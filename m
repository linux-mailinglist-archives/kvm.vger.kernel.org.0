Return-Path: <kvm+bounces-53161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D680B0E1F9
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 18:33:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9D2B7AC6AA
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 16:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D09F527CCF0;
	Tue, 22 Jul 2025 16:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XRL6fUds"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6AB20CCDC;
	Tue, 22 Jul 2025 16:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753202001; cv=none; b=XQXjs5jaun4sBZNQhnRe6TH4HYZCQClx7PrbzdoVBGaOUFoZ1IteRbAhHQQ4QhKMWIi43yP2FSSX+jZAXUHwyhj+08KS1vhlH90+2zFLwtmZqs+M6EX2AEwhEAH94/B/S9PnvoLjWWb3gdEfli92iamgd5EQ9T/xJQe8dlpkD8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753202001; c=relaxed/simple;
	bh=JFvO2sl+ZvzpMngCXmdXRqsQ3fSfoNMsO2yWBEaTG3E=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GprWrOGx/thIP+KuHfcis6Kzc3zHOEbJkMU2RgYrqjsNWn0WY0NRa4MhTgiR9o5NrnWwA2rAA0KEbhaeWoheUqlYSs2FfcDEdF5+dlci/CwzNTiNaRiM7eDLrve3iT7JTLNrwi42ptHmrTiHWlLR8alNsltFmNJQqPIdpFzaQyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XRL6fUds; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M8diXM004800;
	Tue, 22 Jul 2025 16:33:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1tlUzt
	MDEEdZRgTXxLsrPmHpD7VJrIZTsKkoIDhvYP4=; b=XRL6fUdsy8emJzFAGXT+Yz
	yB+xqfbEi0ARRc8vNovfM1R7ER+ReJWUrqwvZnbncYXxMdxTMNZCSdqmcbNWha3H
	OQKqFAT5pYu2tKsTPXTvMBVL0gzvz6F5Fddk80JvPrkpKVSnFGnhLUoMr3qnVq4A
	pn8XTGCe9r/AZ9rwltKrxDYVva9uFQXgOzY1j6wc1y5P6gZvsgrARhVYYqHhBRyv
	kl90P92cYo1LRrTcadVRmA5+MQFJ5+FO19zY6ih1DWS32NOkYEPuI3ZnWxdiybgB
	n+MZjjLaXJ7PR519BiYpia70jxUBL1JGXrtMHL4dJBmSXvGH6DO9xLZoBTlQPaEQ
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 481v6x58c6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 16:33:02 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56MCdciu024744;
	Tue, 22 Jul 2025 16:33:01 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 480rd2bek0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 22 Jul 2025 16:33:01 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56MGX0lF27722436
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 16:33:00 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 730E458056;
	Tue, 22 Jul 2025 16:33:00 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8C0485803F;
	Tue, 22 Jul 2025 16:32:59 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.103.85])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 22 Jul 2025 16:32:59 +0000 (GMT)
Message-ID: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
From: Eric Farman <farman@linux.ibm.com>
To: lizhe.67@bytedance.com, alex.williamson@redhat.com,
        akpm@linux-foundation.org, david@redhat.com, jgg@ziepe.ca,
        peterx@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 22 Jul 2025 12:32:59 -0400
In-Reply-To: <20250710085355.54208-3-lizhe.67@bytedance.com>
References: <20250710085355.54208-1-lizhe.67@bytedance.com>
	 <20250710085355.54208-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: P_Z9B_hl63EBnZtuV78lxdXdkBl-s4rb
X-Proofpoint-GUID: P_Z9B_hl63EBnZtuV78lxdXdkBl-s4rb
X-Authority-Analysis: v=2.4 cv=MK1gmNZl c=1 sm=1 tr=0 ts=687fbd3e cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=968KyxNXAAAA:8 a=20KFwNOVAAAA:8
 a=k6V0GjBr0FUqDimafOgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDEzNSBTYWx0ZWRfX4euhuzOeOdbG
 +5LHnUD63z3BVM524Krpd5SgaXLxR3SP4E7xSdsGh3Acd0eIE/cf7DANsTS62YqsBusdLiW8E3X
 P0sZk7tPbWe1W6yA93Nmfp9cEEUWFWGxMBL4q9AO6dQ/azKQ45ImOS2nkfzBpANXKUsM9Ta6CuC
 6d9uoP66wsZoxNxGnXyh6HRUZgmLzC29Dt4GaNKFEn7r69NyIEX9PI0dGKOVFvVc/eUPwKQE7rA
 7sbojTaNsOGhHQtvFpWrbCBB4Nqo2c7SNV91aofv66eEunlgZvHAyNLGlHgoH7jUjK8YWMuCkob
 Aati/sY61yCfo1cqGV/he3nd2oEjRX95NMVML4LehozZkKL8P8shhilO8aXzDPMU7tKg8j1+7fB
 G6LqDlq1fIqlXayJemnHXUmHQ9TfRjmpwS7F0N1LLcrPrDvaINQC568NBj2kRQEV1aHdZRXq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 clxscore=1011 mlxscore=0 suspectscore=0 phishscore=0 impostorscore=0
 spamscore=0 mlxlogscore=813 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507220135

On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:
> From: Li Zhe <lizhe.67@bytedance.com>
>=20
> When vfio_pin_pages_remote() is called with a range of addresses that
> includes large folios, the function currently performs individual
> statistics counting operations for each page. This can lead to significan=
t
> performance overheads, especially when dealing with large ranges of pages=
.
> Batch processing of statistical counting operations can effectively enhan=
ce
> performance.
>=20
> In addition, the pages obtained through longterm GUP are neither invalid
> nor reserved. Therefore, we can reduce the overhead associated with some
> calls to function is_invalid_reserved_pfn().
>=20
> The performance test results for completing the 16G VFIO IOMMU DMA mappin=
g
> are as follows.
>=20
> Base(v6.16-rc4):
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.047 s (340.2 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.280 s (57.2 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.052 s (310.5 GB/s)
>=20
> With this patch:
> ------- AVERAGE (MADV_HUGEPAGE) --------
> VFIO MAP DMA in 0.027 s (602.1 GB/s)
> ------- AVERAGE (MAP_POPULATE) --------
> VFIO MAP DMA in 0.257 s (62.4 GB/s)
> ------- AVERAGE (HUGETLBFS) --------
> VFIO MAP DMA in 0.031 s (517.4 GB/s)
>=20
> For large folio, we achieve an over 40% performance improvement.
> For small folios, the performance test results indicate a
> slight improvement.
>=20
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++-----
>  1 file changed, 71 insertions(+), 12 deletions(-)

Hi,

Our CI started flagging some crashes running vfio-ccw regressions on the -n=
ext kernel beginning with
next-20250717, and bisect points to this particular commit.

I can reproduce by cherry-picking this series onto 6.16-rc7, so it's not so=
mething else lurking.
Without panic_on_warn, I get a handful of warnings from vfio_remove_dma() (=
after starting/stopping
guests with an mdev attached), before eventually triggering a BUG() in vfio=
_dma_do_unmap() running a
hotplug test. I've attached an example of a WARNING before the eventual BUG=
 below. I can help debug
this if more doc is needed, but admit I haven't looked at this patch in any=
 detail yet.

Thanks,
Eric

[  215.671885] ------------[ cut here ]------------
[  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_type1.=
c:1204
vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
[  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_co=
mmon vsock vhost
vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject=
_ipv4 nft_reject act_csum
cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_=
ipv4 nf_tables pkey_pckmo
s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw =
mdev vfio_iommu_type1
vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath lo=
op nfnetlink ctcm fsm
zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s3=
90 des_s390 libdes
sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc=
 rdma_ucm rdma_cm
configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alu=
a pkey autofs4
[  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: load=
ed Not tainted 6.16.0-
rc7-00005-g4ff8295d8d61 #79 NONE=20
[  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
[  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remove_dm=
a+0xde/0xf0
[vfio_iommu_type1])
[  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:=
0 RI:0 EA:3
[  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3b1c8=
0 0000000092ffad20
[  215.671961]            0000000090b57880 006e010100000000 000000008f3b1c8=
0 000000008f3b1cc8
[  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3b1c8=
0 0000000092ffad20
[  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36c3be=
0 000001c8b36c3ba8
[  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,0000024=
8af72dee0
           000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
          #000002482f7ee55a: af000000		mc	0,0
          >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0
           000002482f7ee562: 0707		bcr	0,%r7
           000002482f7ee564: 0707		bcr	0,%r7
           000002482f7ee566: 0707		bcr	0,%r7
           000002482f7ee568: 0707		bcr	0,%r7
[  215.672006] Call Trace:
[  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_iommu_=
type1]=20
[  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3de/0x=
5f0 [vfio_iommu_type1]=20
[  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0x180=
 [vfio]=20
[  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 [vfi=
o]=20
[  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0=20
[  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0=20
[  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0=20
[  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0=20
[  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30=20
[  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340=20
[  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90=20
[  215.672058] Last Breaking-Event-Address:
[  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_iommu_=
type1]
[  215.672062] ---[ end trace 0000000000000000 ]---
[  219.861940] ------------[ cut here ]------------

...

[  241.164333] ------------[ cut here ]------------
[  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
[  241.164358] monitor event: 0040 ilc:2 [#1]SMP=20
[  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transport_co=
mmon vsock vhost
vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_reject=
_ipv4 nft_reject act_csum
cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_=
ipv4 nf_tables pkey_pckmo
s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_ccw =
mdev vfio_iommu_type1
vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipath lo=
op nfnetlink ctcm fsm
zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng aes_s3=
90 des_s390 libdes
sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma sunrpc=
 rdma_ucm rdma_cm
configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh_alu=
a pkey autofs4
[  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: load=
ed Tainted: G        W =20
6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE=20
[  241.164403] Tainted: [W]=3DWARN
[  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
[  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_do_un=
map+0x4aa/0x4b0
[vfio_iommu_type1])
[  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:=
0 RI:0 EA:3
[  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 000000004000000=
0 000000008cfdcb40
[  241.164418]            0000000000001001 0000000000000001 000000000000000=
0 0000000040000000
[  241.164419]            0000000000000000 0000000000000000 00000001fbe7f14=
0 000000008cfdcb40
[  241.164421]            000003ff97dacfa8 0000000000000000 00000000871582c=
0 000001c8b4177cd0
[  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
           000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
          #000002482f7f1326: af000000		mc	0,0
          >000002482f7f132a: 0707		bcr	0,%r7
           000002482f7f132c: 0707		bcr	0,%r7
           000002482f7f132e: 0707		bcr	0,%r7
           000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
           000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
[  241.164458] Call Trace:
[  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfio_io=
mmu_type1]=20
[  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370 [vf=
io_iommu_type1]=20
[  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70=20
[  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100=20
[  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340=20
[  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90=20
[  241.164481] Last Breaking-Event-Address:
[  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfio_io=
mmu_type1]
[  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oops

>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> index 1136d7ac6b59..6909275e46c2 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -318,7 +318,13 @@ static void vfio_dma_bitmap_free_all(struct vfio_iom=
mu *iommu)
>  /*
>   * Helper Functions for host iova-pfn list
>   */
> -static struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_addr_t =
iova)
> +
> +/*
> + * Find the highest vfio_pfn that overlapping the range
> + * [iova_start, iova_end) in rb tree.
> + */
> +static struct vfio_pfn *vfio_find_vpfn_range(struct vfio_dma *dma,
> +		dma_addr_t iova_start, dma_addr_t iova_end)
>  {
>  	struct vfio_pfn *vpfn;
>  	struct rb_node *node =3D dma->pfn_list.rb_node;
> @@ -326,9 +332,9 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_dm=
a *dma, dma_addr_t iova)
>  	while (node) {
>  		vpfn =3D rb_entry(node, struct vfio_pfn, node);
> =20
> -		if (iova < vpfn->iova)
> +		if (iova_end <=3D vpfn->iova)
>  			node =3D node->rb_left;
> -		else if (iova > vpfn->iova)
> +		else if (iova_start > vpfn->iova)
>  			node =3D node->rb_right;
>  		else
>  			return vpfn;
> @@ -336,6 +342,11 @@ static struct vfio_pfn *vfio_find_vpfn(struct vfio_d=
ma *dma, dma_addr_t iova)
>  	return NULL;
>  }
> =20
> +static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_=
addr_t iova)
> +{
> +	return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> +}
> +
>  static void vfio_link_pfn(struct vfio_dma *dma,
>  			  struct vfio_pfn *new)
>  {
> @@ -614,6 +625,39 @@ static long vaddr_get_pfns(struct mm_struct *mm, uns=
igned long vaddr,
>  	return ret;
>  }
> =20
> +
> +static long vpfn_pages(struct vfio_dma *dma,
> +		dma_addr_t iova_start, long nr_pages)
> +{
> +	dma_addr_t iova_end =3D iova_start + (nr_pages << PAGE_SHIFT);
> +	struct vfio_pfn *top =3D vfio_find_vpfn_range(dma, iova_start, iova_end=
);
> +	long ret =3D 1;
> +	struct vfio_pfn *vpfn;
> +	struct rb_node *prev;
> +	struct rb_node *next;
> +
> +	if (likely(!top))
> +		return 0;
> +
> +	prev =3D next =3D &top->node;
> +
> +	while ((prev =3D rb_prev(prev))) {
> +		vpfn =3D rb_entry(prev, struct vfio_pfn, node);
> +		if (vpfn->iova < iova_start)
> +			break;
> +		ret++;
> +	}
> +
> +	while ((next =3D rb_next(next))) {
> +		vpfn =3D rb_entry(next, struct vfio_pfn, node);
> +		if (vpfn->iova >=3D iova_end)
> +			break;
> +		ret++;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * Attempt to pin pages.  We really don't want to track all the pfns and
>   * the iommu can only map chunks of consecutive pfns anyway, so get the
> @@ -680,32 +724,47 @@ static long vfio_pin_pages_remote(struct vfio_dma *=
dma, unsigned long vaddr,
>  		 * and rsvd here, and therefore continues to use the batch.
>  		 */
>  		while (true) {
> +			long nr_pages, acct_pages =3D 0;
> +
>  			if (pfn !=3D *pfn_base + pinned ||
>  			    rsvd !=3D is_invalid_reserved_pfn(pfn))
>  				goto out;
> =20
> +			/*
> +			 * Using GUP with the FOLL_LONGTERM in
> +			 * vaddr_get_pfns() will not return invalid
> +			 * or reserved pages.
> +			 */
> +			nr_pages =3D num_pages_contiguous(
> +					&batch->pages[batch->offset],
> +					batch->size);
> +			if (!rsvd) {
> +				acct_pages =3D nr_pages;
> +				acct_pages -=3D vpfn_pages(dma, iova, nr_pages);
> +			}
> +
>  			/*
>  			 * Reserved pages aren't counted against the user,
>  			 * externally pinned pages are already counted against
>  			 * the user.
>  			 */
> -			if (!rsvd && !vfio_find_vpfn(dma, iova)) {
> +			if (acct_pages) {
>  				if (!dma->lock_cap &&
> -				    mm->locked_vm + lock_acct + 1 > limit) {
> +				     mm->locked_vm + lock_acct + acct_pages > limit) {
>  					pr_warn("%s: RLIMIT_MEMLOCK (%ld) exceeded\n",
>  						__func__, limit << PAGE_SHIFT);
>  					ret =3D -ENOMEM;
>  					goto unpin_out;
>  				}
> -				lock_acct++;
> +				lock_acct +=3D acct_pages;
>  			}
> =20
> -			pinned++;
> -			npage--;
> -			vaddr +=3D PAGE_SIZE;
> -			iova +=3D PAGE_SIZE;
> -			batch->offset++;
> -			batch->size--;
> +			pinned +=3D nr_pages;
> +			npage -=3D nr_pages;
> +			vaddr +=3D PAGE_SIZE * nr_pages;
> +			iova +=3D PAGE_SIZE * nr_pages;
> +			batch->offset +=3D nr_pages;
> +			batch->size -=3D nr_pages;
> =20
>  			if (!batch->size)
>  				break;

