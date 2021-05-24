Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2805D38F27F
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhEXRul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 13:50:41 -0400
Received: from mail-mw2nam10on2076.outbound.protection.outlook.com ([40.107.94.76]:9825
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232744AbhEXRuk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 13:50:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYUsPb6o4v3tAuGhFsR9SFMUVF3hTdD+Xu8+zMBCCtP9pqeosym2fLa/g02KsF/aoM/aeZScbX3EHGR7lc5kGgD3/VkOeRL2gNJ1RXn6m1pcPgmUjEjnMDL1MTArnl3BFbzTkCYSAFTjzVPspxIEo/igq0awPMXl24KcCdzUgNSX7zOS4yVqeOAMpoJOhonKWBA20JLRhCo8ETHOPDBmmkKOLuEEiQHER/aLtMr6I3GqUT8RYIHGyVocULQWwP8aHZn0H7JkktguaKdGvqGH5gyEfjdw2iszHv31a0nJuCXNIl83B9cYFq6pY+De5wU4TexEfp5Mz0P4+4g4536a/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yv4E9v6+JkLXnTnGgLFaOyltYYKy1dQoj/qY57hJKw=;
 b=aKCLlj7T4CcyP+JT6AoHLOOsOYFjq5XHqaDcERwWLn8o0CqDTp4nVawobA8vIAN274UXjNiVjziWija753OfVRqL2IkPsB8fSXj4O473Tv2yGXkhUXoyD6KfkUDRqjJ7FBAh4EM6UOfbEmi0MgAF3Us1aHsq/fqXUCxRTe+TByHwrXFhiir2C/8aOl+oJ4m7zbq/uOsWoUgjDuvvjOrFrbuwj3plNfdUBmZLb26LovuGFIWNjJtAxlpUtv6gUQZ52wQEUk0ZEoOqfbYjY49Dkh8tHK+KAbK1SBkGMYU30rcqK7kP7pUbxVBsxTezxWW/gyRfqW/Xkpci7bnjJKH0qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yv4E9v6+JkLXnTnGgLFaOyltYYKy1dQoj/qY57hJKw=;
 b=AohKMe8KTN3UECshFX27XeEcleJARJj2lsjzjd9iltbOdVNjZpOZpGfSb4gKfQglEuA5e0N1FOPsb17s184AE2b3c4NzaKx3TQ1/rEaE23DI5gOX6YmO8r/4uPS+t+b9zQzG2qXaDnPy8uGPjNWKfJqBzSM9dOiQtacTITK10aA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB2357.namprd12.prod.outlook.com (2603:10b6:4:b7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.27; Mon, 24 May 2021 17:49:09 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.027; Mon, 24 May
 2021 17:49:09 +0000
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
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Subject: [PATCH v2] KVM: x86: Assume a 64-bit hypercall for guests with protected state
Date:   Mon, 24 May 2021 12:48:57 -0500
Message-Id: <e0b20c770c9d0d1403f23d83e785385104211f74.1621878537.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.31.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN7PR04CA0159.namprd04.prod.outlook.com
 (2603:10b6:806:125::14) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by SN7PR04CA0159.namprd04.prod.outlook.com (2603:10b6:806:125::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Mon, 24 May 2021 17:49:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9dbdffff-5fc7-4653-e3a7-08d91edc3bcc
X-MS-TrafficTypeDiagnostic: DM5PR12MB2357:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2357C10B79D2043F848F2D61EC269@DM5PR12MB2357.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SzQHKT4XzdVFoGL9kJBEBRVJIC3ZkNHNDk2JxftSglYSDOlkBfRmcLF3jUS94t+bQIHMKGgkI2CyXoeO1o53JkEyWjCQxRWt5KdcUPQDPXYCfURddbfoIuABuG7ur0Pxb8TH3kFK1RYIXCFUm+tIE5to8fjxuGATB/XerhDIWw8D+9rmrEAr2j4xeiG01685xbovgfNG5dohvty1EQqaft3yUYe45YRsjqzbzeVTiuH4JXvIfRGargJKA1HqL+iKjIjM0v9WPJsfcg0lvuHOqeAeMwF8JAdoGQ+tZVEWZzkINKpVKwMsG+QQsG4im/4d28uvXFf6rK26TUFHYs6k09mV+rzPbRGIyv8vRTm/sxNK7ZpEDn+OfdWYMHejfENtboj1EVPdBbiGQ0dAxEvWJ2hKtPpkvMLyOfokUkUeouy395gxpjjmlx8O1JFgHpSNNDQUOaq10CvE5FUmUFYPr91z5L/HstEQ0aOJ91CvfGqCfq9ttYIdymjLX96ggakIFv25BScaHyM/Oje3QOPhuh0cn6kqxb+43D015KcPyr4qgPKBegKaCG7eIKSKzlprE0zJY7+tXe5jo271c4+jHyrRvZSiwgLY149AzFWUbD+LPvC8/TROg1peoA0DXBcWwRHFThDcLpeMYCSuQU6GDfkvgA2xJdEhijrfgdhNp3M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(5660300002)(38100700002)(7416002)(478600001)(6486002)(38350700002)(2906002)(2616005)(54906003)(316002)(956004)(6666004)(86362001)(4326008)(8676002)(66556008)(52116002)(7696005)(36756003)(83380400001)(8936002)(66476007)(16526019)(186003)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eWjapFW3/WIFAP0IEqW+WSMdu20J1o1aiSiqWNe/Bvfpz9y3JW4fKa6uQwyS?=
 =?us-ascii?Q?eQPbBl+i4AwRWZabFow8GuAU2xDMiWxHZOKbOOboehNtQse0V3bCagj8rQbr?=
 =?us-ascii?Q?Xa+IAr7jIWfnkG2ASX7ylRc8giNdZ1raTgn27aCQtan3QXhhbHs55gJZzElB?=
 =?us-ascii?Q?Lnu95nNrVMezOVRrPAnrwQN3Q27oLKObGBXmuGoWldas4HM45gmKC9EvWXVd?=
 =?us-ascii?Q?OMY8ejmPDqrAGYSJATjvn1Hu6B5co0RauegkSZBUXCgx81AamUDPGpHWuuBH?=
 =?us-ascii?Q?EIGYhlLMle+T6I/r6oAmsQJh2B8UgQiAbo3J4HJh7EsUgF+KL8Boc/c8vfF5?=
 =?us-ascii?Q?OROw6C+La8ruxxw/g3TISjaMhGeyRCOUWkJdxbrgFxAc/RoFR/CpTxtRz1+M?=
 =?us-ascii?Q?PE2lEyzAwGFbIUdRxC92Nx1Q03H06SZaCUXE/AbAXBAjLIF+wSNeisntLYVP?=
 =?us-ascii?Q?SBlKeDgDagrL9z1TmSGSUWIIg2a8RJ093zqJx+qaIOhm+KFgS6BSEX0C+gBj?=
 =?us-ascii?Q?+qR0rOJImn+9ANlKG91Tmq1qB1kj9iedjz7ImMPwasrBVdXidpDRT09gJ/+Y?=
 =?us-ascii?Q?8eH/HWsEAy5PLGwSPPsiD7H7omQg8HM7298JtpeBSIVjQ6HI7gppG5uCNvhW?=
 =?us-ascii?Q?r5Yeii+di7nu7MnuwTJBqhn42fsuxx8MIZPpvxbUZwBnE+JMwksOb/PC8+HV?=
 =?us-ascii?Q?07Wmh/Gd5LbkDoIrHbG1yL4g//VElIPjKRJFg3Box2MelFJ3/TLR4fL1qz4O?=
 =?us-ascii?Q?MiEY14R1qqQ2hQqHmExGW7ibqsgycw7koV0eDsU9B2AQDIudJpqZa7qx83XT?=
 =?us-ascii?Q?2theLwfcz0PLhf0R2307W2hDc4AeMIo+65nVl0QYa6JuMiV+WJFzRD9I7Kop?=
 =?us-ascii?Q?JqF/7gxKQECwkW6fUvOM5CF1fPmH6tyGS1+0yuhhoX4MjYwLT78byjLFPB28?=
 =?us-ascii?Q?YgqNlQDm95YMiPWw1l5Aak+lJRzR2NTk1UFkV4yJacSKxEeiFiQh5fGoxPE5?=
 =?us-ascii?Q?FWEQy5+G4Zqu1FaG7vb9CMQFLZ+EEwSmf9R/VgPiaJax/bxqFGLTRJeeMaT4?=
 =?us-ascii?Q?hXWLKEfAPlJiNWTN1vEz8aqTeioGkg1LjIhokD0VovCxfWbFON/vW0t8t+Ca?=
 =?us-ascii?Q?IFE9P9h04E8ypTW1Mn4SZITJczCzp/wLLTd/y910B5sqUJtqwsWnTOasoUBC?=
 =?us-ascii?Q?VHTXmlslPf28+cvGQ6HVvLXDGPcsc3LbBgfxYSBNVA4pxWc74W7jYP+eJt04?=
 =?us-ascii?Q?UEV8Pvh4pkDPwzIXNwITK69usiDYf2ZWTlChH0KmGIcj25pjIS9DOtPydbVP?=
 =?us-ascii?Q?cS06m2tLZdSPeXzqbak5540c?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dbdffff-5fc7-4653-e3a7-08d91edc3bcc
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 17:49:09.5917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wPDRtm6nRqFr7rscT+OyjEKPDSiRyjVGkSSIYCdLF0Gq7KZpClenPsz0HlkD20hL0IuQdt3AIsdGBXWRXHHdTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2357
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When processing a hypercall for a guest with protected state, currently
SEV-ES guests, the guest CS segment register can't be checked to
determine if the guest is in 64-bit mode. For an SEV-ES guest, it is
expected that communication between the guest and the hypervisor is
performed to shared memory using the GHCB. In order to use the GHCB, the
guest must have been in long mode, otherwise writes by the guest to the
GHCB would be encrypted and not be able to be comprehended by the
hypervisor.

Create a new helper function, is_64_bit_hypercall(), that assumes the
guest is in 64-bit mode when the guest has protected state, and returns
true, otherwise invoking is_64_bit_mode() to determine the mode. Update
the hypercall related routines to use is_64_bit_hypercall() instead of
is_64_bit_mode().

Add a WARN_ON_ONCE() to is_64_bit_mode() to catch occurences of calls to
this helper function for a guest running with protected state.

Fixes: f1c6366e3043 ("KVM: SVM: Add required changes to support intercepts under SEV-ES")
Reported-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---

Changes since v1:
- Create a new helper routine, is_64_bit_hypercall(), and use it in place
  of is_64_bit_mode() in hypercall related areas.
- Add a WARN_ON_ONCE() to is_64_bit_mode() to issue a warning if invoked
  for a guest with protected state.
---
 arch/x86/kvm/hyperv.c |  4 ++--
 arch/x86/kvm/x86.c    |  2 +-
 arch/x86/kvm/x86.h    | 12 ++++++++++++
 arch/x86/kvm/xen.c    |  2 +-
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index f98370a39936..1cdf2b213f41 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1818,7 +1818,7 @@ static void kvm_hv_hypercall_set_result(struct kvm_vcpu *vcpu, u64 result)
 {
 	bool longmode;
 
-	longmode = is_64_bit_mode(vcpu);
+	longmode = is_64_bit_hypercall(vcpu);
 	if (longmode)
 		kvm_rax_write(vcpu, result);
 	else {
@@ -1895,7 +1895,7 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
 	}
 
 #ifdef CONFIG_X86_64
-	if (is_64_bit_mode(vcpu)) {
+	if (is_64_bit_hypercall(vcpu)) {
 		param = kvm_rcx_read(vcpu);
 		ingpa = kvm_rdx_read(vcpu);
 		outgpa = kvm_r8_read(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9b6bca616929..dc72f0a1609a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8403,7 +8403,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	op_64_bit = is_64_bit_mode(vcpu);
+	op_64_bit = is_64_bit_hypercall(vcpu);
 	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 521f74e5bbf2..3102caf689d2 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -151,12 +151,24 @@ static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
 {
 	int cs_db, cs_l;
 
+	WARN_ON_ONCE(vcpu->arch.guest_state_protected);
+
 	if (!is_long_mode(vcpu))
 		return false;
 	static_call(kvm_x86_get_cs_db_l_bits)(vcpu, &cs_db, &cs_l);
 	return cs_l;
 }
 
+static inline bool is_64_bit_hypercall(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * If running with protected guest state, the CS register is not
+	 * accessible. The hypercall register values will have had to been
+	 * provided in 64-bit mode, so assume the guest is in 64-bit.
+	 */
+	return vcpu->arch.guest_state_protected || is_64_bit_mode(vcpu);
+}
+
 static inline bool is_la57_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ae17250e1efe..c58f6369e668 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -680,7 +680,7 @@ int kvm_xen_hypercall(struct kvm_vcpu *vcpu)
 	    kvm_hv_hypercall_enabled(vcpu))
 		return kvm_hv_hypercall(vcpu);
 
-	longmode = is_64_bit_mode(vcpu);
+	longmode = is_64_bit_hypercall(vcpu);
 	if (!longmode) {
 		params[0] = (u32)kvm_rbx_read(vcpu);
 		params[1] = (u32)kvm_rcx_read(vcpu);
-- 
2.31.0

