Return-Path: <kvm+bounces-16751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F848BD372
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:59:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 557F21F21D63
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 16:59:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5056C15AD9F;
	Mon,  6 May 2024 16:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="e6NUSV71"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-bc09.mail.infomaniak.ch (smtp-bc09.mail.infomaniak.ch [45.157.188.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0EC15A49D
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 16:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715014544; cv=none; b=obKuUVqkhfzBzR8DHM8L0GnA1g2Jh5kjvsYqXgEqyE2nzIyvXw5VIh9Lv0NqF6Ky37/BFm/rOsBH7gK/xRv3rngFcFep1ss7WvTkyR03npMHNRndewKRI+q05ffytzP8eKsG8Ai/3RWRnpOS30IwJ3Co4wZ/FNzf8cYRxyak1Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715014544; c=relaxed/simple;
	bh=BB/R9QYU0sTJD/1/5meoYUG98o9LfMjjjUh7AtLA7CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KkTuLRKaHsmDkUmIUnPje32XJHMduf0bcMzK/CO8NXELXnMkFFyZBLQ33PjxYnHFr0VjW7IG50ZlM6eBYVdQIr0eCFqeWI0Ufwo122IxSMYUYNuR5CYBXoAH5viHJ/teOWkmDD1ke25tMZqUCXuNvbl/ie1boPma/VnlSRKqYUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=e6NUSV71; arc=none smtp.client-ip=45.157.188.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VY6wl1VG5z1Bk;
	Mon,  6 May 2024 18:55:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1715014535;
	bh=BB/R9QYU0sTJD/1/5meoYUG98o9LfMjjjUh7AtLA7CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6NUSV71Lz/Uw6XNJ1YY0EqMg/NSMSyRlEW7pkzFFN6aS6aP5RxHA7QtQno4Eoh6r
	 cUvygZdyOVRmsrEg7/+nOw5Gd98pntS23YuZat1jPEk8GF38dTjaAuMRr9Hc7Y9Gc8
	 JyGMERUFVwtKcCOxMAnbs31XXbE6KH1T5K5j291o=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VY6wk4fKRzRPx;
	Mon,  6 May 2024 18:55:34 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Christian Brauner <brauner@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Shengyu Li <shengyu.li.evgeny@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Brendan Higgins <brendanhiggins@google.com>,
	David Gow <davidgow@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Ron Economos <re@w6rz.net>,
	Ronald Warsow <rwarsow@gmx.de>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Will Drewry <wad@chromium.org>,
	kernel test robot <oliver.sang@intel.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v6 10/10] selftests/harness: Handle TEST_F()'s explicit exit codes
Date: Mon,  6 May 2024 18:55:18 +0200
Message-ID: <20240506165518.474504-11-mic@digikod.net>
In-Reply-To: <20240506165518.474504-1-mic@digikod.net>
References: <20240506165518.474504-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

If TEST_F() explicitly calls exit(code) with code different than 0, then
_metadata->exit_code is set to this code (e.g. KVM_ONE_VCPU_TEST()).  We
need to keep in mind that _metadata->exit_code can be KSFT_SKIP while
the process exit code is 0.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Drewry <wad@chromium.org>
Reported-by: Sean Christopherson <seanjc@google.com>
Tested-by: Sean Christopherson <seanjc@google.com>
Closes: https://lore.kernel.org/r/ZjPelW6-AbtYvslu@google.com
Fixes: 0710a1a73fb4 ("selftests/harness: Merge TEST_F_FORK() into TEST_F()")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240506165518.474504-11-mic@digikod.net
---

Changes since v5:
* Update commit message as suggested by Sean.

Changes since v4:
* Check abort status when the grandchild exited.
* Keep the _exit(0) calls because _metadata->exit_code is always
  checked.
* Only set _metadata->exit_code to WEXITSTATUS() if it is not zero.

Changes since v3:
* New patch mainly from Sean Christopherson.
---
 tools/testing/selftests/kselftest_harness.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index eb25f7c11949..7612bf09c5f8 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -462,9 +462,13 @@ static inline pid_t clone3_vfork(void)
 		munmap(teardown, sizeof(*teardown)); \
 		if (self && fixture_name##_teardown_parent) \
 			munmap(self, sizeof(*self)); \
-		if (!WIFEXITED(status) && WIFSIGNALED(status)) \
+		if (WIFEXITED(status)) { \
+			if (WEXITSTATUS(status)) \
+				_metadata->exit_code = WEXITSTATUS(status); \
+		} else if (WIFSIGNALED(status)) { \
 			/* Forward signal to __wait_for_test(). */ \
 			kill(getpid(), WTERMSIG(status)); \
+		} \
 		__test_check_assert(_metadata); \
 	} \
 	static void __attribute__((constructor)) \
-- 
2.45.0


