Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD2305D06
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 14:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313179AbhAZWg4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 17:36:56 -0500
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:12224
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392553AbhAZRij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 12:38:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D7snSCtG3JTUFvjw4zxp4EfRPQ2/9goph9Qw3UUnLX5TjQaXkiori7WnCOHuZ6BKb8hwzNksw8L8aECb2H+8ekz+7+HC5cQAi7kL61yiOVG+WZMMAMJpGR5GJ21MwKhQq37GgR4IgyytrFF2sC//tMKW+wv3XXNcTov7y6xz+luvx3Z7Ij0DJ2DujSYI3/lfYEvNAn9ACI4kKfkUrwtoxcggKrhsB/gb4Iqh1ymy/pgQyQomL0xNQyUslLDUGmdaPCn/ZyQvrzb4LEbCV9hO6ris9/2Yb8hIxrUiUbItLMshwfv8gxR4tp7ZFqgcIS/JXKPtWIkuDR5wr5Fdyp8yMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMT6c48pr51dMYrBD0z3r9sMxcFpJUFNtsoZoqe32nY=;
 b=CDg4uVat/wjqTqjmqmqbGrbvJV1Vahvu4o4W96JSfUJl6gYrY5MGYMF8eZ/cU2Obz9mHo/gqkk9eoOdFE8D4VCNbXYpz8eMexHL6aGsS1BU0AXfHIYPamcK5EmGNFsI6kBXF1TdrJztx2WLRJHt1pe+vGBNa+5F2zpmA4YSbE5cz9hFGvEJGVIHVLvZyoxxfq0SpIoPJup+0kZI08FKPCEV9F5KMrA7KeYJdoF+CPhPA5gD4nfcmOdlI3Kl+4KxTkbbNrJIdVvAXS1f+/8o3ZyfO++IZc+StujnzYfn5zDDvts8NbyZ+WuARgNqitIx2G6iKMMXMMcmz7FoVChDUdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EMT6c48pr51dMYrBD0z3r9sMxcFpJUFNtsoZoqe32nY=;
 b=O5CbGWstHBbkkg2Ayfi8CBa73EL7HczDpv6AYDs0mCVOJrli8Fjhi++0r76RTaR0ZwV+7P2qICyoVCcEb2+zGlqGp3e4CVvzA6QHkG6oAgCPzsLWztb4aS085mi9o+9WUUzqTbqJPTcWXxPmgCj8rpi5XIBLAPJwNqX/wupGsJY=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4153.namprd12.prod.outlook.com (2603:10b6:5:212::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3784.13; Tue, 26 Jan 2021 17:37:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::cc15:4b1f:9f84:6914%4]) with mapi id 15.20.3784.019; Tue, 26 Jan 2021
 17:37:13 +0000
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
Subject: [PATCH v6 1/6] sev/i386: Add initial support for SEV-ES
Date:   Tue, 26 Jan 2021 11:36:44 -0600
Message-Id: <2e6386cbc1ddeaf701547dd5677adf5ddab2b6bd.1611682609.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <cover.1611682609.git.thomas.lendacky@amd.com>
References: <cover.1611682609.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0167.namprd13.prod.outlook.com
 (2603:10b6:806:28::22) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SA9PR13CA0167.namprd13.prod.outlook.com (2603:10b6:806:28::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.7 via Frontend Transport; Tue, 26 Jan 2021 17:37:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cd680423-a6c0-4743-6b61-08d8c22103ff
X-MS-TrafficTypeDiagnostic: DM6PR12MB4153:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB41530B9BC121ADAE373E39DCECBC9@DM6PR12MB4153.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ID8oZ8HyKDiVBP3sKufLlvnUcIYfOzoLtvxXHy3J4eOiUbnmqvAJr9P6tGjdSXIlsrIKXSqKKtS/0cFs2gneCd4r3FUZVZANcz5ycr9jgXQd5wnXaS0nMAZQS/xaNzXrzcTQhalbwikrbRJjzUPvqH5fdtfbWsBhD1eBYgeYab2vli1lM4hEVkteM/EQIIn89oMx43CO0ZTe+kCiGDgg8xM4piMG5dq+rrwOc/vu7uc4H7+tpGWypql2EwihFZe+l8fCe4T5lkMBt8qnNd16Th9mV7vgOxn+Z0k6ss3FwYQx50Oxn26M1CgueajvcdGeYSzKs0WPFZLD4gOKUBS6ls1V34RBD3fDlABL8HZvi62CoRZXphyAdPWHMW79wOCbBWCGT5qPHlFMqd9dqtkDtDGRefG6gv5CqldHHBzJpPhQc0jzkQnkKfpreNZM4Nob
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(7696005)(52116002)(478600001)(6666004)(7416002)(4326008)(2906002)(66476007)(316002)(54906003)(5660300002)(26005)(2616005)(956004)(86362001)(83380400001)(36756003)(186003)(16526019)(6486002)(66946007)(8936002)(66556008)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Shmyu85v4bEKCyD55c3P6XPk4Mhcvrv0RK06BMtQlUY4kB8h7SofV78dJBMl?=
 =?us-ascii?Q?32g5s0/sq3xQZrTNX+FRu4BTRosv/v1+BMQep10Pvp1avDhUhSdwnnMNmqIB?=
 =?us-ascii?Q?SiDq2gkfUkcRZZK2XMynScVrpTod84AUPdiPUhRdxZzjiqgOnD7pwoQztvpH?=
 =?us-ascii?Q?gi5/md69G+guzlpaX0MWAVFiCQWwoslyD8waq/85l5QXa3U/lzyEVCdR8SpT?=
 =?us-ascii?Q?MGX/uhDkyAqg3Kc/SorvNUwRAT74mZrpSgrODM2YUvsBxTr//6A6wqm//CWX?=
 =?us-ascii?Q?Kg43JdaMFPg82CdEaf+7KiWxKfcEonrn/I1GyXsSeH0okmRKdX1+MTUdP69G?=
 =?us-ascii?Q?g4ofs0ojmUcTWrefbK6HF8q+d7cQskNzd9WNH5HWhoVzLD603j9MHGQA0L8/?=
 =?us-ascii?Q?OlHP6STvR4qSrxIZLKSs3yYeGP/VEkvmqbRdNrLsJP4BAoRbCfa9eOGrBXtD?=
 =?us-ascii?Q?orTmL96exy50UhxcaNb3JbFnVnboHDa5n/PQIBx3/FGe5Txld7tJDxqLhbAC?=
 =?us-ascii?Q?PSFDDM6rFCAiOJpwNRLCaU/rYDseATay5LeP2QLhvRzqM8rh6sbVTpBEqQrt?=
 =?us-ascii?Q?UCvIAkYEtgnUpyjKfDcpwV6V87ZcgwHonaOkoHfwLRpa2d9u/ZftXdDoy0pJ?=
 =?us-ascii?Q?p0W9sxFg+jNpaKa8pkBMUpJ0qFBpdiv9pWLZgU8Z5HKhjjJX0JXX9p0LwPl7?=
 =?us-ascii?Q?/GUBq25CUDl48RBiH5ykxGO3WQdREPwhiaR3hDhbcXKepC/SUIL2o3z352WX?=
 =?us-ascii?Q?7xhfcsK/CeyNjv01RBau+NYYCYTWL2HEkQMMYL9Gds7YbRa1xWQW0QCmXtem?=
 =?us-ascii?Q?kSJ0hmnnpzSIOUhKaxFWNP7HX4kblhR7DkqpeRwcF17ho3LVJrAgwIgpOkcw?=
 =?us-ascii?Q?+lt5ZmNQJWOzPSb+fbNvRaWV3fWH9d6tgzImldu+GGrE1AuKbl7bqXM9hA2b?=
 =?us-ascii?Q?Cj/EkAC1hw1W7rhYi87WQlbavpfNoK0qefmi3kfOAd8e+pjf8AHlvM9ozifW?=
 =?us-ascii?Q?gvrTX8RXz5pSRm6WtONgq2SedJlq5Fv5d7myzEKo8+o3NSAuoZvLRQtZ8f2a?=
 =?us-ascii?Q?2n4ITbdL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd680423-a6c0-4743-6b61-08d8c22103ff
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 17:37:13.1024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v36q3jn3MSHn2Zm2A0qAG0xXWK4DYtb3RylNbtBh74J3V8Qfs0ztEhL2H0PXUfLdn6ScXUPN2GF2HcS3Y+0qSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4153
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
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
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
index 72a79e6019..0415d8a99c 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5987,6 +5987,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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

