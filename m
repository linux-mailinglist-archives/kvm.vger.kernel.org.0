Return-Path: <kvm+bounces-61528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21082C2219A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 937B23AA58C
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 19:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4FE333730;
	Thu, 30 Oct 2025 19:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLyJh0U0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0358433345B
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 19:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761854263; cv=none; b=Tq9y2Oaux35+/L+EP7aKTx3NziD2jczKBK7wGwfMXAjFm2QAIsuvL7TohfArRpc0SMuaIaf/imIpHBZ+swVS0iHPjbCnBy03lfWKUKU/YTluk8Twh3DK65cWnj4wotcm0uQ/byVS1d7lZMQUs28nmIM7IQprAnqzn8dAS/S01Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761854263; c=relaxed/simple;
	bh=2tPW5kS5oYSFrmUrNHC7X2sX8Zt+2D8tcaV7A/DfPsY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jz0YNPQnd2D2oreHdjoZy7ofRy8R8NzlQ3Tckavl6nBZ+rjgMT7GG//zEYupixflK6pOpOYJuxKwGRpguD84desDfHjtzJYUnrX78pw2MYQ5fx9BVAgCt2DNGeQmxL0cbOCdSpGvditZ26ZRQEUBZfGOrmbQTuNx0Fp2LQ5Gj7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CLyJh0U0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761854260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wHUvxh29plVfP0UDVNFA7MwNdgWEnsNAEpe26M+T+AM=;
	b=CLyJh0U01qY744Z5dClW0SefMeH8VC06zdRMRLIVjEqDhR3qBttnpGUf8USA2wi9ZlvfvW
	HeoryVwAyxbQdZTXzb0bU1i+iv1YRqs55xfT84qvG/P0XRhfmf1/sxQu/1G6wlNvQaQGUN
	+snE4X6u6h/v1BngL6RMHd1nRJLzAZo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-sE5-Ef47MmyobhCQuka5lw-1; Thu, 30 Oct 2025 15:57:39 -0400
X-MC-Unique: sE5-Ef47MmyobhCQuka5lw-1
X-Mimecast-MFC-AGG-ID: sE5-Ef47MmyobhCQuka5lw_1761854259
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8a24116e89eso163306285a.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 12:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761854259; x=1762459059;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wHUvxh29plVfP0UDVNFA7MwNdgWEnsNAEpe26M+T+AM=;
        b=irdTBtTh8uRrxMPl3hYRzzajOZ0fUS5rxz4kHrH8Zx4RjoJ2yD0rKmRgOULZDOsbrY
         Ieg7ynW/6tan7SdJ9r0NDRsev6RZKZYd4cNz4Y/p2fIoR/EakuXa5LmoOlktqiCFu+/3
         IdG3nebaAxMSsYq4RnRD7yDUYYzmPdxqROxEYiFpgIbAb+1BfsesZOB0ruxBBQEI0hSF
         oFbPALlzz0x49OwecfCtsgvWFdyaJj78tCc95WsMBMHExKTByHm1IQksTdXgt+pk1dIi
         RNp5SHUhicgdOeK7hbjcHYCLyd9lndgGBv653k1rA9W1+HFUEBRLS3faRXA2VYUaYSNb
         Vnjg==
X-Gm-Message-State: AOJu0Yyq+YshPqCohvVi8hLPFcLbUfZb6gedddqkbkAqGhwM3PDyQiIl
	NdiIMpZ78fzQneWXjtMPhhJ20uUsun73jAuCe193sG1FbBn4F+BZDKB0DYIuXqjg2Vg2ufd9iPG
	1/WGVWxhJH0GNQ7lgIDg6iY41wf4d6YntokUGQoKcaY8ziEt/Hcsi9w==
X-Gm-Gg: ASbGncu5ZUppKiqqmZiScjFlyA9t8NaLWXcUdICu+TrhJKUArChoPvyLcwgA3TjQM7a
	jczV6fXIwSLqN1nLFQVGuUIifW6JKYHzRCuKm6Luodfgit8NLxTffUt9uRHrlvmm7sOL213/8xX
	XOeerTk/rBbjvrK3Nu43QC3aMIUXf7EkGBDXVU7q0+wufos/HpS8nFtloGuqMO2TTdFohic82e1
	HCZc1oPts4B2l4FP3hp7Jb4A0PFpvrKI1hFmosGJp5AdD52oXmFI70X9a7FkcvNzansOoqiFZVx
	glr/H1RpfCi5Y6bFTe7/0LEuxK04FQ9M2UzziK4UaM+nSWYOmhLjZnWoln8SDQvMPROiFwL/dX7
	3AjlEuOEfKaw4vxqtwXRhbk3tH6FBpEt+35SsW7ShxmGZ5Q==
X-Received: by 2002:a05:620a:4493:b0:892:ce2b:f869 with SMTP id af79cd13be357-8ab992a3e89mr91367185a.13.1761854259001;
        Thu, 30 Oct 2025 12:57:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJRwI3hew+S/hBhXzDIhRfd47T9VKrIoMXn5a19Jfc4jmsisyXOlLOhkkpn0luwcThLRLceg==
X-Received: by 2002:a05:620a:4493:b0:892:ce2b:f869 with SMTP id af79cd13be357-8ab992a3e89mr91364485a.13.1761854258578;
        Thu, 30 Oct 2025 12:57:38 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eba37d72ecsm121506711cf.9.2025.10.30.12.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Oct 2025 12:57:38 -0700 (PDT)
Message-ID: <c9b893a643cea2ffd4324c25b9d169f920db1ad4.camel@redhat.com>
Subject: Re: [PATCH 2/3] KVM: x86: Fix a semi theoretical bug in
 kvm_arch_async_page_present_queued
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin"
	 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner
	 <tglx@linutronix.de>, x86@kernel.org, Borislav Petkov <bp@alien8.de>, 
	linux-kernel@vger.kernel.org
Date: Thu, 30 Oct 2025 15:57:37 -0400
In-Reply-To: <aP-JKkZ400TERMSy@google.com>
References: <20250813192313.132431-1-mlevitsk@redhat.com>
	 <20250813192313.132431-3-mlevitsk@redhat.com>
	 <7c7a5a75-a786-4a05-a836-4368582ca4c2@redhat.com>
	 <aNLtMC-k95pIYfeq@google.com>
	 <23f11dc1-4fd1-4286-a69a-3892a869ed33@redhat.com>
	 <aNMpz96c9JOtPh-w@google.com> <aP-JKkZ400TERMSy@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-2.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-27 at 08:00 -0700, Sean Christopherson wrote:
> On Tue, Sep 23, 2025, Sean Christopherson wrote:
> > On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> > > On 9/23/25 20:55, Sean Christopherson wrote:
> > > > On Tue, Sep 23, 2025, Paolo Bonzini wrote:
> > > > > On 8/13/25 21:23, Maxim Levitsky wrote:
> > > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > > index 9018d56b4b0a..3d45a4cd08a4 100644
> > > > > > --- a/arch/x86/kvm/x86.c
> > > > > > +++ b/arch/x86/kvm/x86.c
> > > > > > @@ -13459,9 +13459,14 @@ void kvm_arch_async_page_present(struc=
t kvm_vcpu *vcpu,
> > > > > > =C2=A0=C2=A0 void kvm_arch_async_page_present_queued(struct kvm=
_vcpu *vcpu)
> > > > > > =C2=A0=C2=A0 {
> > > > > > -	kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > > > > > -	if (!vcpu->arch.apf.pageready_pending)
> > > > > > +	/* Pairs with smp_store_release in vcpu_enter_guest. */
> > > > > > +	bool in_guest_mode =3D (smp_load_acquire(&vcpu->mode) =3D=3D =
IN_GUEST_MODE);
> > > > > > +	bool page_ready_pending =3D READ_ONCE(vcpu->arch.apf.pageread=
y_pending);
> > > > > > +
> > > > > > +	if (!in_guest_mode || !page_ready_pending) {
> > > > > > +		kvm_make_request(KVM_REQ_APF_READY, vcpu);
> > > > > > =C2=A0=C2=A0=C2=A0		kvm_vcpu_kick(vcpu);
> > > > > > +	}
> > > > >=20
> > > > > Unlike Sean, I think the race exists in abstract and is not benig=
n
> > > >=20
> > > > How is it not benign?=C2=A0 I never said the race doesn't exist, I =
said that consuming
> > > > a stale vcpu->arch.apf.pageready_pending in kvm_arch_async_page_pre=
sent_queued()
> > > > is benign.
> > >=20
> > > In principle there is a possibility that a KVM_REQ_APF_READY is misse=
d.
> >=20
> > I think you mean a kick (wakeup or IPI), is missed, not that the APF_RE=
ADY itself
> > is missed.=C2=A0 I.e. KVM_REQ_APF_READY will never be lost, KVM just mi=
ght enter the
> > guest or schedule out the vCPU with the flag set.
> >=20
> > All in all, I think we're in violent agreement.=C2=A0 I agree that kvm_=
vcpu_kick()
> > could be missed (theoretically), but I'm saying that missing the kick w=
ould be
> > benign due to a myriad of other barriers and checks, i.e. that the vCPU=
 is
> > guaranteed to see KVM_REQ_APF_READY anyways.
> >=20
> > E.g. my suggestion earlier regarding OUTSIDE_GUEST_MODE was to rely on =
the
> > smp_mb__after_srcu_read_{,un}lock() barriers in vcpu_enter_guest() to e=
nsure
> > KVM_REQ_APF_READY would be observed before trying VM-Enter, and that if=
 KVM might
> > be in the process of emulating HLT (blocking), that either KVM_REQ_APF_=
READY is
> > visible to the vCPU or that kvm_arch_async_page_present() wakes the vCP=
U.=C2=A0 Oh,
> > hilarious, async_pf_execute() also does an unconditional __kvm_vcpu_wak=
e_up().
> >=20
> > Huh.=C2=A0 But isn't that a real bug?=C2=A0 KVM doesn't consider KVM_RE=
Q_APF_READY to be a
> > wake event, so isn't this an actual race?
> >=20
> > =C2=A0 vCPU=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 async #PF
> > =C2=A0 kvm_check_async_pf_completion()
> > =C2=A0 pageready_pending =3D false
> > =C2=A0 VM-Enter
> > =C2=A0 HLT
> > =C2=A0 VM-Exit
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 kvm_make_request(KVM_REQ_APF_READY, vcpu)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 kvm_vcpu_kick(vcpu)=C2=A0 // nop as the vCPU isn't blocking=
, yet
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 __kvm_vcpu_wake_up() // nop for the same reason
> > =C2=A0 vcpu_block()
> > =C2=A0 <hang>
> >=20
> > On x86, the "page ready" IRQ is only injected from vCPU context, so AFA=
ICT nothing
> > is guarnateed wake the vCPU in the above sequence.
>=20
> Gah, KVM checks async_pf.done instead of the request.=C2=A0 So I don't th=
ink there's
> a bug, just weird code.

Hi!

Note that I posted a v2 of this patch series. Do I need to drop this patch =
or its better to keep it
(the patch should still be correct, but maybe an overkill I think).

What do you think?=C2=A0

Can we have the patch 3 of the v2 merged as it fixes an real issue, which a=
ctually
causes random and hard to debug failures?

Best regards,
	Maxim Levitsky

>=20
> =C2=A0 bool kvm_vcpu_has_events(struct kvm_vcpu *vcpu)
> =C2=A0 {
> 	if (!list_empty_careful(&vcpu->async_pf.done))=C2=A0 <=3D=3D=3D
> 		return true;
>=20


