Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507213AFA05
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 02:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhFVAFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Jun 2021 20:05:35 -0400
Received: from mail-pj1-f43.google.com ([209.85.216.43]:44756 "EHLO
        mail-pj1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFVAFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Jun 2021 20:05:35 -0400
Received: by mail-pj1-f43.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so1057889pjo.3;
        Mon, 21 Jun 2021 17:03:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gwx1ZCzIHLcluKpzR6wn6tTFWmEGPnbN9lvDpuT4Ci8=;
        b=K5wn6QmBf0KaTQxNHoHvvpbi+MeBjgTHoJFqxw7tNmJepkHfOTaEOkZh8g5Y0eE9mh
         AwrcIEpVXllNYn7qitn8/ED00sNpjxKEGsx0PtlEnKiAFmYpgbCsM7LxSOFbwvDlEpuf
         PqSlwz7o04VTYu72UXnFm3UKhxIlidqJYtnRSzn5r5G1lelHI4akkI+EgCbRJjxm57cY
         fCT3VlNJpxU7CJTLYe3RJN+FGFXjlRUUMOXyqpZPW1E58IptvgpSNFUzbfFWjWcZwxJp
         P9ZC1Ew9XoS9nn6T2XR2UdBaV0Q+EHQgW67LifieNuIUmbvcYlYVDlxFC5rve9vfVANv
         PaQw==
X-Gm-Message-State: AOAM531IdsHVxRHszwe8AomaRUi8bbWYzpPT62aCCNYj4miVEh7xITT/
        MskPWUG4ajbUxrQKjE32szY=
X-Google-Smtp-Source: ABdhPJwJXA/z/L/6sTK1XoGq6CelorG3QsRkOMPQt2w54jrHngmv2vQzfn+HgNf2ECThlwWPiBTTHA==
X-Received: by 2002:a17:90a:7f8c:: with SMTP id m12mr815076pjl.109.1624320199153;
        Mon, 21 Jun 2021 17:03:19 -0700 (PDT)
Received: from localhost ([173.239.198.97])
        by smtp.gmail.com with ESMTPSA id z6sm13498332pfj.117.2021.06.21.17.03.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 17:03:18 -0700 (PDT)
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
Subject: [PATCH 2/2] vfio: use the new pci_dev_trylock() helper to simplify try lock
Date:   Mon, 21 Jun 2021 17:03:10 -0700
Message-Id: <20210622000310.728294-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210622000310.728294-1-mcgrof@kernel.org>
References: <20210622000310.728294-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the new pci_dev_trylock() helper to simplify our locking.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/vfio/pci/vfio_pci.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index bd7c482c948a..02b05f7b9a91 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -477,13 +477,10 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	 * We can not use the "try" reset interface here, which will
 	 * overwrite the previously restored configuration information.
 	 */
-	if (vdev->reset_works && pci_cfg_access_trylock(pdev)) {
-		if (device_trylock(&pdev->dev)) {
-			if (!__pci_reset_function_locked(pdev))
-				vdev->needs_reset = false;
-			device_unlock(&pdev->dev);
-		}
-		pci_cfg_access_unlock(pdev);
+	if (vdev->reset_works && pci_dev_trylock(pdev)) {
+		if (!__pci_reset_function_locked(pdev))
+			vdev->needs_reset = false;
+		pci_dev_unlock(pdev);
 	}
 
 	pci_restore_state(pdev);
-- 
2.30.2

