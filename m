Return-Path: <kvm+bounces-29107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 09DBE9A2B88
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 19:57:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D3D91F20F3E
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 17:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A74581DFE2A;
	Thu, 17 Oct 2024 17:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D9asiYnS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47231DFD99;
	Thu, 17 Oct 2024 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729187840; cv=none; b=Y/l++TwA2fVtRpP7Vn9HyW0GLIGBzXZoS0ulv/g1Ge78vf+bBCGUl3lp3yKIqa9YDRrvrB9mE5tFmGqAYX6XGIYj/ykwryRXu8vgB6q/20y2O6T6CNZNkHGh1F0f5VW7fRx6m11QVD8bk1WCjCjfPPJIeh6e96jV2qHi0ZAiZro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729187840; c=relaxed/simple;
	bh=xmgbeXT8aWrGiZpymwJtYp1/4iIUijg7NtKvkhTd1ns=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OMxWBiJMnFzt5h68uNtulDJY3Sw4hasN7rrZ/eYdZJ/DH2qX/U+r9Ui5w0PCp5diikpUZFt7SbYkUQsfi5sIj2kFtG1hLIGa455Ct0fmkblIHZYHxj2WiXSOuo5xC3kCPycYnsGADPZJ1eSh7S3DXCRJmeZPEQdHAnALM9QAYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D9asiYnS; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49HFBbP6009186;
	Thu, 17 Oct 2024 17:56:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2023-11-20; bh=mEIYxFwssWTqYAewNViYRm2X7P5Y8
	SJRPt3cVKr76UA=; b=D9asiYnSGhtl26fgojsFhXqUEGsNM2IWWjBSNGPF4HbdN
	bz5wuOzCbiy/AY5Esw9Rx5uMzHB6SdVLznR6dHf9FSh0LrE0+/tsVcm5yE6FrwBp
	5mFh8JcYRjLkzFML8/haOS7pqLV0n+VDhcPbbMPcrwnNZTtxdo6MTvOyTekG9yst
	z1CmbE6HKRWhgJ3J26GQWTpgn9IqBfPfHig4pCedzjtmDngBCEUp41N48Fa8zN/q
	HG6COyncJtQiGCu+2WfE+DPexOt0p6KEqF5p3WWU/v3tRgQSZ5JrxniTBfMnZEWW
	FbG8cx7Tnp9UibDJJxbe6zLSRK5NLX7o2Hw4mpfRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 427gq7q3v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 17:56:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49HHeo9g014276;
	Thu, 17 Oct 2024 17:56:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 427fjajnwb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 17 Oct 2024 17:56:58 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49HHsmYP037780;
	Thu, 17 Oct 2024 17:56:57 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 427fjajnup-1;
	Thu, 17 Oct 2024 17:56:57 +0000
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To: 
Cc: saeed.mirzamohammadi@oracle.com, Breno Leitao <leitao@debian.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5.15, 5.10, 5.4, 4.19 1/1] KVM: Fix a data race on last_boosted_vcpu in kvm_vcpu_on_spin()
Date: Thu, 17 Oct 2024 10:56:13 -0700
Message-ID: <20241017175623.2045625-1-saeed.mirzamohammadi@oracle.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-17_20,2024-10-17_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410170122
X-Proofpoint-ORIG-GUID: gOw21oySdl6c-qz8nIRKQJRVCVj6G30y
X-Proofpoint-GUID: gOw21oySdl6c-qz8nIRKQJRVCVj6G30y

From: Breno Leitao <leitao@debian.org>

commit 49f683b41f28918df3e51ddc0d928cb2e934ccdb upstream.

Use {READ,WRITE}_ONCE() to access kvm->last_boosted_vcpu to ensure the
loads and stores are atomic.  In the extremely unlikely scenario the
compiler tears the stores, it's theoretically possible for KVM to attempt
to get a vCPU using an out-of-bounds index, e.g. if the write is split
into multiple 8-bit stores, and is paired with a 32-bit load on a VM with
257 vCPUs:

  CPU0                              CPU1
  last_boosted_vcpu = 0xff;

                                    (last_boosted_vcpu = 0x100)
                                    last_boosted_vcpu[15:8] = 0x01;
  i = (last_boosted_vcpu = 0x1ff)
                                    last_boosted_vcpu[7:0] = 0x00;

  vcpu = kvm->vcpu_array[0x1ff];

As detected by KCSAN:

  BUG: KCSAN: data-race in kvm_vcpu_on_spin [kvm] / kvm_vcpu_on_spin [kvm]

  write to 0xffffc90025a92344 of 4 bytes by task 4340 on cpu 16:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4112) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:?
		 arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

  read to 0xffffc90025a92344 of 4 bytes by task 4342 on cpu 4:
  kvm_vcpu_on_spin (arch/x86/kvm/../../../virt/kvm/kvm_main.c:4069) kvm
  handle_pause (arch/x86/kvm/vmx/vmx.c:5929) kvm_intel
  vmx_handle_exit (arch/x86/kvm/vmx/vmx.c:?
			arch/x86/kvm/vmx/vmx.c:6606) kvm_intel
  vcpu_run (arch/x86/kvm/x86.c:11107 arch/x86/kvm/x86.c:11211) kvm
  kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:?) kvm
  kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:?) kvm
  __se_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:904 fs/ioctl.c:890)
  __x64_sys_ioctl (fs/ioctl.c:890)
  x64_sys_call (arch/x86/entry/syscall_64.c:33)
  do_syscall_64 (arch/x86/entry/common.c:?)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)

  value changed: 0x00000012 -> 0x00000000

Fixes: 217ece6129f2 ("KVM: use yield_to instead of sleep in kvm_vcpu_on_spin")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240510092353.2261824-1-leitao@debian.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
(cherry picked from commit 92c77807d938145c7c3350c944ef9f39d7f6017c)
Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
---
 virt/kvm/kvm_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 801ab0635bc32..8734d5bbd951e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3525,12 +3525,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 {
 	struct kvm *kvm = me->kvm;
 	struct kvm_vcpu *vcpu;
-	int last_boosted_vcpu = me->kvm->last_boosted_vcpu;
+	int last_boosted_vcpu;
 	int yielded = 0;
 	int try = 3;
 	int pass;
 	int i;
 
+	last_boosted_vcpu = READ_ONCE(kvm->last_boosted_vcpu);
 	kvm_vcpu_set_in_spin_loop(me, true);
 	/*
 	 * We boost the priority of a VCPU that is runnable but not
@@ -3561,7 +3562,7 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
 
 			yielded = kvm_vcpu_yield_to(vcpu);
 			if (yielded > 0) {
-				kvm->last_boosted_vcpu = i;
+				WRITE_ONCE(kvm->last_boosted_vcpu, i);
 				break;
 			} else if (yielded < 0) {
 				try--;
-- 
2.46.0


