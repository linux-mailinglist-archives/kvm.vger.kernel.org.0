Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86D6400E87
	for <lists+kvm@lfdr.de>; Sun,  5 Sep 2021 09:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhIEHOO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 Sep 2021 03:14:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230076AbhIEHOF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 5 Sep 2021 03:14:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630825981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5NXjMtIKegV5Bnld7xmlh2BI3wqQcMyh0+qVZHk8Jl4=;
        b=UZDL9P88jBxJk6wKxJMXA4Hka08XMHLttYFETQx97eUI4lBNyH2r4hZ/Z4XcGwMzCpvT6W
        etrt1eua4VQWETqU3vO3FHx5lsboy0vE93AyBCRZWORdDcMv7wFHp86ZoMS836TFdaQF85
        fYWurh2guBd9LgDKCaXOZ+cgHNjiLSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-erxbHYjoOxuNhJcYFlDhCA-1; Sun, 05 Sep 2021 03:13:00 -0400
X-MC-Unique: erxbHYjoOxuNhJcYFlDhCA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6322180FD8C;
        Sun,  5 Sep 2021 07:12:59 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7955669CAD;
        Sun,  5 Sep 2021 07:12:58 +0000 (UTC)
Message-ID: <f539e833bd7da4800612f8ae4bdffcb1db2f8684.camel@redhat.com>
Subject: Re: [PATCH] KVM: Remove unnecessary export of
 kvm_{inc,dec}_notifier_count()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sun, 05 Sep 2021 10:12:57 +0300
In-Reply-To: <20210902175951.1387989-1-seanjc@google.com>
References: <20210902175951.1387989-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-09-02 at 10:59 -0700, Sean Christopherson wrote:
> Don't export KVM's MMU notifier count helpers, under no circumstance
> should any downstream module, including x86's vendor code, have a
> legitimate reason to piggyback KVM's MMU notifier logic.  E.g in the x86
> case, only KVM's MMU should be elevating the notifier count, and that
> code is always built into the core kvm.ko module.
> 
> Fixes: edb298c663fc ("KVM: x86/mmu: bump mmu notifier count in kvm_zap_gfn_range")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3e67c93ca403..140c7d311021 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -638,7 +638,6 @@ void kvm_inc_notifier_count(struct kvm *kvm, unsigned long start,
>  			max(kvm->mmu_notifier_range_end, end);
>  	}
>  }
> -EXPORT_SYMBOL_GPL(kvm_inc_notifier_count);
>  
>  static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
>  					const struct mmu_notifier_range *range)
> @@ -690,8 +689,6 @@ void kvm_dec_notifier_count(struct kvm *kvm, unsigned long start,
>  	 */
>  	kvm->mmu_notifier_count--;
>  }
> -EXPORT_SYMBOL_GPL(kvm_dec_notifier_count);
> -
>  
>  static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
>  					const struct mmu_notifier_range *range)

Ah, I somehow thought when I wrote this that those two will be used by kvm_amd.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

