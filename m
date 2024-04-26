Return-Path: <kvm+bounces-16083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0B368B4187
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 23:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E38F4B222EE
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 21:54:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7B47376E7;
	Fri, 26 Apr 2024 21:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pVMyzeWK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3360238396;
	Fri, 26 Apr 2024 21:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168449; cv=fail; b=cywefEWdraNsQ3gHNxltpH6iM6/83ZquA5FNmy6pMEIqA2AO8W/D4pbs+aPW1RfCyRxr2UuNrtWKXLj69Ea+LnHXMKKY+7oroFQSyz/EzcSiUdbPMCTvgsIYYmup3KGKOxhHAUJl6z7sd5UPOwLXySppd07qqQnbBjMwyeiQC2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168449; c=relaxed/simple;
	bh=gzt3VHJEhs3XMcLynoGCu5LrX+3oEacqgb0HNWIQT5w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RSrlay8xRk+mX+zpjWXYinAAkfRBqHf8YlmFithRpqAdiJiZ8UkpALbHLevMl2EVc8OaqGtfSJFuwiv1qysJguO5p4K2tiM8OeyX+Ceta6blbCuBTlDMwHuN2w10cPIf3Rj9FR2KJvIo7bjfJw5k9JmZwR0mSy9/mzKNwA89WVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pVMyzeWK; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Asnt5NpwX4svE4CI+fC4nbtQf9MokYeBxlj/eXrRhf+GJzrBueHMJK3in8HjAu/nPm5tOw50S00JWcU0INErzZRCTU1UDjQh4RIWNq4yi6+4BxOQHC6R2cvOsjD7WS5Y8dUM1Z5Fds+Wz7CtXisvEd56MYjG0TdSpVUSXH1qBSBPo5v0INwhQZu5fVKGKRhtkYP1O3Z+eO+tlkhPrNaR8mdNMShpCvCBcZkLp0hdw0Pvt2iLrqRfWj1bIF0+5koEYYw56UG1JJOckwj3X+XIOjzuAUUKp8DkGLI5oRgFs2bgO/RXqz4Var2hdK024QHnW2zNRRoM7s7rWIckC4VxEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24FoQDV6vqYKAefmG8C3h1XdtlmyVqapga9w7WJzGJM=;
 b=cyuTuuk7rMiDy5vfk5OrD0g9X5X/TGkn0YYN4UJXb5DN6YWaB4Fo1A8EyVbcdTH7/t8N0wSOvpWPf/D0KfxbUZQNMC/2fyhWMVMlP9UcMe2StGfaylnKkoSje8OOY8+geZ7imukMDWz8M0oHbpzaUQ8AIYRtwdaTTrzERxVgzcg7aBqNNVV8oce3W5BpwH7D0pY+fBr2sWPH1iXdwSt4BMGY4Pop8fgNqTSk5RsV4ZsUt+ufRsvP0rVmgf50CRv2UlGKYyYCvLloAi3IcqYyU3lj+ESNmuToak6klUJ97+7cYN0VLplFFgKwh0qQ/O9n2dkcLoRApFn+b3z5oAsQXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24FoQDV6vqYKAefmG8C3h1XdtlmyVqapga9w7WJzGJM=;
 b=pVMyzeWKlpN4nxERgjbfQOy+uPvLzxuRN6h/CYGELDvKM0RR4hTaNqX2Iu24zAdh9gmkZ+OIQ+Umuexd+vX8Q3hy4jrqu+Y0Cvzot10Hk1bTPxnMCzafX7cfLUAi4jAA2Xi9fipHHQGIClnjWqpJtFh7/tiE8/F8nkOdA1svoBU=
Received: from BL0PR0102CA0025.prod.exchangelabs.com (2603:10b6:207:18::38) by
 SN7PR12MB6911.namprd12.prod.outlook.com (2603:10b6:806:261::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.46; Fri, 26 Apr 2024 21:54:02 +0000
Received: from BL02EPF0001A0FC.namprd03.prod.outlook.com
 (2603:10b6:207:18:cafe::3f) by BL0PR0102CA0025.outlook.office365.com
 (2603:10b6:207:18::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.35 via Frontend
 Transport; Fri, 26 Apr 2024 21:54:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FC.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Fri, 26 Apr 2024 21:54:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 16:54:01 -0500
Date: Fri, 26 Apr 2024 16:46:33 -0500
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
Message-ID: <20240426214633.myecxgh6ci3qshmi@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-22-michael.roth@amd.com>
 <ZimgrDQ_j2QTM6s5@google.com>
 <20240426173515.6pio42iqvjj2aeac@amd.com>
 <ZiwHFMfExfXvqDIr@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZiwHFMfExfXvqDIr@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FC:EE_|SN7PR12MB6911:EE_
X-MS-Office365-Filtering-Correlation-Id: f5f5e0cc-aaa0-4847-e408-08dc663b62c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HRVovK5l0MvoNkVlQwjriTbugBczjqnWL+RPD0JuEmziE7tM5lm5wvcMWrJS?=
 =?us-ascii?Q?O1Ui1TqtbKvUi0cKaqLZ5P1waYUOG/lIFrB15GQ2+epZLTduPftTm7S7V+R7?=
 =?us-ascii?Q?MX2r5e+23SS88A8hjmc2zIdCT78lmh+5Tnx2V2xVzUfZ0i0K5VF2MhWJclWH?=
 =?us-ascii?Q?L8P0WdGwSUHWlVyWGdMqQ+LBuc84rAKei7x3lwLRw8ZmtrN9dgoU8h5ELHL1?=
 =?us-ascii?Q?NUd1fIlbjJGz44mtHGGLau7O8n3H+hmN/7w1dk5FN+JAnzE0f7+6YbLLW/zj?=
 =?us-ascii?Q?5t8H+SPIVnUMzz7OnjRKvcJ/Owoq/+Hkb625TsqO7mXwZ+bJTNl9Pa0hJ43B?=
 =?us-ascii?Q?jW9BqPfUq5T1lUHcZcf1RX/emYhnw5Nhud22tA0WbwR2oZzFASEBJl37vT2R?=
 =?us-ascii?Q?IVjSzGBpDFPXuexOFMLBNccjGw2F9xw6cB/s+T5eGHsy6XLdCMjC2OzXlz9s?=
 =?us-ascii?Q?WG787Y1XMF8XIPR515woDtVmXvKv6dHAxTOl3/onhQHpdsapj9fPA4hkzmIA?=
 =?us-ascii?Q?7CBlWVh3edFPzuI1VepW3fAXlPdn/AnM1kxHeye9BHkTE00fOmaLnKedzsgf?=
 =?us-ascii?Q?5NKmuqBVXnJshPR7G7mElamB2s0U+7fg1fY57H70mgsbiDzim9sqwqk/dshq?=
 =?us-ascii?Q?r+r1s+te/SVUBSd42MUWeNCP2cQOPaNMx3oK2VJzAL7ur+ZWZdJIT8KoH5lQ?=
 =?us-ascii?Q?rKPfqQFzXWbvzU2S2F+CrFMBlvR8f9msAd0exmw4JYVabVVqbX1i5tWuidVn?=
 =?us-ascii?Q?kggRK813//UB/AsBZoTM86h+DXMarPA5HDo3oJFvE+lN5uukOiX2Rphr5TEM?=
 =?us-ascii?Q?KCmKt1609l2HekonjccAgPG1z2fgafp2UCYkeg/GETjANoIhtU53+A49lhEL?=
 =?us-ascii?Q?QIDaoAzzN56tqJbTGJIh6dLx0msKvppHx6KsPFqEEcvs/LzRCpTv7/GtXnyg?=
 =?us-ascii?Q?Q4epXNFBriFmf0Nc2DC7f1FLZ2JYdVlphxTPnWo1A9JNXmNcn9F4JXhSgFiP?=
 =?us-ascii?Q?7BVZ/KmFelRdukA0WG+1zTSC0VzKT7DHwlBaXaqZaEb8EtEwg51IURSe+w95?=
 =?us-ascii?Q?coQmasOBmVPiAkhc5I0fziWqO8Yjb202sAb1RX+/zh+BfD2sp2UPKOGfRSj9?=
 =?us-ascii?Q?Uhh85orRitGk91PqbiZVZgeD8LNZlXbHNqE9lw3LEuD6Zscj7HGlqjF7bO8j?=
 =?us-ascii?Q?WN3ZRFdYyBy+PMu7ucZQ4hIk96JaFlJ4nMaWWose1PkrKVgbqP6aCrwnxuDy?=
 =?us-ascii?Q?uSJsuzMHlC5epBA4vVNUCAEYajnZmYPvvZjfId7y6Yzjcwxw5eTqeiuuP/9+?=
 =?us-ascii?Q?daqbXUL9c/xbx6uLS19vUhPOQKUmraNVamlTyZRcihspYym+hpw0BXSDNdQf?=
 =?us-ascii?Q?swEznjO6itr1O7HlgPbLMG/BBok0?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 21:54:02.4913
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5f5e0cc-aaa0-4847-e408-08dc663b62c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6911

On Fri, Apr 26, 2024 at 12:57:08PM -0700, Sean Christopherson wrote:
> On Fri, Apr 26, 2024, Michael Roth wrote:
> > On Wed, Apr 24, 2024 at 05:15:40PM -0700, Sean Christopherson wrote:
> > > On Sun, Apr 21, 2024, Michael Roth wrote:
> > > > These commands can be used to pause servicing of guest attestation
> > > > requests. This useful when updating the reported TCB or signing key with
> > > > commands such as SNP_SET_CONFIG/SNP_COMMIT/SNP_VLEK_LOAD, since they may
> > > > in turn require updates to userspace-supplied certificates, and if an
> > > > attestation request happens to be in-flight at the time those updates
> > > > are occurring there is potential for a guest to receive a certificate
> > > > blob that is out of sync with the effective signing key for the
> > > > attestation report.
> > > > 
> > > > These interfaces also provide some versatility with how similar
> > > > firmware/certificate update activities can be handled in the future.
> > > 
> > > Wait, IIUC, this is using the kernel to get two userspace components to not
> > > stomp over each other.   Why is this the kernel's problem to solve?
> > 
> > It's not that they are stepping on each other, but that kernel and
> > userspace need to coordinate on updating 2 components whose updates need
> > to be atomic from a guest perspective. Take an update to VLEK key for
> > instance:
> > 
> >  1) management gets a new VLEK endorsement key from KDS along with
> 
> What is "management"?  I assume its some userspace daemon?

It could be a daemon depending on cloud provider, but the main example
we have in mind is something more basic like virtee[1] being used to
interactively perform an update at the command-line. E.g. you point it
at the new VLEK, the new cert, and it will handle updating the certs at
some known location and issuing the SNP_LOAD_VLEK command. With this
interface, it can take the additional step of PAUSE'ing attestations
before performing either update to keep the 2 actions in sync with the
guest view.

[1] https://github.com/virtee/snphost

> 
> >     associated certificate chain
> >  2) management uses SNP_VLEK_LOAD to update key
> >  3) management updates the certs at the path VMM will grab them
> >     from when the EXT_GUEST_REQUEST userspace exit is issued
> > 
> > If an attestation request comes in after 2), but before 3), then the
> > guest sees an attestation report signed with the new key, but still
> > gets the old certificate.
> > 
> > If you reverse the ordering:
> > 
> >  1) management gets a new VLEK endorsement key from KDS along with
> >     associated certificate chain
> >  2) management updates the certs at the path VMM will grab them
> >     from when the EXT_GUEST_REQUEST userspace exit is issued
> >  3) management uses SNP_VLEK_LOAD to update key
> > 
> > then an attestation request between 2) and 3) will result in the guest
> > getting the new cert, but getting an attestation report signed with an old
> > endorsement key.
> > 
> > Providing a way to pause guest attestation requests prior to 2), and
> > resume after 3), provides a straightforward way to make those updates
> > atomic to the guest.
> 
> Assuming "management" is a userspace component, I still don't see why this
> requires kernel involvement.  "management" can tell VMMs to pause attestation
> without having to bounce through the kernel.  It doesn't even require a push

That would mean a tool like virtee above would need to issue kernel
commands like SNP_LOAD_VLEK to handle key update, then implement some
VMM-specific hook to pause servicing of EXT_GUEST_REQ (or whatever we
end up calling it). QEMU could define events for this, and libvirt could
implement them, and virtee could interact with libvirt to issue them in
place of the PAUSE/RESUME approach here.

But SNP libvirt support is a ways out, QEMU event mechanism for this
will be a pain to use directly because you'd need some custom way to
enumerate all guests, to issue them. But then maybe the provider doesn't
even use QEMU and has to invent something else. Or they just decide to
pause all guests before performing updates but that still a potential
significant amount of downtime.

> without having to bounce through the kernel.  It doesn't even require a push
> model, e.g. wrap/redirect the certs with a file that has a "pause" flag and a
> sequence counter.

We could do something like flag the certificate file itself, it does
sounds less painful than the above. But what defines that spec? GHCB
completely defines the current format of the certs blob, so if we wrap
that in another layer we need to extend the GHCB or have something else
be the authority on what that wrapper looks like and tools like virtee
would need to be very selective about what VMMs it can claim to support
based on what file format they support... it just seems like a
significant and unecessary pain that every userspace implementation
will need to go through to achieve the same basic functionality.

With PAUSE/RESUME, tools like virtee can be completely VMM-agnostic, and
more highly-integrated daemon-based approaches can still benefit from a
common mechanism that doesn't require signficant coordination with VMM
processes. For something as important and basic as updating endorsement
keys while guests are running it seems worthwhile to expose this minimal
level of control to userspace.

-Mike

