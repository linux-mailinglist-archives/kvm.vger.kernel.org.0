Return-Path: <kvm+bounces-60508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 12645BF09DB
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 12:41:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AA55F4E0622
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 10:41:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F6202FBE03;
	Mon, 20 Oct 2025 10:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IxZPtMkn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330472FBDFF
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 10:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760956767; cv=none; b=Ye0AmNnCyFlJ27YAKQ8ltvC4A9+qhSL/siMd7NSHv9P3quUhe0aVtdX7BGvtUia2x++Wdd1/Dll5QE2ApiZ0tEGETKrhfQSJFRNXqbxlPrUHTmVR/yIqR1IVzcFD4J0jn+Lw6yp/n9RXtwFcAH220onK/AgtOmAUJpxyjFOo/eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760956767; c=relaxed/simple;
	bh=M/ymMNPoDiPp+pbd4JkfalLUlnptM2j3t9MgEvqeqQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K2fK338HrDx1BzikEXyjCGuUSWZaEjpqBKHzcoVcPmPFumFh+iDB8ym8s5olRv9ylNlD7NrrrVRVRnSfEuJI4xQ+iyixOJ63ACfyPdBjRonmO/kl9MA7h7mGuURO9mThUqb+wuQ86sOClkimx0mW6a061W0Zn8tZVYn+eGnW4JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IxZPtMkn; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4283be7df63so989883f8f.1
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 03:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760956763; x=1761561563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W8V6t72s6m9O+rQuQWdHSJVeQu4En69ObrbMa64lrwE=;
        b=IxZPtMkn+zlNzMNlG5dgSTQ7IL8VWpD+NTfpQC3E4n+dloW4OScpJstCfXLJyGRKvv
         B/Nf/kkW/AjPLIArdCfBUtDogwMGIzaE1fSfkibREYh62JOf5CN3W2dfHU9PGUc8jqHG
         +21cbxsjtgeZYW9KaC+mTi8m8Ax3cqWlRIabA3yLeuM3RBCGpzAY76aEb9XbRP9rpdZ8
         CrmLw77eEv1IBr3Mbonidy/P5bpPDrwJweHKJ27MKBHYiNgn7HIJFqeUKg5dbC20sQ89
         Kjv0zhT3FFlPAFi08GGfQ3KpsPjo3+U2VhXxdEdQn/5TV5ecSFq/uQt/FC13fNKrrmeP
         cYYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760956763; x=1761561563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8V6t72s6m9O+rQuQWdHSJVeQu4En69ObrbMa64lrwE=;
        b=I5/UGpBS/ZFVVOr8LgTXV9IOEWeGCQmUQrJMLYEdf45dqu/D7N82bFq8DWARxFBoYp
         PclW8GPbauMO29K3BW0JWTMjZFm9cYJ5uj+zf7LrXBGtVtduqJGOuYE/HQSIWHFUk1xR
         K64MTbO8vmaBconU0VWkVeHdjlVN/JiQ0sWc9puGomwtl8ExpIP0kaJ/nr62oynrq4Mm
         8UtZsCX58OWlFxi0fJYtDycq6687goEQqIxqz/inQgeg+UQV4wDfMgFrerXP1NweO2qv
         Je4/l0fPKLe8Ayl9Dr2JJCuzl/gF+/EQQ/aSn6FhrXOg+g/kIv8I4U/qOFvSHvdb/aGG
         wOzw==
X-Forwarded-Encrypted: i=1; AJvYcCU1EWiZbmWc5A8F3LJcbSjUKkEe/YOWa+XipmXMjI85G/rJ3jPd6vqZM6YtdH1qtD6EDbs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz/HWYl4J8A7k4EC6ETlupWWXTFf8rf4NXb3j8LpXmQ9u8vWk0
	CsVyHuOF5Ql+SKHPpdkCBBWlxeP/QVlUV+hG0mCf/vK4JKeFJZc0jY09r/BPQY28no4=
X-Gm-Gg: ASbGncvqnPHwlbRrcftxo8DRKeylLO9mTBYsbVRx4Te/VzlQqgEuyLj7QCIEiAe5wtL
	nm2mpV22zeZ4ojXSECHhbnZLYwxmIsOmtDh4hoC8m3f45/8Z1vsRTJyKPIFrUVbXelVMvzBSAez
	ZGxO6cJCnUDrTrAEWhMzXbZI9VhuJApxeu2F4A1ewXW2qMzk9HxbXee7IdXOM78WX5KVdj4CakI
	45hCii6vCLmD6Yp9/3zcd4y8R7zxEzcbqxLyt9R35ohGsEKfLOS5kYezB6Ya1Z9Wf5yoZCKVjKn
	pdLGitK8DxF8hxmg2RvcBoKq54fnL/fFqcudYhjXzD6d31Z/QyXnznDiszUFxZqGaCPz4kYdBsh
	GtlfqmEtFLi2i0VL/snLssW3jo9mi8aJkbH8MSjo4nENzCNwpI+iuKRH8UxlbGZFj76ZkdZ7p1h
	qzS4FRC0tqc1pJbynJaM6tN1ON6kAjY9ipgxfkQRFrncEjDe/3Ew==
X-Google-Smtp-Source: AGHT+IGtRhefuOKzzFl9+PdkwonrQEzKn77Y5Nm+6QawC0+EavDuvCFIl4z0qnwNmWAUflc1D40aEw==
X-Received: by 2002:a5d:5f82:0:b0:425:8133:8a89 with SMTP id ffacd0b85a97d-42704d75729mr9332637f8f.22.1760956763315;
        Mon, 20 Oct 2025 03:39:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427ea5b3d4csm14321834f8f.19.2025.10.20.03.39.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 20 Oct 2025 03:39:22 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	qemu-ppc@nongnu.org,
	kvm@vger.kernel.org,
	Chinmay Rath <rathc@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 13/18] hw/ppc/spapr: Remove SpaprMachineClass::phb_placement callback
Date: Mon, 20 Oct 2025 12:38:09 +0200
Message-ID: <20251020103815.78415-14-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251020103815.78415-1-philmd@linaro.org>
References: <20251020103815.78415-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The SpaprMachineClass::phb_placement callback was only used by
the pseries-4.0 machine, which got removed. Remove it as now
unused, directly calling spapr_phb_placement().
Move spapr_phb_placement() definition to avoid forward declaration.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |   5 --
 hw/ppc/spapr.c         | 114 ++++++++++++++++++++---------------------
 2 files changed, 55 insertions(+), 64 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 4c1acd7af5e..82f556f97e1 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -149,11 +149,6 @@ struct SpaprMachineClass {
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
     bool pre_6_2_numa_affinity;
-
-    bool (*phb_placement)(SpaprMachineState *spapr, uint32_t index,
-                          uint64_t *buid, hwaddr *pio,
-                          hwaddr *mmio32, hwaddr *mmio64,
-                          unsigned n_dma, uint32_t *liobns, Error **errp);
     SpaprResizeHpt resize_hpt_default;
     SpaprCapabilities default_caps;
     SpaprIrq *irq;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index e861a2e7466..200e68b8bc2 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -4067,12 +4067,62 @@ int spapr_phb_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
     return 0;
 }
 
+static bool spapr_phb_placement(SpaprMachineState *spapr, uint32_t index,
+                                uint64_t *buid, hwaddr *pio,
+                                hwaddr *mmio32, hwaddr *mmio64,
+                                unsigned n_dma, uint32_t *liobns, Error **errp)
+{
+    /*
+     * New-style PHB window placement.
+     *
+     * Goals: Gives large (1TiB), naturally aligned 64-bit MMIO window
+     * for each PHB, in addition to 2GiB 32-bit MMIO and 64kiB PIO
+     * windows.
+     *
+     * Some guest kernels can't work with MMIO windows above 1<<46
+     * (64TiB), so we place up to 31 PHBs in the area 32TiB..64TiB
+     *
+     * 32TiB..(33TiB+1984kiB) contains the 64kiB PIO windows for each
+     * PHB stacked together.  (32TiB+2GiB)..(32TiB+64GiB) contains the
+     * 2GiB 32-bit MMIO windows for each PHB.  Then 33..64TiB has the
+     * 1TiB 64-bit MMIO windows for each PHB.
+     */
+    const uint64_t base_buid = 0x800000020000000ULL;
+    int i;
+
+    /* Sanity check natural alignments */
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_BASE % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_LIMIT % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM64_WIN_SIZE % SPAPR_PCI_MEM32_WIN_SIZE) != 0);
+    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM32_WIN_SIZE % SPAPR_PCI_IO_WIN_SIZE) != 0);
+    /* Sanity check bounds */
+    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_IO_WIN_SIZE) >
+                      SPAPR_PCI_MEM32_WIN_SIZE);
+    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_MEM32_WIN_SIZE) >
+                      SPAPR_PCI_MEM64_WIN_SIZE);
+
+    if (index >= SPAPR_MAX_PHBS) {
+        error_setg(errp, "\"index\" for PAPR PHB is too large (max %llu)",
+                   SPAPR_MAX_PHBS - 1);
+        return false;
+    }
+
+    *buid = base_buid + index;
+    for (i = 0; i < n_dma; ++i) {
+        liobns[i] = SPAPR_PCI_LIOBN(index, i);
+    }
+
+    *pio = SPAPR_PCI_BASE + index * SPAPR_PCI_IO_WIN_SIZE;
+    *mmio32 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM32_WIN_SIZE;
+    *mmio64 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM64_WIN_SIZE;
+    return true;
+}
+
 static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                                Error **errp)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(OBJECT(hotplug_dev));
     SpaprPhbState *sphb = SPAPR_PCI_HOST_BRIDGE(dev);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     const unsigned windows_supported = spapr_phb_windows_supported(sphb);
     SpaprDrc *drc;
 
@@ -4091,12 +4141,10 @@ static bool spapr_phb_pre_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
      * This will check that sphb->index doesn't exceed the maximum number of
      * PHBs for the current machine type.
      */
-    return
-        smc->phb_placement(spapr, sphb->index,
-                           &sphb->buid, &sphb->io_win_addr,
-                           &sphb->mem_win_addr, &sphb->mem64_win_addr,
-                           windows_supported, sphb->dma_liobn,
-                           errp);
+    return spapr_phb_placement(spapr, sphb->index,
+                               &sphb->buid, &sphb->io_win_addr,
+                               &sphb->mem_win_addr, &sphb->mem64_win_addr,
+                               windows_supported, sphb->dma_liobn, errp);
 }
 
 static void spapr_phb_plug(HotplugHandler *hotplug_dev, DeviceState *dev)
@@ -4344,57 +4392,6 @@ static const CPUArchIdList *spapr_possible_cpu_arch_ids(MachineState *machine)
     return machine->possible_cpus;
 }
 
-static bool spapr_phb_placement(SpaprMachineState *spapr, uint32_t index,
-                                uint64_t *buid, hwaddr *pio,
-                                hwaddr *mmio32, hwaddr *mmio64,
-                                unsigned n_dma, uint32_t *liobns, Error **errp)
-{
-    /*
-     * New-style PHB window placement.
-     *
-     * Goals: Gives large (1TiB), naturally aligned 64-bit MMIO window
-     * for each PHB, in addition to 2GiB 32-bit MMIO and 64kiB PIO
-     * windows.
-     *
-     * Some guest kernels can't work with MMIO windows above 1<<46
-     * (64TiB), so we place up to 31 PHBs in the area 32TiB..64TiB
-     *
-     * 32TiB..(33TiB+1984kiB) contains the 64kiB PIO windows for each
-     * PHB stacked together.  (32TiB+2GiB)..(32TiB+64GiB) contains the
-     * 2GiB 32-bit MMIO windows for each PHB.  Then 33..64TiB has the
-     * 1TiB 64-bit MMIO windows for each PHB.
-     */
-    const uint64_t base_buid = 0x800000020000000ULL;
-    int i;
-
-    /* Sanity check natural alignments */
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_BASE % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_LIMIT % SPAPR_PCI_MEM64_WIN_SIZE) != 0);
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM64_WIN_SIZE % SPAPR_PCI_MEM32_WIN_SIZE) != 0);
-    QEMU_BUILD_BUG_ON((SPAPR_PCI_MEM32_WIN_SIZE % SPAPR_PCI_IO_WIN_SIZE) != 0);
-    /* Sanity check bounds */
-    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_IO_WIN_SIZE) >
-                      SPAPR_PCI_MEM32_WIN_SIZE);
-    QEMU_BUILD_BUG_ON((SPAPR_MAX_PHBS * SPAPR_PCI_MEM32_WIN_SIZE) >
-                      SPAPR_PCI_MEM64_WIN_SIZE);
-
-    if (index >= SPAPR_MAX_PHBS) {
-        error_setg(errp, "\"index\" for PAPR PHB is too large (max %llu)",
-                   SPAPR_MAX_PHBS - 1);
-        return false;
-    }
-
-    *buid = base_buid + index;
-    for (i = 0; i < n_dma; ++i) {
-        liobns[i] = SPAPR_PCI_LIOBN(index, i);
-    }
-
-    *pio = SPAPR_PCI_BASE + index * SPAPR_PCI_IO_WIN_SIZE;
-    *mmio32 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM32_WIN_SIZE;
-    *mmio64 = SPAPR_PCI_BASE + (index + 1) * SPAPR_PCI_MEM64_WIN_SIZE;
-    return true;
-}
-
 static ICSState *spapr_ics_get(XICSFabric *dev, int irq)
 {
     SpaprMachineState *spapr = SPAPR_MACHINE(dev);
@@ -4605,7 +4602,6 @@ static void spapr_machine_class_init(ObjectClass *oc, const void *data)
     smc->resize_hpt_default = SPAPR_RESIZE_HPT_ENABLED;
     fwc->get_dev_path = spapr_get_fw_dev_path;
     nc->nmi_monitor_handler = spapr_nmi;
-    smc->phb_placement = spapr_phb_placement;
     vhc->cpu_in_nested = spapr_cpu_in_nested;
     vhc->deliver_hv_excp = spapr_exit_nested;
     vhc->hypercall = emulate_spapr_hypercall;
-- 
2.51.0


