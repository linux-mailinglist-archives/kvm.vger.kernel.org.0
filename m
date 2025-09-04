Return-Path: <kvm+bounces-56775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7CCAB4351A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 935F217EF8A
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275CB2C1786;
	Thu,  4 Sep 2025 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XZ3PUScF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382BA2C1585
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973503; cv=none; b=c5RvaYUJVV+E6C0LAWV8ypdA32sO6kGscRLglbiU9mylKj2R3CQh2fO8Lz42CHr0/CnJdCfFnH/HOj5nC6Dk857f6CCq0biyFqMd88tKHBqFwPdLLPdqJU4dgu69711dQvnDoIFULHIcZskLSdOgX3H2AwPHEoVX0VyAQug0ISA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973503; c=relaxed/simple;
	bh=f1lJK4+aqwvadGneDXpE4FsiMRAIu20TV3graj9zEwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpvJN/jJldRRuUDxcZ7klq5rSu8FNbdMh4LqzmUpf6CiXDvKARxJllGNclej6Xh3UqKJ3GvaxBT9fLV/tCfvJDXyderhkRul/HHp30Ldcw+JL6EvEKAPVn25PMChi1Av0YbAsD7t6jug3RTaHKkDPbIc7wq7FB8u69cI8ovNkdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XZ3PUScF; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-61d3d622a2bso2400234a12.0
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973500; x=1757578300; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZYVyVNsFyTXeOSFCWu8uUvsiqoxRwuwTGPuSI8iWgeI=;
        b=XZ3PUScFCyC0MbhPtUD6zfT/Sa2sXvIN8db7hwFYdm81fB64nGYdSL5abMlJVjA8Jp
         OTEhhRVrknxDua3bNyCFT3NNgPDra/XqPAZKUQFTx2KAVcClGnrIQjBv8/T3MPN7JTg7
         wTYIAr82rPRaqTwUHuppqeZ+IcPhwg7ZbTaKkqaxTba14Qaw2/F5uy+Uv6vDnbRJBwwh
         1vpKYQf1z1YPcJO6g3O9zZn3wo8Y/U2/ffAIzmvLByBX2fQoZoilJhH7w2ZSbrUEBGod
         UUUUUuedZmJAIEygVAkgHhdXWZQvfMf0E8OvY4dfhMo65T5+MxaZCTSQG9J5pvwAk6CM
         GsRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973500; x=1757578300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZYVyVNsFyTXeOSFCWu8uUvsiqoxRwuwTGPuSI8iWgeI=;
        b=UHp9I8W/J5dpqkT3e6yvwdXOGayIyP5Vyvq0SVxVy/9NrICI/5jJ8oQusKiB2F1bs/
         aSBdHKjRQRPZwY7resnZ0dOMfzuXaDG/ak+gnvOBwrlX8jwu1oSt8if72NJX+4cSxw+0
         9kYDoy5EA48cdgHrxGvBAqNqayZdmV+tch6oqtaxAJKctpg1xNlWOYQBgl2JQJScQkxh
         bAyujRNx7L2gUjYmAFD9aez4KZLlNKl61t+m+udsCNyCkXWTa3QrUoiA1Ox8pZ6YKMvv
         9g/xei9DXOoxy12FYLHMoQrzx2n1ahitq8jFa5iNGNBWe5yc9lGmpAhyx8KEpfmV+7UJ
         X02Q==
X-Forwarded-Encrypted: i=1; AJvYcCVztaAsiVtYWXd6Qm0POEsT7hROrhxE/B+WnzxCPM9MdKWheKXUsnDU+FkGD1QoSx11cts=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2VJR5aZC1kZLJ6iqMezWQr84kBR9EsOQ3x0+kDSCB4ZerPIXG
	knW0OcTCQqvbsL/qyeFgPu1gSziAL0CV0Rg93zMwl09O6E3rLuunoQP3t6/xCdofnU8=
X-Gm-Gg: ASbGncsKpT6dI6d3dekpRIVlC1ZQ41+0QPwzTKBzyoahhj27RY3Y0Ce1PfOUprsfMv1
	/AONsDW10Mn1w+mhD3CCvR9VF21qLgYFMDdHhzr5wojbwUMC6thW+0PZNiAW8wh5bwE6MaUev/b
	zaZmCWdmLkqeoLMsM4hH68oudLT5G4kfD2z4xi+1Uo0lupX+et2uedEL5hfqpmecRCRKX1drTuI
	U3uGQ8zGUldwPFWtmpNocZ0yoeCNNWp65gQXDNyqANSRLqKVjIdi/EAAIQEHnv/YUi4bCu8HdE0
	xhNHvn3scM69omzqw8RQwKIFpv3dG8yEOR6EQS4RC3Nauhv72qi88DT6q7lWdFu/bXHVxratMaK
	yNRbvW4ZFMD7b37HFh4tV1S0L5GiXzyMH+w==
X-Google-Smtp-Source: AGHT+IFieb+gm+rWJ0Oa45cj1KjcPCC4rl/ynxe9G4bgf3W7srLgMSyNw8FhmhZu6eY5HA4lnrH5tA==
X-Received: by 2002:a17:907:9729:b0:af9:8739:10ca with SMTP id a640c23a62f3a-b01083235f9mr1709209966b.28.1756973499527;
        Thu, 04 Sep 2025 01:11:39 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b047011daa1sm275133966b.79.2025.09.04.01.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:37 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2163E5F93E;
	Thu, 04 Sep 2025 09:11:29 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>,
	Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 008/281] hw: add compat machines for 10.2
Date: Thu,  4 Sep 2025 09:06:42 +0100
Message-ID: <20250904081128.1942269-9-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250904081128.1942269-1-alex.bennee@linaro.org>
References: <20250904081128.1942269-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Cornelia Huck <cohuck@redhat.com>

Add 10.2 machine types for arm/i440fx/m68k/q35/s390x/spapr.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20250805095616.1168905-1-cohuck@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 include/hw/boards.h        |  3 +++
 include/hw/i386/pc.h       |  3 +++
 hw/arm/virt.c              |  9 ++++++++-
 hw/core/machine.c          |  3 +++
 hw/i386/pc.c               |  3 +++
 hw/i386/pc_piix.c          | 13 +++++++++++--
 hw/i386/pc_q35.c           | 13 +++++++++++--
 hw/m68k/virt.c             |  9 ++++++++-
 hw/ppc/spapr.c             | 15 +++++++++++++--
 hw/s390x/s390-virtio-ccw.c | 14 +++++++++++++-
 10 files changed, 76 insertions(+), 9 deletions(-)

diff --git a/include/hw/boards.h b/include/hw/boards.h
index f94713e6e29..665b6201214 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -779,6 +779,9 @@ struct MachineState {
     } \
     type_init(machine_initfn##_register_types)
 
+extern GlobalProperty hw_compat_10_1[];
+extern const size_t hw_compat_10_1_len;
+
 extern GlobalProperty hw_compat_10_0[];
 extern const size_t hw_compat_10_0_len;
 
diff --git a/include/hw/i386/pc.h b/include/hw/i386/pc.h
index 79b72c54dd3..e83157ab358 100644
--- a/include/hw/i386/pc.h
+++ b/include/hw/i386/pc.h
@@ -214,6 +214,9 @@ void pc_system_parse_ovmf_flash(uint8_t *flash_ptr, size_t flash_size);
 /* sgx.c */
 void pc_machine_init_sgx_epc(PCMachineState *pcms);
 
+extern GlobalProperty pc_compat_10_1[];
+extern const size_t pc_compat_10_1_len;
+
 extern GlobalProperty pc_compat_10_0[];
 extern const size_t pc_compat_10_0_len;
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index ef6be3660f5..9326cfc895f 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -3455,10 +3455,17 @@ static void machvirt_machine_init(void)
 }
 type_init(machvirt_machine_init);
 
+static void virt_machine_10_2_options(MachineClass *mc)
+{
+}
+DEFINE_VIRT_MACHINE_AS_LATEST(10, 2)
+
 static void virt_machine_10_1_options(MachineClass *mc)
 {
+    virt_machine_10_2_options(mc);
+    compat_props_add(mc->compat_props, hw_compat_10_1, hw_compat_10_1_len);
 }
-DEFINE_VIRT_MACHINE_AS_LATEST(10, 1)
+DEFINE_VIRT_MACHINE(10, 1)
 
 static void virt_machine_10_0_options(MachineClass *mc)
 {
diff --git a/hw/core/machine.c b/hw/core/machine.c
index bd47527479a..38c949c4f2c 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -37,6 +37,9 @@
 #include "hw/virtio/virtio-iommu.h"
 #include "audio/audio.h"
 
+GlobalProperty hw_compat_10_1[] = {};
+const size_t hw_compat_10_1_len = G_N_ELEMENTS(hw_compat_10_1);
+
 GlobalProperty hw_compat_10_0[] = {
     { "scsi-hd", "dpofua", "off" },
     { "vfio-pci", "x-migration-load-config-after-iter", "off" },
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 2f58e73d334..bc048a6d137 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -81,6 +81,9 @@
     { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
     { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
 
+GlobalProperty pc_compat_10_1[] = {};
+const size_t pc_compat_10_1_len = G_N_ELEMENTS(pc_compat_10_1);
+
 GlobalProperty pc_compat_10_0[] = {
     { TYPE_X86_CPU, "x-consistent-cache", "false" },
     { TYPE_X86_CPU, "x-vendor-cpuid-only-v2", "false" },
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index c03324281bd..d165ac72ed7 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -504,12 +504,21 @@ static void pc_i440fx_machine_options(MachineClass *m)
                      pc_piix_compat_defaults, pc_piix_compat_defaults_len);
 }
 
-static void pc_i440fx_machine_10_1_options(MachineClass *m)
+static void pc_i440fx_machine_10_2_options(MachineClass *m)
 {
     pc_i440fx_machine_options(m);
 }
 
-DEFINE_I440FX_MACHINE_AS_LATEST(10, 1);
+DEFINE_I440FX_MACHINE_AS_LATEST(10, 2);
+
+static void pc_i440fx_machine_10_1_options(MachineClass *m)
+{
+    pc_i440fx_machine_10_2_options(m);
+    compat_props_add(m->compat_props, hw_compat_10_1, hw_compat_10_1_len);
+    compat_props_add(m->compat_props, pc_compat_10_1, pc_compat_10_1_len);
+}
+
+DEFINE_I440FX_MACHINE(10, 1);
 
 static void pc_i440fx_machine_10_0_options(MachineClass *m)
 {
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index b309b2b378d..e89951285e5 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -374,12 +374,21 @@ static void pc_q35_machine_options(MachineClass *m)
                      pc_q35_compat_defaults, pc_q35_compat_defaults_len);
 }
 
-static void pc_q35_machine_10_1_options(MachineClass *m)
+static void pc_q35_machine_10_2_options(MachineClass *m)
 {
     pc_q35_machine_options(m);
 }
 
-DEFINE_Q35_MACHINE_AS_LATEST(10, 1);
+DEFINE_Q35_MACHINE_AS_LATEST(10, 2);
+
+static void pc_q35_machine_10_1_options(MachineClass *m)
+{
+    pc_q35_machine_10_2_options(m);
+    compat_props_add(m->compat_props, hw_compat_10_1, hw_compat_10_1_len);
+    compat_props_add(m->compat_props, pc_compat_10_1, pc_compat_10_1_len);
+}
+
+DEFINE_Q35_MACHINE(10, 1);
 
 static void pc_q35_machine_10_0_options(MachineClass *m)
 {
diff --git a/hw/m68k/virt.c b/hw/m68k/virt.c
index 875fd00ef8d..98cfe43c73a 100644
--- a/hw/m68k/virt.c
+++ b/hw/m68k/virt.c
@@ -367,10 +367,17 @@ type_init(virt_machine_register_types)
 #define DEFINE_VIRT_MACHINE(major, minor) \
     DEFINE_VIRT_MACHINE_IMPL(false, major, minor)
 
+static void virt_machine_10_2_options(MachineClass *mc)
+{
+}
+DEFINE_VIRT_MACHINE_AS_LATEST(10, 2)
+
 static void virt_machine_10_1_options(MachineClass *mc)
 {
+    virt_machine_10_2_options(mc);
+    compat_props_add(mc->compat_props, hw_compat_10_1, hw_compat_10_1_len);
 }
-DEFINE_VIRT_MACHINE_AS_LATEST(10, 1)
+DEFINE_VIRT_MACHINE(10, 1)
 
 static void virt_machine_10_0_options(MachineClass *mc)
 {
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index 1855a3cd8d0..eb22333404d 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4761,15 +4761,26 @@ static void spapr_machine_latest_class_options(MachineClass *mc)
 #define DEFINE_SPAPR_MACHINE(major, minor) \
     DEFINE_SPAPR_MACHINE_IMPL(false, major, minor)
 
+/*
+ * pseries-10.2
+ */
+static void spapr_machine_10_2_class_options(MachineClass *mc)
+{
+    /* Defaults for the latest behaviour inherited from the base class */
+}
+
+DEFINE_SPAPR_MACHINE_AS_LATEST(10, 2);
+
 /*
  * pseries-10.1
  */
 static void spapr_machine_10_1_class_options(MachineClass *mc)
 {
-    /* Defaults for the latest behaviour inherited from the base class */
+    spapr_machine_10_2_class_options(mc);
+    compat_props_add(mc->compat_props, hw_compat_10_1, hw_compat_10_1_len);
 }
 
-DEFINE_SPAPR_MACHINE_AS_LATEST(10, 1);
+DEFINE_SPAPR_MACHINE(10, 1);
 
 /*
  * pseries-10.0
diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
index a79bd13275b..d0c6e80cb05 100644
--- a/hw/s390x/s390-virtio-ccw.c
+++ b/hw/s390x/s390-virtio-ccw.c
@@ -911,14 +911,26 @@ static const TypeInfo ccw_machine_info = {
     DEFINE_CCW_MACHINE_IMPL(false, major, minor)
 
 
+static void ccw_machine_10_2_instance_options(MachineState *machine)
+{
+}
+
+static void ccw_machine_10_2_class_options(MachineClass *mc)
+{
+}
+DEFINE_CCW_MACHINE_AS_LATEST(10, 2);
+
 static void ccw_machine_10_1_instance_options(MachineState *machine)
 {
+    ccw_machine_10_2_instance_options(machine);
 }
 
 static void ccw_machine_10_1_class_options(MachineClass *mc)
 {
+    ccw_machine_10_2_class_options(mc);
+    compat_props_add(mc->compat_props, hw_compat_10_1, hw_compat_10_1_len);
 }
-DEFINE_CCW_MACHINE_AS_LATEST(10, 1);
+DEFINE_CCW_MACHINE(10, 1);
 
 static void ccw_machine_10_0_instance_options(MachineState *machine)
 {
-- 
2.47.2


