Return-Path: <kvm+bounces-45367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F18AA8AC8
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDD423A8AD5
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DEED1D5ADC;
	Mon,  5 May 2025 01:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AgmJ8Nla"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C911C84A2
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409969; cv=none; b=ZJNlNWtMtGI4iatKBPFqho92nhPfY7SG/qUlrfEfsjtYPrJEeX4Ql9NK1bIC0TCS3/Fzc+2AezQF4KYheB+WSEqfO6QnldygC/aS/ZdqIHVxz20kVF7cSCW9bxqpuYczUhiJENa7f4yZlYntdCAqPSdGy5Vp9cSUgpw2dtKrSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409969; c=relaxed/simple;
	bh=7eGRZI1+IPQW9UuFfFYtmdus7udvGQrwu8sGRQQhKG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrdOC27flhaioicosFDYDVz/bQB1ogkZzmqvMW2ppluH+vh4Nv1pz2tnv5qvpYHitLiTUFukfvFHRiYuA66mi2/5BnLEbszTLb+aFY1f2OgzPbWhbNx8njFW9j12y5e0sKfnkKQmSpd2YkwI3dcg69EtDDgl0KIFV1gdG/8dvBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AgmJ8Nla; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7376e311086so5536754b3a.3
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409967; x=1747014767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oU3hP1IM611C1WkYpOLE6kbCej9Cg8bXJlI25SZwxm4=;
        b=AgmJ8NlaB+09lzQG+3InNY4NTlxbgHUW1sar3B+S6nf10S/4l2ess80J0WWnoSXABd
         OpdIUOW1YT64uolRXraZPi0Tw/Fjv7J4UdQ1ey/9LmxmSFqVWnYw6agKyiFN/00lqIZd
         SdXkY2k6d+3w5vSXYbb0spQU6QY6J0tIiDKpZp7X84XqQpQdKXbjIpDneIULTzOqvf+Q
         t/cZ0QAkELQIvsXbmjQVCdWyvpotqvsStCiGgyUE+2trlVBVT94gymLOTmc3alcAHzYK
         hOJQfa5kwU0NFNdsDriTRSeblS2pk34aev3DcXwyDnUk4aJWFrdfYLhDPU3efxKVFraT
         AuXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409967; x=1747014767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oU3hP1IM611C1WkYpOLE6kbCej9Cg8bXJlI25SZwxm4=;
        b=GSyp4A/ww9ufM8Rz3mdxJdjCQCGzjYMUoXMmJyxSMQTlXouufPT4fCq8vSMpf5M4iO
         UXyRtJZes/xFGMY0b0aZ7t0BBsqLL+Z0qbPXI63MpmpCsvZvhvI29/ORfmty6cjUOxPD
         6aBUsnR4Dy1aHJuH3X6tZ6TbnPtm9DYBWd7By/FA7nur4ZY65sPG0Yozdy6Hxq1TT+t0
         L4/gc4Iy68lLRQVipDD1F1kBrvsYzktZIfMtKxuArpb7BKD1SifTGUb8g3WRihkI+jvW
         BMAvuNgeddkNNiIYIIouQe+FSdW+cBdxK2SFSLF3aK40fLBgFZ/vvgx5f5P96cFm9dr6
         VrWQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXuoeg8RCX+YJXbXLczKjZoqk3sdAioEWTfFCdkjgesGkgAGJiSzRMFrSejQivuguAdEg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9+ZCuCbRjjqwyK/8/lIG7Mxd3N9QWwRAEGF6Y4DGB1hojSIms
	+YfKetxaThGv7o7JNOVM2e9YcwQaB1AiIx7T6PC8DDh2blVPB+cTtfQ0ND6ZQz4=
X-Gm-Gg: ASbGncs9BEH/Mn8XHJJ4ePiuBLBHgtdiKDCwcfdqG7XdwHFXwfp8Umbsylc9LaeAtQP
	v/1lVhJxpbgzkLnQXf0HdpTtZuzcu7wFUwLuqIJNvthSjQL2GHmuc8LjJq5FFHUB7WWlMmU4Bgo
	xVtg0VeohAzeoF5nBPOoG0gmbEO3yWhRvdxcdD4hYwfJ3NQYJfRknuqzledMtt1m6qLPB+tZ6K+
	/X5PncNDn/EI6M+sIlFFvdODWEmMaf+DZia5lAz5VAdatEw/6DgRFmEzDKMWL8umpT1AUKYSMPh
	nBRBeWz4tJYlmSoAUsT/V2TB2ccr7a/LkjIuduUB
X-Google-Smtp-Source: AGHT+IHKmbEWF+VHflNjPvijvEBJAUUzF3e0M7kh8BDmwXSHYHajkN4Dx8oq8wRS2zFmDBQdPm3PdQ==
X-Received: by 2002:a05:6a20:c995:b0:1f5:8153:9407 with SMTP id adf61e73a8af0-20e96ae202cmr7538095637.20.1746409967316;
        Sun, 04 May 2025 18:52:47 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:46 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 21/48] target/arm/helper: restrict include to common helpers
Date: Sun,  4 May 2025 18:51:56 -0700
Message-ID: <20250505015223.3895275-22-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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
 target/arm/helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7fb6e886306..10384132090 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -12,7 +12,6 @@
 #include "cpu.h"
 #include "internals.h"
 #include "cpu-features.h"
-#include "exec/helper-proto.h"
 #include "exec/page-protection.h"
 #include "exec/mmap-lock.h"
 #include "qemu/main-loop.h"
@@ -35,6 +34,9 @@
 #include "cpregs.h"
 #include "target/arm/gtimer.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define ARM_CPU_FREQ 1000000000 /* FIXME: 1 GHz, should be configurable */
 
 static void switch_mode(CPUARMState *env, int mode);
-- 
2.47.2


