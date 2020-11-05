Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A272A7FE5
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 14:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgKENsR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 5 Nov 2020 08:48:17 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60550 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgKENsQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 08:48:16 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A5DljqF176172;
        Thu, 5 Nov 2020 08:47:53 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34m5ftekvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 08:47:52 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0A5DiBvH006410;
        Thu, 5 Nov 2020 13:47:26 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 34h0f6tt1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Nov 2020 13:47:26 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0A5DlNMp64487700
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Nov 2020 13:47:23 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDF76A4054;
        Thu,  5 Nov 2020 13:47:23 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7CFFBA405B;
        Thu,  5 Nov 2020 13:47:23 +0000 (GMT)
Received: from smtp.tlslab.ibm.com (unknown [9.101.4.1])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Thu,  5 Nov 2020 13:47:23 +0000 (GMT)
Received: from yukon.ibmuc.com (sig-9-145-56-119.uk.ibm.com [9.145.56.119])
        by smtp.tlslab.ibm.com (Postfix) with ESMTP id 3776422006B;
        Thu,  5 Nov 2020 14:47:22 +0100 (CET)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Paul Mackerras <paulus@samba.org>
Cc:     linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, Greg Kurz <groug@kaod.org>,
        Gustavo Romero <gromero@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH] KVM: PPC: Book3S HV: XIVE: Fix possible oops when accessing ESB page
Date:   Thu,  5 Nov 2020 14:47:13 +0100
Message-Id: <20201105134713.656160-1-clg@kaod.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_07:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 clxscore=1034 bulkscore=0
 priorityscore=1501 mlxlogscore=648 adultscore=0 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050088
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When accessing the ESB page of a source interrupt, the fault handler
will retrieve the page address from the XIVE interrupt 'xive_irq_data'
structure. If the associated KVM XIVE interrupt is not valid, that is
not allocated at the HW level for some reason, the fault handler will
dereference a NULL pointer leading to the oops below :

    WARNING: CPU: 40 PID: 59101 at arch/powerpc/kvm/book3s_xive_native.c:259 xive_native_esb_fault+0xe4/0x240 [kvm]
    CPU: 40 PID: 59101 Comm: qemu-system-ppc Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-240.el8.ppc64le #1
    NIP:  c00800000e949fac LR: c00000000044b164 CTR: c00800000e949ec8
    REGS: c000001f69617840 TRAP: 0700   Tainted: G        W        --------- -  -  (4.18.0-240.el8.ppc64le)
    MSR:  9000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE>  CR: 44044282  XER: 00000000
    CFAR: c00000000044b160 IRQMASK: 0
    GPR00: c00000000044b164 c000001f69617ac0 c00800000e96e000 c000001f69617c10
    GPR04: 05faa2b21e000080 0000000000000000 0000000000000005 ffffffffffffffff
    GPR08: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
    GPR12: c00800000e949ec8 c000001ffffd3400 0000000000000000 0000000000000000
    GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000000000000
    GPR20: 0000000000000000 0000000000000000 c000001f5c065160 c000000001c76f90
    GPR24: c000001f06f20000 c000001f5c065100 0000000000000008 c000001f0eb98c78
    GPR28: c000001dcab40000 c000001dcab403d8 c000001f69617c10 0000000000000011
    NIP [c00800000e949fac] xive_native_esb_fault+0xe4/0x240 [kvm]
    LR [c00000000044b164] __do_fault+0x64/0x220
    Call Trace:
    [c000001f69617ac0] [0000000137a5dc20] 0x137a5dc20 (unreliable)
    [c000001f69617b50] [c00000000044b164] __do_fault+0x64/0x220
    [c000001f69617b90] [c000000000453838] do_fault+0x218/0x930
    [c000001f69617bf0] [c000000000456f50] __handle_mm_fault+0x350/0xdf0
    [c000001f69617cd0] [c000000000457b1c] handle_mm_fault+0x12c/0x310
    [c000001f69617d10] [c00000000007ef44] __do_page_fault+0x264/0xbb0
    [c000001f69617df0] [c00000000007f8c8] do_page_fault+0x38/0xd0
    [c000001f69617e30] [c00000000000a714] handle_page_fault+0x18/0x38
    Instruction dump:
    40c2fff0 7c2004ac 2fa90000 409e0118 73e90001 41820080 e8bd0008 7c2004ac
    7ca90074 39400000 915c0000 7929d182 <0b090000> 2fa50000 419e0080 e89e0018
    ---[ end trace 66c6ff034c53f64f ]---
    xive-kvm: xive_native_esb_fault: accessing invalid ESB page for source 8 !

Fix that by checking the validity of the KVM XIVE interrupt structure.

Reported-by: Greg Kurz <groug@kaod.org>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
---
 arch/powerpc/kvm/book3s_xive_native.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_xive_native.c b/arch/powerpc/kvm/book3s_xive_native.c
index d0c2db0e07fa..a59a94f02733 100644
--- a/arch/powerpc/kvm/book3s_xive_native.c
+++ b/arch/powerpc/kvm/book3s_xive_native.c
@@ -251,6 +251,13 @@ static vm_fault_t xive_native_esb_fault(struct vm_fault *vmf)
 	}
 
 	state = &sb->irq_state[src];
+
+	/* Some sanity checking */
+	if (!state->valid) {
+		pr_devel("%s: source %lx invalid !\n", __func__, irq);
+		return VM_FAULT_SIGBUS;
+	}
+
 	kvmppc_xive_select_irq(state, &hw_num, &xd);
 
 	arch_spin_lock(&sb->lock);
-- 
2.26.2

