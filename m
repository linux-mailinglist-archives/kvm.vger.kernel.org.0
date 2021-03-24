Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C869347EC5
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237394AbhCXRGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:06:11 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:33120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237066AbhCXRFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/Yn4pyz2BuJDR3yMdEXRqrTDDV+xeOVP0BBAvQwI2Hq3YmkQIlrTJrEvQjFAjEKqmO8lxOGngH8LkH304xXxioo6cHevZV/l8ECCOETtw7FHtztA4QASgxnv3N3zaCS6oGlEf4WeIdZvt7R8gRpCeDUj/yNX8AF/51IlFdtDK3ajiK97Msch6fmrls4pd5N9Wx1ke4U5XnCg5NXVbvIbgB+/CyuyGTWiVe1IwByfriEF6II/6pEpWLyuhrSKB+Z8sxvcH9fbpUxTpizF8ZJsdYIUvXdTVRpsFMUBK2vZHMNqeKcf6QLxX8chLCIonhanLaVTzyedLd0kFCrS8qiug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QU8SJa4pGsdar656VjblxPQz8w2okpR/9hoCkmfzbmI=;
 b=dbihrTaILAOcosdfAROjSeZepBR/+MnHvmkRIDAUSzop0XacpZa7vu0bBekYseyiaii8gZrfNCjNZds1b5pk5/9WkkwkOMuYmjLZwLP2hW06kEQkL7KWCCRjuFKBgtbsEzqgW9Od/MT86DCJ0T2WzrD6QPfFRN2+Ci9QzZUDxGN2IflRPl0He3hLW8trRZ/OYi308AizDa2k9j1IWzuBKWMxfvxRk1JQ0upwXnN/mC3w4He3B5HJqp0Ws1Bj0VcT8aSEHmOWy2ZFtOSqu67iZ22UXLJ1N1pxlGqbcaXxrq9iXxE4tjpRI8RtTColBc30c/S9or3KWQl1UIo5TaWupg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QU8SJa4pGsdar656VjblxPQz8w2okpR/9hoCkmfzbmI=;
 b=IE9M+hIffUhKnHAGJQGJU3xOnJgC5IdT4s01TIlS7QdXF2v1+IYIqw5tpftyvH+OT2MWrbmwOzH8LJnEMnQMmQkcA378GYhaSiSJA6H5AcO+HDXAhAH7C2WvvFEyL3i9/Dga0QtHFh3p0da6bsz1I2nVndfILmdPM+G28Xww18M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:12 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:12 +0000
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
Subject: [RFC Part2 PATCH 26/30] KVM: SVM: add support to handle GHCB GPA register VMGEXIT
Date:   Wed, 24 Mar 2021 12:04:32 -0500
Message-Id: <20210324170436.31843-27-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2d6fcdcd-add5-4974-a566-08d8eee6fcdb
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4382FE0B39D6B790970E285DE5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y9Q7eQqXyMtAKDHjEKE3UKFfGCB5BCoacu1LoJ1N3XipYqIavgrrwmaURUEhNZTTwfu2Ug3hKWzFU7lwB6T92dNcc1ptNU8+2G8Vixk2FlnXcOyqueJ/QcW4DFK/l2sfEmruuDfClC08dYhdwcT0FKy95blPWz3voBKeTz2L70KfC4luZDtZc7iK82f6gGB2H6rMYsrT4BmHRDRXObzx3YNxk9IAkD32jk5FZ+wWP318FC1pI2oFM5ctMOZtMMPpwj64m8BiPo298Gf7auPpyfzeSO6uyeDcpb97apTBjIomdYBcuxJx7vYBxI1c3/2L/AaK+v4u0b82eLh7irR2HPZW1gaqzkUDjmtvnuYhQO1EkucCSQuPhyRQtO8U32TEXdyBKKrcc2hQYWcdIex/8ZgPrhj8Z9Gwb+o5IOeLGEw+EbZgY9ySTQ5W/3rxQsNdGJyE6DhRsTpIRPBaT4dTz80HI9cvHPjhtz4Di9E1gZx7fhdDYQjlVAbtMz3TQ7BdJ3jKl6aNaImPQQiwefi89GvZET8RzXN3+oMn1e351g+3CoYv+c8kbMeRJcy+qPC66sOEPGWmv2sZf0uTAw9HIKtuCaX5vTWgOtWSYvL7VmU387ludo2ZklBlXfH4ZFhHHXDiagfzip76ykraLwZzYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?DPwDTqcPTkTe6Tj6sUupVvhFMkAT7xujvfaNtGOxnvQxk/zNCNE8s+dk4Akb?=
 =?us-ascii?Q?vLxEuMoLt27RgR/DHUOXHRakepI7EEZ35HS4XGNS69Z7iwjcd4wrwbKbVMYc?=
 =?us-ascii?Q?RPATKvLKkWbzjp/dYMINUs2WHN016jtH6TgvFmuAynfqv5zk05Rs+pmtB00X?=
 =?us-ascii?Q?iJAbJSjxtzExQ6uyyQRFnnHKWhfYF1vZXUVf7OYKF+NxXJy0qzJGQnbmMk6j?=
 =?us-ascii?Q?n+3hMCHeWmMV7OWQZnX5z/l1HH+z2kKxw7k0Uk5IzEk4NlAHQx40ElpEDKqi?=
 =?us-ascii?Q?U+36L1LzUByfl7SdRE8QHikYZkvZDE4L2055LVbuclWSh7b0idi3sCNW31LT?=
 =?us-ascii?Q?qxfJpafX1gjFPXWQzdd+cnhqNs/agFqdT0PdEXfX7lw5HQ7enxl5twUmL0Zj?=
 =?us-ascii?Q?pggT6sOElQbyIvmC7pc3h7/NVN66aa9RaeJcS7zxifZwb9Q9MwrDF/rvCwRh?=
 =?us-ascii?Q?4oakFNcL6gxbSyhjfvTpTPlvKkhIPbhjocw5aRipw/1n51jQn5ECzaHC8czN?=
 =?us-ascii?Q?sJoH7sNtofXnz5X0SLkJL6oYL7Cj0Hk5v4eYEi9aDeGbt1TmrV5Dfkt8BFDG?=
 =?us-ascii?Q?K9/CJlVi+VBoObmNvOrF/+rC/2OgbHEGflBKBucNBt4Qe/cIw3aJd9J8bgCq?=
 =?us-ascii?Q?YnrcDdBG0YnnTqyUGYDMTbZ3p1Dbp9pRwYLkmSZo0m5kyaR7W3S/lWPnVMij?=
 =?us-ascii?Q?T9JRfxcvQ6/URzjQoEInjoPGjGwL3dFoENu4qxu3jvOCpvflnd6vDQjslCx5?=
 =?us-ascii?Q?YmHAD6JcTYg4V245onJNXQYfF+BmcFwFzWZ0jx3nSpvIiUH4kqtaTcRdhHT2?=
 =?us-ascii?Q?2BOSq44P/NarlRB4VGlogN8hrDBjPjRk7ZbltKK0jdLHfokq2rYtapDA1dx/?=
 =?us-ascii?Q?llvbAUd/I7/uOgN0QvyzjOSsGr0da58xEwo2Q/wE0OrfczBKFimTXbGD4iDv?=
 =?us-ascii?Q?zbvnXquT86BuJ0LUhbkeHztXQDzQtYKkHXZb5bTBiW92InvQofYGSX3s2cf2?=
 =?us-ascii?Q?gY0Jb7TroU/4oj4WB7l20dncOcadjLH/8Ra/Z1OWk8X/Ap/nMMEzGWds/9z1?=
 =?us-ascii?Q?13G9jLXjwQs0CNqrUSmQ7bRD8VX8Ez73hPOs8fRpPYA0qtFhDhjWYaf3qTii?=
 =?us-ascii?Q?CZsMdCKf4UPV8lCB0OUywpotSHg9qmmlRV+pGJeYCiQXPpe5HiMhkUJ6oBMJ?=
 =?us-ascii?Q?YBNIeneLFXlbVrOKOJOIltkwI/kLoVanAJ+T54lM32s6UwmW/cIbFg8iGO3g?=
 =?us-ascii?Q?L7O9C0LtSTM/DBpaivVtN5dthrXPeehrjL1qftVDctTiEdmNjvyKatzEPuN+?=
 =?us-ascii?Q?ZVICEBPJ6+yQ90N942AO0B6E?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d6fcdcd-add5-4974-a566-08d8eee6fcdb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:12.6916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5fHQ7Z7tmctlKMgrKfzP6Z3XLzkpCRrsl4R8XX5i50+dd3nFZ7J3mNoltdFlOdGn/Ik8Kz3yL5XiJ0L6UmPrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP guests are required to perform a GHCB GPA registration (see
section 2.5.2 in GHCB specification). Before using a GHCB GPA for a vCPU
the first time, a guest must register the vCPU GHCB GPA. If hypervisor
can work with the guest requested GPA then it must respond back with the
same GPA otherwise return -1.

On every VMEXIT, we verify that GHCB GPA matches with the registered value.
If a mismatch is detected then abort the guest.

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
 arch/x86/kvm/svm/sev.c | 28 ++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h | 15 +++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e66be4d305b9..7c242c470eba 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2378,6 +2378,28 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_GHCB_GPA_REGISTER_REQ: {
+		kvm_pfn_t pfn;
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm,
+					GHCB_MSR_GHCB_GPA_REGISTER_VALUE_MASK,
+					GHCB_MSR_GHCB_GPA_REGISTER_VALUE_POS);
+
+		pfn = kvm_vcpu_gfn_to_pfn(vcpu, gfn);
+		if (is_error_noslot_pfn(pfn))
+			gfn = GHCB_MSR_GHCB_GPA_REGISTER_ERROR;
+		else
+			svm->ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn,
+				  GHCB_MSR_GHCB_GPA_REGISTER_VALUE_MASK,
+				  GHCB_MSR_GHCB_GPA_REGISTER_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_GHCB_GPA_REGISTER_RESP,
+				  GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2418,6 +2440,12 @@ int sev_handle_vmgexit(struct vcpu_svm *svm)
 		return -EINVAL;
 	}
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	if (kvm_vcpu_map(&svm->vcpu, ghcb_gpa >> PAGE_SHIFT, &svm->ghcb_map)) {
 		/* Unable to map GHCB from guest */
 		vcpu_unimpl(&svm->vcpu, "vmgexit: error mapping GHCB [%#llx] from guest\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 9b095f8fc0cf..0de7c77b0d59 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -194,6 +194,8 @@ struct vcpu_svm {
 	u64 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct svm_cpu_data {
@@ -254,6 +256,13 @@ static inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+#define GHCB_GPA_INVALID	0xffffffffffffffff
+
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
@@ -574,6 +583,12 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_MSR_CPUID_REG_POS		30
 #define GHCB_MSR_CPUID_REG_MASK		0x3
 
+#define GHCB_MSR_GHCB_GPA_REGISTER_REQ		0x012
+#define GHCB_MSR_GHCB_GPA_REGISTER_VALUE_POS	12
+#define GHCB_MSR_GHCB_GPA_REGISTER_VALUE_MASK	0xfffffffffffff
+#define GHCB_MSR_GHCB_GPA_REGISTER_RESP		0x013
+#define GHCB_MSR_GHCB_GPA_REGISTER_ERROR	0xfffffffffffff
+
 #define GHCB_MSR_TERM_REQ		0x100
 #define GHCB_MSR_TERM_REASON_SET_POS	12
 #define GHCB_MSR_TERM_REASON_SET_MASK	0xf
-- 
2.17.1

