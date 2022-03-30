Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96024EC43A
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 14:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbiC3Mgy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Mar 2022 08:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344659AbiC3MfV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Mar 2022 08:35:21 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7947B554;
        Wed, 30 Mar 2022 05:21:02 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22UAFswN030947;
        Wed, 30 Mar 2022 12:20:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pyu4O5lMMU/BUfHgswvm5ffmgsd3h8dI5XjfpWkeku4=;
 b=rMzTJlRksFsJe0Ryrk6DwGZgmdDLcKfLqudV/sFG6iRKAmGpMgk/CTJMY/dnz8PVxC+P
 YXzufNHYSwNk7wJkgX/x7nR7fto4fgoqTkBji7i1/VUESTEgjwmaYCiMqG9Z0p913ndN
 XMRK7g0UTLFwnvELlJn1XRyEy+xDx+SpY+TVsEPRhVCh8CP4eRXQ7BTrucHnEVdiVp3B
 hW+WVbURkXSPrOARxVDHg+SRA9xdGppk1hF4whGxkjOXCgt7PBO7T9wUZZIGgeUtiW2d
 XMMjr1BjQgrISwySoKA247//v/UDTNSXMX1pneSXa0E5cVSenouioBDynwL2eHofQvY/ 6A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f4na5tjj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:42 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22UC3dGi014382;
        Wed, 30 Mar 2022 12:20:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f4na5tjhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22UBxAot021925;
        Wed, 30 Mar 2022 12:20:40 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf8y9am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 30 Mar 2022 12:20:39 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22UCKgw545482326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 30 Mar 2022 12:20:42 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C413342045;
        Wed, 30 Mar 2022 12:20:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 33EEB42047;
        Wed, 30 Mar 2022 12:20:36 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 30 Mar 2022 12:20:36 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com
Subject: [PATCH v3 8/9] Documentation: virt: Protected virtual machine dumps
Date:   Wed, 30 Mar 2022 12:19:51 +0000
Message-Id: <20220330121952.105725-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330121952.105725-1-frankja@linux.ibm.com>
References: <20220330121952.105725-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: t-pFadYO-60xlBTZlrlHYa7acc4lWyBz
X-Proofpoint-GUID: ZEOVKLz8KoRAPxqZOYMZxDl0Ai8Ne_mE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-30_04,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 spamscore=0 malwarescore=0 adultscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203300062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's add a documentation file which describes the dump process. Since
we only copy the UV dump data from the UV to userspace we'll not go
into detail here and let the party which processes the data describe
its structure.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virt/kvm/index.rst        |  1 +
 Documentation/virt/kvm/s390-pv-dump.rst | 60 +++++++++++++++++++++++++
 2 files changed, 61 insertions(+)
 create mode 100644 Documentation/virt/kvm/s390-pv-dump.rst

diff --git a/Documentation/virt/kvm/index.rst b/Documentation/virt/kvm/index.rst
index b6833c7bb474..32f3eed5fadb 100644
--- a/Documentation/virt/kvm/index.rst
+++ b/Documentation/virt/kvm/index.rst
@@ -20,6 +20,7 @@ KVM
    s390-diag
    s390-pv
    s390-pv-boot
+   s390-pv-dump
    timekeeping
    vcpu-requests
 
diff --git a/Documentation/virt/kvm/s390-pv-dump.rst b/Documentation/virt/kvm/s390-pv-dump.rst
new file mode 100644
index 000000000000..6fe7560e10b1
--- /dev/null
+++ b/Documentation/virt/kvm/s390-pv-dump.rst
@@ -0,0 +1,60 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================================
+s390 (IBM Z) Protected Virtualization dumps
+===========================================
+
+Summary
+-------
+
+Dumping a VM is an essential tool for debugging problems inside
+it. This is especially true when a protected VM runs into trouble as
+there's no way to access its memory and registers from the outside
+while it's running.
+
+However when dumping a protected VM we need to maintain its
+confidentiality until the dump is in the hands of the VM owner who
+should be the only one capable of analysing it.
+
+The confidentiality of the VM dump is ensured by the Ultravisor who
+provides an interface to KVM over which encrypted CPU and memory data
+can be requested. The encryption is based on the Customer
+Communication Key which is the key that's used to encrypt VM data in a
+way that the customer is able to decrypt.
+
+
+Dump process
+------------
+
+A dump is done in 3 steps:
+
+Initiation
+This step initializes the dump process, generates cryptographic seeds
+and extracts dump keys with which the VM dump data will be encrypted.
+
+Data gathering
+Currently there are two types of data that can be gathered from a VM:
+the memory and the vcpu state.
+
+The vcpu state contains all the important registers, general, floating
+point, vector, control and tod/timers of a vcpu. The vcpu dump can
+contain incomplete data if a vcpu is dumped while an instruction is
+emulated with help of the hypervisor. This is indicated by a flag bit
+in the dump data. For the same reason it is very important to not only
+write out the encrypted vcpu state, but also the unencrypted state
+from the hypervisor.
+
+The memory state is further divided into the encrypted memory and its
+encryption tweaks / status flags. The encrypted memory can simply be
+read once it has been exported. The time of the export does not matter
+as no re-encryption is needed. Memory that has been swapped out and
+hence was exported can be read from the swap and written to the dump
+target without need for any special actions.
+
+The tweaks / status flags for the exported pages need to be requested
+from the Ultravisor.
+
+Finalization
+The finalization step will provide the data needed to be able to
+decrypt the vcpu and memory data and end the dump process. When this
+step completes successfully a new dump initiation can be started.
-- 
2.32.0

