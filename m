Return-Path: <kvm+bounces-46822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD458AB9EEF
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 16:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC6241BC5C70
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 14:50:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771691A704B;
	Fri, 16 May 2025 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dA/wwmJ0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF17192598
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747407022; cv=none; b=S66lSv97K7lidWMIOGJdL/t5upfv6Zb6BdKGOibpNNC/ni0IhdAT4eh9ic9vDS/rDLyoiSklNSGOFx1VEGytDdQlzimi+eM1kXzkIeCgsthc133FrDNOlLaiR7Bx6uMqDfLxgORufsNJpAvEb2T/06Lpgdc51Qweot/BMcH7MkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747407022; c=relaxed/simple;
	bh=iXCG1lB1hSDhDND+Mu8dBz8ehzjoDp4h4FuB3y/JnNI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W8fTEXlct3V+ls7k1prN6jDI84jMzgkIggS1PjWRZROcLM/uK57KkCYTmjFZHkk1xrGqbv8FszAlzwi9OaGa4psj1F1EQnWHIeBPrRnsPfmhyN8I2wi0KU0p45GlV5ovWJYius1bSoeM2qE7YM7geIE66WHPL9/3ttc/YO5DyEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dA/wwmJ0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747407019;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZGknCYcVzfwV4QTeTo4iOxNUKp1vBC8TqCZBOa1r6jg=;
	b=dA/wwmJ05BTBk9yAVidLdULT2U0MKQkyioGlcwlX6B19CpyT0XIK0Po81zraTn3OICIcbz
	LdulCmzGKqlK9YV9UL6rheR3W4mU0CE451fNv6LeZ9jjmNrxQlOXjeZGFnog/8nWo9+fv9
	U/GwAYDJLAx8yckfbTcs+E3F2CjD5VQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-6z_lNKHCMNuJ1iERMWHyfg-1; Fri, 16 May 2025 10:50:17 -0400
X-MC-Unique: 6z_lNKHCMNuJ1iERMWHyfg-1
X-Mimecast-MFC-AGG-ID: 6z_lNKHCMNuJ1iERMWHyfg_1747407017
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7caee988153so414552585a.1
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 07:50:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747407017; x=1748011817;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZGknCYcVzfwV4QTeTo4iOxNUKp1vBC8TqCZBOa1r6jg=;
        b=rnYne9viUyKRpfoXZCQba1M4VR1Fx+2pXu97B4Es5Ja8pV9lJ8+EWWvahMUh7NhmUx
         iJ8ZVGLAp/b/Xmubh3Ndm5XtGkyFPnKnXxPZpUTeYDgoMKNssL0vA2wItLYtYSQwGlWW
         rrFw3Aei7vlGC9dzh8r3p9Vscfhwv2T/PESsRFke+1ktiYLer06Cl4OjUuNuqwlzQfLn
         nzzY9WNYyBKVBNyQRET5bMDvzQl1G691D7pOZEZtp1ZTbbCGO3hZl+e8D+McBxdpRgB0
         UgLLX5mlcGyKGWZmABCgzdE+1627hVEE6Rra0/Q+UvUulsmHEIck06QSlTq3A2kkZT9K
         Wbsg==
X-Gm-Message-State: AOJu0Yzc2d4j/zwxVjq6t7JrV4+6/+rjkMSt7ADdqftfVBj7/FdsiIp5
	OoxHuLSoM6IW/pCLAXidJ9SP8H+MdA4Vn743+i2RfKpGwjSYC4nzVqaveE5gWK1whae0bCEW8Nc
	McKRUPXrJQBrHfsImxOsNidkYiFZiy0gy4fNueX0EAGByTGzrqCnhdQ==
X-Gm-Gg: ASbGncvofhYoQzALWQAXcEqJSa/UhmwOTPlJipAeyrbq7v4qbTFB95OGw/Hi+0YCk/Y
	vAk3r8i9OJS9r/Un8i9exYQRi6kck1wNA1qhA2fGZdYm5hjPZPlVwhPQ+SyjZa/6ltly7fK7GsE
	uVK/uBGuC3hABp7TtyJz6SHK93ZZAC/GFevZd07fCJgct1UAeNxmp5VV8bosDC0pJx0AJdSFloj
	Ab4QFgSFE3eo1qiXZF3Yqz/GSgV1v0RLAOu5w4qn0Jr/7M6hrBXv1E/tAqudHmi03GNtCVa1Tni
	9Xa0rLc4Ie3gzCK1uAvQy6iwbGOQAIwzIqRPnJjRNraUzeahTE/PYu6K9Bo=
X-Received: by 2002:a05:620a:1aa1:b0:7c7:b4aa:85bc with SMTP id af79cd13be357-7cd4671fd5emr460804185a.17.1747407016922;
        Fri, 16 May 2025 07:50:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/u3CrKF+Ne4YiK2FGftFVriQZUA6ii1GQ24KTQGBdBRrEctcDVpPHHiKEsqyNW5yBxL4J4w==
X-Received: by 2002:a05:620a:1aa1:b0:7c7:b4aa:85bc with SMTP id af79cd13be357-7cd4671fd5emr460800185a.17.1747407016530;
        Fri, 16 May 2025 07:50:16 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467d814bsm126516085a.28.2025.05.16.07.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 07:50:16 -0700 (PDT)
Message-ID: <d9ea18ac1148c9596755c4df8548cdb8394f2ee0.camel@redhat.com>
Subject: Re: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl
 value given by L2
From: mlevitsk@redhat.com
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sean
 Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Date: Fri, 16 May 2025 10:50:15 -0400
In-Reply-To: <aCaxlS+juu1Rl7Mv@intel.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
	 <20250515005353.952707-4-mlevitsk@redhat.com> <aCaxlS+juu1Rl7Mv@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-05-16 at 11:31 +0800, Chao Gao wrote:
> On Wed, May 14, 2025 at 08:53:52PM -0400, Maxim Levitsky wrote:
> > Check the vmcs12 guest_ia32_debugctl value before loading it, to avoid =
L2
> > being able to load arbitrary values to hardware IA32_DEBUGCTL.
> >=20
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> > arch/x86/kvm/vmx/nested.c | 4 ++++
> > arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0=C2=A0 | 2 +-
> > arch/x86/kvm/vmx/vmx.h=C2=A0=C2=A0=C2=A0 | 2 ++
> > 3 files changed, 7 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index e073e3008b16..0bda6400e30a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3193,6 +3193,10 @@ static int nested_vmx_check_guest_state(struct k=
vm_vcpu *vcpu,
> > 	=C2=A0=C2=A0=C2=A0=C2=A0 CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_=
RSVD))))
> > 		return -EINVAL;
> >=20
> > +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
> > +	=C2=A0=C2=A0=C2=A0=C2=A0 CC(vmcs12->guest_ia32_debugctl & ~vmx_get_su=
pported_debugctl(vcpu, false)))
> > +		return -EINVAL;
> > +
>=20
> How about grouping this check with the one against DR7 a few lines above?

Good idea, will do.
>=20
> > 	if (nested_check_guest_non_reg_state(vmcs12))
> > 		return -EINVAL;
> >=20
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 9953de0cb32a..9046ee2e9a04 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2179,7 +2179,7 @@ static u64 nested_vmx_truncate_sysenter_addr(stru=
ct kvm_vcpu *vcpu,
> > 	return (unsigned long)data;
> > }
> >=20
> > -static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host=
_initiated)
> > +u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initia=
ted)
> > {
> > 	u64 debugctl =3D 0;
> >=20
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 6d1e40ecc024..1b80479505d3 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -413,7 +413,9 @@ static inline void vmx_set_intercept_for_msr(struct=
 kvm_vcpu *vcpu, u32 msr,
> > 		vmx_disable_intercept_for_msr(vcpu, msr, type);
> > }
> >=20
> > +
>=20
> stray newline.
>=20
> > void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
> > +u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initia=
ted);
> >=20
> > /*
> > =C2=A0* Note, early Intel manuals have the write-low and read-high bitm=
ap offsets
> > --=20
> > 2.46.0
> >=20
> >=20
>=20

Best regards,
	Maxim Levitsky


