Return-Path: <kvm+bounces-13482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A27089770B
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 19:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B8F11F2D640
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:40:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C75E616D334;
	Wed,  3 Apr 2024 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uqm9QCWv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C116D32A
	for <kvm@vger.kernel.org>; Wed,  3 Apr 2024 17:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712164806; cv=none; b=nRHHlyV8d0xtctYX+0pJXfsIbq9MSTBAT014JDmIPkJgcRLm3D7OdN6t7giXBcmpCs1jWbA4xvzecnfrCyqGVwsdkb1phyN7msOY7wdIdtGgZHUhWghEUoWywS0BCXJGTUeJtObh93nuqkVxrID4Mo3WdkXa1+npleogGiBmY9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712164806; c=relaxed/simple;
	bh=8IlYAc/1g7pMae9Bxm4yrJUSCcJqAJcPwhB0IO4bkik=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ba/d6JBXXVdWfaSN5PMIsjqlZtGdrVjzby7rS9YNtxLD5GFhubOwvuW/l+heSHDb+ZFrFsB3GGjwbFZW8XTJVMEef2+PGzRcQgNJMQJaCVOY0M+5J6nUxIbECA0sj52EkO1THn7inK50LJWU3fK+GUjJxJRXaf+V3cZqqqhtyxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uqm9QCWv; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2a26a065631so14727a91.3
        for <kvm@vger.kernel.org>; Wed, 03 Apr 2024 10:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712164804; x=1712769604; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3rSsI2dMglxlpboEehF0mS0Pvczh5Ixi6iikM5re2Go=;
        b=uqm9QCWv5Jk6NOjEf1LH0ZW6fJ3j+nxZoMPCyk/f32oAGBCmNLuPU//bMIKVL2fT6d
         iGBgp+4XgGfm5EC9k+PhLta60wHjUrdJqUhx29Rz1wGoWqL37h4oXAQqe53FULM7ZuDf
         cevkpEOowbR3B8ewpaOwcWgaCG5wnh/GCCz+l62wtOX6kAt3/bUKLKbm6SyMsxAVEVDi
         1eE8VuiqiIC1bVa86nJ8u4zRY48jeUkxUF5iOgsZg/JZTK7aft7WKR5YoUS+7ZhoNSsY
         vfTO4IY7jKO3FbDtio2mJE9Szo8X8WDYchJy9kkWwY5bRgzq2cHYkA8arbSqgIMTZS5p
         DZxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712164804; x=1712769604;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3rSsI2dMglxlpboEehF0mS0Pvczh5Ixi6iikM5re2Go=;
        b=L4IXosQM0c1IQGvFwxvuxd2FDXHvwindgYGgPXuJO45dwgBlyg9EU8xB2B3KOjwXV4
         zYfuKZ2WK59N/vafq99sOpxgU/vyglq0cwb6Kv+GuRW8O6KgVObpkP+9noBI1bu9YAnA
         0YHpUicrB2bTKHtT4as8OqXBqDO58GACKKgd6OwCRbJSg1cIGvf2WrRNDGs/Bl4lfnAa
         y9GJjis9WjFQqf5CNSzWxuxHPzkZCLNe+Ux9cVRkaYepQyKyVwWk/kACGphBRJBlzCI6
         VaRAksqcR05wUF5fe9kc+HXGRmSLisnQ6HM5NoZ8Gb+DTK5+DQDrMWQ+e9LZ3CZJ9jDB
         5Itg==
X-Forwarded-Encrypted: i=1; AJvYcCXmzzQchHdK8y4RzLwbHoFQnZBbdTdWOvfQV8HcNFnhtfngHUqnGQVz+oExJBjYwuy4H7UUyeztwRpVQO/u0eAMOmfe
X-Gm-Message-State: AOJu0Yxqfvc4vCj4MJj0h/UdpyYC1D81p1DowIQSUME74qnDsAV9UxpV
	MAe7DsxSrELh+UOrv9fnXrhHfuw7y0iIT23iDZNnxZHFc3EEKQrA5J7fiIUBy8QgY5m2tLduk7q
	TMg==
X-Google-Smtp-Source: AGHT+IHIZspzDL2Pcm1/sprQ9sc+OwskYOcgAh4KZmqfJ7vm5Cs8EmLrKsRKFY2OsZwcrwc08E8/JFabG4E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:dad2:b0:1e0:afa0:cca2 with SMTP id
 q18-20020a170902dad200b001e0afa0cca2mr632062plx.10.1712164803703; Wed, 03 Apr
 2024 10:20:03 -0700 (PDT)
Date: Wed, 3 Apr 2024 10:20:02 -0700
In-Reply-To: <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240402213656.3068504-1-dmatlack@google.com> <cb793d79-f476-3134-23b7-dc43801b133e@loongson.cn>
Message-ID: <Zg2PwgxNlGqA9T3b@google.com>
Subject: Re: [PATCH v2] KVM: Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG
From: Sean Christopherson <seanjc@google.com>
To: maobibo <maobibo@loongson.cn>
Cc: David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2024, maobibo wrote:
>=20
> On 2024/4/3 =E4=B8=8A=E5=8D=885:36, David Matlack wrote:
> > Aggressively drop and reacquire mmu_lock during CLEAR_DIRTY_LOG to avoi=
d
> > blocking other threads (e.g. vCPUs taking page faults) for too long.
> >=20
> > Specifically, change kvm_clear_dirty_log_protect() to acquire/release
> > mmu_lock only when calling kvm_arch_mmu_enable_log_dirty_pt_masked(),
> > rather than around the entire for loop. This ensures that KVM will only
> > hold mmu_lock for the time it takes the architecture-specific code to
> > process up to 64 pages, rather than holding mmu_lock for log->num_pages=
,
> > which is controllable by userspace. This also avoids holding mmu_lock
> > when processing parts of the dirty_bitmap that are zero (i.e. when ther=
e
> > is nothing to clear).
> >=20
> > Moving the acquire/release points for mmu_lock should be safe since
> > dirty_bitmap_buffer is already protected by slots_lock, and dirty_bitma=
p
> > is already accessed with atomic_long_fetch_andnot(). And at least on x8=
6
> > holding mmu_lock doesn't even serialize access to the memslot dirty
> > bitmap, as vCPUs can call mark_page_dirty_in_slot() without holding
> > mmu_lock.
> >=20
> > This change eliminates dips in guest performance during live migration
> > in a 160 vCPU VM when userspace is issuing CLEAR ioctls (tested with
> > 1GiB and 8GiB CLEARs). Userspace could issue finer-grained CLEARs, whic=
h
> Frequently drop/reacquire mmu_lock will cause userspace migration process
> issuing CLEAR ioctls to contend with 160 vCPU, migration speed maybe beco=
me
> slower.

Only if vCPUs actually acquire mmu_lock.  E.g. on x86, KVM fixes/handles fa=
ults
due to write-protection for dirty logging without acquiring mmu_lock.  So f=
or x86,
taking faults that need to acquire mmu_lock while dirty logging should be f=
airly
uncommon (and if vCPUs are taking lots of faults, performance is likely goi=
ng to
be bad no matter what).

> In theory priority of userspace migration thread should be higher than vc=
pu
> thread.

That's very debatable.  And it's not an apples-to-apples comparison, becaus=
e
CLEAR_DIRTY_LOG can hold mmu_lock for a very long time, probably orders of
magnitude longer than a vCPU will hold mmu_lock when handling a page fault.

And on x86 and ARM, page faults can be resolved while hold mmu_lock for rea=
d.  As
a result, holding mmu_lock in CLEAR_DIRTY_LOG (for write) is effectively mo=
re
costly than holding it in vCPUs.

> Drop and reacquire mmu_lock with 64-pages may be a little too smaller,
> in generic it is one huge page size. However it should be decided by
> framework maintainer:)

We could tweak the batching, but my very strong preference would be to do t=
hat
only as a last resort, i.e. if and only if some magic batch number provides=
 waaay
better performance in all scenarios.

Maintaining code with arbitrary magic numbers is a pain, e.g. KVM x86's MMU=
 has
arbitrary batching in kvm_zap_obsolete_pages(), and the justification for t=
he
number is extremely handwavy (paraphasing the changelog):

      Zap at least 10 shadow pages before releasing mmu_lock to reduce the
      overhead associated with re-acquiring the lock.
   =20
      Note: "10" is an arbitrary number, speculated to be high enough so
      that a vCPU isn't stuck zapping obsolete pages for an extended period=
,
      but small enough so that other vCPUs aren't starved waiting for
      mmu_lock.

I.e. we're stuck with someone's best guess from years ago without any real =
idea
if 10 is a good number, let alone optimal.

Obviously that doesn't mean 64 pages is optimal, but it's at least not arbi=
trary,
it's just an artifact of how KVM processes the bitmap.

To be clear, I'm not opposed to per-arch behavior, nor do I think x86 shoul=
d
dictate how all other architectures should behave.  But I would strongly pr=
efer
to avoid per-arch behavior unless it's actually necessary (doubly so for ba=
tching).

In other words, if we do need per-arch behavior, e.g. because aggressivly d=
ropping
mmu_lock causes performance issues on other architectures that need to take=
 mmu_lock
for write to handle faults, I would prefer to have the arch knob control wh=
ether
the lock+unlock is outside versus inside the loop, not control an arbitrary=
 batch
size.

