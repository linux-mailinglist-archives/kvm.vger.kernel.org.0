Return-Path: <kvm+bounces-34056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1D2B9F6A73
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 16:52:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33612172078
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 15:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8396413D518;
	Wed, 18 Dec 2024 15:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DP5wJBUx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2040.outbound.protection.outlook.com [40.107.92.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2417D1E9B09;
	Wed, 18 Dec 2024 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734537152; cv=fail; b=gC2Fwj5755253EMmvbvccXCMYD9me8quF7v4jh4aDUojrRZDYO68ZAHQtqokJjWbRsRkh+YHbgjRe2gDzmUjH6UQhJR1MlDK16ku7gSYeVoYq6N2tJUSudI3kMxt0b4M3CF0gLlHlvd7uJSYwDupHaW5gMaFlRQefVA1aqtfc1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734537152; c=relaxed/simple;
	bh=fkyqUrU4iRsz/Xp5Wq+jUQ9e/E0Nz5riqen+uLFjJ/E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FJw240pAAevw8NCwADdw2NHxGAdLgQ8Q0GDTIy/Gj4nIOVi3Mf+RVJoIIQy0NflEfRYaRZfxASK3904Gyauf/30gEgrxpjbNTWT7vrq5fPHQrrA/jMx7gYw9f4MSZnSz6juXNQtL3YMM3vqi5k3ZuOgmwC3suajPfHo1KoF0684=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DP5wJBUx; arc=fail smtp.client-ip=40.107.92.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o31zz18C/mNYRqPjki0XRpLCqjUox3VzJY6ru4Mfwj8i9ITPyTS5dztkVrA3dgWlBqFRSYfvFWgbRjMCje/gt26tF33fLl3h5up5qfvxjsMYEZPbDWtLRrIR4Od1XtwVPZDNZPHrEUeXKoRUBPBs8i0NBaLoKYbZBcst5ln/hrTk/lQ8Yk9TTzYpuN3JlM1R9cS7j3y1efBFtiDqm1eoIGS9nJZQRfi3+X4SglyJwekp3/gWq87C96JHL7l3YPRf39qjTywG1CYJHtm6rxlqTAVn6jb69dt1gPJGihImjX2qeX5irUHU76JaUc+TqnyxjOmcj67vwkM2JrVZRU3yhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkyqUrU4iRsz/Xp5Wq+jUQ9e/E0Nz5riqen+uLFjJ/E=;
 b=SD4E4NZYOjibbQamnN9INa1v/CSzogO0V69W5952/faJ6tMcMbG5rriiyE8mBkPQudZaC2bqh1IqHYmJ8DdAxFSPMqAExVeI07QqWdxwMZnGARlpJ+I5VUfYwsnzbN+MI7lOM7ntlHFN2cnErjaEzfycr5NQkZsCQxEt46cr2owkzIeNrbVEMvsXiU12sMpbLEHcW2E8Xvrjl34dH3wKLmLVqfH65h7tMy9Jd9aqQxgLd4YuLsGypq5dDpqyO7Wjw1yEFJ8BeLjAhPAk3ZF/86iNUev79mAn5n4WKZTqYVP1VrSjltOujuqvB/PnXj0pkNyGWWSzSj95NG3ZBYPLnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkyqUrU4iRsz/Xp5Wq+jUQ9e/E0Nz5riqen+uLFjJ/E=;
 b=DP5wJBUx5DiebOXtlkxiCwnfJJtqXU9Z57uFEo2qj50D6PYgjkHIOZaLfEzWDvtVe0yuimmN9SeStw6N5KudDUBLWwv+XlEqPeK8Jd9LE1Ry52y8hrOEaWCa84Tc4lwsx/H05ZedGBFGfuE02aKBtXKpyuukeitH5ivtDIRci3A=
Received: from SJ0PR13CA0111.namprd13.prod.outlook.com (2603:10b6:a03:2c5::26)
 by BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.13; Wed, 18 Dec
 2024 15:52:24 +0000
Received: from CO1PEPF000075F1.namprd03.prod.outlook.com
 (2603:10b6:a03:2c5:cafe::c5) by SJ0PR13CA0111.outlook.office365.com
 (2603:10b6:a03:2c5::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Wed,
 18 Dec 2024 15:52:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000075F1.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Wed, 18 Dec 2024 15:52:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 18 Dec
 2024 09:52:22 -0600
Date: Wed, 18 Dec 2024 09:52:02 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <ashish.kalra@amd.com>, <liam.merwick@oracle.com>,
	<pankaj.gupta@amd.com>, <dionnaglaze@google.com>, <huibo.wang@amd.com>
Subject: Re: [PATCH v3 0/2] SEV-SNP: Add KVM support for SNP certificate
 fetching
Message-ID: <20241218155202.avikupjxut5gy3pc@amd.com>
References: <20241218152226.1113411-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241218152226.1113411-1-michael.roth@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F1:EE_|BL1PR12MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: acf95bcc-1148-4d98-a340-08dd1f7bf6ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tPW2rgWZoT/izfMgyBJjt34zwierBvtiPvD4WelJuOb8boUrffy0cpmaDiX/?=
 =?us-ascii?Q?WrQRAMf9s7wvydtilSEI1VXi7MpipaoTY3W+tSGgBmCvp9xP7Oqm3dQNZcJv?=
 =?us-ascii?Q?70HBrloEHEG8xV0sEuyZovRGszYNY5bhLxMZm/+gc3bSqUdYTVng80thJ9p1?=
 =?us-ascii?Q?L3wVp9JfNOPbbZglPi+X9q+FpsJ2+wr05WxYnsfRFyc25oaSb967NlROu3wD?=
 =?us-ascii?Q?0YcqfCdhrxPCxeXW6P7JWogJRRHjVs09zVNz0OuislNZfj0WllBizGhzgxxE?=
 =?us-ascii?Q?ntwDp00m3i0VP2fz9//d/+aq2kBk4Iv0EuDC87kw42bnIBPY4Cuh3MfD+/jq?=
 =?us-ascii?Q?FF5yJX7n7teYz/Ga1kgzdoP33vR0jfBOtREI58AZiG1ak60gcN2Qp/XLhlq3?=
 =?us-ascii?Q?3aDDEd60QQtvFh5XSHmHrsTQCS7kAwSwiyPi2RLdP3kiaNt64srdpX2qkb58?=
 =?us-ascii?Q?oDOyi36w1WAviJBnkallLcJvtPJYfIRIZU1GIvj9iCiP/6w4ac/Vp0sRB4gt?=
 =?us-ascii?Q?jT7l2WzFeVlnlojSKaTSe8NCP1MAMlIoycLyz00U6jvUfzu0SZ8JzNQM8J1I?=
 =?us-ascii?Q?cA/Lg6MZb74TsY+DDspTYqKIYVZeBGXrBzu8SMJ/FGGp9jlRhzkCa7V8MSZg?=
 =?us-ascii?Q?vWXaLlrDCvf03yEeiBnFKhIc/MtlwiQZotkg2ydRBTBUG6TVWLimx+ZnZJSZ?=
 =?us-ascii?Q?1NBozNcivXZ7KdeMvzLEEIzbsC1tR/AwbMkxmKFeBNZjhSoeK5DyEZM2yylt?=
 =?us-ascii?Q?fWqG8ncGmKVQy7BXdu68TPQg6Xgn0Tmw9YUNuTrdFdxGGYlOx9NYNnzfNgD6?=
 =?us-ascii?Q?scg5sfLCCdRPvBa22E5173YCZuNmH9shI4kgWWFCyxbVLmaprDtBI8NsCOWm?=
 =?us-ascii?Q?sNzokZzNFFO5IY5tCurSNc5aLC7zDiLejgYbBnm91mtY7TF6YxQbu51OCauN?=
 =?us-ascii?Q?Q2NldzDg7Db9RUB74MFeb6vfsWIWzSa1a3K79hgXzQk+cfTk97KquacWPTyk?=
 =?us-ascii?Q?1yXFqoWmnhlj3MvYR7NA366ppQs6lKFD0UGFc8BSsCINtdsSlF7j92ABV9X5?=
 =?us-ascii?Q?thYMHLIuWt63D40VWnlL6c0+02UMIUyTjTwsrCJDEmttTxcXcjy9M7jRmNE9?=
 =?us-ascii?Q?/9L9NqjzXxFTI/JG/fREsmyX+i2mroEaWXaaikOOHulPYQRu18PHSxHYuyt+?=
 =?us-ascii?Q?ghnlXCxP4m6/SRODOZoCLPQbIOmdLwnMAblAAgUh3ERwqF7Qk4EiKoz5Im47?=
 =?us-ascii?Q?VjSofLixo9aJMn5iRyS5ETp8DzsZNsji7BMhgD2GnDxqgakYmKqqKsGhH4Ol?=
 =?us-ascii?Q?dLizAjXYnct488rb9bDVTf3iZ/0emFuQpGxs0uNLsJHIDi0ncUXMhypJubxB?=
 =?us-ascii?Q?pxAT6n9qOHZ7E0C8fDGsAds4Iuy+2jphyLVlsOy9u4z0Bz+rXuklyFBj8k3y?=
 =?us-ascii?Q?FDizNMxBBKY5LEe2iV7UREC8vcZHcEOuHUbeEgYPN9Px+rfHdrA8YCcXzgy9?=
 =?us-ascii?Q?Q2A1BTiaTGyb+38=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2024 15:52:23.4375
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: acf95bcc-1148-4d98-a340-08dd1f7bf6ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5995

> [PATCH v3 0/2] SEV-SNP: Add KVM support for SNP certificate fetching

Sorry, please ignore the 0/2 reference in the subject line. There is now
only 1 patch in this series.

