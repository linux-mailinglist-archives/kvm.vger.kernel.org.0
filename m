Return-Path: <kvm+bounces-44993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6592DAA558F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0705C7B19B5
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F57B2C10B9;
	Wed, 30 Apr 2025 20:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IsJOXCh9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08322D0262
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746045059; cv=none; b=EcGy52hc6ceOHvtGvoujdDWKqiAKjz4PsWSmurBzSNTP0HdBDaLj1BMI/V4iF76gh4poQ7cF/ECO5ra/HOxgGeni99wZJeYlUp0u4gKft0YuW1HixcjCpJ4BAfvQWeAFTbt+pvJ+9CqN0G2VzXNClXfDKSfs472wWGVZF9uNnoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746045059; c=relaxed/simple;
	bh=ICGr00xREAImTG7PalegtjIssnWbLJIbF1OpE+eDNbw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DxH4d/97we2BJOd8HLLAkyQ1iU9qsEoSKUIzeH1T9GJs1s8c8I+NpETfXOLlN+3n02m0RFI+Z0Zy5J+FQEv7bJsLSfa/XwgFC3PFA7lrQJVXE+IXTmQe3Ozo8MZuwBt51zhIDOj8Eb0jXM059CRvVg14v1PFzbBg+TEwFmN4duc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IsJOXCh9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746045056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLCLNjhH9N/SbhZgwe55OZ5mfyV+uMRJ+/FIl8sp4MU=;
	b=IsJOXCh9cP6iZ6esTZoYrdWmZZ6RubIAjGnkGban8NHyWNbBLTFL2T4ThjX8ShWKD6X7fk
	lI1huOipbC+V1U2bMJCATP8e6s5Y+sHInD5kfaTELjf34/cckwBsYmh+oQPAJzGwo3nc0o
	5ISgXclEfb78/v4tmUxFTRBoLy/Gizg=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-NBcnqr3fMwaDTOQ4jD0IlQ-1; Wed, 30 Apr 2025 16:30:55 -0400
X-MC-Unique: NBcnqr3fMwaDTOQ4jD0IlQ-1
X-Mimecast-MFC-AGG-ID: NBcnqr3fMwaDTOQ4jD0IlQ_1746045055
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6e8f184b916so7360756d6.3
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 13:30:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746045055; x=1746649855;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kLCLNjhH9N/SbhZgwe55OZ5mfyV+uMRJ+/FIl8sp4MU=;
        b=t8c5Yp7BUa28E23CihAsGtSGHrbBj0YHCglsMw53WW3HJrHcBV6v7TxfBBDSbCP3p3
         d2PmNbz8E7fBRF59fLJs694ve0OfjNB6ZODDHr8KBycFcbyJubrQoU2rIjyIAugnrbXR
         PMOBjQOIqT/1hKYYddendj4V8jw00d6oN6XvOvbapHIvWq671yKu0LiKdZnwNMAnIHMg
         FcovfSXrD/q+NQO5LvoBXu8VSfRkxJmYaX96QHgFyvy/BdbgH3TRPLtOuazCUccGKc3v
         i9lw7Y6vs+6A9ivS6Lu/81HXDT2wfvkIbqvq99nwz2DHovgqfeqwCtJTOisd7IpIV5Jd
         ECkw==
X-Gm-Message-State: AOJu0YxZedJPPKAM/MmIo2pGOpQAvceOJDaBMLLKZa21ySv06AVu5nj9
	h0oNkpV1RBDOTO8DaQswhdURepuGuyjTNLtM9ckTGpphQYl6OfSm0KJGGfCiUM75o8CEsc9mWVU
	tqRYR/TVWvypRVgiC9mCAbAjoI9wH9IBcabRCielzwgGqiZ955RkmhuQyPVL1Fs7B0+bOqtD4cc
	r7TwhVkhVn24P4UC+ArErHiTU5DueyZzdojA==
X-Gm-Gg: ASbGncurAzFwUkCXmiEuPsmUvSG5cRQdivJMd9qbIFirdjdzZB3Q3HgAcEUlCglE1zI
	pBiM8cSUdt6EtX/QZDEkjNiejsUex/OfvE5aEtVyXcVwbeLm+2nQHsfsfiTyKR54TBcWX4QK81f
	xp1WF/o0Dde/julcYerKGD0iqWcViJmVu+D8IOFdYR4r7m5Iz67fUoGgScmehon/ehzNKYAAlGA
	KwlWQVwuFU8WVGTrg++tyGR0pZmttQ4Fe0reXLjPp3oXJsjrJbCvmPD/XnjBXO9/e359ORlN36S
	N0CBmcoSYU5/3xz5l3UHA4nVynvJ+OCtf7zF61aNGpEOsX1FSHRoqEJ11fg=
X-Received: by 2002:a05:6214:2584:b0:6e8:fb92:dffa with SMTP id 6a1803df08f44-6f4fe081236mr60226686d6.25.1746045054904;
        Wed, 30 Apr 2025 13:30:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFqMC1VAUYkFR8BRk72B9YM6tHcI7coSFQe+I2l2BvKOrJizso3ayI0TGKXXExNYQxM53jAuA==
X-Received: by 2002:a05:6214:2584:b0:6e8:fb92:dffa with SMTP id 6a1803df08f44-6f4fe081236mr60225826d6.25.1746045054231;
        Wed, 30 Apr 2025 13:30:54 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f4fe70a277sm12416546d6.55.2025.04.30.13.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 13:30:53 -0700 (PDT)
Message-ID: <53a26378fce90c8bbfa57a582992324560aa0274.camel@redhat.com>
Subject: Re: [PATCH v3 0/4] KVM: lockdep improvements
From: mlevitsk@redhat.com
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Randy Dunlap
 <rdunlap@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Will Deacon
 <will@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Kunkun Jiang
 <jiangkunkun@huawei.com>, Jing Zhang <jingzhangos@google.com>, Albert Ou
 <aou@eecs.berkeley.edu>, Keisuke Nishimura <keisuke.nishimura@inria.fr>, 
 Anup Patel <anup@brainfault.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Waiman Long <longman@redhat.com>,  Boqun Feng
 <boqun.feng@gmail.com>, linux-arm-kernel@lists.infradead.org, Peter
 Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Paul Walmsley <paul.walmsley@sifive.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Sebastian Ott
 <sebott@redhat.com>, Andre Przywara <andre.przywara@arm.com>, Ingo Molnar
 <mingo@redhat.com>, Alexandre Ghiti <alex@ghiti.fr>, Bjorn Helgaas
 <bhelgaas@google.com>, Palmer Dabbelt <palmer@dabbelt.com>, Joey Gouly
 <joey.gouly@arm.com>, Borislav Petkov <bp@alien8.de>, Sean Christopherson
 <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, Alexander Potapenko
 <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 linux-kernel@vger.kernel.org,  linux-riscv@lists.infradead.org, Shusen Li
 <lishusen2@huawei.com>,  kvm-riscv@lists.infradead.org
Date: Wed, 30 Apr 2025 16:30:51 -0400
In-Reply-To: <20250430202311.364641-1-mlevitsk@redhat.com>
References: <20250430202311.364641-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-04-30 at 16:23 -0400, Maxim Levitsky wrote:
> This is	a continuation of my 'extract
> lock_all_vcpus/unlock_all_vcpus'
> patch series.
>=20
> Implement the suggestion of using lockdep's "nest_lock" feature
> when locking all KVM vCPUs by adding mutex_trylock_nest_lock() and
> mutex_lock_killable_nest_lock() and use these functions	in the
> implementation of the
> kvm_trylock_all_vcpus()/kvm_lock_all_vcpus()/kvm_unlock_all_vcpus().
>=20
> Those changes allow removal of a custom workaround that was needed to
> silence the lockdep warning in the SEV code and also stop lockdep
> from
> complaining in case of ARM and RISC-V code which doesn't include the
> above
> mentioned workaround.
>=20
> Finally, it's worth noting that this patch series removes a fair
> amount of duplicate code by implementing the logic in one place.
>=20
> Best regards,
> 	Maxim Levitsky
>=20
> Maxim Levitsky (4):
> =C2=A0 arm64: KVM: use mutex_trylock_nest_lock when locking all vCPUs
> =C2=A0 RISC-V: KVM: switch to kvm_lock/unlock_all_vcpus
> =C2=A0 locking/mutex: implement mutex_lock_killable_nest_lock
> =C2=A0 x86: KVM: SEV: implement kvm_lock_all_vcpus and use it
>=20
> =C2=A0arch/arm64/include/asm/kvm_host.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 3=
 --
> =C2=A0arch/arm64/kvm/arch_timer.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +-
> =C2=A0arch/arm64/kvm/arm.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 43 ------------=
----
> =C2=A0arch/arm64/kvm/vgic/vgic-init.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 |=C2=A0 4 +-
> =C2=A0arch/arm64/kvm/vgic/vgic-its.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 |=C2=A0 8 +--
> =C2=A0arch/arm64/kvm/vgic/vgic-kvm-device.c | 12 ++---
> =C2=A0arch/riscv/kvm/aia_device.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 | 34 +------------
> =C2=A0arch/x86/kvm/svm/sev.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 72 ++----------------------=
-
> --
> =C2=A0include/linux/kvm_host.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 ++
> =C2=A0include/linux/mutex.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 17 +++++--
> =C2=A0kernel/locking/mutex.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 7 +--
> =C2=A0virt/kvm/kvm_main.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 59 +++++++++=
+++++++++++++
> =C2=A012 files changed, 100 insertions(+), 167 deletions(-)
>=20
> --=20
> 2.46.0
>=20
>=20


I forgot to send first patch in the series, resending.

Best regards,
	Maxim Levitsky


