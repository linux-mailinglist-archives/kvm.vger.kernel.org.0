Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4782949DD
	for <lists+kvm@lfdr.de>; Wed, 21 Oct 2020 10:58:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502371AbgJUI6R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Oct 2020 04:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502316AbgJUI5V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Oct 2020 04:57:21 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C7C0613CF
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 01:57:21 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id n6so2011228wrm.13
        for <kvm@vger.kernel.org>; Wed, 21 Oct 2020 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7XJE+hSH/S5sf+J2AcmYCFMIcTxnQzpOZqEdbmMuzFE=;
        b=GUK8bAu/rOwhstjfCCL4jyz79EWKlxKCEPzbQk67yqQgL5JdMMK9qYFAwYpDisTw7I
         i418204vlPkRGtUhsDK0/5TGt4bPzoR91GVgS9OWMA2nj4HmDeVE9XWPk7FPp7l7XoFa
         ZYmkpZjMTP6Ea3nY9tfKU2e09YncWgauHxbSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7XJE+hSH/S5sf+J2AcmYCFMIcTxnQzpOZqEdbmMuzFE=;
        b=dnMVjSGXufDUrtLYX+rBB0ttO7+4V3WewqYlG8xtbQS9REJi4gpP5E7HqMOZrzTQPE
         zDGSb2LJ8QFaxRVDaNxcLz0b0xfhMwaFSIzAuRX0x5n1IkSLPwLl9bsNhV4PvObogAnR
         Ck/uAn7nCauX67sg4Dc2art8Z4FHEXMLkkqdMcrVw6heWM54VhBiAIJA9Cg9JZwzJbpI
         fjTCEP307Pdh/iHV/2tnbTRyGPgJzI/hiHFhvwCGHqze+8HcMpwr3101QJ+4vk4h1BXw
         G/jzWUVYAuEoA5gcfHkEcM8LQFcd16rjNj7vv7f0j+AWjxPNEaWXpDji+fpUx4Woqaat
         oBSQ==
X-Gm-Message-State: AOAM531ywLW7tnngOnLqMGXnO/ZnHXFyKQ27K4RzxbOnNzcBG1AxsYXS
        iNL2dSrohadl5BFlp8rczsfLyQ==
X-Google-Smtp-Source: ABdhPJx37Cjmlb4fgq/grqKCCp37y8t5Mz28eOZMNIB2vWtdgu/4b448hmjy5S8hmkcygKAt/hypYw==
X-Received: by 2002:a5d:5009:: with SMTP id e9mr3539688wrt.104.1603270640046;
        Wed, 21 Oct 2020 01:57:20 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q8sm2675939wro.32.2020.10.21.01.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 01:57:19 -0700 (PDT)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.com>
Subject: [PATCH v3 12/16] PCI: Obey iomem restrictions for procfs mmap
Date:   Wed, 21 Oct 2020 10:56:51 +0200
Message-Id: <20201021085655.1192025-13-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
References: <20201021085655.1192025-1-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's three ways to access PCI BARs from userspace: /dev/mem, sysfs
files, and the old proc interface. Two check against
iomem_is_exclusive, proc never did. And with CONFIG_IO_STRICT_DEVMEM,
this starts to matter, since we don't want random userspace having
access to PCI BARs while a driver is loaded and using it.

Fix this by adding the same iomem_is_exclusive() check we already have
on the sysfs side in pci_mmap_resource().

References: 90a545e98126 ("restrict /dev/mem to idle io memory ranges")
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.com>
--
v2: Improve commit message (Bjorn)
---
 drivers/pci/proc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index d35186b01d98..3a2f90beb4cb 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -274,6 +274,11 @@ static int proc_bus_pci_mmap(struct file *file, struct vm_area_struct *vma)
 		else
 			return -EINVAL;
 	}
+
+	if (dev->resource[i].flags & IORESOURCE_MEM &&
+	    iomem_is_exclusive(dev->resource[i].start))
+		return -EINVAL;
+
 	ret = pci_mmap_page_range(dev, i, vma,
 				  fpriv->mmap_state, write_combine);
 	if (ret < 0)
-- 
2.28.0

