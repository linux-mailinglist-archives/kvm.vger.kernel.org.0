Return-Path: <kvm+bounces-15424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C05FA8AC064
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7710328128B
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B4E63BBCC;
	Sun, 21 Apr 2024 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GzB5yNSG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D1518637;
	Sun, 21 Apr 2024 18:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722435; cv=fail; b=VVbpVeZfV8S9Fk3JL9pj+i5/LtCfxC6iH3284hMPvty4NFhiVKKeXx3051CrJAxgkSlU5vNFC9H8wusLDZdbw7Wq2tny2FIAO6WOC74AsLhv/sVO5eLTuno8m1fJhtXbYI37+qfjMz6iOYucEKZg24ts+9HEQvk1lyLBKZCAiO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722435; c=relaxed/simple;
	bh=qT1YvRpYBoPsXtpMKCKRGLqpCUIZ5BO06KiEt5pFEV4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCvQnLRRSEXDEIOsUynmrBBnFy89ROFjwMvEuL/yqWVyISBegLCCrM6dWAYho+sb59dKOF1ZDTtDyxu1iUEDacm9yalQUiZpZXCwwnZ3aVzDdQ5pniOpbo8hgR2mLumoj/hnlOca2rEzRPpC6UPixlaNo6EPQjBo7Oj3mkX3YtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GzB5yNSG; arc=fail smtp.client-ip=40.107.94.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTgAhSVVTUebrN3jKJn8SFn1XFV72RA/CW3PioZ3XhPYoKMnk6ACXzRMyVhQeJ9lMnOdFB2Y+h3ctJANSTh9qrqVh6AwxgmSsW1Q6tlfe5hWJxrqD1nzhmbu7iIBxw6lfZQsiYS5dP8SxzK4BjcMVBKud+o+QU0t48ZtcKS2mOObzOS8Bj61N7k9W+EApF0iF1T3+E32/fngO2wmjF0fTIuUbI+bl1DUBwgoLAWkNG5ZyeKjlXE/v3ESrY7glhryKmf2lUScnW6owZbDmVDGAJQi9To8czlFcJPMkvsPe0EJxYiZDfrhw/Ef1o+vcRCMYhIUoAaNmEZAtmDxKQeXHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M7vjK2QyHNx9nBCP7/JfqxfYygYQmQBzxkrmv6iwSwc=;
 b=g5R+BYyhoke9LqjbhjTxoYfRQp+t3QQitHxEXqsU1Hgv1W+q0CrSJiNJ4ZWumRqkXjY14zGlwRHJSPRdobx8FEQvIxntn7y8ncNXnCaNnaDy43SoinyE2pkEgxprN9kXlAK9S8e0jJS+uv5qow8SSJr/6zDgcmlUIW6xPO+/BJ4tEMBlZaMeQxY8oDlDO3sTMbpzlRH36fnocnFI/1IRavc9sIffMLMksCMk4bu58DN8AAhUN6FdIcm8TuBZC7ePNnczqtJlSqa1qSN+INAXJ5oT+pJ06qci23BkW84jbu7S/qbRGnbThgEwjNicJnkwDxsapEmAIWznkXEY1nPn6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7vjK2QyHNx9nBCP7/JfqxfYygYQmQBzxkrmv6iwSwc=;
 b=GzB5yNSGBHCm2kcFCRoWXhcpiGkUrkbJvYwHwksUNx8R7KYqmVbYL0lmhvMrkwjuH29GTBJ0lz8oxqAbcTV8YDKyhG/TWTjuomAVz9B4xKkB0ShiDvK0xOv6EB+03Z5w5A3hcvJxg56+QPLISxDq60mB9VZaS6EGAC7CGZffwuo=
Received: from SJ0PR05CA0136.namprd05.prod.outlook.com (2603:10b6:a03:33d::21)
 by IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:00:30 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:a03:33d:cafe::a9) by SJ0PR05CA0136.outlook.office365.com
 (2603:10b6:a03:33d::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.19 via Frontend
 Transport; Sun, 21 Apr 2024 18:00:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:00:29 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:00:27 -0500
Date: Sun, 21 Apr 2024 12:52:50 -0500
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
	<brijesh.singh@amd.com>
Subject: Re: [PATCH v13 10/26] KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
Message-ID: <20240421175250.lkjauspowo5y7c6k@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-11-michael.roth@amd.com>
 <CABgObfaj4-GXSCWFx+=o7Cdhouo8Ftz4YEWgsQ2XNRc3KD-jPg@mail.gmail.com>
 <CABgObfa9Ya-taTKkRbmUQGcwqYG+6cs_=kwdqzmFrbgBQG3Epw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa9Ya-taTKkRbmUQGcwqYG+6cs_=kwdqzmFrbgBQG3Epw@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|IA1PR12MB6353:EE_
X-MS-Office365-Filtering-Correlation-Id: fe74ee6e-2bda-4e0a-b838-08dc622cee54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MVcrc3p0Vnh3dWFucVdQT1FpejNNaEZmOWZ4YS8wMlVVOHNhODZBUk10V1pr?=
 =?utf-8?B?Tjl2bWZsZzhhQ2hjQWlTZDQvZWJzbFN2NzRKaXFMU01McExadUtXMUFVci8r?=
 =?utf-8?B?MmJ4WmhGU2FwWDFLR1BZVzJ0VDJ3cGRCam14Q1JPZUtFK2MzTEVkVm1GYW9W?=
 =?utf-8?B?S2sweE0wQWYxdUprSFE2Mk85b1N0YUIzQnhTZlFKZkdZdnM5SEgxWEVSdk5Q?=
 =?utf-8?B?OC9jem9XVXRhM1pVN1pQa3R2UjgzTnR6R0FGMGJKZlJJWkJrWVRPeVNYYnMx?=
 =?utf-8?B?amZoampBNHVVWTFaMmRodzBkM25LcjZETXNNRHRUK3lwR1phWGtlMUFFemdu?=
 =?utf-8?B?UzB5L01FRjFDWGN3L0doUzQ4UHAwejE3UTk5VWU1M0FwRjJndytPamVMOVgv?=
 =?utf-8?B?NktyejQwVnZhRkVWUVg5TERIcXlqRHNUVW9QVVlRL2VySnJWdjR1d1hia2JH?=
 =?utf-8?B?S1d6OGsyM25Od3A3dHpmNk0yU0xrd1IzQXJ6VExTUmdXV0dSYmE4SWl3NHZy?=
 =?utf-8?B?dWVwQk5ncFZHLzh3aGdRS0tPR0NqUVkrcmlkSXcvUGc2eGVUMG5QdFUvd2RI?=
 =?utf-8?B?d0laNlN0djNRajNVZUhwdUtPcCtoRVZTWllpWkZHd1ltWFo5YVJzLzV1ZnJE?=
 =?utf-8?B?RWttblVUR1FHYkwrdXl5cUZZeTZqT3cyR05ObjFxUURrN3JMeE1jcy9GWTdi?=
 =?utf-8?B?Wm45WTI0ZGZMNDVXT2dGWUxYV3dYU0g5d0JDTVYrZnBYT1BlRUltQ1psQ0Fz?=
 =?utf-8?B?QUc4VHlSajlaUXlQZSs0ODlPbEc2UjJqODFEVGV1SkJBcGZiak4xc0Z2NXdq?=
 =?utf-8?B?MlA5K0hERGdrV3IyQjJkUDdMNU12djFjZy8zVDlxRHZJdVRwTVRJcHR3alRO?=
 =?utf-8?B?RUlwdmZQcnloNFBBbjVqT2RHb1owbGxNNkMydVhJNTVzTXNBK24vWFRaMGcz?=
 =?utf-8?B?YnBmM0dqOGlpenZrS29XR2V5NFFhTEI4TkJQd2xFUFhuSHFNaUZQeno2VjNv?=
 =?utf-8?B?dmNVa3c2S2ZubjNJNUovcUpwN3pBVk4wejhWdm5TczA3bnNaMVZEdkdqNERv?=
 =?utf-8?B?ajZhYmZRR0hYR0tDOGhXcDBiemxCbm1IN2IxWUxER3R6T0ZKbzBkaXhuRlc0?=
 =?utf-8?B?Tm1pVXh3THdiR2lmMTJXM1JjWGVDWWVLVEduMjRzZ1NzOUg5b05SWU5obHZY?=
 =?utf-8?B?WmVINVlYYjd5NjdVcS92NTVuZ1F5NkFlMWJGb0NIV094Q28vdi9ld2g1aklE?=
 =?utf-8?B?VDkrUTdBNDFMcVpUeHBzbnRBajNIZzk5bU1odGZ1bVZaYzUxb2x6UEZJK0k4?=
 =?utf-8?B?L21IMVovNFdkazZEaE9URnFJUFBwODJCUXhONnVmcEpxWWMydEpUSjF3L0RG?=
 =?utf-8?B?Zzlkd3dyR3NCbnhNVjZDSlN5SERVQnF0SGMvN253MDAwdEFaSWV0eW1RVVE4?=
 =?utf-8?B?eHpDaGUrSGdZUlA0L0RhWktOTTdveXhhQ3JYTUxoTnFkT2lseXFZQjJrczBi?=
 =?utf-8?B?YUJQVjFqRS95TUZxMWtnT3lJa3VpMFlSZzZFMVBZZzBabEdVUTluUlJPN3U5?=
 =?utf-8?B?UzlMMDNEaHEycEpGRzFLWWZqcFlRUXJ5OHRybjBDamhobnZkMXovOWFueTdx?=
 =?utf-8?B?ekJHVEhJcE9hdWthaXAvYTdBYVd5aHdFWVFxckxpdUQ4ZDRLTG9WRlpodWow?=
 =?utf-8?B?UXVkYlYxam9lWE5NU2xQUHpNNTdaVUFqWGpKR2FJQTNiUWlteXBVRE5Peis2?=
 =?utf-8?B?QjNTcHpBK0JacHZDV2tEYUxRcFYwaXVpZ041a2pRUVBwZG9CRnUrYmhXZ1Vi?=
 =?utf-8?B?eS9US1JGc1NsZTB6bGpFdnl5RkJ5TDBYZ0hBOWNQb3NFWEpVUGMwUzIxbHBO?=
 =?utf-8?Q?B9CpXbPlsNuCE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(36860700004)(1800799015)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:00:29.4661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe74ee6e-2bda-4e0a-b838-08dc622cee54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6353

On Fri, Apr 19, 2024 at 06:12:11PM +0200, Paolo Bonzini wrote:
> On Fri, Apr 19, 2024 at 1:56 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > +       ret = kvm_gmem_populate(kvm, params.gfn_start, u64_to_user_ptr(params.uaddr),
> > > +                               npages, sev_gmem_post_populate, &sev_populate_args);
> > > +       if (ret < 0) {
> > > +               argp->error = sev_populate_args.fw_error;
> > > +               pr_debug("%s: kvm_gmem_populate failed, ret %d (fw_error %d)\n",
> > > +                        __func__, ret, argp->error);
> > > +       } else if (ret < npages) {
> > > +               params.len = ret * PAGE_SIZE;
> > > +               ret = -EINTR;
> >
> > This probably should 1) update also gfn_start and uaddr 2) return 0
> > for consistency with the planned KVM_PRE_FAULT_MEMORY ioctl (aka
> > KVM_MAP_MEMORY).
> 
> To be more precise, params.len should be set to the number of bytes *left*, i.e.
> 
>    params.len -= ret * PAGE_SIZE;
>    params.gfn_start += ret * PAGE_SIZE;
>    if (params.type != KVM_SEV_SNP_PAGE_TYPE_ZERO)
>        params.uaddr += ret * PAGE_SIZE;
> 
> Also this patch needs some other changes:
> 
> 1) snp_launch_update() should have something like this:
> 
>    src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL :
> u64_to_user_ptr(params.uaddr),;
> 
> so that then...
> 
> > +               vaddr = kmap_local_pfn(pfn + i);
> > +               ret = copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE);
> > +               if (ret) {
> > +                       pr_debug("Failed to copy source page into GFN 0x%llx\n", gfn);
> > +                       goto out_unmap;
> > +               }
> 
> ... the copy can be done only if src is non-NULL
> 
> 2) the struct should have some more fields
> 
> > +        struct kvm_sev_snp_launch_update {
> > +                __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
> > +                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
> > +                __u32 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
> > +                __u8 type;              /* The type of the guest pages being initialized. */
> 
> __u8 pad0;
> __u16 flags;   // must be zero
> __u64 pad1[5];
> 
> with accompanying flags check in snp_launch_update().

Have these all addressed in v14, but I ended up making 'len' a __u64, so the
final struct looks like this:

  struct kvm_sev_snp_launch_update {
          __u64 gfn_start;
          __u64 uaddr;
          __u64 len;
          __u8 type;
          __u8 pad0;
          __u16 flags;
          __u32 pad1;
          __u64 pad2[4];
  };

> 
> If you think IMI can be implemented already (with a bit in flags) go
> ahead and do it.

Migration will also need related flags in LAUNCH_START, and depending on how
we implement things, possibly in LAUNCH_FINISH. So for now I've left IMI
out, but added similar 'flags' and padding to those structs as well so we have
some flexibility with how we end up handling that.

-Mike

> 
> Paolo
> 

