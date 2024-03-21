Return-Path: <kvm+bounces-12431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CA76B88619D
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F32E1F20C32
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 20:27:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5615134CCB;
	Thu, 21 Mar 2024 20:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BzK+COnU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D0B133402
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 20:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711052831; cv=fail; b=I5qRIIYTteWdgyi5156d7nEH67flPfBPzwf2+xDvcItO1gUZ2uB88QtyG4OTYhcgzVBjTAM1hF6hqMxTiqUESqOgFs3XD/lU8nqKbZ8yGT6haWAy09OXNHsPVuBmJ5gOozF4fIWW14ykmJ/OyA0YgMjs3mkGj7t2w+hDtwuOkIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711052831; c=relaxed/simple;
	bh=R2fbNT9v1laTj6HVan/qES1M0rfCDhLGUkVFusAhx6I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GWfd7b4Og9Ilf2bXNixk3mt/q9LoxQS/JIaZDVIbNjML0ieLrPgS2bf3+kX5X2/ytFNh4RLsGvXgOwTnvPi3Dts6aUPlL/tUTXCqobfcGrXfyKGASiK2lB6gGUp/THoFY0n0E9o7ehAfAI5yM/ODKwDUDIGPbPO4FlIAABgGfEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BzK+COnU; arc=fail smtp.client-ip=40.107.223.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a+Kxe7/VH1YPXefELhWXesvx+pQTr0fow1Zeyegmk433l2ajZhDVXVXgz0gfdSplgRTWlFYhRTQBWMTAeqV+FT7mF0wlU0nHZL0NWaBR9OOyJf1uKBHPGWH9HeOAU9vMnWJJb3BF0t6xJqECVdXsuRWilvauraIUp//7l/yLTlN++vjSGvtEvnoY09zs4IOKc42ho+2c4COCy7HSWrolm5ARbZDUjsr0WzAlvjUKnqKIM/PqBvJU+b2pI4LHznn5Xc/nUL/CJh7dlveomPeaTEmqykCbTYxgR8dxEwg/tNcvlOm29efnBv6VZxtKl/9wrqh2pLq6tD1L7DD+zdtI7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BPRGgvlWEUvpKylJ6bQOUWbnKTUehT4ARIxQM6Q1p2c=;
 b=RAeIyd90ffnM4DMWxNOe0okjNYUs/C4tB6uXKNPwsN4mj7XLCqJ2MBLFtWggP4dhqaNVjiWIzTfoTjVISFUuB9MdyV4wvATzJ5TCWIjnPXO4oHaydupKiaIOT60tWb+MivWjJh6tZNnqHQycpRPreWJM/PnXBlCovzASBf1dMwELMZUTWtc2prhKFZFMmWAb3g4LbBLa9oMdwsubzGKlM/ZJih/ZAZ2hOUgEr/D2tkZZEP5C3NxQATdCEIgIFT0U/KjLfJa5WQR40Xm9vP7hqZoDt13zE/v/r1Ky/fA1gd5YU9GZbE02VWt+CkHC/JjzJEzf66LKSHL1LT2/uV5wDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BPRGgvlWEUvpKylJ6bQOUWbnKTUehT4ARIxQM6Q1p2c=;
 b=BzK+COnUuX690HzGeChoX3iOX40Jwm+a+9cNZRcdJA5t0a/dFD3Zg+O2siRTH99NA3mRBAV9UPac5GMxWy5CvQtezAwirG6uYFPsOMx2ZSprXrg52907JYD0MEl8j0+Uz11+GS24aMS1XPtM26YVwsyxf+M3jNU1PMy2mZDh458=
Received: from MW4PR04CA0134.namprd04.prod.outlook.com (2603:10b6:303:84::19)
 by SA1PR12MB8094.namprd12.prod.outlook.com (2603:10b6:806:336::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Thu, 21 Mar
 2024 20:27:07 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:303:84:cafe::fb) by MW4PR04CA0134.outlook.office365.com
 (2603:10b6:303:84::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Thu, 21 Mar 2024 20:27:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 21 Mar 2024 20:27:06 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 21 Mar
 2024 15:26:59 -0500
Date: Thu, 21 Mar 2024 15:26:18 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH RFC v3 00/49] Add AMD Secure Nested Paging (SEV-SNP)
 support
Message-ID: <20240321202618.munlyxlqof5tcd6g@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|SA1PR12MB8094:EE_
X-MS-Office365-Filtering-Correlation-Id: 34bfa99a-9129-4b44-e879-08dc49e5473c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N5bnfbOBmt01i9KEgWwyWaxq4ytSYWSerNingchmlgYN6zty6G2wPEiki+jSyzBp5FAfRZ7iC/yzt7gp7GzKCK04l4AYIosUtpCA4OJoEAbLZ4MLuXyQq7KzunZolMTgm5l8VPrRpykA5tqMlVFjXZ/p0sm/CneZuVFFhZHRioy3jIsS9UytflOd2szJlVGD1ZS5stSgM0VQS3++mgKU0+AcG7P53iK4aG31krQpfb2xcPAN2JvWtSkypyVGdXMBJKy2pIK5CTKo77fNIb+sn++KrHo4ZzVU7VVkR3f7NYOKrS8dP3T6qma9FGsEduENBqovG0a/uaHVT5cVDGagDSVyhatWnQVZ+wSoqVxNS8gOP7+CYAumdmZM+UdCxIlR+qDsneeqt5Br6KDp56aB/OWap70Kcey/13wetXoUphCPuBOh0M9b4zzC35K/f6Ds6q1vETpj+/UFkMYv+TuJ1Vvxzjy9aRxzIE0ta0FlKDtc1aMqn/aZ+940RqHZDpkyGjlskE5MNFE4J4+6uQbKHMDzelHWNJPEo9yekPK1R9pcDQ+yGD2wOMPSoDEWqGFbdXRv1DaHtrI3OY5lKvkNW6mprkHLfdKFbTObMGCeR77wPo51uSmO2q67SU+YbwEbd7p8MYGMIeMH6ke4rvifeHqjCH10a5FJcOrGMQ6Pgg7wcZ4oI5DG4eAhA2z2cVgdIwVr7FGy9v3xkNwBJoAqmA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 20:27:06.7686
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34bfa99a-9129-4b44-e879-08dc49e5473c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8094

On Wed, Mar 20, 2024 at 03:38:56AM -0500, Michael Roth wrote:
> 
> Testing
> -------
> 
> This series has been tested against the following host kernel tree, which
> is a snapshot of the latest WIP SNP hypervisor tree at the time of this
> posting. It will likely not be kept up to date afterward, so please keep an
> eye upstream or official AMDESE github if you are looking for the latest
> some time after this posting:
> 
>   https://github.com/mdroth/linux/commits/snp-host-v12-wip40/

I just noticed I had a necessary local change that wasn't included in the
initial push of this branch. I've updated the branch now, but just wanted
to post a heads-up in case anyone was having issues.

-Mike

