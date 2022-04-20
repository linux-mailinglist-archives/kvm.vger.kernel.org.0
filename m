Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13951508E39
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381008AbiDTRSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381087AbiDTRRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:17:55 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7346462E0;
        Wed, 20 Apr 2022 10:15:08 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q3so3172639wrj.7;
        Wed, 20 Apr 2022 10:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VVE40BH1GRcbe/2Tu0Z62ouo5J9RFF1pHt0E7xPlfvg=;
        b=IQnt/x4OcHX5HZ7mUhDc2ms9QVGAIqV2zbzFjSl/BZga+POXGprc8jAVcP4WSBn8q1
         oC5hUbE3f6l+Jzzr4sdV/Ymci9y5RbyiL52HGSuNgpV7j/y/XnAboHJWcXFj0fwpyy5z
         eKPgBZNNG1V9twCmthvzdlKMf/41DMP3YWUrS27NcX/bJjIGToW3XSjaok/cXdGPspeg
         R09YACy8sr9p/VlWOoLOAb0nJCMZr88milhj4Buqymnm70moyTHwgrKh6FfcIAk7xXVc
         c3eTLSsYRjlm5bvxLmhF6M/j1C7egViWY+e0l/dsHfkJ0AI3vSU4nwTHJIju/5UlMNvR
         aXtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VVE40BH1GRcbe/2Tu0Z62ouo5J9RFF1pHt0E7xPlfvg=;
        b=XeOOh43XbTo9f3+uMfCEgTgnmKzX+/Mm8Odplop0INAFFzZKj9mxx2X7mn2VomkyRI
         MB4HakiViqVkGiRDC7552mvVUplatNyaAqEOHxgdfyPUaTTwUthNid6VcP1Ircdi0YSI
         H2djVwcct/UEh5k6XSx7imYikxKPWAt8A0Wxxu6txCU1zXEBgmqyZE5q6CdQ4h5rk/Se
         sKzpOQHG7bJWpbN0TDvv+LpxNloVYVOQG/pzase8A/GnMnDZtHB5rtFkMlD7VnA8cybP
         LVACel5qFI6GfvY/kjLZn9WJoh27xqXpL+W9kxaQ/Oq2eYjnYhVb29QSNskRJNCR7n84
         XNbQ==
X-Gm-Message-State: AOAM533iEC8KTT0qpgY4wNUmpgicgYu1NWAWoYPOyddetAmP168g8Vv1
        L9T1eENU3VfzhzXIb0QqzWg=
X-Google-Smtp-Source: ABdhPJxIWxnjYPQvPY4VWEEwaTL7CTlMNmYuFQRH2BJ3aMaZWK7/tlKRUWXIe4rCjz+bb1//4bh1qA==
X-Received: by 2002:adf:f943:0:b0:203:e832:129 with SMTP id q3-20020adff943000000b00203e8320129mr16151390wrr.626.1650474906913;
        Wed, 20 Apr 2022 10:15:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l6-20020a1c2506000000b0038e6fe8e8d8sm398575wml.5.2022.04.20.10.15.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 10:15:06 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <3e6018ad-06b7-f465-7b74-aeb20bca9489@redhat.com>
Date:   Wed, 20 Apr 2022 19:15:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 2/2] KVM: X86/MMU: Introduce role.passthrough for
 shadowing 5-level NPT for 4-level NPT L1 guest
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-doc@vger.kernel.org
References: <20220420131204.2850-1-jiangshanlai@gmail.com>
 <20220420131204.2850-3-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220420131204.2850-3-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/20/22 15:12, Lai Jiangshan wrote:
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> 
> When shadowing 5-level NPT for 4-level NPT L1 guest, the root_sp is
> allocated with role.level = 5 and the guest pagetable's root gfn.
> 
> And root_sp->spt[0] is also allocated with the same gfn and the same
> role except role.level = 4.  Luckily that they are different shadow
> pages, but only root_sp->spt[0] is the real translation of the guest
> pagetable.
> 
> Here comes a problem:
> 
> If the guest switches from gCR4_LA57=0 to gCR4_LA57=1 (or vice verse)
> and uses the same gfn as the root page for nested NPT before and after
> switching gCR4_LA57.  The host (hCR4_LA57=1) might use the same root_sp
> for the guest even the guest switches gCR4_LA57.  The guest will see
> unexpected page mapped and L2 may exploit the bug and hurt L1.  It is
> lucky that the problem can't hurt L0.
> 
> And three special cases need to be handled:
> 
> The root_sp should be like role.direct=1 sometimes: its contents are
> not backed by gptes, root_sp->gfns is meaningless.  (For a normal high
> level sp in shadow paging, sp->gfns is often unused and kept zero, but
> it could be relevant and meaningful if sp->gfns is used because they
> are backed by concrete gptes.)
> 
> For such root_sp in the case, root_sp is just a portal to contribute
> root_sp->spt[0], and root_sp->gfns should not be used and
> root_sp->spt[0] should not be dropped if gpte[0] of the guest root
> pagetable is changed.
> 
> Such root_sp should not be accounted too.
> 
> So add role.passthrough to distinguish the shadow pages in the hash
> when gCR4_LA57 is toggled and fix above special cases by using it in
> kvm_mmu_page_{get|set}_gfn() and sp_has_gptes().
> 
> Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Looks good, and is easy to backport; thanks.

However, once we have also your series "KVM: X86/MMU: Use one-off 
special shadow page for special roots", perhaps the passthrough sp can 
be converted to a special root (but now with a shadow_page) as well?

Paolo

> ---
>   Documentation/virt/kvm/mmu.rst  |  3 +++
>   arch/x86/include/asm/kvm_host.h |  5 +++--
>   arch/x86/kvm/mmu/mmu.c          | 16 ++++++++++++++++
>   arch/x86/kvm/mmu/paging_tmpl.h  |  1 +
>   4 files changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
> index 5b1ebad24c77..4018b9d7a0d3 100644
> --- a/Documentation/virt/kvm/mmu.rst
> +++ b/Documentation/virt/kvm/mmu.rst
> @@ -202,6 +202,9 @@ Shadow pages contain the following information:
>       Is 1 if the MMU instance cannot use A/D bits.  EPT did not have A/D
>       bits before Haswell; shadow EPT page tables also cannot use A/D bits
>       if the L1 hypervisor does not enable them.
> +  role.passthrough:
> +    Is 1 if role.level = 5 when shadowing 5-level shadow NPT for
> +    4-level NPT L1.
>     gfn:
>       Either the guest page table containing the translations shadowed by this
>       page, or the base page frame for linear translations.  See role.direct.
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9694dd5e6ccc..d4f8f4784d87 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -285,7 +285,7 @@ struct kvm_kernel_irq_routing_entry;
>    * minimize the size of kvm_memory_slot.arch.gfn_track, i.e. allows allocating
>    * 2 bytes per gfn instead of 4 bytes per gfn.
>    *
> - * Indirect upper-level shadow pages are tracked for write-protection via
> + * Upper-level shadow pages having gptes are tracked for write-protection via
>    * gfn_track.  As above, gfn_track is a 16 bit counter, so KVM must not create
>    * more than 2^16-1 upper-level shadow pages at a single gfn, otherwise
>    * gfn_track will overflow and explosions will ensure.
> @@ -331,7 +331,8 @@ union kvm_mmu_page_role {
>   		unsigned smap_andnot_wp:1;
>   		unsigned ad_disabled:1;
>   		unsigned guest_mode:1;
> -		unsigned :6;
> +		unsigned passthrough:1;
> +		unsigned :5;
>   
>   		/*
>   		 * This is left at the top of the word so that
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 1bdff55218ef..d14cb6f99cb1 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -737,6 +737,9 @@ static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
>   
>   static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>   {
> +	if (sp->role.passthrough)
> +		return sp->gfn;
> +
>   	if (!sp->role.direct)
>   		return sp->gfns[index];
>   
> @@ -745,6 +748,11 @@ static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index)
>   
>   static void kvm_mmu_page_set_gfn(struct kvm_mmu_page *sp, int index, gfn_t gfn)
>   {
> +	if (sp->role.passthrough) {
> +		WARN_ON_ONCE(gfn != sp->gfn);
> +		return;
> +	}
> +
>   	if (!sp->role.direct) {
>   		sp->gfns[index] = gfn;
>   		return;
> @@ -1861,6 +1869,9 @@ static bool sp_has_gptes(struct kvm_mmu_page *sp)
>   	if (sp->role.direct)
>   		return false;
>   
> +	if (sp->role.passthrough)
> +		return false;
> +
>   	return true;
>   }
>   
> @@ -2059,6 +2070,8 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
>   		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
>   		role.quadrant = quadrant;
>   	}
> +	if (level <= vcpu->arch.mmu->root_level)
> +		role.passthrough = 0;
>   
>   	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
>   	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
> @@ -4890,6 +4903,9 @@ kvm_calc_shadow_npt_root_page_role(struct kvm_vcpu *vcpu,
>   
>   	role.base.direct = false;
>   	role.base.level = kvm_mmu_get_tdp_level(vcpu);
> +	if (role.base.level == PT64_ROOT_5LEVEL &&
> +	    role_regs_to_root_level(regs) == PT64_ROOT_4LEVEL)
> +		role.base.passthrough = 1;
>   
>   	return role;
>   }
> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> index 8621188b46df..c1b975fb85a2 100644
> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> @@ -1042,6 +1042,7 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>   		.level = 0xf,
>   		.access = 0x7,
>   		.quadrant = 0x3,
> +		.passthrough = 0x1,
>   	};
>   
>   	/*

