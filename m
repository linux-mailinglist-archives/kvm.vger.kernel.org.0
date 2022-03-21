Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379A64E2384
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 10:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345993AbiCUJpG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 05:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345985AbiCUJpF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 05:45:05 -0400
Received: from out0-143.mail.aliyun.com (out0-143.mail.aliyun.com [140.205.0.143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72E414016;
        Mon, 21 Mar 2022 02:43:39 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047213;MF=darcy.sh@antgroup.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---.N99c1i1_1647855816;
Received: from localhost(mailfrom:darcy.sh@antgroup.com fp:SMTPD_---.N99c1i1_1647855816)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Mar 2022 17:43:36 +0800
From:   "SU Hang" <darcy.sh@antgroup.com>
To:     kvm@vger.kernel.org
Cc:     "=?UTF-8?B?6LWW5rGf5bGx?=" <jiangshan.ljs@antgroup.com>,
        "SU Hang" <darcy.sh@antgroup.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        "Wanpeng Li" <wanpengli@tencent.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Joerg Roedel" <joro@8bytes.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "Dave Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] KVM: X86: use EPT_VIOLATION_* instead of 0x7
Date:   Mon, 21 Mar 2022 17:42:03 +0800
Message-Id: <20220321094203.109546-2-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20220321094203.109546-1-darcy.sh@antgroup.com>
References: <20220321094203.109546-1-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use symbolic value, EPT_VIOLATION_*, instead of 0x7
in FNAME(walk_addr_generic)().

Signed-off-by: SU Hang <darcy.sh@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7853c7ef13a1..2e2b1f7ccaca 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -531,7 +531,12 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_READ;
 		if (fetch_fault)
 			vcpu->arch.exit_qualification |= EPT_VIOLATION_ACC_INSTR;
-		vcpu->arch.exit_qualification |= (pte_access & 0x7) << 3;
+		if (pte_access & ACC_USER_MASK)
+			vcpu->arch.exit_qualification |= EPT_VIOLATION_READABLE;
+		if (pte_access & ACC_WRITE_MASK)
+			vcpu->arch.exit_qualification |= EPT_VIOLATION_WRITABLE;
+		if (pte_access & ACC_EXEC_MASK)
+			vcpu->arch.exit_qualification |= EPT_VIOLATION_EXECUTABLE;
 	}
 #endif
 	walker->fault.address = addr;
-- 
2.32.0.3.g01195cf9f

