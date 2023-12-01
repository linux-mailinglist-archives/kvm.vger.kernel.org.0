Return-Path: <kvm+bounces-3123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7761C800C3D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 14:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33CFF281AEB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 13:33:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7543B38F9C;
	Fri,  1 Dec 2023 13:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hBMEToj2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF07A6;
	Fri,  1 Dec 2023 05:33:14 -0800 (PST)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1DUsUs028075;
	Fri, 1 Dec 2023 13:33:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YbinJJEfA48lrkAAKeh6r9iWp89D+6qAVeEsTXi02DE=;
 b=hBMEToj2+meL8FQZVe/sytJqgsBqHGhWYhcgcC1BVB7mf/LoU1TU2MWxDv6wES6KvlHR
 aI5hxs2V117vxge+BtZqkRG22Gv9eJ2oq8lV6UTQAW7w8kiBBLjoXdqxh3VuZguLLc67
 NPsx6By8k5Rnv46kb9KCVXa3LrBaK/VVnhsZ/IxJVH6ighmku1Ptcnh2oJlbXvHh/Ndm
 k4Naz1y3rtJ+Cyzvse5IzK2bELL8krV/Rez0GsJjjRIe5l+IctgMIb131aDpuN9yCoev
 yyX9nyDS2f10pmlhZRQKFev3flzgtx+qqk5NmizmqEXb/nC45aMpD9225jtXp4YNiTWR yg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqf2m3m6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:33:04 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B1DV4ke028983;
	Fri, 1 Dec 2023 13:33:03 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uqf2m3m54-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:33:03 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B1AXsrs031709;
	Fri, 1 Dec 2023 13:27:15 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ukun05dkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 01 Dec 2023 13:27:15 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B1DRC2G22020730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 1 Dec 2023 13:27:12 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0B3312004B;
	Fri,  1 Dec 2023 13:27:12 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B54420040;
	Fri,  1 Dec 2023 13:27:08 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.171.33.138])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  1 Dec 2023 13:27:08 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Fri, 01 Dec 2023 18:57:07 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Jordan Niethe <jniethe5@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>, mikey@neuling.org,
        paulus@ozlabs.org, sbhat@linux.ibm.com, gautam@linux.ibm.com,
        kconsul@linux.vnet.ibm.com, amachhiw@linux.vnet.ibm.com,
        David.Laight@ACULAB.COM
Subject: [PATCH 09/12] KVM: PPC: Book3S HV nestedv2: Do not call H_COPY_TOFROM_GUEST
Date: Fri,  1 Dec 2023 18:56:14 +0530
Message-ID: <20231201132618.555031-10-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201132618.555031-1-vaibhav@linux.ibm.com>
References: <20231201132618.555031-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d_3ZE0VQY4bp4ezLhtRUdkL9GYphaQ2w
X-Proofpoint-ORIG-GUID: Mv8krihuec8mnqhlcmrZxrVbkOj8KX4o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-01_11,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=655 mlxscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2312010092

From: Jordan Niethe <jniethe5@gmail.com>

H_COPY_TOFROM_GUEST is part of the nestedv1 API and so should not be
called by a nestedv2 host. Do not attempt to call it.

Signed-off-by: Jordan Niethe <jniethe5@gmail.com>
---
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 916af6c153a5..4a1abb9f7c05 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -40,6 +40,9 @@ unsigned long __kvmhv_copy_tofrom_guest_radix(int lpid, int pid,
 	unsigned long quadrant, ret = n;
 	bool is_load = !!to;
 
+	if (kvmhv_is_nestedv2())
+		return H_UNSUPPORTED;
+
 	/* Can't access quadrants 1 or 2 in non-HV mode, call the HV to do it */
 	if (kvmhv_on_pseries())
 		return plpar_hcall_norets(H_COPY_TOFROM_GUEST, lpid, pid, eaddr,
-- 
2.42.0


