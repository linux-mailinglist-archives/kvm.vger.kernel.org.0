Return-Path: <kvm+bounces-33457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6344B9EBE00
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 23:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C8BCB283FED
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 22:44:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070CB1F1932;
	Tue, 10 Dec 2024 22:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yekHXpLX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39FC1EE7BD
	for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 22:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733870680; cv=none; b=tmTpIyqfWTiMscNlnSOn6PUa9qufaqK9yNwkj1AV8SOj2AnITucOpwnIVf6WO4lXFrfcvPrsJpiIN1PFbEhgjJ0TmG/KrajiOYkD2i5wtG1xbndqAFdQGnl+LWK7QviPma4QwU5oXIeQE6tZOUPTSm9GUDItOELwgjyEV2AIR7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733870680; c=relaxed/simple;
	bh=u9leJh1meIuUaI/1M+S+UmdCfL/JpflDsWChpBlbaQ0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=lRByAkk8wKrXob+JLIKxhUdOadhGxFpFTIIYYLHUow1c0BNTZT1hijVCyC5NhkOw4eU46IKZ0UygLv1tan8OEsVYCeACSDGHgWDoBrs2N1JMw3y8HTXDM5VhO6bUw2oKICpL4f4MXoGMRy93hBqmp2U4Xnkv1QgCHm9VhurY7zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yekHXpLX; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3a81684bac0so62701745ab.0
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2024 14:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733870678; x=1734475478; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qqk+CWWqN5rq/MGB/yHuis8ZQybMADaRH3hk0OV3uFc=;
        b=yekHXpLX+E2jJHHo8MvEQkcunPSy8qjbKcTNBtQErx6td5w0k5BQJOGkPiTDDYFT5Z
         b++cL5CA7hgHl5U0DnU6ENsvXL/iK5lptiXXFVmTJZhb+zvuK2fDMan4CdeEHZVyIwmA
         bnEddXaS7N0X+TbVbVv+Dh0hMTqJwRAEokdCznWiuI3Ly+XTKHPaQH8HtAXrjIAp7i2c
         uW6BqdBC7cHpacBsbziD3qZaEsu8+9q3zU7Z5pud8YYqe/frP49nh8UsVNFAtcPqRoZN
         qYanLMURSLIFIu6v2Fu0ex2Wf0BQzX9GpHUgfAxz1HCr37PbL64GbVOAO5oq+3c/wpmA
         7k4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733870678; x=1734475478;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qqk+CWWqN5rq/MGB/yHuis8ZQybMADaRH3hk0OV3uFc=;
        b=H1pRAtx9A9GMaDhtKO6AvcedMFhQ7MHSc3ZK0S3lyi7p7xHO+drkyArjkOF0uVAp4F
         f61v8TtJXkGkZTelPRzXI18fcX7soWbT11S+uLCM+VhT1jAY8gEubwusb9XOod/YXZ76
         UaL4E/FgxVt7ansd5MJSU99AALxctpgU137J+HbRzkINXHDHM1t7W76e4vRZxKRdo3ri
         mtm2BtPG+65dAygwBrPjyxW8gDby+gf9EGkaLIS+0I/MuKFxIsWo5MLx8gYEWEQdxX6Q
         co1Lz+HXfem4c1Q43eVr1QBcLZqd7vtZk9PgnNCwc7qluI6Pk0P3GHWQqmzQG8VS7m7W
         1xFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBZSVYM2FW9McvYmMFeMI8jeE/6WxqbXKMAz5Ae4n8aQnliZlX+m8khSTk5jKOY9UwyUQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3TsBaIEvT1X9qhBxmSbxDaF+eZJ33/1UcFm0TEsJ8A4wIbqVY
	yY4Z+eLbx/3viqXJgfM+hdaHHQt9wwi8iM85uUAkrKQMN8Zlx+zTfMtHKf1uQXcUbYNBC4a+Ht1
	BAR5KwA==
X-Google-Smtp-Source: AGHT+IET+QW/GxpL9rCtfukOBZmUY2qfXT9xKNqc21i3LI6O4efNul9iMc8xel/3eEjF4fnde26kqvcpA/Uu
X-Received: from ilgm9.prod.google.com ([2002:a92:4b09:0:b0:3a7:cfdb:57d])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:1384:b0:3a7:5cda:2769
 with SMTP id e9e14a558f8ab-3aa06bee07cmr8003405ab.12.1733870677912; Tue, 10
 Dec 2024 14:44:37 -0800 (PST)
Date: Tue, 10 Dec 2024 22:44:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241210224435.15206-1-rananta@google.com>
Subject: [PATCH] selftests/rseq: Fix rseq for cases without glibc support
From: Raghavendra Rao Ananta <rananta@google.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Raghavendra Rao Anata <rananta@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Currently the rseq constructor, rseq_init(), assumes that glibc always
has the support for rseq symbols (__rseq_size for instance). However,
glibc supports rseq from version 2.35 onwards. As a result, for the
systems that run glibc less than 2.35, the global rseq_size remains
initialized to -1U. When a thread then tries to register for rseq,
get_rseq_min_alloc_size() would end up returning -1U, which is
incorrect. Hence, initialize rseq_size for the cases where glibc doesn't
have the support for rseq symbols.

Cc: stable@vger.kernel.org
Fixes: 73a4f5a704a2 ("selftests/rseq: Fix mm_cid test failure")
Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/rseq/rseq.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 5b9772cdf265..9eb5356f25fa 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -142,6 +142,16 @@ unsigned int get_rseq_kernel_feature_size(void)
 		return ORIG_RSEQ_FEATURE_SIZE;
 }
 
+static void set_default_rseq_size(void)
+{
+	unsigned int rseq_kernel_feature_size = get_rseq_kernel_feature_size();
+
+	if (rseq_kernel_feature_size < ORIG_RSEQ_ALLOC_SIZE)
+		rseq_size = rseq_kernel_feature_size;
+	else
+		rseq_size = ORIG_RSEQ_ALLOC_SIZE;
+}
+
 int rseq_register_current_thread(void)
 {
 	int rc;
@@ -219,12 +229,7 @@ void rseq_init(void)
 			fallthrough;
 		case ORIG_RSEQ_ALLOC_SIZE:
 		{
-			unsigned int rseq_kernel_feature_size = get_rseq_kernel_feature_size();
-
-			if (rseq_kernel_feature_size < ORIG_RSEQ_ALLOC_SIZE)
-				rseq_size = rseq_kernel_feature_size;
-			else
-				rseq_size = ORIG_RSEQ_ALLOC_SIZE;
+			set_default_rseq_size();
 			break;
 		}
 		default:
@@ -239,8 +244,10 @@ void rseq_init(void)
 		rseq_size = 0;
 		return;
 	}
+
 	rseq_offset = (void *)&__rseq_abi - rseq_thread_pointer();
 	rseq_flags = 0;
+	set_default_rseq_size();
 }
 
 static __attribute__((destructor))

base-commit: 40384c840ea1944d7c5a392e8975ed088ecf0b37
-- 
2.47.0.338.g60cca15819-goog


