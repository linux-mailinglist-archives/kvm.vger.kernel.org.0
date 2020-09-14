Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF2926963E
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgINUTU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:19:20 -0400
Received: from mail-bn8nam12on2068.outbound.protection.outlook.com ([40.107.237.68]:3544
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbgINUSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:18:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmKa5y4J0+Ix6IYgOGrR8zRIpe7Ebe0KA+a74fTDM24fo1+0yC2q96yXh84GMBiYE7/swoG3Utj7vNKaqrpNCWLQAf1Zx76WEvDsCSFmKnoxYDsHf5kHLZ2XT8fEbytwngtTwtYNaBYdeqy4Mx+vTETSI+R9AHfP+bNvKNOd/hKNeEaeU3H9ScfD1zngUuEpRNVM6FdrTBZJiuWXbed3B39QnreiBHNFu1SMriUGjTBbSoQTXLANsZAmzvceoq1++IAQDMPYxr5I0u25vkCvuNLD5+BlSnbXMjqyXIBNQbrlFu+8IV5SsR9mQHkZ1EzmlYXh9Y9Ulyy928nrerypMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soe0+0UfVNPdWVLuVR9+O0Z5aUh3S+aeSfwQdbcR+Aw=;
 b=D7Psln6cZIGMXq+4yiUUJWe+OWqDG6dr4geKBoRse22m8F1xwPYJc2ruqYJ+zgkiG4NCPZWcCN9yRB5kIHBnhZbhGVQnxIkHfGMdpNI0p0wxHR8TX6D+X3MXo96TtPVgWUHmrCsX6NR/ePfGyE5qq+MbrhBsXini8L+uIafs3Fy5sQwlKGoYKPf+FmsCodILLt6hmk5pI8ztcuUdvuLpDCcmQs48RX4GQPy/dgg60KcaCYac0zgQb8TNOY9GSLqsepexLlPgrKs08ImqAEWotYIQxmpjUnSDooB3ezdB8ZfAYGtUDSfzB2Hpu19IRwWIRbCG+w6npT8oI0L70ZYkQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=soe0+0UfVNPdWVLuVR9+O0Z5aUh3S+aeSfwQdbcR+Aw=;
 b=sBEKUvwbLt1Pv+5Ec3u4P+zXMqThf+lw/llwlAIOY9mVwTsr/yZfqRoT6bS177K83ziKqV+C5+I1bUaZZn9cauR053sjLiwYZ4lAd27TXZ4cvi8tSsHybavYEE/SpzRiPJ/uQ+/Javmn0rScexErflUljMU8ZYgjgbUbNNVKN+I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB2988.namprd12.prod.outlook.com (2603:10b6:5:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:18:38 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:18:38 +0000
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
Subject: [RFC PATCH 20/35] KVM: SVM: Add SEV/SEV-ES support for intercepting INVD
Date:   Mon, 14 Sep 2020 15:15:34 -0500
Message-Id: <cc70b4ac7119dda48a76b0d3ab6ba99ace3c4b5b.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0054.prod.exchangelabs.com (2603:10b6:800::22) To
 DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN2PR01CA0054.prod.exchangelabs.com (2603:10b6:800::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:18:37 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 445181f8-c0cf-4724-4bfb-08d858eb5d9a
X-MS-TrafficTypeDiagnostic: DM6PR12MB2988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB2988F9F9230F88BC641B81B6EC230@DM6PR12MB2988.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Xi2yWaTL/dS3OhXsf1hkSxosHzPCbfCzyh4Psr4nb7+wkPxciZMfyRkRqia4YnYPaXgrnyjnvWaXbyGzi0cSJxy7GauqxehVnr0qNkaPfOMUROlgrbvUaj1RROgtMd9rmfyOcSh/jePwXYTZrsAfI/kHXgCTK2kM2i+vHJbv0IAD0EMmSETW+Jsma2to5vcy6BeFmq2IO+1oCwX3WzEWGdPN1E3dfqwsPSSvK2xbiVkXzyQQtHE2Pw54qhCNpTmYD5DPODc4y7oCfCh0TFGBQtYmUhVknTt/ejQmhWV5dPxUO6fVxTJFMHNblZNKyyi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(346002)(396003)(136003)(366004)(8936002)(36756003)(316002)(478600001)(5660300002)(2616005)(956004)(66556008)(66946007)(186003)(4326008)(26005)(54906003)(2906002)(16526019)(66476007)(6666004)(8676002)(83380400001)(86362001)(52116002)(7696005)(7416002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 8Na+cNvMsRuKry2n/Qop8cYhwDv8rq6grvFSzmkFmrqo/W/ALn0meS7Hdx7R1m01Isv3u5ayFdzgbBxFqy4K6IwvKuRyIXk3QaxgCkGtFD4WlmWFyKVAfZaGWoEw5aoYb4Nezko4oxkVNFDJHKSJujBSvdlyErrKFM+33JB0SlFVrYg0QPUlwYu0z4juTkkDZlJVfhYua0QkgE8qvh+QDf2Gz1usHlPEdEZOA03pNug1VAVp8oUmMkNXSmDYHiaD+R2ns0rVy+AGBx8fU07rs5lF0gGdYiqllTxE2NRyEkbOvcfMe4kCYMhi47mgmp4S5rR6HwRMcbJPqfeVWj1Qkvq6RmBbxkPywQUxKr6miojgktKQvpHB6J6bX5Nm6i8tPGBBeUTy8UqfxV8qsNFz+MP+xrVpKyfknyZTUd62kEBgVV20FRc1jD784nFAeBn/N/8vAjCAgFUOT9xYIdZjED8X8len4KPamo+dikVwoOGWYfjUoCCeuhWLM8IdFJaGVuJxImTmx83EhJCK49q0YGLnEB4fo8cEmTOqPzNWU7OFSF8Eed1gyLLnWFXUt6lfNAzO2WLfLGF2BAy37jniVIpD8pkvpv6wzSUF6G4xJpgV9DB1Bog8lwhJpZIQzShaNrzPHB2J7koNSRbLu/ECyg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 445181f8-c0cf-4724-4bfb-08d858eb5d9a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:18:38.5656
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /i49m5qjN5uhnQgjOJfG4PfXxPliNykygNOvJ2KP0wWYWy8xr/lD9Pcop4ogj7zRfja6vDU3wFGdh04aTy6r1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2988
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The INVD instruction intercept performs emulation. Emulation can't be done
on an SEV or SEV-ES guest because the guest memory is encrypted.

Provide a specific intercept routine for the INVD intercept. Within this
intercept routine, skip the instruction for an SEV or SEV-ES guest since
it is emulated as a NOP anyway.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/svm.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 37c98e85aa62..ac64a5b128b2 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2275,6 +2275,17 @@ static int iret_interception(struct vcpu_svm *svm)
 	return 1;
 }
 
+static int invd_interception(struct vcpu_svm *svm)
+{
+	/*
+	 * Can't do emulation on any type of SEV guest and INVD is emulated
+	 * as a NOP, so just skip it.
+	 */
+	return (sev_guest(svm->vcpu.kvm))
+		? kvm_skip_emulated_instruction(&svm->vcpu)
+		: kvm_emulate_instruction(&svm->vcpu, 0);
+}
+
 static int invlpg_interception(struct vcpu_svm *svm)
 {
 	if (!static_cpu_has(X86_FEATURE_DECODEASSISTS))
@@ -2912,7 +2923,7 @@ static int (*const svm_exit_handlers[])(struct vcpu_svm *svm) = {
 	[SVM_EXIT_RDPMC]			= rdpmc_interception,
 	[SVM_EXIT_CPUID]			= cpuid_interception,
 	[SVM_EXIT_IRET]                         = iret_interception,
-	[SVM_EXIT_INVD]                         = emulate_on_interception,
+	[SVM_EXIT_INVD]                         = invd_interception,
 	[SVM_EXIT_PAUSE]			= pause_interception,
 	[SVM_EXIT_HLT]				= halt_interception,
 	[SVM_EXIT_INVLPG]			= invlpg_interception,
-- 
2.28.0

