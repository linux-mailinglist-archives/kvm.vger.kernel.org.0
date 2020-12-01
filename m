Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09DA2C9447
	for <lists+kvm@lfdr.de>; Tue,  1 Dec 2020 01:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgLAAtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 19:49:20 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:4864
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731119AbgLAAtT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 19:49:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGn07hjKkwIteZ8Iy+RS4xTefEBI4rVuNbsX8GRwqAL7aF1Ivp4LoKjoVpZjnDuEvOsb9XPytnZuBsMxoAfyYVaG8D3Hk0r4shpBrznd/0Oi+WjZOLD7LjxDRjcriTCHAcJQOv/ok914FiVBiZk5OFqo1tukvu/WSp/2GHMYggMBMUFymrowHw0sysKBQ2ROOPUnH9pK/zv7qsLEtG47lQedlpnDlpoioiLt/8JmO1LDftg6eHVkyikTUxxN9OLo7e/eLhmqyamPHSZKYmiahI0Nobo3BWoRiivJZtj3Qw+3Ge9cE5fx+txsDlfLEXpNJSx2Yc6x9KC/UO800HdytA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMm/eQKJw+rQ14sDUPcwk4EWWQ3Fl7hyawwQTrrgXy0=;
 b=NUJtgYS5na71kGbXyMfjLsocNiw3kjm67R7wXekw4iVebdNp7h3w0onlH87FxTbyvQ8QK9BlNvuA92LoYmKAJGGmjZaqAkEmCusw+4Y/UmuXBAFHP7omFxyB9IhEppSP5ICyT2ZzN1u+qqrR04DbtS+DewQ5BB5OXpzIl53yAH+jrJGkwhtgR1VUaNmMWDHaoKgb/ACheAQQMDX78DEa+o7GNeze8lSqFQGr5oYHAowVwmFX8GmRUXgXzyvJF9B1XHrGuI01a/A6Cdw3tT6x3DuxCMpaMfyGIsyBicG6b04FunM26MR318n/iLtoFNcwWYZnBTcODNfRWyJDrcBXfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMm/eQKJw+rQ14sDUPcwk4EWWQ3Fl7hyawwQTrrgXy0=;
 b=q4xDBKV3YFe+kJDtQO7sKcaP7huDNyp6iIRFK70nso7swN2pWlWEnFLF3r/VYeAkHS9dSasn9hrzhij8Ee9HQTopqXk3B8aGMIyaDYiicYzUNgMMcptJsyn1QUf+ENOoLB2nsSLI8WZ8N/EbeKyBnTPsPg1o7HtlXbV/u12S/50=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4751.namprd12.prod.outlook.com (2603:10b6:805:df::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Tue, 1 Dec
 2020 00:48:50 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3611.025; Tue, 1 Dec 2020
 00:48:50 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, brijesh.singh@amd.com,
        dovmurik@linux.vnet.ibm.com, tobin@ibm.com, jejb@linux.ibm.com,
        frankeh@us.ibm.com, dgilbert@redhat.com
Subject: [PATCH v2 8/9] KVM: x86: Add kexec support for SEV page encryption bitmap.
Date:   Tue,  1 Dec 2020 00:48:23 +0000
Message-Id: <515cc3e05fe96595371b393b89fd376ddc87b324.1606782580.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1606782580.git.ashish.kalra@amd.com>
References: <cover.1606782580.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR15CA0057.namprd15.prod.outlook.com
 (2603:10b6:3:ae::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR15CA0057.namprd15.prod.outlook.com (2603:10b6:3:ae::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Tue, 1 Dec 2020 00:48:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e1c2b740-5b00-4e13-8737-08d89592de50
X-MS-TrafficTypeDiagnostic: SN6PR12MB4751:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB47519F0817C66F34A6F374378EF40@SN6PR12MB4751.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IodMQR0/0sok8l9FTazx2i0d4fvWaDY+qKVuHUa5yBE+x2UF85gGxn5DbhS8YeCpstjAFzDoeyW9BlSXtOm0yhKktpg0M6UpkybxKDGQTQF8WBd51My9NqZL6Udf1v/LfqjLkdOPOvkIe32vB0hVpO3K4rYjJWYUxyzu6CY+qO6Is/DbAIDRDt91baczbDCB1UBa4OkGMaPstzlc6hLtLICgnEMt7dI6mnpWoT6R7djPELdJZ6KZ4zTgZiky37kanv1j997HD4HCCpvX1/knZxxcolvE06933dL6vgMmpNqgwgCqWVUmtllt5jwQ/Vkxh20zJJRA9USX3+Tj30OEew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(6666004)(186003)(2616005)(6916009)(478600001)(4326008)(316002)(16526019)(52116002)(956004)(26005)(6486002)(7696005)(8936002)(8676002)(7416002)(86362001)(66946007)(66476007)(5660300002)(66556008)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8VCpEiuxNq5thbGXf1xcYv2cAcLU9MKq2W+MYSkexn0P2R9zMrdYmtn9bWhP?=
 =?us-ascii?Q?ix1QtPrlzYcrHoG4CX3iULkgns7GzHUQx60tMSh5kSglBXEqZ7ntJDdtrSt+?=
 =?us-ascii?Q?eFCzvL4gSB9Iz7Fyo2zV3MRGC0dj8GQIog96lfRrHSb0mKIg62ltv8+TLDip?=
 =?us-ascii?Q?CQSiFeo+2gnmShWhOnI8BldMe0GoshhxKIgsnPbYFB/SXIVVc6WmRQWKl20N?=
 =?us-ascii?Q?iXmZdKHA5Q/FsXy1lPObjcwwzqRV8qKB4bhQxu2WGBbazsDOV5YG6IoXkRBE?=
 =?us-ascii?Q?Y3zpHSnhR96mmwdXAdCeLyTtDsi+CaM/KcDDScrct33smO3JV1PUoOZ1L0iG?=
 =?us-ascii?Q?EawmxJ8WBYlnVCFQNKrp7VkzG+zZQRkIEBmnqoWiIuqq2X7DqmTzkfC/PWBQ?=
 =?us-ascii?Q?H0GpkPcdEW+7M+vz0SYINR4c7AV10xqPrLoWA4asbRu4UA8e5GtPEJOQIkac?=
 =?us-ascii?Q?++atBK6PJ2zneB7W54YVB25PEGAc81xGTHBUnhUZIh+7tNk0oGLvOVr4Cvso?=
 =?us-ascii?Q?FGsRykhmqwYHM/GUK8K9xIiO9ZtSIPTAHc1kQlCtV3k/oXqya/a1YJeraEtv?=
 =?us-ascii?Q?cNHS44TE6tO/ckrWEgxMHUSvZFgE2o8pusFeO007siTX0XndbZlAQoa8WRIk?=
 =?us-ascii?Q?urnUblmRUsQ3JlfTVvFgUxKJuQWjHS8kVmCU4qjC1pGy3+QDLhoNG8Uw44yc?=
 =?us-ascii?Q?qffrj0xkmUXbVyvjG/pDzu/+Q0hBxCdGFZFxF6tNh/ogwcNesjeCxN3BvJWr?=
 =?us-ascii?Q?4wFrfUiBnbeI56Q4bo6DIWf4uPmJ/PPvbvFb6xkAHS21PVhYNSoc7tBcRBcO?=
 =?us-ascii?Q?HJvVfNbkjkslMjaRYBQuhyyqQG26+7KMxMIllgS5Np3u5UI/2C7w2/tO9+/U?=
 =?us-ascii?Q?7ou028q8Dx1RnUFAigezReyrBGMSZOxeWs1X2GLE/vJnJrno7Y7mR8l16wWg?=
 =?us-ascii?Q?fTw9WhqWkhMJ3vsB7uRlmAdTUUw74aopUXKuxtGu0qywjr9Zpd/Q7F1DHWsC?=
 =?us-ascii?Q?1ZfD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1c2b740-5b00-4e13-8737-08d89592de50
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2020 00:48:50.2047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u9xjxe1XZTqQF5yxd34SnDbgifMl6HHPdHnyji2EROnBwKVHtXSOggvmum775+YEkV2AcRuOltJV9fC9ka/89Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4751
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Reset the host's page encryption bitmap related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
page encryption bitmap here as we need to retain the
UEFI/OVMF firmware specific settings.

The host's page encryption bitmap is maintained for the
guest to keep the encrypted/decrypted state of the guest pages,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7f57ede3cb8e..55d845e025b2 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -38,6 +38,7 @@
 #include <asm/cpuidle_haltpoll.h>
 #include <asm/ptrace.h>
 #include <asm/svm.h>
+#include <asm/e820/api.h>
 
 DEFINE_STATIC_KEY_FALSE(kvm_async_pf_enabled);
 
@@ -383,6 +384,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
 	 */
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		wrmsrl(MSR_KVM_PV_EOI_EN, 0);
+	/*
+	 * Reset the host's page encryption bitmap related to kernel
+	 * specific page encryption status settings before we load a
+	 * new kernel by kexec. NOTE: We cannot reset the complete
+	 * page encryption bitmap here as we need to retain the
+	 * UEFI/OVMF firmware specific settings.
+	 */
+	if (sev_active() & (smp_processor_id() == 0)) {
+		int i;
+		unsigned long nr_pages;
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+			unsigned long start_pfn;
+			unsigned long end_pfn;
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			start_pfn = entry->addr >> PAGE_SHIFT;
+			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
+			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
+
+			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
+					   entry->addr, nr_pages, 1);
+		}
+	}
 	kvm_pv_disable_apf();
 	kvm_disable_steal_time();
 }
-- 
2.17.1

