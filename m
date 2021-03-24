Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6398D347EAE
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237199AbhCXRFr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:47 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:41848
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237050AbhCXRFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:05:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/boGn1todGX3/Tc7n0xZ/hjJF7ABJRooS/KfFkiyFxbNMC6Of5mpRnnCtKnA8K7yGUKlEWnoyOAPhDvrC190z3Agnvgj+Xiwg++0hQVJvVGTD2uHwgouz8dC1/QqwO5vL5L1z5mKx8ZNL6ggGo/NbiYwiHOVRCN6xtNF0XZziS+ZLRQaiazXPKtTy01s/29mxdsLLTF2IsdLmDMkbszQxA4IIYId3QZa0vkaE5FRw9aJcUWG4JdYEXDrZuG/d1ZpYifqqZ6sq7GzifAUUcllLjM7tzRlU2JFkf+FDs/h2tneKRjyZTtT9ZRlp9tAF6P8U3ylmUg6Fa430vkR5uzqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxkkNx83skXWaNhyaqn+dzT3KPwLhEIZshU8BEQlKU8=;
 b=QMHjo+GmVSl0YCKEggBYIQohyZFgnCN7RSRMl6nVa68vE2zOXstpjfpmDRtFGQQdaoxdrKiuk6EBNyfjUq8LaNZq40FZ8aRYO4CX58xHynffcxBDE0+rsHYc02MplxlOx1busCtLJgCoa4wN2PXSfTK3XICW2kEi+QcQL8PHbcmPjFj5KFcOnarcIfvZW69M7PZlKP1ujPOf4tc+KMygDLBucimqNnCMAc2Z/xLMTkfHZnvAeclkYIJBhAqe90Rj6qjCeK7ZSprT9F6m/OV+lDj2ZwTceCVBrcGTNZhTPwDpD7rnp4rpn/SyEc80J8Rw0byxKt66Kz/9s2FMSIriqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZxkkNx83skXWaNhyaqn+dzT3KPwLhEIZshU8BEQlKU8=;
 b=zGHWXBJavnY2VJOZKh4eNK39ZhOyWtnxf71vPADSJm8U5fCDeeuJNvBExD4g5M2tZT9W9iaNsilkmDhfil/YaJ9Qh/gKtw3O7Fp/OiBc/hnJ/ibLBRfb3jrvsZpDW7WlTUK5AcCjWoZUfBadqnGANbjD0dmIMcYAfwiCshcrfVM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Wed, 24 Mar
 2021 17:05:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:05:03 +0000
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
Subject: [RFC Part2 PATCH 15/30] KVM: SVM: define new SEV_FEATURES field in the VMCB Save State Area
Date:   Wed, 24 Mar 2021 12:04:21 -0500
Message-Id: <20210324170436.31843-16-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:05:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d69c3d58-410a-4fba-5bf4-08d8eee6f718
X-MS-TrafficTypeDiagnostic: SA0PR12MB4382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438205BE311303A3C4BA346BE5639@SA0PR12MB4382.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pqaak33wi6ugApwc/tDwMU3GDwykygInayeeeqoHNGCvjFSlox2FQrRPs+T0m7K95T2M4EvhsY8Td+9O9cgcSnFvwXei9HkXwt+SmA/wRw4mJ+sFDBV1DuCuW7b6Vm1FJ3WA5AA7Z6KmbYM951aMXx93GopSs+wc0n0kPEjARbRGEDqeoKlGmNOJ7+GvO9JpMSt2RP522QNXucbKPpVk+p9S3wmXfvof1e3+zZ9BUnCAt0IGclI5mltooFEkzdQ9PVeNNcSMU949ZAuj21Sx7AIVts7NwxjM2oSs5OOITfUxrio2iOnKZwptDugqg8gv00X4X+6tPo7Rrj9zWNAnnNf8wVVlegsnFlBVVW/P4N9PN+Nh4WL1tQcu0Onv3EO/IgwH1/7g4/Nlxjzdi9OpMqq7cackW1z2zS9PlsuZejlKnao2mURJVDIrVPruEm1DthCB2JsqlQ4BvccEVr+QSRcemIqB50ngY+bkfRD4peT+WnC1iXvE2iNln0NsqKcrfHk1jihkcp3Nn1oOV3UoWXrbQYpQxnoVHqjwx3yDDXE/HIPKXu6vxWdiipDp+sTTmcRX7g8QHyZY1kLzBcD7pLONqWZN5ZuMbb/NUOv/xFZMm7E9Wu9iYzTRcNTgLC9/qWql2FxjwhI+kKSYuhN1xA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(6666004)(44832011)(66946007)(1076003)(66556008)(66476007)(956004)(36756003)(478600001)(2616005)(83380400001)(8676002)(2906002)(8936002)(26005)(86362001)(5660300002)(52116002)(7696005)(38100700001)(4326008)(54906003)(7416002)(16526019)(6486002)(316002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?18WLDIn3LbTvT/R2AsTnCEm7PKSBKzf3bmVWNMMW+3AqPI3zS8QjCoPfEG8q?=
 =?us-ascii?Q?OOeuJ9UHH6vypJKMiZjswEkCkNDLfIrLDvhMDwE4PG5yiNuB+9l7rABdVt1S?=
 =?us-ascii?Q?sN2mBR/7gzOcCL0CN7Jaa3obEovVuFWS/dBfkTRCMVDOfkUWSabJxNGaYtmr?=
 =?us-ascii?Q?vMJ12MbJuc8Zqm/WDEjlWTjhRgPa7lmdP6aGUcYARnopfvzp1HTL0+BChJUS?=
 =?us-ascii?Q?r3Pn4RFys4yZJSBHukeZ3wYoeC2OB831lnt4BthAcHe0aTFxgeLIyiknfref?=
 =?us-ascii?Q?T2Ag76As3mYyMM0LstJihNCSxP2NDuvp8i+SibrzGnvEcuesqmKYIBDiO3ma?=
 =?us-ascii?Q?3d6vVEhLi2Eq1XnXwhQIGjujWdhd/oNsDGJvXHfd3JVkNr0L0CMg1y4rSuXL?=
 =?us-ascii?Q?9yD4KZaIy3LBxcPMdzHD+lDJulfbXZvbLqOioNcKtZfaUYQZOTelAZ1XGiYP?=
 =?us-ascii?Q?6dico92t8l+BLNW6WftfrCOVkYqOxp79ClCCLptNIqzHRB+KWfY1lieWA4zu?=
 =?us-ascii?Q?dzIFX/p7ogk35ouUC5dhqcSlCPmlLEKCteQ2+TMxv1OeKKiht5N/2poLOmtx?=
 =?us-ascii?Q?UwdZtSZe0FeNU3ekvNtkwIRW5egg+zZWXfYFfGGvHkWQ17aPebAEpKEflWK1?=
 =?us-ascii?Q?lapkQFYCzR2nrjKzM9HVBdVz5L/dawkZjTDlk8gwr4D1rsKiLL5HbZgy9RcR?=
 =?us-ascii?Q?E3L4F5zqmiZ0soi1uc36gDaqiQo3jAWxArk/B1dDrEGZ5APJQYO4GfC0wnzw?=
 =?us-ascii?Q?M4xnbdAj8zMI8YRcYmYq2x1JZP+xQieUFPN/VzR8zHytMHdGdTEFb3m76web?=
 =?us-ascii?Q?8P/W8MaDTO4AtF6SjrOENVR/7YzsnYKGUiSb9qQcfjiqUHYYi+fnJ5j1OFhM?=
 =?us-ascii?Q?7oiNLF+ShpVVleOqKuwsCVZYgloBhrcAL8XEc8+Xl8vt+VoLI/zorHCnjf3O?=
 =?us-ascii?Q?qlvIelxNph2rOMDcRP0PfQN75LjwhQlFy2XTpkfaoyIwyRDOmckC3YQRQ40L?=
 =?us-ascii?Q?lEbqznTTKWTCRxzDCX+XoHdUB/Z2vw02ue9RgQkJODzelp/JlI/PFq2ipjXH?=
 =?us-ascii?Q?3Gx0mc6QcvDPbJpYc6QTyEwQ2++YsN8w56NZEMSVi7FyQl53qnvSP5/T1xhg?=
 =?us-ascii?Q?L1SPx0yShDGtKNsBNFFcPrd3DMPsKVIKOaJH+JyaTS9F1Idt7XcvvMt5FeFO?=
 =?us-ascii?Q?cAmyTH3jIRMX81nLzkSt2bUoAKJpIIWY4MalWV6UhBeBGOyhTeSOH66LBhtY?=
 =?us-ascii?Q?Ke8Ej13sIP/oiScqFq7orpT5+UqOjX7N4QDA2MMbJSpw6x0G8wqtk5vbwsuo?=
 =?us-ascii?Q?qSE1s4ojQdx9YYttCsPuv9Ko?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d69c3d58-410a-4fba-5bf4-08d8eee6f718
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:05:03.0301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BkPOntVO2D/rWODHJK2FRQGB2KY8zffy/vtIplas3DJrgcOgPzUlm/JKASJdsX5WtYSqKaQ2ipy66pFIvU7kJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hypervisor uses the SEV_FEATURES field (offset 3B0h) in the Save State
Area to control the SEV-SNP guest features such as SNPActive, vTOM,
ReflectVC etc. An SEV-SNP guest can read the SEV_FEATURES fields through
the SEV_STATUS MSR.

See APM2 Table 15-34 and B-4 for more details.

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
 arch/x86/include/asm/svm.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1c561945b426..c38783a1d24f 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -212,6 +212,15 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
+#define SVM_SEV_FEATURES_SNP_ACTIVE		BIT(0)
+#define SVM_SEV_FEATURES_VTOM			BIT(1)
+#define SVM_SEV_FEATURES_REFLECT_VC		BIT(2)
+#define SVM_SEV_FEATURES_RESTRICTED_INJECTION	BIT(3)
+#define SVM_SEV_FEATURES_ALTERNATE_INJECTION	BIT(4)
+#define SVM_SEV_FEATURES_DEBUG_SWAP		BIT(5)
+#define SVM_SEV_FEATURES_PREVENT_HOST_IBS	BIT(6)
+#define SVM_SEV_FEATURES_BTB_ISOLATION		BIT(7)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
@@ -293,7 +302,8 @@ struct vmcb_save_area {
 	u64 sw_exit_info_1;
 	u64 sw_exit_info_2;
 	u64 sw_scratch;
-	u8 reserved_11[56];
+	u64 sev_features;
+	u8 reserved_11[48];
 	u64 xcr0;
 	u8 valid_bitmap[16];
 	u64 x87_state_gpa;
-- 
2.17.1

