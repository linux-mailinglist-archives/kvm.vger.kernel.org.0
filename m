Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403463C2B0A
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhGIV67 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:58:59 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230526AbhGIV65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pu6o+ZobULeCNAUJZvxSlq0KUEQW3n4GhGaM20LgXTPmJpNMXdnbbhgGLuqVWZq0YqTQSVz9t/daBpVDxIdqqWLrG271BsVBDnP7XUNVIznxWFhb4zHlE3CzGCj3pnAxLRssOQX9bCADkmojMzFbktAUVAvstmz5Z8NVqTTsZMCpH04k4BlLB9RVjPuD8KijfxJdCuhNuA7dKDwX+ydDxhvPD84+H+xCeqeGQDIai51UtF83aeMK6YTkjXWcPHRM4Kmd993aFGeS76YVcRy16rMcPKKvllgRRpJVJMFdM4dZWotBcEKqEuPDHpcOAS3XfWDnCb88JLzVhBr+g2xs4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cy37rgKPFXduWgu6fvACrKP6ieipd51K57Wju9q/1L4=;
 b=K7wzyIaXd4quJbFszsLBOY6nP1snBxt8SSHbUeKF6dm0Gw+N6IKH0VSDXrb57tk+e0cUznABfQ+jfMAEVyLgguvvo224SYW497F1eXHTeqX99bNcDzWngOHTwOTh21TW7TlKusctbQTuEFYpWLx6QcfCt9CMUJC21UjZt/ZJdI2N44S458HDK+dlXOHLnhFdOe2hmPbP9gXdMyRhVNPOcMbngc9YBRV+wS300BsdAnrdWbfiOz6XAv552hK6wA0XkzKodhmCf4cO08iCY9IPthFj2HiyA/mFk3vaMz+Y+YHdCdSGqDL3BYnlPvGmvVE081gngQdQ41yzI/0xZ0Wppg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cy37rgKPFXduWgu6fvACrKP6ieipd51K57Wju9q/1L4=;
 b=qWv22JPEHmXthiUdHi4yl2WJAoeF9Y8BWP3Si5+aXBHDVq+gE8Dd8luE5m37MjeFY5E0GOi1q++M3LFRawms999oWvSs679acb5NUm32oN82TycELuYMv2D4nA3ORlYfbSKWl/elmIgYCQVc4qB6u+fODAXgQzD27C85G4nCsA0=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 21:56:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.022; Fri, 9 Jul 2021
 21:56:11 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH 3/6] i386/sev: initialize SNP context
Date:   Fri,  9 Jul 2021 16:55:47 -0500
Message-Id: <20210709215550.32496-4-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709215550.32496-1-brijesh.singh@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 21:56:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 899c9154-571b-4f82-1a74-08d943245d5a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45753BF85B711C0C94ADAC9FE5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:813;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HsnxluPV1JkHLE5kpAWBfIutehHv6ypiGqKFd5T7w29m3HoL58JomMSemIWDupDEaXfIxAWRYFEKiH9YUrWfoSeik7w8s1sNTlQ8mIrrIjOcs+FWUWXQmlgxy5gcSuRlPIq4bM70h+vM6UAsrzI9jW3BTHQ7/83gVcTkqY2gkcOAgmeVPdfCzEGhYq9xZyP+5EQmcbsnkwU42fLwwCBqLniMeNmxQQ8fx4lXBujLU2qgzky74W4p1JDQQwC7Ii6rb6KOk1XMJilbrbHZ6jNlRjFMAUVt3XfWum9v34w/bn3m2Mi/Jx67L6HeHLmIPBg8r20AC0K/YSLXWXJkZQ1oc2htMIrjQjsARmTM1pM2L8Pq61Juazq+giP5+XE9b9k6PU5apXS1uxVU8LYq7Qb6nXR0Z3X3mJ9ibRuFZaY2iyItcWd7AgNLCYtI5YJVNY6cIa3c6+ub2a2Vfv1odm2VX09+ooaN3d055X9M9C6g9dwSKRrcNo+DtMCFltnbsS8m8vC7NKjb+IRPupY9S1wfisqTWuj88/iNfus4KeQ/tlPINJUD9sekDntDKC/EtnYYWR1AOBkSIS1xX17d6ElWObWYRM/Gnipp7mO3m2/k6d1XHsW+XaZHXB5F+8gBHsmpItsUGWsWzJbvXg0OTdC59kWiJNHYuCxWPe2iVec31eQRng5+V0rhJdnLuewg+9V/OJBiWqYTTBGP344inMbfyOMzgMPh15fFLh8Kfe7k26Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(54906003)(478600001)(1076003)(26005)(7416002)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AXWwuk+ZhJP64RJ9joSIIAr56L8tdR3uQfikxBh/yw3HzbtrkE5fL5LdFx8y?=
 =?us-ascii?Q?oxyYzSLZD2INsBLFU0poNifQzXdHNJZf1ppVp6Sb7XaAuu6Ny8StsdX9g8BM?=
 =?us-ascii?Q?j9igvjpsUk14ULxueTrym8FKyYVGKVrMCOZ6EHSgc+m9B22Fg8zX66JwnxbQ?=
 =?us-ascii?Q?wuORzdokYGY+pw8myD9GKxD9EXdkWlMf72B5pbHNUbdBn/Pugwl+LSV1suio?=
 =?us-ascii?Q?G9BFlFJ1rb0tq2dfWWXYvINGP04sF2XUctBxYIMjxrhqZvxmDH1F+HYAuo8A?=
 =?us-ascii?Q?z7FAKCBHt8sJ6GMgrYCDA+yB1Pg4REuFVBNAC9wfWVoozjdC4D6c/Cd01iCY?=
 =?us-ascii?Q?nAJCQ60qrr3pRAb/yUJK6z6N6z2mymzoJt2ystJUQq/ZGaefnWbIS3lNGPbd?=
 =?us-ascii?Q?syoX4Ba8nVP4tvlunOuuLPxRT6awHbKtflBpRtAX1gSeFPDttnwZZnvVmPAR?=
 =?us-ascii?Q?Z4SjRvhVEIdp6sUxkC8QGRFWCQhjdmE5doJ4fsL3fePhn+ngcDVaHuKKHSxG?=
 =?us-ascii?Q?WBhRyGDgWtQprBLmsGeeSA3+VjQPdWt5ZWHcGsbJIez5BBDDI1b+zDBlMiIV?=
 =?us-ascii?Q?HWmViP17UFB999HbNMt+U5mYfwfAdK/8AIui27cUw5qxSOUzmcYI1oTanUUe?=
 =?us-ascii?Q?EzvpvrVh9L+Vq0bK0H6Wu2ptEPlb/Mz2dd7QkqROuZj3eCRkoe5ChkxFv3wo?=
 =?us-ascii?Q?wuxzxhps0Iflf1joJoMle5ykLIbB0XbyVa2zCIbGz2ZK7xyaYsc+T9WgNy+Q?=
 =?us-ascii?Q?ktfjtOwGqWU8/KShdMtsMGXvKG1itsLBfjj12vDGbZ0Z3V96rzQQD9tATPhG?=
 =?us-ascii?Q?NbNUVuT2pn1X71pL4prumg0fs/TdWQ+m9c6d6q4Jiv6lCyzW/qHrNk3CMLl4?=
 =?us-ascii?Q?8P4vJzSQqrEDc2qzBiMGrN6hbjAKK1z9u40CQEyFSJlyJVzzAEBaYbn7OeVc?=
 =?us-ascii?Q?Z1B2pdq63BK0PaTh16YJbDnQ8B2F5HB0axV3Mzj31o3QCeeuVmdL9JVmbFgC?=
 =?us-ascii?Q?P1Zb2seGE4c9TvNMoVmdxHUtmk4Xnz+sAq73AN6bEvJq3kYB+UDBwzIM/Ddw?=
 =?us-ascii?Q?aJnsw4+rc3lfUL92R0rvgdNUf82/QgcXFk37oc7H8LhKYJE9FnXqRGds17zj?=
 =?us-ascii?Q?Mj7vY2roGB24RfHepJK3JjCDj9ynTQOiA/Y3/NycoDl7IMhx4b+ThrKyDjei?=
 =?us-ascii?Q?cEGXJZRzXH89OsyPs8uTLWQUbf5HoF0jR3GQCvY0mt2ajxXIwa2LFamjI7e+?=
 =?us-ascii?Q?uKR6Zea+586MW9wJceU9PL0Y2KYa3FvW+Y8mLAIMTBHY4rJFc+NTxtHyg744?=
 =?us-ascii?Q?fTOHsE6bnDSQN9ojc15D3xFN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 899c9154-571b-4f82-1a74-08d943245d5a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:11.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFRwfhR8Nboe6mdrZ1v9ERWKARBdRcB7rENqQ7pSytmi2Vy//unpzchIgANDcaH5pFuC6V2pcI/rXliOPJJORg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled, the KVM_SNP_INIT command is used to initialize
the platform. The command checks whether SNP is enabled in the KVM, if
enabled then it allocate a new ASID from the SNP pool and calls the
firmware to initialize the all the resources.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 target/i386/sev.c      | 24 +++++++++++++++++++++---
 target/i386/sev_i386.h |  1 +
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 6b238ef969..84ae244af0 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -583,10 +583,17 @@ sev_enabled(void)
     return !!sev_guest;
 }
 
+bool
+sev_snp_enabled(void)
+{
+    return sev_guest->snp;
+}
+
 bool
 sev_es_enabled(void)
 {
-    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
+    return sev_snp_enabled() ||
+           (sev_enabled() && (sev_guest->policy & SEV_POLICY_ES));
 }
 
 uint64_t
@@ -1008,6 +1015,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    void *init_args = NULL;
 
     if (!sev) {
         return 0;
@@ -1061,7 +1069,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     sev->api_major = status.api_major;
     sev->api_minor = status.api_minor;
 
-    if (sev_es_enabled()) {
+    if (sev_snp_enabled()) {
+        if (!kvm_kernel_irqchip_allowed()) {
+            error_report("%s: SEV-SNP guests require in-kernel irqchip support",
+                         __func__);
+            goto err;
+        }
+
+        cmd = KVM_SEV_SNP_INIT;
+        init_args = (void *)&sev->snp_config.init;
+
+    } else if (sev_es_enabled()) {
         if (!kvm_kernel_irqchip_allowed()) {
             error_report("%s: SEV-ES guests require in-kernel irqchip support",
                          __func__);
@@ -1080,7 +1098,7 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
+    ret = sev_ioctl(sev->sev_fd, cmd, init_args, &fw_error);
     if (ret) {
         error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
                    __func__, ret, fw_error, fw_error_to_str(fw_error));
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index ae6d840478..e0e1a599be 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -29,6 +29,7 @@
 #define SEV_POLICY_SEV          0x20
 
 extern bool sev_es_enabled(void);
+extern bool sev_snp_enabled(void);
 extern uint64_t sev_get_me_mask(void);
 extern SevInfo *sev_get_info(void);
 extern uint32_t sev_get_cbit_position(void);
-- 
2.17.1

