Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCD8638A75
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 13:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiKYMnR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 07:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiKYMnI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 07:43:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6073C1AD82;
        Fri, 25 Nov 2022 04:43:07 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APCUkIO030058;
        Fri, 25 Nov 2022 12:43:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=LQ8G9aExNT8Zyq3aYV+7igQZJ8LQk9rq/MHK/Jx1ZVs=;
 b=YFNs8cIq62/+mEqyMdPJYIoq68aKWXI0VwHoi81xyrsiwmc5ul11TV1BAz5RvNN0OXUo
 gwchAHr5PTB6ycj8k9Nril9pBG3pPwDptqC/hDgAeTVhY28UxjhJ+qlssfkcZvDi6pqO
 zWxGCCc4vAw89tiLiGqlECmsIw2QrzH3mlhvbtpP8WjOHxPGU6jPiTVkyfo5uGvfUwQ7
 gde2Home9/9YxSwCtVgthJcIhDKUHG4/uhJqXwurHDU1x0sDPAgiuQ0VXmaRUCEk1TBT
 LX5KyDP14ZlS8kWAB5NpjDHwPoTS2uD6sEZPzzZzY+2MIR19pWs8YDEGP1XHxlkm/0UK pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wsc86ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:06 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2APCh6FC009189;
        Fri, 25 Nov 2022 12:43:06 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m2wsc86by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:05 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2APCaoWX024016;
        Fri, 25 Nov 2022 12:43:04 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3kxps96xks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 12:43:04 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2APCh1VJ5702242
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Nov 2022 12:43:01 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01BFB4C046;
        Fri, 25 Nov 2022 12:43:01 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8589F4C044;
        Fri, 25 Nov 2022 12:43:00 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.63.115])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 25 Nov 2022 12:43:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [GIT PULL 09/15] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Fri, 25 Nov 2022 13:39:41 +0100
Message-Id: <20221125123947.31047-10-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221125123947.31047-1-frankja@linux.ibm.com>
References: <20221125123947.31047-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: y-74zSwOVq25Q9tbEs18LP3WOgR1xABh
X-Proofpoint-ORIG-GUID: GSr5yranmBQmFkkfOZ1gz9_P8VMcPYWz
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_04,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Add documentation for the new commands added to the KVM_S390_PV_COMMAND
ioctl.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20221111170632.77622-3-imbrenda@linux.ibm.com
Message-Id: <20221111170632.77622-3-imbrenda@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/api.rst | 41 ++++++++++++++++++++++++++++++----
 1 file changed, 37 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..9175d41e8081 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5163,10 +5163,13 @@ KVM_PV_ENABLE
   =====      =============================
 
 KVM_PV_DISABLE
-  Deregister the VM from the Ultravisor and reclaim the memory that
-  had been donated to the Ultravisor, making it usable by the kernel
-  again.  All registered VCPUs are converted back to non-protected
-  ones.
+  Deregister the VM from the Ultravisor and reclaim the memory that had
+  been donated to the Ultravisor, making it usable by the kernel again.
+  All registered VCPUs are converted back to non-protected ones. If a
+  previous protected VM had been prepared for asynchonous teardown with
+  KVM_PV_ASYNC_CLEANUP_PREPARE and not subsequently torn down with
+  KVM_PV_ASYNC_CLEANUP_PERFORM, it will be torn down in this call
+  together with the current protected VM.
 
 KVM_PV_VM_SET_SEC_PARMS
   Pass the image header from VM memory to the Ultravisor in
@@ -5289,6 +5292,36 @@ KVM_PV_DUMP
     authentication tag all of which are needed to decrypt the dump at a
     later time.
 
+KVM_PV_ASYNC_CLEANUP_PREPARE
+  :Capability: KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
+
+  Prepare the current protected VM for asynchronous teardown. Most
+  resources used by the current protected VM will be set aside for a
+  subsequent asynchronous teardown. The current protected VM will then
+  resume execution immediately as non-protected. There can be at most
+  one protected VM prepared for asynchronous teardown at any time. If
+  a protected VM had already been prepared for teardown without
+  subsequently calling KVM_PV_ASYNC_CLEANUP_PERFORM, this call will
+  fail. In that case, the userspace process should issue a normal
+  KVM_PV_DISABLE. The resources set aside with this call will need to
+  be cleaned up with a subsequent call to KVM_PV_ASYNC_CLEANUP_PERFORM
+  or KVM_PV_DISABLE, otherwise they will be cleaned up when KVM
+  terminates. KVM_PV_ASYNC_CLEANUP_PREPARE can be called again as soon
+  as cleanup starts, i.e. before KVM_PV_ASYNC_CLEANUP_PERFORM finishes.
+
+KVM_PV_ASYNC_CLEANUP_PERFORM
+  :Capability: KVM_CAP_S390_PROTECTED_ASYNC_DISABLE
+
+  Tear down the protected VM previously prepared for teardown with
+  KVM_PV_ASYNC_CLEANUP_PREPARE. The resources that had been set aside
+  will be freed during the execution of this command. This PV command
+  should ideally be issued by userspace from a separate thread. If a
+  fatal signal is received (or the process terminates naturally), the
+  command will terminate immediately without completing, and the normal
+  KVM shutdown procedure will take care of cleaning up all remaining
+  protected VMs, including the ones whose teardown was interrupted by
+  process termination.
+
 4.126 KVM_XEN_HVM_SET_ATTR
 --------------------------
 
-- 
2.38.1

