Return-Path: <kvm+bounces-17261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EC38C32D3
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 19:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5CACB21033
	for <lists+kvm@lfdr.de>; Sat, 11 May 2024 17:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8311021350;
	Sat, 11 May 2024 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="U/jljERU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [45.157.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49A822EF2
	for <kvm@vger.kernel.org>; Sat, 11 May 2024 17:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715447708; cv=none; b=I3FPyXaTHdn5Sr5c8rboOztTuyJhOEhYI4qq+zYBtFV5yW1PkVzk5stYaED+GD6/NWUyPYooxhjbgemfHVx+Dgjo645JL0dTrn9yiV8c2IU42u7FcNGQwa5KkpkbRSCZekY4GBx93t6RMK87dJ5AxktzJfEG08E5ZJFkS3GGaLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715447708; c=relaxed/simple;
	bh=788u9Ll57Ys8HanKTUXYX18fyulkHMSJMNamEoiF3dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmMg/4zoMN9pIxWnnZllBxq6vrGhF0ECAqHq238dpJUYKtT9E2JaW7IHQbfIW25Tgh+GTXoUs7IcPcvF0eYk+LiRPn9jmEklCVl/ievWjrvgCfutivg7gkzUtcGmGUrcGCZGASajuAuP15N6SZ/R9O3fuAH2XTbYa6m07+yTH0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=U/jljERU; arc=none smtp.client-ip=45.157.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4VcC6v6TSMzkr2;
	Sat, 11 May 2024 19:15:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1715447703;
	bh=iC1DSJl1PeqWX6x9aSS4+KXcksdR90artpUmueb/AB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U/jljERUOqe/Z4nt3Hwt5Pj28zTqnanMqp8O9vWLFujZOzL7mXfibxaPV2aInBVjt
	 jn4aAQ9WNxHiiwOzj/TWzTYsRS2Ywi1OmWkqiPP2Y+N8A7mY8xxG56gbmoSpvKIwZs
	 r+QLALDEbqltuGI3sqESUbU/71VJtaTh1bj9WBCU=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4VcC6v0xg5z82q;
	Sat, 11 May 2024 19:15:03 +0200 (CEST)
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
Subject: [PATCH v7 10/10] selftests/harness: Handle TEST_F()'s explicit exit codes
Date: Sat, 11 May 2024 19:14:45 +0200
Message-ID: <20240511171445.904356-11-mic@digikod.net>
In-Reply-To: <20240511171445.904356-1-mic@digikod.net>
References: <20240511171445.904356-1-mic@digikod.net>
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
Link: https://lore.kernel.org/r/20240511171445.904356-11-mic@digikod.net
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
index cbedb4a6cf7b..3c8f2965c285 100644
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
 	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
-- 
2.45.0


