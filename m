Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B051347EB7
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237223AbhCXRFu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:50 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237056AbhCXRFJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SyOzjPCOx7xtOy+bT7FHIer2uknP4s9m++Hq6bBQ/G0+cYlS+sbOsxKEozqye+WH0Wb5mdwvMp2az3HT614Y6uXPQIx+VwGCVuMYf7Ftc+XO6RX3e+i9ntcWB46qWob6NLnMIGuBbqmZRDn1WTuWFwgdr3sp+k3orehIa5zyh2XUFcak9sqRxvdq4eew+XqIA3SmLbEoubGdTsttrDW/Y7W3nizaoXDTc3c9Gj/quiIVBsX82R0AEPyInUyvhBm9t6Sq9BcOrroJR8xijow8JtcJA4aa/i4aXfPfQgM2pD/YopzgykSLjJycvsFo55pqlcuckoiNvmqh08aR4ZQpTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jxrfGjRV0UlSbWizl9lwESjUMQ6w/6OcWGsn+CeVVk=;
 b=Z9xsHf9aSDJ9di3pCuPTUvCv23GeFjZp6TuBxp05dEjM0lIF11sxHSq+aZxy4yovYA+Fi9ZsWEpPZt9eNvDB3O13hPg33+3dYOtpvXJSmUJgrDwMc3+SkAz9qV6lf86HBG/zyeZN6Q2fA12qmO9CmcYdQxjRwQKa08YYm9oM+UNtsLx23qUSVpvg8sbacSefHIeRbr3TIzPfuhzXpV6uhQlza2UOfioBZjdnT41trKc2cIQZkoaD6oL9mTYlyXnUaBXOv3wmQ+LflXedDiBxy5ouOezremXGKrbBfSTcJ6XC58vo7CmmQhXJSwGHui8NVetdUSAGoklt/QTtjdMtaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jxrfGjRV0UlSbWizl9lwESjUMQ6w/6OcWGsn+CeVVk=;
 b=GKSMtYSXJah68GU5aBEt3Enkw1JeTAbGHhXHYVcs2VFy9bOOXJkKE6UsLZ89sOqLeAvydQRHwws72PfGcCL4c2nGIU2akfkFIw3A/wLoq1mhvihDUIw8aJPhhxlfxP1o6/ohUFRbbbAGVJ5BNHX8Bew653Po5QNuljB9az3/0kM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:07 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:05 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Subject: [RFC Part2 PATCH 18/30] KVM: SVM: add KVM_SEV_SNP_LAUNCH_UPDATE command
Date:   Wed, 24 Mar 2021 12:04:24 -0500
Message-Id: <20210324170436.31843-19-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4c364de6-c7a7-48cd-3138-08d8eee6f8bc
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382C6D7B00D7F9AD5811DB1E5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cICYGtNTxOEC0DpunZ65mdwTMu2CCisGTLw7qC85frPgom7phr7DXehsBdlNQjFzVLfm8KFj7ljW0SRWSoXWho3IevUmeZI8p3lBAEHbPZ1k2spZpB5u/329waKLygC7ntSni85Ni28s5li5lf70gK2JDsmAuMvQEgWrLrgX+5gFe7uqR5Lc19JycNuN4xOj2WTKPxEn0DRLgvAXEcnqkGTn/wMQOIXxX9yPuLQx07KGl2Z5cUcoz4Ib7IsGtu9XDS4DwgsiuoXVmKGYG4b4VAMLE2BOFfHs6Et6CqF1iYw9vpXYYy8i6EvysFVuUqBfdcnp8/faSlNL0+MlIVJLzZzrUsLtUOLBIjLcyMi64AnwjZje69eWFXqyAEY1O+uB0fCW8fgaFhj5CKIFyXXfBErxzSU54cUti1dkZZW5zDXiGPuuncbbGGkkz3fO7lXf8DGDpacpONsWU5XVyo4OKMGqOUrhCtfOHtSHvFE4BEC1wjS4U2w5IbOUsuHsJd6ZiqVtjI6ht2KAx5mGPI02JC0VKECVdWE9iLFJSl0Q2yc4QCGibPKanX05LH/0owUW1/9oC7D439Uort/IkaIiWqjmAveZXQL6MpWhosN9qcTfIQm1Y+7snR3Pd8d55pi+zfY5/rEpwxSb9OdweCqHPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eizz2Xrd5r/Js+aDANTzwnkoQPW7bWqRxc8ouU9YLUdhUzvcG1zsZdsbr7cf?=
 =?us-ascii?Q?tLg4R7vet5UPKEummMau6JxCeU0/eLpYyy4a88bAvl2KJqdhcWFpferHUtQl?=
 =?us-ascii?Q?7+Z0gwZZReNq5H7NqBWg0yVMD3yiONjDyy1KR6eWwgFnIugfBngQ/sTzWHQX?=
 =?us-ascii?Q?/6AcyIPFbUse24AA/W7LkTRyUqtYIWtuI8yhH0aDo61l8g7YAD3sezu7qqqv?=
 =?us-ascii?Q?Br7hG6+6FFT/f/XlCvsvM3mpP4vXZRbZ81LXkmU1h1f2hxjkJ1nBGdXL2I2Y?=
 =?us-ascii?Q?lzoPIyaR7DB4kWbzcvjBYPLMPAgzChgRmMpieq/b/L4QkshPGnwffoA4PM5i?=
 =?us-ascii?Q?kFGVyE52IfWy97pNdqzXMuToEZpyTLNIE5XwRLji4s04JEIhbniFxtfoKxtZ?=
 =?us-ascii?Q?1PsMsBbxfB2wfBoBW//60x/commINm8irBkYP+mHVRwQ2Yx4P72adtGnjphk?=
 =?us-ascii?Q?cnF9oixV1bsGk3w33nPuwrqH05DH0qKTqAPmQGPX0nBgWoxl3z/OAx+Qp9S+?=
 =?us-ascii?Q?nWSkU7Ts0zQ0rtJYzr6fL7YsiJskJLUJTc3VOfW7+Qxf7VGsENwNl6N0uLMs?=
 =?us-ascii?Q?xtswg6YeVagIJqqtb5gXbv+nuV7aoeplOcK8K3OYAXhK8BjwiWoLGXUIjxNr?=
 =?us-ascii?Q?thWiYqC4/v5OA835q4r+3OtQ3EmPS3DBR7oo4VO44SPC5QE1nV3c8Bp7IRAB?=
 =?us-ascii?Q?aIqrU7xCZglFsjACVcshXsctxejZvbS+ccTm3ixgjpc/7/rjaDkkcPT4lKp7?=
 =?us-ascii?Q?zu6WxVCquQeKz6k9sHTMWBn2695fvo9aN49p2OEm3aKJsKwLzKXuBIQwfth0?=
 =?us-ascii?Q?2NqQXVEDFAThge7doCqkRxLWB/EC7cQ7KqwRirC2JqzBTrqqwul7kLN74u+H?=
 =?us-ascii?Q?NOL4b3YXcd6Ar8shIvPHR87IjCtBK8C/ugsM+V2mc88eAMR4OJrQo5RWQlqe?=
 =?us-ascii?Q?gXma3pve0vAytt9h0nrrVvERE9cRkdTzDF1JErvaI6LF9rPF83a/hzb9z9KK?=
 =?us-ascii?Q?DXka3l5S9RGh9pKJsCrMMXE2DmXDbH1HAdCZpkcCJwN6GZ/Nj63ReTWehgb0?=
 =?us-ascii?Q?9QRTTl88+AMYOSsWlV6TW0ZbddpeU7nIWM6r0PuKNgPsrqVSGgFJ402Scpp9?=
 =?us-ascii?Q?ow1fn/XQ4GgdYMqGZJBVqxQ1v1e9DtoZnduzTXdqpAv17AGnz/X/GlJ05+vz?=
 =?us-ascii?Q?hLhH9FIo8u9IDfCO7BCFWIJBewCl3gki2SIOLJGug8lYxEzNIHkAqOIiuFiw?=
 =?us-ascii?Q?cbkBnAkKhkblQlKM89ZOMHs2i8ldt99Xfk0jgwVWtTtjQ+v7kbN4v1tA04n3?=
 =?us-ascii?Q?fOCpm58ybrAv6PBUDorkVakw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c364de6-c7a7-48cd-3138-08d8eee6f8bc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:05.7485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Y7xhmEimQflMxnMKV62ccWd6Ky5LY50mvcRtg2DSCp+9f11O+He9uQolyMvvyoRax+X9Ailxvmq3oEMDVancg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SEV_SNP_LAUNCH_UPDATE command can be used to insert data into the
guest's memory. The data is encrypted with the cryptographic context
created with the KVM_SEV_SNP_LAUNCH_START.

In addition to the inserting data, it can insert a two special pages
into the guests memory: the secrets page and the CPUID page.

For more information see the SEV-SNP spec section 4.5 and 8.12.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 136 +++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h |  18 ++++++
 2 files changed, 154 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7652e57f7e01..1a0c8c95d178 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1247,6 +1247,139 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
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
+static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	unsigned long npages, vaddr, vaddr_end, i, next_vaddr;
+	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct sev_data_snp_launch_update *data;
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
+	data = kzalloc(sizeof(*data), GFP_KERNEL_ACCOUNT);
+	if (!data)
+		return -ENOMEM;
+
+	data->gctx_paddr = __sme_page_pa(sev->snp_context);
+	data->vmpl1_perms = 0xf;
+	data->vmpl2_perms = 0xf;
+	data->vmpl3_perms = 0xf;
+
+	/* Lock the user memory. */
+	inpages = sev_pin_memory(kvm, params.uaddr, params.len, &npages, 1);
+	if (!inpages) {
+		ret = -ENOMEM;
+		goto e_free;
+	}
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
+		e.pagesize = X86_RMP_PG_LEVEL(level);
+		ret = rmptable_rmpupdate(inpages[i], &e);
+		if (ret) {
+			ret = -EFAULT;
+			goto e_unpin;
+		}
+
+		data->address = __sme_page_pa(inpages[i]);
+		data->page_size = e.pagesize;
+		data->page_type = params.page_type;
+		ret = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE, data, error);
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
+			rmptable_rmpupdate(inpages[i], &e);
+	}
+
+	/* Unlock the user pages */
+	sev_unpin_memory(kvm, inpages, npages);
+
+e_free:
+	kfree(data);
+
+	return ret;
+}
+
 int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_sev_cmd sev_cmd;
@@ -1303,6 +1436,9 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 84a242597d81..a9f7aa9e412d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1597,6 +1597,7 @@ enum sev_cmd_id {
 	/* SNP specific commands */
 	KVM_SEV_SNP_INIT,
 	KVM_SEV_SNP_LAUNCH_START,
+	KVM_SEV_SNP_LAUNCH_UPDATE,
 
 	KVM_SEV_NR_MAX,
 };
@@ -1656,6 +1657,23 @@ struct kvm_sev_snp_launch_start {
 	__u8 imi_en;
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

