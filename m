Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACEDF165E29
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgBTNGG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33098 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728114AbgBTNGF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JJNOlxhz3YaDnBzT0LwFaaq/SOy/0tsQ/KrZZBdtHoE=;
        b=Y6RpI0xcRZrTEKai7CZeblPtb3EmoD464k8GgDfsXisL2G5s422AwB1AfhfduqOyUdPwzy
        Qg8RWQYYVqy12EefFThVfREF6feSBAN+tCstcGGQxvVNPLzRbTaoQP+j+AvGWKzsEficL+
        eVynyR/NP1vg0r70dqvCwFV/6PF23rA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-411-UaOXaiRvPSu9JNCLFxldug-1; Thu, 20 Feb 2020 08:06:02 -0500
X-MC-Unique: UaOXaiRvPSu9JNCLFxldug-1
Received: by mail-wm1-f71.google.com with SMTP id b205so806416wmh.2
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:06:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JJNOlxhz3YaDnBzT0LwFaaq/SOy/0tsQ/KrZZBdtHoE=;
        b=rQVg/+wkPpCZENhNonxFW5IKS4LXGdQtiHlGviu78oUvncb6H77Duw3ZCWqFMtm366
         BzSZtMWCo3Q4+XMw3lpdzlpY7zT3M6+Cme7dr7bgcXxPET/VOjcnV7bSmeXwthCe+EIP
         zDSDRjHKMF57LfVPUTreJvVv8V9oqBNj+vaVoQksUppTdOj2eR7DUqmLEy54WcPjaNzB
         /g2pGA0txXCvvz5LthDLQEH0XkiBBtMjOEOdjtfQ2BE+fxd0VpTKZ1vtX58hUr3A5Y59
         /McXeOGB3zkBwipeirVVhJzuzEDMBcvkG8/g384eRSVMSIhXJbNgu4spL1n0/MjiUXpF
         eeXg==
X-Gm-Message-State: APjAAAVx68s8Dm/oAg4spGUGoVkVsBAnkUXyYErNV50SIhliutlBkJXR
        8YmJcln70Sipjre8NAdDTtHwI/9vi0saD7mrZcNPqID/tf+vJNkhFrsaaz9yUNStgWGxhaF2OrI
        fvCQa0hZT5itq
X-Received: by 2002:a7b:c1d0:: with SMTP id a16mr4485847wmj.175.1582203961576;
        Thu, 20 Feb 2020 05:06:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8KNQ719hweoepCwU/16r5sB1wpPqBKHDZc0xAJklXBupLNm7eWc89eDGk1e864X9IS4bitQ==
X-Received: by 2002:a7b:c1d0:: with SMTP id a16mr4485824wmj.175.1582203961311;
        Thu, 20 Feb 2020 05:06:01 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:06:00 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 02/20] hw: Remove unnecessary cast when calling dma_memory_read()
Date:   Thu, 20 Feb 2020 14:05:30 +0100
Message-Id: <20200220130548.29974-3-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since its introduction in commit d86a77f8abb, dma_memory_read()
always accepted void pointer argument. Remove the unnecessary
casts.

This commit was produced with the included Coccinelle script
scripts/coccinelle/exec_rw_const.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/coccinelle/exec_rw_const.cocci | 15 +++++++++++++++
 hw/arm/smmu-common.c                   |  3 +--
 hw/arm/smmuv3.c                        | 10 ++++------
 hw/sd/sdhci.c                          | 15 +++++----------
 4 files changed, 25 insertions(+), 18 deletions(-)
 create mode 100644 scripts/coccinelle/exec_rw_const.cocci

diff --git a/scripts/coccinelle/exec_rw_const.cocci b/scripts/coccinelle/exec_rw_const.cocci
new file mode 100644
index 0000000000..a0054f009d
--- /dev/null
+++ b/scripts/coccinelle/exec_rw_const.cocci
@@ -0,0 +1,15 @@
+// Usage:
+//  spatch --sp-file scripts/coccinelle/exec_rw_const.cocci --dir . --in-place
+
+// Remove useless cast
+@@
+expression E1, E2, E3, E4;
+type T;
+@@
+(
+- dma_memory_read(E1, E2, (T *)E3, E4)
++ dma_memory_read(E1, E2, E3, E4)
+|
+- dma_memory_write(E1, E2, (T *)E3, E4)
++ dma_memory_write(E1, E2, E3, E4)
+)
diff --git a/hw/arm/smmu-common.c b/hw/arm/smmu-common.c
index 23eb117041..0f2573f004 100644
--- a/hw/arm/smmu-common.c
+++ b/hw/arm/smmu-common.c
@@ -74,8 +74,7 @@ static int get_pte(dma_addr_t baseaddr, uint32_t index, uint64_t *pte,
     dma_addr_t addr = baseaddr + index * sizeof(*pte);
 
     /* TODO: guarantee 64-bit single-copy atomicity */
-    ret = dma_memory_read(&address_space_memory, addr,
-                          (uint8_t *)pte, sizeof(*pte));
+    ret = dma_memory_read(&address_space_memory, addr, pte, sizeof(*pte));
 
     if (ret != MEMTX_OK) {
         info->type = SMMU_PTW_ERR_WALK_EABT;
diff --git a/hw/arm/smmuv3.c b/hw/arm/smmuv3.c
index 8b5f157dc7..57a79df55b 100644
--- a/hw/arm/smmuv3.c
+++ b/hw/arm/smmuv3.c
@@ -279,8 +279,7 @@ static int smmu_get_ste(SMMUv3State *s, dma_addr_t addr, STE *buf,
 
     trace_smmuv3_get_ste(addr);
     /* TODO: guarantee 64-bit single-copy atomicity */
-    ret = dma_memory_read(&address_space_memory, addr,
-                          (void *)buf, sizeof(*buf));
+    ret = dma_memory_read(&address_space_memory, addr, buf, sizeof(*buf));
     if (ret != MEMTX_OK) {
         qemu_log_mask(LOG_GUEST_ERROR,
                       "Cannot fetch pte at address=0x%"PRIx64"\n", addr);
@@ -301,8 +300,7 @@ static int smmu_get_cd(SMMUv3State *s, STE *ste, uint32_t ssid,
 
     trace_smmuv3_get_cd(addr);
     /* TODO: guarantee 64-bit single-copy atomicity */
-    ret = dma_memory_read(&address_space_memory, addr,
-                           (void *)buf, sizeof(*buf));
+    ret = dma_memory_read(&address_space_memory, addr, buf, sizeof(*buf));
     if (ret != MEMTX_OK) {
         qemu_log_mask(LOG_GUEST_ERROR,
                       "Cannot fetch pte at address=0x%"PRIx64"\n", addr);
@@ -406,8 +404,8 @@ static int smmu_find_ste(SMMUv3State *s, uint32_t sid, STE *ste,
         l2_ste_offset = sid & ((1 << s->sid_split) - 1);
         l1ptr = (dma_addr_t)(strtab_base + l1_ste_offset * sizeof(l1std));
         /* TODO: guarantee 64-bit single-copy atomicity */
-        ret = dma_memory_read(&address_space_memory, l1ptr,
-                              (uint8_t *)&l1std, sizeof(l1std));
+        ret = dma_memory_read(&address_space_memory, l1ptr, &l1std,
+                              sizeof(l1std));
         if (ret != MEMTX_OK) {
             qemu_log_mask(LOG_GUEST_ERROR,
                           "Could not read L1PTR at 0X%"PRIx64"\n", l1ptr);
diff --git a/hw/sd/sdhci.c b/hw/sd/sdhci.c
index 69dc3e6b90..d5abdaad41 100644
--- a/hw/sd/sdhci.c
+++ b/hw/sd/sdhci.c
@@ -701,8 +701,7 @@ static void get_adma_description(SDHCIState *s, ADMADescr *dscr)
     hwaddr entry_addr = (hwaddr)s->admasysaddr;
     switch (SDHC_DMA_TYPE(s->hostctl1)) {
     case SDHC_CTRL_ADMA2_32:
-        dma_memory_read(s->dma_as, entry_addr, (uint8_t *)&adma2,
-                        sizeof(adma2));
+        dma_memory_read(s->dma_as, entry_addr, &adma2, sizeof(adma2));
         adma2 = le64_to_cpu(adma2);
         /* The spec does not specify endianness of descriptor table.
          * We currently assume that it is LE.
@@ -713,8 +712,7 @@ static void get_adma_description(SDHCIState *s, ADMADescr *dscr)
         dscr->incr = 8;
         break;
     case SDHC_CTRL_ADMA1_32:
-        dma_memory_read(s->dma_as, entry_addr, (uint8_t *)&adma1,
-                        sizeof(adma1));
+        dma_memory_read(s->dma_as, entry_addr, &adma1, sizeof(adma1));
         adma1 = le32_to_cpu(adma1);
         dscr->addr = (hwaddr)(adma1 & 0xFFFFF000);
         dscr->attr = (uint8_t)extract32(adma1, 0, 7);
@@ -726,13 +724,10 @@ static void get_adma_description(SDHCIState *s, ADMADescr *dscr)
         }
         break;
     case SDHC_CTRL_ADMA2_64:
-        dma_memory_read(s->dma_as, entry_addr,
-                        (uint8_t *)(&dscr->attr), 1);
-        dma_memory_read(s->dma_as, entry_addr + 2,
-                        (uint8_t *)(&dscr->length), 2);
+        dma_memory_read(s->dma_as, entry_addr, (&dscr->attr), 1);
+        dma_memory_read(s->dma_as, entry_addr + 2, (&dscr->length), 2);
         dscr->length = le16_to_cpu(dscr->length);
-        dma_memory_read(s->dma_as, entry_addr + 4,
-                        (uint8_t *)(&dscr->addr), 8);
+        dma_memory_read(s->dma_as, entry_addr + 4, (&dscr->addr), 8);
         dscr->addr = le64_to_cpu(dscr->addr);
         dscr->attr &= (uint8_t) ~0xC0;
         dscr->incr = 12;
-- 
2.21.1

