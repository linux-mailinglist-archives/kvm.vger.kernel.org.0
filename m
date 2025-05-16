Return-Path: <kvm+bounces-46905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E088ABA5AD
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:00:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3BF174A3EA3
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6AA28136F;
	Fri, 16 May 2025 21:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aH8CvCg6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B14E280311
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432768; cv=none; b=mPgkc5+18wirHE1NXCr7jVuPZ2HSWH5EO95FQq41Dd2N0JzZI2GUr82tFfs1+B9kLaKxeu5sIaBZdZ8SXoUk1U94vkuImsj6LKlKkniZt/GZUaf5tcxOdPivFF5jAi8mMCvmoYBi5xRqmvpq1ybmToP/wVg/5chKsHZFz/yoyOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432768; c=relaxed/simple;
	bh=XuQn38073KHqrzPrijgLyDNDCPtL6wvRlD+O0fD5OUo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AvP25EWQjDxnHD5GVl/G09MCKfTff0s/Q3pegF8eSJr8N9MvvoOJHzpfMQzfruwnCmyB/w8y0LW7h84VnZw33yQD+piFw2qq+X1ZkjfC7Nl7nT3lWYO8iCc11+fR0hTZuuEGyUEDfYuQLoI7fr7i9BCToBtTUFXctO6RvUE3hGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aH8CvCg6; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-742a091d290so1559498b3a.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747432767; x=1748037567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pDqYazeOU2MMjFDIvxd/6WS3ibNxsUMiTmQuhluxDl0=;
        b=aH8CvCg6UAtqjiKGFR1lSxGdgm07KX1kNwfdaQUtus6Jel3GCc/P7DdqUGNMLSes11
         ppQI8rvmyC+8Bb9UNomaRUxmCsNuI0oZKPmTEA+aLUh5plrQ1HJTkGyIffcUNUjniHME
         ApiyKSAnBWBIJOfQjzfbkxLLgBWslWlDjS6U/UM0/XHOJfErUHJLvU1N3hPkLCx7yEVd
         0j6wQVZqUz76lPQo/1cg4ahUx2yQwQ1vQJvJmr868ZDTXWnp1foyCMQaonkyMna9irjv
         OgzmV0G1+CZ1xCPGa1dUv2cw6wk32IQv8Vgaviu2JMztm1yHmPxc6lk6q8kraZGQlkEv
         hfeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747432767; x=1748037567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pDqYazeOU2MMjFDIvxd/6WS3ibNxsUMiTmQuhluxDl0=;
        b=R+a7hff6mL4p5U6br71m0Ey7/ryPB9gv8581rNLzOhSpoTOKwK82OM/4CSRZkMhQJf
         gq9u0a8IqxKnhT8ATvMKzMpaFFvKIpC+sZ1UyWoXxC+iWy41PY9PYq9GjKSgD133wqKI
         xPH3abZ9wqYvOGoIogB4f8Fzrx14CvNn4HlIGStta5t2PWGE7J4ezHKLdRE2H61dZb0w
         aF1XB4IGWzLi1MhVFayxSo9O3B1k0QkfgDWdNLGP/XcFrkl9uOqbjlBIqGCg0Zkrqzek
         pUYgR9z1jczhr4bbI+FA9K6Uum0N12E0B68WQm6BBiKXZFkL1Ux5o/Rk/ernG3ghfhol
         UA4A==
X-Gm-Message-State: AOJu0Yx/7o2GAILFfA60gEGUeP3YJE4tlIMPbWKYudFeiK8TTbTuFEcu
	ENuuRVjBNK941UPS6Q2+N9pxPnS67VbfP3GtpEtF8CPiroWZu0ywYRtbb/iNBEvjPN6FpDTCteS
	zEWp3qg==
X-Google-Smtp-Source: AGHT+IEMpqGq+n5rZKXrfZWJxx7HdXHB3++83H1QA7R+pncGD6kY27CVeqAueI1gRToAFbpOxhL8FJB+P4c=
X-Received: from pgcu198.prod.google.com ([2002:a63:79cf:0:b0:b26:e8ed:2bbe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3289:b0:203:9660:9e4a
 with SMTP id adf61e73a8af0-21621a18c62mr7063111637.41.1747432766886; Fri, 16
 May 2025 14:59:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:59:08 -0700
In-Reply-To: <20250516215909.2551628-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215909.2551628-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516215909.2551628-4-seanjc@google.com>
Subject: [PATCH 3/4] KVM: selftests: Play nice with EACCES errors in open_path_or_exit()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Expand the SKIP conditions of the open_path_or_exit() helper to skip on
EACCES as well as ENOENT.  Most often, lack of permissions to a file
needed by a KVM selftests is due to a file being root-only by default,
not because of any bug/misconfiguration that warrants failing a test.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b133f2b1dbf7..cd415f70de98 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -37,9 +37,10 @@ int __open_path_or_exit(const char *path, int flags, const char *enoent_help)
 	return fd;
 
 error:
-	if (errno == ENOENT)
+	if (errno == EACCES || errno == ENOENT)
 		ksft_exit_skip("- Cannot open '%s': %s.  %s\n",
-			       path, strerror(errno), enoent_help);
+			       path, strerror(errno),
+			       errno == EACCES ? "Root required?" : enoent_help);
 	TEST_FAIL("Failed to open '%s'", path);
 }
 
-- 
2.49.0.1112.g889b7c5bd8-goog


