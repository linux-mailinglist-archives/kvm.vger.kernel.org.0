Return-Path: <kvm+bounces-48528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD03CACF2F6
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 17:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 48CE71893CFF
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 15:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 689151DE2BD;
	Thu,  5 Jun 2025 15:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oMMo+i+e"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90DE198A2F
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749137113; cv=none; b=KSV18yJu/HQ7K5JiYKn5s7d7MGSSGWZtO96KShBUcGzW7QNHuXwdkC0D7P00BJE/clqjq3ijemlKJxc8h8YzFQoFfr7NmOEzUcNETWu8B+tO2ml+24IGS7U5DbdEX0C+7jigNbAJMozukZ7Z+Ik5djilA+SahStLMnTjWACVDzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749137113; c=relaxed/simple;
	bh=s8j3KrbHnhPOaTY8IAydz5/vIdM8uAGt1B3a+oScVr0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DPsZQCAuhMd+nfLpe15PhmpcmyJmrEomghm+bEudAgT4Vr+8QDf89svN6mi5bz+2IQpJcePetHApiAGm5NevkNosLx81NaZa2HE4qDnt75HRZGoeU1TISmehUgBVKuSKnT65WAIqbJC3pOlymlnXLWuTzNbtWr68ZoBy7rCX4Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oMMo+i+e; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555AtW6x001121;
	Thu, 5 Jun 2025 15:25:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=q81kYix3nk6+D3y4tI333zhfbik3B
	U0UxC/k7QO0HSY=; b=oMMo+i+eEls4TrE8mGW7pyPdnc6TLuF12A4/Gy3/2pXvX
	dvNjXW8rAasCGFcB+RBH9Bo1WSKBaKW+fld+w2oqd2QvzN6YnD321GAnnapcsUXA
	wQIkFzoxG177zcfmCBtk3DMC/6KoCn0Up2iYhDLVRea6Bz86WD26d1EtXX2vz3vS
	uL7als0IUriFrip2t4r2Dt3KKbKJZFmgy22TNybvFGbBWlWvVDrcJawOnViWzn3t
	RxmU9tnvS4cQsXyBh02YdwxArNbzG9L+O4CRQVCk2JGeAfdeVzqQPHfzP9C3FSQd
	vt10U/YSzRyJoMUDpYhGygsvbnPY1MbKCsoc9cT/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8dxdq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555DoImj038511;
	Thu, 5 Jun 2025 15:25:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7c8buk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 15:25:05 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 555FP4ls016227;
	Thu, 5 Jun 2025 15:25:04 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46yr7c8bt3-1;
	Thu, 05 Jun 2025 15:25:04 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH 0/3] SEV-SNP fix for cpu soft lockup on 1TB+ guests
Date: Thu,  5 Jun 2025 15:24:59 +0000
Message-ID: <20250605152502.919385-1-liam.merwick@oracle.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=831 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050134
X-Authority-Analysis: v=2.4 cv=Va/3PEp9 c=1 sm=1 tr=0 ts=6841b6d2 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=1JC5xqyqxMlxYnEJmzwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDEzNCBTYWx0ZWRfX0LCX58lXGhlN kqVyeHb7ee1y8V5Na1nbAE7IOWnSLliyJ2xk0z9FsHXCVnVl+t2o/Zh/iHf9xsMLRfaO9h2BS+7 TkSXSFxcyds0A4mzvyJfgz0MJGGObIrkMPYVK1BxocJ4m45+zeVg8LHOlIL7CgKkcILpXCyyS7/
 x41bYk97XfIK/k0QOXkL9J8wTmROzq1sPjrGy9GQMi/kLpvVHL/B3qWjEj9+zzVmHgsGTkgdH5I JWqXryGXJykaTGmRlUkxhL1TtWeTCbznVF4gSIcacPSfXaunL4WOKVmGwXqUQawoQ4wTDlXH0si Lz3xiw3e7uVI/a6TqHJb9DuIor7debGtA4L0oZo5W0w1TTACjDuNOg/7gl3dTA85vz1lZXgDi1v
 RCBfBRfH2CANkOg1JyG7lhpu6pHq20KddoezeuA70bAyFL56jTHbrek5nW3OaDC/Hdrl1Zf0
X-Proofpoint-ORIG-GUID: LRbpDSobsmBJKaZk-3JGKGTdY8NUeiJs
X-Proofpoint-GUID: LRbpDSobsmBJKaZk-3JGKGTdY8NUeiJs

When creating SEV-SNP guests with a large amount of memory (940GB or greater)
the host experiences a soft cpu lockup while setting the per-page memory
attributes on the whole range of memory in the guest.

The underlying issue is that the implementation of setting the
memory attributes using an Xarray implementation is a time-consuming
operation (e.g. a 1.9TB guest takes over 30 seconds to set the attributes)

Fix the lockup by modifying kvm_vm_ioctl_set_mem_attributes() so that it
sets the attributes on, at most, a range of 512GB at a time and avoids
holding kvm->slot_lock for too long.

Apart from the lockup, the implementation to set memory attributes via Xarray
also results in a delay early in the boot of SEV-SNP/TDX guests - this fix
does not address that.  As it happens, the slowness of setting the attributes
was brought up by Michael Roth in the review of Ackerley Tng's series to add
1G page support for guest_memfd [1] where using a Maple Tree implementation
is being proposed to track shareability and Michael suggested that doing it
for KVM mem attributes would be useful also (it should avoid the SLU while
also taking less CPU time in general to populate). If that was implemented
in the future, it should address this lockup but I think there's benefit
in fixing the lockup issue now with a targeted fix.

[1] https://lore.kernel.org/all/20250529054227.hh2f4jmyqf6igd3i@amd.com 

Tested with VMs up to 1900GB in size (the limit of hardware available to me)

The functionality was introduced in v6.8 but I tagged as just needing
backporting as far as linux-6.12.y (applies cleanly)

Based on tag: kvm-6.16-1

Liam Merwick (3):
  KVM: Batch setting of per-page memory attributes to avoid soft lockup
  KVM: Add trace_kvm_vm_set_mem_attributes()
  KVM: fix typo in kvm_vm_set_mem_attributes() comment

 include/trace/events/kvm.h | 33 +++++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        | 43 ++++++++++++++++++++++++++++++++------
 2 files changed, 70 insertions(+), 6 deletions(-)

-- 
2.47.1


