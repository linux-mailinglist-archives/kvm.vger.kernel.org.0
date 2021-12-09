Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB6D46F67D
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 23:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232340AbhLIWMg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 17:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbhLIWMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 17:12:36 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF913C0617A1
        for <kvm@vger.kernel.org>; Thu,  9 Dec 2021 14:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=/5Qkoh8pYH5HbNhrnTekBbg9zajs4rUylaVCWNLcGsk=; b=BAsinmt782kleeOm9L/2dn1uZI
        BogZi8zGxKgmuzDQ8eR1ixyoI8wXRrQeO8ZtNPyuuKaeTPl+oHK9OdgGAcugWyLHFoxcFm4IL9MB1
        IpnAOPlv/Hq3e6kO6zhlI/Q2b1A6MHja1zUiNN80YDtjc9gdFF3g6FHbygB4XR6SvnYGx0OdWI0nV
        ErhOVOKhK7ktKLccF+INUtnNKntKiVCPUhCecN3xgGJI73IDC0Br0Jp2h9alg7c2epyVDF9SP7Y5E
        RmLeJIF6IBnRSvCulbySf39JQ6Dx0+FFfP/nfTgwpKzT3/mvfapxyZxbuHudKOn28YkqjFIlzkWrU
        LbaTBUCQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvRai-009loY-Uc; Thu, 09 Dec 2021 22:08:41 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvRaj-0003t5-53; Thu, 09 Dec 2021 22:08:41 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     qemu-devel@nongnu.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 4/4] intel_iommu: Fix irqchip / X2APIC configuration checks
Date:   Thu,  9 Dec 2021 22:08:40 +0000
Message-Id: <20211209220840.14889-4-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209220840.14889-1-dwmw2@infradead.org>
References: <20211209220840.14889-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
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
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/i386/intel_iommu.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index bd288d45bb..0d1c72f08e 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -3760,15 +3760,10 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
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
2.31.1

