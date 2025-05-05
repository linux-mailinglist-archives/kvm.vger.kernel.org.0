Return-Path: <kvm+bounces-45500-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D9703AAAD50
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B82F916DCD6
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C20C3B17CA;
	Mon,  5 May 2025 23:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uwOU6ZOX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246DA27979F
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487242; cv=none; b=D23E7Tu262VNHhNQYcUy3foKfJfPKcKTmDQ6UNKOGH6/cFaH0i9y8dry2Nw8NkKGYZCrFLKicCl34HAgwPydRDEtO/kiR4QdWJqQowYGlFEtx5iodDL7UCbLximn5V8Xtm6ePN2VCj8FZKfIYKle6zUSo+ZWPGui6CascWM1nVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487242; c=relaxed/simple;
	bh=7eGRZI1+IPQW9UuFfFYtmdus7udvGQrwu8sGRQQhKG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFdbywbmEnIv/+j2v48Et9YynHFwWcsG8ivkTmj3Yqx8pwutZLlYG/4vpn5Ep5GlelbOumQQluTLiRob6U2RlNOMzXPt2xP0VJhJAwrxP/WzIHD4dopPSEoSr26ko9yKBPpkjINiBvcOQYU32IGU9BWetfQXsCPK4IeLqUrqTqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uwOU6ZOX; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-30820167b47so4721709a91.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487239; x=1747092039; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oU3hP1IM611C1WkYpOLE6kbCej9Cg8bXJlI25SZwxm4=;
        b=uwOU6ZOXDmB/cLyz2V+UdNrug/AlAk4DBn/pquJHfxdk+m/C96a/vkTSvEExd4DnI3
         I5Sph7Jfs6Zj8H8gLblkJNi65Ns6LkqaNsVeRm8/vq3Fn8tgVBFo8UfiDJP4/6P6D6MN
         aOf5R88ahylRGzsoySK28OdQ3uqmA64J84aVfCT/+7JgnD8I9nPELNnL8cMQEnBE7Nwr
         dNN8kXwDRyiANA5MJTaDTMmqA3TaRFpke81R5yKTg3c19ftAXI37Y1wICZZ7IXIuwCya
         yoogTVGW4VtFv0BV/RNXFVyvDo1uhkpZJgUYpSyKznJIeS/GfDBFPXC3pkND/dFDi53H
         30sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487239; x=1747092039;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oU3hP1IM611C1WkYpOLE6kbCej9Cg8bXJlI25SZwxm4=;
        b=f4hKQRk3A9D01MqbBV5l5tJ/u6WcJfDMXsKZYEM3/uYXq78mOQJqHycji69dTalRMW
         mt18uz9LKH0tlzDce8Za4KJDwDLIOeGCuFe2n/345C92G7qEWcy7HeMPzVHFVUjbEgii
         P+2uo1rE30s4gh/mbMsvaPaWKp/JfH2J434005Td6uGCPYOC/pKqYwEbCB5rjgiNfL3u
         t3WX30o18naDbgVpXDzs+PhG4hz2pBFBiSWHWy+ZvoSF5GQ02CZgGtIoka5b/gv63jOL
         jXO3NzdhVEzObrgjEhuM7H2m1Wc83WRMm7K3jPbcTVvFJPQDG6jTN9bNG5D59AHhTjI+
         4dZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXACJnr/OSkYbi5GrJtk08YRq4pGcrBdC9UToyRvaLAkrOGYBAS2xolTYKiX5efW+wQ/to=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqBcQWIg8G7PcC3KD8HWTrxK2SmZE8xuOoWjyNY06+ovhw8R4d
	e8G++cpFGenlJSby4bI46oVSiOCXVvNgDzrWV3ZyQ7/E0dNq4W2b0Ra051STX4A=
X-Gm-Gg: ASbGncva/+FwTKWGTjr95LQ1vqezKuVvl8FUy2gJ3VFAubIEUyW0OkCLL2EB05ek1Jw
	CVwxUv7kxNR50lwJShJ+iFqf6nZjBG+6mXZ1Cccyz4zcjz47rXcS/6o1bjejv9s/72m9n9KWJs6
	TYeX3J2mSvldlXc8SvY2pGRKRW9Qp7SBCltptblH7pvAt2ktaxUwx5RVOirLqkG+SCPcMAPk3VJ
	EjuZFnvNXRuaqKXudHshUYoXvXJsKwp5Bz9Lfwxcf4CUiEIKp3YUJvS+AjF6gwNezfjf8wAQL72
	HNyZHOvgcR2SEi0DLFLKMZlA9gnqf8pMCYvycI5b
X-Google-Smtp-Source: AGHT+IEeQn5CnaDJkgJrvd4w2rWjGIxMS+SZ2bixNnuJIzYcZR/FEvQuhLkOTW8Ra8Q6iuMjA6Xc0A==
X-Received: by 2002:a17:90b:268e:b0:2fa:17e4:b1cf with SMTP id 98e67ed59e1d1-30a7bad37a1mr1863711a91.2.1746487239310;
        Mon, 05 May 2025 16:20:39 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:38 -0700 (PDT)
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
Subject: [PATCH v6 21/50] target/arm/helper: restrict include to common helpers
Date: Mon,  5 May 2025 16:19:46 -0700
Message-ID: <20250505232015.130990-22-pierrick.bouvier@linaro.org>
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


