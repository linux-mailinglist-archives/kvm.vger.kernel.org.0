Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A0F53F90BC
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243816AbhHZW2R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:17 -0400
Received: from mail-bn8nam12hn2223.outbound.protection.outlook.com ([52.100.165.223]:18432
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243805AbhHZW2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XWpdgEJq4IEFq628TsilOUsEnwkFZbpIrVCM6Le9+LkdrwB0Ra82yE4hz+heyC9auejsRN/z7hQnA/a8+rGX0Svo2irYpVw4WkaenjAsnBLDeo7LxnKMrZgugtcI97z7481lpaXTtfzBaMj8k8+3LCeEier3mF5HLcsx1IdOk3QkwxNJa9+jledbHWthGii9ehwsUhlWsCNHZSM380Yl3N4RmVmP/QcTKD33ZbrtXTDprQ7MPSKdEQWU0JhNyW9WmsbLEuMTlYiGPqlqC5JgfNFs/WzsD/YuCCHKIXnM2h2Qpm5AeSpYG7VPVXDHOYIHt8NS6+YKRVPZYo8DaYACKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd6nAHvM5keukv7hka7KvDWF8u8LRdbOZvMs6rJwNpk=;
 b=JTMGNAlodiq8UzjAF7zo/e/i0n4fkxX9TnN4ifmzGeqrdgj8eHyAj1S0C7oYSZNYFjRiQwr/f2Burbz/fQLhApzHiHFrz8/RS9cFEq3m2SIu4AdJ0asYpx+dnClaTslJZUMdtkIqXGfxvFDZCo9536ifaxUY0Y3dHWOVeT31TlS7jmQMx4mVQcv5OFUPwrBWQJ/PDbVA/aedBrZj4N7VVYNr0er1QSjUPq7S/gRgRO6ClgzptO2NXm8ZtUfk+yrPfW2yEPzlN58hBgMQPPkyi3VCUdN+h5GvmNwGvIl1bgyQqnHA+goZooK5wj99iQwvyTeGtXtz/oFhrdZjJgHF+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yd6nAHvM5keukv7hka7KvDWF8u8LRdbOZvMs6rJwNpk=;
 b=sekz1ODay5VnFYEZsRrhATDSZPKOkMQReerRvRhRXKAdCK6ag5bQmWR8yTNq4la6FeRLo0TmDNXB6nDlSwMDymg+LgNMSW8O6n8USVW5jflnjOV32STcVqQGLkxVtGdq2chovRQ95v7zgiYb2QvHLnffAP5Dk/Do8olcx4jfGSg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:27 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:27 +0000
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
Subject: [RFC PATCH v2 07/12] i386/sev: populate secrets and cpuid page and finalize the SNP launch
Date:   Thu, 26 Aug 2021 17:26:22 -0500
Message-Id: <20210826222627.3556-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:806:d2::24) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA0PR11CA0079.namprd11.prod.outlook.com (2603:10b6:806:d2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 26 Aug 2021 22:27:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d7115f8-03ad-4e4e-1e83-08d968e0af3e
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39258F72FC8CDEAB7EB0755F95C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2EKhb9kDpwPRYSSCehm9m+oTfD9Rs88JQnq9yLCJDa3DasV4JFGGVv8bbKgm?=
 =?us-ascii?Q?BXuzShjp/OTJ7+ZJkKdDGoCdBhZAfH6tpH2h5PhozuIhbrwwmbmkBm1WZMqI?=
 =?us-ascii?Q?8gPY+InyEBPZV7y26vRsfFWauunMfjZzbu6+1OSZFuDcu2rYLVuqNL5GpHAR?=
 =?us-ascii?Q?+RPcv4gAGGHxUk9KvyF2grUxUebfK6/Upo0VnvsECWPknhPukzBjAYDQ0S3A?=
 =?us-ascii?Q?Wu+SGGWexxhmMdLa5JS4MW078DHmnBrK/F+KSpZszXq7IGKcSDVK437UtJME?=
 =?us-ascii?Q?hhj2fmqtefALczl7TCrAJTpray5g0/FUWzaprvVgy4TihdU6t5luLXcyLxOs?=
 =?us-ascii?Q?idnTrnl2ELgdSvJ+eXPzYf6Rm429x6TLy5UH7Z2PlOQErBjnHsrWtGKcIfB5?=
 =?us-ascii?Q?u5EO2jnrOYEpgAMzHK2aBBZWsMpPZibNO21DKsHR5RUwjZ+Y2JS/fDntAdJ5?=
 =?us-ascii?Q?Dsu0dhq5FTY1fp2sb7q+HwNIdkdXFrYqIPGwb56FlD0Z5xnA5QGNQ43w/303?=
 =?us-ascii?Q?Iu83/PbenBOANJPcZlpDOELnYCLO1A96SPrnTXqRjtCEENl1ETVq3m2Dmlt8?=
 =?us-ascii?Q?gJadDzzZfcwY+cpaf+eICtAuhegMWjkpbpmkK5N1iMqFJDepmnwxmRYVfiHi?=
 =?us-ascii?Q?XHHdryxFTVsIcCQpaSqXwoHcJiLEnz7BJGjVgfphnPrgo6UsELf1lXA9z+Sa?=
 =?us-ascii?Q?200z4C5TDKIKvTsBeM4oU8ratlRekVJa7jVMFC6gVX5VnAPTTfwlR2PKV3cW?=
 =?us-ascii?Q?++pO/txX7kVtH1eDfPUJ5INpFUmoWVuhzvbmEeKpGony96JTImNvbXFEQpcU?=
 =?us-ascii?Q?mSB5wHGOhw6WMf8/UIvnzeEEVjQAE5xicnjqO1Fw240bH7gEK5WtIQNFygxc?=
 =?us-ascii?Q?+sXREY49XnrvAPJeMwq40Lm0mHX4PjyMZcglCgtzWncwVJqbwo/33YoaJq/l?=
 =?us-ascii?Q?XE+vTOYQCs0jhALOC44iLajMIAGosDdmtMded2Iv/twE94XS0VZ9jZZZtYbq?=
 =?us-ascii?Q?2SxSSOC7dlACJjm9maFuAcA9WR7fnNH7ogQHebdL4y64PY0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(6666004)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v0LuheBf0gxrg8Y5/zVgcFObQPqdlYD7tD53A9l37SoCV5hQpzxzOkdSMT//?=
 =?us-ascii?Q?nUql4tEAFb/c9O55eTBn6yL80onFyqvWdAPV7ndMiZapx6S06Q13F8ZNGBx3?=
 =?us-ascii?Q?/WY4fD30VYCUOaR3jL5krBAD5f4XNobK+Cf6aT65be++9DFBJZmKaiFtLrxj?=
 =?us-ascii?Q?1G+D2jTqRMrOw2y3M72A5Cng6rqnhqWDZutxQObmTgDeKYR/LMQR/BQQFXl9?=
 =?us-ascii?Q?d71NEkbi10eEL6MU6G53rosR5S0GE54c94SMkE3m8WILgPcVu3ld8LRRBwf2?=
 =?us-ascii?Q?hxz81+ikBiUEUYwP76EK1nqSpCwBwYOzUFcqBeguA53axqcQ3Wbs9JAvYfBn?=
 =?us-ascii?Q?iyK+JLOCI7w74dQ6rTYBcxQ1EgFwNCtm6fkvrr6TTs42uREmua2BSXItbNNW?=
 =?us-ascii?Q?hgRf1eF0+bK81gYF2xQeRmquQ47lfgYh7JWSDC+UwGVzn5qIXcDnHpVJXS2u?=
 =?us-ascii?Q?SY62jW/eCq9cZ/y6Ly1fu7gpVP9bMwi3KQG4FIuAQ50msgUJ+erOpyQ5tECe?=
 =?us-ascii?Q?6+W1T9HGeaNRTrua5AqgxAmLybUn1jiKjvMzdl2SBbvajz3DQ9bbt1U+Vycx?=
 =?us-ascii?Q?Ayp9lLBQrRk2CBMT4luGS33PLyY8gzTCOb2o9IngxC4gOvH4pe2qIV4GFTTS?=
 =?us-ascii?Q?FuIiKa4WIDSXvD6zLrmlDucnVTBjOwyL9cGmvv33fUsEL+UhQlR47aN/FFTw?=
 =?us-ascii?Q?sLztPT72NMRZqseCnM0Mboae3DnBwVyVFbHqpqC5hH8DDTKqKdsPr9Epg4J0?=
 =?us-ascii?Q?ekQgruxDwJ40XCASdiHN91hfy+97Dfaed8a6/+p8o0pZpVyd5EOG9Sof33ZQ?=
 =?us-ascii?Q?IQ+RIwWPgcZRbgIp7vmVcgRD11CTbdUozSGfgY8OF63HKka68XScw9GcVtBZ?=
 =?us-ascii?Q?anOv9zoRxQ8/XXE9DEq/Sevqu12butGUGcEkwvxSrlKn0aCcwYI+xMa6O93k?=
 =?us-ascii?Q?O5sWh7QwplRr7WlADctY0DLZ6OZ4myQ4rIgTOKElm3uCi1kRI0jRLuM/cGko?=
 =?us-ascii?Q?jhaN6pULBT9UmUNyfXlABs8dmsnqpg/WsEF1ahK9pQ6qj1bsrSWwH3ziqCQZ?=
 =?us-ascii?Q?SSUIfAUZVAqPkOKrbXgcGpUCtZszeM279AzZSk3aANXZADlZwmUKKlnWsxsR?=
 =?us-ascii?Q?4XXgIvwPGGRbP8POieNsnYkmMMh7tbi/rjxVF8utNkqV7JnbfJ3V8pawC47p?=
 =?us-ascii?Q?OwtAUHULxHJDVESsXnUD/PvFZvYtSLSjGU3/adgwGLzvW2Vv4J5/Dpg40IKm?=
 =?us-ascii?Q?neGK3kERPXafFhtL0sw7Y0iXqLd8tXR5r3Qx2yFeeNiCylsoq4Nl8EpBlEjE?=
 =?us-ascii?Q?FLTMjQvYhwpbIHGm6DC9vJeB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d7115f8-03ad-4e4e-1e83-08d968e0af3e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:27.2977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2QRoJ61LxFn7a++bPkVO1usn4aDWhXWGZtFpXAEqZssLNQrfVPg8MOz8Uww7T2GK/fK0Sf1vsJkRGLkJ/tAfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

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
present the call SNP_LAUNCH_UPDATE command to validate those address
range without affecting the measurement. See the SEV-SNP specification
for further details.

Finally, call the SNP_LAUNCH_FINISH to finalize the guest boot.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c        | 189 ++++++++++++++++++++++++++++++++++++++-
 target/i386/trace-events |   2 +
 2 files changed, 189 insertions(+), 2 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 867c0cb457..0009c93d28 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -33,6 +33,7 @@
 #include "monitor/monitor.h"
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/pc.h"
+#include "qemu/range.h"
 
 #define TYPE_SEV_COMMON "sev-common"
 OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
@@ -107,6 +108,19 @@ typedef struct __attribute__((__packed__)) SevInfoBlock {
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
 static Error *sev_mig_blocker;
 
 static const char *const sev_fw_errlist[] = {
@@ -1086,6 +1100,162 @@ static Notifier sev_machine_done_notify = {
     .notify = sev_launch_get_measure,
 };
 
+static int
+sev_snp_launch_update_gpa(uint32_t hwaddr, uint32_t size, uint8_t type)
+{
+    void *hva;
+    MemoryRegion *mr = NULL;
+    SevSnpGuestState *sev_snp_guest =
+        SEV_SNP_GUEST(MACHINE(qdev_get_machine())->cgs);
+
+    hva = gpa2hva(&mr, hwaddr, size, NULL);
+    if (!hva) {
+        error_report("SEV-SNP failed to get HVA for GPA 0x%x", hwaddr);
+        return 1;
+    }
+
+    return sev_snp_launch_update(sev_snp_guest, hwaddr, hva, size, type);
+}
+
+static bool
+detect_first_overlap(uint64_t start, uint64_t end, Range *range_list,
+                     size_t range_count, Range *overlap_range)
+{
+    int i;
+    bool overlap = false;
+    Range new;
+
+    assert(overlap_range);
+    range_make_empty(overlap_range);
+    range_init_nofail(&new, start, end - start + 1);
+
+    for (i = 0; i < range_count; i++) {
+        if (range_overlaps_range(&new, &range_list[i]) &&
+            (range_is_empty(overlap_range) ||
+             range_lob(&range_list[i]) < range_lob(overlap_range))) {
+            *overlap_range = range_list[i];
+            overlap = true;
+        }
+    }
+
+    return overlap;
+}
+
+static void snp_ovmf_boot_block_setup(void)
+{
+    SevSnpBootInfoBlock *info;
+    uint32_t start, end, sz;
+    int ret;
+    Range validated_ranges[2];
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
+    range_init_nofail(&validated_ranges[0], info->secrets_addr, info->secrets_len);
+    range_init_nofail(&validated_ranges[1], info->cpuid_addr, info->cpuid_len);
+    start = info->pre_validated_start;
+    end = info->pre_validated_end;
+
+    while (start < end) {
+        Range overlap_range;
+
+        /* Check if the requested range overlaps with Secrets and CPUID page */
+        if (detect_first_overlap(start, end, validated_ranges, 2,
+                                 &overlap_range)) {
+            if (start < range_lob(&overlap_range)) {
+                sz = range_lob(&overlap_range) - start;
+                if (sev_snp_launch_update_gpa(start, sz,
+                    KVM_SEV_SNP_PAGE_TYPE_UNMEASURED)) {
+                    error_report("SEV-SNP: failed to validate gpa 0x%x sz %d",
+                                 start, sz);
+                    exit(1);
+                }
+            }
+
+            start = range_upb(&overlap_range) + 1;
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
+sev_snp_launch_finish(SevSnpGuestState *sev_snp)
+{
+    int ret, error;
+    Error *local_err = NULL;
+    struct kvm_sev_snp_launch_finish *finish = &sev_snp->kvm_finish_conf;
+
+    trace_kvm_sev_snp_launch_finish();
+    ret = sev_ioctl(SEV_COMMON(sev_snp)->sev_fd, KVM_SEV_SNP_LAUNCH_FINISH, finish, &error);
+    if (ret) {
+        error_report("%s: SNP_LAUNCH_FINISH ret=%d fw_error=%d '%s'",
+                     __func__, ret, error, fw_error_to_str(error));
+        exit(1);
+    }
+
+    sev_set_guest_state(SEV_COMMON(sev_snp), SEV_STATE_RUNNING);
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
 sev_launch_finish(SevGuestState *sev_guest)
 {
@@ -1121,7 +1291,12 @@ sev_vm_state_change(void *opaque, bool running, RunState state)
 
     if (running) {
         if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
-            sev_launch_finish(SEV_GUEST(sev_common));
+            if (sev_snp_enabled()) {
+                snp_ovmf_boot_block_setup();
+                sev_snp_launch_finish(SEV_SNP_GUEST(sev_common));
+            } else {
+                sev_launch_finish(SEV_GUEST(sev_common));
+            }
         }
     }
 }
@@ -1236,7 +1411,17 @@ int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
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
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
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
2.25.1

