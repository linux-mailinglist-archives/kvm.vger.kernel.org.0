Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6FCCB067
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 22:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731413AbfJCUrS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 16:47:18 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37126 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729193AbfJCUrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 16:47:17 -0400
Received: by mail-pf1-f194.google.com with SMTP id y5so2498963pfo.4
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 13:47:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vDz4CNFWOTztzA1GiLBvWR2d/6AIBHLVshICPQcqmiQ=;
        b=tpS9Xyq8UxQIeioJvhHyAjd/1b0w7dxkiB4JlCUpsBHPlN9IeqV0YiIS9Am3+2ep2U
         oYpZ1Ax2M6ikdG4VRihJjXsQUF4ZsEUEIgpjZtrx/si4plvXxnPBvzWLU4Jfv4Agt6LR
         9eqtwIy6VgWUkLzhdBw74/+Jn6JqNV4Y+Ew2E+GIM4HRQnBknVXVUw5VI7NSYmz47dmK
         oBSbksdE8Q9nWAiML6dVV4QY0jbIIeTb4pHK8sWYb459SWj/2+wje1PVAJLumkw47IUR
         cfOIgUqVz0Qn+LvqKjf2rst7CpfWvUqQQnZY5BKd96CINsFeFxLaw7MLxGzXKDlqxLRC
         bfpw==
X-Gm-Message-State: APjAAAVoWzMahV+y8X2Rsf3sl9438FEsUKpMBj1ini36LcEQ3sGprJ9+
        fx8+UQ9MP/TEwo9vO8pjwCj5aw9rR6U=
X-Google-Smtp-Source: APXvYqzEB7vDO7DrJWNuOzXa8QOUt1SdweDU5XBbGkmckSz/KjW6E24bo4JlLWa9Q413fYFPY7jWEg==
X-Received: by 2002:a17:90a:e50e:: with SMTP id t14mr13023170pjy.62.1570135636656;
        Thu, 03 Oct 2019 13:47:16 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id q29sm6100093pgc.88.2019.10.03.13.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 13:47:15 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, sean.j.christopherson@intel.com,
        Nadav Amit <namit@vmware.com>
Subject: [kvm-unit-tests PATCH] x86: VMX: Mask advanced VM-exit info
Date:   Thu,  3 Oct 2019 06:26:18 -0700
Message-Id: <20191003132618.8485-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bits [9:11] are undefined in the VM-exit qualification when "advanced
VM-exit information for EPT violations" is not supported.

Mask these bits for now to avoid false failures. If KVM supports this
feature, the tests would need to be adapted, and the masking would need
to be removed.

Unfortunately, I do not have hardware that supports this feature
available for my use to make a better fix.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx.h       | 2 ++
 x86/vmx_tests.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/x86/vmx.h b/x86/vmx.h
index a8bc847..8496be7 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -618,6 +618,8 @@ enum vm_instruction_error_number {
 #define EPT_VLT_GUEST_USER	(1ull << 9)
 #define EPT_VLT_GUEST_RW	(1ull << 10)
 #define EPT_VLT_GUEST_EX	(1ull << 11)
+#define EPT_VLT_GUEST_MASK	(EPT_VLT_GUEST_USER | EPT_VLT_GUEST_RW | \
+				 EPT_VLT_GUEST_EX)
 
 #define MAGIC_VAL_1		0x12345678ul
 #define MAGIC_VAL_2		0x87654321ul
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index f4b348b..6b9dc10 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1409,6 +1409,13 @@ static int ept_exit_handler_common(bool have_ad)
 		}
 		return VMX_TEST_RESUME;
 	case VMX_EPT_VIOLATION:
+		/*
+		 * Exit-qualifications are masked not to account for advanced
+		 * VM-exit information. Once KVM supports this feature, this
+		 * masking should be removed.
+		 */
+		exit_qual &= ~EPT_VLT_GUEST_MASK;
+
 		switch(vmx_get_test_stage()) {
 		case 3:
 			check_ept_ad(pml4, guest_cr3, (unsigned long)data_page1, 0,
-- 
2.17.1

