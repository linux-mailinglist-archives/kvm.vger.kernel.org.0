Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9DB269635
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgINUSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:18:11 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbgINURV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:17:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCVF7NZfzAT2W7A3aKqZpcw6/VikPu1cBQsFt8v0Rdzx2i/Agr1Jl4OK1j7SPqPepNpHqgqUWVazdXJj17IpxaYt+ER5X0PdJYHQr6NEFcMjyLk4VFLxziPKy62e/51dJQV+ZqIOfFOd4D/402ywTkB6OhThqGc7O2hkxBWzQnTbRsYo/liJ/71yBRls1BCWXTxjlxzftwRrC/h0XmCaP6Vxr1JgUsefqApPj5gizTQv+5QslywF4N4tLPCnZMfeEv21zSnIuGhHxUcbBJThA1HpfWaaQoh4tBYHz1Ok0tWCbkr5XhiqwSLrTE9M/scbfLjRZmtw37+IejC026X6qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qsw4fVvYw5dooPDBM98sNdSh5tjxyKiJeNnHC0qBETo=;
 b=URoru6MZd04iEItmIoo3ZIVAupQhRRjn/IGYud/B4XZHOeVgneO5nSK66ZxUAVv/RaEya4m3lkM7+XxDE71wMDWbjRwHrv/RPDVnDfWCdubN52U4ZN8Eqdn05TXjtPrKmV7TvSX1UdBlAWBXshZAvsCYXnLD7XuVS1JboYXyq669A0qo1wNRzvLtUthyWx8JulM4xabYImNAD7T5CFgH6+awr9SS4cj7kpxXSJxBHFJ0/U4zHj7urJppPgYatjO9eGG2PLQ/ssz1C2zGyKSn+Q64NMBQMZVu053O6onOxQ0aGNAuEiXSzn5BBB6XczE7QVHMvf3JGBejNVui55nPRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qsw4fVvYw5dooPDBM98sNdSh5tjxyKiJeNnHC0qBETo=;
 b=FuyBE5szdHyssdmyCJaX+v24TZFz+rtX8bi4KRVNUisRFUaNTR5bhcDip7+s/CatEm0ACb5QbQOB4lTyJ0fH6+6PoHlGMX1j6LEcAv51KIzxwaH6mseAZZfl/6B0FEZXl5EXWVR2Cn9MB/7r9f3GQEXnEPmQVvyNPg3ze7vB2AA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:17:03 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:17:03 +0000
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
Subject: [RFC PATCH 08/35] KVM: SVM: Prevent debugging under SEV-ES
Date:   Mon, 14 Sep 2020 15:15:22 -0500
Message-Id: <58093c542b5b442b88941828595fb2548706f1bf.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:5:120::21) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR06CA0008.namprd06.prod.outlook.com (2603:10b6:5:120::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:17:02 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f321452-0ab0-416d-80bf-08d858eb24c1
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB11634784E097298CC887A1E1EC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:235;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b6M38PzXXGk0Lvu1YxeRNEjEBZZeEq9XQzKj+Vi0E3egyt3oFHKCCFRPov4t6QSYfKMC/47jW1uI1aOS1HJmq5As2HXLEuv4tH+Tae7xM8pFp5pZ/VfUMUD6hMRJ8xM6EJTbNjZeTRS6itbyFoeB455KJi11+Ua5vflNLkt3fBjHAJu6CQjmV9y5oFvKXzhx+UIRwUJCiYTxR+gTl1C/GB3EYN1tYB/Vg3qV0a7KWERN4RdQw4/2xJr+Iycsub9B/6WaRsd6loqt/d2nPy2xArBgCyM5gSrHRJq7KBhvDu2TjMnkzPOEKownGllFCjxi/w6zWLhdK5YvcocY34smeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: h91u3AovyN14eranPli9+raHUuGcmGk00C1F8q1VNZ6b9SfeZV5GKyihsWL6yeo9hI4oVXm48i28Lk6Tn5DUywBfhnPLlOGi/alJf5Mc3uAlL+nl5A3LZjdyEPiMpItATrbcu35WYGhNei1PYmoJbwmwX8zYyYnGyzSrbVXln2/Rbgwojlxd2kp9IebMHMaIeyapeoJ43bFaftgcu6StpGUfF18+mjSGYyAb038PRDTcW/JZbiBHcmAQAWcgX/ynH/eX7qbXBxL0t1U/hHDqZcwPT2i8yNLH1gzf94m2u/oIRSx0WGU7gFdytBR9+lduYbnmBYAudUwADHROXWzi4exR4mzVnuBIaP0GiahDUF/ZpvPKUI9TUvTz17IQAeV7Gp9pMGe/Bp0cX5U6fonqrSw8VrlmItzCqNeumLleDtKaVyFnyJUhg32jcqxu3r5J1fa75+E6NqJrHocGlqQT/68tVHierrvhU3sl2oIcFKEHEZ4cC35YC5W7h4UW/nUUqodg6PZnrXgoytwxk5dAsmyhmkFp7/WmD5QWExUxVj7UhHDgXv6/IGJJ1nKJ/dfC0BxjIy6Ngfqs9LXHhxqmaN7WZDRRIbZEHXu8NvnC59VPo78Wv+vOhRZVJ4Aokvx1cieez0ACoTBnWoLLToeHfw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f321452-0ab0-416d-80bf-08d858eb24c1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:17:03.2184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LgImxKZlKpIY0B+0BmLSmkJoSw2lhVisa6DWHphXe+l8e6aFAZCVAxXOHJcfN9VSP7m3s+4IlnrKmBnNYTglkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Since the guest register state of an SEV-ES guest is encrypted, debugging
is not supported. Update the code to prevent guest debugging when the
guest is an SEV-ES guest. This includes adding a callable function that
is used to determine if the guest supports being debugged.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/svm.c          | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  7 +++++++
 arch/x86/kvm/x86.c              |  3 +++
 4 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c900992701d6..3e2a3d2a8ba8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1234,6 +1234,8 @@ struct kvm_x86_ops {
 	void (*reg_read_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
 	void (*reg_write_override)(struct kvm_vcpu *vcpu, enum kvm_reg reg,
 				   unsigned long val);
+
+	bool (*allow_debug)(struct kvm *kvm);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f8a5b7164008..47fa2067609a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1729,6 +1729,9 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
 	struct vmcb *vmcb = svm->vmcb;
 
+	if (svm->vcpu.arch.vmsa_encrypted)
+		return;
+
 	if (unlikely(value != svm_dr6_read(svm))) {
 		svm_dr6_write(svm, value);
 		vmcb_mark_dirty(vmcb, VMCB_DR);
@@ -1739,6 +1742,9 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.vmsa_encrypted)
+		return;
+
 	get_debugreg(vcpu->arch.db[0], 0);
 	get_debugreg(vcpu->arch.db[1], 1);
 	get_debugreg(vcpu->arch.db[2], 2);
@@ -1757,6 +1763,9 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (vcpu->arch.vmsa_encrypted)
+		return;
+
 	svm_dr7_write(svm, value);
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
@@ -4243,6 +4252,11 @@ static void svm_reg_write_override(struct kvm_vcpu *vcpu, enum kvm_reg reg,
 	vmsa_reg[entry] = val;
 }
 
+static bool svm_allow_debug(struct kvm *kvm)
+{
+	return !sev_es_guest(kvm);
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4384,6 +4398,8 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.reg_read_override = svm_reg_read_override,
 	.reg_write_override = svm_reg_write_override,
+
+	.allow_debug = svm_allow_debug,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 46ba2e03a892..fb8591bba96f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7879,6 +7879,11 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 	return supported & BIT(bit);
 }
 
+static bool vmx_allow_debug(struct kvm *kvm)
+{
+	return true;
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_unsetup = hardware_unsetup,
 
@@ -8005,6 +8010,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.need_emulation_on_page_fault = vmx_need_emulation_on_page_fault,
 	.apic_init_signal_blocked = vmx_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
+
+	.allow_debug = vmx_allow_debug,
 };
 
 static __init int hardware_setup(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a5afdccb6c17..9970c0b7854f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9279,6 +9279,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
 	unsigned long rflags;
 	int i, r;
 
+	if (!kvm_x86_ops.allow_debug(vcpu->kvm))
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 
 	if (dbg->control & (KVM_GUESTDBG_INJECT_DB | KVM_GUESTDBG_INJECT_BP)) {
-- 
2.28.0

