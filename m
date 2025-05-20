Return-Path: <kvm+bounces-47183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5407ABE645
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 23:49:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 803327A7D98
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 21:47:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C502225E80E;
	Tue, 20 May 2025 21:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQBdt9sW"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920A7136351
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 21:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747777731; cv=none; b=UaV7+uS5R9R84W19c6A1ayzQxNI1/F4qKF01wFa4nciUay4OpQ6v5KnoUMHpePCy+2SBRbdB1Ur+m4UV56jkVIF45rh4N12uKY7Gmit45un7p6t12LQkbYrGYweU5Wz9QeJdQ5UPGEHw6DsA2bDCLuIwSLndE0YhBA0Q02W/hFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747777731; c=relaxed/simple;
	bh=5LoP3oqgkFKk6ICaoX4/klDyU+9dYXEmA86kg6cSZJA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BNcqLuh4xuiSFABjOwF39oJWL01cAmlWXlqHcYv+cPSVnXkBsIom0uvZOmYp2P9Wq3k7vWUMllggPPH1zygRqy0l7whGmOcOQQKEh2vnXUwmq15QiaLKdsc9u9mt0eysQv2TZKZBgYNJbGCV2w22ZirGk9aL/zfKOD8eiyIWo1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQBdt9sW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747777728;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EutPvaaVGl0ODINF9E/bZzQuSm+ScWKoBRiRqN3WqE0=;
	b=EQBdt9sWsqQToJ4TO0fTQltngSKDF90P2D9lJetBSJDQKcTk+J7s8tZudN5/0KW3yGyIFp
	Aeod+dkTrem55+bh7mitOesdKQTccuYSioGbKczqz9FqAKzMlIYIiq3bXuyiIu9mZ2FbDS
	kgHSutlh8XgcnmpIVa8Rn9nlyW4GiMY=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-m9AElkeSNDOD-qTRuxwfLQ-1; Tue, 20 May 2025 17:48:47 -0400
X-MC-Unique: m9AElkeSNDOD-qTRuxwfLQ-1
X-Mimecast-MFC-AGG-ID: m9AElkeSNDOD-qTRuxwfLQ_1747777727
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6f8dd95985dso53154366d6.0
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 14:48:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747777726; x=1748382526;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EutPvaaVGl0ODINF9E/bZzQuSm+ScWKoBRiRqN3WqE0=;
        b=DYbpiCaUVnVja37Mp1C76fLDsI54Bi+/0+uJ77/ODxzGax5I9n8MGbyMGJjP7AFoTl
         P3pGCYWj8hYZ3n/ndwuMmWDtVNbHlgWNVIoj7l6YP8Bl6tf/A0QgXYCv3Lz41UpJ9TpD
         7LR17OplY7ggwHOQWr+bsg4XgWnaDtTaHBXbJQ0sPKsTJNlhbdaITTFP6+93Wr+H0+pR
         qPMj1PUz7oA4GWvIkHAO9U72Ie4Tmj7TOpOgDLmLBwyzY9+VCGMLhkfJYsixg7qPox1O
         DgMOHzQfMMpzve3eE3lHgiKtBYTzhbZQilqZ46GuCnOpux0+XjZQaxX7kF7iYgiq7Gg0
         O9AA==
X-Gm-Message-State: AOJu0Yy/kyIOEza6Eau3btsbp74/RnctS1Tn2aRLaFQrlRTXXBHx3p8w
	ibC1h1UWKq01FpoUz8E/3UGBcG1N4/x5GsX1YPiuxVPcqAoDp+DRcxfGqXFmUlCpxXnU0iriY9N
	CUdQ+qBxEPFQFcwwM6RKgIfs7QfY93WsuajI59Y4Ty9l8cI8W/icOeA==
X-Gm-Gg: ASbGncsZHfs6PyPjVktb3M6FZTRALzFFR52mmo3/R8HYNHI5Tu+ejuqohAcjNLGTVFQ
	XgABHb34PLwA+1uTj6NQz8qJdi3uRDou2ZflNyNSzsCGF5/YbPGodMxrAOfFdkNq04WuPzC72P4
	mtMxku/Mim2NAG8MzP2ubPUwM1vckTtU8sq4PD+ZuB6oexF6oP29FKSQ2odlMPcDOUo0LDffY0g
	tPShztPEDol5SmYbvc5PCJWZh01qAps/WwrYhwmgf767BKFwVPsL4/Gpl6JZa1C8M2Z4j7r/RiL
	ycAG1gXsMtkfW61X56JEf2BXfm+p84tk7x7yoC/WCFTTNIbeAoRG9UR5mfQ=
X-Received: by 2002:a05:6214:482:b0:6f2:c88a:50c5 with SMTP id 6a1803df08f44-6f8b2d0d13dmr346107916d6.32.1747777726550;
        Tue, 20 May 2025 14:48:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuvUphlpNVXWMjMR0Rm0/W8jolN5rQHYmWgteLlMDTRklWTSbWCq/+mU2Z1OwSeR6pXhISOg==
X-Received: by 2002:a05:6214:482:b0:6f2:c88a:50c5 with SMTP id 6a1803df08f44-6f8b2d0d13dmr346107576d6.32.1747777726204;
        Tue, 20 May 2025 14:48:46 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b096ddb4sm76528256d6.78.2025.05.20.14.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 May 2025 14:48:45 -0700 (PDT)
Message-ID: <fababe6628c448a4aa96e1ad47ad862eddf90c24.camel@redhat.com>
Subject: Re: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl
 value given by L2
From: mlevitsk@redhat.com
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sean
 Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Date: Tue, 20 May 2025 17:48:44 -0400
In-Reply-To: <d9ea18ac1148c9596755c4df8548cdb8394f2ee0.camel@redhat.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
	 <20250515005353.952707-4-mlevitsk@redhat.com> <aCaxlS+juu1Rl7Mv@intel.com>
	 <d9ea18ac1148c9596755c4df8548cdb8394f2ee0.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-05-16 at 10:50 -0400, mlevitsk@redhat.com wrote:
> On Fri, 2025-05-16 at 11:31 +0800, Chao Gao wrote:
> > On Wed, May 14, 2025 at 08:53:52PM -0400, Maxim Levitsky wrote:
> > > Check the vmcs12 guest_ia32_debugctl value before loading it, to avoi=
d L2
> > > being able to load arbitrary values to hardware IA32_DEBUGCTL.
> > >=20
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > > arch/x86/kvm/vmx/nested.c | 4 ++++
> > > arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0=C2=A0 | 2 +-
> > > arch/x86/kvm/vmx/vmx.h=C2=A0=C2=A0=C2=A0 | 2 ++
> > > 3 files changed, 7 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > index e073e3008b16..0bda6400e30a 100644
> > > --- a/arch/x86/kvm/vmx/nested.c
> > > +++ b/arch/x86/kvm/vmx/nested.c
> > > @@ -3193,6 +3193,10 @@ static int nested_vmx_check_guest_state(struct=
 kvm_vcpu *vcpu,
> > > 	=C2=A0=C2=A0=C2=A0=C2=A0 CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFG=
S_RSVD))))
> > > 		return -EINVAL;
> > >=20
> > > +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> > > +	=C2=A0=C2=A0=C2=A0=C2=A0 CC(vmcs12->guest_ia32_debugctl & ~vmx_get_=
supported_debugctl(vcpu, false)))
> > > +		return -EINVAL;
> > > +
> >=20
> > How about grouping this check with the one against DR7 a few lines abov=
e?
>=20
> Good idea, will do.

Besides the above change, is there anything else to change in this patchset=
?
If not I'll sent a new version soon.

Thanks,
Best regards,
	Maxim Levitsky




> >=20
> > > 	if (nested_check_guest_non_reg_state(vmcs12))
> > > 		return -EINVAL;
> > >=20
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 9953de0cb32a..9046ee2e9a04 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -2179,7 +2179,7 @@ static u64 nested_vmx_truncate_sysenter_addr(st=
ruct kvm_vcpu *vcpu,
> > > 	return (unsigned long)data;
> > > }
> > >=20
> > > -static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool ho=
st_initiated)
> > > +u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_init=
iated)
> > > {
> > > 	u64 debugctl =3D 0;
> > >=20
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index 6d1e40ecc024..1b80479505d3 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -413,7 +413,9 @@ static inline void vmx_set_intercept_for_msr(stru=
ct kvm_vcpu *vcpu, u32 msr,
> > > 		vmx_disable_intercept_for_msr(vcpu, msr, type);
> > > }
> > >=20
> > > +
> >=20
> > stray newline.
> >=20
> > > void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
> > > +u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_init=
iated);
> > >=20
> > > /*
> > > =C2=A0* Note, early Intel manuals have the write-low and read-high bi=
tmap offsets
> > > --=20
> > > 2.46.0
> > >=20
> > >=20
> >=20
>=20
> Best regards,
> 	Maxim Levitsky


