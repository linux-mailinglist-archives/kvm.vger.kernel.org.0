Return-Path: <kvm+bounces-45882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 277C4AAFBD5
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:44:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 751EFB246AD
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E156022D9EE;
	Thu,  8 May 2025 13:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H6J9ptEO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9121622D4E7
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711857; cv=none; b=NdLMiBCb+vE2+My009exMfMQUSDTjoeR8jaF52e3lL4HFTvQvB2RQVMbIWKu/0B7HnJ6/v8q0W8s3KGXbBI0wPOme2y4QAl474pzbD2cXMzntmfWJn00d0vNcFl6CQcJsT8384hylCW3DwvtsxQPFW3JNhCi0/D7mNTxsBHTf4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711857; c=relaxed/simple;
	bh=jHhtZ8q29r+FEC+BvKfiNaHBaBNxDYAwNve10Mex5UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MlpAO2QDMUD88yEzq1crIxd2wAdxg5P9ycp6y5B7l3ofLKdWqMkyAfMLsrhFw7cF/Upo7WGt38HxjqO7sEhzVuNlztbX4KDWrAJ4WF90AIKaSTquZ7lVEj9OFdH5hk8qdjKm3StVyStyRnsGOAd7AVjjYiwqd4McE4cDtKhtecs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H6J9ptEO; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-af50f56b862so603458a12.1
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711855; x=1747316655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMLC32cD5rQa4ngqh9n69biVbtvyYihadQEH/qk7LQg=;
        b=H6J9ptEOvHltLJDYEcO7d4mnAG71AF7QUANIFL1U/w9Fo83Y21XKTLfGvOuiZ627eA
         ViSySK8Fe+xklST4Y1y1VqJQEMufMnG4UnHIjoM4cmJJA9i/hGvlz/dX9bIKft9EXVFf
         LHQUvfVPRguEw7rCOk9tWK6/zBinUbFBowQnyLPwPl4q46d3hw1mmbyc6iJTMkdGAjW0
         /Xn5sAArDrK0CCSOeV/NqZBrDmJvu7U/R6EsJoiOs6jhvRgisBRebL7y2lyOpTrIRIWH
         nndTqdc8kuNzoaq/4zM7DIa1AHTT857LOfsUEV+MLx+HkYWvG+oL9bTf3LFlNs88mVAF
         4MVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711855; x=1747316655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gMLC32cD5rQa4ngqh9n69biVbtvyYihadQEH/qk7LQg=;
        b=M7q+QmXO0t/vUs//uR7pXjirII4POryytpZpRv+pbmBY+pgPuHNwa93CmM2XqZH2nz
         ngfGASLiWqz2D7eDGphfNkdy/C3wKFLcqD1kysg7wVNEO+r7pCCzkgSLEwMLU7RDAav5
         57Zns0N4IDkxewq3+fKuG04MXhS3OcIC1wi0LY4w5hY9gQZbWhXzJUoOTovzK7RBLuOp
         vwk8eLrRn8/g3m0MFLpJ+uznyEQxKTFY5IyghhOoyyvfE7QbdA++JD/6l19lYUJQvBcU
         onJzevCNL4omR0fbi3aaFygcedLOSnn7vgG1Wxi+KEVcx/dZop7CUNpB0XIYjDmj+dev
         vUdA==
X-Forwarded-Encrypted: i=1; AJvYcCVjmlVCG6AAa5eo/oaeIjgSknZva31X7CROvBgM6UXwcGyLt0N3xdGt+beszWexdFyFYRU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrSFgQztzjRQXTVTdS/DDtgGKxIciP+EMEVAVIE2bH8xqhkkEP
	sYIv+Zp7bRDbnIGdyYOX8izv6HKneKt84itVebohkMwt6di591zEvbU1Vyu2Xpk=
X-Gm-Gg: ASbGnctw3iAOeZ3zFLmpYIdGtcEzBsoGMay9JYRYYbLbAKUDD4rIHLiRVTwlub0TIqa
	9kVf6z700mbIF3wzEtxhaclxw3qY4rjtwF2Q4QXc9uq1vpyArhv5iC4GfC2OFvFQH7Tpxz+5fSO
	q5YwsCZrjxegOGu3feSyF960TzpfFR689lXu7Kh29EH+FlOtOw91z/EyOFjvVptk89sN2bh+ovd
	KUBeVE6sQ7jN0XcZD97+DMwngu94AVvGyWX7ocG0I7yteL7fQjxUhNlmu0jXOwu+lJfyMxQP09C
	nBO+9k3o3MwO+2Q4C5WFnD9+E4HZSWcqX5/AMGKxgi5zd6M9hAQbTaGhvRJSexB1WGx6//KHjza
	J9KBcEaYmKYww+xQ=
X-Google-Smtp-Source: AGHT+IHMW98LKLrBk/HrYfcCCVQ80r3nhlUHxeo5FoUvbXLo766SGUMibKHsMA0gfPKgCoMTxObdMg==
X-Received: by 2002:a05:6a21:6e41:b0:1f5:852a:dd81 with SMTP id adf61e73a8af0-2148d52bbe3mr13246245637.34.1746711854843;
        Thu, 08 May 2025 06:44:14 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74058df2a6csm13272789b3a.81.2025.05.08.06.44.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:44:14 -0700 (PDT)
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
	Mark Cave-Ayland <mark.caveayland@nutanix.com>
Subject: [PATCH v4 22/27] hw/core/machine: Remove hw_compat_2_7[] array
Date: Thu,  8 May 2025 15:35:45 +0200
Message-ID: <20250508133550.81391-23-philmd@linaro.org>
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

The hw_compat_2_7[] array was only used by the pc-q35-2.7 and
pc-i440fx-2.7 machines, which got removed. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
---
 include/hw/boards.h | 3 ---
 hw/core/machine.c   | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index a881db8e7d6..77707c4376a 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -838,7 +838,4 @@ extern const size_t hw_compat_2_9_len;
 extern GlobalProperty hw_compat_2_8[];
 extern const size_t hw_compat_2_8_len;
 
-extern GlobalProperty hw_compat_2_7[];
-extern const size_t hw_compat_2_7_len;
-
 #endif
diff --git a/hw/core/machine.c b/hw/core/machine.c
index ce98820f277..bde19a2ff67 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -266,15 +266,6 @@ GlobalProperty hw_compat_2_8[] = {
 };
 const size_t hw_compat_2_8_len = G_N_ELEMENTS(hw_compat_2_8);
 
-GlobalProperty hw_compat_2_7[] = {
-    { "virtio-pci", "page-per-vq", "on" },
-    { "virtio-serial-device", "emergency-write", "off" },
-    { "ioapic", "version", "0x11" },
-    { "intel-iommu", "x-buggy-eim", "true" },
-    { "virtio-pci", "x-ignore-backend-features", "on" },
-};
-const size_t hw_compat_2_7_len = G_N_ELEMENTS(hw_compat_2_7);
-
 MachineState *current_machine;
 
 static char *machine_get_kernel(Object *obj, Error **errp)
-- 
2.47.1


