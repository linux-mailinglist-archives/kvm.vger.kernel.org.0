Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB2E26964D
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgINUVs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:21:48 -0400
Received: from mail-dm6nam11on2069.outbound.protection.outlook.com ([40.107.223.69]:56449
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726093AbgINUVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:21:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ94M5LBAjoQ8VjmXctEV71VgaRgzUtDY7FWAWTVIdtzKocgUKJo3Y7EJDkfK7o0gwA1qILonQykhGBuHqtPJYunwc9TrybiZg16WoBZvho+w1fs2sgBOgosKnhlPO31U4ssCo2KIQXBCZE5LmqUlCvkFatsX5mQO0zAXVF7hYNY6aIuzQ3lrh1+h0DK8BZrd3LBCBJp0pvHDcBaejZlNuKV5T2J8DiRwMtFPy9cazs34VHJ/UoihbUbrdMpw1smwgLRqAryW3o+OSKDWwdV13pvFfKdF3y4KPh4WXUabhoAZsh8F/FlqtXNhl/VXaMxwlSgdiYEs78BjAytFnV1eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjrf2G55w0tPZqwal/5bfG5DbYxgP1yRtNxlPhfX3RA=;
 b=GBtJgEOhoCXX8fT8EadZS1jVNfoRjddba7OSv6rOEtbfDDtZtLJsCW3sNQvaNH1MgiaUc7f+x0Gtev8FSsiu5GyBUrQ03EFx+cLHT6hfnRPXLVkVscR0gPGwVC+MqjCbLwtVcpSGPEyMQQtq09P7zRFUK6nkeMmRvTg70kJ07s3VPR6P6tGkFHeoOrn1/hR4E9GtYsnAFi5Al8nh1rjGVdZA4b4ra07u6obLDQH6gwrNh+EMvUBHC4tpbWwQXpVLxQDItx/eAHkr+E6UEJmRVqP6shMwbGvvrbqeAGO1Pc5Kx7dhBiHiOjMUwbX5tJC7XrCrtWoblyKLICzMSCT1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjrf2G55w0tPZqwal/5bfG5DbYxgP1yRtNxlPhfX3RA=;
 b=OD4ASn+9GdSSj4DyZWzbpWhKUiEZbswOXVoCp5VP2JJUGnvaXuSSwlm8JDQ6NwWdrJx+TjRUUKES4OXOMWfKIOJt05lNqwGeGF0h51CCF1ehuQ5RsTSZHEGwuumcAqmQJQ3rQkaVLsWdiSgBLHGQSU8ZrTVLed+n/4QMtpTVIUo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:19:44 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:19:44 +0000
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
Subject: [RFC PATCH 28/35] KVM: X86: Update kvm_skip_emulated_instruction() for an SEV-ES guest
Date:   Mon, 14 Sep 2020 15:15:42 -0500
Message-Id: <ff66ee115d05d698813f54e10497698da21d1b73.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0063.namprd12.prod.outlook.com
 (2603:10b6:802:20::34) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN1PR12CA0063.namprd12.prod.outlook.com (2603:10b6:802:20::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15 via Frontend Transport; Mon, 14 Sep 2020 20:19:43 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 34bc036d-1e65-4c35-9f38-08d858eb84a3
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988DCD12B356768E34C8690EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wFQjlMaGol7e3QuAsJjuipgQbA6Rx13BADAQuv7grtU0oPpXw3eMImxwpA7mXIkpIKmv8yoe1BfB8umC3es31wrTXNDWyo/+pw9pv3sRqzUyT0wP7/IEnWQq79VrXV7XGZVYXVfl5ps43y4LsBCAEm/wRUgqCl2b3dR58I4mXzhdsJbpvNExnCpc2ZUi+PhhfwQfhL/ge4V6gI3l82FZ+3ZsyLv04uzeQwt8D2ITpX/otBrjeFmEQKUwH706qAujaFfXn/bG1i0C69JkuzgVc2/QHGLcgDT9Iis8BOAV9+9lrAS2oGrituaxhvFe9HQE3iKC/+Og1XN6i3tR4/Z/tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(15650500001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tknN3+R06CR63Fz4XmzEFwQof/kPY9QpCXrBIyKOXJ+Hp3CDBlKBraDdz9tToZz9nhOxN3B2lz/HqabtazBUc8nCBmkS+TpnNh1ct153xOqCMbtneUTioLaGzss0rMbiJjvlTjmMroAEjg4mAIJIvWOnqBcritwsg82Lb07yuNWT5qvkkrpbvviUpfPb2CUYAwGSuMFDihthz4k5x+pPKQOrrNc1kBwOWIkGTOpOH78KMDOOMBszPlVaj/SyctpiUUArSvN5weXTcRVApUYk+gOjKMARTG5WQk3FDg4/+iI1BV5h+FtcTgF2pcEom30kfmYiGvMuoteaDJHJTq3/IhoPUvtc1h+WALvTgYi1UYPalKDpGwpZ2ElyKOXaTL4fzZ+jOy/jrDFzunmQ4uE6OiLP9i4q/3EuLjSMcTYxe6lPribb3PVcDh5DmyHuKOLDO1IaSLMefEM/iOtc9gm4HapnuI1BXSbLSAPZpyxQya/cNDWQA8g3Z61T+pCs6Tohx13rwlDqA8LKfp4qxEwtZMOyNhW1W58PfsRBcLnBeRENzTSMP19wMUVFbB4uLlLlE/u6DV0roduzuBaMcwY+GtcTsS5FwSPfP8sJXYWhdAanu54sIgNeQjSmTrzzkjB3dfJvEtYQdRjuwiksYNoJrQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34bc036d-1e65-4c35-9f38-08d858eb84a3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:19:44.1518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C52H4tXeeQIUj3T/E6sVlyg51W4oJ6vMxARVM+MCjkfsmte5ei/7tkTuh+vG9i7Hf3vL9Wl49ch+wRoEf1oJmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The register state for an SEV-ES guest is encrypted so the value of the
RIP cannot be updated. For an automatic exit, the RIP will be advanced
as necessary. For a non-automatic exit, it is up to the #VC handler in
the guest to advance the RIP.

Add support to skip any RIP updates in kvm_skip_emulated_instruction()
for an SEV-ES guest.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/x86.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 23564d02d158..1dbdca607511 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6874,13 +6874,17 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	unsigned long rflags = kvm_x86_ops.get_rflags(vcpu);
+	unsigned long rflags;
 	int r;
 
 	r = kvm_x86_ops.skip_emulated_instruction(vcpu);
 	if (unlikely(!r))
 		return 0;
 
+	if (vcpu->arch.vmsa_encrypted)
+		return 1;
+
+	rflags = kvm_x86_ops.get_rflags(vcpu);
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
 	 * not been saved yet.
-- 
2.28.0

