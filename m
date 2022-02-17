Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C96854B9C93
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 10:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238913AbiBQJ5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 04:57:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiBQJ5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 04:57:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C465F56;
        Thu, 17 Feb 2022 01:57:17 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21H8kAdt009839;
        Thu, 17 Feb 2022 09:57:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=e0/vzfS1t4CjBCHf0WsLr/hXN/E5z9rydlFbYlAVCk8=;
 b=iXrwUzSJvsGEA5LwtLL+U5f8Zxu1ucKaisLY6rarvMfcpH1zizZaDphtOq41zTrNFo7X
 iH0OwyJU6b48dGeoiULaif6Y9/D1c6v8WoxxMFujR2K7XnCL/mFcfm3G0Sp2BiLs0lBc
 5FThlTvtPSf0xpOGZKcW1hWdbiXgSIgcJtNqHlvxTaf0sJQrLd87yCkDw+XQX/s5RvzO
 AkRGfXZxM/HmpvSHUetWAEJLV7ae2TAzKVIhmR0x2SG367ugKsTbzjJplLXsOaLQb2JP
 ptqvATpQPeYTEgNoG6ggX2BBIcK8KDPMQ+UW+eRB98uAed8wGGWbM3zZqqjKexTWrMuw Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9k53hc7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 09:57:16 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21H9tpnq031342;
        Thu, 17 Feb 2022 09:57:16 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9k53hc77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 09:57:15 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21H9u1kh029961;
        Thu, 17 Feb 2022 09:57:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3e64haeb0t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 09:57:13 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21H9vAIK26804530
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 09:57:10 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB2B5A4053;
        Thu, 17 Feb 2022 09:57:10 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ED3CBA4040;
        Thu, 17 Feb 2022 09:57:09 +0000 (GMT)
Received: from li-c6ac47cc-293c-11b2-a85c-d421c8e4747b.ibm.com.com (unknown [9.171.42.121])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 09:57:09 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, cohuck@redhat.com,
        david@redhat.com, thuth@redhat.com, imbrenda@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, pmorel@linux.ibm.com,
        wintera@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v7 0/1] s390x: KVM: CPU Topology
Date:   Thu, 17 Feb 2022 10:59:22 +0100
Message-Id: <20220217095923.114489-1-pmorel@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: X7TduB7pMtF7m4TXqbylTVqDkkpt5qeI
X-Proofpoint-GUID: wOI_yo9VyCV1mmzm1utuVMEZg5v-GNPz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_03,2022-02-16_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

This is only a new rebase to keep on sync with Linux development.

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

- first we report CPU hotplug
- modification of the CPU mask inside sockets

In future development we will provide:

- handling of shared CPUs
- reporting of the CPU Type
- reporting of the polarization


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
  s390x: KVM: guest support for topology function

 Documentation/virt/kvm/api.rst   | 16 +++++++++++
 arch/s390/include/asm/kvm_host.h | 12 ++++++--
 arch/s390/kvm/kvm-s390.c         | 48 +++++++++++++++++++++++++++++++-
 arch/s390/kvm/kvm-s390.h         | 25 +++++++++++++++++
 arch/s390/kvm/priv.c             | 14 +++++++---
 arch/s390/kvm/vsie.c             |  3 ++
 include/uapi/linux/kvm.h         |  1 +
 7 files changed, 111 insertions(+), 8 deletions(-)

-- 
2.27.0

