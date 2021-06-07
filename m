Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2599739D4C8
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 08:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhFGGRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 02:17:41 -0400
Received: from mail-co1nam11on2087.outbound.protection.outlook.com ([40.107.220.87]:17504
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230322AbhFGGRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 02:17:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRCNUezH+h2LqNGpdtNkd83EZsk/UEV7ZiNlCxo515o4HCNp4/V6jKw1MDK9/j+SdUWn3E+Vcg9g43wm35oOwe1R3hvCejpLP1dW3uh9jDEz9PbI5Xf/HPGhmsCuPXLOO2BGC03UkALYYsFQZm1Ik7PosmL3gqrFSctmTMJNXJXtBS+ICqAXQYrHJjX480kfrLDXTehiYinSEK+3BoJltXBoKKsvcXdjYj94RtZrp5XH5OBlqsW0ZiuIbhhvAggkYC6Eq+Et8mqLDLPLbwmL77+N+j2HlzI+1KK1gr5jGRLvaZWAKGBr6VL4aUy5roy5ZiLrWYU7/EzgEOnIb6MROg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EH3iq5bJY5waNbmzm1Q1iAHPFiwvDbAyrGFMkmFeA4=;
 b=M0yuvTI1RFk8uNGOfnmTiTNpCLhky/WJoHVj+H0vzwZxfr6XrexmpP20jnFeBO6s4DcY0YyiwNF5t95hPFOsnInaJVMpZTmgrtf6OXIcRuI00Vj3cL/gzDFaAdgSIv6qvn5FCtnjx2REbRUUbA9xRb6p+kU2TDaFb3TUM8UPL3MCSz+MIQtkQjVl8sWDY7dBjmAecHj8eU08cQXA8CAEuSAcOxLjalFaGjCQT9JeOyCXJyk7yBbPQjKAHatiHkihWCqHM01yZVDel0VwowQCGcqqXWe7y4MIdB/+EAMVjFoUfv3CYm565D9qM2Ysd0/faEDHle6S3+8652iBmECQXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5EH3iq5bJY5waNbmzm1Q1iAHPFiwvDbAyrGFMkmFeA4=;
 b=HmYJdoKCuZ0+SIXHbQS61z0HCjCmXmM7u7GHuRrMVP6ixPRy5TQehj+5ojzqND7izcdDBjsJiVO7ms3HOYiehuImNqeBStgduUcNgNYJ7ZfN4oPS8+QSd5vuQAYsQZ0V0ys8+YI1BrhY1MBk3d+qjp6K3SOHx+hmHPmrg8aYZ40=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2639.namprd12.prod.outlook.com (2603:10b6:805:75::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 06:15:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::1fb:7d59:2c24:615e%6]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 06:15:43 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     seanjc@google.com, tglx@linutronix.de, bp@alien8.de,
        mingo@redhat.com, hpa@zytor.com, joro@8bytes.org,
        Thomas.Lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srutherford@google.com,
        brijesh.singh@amd.com
Subject: [PATCH] KVM: SVM: Fix SEV SEND_START session length & SEND_UPDATE_DATA query length after commit 238eca821cee
Date:   Mon,  7 Jun 2021 06:15:32 +0000
Message-Id: <20210607061532.27459-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0004.namprd13.prod.outlook.com
 (2603:10b6:806:21::9) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0004.namprd13.prod.outlook.com (2603:10b6:806:21::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.9 via Frontend Transport; Mon, 7 Jun 2021 06:15:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4e9e9d7-26f5-4a97-348e-08d9297bae44
X-MS-TrafficTypeDiagnostic: SN6PR12MB2639:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26398B9CBC9F1C275DF69D668E389@SN6PR12MB2639.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1AFlhZoGLJgla3bTX20MjUeMwVDdPmMk9x7vbaM63O/vLVYMjxMbTxMmOJdt7v7MvqxiUlfRNUYRcorVyvjwxJzPOhoxd1s+WU15naFkgux9RCe2ePGkQGD3k30ky05P/DRIHNgNVEEyZkMr7t8Z97G4UIfgbUR8d71hgiaJJqHPdD6lgqdMsWZZF0c7snOn7MayBMV2cBo7wen4asjTprTlSsWkwW1wEIQtNAnxkQ0dlVHC3r48sNAaEV+UdHOmhAnsmawmXjIjA7i/0RzJR2wwVCEYAPEAkMpdmXokppiS12YyBItqewYo8m9aZ5hkfa2kxQmSMKRCo/ITYX8V3htIXBKec9Jt+Fb9AhsCcBAYskd8ozRIsrKYQqLVGKKnlbDEd29AEWhtjX/8tLOiuPkiLhwkqyCpc423v0Ppo0r1+5Rjv4fxG+YOKjAkaRDLxBPvSykMpA6nQOJ+dNh+rWxUeSZcBWr64xygaGmWrFL6fOBYzQZjBSmwpygXhhZxWvymb+Rpe/vmuzth2Yul517w92FhHSIAFxvUHVFIwdtAKxS9MtnydD9Xp/Xh1h+e5fk2xOXhZf1MhzGaksVoR9pvq6p3rdqXC+PjeNLqMPf7ywvMyBV3Om2YgvClgVwNDvkTR2ET7l+hm2ohm7hrb95XUBKEUTxm9jslnadXjE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(39860400002)(346002)(396003)(136003)(5660300002)(38100700002)(4326008)(36756003)(38350700002)(16526019)(7416002)(2616005)(186003)(2906002)(6916009)(316002)(52116002)(66946007)(6666004)(1076003)(8936002)(83380400001)(478600001)(26005)(66556008)(6486002)(86362001)(8676002)(956004)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?vaqpXRrv0mFSkQX4b+61+UcB2h94Y0FzmYTx809zq98kukhQHuHaUgvvxKkF?=
 =?us-ascii?Q?DXebL1aIH67Yd43Z5MQKZheAzG3ys/1WAffnPb0kKzswVbpgFSPxslTZ7/b2?=
 =?us-ascii?Q?PuWzPjDc26rQuV3tLFxGXVOsT+JZzR04dKdS/f7TmXsEzW1Wn9jZqvVI/e+0?=
 =?us-ascii?Q?9cq/aYOayl88XC9cpbGJfp7MCVAR1nV3pBpeUnyqvlj7pNKbuO1l/LRk8/z/?=
 =?us-ascii?Q?q6mhjT2ksBh2NcOxSFzjvEHTPgvh7MwL7E7fmR3zUchtpjPB83hSD7txE9Ru?=
 =?us-ascii?Q?W66igXc3qc0AK/wucnnKU0DSUFxOJqCqFgeybQXlLSwPk75UVpzsgoNLmxt7?=
 =?us-ascii?Q?KW6wKOs6KxQ2slnnHkTd8OYLWVnukyOoB9Ahp00gvz39jz03eVxlwMWD3cVL?=
 =?us-ascii?Q?OqD5bdaSXJmMk76zDaFyJRitfb6EbJ4pRfvGSsq/481e2RF4AOVzlLgEpGII?=
 =?us-ascii?Q?y1jdt3xMex3wkq15Ls1+sv3lEuzM9vuztMkP0vvpcUb68zAIRApem8e6AEYL?=
 =?us-ascii?Q?HKSuEWQVqwtiiuPUyMNYLJUIctai8QdD2P7viAsSeznBsZW9ahNHxMM6nMUG?=
 =?us-ascii?Q?kP2T79cWoW1NntWjwsbMpwEye0aKP39Nf52JWDgcKeua7ZkR02A907VjTgYH?=
 =?us-ascii?Q?Hn+ImosJNMRhNAJzkWeySwXXJ64PIj837VxlLO2iMt6eZ6y3HvpKC+n8puEV?=
 =?us-ascii?Q?GoIkCG38iXG++a8138W84uC18cLogefE2sAo1cmGLUkw09OZCAQfVYjPJHSQ?=
 =?us-ascii?Q?28UxWXallw7jvNVpUxdgSl93kRhY27jVYBNMJxfIDX+/oy51bMlmQ3yqPppf?=
 =?us-ascii?Q?UFQjHaXiexavVQVFCEinAGstG1WTNOZS/UNdfHtd2LgOZvvvaNEMW0Di6/o1?=
 =?us-ascii?Q?Y4O2KA7t6i1tgteHDirCXTd9Tpf6fjCOhbTd5cIPLOgSU6Va24h8C7QzM7+c?=
 =?us-ascii?Q?5WeN7Lr4ewXSaK8HFovV+fOwdlfhZk4C6F27/J5UKanMvO5VQh09duK7QiVt?=
 =?us-ascii?Q?IbP9w6SFHBt5oWG+fvZVo4rbmrEohQVSeRw4/hFDEeaAKnNaRQ4SdUZGlLup?=
 =?us-ascii?Q?z83t2G1FopB3wuuy6ejy8Bl0h+VBXB1gRVuxX7Qw5xX/+wHltuto54endcvm?=
 =?us-ascii?Q?150+GSr01IQHoQfmnDTcnFdDPT/XkfnvfUNeXTwmu1BM5benQ8cPMx8gFrQ8?=
 =?us-ascii?Q?BNplK3DCRNBQQ276etip3sXQQltOX27oz9LpOFMGrMfpZE+K1tuyMS27lnYb?=
 =?us-ascii?Q?dW6e2Qb8TlYuKQc9CmWQE5q8X59JKgrxLD19sTBWWba8alZuHV+wZ1hbloW+?=
 =?us-ascii?Q?r1rXToxnZfCdVc8nYNRsPTBh?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e9e9d7-26f5-4a97-348e-08d9297bae44
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 06:15:43.2486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/V5oP44DgL0Ig/GhQh/wKpnSKkGCntXiye7zN2TNe+t7NQ3oIWjjmk0HO18hyrvFHSv2UC0gDsapnnaHHm/VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2639
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Commit 238eca821cee ("KVM: SVM: Allocate SEV command structures on local stack")
uses the local stack to allocate the structures used to communicate with the PSP,
which were earlier being kzalloced. This breaks SEV live migration for 
computing the SEND_START session length and SEND_UPDATE_DATA query length as
session_len and trans_len and hdr_len fields are not zeroed respectively for
the above commands before issuing the SEV Firmware API call, hence the
firmware returns incorrect session length and update data header or trans length.

Also the SEV Firmware API returns SEV_RET_INVALID_LEN firmware error
for these length query API calls, and the return value and the
firmware error needs to be passed to the userspace as it is, so
need to remove the return check in the KVM code.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 5bc887e9a986..e0ce5da97fc2 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1103,10 +1103,9 @@ __sev_send_start_query_session_length(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	struct sev_data_send_start data;
 	int ret;
 
+	memset(&data, 0, sizeof(data));
 	data.handle = sev->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_START, &data, &argp->error);
-	if (ret < 0)
-		return ret;
 
 	params->session_len = data.session_len;
 	if (copy_to_user((void __user *)(uintptr_t)argp->data, params,
@@ -1215,10 +1214,9 @@ __sev_send_update_data_query_lengths(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	struct sev_data_send_update_data data;
 	int ret;
 
+	memset(&data, 0, sizeof(data));
 	data.handle = sev->handle;
 	ret = sev_issue_cmd(kvm, SEV_CMD_SEND_UPDATE_DATA, &data, &argp->error);
-	if (ret < 0)
-		return ret;
 
 	params->hdr_len = data.hdr_len;
 	params->trans_len = data.trans_len;
-- 
2.17.1

