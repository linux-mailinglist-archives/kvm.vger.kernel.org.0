Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35B511DE74E
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 14:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgEVMx5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 08:53:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbgEVMwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 08:52:23 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74450C08C5C8
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:22 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id a25so834242ljp.3
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 05:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TRTK9a5mpqTDY5ZfccpPpqg6MJ7UvrTh0xOAXZSLOT0=;
        b=GtiEZ4n19ouyAizgKUR7+QtiVY5GOsdnqMTjHrIb62L5xETehoiRwghxpTXWAFsud/
         mzMElUVEBDDRWzoET4wNfdBr+wjaqzM/XIt1wcZOSbxfJkSXPhaXh78G/xODWbBkjHWI
         Ml2DHUVIQJ87N1mWdC9TF590bqRjFqLm61X3ZvCMq8khw6tLBA9ohicbe26vEv2hL8U5
         4F9TmwyGNQDDzBo+XOMmQUHnWmvDEW6nCGxTzjxiqD3j423EdCtU2NM74RLdpHP02Q1T
         BbVYwG/7tf+sGDZcMWGVGYeXypePS7/N7EB2aXkxTZ+AwJIqmQ4ZMG6MMGqCPisBllWD
         ayxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TRTK9a5mpqTDY5ZfccpPpqg6MJ7UvrTh0xOAXZSLOT0=;
        b=mWtsjPERLJMFlblHWNPsQP+RrQXOKXwaatkMzlDH6FY/LhTl6C5inaCaf8rkDak487
         1sgz9pSmwt+f2f9nrnqWJTbt8hv2fEjL3jDejqQsBrZnCc2E1npncGnI/LbtVrLI7xcv
         P+yZLTb8+BR2YVZFJ8+Mtm+XOZieFvMv5DDVgCZsbkuEnBTLFXVIqB8QHN8DTPRI4NLQ
         pTCgsQWkdvMEVmUzyv/P6Wpl7co4wZ4YPkSgn6cp1mWuyFzvq9/d1dqi7FJjL0TPa4ol
         06U7XpoQ5BdwrYIVbPoM2lgem0Ns8MbsGLVN/KY9uMHZDbrOEkxtYQqy4qkplmbw1o/I
         Ssfg==
X-Gm-Message-State: AOAM530fvdqk8SA3mUFdEJdLjvnGdVj4Nxev0j5Tg+ctrjkdCSJDOcg6
        f3TGiW5E0aJV9l0FYYFOcVApGA==
X-Google-Smtp-Source: ABdhPJxgD8Uk4BEWMvgEPW1VD/uD+DbfKpa/h/WYtV9wQd/dZu3w9fynzecAsTLspWi1RmapCaP6QQ==
X-Received: by 2002:a2e:9f43:: with SMTP id v3mr7757905ljk.285.1590151940948;
        Fri, 22 May 2020 05:52:20 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id n8sm2401340lfb.20.2020.05.22.05.52.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:52:20 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id C0A1C102053; Fri, 22 May 2020 15:52:19 +0300 (+03)
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
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC 05/16] x86/kvm: Make VirtIO use DMA API in KVM guest
Date:   Fri, 22 May 2020 15:52:03 +0300
Message-Id: <20200522125214.31348-6-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
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
index 58b96baa8d48..bd9c56160107 100644
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

