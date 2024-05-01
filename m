Return-Path: <kvm+bounces-16303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B79F8B8659
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 09:48:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66609B21C83
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 07:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E1150295;
	Wed,  1 May 2024 07:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="LTQsaA5x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2069.outbound.protection.outlook.com [40.107.94.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5B94F207;
	Wed,  1 May 2024 07:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714549676; cv=fail; b=UrCQKZ2c9uY0CWPtJbKeB7+vIGA/d5I7IId74yQhXcy3G5bNiJAHJCAY+DthlJMeMviXv3iWJX2L1crdIekn7ENq7vyPd+4w5vpBQNYJzsoLq/gvzpAmbSTtLL2J2wa7J4cQ0McA+ZoUsaW1yjfwclUscL7IWS/XOuLFL3CgsuU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714549676; c=relaxed/simple;
	bh=RIf79EgCG75b1hZjOiZoOe6VfRniHFi/Kye+QNJuRsY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6SE5FpvBeSoa7cQdbne2Z+WR5/OuCmmjtK2CTUdSrOHbMPqX+F/AMSCgD34wkZGwioQcQcgBGKgGZB1razrtq1wMFgvgEwrITfRpkF4v+SjzE1w+aGIU1udce57glKcD2+fS0UZ7bYGQ/ja3egZgENZo0x1iuDswgcV0YrQfMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=LTQsaA5x; arc=fail smtp.client-ip=40.107.94.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSwNk2CR9NXOsFPx8u/Z0mj/3NNbNZp1QBhTusQ8+RJ3+Kxj7/cJgZKLPPwrf6fi/mRQTv/6GZX0ONF0NNxx/imnJeEENSijbb1ps5jMET11i55xu2kF6wQsl0Eyi6RhhXzIiXh0pdsek40y9gsAWV7ySG2YmTIxWgVV5w/S8Vx+BsgKHkJQ6+HMYEhF3Kw8enkRq+b0NQvjfeHhB6uQaZHRRVCliPcbsedR94DVRtQ66T0ti4Y5qQAZDacjFv3x+lPvlScfNtKi39PjK1StkzataCPcyREQwHHvtJWk/60CjmyzB2aoEJLZteJBUv9Hm5AvPlCFy9kekD6mAmzmzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TzzAZm9oYogXqez2TlMGxs3a+KLmFqZxsyGAqlGIiK8=;
 b=LS4QhWLnt8MNcM9QbitmRGtURvCZ10aeEIwy34Hcs89+3WAjX37+FwXn8HvPCZzvBAp5xdvUOUHNp+LpuEbu6c2aAHUOqzsD7UwrcCFdVMbiiEG6E1xD7uy6MhRx74wuaSHr3KVpoqsAwdRrMaWq797Som1wWgr13pePjLGca2W1hO1ZuTBbQKpWb1h0JY/6SheLmC9zxODaNZSYPEYAyayVZXnkSmZwsBqh5prxqL13NNLLBEN4He9neCW3VNKMdb2azmC8Xj20vgbmwQjxEWxIfVtNBHTlsaDHwpvbxh2+7KqkYR56Z+Hx4ET8Rc4rqWfNQSl3Sibt8fpSYum9TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzzAZm9oYogXqez2TlMGxs3a+KLmFqZxsyGAqlGIiK8=;
 b=LTQsaA5xvuzJo3+XLZzUZkLDWNim0Qdnp8VJlQCRbEIIAy/+H8hLWUah00zgxK84E9Bq4kjNG4w0kPEMLZssDwQwdT5/9pbvILGJOUwWgnp2xtjqjCt8COyEFUYkGF51+e/KxNk35FFSub5ZOgStvSWdtGzZ/gNRmJOz/hbV9Kw=
Received: from PH7PR17CA0062.namprd17.prod.outlook.com (2603:10b6:510:325::23)
 by CYYPR12MB8749.namprd12.prod.outlook.com (2603:10b6:930:c6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.36; Wed, 1 May
 2024 07:47:51 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::79) by PH7PR17CA0062.outlook.office365.com
 (2603:10b6:510:325::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.25 via Frontend
 Transport; Wed, 1 May 2024 07:47:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Wed, 1 May 2024 07:47:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 1 May
 2024 02:47:50 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>
Subject: [PATCH 3/4] KVM: SEV: Add GHCB handling for termination requests
Date: Wed, 1 May 2024 02:10:47 -0500
Message-ID: <20240501071048.2208265-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240501071048.2208265-1-michael.roth@amd.com>
References: <20240501071048.2208265-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|CYYPR12MB8749:EE_
X-MS-Office365-Filtering-Correlation-Id: 537ed26d-c693-4ee8-4a06-08dc69b300cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400014|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hQWUVhX00nM+DYhxT02EUQ4ptNhKwPYJBp96864jywBy31emY60asPL2W5d2?=
 =?us-ascii?Q?85MxZD6nFd67+uMYRcSGLvmabno979x/n5xxlCZzQDDe7D2ISL3DAXucacjo?=
 =?us-ascii?Q?LThWfxPrccABObaRFoHy66hUYhtqbHAN6a997XcFJeAOZN1B7l3dtA2lyny5?=
 =?us-ascii?Q?fsNJTuc79E5bj86A6QrwQZaN3FrPkM2nIikScvAa2PLCRPMopqptkkf+ANrt?=
 =?us-ascii?Q?EJoRSnkOp4UEuuMxF7o4dLSNbxaR4ee7htnrufyfsFLQ4ylKHFEV7kRmGfAE?=
 =?us-ascii?Q?sRUJevtfqiJVh8dIA8pJUlHciLkx/bqlstE8OiDQy9HEiu6hAlpQPIvfeko2?=
 =?us-ascii?Q?6v3LtjYj9CwBOjXr0aiIMxfcskTFfBiaDGPaRH0zmeLi0FJ/S3uU0LljqA+J?=
 =?us-ascii?Q?D41Lq/DowYg5RmeOT61mEnQhFxvkSpUsWEJitHtus3QicEnaYyzWktxS369o?=
 =?us-ascii?Q?+1LMX3Wwtdys0AYc4NfOUtHUA1TyfZpMx6xj3ZjIk/bU3+VkVqGmYeFFpiY6?=
 =?us-ascii?Q?oJWS8ffj3SWHqz20KJztQQYSG5q+AIOuQx+t0AYyd2zjYRRSSDzV1s/Iluro?=
 =?us-ascii?Q?XwHW2KM6XJFS6s26QB8ohqQm4/ZvvqqH8lFEAMPj3gxCnwxA28yvqag0GQ9d?=
 =?us-ascii?Q?IptE8DhyDc7vqSdHSyeUWakdVg8NoEReg4iNaa6nB+7+B6cRFne7bw1Gsqc7?=
 =?us-ascii?Q?NNlmyJefA23EtVBECfcB8uvHOfRshrH5zeooxKm/wd6/aQFWwuhyeUdB2urU?=
 =?us-ascii?Q?n1tXx+0pobjIIDZoIMR+8y0PpfNwqYwkyn8aKNahT65DGmcM5i5AihoOOGf7?=
 =?us-ascii?Q?QdC8brpZ1xIYBYBqT1cjJiK7L0op63ZAfrqxNNVzdHaoVHDYx9tjA5YLZIML?=
 =?us-ascii?Q?TMuN6t2N32GMNvmUtigE6gFtnf4jJjLblxFd2abP4N1r5IWhj1xqwUBSb2ic?=
 =?us-ascii?Q?3vjTEO5R6HXZ4aOUcFkLsVIx1fXoRmYgv87j/pwg6k6qopJFOf39UD1RcKXa?=
 =?us-ascii?Q?vgW4W67VBLkcmeCd8VF7ju0ZfmffMCLAlZdPdx/YZ38Ugw9i3zKEFou0ux19?=
 =?us-ascii?Q?lJXe3f+gCw6hnFWXjZ0nc1xQ+bY6IzgKj3bxSezstj8RmSzLBbp/vw/mtZcE?=
 =?us-ascii?Q?BPbNlgof3UHWxB+h0/hPvt+GUYJlfZQlzRQD492eBlhirgPtPv5192+YXPgL?=
 =?us-ascii?Q?Ca72zboo7LoKO1oYan5LTNA5a6wVLB+j7fh+nSQ0NsqPBIgfqLtsz8Z1l9LU?=
 =?us-ascii?Q?m/AtZjoIQ+kJZvdaYn7KNiUlrT8PPjZ32PTxht10lHAmNAysNU49y0je223s?=
 =?us-ascii?Q?NmOrUo7EdwBk8rGeQI6K6ABy4C55LP5GO8rQHP4p6CJqMZsgDii97YmIUNKM?=
 =?us-ascii?Q?6ES9/G0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 07:47:51.2162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 537ed26d-c693-4ee8-4a06-08dc69b300cf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8749

GHCB version 2 adds support for a GHCB-based termination request that
a guest can issue when it reaches an error state and wishes to inform
the hypervisor that it should be terminated. Implement support for that
similarly to GHCB MSR-based termination requests that are already
available to SEV-ES guests via earlier versions of the GHCB protocol.

See 'Termination Request' in the 'Invoking VMGEXIT' section of the GHCB
specification for more details.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 37d396636b71..01baa8aa7e12 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2704,6 +2704,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_AP_JUMP_TABLE:
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 	case SVM_VMGEXIT_HV_FEATURES:
+	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	default:
 		reason = GHCB_ERR_INVALID_EVENT;
@@ -3099,6 +3100,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 
 		ret = 1;
 		break;
+	case SVM_VMGEXIT_TERM_REQUEST:
+		pr_info("SEV-ES guest requested termination: reason %#llx info %#llx\n",
+			control->exit_info_1, control->exit_info_2);
+		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+		vcpu->run->system_event.ndata = 1;
+		vcpu->run->system_event.data[0] = control->ghcb_gpa;
+		break;
 	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
 		vcpu_unimpl(vcpu,
 			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",
-- 
2.25.1


