Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288A13C2B0D
	for <lists+kvm@lfdr.de>; Fri,  9 Jul 2021 23:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhGIV7C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 17:59:02 -0400
Received: from mail-bn7nam10on2062.outbound.protection.outlook.com ([40.107.92.62]:31937
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231205AbhGIV67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 17:58:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VfQ+h4Yd6NWDWl4oiUp0/nJ6lir19V/ODt8NiNHl0+dyXVXsJWpv6aGVlmY6gTvpkSnJHMgBuyX8NNQynKMvbeaIgzg8b7jgLq9QJuWukyG4wysEIDgBfWUsp2MPOuL8w8OKUodgwppBJZcaOsTArTlpyitnEPjYbhwXLyAWO3hTBxPDCYjLWSyYLCheyfEor+2eBHoZP+S2MTuiVfWdSCTmwoCLPZ4RBS48iPGK2cnSbv+i8jD+CNInkwT1UN29jTt4iG3FxersoEyPYDaxuRlZbx+FDHRXZMCvSqoPDA6AZ4iUp6jdtsgCHIp2VPjUPbgZnp9RvfFj0C4JMEeD8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5EGslmX1O1I9KE1GjjFQXW6pNm8NomEgQBFNqrAl10=;
 b=Ae2BMQTEd0kyTzm8RaaJCrGptg+aUGtDRT6zp51fsOr76+26A1+jgOgKNuPUhhb+W3Icwexa0bFsdvLjM74ocix8anb6+bh/T0QLi2dEe3AcyKeD9CntG9eVhZSS/K4rWf3eURXNfLv7kz/mVgovEwCZsb/SpLlaB/nns+LNXlxFvlNw9Pn7aX1psW0ik6JwqYznAylSgY9RFBqyWKPnVYYVolvWoXWNOjLvsC2D/iOD6FO60WqS4urEtCaRbeF6kHMoUzT8uZnf7O+moiSTFhFA7R1CluBJolEQwDojsBUgeTrI38RqNo/H4G8V4o4RUsEmBVlhmqFVGW+DEQn2BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t5EGslmX1O1I9KE1GjjFQXW6pNm8NomEgQBFNqrAl10=;
 b=a3w2iLOn3acIn9shoM/fZuv6dCEhJly6Gp+bv/aZMTLoQjDPIPWwZdpe+rQtUujv/Ua5dOfO97UkpAopyOujbnacM9oTnn7yxzfc25RhAuY/QOdf6gEPp0Q52bpFp9R+HU/f08BP9SGXIHv6/F0Tai/Z1NE/wktM+KBi58KI/3g=
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
Subject: [RFC PATCH 6/6] i386/sev: populate secrets and cpuid page and finalize the SNP launch
Date:   Fri,  9 Jul 2021 16:55:50 -0500
Message-Id: <20210709215550.32496-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709215550.32496-1-brijesh.singh@amd.com>
References: <20210709215550.32496-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0007.namprd06.prod.outlook.com
 (2603:10b6:803:2f::17) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0601CA0007.namprd06.prod.outlook.com (2603:10b6:803:2f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Fri, 9 Jul 2021 21:56:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64c4f448-ca78-43b8-780d-08d943245ea7
X-MS-TrafficTypeDiagnostic: SA0PR12MB4575:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45753579CF46743FAA0D8958E5189@SA0PR12MB4575.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UfRDvxfwbZ6GAdbp4D2LbAN9NtrjL+vBI3PqqC7o8ssrsOWIrBz/2EsPLLTc6yHt9W6PC88Kb0NxLOuQq8wKkluP6WKMVSn9nneYG9Fw+8RMMTGnU/NEEe0e47YSAKx4QA+ppCun4ywLGCPQIJ6Rehz0sagUFV+MsXYISZvmJrl7RkGLeBmfElQG185kx8cxIV2OjwQD7Ws2SOstD8orx2wIlwjTMhLSTw10nWGU2X7p2HHe3RXF/l0iONxB1m01StJS3QL5h3bOSaHrSXE4/g2mTR2h0Rvo+i1LzfkRvoNgfpGAQY8OoamLwV7mx7dvwKS/5jn3L9N0aXKkDoGRZNj3dYZ6Nb/x+Ju28YBjvROufDStbvvIENKmk/hLomR7LXVRD0THEOp3DSYQhQ1pKjTSZeiSXj1j+3dCiTZbJ0KFz0Lc4wvlxjWyFRnJuN2avNQwMlo6RTdiTVuHukYMb+6jJB2T7mq7AgIbsKB3Pp9EQPN4zshSN4fd4YESjl71f/jAXn3L7nqEZS0JWNNxnlOBwj3pGUUyrjqxOOMVGcGUDUFUEK0x6EKA19Jc0/+JYai3ezdlW8J34FMo937LeV7gOjHoNLqVFHL93vxE2t/bbEKljJIsPSGAWX3OefG8bE47SbD+FgJPe+Zq2ZOmQa4vNequZHuBnZWAaMFhy2fcKNysLh59DEx5AOSlsc7iwjhhLaevTcXBZ494RG1heg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(6916009)(2616005)(66556008)(36756003)(6666004)(6486002)(83380400001)(7696005)(52116002)(2906002)(66476007)(316002)(4326008)(186003)(38100700002)(66946007)(38350700002)(8676002)(8936002)(956004)(86362001)(5660300002)(44832011)(54906003)(478600001)(1076003)(26005)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I9cnBYkOecaet5sAbUqmRWsH5TS90upY4z9uG0bujv/JQzaLJgyutmv1Gl7u?=
 =?us-ascii?Q?NhFXceQ/YZnZ1Sm3120cKmWbBXGkHDh3qrApccfMwxcCX+ukVRZS5DM9CbGk?=
 =?us-ascii?Q?BEvjoanXmAVgTE+J2Qe25qr85BEG+BvInjegfIaEeK817471pJ2ZnPbZNmyu?=
 =?us-ascii?Q?SaSIQKI+iCfmHyAukbvZLiW/sTt1fyXdLWJLYosH0QyIJFGznXw35pF7z1lw?=
 =?us-ascii?Q?F9da3j/DCJ5A1HCqHtpI68aVy+ZunyinZkKuET0RrJm8p7K1//udkNhvuWyR?=
 =?us-ascii?Q?a+akFdhRP3FUtzzALBhMYqSBIVbecTrCCBD65MZRA0+XviPcCibMreF4tr9B?=
 =?us-ascii?Q?AkYlk6YibSaFa0fT1FkhZsO16wuFddSbrs4WtAdYVY8YTLfvFWZuKuriK9TL?=
 =?us-ascii?Q?kFONOxbT5k31dotppDsM2wNIrdelXdQ//2MHsXabpFaAKq8p1U5C3zLsJ5vz?=
 =?us-ascii?Q?l3bu9THeWqff+8f8o6hPbEB8zTNng6zD/+jDHNMURLiiAqsnxn/O6PbGg8J5?=
 =?us-ascii?Q?5CyAVCW+LF/gjudHNwVB6E7swGfyDqHY+0fUWgL+cVpE5bY3Ckhji8qNPBgE?=
 =?us-ascii?Q?Z2oiQewJzOkaiQevv8LlMAYnyguXWhk8ND3C/cGryny0fdgbBYpKmxuaYrse?=
 =?us-ascii?Q?q4gHbtwERQiZoaIaSfSkX/5GQ45uUHuTtHsgMpNVw/yFXIvkUg2k9KTbVTGX?=
 =?us-ascii?Q?yxuZTSVROcVoa7AjZ1UgMTInmXO+XugjUshT+reD4vpaoz3h0YE1US8mH2WJ?=
 =?us-ascii?Q?ab5wOhebCPRe/lcxEh1YtUvCvT0fhXIjmnOjHoqNAmBUCfg3fXVWwKJ0YyyM?=
 =?us-ascii?Q?hNcu9xjGAYo7Rro9Q1RsG1ratvk84HwsJf7sPo7aEsc9qntEkeAK1J+4Vip+?=
 =?us-ascii?Q?1ehbLc/Ev41HzdZqa55LUMK9ZKKXIp+rgyw3hCdhDifnL/G9FN77F1DwWCIa?=
 =?us-ascii?Q?wSZXD1Z6YMsH+CQ1op67X2cj1kyrWjGvE5kvCufl0ouhTaD2OyX0cw24SsVf?=
 =?us-ascii?Q?n0tw3crpPfB0fzEHhYg5LW+hOnWDXEhUJum/FKj0vaK81hH6ab8G6R18LI84?=
 =?us-ascii?Q?bzFGDx0yQew2jvLVsIGxeh+FJL5lnb7HJqS91bHiTlwYFXXm++POohOrWJAq?=
 =?us-ascii?Q?o/vfxYieZMb2Ps3NO6izL98bWEfUXth74lyeLLtre2z67NF5Hf7j12YU3qCp?=
 =?us-ascii?Q?Xp8i13Vrlau3wVvtfOzpwCiUphWSiP5GUNDzag8X2ldfK3v5LY01y0DQkusy?=
 =?us-ascii?Q?o6PfHtBkmbMY7S7NiJKKNsmTi6tZDXey7qfOcMyoUqS0vroQ4CrKG6PhcCyr?=
 =?us-ascii?Q?392kxQiinG7yIeuISYy7HycH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c4f448-ca78-43b8-780d-08d943245ea7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 21:56:13.7352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6hSA4kr8/X/mlX5JGF67wsgaL9L9gsOPl+DzdRZ/q2wS31o5y7zeVQhmMgjzr4tC9VMIAkzlgjUyZ+kScwBgsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During the SNP guest launch sequence, a special secrets and cpuid page
needs to be populated by the SEV-SNP firmware. The secrets page contains
the VM Platform Communication Key (VMPCKs) used by the guest to send and
receive secure messages to the PSP. And CPUID page will contain the CPUID
value filtered through the PSP.

The guest BIOS (OVMF) reserves these pages in MEMFD and location of it
is available through the SNP boot block GUID. While finalizing the guest
boot flow, lookup for the boot block and call the SNP_LAUNCH_UPDATE
command to populate secrets and cpuid pages.

In order to support early boot code, the OVMF may ask hypervisor to
request the pre-validation of certain memory range. If such range is
present the call LAUNCH_UPDATE command to validate those address range
without affecting the measurement. See the SEV-SNP specification for
further details.

Finally, call the SNP_LAUNCH_FINISH to finalize the guest boot.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 target/i386/sev.c        | 184 ++++++++++++++++++++++++++++++++++++++-
 target/i386/trace-events |   2 +
 2 files changed, 184 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 41dcb084d1..f438e09d33 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -93,6 +93,19 @@ typedef struct __attribute__((__packed__)) SevInfoBlock {
     uint32_t reset_addr;
 } SevInfoBlock;
 
+#define SEV_SNP_BOOT_BLOCK_GUID "bd39c0c2-2f8e-4243-83e8-1b74cebcb7d9"
+typedef struct __attribute__((__packed__)) SevSnpBootInfoBlock {
+    /* Prevalidate range address */
+    uint32_t pre_validated_start;
+    uint32_t pre_validated_end;
+    /* Secrets page address */
+    uint32_t secrets_addr;
+    uint32_t secrets_len;
+    /* CPUID page address */
+    uint32_t cpuid_addr;
+    uint32_t cpuid_len;
+} SevSnpBootInfoBlock;
+
 static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
@@ -1014,6 +1027,158 @@ static Notifier sev_machine_done_notify = {
     .notify = sev_launch_get_measure,
 };
 
+static int
+sev_snp_launch_update_gpa(uint32_t hwaddr, uint32_t size, uint8_t type)
+{
+    void *hva;
+    MemoryRegion *mr = NULL;
+
+    hva = gpa2hva(&mr, hwaddr, size, NULL);
+    if (!hva) {
+        error_report("SEV-SNP failed to get HVA for GPA 0x%x", hwaddr);
+        return 1;
+    }
+
+    return sev_snp_launch_update(sev_guest, hva, size, type);
+}
+
+struct snp_pre_validated_range {
+    uint32_t start;
+    uint32_t end;
+};
+
+static struct snp_pre_validated_range pre_validated[2];
+
+static bool
+detectoverlap(uint32_t start, uint32_t end,
+              struct snp_pre_validated_range *overlap)
+{
+    int i;
+
+    for (i = 0; i < ARRAY_SIZE(pre_validated); i++) {
+        if (pre_validated[i].start < end && start < pre_validated[i].end) {
+            memcpy(overlap, &pre_validated[i], sizeof(*overlap));
+            return true;
+        }
+    }
+
+    return false;
+}
+
+static void snp_ovmf_boot_block_setup(void)
+{
+    struct snp_pre_validated_range overlap;
+    SevSnpBootInfoBlock *info;
+    uint32_t start, end, sz;
+    int ret;
+
+    /*
+     * Extract the SNP boot block for the SEV-SNP guests by locating the
+     * SNP_BOOT GUID. The boot block contains the information such as location
+     * of secrets and CPUID page, additionaly it may contain the range of
+     * memory that need to be pre-validated for the boot.
+     */
+    if (!pc_system_ovmf_table_find(SEV_SNP_BOOT_BLOCK_GUID,
+        (uint8_t **)&info, NULL)) {
+        error_report("SEV-SNP: failed to find the SNP boot block");
+        exit(1);
+    }
+
+    trace_kvm_sev_snp_ovmf_boot_block_info(info->secrets_addr,
+                                           info->secrets_len, info->cpuid_addr,
+                                           info->cpuid_len,
+                                           info->pre_validated_start,
+                                           info->pre_validated_end);
+
+    /* Populate the secrets page */
+    ret = sev_snp_launch_update_gpa(info->secrets_addr, info->secrets_len,
+                                    KVM_SEV_SNP_PAGE_TYPE_SECRETS);
+    if (ret) {
+        error_report("SEV-SNP: failed to insert secret page GPA 0x%x",
+                     info->secrets_addr);
+        exit(1);
+    }
+
+    /* Populate the cpuid page */
+    ret = sev_snp_launch_update_gpa(info->cpuid_addr, info->cpuid_len,
+                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
+    if (ret) {
+        error_report("SEV-SNP: failed to insert cpuid page GPA 0x%x",
+                     info->cpuid_addr);
+        exit(1);
+    }
+
+    /*
+     * Pre-validate the range using the LAUNCH_UPDATE_DATA, if the
+     * pre-validation range contains the CPUID and Secret page GPA then skip
+     * it. This is because SEV-SNP firmware pre-validates those pages as part
+     * of adding secrets and cpuid LAUNCH_UPDATE type.
+     */
+    pre_validated[0].start = info->secrets_addr;
+    pre_validated[0].end = info->secrets_addr + info->secrets_len;
+    pre_validated[1].start = info->cpuid_addr;
+    pre_validated[1].end = info->cpuid_addr + info->cpuid_len;
+    start = info->pre_validated_start;
+    end = info->pre_validated_end;
+
+    while (start < end) {
+        /* Check if the requested range overlaps with Secrets and CPUID page */
+        if (detectoverlap(start, end, &overlap)) {
+            if (start < overlap.start) {
+                sz = overlap.start - start;
+                if (sev_snp_launch_update_gpa(start, sz,
+                    KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
+                    error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
+                                 start, sz);
+                    exit(1);
+                }
+            }
+
+            start = overlap.end;
+            continue;
+        }
+
+        /* Validate the remaining range */
+        if (sev_snp_launch_update_gpa(start, end - start,
+            KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
+            error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
+                         start, end - start);
+            exit(1);
+        }
+
+        start = end;
+    }
+}
+
+static void
+sev_snp_launch_finish(SevGuestState *sev)
+{
+    int ret, error;
+    Error *local_err = NULL;
+    struct kvm_sev_snp_launch_finish *finish = &sev->snp_config.finish;
+
+    trace_kvm_sev_snp_launch_finish();
+    ret = sev_ioctl(sev->sev_fd, KVM_SEV_SNP_LAUNCH_FINISH, finish, &error);
+    if (ret) {
+        error_report("%s: SNP_LAUNCH_FINISH ret=%d fw_error=%d '%s'",
+                     __func__, ret, error, fw_error_to_str(error));
+        exit(1);
+    }
+
+    sev_set_guest_state(sev, SEV_STATE_RUNNING);
+
+    /* add migration blocker */
+    error_setg(&sev_mig_blocker,
+               "SEV: Migration is not implemented");
+    ret = migrate_add_blocker(sev_mig_blocker, &local_err);
+    if (local_err) {
+        error_report_err(local_err);
+        error_free(sev_mig_blocker);
+        exit(1);
+    }
+}
+
+
 static void
 sev_launch_finish(SevGuestState *sev)
 {
@@ -1048,7 +1213,12 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
 
     if (running) {
         if (!sev_check_state(sev, SEV_STATE_RUNNING)) {
-            sev_launch_finish(sev);
+            if (sev_snp_enabled()) {
+                snp_ovmf_boot_block_setup();
+                sev_snp_launch_finish(sev);
+            } else {
+                sev_launch_finish(sev);
+            }
         }
     }
 }
@@ -1164,7 +1334,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     ram_block_notifier_add(&sev_ram_notifier);
-    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+
+    /*
+     * The machine done notify event is used by the SEV guest to get the
+     * measurement of the encrypted images. When SEV-SNP is enabled then
+     * measurement is part of the attestation report and the measurement
+     * command does not exist. So skip registering the notifier.
+     */
+    if (!sev_snp_enabled()) {
+        qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+    }
+
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
 
     cgs->ready = true;
diff --git a/target/i386/trace-events b/target/i386/trace-events
index 0c2d250206..db91287439 100644
--- a/target/i386/trace-events
+++ b/target/i386/trace-events
@@ -13,3 +13,5 @@ kvm_sev_launch_secret(uint64_t hpa, uint64_t hva, uint64_t secret, int len) "hpa
 kvm_sev_attestation_report(const char *mnonce, const char *data) "mnonce %s data %s"
 kvm_sev_snp_launch_start(uint64_t policy) "policy 0x%" PRIx64
 kvm_sev_snp_launch_update(void *addr, uint64_t len, int type) "addr %p len 0x%" PRIx64 " type %d"
+kvm_sev_snp_launch_finish(void) ""
+kvm_sev_snp_ovmf_boot_block_info(uint32_t secrets_gpa, uint32_t slen, uint32_t cpuid_gpa, uint32_t clen, uint32_t s, uint32_t e) "secrets 0x%x+0x%x cpuid 0x%x+0x%x pre-validate 0x%x+0x%x"
-- 
2.17.1

