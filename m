Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA8251F7E
	for <lists+kvm@lfdr.de>; Tue, 25 Aug 2020 21:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726556AbgHYTGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Aug 2020 15:06:11 -0400
Received: from mail-co1nam11on2079.outbound.protection.outlook.com ([40.107.220.79]:49711
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbgHYTGJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Aug 2020 15:06:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNTUSg/BzxrQJeQN1Lk0yWyn1flm6UQuwvT+YtlKEkKqJVDXB3sKTvULP7DwIIvx7ZHDybGTF7b1AG/YBkvhGPVq1MUidIu5JtrIvGGD8gjzS8xK3+94e4tVspUrxGEE4KRezcgvSEyNjmZmLXngAM1mJ60kpPoFvd7j7Ct4BQ9r/sj4mkpdqWoMQHv6xt4VB94TPwBYzCnTdzh645mSG9pBmn4DsWy+7GiT9MFNTWjjQr+1lfBGOY4X3hnAW361PurD1xdf911lJpW9VX/eZJn17Gudafj6oE0thqeZ4j5mVlzWOnXT6amGqRsu+sr07VPDmV0GL/bcW1XxNBoqkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+BpJng5csN/LA+I/qcPQkYM/tISIORmRx+LOYMnks=;
 b=DEV843dJZ+BpWDH+gOM/8Io6mBBUm7EKKcCObNRwnOkNxG4VXfTnfH12V/rrkbbnRqTQ1hCQ+3vCGM7GSq0RMxNwJgVb7KVWNLRCwuAWr+vCgzDq2L8yxIIoX/uNXBJCs1EgxMg3HxhRJ7GYyqk6Nfnoibpumx7w5WyvU9YPJQeC3o65BUDtOgeuuFIR/lhRAZcB2tcQibmRtwxV2mbwwVuD1LzQMDKlReDiOsTcEihk1FPebmoXJ/exkecxlHpH3EfoLz8IUMet1wPl8GpJX/0sKr9cXrEAajP15/Ig4giorT1+CjQNI22EB+iP4mSfx7XZR8EMvXmz37Md+zR1mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJ+BpJng5csN/LA+I/qcPQkYM/tISIORmRx+LOYMnks=;
 b=M82Qy+3a5osu+M9iWrXfWqCt4Q6ovsq/0fY57AimJmUc45CHCL2+EqLxJGArbzRQF52vABdFVPBzhdMNPHKvugfitsqfQ/cmw3y3ZxebeS9JNpgoNCfCz8O5HWGM2hCzQvCOn0wPAE1XcsamneEG1H3Whockj4xdMTQQQy+0UBM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0219.namprd12.prod.outlook.com (2603:10b6:4:56::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3305.25; Tue, 25 Aug 2020 19:06:06 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 19:06:06 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>
Subject: [PATCH 1/4] sev/i386: Add initial support for SEV-ES
Date:   Tue, 25 Aug 2020 14:05:40 -0500
Message-Id: <88dc46aaedd17a3509d7546a622a9754dad895cb.1598382343.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1598382343.git.thomas.lendacky@amd.com>
References: <cover.1598382343.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:3:103::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by DM5PR12CA0056.namprd12.prod.outlook.com (2603:10b6:3:103::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Tue, 25 Aug 2020 19:06:05 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ddc2d9c-82a0-433d-cdcc-08d84929eb1c
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0219:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02194578774DFC92EFC06EDCEC570@DM5PR1201MB0219.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2043;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DkWYuh3DAgGbkwvY6N0zDEGGnLrPTiyttB/aPom7rWNyU6KhXoCa+JES7AlQzbwpzX9CB4FtARrf37o57ANQtO648QaPdyhzw7kbzy+olcSh1Rju2lpQwzDxrf7PlTWuytO7krX68r+7zMHGx8dpQ4Jf6sihgFBboZW3MMzThwiaMn5tK/7yaHeEgCKPD58j4Msg9z+XTbgi9uy2jFS/dZ6/ra5U5HYWEPQIF/Lm+KFjDyVRSZv4DCb+1l987Od8VFTRs/STRoQI+FfEpkroRBuxQGtuVXm48fhQld1uYYAEusMNSq00BYAecSpn4ru2GCbDINHYBp4EsPM73bBiAxva7ygdFgVBEePoSxQhqkgxz7i+YnRJL3ZuJCPW4Xet3iALUsA3K+kpThZsjLaCpRqHK8rpm8KkGKPxJm4eqn8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(4326008)(186003)(86362001)(8676002)(83380400001)(54906003)(16576012)(8936002)(6486002)(316002)(478600001)(36756003)(52116002)(26005)(6666004)(66556008)(2616005)(66476007)(66946007)(956004)(2906002)(5660300002)(136400200001)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p7myolQbTVCGy+rCIbIy9j9eW4HKvjP0mF9pvwIJ0vIAI7rjWGvlwYeNraOpydLV6YdigRW34S15Z02gFF3np6IASPUPrhB3myGJypURXtQanDErxeA2tPpGO6X/8leH3/yAaMZWT3bviziLv2nAB36etu2ocv9eP0ebCxhvhRLoeccTIaYaZK5P+k2vSfMz9I1EigeQnH1hErw6NNaSAkU2rmNK8OZqNXwI4f0JOPJRioXX/w94NsXvOUqssy/IY5CsqsNG8HUJOy2pBeY7/N8dcJi4xB1RmLbGneBkwipWFSFpDJBIzHRiK5DAkh2RT+7Ki8zFT6oSZGkszLcQE5+LipGb0l2+hH6zKCKoSXM9wmWdQWpa7LJLbW8nLXi/sckD6gyN3ruMLAlMDyhm1uXxPnWl3OWjodAK1U0v0xtpwoB9Dxu6DYziEn91N8YOvii38PD7EtxMg2hoGyWmtwDK29CzCtm9SJ6SBbKQFwS4FMP/vv1AFAUINU0gJt4/ZlTw5Z5nPVE4NH2fVuAzxdMcgezlP0m1HMJmCXEDDurcllYA/AvllReLMlD2WB+SN8TA27970wPC3GYzprq5bTP9Y0G2Ze6RC8JVcFDpFfzWrpuhGsJs1IP4tF2lfY8TbR5tU48WmpXqN+E3cFYr0Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddc2d9c-82a0-433d-cdcc-08d84929eb1c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 19:06:06.2874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8XaMQylx0Z9UlituBiJIcmFv2XuzITUrNwiRXmh2Jqu24apH7ziFH2W4KQvyZO1ifj4m9tbCw8LpJcpdDebCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0219
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

