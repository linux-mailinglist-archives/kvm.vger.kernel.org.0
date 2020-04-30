Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56AD11BF365
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 10:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgD3Isl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 04:48:41 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:22881
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726611AbgD3Isl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 04:48:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lqz8ct5ikjwWKAYzQ1Gi6ukBN2WpuugrQ1gL8sP+hXhKJ5enSELQVoVVgnUXnqG8ikUR509HWM7B1mdTDiOCpGoWH2itUjTjRkoD54YEEEs6PJti9FeNNmikUJCYDkcaj1Thw4q+xQNsWIrU4YEPaxaaLOSBbZn4cstZA3PIwB2VyomfNfg77YvBHOKK14BUunXVgcKvRs+ZMLrBT/9m9u1HHqmhu1urpilxFJ4rQf5fqutm8GXPpqajw92Vp22MGjZ8BZlUUQ9RyzVvz90adE/SGbOyTjJKsKCHlk18m2rw7jSak2e1vo+QG6BkUPPs+5+y1XJayP89Ss/uwn4RXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMnmWSXOVuAuctdePqPIk4ECMJVF0D55bCj+XKGA+uU=;
 b=EwbxZEqUXHV3Lr5czEyWvDtebDwyplWnWTSp1JqrSu7m57eH+qF+NFhym4tHsYT5ziM1E+F06Lk7oJN0yAyWVtZRZYZ55B4VaG+eootnbFsavHgd9vU3Ls5s8lyrfR5qv82owUHoQMysCm2hAdO42jZXRLT/9/TsxIHMwfSGJUIrxjM4YGYVEpRn7qFHBrAB9IzWb3ifuxFj4i99l8o59hpMzHmQUpfuFxnNrZyUyJGodwFYHeeuepEWCUswdf7j6HzVqIYGO2Qv9POuwfmB+gPzbdaeyTWRBx3HMoF/XPSpZviB8vYS9WCXiOYgrreyvYPxx0uT5BJQwYwgRV+/wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMnmWSXOVuAuctdePqPIk4ECMJVF0D55bCj+XKGA+uU=;
 b=UoP5cDTk9XQMdnsbWT1sP9ZJZKAz6SJ+9WTKbLWzM4gAYDCeH14WHkymIGfPONH07u5/Z6eDZKZVQcHx/BStB46lZFZ3eck+ugcuvwSRcln2YMaBd2Bwbo8FbgGUt858/fxV7rOPmMyyxLUFc7u6y4/gnhAqXCBr6Rp+TwUYYGA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1883.namprd12.prod.outlook.com (2603:10b6:3:113::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2937.13; Thu, 30 Apr 2020 08:48:39 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 08:48:39 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
Subject: [PATCH v7 18/18] KVM: x86: Add kexec support for SEV Live Migration.
Date:   Thu, 30 Apr 2020 08:48:29 +0000
Message-Id: <0adf76ea0f88e137bef5e045ebf96ebb004ee8df.1588234824.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588234824.git.ashish.kalra@amd.com>
References: <cover.1588234824.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:805:de::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR05CA0016.namprd05.prod.outlook.com (2603:10b6:805:de::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.12 via Frontend Transport; Thu, 30 Apr 2020 08:48:37 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4ed7b96d-b898-453e-235f-08d7ece346e8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1883:|DM5PR12MB1883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB18834D26B280D7CF6A4FFAAC8EAA0@DM5PR12MB1883.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(366004)(136003)(376002)(39860400002)(478600001)(86362001)(956004)(8936002)(26005)(2906002)(2616005)(6916009)(8676002)(36756003)(6486002)(7416002)(4326008)(16526019)(186003)(7696005)(66476007)(5660300002)(66946007)(6666004)(52116002)(66556008)(316002)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+HsTCYEW6FdZIthQxJbm6pL1Nl+FxJQVp09/rh0kiem0AxDlZyCxAE/9dPTmdModyfIoYgzshaPnjTVurKsCs6pjTCVwhp1fnSAaqimJMkPyne5Or5cxkWQarJWVlM4Ae+bHt+1Ez79zXDRNIPdXSIljLGKFCcoabk0KHaa3OcycxT0TKCdrmBmnHLc2bagphc9cvWvQ6FgfsQi5HI5Vq1Rf0Ix0oPmE4fjHRPSB0ADMeXWbHPJGd7j3yd7c7GRwUYxXU9/Y9/wSfYHSWGE1gNDohpcZn9+HCd0szuhF6qtpyIBPIcFa6HS93k9KXIJCgxUXCjiAgNVxhrbjdSnvaUw5xVzvQm1JTh4d36avowcHrZOYxbPqfBcJMiAbzFBFeFHnxy+ekaVpO1G+iRXSXpGvtelWyHV9IrbT/GvLELv1SRAz7Fwa6Ui83fEqt1GWVp6+WNWQo7TQQKI4rtYBvDRQbwapKKDLLf9LH6PSBUSRhN9c8ggzWdRiXE5buB8
X-MS-Exchange-AntiSpam-MessageData: hklji63G1mQx/Km/dj7Y0UVbSP4x4/xnziRt4TLpNiAAY4ffPSPly5bAmN8bGg2//bTT6TjKTsw46YC49yeagMarSLN1WWKEjY3moYE8PqyOhnDRLt8uyOKrFh5trNfPpcvDZ9C/ROFUA8ZFM5WW4F/Uc0vn9Px4AgYjsGxSVl/FDsiZlZmbwcQKMB1co+pvS0EiLc0yurGhjdBy2fOVE3+V+Bki62GJx0oRRdVeP+Bs0knXeh/kf/348zCZYleZSmTHrhzvyVZIxbRjKldmJ7hiIGlG2E12Vl5oeidNNJRxIZiCO8TJ4e9MJYZ0rI0PBCqr4tiPEfuW1YgwTzq3eBDGkPkoPMtshwPAAwBIlTUxf+5Qs9YBkudOZyo7nEt3xYtY7BdXO7xd0MrE48bWmL3U5OncG7MwXztpJF+shu/rwPUeLhI4jGeVkGNqYI2geNs1NAe+U1nysVYythTpHyFLXwpX5ddV8p9SxQtpcR3hCnZJ4yhpq0/CmBn2/f2XUhB2w+VtCo1l0NzMzhHKs6ML0ESEH3ZPpNX6pXJ/ES5aMnBxogmIrY8/iXCz2xcP4mlCaeeChccA1tXCkqpzzS2Zboa7r4e8+b+Ws3YyUGluGxz/GxRfT8DxbWgliTXmwu72K3KgO4MCSN3iBtfWHj0g3ugl1O/61b39uANQlv2x9Ns/DszjJMGyQa+2lJXWJhwCzaAr2e4tlLAHrur4HpHML6fJx3C06DKC/KIdooTistD8uEDOQsKNny1Ld4XnNsYeejJn/iJybOF7piyYOlyjglG5MPZ5GHoNgxSe854=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ed7b96d-b898-453e-235f-08d7ece346e8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 08:48:38.9523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYA9XJorzJVZIF1Q+62mPXLTQSFaAYzgTFj9zroL1yg4CWBzUZmanD51TqFSi10gCv9c/Y/FOzMU2lS7DMxfDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1883
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Reset the host's page encryption bitmap related to kernel
specific page encryption status settings before we load a
new kernel by kexec. We cannot reset the complete
page encryption bitmap here as we need to retain the
UEFI/OVMF firmware specific settings.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 8b8cc87a3461..68f2de4c1e74 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -35,6 +35,7 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/e820/api.h>
 
 static int kvmapf = 1;
 
@@ -358,6 +359,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
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
+	if (sev_live_migration_enabled() & (smp_processor_id() == 0)) {
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

