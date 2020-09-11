Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB152657ED
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 06:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725766AbgIKEQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 00:16:41 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:64108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725283AbgIKEQj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 00:16:39 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08B40kG2091940;
        Fri, 11 Sep 2020 00:16:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=LHOkpPN83ZtmAlscrJcPGRdOy5V9rMnM7fXtdJV7PO0=;
 b=OHKrWCfdhWSqTX97Id1N22I4UWO35mrfuXSb9ECeuzJXrrNZKWNWCCCjz4KxT6RDZk0z
 BgmzCrwHx92EQJGk1fDHbLnkh9THpGyCVLWzsoRixOFSkrUesTdNb0+OPi60V6XUJghj
 uk4GWBD1N4XfeDTPG7l/Olhuj1dMDo5H+FRTMwYGV+i+7IN4p6Tjh+XkoM/Sjg5CCpLp
 qAraYZJoV46GiK22alsozGA5GmKkLt5Nxw/zS0k+6U0Qc3Q+arDBefAp5KNK2L2UExw2
 W1FRKZ+bwrF1qyW1lwRQLiPRPoHmZSuANvRi0JVk378fTYoCEgvlzSKKLJrlHLPxFFIN aA== 
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33g1rp8fv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 00:16:22 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08B4BYji016703;
        Fri, 11 Sep 2020 04:16:21 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 33c2a9n55p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 04:16:21 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08B4GK4r15729130
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 04:16:21 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E09B6C6061;
        Fri, 11 Sep 2020 04:16:20 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3FBFFC6057;
        Fri, 11 Sep 2020 04:16:19 +0000 (GMT)
Received: from farosas.linux.ibm.com.com (unknown [9.80.219.36])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 04:16:18 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     kvm-ppc@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        paulus@ozlabs.org, mpe@ellerman.id.au, david@gibson.dropbear.id.au
Subject: [PATCH] KVM: PPC: Book3S HV: Do not allocate HPT for a nested guest
Date:   Fri, 11 Sep 2020 01:16:07 -0300
Message-Id: <20200911041607.198092-1-farosas@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_01:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 clxscore=1011 adultscore=0 suspectscore=1 impostorscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110026
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The current nested KVM code does not support HPT guests. This is
informed/enforced in some ways:

- Hosts < P9 will not be able to enable the nested HV feature;

- The nested hypervisor MMU capabilities will not contain
  KVM_CAP_PPC_MMU_HASH_V3;

- QEMU reflects the MMU capabilities in the
  'ibm,arch-vec-5-platform-support' device-tree property;

- The nested guest, at 'prom_parse_mmu_model' ignores the
  'disable_radix' kernel command line option if HPT is not supported;

- The KVM_PPC_CONFIGURE_V3_MMU ioctl will fail if trying to use HPT.

There is, however, still a way to start a HPT guest by using
max-compat-cpu=power8 at the QEMU machine options. This leads to the
guest being set to use hash after QEMU calls the KVM_PPC_ALLOCATE_HTAB
ioctl.

With the guest set to hash, the nested hypervisor goes through the
entry path that has no knowledge of nesting (kvmppc_run_vcpu) and
crashes when it tries to execute an hypervisor-privileged (mtspr
HDEC) instruction at __kvmppc_vcore_entry:

root@L1:~ $ qemu-system-ppc64 -machine pseries,max-cpu-compat=power8 ...

<snip>
[  538.543303] CPU: 83 PID: 25185 Comm: CPU 0/KVM Not tainted 5.9.0-rc4 #1
[  538.543355] NIP:  c00800000753f388 LR: c00800000753f368 CTR: c0000000001e5ec0
[  538.543417] REGS: c0000013e91e33b0 TRAP: 0700   Not tainted  (5.9.0-rc4)
[  538.543470] MSR:  8000000002843033 <SF,VEC,VSX,FP,ME,IR,DR,RI,LE>  CR: 22422882  XER: 20040000
[  538.543546] CFAR: c00800000753f4b0 IRQMASK: 3
               GPR00: c0080000075397a0 c0000013e91e3640 c00800000755e600 0000000080000000
               GPR04: 0000000000000000 c0000013eab19800 c000001394de0000 00000043a054db72
               GPR08: 00000000003b1652 0000000000000000 0000000000000000 c0080000075502e0
               GPR12: c0000000001e5ec0 c0000007ffa74200 c0000013eab19800 0000000000000008
               GPR16: 0000000000000000 c00000139676c6c0 c000000001d23948 c0000013e91e38b8
               GPR20: 0000000000000053 0000000000000000 0000000000000001 0000000000000000
               GPR24: 0000000000000001 0000000000000001 0000000000000000 0000000000000001
               GPR28: 0000000000000001 0000000000000053 c0000013eab19800 0000000000000001
[  538.544067] NIP [c00800000753f388] __kvmppc_vcore_entry+0x90/0x104 [kvm_hv]
[  538.544121] LR [c00800000753f368] __kvmppc_vcore_entry+0x70/0x104 [kvm_hv]
[  538.544173] Call Trace:
[  538.544196] [c0000013e91e3640] [c0000013e91e3680] 0xc0000013e91e3680 (unreliable)
[  538.544260] [c0000013e91e3820] [c0080000075397a0] kvmppc_run_core+0xbc8/0x19d0 [kvm_hv]
[  538.544325] [c0000013e91e39e0] [c00800000753d99c] kvmppc_vcpu_run_hv+0x404/0xc00 [kvm_hv]
[  538.544394] [c0000013e91e3ad0] [c0080000072da4fc] kvmppc_vcpu_run+0x34/0x48 [kvm]
[  538.544472] [c0000013e91e3af0] [c0080000072d61b8] kvm_arch_vcpu_ioctl_run+0x310/0x420 [kvm]
[  538.544539] [c0000013e91e3b80] [c0080000072c7450] kvm_vcpu_ioctl+0x298/0x778 [kvm]
[  538.544605] [c0000013e91e3ce0] [c0000000004b8c2c] sys_ioctl+0x1dc/0xc90
[  538.544662] [c0000013e91e3dc0] [c00000000002f9a4] system_call_exception+0xe4/0x1c0
[  538.544726] [c0000013e91e3e20] [c00000000000d140] system_call_common+0xf0/0x27c
[  538.544787] Instruction dump:
[  538.544821] f86d1098 60000000 60000000 48000099 e8ad0fe8 e8c500a0 e9264140 75290002
[  538.544886] 7d1602a6 7cec42a6 40820008 7d0807b4 <7d164ba6> 7d083a14 f90d10a0 480104fd
[  538.544953] ---[ end trace 74423e2b948c2e0c ]---

This patch makes the KVM_PPC_ALLOCATE_HTAB ioctl fail when running in
the nested hypervisor, causing QEMU to abort.

Reported-by: Satheesh Rajendran <sathnaga@linux.vnet.ibm.com>
Signed-off-by: Fabiano Rosas <farosas@linux.ibm.com>
---
 arch/powerpc/kvm/book3s_hv.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 4ba06a2a306c..764b6239ef72 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -5250,6 +5250,12 @@ static long kvm_arch_vm_ioctl_hv(struct file *filp,
 	case KVM_PPC_ALLOCATE_HTAB: {
 		u32 htab_order;
 
+		/* If we're a nested hypervisor, we currently only support radix */
+		if (kvmhv_on_pseries()) {
+			r = -EOPNOTSUPP;
+			break;
+		}
+
 		r = -EFAULT;
 		if (get_user(htab_order, (u32 __user *)argp))
 			break;
-- 
2.25.4

