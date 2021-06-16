Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B473AA3B6
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 21:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbhFPTEL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 15:04:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35592 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232025AbhFPTEK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Jun 2021 15:04:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623870123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RLkAGByXY0zUpu2RkDB2e3cU603Rpn9/oplrhU5cYHE=;
        b=U9eNRiWEbU8g0Zo1CWBy0iYPc66re9S1YgM4UKlJiBvUUJ1eiJxtpvYcoUHYBtgd1SINmK
        QQtjO//5Zhd6IL77mp1EpW8Uq0zZdLCBm3z2eIgrSw8l/1iufOOCKvbC6fJIDGj5R/+14Z
        ZQdvD0I/I6uX1x0fy5wmje2++XNYPFo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-loLHccfmPXiQ0F_AJi5uew-1; Wed, 16 Jun 2021 15:02:02 -0400
X-MC-Unique: loLHccfmPXiQ0F_AJi5uew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3878580364C;
        Wed, 16 Jun 2021 19:02:01 +0000 (UTC)
Received: from starship (unknown [10.40.194.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D743F61145;
        Wed, 16 Jun 2021 19:01:58 +0000 (UTC)
Message-ID: <83be37371a61efa72c4364f1dc9a26d19750d8cc.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Grab nx_lpage_splits as an unsigned long
 before division
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 16 Jun 2021 22:01:57 +0300
In-Reply-To: <20210615162905.2132937-1-seanjc@google.com>
References: <20210615162905.2132937-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-06-15 at 09:29 -0700, Sean Christopherson wrote:
> Snapshot kvm->stats.nx_lpage_splits into a local unsigned long to avoid
> 64-bit division on 32-bit kernels.  Casting to an unsigned long is safe
> because the maximum number of shadow pages, n_max_mmu_pages, is also an
> unsigned long, i.e. KVM will start recycling shadow pages before the
> number of splits can exceed a 32-bit value.
> 
>   ERROR: modpost: "__udivdi3" [arch/x86/kvm/kvm.ko] undefined!
> 
> Fixes: 7ee093d4f3f5 ("KVM: switch per-VM stats to u64")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 720ceb0a1f5c..7d3e57678d34 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6043,6 +6043,7 @@ static int set_nx_huge_pages_recovery_ratio(const char *val, const struct kernel
>  
>  static void kvm_recover_nx_lpages(struct kvm *kvm)
>  {
> +	unsigned long nx_lpage_splits = kvm->stat.nx_lpage_splits;
>  	int rcu_idx;
>  	struct kvm_mmu_page *sp;
>  	unsigned int ratio;
> @@ -6054,7 +6055,7 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
>  	write_lock(&kvm->mmu_lock);
>  
>  	ratio = READ_ONCE(nx_huge_pages_recovery_ratio);
> -	to_zap = ratio ? DIV_ROUND_UP(kvm->stat.nx_lpage_splits, ratio) : 0;
> +	to_zap = ratio ? DIV_ROUND_UP(nx_lpage_splits, ratio) : 0;
>  	for ( ; to_zap; --to_zap) {
>  		if (list_empty(&kvm->arch.lpage_disallowed_mmu_pages))
>  			break;
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

