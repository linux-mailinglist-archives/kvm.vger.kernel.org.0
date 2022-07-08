Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A8956B8A5
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 13:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237964AbiGHLdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 07:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237568AbiGHLdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 07:33:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FBD13E83;
        Fri,  8 Jul 2022 04:33:39 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268AhpgP003069;
        Fri, 8 Jul 2022 11:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7xrOGjIsWAEbDM49IOKliT1dOZH/keObOYt2wLlK0qA=;
 b=lgIy1DXzsv9XlaV49r6vIDkrbcCTa8rwbkcshFDm/DFh9dmsEtSfOrfwX/mw5MeComim
 JMnrHubTwR5O3oCddXwwV6XkCOoEit3JbXvlRhVP9b+oIQGbsLflNV1QfsqEHtJTYMLn
 rZi6wQMefNafk8EnDnWajx4Ie3fLayCPBvUO6umQnij6bKRpRbwGpnfJqXDlbM4+sBkF
 MdjVYQbdFZUliusvtXLQKYxSfHH1XNwidUdDjdcEbVGSi9oFAIykadmdoqfgtsbPGsn8
 p0xKpxzMqOpmDB1GEjxM6ezwt2h6b+9+tVWjE3gnG4uAoZIy+3bRD3xXGRduJ4A3gobX pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6k36h357-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 11:33:36 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 268AkiXe018085;
        Fri, 8 Jul 2022 11:33:36 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6k36h34e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 11:33:36 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 268BL1cW024404;
        Fri, 8 Jul 2022 11:33:33 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma05fra.de.ibm.com with ESMTP id 3h4uk9aw5q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 11:33:33 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 268BXdUk28377420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 11:33:39 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 063694C04A;
        Fri,  8 Jul 2022 11:33:30 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F0CDB4C040;
        Fri,  8 Jul 2022 11:33:28 +0000 (GMT)
Received: from [9.171.9.15] (unknown [9.171.9.15])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  8 Jul 2022 11:33:28 +0000 (GMT)
Message-ID: <aa48903f-1354-6cca-4a52-86c073d3071d@linux.ibm.com>
Date:   Fri, 8 Jul 2022 13:33:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v9 00/21] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        linux-s390@vger.kernel.org, alex.williamson@redhat.com,
        pbonzini@redhat.com, hca@linux.ibm.com, gor@linux.ibm.com
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Z-nYG6kolGfyHIgz53xS4AXPTi2GZbpd
X-Proofpoint-ORIG-GUID: CrcPjwB1UDjtQA3cAPI_RM46Rsj7S50E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_08,2022-07-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207080042
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Am 06.06.22 um 22:33 schrieb Matthew Rosato:
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by triggering a routine
> when the VFIO group is associated with the KVM guest, transmitting to
> firmware a special token (GISA designation) to enable that specific guest
> for interpretive execution on that zPCI device.  Load/store interpreation
> enablement is then controlled by userspace (based upon whether or not a
> SHM bit is placed in the virtual function handle).  Adapter Event
> Notification interpretation is controlled from userspace via a new KVM
> ioctl.
> 
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can reduce the frequency of guest SIE exits for
> zPCI.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will follow up with a link the most recent QEMU series.
> 
> Changelog v8->v9:
> - Rebase on top of 5.19-rc1, adjust ioctl and capability defines
> - s/kzdev = 0/kzdev = NULL/ (Alex)
> - rename vfio_pci_zdev_open to vfio_pci_zdev_open_device (Jason)
> - rename vfio_pci_zdev_release to vfio_pci_zdev_close_device (Jason)
> - make vfio_pci_zdev_close_device return void, instead WARN_ON or ignore
>    errors in lower level function (kvm_s390_pci_unregister_kvm) (Jason)
> - remove notifier accidentally left in struct zpci_dev + associated
>    include statment (Jason)
> - Remove patch 'KVM: s390: introduce CPU feature for zPCI Interpretation'
>    based on discussion in QEMU thread.
> 
> Matthew Rosato (21):
>    s390/sclp: detect the zPCI load/store interpretation facility
>    s390/sclp: detect the AISII facility
>    s390/sclp: detect the AENI facility
>    s390/sclp: detect the AISI facility
>    s390/airq: pass more TPI info to airq handlers
>    s390/airq: allow for airq structure that uses an input vector
>    s390/pci: externalize the SIC operation controls and routine
>    s390/pci: stash associated GISA designation
>    s390/pci: stash dtsm and maxstbl
>    vfio/pci: introduce CONFIG_VFIO_PCI_ZDEV_KVM
>    KVM: s390: pci: add basic kvm_zdev structure
>    KVM: s390: pci: do initial setup for AEN interpretation
>    KVM: s390: pci: enable host forwarding of Adapter Event Notifications
>    KVM: s390: mechanism to enable guest zPCI Interpretation
>    KVM: s390: pci: provide routines for enabling/disabling interrupt
>      forwarding
>    KVM: s390: pci: add routines to start/stop interpretive execution
>    vfio-pci/zdev: add open/close device hooks
>    vfio-pci/zdev: add function handle to clp base capability
>    vfio-pci/zdev: different maxstbl for interpreted devices
>    KVM: s390: add KVM_S390_ZPCI_OP to manage guest zPCI devices
>    MAINTAINERS: additional files related kvm s390 pci passthrough
> 
>   Documentation/virt/kvm/api.rst   |  47 +++
>   MAINTAINERS                      |   1 +
>   arch/s390/include/asm/airq.h     |   7 +-
>   arch/s390/include/asm/kvm_host.h |  23 ++
>   arch/s390/include/asm/pci.h      |  11 +
>   arch/s390/include/asm/pci_clp.h  |   9 +-
>   arch/s390/include/asm/pci_insn.h |  29 +-
>   arch/s390/include/asm/sclp.h     |   4 +
>   arch/s390/include/asm/tpi.h      |  13 +
>   arch/s390/kvm/Makefile           |   1 +
>   arch/s390/kvm/interrupt.c        |  96 ++++-
>   arch/s390/kvm/kvm-s390.c         |  83 +++-
>   arch/s390/kvm/kvm-s390.h         |  10 +
>   arch/s390/kvm/pci.c              | 690 +++++++++++++++++++++++++++++++
>   arch/s390/kvm/pci.h              |  88 ++++
>   arch/s390/pci/pci.c              |  16 +
>   arch/s390/pci/pci_clp.c          |   7 +
>   arch/s390/pci/pci_insn.c         |   4 +-
>   arch/s390/pci/pci_irq.c          |  48 ++-
>   drivers/s390/char/sclp_early.c   |   4 +
>   drivers/s390/cio/airq.c          |  12 +-
>   drivers/s390/cio/qdio_thinint.c  |   6 +-
>   drivers/s390/crypto/ap_bus.c     |   9 +-
>   drivers/s390/virtio/virtio_ccw.c |   6 +-
>   drivers/vfio/pci/Kconfig         |  11 +
>   drivers/vfio/pci/Makefile        |   2 +-
>   drivers/vfio/pci/vfio_pci_core.c |  10 +-
>   drivers/vfio/pci/vfio_pci_zdev.c |  35 +-
>   include/linux/sched/user.h       |   3 +-
>   include/linux/vfio_pci_core.h    |  12 +-
>   include/uapi/linux/kvm.h         |  31 ++
>   include/uapi/linux/vfio_zdev.h   |   7 +
>   32 files changed, 1279 insertions(+), 56 deletions(-)
>   create mode 100644 arch/s390/kvm/pci.c
>   create mode 100644 arch/s390/kvm/pci.h

So I pulled this into a topic branch and will merge that into kvms390/next. We can
merge this topic  branch into vfio-next and/or s390-next when the conflicts get
to complicated.

While pulling I fixed up the numbers for the capability to

#define KVM_CAP_S390_ZPCI_OP 221

and the doc number to

4.137 KVM_S390_ZPCI_OP

to minize struggle when doing backports.
