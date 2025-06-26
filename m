Return-Path: <kvm+bounces-50860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD8C7AEA3FB
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 19:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 399D556052C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 17:07:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13F828ECF2;
	Thu, 26 Jun 2025 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gs3VZs3x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D172635
	for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 17:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750957647; cv=none; b=RWBN0BmQB+cPt40IdQUSOPVHMf5MnZk4HKReDoJrWnmFeir3USuTAHfOZZmu6bY29dhCb/HgBouzYlt4Y0B3/zShTzwlrEEmS3DUXHZeEYk4s9oP91L2okX5kFTi6Fq7NqmRaUSASbqxGPnzWhpSmb6f7dhcHJFnAEICUDKM3Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750957647; c=relaxed/simple;
	bh=yORxWY8GyHCDmWw6EjGxurFrfqtKyShQg4KxNc629PE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W4gcvWZcCd/Yy3AWRDaKHcNYNN/1m5/NVzpNRLJP7PvZdtnF0yt0D+HggismekN7dMpgVQXbqyi4I1yXDC+PdEm5PT46MGPk+YdVLtkSKLtnpBCINImiTa4FbHyxIQ/oNdVIXJNMmpv6jKZGgNvPAeV4nvFJdQdkINT37i+LhWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gs3VZs3x; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750957644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ElHdV6GNSp1vb3ZduZBLY+3JVTW3tGG64MkP7ptQfnQ=;
	b=gs3VZs3xaG549y5J7KTpEJ8lT8XuhccqzwrD1g5T5/pkPixQ3xAZZQ8NPpapIbdDX//93L
	zlJIv/htgfksmMXbcZqnlit4NhXqIqIQShyG158fil/gQU9V8GkNXrSk9IN4h46q12tc2y
	SlnqyuhM7GJDHyedESYcIEk9KLZDAnA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-446-FomomL14MQi9k-qo_CC3Bw-1; Thu, 26 Jun 2025 13:07:23 -0400
X-MC-Unique: FomomL14MQi9k-qo_CC3Bw-1
X-Mimecast-MFC-AGG-ID: FomomL14MQi9k-qo_CC3Bw_1750957641
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4a7bba869dbso26462231cf.1
        for <kvm@vger.kernel.org>; Thu, 26 Jun 2025 10:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750957641; x=1751562441;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ElHdV6GNSp1vb3ZduZBLY+3JVTW3tGG64MkP7ptQfnQ=;
        b=ijt8vczxwF5t+fdEhRgFBeuc2aUw+rMO+b09lE20eLuGszbx/U03u7dKG6QCkRBZXl
         0Vf4Z8Sb0hFjYtW1vHxTVTpF5LY9PdDW5b9ddX/PKUkXH6yKnOeyqY0fTImpSf3+MOVV
         mVwsBHdvsSDYjoILUljUstI5dZFGeApyQmomEJTylrQzUB09kxH1HtBOKsL07s6NmI0R
         gLiTG6+fGnFvWYdnolZQQfEHqjVPSt0thdNKW36IY1p2iXItLkkyqYbQqrFllI6+Uplc
         qjpzqgYftHNZRcgmb8nsb97vOvQ3jVTLim9ytKKZlBiujnkTJKwp1Jyzdfi2ehKCoIWT
         ZAiw==
X-Forwarded-Encrypted: i=1; AJvYcCW2iPmcxgiS4OvSW4YPtE1MqzQvpSVdSJb1evkvnc7UAjDCbDY38ow6Vhewh1TLfUCmtTY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEatq/pAiIPe/qzG7yT1f0HLYm3eAGprx54kCQAHARFLwgYTqA
	T+pih87kOIOjAJeegIsZr/qO2A/pA7Y15r7TREXodmxWIYbuI6TMKdkUJEHIhbwyvSJoRHYV9Wn
	yPmMT2ituKXRi5Cq3ycKj8sMmFnCXA/rq8kQFvEkOSZVB7oJ2EPKiUg==
X-Gm-Gg: ASbGnct1ZoGzGff8lVF/w+97HS2dUC1Kfd7LZ/3rW6BYG1513xcjaQ0n5y8ukCdshke
	9peKzdn8KBELNwombNaTtDThUxBGV2ozVUCKxFAGa9JZ8G9w2yqIBrtuQPX0+M7WMNz6MZe5umJ
	F2/n+DgG6sn3snzPN4DzBjj7VPAaVI2KJBGSGQcgx0/dnO3iqA7TRmO++a3TIR3ROsvh/RSsoHz
	lGMVMri+MoKXrEpDq4HUb4Pck/7ZA9wWFD0qsaHK+ZQMYQ9rUKN2/iz+92aKGcNMl9y0DxYPU+g
	aQgI+R4bVPhaQJy6Zx3/ppfacaZ1CMJYNNMSWyr5wkJp/VHFNNbBnaywusPdRsGLXQIA+g==
X-Received: by 2002:a05:622a:1e0e:b0:4a7:fbd0:79ab with SMTP id d75a77b69052e-4a7fcaeefa7mr5230551cf.37.1750957641234;
        Thu, 26 Jun 2025 10:07:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHdzeLP542yayViT/FsCNO58LdliV5DNYwwPgnzs1H4kWBjESlC8r6eLcZtY7UMh77NB4oSeQ==
X-Received: by 2002:a05:622a:1e0e:b0:4a7:fbd0:79ab with SMTP id d75a77b69052e-4a7fcaeefa7mr5230051cf.37.1750957640825;
        Thu, 26 Jun 2025 10:07:20 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a7fc10616esm1654931cf.8.2025.06.26.10.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 10:07:20 -0700 (PDT)
Message-ID: <cda50cdf2329b5de76c6cdbf97f248f77ab5a55a.camel@redhat.com>
Subject: Re: [PATCH v6 8/8] KVM: VMX: Preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while running the guest
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>
Date: Thu, 26 Jun 2025 13:07:19 -0400
In-Reply-To: <aF1yni8U6XNkyfRf@google.com>
References: <20250610232010.162191-1-seanjc@google.com>
	 <20250610232010.162191-9-seanjc@google.com>
	 <17b45add9debcc226f515e5d8bb31c508576fa1e.camel@redhat.com>
	 <aF1yni8U6XNkyfRf@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-06-26 at 09:17 -0700, Sean Christopherson wrote:
> On Tue, Jun 24, 2025, mlevitsk@redhat.com=C2=A0wrote:
> > On Tue, 2025-06-10 at 16:20 -0700, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > index c20a4185d10a..076af78af151 100644
> > > --- a/arch/x86/kvm/vmx/vmx.h
> > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > @@ -419,12 +419,25 @@ bool vmx_is_valid_debugctl(struct kvm_vcpu *vcp=
u, u64 data, bool host_initiated)
> > > =C2=A0
> > > =C2=A0static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vc=
pu, u64 val)
> > > =C2=A0{
> > > +	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
> > > +
> > > +	val |=3D vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
> > > =C2=A0	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
> > > =C2=A0}
> > > =C2=A0
> > > =C2=A0static inline u64 vmx_guest_debugctl_read(void)
> > > =C2=A0{
> > > -	return vmcs_read64(GUEST_IA32_DEBUGCTL);
> > > +	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SM=
M;
> > > +}
> > > +
> > > +static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
> > > +{
> > > +	u64 val =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
> > > +
> > > +	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM)=
)
> > > +		return;
> > > +
> > > +	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
> > > =C2=A0}
> >=20
> >=20
> > Wouldn't it be better to use kvm_x86_ops.HOST_OWNED_DEBUGCTL here as we=
ll
> > to avoid logic duplication?
>=20
> Hmm, yeah.=C2=A0 I used DEBUGCTLMSR_FREEZE_IN_SMM directly to avoid a mem=
ory load
> just to get at a constant literal.
>=20
> What about this?=C2=A0 It doesn't completely dedup the logic, but I think=
 it gets us
> close enough to a single source of truth.
>=20
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 26 Jun 2025 09:14:20 -0700
> Subject: [PATCH] KVM: VMX: Add a macro to track which DEBUGCTL bits are
> =C2=A0host-owned
>=20
> Add VMX_HOST_OWNED_DEBUGCTL_BITS to track which bits are host-owned, i.e.
> need to be preserved when running the guest, to dedup the logic without
> having to incur a memory load to get at kvm_x86_ops.HOST_OWNED_DEBUGCTL.
>=20
> No functional change intended.
>=20
> Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> =C2=A0arch/x86/kvm/vmx/main.c |=C2=A0 2 +-
> =C2=A0arch/x86/kvm/vmx/vmx.h=C2=A0 | 12 +++++++-----
> =C2=A02 files changed, 8 insertions(+), 6 deletions(-)
>=20
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 8c6435fdda18..dbab1c15b0cd 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -883,7 +883,7 @@ struct kvm_x86_ops vt_x86_ops __initdata =3D {
> =C2=A0	.vcpu_load =3D vt_op(vcpu_load),
> =C2=A0	.vcpu_put =3D vt_op(vcpu_put),
> =C2=A0
> -	.HOST_OWNED_DEBUGCTL =3D DEBUGCTLMSR_FREEZE_IN_SMM,
> +	.HOST_OWNED_DEBUGCTL =3D VMX_HOST_OWNED_DEBUGCTL_BITS,
> =C2=A0
> =C2=A0	.update_exception_bitmap =3D vt_op(update_exception_bitmap),
> =C2=A0	.get_feature_msr =3D vmx_get_feature_msr,
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 87174d961c85..d3389baf3ab3 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -410,27 +410,29 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *=
vcpu);
> =C2=A0u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_ini=
tiated);
> =C2=A0bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool ho=
st_initiated);
> =C2=A0
> +#define VMX_HOST_OWNED_DEBUGCTL_BITS	(DEBUGCTLMSR_FREEZE_IN_SMM)
> +
> =C2=A0static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, =
u64 val)
> =C2=A0{
> -	WARN_ON_ONCE(val & DEBUGCTLMSR_FREEZE_IN_SMM);
> +	WARN_ON_ONCE(val & VMX_HOST_OWNED_DEBUGCTL_BITS);
> =C2=A0
> -	val |=3D vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM;
> +	val |=3D vcpu->arch.host_debugctl & VMX_HOST_OWNED_DEBUGCTL_BITS;
> =C2=A0	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
> =C2=A0}
> =C2=A0
> =C2=A0static inline u64 vmx_guest_debugctl_read(void)
> =C2=A0{
> -	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~DEBUGCTLMSR_FREEZE_IN_SMM;
> +	return vmcs_read64(GUEST_IA32_DEBUGCTL) & ~VMX_HOST_OWNED_DEBUGCTL_BITS=
;
> =C2=A0}
> =C2=A0
> =C2=A0static inline void vmx_reload_guest_debugctl(struct kvm_vcpu *vcpu)
> =C2=A0{
> =C2=A0	u64 val =3D vmcs_read64(GUEST_IA32_DEBUGCTL);
> =C2=A0
> -	if (!((val ^ vcpu->arch.host_debugctl) & DEBUGCTLMSR_FREEZE_IN_SMM))
> +	if (!((val ^ vcpu->arch.host_debugctl) & VMX_HOST_OWNED_DEBUGCTL_BITS))
> =C2=A0		return;
> =C2=A0
> -	vmx_guest_debugctl_write(vcpu, val & ~DEBUGCTLMSR_FREEZE_IN_SMM);
> +	vmx_guest_debugctl_write(vcpu, val & ~VMX_HOST_OWNED_DEBUGCTL_BITS);
> =C2=A0}
> =C2=A0
> =C2=A0/*
>=20
> base-commit: 6c7ecd725e503bf2ca69ff52c6cc48bb650b1f11
> --
>=20

This looks reasonable.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky


