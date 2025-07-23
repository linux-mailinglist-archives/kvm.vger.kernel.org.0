Return-Path: <kvm+bounces-53257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A85B0F59D
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:43:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 465AC1CC2697
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B00182F2C50;
	Wed, 23 Jul 2025 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VRJbOnXj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29032E3373;
	Wed, 23 Jul 2025 14:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753281716; cv=none; b=fnzrT82YYEETXBNiKaad7FQ6Xpy7+I3eJ+ZBVejT6YRpOKfqn4y2DWvkkPC1foSFMd7G/olfMHU+UNBssNYFYG7zRA2eJgjuri6dm6Pr4ctcLh+f92wZbYzxvn2YuX6yQHOI/7HFEK6PGr1DthYv/2LafHYumCSWBp52jDPLrMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753281716; c=relaxed/simple;
	bh=wJROE9NJVAA6DA7/IpdheYdzqibGjE5oFuhBSRBqooE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DZncwu00qqMWZ7QkrdTiAEkUWdCYIlLq9egcKBsSitNHnQ85EfSDnopL8hIlq0fLu4opEB9nXDy2GH1Xo/YIum3o32Uc+3sWoADVTiMwxMIAKmSgEuNxqsN8Rn3cVQ1mNWtTjCHEYyS+WmzUcGfBlt7zQxcGhAf3FDNMCxLnmyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VRJbOnXj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56NAPn7s029171;
	Wed, 23 Jul 2025 14:41:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BsRYrm
	zERgPOP9TC+SccnJXGvwcImyLF8hTv5G28Y4Y=; b=VRJbOnXjrbgBI0by2bkg2K
	+JuEPLtFD88gSEvRG9S64dN2bHJTCtfElfwP1DmDB+PRBKyrBHOxQj4IVNRXBvqN
	ImgNVYAaJUs+Xrlz2igBfrJKOSYrQWw2cmzHQn1iBPfNHVKYwwaARPXrrcgYYvzL
	LNA5hrvaUwq6MVb+7kM7M43/HqfIkrWBi8EKx3dOv0ueXlSulva7GocMnMSNrXLN
	j2SZARXy3JAPMML8yVqdkEambwygWQC5TPbJ3APATt3r9Rcf2IwOikyMCq6J39Qf
	PVQ3EebTE5irrTGv5uOcMSgSjMvkqbzBsFa8nGiy4W8XyleZ0cGF0cv0FByAj7ug
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 482kdym50a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 14:41:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56NCY7DW014302;
	Wed, 23 Jul 2025 14:41:36 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 480ppp87m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Jul 2025 14:41:36 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56NEfZ5315401652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 14:41:36 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C76C658065;
	Wed, 23 Jul 2025 14:41:35 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 053155805A;
	Wed, 23 Jul 2025 14:41:35 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.103.85])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 23 Jul 2025 14:41:34 +0000 (GMT)
Message-ID: <f22a8b5b50a140339222bed77f4b670d9008f29b.camel@linux.ibm.com>
Subject: Re: [PATCH v4 2/5] vfio/type1: optimize vfio_pin_pages_remote()
From: Eric Farman <farman@linux.ibm.com>
To: lizhe.67@bytedance.com
Cc: akpm@linux-foundation.org, alex.williamson@redhat.com, david@redhat.com,
        jgg@ziepe.ca, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, peterx@redhat.com
Date: Wed, 23 Jul 2025 10:41:34 -0400
In-Reply-To: <20250723070917.87657-1-lizhe.67@bytedance.com>
References: <1bd50178755535ee0a3b0b2164acf9319079a3d5.camel@linux.ibm.com>
	 <20250723070917.87657-1-lizhe.67@bytedance.com>
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
X-Proofpoint-ORIG-GUID: LjxNU6gIq12eLmfrwE13fuT495092aWs
X-Authority-Analysis: v=2.4 cv=XP0wSRhE c=1 sm=1 tr=0 ts=6880f4a1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=968KyxNXAAAA:8 a=VnNF1IyMAAAA:8
 a=20KFwNOVAAAA:8 a=tpwnMQrfUSg4QDc0uBEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: LjxNU6gIq12eLmfrwE13fuT495092aWs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDEyNiBTYWx0ZWRfXxcniVq8EcEpC
 fLRZaRQlxv2Cc0ZgFEvrZu8DOkDS9TER1TtyJ6F3mP4rXoZ7rebwPzrULTrhH2s5B3TR9lvFNvU
 SodSOjHHKKN1Srf2rHlipoWJK0JuelXrJTXWSWGRtTZoiaHrj0mDT7+LtqhIo0jioWjMO/KxkrQ
 ivZp1kBlCe+E/TG8U372bkCsjRX6TDowCkAe+c4xgGXHDCutugBBmQukaNeWe0Qdrhqunmwr5wT
 Fq5eOhJQ/RdABPvBvYK1zqkN6cV2v+9/IEPWgFIfDkbEQJAYT6EeDcNdXA8K99D27f0I5NbN3VE
 ONB2KvWdCNpZ8dZQTogpQKgX+15GF06JchXFrlqaprgwt636BB1BqaK6NtFm65PPQHkz8fesx0i
 AShL75hmGrkmtU6MsfF7TL3XhVQIPoqg5ooQZbane29IUf1IsD47Hsa82aib817UNOB2VB/v
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=677 spamscore=0
 suspectscore=0 clxscore=1015 malwarescore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507230126

On Wed, 2025-07-23 at 15:09 +0800, lizhe.67@bytedance.com wrote:
> On Tue, 22 Jul 2025 12:32:59 -0400, farman@linux.ibm.com wrote:
> =20
> > On Thu, 2025-07-10 at 16:53 +0800, lizhe.67@bytedance.com wrote:
> > > From: Li Zhe <lizhe.67@bytedance.com>
> > >=20
> > > When vfio_pin_pages_remote() is called with a range of addresses that
> > > includes large folios, the function currently performs individual
> > > statistics counting operations for each page. This can lead to signif=
icant
> > > performance overheads, especially when dealing with large ranges of p=
ages.
> > > Batch processing of statistical counting operations can effectively e=
nhance
> > > performance.
> > >=20
> > > In addition, the pages obtained through longterm GUP are neither inva=
lid
> > > nor reserved. Therefore, we can reduce the overhead associated with s=
ome
> > > calls to function is_invalid_reserved_pfn().
> > >=20
> > > The performance test results for completing the 16G VFIO IOMMU DMA ma=
pping
> > > are as follows.
> > >=20
> > > Base(v6.16-rc4):
> > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > VFIO MAP DMA in 0.047 s (340.2 GB/s)
> > > ------- AVERAGE (MAP_POPULATE) --------
> > > VFIO MAP DMA in 0.280 s (57.2 GB/s)
> > > ------- AVERAGE (HUGETLBFS) --------
> > > VFIO MAP DMA in 0.052 s (310.5 GB/s)
> > >=20
> > > With this patch:
> > > ------- AVERAGE (MADV_HUGEPAGE) --------
> > > VFIO MAP DMA in 0.027 s (602.1 GB/s)
> > > ------- AVERAGE (MAP_POPULATE) --------
> > > VFIO MAP DMA in 0.257 s (62.4 GB/s)
> > > ------- AVERAGE (HUGETLBFS) --------
> > > VFIO MAP DMA in 0.031 s (517.4 GB/s)
> > >=20
> > > For large folio, we achieve an over 40% performance improvement.
> > > For small folios, the performance test results indicate a
> > > slight improvement.
> > >=20
> > > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > > Co-developed-by: Alex Williamson <alex.williamson@redhat.com>
> > > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > ---
> > >  drivers/vfio/vfio_iommu_type1.c | 83 ++++++++++++++++++++++++++++---=
--
> > >  1 file changed, 71 insertions(+), 12 deletions(-)
> >=20
> > Hi,
> >=20
> > Our CI started flagging some crashes running vfio-ccw regressions on th=
e -next kernel beginning with
> > next-20250717, and bisect points to this particular commit.
> >=20
> > I can reproduce by cherry-picking this series onto 6.16-rc7, so it's no=
t something else lurking.
> > Without panic_on_warn, I get a handful of warnings from vfio_remove_dma=
() (after starting/stopping
> > guests with an mdev attached), before eventually triggering a BUG() in =
vfio_dma_do_unmap() running a
> > hotplug test. I've attached an example of a WARNING before the eventual=
 BUG below. I can help debug
> > this if more doc is needed, but admit I haven't looked at this patch in=
 any detail yet.
> >=20
> > Thanks,
> > Eric
> >=20
> > [  215.671885] ------------[ cut here ]------------
> > [  215.671893] WARNING: CPU: 10 PID: 6210 at drivers/vfio/vfio_iommu_ty=
pe1.c:1204
> > vfio_remove_dma+0xda/0xf0 [vfio_iommu_type1]
> > [  215.671902] Modules linked in: vhost_vsock vmw_vsock_virtio_transpor=
t_common vsock vhost
> > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_re=
ject_ipv4 nft_reject act_csum
> > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_def=
rag_ipv4 nf_tables pkey_pckmo
> > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_=
ccw mdev vfio_iommu_type1
> > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipat=
h loop nfnetlink ctcm fsm
> > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng ae=
s_s390 des_s390 libdes
> > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma su=
nrpc rdma_ucm rdma_cm
> > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh=
_alua pkey autofs4
> > [  215.671946] CPU: 10 UID: 107 PID: 6210 Comm: qemu-system-s39 Kdump: =
loaded Not tainted 6.16.0-
> > rc7-00005-g4ff8295d8d61 #79 NONE=20
> > [  215.671950] Hardware name: IBM 3906 M05 780 (LPAR)
> > [  215.671951] Krnl PSW : 0704c00180000000 000002482f7ee55e (vfio_remov=
e_dma+0xde/0xf0
> > [vfio_iommu_type1])
> > [  215.671956]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0=
 PM:0 RI:0 EA:3
> > [  215.671959] Krnl GPRS: 006d010100000000 000000009d8a4c40 000000008f3=
b1c80 0000000092ffad20
> > [  215.671961]            0000000090b57880 006e010100000000 000000008f3=
b1c80 000000008f3b1cc8
> > [  215.671963]            0000000085b3ff00 000000008f3b1cc0 000000008f3=
b1c80 0000000092ffad20
> > [  215.671964]            000003ff867acfa8 000000008f3b1ca0 000001c8b36=
c3be0 000001c8b36c3ba8
> > [  215.671972] Krnl Code: 000002482f7ee550: c0e53ff9fcc8	brasl	%r14,000=
00248af72dee0
> >            000002482f7ee556: a7f4ffcf		brc	15,000002482f7ee4f4
> >           #000002482f7ee55a: af000000		mc	0,0
> >           >000002482f7ee55e: a7f4ffa9		brc	15,000002482f7ee4b0
> >            000002482f7ee562: 0707		bcr	0,%r7
> >            000002482f7ee564: 0707		bcr	0,%r7
> >            000002482f7ee566: 0707		bcr	0,%r7
> >            000002482f7ee568: 0707		bcr	0,%r7
> > [  215.672006] Call Trace:
> > [  215.672008]  [<000002482f7ee55e>] vfio_remove_dma+0xde/0xf0 [vfio_io=
mmu_type1]=20
> > [  215.672013]  [<000002482f7f03de>] vfio_iommu_type1_detach_group+0x3d=
e/0x5f0 [vfio_iommu_type1]=20
> > [  215.672016]  [<000002482f7d4c4e>] vfio_group_detach_container+0x5e/0=
x180 [vfio]=20
> > [  215.672023]  [<000002482f7d2ce0>] vfio_group_fops_release+0x50/0x90 =
[vfio]=20
> > [  215.672027]  [<00000248af25e1ee>] __fput+0xee/0x2e0=20
> > [  215.672031]  [<00000248aef19f18>] task_work_run+0x88/0xd0=20
> > [  215.672036]  [<00000248aeef559a>] do_exit+0x18a/0x4e0=20
> > [  215.672042]  [<00000248aeef5ab0>] do_group_exit+0x40/0xc0=20
> > [  215.672045]  [<00000248aeef5b5e>] __s390x_sys_exit_group+0x2e/0x30=
=20
> > [  215.672048]  [<00000248afc81e56>] __do_syscall+0x136/0x340=20
> > [  215.672054]  [<00000248afc8da7e>] system_call+0x6e/0x90=20
> > [  215.672058] Last Breaking-Event-Address:
> > [  215.672059]  [<000002482f7ee4aa>] vfio_remove_dma+0x2a/0xf0 [vfio_io=
mmu_type1]
> > [  215.672062] ---[ end trace 0000000000000000 ]---
> > [  219.861940] ------------[ cut here ]------------
> >=20
> > ...
> >=20
> > [  241.164333] ------------[ cut here ]------------
> > [  241.164340] kernel BUG at drivers/vfio/vfio_iommu_type1.c:1480!
> > [  241.164358] monitor event: 0040 ilc:2 [#1]SMP=20
> > [  241.164363] Modules linked in: vhost_vsock vmw_vsock_virtio_transpor=
t_common vsock vhost
> > vhost_iotlb algif_hash af_alg kvm nft_masq nft_ct nft_reject_ipv4 nf_re=
ject_ipv4 nft_reject act_csum
> > cls_u32 sch_htb nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_def=
rag_ipv4 nf_tables pkey_pckmo
> > s390_trng pkey_ep11 pkey_cca zcrypt_cex4 zcrypt eadm_sch rng_core vfio_=
ccw mdev vfio_iommu_type1
> > vfio drm sch_fq_codel i2c_core drm_panel_orientation_quirks dm_multipat=
h loop nfnetlink ctcm fsm
> > zfcp scsi_transport_fc mlx5_ib diag288_wdt mlx5_core ghash_s390 prng ae=
s_s390 des_s390 libdes
> > sha3_512_s390 sha3_256_s390 sha512_s390 sha1_s390 sha_common rpcrdma su=
nrpc rdma_ucm rdma_cm
> > configfs iw_cm ib_cm ib_uverbs ib_core scsi_dh_rdac scsi_dh_emc scsi_dh=
_alua pkey autofs4
> > [  241.164399] CPU: 14 UID: 107 PID: 6581 Comm: qemu-system-s39 Kdump: =
loaded Tainted: G        W =20
> > 6.16.0-rc7-00005-g4ff8295d8d61 #79 NONE=20
> > [  241.164403] Tainted: [W]=3DWARN
> > [  241.164404] Hardware name: IBM 3906 M05 780 (LPAR)
> > [  241.164406] Krnl PSW : 0704e00180000000 000002482f7f132a (vfio_dma_d=
o_unmap+0x4aa/0x4b0
> > [vfio_iommu_type1])
> > [  241.164413]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:2=
 PM:0 RI:0 EA:3
> > [  241.164415] Krnl GPRS: 0000000000000000 000000000000000b 00000000400=
00000 000000008cfdcb40
> > [  241.164418]            0000000000001001 0000000000000001 00000000000=
00000 0000000040000000
> > [  241.164419]            0000000000000000 0000000000000000 00000001fbe=
7f140 000000008cfdcb40
> > [  241.164421]            000003ff97dacfa8 0000000000000000 00000000871=
582c0 000001c8b4177cd0
> > [  241.164428] Krnl Code: 000002482f7f131e: a7890000		lghi	%r8,0
> >            000002482f7f1322: a7f4feeb		brc	15,000002482f7f10f8
> >           #000002482f7f1326: af000000		mc	0,0
> >           >000002482f7f132a: 0707		bcr	0,%r7
> >            000002482f7f132c: 0707		bcr	0,%r7
> >            000002482f7f132e: 0707		bcr	0,%r7
> >            000002482f7f1330: c0040000803c	brcl	0,000002482f8013a8
> >            000002482f7f1336: eb6ff0480024	stmg	%r6,%r15,72(%r15)
> > [  241.164458] Call Trace:
> > [  241.164459]  [<000002482f7f132a>] vfio_dma_do_unmap+0x4aa/0x4b0 [vfi=
o_iommu_type1]=20
> > [  241.164463]  [<000002482f7f1d08>] vfio_iommu_type1_ioctl+0x1c8/0x370=
 [vfio_iommu_type1]=20
> > [  241.164466]  [<00000248af27704e>] vfs_ioctl+0x2e/0x70=20
> > [  241.164471]  [<00000248af278610>] __s390x_sys_ioctl+0xe0/0x100=20
> > [  241.164474]  [<00000248afc81e56>] __do_syscall+0x136/0x340=20
> > [  241.164477]  [<00000248afc8da7e>] system_call+0x6e/0x90=20
> > [  241.164481] Last Breaking-Event-Address:
> > [  241.164482]  [<000002482f7f1238>] vfio_dma_do_unmap+0x3b8/0x4b0 [vfi=
o_iommu_type1]
> > [  241.164486] Kernel panic - not syncing: Fatal exception: panic_on_oo=
ps
>=20
> Thanks for the report. After a review of this commit, it appears that
> only the changes to vfio_find_vpfn() could plausibly account for the
> observed issue (I cannot be absolutely certain). Could you kindly test
> whether the issue persists after applying the following patch?

Hi Zhe,

Thank you for the quick patch! I applied this and ran through a few cycles =
of the previously-
problematic tests, and things are holding up great.

It's probably a fixup to the commit here, but FWIW:

Tested-by: Eric Farman <farman@linux.ibm.com>

Thanks,
Eric

>=20
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_ty=
pe1.c
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -344,7 +344,7 @@ static struct vfio_pfn *vfio_find_vpfn_range(struct v=
fio_dma *dma,
> =20
>  static inline struct vfio_pfn *vfio_find_vpfn(struct vfio_dma *dma, dma_=
addr_t iova)
>  {
> -       return vfio_find_vpfn_range(dma, iova, iova + PAGE_SIZE);
> +       return vfio_find_vpfn_range(dma, iova, iova + 1);
>  }
>=20
> Thanks,
> Zhe

