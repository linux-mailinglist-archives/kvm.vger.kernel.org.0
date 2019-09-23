Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36AE3BB831
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 17:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732528AbfIWPnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 11:43:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:28742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728252AbfIWPnm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Sep 2019 11:43:42 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8NFgB0P032594
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 11:43:40 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v70cv9c95-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 11:43:39 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <groug@kaod.org>;
        Mon, 23 Sep 2019 16:43:37 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 23 Sep 2019 16:43:33 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8NFhWS339125128
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Sep 2019 15:43:32 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E98A405B;
        Mon, 23 Sep 2019 15:43:32 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFC5CA4060;
        Mon, 23 Sep 2019 15:43:31 +0000 (GMT)
Received: from bahia.lan (unknown [9.145.22.84])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 23 Sep 2019 15:43:31 +0000 (GMT)
Subject: [PATCH 0/6] KVM: PPC: Book3S: HV: XIVE: Allocate less VPs in OPAL
From:   Greg Kurz <groug@kaod.org>
To:     Paul Mackerras <paulus@ozlabs.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?utf-8?q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 23 Sep 2019 17:43:31 +0200
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19092315-0028-0000-0000-000003A18D89
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19092315-0029-0000-0000-000024639F7C
Message-Id: <156925341155.974393.11681611197111945710.stgit@bahia.lan>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-23_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1034 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=728 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909230148
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each vCPU of a VM allocates a XIVE VP in OPAL which is associated with
8 event queue (EQ) descriptors, one for each priority. A POWER9 socket
can handle a maximum of 1M event queues.

The powernv platform allocates NR_CPUS (== 2048) VPs for the hypervisor,
and each XIVE KVM device allocates KVM_MAX_VCPUS (== 2048) VPs. This
means that on a bi-socket system, we can create at most:

(2 * 1M) / (8 * 2048) - 1 == 127 XIVE KVM devices

ie, start at most 127 VMs benefiting from an in-kernel interrupt
controller. Subsequent VMs need to rely on a much slower userspace
emulated XIVE or XICS device in QEMU.

This is problematic as one can legitimately expect to start the same
number of mono-cpu VMs as the number of HW threads available on the
system, eg, 144 on a bi-socket POWER9 Witherspoon.

This series allows QEMU to tell KVM how many interrupt servers are needed,
which is likely less than 2048 with a typical VM, eg. it is only 256 for
32 vCPUs with a guest's core stride of 8 and 1 thread per core.

With this I could run ~500 SMP1 VMs on a Witherspoon system.

Patches 1 to 3 are preliminary fixes (1 and 2 have already been posted
but are provided for convenience).

--
Greg

---

Cédric Le Goater (1):
      KVM: PPC: Book3S HV: XIVE: initialize private pointer when VPs are allocated

Greg Kurz (5):
      KVM: PPC: Book3S HV: XIVE: Set kvm->arch.xive when VPs are allocated
      KVM: PPC: Book3S HV: XIVE: Ensure VP isn't already in use
      KVM: PPC: Book3S HV: XIVE: Compute the VP id in a common helper
      KVM: PPC: Book3S HV: XIVE: Make VP block size configurable
      KVM: PPC: Book3S HV: XIVE: Allow userspace to set the # of VPs


 Documentation/virt/kvm/devices/xics.txt |   14 +++
 Documentation/virt/kvm/devices/xive.txt |    8 ++
 arch/powerpc/include/uapi/asm/kvm.h     |    3 +
 arch/powerpc/kvm/book3s_xive.c          |  145 +++++++++++++++++++++++++------
 arch/powerpc/kvm/book3s_xive.h          |   17 ++++
 arch/powerpc/kvm/book3s_xive_native.c   |   49 +++++-----
 6 files changed, 179 insertions(+), 57 deletions(-)

