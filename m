Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5008F297F3C
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764686AbgJXVfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764654AbgJXVfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2A9C0613D6;
        Sat, 24 Oct 2020 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=JIXIY3GAyntKqPeZa3MAlKhd1UW1TXMA9oFv8e4M/GQ=; b=MEjgRucK7MhV9F/E1x5IPQpfVf
        hVM9Zs7V1GvmQ9EL/yAHBVjgegMtvk+QzXrMHancjq/aqxzqNpSKYufarYG3zKWeUUUI6VD2XbhSu
        5hTnEyezWLQU8rjS3CA0/AX4Y6yOCqBHGHnb6z271Ph13K0V05B9lIc0381J1Tnpf99/FR6OY0CwZ
        ydbQMeEJu7mzG9SI/gE0jldeW9aIm8LQx7aMALyjyIGEhNfAUZpZiBkTvsCfN334wBGUfBoG7BpP9
        JvDgLYQTLHj0sCTLd5coQ81CSf/YodwhP7FGWG9yLvdGJ5PnwPk6Rznu8ExVCFFVLTTVDQSPrKXn2
        suq6f54Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCN-0006Gg-Vu; Sat, 24 Oct 2020 21:35:41 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPi-GD; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 33/35] iommu/hyper-v: Disable IRQ pseudo-remapping if 15 bit APIC IDs are available
Date:   Sat, 24 Oct 2020 22:35:33 +0100
Message-Id: <20201024213535.443185-34-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

If the 15-bit APIC ID support is present in emulated MSI then there's no
need for the pseudo-remapping support.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/iommu/hyperv-iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index a629a6be65c7..9438daa24fdb 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -121,6 +121,7 @@ static int __init hyperv_prepare_irq_remapping(void)
 	int i;
 
 	if (!hypervisor_is_type(X86_HYPER_MS_HYPERV) ||
+	    x86_init.hyper.msi_ext_dest_id() ||
 	    !x2apic_supported())
 		return -ENODEV;
 
-- 
2.26.2

