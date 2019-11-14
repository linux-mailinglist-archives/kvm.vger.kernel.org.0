Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 656D1FCF75
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfKNUP6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:58 -0500
Received: from mail-eopbgr730081.outbound.protection.outlook.com ([40.107.73.81]:22896
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727310AbfKNUP5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H8+6vrqF5Yo7Yo/BN/FzFIYXbsrFYOadJr7GKs7s2s2xlBQWzDr2kzNvoZvxLMtdD6ayHsGqcgsCdDm1ViA4Y+jVHHgn+WLPGEvfwcdeqdWdl6swV7fC8l+WBcOsIu0zLTLSp87vj0bdtvTAL1JY5RELZhSOlKn/kuD77AYcTS3gQltUguyual3F8ajFDl7neSjgGgtvq1B1gOFwfRDA/6mDh7TRFPwuCU72rm0WoMknf0kmO8wfJPXstCOqoae7gi15Qi9h3+YmnLowOpzrdI1KSJmXo3e53VlOvDyps+HaGC1W5SlWw08RlKU08OHrA0p/umZBqDr9BzVbNNCMeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojw+O5djIJwO3KfRgGQH6IAsaVENGbpt60wyasLln1I=;
 b=bXGqRe1c973TfppgiJvd07SbbZ3oXjDulbGxAtB+pQNTZDmWemLd9fb0we+VghlnGPlR1cMs62mGCPxsvKudJLtOFeliVDP1XShewCQi0+USGMKOlSkvIOhDAws2I9zPz563UMqfylo/4Cpm+ccFOx2ihM1mvvl/PT9X3e9uZK0X26naYL+QN/7PnGOATTi1IehdaiQJLsDanHHxBG68fLh92mVPva2tkCbVU0F5C6w2rED77BTFm5U1HBL7hWCy9+eh6Yqncmqos28TArHHHk0S5eg5hVfQv9tOPI8HB5kyl1FDhOv8K9WmiEqmD72euFcQa2uCYIPQuyAr01VdLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ojw+O5djIJwO3KfRgGQH6IAsaVENGbpt60wyasLln1I=;
 b=cYYaKMX5yi4R14qtRCiYTdfu/2uiS+/Wbn79d/EXNljinqSgl0iRhTCWTScPTdoLNRhqd/kt+Pl1dYshiSkTFCAxe7vZ9uhOtZ77nDFr6PQEeZ7YZsGcxOe09c8UL89kd+WtrkTes7ifS5zZNjcG0sWK2kMJz+3idTZAewMI25w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:49 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:49 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 14/18] kvm: i8254: Deactivate APICv when using in-kernel PIT re-injection mode.
Date:   Thu, 14 Nov 2019 14:15:16 -0600
Message-Id: <1573762520-80328-15-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1573762520-80328-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN1PR12CA0099.namprd12.prod.outlook.com
 (2603:10b6:802:21::34) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c8::18)
MIME-Version: 1.0
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dc65a16f-d9e6-44dc-6ac0-08d7693f70a0
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739C12C5AE5E1121E9F924BF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5/ZoIs/NWK56C897yTucszT3ON4XUz9C7GGjgr4HKYTlvXLjBv1TbiOVFmJg8b5P79PhIsee6cE8Zs8fkDhUUsg2ZBqWhDrKQxRFJ2srIhTyyiJoYhFANgYVH9pdFA5D6widsCHEeqmTcv4jSGXvSKhHSscfot6lyAWjjnFxUasWh4wYQeBKdjWNb/rMxsHSYp9AK6u+l85Zlc7jxinqxj9TEmb0fBimqLGI0++b4WmBPbv3MWY0wmtmsO2FK3hwJib6HokL/yUQJVoxkUlH/JMVBtU4v95vl1CNzge5G2JT/QCNMjGGafrJcEJlal6XdWtSIVa46O+m8t6CgUAM6lQXnKd2Ufb1n/4thBoUPVKVj8oO3Zxyon/hGiIG9LqGDRneS/G6mOiTguDL1xEv96+apUJfXPCo9UJuBl64zRxEk25U/1HC8+8/RKcj9FCA
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc65a16f-d9e6-44dc-6ac0-08d7693f70a0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:49.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nb/ZdR1lI2aQzQm1gGmkljSzW0w0DTQUROn8nQ/N6U0h7UiDNBr2vmtQlW22wi6JDP5m4UmVruxzG/nJ6WGT1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SVM AVIC accelerates EOI write and does not trap. This causes
in-kernel PIT re-injection mode to fail since it relies on irq-ack
notifier mechanism. So, APICv is activated only when in-kernel PIT
is in discard mode e.g. w/ qemu option:

  -global kvm-pit.lost_tick_policy=discard

Also, introduce APICV_INHIBIT_REASON_PIT_REINJ bit to be used for this
reason.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/i8254.c            | 12 ++++++++++++
 arch/x86/kvm/svm.c              | 11 +++++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4b51222..9cb2d2e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -853,6 +853,7 @@ enum kvm_irqchip_mode {
 #define APICV_INHIBIT_REASON_HYPERV     1
 #define APICV_INHIBIT_REASON_NESTED     2
 #define APICV_INHIBIT_REASON_IRQWIN     3
+#define APICV_INHIBIT_REASON_PIT_REINJ  4
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
index 4a6dc54..b24c606 100644
--- a/arch/x86/kvm/i8254.c
+++ b/arch/x86/kvm/i8254.c
@@ -295,12 +295,24 @@ void kvm_pit_set_reinject(struct kvm_pit *pit, bool reinject)
 	if (atomic_read(&ps->reinject) == reinject)
 		return;
 
+	/*
+	 * AMD SVM AVIC accelerates EOI write and does not trap.
+	 * This cause in-kernel PIT re-inject mode to fail
+	 * since it checks ps->irq_ack before kvm_set_irq()
+	 * and relies on the ack notifier to timely queue
+	 * the pt->worker work iterm and reinject the missed tick.
+	 * So, deactivate APICv when PIT is in reinject mode.
+	 */
 	if (reinject) {
+		kvm_request_apicv_update(kvm, false,
+					 APICV_INHIBIT_REASON_PIT_REINJ);
 		/* The initial state is preserved while ps->reinject == 0. */
 		kvm_pit_reset_reinject(pit);
 		kvm_register_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_register_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	} else {
+		kvm_request_apicv_update(kvm, true,
+					 APICV_INHIBIT_REASON_PIT_REINJ);
 		kvm_unregister_irq_ack_notifier(kvm, &ps->irq_ack_notifier);
 		kvm_unregister_irq_mask_notifier(kvm, 0, &pit->mask_notifier);
 	}
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index b7883b3..2dfdd7c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -1684,7 +1684,13 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
 	int ret = 0;
 
 	mutex_lock(&kvm->slots_lock);
-	if (kvm->arch.apic_access_page_done == activate)
+	/*
+	 * During kvm_destroy_vm(), kvm_pit_set_reinject() could trigger
+	 * APICv mode change, which update APIC_ACCESS_PAGE_PRIVATE_MEMSLOT
+	 * memory region. So, we need to ensure that kvm->mm == current->mm.
+	 */
+	if ((kvm->arch.apic_access_page_done == activate) ||
+	    (kvm->mm != current->mm))
 		goto out;
 
 	ret = __x86_set_memory_region(kvm,
@@ -7281,7 +7287,8 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
 			  BIT(APICV_INHIBIT_REASON_NESTED) |
-			  BIT(APICV_INHIBIT_REASON_IRQWIN);
+			  BIT(APICV_INHIBIT_REASON_IRQWIN) |
+			  BIT(APICV_INHIBIT_REASON_PIT_REINJ);
 
 	return supported & BIT(bit);
 }
-- 
1.8.3.1

