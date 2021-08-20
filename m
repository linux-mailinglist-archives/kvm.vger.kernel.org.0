Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453163F30ED
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbhHTQFZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:05:25 -0400
Received: from mail-co1nam11on2049.outbound.protection.outlook.com ([40.107.220.49]:48673
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235950AbhHTQDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:03:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgzhvb4ad6SfD84S8+DidqMk2d97JqJ7f14CEmAi5V9D0twVNPiGvye4506swYhQ2rXfpaJvdsLDd9wJxg1ZRkTXUbHRPnkW57sbHAfvwzBexEhMuUW3I96cNJkFNcQY6Ir10ct8tw0aDsx7KXmaDD1mk2wT7c066A4iGX96LLoHikmxwmVN5o6stM0KSWO4tJWTaXAHV7yWRZosFzmxV1ZQZaHnQ4tLFHUTsbRc/2UKrTpvYkf/kz7lX2WnFCw+VkDFWviSWxpSuzb+HnjpaxFoNedNWMQDGNUkAPCOihpCzf/lb2K0vjGv1Bk5GUbFwb0PtwMSw1EjsNX0hvo9PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SskhzyDvqfaIYDs2SMy1p2yCg2F/EtAhJWXlasHkM5E=;
 b=ALzdBaX4viNV4LGZf1S6j9OsvQz1aKXHl5bWMltLvzmJuOivMtvEuV4kNL4nqzSKOG2wYUxTVOfzONvzt0dXvCDWvxZluYdmgHSMjoM8/KlnRqExj1rH27+s6hLmSw5psqs3JcnELmBjhnuMFhfFXH59qICJGtD6l7s2KAn9scr2CFgHUQiYe982I+wI7PTRTCcqiJP+I+UM96CMIq5lz9K6o5tfFv5d88wP5ucn3rN6GVq1OAZI4pS03kCalr5GtL4zmeMpW6G9MtnLwqz+jJS5vvHEZ7e2rynWL3V6MaRRoML2vJFkBhQRwUhE0CwNr5R6B46tSVI8cqvGMr3hjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SskhzyDvqfaIYDs2SMy1p2yCg2F/EtAhJWXlasHkM5E=;
 b=3HD8TXMHIbyZZvjvunI0nMwjSVPVQqhLIni6HIUxM80KyD0Dfk+8bk93cNX3rGo/uhbSgkLgJHdaU3dMT86Y2OX9XwIudD0ZoLALyexCcSpzl/K8GkLYRc8QiX1vCNGCzFR7XN43gpl6E8bPuMA1rLCo1mgEzoHpK/CFOXdzpjE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4574.namprd12.prod.outlook.com (2603:10b6:806:94::22) with
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
Subject: [PATCH Part2 v5 34/45] KVM: SVM: Do not use long-lived GHCB map while setting scratch area
Date:   Fri, 20 Aug 2021 10:59:07 -0500
Message-Id: <20210820155918.7518-35-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e04094e7-dc0d-4c42-45d8-08d963f3a6d3
X-MS-TrafficTypeDiagnostic: SA0PR12MB4574:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4574B525515FD295B57412E9E5C19@SA0PR12MB4574.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HAK3Wh9CyLFkNg2OcLyp92LszmoVnaZDYR6yIoLt3Wjjm8nJ9sUuCn1R9DuR7O5KUF/WjRe04IHvRd7/JJMNTVTeQOXKohvzCuFHjmits0bIe8/aGH9DsjvaPk5ZD2+OWuDMzdzfgiXjc+pD4k+czTZEBxPSmFkRxgLB9lNRNFeL9k5y89nFTm1Vo7FWB3ZehgTUlDG5s/TIjT3bKWaYhPGKebe/UCarMT2LPQaSK09tdm9WwKU7kampmU8mAsYQOAnL/R9A4ySHopRHv1PQjj6KHMEkhWq2GU0V+etPuI7QzTsFWPP/4c76nd4IguNeYUBJi7jOl3tSVE/XJC0duNe9Cl2oEyzEii5wp8qVhdkzgGNI7AYjeUacrABRwkmn3kxk2hx0oVQUHwVNcT18IPt1SzbVffPEqgnmPb4d11bndNtE+fqKjkClB3VlKjt0+9t8GhMtOlH+oCnbBrJlYcLhJ531x4aA3NidcfYwo2ZkQ9OzjIQDJpaK3o197GAhbk3rBaoNfjXI9eqMvkD/xQ5tvM40KVq6cD1zaC/QavKS58UxxqiQCjvQzI6oocCPrzM95BYx7FRe8faBmDKmjlwu4/0bX/osGfIXEXb7y4ivodRPklM+Ozf0Zz50bd2U4LMNhkOKHAyznqk1SVzWb0JRrAEsGi0oUa603Up+qE16fhVGijxeUCE0sBGMpwwMFpASmcYysl7CP1fGBFd42g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(38100700002)(316002)(38350700002)(5660300002)(26005)(44832011)(4326008)(66556008)(54906003)(7416002)(7406005)(8676002)(66476007)(86362001)(66946007)(6666004)(2616005)(956004)(8936002)(2906002)(36756003)(83380400001)(478600001)(6486002)(7696005)(52116002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GyfbZWUdMaCD1XIxGLxOLk1dgU12r4eux1dhKe6r1cfWbH7nfR2NeBS4DNZV?=
 =?us-ascii?Q?nIUZ3xP3uh2i0t1VaqLYqKtd++TR3ondBnRPAdgE/MxCIMuI3/u0mQxfywqn?=
 =?us-ascii?Q?GdTTP8Ixw5vrBHQPhYEhMZYQSWgA354v24snDUjCb3dioWaJ2ASYmZtPSnyi?=
 =?us-ascii?Q?QNTzkX9+JouYdtvjdvRGZ5Pdgod/SrMTK0K9lZG95LOfNvZmdgFJpULt0P4v?=
 =?us-ascii?Q?fiR0nMmuVQc8ak9v/HAdPMgG+ANQS8e5TSg7XDtmPMwkYUvQqqNy/vUuSiEr?=
 =?us-ascii?Q?+pH52uEFkkLgFh5jmmUCxl5fnLClR7cLOhY07HdgjKyOlkMUW5HLOnvi7sRw?=
 =?us-ascii?Q?JGWFhI0nO0OqBldMV+VwlzNKq8SbgPIL90dDboRAxbv94Zw6CsXyIr6nJeCO?=
 =?us-ascii?Q?LQxQGFgjNjbzDi17QQgwQ+gM/6dBM7LUbgfSGD1anONrPbUdIZ5spOyZblds?=
 =?us-ascii?Q?Ck34JvpYb2+hlcT9XsiKouUjzdXTL9PCMXiO3T33shhg4ZG2tzz7shzrPF6K?=
 =?us-ascii?Q?JQVx32Pze5uQdcozr8ULhZYc8qbLEyuFq0bwhOUQwhzat9dE0itT7kGpjUhk?=
 =?us-ascii?Q?ut6WuinVuqNwjbhI1bd62lAgGxGglJTdejjWAx9o0AnwTfoXKTUz7nC2OP39?=
 =?us-ascii?Q?s/t/Mf7fEB5lexwinfG8q3nTy71rX/pS0kXn89UCaNAUkcGAorO8JRreFjlN?=
 =?us-ascii?Q?OppU3pwmI5XcguMJorNFooFzF/rnrKVt4rc9WUw7dhHoq6z8enuzra6Kptrp?=
 =?us-ascii?Q?rm1vttrZB9GilNUVcD2SRYmN3RyOiWKJ4Caa4P58H7bVvRJHF5XNLFSO89ie?=
 =?us-ascii?Q?3S3TMym4Km7m17Wq4kXhnOoMmrLDFg+CvP7pzXn8A97zhR0HgcKiMZuitJ9Q?=
 =?us-ascii?Q?tpLctuCI/e0ByY5kbdPmqrCzmah7TeewOQv73AuljtBqXXYO1Klih5RPrsla?=
 =?us-ascii?Q?zqsnX7nLft+EVXpD9giGRgnHw3gZc0PaNL+6BF5XdfSP6wgQ+ww/BeBzrcfQ?=
 =?us-ascii?Q?heb5xEiZ36FiS6gvsA9z80LuT2ZbHJ/EbFVs7thRB4S6eTTCWKW5YLCiuHGy?=
 =?us-ascii?Q?tI+YoeMhag6kXbvVD8PZJpRwr+f4JqO1LE1snqDxG+wd3lPTmkLM/vgcaYZo?=
 =?us-ascii?Q?Tjp8YDwvBCk/CBC6e9l3dNlr6eF0hOheanlkovZyPb/4KKR7vFSyh81eFe5V?=
 =?us-ascii?Q?9WcZAWml2A0arbwaDRbaomeqj6SWulE5dxLbOcOAvw9f4Fz/n+mboUY1mBdL?=
 =?us-ascii?Q?05aryUg0jzc6vEX2Om8hrpLYcXhUoqD328/jrmCqtlrRx6ZH886EEmxu0vyV?=
 =?us-ascii?Q?YLMNlt50Jv/GEPVSdyJyDMuH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04094e7-dc0d-4c42-45d8-08d963f3a6d3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:37.9111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rYSjqFPtjRaWkddVj1OoeIavjoj4JGQ05QO22ifMEnIDJJfYnpkgLdikh/1zXMUTGG8tIbAK6r2gN6HOgY/Hrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4574
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The setup_vmgexit_scratch() function may rely on a long-lived GHCB
mapping if the GHCB shared buffer area was used for the scratch area.
In preparation for eliminating the long-lived GHCB mapping, always
allocate a buffer for the scratch area so it can be accessed without
the GHCB mapping.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 70 +++++++++++++++++++-----------------------
 arch/x86/kvm/svm/svm.h |  3 +-
 2 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2ad186d7e7b0..7dfb68e06334 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2490,8 +2490,7 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	__free_page(virt_to_page(svm->vmsa));
 
 skip_vmsa_free:
-	if (svm->ghcb_sa_free)
-		kfree(svm->ghcb_sa);
+	kfree(svm->ghcb_sa);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -2579,6 +2578,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
 	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
 
+	/* Copy the GHCB scratch area GPA */
+	svm->ghcb_sa_gpa = ghcb_get_sw_scratch(ghcb);
+
 	/* Clear the valid entries fields */
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
 }
@@ -2714,22 +2716,12 @@ void sev_es_unmap_ghcb(struct vcpu_svm *svm)
 	if (!svm->ghcb)
 		return;
 
-	if (svm->ghcb_sa_free) {
-		/*
-		 * The scratch area lives outside the GHCB, so there is a
-		 * buffer that, depending on the operation performed, may
-		 * need to be synced, then freed.
-		 */
-		if (svm->ghcb_sa_sync) {
-			kvm_write_guest(svm->vcpu.kvm,
-					ghcb_get_sw_scratch(svm->ghcb),
-					svm->ghcb_sa, svm->ghcb_sa_len);
-			svm->ghcb_sa_sync = false;
-		}
-
-		kfree(svm->ghcb_sa);
-		svm->ghcb_sa = NULL;
-		svm->ghcb_sa_free = false;
+	 /* Sync the scratch buffer area. */
+	if (svm->ghcb_sa_sync) {
+		kvm_write_guest(svm->vcpu.kvm,
+				ghcb_get_sw_scratch(svm->ghcb),
+				svm->ghcb_sa, svm->ghcb_sa_len);
+		svm->ghcb_sa_sync = false;
 	}
 
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, svm->ghcb);
@@ -2767,12 +2759,11 @@ void pre_sev_run(struct vcpu_svm *svm, int cpu)
 static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
-	struct ghcb *ghcb = svm->ghcb;
 	u64 ghcb_scratch_beg, ghcb_scratch_end;
 	u64 scratch_gpa_beg, scratch_gpa_end;
 	void *scratch_va;
 
-	scratch_gpa_beg = ghcb_get_sw_scratch(ghcb);
+	scratch_gpa_beg = svm->ghcb_sa_gpa;
 	if (!scratch_gpa_beg) {
 		pr_err("vmgexit: scratch gpa not provided\n");
 		return false;
@@ -2802,9 +2793,6 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       scratch_gpa_beg, scratch_gpa_end);
 			return false;
 		}
-
-		scratch_va = (void *)svm->ghcb;
-		scratch_va += (scratch_gpa_beg - control->ghcb_gpa);
 	} else {
 		/*
 		 * The guest memory must be read into a kernel buffer, so
@@ -2815,29 +2803,35 @@ static bool setup_vmgexit_scratch(struct vcpu_svm *svm, bool sync, u64 len)
 			       len, GHCB_SCRATCH_AREA_LIMIT);
 			return false;
 		}
+	}
+
+	if (svm->ghcb_sa_alloc_len < len) {
 		scratch_va = kzalloc(len, GFP_KERNEL_ACCOUNT);
 		if (!scratch_va)
 			return false;
 
-		if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, scratch_va, len)) {
-			/* Unable to copy scratch area from guest */
-			pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
-
-			kfree(scratch_va);
-			return false;
-		}
-
 		/*
-		 * The scratch area is outside the GHCB. The operation will
-		 * dictate whether the buffer needs to be synced before running
-		 * the vCPU next time (i.e. a read was requested so the data
-		 * must be written back to the guest memory).
+		 * Free the old scratch area and switch to using newly
+		 * allocated.
 		 */
-		svm->ghcb_sa_sync = sync;
-		svm->ghcb_sa_free = true;
+		kfree(svm->ghcb_sa);
+
+		svm->ghcb_sa_alloc_len = len;
+		svm->ghcb_sa = scratch_va;
 	}
 
-	svm->ghcb_sa = scratch_va;
+	if (kvm_read_guest(svm->vcpu.kvm, scratch_gpa_beg, svm->ghcb_sa, len)) {
+		/* Unable to copy scratch area from guest */
+		pr_err("vmgexit: kvm_read_guest for scratch area failed\n");
+		return false;
+	}
+
+	/*
+	 * The operation will dictate whether the buffer needs to be synced
+	 * before running the vCPU next time (i.e. a read was requested so
+	 * the data must be written back to the guest memory).
+	 */
+	svm->ghcb_sa_sync = sync;
 	svm->ghcb_sa_len = len;
 
 	return true;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 27c0c7b265b8..85c852bb548a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -199,8 +199,9 @@ struct vcpu_svm {
 	/* SEV-ES scratch area support */
 	void *ghcb_sa;
 	u64 ghcb_sa_len;
+	u64 ghcb_sa_gpa;
+	u32 ghcb_sa_alloc_len;
 	bool ghcb_sa_sync;
-	bool ghcb_sa_free;
 
 	bool guest_state_loaded;
 };
-- 
2.17.1

