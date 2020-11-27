Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEB72C69E8
	for <lists+kvm@lfdr.de>; Fri, 27 Nov 2020 17:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731753AbgK0Qm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Nov 2020 11:42:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731746AbgK0QmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Nov 2020 11:42:09 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C67C061A04
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:09 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id c198so5650526wmd.0
        for <kvm@vger.kernel.org>; Fri, 27 Nov 2020 08:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rOg+qp39SVj5WC86VkdFnTzL9jP06PEcpQhmqKQ3t14=;
        b=KobUOV0hD77WVAdN6sE1FCbuddcx+Y7JofzkUlxRd9nWy9jlHdO1T8SsUttmc9LdEH
         18FkNkVd0nL6VbYr5rOcMNJq8lcpuHF9LitOz/7CtQcZOgTCuvVk9HlpE337IvJ3CeQo
         TbfkBVcsC/WpwsEsC3qnjZtZkVocnIVEGrM9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rOg+qp39SVj5WC86VkdFnTzL9jP06PEcpQhmqKQ3t14=;
        b=jksDP7gNjnXN+cN0FFz65ipm+sNf/vGSBHTur7q9n9nwyrN3jQUItqU+xAq29CPv/J
         vGdumGNjq0XjCJmgHUPDmjs1++qsmNIcJ59Hft91nH7xNpyQdYE3L96yWhwhXWxTK+in
         Wcg2WxkBoWGfbVry4xf3GhSMqKxL9pyexw6oT3S7kxWrzY7rMEP+TIPZDqtHIv+aq3j8
         YrpqnctC2T7ZB6hlDBGmKiaITkgPRu+beKseBEcsIP38mZjC8854lesckmhixycv9f11
         DdYNDu3BZOMH9joxZwJHUVlWl/QKVSxd2ZpKPmxq3Id7W9jrqKeDbrNK058IDiNjpBDy
         suhw==
X-Gm-Message-State: AOAM533cjYIVSCzt0Z3D1tlp8U74x31V7ISO2+WhTlaKVMSyp79Q5VEr
        /jmS1GtB0SGWPUj0jRC2l49R+w==
X-Google-Smtp-Source: ABdhPJzZvF4udC7vFRIpQiicdsquYnu262AHQt4sYjvK76p1I545qbyBbBNxGngNqssLcpNV9573Nw==
X-Received: by 2002:a1c:4944:: with SMTP id w65mr10125938wma.50.1606495328317;
        Fri, 27 Nov 2020 08:42:08 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id q12sm14859078wrx.86.2020.11.27.08.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 08:42:07 -0800 (PST)
From:   Daniel Vetter <daniel.vetter@ffwll.ch>
To:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kees Cook <keescook@chromium.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, linux-pci@vger.kernel.org
Subject: [PATCH v7 08/17] PCI: Obey iomem restrictions for procfs mmap
Date:   Fri, 27 Nov 2020 17:41:22 +0100
Message-Id: <20201127164131.2244124-9-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
References: <20201127164131.2244124-1-daniel.vetter@ffwll.ch>
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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>
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
2.29.2

