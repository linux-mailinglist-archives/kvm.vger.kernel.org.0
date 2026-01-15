Return-Path: <kvm+bounces-68249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DCF7D2871F
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:37:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B61C9300F264
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 649A2322B74;
	Thu, 15 Jan 2026 20:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QdTbFkC2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD38326D62;
	Thu, 15 Jan 2026 20:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509450; cv=none; b=t41RvAZTETtcdHw3ZqM+m15huVmqFo/eN+ORssPcqjxI339+qiihG9fXjuNh0D+LeEOLbkjQo+WEiAi0+GQ7aXnQdXXAR6lQB7/UJ9FqQR3St2XQ/fVUZsGB+h/QcwMEblxBOqcRpeizLQtEeKTOm8XThXdChQMkKMR98pqYNq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509450; c=relaxed/simple;
	bh=iTX6mtorYnC4MuGkfW7W9dN/7j3s6u/bl0SHLJ7SCYA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tM378tkO4cljmdFBip8yyMxRRxgRu12Piv84s1I+DSyTfDaGkPqPkG55PgnyqMCB9ZVDaXGIY/Tidgz2VNDkkaKVz++xYzknkcqc16s5DKyYTjd7OpGcw099uycoC+mje32y34mw4IPbN2WHgZbmrFNXPxhzPwUCY6hoDMVrUOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QdTbFkC2; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FDqLg01098168;
	Thu, 15 Jan 2026 20:36:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=whWqB6tPf8ilZ8Z2yieEc8zQoCzxv
	Wrmi9lHdomQDrs=; b=QdTbFkC2yb9nV3E6bcOOy052fVlCrynOpfbNu36HqcZBZ
	dfdGDlE36dmxJVobX3gYFeLXGzB1vjJ19PzvE39EycXDhbrWMWrtXA84BTHUZLUV
	OUOGijA1D5yljy7GP5fu5NTPkRPhRxGV5J4d9fX4zJHSWj8tLpt+fuWz897ilIOU
	3LkdNXeIcQQO4DoCkkcnMilATab5gX9kSjcjojHcUR1o/UaKZYnabYMIlrDITUP9
	HvIkyVJMBF3ZUnQbenevrd6vJbQ43AngxoZLpkXbIYBRBRksv4SeobNxxPA0J/pU
	TuE53dLZtG7OqByEc5rNnpN+xL4mcVdpuhW2wd1OQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb8nbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:36:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FJrWo9033952;
	Thu, 15 Jan 2026 20:35:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bsw1u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:35:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 60FKXKQN010408;
	Thu, 15 Jan 2026 20:35:58 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4bkd7bsw14-1;
	Thu, 15 Jan 2026 20:35:58 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dwmw2@infradead.org,
        dwmw@amazon.co.uk, paul@xen.org, tglx@kernel.org, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org, joe.jin@oracle.com,
        dongli.zhang@oracle.com
Subject: [PATCH 0/3] KVM: x86: Mitigate kvm-clock drift caused by masterclock update
Date: Thu, 15 Jan 2026 12:22:28 -0800
Message-ID: <20260115202256.119820-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
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
 mlxlogscore=788 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150161
X-Proofpoint-GUID: GEHHsX76239Zo4D4bQNFcg5XfqGS8U8u
X-Proofpoint-ORIG-GUID: GEHHsX76239Zo4D4bQNFcg5XfqGS8U8u
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE2MSBTYWx0ZWRfX0J8nFrtRqJ6b
 Y2VZbMzjZAHwiYOto4zclrBQLIKmOW25XXvGHLXyByN2mqEE/f8cAs70NqYEFrGvvN9OmqKDA1h
 D39At5P3IGkfK05uiHPXKD6zaH/qGfq4a4s5kwsJupso1mbWzMiyn4yt1OlbXlNnSmEykb+AU0D
 e+aIFxAF+1uJjnP3vUnrHkFCjItEwh6Gd4rgzWkg3ywYAYi8nOZ1ecX0abfOA4oqj5xNqmjYQlQ
 nLrRHdb/KmqRuz1VQN8IcqiyhHQxUP2fsTY9m4OLRPSLZsTo+r17Uv+u8lBJB73GDcL0ziwYnpO
 f8CodDlFE85eyrrsZh0ReH79BjOT/biAB32I4TQiHjgX+7jLVT0TcBnFmc750//8cQFaeSAZBuT
 KU29KwIP5DAe17pzrDUoMFQgl6BCB1eiZy+AFS8Z2gc7m9L8bGpNyKnz23DDQWYqKxV1d/lWEr0
 QY4LNzOAQ713KDCHKlw==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=69694fb0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
 a=w82ApDYLxB2Y06Xz2jsA:9 a=1CNFftbPRP8L7MoqJWF3:22

As noted in commit c52ffadc65e2 ("KVM: x86: Don't unnecessarily
force masterclock update on vCPU hotplug"), each unnecessary
KVM_REQ_MASTERCLOCK_UPDATE can cause the kvm-clock time to jump.

Although that commit addressed the kvm-clock drift issue during vCPU
hotplugl there are still unnecessary KVM_REQ_MASTERCLOCK_UPDATE requests
during live migration on the target host.

The patchset below was authored by David Woodhouse. Two of the patches aim
to avoid unnecessary KVM_REQ_MASTERCLOCK_UPDATE requests.

[RFC PATCH v3 00/21] Cleaning up the KVM clock mess
https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org/

[RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
[RFC PATCH v3 15/21] KVM: x86: Allow KVM master clock mode when TSCs are offset from each other

The current patchset has three patches.

PATCH 1 is a partial copy of "[RFC PATCH v3 10/21] KVM: x86: Fix software
TSC upscaling in kvm_update_guest_time()", as Sean suggested, "Please do
this in a separate patch. There's no need to squeeze it in here, and this
change is complex/subtle enough as it is.", and David's authorship is
preserved.

PATCH 2 clears unnecessary KVM_REQ_MASTERCLOCK_UPDATE at the end of
KVM_SET_CLOCK, if masterclock is already active.

PATCH 3 avoids unnecessary updates of ka->master_kernel_ns and
ka->master_cycle_now in pvclock_update_vm_gtod_copy(), if it is already
active and will remain active.


David Woodhouse (1):
  KVM: x86: Fix compute_guest_tsc() to cope with negative delta

Dongli Zhang (2):
  KVM: x86: conditionally clear KVM_REQ_MASTERCLOCK_UPDATE at the end of KVM_SET_CLOCK
  KVM: x86: conditionally update masterclock data in pvclock_update_vm_gtod_copy()

 arch/x86/kvm/x86.c | 73 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 21 deletions(-)

base-commit: 944aacb68baf7624ab8d277d0ebf07f025ca137c

Thank you very much!

Dongli Zhang


