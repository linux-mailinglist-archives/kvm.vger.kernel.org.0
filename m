Return-Path: <kvm+bounces-45877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E14D6AAFBC2
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:43:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 800DC1BC1113
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:43:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20A3A22D4FD;
	Thu,  8 May 2025 13:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zclXQkRR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B733522DA17
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711746; cv=none; b=MHTNii5/Q6g8UGwYcWXaNSyGvgAIe++HzkyYX51Wz9tVzIECgU7iRaZqtbO9S2ezsqI/4enLYxNFdrUwwsMF9NP3Y/PRcN73imJ4fvhBjFL4mXFrWDa5RyCbRGbmXfw+xZLazv10yiiGh2lC/hENaf4iuobNcqLVg0LW7SU65S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711746; c=relaxed/simple;
	bh=SuqhFKHEH8f9U6pwmYur//5KED7GhO6pLdMl+1E8EkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tORkdqauKVs9/8kYusOI3lvDQJYZLgX4U6vFKEVbssjjUyvcmRB2v2mzhdrBLRJF4ml1CYe6b3tQyz5aHGVstlf1PuHAdxAl4p1Hg5/FINjojvOmLDU3UuhANk3hC5n6U0Dd59yfe23DYrlLgp5ibLUt8MstZbIiNlBZ7iYblFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zclXQkRR; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-30820167b47so897059a91.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711744; x=1747316544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zEKZAR/VZgMFUr6PYFqtHtppbGxXvaRql4Q5kTcH03k=;
        b=zclXQkRRquhTbHSqDT1HGiZqyWfzPHwX1A/d3rSrmcWhw4bEwh1PjNctYGqnpsCHi0
         LzXVDfUkLKK8yhL15AjKkdKngJveuru9FVqa3eHZREB5KhLaVm1MOcqcSqlfkEjizFUm
         cic0p8JcXPQ8KuY4+JACMtCI67txfzOmr+2/7u1Z78BtPiSjLF/rWa/7r9Tf4l5Mi/Zh
         nZwyUZxuihrz/d6sD1pvSWMBsVrVjz7l0haDbi8YrY8Bt7uiXZUFxMOFpaGrM54xMio1
         08t072in/YcivfoKhqtwk34WnRpXUNOkpexnRvUVmp/866x3lEeqd0sVrsJSgOt3G4uQ
         aHcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711744; x=1747316544;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zEKZAR/VZgMFUr6PYFqtHtppbGxXvaRql4Q5kTcH03k=;
        b=aHUhTeTiOthh46xaESOBnuplC3kFEHRSuD+FMt7+nuIIXIX6AOHEfyAgD/A8rbCTXT
         uDs6t4igckjO4uSBhKn/1+sCfxOSD3Q7StWiBn1I51P9yUGyQ6nnSn82guIkbywjotRd
         iB2SDyT6zc3Fc/8j5l2Xl4xLT4dWLDfAmfBr1QDw+FUPYu4P23PQ35ghD02EDZdyLzKy
         xofXK4976OcMqmvMeCDWWC7A4NN7ME+Vq8FokdeKNAhlHRyYtbFniEarm18SqrR7ss6G
         a4CIVMC7ndxq6uDJccZDNAQ4vu+Uv2k5R4fBxeeTLg9Xrs56FqKrbqf9bU15djS0NDEp
         CcpQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1yq9JbNZUt7JejKerydRv5UKaKkntDSnz4uDjKU/b8dCD13sXmM7XIhMa+1lrbMKZfF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC4BGZ7lLNjMFKLnYws5J9P8x7djEjox8iwCIoFlV2uhOj3Xa7
	leKauo1KboVXmM8Z994e/YBFr390HqbXGY8pRu7XqfhRnDPoadADAFJEaBtmqCs=
X-Gm-Gg: ASbGncvss+773eKGH5KGIC324PIQCRsjZ3x+UpCs5I3awdUpcwBbCcs95rLmDZkzI7S
	vTswr3pT6rYkNZf1iJ2mQXHQ0TwzMmjT4pErO+waVVMfDeFLIZCXRXQFeJpoy7lpRQD67fU8/IV
	ToYTmYIhXj9CXm9FoSJaThe79rXKGDdEBQ0mYbgAEjCQaWKuIcYrUN8OWIxr/bkqt7CYMpFA642
	Crv8D+X+AGn+5lDT3eW29/7y3Z/8FKitG2yisV6E6j1NhQwMVavyIRrkAj7AED5p6WP59PsN8U9
	fz8niD3Us/DVIgRJrFZyp4+rJel4H0QD1kuclI0me/yPmZ5Xykjsm+FWQ03pV7axm7pB7HaTK9b
	s5HIz4pE7bw6i4jU=
X-Google-Smtp-Source: AGHT+IH1WVEL7CuYnhcuoeZe0dF5ZImTjMBcZgMJJlYHkrELO77MU8NVhB0RggY4VqZxOdLZ04ngFQ==
X-Received: by 2002:a17:90b:3b91:b0:2ee:8cbb:de28 with SMTP id 98e67ed59e1d1-30adbf18acamr5563077a91.8.1746711743871;
        Thu, 08 May 2025 06:42:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d2f15dsm2382033a91.18.2025.05.08.06.42.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:42:23 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v4 17/27] hw/i386/pc: Remove deprecated pc-q35-2.7 and pc-i440fx-2.7 machines
Date: Thu,  8 May 2025 15:35:40 +0200
Message-ID: <20250508133550.81391-18-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

These machines has been supported for a period of more than 6 years.
According to our versioned machine support policy (see commit
ce80c4fa6ff "docs: document special exception for machine type
deprecation & removal") they can now be removed.  Remove the qtest
in test-x86-cpuid-compat.c file.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 hw/i386/pc_piix.c                   |  9 ---------
 hw/i386/pc_q35.c                    | 10 ----------
 tests/qtest/test-x86-cpuid-compat.c | 11 -----------
 3 files changed, 30 deletions(-)

diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 98a118fd4a0..98bd8d0e67b 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -755,15 +755,6 @@ static void pc_i440fx_machine_2_8_options(MachineClass *m)
 
 DEFINE_I440FX_MACHINE(2, 8);
 
-static void pc_i440fx_machine_2_7_options(MachineClass *m)
-{
-    pc_i440fx_machine_2_8_options(m);
-    compat_props_add(m->compat_props, hw_compat_2_7, hw_compat_2_7_len);
-    compat_props_add(m->compat_props, pc_compat_2_7, pc_compat_2_7_len);
-}
-
-DEFINE_I440FX_MACHINE(2, 7);
-
 #ifdef CONFIG_ISAPC
 static void isapc_machine_options(MachineClass *m)
 {
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index b7ffb5f1216..a1f46cd8f03 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -648,13 +648,3 @@ static void pc_q35_machine_2_8_options(MachineClass *m)
 }
 
 DEFINE_Q35_MACHINE(2, 8);
-
-static void pc_q35_machine_2_7_options(MachineClass *m)
-{
-    pc_q35_machine_2_8_options(m);
-    m->max_cpus = 255;
-    compat_props_add(m->compat_props, hw_compat_2_7, hw_compat_2_7_len);
-    compat_props_add(m->compat_props, pc_compat_2_7, pc_compat_2_7_len);
-}
-
-DEFINE_Q35_MACHINE(2, 7);
diff --git a/tests/qtest/test-x86-cpuid-compat.c b/tests/qtest/test-x86-cpuid-compat.c
index 456e2af6657..5e0547e81b7 100644
--- a/tests/qtest/test-x86-cpuid-compat.c
+++ b/tests/qtest/test-x86-cpuid-compat.c
@@ -345,17 +345,6 @@ int main(int argc, char **argv)
 
     /* Check compatibility of old machine-types that didn't
      * auto-increase level/xlevel/xlevel2: */
-    if (qtest_has_machine("pc-i440fx-2.7")) {
-        add_cpuid_test("x86/cpuid/auto-level/pc-2.7",
-                       "486", "arat=on,avx512vbmi=on,xsaveopt=on",
-                       "pc-i440fx-2.7", "level", 1);
-        add_cpuid_test("x86/cpuid/auto-xlevel/pc-2.7",
-                       "486", "3dnow=on,sse4a=on,invtsc=on,npt=on,svm=on",
-                       "pc-i440fx-2.7", "xlevel", 0);
-        add_cpuid_test("x86/cpuid/auto-xlevel2/pc-2.7",
-                       "486", "xstore=on", "pc-i440fx-2.7",
-                       "xlevel2", 0);
-    }
     if (qtest_has_machine("pc-i440fx-2.9")) {
         add_cpuid_test("x86/cpuid/auto-level7/pc-i440fx-2.9/off",
                        "Conroe", NULL, "pc-i440fx-2.9",
-- 
2.47.1


