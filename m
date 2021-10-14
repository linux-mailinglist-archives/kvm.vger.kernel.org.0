Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430A142D69B
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 11:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhJNKAb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 06:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbhJNKAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 06:00:30 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0202FC061570;
        Thu, 14 Oct 2021 02:58:26 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so6521623pjc.3;
        Thu, 14 Oct 2021 02:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7oaee+4oXg8HKCv9PzcF0QIAtHVH0NEu6qYXRmh9b7E=;
        b=SYT3ed+Kz4WckqM1sdzgCokwg940ETQPZayiRvNZNuxLmq9tIMS0KlpJHvzxURHvF8
         SuGEOR8eZpBIkLiP1RzZHIAE8e4OHMHFaAKngIH/FZz/eogqpBBS7fGQsOeeakWVy402
         hXVWXk3tlf+cxQpDFxSvoKCGGTMquePZU+fvNST57OE8D+kpHtMRlgqBo4mtR+em0lvH
         4ki00TI11LY4vfRQkYQwtrw5LLXkg7HppWdxAoPVvUqbKPf2KuO+uwBesRxAP0WXljwc
         bOzFPAMxqkYpZNgSyUYVzmK4ElfmAoR5JHx29JLYkNeeqakmDvggJ/gIsRdSj9a7kppb
         THbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7oaee+4oXg8HKCv9PzcF0QIAtHVH0NEu6qYXRmh9b7E=;
        b=47Sub2eRAvsi033oh8bpdkwABV1hLC9ckxvXApTVjd6gnOy7Nk2awPr5Z5qOhXxH32
         MQwCZmz+4taqH36nNerfkaPNKopw0uPEEViIDw87WjwXlyeUIQeGyBaHPyd3eibI3eiJ
         ykBJKBmuOyXi0K5sFA6yNR77PXRr02dM5EVucDWmTDqCYxXXvimrhBOsC89ye7afvXxq
         rryX5BnKmsbw+FEGaqKWEoTpBs5ikg/1dHu+OrZp2Qs5s7InqHXUbLhYxaVSiCXKMS2G
         33Ir61Xng/x8DS0EUXit3bSBQCFLZV/6HKtl05haF5lJ2vdFx1Sr6Aw9DHr+Yv44ZOZV
         gaRA==
X-Gm-Message-State: AOAM532fletkB2IXqsPvWQQbPVkMQQgXgBT+n0Mh/4k7fbjsP1xdtUEX
        HWGmzmyU2fMvwMWDS6Oh0u5oc+03ddbndg==
X-Google-Smtp-Source: ABdhPJw72G2WanonNLSptbeZnKFwjyD1IiMloGP9Teb6H/jy+fy3maiOi+RWy6kdTz/K97d05wxcHA==
X-Received: by 2002:a17:90b:1049:: with SMTP id gq9mr16087657pjb.180.1634205505581;
        Thu, 14 Oct 2021 02:58:25 -0700 (PDT)
Received: from localhost.localdomain (5e.8a.38a9.ip4.static.sl-reverse.com. [169.56.138.94])
        by smtp.gmail.com with ESMTPSA id k127sm2080664pfd.1.2021.10.14.02.58.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Oct 2021 02:58:25 -0700 (PDT)
From:   Zhenguo Yao <yaozhenguo1@gmail.com>
To:     bhelgaas@google.com, alex.williamson@redhat.com
Cc:     cohuck@redhat.com, jgg@ziepe.ca, mgurtovoy@nvidia.com,
        yishaih@nvidia.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaozhenguo@jd.com,
        Zhenguo Yao <yaozhenguo1@gmail.com>
Subject: [PATCH v1 1/2] PCI: Add ignore_reset sysfs interface to control whether to do device reset in PCI drivers
Date:   Thu, 14 Oct 2021 17:57:47 +0800
Message-Id: <20211014095748.84604-2-yaozhenguo1@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211014095748.84604-1-yaozhenguo1@gmail.com>
References: <20211014095748.84604-1-yaozhenguo1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some PCI devices can't do device reset in enable and disable operations.
So, and ignore_reset sysfs interface to ignore reset in those operations.
For example:

echo 1 > /sys/bus/pci/xxxx/ignore_reset

PCI drivers can ignore reset for this device based on ignore_reset.

Signed-off-by: Zhenguo Yao <yaozhenguo1@gmail.com>
---
 drivers/pci/pci-sysfs.c | 25 +++++++++++++++++++++++++
 include/linux/pci.h     |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 7fb5cd17cc98..c2fa2ed3ae55 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -255,6 +255,30 @@ static ssize_t ari_enabled_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(ari_enabled);
 
+static ssize_t ignore_reset_show(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	struct pci_dev *pci_dev = to_pci_dev(dev);
+
+	return sprintf(buf, "%u\n", pci_dev->ignore_reset);
+}
+static ssize_t ignore_reset_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	pdev->ignore_reset = !!val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(ignore_reset);
+
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -618,6 +642,7 @@ static struct attribute *pci_dev_attrs[] = {
 #endif
 	&dev_attr_driver_override.attr,
 	&dev_attr_ari_enabled.attr,
+	&dev_attr_ignore_reset.attr,
 	NULL,
 };
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index cd8aa6fce204..ac026acd4572 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -508,6 +508,7 @@ struct pci_dev {
 
 	/* These methods index pci_reset_fn_methods[] */
 	u8 reset_methods[PCI_NUM_RESET_METHODS]; /* In priority order */
+	u8 ignore_reset; /* ignore reset control in driver */
 };
 
 static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
-- 
2.27.0

