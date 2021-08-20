Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5993F30B8
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhHTQDU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:03:20 -0400
Received: from mail-bn8nam12on2046.outbound.protection.outlook.com ([40.107.237.46]:12057
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235218AbhHTQB4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:01:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iy+zRGmubVwS3Z3u+Jgr+y/TOvuCh+Z58zEGc3al4UdsXZXuE4qZ8XaWdEUakazd1TTmVVlRDz0KlCmyLtaMqxE8naqAS3/CGpsrJs0xX/hDskuVkG9xkFMbLYHuewOYu+lDAcyHbiSeS0THYTSi04Qesi0GDZKM0SQMpsce8IhC6RHY9N68wkqyHyHCH1QUlmd8Fh/tWO94LCdGbuxDqHcRhxokPTIZSwkIfC7hF1vti28puTqkw20ITHWPIK26rSkInVDfgsyLqQv5Lk40lgmTOFSOqg6W77w3V9eNYBWpXcx9pWvWs9ZhN+KRZ8YiXHjSXkGMXkPMAnpvLONBmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXSm6e6oosM2NMY04WCBckiuTh6x9wVDLcgHy+Qt0lQ=;
 b=Z+utim6V287fr1sm7Xhn50MyXMSez7jBg7nS1Dxv4vpKst+N3uWucq1xl43Y/Fagbdmm7Tld1pjtKtpJ+/c3ZArEbAeZWbYArI4K9u8QHwoZK+nqASmpGARpbahfgmeNA8cRQxWFfhG7kvJaG9BPBPW2794kj+XD5D66HBO9XBdfY1tqW8EeXnxookAj++vhnN6IbKZhHJgQvl1rnvqHqrH+6HnEnBQpumVGOoiTzRmq3+u3ttoSFhBgJzisf43XARy2TFJJ54fX2DLcR1MXwyT2R6JB3OfvVj9MvOvmXo3V+fZysQEcs2Ea049fcTRFRJk5umDN1pfUGQXocRLAbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXSm6e6oosM2NMY04WCBckiuTh6x9wVDLcgHy+Qt0lQ=;
 b=Q8UYi/E1NvL3Dmf1sddrBWYQgBxt2tduUnwOsE56856Ipj4MP2jnh17dYy7JOM7ghYroXZSmFIqw7SCnTP+G7LeTpgqYI+szqcZ57CbO4mRPo3rw7Cm6yeQKmyZ6NNsQ8I0u3dB5D4+pozT/CZCfxFGEu1UyjGxxLreqi0w1xYw=
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
Subject: [PATCH Part2 v5 36/45] KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
Date:   Fri, 20 Aug 2021 10:59:09 -0500
Message-Id: <20210820155918.7518-37-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a83fd2bc-f7cc-4f9a-2240-08d963f3a851
X-MS-TrafficTypeDiagnostic: SA0PR12MB4509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4509371F0E507FB5F6A79791E5C19@SA0PR12MB4509.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kp0OKlwfVPQv9BNYI9RB7i/5v/uOKYOsEslpr2qD3dp8RZd7eRYIwEeC39A5PZ2fkz0iAo8oEocRrNQ5+EEgtxbFn32BmBJNW+Z685N5dNHNU6RUb1K1NA7xd3HtCS0miea6UV9JB49xIpWG0czhcKbzu7WQSC1qD4LenY1N+5G4vDY6V8voHUb69a8TEOh+JFfgRRp9zbDnuBQtgnazNoUABVGCOhboq7zXkIbqYJsfe5bHhmZUWIywCEKKYp+GY757kl3XIQhlbYTQya4c2f1T+rctyqGGnvjaHHzoZiWueTL+lsEK+EWo0Zf2hi3yKyWJwOqEC5+8kMJcLNTbx0em62WahWdKJN5hksyOfEsPy5qoq+O3ZFVkkjNWOS7h6b6Ev2H9E7m5jP7rV6S7Ar4pweSjxw21YjPurZ4gan14VAlj3jKpOm7fs2ZQOsEiZR4kEjdOO3cVUQK7N5iMS7i0hEJWu4YeIdKrXicOlXoINdoW1i5DEA7igwVftQz5t3PmtRmGKghEVrQjxID7VfpIoEj0ERjJ+C+zdjUaf8P7aCeateigiGB6djLvySBqTIl2FRFo8Coyk1utIvkge7nJ+4tB1mmRCWalrEkPcbMGBokophS36Mf8bCj7oKv50lpECw80fY3gtIgpC8kQRAD5E0uR1DlfqkpJta6a/T0mHr/BxerUps92O5Ae5Hp5rGS9cpCk/JpytaOtYcsNQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(4326008)(36756003)(7416002)(44832011)(54906003)(316002)(66946007)(66556008)(66476007)(86362001)(7406005)(956004)(6486002)(2616005)(2906002)(83380400001)(38350700002)(38100700002)(186003)(5660300002)(8936002)(52116002)(1076003)(7696005)(8676002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s6O2rpQW6tw15+yW6UvvqlYpoeJo/FzqO3WIqWPm6hcwIgRS6IJFBctXi9aE?=
 =?us-ascii?Q?M1pPDq60pSWisjTkoSoC3wwM9h2S4fa+M3STdCE1RlLNrUoKTqhFZhuPUN8L?=
 =?us-ascii?Q?ujBS/B2eHbr1DKu3M4gbtQgkA/f8+GZUI5TKh7UtUm1iJCfe9LTwIpIOeV/K?=
 =?us-ascii?Q?2V78Wn1pzgq/jdrl3fVLUguluAFC/EeGbWpsuDt5rGR7uvw+HtpM+jSXnEpp?=
 =?us-ascii?Q?qTZApqERglOjlQcUmh4GJepgRNGDyEHC3s8huVnWoHGZy/jcKtTQpvSWImpK?=
 =?us-ascii?Q?rZ4IelfuLJUg/FzjM9GtwKnHG2UHJL1Zd1TSsYtZsBHmvEtQ54HsSna+QtCn?=
 =?us-ascii?Q?o4aSE93YQ49H6zZ7E4WrFEBSQv8Dhh4jyCjVMcp3mzmNcyrqt+ybsPWqQbrE?=
 =?us-ascii?Q?Hy5x1WXTbFmNIirlovrW6+yVbotegkX9O/GsH7XCIfLozvTSLFzAmca9kQDX?=
 =?us-ascii?Q?ZuqMEyYec9WbAaY6u8eXgRln/eqeMKiXgAoL8E00/Opie4rxFybcBkArNQfI?=
 =?us-ascii?Q?ZPH2mSGhAjy432rRG20kyke5Bo9PUaDijySDX86prD4cISLORj7KRZ5vh4Is?=
 =?us-ascii?Q?avPUZo7WTFexODFMrxkObNKPtOn86ht3kQWQ3PAM7M420r4o0pa2n8kxirLb?=
 =?us-ascii?Q?lrVzHWAsURtP9M+B4P4Os80SvTz8WjTaUhCqpTUD4N5+OVlXa5pKM/c+pPRh?=
 =?us-ascii?Q?ShvH9GAXJ1cCrdPXuW6ZNovSKV5944LJzXDuepWFvPiy6HO0qNr/F5/Mj62n?=
 =?us-ascii?Q?nxl6TOasekDjlLqMDiwiXSYt9fXglGsA2M3KpdsjQvJ2zF2AQX7eZtWy6116?=
 =?us-ascii?Q?JUGJ/Iba7NUwBjLpStop6dzjdUXdwTQhDOydQKd0Tqn3jU1E1jJyZGhk+Lhq?=
 =?us-ascii?Q?y3Fe4bOAhW7mjAwWfVBNF8IiPtZDO+Sg9LVwjgyMlgsG3ddGJtf90oJD3ZNT?=
 =?us-ascii?Q?iL3Wgz3IbZjYAAQcbb58aZtfyQxf5NzWJ1ugmmRgSnXeI8I3sHEekAl5QUav?=
 =?us-ascii?Q?RzzAA8O7RHUYp7xeLjeo37a10yxMDYd1aqkS0+kxwc7+0SOrOOUWfNdaOAfQ?=
 =?us-ascii?Q?AqUyDpjqW1w58mMK+nIIurqoW/7Nmq/uu4zuOzAOEfzZiny3gGWGCq23V/MZ?=
 =?us-ascii?Q?hEIp6CPAMZXtKwWj1rtkuLiHxSaQiE48rr3MshUzSVqOiD9QeGva0sS9CxdM?=
 =?us-ascii?Q?Q44xQRpclHbwZEeFI5kNlIHkZr245V+02b/yf4kc0b7A+88SqmbYzOvUy07H?=
 =?us-ascii?Q?rfUdNHJNNjjnnjoLM1PtCJE2KlrQMAjj4BoK1QUJQLjnPugde/PmRQG4jYuq?=
 =?us-ascii?Q?gMbNy0qYNM/x/VU6J2Rj7osT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a83fd2bc-f7cc-4f9a-2240-08d963f3a851
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:40.3467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S38IT6auAVIxYmKP4XcpDXZRt2XgfzpCLty4l3lMu17QtOwl+4K1fSzDbueTt9lJPEYIOPk7EVmCGpXsd3aNhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4509
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
mismatch is detected then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++++
 arch/x86/kvm/svm/sev.c            | 27 +++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 779c7e8f836c..91089967ab09 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index c41d972dadc3..991b8c996fc1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2984,6 +2984,27 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_PREF_GPA_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3024,6 +3045,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm, &exit_code);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 22c01d958898..d10f7166b39d 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -210,6 +210,8 @@ struct vcpu_svm {
 	 */
 	u64 ghcb_sw_exit_info_1;
 	u64 ghcb_sw_exit_info_2;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct svm_cpu_data {
@@ -266,6 +268,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
 	return sev_es_guest(kvm) && sev->snp_active;
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.17.1

