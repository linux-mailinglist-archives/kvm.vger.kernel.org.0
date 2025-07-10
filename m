Return-Path: <kvm+bounces-52028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D275AFFF4A
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 12:29:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1C7F3B4B1B
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 10:29:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6911B2D8DDC;
	Thu, 10 Jul 2025 10:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OCntFvBi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA192D8778
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 10:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752143366; cv=none; b=IGIY0/+sTuxNSNkFWVFvAp+lTWUGbRiaYBnIQKXRgiEatNNClr9Yh1Keb3+T4mJeEelbnPF/+NG9J/Qpovh3U8Tm98m+x9X6RlXfgM0X+r5LrvWgsvpD1BKwvvJEU/n8YJCYvZsu4JODvGqMqnjQ0sQfXnqKFseF5RC8IVAvEIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752143366; c=relaxed/simple;
	bh=2QWhoM0mWymndRaVSrqd72lnEQHxsPB5lSFxXslQrjM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QgU8kf+gjofUs50UoypvH24dCp1VdLiwUZV3UOd3GZK7NMDSLyuPpVN9xiq940A8cP4GKL+Rw2YgSW31G0/oVvh+w9eDR2SMvKqCVuvPc6j8YC+DalYstr1nqgk7yt1wpVhVWjVnINdC/tZVgSrhDmVxN7yS5eMJ/GxV0xBLn+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OCntFvBi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752143362;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wY7K55zKGpDrRjZXwu1uqWR3zVKuspjibxDl7C+lpPc=;
	b=OCntFvBi/ZCyBr/d/ToZb1fL3a7qOtw7hiIyz18TgkS2TBmVsAOwsK8lUODRYTCGmh0FGB
	mSQh1Q1gIzR/lPsCXDHe8/AeLT4zMTPkPaNB9K0vOrEP0vs+ANbqtCLJhHrbMi0At/7kJo
	jcLY1+8QJEgXa8oktzEtN9nGN1kbe9w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-256-Pnk1kgTCMnySmPAgq87_Xg-1; Thu, 10 Jul 2025 06:29:21 -0400
X-MC-Unique: Pnk1kgTCMnySmPAgq87_Xg-1
X-Mimecast-MFC-AGG-ID: Pnk1kgTCMnySmPAgq87_Xg_1752143360
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a50816ccc6so575863f8f.1
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 03:29:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752143360; x=1752748160;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wY7K55zKGpDrRjZXwu1uqWR3zVKuspjibxDl7C+lpPc=;
        b=GO1YT6BcjNiZgvYAeJkDMe9SV87Pw4K3YUeY9qzX5US+c328s2sdRC/bYPJZEZgErR
         eq1Q+7l7/AtqWujxF4G9e2g12zp2AEHD+IiXhqmgIEHbftgJG5hkWFXOMBPTnMBuHxcF
         CWeb/tibXzrzyn5uWvQY7tDQh2P2elzDwFy2fBvlpKN9m1r8IvQ51ig65OHpGoFyFOLq
         +GtnLH0YBmDERVhnwDU6ZrnXcplBtnBqnsWjRdZOeggqa23al4MxkO5hrAE06vll+vc4
         qEf4fk3DgL6NcT3cKYdDlRwjZw7X5EwW36wtClof9VDHlHfcwVn7wEeDbo5yiwQg+1Yv
         Mumg==
X-Forwarded-Encrypted: i=1; AJvYcCXse8N1o/yvoWcyt9Z76AXCIrlFIfabS2M5L6/ILzLSTuk8cCNZDuL1xKjdFMQN/6mqLLk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrTHxrfp4hVxLlKYJgx0LJ1inkjVEIZdgCqFs68eK4xlSh4YpI
	kptBcDPCL7VsFn8c6u4eGWKypaEVgU3uTXxw/48KNKMTygHEQJFDMGX18+rHxZBFB1HLIuDwWqz
	cekNZrzQXC+TkRd4McwGMCnN6n1gQ/OAUaHFxEH7lW26LklWZ8AY2AQ==
X-Gm-Gg: ASbGncsY5sU1q7op50C391gqpao4QrsXhpAR7uEzNSjoHZpPK8MSI4IWEuyuHHNRrcO
	3yBabS80NAjaNgASbN6UBsWV3Mlaz2sqO10kkL/8zjAuvKRHBdBiMby3An52kBB9dKqiH5ywtkB
	TBGdOaZvII0Pg0rUcabx6iPd2h/oWaNcN2mZ6ZgsuPgWlwWJ8mMr9HdEx8zXjLwkZomJHFy/RfC
	bkhKXiGe/tGG1iF4R8am/RhZxuHc/0nFCCHyminGkucNXsoOfYhf+PfRO4B8H3qiAj5Mm24vQ9H
	48IKi8zjppl3UXx1rKMu4if9Vbg=
X-Received: by 2002:a5d:6f12:0:b0:3a5:541c:b40f with SMTP id ffacd0b85a97d-3b5e866b02bmr2207648f8f.9.1752143360040;
        Thu, 10 Jul 2025 03:29:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEP+KlTnZ761Q6UY9fIQIXQSv43xuQra8a1ir/3lJsDWF78oojl38M+s7mgvd2ajLHSrEGAjg==
X-Received: by 2002:a5d:6f12:0:b0:3a5:541c:b40f with SMTP id ffacd0b85a97d-3b5e866b02bmr2207610f8f.9.1752143359427;
        Thu, 10 Jul 2025 03:29:19 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.202.169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc3a62sm1474020f8f.40.2025.07.10.03.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jul 2025 03:29:18 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH] KVM: Documentation: document how KVM is tested
Date: Thu, 10 Jul 2025 12:29:17 +0200
Message-ID: <20250710102917.250176-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Proper testing greatly simplifies both patch development and review,
but it can be unclear what kind of userspace or guest support
should accompany new features. Clarify maintainer expectations
in terms of testing expectations; additionally, list the cases in
which open-source userspace support is pretty much a necessity and
its absence can only be mitigated by selftests.

While these ideas have long been followed implicitly by KVM contributors
and maintainers, formalize them in writing to provide consistent (though
not universal) guidelines.

Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/review-checklist.rst | 92 +++++++++++++++++++--
 1 file changed, 87 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/review-checklist.rst b/Documentation/virt/kvm/review-checklist.rst
index 7eb9974c676d..87d5aee4366c 100644
--- a/Documentation/virt/kvm/review-checklist.rst
+++ b/Documentation/virt/kvm/review-checklist.rst
@@ -21,8 +21,7 @@ Review checklist for kvm patches
 6.  New cpu features should be exposed via KVM_GET_SUPPORTED_CPUID2,
     or its equivalent for non-x86 architectures
 
-7.  Emulator changes should be accompanied by unit tests for qemu-kvm.git
-    kvm/test directory.
+7.  The feature should be testable (see below).
 
 8.  Changes should be vendor neutral when possible.  Changes to common code
     are better than duplicating changes to vendor code.
@@ -37,6 +36,89 @@ Review checklist for kvm patches
 11. New guest visible features must either be documented in a hardware manual
     or be accompanied by documentation.
 
-12. Features must be robust against reset and kexec - for example, shared
-    host/guest memory must be unshared to prevent the host from writing to
-    guest memory that the guest has not reserved for this purpose.
+Testing of KVM code
+-------------------
+
+All features contributed to KVM, and in many cases bugfixes too, should be
+accompanied by some kind of tests and/or enablement in open source guests
+and VMMs.  KVM is covered by multiple test suites:
+
+*Selftests*
+  These are low level tests included in the kernel tree.  While relatively
+  challenging to write, they allow granular testing of kernel APIs.  This
+  includes API failure scenarios, invoking APIs after specific guest
+  instructions, and testing multiple calls to ``KVM_CREATE_VM`` within
+  a single test.
+
+``kvm-unit-tests``
+  A collection of small guests that test CPU and emulated device features
+  from a guest's perspective.  They run under QEMU or ``kvmtool``,
+  are relatively easy to write.  `kvm-`unit-tests`` are generally not
+  KVM-specific; they can be run with any accelerator that QEMU support
+  or even on bare metal, making it possible to compare behavior across
+  hypervisors and processor families.
+
+Functional test suites
+  Various sets of functional tests exist, such as QEMU's ``tests/functional``
+  suite and `avocado-vt <https://avocado-vt.readthedocs.io/en/latest/>`__.
+  These typically involve running a full operating system in a virtual
+  machine.
+
+The best testing approach depends on the feature's complexity and
+operation. Here are some examples and guidelines:
+
+New instructions (no new registers or APIs)
+  The corresponding CPU features (if applicable) should be made available
+  in QEMU.  If the instructions require emulation support or other code in
+  KVM, it is worth adding coverage to ``kvm-unit-tests`` or selftests.
+  While selftests are generally larger and harder to write, they may be
+  a better choice if the instructions relate to an API that already
+  has good selftest coverage.
+
+New hardware features (new registers, no new APIs)
+  These should be tested via ``kvm-unit-tests``; this more or less implies
+  supporting them in QEMU and/or ``kvmtool``.  In some cases selftests
+  can be used instead, similar to the previous case, or specifically to
+  test corner cases in guest state save/restore.
+
+Bug fixes and performance improvements
+  These usually do not introduce new APIs, but it's worth sharing
+  any benchmarks and tests used to validate your contribution,
+  ideally in the form of regression tests.  Tests and benchmarks
+  can be included in either ``kvm-unit-tests`` or selftests, depending
+  on the specifics of your change.  Selftests are especially useful for
+  regression tests because they are included directly in Linux's tree.
+
+Large scale internal changes
+  While it's difficult to provide a single policy, you should ensure that
+  the changed code is covered by either ``kvm-unit-tests`` or selftests.
+  In some cases the affected code is run for any guests and functional
+  tests suffice.  Explain your testing process in the cover letter,
+  as that can help identify gaps in existing test suites.
+
+New APIs
+  It is important to demonstrate your use case.  This can be as simple as
+  explaining that the feature is already in use on bare metal, or it can be
+  a proof-of-concept implementation in userspace.  The latter need not be
+  open source, though that is of course preferrable for easier testing.
+  Selftests should test corner cases of the APIs, and should also cover
+  basic guest operation if no open source VMM uses the feature.
+
+Bigger features, usually spanning host and guest
+  These should be supported by Linux guests, with limited exceptions
+  for Hyper-V features that are testable on Windows guests.  It is
+  strongly suggested that the feature be usable exclusively with open
+  source code, including in at least one of QEMU or crosvm.  Selftests
+  should test at least API error cases.  Guest operation can be
+  covered by either selftests of ``kvm-unit-tests`` (this is especially
+  important for paravirtualized and Windows-only features).  Strong
+  selftest coverage can also be a replacement for implementation in an
+  open source VMM, but this is generally not recommended.
+
+Following the above suggestions for testing in selftests and
+``kvm-unit-tests`` will make it easier for the maintainers to review
+and accept your code.  In fact, even before you contribute your changes
+upstream it will make it easier for you to develop for KVM.
+
+Of course, the KVM maintainers reserve the right to require more tests,
+though they may also waive the requirement from time to time.
-- 
2.50.0


