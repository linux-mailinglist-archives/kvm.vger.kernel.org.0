Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9519E398C7C
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhFBOSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:55 -0400
Received: from mail-dm6nam12on2079.outbound.protection.outlook.com ([40.107.243.79]:15104
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231653AbhFBOQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bI1VX0wUunEp5GZ/OephPMlHO67cBJp1GJRJ6/yLdXVcBqll0gYHkdZWG1l0PTaoTn/DqYg2kHai/eusrH73ldrzkFtJpahKCV9uCusTIkijJ4AULkGDbI6f+5u8/+raJnZ0zokRWJ2SfncVH/NRsiX7ylIecm4RYudfSPO8GZiJDiVbR8Daw80UtJ2p8SXfR/YPUR7b74KR3fAonNHNMuyKHO9mdTKlgAGex9WN9yUdvYqzLTvNFbjHLqxemNfHwqQFbwhvgcJNI05kLB2y2aEIT4oCg5n93Ykfp1ny+T3OdyyvrJHPjDuYGaWZ3dRH/L3Jr59zBfTd4txdqD7EmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KooHv0mllq5V/tjmM2u3XNXV0Y9fxysjExz0F1f2TiU=;
 b=SI9MqEwndRY1nWAizzZKtc5omI+HmOd84wHIJNeGWY+0EVe8SIqnRqKRCDxRHdY3ZvV5Mitj3bXF0T4ijMKtylYudoszwPLvM7qOLf11TJm48sxBME0hmAGejWuTmlM7IbNbAwjxMHlWWFzK1PJOw6WGGXMnntrlOetvv6SR7M0MOLCVbcmGX5VNHajS/CCh+GZGKt/uTfBC9jMvxsJzK9kt94j1R+5thUri4vXdZ/ZbY0VrxRpYtLeKm69VLHdzL4AFiOSzddMiFDjaxZW+vSVggCryzanRdeDT8BWtsxtCzRqKG2sANBPqXKMHd3ntN2Nw9EoyxcTrahFeId6szA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KooHv0mllq5V/tjmM2u3XNXV0Y9fxysjExz0F1f2TiU=;
 b=oUViDX+5dylzk4O0uyEan1OshcOazB4Vj7nty6TP+38WJ8EoguGyPGcCRSxBgWRvIcq5wXCOaLa2UtOgUkX83vRjOlHJrXIxIWRsIVQ76mZQ1Ahusu9jeY8t96UeDKY/XDIKDIANdMZ3YeTJcEFeGZq7JejZGheSUEB8jcq0cVo=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:12:06 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:12:06 +0000
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
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 29/37] KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
Date:   Wed,  2 Jun 2021 09:10:49 -0500
Message-Id: <20210602141057.27107-30-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:12:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36cdc39e-1f27-4e69-cb92-08d925d066b8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592A75EE4BBB94F31545FA7E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F4L4x/cu/I+t2iyzrDwJUwIMWZITBNQoFvj/Uq7c2Xno7n6tb+1i7+4r8W7n1h5tHB6xrQBkePfHn2JfPII+naGQdsr8+VGe2aDpi3N7Jp7AU/5rTZ+XToGo6eeCJKleKVtTL9kR3A4B7STtg3DwCNDXH6Dab27rf33J1IUoxiW0VP8X3yY+y1uHMdaR1PTdzuCtkzUuoIT9qS17EazGXfSEuknZdd9eVJaGVl9djdxTn+/mv2w2mrl4fqlrYKV6iJnl/kzEXSrvboN7mdvj9WGJVcuI6f8yI0F62ZcQsKzUhSB59NIa9ZdYEIHqU3c+HraYTZ3Ef6svXQa6F03gHtLL9+6evh6LN91fuA2XUXO3eZa8Pwclh3CTe2bVSGyQZEhv2CIpfsbVTIHP5bWLRBs/s8N8ax5QfS5jdHdeOOE48FvYoY8mSBoN0e5GJxH6CHuFNk3ozKvFkzkFTeAmBru3sai8fQDKoONpwAF+In1SSwgwL03Zjs5avQgDSaxT0MJsqrni0GfTZPahmQR0kEtTD9yLP88UorPnyWtAfyyIBxlJVXBMgit58+lPqFpjsoAOiNL6/IPLSAyM156kY4QhWYnaYzskgy2i15GTQ8mUXBCsVNurw6pQUpo0jI4vv7t3RiHx5yFlHdpQfF3QBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vd4PGtCPOErTv6d5hXfCjzV6v0sgEBskZ3THYXtwkm426tQ4hP8O04fFTK9l?=
 =?us-ascii?Q?lJCJVXom1koT98zPk+4hD5o8i/3sDFNCwcLAzizQou+FncBjHKYrbVT10xKl?=
 =?us-ascii?Q?y0qg0RX1fGopIgA10YpBfYIhZSdAd9UivbIJtzOxX5webNdKXG8lszadHb/g?=
 =?us-ascii?Q?XSWUwOtr30aLCa2/CSD1Lyi0TgsHTFXswuzQuSbUss+1safA5hVLySj79ExD?=
 =?us-ascii?Q?aqJHVw8fqxtkJ7J5EJBlmUcm8m/KaW54dBr9Q1q+KzJvJiz6jRYiWL2uBSth?=
 =?us-ascii?Q?Uw/1VZFO4SbLxgWmzr2k7ico5+7190jxHi/U+fjfFoRv4I7kHNIHKaSYFPsT?=
 =?us-ascii?Q?HEogRX7qETicaFTDTkbIo3XPqtV+BJ7HrM4dztxJmThy9aR20stPWx/HIi+F?=
 =?us-ascii?Q?fsTO0v+Z1efwTblZ+/IMMhtfvI3vTqDRFW5mCFxs1sBM9OXRwPVCzgHSDhij?=
 =?us-ascii?Q?c2gAg6n6YLF4GTBoyZvdpM9daKCp3BhBfTtFVSZM5aRyavEvdwPGOYGR3kwZ?=
 =?us-ascii?Q?1mgdZdIh8Ac7YAyRCtx5YRwxNNTKtMTHz4mmteN3iQpFrl2reAAZwzawV7c6?=
 =?us-ascii?Q?T1GR4z1bj6Njzx1GyP0vxKV5WOXbUMok7w0gloOO6B8A4wXsq6PgqdU3CVYU?=
 =?us-ascii?Q?3RWEu3JjQkAAVE/Kyr1fyrppFBrW6vg5fl9Ic+XDo1IZy0qzKS05LlqKfHR5?=
 =?us-ascii?Q?kxfG792XtnEkxRAnMDTUXp5ODOT5MNYXl/ioQOv1Inw7KbngLGdod7YrpzVQ?=
 =?us-ascii?Q?LLb5spGdR53EYgl0t8LxIn8XExQn2QaH8TA+5X1m64XRG00j+zjQ3HwYTi7f?=
 =?us-ascii?Q?pAPfFzokS7F+papmNjiHc/5B+D7gHK4bw3sEIWnJye5xGN+u+fdQK4S2FJyd?=
 =?us-ascii?Q?ChEGZzlD2KWJPCRcHhgfhpac9GU7GEhs30+Nr6iw2TokSAQK09bNdpVniMN/?=
 =?us-ascii?Q?r8Hd1xu3QmYTJz+faggEt+sB+xIPRmah/fXf7X4ioSBMYOLfOygV/Rgn7IeJ?=
 =?us-ascii?Q?dzLgJNCtsTJwhFMbdGdWLBmPd5b3KUC70HbS8DQvQkGvyMbTrrpXpYSLfRaO?=
 =?us-ascii?Q?6gnNBh56Vesq4zftHdUjF0Hco5gEdRGyUt01C3p0r3pZCSEnVFMSzGv6NpM3?=
 =?us-ascii?Q?2ggSQzo0UbOPijV/TBRxLpvQLmysgyFMBLwy7PVGWz8KSglf5WpRknblfRr/?=
 =?us-ascii?Q?PEzBjTPAkwr/vv54oWCztrh+8vrZbKHJNl4xmSZBsWtedAfen9Ldgh+7UP7U?=
 =?us-ascii?Q?O6ay6183LL6cbti4FlyaMdBJofO+MHFI+S9w3gcpho62TFcOelj5IQyLmGIK?=
 =?us-ascii?Q?fM1xRyLd4xLeNtLyY+nRRyps?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36cdc39e-1f27-4e69-cb92-08d925d066b8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:12:05.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/Vsmnb7QF2/EC8QAAUB5NEhYfgZvVA78Wly7y9MNbbIt1FRM17iqEVIg9GMhvI9OVZRxa0aLTJJXhf031dSJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV-SNP guests are required to perform a GHCB GPA registration (see
section 2.5.2 in GHCB specification). Before using a GHCB GPA for a vCPU
the first time, a guest must register the vCPU GHCB GPA. If hypervisor
can work with the guest requested GPA then it must respond back with the
same GPA otherwise return -1.

On VMEXIT, Verify that GHCB GPA matches with the registered value. If a
mismatch is detected then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/kvm/svm/sev.c            | 25 +++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h            |  7 +++++++
 3 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 97137f1a567b..e7c6ce2ce45e 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -93,6 +93,7 @@
 	GHCB_MSR_GPA_REG_REQ)
 
 #define GHCB_MSR_GPA_REG_RESP		0x013
+#define GHCB_MSR_GPA_REG_ERROR		GENMASK_ULL(51, 0)
 #define GHCB_MSR_GPA_REG_RESP_VAL(v)	((v) >> GHCB_MSR_GPA_REG_VALUE_POS)
 
 /* SNP Page State Change NAE event */
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 6b0c230c5f37..81c0fc883261 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2900,6 +2900,25 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
 	}
+	case GHCB_MSR_GPA_REG_REQ: {
+		kvm_pfn_t pfn;
+		u64 gfn;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_REG_GFN_MASK,
+					GHCB_MSR_GPA_REG_VALUE_POS);
+
+		pfn = kvm_vcpu_gfn_to_pfn(vcpu, gfn);
+		if (is_error_noslot_pfn(pfn))
+			gfn = GHCB_MSR_GPA_REG_ERROR;
+		else
+			svm->ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_REG_GFN_MASK,
+				  GHCB_MSR_GPA_REG_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_GPA_REG_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2948,6 +2967,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		return -EINVAL;
 	}
 
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	svm->ghcb = svm->ghcb_map.hva;
 	ghcb = svm->ghcb_map.hva;
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 32abcbd774d0..af4cce39b30f 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -185,6 +185,8 @@ struct vcpu_svm {
 	bool ghcb_sa_free;
 
 	bool guest_state_loaded;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct svm_cpu_data {
@@ -245,6 +247,11 @@ static inline bool sev_snp_guest(struct kvm *kvm)
 #endif
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

