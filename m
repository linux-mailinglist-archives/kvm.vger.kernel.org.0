Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8482055E720
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 18:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347069AbiF1N5M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 09:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346958AbiF1N4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 09:56:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BBD338AB;
        Tue, 28 Jun 2022 06:56:32 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25SDlFFX020827;
        Tue, 28 Jun 2022 13:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=uN8IBWDeFws7FG2qgqc9xpszs7wwiYuL6XNWN8ORTZI=;
 b=TGHi2Vmq+v5rXbUMbEVmVodsykp0DaVDSoMRYnFtSfXa9GKVde/ZtZwxBIX+teu/wgBO
 dqq5yBeaqjVOcOfZv9aQwX7fWvnY4jh96DD1vWoKdNJZcgPpt2zQjXfO8b4WbmBcK4tZ
 uz3vEoR+rNfmp0+3vzowFi/2nI1TLElY/pv5AAF0l+bknMTcrUg87fapS+kuv37N8gTh
 qGEOBbNciCHb/htO3dzYT0Hvkb2NyHsjR3nijunK3OHlAhWK808vNmWv7OjjoOym3uKo
 VqeEu0NQWLOtViZiE/0pEnt73F0YdRikqqCYTuLPD8IjOF8x9MWZ3QoyO5svJvIxxD6/ /Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02u7rayp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:31 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25SDlgdX022504;
        Tue, 28 Jun 2022 13:56:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h02u7raxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:30 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25SDp6Jt021923;
        Tue, 28 Jun 2022 13:56:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3gwsmj4yw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Jun 2022 13:56:29 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25SDuQcS13042116
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jun 2022 13:56:26 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FCA04C040;
        Tue, 28 Jun 2022 13:56:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA6844C046;
        Tue, 28 Jun 2022 13:56:25 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.40])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Jun 2022 13:56:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v12 14/18] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Tue, 28 Jun 2022 15:56:15 +0200
Message-Id: <20220628135619.32410-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628135619.32410-1-imbrenda@linux.ibm.com>
References: <20220628135619.32410-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IVpjwEUMZ69jS7PK65eDcUKz1cV5s1iW
X-Proofpoint-ORIG-GUID: 8Dk9q-u5PXduNRIES8iaHTeFVAqyHvw4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-06-28_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206280057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for the new commands added to the KVM_S390_PV_COMMAND
ioctl.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 11e00a46c610..24f91ae0e494 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5143,11 +5143,13 @@ KVM_PV_ENABLE
   =====      =============================
 
 KVM_PV_DISABLE
-
   Deregister the VM from the Ultravisor and reclaim the memory that
   had been donated to the Ultravisor, making it usable by the kernel
-  again.  All registered VCPUs are converted back to non-protected
-  ones.
+  again. All registered VCPUs are converted back to non-protected
+  ones. If a previous VM had been set aside for asynchonous teardown
+  with KVM_PV_ASYNC_CLEANUP_PREPARE and not actually torn down with
+  KVM_PV_ASYNC_CLEANUP_PERFORM, it will be torn down in this call
+  together with the current VM.
 
 KVM_PV_VM_SET_SEC_PARMS
   Pass the image header from VM memory to the Ultravisor in
@@ -5160,6 +5162,29 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+KVM_PV_ASYNC_CLEANUP_PREPARE
+  Prepare the current protected VM for asynchronous teardown. Most
+  resources used by the current protected VM will be set aside for a
+  subsequent asynchronous teardown. The current protected VM will then
+  resume execution immediately as non-protected. There can be at most
+  one protected VM set aside at any time. If a protected VM had
+  already been set aside without starting the asynchronous teardown
+  process, this call will fail. In that case, the userspace process
+  should issue a normal KVM_PV_DISABLE. The resources set aside with
+  this call will need to be cleaned up with a subsequent call to
+  KVM_PV_ASYNC_CLEANUP_PERFORM or KVM_PV_DISABLE, otherwise they will
+  be cleaned up when KVM terminates.
+
+KVM_PV_ASYNC_CLEANUP_PERFORM
+  Tear down the protected VM previously set aside with
+  KVM_PV_ASYNC_CLEANUP_PREPARE. The resources that had been set aside
+  will be freed during the execution of this command. This PV command
+  should ideally be issued by userspace from a separate thread. If a
+  fatal signal is received (or the process terminates naturally), the
+  command will terminate immediately without completing, and the normal
+  KVM shutdown procedure will take care of cleaning up all remaining
+  protected VMs.
+
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
-- 
2.36.1

