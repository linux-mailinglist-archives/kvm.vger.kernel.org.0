Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BEE398BFC
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhFBONn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:13:43 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:30496
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230389AbhFBONT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6lIHJW7UA1kXsGyRlx6cQSDjrln0hNrc+SnCg/vX6LpocvY4rojJktQbfB8uwHZiX5sf1PQ3toF7GkyPPZ5jZHNirGNskV6scH+PSHUZqI0gf0TX4QhyaxBBH7drtu1ORvOWitL8WtqrSoDpfIL5hhjNXeQqGPnmqewhygp37nfepcMQYqFIpUs2KD5vPl7UM8TMSxv1VUAWAObfbsEvOfXARCu4T6HTKtNmuPrnxAP81xDOh83gUme3cEiDJkKjeOgsUO6bfv3/xMZKQha/mPUrFQ6yUhKG6GWfrXq4wf1BcKdM3EeXKdJDPzUeB+TPhQB/buUl4nCC2zMpGpY7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbkcD3u6VPMFxYdkbjP4GT3Z766pfi8iMLV8g8cvHI4=;
 b=a+u936oQUEO2meQfDT06ysJnRsyGMCLFpyqnFBcTLnQ41c53nettQIJMKcGKv2ln7m8RBFBowCiNqG2ioZrI2JStdL/sjkXMMLLdfz3OywZbGig+kI9NgUlOmmHEhguC/RjbTzUs2T06tktohlk6POeXeO50xF+IaBFJhRZIv/XASdAYENyo1IwNCZSgft+evEycUmp1EQDVsP4eXpPk0fPDsa29XPbx2osUUImTzNQjrZHCV4p/c0wA2fFfFG5P1c++WCWBtuIa73wnSu39KLnmxccS230HI1iwEv//VLw3i+OvQeIpDqBxjuCexbPMflDqlrYvE2sJ7MNFWQY05Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbkcD3u6VPMFxYdkbjP4GT3Z766pfi8iMLV8g8cvHI4=;
 b=RQwSnBaDL+OUsO8ZSQi9otoshZ6yZtSkje4YgHHBF1lytUReB61S/YxDO0G/jZvxhwMg6IeHypaVhuV9KIX3m5875+4zQ0TIfn6zNoa2bXRwlWjm/yJYPaVHzqMLgEj6lAsy3EvMOg38ofkpE/4NoeSfiaOFmUOMpSUl2OIL75E=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:31 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:31 +0000
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
Subject: [PATCH Part2 RFC v3 02/37] KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
Date:   Wed,  2 Jun 2021 09:10:22 -0500
Message-Id: <20210602141057.27107-3-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5535477-2af6-4d80-260b-08d925d05223
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44952000DB256F4ED9418F63E53D9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tVTr0QlReaqqHVltv5poe2/Nq/e9GRk4pAxSvhN2xQnIA77z0cZH9wIKvvBA5wIdnnc8bMZmjUWmQKfgjYaAGro3HTlrK8ic0hPKgI5xNOY8mHKURiIb8yf9Z3Q/z/h4kN+UJDNjSxcPqLUtMWnYUzWtndD9KaPDoUaFWxAK7lWNPDIPyaDfkvD9jbvTMNikl227hgDha93OSvcB59daE420IKXlepjxK26635Z1VT3xQFdbXXXYzmJbRLluc633V6yqgJitKg8wJo9B0OWW485j0Og6IpJhnYAzi7KbeUdBrZEjH2m4UiXTdl/P3aWrIax8Bulnex4M1omCz3rOzgm9QbQ4m1N5wsqnQpoIWDzkA5lEer0bkozgWZOLq1KMSR6J8qTkxCxkMvGFgOv5RG/MMES24HP+XEzgrRlNhM+EcIB8jyMdYNiHT0N0F0hZda0JeFjDEu0xkQzRLIkaV/gj9GOqNJauDIPb3TG3M0AvFFSvkDSR8SpSaDUXXY00Sc/94MawIwi5aOW1vY9CYu+iIJUe7vKf9HI3b4MY+RO+GwYDqV51Y8ZcCeRltuQajgqMZFUm5vrjt4wVfzMwRuJC0OKUKeYEKZPotWlOQqIOApYGkujrW0GndahKEhYRSlGb7u15K4IgTwqJ1ADljg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(1076003)(54906003)(44832011)(8676002)(2616005)(956004)(478600001)(6486002)(316002)(86362001)(4326008)(7416002)(6666004)(38100700002)(7696005)(38350700002)(52116002)(16526019)(26005)(186003)(2906002)(5660300002)(66946007)(8936002)(83380400001)(36756003)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?xgOTqBHal5rCIEAhf7l70kH1DDkGOKa2qy5oKEr9QTXYFlQUq1IVJcOCQe/N?=
 =?us-ascii?Q?eAWVOX2fZh9NalHl1NOOh+f195Azj8iEBMKXzCgWt3lSRDhtpEaIdEMOU9bX?=
 =?us-ascii?Q?dHCDB9QxSxb/OzgzNgcgZ4bZ1cFBfPpHmZdMjxYqyX+Xf9fHX5Ijd49wrW6i?=
 =?us-ascii?Q?SusEzaM2gLz/fEvAzLow4oq35Ts/wtaBkrOgpgMQVo5t8KtnKB6bg14J/fUm?=
 =?us-ascii?Q?WsvsoSJDNQq8vVdP0ntD8bL1lPN4CnAwBYlD0ZCcsk5LS3DcSyjms9kO68lT?=
 =?us-ascii?Q?lMPjUzkczbhJHAVqemdaYHDtwGE6cFijj22OxonRNMXbDMyX27zdf3pmaMxP?=
 =?us-ascii?Q?HxRBeBD3olLUOQ0+6+pfsMXnQ6nX7nLUT2q638KsPUHHWt2kRO2mC2+OM6SA?=
 =?us-ascii?Q?4gbl1tXGyZjEbqLSPPQJGDpkevbh5H3JP/KRYMBHWYgAkiNyxTos9Azznoma?=
 =?us-ascii?Q?n7SfQMD9Xem4Q86uhOi/ykWTitGdxSbkkwg+9f3U3hJ+vNgTABQTnx4safeG?=
 =?us-ascii?Q?T/fxa3/Bq+7TcmOzD0d7ntTUKaBfZFU7cG3jGuVJwBIsn27A4DDynwcooum6?=
 =?us-ascii?Q?0ACcAmZcLlr9vbzlDmfVSP+6EXeUHgVKuOac8tJ56Khc4D61URNjowgrh/Pk?=
 =?us-ascii?Q?nJNcvEeizTpviDL8RtYGX24kmFUWnzC/82to8VuQZXWlBydLx3OCsxd9zK83?=
 =?us-ascii?Q?l8s/0BMuCzgqnkIXih9k+XqGrNzPT7ILloxWU2miHJaBVixu2uXnQwUyjdvU?=
 =?us-ascii?Q?Xx2QHu00NcRpWBEycvO2X7Jm4QGPv9BiZm8ylHbiHENWUhiRlAx9b+nQi3So?=
 =?us-ascii?Q?CCvSSsDYerOWcrcxb6bGFTFaoymqhm6lYCz1rT0X/Cq1TO4SmZKI9OrJPJoA?=
 =?us-ascii?Q?r4FcjnUodM/eutmIGI21fIIt7ZPDrUDFiseoHC3id6fk+u+nWSMGQpEHz9V2?=
 =?us-ascii?Q?h5a/1RRd2d2YXaAyJfuEjKZGlBSGnwyeKnnnKe1L+9Wv5SbKy1/VtQozfilv?=
 =?us-ascii?Q?Zx0IGkp0CXl+e7KDYNRXhen05DuJ21vNoN6V5/1NJ4Ig+pZshpLxdMHWxfC+?=
 =?us-ascii?Q?JZtycseKqov9kTOOBpFEaOY/7ZqjccObKhYm9r9wDqMwsGuCHxveId9ji5sL?=
 =?us-ascii?Q?Rdotksu1Jlq/owPR9pfRv+Zw98JTmWpo90RFi0At8Khe0x/u/R/IiTLDCU2c?=
 =?us-ascii?Q?cWefmUMWMTQataXfzqf4Xav3OTZsrt2mYlZZ4Bkfht20aWZ515c4T19MRb1x?=
 =?us-ascii?Q?Qa0PZGEChmLH4r7ni9m9uWypdram+m2zzOHcBj95/PL2qrRrsHiLZSuN+pl8?=
 =?us-ascii?Q?vBO8FzuKc1WfmQx1LW/mGFai?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5535477-2af6-4d80-260b-08d925d05223
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:31.2715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFb5UJIsU8d9Gy2CWu8EUFGeWkM+aN59t7MstfjuV47lMrnALVmh6EbtRpAG70OZXQX4/iA/UMFSE7tIPu97xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/uapi/asm/svm.h |  2 ++
 arch/x86/kvm/svm/sev.c          | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h          |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index bd64f2b98ac7..de977dd167ca 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -114,6 +114,7 @@
 #define SVM_VMGEXIT_AP_CREATE_ON_INIT		0
 #define SVM_VMGEXIT_AP_CREATE			1
 #define SVM_VMGEXIT_AP_DESTROY			2
+#define SVM_VMGEXIT_HV_FT			0x8000fffd
 #define SVM_VMGEXIT_UNSUPPORTED_EVENT		0x8000ffff
 
 #define SVM_EXIT_ERR           -1
@@ -224,6 +225,7 @@
 	{ SVM_VMGEXIT_PSC,		"vmgexit_page_state_change" }, \
 	{ SVM_VMGEXIT_AP_CREATION,	"vmgexit_ap_creation" }, \
 	{ SVM_VMGEXIT_GUEST_REQUEST,	"vmgexit_guest_request" }, \
+	{ SVM_VMGEXIT_HV_FT,      "vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7d0b98dbe523..b8505710c36b 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2173,6 +2173,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FT:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2427,6 +2428,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2542,6 +2550,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FT: {
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ad12ca26b2d8..5f874168551b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -527,9 +527,10 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

