Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D723D4D86EB
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 15:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234872AbiCNO1O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233894AbiCNO1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 10:27:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABE036E1C
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 07:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bHAchC0+iNjy4eEX6Icd7ira7yPt3JmQnXnO4S53bdQ=; b=XDz59F+qwUk/bBNEAoIBT35/O3
        NAr/u+ffFuMiPj7DvI7CM7/LXgoBzRS2EcfdvGA8U9OndnyRHdX+pZSHq4yATDCyMZA7oDwLaNUis
        c/ig+O/LKRnyoWNfBEBfiMD5ARgczxI7iEwdJF3/L/gAJJ/oTefD8AoWLB+7pDOFYG8ObBvJ0Aiwi
        D1kehFJPRZslUNZ6d9FHg0K+5Roe4bs3Uk0uytqQvKm5V94WxBsHTzT8dEHj+Q6HFcaOdMbIlOt7J
        Yu74kbMM6wuazRsE71SfUqQGq68/5VIO/7mFK7vLeLApw5DsxbIMtHOxFsXhP/hAPnMz7G7t2zybr
        i7xBmP5A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nTldp-0047Z9-A5; Mon, 14 Mar 2022 14:25:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nTldo-000dAd-MB; Mon, 14 Mar 2022 14:25:44 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Subject: [PATCH 4/4] intel_iommu: Fix irqchip / X2APIC configuration checks
Date:   Mon, 14 Mar 2022 14:25:44 +0000
Message-Id: <20220314142544.150555-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220314142544.150555-1-dwmw2@infradead.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't need to check kvm_enable_x2apic(). It's perfectly OK to support
interrupt remapping even if we can't address CPUs above 254. Kind of
pointless, but still functional.

The check on kvm_enable_x2apic() needs to happen *anyway* in order to
allow CPUs above 254 even without an IOMMU, so allow that to happen
elsewhere.

However, we do require the *split* irqchip in order to rewrite I/OAPIC
destinations. So fix that check while we're here.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Acked-by: Claudio Fontana <cfontana@suse.de>
---
 hw/i386/intel_iommu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index e32cb933bd..1cc64b0efc 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3786,15 +3786,10 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
                                               ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
     }
     if (s->intr_eim == ON_OFF_AUTO_ON && !s->buggy_eim) {
-        if (!kvm_irqchip_in_kernel()) {
+        if (!kvm_irqchip_is_split()) {
             error_setg(errp, "eim=on requires accel=kvm,kernel-irqchip=split");
             return false;
         }
-        if (!kvm_enable_x2apic()) {
-            error_setg(errp, "eim=on requires support on the KVM side"
-                             "(X2APIC_API, first shipped in v4.7)");
-            return false;
-        }
     }
 
     /* Currently only address widths supported are 39 and 48 bits */
-- 
2.33.1

