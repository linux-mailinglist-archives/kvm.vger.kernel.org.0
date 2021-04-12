Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5435C585
	for <lists+kvm@lfdr.de>; Mon, 12 Apr 2021 13:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbhDLLpk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Apr 2021 07:45:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41428 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237792AbhDLLpj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 12 Apr 2021 07:45:39 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CBa0Nb144705;
        Mon, 12 Apr 2021 07:44:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YbhVLhB/fTHiNuq6es7ZeDfxBnJVH+H/SDt1CN+GezM=;
 b=biAuOrcfeOERX6OANr9swuAq99ZEQPBPsclvMEr1Wc1a7imgAnOQadSQLqXwPoGOpxcB
 ED9RycZ+/xVX02c7B64fWTNcscG9F2vsLh7a2bCWu1bWiV56mh08fjzD1jTYZmYhHti5
 f2HAjVYLsbSR6NC80F+9rrQKMHMzPwy543NL/Rp8GZw1XZjEBGm4+ncE/1NLtTXe5vxM
 6JfzyManfhkl9vlHjmPwznTir7zjS+KtKXTfoFn2T+k9HrUuAVa/iCaoimSk09gXFx85
 0zNMF6JiAbeeOTkNBaCQwgEVhjhHa5KukNqRihQgpoJKw6PwJ2EV7Yq3bll9VI3tGeDS Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vm0tuc1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 07:44:51 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CBaKKX147307;
        Mon, 12 Apr 2021 07:44:50 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37vm0tuc17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 07:44:50 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13CBhihm008868;
        Mon, 12 Apr 2021 11:44:48 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 37u39hhs17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 11:44:48 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13CBijkg37814764
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Apr 2021 11:44:45 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BEF04AE056;
        Mon, 12 Apr 2021 11:44:45 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8D9C9AE04D;
        Mon, 12 Apr 2021 11:44:42 +0000 (GMT)
Received: from bangoria.ibmuc.com (unknown [9.199.37.145])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Apr 2021 11:44:42 +0000 (GMT)
From:   Ravi Bangoria <ravi.bangoria@linux.ibm.com>
To:     paulus@samba.org, david@gibson.dropbear.id.au
Cc:     ravi.bangoria@linux.ibm.com, mpe@ellerman.id.au, mikey@neuling.org,
        pbonzini@redhat.com, mst@redhat.com, clg@kaod.org,
        qemu-ppc@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        cohuck@redhat.com, groug@kaod.org
Subject: [PATCH v5 2/3] ppc: Rename current DAWR macros and variables
Date:   Mon, 12 Apr 2021 17:14:32 +0530
Message-Id: <20210412114433.129702-3-ravi.bangoria@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
References: <20210412114433.129702-1-ravi.bangoria@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QYjHwflVB6fd1BdcFLdiZHBvkEcJojyU
X-Proofpoint-ORIG-GUID: pp0xkBQEygHc5kW-1Z-s5Kd_rYZ39vtt
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 impostorscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104120079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Power10 is introducing second DAWR. Use real register names (with
suffix 0) from ISA for current macros and variables used by Qemu.

One exception to this is KVM_REG_PPC_DAWR[X]. This is from kernel
uapi header and thus not changed in kernel as well as Qemu.

Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Reviewed-by: Greg Kurz <groug@kaod.org>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
---
 include/hw/ppc/spapr.h          | 2 +-
 target/ppc/cpu.h                | 4 ++--
 target/ppc/translate_init.c.inc | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index bf7cab7a2c..5f90bb26d5 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -363,7 +363,7 @@ struct SpaprMachineState {
 
 /* Values for 2nd argument to H_SET_MODE */
 #define H_SET_MODE_RESOURCE_SET_CIABR           1
-#define H_SET_MODE_RESOURCE_SET_DAWR            2
+#define H_SET_MODE_RESOURCE_SET_DAWR0           2
 #define H_SET_MODE_RESOURCE_ADDR_TRANS_MODE     3
 #define H_SET_MODE_RESOURCE_LE                  4
 
diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index e73416da68..cd02d65303 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1459,10 +1459,10 @@ typedef PowerPCCPU ArchCPU;
 #define SPR_MPC_BAR           (0x09F)
 #define SPR_PSPB              (0x09F)
 #define SPR_DPDES             (0x0B0)
-#define SPR_DAWR              (0x0B4)
+#define SPR_DAWR0             (0x0B4)
 #define SPR_RPR               (0x0BA)
 #define SPR_CIABR             (0x0BB)
-#define SPR_DAWRX             (0x0BC)
+#define SPR_DAWRX0            (0x0BC)
 #define SPR_HFSCR             (0x0BE)
 #define SPR_VRSAVE            (0x100)
 #define SPR_USPRG0            (0x100)
diff --git a/target/ppc/translate_init.c.inc b/target/ppc/translate_init.c.inc
index c03a7c4f52..879e6df217 100644
--- a/target/ppc/translate_init.c.inc
+++ b/target/ppc/translate_init.c.inc
@@ -7748,12 +7748,12 @@ static void gen_spr_book3s_dbg(CPUPPCState *env)
 
 static void gen_spr_book3s_207_dbg(CPUPPCState *env)
 {
-    spr_register_kvm_hv(env, SPR_DAWR, "DAWR",
+    spr_register_kvm_hv(env, SPR_DAWR0, "DAWR0",
                         SPR_NOACCESS, SPR_NOACCESS,
                         SPR_NOACCESS, SPR_NOACCESS,
                         &spr_read_generic, &spr_write_generic,
                         KVM_REG_PPC_DAWR, 0x00000000);
-    spr_register_kvm_hv(env, SPR_DAWRX, "DAWRX",
+    spr_register_kvm_hv(env, SPR_DAWRX0, "DAWRX0",
                         SPR_NOACCESS, SPR_NOACCESS,
                         SPR_NOACCESS, SPR_NOACCESS,
                         &spr_read_generic, &spr_write_generic,
-- 
2.17.1

