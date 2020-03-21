Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D6518DDEC
	for <lists+kvm@lfdr.de>; Sat, 21 Mar 2020 06:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgCUFHu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Mar 2020 01:07:50 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33947 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgCUFHu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Mar 2020 01:07:50 -0400
Received: by mail-pf1-f193.google.com with SMTP id 23so4417919pfj.1
        for <kvm@vger.kernel.org>; Fri, 20 Mar 2020 22:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=49BuhoPB/LV65DGt5z0/eg7O0OzojYhf2QWVo/kHTnA=;
        b=dlQ0FbvDSrgCI0wUxafmy5v/Kc8YogcDi05k6GIU7914IandyOgaBIou0Mg0eIl2aZ
         2CWfSSSPzSrCG/CR/o/rOLaUlWyBmDbZDHaaxwWXfotRwTBURVAQsEZy17FvoDPmjA5o
         LZTe7FCmt8coKM/LooAlE+PlmmrF3uek5zegWlkvJ3tBqkYY+p2jhSNySfo6M2TcvXfu
         bJU5AS2fYgm8yRadIwAcip4+Kpu1/Uk/IUzwj1lFiiNOnNGju7W0PDunItUw02Uz313W
         pbR+yaLFEPjbCqJ8+c8JI6gbjTN6ejWC4RKe5sqMza+JhG3ZVVqyHA4DOIVFIk92N9NP
         HUdw==
X-Gm-Message-State: ANhLgQ1apckc7jhYAqkoFzfvAzTXObhGqIiP3dXDu9MSnpONM/qaWQYH
        mRJ/sOsfNDEMoQ0GtlokORvw0BpYNJA=
X-Google-Smtp-Source: ADFU+vtcFs9SIAbeve8621dMFSO4oz9Sa937sKD5p1tsYNgB7EMgNFJ7j12QgwE/c64Omfw907l76g==
X-Received: by 2002:aa7:9888:: with SMTP id r8mr13526553pfl.293.1584767268664;
        Fri, 20 Mar 2020 22:07:48 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id b9sm6391524pgi.75.2020.03.20.22.07.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 22:07:47 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>
Subject: [PATCH] x86: vmx: Fix "EPT violation - paging structure" test
Date:   Fri, 20 Mar 2020 22:05:55 -0700
Message-Id: <20200321050555.4212-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running the tests with more than 4GB of memory results in the following
failure:

  FAIL: EPT violation - paging structure

It appears that the test mistakenly used get_ept_pte() to retrieve the
guest PTE, but this function is intended for accessing EPT and not the
guest page tables. Use get_pte_level() instead of get_ept_pte().

Tested on bare-metal only.

Signed-off-by: Nadav Amit <namit@vmware.com>
---
 x86/vmx_tests.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index be5c952..1f97fe3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -1312,12 +1312,14 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 	u64 guest_cr3;
 	u32 insn_len;
 	u32 exit_qual;
-	static unsigned long data_page1_pte, data_page1_pte_pte, memaddr_pte;
+	static unsigned long data_page1_pte, data_page1_pte_pte, memaddr_pte,
+			     guest_pte_addr;
 
 	guest_rip = vmcs_read(GUEST_RIP);
 	guest_cr3 = vmcs_read(GUEST_CR3);
 	insn_len = vmcs_read(EXI_INST_LEN);
 	exit_qual = vmcs_read(EXI_QUALIFICATION);
+	pteval_t *ptep;
 	switch (exit_reason.basic) {
 	case VMX_VMCALL:
 		switch (vmx_get_test_stage()) {
@@ -1364,12 +1366,11 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 			ept_sync(INVEPT_SINGLE, eptp);
 			break;
 		case 4:
-			TEST_ASSERT(get_ept_pte(pml4, (unsigned long)data_page1,
-						2, &data_page1_pte));
-			data_page1_pte &= PAGE_MASK;
-			TEST_ASSERT(get_ept_pte(pml4, data_page1_pte,
-						2, &data_page1_pte_pte));
-			set_ept_pte(pml4, data_page1_pte, 2,
+			ptep = get_pte_level((pgd_t *)guest_cr3, data_page1, /*level=*/2);
+			guest_pte_addr = virt_to_phys(ptep) & PAGE_MASK;
+
+			TEST_ASSERT(get_ept_pte(pml4, guest_pte_addr, 2, &data_page1_pte_pte));
+			set_ept_pte(pml4, guest_pte_addr, 2,
 				data_page1_pte_pte & ~EPT_PRESENT);
 			ept_sync(INVEPT_SINGLE, eptp);
 			break;
@@ -1437,7 +1438,7 @@ static int ept_exit_handler_common(union exit_reason exit_reason, bool have_ad)
 					  (have_ad ? EPT_VLT_WR : 0) |
 					  EPT_VLT_LADDR_VLD))
 				vmx_inc_test_stage();
-			set_ept_pte(pml4, data_page1_pte, 2,
+			set_ept_pte(pml4, guest_pte_addr, 2,
 				data_page1_pte_pte | (EPT_PRESENT));
 			ept_sync(INVEPT_SINGLE, eptp);
 			break;
-- 
2.17.1

