Return-Path: <kvm+bounces-10684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AD58986E9C9
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:41:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 277111F25863
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6E23C684;
	Fri,  1 Mar 2024 19:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="OSrVYlnh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [83.166.143.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E223A8E3;
	Fri,  1 Mar 2024 19:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709322056; cv=none; b=OVpcpyGFcBP8KDT9X9CUq7B4hCnVGSEZgWFMyVxgokJH3CxeKEXNd02iQjBMap5LFKGzs3YgV/BQxY1GswYi+03fF0lJQ25nqfAyEZC0SgrJVL4R6TuM4JBkIXkHghwVXuZVxn68reQUReO3m+pjdo72yTH2c6unEpURvfPl4UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709322056; c=relaxed/simple;
	bh=2OrWNccpx9RIERKaD1LaWkqEFkrgGuR3iwbvIXZvKD4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DffBhjYTFoX3DN6du0v3vQ3OgW62SaltjrDK32nZl4bt86tbG1MjxeJCIQYoYZ0LjheWH9PZSN0uGvr0HlN8J0B1TbKaR+rr/+PIgYIGJatWrp6Mvxl75akUSRWbFmeHHaE5NMnCjJTJBqJ5XiT8vxsZ2lddWU9DitRrhjvV+bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=OSrVYlnh; arc=none smtp.client-ip=83.166.143.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Tmdjs4TkfznjY;
	Fri,  1 Mar 2024 20:40:49 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Tmdjr32Rnz3b;
	Fri,  1 Mar 2024 20:40:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709322049;
	bh=2OrWNccpx9RIERKaD1LaWkqEFkrgGuR3iwbvIXZvKD4=;
	h=From:To:Cc:Subject:Date:From;
	b=OSrVYlnhvWxkk6XfcuTUYzkKfO5Jtwoju81YMT1NYRVqiaCeI2z+/tpHnjDdsMyJ/
	 lO3wu1Mf2w3OCerCjG/QoY9ouNjpOioGbIAvyPlnKE+Yha7vtzB2yRgOXpH95GuzTB
	 5SOB3hqc0ZR5ETY+eNpo67Mod+PwaxNqurlhLF8M=
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
Subject: [PATCH v2 0/7] Handle faults in KUnit tests
Date: Fri,  1 Mar 2024 20:40:30 +0100
Message-ID: <20240301194037.532117-1-mic@digikod.net>
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

This patch series teaches KUnit to handle kthread faults as errors, and
it brings a few related fixes and improvements.

I removed the previous patch that moved the KUnit test execution at the
very end of kernel initialization.  We'll address that with a separate
series.

A new test case check NULL pointer dereference, which wasn't possible
before.

This is useful to test current kernel self-protection mechanisms or
future ones such as Heki: https://github.com/heki-linux

Previous version:
v1: https://lore.kernel.org/r/20240229170409.365386-1-mic@digikod.net

Regards,

Mickaël Salaün (7):
  kunit: Handle thread creation error
  kunit: Fix kthread reference
  kunit: Fix timeout message
  kunit: Handle test faults
  kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
  kunit: Print last test location on fault
  kunit: Add tests for fault

 include/kunit/test.h      | 24 ++++++++++++++++++---
 include/kunit/try-catch.h |  3 ---
 lib/kunit/kunit-test.c    | 45 ++++++++++++++++++++++++++++++++++++++-
 lib/kunit/try-catch.c     | 33 +++++++++++++++++-----------
 lib/kunit_iov_iter.c      | 18 ++++++++--------
 5 files changed, 95 insertions(+), 28 deletions(-)


base-commit: d206a76d7d2726f3b096037f2079ce0bd3ba329b
-- 
2.44.0


