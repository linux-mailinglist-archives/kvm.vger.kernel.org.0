Return-Path: <kvm+bounces-34194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52ED49F8994
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 02:39:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 945C91697AC
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2024 01:39:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94CF217578;
	Fri, 20 Dec 2024 01:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UIhDHY2f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B3F5672
	for <kvm@vger.kernel.org>; Fri, 20 Dec 2024 01:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734658750; cv=none; b=LgRJzaaX+vpzzC57B1ewXjpmDPJKg1VANOUCiUhCzKn/+jB8veoacGPC3Hj/B4/PVY9Ct3osuIzKo4J53otzArvIYrXjkUlJNa/qSQv0YGNWqlxb59R/lpmU4BK5OTjZY8owVzQQMvuMfLd7mBfgld6S3exKXBbYIyZHQ2SB0v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734658750; c=relaxed/simple;
	bh=iOtbn0YZnKIsu57KSQS/WdzlFtmyeZ6SuWU2WK8fyWM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=KY0E2ZLZOhQGsg/JTIB6paOSusbH3fYMwbrL6MSusVGEppt0H8PcqULMO4J05kF7DfCEQRX+u+62QOhka7ZoKlhjP6mAUi/OCVquRmASN+kQtWkNtcidXbTqGeDL6eZ4E0zpxm8gPLELxRsafauCWNdZjvVE9h0zX6s6pQPtIHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UIhDHY2f; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fb966ee0cdso1054860a12.1
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 17:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734658748; x=1735263548; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cRDKUGnjPxUGgjTzF3qCkNkq62oEn2vSDO7JvD7Kppc=;
        b=UIhDHY2fEZ2IElrSXBSnRu2AblLKDQeH5kIyaUP9VqifompF1py7Zr4Q0Gn2TmF7Ry
         30S06XpDgXi/63tJWFBgitHNW13yfQkyMj8b+2Wng+SzPiPNmHqZcFuI3CuUnwx7oMNf
         3HB6NqKmnis/mrshNDH2VRTDKWIlzpzd5G7Uhu+vLf05Ct8MNHwpklffa3gEe+TECvKc
         Ttbt0hO5Ue3x3ZS5LJKNxekxjrHb0ubnudvJyFACx4UVPpp+KT7ff0YRhsQi2bBpUq8e
         xLQH3GEBsAdmtEFrN5YJXmvcaVoK6YWKK19PEYNZUlclY2TUwoMquc6WmYAJPyl6RARD
         s7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734658748; x=1735263548;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cRDKUGnjPxUGgjTzF3qCkNkq62oEn2vSDO7JvD7Kppc=;
        b=hOWiDzoRldijJgTpQHad4NuJ2wmgEFnb+OIU/amLcLrNbPw46zNiZtqasH0USe9MS3
         99OIkBOCoTmEY6Ofq3tkyOG7LbTGx2qROEVapbHZDtcVGInRy6Ikj5mhj61ztM+RPTc1
         iE3Y35kf9vkX/DtlVQY5xk5Nh91MX7joZDMzqCO6FsEwx5wx73jHMk/zqITPtzIdFON4
         9zB2/1kFRuqdgI8TEO/G3G1ig31GahDLxjxUadfC9uAC3w4JJaMVnRPclthjvzHzMXoS
         k243RqhW1VJ7VaysxwMeGjn6aZ+SdYwLtbjQXDGWA0SCC0TTZtO5bDsQvfzd5hm0oyHF
         kBYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqJzQF0cwlAJKP7UbfO6VmXUSSLoF9r/sheUtJoiLBSVq7EQ/ZyAzJcZBynJ4HUEji39A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnjblpN1lUkWlEPTI0JVniCSp96SGrUHgLbiboN+Lh1xrN1tu3
	KFY/8ZjPVkKikzMU9R+mOPnlgsTE7HIydJb2xowUjiICm+pDDbVFzIzJtNFMVJ2SXpTTbW/Acy9
	hJA==
X-Google-Smtp-Source: AGHT+IGKk1u1qooE3KT9EvHF6/wnmuA9XWAa8TXLf9DPPdKposqbF1SIF5jz7mHb6qxYFc6rf04T8dQlWu4=
X-Received: from pgbda1.prod.google.com ([2002:a05:6a02:2381:b0:7fd:4bf0:25fa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:7fa6:b0:1e3:c763:74d4
 with SMTP id adf61e73a8af0-1e5c6d6b62dmr8239281637.0.1734658748516; Thu, 19
 Dec 2024 17:39:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 19 Dec 2024 17:38:58 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241220013906.3518334-1-seanjc@google.com>
Subject: [PATCH 0/8] KVM: selftests: Binary stats fixes and infra updates
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Fix a handful of bugs in the binary stats infrastructure, expand support
to vCPU-scoped stats, enumerate all KVM stats in selftests, and use the
enumerated stats to assert at compile-time that {vm,vcpu}_get_stat() is
getting a stat that actually exists.

Most of the bugs are benign, and AFAICT, none actually cause problems in
the current code base.  The worst of the bugs is lack of validation that
the requested stat actually exists, which is quite annoying if someone
fat fingers a stat name, tries to get a vCPU stat on a VM FD, etc.

FWIW, I'm not entirely convinced enumerating all stats is worth doing in
selftests.  It seems nice to have?  But I don't know that it'll be worth
the maintenance cost.  It was easy enough to implement, so here it is...

Sean Christopherson (8):
  KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
  KVM: selftests: Close VM's binary stats FD when releasing VM
  KVM: selftests: Assert that __vm_get_stat() actually finds a stat
  KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name
    string
  KVM: selftests: Add struct and helpers to wrap binary stats cache
  KVM: selftests: Get VM's binary stats FD when opening VM
  KVM: selftests: Add infrastructure for getting vCPU binary stats
  KVM: selftests: Add compile-time assertions to guard against stats
    typos

Sean Christopherson (8):
  KVM: selftests: Fix mostly theoretical leak of VM's binary stats FD
  KVM: selftests: Close VM's binary stats FD when releasing VM
  KVM: selftests: Assert that __vm_get_stat() actually finds a stat
  KVM: selftests: Macrofy vm_get_stat() to auto-generate stat name
    string
  KVM: selftests: Add struct and helpers to wrap binary stats cache
  KVM: selftests: Get VM's binary stats FD when opening VM
  KVM: selftests: Add infrastructure for getting vCPU binary stats
  KVM: selftests: Add compile-time assertions to guard against stats
    typos

 .../kvm/include/arm64/kvm_util_arch.h         |  12 ++
 .../testing/selftests/kvm/include/kvm_util.h  |  49 ++++++--
 .../selftests/kvm/include/kvm_util_types.h    |   6 +
 .../kvm/include/riscv/kvm_util_arch.h         |  14 +++
 .../kvm/include/s390/kvm_util_arch.h          | 113 ++++++++++++++++++
 .../selftests/kvm/include/x86/kvm_util_arch.h |  52 ++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c    |  79 ++++++------
 .../kvm/x86/dirty_log_page_splitting_test.c   |   6 +-
 .../selftests/kvm/x86/nx_huge_pages_test.c    |   4 +-
 .../selftests/kvm/x86/xapic_ipi_test.c        |   2 +
 10 files changed, 286 insertions(+), 51 deletions(-)


base-commit: dcab55cef6f247a71a75a239d4063018dc83a671
-- 
2.47.1.613.gc27f4b7a9f-goog


