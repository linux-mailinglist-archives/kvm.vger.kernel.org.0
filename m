Return-Path: <kvm+bounces-36140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 64FB7A181B0
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:06:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A25A188272B
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:06:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826041F4705;
	Tue, 21 Jan 2025 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aErWe07z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507E3224D7
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475560; cv=none; b=nyO/io6d2+ioTxDX/wECsONuenyrrpy8LsW5CLpJ1oX/LySw5oZJY3l8+TikjpbVA2KcMrPw8zLULeOb9yrRo6U0qe1j09vDk7r1lX+I00ip92au+W3CE9Wvm4LIu2h7CDeSuFarXZyXb0lXKQQfWjMPqbnP9r66OdcRvF2HZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475560; c=relaxed/simple;
	bh=LEkjzKCvaFiVJxVYiKrHF9zba2jnUyfJh52tXTn51bM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VDORrkplcxvdHy4Rmg4r/+AcHJOnt9l1nevgLLFFuDTAWH2LvLYEtGw2kpfi6nJcV9/p4zmEoNtn65Zjq8eGnczDoC0vptKjcJfEnEaPLByQU4yC9FcUvQNuXvre54HRjiT1fyK/Mv5FDLzr2XZ/E4oGsum4WOO5rd7BihdqVvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aErWe07z; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-216750b679eso79667425ad.1
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 08:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737475558; x=1738080358; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Yz84lleC5Mk2nqkUEXOyEM0HuFKKjnN9zGCEimjnnI=;
        b=aErWe07zM6/KMfviKYggeuKfR/Q/FdPtUIR+VSJECcJ2dRs1cGwyzK+iXI1lyJKBKU
         ImM1BbyXJtWC5T9LUbiXiUZ5sSF36Optp5eq1JgKt3HlRPr8dPJtXOkMfek2ySVdX2+4
         Lp4sUr3cJJxul6lI9H9M5TeoMcr6NmbfPFVnkLT5f8XzEcCxza6IuWt7NDZJjFEN1az8
         2yYP8cjaNUWAPhGr7rmESjuwAWerrkt21Ki/38z+WfPOvbuQzNw+GCNP2Zpyoxvjo5mn
         qorA2Bj/Xxgg+ESZi0+HVLDorY+gHK3S5Ci5JFKX9mA8trkN3p0+RbZR8K94FfPtNfI1
         5+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475558; x=1738080358;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Yz84lleC5Mk2nqkUEXOyEM0HuFKKjnN9zGCEimjnnI=;
        b=eXC2wTZA5CP+5kDSjtapZI8bB0VlARAUBsbRGM5x3gv1bz+j2H6DuxDGEGFLs7r1ij
         q392wqJpR5KmfeEFY82fIdQ+aOF5IsNQUnjUxKEn8BJPo4pWcal/pbXPppnO7cpGS86B
         XPW0LGVhUW2ijO8zEmknqC5ZEw7mWLCVYUVlsCztm5sGRH4EFyZskgLh8Xe8ArueF2PH
         l9k70edEyo4J+rLxewp93gVvh09DFnunSvFZhKiGsllU1XQ88kHdiBEkNbS0zcV+dcda
         qwkuhKalxWzBoYZ5YE5iY6n5l+RgjYw7VQ7IcjTDEYcIpfgn+il93S0NVtjUYgsvNhaa
         27cQ==
X-Gm-Message-State: AOJu0YwUZYjakG5+1azXarTvglDaOMVyFQHhJWa7xqHOnMjln92BNAH/
	JMHSyi7GTdydeeM7DnR8Kx58hZQDDVYOjiJXZSjeSCDkW7QY9ZEhAb1kXzzahnUcT2BPtnhM/kJ
	5Bw==
X-Google-Smtp-Source: AGHT+IETGqGoKIV+lA1dbjHfsuhBIbpfyITRLkeYzNyePSsdGcjttV5KyGVg3y40wYbMXBPw+OMpQCcKxHI=
X-Received: from pfbeg5.prod.google.com ([2002:a05:6a00:8005:b0:72a:c59c:ef6e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:6812:b0:72d:b36a:4497
 with SMTP id d2e1a72fcca58-72db36a45eemr21902746b3a.3.1737475558576; Tue, 21
 Jan 2025 08:05:58 -0800 (PST)
Date: Tue, 21 Jan 2025 08:05:57 -0800
In-Reply-To: <D76ZBOXNTIGF.3D0BBERDWTY2C@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250111002022.1230573-1-seanjc@google.com> <20250111002022.1230573-4-seanjc@google.com>
 <D76ZBOXNTIGF.3D0BBERDWTY2C@linux.ibm.com>
Message-ID: <Z4_F5dNstl3Xzhox@google.com>
Subject: Re: [PATCH v2 3/5] KVM: Add a dedicated API for setting KVM-internal memslots
From: Sean Christopherson <seanjc@google.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Tao Su <tao1.su@linux.intel.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Jan 20, 2025, Christoph Schlameuss wrote:
> On Sat Jan 11, 2025 at 1:20 AM CET, Sean Christopherson wrote:
> > Add a dedicated API for setting internal memslots, and have it explicitly
> > disallow setting userspace memslots.  Setting a userspace memslots without
> > a direct command from userspace would result in all manner of issues.
> >
> > No functional change intended.
> >
> > Cc: Tao Su <tao1.su@linux.intel.com>
> > Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  arch/x86/kvm/x86.c       |  2 +-
> >  include/linux/kvm_host.h |  4 ++--
> >  virt/kvm/kvm_main.c      | 15 ++++++++++++---
> >  3 files changed, 15 insertions(+), 6 deletions(-)
> 
> [...]
> 
> > +int kvm_set_internal_memslot(struct kvm *kvm,
> > +			     const struct kvm_userspace_memory_region2 *mem)
> > +{
> > +	if (WARN_ON_ONCE(mem->slot < KVM_USER_MEM_SLOTS))
> > +		return -EINVAL;
> > +
> 
> Looking at Claudios changes I found that this is missing to acquire the
> slots_lock here.
> 
> guard(mutex)(&kvm->slots_lock);

It's not missing.  As of this patch, x86 is the only user of KVM-internal memslots,
and x86 acquires slots_lock outside of kvm_set_internal_memslot() because x86 can
have multiple address spaces (regular vs SMM) and KVM's internal memslots need to
be created for both, i.e. it's desirable to holds slots_lock in the caller.

If it's annoying for s390 to acquire slots_lock, we could add a wrapper, i.e. turn
this into __kvm_set_internal_memslot() and then re-add kvm_set_internal_memslot()
as a version that acquires and releases slots_lock.

