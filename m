Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631EE5AC149
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 22:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiICUGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 16:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiICUGG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 16:06:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B544DB0E;
        Sat,  3 Sep 2022 13:06:03 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2839EGQB031956;
        Sat, 3 Sep 2022 20:06:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=DvtTk1Z/ESP+39Y8V1aV0Jj1x/WVB/9tkpYI5Y8WQPA=;
 b=pZSp6QJ8sJxouzIrBcgGoyhKRUsxh8Gkz7M7iedc3WmPmrNOCoqAmjYpmMTO5/BrfZoO
 PGidL0AumTumJJ0Tk76fzFgb54+36dVNWz69ron937qSX5ebQJ+dj1DhF8nrHiZsaAki
 ziA3/31ioQ4eL81sd9xsYjERqJIWGh298CUw75yMzlUiV97gl9VjrFCkuLXcJ4v8ni1Z
 NotYlHWgDKR9lY7RnBby7o2tExfy/shPuoud6ReqiPTbvRgHF1HxIzaBr/zGgX67DQ2H
 7pl6jodzdgqNh4g+Ybl854KZG67lsCpiFqhTZZa9EUugeGUli0evBXoRoqBH4Ouc/Hb/ Ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwbc101k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Sep 2022 20:05:59 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 283IkqjE016402;
        Sat, 3 Sep 2022 20:05:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc0ma52-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Sep 2022 20:05:58 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 283K5wZM018676;
        Sat, 3 Sep 2022 20:05:58 GMT
Received: from alaljime-amd-bm-e3.allregionalphxs.osdevelopmenphx.oraclevcn.com (alaljime-amd-bm-e3.allregionalphxs.osdevelopmenphx.oraclevcn.com [100.107.196.22])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3jbwc0ma4y-1;
        Sat, 03 Sep 2022 20:05:58 +0000
From:   Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, alejandro.j.jimenez@oracle.com
Subject: [PATCH 1/1] KVM: x86: Allow emulation of EOI writes with AVIC enabled
Date:   Sat,  3 Sep 2022 20:05:57 +0000
Message-Id: <20220903200557.1719-1-alejandro.j.jimenez@oracle.com>
X-Mailer: git-send-email 2.34.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-03_10,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209030104
X-Proofpoint-ORIG-GUID: oQMLQonpWEv3fjYMeJ-EE-4jul812gHa
X-Proofpoint-GUID: oQMLQonpWEv3fjYMeJ-EE-4jul812gHa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section 15.29.9.2 - AVIC Access to un-accelerated vAPIC register
of the AMD APM [1]:

"A guest access to an APIC register that is not accelerated by AVIC results in
a #VMEXIT with the exit code of AVIC_NOACCEL. This fault is also generated if
an EOI is attempted when the highest priority in-service interrupt is set for
level-triggered mode."

This is also stated in Table 15-22 - Guest vAPIC Register Access Behavior,
confirming that AVIC hardware traps on EOI writes for level triggered
interrupts, and leading to the following call stack:

avic_unaccelerated_access_interception()
-> avic_unaccel_trap_write()
  -> kvm_apic_write_nodecode()
    -> kvm_lapic_msr_read()
      -> kvm_lapic_reg_read()

In kvm_lapic_reg_read(), the APIC_EOI offset (0xb0) is not allowed as valid, so
the error returned triggers the assertion introduced by 'commit 70c8327c11c6
("KVM: x86: Bug the VM if an accelerated x2APIC trap occurs on a "bad" reg")'
and kills the VM.

Add APIC_EOI offset to the valid mask in kvm_lapic_reg_read() to allow the
emulation of EOI behavior for level triggered interrupts.

[1] https://www.amd.com/system/files/TechDocs/24593.pdf

Fixes: 0105d1a52640 ("KVM: x2apic interface to lapic")
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
---

I am unsure as to the proper commit to use for the Fixes: tag. Technically the
issue was introduced by the initial SVM AVIC commits in 2016, since they failed
to add the EOI offset to the valid mask.

To be safe, I used the commit that introduces the valid mask, but that is
somewhat misleading since at the time AVIC was not available, and I believe that
Intel posted interrupts implementation does not require access to EOI offset in
this code.

Please correct Fixes: tag if necessary.
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 9dda989a1cf0..61041fecfa89 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1452,6 +1452,7 @@ static int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		APIC_REG_MASK(APIC_LVR) |
 		APIC_REG_MASK(APIC_TASKPRI) |
 		APIC_REG_MASK(APIC_PROCPRI) |
+		APIC_REG_MASK(APIC_EOI) |
 		APIC_REG_MASK(APIC_LDR) |
 		APIC_REG_MASK(APIC_DFR) |
 		APIC_REG_MASK(APIC_SPIV) |
-- 
2.34.2

