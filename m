Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11C2E27914C
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 21:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgIYTE2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 15:04:28 -0400
Received: from mail-bn8nam11on2077.outbound.protection.outlook.com ([40.107.236.77]:28641
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728069AbgIYTE1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Sep 2020 15:04:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iMlp+NnyQYMHni7mJpzT6sqRMDbSTaYdOoL1QMk2pml+xqo1Su83I14WwKI9NmhG2dmFL3cHGQ0rUWpbNu/YFSG5juZbk9t0kvXPXYlyoljTVEtQ6sztDgzmACEvKUtfpVlOu2bAVa50dFNG+rp5C5FIM1PXXUhsvph5IHgV/UcRibvVuNT4BJwTqIG5fgnkzEbkf+l3Kp5SFmOhS0QnljANA7cRR5u7Ele12StoW7NOPGSWhDjhNcyVFVVrwwdGwsKi4gHrzW+U/CgeDLBI4y3Dpln9yfENhxgPy07m45mIjMXEaSyzj8L0Yhb3HryfFfH8TPZZl+8NYeSbCeqyGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnGr0S8uGAzeDpWKwoRpwkcNUvB3BEpyqXdIK+1wAC4=;
 b=ifdZ2bBRpSmPydYx7h+A7vmB5YKKd9eVzEUr31QFwECc7nZfvbcU+4xAG2Ny8gBuqUlFvva/EdH2N1uBkxrFwvmIXFEKnUzYbhfXYmy2kYrUex5nnQ3pEk6by6tQJE+zhxg8UJXuaQ61wdPuqrE/ez1VfOjcaQgcWfSmBP1PPRhbH0nSPoxmJPCd+vbpMd8ZdLhDSZ+HOz6DOSFu6dADsUTqsEdWK1YS9yUgVGf1BUqES7iyaQ0Jpr+H14kqiyDs/TJMW8D+onCIuy4WmM51Kqeoz5zO4/eXjrpQDAxI2Bh/0btB3jFCyyS/SyWR3Qdx9kuPvOU2asmL2hTN+ew4ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qnGr0S8uGAzeDpWKwoRpwkcNUvB3BEpyqXdIK+1wAC4=;
 b=PFOcTaErpmUzYeeRWBZksAj+KhoCRBw8nbtbdOwamdIK9qcfVt8ceG47HVpZCZs3DxDKt4kq7FtRcl2R7tBINBUWjl3Hvzs5k03xXvYDTKZF4Xi5wtnSPMX5AGI5rP02A9MnQUuNWIgOZJ1VctCqda/Z6API0bY0Ct4kKBsrWRg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4297.namprd12.prod.outlook.com (2603:10b6:5:211::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3412.22; Fri, 25 Sep 2020 19:04:25 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3391.024; Fri, 25 Sep 2020
 19:04:25 +0000
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
Subject: [PATCH v4 1/6] sev/i386: Add initial support for SEV-ES
Date:   Fri, 25 Sep 2020 14:03:35 -0500
Message-Id: <29ff1690a9f84536ccd303cda9f105814e117f45.1601060620.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1601060620.git.thomas.lendacky@amd.com>
References: <cover.1601060620.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:4:4b::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR15CA0032.namprd15.prod.outlook.com (2603:10b6:4:4b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20 via Frontend Transport; Fri, 25 Sep 2020 19:04:24 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb7633e1-5362-4627-6c89-08d86185d1c0
X-MS-TrafficTypeDiagnostic: DM6PR12MB4297:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB42975FAABACF8B8C51B55C29EC360@DM6PR12MB4297.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W6h2JHIx4sslAl+7ApPXQleOuljSoufIHXrMJt0F226KXT+NWHdDuPoMnbvQwvNjz1Adv9eI9iUyreQ1Eeo8bg2xdscmRaWx0c8+V+jRbfqidlYb428Ic0U2taPP/QyzqCzdJvmm86mF2De0uuEYPMNMNmThkWMxvW8Mp8K0Ud2cQ/3gjarY52OBr7ZflCVXLOgjsqWEOZSnju8ghu6qrqp1ATWrOc9nEcPg2gOyMzLzK2vl0qLX164j5LEcSSFqdISDkbriQVFJGHtMEnwST38tDrdUZ2pJZcqgFGLKEQVvw9SnUQl8YTwiOXin4Q9RDC1BZJLrlqIQvxdX3KwJMsevc94EBNczU7sugUNIlPXKjnt3W0TT7ZbzrCST2clTPLbpfNimY9HgL780flyg0IdaL0TOky9fpOacvNh9rHw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(26005)(7416002)(956004)(186003)(6666004)(16526019)(54906003)(2616005)(6486002)(66556008)(66946007)(36756003)(8936002)(66476007)(86362001)(316002)(478600001)(7696005)(52116002)(2906002)(5660300002)(4326008)(83380400001)(8676002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 75N56JZPgwqEk1hgORCezZDfTSlBrEKkYfrIQvkeAsTfgAW84DYcfuz5Q7sVQxCiYAqvXN0wN1T90wpHbT1OYjavfII2IBgf5G/OCP9QHKTDIjZKtrL4ob4th7mMehz0HWY8dU0v+xf3iLYVSIc3q19oLaaJa+nvXHRTI87cIxaby99bnR3CkHn4LcFdJ4LY/XxD9MEPwd5akB1inNOMK5Zl7jfsCe6zIpU/ZMPAAirdDlD8imBDm99MIvcQU61mwSZRIQ5ih09/mZnB5HU1S/RDekCymVGLWzNtlWB2ne0hNpIkagT4X3o+krC3cDgnTWJ6ROHtQrYOh3ZP6jBjRFUTKvkFvfni/nn4C20ya8pmZBb+Yzq0fwIiMK1nOXuv//hOKPwKEmipuIUKEXzXSJ7M1UmgZAezVnXUnCCTGN+Qz2eYZYwUseT7WIv5kh/1cniL5WrR6g7ZbksivwXzv1eGiszdeKT0BMeeuNtrni7hUhduyGTQiHYzAo+t4WhTaCJNRAg4ow58YEc/ve2IaQTZ6RwU2/s0Fd/LKxGxRfmru17DMzS137CJeDVaeCBf3cr+N6bW6t9e0CwVtRTLJep+vw87XPMjJvRVlreVHEFoyoNh/51dYLZOM8w1ECEBXU7fZLig43Y6htFItzdMjw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7633e1-5362-4627-6c89-08d86185d1c0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2020 19:04:25.3077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fd5aSg4bFPy2ESMgDvjr7+cOKV11ZrEvYuWOytDJNUJUL9vlTt3PEFUOmyGASKhI2KuXie/EPoaYPdX0wyrQ3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4297
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Provide initial support for SEV-ES. This includes creating a function to
indicate the guest is an SEV-ES guest (which will return false until all
support is in place), performing the proper SEV initialization and
ensuring that the guest CPU state is measured as part of the launch.

Co-developed-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/cpu.c      |  1 +
 target/i386/sev-stub.c |  5 +++++
 target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++--
 target/i386/sev_i386.h |  1 +
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3ffd877dd5..ca0e17ed07 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5940,6 +5940,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x8000001F:
         *eax = sev_enabled() ? 0x2 : 0;
+        *eax |= sev_es_enabled() ? 0x8 : 0;
         *ebx = sev_get_cbit_position();
         *ebx |= sev_get_reduced_phys_bits() << 6;
         *ecx = 0;
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index 88e3f39a1e..040ac90563 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -49,3 +49,8 @@ SevCapability *sev_get_capabilities(Error **errp)
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
+
+bool sev_es_enabled(void)
+{
+    return false;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 93c4d60b82..af6b88691f 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -358,6 +358,12 @@ sev_enabled(void)
     return !!sev_guest;
 }
 
+bool
+sev_es_enabled(void)
+{
+    return false;
+}
+
 uint64_t
 sev_get_me_mask(void)
 {
@@ -578,6 +584,20 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
     return ret;
 }
 
+static int
+sev_launch_update_vmsa(SevGuestState *sev)
+{
+    int ret, fw_error;
+
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL, &fw_error);
+    if (ret) {
+        error_report("%s: LAUNCH_UPDATE_VMSA ret=%d fw_error=%d '%s'",
+                __func__, ret, fw_error, fw_error_to_str(fw_error));
+    }
+
+    return ret;
+}
+
 static void
 sev_launch_get_measure(Notifier *notifier, void *unused)
 {
@@ -590,6 +610,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
         return;
     }
 
+    if (sev_es_enabled()) {
+        /* measure all the VM save areas before getting launch_measure */
+        ret = sev_launch_update_vmsa(sev);
+        if (ret) {
+            exit(1);
+        }
+    }
+
     measurement = g_new0(struct kvm_sev_launch_measure, 1);
 
     /* query the measurement blob length */
@@ -684,7 +712,7 @@ sev_guest_init(const char *id)
 {
     SevGuestState *sev;
     char *devname;
-    int ret, fw_error;
+    int ret, fw_error, cmd;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
@@ -745,8 +773,20 @@ sev_guest_init(const char *id)
     sev->api_major = status.api_major;
     sev->api_minor = status.api_minor;
 
+    if (sev_es_enabled()) {
+        if (!(status.flags & SEV_STATUS_FLAGS_CONFIG_ES)) {
+            error_report("%s: guest policy requires SEV-ES, but "
+                         "host SEV-ES support unavailable",
+                         __func__);
+            goto err;
+        }
+        cmd = KVM_SEV_ES_INIT;
+    } else {
+        cmd = KVM_SEV_INIT;
+    }
+
     trace_kvm_sev_init();
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT, NULL, &fw_error);
+    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
     if (ret) {
         error_report("%s: failed to initialize ret=%d fw_error=%d '%s'",
                      __func__, ret, fw_error, fw_error_to_str(fw_error));
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index 4db6960f60..4f9a5e9b21 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -29,6 +29,7 @@
 #define SEV_POLICY_SEV          0x20
 
 extern bool sev_enabled(void);
+extern bool sev_es_enabled(void);
 extern uint64_t sev_get_me_mask(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
-- 
2.28.0

