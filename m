Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E6A626003
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 18:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiKKRGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 12:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbiKKRGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 12:06:48 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD34729A8;
        Fri, 11 Nov 2022 09:06:46 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2ABGi6Na022130;
        Fri, 11 Nov 2022 17:06:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Kt5iBuHvmiPQOHPJcw45GaWZmjl/3eupPWDl+qKrt7Q=;
 b=Z242fP4uAPXD0WAkEAMZiIDyNfaxQoUNaxk+1Ulu9Jur/YEcabhCH+JqwExJYHUAgxDc
 615qo0RBff7m6A/srDDk3UQxdY7b9KJQdOFdJ4udGLoJA8S0xdGx5YPks0YgJ5NcVZrs
 yRlFyoCn6S4Ay8Zec/pA00q4vawAo/ZX2I8Er0FfnGUYsm91DKwbNwfIcrV20djNvb+M
 WiR5iKd/LHTKrIDq2OZDdyNvY2WCCuZw+rGS9/FpBQTd1LL0f2TKDVO6n5S/C1AFFb7S
 ovY4MuwloD+ZOA+X1w/rXm3CKx3W1IHhWA8sGjRdb5iDMqtYMIsasplNKYBuy4vm/uqt Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kst5wghmr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:45 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ABGjbL6025855;
        Fri, 11 Nov 2022 17:06:44 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kst5wghkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:44 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ABH6NHu031600;
        Fri, 11 Nov 2022 17:06:42 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3krcbr2car-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 17:06:42 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ABH6dmb60817736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 17:06:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60E2E4C04E;
        Fri, 11 Nov 2022 17:06:39 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D35C04C040;
        Fri, 11 Nov 2022 17:06:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.171.65.74])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 11 Nov 2022 17:06:38 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v16 2/6] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Fri, 11 Nov 2022 18:06:28 +0100
Message-Id: <20221111170632.77622-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221111170632.77622-1-imbrenda@linux.ibm.com>
References: <20221111170632.77622-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gm5U7jm0hEf8K-SaSSvi9BVhpAFnNY1P
X-Proofpoint-ORIG-GUID: MFJVpO3E4Or6x9ikrRlNN5V7v5qP5y5i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_08,2022-11-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add documentation for the new commands added to the KVM_S390_PV_COMMAND
ioctl.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
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

