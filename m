Return-Path: <kvm+bounces-52551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A78AB06979
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 00:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A35027B04D1
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 22:55:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D692D1F7E;
	Tue, 15 Jul 2025 22:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DwcLe2S7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B4945945;
	Tue, 15 Jul 2025 22:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752620188; cv=fail; b=hS55n1NrMgFCh/LmdC44mxwRFU7IXMjIFOIibv+O6OlolBJl8PH0KDmthPE+uXH1DWdhFp9IOr94SsxTV0nw+uvpvuv4avfnDAFioTBYECdiidDLhVmN36bGo+P1XfOX1rz8iF1ecL7KkPg5sK149OTJPHlLEI04cv4GP5/E5Qk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752620188; c=relaxed/simple;
	bh=Du7X2dc42RYNqmuJ6CqWqJqmgNnzObopKmfFxjNTZ2Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W1ZEX3RS5xH/U94CR3Sgdpc/D2V4kV6eNDLOM/zs/PhkmA/+tVxF5HrmWkAAc+Ty2N08gwHpzm5nN6qd7ebxKoeUpvulYWeY8Ttjrkej9Pj+gDFnZszTMuS/ySMvIrKEn/fowFDKa4X4NBzcbvsluEOlWMIn1bzbiYGGnSJTqoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DwcLe2S7; arc=fail smtp.client-ip=40.107.102.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F33cYPUk7ltE6y6/X4t9eF7d6Cj4lpMHwytQoql0ejBDQl08OlPdZ38zg9Ls61Rmustn4ZcOWXpxfe4SeQ/RfIYo7WmLxtkLv7VmxtY7xpZB/VdbRcCykM6L9DORCKR3EKme2O3Z45PcN+FhSac0EKhRvR56k9ycbQQmbsLGHXx8+e5Vdv0boyfE6UPQoDVLxQMlbYj/N+dL1+m2k3/PAEFyHbFfKvxLAZEtVkAp4qN+OUYrQft6qNkKp3mmcGrqT5yjbvsU8o4DlCs040VR8Ydk6pMkYzpp0mf6RJ1em2yfMjGqEC1P7aCldMnSYbfZ8wggA39net/bFW51qtBMGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgaJgzjhfii8WeXLuQ32oWUkapATGNZrzZ7aaHqGtGw=;
 b=GIYgAqfxMUXrG2TBQme1MI8Fc+jB+zvxmc5fhWGvJOd0WmlyoM5bohwbkImiOWqNcF5iVr6vwRaN8H2DTK8lAkAcZHVV080mU5dSgq0ghAQBO0lzfLZ1EvpBU3fnOcwfEHFdcODbQ+rXcJFcDXfUIjztdipagYim3syO2U3nLM1tDIgxf95FbHk449dW9VZWs9UIvuNWxMWENDTdnNlmT4eDUlDJ4h97SUQudBrfEeSDKgS1daUQqVRWMkDXl66HZdzVrZVXd1UpShmJKb3wPVcMGbHIPigqcV4ltpioq8ypmA1BbqTRLshDBB3X9d2aC6sTfZqHNdE35ML0Us7OEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgaJgzjhfii8WeXLuQ32oWUkapATGNZrzZ7aaHqGtGw=;
 b=DwcLe2S7S1vPckiKwT7yeWb7Nyqsa3BRxm7d434imISGAXAqwwW08Tdl/sqaOSzFLMV+TiJoVOoa6WiXBaWNFFMWRTAgyCTUk2ozClyWlGpScBGwlf709zqC75bCH6hXTL2mTFfPBDtjAsNTD/2qr8qN/Kegxn+W9ERqp+8NMm4=
Received: from CP3P284CA0067.BRAP284.PROD.OUTLOOK.COM (2603:10d6:103:6e::12)
 by DM4PR12MB6085.namprd12.prod.outlook.com (2603:10b6:8:b3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 22:56:23 +0000
Received: from CY4PEPF0000EDD1.namprd03.prod.outlook.com
 (2603:10d6:103:6e:cafe::4c) by CP3P284CA0067.outlook.office365.com
 (2603:10d6:103:6e::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Tue,
 15 Jul 2025 22:56:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD1.mail.protection.outlook.com (10.167.241.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 22:56:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 17:56:19 -0500
Date: Tue, 15 Jul 2025 17:55:23 -0500
From: Michael Roth <michael.roth@amd.com>
To: Vishal Annapurve <vannapurve@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<ackerleytng@google.com>, <ira.weiny@intel.com>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<joro@8bytes.org>, <pratikrajesh.sampat@amd.com>, <liam.merwick@oracle.com>,
	<yan.y.zhao@intel.com>, <aik@amd.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
Message-ID: <20250715225523.yzmrwghbhi56tqux@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com>
 <CAGtprH-vSjkNyQkdqjgnqkK7w0CM2CbewxTwq0XBOXkE8C1WvA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH-vSjkNyQkdqjgnqkK7w0CM2CbewxTwq0XBOXkE8C1WvA@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD1:EE_|DM4PR12MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: f2d0497a-cae5-440a-a674-08ddc3f2d0e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|7416014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d3hWLzVRakVVYzhZM0J4OFRBaDIwK2txcjZrQ2h0ZERaakJIRjJvY2lhQlcz?=
 =?utf-8?B?di9pR2kzQ1l6VitpRlpiUmZQQ1BLN09RTGl6elorbm1ERHNlVkF5NnMray9V?=
 =?utf-8?B?aWlLU1NPV2dpQXBneEpEM3VaeU1Zbi8xMVhGandBOWJucHpLRHJ6U0llL25n?=
 =?utf-8?B?R1BLTjBpenpzNURVUEFkYVlTb0F5WGkySVVrTjV1NExYODUrUkJEMFVNclVZ?=
 =?utf-8?B?ZTVvOHFoTHJhckhMSlNoOURidmpiemUxVlRJckxBZWRGdGlkdGdRZUl5ZTFm?=
 =?utf-8?B?ZWthQVJZOGlwOW41MEtTb1Y2V3NYWkJ1S3cwWGdVU0pwSjNtOFp3VnQrcWkv?=
 =?utf-8?B?UGt6UGc3cnNRakxOYUpWa1FBUm1KZXNaR0dXSjNZc1RoanlxR05pVHltRVZT?=
 =?utf-8?B?a21Vamt3Z0pheC9kdHlkNm9kdHFUK1lHK2pHV2ZSM3d4RW9JTmdaQUFLbUJW?=
 =?utf-8?B?aDNPbVlFQjFRS1dTQVFNbGVjcEkzd0pmRURhcTFNRGdmUkxETWpyWnMyd3kw?=
 =?utf-8?B?b0pPa042RFhHTEovYzFRT3VhTEJDelZiN0Q3cnE0RDZtYzh3Y2l4dzZ3ZmNQ?=
 =?utf-8?B?NUN0ZFhNR2VjRmVLMEpJUXVSRUdnU1I3SXdFaGpmZ3NoalRhYVJ5bmZmZisv?=
 =?utf-8?B?Mkp4MUdzckhmSDZ3ZlhseGZ3Rk83ekgraHZNZG5QSVo0SWFLSDVqSStJMVkv?=
 =?utf-8?B?ckRkSlVmZFBpN3ZTYTZWdGFVSGNPdFIxUjdwQjJjTmJ5M0VoRStEOFovcDRj?=
 =?utf-8?B?ODZBcVpJN2pBZ3pPYVpEempXYXhGOW9LS3FVRVR1RFdkaTBaM2tXc1c4T1VH?=
 =?utf-8?B?TUdWcVlPR2dJM21GaGs0SU1OUldvYUp3U0pLL2ZSSVBKTjk5d0ZtbzNpOVRa?=
 =?utf-8?B?QkVDNlB5YlBCZURGYWF4WnpIemlhWHl3c0g5VGlWOUlveU1CbVp0ZmxvN0pw?=
 =?utf-8?B?OVlmeGhOWmUycjNvRXNXZjlNSUdLQ3cvODRDejd0SnlYMzBXbFRaRVBDOU1n?=
 =?utf-8?B?MGRPTmJDSXVCUHY2MXp0Q0VncWhndGRSemszUHNBdGsyekRkWTgyR3I1cE1o?=
 =?utf-8?B?Z2poeFBMSyttQU81Ym1KVXFmNURwTHBFRjR2OG5ielZRYVA4dzJYeFNQTzJP?=
 =?utf-8?B?cHhjRXpRYW8rN01EaFRsWkRvZTExQ2h2NFNOMXdPRlVIbmd5VTJaSXc2blFo?=
 =?utf-8?B?djR4c2xOOU94ZERMUVN0OVlqZ3ZGRzk2cWFyb3JGOGtScTBMYW83WjFPZG9m?=
 =?utf-8?B?cmJ2VExzdGNaZHYzcFErSnNvOVVHb2NxZi9vbHppNkU3Vytuc05qK3hSaVor?=
 =?utf-8?B?K2doZys0a2NtUUhqb3U2QlpWZUt4cGgrNm9CK3RWMk9GbGxmODg2ekFvaFdt?=
 =?utf-8?B?M0Z3OHhrYkhEWmRpSk9pZXlvRDVoMmh2bXlTaWUzb0RRQndnQ0MremNoOTRn?=
 =?utf-8?B?M1NYeFZndEJ4YUQ2VHVyaFI4NDlKZ0hoRGd2K094QjRncDIxYjRqMFNadWtH?=
 =?utf-8?B?MHBkL3dGaFl4dDFKVk16NTc5aHNnK0VRV0VEaG5lZlRQTUNFeHpBSDRsMzJX?=
 =?utf-8?B?Q295RmJVbDhPVDg4T29vdzhiUXRtbzl6UHFQUWFObEpoK3FqVUVWZk1WSkhx?=
 =?utf-8?B?Q2g5bkgyQVdzUVFLT0l2cm5KUXBjSUFtc21BbDhEaGl5UHk4TVNtYk1hRlls?=
 =?utf-8?B?eGV3Zm5UdER2YnFHUzJjdDJaZ1BHRVNPdmlhU0FMZjV5U3dmaFpOR2p5Z0tX?=
 =?utf-8?B?Z2hMM044NHJJVGNEOXZFdXhwRFpLVVpSZnVpb1VGcnhxRExGS0ZSL012MG1Q?=
 =?utf-8?B?ZUxpNWVUaG8zaDdsajdoTGhmdldjNXdCL0cyaTFqTXJoZktYdENGUzh1STdr?=
 =?utf-8?B?TVFnQ2poVDQ4QkJiZk1vL21Dd1orelg0T2hPb2hWUlh2ZmY2cVBhRzIyK1Zl?=
 =?utf-8?B?d2V2aTlHcU1VM3l5SGJEN29BLytTWE00T01VRjVMRzZKdy9kRkEvYXUxRkhE?=
 =?utf-8?B?QWtnaXRQa2JZRVZ4TmZuVWZrTURISFpmcXdTcklsUkw3aUpIMXIyYitkamoz?=
 =?utf-8?B?MnJNVzVkMVRDbVROTlEvdzduYlQ4ak1NVHU5UT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(7416014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 22:56:20.9814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d0497a-cae5-440a-a674-08ddc3f2d0e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6085

On Tue, Jul 15, 2025 at 05:47:31AM -0700, Vishal Annapurve wrote:
> On Thu, Jun 12, 2025 at 5:55 PM Michael Roth <michael.roth@amd.com> wrote:
> >
> > guest_memfd currently uses the folio uptodate flag to track:
> >
> >   1) whether or not a page had been cleared before initial usage
> >   2) whether or not the architecture hooks have been issued to put the
> >      page in a private state as defined by the architecture
> >
> > In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> > there do not seem to be any plans/reasons that would suggest this will
> > change in the future, so this additional tracking/complexity is not
> > really providing any general benefit to guest_memfd users. Future plans
> > around in-place conversion and hugepage support, where the per-folio
> > uptodate flag is planned to be used purely to track the initial clearing
> > of folios, whereas conversion operations could trigger multiple
> > transitions between 'prepared' and 'unprepared' and thus need separate
> > tracking, will make the burden of tracking this information within
> > guest_memfd even more complex, since preparation generally happens
> > during fault time, on the "read-side" of any global locks that might
> > protect state tracked by guest_memfd, and so may require more complex
> > locking schemes to allow for concurrent handling of page faults for
> > multiple vCPUs where the "preparedness" state tracked by guest_memfd
> > might need to be updated as part of handling the fault.
> >
> > Instead of keeping this current/future complexity within guest_memfd for
> > what is essentially just SEV-SNP, just drop the tracking for 2) and have
> > the arch-specific preparation hooks get triggered unconditionally on
> > every fault so the arch-specific hooks can check the preparation state
> > directly and decide whether or not a folio still needs additional
> > preparation. In the case of SEV-SNP, the preparation state is already
> > checked again via the preparation hooks to avoid double-preparation, so
> > nothing extra needs to be done to update the handling of things there.
> >
> 
> I believe this patch doesn't need to depend on stage1/stage2 and can
> be sent directly for review on kvm tip, is that right?

Yes, this was actually tested initially against kvm/next and should not
cause issues. I wanted to post the change in the context of in-place
conversion/hugetlb work to help motivate why we're considering the
change, but ideally we'd get this one applied soon-ish since the question
of "how to track preparation state" seems to be throwing a wrench into all
the planning activities and at the end of the day only SNP is making use
of it so it seems to be becoming more trouble than it's worth at a
fairly fast pace.

-Mike

> 
> This update paired with zeroing modifications[1] will make uptodate
> flag redundant for guest_memfd memory.
> 
> [1] https://lore.kernel.org/lkml/CAGtprH-+gPN8J_RaEit=M_ErHWTmFHeCipC6viT6PHhG3ELg6A@mail.gmail.com/

