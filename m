Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFE8638A6A
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbiKYMnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiKYMnF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA951AD95;
        Fri, 25 Nov 2022 04:43:04 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APAxpcZ029156;
        Fri, 25 Nov 2022 12:43:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=DxA0l4aFe1LptvUK1eK0JahASpZLQZHNGZp+luQ9G/I=;
 b=fwSyZiUFm+vJ8gSrNDmspXeBaDXpLuprxdmNbP2W3FlcTmFMGho6JnSe4SXRdoC0sFJ3
 7HtzE0ur+tyW7xwdJjsBPN3L4puyM2QP+93s1y1EUWs3iZvEcPsCUAQh6oLlCpGAELcH
 42M8pxQCOFgVh1H7I43NPIEUPVC7jh6C2yZiU+gz7ikE5EYYmKPpDV6uKbFeYL16jMWQ
 WIPh/anNzT2xWLtJtMVqNG6pUB5YUiAnlnPC93whEJ80+i+v8SjYjGZLTDWuDRr+oKqY
 sxnQHdNH2zKZxvN/w28mXNlV2NZ+ggJQifejFh8vxS8lop4zTrbVkIsnFWpSVgIXMD9C pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2ver276f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:03 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APAxkls028668;
        Fri, 25 Nov 2022 12:43:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2ver275w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:02 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCb85Z024057;
        Fri, 25 Nov 2022 12:43:00 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 3kxps96xkr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:00 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCgvQ03342998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:42:57 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 05A704C044;
        Fri, 25 Nov 2022 12:42:57 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 86F3F4C046;
        Fri, 25 Nov 2022 12:42:56 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:42:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: [GIT PULL 02/15] s390/entry: sort out physical vs virtual pointers usage in sie64a
Date:   Fri, 25 Nov 2022 13:39:34 +0100
Message-Id: <20221125123947.31047-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kRr-18wUQVM0Gu6YX4CLSjM354J23oUH
X-Proofpoint-ORIG-GUID: LzRvQ_xAt45aA-QkwQplDGk_1s2BsURM
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=764 mlxscore=0
 impostorscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 bulkscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Fix virtual vs physical address confusion (which currently are the
same).

sie_block is accessed in entry.S and passed it to hardware, which is why
both its physical and virtual address are needed. To avoid every caller
having to do the virtual-physical conversion, add a new function sie64a()
which converts the virtual address to physical.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20221020143159.294605-3-nrb@linux.ibm.com
Message-Id: <20221020143159.294605-3-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h   |  8 +++++++-
 arch/s390/include/asm/stacktrace.h |  1 +
 arch/s390/kernel/asm-offsets.c     |  1 +
 arch/s390/kernel/entry.S           | 26 +++++++++++++++-----------
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index b1e98a9ed152..9a31d00e99b3 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -1017,7 +1017,13 @@ void kvm_arch_crypto_clear_masks(struct kvm *kvm);
 void kvm_arch_crypto_set_masks(struct kvm *kvm, unsigned long *apm,
 			       unsigned long *aqm, unsigned long *adm);
 
-extern int sie64a(struct kvm_s390_sie_block *, u64 *);
+int __sie64a(phys_addr_t sie_block_phys, struct kvm_s390_sie_block *sie_block, u64 *rsa);
+
+static inline int sie64a(struct kvm_s390_sie_block *sie_block, u64 *rsa)
+{
+	return __sie64a(virt_to_phys(sie_block), sie_block, rsa);
+}
+
 extern char sie_exit;
 
 extern int kvm_s390_gisc_register(struct kvm *kvm, u32 gisc);
diff --git a/arch/s390/include/asm/stacktrace.h b/arch/s390/include/asm/stacktrace.h
index b23c658dce77..1802be5abb5d 100644
--- a/arch/s390/include/asm/stacktrace.h
+++ b/arch/s390/include/asm/stacktrace.h
@@ -46,6 +46,7 @@ struct stack_frame {
 			unsigned long sie_savearea;
 			unsigned long sie_reason;
 			unsigned long sie_flags;
+			unsigned long sie_control_block_phys;
 		};
 	};
 	unsigned long gprs[10];
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index d8ce965c0a97..3f8e760298c2 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -62,6 +62,7 @@ int main(void)
 	OFFSET(__SF_SIE_SAVEAREA, stack_frame, sie_savearea);
 	OFFSET(__SF_SIE_REASON, stack_frame, sie_reason);
 	OFFSET(__SF_SIE_FLAGS, stack_frame, sie_flags);
+	OFFSET(__SF_SIE_CONTROL_PHYS, stack_frame, sie_control_block_phys);
 	DEFINE(STACK_FRAME_OVERHEAD, sizeof(struct stack_frame));
 	BLANK();
 	/* idle data offsets */
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index d2a1f2f4f5b8..12e1773a94a4 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -225,18 +225,20 @@ ENDPROC(__switch_to)
 
 #if IS_ENABLED(CONFIG_KVM)
 /*
- * sie64a calling convention:
- * %r2 pointer to sie control block
- * %r3 guest register save area
+ * __sie64a calling convention:
+ * %r2 pointer to sie control block phys
+ * %r3 pointer to sie control block virt
+ * %r4 guest register save area
  */
-ENTRY(sie64a)
+ENTRY(__sie64a)
 	stmg	%r6,%r14,__SF_GPRS(%r15)	# save kernel registers
 	lg	%r12,__LC_CURRENT
-	stg	%r2,__SF_SIE_CONTROL(%r15)	# save control block pointer
-	stg	%r3,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
+	stg	%r2,__SF_SIE_CONTROL_PHYS(%r15)	# save sie block physical..
+	stg	%r3,__SF_SIE_CONTROL(%r15)	# ...and virtual addresses
+	stg	%r4,__SF_SIE_SAVEAREA(%r15)	# save guest register save area
 	xc	__SF_SIE_REASON(8,%r15),__SF_SIE_REASON(%r15) # reason code = 0
 	mvc	__SF_SIE_FLAGS(8,%r15),__TI_flags(%r12) # copy thread flags
-	lmg	%r0,%r13,0(%r3)			# load guest gprs 0-13
+	lmg	%r0,%r13,0(%r4)			# load guest gprs 0-13
 	lg	%r14,__LC_GMAP			# get gmap pointer
 	ltgr	%r14,%r14
 	jz	.Lsie_gmap
@@ -248,6 +250,7 @@ ENTRY(sie64a)
 	jnz	.Lsie_skip
 	TSTMSK	__LC_CPU_FLAGS,_CIF_FPU
 	jo	.Lsie_skip			# exit if fp/vx regs changed
+	lg	%r14,__SF_SIE_CONTROL_PHYS(%r15)	# get sie block phys addr
 	BPEXIT	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)
 .Lsie_entry:
 	sie	0(%r14)
@@ -258,13 +261,14 @@ ENTRY(sie64a)
 	BPOFF
 	BPENTER	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)
 .Lsie_skip:
+	lg	%r14,__SF_SIE_CONTROL(%r15)	# get control block pointer
 	ni	__SIE_PROG0C+3(%r14),0xfe	# no longer in SIE
 	lctlg	%c1,%c1,__LC_KERNEL_ASCE	# load primary asce
 .Lsie_done:
 # some program checks are suppressing. C code (e.g. do_protection_exception)
 # will rewind the PSW by the ILC, which is often 4 bytes in case of SIE. There
 # are some corner cases (e.g. runtime instrumentation) where ILC is unpredictable.
-# Other instructions between sie64a and .Lsie_done should not cause program
+# Other instructions between __sie64a and .Lsie_done should not cause program
 # interrupts. So lets use 3 nops as a landing pad for all possible rewinds.
 .Lrewind_pad6:
 	nopr	7
@@ -293,8 +297,8 @@ sie_exit:
 	EX_TABLE(.Lrewind_pad4,.Lsie_fault)
 	EX_TABLE(.Lrewind_pad2,.Lsie_fault)
 	EX_TABLE(sie_exit,.Lsie_fault)
-ENDPROC(sie64a)
-EXPORT_SYMBOL(sie64a)
+ENDPROC(__sie64a)
+EXPORT_SYMBOL(__sie64a)
 EXPORT_SYMBOL(sie_exit)
 #endif
 
@@ -373,7 +377,7 @@ ENTRY(pgm_check_handler)
 	j	3f			# -> fault in user space
 .Lpgm_skip_asce:
 #if IS_ENABLED(CONFIG_KVM)
-	# cleanup critical section for program checks in sie64a
+	# cleanup critical section for program checks in __sie64a
 	OUTSIDE	%r9,.Lsie_gmap,.Lsie_done,1f
 	SIEEXIT
 	lghi	%r10,_PIF_GUEST_FAULT
-- 
2.38.1

