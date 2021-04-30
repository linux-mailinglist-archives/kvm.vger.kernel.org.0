Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE9A36FABD
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232817AbhD3Mn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:43:57 -0400
Received: from mail-bn8nam12on2074.outbound.protection.outlook.com ([40.107.237.74]:41101
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232441AbhD3Mmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGJpVBWVfT58f8fMg1p5gnZVuoeqAVoBTkLrkl39MP0ExIoIIqsaiVhN7p5r/9uExlkTrXJvvZptcjkLM2gSen3Z2PsM5ae0G8mPM3VoROimtalZQ16E3CesylH6DA39bM8OKiuwA66s9seNi71EM5A+Osi3YieVvYGXt5rfL+h1hbIAse4IC5Npb6a18Kapxme31eCdGE4tXfrQgl+699RQ9Z0kELBngK54WKUm1MXNSzyA4mjcB48UtI2QPi8al1CRa/UfybHkTqXLdkcNRKVYXDbWeIfaGTkWCPyo0FU+90xOShq/jqW3eB55WMFN9vZaFr73mJ0S9MS47xg00Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiJEiN0MDAnMJXmc07sfCitsrSw8RPaedeW1YFszWOE=;
 b=QEGPVC1EAKJMK3C+0meeNb/Uy6voxrec6vbhgIPfmoI4Smp89T8D1raK4AQ8/KMmzZBtApeb2oFfD9yHIHvfvaVDHWSlprsU8dn24iVogP1J+CPbjqbE4kuXiupKQfS+8VXo20ZUVEsrCmuUqQSQzb0Rs9bl2l+JDsI7EZ844I3BJV2ONPCop5YIhTUegQruDrtJwVbtPnOd5wneI4RxJ5fc5MBeL62+msT6ndgQ91cwS23DMW/iD2nCX5OYSK6qQdl1uBFCeE1O5ntQdR5yxJzo2vjSZm7wwaa4VbMLjD00ZEucCsrcO/RMQPkOq7GNVMZVw/3rHEenP7duVtazGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiJEiN0MDAnMJXmc07sfCitsrSw8RPaedeW1YFszWOE=;
 b=qTDGBrUDaJp2Zy1SRTdo20MXypM/Tn09zdxibMJVhpBooc16+H+6fEBeA8FvBEWjlwPhxv7jHOQIK/dprwOUK5qhtngUs5W28wbGUjQsNyeXoWUilxsNn5ARLfm+2T7rpn2SrBDDsPdovcRkmxQcY5jVmU687F6ZVJOTIosW8BA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:10 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:10 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 23/37] KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Fri, 30 Apr 2021 07:38:08 -0500
Message-Id: <20210430123822.13825-24-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07ad746d-3541-46e8-0de0-08d90bd4f40b
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28321FF261B5C17FFCBE6C99E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NMJhy+M/0mB3Zu2IA1K9YnhNlFnA74kOyb6s5Iz5vCh8CoVTeb2r56SSyOwAcmGizZsCDRJDi/Mjudwaev8gnXo/cTJWEzNjzsFnr37mS2IrB5CP9Qd62uXBIsnLD3xWjSb4Aw1xFMDchFFfSKl77cLtJfgpg9UPbODppP+RNAAq4toEsj5uSbXUcOVF7eGG4Md4Hy6zeKk+fJJBbBqkSH6iBPDu/QzubHCOzGPiuF23ONG1ViNWNwmQLzCKswufPjhBtd/Yyf2kTjgendndxhNldQ2zNJQnkLM7Od4goxluVYVt7i9C6kJdr763hmlUOR0eitZaZmBXkdbKe4vR8bFqDeYaLYmjTK6ZMOYeWI5tNE2OJUfPsBuylyb+Oa4RhkvmmVKZ897vtIRAmpDtkM/Ypu/ruoaq7ePLQ+k8Tg/3+e5nv49SfIia7xP6h1NV1EBs+3GONXZclunkR75k7bJ7T32cNEw/vpfX59oNaJlv1gxFShTXuEq6ylMU0c68wUgEzjmKx6sjJWJCGtFx7Jxit4qLaH1aDNgEaW2JlknhdqP+Ypdl2vIP+hnkgL9+k/UG8penZZMNFd89PNJ1u7c9hGJOMa82DMCPKa/fL9jfBh3w7kHdv4Nb34kR/brdhaX1Iiolqjq3GHhwb6wk+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?by1PALNaVqnCItOfCpjVMfI/AeJ8Su60ypM07VIp09uTea7WtQo6VcmbCDWM?=
 =?us-ascii?Q?MnreQkOiTsoOlLAYPgaZgDbEXlPNmoAOeUyHHUFHReJs9T9CoBvjTr5EAE6Z?=
 =?us-ascii?Q?TQCZac/5ojGcjrG7QrV3uSZpq2U3j6mw4FF1p24re6I+xcLn/GgrNeIgWBoN?=
 =?us-ascii?Q?KcDNzc5gJSwea97hXHXulaAZU1Y9JEPRm7wlKP/iCWpbdi++c3DqO5pysuNZ?=
 =?us-ascii?Q?bwkh3O1TdcikuTEMpN3Cn2+b6tWMElHXRVYyOJLcVeUtCkID20XGR/5Ip/Pq?=
 =?us-ascii?Q?x48ZBGwFqwGu9VRsqO03vfE1Bg17a04nL2ABSq+dcThAK3tYiD863ihkry8T?=
 =?us-ascii?Q?5DrGDD2tPz+1WXX6+smotw3gm1EdaqRF+YJWnCuhmiwZp9rL0SLejAy7G5+I?=
 =?us-ascii?Q?F0bRTDWg6I05Q/fnkS41VjPOQvciNHv/VvEF3r6xDjVMMpakCY0TCkugcDNE?=
 =?us-ascii?Q?OyjL9iWWptuqUaaCTQJOZFobbcA+P5wRxiRae4FhWfIfbTMsNxB+xnNYzOKg?=
 =?us-ascii?Q?p6yChbucpaRFzFqJHZTvAke0hqSWDmS5k1W/huCw3X4l8uq3JigmqCzm2ECK?=
 =?us-ascii?Q?Z4PjqytoPw7hAAnqmHlzSOIk9BFU9sERqffZgN0GhBBVzkuPWBZ/qTsbFIQd?=
 =?us-ascii?Q?hYZaSCz9KH/emrF1Oc/2Q9cRO5f5sV9EUMJ8ibAESSxlsytVgFF6aIqnva5C?=
 =?us-ascii?Q?Q1TqBXct8ML3rHMumqdjWuN6HCq5dV6txH/jG540gn8Sf6XYZ8oLBSI4Y2Vp?=
 =?us-ascii?Q?1Y3Q+E4t0CZP4RsAdX4LZDF2KjidEAHJjdCLLB/LJuVDc6dGnXiYkWLLQdkl?=
 =?us-ascii?Q?9hUAqZNleKDbTdCcOc+liIc+oCk+kJ/YJbztZLaMH/RQPkpbVfPZTxePDHl7?=
 =?us-ascii?Q?N2rX+9pjwLUszSYs1nvCqTOg8DCkPbd84W/fxN/twP/eZv18N+ZYfJ2yXTrE?=
 =?us-ascii?Q?alIEVkUHEYfamoThqcp6WZLjl3FeSMKZC2aI2Y5ZDM9G/YFCh7lKmkNBcN9X?=
 =?us-ascii?Q?3rZpKg7EZM5mmKiIVa9KMlNeZ3hUqaD8nYWNvUl+9EGNOVM47NmIbnDg8NoI?=
 =?us-ascii?Q?BsLqIUhalvxJasmOTy2e6G7livpN898AXCHwjGLv7rnNFEcRFiqTGlLdEzcC?=
 =?us-ascii?Q?DFCg+TL82jnExOxgpB+LeD9+orTMjPft6/lZ7sCdOlG5G0VzXidVmpUdJoPd?=
 =?us-ascii?Q?K1Nvwfc9VLwl/x3+6j/XvDClqNPS2vRDqkLNvRT9QM54n68JMdbJwJZAplS0?=
 =?us-ascii?Q?foC0B8W1R1Hf2LwNrWzfzThYZudyuRWzFXYu2ieHdIY3UrNUAef1OnyjuhAL?=
 =?us-ascii?Q?6zZwgw34yitm2mJHH0MzWJ8R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07ad746d-3541-46e8-0de0-08d90bd4f40b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:10.6582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6vFigq9ANOxPRjRSmk0heaxQdiTlxS2eDG2GT1yiXbNqlsSuUXwnYYR4nAmc09nBNq+IeXghNNAlxfkARrxPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
guest's memory. The data is encrypted with the cryptographic context
created with the KVM_SEV_SNP_LAUNCH_START.

In addition to the inserting data, it can insert a two special pages
into the guests memory: the secrets page and the CPUID page.

For more information see the SEV-SNP specification.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 139 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  18 +++++
 2 files changed, 157 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 90d70038b607..d97f37df1f3b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -17,6 +17,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/processor.h>
 #include <linux/trace_events.h>
+#include <linux/sev.h>
 #include <asm/fpu/internal.h>
 
 #include <asm/trapnr.h>
@@ -1607,6 +1608,141 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return rc;
 }
 
+static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm, unsigned long hva)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *memslot;
+
+	kvm_for_each_memslot(memslot, slots) {
+		if (hva >= memslot->userspace_addr &&
+		    hva < memslot->userspace_addr + (memslot->npages << PAGE_SHIFT))
+			return memslot;
+	}
+
+	return NULL;
+}
+
+static bool hva_to_gpa(struct kvm *kvm, unsigned long hva, gpa_t *gpa)
+{
+	struct kvm_memory_slot *memslot;
+	gpa_t gpa_offset;
+
+	memslot = hva_to_memslot(kvm, hva);
+	if (!memslot)
+		return false;
+
+	gpa_offset = hva - memslot->userspace_addr;
+	*gpa = ((memslot->base_gfn << PAGE_SHIFT) + gpa_offset);
+
+	return true;
+}
+
+static int snp_page_reclaim(struct page *page, int rmppage_size)
+{
+	struct sev_data_snp_page_reclaim data = {};
+	struct rmpupdate e = {};
+	int rc, err;
+
+	data.paddr = __sme_page_pa(page) | rmppage_size;
+	rc = snp_guest_page_reclaim(&data, &err);
+	if (rc)
+		return rc;
+
+	return rmpupdate(page, &e);
+}
+
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	unsigned long npages, vaddr, vaddr_end, i, next_vaddr;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update data = {};
+	struct kvm_sev_snp_launch_update params;
+	int *error = &argp->error;
+	struct kvm_vcpu *vcpu;
+	struct page **inpages;
+	struct rmpupdate e;
+	int ret;
+
+	if (!sev_snp_guest(kvm))
+		return -ENOTTY;
+
+	if (!sev->snp_context)
+		return -EINVAL;
+
+	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data, sizeof(params)))
+		return -EFAULT;
+
+	data.gctx_paddr = __psp_pa(sev->snp_context);
+
+	/* Lock the user memory. */
+	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
+	if (!inpages)
+		return -ENOMEM;
+
+	vcpu = kvm_get_vcpu(kvm, 0);
+	vaddr = params.uaddr;
+	vaddr_end = vaddr + params.len;
+
+	for (i = 0; vaddr < vaddr_end; vaddr = next_vaddr, i++) {
+		unsigned long psize, pmask;
+		int level = PG_LEVEL_4K;
+		gpa_t gpa;
+
+		if (!hva_to_gpa(kvm, vaddr, &gpa)) {
+			ret = -EINVAL;
+			goto e_unpin;
+		}
+
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+		gpa = gpa & pmask;
+
+		/* Transition the page state to pre-guest */
+		memset(&e, 0, sizeof(e));
+		e.assigned = 1;
+		e.gpa = gpa;
+		e.asid = sev_get_asid(kvm);
+		e.immutable = true;
+		e.pagesize = X86_TO_RMP_PG_LEVEL(level);
+		ret = rmpupdate(inpages[i], &e);
+		if (ret) {
+			ret = -EFAULT;
+			goto e_unpin;
+		}
+
+		data.address = __sme_page_pa(inpages[i]);
+		data.page_size = e.pagesize;
+		data.page_type = params.page_type;
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, &data, error);
+		if (ret) {
+			snp_page_reclaim(inpages[i], e.pagesize);
+			goto e_unpin;
+		}
+
+		next_vaddr = (vaddr & pmask) + psize;
+	}
+
+e_unpin:
+	/* Content of memory is updated, mark pages dirty */
+	memset(&e, 0, sizeof(e));
+	for (i = 0; i < npages; i++) {
+		set_page_dirty_lock(inpages[i]);
+		mark_page_accessed(inpages[i]);
+
+		/*
+		 * If its an error, then update RMP entry to change page ownership
+		 * to the hypervisor.
+		 */
+		if (ret)
+			rmpupdate(inpages[i], &e);
+	}
+
+	/* Unlock the user pages */
+	sev_unpin_memory(kvm, inpages, npages);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1699,6 +1835,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	case KVM_SEV_SNP_LAUNCH_START:
 		r = snp_launch_start(kvm, &sev_cmd);
 		break;
+	case KVM_SEV_SNP_LAUNCH_UPDATE:
+		r = snp_launch_update(kvm, &sev_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 00427707d053..dfc4975820d6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1681,6 +1681,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1786,6 +1787,23 @@ struct kvm_sev_snp_launch_start {
 	__u8 gosvw[16];
 };
 
+#define KVM_SEV_SNP_PAGE_TYPE_NORMAL		0x1
+#define KVM_SEV_SNP_PAGE_TYPE_VMSA		0x2
+#define KVM_SEV_SNP_PAGE_TYPE_ZERO		0x3
+#define KVM_SEV_SNP_PAGE_TYPE_UNMEASURED	0x4
+#define KVM_SEV_SNP_PAGE_TYPE_SECRETS		0x5
+#define KVM_SEV_SNP_PAGE_TYPE_CPUID		0x6
+
+struct kvm_sev_snp_launch_update {
+	__u64 uaddr;
+	__u32 len;
+	__u8 imi_page;
+	__u8 page_type;
+	__u8 vmpl3_perms;
+	__u8 vmpl2_perms;
+	__u8 vmpl1_perms;
+};
+
 #define KVM_DEV_ASSIGN_ENABLE_IOMMU	(1 << 0)
 #define KVM_DEV_ASSIGN_PCI_2_3		(1 << 1)
 #define KVM_DEV_ASSIGN_MASK_INTX	(1 << 2)
-- 
2.17.1

