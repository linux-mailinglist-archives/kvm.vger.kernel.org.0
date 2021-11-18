Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82CA84559EA
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 12:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343925AbhKRLR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 06:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44812 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343937AbhKRLPx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 06:15:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637233973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6s+jojSZwmq72+IQvZdx+Y5ACBLKuCbcPrfvFOGprY=;
        b=NJTwBLhNxU7Ujt7stv+X7uYI3b1JPTGgiMB4b53w3Y1avzb+4mLSAbKbntHOOyv1s8i65Y
        oZp7D/1IeVqOf/TrB6ImqmmKR0fXV9tf2FMXVAquPxdCUqIjgs1aHod8ktpTjv8qFY8LGa
        +TPUnyoDWodSwqNidMHF7KYLGSdTCr8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-7wYCfhRwMX2pjdADGc2Eig-1; Thu, 18 Nov 2021 06:12:49 -0500
X-MC-Unique: 7wYCfhRwMX2pjdADGc2Eig-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 764EE824F89;
        Thu, 18 Nov 2021 11:12:47 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A47A5F4EF;
        Thu, 18 Nov 2021 11:12:40 +0000 (UTC)
Message-ID: <16b701db-e277-c4ef-e198-65a2dc6e3fdf@redhat.com>
Date:   Thu, 18 Nov 2021 12:12:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/15] KVM: X86: Always set gpte_is_8_bytes when direct
 map
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-16-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118110814.2568-16-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 12:08, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> When direct map, gpte_is_8_bytes has no meaning, but it is true for all
> other cases except direct map when nonpaping.
> 
> Setting gpte_is_8_bytes to true when nonpaping can ensure that
> !gpte_is_8_bytes means 32-bit gptes for shadow paging.

Then the right thing to do would be to rename it to has_4_byte_gptes and 
invert the direction.  But as things stand, it's a bit more confusing to 
make gpte_is_8_bytes=1 if there are no guest PTEs at all.

Paolo

> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   Documentation/virt/kvm/mmu.rst | 2 +-
>   arch/x86/kvm/mmu/mmu.c         | 4 ++--
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
> index f60f5488e121..5d1086602759 100644
> --- a/Documentation/virt/kvm/mmu.rst
> +++ b/Documentation/virt/kvm/mmu.rst
> @@ -179,7 +179,7 @@ Shadow pages contain the following information:
>       unpinned it will be destroyed.
>     role.gpte_is_8_bytes:
>       Reflects the size of the guest PTE for which the page is valid, i.e. '1'
> -    if 64-bit gptes are in use, '0' if 32-bit gptes are in use.
> +    if direct map or 64-bit gptes are in use, '0' if 32-bit gptes are in use.
>     role.efer_nx:
>       Contains the value of efer.nx for which the page is valid.
>     role.cr0_wp:
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 6948f2d696c3..0c92cbc07320 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2083,7 +2083,7 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   	role.level = level;
>   	role.direct = direct;
>   	role.access = access;
> -	if (!direct_mmu && !role.gpte_is_8_bytes) {
> +	if (!role.gpte_is_8_bytes) {
>   		quadrant = gaddr >> (PAGE_SHIFT + (PT64_PT_BITS * level));
>   		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
>   		role.quadrant = quadrant;
> @@ -4777,7 +4777,7 @@ kvm_calc_shadow_root_page_role_common(struct kvm_vcpu *vcpu,
>   
>   	role.base.smep_andnot_wp = role.ext.cr4_smep && !____is_cr0_wp(regs);
>   	role.base.smap_andnot_wp = role.ext.cr4_smap && !____is_cr0_wp(regs);
> -	role.base.gpte_is_8_bytes = ____is_cr0_pg(regs) && ____is_cr4_pae(regs);
> +	role.base.gpte_is_8_bytes = !____is_cr0_pg(regs) || ____is_cr4_pae(regs);
>   
>   	return role;
>   }
> 

