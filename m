Return-Path: <kvm+bounces-36447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 06892A1AD6E
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 00:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0320188F381
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 23:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88881D63E7;
	Thu, 23 Jan 2025 23:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QpAa3vde"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097C1D47CB
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 23:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737675911; cv=none; b=iwb0dvvPkvBKmFATYpShmKgzkl2atu07RFPH1cqlS0bwglkc7olEU1FYYOzS6B+sr9A48GofUZKRt/JlYfCD727+BO+0leEN7FZ8IX92ojP99oGSabrho8FeJgXmlv7tDWpMkEvfmjfTYuHVKQvAeI4ZnXwGxRMvOH9DBzTE83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737675911; c=relaxed/simple;
	bh=PnRmCasp/kx/ikQRLih9mkoTj+hCY8Tgy0oIA1UoDng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HEId25MsBwZ1UsKvu7Dj2uIS75wouOl+RN3M/Jcqnu3jFPlTO2BrAuYv9fjGEaIHEgByLo14tloLM1lDPfqweSzlAQVTqoFzM1NZ8DS6GIbpIeDjB8vtyBwVk8tj6u+W/LPLiqGZbvl9nfQGis/QVVXGiqZJflQbEtnQD3IUPUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QpAa3vde; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-385df53e559so1134052f8f.3
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737675908; x=1738280708; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yDFP15LbfYjBwdgoNtB1SUTPS+QYiGObjjbLDQKpiPc=;
        b=QpAa3vdeGmquHXJx6lNb9PY6nba9LJ7EX9XeSr8aEuW5IqpSfyVN3FGfmM3LrP1IbP
         gJE0VMt5TtfvC8Dsv0dVECnGV9fXxayfiMQJsdt1Rc1kem8Hb19It2XcWA3uG2YmwMKO
         iQFJRw0hfkryd98JDpg5IPXs/P1roo4g69vdRXldDPV07TlfHFkbg+xnzvHolHWkPPMS
         khXDAIx0rM4UgMGV0N4j555hq3Ge0CacsZxBUkhcH8V3jmQEOe9tPhubqx4yF7g1DHN4
         gO7V6kUqfmuWd1A2RfiGR+9r1Wzc678rup5jTrs4dO0IiL6D6IWTgL0AQfoYLAaDf9ac
         mowQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737675908; x=1738280708;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yDFP15LbfYjBwdgoNtB1SUTPS+QYiGObjjbLDQKpiPc=;
        b=h5O1qZtgB+fzfsxsfp3Dyz1j8HdKUdTToxZzC5DRcl0vhABESNeT/elLhoNuZZPc/e
         PYluzdojcLQsd7r+EerK+3RpwIQ/ImxpOaj7qEPDkVPHCVZvUNt+NFnhUQJuKL2PxGTF
         KXLXxJC2NLbKkJkC82iiukZcJKvgvrM5cYDwqHvd1lu+GxYO+b3iqVrTLLWWECBr0dz+
         dtU3OS9BjsZYr81tAWFbc7TMLZLzvoeqowHhR8jfK2BlICMSe7agDTUHFGh9HqWvXena
         iygWXYIil92KzXc549TMM0lIOge8zj9KreCBOONhdap7Go+VCdhHRNq6lIxBmEJOsBfT
         J6sw==
X-Forwarded-Encrypted: i=1; AJvYcCV36MsjX/Xk9MKQWc+KLdJFUxQF+nmkgwwecOfmfqBoPf8WsZ6Gw3clPdwxjanOdzPjHDU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9HdUx20X5D08lbQ4cXuaPnJwtlN4qOtwZWdukMh9e586sfDSW
	U1Mo1Of9yEmGGsiYibE6LnoA34C+Ix7v0zovtikVXxhvjopwwW2nTniI/ycDozA=
X-Gm-Gg: ASbGncvDkw78SHom46FaL9litTDcooBvgyY9gNfPuxzllOgwb14LEBnpue8oS3i75R+
	a1FKbLm5hizklO9sILuPCO1cY9EU8pvOtmb72znQBIAYq7efPBJUkfs1WkG2umDWAH9QLSD8j3D
	tQBCEqDEk/yhDxYNOnE+CElwok7lhZWx9CQIP0G6V3VHxnCnEWT0/gJfdBWCmt0rRr79/mfvV0K
	gEw0dN1aSQiajcqSpff4fq571YTYEAiNOFMLDBWf4/qKG6B/BGXO1T+JG2wj1C1VVxK67EIjcY9
	sspxU18eoP3ZPjFszjl4SItIVyMv8UH3Ys3+RcqQQV0dOHMxavZT9vo=
X-Google-Smtp-Source: AGHT+IF/y2rn8++eRXtfGXVV9eCNnufdJ4OAKshcVAU/XMr+be4nBaPjnThGR5Wf47h3eLbBgCoQsA==
X-Received: by 2002:a05:6000:401f:b0:38c:2677:9bee with SMTP id ffacd0b85a97d-38c26779db8mr3711264f8f.15.1737675907708;
        Thu, 23 Jan 2025 15:45:07 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a17630asm997952f8f.6.2025.01.23.15.45.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 23 Jan 2025 15:45:06 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	qemu-riscv@nongnu.org,
	David Hildenbrand <david@redhat.com>,
	qemu-s390x@nongnu.org,
	xen-devel@lists.xenproject.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 09/20] accel/tcg: Restrict 'icount_align_option' global to TCG
Date: Fri, 24 Jan 2025 00:44:03 +0100
Message-ID: <20250123234415.59850-10-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250123234415.59850-1-philmd@linaro.org>
References: <20250123234415.59850-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Since commit 740b1759734 ("cpu-timers, icount: new modules")
we don't need to expose icount_align_option to all the
system code, we can restrict it to TCG. Since it is used as
a boolean, declare it as 'bool' type.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/internal-common.h | 2 ++
 include/system/cpus.h       | 2 --
 accel/tcg/icount-common.c   | 2 ++
 system/globals.c            | 1 -
 4 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/accel/tcg/internal-common.h b/accel/tcg/internal-common.h
index d3186721839..7ef620d9631 100644
--- a/accel/tcg/internal-common.h
+++ b/accel/tcg/internal-common.h
@@ -17,6 +17,8 @@ extern int64_t max_advance;
 
 extern bool one_insn_per_tb;
 
+extern bool icount_align_option;
+
 /*
  * Return true if CS is not running in parallel with other cpus, either
  * because there are no other cpus or we are within an exclusive context.
diff --git a/include/system/cpus.h b/include/system/cpus.h
index 3d8fd368f32..1cffeaaf5c4 100644
--- a/include/system/cpus.h
+++ b/include/system/cpus.h
@@ -38,8 +38,6 @@ void resume_all_vcpus(void);
 void pause_all_vcpus(void);
 void cpu_stop_current(void);
 
-extern int icount_align_option;
-
 /* Unblock cpu */
 void qemu_cpu_kick_self(void);
 
diff --git a/accel/tcg/icount-common.c b/accel/tcg/icount-common.c
index b178dccec45..402d3e3f4e8 100644
--- a/accel/tcg/icount-common.c
+++ b/accel/tcg/icount-common.c
@@ -48,6 +48,8 @@ static bool icount_sleep = true;
 /* Arbitrarily pick 1MIPS as the minimum allowable speed.  */
 #define MAX_ICOUNT_SHIFT 10
 
+bool icount_align_option;
+
 /* Do not count executed instructions */
 ICountMode use_icount = ICOUNT_DISABLED;
 
diff --git a/system/globals.c b/system/globals.c
index 4867c93ca6b..b968e552452 100644
--- a/system/globals.c
+++ b/system/globals.c
@@ -48,7 +48,6 @@ unsigned int nb_prom_envs;
 const char *prom_envs[MAX_PROM_ENVS];
 uint8_t *boot_splash_filedata;
 int only_migratable; /* turn it off unless user states otherwise */
-int icount_align_option;
 
 /* The bytes in qemu_uuid are in the order specified by RFC4122, _not_ in the
  * little-endian "wire format" described in the SMBIOS 2.6 specification.
-- 
2.47.1


