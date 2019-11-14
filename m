Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46A24FCF86
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727238AbfKNUPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:52 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727196AbfKNUPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PM16G2d2f3WMQLR2j+BXeMKQTkR0eqPLLi17TcpIkVW1cysmYhCmEEijQEuCnIHD/4SkGJ2wzSiFRSdyUbPJfO0O54ZGM9lQzUONQspI/kuzv2q6HFSSzTMAymeKQhaKaxfYUs9Upr9mn2+AnrNpj8xWGAsV6OFFconJTOTB1P5nFysSr29mUyOp1dPsruYHFVibNV7a84KN7Ri1nOX8xoDjbs0cifepeQz7jNVcIKer65hZEaG6s/BgSaSCHXASFR3fv9ZHQemL6ID7b2QLBMia7vfYOvPxzLOtajpRUi81W8N0FFp2nnhIhsXlgbMyuKvk3vj7fCIcqlgieXCBgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9/2saZ+VWEN/dE1Rnfb+mpwHp70puMT2q1Wad5rLXY=;
 b=Nq0GeT51KpPOJivG95LJcPuqyBr7r5fH1uwu339qnI0WI6a3/OTIn/25AJmK8mYS4xo2i5/qfSsgaL01YwG3BWc9bswL0A3KEsnQu7o5/F5PDfHBPeIkpRdYXHiNwySyBB7x6l8zrzsBmTB5NmVMMc2SZr+eRwi3CinyEYVjReeXT3cHxiQ16X0szr1IURaNPmhT98bQ9pO76+aLcgkZcxfoW8wK8ogjdvVpobLOf6h5pmnlswiSdx40B1//QxVj6Vor1ShgdHdQO7lavspZETY38TS4Qyy0lFwyT5D06oVD1lZr5ZszLpXXfal4ziCk378eIw1BJ2xkF39ghYbmMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i9/2saZ+VWEN/dE1Rnfb+mpwHp70puMT2q1Wad5rLXY=;
 b=G3TC30ilp+OxWwehxEFjtbUxOF4xpBp+9MBjtCd8lIyKlHft13mBAVP0OS6seoyXNCpg4xANY+xLKJV73hmhNa+Uj5SZ8J4IrwwU6DzfpgVfgq2mQzdR2lXXJsd8WD3OTpOaAf94GALxqE2ZxP2+wVEtg9aUuLoc1q69qFvfhQU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:41 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:41 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 08/18] kvm: x86: Introduce APICv x86 ops for checking APIC inhibit reasons
Date:   Thu, 14 Nov 2019 14:15:10 -0600
Message-Id: <1573762520-80328-9-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 319ac458-a0c0-4816-a8ef-08d7693f6beb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB373962F01868A2F608D98FD2F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lpS3XNH55EpH16LNhAQ4oXtFZEbE6sqXJnT+kqq8KmjyeaEggWSPYNEqS92KdLNMuN+RxI+VZCashHT4KcaK7+oLeFY5qYMFwO04ONhskLBSco8ByGBXlQPOAyhme2D1uvuq8D/i7tcYpV7zzIUMoiSQ1+PG5lc1boZM4bOvDBgKSOi3Q6xvwa+4FSqYziUnMnbIjEnjqdt97S4iWOCTDPJU67U27YUg087NC2C9blJ20ZbEBjpZ82JV+1wNqC+CeWm9aMXA/EAdberbR4Vbm6zPm/FVkgvYJ+B80YHpjXg+Hhz5SJJs22S03J6fCSOpKv/73LT220+fLCx9GcXxrBNGr91fk/2cT8YHuQK2g2/WSAh+HPiATqF5vGGelc/HWEhBev3EDPv/LSky9GfQpN6luf4fYQWy0u6hFmY2zgnCcspZQ5VzrV1yIcTIx3H0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 319ac458-a0c0-4816-a8ef-08d7693f6beb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:41.4574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9jF5CxP+Ol08hiey+SOEu99yUYnR0LOiImtAIxNDTVQMi5zJ2ea3NAvBr2Zq6cUund3PnXuKwsa3khjUPbB+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inibit reason bits are used to determine if APICv deactivation is
applicable for a particular hardware virtualization architecture.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 arch/x86/kvm/x86.c              | 4 ++++
 4 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 25383b6..5ee6331 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1090,6 +1090,7 @@ struct kvm_x86_ops {
 	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
 	bool (*get_enable_apicv)(struct kvm *kvm);
+	bool (*check_apicv_inhibit_reasons)(ulong bit);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 3ffb437..8bffd93 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7223,6 +7223,13 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 		   (svm->vmcb->control.intercept & (1ULL << INTERCEPT_INIT));
 }
 
+static bool svm_check_apicv_inhibit_reasons(ulong bit)
+{
+	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE);
+
+	return supported & BIT(bit);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7300,6 +7307,7 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 	.set_virtual_apic_mode = svm_set_virtual_apic_mode,
 	.get_enable_apicv = svm_get_enable_apicv,
 	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
+	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_irr_update = svm_hwapic_irr_update,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d6d1c862..8f51569 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7732,6 +7732,13 @@ static __exit void hardware_unsetup(void)
 	free_kvm_area();
 }
 
+static bool vmx_check_apicv_inhibit_reasons(ulong bit)
+{
+	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE);
+
+	return supported & BIT(bit);
+}
+
 static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
@@ -7809,6 +7816,7 @@ static __exit void hardware_unsetup(void)
 	.refresh_apicv_exec_ctrl = vmx_refresh_apicv_exec_ctrl,
 	.load_eoi_exitmap = vmx_load_eoi_exitmap,
 	.apicv_post_state_restore = vmx_apicv_post_state_restore,
+	.check_apicv_inhibit_reasons = vmx_check_apicv_inhibit_reasons,
 	.hwapic_irr_update = vmx_hwapic_irr_update,
 	.hwapic_isr_update = vmx_hwapic_isr_update,
 	.guest_apic_has_interrupt = vmx_guest_apic_has_interrupt,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 044c628..1ab8e66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7882,6 +7882,10 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
+	if (!kvm_x86_ops->check_apicv_inhibit_reasons ||
+	    !kvm_x86_ops->check_apicv_inhibit_reasons(bit))
+		return;
+
 	if (activate) {
 		if (!test_and_clear_bit(bit, &kvm->arch.apicv_inhibit_reasons) ||
 		    !kvm_apicv_activated(kvm))
-- 
1.8.3.1

