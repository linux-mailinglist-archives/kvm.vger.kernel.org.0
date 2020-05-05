Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836E51C62F6
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 23:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729195AbgEEVV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 May 2020 17:21:58 -0400
Received: from mail-eopbgr680053.outbound.protection.outlook.com ([40.107.68.53]:50171
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728584AbgEEVV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 May 2020 17:21:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkoBs0EpDKrn/TsTkZbUoB5S8d7q6WvMtKzqOXAKAD9xPESkAIf3dypV9xO8epHUzWtxxoyhCRirpES3v7375nvIO5DM5wTvWHw2Ii4rgdsmh8pPnQrwvWp2cW74hzHIUalAY6cSmRwyUxVVPWRoWaJDzY+fPaAYKCGoxNCGzgzx9ysIY5+SUl3QM18PkGZlt8BSRIAhiByo6cr3k82qWRxMay04GFpJKYbagZoocfy6mhzd/9DDwT//2vOXcH04OBh95igMJ1oo+djxHOi95zlD0ITy496WjzUeyCQq1JJxY1Z1Z0X+kb7wt6rAm035F2sw+k4lOwR00DnpZS7w8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRen4pFPZF/iqIIqXMSRdOmlGqIWpQk3u36Pdq3rBKU=;
 b=n500X0B+SsTZ02X5bygbbx0ouqdxWVp8Y8Q85u3j+9e9soQbYPxcLZO7OSSSOV7qauunksnZUMg0CZon5/HMbMyogGxN57XL2j3QqalDdCNqugzSqjCJelaay55HXMPqKcjcp7qPRIF230Oac8tmYHYQJHwxZmLGgPsOof0bpcuosqSDyEy+26eQXdrbs2Sb7xk73ALn7pDvJ0XY35X2n/s1ZLG43HVgGdPIf2npoZN5Cl86yCHgN89ZF59l+ZQYbk4CIysI9GTMP1jrJLLMOsGHFfuNxuvjuasF8sWTq4wtVl1xOTQfLy8Z3YyxJWoc7irqphWym6TI+djF3zgpqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LRen4pFPZF/iqIIqXMSRdOmlGqIWpQk3u36Pdq3rBKU=;
 b=vedzh/8cwel7B5k3sHqssn79OJI4IpZgn01JNKR5AINrbcKCMMzPgs617vsCi+XG90nJsUt6rStl+smjv1Mq24YcMm4foFd+ZCo9fUt9jyYBtCxYgqmYQgo5iGZClAgDJrf4aZhIgWRwgVcoSYvuyzTDvWp41fPqUFX7ilxMGWs=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Tue, 5 May 2020 21:21:54 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::6962:a808:3fd5:7adb%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 21:21:54 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, Thomas.Lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srutherford@google.com, rientjes@google.com,
        venu.busireddy@oracle.com, brijesh.singh@amd.com,
        kexec@lists.infradead.org
Subject: [PATCH v8 17/18] KVM: x86: Add kexec support for SEV Live Migration.
Date:   Tue,  5 May 2020 21:21:44 +0000
Message-Id: <697cbb9301acf18296b65bb63686b6c0d422e382.1588711355.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1588711355.git.ashish.kalra@amd.com>
References: <cover.1588711355.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM5PR22CA0019.namprd22.prod.outlook.com
 (2603:10b6:3:101::29) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM5PR22CA0019.namprd22.prod.outlook.com (2603:10b6:3:101::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 21:21:53 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 17b7dd6f-675e-43a1-a819-08d7f13a55a4
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:|DM5PR12MB2518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB251866B643C0A84403DD3AE28EA70@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9SQKmArPcpvLceDNjqj2kamGeL0F9TTIZuqO/pI6HsU2kB/zC3tRh9Lp2U8VSt6NaEDpwfXpaal9tTb/Q21EVzaTOxf8KUJglqQrOMjVyqvFrD4PaQYKE+6HYnSR0IPt5qpgyjiBAQSiqealfSxMQJrFfrjvLTdLLY21rShNCfAPHo48vF5ntY9W1jhJ+8sJ7jhwFAwZl4+O2Opq/D05HjIFHVtR+ohzLKKvaz+2Zp7xz0Va6q6U6iYQapbxQeWF1f5RY5xVQJRLEI8J4uyGvQPXyJKPzq3FwIkihkBnRX4cGyAe09dD8lGd5aIxah1oyosbgfyJ/kDJZXAG8P6545QoFAuGq2EJPfh84ItRCzgo0ws1WUmfSYU1Z3To5LhkdWnGetx3BAaVfOGpBhbOtqkunJeGUpZwei6KLqk7jVdINLE/SFjPpESal6YjRtSpmoX6XvqcwJ1R2vpAjg6ib+5/ZjL8bC/9P1rYdjaNGlDC9RBC/ksWlQQshwj8afk5t+WgZSbe5w9dSPvtDjOpLl+YTG3UnvFjWvbT8icIhP+30khNr2owuMgBbVtJFYzM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(33430700001)(86362001)(8676002)(66556008)(7696005)(66476007)(52116002)(8936002)(7416002)(4326008)(33440700001)(316002)(66946007)(16526019)(478600001)(6486002)(6916009)(26005)(36756003)(956004)(5660300002)(2906002)(6666004)(186003)(2616005)(136400200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: luXNGpqSXp3iI+YgYq05al6MSZC85f4OrEvGEpLyUCTHUIdJORgXjZetT0kEZ3DZv49jC9+msbRlB86Efe+jWKtMo/44GZtocITAx/4C/eNJgmooWxKTO1gvEwYGs0ac1F60jqdFcq6E3okzd5Hfp1tey1jDaSHQgI+D92X0aR8GLaTnW0gTXOiTj3IUws5euSJX4UbcMj81CUok5S7LQNFWqDwIcFGNBahWCDIgJQqlXDFvfLe/DJ6oEQYhNjQmj1/sAFGj3pHP/vCbWle4E+1i4I9I/Ldsg9Xqt12esMisctbDCYEDq+lhitX6zrZNAUnwiHBTqmEboS5OQ5fLq5do8geDfhg0AaKNpMdj8YuCabJAi+vkQv3VnqWAwdG29MtVO3aWGtZPdZWzrEOSUj8cv4L2l3mG7X8poUW9JqFb9pGQ7f5naHpHJGINbeon5+Fh9me0FN+O0KDPMcrq13Pqb/RHFih/dovY0yAT5g5aNHdQ8Gxgdakxg099P499nZmWdg3q8LvfJSiOBCqwVgucluR+Z1LqJGTxeuRYhD5TnQrYsBFehMd3lcgkc6R2Z8yXLWy8AYxneisZUtmVX9uNYG6Vu70rh5IkqWB9lzK/Li1lk1+NlLNp1ZgF+HLJEWZL3lg19IdHnHK4V0sCZ53R/vxmzpS6m1MgTgAGtgFe886YXhlT9WD7ZmbfnOm40nlovFRakwTL5YEP+XfM73x94Sy7l/VJD9pgZ7/YU2CWRAViftaP5Rvaa85YNdfTQbEAV5DJRmgyin3jvin7i53ek2p4JfPbqaQvztgk+IM=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17b7dd6f-675e-43a1-a819-08d7f13a55a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 21:21:54.5605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u0Xj+Tg2M+yb/dLIO99F/dGxozVbBBMJnBOs8weCISMOH67FnyKDOXGDq6Zahr4lElHlEmEX3HoXGi1gG2V7gA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
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

The host's page encryption bitmap is maintained for the
guest to keep the encrypted/decrypted state of the guest pages,
therefore we need to explicitly mark all shared pages as
encrypted again before rebooting into the new guest kernel.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kernel/kvm.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 4b29815de873..a8bc30d5b15b 100644
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

