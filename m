Return-Path: <kvm+bounces-11687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 08218879B18
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 19:14:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B72F12843EB
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 18:14:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2BD413957B;
	Tue, 12 Mar 2024 18:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="O/p1DeSm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FA3137C2D;
	Tue, 12 Mar 2024 18:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710267288; cv=none; b=mQ1v+L9Y6At+61hrn2WzFAE9R6wiLRRywiseIX7zqcV1G8bilwxCR91HgYWnbkJZZTz/7n1d1kdv/CJRwsXOf05XeCcDQQviDvro++8fQYza4/Bfnc5xnUhTRCl6iKiU88UminTsa/4NkZVsQsD4Kne8YIhVneHSgAYaGuV3PgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710267288; c=relaxed/simple;
	bh=IHgqxFldup+4h0fOf2DqjqqlOy/xyrjmzLgTge0GrPI=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=LIge+C1jO2QU2tTVk+GYdo0QnKxmF8thcoXI3rbEY95V/xCOUAWGUfvLhuwVscPR0XkWnwaL3EmVCmnZsMUsC+fG9r/GJ8fRnLlFPOe6A/q+Co9YHXDXCKGYvdJvkyf9+YU/S1HLSbhStSxHZlODNwSU7JsC/XZxKkMOfzB44oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=O/p1DeSm; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42CH745M025455;
	Tue, 12 Mar 2024 18:14:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pp1; bh=XKNGZYmOYcbMyFlOT7owfdYa/ezTaXVNlWfUCujhK9I=;
 b=O/p1DeSmuZC+PixDTpgyq6qSqFvJSBow+3hYXw1eFwB0TGEUjo4U7UG/KW0fZqxPfvaC
 RpiW+CcqCTwH5LUx9tI7EPE85A7n9Xrc2KllJ1l/mdHyyJ+8fFoDGtXCvfD+NZTWEDyq
 +ZTj2ZWl9wXrhEvNfe6aTZDVVsclX8lpzQGEBrHvTqpi1hW6t8exglQza/rbA8QQiKGq
 q8g0L4DB9x4bU/xJOs6Hj5+C8SOYjPpw6R7c9YbK4mLUsX2zNa0V4G1JgJI1jtKAznru
 VeVo3nEBOSjOBu/kl/TVKIGzVB8nN4UXPmAkeC0YD9XDfePYjjEc5hHVxNCMHtq43JSA Og== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wtsapuf6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Mar 2024 18:14:17 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42CHxn3s015652;
	Tue, 12 Mar 2024 18:14:16 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wtsapuf68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Mar 2024 18:14:16 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42CGluYs013553;
	Tue, 12 Mar 2024 18:14:15 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ws4ak8cm9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 12 Mar 2024 18:14:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42CIEAP830015768
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 12 Mar 2024 18:14:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C35F620040;
	Tue, 12 Mar 2024 18:14:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 191F22005A;
	Tue, 12 Mar 2024 18:14:06 +0000 (GMT)
Received: from ltcd48-lp2.aus.stglabs.ibm.com (unknown [9.3.101.175])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 12 Mar 2024 18:14:05 +0000 (GMT)
Subject: [RFC PATCH 0/3] powerpc: pSeries: vfio: iommu: Re-enable support for
 SPAPR TCE VFIO
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: tpearson@raptorengineering.com, alex.williamson@redhat.com,
        linuxppc-dev@lists.ozlabs.org
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com,
        gbatra@linux.vnet.ibm.com, brking@linux.vnet.ibm.com,
        sbhat@linux.ibm.com, aik@ozlabs.ru, jgg@ziepe.ca, robh@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, aik@amd.com,
        msuchanek@suse.de, jroedel@suse.de, vaibhav@linux.ibm.com,
        svaidy@linux.ibm.com
Date: Tue, 12 Mar 2024 13:14:05 -0500
Message-ID: <171026724548.8367.8321359354119254395.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nM_n4KNkdtQOdBqyQlTqIQFj1nMmrCcn
X-Proofpoint-GUID: Ov1NSsXSVowbq5PWuERKi9IkAjCnq0OM
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-12_11,2024-03-12_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0
 suspectscore=0 clxscore=1011 phishscore=0 mlxlogscore=999 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403120138

This patch-set fills the missing gaps on pSeries for VFIO SPAPR TCE
sub-driver thereby re-enabling the VFIO support on POWER pSeries
machines.

Structure of the patchset
=========================

* Currently, due to [1] VFIO_IOMMU_UNMAP_{DMA,UNMAP} ioctls are broken
on pSeries as it only supports single level TCEs. This is addressed in
the first patch as the lost functionality is restored.

On pSeries, the DMA windows (default 32-bit and the 64-bit DDW) are
"borrowed" between the host and the vfio driver. The necessary
mechanism for this is already been in place since [2]. However,
the VFIO SPAPR-TCE sub-driver doesn't open the 64-bit window if
it wasn't already done by a host driver like NVME. So the user-space
only gets access to the default 32-bit DMA window alone. This poses a
challenge for devices having no host kernel drivers and completely
depend on VFIO user-space interface to request DMA. The
VFIO_SPAPR_TCE_CREATE ioctl currently just returns EPERM without
attempting to open the second window for such devices.

* The second patch is just code movement for pSeries specific
functions from arch iommu to the pSeries platform iommu file.
This is needed as the DMA window manipulation operations
introduced in the third patch depend on these functions and are
entirely pSeries specific.

* The third patch adds necessary support to open up the 64-bit DMA
window on VFIO_SPAPR_TCE_CREATE ioctl from the user-space. It also
collects the DDW information from the platform for exposing it to
user through 'struct vfio_iommu_spapr_tce_ddw_info'.

Testing
========
These patches are tested with by attaching a nvme disk to a nested
kvm guest running a pSeries lpar. Also vfio-test [3] by Alex Willamson,
was forked and updated to add support for pSeries guest and used to
test these patches[4].

Limitations/Known Issues
========================
* Does not work for SRIOV VFs, as they have only one DMA window.
* Does not work for multi-function cards.
* Bugs
  - mmdrop() in tce_iommu_release() when container detached
    with pending unmaps.

[1] Commit: 090bad39b237 ("powerpc/powernv: Add indirect levels to it_userspace")
[2] Commit: 9d67c9433509 ("powerpc/iommu: Add \"borrowing\" iommu_table_group_ops")
[3] https://github.com/awilliam/tests
[4] https://github.com/nnmwebmin/vfio-ppc-tests/tree/vfio-ppc-ex

---

Shivaprasad G Bhat (3):
      powerpc/pseries/iommu: Bring back userspace view for single level TCE tables
      powerpc/iommu: Move pSeries specific functions to pseries/iommu.c
      pseries/iommu: Enable DDW for VFIO TCE create


 arch/powerpc/include/asm/iommu.h       |   7 +-
 arch/powerpc/kernel/iommu.c            | 156 +-------
 arch/powerpc/platforms/pseries/iommu.c | 514 ++++++++++++++++++++++++-
 drivers/vfio/vfio_iommu_spapr_tce.c    |  51 +++
 4 files changed, 571 insertions(+), 157 deletions(-)


