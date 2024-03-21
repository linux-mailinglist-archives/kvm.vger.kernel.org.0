Return-Path: <kvm+bounces-12379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A261D885A10
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 14:43:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 253111F22085
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 13:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E707884A55;
	Thu, 21 Mar 2024 13:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kqn1kPgJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2045.outbound.protection.outlook.com [40.107.223.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3868083CC9
	for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 13:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711028585; cv=fail; b=S3y4q+9MJ1zgw/NYF3LopSmKW5kKN6TsicqJRqImjICT2MOaqmSkGD9e6HUP21o8LsCPckpbX9SuUQqQUOGBbFn/9vCnjipQ2MAcZuoHMQaMhR9ffIKstypA/JPZ3KZ8FANRoXMSuKyyF2mm9udSz7veoDDerciKK+ejEG8CBaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711028585; c=relaxed/simple;
	bh=0p7vrE1TA5q/KCme5ZePFMbz5wPUxOIAQXMrbdC7qMU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Au2z7y55AEMi2g0Tju7+Uawhsnl4bt6HYxkBUpC+nHLW6QcbFhnhqo57XYPLtWrTJbFQo7Q+7TYbPmU62BIgZ1jlTTSNowFSizPkt4ja2RcJxGUw6GyRDvU/byOKdb4wYTabzOS9BeO20qbEyMm7LuklyvRDUGGpZv6JlDr/tyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=fail (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kqn1kPgJ reason="signature verification failed"; arc=fail smtp.client-ip=40.107.223.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHh6WOB1+OX9msKmL13DPkWha/IlmiLfPxlkAchZ7bhGtimQ4c7pPtFBrJhD4nME221k9BfvpLFDCHZklTbuGf7sUAh+phCAHaSdzr1sj0+qJsOPWKAscHKhmLHXyjdJ81Aqhvk5KV+hdRPhwCsfJM/wKbZdUtI2O9JcwWfBFqVsadGHwhUod9IFcw9e3b0vaidsP/cMkv5Hu0G4NdURrQi/yrL+U84eK3fVZh92hSRNFoOe71GhZz1046OsEKS3wORp9bOwJZuwgTHBWAhnviE4wGyydzSEzCvaiTm+YWtlUHNCf1yyPn6rMFTdGVtrTUavvSO+6LcihBM0AwI4cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olwHZXTcu4U6XXEs4yDcvWO4O0vqOn1EHft+LK+aDR0=;
 b=iy2huy3affVErjicRGXDKOifbqA0YfoC8ufQ7wXRs2zVghh6L7m4HBX6die68MZg62pxRx7CYR3OgaZbV/gEDfWRttZfQzQfLjqydnfqbCmpsT7UWsVuRBuDgQ0Y8Tyg9mdny/lzRGHC73HHlr2etIw5srxiALd8o/OFOsGCukNshxuWy4idqQL1j5MG5eahGQ+rEnPnLBnWUdzU4v6QAcxHraTc4E72C15ztG+/S8OWnJpnxsRk9nxGUz8WlskIQ6eBfnquGPkCS4RMpJtxfbyvRV7GlSlCD91pY1xRFUD5rs8jgaIgfM7nXfQ12uqMz4tDYt5a6eB4dageY5Z0RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olwHZXTcu4U6XXEs4yDcvWO4O0vqOn1EHft+LK+aDR0=;
 b=Kqn1kPgJ+zAkDqJTr/6usp0MBNquf2TfboYhLdXbB3HRrowt7ceM9G2xsKK0SMM4YdII/enVmKy80WnXS+U9mBC87YHQku+HiNiZ2uqIe9nJ1ieLAbtla81b5Murtn6J6OhzFx/7TZ4Gizj+1cTB2v9fX67i14ShDaVHAeCMYE8=
Received: from CH5PR02CA0019.namprd02.prod.outlook.com (2603:10b6:610:1ed::12)
 by BL3PR12MB6572.namprd12.prod.outlook.com (2603:10b6:208:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Thu, 21 Mar
 2024 13:42:59 +0000
Received: from CH1PEPF0000A349.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::48) by CH5PR02CA0019.outlook.office365.com
 (2603:10b6:610:1ed::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Thu, 21 Mar 2024 13:42:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A349.mail.protection.outlook.com (10.167.244.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Thu, 21 Mar 2024 13:42:59 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 21 Mar
 2024 08:42:58 -0500
Date: Thu, 21 Mar 2024 08:42:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, "Markus
 Armbruster" <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	"Xiaoyao Li" <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 47/49] hw/i386/sev: Add support to encrypt BIOS when
 SEV-SNP is enabled
Message-ID: <20240321134222.dsp4zswwm23ryxss@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-48-michael.roth@amd.com>
 <ZfrVClQEH_yUuXVs@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfrVClQEH_yUuXVs@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A349:EE_|BL3PR12MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: 6aca1df4-b58f-4101-47ed-08dc49acd285
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NuZPfhne9eDWObU0SDlG2H02JGaXPNe1rTF4wWCKnJ/uP8D3AgKAUZDI2B9KHWyW/mhRUTiQItrQN93FkhCwE8zfQTRznbGBz86GJ0lreJ4fHFsvzdOBdkqiP8D9LHC/ndMDe+PxCnZacxVJVW2wkF2T6/PG0CxY9DfPp9MgB9urbkZgDJwHuK1sxzLnPcZeDYQTCtheFa9q1b/aCEAVDnX9RKXHB3/ccZoPK+G6t65OBIJTkDOrXlNEXrh0Su+1msrLsqatsLyMcc8ibZ4qhdwA5ipIDpg3Ut9fi0n2TonxgatDgZbCEi4bLDMUQ2jyQfk6HEsKnHyH5BUQdxS3vmM1Jl7k/lA7ySxBx6L5BP4BrkynaXMbG4Av1t9MS/zLjD7GHf/td/3zUxNfq9lkV3I6tRul23A7SVnWx4pk+ZjD5pB15v7RHtYlG0R10vnOpVAoaKDLZs4KcJDbKloXmc/qu3zTyG7q3K+R9cVR/2YwwVTOGLQMpWSYdh4dm+VeaXEyy8Ihbd+8Bw9yBg+StPAXunECu9NCZJ5xGmxV/SoCzjGDJUCOqKAwZgbRIa8gLi+nh5B2LVefdX/u7NZUEuirdXZbmQuPsTs0Eir5zLU/6DTHITC4kdWq9KRqoepxSll2cnvbCwbvNW09gqpOZdrqvg5JPoAIb2+X9WQYCVw9ngtu1BYeSRri+TEtJHCvI4/GUH6oXerOA06PCm6MXA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(1800799015)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 13:42:59.4295
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6aca1df4-b58f-4101-47ed-08dc49acd285
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A349.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6572

On Wed, Mar 20, 2024 at 12:22:34PM +0000, Daniel P. Berrangé wrote:
> On Wed, Mar 20, 2024 at 03:39:43AM -0500, Michael Roth wrote:
> > TODO: Brijesh as author, me as co-author (vice-versa depending)
> >       drop flash handling? we only support BIOS now
> 
> A reminder that this commit message needs fixing.

Sorry, definitely meant to fix this one up before submitting. I've
gone ahead and force-pushed an updated tree to same qemu-v3-rc branch.
The only change is proper attribution/commit message for this patch:

  https://github.com/AMDESE/qemu/commit/c54618a1cc23f2398e6c3af6f3cf140c4901347c

-Mike

> 
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >  hw/i386/pc_sysfw.c            | 12 +++++++-----
> >  hw/i386/x86.c                 |  2 +-
> >  include/hw/i386/x86.h         |  2 +-
> >  target/i386/sev-sysemu-stub.c |  2 +-
> >  target/i386/sev.c             | 15 +++++++++++----
> >  target/i386/sev.h             |  2 +-
> >  6 files changed, 22 insertions(+), 13 deletions(-)
> 
> With regards,
> Daniel
> -- 
> |: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
> |: https://libvirt.org         -o-            https://fstop138.berrange.com :|
> |: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|
> 

