Return-Path: <kvm+bounces-50089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDEDAE1BAA
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:12:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3581016ABEE
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B0528EC15;
	Fri, 20 Jun 2025 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Uz1pAEBM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417AA28C2CA
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424960; cv=none; b=amyBUYtkmKvlo27+GhpvfC3Emo/0IdR5hqvxkOAZLLHyt4DZNDr5nXWVgUbBzmCNjW4gjcGpEVVDlH08lkXvk3gZI4iPi3mbXE3xUuFLS2pOMY2BwvPAM/SH/WDiUJx4jpWod50CSBL/sajNsnZb01u62Zos9HYvQom5b7PdvaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424960; c=relaxed/simple;
	bh=9qzxSOHpjm7q+4D2X/5tHgTkaugrva9sNyIgu2Ad5sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QWkUIGddCHsjcf3CPf/cjrvpy06aJtCVuuoO38fDBBKhg47aPsHNVCPb5EH1VCwa4LGErCJdKwwtXSGILLuoUwT+a2P8vqc0h9f1EiZwkl3kx/Mcyg+YZLP69Ojys9uZiJEGt/vmd/ejoaLTXBdv+EpnYFf6Bffp5tJf1beRbyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Uz1pAEBM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3a6cd1a6fecso1476864f8f.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424956; x=1751029756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tlzGRKm85UWY2+8yyhfs+sQBrY+hIXBP3ETvuuIJ2dg=;
        b=Uz1pAEBMb+b0rNCLIKvONfcES9zIX1KN5LgzioQ5eUbT4RtyOj+Fu5rdCoxNiFL9CY
         ONO6f5PlPHmmCoqY1aOrWxDu5mY2pKZmsps6akM0UVJQvj+a1IhtNyWqgfHdjByDxehA
         2RQHQclsO2Rjmc+Sn5QXwAjhZhcSz5mZyfY4zPn/RueErNFc206JCMQnlRjFT77toYzO
         KjUKqDisYR668uOvRaAwdxGAGtaoh8kEe//dibD7EeI6s6lq59kAQIbW7I3oZUGaZ7Jf
         famyiVSjUvuo16iJitl5NFQuWSBlK80f9v8XXZuArKFruH3ePZegcpiYe9uBrEtFr4Zb
         Q+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424956; x=1751029756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlzGRKm85UWY2+8yyhfs+sQBrY+hIXBP3ETvuuIJ2dg=;
        b=lb6lW5zxBesAInmylEn9yjpkJn1Ue2KxjHFEAU1V59f9jMBptmCJrkyWGXvot4irCy
         g5Zuv+oOKYqh4gn7p2maAQXDHKCMI/DoNoe+jO9tIniVLJBeRcus9K9t89n/RbvRnngJ
         lNzTxpeM5RIXJURB8PUrFJIgiWdSFyWCpNILdwoP4eiAZCVIlydoRntYcTUjoL5adEA/
         uTZ2yk38BoKyEMEf1Qdr0OcWbabA3iCdw7sino//sRxeZ+g++mMplayAOS9Z7eXgZmT4
         0QkouGUCKnjLH/facTsyBIqDrIYEmaZzq4T3O/ixGqHM7tZcggQPGkOam5js4u+Ses6c
         +lRw==
X-Forwarded-Encrypted: i=1; AJvYcCVBzfvNdPD4bBekYy34PO15CGk0vhMVPqsvzf9LCKyMp6q5Eo6k+dfQNp1AhfkSyTJP8aI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYYmu+5KFe8AZlE7TWtxoQoDfAQ52L3/6QmnyI0Mmux+tfCV2H
	MpeCjcH/CT8i4RnRiEF2046aeTyUf9fb04yuVeo86GKrr37SQlzglKPKdoVRGQ/ose8=
X-Gm-Gg: ASbGncsOip77XsRo8gBIo082eLDMM+JsxxUBdrB87K3LDXuAUAsXfR8MyBPAHuwSVXK
	I8BMTj9FE17L13yu5ize/UJL/UL/wTghJTTduVYvGgGaCoCv/E6lMFwulHSJ2m91Ue42lWGPXJ5
	pDoHcLLDGBHD8zRvhEkSPDLRpNJEyQaNzoIZnpoFm/jWy3suAtVBMoTtetmtu3emdsYWbLzlHa1
	uF0EoKJmqFPlt3HQh2waMPED27BJxVzIzwKW2xnZ+hFble7tbDgKdPKmwkgG1cB8dMnroz4qMN9
	/BRqsNZ8X5iTZpaUxfaX2l6svVfUCl0flgEgMxHir/p0ZKAHnXbfMO/ow0XD+zLBbO+nI40bNSK
	hOa5CgRJ0myH078pbRDbkbapygQjEmceMXmwR
X-Google-Smtp-Source: AGHT+IF5uD/3snOQ4X+aLRPk1Xt/Xd4ZmVTTd6N1+20oIyEGbROy1hmGwi9rA/PwtOTLyfKem3s2JA==
X-Received: by 2002:a05:6000:248a:b0:3a5:2fae:1348 with SMTP id ffacd0b85a97d-3a6d13129c6mr2233188f8f.51.1750424956479;
        Fri, 20 Jun 2025 06:09:16 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d2236452sm1791926f8f.59.2025.06.20.06.09.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:09:15 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 22/26] hw/arm/sbsa-ref: Tidy up use of RAMLIMIT_GB definition
Date: Fri, 20 Jun 2025 15:07:05 +0200
Message-ID: <20250620130709.31073-23-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Define RAMLIMIT_BYTES using the TiB definition and display
the error parsed with size_to_str():

  $ qemu-system-aarch64-unsigned -M sbsa-ref -m 9T
  qemu-system-aarch64-unsigned: sbsa-ref: cannot model more than 8 TiB of RAM

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/arm/sbsa-ref.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/hw/arm/sbsa-ref.c b/hw/arm/sbsa-ref.c
index deae5cf9861..15c1ff4b140 100644
--- a/hw/arm/sbsa-ref.c
+++ b/hw/arm/sbsa-ref.c
@@ -19,6 +19,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/cutils.h"
 #include "qemu/datadir.h"
 #include "qapi/error.h"
 #include "qemu/error-report.h"
@@ -53,8 +54,7 @@
 #include "target/arm/cpu-qom.h"
 #include "target/arm/gtimer.h"
 
-#define RAMLIMIT_GB 8192
-#define RAMLIMIT_BYTES (RAMLIMIT_GB * GiB)
+#define RAMLIMIT_BYTES (8 * TiB)
 
 #define NUM_IRQS        256
 #define NUM_SMMU_IRQS   4
@@ -756,7 +756,9 @@ static void sbsa_ref_init(MachineState *machine)
     sms->smp_cpus = smp_cpus;
 
     if (machine->ram_size > sbsa_ref_memmap[SBSA_MEM].size) {
-        error_report("sbsa-ref: cannot model more than %dGB RAM", RAMLIMIT_GB);
+        char *size_str = size_to_str(RAMLIMIT_BYTES);
+
+        error_report("sbsa-ref: cannot model more than %s of RAM", size_str);
         exit(1);
     }
 
-- 
2.49.0


