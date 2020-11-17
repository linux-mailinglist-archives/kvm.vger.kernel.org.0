Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062622B6B32
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 18:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgKQRJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 12:09:12 -0500
Received: from mail-dm6nam11on2081.outbound.protection.outlook.com ([40.107.223.81]:9824
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727816AbgKQRJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 12:09:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JmhQD7vbP/VB7QRMw+UYnyHWmKNzhbTEMyRAftFTBv7B/AKlXjXHPrhMUrkrWs6N8Rh1kNTdQR9+hXXEo3eNjynYqkaCq7IJ9H/dySPRi1Q2TQ3ROuz9yB0JN71pPoAU7dFUbltwHwcPGUY7x1OCjblBwD19S5cJkrIUdZ6c2mQdl9NAw8jStZ5oYfo6vKHXJev2Z/K8g0pLG074T0vqth0VPy3c5t8EDYwtJlcQrBnrOFfFsB8RJr4a7wmfAfSAZZYgDG/nmYyQ2bo9yleHGbvFiQCjfltIHbAMcpEQvaet4iZ3vd/JZ8aDyPE0Yr18+421QNBZAIu/qNBOfYeqBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCPd1cemga2nT9Mliq6eEgmXXXeJRbwSStRGkT1lprA=;
 b=Xo7tKU+COO/yVKdnkGoXNHOi9PeqBe9i0CHL7Q9agUj8i8EkdmIxVCHIYyOkeFZVYTNEoD5fSxDprJfChspsvz1nxZQSwyJ6I8nwwuq+xdqVheueUy8VQwT9uRSmmPPIX92Ax6farsqi6ijKoV/V5c1Ksv0+MdKY6vBIxbvzcWQVvLiMkPmfWxHWVem5XV8N7768s3UOI3qRMAL6eBI50k4ju0qiaP6y2pGGKSsarXqpdyaKXc9KNT6SuFOVsP780gyiTM5ojTiXyFxZr88Otw1yeZAV2aGnZazEVeFpMuhADQ35s5+3lJ+yqIWCFhCkHJNDEDHqPxmTdfosaIPBYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCPd1cemga2nT9Mliq6eEgmXXXeJRbwSStRGkT1lprA=;
 b=j0JHmuoPC9nk12KbbXwewTbfJIQA/kDKXG1mUsGHjQmUb4Z3JinisMC1UkihZAvBppjRBxnFa1PYghDeTDo8deJV+TvjVxv6chF/E6fVPzrKvh4/rCXYNTsB3TV8FBMGGlyr3Dr+sumnvSdgn/8eapGLJ6d5MwuITIMzXG42XnE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1772.namprd12.prod.outlook.com (2603:10b6:3:107::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Tue, 17 Nov 2020 17:09:07 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 17:09:07 +0000
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
Subject: [PATCH v4 10/34] KVM: SVM: Cannot re-initialize the VMCB after shutdown with SEV-ES
Date:   Tue, 17 Nov 2020 11:07:13 -0600
Message-Id: <71596ee517ed3a4eaf16721e7b5fa78fa93be01a.1605632857.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1605632857.git.thomas.lendacky@amd.com>
References: <cover.1605632857.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM5PR13CA0015.namprd13.prod.outlook.com
 (2603:10b6:3:23::25) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM5PR13CA0015.namprd13.prod.outlook.com (2603:10b6:3:23::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 17:09:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00d4eafc-384b-44e4-6db0-08d88b1b7d9a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1772:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1772670B2919EB3AA0DC2491ECE20@DM5PR12MB1772.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +9EkJ81nvPmqA8cPFDOO3xsY/skRIuvOv6DYQxCgxU71kpL+1qTgceCC1Ip74eH46fquYl44o+xskuHh1BfRFlw9urTfE/i05CupLxNHel/hLDLmF3sLsMww0/qLpV5dXe3yb8JcVvACqZ+uTD6IxI4LOdBfNZk88qnGv+Lps5jMcfv2DwdWCKfJY/RRk7M1C8LIhLabwqHMaSh1rZSZr3j2061M2ziTdCtpoLHfMCtjrpNiAHeJU4pkLcguD2+AJ+X8Zts+hYyPf5xOW8GtqpaoKcxxBlD6JnxvUXAaO2or9vd9I7l+1wM2+Xhnwj9R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(6486002)(66476007)(66946007)(4744005)(8936002)(5660300002)(26005)(478600001)(66556008)(16526019)(6666004)(186003)(36756003)(86362001)(8676002)(316002)(956004)(52116002)(4326008)(54906003)(7696005)(7416002)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BXLZi1WUNKXrS6fvbkJV+WYxEIRmbtAWLm+FplkNZYYym8uhX/Wil36ZgYg6fqxhIhd0UxXYgIoA9DSMEdhbVDgtfGo+8edPHpnnle6jtNCbyLMt3q91AIN3nv3sWADS3Ff6H1mOpoH97QU2+d3tG9pOq8dGxeHmQOf5C9vonk0QVtozgooHMFLcyYGlhyBeA3EiCFE1qiNRJC2M+S/t2cF4+4zNJbOtWm+RU8HeKFACXdrOyjgljO6YRnMLkqfqPBTuQV+1SaeRgDgRGwKKZWGOQrbq/lfnbJvuO8dvIEgDdyyX9jQwrNs1IAwjy6Q5RBjnvBfbciFea7KjNu71AxIPYUuq9PMVFN59QPoUUcfybZxRU2QEbqxPm24075dU5P1YzaXwQ+WMiN/rahLQZ5fQTwB8WIKe2OUJaoLHkAcnBJFQdZWfdbwn69i9gtRfxXJQ72QF0nHJEdpEroP+R1HP9IElu7QfFA6occfc/Shb15ePLUZohMu1yb3NPPBLQPs2/wI2QCL7UjVHwDc2GQdGHG1aGNaECWwi9EuLZyiO9TLGZqGW6hSqei8lt/aBFHSlcao3jBXCrkCsw0u/b8eq6XnG+90IlkSNTeXF+Hctoz3UdcgziFmmwgQT24ZzFd8pfms6hlcpu719ZvTgJw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00d4eafc-384b-44e4-6db0-08d88b1b7d9a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 17:09:07.3080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xlOpey34vQ70zt6mhZY/Kfu7K+xl0PeLy2+Ie+pLvkFmFzUBPQisY5eB/jpnjryi+Sn6dVGrNFRLQ3SlV579tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1772
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
index 0e5f83912b56..f353039e54b6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2026,6 +2026,13 @@ static int shutdown_interception(struct vcpu_svm *svm)
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

