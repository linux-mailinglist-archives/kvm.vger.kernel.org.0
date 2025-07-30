Return-Path: <kvm+bounces-53722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 961FBB15A3A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 10:13:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5D0216C4E7
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 08:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53494264A6E;
	Wed, 30 Jul 2025 08:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BzsuygLg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED02254AFF;
	Wed, 30 Jul 2025 08:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753863205; cv=none; b=SLMvw9O102tLWeUkHq7TDbn25/C1FDHRXqmdsrrtKQsT01hKjjh2KJxRLKIM8/G9Pvhg2YBULQGWTlTnyWLXeAi/DLSOnBrMwntMS1pH9zPe9GIj7Inj/QKWiPpRoLb/MgseziSfTq2iHaULEXa0wmM04Zp+36QDIdeaeCVoVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753863205; c=relaxed/simple;
	bh=Z+LZaCKeB+4hDmhyEpWk6i9kAFfg72w1JRzw0lziIwg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aRmjAez0HCuvW2yKaVVzPIquBoPR8b9LPp1CbyfRXpvdYbitcHIWOSyTzj+kLY1e5cLJ67Zg1tW/+ej4bKovEJ7A4kgVowRdVNRy6xuNT0ydCFeAC3uNtJmsnzXAut5Lm2vXVP9IHj/pNOI/zk9Q8VUHCp23je1vqBzTpxigyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BzsuygLg; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56TNm6o9022019;
	Wed, 30 Jul 2025 08:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=k+Ktn0fr5ustoFIBgJ3ExzAeUyCFEFHYlWRtcviFV
	cU=; b=BzsuygLgFx7qyrHCi53WxFMcyylBV8HGA/Yvsy4OAt+mX0yougrd3Y3XT
	5BIH+z/OMzj1rlKqPqL5P+3gcitgA0TbT30W3KX7OP4yLgxa8qmOP7xAcx5gUkv3
	VfOUKMidclY8k04ibgsteQVJGj50EP40lTlyKILTgYZBIAMveNVTCknXUpOuxM7o
	KGzspjfnLl2EkDe9KdeXFq+4RJaJxa5p4y/7tD5vhOChMZsoOiYh4m+gzWskiOoA
	39YdC/oZ6SYqxsEOYZp+OfGs2rwNjquPJwAUjw+SD3QXL2Z+GVg1zCVAMo0rGB8f
	o6lCC8RJCFK6X/9geoeuVgwfQCbYw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 484qemuf83-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:13:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 56U7uEnY028748;
	Wed, 30 Jul 2025 08:13:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 485c22p73m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Jul 2025 08:13:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 56U8D9au21627300
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Jul 2025 08:13:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B3102004B;
	Wed, 30 Jul 2025 08:13:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ED49B20040;
	Wed, 30 Jul 2025 08:13:08 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com.com (unknown [9.87.148.140])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Jul 2025 08:13:08 +0000 (GMT)
From: Janosch Frank <frankja@linux.ibm.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, frankja@linux.ibm.com, borntraeger@linux.ibm.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, ajd@linux.ibm.com,
        sfr@canb.auug.org.au
Subject: [GIT PULL 0/2] KVM: s390: updates for 6.17
Date: Wed, 30 Jul 2025 10:10:31 +0200
Message-ID: <20250730081224.38778-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: eN97iwKfSrwCJdYLPLRIFYP9E1d_fweD
X-Proofpoint-GUID: eN97iwKfSrwCJdYLPLRIFYP9E1d_fweD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMwMDA1MyBTYWx0ZWRfXylKP05ICaBUu
 A915jfNz1LFGzDuIQf1JhPlFt/vAj6MK8nhtbLFalixOlRodB4e2Vs2Ohj81/ThlE6uCXmWFyja
 5kncQZNyA7iMFGGJhvcpZVyxTQxSEuNz9Zst7xRujHob1fyWKt7gkfclUv1RrGXBCoOGWMyZruJ
 6TBFSYUywilIiS9GbBsI4Bhkn4ef4JWgv6jhZLdnbFJX5FRVoo7sm7XhO/oToTe+Nw8lK87lSgz
 wlxQXCjOwTIKH4lYQqqNskbzBJ0dHb6iKnLqCS9zSpwcQ37UB4WrdjxccjZWIb8mRWxej3058Fr
 xL1JcaEAcNT7lbTGd8jHUmMFPIXEAAAVKXSadTUbca0oM74705B3FNnGKTIiiqDiNDL42qT+4cd
 AKtAgS/baZcBbEqMwPx65iGfI0MuXSr/xXKOmpXwv0gIZ2rUX7p8nfp99GZ1n8heFJ6K7Kui
X-Authority-Analysis: v=2.4 cv=BJOzrEQG c=1 sm=1 tr=0 ts=6889d41a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=rOUgymgbAAAA:8
 a=tUJVMNxONFyKEEuN94kA:9 a=MP9ZtiD8KjrkvI0BhSjB:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-30_03,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=784 priorityscore=1501 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507300053

Paolo,

here are two fix patches that cleanup s390 guest entry.
They've been part of our CI runs for a couple of weeks now.

These patches went through a couple of hands before hitting our next branch [1].
Additionally Stephen found and fixed a merge conflict with 
a70e9f647f50 ("entry: Split generic entry into generic exception and syscall entry")[2]

Please pull.


Cheers,
Janosch

---

The following changes since commit e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/kvm-s390-next-6.17-1

for you to fetch changes up to 57d88f02eb4449d96dfee3af4b7cd4287998bdbd:

  KVM: s390: Rework guest entry logic (2025-07-21 13:01:03 +0000)

---

[1] https://lore.kernel.org/linux-s390/20250708092742.104309-1-ajd@linux.ibm.com/
[2] https://lore.kernel.org/linux-next/20250729105655.286c0496@canb.auug.org.au/

---

Mark Rutland (2):
  entry: Add arch_in_rcu_eqs()
  KVM: s390: Rework guest entry logic

 arch/s390/include/asm/entry-common.h | 10 ++++++
 arch/s390/include/asm/kvm_host.h     |  3 ++
 arch/s390/kvm/kvm-s390.c             | 51 +++++++++++++++++++++-------
 arch/s390/kvm/vsie.c                 | 17 ++++------
 include/linux/entry-common.h         | 16 +++++++++
 kernel/entry/common.c                |  3 +-
 6 files changed, 77 insertions(+), 23 deletions(-)

-- 
2.50.1


