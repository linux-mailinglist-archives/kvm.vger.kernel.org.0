Return-Path: <kvm+bounces-45870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5B0AAFBA6
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F423A90B3
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98FE322B8C3;
	Thu,  8 May 2025 13:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="untv0Jxm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409BE84D13
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711611; cv=none; b=CyERctI9O9VHHRfH/Grm7NzhLdTc1kzAOyT9pscaFK7kenKWbXvJEPyVhzRFDxPE4kNz9TKO8H46OqQIHD+nGxVZgKjB8EyU/FZr76GPXFdT7CD7DIpKm7I3FkZKNHfCj7ZBnCJe1o66EPwGV4xcun8eFtsiopKcmWF4jYyZ3iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711611; c=relaxed/simple;
	bh=+jypoLN8eT3LPlOHE7eM3AKU31p+pkhCBzwwyXQQpXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hIH4Pq4tAJaN5SiUWyFb1GyhcziR+BsLCGk2QqgRaLl/6HZLO/2HfAdHE7xC2/n84hl/3kOzS2wTnpDz1k7jD4C9Mt/YtJ6kBDmWRn6YzDdjrXxdS8dQQnISD90gmvKkr6F7HCI5nsyVCt8f8hYGywcqxgdkhKsal9NXTBaNPOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=untv0Jxm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22fa47d6578so6843655ad.2
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711609; x=1747316409; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8Pwvw+j4e5J09FPHtAsan2JUEBLBE3y7JNJd5PTK2A=;
        b=untv0JxmUxzN3LyJNkY5MuO/lYl/ClShaYVn7phbyHIIsK2Gqn95XWlEw3QXjxzJAw
         TFDGOWHw21bjBlAuPog72flcHk7wBN3debDPz0UxYhfh5+suGOPU0MFGu3o/L/xFM0Nz
         sf9XcAr0xFeMAovk0+EpT1+QXJQyittpIJAPh9ptvj8mBzSCn31KKXNZfYLoWx2o81+R
         9tbVPPtJUba8bZSR0OsUoSPIGAsNTBSXZueuoyyt+16ee4N5T7Aay4vk4ReMzaHXINfd
         iz/0uHnAG7DkYg75+gloCB40TjJeO9piDnHW+NNbtK8Ac7ZTnbZajwBA95s4MKCANU7n
         TmDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711609; x=1747316409;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8Pwvw+j4e5J09FPHtAsan2JUEBLBE3y7JNJd5PTK2A=;
        b=COGDd6QddGqzeNHnxUTgeZJUBZ+O36td3+gFmUx3k6YcqoWldt0i/a64qBtcLFKkfX
         qSl0qI+VKnBCIfC2jMIBEmjCWFog/dSGJeBxs4x4Gbn1dMa6RnD4cnu3Tc0zSEwG/q3I
         2NKO+zaQi3rPN3R1WRRBVjg7J0/Yai1dlZMQ5a1sEsUQZWfU8XHObkJNn1CgF5CWzMYO
         29ZyH0+x3Ar+zE5RbD/PFiip3HexxrrZRQxRKNmEsErUt5shJwg1OCQzWODRgPkoyq9s
         v+Aq3r/WPf47yGcw16KhRBr8bZdyn0KlO2gp7MjOjIKc9WOKvbQVS/OSVRM8tFzmxbMv
         cdAQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0w6V/iJeP9Mp2vWTvl7CZ3UbNjQyKwSODyv5ku07mDkbp0OIxOsBz/pu1P7VkuNg68+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHVNZP5243CTZnCZMF6GqOtFh2mE/jqPSaNnS6B1SqbbCGwShH
	aRBR9K3gJgW1TdSby9eXETjEilPdLpuygtsbYROFHMRi4gZ64b0/bW8OPFQ/mvY=
X-Gm-Gg: ASbGnctOg2Zd5y0ZJlKHDrcdXYNjkv/F5YIkWbfSBQs2xQdnHQP/Xj632H3MAAtEXmI
	4xRzN0uJ2vuTVhWyv6VZG2vSt7fiInMRcCWs3VFeYkn4E0vjAWzt0+WqlDAJ/Vc91CNW5eD8KPx
	lWr+0Ik+FCFt8l2vNJ4uxiwUyyOMspC1AH/4LE9krRlFCeYG7lYww04gdADFCFSKZ2j9xYJrUDx
	HPWB8msMxh5XO4nZcJ4XwY7xzthc5n5JZmOKUaHJIEgTtE+5G0PqKgtKs+eDBcvhA2pCo3hyKng
	P/em3QanHdDuAgrWex7wp6gBL45KGWGcMVNtMkDbt2y0OvcgbvLetuzaY3a4VDhKMOIXDWzTPc5
	8/TS691/AktiqSeM=
X-Google-Smtp-Source: AGHT+IEHNU51J756smrG33Ll3fKAa4cINEE9vVGIcVFbaMYD4LmaTKtFYWOJts/yoYULQ+dhKo+C6Q==
X-Received: by 2002:a17:902:d50d:b0:221:78a1:27fb with SMTP id d9443c01a7336-22e5ea38b30mr113474455ad.11.1746711609535;
        Thu, 08 May 2025 06:40:09 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3b62502sm11305764a12.32.2025.05.08.06.39.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:40:09 -0700 (PDT)
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
Subject: [PATCH v4 11/27] hw/i386/pc: Remove pc_compat_2_6[] array
Date: Thu,  8 May 2025 15:35:34 +0200
Message-ID: <20250508133550.81391-12-philmd@linaro.org>
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

The pc_compat_2_6[] array was only used by the pc-q35-2.6
and pc-i440fx-2.6 machines, which got removed. Remove it.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 include/hw/i386/pc.h | 3 ---
 hw/i386/pc.c         | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index a3de3e9560d..4fb2033bc54 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -292,9 +292,6 @@ extern const size_t pc_compat_2_8_len;
 extern GlobalProperty pc_compat_2_7[];
 extern const size_t pc_compat_2_7_len;
 
-extern GlobalProperty pc_compat_2_6[];
-extern const size_t pc_compat_2_6_len;
-
 #define DEFINE_PC_MACHINE(suffix, namestr, initfn, optsfn) \
     static void pc_machine_##suffix##_class_init(ObjectClass *oc, \
                                                  const void *data) \
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 4e6fe68e2e0..65a11ea8f99 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -251,14 +251,6 @@ GlobalProperty pc_compat_2_7[] = {
 };
 const size_t pc_compat_2_7_len = G_N_ELEMENTS(pc_compat_2_7);
 
-GlobalProperty pc_compat_2_6[] = {
-    { TYPE_X86_CPU, "cpuid-0xb", "off" },
-    { "vmxnet3", "romfile", "" },
-    { TYPE_X86_CPU, "fill-mtrr-mask", "off" },
-    { "apic-common", "legacy-instance-id", "on", }
-};
-const size_t pc_compat_2_6_len = G_N_ELEMENTS(pc_compat_2_6);
-
 /*
  * @PC_FW_DATA:
  * Size of the chunk of memory at the top of RAM for the BIOS ACPI tables
-- 
2.47.1


