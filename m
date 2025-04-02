Return-Path: <kvm+bounces-42522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4265DA79818
	for <lists+kvm@lfdr.de>; Thu,  3 Apr 2025 00:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97B6F188A150
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 22:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE0301F463E;
	Wed,  2 Apr 2025 22:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PeWXXXEJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2044.outbound.protection.outlook.com [40.107.236.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D631DFF0;
	Wed,  2 Apr 2025 22:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743632280; cv=fail; b=Yul6jQ45azYs88RUXEz2+myAjVMG9VzO1HRTOeRdCBliXGKor2yVQ8IfO737Gzq/Z81HRGQeBagWf/vWmspLy+P7SzcEXsnXlwi2kSbXylL2tN2B38S+vcRGqv3u+5FzllnZbvLR+ki1Yw3513sXOdSACzXh/5+6+gObYYmpj1w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743632280; c=relaxed/simple;
	bh=6RV3H4gpTt6+EiVLZuEPuInSr94WJoAkBD2gU3LCD0Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rESmwdQrwWBfufNe/S8hBMoNSLGoCnY83AAVxIAsL9ItjVh/RUsq3UQcGRIpdiKnJuhgYWUeU1+TPGBUEsYFdfcjJ5b35EMoBe3cs/fV+NU9vhkq1dOcTSHi5RCRjD4MAZx969BmFcw06TFTKpUmcQwCOKCdzSfF6Vm33g1mICk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PeWXXXEJ; arc=fail smtp.client-ip=40.107.236.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1kvf/jHFRZzcgQuS6RiqCb2xCEHXlqYIGBU5zG42P3vkPGGAbebxuOOYmg4iN609AnAdFsh0r/amBf+grsR7TZ14H07fgpzHQNAEn1h+/SygDuFJsxVi1uChP4/9QjoBgUa313IX/uDKyAlv7+LXVCB8P3MB6A/1UB9G1jmP8DesDaHyjsZijz8DEh+XQU3iaoEbfT4e3b6PrIJJbp2rUX9UdzMoB4PzsztxB0Xm36fquBKRR0o0fBliXFgWgTYNCRjKqM6B1Wq+bk7qXZp3MAtpiPNTKzs0HKH63SOfoYRq+iUY9n02Ypp3TDwX4+HUgpq/EfmOHriAiPY86dHbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hBN1GNCKPC8jWPPRSxQeM7OeaQvUytNA+k2sj4hhY6g=;
 b=FsJUyspO15tU+dZFq2i6oTgn1MM9A7IgSMv8Ouqq54K0JSySaYtuU275+fAslTauWTrcPQe4nQt++BllwV+KvqBY0It4RW+KQuqnlocEmhe45uvgDmuYdT9Ae/ViHSV1AxjpDL7AIAR6Eq4UxP5QE41C0RPKCTbVUxR6nPGOxcOC9tJk/+TamylCvXcKg7aq4Y5r7fQyR7jfOkkmlTTp15zIjxkwWvU9FQNS3DQ2Yb/E3E8bNWOTOQztkFBKABfpmGvBXGdcaiAqWZ5mwBMwvE3aTg1AmrG/VZx09EfZ82NhYnPSzNJsNLpBjXlkBimJF7dgJsD8AaeffVFnPrXLrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hBN1GNCKPC8jWPPRSxQeM7OeaQvUytNA+k2sj4hhY6g=;
 b=PeWXXXEJLoQfYHv5m+kOfmdrfSVB1s1j/wikbvmPLfj7eId9Sgv3UTIpmAnqfEM+dUF+shw3AKfUwdZTnE36P0J29tde1GFGQwnu1CFKdGQ/Fgdqi0OOpQ9FCmLGFu2x/vfNGokDjI8SzFXg9ZIqVBSIl9nxCLNDToDZWrukeRI=
Received: from BL1PR13CA0377.namprd13.prod.outlook.com (2603:10b6:208:2c0::22)
 by PH8PR12MB6867.namprd12.prod.outlook.com (2603:10b6:510:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.50; Wed, 2 Apr
 2025 22:17:54 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::b1) by BL1PR13CA0377.outlook.office365.com
 (2603:10b6:208:2c0::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.9 via Frontend Transport; Wed, 2
 Apr 2025 22:17:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8606.22 via Frontend Transport; Wed, 2 Apr 2025 22:17:53 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 2 Apr
 2025 17:17:53 -0500
Date: Wed, 2 Apr 2025 17:17:39 -0500
From: Michael Roth <michael.roth@amd.com>
To: Fuad Tabba <tabba@google.com>
CC: Vishal Annapurve <vannapurve@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>, <pbonzini@redhat.com>,
	<chenhuacai@kernel.org>, <mpe@ellerman.id.au>, <anup@brainfault.org>,
	<paul.walmsley@sifive.com>, <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>,
	<seanjc@google.com>, <viro@zeniv.linux.org.uk>, <brauner@kernel.org>,
	<willy@infradead.org>, <akpm@linux-foundation.org>, <xiaoyao.li@intel.com>,
	<yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>, <jarkko@kernel.org>,
	<amoorthy@google.com>, <dmatlack@google.com>, <isaku.yamahata@intel.com>,
	<mic@digikod.net>, <vbabka@suse.cz>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <david@redhat.com>, <wei.w.wang@intel.com>,
	<liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
	<kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
	<steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>
Subject: Re: [PATCH v6 5/7] KVM: guest_memfd: Restore folio state after final
 folio_put()
Message-ID: <20250402221739.yqvuuiuxvvphgijd@amd.com>
References: <20250318162046.4016367-1-tabba@google.com>
 <20250318162046.4016367-6-tabba@google.com>
 <CAGtprH-aoUrAPAdTho7yeZL1dqz0yqvr0-v_-U1R9f+dTxOkMA@mail.gmail.com>
 <CA+EHjTwZaqX9Ab-XhFURn+Kn6OstN3PHNqUi_DxbHrQYBTa2KA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+EHjTwZaqX9Ab-XhFURn+Kn6OstN3PHNqUi_DxbHrQYBTa2KA@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|PH8PR12MB6867:EE_
X-MS-Office365-Filtering-Correlation-Id: 89233117-8d5f-4792-be8b-08dd723436c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aWkvekQxcDk0NXA5akx4NEhZY1dIN0NjQytFUUtLUlFqL3NCdXlnMit6bHJJ?=
 =?utf-8?B?MWs0Tytwd3NVanJDSUtneWsrZTg3OC91UHJJSFJndVhVQmxveFRPaUNDY1U2?=
 =?utf-8?B?YjZ4Y3ZCVlIxTmFFdHJVNnN5Q3QzdkROV3pyR3ZYbS9aV0ZWTnNhNDBlZU85?=
 =?utf-8?B?UXFOUFZmNWpqUWUwN2E3dlVkRmUrdjRXR3JROWNkeDF1Z0tzRUtGZXh2VEJi?=
 =?utf-8?B?TW1qbEZFVXVCeTI0R3NSVzhGTGtxVlFTR0w0VkVDVTg1N2JzMDJVOVY2eUZX?=
 =?utf-8?B?Y3YxSTZLdzVOUEloS3NsK0NhSkhDOGFTdmVoRlpUa0NRZHplNXN6VlQ3cFJI?=
 =?utf-8?B?M1VCK2t0VWQ3Z1JnNHdKYWwxeDFvc3p5d3JOdWo1VTQrVXNRTjArVWhta1Er?=
 =?utf-8?B?VWZEeHVxemhjTmsxaTBYNDJUQ2RFSUdkN20vK3pvTG5QNmsxRS8zZlZhdnIy?=
 =?utf-8?B?UE5FZEEvV2JxcnpaYnBRb2pRUGp1MnRoUWhIQ3lYTDZwR1NKblp5OHVvaGFz?=
 =?utf-8?B?R1psNmIxd3FybXkxMThSeGw2L2VxNUJHU1BFRHZBeXF2SmkzZFNHOVFFUGFl?=
 =?utf-8?B?YnkzNUwrZG11ZGkvZmJBWGNjUXpjTXYvM2JGSXZHSUd2cjErbkNmaVlBS3Jr?=
 =?utf-8?B?elBDQVJDQmR4OVUySllJcDZqdHp2L2VFWFlFQzdBd0hxVXZ6eGdvMFFaRzRY?=
 =?utf-8?B?bFgvU2t0bWZQWDBUNEJrMWpnbGV4WDZmOXlobFFIT3cyYWZDSDNuSDhwQ1R0?=
 =?utf-8?B?dTlzaXJENllUTGVCeVEzbXMwaFJ4Y1p5Y2drMFdQcXR6eExuT2hPTlBzWVRj?=
 =?utf-8?B?YmViY3ZaQXZQemRxRFUwcU13MzVBTmhocTJydWVPSE1McWlOQlRCTDg4VFRN?=
 =?utf-8?B?VjBYbTluNDk5emNYOENRQmZCRFBERGhDbjVZTmNGR2N6Y0F4czE3QUFuTjg0?=
 =?utf-8?B?a2R4blkxS1VJMTFVVmVlNEVncTFNK0N1Zk16ZDIxMklnYTY1dDNiMFNFWml5?=
 =?utf-8?B?NVZlbmx5VzE3eHJSbk8wOVN4MCtUZ1ZjNTdLSnpNam9ydiswUHFMVHpRd2R5?=
 =?utf-8?B?andXc0FmM3JSVTFXck50VXdJdEwrSldzc2dQOWJ1bkZwRWRCYklTT0NhYTl1?=
 =?utf-8?B?TjFxK2dGZy94aWRpVnIxSk5zU0tEeWNRdHpPSGxQdTZXQWFLVHlydHVwcXpt?=
 =?utf-8?B?Mit2ci81SVNxMjNqWnJLYjlhOTFBeDQ1SnRWdUpoSjdSVTFNYXFVWE5vN1E1?=
 =?utf-8?B?T1IxYnBlR2FzMk42TW1ad0o3aUpHNFc1YXF2TVIrL2lKYkl3S29DejBUYm5G?=
 =?utf-8?B?WHFBMkRSMzV4bG43Z1hRZVpmUHpCM1VSa2cxU2NTdHBnL3BFSmRWcjFGMFly?=
 =?utf-8?B?U1NaM0owaHBZNm5mZzhPNzN2Z3E2ZVB2SWpnWGVsQkJEejRMeUtGWXFiRkRu?=
 =?utf-8?B?VER0SU00Z2MxSjVZTXZwZUJsV2U4aHhIM3pZQVgzUlkxbW1FcHRJY01wK2h4?=
 =?utf-8?B?UnZQeG5RU2x2YVRITmpBNU9xSUk2TkkrTjlnZ0pZVVdCY2tPZ2NSYU1UR1lS?=
 =?utf-8?B?dVlkZFE2NkhCVk9nQ1BtZWJNN3hCVFJaU2swNiszUFhQT1d4bTgvYWluRlNX?=
 =?utf-8?B?T1ZXNHIwU0NuNXNLOUpRbm5MeENneHJHWUxJeDN5bmxJa2REK3VaSVJuVU0r?=
 =?utf-8?B?QUJWbFEwbG1Xek15YXJBTzRRc2dtUUJIV2lBZzNSYzRabWFiQVNRcENmK05E?=
 =?utf-8?B?SEw3L3I3Y000NkljbC8vR3pGZGN3TW4zSDVncXRtTTErMUVJc2paMW1xTUVE?=
 =?utf-8?B?cnVFUHFPR1lLVnZSdHNGUlNBNm00a3pueXRDaTlXaFZTekQwWVVXcFBkT0lj?=
 =?utf-8?B?T1JCTkVhaC9Bb3RCWmJwWTNGemVRWHBYVFJ3c0xvVXJDbHkzZ3drNjFwWUM3?=
 =?utf-8?Q?27ZrAHCrYo0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 22:17:53.8910
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 89233117-8d5f-4792-be8b-08dd723436c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6867

On Tue, Mar 25, 2025 at 03:57:00PM +0000, Fuad Tabba wrote:
> Hi Vishal,
> 
> 
> On Fri, 21 Mar 2025 at 20:09, Vishal Annapurve <vannapurve@google.com> wrote:
> >
> > On Tue, Mar 18, 2025 at 9:20 AM Fuad Tabba <tabba@google.com> wrote:
> > > ...
> > > +/*
> > > + * Callback function for __folio_put(), i.e., called once all references by the
> > > + * host to the folio have been dropped. This allows gmem to transition the state
> > > + * of the folio to shared with the guest, and allows the hypervisor to continue
> > > + * transitioning its state to private, since the host cannot attempt to access
> > > + * it anymore.
> > > + */
> > >  void kvm_gmem_handle_folio_put(struct folio *folio)
> > >  {
> > > -       WARN_ONCE(1, "A placeholder that shouldn't trigger. Work in progress.");
> > > +       struct address_space *mapping;
> > > +       struct xarray *shared_offsets;
> > > +       struct inode *inode;
> > > +       pgoff_t index;
> > > +       void *xval;
> > > +
> > > +       mapping = folio->mapping;
> > > +       if (WARN_ON_ONCE(!mapping))
> > > +               return;
> > > +
> > > +       inode = mapping->host;
> > > +       index = folio->index;
> > > +       shared_offsets = &kvm_gmem_private(inode)->shared_offsets;
> > > +       xval = xa_mk_value(KVM_GMEM_GUEST_SHARED);
> > > +
> > > +       filemap_invalidate_lock(inode->i_mapping);
> >
> > As discussed in the guest_memfd upstream, folio_put can happen from
> > atomic context [1], so we need a way to either defer the work outside
> > kvm_gmem_handle_folio_put() (which is very likely needed to handle
> > hugepages and merge operation) or ensure to execute the logic using
> > synchronization primitives that will not sleep.
> 
> Thanks for pointing this out. For now, rather than deferring (which
> we'll come to when hugepages come into play), I think this would be

FWIW, with SNP, it's only possible to unsplit an RMP entry if the guest
cooperates with re-validating/re-accepting the memory at a higher order.
Currently, this guest support is not implemented in linux.

So, if we were to opportunistically unsplit hugepages, we'd zap the
mappings in KVM, let it fault in at a higher order so we could reduce
TLB misses, and then KVM would (via
kvm_x86_call(private_max_mapping_level)(kvm, pfn) find that the RMP
entry is still split to 4K, and remap everything right back to the 4K
granularity it was already at to begin with.

TDX seems to have a bit more flexibility in being able to
'unsplit'/promote private ranges back up to higher orders, so it could
potentially benefit from doing things opportunistically...

However, ideally...the guest would just avoid unecessarily carving up
ranges to begin with and pack all it's shared mappings into smaller GPA
ranges. Then, all this unsplitting of huge pages could be completely
avoided until cleanup/truncate time. So maybe even for hugepages we
should just plan to do things this way, at least as a start?

> possible to resolve by ensuring we have exclusive access* to the folio
> instead, and using that to ensure that we can access the
> shared_offsets maps.
> 
> * By exclusive access I mean either holding the folio lock, or knowing
> that no one else has references to the folio (which is the case when
> kvm_gmem_handle_folio_put() is called).
> 
> I'll try to respin something in time for folks to look at it before
> the next sync.

Thanks for posting. I was looking at how to get rid of
filemap_invalidate_lock() from conversion path, and having that separate
rwlock seems to resolve a lot of the potential races I was looking at.
I'm working on rebasing SNP 2MB support on top of your v7 series now.

-Mike

> 
> Cheers,
> /fuad
> 
> > [1] https://elixir.bootlin.com/linux/v6.14-rc6/source/include/linux/mm.h#L1483
> >
> > > +       folio_lock(folio);
> > > +       kvm_gmem_restore_pending_folio(folio, inode);
> > > +       folio_unlock(folio);
> > > +       WARN_ON_ONCE(xa_err(xa_store(shared_offsets, index, xval, GFP_KERNEL)));
> > > +       filemap_invalidate_unlock(inode->i_mapping);
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_gmem_handle_folio_put);
> > >
> > > --
> > > 2.49.0.rc1.451.g8f38331e32-goog
> > >
> 

