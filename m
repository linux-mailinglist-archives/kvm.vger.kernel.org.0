Return-Path: <kvm+bounces-52528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6EC0B06528
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:30:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6DB43A8BB4
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 17:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF4625F994;
	Tue, 15 Jul 2025 17:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fs78sFOi"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC01184D08
	for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 17:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752600649; cv=none; b=JH7iecfK81CuUhWIAbG8L3cQ6gXP8b5grWHGL7O4kmREmQMZFGubyUp8EVudjJj1qko31puD1xhfH4UQhQN9c4bYxbprZYHOW28cg8vV7XHMdU3JrM583ZOd/qpA1+qZijxvTK8BcR9643gEMkWGJPz04VDru+GwVKdJJH1c5Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752600649; c=relaxed/simple;
	bh=OicMDYwkIxFtbCHm2GkQKVqKCEIne5yDeXU4/6B5SLc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SPe9WEKJQbyLEl9s6d9EddmtIKOsBXxTs9n6WYcpCTuEAiYKULfTo7WLhxiIeEG/5MjFDTEqBrGtSyfUsGKAMd1LVsvsV3YRaLOUwMJV63VdRgZRD7BblZwou51kZ8cFdyDUD8N1rSnepmM2IKmZCvqMdYKwXMI/RMsICjDHSBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fs78sFOi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752600645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qeaioDV5y+/M11cE3dFJNrEA7V3W8i3+YqsMbWa6FZM=;
	b=fs78sFOiJX/W/txVT2bMxEDmPOHoG8tzq8+gwxM1rQBPqfVpFEB619IcdJW9fhLC0rKXb5
	mmptSytD8c3HvU1dh6rgoYNty7I9bw6PKoiK654OAN4mssmOnbfAy0TUiJMKATbFwaYZEu
	YU4v/U9KHbMGoxxXHqTGT6lMg92nx5Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298-qHPe3UrEOcybiPMIgBZHBA-1; Tue, 15 Jul 2025 13:30:44 -0400
X-MC-Unique: qHPe3UrEOcybiPMIgBZHBA-1
X-Mimecast-MFC-AGG-ID: qHPe3UrEOcybiPMIgBZHBA_1752600643
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-456267c79deso4459395e9.1
        for <kvm@vger.kernel.org>; Tue, 15 Jul 2025 10:30:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752600643; x=1753205443;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qeaioDV5y+/M11cE3dFJNrEA7V3W8i3+YqsMbWa6FZM=;
        b=RyEh/fA65+CVj8YQnZz1eGzHBW/oTboVHuZ1AvI3prHlSDJ970gL6m2IP4y8bSOY2H
         RWe4iyYuerq1v1zEXTVKhx9V+HYSHGCG0V0BvJOwKjT3MTCcLbtmRvlaJxeZAzHwfBvx
         8b19qIGYOB9HF9PvmBBOlG6Ohvo/A7EqNgQXpizoTXhVVFJcGh+WW/n4X3/bvseJkWuM
         fMzyg3nRy6GlERFjBWUTbJ45uIFRhWosl1Z6l1RMvZyH4g+CA1Wni5+B3dItDMpa4UMb
         6iGxBwa11DmqXiHTdZXjdFmpnp4X0ES/e625w+cy5GNHn5sKBy93UT9vjYc+qaKasE4e
         KyIA==
X-Forwarded-Encrypted: i=1; AJvYcCWszAYBJc2dve0EP8ko/RMDVkYeVy9R69cGZ4ySjuBf2xWeFm0zHWUj02T9iVdyZohh2qI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr/v2zBATSDCMJ4WrMiasZvOeHGsOIlmN/MjbTcrQRXZ5o3Plp
	LokFSq+6Ip0X9IgdF5choPNO98F2FIvZ5YIq+8hxME+ds08S5CzvKkmOk8p4xAsb5GfJkRms1CH
	n61m3CSoEmuT1GFRVfvCtI/TQRKQb9Agjq8ufHfQq+r1nTNQfsWg0fw==
X-Gm-Gg: ASbGncsxJWuQxwYiBFPJS2Ph6yn/KnS2cagV04R7E6k9WGYq2GNNu41Qqjf2cBBnm+z
	+i9E83i1xFob6MleHlDNdcQNOD4j4cXZmefjAr7iqwXnovxWfj4C6UzgEaFebJ4aGRlCnWTbeOl
	735LireESQVF6s8UzaZdDZoO8LO6uMjX8QwMKUJxbJ//84lL1ecz3pTlF/lwD1s8mMyjZXGem2O
	0rEG7eXGLz9N1m0virntVKMX+3c9LbgAVfeMFfWlIvwBBZuy3y8/xhk8mE7ZwzUUstjvknOpq/C
	tY1wZNz8768LmtQAUL536igXuBBhCsTeNwurTdcbtJg=
X-Received: by 2002:a05:600c:5024:b0:456:1611:cea5 with SMTP id 5b1f17b1804b1-4561611d3d6mr93534155e9.18.1752600642522;
        Tue, 15 Jul 2025 10:30:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgdfzHMYKo96xJPVD8XmG2KZ3Hiiv3pnWqQBgJmnGsb7o44GvKpXjabolY14F3WHgvp7NY0g==
X-Received: by 2002:a05:600c:5024:b0:456:1611:cea5 with SMTP id 5b1f17b1804b1-4561611d3d6mr93533785e9.18.1752600642060;
        Tue, 15 Jul 2025 10:30:42 -0700 (PDT)
Received: from [192.168.122.1] ([151.49.73.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8e1e8cfsm15224072f8f.80.2025.07.15.10.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jul 2025 10:30:41 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@redhat.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v2] KVM: Documentation: document how KVM is tested
Date: Tue, 15 Jul 2025 19:30:40 +0200
Message-ID: <20250715173040.209885-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.50.1
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
 Documentation/virt/kvm/review-checklist.rst | 90 +++++++++++++++++++--
 1 file changed, 85 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/review-checklist.rst b/Documentation/virt/kvm/review-checklist.rst
index 7eb9974c676d..debac54e14e7 100644
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
@@ -37,6 +36,87 @@ Review checklist for kvm patches
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
+  These are low level tests that allow granular testing of kernel APIs.
+  This includes API failure scenarios, invoking APIs after specific
+  guest instructions, and testing multiple calls to ``KVM_CREATE_VM``
+  within a single test.  They are included in the kernel tree at
+  ``tools/testing/selftests/kvm``.
+
+``kvm-unit-tests``
+  A collection of small guests that test CPU and emulated device features
+  from a guest's perspective.  They run under QEMU or ``kvmtool``, and
+  are generally not KVM-specific: they can be run with any accelerator
+  that QEMU support or even on bare metal, making it possible to compare
+  behavior across hypervisors and processor families.
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
+  KVM, it is worth adding coverage to ``kvm-unit-tests`` or selftests;
+  the latter can be a better choice if the instructions relate to an API
+  that already has good selftest coverage.
+
+New hardware features (new registers, no new APIs)
+  These should be tested via ``kvm-unit-tests``; this more or less implies
+  supporting them in QEMU and/or ``kvmtool``.  In some cases selftests
+  can be used instead, similar to the previous case, or specifically to
+  test corner cases in guest state save/restore.
+
+Bug fixes and performance improvements
+  These usually do not introduce new APIs, but it's worth sharing
+  any benchmarks and tests that will validate your contribution,
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
+  basic host and guest operation if no open source VMM uses the feature.
+
+Bigger features, usually spanning host and guest
+  These should be supported by Linux guests, with limited exceptions for
+  Hyper-V features that are testable on Windows guests.  It is strongly
+  suggested that the feature be usable with an open source host VMM, such
+  as at least one of QEMU or crosvm, and guest firmware.  Selftests should
+  test at least API error cases.  Guest operation can be covered by
+  either selftests of ``kvm-unit-tests`` (this is especially important for
+  paravirtualized and Windows-only features).  Strong selftest coverage
+  can also be a replacement for implementation in an open source VMM,
+  but this is generally not recommended.
+
+Following the above suggestions for testing in selftests and
+``kvm-unit-tests`` will make it easier for the maintainers to review
+and accept your code.  In fact, even before you contribute your changes
+upstream it will make it easier for you to develop for KVM.
+
+Of course, the KVM maintainers reserve the right to require more tests,
+though they may also waive the requirement from time to time.
-- 
2.50.1


