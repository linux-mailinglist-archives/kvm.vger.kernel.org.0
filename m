Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167022F6ED4
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 00:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbhANXO3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 18:14:29 -0500
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:37125
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730799AbhANXO2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 18:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrgUXWKkMj2dCYjklwoPCN3oRhl9HtLZd4RIfgtBWO50k5OLRsbcyF36AREFHVcTkLu/8lFWkkpHU5umHn8SA3jN2X6eYIA9vvo8aHP3CWdNVgOQRYkrwueG26uoIe7RNGjSiuTxhJhv9xHUOLrRt/Hw8FQ763s+TUef+mlqMkCi15JFeabP5dtkK7WxUcnTUwOQ/xxbHk1CK8TBPhbHLPPNVOEssdsLkhwq+5i+pnufDMJ0OzALOq8OZTWjE4gTLtd0dPq8C8teBaAZtGK25tHuVussdGCywRaaNNWRUQuoO90xDhMUyiJu7B0a4bV9uKsHIHY4hLvGBVlLFlv9nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL/4RU8ga+O/ynjbp7ttMwZnaHB0wh1OA0hcnvMmlC0=;
 b=TNDhe4ft/AIYyQTWtEy9szBEza0PDV2GELqxDVM6t8yUy9Y47iY8+Lv2dk4RDXcm/S8OUxpUYQT34zsiYzlOyyYCKSFX1fEGAyzh99J1emqrkY8Ewoz+nVNcloh7R3RmUAltSxvSrq9vTowwNAi1rvj0+LvlbzlOd+pm73z+dDUmhWWfMezztzMcwGuAWL4VSDOlIeiAImUBitRSpctWMFqHuDv9OvLlyVNVKAesRfMo9ttFTEj/JXQdSAKMhEYjsQxdI6nh3DdgtaeqY0T/yS19C5Ozi9opjbKBSs4PB6wz5ehhbUyi3TmE/jqa3bPYr7LfViKHD/lkcucBW0XCGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DL/4RU8ga+O/ynjbp7ttMwZnaHB0wh1OA0hcnvMmlC0=;
 b=yqqsPgrOChtcBjyDE222aM+0ajmmQZLS3Y3LPg6OnvWHDDc7ezsLwCwkE1M5Os2ICz0rWuZm5B+2yr2CfuplWYPLnKcHNqFcYXa8wOSu3+1dhOvvNoY9fxOccBqup8C98uzu1sxm5AANjLX4q8caacErBJqq1L+4sllLTYA16k8=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3763.9; Thu, 14 Jan 2021 23:12:58 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3763.011; Thu, 14 Jan 2021
 23:12:57 +0000
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
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v5 1/6] sev/i386: Add initial support for SEV-ES
Date:   Thu, 14 Jan 2021 17:12:31 -0600
Message-Id: <6403cdc0040bc07355b35fe56e26fb9cd11eb172.1610665956.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1610665956.git.thomas.lendacky@amd.com>
References: <cover.1610665956.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0601CA0012.namprd06.prod.outlook.com
 (2603:10b6:803:2f::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN4PR0601CA0012.namprd06.prod.outlook.com (2603:10b6:803:2f::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 23:12:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e5947bc0-205f-44a6-6f79-08d8b8e1ee67
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2503C9A9BCC5A2BE216786F4ECA80@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9x8VQFwLp8Qgiu7OJC4v2Kz/yA+FiQ1YYkWsiZAaS1WAhwq9xoR5UYAbuGaPBZsw5egW8rDWO8NYwWN2m9JISYtf3ANQ27oz9vX3XD88xSKCHpJWiBy1rVsjwiQvAF1C+lg/TvKqitMgv/xohZEhhtimGdfbU4uBLsC1UpI4BU5emqXwWwXHAQr+v8vM+wOM1isw5ipbPcQ8l66Y5jm4GIfB0JCMkzWlYVd1C3uPnz4KB9SlMyWWr3n407STTmAOy2IC7aiv/hp9g/aqjxLwt1hpNgBzXaFa3u3hiOnyY9Skc6xKnnMZDGTRV3MKfSFHlAYqdfBcU00Sm2FjV9vj61LwbbeQQt1j9J808ctXjmE2LXZt8H8ZH1v5tkO35ziaI8G+bjqINiVbUaWPZyfv+ETMmnLbfyLb4Bp+NUpeTeby/i80Rt5LZApj+q7msykB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(396003)(39860400002)(8936002)(54906003)(186003)(6666004)(6486002)(16526019)(86362001)(7696005)(956004)(66476007)(66556008)(52116002)(316002)(5660300002)(7416002)(2616005)(4326008)(36756003)(26005)(478600001)(83380400001)(2906002)(66946007)(8676002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?p0EVQdWvteJu7VknEvfarPlXwS4/vYY8mzEUyn3N07PSCS3PCklYW4ArT0AW?=
 =?us-ascii?Q?+vNLG3nXquzpkrEmvOhTe+DNXzKGDtiGRWinA9E3YIKZcG1S3WXlZP+i+IDb?=
 =?us-ascii?Q?rbWsRmZQgvUf0I2hBxalU2fg5SgY9mpTeMPRrSKVbvbj5H5q4N+djdy96tAh?=
 =?us-ascii?Q?8FVpmyyuLaaSm78myx+NBrJyuJTmlVxm9qXQSyY/N56xutoOxmryuEzJF2JG?=
 =?us-ascii?Q?YAQ+dDLNR1IjIR69yqx1AKHHY0yV4au5ulrWUHu1MNrOP31XbJxFtR3RLYRF?=
 =?us-ascii?Q?m1NcryKPYh7A1GXZZyM04nDfLkSZu7R0rTH/KupMS2OKfH9AMLj9yarUbxuN?=
 =?us-ascii?Q?aBdVEhTPOKR3dgkJpUL0s/dqc54Oj0SACopWAjdLRTm4XAwUVad6UfSa4NOt?=
 =?us-ascii?Q?cHjqikTqv/AF60MemxhdqlVeoKIDzpM5IbXPxHQiZs18wG6TtzxE/4KagqH9?=
 =?us-ascii?Q?z43p6yF/9wMs41AuxNWzWvCG1c7Q7E2OpozhA7uJeu6TqxLrEFHnNCxCydkV?=
 =?us-ascii?Q?TYovvXIHpQ6pQzcA+K5mg6gwwd+mbWNR8qHtgRvREijRJ521G6uHSUOtw/t6?=
 =?us-ascii?Q?W6EGfOfNpoV3P4/I/lLJsL2du5rw88DsceZWYq718C1bbJFCiavVNK1TqGE9?=
 =?us-ascii?Q?ccPY9TjqpZzeXOTugh/kYP8NypzZMgWCu3Hd1xe/Y+ra8sfpzNvlDsHCbSDI?=
 =?us-ascii?Q?Kf8YMUlwWX4TqYixXdr38YBaTHqCDVMNGAdlI0Y9fC/WW8SdkNMy4obKtihs?=
 =?us-ascii?Q?phNaxVThnrO4xfQfQ1F2qo9KVj4cceZcebh3q+Yv7U62WHvcSZWk6/jvLviO?=
 =?us-ascii?Q?/80SDYaNNJaQJ4Wa4gZar/4xugdWHS7SaF6n/UYz+Wq+f0zVSwkjyXMm1Xci?=
 =?us-ascii?Q?eyKhzP0x2s7THnrRHzOmDYueSAV9kmDKTGJEFEDtAJ1LFvk5JPBI4AbzHHiF?=
 =?us-ascii?Q?spVINJe9FFv7c4lwnuVhXKPle7i8Nbxbyfdz6Ownt6eSDIp7ebnYW1ha87B/?=
 =?us-ascii?Q?cwUb?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 23:12:57.9164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: e5947bc0-205f-44a6-6f79-08d8b8e1ee67
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9vDIk4ocHWjB/hvaEMqgVwmHH4BNqRji+y2nllxhnulwOdk2GIeNIlnEm3wXG5tZYKpYuAZ7z1HrrXCjx6iwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Provide initial support for SEV-ES. This includes creating a function to
indicate the guest is an SEV-ES guest (which will return false until all
support is in place), performing the proper SEV initialization and
ensuring that the guest CPU state is measured as part of the launch.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Co-developed-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 target/i386/cpu.c      |  1 +
 target/i386/sev-stub.c |  6 ++++++
 target/i386/sev.c      | 44 ++++++++++++++++++++++++++++++++++++++++--
 target/i386/sev_i386.h |  1 +
 4 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 35459a38bb..9adb34c091 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5986,6 +5986,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0x8000001F:
         *eax = sev_enabled() ? 0x2 : 0;
+        *eax |= sev_es_enabled() ? 0x8 : 0;
         *ebx = sev_get_cbit_position();
         *ebx |= sev_get_reduced_phys_bits() << 6;
         *ecx = 0;
diff --git a/target/i386/sev-stub.c b/target/i386/sev-stub.c
index c1fecc2101..229a2ee77b 100644
--- a/target/i386/sev-stub.c
+++ b/target/i386/sev-stub.c
@@ -49,8 +49,14 @@ SevCapability *sev_get_capabilities(Error **errp)
     error_setg(errp, "SEV is not available in this QEMU");
     return NULL;
 }
+
 int sev_inject_launch_secret(const char *hdr, const char *secret,
                              uint64_t gpa, Error **errp)
 {
     return 1;
 }
+
+bool sev_es_enabled(void)
+{
+    return false;
+}
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 1546606811..fce2128c07 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -360,6 +360,12 @@ sev_enabled(void)
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
@@ -580,6 +586,20 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
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
@@ -592,6 +612,14 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
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
@@ -686,7 +714,7 @@ sev_guest_init(const char *id)
 {
     SevGuestState *sev;
     char *devname;
-    int ret, fw_error;
+    int ret, fw_error, cmd;
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
@@ -747,8 +775,20 @@ sev_guest_init(const char *id)
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
2.30.0

