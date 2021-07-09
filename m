Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F443C2B0B
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbhGIV7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:59:00 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231133AbhGIV66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLzOgYxx7taE2CgcCkknkMtMYLk7ai98DpagkcBfjati4cdQdAj0B8OW1mZVJ4VgxzA6QUbFtmb18D+X2vsnGovyu6z2rxoDLmWSPCHgzDHhKPCYXGcZtqpQtvS9yRH3W+JI8bkPKXPCPclzOzgjO9fitRBWnXGI4lyyvo6sD7P1UnWRaC0MjnYAIlPiSgcKUFaRaF9a1iS1AmEmXZMjfUVZ3P934ehA5ADSr7Ed/rPuamL5HbF2V+zlfcchMJwbzmFWwflhhxn+RPC4fldLYLtJfzDKbfd9spACHvvXXBXgSGRtY/HTCeK1l940BNRsObmWxCfExLg0RsDIsA26vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS5kgrI8gBb97Fva2W60j49RkiZfbbvK9wWxZ2hB5N0=;
 b=OF9U7b9puLHkndPFtK95iClFALNOmwIMEnaGp59irEkuLUQq3avIvp+JYN1Qa8HEfVdt+KjKYHuPluO9g5h2oLunZSJVUghinWmecQr+N/95/b1txrvFSKzh18c7JmfK6FsQOQGlxyAp8PXmWhFu6Emkvi9rvNU0Ep7Ex0pnTLQkXTIub0z+YHDHdU13PZglviWuliYyaHZdoRfglWjw8FTLIViI3fGEqH9DP1IVg+/Q60wX7/qrfAxe+KKXLYNcoKVUl4VNHNjWPirtMrkMcMdZzRgWHVIekttS7a85rYXNqagKEi2grJ/A0UPRm+uBQaWdaVffzutAQ4dwJepLgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SS5kgrI8gBb97Fva2W60j49RkiZfbbvK9wWxZ2hB5N0=;
 b=wswZhP2yiAvKrDzLHFTokWyT4iLA47Wu2aTjaT3hFsIVhm54faJ1fN8dW3+kwEEJfCDqiI0qE3yK4T9SzWuJV6iAIfZRmBpXQWbiBU11VeHqgsGYxY8och4hXZ/ruq2bNjCt+k0R7pYmQ/DOPdczEDptRN9Sf8qxgWd/qnmWhaM=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4575.namprd12.prod.outlook.com (2603:10b6:806:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Fri, 9 Jul
 2021 21:56:12 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::a8a9:2aac:4fd1:88fa%3]) with mapi id 15.20.4308.022; Fri, 9 Jul 2021
 21:56:12 +0000
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
Subject: [RFC PATCH 4/6] i386/sev: add the SNP launch start context
Date:   Fri,  9 Jul 2021 16:55:48 -0500
Message-Id: <20210709215550.32496-5-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 35fd1136-dac2-4def-46ad-08d943245dc9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4575A7E7472B5DCE37ED821FE5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:208;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vLaFPJHqVWkt3xmLfYF3MpIVv+631upqSd7iuh0CvShhP/lJ7rqHUYlxFCWOgzF53/YfiDyzEAuPGj4seG45LKwUfxBnDMrDXlTCNblcaZVhsyM38Xnj7QoDIBhWtLYpyDgVNvMlb/xM8glcOd4ugIElRMlHz+QDupdeei+9wz0aku5KeZz8ezok4yCedfOXdFItXjmgLIh5JiIWaC4D7dXUREv+ljgtRMTes8kMi4ThobY2d3OoCRPekIjGV2myRsbOlpQwJmg6DW7WMlKUjsa6cXQiLCoeNwC4xHMHT79sUm0eBST962rMPw+770rtryJjWRu6zRu//jZ0q4wrEElltrcr46fb1gcdhG6ySUgShmh0gCfDf0KPf2HqwL5zac3rfKRg5+ciozwOXpOV6TWkXLnaOfEkhHSiLbsFYnqdJe8u8Nql6JQ0ZhWyDAA8oxUd4iB32b3pbvRs+Ysm91WzqjeSyByk8JAPqNJxAkYJKP7MOQLduMgyNtHZthDSdSQVx1RoTTwR2LvDyKoDCIR68neK1N/Zdybh+tDOXQNbrbs9nc6KWj/ZhHZ24jJX43TmaRdVtd6Dg2bmJ23Cd88NRqxkGzuQbxZfdsec5XTudemMMcB7XbBhwiie0kPNjuzAESwF6BBkcOGaAeFoKecCJf5DYzw+qu220tL9zkTsMFW8NdnMyiVidSAHJSWnzQfl1fViqytJCm65fSXjRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(54906003)(478600001)(1076003)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?omKuYw+JW2UfJRIKm2fzRKq2C/kdiMcPaQBekhgAIDwgm9iobJxrWv0iGj3c?=
 =?us-ascii?Q?jBgGs1TqZFp8BFzpE5sb6uHDtD3194K4BNUbVmJ24lSAWHPSJzA0eWGKq0S0?=
 =?us-ascii?Q?Hfc1fs9PAa5uxAQOyBEQBwdw0cHXBc9ceYPn2dwnBmkmMIfvzx7YVzCZvZGs?=
 =?us-ascii?Q?65hlyiamExEc0FsxUNlkg8HMvnWTdQSt+hO4FX+yZ14E5ouE7dIabiKepjEg?=
 =?us-ascii?Q?uzrK/GCmKrbbMt/wM95KqepJQ3eWVr4LF0/aekCaAm3NjyKx7WMjKSs3q/HK?=
 =?us-ascii?Q?x4fpk3U007yTy2yUyLljVTAIpwyJTHMrf0OgVP4NMrCyZBh3coVWxGrUy4kT?=
 =?us-ascii?Q?S5kFwB8ZZhlZ8OU4caIo3/8FwcaFRn6HBxC/sF6TlhQDVX63TPwdqdtYhqtq?=
 =?us-ascii?Q?l1RlTXRVNdnYMQ2XgL8qOzHkk29Asmb4f66ov1V1yJ8X6rtatE8iKYyHY8b9?=
 =?us-ascii?Q?4aZ7lMUbjZE7h5FGHp3xZfNEXk2OX4QWPjTMx/gC7c6V5hC8IWjD4ZUnES89?=
 =?us-ascii?Q?LeIVfBBHV49gG8K+p5FfFArL+2Nk/DCLFgC2vZjOl3xmQG2npZgfDw3QKzrB?=
 =?us-ascii?Q?b5P/OZQ2WNX/RhZCeSdf2rJD3rFNe8qDBbsBz7FXe6H2+UEdylp6g3ozuC4D?=
 =?us-ascii?Q?zjNEbBD05iWtlXURaxuRjUeX1u+/YTDZSG9XfoLZL2gqVvZ182EnU2bnIWir?=
 =?us-ascii?Q?MBT3zebgheDT/GThXFuP8bsIt8TqMLV2xgq7Qo79wAoxj3nES/bG3Hpl+TTc?=
 =?us-ascii?Q?QHLN5SUHd5wCdtmk2VyvbnEQap8E7ejaH4Nz7NZZL47uQkkGEstk5g6S2t0u?=
 =?us-ascii?Q?qfmYYQ+aI+EwQbyFpdFBDaeJUdlwt/KzaCRwWo34HsxAHIjD7Be9xaY7TvPX?=
 =?us-ascii?Q?zPyazO/DuYwxn99GTritNGSrkVNpXhUdhtOuDCvKC4wayi1bDjyRrbHXqvf1?=
 =?us-ascii?Q?+r9MQIAwqr99X4ebOFCwibMrArZd4+s+recZseBrdIRaYLAY+NmT/nhgeQbB?=
 =?us-ascii?Q?w38MuE8wxndaFGqR+DlD8pNqnQIPy5mmLI6/I/9xOy8sX1ZybsIQeH9xIG6g?=
 =?us-ascii?Q?ZGtZs7k473ZZyy8/S30hR4ebWOm2Gic9P4N4uYqNjr0QyCM/C94WvpkHMUSQ?=
 =?us-ascii?Q?ywJm3jrPuOYVPtWjbw9nTGrZPMtlVDOBbZK+wVoqYFFRIpkExNBPWu5CpBFj?=
 =?us-ascii?Q?BVTag6aXfsnI+0bnvZBkbXjkvZ1o2CeCCMCec6JXWmsLSykUISO8AikNJDRi?=
 =?us-ascii?Q?P/Z0MrAKY2LA42F7rRgXPFU6A4ADismGeN9tg41FEfw7czfq3/d4ktwml3Oq?=
 =?us-ascii?Q?7FM3ySuOl9WwUXzoKN9Wwr/f?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35fd1136-dac2-4def-46ad-08d943245dc9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:12.2610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LP3G8LG2TyVHnSqA9mdHCDi3/SyXvpiXbXI7fZ5EnV6Oo0BRlPlM5UjMZrdGwe1YqI9XaLvmsx1aXeo00Aa+0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SNP_LAUNCH_START is called first to create a cryptographic launch
context within the firmware.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 target/i386/sev.c        | 30 +++++++++++++++++++++++++++++-
 target/i386/trace-events |  1 +
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 84ae244af0..259408a8f1 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -812,6 +812,29 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
     return 0;
 }
 
+static int
+sev_snp_launch_start(SevGuestState *sev)
+{
+    int ret = 1;
+    int fw_error, rc;
+    struct kvm_sev_snp_launch_start *start = &sev->snp_config.start;
+
+    trace_kvm_sev_snp_launch_start(start->policy);
+
+    rc = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_START, start, &fw_error);
+    if (rc < 0) {
+        error_report("%s: SNP_LAUNCH_START ret=%d fw_error=%d '%s'",
+                __func__, ret, fw_error, fw_error_to_str(fw_error));
+        goto out;
+    }
+
+    sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
+    ret = 0;
+
+out:
+    return ret;
+}
+
 static int
 sev_launch_start(SevGuestState *sev)
 {
@@ -1105,7 +1128,12 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    ret = sev_launch_start(sev);
+    if (sev_snp_enabled()) {
+        ret = sev_snp_launch_start(sev);
+    } else {
+        ret = sev_launch_start(sev);
+    }
+
     if (ret) {
         error_setg(errp, "%s: failed to create encryption context", __func__);
         goto err;
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 2cd8726eeb..18cc14b956 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -11,3 +11,4 @@ kvm_sev_launch_measurement(const char *value) "data %s"
 kvm_sev_launch_finish(void) ""
 kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa 0x%" PRIx64 " hva 0x%" PRIx64 " data 0x%" PRIx64 " len %d"
 kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
+kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
-- 
2.17.1

