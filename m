Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FA43F90B2
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243778AbhHZW2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:03 -0400
Received: from mail-dm6nam11hn2225.outbound.protection.outlook.com ([52.100.172.225]:47361
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243764AbhHZW2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eepTJ0F8KtgqoF1p4sz2khFvqkS46aNyj3gKN+BD8rW1GloapfOdIAecIW7DEULGkpBegA25Z6WbP2AFp861C7oskWD7ByjeBiIki1zVSD4i6r2RVKGxJ/LUH1T6FrmaAl/TJrlAqPNcXcZ5GHyyIjz5fdDMZycP1I48hT5/pPR1vLo32QpZJOKfRi/bFFsGHtk2b4bCpEMs2bqlBjoJs2ALk0m8fYLgKUKKi1AhR7NObn41lCvQexf9S4pkv5ERtNn5jzg9+WCMo4Iw5UGbsFvY5n80ODyuRu+TG9eB4ozuKvK+/WSSKUzyrAxXc8iBiE7qPm6DrBrqT9gZhQoHDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+COgJlQSZtZ2EaaufkaqxyCvux1xLYqGTWWciI8S6lI=;
 b=Ads0Pi9Rme27nhUdvMlNVH4RMLRaaYzlzXHQ45Bi5Ppwm/uJEaQkvmGja5xQJF/Bd+MwqB1cCQYvlm3ees8kF0YLk6YOlaTuViQKrOXblQQmlGC94k2sdbHwDlbUDkiFtlGg46L7lfZXTJjkZwJzA9y0xHJQWzbhNrZFX5khc/2ghI+vipdyvOzz7xD+gmTJEAC+Eer4HvLg5ag9SuOQ6cU/EonHiZEk533nIKF6W/BVe8RgimYI53U/R0Y5u9BOJhvu1RKGYTkzDcSUADZt+NFdwbDOT9BI8xg9bxoRV1khTbH3vN6yXq9dtmhJVR0/m/aKcKqPDwxv/B4SgFpmmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+COgJlQSZtZ2EaaufkaqxyCvux1xLYqGTWWciI8S6lI=;
 b=ZItGjn89110ye/3VL6VHw/S27lHvIsSXSw+exDIsME2Lfti9jgyTaIPOXrI2zTkGtXljK/WXZKqa8p8xNgUVnMKKrQi+oAGwbDKW/QNcG63ZkFbP8iO23tyR30Cs9NGiw0Oz1V6+kKJ6Iz+e7x8M5CitEUXgUKskq5zJBOBhA6M=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:12 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:12 +0000
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
Subject: [RFC PATCH v2 11/12] i386/sev: sev-snp: add support for CPUID validation
Date:   Thu, 26 Aug 2021 17:26:26 -0500
Message-Id: <20210826222627.3556-12-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0067.namprd11.prod.outlook.com
 (2603:10b6:806:d2::12) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA0PR11CA0067.namprd11.prod.outlook.com (2603:10b6:806:d2::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Thu, 26 Aug 2021 22:27:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: beb8c79a-92ba-4a13-5634-08d968e0a691
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39252410E2058E4282FA860F95C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?DmiEU9wagF08pitKrB5IyLy9D44adZbmzX8Smbq+71yAP4KU2syh/9wUOfrO?=
 =?us-ascii?Q?z9GNYIeqXGN50vMYIzl7maSXidjwbXR9qwoCL7TUokX5YN60yLrLwjNOR7nh?=
 =?us-ascii?Q?7OVQ9e0vEQyB+QvA1dVXsPIUcuZ614ZS4Q0RCbEUtvnyZtmC+G9RpMybmMbJ?=
 =?us-ascii?Q?WlFq/kQ84toocPspwcLXkexFPFYh3fxJ+0m700kRJkMLp8apW+S9EWfQ1kB7?=
 =?us-ascii?Q?rDd+P67g8gIWZ3qsZis4chfVLLFVzTTHlSMVGOnN/R83ixrb5Fuh9WF1u1KX?=
 =?us-ascii?Q?gbLb6mMImrhPrOgh6GS72mM3d2lU74NiESilxrbKqj54TwMGkZnLOpyhoh5k?=
 =?us-ascii?Q?J1B5xM2Ui4pnrWnL5LlcBl6HQw5GTdlV8pnzXs+10d5EhYBEt45IP1/1ylDC?=
 =?us-ascii?Q?V+YBGiFGPLasq3MYPK+IwKjCnTcSJ9EGWLmhWmkon2gYIJ1N3YKurBUD9YxU?=
 =?us-ascii?Q?U8/ygUUdsmYKHqqdlxwNQYVVhah/Ta1sGW/A3JA1mPbcU1vTIjlEuYyP7rTo?=
 =?us-ascii?Q?WYaMdWJFbbYVgb669o7ukR+fLzjNX9yYs5XIayMi/kWlMHHx8jYeuLPeyuPD?=
 =?us-ascii?Q?FUqvrcI/13EO6vcu1D+hQrZ3VFId/Lv4l2iZNtKhlEVYvuYNIFR2i38dshTf?=
 =?us-ascii?Q?in1mcWV3YllGm0c073QgDkyptbee4kx2TEfZJYzbsSIL1Ha8Is2PKPoax2T/?=
 =?us-ascii?Q?2ggbCEZttc1U1GatEPGWWS1FBTorCsY3I836TITfXYayEgUjmm4TXSG8jysi?=
 =?us-ascii?Q?SX8YrpZa4MpRcqud21oPqpxzDiC96Vraj5JwjvFJc/xx3Nl4psiNiMonU70g?=
 =?us-ascii?Q?+xuKgfG4t56NBR/nNWsJrak6Bm0Fucc7rKl3SGQi19+w6+/uza8mC4LDSnqM?=
 =?us-ascii?Q?rDEMT25cGoff5w7umBHDQ96kUXfoQqVlLXCInUooxCiUxc1RMJy6HDDfQod9?=
 =?us-ascii?Q?Gg4V7mXmeVZ40cm8dnJqgJ38vk2joJuChXVfWrHyW/Fbiadk835TXMEKPSjY?=
 =?us-ascii?Q?ZmGfbonzI4FBysiMI7RjSbnOz+BU/peWsS63FMtcbBV1Vnk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(6666004)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xT5c+HdCyVNtJC2Zkr6TF7fKW/cnK8ezw9xICV+giJ04TozLrZbb+ssSUr5h?=
 =?us-ascii?Q?QI4vCV27mpFMCwLjvO+2ToqCOxnaoqrlTNYjPQ3sjHsO4albWgIQnfLahnL2?=
 =?us-ascii?Q?vxQZx51dQ3BD0jsK09KWL2/BaoOXZnEZMsmHSvGAN8iuGN0JmwuArM7QJ85j?=
 =?us-ascii?Q?qRnrAfzhGkjrXalaVWmQUWrxuO4qpLDpNqDvwh/AW9fycsgq5R6BXOLlhcWb?=
 =?us-ascii?Q?kkUjIl234EWFcfZCKQtd4XOeqwjaeQtSsG9goxG0xKH7D57KAM0vI6f2tvqZ?=
 =?us-ascii?Q?8TepC17Ow2Y4N5/WUPyOZOwixkq34pYX7FR6FshdE+zR/IklCQByNyylP7qu?=
 =?us-ascii?Q?GX4e7+kmWZpqgtLDpiU9CEuJ+13easBtYWNhLdsX39yBoJ8+uWB9oKSrKlAE?=
 =?us-ascii?Q?S+G/bLG6E8eET8vXCrxtQJwxIbIexD7ioNDMik47fc6Wzs188eSbqhtIUKlV?=
 =?us-ascii?Q?kcGikPwD+hdldiqX5kZ7UpOkbaJ7wyyUboUzwZQUvLtDy+tOUwnCqmPNI6qA?=
 =?us-ascii?Q?5g1GodxRCV7SOOUDWLtyd3i1NG26mXnHDrOpQVcmkyoF5XLs0D+Mwh60Cwjl?=
 =?us-ascii?Q?fdRGEo1xR2iEDPWxFJJmAKV9095t1nntTYxcJ6NlRDxy6ANSqv/lunU/NhfI?=
 =?us-ascii?Q?bRYFFLd+GFF8TcMi+qf0GRG4vz4PkOyR8EdOTBnD6A5Fa6dKpf+28pK7trUL?=
 =?us-ascii?Q?QAz/oaurSfWCylzutvck6aP08cUE//1TRbKbwwVH+/8JwFMvZepYiI612H3n?=
 =?us-ascii?Q?KwON6QQc4IXcOus2dYoWxzDsRv2RLps550SBPAf7ddksIQbE2qAXuGEfn2Be?=
 =?us-ascii?Q?2LyxqshbI0+cxfVQIb0KjOcjbIhWYoV0LNg3M+NwyExOTEU9BaPMC+HmqemK?=
 =?us-ascii?Q?9FgKVWPbbOxeAcIYcAy4hkg6kXkd7kGlWXLhdjYXMelR2jBSnS24P5OUGBZ5?=
 =?us-ascii?Q?sagK+MgoG419WnjOdHN5oGw/tkYUcQY26undg3cNdjA9oYpmHBOMwNI57r/k?=
 =?us-ascii?Q?BqMZPcQ7fsxCtI5pt27OicdTsNVIo+CcguswZjdSzgCS1WWeyIR+tPst6d9y?=
 =?us-ascii?Q?12LvWeLx77dew25pGA/HNTp7isp0B/3h7iq7gnZXK14QVroYn/YKyZ3AiIaZ?=
 =?us-ascii?Q?6GN7aCwAIWIWTrQv2xWNMu+CxpENY5UTRQ2wZIUa6u0b95tOTmj18LMFOwUH?=
 =?us-ascii?Q?FUSKK9Wv6QtvXfM63tpp/CaiZNuNxMP+vhrAwcGYEyxKosv0lcDFfrw1RAgg?=
 =?us-ascii?Q?Q02xpE8EaA+LMVKMqqS/BWMbZxRq9diWjTNhL9O44l6kKVXacVn0Ss1Y9qcF?=
 =?us-ascii?Q?41gwdAc0q8Yhh6YJqeuE/ZF3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: beb8c79a-92ba-4a13-5634-08d968e0a691
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:12.7445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uncT576zmPbhUxKqixaYgU2cEArhT6MPhVXozUaxAITs7R2Ac5xhmSPAhiPrmkpFqmb0cgo6UF4ZPVHVx+JI4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP firmware allows a special guest page to be populated with a
table of guest CPUID values so that they can be validated through
firmware before being loaded into encrypted guest memory where they can
be used in place of hypervisor-provided values[1].

As part of SEV-SNP guest initialization, use this process to validate
the CPUID entries reported by KVM_GET_CPUID2 prior to initial guest
start.

[1]: SEV SNP Firmware ABI Specification, Rev. 0.8, 8.13.2.6

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/sev.c | 146 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 143 insertions(+), 3 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 0009c93d28..72a6146295 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -153,6 +153,36 @@ static const char *const sev_fw_errlist[] = {
 
 #define SEV_FW_MAX_ERROR      ARRAY_SIZE(sev_fw_errlist)
 
+/* <linux/kvm.h> doesn't expose this, so re-use the max from kvm.c */
+#define KVM_MAX_CPUID_ENTRIES 100
+
+typedef struct KvmCpuidInfo {
+    struct kvm_cpuid2 cpuid;
+    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+} KvmCpuidInfo;
+
+#define SNP_CPUID_FUNCTION_MAXCOUNT 64
+#define SNP_CPUID_FUNCTION_UNKNOWN 0xFFFFFFFF
+
+typedef struct {
+    uint32_t eax_in;
+    uint32_t ecx_in;
+    uint64_t xcr0_in;
+    uint64_t xss_in;
+    uint32_t eax;
+    uint32_t ebx;
+    uint32_t ecx;
+    uint32_t edx;
+    uint64_t reserved;
+} __attribute__((packed)) SnpCpuidFunc;
+
+typedef struct {
+    uint32_t count;
+    uint32_t reserved1;
+    uint64_t reserved2;
+    SnpCpuidFunc entries[SNP_CPUID_FUNCTION_MAXCOUNT];
+} __attribute__((packed)) SnpCpuidInfo;
+
 static int
 sev_ioctl(int fd, int cmd, void *data, int *error)
 {
@@ -1141,6 +1171,117 @@ detect_first_overlap(uint64_t start, uint64_t end, Range *range_list,
     return overlap;
 }
 
+static int
+sev_snp_cpuid_info_fill(SnpCpuidInfo *snp_cpuid_info,
+                        const KvmCpuidInfo *kvm_cpuid_info)
+{
+    size_t i;
+
+    memset(snp_cpuid_info, 0, sizeof(*snp_cpuid_info));
+
+    for (i = 0; kvm_cpuid_info->entries[i].function != 0xFFFFFFFF; i++) {
+        const struct kvm_cpuid_entry2 *kvm_cpuid_entry;
+        SnpCpuidFunc *snp_cpuid_entry;
+
+        kvm_cpuid_entry = &kvm_cpuid_info->entries[i];
+        snp_cpuid_entry = &snp_cpuid_info->entries[i];
+
+        snp_cpuid_entry->eax_in = kvm_cpuid_entry->function;
+        if (kvm_cpuid_entry->flags == KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
+            snp_cpuid_entry->ecx_in = kvm_cpuid_entry->index;
+        }
+        snp_cpuid_entry->eax = kvm_cpuid_entry->eax;
+        snp_cpuid_entry->ebx = kvm_cpuid_entry->ebx;
+        snp_cpuid_entry->ecx = kvm_cpuid_entry->ecx;
+        snp_cpuid_entry->edx = kvm_cpuid_entry->edx;
+
+        if (snp_cpuid_entry->eax_in == 0xD &&
+            (snp_cpuid_entry->ecx_in == 0x0 || snp_cpuid_entry->ecx_in == 0x1)) {
+            snp_cpuid_entry->ebx = 0x240;
+        }
+    }
+
+    if (i > SNP_CPUID_FUNCTION_MAXCOUNT) {
+        error_report("SEV-SNP: CPUID count '%lu' exceeds max '%u'",
+                     i, SNP_CPUID_FUNCTION_MAXCOUNT);
+        return -1;
+    }
+
+    snp_cpuid_info->count = i;
+
+    return 0;
+}
+
+static void
+sev_snp_cpuid_report_mismatches(SnpCpuidInfo *old,
+                                SnpCpuidInfo *new)
+{
+    size_t i;
+
+    for (i = 0; i < old->count; i++) {
+        SnpCpuidFunc *old_func, *new_func;
+
+        old_func = &old->entries[i];
+        new_func = &new->entries[i];
+
+        if (memcmp(old_func, new_func, sizeof(SnpCpuidFunc))) {
+            error_report("SEV-SNP: CPUID validation failed for function %x, index: %x.\n"
+                         "provided: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x\n"
+                         "expected: eax:0x%08x, ebx: 0x%08x, ecx: 0x%08x, edx: 0x%08x",
+                         old_func->eax_in, old_func->ecx_in,
+                         old_func->eax, old_func->ebx, old_func->ecx, old_func->edx,
+                         new_func->eax, new_func->ebx, new_func->ecx, new_func->edx);
+        }
+    }
+}
+
+static int
+sev_snp_launch_update_cpuid(uint32_t cpuid_addr, uint32_t cpuid_len)
+{
+    KvmCpuidInfo kvm_cpuid_info;
+    SnpCpuidInfo snp_cpuid_info;
+    CPUState *cs = first_cpu;
+    MemoryRegion *mr = NULL;
+    void *snp_cpuid_hva;
+    int ret;
+
+    snp_cpuid_hva = gpa2hva(&mr, cpuid_addr, cpuid_len, NULL);
+    if (!snp_cpuid_hva) {
+        error_report("SEV-SNP: unable to access CPUID memory range at GPA %d",
+                     cpuid_addr);
+        return 1;
+    }
+
+    /* get the cpuid list from KVM */
+    memset(&kvm_cpuid_info.entries, 0xFF,
+           KVM_MAX_CPUID_ENTRIES * sizeof(struct kvm_cpuid_entry2));
+    kvm_cpuid_info.cpuid.nent = KVM_MAX_CPUID_ENTRIES;
+
+    ret = kvm_vcpu_ioctl(cs, KVM_GET_CPUID2, &kvm_cpuid_info);
+    if (ret) {
+        error_report("SEV-SNP: unable to query CPUID values for CPU: '%s'",
+                     strerror(-ret));
+    }
+
+    ret = sev_snp_cpuid_info_fill(&snp_cpuid_info, &kvm_cpuid_info);
+    if (ret) {
+        error_report("SEV-SNP: failed to generate CPUID table information");
+        exit(1);
+    }
+
+    memcpy(snp_cpuid_hva, &snp_cpuid_info, sizeof(snp_cpuid_info));
+
+    ret = sev_snp_launch_update_gpa(cpuid_addr, cpuid_len,
+                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
+    if (ret) {
+        sev_snp_cpuid_report_mismatches(&snp_cpuid_info, snp_cpuid_hva);
+        error_report("SEV-SNP: failed update CPUID page");
+        exit(1);
+    }
+
+    return 0;
+}
+
 static void snp_ovmf_boot_block_setup(void)
 {
     SevSnpBootInfoBlock *info;
@@ -1176,10 +1317,9 @@ static void snp_ovmf_boot_block_setup(void)
     }
 
     /* Populate the cpuid page */
-    ret = sev_snp_launch_update_gpa(info->cpuid_addr, info->cpuid_len,
-                                    KVM_SEV_SNP_PAGE_TYPE_CPUID);
+    ret = sev_snp_launch_update_cpuid(info->cpuid_addr, info->cpuid_len);
     if (ret) {
-        error_report("SEV-SNP: failed to insert cpuid page GPA 0x%x",
+        error_report("SEV-SNP: failed to populate cpuid tables GPA 0x%x",
                      info->cpuid_addr);
         exit(1);
     }
-- 
2.25.1

