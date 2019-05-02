Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4335C12487
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 00:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfEBWUY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 May 2019 18:20:24 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33108 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfEBWUY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 May 2019 18:20:24 -0400
Received: by mail-pl1-f196.google.com with SMTP id y3so1685820plp.0
        for <kvm@vger.kernel.org>; Thu, 02 May 2019 15:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PCto+tor/Funw84FDK4f/C6mYnGfPxUusytNY/M0v8E=;
        b=eAT043FuBp3mi4krOIRkaTWf8pphOCzVeycqzBgC1h2at1nU+VBxVWWBdNC7ONwGdW
         iyCjcUEBZWQsgkwYlL83O/SxQ51/gE+MdDwNu0/GvePKT7zY11uNCPMGZH0doNZnUS0p
         TivFJp7LViUbxED/lu6AUnXVNw3uxq+NuzzUeqWkw1S4b3Wu+EiSDL8R2GDFQ2/T9U/k
         jaUmV/bIjLBuNYZKNbP9nVL1/9MtAVLwhnAhOgK+Hvp7W8QnEyaflaO6eqdBslM74tvY
         N+HdhTGEIydGiLoT/2OqUE9OpVuoXKOXFVvQH+BySIn+1O/tHAA1beUBB0ticBnGOOKX
         22CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PCto+tor/Funw84FDK4f/C6mYnGfPxUusytNY/M0v8E=;
        b=ACYL/NGqnS/fEz9PbDlnNTaYzUtm7rsuP26omwnQ+qUTjUt1UrzHhShxhS33dth869
         BdusYvWyDYlnqtlDCSztJ4arbyxX3mbyU2ivTIrRl2z8UukvvnH3gESQ+hBGK1OHT05U
         Brfy1GU7fzy4Bww9VDIgCCtyWHVRvOK+nPe/iIWPC3aoBRGWLTDB8C9hASlDxMZeWvn+
         W20tKd7pBVFZnPYhViYBYlwlPP4cbcDNGZR2iMjCyV2vVn45AjdLO1W1gCH/gseHQ7a8
         XO07CVyW2fGg6ZjZUpsEzKsJgDWK081uyi0hAyVUvceT6/C0SrWjZmWI8gZSgnok4KUU
         jyeA==
X-Gm-Message-State: APjAAAWMFTKNTJLoX4qEaSP2fkavoDVu0YwyqzfmwrMpL9i1x60vbAfv
        5PMGJjaqkR+qlP7+/zhgSy4=
X-Google-Smtp-Source: APXvYqwoGq65aufpUX/mKYr86ZX/8fnSpMAEHV+3n8PoBUQvfttW0HxgzkLBfX8LROoXu9AoeQWe6A==
X-Received: by 2002:a17:902:8345:: with SMTP id z5mr6398466pln.255.1556835623484;
        Thu, 02 May 2019 15:20:23 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id y17sm201167pfb.161.2019.05.02.15.20.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 15:20:22 -0700 (PDT)
From:   nadav.amit@gmail.com
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Restore VMCS state when test_vmcs_addr() is done
Date:   Thu,  2 May 2019 07:57:41 -0700
Message-Id: <20190502145741.7863-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

The VMCS fields of APIC_VIRT_ADDR and TPR_THRESHOLD are modified by
test_vmcs_addr() but are not restored to their original value. Save and
restore them.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/vmx_tests.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index e9010af..2d6b12d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -4432,6 +4432,8 @@ static void test_tpr_threshold_values(void)
 static void test_tpr_threshold(void)
 {
 	u32 primary = vmcs_read(CPU_EXEC_CTRL0);
+	u64 apic_virt_addr = vmcs_read(APIC_VIRT_ADDR);
+	u64 threshold = vmcs_read(TPR_THRESHOLD);
 	void *virtual_apic_page;
 
 	if (!(ctrl_cpu_rev[0].clr & CPU_TPR_SHADOW))
@@ -4451,11 +4453,8 @@ static void test_tpr_threshold(void)
 	report_prefix_pop();
 
 	if (!((ctrl_cpu_rev[0].clr & CPU_SECONDARY) &&
-	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES)))) {
-		vmcs_write(CPU_EXEC_CTRL0, primary);
-		return;
-	}
-
+	    (ctrl_cpu_rev[1].clr & (CPU_VINTD  | CPU_VIRT_APIC_ACCESSES))))
+		goto out;
 	u32 secondary = vmcs_read(CPU_EXEC_CTRL1);
 
 	if (ctrl_cpu_rev[1].clr & CPU_VINTD) {
@@ -4505,6 +4504,9 @@ static void test_tpr_threshold(void)
 	}
 
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
+out:
+	vmcs_write(TPR_THRESHOLD, threshold);
+	vmcs_write(APIC_VIRT_ADDR, apic_virt_addr);
 	vmcs_write(CPU_EXEC_CTRL0, primary);
 }
 
-- 
2.17.1

