Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEB7629711
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiKOLRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232544AbiKOLQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:32 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05D21BEB3
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:30 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so1148077wmb.6
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RrwzRsB22pRwqfA6j+FOYGMh9VZ422ekWmaxzemiqxQ=;
        b=Slp7czprnwmYuZ415Tpi7Ar8cf0xmT3saibucqgkljWMwisDYhB8IylzI3jvbakIkK
         197ZHBFwH8avTYXwIS+gIpUU5yhvU4TEn0jVsAAigBPiIXsQDPQW6iE+BDmsFhjXDowu
         SLd66Ucil0UFwbsURF6Ae5J+Sl18SVhduaNtockidnm6FNm23QWxMLScwIAbV9GdJ0Na
         0h8ozf56B+AhoDuV13QWJc4sjz4chg3KdGLFFijzGFp9GaCvBiiFeAT1wX0EeeW0iRRk
         hRpCnqmiTxFt652sdI4uG/jKT8ai/gCup+OJ83sTgp6xrS9fKDNSQZj4d3jesm0JNePp
         Bc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RrwzRsB22pRwqfA6j+FOYGMh9VZ422ekWmaxzemiqxQ=;
        b=gNSx22iko5COVIaMjemfp4SngJ9sEaj0RYiMeLeP2e2m3o2KSG9NYxdQm52gJcfV6o
         tOjsicFbLaxF2PQSfO0tU6upUpCnr3t45xm5pmzp/rU5Vd/zodsXN1dGoOCHAvQ1bIkt
         5nsJKxZ8faEb6cj9MEKlHn6AdX5FnzhLNdUbbYPqphbIXNOIpFz8tWNz2Ze2gwKYeE8T
         eG/eyKBDJ+wVCcmfyNmkXR2ShXpk2rkbrbq7GKeUkU+cHvsdpzoGeF4dcwmovWgbvFHC
         0SLYNgnsiztRavp+FL93CwHy4HCH/9qPcVyQ/ERu0Ru54XiCKoDwRjtwCtyv21hLN1tT
         nbcg==
X-Gm-Message-State: ANoB5pkSrvpA/mLD+cy2D7K5ukF2QfwU+PZqikmbjaGnbHbDHGbgo7k0
        UXZJNAuHvP9cSSsf3O32qx/ZndNfiSo/JcyrYB9wdPAKvQFbdOGbBI0yEr+JGn6radYf1ufmG1/
        D2ak8RDIaf5BBVmmTfxpUZUThZRdRPcihOSqCcrA0qF/AJRlApL/eyP0=
X-Google-Smtp-Source: AA0mqf4DPzMK2Ddtk7GAom5Xpda1Ji5kjnD6ltgEtOTk2ID6j31UQC3Y3382smQQNTmAlKxlME5yNKfQag==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:adf:f508:0:b0:22e:5149:441d with SMTP id
 q8-20020adff508000000b0022e5149441dmr10245660wro.661.1668510989265; Tue, 15
 Nov 2022 03:16:29 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:49 +0000
In-Reply-To: <20221115111549.2784927-1-tabba@google.com>
Mime-Version: 1.0
References: <20221115111549.2784927-1-tabba@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-18-tabba@google.com>
Subject: [PATCH kvmtool v1 17/17] Pass the memory file descriptor and offset
 when registering ram
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the memory file descriptor is the canonical reference to guest
memory, pass that and the offset when registering guest memory.
Future fd-based kvm proposals might even not require a userspace
address [*].

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>

[*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.intel.com/
---
 arm/aarch64/pvtime.c |  2 +-
 arm/kvm.c            |  3 ++-
 hw/cfi_flash.c       |  4 +++-
 hw/vesa.c            |  2 +-
 include/kvm/kvm.h    | 17 +++++++++--------
 kvm.c                |  3 ++-
 mips/kvm.c           |  6 +++---
 powerpc/kvm.c        |  2 +-
 riscv/kvm.c          |  2 +-
 vfio/core.c          |  3 ++-
 x86/kvm.c            |  6 +++---
 11 files changed, 28 insertions(+), 22 deletions(-)

diff --git a/arm/aarch64/pvtime.c b/arm/aarch64/pvtime.c
index a7ba03e..9b06ee4 100644
--- a/arm/aarch64/pvtime.c
+++ b/arm/aarch64/pvtime.c
@@ -28,7 +28,7 @@ static int pvtime__alloc_region(struct kvm *kvm)
 	}
 
 	ret = kvm__register_ram(kvm, ARM_PVTIME_BASE,
-				ARM_PVTIME_SIZE, mem);
+				ARM_PVTIME_SIZE, mem, mem_fd, 0);
 	if (ret) {
 		munmap(mem, ARM_PVTIME_SIZE);
 		close(mem_fd);
diff --git a/arm/kvm.c b/arm/kvm.c
index 5cceef8..8772a55 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -50,7 +50,8 @@ void kvm__init_ram(struct kvm *kvm)
 	phys_start	= kvm->cfg.ram_addr;
 	phys_size	= kvm->ram_size;
 
-	err = kvm__register_ram(kvm, phys_start, phys_size, kvm->ram_start);
+	err = kvm__register_ram(kvm, phys_start, phys_size, kvm->ram_start,
+		kvm->ram_fd, 0);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
diff --git a/hw/cfi_flash.c b/hw/cfi_flash.c
index 7faecdf..92a6567 100644
--- a/hw/cfi_flash.c
+++ b/hw/cfi_flash.c
@@ -131,6 +131,7 @@ struct cfi_flash_device {
 	u32			size;
 
 	void			*flash_memory;
+	int			flash_fd;
 	u8			program_buffer[PROGRAM_BUFF_SIZE];
 	unsigned long		*lock_bm;
 	u64			block_address;
@@ -451,7 +452,7 @@ static int map_flash_memory(struct kvm *kvm, struct cfi_flash_device *sfdev)
 	int ret;
 
 	ret = kvm__register_mem(kvm, sfdev->base_addr, sfdev->size,
-				sfdev->flash_memory,
+				sfdev->flash_memory, sfdev->flash_fd, 0,
 				KVM_MEM_TYPE_RAM | KVM_MEM_TYPE_READONLY);
 	if (!ret)
 		sfdev->is_mapped = true;
@@ -583,6 +584,7 @@ static struct cfi_flash_device *create_flash_device_file(struct kvm *kvm,
 		ret = -errno;
 		goto out_free;
 	}
+	sfdev->flash_fd = fd;
 	sfdev->base_addr = KVM_FLASH_MMIO_BASE;
 	sfdev->state = READY;
 	sfdev->read_mode = READ_ARRAY;
diff --git a/hw/vesa.c b/hw/vesa.c
index 522ffa3..277d638 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -102,7 +102,7 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 		goto close_memfd;
 	}
 
-	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem);
+	r = kvm__register_dev_mem(kvm, VESA_MEM_ADDR, VESA_MEM_SIZE, mem, mem_fd, 0);
 	if (r < 0)
 		goto unmap_dev;
 
diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index f0be524..33cae9d 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -135,24 +135,25 @@ bool kvm__emulate_io(struct kvm_cpu *vcpu, u16 port, void *data, int direction,
 bool kvm__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data, u32 len, u8 is_write);
 int kvm__destroy_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr);
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size, void *userspace_addr,
-		      enum kvm_mem_type type);
+		      int memfd, u64 offset, enum kvm_mem_type type);
 static inline int kvm__register_ram(struct kvm *kvm, u64 guest_phys, u64 size,
-				    void *userspace_addr)
+				    void *userspace_addr, int memfd, u64 offset)
 {
-	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
-				 KVM_MEM_TYPE_RAM);
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr, memfd,
+				 offset, KVM_MEM_TYPE_RAM);
 }
 
 static inline int kvm__register_dev_mem(struct kvm *kvm, u64 guest_phys,
-					u64 size, void *userspace_addr)
+					u64 size, void *userspace_addr,
+					int memfd, u64 offset)
 {
-	return kvm__register_mem(kvm, guest_phys, size, userspace_addr,
-				 KVM_MEM_TYPE_DEVICE);
+	return kvm__register_mem(kvm, guest_phys, size, userspace_addr, memfd,
+				 offset, KVM_MEM_TYPE_DEVICE);
 }
 
 static inline int kvm__reserve_mem(struct kvm *kvm, u64 guest_phys, u64 size)
 {
-	return kvm__register_mem(kvm, guest_phys, size, NULL,
+	return kvm__register_mem(kvm, guest_phys, size, NULL, -1, 0,
 				 KVM_MEM_TYPE_RESERVED);
 }
 
diff --git a/kvm.c b/kvm.c
index a1eb365..0c6ed3d 100644
--- a/kvm.c
+++ b/kvm.c
@@ -256,7 +256,8 @@ out:
 }
 
 int kvm__register_mem(struct kvm *kvm, u64 guest_phys, u64 size,
-		      void *userspace_addr, enum kvm_mem_type type)
+		      void *userspace_addr, int memfd, u64 offset,
+		      enum kvm_mem_type type)
 {
 	struct kvm_mem_bank *merged = NULL;
 	struct kvm_mem_bank *bank;
diff --git a/mips/kvm.c b/mips/kvm.c
index 0a0d025..ebb2b19 100644
--- a/mips/kvm.c
+++ b/mips/kvm.c
@@ -38,21 +38,21 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	} else {
 		/* one region for memory that fits below MMIO range */
 		phys_start = 0;
 		phys_size  = KVM_MMIO_START;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 
 		/* one region for rest of memory */
 		phys_start = KVM_MMIO_START + KVM_MMIO_SIZE;
 		phys_size  = kvm->ram_size - KVM_MMIO_START;
 		host_mem   = kvm->ram_start + KVM_MMIO_START;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	}
 }
 
diff --git a/powerpc/kvm.c b/powerpc/kvm.c
index 8d467e9..c36c497 100644
--- a/powerpc/kvm.c
+++ b/powerpc/kvm.c
@@ -88,7 +88,7 @@ void kvm__init_ram(struct kvm *kvm)
 		    "overlaps MMIO!\n",
 		    phys_size);
 
-	kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 }
 
 void kvm__arch_set_cmdline(char *cmdline, bool video)
diff --git a/riscv/kvm.c b/riscv/kvm.c
index 4a2a3df..bb79c5d 100644
--- a/riscv/kvm.c
+++ b/riscv/kvm.c
@@ -38,7 +38,7 @@ void kvm__init_ram(struct kvm *kvm)
 	phys_size	= kvm->ram_size;
 	host_mem	= kvm->ram_start;
 
-	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	if (err)
 		die("Failed to register %lld bytes of memory at physical "
 		    "address 0x%llx [err %d]", phys_size, phys_start, err);
diff --git a/vfio/core.c b/vfio/core.c
index 3ff2c0b..ea189a0 100644
--- a/vfio/core.c
+++ b/vfio/core.c
@@ -255,7 +255,8 @@ int vfio_map_region(struct kvm *kvm, struct vfio_device *vdev,
 	region->host_addr = base;
 
 	ret = kvm__register_dev_mem(kvm, region->guest_phys_addr, map_size,
-				    region->host_addr);
+				    region->host_addr, vdev->fd,
+				    region->info.offset);
 	if (ret) {
 		vfio_dev_err(vdev, "failed to register region with KVM");
 		return ret;
diff --git a/x86/kvm.c b/x86/kvm.c
index 8d29904..cee82d3 100644
--- a/x86/kvm.c
+++ b/x86/kvm.c
@@ -107,7 +107,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	} else {
 		/* First RAM range from zero to the PCI gap: */
 
@@ -115,7 +115,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = KVM_32BIT_GAP_START;
 		host_mem   = kvm->ram_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 
 		/* Second RAM range from 4GB to the end of RAM: */
 
@@ -123,7 +123,7 @@ void kvm__init_ram(struct kvm *kvm)
 		phys_size  = kvm->ram_size - phys_start;
 		host_mem   = kvm->ram_start + phys_start;
 
-		kvm__register_ram(kvm, phys_start, phys_size, host_mem);
+		kvm__register_ram(kvm, phys_start, phys_size, host_mem, kvm->ram_fd, 0);
 	}
 }
 
-- 
2.38.1.431.g37b22c650d-goog

