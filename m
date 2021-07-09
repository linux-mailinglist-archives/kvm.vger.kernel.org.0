Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FBF3C2B0C
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhGIV7B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:59:01 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231181AbhGIV66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJoeZsIWPdDY8V0JQMk5H7F3XZAj1QCyVuUTdxa4dTjZpU0VGXzbh0YnT/PoGhGFgRf0ZOxDUeODyd2gCC02/kXFLyFiWztkDaFQT/E41Te+2ugyKgFj5KkT5Vwq+f1zZ9QOBvabnXqyN7rwcE4EJeHwSa8SYQqR8kojx6SL/T7WiLtSgF/XcwSFvUcT7QXIeABaJi3cPMvhtejrh1g4zL0kdm7DSaeVjL0ZOrj+zOWRBvbZjVJMrOPwgEdJb7TYfEQO+twzKFFvnfPMXeOYGMy67d+he1RrwWh2XrkOBlF44i1NdHtclfdthOZfma7CLnyv7mYwlzd/53NCvqVdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/Vie47PxRPlWdAkPdp5i3FY8mj0catEPt6gPEFGvxQ=;
 b=lCVB7bQJMYL1nsp1cHu6sqWA8010vMmOK9T7x8OzCtisVWnh5Yn+xmSMz+kGtgN4CaIjpV05AwFigzhT+IYMdLIBp2wYT51SARtzZUQfM+//IqLK3j4a5HKSw2MZXhmOJbdte3dZifh5Amm5EMDmhndEz/a2nicrHnBhPZ6zVGIC/vYrW2UMokdOEEaFM/zediGFupPhc9NfOhFL+JXpBgG1nev1pmje9cQbJTBwlt1t7zoEuRwWVgz5ogqEmeg9v6IQsmjXaoy5wTa3blQhG7JOYDYNCJAET6Pmb+77OiIZb++KHh4FcM742TBV2gt+CrCrMPxSG8KmFh4MmcrRkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7/Vie47PxRPlWdAkPdp5i3FY8mj0catEPt6gPEFGvxQ=;
 b=WdBSBy/b1D3RLdhyeZGlqsXYZwGWUzTFfmTpoTirvIA3ozoreHebgajmpf12sOGSVA2piWpRglvPT0zXdhHq5/S7JYYbROvCO75v3uDsvlHSqkRc67jQJ6niMMeWj4UcM3V2/dF9ASvsko+sI9rtqrUCObTsXyO/xruYb89JPEQ=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 21:56:13 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.022; Fri, 9 Jul 2021
 21:56:13 +0000
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
Subject: [RFC PATCH 5/6] i386/sev: add support to encrypt BIOS when SEV-SNP is enabled
Date:   Fri,  9 Jul 2021 16:55:49 -0500
Message-Id: <20210709215550.32496-6-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709215550.32496-1-brijesh.singh@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 21:56:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e8adfde-3b26-4af2-f056-08d943245e3d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45755B7AF7BD14A72E7107B7E5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IFCTxhTSmM3FU8ZeLndUEdxS8ex8xNUS0FObjaZzFdlIoqPg/7vj+HONHgzxXxT5oYsn8snS2ZxCw1+Qkxa92jlEdYVUxnIxp1x3MVC9YwRgNzZhAXV2gDanAr7SmagJit3m1Obk5ClkJEGr6B7++ZRiTM5TVRNrLK8sv9T6o8ffdCV42CzITBeFsFMjljNQKErUtsNeq2IMDoDw0GS/IHlLsky/jzGtB6G9529iSjxRRfM/oa/UECtqF+4m9hpMKMspNHMxyE9Y8VmY7K7gG1dg8xEaLaFQWnvDDc03Fv6i8mqmXPf1UB7Wm9bffnfg94hlDVTphkLadsmBHVXMuMMZo6yILu2bAVOdlHiKVWNxXCx8PXHfEp759uUDVslaF6CSj+Gy8s/zBgurVF+auoQh1QLEumA0PhiUZXfHOpjd3xz4h4Oi5nc5vl2NGJJBbf2wZ/PdhNnF+n22wtbd9hpM+QXokDQQbkgT5c+uCJWDtDc3oCs6LilcyjGWx1GRB3cLdxC5BKNu+QP1AjxvB4PtnK9RURdkcufDvt3T9X7unnoPJWaijNx4x/QYaERwXw/tF59jrJcgaUuY3mkkhqQKJbn+6nogvFb6lY2GSee4YZKRS1ljnD9VYAO9tUhwXPwgCkTT7y5srRefIFR4pwScojSsqZQDrCwT4vIgtbManLxT63z0OHarMMeX0of2u9e/DTJkfnIbywa00d+n6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(54906003)(478600001)(1076003)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?F6swLJEP6P+OVH9IoJ2TGagV8Gnk32sn+8iqRKh4tTIKtCC2c4BmCkMee4ll?=
 =?us-ascii?Q?4FD/o8+/GyqO4wlNQmL7Ajxg7bWbDhYQEkXPDavfzP7tlc+W+NjuotS2NSSj?=
 =?us-ascii?Q?8ELfZ5AVVseANpJeyt+tdGYHs+x2rcJKOcN9hOUn8Ah5ZZfJAjo09PSHgqvH?=
 =?us-ascii?Q?vrLEd7EnCn42CR+qHK06GF6CwnMO8gzXDmkVyrAWwKDdJpxEEefrI2bQrIJK?=
 =?us-ascii?Q?2ULPtN1utUeDruPVkRauuq7X0iVwe8gLNhXVjlD6EnoC2E5faB6Wxj+5koZe?=
 =?us-ascii?Q?k7dMKbIulOx1BHi2v8KtL57brMYh3rtgLrK7OONWSDJ8Kd5zBi+Dq/hfA6JU?=
 =?us-ascii?Q?dOyidktuPV8XEmYU8GkLCmvEgPZ1Ss7Lzt1mQbMdEqzdS2vlgW24ojSyrU47?=
 =?us-ascii?Q?zxbd7qFK1/Izt9kwHIf6OVN9thgcdCxjtoiaTEbV0VTh5NuxgCMhwxfX+UcE?=
 =?us-ascii?Q?3xiHWfm46FGOHQDTZLN2bDg0a2KxbFd1Nj8EM0BN6oflDzwyvYwijXs6P+FX?=
 =?us-ascii?Q?w3wZpRYNXP7fCMMQDdDOsoUJ1MWVjZCg53dyTBb1csdme6RlS61TuMKiz2eQ?=
 =?us-ascii?Q?9jc71XX72zLL+sJPMABjiMZyMTKcgJSqGaK18busmmyDlqxoCWuOzDqtpLAj?=
 =?us-ascii?Q?YgeramrsWvh2CGc00PBlkr+I0GeMkuA1DBy2wH9sr1x0G5O92Jw5fStu3dxP?=
 =?us-ascii?Q?3mbW5bbW+w1iYsCyQNwrC4JQU1bRXq1R+IU5lPGC2KLLQxem4uFXiKtwi7e0?=
 =?us-ascii?Q?YlqChlMPSV1IQgwJG3YlKbXAM+mIzpJJNSE8ocqh9SNwXY/hnuX6jh0Y9bfo?=
 =?us-ascii?Q?NAtp6KhmpjBTlTr9wcCSoiPgIY1S4RyCnj8GxauSh8p4+NH/KksI+XD9Vez4?=
 =?us-ascii?Q?wJWeByDtyOXWqvAIfb1X2Ah7C9uhd2qiMFPIWNPpfpJX9hvGVF1FnI/BHdgo?=
 =?us-ascii?Q?nC1dqx1FfcSJvdK3pZmagIow7jNdIs9S/uAsEJN2FHxSAadp+UahQ1tHB1XZ?=
 =?us-ascii?Q?BhfL4NDqCV8ee+GSA8Nqqi9I7lmLaeFicA82vC/MhBv3XoK0vkfuoGMJfsO1?=
 =?us-ascii?Q?TOK+hf/y1Fgf1wcB+VuUqjeOX5IZT3s8RmBLsRRPw4ER/7bdgq7qDQdlQhAp?=
 =?us-ascii?Q?0efdOZWD5JLHirReoqwHiC9SKLzXNtMdhEke1U1IpauFjTbf6QdfuuPU36GU?=
 =?us-ascii?Q?U69/VZJ10dkH/eFvoX21ePrpd9KkNKAEtBFVsTi6Rn2aJTByvIjyz3NXLU0C?=
 =?us-ascii?Q?8uJCztwBpTVdWPCU0JMidAutT/RZcTVEYVegO/7okHyeP3JHQSul6ZBghXhk?=
 =?us-ascii?Q?jPNUZxBBQM0gsr0t0OszK3ot?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8adfde-3b26-4af2-f056-08d943245e3d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:12.9886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pjcLUpoqjuxY5A/+2RqGnQxbzO/piiFLmHO4cxE/ECZ+ido4Y9/5X4dxIdpUOZgyHPwNS/8zi+nreD8bK9BOCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_UPDATE command is used for encrypting the bios
image used for booting the SEV-SNP guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 target/i386/sev.c        | 33 ++++++++++++++++++++++++++++++++-
 target/i386/trace-events |  1 +
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 259408a8f1..41dcb084d1 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -883,6 +883,30 @@ out:
     return ret;
 }
 
+static int
+sev_snp_launch_update(SevGuestState *sev, uint8_t *addr, uint64_t len, int type)
+{
+    int ret, fw_error;
+    struct kvm_sev_snp_launch_update update = {};
+
+    if (!addr || !len) {
+        return 1;
+    }
+
+    update.uaddr = (__u64)(unsigned long)addr;
+    update.len = len;
+    update.page_type = type;
+    trace_kvm_sev_snp_launch_update(addr, len, type);
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_UPDATE,
+                    &update, &fw_error);
+    if (ret) {
+        error_report("%s: SNP_LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
+                __func__, ret, fw_error, fw_error_to_str(fw_error));
+    }
+
+    return ret;
+}
+
 static int
 sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
 {
@@ -1161,7 +1185,14 @@ sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 
     /* if SEV is in update state then encrypt the data else do nothing */
     if (sev_check_state(sev_guest, SEV_STATE_LAUNCH_UPDATE)) {
-        int ret = sev_launch_update_data(sev_guest, ptr, len);
+        int ret;
+
+        if (sev_snp_enabled()) {
+            ret = sev_snp_launch_update(sev_guest, ptr, len,
+                                        KVM_SEV_SNP_PAGE_TYPE_NORMAL);
+        } else {
+            ret = sev_launch_update_data(sev_guest, ptr, len);
+        }
         if (ret < 0) {
             error_setg(errp, "failed to encrypt pflash rom");
             return ret;
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 18cc14b956..0c2d250206 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -12,3 +12,4 @@ kvm_sev_launch_finish(void) ""
 kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
 kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
 kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
+kvm_sev_snp_launch_update(void *addr, uint64_t len, int type) "addr %p len 0x%" PRIx64 " type %d"
-- 
2.17.1

