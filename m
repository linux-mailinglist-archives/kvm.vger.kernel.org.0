Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE4123A3E65
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 10:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhFKI7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 04:59:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231400AbhFKI7P (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 04:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623401837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z02WQeH8aJ5zwgsjzwCIx8vmkkLdYBfVdFaAFhuyiZE=;
        b=HcipEC0G3B9kcE2IYjEtlZBuqTyxGVAyfr9wV3qukV+Zdw+VYdx4TFqMTQlnUGS9V+m4IA
        u1MHzNHsNQUh+G+zRAxQA8cKIWwDWullM2RdrLNxc4Ya3zcyI7/vmHpmotn6l+mjmJfipT
        qVapOilKzsyBvDhkLPdKAU6VkoI2dZY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-Y_6K6f7tNs68tHO07iyMwg-1; Fri, 11 Jun 2021 04:57:13 -0400
X-MC-Unique: Y_6K6f7tNs68tHO07iyMwg-1
Received: by mail-wm1-f71.google.com with SMTP id o82-20020a1ca5550000b029019ae053d508so4179977wme.6
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 01:57:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Z02WQeH8aJ5zwgsjzwCIx8vmkkLdYBfVdFaAFhuyiZE=;
        b=ln4vQhsKWLR1Xodb10a/0ZAi6kxzqPBpR1T+LULmOM2+1aWAaTZObSu3yVNaaFXr+B
         QZJmETzQL8vr2Iw7tKKherQatTld512GC3kTyOk3xkykWLzC1y060akhApnZ43H5/IkK
         e4lCX+90RptQsHRsHDvU9lca1QoH7igDQX12Uyg4n0yVI2FhIIqxbtnsROa6w8GqCy0k
         g3Vs/k4N4k/vscp7XxDvC8c7zeyE/+NKuEgXWmibYgjsbWWIP/RzwuwOqXTjHggc7f6C
         G0vYe27Ko3Q749ZIbuWjWo3vCXoZOknDhm/x952GNwhis3kEN/BSCxXtP7rBb/osOZUh
         JQ0Q==
X-Gm-Message-State: AOAM531ydkwLlAD3W+/OJtz4w4Ea9If6I9smOPkeSbj7B/mllA2PNTO5
        zFgsqubXvCDswejql+CE4KpWOZyircyh9zn6ez2AfwJEJzMdQ/kkVNaIM04Vphf6mbttqgMQ2Zb
        qTtKXsWrgIdD8
X-Received: by 2002:adf:fa48:: with SMTP id y8mr2814636wrr.387.1623401832642;
        Fri, 11 Jun 2021 01:57:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw0z4NdMZBiLcEyrbPoI45T9t5OFABlmVcxAF9uV5Hq+Rwn1mv/4IM8hDcz5th8gZvKfvo26w==
X-Received: by 2002:adf:fa48:: with SMTP id y8mr2814608wrr.387.1623401832427;
        Fri, 11 Jun 2021 01:57:12 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j131sm12538670wma.40.2021.06.11.01.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 01:57:11 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Calculate and check "full" mmu_role for
 nested MMU
In-Reply-To: <20210610220026.1364486-1-seanjc@google.com>
References: <20210610220026.1364486-1-seanjc@google.com>
Date:   Fri, 11 Jun 2021 10:57:11 +0200
Message-ID: <87bl8cye1k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Calculate and check the full mmu_role when initializing the MMU context
> for the nested MMU, where "full" means the bits and pieces of the role
> that aren't handled by kvm_calc_mmu_role_common().  While the nested MMU
> isn't used for shadow paging, things like the number of levels in the
> guest's page tables are surprisingly important when walking the guest
> page tables.  Failure to reinitialize the nested MMU context if L2's
> paging mode changes can result in unexpected and/or missed page faults,
> and likely other explosions.
>
> E.g. if an L1 vCPU is running both a 32-bit PAE L2 and a 64-bit L2, the
> "common" role calculation will yield the same role for both L2s.  If the
> 64-bit L2 is run after the 32-bit PAE L2, L0 will fail to reinitialize
> the nested MMU context, ultimately resulting in a bad walk of L2's page
> tables as the MMU will still have a guest root_level of PT32E_ROOT_LEVEL.
>
>   WARNING: CPU: 4 PID: 167334 at arch/x86/kvm/vmx/vmx.c:3075 ept_save_pdptrs+0x15/0xe0 [kvm_intel]
>   Modules linked in: kvm_intel]
>   CPU: 4 PID: 167334 Comm: CPU 3/KVM Not tainted 5.13.0-rc1-d849817d5673-reqs #185
>   Hardware name: ASUS Q87M-E/Q87M-E, BIOS 1102 03/03/2014
>   RIP: 0010:ept_save_pdptrs+0x15/0xe0 [kvm_intel]
>   Code: <0f> 0b c3 f6 87 d8 02 00f
>   RSP: 0018:ffffbba702dbba00 EFLAGS: 00010202
>   RAX: 0000000000000011 RBX: 0000000000000002 RCX: ffffffff810a2c08
>   RDX: ffff91d7bc30acc0 RSI: 0000000000000011 RDI: ffff91d7bc30a600
>   RBP: ffff91d7bc30a600 R08: 0000000000000010 R09: 0000000000000007
>   R10: 0000000000000000 R11: 0000000000000000 R12: ffff91d7bc30a600
>   R13: ffff91d7bc30acc0 R14: ffff91d67c123460 R15: 0000000115d7e005
>   FS:  00007fe8e9ffb700(0000) GS:ffff91d90fb00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 0000000000000000 CR3: 000000029f15a001 CR4: 00000000001726e0
>   Call Trace:
>    kvm_pdptr_read+0x3a/0x40 [kvm]
>    paging64_walk_addr_generic+0x327/0x6a0 [kvm]
>    paging64_gva_to_gpa_nested+0x3f/0xb0 [kvm]
>    kvm_fetch_guest_virt+0x4c/0xb0 [kvm]
>    __do_insn_fetch_bytes+0x11a/0x1f0 [kvm]
>    x86_decode_insn+0x787/0x1490 [kvm]
>    x86_decode_emulated_instruction+0x58/0x1e0 [kvm]
>    x86_emulate_instruction+0x122/0x4f0 [kvm]
>    vmx_handle_exit+0x120/0x660 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0xe25/0x1cb0 [kvm]
>    kvm_vcpu_ioctl+0x211/0x5a0 [kvm]
>    __x64_sys_ioctl+0x83/0xb0
>    do_syscall_64+0x40/0xb0
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: bf627a928837 ("x86/kvm/mmu: check if MMU reconfiguration is needed in init_kvm_nested_mmu()")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0144c40d09c7..8d5876dfc6b7 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4739,9 +4739,33 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
>  	context->inject_page_fault = kvm_inject_page_fault;
>  }
>  
> +static union kvm_mmu_role kvm_calc_nested_mmu_role(struct kvm_vcpu *vcpu)
> +{
> +	union kvm_mmu_role role = kvm_calc_shadow_root_page_role_common(vcpu, false);
> +
> +	/*
> +	 * Nested MMUs are used only for walking L2's gva->gpa, they never have
> +	 * shadow pages of their own and so "direct" has no meaning.   Set it
> +	 * to "true" to try to detect bogus usage of the nested MMU.
> +	 */
> +	role.base.direct = true;
> +
> +	if (!is_paging(vcpu))
> +		role.base.level = 0;
> +	else if (is_long_mode(vcpu))
> +		role.base.level = is_la57_mode(vcpu) ? PT64_ROOT_5LEVEL :
> +						       PT64_ROOT_4LEVEL;
> +	else if (is_pae(vcpu))
> +		role.base.level = PT32E_ROOT_LEVEL;
> +	else
> +		role.base.level = PT32_ROOT_LEVEL;
> +
> +	return role;
> +}
> +
>  static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
>  {
> -	union kvm_mmu_role new_role = kvm_calc_mmu_role_common(vcpu, false);
> +	union kvm_mmu_role new_role = kvm_calc_nested_mmu_role(vcpu);
>  	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
>  
>  	if (new_role.as_u64 == g_context->mmu_role.as_u64)

Oh, I see. Cautiously:

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

What I don't quite like (besides the fact that this 'nested_mmu' exists
but I don't see an elegant way to get rid of it) is the fact that we now
have the same logic to compute 'level' both in
kvm_calc_nested_mmu_role() and init_kvm_nested_mmu(). We could've
avoided that by re-aranging code in init_kvm_nested_mmu() I
guess. Something like (untested):

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..3b1d1c5016c9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4741,22 +4741,12 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 {
-	union kvm_mmu_role new_role = kvm_calc_mmu_role_common(vcpu, false);
+	union kvm_mmu_role new_role = kvm_calc_shadow_root_page_role_common(vcpu, false);
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
-
-	if (new_role.as_u64 == g_context->mmu_role.as_u64)
-		return;
-
-	g_context->mmu_role.as_u64 = new_role.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
-	g_context->get_pdptr         = kvm_pdptr_read;
-	g_context->inject_page_fault = kvm_inject_page_fault;
-
-	/*
-	 * L2 page tables are never shadowed, so there is no need to sync
-	 * SPTEs.
-	 */
-	g_context->invlpg            = NULL;
+	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t gva_or_gpa,
+                            u32 access, struct x86_exception *exception);
+	int root_level;
+	bool nx;
 
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
@@ -4767,27 +4757,45 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 	 * the gva_to_gpa functions between mmu and nested_mmu are swapped.
 	 */
 	if (!is_paging(vcpu)) {
-		g_context->nx = false;
-		g_context->root_level = 0;
-		g_context->gva_to_gpa = nonpaging_gva_to_gpa_nested;
+		nx = false;
+		root_level = 0;
+		gva_to_gpa = nonpaging_gva_to_gpa_nested;
 	} else if (is_long_mode(vcpu)) {
-		g_context->nx = is_nx(vcpu);
-		g_context->root_level = is_la57_mode(vcpu) ?
-					PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
-		reset_rsvds_bits_mask(vcpu, g_context);
-		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+		nx = is_nx(vcpu);
+		root_level = is_la57_mode(vcpu) ?
+			PT64_ROOT_5LEVEL : PT64_ROOT_4LEVEL;
+		gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else if (is_pae(vcpu)) {
-		g_context->nx = is_nx(vcpu);
-		g_context->root_level = PT32E_ROOT_LEVEL;
-		reset_rsvds_bits_mask(vcpu, g_context);
-		g_context->gva_to_gpa = paging64_gva_to_gpa_nested;
+		nx = is_nx(vcpu);
+		root_level = PT32E_ROOT_LEVEL;
+		gva_to_gpa = paging64_gva_to_gpa_nested;
 	} else {
-		g_context->nx = false;
-		g_context->root_level = PT32_ROOT_LEVEL;
-		reset_rsvds_bits_mask(vcpu, g_context);
-		g_context->gva_to_gpa = paging32_gva_to_gpa_nested;
+		nx = false;
+		root_level = PT32_ROOT_LEVEL;
+		gva_to_gpa = paging32_gva_to_gpa_nested;
 	}
 
+	if ((new_role.as_u64 == g_context->mmu_role.as_u64) &&
+	    (root_level == g_context->root_level))
+		return;
+
+	g_context->nx = nx;
+	g_context->root_level = root_level;
+	g_context->gva_to_gpa = gva_to_gpa;
+	if (root_level)
+		reset_rsvds_bits_mask(vcpu, g_context);
+
+	g_context->mmu_role.as_u64 = new_role.as_u64;
+	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_pdptr         = kvm_pdptr_read;
+	g_context->inject_page_fault = kvm_inject_page_fault;
+
+	/*
+	 * L2 page tables are never shadowed, so there is no need to sync
+	 * SPTEs.
+	 */
+	g_context->invlpg            = NULL;
+
 	update_permission_bitmask(vcpu, g_context, false);
 	update_pkru_bitmask(vcpu, g_context, false);
 	update_last_nonleaf_level(vcpu, g_context);


-- 
Vitaly

