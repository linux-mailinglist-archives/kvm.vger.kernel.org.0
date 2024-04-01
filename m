Return-Path: <kvm+bounces-13302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F14894795
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 01:18:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E994283710
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 23:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FAA556B94;
	Mon,  1 Apr 2024 23:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mhKAi9LL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B606B482D1;
	Mon,  1 Apr 2024 23:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712013475; cv=fail; b=qXsrn+SLdLkBLchudCeMvB48tIL+hd8O6ijNATGYo1T7G7hjdQoFEJhS4/K5+GvjpXkYb1zIX2kN8IcRwAXYMo/ilk2hgYdBZ03OYvinr2XjCoy+qciQciTOnROAcP9voIdzDuFmfYWu3Z8l7RmVYufalDTXLoZSeO+oFzKESSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712013475; c=relaxed/simple;
	bh=EAKUqVPDRFaknzwGM9rGXUEhvQ3/84EJbHbazsUSb6o=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjyV37oYxLOiC37hSBrALPHH6bbtXvxHz+D4sJN/NMHZIkBYAa/JLo2wa/5V83TiDLcHgzlyxahTiylO1p4WWm1k6djTSz898fvRv1wX5TUOeX4Gj+KDixwkOaILTR5+qv2Yxd9QAj4T86xwu8fqr3B9ouKhUAnpLhsnSNkqHXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mhKAi9LL; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c4RAYT3ECo6+vnjlIiBg6SAqID5B6UYdl3isqKEgXBugoJxVHb3Po1FrEZ5cggogW/ncEYRLSysJmLGS1ktT1gQFy8IrKMhz4K2PC8YY8SGiqlSfvOcLUfOBoHZsDAPU2kFU+z91cpgoG3Vk5zptoDwYoUYGU3BKII6URILBW5+PD/LS9kTAyZHYuAyj5YenyhaJEg2c5uEIajqT8Vihf+sPXpI5gr2D85ygR+Vay5brPLeU4Qk64JxfPiE2lVXZi7J4Lol+yrS0VlrMtaVjDzAuHUAKPGjN73puy1rNobzaQPPsH5EMmw82kQW1f33MuuKwMf+z73k1PHqS/MMVfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JLYAJJ4tsw0f/Qw28CdWImlMCEVMjV5TcDIPF0Bjsr4=;
 b=Z7LzpzV6KmcbOVMyiRNE8JH3+QjO6UafMyXSaydFcNK0dhkW1LGC+bp9SRydF7tNjErFy6IW7Vewqwplrzyay2W/GpC3YImAoJGAS9tp2iypFMIKmg4ahy2s/B3HGbul2k+xVFUIvf52KaA+4L0oNlOOSXiaxN2KMuvZP9LzyhGbrKTi4HqQQaSXqcvPnqsFPaQ9xCcBUF5GQPut+b9gIqeZx8k2Hfne8CGWUXZ0iDA0QD+JVb7FL3KWV4TMi4h2YKxabMUIWufIP5e9NjdY+MvY6QPIVUVLDq8ZbnF51P+UddiK2nmWdT17mE4cuEXlemvUwnBCQozyxzvdR8tHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JLYAJJ4tsw0f/Qw28CdWImlMCEVMjV5TcDIPF0Bjsr4=;
 b=mhKAi9LL1fdKTnN1yMM0VpgMO+N0wjUhIQQmh7ASKsuf72cr4LRAMweaq/dTHbj0KEQPaGolovF6W9+tLP94Iw0sdiim++bzgJTa6FXdCoyltf+f4E3Au+VOu0xRaKTz9KnZC0NvnipC7DAHPpTpR2BqnSLhgtBvS+SzfeFUj+c=
Received: from CH2PR08CA0011.namprd08.prod.outlook.com (2603:10b6:610:5a::21)
 by PH7PR12MB6740.namprd12.prod.outlook.com (2603:10b6:510:1ab::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Mon, 1 Apr
 2024 23:17:48 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::b3) by CH2PR08CA0011.outlook.office365.com
 (2603:10b6:610:5a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46 via Frontend
 Transport; Mon, 1 Apr 2024 23:17:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Mon, 1 Apr 2024 23:17:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 1 Apr
 2024 18:17:47 -0500
Date: Mon, 1 Apr 2024 18:17:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Harald Hoyer <harald@profian.com>
Subject: Re: [PATCH v12 12/29] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
Message-ID: <20240401231731.kjvse7m7oqni7uyg@amd.com>
References: <20240329225835.400662-1-michael.roth@amd.com>
 <20240329225835.400662-13-michael.roth@amd.com>
 <40382494-7253-442b-91a8-e80c38fb4f2c@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <40382494-7253-442b-91a8-e80c38fb4f2c@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|PH7PR12MB6740:EE_
X-MS-Office365-Filtering-Correlation-Id: b09a6e0b-d136-43aa-2f94-08dc52a1f1e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tqhk+885Ya1I0c4Q/QDz0FOIY9cplYaBhd3HQCXjCZG8GTjuvgcWlBMOewP6CYx6iirQfhlatVrXe40dNqKLJTZnS78FrJkM5DglNn2n/Eb1FLXktPjZkfk8XDeuEjxjIXuCio+3xPcJSLmjvEwLWffpdNFyjAY7A7wlm7oso5nfSD6K5f3zvjMvje95oJiptXafYRWkBFkVlVCI+nKJqCQ5HvYH8ZUSaUDfft7nKYObA9pY0AgJYaGQMAnil5nHM/KRGvH1vTbqaJpg6CO3las9iq0iS9QTojNi+SY8b9C3he3bqTkO9vy4yAb3EUDm8D3bCsZVO78DMgQeINW6esEjIYMKhkPtJcsVqqCj9phAi7Wkc806v8LkDE7kd4W7mwgtyAff3X4Ce9ItECZ1sz8ig476kJgBSOBK9okQ6vTR9DxNuIJCqJuv1EmmUcHYjqMUkMYM+dUx/J08RMhF/+8iuGTVIlOfWLceQjz/d0u3foqyCcLVmcrw3Pyg7AzYrIedXDNZbA4OunowR/laSq/rPpkb2BkCWQJyUnja0c7985s53c5Wl9+YbU1h/JhS0BVa7I+ZQtvPKupSvprI3Xxx6k5Jhzz56DLSHRDvdFjJKEJERG5y41TMWoghfJbErvjkoJCVxBfJ13ojCQ+sIorBVdZU2/evMEZYLszojEuH/h3MR4c84AkzTDnLZik0Pr44NPUQuHAlu/cwFKwfo5lNkslqkeBCQJ4OD+seQPJW7IXhWEel4wZwvQPtHcGA
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2024 23:17:48.0658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b09a6e0b-d136-43aa-2f94-08dc52a1f1e7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6740

On Sat, Mar 30, 2024 at 09:41:30PM +0100, Paolo Bonzini wrote:
> On 3/29/24 23:58, Michael Roth wrote:
> > 
> > +		/* Handle boot vCPU first to ensure consistent measurement of initial state. */
> > +		if (!boot_vcpu_handled && vcpu->vcpu_id != 0)
> > +			continue;
> > +
> > +		if (boot_vcpu_handled && vcpu->vcpu_id == 0)
> > +			continue;
> 
> Why was this not necessary for KVM_SEV_LAUNCH_UPDATE_VMSA?  Do we need it
> now?

I tried to find the original discussion for more context, but can't seem to
locate it. But AIUI, there are cases where a VMM may create AP vCPUs earlier
than it does the BSP, in which case kvm_for_each_vcpu() might return an AP
as it's first entry and cause that VMSA to get measured before, leading
to a different measurement depending on the creation ordering.

Measuring the BSP first ensures consistent measurement, since the
initial AP contents are all identical so their ordering doesn't matter.

For SNP, it makes sense to take the more consistent approach right off
the bat. But for SEV-ES, it's possible that there are VMMs/userspaces
out there that have already accounted for this in their measurement
calculations, so it could cause issues if we should the behavior for all
SEV-ES. We could however limit the change to KVM_X86_SEV_ES_VM and
document that as part of KVM_SEV_INIT2, since there is similarly chance
for measurement changes their WRT to the new FPU/XSAVE sync'ing that was
added.


> 
> > +See SEV-SNP specification [snp-fw-abi]_ for SNP_LAUNCH_FINISH further details
> > +on launch finish input parameters.
> 
> See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
> details on the input parameters in ``struct kvm_sev_snp_launch_finish``.

Will make similar changes for the others as well. Thanks!

-Mike

> 
> Paolo
> 
> 

