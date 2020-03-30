Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3446C197474
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 08:23:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbgC3GXy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 02:23:54 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:19623
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729089AbgC3GXx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Mar 2020 02:23:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPfz/aOdB7l5EfDeCFn4rYu5vNv/0qE4h7rnHJcT3+JpdHzTwFUbcnQ0+byxMq7roongoyjEXzhLpKBwmUlYiVlEz8lvWuDATZ1hd/jv9qncY6M1wXEcdTtmYoPXhGQqjMlqgRMYiJME9WAm2aje/aIbnTM+7kDu/6nMWXcx6X+9ZhICMQxQXp9EuarzGu+KAKg8bNZoKCbn0Uvc5P1RoY4suiYD4mYf1S9wdEGPc3kIc2dYUQrCAq55NLMLnarH0AQ4z7Js43NV/EPVvCWPCqiz7xFMmTumI3PO4uJ5wHYli5EP09hQqzo1ZolIcgBmTAnahuN7cynfr9UkfZETpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aodWKOdHZfBvB6+8w8EpuzzbFUtA2r4yfbVD9G2bT3Y=;
 b=jJ0+SrEETzjEuMaxP7EN0+j0C7los3qDqPXjHIlammvuZP0XtLq7V0NZs/3u8JdhgIZWZGUeFKJbKa7lftGo+/KGo+bGEsSVcENCp0n3EQzG/zT0UIbT0b6nuL282TZ+euynfOjXnNPHzBK2aVW7SOvYEanjZbEm6nz7K32WSWZQgJNcOl7z9TOGAdq9RF+2/Xj6xVLnMHx1kh24JgMHJ+O4zdgpWzMHE1n7wz38Cs8DcOhrRDcU2TKTPNc5VctNVavNripHXF4LowLHi6ogJX7bgDvGWW8BcaS26oTApPEkAa5a4QxQ/LULVP2mi71zpvUEWrx8di5YaWJm9niKYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aodWKOdHZfBvB6+8w8EpuzzbFUtA2r4yfbVD9G2bT3Y=;
 b=PlAi7qT/9oOYxTmZRVyfVWGRoTtk9naNkDPnUE2FqffAykBJ4abxvmsQb5gdKT5gVTrL1anRzQh01Wt8qlH3R1/yGw/ogegTLMQzdlZinso5WQ8c1ejrVhXfJxdT0tmQxkshsiYj9mDChEiswm/9LIetbqHjjQ/IvnsLar2bITk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1692.namprd12.prod.outlook.com (2603:10b6:4:5::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Mon, 30 Mar 2020 06:23:50 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 06:23:50 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v6 14/14] KVM: x86: Add kexec support for SEV Live Migration.
Date:   Mon, 30 Mar 2020 06:23:41 +0000
Message-Id: <0caf809845d2fdb1a1ec17955826df9777f502fb.1585548051.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585548051.git.ashish.kalra@amd.com>
References: <cover.1585548051.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0108.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::49) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM6PR02CA0108.namprd02.prod.outlook.com (2603:10b6:5:1f4::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 06:23:50 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1eeb11ef-ece6-40dc-3e71-08d7d472e998
X-MS-TrafficTypeDiagnostic: DM5PR12MB1692:|DM5PR12MB1692:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16925A69443D56C147736C4A8ECB0@DM5PR12MB1692.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(366004)(39860400002)(396003)(376002)(66556008)(86362001)(66476007)(478600001)(2616005)(956004)(81166006)(52116002)(8676002)(81156014)(6916009)(7696005)(8936002)(5660300002)(6666004)(6486002)(16526019)(186003)(26005)(66946007)(316002)(7416002)(2906002)(4326008)(36756003)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PyMV+6T2dOh/4RUDAwz1Ne5I1u2hM/YqpnZ9HbLEqJxQAQdU1sUWknxleaqwmAaPqMqUXP6RGLY0+65cmHk/ZDmnegNmzucZHpxAVqkA0lpIakgIiZBFGjrROOjk5MDwoMVo9zF0jRhNPWZy2KlkOikCQv72zICpFnzHvASFcJ+wlHFkp24QlWiQQKO0aHqAdcaZjXCmO0vOXN1F8wgTF50/fqJVHd6snygJQ6Dcg4igw7rXL+ai3uOm1+3l1Y3P8DlVP6pNIlPqZtbFecOdr+kSbgFDVw3vRerY9N20oImoUJYKqInKxIJwRaBbDhAp1mykiLGue6sbjwyrLpC2dmUoXxtFHLZOFsJlyQWmAeaRZPGgjxyp+1eSMuyr/le0nJBZRdNd7/JoyOPWIqSHRCt1hwSWhj/D2NxFv1Bhx19HPp3RtJA9TrK4Dw6sBDvLjY+gpcoZALUix4T7OfxsAlww2J5GAkFez3mB3K1CE4tUfF1eKIC84ZwdBCOCMVP3
X-MS-Exchange-AntiSpam-MessageData: BzLhDw4CqT8g2fA8aSKfXI4mBhAvjHDImdlivDw4XkjclWm1xjnEfwTeig3UKBVRCiLZMhr0MaafgsWXY/cdIi1dAV2KHEoW0jVxTh3epi4rxX6+80JQsbni9fPIb2rPq3u7f9c0Hl0MksIs3ifRXg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eeb11ef-ece6-40dc-3e71-08d7d472e998
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 06:23:50.8022
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBbcqQmry/sno62888DA1fzRaDGpDiMsbI0b/0rYml66kt6PHKaY4I8XkHsxWC9Ml1iNfxxsvMmCebQ1KhstiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1692
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
index 8fcee0b45231..ba6cce3c84af 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -34,6 +34,7 @@
 #include <asm/hypervisor.h>
 #include <asm/tlb.h>
 #include <asm/cpuidle_haltpoll.h>
+#include <asm/e820/api.h>
 
 static int kvmapf = 1;
 
@@ -357,6 +358,33 @@ static void kvm_pv_guest_cpu_reboot(void *unused)
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
+	if (kvm_para_has_feature(KVM_FEATURE_SEV_LIVE_MIGRATION) &&
+		(smp_processor_id() == 0)) {
+		unsigned long nr_pages;
+		int i;
+
+		for (i = 0; i < e820_table->nr_entries; i++) {
+			struct e820_entry *entry = &e820_table->entries[i];
+			unsigned long start_pfn, end_pfn;
+
+			if (entry->type != E820_TYPE_RAM)
+				continue;
+
+			start_pfn = entry->addr >> PAGE_SHIFT;
+			end_pfn = (entry->addr + entry->size) >> PAGE_SHIFT;
+			nr_pages = DIV_ROUND_UP(entry->size, PAGE_SIZE);
+
+			kvm_sev_hypercall3(KVM_HC_PAGE_ENC_STATUS,
+				entry->addr, nr_pages, 1);
+		}
+	}
 	kvm_pv_disable_apf();
 	kvm_disable_steal_time();
 }
-- 
2.17.1

