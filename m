Return-Path: <kvm+bounces-15682-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A62C88AF401
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 18:28:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E7A51F22D7F
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 16:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A1A13E042;
	Tue, 23 Apr 2024 16:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FTjCWayX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2087.outbound.protection.outlook.com [40.107.236.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7F813E020;
	Tue, 23 Apr 2024 16:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713889518; cv=fail; b=hSsI9M9qzV+fX8NLH4/s/W14ayZC7q+KAthmoNx9G+o2HmzQZ8MdGzbGXaEUKAWie5UKUb0Puqsg9Q8gtPewzTetHL0sYKjlWo+xojIyqC3fXK64Tx2u1zL0h3XQSolN0o2J6uPPaKwZAP5bcREpm/y7LSVGU9gKfqMaqZSf04I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713889518; c=relaxed/simple;
	bh=z2QZujCjmP7vqBDx2FyunNT8IX4trqgVHML4dsx8ZYs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUXXs5x2fBBFBin9qzhPBiU/eHyeJn3uimW4zHcQGeMo/lbVhQR42bqalonGi01mPZkGvsPbbXRjwyBUhg8ViiY/Sud6Mhtq4RmQwEKWz4ypCtNQ+alMXf4hjwV6nZOVqA9ywavx2QHrEcbCRmuq0FRdg6zrhNk0isPAGaiPQaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FTjCWayX; arc=fail smtp.client-ip=40.107.236.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ne4rwnXmWgfPefIaSnCkSTYah74AkqekI+U23EwscScRD3CEF+xjZ5nLHqCYqDSPeaSf2QjIKjxSn34ouwgWLsU1fef1IVYKCanEKgS+0BDumq/yBQuaK1lPQIZBpmMogf0OoPnxXwvI2PftXZIBouXjRGzHPfWQglkNZASXhx3yDEkqFFrhltUSBpyXJyoDI3vt++XhUVCSs+QnxsLp1reUQqyJz+psjRakObuWh5jABja7+n02r9qILvNFTDJEEuk3awGoSbwnMEgjy2g0b54fYsQnvt7SGrYlQT3fR4EUMG2KiHTfguhSO8FHvADDmblRTzm+l1J9Yt0NA2nmOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGdYWeUMgqUQNiInAjcQTgDZEuZULJnifx5b/bbLioA=;
 b=kdhzWVpCX1d435zcjxuvBDxev49UP5FMDFZB+J4CiSty/6I4w2ryKCpm0H7YZhQhnXFeNidP+Orau+SDL57ntMuABOiWN4ZLo8FligYfmHz2rta62qHMH9Gqssx4NXBLTNoTXHnnuUAXbhBwo8rYrmcygc3RZITYbn4lxiyVyoGzSpZM49L8bNH3fU/sdTev2lu9mFRU8r7Vzibew9QJ/It2sSYYrL6cJ8kxYLreDwP01O5N5uMn+lZz9EguCreCeMzAl5jitFA9ujAn6odubm3i6+sUWLYIiByMHE5r7vNpyI+Rzm0pcFyTcxiWx5DuqJ9Z6Rpjs61B964/MeXI3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGdYWeUMgqUQNiInAjcQTgDZEuZULJnifx5b/bbLioA=;
 b=FTjCWayXZMrCOyUhMR8KcgYukLA+G5LpdsCsv4FefIU85HG2svFjOUsW3XtHCSE72GpipRhlmzxNKe0z8yIQT9ixKMNxa2VlYTh2MGiSVG1DNUGljz7K3Iswx8phEtkja73sqaH3VAaJhIjByfaagA2+Sn6kWfjze61KJoZ3a2E=
Received: from CH2PR15CA0017.namprd15.prod.outlook.com (2603:10b6:610:51::27)
 by PH7PR12MB9204.namprd12.prod.outlook.com (2603:10b6:510:2e7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 16:25:14 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:51:cafe::9c) by CH2PR15CA0017.outlook.office365.com
 (2603:10b6:610:51::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22 via Frontend
 Transport; Tue, 23 Apr 2024 16:25:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Tue, 23 Apr 2024 16:25:13 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 23 Apr
 2024 11:25:13 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: [PATCH v14 27/22] [SQUASH] KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
Date: Tue, 23 Apr 2024 11:21:42 -0500
Message-ID: <20240423162144.1780159-5-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240423162144.1780159-1-michael.roth@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240423162144.1780159-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|PH7PR12MB9204:EE_
X-MS-Office365-Filtering-Correlation-Id: e5ffe3ab-2aa7-4b93-e711-08dc63b1f441
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KXlemEq4XVwpbgBmb8EyCJNbbuwMfnN5C2eHNCo7CGtMtWHaevcm31Mb4v+P?=
 =?us-ascii?Q?BIXPt72h8GuqlDNeWG3kieluz+jbv8mOxH1Ak+AkuofRVgppdnLug4Pq6y5s?=
 =?us-ascii?Q?NpnUwyLODa03oinp2SGRBdRH/7I84FUhJ6HJtGTe71LeUoeoqQWa7rGSqurD?=
 =?us-ascii?Q?4eLvPRf3KSelv7PB2uBsgjtmEnwa0GqsviCAgs9L9rpBXaJ4etN92Poso45r?=
 =?us-ascii?Q?8PLJQLeArOATc5VlXn0RTtIC15VEEx2Y6rOFr4u2wR7gscfMJofE1hi6TU2Q?=
 =?us-ascii?Q?PPVXdc3eHN1LA2y9QMDQrNedZR8A+5f9PIRLlcKMGf55jEwPf/FrvGkxyb3Y?=
 =?us-ascii?Q?v8HlMDiZ3/6hmbuqZpKHJVClXq6NcbXHBJAHtEbc9/ShBwC3gt8qbK7npBE/?=
 =?us-ascii?Q?u8LynezSVravbhCmmep+YQ8lhG16ZBlZQcX8WbeYsy7wx74WPunGt90VcWNN?=
 =?us-ascii?Q?ewI1brSM9rmqTDbR0Z0CgSmBjttEVjkoLQpwJoSE1m1jKDrSbYdwFRhRguDw?=
 =?us-ascii?Q?1xBuJUQBGE7Pbb4Ioc1+fWgbekqmcLhyITlYyYOZBU+Naxo1ZUvEJtg9xTco?=
 =?us-ascii?Q?FO8KopgO5OuNq7HeLBRuNEDHlW4YfhAz8+s3pTB7tcyZs6Iu0qcrOJiWwubL?=
 =?us-ascii?Q?bxw/4Qhdmo2PSLkkdJxVBAGK8hvxV09g3qo0Ia9X9vBis5+RLdcvhtZwVukM?=
 =?us-ascii?Q?87RolzRFdIMwLRLZoT5Z9kkcy2B+w6pQQAX16OT9/PNz49hWZDy4ViYo1zHz?=
 =?us-ascii?Q?3HCSfay8Uw9vIYQZFfPDxmu6dpJHYv1/1MG+I+BiBDT+xsVRKqcCQS0MhFeX?=
 =?us-ascii?Q?IeHvvkI4q12BxEjD5PTZBn3xIDb1WtP34rSJje6CTxiCeudtOn3fbYbXKcCx?=
 =?us-ascii?Q?3fDXZyZkJlD0iwKdyTDmO9O4eBAy6EyGkR0uop3rEwm7u7vUD29yz+7mrru8?=
 =?us-ascii?Q?/M/C2HAeiyezdhE2EH5+NwyYo2T6+yB+xlC6oy6xZ0kUwk2ELxuqhHnHyHn/?=
 =?us-ascii?Q?hDDREUC+xuDalIXrjPWTlKGhr8lqgSZlQKOh4lATjSSXD+YNIoexE81OKEgP?=
 =?us-ascii?Q?Pf1Ca8FmygIqLaHA0Xma/Qv9hb/bpLOxO9U/JaRLuKKeiU9RqFgb8UKIGQUj?=
 =?us-ascii?Q?2BnOC8CJ4BHHtuUe1A0sCrF4pKyyIyJZhv5MYygKKi79uvgpcs7it7E/YziT?=
 =?us-ascii?Q?m/fuo/yjyRF5sDRDkpYCrh5kNtt5RU2KlSpiVCV70HXy+cn3I2YBGU6sRgQe?=
 =?us-ascii?Q?dzM5qN8503lpboASt2YMyjZElriOPANGIvqLmJTWzCge7y/ChQwJT48q072w?=
 =?us-ascii?Q?6b+gt/fimQ1BnePej8Qqz0vPA0pdSCIhP14xP5JmPTJjuFdkMH/GV/ffnKQV?=
 =?us-ascii?Q?iLru7nk=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(376005)(7416005)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 16:25:13.7307
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ffe3ab-2aa7-4b93-e711-08dc63b1f441
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9204

As with SVM_VMGEXIT_PSC, ensure that SVM_VMGEXIT_GUEST_REQUEST can only
be issued by an SNP guest.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0e22f588dbe4..2b30b3b0eec8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3292,10 +3292,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
 	case SVM_VMGEXIT_TERM_REQUEST:
 		break;
 	case SVM_VMGEXIT_PSC:
+	case SVM_VMGEXIT_GUEST_REQUEST:
 		if (!sev_snp_guest(vcpu->kvm))
 			goto vmgexit_err;
 		break;
-	case SVM_VMGEXIT_GUEST_REQUEST:
 	case SVM_VMGEXIT_EXT_GUEST_REQUEST:
 		break;
 	default:
-- 
2.25.1


