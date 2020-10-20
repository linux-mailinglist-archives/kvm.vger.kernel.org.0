Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1F42934D9
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404043AbgJTGVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403855AbgJTGTK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:10 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F08DC0613D3
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id a9so660785lfc.7
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qLURW/jdlNSmWtGV7khIZIL/9JX3uhBDJsl3glpsKS8=;
        b=Jaw6HndAu/3od4pm499wgLo/PnSpOsgf0qKVfrKZ1ObrIz2yUpappsJVWeGMaVAqNO
         zSq3AWMELJvDUUtpU8pJz+MZT0jeQQR7iN/Ls98p1ehKXFap4WGihAI3j73Y43ME2ILD
         Qx9R8kIrkKBMrnE5Wz8ug5w+u3Gub5ePmKcDsf5JJtjgCQkVIFtvxx25WrErKV8U4Dve
         P5UiLdHJzlXicKgNe8Ov+RGhPZS9rX9WxGEc+5yZ68LNby4EsxZ6T9FgHRrW74PIhXab
         OHvYo/0kDIK1WRTZvuBsBjo02CVVdOGsKHYcx7W8ewU4ZIqOMNtSxDmApLflbLxA5FA5
         zJeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qLURW/jdlNSmWtGV7khIZIL/9JX3uhBDJsl3glpsKS8=;
        b=LquOkGDuemO1dAXjdY3nscFHX9pBJS0LtKqzzJUARchkhltZ7sYOgLoIugWAe0ZOvz
         F1WZt2MKsNEQFR/vHjq+id1ZQACTwhCoTx+BIV7siB45PIHlbLVS/GbrpTTG9lpc9VQk
         o6d6Gk7OHxdNhWxUjes1a+cdNcW3aX7y1TjBKAlfxt8FlcLhp/AKCLVUtbrIzRO8YAks
         O0qXEr6GoVPcYS9hb2WR80zlRv++5Gac5RT/jLbYPiZAzbZxe4Qi1Qx9KdEFEqvVgi6C
         CPjl3qiSgHcXxn1vl1zSDwC4JXYimgLZ7WVfFCCtgSptKmGiZ7PuZ9vXQdlp7ThhotdG
         KMKQ==
X-Gm-Message-State: AOAM531TXhEs7Igq01aGCgIcjAKGxP9r+NQCryk9OgLVdKCis0ZALC42
        tU7u3EgUrrY0vVwk6yZykGRBwQ==
X-Google-Smtp-Source: ABdhPJyKeklJAljBMnRznV5JsOkA5QkHO53L5Td3aC6wSbikok2iDHFkX0MnaQa4ylGJgw8He3Cn1Q==
X-Received: by 2002:a19:64b:: with SMTP id 72mr395872lfg.47.1603174748148;
        Mon, 19 Oct 2020 23:19:08 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id m30sm136843lfc.97.2020.10.19.23.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:06 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id D79B8102F64; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
To:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFCv2 05/16] x86/kvm: Make VirtIO use DMA API in KVM guest
Date:   Tue, 20 Oct 2020 09:18:48 +0300
Message-Id: <20201020061859.18385-6-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VirtIO for KVM is a primary way to provide IO. All memory that used for
communication with the host has to be marked as shared.

The easiest way to archive that is to use DMA API that already knows how
to deal with shared memory.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 drivers/virtio/virtio_ring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index becc77697960..ace733845d5d 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -12,6 +12,7 @@
 #include <linux/hrtimer.h>
 #include <linux/dma-mapping.h>
 #include <xen/xen.h>
+#include <asm/kvm_para.h>
 
 #ifdef DEBUG
 /* For development, we want to crash whenever the ring is screwed. */
@@ -255,6 +256,9 @@ static bool vring_use_dma_api(struct virtio_device *vdev)
 	if (xen_domain())
 		return true;
 
+	if (kvm_mem_protected())
+		return true;
+
 	return false;
 }
 
-- 
2.26.2

