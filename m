Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373FC3AFA02
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 02:03:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbhFVAFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 20:05:32 -0400
Received: from mail-pg1-f171.google.com ([209.85.215.171]:43541 "EHLO
        mail-pg1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFVAFb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 20:05:31 -0400
Received: by mail-pg1-f171.google.com with SMTP id e22so9303353pgv.10;
        Mon, 21 Jun 2021 17:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kPvPHHqOJHdMhmGWwfRJSkp/uTYoev95TYDhk0HG6a0=;
        b=li1I2GIFBGvIGusaobRdLCufUidsUbgk18cOhYdZnqJZfFI7K+z/xMjG9vQgFCOaYM
         SR2pobabJzfgZ1nlua5pZLlTZRbbxGBL/CGR7qM6pdKN53wG8rv4nsNCb2jLEWwbgyNL
         Fx6Nd9030m0XZWauSVYQOAqxxfW+gU3N97GscVrcuXwuUjhF+hFlZZ9Hqq3bXeM60IZB
         p0sOAqCXdViYIdai2RxLZW88tBY7YI+gLCI3xK5/03moEy/U9mjpzTGkS9yMDiwlDZk1
         6asfhjs0FqiOHEd6I7JU/ktIDHbQoij5d1/d5CydGXY9IUjHbhlhOuRi5tlcYg2HSob5
         SflQ==
X-Gm-Message-State: AOAM531BRN194KjyG4xmLc0cl81VP/MNt5q1qjMkfvnopk5+vH1AqdQU
        zgxos5gbg4yYvFsrcrmxIQE=
X-Google-Smtp-Source: ABdhPJwusuabXNp23P3HhIZ6jO2wGUGtkgCZmg9BDd7MMDOt4n5381fC3wDFdYCo4j8yj8E5n2+1wQ==
X-Received: by 2002:a05:6a00:a1e:b029:303:56b5:414b with SMTP id p30-20020a056a000a1eb029030356b5414bmr759601pfh.48.1624320195786;
        Mon, 21 Jun 2021 17:03:15 -0700 (PDT)
Received: from localhost ([173.239.198.97])
        by smtp.gmail.com with ESMTPSA id m4sm292044pjv.41.2021.06.21.17.03.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 17:03:14 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     bhelgaas@google.com, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org
Cc:     minchan@kernel.org, gregkh@linuxfoundation.org, jeyu@kernel.org,
        ngupta@vflare.org, sergey.senozhatsky.work@gmail.com,
        mcgrof@kernel.org, axboe@kernel.dk, mbenes@suse.com,
        jpoimboe@redhat.com, tglx@linutronix.de, keescook@chromium.org,
        jikos@kernel.org, rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pci: export pci_dev_unlock() and the respective unlock
Date:   Mon, 21 Jun 2021 17:03:09 -0700
Message-Id: <20210622000310.728294-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Other places in the kernel use this form, and so just
provide a common path for it.

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
index 6248e044dd29..c55368f58965 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1353,6 +1353,9 @@ int devm_request_pci_bus_resources(struct device *dev,
 /* Temporary until new and working PCI SBR API in place */
 int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
 
+int pci_dev_trylock(struct pci_dev *dev);
+void pci_dev_unlock(struct pci_dev *dev);
+
 #define pci_bus_for_each_resource(bus, res, i)				\
 	for (i = 0;							\
 	    (res = pci_bus_resource_n(bus, i)) || i < PCI_BRIDGE_RESOURCE_NUM; \
-- 
2.30.2

