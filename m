Return-Path: <kvm+bounces-53135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F46B0DF2B
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6ACE7585766
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 14:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A470F2EAD1C;
	Tue, 22 Jul 2025 14:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ujMbsYaV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A9F239E91
	for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 14:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753195036; cv=none; b=caemSvNysgyHZ/dETYC794ZPIebK4aXrphY1t9eLUIROqaLf5V42fv2uHgW3T2y0FRievLbQZHM9qHvIqiRK+Z3F2GlvYmndbeJcPZKrkzAc+0wTgJIQiFyLPDcZuz9/Vg+iLSkJBnVsy2uYpZ/yDRy6f6wnouJw05mF2zeB5go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753195036; c=relaxed/simple;
	bh=mx4M38Pifod+TTsFyCyeW51ExTlxELB+CIMDHDK7b5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JVnCgiOWKRriJCPuzVsjtvaNYKNaHf0/k1BTu50Cd2M1igrIq1ra7TIpa+QpVcvJyFpeRA2lCP7asrKsFjGB9xJ6/OS5FmX8QC83mdkf0klAc3YBQxnE4lUVteKDPbAlMye2vAjjINduofCjU+9diZ9jpXXfaN4VsFPusSrbUTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ujMbsYaV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ef4fb5eeso5544635a91.1
        for <kvm@vger.kernel.org>; Tue, 22 Jul 2025 07:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753195035; x=1753799835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dUACzvPgQEm4XYWd11I1pPmyiARplQU6zhTfmXThj6g=;
        b=ujMbsYaVvKXPwTbsp7THR0kg3wJ2N00FKW/7oAJfJVqQ/9vYePBhoiXhBNMSnosW7h
         X5R07b/7eL0raeu5gU1+5xs3tiJ6Br7xMKMLKYBDTqGQ5EO1DR1CuIBD8D2+89CcufkV
         7/wKhURT1onzejlFTUZqPH9NGS062Pk7oSuWIRd5uOvVOYOyXsyka0tQxWThWYqS5lVE
         QXV0yy87Xb5kkXT5sHo468o9Dt8hTPAE/oWWyeA1TzvrB41qUaGbIVc6UPH5BG7loe60
         5gUTudqFTTq+3Tl3Qfv/kkIkBtCxhWBfIpZCDoLsKNrB9ACKKp/ucQ3GnbMi0pm5oHTD
         OagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753195035; x=1753799835;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dUACzvPgQEm4XYWd11I1pPmyiARplQU6zhTfmXThj6g=;
        b=l7+WmfhOzt8Vcsvi5COC5ZCkI83Gu0+EQgaoygYvYLPOVDFWWeL/2hXxRJri+1CoAM
         IBVtmLwq0pnHzMU0sWDfl1yfS0gXPHbFx4SJaIexq8TcuTFUhzWib4m2U0MXBNxvz2es
         DE43vvLgVYxoEoHXTybJgOdvX2BTcwXlNErXrzwp4u/8rspoWvArst39H8tmyicfUny4
         GVDKFC5ggBH2oO3kQvvjjvIC0MvbxyQ4tB+Ka+Lx+rD1J0PAZq/rZWH7WaU4fHVrNbBl
         ClgTSFMDZ0z9x+ZD6l2T5IAiNRuGQBK8QmbWzixjGvFPUqpVSbLDs8eyj+8aAJ7yjF4L
         BI6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNBZymsBaZRhBHxxTNqTyC8bqEmNigAlyAa8JfNcmyt5mzWEc+D9s6d40gTCgPk/ZAsWc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZh4hGAdVwtp31jLcT7FzZLjLHGIPSzFrtz5lLdrPgd6Knw3ea
	st+MvWU9kij+rXpRDruM4sKnpWx0msQm9gSLe/vyA2MO3Ys73BcmnCNERrJe2AMfzEpGLV0P+Gi
	DR/6v6g==
X-Google-Smtp-Source: AGHT+IE8C9J3LvK/phm20LbST6qjzlg3ADXumanwajQGLHBmnJo5nov+CCWKM1So3cCPJD4+nPzceM8mbdg=
X-Received: from pjbqo11.prod.google.com ([2002:a17:90b:3dcb:b0:311:7d77:229f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38d1:b0:30a:9feb:1e15
 with SMTP id 98e67ed59e1d1-31e3e153417mr4923710a91.8.1753195034488; Tue, 22
 Jul 2025 07:37:14 -0700 (PDT)
Date: Tue, 22 Jul 2025 07:37:12 -0700
In-Reply-To: <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-15-tabba@google.com>
 <505a30a3-4c55-434c-86a5-f86d2e9dc78a@intel.com> <608cc9a5-cf25-47fe-b4eb-bdaff7406c2e@intel.com>
Message-ID: <aH-iGMkP3Ad5yncW@google.com>
Subject: Re: [PATCH v15 14/21] KVM: x86: Enable guest_memfd mmap for default
 VM type
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
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

On Tue, Jul 22, 2025, Xiaoyao Li wrote:
> On 7/21/2025 8:22 PM, Xiaoyao Li wrote:
> > On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > > +/*
> > > + * CoCo VMs with hardware support that use guest_memfd only for
> > > backing private
> > > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping
> > > enabled.
> > > + */
> > > +#define kvm_arch_supports_gmem_mmap(kvm)=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
> > > +=C2=A0=C2=A0=C2=A0 (IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP) &&=C2=
=A0=C2=A0=C2=A0 \
> > > +=C2=A0=C2=A0=C2=A0=C2=A0 (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_=
VM)
> >=20
> > I want to share the findings when I do the POC to enable gmem mmap in Q=
EMU.
> >=20
> > Actually, QEMU can use gmem with mmap support as the normal memory even
> > without passing the gmem fd to kvm_userspace_memory_region2.guest_memfd
> > on KVM_SET_USER_MEMORY_REGION2.
> >=20
> > Since the gmem is mmapable, QEMU can pass the userspace addr got from
> > mmap() on gmem fd to kvm_userspace_memory_region(2).userspace_addr. It
> > works well for non-coco VMs on x86.
>=20
> one more findings.
>=20
> I tested with QEMU by creating normal (non-private) memory with mmapable
> guest memfd, and enforcily passing the fd of the gmem to struct
> kvm_userspace_memory_region2 when QEMU sets up memory region.
>=20
> It hits the kvm_gmem_bind() error since QEMU tries to back different GPA
> region with the same gmem.
>=20
> So, the question is do we want to allow the multi-binding for shared-only
> gmem?

Can you elaborate, maybe with code?  I don't think I fully understand the s=
etup.

