Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A240C1680D2
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 15:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgBUOwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 09:52:38 -0500
Received: from mail-dm6nam11on2072.outbound.protection.outlook.com ([40.107.223.72]:6262
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728798AbgBUOwh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 09:52:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJYJ80T0SXjv24iu7ci4A6q1H/Hc5Zw+vBhWuX87kJRAkweNKVR1plPLi8Gc/+Rn6Po7biUTTDBxVKkMr7vF541bpTT5Md4Z3WGjgSzg7XNvTXbygwWSjk5AnxXZBHo07V9r9b+H5WKejTMFUc/9g0sI7l97AAslZXB4mPmU1CfSFQvka52U7PvV5JhrQshVS+iC9K0AU0cmNvmvs4VElAJ79QkmWY/AYoAaumpdNQ/LuDB9vh2J0pQQwhmJ7bTmtSHi4/Rrklj5F8a9v4M3OzCvPHsqH+lEsR/zrbxTlkngeR+XhhEtseYrnZ/RITZQTd9Nb7aJUj+6KbOzSO5tig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/1EWM8eTf2vqsMfswhhodiaOtx+HIyjDIW3J1RIBcI=;
 b=ig912F4UahB6nXfooNIMDE8rIXgdIfI5rRrHJfd4F7lPBsI6sR8cXRmb/WAPyJh91Wzg3KwBTT+vUPF6hkU7Sc7W8dGHzkaH+Fjv6Acfh7azdXVswZ5rKEOrWuZ0EmEEYqh50ZmVsxmYkHHslENHPZ5YI9B49uB7SiB6A/WfGvBb9jLRSq9xFweUat1pCLsP7B14nvi6tNe0UolBoB8vl81NkFtSgC5gpdZFbXkZfguK5I2bQNNEg9aO/Y17QNc7Oz0ueOEycJeQACq0Sdn1dtmJaxYPElXr52Kdu8vJx6noCvo1HcCk/4oNi0lpd0CAWXz8k+fbrAY7crWxZDmgDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/1EWM8eTf2vqsMfswhhodiaOtx+HIyjDIW3J1RIBcI=;
 b=DA5a4/Rp3lilIzkawQZEhjGVNXzXuOzW8D64B5b3PC9gd15TJ7C0v3rcqnMPJzERyprFcn+Rzso/qLfjF8Rv9xpyR+pAeCMOtjf45KObTEz1L/WEiOyO2/ZY6TPDtNkKIVvk/VBP+WZsWMtDKlx5ntNl0CtsArtsT1pFyX4JU6A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB3402.namprd12.prod.outlook.com (2603:10b6:5:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.31; Fri, 21 Feb
 2020 14:52:34 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::fdd1:4a97:85cc:d302]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::fdd1:4a97:85cc:d302%3]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 14:52:34 +0000
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, joro@8bytes.org,
        jon.grimm@amd.com,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: x86: svm: Fix NULL pointer dereference when AVIC not enabled
Date:   Fri, 21 Feb 2020 08:52:17 -0600
Message-Id: <1582296737-13086-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0040.namprd11.prod.outlook.com
 (2603:10b6:5:14c::17) To DM6PR12MB3865.namprd12.prod.outlook.com
 (2603:10b6:5:1c4::14)
MIME-Version: 1.0
Received: from ssuthiku-rhel7-ssp.amd.com (165.204.78.2) by DM6PR11CA0040.namprd11.prod.outlook.com (2603:10b6:5:14c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Fri, 21 Feb 2020 14:52:33 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [165.204.78.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9c9dbcd-49f5-4fe4-d764-08d7b6ddaf2b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3402:|DM6PR12MB3402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB340284D1F8A41789A8056EF1F3120@DM6PR12MB3402.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(199004)(189003)(5660300002)(44832011)(66946007)(66556008)(6666004)(52116002)(966005)(7696005)(6486002)(66476007)(36756003)(54906003)(8676002)(26005)(16526019)(2906002)(8936002)(81156014)(2616005)(186003)(956004)(81166006)(478600001)(316002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR12MB3402;H:DM6PR12MB3865.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKJuiOjZY/T8kOQkupKkpiqIVLFg1aFwpeZxMYWatZBB/Rp8kBmm6ZLgeZBxVlmJoLnFP+FWIsstOuzexY44BIISliuM4neUW9vSvKYWGuvJGCTJdGpAMbQ002z+nHpsAl9deV8t1TKqDHG9gmJ+3AhIGeXSBV9B05kGSJehph5z2ftqNMb+AOJPZrMX1smp1FG4tofgDEhLJW9rjoI40LM0tba3XIG2kHXdeRmk0Eq4D2YfXPjI2bcPeCB8ysJlfKyW7ojZvc8Bx/i+c7z9qUz2PyaUE10iWFeoaJLP4npr1H/1M5QNKfmL26EgU7iv1v4eu9cal9iZeKJ40dWVWjZDUk0vMih6PZjnMAcvHK6hirPTFwUaYfxyA8l4IyPqoYJMkEI/OrFI9wGUsAt77lDOY897E8OByBBFnyG79BXFg8RqCb3TVKc6SjFGMfxfpZ041F06r8G5QP2NQp7S08b7A02Qq/KAmRmLcTqrABZ5gfr936qrbFYSut+VZWTyT1E5LLYkySdW1ZMVVqWrnQ==
X-MS-Exchange-AntiSpam-MessageData: uesLFnMPiwTGsOl75Ll9a7wLJMwwJ+QMLWQr8oeFP7eoIeteRWVs3xMWjW3hQT77yGf2TKpiBvEfOoEZgaIUtWpIXAFMUA/E+DTkl74D/kvf/zdKhpBo722Y2TzXr8VSZZsQVjRsHYRqXIJ2bi3e6Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c9dbcd-49f5-4fe4-d764-08d7b6ddaf2b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 14:52:34.1196
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gJuU92ySDargbcsJ0BOO7e55h+YE87dVPYCs01zRZ7LuXBce4OIeZD3nWIzywY/h8QHowNKADNk/yMj3wMoKoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3402
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Launching VM w/ AVIC disabled together with pass-through device
results in NULL pointer dereference bug with the following call trace.

    RIP: 0010:svm_refresh_apicv_exec_ctrl+0x17e/0x1a0 [kvm_amd]

    Call Trace:
     kvm_vcpu_update_apicv+0x44/0x60 [kvm]
     kvm_arch_vcpu_ioctl_run+0x3f4/0x1c80 [kvm]
     kvm_vcpu_ioctl+0x3d8/0x650 [kvm]
     do_vfs_ioctl+0xaa/0x660
     ? tomoyo_file_ioctl+0x19/0x20
     ksys_ioctl+0x67/0x90
     __x64_sys_ioctl+0x1a/0x20
     do_syscall_64+0x57/0x190
     entry_SYSCALL_64_after_hwframe+0x44/0xa9

Investigation shows that this is due to the uninitialized usage of
struct vapu_svm.ir_list in the svm_set_pi_irte_mode(), which is
called from svm_refresh_apicv_exec_ctrl().

The ir_list is initialized only if AVIC is enabled. So, fixes by
adding a check if AVIC is enabled in the svm_refresh_apicv_exec_ctrl().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=206579
Fixes: 8937d762396d ("kvm: x86: svm: Add support to (de)activate posted interrupts.")
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>
---
 arch/x86/kvm/svm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 19035fb..1858455 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5222,6 +5222,9 @@ static void svm_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	struct vmcb *vmcb = svm->vmcb;
 	bool activated = kvm_vcpu_apicv_active(vcpu);
 
+	if (!avic)
+		return;
+
 	if (activated) {
 		/**
 		 * During AVIC temporary deactivation, guest could update
-- 
1.8.3.1

