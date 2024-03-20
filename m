Return-Path: <kvm+bounces-12335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ADF7881969
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 23:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 539911C2155F
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 22:14:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01F185C69;
	Wed, 20 Mar 2024 22:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CuhwcK3H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2052.outbound.protection.outlook.com [40.107.100.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68F652F78
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710972881; cv=fail; b=mneM/OgaPY7CFwKnUIKuG/pcT5z0otqz+fNzwZPQTIqSwq44lw6OQxdBWGjxE0nSBgUHvxIaJGcN79PcrzXlCQh2MV6w6mAcD6KVbKb6gF4pIosNfwmcgqfSw10xR2ZIl2jQmHgy+I5+2sIcMugRNa1HxzVFtG00+yxWj5IX5Gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710972881; c=relaxed/simple;
	bh=hzQTSLbt/90cjR8xRpNekwBi3HAKSJq1wxkLdLe8mLU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cnlLqLOm3ww5LRnneulHbMjGFczYPV7hd7KhjVuy0iycfrAloWNRq2OktglcMadtXIgCEajQvCEciYcDLNQJ0Qn13EJ2zHQm8/fsvqzT1a9pjm4uwQ+GCXyqsEcJ7B5tZT9VfjHEO4JdqWFwi17LsMXC3ub75V+nX5nL1tJbpvI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CuhwcK3H; arc=fail smtp.client-ip=40.107.100.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIYswS++TQT8wKiz1dcRtx0QYt+NKNZStqzDCYZTlpuMCmkD6trvpDMVts8BKNuyiuhSnfHaQiK/e3bZz3b5kNy8ldAFiAeWsdFeGIpYrKBuWnYcqxKpRAghQcdFvYtY2Aes5oaDvShRQz6cP5SDByvkQDBfBwNMxUeNAZJ3dkBGI/S1YScSlqDjNP67miwF1iWtLIhv/F5oEYmpKXXQz++U0DVWYS2Tih4/Ak0DVcsLtaiMRgJtd7mnyvI4CDsLnLS51vdkQzPAS2prSalLDQNUiWwyI4KMUpwpnQ1IJkX5XAPyjl19qk2oac0jWHSUC67a7mOJKMz87/U4oJkg8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4nDCye8BmsaDu9v1gfNUR0YQsqnfqiNV+HHQmJvF9I=;
 b=EW/kbBGO39GEWkHOuzxM1wvpFahoa14mkeFTBPbINmrN3H/52/ywe2xhGSZ/NsRkpNRXD8l6Lh5pEJ6bE24sJnO9OijmT0h2uWWlBBgSzlGeId3ftj3iGUUAhLtWNxIVbp95PSdNtjM0FgqCWh1IuCwxZsBSvQtTksINYvxegXLhq8q0BxJrKJp5QD+QYRK+YBA7KB0OCQkwWEu9DHwUJby93rL9tlrXr64DQJsiWBMYxcpZKHq6ZnOBy4777qwi3Zfx/5Mn2a0uxHW8iMOldFBoTGNW2rhF7S0zLiQHWkV4IfVLFIfr0wPyjjnevDCY3UJHqbxwjSJUwx7wxJGPeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k4nDCye8BmsaDu9v1gfNUR0YQsqnfqiNV+HHQmJvF9I=;
 b=CuhwcK3HjTNrMPPysDTr1hmnXz/t6Z9XLpc3/B6/i9HGmqmCNC0pWp6U18YRVOnpMyRBI/xpUuGac8I/lJoEOyidzctlytQUTjKla2Db6PFyeovzgrVMzelqkH7oaD2IDtFBAh0gzAtIcMXTusO6fU9aU0Iwuwlf7BkoPY04VNQ=
Received: from BL1PR13CA0266.namprd13.prod.outlook.com (2603:10b6:208:2ba::31)
 by SN7PR12MB6863.namprd12.prod.outlook.com (2603:10b6:806:264::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 22:14:36 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:208:2ba:cafe::c6) by BL1PR13CA0266.outlook.office365.com
 (2603:10b6:208:2ba::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 22:14:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 22:14:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 17:14:34 -0500
Date: Wed, 20 Mar 2024 17:14:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Tom Lendacky
	<thomas.lendacky@amd.com>, Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 25/49] i386/sev: Skip RAMBlock notifiers for SNP
Message-ID: <20240320221410.fdfuzjpzzwaeqjaw@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-26-michael.roth@amd.com>
 <7727f1f2-2a30-45d2-85a9-db22ec5a9be5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7727f1f2-2a30-45d2-85a9-db22ec5a9be5@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|SN7PR12MB6863:EE_
X-MS-Office365-Filtering-Correlation-Id: 89783dbc-e6e8-4b2b-ee40-08dc492b2012
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ehZAhFvygcbrllg+zqqYIBpgPoj5C82dufRHN7pyVm0NuEAq3GwnlJpumq5IvhL75uB7A13U6HTb6WufH9xuniNbYJmcnMFK/PjZpuVjgVzZFEkcdBRucntlyEnBUKnOqO/+qe3LJecDhDt69dzOWBB8Auyq/QMbpvT6wccU55TGtZmqnyXsZH3d+xxGUvIbZS/LOEgnyyQ4jaqcS1jlb7r7dNp7b89McVD8bNbMdl3BbCOZBsxYdhQ0L9cr6EZ6GW1zNA35IdejkIB1RwAaFz4bEvtytMoNy71kWnNJEwj6tHUqQJMLy51I06/uONoamzzooYduAgoWe6bAl2LzhTeCC2v39t1IjgvJA6ufg9lcsnUdHG1CTZUFGLDNGJsCntI2dTpnaWmlLUCWynyvL6jh109I7lRE4g38nvq2tE3vFXdv6XLEddp4b3Nv4ZmPq8Znkb47jgymSAcAgQGppnAmRIenINz2bp1kioxILYe2sAvMThYtUGPyYf1Ql4biNkDY/UqOF4SgrNxUbjEzkN5jgtjgRw6hXL3iK4vBwbWbEaqk/M/8NeXk848Sxx4vxHh1XUJNq1+G5gd2A+9Cy2r9e9bQ3TMhIYxwNhYLAoUA4ddb8XZNE7ULYHMC7oZflX9V06ZRg+e81oU4rmOk9dMYHDBxs26tXv9ioWqY99qpi/OFSaaVBP07P0jglJBHMYGAgLsbaiyWPBQb3zyEOSv5ftfCTWRTxy55FboDC1xCSjWIsF6WlHTGmhqvFs1Y
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 22:14:34.9831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89783dbc-e6e8-4b2b-ee40-08dc492b2012
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6863

On Wed, Mar 20, 2024 at 10:46:29AM +0100, Paolo Bonzini wrote:
> On 3/20/24 09:39, Michael Roth wrote:
> > SEV uses these notifiers to register/pin pages prior to guest use, since
> > they could potentially be used for private memory where page migration
> > is not supported. But SNP only uses guest_memfd-provided pages for
> > private memory, which has its own kernel-internal mechanisms for
> > registering/pinning memory.
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >   target/i386/sev.c | 10 +++++++++-
> >   1 file changed, 9 insertions(+), 1 deletion(-)
> > 
> > diff --git a/target/i386/sev.c b/target/i386/sev.c
> > index 61af312a11..774262d834 100644
> > --- a/target/i386/sev.c
> > +++ b/target/i386/sev.c
> > @@ -982,7 +982,15 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> >           goto err;
> >       }
> > -    ram_block_notifier_add(&sev_ram_notifier);
> > +    if (!sev_snp_enabled()) {
> > +        /*
> > +         * SEV uses these notifiers to register/pin pages prior to guest use,
> > +         * but SNP relies on guest_memfd for private pages, which has it's
> > +         * own internal mechanisms for registering/pinning private memory.
> > +         */
> > +        ram_block_notifier_add(&sev_ram_notifier);
> > +    }
> > +
> >       qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
> >       qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
> 
> These three lines can be done in any order, so I suggest removing
> ram_block_notifier_add + qemu_add_machine_init_done_notifier from the
> sev-common implementation of kvm_init (let's call it sev_common_kvm_init);
> and add an override in sev-guest that calls them if sev_common_kvm_init()
> succeeds.
> 
> (treat this as a review for 25/26/29).

Makes sense. Will split out the common bits of sev_kvm_init() and use
class methods for initialization specific to sev-guest and
sev-snp-guest.

-Mike

> 
> Paolo
> 

