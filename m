Return-Path: <kvm+bounces-45540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 728A5AAB61B
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ED753AB7D6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E975C34F3E7;
	Tue,  6 May 2025 00:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jzGaPiKt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085652FC0F5
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487455; cv=none; b=TOmcHQ6UfEz1QlwqlzsXv3FwjWBLxhbRDNklW8FLgIomSMh0jB0VlQv8pIQmHmgndclIavUiwjryQbe3zW+UM95/74Lrj2OCFrfZ1Gu/euT4b6pP9bUE2YiSYpudF4MyUxK7cTRCVhQxfw0TGSKjyRDAb9W59aXSHhwhN5UVxs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487455; c=relaxed/simple;
	bh=VnT71K8Ea2O5Onxo6pSBB5UNJtKdovZ2hzSFYNY+2bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNFZzSXrXPCBQaQrk5bRFzeOYLwyQcp53XwPRsbZ3f5b+OrEBXcctB9fv9kRSf7ocHXus86kcn2f20qS2uP5N4U2dTqwW5Uq9HNZ4cG1dKKUaoco+4G+z4UUVF82XBfxNtf6eR93e6YPYmlj/DU5t52BK2NvY3086I/QB7LsG4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jzGaPiKt; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-224341bbc1dso65422035ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487452; x=1747092252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11Q55+gMF5u6Eo9NyNW4V+s1ceVG/+YyEcTpuHMGI4c=;
        b=jzGaPiKtC6wd6rr8hlaxDeJfH/QtFaTcIfwiSZPUpKLFiOHDLkLLvBiA61lG9yz1eN
         Hjjt2J/l1NoJTGF8oH140J44P3+gnielklas6fJzjcl7m7ozHSsHjwTSja73at/XFc7t
         GK6g+EG7EHE3SMdqr8fcBJmtYwfin7z5Ar1smNpNZOrcMvO0nVwthanq907eaotTAGOm
         T5KMWNi5vw41tu2OF4mFiuhvC9mewEZp/KgGfb5JctzszaiQohBFerU6DD5GSRO55Orc
         +6ta6u4Ry58hnqgiSlz+Uk6jh4xCOLwjY0HnpiEdjBL+CIFzVRM7eX7XacfaDKTUELP3
         uyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487452; x=1747092252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11Q55+gMF5u6Eo9NyNW4V+s1ceVG/+YyEcTpuHMGI4c=;
        b=MnAb80HaRvxdFUfFBGPyoVfPjQTx+zGX2h+PDva/qzd8Mb7BJb0gmy5gzjPp8SIOzN
         V2hPfYJbvVynzGqBVtX9cVYFbPK/mR+IqYWUvYjLN39uRm1HXa6msuoJAysYkkcbPmox
         Il4lZWXWXESshYYYnZ1C67xpp1lStD+5sL01R95OuXLX+nKsV0HMWwQwhHFn4bcDA++4
         I7QJ7s665Qgmy1ApzXEBmO5QzuwHhtUWYLJD3dnJmxLAM/rW776nFr+dRzyv7Sgx8/Ss
         MJKdcrjoxC+mCl2xgeQ7M3DYXMNlT83d0gN4WKXpZ9wYP1JCAI2olj/bt4nEsog1pip5
         FS7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXfP5LR3QbXx1opBSqU5Aa9A8mPtG/vxCnwzMbhtudk3BZb4Rxt9hSZj2h3sKJQAHy6P1o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx13k3f7wtDirU0HZSMaWx+mPN6qeHxV06d4V2YLjW+3TFrEtXA
	iCSYplEe9K9o0SWBLRqg7gnQpRdqsW8/1GmeuRthSNcMR8HI3SPLyy4I34HeZEA=
X-Gm-Gg: ASbGncsmYeEAk+N5uRRlz/F/EbMLxNsnZQHL3FdzRgi27fLLikB2fuWDiG/p46daMhp
	DYCw/+gvVLW1XeOJtzolCUw5WF3pQBwhjmeBZRDyHpwKuqKC00tY26rv6XcRPjqerGQGEbXCeiT
	hzZgT11i1N7C9aWN9Q0A6bf0cc72JU21bWHOoqdAYxVnVOznL+QEoY42subY62xDHve/D9pCyLG
	8bYPQhXICDi/mI+XCF0WxXt58Desio4w12KN9EnqEGMWVa+wqFeVBEDJ4Yj0irTj8q2rlo/w0O3
	o87OYM/a/ziUo4I2FmZ4DAmBS6uLJBhTXWCUf9fRI2e2WHfCzSk=
X-Google-Smtp-Source: AGHT+IHEfEn8enc/UUEJkyenE0/ZzWHcJwnmTdVTyMTIF5jEMniI55M6dBRUpyvPtgQEw4fn++nWVg==
X-Received: by 2002:a17:902:c412:b0:220:cd9f:a180 with SMTP id d9443c01a7336-22e365b89d7mr13254335ad.53.1746487452569;
        Mon, 05 May 2025 16:24:12 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:12 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 45/50] target/arm/tcg/neon_helper: compile file twice (system, user)
Date: Mon,  5 May 2025 16:20:10 -0700
Message-ID: <20250505232015.130990-46-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/neon_helper.c | 4 +++-
 target/arm/tcg/meson.build   | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/neon_helper.c b/target/arm/tcg/neon_helper.c
index e2cc7cf4ee6..2cc8241f1e4 100644
--- a/target/arm/tcg/neon_helper.c
+++ b/target/arm/tcg/neon_helper.c
@@ -9,11 +9,13 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "vec_internal.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define SIGNBIT (uint32_t)0x80000000
 #define SIGNBIT64 ((uint64_t)1 << 63)
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 02dfe768c5d..af786196d2f 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -32,7 +32,6 @@ arm_ss.add(files(
   'translate-vfp.c',
   'm_helper.c',
   'mve_helper.c',
-  'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
   'vec_helper.c',
@@ -68,8 +67,10 @@ arm_common_ss.add(files(
 arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
-- 
2.47.2


