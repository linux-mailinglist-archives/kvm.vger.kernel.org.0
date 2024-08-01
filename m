Return-Path: <kvm+bounces-22938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BB551944B52
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 14:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DCB91F22314
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 12:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E931A01DB;
	Thu,  1 Aug 2024 12:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qq5MwXm2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBD918950D
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 12:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722515479; cv=none; b=pN4cEwYcAkIQe9oXtgu70RA4iPyvOATHjts0kee4xQTZIfvu2k0e37Q8HhyM/juNXuHCoRUzAnPBoE+NCJXOY01UWSVy2h2WfZ2lYwfMZFNtjZoxpoyExv9difex49Vu98+pEo7pPCA5IavD/cZ4g6mo+2rcQGt+wJRqaiwxR4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722515479; c=relaxed/simple;
	bh=bHJR4JlVIwlvld9EBZLdOtnLSMIAElASlpiiWEYoAxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NoBef17GzNcH1bpl4MXZ7mxFTnEnN/FpxCfvT6za16fdB98bb/eOsBdBNz5O6Up03/S0G0Qs0bBdCFgm0otGKzJhHFCUEHoxoL7h+AeqcKdcUO763+z37QuOkKyVGDXIw1iGDM3WvMcLz3y4xml9O67KgLLVVCauhfELjsXJe8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qq5MwXm2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 471Bl5Ri004369
	for <kvm@vger.kernel.org>; Thu, 1 Aug 2024 12:31:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=VSeewc7OugFqmhjdphwaZaUD6s
	+wXoeAjl4Lo4YMV8M=; b=qq5MwXm2bH/rQpgBze5LmOu8UE03Z2iDmAgaXHkxw7
	IEoJ1NnkbSFfSsUEM9zEkPfqX2CjlFcumDVGoY6DUdqaSlV+LII1FWOhdqUSzotx
	z4gz/FOUPG0sdiI6XFyXXxBjk1Y6/G59SVnRXutxFTaR3wrH+d5xEsSm3Y2Wa3ZT
	Z2pow0BxADbYKv9LQBYXF6MnMKBqDbwC9dPinIXR6h9+L+qlVfKj5FwF2G65iNya
	IMDpo+HBvR8YZTCtz5abkeiJ/k0LgyQxUfERSHufiGDGCjXaUoeZ9xiVJKgxegG0
	6l4IggAAKhcymq+hG+ce4qRqtlh/zpm2PkGJf3XbZZQw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40r54urr2m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 12:31:15 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4719jmHg003856
	for <kvm@vger.kernel.org>; Thu, 1 Aug 2024 12:31:14 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 40ndemse8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 01 Aug 2024 12:31:14 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 471CV9Wv45351380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Aug 2024 12:31:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7F8112004E;
	Thu,  1 Aug 2024 12:31:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 655132004B;
	Thu,  1 Aug 2024 12:31:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  1 Aug 2024 12:31:09 +0000 (GMT)
From: Michael Mueller <mimu@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: borntraeger@linux.ibm.com, frankja@linux.ibm.com, nrb@linux.ibm.com,
        mimu@linux.ibm.com
Subject: [PATCH v2] KVM: s390: fix validity interception issue when gisa is switched off
Date: Thu,  1 Aug 2024 14:31:09 +0200
Message-ID: <20240801123109.2782155-1-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 86MY3wcMX4-cCQxbl4lPMX8eyXL6q_2S
X-Proofpoint-ORIG-GUID: 86MY3wcMX4-cCQxbl4lPMX8eyXL6q_2S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-01_08,2024-08-01_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=929 bulkscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 clxscore=1011 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2408010080

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
2.43.0


