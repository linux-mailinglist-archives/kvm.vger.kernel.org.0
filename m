Return-Path: <kvm+bounces-33740-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FA869F12C4
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 17:50:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BCA428104F
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 16:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5567D1EF099;
	Fri, 13 Dec 2024 16:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dzp+pZlU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8C91E47D7
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 16:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108496; cv=none; b=lAqKvgjXcDOH1UWgr0TxPbMqoxHqA8OufbFdXWhks78yNVyUrdjalSXI/pkae0d3z9aWjCcqBgUz49DTwPACPVM6nsGOJy0V7Ga5Ybyl96T0M8TIsSmPlqtZ8XscRXfJ7nN0Mt2IMu3J1/ZJ8fyHz21ynvGmbSGyK6xDW6NHNh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108496; c=relaxed/simple;
	bh=r+HyORnvoVi0/ofpUpkrBmDYo1B6a7NTdhOnqSZIzXo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=o7DFswbPbFBXQvtwxFtSt7RJcezOLe2ezDhjitYz/AaR6SluVI6MbxrSBVT+tnLlKAXCl4VYCChwiYKsMgtDG/vi3zqapXNuqY7j691K4bCdKCB1+EZ124MRu9uE7E3UD67zpSbFpRaYkrzdLMJrwYnq5uZZvfjpYNSpIUv2sdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dzp+pZlU; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3862e986d17so865815f8f.3
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 08:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734108493; x=1734713293; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=l49nZBQWbj/tqR0pfbsQBWP6JXQh3gfv222a0VGKOo8=;
        b=dzp+pZlUZYOQQryw2z9CZ5a75SNpCt3ArokQKkqDzQIy1o9enyy5xJiDMaQ5R/bat9
         RDBDusPCzUxb1bKcXDfHmdUhRd5NOSKbH6I15EorpJYqSN3O1Exm1cjjLamuk0XfFXQK
         jGHp3UveA8dbX5wAFhdNqILn65vrKCxXP7nL4D3KVIF9hiNUGVmRDIlaM55MKjfvyWio
         iyOCWMlgGOE7hw2W+tT68fINxGSZQBjfyHn5deJ0KCMBi6AcVGlvcXY7kXILhN26UYpu
         m6h1b5HhRiWjS0dOIcT7YTTRievIyNaAIbcqUY/PeyyW0L135cXFSeDH4Qbhxjlq+NaY
         quTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108493; x=1734713293;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l49nZBQWbj/tqR0pfbsQBWP6JXQh3gfv222a0VGKOo8=;
        b=oaxJcAP5hEh5sy08NC6xR9y5wVa4jHye1nXSuYNi73K7+m8/HpWw5JF96cMRbPvs3D
         K+GJ29+vsYLzxf1XemraDMEk7D42e/mgdrCJ4eIyhlxYxchZ3DdHjP8Ooye8LoQH3pEN
         kaGwiDmR5hUneyS4PdBcIMPD7F8CtiqoBRoX7iec1FVgcHBAIH5KUPCJegUsSu3/YjSf
         4ueKvEFpALGdd7XMK9fI8hzHIpRni2suOLJeZdHl7XTYWTzNgw4/YVhAuWbFLOfDMmhO
         feTAdrbuHIauQ2wG5YPiaH9kDAWCW+c0rN8NI9lvwJYdU/Ty3qowqMAStt+yyL++moAb
         P7ZQ==
X-Gm-Message-State: AOJu0YyJnXB82AkrbugXdQ2NGL9MdLRC2HwWQIVjViWunwq91cf4rTQz
	MWz7TnGqve9b9Nu29GxnINbXXEz2YE7xu0gg3a2aZxkAHHC9ZwhHDnDj6rzAyscMwBF4wJZcg7h
	19UxjYLzRHf9lONPxYqrSnbOKUWoccTEb9sekj5W12yJmcXtiqMzU5Mux99hQrg/Yn27d/eHLM5
	XS+9Z/l8suL70uLIZ6Xx8MPks=
X-Google-Smtp-Source: AGHT+IHeXWv9UlvNwtt49TJOJkvo4Sw+243biArECpj/wEQYlB+Xl6ffPPZWh7+IujbdTMPrByuwczoUyA==
X-Received: from wmph6.prod.google.com ([2002:a05:600c:4986:b0:434:e96f:86b0])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a5d:5986:0:b0:385:dea3:6059
 with SMTP id ffacd0b85a97d-3889ad32e66mr2769505f8f.49.1734108493083; Fri, 13
 Dec 2024 08:48:13 -0800 (PST)
Date: Fri, 13 Dec 2024 16:47:56 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241213164811.2006197-1-tabba@google.com>
Subject: [RFC PATCH v4 00/14] KVM: Restricted mapping of guest_memfd at the
 host and arm64 support
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

This series adds restricted mmap() support to guest_memfd, as
well as support for guest_memfd on arm64. It is based on Linux
6.13-rc2.  Please refer to v3 for the context [1].

Main changes since v3:
- Added a new folio type for guestmem, used to register a
  callback when a folio's reference count reaches 0 (Matthew
  Wilcox, DavidH) [2]
- Introduce new mappability states for folios, where a folio can
be mappable by the host and the guest, only the guest, or by no
one (transient state)
- Rebased on Linux 6.13-rc2
- Refactoring and tidying up

Cheers,
/fuad

[1] https://lore.kernel.org/all/20241010085930.1546800-1-tabba@google.com/
[2] https://lore.kernel.org/all/20241108162040.159038-1-tabba@google.com/

Ackerley Tng (2):
  KVM: guest_memfd: Make guest mem use guest mem inodes instead of
    anonymous inodes
  KVM: guest_memfd: Track mappability within a struct kvm_gmem_private

Fuad Tabba (12):
  mm: Consolidate freeing of typed folios on final folio_put()
  KVM: guest_memfd: Introduce kvm_gmem_get_pfn_locked(), which retains
    the folio lock
  KVM: guest_memfd: Folio mappability states and functions that manage
    their transition
  KVM: guest_memfd: Handle final folio_put() of guestmem pages
  KVM: guest_memfd: Allow host to mmap guest_memfd() pages when shared
  KVM: guest_memfd: Add guest_memfd support to
    kvm_(read|/write)_guest_page()
  KVM: guest_memfd: Add KVM capability to check if guest_memfd is host
    mappable
  KVM: guest_memfd: Add a guest_memfd() flag to initialize it as
    mappable
  KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
    allowed
  KVM: arm64: Skip VMA checks for slots without userspace address
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: Enable guest_memfd private memory when pKVM is enabled

 Documentation/virt/kvm/api.rst                |   4 +
 arch/arm64/include/asm/kvm_host.h             |   3 +
 arch/arm64/kvm/Kconfig                        |   1 +
 arch/arm64/kvm/mmu.c                          | 119 +++-
 include/linux/kvm_host.h                      |  75 +++
 include/linux/page-flags.h                    |  22 +
 include/uapi/linux/kvm.h                      |   2 +
 include/uapi/linux/magic.h                    |   1 +
 mm/debug.c                                    |   1 +
 mm/swap.c                                     |  28 +-
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../testing/selftests/kvm/guest_memfd_test.c  |  64 +-
 virt/kvm/Kconfig                              |   4 +
 virt/kvm/guest_memfd.c                        | 579 +++++++++++++++++-
 virt/kvm/kvm_main.c                           | 229 ++++++-
 15 files changed, 1074 insertions(+), 59 deletions(-)


base-commit: fac04efc5c793dccbd07e2d59af9f90b7fc0dca4
-- 
2.47.1.613.gc27f4b7a9f-goog


