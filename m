Return-Path: <kvm+bounces-20393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A6C914A4C
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 14:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE7F82859D1
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 154EF13C9CB;
	Mon, 24 Jun 2024 12:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rqoK/l18"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C31386DA;
	Mon, 24 Jun 2024 12:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719232721; cv=none; b=hvl/nhNVxx7ZNeTe1pAmuxbOHQKCMQNHpUdqRG62hKNaCLFZqwxrcg6lns/5L2RZitVJMRaWo2ylqi1fzCDvnknMBC4TE8KQRM4zMAzqQRXQrHFa+whDq5sB+MowEyE/2FC1QtCnf2W5y6wqKilrsfNP3LjI7a1cGBDMYv6Hx0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719232721; c=relaxed/simple;
	bh=Fy0Vwku4i/edg06rEdhL5d0t9NVWZcRpigQqhSDnT3k=;
	h=Subject:From:To:Cc:Date:Message-ID:Content-Type:MIME-Version; b=Swmv+GZLNdr3jvsvlIvjpHQJW7fs3LmXpkKV0O0N23ZRCbDg1SoJMTypb8Rb7sbglqmMLgXIeaL0hbOUatlH5NecDRbGzR7wwVkYeg1TYgjyweospivKvOqM/4hv/S5d0AP8aO4UQJimXkT4h/Cv6OiCtGYGWjGVSVLgQstqF2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rqoK/l18; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45OCQRWH029828;
	Mon, 24 Jun 2024 12:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	subject:from:to:cc:date:message-id:content-type
	:content-transfer-encoding:mime-version; s=pp1; bh=Hvf40/4DRmlQ9
	1blYNCyK9m/dwqfbQqI7vBUaRHYyg0=; b=rqoK/l18AdsFoiaJ/roNzrnHQ5DIt
	hrmvGtFuM/6zDgAYH4m6VUho7K/aYwzxVjc9XvnI1VeZYaJkxdLpYnaibncp/2mH
	GNjpVTu7bpjgmtMROsOzRj8BL/3s7U34zMwmfdGwzUMdm8M6iyBk7xwU1HYjwWmS
	quPYwahqPiQxJ2s6xCft0K8G6v7DYZqBg1FzyxTsAiJQTFYHiLbFbLp3o1owCy3b
	uQBZVYAXYKh3sU9brsQnyLQtWDJ2Y5h4wEAoX5sehNUJNzkwwOE8EgLQmFbL9rio
	JfixG0xJWQZdK+bg+/F5oHrjG9ffwCvdBRLAKghGIjfaN0IOOxJ1d4v6g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy72xgbh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:38:19 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 45OCcIZt020362;
	Mon, 24 Jun 2024 12:38:18 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yy72xgbh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:38:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45OARoKF000685;
	Mon, 24 Jun 2024 12:38:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yxaemrm6j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Jun 2024 12:38:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45OCcBVu15008022
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Jun 2024 12:38:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D46C22004B;
	Mon, 24 Jun 2024 12:38:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7036820040;
	Mon, 24 Jun 2024 12:38:08 +0000 (GMT)
Received: from [172.17.0.2] (unknown [9.3.101.175])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Jun 2024 12:38:08 +0000 (GMT)
Subject: [PATCH v4 0/6] powerpc: pSeries: vfio: iommu: Re-enable support for
 SPAPR TCE VFIO
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
To: mpe@ellerman.id.au, tpearson@raptorengineering.com,
        alex.williamson@redhat.com, linuxppc-dev@lists.ozlabs.org, aik@amd.com
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, aneesh.kumar@kernel.org,
        naveen.n.rao@linux.ibm.com, gbatra@linux.vnet.ibm.com,
        brking@linux.vnet.ibm.com, sbhat@linux.ibm.com, aik@ozlabs.ru,
        jgg@ziepe.ca, ruscur@russell.cc, robh@kernel.org,
        sanastasio@raptorengineering.com, linux-kernel@vger.kernel.org,
        joel@jms.id.au, kvm@vger.kernel.org, msuchanek@suse.de,
        oohall@gmail.com, mahesh@linux.ibm.com, jroedel@suse.de,
        vaibhav@linux.ibm.com, svaidy@linux.ibm.com
Date: Mon, 24 Jun 2024 12:38:07 +0000
Message-ID: <171923268781.1397.8871195514893204050.stgit@linux.ibm.com>
User-Agent: StGit/1.5
Content-Type: text/plain; charset="utf-8"
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4Eg-QjpYq1jt1FFXcOrWoVZgTo2BR1kZ
X-Proofpoint-GUID: 7ktYKp9B7e3FR1syAWiiqnWMoAhoIetx
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
 definitions=2024-06-24_09,2024-06-24_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 impostorscore=0
 clxscore=1011 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406240099

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
v3: https://lore.kernel.org/linuxppc-dev/171810893836.1721.2640631616827396553.stgit@linux.ibm.com/
 - Rebased to top of the tree.
 - In the first patch, spapr_tce_table_group_ops is only used locally in
   the pseries/iommu.c file. So, made it static.
 - Fixed the test robot reported issues 202406121640.yr6LK5HJ-lkp@intel.com
   and 202406142110.r97Ts8Xm-lkp@intel.com
 - Updated the commit messages

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


 arch/powerpc/include/asm/iommu.h          |  14 +-
 arch/powerpc/kernel/eeh.c                 |  16 -
 arch/powerpc/kernel/iommu.c               | 170 +-----
 arch/powerpc/platforms/powernv/pci-ioda.c |   6 +-
 arch/powerpc/platforms/pseries/iommu.c    | 704 +++++++++++++++++++++-
 drivers/vfio/vfio_iommu_spapr_tce.c       |  13 +-
 6 files changed, 718 insertions(+), 205 deletions(-)

--
Signature


