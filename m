Return-Path: <kvm+bounces-54421-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0295B212D1
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 19:07:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDF9F3E1AEA
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 17:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B647D2D47F7;
	Mon, 11 Aug 2025 17:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KaDaSBXT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7AD2C21D0
	for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754931993; cv=none; b=pOmnSwX3d8L9rZ2MRs/aCipilZQiEWQ4IUWlxspxc3zF/1eivBW4pgO2uXhCjN5dguic8kxojJ4BOzHmtuVulB+RHDda5z8EuQfcySqQlL1bwWSieIsNe7Qeq7JJcPwBEpNfTg95j+4FK8NdYwBMpLe+MyeI9kTdGwPoS69u24k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754931993; c=relaxed/simple;
	bh=v7FYO250aviFShiRoyTRQ3khbsLeGYsapHGC6NIqlMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i8/YA8ZCgq76H9MjCR8X4pihTwnynVm4/GUvNxC8SH6Wr7DlZZ0aZxMRKPFXGsAbCbLhhrUayUTA2NMLQfelq+ZHIzohKZF+WcY57z9FUq6T1vlvusjpVAaQVuApZI1XZCMkzaEjqdDQljgXiXdwauv/ErU8BPAsR3t6z9CPnds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KaDaSBXT; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-3b782cca9a0so3059647f8f.1
        for <kvm@vger.kernel.org>; Mon, 11 Aug 2025 10:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754931990; x=1755536790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EBVvp2mm8aGqZTUxsuL2RXTGufy667cu7GsFN8qW288=;
        b=KaDaSBXTi8AKwxBUu2SptDgW7rXr6aeT3Zv6wqf1+0QNlSlXrRdCuPnieOqfHWh3RG
         Nrkx0Rl4pH7aIlIWtWo4r8+gmDMnr31T0IMIUgQVlGXVWqTA05Gk2Hyf8X/IUgNcuY76
         gYcXyPSXC0K99VA1BzvyxAQ77rmlg1MiV7V2Gr6Wry6qaz2HHrIx8vwpx9pGanJ+ThI8
         JGeqcAZFwc8eJbqiHIKehJsxoBBYV5wGfuyDjo2vVRsmHJ8iLFYdMLrnefWvs/DlkIH0
         O0frx8YJ58+Z9l1mH7etafOFbfIOn0V080i/bQy36C1SuHO8DBkKOZZBebdmujrbGLIj
         19tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754931990; x=1755536790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EBVvp2mm8aGqZTUxsuL2RXTGufy667cu7GsFN8qW288=;
        b=CqzzAQgh1YRhF+KA28tgC7FMSfnZsI2vja6h0yyyW0XDfyE8B8lUANd36Ld5gVHG9/
         zSau4eOO4RLSG8njNDlJxaifhniscnfCjUfKt5nbePDnKr8ms2bXbLXYydaVTu97D8xE
         anUMvKLmgVBDTfTZsoMoSKwCj8MkuhLgMLq7589afP3fjy7Qol74ddD4ahro3cD8Z3zn
         JR5X4r6yU7REN1QAgOWpK+I6zgI9AuxDxmp58xe4vmWPHkLCuQo5UvML4qGHUK8/g6bv
         CdHGs0t/rVA0zY+bXXV++jor88XbYJECZnDzBS62GN1jnPTBBuX38vTAOpfeRBJXRpzo
         j9gA==
X-Forwarded-Encrypted: i=1; AJvYcCVIMUyE/4QX3ulh8sX7vp22BuPFxskCif/oEH4p7l9153ssagBdFkROTEguonbjXTdGui0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeV/2uXcdjMAwvOGpu9KOatjkPf96qrYISmBl3Ki3zahI2q36W
	H+8ONRDlZo30QO0qGORPJ/HPWlRtX6Wuc/vc27f3pqgTwAKOGm+6PgNv/uDlvhE5v4A=
X-Gm-Gg: ASbGnctvwBFKs3I0g+WFoqhrNN8YD3DsAJDOvsdN091XgPWXM5/biRwcHqs577eAriY
	LXEasbMeDSWpKcgB0oD2fR3hveRZG80aGsEAJlaFcNMm5aC6W0AS9LtyAJZHozeZg1h34aoDBmb
	K5VlszP4Wr43CsR/BbQGKyT55sLHFpLVBTy6b5yNFvSPCl5B8aDDTciWVsoaoV0R33x/o+jecT3
	wLWNbagD1ei8KxXpbPWs1m/goWbrNvOdgAyXI4lP3Fgsh4h20FhEa/OWT0QOlgCwjBX14frCUqL
	lxxy2qu7FiLnLSbU6rPq8dJQvXAokY1tLvHN3iKvW+yHVNLSr+skTaeYv/Nixt1pospxXi5ekik
	tvKzm+O8Dkjh6D+03cOkBI/odu4gSxNuXcCM4SwPifAtPcN22NVg1T+gHTij/4uZjYpcuLaT5
X-Google-Smtp-Source: AGHT+IGYtGd8rolKCFqRynOmaKKG7z81rdsXHVV5N9o+CH0wBtLo6sJkFR2p9cNAlJ+BSookmaVkUg==
X-Received: by 2002:a05:6000:1ac6:b0:3b7:7749:aa92 with SMTP id ffacd0b85a97d-3b900b6ab1emr10379986f8f.58.1754931990393;
        Mon, 11 Aug 2025 10:06:30 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8e04c7407sm31841796f8f.13.2025.08.11.10.06.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Aug 2025 10:06:29 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Miguel Luis <miguel.luis@oracle.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Haibo Xu <haibo.xu@linaro.org>,
	Mohamed Mediouni <mohamed@unpredictable.fr>,
	Mark Burton <mburton@qti.qualcomm.com>,
	Alexander Graf <agraf@csgraf.de>,
	Claudio Fontana <cfontana@suse.de>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Mads Ynddal <mads@ynddal.dk>,
	Eric Auger <eric.auger@redhat.com>,
	qemu-arm@nongnu.org,
	Cameron Esfahani <dirty@apple.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 03/11] target/arm: Restrict PMU to system mode
Date: Mon, 11 Aug 2025 19:06:03 +0200
Message-ID: <20250811170611.37482-4-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250811170611.37482-1-philmd@linaro.org>
References: <20250811170611.37482-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/arm/cpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index d9a8f62934d..1dc2a8330d8 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1551,7 +1551,6 @@ static const Property arm_cpu_pmsav7_dregion_property =
             DEFINE_PROP_UNSIGNED_NODEFAULT("pmsav7-dregion", ARMCPU,
                                            pmsav7_dregion,
                                            qdev_prop_uint32, uint32_t);
-#endif
 
 static bool arm_get_pmu(Object *obj, Error **errp)
 {
@@ -1576,6 +1575,8 @@ static void arm_set_pmu(Object *obj, bool value, Error **errp)
     cpu->has_pmu = value;
 }
 
+#endif
+
 static bool aarch64_cpu_get_aarch64(Object *obj, Error **errp)
 {
     ARMCPU *cpu = ARM_CPU(obj);
@@ -1771,12 +1772,12 @@ static void arm_cpu_post_init(Object *obj)
     if (arm_feature(&cpu->env, ARM_FEATURE_EL2)) {
         qdev_property_add_static(DEVICE(obj), &arm_cpu_has_el2_property);
     }
-#endif
 
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
         object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
     }
+#endif
 
     /*
      * Allow user to turn off VFP and Neon support, but only for TCG --
-- 
2.49.0


