Return-Path: <kvm+bounces-16093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6558B4381
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 03:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2F0F1C21FB0
	for <lists+kvm@lfdr.de>; Sat, 27 Apr 2024 01:32:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001AF383BF;
	Sat, 27 Apr 2024 01:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IOHe839k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04963A9;
	Sat, 27 Apr 2024 01:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714181554; cv=fail; b=JtTfrOpyb/x5VMARF7hq3JxRFXTz98WU6AGSR+GILzraVOI5kJQ+orK0H9i45H955ls3LdNxjay/C0zKlfPg5Yfx/haRFGVFBymZiS0vCsnKy2bMRZ6Fm9tEbYmdp60jb+8TXdICsA2NfyotM7kBNSnITzRqCvFCM6xDu6IsQR4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714181554; c=relaxed/simple;
	bh=KaQ6lqXzYJbwdKZiAO5A9/45sOGzmtcFf61yfYYacV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Uab/9ONHPc//S2CC0wtD382as4MPkpGJ1SHVRLlvj5uAOdPyWrwUxoZ3g6ExgSIqizPr+WX9N57yuC2ixkAoqtpDIXTEf00SAQBYt8pvBTmx3qgsqpekPXZPy3Po0PIEcSGsv4T3q5QqL3t4OavFEjbUGvt7aT7WaQovS9KuO4Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IOHe839k; arc=fail smtp.client-ip=40.107.237.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOCPayyNA9aGvHccjBGi8Wzeuf1hyrF1rN/hv2QLIn8mPaX1SyZXkdZ097YamCfxHmDzljMySKsq3Y8YSrXrdeU1zp5vJYiTGn0BgcukUlN9FkmVdQ+Qcke6mU815hAQBpmFXd6M2iQ+zHMOhCm/9Lb3m0sdvQu8Yh8YJx4pOZ/umZKdkpcfVpH51fgMsFE3pqCk9wCxlEDfjd/LbZJZHMVReHpDS3OZvrsbHuGidc3M8L4h2pXBa2RInY4tOQMgYJn/GrMvpeN3wt1y9dgE439zg0jkkiEdJHdn4sgyepKc0BQtlY9CfJV855V3iECkud05OoV+1+lGoje7yswt/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DIDN1Tm7LVGv+jHxm5+A9UKzEp0yZb5ivxKsyyf7JXg=;
 b=FcWdXwnlpApz3X67x4acsI8QqF+2pMkgO1FOssTyDArSDMKTqkVBezND9TEDkPjTAussqqbiesp1a/EEGqnfanzzkgPum37BHJuHKa9A/HdhJQUbky1TMBLLZXkHuEnnD4YsXT538sHZE2Q0hFYMiKjmyw03U+Xx43nWesJr3rm3cnSfTMHQe0PvrMsn5i6wXDCp4uc74wkZIYFG+5oR/S1aMPTdkL07EMA86RYFyPx+1y+E0E5iRj/KA8fuEUNiNNlH6yk4azOGxgs9M2tXUKp+frAMxDzcwHTZO3nzAPVreBRT+Z2GgFR0iYoYhCbF+CKaX/h4bM6QnRMIHMYa1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DIDN1Tm7LVGv+jHxm5+A9UKzEp0yZb5ivxKsyyf7JXg=;
 b=IOHe839kGqRip33b0ysGPCo9H/l39Rt3pVdQZgdyzicAVKEO7j/aDDGoFZ+2KJAo0sGsoA8QUSqsj8EyqvipGX/jMhI3/Kqc5yrOqrtmzfMJXvSYY8CbcstEvZqnG7G7tILS+4brYqdqzVgf/soZJhQDrHhtXfdwRXrLrj7J4Po=
Received: from BYAPR02CA0046.namprd02.prod.outlook.com (2603:10b6:a03:54::23)
 by PH7PR12MB9150.namprd12.prod.outlook.com (2603:10b6:510:2eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sat, 27 Apr
 2024 01:32:29 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:54:cafe::bc) by BYAPR02CA0046.outlook.office365.com
 (2603:10b6:a03:54::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.31 via Frontend
 Transport; Sat, 27 Apr 2024 01:32:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sat, 27 Apr 2024 01:32:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 20:32:27 -0500
Date: Fri, 26 Apr 2024 20:32:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <Larry.Dewey@amd.com>
Subject: Re: [PATCH v14 21/22] crypto: ccp: Add the
 SNP_{PAUSE,RESUME}_ATTESTATION commands
Message-ID: <20240427013210.ioz7mv3yuu2r5un6@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com>
 <ZimgrDQ_j2QTM6s5@google.com>
 <20240426173515.6pio42iqvjj2aeac@amd.com>
 <ZiwHFMfExfXvqDIr@google.com>
 <20240426214633.myecxgh6ci3qshmi@amd.com>
 <ZixCYlKn5OYUFWEq@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZixCYlKn5OYUFWEq@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|PH7PR12MB9150:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cfdf1de-0253-410b-3523-08dc6659e6d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FMYOpG3lR4B3qT4rDk5nq58JQ5krM8TCP88ybOjQ+QBhLB4E9p1iQVNaIx+y?=
 =?us-ascii?Q?LF676qUaGPTEqwrY37TEDdZzXvyh0mUvZW50WjYa6yp6FKtAzrK9nPPvIdv4?=
 =?us-ascii?Q?4IF22wxVoO1J7t6ojZxLJO3jMFk0IO6a0q0zmATgRmIZDYsmoT0Z2noWSbhR?=
 =?us-ascii?Q?L80lLhU/HzKR7reRYCBbsu5aElgDWvO25o0clUuaRYpOTD4YLfmy4ek2V3dr?=
 =?us-ascii?Q?x9JGWi3hVdt3kknStedabwkpK/zprFVC3dXZhGctCliq9o93Ckl7yeSoL0MS?=
 =?us-ascii?Q?VSkZcjTE5JKbC0XkXFUv07/C162famRoX3bljyEmVELF3d3phiudrKoojh5o?=
 =?us-ascii?Q?53p3GuKprf1Fek23NAYjSptLBkgm7lXVikTZLDouHnNS9kEtm7aoefzOCDhs?=
 =?us-ascii?Q?h+onI63ZZWb371iv0xrIvowAUHXGGtL9lzqrw6Z/YwWV51J99l1TvCQY4IPe?=
 =?us-ascii?Q?+hbBMNcIjKfs1cA9RIZgMuvaql2EKEqODT0wOWJIJHaZxZI+0ykkfTxePvbe?=
 =?us-ascii?Q?4YNjKmxO5RnhIIc/eF+aoIK+gLotFTJoQc8gJ3EbFDP9kKUhBNZRmVEpKUmJ?=
 =?us-ascii?Q?Z1NLNDZ3zOJ+yw17TtYHJ6ypxvF70AL3WkDS6tt454nspCulwEJdYPt+T8/a?=
 =?us-ascii?Q?OyMsn6ROQ7VKy+Noqqf/ySXwJFCGVR8Yqzsq0g3jKLOCkQV+bAjIF8uJMVap?=
 =?us-ascii?Q?oi4fmrgMxi0HklZ7OUDjGbLg01eqGuSL3eERcqrF2F6DVzAP7axK46/c/p1m?=
 =?us-ascii?Q?lON7k3K/X8NihSSAATk/QDL1qDY3Vu+d8oIdINTEq6r3OSCxT/oJD56PtBwF?=
 =?us-ascii?Q?ocYQmoG/7W8KAcSP3eLpUcZzKL7e4KyPXeJwFi2+co8mVavnnlKEvUHNP8+4?=
 =?us-ascii?Q?fOPbFthkwhE6pLxDF1/raEbxaU+9sJOJX5F/jlTQevG9A3mj4ypCkf3gt38o?=
 =?us-ascii?Q?gGWXVFaqynvSQlFhRF0C8aZjQPHLPWYHRKOAz/BOsrdRjqZSkI3jXgrUZgyE?=
 =?us-ascii?Q?0TiIr4rA0gIwUP3r89lOAL9pnhH7PtxXpeOt5Tm+pWNMcxk8v6Vmoy1Nj8kH?=
 =?us-ascii?Q?9Qa6UdeHf/TUHL7I2SL83RQbxGRqjSA9KJhydiumgaCXpk+URO4jlybNaRQ4?=
 =?us-ascii?Q?/LeCYtsUp/fZccjajk4ZHmMerDskmxafLSFXrobKafupEpYX1CJ2IXWhDW3p?=
 =?us-ascii?Q?MRRJMtbUpTq0mjyYMftjGg8u05FW7MEvcmA5ie8spILdEva3dKBCx3l1TnUr?=
 =?us-ascii?Q?b3lfbgZDIaM6kaieOBBo5PK/wuaag+4EJAu1/BlsNokitCMKviaEUfn3eohF?=
 =?us-ascii?Q?Kvg5esXR5e1Dey8lNeAEkO6t9rv2oR+dKH7PrE/SzhxjVFCwAVnnLPirOvoD?=
 =?us-ascii?Q?AhwRUnpzL7ZBEMivM4F56DddAdwi?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2024 01:32:28.7472
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cfdf1de-0253-410b-3523-08dc6659e6d7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9150

On Fri, Apr 26, 2024 at 05:10:10PM -0700, Sean Christopherson wrote:
> On Fri, Apr 26, 2024, Michael Roth wrote:
> > On Fri, Apr 26, 2024 at 12:57:08PM -0700, Sean Christopherson wrote:
> > > On Fri, Apr 26, 2024, Michael Roth wrote:
> > > What is "management"?  I assume its some userspace daemon?
> > 
> > It could be a daemon depending on cloud provider, but the main example
> > we have in mind is something more basic like virtee[1] being used to
> > interactively perform an update at the command-line. E.g. you point it
> > at the new VLEK, the new cert, and it will handle updating the certs at
> > some known location and issuing the SNP_LOAD_VLEK command. With this
>   ^^^^^^^^^^^^^^^^^^^
> > interface, it can take the additional step of PAUSE'ing attestations
> > before performing either update to keep the 2 actions in sync with the
> > guest view.
> 
> ...
> 
> > > without having to bounce through the kernel.  It doesn't even require a push
> > > model, e.g. wrap/redirect the certs with a file that has a "pause" flag and a
> > > sequence counter.
> > 
> > We could do something like flag the certificate file itself, it does
> > sounds less painful than the above. But what defines that spec?
> 
> Whoever defines "some known location".  And it doesn't need to be a file wrapper,

"some known location" is a necessary and simple parameter controlled by
the cloud provider, so it's easy to make a tool like virtee aware of those
what those parameters should be for any particular environment. But it's not
easy to make it aware of a particular providers internal way of synchronizing
guests and certs access. We'd be somewhat dependent of those providers either
providing hooks to allow for better integration, which is "work" that might
encourage them to just brew their own solutions, versus...

Providing a simple reference scheme that's clearly defined, and easily
adoptable across the board, which is "less work", and makes adoption of common
tools/libraries SNP/certs/key management easier because we don't need to
directly involve a provider's internal guest management mechanisms into those
tools.

> e.g. put the cert in a directory along with a lock.  Actually, IIUC, there doesn't
> even need to be a separate lock file.  I know very little about userspace programming,
> but common sense and a quick search tells me that file locks are a solved problem.
> 
> E.g. it took me ~5 minutes of Googling to come up with this, which AFAICT does
> exactly what you want.
> 
> touch ~/vlek.cert
> (
>   flock -e 200
>   echo "Locked the cert, sleeping for 10 seconds"
>   sleep 10
>   echo "Igor, it's alive!!!!!!"
> ) 200< vlek.cert
> 
> touch ~/vlek.cert
> (
>   flock -s 201
>   echo "Got me a shared lock, no updates for you!"
> ) 201< vlek.cert
> 

Hmm... I did completely miss this option. But I think there are still some
issues here. IIUC you're suggesting (for example):

  "Management":
  a) writelock vlek.cert
  b) perform SNP_LOAD_VLEK and update vlek.cert contents
  c) unlock vlek.cert

  "QEMU":
  a) readlock vlek.cert
  b) copy cert into guest buffer
  c) unlock vlek.cert

The issue is that after "QEMU" unlocks and return the cert to KVM we'll
have:

  "KVM"
  a) return from EXT_GUEST_REQ exit to userspace
  b) issue the attestation report to firmware
  c) return the attestation report and cert to the guest

Between a) and b), "Management" can complete another entire update, but
the cert that it passes back to the guest will be stale relative to the
key used to sign the attestation report.

If we need to take more time to explore other options it's not
absolutely necessary to have the kernel solve this now. But every userspace
will need to solve it in some way so it seemed like it might be nice to
have a simple reference implementation to start with.

-Mike

