Return-Path: <kvm+bounces-52245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 848DFB03182
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 16:34:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E89CC3BE218
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 14:33:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186061D7E4A;
	Sun, 13 Jul 2025 14:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lTIZeMGd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC62279794;
	Sun, 13 Jul 2025 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752417250; cv=fail; b=Cpn43xF5+aD+xr4BrBsxTW5HCD0tShSPcycKMWqZ+GiA2lJBYwPuY3uF2TGA9LrZZQnIXbfKmxAn+TbsAfZYV8ih1unSf++46I66dXti6kW/qY3Snabv33OS8XCwkMdDoPab3VR/mALotSFaZArwbmErorWymwaep3n5jBWvv3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752417250; c=relaxed/simple;
	bh=OJ1R/ZmTldFosbTA8SRnkqmlm1Hb8mQnAeH1dMUX0/U=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rAfvhMJWvLz8Ss/9FcUm5k1ejuJVLUJobMmV7c1TWvp/5if7w5eOOWfgOBwmzsN7L0RTiohrPImr6e+tGYluk/gqrR4N6Z+t5zjIWXAH4/wTqgLYTmIKQmKfblEdNaCH5T/2fL7zXR2ISVgAZx0SbrgfNVJ9spRPvCbrc4vTn28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lTIZeMGd; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HjXED/Orgzo5LPSs+7zMOeryxuM85jJ+U1HDEKGIMfqALBh7gy1dRpPKACAsTow2WF1gebzJe/y1J1UBdJEOnYSndbkcq0Pc1TJ9QUv6aCkY9/cR/5iu+vejMsB06nzmmLUvyMsZYA/oKPUYNo8ek+xIcCuW1TJ8DsZpvZc1Hv9IK8IQwv+tyy6k/asQflP0xpM+w+tiPZ6ZGSPYztgzsIpDVFDJPDkO0SgtGjBeZwVSVxpyaDLtUzeFrVtgWtS3CFb+OeJ3w5HPnmloc1jVLnZOdP0sqWV0QG3auUv4RBtm5mh3V6FlUABjb0THhJxYQUG5RZlia4DQsv8BkQH7tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUrpCj3XuPGDH0JJ1I7vLrhZbBfBjsGqiWc86CG73/I=;
 b=dtdpww8RoZBIM4ei9VF1PISXIyqnUW/xRMrjwsOFXeG+GL4v2EFtgjramtuHs5IGuPJfy0211UovRXx72C9p2JRkzZMhgThuhW0WfnIHDFEPkgZmFgxtKfEgVUCTZjzkb13pvTuWDjgyXJbJCjDXshjdfAXKwhnqAWSiby9MML6odUJ5yoboP0rqp/h8XnHkQbjZ45rq836zEqKSLhMxlCRbohm87181Sgwofjm8mXh+WdoSHEk+73+i+f6gXB7uJOkVqewMyHC7iOBADxmS5Wkg/hFCzwscytwKF5NF5HwklLT/I3u/aUaLOa+hlgUhVnof7BTSoipgy+HcdkykZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUrpCj3XuPGDH0JJ1I7vLrhZbBfBjsGqiWc86CG73/I=;
 b=lTIZeMGdF72fwAkZxe88bDw4421lg1tybgSb/DjksQ8f1IczHheAOsJjzFQgaOyl46bgShVx0Ipq6zO65bUVeSYl6dpAzTLbq41b4mbZBvIuAeb6CPOArUSxr6zzKnVWF3rbBpIaZAFVbTSQWrNEQzcVWbOpMid3xx1Q3su1PBU=
Received: from DSZP220CA0012.NAMP220.PROD.OUTLOOK.COM (2603:10b6:5:280::10) by
 CH8PR12MB9768.namprd12.prod.outlook.com (2603:10b6:610:260::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.29; Sun, 13 Jul 2025 14:34:05 +0000
Received: from DS2PEPF00003446.namprd04.prod.outlook.com
 (2603:10b6:5:280:cafe::a6) by DSZP220CA0012.outlook.office365.com
 (2603:10b6:5:280::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.30 via Frontend Transport; Sun,
 13 Jul 2025 14:34:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003446.mail.protection.outlook.com (10.167.17.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Sun, 13 Jul 2025 14:34:05 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Sun, 13 Jul
 2025 09:34:01 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: kernel test robot <lkp@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <llvm@lists.linux.dev>, <oe-kbuild-all@lists.linux.dev>,
	<thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>, "Michael
 Roth" <michael.roth@amd.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for
 SEV-SNP guests
In-Reply-To: <202507120551.iDEiTBBN-lkp@intel.com>
References: <20250711045408.95129-1-nikunj@amd.com>
 <202507120551.iDEiTBBN-lkp@intel.com>
Date: Sun, 13 Jul 2025 14:33:53 +0000
Message-ID: <85ms98gnxq.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003446:EE_|CH8PR12MB9768:EE_
X-MS-Office365-Filtering-Correlation-Id: a520300a-b49e-4ce4-18b0-08ddc21a51d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wyE6fnU6I1MTP7lftyJnbtH/93Ir6EHDTtyH4CQdJjS9tfUCiqom3C9VfZXC?=
 =?us-ascii?Q?BSAHcTQM2vUiHra4mVM/SnlVVaS4nBdbLqy6CC7NwiUNz/n5xoAMQAXw8HhC?=
 =?us-ascii?Q?gp07A/vB6GuT/AkbeMRyYQwNqMNE94YvBdCcLk+MQ56+XpxGRC/f6WNgyOPd?=
 =?us-ascii?Q?94kfF8428LoEMynQrWBH/Y7kQEjXoHPiFjO/lgmDQOnVm0ddOHw75rX8yFTW?=
 =?us-ascii?Q?Z3d0TMo7C8/1FG66yxlc5ZTHoZX+tcjvki8DYpHvm0zYaZyT2aIWRwmGIPIT?=
 =?us-ascii?Q?wSwvryUWITy1lSqvw3kn3vk86k/w318iuDh1WeyLbxryW1PV8BUf666HHlcN?=
 =?us-ascii?Q?aDVgwf9D6DJfTZAiYSponlkrt4pJNHlODUs3IwZYcp63+HOWvRz99bO1p5Pf?=
 =?us-ascii?Q?2LjVktIkuMVfu1Ipqp0QohM9w2Q2Aqu5sjcxWY+LDOjGYPe1a8r108OvRVMZ?=
 =?us-ascii?Q?Bb7IjJoY2f1YRfEdKsTlkjYbEj7dksdmfZbB7RLBPulLRdRVFnM+JZdO8WJE?=
 =?us-ascii?Q?kpx8Z+QKHLpszYFJ7BaQ7TqjqNQkI8bKIxg/CZX6GMhK/A+YzMxGD5ETkFTo?=
 =?us-ascii?Q?IOYKKhM6BE4kS7ANf4MZemCX5R6jle0mg8Pf2iQXQeze9t2Lz0Sw0PWi0+ok?=
 =?us-ascii?Q?xeG7+b5ZtSga7VBDHMszHp0bAzNXrQ3BrPQsZYUl5I8fd893XGZRmBqAIV2T?=
 =?us-ascii?Q?I7qfs2tdETybhmLAutDQsTvZ7LRLxQvlauqWp3lXNkzAtRV9te9uaT/nLMLV?=
 =?us-ascii?Q?ivgHcZ62volkRE0TWmYb3iy17CoU446cgauhDryKf3LhgDhDQiJIYIRexMm0?=
 =?us-ascii?Q?UW+MY18qaUs6CD/XSo2DRy+hUpOjpTVhc/MfbTae49dZ1sksbKhLbqM8hhKY?=
 =?us-ascii?Q?8YIAzln1Qu3TrwO8fDcZ2YhLQpXvQifjFa77vVCi7JYaJ1UP4YRWsd2t4jW7?=
 =?us-ascii?Q?4mVCE3G/PZdybomqGdwxkLZ0gXtXCrtklLyKiQPk8/aNG2fcfhtYalTemXtn?=
 =?us-ascii?Q?yCoVbCzTJvS+7lqmJPuLjx6T/3dsEUvRKJ77oLCgPPNpARzpm3OFlAhS1x81?=
 =?us-ascii?Q?Bz2ynVFGMi3B0Xl5DT+DlAlFwSFNr3cc8UPcwFQJG41DaLFwW9tqeUvgWEir?=
 =?us-ascii?Q?s3LWxbFmwZ0rn65YQPQ/R5muydv8nsOWQ6+VBQuXlopMfwFI5X+mfyt3V2tB?=
 =?us-ascii?Q?uv9njpY+5mQdFlrEJJKklkgyUqL12nWRIxrDJLqn/5MH3T5q1D7eq3AWD/gR?=
 =?us-ascii?Q?34W+22uJU9sGbJh0Ovc4oRC5t6tROdugHKcZEGi5W0BMUDI2EjreClXKavv4?=
 =?us-ascii?Q?BrN1nx2/zrIdkdFZ9naqcz0HApUz2zGhngzMUjHxk3f89hE1AQDOjLxhUlfI?=
 =?us-ascii?Q?mJEImq1P1XdwYwci05sf70acQZcJn4VYzGOnW/CqwBhSC7AJ7rh7MmFxlXtF?=
 =?us-ascii?Q?xiN1FylvpMbBDUOGzabinFvgmr0eHVjB5tZO7tCzGrVhKk9z60GD2Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2025 14:34:05.3209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a520300a-b49e-4ce4-18b0-08ddc21a51d0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003446.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9768

kernel test robot <lkp@intel.com> writes:

> Hi Nikunj,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on kvm/queue]
> [also build test ERROR on kvm/next linus/master v6.16-rc5 next-20250711]
> [cannot apply to kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/KVM-SEV-Enforce-minimum-GHCB-version-requirement-for-SEV-SNP-guests/20250711-125527
> base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
> patch link:    https://lore.kernel.org/r/20250711045408.95129-1-nikunj%40amd.com
> patch subject: [PATCH] KVM: SEV: Enforce minimum GHCB version requirement for SEV-SNP guests
> config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20250712/202507120551.iDEiTBBN-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250712/202507120551.iDEiTBBN-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507120551.iDEiTBBN-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>>> arch/x86/kvm/svm/sev.c:426:6: error: use of undeclared identifier 'snp_active'
>      426 |         if (snp_active && data->ghcb_version && data->ghcb_version < 2)
>          |             ^
>    1 error generated.

This was on top of SecureTSC hos patches that is having the change, will
sent v2 without this dependency.

Regards
Nikunj

