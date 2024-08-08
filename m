Return-Path: <kvm+bounces-23631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A9F0894C07A
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 17:02:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 035611F2BECE
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA67118F2F6;
	Thu,  8 Aug 2024 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gMTg9kBG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E833718C34D;
	Thu,  8 Aug 2024 15:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723129308; cv=none; b=swuGRM9StEJybs8sxIYhN7tTOZBWJiLfcEhlGN7pVXQeswfI4Or8iP/Q9YlQWX20/fFB1WjQzsYQWU/HnkBpFdFY0B59C05hI8x3w2RHONNHK4TCU1axgKmJ2GPKwUDBhb/Wk8v2PUANnt6xaOCS7oWGRHafopywr7hpAoLwbK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723129308; c=relaxed/simple;
	bh=hoxf+hbC6Y+IbeALTMHxTLaJo9rT0u0vBQPCcgvhkow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuDw8VIIjnDV1BBCrUTLn1S25AV5rxW784UGfux1o9mTuRvlbbPezxuEBbgPAebpcqhrhWkY1dJumLs8zJ/JBz09KyA2JioZ5mx3xTQxt/EyNDeU9jriKtf6obk8QA8gsUfcwHQjtaBZXpbozc9kH1jZgIyrjuGHobhqIHrIZZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gMTg9kBG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 478CaLRX007445;
	Thu, 8 Aug 2024 15:01:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:mime-version; s=pp1; bh=VKS1xVMi4UZzv
	lDQJcqZovxfenfUy5skxwwQ8TNkLUg=; b=gMTg9kBG/fQoXL0Pwk7QDXnvo33TO
	AB4DXG+OqeE11CY+un63ul/emTetSFifVhkr+3O2cghirfjA/ne3/a9TFovffCmF
	PGXMC1smoPXCeoHBhdHRsAT3Gaa8zsfQVnI8xaMEIUE1CVTbahYApDTk1Pr2HGTT
	LH3LvzfXUkNa+Xg3x/u+ZtiQuxtD/tm3eXs5eBNRgDwOlxPvtWzGzftDlLy39Zw9
	9/q5kOb9nd1Y8ZpHiBPQvOuU7cMOMmSuxgcDZAdLip6WXa/dwplQ5Oyudr2bAbzs
	MyO1OFKtUq2LPRPGWE6O6nJPcetsNc1dFLzVmM5SobhrJJYXdpNs5Fg8g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40vwkbrdne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:37 +0000 (GMT)
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 478F1anl031575;
	Thu, 8 Aug 2024 15:01:36 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40vwkbrdnb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 478EMPBv024386;
	Thu, 8 Aug 2024 15:01:36 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 40sy90y0pq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Aug 2024 15:01:35 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 478F1Uq857016766
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Aug 2024 15:01:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F92C20049;
	Thu,  8 Aug 2024 15:01:30 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7AE622004B;
	Thu,  8 Aug 2024 15:01:29 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.171.38.33])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Aug 2024 15:01:29 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        Michael Mueller <mimu@linux.ibm.com>, stable@vger.kernel.org
Subject: [GIT PULL 1/2] KVM: s390: fix validity interception issue when gisa is switched off
Date: Thu,  8 Aug 2024 16:52:12 +0200
Message-ID: <20240808150026.11404-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240808150026.11404-1-frankja@linux.ibm.com>
References: <20240808150026.11404-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6wPf03SuAUuF3qzHvT6B9hHoISlJChZK
X-Proofpoint-ORIG-GUID: 9bfIHlp_rMLea-dBLMJ49V3hHCIqmD_v
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-08_15,2024-08-07_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 spamscore=0 mlxscore=0 clxscore=1011
 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408080103

From: Michael Mueller <mimu@linux.ibm.com>

We might run into a SIE validity if gisa has been disabled either via using
kernel parameter "kvm.use_gisa=0" or by setting the related sysfs
attribute to N (echo N >/sys/module/kvm/parameters/use_gisa).

The validity is caused by an invalid value in the SIE control block's
gisa designation. That happens because we pass the uninitialized gisa
origin to virt_to_phys() before writing it to the gisa designation.

To fix this we return 0 in kvm_s390_get_gisa_desc() if the origin is 0.
kvm_s390_get_gisa_desc() is used to determine which gisa designation to
set in the SIE control block. A value of 0 in the gisa designation disables
gisa usage.

The issue surfaces in the host kernel with the following kernel message as
soon a new kvm guest start is attemted.

kvm: unhandled validity intercept 0x1011
WARNING: CPU: 0 PID: 781237 at arch/s390/kvm/intercept.c:101 kvm_handle_sie_intercept+0x42e/0x4d0 [kvm]
Modules linked in: vhost_net tap tun xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT xt_tcpudp nft_compat x_tables nf_nat_tftp nf_conntrack_tftp vfio_pci_core irqbypass vhost_vsock vmw_vsock_virtio_transport_common vsock vhost vhost_iotlb kvm nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables sunrpc mlx5_ib ib_uverbs ib_core mlx5_core uvdevice s390_trng eadm_sch vfio_ccw zcrypt_cex4 mdev vfio_iommu_type1 vfio sch_fq_codel drm i2c_core loop drm_panel_orientation_quirks configfs nfnetlink lcs ctcm fsm dm_service_time ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common dm_mirror dm_region_hash dm_log zfcp scsi_transport_fc scsi_dh_rdac scsi_dh_emc scsi_dh_alua pkey zcrypt dm_multipath rng_core autofs4 [last unloaded: vfio_pci]
CPU: 0 PID: 781237 Comm: CPU 0/KVM Not tainted 6.10.0-08682-gcad9f11498ea #6
Hardware name: IBM 3931 A01 701 (LPAR)
Krnl PSW : 0704c00180000000 000003d93deb0122 (kvm_handle_sie_intercept+0x432/0x4d0 [kvm])
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Krnl GPRS: 000003d900000027 000003d900000023 0000000000000028 000002cd00000000
           000002d063a00900 00000359c6daf708 00000000000bebb5 0000000000001eff
           000002cfd82e9000 000002cfd80bc000 0000000000001011 000003d93deda412
           000003ff8962df98 000003d93de77ce0 000003d93deb011e 00000359c6daf960
Krnl Code: 000003d93deb0112: c020fffe7259	larl	%r2,000003d93de7e5c4
           000003d93deb0118: c0e53fa8beac	brasl	%r14,000003d9bd3c7e70
          #000003d93deb011e: af000000		mc	0,0
          >000003d93deb0122: a728ffea		lhi	%r2,-22
           000003d93deb0126: a7f4fe24		brc	15,000003d93deafd6e
           000003d93deb012a: 9101f0b0		tm	176(%r15),1
           000003d93deb012e: a774fe48		brc	7,000003d93deafdbe
           000003d93deb0132: 40a0f0ae		sth	%r10,174(%r15)
Call Trace:
 [<000003d93deb0122>] kvm_handle_sie_intercept+0x432/0x4d0 [kvm]
([<000003d93deb011e>] kvm_handle_sie_intercept+0x42e/0x4d0 [kvm])
 [<000003d93deacc10>] vcpu_post_run+0x1d0/0x3b0 [kvm]
 [<000003d93deaceda>] __vcpu_run+0xea/0x2d0 [kvm]
 [<000003d93dead9da>] kvm_arch_vcpu_ioctl_run+0x16a/0x430 [kvm]
 [<000003d93de93ee0>] kvm_vcpu_ioctl+0x190/0x7c0 [kvm]
 [<000003d9bd728b4e>] vfs_ioctl+0x2e/0x70
 [<000003d9bd72a092>] __s390x_sys_ioctl+0xc2/0xd0
 [<000003d9be0e9222>] __do_syscall+0x1f2/0x2e0
 [<000003d9be0f9a90>] system_call+0x70/0x98
Last Breaking-Event-Address:
 [<000003d9bd3c7f58>] __warn_printk+0xe8/0xf0

Cc: stable@vger.kernel.org
Reported-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Fixes: fe0ef0030463 ("KVM: s390: sort out physical vs virtual pointers usage")
Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20240801123109.2782155-1-mimu@linux.ibm.com
Message-ID: <20240801123109.2782155-1-mimu@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index bf8534218af3..e680c6bf0c9d 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -267,7 +267,12 @@ static inline unsigned long kvm_s390_get_gfn_end(struct kvm_memslots *slots)
 
 static inline u32 kvm_s390_get_gisa_desc(struct kvm *kvm)
 {
-	u32 gd = virt_to_phys(kvm->arch.gisa_int.origin);
+	u32 gd;
+
+	if (!kvm->arch.gisa_int.origin)
+		return 0;
+
+	gd = virt_to_phys(kvm->arch.gisa_int.origin);
 
 	if (gd && sclp.has_gisaf)
 		gd |= GISA_FORMAT1;
-- 
2.46.0


