Return-Path: <kvm+bounces-47299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DF8C9ABFBA2
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 18:51:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 194FF1BC5153
	for <lists+kvm@lfdr.de>; Wed, 21 May 2025 16:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D499823956E;
	Wed, 21 May 2025 16:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KMT/BI8t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9892222C8
	for <kvm@vger.kernel.org>; Wed, 21 May 2025 16:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747846260; cv=none; b=aVHVO9hUjempO+FvMbxyrkcoE9ZDGzRt8cfTTesqs207NCaF0k23Re9vrk2FCx3zflNC38/uuKgPc2FEqTGDJiWNm3TLEMuQ4BrieI+/QrD9Qm0AOa0acGoEUElZ5fyqUPXJRWb4RWDUhfmvWOevdr0QtURxZ0bqvsmVRlbf4Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747846260; c=relaxed/simple;
	bh=ZqmTp0vdqeL6cANi7f/FJrj8wXnKnJZKTFI5l8ldFmM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XzvlUNK70fxJ/4WzMU4jCdgC6HMb8VxmZE+aSD81N4areUm/M8JJ4CmclTv10R7vcw543MpaZWaj8tPf49EDHiFvO9CvHQEZYbtMYlXhcRXxW2q+BDUVNNLZ1qL59lZ/+CXe9C/mQUNHB+0dGO+BiP6o50+aRyHITB0KFkuSiuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KMT/BI8t; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747846251;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UjAixvvVyD2iBD9dJkuzfmZPAxf2QpS0W+zdD24rYYk=;
	b=KMT/BI8t7zJ2/Q1Uj2CHC+XAXsbdoCSL6ypETBEgLigzsuSjpAqaUNOh2E25VAZYzDLflj
	Il4P1Sig2J7A/vqqRfR4teRwUxTfD1RnBl7dciQ/cb3I9ok5Q1/JmiVW7KnrZFa5BLw0yq
	W2U/NXGsG+Fboa2JNjP4SA8LCktUKxA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-263-REMdvlcWOHaJkuKpJFtpPA-1; Wed, 21 May 2025 12:50:50 -0400
X-MC-Unique: REMdvlcWOHaJkuKpJFtpPA-1
X-Mimecast-MFC-AGG-ID: REMdvlcWOHaJkuKpJFtpPA_1747846250
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7cabd21579eso1238972785a.3
        for <kvm@vger.kernel.org>; Wed, 21 May 2025 09:50:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747846250; x=1748451050;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UjAixvvVyD2iBD9dJkuzfmZPAxf2QpS0W+zdD24rYYk=;
        b=YKChZYuPYVTemEl8uEqXaK3F+ZBwAePfwlb7mEsgdYLSCR9ZMkJRUT/cuXUSVuQsKO
         EceMGFrUhH6ctd4qLQqrlSx/C2QI3+8vgdjm/5TY6cL/jckrJjrEvTROeitYEHwdxN7r
         q0bGD4Rzv+PzIraZALWGpmlIz5VPk8K1EmuNZjfh9kPjME68a9jgGuifENnrRMWdDmJ8
         NlQ7cnbzDs/6FR+eLkXUo01joWXnPkBDyleV6f+fdck5Awv+Yzqqa1f38KFhoywPrEIy
         GQH5N/QBT0CI5fT0G0hgP5nQvPg+e2tGxo3Zteb4jTjdQC0gCo96k9aJ+xqSYZOwZpEx
         hyZg==
X-Gm-Message-State: AOJu0Ywc+9Z66Z/Vs3NZdKQgW6SvSsqI3F21ChEQyq1Zh6cjlQS2QNzc
	kaxu4GiRTAPzjQ07is41iotZwvKr87ZumU1QrdLqzTvCQDBQE0M8faa4k9New5ckws+AvCioAUi
	r7c0lkT/cCdaY48hyiIzANd5VwZhB6MQIh5Lj1bp9sks4YANnxiV+eg==
X-Gm-Gg: ASbGncu3/PNsehXK4HjCuzdi6QQz6ZFrRkUSOZyaUzE2M+rmY51+v2Pp+CEI9++dtN9
	1I564XMF41zqjmmm8PPK4+b70OFV4WUZX8jTG1s+EyknkwaqA/STqq8hqkl1PP3l/0YaBG03/9X
	+KBO62xjs2I9zV/TUot41t92E+8cras5p4iWTGU+fVZynFMF1wDT5GX63IV5fe3AUmFTxK/Gdf0
	EvqneB4y/+UzQDmVaSOEhtwVXsFY9QCsOSNPhUaOgIZNzGVhIpc7O7TVhRUkGj6DyE/h4tONITm
	90qe1b0uIC7iooMIejYi09NRBZnHhpsD4WAzbwFw/esmScZQdyG1TFw7NT0=
X-Received: by 2002:a05:620a:4454:b0:7c5:a29e:3477 with SMTP id af79cd13be357-7cd467affddmr3790930385a.53.1747846249856;
        Wed, 21 May 2025 09:50:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHX3Vc1M1uoBzgve6vIVsbAt/e/9oWjTfkwdOyCXc0Sv8G9dYFq/4+D0r5mWMxD9yGbILZnLQ==
X-Received: by 2002:a05:620a:4454:b0:7c5:a29e:3477 with SMTP id af79cd13be357-7cd467affddmr3790927385a.53.1747846249549;
        Wed, 21 May 2025 09:50:49 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd467d7e65sm895887785a.35.2025.05.21.09.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 May 2025 09:50:49 -0700 (PDT)
Message-ID: <dfd52ae3c91f28d31ef1aa176a1aee4a4b596df2.camel@redhat.com>
Subject: Re: [PATCH v4 3/4] x86: nVMX: check vmcs12->guest_ia32_debugctl
 value given by L2
From: mlevitsk@redhat.com
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Sean
 Christopherson <seanjc@google.com>, Borislav Petkov <bp@alien8.de>,
 x86@kernel.org, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Paolo
 Bonzini <pbonzini@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 21 May 2025 12:50:48 -0400
In-Reply-To: <aC0fOC8IiQJShYOe@intel.com>
References: <20250515005353.952707-1-mlevitsk@redhat.com>
	 <20250515005353.952707-4-mlevitsk@redhat.com> <aCaxlS+juu1Rl7Mv@intel.com>
	 <d9ea18ac1148c9596755c4df8548cdb8394f2ee0.camel@redhat.com>
	 <fababe6628c448a4aa96e1ad47ad862eddf90c24.camel@redhat.com>
	 <aC0fOC8IiQJShYOe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-05-21 at 08:32 +0800, Chao Gao wrote:
> On Tue, May 20, 2025 at 05:48:44PM -0400, mlevitsk@redhat.com=C2=A0wrote:
> > On Fri, 2025-05-16 at 10:50 -0400, mlevitsk@redhat.com=C2=A0wrote:
> > > On Fri, 2025-05-16 at 11:31 +0800, Chao Gao wrote:
> > > > On Wed, May 14, 2025 at 08:53:52PM -0400, Maxim Levitsky wrote:
> > > > > Check the vmcs12 guest_ia32_debugctl value before loading it, to =
avoid L2
> > > > > being able to load arbitrary values to hardware IA32_DEBUGCTL.
> > > > >=20
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > > > arch/x86/kvm/vmx/nested.c | 4 ++++
> > > > > arch/x86/kvm/vmx/vmx.c=C2=A0=C2=A0=C2=A0 | 2 +-
> > > > > arch/x86/kvm/vmx/vmx.h=C2=A0=C2=A0=C2=A0 | 2 ++
> > > > > 3 files changed, 7 insertions(+), 1 deletion(-)
> > > > >=20
> > > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.=
c
> > > > > index e073e3008b16..0bda6400e30a 100644
> > > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > > @@ -3193,6 +3193,10 @@ static int nested_vmx_check_guest_state(st=
ruct kvm_vcpu *vcpu,
> > > > > 	=C2=A0=C2=A0=C2=A0=C2=A0 CC((vmcs12->guest_bndcfgs & MSR_IA32_BN=
DCFGS_RSVD))))
> > > > > 		return -EINVAL;
> > > > >=20
> > > > > +	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) =
&&
> > > > > +	=C2=A0=C2=A0=C2=A0=C2=A0 CC(vmcs12->guest_ia32_debugctl & ~vmx_=
get_supported_debugctl(vcpu, false)))
> > > > > +		return -EINVAL;
> > > > > +
> > > >=20
> > > > How about grouping this check with the one against DR7 a few lines =
above?
> > >=20
> > > Good idea, will do.
> >=20
> > Besides the above change, is there anything else to change in this patc=
hset?
> > If not I'll sent a new version soon.
>=20
> ...
>=20
> > > > > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > > > > index 6d1e40ecc024..1b80479505d3 100644
> > > > > --- a/arch/x86/kvm/vmx/vmx.h
> > > > > +++ b/arch/x86/kvm/vmx/vmx.h
> > > > > @@ -413,7 +413,9 @@ static inline void vmx_set_intercept_for_msr(=
struct kvm_vcpu *vcpu, u32 msr,
> > > > > 		vmx_disable_intercept_for_msr(vcpu, msr, type);
> > > > > }
> > > > >=20
> > > > > +
> > > >=20
> > > > stray newline.
>=20
> Can you remove this newline? (not sure if you've already noticed this)
Sure thing!

>=20
> Also, the shortlogs for patches 3-4 don't follow the convention. They sho=
uld be
> "KVM: nVMX" and "KVM: VMX". With these fixed,

Sure thing - I wish it was more consistent but you are right.=20



>=20
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>=20

Thank you very much!
Best regards,
	Maxim Levitsky


