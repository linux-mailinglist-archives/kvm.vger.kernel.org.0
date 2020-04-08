Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253981A1B4D
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgDHFGM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:06:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52844 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726830AbgDHFFt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 038553d4013457;
        Wed, 8 Apr 2020 05:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=RT2DLUiFIblGAhj2vsdXWMs47UzEg77Wx4rwQqNvIys=;
 b=vt9sy4IT0ona61EF6lrQB6+fOd4n1UUP16sabHo45o2Fj3qC6LzIzwKRjy/UGHKp6UtX
 qFSd5YSVzautGXeCr2eAJwfIK/iGXCJNeAxcoDO3I7m5gSP91p4n0pb5kTTgdsi0yjOx
 qo22FkosRIApaeM6Fz6ilxR/dtoXxhOalPa8lPluAeNfJBYl4kG5bLmjOE/87zZNyJBJ
 gyT8RCVnfUfcfVutEDgu5tGajHjyK4ZwDhUOdnggz0MB/ArZELsxKKhJSr8EvqA/iPGM
 LytegfsDsU5SPuZ1H7lB9GSPk4DwMfVvQ5OLU8BwvFvA+C8d07oHuaLcCOsQnaN6BFRD jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3091m390y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03853M4I159232;
        Wed, 8 Apr 2020 05:05:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3091m01g4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:27 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03855QOv007470;
        Wed, 8 Apr 2020 05:05:26 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:26 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 20/26] x86/paravirt: Enable pv-spinlocks in runtime_patch()
Date:   Tue,  7 Apr 2020 22:03:17 -0700
Message-Id: <20200408050323.4237-21-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable runtime patching of paravirt spinlocks. These can be trivially
enabled because pv_lock_ops are never preemptible -- preemption is
disabled at entry to spin_lock*().

Note that a particular CPU instance might get preempted in the host but
because runtime_patching() is called via stop_machine(), the migration
thread would flush out any kernel threads preempted in the host.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/paravirt.h  | 10 +++++-----
 arch/x86/kernel/paravirt_patch.c | 12 ++++++++++++
 kernel/locking/lock_events.c     |  2 +-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 694d8daf4983..cb3d0a91c060 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -642,27 +642,27 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 static __always_inline void pv_queued_spin_lock_slowpath(struct qspinlock *lock,
 							u32 val)
 {
-	PVOP_VCALL2(lock.queued_spin_lock_slowpath, lock, val);
+	PVRTOP_VCALL2(lock.queued_spin_lock_slowpath, lock, val);
 }
 
 static __always_inline void pv_queued_spin_unlock(struct qspinlock *lock)
 {
-	PVOP_VCALLEE1(lock.queued_spin_unlock, lock);
+	PVRTOP_VCALLEE1(lock.queued_spin_unlock, lock);
 }
 
 static __always_inline void pv_wait(u8 *ptr, u8 val)
 {
-	PVOP_VCALL2(lock.wait, ptr, val);
+	PVRTOP_VCALL2(lock.wait, ptr, val);
 }
 
 static __always_inline void pv_kick(int cpu)
 {
-	PVOP_VCALL1(lock.kick, cpu);
+	PVRTOP_VCALL1(lock.kick, cpu);
 }
 
 static __always_inline bool pv_vcpu_is_preempted(long cpu)
 {
-	return PVOP_CALLEE1(bool, lock.vcpu_is_preempted, cpu);
+	return PVRTOP_CALLEE1(bool, lock.vcpu_is_preempted, cpu);
 }
 
 void __raw_callee_save___native_queued_spin_unlock(struct qspinlock *lock);
diff --git a/arch/x86/kernel/paravirt_patch.c b/arch/x86/kernel/paravirt_patch.c
index 3eb8c0e720b4..3f8606f2811c 100644
--- a/arch/x86/kernel/paravirt_patch.c
+++ b/arch/x86/kernel/paravirt_patch.c
@@ -152,6 +152,18 @@ int runtime_patch(u8 type, void *insn_buff, void *op,
 
 	/* Nothing whitelisted for now. */
 	switch (type) {
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
+	/*
+	 * Preemption is always disabled in the lifetime of a spinlock
+	 * (whether held or while waiting to acquire.)
+	 */
+	case PARAVIRT_PATCH(lock.queued_spin_lock_slowpath):
+	case PARAVIRT_PATCH(lock.queued_spin_unlock):
+	case PARAVIRT_PATCH(lock.wait):
+	case PARAVIRT_PATCH(lock.kick):
+	case PARAVIRT_PATCH(lock.vcpu_is_preempted):
+		break;
+#endif
 	default:
 		pr_warn("type=%d unsuitable for runtime-patching\n", type);
 		return -EINVAL;
diff --git a/kernel/locking/lock_events.c b/kernel/locking/lock_events.c
index fa2c2f951c6b..c3057e82e6f9 100644
--- a/kernel/locking/lock_events.c
+++ b/kernel/locking/lock_events.c
@@ -115,7 +115,7 @@ static const struct file_operations fops_lockevent = {
 	.llseek = default_llseek,
 };
 
-#ifdef CONFIG_PARAVIRT_SPINLOCKS
+#if defined(CONFIG_PARAVIRT_SPINLOCKS) && !defined(CONFIG_PARAVIRT_RUNTIME)
 #include <asm/paravirt.h>
 
 static bool __init skip_lockevent(const char *name)
-- 
2.20.1

