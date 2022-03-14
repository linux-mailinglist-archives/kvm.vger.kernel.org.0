Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356534D86EE
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 15:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239001AbiCNO1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 10:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiCNO1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 10:27:14 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB3F36E1B
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 07:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=sZZuFpI4exz793Oyalsxftvzu/Zwg8HQxGOOUixySZQ=; b=Ln4NI7HEM5jHy45UM4eaiWZTWr
        EANhaG4L3313pRC6xFJH/mkCzQeA3jfExVZQmFV+LwGqmra4ADF4igtOliSozFRVxyFGw6lYqPAJG
        GkmSBzEuli2zt8A7iF3tVj4e6GtdIB1nNCkjXOKbSvAlidLdeyX7+FwsUIysyBr9VfCK7TCmOvm6K
        p5m/lxbV1ZkCmorLLF1EpmtqAfZLdKlXlhnl1ZTCyUdW/ijvVTifKy4DrQw4szrOjEzCm1gSmbm6m
        WE6q997eCkntrb4ow0wxJVQlBVqbCzsR7BrD2DUD+wmQr2jhDCgAkwK256L+hJyayc4ADZ9aoc4Br
        XbFRhguA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nTldp-000rjR-Bi; Mon, 14 Mar 2022 14:25:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nTldo-000dAa-La; Mon, 14 Mar 2022 14:25:44 +0000
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
Subject: [PATCH 3/4] intel_iommu: Only allow interrupt remapping to be enabled if it's supported
Date:   Mon, 14 Mar 2022 14:25:43 +0000
Message-Id: <20220314142544.150555-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220314142544.150555-1-dwmw2@infradead.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

We should probably check if we were meant to be exposing IR, before
letting the guest turn the IRE bit on.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 hw/i386/intel_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 948c653e74..e32cb933bd 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -2209,6 +2209,7 @@ static void vtd_handle_gcmd_ire(IntelIOMMUState *s, bool en)
 /* Handle write to Global Command Register */
 static void vtd_handle_gcmd_write(IntelIOMMUState *s)
 {
+    X86IOMMUState *x86_iommu = X86_IOMMU_DEVICE(s);
     uint32_t status = vtd_get_long_raw(s, DMAR_GSTS_REG);
     uint32_t val = vtd_get_long_raw(s, DMAR_GCMD_REG);
     uint32_t changed = status ^ val;
@@ -2230,7 +2231,8 @@ static void vtd_handle_gcmd_write(IntelIOMMUState *s)
         /* Set/update the interrupt remapping root-table pointer */
         vtd_handle_gcmd_sirtp(s);
     }
-    if (changed & VTD_GCMD_IRE) {
+    if ((changed & VTD_GCMD_IRE) &&
+        x86_iommu_ir_supported(x86_iommu)) {
         /* Interrupt remap enable/disable */
         vtd_handle_gcmd_ire(s, val & VTD_GCMD_IRE);
     }
-- 
2.33.1

