Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89E34A9C78
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 16:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376587AbiBDPy3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 10:54:29 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:9604 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376367AbiBDPyH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 10:54:07 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214E8K96006648;
        Fri, 4 Feb 2022 15:54:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Quhfip8/AtFST9/2dPpR4TNIuCHI1BKc+UcODKSOCY4=;
 b=I3zj8N+CMVcQsYtnVm/PtWkR/oD6INfgE3k7srm+suSi3s0nW0XZBfAwbUVPp6LlC+Py
 AUCbHb1gB0h8KKjMoUZufQfIeuPomtI5QG8RNUsiP0hrIauSDolSbhynyQrOpxqioA+K
 HRT0zNTPHBjF3yy6JENcGMJuDuuWIgiliNlLnRHShNa5BRj4R3t+t3kRwhLFLKxExTLJ
 V6NG4/Bgv0h8Fq0oBsH45vgJX/xmrQfQA2j4GfqmeMC+WLbImpPEgeSJ7MPyluSf4HSY
 sk836VNv6HdXOFQA6ud1ujbYCUB5K6hW2Bwr8DRPbUadQfnnFcu2K1XyFvh7o5wnQN9g 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12gahg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:07 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214EFK8A013356;
        Fri, 4 Feb 2022 15:54:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12gagk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214Fn6uD005890;
        Fri, 4 Feb 2022 15:54:04 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3e0r0spad1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 15:54:04 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214Fs0hR42140078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 15:54:00 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 04B57AE05D;
        Fri,  4 Feb 2022 15:54:00 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 76293AE051;
        Fri,  4 Feb 2022 15:53:59 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.8.50])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 15:53:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com
Subject: [PATCH v7 15/17] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Fri,  4 Feb 2022 16:53:47 +0100
Message-Id: <20220204155349.63238-16-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220204155349.63238-1-imbrenda@linux.ibm.com>
References: <20220204155349.63238-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2ba7bUvp14zc4EPa4LENPk8IiL2usfre
X-Proofpoint-ORIG-GUID: EJQtjSdphsYJi57EaOXQJbla3dlWBgrA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for the new commands added to the KVM_S390_PV_COMMAND
ioctl.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a4267104db50..3b9068aceead 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5010,11 +5010,13 @@ KVM_PV_ENABLE
   =====      =============================
 
 KVM_PV_DISABLE
-
   Deregister the VM from the Ultravisor and reclaim the memory that
   had been donated to the Ultravisor, making it usable by the kernel
-  again.  All registered VCPUs are converted back to non-protected
-  ones.
+  again. All registered VCPUs are converted back to non-protected
+  ones. If a previous VM had been prepared for asynchonous teardown
+  with KVM_PV_ASYNC_DISABLE_PREPARE and not actually torn down with
+  KVM_PV_ASYNC_DISABLE, it will be torn down in this call together with
+  the current VM.
 
 KVM_PV_VM_SET_SEC_PARMS
   Pass the image header from VM memory to the Ultravisor in
@@ -5027,6 +5029,19 @@ KVM_PV_VM_VERIFY
   Verify the integrity of the unpacked image. Only if this succeeds,
   KVM is allowed to start protected VCPUs.
 
+KVM_PV_ASYNC_DISABLE_PREPARE
+  Prepare the current protected VM for asynchronous teardown. The current
+  VM will then continue immediately as non-protected. If a protected VM had
+  already been set aside without starting the teardown process, this call
+  will fail. In this case the userspace process should issue a normal
+  KVM_PV_DISABLE.
+
+KVM_PV_ASYNC_DISABLE
+  Tear down the protected VM previously set aside for asynchronous teardown.
+  This PV command should ideally be issued by userspace from a separate
+  thread. If a fatal signal is received (or the process terminates
+  naturally), the command will terminate immediately without completing.
+
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
 
-- 
2.34.1

