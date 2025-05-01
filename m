Return-Path: <kvm+bounces-45038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA56AA5ACE
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CED941BA7449
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C61B2698BC;
	Thu,  1 May 2025 06:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fylTBMPv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE29270ED1
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080641; cv=none; b=RtIHKJcTkyBQvAt7SQGuJ3YsOEHCkfVo9WfGyxr62MOR9dWJmaLy3XEYhv8DFdiy/MVrDqi2NYR6fYIJwu1xonMTWb3gYyIYBrtIu1tNI0bup4hCx7MYIPxwRyP+PPSxH+jpnjRAUAX5OpFVSX816XRXPEFTk1iaxt62S3IpR3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080641; c=relaxed/simple;
	bh=Q4qCkgpG1KLyQ9neixjUd/QLlR3Ezc/BgF6Hmmxptq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UAB5+fWbOW1epc1O1g2Xsh4ZgxXK8fePo1OpDUx2rU2Kv58ZhoJtgb2+YJI7e/SR3nt97T6uDPdFdeN0uPR8lQm/8KX9gvvyC3KwPGzIUIHBaBI3/VSPSzNUYd9v2Dr5r6H1iuZrXatVewjO6hpWdAbgBSEtuaHO8mqlvHiM9ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fylTBMPv; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso698341b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080639; x=1746685439; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v43acThFN05/FatusJlue/N5CkXsn1OHHnhEzQzn40s=;
        b=fylTBMPvdHUtuD+RUx7puF0cJmKp57XIiA3V7CqNVxpXgxBJnddRjz8Tbs6QlYuj/T
         kztT3NOE//S482nVHH7yTo5a0NdPLbiXWJs0SA91UO454+530L6o0nZndY6p3y21dyqD
         eo6BGdDj7xRGSeWyiZ0ieWujvSr6JV++P9Agptz5+mZmTeDfgUsmH3/272VCgM/c8ojr
         SvHMRPiC7M6cfc+7ncduVZOOyN03Ei1xcI15d9JQkhK1rTg8x3CfzEOUFQ6kobCj8YKj
         pgdjCdGXzbJ2sjCq03CcLqvkOwLIZ8EEME+mPWr5Rl2NZBqo4hgTlXhbEZKSchu+Xrma
         JdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080639; x=1746685439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v43acThFN05/FatusJlue/N5CkXsn1OHHnhEzQzn40s=;
        b=B73Bu9m7OyWH2nMQPYPbGgqVpa31lSIXW4uxWY88uza4LP2k8dJd3mLB8dskk50QyB
         TqzFgP5JQwOLt/Kcq/tso2pSiTCgIFIW0wzqJdUkJGwD8hWWiht+mUjmgJjdpzJGX9j0
         Ow4SDySmF/xt5iS8vnkHTjxHyqsASCNmgdwbc+feswSjHReu02QGMsA3KIK6CDyUDydQ
         9FK6xg8z19PVpHomM+CIyFvjMnhMRXdg8Zy4WCXEBFLMy7bbAXWhS1GJQgELhvDA+m6H
         Lf5cmGk/vDMd5JFBOPGk8uO+NuibHwa2YBXurumHeH9BHo7Oo8oDsv6HgTTeyayh+q7+
         c7/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6a/amfb9SsDKlLtxuzXQ5RTbPjXuObqfTYU81O2niSsCh9Qc0epV3zGZIukmULFmKb9s=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk0dRZUb6mj28OABuhQLNPykPkEywPP/tJW9Tz/Rx9ZFSyeN0k
	HRrukDg96pUf0a6jVtro3a+EplTEkN6OkmRaiYA3aDQsZhCFa0Bb407DZSlCPwg=
X-Gm-Gg: ASbGncvz1iqvgDMYOO2/HSYS5qMbBR/Wuda98TC2Td7h58Hh5tpv3+rlfDKmltzo+sI
	7TSUvEnnAmsnJo1gfoq1eYqtzZftCziGepiYMzBaFyxgu4DvtuDdtK85YQAeGu1R/olEkazk83y
	LUbdEDC+YTosXTZg/k4rZNoUlNrsaxAOYXOkK2S/RzVIMm38cym5KEmnayOhLNG0gXrSDnRKLzD
	HIequULZfLH1jGM7Ia2B3oIKwWIXywBnfRco07O45NyzgI9H4eAsCAZ5iDRKA0z76DvylYCuhas
	wHvjkKCcy0k0OjQBFI1cZSFo0mZuU1GSGmOewmW5
X-Google-Smtp-Source: AGHT+IGxPomAylWwLJi0L6OKGSROnLWYZiR31IMYciHNxQlk0i4DhhlCaz5LkQ50RwCVuokbYxi1xA==
X-Received: by 2002:a05:6a00:1411:b0:736:3c77:31fd with SMTP id d2e1a72fcca58-7404792b867mr2645976b3a.23.1746080639426;
        Wed, 30 Apr 2025 23:23:59 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:23:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 09/33] target/arm/cpu: remove TARGET_AARCH64 around aarch64_cpu_dump_state common
Date: Wed, 30 Apr 2025 23:23:20 -0700
Message-ID: <20250501062344.2526061-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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
 target/arm/cpu.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 37b11e8866f..00ae2778058 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1183,8 +1183,6 @@ static void arm_disas_set_info(CPUState *cpu, disassemble_info *info)
 #endif
 }
 
-#ifdef TARGET_AARCH64
-
 static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -1342,15 +1340,6 @@ static void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
-#else
-
-static inline void aarch64_cpu_dump_state(CPUState *cs, FILE *f, int flags)
-{
-    g_assert_not_reached();
-}
-
-#endif
-
 static void arm_cpu_dump_state(CPUState *cs, FILE *f, int flags)
 {
     ARMCPU *cpu = ARM_CPU(cs);
-- 
2.47.2


