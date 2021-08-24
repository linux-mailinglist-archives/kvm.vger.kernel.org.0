Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D24D3F5CD5
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 13:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbhHXLIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 07:08:47 -0400
Received: from mail-dm6nam11on2059.outbound.protection.outlook.com ([40.107.223.59]:38497
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236606AbhHXLIm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 07:08:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfF3DQoP4o2FcJedClMWup0TDNZ7rEPPe5P0CgvxiGmZs3FiHq1/q5c1tNtoPIwaxTv3YddEB5eZRgVAJUrgpXbh3tRlGZegyFBecK4HN+/5Js+M3Q+WAMBWEyW33fMosonkFK2GwLfRDZbuPSxi5FzWUfnP09hR3saBvG19gyFutOwt5Qy+BZkwPjCW/klsuq3s4C42XGOlw/FHAourOkeOnHGo67mRe0F5/IyHvHa3PaRyuE9qDrBnWx/imLDuG573v5Jy82VtlXlvxxuNa/PCbEyKEA1gxTopZPsQwZhwoeap93eKapuZN+WhZewP5zJ2AmgnSQhKmCMR3h4oMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSdJXXgv4wIE3DgoSk3huqwGy0iT0Qq+ISanik4sM6A=;
 b=L44pXnjfGujZSzs9yZUGcrxZtMcOvq9+GFyQBbnMtjgdhruSqt6z+qobXHQAsD2YCJtdw3iu+9aIhdQ7qGwKGuQVkVPa9ELpgPLPKUFv2vNT94D2UaLI1fMWhl8TjuCHbC98my49lP26ETDM0O5zlcpohNugwhDDxz46UlXvC0ne1FeY/4WB+ihxqM7hzwSMJcWle2K117WPZRPmPsjiBYMR1ob997bhRxbbFRY/1Q9b+DgyYOMyH+eF5/38/Yd6Rr0RDmy4Xh1LbxHZP/OywCjheSlfwDN3WOpqL6PjxB3fWXJU4m6MW0p57IemunQqO9udMHJLNJVij6LpmLJMzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSdJXXgv4wIE3DgoSk3huqwGy0iT0Qq+ISanik4sM6A=;
 b=DbBwNi6+i5CpMTJVIIT2qkRMV9lYZ+AeSu/ESTTlq3bK6OxlCVSHZzfICF3UfMwiShz2waJZ937VozVJPe5DNjSnk0Ig91aAaiaUHQK0IMKGnU/9t/rUi0HSTA5OvF5wBOvOjxEYDFM0snt20I/FEoKlcQYs6fN0FOAXlt4YMwA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2637.namprd12.prod.outlook.com (2603:10b6:805:6b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 11:07:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 11:07:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, joro@8bytes.org, bp@alien8.de,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com, dovmurik@linux.ibm.com, tobin@linux.ibm.com,
        jejb@linux.ibm.com, dgilbert@redhat.com, kexec@lists.infradead.org
Subject: [PATCH v6 5/5] x86/kvm: Add kexec support for SEV Live Migration.
Date:   Tue, 24 Aug 2021 11:07:45 +0000
Message-Id: <3e051424ab839ea470f88333273d7a185006754f.1629726117.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629726117.git.ashish.kalra@amd.com>
References: <cover.1629726117.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0201CA0015.namprd02.prod.outlook.com
 (2603:10b6:803:2b::25) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN4PR0201CA0015.namprd02.prod.outlook.com (2603:10b6:803:2b::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 11:07:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be13c8be-1947-4037-68d0-08d966ef6d4e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2637:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26379F954164510601D64E208EC59@SN6PR12MB2637.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: is+lQwkywHe8exxFtQwrqbyQZGSeM7Z7V+RcDczg06pNTZjGf6+/n/xNMiWhL/l5+uyLyZalW7Ic647LFr6ZFxb3eG2EFylgBLBD27WxJ4QN9Ck69vDaD0aHJj4gg7WuDQQU6GjnQzH9QtTz7B3lbb4lsJmBlzjwKh3/BYL+yezvY+I7gGf44pzOBuoyp6XKhGX7d1N47rzWXSl3QLlWt0+hkS+Fqo2z/gcPMmAO5vDAzfA39Dq8eG6H2h34A/8oc2dBkHrj3PH3//QkeY2aBLjDmqEGfwrwbFXfCJJtXgoFsaSVxYKx8WaN/Viht6d2HYyniIm+OEKLnO64PyK+BVWIOvWvPV9WIbe1pO/cw5ukGGDzJ4x52AdBfLYJkLdw+ZGDPZgp9EkCenx5IU/vgs+S40u+w5BZn14Okj5VDirUoeZ9omj04pATGQ02c177Bm8f7iui/4JipdjkM0g5XoFvPoDT81UJ5FrrTWVLwq1XKgrFAzasmAvfBa8oFWZhH/Cg4ycWkoK5mM+a+5gzAMqNvCe76KEl8z3avWXLZ+auCma4FtKkiujDdZl+WXpZAFU0079Iq+LL6dS917vAlJIijwbB0XdWBH9T8N1T9kNmRW94Y1htD25hDZY0qmk32IOmVIqGQf1ILicyKQ1aBkyD4QR9z2IxefVtnSxuYbZds2xrYcRGoYNFZrsBzwaEWJEvM/qyTldJx7Tf9+9ilA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(26005)(38100700002)(38350700002)(7416002)(478600001)(186003)(86362001)(8936002)(5660300002)(6916009)(6666004)(7696005)(316002)(6486002)(2906002)(52116002)(66946007)(4326008)(36756003)(8676002)(66476007)(66556008)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y3M3jXjeBIgMSLjB7hABWSorf0vlisFixmrxoDVrPcD+6/ZQmilSXE9vM5Rd?=
 =?us-ascii?Q?g5NGwTsOA8p2kvFUV1RNziMxkgXV7/4iJetAwkPOR5zD2BzVPALmriE2tlpd?=
 =?us-ascii?Q?I6JDNnT5BHjbgHHAvd1zxOgUEBdZXYJIbr6t11Mkll4i+lsBptiqr2+vjERb?=
 =?us-ascii?Q?AWG7GrQLSZWHej0D5nt4eftthSY+sfPfg3omu4uLHKbI/OmA0/F9fX8E+kQB?=
 =?us-ascii?Q?F0SS0QrmmWWgs2jo7zFbtgakLL8JrI+F5Add8aeKudSiDJuUhJthH3nwlYus?=
 =?us-ascii?Q?SpC4fRU8HJGI/c6YMEM2D2fYdBjua0Hv3F4YF88J0C5TZ3m7xIcgwBIUmLCC?=
 =?us-ascii?Q?xudtt2d5kGAXWxL9zY80b31NvA5UEay2/xa+C1z1Oj4DObj98zkM/FR/KX0/?=
 =?us-ascii?Q?YxKL3Sr+s2juYbU6kXVncG7yYB/7vyZDizPV6G0ul9PvcpJt2OZgvn6pxgAr?=
 =?us-ascii?Q?pTW0QUY54eu4NdOosKvlgxpqPDPulw3qPaCYuFXM867GvK15DwuAn9Oriso6?=
 =?us-ascii?Q?iNi0cremDzzQwAQYR7oL6dplOn2WQ4P6nIcMQrOp+pxcIipAwCQWslNp7oIN?=
 =?us-ascii?Q?vxcnc2UXisNUvYP3M/Y/f90jc85fSAlB45EHk3ORz2DE3dUYRQKqgnRZKDOB?=
 =?us-ascii?Q?Ng3MvyXnTCuVV9bWgdwqQ4Mbo+YgujPLj3BcV2zSUmTFI1A5wrbv8ALkIKWE?=
 =?us-ascii?Q?T1VeMGTUZOtzD9jqfqKTLTJoRX4finia10eM5j3JtwcN6YtIVJlBzOOZNs76?=
 =?us-ascii?Q?URPuYP0mBpTDIoOaiM9UeWUJXlSMfYAQxXbB7VD2GExlYOqs1wa5PTwFpxqH?=
 =?us-ascii?Q?bT2aVjNvcXo5wEGJ0HRgzvB2sBbslW0iLorTRMifxUiBdFGMpiCSe5LdeAfv?=
 =?us-ascii?Q?SrwB0+EupuRHbCe3+R3hs2ruJC9gXje3FEUVuh9ceFSUeb4+d9bH59/oXveU?=
 =?us-ascii?Q?okBcppr6RDusO4LVdZ9G93UH9Xhgolrzyd4wLQOwMJAWyTg7h34oWS0zektz?=
 =?us-ascii?Q?w+lSda4qG95C614hOM3HHnf2svqnRiLUEyaRqUtO3qYVF9QXrCykmnObwu4l?=
 =?us-ascii?Q?3e+s0iWVb4bFHeG2GHO5zcFmv7TiwWqkk+pnHmIjhXsU5mBAzOJOhu03/m3C?=
 =?us-ascii?Q?MTCF5invGQ8Doh5LBzlOQlmNWfLXetFGY3DYN0Iz6lCsMys1HdtNOrqoSyfa?=
 =?us-ascii?Q?Uhq0UhK1W27bgMDMO3JVJgIKavzYkOydnsLPgvHeIFUtwC0uRcsNTcz8M575?=
 =?us-ascii?Q?hb+jEUFDg4TR47PP3ya0HVXkLpdYkrVjHO8P5DKlhXqQfdYJg4L89KkkCaaa?=
 =?us-ascii?Q?Q01q6Nepw+aXYply+NH1/GgJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be13c8be-1947-4037-68d0-08d966ef6d4e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:07:56.8376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 05alGUCSoIdvf/j5aASuoxD2v1ebPT3daDVwhOZxS6bdO7YM4gn2E6NgHW0sWLTq2KqgbuQy/ORujKDVVpgFHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2637
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Reset the host's shared pages list related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
shared pages list here as we need to retain the
UEFI/OVMF firmware specific settings.

The host's shared pages list is maintained for the
guest to keep track of all unencrypted guest memory regions,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Reviewed-by: Steve Rutherford <srutherford@google.com>
---
 arch/x86/kernel/kvm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7d36b98b567d..025d25efd7e6 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -869,10 +869,35 @@ static void __init kvm_init_platform(void)
 	if (sev_active() &&
 	    kvm_para_has_feature(KVM_FEATURE_MIGRATION_CONTROL)) {
 		unsigned long nr_pages;
+		int i;
 
 		pv_ops.mmu.notify_page_enc_status_changed =
 			kvm_sev_hc_page_enc_status;
 
+		/*
+		 * Reset the host's shared pages list related to kernel
+		 * specific page encryption status settings before we load a
+		 * new kernel by kexec. Reset the page encryption status
+		 * during early boot intead of just before kexec to avoid SMP
+		 * races during kvm_pv_guest_cpu_reboot().
+		 * NOTE: We cannot reset the complete shared pages list
+		 * here as we need to retain the UEFI/OVMF firmware
+		 * specific settings.
+		 */
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
+
+			kvm_sev_hypercall3(KVM_HC_MAP_GPA_RANGE, entry->addr,
+				       nr_pages,
+				       KVM_MAP_GPA_RANGE_ENCRYPTED | KVM_MAP_GPA_RANGE_PAGE_SZ_4K);
+		}
+
 		/*
 		 * Ensure that _bss_decrypted section is marked as decrypted in the
 		 * shared pages list.
-- 
2.17.1

