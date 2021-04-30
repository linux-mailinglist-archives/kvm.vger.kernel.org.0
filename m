Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9DC36FAB9
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232911AbhD3Mnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:43:33 -0400
Received: from mail-bn8nam12on2060.outbound.protection.outlook.com ([40.107.237.60]:34272
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233348AbhD3MmF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:42:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6VC3uWX1/gcM9A0yXzq02g7Fp0Kmig2/yxSShtsTaumAsfoagt+BMdgfYX0iYC0iZM3NIO8DlQLbnnCFFwIZv479DH9WmPfi7dW5sctYiiUGordQcMgmE9G9QO3zqC1Cx+V3A1ide3NOM+SFF7pjlxAcl1KovbFp6xWkJ2x6t4gscVc4jTw82s04DKKFR+yWcDhM3u/X08qK5aEJ1JHjaWgoN6eQ2CtFxKVYTIZjBhhQKXnWczuVptpezayyGn6RW2svO9rUNSFQpa0VXetdtsv0fpyeotblRm5bvOwIX9EXnmq3Qe8cHVkLp5z3oKWnlWGIiYYBpH26ArDEJ745w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpZ41z5iwQYEDhEO9+u95WqpO0KTNQelmlqlOU53LXE=;
 b=SQnFnVveGE81syRRUdOowM3TVJ6WXh7o749UVhPprrdBtNmFF4fiyVSa/KsN86CX/+SxAZWjmH4RgQSX9Pvfc4mmEcdpEBpSn9wKVw4rrPjYN7gUYPmMFfwi9mMG+jijscw7YyPv/or6MLX2UphnOJJgYnvSS7Q1g869kR9vhDeqopdeVMTufOulvGUv31smBCKGh/S6nSuV6TOa4rECuzNARz/Y6ZeORn33wdcrJJvJEn7rPzDiUAaSReWaoTwtKsVVNjBhQxNFxv3xFld7Dw0HTmwWpqN59XzlUG3V9eBG0j82E3Z1U0GvVfPmU2YlDb7/AdxdV2gMxEFfzoEO1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpZ41z5iwQYEDhEO9+u95WqpO0KTNQelmlqlOU53LXE=;
 b=TM2DU9U+rtQlB4+igPuDwsXRLn2TP5K3dwEhk+Wzcvz/8DMI4QIWZqUmeooKkmHqD7O+F4V0NROzdkM2jSoDeMXLrgJCmQfBsZHFhZ/+vv52hAa8H6Uzh5fOo8KjSu41jghA0mJHWWaSKOEvI9/VqJdgVfFXYJBM8OoJMjkbQF0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:09 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:09 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 21/37] KVM: SVM: Add KVM_SNP_INIT command
Date:   Fri, 30 Apr 2021 07:38:06 -0500
Message-Id: <20210430123822.13825-22-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4394f92d-f035-4393-84d3-08d90bd4f339
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832D4776F8AB101F3A330D6E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 106025hRZa9O5T49UCLc/lQrtq7Ctv0NeEpunl7KTvALQkdphrIv1a8LyiMgVAgQd1pkXRal0z17kv/f9F+GypBMY7QVm0HDm/7WNeBPjgmca+Ov0LFtR9c4/isCeK+yrqJ3ffTUrklBkZ7DH2l8Mm0pCzzi6+bh8vkDNfLWE6cFxymlg1J79iFKnKqeGRYmj9cUH+OQPpUVEsKFkKjjDxDMUHsy1uHn05iKoM3IGIKsNTI+6yCFQgOV+wgQ7xx5WRYLjvn78iDbAXhKb7T4KY/xLHTnmn41tNp6wZRy9BNul1iVW1x3AlhOJRSm/vMslEI5+aOfYXh6PtOXFJAOfcnMqpW/vxrNyQ0YLTDrRPWaydNTBy2jOaAvRSB/V0Og155UY3nTfDIBEnCDlw11Of7a7Mqm93C7AHH/wXXFRmBgS9u6cuOI+irW3+oGppNSOFvHJtxfF3iYx34cx6AW4M6qi4bxKhUnGuTLfzuj+sjBzFErDkSe0FDu+VthbiWEHtVUw6gHCFev7V3Fupr7cuF+HZflKjPBZQ81w0O4nwsCc7JXpYJXaFl/imQqRsfgLSHhNCCMHxAVFr2za4sc1yqfCrUYfJNGZfn8/BsfFn3lvKp8lFKQzXJ9tanp+H518ET8c1oYQnwLwqb5rROLbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ZdduA1WnReu/9uEHoYrvcBSOo5ndb/NXT2hCl4UJiRQBKUexFyEVKvKrF4RS?=
 =?us-ascii?Q?NEZcYEXCYuohVAJ6cuJpfGdxjygQtXFQdWNFe0TcZkwMChXv5T7KiIMQLWZh?=
 =?us-ascii?Q?Ta3Lhfipq5orMo0XkfpWN2oN/pB81s57Fwq6xma1QyrLLJbO79AGKx9h1Kjq?=
 =?us-ascii?Q?UeIdUOttk/GuIbAy7tAtk6CrMPF2CxR+pcauzNlYlieY6ng0g57Mj7MkMFCB?=
 =?us-ascii?Q?LLMQcR7nR6TUor1Dl3ei+olvupoMhADDvu3iGv0Y6Wej4Meo3E6JcvfPUjL7?=
 =?us-ascii?Q?vMhRzXFDXzoQ+FZGaQ8SHN/ZTJjVjnZNB6Tr2SXDNXmU/XijkeDs5i9R9mAV?=
 =?us-ascii?Q?Urhw3QzLGAmtQxBVloA7enuiSaNS/iD9Qa8c93yfV7d0wansKOvc9nR5yGyz?=
 =?us-ascii?Q?yLPr/67QRoAeXA3Jzz0Ovz93D5uKNIWuIT6LvSJjwwJwcadO30SLhzSdVEv6?=
 =?us-ascii?Q?nnXvLutSEyiA51D50FH0ipwaVHovTu1quOSzlhVYgfQV9cePsGjhB6aAIEZY?=
 =?us-ascii?Q?0XTZXLkrHfLmSPbn5dn6EjajykXQ7z651lh+vdoGKQvugStlYZHrdb+Ie6q8?=
 =?us-ascii?Q?psM/+vAOlizCIcDnn30Zl4WdK5IiglhRBrQtv92sw6F9k75oi81SStqxTWrE?=
 =?us-ascii?Q?4egaP6c8XUQcXPtsg+NuH6xGb6U5gWYOfDR+j7UBOxyCTpG+M2zpoCvpD64R?=
 =?us-ascii?Q?hvlgm220/kX5svSpd6W32vjWfFa36aAPIa97SDv7pTutjRil1+1RbxWmcNPp?=
 =?us-ascii?Q?7Sgm/4N5PGVlAEmHR6QhDUKjvHRCasaq5NnYMJA+82Kn9tFDMoDtit8T6Iim?=
 =?us-ascii?Q?xt6Gw+sHtu24ZvUSndgdeHXSRfG9rthGFyTVCkEkpAD7KCQ5HSWO1ILcxTKV?=
 =?us-ascii?Q?mbavFJ0pL+mb683SpzpaVUH9cd9ZpZeGX0OMLEZj35np0LSdWvBCSDsFziOI?=
 =?us-ascii?Q?MKKDUoGV5Yf5l92ITgAFOcmVD7zY6+PfcJgHjLPEVRF4yOGDMq3msPfAQC47?=
 =?us-ascii?Q?eTod8IYu7kHI2AVNCWoiCXPOIpuLt0SVE1XFn/BKl6YX95inLn4n3RY5tn82?=
 =?us-ascii?Q?odT80yqucKwnnQEfX+mxQ3qNYy/2tcFLFQRtkv9BvvTnHgzArVsy9UroutES?=
 =?us-ascii?Q?rVfovQX7p9FlcRA0j6yjBJO7S75AXbf7GXSykDaTAl6QjtBQ1JBMSYfnx0qo?=
 =?us-ascii?Q?c+HTETiTM9lr42NZhdoe6ekpzTgT928n3LPiOeGlFJxxL7Jxu7TwCJ3Nh9uR?=
 =?us-ascii?Q?OEzuUiVJSYnlNOhnc1dE+iVxeOHPUjKVzOA3vRpjThDgObvDS8IQ6Um8Qbz5?=
 =?us-ascii?Q?YxI9P7pp6KML7pV/BxQ9cF0l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4394f92d-f035-4393-84d3-08d90bd4f339
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:09.3010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZaB7RZ+muUJKYD8laMGV1U7+WDwuASa62fMJy6/HhHZT1V6SV9BlmxPQiCngrP9/msG8zcdj228JQDqMNr5Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KVM_SNP_INIT command is used by the hypervisor to initialize the
SEV-SNP platform context. In a typical workflow, this command should be the
first command issued. When creating SEV-SNP guest, the VMM must use this
command instead of the KVM_SEV_INIT or KVM_SEV_ES_INIT.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 18 ++++++++++++++++--
 include/uapi/linux/kvm.h |  3 +++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 200d227f9232..ea74dd9e03d3 100644
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
 
@@ -583,6 +588,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	save->pkru = svm->vcpu.arch.pkru;
 	save->xss  = svm->vcpu.arch.ia32_xss;
 
+	if (sev_snp_guest(svm->vcpu.kvm))
+		save->sev_features |= SVM_SEV_FEATURES_SNP_ACTIVE;
+
 	/*
 	 * SEV-ES will use a VMSA that is pointed to by the VMCB, not
 	 * the traditional VMSA that is part of the VMCB. Copy the
@@ -1525,6 +1533,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
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
index 3fd9a7e9d90c..aaa2d62f09b5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1678,6 +1678,9 @@ enum sev_cmd_id {
 	/* Guest Migration Extension */
 	KVM_SEV_SEND_CANCEL,
 
+	/* SNP specific commands */
+	KVM_SEV_SNP_INIT,
+
 	KVM_SEV_NR_MAX,
 };
 
-- 
2.17.1

