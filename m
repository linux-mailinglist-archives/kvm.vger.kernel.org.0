Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CA1269630
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 22:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgINUQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 16:16:59 -0400
Received: from mail-bn8nam12on2061.outbound.protection.outlook.com ([40.107.237.61]:36897
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbgINUQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 16:16:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaUMZaA9EUh+22u7gBdGWOmnO/VbJU3PvTtg0Vym+7EUn5i+trIdCvPUiygTt8/mhRUbFjZidZ2/37Cuy+6qUO0tgS7ct26GJKgwaW8hYGebXa0EpllibaPAouWDQ4O3nbkr+pym7tNXE8Edj/1vHrLb0mFOkXeNrWDIB1ihNH8g395L1Iu18TUbzDnEIjxGL/gQVBgyGmkQG0bpOW8cUAuKxdThip+rQhOsLjWuqVloYeSxkFUDjrG0ebmDuUV+WNTByib1mEhJciVl+hxVvpoOsbr/xe0GBsnR0azpFnb6i+wLkiobAj0QVijGeR4yGOR0GWw/BalauNdHUXTabQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lSD6qJZgfFC9PrTfTWl1grZ0WpDC8H7qzL7KDXo3/k=;
 b=Lkdz7Q2SvcAz1S1u335MCfmIBpEUkkIHvMw688Bl1BYXr68S/b4bJmXmc/oP7TTBLb0vuZZ8CN0yWJF6tpoPcN0Qn2oCAZbhvpvg5lrhrIjNyotD2B8koF09HPeXwCiZA2gq6F2UcR97LsO+1Kr+inQE+F+3/cmAR7yq0boIDY0MD8FojYgdhFyY+pO6/dKLxY/O8cqA5gZ8O/ptoQp3/YNnEOSWs6AmwMHS8CLvUrV8CkEsIcRCIJKLBBanSbdLcw0RRB7jqA30qcnYH6IqmDvBfCPKqYImEVO+BGzu2Ti0mS2NyXCamop5b+rFd2WCIXkToTft7cOywduKABlS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lSD6qJZgfFC9PrTfTWl1grZ0WpDC8H7qzL7KDXo3/k=;
 b=3A120pJ8Xn2l/uvmDWjtyYYCYO36TbgILimA8Ht+eoGC+Ja7DRdXxYGLYHFRHr4BYlMzSFDs0JVQPTb5zy2vWwvY5m//3gQQTJgxeQm06u+qOdnVOZRQAqZN4RLD56xLSerB5IcWw5nSiIBBb0EInq0VmBm4k4AKmhj1nsIpgUg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 20:16:23 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::299a:8ed2:23fc:6346%3]) with mapi id 15.20.3370.019; Mon, 14 Sep 2020
 20:16:23 +0000
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
Subject: [RFC PATCH 03/35] KVM: SVM: Add indirect access to the VM save area
Date:   Mon, 14 Sep 2020 15:15:17 -0500
Message-Id: <627d74a17e37a1ac048d423dd47da9e64b62952c.1600114548.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1600114548.git.thomas.lendacky@amd.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0062.namprd03.prod.outlook.com
 (2603:10b6:5:100::39) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by DM6PR03CA0062.namprd03.prod.outlook.com (2603:10b6:5:100::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Mon, 14 Sep 2020 20:16:22 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6816d353-c333-4fd6-65b2-08d858eb0d1c
X-MS-TrafficTypeDiagnostic: DM5PR12MB1163:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB116315619F5950DA80D2852AEC230@DM5PR12MB1163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7v707a4DhAUPj7QNYPRJnPeG759pRCv43DRpyQGgh7ZTS6dXaxSIOYw3hpERskW6jEoraI3dEtt3W7e7IVLN8E8kf/u1UDcnteS3xnohtNW6ZChrtPEJf21w06gznsdZW/FSQfSGeedxODTnjUhehYt43/o3un7ewPYMuzIztCwYq2FtVQxESE6ai7MHmHH0l5C7YX+Cz2m3Vlmi6QauyVJiNpMD5lyog6z65Gx8d9Ri27OBSFO92RRMgrD0utxpmsNZbK/EJMxtfESsn5gQkjSVq0jp+DZiiff7+UE4gQzg1D7Y6aLcrhk+53JvZP9lIQuXAL/64/61JwJ3zpHNWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8676002)(478600001)(83380400001)(26005)(316002)(7416002)(2906002)(5660300002)(6666004)(956004)(86362001)(186003)(16526019)(52116002)(7696005)(66556008)(66476007)(66946007)(4326008)(8936002)(54906003)(36756003)(2616005)(6486002)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RPYTdxs/MsmxTuf8Eq5lSPn5ytHGatu533DMIEqKrst/yWk+KFk/yNxfSnbtwW7saFsYWl4Dm5f3on9SzXsCdfHPFPIumgJ+RdLMcpwW30zgD5rgRE5InSGimWcAwXXstyM3bwSTF5+cN3hBHuKG4iEq1mOMARKlJeTYA+2GL1fkWIMEOS0A8vSxjUqSRRdWR1rkSWFLRuUo4pD6NlKnt++6uvtKQ83YF5LMjBt21RZINnvybDJQpF9taqcamMl0oeE3ArM23bwi9V8bbk9VfxKRpe0+aoPDavaY42ttTt1FZ+zm8kcIfFCfTeHcTogJGgEDvb7bxchuRgjNFLn7jzApVnD+XYl2drLDZ0pyMRdlbsbBIOsSfsjmYLO6SEBVRAo12XYGiTce1ZlEBm0dlUyNfAYfs778rpBEH7VEhMsjYz9Fw2zv6QeeTUU8cApvvbIFS66n9sHhbYIzoL4rrUHx89HvqenXbFug6TQDXpR14U3BNRQJ2NhkAr6wvgY4gJTJmqrrOz2mJfvjCcqHrSzac4pm0bHT2w6CjUwh8of6D5/+LJwXkGmwF11J9ek37oEWZxBrJe9kvulRPOO6MiwVKswfeEjbK3dPb5s2plkFHv2DIp9EyrB1LtoouMUy1pkbstDg0GbMLG0fCGeJDQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6816d353-c333-4fd6-65b2-08d858eb0d1c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2020 20:16:23.6467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDO5n/c7oiKS1QWnCSfqjS8HmH0dAolltgn4qeYtSMkMgdZb06kB6M0LsY3dVfRM5ViOcGJhAGVAL2q9x3QGaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1163
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

In order to later support accessing the GHCB structure in a similar way
as the VM save area (VMSA) structure, change all accesses to the VMSA
into function calls. Later on, this will allow the hypervisor support to
decide between accessing the VMSA or GHCB in a central location. Accesses
to a nested VMCB structure save area remain as direct save area accesses.

The functions are created using VMSA accessor macros.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/nested.c | 125 +++++++++++++++--------------
 arch/x86/kvm/svm/svm.c    | 165 +++++++++++++++++++-------------------
 arch/x86/kvm/svm/svm.h    | 129 ++++++++++++++++++++++++++++-
 3 files changed, 273 insertions(+), 146 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d1ae94f40907..c5d18c859ded 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -367,28 +367,29 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
 {
 	/* Load the nested guest state */
-	svm->vmcb->save.es = nested_vmcb->save.es;
-	svm->vmcb->save.cs = nested_vmcb->save.cs;
-	svm->vmcb->save.ss = nested_vmcb->save.ss;
-	svm->vmcb->save.ds = nested_vmcb->save.ds;
-	svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
-	svm->vmcb->save.idtr = nested_vmcb->save.idtr;
+	svm_es_write(svm, &nested_vmcb->save.es);
+	svm_cs_write(svm, &nested_vmcb->save.cs);
+	svm_ss_write(svm, &nested_vmcb->save.ss);
+	svm_ds_write(svm, &nested_vmcb->save.ds);
+	svm_gdtr_write(svm, &nested_vmcb->save.gdtr);
+	svm_idtr_write(svm, &nested_vmcb->save.idtr);
 	kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
 	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
+	svm_cr2_write(svm, nested_vmcb->save.cr2);
+	svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
 	kvm_rsp_write(&svm->vcpu, nested_vmcb->save.rsp);
 	kvm_rip_write(&svm->vcpu, nested_vmcb->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	svm->vmcb->save.rax = nested_vmcb->save.rax;
-	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
-	svm->vmcb->save.rip = nested_vmcb->save.rip;
-	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
+	svm_rax_write(svm, nested_vmcb->save.rax);
+	svm_rsp_write(svm, nested_vmcb->save.rsp);
+	svm_rip_write(svm, nested_vmcb->save.rip);
+	svm_dr7_write(svm, nested_vmcb->save.dr7);
 	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;
-	svm->vmcb->save.cpl = nested_vmcb->save.cpl;
+	svm_cpl_write(svm, nested_vmcb->save.cpl);
 }
 
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
@@ -451,7 +452,6 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	int ret;
 	struct vmcb *nested_vmcb;
 	struct vmcb *hsave = svm->nested.hsave;
-	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 	u64 vmcb_gpa;
 
@@ -460,7 +460,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		return 1;
 	}
 
-	vmcb_gpa = svm->vmcb->save.rax;
+	vmcb_gpa = svm_rax_read(svm);
 	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map);
 	if (ret == -EINVAL) {
 		kvm_inject_gp(&svm->vcpu, 0);
@@ -481,7 +481,7 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 		goto out;
 	}
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb_gpa,
+	trace_kvm_nested_vmrun(svm_rip_read(svm), vmcb_gpa,
 			       nested_vmcb->save.rip,
 			       nested_vmcb->control.int_ctl,
 			       nested_vmcb->control.event_inj,
@@ -500,25 +500,25 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	 * Save the old vmcb, so we don't need to pick what we save, but can
 	 * restore everything when a VMEXIT occurs
 	 */
-	hsave->save.es     = vmcb->save.es;
-	hsave->save.cs     = vmcb->save.cs;
-	hsave->save.ss     = vmcb->save.ss;
-	hsave->save.ds     = vmcb->save.ds;
-	hsave->save.gdtr   = vmcb->save.gdtr;
-	hsave->save.idtr   = vmcb->save.idtr;
+	hsave->save.es     = *svm_es_read(svm);
+	hsave->save.cs     = *svm_cs_read(svm);
+	hsave->save.ss     = *svm_ss_read(svm);
+	hsave->save.ds     = *svm_ds_read(svm);
+	hsave->save.gdtr   = *svm_gdtr_read(svm);
+	hsave->save.idtr   = *svm_idtr_read(svm);
 	hsave->save.efer   = svm->vcpu.arch.efer;
 	hsave->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	hsave->save.cr4    = svm->vcpu.arch.cr4;
 	hsave->save.rflags = kvm_get_rflags(&svm->vcpu);
 	hsave->save.rip    = kvm_rip_read(&svm->vcpu);
-	hsave->save.rsp    = vmcb->save.rsp;
-	hsave->save.rax    = vmcb->save.rax;
+	hsave->save.rsp    = svm_rsp_read(svm);
+	hsave->save.rax    = svm_rax_read(svm);
 	if (npt_enabled)
-		hsave->save.cr3    = vmcb->save.cr3;
+		hsave->save.cr3    = svm_cr3_read(svm);
 	else
 		hsave->save.cr3    = kvm_read_cr3(&svm->vcpu);
 
-	copy_vmcb_control_area(&hsave->control, &vmcb->control);
+	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 
 	svm->nested.nested_run_pending = 1;
 
@@ -544,20 +544,21 @@ int nested_svm_vmrun(struct vcpu_svm *svm)
 	return ret;
 }
 
-void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+void nested_svm_vmloadsave(struct vmcb_save_area *from_vmsa,
+			   struct vmcb_save_area *to_vmsa)
 {
-	to_vmcb->save.fs = from_vmcb->save.fs;
-	to_vmcb->save.gs = from_vmcb->save.gs;
-	to_vmcb->save.tr = from_vmcb->save.tr;
-	to_vmcb->save.ldtr = from_vmcb->save.ldtr;
-	to_vmcb->save.kernel_gs_base = from_vmcb->save.kernel_gs_base;
-	to_vmcb->save.star = from_vmcb->save.star;
-	to_vmcb->save.lstar = from_vmcb->save.lstar;
-	to_vmcb->save.cstar = from_vmcb->save.cstar;
-	to_vmcb->save.sfmask = from_vmcb->save.sfmask;
-	to_vmcb->save.sysenter_cs = from_vmcb->save.sysenter_cs;
-	to_vmcb->save.sysenter_esp = from_vmcb->save.sysenter_esp;
-	to_vmcb->save.sysenter_eip = from_vmcb->save.sysenter_eip;
+	to_vmsa->fs = from_vmsa->fs;
+	to_vmsa->gs = from_vmsa->gs;
+	to_vmsa->tr = from_vmsa->tr;
+	to_vmsa->ldtr = from_vmsa->ldtr;
+	to_vmsa->kernel_gs_base = from_vmsa->kernel_gs_base;
+	to_vmsa->star = from_vmsa->star;
+	to_vmsa->lstar = from_vmsa->lstar;
+	to_vmsa->cstar = from_vmsa->cstar;
+	to_vmsa->sfmask = from_vmsa->sfmask;
+	to_vmsa->sysenter_cs = from_vmsa->sysenter_cs;
+	to_vmsa->sysenter_esp = from_vmsa->sysenter_esp;
+	to_vmsa->sysenter_eip = from_vmsa->sysenter_eip;
 }
 
 int nested_svm_vmexit(struct vcpu_svm *svm)
@@ -588,24 +589,24 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Give the current vmcb to the guest */
 	svm_set_gif(svm, false);
 
-	nested_vmcb->save.es     = vmcb->save.es;
-	nested_vmcb->save.cs     = vmcb->save.cs;
-	nested_vmcb->save.ss     = vmcb->save.ss;
-	nested_vmcb->save.ds     = vmcb->save.ds;
-	nested_vmcb->save.gdtr   = vmcb->save.gdtr;
-	nested_vmcb->save.idtr   = vmcb->save.idtr;
+	nested_vmcb->save.es     = *svm_es_read(svm);
+	nested_vmcb->save.cs     = *svm_cs_read(svm);
+	nested_vmcb->save.ss     = *svm_ss_read(svm);
+	nested_vmcb->save.ds     = *svm_ds_read(svm);
+	nested_vmcb->save.gdtr   = *svm_gdtr_read(svm);
+	nested_vmcb->save.idtr   = *svm_idtr_read(svm);
 	nested_vmcb->save.efer   = svm->vcpu.arch.efer;
 	nested_vmcb->save.cr0    = kvm_read_cr0(&svm->vcpu);
 	nested_vmcb->save.cr3    = kvm_read_cr3(&svm->vcpu);
-	nested_vmcb->save.cr2    = vmcb->save.cr2;
+	nested_vmcb->save.cr2    = svm_cr2_read(svm);
 	nested_vmcb->save.cr4    = svm->vcpu.arch.cr4;
 	nested_vmcb->save.rflags = kvm_get_rflags(&svm->vcpu);
 	nested_vmcb->save.rip    = kvm_rip_read(&svm->vcpu);
 	nested_vmcb->save.rsp    = kvm_rsp_read(&svm->vcpu);
 	nested_vmcb->save.rax    = kvm_rax_read(&svm->vcpu);
-	nested_vmcb->save.dr7    = vmcb->save.dr7;
+	nested_vmcb->save.dr7    = svm_dr7_read(svm);
 	nested_vmcb->save.dr6    = svm->vcpu.arch.dr6;
-	nested_vmcb->save.cpl    = vmcb->save.cpl;
+	nested_vmcb->save.cpl    = svm_cpl_read(svm);
 
 	nested_vmcb->control.int_state         = vmcb->control.int_state;
 	nested_vmcb->control.exit_code         = vmcb->control.exit_code;
@@ -625,9 +626,9 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	nested_vmcb->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
 	nested_vmcb->control.pause_filter_count =
-		svm->vmcb->control.pause_filter_count;
+		vmcb->control.pause_filter_count;
 	nested_vmcb->control.pause_filter_thresh =
-		svm->vmcb->control.pause_filter_thresh;
+		vmcb->control.pause_filter_thresh;
 
 	/* Restore the original control entries */
 	copy_vmcb_control_area(&vmcb->control, &hsave->control);
@@ -638,12 +639,12 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	svm->nested.ctl.nested_cr3 = 0;
 
 	/* Restore selected save entries */
-	svm->vmcb->save.es = hsave->save.es;
-	svm->vmcb->save.cs = hsave->save.cs;
-	svm->vmcb->save.ss = hsave->save.ss;
-	svm->vmcb->save.ds = hsave->save.ds;
-	svm->vmcb->save.gdtr = hsave->save.gdtr;
-	svm->vmcb->save.idtr = hsave->save.idtr;
+	svm_es_write(svm, &hsave->save.es);
+	svm_cs_write(svm, &hsave->save.cs);
+	svm_ss_write(svm, &hsave->save.ss);
+	svm_ds_write(svm, &hsave->save.ds);
+	svm_gdtr_write(svm, &hsave->save.gdtr);
+	svm_idtr_write(svm, &hsave->save.idtr);
 	kvm_set_rflags(&svm->vcpu, hsave->save.rflags);
 	svm_set_efer(&svm->vcpu, hsave->save.efer);
 	svm_set_cr0(&svm->vcpu, hsave->save.cr0 | X86_CR0_PE);
@@ -651,11 +652,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	kvm_rax_write(&svm->vcpu, hsave->save.rax);
 	kvm_rsp_write(&svm->vcpu, hsave->save.rsp);
 	kvm_rip_write(&svm->vcpu, hsave->save.rip);
-	svm->vmcb->save.dr7 = 0;
-	svm->vmcb->save.cpl = 0;
-	svm->vmcb->control.exit_int_info = 0;
+	svm_dr7_write(svm, 0);
+	svm_cpl_write(svm, 0);
+	vmcb->control.exit_int_info = 0;
 
-	vmcb_mark_all_dirty(svm->vmcb);
+	vmcb_mark_all_dirty(vmcb);
 
 	trace_kvm_nested_vmexit_inject(nested_vmcb->control.exit_code,
 				       nested_vmcb->control.exit_info_1,
@@ -673,7 +674,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		return 1;
 
 	if (npt_enabled)
-		svm->vmcb->save.cr3 = hsave->save.cr3;
+		svm_cr3_write(svm, hsave->save.cr3);
 
 	/*
 	 * Drop what we picked up for L2 via svm_complete_interrupts() so it
@@ -819,7 +820,7 @@ int nested_svm_check_permissions(struct vcpu_svm *svm)
 		return 1;
 	}
 
-	if (svm->vmcb->save.cpl) {
+	if (svm_cpl_read(svm)) {
 		kvm_inject_gp(&svm->vcpu, 0);
 		return 1;
 	}
@@ -888,7 +889,7 @@ static void nested_svm_nmi(struct vcpu_svm *svm)
 
 static void nested_svm_intr(struct vcpu_svm *svm)
 {
-	trace_kvm_nested_intr_vmexit(svm->vmcb->save.rip);
+	trace_kvm_nested_intr_vmexit(svm_rip_read(svm));
 
 	svm->vmcb->control.exit_code   = SVM_EXIT_INTR;
 	svm->vmcb->control.exit_info_1 = 0;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 83292fc44b4e..779c167e42cc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -285,7 +285,7 @@ void svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 		svm_set_gif(svm, true);
 	}
 
-	svm->vmcb->save.efer = efer | EFER_SVME;
+	svm_efer_write(svm, efer | EFER_SVME);
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
 
@@ -357,7 +357,7 @@ static void svm_queue_exception(struct kvm_vcpu *vcpu)
 		 */
 		(void)skip_emulated_instruction(&svm->vcpu);
 		rip = kvm_rip_read(&svm->vcpu);
-		svm->int3_rip = rip + svm->vmcb->save.cs.base;
+		svm->int3_rip = rip + svm_cs_read_base(svm);
 		svm->int3_injected = rip - old_rip;
 	}
 
@@ -699,9 +699,9 @@ void disable_nmi_singlestep(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
 		/* Clear our flags if they were not set by the guest */
 		if (!(svm->nmi_singlestep_guest_rflags & X86_EFLAGS_TF))
-			svm->vmcb->save.rflags &= ~X86_EFLAGS_TF;
+			svm_rflags_and(svm, ~X86_EFLAGS_TF);
 		if (!(svm->nmi_singlestep_guest_rflags & X86_EFLAGS_RF))
-			svm->vmcb->save.rflags &= ~X86_EFLAGS_RF;
+			svm_rflags_and(svm, ~X86_EFLAGS_RF);
 	}
 }
 
@@ -988,7 +988,7 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 static void init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct vmcb_save_area *save = &svm->vmcb->save;
+	struct vmcb_save_area *save = get_vmsa(svm);
 
 	svm->vcpu.arch.hflags = 0;
 
@@ -1328,7 +1328,7 @@ static void svm_vcpu_put(struct kvm_vcpu *vcpu)
 static unsigned long svm_get_rflags(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	unsigned long rflags = svm->vmcb->save.rflags;
+	unsigned long rflags = svm_rflags_read(svm);
 
 	if (svm->nmi_singlestep) {
 		/* Hide our flags if they were not set by the guest */
@@ -1350,7 +1350,7 @@ static void svm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
         * (caused by either a task switch or an inter-privilege IRET),
         * so we do not need to update the CPL here.
         */
-	to_svm(vcpu)->vmcb->save.rflags = rflags;
+	svm_rflags_write(to_svm(vcpu), rflags);
 }
 
 static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
@@ -1405,7 +1405,7 @@ static void svm_clear_vintr(struct vcpu_svm *svm)
 
 static struct vmcb_seg *svm_seg(struct kvm_vcpu *vcpu, int seg)
 {
-	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
+	struct vmcb_save_area *save = get_vmsa(to_svm(vcpu));
 
 	switch (seg) {
 	case VCPU_SREG_CS: return &save->cs;
@@ -1492,32 +1492,30 @@ static void svm_get_segment(struct kvm_vcpu *vcpu,
 		if (var->unusable)
 			var->db = 0;
 		/* This is symmetric with svm_set_segment() */
-		var->dpl = to_svm(vcpu)->vmcb->save.cpl;
+		var->dpl = svm_cpl_read(to_svm(vcpu));
 		break;
 	}
 }
 
 static int svm_get_cpl(struct kvm_vcpu *vcpu)
 {
-	struct vmcb_save_area *save = &to_svm(vcpu)->vmcb->save;
-
-	return save->cpl;
+	return svm_cpl_read(to_svm(vcpu));
 }
 
 static void svm_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	dt->size = svm->vmcb->save.idtr.limit;
-	dt->address = svm->vmcb->save.idtr.base;
+	dt->size = svm_idtr_read_limit(svm);
+	dt->address = svm_idtr_read_base(svm);
 }
 
 static void svm_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->save.idtr.limit = dt->size;
-	svm->vmcb->save.idtr.base = dt->address ;
+	svm_idtr_write_limit(svm, dt->size);
+	svm_idtr_write_base(svm, dt->address);
 	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
 }
 
@@ -1525,30 +1523,31 @@ static void svm_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	dt->size = svm->vmcb->save.gdtr.limit;
-	dt->address = svm->vmcb->save.gdtr.base;
+	dt->size = svm_gdtr_read_limit(svm);
+	dt->address = svm_gdtr_read_base(svm);
 }
 
 static void svm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->save.gdtr.limit = dt->size;
-	svm->vmcb->save.gdtr.base = dt->address ;
+	svm_gdtr_write_limit(svm, dt->size);
+	svm_gdtr_write_base(svm, dt->address);
 	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
 }
 
 static void update_cr0_intercept(struct vcpu_svm *svm)
 {
 	ulong gcr0 = svm->vcpu.arch.cr0;
-	u64 *hcr0 = &svm->vmcb->save.cr0;
+	u64 hcr0;
 
-	*hcr0 = (*hcr0 & ~SVM_CR0_SELECTIVE_MASK)
+	hcr0 = (svm_cr0_read(svm) & ~SVM_CR0_SELECTIVE_MASK)
 		| (gcr0 & SVM_CR0_SELECTIVE_MASK);
 
+	svm_cr0_write(svm, hcr0);
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 
-	if (gcr0 == *hcr0) {
+	if (gcr0 == hcr0) {
 		clr_cr_intercept(svm, INTERCEPT_CR0_READ);
 		clr_cr_intercept(svm, INTERCEPT_CR0_WRITE);
 	} else {
@@ -1565,12 +1564,12 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	if (vcpu->arch.efer & EFER_LME) {
 		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer |= EFER_LMA;
-			svm->vmcb->save.efer |= EFER_LMA | EFER_LME;
+			svm_efer_or(svm, EFER_LMA | EFER_LME);
 		}
 
 		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG)) {
 			vcpu->arch.efer &= ~EFER_LMA;
-			svm->vmcb->save.efer &= ~(EFER_LMA | EFER_LME);
+			svm_efer_and(svm, ~(EFER_LMA | EFER_LME));
 		}
 	}
 #endif
@@ -1586,7 +1585,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	 */
 	if (kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 		cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
-	svm->vmcb->save.cr0 = cr0;
+	svm_cr0_write(svm, cr0);
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 	update_cr0_intercept(svm);
 }
@@ -1594,7 +1593,7 @@ void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	unsigned long host_cr4_mce = cr4_read_shadow() & X86_CR4_MCE;
-	unsigned long old_cr4 = to_svm(vcpu)->vmcb->save.cr4;
+	unsigned long old_cr4 = svm_cr4_read(to_svm(vcpu));
 
 	if (cr4 & X86_CR4_VMXE)
 		return 1;
@@ -1606,7 +1605,7 @@ int svm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (!npt_enabled)
 		cr4 |= X86_CR4_PAE;
 	cr4 |= host_cr4_mce;
-	to_svm(vcpu)->vmcb->save.cr4 = cr4;
+	svm_cr4_write(to_svm(vcpu), cr4);
 	vmcb_mark_dirty(to_svm(vcpu)->vmcb, VMCB_CR);
 	return 0;
 }
@@ -1637,7 +1636,7 @@ static void svm_set_segment(struct kvm_vcpu *vcpu,
 	 */
 	if (seg == VCPU_SREG_SS)
 		/* This is symmetric with svm_get_segment() */
-		svm->vmcb->save.cpl = (var->dpl & 3);
+		svm_cpl_write(svm, (var->dpl & 3));
 
 	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 }
@@ -1672,8 +1671,8 @@ static void svm_set_dr6(struct vcpu_svm *svm, unsigned long value)
 {
 	struct vmcb *vmcb = svm->vmcb;
 
-	if (unlikely(value != vmcb->save.dr6)) {
-		vmcb->save.dr6 = value;
+	if (unlikely(value != svm_dr6_read(svm))) {
+		svm_dr6_write(svm, value);
 		vmcb_mark_dirty(vmcb, VMCB_DR);
 	}
 }
@@ -1690,8 +1689,8 @@ static void svm_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
 	 * We cannot reset svm->vmcb->save.dr6 to DR6_FIXED_1|DR6_RTM here,
 	 * because db_interception might need it.  We can do it before vmentry.
 	 */
-	vcpu->arch.dr6 = svm->vmcb->save.dr6;
-	vcpu->arch.dr7 = svm->vmcb->save.dr7;
+	vcpu->arch.dr6 = svm_dr6_read(svm);
+	vcpu->arch.dr7 = svm_dr7_read(svm);
 	vcpu->arch.switch_db_regs &= ~KVM_DEBUGREG_WONT_EXIT;
 	set_dr_intercepts(svm);
 }
@@ -1700,7 +1699,7 @@ static void svm_set_dr7(struct kvm_vcpu *vcpu, unsigned long value)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->save.dr7 = value;
+	svm_dr7_write(svm, value);
 	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 }
 
@@ -1735,7 +1734,7 @@ static int db_interception(struct vcpu_svm *svm)
 	if (!(svm->vcpu.guest_debug &
 	      (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) &&
 		!svm->nmi_singlestep) {
-		u32 payload = (svm->vmcb->save.dr6 ^ DR6_RTM) & ~DR6_FIXED_1;
+		u32 payload = (svm_dr6_read(svm) ^ DR6_RTM) & ~DR6_FIXED_1;
 		kvm_queue_exception_p(&svm->vcpu, DB_VECTOR, payload);
 		return 1;
 	}
@@ -1749,10 +1748,10 @@ static int db_interception(struct vcpu_svm *svm)
 	if (svm->vcpu.guest_debug &
 	    (KVM_GUESTDBG_SINGLESTEP | KVM_GUESTDBG_USE_HW_BP)) {
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		kvm_run->debug.arch.dr6 = svm->vmcb->save.dr6;
-		kvm_run->debug.arch.dr7 = svm->vmcb->save.dr7;
+		kvm_run->debug.arch.dr6 = svm_dr6_read(svm);
+		kvm_run->debug.arch.dr7 = svm_dr7_read(svm);
 		kvm_run->debug.arch.pc =
-			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+			svm_cs_read_base(svm) + svm_rip_read(svm);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		return 0;
 	}
@@ -1765,7 +1764,7 @@ static int bp_interception(struct vcpu_svm *svm)
 	struct kvm_run *kvm_run = svm->vcpu.run;
 
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
-	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+	kvm_run->debug.arch.pc = svm_cs_read_base(svm) + svm_rip_read(svm);
 	kvm_run->debug.arch.exception = BP_VECTOR;
 	return 0;
 }
@@ -1953,7 +1952,7 @@ static int vmload_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm_rax_read(svm)), &map);
 	if (ret) {
 		if (ret == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
@@ -1964,7 +1963,7 @@ static int vmload_interception(struct vcpu_svm *svm)
 
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
-	nested_svm_vmloadsave(nested_vmcb, svm->vmcb);
+	nested_svm_vmloadsave(&nested_vmcb->save, get_vmsa(svm));
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	return ret;
@@ -1979,7 +1978,7 @@ static int vmsave_interception(struct vcpu_svm *svm)
 	if (nested_svm_check_permissions(svm))
 		return 1;
 
-	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->vmcb->save.rax), &map);
+	ret = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm_rax_read(svm)), &map);
 	if (ret) {
 		if (ret == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
@@ -1990,7 +1989,7 @@ static int vmsave_interception(struct vcpu_svm *svm)
 
 	ret = kvm_skip_emulated_instruction(&svm->vcpu);
 
-	nested_svm_vmloadsave(svm->vmcb, nested_vmcb);
+	nested_svm_vmloadsave(get_vmsa(svm), &nested_vmcb->save);
 	kvm_vcpu_unmap(&svm->vcpu, &map, true);
 
 	return ret;
@@ -2064,7 +2063,7 @@ static int invlpga_interception(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	trace_kvm_invlpga(svm->vmcb->save.rip, kvm_rcx_read(&svm->vcpu),
+	trace_kvm_invlpga(svm_rip_read(svm), kvm_rcx_read(&svm->vcpu),
 			  kvm_rax_read(&svm->vcpu));
 
 	/* Let's treat INVLPGA the same as INVLPG (can be optimized!) */
@@ -2075,7 +2074,7 @@ static int invlpga_interception(struct vcpu_svm *svm)
 
 static int skinit_interception(struct vcpu_svm *svm)
 {
-	trace_kvm_skinit(svm->vmcb->save.rip, kvm_rax_read(&svm->vcpu));
+	trace_kvm_skinit(svm_rip_read(svm), kvm_rax_read(&svm->vcpu));
 
 	kvm_queue_exception(&svm->vcpu, UD_VECTOR);
 	return 1;
@@ -2387,24 +2386,24 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	switch (msr_info->index) {
 	case MSR_STAR:
-		msr_info->data = svm->vmcb->save.star;
+		msr_info->data = svm_star_read(svm);
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_LSTAR:
-		msr_info->data = svm->vmcb->save.lstar;
+		msr_info->data = svm_lstar_read(svm);
 		break;
 	case MSR_CSTAR:
-		msr_info->data = svm->vmcb->save.cstar;
+		msr_info->data = svm_cstar_read(svm);
 		break;
 	case MSR_KERNEL_GS_BASE:
-		msr_info->data = svm->vmcb->save.kernel_gs_base;
+		msr_info->data = svm_kernel_gs_base_read(svm);
 		break;
 	case MSR_SYSCALL_MASK:
-		msr_info->data = svm->vmcb->save.sfmask;
+		msr_info->data = svm_sfmask_read(svm);
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		msr_info->data = svm->vmcb->save.sysenter_cs;
+		msr_info->data = svm_sysenter_cs_read(svm);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
 		msr_info->data = svm->sysenter_eip;
@@ -2423,19 +2422,19 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	 * implemented.
 	 */
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = svm->vmcb->save.dbgctl;
+		msr_info->data = svm_dbgctl_read(svm);
 		break;
 	case MSR_IA32_LASTBRANCHFROMIP:
-		msr_info->data = svm->vmcb->save.br_from;
+		msr_info->data = svm_br_from_read(svm);
 		break;
 	case MSR_IA32_LASTBRANCHTOIP:
-		msr_info->data = svm->vmcb->save.br_to;
+		msr_info->data = svm_br_to_read(svm);
 		break;
 	case MSR_IA32_LASTINTFROMIP:
-		msr_info->data = svm->vmcb->save.last_excp_from;
+		msr_info->data = svm_last_excp_from_read(svm);
 		break;
 	case MSR_IA32_LASTINTTOIP:
-		msr_info->data = svm->vmcb->save.last_excp_to;
+		msr_info->data = svm_last_excp_to_read(svm);
 		break;
 	case MSR_VM_HSAVE_PA:
 		msr_info->data = svm->nested.hsave_msr;
@@ -2527,7 +2526,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
 			return 1;
 		vcpu->arch.pat = data;
-		svm->vmcb->save.g_pat = data;
+		svm_g_pat_write(svm, data);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 		break;
 	case MSR_IA32_SPEC_CTRL:
@@ -2584,32 +2583,32 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		svm->virt_spec_ctrl = data;
 		break;
 	case MSR_STAR:
-		svm->vmcb->save.star = data;
+		svm_star_write(svm, data);
 		break;
 #ifdef CONFIG_X86_64
 	case MSR_LSTAR:
-		svm->vmcb->save.lstar = data;
+		svm_lstar_write(svm, data);
 		break;
 	case MSR_CSTAR:
-		svm->vmcb->save.cstar = data;
+		svm_cstar_write(svm, data);
 		break;
 	case MSR_KERNEL_GS_BASE:
-		svm->vmcb->save.kernel_gs_base = data;
+		svm_kernel_gs_base_write(svm, data);
 		break;
 	case MSR_SYSCALL_MASK:
-		svm->vmcb->save.sfmask = data;
+		svm_sfmask_write(svm, data);
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
-		svm->vmcb->save.sysenter_cs = data;
+		svm_sysenter_cs_write(svm, data);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
 		svm->sysenter_eip = data;
-		svm->vmcb->save.sysenter_eip = data;
+		svm_sysenter_eip_write(svm, data);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
 		svm->sysenter_esp = data;
-		svm->vmcb->save.sysenter_esp = data;
+		svm_sysenter_esp_write(svm, data);
 		break;
 	case MSR_TSC_AUX:
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
@@ -2632,7 +2631,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
-		svm->vmcb->save.dbgctl = data;
+		svm_dbgctl_write(svm, data);
 		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
 		if (data & (1ULL<<0))
 			svm_enable_lbrv(svm);
@@ -2805,7 +2804,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct vmcb_save_area *save = &svm->vmcb->save;
+	struct vmcb_save_area *save = get_vmsa(svm);
 
 	if (!dump_invalid_vmcb) {
 		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
@@ -2934,16 +2933,16 @@ static int handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	trace_kvm_exit(exit_code, vcpu, KVM_ISA_SVM);
 
 	if (!is_cr_intercept(svm, INTERCEPT_CR0_WRITE))
-		vcpu->arch.cr0 = svm->vmcb->save.cr0;
+		vcpu->arch.cr0 = svm_cr0_read(svm);
 	if (npt_enabled)
-		vcpu->arch.cr3 = svm->vmcb->save.cr3;
+		vcpu->arch.cr3 = svm_cr3_read(svm);
 
 	svm_complete_interrupts(svm);
 
 	if (is_guest_mode(vcpu)) {
 		int vmexit;
 
-		trace_kvm_nested_vmexit(svm->vmcb->save.rip, exit_code,
+		trace_kvm_nested_vmexit(svm_rip_read(svm), exit_code,
 					svm->vmcb->control.exit_info_1,
 					svm->vmcb->control.exit_info_2,
 					svm->vmcb->control.exit_int_info,
@@ -3204,7 +3203,7 @@ static void enable_nmi_window(struct kvm_vcpu *vcpu)
 	 */
 	svm->nmi_singlestep_guest_rflags = svm_get_rflags(vcpu);
 	svm->nmi_singlestep = true;
-	svm->vmcb->save.rflags |= (X86_EFLAGS_TF | X86_EFLAGS_RF);
+	svm_rflags_or(svm, (X86_EFLAGS_TF | X86_EFLAGS_RF));
 }
 
 static int svm_set_tss_addr(struct kvm *kvm, unsigned int addr)
@@ -3418,9 +3417,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	fastpath_t exit_fastpath;
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+	svm_rax_write(svm, vcpu->arch.regs[VCPU_REGS_RAX]);
+	svm_rsp_write(svm, vcpu->arch.regs[VCPU_REGS_RSP]);
+	svm_rip_write(svm, vcpu->arch.regs[VCPU_REGS_RIP]);
 
 	/*
 	 * Disable singlestep if we're injecting an interrupt/exception.
@@ -3442,7 +3441,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	sync_lapic_to_cr8(vcpu);
 
-	svm->vmcb->save.cr2 = vcpu->arch.cr2;
+	svm_cr2_write(svm, vcpu->arch.cr2);
 
 	/*
 	 * Run with all-zero DR6 unless needed, so that we can get the exact cause
@@ -3492,10 +3491,10 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
-	vcpu->arch.cr2 = svm->vmcb->save.cr2;
-	vcpu->arch.regs[VCPU_REGS_RAX] = svm->vmcb->save.rax;
-	vcpu->arch.regs[VCPU_REGS_RSP] = svm->vmcb->save.rsp;
-	vcpu->arch.regs[VCPU_REGS_RIP] = svm->vmcb->save.rip;
+	vcpu->arch.cr2 = svm_cr2_read(svm);
+	vcpu->arch.regs[VCPU_REGS_RAX] = svm_rax_read(svm);
+	vcpu->arch.regs[VCPU_REGS_RSP] = svm_rsp_read(svm);
+	vcpu->arch.regs[VCPU_REGS_RIP] = svm_rip_read(svm);
 
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
@@ -3558,7 +3557,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 		cr3 = vcpu->arch.cr3;
 	}
 
-	svm->vmcb->save.cr3 = cr3;
+	svm_cr3_write(svm, cr3);
 	vmcb_mark_dirty(svm->vmcb, VMCB_CR);
 }
 
@@ -3886,9 +3885,9 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 		/* FEE0h - SVM Guest VMCB Physical Address */
 		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb);
 
-		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-		svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+		svm_rax_write(svm, vcpu->arch.regs[VCPU_REGS_RAX]);
+		svm_rsp_write(svm, vcpu->arch.regs[VCPU_REGS_RSP]);
+		svm_rip_write(svm, vcpu->arch.regs[VCPU_REGS_RIP]);
 
 		ret = nested_svm_vmexit(svm);
 		if (ret)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 2692ddf30c8d..f42ba9d158df 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -395,7 +395,8 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 			 struct vmcb *nested_vmcb);
 void svm_leave_nested(struct vcpu_svm *svm);
 int nested_svm_vmrun(struct vcpu_svm *svm);
-void nested_svm_vmloadsave(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
+void nested_svm_vmloadsave(struct vmcb_save_area *from_vmsa,
+			   struct vmcb_save_area *to_vmsa);
 int nested_svm_vmexit(struct vcpu_svm *svm);
 int nested_svm_exit_handled(struct vcpu_svm *svm);
 int nested_svm_check_permissions(struct vcpu_svm *svm);
@@ -504,4 +505,130 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_hardware_setup(void);
 void sev_hardware_teardown(void);
 
+/* VMSA Accessor functions */
+
+static inline struct vmcb_save_area *get_vmsa(struct vcpu_svm *svm)
+{
+	return &svm->vmcb->save;
+}
+
+#define DEFINE_VMSA_SEGMENT_ENTRY(_field, _entry, _size)		\
+	static inline _size						\
+	svm_##_field##_read_##_entry(struct vcpu_svm *svm)		\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		return vmsa->_field._entry;				\
+	}								\
+									\
+	static inline void						\
+	svm_##_field##_write_##_entry(struct vcpu_svm *svm,		\
+				      _size value)			\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		vmsa->_field._entry = value;				\
+	}								\
+
+#define DEFINE_VMSA_SEGMENT_ACCESSOR(_field)				\
+	DEFINE_VMSA_SEGMENT_ENTRY(_field, selector, u16)		\
+	DEFINE_VMSA_SEGMENT_ENTRY(_field, attrib, u16)			\
+	DEFINE_VMSA_SEGMENT_ENTRY(_field, limit, u32)			\
+	DEFINE_VMSA_SEGMENT_ENTRY(_field, base, u64)			\
+									\
+	static inline struct vmcb_seg *					\
+	svm_##_field##_read(struct vcpu_svm *svm)			\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		return &vmsa->_field;					\
+	}								\
+									\
+	static inline void						\
+	svm_##_field##_write(struct vcpu_svm *svm,			\
+			    struct vmcb_seg *seg)			\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		vmsa->_field = *seg;					\
+	}
+
+DEFINE_VMSA_SEGMENT_ACCESSOR(cs)
+DEFINE_VMSA_SEGMENT_ACCESSOR(ds)
+DEFINE_VMSA_SEGMENT_ACCESSOR(es)
+DEFINE_VMSA_SEGMENT_ACCESSOR(fs)
+DEFINE_VMSA_SEGMENT_ACCESSOR(gs)
+DEFINE_VMSA_SEGMENT_ACCESSOR(ss)
+DEFINE_VMSA_SEGMENT_ACCESSOR(gdtr)
+DEFINE_VMSA_SEGMENT_ACCESSOR(idtr)
+DEFINE_VMSA_SEGMENT_ACCESSOR(ldtr)
+DEFINE_VMSA_SEGMENT_ACCESSOR(tr)
+
+#define DEFINE_VMSA_SIZE_ACCESSOR(_field, _size)			\
+	static inline _size						\
+	svm_##_field##_read(struct vcpu_svm *svm)			\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		return vmsa->_field;					\
+	}								\
+									\
+	static inline void						\
+	svm_##_field##_write(struct vcpu_svm *svm, _size value)		\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		vmsa->_field = value;					\
+	}								\
+									\
+	static inline void						\
+	svm_##_field##_and(struct vcpu_svm *svm, _size value)		\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		vmsa->_field &= value;					\
+	}								\
+									\
+	static inline void						\
+	svm_##_field##_or(struct vcpu_svm *svm, _size value)		\
+	{								\
+		struct vmcb_save_area *vmsa = get_vmsa(svm);		\
+									\
+		vmsa->_field |= value;					\
+	}
+
+#define DEFINE_VMSA_ACCESSOR(_field)					\
+	DEFINE_VMSA_SIZE_ACCESSOR(_field, u64)
+
+#define DEFINE_VMSA_U8_ACCESSOR(_field)					\
+	DEFINE_VMSA_SIZE_ACCESSOR(_field, u8)
+
+DEFINE_VMSA_ACCESSOR(efer)
+DEFINE_VMSA_ACCESSOR(cr0)
+DEFINE_VMSA_ACCESSOR(cr2)
+DEFINE_VMSA_ACCESSOR(cr3)
+DEFINE_VMSA_ACCESSOR(cr4)
+DEFINE_VMSA_ACCESSOR(dr6)
+DEFINE_VMSA_ACCESSOR(dr7)
+DEFINE_VMSA_ACCESSOR(rflags)
+DEFINE_VMSA_ACCESSOR(star)
+DEFINE_VMSA_ACCESSOR(lstar)
+DEFINE_VMSA_ACCESSOR(cstar)
+DEFINE_VMSA_ACCESSOR(sfmask)
+DEFINE_VMSA_ACCESSOR(kernel_gs_base)
+DEFINE_VMSA_ACCESSOR(sysenter_cs)
+DEFINE_VMSA_ACCESSOR(sysenter_esp)
+DEFINE_VMSA_ACCESSOR(sysenter_eip)
+DEFINE_VMSA_ACCESSOR(g_pat)
+DEFINE_VMSA_ACCESSOR(dbgctl)
+DEFINE_VMSA_ACCESSOR(br_from)
+DEFINE_VMSA_ACCESSOR(br_to)
+DEFINE_VMSA_ACCESSOR(last_excp_from)
+DEFINE_VMSA_ACCESSOR(last_excp_to)
+
+DEFINE_VMSA_U8_ACCESSOR(cpl)
+DEFINE_VMSA_ACCESSOR(rip)
+DEFINE_VMSA_ACCESSOR(rax)
+DEFINE_VMSA_ACCESSOR(rsp)
+
 #endif
-- 
2.28.0

