Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F614C102C
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbiBWKUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 05:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiBWKUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 05:20:37 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB58BF4A;
        Wed, 23 Feb 2022 02:20:09 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21N8R854029813;
        Wed, 23 Feb 2022 10:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PTJLQJgXVKvAxFvrnDjmsju9sTxp1yhqLvbsg3kDj7c=;
 b=peebXjPqnPgEyl5Xu/LbHxUiSAY2+FtwE1PbNUKTinwxG8si0kEHa2A5hbhM6iy423CO
 zZjIH488VoDEkAmpq4D92sKkhw6cNI2UkUZkqjFw40SdFmGKGsIF+ghx0NUncg771nDo
 EA9dLHsk0GqcdpIO4MiCwI9HCPrFvK8jWZYm07TRz85GZY7wAClBb0UXPXlws/yvVZDI
 6wxh6QicO9HqyQKgI7byePAx+jayxHjkHTlQGoYxDus/5UznZ4CHsDjdTuqiuprB+bs4
 NJ7DP09ZpQTBwWnFMRQEQ5FI4jniXipwz6TGfWCGzB0l4jcKBnoa5GT+X7UDK6UK1CZk Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edds7nwet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:08 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21NA6rK6005961;
        Wed, 23 Feb 2022 10:20:08 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3edds7nwe7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:08 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21NAD24q018756;
        Wed, 23 Feb 2022 10:20:06 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3ear697gkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Feb 2022 10:20:06 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21NAK3LS50397524
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 10:20:03 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3C4725205A;
        Wed, 23 Feb 2022 10:20:03 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 034F252059;
        Wed, 23 Feb 2022 10:20:02 +0000 (GMT)
From:   Michael Mueller <mimu@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        david@redhat.com, borntraeger@linux.ibm.com, pasic@linux.ibm.com,
        Michael Mueller <mimu@linux.ibm.com>
Subject: [PATCH v4 1/2] KVM: s390: pv: pull all vcpus out of SIE before converting to/from pv vcpu
Date:   Wed, 23 Feb 2022 11:19:59 +0100
Message-Id: <20220223102000.3733712-2-mimu@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220223102000.3733712-1-mimu@linux.ibm.com>
References: <20220223102000.3733712-1-mimu@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UdP7pnf-R1wzMkrr8iNUIrmZt1VXdYcq
X-Proofpoint-ORIG-GUID: bg5Hb2LhxXZ5Hum1t4lFS17KIev9Bh-W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-23_03,2022-02-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230052
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

That will allow to modify the control blocks without locking the vcpus.
A kvm-unit-test surfaced a possible DEADLOCK situation when guest cpus are
executing intercepted instructions at this time.

[  319.799638] ======================================================
[  319.799639] WARNING: possible circular locking dependency detected
[  319.799641] 5.17.0-rc5-08427-gfd14b6309198 #4661 Not tainted
[  319.799643] ------------------------------------------------------
[  319.799644] qemu-system-s39/14220 is trying to acquire lock:
[  319.799646] 00000000b30c0b50 (&kvm->lock){+.+.}-{3:3}, at: kvm_s390_set_tod_clock+0x36/0x250
[  319.799659]
               but task is already holding lock:
[  319.799660] 00000000b5beda60 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x9a/0x958
[  319.799665]
               which lock already depends on the new lock.

[  319.799667]
               the existing dependency chain (in reverse order) is:
[  319.799668]
               -> #1 (&vcpu->mutex){+.+.}-{3:3}:
[  319.799671]        __mutex_lock+0x8a/0x798
[  319.799677]        mutex_lock_nested+0x32/0x40
[  319.799679]        kvm_arch_vm_ioctl+0x1902/0x2c58
[  319.799682]        kvm_vm_ioctl+0x5b0/0xa80
[  319.799685]        __s390x_sys_ioctl+0xbe/0x100
[  319.799688]        __do_syscall+0x1da/0x208
[  319.799689]        system_call+0x82/0xb0
[  319.799692]
               -> #0 (&kvm->lock){+.+.}-{3:3}:
[  319.799694]        __lock_acquire+0x1916/0x2e70
[  319.799699]        lock_acquire+0x164/0x388
[  319.799702]        __mutex_lock+0x8a/0x798
[  319.799757]        mutex_lock_nested+0x32/0x40
[  319.799759]        kvm_s390_set_tod_clock+0x36/0x250
[  319.799761]        kvm_s390_handle_b2+0x6cc/0x26f0
[  319.799764]        kvm_handle_sie_intercept+0x1fe/0xe98
[  319.799765]        kvm_arch_vcpu_ioctl_run+0xec8/0x1880
[  319.799768]        kvm_vcpu_ioctl+0x29e/0x958
[  319.799769]        __s390x_sys_ioctl+0xbe/0x100
[  319.799771]        __do_syscall+0x1da/0x208
[  319.799773]        system_call+0x82/0xb0
[  319.799774]
               other info that might help us debug this:

[  319.799776]  Possible unsafe locking scenario:

[  319.799777]        CPU0                    CPU1
[  319.799778]        ----                    ----
[  319.799779]   lock(&vcpu->mutex);
[  319.799780]                                lock(&kvm->lock);
[  319.799782]                                lock(&vcpu->mutex);
[  319.799783]   lock(&kvm->lock);
[  319.799784]
                *** DEADLOCK ***

[  319.799785] 2 locks held by qemu-system-s39/14220:
[  319.799787]  #0: 00000000b5beda60 (&vcpu->mutex){+.+.}-{3:3}, at: kvm_vcpu_ioctl+0x9a/0x958
[  319.799791]  #1: 00000000b30c4588 (&kvm->srcu){....}-{0:0}, at: kvm_arch_vcpu_ioctl_run+0x6f2/0x1880
[  319.799796]
               stack backtrace:
[  319.799798] CPU: 5 PID: 14220 Comm: qemu-system-s39 Not tainted 5.17.0-rc5-08427-gfd14b6309198 #4661
[  319.799801] Hardware name: IBM 8561 T01 701 (LPAR)
[  319.799802] Call Trace:
[  319.799803]  [<000000020d7410de>] dump_stack_lvl+0x76/0x98
[  319.799808]  [<000000020cbbd268>] check_noncircular+0x140/0x160
[  319.799811]  [<000000020cbc0efe>] __lock_acquire+0x1916/0x2e70
[  319.799813]  [<000000020cbc2dbc>] lock_acquire+0x164/0x388
[  319.799816]  [<000000020d75013a>] __mutex_lock+0x8a/0x798
[  319.799818]  [<000000020d75087a>] mutex_lock_nested+0x32/0x40
[  319.799820]  [<000000020cb029a6>] kvm_s390_set_tod_clock+0x36/0x250
[  319.799823]  [<000000020cb14d14>] kvm_s390_handle_b2+0x6cc/0x26f0
[  319.799825]  [<000000020cb09b6e>] kvm_handle_sie_intercept+0x1fe/0xe98
[  319.799827]  [<000000020cb06c28>] kvm_arch_vcpu_ioctl_run+0xec8/0x1880
[  319.799829]  [<000000020caeddc6>] kvm_vcpu_ioctl+0x29e/0x958
[  319.799831]  [<000000020ce4e82e>] __s390x_sys_ioctl+0xbe/0x100
[  319.799833]  [<000000020d744a72>] __do_syscall+0x1da/0x208
[  319.799835]  [<000000020d757322>] system_call+0x82/0xb0
[  319.799836] INFO: lockdep is turned off.

Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
---
 arch/s390/kvm/kvm-s390.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 2296b1ff1e02..b75ea3e57172 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2185,15 +2185,15 @@ static int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rcp, u16 *rrcp)
 	 * behind.
 	 * We want to return the first failure rc and rrc, though.
 	 */
+	kvm_s390_vcpu_block_all(kvm);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
 		if (kvm_s390_pv_destroy_cpu(vcpu, &rc, &rrc) && !ret) {
 			*rcp = rc;
 			*rrcp = rrc;
 			ret = -EIO;
 		}
-		mutex_unlock(&vcpu->mutex);
 	}
+	kvm_s390_vcpu_unblock_all(kvm);
 	return ret;
 }
 
@@ -2205,13 +2205,13 @@ static int kvm_s390_cpus_to_pv(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	struct kvm_vcpu *vcpu;
 
+	kvm_s390_vcpu_block_all(kvm);
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		mutex_lock(&vcpu->mutex);
 		r = kvm_s390_pv_create_cpu(vcpu, rc, rrc);
-		mutex_unlock(&vcpu->mutex);
 		if (r)
 			break;
 	}
+	kvm_s390_vcpu_unblock_all(kvm);
 	if (r)
 		kvm_s390_cpus_from_pv(kvm, &dummy, &dummy);
 	return r;
-- 
2.32.0

