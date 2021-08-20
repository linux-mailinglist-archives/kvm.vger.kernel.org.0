Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D81C3F30B5
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbhHTQCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:02:55 -0400
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:3905
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235210AbhHTQBv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R7MeuaxEDqeEie6Net+P8VydbpzST7iBDgAHoOWJiJGcMU95YgEsvRobLD4rlbP2XgUvxRyIZPiZb4yD7IyTCTC1esTTYMF9RSVWpnlYIpFFhfl6vqU2CQWOlTdaffusksSPnXmrt42lzuURsjwJsGP4MF51aREiaf+Sc7NnFOnLw2Dgmg4xDYOzUWmqw2UrJ2mOJeZAGrFXug86EEXZeJ9yvrPhsigyT2zEFEworX4BgC2E5M87azC/CMf5WnowckmKAE3/caUTJu/iTJOPExguEPxSF86XA1RAj5wyJikDb4i5Ik0RZbU9e2ZWNOt1iY7c2RNH0w1PqCmQX2u3Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7oYclA2ctLaqK+het86Nyg5zcVcsGgO+5/BrXDlfzg=;
 b=BiShOt8GLVFNglv6Ns7DTNsKQKRDXiT2NHnyFFdiu+mRDSEfJrijHzsGb4zUQElz7F85asFcHfAeezT8OqGuV7MoM7iarOODqsyQkV1jl1VzXIMIZCHOC2egedvLE9Lu7II2JPd1hnhxDE7h1M/OHUxQ8lUezlxaiVHYrfcXgyUj0iF5pkvUMsKPlLjANOjhD3F0jU1ZsVDhWs2aLkpKxxkLSVMtRhU+yCm1SHyRerN6L+JATqE8C/sbCjGnNW4vJVM2gfcFcjmwft/suZy49sNrWq/QzLdP4CdwjSPSU9OGyLUS2ebLR+T9l9pBckjU1zQZn/PnYmw2rGsu8+McAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y7oYclA2ctLaqK+het86Nyg5zcVcsGgO+5/BrXDlfzg=;
 b=ybVpQxgwtTLPCjIoHJS8g8qbXBTlePSdDd2Rtu26xZgAvedEYhCnd2A1vqctVuc97kl2pjyR03Juk23TvxkfvZ4/qB8O+dVQjEt0IPp9YvuJ3p0aasYwUdszpersZUTuZ29cD0z4uzLGWYX/TJ67N7xslFv/hnDjzco6MLWbhi8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:07 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 35/45] KVM: SVM: Remove the long-lived GHCB host map
Date:   Fri, 20 Aug 2021 10:59:08 -0500
Message-Id: <20210820155918.7518-36-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8eca29c-80dd-4e5c-b5fb-08d963f3a795
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509B89C16A80D37E333CABEE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nhszm+EdJiZ4kn26QSMREa0LF5fERPrKtr7t/rxCWG6dqVdgARVX6nRR3U84wtun8rLnzrodcCkep590MxGCmpJi0zlphKuDDlYMUL+zwBmg7LyO8S2+B4bHL7kHn4jYSWdPbsXx52xa/Eeviscx2IXYo3LVErl2Vt42G6uNbu9n9i76/SmNcXi2e7wwGkYweQOzEeBjzZaqA4FUYyyoNkCADrKNm7aFj6o0XnXDGixaEtnNwpUivBWAq2Zo5+Te6Igd3R6PElPWxoNwCozc2h8/rKEiSybHISZKm1B+eKIZaHShE9L3JI8OPvcE5+yH376FT5wyTy1qdhKAospWcUHM3zsMszdpedHeYSxqUoDlCHJ8R+wOZuTcFD4l1b687dDkBc1JXcW1pgZJCb5PC8xIm84cac02kEVlvNjbcfhvugOuyjF3LM01wkV5FGz9HgZCyfrZWEFw6izdizYjETy4IXQ4NHKriqKfxK2nO83EslKlmLpiQUVaiqbyW481K9eqHYwh+Yn7Fr3iN5p3CFL9ObZx7GSFra1vcj8FyzQb/blc+ic24x6fu+6PHRVsAiFn8jEh+wncr3jsgwfDYz7frXDTcP+SgKdABAgsfonQmG/R7EklfGZm4SeMXuTDvuZk0nqW9WvfLx8ysT8gciQfaV9MOtcWVXa6CJHzbYe6PgQTf7nxmtwaj6VQIYCyGecRuUaZ+LGT1EslfOQPfGssgdu03nzh776imnGxyeA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(30864003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ERCKBAmvVuIVmhCd8Y2HtOgoddJ9kv+Sj72rIavFJe2ObHwO47ecfT0yNT+P?=
 =?us-ascii?Q?8R6aGHpYQalarTZAgx/zk2Gmswse9PYpBYduc6aHsYjD7092x0U1qhiJDfYU?=
 =?us-ascii?Q?qWdsWGi93iSloug6KWY4MbKwzwgdN75mn4WI6PkY9BOIAXBH2lycJQ9rgBqI?=
 =?us-ascii?Q?vJKICY3yJR1SQ4C+GFUvYcI+NPzFBCsfiZIzYn/FMalvxphsiKcNpq/V+3GJ?=
 =?us-ascii?Q?5B+YtdbiV3JOhUwLkUR9Ql2U2P9HODHJc94MyJh+Q+Pxe8TN93wGmz3rZVMO?=
 =?us-ascii?Q?zabhZcN0NzOLFJ1D1Yt49PnM8ZLenOwKOd8H0/bsNS37UcogP2q8sr0mUQUL?=
 =?us-ascii?Q?LnO0/Pi89NvwWHXlgAuW+SCMUESS6In2Ie5qmuUTZDH3vNNSnua03hrdEDtK?=
 =?us-ascii?Q?VomNROjsuVVBvQNio5Lrth59D5N7XrmRUd/DHLhAfdf+O26cKi+Mjn5BaRvx?=
 =?us-ascii?Q?d1++Km0+icgtfBPt0+gb3+x+cfCj3o0oU2oPJ9wQwDPua8nbFLIacfNiHOa1?=
 =?us-ascii?Q?Lg9SUWiWq6LuJ4yJV8b67q1uid8xvE3oaIq6vGpi1gFCuSpG1xHXTbyiFZWr?=
 =?us-ascii?Q?wbYKPgiHwIoMSSdDnQXy4r7E/KdH4wlG3U6ZjrWb/tAwFKthlKsBC51AbaML?=
 =?us-ascii?Q?5QWyr5nRYAxuZK92TBNvRg7V8shVEASbzm4yFcDdrF/rbYlEAklv6ifkgiwN?=
 =?us-ascii?Q?42rJgzMbAegOJ90Pwm+VH3JuemwUlnRqtk0S2nn2u2+7tjunkISZ1aakBmnk?=
 =?us-ascii?Q?psadaAl5L0kCcF/QF2GnHMGNNVVZJpbvQ83bXZCjzXKiMn4Wp4L9r5INX/mr?=
 =?us-ascii?Q?oA6pI/X3IwU+RW2Mv36+JBTvqvkCJNb/1+gq10DZMFFLh2hHyEa2Mhgc6Fxc?=
 =?us-ascii?Q?K7h1PuZ6lDbOFIewiv1nDctIEaaykcKOj3LycfZM2q0AAVhRkuQuItVUtG33?=
 =?us-ascii?Q?QGW4qEJJ/2E60ohSGEEaYR0mBQhpcV0EImzSUmunHGeFgalY7IhFYaOj9whO?=
 =?us-ascii?Q?YzbQ568MDt1+YqloHFtS+dusJuXrEHrM6Mc/D+mLSJd2xeN7BoipvMMX8rDj?=
 =?us-ascii?Q?2B3EU4wZaW0eOUYCw1QCflCbtdzVqEN5e9owCsAQP3uVUoVFQV8wKUltHup0?=
 =?us-ascii?Q?Z0f8G6HdYroJ/6smgrlT8sMtFSG33/EVz/P1OwGnpR9xpf4MRrPPPviL8yoQ?=
 =?us-ascii?Q?yOrwlZxP2u5IbJl9mRqYnzEOzSiVdmnvS6guBBGUA+VerNip99okpASu4un3?=
 =?us-ascii?Q?mvw4FhCkbI2KYC8CvLPWc3rj/Nn3A8NG8cbxLtMiKfo8Dc5W/0GjGT/YHIRW?=
 =?us-ascii?Q?J2qIf1X+FwZe3bp4zfnPWo1M?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8eca29c-80dd-4e5c-b5fb-08d963f3a795
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:39.1783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZtnoJYBU2173INyRTJ803L3k8/UvTf8r/uf5xNF9Z7WSQijukHw1x3oy2sXbTQ+kGAbWEIw1URwU7o7Nv3Q6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On VMGEXIT, sev_handle_vmgexit() creates a host mapping for the GHCB GPA,
and unmaps it just before VM-entry. This long-lived GHCB map is used by
the VMGEXIT handler through accessors such as ghcb_{set_get}_xxx().

A long-lived GHCB map can cause issue when SEV-SNP is enabled. When
SEV-SNP is enabled the mapped GPA needs to be protected against a page
state change.

To eliminate the long-lived GHCB mapping, update the GHCB sync operations
to explicitly map the GHCB before access and unmap it after access is
complete. This requires that the setting of the GHCBs sw_exit_info_{1,2}
fields be done during sev_es_sync_to_ghcb(), so create two new fields in
the vcpu_svm struct to hold these values when required to be set outside
of the GHCB mapping.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 129 ++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c |  12 ++--
 arch/x86/kvm/svm/svm.h |  24 +++++++-
 3 files changed, 111 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7dfb68e06334..c41d972dadc3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2493,15 +2493,40 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	kfree(svm->ghcb_sa);
 }
 
+static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
+{
+	struct vmcb_control_area *control = &svm->vmcb->control;
+	u64 gfn = gpa_to_gfn(control->ghcb_gpa);
+
+	if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
+		/* Unable to map GHCB from guest */
+		pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
+{
+	kvm_vcpu_unmap(&svm->vcpu, map, true);
+}
+
 static void dump_ghcb(struct vcpu_svm *svm)
 {
-	struct ghcb *ghcb = svm->ghcb;
+	struct kvm_host_map map;
 	unsigned int nbits;
+	struct ghcb *ghcb;
+
+	if (svm_map_ghcb(svm, &map))
+		return;
+
+	ghcb = map.hva;
 
 	/* Re-use the dump_invalid_vmcb module parameter */
 	if (!dump_invalid_vmcb) {
 		pr_warn_ratelimited("set kvm_amd.dump_invalid_vmcb=1 to dump internal KVM state.\n");
-		return;
+		goto e_unmap;
 	}
 
 	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
@@ -2516,12 +2541,21 @@ static void dump_ghcb(struct vcpu_svm *svm)
 	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
 	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
 	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
+
+e_unmap:
+	svm_unmap_ghcb(svm, &map);
 }
 
-static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
+static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->ghcb;
+	struct kvm_host_map map;
+	struct ghcb *ghcb;
+
+	if (svm_map_ghcb(svm, &map))
+		return false;
+
+	ghcb = map.hva;
 
 	/*
 	 * The GHCB protocol so far allows for the following data
@@ -2535,13 +2569,24 @@ static void sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	ghcb_set_rbx(ghcb, vcpu->arch.regs[VCPU_REGS_RBX]);
 	ghcb_set_rcx(ghcb, vcpu->arch.regs[VCPU_REGS_RCX]);
 	ghcb_set_rdx(ghcb, vcpu->arch.regs[VCPU_REGS_RDX]);
+
+	/*
+	 * Copy the return values from the exit_info_{1,2}.
+	 */
+	ghcb_set_sw_exit_info_1(ghcb, svm->ghcb_sw_exit_info_1);
+	ghcb_set_sw_exit_info_2(ghcb, svm->ghcb_sw_exit_info_2);
+
+	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, ghcb);
+
+	svm_unmap_ghcb(svm, &map);
+
+	return true;
 }
 
-static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
+static void sev_es_sync_from_ghcb(struct vcpu_svm *svm, struct ghcb *ghcb)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
-	struct ghcb *ghcb = svm->ghcb;
 	u64 exit_code;
 
 	/*
@@ -2585,13 +2630,18 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
 
-static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
+static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 {
-	struct kvm_vcpu *vcpu;
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_host_map map;
 	struct ghcb *ghcb;
-	u64 exit_code = 0;
 
-	ghcb = svm->ghcb;
+	if (svm_map_ghcb(svm, &map))
+		return -EFAULT;
+
+	ghcb = map.hva;
+
+	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
 
 	/* Only GHCB Usage code 0 is supported */
 	if (ghcb->ghcb_usage)
@@ -2601,7 +2651,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	 * Retrieve the exit code now even though is may not be marked valid
 	 * as it could help with debugging.
 	 */
-	exit_code = ghcb_get_sw_exit_code(ghcb);
+	*exit_code = ghcb_get_sw_exit_code(ghcb);
 
 	if (!ghcb_sw_exit_code_is_valid(ghcb) ||
 	    !ghcb_sw_exit_info_1_is_valid(ghcb) ||
@@ -2685,6 +2735,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 		goto vmgexit_err;
 	}
 
+	sev_es_sync_from_ghcb(svm, ghcb);
+
+	svm_unmap_ghcb(svm, &map);
 	return 0;
 
 vmgexit_err:
@@ -2695,16 +2748,17 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 			    ghcb->ghcb_usage);
 	} else {
 		vcpu_unimpl(vcpu, "vmgexit: exit reason %#llx is not valid\n",
-			    exit_code);
+			    *exit_code);
 		dump_ghcb(svm);
 	}
 
 	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
 	vcpu->run->internal.ndata = 2;
-	vcpu->run->internal.data[0] = exit_code;
+	vcpu->run->internal.data[0] = *exit_code;
 	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 
+	svm_unmap_ghcb(svm, &map);
 	return -EINVAL;
 }
 
@@ -2713,23 +2767,20 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	/* Clear any indication that the vCPU is in a type of AP Reset Hold */
 	svm->ap_reset_hold_type = AP_RESET_HOLD_NONE;
 
-	if (!svm->ghcb)
+	if (!svm->ghcb_in_use)
 		return;
 
 	 /* Sync the scratch buffer area. */
 	if (svm->ghcb_sa_sync) {
 		kvm_write_guest(svm->vcpu.kvm,
-				ghcb_get_sw_scratch(svm->ghcb),
+				svm->ghcb_sa_gpa,
 				svm->ghcb_sa, svm->ghcb_sa_len);
 		svm->ghcb_sa_sync = false;
 	}
 
-	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
-
 	sev_es_sync_to_ghcb(svm);
 
-	kvm_vcpu_unmap(&svm->vcpu, &svm->ghcb_map, true);
-	svm->ghcb = NULL;
+	svm->ghcb_in_use = false;
 }
 
 void pre_sev_run(struct vcpu_svm *svm, int cpu)
@@ -2961,7 +3012,6 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 ghcb_gpa, exit_code;
-	struct ghcb *ghcb;
 	int ret;
 
 	/* Validate the GHCB */
@@ -2974,27 +3024,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
-	if (kvm_vcpu_map(vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
-		/* Unable to map GHCB from guest */
-		vcpu_unimpl(vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
-			    ghcb_gpa);
-		return -EINVAL;
-	}
-
-	svm->ghcb = svm->ghcb_map.hva;
-	ghcb = svm->ghcb_map.hva;
-
-	trace_kvm_vmgexit_enter(vcpu->vcpu_id, ghcb);
-
-	exit_code = ghcb_get_sw_exit_code(ghcb);
-
-	ret = sev_es_validate_vmgexit(svm);
+	ret = sev_es_validate_vmgexit(svm, &exit_code);
 	if (ret)
 		return ret;
 
-	sev_es_sync_from_ghcb(svm);
-	ghcb_set_sw_exit_info_1(ghcb, 0);
-	ghcb_set_sw_exit_info_2(ghcb, 0);
+	svm->ghcb_in_use = true;
+
+	svm_set_ghcb_sw_exit_info_1(vcpu, 0);
+	svm_set_ghcb_sw_exit_info_2(vcpu, 0);
 
 	ret = -EINVAL;
 	switch (exit_code) {
@@ -3033,23 +3070,23 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 			break;
 		case 1:
 			/* Get AP jump table address */
-			ghcb_set_sw_exit_info_2(ghcb, sev->ap_jump_table);
+			svm_set_ghcb_sw_exit_info_2(vcpu, sev->ap_jump_table);
 			break;
 		default:
 			pr_err("svm: vmgexit: unsupported AP jump table request - exit_info_1=%#llx\n",
 			       control->exit_info_1);
-			ghcb_set_sw_exit_info_1(ghcb, 1);
-			ghcb_set_sw_exit_info_2(ghcb,
-						X86_TRAP_UD |
-						SVM_EVTINJ_TYPE_EXEPT |
-						SVM_EVTINJ_VALID);
+			svm_set_ghcb_sw_exit_info_1(vcpu, 1);
+			svm_set_ghcb_sw_exit_info_2(vcpu,
+						    X86_TRAP_UD |
+						    SVM_EVTINJ_TYPE_EXEPT |
+						    SVM_EVTINJ_VALID);
 		}
 
 		ret = 1;
 		break;
 	}
 	case SVM_VMGEXIT_HV_FEATURES: {
-		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+		svm_set_ghcb_sw_exit_info_2(vcpu, GHCB_HV_FT_SUPPORTED);
 
 		ret = 1;
 		break;
@@ -3171,7 +3208,7 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 		 * Return from an AP Reset Hold VMGEXIT, where the guest will
 		 * set the CS and RIP. Set SW_EXIT_INFO_2 to a non-zero value.
 		 */
-		ghcb_set_sw_exit_info_2(svm->ghcb, 1);
+		svm_set_ghcb_sw_exit_info_2(vcpu, 1);
 		break;
 	case AP_RESET_HOLD_MSR_PROTO:
 		/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 0c8510ad63f1..5f73f21a37a1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2786,14 +2786,14 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 static int svm_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb))
+	if (!err || !sev_es_guest(vcpu->kvm) || WARN_ON_ONCE(!svm->ghcb_in_use))
 		return kvm_complete_insn_gp(vcpu, err);
 
-	ghcb_set_sw_exit_info_1(svm->ghcb, 1);
-	ghcb_set_sw_exit_info_2(svm->ghcb,
-				X86_TRAP_GP |
-				SVM_EVTINJ_TYPE_EXEPT |
-				SVM_EVTINJ_VALID);
+	svm_set_ghcb_sw_exit_info_1(vcpu, 1);
+	svm_set_ghcb_sw_exit_info_2(vcpu,
+				    X86_TRAP_GP |
+				    SVM_EVTINJ_TYPE_EXEPT |
+				    SVM_EVTINJ_VALID);
 	return 1;
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 85c852bb548a..22c01d958898 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -191,8 +191,7 @@ struct vcpu_svm {
 
 	/* SEV-ES support */
 	struct sev_es_save_area *vmsa;
-	struct ghcb *ghcb;
-	struct kvm_host_map ghcb_map;
+	bool ghcb_in_use;
 	bool received_first_sipi;
 	unsigned int ap_reset_hold_type;
 
@@ -204,6 +203,13 @@ struct vcpu_svm {
 	bool ghcb_sa_sync;
 
 	bool guest_state_loaded;
+
+	/*
+	 * SEV-ES support to hold the sw_exit_info return values to be
+	 * sync'ed to the GHCB when mapped.
+	 */
+	u64 ghcb_sw_exit_info_1;
+	u64 ghcb_sw_exit_info_2;
 };
 
 struct svm_cpu_data {
@@ -503,6 +509,20 @@ void nested_sync_control_from_vmcb02(struct vcpu_svm *svm);
 void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm);
 void svm_switch_vmcb(struct vcpu_svm *svm, struct kvm_vmcb_info *target_vmcb);
 
+static inline void svm_set_ghcb_sw_exit_info_1(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->ghcb_sw_exit_info_1 = val;
+}
+
+static inline void svm_set_ghcb_sw_exit_info_2(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	svm->ghcb_sw_exit_info_2 = val;
+}
+
 extern struct kvm_x86_nested_ops svm_nested_ops;
 
 /* avic.c */
-- 
2.17.1

