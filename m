Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB4F36FA79
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhD3Mjy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:39:54 -0400
Received: from mail-dm6nam10on2058.outbound.protection.outlook.com ([40.107.93.58]:15105
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232154AbhD3Mjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JuHEN5Cmh4qr0YsTRDup0+OxZJbEKsHPPGi0cVQiWtpQibFwp8EEoGO6rUuX4vYVmU1vWmbiCF2dV2s8hbtT0AfvU9KLzm280K4FM0ppseqaTwwcopOzGnkWuFaVGvLjMY0loBmO9p6lWEFA52UIdYWgRE2o5ZNWoyCK569q0sKJl/wspwYqzdACB9rV8GSGDLye2ill30P0My2nGG/xN37u9Z/dFfSibxW0ncDuPnT5WSLsgfHshWyDt1lbgyJVwk02oqGW6jvdwQpqkYNTckLm9vuBBdaHtm2w1pxmIH9ZlaBlxqtNlY2Ws75Iv+NeZlpKB5bza9pkMkgQkYAgRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vWNdGBWM2hCj6xfJeyYcH3m9kjbKolT8k9WpVzLQWk=;
 b=EE7qz4+vAw8bJGQbPeJ//M29yDkhJYWxnKNtJWCHVFGAeQ7SoY499EUTiCXfDNtlVNJEVBmxMcISab5BsYidq2EvukRQjHx0nCmyXyyQhMWiCSK2I93LjkuHFNtPGEF2PyeT6GC7iOrzMenBVf6H1T6AapodnF6ss77bsWfV/+id8tWNnA1G6IT2Fltw5nuG3hwad7dKnt6XQJhAoIu5cRuTz1Qh/giNX6Xi6AKzLx+n69VwJxgn8N4pwSXsICzTatSRhdwKyfDss3WPj2hpGNPmc7cic70CkGTSqyR3usgI1u1tmbPx1jfblYOKSombRIeyfeguylkAABxQSuGEBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6vWNdGBWM2hCj6xfJeyYcH3m9kjbKolT8k9WpVzLQWk=;
 b=JXQDRDazMBX5uZfUXiSZeX6hnyzVpeP/1euJJHriIIZpySP4QDY9yHsh42T8JVe9jS9SKo2+gvKa7s/AA3ByD2IGaVqTmDDMr7PnvtaW9d3UnH9Vo9+1DhApDVcPrZblDvpU5+fg2K9cgGE/OzWwK5CFV8kJ08m6UAlYPrEmWHM=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4511.namprd12.prod.outlook.com (2603:10b6:806:95::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.26; Fri, 30 Apr
 2021 12:38:55 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:55 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 02/37] KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
Date:   Fri, 30 Apr 2021 07:37:47 -0500
Message-Id: <20210430123822.13825-3-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bfe5bd9-235f-4798-bda5-08d90bd4ead1
X-MS-TrafficTypeDiagnostic: SA0PR12MB4511:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45118A54E0733C8085FE0571E55E9@SA0PR12MB4511.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMENVWqfzfPkx9oUVrLhIU0lC+7DMzI0/0TQf3cYj4t7oSXicbi0GsCwehwNU0Z3QSPKq+oyKSrtZIgzrF2IvH699tEQikOZmb1t/4K07zatH64/9RrpHzVlEcq0cEdvEe+97MvK5dH4vvf8Y/PWhs/rIA00Y3dA2PomBICjOWZXMOXmdMnEMjbvJgft9CIYGd5bI1eyYq8xy7KW3xulLzymirmdFwgLgdX7imm0Czad1mD021IzBIYzf9T2UvhYVggeZrC4Jf0kPZMiW8LAqz4uFTwqOoZnNvI4aa4iFkFsO3akmE02xnlPD8O6AhbIA18SV1oPMjNghvb/kabZnQ8UkPgMLptOQeJsXYy+Fsv8iZM8jV8ZS/2KBnWvFtUUgb5sRGY/HGuLJmuTUlTsxlcATeuWf0sVln2WmP4q8Bf6AaBOXb3ddPC1i/LVS/rrVvg4YU36/Gk1B2+tMte2RyE0LOWAT3w/BmYvNuj1lrjUTJMjzbupjabDZZwnf2DBAtWdYXivLP5jXErzb36OfMnd2PTTLAoGQznJfYA5TdlfK/3vmg+EdD2nsm5N9dNsS0qWyu22PAg3gEgKwkEz4mfPgBGjpq1qN3UcsrZXN7PyqfrfZcoQDmSypL8F32gjWqSLUQwju1BnZ/z9lF9tPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(83380400001)(36756003)(8936002)(86362001)(66476007)(956004)(186003)(38350700002)(16526019)(6666004)(6486002)(44832011)(52116002)(5660300002)(38100700002)(7416002)(66556008)(2616005)(26005)(478600001)(4326008)(66946007)(316002)(2906002)(8676002)(7696005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?RzWF9IN0oCVUEqA4gZOlssNeL9qkqgfCuc+rpxkOJENK9U7LmupzJb1Y3M+4?=
 =?us-ascii?Q?OCNGa9RT20mbs33SYSEp+mO4pQkYxvf+i6aUtvFwcGNg5/mE13u+u/aNFkkW?=
 =?us-ascii?Q?0LsQ7379jk25zd8dgZzIofWTUso0KZRf8syPZjFicij91p9KpvAsSVbFu+zC?=
 =?us-ascii?Q?0uiXskzNhnGArzfoVw3c2cqXjAm3yhiluVL0b6j5Pol3O2IyJI7fsucUnTjl?=
 =?us-ascii?Q?Ctte99XxWl4PiAbMk0H/yyaeKiHWBZHHSiHZVlsQ7bjggcpo4NUxjMrINQQD?=
 =?us-ascii?Q?+0mea/5ljrF4jsryFuMyDx52m97dliSFW153GkQapzh4dsSFHRYMdZXoTkIx?=
 =?us-ascii?Q?fj4ypJj/3MOPx6US+XMZJJlNSHuQ22ni8MlJc0mtT3P4M6VKqbJz0lRTmjXY?=
 =?us-ascii?Q?06rjiytZCjKt/7Fi9rw+H1y1ci0APGPraLAiEM9PzoKS38wCMa56oGONbwM/?=
 =?us-ascii?Q?KK8VfiAiEsXPGFdHQv9BVwbGKBZ5KMOnQ/tRNTxoIvh6a3tu8CJtii2ywrnX?=
 =?us-ascii?Q?HetjF0llusSMgv/jZRR8+hd8GnLfMrbD9rbVrngDe7RHqAmS+6jXgvcox4Mg?=
 =?us-ascii?Q?sj78SggUC80hFeeRmbxTIKNzmqMQBUAj4eF20hb0ZHZ2723kU9M0MKKkfUZ+?=
 =?us-ascii?Q?GaKF171KCSqGY7ezwlgCF5Wnji69Ar4r2LYFo35wsNjAyEp9pm90X6Bagih2?=
 =?us-ascii?Q?ClbvrMu0ZSJrhCFhvyzOMekWgBXSOEFv3EhOotZJvXTf5nMi2NaVZLEzjJwF?=
 =?us-ascii?Q?6qgTO5FW3JMpRC8GXnqH927pyQrOmWjLB8Y/jE6JO+t19LUge7b/RjT2cp8N?=
 =?us-ascii?Q?DmWaRNft3lF/Lrlt21fIv1WZKC1HKP3acg451a70KafUYZWzh9t/irxu/0t3?=
 =?us-ascii?Q?0lUzzy4fOhaNh54KFu0OWVHzI0wbGTAa57GkxvTbOgruUKKRPilPrff6CTMT?=
 =?us-ascii?Q?lCGNjP8sI4Hd2Ba+AY/Ym5Hf+lKjc6e/o+a6MsQnDBH78/JD6lWWf2ZfgjbF?=
 =?us-ascii?Q?d8HhqGPUzMiGTqmbaEVhCm+nTLzyEfmm9h9yaDlP1a5FsyfUIKpVXXuTwUQJ?=
 =?us-ascii?Q?yLwFP3WNFNkCmegyv0mA4GvNAap+Q0zzAp2Jgk6rwyEHAMlZF9ymCtkVReKX?=
 =?us-ascii?Q?2WRtTnAzFkAQE4Zkn42kBxiUtac9RNV820BDgsVD9zUen9wQfDmVirn4+bwn?=
 =?us-ascii?Q?lyUZvrFdoXG2En1aV5Iz9fOywNlvT8KwE/0gM5eR2YHzmyqzqkYDttbwySaT?=
 =?us-ascii?Q?QoG+QffQGsIxQltoG05PYs12Zd45s6WVYu0m5s0jobr1i6zqsxajPjQnNTpe?=
 =?us-ascii?Q?SkW32mkIFy/+qkQ4cZTJ2q9B?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bfe5bd9-235f-4798-bda5-08d90bd4ead1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:55.1951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RsoGcWF+h6A1DONec13D1NAndZrw9xwVQd9ohs81qpnHjC6ilwCYSxLOKtlIK1/KROfuzEX2vnVVCj7m6XeoLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4511
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports the basic SEV-SNP, advertisement the support through
the hypervisor feature request MSR protocol and NAE VMGEXITs.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7bf4c2354a5a..5f0034e0dacc 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2174,6 +2174,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2431,6 +2432,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FEATURES_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_HV_FEATURES_SUPPORTED,
+				GHCB_MSR_HV_FEATURES_MASK, GHCB_MSR_HV_FEATURES_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FEATURES_RESP,
+				GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2546,6 +2554,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HYPERVISOR_FEATURES: {
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FEATURES_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index dad528d9f08f..2b0083753812 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -530,6 +530,7 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 #define GHCB_VERSION_MAX	1ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FEATURES_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

