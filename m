Return-Path: <kvm+bounces-12120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC12187FC20
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 11:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CA381F23021
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 10:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C137E116;
	Tue, 19 Mar 2024 10:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="Q7tT/TcJ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-8fac.mail.infomaniak.ch (smtp-8fac.mail.infomaniak.ch [83.166.143.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2161355C3C
	for <kvm@vger.kernel.org>; Tue, 19 Mar 2024 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710845370; cv=none; b=HVuEsJ6EwZYMjhxzc/ZQ0zvygsIdrbcwJ87z2T6Svurxz17STkymKHyPX7eNIhgHBG+Z28GIDIK/wLaEYBTfTEJ62IK0vRSXoNmn0YFNWwVYih1g/c05obE0ZtxHjKRA1H7EptcRvRFVA2auCMQBjwrtGQ+r0xGNDxF1riaXHbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710845370; c=relaxed/simple;
	bh=titjicsS13zyLYpwVbjFKzsdWlMZsZ9iAVihS7vtrRU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r6k8FXJdhVW+mYioAcWBXXZ9ez8EYW5AY9V61NK9z4qt/3JmLvV4r5q7cuE90OZeKNc6y9JYrPSIotjWh+46EeobgCf4o9Mb1OTME77FyPgL91v3HH9VaBasAb2B4PQy+20+JSZ+DM9upqKFxGr1+4XSzFA8MNvOPjMkfJfU098=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=Q7tT/TcJ; arc=none smtp.client-ip=83.166.143.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TzT4G1GLBzMq3Gc;
	Tue, 19 Mar 2024 11:49:18 +0100 (CET)
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4TzT4D5thVzvGg;
	Tue, 19 Mar 2024 11:49:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1710845358;
	bh=titjicsS13zyLYpwVbjFKzsdWlMZsZ9iAVihS7vtrRU=;
	h=From:To:Cc:Subject:Date:From;
	b=Q7tT/TcJvK7xnZ0yNnH8RKseTWW7HMLg8r+H4B7xE+inCtDOxMj/yIS0gmUAS574p
	 d1VT8nzN0WuOf/YgPmyMQPrKaMGUA+ZhjzVHME00J/VthdkIqwsIZEFZc80GJoFmyR
	 cBePVO0WziY1W198OVLF5Mx5uDP8hjU07byNStJ4=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alan Maguire <alan.maguire@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Kees Cook <keescook@chromium.org>,
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
Subject: [PATCH v3 0/7] Handle faults in KUnit tests
Date: Tue, 19 Mar 2024 11:48:50 +0100
Message-ID: <20240319104857.70783-1-mic@digikod.net>
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

Shuah, everything should be OK now, could you please merge this series?

All these tests pass (on top of v6.8):
./tools/testing/kunit/kunit.py run --alltests
./tools/testing/kunit/kunit.py run --alltests --arch x86_64
./tools/testing/kunit/kunit.py run --alltests --arch arm64 \
  --cross_compile=aarch64-linux-gnu-

I added Reviewed-by, Tested-by and Fixes tags according to previous
review.  I improved a commit message and added a comment.

A new test case check NULL pointer dereference, which wasn't possible
before.

This is useful to test current kernel self-protection mechanisms or
future ones such as Heki: https://github.com/heki-linux

Previous version:
v2: https://lore.kernel.org/r/20240301194037.532117-1-mic@digikod.net
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
 lib/kunit/try-catch.c     | 38 ++++++++++++++++++++++-----------
 lib/kunit_iov_iter.c      | 18 ++++++++--------
 5 files changed, 100 insertions(+), 28 deletions(-)


base-commit: e8f897f4afef0031fe618a8e94127a0934896aba
-- 
2.44.0


