Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7537235EE
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 05:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233491AbjFFDyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 23:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbjFFDxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 23:53:48 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A29187;
        Mon,  5 Jun 2023 20:53:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-977d3292be0so62873566b.1;
        Mon, 05 Jun 2023 20:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686023620; x=1688615620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNV4hm8Cg6o2Z3bZJuHBg+kQzEfziibVmxhyt0BUqa4=;
        b=lxRu0ZJMrUvgo3Jksgkb7odvukpJqoiTpfzxHuwQaoM6lqfUN+VPMNzALVNFfCbDbE
         95oxc1WMxuZfV3SLJX1TLsfxV56zDh6Crvonvb8xxazEk2ZYbRBVDDzgSf2FtJsOHuin
         oNH7yaU+qQlWa5P4UlY1NQX+P1L60ovIt5MUPDZjW7nOgidMMvLyTmeU8A2rC8+VYnAh
         kO9Odqof7RPLKtqirdUzcJwbAQnWjiWVSNdh0lbS9Gl11V7l2ordxz66fkekEbDl5bZL
         v0KZQ8bO1GGU0R1uKf3CZhf5EJHfwgDuww4VpDVCWTK90wjDkFZ2kCw8WXa3JnTeF/mN
         2IFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686023620; x=1688615620;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KNV4hm8Cg6o2Z3bZJuHBg+kQzEfziibVmxhyt0BUqa4=;
        b=NW0Dp9Aj2ni5hc83aKP45o7PNll3HEq+K5MIBMGOYG+sh2OLGLL4FQ4rXwmlwGeaZi
         vy/tdiEf1PcfbVr+F5ZpyYlZtnoEX82YaXYal08LretV0klVGYmgm/Lw0TdU6HLFEeoy
         ck/govDrfUvwJz86RzOPu6YN3SjfXH/0Ve2GzsNq7XC3KBZany7Bhpr3uZBSfX5czZm7
         WhDeTHsuNbY9s2W6Tuzxch6urQPnA97NjkwunBEhHfqAIl3yJwb4JQqgJLN3EArcGC7j
         PNcg4j1tjE7nEp2I6Ws8KTXIB1a69Jep6Hpa8vqHDEMkWKRmPPCApKfY2Q6M1Z6FAGn5
         EJ5A==
X-Gm-Message-State: AC+VfDznTYh0bsn4uiqSHueOagpCoFOhitGKnKDf6qW21S6FW5Vpywbr
        FfVU1HcBGl+g40bkcdm+7RQ=
X-Google-Smtp-Source: ACHHUZ6juUEN7cbzeA0ALvj+vq8aZuq1oL7NtDIkgFEdz+ZVHi65ozazHiTGz+UIKp30UK4UPZtPTw==
X-Received: by 2002:a17:906:64de:b0:977:b21d:7d8c with SMTP id p30-20020a17090664de00b00977b21d7d8cmr1078666ejn.6.1686023619451;
        Mon, 05 Jun 2023 20:53:39 -0700 (PDT)
Received: from localhost ([134.191.220.81])
        by smtp.gmail.com with ESMTPSA id o6-20020a170906860600b00977d280f83bsm2599249ejx.215.2023.06.05.20.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 20:53:39 -0700 (PDT)
Date:   Tue, 6 Jun 2023 11:53:24 +0800
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        H Peter Anvin <hpa@zytor.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 3/6] KVM: VMX: Add new ops in kvm_x86_ops for LASS
 violation check
Message-ID: <20230606115324.00004a51.zhi.wang.linux@gmail.com>
In-Reply-To: <c60f77df-4d29-f063-ba75-ce7dd818b2fb@linux.intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
        <20230601142309.6307-4-guang.zeng@intel.com>
        <3b3d9106-9e4f-8a76-30ee-29540b06022a@linux.intel.com>
        <20230605205342.00000e41.zhi.wang.linux@gmail.com>
        <c60f77df-4d29-f063-ba75-ce7dd818b2fb@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 6 Jun 2023 10:57:23 +0800
Binbin Wu <binbin.wu@linux.intel.com> wrote:

>=20
>=20
> On 6/5/2023 8:53 PM, Zhi Wang wrote:
> > On Mon, 5 Jun 2023 11:31:48 +0800
> > Binbin Wu <binbin.wu@linux.intel.com> wrote:
> >
> >>
> >> On 6/1/2023 10:23 PM, Zeng Guang wrote:
> >>> Intel introduces LASS (Linear Address Separation) feature providing
> >>   =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 ^
> >>   =A0missing "Space" here
> >>> an independent mechanism to achieve the mode-based protection.
> >>>
> >>> LASS partitions 64-bit linear address space into two halves, user-mode
> >>> address (LA[bit 63]=3D0) and supervisor-mode address (LA[bit 63]=3D1)=
. It
> >>> stops any code execution or conditional data access[1]
> >>>       1. from user mode to supervisor-mode address space
> >>>       2. from supervisor mode to user-mode address space
> >>> and generates LASS violation fault accordingly.
> >>>
> >>> [1]A supervisor mode data access causes a LASS violation only if supe=
rvisor
> >>> mode access protection is enabled (CR4.SMAP =3D 1) and either RFLAGS.=
AC =3D 0
> >>> or the access implicitly accesses a system data structure.
> >>>
> >>> Following are the rules of LASS violation check on the linear address=
(LA).
> >>> User access to supervisor-mode address space:
> >>>       LA[bit 63] && (CPL =3D=3D 3)
> >>> Supervisor access to user-mode address space:
> >>>       Instruction fetch: !LA[bit 63] && (CPL < 3)
> >>>       Data access: !LA[bit 63] && (CR4.SMAP=3D=3D1) && ((RFLAGS.AC =
=3D=3D 0 &&
> >>>                    CPL < 3) || Implicit supervisor access)
> >>>
> >>> Add new ops in kvm_x86_ops to do LASS violation check.
> >>>
> >>> Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> >>> Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> >>> ---
> >>>    arch/x86/include/asm/kvm-x86-ops.h |  3 +-
> >>>    arch/x86/include/asm/kvm_host.h    |  2 ++
> >>>    arch/x86/kvm/kvm_emulate.h         |  1 +
> >>>    arch/x86/kvm/vmx/vmx.c             | 47 ++++++++++++++++++++++++++=
++++
> >>>    arch/x86/kvm/vmx/vmx.h             |  2 ++
> >>>    5 files changed, 54 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/as=
m/kvm-x86-ops.h
> >>> index 13bc212cd4bc..8980a3bfa687 100644
> >>> --- a/arch/x86/include/asm/kvm-x86-ops.h
> >>> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> >>> @@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
> >>>    KVM_X86_OP(msr_filter_changed)
> >>>    KVM_X86_OP(complete_emulated_msr)
> >>>    KVM_X86_OP(vcpu_deliver_sipi_vector)
> >>> -KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> >>> +KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
> >>> +KVM_X86_OP_OPTIONAL_RET0(check_lass)
> >>>   =20
> >>>    #undef KVM_X86_OP
> >>>    #undef KVM_X86_OP_OPTIONAL
> >>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/k=
vm_host.h
> >>> index 92d8e65fe88c..98666d1e7727 100644
> >>> --- a/arch/x86/include/asm/kvm_host.h
> >>> +++ b/arch/x86/include/asm/kvm_host.h
> >>> @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> >>>    	 * Returns vCPU specific APICv inhibit reasons
> >>>    	 */
> >>>    	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *=
vcpu);
> >>> +
> >>> +	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 f=
lags);
> >>>    };
> >>>   =20
> >>>    struct kvm_x86_nested_ops {
> >>> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> >>> index 5b9ec610b2cb..f1439ab7c14b 100644
> >>> --- a/arch/x86/kvm/kvm_emulate.h
> >>> +++ b/arch/x86/kvm/kvm_emulate.h
> >>> @@ -91,6 +91,7 @@ struct x86_instruction_info {
> >>>    /* x86-specific emulation flags */
> >>>    #define X86EMUL_F_FETCH			BIT(0)
> >>>    #define X86EMUL_F_WRITE			BIT(1)
> >>> +#define X86EMUL_F_SKIPLASS		BIT(2)
> >>>   =20
> >>>    struct x86_emulate_ops {
> >>>    	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
> >>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >>> index a33205ded85c..876997e8448e 100644
> >>> --- a/arch/x86/kvm/vmx/vmx.c
> >>> +++ b/arch/x86/kvm/vmx/vmx.c
> >>> @@ -8130,6 +8130,51 @@ static void vmx_vm_destroy(struct kvm *kvm)
> >>>    	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_o=
rder(kvm));
> >>>    }
> >>>   =20
> >>> +/*
> >>> + * Determine whether an access to the linear address causes a LASS v=
iolation.
> >>> + * LASS protection is only effective in long mode. As a prerequisite=
, caller
> >>> + * should make sure vCPU running in long mode and invoke this api to=
 do LASS
> >>> + * violation check.
> >>> + */
> >>> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 f=
lags)
> >>> +{
> >>> +	bool user_mode, user_as, rflags_ac;
> >>> +
> >>> +	if (!!(flags & X86EMUL_F_SKIPLASS) ||
> >>> +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
> >>> +		return false;
> >>> +
> >>> +	WARN_ON_ONCE(!is_long_mode(vcpu));
> >> IMHO, it's better to skip the following checks and return false if it =
is
> >> out of long mode.
> >>
> > The check of long mode is in the caller implemented in in the next patc=
h. :)
> >
> > +	if (!is_long_mode(vcpu))
> > +		return false;
> I know the callers have checked the mode, however, IMHO, it's better as=20
> following:
>=20
> +	if (!!(flags & X86EMUL_F_SKIPLASS) ||
> +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS) || WARN_ON_ONCE(!is_long_mo=
de(vcpu)))
> +		return false;
>
Uh. I see. LGTM.=20
>=20
>=20
> >>> +
> >>> +	user_as =3D !(la >> 63);
> >> It's better to describe how LASS treat linear address in compatibility
> >> mode in changelog or/and in comment,
> >> i.e. for a linear address with only 32 bits (or 16 bits), the processor
> >> treats bit 63 as if it were 0.
> >>
> >>
> >>> +
> >>> +	/*
> >>> +	 * An access is a supervisor-mode access if CPL < 3 or if it implic=
itly
> >>> +	 * accesses a system data structure. For implicit accesses to system
> >>> +	 * data structure, the processor acts as if RFLAGS.AC is clear.
> >>> +	 */
> >>> +	if (access & PFERR_IMPLICIT_ACCESS) {
> >>> +		user_mode =3D false;
> >>> +		rflags_ac =3D false;
> >>> +	} else {
> >>> +		user_mode =3D vmx_get_cpl(vcpu) =3D=3D 3;
> >>> +		if (!user_mode)
> >>> +			rflags_ac =3D !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
> >>> +	}
> >>> +
> >>> +	if (user_mode =3D=3D user_as)
> >>> +		return false;
> >>> +
> >>> +	/*
> >>> +	 * Supervisor-mode _data_ accesses to user address space
> >>> +	 * cause LASS violations only if SMAP is enabled.
> >>> +	 */
> >>> +	if (!user_mode && !(access & PFERR_FETCH_MASK))
> >>> +		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;
> >>> +
> >>> +	return true;
> >>> +}
> >>> +
> >>>    static struct kvm_x86_ops vmx_x86_ops __initdata =3D {
> >>>    	.name =3D KBUILD_MODNAME,
> >>>   =20
> >>> @@ -8269,6 +8314,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdat=
a =3D {
> >>>    	.complete_emulated_msr =3D kvm_complete_insn_gp,
> >>>   =20
> >>>    	.vcpu_deliver_sipi_vector =3D kvm_vcpu_deliver_sipi_vector,
> >>> +
> >>> +	.check_lass =3D vmx_check_lass,
> >>>    };
> >>>   =20
> >>>    static unsigned int vmx_handle_intel_pt_intr(void)
> >>> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> >>> index 9e66531861cf..f2e775b9849b 100644
> >>> --- a/arch/x86/kvm/vmx/vmx.h
> >>> +++ b/arch/x86/kvm/vmx/vmx.h
> >>> @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu=
 *vcpu, u32 msr, int type);
> >>>    u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
> >>>    u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> >>>   =20
> >>> +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 f=
lags);
> >>> +
> >>>    static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu=
, u32 msr,
> >>>    					     int type, bool value)
> >>>    {
>=20

