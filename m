Return-Path: <kvm+bounces-10688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 630DE86E9D7
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:42:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83B7C1C23FDC
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D24B3E477;
	Fri,  1 Mar 2024 19:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="fChSHdTz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-1909.mail.infomaniak.ch (smtp-1909.mail.infomaniak.ch [185.125.25.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3C23D0D0
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709322060; cv=none; b=hnZsBmTR6jRCgc16NO+moadHfyHSDD31YSrDuB+FP9aEtlbSNtvHP1+NgNKBlou0HMps2rKfN8GaOBZCyal0rvRPv5/O+gdvuyb6fcCYz3r8CyrjjswG63Aaa12Xmxzjrif8VdYBWzpiPHCkL7lPTFygsjrpOxyob5wGwkuBf/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709322060; c=relaxed/simple;
	bh=DPORhoRZEnU1cQKeBuJfHN1o+MHucoCrB95swcPKhLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZhEIq+GW02PBEq3cqgwkWBAfyzB+WGtn4kpmvJ2AVVd+3V62igIq2Lf/kNXe6IwDM94WIM58qaD0qprhJv2UM4HPNh1E8FaQk9KzUz8rHWjg/o1G9Ze7ohHZmd5q3xFuekPfACwkwgY+KToGIUilHyXWOnjaKREUG9EHi6tTKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=fChSHdTz; arc=none smtp.client-ip=185.125.25.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Tmdjz6gWhzmb4;
	Fri,  1 Mar 2024 20:40:55 +0100 (CET)
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Tmdjz0TdjzwCq;
	Fri,  1 Mar 2024 20:40:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709322055;
	bh=DPORhoRZEnU1cQKeBuJfHN1o+MHucoCrB95swcPKhLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fChSHdTzp5ZG85c0ScaUg12C67logz6ezII4opXH0NIXTIBddr/aw7I/Tljnrr+QM
	 HKxQtwDsSIAygpXXbDRE6/d0Mbsv2UFKE2FvPzPdKKqeDNWdvtkywHqcMT4kPVbK1k
	 I+VGFmaOPdgwkIY1vE6mGMsimqFd93AHPdBCkBkQ=
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
Subject: [PATCH v2 5/7] kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
Date: Fri,  1 Mar 2024 20:40:35 +0100
Message-ID: <20240301194037.532117-6-mic@digikod.net>
In-Reply-To: <20240301194037.532117-1-mic@digikod.net>
References: <20240301194037.532117-1-mic@digikod.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

Fix KUNIT_SUCCESS() calls to pass a test argument.

This is a no-op for now because this macro does nothing, but it will be
required for the next commit.

Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: David Gow <davidgow@google.com>
Cc: Rae Moar <rmoar@google.com>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20240301194037.532117-6-mic@digikod.net
---

Changes since v1:
* Added Kees's Reviewed-by.
---
 lib/kunit_iov_iter.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/kunit_iov_iter.c b/lib/kunit_iov_iter.c
index 859b67c4d697..27e0c8ee71d8 100644
--- a/lib/kunit_iov_iter.c
+++ b/lib/kunit_iov_iter.c
@@ -139,7 +139,7 @@ static void __init iov_kunit_copy_to_kvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -194,7 +194,7 @@ static void __init iov_kunit_copy_from_kvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 struct bvec_test_range {
@@ -302,7 +302,7 @@ static void __init iov_kunit_copy_to_bvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -359,7 +359,7 @@ static void __init iov_kunit_copy_from_bvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 static void iov_kunit_destroy_xarray(void *data)
@@ -453,7 +453,7 @@ static void __init iov_kunit_copy_to_xarray(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -516,7 +516,7 @@ static void __init iov_kunit_copy_from_xarray(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -596,7 +596,7 @@ static void __init iov_kunit_extract_pages_kvec(struct kunit *test)
 stop:
 	KUNIT_EXPECT_EQ(test, size, 0);
 	KUNIT_EXPECT_EQ(test, iter.count, 0);
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -674,7 +674,7 @@ static void __init iov_kunit_extract_pages_bvec(struct kunit *test)
 stop:
 	KUNIT_EXPECT_EQ(test, size, 0);
 	KUNIT_EXPECT_EQ(test, iter.count, 0);
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -753,7 +753,7 @@ static void __init iov_kunit_extract_pages_xarray(struct kunit *test)
 	}
 
 stop:
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 static struct kunit_case __refdata iov_kunit_cases[] = {
-- 
2.44.0


