Return-Path: <kvm+bounces-46515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B89D0AB718C
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 18:35:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0C948C68DE
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 16:35:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A43A27E7EC;
	Wed, 14 May 2025 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zsz7YjqJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09D027A92C;
	Wed, 14 May 2025 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240508; cv=none; b=Ep3mMpRRTipFUFd86+yfYSjx1lG/FLxp2igHytgoVeJ3xipmkEDzr8eXAZ9X0dFZLbBgUitvjOSWKv+/1qeFq+fQLRzLIOC9YNyGpqCLSATVj1IfMcYOhZqBrzcNah/m5slkDC3CGhkjponBghw/CoKCbuea9mu6h/UYfWcD/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240508; c=relaxed/simple;
	bh=7DBzfhW9UYV0KScaA8ZdZ7S8hCtuUqBF35CzfESODSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R5lo21ZO3A98SjnhGrToVxty0sL8MalsBvPDd7ZZRCwHuKJFF2D2KPRD2vYyKqnqK2rATLkemi+kT35OQCdBMH/jF5uf6w6A+FFo6UteaOIcsNVYBOxxA9mDg/4zDsJHRkyReh3vAPcNjDbm4WREnhuYoJgIsA0e7qakvYLYTgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Zsz7YjqJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54EFkJiU026351;
	Wed, 14 May 2025 16:35:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8fmCVw
	qyJ5dpBqevj4HquKRB/BaZrS+I3yyJgiiHMMk=; b=Zsz7YjqJZWTuPBHIcgcsba
	COLmcJ2eCyl20IlKXGfAQfRNc9cW5r7WNc9QEP6ZH7H/h9PxTTs/ueU5z0akgpim
	Ov74TRnmGoplg/Q6kEc3VfGOjkhEj0RIfKk383rvahcpQLFFINbWkFzXEvwTvifW
	hGNSgkU8xgjmcYDfKEcqZ79jje/mdA6LaQvcgquNyQ3USXUNMFy4dHSN9D63ZiYq
	994rK22y5apnfPuKtk4OoLjmGf9n49ZOYPXHRKBrYEetDq1vQt8Jq2wDsRnNW0K6
	KSxL3cmOE3HShZhWweHtx7wvFpno/iNMvyoftMrGHurGU6oNfyXHG/exwvngHB8g
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46mnst32bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:35:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54EDU2eV021797;
	Wed, 14 May 2025 16:35:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46mbfpn9dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 16:35:02 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54EGYxkM51118434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 May 2025 16:34:59 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EFBF42008D;
	Wed, 14 May 2025 16:34:58 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82E0B2008B;
	Wed, 14 May 2025 16:34:58 +0000 (GMT)
Received: from darkmoore.ibmuc.com (unknown [9.111.91.37])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 May 2025 16:34:58 +0000 (GMT)
From: Christoph Schlameuss <schlameuss@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 1/3] KVM: s390: Set KVM_MAX_VCPUS to 256
Date: Wed, 14 May 2025 18:34:49 +0200
Message-ID: <20250514-rm-bsca-v1-1-6c2b065a8680@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ViujWQmibUndB4OxOe-1V0os-ssop9ET
X-Authority-Analysis: v=2.4 cv=V+590fni c=1 sm=1 tr=0 ts=6824c638 cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=wggSNQFzZ8jKG0l6iRoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: ViujWQmibUndB4OxOe-1V0os-ssop9ET
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDE0MyBTYWx0ZWRfX6IfugzaVgqKZ GlkUd0D4Mll92kVUSclL03zofL5A9FkK8JE+B69btdtAAmKROZBCiJBbs5Ul94ko1AQpylvTwYI mS0t6QabB9jnNU12TEJqew907/K+sFT38ESP1x/cxXdbiA62C0YBcDC6zCeP0+3zQVbZS4oydWr
 OqlFibYGTFK3uWeG8oc13vEHq6MXbEkMNeIXhTwk2UKSu2QG/4F9FS3lq8Qg5fXxRITM2ym0+Pa 0ZdnlHKuHuPz9d+mSy0Y8+ijkzQD8nsHu+c0NxAv+N5GBKSje/CU+995Fqa5UtneNSUjAJod6w8 Ui20Arrc43WDZw7DnTrclWYBD3Ur7xLxz9dq5QytpglxF73/KzOlM0p/EpSmX9ALbYcEb/wgL9z
 pnbxP4wTJcl/bOrJJdN2MYasUkMm09z0KQItSVYuCaeENSvuSREL/eIZtg+Fs+Aghoxuiypq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_04,2025-05-14_03,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 mlxlogscore=634 lowpriorityscore=0 bulkscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 phishscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505140143

The s390x architecture allows for 256 vCPUs with a max CPUID of 255.
The current KVM implementation limits this to 248 when using the
extended system control area (ESCA). So this correction should not cause
any real world problems but actually correct the values returned by the
ioctls:

* KVM_CAP_NR_VCPUS
* KVM_CAP_MAX_VCPUS
* KVM_CAP_MAX_VCPU_ID

KVM_MAX_VCPUS is also moved to kvm_host_types to allow using this in
future type definitions.

Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 arch/s390/include/asm/kvm_host.h       | 2 --
 arch/s390/include/asm/kvm_host_types.h | 2 ++
 arch/s390/kvm/kvm-s390.c               | 2 ++
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cb89e54ada257eb4fdfe840ff37b2ea639c2d1cb..f51bac835260f562eaf4bbfd373a24bfdbc43834 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -27,8 +27,6 @@
 #include <asm/isc.h>
 #include <asm/guarded_storage.h>
 
-#define KVM_MAX_VCPUS 255
-
 #define KVM_INTERNAL_MEM_SLOTS 1
 
 /*
diff --git a/arch/s390/include/asm/kvm_host_types.h b/arch/s390/include/asm/kvm_host_types.h
index 1394d3fb648f1e46dba2c513ed26e5dfd275fad4..9697db9576f6c39a6689251f85b4b974c344769a 100644
--- a/arch/s390/include/asm/kvm_host_types.h
+++ b/arch/s390/include/asm/kvm_host_types.h
@@ -6,6 +6,8 @@
 #include <linux/atomic.h>
 #include <linux/types.h>
 
+#define KVM_MAX_VCPUS 256
+
 #define KVM_S390_BSCA_CPU_SLOTS 64
 #define KVM_S390_ESCA_CPU_SLOTS 248
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3f3175193fd7a7a26658eb2e2533d8037447a0b4..b65e4cbe67cf70a7d614607ebdd679060e7d31f4 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -638,6 +638,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 			r = KVM_S390_ESCA_CPU_SLOTS;
 		if (ext == KVM_CAP_NR_VCPUS)
 			r = min_t(unsigned int, num_online_cpus(), r);
+		else if (ext == KVM_CAP_MAX_VCPU_ID)
+			r -= 1;
 		break;
 	case KVM_CAP_S390_COW:
 		r = machine_has_esop();

-- 
2.49.0

