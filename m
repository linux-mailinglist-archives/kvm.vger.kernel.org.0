Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A18FB3B11B8
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 04:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhFWCav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 22:30:51 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:41864 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbhFWCat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 22:30:49 -0400
Received: by mail-pg1-f182.google.com with SMTP id u190so471236pgd.8;
        Tue, 22 Jun 2021 19:28:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LBQrvoFPocMJkFcQu4BsnarGUiW1t6Ipw95ekgoHgGs=;
        b=SkJWv3S+iXzq2Yhpn15SZlFSftfoxGcUGtTzF1WtVgYJOlJtwZt2CeXwwuP+tv14lg
         RwSwkyLmEG3/0WA6+NvveScef0+lP0bxIKGpSfqEENTGlSg48FCYoCr3iL9T2VFXsU6V
         +LZrc0rWP3bCOOCK2kBy6iqtMv5cd7iGzB0U/W6sjsxQ1aNw2bRHpiaEyK3AahEybzuF
         2jlFZkg2fYMibWP1JaDw9YAEHwgbMsiNR7p0hfWJXRSrN1JpYBkyM1AC5TbVEDpTz2Bc
         +GOnyp+ry3tG4+yzCh3M9C06UNvbeE46KIR9b5fsrOwsZEbBaX/KwoP98UIPw58cU8I+
         nMww==
X-Gm-Message-State: AOAM5310uMPXdAD7Jk+ag+J2NzqJUysNRi5cg/5vWr6Dw+fZJrDFHdRt
        MstdAniyrruLBSivFAc4gAE=
X-Google-Smtp-Source: ABdhPJyTm1u9FtJlYn57k29Q04An5rIzOg0bXZ0j2tbvleo5R+VQGN1/s++L2RcaYzo/rM5PQOhl0Q==
X-Received: by 2002:a65:4608:: with SMTP id v8mr1546154pgq.269.1624415311647;
        Tue, 22 Jun 2021 19:28:31 -0700 (PDT)
Received: from localhost ([173.239.198.97])
        by smtp.gmail.com with ESMTPSA id c18sm20578436pgf.66.2021.06.22.19.28.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 19:28:30 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     bhelgaas@google.com, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        schnelle@linux.ibm.com
Cc:     minchan@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, mcgrof@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] PCI: Export pci_dev_trylock() and pci_dev_unlock()
Date:   Tue, 22 Jun 2021 19:28:23 -0700
Message-Id: <20210623022824.308041-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623022824.308041-1-mcgrof@kernel.org>
References: <20210623022824.308041-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Other places in the kernel use this form, and so just
provide a common path for it.

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/pci/pci.c   | 6 ++++--
 include/linux/pci.h | 3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index f09821af1d2e..b1d9bb3f5ae2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -5027,7 +5027,7 @@ static void pci_dev_lock(struct pci_dev *dev)
 }
 
 /* Return 1 on successful lock, 0 on contention */
-static int pci_dev_trylock(struct pci_dev *dev)
+int pci_dev_trylock(struct pci_dev *dev)
 {
 	if (pci_cfg_access_trylock(dev)) {
 		if (device_trylock(&dev->dev))
@@ -5037,12 +5037,14 @@ static int pci_dev_trylock(struct pci_dev *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(pci_dev_trylock);
 
-static void pci_dev_unlock(struct pci_dev *dev)
+void pci_dev_unlock(struct pci_dev *dev)
 {
 	device_unlock(&dev->dev);
 	pci_cfg_access_unlock(dev);
 }
+EXPORT_SYMBOL_GPL(pci_dev_unlock);
 
 static void pci_dev_save_and_disable(struct pci_dev *dev)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 6248e044dd29..d8f056f3a2e3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1622,6 +1622,9 @@ void pci_cfg_access_lock(struct pci_dev *dev);
 bool pci_cfg_access_trylock(struct pci_dev *dev);
 void pci_cfg_access_unlock(struct pci_dev *dev);
 
+int pci_dev_trylock(struct pci_dev *dev);
+void pci_dev_unlock(struct pci_dev *dev);
+
 /*
  * PCI domain support.  Sometimes called PCI segment (eg by ACPI),
  * a PCI domain is defined to be a set of PCI buses which share
-- 
2.30.2

