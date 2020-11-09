Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5DD2AC856
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 23:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgKIW0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 17:26:35 -0500
Received: from mail-bn8nam12on2047.outbound.protection.outlook.com ([40.107.237.47]:23872
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731181AbgKIW0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 17:26:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfDivebfbuVDg6dFX3wEH9/btDYvxgcWFpTvB3QZAp5c5079zjdD4sW3MPZFTzXbnddiCPaaxo3ZcxxTBeAc6xPOobgBixW9fOZzg2xtlx+nWNtAMVyig0+KUSCW4C0KLXnrXYnaTU+y6Vq7cOpjtdVa1YwHnQF+5TVc/lgMDQivxviIn8L6IhhOaB7c7XcfsSZVhxccaR0D2UZLEbs8QHXYR6eehIEoDLIgAJ6UKjH5abUmNfJeTK9ti62zALo4JRkRdNjuw+VV8LjEmPx9hKq0AZq183EIKx0CpmTvc5kV5SHm/pEwM0llxtxMHoS2RI/awqGDkJyegJnVsdgNKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=j2kOuY6wZX4JIGE/fxahJX96a3MfajNRiL1KggcVXe+cPng96rrdfRugVa/M9LjONrS/QSTbbTGHWGNiAmGbiaYlqABikrauc6NMiN8h0m68M50hHjbVZ5o0g9jmlf3ODv8vmZAzeEOBRKoSRloNEKmnbLhxClucXACcU9+iX7sUmOpXzX6uc0N3mHzTfh8CA1xR2zUTcYvTpatsN+56QJFZUv8Vi+m4+oMfTqfx3b4MuMhTOSsp6SO9xhwkQ+ywL5j1LBJhiMfPVOonOEN0bAOcscEO/bf33Mr4INhW/pcPuiZHjhAwvZJ4GXVzMNxG0/VZlm8BAdkc9r1/trnM5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=aN5SdRvMhG8wVsjDK5x+BQgnCR90F3yepEjXbrJA045x9y7Leh24w++qybKMpwX/Qnb5ADu3PZDAE51qKqVVW9d22BdHv4K+y1kr72OJ24CMJPAwalycbt8aiCb/TPb4acKdxb70JXqaP/RGB1l9aXy+a98tDTATmkYOx5qmOP4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4058.namprd12.prod.outlook.com (2603:10b6:5:21d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Mon, 9 Nov 2020 22:26:31 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::e442:c052:8a2c:5fba%6]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 22:26:31 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v3 02/34] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Mon,  9 Nov 2020 16:25:28 -0600
Message-Id: <1b420ccfe763099dee756e935ce3909cee11d141.1604960760.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1604960760.git.thomas.lendacky@amd.com>
References: <cover.1604960760.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN1PR12CA0113.namprd12.prod.outlook.com
 (2603:10b6:802:21::48) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0113.namprd12.prod.outlook.com (2603:10b6:802:21::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 22:26:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 79f9d326-8876-43ec-8b45-08d884fe822c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4058:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB405877D53C3553D9B8560666ECEA0@DM6PR12MB4058.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ELstBj5BK0wHuefz1jGCejFP8BiythMpU39LKVnidxkWzhpUTen49qRLS9DBSxSrEjKmrPPAOTbSZAiRmsI7xHLsv8PPKNANP9G9SAJw2dfg93eTvRQwu8Dc89QmfioF2M2vmlZOjFiJOR4T5ay0s9f3/vE6FVzqDeBNqMEtO0cGwGj5MiwPDr8o5VA4XyhoHMtZwHPhNqmlX0UPOzdtC5RIvWsnBRmnAHndO2gvguqe96W7fLTbrKs9RSfKUEG0gHxzwPgC8ykW5S4p62qZ28mcqX6R78DVv2NzniZaTywMXCpQ+ACA33dlM850mooYuGk6bobX9nfnOnZ5r7gQOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(2616005)(956004)(8676002)(16526019)(54906003)(316002)(86362001)(4326008)(26005)(8936002)(7416002)(36756003)(5660300002)(52116002)(7696005)(66556008)(66476007)(66946007)(6486002)(478600001)(83380400001)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ISmsFScE87uw/NN1Yx51eMGCmtRMoKYNmgjOC2e72KB5KPTAwVedbiKklleBvAHFmg1j8vWqdqZqb/wR/9eWNFobOQVks4N6mGrOEzuKPjXR2RHPm6v9Z5JQGFbmSINnM1L/VIKTAam76P3YdwnOcFHSuEfq1rpFtTkES4Q0hgBJ+sPrGbRgRQZmlOSnaS6/seRxHKX+ZoUPafbODcQgJRiwTl+tHkJgRnLeeSMyz7ZxkZIyrBngF35Tt2btuCjtjRLo6Ng17ao+x1rR0yglU59ecD19w12MZGLdEgvYJBK/CKPzmZ2jhdIuJLwOWQwX673RIArsNCh7vNZvBbx/6ghTaa/OC3icpSGXOOCOA/nl9RlqV+op09avlm+Rss5OLct/fmsoWIa5wshGwT3zjV+FSTPGjOO6FNh30pDKkY0R7zpg+9WgxnKBEvBz6B8VUTuhZlXYYYFUgStp3gDs+S5VHamIatFA/AyRr4e5kIgVk8Y+pbXCKQsekFrrtDHoAK89ATGFqV51EZIIEtWyBqY6gWMOBEzDXtVMrI01EP6gKe3O1utQL0WfdJ/lmt495F002L0cTUJ36WL/Bhnny1Q1+pN15c264FoEEYYiNM51SChK1C2liyaoujAJ+cxXK5iqHRfc5lBZFwC7HKcBQw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f9d326-8876-43ec-8b45-08d884fe822c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 22:26:31.5551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gUl1WVMFXVQA05kNmershwvqfLpFaxejLUSrpv5uhKE7KJzo8NawicDpcRdbuCaOJF2wFEM0DCGrWY7cGJhuUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

When both KVM support and the CCP driver are built into the kernel instead
of as modules, KVM initialization can happen before CCP initialization. As
a result, sev_platform_status() will return a failure when it is called
from sev_hardware_setup(), when this isn't really an error condition.

Since sev_platform_status() doesn't need to be called at this time anyway,
remove the invocation from sev_hardware_setup().

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c0b14106258a..a4ba5476bf42 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1127,9 +1127,6 @@ void sev_vm_destroy(struct kvm *kvm)
 
 int __init sev_hardware_setup(void)
 {
-	struct sev_user_data_status *status;
-	int rc;
-
 	/* Maximum number of encrypted guests supported simultaneously */
 	max_sev_asid = cpuid_ecx(0x8000001F);
 
@@ -1148,26 +1145,9 @@ int __init sev_hardware_setup(void)
 	if (!sev_reclaim_asid_bitmap)
 		return 1;
 
-	status = kmalloc(sizeof(*status), GFP_KERNEL);
-	if (!status)
-		return 1;
-
-	/*
-	 * Check SEV platform status.
-	 *
-	 * PLATFORM_STATUS can be called in any state, if we failed to query
-	 * the PLATFORM status then either PSP firmware does not support SEV
-	 * feature or SEV firmware is dead.
-	 */
-	rc = sev_platform_status(status, NULL);
-	if (rc)
-		goto err;
-
 	pr_info("SEV supported\n");
 
-err:
-	kfree(status);
-	return rc;
+	return 0;
 }
 
 void sev_hardware_teardown(void)
-- 
2.28.0

