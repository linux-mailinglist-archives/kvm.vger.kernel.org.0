Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A11398C74
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFBOSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:18:34 -0400
Received: from mail-bn8nam11on2062.outbound.protection.outlook.com ([40.107.236.62]:57888
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230359AbhFBOQc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:16:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h2nZyrcD5hcAreqAPvHB1U/p6X9N58MLhSPk4+iWO/UrMN+c10D6QKhgxMTSfIxdgLyqhju5xI8eh2wRG4VCOD3oaF4dNi4YalzmWl/BfRyfmME1Qylu5cUXV/rOvmMvcnk3kLbdVCmItXyKuMeb59akbY3ihaYqsBLJo+MsgE6/qq71HgGHvzY8ggLWykd/pfH/3W2qPfh4PfOlg/GIXNsJyWwdVR47/3X3xH7qJ3GugzBB268NgarHy0b1h1MlW8A773FxCmjDdVulXjaCDXJnVRpKYT+GQo1XyQFKxvrVmEgJFz882Ve+QvHr88oPH/IgKs0LGC01g0ghACRWKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFpeNdFjUsH7IwLUh37P7htqdthGpK5Be5lUjePfE7w=;
 b=DofFlMQxfzf1CNqxytVhQ5vCAPyJFWpFNrkOfOtb7TA/3HEUZcs/GETnNz6pgoO1l/Y81vapjXw0i7kHo4gS+Lw533yyBahJC/+LXOkdkTL1iwXkr5zZcTrkpAaogW7HQ/60C9t8WxJ5Vkl++bQ6Nbpufm3OlBlquQ3F9BnPARzQolR0A53F7Elm2hh0SNfHY0ekmREstS8lgq8HzDpAQSAaMGja2lIAEs9kxjOJfQcnsvk/gbeloFxQ4aNanBtj13f25mrfuPAH88Jo+MJoOmwxQuBSI4MfJz+RiJ4cNrV0oujF9d5d/ryFmuRlb0x0ywI8EBSJarCodca5mUAn2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MFpeNdFjUsH7IwLUh37P7htqdthGpK5Be5lUjePfE7w=;
 b=avgADYZCNNN39eN5TGJCXzkElXsCWWtff2afbZ2hC2O7BBiAMVrI5+0MOC6WtdWxcoKMUQ6hO58B9JQTrabPAiaj8yxRbkHnKaKZpsJTa66S6WnsLQY8zl1qNVlptRCxfYnY6LXI+f8aTW+Vh3uMw8ztUIFdtHFKejEpjBK5xQ4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:52 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:52 +0000
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
Subject: [PATCH Part2 RFC v3 19/37] KVM: SVM: Add KVM_SNP_INIT command
Date:   Wed,  2 Jun 2021 09:10:39 -0500
Message-Id: <20210602141057.27107-20-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53bec168-42cc-46a3-c2f7-08d925d05e90
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368170C10A903631BF3B3F0E53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rp60OCQucj1PsDZ4YxsW7LgWxJH8O5dtMG6A4Z1pRa3qmSrHOJoFY+8IIEyHm08k407+V29uryuMyoWoePoO+D4nuW/sB8C7xT/eA5KzYEXooO0Dq4XnRfve7qvXVATE+TnYY1R2TGv/QoGTGWgoK5kFY+Kg66KLL5SBSD3WRqjwFsj0uwIDEsNcksJp4WKP3gVEGYhMzBuIB8LPfG3I3x/gaw0MRolmv/8f2HSM7lF0OuaQfu/m1El6R3l3IjjMt/wwb9aQ9Y+8WP/tqHrjZZozJG4Nif5hBiI+WDVhy1d2F+HNZ6rUQVKWY5fICdJmyhLshtm4r4NDRd+LB/BdcOZTckjXhU/73b0+vdPLW0xoXMyZlxazhHH9POCEuShJ6JrB1q+nuhzHa7b1d8CkfYu7zsJPme6wlkOXB8K0c1eA4uVX+GejUHLQKnN3kvtrN33ljfag0mCHFXx/2coayCdznoXTTa3v1T5No2EhpLAIR56goStHZ6gfWhbPzWaoeygLhnMEic0KoNfhxgwuxI5Xrdpz/4p75iD3g3JEte3vU2NoPQmE5LugFvEobC27Eq/IBVHoBA1pwjAmc31K3C1+cTO7sJiF9sTvgQNXMbBPkgQuFSxN53fY2a4tjPRwoViD60Eh0P8mzTtV2QiOhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Ayao1/BVLSzGZbmgJ5E4B4/JMpbHXKHKkz0qDfI4GHUo+qr8e4dwL957lBVT?=
 =?us-ascii?Q?K5OMdq9zqcJn7ExV5B3tvZwyLXoFS6DIPZq+juNsFSmD1d2Nb/aIn5Xiw8Oe?=
 =?us-ascii?Q?SSq3qmjOOasOJPxs0Q8q+Gp4NfTWHwArB17bosYGTyuA08SgzGKE+oPPJiFn?=
 =?us-ascii?Q?CXEOEmWyKEJez+GEf4qQ/zq990/t5te6+lWd49ZxJtZPouDBZKKmZMcQEtQF?=
 =?us-ascii?Q?Jtx2GRod32NDSQqWo0sV4JRT3CmgAA001Hw9GLte5x3lf6jhyLkMZv6XxAbS?=
 =?us-ascii?Q?wBKyO13qghksPIGmu0TlDFYjFMLryaX904WW3zyCllbj/ukZ6tprCbAtMflE?=
 =?us-ascii?Q?9sxQIMu2y/3wk2e6FCbKUQdaX04uTEiLWQakHE+vcT2WUurEr0QpLELvc6mi?=
 =?us-ascii?Q?FMGiIdvFPSeW7ApRl7khs6c1HzANwTTl2KINbV6VjisT79gG6a9nKZUk3Kk5?=
 =?us-ascii?Q?cy2FvV1K2zCw5J122WUGsETX1QymqqNRHmCxOd83XWpQ5dgjg1/7t+e0BMAJ?=
 =?us-ascii?Q?TI6KVfVW0Rtd2O0TxGZVrsEozYbIRRLVGJCsC+AyqScCTvy4X23TkBihvVyF?=
 =?us-ascii?Q?vSYghNvq5k+zznPMQwCCK+lzqSSyoKIhYkznO5FMYh6OIJMYYZ5aGl9ImIW3?=
 =?us-ascii?Q?prp4KrfOTqctFBWQFwUb9PJx/eWQiA4xgy9TO1RyRCcbW3SRWW/AAvi4+Z3x?=
 =?us-ascii?Q?BMJiKYWbVetC9x2o56SA2oSy3iT/e3yJNMJA6p+CxS4LGMtA549maZjX3b8u?=
 =?us-ascii?Q?BS9sYf5J0un2NChK/qaSyuCa2orc7jzkghwtkLxQigd6zWC8nxgyNv11l5hD?=
 =?us-ascii?Q?LnHN77NZRuM35aC6wlFlDVNsBi2eCW9SC4fQpoeYvwOPef4vv1HhM50hYi3B?=
 =?us-ascii?Q?y+qrnC7WhJ66OELipU4t7yWaSMUXrdytd/tl0G8N4ZKo2PKnbrOtbVLrUsqf?=
 =?us-ascii?Q?5MGIryFKtqfe9/zLrqkhRhV8E/Uv+BZZcj8rqLpC0b9ymqKL/oYhUHUTBbmG?=
 =?us-ascii?Q?CGrHNrWFWwc2miAgxEOquMyqmyCAPyC2i/U3H2WNc11Smtx97qcXhf1l/jwa?=
 =?us-ascii?Q?e8HOnhjs0kTPp0joB7SIQt30KSl75zrtGHKwBqxQW/js92zxpoI+qezIYmyS?=
 =?us-ascii?Q?37faj6oQOlF9+TStWIo89U3FjOV79j3FLXD2QXeecDXFT2pOhf7s32g8enIT?=
 =?us-ascii?Q?zIrNIHGTU3ux8bzWVuDymSA9rDD3bb8mWEpr6fvF7cJXhtIZdIPUPbiMnzkw?=
 =?us-ascii?Q?DUy499a6XxyzGlTZEJkSlqOF0f58aEcEI4qoLSe+w6531P62s1FpLopNNwgt?=
 =?us-ascii?Q?+Ow0u4EjadN5oG3wfS9ppbeD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53bec168-42cc-46a3-c2f7-08d925d05e90
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:52.3254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHN1+VOK/nFwzPm1Uc4wrP5YGEmosM/PrdFmfG0Nsv/cbsfXPox/CM8jDsgvJ6kG9oCd/3D/IVr7xPJ+R3ZwQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be the
first command issued. When creating SEV-SNP guest, the VMM must use this
command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/svm.h |  2 ++
 arch/x86/kvm/svm/sev.c     | 18 ++++++++++++++++--
 include/uapi/linux/kvm.h   |  3 +++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index b6f358d6b975..65407b6d35a0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -212,6 +212,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_NESTED_CTL_SEV_ENABLE	BIT(1)
 #define SVM_NESTED_CTL_SEV_ES_ENABLE	BIT(2)
 
+#define SVM_SEV_FEATURES_SNP_ACTIVE		BIT(0)
+
 struct vmcb_seg {
 	u16 selector;
 	u16 attrib;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index abca2b9dee83..0cd0078baf75 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -230,8 +230,9 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
 static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 {
+	bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
-	bool es_active = argp->id == KVM_SEV_ES_INIT;
+	bool snp_active = argp->id == KVM_SEV_SNP_INIT;
 	int asid, ret;
 
 	if (kvm->created_vcpus)
@@ -242,12 +243,16 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return ret;
 
 	sev->es_active = es_active;
+	sev->snp_active = snp_active;
 	asid = sev_asid_new(sev);
 	if (asid < 0)
 		goto e_no_asid;
 	sev->asid = asid;
 
-	ret = sev_platform_init(&argp->error);
+	if (snp_active)
+		ret = sev_snp_init(&argp->error);
+	else
+		ret = sev_platform_init(&argp->error);
 	if (ret)
 		goto e_free;
 
@@ -591,6 +596,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->pkru = svm->vcpu.arch.pkru;
 	save->xss  = svm->vcpu.arch.ia32_xss;
 
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEATURES_SNP_ACTIVE;
+
 	return 0;
 }
 
@@ -1523,6 +1531,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
 	}
 
 	switch (sev_cmd.id) {
+	case KVM_SEV_SNP_INIT:
+		if (!sev_snp_enabled) {
+			r = -ENOTTY;
+			goto out;
+		}
+		fallthrough;
 	case KVM_SEV_ES_INIT:
 		if (!sev_es_enabled) {
 			r = -ENOTTY;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 3fd9a7e9d90c..f3a86d3a8f04 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1678,6 +1678,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT = 255,
+
 	KVM_SEV_NR_MAX,
 };
 
-- 
2.17.1

