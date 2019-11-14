Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC12FCF73
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 21:16:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbfKNUPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 15:15:55 -0500
Received: from mail-eopbgr730081.outbound.protection.outlook.com ([40.107.73.81]:22896
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727217AbfKNUPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 15:15:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtAs001zF7BTi9jVw4wCESQpsXzbjtJFfNB/f/jqB6Ikvf8L6vGFerYhQ9XRv3+K520vBLFYXoStRsTUUz0LbY8w/lHb/sxji4/gx2stcuW9kxIp4jz1KFNsgOsFoxJ5KwLaFum9AwMe9nahJZ9zx32knxjsCJMSn2wZFVzSejpiDj5mOoErTGF8FH1pdec/AUch0EFlIjFmU2AcZ95X8wiVc61vE2RDzyOJIckLtVpeX6KC7/Slyr7qRWe2d7i3aH7K9l/tBLW/3/qqLNcC/nFFSQPyDiuDquieIVuFKMnKa0REiDmalJcRMbt6nW3LiIsno8TmAucRc8hWMT04nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehCGPvQaXnVTYjyAHUTRQgjZqtq+JAMx8RF68svuwFw=;
 b=Lvvs0WGEqbJd6CNcu95azvM+BKD+NqTR2a19Uh8slHk3lLaHLM2UWvYUPG5FCcqFhPg4PGnq333HqgpFEAfRV9oZyu1YlM4ubSz+Hh5gK0ywYswNzrcItKLhseaJeLBWrKe13kkoher3sHWsLt3UbvF+MEca8G4TZ2WQg21kgrc5LOZ2/VoQXhwglbdUV4NXVFfnKhTS8rFYp/0vKnla0H4geIoF2L7IYs3Zb6cxmG9UVgDFEah1LkO0fn3mt9qFa0T1iyPngxsEHVtsPFOjNwno3kOOjqMha8c9fvZbeJooNhdGka8Z039gRj2IE9BpHShuLqdZzkO9WXyJs1QaFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehCGPvQaXnVTYjyAHUTRQgjZqtq+JAMx8RF68svuwFw=;
 b=bkGj+A8yS1DUHvhTfXwF0gLY980sMO6sm/PvPEyIiC9sY+Z3IhFi0GXdN6REhRH4v6iFYQcA/XLq0BjV4B/rR+mLnULtGi1oQVe+gH53djpdfAstUAHBM53FVzYTG930NmchjapxrH9kZK/WvjbQvJl7TKG3+tW6oebg1yN+IgA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (10.255.173.210) by
 DM6PR12MB3739.namprd12.prod.outlook.com (10.255.172.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 14 Nov 2019 20:15:43 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::4898:93e0:3c0c:d862%6]) with mapi id 15.20.2451.027; Thu, 14 Nov 2019
 20:15:42 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        vkuznets@redhat.com, rkagan@virtuozzo.com, graf@amazon.com,
        jschoenh@amazon.de, karahmed@amazon.de, rimasluk@amazon.com,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH v5 09/18] kvm: x86: Introduce x86 ops hook for pre-update APICv
Date:   Thu, 14 Nov 2019 14:15:11 -0600
Message-Id: <1573762520-80328-10-git-send-email-suravee.suthikulpanit@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: addb89d6-d31f-4bc4-02e3-08d7693f6cb8
X-MS-TrafficTypeDiagnostic: DM6PR12MB3739:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB373984D665CD212319EF7EECF3710@DM6PR12MB3739.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:597;
X-Forefront-PRVS: 02213C82F8
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(189003)(199004)(6506007)(25786009)(86362001)(6512007)(15650500001)(6436002)(8676002)(47776003)(7416002)(66066001)(6486002)(50226002)(4326008)(3846002)(8936002)(4720700003)(81156014)(2906002)(16586007)(7736002)(66556008)(305945005)(66476007)(2616005)(6116002)(66946007)(186003)(316002)(14454004)(486006)(478600001)(99286004)(81166006)(26005)(14444005)(476003)(5660300002)(44832011)(386003)(446003)(52116002)(51416003)(76176011)(50466002)(6666004)(36756003)(11346002)(48376002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3739;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RL7bASubRuTKGOrufRKvLo1by6MleBsaQ7YMpARKCgpXoIkFGTic02rZy2xhJQwFDHaESjtNDF7W/Tb0mz5yY78C/WZ6gkjkt/XNby77bVlkK80zrvfWCKzP7VwXR6D3ty8yLtYFhYxio8tr/2NxzRwtq5A8Ye+kOWgA74N+9zAfaQ+lA35iQfRfqHoDGD7CGn/v0CScxH2rZYTzn1lBViCq65clRvBA62upRzxdnG0Z4FMazLOHh0Adz39OvI144nb3UWT2D7/hrrQzyJjH+iVnSD2cSjdB2DNRulGRd3h93AgnrY32aI6j8ERFSoGznsle2vGpsKOJrtkE13alFKrsNjdRvtTvX41Nx07ASrcTsyMXn33p7KgVLbjch8KEPOojOz1etOsPEzfGlmXan5LGTomkvyX9V1UgyP86wFx5YXOW9ck16dXdswGmZE0S
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: addb89d6-d31f-4bc4-02e3-08d7693f6cb8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2019 20:15:42.7657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4YUH1OFJt+tx2og06OEkAVHbCOMJRUdQXshhry7xqz8a84NPswIea/CWfnNlAeb8O0SowduQuUO67vXFt/Pxxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3739
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SVM AVIC needs to update APIC backing page mapping before changing
APICv mode. Introduce struct kvm_x86_ops.pre_update_apicv_exec_ctrl
function hook to be called prior KVM APICv update request to each vcpu.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/svm.c              | 6 ++++++
 arch/x86/kvm/x86.c              | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ee6331..c685643 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1091,6 +1091,7 @@ struct kvm_x86_ops {
 	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
 	bool (*get_enable_apicv)(struct kvm *kvm);
 	bool (*check_apicv_inhibit_reasons)(ulong bit);
+	void (*pre_update_apicv_exec_ctrl)(struct kvm *kvm, bool activate);
 	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
 	void (*hwapic_irr_update)(struct kvm_vcpu *vcpu, int max_irr);
 	void (*hwapic_isr_update)(struct kvm_vcpu *vcpu, int isr);
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 8bffd93..5a4516c 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7230,6 +7230,11 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static void svm_pre_update_apicv_exec_ctrl(struct kvm *kvm, bool activate)
+{
+	avic_update_access_page(kvm, activate);
+}
+
 static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
@@ -7308,6 +7313,7 @@ static bool svm_check_apicv_inhibit_reasons(ulong bit)
 	.get_enable_apicv = svm_get_enable_apicv,
 	.refresh_apicv_exec_ctrl = svm_refresh_apicv_exec_ctrl,
 	.check_apicv_inhibit_reasons = svm_check_apicv_inhibit_reasons,
+	.pre_update_apicv_exec_ctrl = svm_pre_update_apicv_exec_ctrl,
 	.load_eoi_exitmap = svm_load_eoi_exitmap,
 	.hwapic_irr_update = svm_hwapic_irr_update,
 	.hwapic_isr_update = svm_hwapic_isr_update,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1ab8e66..cbc7884 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7897,6 +7897,8 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	}
 
 	trace_kvm_apicv_update_request(activate, bit);
+	if (kvm_x86_ops->pre_update_apicv_exec_ctrl)
+		kvm_x86_ops->pre_update_apicv_exec_ctrl(kvm, activate);
 	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
-- 
1.8.3.1

