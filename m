Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB733F90BA
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243803AbhHZW2N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:13 -0400
Received: from mail-bn8nam12hn2202.outbound.protection.outlook.com ([52.100.165.202]:49841
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243809AbhHZW2M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4rioBrvZYvLA4gN5pZmwnvgxRUijVm/Y0N268ZYy7iHvDp94/BvNtKYIEdpW1vczrF1tQORIVlAkwyNStevV5UDnYYvWCgu05+MXuyxyaEuzOe4fzG/1RntOBuLPCTI6lbcLpPSZe0FvXDaHe45aL+fye4f/p8HxZdfOZni3Q+Na+WB/VVqadcjCW5m5RzjNnys20onZmPuAd6OHGdp4uxsKHETG650lz6O/FS6m3vRM8BBut2592uzBAfyC3c/gVlGf885HE4DxWtPZ7yUy/WmUcgz+wGXtyWIqhaCQ9wmZOTj9WQw3F2PbwRN1VIpfIdKjfUlnPvfOfskckJLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjJvoPFWhDmiaCLBg0LOzFdUkaf1IvaS55eMyY66ytk=;
 b=WBy6gtOa1SBmluwA7vLVrTmwJM5iSthpT4SXa7ykp+aDeesVzRqFXi4afNocrdkuk/3C0+K3IYEBd0hq2u99UWsb0BC8TJT8+9Mm5tP677GXDF6kIwlv4v52dkziBV28meOGqeTmwiuhgOv/Twoqw6F4DUD4hfOGZu2kssoP9KTIBSeV7ULmNv4gpvXJVo/SwF0yzACoaeCUHoFgqAoWZUPxFtPI2VdVoCywetsA3i2K8nO9y5/xiImExToEGndsPrW9c+f085UZsCjzEXa02FvXb2fXRlNNlHVUKHpKGpBDM+C3smYEpiFYRjpwu8M6Cn/KeMAF0jiPqX/TWbsOzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjJvoPFWhDmiaCLBg0LOzFdUkaf1IvaS55eMyY66ytk=;
 b=oriKxKGzk/l+PnMtYSslrRJPBe+kcSOzmrqqMAUMRL2newgZf+4nXAUjE1XXizNEmXkg/kxPObD8GR0tqEGJ1xrdvip4/q4Qk6GD7SlRPkIWBdnA82k9As0h5GuGGgB+Y9bb/KOZdfFyCqTbuHGFdsXNMYOS+GOpjEel7HH+UXc=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:23 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:23 +0000
From:   Michael Roth <michael.roth@amd.com>
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
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 05/12] i386/sev: add the SNP launch start context
Date:   Thu, 26 Aug 2021 17:26:20 -0500
Message-Id: <20210826222627.3556-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9P221CA0017.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::22) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA9P221CA0017.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 26 Aug 2021 22:27:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9b19e41-cd6f-48ad-6cc4-08d968e0acf1
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39254DE6D32CCD57A396812295C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:208;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pd8BhcIR53efWglYYhb6lqUAoMMQ8IfHZp+R63sLWKntsHFG2LPu0X/HXiRR?=
 =?us-ascii?Q?+l3B92ZyW8mEMKFJ3+wwczQu3w4JBkOyx3olaOy7ZC1HWMYljMebr57HYm1l?=
 =?us-ascii?Q?4ZrDW6gGOAGVMjZWfm/HhhUpMMbBnzYtNLEe+BrIGE+5wU7QUxoDazrMimKl?=
 =?us-ascii?Q?9PW1RN5XruosbJ4fm6a91RMAHaiBurxbJNI9g/O287w5lulwObHrDEpzvjeu?=
 =?us-ascii?Q?Fi9hFyBCEucNEAjzufJcpDw84sPcplRUfAUntq6g/D4/ka1QobAkJOK6sTWS?=
 =?us-ascii?Q?qa9Yp5TcfFEyJq1hKg9DpJead+LZPidDEf2I4ff4z54m/wo3S7OgAlLU13GY?=
 =?us-ascii?Q?nUBiyZY4DSl1lEOanMxV7l5Iehw9cIzXPIT39yYLoteqiumrB31M/LJxzcL2?=
 =?us-ascii?Q?nFRWwue5FvI1GzVHADnHEpkJKbV5ElkaW53vfdbTUYiOmmxXf0v5DQrXMjVm?=
 =?us-ascii?Q?Wu2oS1SIC1L1wLMyDDnta9CLUYHy+EyDxgj83zmnuf5LrOFpLossxMq5OfQH?=
 =?us-ascii?Q?SkrrP/iSKLqe/EqZQGpnOz+ZecxzEVz9J0Kk6ZBOTJum1XR7DjDYNr2rffAK?=
 =?us-ascii?Q?U+NCzq/AMDe285OYc1ip9amZq2NuopZd5AllgsUaF+zCzvkwAA0NvcgBBES/?=
 =?us-ascii?Q?dfzWaoH1pk5YfS11tVZm0+mh0cen5ILJal1fnf7Nh3dnXh1XyXDadIbhGcEV?=
 =?us-ascii?Q?Hjzf2Ofqk/K5i/wvtEAlRqYdDJ1p4fd/K6a7s9JN5Z9dtXnNF3gaSiywE2v0?=
 =?us-ascii?Q?KpIE8hR2SRchMbJ3sidW2oD+p+6zjInRP0nUFWOZtm64U7myGHISynVHpvm/?=
 =?us-ascii?Q?3hVsS2Hax+Rmv+sbZhH7IGDc01uS4IDDtDPcXpNKCQzPmc5gw2XZ9G5/Cy7o?=
 =?us-ascii?Q?B9ibIitu7JaaOxW6rrib49iCUKYoKmqKFklNmoSsdWXMSvZlpAoEapKodoe8?=
 =?us-ascii?Q?126R8OkiFfB2qfr7WahNhj1ozZFoz+LEo+OHKU2dx6cR7k4lTKbcV7icEms7?=
 =?us-ascii?Q?1nBciaYSyNX/UPCPhigrdsodhzoAlsTmAPOrGkLwzI0Lekk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mzxR+ILaO6WFdS3FbiLgqe33VP3CHlQXD49a4zRwYAbgfZcMPB/AgoU0qv5T?=
 =?us-ascii?Q?5fLSrwEsE2SGotsr7+B1X1W3y1q6mmE4XYnRVcZbuUKiwjFzH7VfqlKHor8S?=
 =?us-ascii?Q?rAuCEpQwYAeoeyuKKpbcxyVtjBTgr1vj1bftNqZl3jyLJzwUwEdDU0g/IzVF?=
 =?us-ascii?Q?YwxJY328BS+LaF3quxVv4inNCd7JE6RvX/OFyEdzmc0VrFqPqSKEk3oobM4W?=
 =?us-ascii?Q?WSAdxcZEkeya/nZzVaGddk8Lqeppx36/OfivQnzC11GmM+HvRGSUllqOh+l+?=
 =?us-ascii?Q?QSvVb8TM5s622K63UDcN3AX8TF8Y3sTRCM77ZfQDzOFAHW+WmQnfe9/D4+8e?=
 =?us-ascii?Q?WDWbvKzjlq+g07+iJB3tjUWpkhOGKFqmPGlMSXP/SYu9k2Na33XY/d3+OObx?=
 =?us-ascii?Q?z8CwH8MhwGwBLWWacoDYzPh68K+eaakA4Xj6eJNM153mP8JMg5P2l/Nf/LQY?=
 =?us-ascii?Q?VHTIoqEjNZcXSkmROGp68Bh/D3ulUQ14GM9Wiiq4RI1878X/2miWwHs2Rzqq?=
 =?us-ascii?Q?iG2sw3Kyk8sKV3F/j1DjTtJ/Ca7t6JjUo9Qk0tyL3t9n3Dux1ufAjMzrh6KK?=
 =?us-ascii?Q?MRLy5NsTDe/yETwxNP2QkAl3vkIDtBBZuD7dytlW9kCV4DssP30CsdWzYqCD?=
 =?us-ascii?Q?a2U5GOZ3ytpToiI4gGJwPFrLj67a5Z2BD/cYRXE256l11hXH5Y6ecUasuCBN?=
 =?us-ascii?Q?jcHqkOoF/yAmJCBTGU/9+BCpXKJNQrCduGJfKPJYjb6gn+yu1fnTIrHgkKx0?=
 =?us-ascii?Q?kaJiqyLu44xvsyPojGNUhAAOmjOcaCmTGlELb9cLGDaJCHi85EHvjuoe7DY3?=
 =?us-ascii?Q?5m2hEMwst6wlVLR3TO4nwNdCVHHP8eJgSCL6mTwcZ++1jW/CQEyYq7lq4e7i?=
 =?us-ascii?Q?aIH8IgzNGG13dLwcdYEXgQR81t68nKQu90ODSzQg5aJ1wwrVAOUubNCffmBC?=
 =?us-ascii?Q?jJkopVLgC6yRcVNSCgd9NA+h20wDpr7xh5xV4vqdCgaH6tSdSCLVu/gDvNZX?=
 =?us-ascii?Q?oMVsk6BHRHkSOln8/eZGUcRDY7fOPi1DOJffWL4XSKpsG7zYHsoN6csbnjrL?=
 =?us-ascii?Q?+1dO6tAW3vPhfoGOK9iGmiG+dHwuggWyioMtoDME/sQkHkdRQTX0dw8Fk7KM?=
 =?us-ascii?Q?9Im/X0IkqSPo10eXuFWpya9TgJcRiagPXK9hdSq4WByP26QEicuONMcRxjtf?=
 =?us-ascii?Q?MHLlfpvhto4MLlU+YXdW/lA978II70CCRijy//i0hTY/ZI+TztLz5Q9XJOyx?=
 =?us-ascii?Q?Rlih+vZfckK2vjzwy1DGgIn9kLPAobHNar4fqYQrHrKt1yqV+Qz4g2zEv1gx?=
 =?us-ascii?Q?H/nfUnZy+JJxazHEV8yZAWvT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b19e41-cd6f-48ad-6cc4-08d968e0acf1
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:23.4197
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PChnfB8Z8DURP0i/4EB4yA/6wTo5H0vOTxJLM28vaadEwtxflcAfY4cbTxVopm408qFFlNnnT3hBUV/sy3IItQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The SNP_LAUNCH_START is called first to create a cryptographic launch
context within the firmware.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c        | 29 ++++++++++++++++++++++++++++-
 target/i386/trace-events |  1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index b8bd6ed9ea..51689d4fa4 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -875,6 +875,28 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
     return 0;
 }
 
+static int
+sev_snp_launch_start(SevSnpGuestState *sev_snp_guest)
+{
+    int fw_error, rc;
+    SevCommonState *sev_common = SEV_COMMON(sev_snp_guest);
+    struct kvm_sev_snp_launch_start *start = &sev_snp_guest->kvm_start_conf;
+
+    trace_kvm_sev_snp_launch_start(start->policy);
+
+    rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_SNP_LAUNCH_START,
+                   start, &fw_error);
+    if (rc < 0) {
+        error_report("%s: SNP_LAUNCH_START ret=%d fw_error=%d '%s'",
+                __func__, rc, fw_error, fw_error_to_str(fw_error));
+        return 1;
+    }
+
+    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_UPDATE);
+
+    return 0;
+}
+
 static int
 sev_launch_start(SevGuestState *sev_guest)
 {
@@ -1173,7 +1195,12 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    ret = sev_launch_start(SEV_GUEST(sev_common));
+    if (sev_snp_enabled()) {
+        ret = sev_snp_launch_start(SEV_SNP_GUEST(sev_common));
+    } else {
+        ret = sev_launch_start(SEV_GUEST(sev_common));
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
2.25.1

