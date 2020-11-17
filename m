Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D972B6B1F
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgKQRIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:08:11 -0500
Received: from mail-dm6nam12on2074.outbound.protection.outlook.com ([40.107.243.74]:57312
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726196AbgKQRIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:08:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTWDSfCjTJTG3O7ueSuireRb0XPcA1jwUiQqE5q9wb+st8HzMAJjVTBUeS8bYyKdp753FvhXfJTZGEQqN4Yu0Tn5SLCaGPA+qCwFDj4Os07WrOU2L3kR5C5KEH6PeUwloxenMetdVM5F0EpdzxBQWYnDK/rzjxQ8yMsj2Pl7e1G/bWUi1dkRKFd0dyWxSgvavZvN68wNiXtP+l0e/9PWtBX890lTjS4PEqtJdIuZm/Ha43HXy4/d0rBdimOdgzUe5Ut5tD23Afr2S27LK/Dydnsy0CYT6CVOzXIVa+YgAWEZAS+YXKCoE4CHbP8aGGXnHxYADhXlLqIm3Zkv/qJCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=e1+SlwinsCbu4HnakV5ouecDs6I2PIuj5T8FJytN+oWRWRotlwm/4bcoyImMVhIJsslt+U2Q1IpTZvj/mDPJElA1xZo1LbaFOEfIHxMfyz0kBIRRDw2VZfJkc7rkyOr6JwH782HPAlTz1k6kxBf63PPDgwRrzAf/GxqN5VWGlrl08gv09tlzNQkcsOiMSKZcXIoOFB7Z9cHbSqoqikxRS/Uc6ohokjQJg753FY4hVcumo1jxoGjBqPzhl08qmxzPf1Y1aSzBG0suAbLtasCrkjL18Xc2qEnKvfvodDRYZ/+4zaNgdAruIRzOJNZYeFjBImOXmVJmOh39MNmyfzQK5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dezrM75SgkRzYWh4Ln72KARkco3Iwy+sJTmsje+sres=;
 b=fQkQScjJUWstfJoHQn/EsI+zlKpMqlJ16UlXqTVGOLvBkAYn6ZsuWlgU2nvoNzRxienSJmoJNSFQXKi8kKFpEynW6Hz10r0C7wKWAsc2IxfarwDEdZ+XQhihdJXvZCHtJ4OcOVJuEXzTi6DSfSqcVJO+nMn0s0Yh3vO9FDRkiO0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:08:05 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:08:05 +0000
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
Subject: [PATCH v4 02/34] KVM: SVM: Remove the call to sev_platform_status() during setup
Date:   Tue, 17 Nov 2020 11:07:05 -0600
Message-Id: <c1dae227bf60684dc239569312b8d4a674fbf23a.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR18CA0083.namprd18.prod.outlook.com (2603:10b6:3:3::21)
 To DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR18CA0083.namprd18.prod.outlook.com (2603:10b6:3:3::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 17 Nov 2020 17:08:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 15646a3f-d746-44c2-7979-08d88b1b5996
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772BCC2F18B653525047A24ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tf+Vtf4g6KXn4vnDo6ISj1nF3F08vPjsFENzgPFMW5N6yrq/kRcHBDKJvlTBMg+4DsnuhMsLjamtwZ7QzbQFsOkjNPELnV0J8g+QMrw9gIv3I1skUvyg7aThjxeQzmB0HlYLcE72x9Ct7S4wscoEQLXJmAvLnCARP8hh19+VoZFigEg9qHzlfEKS+E0nkoD+7z34Z7/eJtNxseIBT+0O6i06GAAB+ey+jl7mBmdsKBnFyOcZYhprVbntKVYgNbOB7QIbDlOc4uO7GDirag+NXk8FI5RdAXJTyK4B00xT2da1u6zQ4T1uk5KnMAquJmw+3gfg47CeNs8hwG1IGKNfWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(8936002)(83380400001)(5660300002)(26005)(478600001)(66556008)(16526019)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ck5U+geNcfi/FcxFqV7XVoEdA8fT4Ou6c0K5wDuOTpACRI9I3yV9S8DLT6Y44xI/S6lA2oPHFc7j+WI+NqeZ7GOGT7GG2YTti/pWPMZLawDkXj2QRrY2xBjDSUESzoZPBvNNu6OK63pUXdwBU9LP/t9VTqxWeSwLt+cvh6gGFnvBcXaL4r4oVxoCtyP1fgtZxzf3le+qam9DfF+pHnpqR5+4/NXD3SwOXJHMrUlZiGMkvB2vEd5D5h9jyfXW43dLFlx+ohluBeRrli6JPLO7X6zxAzzp1khY82Gjy+Z3aZqfRjcLvHW5dS+UsGgulKo9THaVoYuT4eMTDckHFr1nK08Vu9939hRDkZ4+uE1+1s8mFVeNJzMj9eTd3iHeARvriTBzoTmLO0/vowabc1syL1q6G/BAAQ0pBq6tUBJhPp3SOmxnWS01phGCZDRO3uHMztkeYKXwSBpQ5dweseJzXLc37skYx73QnA2ElzLl2poCVmQP6theSAa1w1+vQVenzqn0mmsJ13qciCFzdbg3+TUGoMx/S/dHVwIxBKy20kdE0vQdcDJPl5LlfvfQnYAZOJ2ovL3f+rXCls7A74RG1VrxgYVV0qPmfcXRbneIJ+tZsKC//WKOLriyi+MnT06DSk1h3gzIhjvgKYlwU9RA1Q==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15646a3f-d746-44c2-7979-08d88b1b5996
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:08:05.8055
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 388/I6aYdWq3mV4Bnogt6iwf4h3kIFavzEPdWmPKpPfsVDHJnzC0nEOmX9TVtAUB4+sSRCSWSG6iKq27jVANGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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

