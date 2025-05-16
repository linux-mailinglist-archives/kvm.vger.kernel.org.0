Return-Path: <kvm+bounces-46906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62AA4ABA5BB
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:00:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 009EC7B10EF
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 21:59:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DBE3281520;
	Fri, 16 May 2025 21:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sxAPbcgX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BA3280311
	for <kvm@vger.kernel.org>; Fri, 16 May 2025 21:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747432771; cv=none; b=hjMHSJ820D0BPZ4QAtfniue9yG2oPXvmGv2OA0hHlUOPlSaPqx/dsvDSauQvXEnTbdQF/zyypHPa2KCllVVRUCl7i92BUuswwxi0yUXM162ZLk1mcSx7G5oe66hsE5X/NhEMc6ddqqMSSfUfW6DJfDVOHOMlMpeBGXmRDt5PB/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747432771; c=relaxed/simple;
	bh=fHzQNuAEGzAs0V+/3iJg5MoPsJofX2suDpfAK1XD40o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rxW2zKbeagS5Pg4WqpWBqov6z5mIomRv9/pdDmfLrc9Uo7YeyWF15XZ9m3Qnh72rhmwrMNo51NCFbU0zIeWOUjV6mdrpHXnsPUAG/vlomNeowfixIAt2km2uNl4F4ivgNyplfbg9yecas3HJJNJzj1opgRZWvnxUKI2oARMrc3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sxAPbcgX; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7370e73f690so2966042b3a.3
        for <kvm@vger.kernel.org>; Fri, 16 May 2025 14:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747432769; x=1748037569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KJLKvOEBBRqQbKBXlovuW7nBLdsIgFKyRZr0KCcKFF4=;
        b=sxAPbcgXfTvyZbyytJYNRJy1NoqtZVTDYJPDNdzyB4xvojx1YtX1/Pq/GzfpNGEWph
         iB1jeHLkW1gVBYIF+ABLf7eRf6HauCvGZYDkSpNfU3xOPy36SYObh0p6nRR57auPdhLL
         6J0J5S+Vo5RqjjCmToX9fE+m7ax7rJXgRczl5yn23UBwrT9u8rKMkwwNUJJcosZmV0+I
         lF61EDy3layoGId3gFMAGlpykBTZD+n3PmtkyQjrDHy3aRi1c0lJZkJ4/7veoTR3yuHw
         /tkWgacVKmsqd/R3zX5WodIFT5hJFv00uwaV8pAmTM8DT6/RP2UkH1aPHWkDYuZQbiqC
         XE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747432769; x=1748037569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KJLKvOEBBRqQbKBXlovuW7nBLdsIgFKyRZr0KCcKFF4=;
        b=MVhqMcGqp1u0gW45K3aS1riGEd2EZSWbHMoNU6MrJ/1bUz4sDZ0AtW9bnZcWLBKylw
         Gnapyah9rez3iyU7JI5DKMcZEIk1JbzKvFf9ul4o7tut3IBgps0cwVFmIHB6qLVoRX/u
         3v7hRSJsqviOzaExHbrjrSKH0SnYRsOWKp2KszUcDzidct/glGTcWxTfeARyg/V8HpOr
         zp6bcKenJNFfTRnitNgQRm3UQ/5rZnaD0jK/HCnGcIARhmlO9EJK1EkKDQc2oiN4FD5+
         cWqn+Mf87rhCxyt5Nr01jDwf53mLG+1Hit1pXveOjXciuXUS1oTHyZCycSxBTHO3/Dmm
         kmUg==
X-Gm-Message-State: AOJu0YxBZA+EH09JLbdMbRXDutP0+Fh+jpT670jsCOYIs8HFvJPyPAJw
	xIZgIi77E9d9Z5Uww3d51ZBrSWJYn/KD8tNXR+DKDU2GrlaMoxgQvY2tRlJvIY6POP6CzuoBk32
	SS1n4eQ==
X-Google-Smtp-Source: AGHT+IE+ZDBFv/EaWegJcGZxqlIbLXp60sd2aeiJn9nLSrWpqIbz5IJGRoEqQKdaxj00HZApGs0eC5hkpLs=
X-Received: from pfey12.prod.google.com ([2002:a62:b50c:0:b0:739:485f:c33e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e9b:b0:73e:1e21:b653
 with SMTP id d2e1a72fcca58-742a978e6a3mr6863851b3a.5.1747432769498; Fri, 16
 May 2025 14:59:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 16 May 2025 14:59:09 -0700
In-Reply-To: <20250516215909.2551628-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250516215909.2551628-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1112.g889b7c5bd8-goog
Message-ID: <20250516215909.2551628-5-seanjc@google.com>
Subject: [PATCH 4/4] KVM: selftests: Print a more helpful message for EACCESS
 in access tracking test
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

Use open_path_or_exit() helper to probe /sys/kernel/mm/page_idle/bitmap in
the access tracking perf test so that a helpful/pertinent SKIP message is
printed if the file exists but is inaccessible, e.g. because the file has
the kernel's default 0600 permissions.

Cc: James Houghton <jthoughton@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index da7196fd1b23..c9de66537ec3 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -596,11 +596,8 @@ int main(int argc, char *argv[])
 		if (ret)
 			return ret;
 	} else {
-		page_idle_fd = open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
-		__TEST_REQUIRE(page_idle_fd >= 0,
-			       "Couldn't open /sys/kernel/mm/page_idle/bitmap. "
-			       "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
-
+		page_idle_fd = __open_path_or_exit("/sys/kernel/mm/page_idle/bitmap", O_RDWR,
+						   "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
 		close(page_idle_fd);
 
 		puts("Using page_idle for aging");
-- 
2.49.0.1112.g889b7c5bd8-goog


