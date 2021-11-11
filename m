Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B661044D645
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 13:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbhKKMFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Nov 2021 07:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhKKMFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Nov 2021 07:05:40 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87335C061766
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 04:02:51 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id u18so9403409wrg.5
        for <kvm@vger.kernel.org>; Thu, 11 Nov 2021 04:02:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7m+OpQtxzW/txd8CCI8RgHsDlwT0VoSBD46AL8PSlZk=;
        b=i6koRGKJM92uFr+BYasecYTBAxI0pas7Ia+FXRdhox67EnUwgr1PWMuOrD8n5Kbvfy
         hwNjJ8YQxA5c/sHSflfopF+JP2EcajUuOtN6v2PlL4+/cl+yEPu1YCrkIu1pVMRdop/n
         FcZeBFRvzUxZ9nkl7Kdpvp11d+UnjtMeJGGwbyKyLmjkFSolAj7VZiA7MlDDOx/k8piE
         DOy9Sjy0AfNBeNmtW/hWvnb7/DPgzbDn/t5Vbx8uP1i13kPYzx/mmsKinlCaczRmB8ZD
         g7afiM78PaZyEWvQp4XxDyuhEy/nBgpFEGJ4X/b2m9jJh4zvXlh5IAJ6WxnSdQDwLPdV
         /u5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7m+OpQtxzW/txd8CCI8RgHsDlwT0VoSBD46AL8PSlZk=;
        b=QsgnO1pp7Z+fen9czGMToflmlE5/Vb88/cTTyl7dsumkoRYvJtLmO2IUGB94VJEst6
         j6/0oOTgFRqNcr5WZmeEsk/RnmBTzidTV6b+DUTZn4/EzDv8m0wA3xueR6eF2vGdXfVX
         Q8Zv/FoLgqLLXGK/EIGAt4cTYQz98RrsJr3Tnl/MGsxHH4wtLo2GqrpMTTHldHGYLYmc
         pjyZi5XUwn52RnEHXwrP0e9s3NvjlqChme4DayADXgBHBoYfN5kfviDzeK1v2D9dqu2K
         HPc2sLTQewv2plRrduFZAQaQIQHX1otA5SPWv0gfu5jxDemte5MND6VuC9bS44dwms9w
         y1og==
X-Gm-Message-State: AOAM533p95Za9HGWWu5/s8JmvJedX2zIkOqALSU2fyA9yOLfhXGBlAWz
        G+1IRur+KYAOp0APY8JSIiY=
X-Google-Smtp-Source: ABdhPJxO37kDr7wXdQxlByzxI0iiYviHup6/27ELDK8SJ+fLvfoaSO/IB22TPkGvuqJg2UbH30LQWg==
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr8256765wrd.420.1636632169751;
        Thu, 11 Nov 2021 04:02:49 -0800 (PST)
Received: from localhost.localdomain (cpc92698-cmbg18-2-0-cust123.5-4.cable.virginm.net. [82.30.113.124])
        by smtp.gmail.com with ESMTPSA id o4sm10778343wmq.31.2021.11.11.04.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:02:49 -0800 (PST)
From:   Sathyam Panda <panda.sathyam9@gmail.com>
X-Google-Original-From: Sathyam Panda <sathyam.panda@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        jean-philippe@linaro.org, vivek.gautam@arm.com,
        sathyam.panda@arm.com
Subject: [PATCH kvmtool RESENT] arm/pci: update interrupt-map only for legacy interrupts
Date:   Thu, 11 Nov 2021 12:02:31 +0000
Message-Id: <20211111120231.5468-1-sathyam.panda@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The interrupt pin cell in "interrupt-map" property
is defined only for legacy interrupts with a valid
range in [1-4] corrspoding to INTA#..INTD#. And the
PCI endpoint devices that support advance interrupt
mechanism like MSI or MSI-X should not have an entry
with value 0 in "interrupt-map". This patch takes
care of this problem by avoiding redundant entries.

Signed-off-by: Sathyam Panda <sathyam.panda@arm.com>
Reviewed-by: Vivek Kumar Gautam <vivek.gautam@arm.com>
---
 arm/pci.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arm/pci.c b/arm/pci.c
index 2251f62..e44e453 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -80,6 +80,16 @@ void pci__generate_fdt_nodes(void *fdt)
 		u8 irq = pci_hdr->irq_line;
 		u32 irq_flags = pci_hdr->irq_type;
 
+		/*
+		 * Avoid adding entries in "interrupt-map" for devices that
+		 * will be using advance interrupt mechanisms like MSI or
+		 * MSI-X instead of legacy interrupt pins INTA#..INTD#
+		 */
+		if (pin == 0) {
+			dev_hdr = device__next_dev(dev_hdr);
+			continue;
+		}
+
 		*entry = (struct of_interrupt_map_entry) {
 			.pci_irq_mask = {
 				.pci_addr = {
-- 
2.25.1

