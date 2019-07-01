Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5712128353
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 18:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbfEWQWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 12:22:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41704 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731202AbfEWQWV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 May 2019 12:22:21 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NGGucK131788
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 12:22:20 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2snvu0xgcb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 12:22:20 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mimu@linux.ibm.com>;
        Thu, 23 May 2019 17:22:18 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 23 May 2019 17:22:14 +0100
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4NGMCrR29098026
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 16:22:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E8784C05C;
        Thu, 23 May 2019 16:22:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 094CC4C059;
        Thu, 23 May 2019 16:22:12 +0000 (GMT)
Received: from s38lp84.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 23 May 2019 16:22:11 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     KVM Mailing List <kvm@vger.kernel.org>,
        Linux-S390 Mailing List <linux-s390@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v2 0/8] s390: virtio: support protected virtualization
Date:   Thu, 23 May 2019 18:22:01 +0200
X-Mailer: git-send-email 2.13.4
X-TM-AS-GCONF: 00
x-cbid: 19052316-4275-0000-0000-00000337DAFB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19052316-4276-0000-0000-0000384777E7
Message-Id: <20190523162209.9543-1-mimu@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230110
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enhanced virtualization protection technology may require the use of
bounce buffers for I/O. While support for this was built into the virtio
core, virtio-ccw wasn't changed accordingly.

Some background on technology (not part of this series) and the
terminology used.

* Protected Virtualization (PV):

Protected Virtualization guarantees, that non-shared memory of a  guest
that operates in PV mode private to that guest. I.e. any attempts by the
hypervisor or other guests to access it will result in an exception. If
supported by the environment (machine, KVM, guest VM) a guest can decide
to change into PV mode by doing the appropriate ultravisor calls.

* Ultravisor:

A hardware/firmware entity that manages PV guests, and polices access to
their memory. A PV guest prospect needs to interact with the ultravisor,
to enter PV mode, and potentially to share pages (for I/O which should
be encrypted by the guest). A guest interacts with the ultravisor via so
called ultravisor calls. A hypervisor needs to interact with the
ultravisor to facilitate interpretation, emulation and swapping. A
hypervisor  interacts with the ultravisor via ultravisor calls and via
the SIE state description. Generally the ultravisor sanitizes hypervisor
inputs so that the guest can not be corrupted (except for denial of
service.


What needs to be done
=====================

Thus what needs to be done to bring virtio-ccw up to speed with respect
to protected virtualization is:
* use some 'new' common virtio stuff
* make sure that virtio-ccw specific stuff uses shared memory when
  talking to the hypervisor (except control/communication blocks like ORB,
  these are handled by the ultravisor)
* make sure the DMA API does what is necessary to talk through shared
  memory if we are a protected virtualization guest.
* make sure the common IO layer plays along as well (airqs, sense).


Important notes
================

* This patch set is based on Martins features branch
 (git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git branch
 'features').

* Documentation is still very sketchy. I'm committed to improving this,
  but I'm currently hampered by some dependencies currently.  

* The existing naming in the common infrastructure (kernel internal
  interfaces) is pretty much based on the AMD SEV terminology. Thus the
  names aren't always perfect. There might be merit to changing these
  names to more abstract ones. I did not put much thought into that at
  the current stage.

* Testing: Please use iommu_platform=on for any virtio devices you are
  going to test this code with (so virtio actually uses the DMA API).

Change log
==========

v1 --> v2:
* patch "virtio/s390: use vring_create_virtqueue" went already upstream
* patch "virtio/s390: DMA support for virtio-ccw" went already upstream
* patch "virtio/s390: enable packed ring" went already upstream
* Made dev.dma_mask point to dev.coherent_dma_mask for css, subchannel
  and ccw devices.
* While rebasing 's390/airq: use DMA memory for adapter interrupts' the
  newly introduced kmem_cache  was replaced with an equivalent dma_pool;
  the kalloc() allocations are now replaced with cio_dma_zalloc()
  allocations to avoid wasting almost a full page.
* Made virtio-ccw use the new AIRQ_IV_CACHELINE flag.
* fixed all remaining checkpatch issues

RFC --> v1:
* Fixed bugs found by Connie (may_reduce and handling reduced,  warning,
  split move -- thanks Connie!).
* Fixed console bug found by Sebastian (thanks Sebastian!).
* Removed the completely useless duplicate of dma-mapping.h spotted by
  Christoph (thanks Christoph!).
* Don't use the global DMA pool for subchannel and ccw device
  owned memory as requested by Sebastian. Consequences:
	* Both subchannel and ccw devices have their dma masks
	now (both specifying 31 bit addressable)
	* We require at least 2 DMA pages per ccw device now, most of
	this memory is wasted though.
	* DMA memory allocated by virtio is also 31 bit addressable now
        as virtio uses the parent (which is the ccw device).
* Enabled packed ring.
* Rebased onto Martins feature branch; using the actual uv (ultravisor)
  interface instead of TODO comments.
* Added some explanations to the cover letter (Connie, David).
* Squashed a couple of patches together and fixed some text stuff. 

Looking forward to your review, or any other type of input.

Halil Pasic (8):
  s390/mm: force swiotlb for protected virtualization
  s390/cio: introduce DMA pools to cio
  s390/cio: add basic protected virtualization support
  s390/airq: use DMA memory for adapter interrupts
  virtio/s390: use cacheline aligned airq bit vectors
  virtio/s390: add indirection to indicators access
  virtio/s390: use DMA memory for ccw I/O and classic notifiers
  virtio/s390: make airq summary indicators DMA

 arch/s390/Kconfig                   |   5 +
 arch/s390/include/asm/airq.h        |   2 +
 arch/s390/include/asm/ccwdev.h      |   4 +
 arch/s390/include/asm/cio.h         |  11 ++
 arch/s390/include/asm/mem_encrypt.h |  18 +++
 arch/s390/mm/init.c                 |  47 +++++++
 drivers/s390/cio/airq.c             |  32 +++--
 drivers/s390/cio/ccwreq.c           |   9 +-
 drivers/s390/cio/cio.h              |   2 +
 drivers/s390/cio/css.c              | 111 ++++++++++++++++
 drivers/s390/cio/device.c           |  64 ++++++++--
 drivers/s390/cio/device_fsm.c       |  53 +++++---
 drivers/s390/cio/device_id.c        |  20 +--
 drivers/s390/cio/device_ops.c       |  21 +++-
 drivers/s390/cio/device_pgid.c      |  22 ++--
 drivers/s390/cio/device_status.c    |  24 ++--
 drivers/s390/cio/io_sch.h           |  20 ++-
 drivers/s390/virtio/virtio_ccw.c    | 244 ++++++++++++++++++++----------------
 18 files changed, 514 insertions(+), 195 deletions(-)
 create mode 100644 arch/s390/include/asm/mem_encrypt.h

-- 
2.13.4

