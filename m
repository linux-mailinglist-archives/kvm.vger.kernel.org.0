Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790E92934BA
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 08:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbgJTGTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 02:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403827AbgJTGTH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 02:19:07 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24650C0613CE
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id r127so641514lff.12
        for <kvm@vger.kernel.org>; Mon, 19 Oct 2020 23:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hD8fdBTcCRJJbNA8v3NsYdfNpsT0GOXjZBHChPVSAwQ=;
        b=xayXCOMNNZwbmuUkVVezQLWXxIF8Miy8enw02DRg4WMA4X4m4slW+NMA5P0c3qhO5D
         +kGcktM4P+HXe2yBeAnG/2+Xclqp2OgxTip6/Bb3CVCIZ2bBJdJuUilLIHzwrkBYOE4B
         TsX/QxjT2Zm+Xmi1DZEf4e3GHpzUBG52A5spJ1L+jd8GahD1wE/T70vxhKe2veBu6B1U
         on4Jm3FJeU84oDq/lvJr3ij5Om1hKycOuf2yF3ueejQYeW554+O4+OSO9VQsHq+jp040
         3geG9EoBXHbv6MxUNE5qtCkA4baTyshro1n8PLvrT+t13ES/igx8D186TbBJCvSPy9yt
         zZ+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hD8fdBTcCRJJbNA8v3NsYdfNpsT0GOXjZBHChPVSAwQ=;
        b=m3OI4++D4c6a5+CXkDEYJ7lGN4Of+Oxar6GBT+kSmLpv/+76bPzcnrF2F2LTXBy7NF
         kSmAhTqPzooxR+JkUtYogf9eWyS8LUs9iDgImg1R/avzh6MOv+Ydv5HudkDcqAa82eV/
         2GDsmXOMN57wdmgXd5yl+7QVuqJ6gyonLQCcbRgoAMNXzy/SAkmI4+PufjNg0iIEvciw
         +smW0Q2zLofZeRodc6R4oy/uUWwthQX71gXgFOmtyfdGUPLCfrS1MEDkx2+dX2O+M3vC
         tYI9TzPtqbj83PQYWLIx10/YaFa4U6CrycvGEi+WXMbuZ+Zx1ErKHBtHSTHHWseI/u5y
         LUzQ==
X-Gm-Message-State: AOAM530EXRSCvnZxmW6BK+XT65X/c8jho3dReE0C5S1b9l7t/nwvNSeA
        cNU8cNHbx/U9D5Q0ehwZ3JWH7g==
X-Google-Smtp-Source: ABdhPJxCPKzmW7NJTv3qxlWKTiOn+Grv8DEV/W8CxNVAx3qx4Sk8sxbe6hNbgDfkCVtKyrc+SsUrYg==
X-Received: by 2002:a19:824f:: with SMTP id e76mr380839lfd.572.1603174745613;
        Mon, 19 Oct 2020 23:19:05 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id y19sm135513lfj.288.2020.10.19.23.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 23:19:04 -0700 (PDT)
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
X-Google-Original-From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Received: by box.localdomain (Postfix, from userid 1000)
        id C76D7102F62; Tue, 20 Oct 2020 09:19:01 +0300 (+03)
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
Subject: [RFCv2 03/16] x86/kvm: Make DMA pages shared
Date:   Tue, 20 Oct 2020 09:18:46 +0300
Message-Id: <20201020061859.18385-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make force_dma_unencrypted() return true for KVM to get DMA pages mapped
as shared.

__set_memory_enc_dec() now informs the host via hypercall if the state
of the page has changed from shared to private or back.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/Kconfig                 | 1 +
 arch/x86/mm/mem_encrypt_common.c | 5 +++--
 arch/x86/mm/pat/set_memory.c     | 7 +++++++
 include/uapi/linux/kvm_para.h    | 2 ++
 4 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 619ebf40e457..cd272e3babbc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -805,6 +805,7 @@ config KVM_GUEST
 	select PARAVIRT_CLOCK
 	select ARCH_CPUIDLE_HALTPOLL
 	select X86_HV_CALLBACK_VECTOR
+	select X86_MEM_ENCRYPT_COMMON
 	default y
 	help
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/mm/mem_encrypt_common.c b/arch/x86/mm/mem_encrypt_common.c
index 964e04152417..a878e7f246d5 100644
--- a/arch/x86/mm/mem_encrypt_common.c
+++ b/arch/x86/mm/mem_encrypt_common.c
@@ -10,14 +10,15 @@
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
 #include <linux/dma-mapping.h>
+#include <asm/kvm_para.h>
 
 /* Override for DMA direct allocation check - ARCH_HAS_FORCE_DMA_UNENCRYPTED */
 bool force_dma_unencrypted(struct device *dev)
 {
 	/*
-	 * For SEV, all DMA must be to unencrypted/shared addresses.
+	 * For SEV and KVM, all DMA must be to unencrypted/shared addresses.
 	 */
-	if (sev_active())
+	if (sev_active() || kvm_mem_protected())
 		return true;
 
 	/*
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d1b2a889f035..4c49303126c9 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -16,6 +16,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/libnvdimm.h>
+#include <linux/kvm_para.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -1977,6 +1978,12 @@ static int __set_memory_enc_dec(unsigned long addr, int numpages, bool enc)
 	struct cpa_data cpa;
 	int ret;
 
+	if (kvm_mem_protected()) {
+		unsigned long gfn = __pa(addr) >> PAGE_SHIFT;
+		int call = enc ? KVM_HC_MEM_UNSHARE : KVM_HC_MEM_SHARE;
+		return kvm_hypercall2(call, gfn, numpages);
+	}
+
 	/* Nothing to do if memory encryption is not active */
 	if (!mem_encrypt_active())
 		return 0;
diff --git a/include/uapi/linux/kvm_para.h b/include/uapi/linux/kvm_para.h
index 1a216f32e572..c6d8c988e330 100644
--- a/include/uapi/linux/kvm_para.h
+++ b/include/uapi/linux/kvm_para.h
@@ -30,6 +30,8 @@
 #define KVM_HC_SEND_IPI			10
 #define KVM_HC_SCHED_YIELD		11
 #define KVM_HC_ENABLE_MEM_PROTECTED	12
+#define KVM_HC_MEM_SHARE		13
+#define KVM_HC_MEM_UNSHARE		14
 
 /*
  * hypercalls use architecture specific
-- 
2.26.2

