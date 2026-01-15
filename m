Return-Path: <kvm+bounces-68246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D3295D2870F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:37:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F1373044BAC
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCE8C322B74;
	Thu, 15 Jan 2026 20:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sUw/reuJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2F127732;
	Thu, 15 Jan 2026 20:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509429; cv=none; b=qPTlH3tqKvYAUOvC1KQolkRiNwDvTJmhaIPdCyi2bq+I3DZb99x7HAwOJC0u8oWRywmQWe6p1UhdsONV3238atB8YKU+HJieUncTEYLg4iiyv172O3Shfy2rCvuq2wqYPs9tKDTVIOryfFCqZuVPqW/erj5wcgeJCWyhfnSgELg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509429; c=relaxed/simple;
	bh=x9drjpNdk0OcwrrATaj/vALUYVz/ueJrvGK4EhONfYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrIxaNsdmmvj5LELDbLVp+Fyl3Z3fnKPwaWaTiErzdNXS5oudHZg4r2eikVe4PxtdqsMub+gwSTbd9/hQQxQUTmjSj6K3K4092BWlFJMYswRhJPZ01yMzFWV3Nw5MVDxy6xt2lIhNHOQ01layTf9fn4D3dnlxgaQoBkR9wc/RaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sUw/reuJ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FH5a2H1360843;
	Thu, 15 Jan 2026 20:36:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=2bFhq
	W+1koXRCrousnKYAoJXdN67c6lKmOJvXkEhZSs=; b=sUw/reuJ5L2PnUHb0JBU2
	k6b377QShm0bKj0+1BVlw9ZjDbIi6f8EJtwkCe3yiAj9XNvsD/w3gLkDCcR0ePEm
	AlJcvnmOXzeZo2xc2NBlSu41vqADIzOSDcH1wAiYCYa+a8pYE59XeT0XGpC9pyLs
	nvv2h5ewqrD2QsHHaIpkxjgnRXzGjvaB57m8yHmSgQMqKgx8uQjFNxBXRdq4oM65
	dqkx/Pcha8iHZOGKXk+Ds04f7isrtir9Tx/nBhJcCZP2D2jeoD4L5Uolc2+t9i+M
	FC0HoqmuNvvZsuu0B01Va/bYD/rMQxVD2ujJtnh1mfzEVt50WHg8KOQvLknqaUHw
	Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5vp3v8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FKIlS4034710;
	Thu, 15 Jan 2026 20:36:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bsw2p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60FKXKQP010408;
	Thu, 15 Jan 2026 20:36:00 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7bsw14-2;
	Thu, 15 Jan 2026 20:35:59 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dwmw2@infradead.org,
        dwmw@amazon.co.uk, paul@xen.org, tglx@kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com,
        dongli.zhang@oracle.com
Subject: [PATCH 1/3] KVM: x86: Fix compute_guest_tsc() to cope with negative delta
Date: Thu, 15 Jan 2026 12:22:29 -0800
Message-ID: <20260115202256.119820-2-dongli.zhang@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE2MSBTYWx0ZWRfX4XWGV2aWTQFV
 QGJPeat/4rN0rh0uuOTl6NZFAcg/uY+x7KXjU9oiD7RSRChOIwSqLvQ0fxPR1y208RZ5QUQhMFZ
 ZHCJJu9bXvYzv97szi2qbJPg3+gMC2p6cyf52U+U8pCJA1hqHArjIaCyJ/uzhPH2ps4gtNYtIXS
 FDZRcbxN3RMTnXeDK20wdoBkLJP/y87U9i+PznW08+YGGL3jGsQc+stHFR9vIBPeL5sxqvkjxEO
 g8qeDgs5rK6cNBnuRo5roETpUhTIl6SugyBX43HpVcyd1BfmSC4EnYtNknCy3g/5MKji0lDRqk9
 6bpuBlKDZo/Qf3uVA6a9qi+S1HYmx+cyQWES0rNm8i/elbTmwEEghlJv42g5xaGgBYonwj5xMrk
 a3yEHvyID5wcWl61NhyV2z6KA1w3UbnG3g8PtDliUmtiH6BikEucsCtpdQyXlzFzjvJFYH2eHo7
 quSEXyfHwFbS816fGHQ==
X-Proofpoint-GUID: s9_OY21XVOVNIEobCpbNoF03Q21k6tVY
X-Authority-Analysis: v=2.4 cv=aZtsXBot c=1 sm=1 tr=0 ts=69694fb1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=pBOR-ozoAAAA:8 a=yPCof4ZbAAAA:8 a=eS-YMVMKI1Vx346kp8kA:9
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: s9_OY21XVOVNIEobCpbNoF03Q21k6tVY

From: David Woodhouse <dwmw@amazon.co.uk>

The upcoming patches will minimize the chances of updating the master clock
data. Unfortunately, this may cause issues in compute_guest_tsc().

Since the KVM clock reference point in master_kernel_ns might actually be
*earlier* than the reference point used for the guest TSC
(vcpu->last_tsc_nsec), this might lead to a negative delta to be passed to
pvclock_scale_delta(). Fix the compute_guest_tsc() function to cope with
negative numbers.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Link: https://lore.kernel.org/all/20240522001817.619072-11-dwmw2@infradead.org/
[Dongli: copy relevant code from above link and modify changelog]
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
This a partial copy of "[RFC PATCH v3 10/21] KVM: x86: Fix software
TSC upscaling in kvm_update_guest_time()", as Sean suggested, "Please do
this in a separate patch. There's no need to squeeze it in here, and this
change is complex/subtle enough as it is.", and David's authorship is
preserved.

 arch/x86/kvm/x86.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 63afdb6bb078..5e7418cfd0af 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2581,10 +2581,19 @@ static int kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
 
 static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
 {
-	u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
-				      vcpu->arch.virtual_tsc_mult,
-				      vcpu->arch.virtual_tsc_shift);
-	tsc += vcpu->arch.this_tsc_write;
+	s64 delta = kernel_ns - vcpu->arch.this_tsc_nsec;
+	u64 tsc = vcpu->arch.this_tsc_write;
+
+	/* pvclock_scale_delta cannot cope with negative deltas */
+	if (delta >= 0)
+		tsc += pvclock_scale_delta(delta,
+					   vcpu->arch.virtual_tsc_mult,
+					   vcpu->arch.virtual_tsc_shift);
+	else
+		tsc -= pvclock_scale_delta(-delta,
+					   vcpu->arch.virtual_tsc_mult,
+					   vcpu->arch.virtual_tsc_shift);
+
 	return tsc;
 }
 
@@ -2595,7 +2604,7 @@ static inline bool gtod_is_based_on_tsc(int mode)
 }
 #endif
 
-static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
+static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
 	struct kvm_arch *ka = &vcpu->kvm->arch;
@@ -2612,12 +2621,9 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
 
 	/*
 	 * Request a masterclock update if the masterclock needs to be toggled
-	 * on/off, or when starting a new generation and the masterclock is
-	 * enabled (compute_guest_tsc() requires the masterclock snapshot to be
-	 * taken _after_ the new generation is created).
+	 * on/off.
 	 */
-	if ((ka->use_master_clock && new_generation) ||
-	    (ka->use_master_clock != use_master_clock))
+	if (ka->use_master_clock != use_master_clock)
 		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 
 	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
@@ -2803,7 +2809,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
 	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
 	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
 
-	kvm_track_tsc_matching(vcpu, !matched);
+	kvm_track_tsc_matching(vcpu);
 }
 
 static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
-- 
2.39.3


