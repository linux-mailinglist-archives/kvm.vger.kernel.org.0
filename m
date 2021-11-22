Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0A8458F38
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 14:14:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238812AbhKVNRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 08:17:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62638 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231444AbhKVNRP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 08:17:15 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AMDC27G002742;
        Mon, 22 Nov 2021 13:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=fJC015vFBTfk1PNLFlBZk1eXpgjC6YFxdvIGaxiMlhQ=;
 b=GMhBYtwkMf9FRswJaPEFBeO2V7Dp908W8yOdItWhYZm1fFxli7a1Kfh6xUhIxAqrLZA9
 JjQBYgSSKOhvlcIlJp1jk/0yF8fd7ie2oC3u+ElgDN5JDLtfvKVtqRVsGbw0r4M0r7u6
 v6mxnPJzJU8s0rejIKRneIea7/kww2LNiDcial1UIh1LkDqC5235tiaSfi5cY1Iusrco
 /KnFa+W1mItLqEDPqKdz2LtEK7wdTZgwVpEeXWid1F33fGCdA07Yyd16/CO6MGOp9Ops
 cCQldZTk/LutCvLbrdocS+oaX2BjQUSDSwKLwpUZpgCsO4mTvWUNInH21RT75YeZcOsR 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgbvf017y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 13:14:08 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AMDC1V1002700;
        Mon, 22 Nov 2021 13:14:08 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3cgbvf017d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 13:14:08 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AMD8Bli015555;
        Mon, 22 Nov 2021 13:14:06 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3cern9dwwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 22 Nov 2021 13:14:06 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AMDE2TS1376780
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 Nov 2021 13:14:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF8D311C04A;
        Mon, 22 Nov 2021 13:14:02 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FD7C11C050;
        Mon, 22 Nov 2021 13:14:02 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.49.3])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 22 Nov 2021 13:14:02 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com
Subject: [PATCH v5 0/1] s390x: KVM: CPU Topology
Date:   Mon, 22 Nov 2021 14:14:42 +0100
Message-Id: <20211122131443.66632-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mq5W-L8SbTEVSsP8NV-eNoBzj5ZHTn-Q
X-Proofpoint-GUID: YOHRs8YV8-3kW07di_NtAiB8y2e6D6mO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-22_06,2021-11-22_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxscore=0 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0
 clxscore=1011 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111220069
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This new series add the implementation of interpretation for
the PTF instruction.

The series provides:
1- interception of the STSI instruction forwarding the CPU topology
2- interpretation of the PTF instruction
3- a KVM capability for the userland hypervisor to ask KVM to 
   setup PTF interpretation.


0- Foreword

The S390 CPU topology is reported using two instructions:
- PTF, to get information if the CPU topology did change since last
  PTF instruction or a subsystem reset.
- STSI, to get the topology information, consisting of the topology
  of the CPU inside the sockets, of the sockets inside the books etc.

The PTF(2) instruction report a change if the STSI(15.1.2) instruction
will report a difference with the last STSI(15.1.2) instruction*.
With the SIE interpretation, the PTF(2) instruction will report a
change to the guest if the host sets the SCA.MTCR bit.

*The STSI(15.1.2) instruction reports:
- The cores address within a socket
- The polarization of the cores
- The CPU type of the cores
- If the cores are dedicated or not

We decided to implement the CPU topology for S390 in several steps:
- first step we provide a correct topology only for dedicated CPUs
  and vCPUs. We provide the basic framework and report topology change
  only when a new vCPU is plugged in a monotonic scheme.

In future development we will provide:
- NUMA handling, allowing holes inside the cores bitmap reported by
  STSI(15.1.2)
- dedicated versus shared CPUs handling
- vCPU migration on a different CPU

We will ignore the following changes inside a STSI(15.1.2):
- polarization: only horizontal polarization is currently used in Linux.
- CPU Type: only IFL Type are supported in Linux


1- Interception of STSI

To provide Topology information to the guest through the STSI
instruction, we forward STSI with Function Code 15 to the
userland hypervisor which will take care to provide the right
information to the guest.

To let the guest use both the PTF instruction  to check if a topology
change occurred and sthe STSI_15.x.x instruction we add a new KVM
capability to enable the topology facility.

2- Interpretation of PTF with FC(2)

The PTF instruction will report a topology change if there is any change
with a previous STSI(15.1.2) SYSIB.
Changes inside a STSI(15.1.2) SYSIB occur if CPU bits are set or clear
inside the CPU Topology List Entry CPU mask field, which happens with
changes in CPU polarization, dedication, CPU types and adding or
removing CPUs in a socket.

The reporting to the guest is done using the Multiprocessor
Topology-Change-Report (MTCR) bit of the utility entry of the guest's
SCA which will be cleared during the interpretation of PTF.

To check if the topology has been modified we use a new field of the
arch vCPU prev_cpu, to save the previous real CPU ID at the end of a
schedule and verify on next schedule that the CPU used is in the same
socket, this field is initialized to -1 on vCPU creation.


Regards,
Pierre

Pierre Morel (1):
  s390x: KVM: accept STSI for CPU topology information

 Documentation/virt/kvm/api.rst   | 16 ++++++++++
 arch/s390/include/asm/kvm_host.h | 14 ++++++---
 arch/s390/kvm/kvm-s390.c         | 52 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/priv.c             |  7 ++++-
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 6 files changed, 87 insertions(+), 6 deletions(-)

-- 
2.27.0

Changelog:

from v4 tp v5

- modify the way KVM_CAP is tested to be OK with vsie
  (David)

from v3 to v4

- squatch both patches
  (David)

- Added Documentation
  (David)

- Modified the detection for new vCPUs
  (Pierre)

from v2 to v3

- use PTF interpretation
  (Christian)

- optimize arch_update_cpu_topology using PTF
  (Pierre)

from v1 to v2:

- Add a KVM capability to let QEMU know we support PTF and STSI 15
  (David)

- check KVM facility 11 before accepting STSI fc 15
  (David)

- handle all we can in userland
  (David)

- add tracing to STSI fc 15
  (Connie)

