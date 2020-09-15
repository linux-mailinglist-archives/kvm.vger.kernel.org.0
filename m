Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D626AFD3
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 23:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgIOVor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 17:44:47 -0400
Received: from mail-bn8nam08on2083.outbound.protection.outlook.com ([40.107.100.83]:29249
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728085AbgIOVbC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 17:31:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ql1yOt/1sjhmOsDzx40ItUm+M0OydLFK446qUaZDraTcRuusQ0ac/Z207poV8ERodka2AHXbLkTrNKUIuPNNYBmepjzTBDcf7FT/Dn1/TUdu6wobue5IzVHyrhRyj0wXLtJuwsjXW0Us8rrIblbk3QloQzWPAz2CiMK4ZgEuMvIcV46/rwX74iRnyNylRmQCDLfgBq8eWm3oPyVTVATr28P2+9taw80i4yzxtIQuSrkMoPI5kJZSXzBDLGI+l/YZEGln/3Ity7bPxGQIS1MYqVKO7d+nVYM5lB7UmfuATb9dm6pSwjxUwi2Ion5+IWgqEMhhtxQS4qWwnz0ek5iUtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXF8fTPJ/Y9pFcClOLMeQ5tenPBU4qylEmby8f9sbW8=;
 b=iZF7Z6ya9RARFt6c2+rWsAVvnHhbindfxsWuOA8KGAIb2uMy+dISq4uj7QafZBDa+kRD81oEOC997lM3FY3ZNJSYkYS88EiwjlV1Y2CBwsWhm4pz98dpIvu5WV13OfOUa3UymiN3/TKBAmrApkXj3i2ONfXwzRjOCn7SSdIMugPwbWEGDBDK0mBjjGc8uftpDCedkO9ukXB8Z4zJuJgdjpRgM0ajlgrua1V8xE1/HWu/jB69hWVJi1xYhP7oMnLcrjUNUlcMzIiVvBQFeBeV4SHSch2QVS7OzXDaJ21gIi+aoRw5GVOI/CBs8t0D4+4Teb9HaO3skhdfaxuNBwOxhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXF8fTPJ/Y9pFcClOLMeQ5tenPBU4qylEmby8f9sbW8=;
 b=lO8L1F44dYbQrV5PRYOwpt2OOEg9EvFfRa1pUHqqwt3blSFWJs3Gwnp9j4ExpUD6QIIYBduQdOurDxCio13ZnLyK1BX54JF8K94bGJTeOi8aCQWDS9NF4HsEarA3w247PIVFAW9yD33NZz2x/yuhHlAd0H8BpFJX0NF623fP1wI=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 21:30:34 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 21:30:33 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH v3 4/5] sev/i386: Don't allow a system reset under an SEV-ES guest
Date:   Tue, 15 Sep 2020 16:29:43 -0500
Message-Id: <058dcb33a9cc223e3180133d29e7a92bfdc40938.1600205384.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600205384.git.thomas.lendacky@amd.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR21CA0024.namprd21.prod.outlook.com
 (2603:10b6:5:174::34) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR21CA0024.namprd21.prod.outlook.com (2603:10b6:5:174::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.1 via Frontend Transport; Tue, 15 Sep 2020 21:30:32 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 400fbeb3-719d-495c-c1e2-08d859be9416
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB160700615C797537AA830B9BEC200@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wl4pLzrUN4iZXeFltD1AXlkTQIP2YIoKC3AlR2md2CKgbFj5DLDxc1fdWgkEZqsjxPQ0r/bd9yQgB0JK1yDi8Um2q1N7hlWlcOiEaptQoSaxNyoJ12DCMQDvpmcZmcgzuZSij+PfhLfLXX1IGAmjLJ3FEDkO/sXZZlvBKTIT7elJMsXVjTRKC6nueba9ORa2Sk0N1XlRvC7TPuwKgyZALRyimAkx0dkLjP4cM1GPQEH2vtzXqSxoBIMRjGdb4tvp45PScqRlFh/2JSB6pBras7ZwFBNBaizyI+UZc9HD5IF3KKIlczXds0TRKBU8G9CL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(5660300002)(956004)(478600001)(6666004)(86362001)(52116002)(2616005)(2906002)(7696005)(36756003)(66476007)(8936002)(66556008)(66946007)(316002)(54906003)(7416002)(26005)(6486002)(4326008)(8676002)(16526019)(83380400001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FcvrEI1uBWjZuelOaGS5d/PHx83Yo/QJwB+ZchJEm/cEab7qQ0m+mjp6JosobUENkRYbXIJdrwquCE+yPHeBTqxq19V6riVVorC9hOo+cJSh10mgANqCVB6+BEkvDijv9+q6XvJDmBGE1BN7jquFFHeV1r9imNwqof7/9k/kNIaTsEST0Km+WHKIxGqV58ElEVJIDykgf9/DuTXkKjTY9nZhn88UgTjBxxJABpl0IOFTCuow2GdFAdOAxSbpPViDCKsfaY/mQ8w0NKPAms/m+bD0lvYze+2HuT9pDmJtQkSNDDyemujW6wATs49hDQ/mCtxcDfKDa4UmRSSQN8VIEDdUyYWH0dLgkTN7Z6aO0gSgwV0yOGPuiYmBS2dJBs+2ZF2W8LzaglTs8Wyse1GCd1Ir+Ie4lwDS49NARIeYoqWRAtvo+qD6gMkCn0h4iXSQKzv7kcJdGnyUFIqjz+hNYA61MG6hLxMk73J6Vv+puFdhuuWGEI3tO1mD5lVlq9Xgd31AozgK2TZVQF11QKpmpGi6+gs6/fF1VShA/eYqMZD/mZ6x4DclorktScIauojO1paCdVWkG2NHpBQZVE5pJa6DriXbQzXkd9uRlfi5p/Em7XnZV1opqT5XPe0gxIcQF+lcW7NC0YCSyUztiQwDIA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400fbeb3-719d-495c-c1e2-08d859be9416
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:30:33.8331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OhCEAdmp/u4ySPQ7QKhb7acffs4LNH8mYN9mcjUU6GNGf9983RVbuwX3rhXhmY64JEe1UQTelEuc49+kpjmA6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

An SEV-ES guest does not allow register state to be altered once it has
been measured. When a SEV-ES guest issues a reboot command, Qemu will
reset the vCPU state and resume the guest. This will cause failures under
SEV-ES, so prevent that from occurring.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 accel/kvm/kvm-all.c       | 9 +++++++++
 include/sysemu/cpus.h     | 2 ++
 include/sysemu/hw_accel.h | 5 +++++
 include/sysemu/kvm.h      | 2 ++
 softmmu/cpus.c            | 5 +++++
 softmmu/vl.c              | 5 ++++-
 6 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 20725b0368..63153b6e53 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2388,6 +2388,15 @@ void kvm_flush_coalesced_mmio_buffer(void)
     s->coalesced_flush_in_progress = false;
 }
 
+bool kvm_cpu_check_resettable(void)
+{
+    /*
+     * If we have a valid reset vector override, then SEV-ES is active
+     * and the CPU can't be reset.
+     */
+    return !kvm_state->reset_valid;
+}
+
 static void do_kvm_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
     if (!cpu->vcpu_dirty) {
diff --git a/include/sysemu/cpus.h b/include/sysemu/cpus.h
index 3c1da6a018..6d688c757f 100644
--- a/include/sysemu/cpus.h
+++ b/include/sysemu/cpus.h
@@ -24,6 +24,8 @@ void dump_drift_info(void);
 void qemu_cpu_kick_self(void);
 void qemu_timer_notify_cb(void *opaque, QEMUClockType type);
 
+bool cpu_is_resettable(void);
+
 void cpu_synchronize_all_states(void);
 void cpu_synchronize_all_post_reset(void);
 void cpu_synchronize_all_post_init(void);
diff --git a/include/sysemu/hw_accel.h b/include/sysemu/hw_accel.h
index e128f8b06b..8b4536e7ae 100644
--- a/include/sysemu/hw_accel.h
+++ b/include/sysemu/hw_accel.h
@@ -17,6 +17,11 @@
 #include "sysemu/hvf.h"
 #include "sysemu/whpx.h"
 
+static inline bool cpu_check_resettable(void)
+{
+    return kvm_enabled() ? kvm_cpu_check_resettable() : true;
+}
+
 static inline void cpu_synchronize_state(CPUState *cpu)
 {
     if (kvm_enabled()) {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index f74cfa85ab..eb94bbbff9 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -494,6 +494,8 @@ int kvm_physical_memory_addr_from_host(KVMState *s, void *ram_addr,
 
 #endif /* NEED_CPU_H */
 
+bool kvm_cpu_check_resettable(void);
+
 void kvm_cpu_synchronize_state(CPUState *cpu);
 void kvm_cpu_synchronize_post_reset(CPUState *cpu);
 void kvm_cpu_synchronize_post_init(CPUState *cpu);
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index a802e899ab..32f286643f 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -927,6 +927,11 @@ void hw_error(const char *fmt, ...)
     abort();
 }
 
+bool cpu_is_resettable(void)
+{
+    return cpu_check_resettable();
+}
+
 void cpu_synchronize_all_states(void)
 {
     CPUState *cpu;
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 4eb9d1f7fd..422fbb1650 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -1475,7 +1475,10 @@ void qemu_system_guest_crashloaded(GuestPanicInformation *info)
 
 void qemu_system_reset_request(ShutdownCause reason)
 {
-    if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
+    if (!cpu_is_resettable()) {
+        error_report("cpus are not resettable, terminating");
+        shutdown_requested = reason;
+    } else if (no_reboot && reason != SHUTDOWN_CAUSE_SUBSYSTEM_RESET) {
         shutdown_requested = reason;
     } else {
         reset_requested = reason;
-- 
2.28.0

