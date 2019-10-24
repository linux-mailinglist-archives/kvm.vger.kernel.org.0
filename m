Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF0AE30C4
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436522AbfJXLmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:14 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22610 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2407218AbfJXLmM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:12 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBbDTB174593
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:11 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vt294fext-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:11 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:08 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:05 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfUmi40042806
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:41:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52E5352054;
        Thu, 24 Oct 2019 11:42:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BB6315204F;
        Thu, 24 Oct 2019 11:42:01 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 11/37] DOCUMENTATION: protvirt: Interrupt injection
Date:   Thu, 24 Oct 2019 07:40:33 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0028-0000-0000-000003AEC514
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0029-0000-0000-00002470F70B
Message-Id: <20191024114059.102802-12-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=691 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Interrupt injection has changed a lot for protected guests, as KVM
can't access the cpus' lowcores. New fields in the state description,
like the interrupt injection control, and masked values safeguard the
guest from KVM.

Let's add some documentation to the interrupt injection basics for
protected guests.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 Documentation/virtual/kvm/s390-pv.txt | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/virtual/kvm/s390-pv.txt b/Documentation/virtual/kvm/s390-pv.txt
index 86ed95f36759..e09f2dc5f164 100644
--- a/Documentation/virtual/kvm/s390-pv.txt
+++ b/Documentation/virtual/kvm/s390-pv.txt
@@ -21,3 +21,30 @@ normally needed to be able to run a VM, some changes have been made in
 SIE behavior and fields have different meaning for a PVM. SIE exits
 are minimized as much as possible to improve speed and reduce exposed
 guest state.
+
+
+Interrupt injection:
+
+Interrupt injection is safeguarded by the Ultravisor and, as KVM lost
+access to the VCPUs' lowcores, is handled via the format 4 state
+description.
+
+Machine check, external, IO and restart interruptions each can be
+injected on SIE entry via a bit in the interrupt injection control
+field (offset 0x54). If the guest cpu is not enabled for the interrupt
+at the time of injection, a validity interception is recognized. The
+interrupt's data is transported via parts of the interception data
+block.
+
+Program and Service Call exceptions have another layer of
+safeguarding, they are only injectable, when instructions have
+intercepted into KVM and such an exception can be an emulation result.
+
+
+Mask notification interceptions:
+As a replacement for the lctl(g) and lpsw(e) interception, two new
+interception codes have been introduced. One which tells us that CRs
+0, 6 or 14 have been changed and therefore interrupt masking might
+have changed. And one for PSW bit 13 changes. The CRs and the PSW in
+the state description only contain the mask bits and no further info
+like the current instruction address.
-- 
2.20.1

