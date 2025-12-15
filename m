Return-Path: <kvm+bounces-66013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D3BECBF8F7
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 20:35:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E101730A3DC0
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 19:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B37DA335094;
	Mon, 15 Dec 2025 19:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1DmzYpfJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B4EC33372E
	for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 19:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765826912; cv=none; b=RueQf5b1GDn8/BwUtfshwHbFeALdUAo4v5t6kfyj/Wji6fL7A3coaFTnC9YcPVPOcWV7NczrGbe2o9/6glWgd9GbttR7HdcgqV1hkHgnRcrcvt8qv+0E+Azk+Tr5XG847j2kBcBN3zlDzhOzGmu0wM/8aSkacNioPpOrvZWw3iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765826912; c=relaxed/simple;
	bh=cNsVoujiY8uDrGz4I4Bw9xQAEb7YfhSZfFobdml3xFg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mk/V7GVrtH1WePDkqG3odBGfbdpsWFvWBH0V4Rvp84doH4FlCA9sCGa8ZccxBN7BzraDEw7gN0lEFDjgDzXQIo5VVhKXLdelc0/oHkfTnoWxCmgsYPx7sPzNw5Syr9NHMCyIxJAULGSI1OQy6CBmOdNUB1zniWoHZFBldkhO6ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1DmzYpfJ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so30426845e9.1
        for <kvm@vger.kernel.org>; Mon, 15 Dec 2025 11:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765826909; x=1766431709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lEXX3vc4cLU+jIKkIZEIBzEs4e4yEJi9BbZ4OFfzCaQ=;
        b=1DmzYpfJ33x7tVtMoF9OLFjEc/zeEpAHVjM3VGHQwuoxKMicYXb78ztVpCtfUtGMGm
         G1UXjsEICA/ch8LPHIm8DTTk8X9ISMfqIjeUOSKVUBoOrby54Psj/1Zy2qINMjGMOGwf
         TATiud/DqsP9yhSl9MBmTsI3K4U7fQerXMgQQJ3ci+39+Ino4vGZU6rGHLpRfBd8VPvB
         o0B3HUcR6z3+8sAuHnxS6PAsUFAbhLM3QWz0X9UiVIXxRMG4i6iRxWChxzf0Oy9lWOAr
         FAM+74BusVGWjFbJ1ZJk2MlM8dxP531WzSIolyMxOJXfSBgm4e8ZLmoj1EqB1fWBACLb
         7OrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765826909; x=1766431709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lEXX3vc4cLU+jIKkIZEIBzEs4e4yEJi9BbZ4OFfzCaQ=;
        b=HQugLIpcA+A5+aYIJ/u0yQGfgK7A42XAG0KWdfXBXCnOE0Wpyf0MnjRTPW0AdAMgGT
         yFw3SPdm3nYgBqQZBKck85EzvA+YFqaCoVpG7ArLKa13h9NMyBtDyORiNM11A4HzegTZ
         wcpqho074NrwS4vgEXKuyNdWIDjDkVdVHZhE8sbqbfOmvgq8pfMN71Vp23aA7HU439yA
         0mtE1GdA9xTToqplP1uGEvjawf/AvhQNOmN2/PX1E2NuHFbGbf7+R+gj0HjYCKy58qde
         fYqsisbyeL3HD0fChWGJxmm57WsRKF5KDVtCEqvybnval5bljL01LmGo0uJpPaGQySMV
         huxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXQ49cRtAyoaTSRF+F0owE+tmeHu/n0AwJyH3/Ttxxvsn/+GzPqY86nxU8nJeMSutAHnM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1zfoHmADH86nofhj1L3CadpBUG+Gno3GJYd5mCZiFsIVf8qrF
	xEvyn1wxY17MzI+57kPKdisr4xEt9i0Ztm2OKmdtbrxeXoM8Q5Xb5N2VLyGmCCi/gFbWloQGig8
	o5vqb+1s7tVcKcL+kqy5XPRDtPXkxmfyzasOp5gM5
X-Gm-Gg: AY/fxX5sE59tJ0pjQZcxHYQm57joYzjI40CVbmciZUeU14SrCVdcJcLXUetxdijPdNh
	3F5nVVjW10i7Zu8/uqnsJXNCACwqMQaigqGkZIp/6942wAYsIflBceSqPt45gtLqfN+CGywbOdY
	3SMv+NpPUGGYo0WFBywAbHF/PWsxK+fk7lyG5xuiJo/rabguCpHGsUsDUSMrZruRwfVJ/U4Hm1a
	zyXICcRahTVvw2R4AQy4D5rZ85ehlMcrQgVV3ak0zghdw1ksOQz6vRBiXMs2NCrZfetVY5qw3NL
	gqb/vs8wwpMb8pmEur8TbVF3O67Tkw==
X-Google-Smtp-Source: AGHT+IGO1dIoyxgcNd4S7Pz2nAr73mkYppC4c9vFh2s0+ET6QNErIQ2RHfdzOEifqc8Xtb0LAn7vcRr53bQvbkUBDwQ=
X-Received: by 2002:a05:6000:18a3:b0:426:ee08:8ea9 with SMTP id
 ffacd0b85a97d-42fb48fa58dmr13868372f8f.44.1765826908295; Mon, 15 Dec 2025
 11:28:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215160710.1768474-1-chengkev@google.com> <s2he4kulkeylkrv5n7r5vb7uyr72lvv7yajh5ln67d3zjwrnai@e4stv2pkh7c4>
In-Reply-To: <s2he4kulkeylkrv5n7r5vb7uyr72lvv7yajh5ln67d3zjwrnai@e4stv2pkh7c4>
From: Kevin Cheng <chengkev@google.com>
Date: Mon, 15 Dec 2025 14:28:17 -0500
X-Gm-Features: AQt7F2pymdhc_-Oub1oWCfakenY02NVYGcCPkNAUIfXVngYnIwTnreZRl9pniCo
Message-ID: <CAE6NW_bTM0cpYcwu-wj+PHUCnkuYs3WpejPr1or+9+PVg1-byA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: SVM: Don't allow L1 intercepts for instructions
 not advertised
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: seanjc@google.com, pbonzini@redhat.com, jmattson@google.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 1:51=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> On Mon, Dec 15, 2025 at 04:07:10PM +0000, Kevin Cheng wrote:
> > If a feature is not advertised in the guest's CPUID, prevent L1 from
> > intercepting the unsupported instructions by clearing the corresponding
> > intercept in KVM's cached vmcb12.
> >
> > When an L2 guest executes an instruction that is not advertised to L1,
> > we expect a #UD exception to be injected by L0. However, the nested svm
> > exit handler first checks if the instruction intercept is set in vmcb12=
,
> > and if so, synthesizes an exit from L2 to L1 instead of a #UD exception=
.
> > If a feature is not advertised, the L1 intercept should be ignored.
> >
> > While creating KVM's cached vmcb12, sanitize the intercepts for
> > instructions that are not advertised in the guest CPUID. This
> > effectively ignores the L1 intercept on nested vm exit handling.
>
> Nit: It also ignores the L1 intercept when computing the intercepts in
> VMCB02, so if L0 (for some reason) does not intercept the instruction,
> KVM won't intercept it at all.
>
> I don't think this should happen because KVM should always intercept
> unsupported instructions to inject a #UD, unless they are not supported
> by HW, in which case I believe the HW will inject the #UD for us.
>
> >
> > Signed-off-by: Kevin Cheng <chengkev@google.com>
>
> Maybe also this since Sean contributed code to the patch in his last
> review?
>
> Co-developed-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
>

I promise I didn't mean to leave that out haha. Sorry Sean! Done.

> Otherwise looks good to me, FWIW:
> Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
>
> > ---
> > v1 -> v2:
> >   - Removed nested_intercept_mask which was a bit mask for nested
> >     intercepts to ignore.
> >   - Now sanitizing intercepts every time cached vmcb12 is created
> >   - New wrappers for vmcb set/clear intercept functions
> >   - Added macro functions for vmcb12 intercept sanitizing
> >   - All changes suggested by Sean. Thanks!
> >   - https://lore.kernel.org/all/20251205070630.4013452-1-chengkev@googl=
e.com/
> >
> >  arch/x86/kvm/svm/nested.c | 19 +++++++++++++++++++
> >  arch/x86/kvm/svm/svm.h    | 35 +++++++++++++++++++++++++++--------
> >  2 files changed, 46 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > index c81005b245222..5ffc12a315ec7 100644
> > --- a/arch/x86/kvm/svm/nested.c
> > +++ b/arch/x86/kvm/svm/nested.c
> > @@ -403,6 +403,19 @@ static bool nested_vmcb_check_controls(struct kvm_=
vcpu *vcpu)
> >       return __nested_vmcb_check_controls(vcpu, ctl);
> >  }
> >
> > +/*
> > + * If a feature is not advertised to L1, clear the corresponding vmcb1=
2
> > + * intercept.
> > + */
> > +#define __nested_svm_sanitize_intercept(__vcpu, __control, fname, inam=
e)     \
> > +do {                                                                  =
       \
> > +     if (!guest_cpu_cap_has(__vcpu, X86_FEATURE_##fname))             =
       \
> > +             vmcb12_clr_intercept(__control, INTERCEPT_##iname);      =
       \
> > +} while (0)
> > +
> > +#define nested_svm_sanitize_intercept(__vcpu, __control, name)        =
               \
> > +     __nested_svm_sanitize_intercept(__vcpu, __control, name, name)
> > +
> >  static
> >  void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
> >                                        struct vmcb_ctrl_area_cached *to=
,
> > @@ -413,6 +426,12 @@ void __nested_copy_vmcb_control_to_cache(struct kv=
m_vcpu *vcpu,
> >       for (i =3D 0; i < MAX_INTERCEPT; i++)
> >               to->intercepts[i] =3D from->intercepts[i];
> >
> > +     __nested_svm_sanitize_intercept(vcpu, to, XSAVE, XSETBV);
> > +     nested_svm_sanitize_intercept(vcpu, to, INVPCID);
> > +     nested_svm_sanitize_intercept(vcpu, to, RDTSCP);
> > +     nested_svm_sanitize_intercept(vcpu, to, SKINIT);
> > +     nested_svm_sanitize_intercept(vcpu, to, RDPRU);
> > +
> >       to->iopm_base_pa        =3D from->iopm_base_pa;
> >       to->msrpm_base_pa       =3D from->msrpm_base_pa;
> >       to->tsc_offset          =3D from->tsc_offset;
> > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > index 9e151dbdef25d..7a8c92c4de2fb 100644
> > --- a/arch/x86/kvm/svm/svm.h
> > +++ b/arch/x86/kvm/svm/svm.h
> > @@ -434,28 +434,47 @@ static __always_inline struct vcpu_svm *to_svm(st=
ruct kvm_vcpu *vcpu)
> >   */
> >  #define SVM_REGS_LAZY_LOAD_SET       (1 << VCPU_EXREG_PDPTR)
> >
> > -static inline void vmcb_set_intercept(struct vmcb_control_area *contro=
l, u32 bit)
> > +static inline void __vmcb_set_intercept(unsigned long *intercepts, u32=
 bit)
> >  {
> >       WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
> > -     __set_bit(bit, (unsigned long *)&control->intercepts);
> > +     __set_bit(bit, intercepts);
> >  }
> >
> > -static inline void vmcb_clr_intercept(struct vmcb_control_area *contro=
l, u32 bit)
> > +static inline void __vmcb_clr_intercept(unsigned long *intercepts, u32=
 bit)
> >  {
> >       WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
> > -     __clear_bit(bit, (unsigned long *)&control->intercepts);
> > +     __clear_bit(bit, intercepts);
> >  }
> >
> > -static inline bool vmcb_is_intercept(struct vmcb_control_area *control=
, u32 bit)
> > +static inline bool __vmcb_is_intercept(unsigned long *intercepts, u32 =
bit)
> >  {
> >       WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
> > -     return test_bit(bit, (unsigned long *)&control->intercepts);
> > +     return test_bit(bit, intercepts);
> > +}
> > +
> > +static inline void vmcb_set_intercept(struct vmcb_control_area *contro=
l, u32 bit)
> > +{
> > +     __vmcb_set_intercept((unsigned long *)&control->intercepts, bit);
> > +}
> > +
> > +static inline void vmcb_clr_intercept(struct vmcb_control_area *contro=
l, u32 bit)
> > +{
> > +     __vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
> > +}
> > +
> > +static inline bool vmcb_is_intercept(struct vmcb_control_area *control=
, u32 bit)
> > +{
> > +     return __vmcb_is_intercept((unsigned long *)&control->intercepts,=
 bit);
> > +}
> > +
> > +static inline void vmcb12_clr_intercept(struct vmcb_ctrl_area_cached *=
control, u32 bit)
> > +{
> > +     __vmcb_clr_intercept((unsigned long *)&control->intercepts, bit);
> >  }
> >
> >  static inline bool vmcb12_is_intercept(struct vmcb_ctrl_area_cached *c=
ontrol, u32 bit)
> >  {
> > -     WARN_ON_ONCE(bit >=3D 32 * MAX_INTERCEPT);
> > -     return test_bit(bit, (unsigned long *)&control->intercepts);
> > +     return __vmcb_is_intercept((unsigned long *)&control->intercepts,=
 bit);
> >  }
> >
> >  static inline void set_exception_intercept(struct vcpu_svm *svm, u32 b=
it)
> > --
> > 2.52.0.239.gd5f0c6e74e-goog
> >

