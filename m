Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CC33037BF
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 09:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389814AbhAZIU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 03:20:59 -0500
Received: from mail-bn8nam08on2064.outbound.protection.outlook.com ([40.107.100.64]:61696
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389802AbhAZIUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 03:20:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VpSHifjG8KnY5fK3Hkuw3w2y/HqJXqGKMjLaj4n5CeY/Qa0e283prfE5gn+HxDcRMNDoug2a6LPkPl8Jr7iJJjqFJPuiW8AZg8XH0/j1wul9tz2SaUJ58jE24UypTEk/Bklp7yDofrBeNwzYHryVX4YycdLshoJ5Ht1y7Xmc1g4+UUNxD8ANgQVZS/dWG7c65OvBiJTzVXZtInJbR7vTi16TNRNoup8lr5HgrHRVtusSkLikJw+sKYT8N9MF+BH9UA2lqUxbnBmn3jWJMjAP2GgCLUOOm1yl1EWfBAM5YhWLQTbTfJvjKu/UAVtyK8SR5RYOp+qbukgknEQQfcvouA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrh/yP3QuebLz4N2MRDY6SWrEwvZslYWV2sm2NvlQM4=;
 b=NE6FvyoKHvxlYwwx4Q5Br2uGXUXoIvxZ4S8Fe2rkTAuEDlqpeqqAHIFeDfOF8clEF2lXNo7hzJSIbNbLvTGy+f4PcKv/zj8L8i6Z9WbnJXsViOx/MPKibk7rOcEajAX6Smn+wHhlbqstpvGx/Vh80R+siee/Aol9Pto6SjNDARqr79rZy3VTTVgNTWXbJ5u0Qkm9DHt3zprkqyp04SbPD+JJG8TIEYx2wNiKSq1VQhPfANgH2BEwY7sN6WWhNx510wC0z/w713Z2OiRTS7okVT0eqi30znhHWKzIlAEVcJR6ZEBaLfVbSAY/J2h42hINBgumV0bs2+K3KlQZsmulhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zrh/yP3QuebLz4N2MRDY6SWrEwvZslYWV2sm2NvlQM4=;
 b=OP+zlrZ+fnHRXNc1Ux4Pi4EozldcImXBy9+Pf1wgLV6d5B9BMsBXrj3CUIZ7/ush5sdhZwb67OCHAK5H/I6js9rFSA71UZHdCx5sR37vjxg9YzwdEJ5lpT9tFASiPFVfFpC4V3MkGYznicfTwcSRaGkmAshIZtmrSoMWNaBMInE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1494.namprd12.prod.outlook.com (2603:10b6:910:f::22)
 by CY4PR1201MB0214.namprd12.prod.outlook.com (2603:10b6:910:25::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 26 Jan
 2021 08:19:05 +0000
Received: from CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819]) by CY4PR12MB1494.namprd12.prod.outlook.com
 ([fe80::25d2:a078:e7b:a819%11]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 08:19:05 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v3 1/4] KVM: x86: Factor out x86 instruction emulation with decoding
Date:   Tue, 26 Jan 2021 03:18:28 -0500
Message-Id: <20210126081831.570253-2-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210126081831.570253-1-wei.huang2@amd.com>
References: <20210126081831.570253-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: AM8P192CA0010.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::15) To CY4PR12MB1494.namprd12.prod.outlook.com
 (2603:10b6:910:f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by AM8P192CA0010.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21b::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Tue, 26 Jan 2021 08:19:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0dbbbf28-39ce-4de4-090c-08d8c1d30b8d
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0214:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1201MB02141FD4E4ACE00FFF6BAF14CFBC0@CY4PR1201MB0214.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQPHmmp2Bq/+9+uPalZ+6VnYFcXSlcbCPUkUR7L7HfNZke0HCDV1irPHD7mDTyjc9ENTiwHrOxjgWlygFPDjyOu/anmjABSk2L6xvOO4Nr0f3JVelCZ3uly2metiwQ8DX349lom12dJXr0TQof3YtHQ/lhpJSaiS5kVXm0Mmolw3RADYEXgyiYtwVUXePvwLAiYVd4KKf3FC30ZBk7Lf8PYEXCeVaGzv4eGyBi1GN8UgsTaw4ROcVpe+awXEIN2IJR96HTDFO3NVJV1acXql2CClcae/IkKYZO+yAiZhGVX5kOVKVmrFEoi9zDOu2pxybisRxc39XXpL1bS/AejoRUt8rwf+Ne+yJ7hZK6kEqpxIV+mELUkJ1sUHCziDdwbgDMMYoYT95McLyX2uOlhYJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1494.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(36756003)(66556008)(6486002)(8676002)(66476007)(66946007)(52116002)(86362001)(5660300002)(6512007)(2906002)(956004)(186003)(26005)(16526019)(478600001)(6666004)(83380400001)(8936002)(4326008)(6916009)(316002)(6506007)(7416002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?mxhWXDMXaMtscx1caINMsTj3kusyIt+FWM1bkm8hqja8MGNXZDa5H/0JUgLf?=
 =?us-ascii?Q?gkRiltrRW5A6UVOoqy9QSf4Nc10h8FPeQoNG2c32zieuU+vn+AgUt/roqXb3?=
 =?us-ascii?Q?t3tULhS/L3gOqEyQJd41t3Aej2pl2k0izE/9AKL644bVcLl8XW4SzFv1Kn0C?=
 =?us-ascii?Q?3p7KQW+3i26HxSgaQmusv4+hKHw1PFQwa1YBOHQNFYCwPd46GCeMcVnlmNkr?=
 =?us-ascii?Q?oFw7ADxuwc+MIj+f8rFjGB0PjFVU582zEZ+QD4HjI2sWYdWqIoeFP5yTypyG?=
 =?us-ascii?Q?M7L9IHJ4f92coCHPJaiu2+RGoBv9aAc8x0mjKC9mnBtYWR0oNlI9szkaCaCF?=
 =?us-ascii?Q?QrWGxcLbpMXB7Mw/VXlsC4v1sjlQG/J2OXWwfeU535hskt8W04w07IZ1Ults?=
 =?us-ascii?Q?KrWeEtDm3e7tPXSVnAPrI1qIlGjSOQTgMJGXa1Y2hDXzlOV7MiQ/+TDO/1lO?=
 =?us-ascii?Q?fNKhkkBBbLWnZvFeEferknv2J+UtaSluKLaKtBpRki4aHWSluKg3S1CJkO/A?=
 =?us-ascii?Q?nNZ7mGD/zE+IqzZP8FyK63T1URQk3qWv38boXh3nDtuyMpp71t3vj2v5Amag?=
 =?us-ascii?Q?b9T1yNjFpWvFCAVjpdqZP5AwoyrvXt3mu6+SxmPDq9TL8T7WQOxbOMVOywro?=
 =?us-ascii?Q?xlnLx7W9nE+MWtjovbky63jcG2lmnVkPkvYNKMDSC+n+XowYtqc3r126Emwa?=
 =?us-ascii?Q?dPHX+XQHAiispwzWJIkO2Y7T2WnjyjEZAeOKjz7yKmnqh0lEMJAJVhyLbqWD?=
 =?us-ascii?Q?i9cyJStzjU+ulB+ZU/PYvMIz34Hu/NGjDd4RiwruX3rD4F6DqpEl+m94B894?=
 =?us-ascii?Q?U4c1W6HmfcmTfoOhoa+u5kFH7/4I8t9B+Jq8OeIVR2lqt5tTBExSXbYGpXKu?=
 =?us-ascii?Q?OevOq5eCrRwlvXbj/GT85BlVn8+8vlmcHSSw+FTPHOoOqxwZ6zuRmdFI4kG8?=
 =?us-ascii?Q?JMrBh2N6hLFHCNoBOr2As4WEPEnLTfNXb02VdBkRVcPtj65rKYuq7SOYAGIH?=
 =?us-ascii?Q?yjMLzkRNJJKYQRA2iGvfv4PcJA0XrEf7TrkPOocREqJgLfUPRVzC/WuSieOy?=
 =?us-ascii?Q?A1QzZcNO?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbbbf28-39ce-4de4-090c-08d8c1d30b8d
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1494.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2021 08:19:05.1746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X/qaKaTcCnzwui7LgSvxhq/jc9hWOMMqZNYrhwKG0aAzdtTx7Zm64evYe4SDnhR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0214
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the instruction decode part out of x86_emulate_instruction() for it
to be used in other places. Also kvm_clear_exception_queue() is moved
inside the if-statement as it doesn't apply when KVM are coming back from
userspace.

Co-developed-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Bandan Das <bsd@redhat.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
---
 arch/x86/kvm/x86.c | 62 +++++++++++++++++++++++++++++-----------------
 arch/x86/kvm/x86.h |  2 ++
 2 files changed, 41 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..a1c83cd43c1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7298,6 +7298,42 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+/*
+ * Decode to be emulated instruction. Return EMULATION_OK if success.
+ */
+int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+				    void *insn, int insn_len)
+{
+	int r = EMULATION_OK;
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	init_emulate_ctxt(vcpu);
+
+	/*
+	 * We will reenter on the same instruction since we do not set
+	 * complete_userspace_io. This does not handle watchpoints yet,
+	 * those would be handled in the emulate_ops.
+	 */
+	if (!(emulation_type & EMULTYPE_SKIP) &&
+	    kvm_vcpu_check_breakpoint(vcpu, &r))
+		return r;
+
+	ctxt->interruptibility = 0;
+	ctxt->have_exception = false;
+	ctxt->exception.vector = -1;
+	ctxt->perm_ok = false;
+
+	ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
+
+	r = x86_decode_insn(ctxt, insn, insn_len);
+
+	trace_kvm_emulate_insn_start(vcpu);
+	++vcpu->stat.insn_emulation;
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(x86_decode_emulated_instruction);
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len)
 {
@@ -7317,32 +7353,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 */
 	write_fault_to_spt = vcpu->arch.write_fault_to_shadow_pgtable;
 	vcpu->arch.write_fault_to_shadow_pgtable = false;
-	kvm_clear_exception_queue(vcpu);
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
-		init_emulate_ctxt(vcpu);
-
-		/*
-		 * We will reenter on the same instruction since
-		 * we do not set complete_userspace_io.  This does not
-		 * handle watchpoints yet, those would be handled in
-		 * the emulate_ops.
-		 */
-		if (!(emulation_type & EMULTYPE_SKIP) &&
-		    kvm_vcpu_check_breakpoint(vcpu, &r))
-			return r;
-
-		ctxt->interruptibility = 0;
-		ctxt->have_exception = false;
-		ctxt->exception.vector = -1;
-		ctxt->perm_ok = false;
-
-		ctxt->ud = emulation_type & EMULTYPE_TRAP_UD;
-
-		r = x86_decode_insn(ctxt, insn, insn_len);
+		kvm_clear_exception_queue(vcpu);
 
-		trace_kvm_emulate_insn_start(vcpu);
-		++vcpu->stat.insn_emulation;
+		r = x86_decode_emulated_instruction(vcpu, emulation_type,
+						    insn, insn_len);
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
 			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..482e7f24801e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -273,6 +273,8 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
+int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+				    void *insn, int insn_len);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
-- 
2.27.0

