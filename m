Return-Path: <kvm+bounces-45874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CE4AAFBBB
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:42:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 84D121BC1A65
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:42:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8DE22C339;
	Thu,  8 May 2025 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="O8kmYkJy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1921B6CE9
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711700; cv=none; b=GgZjIO+GBiFCOo1ZXMwq5Y/iP3CFDa5Aod33rid4vrjkIxMRVvNizEIBn46ILzuN0wEp6n1BFeaDnpg411JKsHe7mGUXxtdOvBL7zqF/+Bpcz4N/43enAnKdHcuFZhmxIV5ICZR6hCvI2B2ggWJby48agkacFwswDd+ejig5eI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711700; c=relaxed/simple;
	bh=QXpmaOozuPORD0wnEusaSOC48/QB081Nph94BBSokdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sfpTqETkXltnk7p54ecuj3putVb7zf21nBDK3SOmYOg7FpzJ8gudWo3OlhMK8iMjT7JztC/LJpfTJ2GbR6Q9t8HTdYjk9xGJ6tBUS1zh5L5j+XUcyKU0qw+M8+KXmfVPtzu4L/IMPJUdudbfRO8CRKbS9fDHNVyRKbZrv21wgBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=O8kmYkJy; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b200047a6a5so431310a12.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711698; x=1747316498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqRI2bUWFL/LTWDPgHwj3plQ/Zek5ug5WOQHcPBpHVI=;
        b=O8kmYkJyV6pE1OZaCt4DV22tHkOhWTYsYKi6K/CHlaJyHP8xzw6utmBzslDp1b6sPL
         d+THPaaJipE/28ox8YfMilwROifLwge263Ll00FnzAGjLdwp0hK07/BT7k4kGCKQ4Qwt
         hzEfsu5ISKFSMu/XXxVGEAOYRmqLZr47cJdu+UsfohT1hUj6FOdBKrHKyQrlbUq2PJwE
         PMG8DAlNOEGAyGmGgtzYylrE4B/ebcFJUrlrCrCNgeabD2nQRCJdncLgaL6PRCswA15D
         XYTpfUnYOAnY0nRDnhpc6vFUnMxyrHrssXrN8TfqBKL70FCcPZjqtyk0OBem4WrmmmkR
         0XAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711698; x=1747316498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sqRI2bUWFL/LTWDPgHwj3plQ/Zek5ug5WOQHcPBpHVI=;
        b=IHQ7nzs8jdG81ATyB2VEJYKD2wl6rODwUYxrFQbs+O1wlP5FRAqih5nHeB587IjTu/
         r02qlI11a9n7nVnv9LyCLsyqS7ezOOiAGIgJfz2NatVUpJKui9gRc9Org7Xet8zavjTp
         LQz7EQfyqrk984qE6OHf9J04KjaE46tc6Zxa9YFCKi19yibRTYkelMAl0Ru/+X0gyQZU
         H8B56UaHbX/ZX4wrJjJ1XYIAyrPmi1j77YUlge/+oLPWKXtZxZNQmFDPOtjzKQfC8TZ3
         w19m/rImhMibsRBKm8AQiJlD1H5gRieYKYeeQK+lwpPCnzjVdiDTyCLokMS8+wnbe+rZ
         C9Eg==
X-Forwarded-Encrypted: i=1; AJvYcCXuSqpZ/U3aE06tMEQpPIJrgMuUayIdLl9VGtC4K60Vlmkgvk7L33Lk+qMtNMUKs31P8Mk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLi+Hx+4QdaL8x+T4jjO5W2y+CCoZmx9nAhVBltX3YwZaEjXqZ
	Gi2drd70mZqw+0pUj0SmzZKlle8Q2BjjpBMpithyP/vA9pBQfsGu5sQ6G4qX9S4=
X-Gm-Gg: ASbGncsdLedls+ZyqbBBI76DWLqA/cMIThfHTlfhJnNTMAa00XgzGUzTmuqiQx3KoJY
	28lT4vno75b2jpva4kpQo6TGG3cjoQqVvGeoo1LFqk1Qt1lp2rsH+y+CH38rKDcuXy24WzCbRRZ
	j0REbKAhw/RDx/wb6v6PNvdO5vuMmFht4QoOlvqizkPmjQfszMRjEXoqpN3oR7wKp7W7iF17zab
	B9IWsn08/z6hCCJR74a1BmHeWG5NAFGrmXl3hV5VQR2rvRJnGF7M6eqPmzosuAPl5GhE810IDKG
	PEmbubHmETZR5klBwlwhEC9+sXCHua+be64Oc0+QOmjr2yyz6QaZtABMeROSVqeZ8BZjYu/F4M3
	WyQzAA7845CaPfOQ=
X-Google-Smtp-Source: AGHT+IFhRKm8yP4ybLtVM7FMTYL0LsALgcJNgjwXO7oc+jzCvJH9Gi2a3jIUCJN8VIl19enCQAvxwA==
X-Received: by 2002:a17:902:c94f:b0:215:a303:24e9 with SMTP id d9443c01a7336-22e846a2ab2mr48657765ad.3.1746711698591;
        Thu, 08 May 2025 06:41:38 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e766dffefsm24985605ad.33.2025.05.08.06.41.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:41:38 -0700 (PDT)
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
Subject: [PATCH v4 15/27] hw/core/machine: Remove hw_compat_2_6[] array
Date: Thu,  8 May 2025 15:35:38 +0200
Message-ID: <20250508133550.81391-16-philmd@linaro.org>
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

The hw_compat_2_6[] array was only used by the pc-q35-2.6 and
pc-i440fx-2.6 machines, which got removed. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 include/hw/boards.h | 3 ---
 hw/core/machine.c   | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index 5f1a0fb7e28..a881db8e7d6 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -841,7 +841,4 @@ extern const size_t hw_compat_2_8_len;
 extern GlobalProperty hw_compat_2_7[];
 extern const size_t hw_compat_2_7_len;
 
-extern GlobalProperty hw_compat_2_6[];
-extern const size_t hw_compat_2_6_len;
-
 #endif
diff --git a/hw/core/machine.c b/hw/core/machine.c
index e7001bf92cd..ce98820f277 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -275,14 +275,6 @@ GlobalProperty hw_compat_2_7[] = {
 };
 const size_t hw_compat_2_7_len = G_N_ELEMENTS(hw_compat_2_7);
 
-GlobalProperty hw_compat_2_6[] = {
-    { "virtio-mmio", "format_transport_address", "off" },
-    /* Optional because not all virtio-pci devices support legacy mode */
-    { "virtio-pci", "disable-modern", "on",  .optional = true },
-    { "virtio-pci", "disable-legacy", "off", .optional = true },
-};
-const size_t hw_compat_2_6_len = G_N_ELEMENTS(hw_compat_2_6);
-
 MachineState *current_machine;
 
 static char *machine_get_kernel(Object *obj, Error **errp)
-- 
2.47.1


