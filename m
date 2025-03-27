Return-Path: <kvm+bounces-42088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F20BA72814
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 02:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F9F73AEC80
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 01:24:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE549383A2;
	Thu, 27 Mar 2025 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NDgnPe2H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com [209.85.219.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A6535959
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 01:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743038694; cv=none; b=ZczzEcRKF4p0nJc53jedMoBR6bCiYZK0+Hoh9QaCWQXYEOdbmFlvOikZwMAuAZv1hr96OMtrqjKhn1CJA2eRi1nUqYd4UjlSsgEeZ8WNoncc4VjZZbBzYR5JqKTz3zRUxkGiAyUhOZaRMldzpldZieSmHCZUme0AXn5XjSeXaDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743038694; c=relaxed/simple;
	bh=sVPmJtk+M0QFe2DpgpAtXxhYDfGr4TqJUl6HVgYb1yE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h8fpvw1HHgukeTS5ufXMB5XUZKzlmJ4K8/Alge70o4XYYouEtQL213y4DMF1TOd3QEzls4SBuFDX6XbYHAO+0jtqvo9b9juHX9VIPcl3PBa7iPDXFiRHuDnQoGhfxQjanTgCk76JOC7ZwElZCujlLbmARpl15mP9/rs2zG80xu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NDgnPe2H; arc=none smtp.client-ip=209.85.219.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qv1-f73.google.com with SMTP id 6a1803df08f44-6ed0cc28f7dso9196806d6.0
        for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 18:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743038691; x=1743643491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=liGs0zsmCzXyApDpxJa5hQb5aVWUAwjiM/fW15pHclY=;
        b=NDgnPe2HKi3P7wPlUM9MeskIM3MiwgVMz+sUgld+TwKnpcFg4vxMhlQlm6JNALCqxh
         iDl29Crucip5+l6BRze2apweoyfR9Y8/+zmeqBSH/JkTWM6jSAO1k1PScLGINCsaouTu
         AGuVD31gTbGOixL4Pk25AqwEFc4ebX2u219f43uHEoKmCziX0QJNSzIWEaYQODc+kC3j
         LpVpkp6NiuN7Vmhhoc5zXaTU9kDWK8tE5VTub6ugCCJKuUPX0ac2XGYYLiZy2vXYP/VY
         A1pKSrDIO87df6y5UIOYhHO22Ci98A/H7/jkw7UGw5Z+xeNX4qWJ74+UdgqcLeryPlcX
         wk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743038691; x=1743643491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=liGs0zsmCzXyApDpxJa5hQb5aVWUAwjiM/fW15pHclY=;
        b=tWWx9tTFbkAr02GHXu1dNAwVh1PcT29fcEpGa9kbe+D3yXEG7/NonLz5MrAd70JYQM
         7is+v3OrAo+z5swnKPCkITLvelKBfYZz9htB5hf69oqaDhbbp8vq6HFaDfi97QlsT3YA
         3wOkh3qg0AtQMKvdXb0fHAoElKBHuuZfO2i8+acucGR5oczrKCiCAufAqfk7GKw/dYRR
         zdOwHKS6Dzg9euHQfWlMNcpPAbQoIvykSEsLCo6VYx6o751ZE6sTCSiLlEV3qL5ueRs/
         0oTpYzRPE1mBhd5i/uvDvLHDwTf/MqCrsmOJZ71a4auKec2nQQvo3YUQEj+tUuQvAOTM
         E7oA==
X-Forwarded-Encrypted: i=1; AJvYcCW5sU6GUtMzc5FEuTrHzi/91EV9e+a9yDm1hKZQmgj0HinkxAy3lqEsapVbe+RF2mO7f/4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKfYkH1rUbf/lAH5xuLL/5NLY2FPZ85qTFd7AsLmrySw5BaxRZ
	+TcG3wsoLGxbfAcUJ+1SDLJdmgPQAv9bagX++ei/HKDO+PQa7uWGB7BJcM4sVkcfZNiImfOEpeW
	Yc55g4Jf6EGYkXO0ABg==
X-Google-Smtp-Source: AGHT+IH7BAFDxR8LyIf/cCmDc14HH7jyC//3aG9i1kJW7Fvp8ZskK6kVxOKCBos5v4Y1+Vq5kmrmwnBeThHJhsNb
X-Received: from qvbrf3.prod.google.com ([2002:a05:6214:5f83:b0:6ec:dd52:e52c])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6214:2585:b0:6e8:fbe2:2db0 with SMTP id 6a1803df08f44-6ed23912adfmr23153566d6.30.1743038691331;
 Wed, 26 Mar 2025 18:24:51 -0700 (PDT)
Date: Thu, 27 Mar 2025 01:23:46 +0000
In-Reply-To: <20250327012350.1135621-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250327012350.1135621-1-jthoughton@google.com>
X-Mailer: git-send-email 2.49.0.395.g12beb8f557-goog
Message-ID: <20250327012350.1135621-2-jthoughton@google.com>
Subject: [PATCH 1/5] KVM: selftests: Extract guts of THP accessor to
 standalone sysfs helpers
From: James Houghton <jthoughton@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Cc: Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yu Zhao <yuzhao@google.com>, James Houghton <jthoughton@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Sean Christopherson <seanjc@google.com>

Extract the guts of thp_configured() and get_trans_hugepagesz() to
standalone helpers so that the core logic can be reused for other sysfs
files, e.g. to query numa_balancing.

Opportunistically assert that the initial fscanf() read at least one byte,
and add a comment explaining the second call to fscanf().

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/kvm/lib/test_util.c | 35 ++++++++++++++-------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index 8ed0b74ae8373..3dc8538f5d696 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -132,37 +132,50 @@ void print_skip(const char *fmt, ...)
 	puts(", skipping test");
 }
 
-bool thp_configured(void)
+static bool test_sysfs_path(const char *path)
 {
-	int ret;
 	struct stat statbuf;
+	int ret;
 
-	ret = stat("/sys/kernel/mm/transparent_hugepage", &statbuf);
+	ret = stat(path, &statbuf);
 	TEST_ASSERT(ret == 0 || (ret == -1 && errno == ENOENT),
-		    "Error in stating /sys/kernel/mm/transparent_hugepage");
+		    "Error in stat()ing '%s'", path);
 
 	return ret == 0;
 }
 
-size_t get_trans_hugepagesz(void)
+bool thp_configured(void)
+{
+	return test_sysfs_path("/sys/kernel/mm/transparent_hugepage");
+}
+
+static size_t get_sysfs_val(const char *path)
 {
 	size_t size;
 	FILE *f;
 	int ret;
 
-	TEST_ASSERT(thp_configured(), "THP is not configured in host kernel");
-
-	f = fopen("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", "r");
-	TEST_ASSERT(f != NULL, "Error in opening transparent_hugepage/hpage_pmd_size");
+	f = fopen(path, "r");
+	TEST_ASSERT(f, "Error opening '%s'", path);
 
 	ret = fscanf(f, "%ld", &size);
+	TEST_ASSERT(ret > 0, "Error reading '%s'", path);
+
+	/* Re-scan the input stream to verify the entire file was read. */
 	ret = fscanf(f, "%ld", &size);
-	TEST_ASSERT(ret < 1, "Error reading transparent_hugepage/hpage_pmd_size");
-	fclose(f);
+	TEST_ASSERT(ret < 1, "Error reading '%s'", path);
 
+	fclose(f);
 	return size;
 }
 
+size_t get_trans_hugepagesz(void)
+{
+	TEST_ASSERT(thp_configured(), "THP is not configured in host kernel");
+
+	return get_sysfs_val("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size");
+}
+
 size_t get_def_hugetlb_pagesz(void)
 {
 	char buf[64];
-- 
2.49.0.395.g12beb8f557-goog


