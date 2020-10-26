Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CDE298B23
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 12:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772925AbgJZK7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 06:59:20 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37647 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1772826AbgJZK6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 06:58:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so11903326wre.4
        for <kvm@vger.kernel.org>; Mon, 26 Oct 2020 03:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5W4UqFTJMoDRzu7XpmV7m/mIx7tbXZK4TFNNVek8jNg=;
        b=KLr497mrTXuUWmZaofaXk1hyxgArLSK5Z8LFA7VwpBwSz2E3+nE1glgvLx0JiQdQzn
         dm5kaVp9H5reVf+JjmNdCZ0s9dozztPh2nQ4nrraI1YOy9mqE/zZOpL+5xkTYVff+uRk
         JdfMqSudDhC/KCWc2IX1OVFNm25KGK/VrwkWA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5W4UqFTJMoDRzu7XpmV7m/mIx7tbXZK4TFNNVek8jNg=;
        b=DHbGHwNHjA0KlS6kDJE7hc0KEjPWytkz5C+uPc1cCyWNT9VWK9Qqk3avwgY94K/Nhr
         A2zBHjH79EcUBOwKmLGWb5WSL2hRoW5fZ2Ylv+7gwmFrk6WMDwVI58de9ws/tYKDp5Ax
         phyrxDSldL/xiktfxhXax38t9PL9y+n1vPfXYcqryxwxqK/4saN7aac4NiNDYINiDbsE
         M0qTtfJRDMHjhW+TsInSNuLEx8iW19xKVuZ26FIfPqWbKXevqMZ1QRtxT+7krZ3Fyp+M
         CAGjg4OncDb9SMj9cMsmLrAYcCQd+xtRO2US08hNvKYHQa3fh5ErrKBXY6ozIOU0e24y
         DJ+A==
X-Gm-Message-State: AOAM533v8hHunRfJIKHotC9Zi2FIgjh292lAoYsWvfUukGKJPh3n25Ov
        gf5coH741BBOHwl/nIhwx4/rvA==
X-Google-Smtp-Source: ABdhPJz2su0SrOVqm3DeypSb7RJN8qc1fEsNaBh1v2aKMDuErJYYfZ5yJi5C/1uI817lBc+Ai9qYTQ==
X-Received: by 2002:adf:f3cb:: with SMTP id g11mr18177850wrp.210.1603709921142;
        Mon, 26 Oct 2020 03:58:41 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id w83sm21165156wmg.48.2020.10.26.03.58.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:58:40 -0700 (PDT)
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
        linux-pci@vger.kernel.org
Subject: [PATCH v4 11/15] PCI: Obey iomem restrictions for procfs mmap
Date:   Mon, 26 Oct 2020 11:58:14 +0100
Message-Id: <20201026105818.2585306-12-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
References: <20201026105818.2585306-1-daniel.vetter@ffwll.ch>
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
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
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

