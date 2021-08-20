Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8F23F30DF
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbhHTQE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:56 -0400
Received: from mail-bn8nam12on2059.outbound.protection.outlook.com ([40.107.237.59]:3905
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236436AbhHTQCv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC2NnvQUfzdzuvdpvW3AWvskmIon5SBMXg7vQTOy6vvenG0jEmRU+IyIjpvNqA3hCfGFcC17NkR3SAVCXaDuALSOxI6p1A6xEoScQA6h+yWXheuwq8/pyAFaWfs98BfXP16g9dKj5VDmKIrYtoStzdQMKaSOHqJ/QaVLV2rIaR2+vEWETLpX0YPFSYtqW+6YlbkAhEu/gJ1bke/HQ9/g3IuotOJWzoBd8J72K7ScJDnzaxwcQLUnmA4dd8h5OoUaFnkew8Ba7UufuPdgHHZFwFPdHxyQ86arocmfMgrSGX4M5rwgUeMghwvfthTmMrD3sXsNGqa1I52XNsy04fNTIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwdgEaPmKyxwoGNdGmt5BLL68r7SDTmY/rgZpxhckmE=;
 b=etzkRr09vtAnsLnE7KJ0ZBX16YZ697xYKekrrj104ESorfhHJ81sXWoMztVte/aVPJZ/+xQ0VOIcn7EyA1oXieqc285x8KAYMSupkUOZIpsKyhEYeDI3li//rZPKAS0fZVSI+95OHapDqXShHM1Inj+HAtoQiS41Hyo9K+VBYYnwnwiGreWETxtGuSGOVkwE32/nQIpZgfS+8teIwtgC9Hc7NWwZkcpPR/xWQ2gtfy13hjyywwSQmq/qEVLfDI+yST/gujNbuhuuzn5quNeQSmY6a8f4It4qzgm3BHymDptkVWwTUkAwdzPkSuNgkDOnHidzLOdzsRXL4KhBgEWMzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwdgEaPmKyxwoGNdGmt5BLL68r7SDTmY/rgZpxhckmE=;
 b=vwOz6unwEXY0PXoRsJbUWjILi8W4teSm1Kr+zXKKe3xTU57QnkHJBMk2MUk/dD+hraM3ZGNWpzDYVCdUFe2wh2MSupsMPiJZodahvUqNk0N3V0GYEPpUF9xQWPIoN3ZAq6p2ZbVF+EA+ds6IlQZ8MXzQEMVBWM8HX358aDY0ev4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4509.namprd12.prod.outlook.com (2603:10b6:806:9e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:01:08 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:01:08 +0000
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
Subject: [PATCH Part2 v5 39/45] KVM: SVM: Introduce ops for the post gfn map and unmap
Date:   Fri, 20 Aug 2021 10:59:12 -0500
Message-Id: <20210820155918.7518-40-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd062faa-06fd-48f7-5340-08d963f3aa69
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509B29D76574BC6529D968DE5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ly00cJWLaWxy2BCRy7RUuzBo8TQXhVINA386Mlr2v7U5rTrx8k26n3kvwpTLXcePtSaZDLOTIF+q/MD+zxgWeM1cn+iI6GzSWAUpmqCcOfuW/XzO4DqQo+orP341mBFZTsT39YDDY5eHmQLb0sym1NSJu+Py9GMjJNFimLHE+25vj4uMvRyRmhN0WXOcd6LxZwT71G5A86hn0Oalxy90k2zXhHKdNtqBWduMYmmzsytEpBV9NQvXLm+Em1RbbUw30xZQT7WivZJEUQS+mmKkhpRgdmugYkVZpK6r4/MLDEncI1M4fHVRs4ytWdvRTHEDT+iYEh5BLHJ/uurvwpdnVKyoe2rYGoD+a529TkFs4iSvwAGy3iyFesEgn2yXSG41b8d15+zNw2DHzIhBz6y+nxhTdnwjLclPONgNv3b3bAZrGcAqTN60+sTqBI6vNxXy70ZJqUtUNOFklJmFx6OOdsVH/WvCfPJv8s4ZiV52b73bMjYHkKQc/LZKp76ZLidiWK6/esC2BGTXpdlLIO3MuSpAeSfQLCQOIuQmy0TnA3sUs39ejBeSRnpDwl+/UA6wvdnMwyzqL3WEwb3jPdw+VE8eHupw5ZHY/gjEDO3hIV2wuNafE3/QKIRukRT4BkXfQJWbGM4YrQ2tHhhIt8Ly+cjp6VKqeQqoCL8IM8okkMNNaj4XKRAkJn6OgYyMxJwTjtjbCbXcDH4xZ84GYHAgVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(30864003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?woOLjS+XF8yNGlLgkSZB+5xoCW42xrqvfgJaOVMQmGAFKd0c3HBHXZg4MAzG?=
 =?us-ascii?Q?aGUDAAexIkWgv7QJcGmVNcrBRuvx0qeqAlwOg3gYGNrSwofeQZrHuirDJUnr?=
 =?us-ascii?Q?eJhICm80tLvK/QXQAqMvmcYd/KdHwslxMQ9+eSETJuY4H/v/LEtBQY16c/Aw?=
 =?us-ascii?Q?63dBW9RCdDB0sQRNWL3+61vcVYWn90XM7oCRfLAxmoMGOapdqBE2OBVmB4gV?=
 =?us-ascii?Q?WJKI2/UdoTD3aDx1T9lADWROSp5YXueMK/ZEIrfLK05OckhGbmc4dlRcGm53?=
 =?us-ascii?Q?n1MIvAdR6DPHT4FMKU9Fq4+yGSQfk2mKem1gN83nwRhPso8uI/l5UjVVrV1S?=
 =?us-ascii?Q?+8jJgv4tJ+/wOeCjNsSKA+OQao8Y9hndLp3mUWx3Td2PsUgk0ojtUrq8RfHx?=
 =?us-ascii?Q?3c9DL0OUgepKrlruNsVqP9RTPjOndFCnBT7+TCXFV+EIOWpRACTTwyuGIPpM?=
 =?us-ascii?Q?oIn0Q8Ar86d7nx69SkeDK2zwYra8nBlzetvNBJV1cLdtgVWg5ACaUbIzUobP?=
 =?us-ascii?Q?Cc6AsO0PZJ1pFyvKI08auS/KJYktwGMNzj1idFNd/EVDxb0hYK7n3vLA2TT4?=
 =?us-ascii?Q?f5qSI/ht17Z12yuFkEhACHr+Yz2izAFj5mEEyKQ0bKP4RtGeLWYBus5ej+oI?=
 =?us-ascii?Q?8vKdijNKgAbQd5vNuitgpKUzMnhUHSVIU0g42JOlgKQOZB9KrDeb50OH68RH?=
 =?us-ascii?Q?42h+J41e5tdX6XaLOd3eC8IQLOt/JFecct1BCELGcFXY3qJ/AAz5FUiReSGW?=
 =?us-ascii?Q?is8V2G8pbSzoiLaogJpO17YYtD+wxoLPydaIoEUnZXlsuzZuB7JMLsnGwS4f?=
 =?us-ascii?Q?Vq5+421lmQUrOJxBMrXF7sISfZoAqjIG7aWs3oVEGb6+47umku/EsxDxB4n7?=
 =?us-ascii?Q?U+HarBPsyd89S4CI5MlT3R0rjoNHKeS9B2aTaAI+SW09kFBDxBDiPNMZh3JX?=
 =?us-ascii?Q?zxop5583vtTF4VwGwlIuseo1Q+WK1/qZYV6kHtsqLyDKthaTg9tFnEwZ8VTk?=
 =?us-ascii?Q?/lZVcnj4sgUWqJzqH0UefibAoV9c55LbWwqeelFHNDccC8JeLhXnIbN13PY1?=
 =?us-ascii?Q?/wiCb5dBOPiiY/AamBxcVx34kx2Bq2x1yjKRrvsTRRDPQyPL9JZTskZ4v0Z+?=
 =?us-ascii?Q?wUlx1l95u18kNj70fayQel2ofhdB/hA6AMbIr1ZJ92/4eXh5+EViJLGSU0fy?=
 =?us-ascii?Q?VXDv6iAV6nQeRyOkcqyjNAHQmZgrbDURGsWSYklb8OmLKeeAkPRyfmT/Yx1U?=
 =?us-ascii?Q?vB5IVeoTmH+SKWWH2p6V09VnyJHqzoyCrJhUi7FXY/RFXsUkWORqsOEolkE/?=
 =?us-ascii?Q?vdxs84W5IQK1oU1hFc+VKTwy?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd062faa-06fd-48f7-5340-08d963f3aa69
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:43.9216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wRX/wIHf4rTRznryyLKto9ardUDI2nV53f1dFJ/Xfit32EC42OjhiGn4Q483d67+TCDofbQb7yiryKq/jXMAbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When SEV-SNP is enabled in the guest VM, the guest memory pages can
either be a private or shared. A write from the hypervisor goes through
the RMP checks. If hardware sees that hypervisor is attempting to write
to a guest private page, then it triggers an RMP violation #PF.

To avoid the RMP violation, add post_{map,unmap}_gfn() ops that can be
used to verify that its safe to map a given guest page. Use the SRCU to
protect against the page state change for existing mapped pages.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 +
 arch/x86/include/asm/kvm_host.h    |  4 ++
 arch/x86/kvm/svm/sev.c             | 69 +++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c             |  4 ++
 arch/x86/kvm/svm/svm.h             |  8 +++
 arch/x86/kvm/x86.c                 | 78 +++++++++++++++++++++++++++---
 6 files changed, 146 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 371756c7f8f4..c09bd40e0160 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -124,6 +124,8 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP_NULL(complete_emulated_msr)
 KVM_X86_OP(alloc_apic_backing_page)
 KVM_X86_OP_NULL(rmp_page_level_adjust)
+KVM_X86_OP(post_map_gfn)
+KVM_X86_OP(post_unmap_gfn)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_NULL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6e764458f3e..5ac1ff097e8c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1463,7 +1463,11 @@ struct kvm_x86_ops {
 	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
 
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
+
 	void (*rmp_page_level_adjust)(struct kvm *kvm, kvm_pfn_t pfn, int *level);
+
+	int (*post_map_gfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token);
+	void (*post_unmap_gfn)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0de85ed63e9b..65b578463271 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -336,6 +336,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		if (ret)
 			goto e_free;
 
+		init_srcu_struct(&sev->psc_srcu);
 		ret = sev_snp_init(&argp->error);
 	} else {
 		ret = sev_platform_init(&argp->error);
@@ -2293,6 +2294,7 @@ void sev_vm_destroy(struct kvm *kvm)
 			WARN_ONCE(1, "Failed to free SNP guest context, leaking asid!\n");
 			return;
 		}
+		cleanup_srcu_struct(&sev->psc_srcu);
 	} else {
 		sev_unbind_asid(kvm, sev->handle);
 	}
@@ -2494,23 +2496,32 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
 	kfree(svm->ghcb_sa);
 }
 
-static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
+static inline int svm_map_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map, int *token)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	u64 gfn = gpa_to_gfn(control->ghcb_gpa);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 
-	if (kvm_vcpu_map(&svm->vcpu, gfn, map)) {
+	if (kvm_vcpu_map(vcpu, gfn, map)) {
 		/* Unable to map GHCB from guest */
 		pr_err("error mapping GHCB GFN [%#llx] from guest\n", gfn);
 		return -EFAULT;
 	}
 
+	if (sev_post_map_gfn(vcpu->kvm, map->gfn, map->pfn, token)) {
+		kvm_vcpu_unmap(vcpu, map, false);
+		return -EBUSY;
+	}
+
 	return 0;
 }
 
-static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map)
+static inline void svm_unmap_ghcb(struct vcpu_svm *svm, struct kvm_host_map *map, int token)
 {
-	kvm_vcpu_unmap(&svm->vcpu, map, true);
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	kvm_vcpu_unmap(vcpu, map, true);
+	sev_post_unmap_gfn(vcpu->kvm, map->gfn, map->pfn, token);
 }
 
 static void dump_ghcb(struct vcpu_svm *svm)
@@ -2518,8 +2529,9 @@ static void dump_ghcb(struct vcpu_svm *svm)
 	struct kvm_host_map map;
 	unsigned int nbits;
 	struct ghcb *ghcb;
+	int token;
 
-	if (svm_map_ghcb(svm, &map))
+	if (svm_map_ghcb(svm, &map, &token))
 		return;
 
 	ghcb = map.hva;
@@ -2544,7 +2556,7 @@ static void dump_ghcb(struct vcpu_svm *svm)
 	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
 
 e_unmap:
-	svm_unmap_ghcb(svm, &map);
+	svm_unmap_ghcb(svm, &map, token);
 }
 
 static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
@@ -2552,8 +2564,9 @@ static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_host_map map;
 	struct ghcb *ghcb;
+	int token;
 
-	if (svm_map_ghcb(svm, &map))
+	if (svm_map_ghcb(svm, &map, &token))
 		return false;
 
 	ghcb = map.hva;
@@ -2579,7 +2592,7 @@ static bool sev_es_sync_to_ghcb(struct vcpu_svm *svm)
 
 	trace_kvm_vmgexit_exit(svm->vcpu.vcpu_id, ghcb);
 
-	svm_unmap_ghcb(svm, &map);
+	svm_unmap_ghcb(svm, &map, token);
 
 	return true;
 }
@@ -2636,8 +2649,9 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_host_map map;
 	struct ghcb *ghcb;
+	int token;
 
-	if (svm_map_ghcb(svm, &map))
+	if (svm_map_ghcb(svm, &map, &token))
 		return -EFAULT;
 
 	ghcb = map.hva;
@@ -2739,7 +2753,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 
 	sev_es_sync_from_ghcb(svm, ghcb);
 
-	svm_unmap_ghcb(svm, &map);
+	svm_unmap_ghcb(svm, &map, token);
 	return 0;
 
 vmgexit_err:
@@ -2760,7 +2774,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm, u64 *exit_code)
 	vcpu->run->internal.data[0] = *exit_code;
 	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
 
-	svm_unmap_ghcb(svm, &map);
+	svm_unmap_ghcb(svm, &map, token);
 	return -EINVAL;
 }
 
@@ -3036,6 +3050,9 @@ static int __snp_handle_page_state_change(struct kvm_vcpu *vcpu, enum psc_op op,
 				return PSC_UNDEF_ERR;
 		}
 
+		/* Wait for all the existing mapped gfn to unmap */
+		synchronize_srcu_expedited(&sev->psc_srcu);
+
 		write_lock(&kvm->mmu_lock);
 
 		rc = kvm_mmu_get_tdp_walk(vcpu, gpa, &pfn, &npt_level);
@@ -3604,3 +3621,33 @@ void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level)
 	/* Adjust the level to keep the NPT and RMP in sync */
 	*level = min_t(size_t, *level, rmp_level);
 }
+
+int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	int level;
+
+	if (!sev_snp_guest(kvm))
+		return 0;
+
+	*token = srcu_read_lock(&sev->psc_srcu);
+
+	/* If pfn is not added as private then fail */
+	if (snp_lookup_rmpentry(pfn, &level) == 1) {
+		srcu_read_unlock(&sev->psc_srcu, *token);
+		pr_err_ratelimited("failed to map private gfn 0x%llx pfn 0x%llx\n", gfn, pfn);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+
+	if (!sev_snp_guest(kvm))
+		return;
+
+	srcu_read_unlock(&sev->psc_srcu, token);
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f73f21a37a1..3784d389247b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4679,7 +4679,11 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
 
 	.alloc_apic_backing_page = svm_alloc_apic_backing_page,
+
 	.rmp_page_level_adjust = sev_rmp_page_level_adjust,
+
+	.post_map_gfn = sev_post_map_gfn,
+	.post_unmap_gfn = sev_post_unmap_gfn,
 };
 
 static struct kvm_x86_init_ops svm_init_ops __initdata = {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index d10f7166b39d..ff91184f9b4a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -76,16 +76,22 @@ struct kvm_sev_info {
 	bool active;		/* SEV enabled guest */
 	bool es_active;		/* SEV-ES enabled guest */
 	bool snp_active;	/* SEV-SNP enabled guest */
+
 	unsigned int asid;	/* ASID used for this guest */
 	unsigned int handle;	/* SEV firmware handle */
 	int fd;			/* SEV device fd */
+
 	unsigned long pages_locked; /* Number of pages locked */
 	struct list_head regions_list;  /* List of registered regions */
+
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
+
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
+
 	u64 snp_init_flags;
 	void *snp_context;      /* SNP guest context page */
+	struct srcu_struct psc_srcu;
 };
 
 struct kvm_svm {
@@ -618,6 +624,8 @@ void sev_es_prepare_guest_switch(struct vcpu_svm *svm, unsigned int cpu);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 struct page *snp_safe_alloc_page(struct kvm_vcpu *vcpu);
 void sev_rmp_page_level_adjust(struct kvm *kvm, kvm_pfn_t pfn, int *level);
+int sev_post_map_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int *token);
+void sev_post_unmap_gfn(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int token);
 
 /* vmenter.S */
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index afcdc75a99f2..bf4389ffc88f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3095,6 +3095,65 @@ static inline bool kvm_pv_async_pf_enabled(struct kvm_vcpu *vcpu)
 	return (vcpu->arch.apf.msr_en_val & mask) == mask;
 }
 
+static int kvm_map_gfn_protected(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
+				 struct gfn_to_pfn_cache *cache, bool atomic, int *token)
+{
+	int ret;
+
+	ret = kvm_map_gfn(vcpu, gfn, map, cache, atomic);
+	if (ret)
+		return ret;
+
+	if (kvm_x86_ops.post_map_gfn) {
+		ret = static_call(kvm_x86_post_map_gfn)(vcpu->kvm, map->gfn, map->pfn, token);
+		if (ret)
+			kvm_unmap_gfn(vcpu, map, cache, false, atomic);
+	}
+
+	return ret;
+}
+
+static int kvm_unmap_gfn_protected(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
+				   struct gfn_to_pfn_cache *cache, bool dirty,
+				   bool atomic, int token)
+{
+	int ret;
+
+	ret = kvm_unmap_gfn(vcpu, map, cache, dirty, atomic);
+
+	if (kvm_x86_ops.post_unmap_gfn)
+		static_call(kvm_x86_post_unmap_gfn)(vcpu->kvm, map->gfn, map->pfn, token);
+
+	return ret;
+}
+
+static int kvm_vcpu_map_protected(struct kvm_vcpu *vcpu, gpa_t gpa, struct kvm_host_map *map,
+				  int *token)
+{
+	int ret;
+
+	ret = kvm_vcpu_map(vcpu, gpa, map);
+	if (ret)
+		return ret;
+
+	if (kvm_x86_ops.post_map_gfn) {
+		ret = static_call(kvm_x86_post_map_gfn)(vcpu->kvm, map->gfn, map->pfn, token);
+		if (ret)
+			kvm_vcpu_unmap(vcpu, map, false);
+	}
+
+	return ret;
+}
+
+static void kvm_vcpu_unmap_protected(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
+				     bool dirty, int token)
+{
+	kvm_vcpu_unmap(vcpu, map, dirty);
+
+	if (kvm_x86_ops.post_unmap_gfn)
+		static_call(kvm_x86_post_unmap_gfn)(vcpu->kvm, map->gfn, map->pfn, token);
+}
+
 static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
 {
 	gpa_t gpa = data & ~0x3f;
@@ -3185,6 +3244,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 {
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
+	int token;
 
 	if (kvm_xen_msr_enabled(vcpu->kvm)) {
 		kvm_xen_runstate_set_running(vcpu);
@@ -3195,8 +3255,8 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 		return;
 
 	/* -EAGAIN is returned in atomic context so we can just return. */
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
-			&map, &vcpu->arch.st.cache, false))
+	if (kvm_map_gfn_protected(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
+				  &map, &vcpu->arch.st.cache, false, &token))
 		return;
 
 	st = map.hva +
@@ -3234,7 +3294,7 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 
 	st->version += 1;
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
+	kvm_unmap_gfn_protected(vcpu, &map, &vcpu->arch.st.cache, true, false, token);
 }
 
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
@@ -4271,6 +4331,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
 	struct kvm_host_map map;
 	struct kvm_steal_time *st;
+	int token;
 
 	if (!(vcpu->arch.st.msr_val & KVM_MSR_ENABLED))
 		return;
@@ -4278,8 +4339,8 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.st.preempted)
 		return;
 
-	if (kvm_map_gfn(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT, &map,
-			&vcpu->arch.st.cache, true))
+	if (kvm_map_gfn_protected(vcpu, vcpu->arch.st.msr_val >> PAGE_SHIFT,
+				  &map, &vcpu->arch.st.cache, true, &token))
 		return;
 
 	st = map.hva +
@@ -4287,7 +4348,7 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 
 	st->preempted = vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
-	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, true);
+	kvm_unmap_gfn_protected(vcpu, &map, &vcpu->arch.st.cache, true, true, token);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -6816,6 +6877,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	gpa_t gpa;
 	char *kaddr;
 	bool exchanged;
+	int token;
 
 	/* guests cmpxchg8b have to be emulated atomically */
 	if (bytes > 8 || (bytes & (bytes - 1)))
@@ -6839,7 +6901,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 	if (((gpa + bytes - 1) & page_line_mask) != (gpa & page_line_mask))
 		goto emul_write;
 
-	if (kvm_vcpu_map(vcpu, gpa_to_gfn(gpa), &map))
+	if (kvm_vcpu_map_protected(vcpu, gpa_to_gfn(gpa), &map, &token))
 		goto emul_write;
 
 	kaddr = map.hva + offset_in_page(gpa);
@@ -6861,7 +6923,7 @@ static int emulator_cmpxchg_emulated(struct x86_emulate_ctxt *ctxt,
 		BUG();
 	}
 
-	kvm_vcpu_unmap(vcpu, &map, true);
+	kvm_vcpu_unmap_protected(vcpu, &map, true, token);
 
 	if (!exchanged)
 		return X86EMUL_CMPXCHG_FAILED;
-- 
2.17.1

