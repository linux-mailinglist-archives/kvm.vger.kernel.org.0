Return-Path: <kvm+bounces-45391-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ABBEAA8AED
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:56:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF310168422
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 981F51A23B9;
	Mon,  5 May 2025 01:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uTteeaTd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C019C54E
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410189; cv=none; b=B1Qg7z4iqaLmMl6yaujMxV7NNpTnSZcUq2dMPQ2qzhEvcNhIgshe63zGiHwgP7XpkyG32OmzUJdLZ5VJfjeoXypF8ygXinmz7ef6AE4L/mWe6sxq3IcC/+O8XEOXZYsNwo17tMf+Fu3Xn5vQLUwVZM9tJUYhuvtIeNaIpM3TzhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410189; c=relaxed/simple;
	bh=OqxqB8L618kAqzkr9eUccS2oTBGqRWHLGo7rLzhFSd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M6C5eU+ztvg2r+n67uaLjJvjPalhim94lFwXQFUD1QBjXXHmOuNXoKiV/RyTwEAY4IOrRLCtH8l2EbibOQyMSoyVeIqTak+zOFwJuxr7N/FV7AKQ9b4X7/Kum2YNGQ+ZCMJIRJCgwzvHEy9hidToZjvDqTISXD1MxN3sxtfgoAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uTteeaTd; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-30a509649e3so1690388a91.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410187; x=1747014987; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qD9vVqLBGjput0IZ+F6o4hs3gsnwUP4nuOaAH5o+vHU=;
        b=uTteeaTd7r+PSWmuHbPrQTLQVNUko2Pisq5vpAMGAjYQp4yKPNvKzPnIS4SKirPdR3
         UbKRGC6W2FE5LCrhqcKXkB9yQ/fKBLgGXzycB9MV2klhnu10UC9xWR+cQrMmFQ+mdSy0
         lvwSc9WXhU+6TsV2hmA5vj2FDPgVREViyLtBjuSNs+NgFvfqpc0GkxEYxGB1nwZQq/E4
         VmoiAeBSTYgwIZCXWbEpyJXUiLL4pc8niGyhA7f0wXt93IwLvYPd+5BlIGDmVOGTyx3F
         5LSYz7IQmNw7p5K79wdBe7dIyZ+n7X4sEEPeauGiuchI1jx1AQsr9/eXC3dTMxcrHwz9
         nxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410187; x=1747014987;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qD9vVqLBGjput0IZ+F6o4hs3gsnwUP4nuOaAH5o+vHU=;
        b=aahEjjztkPZ8vIkMNLjPv2fldMZ1OBiD5V+fpACgOLcDXpIom259MYTBpSMjrqFQMs
         m7I1MOhmxAIh8CaeG6ZpgmUqhYyC+2Ns1XpoACxN8jR69v0BlSB6rxLAL5PS7n3r95UZ
         s1GcwxJFYl+mqi07CxA2E6g9AmxI4yIYz22g16No821MD5tuUtfoYOsFtst+hc0AsZyx
         AoGcQ6/FrgWwvbSbuGpL8MInXkazVlsdMDZ9nGJ/r5nQJ3PBETjINcmXnalKrFGiM1JW
         LWYCJ8xkiY7BFnxxiURnF1LxebJnKAYv0za2gcllLIn3YO+k0J5uDNop7gdA3pXEhp8b
         MvaA==
X-Forwarded-Encrypted: i=1; AJvYcCXfHi+nrjXuo80YHGLoYUw+9FX8Haq4NuH+sG6Bw1fm/gAw+GxqvJkbF9mb787ckQMQ5wk=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywli3pIzWN3JEagZ+WehjG8em0ID2LnrCeeWDYhcEE1Dfv2yhHk
	goyvoV1O2+P5BzPVJEReZID4ocgfC1BlrWyoybZAip2xigPfkLwy/sRIutUMvRw=
X-Gm-Gg: ASbGncsvNR9vq1wlFyo/wzoS0yHG+IVAzTmg1/+eUX7TYbLA4U77m1icmg5ei9nHxy9
	YIdpg4+PmGyWYFLHM02OK75QuLWYG44UQflWcqvP7WaOf6fTmRzRh3CP3yojA+qEVrP/p4/aRLP
	BuTOQhk3hfYKGAEczx2ikc6Qye95YjrPwZqAu+LAmwIwcGnfX+xGZTE5p4Z9uidi2jR/+6eDxtc
	fdHMHr1M+cbfkxUrtywCmGkc6H6FDnu2b1v3RkB0RBSi0Yqhb/fYaGMUX9d9bBykRKsRTB/JGAT
	XCoBLRaqoDR+c9yBmZEUo5pSNYTQA+SRKtr7IIh9
X-Google-Smtp-Source: AGHT+IHd/AYNlC9/+eGUzUQbXsHjdxY4eWx9rL/q1NHWCF/Mmj/1cPsEHPNZmlSNg6CCopLTE0vdnQ==
X-Received: by 2002:a17:90b:5830:b0:2f9:bcd8:da33 with SMTP id 98e67ed59e1d1-30a5ae599fcmr10633990a91.21.1746410187712;
        Sun, 04 May 2025 18:56:27 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:27 -0700 (PDT)
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
Subject: [PATCH v5 44/48] target/arm/tcg/neon_helper: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:19 -0700
Message-ID: <20250505015223.3895275-45-pierrick.bouvier@linaro.org>
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
index 3482921ccf0..ec087076b8c 100644
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
@@ -65,9 +64,11 @@ arm_common_system_ss.add(files(
   'crypto_helper.c',
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
 arm_user_ss.add(files(
   'crypto_helper.c',
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
-- 
2.47.2


