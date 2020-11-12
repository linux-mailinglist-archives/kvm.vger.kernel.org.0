Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B4D2B1142
	for <lists+kvm@lfdr.de>; Thu, 12 Nov 2020 23:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgKLWSH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Nov 2020 17:18:07 -0500
Received: from mail-dm6nam12on2062.outbound.protection.outlook.com ([40.107.243.62]:26240
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726290AbgKLWSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Nov 2020 17:18:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnAIGF9u3J3+wGVl63r97mmKTzLu+bOqYmy8iaaTTeZe1Kide0lGghFlFb+1xpdwFV2L8HZ50/VxOlks1LmGowS1RYZI2aDcIYny66vx6ePipgmKi/Zq/vVgMdoZ9yTK7C1XaRRcM3v07XsKQoPRtt6AncFg/CGHTHdxVcdlnyrnyY282aVcpeKXRDhD+/VIXhhzeIwQtxqIsMhTr7E7KNml1SJrWNZdarw8s0VjtIzPSX+AldII1R3D0MrI6FL95878VBt8oQyICDdlXEXVqTod9A2XAo9bmkTwYAALw8ryw+wAfwciK04pA+tKXQHcIkLwkGc1pU1Y9J4wx77qFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgW/1ozsQ1ExT4ew6yFUML6jPPlqGusaD9qhAs6FW1c=;
 b=fvvfqDh6SQ0MDwHHK6ogbR9xQmh2QvEQpSHArdjtLPQh6XpN1PE2hzPv2GVmMFD62VaJoPIHfLBEuSu/CzrNSWMV8j9ObPZyGEKNXa6WzCPCCRdEsbEOsPDm3rmCqxgm5EzisSMz17DHZnQIqo2VNHld2tuCjnV0sOapKlTjnk9uef21+mraXpX7mRgOvM4UrGLiCYn2wZL1sbrgWcxef7IuvD3XJ1G3r6eFPK+mCkTErLWQ+WSDEDfJCqXB2KgE3NXmFCdQ1JVcWZmeM83QtFkCD60I+MAQTMQbuMyxrUfRUvzwjJ5l07Sr3vlbypE87Wd0PuMCV3qEQ3c0g0CwWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgW/1ozsQ1ExT4ew6yFUML6jPPlqGusaD9qhAs6FW1c=;
 b=Oi/I3CVN0pJnOtdZhWGmxdGIsVlwNW1AfxiDv2KGOuqq7p4CnyLdOXwqPA3sKFTTwJREfAnmhgSsxlEuCta/F4nh8XlseDWvD2Hyfm3tS2PQWDdhb4MB/dlANHxAVXaCr1Ki6WZdJgGuazayHsi0CMWE9Nb9zBuZc1T9xZv4qkY=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4445.namprd12.prod.outlook.com (2603:10b6:806:95::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Thu, 12 Nov
 2020 22:18:04 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3541.026; Thu, 12 Nov 2020
 22:18:04 +0000
Subject: [PATCH v2 2/2] KVM:SVM: Update cr3_lm_rsvd_bits for AMD SEV guests
From:   Babu Moger <babu.moger@amd.com>
To:     pbonzini@redhat.com
Cc:     junaids@google.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, mingo@redhat.com, bp@alien8.de,
        hpa@zytor.com, tglx@linutronix.de, vkuznets@redhat.com,
        jmattson@google.com
Date:   Thu, 12 Nov 2020 16:18:03 -0600
Message-ID: <160521948301.32054.5783800787423231162.stgit@bmoger-ubuntu>
In-Reply-To: <160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu>
References: <160521930597.32054.4906933314022910996.stgit@bmoger-ubuntu>
User-Agent: StGit/0.17.1-dirty
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0060.namprd11.prod.outlook.com
 (2603:10b6:806:d0::35) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [127.0.1.1] (165.204.77.1) by SA0PR11CA0060.namprd11.prod.outlook.com (2603:10b6:806:d0::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 12 Nov 2020 22:18:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d486f657-959c-4569-cb29-08d88758d347
X-MS-TrafficTypeDiagnostic: SA0PR12MB4445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4445502FEF44E94120857CD895E70@SA0PR12MB4445.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K9RniAIqQ1bT+2w1XQ+34SaVUQ6Ts6cItFf2WbnhV/RB+BlHArEq1nAvp5HSeeEUxxKLLaQHO/ZeE55awB6kVPOOxJzbEXwHs2nmOAi+Z8DOu1G9+yfTcY8QRJV5/L/LZC8x2Ny/mINpcA8GRADbrIwBiJagchJ/NtvSs2wUhXaeebD6ewOQrdDX6VtsFwd1a/DERwB93QJhOVxje0jX/4tBrSXmgUCKmvWc7ngF73esHdB2FF6Toaua5Vf2lVf/qPGeNri0Lv3kPrUxpZd8/xMKVNSyz91vQEfHiqmyK7E/fAS7llMgfWO3+aobVFyr1a2+6f8COp/OfCwqgBTNcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(52116002)(33716001)(15650500001)(16576012)(9686003)(16526019)(8676002)(86362001)(6486002)(103116003)(478600001)(956004)(6916009)(2906002)(66476007)(8936002)(66556008)(316002)(7416002)(26005)(4326008)(83380400001)(44832011)(5660300002)(66946007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: L8G5026cqDOEaCI42wlAZj0KsrUc6hbbwCFaCf7Wj8kJLJC2hbG9D+EFbdk1iZEO5tvmHR6xtNEdDLX03zDyYkhPJT4EFPPyL9HqZLHt5qtbbVohVK09cvJ9VvyI+pwPuvCIyZ3nG/csryIhSALnLT41jYTJYIr+tpmoeQHFvKZh8gGCqS78eKInF8PPCyZQ1TTMTD9T2AauWbSbP0zatjdGv5ZkY6xjE+Sp4lT2OyF2dEUyKeyyFngpxJYS46e7YAWpSMZXJxzmHcBXXuBCAyLt3lBEO7WBj8TlvSFUjMlN4jMF7qE1aZ7tktIxyxeFwP5WDJUYjb/GpsySr63gWtSfruJrXlsBmSaDwk+YkkOKdULCWHg916gn1VyI9wy++gspbxpzbZGahqa9hLV93MoRV+luBTWnWAB+9CjYAAvI/P3Ub4ASxkEqueyxfKykGzRLBDJJ9EU6vd6Zu6m0OpYwTn/u6HmFOiH83azd2jMcNF9v4pkl/tDOhPLCpnZ6bNpdDS3umqUGYx77g0JulB0Fbp2co2Yf7KsI7zrcVzxhfZFniCBTJZ2yDWVJKiLvf4aI673iqFI7xo+A2E67DOyiHjyYwBpFuS/QFZtQqBECIV5vrlJM6tbLZR1kyzK+Z3dcn05VRJT7WftLhR972A==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d486f657-959c-4569-cb29-08d88758d347
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2020 22:18:04.6593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uwhm8aULA2ax7Z4xluL7ycZirhsvV9axkQFILM55R0RawlYXsXYGnFE883aG4Ph9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4445
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For AMD SEV guests, update the cr3_lm_rsvd_bits to mask
the memory encryption bit in reserved bits.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/kvm/svm/svm.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2f32fd09e259..b418eeabcccc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3741,6 +3741,7 @@ static u64 svm_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_cpuid_entry2 *best;
 
 	vcpu->arch.xsaves_enabled = guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
 				    boot_cpu_has(X86_FEATURE_XSAVE) &&
@@ -3753,6 +3754,16 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	/* Check again if INVPCID interception if required */
 	svm_check_invpcid(svm);
 
+	/*
+	 * For sev guests, update the cr3_lm_rsvd_bits to mask the memory
+	 * encryption bit from reserved bits
+	 */
+	if (sev_guest(vcpu->kvm)) {
+		best = kvm_find_cpuid_entry(vcpu, 0x8000001F, 0);
+		if (best)
+			vcpu->arch.cr3_lm_rsvd_bits &= ~(1UL << (best->ebx & 0x3f));
+	}
+
 	if (!kvm_vcpu_apicv_active(vcpu))
 		return;
 

