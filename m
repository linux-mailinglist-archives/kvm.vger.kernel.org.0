Return-Path: <kvm+bounces-57675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12AAAB58E58
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EA071B23435
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 06:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF8D2C11EC;
	Tue, 16 Sep 2025 06:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BqugnTqz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF213B293
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 06:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758003500; cv=none; b=eJOXvXlR/O3dwt697ycoskVZvyy1eUv3HFvKRfAK1An4MXtNDEEBtCTwb/FvNCjbE/z8XhsiR3gZ7Pk+LvEpghlluO3hwkxjEbAbXVZhF/1vQdycMkN06OXpJvqcfihqxPw+eldZCGEW+DqZvf8hXkFgecFSpKSSYcQHUGXSfMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758003500; c=relaxed/simple;
	bh=uFWGhlA3mDZh9/MHGNabuAyDeWGAel/nv/BBh5Mcq2k=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jvhzxnoOwXvJjN+xgi+KQVxyi+9F+kfBfWOkSL8B1dtDyCBXi+blYklwIaMIa+30CMa64nNDGpXJHKmHwP1hARW6wTaVOYd/roYqDSYU5vfiYgq+tMXrR70CkMh1z6oBDdvs6UlMO0+S6RxvB2rqj+sCXW6x8w+YtENDEMEUKdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BqugnTqz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58G5VsGD031553;
	Tue, 16 Sep 2025 06:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=o8FvyA884sDbTFyfaccM/3oCnolBTd6Hw/6ZhdXs+
	2k=; b=BqugnTqzjwH2CFMM7quItzy20XfOLSV9RMm/ik2iVgW0CZOQRQFaL36Vz
	gZOmsA5uoxi/GUOARTjN/mu2bgd1ljPY72U532R5/4sl3O1Xj4hy+GRjrVHFRhwV
	L/kui5yZGas5n8/yU8sMLkBXF1GqNo+1Lgycibj3S7MfZppxcNq17/sQQo7cknPP
	Yj93eO+pdD3TRDhyzo9U2eplnos1G6JQ0HmjmANZvE/ufV4xLj7cP07h5MGtYlei
	VNifZTdyeARQclTcPfH+3wXQRwf26foDZiP10nqrBkj9aAjjOyKGhFd2tk97dDhC
	Dl2m/iY/jgmcoXFCPQaH6vG8PtM8A==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tenug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 06:18:07 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58G6FDQK007283;
	Tue, 16 Sep 2025 06:18:07 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 494x1tenuf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 06:18:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58G3BkFc027358;
	Tue, 16 Sep 2025 06:18:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495men2ck1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 06:18:06 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58G6I2kQ48365832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 06:18:02 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D6CE20043;
	Tue, 16 Sep 2025 06:18:02 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8CA02004B;
	Tue, 16 Sep 2025 06:17:59 +0000 (GMT)
Received: from mac.in.ibm.com (unknown [9.109.215.35])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Sep 2025 06:17:59 +0000 (GMT)
From: Gautam Menghani <gautam@linux.ibm.com>
To: harshpb@linux.ibm.com, vaibhav@linux.ibm.com, nicholas@linux.ibm.com,
        rathc@linux.ibm.com, npiggin@gmail.com, pbonzini@redhat.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [PATCH v4] hw/ppc/spapr_hcall: Return host mitigation characteristics in KVM mode
Date: Tue, 16 Sep 2025 11:47:53 +0530
Message-Id: <20250916061753.20517-1-gautam@linux.ibm.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OMsn3TaB c=1 sm=1 tr=0 ts=68c9011f cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=voM4FWlXAAAA:8 a=VnNF1IyMAAAA:8 a=TfJWrzbei0Lz0DVUvboA:9
 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-ORIG-GUID: sZ0cQy4fzVJ7D2SdVJxLYBghDOIlUj--
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAwMSBTYWx0ZWRfX82wY3QhDOETz
 w7RdLwgenkAL/2dDIqYf2nfEi7xQHOy/SfiGSgFy6EzvVwxX7LEq09dZ+1NBzGJ51iCBatgzLR3
 uSkCAOkKzp0wzxZZtfh8JJp/7Forl3XPRSjo4gr/SxPEWLbccV33MFmK6ZdQf9ALfEfVy3ai55y
 hmYZp8pRkUSr3IJq6cvi0iPFDAxe7HB3R9b2Wf4tYdMUnS7FPeozc11/AcNz4MRrpPbHVfhzLFt
 NRFXjhgOo3Khd6R4d51B7s0ZPeC/AGAn9hipPOtNbtxJE1Tq2Gpa2bQhq8yDClAuTf30r0v+/jc
 BZ1GTPaujDM1c6Ru8+61R5JAwPMdFR30Ayo+MTLU/rmgm1vfwfvMtvcq7d4dVE3cBuEMsbwaTE7
 N+BHffhb
X-Proofpoint-GUID: VkLv9Z2maXFr-SK59hw8ERgRF1MbbAbW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_01,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 spamscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509130001

Currently, on a P10 KVM guest, the mitigations seen in the output of
"lscpu" command are different from the host. The reason for this
behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
hcall, QEMU does not consider the data it received from the host via the
KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
spapr->eff.caps[], which in turn just contain the default values set in
spapr_machine_class_init().

Fix this behaviour by making sure that h_get_cpu_characteristics()
returns the data received from the KVM ioctl for a KVM guest.

Mitigation status seen in lscpu output:
1. P10 LPAR (host)
$ lscpu | grep -i mitigation
Vulnerability Spectre v1:             Mitigation; __user pointer sanitization, ori31 speculation barrier enabled
Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

2. KVM guest on P10 LPAR with upstream QEMU
$ lscpu | grep -i mitig
Vulnerability L1tf:                   Mitigation; RFI Flush, L1D private per thread
Vulnerability Meltdown:               Mitigation; RFI Flush, L1D private per thread
Vulnerability Spec store bypass:      Mitigation; Kernel entry/exit barrier (eieio)
Vulnerability Spectre v1:             Mitigation; __user pointer sanitization
Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

3. KVM guest on P10 LPAR (this patch applied)
$ lscpu | grep -i mitigation
Vulnerability Spectre v1:             Mitigation; __user pointer sanitization, ori31 speculation barrier enabled
Vulnerability Spectre v2:             Mitigation; Software count cache flush (hardware accelerated), Software link stack flush

Perf impact:
With null syscall benchmark[1], ~45% improvement is observed.

1. Vanilla QEMU
$ ./null_syscall
132.19 ns     456.54 cycles

2. With this patch
$ ./null_syscall
91.18 ns     314.57 cycles

[1]: https://ozlabs.org/~anton/junkcode/null_syscall.c

Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
---
v1 -> v2:
Handle the case where KVM_PPC_GET_CPU_CHAR ioctl fails

v2 -> v3:
Add the lscpu output in the patch description

v3 -> v4:
Fix QEMU CI build failure

 hw/ppc/spapr_hcall.c | 10 ++++++++++
 target/ppc/kvm.c     | 27 +++++++++++++++++++--------
 target/ppc/kvm_ppc.h |  1 +
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/hw/ppc/spapr_hcall.c b/hw/ppc/spapr_hcall.c
index 1e936f35e4..7d695ffc93 100644
--- a/hw/ppc/spapr_hcall.c
+++ b/hw/ppc/spapr_hcall.c
@@ -1415,6 +1415,16 @@ static target_ulong h_get_cpu_characteristics(PowerPCCPU *cpu,
     uint8_t count_cache_flush_assist = spapr_get_cap(spapr,
                                                      SPAPR_CAP_CCF_ASSIST);
 
+    #ifdef CONFIG_KVM
+    struct kvm_ppc_cpu_char c = kvmppc_get_cpu_chars();
+
+    if (kvm_enabled() && c.character) {
+        args[0] = c.character;
+        args[1] = c.behaviour;
+        return H_SUCCESS;
+    }
+    #endif
+
     switch (safe_cache) {
     case SPAPR_CAP_WORKAROUND:
         characteristics |= H_CPU_CHAR_L1D_FLUSH_ORI30;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 015658049e..28dcf62f58 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -93,6 +93,7 @@ static int cap_fwnmi;
 static int cap_rpt_invalidate;
 static int cap_ail_mode_3;
 static int cap_dawr1;
+static struct kvm_ppc_cpu_char cpu_chars = {0};
 
 #ifdef CONFIG_PSERIES
 static int cap_papr;
@@ -2515,7 +2516,6 @@ bool kvmppc_has_cap_xive(void)
 
 static void kvmppc_get_cpu_characteristics(KVMState *s)
 {
-    struct kvm_ppc_cpu_char c;
     int ret;
 
     /* Assume broken */
@@ -2525,18 +2525,29 @@ static void kvmppc_get_cpu_characteristics(KVMState *s)
 
     ret = kvm_vm_check_extension(s, KVM_CAP_PPC_GET_CPU_CHAR);
     if (!ret) {
-        return;
+        goto err;
     }
-    ret = kvm_vm_ioctl(s, KVM_PPC_GET_CPU_CHAR, &c);
+    ret = kvm_vm_ioctl(s, KVM_PPC_GET_CPU_CHAR, &cpu_chars);
     if (ret < 0) {
-        return;
+        goto err;
     }
 
-    cap_ppc_safe_cache = parse_cap_ppc_safe_cache(c);
-    cap_ppc_safe_bounds_check = parse_cap_ppc_safe_bounds_check(c);
-    cap_ppc_safe_indirect_branch = parse_cap_ppc_safe_indirect_branch(c);
+    cap_ppc_safe_cache = parse_cap_ppc_safe_cache(cpu_chars);
+    cap_ppc_safe_bounds_check = parse_cap_ppc_safe_bounds_check(cpu_chars);
+    cap_ppc_safe_indirect_branch =
+        parse_cap_ppc_safe_indirect_branch(cpu_chars);
     cap_ppc_count_cache_flush_assist =
-        parse_cap_ppc_count_cache_flush_assist(c);
+        parse_cap_ppc_count_cache_flush_assist(cpu_chars);
+
+    return;
+
+err:
+    memset(&cpu_chars, 0, sizeof(struct kvm_ppc_cpu_char));
+}
+
+struct kvm_ppc_cpu_char kvmppc_get_cpu_chars(void)
+{
+    return cpu_chars;
 }
 
 int kvmppc_get_cap_safe_cache(void)
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index a1d9ce9f9a..51c1c7d1a0 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -87,6 +87,7 @@ void kvmppc_check_papr_resize_hpt(Error **errp);
 int kvmppc_resize_hpt_prepare(PowerPCCPU *cpu, target_ulong flags, int shift);
 int kvmppc_resize_hpt_commit(PowerPCCPU *cpu, target_ulong flags, int shift);
 bool kvmppc_pvr_workaround_required(PowerPCCPU *cpu);
+struct kvm_ppc_cpu_char kvmppc_get_cpu_chars(void);
 
 bool kvmppc_hpt_needs_host_contiguous_pages(void);
 void kvm_check_mmu(PowerPCCPU *cpu, Error **errp);
-- 
2.39.5 (Apple Git-154)


