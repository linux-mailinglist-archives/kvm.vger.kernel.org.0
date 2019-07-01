Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCD710068
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 21:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfD3TrW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 15:47:22 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42986 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfD3TrW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 15:47:22 -0400
Received: by mail-pg1-f195.google.com with SMTP id p6so7315373pgh.9
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2019 12:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mBbomRt4Uelgetgzv4Py/lnS89qT0a6o14TEXaMdcqA=;
        b=HM6kLzzJ9WFxDb6LoHClGEe3D0K0kO0jOsd96WuchhBYODwNc4W/yDj1KmE3Q+pKTm
         COOhPQmzDMiUQCyDtjK5ui34AOtwm5/WlhGAedr3h0Z4FVqBIs03AxeGWLJQ6A1kZnpG
         EQCiurm5wh+/hSdm70IkstDEbIPpl12m06VX7ukPdFlKwsivNFM9wBLSdvNpTqtR58cv
         97WM3Z9oVcSIG/+mUVb0el4ZNsR14Fz3SRD4o9x2Ab7Ugl9Ry/MSPRUyGxROhTNWEvfM
         wJoj9VlTZP5zFGdTfGY0YY+oQZj9UmbBUZd2dXKbVOZbbHtdNpwOHccCHjvpVUSkwCFP
         68DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mBbomRt4Uelgetgzv4Py/lnS89qT0a6o14TEXaMdcqA=;
        b=qDxfUMku4ClfNDFwoTKaOjsEjRuRFNEjtTOWRQHoWQnr71VicD+Oo/pB65wUuGRHXv
         50Dw0YZCi+fKds939vYlL5/pRjHvnnrxy03MBMlHXllzK+wmNlYpIn78t8fP0jhZaJXs
         +O0JPHF9glweIZvhd7RGAZb22kqTEocUZ2aiE3CDsY0gH9vQOO1h9oQrDqsEPvsDDKm+
         AgnC2Dl6s5Ex5PV7oAJ+EJ780EKqXL+JxrL/H5rYIIMrQx6+jUqL18JmTKNkNa1wn3BK
         v0xD/pACSYy+d/b/yhefXK7Je7tobX2cnvWgqsnRvdIAhznLtYc50ck8zak0imlJyRVP
         Ce5Q==
X-Gm-Message-State: APjAAAWQhI8m01/xEMGxnBrnhoGPLDy/ekMuLZgsr3vzw3nIKKJqbrQ3
        2UGFofqZDvTqxfe6mTfkcDE=
X-Google-Smtp-Source: APXvYqzkD88kZzjQfwBEoDth44lLZGbkhLXCxwMA1gVF7yDRlgMT4DgGusQ6UoOmmh1azJGg25Xoqw==
X-Received: by 2002:a65:6205:: with SMTP id d5mr22902158pgv.61.1556653641349;
        Tue, 30 Apr 2019 12:47:21 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id a3sm58703961pfn.182.2019.04.30.12.47.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 12:47:20 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH] x86: Disable cache before relocating local APIC
Date:   Tue, 30 Apr 2019 05:27:01 -0700
Message-Id: <20190430122701.41069-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

According to the SDM, during initialization, the BSP "Switches to
protected mode and ensures that the APIC address space is mapped to the
strong uncacheable (UC) memory type."

This requirement is not followed when the tests relocate the APIC. Set
the cache-disable flag while the APIC base is reprogrammed. According
to the SDM, the MTRRs should be modified as well, but it seems somewhat
complicated to do that and probably unnecessary.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/processor.h | 1 +
 x86/apic.c          | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 916e67d..59137da 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -29,6 +29,7 @@
 #define X86_CR0_TS     0x00000008
 #define X86_CR0_WP     0x00010000
 #define X86_CR0_AM     0x00040000
+#define X86_CR0_CD     0x40000000
 #define X86_CR0_PG     0x80000000
 #define X86_CR3_PCID_MASK 0x00000fff
 #define X86_CR4_TSD    0x00000004
diff --git a/x86/apic.c b/x86/apic.c
index de5990c..de4a181 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -165,8 +165,13 @@ static void test_apicbase(void)
 {
     u64 orig_apicbase = rdmsr(MSR_IA32_APICBASE);
     u32 lvr = apic_read(APIC_LVR);
+    u64 cr0 = read_cr0();
     u64 value;
 
+    /* Disable caching to prevent the APIC from being cacheable */
+    write_cr0(cr0 | X86_CR0_CD);
+    asm volatile ("wbinvd" ::: "memory");
+
     wrmsr(MSR_IA32_APICBASE, orig_apicbase & ~(APIC_EN | APIC_EXTD));
     wrmsr(MSR_IA32_APICBASE, ALTERNATE_APIC_BASE | APIC_BSP | APIC_EN);
 
@@ -186,6 +191,8 @@ static void test_apicbase(void)
     wrmsr(MSR_IA32_APICBASE, orig_apicbase);
     apic_write(APIC_SPIV, 0x1ff);
 
+    write_cr0(cr0);
+
     report_prefix_pop();
 }
 
-- 
2.17.1

