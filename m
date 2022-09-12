Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F05595B5C57
	for <lists+kvm@lfdr.de>; Mon, 12 Sep 2022 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiILOiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Sep 2022 10:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiILOiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Sep 2022 10:38:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CBB2ED7B
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 07:38:18 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDsPm8003295;
        Mon, 12 Sep 2022 14:38:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=eevU3m18bHpE3ha0pkMlGWzBztH6zEsSaYRdAuR8Vng=;
 b=NHIYxoypCL4KoGGGEPuoy37HsJUkKd/ftqH0vnkj91TF0xQ6gHbBfVg5lhIppEjDXeVe
 hxizkb4ysCeyxxyzdNdxeAMGGnKTrzMQvTc7xOMx8KkvTpFUg7YTxnGPupqVNjsR9o16
 /9DRUKJxF9Ul9vChvtHRl1/XrRsxeVbYdNkfIxr8YqkgBf5yPAGfUgZx1UEsq5ykThLZ
 L/TWSKLQkeIysIBUxxDSE32A0uSIx9bl9aOBq9MacDYPMLS6sSg+HkqNBNhcPAeBqxxM
 z0u776lZFSSlsHRb7OkvIZalHSwr898lZUmxVUEcsm+MMYHYHzFNx83bu/gapbFY/XdD yg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj625heua-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 14:38:10 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28CDsuAH004879;
        Mon, 12 Sep 2022 14:38:09 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jj625hesm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 14:38:09 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28CEaU3v028857;
        Mon, 12 Sep 2022 14:38:07 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3jgj79thee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Sep 2022 14:38:07 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28CEYMpP18219450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 14:34:22 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CAC58A404D;
        Mon, 12 Sep 2022 14:38:03 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 159E8A4055;
        Mon, 12 Sep 2022 14:38:03 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.22.70])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 12 Sep 2022 14:38:03 +0000 (GMT)
Message-ID: <d8fbb30bbc8dc3d5d512fbeac257c38effbe1dc2.camel@linux.ibm.com>
Subject: Re: [PATCH v9 00/10] s390x: CPU Topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Date:   Mon, 12 Sep 2022 16:38:02 +0200
In-Reply-To: <20220902075531.188916-1-pmorel@linux.ibm.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: HIKMAUZdXLVDT-N2D6_64Mta2c8Z-VZr
X-Proofpoint-ORIG-GUID: 1OBtJPaPDU_NMKcrFeWzloaY7mW43Y02
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_10,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 spamscore=0 clxscore=1015 suspectscore=0 adultscore=0
 priorityscore=1501 malwarescore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209120049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I found this version much easier to understand than the previous one.

You could consider splitting up the series into two.
One that introduces support for STSI, PTF, migration, etc.
And a second one that adds support for the maximum-MNist facility and
drawers and books.

This would also make bisecting a bit nicer because it moves the feature
enablement closer to the commits adding the support.

Right now, with this series, the topology is static and cannot change.
Most of the value of making the topology visible to the guest is for it
to mirror reality, and a static topology is a hindrance for that.
I'm completely fine with having a static topology as a stepping stone
to a dynamic one.
However I think we should have a rough plan or maybe even a prototype
for how we turn a static into a dynamic topology before we merge this
series in order to avoid designing us into a corner.
What do you think?

On Fri, 2022-09-02 at 09:55 +0200, Pierre Morel wrote:
> Hi,
> 
> The implementation of the CPU Topology in QEMU has been drastically
> modified since the last patch series and the number of LOCs has been
> greatly reduced.
> 
> Unnecessary objects have been removed, only a single S390Topology object
> is created to support migration and reset.
> 
> Also a documentation has been added to the series.
> 
> 
> To use these patches, you will need Linux V6-rc1 or newer.
> 
> Mainline patches needed are:
> 
> f5ecfee94493 2022-07-20 KVM: s390: resetting the Topology-Change-Report    
> 24fe0195bc19 2022-07-20 KVM: s390: guest support for topology function     
> 0130337ec45b 2022-07-20 KVM: s390: Cleanup ipte lock access and SIIF fac.. 
> 
> Currently this code is for KVM only, I have no idea if it is interesting
> to provide a TCG patch. If ever it will be done in another series.
> 
> To have a better understanding of the S390x CPU Topology and its
> implementation in QEMU you can have a look at the documentation in the
> last patch.
> 
> New in this series
> ==================
> 
>   s390x/cpus: Make absence of multithreading clear
> 
> This patch makes clear that CPU-multithreading is not supported in
> the guest.
> 
>   s390x/cpu topology: core_id sets s390x CPU topology
> 
> This patch uses the core_id to build the container topology
> and the placement of the CPU inside the container.
> 
>   s390x/cpu topology: reporting the CPU topology to the guest
> 
> This patch is based on the fact that the CPU type for guests
> is always IFL, CPUs are always dedicated and the polarity is
> always horizontal.
> This may change in the future.
> 
>   hw/core: introducing drawer and books for s390x
>   s390x/cpu: reporting drawers and books topology to the guest
> 
> These two patches extend the topology handling to add two
> new containers levels above sockets: books and drawers.
> 
> The subject of the last patches is clear enough (I hope).
> 
> Regards,
> Pierre
> 
> Pierre Morel (10):
>   s390x/cpus: Make absence of multithreading clear
>   s390x/cpu topology: core_id sets s390x CPU topology
>   s390x/cpu topology: reporting the CPU topology to the guest
>   hw/core: introducing drawer and books for s390x
>   s390x/cpu: reporting drawers and books topology to the guest
>   s390x/cpu_topology: resetting the Topology-Change-Report
>   s390x/cpu_topology: CPU topology migration
>   target/s390x: interception of PTF instruction
>   s390x/cpu_topology: activating CPU topology
>   docs/s390x: document s390x cpu topology
> 
>  docs/system/s390x/cpu_topology.rst |  88 +++++++++
>  hw/core/machine-smp.c              |  48 ++++-
>  hw/core/machine.c                  |   9 +
>  hw/s390x/cpu-topology.c            | 293 +++++++++++++++++++++++++++++
>  hw/s390x/meson.build               |   1 +
>  hw/s390x/s390-virtio-ccw.c         |  61 +++++-
>  include/hw/boards.h                |  11 ++
>  include/hw/s390x/cpu-topology.h    |  53 ++++++
>  include/hw/s390x/s390-virtio-ccw.h |   7 +
>  qapi/machine.json                  |  14 +-
>  qemu-options.hx                    |   6 +-
>  softmmu/vl.c                       |   6 +
>  target/s390x/cpu-sysemu.c          |  15 ++
>  target/s390x/cpu.h                 |  51 +++++
>  target/s390x/cpu_topology.c        | 150 +++++++++++++++
>  target/s390x/kvm/kvm.c             |  56 +++++-
>  target/s390x/kvm/kvm_s390x.h       |   1 +
>  target/s390x/meson.build           |   1 +
>  18 files changed, 858 insertions(+), 13 deletions(-)
>  create mode 100644 docs/system/s390x/cpu_topology.rst
>  create mode 100644 hw/s390x/cpu-topology.c
>  create mode 100644 include/hw/s390x/cpu-topology.h
>  create mode 100644 target/s390x/cpu_topology.c
> 

