Return-Path: <kvm+bounces-3644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C14DF806318
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 00:50:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 748DF1F21764
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 23:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE7434123E;
	Tue,  5 Dec 2023 23:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lQh7+nYv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408F618C;
	Tue,  5 Dec 2023 15:50:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j538p6M9GejfRI64TfQBZPEaPkDtYn5aRxBDjZsg8iLkcLwb/IR5BvC6WFP7TztpHBuTmMw4gUY+BCLyk3wwxszPnqBXJjkp79cRf7XxiTq5LbaGMlBIOBo0g0e70VE09vOaFMkOxwivIm+0VQNmlXHTSQw4mt7dr1FJGjlvf+46deMxZHSJPQP5Nthx2g3x1xh8XsHqoemRr8lmtYm8FzKbuwqSYJBvVRWAuiLiAGRn/M8sioed682ugKK9OR0izHbozbFpnL24dBfShMvDFytlC/L/8OeGY6qFqWI1WV9XjYBddB8gxzJz2WOE4ptTvTXVgv9TXjOTvgC+gvEAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PMdYy3O1Cpgbmo1vLEbA3kKWDu536YFAQ55nLgD2apg=;
 b=aPjAEWq0bgvtYZVMvir/vDqOUCUWAEyBBHA+4HrZ/x8d4anYH3TXRZSCh+0+OEYi5pZphTNI71hS/NrpnF4mI2CmU0I6caiK58wr4NSUlzty27cdp9mtufBGrXRpZps+1sYWOGDXN05HI568oAwPzmTiQm9pTBzD0DYzohAKa5+Kes/Ie8lw+W995fOlThoUT3D2yGuPPyBMBhptes9WTJ7xa8qrTvXvY1Um3QVMCza/Imj0aGkgJ32fdB6Dd2pABjL6i0kbrSRdoi8jmo+TY3Vz9pAJ+RqGUrMKrX3To2JQL9Smyi3bfQmJ4mE/Yr/Lw5DuvHANCkk2HbMWDrYBxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PMdYy3O1Cpgbmo1vLEbA3kKWDu536YFAQ55nLgD2apg=;
 b=lQh7+nYvgJyyQPx2zUV/fVyx7PKED6eQ72UMfwgWhUBD+pTs9yquNUqL/NZmsh7MlKn7RH01vOOuKhhpXtP6yyoPQEkg021t1rmUIYXTt4qX1oDr2FXb4rh+wZtB1aQwLaWg9c+kSCS1Wq3E9LIw90PNHob6jaL/Bs+O/nToGFI=
Received: from SA1P222CA0111.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::8)
 by PH0PR12MB8007.namprd12.prod.outlook.com (2603:10b6:510:28e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 23:50:22 +0000
Received: from SN1PEPF0002BA4E.namprd03.prod.outlook.com
 (2603:10b6:806:3c5:cafe::25) by SA1P222CA0111.outlook.office365.com
 (2603:10b6:806:3c5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.26 via Frontend
 Transport; Tue, 5 Dec 2023 23:50:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4E.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7068.20 via Frontend Transport; Tue, 5 Dec 2023 23:50:22 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 5 Dec
 2023 17:50:21 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] KVM: SEV: Fix handling of EFER_LMA bit when SEV-ES is enabled
Date: Tue, 5 Dec 2023 17:49:56 -0600
Message-ID: <20231205234956.1156210-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4E:EE_|PH0PR12MB8007:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b1e1d2b-b18c-44d4-5f21-08dbf5ecf1fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GuaMXyFiH5KwMkUhcxdZanD/tai+Dkxcjt2PRouHZgw05cMsWOXs7aPcdqVwoEMCnj8WnhdxiGeHip7RklcSlgbsPUoQVe6aND6uqnE9Ib7UEKgYLVGpdVEibJDTDeUYAX2OtAsLtoXtalQu2xu0nx4YFI1OujaNvwLvnGxfs6L3QnSAk0wSXccpuIzykCiebU65k1XeRFaQx6y33Y4pTQ6TNraKzfOH8r5KEUJSOMz255CLGW+HAK4d3s/krsXBvw7IKRaUaLPn6r6uBrHl+DcmPKp+0OlSePnqyY+DnoZ6XxLWMJsEvAp7TaekUfe6hWLAfE97IzXi6bQLxTfx0b0L+0txhw6Vk92VYb7lyhYhD+/Im9J+o6gaBZ8tdyeZBFjuPUgPsPA12h2s4OT8p94ojJaCWjH2mcX9LH0y8nswsdb6HP5q/wGC3Xw2FXjaTuJRQ3PrBAtC5911uaX115D1AAjdn8roOqkB/O0CVTBDSPnV8OyR0GT5wRB20FVX3XHqvgrFJ7v2R8ryeJ0gsRllg5Q1jauGvhmLlkcYOO1Hv/qn/oCdH/ctBWPuX9YCH4JVKp9AOLBWpKU0atmS6c7aMZ5+0HoC9bIdaray+vUFXC3JFgki0bd+NnTPcCHX15sr2sYkb7VBWfSg1BG4ctwoniST7YS6IA4dHAeDf9n494mxysX+rSlU55A5uIU5lSYVlRuKivY7oLTGkdL3Y/ZxiebCbYMRSUmzU79peSe3dFvxFRpy58kIbAToIULWX0xmtOrN2p9DnCUAsBgeYg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(346002)(396003)(376002)(230922051799003)(1800799012)(82310400011)(64100799003)(451199024)(186009)(46966006)(40470700004)(36840700001)(7416002)(2906002)(40460700003)(478600001)(8936002)(8676002)(4326008)(6666004)(44832011)(86362001)(70586007)(54906003)(6916009)(70206006)(5660300002)(36860700001)(47076005)(356005)(81166007)(82740400003)(26005)(16526019)(40480700001)(83380400001)(36756003)(336012)(426003)(41300700001)(2616005)(316002)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 23:50:22.3367
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b1e1d2b-b18c-44d4-5f21-08dbf5ecf1fc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8007

In general, activating long mode involves setting the EFER_LME bit in
the EFER register and then enabling the X86_CR0_PG bit in the CR0
register. At this point, the EFER_LMA bit will be set automatically by
hardware.

In the case of SVM/SEV guests where writes to CR0 are intercepted, it's
necessary for the host to set EFER_LMA on behalf of the guest since
hardware does not see the actual CR0 write.

In the case of SEV-ES guests where writes to CR0 are trapped instead of
intercepted, the hardware *does* see/record the write to CR0 before
exiting and passing the value on to the host, so as part of enabling
SEV-ES support commit f1c6366e3043 ("KVM: SVM: Add required changes to
support intercepts under SEV-ES") dropped special handling of the
EFER_LMA bit with the understanding that it would be set automatically.

However, since the guest never explicitly sets the EFER_LMA bit, the
host never becomes aware that it has been set. This becomes problematic
when userspace tries to get/set the EFER values via
KVM_GET_SREGS/KVM_SET_SREGS, since the EFER contents tracked by the host
will be missing the EFER_LMA bit, and when userspace attempts to pass
the EFER value back via KVM_SET_SREGS it will fail a sanity check that
asserts that EFER_LMA should always be set when X86_CR0_PG and EFER_LME
are set.

Fix this by always inferring the value of EFER_LMA based on X86_CR0_PG
and EFER_LME, regardless of whether or not SEV-ES is enabled.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/svm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5d75a1732da4..b31d4f2deb66 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1869,7 +1869,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	bool old_paging = is_paging(vcpu);
 
 #ifdef CONFIG_X86_64
-	if (vcpu->arch.efer & EFER_LME && !vcpu->arch.guest_state_protected) {
+	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
 			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
-- 
2.25.1


