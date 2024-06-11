Return-Path: <kvm+bounces-19316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CA2F903BE3
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 14:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BDAD0B22DA4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAB1E17C21D;
	Tue, 11 Jun 2024 12:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kf5NSpz1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CB3176FC6;
	Tue, 11 Jun 2024 12:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718108979; cv=none; b=BPlZ48rcgxzLeIGwXBXg+wjfLcs74taaFxmCog0WZVKJJKqTyLzvkY9NyQSwrtszVcRdm4q4LlV3z0WdibvCJuUZcjiypAuBFWbVOcNtqi4MKFH8logahtby5U29BZxYVwzI+ocm7PcFqTNNYULSlseXDEpRtx6kwVx1jr4plhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718108979; c=relaxed/simple;
	bh=q9kyVSD0BIBtVrdVEaZDO/szZtri46Uzq548rN72h6Y=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=NoBUkoaOh6jUr0Q+N217VD5h/gRRiD/jJ0G9/GKzW7bZRwrJ4ULNCgJEWz1+Kez8fo3SE+WBbEcPF4Eke7BsPesgejuyJyOSH1YUhpoa7oc1F+NWtY59od+9V9nWkd2KxT2dPUKpvmucolwLb6Ltqnp5iEc/DsrbVqK4Fi4x6Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kf5NSpz1; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BBTIOW018271;
	Tue, 11 Jun 2024 12:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=pp1; bh=+xuTgifUTgDv1
	KSSr0HjQCiBclbjmC0EqABAAJC4HvM=; b=kf5NSpz1G8/09UVKF/27gCllDadn4
	6KPbZtGNWGcfuZn24InGc8DyvWnvlyl3U+Wlx0F1Nvn6GHj+PtkLnXdFkJTEiqxO
	Dj1fJPczEFuHWAEslHYq3WeKhQJZpUz74b80zHtMbl04Enj4pNZch05q7uwIFYLR
	ry3MsMXt18ez28FqqwRA5CNcU++baDSz+miIEpTQY358DGfeLgE7DcazRtdo6FOE
	7O4PVKPfMoRpUJ1JmWCg+Q1pDQoaKGMZG77MEbgJPEoR88ImHPBJIWOclNCA9IOu
	/FamQD9HEXFNYjCAOid0eZaRvvKBIp/sWxTbVB6hKcDBvE65qp9pOa57w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnr0r3vv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:09 +0000 (GMT)
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45BCT8nR010062;
	Tue, 11 Jun 2024 12:29:08 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ypnr0r3vr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:08 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45BAG4rE028734;
	Tue, 11 Jun 2024 12:29:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3yn1mu5y4n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Jun 2024 12:29:07 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45BCT2aR52625874
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 12:29:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5F7A12004F;
	Tue, 11 Jun 2024 12:29:02 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0576A20043;
	Tue, 11 Jun 2024 12:28:59 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Jun 2024 12:28:58 +0000 (GMT)
Subject: [PATCH v3 0/6] powerpc: pSeries: vfio: iommu: Re-enable support for
 SPAPR TCE VFIO
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
        jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
        linux-kernel@vger.kernel.org, joel@jms.id.au, kvm@vger.kernel.org,
        msuchanek@suse.de, oohall@gmail.com, mahesh@linux.ibm.com,
        jroedel@suse.de, vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Date: Tue, 11 Jun 2024 12:28:58 +0000
Message-ID: <171810893836.1721.2640631616827396553.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 92C-Q4P0P3MjOTXxbdTJzlyYklVSGKDI
X-Proofpoint-ORIG-GUID: ESotMs8n1MpL44jpM8heqXKn36I0pJ_x
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_07,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406110092

The patches reimplement the iommu table_group_ops for pSeries
for VFIO SPAPR TCE sub-driver thereby bringing consistency with
PowerNV implementation and getting rid of limitations/bugs which
were emanating from these differences on the earlier approach on
pSeries.

Structure of the patchset:
-------------------------
The first and fifth patches just code movements.

Second patch takes care of collecting the TCE and DDW information
for the vfio_iommu_spapr_tce_ddw_info during probe.

Third patch fixes the convention of using table[1] for VFs on
pSeries when used by the host driver.

Fourth patch fixes the VFIO to call TCE clear before unset window.

The last patch has the API reimplementations, please find the
details on its commit description.

Testing:
-------
Tested with nested guest for NVME card, Mellanox multi-function
card by attaching them to nested kvm guest running on a pSeries
lpar.
Also vfio-test [2] by Alex Willamson, was forked and updated to
add support for pSeries guest and used to test these patches[3].

Limitations/Known Issues:
------------------------
* The DMA window restrictions with SRIOV VF scenarios of having
maximum 1 dma window is taken care in the current patches itself.
However, the necessary changes required in
vfio_iommu_spapr_tce_ddw_info to expose the default window being
a 64-bit one and the qemu changes handle the same will be taken
care in future versions.

References:
----------
[1] https://lore.kernel.org/linuxppc-dev/171026724548.8367.8321359354119254395.stgit@linux.ibm.com/
[2] https://github.com/awilliam/tests
[3] https://github.com/nnmwebmin/vfio-ppc-tests/tree/vfio-ppc-ex

---
Changelog:
v2: https://lore.kernel.org/linuxppc-dev/171450753489.10851.3056035705169121613.stgit@linux.ibm.com/
 - Rebased to upstream. So, required the explicit vmalloc.h inclusion as its
   removed from the system header io.h now.
 - Fixed the DLPAR hotplugged device assignment case. The dma window
   property is backed up before removal. That copy is restored when required.
 - Cleaned up bit more. Removed leftover debug prints and dump_stack()s.
 - The warning at remap_pfn_range_notrack() during kvm guest boot is no longer
   seen after the rebase.

v1: https://lore.kernel.org/linuxppc-dev/171026724548.8367.8321359354119254395.stgit@linux.ibm.com/
 - Rewrite as to stop borrowing the DMA windows and implemented
 the table_group_ops for pSeries.
 - Cover letter and Patch 6 has more details as this was a rewrite.

Shivaprasad G Bhat (6):
      powerpc/iommu: Move pSeries specific functions to pseries/iommu.c
      powerpc/pseries/iommu: Fix the VFIO_IOMMU_SPAPR_TCE_GET_INFO ioctl output
      powerpc/pseries/iommu: Use the iommu table[0] for IOV VF's DDW
      vfio/spapr: Always clear TCEs before unsetting the window
      powerpc/iommu: Move dev_has_iommu_table() to iommu.c
      powerpc/iommu: Reimplement the iommu_table_group_ops for pSeries


 arch/powerpc/include/asm/iommu.h          |   9 +-
 arch/powerpc/kernel/eeh.c                 |  16 -
 arch/powerpc/kernel/iommu.c               | 170 +-----
 arch/powerpc/platforms/powernv/pci-ioda.c |   6 +-
 arch/powerpc/platforms/pseries/iommu.c    | 708 +++++++++++++++++++++-
 drivers/vfio/vfio_iommu_spapr_tce.c       |  13 +-
 6 files changed, 717 insertions(+), 205 deletions(-)

--
Signature


