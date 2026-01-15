Return-Path: <kvm+bounces-68247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB92FD28725
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:37:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BF1A30ABB1B
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:37:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A39324B20;
	Thu, 15 Jan 2026 20:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dznVJvgW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66EB530B53F;
	Thu, 15 Jan 2026 20:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509434; cv=none; b=sEYOiI1M+tRu5vci6cBiW6diKls9hUbyGA9agselkL20DiZUmqUTl9WZ4PirDVPhRFYEf30b3VEM7lgi8D4FuwJZ56+EILlVK7pkHNaUvtM9u7wpMK+6fAZPu2lRrrQQkkbm/BhAxHwrTnYwN7iLRbD+VofjUm1lJ3bO5p/dYgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509434; c=relaxed/simple;
	bh=atSnSNGUCMvqfMxFOoNvSp3wbHU40Yrg32Mfk4tSgO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoYt4VaY2X/ks9vloOUeYewdTWG74Yr9sq+gVSw9zAHps9G9944nRA/h8hMfSd0IMKmls4PFTSdh9KHrAIe7g8xrvrXBzKWpgmak9pSqAS/rw44fOsDHJqZI7jsDtyroBEdeV8nJpZvOnNdL2NboRBFZm50cXMJoiFGnhcRjDd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dznVJvgW; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGpavP2754251;
	Thu, 15 Jan 2026 20:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=LNSBs
	EGycB+YY3yU8y9K67W3Lr04PTVlTszV4LeZMgE=; b=dznVJvgWKMeg63S7rXT18
	N3yFkH86CJM0B495gM0DdXsrhuZ/5WXf7gbqXr2kvJpF4F7ZWPjv/MJ8dKq7cKbZ
	lEzvkOpcinAW9kh+zbUSJqdHPrpz97LDs2sYlnkex59fFnDlUOZnlE4nyShp0L6U
	7TJ62VwdG+pYKQ3xefGN6t9B0ep6ghYinBEkseQRuKrjr+eXgOiir/eLBospm3DB
	h+V5jjgLFmpcdF4Oo8I8PQcct2J7n2OekAG0pFH47PsfiWP4cwcJlopKvOr/K7qN
	t9/3M2HA9/nPOzeSFmFGDbRY/BM/o9lZeS3i0ZFf2NJUrDoj833Ph7oLLcvfa7WL
	g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrkgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJLVZR035374;
	Thu, 15 Jan 2026 20:36:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bsw3q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:01 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60FKXKQR010408;
	Thu, 15 Jan 2026 20:36:01 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7bsw14-3;
	Thu, 15 Jan 2026 20:36:01 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dwmw2@infradead.org,
        dwmw@amazon.co.uk, paul@xen.org, tglx@kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com,
        dongli.zhang@oracle.com
Subject: [PATCH 2/3] KVM: x86: conditionally clear KVM_REQ_MASTERCLOCK_UPDATE at the end of KVM_SET_CLOCK
Date: Thu, 15 Jan 2026 12:22:30 -0800
Message-ID: <20260115202256.119820-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260115202256.119820-1-dongli.zhang@oracle.com>
References: <20260115202256.119820-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150161
X-Proofpoint-GUID: Y0PaUXtQa8w_bd5geJNOl64Ua1ebWHQH
X-Proofpoint-ORIG-GUID: Y0PaUXtQa8w_bd5geJNOl64Ua1ebWHQH
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=69694fb2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=pBOR-ozoAAAA:8 a=yPCof4ZbAAAA:8
 a=xtrMm11tuchXP9ObCAUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE2MSBTYWx0ZWRfX91Nv2gRh1BnK
 E1zJTO2ftc0OalpMrcfha/RxKEpw3w0BIuTj1pCb20piYXVPdJ9ltGwXKZzgfD8p7nHi2UXidsK
 pA5CS8wcTk9NFa5+JM55HdbGDd0ubnBB457pZflMLCmJMOVAXzOQfefyre2WfSCm4UQFyiGhnuc
 pcFrtIaHFrkzula1DX34NFa9niWNrG7bGxNWS617JAGNmGyzGtiP58zfdMWoV4CDqdh2F9MvZn5
 VkWgWs8AWAwoRFXPNNjKoaAwMVge8U+fDCO0jcuatnQtI89x/cvVRf/atSWW6dEcT8BDvHpuo5s
 1c6bHZzr0ng/Dj5KbI+Grn7Gz7h70nYV/GluzwDN0Yr+LQ7KPI+LVZneBvlNGz5RqzsaIXYYI+x
 LfkxCohemEJnpzyrE2nvooPzfFyA7+A0mpmhuqd/YrWzxtGgtm58oUwrqZjVPwnRxd495FHsK1d
 wVSIGeo3ia3VvMbOPKQ==

The KVM_SET_CLOCK command calls pvclock_update_vm_gtod_copy() to update the
masterclock data.

Many vCPUs may already have KVM_REQ_MASTERCLOCK_UPDATE pending before
KVM_SET_CLOCK is invoked. If pvclock_update_vm_gtod_copy() decides to use
the masterclock, there is no need to update the masterclock multiple times
afterward. As noted in commit c52ffadc65e2 ("KVM: x86: Don't unnecessarily
force masterclock update on vCPU hotplug"), each unnecessary
KVM_REQ_MASTERCLOCK_UPDATE can cause the kvm-clock time to jump.

Therefore, clear KVM_REQ_MASTERCLOCK_UPDATE for each vCPU at the end of
KVM_SET_CLOCK when the master clock is active. The 'tsc_write_lock' ensures
that only requests issued before KVM_SET_CLOCK are cleared.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5e7418cfd0af..0599949a7803 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7173,6 +7173,8 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_arch *ka = &kvm->arch;
 	struct kvm_clock_data data;
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 	u64 now_raw_ns;
 
 	if (copy_from_user(&data, argp, sizeof(data)))
@@ -7211,6 +7213,12 @@ static int kvm_vm_ioctl_set_clock(struct kvm *kvm, void __user *argp)
 	else
 		now_raw_ns = get_kvmclock_base_ns();
 	ka->kvmclock_offset = data.clock - now_raw_ns;
+
+	if (kvm->arch.use_master_clock) {
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			kvm_clear_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+	}
+
 	kvm_end_pvclock_update(kvm);
 	return 0;
 }
-- 
2.39.3


