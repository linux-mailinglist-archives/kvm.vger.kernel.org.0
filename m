Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA83E2FE33E
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 07:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbhAUG4w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 01:56:52 -0500
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:35598
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725967AbhAUG4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 01:56:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V8SHMWAbvPwhGac0kpsbsiyI8v0ITK/5DIYYWgpDDaGw6rU7+1iS3iQ+BibCbszlJnP3pkd6gzqTWVycuCqGlswFdkHpbnd7SM72ropO3ZRKo3oHmWxWpWI1BRulUPmHNBnUeS1rbxFytmTm5sIInDlrnQhnLrukUf7NmyoCg+Nkm3zdAwqmqQ9zN+9SVUoxRcaJBGLWBt7bMkQAzydLkDHSPP8+cVJQrnbstUvVkIs3z1I/PK5Uwjq2KoJEG9+vwutZ1wr9bPxZhTcTLsFoCTMEuSeelVH8APYZ+pf1yQkjq07n7ZOXKNR+kqZyalOewJYS6OgDOXbPmmtaAHj/VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u2e1NwXSIFY6408TR3E4ui0BK0d0t1eZ5AiNvDwuMM=;
 b=MCF1vuvFysDCntO17CN2K2eCabtGWaMm7d8JHBAgsHUcwy9iuNGGMrKiNOKqRdEzCD1f20SmsOcqFcR5Du1i/Wbr1UASc+1OWZCFoMtbDazb1lKEVpPqeZnvPzdLXsc/Yruu6ud/noyTQ8QYaWjt1W8QJbwTqZsaHNUxSH/TaK+INZEy3A4gWuN6JL6Z3XyoYnAz3mKudo12AW/kO37uzqwohc+nfn9VqDjo6z0Pa86g2PO9EgqW+8F8ITjsKv4ET1KFIXwdqpHgSRMaSyPmKYEXMKSKUvvW8mS3YCLPq4bLEFHGjBv8KeampzMa2HBnKzBBUBoUkD+XYFLo2DHefw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/u2e1NwXSIFY6408TR3E4ui0BK0d0t1eZ5AiNvDwuMM=;
 b=dTI7u16VX0ZSigevAR6EntXyeTEceq8gCNta4+21KTP+y4fomDPR3q2TwtYqPsv4SNoMHfXOU9OS8UGgWr+BQolKQEbHfl8vTt5eebsc4iQE5tzOt8FvLvFyu24fGORNyksU47YRBGCaQ2FxoU9mY3vnID0h4PlLXJNBhLH1HIM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
 by MW3PR12MB4441.namprd12.prod.outlook.com (2603:10b6:303:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 06:56:09 +0000
Received: from MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460]) by MWHPR12MB1502.namprd12.prod.outlook.com
 ([fe80::d06d:c93c:539d:5460%10]) with mapi id 15.20.3784.013; Thu, 21 Jan
 2021 06:56:09 +0000
From:   Wei Huang <wei.huang2@amd.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        vkuznets@redhat.com, mlevitsk@redhat.com, seanjc@google.com,
        joro@8bytes.org, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, jmattson@google.com,
        wanpengli@tencent.com, bsd@redhat.com, dgilbert@redhat.com,
        luto@amacapital.net, wei.huang2@amd.com
Subject: [PATCH v2 1/4] KVM: x86: Factor out x86 instruction emulation with decoding
Date:   Thu, 21 Jan 2021 01:55:05 -0500
Message-Id: <20210121065508.1169585-2-wei.huang2@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210121065508.1169585-1-wei.huang2@amd.com>
References: <20210121065508.1169585-1-wei.huang2@amd.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Originating-IP: [66.187.233.206]
X-ClientProxiedBy: SG2PR0601CA0009.apcprd06.prod.outlook.com (2603:1096:3::19)
 To MWHPR12MB1502.namprd12.prod.outlook.com (2603:10b6:301:10::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from amd-daytona-06.khw1.lab.eng.bos.redhat.com (66.187.233.206) by SG2PR0601CA0009.apcprd06.prod.outlook.com (2603:1096:3::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Thu, 21 Jan 2021 06:56:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37463c4a-4f8e-49c9-abfd-08d8bdd9a1b3
X-MS-TrafficTypeDiagnostic: MW3PR12MB4441:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW3PR12MB4441E7400DB86CBA6CC476EBCFA19@MW3PR12MB4441.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPBvq8ahXDxjey6BYc+7Rq8nMkW+C91tnqPX5wIO9nIJDioAj1wmJLU09VuWBP3PYEYLTfeAU/0CfcQFpxX/6rOwaU/V4zCPdYPVSvpik3ZzHD6DHmbYoez59keJt0FdxmGdx5N3VpWMVmlzipGmm2fdBjnGEAkcok9ZBl190Smf37d9TxhpF2DacTfMaNh8+ic6mGpJm0YUXE70iP7+GA3TImBrVqgKYJbqOroWf48HlyBvJSabZ5xMxvNfc6BoHHTyZDDV3K0hYc2iRMjalJsdnv9dA6c7aoeYz7hxfl7NMd2gwqMTHU11vJKF3eyMpGDSh/q/OPYLoHc624MMjbmKokEtTLDLxhnjNwQ5VGHeSpMLJxrGNB8aR3BucyeNPSlpYN0Gw9praxKZs43iLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1502.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(83380400001)(52116002)(8936002)(86362001)(6506007)(66476007)(6512007)(6916009)(2906002)(186003)(478600001)(4326008)(6486002)(16526019)(956004)(26005)(2616005)(36756003)(8676002)(1076003)(316002)(7416002)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?uLOAEyE9FsQDBV1sNVWVgfg8L7g4z25jE9gOBH5TwF0C9IJSJ4ttHUch4LaN?=
 =?us-ascii?Q?w59s7kQ3ORH+sIdDk9Fm+fhNnCpjpr8IEz7yMprGUjbaJbu186dJFiJuBQ/5?=
 =?us-ascii?Q?hb073ZtcBASPSwKbRuy/sAVgxhALeQvWgJy1Hn1hkegq6cIM95Bfxxa7arwm?=
 =?us-ascii?Q?sZ/DfsUAdFXUMR8PULEClP4J96lfmfVMp/rrYsBKHuUE9yHvCbPB6EvtE93n?=
 =?us-ascii?Q?jpT91/8CMRwLdM26ArGe4tGDiNo+YutfwZH3aO9QEqwEyKYTyph48JlnEENp?=
 =?us-ascii?Q?uUnRVKFiAZE8lo6/ei9Wgy1okfA7C/92lAfnk1ARnY0+0jiN+iBdYttWzM6P?=
 =?us-ascii?Q?PQOAyHvqPpEgKSXfMaiYb5ptsAQyrN6L6orJUhM+1SE89ror15WKGHX04ZPP?=
 =?us-ascii?Q?7Zj1C2xDmdNUASuI2hh6AH+zl+VKZe10ALYR6kOo9CxDivWVYiEy05rWdBsc?=
 =?us-ascii?Q?UKRWbZ7v1TusY1tI1aoa6hb6lmeZ+1zAoaK/p2hUweFqxl9EjtxkV4L/P8Vh?=
 =?us-ascii?Q?vtOudjak/Q/03P0FW4WwZMXSFsGF1d7jzIs+K+vo1zty9ISKSOTVgTPrOfSq?=
 =?us-ascii?Q?Hd7iMdpdJYwBARJj9QXvaYE/43lXmNRlYylidIRiavYjeWnkFM0iAsqcVbos?=
 =?us-ascii?Q?WtulAyxTvrVE4a9NeRU/ir1+l+zmdLbAyiJ8mbmqpwd/IE9qS1CEgMMDALmG?=
 =?us-ascii?Q?paWe8meJIi/pqG73M4NdMhfsDy1FQsOzDEshfXVbQOEtxg0fA2So2tD+jdn0?=
 =?us-ascii?Q?AB/tRAx3ddr85+eeNbYlI1PSE/x6l79SgUPZsdYlQFSz5RRdtpBSftiFKYOz?=
 =?us-ascii?Q?cFhT3JMudavlu/Y18eJQDVF73/6UqMGumONN0z0U3TxrQTfX/ODuVt/MBFhb?=
 =?us-ascii?Q?g+7OIgLUszUhWB/IkclO4TXoXwsXVFSV/V+4DpohgCA9XeTIyIHGouux66qR?=
 =?us-ascii?Q?VzfNuMyrjn2eF/C5CRxvtrDfmtnoXDQ6OhSoeMvdm4yagfJRKkL8aoTraZ3S?=
 =?us-ascii?Q?K/RQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37463c4a-4f8e-49c9-abfd-08d8bdd9a1b3
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1502.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 06:56:09.5562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LRglpc6fglwsvcjVKKRorrzxuVLL+RQHcDrARB9Wv55asJEwOoMycnhfCvceVuHo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4441
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
 arch/x86/kvm/x86.c | 63 +++++++++++++++++++++++++++++-----------------
 arch/x86/kvm/x86.h |  2 ++
 2 files changed, 42 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9a8969a6dd06..580883cee493 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7298,6 +7298,43 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+/*
+ * Decode and emulate instruction. Return EMULATION_OK if success.
+ */
+int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+				    void *insn, int insn_len)
+{
+	int r = EMULATION_OK;
+	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
+
+	init_emulate_ctxt(vcpu);
+
+	/*
+	 * We will reenter on the same instruction since
+	 * we do not set complete_userspace_io.  This does not
+	 * handle watchpoints yet, those would be handled in
+	 * the emulate_ops.
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
+EXPORT_SYMBOL_GPL(x86_emulate_decoded_instruction);
+
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len)
 {
@@ -7317,32 +7354,12 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
+		r = x86_emulate_decoded_instruction(vcpu, emulation_type,
+						    insn, insn_len);
 		if (r != EMULATION_OK)  {
 			if ((emulation_type & EMULTYPE_TRAP_UD) ||
 			    (emulation_type & EMULTYPE_TRAP_UD_FORCED)) {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c5ee0f5ce0f1..fc42454a4c27 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -273,6 +273,8 @@ bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu, gfn_t gfn,
 					  int page_num);
 bool kvm_vector_hashing_enabled(void);
 void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t gva, u16 error_code);
+int x86_emulate_decoded_instruction(struct kvm_vcpu *vcpu, int emulation_type,
+				    void *insn, int insn_len);
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
-- 
2.27.0

