Return-Path: <kvm+bounces-52999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E62B0C6D4
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 16:48:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C830540ABA
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 14:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9870E19E7D1;
	Mon, 21 Jul 2025 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GrTW1b3j"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F32DE71E
	for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 14:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753109235; cv=none; b=LJGvgY5nuMNbz3e7/mGEK3uXod/irlROd67rIKIMv2BD+hSItsMZkxhikBLX2fY5mLaQUWOp1VFTCsjm1QIjQf07C3cEkmSkPJ+V7d2MSwBIsdj8SKJjoYlInPGiY9nVNGMh+gC85qjyjRMAMUsa7OUur+dg3GCBcsvieWwfqFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753109235; c=relaxed/simple;
	bh=HI2Eq1XFMFwBXQQOwsx0GY6/RMpiizz+jBnMiq7HC5k=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XtvI7zeUbevT6Cd+JmjS/Gbxn7Rkda0fpVuKzBBPjM9mjj9CtitTqKwZ6fGwx6B4ViyS6eYnicG61/9uqts1JOfpeOiDpRm/2GhQ9GiALIpeHgTbc2C45yrD5qq9apb2ch8uMgXViGZiZvauhsORG9zbDM1K5wynPdy4/XVR3G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GrTW1b3j; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235f77f86f6so42345355ad.2
        for <kvm@vger.kernel.org>; Mon, 21 Jul 2025 07:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753109234; x=1753714034; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ffOtNEBmbjqizvgQ4vhm5l8UrMZzIYK2/Gg6fgZ0b+8=;
        b=GrTW1b3jks/z5sUfGsGH1AZHfI753l7DfBkdWR3OWdJkIuled+FpKG7MJaw+3AV+mR
         oi2KXdgwx65aVExWEAjLlHhS6AX3ReVQgKAKjjcresa6GQcNguh4dAMbklxWiaHRGvYK
         xppYBbJo31FwCvqCyMp4d4AoO9Is6Gra3wmBaV79GjVyPiksDGiP11guQNl+WPGL9zbL
         1njejAWfv44GD1FsfS4OhU+2pUoDWqMKmGlm6T8l/lV4/i46cCv0qrhdTsie/A5f7eyf
         b/EYrShWRi922KyM0xo8K0YVHPhpsQkQGzKr+Yi1HOa1mGSriaJjV//Gjj9eURX1kPDs
         mJFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753109234; x=1753714034;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ffOtNEBmbjqizvgQ4vhm5l8UrMZzIYK2/Gg6fgZ0b+8=;
        b=wTRKWfryE+24+lMl0L185OzyJNc7PrmNJQ9urUOGUcOjC9SJSfueHBCgHROo7KX5/y
         21PgL3tGbRB7IKpzjQC+2yt+B6xuppdqM8G0Vi0a1q12YLrM0vt1QT2K8vx2fb87/YiN
         N+ae/K3rf8l9u/tmGL+7PxC/fI8qeOtgcTMqLbMhfqqfnnGX4l7ByVeD1Bumm38K8+gJ
         GyMUG2R5Viw+MMJoFH7M1VNFW5MGc0nONZsDaoUvdz+xjgoTChdougg6WlDr00DfId24
         BZ8gf+y7rXW7jdzRMNWHhh5gxS2+75ISArv3s67zyrDIHvU0UW9l23oo1QZtR2p4bqHc
         zC1A==
X-Forwarded-Encrypted: i=1; AJvYcCVV+JAJk+At6lyaxyqqhwKif7RpAJ6TiMTZugfP2JMYNDA9fiD2qqkFpe4hUBiIylZ8byw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIUHpEY2TO1sgRxHGhaH5fMhTbN8FV3el5OuVEMGKWUZjnD/rG
	Et4T/Ks+ul2t/qMBpQGBVTEM9CoEPOlNEMPETu8X2zDoo7Jvts/IKTofX6okLX+lHcrUG6r0qlJ
	GjOSA8Q==
X-Google-Smtp-Source: AGHT+IGdzbBSF5af55nYsZY9Q+1tI4Xjkxsmb5nVNCaysEuaq1dpjZGyCGgJvydc4U55ykW3wDMcDR7ynNM=
X-Received: from pjp6.prod.google.com ([2002:a17:90b:55c6:b0:30e:5bd5:880d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e547:b0:235:eb71:a37b
 with SMTP id d9443c01a7336-23e25776833mr368910515ad.46.1753109233689; Mon, 21
 Jul 2025 07:47:13 -0700 (PDT)
Date: Mon, 21 Jul 2025 07:47:12 -0700
In-Reply-To: <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250717162731.446579-1-tabba@google.com> <20250717162731.446579-4-tabba@google.com>
 <ffb23653-058a-426e-9571-51784a77ad3d@intel.com>
Message-ID: <aH5S8A4NJtusWgqe@google.com>
Subject: Re: [PATCH v15 03/21] KVM: Introduce kvm_arch_supports_gmem()
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
Content-Type: text/plain; charset="us-ascii"

On Fri, Jul 18, 2025, Xiaoyao Li wrote:
> On 7/18/2025 12:27 AM, Fuad Tabba wrote:
> > -/* SMM is currently unsupported for guests with private memory. */
> > +/* SMM is currently unsupported for guests with guest_memfd private memory. */
> >   # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) ? 1 : 2)
> 
> As I commented in the v14, please don't change the comment.

+1, keep it as is.

