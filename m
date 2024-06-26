Return-Path: <kvm+bounces-20572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C1D918A3E
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 19:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AE4602823CC
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 17:42:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17F819005B;
	Wed, 26 Jun 2024 17:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="l65RhYWn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2050.outbound.protection.outlook.com [40.107.92.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D4EEEDD;
	Wed, 26 Jun 2024 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719423770; cv=fail; b=Z/AAOcVsNGhVSLpjz12Z/22AjAOHkKfUjwxtrgUZ6New761lcrlyUW9TS5GyTQqeTcp7VFkhx/mtO8/bsTN65l3YURBNCrpqWgyZ2H8R5m1wbBPveVd7wVmhBsNSwKxSS4rdOlsG28zwjfQMcBfLJ38BzcgrBe2sQYu/FjhLA1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719423770; c=relaxed/simple;
	bh=mfqmTLFHTtYAD7JW0SJZniDAHyxWhQFhkZn5y59Uc/8=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TI/Iz//nnTf5TJM2oOgN2T/cBW8nMl4pZNBUsZ+JjV3niMj3W75iOVAwcO9Eip0YtsCQhNmNQ/fVV+t4FoS4ZyxWdooXl1hgrkaiPnYLS1nqfg9Pxqr3xyschxzk9Fs6sOaFNaspoZs4t0TgGf3vGgKtoflwnTaDOWxt9a7DQz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=l65RhYWn; arc=fail smtp.client-ip=40.107.92.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=apuihaXF6P+b2Alqo3JCQm+4IRKQPG38KQM54USBGT16H7+iRsJIirzSgxRBNI7CT+6FicJazuohNFUMbNE1eqfZbmXiq+TC6ciuUOaem1ukv884Ci+PDtbGFwMCYOze0fPFm3ySGL9TNYIzMJ/m3zf8Z7xDkX9wOWKjtM5ZcI0h3nXrwwMVMAf24uUQh2Pf1tldsswNo7xJQolkzSOTRVtpxoWSq27WtPLoRbZRrw1Tmgrx3QKnBb6C7QSncqkbEuXHGjeXt4ArQ/gwRj95A01JhWMR3xyegZSd9ROtGXi/GeFNQ2UJp5rL4AeeaZQwPZQVjRCJbp4XUHvwVB959g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7dCQHBrWdIFzdae/2WVpDQFnc3/djbXyETJzXFFmjA=;
 b=E2rIfE6dLBfazvFa8F5psjcHDuf+TiI97l80JMBvtbmSqgQsEr4eOJoQd9B7W7fG9QwfAUac6wMhCzVI3FHSt9ty+bLXAjp6n5MmpRRREJt7Lj4w3jtuydaOGA7l/lPGP7o6KhD96Y6MMiBRf1MarOuQ6KjEBygc5q4EZg7C1/YOZmSrihvZtj9r8hQLtxKlFehKOlm6NDLSUs/D5bPBwV0yiKvWggjo2AbN1Dh5Dz5DQ4CicChmQoBFbHJA8Ji/UaA+I9M8DQBkyAo10//+OxPrU+p+8fzxLjmgt6MJCAW5FGB6tg36MaEr+TW/DMf1C19wUmApnriuiZ+/+0I6hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7dCQHBrWdIFzdae/2WVpDQFnc3/djbXyETJzXFFmjA=;
 b=l65RhYWnpIXzTMF57RKVczTuamqy3ngljRyWvo+EaEtDTkobWY2ASj8zTlRGLoIZgYkMfomnPppb1JDYZAZmnqKA+iDttTsE4YddU5ufuVr+82vDp/LPwHMevwRGJsw+EBLyna4hd0j0dizcnmDgtYxpb4jheDmmdKeG8KqDc7s=
Received: from CH5PR03CA0002.namprd03.prod.outlook.com (2603:10b6:610:1f1::14)
 by LV8PR12MB9156.namprd12.prod.outlook.com (2603:10b6:408:181::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Wed, 26 Jun
 2024 17:42:45 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:610:1f1:cafe::43) by CH5PR03CA0002.outlook.office365.com
 (2603:10b6:610:1f1::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.22 via Frontend
 Transport; Wed, 26 Jun 2024 17:42:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Wed, 26 Jun 2024 17:42:45 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 26 Jun
 2024 12:42:44 -0500
Date: Wed, 26 Jun 2024 12:42:31 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <pbonzini@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>, Brijesh Singh <brijesh.singh@amd.com>, "Alexey
 Kardashevskiy" <aik@amd.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Message-ID: <fbzi5bals5rmva3efgdpnljsfzdbehg4akwli7b5io7kqs3ikw@qfpdpxfec7ks>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com>
 <ZnwecZ5SZ8MrTRRT@google.com>
 <6sczq2nmoefcociyffssdtoav2zjtuenzmhybgdtqyyvk5zps6@nnkw2u74j7pu>
 <ZnxMSEVR_2NRKMRy@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZnxMSEVR_2NRKMRy@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|LV8PR12MB9156:EE_
X-MS-Office365-Filtering-Correlation-Id: 793becf7-549b-46a1-0a67-08dc96076354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230038|1800799022|82310400024|36860700011|7416012|376012;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?38Nx/5/ygOHfv4Mh0FB1fPoNT/oQWecBf1Dtttmku7XCaWhZbC0JJlIjrGXQ?=
 =?us-ascii?Q?OLrBicxLvWLpHG1YE3Mi5G0E8+m4sbdxCXdPMcljTfy5I0UHHlFc8fChTMP9?=
 =?us-ascii?Q?Db8CtczZ7OmMXfXwznu+yfSofL+Xib+f+o6s9XwpXNX7ZTO/IPplrTaRpK4X?=
 =?us-ascii?Q?AxSHfp0Y5bLCeTj+oIpVPb//ILXoDJrDCjRhSCtX2wGocBT/SDgNpjCVOelH?=
 =?us-ascii?Q?mjo6EvaY17gVWof4vYC++QTCYq3PBGTdg/tqB9olQGFH8hLlft7XaX0fiXJO?=
 =?us-ascii?Q?/Q17EzGFNl189eNeXu8UEInL8U8nbK2ody1YnkRThcUxrAgVrNb39QP/xgGU?=
 =?us-ascii?Q?DE322vEp14vDGQc7ADNfAiQ1bnd94kWmkLplUFzmCiUKR7BSDBc2WAKMS+gt?=
 =?us-ascii?Q?Yy1cCp80Rir6XB6cqfOJd0Xu4jt7ZMoTCgwPD1HJRhoriK540lMCAtQHet3R?=
 =?us-ascii?Q?qLjEe7TmEeW/HlklbZBAFbyL/LVe+uKbptq9QqJrYgFAglC1U7sxjV58EHgG?=
 =?us-ascii?Q?BrXvIN7ErITznS7QapyvyEL3LP92HoRtnQzjfm3SbCa4t7+GXi4SjE52oRwl?=
 =?us-ascii?Q?JLx0IN8S5aPdORqne2p5yCvV1VOnRHX69Pwn9K3655iQs1ACYBtd8tMgVi3q?=
 =?us-ascii?Q?K80LkU3NA+IZu8Uv61JeJwk2/PKLtJnnC0bdMsEPUTws9n0FKwUjaJVVF+yS?=
 =?us-ascii?Q?7PztjDjE4oQgnu6nCqQYGrZ2zGRP3V0WM9gf1iZLp9ZQdMATCfyRXcxOo27M?=
 =?us-ascii?Q?kLUy2UcTtrF3yBTIToZcBbqJmTkM7aZo6iIYoaounpzmFnb3n9gU1wPGJRc2?=
 =?us-ascii?Q?mAcnjeT6PIgDG6VbnuedKl/rjGsIsKDAHqArDEfoABBI1YkyO7ouuGm1C2q2?=
 =?us-ascii?Q?XEXSd2ex5xrxmbouCFPKluoIdKXDxlGVbTRpY4oYNI9uiA/sjlr+8q7xyrBm?=
 =?us-ascii?Q?pyKLn13koo/39LMi/kwhwQhk8xy8aaSsCbd0Kag4458LHcmSpO9k8vqNuESo?=
 =?us-ascii?Q?pn79fX8jj1sy3pQMGk6T5++qQYJ2TsERZI8LTBhw2MNAiM8E/Ew4/av7/u5L?=
 =?us-ascii?Q?96fzFVLe9n9W9CSqN3HCCtreY174YqyzuwnQOrJvlJf93eFR2DxYKsTf4URF?=
 =?us-ascii?Q?r9NiNpSmU6sdtmum1V8ykRfCtLolii7dPr8Fp3H6XpUgD5n5Tr5+bx8JCqyc?=
 =?us-ascii?Q?ashJvAcsJmu6UyusSpWJpAQS2EEFj8dCsL5D8lCMsiYZH/VIVxQ6N8qeTU1E?=
 =?us-ascii?Q?5O1+2cMDjsg8f+UepP7H1Mm/5+WsoKV/rJzGAyDu4FYOfDGP0ILzZqxdxDn7?=
 =?us-ascii?Q?ynazn4oPnrBVgGLoQSZeKcEyjmTjzzdU1TR+OmzyM5yN75BnvltYTwIEiyZn?=
 =?us-ascii?Q?ZU/lvAo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230038)(1800799022)(82310400024)(36860700011)(7416012)(376012);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2024 17:42:45.4063
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 793becf7-549b-46a1-0a67-08dc96076354
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9156

On Wed, Jun 26, 2024 at 10:13:44AM -0700, Sean Christopherson wrote:
> On Wed, Jun 26, 2024, Michael Roth wrote:
> > On Wed, Jun 26, 2024 at 06:58:09AM -0700, Sean Christopherson wrote:
> > > [*] https://lore.kernel.org/all/20240229025759.1187910-1-stevensd@google.com
> > > 
> > > > +	if (is_error_noslot_pfn(req_pfn))
> > > > +		return -EINVAL;
> > > > +
> > > > +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> > > > +	if (is_error_noslot_pfn(resp_pfn)) {
> > > > +		ret = EINVAL;
> > > > +		goto release_req;
> > > > +	}
> > > > +
> > > > +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
> > > > +		ret = -EINVAL;
> > > > +		kvm_release_pfn_clean(resp_pfn);
> > > > +		goto release_req;
> > > > +	}
> > > 
> > > I don't see how this is safe.  KVM holds no locks, i.e. can't guarantee that the
> > > resp_pfn stays private for the duration of the operation.  And on the opposite
> > 
> > When the page is set to private with asid=0,immutable=true arguments,
> > this puts the page in a special 'firmware-owned' state that specifically
> > to avoid any changes to the page state happening from under the ASPs feet.
> > The only way to switch the page to any other state at this point is to
> > issue the SEV_CMD_SNP_PAGE_RECLAIM request to the ASP via
> > snp_page_reclaim().
> >
> > I could see the guest shooting itself in the foot by issuing 2 guest
> > requests with the same req_pfn/resp_pfn, but on the KVM side whichever
> > request issues rmp_make_private() first would succeed, and then the
> > 2nd request would generate an EINVAL to userspace.
> > 
> > In that sense, rmp_make_private()/snp_page_reclaim() sort of pair to
> > lock/unlock a page that's being handed to the ASP. But this should be
> > better documented either way.
> 
> What about the host kernel though?  I don't see anything here that ensures resp_pfn
> isn't "regular" memory, i.e. that ensure the page isn't being concurrently accessed
> by the host kernel (or some other userspace process).
> 
> Or is the "private" memory still accessible by the host?

It's accessible, but it is immutable according to RMP table, so so it would
require KVM to be elsewhere doing a write to the page, but that seems possible
if the guest is misbehaved. So I do think the RMP #PF concerns are warranted,
and that looking at using KVM-allocated intermediary/"bounce" pages to pass to
firmware is definitely worth looking into for v2 as that's just about the
safest way to guarantee nothing else will be writing to the page after
it gets set to immutable/firmware-owned.

> 
> > > resp_pfn stays private for the duration of the operation.  And on the opposite
> > > side, KVM can't guarantee that resp_pfn isn't being actively used by something
> > > in the kernel, e.g. KVM might induce an unexpected #PF(RMP).
> > > 
> > > Why can't KVM require that the response/destination page already be private?  I'm
> > 
> > Hmm. This is a bit tricky. The GHCB spec states:
> > 
> >   The Guest Request NAE event requires two unique pages, one page for the
> >   request and one page for the response. Both pages must be assigned to the
> >   hypervisor (shared). The guest must supply the guest physical address of
> >   the pages (i.e., page aligned) as input.
> > 
> >   The hypervisor must translate the guest physical address (GPA) of each
> >   page into a system physical address (SPA). The SPA is used to verify that
> >   the request and response pages are assigned to the hypervisor.
> > 
> > At least for req_pfn, this makes sense because the header of the message
> > is actually plain text, and KVM does need to parse it to read the message
> > type from the header. It's just the req/resp payload that are encrypted
> > by the guest/firmware, i.e. it's not relying on hardware-based memory
> > encryption in this case.
> > 
> > Because of that though, I think we could potential address this by
> > allocating the req/resp page as separate pages outside of guest memory,
> > and simply copy the contents to/from the GPAs provided by the guest.
> > I'll look more into this approach.
> > 
> > If we go that route I think some of the concerns above go away as well,
> > but we might still need to a lock or something to serialize access to
> > these separate/intermediate pages to avoid needed to allocate them every
> > time or per-request.
> > 
> > > also somewhat confused by the reclaim below.  If KVM converts the response page
> > > back to shared, doesn't that clobber the data?  If so, how does the guest actually
> > > get the response?  I feel like I'm missing something.
> > 
> > In this case we're just setting it immutable/firmware-owned, which just
> > happens to be equivalent (in terms of the RMP table) to a guest-owned page,
> > but with rmp_entry.ASID=0/rmp_entry.immutable=true instead of
> > rmp_entry.ASID=<guest asid>/rmp_entry.immutable=false. So the contents remain
> > intact/readable after the reclaim.
> 
> Ah, I see the @asid=0 now.  The @asid=0,@immutable=true should be a separate API,
> because IIUC, this always holds true:

That makes sense. I'll look at introducing rmp_make_firmware() as part of
the next revision.

-Mike

> 
> 	!asid == immutable
> 
> E.g.
> 
> static int rmp_assign_pfn(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable)
> {
> 	struct rmp_state state;
> 
> 	memset(&state, 0, sizeof(state));
> 	state.assigned = 1;
> 	state.asid = asid;
> 	state.immutable = immutable;
> 	state.gpa = gpa;
> 	state.pagesize = PG_LEVEL_TO_RMP(level);
> 
> 	return rmpupdate(pfn, &state);	
> }
> 
> /* Transition a page to guest-owned/private state in the RMP table. */
> int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid)
> {
> 	if (WARN_ON_ONCE(!asid))
> 		return -EIO;
> 
> 	return rmp_assign_pfn(pfn, gpa, level, asid, false);
> }
> EXPORT_SYMBOL_GPL(rmp_make_private);
> 
> /* Transition a page to AMD-SP owned state in the RMP table. */
> int rmp_make_firmware(u64 pfn, u64 gpa)
> {
> 	return rmp_assign_pfn(pfn, gpa, PG_LEVEL_4K, 0, true);
> }
> EXPORT_SYMBOL_GPL(rmp_make_firmware);

