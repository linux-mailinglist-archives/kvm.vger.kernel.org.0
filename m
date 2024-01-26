Return-Path: <kvm+bounces-7041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E029383D24C
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 02:59:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D1251F235A7
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 01:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4423E79D2;
	Fri, 26 Jan 2024 01:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QHVY4T4O"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73DA63D5;
	Fri, 26 Jan 2024 01:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706234342; cv=fail; b=lMCduCypXpPgo0QPUoAKcNo06wXMwdrIRYkmzqzUnmdakGGaAUV4D4nrSpgQTF+jxgf5UKD6ZRj1sLNWpnhFuNS828TIfi/HC3xp5xi0XrjIx+kMzsq3wbe1xA3OXzwtC1Nh+royI0XG3wcSdFdcDNoy4ftRmGTL165/KQTCHCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706234342; c=relaxed/simple;
	bh=q7iVujImU1NWbNO6y4n2pyb0TzLo96uXaLsYmbo9G+4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f6VE8HoiqoN+W2F39ljS0d+esnv9NLdWSF3kUdEvywV6ghSo+/qPBJiHLl/G9PvNHNymEn2lZ/WT9vIE/QK6lT465ExL9Hn/U/G2k38wH81waGZmW1IoKfszXWXzsFSXHARKcm4nviA3B6PIoKdmhwlxDjDWef65fEY+/bCrhhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QHVY4T4O; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hmYsBIoLunKvrl5QByTngWpl9bBiIFZzTSe3uwUYr3xG1A5hJAaL5hvyqgG+gatJffRQm77o3IYyO59yFKgkV5nq3EyxJhN1+8eyZd4KuhW21DwkuiemCfrQE0VzJW3DFTtkq+TM8s2dbnqdbJwZTfRTajKDgtRsA+M0jWv05/ZA56Yqgt0dNewtE7/AFGb41pPlJqCi6+bxE1i8xX/FR2qUXF2g5/rT2pWrm7YBBFoqW5jA64gYSkEenGWxCl/h/edUcwRX7tqL4tI+83dFiFJc0muDZkgd1Tn3XDD7K2M08DKuRWyE1bPjxjpE2WC3fdAPXUzdAE7OZ11ditQISA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoNjFYBBL3cDRYrPPVAWeRqIuDpGqpIEeNyPTMXLU4M=;
 b=E03eJPj/epksPSOwoOlHvibYeuCz+6BC/HSPikj8tObYsvE55fZgKITxYU6eLyxWyjRbprx19SJmSvv6n6LE8/T1HstQmbsA8b0ABiooHllrZYXj/tDF2gfRNbg9Qxy03hTVdVcMWbwYphlpt+OXWr3pWXYEYfLwn5w27KMjM/8bamoJNrIm08aJiHESaVst6rewKO+c8IIJEnILY5yq7DXorVeguxPXTy09TW9ihKNqcnSlM0/tVWYnBIv8DqqRrNHSSmtSRsFvICny3jElmsyeypnh5DsPzb2nvk8brvySQ3/wyN7lHGx1f3hK9tT+BDnsFBWj7wpBpcokHF2mHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yoNjFYBBL3cDRYrPPVAWeRqIuDpGqpIEeNyPTMXLU4M=;
 b=QHVY4T4OoX83XSBarH1JW9wNHBEtf4G5NXCiIYHpjaZ6MUQP33WgJwXXPrnPhQWbMm16VuYSkTzq4qHIb2KIBZq7+hlXOr1VF/bt+n1lwF6hG9Y4JTTpzXjv0iGMxc2u7F6vT2V4v/3HBncdN6taMtTJLuDus/pl+ZclJBUn6+8=
Received: from SA1P222CA0046.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::14)
 by PH8PR12MB6771.namprd12.prod.outlook.com (2603:10b6:510:1c6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Fri, 26 Jan
 2024 01:58:56 +0000
Received: from SN1PEPF00026369.namprd02.prod.outlook.com
 (2603:10b6:806:2d0:cafe::71) by SA1P222CA0046.outlook.office365.com
 (2603:10b6:806:2d0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22 via Frontend
 Transport; Fri, 26 Jan 2024 01:58:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026369.mail.protection.outlook.com (10.167.241.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 01:58:56 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 19:58:55 -0600
Date: Thu, 25 Jan 2024 19:35:24 -0600
From: Michael Roth <michael.roth@amd.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
	<pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>, <rppt@kernel.org>
Subject: Re: [PATCH v1 11/26] x86/sev: Invalidate pages from the direct map
 when adding them to the RMP table
Message-ID: <20240126013524.s7lzsnaeyhs7g5ey@amd.com>
References: <20231230161954.569267-1-michael.roth@amd.com>
 <20231230161954.569267-12-michael.roth@amd.com>
 <cb604c37-aeb5-45bd-b6db-246ae724e4ca@intel.com>
 <20240112200751.GHZaGcF0-OZVJiIB7y@fat_crate.local>
 <63297d29-bb24-ac5e-0b47-35e22bb1a2f8@amd.com>
 <336b55f9-c7e6-4ec9-806b-cb3659dbfdc3@intel.com>
 <20240116161909.msbdwiyux7wsxw2i@amd.com>
 <011fed12-7fcd-4df8-b264-b55db2f3e95f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <011fed12-7fcd-4df8-b264-b55db2f3e95f@intel.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026369:EE_|PH8PR12MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: a518ceb2-1451-4519-8fd4-08dc1e125b09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b+EJEQPy25KKaajFBzGuaYuX1Z2Ei8wfA/RCf+xDGdpNLV/lR3sWGg1R1Ysp6y7LoJp9rO8zzAtC3IdSGjXwdSFlaUvcnxVZfyCcz851hjVSErf8dsjbg45yRHjYi0u6v7EH0SKlokzEM/iPXH4JSqEWpiSRHgWOZPnQ6ApN2Akf46UVk6COVo48PJ72GV92yJqyY2Pu1v7SLfpw1OY6xf3Zv7gNG1xsLS1kdXkZqOPsvumfQjkgZqT+vIEZkcE1Su3w2H7vU8rqKNCBtFMKI/1zEC7mhdkLHfjX9DrA/3tLes1hw2WqJINsdqSMIljKp5+jKICozaVpsBp0r6Ljfu5Z8zU89OhcqLcPErgo/SK05kVryoZ9EbnbnZNdxPndeA7VfM3jEyeTKwr5ZeuiARFfhxNkEtxsPFZ8/IN4YbZ3Q5qniEj5Qzi94FeAmsbj201qJIjTJboBOxrV08FTf2ZkGX7Pj1Wn2YPMXGb9e6jdkfz7jksTeVT3neHK33YW+g2zWwIqbpc8BGl9k5G12c6rY0ewOxMKBEzLG4l33dG1k0oM+/pxuBYhwo0G7MV1m3Jyv07ks5W1eTNd7q2nBaPqizxma84JDyHJJOQi4ut1W4CLm5k84EpaRppdy6Nx/g/0jDtFyg8EOPRqjA5KjX3wZVngSusV/VrWyt6bgAuVabgueNAanGmJ/NoTGVJSWghGcrRBcJfRouAfu1OZg2CqOFtoDvQP5YmU53izyTetm3U2Kq7QyHNX8W4Hrhmn+iimiNpiYhQdhnSMY6FWLA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(136003)(376002)(39860400002)(396003)(230922051799003)(64100799003)(82310400011)(186009)(1800799012)(451199024)(46966006)(36840700001)(40470700004)(36756003)(70206006)(7416002)(4326008)(8676002)(8936002)(70586007)(54906003)(7406005)(5660300002)(44832011)(966005)(316002)(86362001)(6916009)(2906002)(6666004)(16526019)(47076005)(478600001)(36860700001)(82740400003)(81166007)(53546011)(83380400001)(356005)(2616005)(1076003)(336012)(426003)(41300700001)(40460700003)(40480700001)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 01:58:56.4740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a518ceb2-1451-4519-8fd4-08dc1e125b09
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026369.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6771

On Tue, Jan 16, 2024 at 12:22:39PM -0800, Dave Hansen wrote:
> On 1/16/24 08:19, Michael Roth wrote:
> > 
> > So at the very least, if we went down this path, we would be worth
> > investigating the following areas in addition to general perf testing:
> > 
> >   1) Only splitting directmap regions corresponding to kernel-allocatable
> >      *data* (hopefully that's even feasible...)
> 
> Take a look at the 64-bit memory map in here:
> 
> 	https://www.kernel.org/doc/Documentation/x86/x86_64/mm.rst
> 
> We already have separate mappings for kernel data and (normal) kernel text.
> 
> >   2) Potentially deferring the split until an SNP guest is actually
> >      run, so there isn't any impact just from having SNP enabled (though
> >      you still take a hit from RMP checks in that case so maybe it's not
> >      worthwhile, but that itself has been noted as a concern for users
> >      so it would be nice to not make things even worse).
> 
> Yes, this would be nice too.
> 
> >> Actually, where _is_ the TLB flushing here?
> > Boris pointed that out in v6, and we implemented it in v7, but it
> > completely cratered performance:
> 
> That *desperately* needs to be documented.
> 
> How can it be safe to skip the TLB flush?  It this akin to a page
> permission promotion where you go from RO->RW but can skip the TLB
> flush?  In that case, the CPU will see the RO TLB entry violation, drop
> it, and re-walk the page tables, discovering the RW entry.
> 
> Does something similar happen here where the CPU sees the 2M/4k conflict
> in the TLB, drops the 2M entry, does a re-walk then picks up the
> newly-split 2M->4k entries?
> 
> I can see how something like that would work, but it's _awfully_ subtle
> to go unmentioned.

I think the current logic relies on the fact that we don't actually have
to remove entries from the RMP table to avoid unexpected RMP #PFs,
because the owners of private PFNs are aware of what access restrictions
would be active, and non-owners of private PFNs shouldn't be trying to
write to them. 

It's only cases where a non-owner does a write via a 2MB+ mapping to that
happens to overlap a private PFN that needs to be guarded against, and
when a private PFN is removed from the directmap it will end up
splitting the 2MB mapping, and in that cases there *is* a TLB flush that
would wipe out the 2MB TLB entry.

After that point, there may still be stale 4KB TLB entries that accrue,
but by the time there is any sensible reason to use them to perform a
write, the PFN would have been transitioned back to shared state and
re-added to the directmap.

But yes, it's ugly, and we've ended up re-working this to simply split
the directmap via set_memory_4k(), which also does the expected TLB
flushing of 2MB+ mappings, and we only call it when absolutely
necessary, benefitting from the following optimizations:

  - if lookup_address() tells us the mapping is already split, no work
    splitting is needed
  - when the rmpupdate() is for a 2MB private page/RMP entry, there's no
    need to split the directmap, because there's no risk of a non-owner's
    writes overlapping with the private PFNs (RMP checks are only done on
    4KB/2MB granularity, so even a write via a 1GB directmap mapping
    would not trigger an RMP fault since the non-owner's writes would be
    to a different 2MB PFN range.

Since KVM/gmem generally allocate 2MB backing pages for private guest
memory, the above optimizations result in the directmap only needing to
be split, and only needing to acquire the cpa_lock, a handful of times
for each guest.

This also sort of gives us what we were looking for earlier: a way to
defer the directmap split until it's actually needed. But rather than in
bulk, it's amortized over time, and the more it's done, the more likely it
is that the host is being used primarily to run SNP guests, and so the less
likely it is that splitting the directmap is going to cause some sort of
noticeable regression for non-SNP/non-guest workloads.

I did some basic testing to compare this against pre-splitting the
directmap, and I think it's pretty close performance-wise, so it seems like
a good, safe default. It's also fairly trivial to add a kernel cmdline
params or something later if someone wants to optimize specifically for
SNP guests.

  System: EPYC, 512 cores, 1.5TB memory
  
  == Page-in/acceptance rate for 1 guests, each with 128 vCPUs/512M ==
  
     directmap pre-split to 4K:
     13.77GB/s
     11.88GB/s
     15.37GB/s

     directmap split on-demand:
     14.77 GB/s
     16.57 GB/s
     15.53 GB/s
  
  == Page-in/acceptance rate for 4 guests, each with 128 vCPUs/256GB ==
  
     directmap pre-split to 4K:
     37.35 GB/s
     33.37 GB/s
     29.55 GB/s
    
     directmap split on-demand:
     28.88 GB/s
     25.13 GB/s
     29.28 GB/s
  
  == Page-in/acceptance rate for 8 guests, each with 128 vCPUs/160GB ==
  
     directmap pre-split to 4K:
     24.39 GB/s
     27.16 GB/s
     24.70 GB/s
     
     direct split on-demand:
     26.12 GB/s
     24.44 GB/s
     22.66 GB/s

So for v2 we're using this on-demand approach, and I've tried to capture
some of this rationale and in the commit log / comments for the relevant
patch.

Thanks,

Mike

