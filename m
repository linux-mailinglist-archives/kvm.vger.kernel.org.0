Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4603722669
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233523AbjFEMyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233452AbjFEMyE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:54:04 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5863EA1;
        Mon,  5 Jun 2023 05:54:01 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-977fae250easo5889666b.1;
        Mon, 05 Jun 2023 05:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685969640; x=1688561640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KzPCNkAV8qDQrMk6ufehDtxGAXb1czA1SgsO+wfzRYA=;
        b=rSGZWxgYqmvS0d6q2X2AJVbs0La7jVbFc+2magSPiCOum8/XkVU5BI9dWKu1SFacA+
         2xjYcYXBbUZqaIB5ZsxO+T98LbIKIne8Ld4Zz538Xe7HGzvjJEWlmcTN6FW0hHkv9ezM
         id0A3q4XYZnmTIpRRcIBTvIYuXKOk59iY/k9SsMCledx6qxmO5021CvUx1BFPFmM6duV
         dxvB3yigQPIo1CG/1E5FxbNfI2fyddFyPGn1WQJjpQpOeTV4KDMVbRneFD/cTFaBL3Bh
         uaDziYeFyfX78dDCEyVGkassr5+9hWKnkCn7WBGmzM94JyZJlThi/dhi/eEmA8IxYAcM
         +jmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685969640; x=1688561640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzPCNkAV8qDQrMk6ufehDtxGAXb1czA1SgsO+wfzRYA=;
        b=F6mjC2GFfSdStX8wnQ0O1RmIbZfMXS43wRXOU9NXUInFHYkeLW/QbsP2jssClZ6bCP
         YYxgX6Cd4bbo4uoyiY7DQnnr+bmXVkkaejM/j0bU3egx1P2cI5TtS1CVgCRNYvjkzbiH
         ziLHz3e83MC/2xt2KPXzTtJxn29a/paIzdbVYSEVzB6OCNDMhs10FSWhBUmBuM/NIeQ7
         AD25fNwHKfQPPAI0YKzh4D7VCFCjYJY8h7GkV7+Hku+85XUrnY3kLveuGtcn0+HBNWr2
         TM0nfBdz0iy4+4LO1iBTB6TuMU+pHClJYWskiir1fUlJ9Qe/jW/IjVsuQc9HPesNkZT4
         NAhg==
X-Gm-Message-State: AC+VfDzq/0AmTYsMtbLqqEChLDELKAyC1+0M57Q7MgzK7/cfxiAd8X5G
        Bb2f/5OLMwDgR+E6BSBh0Z8=
X-Google-Smtp-Source: ACHHUZ4iMK9BL7Lq5y+VTWox45b7vTaIX3GKK3b8zGp/TKvuXUTREPIIxlScgTSj5arEwJiPi10Wvw==
X-Received: by 2002:a17:906:74d4:b0:977:c867:489b with SMTP id z20-20020a17090674d400b00977c867489bmr4883952ejl.0.1685969639496;
        Mon, 05 Jun 2023 05:53:59 -0700 (PDT)
Received: from localhost ([134.191.220.83])
        by smtp.gmail.com with ESMTPSA id u22-20020a170906069600b009767c4235absm3384566ejb.219.2023.06.05.05.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 05:53:59 -0700 (PDT)
Date:   Mon, 5 Jun 2023 20:53:42 +0800
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
Message-ID: <20230605205342.00000e41.zhi.wang.linux@gmail.com>
In-Reply-To: <3b3d9106-9e4f-8a76-30ee-29540b06022a@linux.intel.com>
References: <20230601142309.6307-1-guang.zeng@intel.com>
        <20230601142309.6307-4-guang.zeng@intel.com>
        <3b3d9106-9e4f-8a76-30ee-29540b06022a@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 5 Jun 2023 11:31:48 +0800
Binbin Wu <binbin.wu@linux.intel.com> wrote:

>=20
>=20
> On 6/1/2023 10:23 PM, Zeng Guang wrote:
> > Intel introduces LASS (Linear Address Separation) feature providing
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 ^
>  =A0missing "Space" here
> > an independent mechanism to achieve the mode-based protection.
> >
> > LASS partitions 64-bit linear address space into two halves, user-mode
> > address (LA[bit 63]=3D0) and supervisor-mode address (LA[bit 63]=3D1). =
It
> > stops any code execution or conditional data access[1]
> >      1. from user mode to supervisor-mode address space
> >      2. from supervisor mode to user-mode address space
> > and generates LASS violation fault accordingly.
> >
> > [1]A supervisor mode data access causes a LASS violation only if superv=
isor
> > mode access protection is enabled (CR4.SMAP =3D 1) and either RFLAGS.AC=
 =3D 0
> > or the access implicitly accesses a system data structure.
> >
> > Following are the rules of LASS violation check on the linear address(L=
A).
> > User access to supervisor-mode address space:
> >      LA[bit 63] && (CPL =3D=3D 3)
> > Supervisor access to user-mode address space:
> >      Instruction fetch: !LA[bit 63] && (CPL < 3)
> >      Data access: !LA[bit 63] && (CR4.SMAP=3D=3D1) && ((RFLAGS.AC =3D=
=3D 0 &&
> >                   CPL < 3) || Implicit supervisor access)
> >
> > Add new ops in kvm_x86_ops to do LASS violation check.
> >
> > Signed-off-by: Zeng Guang <guang.zeng@intel.com>
> > Tested-by: Xuelian Guo <xuelian.guo@intel.com>
> > ---
> >   arch/x86/include/asm/kvm-x86-ops.h |  3 +-
> >   arch/x86/include/asm/kvm_host.h    |  2 ++
> >   arch/x86/kvm/kvm_emulate.h         |  1 +
> >   arch/x86/kvm/vmx/vmx.c             | 47 ++++++++++++++++++++++++++++++
> >   arch/x86/kvm/vmx/vmx.h             |  2 ++
> >   5 files changed, 54 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/=
kvm-x86-ops.h
> > index 13bc212cd4bc..8980a3bfa687 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -132,7 +132,8 @@ KVM_X86_OP_OPTIONAL(migrate_timers)
> >   KVM_X86_OP(msr_filter_changed)
> >   KVM_X86_OP(complete_emulated_msr)
> >   KVM_X86_OP(vcpu_deliver_sipi_vector)
> > -KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> > +KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons)
> > +KVM_X86_OP_OPTIONAL_RET0(check_lass)
> >  =20
> >   #undef KVM_X86_OP
> >   #undef KVM_X86_OP_OPTIONAL
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm=
_host.h
> > index 92d8e65fe88c..98666d1e7727 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -1731,6 +1731,8 @@ struct kvm_x86_ops {
> >   	 * Returns vCPU specific APICv inhibit reasons
> >   	 */
> >   	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcp=
u);
> > +
> > +	bool (*check_lass)(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 fla=
gs);
> >   };
> >  =20
> >   struct kvm_x86_nested_ops {
> > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > index 5b9ec610b2cb..f1439ab7c14b 100644
> > --- a/arch/x86/kvm/kvm_emulate.h
> > +++ b/arch/x86/kvm/kvm_emulate.h
> > @@ -91,6 +91,7 @@ struct x86_instruction_info {
> >   /* x86-specific emulation flags */
> >   #define X86EMUL_F_FETCH			BIT(0)
> >   #define X86EMUL_F_WRITE			BIT(1)
> > +#define X86EMUL_F_SKIPLASS		BIT(2)
> >  =20
> >   struct x86_emulate_ops {
> >   	void (*vm_bugged)(struct x86_emulate_ctxt *ctxt);
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index a33205ded85c..876997e8448e 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -8130,6 +8130,51 @@ static void vmx_vm_destroy(struct kvm *kvm)
> >   	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_orde=
r(kvm));
> >   }
> >  =20
> > +/*
> > + * Determine whether an access to the linear address causes a LASS vio=
lation.
> > + * LASS protection is only effective in long mode. As a prerequisite, =
caller
> > + * should make sure vCPU running in long mode and invoke this api to d=
o LASS
> > + * violation check.
> > + */
> > +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 fla=
gs)
> > +{
> > +	bool user_mode, user_as, rflags_ac;
> > +
> > +	if (!!(flags & X86EMUL_F_SKIPLASS) ||
> > +	    !kvm_is_cr4_bit_set(vcpu, X86_CR4_LASS))
> > +		return false;
> > +
> > +	WARN_ON_ONCE(!is_long_mode(vcpu));
> IMHO, it's better to skip the following checks and return false if it is=
=20
> out of long mode.
>
The check of long mode is in the caller implemented in in the next patch. :)

+	if (!is_long_mode(vcpu))
+		return false;

> > +
> > +	user_as =3D !(la >> 63);
> It's better to describe how LASS treat linear address in compatibility=20
> mode in changelog or/and in comment,
> i.e. for a linear address with only 32 bits (or 16 bits), the processor=20
> treats bit 63 as if it were 0.
>
>=20
> > +
> > +	/*
> > +	 * An access is a supervisor-mode access if CPL < 3 or if it implicit=
ly
> > +	 * accesses a system data structure. For implicit accesses to system
> > +	 * data structure, the processor acts as if RFLAGS.AC is clear.
> > +	 */
> > +	if (access & PFERR_IMPLICIT_ACCESS) {
> > +		user_mode =3D false;
> > +		rflags_ac =3D false;
> > +	} else {
> > +		user_mode =3D vmx_get_cpl(vcpu) =3D=3D 3;
> > +		if (!user_mode)
> > +			rflags_ac =3D !!(kvm_get_rflags(vcpu) & X86_EFLAGS_AC);
> > +	}
> > +
> > +	if (user_mode =3D=3D user_as)
> > +		return false;
> > +
> > +	/*
> > +	 * Supervisor-mode _data_ accesses to user address space
> > +	 * cause LASS violations only if SMAP is enabled.
> > +	 */
> > +	if (!user_mode && !(access & PFERR_FETCH_MASK))
> > +		return kvm_is_cr4_bit_set(vcpu, X86_CR4_SMAP) && !rflags_ac;
> > +
> > +	return true;
> > +}
> > +
> >   static struct kvm_x86_ops vmx_x86_ops __initdata =3D {
> >   	.name =3D KBUILD_MODNAME,
> >  =20
> > @@ -8269,6 +8314,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata =
=3D {
> >   	.complete_emulated_msr =3D kvm_complete_insn_gp,
> >  =20
> >   	.vcpu_deliver_sipi_vector =3D kvm_vcpu_deliver_sipi_vector,
> > +
> > +	.check_lass =3D vmx_check_lass,
> >   };
> >  =20
> >   static unsigned int vmx_handle_intel_pt_intr(void)
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 9e66531861cf..f2e775b9849b 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -433,6 +433,8 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *=
vcpu, u32 msr, int type);
> >   u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
> >   u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
> >  =20
> > +bool vmx_check_lass(struct kvm_vcpu *vcpu, u64 access, u64 la, u32 fla=
gs);
> > +
> >   static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u=
32 msr,
> >   					     int type, bool value)
> >   {
>=20

