Return-Path: <kvm+bounces-182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 080847DCACC
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 11:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF6962817D3
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 10:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE277199AF;
	Tue, 31 Oct 2023 10:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xmivka4f"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A261111B4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 10:29:30 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63289A1
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 03:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698748168; x=1730284168;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=bbGtxqX2Q/i2MOytNP2nmiCr09ojg+U75vfd9cCCizI=;
  b=Xmivka4fOloqdAUFEtkp/oZe0KqJuJyYq/XWMq6YkkzwcnSAndnqrDKK
   Q4dac+LVgxdD4aui/Dop28k20ek0Lni5nXW5jz+GODMH9ka4v76GDNiY0
   Re1UMLwKxlG1bw6mKEdjQOEq6AK+/IdDTxSDZOm/Gh5enwHzue09VU8TP
   nd91takKzX3etjCQIfYE4oZn//vc8+dvppa3kfe1VEg4/hnI5T6obQK7f
   276kgAm/H1W10OIgSYm7KSeWmEgeZ9cL23xGF5hLuUUxTvbfOX2colWgG
   7dHA3I5U3bAI47pi+ZbXDE7g5Iw2N0NOsvrrbxaNZlnM+JTM9uLcpikJI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="454726680"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="454726680"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 03:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10879"; a="789749184"
X-IronPort-AV: E=Sophos;i="6.03,265,1694761200"; 
   d="scan'208";a="789749184"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 31 Oct 2023 03:29:27 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 31 Oct 2023 03:29:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 31 Oct 2023 03:29:27 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 31 Oct 2023 03:29:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuUNlKmW12+CvmL83v4hNgRlpvuTSkpis08FhL7Q0ecPcAevdungniUHMZVnpvQyCPngU0rESI0G/mnMXtciQVnJcBvp0DScMdB2L7wSJ+I9EquIA3XcPPx/l1zu0O6US6L2GIi8IofBr42gIjROg8tYGcfWuTEZ0uwdmiUQozKbl8hzwAit8fYa4SYN09aL2Z80mWSBoReUHHMZ+hOAN7i4Ob6jxB9m+QLrkXjy5/yWBqwQYyQx4TaROVlvzJCR+sUO3QY5B+Hao9CAJosTFCzMWYzWIFVDiLHbIgkDyoCRb6wUe5BfQ0sX714X5w/zJ2E2QlQLJ/0Jk1XTFx/fGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ercTZ+CT8DQfMx1kurqTgXkVyN7U/oUiRstLgB71rPI=;
 b=R3dAbg0Evj5TgVBiX3v2ylyEYXPjVCeH0SMjFX/IkR/crkp7BrLmJ0RHNw2NX9JYRTcOnw+9ZPOq98z7KruQ+NLV/uf3JMkaqdZvKxVvIJLviu8i6gCkUo4RowLDhzab8KYB48ssxC18wFcBGa7s9RBoDMuBxGweasQjZeReRjwhHcURl9xh5q2XDQgKEU81Lp7acG342mYTSr2WrY7z3rCRftcg9pWszr7++YMzns5DU0/H7Cn5dBRqJP8oGIU/Lqc2jXlPlpVeN1YQnaQSF1GZnRHWbquagMQLEQjzbsEjLpZI63fwx++V9SaEqY19pfxg2qKboDHGT9eYnG5mFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB7302.namprd11.prod.outlook.com (2603:10b6:8:109::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.29; Tue, 31 Oct 2023 10:29:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::3228:6596:fe02:211b]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::3228:6596:fe02:211b%6]) with mapi id 15.20.6933.028; Tue, 31 Oct 2023
 10:29:18 +0000
Date: Tue, 31 Oct 2023 18:01:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yibo Huang <ybhuang@cs.utexas.edu>, <kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Message-ID: <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com>
 <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZUAC0jvFE0auohL4@google.com>
X-ClientProxiedBy: KL1PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB7302:EE_
X-MS-Office365-Filtering-Correlation-Id: 33c0927e-9dd0-4c7b-71c5-08dbd9fc3cfd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYcKoy9r/YzPNnkKsOW3Q7px7BEjgiVOd1YwytLEesy3/cDc2n1c2San4NWpjnfO5UgCfZTmlbasLAAL7MDOq2p1HGf8x3IFg2zPpn7SAxP6CjRV5dD0RCA+JuvWpCgwbiOPSJEP0ciq1NPHKOfFNP26jHhAqvjuYQwYG8AbUpy0xCBDKTzHgwDeB1RKAY2qbUPJ733aU8ztAll2gWg5S/CRlKd4WjlE7THyWFdRqG0Z86nrZJNhR3SouClAgtdxx4x9iMkq5z7D+URZK5dhYx/1nOj7WKokDyixPHhl0QdJWJcIVuYse+bcomMw0VXsSoNiTTektWaQkhnbBxQG+VIsyoajr6ULzeQKMIruF7GWcbIFuAbTIPlRNFL1p+2QhZD3KEGCKqj+btxcvIfpKDzjYrjFxbZaFNKe5usxlkF5t+q9LV9kjhgT15mXpR5LEKEnt91wIoH0pW4/J9GjcxOJcLcBRCFU7LxfzPqJqqhFYFqvKjLu1TIqx9xBCZWjhnYJw2OJVruHdT8/uT5FH+M1otkuwp+Rt8qHLxay8Uk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(366004)(39860400002)(396003)(136003)(230922051799003)(451199024)(1800799009)(186009)(64100799003)(41300700001)(6486002)(966005)(478600001)(3450700001)(6506007)(6666004)(4326008)(8676002)(83380400001)(8936002)(30864003)(2906002)(5660300002)(66946007)(66556008)(66476007)(6916009)(26005)(316002)(86362001)(38100700002)(6512007)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3SeODCGJ2FWsFCcynHHaqePjOsUfWOu9PHDfEktkOl333+DMy0UeBd4xxfAo?=
 =?us-ascii?Q?DJS6u/K3oFCMUYIfTbIyJNQTZ5N/+QeaW5w5zF2wcEfmvoQAOAZCsCpzc+0R?=
 =?us-ascii?Q?O/h3pvYGAq9jW9FRT8TO4a2Z5ebjpd3uHXKVLc4229PwIa8vkWWpmZa9fmXp?=
 =?us-ascii?Q?Fs81mmlYymfPgeCNHcdG7Rf0cKW+7FM7K67kewMEtltbspxAv3IREg8ogCZ4?=
 =?us-ascii?Q?hmwNjm53AW8/38SiByzJNacc2AeFNxpmnyXWfncJ2khCcWq8ERJgzvRJTmw0?=
 =?us-ascii?Q?VTUa4y8/kDXGg4PqmrYSS6gvmCXUAoasAzQCIjIQv7paer56RXbnnTTWj/xY?=
 =?us-ascii?Q?xs3+SnG2KxQoOxeQs+4xEvUg5eQxN0rZGTeFZzEB5No6FPbTRtqdYMlwmVGg?=
 =?us-ascii?Q?56fZECpQjRF50KXHqo8Zskji0ZS3eNsUjFvZlmaj7FbaOg2hGVLvOVN7A0u1?=
 =?us-ascii?Q?6T2KkrpzKlWaICEJx3SPaulf2VS9xATi6MGDCcGIcw3lUTVoKEiFn/Z2xyzJ?=
 =?us-ascii?Q?N+tmkcWHPQfpr06+QtkQyUhU7PJeFPUhfLK5jGrXt2X8EqtIqm8/CCV9Ed+o?=
 =?us-ascii?Q?hfM8xRXTM6u8WrG5ctc+xZGpf0g18/TsjLZwB0AnelvQ/uVYtLmUV271300K?=
 =?us-ascii?Q?qAS/YMwvSfAaEA7SN1XJ6xaOXa4RgS60Vb8rW/7csSXgNEGxqjv/cGry2iFj?=
 =?us-ascii?Q?zF4bsbRKZhGXdS2vgcmNmbhvlpK360W+lEXoogyeG1SWZqmP6o69yDPaL50b?=
 =?us-ascii?Q?sGUBdOqdDaJ+763lwiISRUJ21vK9uom9i9ZHpYX/uHhbMcna773AMPm4TLGp?=
 =?us-ascii?Q?2UardJrD6+ytiOOY5cVRiZvGpODuEcDgLujjxwkVnQ3SVEPeKXb/aB1Jmz+L?=
 =?us-ascii?Q?w0tFq2GH3QMtuvnckYGZ8rwTLkZGqRxUQYiARnDI7uWNA511BpWZaBUP0O9z?=
 =?us-ascii?Q?ShVXfnWKvPJ8oKrupVxkDnzljJvSfuPTAEOKoLPouc8XmHLfPOGvlUOaO+IZ?=
 =?us-ascii?Q?2bRpwgetKXXd643n8CVslliUN8BzE7Ooki6jHhqKjTQ1oN9k6/Khg5WYnL/T?=
 =?us-ascii?Q?qUVTzlHvb/aMIwblvrmbZFWVV0/G24xMD7XpRwn7eH5zupIdEK0ueEUuLU/t?=
 =?us-ascii?Q?jMh3/uzOavQlRIukNcwtIwy1A6Uamd9Qu1WrJ8p+Vi/5HGqUEYwB9BN4+zmW?=
 =?us-ascii?Q?oJCECz6kaYyCfGw2MHaN9DSmogQ71D2n0csP1hJzkmvxRkXJy2Wmcq2NKxSy?=
 =?us-ascii?Q?IWLb1uiRM2SX1CWOafR3Nitv+1OkLThY7jTGaCN+UdkPc6AiEHwjx+URq1vu?=
 =?us-ascii?Q?qY2DAXwURbrplg4JBz4LLykKZO98P0ZIt9tcMtgdnRGCHy+Caf1tw5ocI4Rl?=
 =?us-ascii?Q?JxtTLJxTW9wBgvFcOxXmgE75FlbVkb7ZtnonvfxN9AgyTaN31jH4Rlr5/u7Z?=
 =?us-ascii?Q?Q1j/mwmVEisYdcLJZO202blGYQVWUWszsjJ6PBViUN67icr6SPMrydPQKX1r?=
 =?us-ascii?Q?hjQGiMoQ9zbrV5l4iAuCTkTL0F/1RUKv4n/xRRdW2COhnH+2MIWIqKB8nPRZ?=
 =?us-ascii?Q?civb2C/ugXGBqUbsHbQmD9KUSzU1lvLjrbQ3+ipO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33c0927e-9dd0-4c7b-71c5-08dbd9fc3cfd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2023 10:29:18.5087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aVTpNvxo527CerDV29pTMiWouRY1IjhS0vjdW2vU1j1OKciMFDkMKVjw+Neu7ii/l+ERxcJw1En5vrcqJjwNYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7302
X-OriginatorOrg: intel.com

On Mon, Oct 30, 2023 at 12:24:02PM -0700, Sean Christopherson wrote:
> On Mon, Oct 30, 2023, Yan Zhao wrote:
> > On Fri, Oct 27, 2023 at 04:13:36PM -0700, Sean Christopherson wrote:
> > > E.g. I have a very hard time believing a real world guest kernel mucks with the
> > > MTRRs to setup DMA.  And again, this is supported by the absense of bug reports
> > > on AMD.
> > > 
> > > 
> > > Yan,
> > > 
> > > You've been digging into this code recently, am I forgetting something because
> > > it's late on a Friday?  Or have we been making the very bad assumption that KVM
> > > code from 10+ years ago actually makes sense?  I.e. for non-coherent DMA, can we
> > > delete all of the MTRR insanity and simply clear IPAT?
> > Not sure if there are guest drivers can program PAT as WB but treat memory type
> > as UC.
> > In theory, honoring guest MTRRs is the most safe way.
> > Do you think a complete analyse of all corner cases are deserved?
> 
> I 100% agree that honoring guest MTRRs is the safest, but KVM's current approach
> make no sense, at all.  From a hardware virtualization perspective of guest MTRRs,
> there is _nothing_ special about EPT.  Legacy shadowing paging doesn't magically
> account for guest MTRRs, nor does NPT.
> 
> The only wrinkle is that NPT honors gCR0, i.e. actually puts the CPU caches into
> no-fill mode, whereas VMX does nothing and forces KVM to (poorly) emulate that
> behavior by forcing UC.
> 
> TL;DR of the below: Rather than try to make MTRR virtualization suck less for EPT,
> I think we should delete that code entirely and take a KVM errata to formally
> document that KVM doesn't virtualize guest MTRRs.  In addition to solving the
> performance issues with zapping SPTEs for MTRR changes, that'll eliminate 600+
> lines of complex code (the overlay shenanigans used for fixed MTRRs are downright
> mean).
> 
>  arch/x86/include/asm/kvm_host.h |  15 +---
>  arch/x86/kvm/mmu/mmu.c          |  16 ----
>  arch/x86/kvm/mtrr.c             | 644 ++++++-------------------------------------------------------------------------------------------------------------------------------
>  arch/x86/kvm/vmx/vmx.c          |  12 +--
>  arch/x86/kvm/x86.c              |   1 -
>  arch/x86/kvm/x86.h              |   4 -
>  6 files changed, 36 insertions(+), 656 deletions(-)
> 
> Digging deeper through the history, this *mostly* appears to be the result of coming
> to the complete wrong conclusion for handling memtypes during EPT and VT-d enabling.
> 
> The zapping GFNs logic came from
> 
>   commit efdfe536d8c643391e19d5726b072f82964bfbdb
>   Author: Xiao Guangrong <guangrong.xiao@linux.intel.com>
>   Date:   Wed May 13 14:42:27 2015 +0800
> 
>     KVM: MMU: fix MTRR update
>     
>     Currently, whenever guest MTRR registers are changed
>     kvm_mmu_reset_context is called to switch to the new root shadow page
>     table, however, it's useless since:
>     1) the cache type is not cached into shadow page's attribute so that
>        the original root shadow page will be reused
>     
>     2) the cache type is set on the last spte, that means we should sync
>        the last sptes when MTRR is changed
>     
>     This patch fixs this issue by drop all the spte in the gfn range which
>     is being updated by MTRR
> 
> which was a fix for 
> 
>   commit 0bed3b568b68e5835ef5da888a372b9beabf7544
>   Author:     Sheng Yang <sheng@linux.intel.com>
>   AuthorDate: Thu Oct 9 16:01:54 2008 +0800
>   Commit:     Avi Kivity <avi@redhat.com>
>   CommitDate: Wed Dec 31 16:51:44 2008 +0200
>   
>       KVM: Improve MTRR structure
>       
>       As well as reset mmu context when set MTRR.
> 
> (side topic, if anyone wonders why I am so particular about changelogs, the above
> is exactly 
> 
> Anyways, the above was part of a "MTRR/PAT support for EPT" series that also added
> 
> +	if (mt_mask) {
> +		mt_mask = get_memory_type(vcpu, gfn) <<
> +			  kvm_x86_ops->get_mt_mask_shift();
> +		spte |= mt_mask;
> +	}
> 
> where get_memory_type() was a truly gnarly helper to retrive the guest MTRR memtype
> for a given memtype.  And *very* subtly, at the time of that change, KVM *always*
> set VMX_EPT_IGMT_BIT,
> 
>         kvm_mmu_set_base_ptes(VMX_EPT_READABLE_MASK |
>                 VMX_EPT_WRITABLE_MASK |
>                 VMX_EPT_DEFAULT_MT << VMX_EPT_MT_EPTE_SHIFT |
>                 VMX_EPT_IGMT_BIT);
> 
> which came in via
> 
>   commit 928d4bf747e9c290b690ff515d8f81e8ee226d97
>   Author:     Sheng Yang <sheng@linux.intel.com>
>   AuthorDate: Thu Nov 6 14:55:45 2008 +0800
>   Commit:     Avi Kivity <avi@redhat.com>
>   CommitDate: Tue Nov 11 21:00:37 2008 +0200
>   
>       KVM: VMX: Set IGMT bit in EPT entry
>       
>       There is a potential issue that, when guest using pagetable without vmexit when
>       EPT enabled, guest would use PAT/PCD/PWT bits to index PAT msr for it's memory,
>       which would be inconsistent with host side and would cause host MCE due to
>       inconsistent cache attribute.
>       
>       The patch set IGMT bit in EPT entry to ignore guest PAT and use WB as default
>       memory type to protect host (notice that all memory mapped by KVM should be WB).
> 
> Note the CommitDates!  The AuthorDates strongly suggests Sheng Yang added the whole
> IGMT things as a bug fix for issues that were detected during EPT + VT-d + passthrough
> enabling, but Avi applied it earlier because it was a generic fix.
>
My feeling is that
Current memtype handling for non-coherent DMA is a compromise between
(a) security ("qemu mappings will use writeback and guest mapping will use guest
specified memory types")
(b) the effective memtype cannot be cacheable if guest thinks it's non-cacheable.

So, for MMIOs in non-coherent DMAs, mapping them as UC in EPT is understandable,
because other value like WB or WC is not preferred --
guest usually sets MMIOs' PAT to UC or WC, so "PAT=UC && EPT=WB" or
"PAT=UC && EPT=WC" are not preferred according to SDM due to page aliasing.
And VFIO maps the MMIOs to UC in host.
(With pass-through GPU in my env, the MMIOs' guest MTRR is UC,
 I can observe host hang if I program its EPT type to
 - WB+IPAT or
 - WC
 )

For guest RAM, looks honoring guest MTRRs just mitigates the page aliasing
problem.
E.g. if guest PAT=UC because its MTRR=UC, setting EPT type=UC can avoid
"guest PAT=UC && EPT=WB", which is not recommended in SDM.
But it still breaks (a) if guest PAT is UC.
Also, honoring guest MTRRs in EPT is friendly to old systems that do not enable
PAT. I guess :)
But I agree, in common cases, honoring guest MTRRs or not looks no big difference.
(And I'm not lucky enough to reproduce page-aliasing-caused MCE yet in my
environment).

For CR0_CD=1,
- w/o KVM_X86_QUIRK_CD_NW_CLEARED, it meets (b), but breaks (a).
- w/  KVM_X86_QUIRK_CD_NW_CLEARED, with IPAT=1, it meets (a), but breaks (b);
                                   with IPAT=0, it may breaks (a), but meets (b)


> Jumping back to 0bed3b568b68 ("KVM: Improve MTRR structure"), the other relevant
> code, or rather lack thereof, is the handling of *host* MMIO.  That fix came in a
> bit later, but given the author and timing, I think it's safe to say it was all
> part of the same EPT+VT-d enabling mess.
> 
>   commit 2aaf69dcee864f4fb6402638dd2f263324ac839f
>   Author:     Sheng Yang <sheng@linux.intel.com>
>   AuthorDate: Wed Jan 21 16:52:16 2009 +0800
>   Commit:     Avi Kivity <avi@redhat.com>
>   CommitDate: Sun Feb 15 02:47:37 2009 +0200
> 
>     KVM: MMU: Map device MMIO as UC in EPT
>     
>     Software are not allow to access device MMIO using cacheable memory type, the
>     patch limit MMIO region with UC and WC(guest can select WC using PAT and
>     PCD/PWT).
> 
> In addition to the host MMIO and IGMT issues, this code was obviously never tested
> on NPT until much later, which lends further credence to my theory/argument that
> this was all the result of misdiagnosed issues.
> 
> Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
> Yang was trying to resolve issues with passthrough MMIO.
> 
>  * Sheng Yang 
>   : Do you mean host(qemu) would access this memory and if we set it to guest 
>   : MTRR, host access would be broken? We would cover this in our shadow MTRR 
>   : patch, for we encountered this in video ram when doing some experiment with 
>   : VGA assignment. 
> 
> And in the same thread, there's also what appears to be confirmation of Intel
> running into issues with Windows XP related to a guest device driver mapping
> DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
> SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
> the fact that EPT and NPT both honor guest PAT by default.  /facepalm

My interpretation is that the since guest PATs are in guest page tables,
while with EPT/NPT, guest page tables are not shadowed, it's not easy to
check guest PATs  to disallow host QEMU access to non-WB guest RAM.

The credence is with Avi's following word:
"Looks like a conflict between the requirements of a hypervisor 
supporting device assignment, and the memory type constraints of mapping 
everything with the same memory type.  As far as I can see, the only 
solution is not to map guest memory in the hypervisor, and do all 
accesses via dma.  This is easy for virtual disk, somewhat harder for 
virtual networking (need a dma engine or a multiqueue device).

Since qemu will only access memory on demand, we don't actually have to 
unmap guest memory, only to ensure that qemu doesn't touch it.  Things 
like live migration and page sharing won't work, but they aren't 
expected to with device assignment anyway."


>  
>  * Avi Kavity
>   : Sheng Yang wrote:
>   : > Yes... But it's easy to do with assigned devices' mmio, but what if guest 
>   : > specific some non-mmio memory's memory type? E.g. we have met one issue in 
>   : > Xen, that a assigned-device's XP driver specific one memory region as buffer, 
>   : > and modify the memory type then do DMA.
>   : >
>   : > Only map MMIO space can be first step, but I guess we can modify assigned 
>   : > memory region memory type follow guest's? 
>   : >   
>   : 
>   : With ept/npt, we can't, since the memory type is in the guest's 
>   : pagetable entries, and these are not accessible
> 
> [*] https://lore.kernel.org/all/1223539317-32379-1-git-send-email-sheng@linux.intel.com
> 
> So, for the most part, what I think happened is that 15 years ago, a few engineers
> (a) fixed a #MC problem by ignoring guest PAT and (b) initially "fixed" passthrough
> device MMIO by emulating *guest* MTRRs.  Except for the below case, everything since
> then has been a result of those two intertwined changes.
> 
> The one exception, which is actually yet more confirmation of all of the above,
> is the revert of Paolo's attempt at "full" virtualization of guest MTRRs:
> 
>   commit 606decd67049217684e3cb5a54104d51ddd4ef35
>   Author: Paolo Bonzini <pbonzini@redhat.com>
>   Date:   Thu Oct 1 13:12:47 2015 +0200
> 
>     Revert "KVM: x86: apply guest MTRR virtualization on host reserved pages"
>     
>     This reverts commit fd717f11015f673487ffc826e59b2bad69d20fe5.
>     It was reported to cause Machine Check Exceptions (bug 104091).
> 
> ...
> 
>   commit fd717f11015f673487ffc826e59b2bad69d20fe5
>   Author: Paolo Bonzini <pbonzini@redhat.com>
>   Date:   Tue Jul 7 14:38:13 2015 +0200
> 
>     KVM: x86: apply guest MTRR virtualization on host reserved pages
>     
>     Currently guest MTRR is avoided if kvm_is_reserved_pfn returns true.
>     However, the guest could prefer a different page type than UC for
>     such pages. A good example is that pass-throughed VGA frame buffer is
>     not always UC as host expected.
>     
>     This patch enables full use of virtual guest MTRRs.
> 
> I.e. Paolo tried to add back KVM's behavior before "Map device MMIO as UC in EPT"
> and got the same result: machine checks, likely due to the guest MTRRs not being
> trustworthy/sane at all times.
> 
> And FWIW, Paolo also tried to enable MTRR virtualization on NP, but that too got
> reverted.  I read through the threads, and AFAICT no one ever found a smoking gun,
> i.e. exactly why emulating guest MTRRs via NPT PAT caused extremely slow boot times
> doesn't appear to have a definitive root cause.
> 
>   commit fc07e76ac7ffa3afd621a1c3858a503386a14281
>   Author: Paolo Bonzini <pbonzini@redhat.com>
>   Date:   Thu Oct 1 13:20:22 2015 +0200
> 
>     Revert "KVM: SVM: use NPT page attributes"
>     
>     This reverts commit 3c2e7f7de3240216042b61073803b61b9b3cfb22.
>     Initializing the mapping from MTRR to PAT values was reported to
>     fail nondeterministically, and it also caused extremely slow boot
>     (due to caching getting disabled---bug 103321) with assigned devices.
>
> ...
> 
>   commit 3c2e7f7de3240216042b61073803b61b9b3cfb22
>   Author: Paolo Bonzini <pbonzini@redhat.com>
>   Date:   Tue Jul 7 14:32:17 2015 +0200
> 
>     KVM: SVM: use NPT page attributes
>     
>     Right now, NPT page attributes are not used, and the final page
>     attribute depends solely on gPAT (which however is not synced
>     correctly), the guest MTRRs and the guest page attributes.
>     
>     However, we can do better by mimicking what is done for VMX.
>     In the absence of PCI passthrough, the guest PAT can be ignored
>     and the page attributes can be just WB.  If passthrough is being
>     used, instead, keep respecting the guest PAT, and emulate the guest
>     MTRRs through the PAT field of the nested page tables.
>     
>     The only snag is that WP memory cannot be emulated correctly,
>     because Linux's default PAT setting only includes the other types.
> 
> In other words, my reading of the tea leaves is that honoring guest MTRRs for VMX
> was initially a workaround of sorts for KVM ignoring guest PAT *and* for KVM not
> forcing UC for host MMIO.  And while there *are* known cases where honoring guest
> MTRRs is desirable, e.g. passthrough VGA frame buffers, the desired behavior in
> that case is to get WC instead of UC, i.e. at this point it's for performance,
> not correctness.
> 
> Furthermore, the complete absense of MTRR virtualization on NPT and shadow paging
> proves that while KVM theoretically can do better, it's by no means necessary for
> correctnesss.
> 
> Lastly, I would argue that since kernels mostly rely on firmware to do MTRR setup,
> and the host typically provides guest firmware, honoring guest MTRRs is effectively
> honoring *host* userspace memtypes, which is also backwards, i.e. it would be far
> better for host userspace to communicate its desired directly to KVM (or perhaps
> indirectly via VMAs in the host kernel, just not through guest MTRRs).

