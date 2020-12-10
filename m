Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48332D632F
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392550AbgLJRNY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:13:24 -0500
Received: from mail-bn8nam11on2055.outbound.protection.outlook.com ([40.107.236.55]:12128
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2392117AbgLJRNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:13:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fw6hfw6lgpIbfnmHMLYHT2G/6/+1fI7baWiFUFAEXTUepPOn2Ro+kCgCm6r9iLzxN0ArGVsGqsw/WWYXaucQ6hgu3WbkhZFJ/Ha5QsECJt4CN1/0u4u9XAM/fdNJRYakW8WQL5men8ak40sZ84zBLvV4dL9CXJvxdkBi8Jd5jEwAoRJQfHQthn5blE7ceJOmb3/SJEc9GuDACyFs6AK7Uw88Ce3viIwL2OjaTSyPqhhm0J1sUA6elZB5h2ZwvA/RIab/lZ6nusDWZJVKJCO3F0F6Dk7e9xPdMQT6yIhLEqxOgqqYHmABjZY3p5XQAy+SJHSrEYMmbTYC9eDBB142ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HP/5Th62f8/BaTNryP9EmMDjhB5bsdKIYw1YeOXgs90=;
 b=E34gG3JqZpmlllUpJ7h8gvYnthlhkxLcz0QKyI22xm2uuY6AYLSMzCvypFloZ4ObdJ1uE7wh0L+IejDiGxsq0W18K5IOvA6u7eCNQsPbZCdCXkjWTxf/zSKchWZRz1sIT8pLMj1BWiARumZEpeDECFALQCt6wtbmDgY9AQ6KmJ3hSi7duxGsrhRrLqh/IkTcL7WxmEwyRvHuee1E0VMGmM7//Mtl8aQxX7Tx7wwZf1gCZWU88NuLZatnM84YdoqoEzB4RZF6mSwYkQ3op4CD2+Z0wBTQezNCd5dazxARXwU38mLYTOGVQg2EhekwijgvCuzWDgrwKRmMu6nBNu/3Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HP/5Th62f8/BaTNryP9EmMDjhB5bsdKIYw1YeOXgs90=;
 b=itf0s1V2oyiEMsKrLD9adn6Zu8avhxzvhBpY/qhqcodXIgzB7XAwGRpEbVy81d70BNwjB5XC8jfxpTr4dQrkzC6g7ea261zqB8QHpIfy6sFeJgrn822Dc8sdPxE/7V+4SXZpfe6BiMG5no/8HWujXEE1Jf+u+HjavnrDqmlhgy8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0149.namprd12.prod.outlook.com (2603:10b6:910:1c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:11:46 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:11:46 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 10/34] KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
Date:   Thu, 10 Dec 2020 11:09:45 -0600
Message-Id: <aa6506000f6f3a574de8dbcdab0707df844cb00c.1607620209.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620209.git.thomas.lendacky@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR14CA0012.namprd14.prod.outlook.com
 (2603:10b6:610:60::22) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR14CA0012.namprd14.prod.outlook.com (2603:10b6:610:60::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:11:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 20998994-1242-4bde-6c23-08d89d2eacf2
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0149:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0149F7420856F5AE233F2E39ECCB0@CY4PR1201MB0149.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G3kSDLlmZ5T2zqY8AtivJpUzRHYsIFey0Mq5JUO6rD4m3BlkhrZzYmi4PjPqXbXPTihmwZ66pFER50FfNqatwzqYo1/4O7WastWnhyrAuZImc18LV7i/XeIBU5zNzXk2fClLBfrJigLYtZ1I6WOuOokQMkqRt+7vqep3Qu0o3GvDeYz//CcBR8q/QduRGSA5gMzQqum7ZPf1Ic6qusAVDB++nRDiqX2HKzRl8LSWaKAkewvYlI75lnSpOCNcxoD/CP4WkVTlwgVXygDxs6RK9OeZI0P4perz+5vfNIkhGdMza5CCyc63oURiX0okYmmJ9aw5ZngpRNSCaEJhQerJ8RAZoXdtGHBroTvsVgt+0vfitBrqQPhmi2FU/yvP8anN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(2906002)(5660300002)(26005)(52116002)(186003)(16526019)(54906003)(6486002)(956004)(2616005)(8936002)(7696005)(4744005)(508600001)(66946007)(66476007)(36756003)(8676002)(86362001)(34490700003)(4326008)(7416002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?WVOS24SFBbkdMb4UiZaEYBMVays56Cwszg7Yc2QqBTAAQbwteMe68Un6l4Ma?=
 =?us-ascii?Q?PyYB+BfNZ/2d/UWuWeAutn6bOAptoYyb/OdVev9BDt/QxD0iIbH8aXTzj2CJ?=
 =?us-ascii?Q?dFOS0mHVmE+888dGF/l5xABm+ZZ0XnZEgH8+LPUITpKcNDY46WyzfemWP2Iq?=
 =?us-ascii?Q?NN22xgq7LBtg856eNP/9zaYwBvhoSWM5W3eCJR/bwZ2U8OW03GbcHHv0JQz/?=
 =?us-ascii?Q?kDJS2j6OPJizIjWrftY6Fn7fNGHKOP2i9rRRcfHSgtntRJ3j+aEniEZtKj/v?=
 =?us-ascii?Q?6grZE6OLzMwJtB11yf1lfs014wKMIk7by/yahWLaF8wSJljpVOXtKOts0I0l?=
 =?us-ascii?Q?gxltYAwOQOx9MIhyF1suA2yuujzRf85GIQ4gwyO9zL/G0clw/gZPkgP9WHSK?=
 =?us-ascii?Q?8SSyR/ETSmeinDHz7+6fSiMO3e/Oekrs4bd30pYd3FzQQjDtP2O3KnFPPACC?=
 =?us-ascii?Q?zm+OogElDJFvjYQxRKZPXLAd7sX8oPV7b5vgD4S5bE0w/CW5Aaych/z7vllR?=
 =?us-ascii?Q?Jw/NmPnwuVj7iJZkdPD8KUfhbIx2I+07HzBsji5F06qHVaPNpqeSy/5a2a5l?=
 =?us-ascii?Q?beZpsux7BWeJxM2dPKm7Tc3qQ4/X9gGnqa8QKC1zTF4YL8Zs/zIrX5s/+Xz+?=
 =?us-ascii?Q?4o+XKEoUN+DrSnwFCUst/uHrwPlAPXAsp/sRn+iYVx+GW0JfI74zz+ItlSCG?=
 =?us-ascii?Q?WoC3OtrqHvnbZJrVQ8VmtaPvhXS4Vf28hR7ztM3d1eXYMMbclBP7biIkJNy1?=
 =?us-ascii?Q?9iYVUtHbiR5380NqhzokrrPm4fNbcuGihVups8wSZewSNB5+Wjs7z99Ss/wU?=
 =?us-ascii?Q?Hed1ib2sVEnq4Zjv5uldGQWuRImVGMHoQIcL5aKqZzcieDfcVi1WZOnAGA+o?=
 =?us-ascii?Q?LtAATdWtugJ50e9NyQox86CrwjjzcaZ8oq8Vo0dlKb7DFYYypn33LEK2bg2c?=
 =?us-ascii?Q?/9+6YdwMMQaKzVGGfSH0epQA5+wPJfZnPXG/fRYG65/CRiyavl70YeuD31CD?=
 =?us-ascii?Q?5aCG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:11:46.7330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 20998994-1242-4bde-6c23-08d89d2eacf2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QInn8f+M0exGxK8DnxOzfKAv7AqtLizHnI5D8EokoF2iPRV3BTV0CYe9+zPWP9Tp87hbi8GdXmaZhIWK0JeafA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0149
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When a SHUTDOWN VMEXIT is encountered, normally the VMCB is re-initialized
so that the guest can be re-launched. But when a guest is running as an
SEV-ES guest, the VMSA cannot be re-initialized because it has been
encrypted. For now, just return -EINVAL to prevent a possible attempt at
a guest reset.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 81572899b7ea..3b02620ba9a9 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2030,6 +2030,13 @@ static int shutdown_interception(struct vcpu_svm *svm)
 {
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
+	/*
+	 * The VM save area has already been encrypted so it
+	 * cannot be reinitialized - just terminate.
+	 */
+	if (sev_es_guest(svm->vcpu.kvm))
+		return -EINVAL;
+
 	/*
 	 * VMCB is undefined after a SHUTDOWN intercept
 	 * so reinitialize it.
-- 
2.28.0

