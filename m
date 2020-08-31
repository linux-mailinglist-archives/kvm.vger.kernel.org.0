Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF86257D75
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 17:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729196AbgHaPhv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 11:37:51 -0400
Received: from mail-dm6nam08on2043.outbound.protection.outlook.com ([40.107.102.43]:56437
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729335AbgHaPhj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 11:37:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CA9ituaPySmYdpBCZWQHc719C9VrmO2NG9+6+e6vyFU90F01BXhTuYobsU3RN+6ut7xONhe+jOppQgRYoVtKfsye17t6cX+SJxu4H+3sCD/HrmJNzTPzziHBSxhLVnv///OrPy/O/Edsi92+EqS8HGVb3I+vxUM3BF+0AFm/lyo3KZE+YPje7XHDOujBbsD9fW/KVvfPHtt7W6iWRCJ3K5uFz1KXgSiEyinYkejbqDK0aRdBiMK2vTVWKLmbTIkAF0ANgHWk/ehquC1JAMQL/SFWzTh8aMxZj5IC/ukBbu8NhJ560M/PGuah9Kr6Gu5qfdCLjZF/M7DwUhQPRoB4VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+BpJng5csN/LA+I/qcPQkYM/tISIORmRx+LOYMnks=;
 b=hORM3Vy8hyK6xLsYFFSIq/y5Tp6Pg2z/sJ60tyYU1JZyT2yeXLN0JIwCuzigEd90XFO6iCzy/7VCTbvNkYmv3I2yEx66mY7GYHl7KcTWxLvGruA7o89b+SmXOhIQACCdqeJUGDt4zl5J8g5c0NMcTUmJBuYpl0a5bI7ctwF7zxOPH+OVpwJHCH692Ie+5sYpc1qp6RShWQUqGr7CE08rIpEr9KHl+GGSWV1Y1Vc/AL+HCTi/6019BUZCInTm+2kMFx2NHqY37W6J4aVlZAccV2ScuvS9KmtFSyOYRf0c9e9mCvZx5A9ODE4XCPvZjAYFtpeAS4YDOtHNlZhZVqPCPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+BpJng5csN/LA+I/qcPQkYM/tISIORmRx+LOYMnks=;
 b=eBTRGY6a+GyfUq51LlvjAUZ2fHcsw2xp2QzSuQ9LF+DjVDHDA6KTX5D79vYYHN03TrwuzczBCPhSxTy6dX2I07/wkMbvuWSBMD5hgTnXyJSuGyEMLCZlXFdIi1L7b7uqN47qHv6xhfdvAT3tAL58zzTvUyvQk5k5HLgEHHwNfOg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3326.19; Mon, 31 Aug 2020 15:37:36 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 15:37:36 +0000
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
Subject: [PATCH v2 1/4] sev/i386: Add initial support for SEV-ES
Date:   Mon, 31 Aug 2020 10:37:10 -0500
Message-Id: <6222b0024f7af99fe7de5eede633d00e42162e2f.1598888232.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598888232.git.thomas.lendacky@amd.com>
References: <cover.1598888232.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0061.namprd12.prod.outlook.com
 (2603:10b6:802:20::32) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by SN1PR12CA0061.namprd12.prod.outlook.com (2603:10b6:802:20::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 15:37:35 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9569550a-4ca3-4eab-65e0-08d84dc3c93d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB448403024AD44777CD0BE3B4EC510@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sEp+kjbfBef11bfZgkVrkg5IV8ofbX8OSiVzyVbxJsRsel2y/a7COTjh4OjyPDfh8ro02/ASUQiMVfsdmaGngLCbrs3N9jzKB2k5CD6DAH0rrf+g0fVIFgSjcptViR7RCmrHb3PGgjqDJ8/OvrddosHJNa+Bj39dBHPsdfNYgOQNpHnNnLxq9/DRxLwMynjPyeUKjSVe8sLM3hXK7KwgvCXaNpEtlr4MeEtuzd4SxdkDwD9ffcHWbiSooVjtTAdVPGLsWyJQaVR+bRSupXcAOuToqhI5Yptf5cl0qNbuL8lBkpEY3Av4FQqXVc9Mrm7ZNMh4l3ANg3JS4EgKoPpjUX7OMwltedn74PYKTSgWsOwIXxup9ZzxZxvjyQWuv3yx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(366004)(346002)(376002)(136003)(54906003)(956004)(16576012)(7416002)(2906002)(6666004)(4326008)(2616005)(6486002)(316002)(66556008)(8676002)(66946007)(478600001)(186003)(5660300002)(8936002)(86362001)(83380400001)(66476007)(36756003)(52116002)(26005)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BC9uk/Y5kE+Kl2S0IU3FJD8eG/XG8+D3Hl7bC1jXS8CpO66hDLSNRueM1NW1hFMk0Q2YE4CHLfjoMIel0mpPTNuBcYTuZwP7nZ5tw0NJFChW1dREVmhrCbEaTNSp6o/x3JE8LROIvncmO7nO1ebOpXoRz46v0IJy+nnGZqx1r9qnBQ5yGr3QQbSn03z33i4TTc6QkkZ2ZL8QEKg3o0APvje7HW5uMBBKKld8bk6qXA+Z9mIr/t/V4PDsYIEke/vEMBCRgUBt0GO8a0+jMi0uMh9/lhwM5pwkdW8oZBDvs7lSg0lbijDdYAaHDV5v45E80HJxN0bp2u6MxQJSfz1bGgiBPw2A1GbDfcOLGbSBDMZQsEn7cinXrOubP20lkTVfgJRlBORvmwz7prs+Ohwp9ERFv71V7RHe7g1pWRr4MuXFZ7xLbp2qivmkxFatPYz1qXbyB5A2Vrk7i0ppgRyTr06Qjduka2RPk4HX6SvCgLkPJqPzLJHzG6yqgKRg12M5psouQNcCBZBaoPrXTCEHQ+jzu+ORK4ZRXMcfpEsX3I5wSY6aOSTsjyWRf9BwaxL527pKJW19QFGOtgpMChZwf/OwvuTkyXeTTMtwb6yBd85AeVMT6dckM0lifOAPIZi2mRhvKLl0gAA4Xv+tFM5QRA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9569550a-4ca3-4eab-65e0-08d84dc3c93d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 15:37:36.6519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHBZq1bZzH2IaITt/kKzRcSjaqYZRPvFht2nuA55LtkDYM9viUkbWMz171Ow4jQanmY4UKW7hbe7tXfhSoORGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
Sender: kvm-owner@vger.kernel.org
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
 target/i386/sev.c      | 46 ++++++++++++++++++++++++++++++++++++++++--
 target/i386/sev_i386.h |  1 +
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 588f32e136..bbbe581d35 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5969,6 +5969,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
index c3ecf86704..6c9cd0854b 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -359,6 +359,12 @@ sev_enabled(void)
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
@@ -578,6 +584,22 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
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
+        goto err;
+    }
+
+err:
+    return ret;
+}
+
 static void
 sev_launch_get_measure(Notifier *notifier, void *unused)
 {
@@ -590,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
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
@@ -684,7 +714,7 @@ sev_guest_init(const char *id)
 {
     SevGuestState *sev;
     char *devname;
-    int ret, fw_error;
+    int ret, fw_error, cmd;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
@@ -745,8 +775,20 @@ sev_guest_init(const char *id)
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

