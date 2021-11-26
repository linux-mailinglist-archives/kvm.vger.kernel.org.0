Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034CD45EE5D
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237657AbhKZNBd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 08:01:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:38511 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235899AbhKZM7d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:59:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637931379;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Et9E/ithShfXgunEZwY5wgPwrsvEeSfHkQyeQlhEjGc=;
        b=bW2+vSWqpbhp8aL52TvELQi/JWSxPLGagB4ycBxfk9XRIb2eOYvh8Jp9X6KiQMKOEz5xxK
        xM/WMY6qUufYPWQtP77jwIgSndq9PlxOvs8XxmdYpURSqQX/ObceYFkQxBbEauafJSabBc
        NFrgmyhBAafE0CbmlcfR8yvrLrK46vA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-Rkk-tMbMOdeaHgo_W5C-0Q-1; Fri, 26 Nov 2021 07:56:16 -0500
X-MC-Unique: Rkk-tMbMOdeaHgo_W5C-0Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3374080A1A7;
        Fri, 26 Nov 2021 12:56:14 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CB0160BE5;
        Fri, 26 Nov 2021 12:56:04 +0000 (UTC)
Message-ID: <e72acd9e-eb0d-8060-c89e-b8804d0b0305@redhat.com>
Date:   Fri, 26 Nov 2021 13:56:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 11/12] KVM: X86: Check root_level only in
 fast_pgd_switch()
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
 <20211124122055.64424-12-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211124122055.64424-12-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/21 13:20, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> If root_level >= 4, shadow_root_level must be >= 4 too.
> Checking only root_level can reduce a check.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/mmu/mmu.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9fb9927264d8..1dc8bfd12ecd 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4136,8 +4136,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
>   	 * having to deal with PDPTEs. We may add support for 32-bit hosts/VMs
>   	 * later if necessary.
>   	 */
> -	if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
> -	    mmu->root_level >= PT64_ROOT_4LEVEL)
> +	if (mmu->root_level >= PT64_ROOT_4LEVEL)
>   		return cached_root_available(vcpu, new_pgd, new_role);
>   
>   	return false;
> 

Hmm, I think this is more confusing.  I *think* that adding support for 
PAE would be mostly an issue with the guest PDPTRs, and not with the 
shadow PDPTRs, but without thinking more about it I'm leaning towards 
not applying this patch.

Paolo

