Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D083F30C8
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbhHTQEZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:04:25 -0400
Received: from mail-co1nam11on2046.outbound.protection.outlook.com ([40.107.220.46]:20576
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233982AbhHTQCT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:02:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArV77KibKTduxMpFBcPohCQxOzDVfJicE4xBsqWEHOH1q1JJWyeJSXsRvYujojqXfkXck8XNlnfrzh1B7g7xmlgV+ievL7y7QXkegpeoz7giDLDRgzPE5PJXDv9MOKu1NYUDE4T5645gey6EsLQw8XsgmBqlk68weBcGQgZtZPPy3xIqnPmIXICnw4Yv3xFqVZoEbJ6CSoG8r8H/fuWZOdFemegBqVM6k1RJD2ks8H/N5ArLn8cpXc7D7jAcqccei8K704Rwv/a3IZbSu9LHqdGiLxhl+nc3OZGI/WhxfuzTCBkaskeJgn1J40WX3WSChA9oTtj4tsLMUNGBz4iKrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CP8qfEvGIazB1gj0yyE4zHcuE1pL+F4XTy/w3EoGe0=;
 b=UUtlzAN94wAgXDAmHL8cjm1GODNEwXURq8kS/KEm+RtOw9I3kg0ChKjXW2mT65lFdmyYQM++F4A/LnfLaWu3OMnsYOcLU89e3yvsnZSA1pOSjphmFFcZPju2uEewKdilWHSrJYVBjPPbYNMIzOjaA36RAwJdJkgCe+7lj54X7Vy7r6PxJIjiW3SoByuqN+veUdDWfrw5zNnfTr1sM/yqEnEIGzAZ0TVt5iQnmQQrz5+hV6H6GXNIy1Tf21Kaya/Vc81RuXnlN8ngBumP9YskAuVqzAwLx6iNt80zWbqo+hSvypNs+9keKPjduMjEr9TwGqz+2uK9OgzXJv75jk8RVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9CP8qfEvGIazB1gj0yyE4zHcuE1pL+F4XTy/w3EoGe0=;
 b=yUI4jy3GHP5Z2bcBs4FyMYyW8TNucXJU2psuF9jemqjY9iM20nZCTaIBXFolEJMVV0gO/hydpAscxuWSgrcq2YzklQyXd+TYmUHBRYSRlLpbjrLe0Jm97+hn1tcuYS6DwRoHROtzgE41c3q1Ya5Bph56pffoe8Esz5Lbmn/oxNk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2685.namprd12.prod.outlook.com (2603:10b6:805:67::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Fri, 20 Aug
 2021 16:00:20 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:20 +0000
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
Subject: [PATCH Part2 v5 20/45] KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
Date:   Fri, 20 Aug 2021 10:58:53 -0500
Message-Id: <20210820155918.7518-21-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 16:00:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ffd8ed9-d4f7-4a90-50e0-08d963f39c1d
X-MS-TrafficTypeDiagnostic: SN6PR12MB2685:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB268579AA6AC8AA5FA1A6E5AEE5C19@SN6PR12MB2685.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oH4LqYNcXHsrSfRphfGhOobjmIVej5zzEdq3bk9zMJpCWLLwMqDcobBMti2QcvsxJ+uqOXFjY2GrR7IxQKwNla5N2WQjay62bsLq7YYSxGxCC00GYTJBBynpKTf3Nh6T9BWGm5PCKh7A1rbwpRqJWUIWXWbyStHhNRHV6/gElrGtc8DjMmUeuczlNYCA3FHizhCCm33I8bYkyIIpldcUftMu5n3mZwZ2XPdigyQI9IbV6LFxwtvfq62AsZDZriyl4JCAa0WnXC9RVLiaf8asidoKdHmYVGwsLUOD09UamzpaNN+qkMzyIn7i9ACvje55bk5ZhEbqmCfEtUJtV0pAzptpaOBvVS4qg4Wvnml76q9rpN6gpyvsYYFLplCbAfS3pqY9BorqDfFblXy8uKEJP1zB+3dS8AavCPeLDj2yWXKKtYvgEKs1U7i3zBOvN1dzkWd96+Gnwrn1YfqpDabThsKtnV0Oq18v9oBveVhP+xNgkuiGjmmsErrlUuj9Q0qKmL0S3klOWXUTT1hG+QkV+joHu2BiM6tJF9DgmmBLaxXZnGJUmxNbZ5O5UjOj4OZe3W99GpfKlUQUZkGezvrFn52IGzoouwda60lhlvDrFHcpgB9BZbhve08MXuvlHYwYCHBHksjBFbbhQI8Z+GkISTMpPiNW/+XCXkCCuWAH2ZQHmGn+0vyHXaZVG2iCTFC6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(956004)(186003)(44832011)(2616005)(26005)(83380400001)(66946007)(52116002)(66556008)(66476007)(7696005)(7406005)(6666004)(7416002)(1076003)(2906002)(478600001)(36756003)(316002)(54906003)(8676002)(8936002)(5660300002)(6486002)(38350700002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rqt9EYIcgPJrYt81HRwD+VfK01Qk5jhENkN/lH8iE4I3CXrdm2rfkDQxMesp?=
 =?us-ascii?Q?UApmTmgjURn2vEMO1XEyfDGZ2ewFLMzj6vE1tn2SH83A1D6LqC8hmWZBKVSM?=
 =?us-ascii?Q?/cgqfuHgw7hLhm4QEmw9qJEcY1atAeFfx3eBCMVjR5ozcy2n/39yjSv/g2CR?=
 =?us-ascii?Q?0W02qJKR+56m2NWUOw9WqZAIOAXDcScQo9SK/fXV9+n+Pp13YTjOZ1iKTBfu?=
 =?us-ascii?Q?O7aAO/gbhvEBnPO3yYigo2w7Aw6lJ37GWkRlo3srTuDSauIB8JaVgUz7wsoq?=
 =?us-ascii?Q?nexknThnoSwtcxMrLnVz+B/iYR+Y8tJb6Z/48MIKepzPN3te3Yrv7BEd9MGH?=
 =?us-ascii?Q?ofIOn/tFWNvkdC7MnnNG1McwuEUjdS3lDjJO+cToVwRMBSVZxkbPeq2f0VzD?=
 =?us-ascii?Q?bi+CR+SisCIBDpCqT1mdjKThHrFBf2JCEOuMsw07YM1gUEkiv3MoISUFc9P0?=
 =?us-ascii?Q?lCBRGI8ImjX+xoSyh1JuZYI8N+toCaCi1IgJW1sqPxJ4W9uvl9+xZd4Twkqb?=
 =?us-ascii?Q?FimOKojCeM4OXraO5ms+SZMrzht8Gzb3yiA9NDj1C3/7hIuaYnuwYdbK68QL?=
 =?us-ascii?Q?i7RT+A7KSle3nXmCYzJl6h9U97Nx7m60dxYiMKCjryWt3WYf9cmPvOM15Awz?=
 =?us-ascii?Q?NN4r7gD1aqS1Zy338RYoI6LJM5edtnsjV8GkoHyW657Zth5kp1wbkrNBEZwl?=
 =?us-ascii?Q?XdN9eO6RsVE66s4fAfYbWyzpmKSjVzoOgvuFGe953b76WvQR9WyATUIoxoN+?=
 =?us-ascii?Q?K+A9whqFCNXwfXyGsAhbh6EceJN7/83V6Bu/R2bmtwuNomZanrrjvgBmumUy?=
 =?us-ascii?Q?jXCOGOpRKZtPtdyadtFT+wIMN72W/Jda61n0NFwl72gsOVAOCkDxymbHwd4B?=
 =?us-ascii?Q?Rur4B6clxKf7IdjGMx+oWYNXathHC1SEsdiUsilLEwKd/M9k76PMX9OV9GLR?=
 =?us-ascii?Q?2DjMMq81MIQ959FTgY2gQs+D/NE3XzhVcusWfQe+oe0jb62KkGbDh+vHk3Gs?=
 =?us-ascii?Q?5IPt1NU8z+IrKNE63jLJ/YdHEnCD6fNZm1cqgEoQwWw9autEXFOpa/lr9UmX?=
 =?us-ascii?Q?wKsGLeeUR2r5MPkmQEoG71Yw+qGu5HCOBzrypaQnpVHK+U7dqjbxZCupTTO/?=
 =?us-ascii?Q?JBsRRRCnAYB7m7vxEHrU1aV5mWJP7SYQY8unnpSxd9KEo/2LXWhvXUlD+tZY?=
 =?us-ascii?Q?RWfA1LJKY1+fhEtN2fYmRJEz49c3s/8qGwhubSLD0oCkWOW7ICxlnt87oxH1?=
 =?us-ascii?Q?PQn6o8Dk+DJZQCyWJsr6BR7Iag+E5wdn/oNgqAU3sCsxi7T/tR82n8Q6K38D?=
 =?us-ascii?Q?+kjTT6ez+zvUKzL3RHoLNzrU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ffd8ed9-d4f7-4a90-50e0-08d963f39c1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:19.8724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H7AWxP+L7UbtkmKgI1jxmYKrYvuhP0iDXOIWmIOa3WYKSrzpc30UfJ3NSgg+q/k4Fe/4D4NVnlJwxRpfchv5hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2685
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Version 2 of the GHCB specification introduced advertisement of features
that are supported by the Hypervisor.

Now that KVM supports version 2 of the GHCB specification, bump the
maximum supported protocol version.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/sev-common.h |  2 ++
 arch/x86/kvm/svm/sev.c            | 14 ++++++++++++++
 arch/x86/kvm/svm/svm.h            |  3 ++-
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index d70a19000953..779c7e8f836c 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -97,6 +97,8 @@ enum psc_op {
 /* GHCB Hypervisor Feature Request/Response */
 #define GHCB_MSR_HV_FT_REQ		0x080
 #define GHCB_MSR_HV_FT_RESP		0x081
+#define GHCB_MSR_HV_FT_POS		12
+#define GHCB_MSR_HV_FT_MASK		GENMASK_ULL(51, 0)
 #define GHCB_MSR_HV_FT_RESP_VAL(v)			\
 	/* GHCBData[63:12] */				\
 	(((u64)(v) & GENMASK_ULL(63, 12)) >> 12)
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0ca5b5b9aeef..1644da5fc93f 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2184,6 +2184,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_HLT_LOOP:
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
+	case SVM_VMGEXIT_HV_FEATURES:
 		break;
 	default:
 		goto vmgexit_err;
@@ -2438,6 +2439,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 				  GHCB_MSR_INFO_MASK,
 				  GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_HV_FT_REQ: {
+		set_ghcb_msr_bits(svm, GHCB_HV_FT_SUPPORTED,
+				  GHCB_MSR_HV_FT_MASK, GHCB_MSR_HV_FT_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
+				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -2553,6 +2561,12 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 		ret = 1;
 		break;
 	}
+	case SVM_VMGEXIT_HV_FEATURES: {
+		ghcb_set_sw_exit_info_2(ghcb, GHCB_HV_FT_SUPPORTED);
+
+		ret = 1;
+		break;
+	}
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5b8d9dec8028..d1f1512a4b47 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -548,9 +548,10 @@ void svm_vcpu_unblocking(struct kvm_vcpu *vcpu);
 
 /* sev.c */
 
-#define GHCB_VERSION_MAX	1ULL
+#define GHCB_VERSION_MAX	2ULL
 #define GHCB_VERSION_MIN	1ULL
 
+#define GHCB_HV_FT_SUPPORTED	0
 
 extern unsigned int max_sev_asid;
 
-- 
2.17.1

