Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A435419721D
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 03:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgC3BjD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 29 Mar 2020 21:39:03 -0400
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:39303
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727954AbgC3BjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 29 Mar 2020 21:39:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=devBj8pIJaIdRUVpZz+W3ivaf55TxBK17QFF5XuTQMsGyBgqDI99EaMC6HsLKB/la+4Y4wgweNS1oG09Jv4rt/HiKeEEpRDDg3qrhJbUj9M/ff3RbgMnXClVMGfOhAqCZIIpom++ieTku4Hz9I/dZd+b2pckbeaSYhe5qhi/lCKUhfmpx6nH2Pfq+uigVfOGIMJOY5uKmfywrySwPZ4uQinWUPcrEAk25Ftjd3YcMUuNrX+q/qe2MLgokLgtSYEdhRlMqWxrFnHjiyo5XfunBCv7d02oMCeidSFXzlnWE0I+6589V5EPdC+Q+90IpW7GmfTO7lKAM8/3R+wp81DCEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aodWKOdHZfBvB6+8w8EpuzzbFUtA2r4yfbVD9G2bT3Y=;
 b=L+/uvD+dcjn/101fwCcFeXhkrKJ9SZb664elBp/WyFM98cclgs/SEnFYkisWmSO7I90QmZvvswb7xJN98CfVURvtSMHcVB0cf1TWuQ8w2LZo2Bz6vJnThrhyckbEdjaNKBbRECyPs2f+a6FlINbZ+3go+NqR7vlC6/5kVB4PJGTq9/7gaIjVpF4Yt/Lc4CeEeR+cmXexnFnwZJyl2jCh8GVEntxLSkr5upnSgJfaaOIVl91jM653R89DZ8KgGvTwpH0QovXkQ65XJIP9yrEB3TeNgxgfpSum6kyDLg5Qs65ldU3N+EbxbfE7cX+YtXhy3x5F5YlW7eqZsd0pdXd2Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aodWKOdHZfBvB6+8w8EpuzzbFUtA2r4yfbVD9G2bT3Y=;
 b=YmQPxrzo7PVJ+rgqQMBAxdKe3GDygRhDP6EG9YDD1YO1Jk6DkJEQj3yIvvL6ZmxJ1Ye1SARLlGCo8dUT09ylAaLeR+Wdi29JRoPdfGM20VmfS8RZ5YsPr4JXxL9Sr0zngONez0NyqHWvoo2ajFujGYpZzKqUb+sE+C1ycgymtOA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Ashish.Kalra@amd.com; 
Received: from DM5PR12MB1386.namprd12.prod.outlook.com (2603:10b6:3:77::9) by
 DM5PR12MB1387.namprd12.prod.outlook.com (2603:10b6:3:6c::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 01:38:22 +0000
Received: from DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c]) by DM5PR12MB1386.namprd12.prod.outlook.com
 ([fe80::969:3d4e:6f37:c33c%12]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 01:38:22 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        joro@8bytes.org, bp@suse.de, thomas.lendacky@amd.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, srutherford@google.com, luto@kernel.org,
        brijesh.singh@amd.com
Subject: [PATCH v5 14/14] KVM: x86: Add kexec support for SEV Live Migration.
Date:   Mon, 30 Mar 2020 01:38:12 +0000
Message-Id: <a823eb9c85b47bcd0a1447a50af968b3e2ae92fb.1585531159.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1585531159.git.ashish.kalra@amd.com>
References: <cover.1585531159.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:805:66::36) To DM5PR12MB1386.namprd12.prod.outlook.com
 (2603:10b6:3:77::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR08CA0023.namprd08.prod.outlook.com (2603:10b6:805:66::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Mon, 30 Mar 2020 01:38:21 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc387a04-eb4e-4265-7db5-08d7d44b0855
X-MS-TrafficTypeDiagnostic: DM5PR12MB1387:|DM5PR12MB1387:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1387605B25A598ABF8409E558ECB0@DM5PR12MB1387.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1386.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(136003)(396003)(186003)(66556008)(6666004)(66476007)(86362001)(6916009)(66946007)(316002)(4326008)(7696005)(52116002)(5660300002)(6486002)(16526019)(26005)(36756003)(478600001)(7416002)(81166006)(81156014)(8936002)(2616005)(8676002)(2906002)(956004)(136400200001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoeVFpd86DOsrB8t9uDMsSSBYFM8u6obIAmhhm/0quWGUDQV/l4tScEmjj3sOoOnEAN88tD2AUS4V3hq89fNsEJ4K8mzuVOL2QsnRWUf69FF3dq9EyrvoyYjhRYyySQJhML8835Q7g1EzcdGvBNHQcunQAk3mXcBddi1YM1UYxTKAEAShL9wk3EqARCXXoUtTI2LI1U+XWt7ov5zq8RWaoUJod34i7cwppsRozn738cB8zyQJAapc8t401mM5WclhTsu3e1++CusyibMJvY7h3WTSDVPpM5TbQGR+Gr/NDXuazAJZOpHh/VM2tN7wcfI9/fDBaQpsezZ6JioFmJ/wF3LQHQrbd/IXqkjJMgcqlViAwhkac7Uc1gD4QaBRy2c23gmk6P3x3+51UAeSRj+igsA81T/B8viA+cTxsi3pWxvNXp5Z2Xfv3GCZbEQvQW2488rkIgxc3sqF6g7spbeZ7NPBgyrj1SRDLgv9ED9b0JL98lpnOYaTtFXd68jPTJ2
X-MS-Exchange-AntiSpam-MessageData: 5Y5CERaaduFaaKIx0+jO2D1aKkA3qyk7eU+6LSV0FhjQ85S4UkhCcMzLVDNKDa1xXxEBtc2ns2bATDdgBlNyK049yd3cY3ZNlxcbgtOs6P+OsHNhOpNf8g3FU66fCu9zml/tA6/MGVk4unnjSk164A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc387a04-eb4e-4265-7db5-08d7d44b0855
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 01:38:22.5290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jbs2Hb3udl0jB4KiKXGf3INsnQrerWtjww45vSBVVirpVurtiTanW31rGX/N0UxVGu7cPojBS/aiybSsPcnHWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1387
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

