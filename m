Return-Path: <kvm+bounces-21661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EEBA5931CC2
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 23:48:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AD49B22319
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 21:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A5A13E02B;
	Mon, 15 Jul 2024 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rax9hGMT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2110F13D8AC;
	Mon, 15 Jul 2024 21:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721080092; cv=fail; b=EkpIXDJrAk9nWr10PN6xRhMn4L447riey8nWBFT72DcmHXV4uOYOH+VMvitc/BVcrTURUgdMpJWU12CueJHVNN3F9gnLDeD6WjpmaQsj8Ldly7KY0qIHTVDCXKuisrOezInga+wiwj7N4xE98RkzDqTDvwVFUwtwwBKh7vuyLsA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721080092; c=relaxed/simple;
	bh=xr/MwDr7Bua9PIx6rw2dDXAkrYDSV1vUJ4LF7v3FB/A=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oi/YAMsGcH+T8rStZB4x97Vk7EWVOpv4HfKBMgomtZ81J2+8603sQInykEBYtLzNnU6Q6ouExyKzU60RQuhL8lfGruPWuNDDCJNY0Ct+xR28uzQygzIbLbELgwZ39VIjoMYj7O2LC3iRM8WCudphtqwpraH6qQ0wYRW2IpK2G4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rax9hGMT; arc=fail smtp.client-ip=40.107.244.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iKqqlkBLshBSrbqzMHra21SSk5YHKC6WkX64B1UWEBrisd8WxDJasLuhVbozRmwS0WKz8EQ7MAr4Ud7n5HdN0NXhhliwLw0sXSBA9V1+NqqXIhyPCESaxVVeHue5WKBJg91xDKsJVu22HhZhfl5pmNufNIxMb4/FRUsnH7vNzGzyWNZVMQ/LsWnxxcJQLN/Xb+Gx+l6pFbixamPRAC+1riPaEzYE2tATSSfFltvlZiWKOcuiOdh0V8wQniFH7zJd2TNguUjwlYUfWDmlzP59zAQhg7s3XkBnLdYKeUdnjqh3IjsR8j5Ixa3oiAMOeTinQHo3sx9Mz8DdaeRziDHSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eYTYmIguY7h30fpYo5Z6bubB8EAuz526O+GfHahqPsg=;
 b=lLHj8JPZfcI7xc1tGzYqNbvAAt5exiRYMa+4wqlPz91ZSScQbtx2WiOFx1Pk1X1+CmYIU0PNA9re2K1/I/dAk5dt4McjFN3Qe2In6sYCCBnBlVR7GUZK2jJ29hp2xgUN6176D65595NgU20lAfENh6HRYlutpOl+gSb7waS5nxwXIVSF+36BC3o99grcHhbMmAgYAfZzvMyJCK0Cfy0AxmIRsk+j4WvLqq583bmJvo0eIlVCY9JM55btQ5QkRp8lKwggp42S5k9CigY771jJN+1/xVZKo2Z65cRoY6j4EiguGZWtZDcYXQWtEwzINkdyIYRgIgbCc3rm3CAXpwRVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYTYmIguY7h30fpYo5Z6bubB8EAuz526O+GfHahqPsg=;
 b=rax9hGMTZ60QZP2jI56fOrBle9HdloNehOrlshO2b7HghKpv9KOVbUgFZGB5D6VyW5Ve+AIP8eIECgxFPDD6pbc7HDVx6LyNcykgmgIh1ODP51a+sQ5V4x/vMSS0TXIpQhr55RhSUCXqIppoS1XxSg4XYRyNljuaRGPZplFtCxg=
Received: from DM6PR02CA0115.namprd02.prod.outlook.com (2603:10b6:5:1b4::17)
 by CY8PR12MB9036.namprd12.prod.outlook.com (2603:10b6:930:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Mon, 15 Jul
 2024 21:48:06 +0000
Received: from DS2PEPF00003444.namprd04.prod.outlook.com
 (2603:10b6:5:1b4:cafe::72) by DM6PR02CA0115.outlook.office365.com
 (2603:10b6:5:1b4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Mon, 15 Jul 2024 21:48:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003444.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Mon, 15 Jul 2024 21:48:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 16:48:04 -0500
Date: Mon, 15 Jul 2024 16:47:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Message-ID: <i4gor4ugezj5ma4l6rnfqanylw6qsvh6rvlqk72ezuadxq6dkn@yqgr5iq3dqed>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-10-pbonzini@redhat.com>
 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
 <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
 <n2nmszmuok75wzylgcqy2dz4lbrvfavewuxas56angjrkp3sl3@k4pj5k7uosfe>
 <CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003444:EE_|CY8PR12MB9036:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dd375ff-0221-4c26-f9bb-08dca517cf3d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SklTOTdJM25jT21SK3lZTC82UzYzdUhhWnJlNTNzb3ZQUVEvT1J4U3VQbXIz?=
 =?utf-8?B?bDQ2akVCQm82QlIrMDJKZXZsckdlMnpySHZCMkREUHIyK1dIT29mM2QrcGhV?=
 =?utf-8?B?WHI2VUUvQnFmUzlhbzlPUnVJUzMxRks5V2J3SWNodDlsZ3JSd21QU3BWT0hq?=
 =?utf-8?B?WHd1Y05XT3N1cnVpYzZidEl0L3AxeVR5K2VLdVlnK2d0dnVzSEp1WVBZYXpF?=
 =?utf-8?B?Z3J1QXR0VjJEQlg0YUhIeFljYkZOdStEdU1LZWprVG40amhsUHdUZ01sVUhM?=
 =?utf-8?B?VTlrYVNvRi8xOWFtNi9tM0FJL2p1dlRJWjE3SHU0bDU4Umw0V0ZyZWZySlY0?=
 =?utf-8?B?NVRlMUJwZGtNcDR4RGp6M1U4a2NMcE5pK08rMDhic1NMdFI0ZzhsV0RYZzNl?=
 =?utf-8?B?NisraVIvdUJpWC9aT3FaMkN4Zmx2ejdMdFYwaFpXb0hkdFY3OEZSbzVLK1RY?=
 =?utf-8?B?b1lNN3loc3FsYjBtdUsyb3dFc2NpWG4rb0tjOFlpZEtZQ2FwK2ZnTEZHNkpN?=
 =?utf-8?B?c0t2UUlWVlpISElIUW9BNHI0TURkME5GZlZsOGhOejJEbHREZk1XbEpRNE5N?=
 =?utf-8?B?ZFliNEFSNDRxQ2dIUlJUV01KbDBHMzRaYTZYQWV3ZVczNFNSN3ozMTRXdExH?=
 =?utf-8?B?VndCRjRNS0t4bDNjK2VHTjAybVYvOVg5R05GeGZnN3NqTVJkVmNlN3Fmekgr?=
 =?utf-8?B?MDlzdmZYMTF2UmxPTXZqUDlaTGNpZnRMc2tlaTV4a0tXb3VYYW0yRElYVVFp?=
 =?utf-8?B?QnlWSlhacXZUVFllTWNqM21tN1RKSmhsa0hFd2tSRXllQ1N2K0RFekcxK0s1?=
 =?utf-8?B?b2RKL2tnZ1Y2UjlNWFFsbGFhOUZ3cWFjbnA2NjZpOHBnVCsxSWFDME5Od2dQ?=
 =?utf-8?B?cmM1WVE4VXllNnV5ZFh3UkI0K29wVzNBSEgxK0xSTzhWL1RSM3VjbHlnYWNk?=
 =?utf-8?B?L3NYZFE1YkRjUm9rQTE3Nm53dStoUHNud2tTNGs2cytkZ3FOSXY0YXk5NWJL?=
 =?utf-8?B?amhMd2d1NnZHM3ZWaEt5Q2NkUWZUdHNLVWJlMDV5ZmNvZXM5Z052c1JZNTNu?=
 =?utf-8?B?RGlSZGRxdzhGT1BzK0dVVmdiVWNzZ0ZaSGFWUGVSWVJZaUdPSFA3QTVHZCs1?=
 =?utf-8?B?bllCN3VERkJQSDFKTXNkcy9BcVNlZ284ZUcySG9rd08zZWpTcE9jYjNGbHJv?=
 =?utf-8?B?YmdDRldPRE1uZ2FOeWpxcW1FVEE5OGVyeStaQyt5d29qcTltV0hPZi9WY1Zw?=
 =?utf-8?B?NCtGK0RPS280VEJEWklLSnFUZHgrWnQrNjdXMUZjVE15eDdIWGxxOEpRSFQ4?=
 =?utf-8?B?T3JjVVZTaTh1UkgyNW1jOHRrZkMzeDBEazd2UlhmSHFQYXc0MmRJNWJEcCtj?=
 =?utf-8?B?ZTc4N09HSWlQU3pteGREVnc0UGdGSVpTY1Jya1crZGc3SzVpMHUxcGFEVTFI?=
 =?utf-8?B?OVIxaHNXMFNsTmlTaU9CUG5IN0FtWWYyelFlcEh1enVhSmpscC9UL3plMmhX?=
 =?utf-8?B?elA4NjJZNC9VNWswbFNHUHR2L2psRjFUK0thck50eSs4eDFmWlpzd1NlcFVi?=
 =?utf-8?B?eGhkQlBxanp6Uy9LdzZSR2p5RTVQdmM0V0VLbENFaDg1ZHRLVnZTY3FXRHow?=
 =?utf-8?B?RUVEYnpOcnh0b0JIL2ZoU1g5ZG1jeU5yb2JvZk1sTCt1SG9DclJjL0pwR05G?=
 =?utf-8?B?ZzI5VVQvR1VVNk1lUENLRmdzM211SDZGc1pnMWswb3ptOXVWTHhRTHdNeFND?=
 =?utf-8?B?N2NCNS84K3RGUnRkUTdmUXVvM0ZNN0JVQ0s0amJ0dkE2SnJJcTFOenM1ZVhk?=
 =?utf-8?B?VDZGZFdJMTRUTTN6N1FvbXUzd0M0TjNXbjhVRllSTkU2RzdGcitpeUdudTRh?=
 =?utf-8?B?QUc0Smt5b2JOTnM4anZRcW92UlVBa1k3cGRpcTVUWXByaEE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2024 21:48:05.8450
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dd375ff-0221-4c26-f9bb-08dca517cf3d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003444.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB9036

On Mon, Jul 15, 2024 at 06:08:51PM +0200, Paolo Bonzini wrote:
> On Sun, Jul 14, 2024 at 7:33 AM Michael Roth <michael.roth@amd.com> wrote:
> > > I guess this series is trying to help userspace not mess up the order of things
> > > for SEV, where as TDX's design was to let userspace hold the pieces from the
> > > beginning. As in, needing to match up the KVM_PRE_FAULT_MEMORY and
> > > KVM_TDX_INIT_MEM_REGION calls, mysteriously return errors in later IOCTLs if
> > > something was missed, etc.
> >
> > If SNP were to try to call KVM_PRE_FAULT_MEMORY before SNP_LAUNCH_UPDATE
> > (rough equivalent to KVM_TDX_INIT_MEM_REGION), I think the same issue
> > would arise, and in that case the uptodate flag you prototyped would
> > wouldn't be enough to address it because SNP_LAUNCH_UPDATE would end up
> > failing because the gmem_prepare hook previously triggered by
> > KVM_PRE_FAULT_MEMORY would have put the corresponding RMP entries into
> > an unexpected state (guest-owned/private).
> 
> Indeed, and I'd love for that to be the case for both TDX and SNP.
> 
> > So for SNP, KVM_PRE_FAULT_MEMORY/SNP_LAUNCH_UPDATE are mutually
> > exclusive on what GPA ranges they can prep before finalizing launch state.
> 
> Not a problem; is KVM_PRE_FAULT_MEMORY before finalization the same as
> zeroing memory?

Sort of: you get a page that's zero'd by
gmem->kvm_gmem_prepare_folio()->clear_highpage(), and then that page is
mapped in the guest as a private page. But since no encrypted data was
written the guest will effectively see ciphertext until the guest actually
initializes the page after accepting it.

But you can sort of treat that whole sequence as being similar to calling
sev_gmem_post_populate() with page type KVM_SEV_SNP_PAGE_TYPE_ZERO (or
rather, a theoretical KVM_SEV_SNP_PAGE_TYPE_SCRAMBLE in this case), just
that in that case the page won't be pre-validated and it won't be
measured into the launch digest. But still if you look at it that way it's
a bit clearer why pre-fault shouldn't be performed on any ranges that will
later be populated again (unless gmem_populate callback itself handles it
and so aware of the restrictions).

> 
> > I realize that is awkward for TDX, where the KVM_PRE_FAULT_MEMORY is
> > required to create the sEPT mapping before encrypting, but maybe it
> > would be possible for TDX to just do that implicitly within
> > KVM_TDX_INIT_MEM_REGION?
> 
> Yes, and it's what the TDX API used to be like a while ago.
> Locking-wise, Rick confirmed offlist that there's no problem in
> calling kvm_arch_vcpu_pre_fault_memory() from tdx_gmem_post_populate()
> (my fault that it went offlist - email from the phone is hard...).

That's promising, if we go that route it probably makes sense for SNP to
do that as well, even though it's only an optimization in that case.

> 
> To be clear, I have no problem at all reusing the prefaulting code,
> that's better than TDX having to do its own thing.  But forcing
> userspace to do two passes is not great (it's already not great that
> it has to be TDX_INIT_MEM_REGION has to be a VCPU operation, but
> that's unfortunately unavoidable ).

Makes sense.

If we document mutual exclusion between ranges touched by
gmem_populate() vs ranges touched by actual userspace issuance of
KVM_PRE_FAULT_MEMORY (and make sure nothing too crazy happens if users
don't abide by the documentation), then I think most problems go away...

But there is still at least one awkward constraint for SNP:
KVM_PRE_FAULT_MEMORY cannot be called for private GPA ranges until after
SNP_LAUNCH_START is called. This is true even if the GPA range is not
one of the ranges that will get passed to
gmem_populate()/SNP_LAUNCH_UPDATE. The reason for this is that when
binding the ASID to the SNP context as part of SNP_LAUNCH_START, firmware
will perform checks to make sure that ASID is not already being used in
the RMP table, and that check will fail if KVM_PRE_FAULT_MEMORY triggered
for a private page before calling SNP_LAUNCH_START.

So we have this constraint that KVM_PRE_FAULT_MEMORY can't be issued
before SNP_LAUNCH_START. So it makes me wonder if we should just broaden
that constraint and for now just disallow KVM_PRE_FAULT_MEMORY prior to
finalizing a guest, since it'll be easier to lift that restriction later
versus discovering some other sort of edge case and need to
retroactively place restrictions.

I've taken Isaku's original pre_fault_memory_test and added a new
x86-specific coco_pre_fault_memory_test to try to better document and
exercise these corner cases for SEV and SNP, but I'm hoping it could
also be useful for TDX (hence the generic name). These are based on
Pratik's initial SNP selftests (which are in turn based on kvm/queue +
these patches):

  https://github.com/mdroth/linux/commits/snp-uptodate0-kst/
  https://github.com/mdroth/linux/commit/dd7d4b1983ceeb653132cfd54ad63f597db85f74

It could be interesting to also add some coverage interleaving of
fallocate()/FALLOC_FL_PUNCH_HOLE as well. I'll look into that more,
and more negative testing depending on the final semantics we end up
with.

Thanks,

Mike

> 
> Paolo
> 

