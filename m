Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0176D46F67F
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 23:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhLIWMw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 17:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbhLIWMv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 17:12:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651B0C0617A1
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 14:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=P6f35iHkW27bYKrXKVfssYuF4aX8DsMoePwrZGh388Y=; b=QFa5QICMSxxiDRr8Beg7VYfEAv
        p/DL6z6HrvRONhadMeoMETfekFz9AqCkTnmenSpp+Ux4r+8g7TFUvQSQhMnj+vGkjk+A/IAA6S+EE
        XUAN6akFNVm/0Kz118EXnIGBPwgDbSwlo+7RdRQZ5aYwFWzqdK0+mlZLF+Q0KgKAVp3w473P2nZh+
        sxoBBlKKukb+0LR9j5k53fyt8//2JvjC/WNzVLxgCyADH3dEUcUjqfe2HzuKAJGvUgyLrhWKjAfXi
        o1cW6D21kV9tqjLQUKHE9qbQ1kdop9T4k6dJdjcCpheZVJrZCOx5uDo65hAAN9LHlD5Nr5o4dmrQz
        Vj+QKFsw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvRaj-000RNf-B2; Thu, 09 Dec 2021 22:08:50 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvRaj-0003sx-0h; Thu, 09 Dec 2021 22:08:41 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 2/4] intel_iommu: Support IR-only mode without DMA translation
Date:   Thu,  9 Dec 2021 22:08:38 +0000
Message-Id: <20211209220840.14889-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209220840.14889-1-dwmw2@infradead.org>
References: <20211209220840.14889-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

By setting none of the SAGAW bits we can indicate to a guest that DMA
translation isn't supported. Tested by booting Windows 10, as well as
Linux guests with the fix at https://git.kernel.org/torvalds/c/c40aaaac10

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Acked-by: Claudio Fontana <cfontana@suse.de>
---
 hw/i386/intel_iommu.c         | 14 ++++++++++----
 include/hw/i386/intel_iommu.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index f584449d8d..9a3cb2b789 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2202,7 +2202,7 @@ static void vtd_handle_gcmd_write(IntelIOMMUState *s)
     uint32_t changed = status ^ val;
 
     trace_vtd_reg_write_gcmd(status, val);
-    if (changed & VTD_GCMD_TE) {
+    if ((changed & VTD_GCMD_TE) && s->dma_translation) {
         /* Translation enable/disable */
         vtd_handle_gcmd_te(s, val & VTD_GCMD_TE);
     }
@@ -3100,6 +3100,7 @@ static Property vtd_properties[] = {
     DEFINE_PROP_BOOL("caching-mode", IntelIOMMUState, caching_mode, FALSE),
     DEFINE_PROP_BOOL("x-scalable-mode", IntelIOMMUState, scalable_mode, FALSE),
     DEFINE_PROP_BOOL("dma-drain", IntelIOMMUState, dma_drain, true),
+    DEFINE_PROP_BOOL("dma-translation", IntelIOMMUState, dma_translation, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
@@ -3605,12 +3606,17 @@ static void vtd_init(IntelIOMMUState *s)
     s->next_frcd_reg = 0;
     s->cap = VTD_CAP_FRO | VTD_CAP_NFR | VTD_CAP_ND |
              VTD_CAP_MAMV | VTD_CAP_PSI | VTD_CAP_SLLPS |
-             VTD_CAP_SAGAW_39bit | VTD_CAP_MGAW(s->aw_bits);
+             VTD_CAP_MGAW(s->aw_bits);
     if (s->dma_drain) {
         s->cap |= VTD_CAP_DRAIN;
     }
-    if (s->aw_bits == VTD_HOST_AW_48BIT) {
-        s->cap |= VTD_CAP_SAGAW_48bit;
+    if (s->dma_translation) {
+            if (s->aw_bits >= VTD_HOST_AW_39BIT) {
+                    s->cap |= VTD_CAP_SAGAW_39bit;
+            }
+            if (s->aw_bits >= VTD_HOST_AW_48BIT) {
+                    s->cap |= VTD_CAP_SAGAW_48bit;
+            }
     }
     s->ecap = VTD_ECAP_QI | VTD_ECAP_IRO;
 
diff --git a/include/hw/i386/intel_iommu.h b/include/hw/i386/intel_iommu.h
index 41783ee46d..42d6a6a636 100644
--- a/include/hw/i386/intel_iommu.h
+++ b/include/hw/i386/intel_iommu.h
@@ -266,6 +266,7 @@ struct IntelIOMMUState {
     bool buggy_eim;                 /* Force buggy EIM unless eim=off */
     uint8_t aw_bits;                /* Host/IOVA address width (in bits) */
     bool dma_drain;                 /* Whether DMA r/w draining enabled */
+    bool dma_translation;           /* Whether DMA translation supported */
 
     /*
      * Protects IOMMU states in general.  Currently it protects the
-- 
2.31.1

