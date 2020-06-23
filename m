Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26156204DE3
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731952AbgFWJYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:24:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40424 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731887AbgFWJY3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:24:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05N914cK042258;
        Tue, 23 Jun 2020 05:24:28 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tyry2378-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 05:24:28 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 05N916rE042447;
        Tue, 23 Jun 2020 05:24:28 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 31tyry236q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 05:24:27 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 05N9KN0W028871;
        Tue, 23 Jun 2020 09:24:26 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma01fra.de.ibm.com with ESMTP id 31sa3823fy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 09:24:25 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05N9ONwY4063568
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 09:24:23 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B84F52051;
        Tue, 23 Jun 2020 09:24:23 +0000 (GMT)
Received: from localhost.localdomain.com (unknown [9.145.62.182])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 9EF9352052;
        Tue, 23 Jun 2020 09:24:22 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com
Subject: [GIT PULL 1/1] KVM: s390: reduce number of IO pins to 1
Date:   Tue, 23 Jun 2020 11:23:41 +0200
Message-Id: <20200623092341.10348-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200623092341.10348-1-frankja@linux.ibm.com>
References: <20200623092341.10348-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_04:2020-06-22,2020-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxscore=0 impostorscore=0
 cotscore=-2147483648 suspectscore=0 mlxlogscore=999 clxscore=1015
 priorityscore=1501 bulkscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006230068
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The current number of KVM_IRQCHIP_NUM_PINS results in an order 3
allocation (32kb) for each guest start/restart. This can result in OOM
killer activity even with free swap when the memory is fragmented
enough:

kernel: qemu-system-s39 invoked oom-killer: gfp_mask=0x440dc0(GFP_KERNEL_ACCOUNT|__GFP_COMP|__GFP_ZERO), order=3, oom_score_adj=0
kernel: CPU: 1 PID: 357274 Comm: qemu-system-s39 Kdump: loaded Not tainted 5.4.0-29-generic #33-Ubuntu
kernel: Hardware name: IBM 8562 T02 Z06 (LPAR)
kernel: Call Trace:
kernel: ([<00000001f848fe2a>] show_stack+0x7a/0xc0)
kernel:  [<00000001f8d3437a>] dump_stack+0x8a/0xc0
kernel:  [<00000001f8687032>] dump_header+0x62/0x258
kernel:  [<00000001f8686122>] oom_kill_process+0x172/0x180
kernel:  [<00000001f8686abe>] out_of_memory+0xee/0x580
kernel:  [<00000001f86e66b8>] __alloc_pages_slowpath+0xd18/0xe90
kernel:  [<00000001f86e6ad4>] __alloc_pages_nodemask+0x2a4/0x320
kernel:  [<00000001f86b1ab4>] kmalloc_order+0x34/0xb0
kernel:  [<00000001f86b1b62>] kmalloc_order_trace+0x32/0xe0
kernel:  [<00000001f84bb806>] kvm_set_irq_routing+0xa6/0x2e0
kernel:  [<00000001f84c99a4>] kvm_arch_vm_ioctl+0x544/0x9e0
kernel:  [<00000001f84b8936>] kvm_vm_ioctl+0x396/0x760
kernel:  [<00000001f875df66>] do_vfs_ioctl+0x376/0x690
kernel:  [<00000001f875e304>] ksys_ioctl+0x84/0xb0
kernel:  [<00000001f875e39a>] __s390x_sys_ioctl+0x2a/0x40
kernel:  [<00000001f8d55424>] system_call+0xd8/0x2c8

As far as I can tell s390x does not use the iopins as we bail our for
anything other than KVM_IRQ_ROUTING_S390_ADAPTER and the chip/pin is
only used for KVM_IRQ_ROUTING_IRQCHIP. So let us use a small number to
reduce the memory footprint.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Link: https://lore.kernel.org/r/20200617083620.5409-1-borntraeger@de.ibm.com
---
 arch/s390/include/asm/kvm_host.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
index cee3cb6455a2..6ea0820e7c7f 100644
--- a/arch/s390/include/asm/kvm_host.h
+++ b/arch/s390/include/asm/kvm_host.h
@@ -31,12 +31,12 @@
 #define KVM_USER_MEM_SLOTS 32
 
 /*
- * These seem to be used for allocating ->chip in the routing table,
- * which we don't use. 4096 is an out-of-thin-air value. If we need
- * to look at ->chip later on, we'll need to revisit this.
+ * These seem to be used for allocating ->chip in the routing table, which we
+ * don't use. 1 is as small as we can get to reduce the needed memory. If we
+ * need to look at ->chip later on, we'll need to revisit this.
  */
 #define KVM_NR_IRQCHIPS 1
-#define KVM_IRQCHIP_NUM_PINS 4096
+#define KVM_IRQCHIP_NUM_PINS 1
 #define KVM_HALT_POLL_NS_DEFAULT 50000
 
 /* s390-specific vcpu->requests bit members */
-- 
2.25.4

