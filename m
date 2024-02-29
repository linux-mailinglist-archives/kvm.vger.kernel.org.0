Return-Path: <kvm+bounces-10531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C289C86D01B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 18:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5F2081F214BF
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 17:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3705D7A154;
	Thu, 29 Feb 2024 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="tSl8YApK"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [84.16.66.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987D93770C
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=84.16.66.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709226280; cv=none; b=SxOsiY19JwsrHi1sZjgiXc42IU/XGMmZ02l6d2ek6wm2Em2ZxEDp4YdrsGwSo8YY+j/RdT2QFeOBznHiIJQcfXy974oNnT6SwO9j9Y7Q9fQm6SwEK7SG0Lk7t9jFolCANP+fSdCVE3AbfLTZh5+MIWqXNjRxV5srh5S/E8dvNFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709226280; c=relaxed/simple;
	bh=njKd78Dlxcb8LNFqK0Y6SC5BCIGDfZPNfNKkSCugFkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ICffkD2Z2y4FHSZJz+vY/i51kIl0iuOWcYh+WHGsXOZDdNrX+dg5XcECYnc533+/y68sKp3VbonzURpSzkiyu1p+N24fvU8Qg7dCgM8soUfopFCn3bchSFTBvsxdW2XekGkFnsD+3trNOEELmuQOjqaEnYtNjsGrSo3injJP4QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=tSl8YApK; arc=none smtp.client-ip=84.16.66.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TlyHy3694zMrkv9;
	Thu, 29 Feb 2024 18:04:30 +0100 (CET)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4TlyHx3kNwzMppVF;
	Thu, 29 Feb 2024 18:04:29 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709226270;
	bh=njKd78Dlxcb8LNFqK0Y6SC5BCIGDfZPNfNKkSCugFkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tSl8YApK6lTMIm1P9is6nUyb70iS56zUvtW6vvPpqkeaUL8jxgCoM51JKQUjF9ssj
	 cY8uUxa/dhGRdbk00nKuP/PM9L467aNrqqbYwMVsbB96Q4+RBvLJokVbpLp5r41i8A
	 FSsOtrx+hLcfiz7OU/wAdcXDQcIhO/+DrngS1G5A=
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
Subject: [PATCH v1 6/8] kunit: Fix KUNIT_SUCCESS() calls in iov_iter tests
Date: Thu, 29 Feb 2024 18:04:07 +0100
Message-ID: <20240229170409.365386-7-mic@digikod.net>
In-Reply-To: <20240229170409.365386-1-mic@digikod.net>
References: <20240229170409.365386-1-mic@digikod.net>
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
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 lib/kunit_iov_iter.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/lib/kunit_iov_iter.c b/lib/kunit_iov_iter.c
index a77991a9bffb..b586aa19e45d 100644
--- a/lib/kunit_iov_iter.c
+++ b/lib/kunit_iov_iter.c
@@ -137,7 +137,7 @@ static void iov_kunit_copy_to_kvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -192,7 +192,7 @@ static void iov_kunit_copy_from_kvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 struct bvec_test_range {
@@ -299,7 +299,7 @@ static void iov_kunit_copy_to_bvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -356,7 +356,7 @@ static void iov_kunit_copy_from_bvec(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 static void iov_kunit_destroy_xarray(void *data)
@@ -449,7 +449,7 @@ static void iov_kunit_copy_to_xarray(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -512,7 +512,7 @@ static void iov_kunit_copy_from_xarray(struct kunit *test)
 			return;
 	}
 
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -592,7 +592,7 @@ static void iov_kunit_extract_pages_kvec(struct kunit *test)
 stop:
 	KUNIT_EXPECT_EQ(test, size, 0);
 	KUNIT_EXPECT_EQ(test, iter.count, 0);
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -670,7 +670,7 @@ static void iov_kunit_extract_pages_bvec(struct kunit *test)
 stop:
 	KUNIT_EXPECT_EQ(test, size, 0);
 	KUNIT_EXPECT_EQ(test, iter.count, 0);
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 /*
@@ -749,7 +749,7 @@ static void iov_kunit_extract_pages_xarray(struct kunit *test)
 	}
 
 stop:
-	KUNIT_SUCCEED();
+	KUNIT_SUCCEED(test);
 }
 
 static struct kunit_case iov_kunit_cases[] = {
-- 
2.44.0


