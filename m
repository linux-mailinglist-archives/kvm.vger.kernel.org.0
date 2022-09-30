Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7E45F0CE7
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiI3OCG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 10:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiI3OCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 10:02:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0630C2ED7B;
        Fri, 30 Sep 2022 07:01:59 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28UDnWMD010904;
        Fri, 30 Sep 2022 14:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=9H6gPS9DxeRf+DjTLb+9upWstioPtya8yTIcCoBHzfQ=;
 b=h2vvPMBYh2T3VJABuZ0Cf+4eAuIjiTKgz4d7fYJs4fZ4UQpoQIqkzJJpXTgRrkk98WFX
 uhu9ubs43S4Bm9skD1hVBAqKGH7Z//bMfBmUwyGJq6bOUdFWqIw7oX8sceOL602DlUr7
 q+TWLLQLi885/Pjko/G7Qk675d6qullQtBfd7B8zECc5n/uGR3h7xXBUDiWAiHW7nj6d
 OF1g59hE9wgHR98Br8MpucA4SiE8X6d8W02pMvZpJjAGM/0/c6Z7Et7YgJ9YVq2AJR0Q
 5jfMThBQBRGKzRwi/nSKnbzLRINVfJaqQUuhOVaWXIarOgnPc066MAJTh6wRhvdz/qVq aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1pagd63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:58 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28UDnYNY010997;
        Fri, 30 Sep 2022 14:01:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jx1pagd4g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:57 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28UDq4wW005527;
        Fri, 30 Sep 2022 14:01:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3juapunus0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 14:01:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28UE1q5E393958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 14:01:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D982A4040;
        Fri, 30 Sep 2022 14:01:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A8C4A404D;
        Fri, 30 Sep 2022 14:01:52 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.242])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Sep 2022 14:01:51 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v14 2/6] KVM: s390: pv: api documentation for asynchronous destroy
Date:   Fri, 30 Sep 2022 16:01:46 +0200
Message-Id: <20220930140150.37463-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930140150.37463-1-imbrenda@linux.ibm.com>
References: <20220930140150.37463-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: an_0eYrLoHitXxzRZOlJ9S99Mn4hBaM3
X-Proofpoint-GUID: fBASDQLgNuBdsqkhhKQIDR3UW2t0qQtD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-30_04,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 impostorscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209300086
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
---
 Documentation/virt/kvm/api.rst | 37 ++++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index abd7c32126ce..5775e5fbfd18 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5161,10 +5161,13 @@ KVM_PV_ENABLE
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
@@ -5287,6 +5290,32 @@ KVM_PV_DUMP
     authentication tag all of which are needed to decrypt the dump at a
     later time.
 
+KVM_PV_ASYNC_CLEANUP_PREPARE
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
 
 4.126 KVM_X86_SET_MSR_FILTER
 ----------------------------
-- 
2.37.3

