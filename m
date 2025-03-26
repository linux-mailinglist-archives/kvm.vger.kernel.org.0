Return-Path: <kvm+bounces-42035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0979A71A09
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 16:18:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A3291894FD2
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 15:10:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C75E1F3BB9;
	Wed, 26 Mar 2025 15:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PncpYpop"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEE31E1E0D
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743001796; cv=none; b=lqxrEYTVPXBw9IghEcBHd5VdV6rd3Ho1XcltQYL++aRCJ4KKe4aaCXOb3CzSsFrNbTy0/xq4YYEtbzNOMzs6QFg5+yoq5Yc3XQodwSQutuRUnF8okh+lvXHletrQY9/WtNnoRuRHIKEH7rYd0p8BycqlpZysPeneNHVWrHX63uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743001796; c=relaxed/simple;
	bh=LvPznTTQMeL5HHEqwAw5mQEy+wnALOSIcXn/tKHfL/k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tbK8xk9gzhWuvuSc+9tl3xovXUGmtp20INaM0zfExRjYKwj5jUAeHO40ObmS2skD4ZcNiYqHxq7nEJ/mWfz71+CCvmG7HLu2VabXxOilq8OIVch1MziYBZhMBF8SVUw4ZEJL5fyb977jIoOifwzofqJBZJ1bSp1KCST74zA2ge0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PncpYpop; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff6aaa18e8so10722703a91.1
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 08:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743001794; x=1743606594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkOqbfERQdrw9bi6YeAMxlXl0dXPXrj8aIpOruTKiGo=;
        b=PncpYpopJN6KMaAn5otdzkkkvbbKBHwBdmeiUgMDdjQSkPMT3QtY4WMpoUHEhjIjRq
         PHjvi+G963jnXV7xnE0KLVKGDSvU3hTOffNDLoMB58ULFr0fGx6AP7TjosouaKhwq61y
         27aCifCGEwzmMzYVPfTiwguPV2jD35atRzkO1k8v19POPXOOyoz8guEyOyfSdx6/d9U7
         jQ9FGaurcqE0J6bXt4eTW7T7rIMhRqMC2tgHbyPgiyPPd0p/AjpJM3tboJDRZ6nADTcA
         SP9MjvWuHyHJBmZ3FaIuKz4LhlHLCkk8McmSOrvOiIDj4zDVIoqzfymAMaDaNZ3eRuzG
         OInw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743001794; x=1743606594;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FkOqbfERQdrw9bi6YeAMxlXl0dXPXrj8aIpOruTKiGo=;
        b=h9M+tGzRUkRBhfhWmuk9+NaPFOfBlkuUD3HpfuIA3V20Hif+npziMv0eYBkryh9va5
         gWmL0nDcLLJl/k+OpMSztY1Pb31GrpeXdtprDclqm2v0+PSJzBWzWT8egGkKFgpcKX95
         UVTa9Mtn7mEhkkyh50iFMXSmrX2DXD13BbDBNv01Lxk1vTYNxe7pYD07RbLyVqM+kQO+
         KzbB1i969i8Jvepu4nFoDvJ7EH23oL6yGRNDMoJYY4BKZcQcXhAnSUPzBIlQg8dj3z6l
         bSxzLKXhsxO6HEa49LcjG5JTi+z1F2zCJUDDMMq4mwMmxU5EfkjbppBGx9vD9mvFnua4
         ndLA==
X-Forwarded-Encrypted: i=1; AJvYcCU14zh9f+w8EFr0beOKJsEr7pqt81MxOiL1GMEuXuWnRS1PafkW2D75dVZHjTiRCDv9tgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUQTnwQhCGbxr7oqoHArUu6h1Ygixjlku9qBHslaEN/n/Z9FfE
	6A0ug4OCBYcthuXT15q8zxD5ogiiHP86rf/ZxvNPF9SzdEFKY3Olmt8vj1r0ueCt44B2UWNAGHL
	3Fg==
X-Google-Smtp-Source: AGHT+IGaEwe4msZVS1TKiQxfZo1Kl1wf0fVTRtC8U+SRmC7/tJzqPC3DpOBHSnHN51MOxacJYlojeP9LBP0=
X-Received: from pfbch5.prod.google.com ([2002:a05:6a00:2885:b0:730:96d1:c213])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9217:b0:1f5:6a1a:329b
 with SMTP id adf61e73a8af0-1fea2f635e9mr263486637.32.1743001794420; Wed, 26
 Mar 2025 08:09:54 -0700 (PDT)
Date: Wed, 26 Mar 2025 08:09:53 -0700
In-Reply-To: <c220d043-2314-85bb-e99d-dc2c609aa739@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250311074737.3160546-1-maobibo@loongson.cn> <c220d043-2314-85bb-e99d-dc2c609aa739@loongson.cn>
Message-ID: <Z-QYwWxhBH_nvmWH@google.com>
Subject: Re: [RFC V2] LoongArch: KVM: Handle interrupt early before enabling irq
From: Sean Christopherson <seanjc@google.com>
To: bibo mao <maobibo@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025, bibo mao wrote:
> Hi Paolo, Sean
>=20
> This idea comes from x86, do you have any guidance or suggestion about it=
?
>=20
> Also I notice that there is such irq_enable()/irq_disable() pair on x86, =
I
> do not know why it is so.

Because on AMD (SVM), IRQ VM-Exits don't consume the IRQ, i.e. the exit is =
purely
a notification.  KVM still needs to enable IRQs to actually handle the pend=
ing IRQ.
And if the IRQ that triggered VM-Exit is for the host's tick, then it's des=
irable
to handle the tick IRQ before guest_timing_exit_irqoff() so that the timesl=
ice is
accounted to the guest, not the host (the tick IRQ arrived while the guest =
was
active).

On Intel (VMX), KVM always runs in a mode where the VM-Exit acknowledge/con=
sumes
the IRQ, and so KVM _must_ manually call into the appropriate interrupt han=
dler.

>     local_irq_enable();
>     ++vcpu->stat.exits;
>     local_irq_disable();
>     guest_timing_exit_irqoff();
>     local_irq_enable();
>=20
> Regards
> Bibo Mao
>=20
> On 2025/3/11 =E4=B8=8B=E5=8D=883:47, Bibo Mao wrote:
> > If interrupt arrive when vCPU is running, vCPU will exit because of
> > interrupt exception. Currently interrupt exception is handled after
> > local_irq_enable() is called, and it is handled by host kernel rather
> > than KVM hypervisor. It will introduce extra another interrupt
> > exception and then host will handle irq.
> >=20
> > If KVM hypervisor detect that it is interrupt exception, interrupt
> > can be handle early in KVM hypervisor before local_irq_enable() is
> > called.

The correctness of this depends on how LoongArch virtualization processes I=
RQs.
If the IRQ is consumed by the VM-Exit, then manually handling the IRQ early=
 is
both optimal and necessary for correctness.  If the IRQ is NOT consumed by =
the
VM-Exit, then manually calling the interrupt handler from KVM will result i=
n every
IRQ effectively happening twice: once on the manual call, and against when =
KVM
enables IRQs and the "real" IRQ fires.

