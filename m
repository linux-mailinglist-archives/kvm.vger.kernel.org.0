Return-Path: <kvm+bounces-10524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E96286D000
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:04:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DA0928973E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC42E160636;
	Thu, 29 Feb 2024 17:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="nlVkoodR"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [45.157.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650743770C
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 17:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709226275; cv=none; b=W1MHqjdWIf9f2ELu7exMhREgrhRZIdWsmbLI3TpBIN8i8zUlOiGneuQeA1U+41k+zRnOfqxIPqp9ATBbbBeaQdoXbR2D1GffMy+VsHnohXdq4esI00GQH2VYI3SvIlMwNGECUuV2j2kdsjVWNvZ3WHafqwyImsxSeBz7jlCPe3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709226275; c=relaxed/simple;
	bh=4wDdbt4I56G5n6LSUJ2u1jaEVBMsm/64WWZPbsYi9U0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mTBGIvkrM/VRO9iwuXupLPsiz1WojMrdlPLQQUahNWBdi5QcE6VGCMkhJ38MSMvkh86dyBL9gDcS2D7H86gj3CSX78SBgFdFhpvsKaJVEZPpNGBlIc/EbLtG6GjssfOZxdiSI+1xDz8b1ugML9ZeyBJlQALIjMX2gTLTRzKqZlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=nlVkoodR; arc=none smtp.client-ip=45.157.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TlyHp6JJMz5wk;
	Thu, 29 Feb 2024 18:04:22 +0100 (CET)
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4TlyHm47S2zYBH;
	Thu, 29 Feb 2024 18:04:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709226262;
	bh=4wDdbt4I56G5n6LSUJ2u1jaEVBMsm/64WWZPbsYi9U0=;
	h=From:To:Cc:Subject:Date:From;
	b=nlVkoodRGG/+JH60co6QTYI+j/xS/kAvzRqTk/xdhkVfSSC5JtD7P7treNBKoqd0u
	 U5gu49lO236cmDqZAiQi+oFIZbE1jszXjS2h0mslolmhNqIG4IKa/drMCKvMRTmYRX
	 pKXV1VkrqQbG3nE+oEnjraDdG3Vrknapc8Mb93bc=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>,
	Kees Cook <keescook@chromium.org>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Marco Pagani <marpagan@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Thara Gopinath <tgopinath@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>,
	Zahra Tarkhani <ztarkhani@microsoft.com>,
	kvm@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org
Subject: [PATCH v1 0/8] Run KUnit tests late and handle faults
Date: Thu, 29 Feb 2024 18:04:01 +0100
Message-ID: <20240229170409.365386-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Hi,

This patch series moves KUnit test execution at the very end of kernel
initialization, just before launching the init process.  This opens the
way to test any kernel code in its normal state (i.e. fully
initialized).

This patch series also teaches KUnit to handle kthread faults as errors,
and it brings a few related fixes and improvements.

New tests check NULL pointer dereference and read-only memory, which
wasn't possible before.

This is useful to test current kernel self-protection mechanisms or
future ones such as Heki: https://github.com/heki-linux

Regards,

Mickaël Salaün (8):
  kunit: Run tests when the kernel is fully setup
  kunit: Handle thread creation error
  kunit: Fix kthread reference
  kunit: Fix timeout message
  kunit: Handle test faults
  kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
  kunit: Print last test location on fault
  kunit: Add tests for faults

 include/kunit/test.h                |  24 +++++-
 include/kunit/try-catch.h           |   3 -
 init/main.c                         |   4 +-
 lib/bitfield_kunit.c                |   8 +-
 lib/checksum_kunit.c                |   2 +-
 lib/kunit/executor.c                |  81 ++++++++++++++------
 lib/kunit/kunit-example-test.c      |   6 +-
 lib/kunit/kunit-test.c              | 115 +++++++++++++++++++++++++++-
 lib/kunit/try-catch.c               |  33 +++++---
 lib/kunit_iov_iter.c                |  70 ++++++++---------
 tools/testing/kunit/kunit_kernel.py |   6 +-
 11 files changed, 261 insertions(+), 91 deletions(-)


base-commit: d206a76d7d2726f3b096037f2079ce0bd3ba329b
-- 
2.44.0


