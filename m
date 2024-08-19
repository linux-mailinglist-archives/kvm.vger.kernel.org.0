Return-Path: <kvm+bounces-24561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E662895780A
	for <lists+kvm@lfdr.de>; Tue, 20 Aug 2024 00:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75DE5B21582
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2024 22:47:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90C811DF661;
	Mon, 19 Aug 2024 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GRib77bB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709EA15B99E
	for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 22:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724107640; cv=none; b=HmIXv+FS4E1YyNjNp6jBEUaddKp0NAq5zesT/A5CVdQlqfXGYfM6zmsgfcMQNSTT9ESVE47JB7iU8eVl7ZUsp4WuPhTkDK2yCpThux3/SUIjzXubtKqqJtDYCIl0Ainr6wwfOsVAB7+kXFRehdSKPYBkDPjXiGxJoGIPnvs9+wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724107640; c=relaxed/simple;
	bh=VDHlprhqwjCM5N4nwmrW+/M8UE6X+2dcwSHCzgZZckE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G6Y3/spf+MDM4RWbGsLlIyVCdJXIu3wsDxPRD1+jN4qBdnroshRqIM2jIYx8B6jh0mPEe0JoO330IplIcaGiVa5Fx7Rj8YL7y0jA+bGbPRCSruErL3XWK6w39XGVp45c4UfG0/fnzTEIKCpMNNTHBmNmjbx8kbqHEfVLTeemnM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GRib77bB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7163489149fso4406512a12.3
        for <kvm@vger.kernel.org>; Mon, 19 Aug 2024 15:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724107639; x=1724712439; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0mpr7864OCZvv9Hj0Yv++YX+VmARQzYZRUR5rU9bOeY=;
        b=GRib77bBvuS54zVEHsxcUHiR1ATqHPtnZ0xESmawQTlLv1Ib7SqbQkkMxRunQmPA0B
         W0GHItnH3tz5SofclG0kBJoNYYXCplWh/PTDaIarpYxUsoRdoymc/5a62C50UifSmjJ8
         OCevUGwGgv5nLbYihzWy2PftYtd8bx8cuEnOV7+649T3sS1DhEst/f+DLD43dHN8NpSD
         OEBzZQHc8Y1QIx57Yjo+HmMWLNEu1XBp8lBJOUduEOpDShDWf0edME8PdxO/iG62CmEr
         OvdYeU3PHgvDD8iYgxuGlBnXUFrIvX13G/+HFdT/cIenuchJWXa6Gi/BbRIIwxsvg/Ls
         WxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724107639; x=1724712439;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0mpr7864OCZvv9Hj0Yv++YX+VmARQzYZRUR5rU9bOeY=;
        b=mYj8mKxwh0gltPI44TjqSg2vhIFQ8zkiKHBytC09NW7kpVZUmcKuip1bIZm1zIZ+/l
         qoZgZ72VBhrlVl1Fhe4eSGKnRuJbk4CjLbVN1Pb6X9A2SahcC8pdTBxpvABtRVnevzqz
         CCKjnDjLFwqQIpPWR0H30dDqKmvZBOycv29I43evv2bw05VkBKF3mjSd+8ib5mCcS4Ea
         LWjasV/8DNznoVuLG1MgRq+KCpIbXv5BIoh+96p/XiLLFwfpKqRxt+sQxW37XPl7GHem
         U5OfrdWuVhQgszEFJycK1sVjCCw17ueAoKdUHZSlY2xcTAhfcsdxtTlCG7VitHRZho+J
         6/ew==
X-Forwarded-Encrypted: i=1; AJvYcCUhBBd30U8ya0UAlz9nxHafQgtnB7LmVzp/0Jb2V7mMGwUTC6tg1b0b1/FlFWSn+zSo9UI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBI8pFZ5kvvrQFG9qEPIZhjMobsYU9Wn9fRDZcooWndqpDGCOc
	Ct3+vhYLFL7bKCx+u+fCOP9uCR8fGWBmCTNmvdzKgVDuhBuPv0pSDweZ9DYsMoZbhS+cZ34i16a
	9gw==
X-Google-Smtp-Source: AGHT+IGngB58TyyXwtykQy2TchYmizV3K6F19AJubcP5aFPXxhvBteRSy0IDpLShOfEeLOPTdkLjdiTkkuE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:247:b0:1fd:8e8d:8695 with SMTP id
 d9443c01a7336-20203f27f39mr13121725ad.12.1724107638639; Mon, 19 Aug 2024
 15:47:18 -0700 (PDT)
Date: Mon, 19 Aug 2024 15:47:17 -0700
In-Reply-To: <ZsOuEP6P0v45ffC0@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
 <20240724011037.3671523-4-jthoughton@google.com> <CADrL8HV5M-n72KDseDKWpGrUVMjC147Jqz98PxyG2ZeRVbFu8g@mail.gmail.com>
 <Zr_y7Fn63hdowfYM@google.com> <CAOUHufYc3hr-+fp14jgEkDN++v6t-z-PRf1yQdKtnje6SgLiiA@mail.gmail.com>
 <ZsOuEP6P0v45ffC0@linux.dev>
Message-ID: <ZsPLdUC44-DHKAON@google.com>
Subject: Re: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn
 and kvm_age_gfn
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>, James Houghton <jthoughton@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Shaoqin Huang <shahuang@redhat.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Wei Xu <weixugc@google.com>, Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2024, Oliver Upton wrote:
> On Fri, Aug 16, 2024 at 07:03:27PM -0600, Yu Zhao wrote:
> > On Fri, Aug 16, 2024 at 6:46=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
>=20
> [...]
>=20
> > > Were you expecting vCPU runtime to improve (more)?  If so, lack of mo=
vement could
> > > be due to KVM arm64 taking mmap_lock for read when handling faults:
> > >
> > > https://lore.kernel.org/all/Zr0ZbPQHVNzmvwa6@google.com
> >=20
> > For the above test, I don't think it's mmap_lock
>=20
> Yeah, I don't think this is related to the mmap_lock.
>=20
> James is likely using hardware that has FEAT_HAFDBS, so vCPUs won't
> fault for an Access flag update.

Huh, didn't know that was a thing on ARM.  Ooh, that lends even more creden=
ce to
my assertion that marking folios accessed in handle_access_fault() can go a=
way[*].
I assume hardware-assisted updates means this code in handle_access_fault()=
 will
no longer be hit, as KVM simply won't ever get access faults?  If so, I'll =
add
that info to the changelog.

	if (kvm_pte_valid(pte))
		kvm_set_pfn_accessed(kvm_pte_to_pfn(pte));

[*] https://lore.kernel.org/all/20240726235234.228822-83-seanjc@google.com

> Even if he's on a machine w/o it, Access flag faults are handled outside =
the
> mmap_lock.

Oh, right, they go down handle_access_fault(), not user_mem_abort().

Reviewing late Friday afternoon, never a good idea ;-)

