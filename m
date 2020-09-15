Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6113626AFD1
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 23:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgIOVo5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 17:44:57 -0400
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:21344
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727999AbgIOVas (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 17:30:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNjYlSLEaXVAWq7mHbyJR92EYSjvUnLlW2/isflj+vwY8Mg5q3bxOwrf8nxSnF5BhfD3zK3y+671ZBsyzEdP28aRSByF2TP5SwBX/6m4i5uVXfWWRVlfKw7jEBoBL3IbGuyVixrlI5AGSJpx+qHRgl1y1kZIHl4OTII9Mh87D2WL6IdRzf1cdTuLgpfotErpjuTBpiOcdE+lONycrNB571a1cet56l7L0l3oI/oBJoh2FiKqp8R1w6SOPP8Ce8PaxEJbJFlyqF6UpDMaL5ZXxERF/FuBmljDq7axfXjqcMBIq70/GEVvdvWBBkIkx/hd38BwFr11ZYIHLvJ7GvQchg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+BpJng5csN/LA+I/qcPQkYM/tISIORmRx+LOYMnks=;
 b=bfwY3oY3hj8nfswS/j2xKnUzgMi7NPWmwJbieQaGJiMcze+lTPgCKqjIMowIR6Ib1aCrBpZ11E7PDPEMsJ7EyRIeFg25r4LQBRszH/oQIUK6b1y4Galh9HVQzhwUK5pWwgTnmxF7T3WlT7RW/jjj1QI8GM3GY8ICsGZyUVPnv4tCqCIKqq7lanq8D1d5Wg6nI31wVjAhccjzvDmVuWw098n4iJjQ//7cSPwmM+5NUN6w+TORJeCxNVfDmFqjo6PdGF/nHqefPeSH/cCKE9OfCGHuYbVGh2Crxboh/OjYLIo0bQQnGmEn8uT4VTXOs9GFP50HSdw503qMIpJ9CRR/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+BpJng5csN/LA+I/qcPQkYM/tISIORmRx+LOYMnks=;
 b=0exTJDH5sq9zBSGZtUC2wPy38PRzvE4az0GJIFUHwASHOsbf89iGW4bYdBmef54a2zCF6MOLfqwlyFW9uPHGYetS1psxUp6mTeIjjEQbr19rHTYePfAoCmy/ZaBBFGzZYYWFAmiG+jhVCfpHSJzOJ8HWlC2k1sOAmmRIjoSHPU0=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1607.namprd12.prod.outlook.com (2603:10b6:910:b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 21:30:08 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::989b:b1b2:464c:443%10]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 21:30:08 +0000
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
Subject: [PATCH v3 1/5] sev/i386: Add initial support for SEV-ES
Date:   Tue, 15 Sep 2020 16:29:40 -0500
Message-Id: <e2456cc461f329f52aa6eb3fcd0d0ce9451b8fa7.1600205384.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600205384.git.thomas.lendacky@amd.com>
References: <cover.1600205384.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:3:ac::32) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR21CA0022.namprd21.prod.outlook.com (2603:10b6:3:ac::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.0 via Frontend Transport; Tue, 15 Sep 2020 21:30:07 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7be9caef-abf7-4671-d990-08d859be84b6
X-MS-TrafficTypeDiagnostic: CY4PR12MB1607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB16078003DCFFEDF511B73192EC200@CY4PR12MB1607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 42NvKcwMhV+hkZ6a2o5icitj4a+1HG/0kwvwHUR5mq3zfejADqEhR/WTrUuvRQubbEbmEdMxGADIn1G/cY+fl7VPtH+np3xsl8zvlBYKOe8Pxk8tiADOA0BCOMZWhRf7KkvI3xc3vCn3OnIMc94lnCuH1/u1jUR2s9wToHMpy7Xmdw3ajG18vT0wKFfEiaKgAWPf1OnpbwpIbKkKDC6Mp0MJkij+G8H9sDVF00rja/OIPwzI5pfJ8HRIgJfv4Bn2M/dJ/+ib/VH+WJ+VLofALNQ8Q6YXcLtX/oWt5xxQ4DZQnWgKdkiwqLimF2ikzP/F/wFSoVfLLOru8X9y8G7KLKYKsXaGfpY5u1wnTiELRrKDXecHRH9KJPWOq3HF9XvX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(5660300002)(956004)(478600001)(6666004)(86362001)(52116002)(2616005)(2906002)(7696005)(36756003)(66476007)(8936002)(66556008)(66946007)(316002)(54906003)(7416002)(26005)(6486002)(4326008)(8676002)(16526019)(83380400001)(186003)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I051YFqFnSwiRy6dax9lhZVvzOPLBskuC1xd9oE2mwmBBsvAA4dp0MGUiIfTsYzRY8/pc8rR3DgrnfmiGocgjVCsHcQ/M1rOYQ1VLywqnktyNQWihODVBxywhFC7PI+9w38mmo5gVsJH2Sn3/PlkZ+fq+aWGlXRFJDVQ9jKBM1iCBW8y3jXj8hzOQSymcSc1QW9ANXtWIivN3IS9hU3CKTFzaCo5In9/j6+kk1i0+KLgEWiUZ54RITxlmoqwpi2pefMhBVrxYR81Rh9Fc3mndayjE4ZFY9vv6Y/RuzYnqiJqu872gBglBlo6O5L4mbguFp2B30zQxKLtAj9u1FXTnBS9Ao+w0l6mJ7i2eAD3uCm782dHuiiR6Ec76SbuYGJ562u+TBGiIe1cAohXxW5RbLO6lqZLvEeFRnBc2q8uAdDyvwBLEOJvDeQ6h71B1BgB15qk/ZNAdv9NYBnRc7ZJK7iVHghaY+Ld9I6BTOiB8Dc6IURZt2oiXFvJVlNNBKn+DQd/hUBmq97BG9F0fzc7rVX5U4tZ6vL+yvxew5fhb74EQrpn2w6rLY32AqEVCvEj+ZeaDsAvaulSBq8CPJrha709wxpitDtki4EyD9jm1iw9C+fProVruraDH/IMu6rqH1lLNrL5iNhFhrBoZnLkPQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be9caef-abf7-4671-d990-08d859be84b6
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2020 21:30:08.0318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m3FA5ZZ4wdtW26EPYDOsjn4RbhO0jjfzZyMcQaABeu7xWAoBkyqxfreJxS9WXzZ85CW2kfqMHp/h253jxV108Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1607
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

