Return-Path: <kvm+bounces-48731-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8904EAD1A53
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 11:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4294916ADC3
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 09:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B83A24EA81;
	Mon,  9 Jun 2025 09:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="i0H04vqR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB8720B215
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 09:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749460290; cv=none; b=X81ZyIK8ri8HHxqmwULgOrA17shgwLHQbWse/I5IhKx3jw6aMsZBq9zvNsfBiT4D1Y33kXqy/EAVXKMeBbcgkWk3ca85sT0tqVgushu6xOlLIWMc8pwaWloHzC9zV2o6iMcJ4NpyUAUFtgJc9QOuaxcPT2IZtIMyFOFKPPYJuUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749460290; c=relaxed/simple;
	bh=q9BlRUZY35HiqqvBYpxMYn/bFd14G4xovKaIqPO52Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GVXwpX2K9OrClv02WrgsM+JObDhQhhWFPH6pzd52pKSV7c5seWNu77qDdFPHvikmfIkODCOg5wJ9q1J1jigsqYzqURr+BsB2Y37RpegnzdkjYWzoGTD9zB8XooKbO37JNVqnn2QxUPsjFqqtH5FMnvrbiJJq+gqYCPKkxNLIPDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=i0H04vqR; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5593isHl011793;
	Mon, 9 Jun 2025 09:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=GiT7pZRLQXdhwvjLTunzSHOA2xNnM
	E5GnB52/oFPRK4=; b=i0H04vqRxBx06qHYcpsqzEjrOmPI1GAg4vPdLjeb5KoP/
	weiZL1upEoC0Kj1y9nNh4dhVzwoDRBnNmOJxxfRnscRmMPUkDLWjU5Ptit4E+DAq
	ldfGLTo9f9+239BZeqp3+hUtkMoVkifROeUj+DFUDvn9cRf4xyevX+GivruJd8Gq
	KZfdpPoHGTTcgDEFn8QdOoGkaC7YYlc468n8ijzx8+kmUypfwo+VrEXeoKONOPKa
	SRV37Y1D/9O9G4p0aQaBtfUtKotz5XP3O7qgVkprK8Z8bjqVK2D5UyDKB7RA1bxj
	KD7POKof4oRXO6gDBeAjPiPQWpFn1kuHcKpWEWtvQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf1t7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55996FtS032088;
	Mon, 9 Jun 2025 09:11:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv77ne5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Jun 2025 09:11:23 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5599BMix030518;
	Mon, 9 Jun 2025 09:11:22 GMT
Received: from lmerwick-vm-ol8.osdevelopmeniad.oraclevcn.com (lmerwick-vm-ol8.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.219])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 474bv77nds-1;
	Mon, 09 Jun 2025 09:11:22 +0000
From: Liam Merwick <liam.merwick@oracle.com>
To: kvm@vger.kernel.org
Cc: liam.merwick@oracle.com, pbonzini@redhat.com, seanjc@google.com,
        thomas.lendacky@amd.com, michael.roth@amd.com, tabba@google.com,
        ackerleytng@google.com
Subject: [PATCH v2 0/3] SEV-SNP fix for cpu soft lockup on 1TB+ guests
Date: Mon,  9 Jun 2025 09:11:18 +0000
Message-ID: <20250609091121.2497429-1-liam.merwick@oracle.com>
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
 definitions=2025-06-09_03,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506090070
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=6846a53c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=znXdRrifEY1hdDMAd4AA:9
X-Proofpoint-GUID: Tkf3Gg6uHWHfukmzJTb02_Ur909Wkmqv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA5MDA3MCBTYWx0ZWRfX3PEi8XfCq4+5 o2ztaWHhBlr3B5WRBWHjrTaRHVPHpY1NVZKCQAvDeQHCy5nZoJd419EON5Sz+Rcpz4FePBrrJeR iaJluzmzrSrSajaCJBs7rV8RfmiZcl5rP+kYD7DMCOu8iHngV0Rjxgsb9ukLNw2pTeHvwAs3JET
 qUP6enCDsUTOpu17mAN5MF6t3AxXp9hTf380MPLZljIv40g09GqUc7rPvzkFjI52Fs/fR6W6MZr qAIBmByo5cVBi9yJPw5uJPmMV6EpxDmQ/7iQqm0c6wzAileWDABDR/TOjF3t5IPHbi7HGUsSFZV yVxcKnJdAGgq0k9IyrmUETAdaBh8RQ+9Gg3QsWB7Uq7tMcciM/bSiWF2jYA7zQUK9LHnjFqkpen
 /zF6IeQvCyjoBYv9ghgbb1UVUPP2v2kdsikiglqLUSzLaZcYEoJfE3HCrOcQVrHILle+M6lS
X-Proofpoint-ORIG-GUID: Tkf3Gg6uHWHfukmzJTb02_Ur909Wkmqv

When creating SEV-SNP guests with a large amount of memory (940GB or greater)
the host experiences a soft cpu lockup while setting the per-page memory
attributes on the whole range of memory in the guest.

The underlying issue is that the implementation of setting the
memory attributes using an Xarray implementation is a time-consuming
operation (e.g. a 1.9TB guest takes over 30 seconds to set the attributes)

Fix the lockup by modifying kvm_vm_set_mem_attributes() to call cond_resched()
during the loops to reserve and store the Xarray entries to give the scheduler
a chance to run a higher priority task on the runqueue if necessary and avoid
staying in kernel mode long enough to trigger the lockup.

Tested with VMs up to 1900GB in size (the limit of hardware available to me)

The functionality was introduced in v6.8 but I tagged as just needing
backporting as far as linux-6.12.y (applies cleanly)

Based on tag: kvm-6.16-1

v1 -> v2
Implement suggestion by Sean to use cond_resched() rather than splitting operations
into batches.

v1: https://lore.kernel.org/all/20250605152502.919385-1-liam.merwick@oracle.com 

Liam Merwick (3):
  KVM: Allow CPU to reschedule while setting per-page memory attributes
  KVM: Add trace_kvm_vm_set_mem_attributes()
  KVM: fix typo in kvm_vm_set_mem_attributes() comment

 include/trace/events/kvm.h | 27 +++++++++++++++++++++++++++
 virt/kvm/kvm_main.c        |  7 ++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)

-- 
2.47.1


