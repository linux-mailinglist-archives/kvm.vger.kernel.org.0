Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A4CFCF87
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfKNUQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:16:38 -0500
Received: from mail-eopbgr730059.outbound.protection.outlook.com ([40.107.73.59]:60877
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727200AbfKNUPw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRLOGnAcKsYwYLs3+RUkgTdPoFDkWHzX5/D2XHiNv0q4ksbhDLS16BayDn+ajZxbZ5P3MUkZJBjFwTnFfX9addE7BB4z5gDnPJSLgAvYhzvrnkXLWHQVVqzibSEsCHqEj71LuH+fYR3DInoSo6d0EqXzZGSXjlNfzve0cMQCanVvMB7JehZm+KdY88T61XDsnkceJadPHIuy4Ntnj4sA98M/zmsxdAdlozN/Ch4QyLr0g8VvnxD7WnbdMgjrw4ryHyYtokMLRW9W/c5+IIQV3rTSLJ+Hfl5lP2K9x/UgX4FgqL8P2x+ydFUn7xEGp0MMfTw/Eya4x2ij08yAmndlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jL5LYMEJzNZ6AgX5fhr+Ha5GUhnHm/Mqm00q4AUGaI=;
 b=iN4nQZKmVLLHulBbvEURPiuvzsVFO1InPCahGXUmLkq6qRM0mLFNfjggVv+ssC3RUFcDalHBh8T+suZmkuVFIMG0Jq/BDNLgRNMXF5LiFXhkJpkSnY8PUi4ViL90ILFTek6KBXmPL8nQWqUuOBdffiTB+/tu3pRa3JgHF8eDKj7hwqwqLjvj9Q6c0yxJazrtxeS87oAzI4YniwCOJK+qAyRmUv/Awep1HUnlL2o6R/zOa0kyotMlX8WyZhW6iE3eCoPumuvH+zABBLqcMEs6LCko46EpcIah82OOrBzYSNEAzLtP5hU1ZTcJ1rUwJjoMXh3+WVSIi1rjEDud7eL3wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1jL5LYMEJzNZ6AgX5fhr+Ha5GUhnHm/Mqm00q4AUGaI=;
 b=3blxhhvHd2BT0ZMopc2jRobLRHTeJadJu9p6Y7lah8KUZJMbZ5f981MqjU3BuVh19RKBwGPi3o6BqKVWey+Tvi0vJPmdzX+XnmyqGDQMOSOwHTQiZW/HolrvL27VG0GSdClJYdD67ouKlqupcZ+udpnTwPd9XylHAXdxMe6w+zM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:45 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:45 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 11/18] kvm: x86: hyperv: Use APICv update request interface
Date:   Thu, 14 Nov 2019 14:15:13 -0600
Message-Id: <1573762520-80328-12-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9bd3ba82-0764-4147-10ee-08d7693f6e5d
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB3739F6E70392634128961724F3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(1496009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kOWSnv5ATzMJqZ+uObOkTNdp2YvdsLnYp4YdwUhgSQrXiWTCZeMUSC9DEYs/9eLJrJcBthadPl1ffmV9v7Y+C0zGdr8+gA7eXbaIi4NZSvni6ZMlMCMRckaLj0r+aRNVjsASWy2RPIK6wXUeO63PfKPEQoFFqvI5xgHELaiHlo2FX4rnRaInCeBjjGLzEUMus5HHa17Pp3A+S37vSvEYDkW1Dl8gVL3OqUs/sHnffO4fiJk+tCRolJ3kA4TW4MztzfXVVK0n/A2Rd9or056QPdy5h7K2b14ph/rUwGOW4rxmtiJL6MRWs6gBHo6K+pz1ng4uHF0GVLbx0GGVrwMqEYO4nLUQLXktLX9G0Vim80cvxCXR01N4XRNw0UMb+8Axg+EBj3dE6JaZvbf9B94WvFXfSeRjTh0en9wk6vmvnfI9veSB91GAB/MWFG+ezW3V
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd3ba82-0764-4147-10ee-08d7693f6e5d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:45.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kr61eglqlMVfvb1R6JDHT6J1rV5N4EhHqaJ93s2JaYs95ZldwT8Vrk5a9BHbElflCmFJJcpeoR7xVo87jF6G9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since disabling APICv has to be done for all vcpus on AMD-based
system, adopt the newly introduced kvm_request_apicv_update()
interface, and introduce a new APICV_INHIBIT_REASON_HYPERV.

Also, remove the kvm_vcpu_deactivate_apicv() since no longer used.

Cc: Roman Kagan <rkagan@virtuozzo.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/hyperv.c           |  5 +++--
 arch/x86/kvm/svm.c              |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 arch/x86/kvm/x86.c              | 13 -------------
 5 files changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c685643..5d1e4a9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -850,6 +850,7 @@ enum kvm_irqchip_mode {
 };
 
 #define APICV_INHIBIT_REASON_DISABLE    0
+#define APICV_INHIBIT_REASON_HYPERV     1
 
 struct kvm_arch {
 	unsigned long n_used_mmu_pages;
@@ -1447,7 +1448,6 @@ gpa_t kvm_mmu_gva_to_gpa_write(struct kvm_vcpu *vcpu, gva_t gva,
 gpa_t kvm_mmu_gva_to_gpa_system(struct kvm_vcpu *vcpu, gva_t gva,
 				struct x86_exception *exception);
 
-void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu);
 bool kvm_apicv_activated(struct kvm *kvm);
 void kvm_apicv_init(struct kvm *kvm, bool enable);
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 23ff655..3ecfb32 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -775,9 +775,10 @@ int kvm_hv_activate_synic(struct kvm_vcpu *vcpu, bool dont_zero_synic_pages)
 
 	/*
 	 * Hyper-V SynIC auto EOI SINT's are
-	 * not compatible with APICV, so deactivate APICV
+	 * not compatible with APICV, so request
+	 * to deactivate APICV permanently.
 	 */
-	kvm_vcpu_deactivate_apicv(vcpu);
+	kvm_request_apicv_update(vcpu->kvm, false, APICV_INHIBIT_REASON_HYPERV);
 	synic->active = true;
 	synic->dont_zero_synic_pages = dont_zero_synic_pages;
 	return 0;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index a1890bb..5e80b7e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7243,7 +7243,8 @@ static bool svm_apic_init_signal_blocked(struct kvm_vcpu *vcpu)
 
 static bool svm_check_apicv_inhibit_reasons(ulong bit)
 {
-	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE);
+	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
+			  BIT(APICV_INHIBIT_REASON_HYPERV);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8f51569..8aa3895 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7734,7 +7734,8 @@ static __exit void hardware_unsetup(void)
 
 static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 {
-	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE);
+	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
+			  BIT(APICV_INHIBIT_REASON_HYPERV);
 
 	return supported & BIT(bit);
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cbc7884..5e8cfaf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7317,19 +7317,6 @@ static void kvm_pv_kick_cpu_op(struct kvm *kvm, unsigned long flags, int apicid)
 	kvm_irq_delivery_to_apic(kvm, NULL, &lapic_irq, NULL);
 }
 
-void kvm_vcpu_deactivate_apicv(struct kvm_vcpu *vcpu)
-{
-	if (!lapic_in_kernel(vcpu)) {
-		WARN_ON_ONCE(vcpu->arch.apicv_active);
-		return;
-	}
-	if (!vcpu->arch.apicv_active)
-		return;
-
-	vcpu->arch.apicv_active = false;
-	kvm_x86_ops->refresh_apicv_exec_ctrl(vcpu);
-}
-
 bool kvm_apicv_activated(struct kvm *kvm)
 {
 	return (READ_ONCE(kvm->arch.apicv_inhibit_reasons) == 0);
-- 
1.8.3.1

