Return-Path: <kvm+bounces-30194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FAE69B7DDD
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 16:12:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 946611F215F4
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 15:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812581A3056;
	Thu, 31 Oct 2024 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N8OHzEvc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F621A2554
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 15:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730387509; cv=none; b=gscDL25ImZkK4Qg8xPNFqeq7xvzA/sGkmmVj6i9LhMmxo5rp5RTmAYUkxK9Ai2o32PjbirJV80Djdnx2I2r0d/XmhKym5yM+TIjN3H4qgtnzzbtYhwV74mdwzhG4mTNGqUuWiZDcRYOXA9aLRzxtI7FlPXyuhxQmPw60ztr0Vpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730387509; c=relaxed/simple;
	bh=7jwnfdMN3F2S5fym8rFejprNgR+2BFXIimZ0H3us0Rw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rvH7n8T8xYR6KfUAbF5/W7TMqnyQN1OKnkGtwq167ZKI3xnKI2afyA8U8fOMgkfggx9puFTdimgXWlkvIOm4eeezy0vCA7aMyXD7/AsJ6j0kzTiZ4nasnmPhFib6ailDZrIKkwr8fbjyfANXTDpL5Sb5JhLrtVh3qWRvBxpqqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N8OHzEvc; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e6241c002so994898b3a.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 08:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730387506; x=1730992306; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNvlokIe1Br4lk/W/Xm81xv64+Y3DxCvAIp56+tQW0Q=;
        b=N8OHzEvcNG3tWonpp3Bbs+4OFoISGVuNCersyG35A+/tKixTx8U2W56JPPGN9Dh7hj
         dfIJgFXhhF9Rwa6Hw8RenvMb+9zcVJFkpTSehoGSFTUwG67MEueG2Neu6y3ZfWXB7yLR
         N3TiS9bhpNYuz67/XoOjjzC7V6QhIzbFTigpEHVOL7FXHZRLcmhhgsIsCkYcAiDjk/Zy
         15TTgOnwkI8kbLSjnE9p9OQhJD4PvawG1H6gVf3ciVxYwLrfpAExLN2JBvPqeh7V/aUz
         jsD+33Eoy7QTv9dtHzephFYQR1irTgk8PA4fXcvWj51JT2oi/gb5aXTBNNUIPrzIsiTe
         BsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730387506; x=1730992306;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RNvlokIe1Br4lk/W/Xm81xv64+Y3DxCvAIp56+tQW0Q=;
        b=kJjU9p5hvF7VipQwRM5NdIkNV4UkNuzmgYkaUuYsV5QXwG16Bo44szpZ4MAkE096cn
         pUZYj385tNjfQxHq2BS+fep2CzcN4cBi618C+xyGaX2HzgO5WwFeWRZfwFg/RXDK2WA8
         xtFYV7K+EKlIPsDrkfN1axx7U70553Kf6sbGm2wXvEQDBA+z71PxnW4qpLk/PDkbzfkj
         Wxd9t3NaCGX0FlbOxaqu+NvlMh3LauHAW2p/LXcV2d68sX+Upcld6wd1yASCm0ekyl2A
         /tP8zRrym7kV3MDctYKp+DQ55fSbeeUi3gXP8yNwtR5qjlv1NkqEWI0gj5+0ZDNlVReY
         PgZw==
X-Gm-Message-State: AOJu0Yx23DQULxkVPigN/iHcmyy+5LwSSIrnVU+S0c98A+r8Kwfq4HCs
	l14mMAHFP9wqFWPlD4CzbsUzrfECo1HT6xUYtsdH0VTR4NMoHsXBEhW5yDoKkMPqjUO42FDzcWO
	2Tg==
X-Google-Smtp-Source: AGHT+IGv3nscdzAd4YFBtAvSU6CQTQhfrBSnQF/WHRNsktgJ9OvJfsj8c9438slFE+WyDQR+lAVw3RZRrdA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:8989:b0:71e:6a72:e9d with SMTP id
 d2e1a72fcca58-720bc894a2emr7121b3a.3.1730387505678; Thu, 31 Oct 2024 08:11:45
 -0700 (PDT)
Date: Thu, 31 Oct 2024 08:11:44 -0700
In-Reply-To: <4734379d-97c4-44c8-ae40-be46da6e6239@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com> <ZyKbxTWBZUdqRvca@google.com>
 <4734379d-97c4-44c8-ae40-be46da6e6239@linux.intel.com>
Message-ID: <ZyOeMJ3BtI_h136q@google.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace generically
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com, 
	isaku.yamahata@intel.com, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	yuan.yao@linux.intel.com, xiaoyao.li@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 31, 2024, Binbin Wu wrote:
> On 10/31/2024 4:49 AM, Sean Christopherson wrote:
> > On Mon, Aug 26, 2024, Binbin Wu wrote:
> > > Check whether a KVM hypercall needs to exit to userspace or not based=
 on
> > > hypercall_exit_enabled field of struct kvm_arch.
> > >=20
> > > Userspace can request a hypercall to exit to userspace for handling b=
y
> > > enable KVM_CAP_EXIT_HYPERCALL and the enabled hypercall will be set i=
n
> > > hypercall_exit_enabled.  Make the check code generic based on it.
> > >=20
> > > Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> > > Reviewed-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >   arch/x86/kvm/x86.c | 5 +++--
> > >   arch/x86/kvm/x86.h | 4 ++++
> > >   2 files changed, 7 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 966fb301d44b..e521f14ad2b2 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -10220,8 +10220,9 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vc=
pu)
> > >   	cpl =3D kvm_x86_call(get_cpl)(vcpu);
> > >   	ret =3D __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bi=
t, cpl);
> > > -	if (nr =3D=3D KVM_HC_MAP_GPA_RANGE && !ret)
> > > -		/* MAP_GPA tosses the request to the user space. */
> > > +	/* Check !ret first to make sure nr is a valid KVM hypercall. */
> > > +	if (!ret && user_exit_on_hypercall(vcpu->kvm, nr))
> > I don't love that the caller has to re-check for user_exit_on_hypercall=
().
> Agree, it is not ideal.
>=20
> But if __kvm_emulate_hypercall() returns 0 to indicate user exit and 1 to
> indicate success, then the callers have to convert the return code to set
> return value for guest.=C2=A0 E.g., TDX code also needs to do the convers=
ion.

Yeah, it's ugly.

> > @@ -10111,12 +10111,21 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vc=
pu)
> >   	cpl =3D kvm_x86_call(get_cpl)(vcpu);
> >   	ret =3D __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit,=
 cpl);
> > -	if (nr =3D=3D KVM_HC_MAP_GPA_RANGE && !ret)
> > -		/* MAP_GPA tosses the request to the user space. */
> > +	if (!ret)
> >   		return 0;
> > -	if (!op_64_bit)
> > +	/*
> > +	 * KVM's ABI with the guest is that '0' is success, and any other val=
ue
> > +	 * is an error code.  Internally, '0' =3D=3D exit to userspace (see a=
bove)
> > +	 * and '1' =3D=3D success, as KVM's de facto standard return codes ar=
e that
> > +	 * plus -errno =3D=3D failure.  Explicitly check for '1' as some PV e=
rror
> > +	 * codes are positive values.
> > +	 */
> I didn't understand the last sentence:
> "Explicitly check for '1' as some PV error codes are positive values."
>=20
> The functions called in __kvm_emulate_hypercall() for PV features return
> -KVM_EXXX for error code.
> Did you mean the functions like kvm_pv_enable_async_pf(), which return
> 1 for error, would be called in __kvm_emulate_hypercall() in the future?
> If this is the concern, then we cannot simply convert 1 to 0 then.

No, it was a brain fart on my end.  I was thinking of these #defines, and m=
anaged
to forget that KVM always returns -KVM_Exxx.  /facepalm

  #define KVM_ENOSYS		1000
  #define KVM_EFAULT		EFAULT
  #define KVM_EINVAL		EINVAL
  #define KVM_E2BIG		E2BIG
  #define KVM_EPERM		EPERM
  #define KVM_EOPNOTSUPP		95

>=20
> > +	if (ret =3D=3D 1)
> > +		ret =3D 0;
> > +	else if (!op_64_bit)
> >   		ret =3D (u32)ret;
> > +
> >   	kvm_rax_write(vcpu, ret);
> >   	return kvm_skip_emulated_instruction(vcpu);
> >=20
> > base-commit: 675248928970d33f7fc8ca9851a170c98f4f1c4f
>=20

