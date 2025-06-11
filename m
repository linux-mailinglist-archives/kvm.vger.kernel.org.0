Return-Path: <kvm+bounces-49097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D541BAD5E06
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 20:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CC98175296
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 18:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 106A22253E8;
	Wed, 11 Jun 2025 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QFjUXWbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB592253E0
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666054; cv=none; b=do+KfHGZMZEQ1M/ey2zF/VN04CbD4fUWAEf7gRcsNiEnFLSY1kwtjmpGCbwxB1AeWTMMiJij/CE78QyIrpMLNZ0Z6tSFOqYGeODIXEtTnpJjsyzXhQqu2oJHjb0jpCjl7TfMWIJmnAZt/H/TlAPyGUOCH+W2LNV5yMutcxnBsZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666054; c=relaxed/simple;
	bh=L+PQ8oC5SKj2Pvt3GVWZzPVy8l1E6eCuxqGGzJ4Ezoc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bGp6PnnbtUbSQCxV5gs6OjsQqt8h+Ao2DDfDbXbRXBuJJm8qbQCZF5pQ3bDrb09HyS0nCmnxLF37kIL5PLS0YbQBRUDuf2mQemxUDUom+3t7vRu7QjoCCWiHP1YunIjgjtIjMYPcdpJ4hy0K7mmmktQYMu7WA1tCpbuObOSoKI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QFjUXWbQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d29e90b4so135497b3a.0
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 11:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749666052; x=1750270852; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+PQ8oC5SKj2Pvt3GVWZzPVy8l1E6eCuxqGGzJ4Ezoc=;
        b=QFjUXWbQLMPftCuT1i4VEZ6Lj5NFSWGeK8bRb305fIDeKZaauboNIzOo2rWQK/kNOJ
         VW+pLpU2joBY/klW5zV2kHMkdHadngmcVSlaDTgtCvB+FbosmJLaSJyn3v9upmqZL8IO
         kwnJkafTiKB0pAk717NujbU0OQL3vjn+5+Hmp7W+bhGda49y1KkGdDoOqIFrHV6Ub/it
         5iV/D+rLeNTtZPiPBuLzjnaGnOpk7vyGcdyJLR97/qGYlm3mCxkKBzBzG1+KSnXGT4/C
         JjMZsTpGO5EXk+k9meoITmZ3HvzQIKff+A7Nghggwo1RW9tFix1RrGwCuIGt06wdU/xe
         nAow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749666052; x=1750270852;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L+PQ8oC5SKj2Pvt3GVWZzPVy8l1E6eCuxqGGzJ4Ezoc=;
        b=fLkfEdjEm8BrOVKALcpSbHV6v+C6A4q+8V1552qKm7v38WrDxjvELrVkgakywqRCfe
         s+RAmKHPN2vFVPlLOAZluVqIQLIWAiaS8rmEiq/oX9TdZ/gOk7OY3v5+tlHSjpZ98GtV
         USQdzC2cUqwEpeh0Xsu3t2zyH+YO2zYqSoQU/IodL+2P+ARAzxI3HNLLuruhUK5v1g6+
         Mrb/+uDK++SixDbEClSm2ZtL5iY0PgxnOAwwlcKqjRN3tE1cGRA47uvpsxq8vaK2KbGe
         Y+FvUas4sy7hUVYur5ECTF5WuxEV1vvcOMrCuNSBA+0m9CQvgpsD2LWyXhKos0AukPi6
         5dRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPeRUPIeiXnV5g+AWqAamJM32W0hka0M//ngoGW4pqv6Qkj2BY2IRGQJRMQwEehLOLOLM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxzsNKP9WBAjMDQmbZT4e/AibrjxZ3IIiHXpQUqwNB5Ajt9VO87
	p+TTHW6J9V78jYQUi0KcDVTAonJ6zZVi2CdxPnt1hHP0Ux34K6jzSmJJFf49l1lKPuKZ4+vg3Tg
	lwwOj/p+B6pwcqxKS8qES3bYHhg==
X-Google-Smtp-Source: AGHT+IF9dOmPoH3f/Yv0MDUAXNH7QyABROACGGNRSdkVBP3APUAHFDt+InrBgJ0rMfVnQW8MeeLtIRfDXx/Of21iag==
X-Received: from pfnx17.prod.google.com ([2002:aa7:84d1:0:b0:746:27ff:87f8])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:41:b0:1ee:d418:f764 with SMTP id adf61e73a8af0-21f978c4298mr1110324637.38.1749666051578;
 Wed, 11 Jun 2025 11:20:51 -0700 (PDT)
Date: Wed, 11 Jun 2025 11:20:49 -0700
In-Reply-To: <95fe5d24-560b-4c20-b988-6d7072ed2293@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250605153800.557144-1-tabba@google.com> <20250605153800.557144-9-tabba@google.com>
 <ad4157a1-6e38-46df-ae24-76d036972fbc@redhat.com> <95fe5d24-560b-4c20-b988-6d7072ed2293@amd.com>
Message-ID: <diqz4iwmw35q.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v11 08/18] KVM: guest_memfd: Allow host to map guest_memfd pages
From: Ackerley Tng <ackerleytng@google.com>
To: Shivank Garg <shivankg@amd.com>, David Hildenbrand <david@redhat.com>, Fuad Tabba <tabba@google.com>, 
	kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Shivank Garg <shivankg@amd.com> writes:

> On 6/6/2025 2:42 PM, David Hildenbrand wrote:
>> On 05.06.25 17:37, Fuad Tabba wrote:
>>> This patch enables support for shared memory in guest_memfd, including
>>> mapping that memory from host userspace.
>>>
>>> This functionality is gated by the KVM_GMEM_SHARED_MEM Kconfig option,
>>> and enabled for a given instance by the GUEST_MEMFD_FLAG_SUPPORT_SHARED
>>> flag at creation time.
>>>
>>> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
>>> Signed-off-by: Fuad Tabba <tabba@google.com>
>>> ---
>>=20
>> [...]
>>=20
>>> +static bool kvm_gmem_supports_shared(struct inode *inode)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 flags;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return false;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 flags =3D (u64)inode->i_private;
>>=20
>> Can probably do above
>>=20
>> const u64 flags =3D (u64)inode->i_private;
>>=20
>>> +
>>> +=C2=A0=C2=A0=C2=A0 return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>>> +}
>>> +
>
> I agree on using const will have some safety, clarity and optimization.
> I did not understand why don't we directly check the flags like...
>
> return (u64)inode->i_private & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
>
> ...which is more concise.

Imo having an explicit variable name here along with the cast is useful
in reinforcing and repeating that guest_memfd is using inode->i_private
to store flags.

I would rather retain the explicit variable name, and looks like in v11
it was retained.

>
> Thanks,
> Shivank

