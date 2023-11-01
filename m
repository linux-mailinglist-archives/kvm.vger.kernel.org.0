Return-Path: <kvm+bounces-291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 63AF67DDE88
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 10:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8728E1C20D47
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 09:36:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF74179D3;
	Wed,  1 Nov 2023 09:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Av7Zh1qE"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C726A6FDB
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 09:36:37 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E424C12B
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 02:36:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698831392; x=1730367392;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=8wBp8KwYqD4VhEOOpG93z5CCkRYP3TVI4ycBwbkOv8E=;
  b=Av7Zh1qEQrbFofD2ZD7FO0ON7vkvKJIK00zyJUHq4yqgsDM3LX7S3/yJ
   nPmmmGq9vwXYjamlkrm/lBZFneZmdAPawv2cxLqZHzCLWidSpJA6CrU2n
   oc08emOGLQI15IFtX9qUYc4sbfWEa4tm70eSax1MGsXkQJs9OiVnME0gt
   T3uYPVTYqgIfVqWZY55Jw/qnlpZzf0K6Pn9iGjLDrQow6fxKpJuOGAa2d
   6v8cTeE5Pf//vkVB8ISLEm9SgNDMv7HI28qMBoxeaskbmPCnIjBlYNJ4S
   iX5aaRVLNLkjV4xPtBG/fTdPuprN4aKCOFifqLrKnWS4ptGur12c9e+Ki
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="392326194"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="392326194"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2023 02:36:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="795854263"
X-IronPort-AV: E=Sophos;i="6.03,267,1694761200"; 
   d="scan'208";a="795854263"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Nov 2023 02:36:32 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Wed, 1 Nov 2023 02:36:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Wed, 1 Nov 2023 02:36:32 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Wed, 1 Nov 2023 02:36:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mZuHuhuUxichZpF8I+vi3U+YkMPTPCsGpp9vV1xblo9QkpIywKOOYFIJ/wWPh0Z/iRwEa8qPd7RsQIrnQrhHjV1/SNcPIpBAmX1RQVEi57GGzy7s9R4NhIUuXvVbikNK1UJiFfQmaW3IbdmPO3TyrQqnAYHgnXZgvpfSY98cZbYGvctRwDDFxt5GwxDV5CrNn+y36YCdBzPmsGWsflYe04YDVMQeqe0BlLnVAL+8vaPb1vdK5JHCq5OzxWA0uXnZjIKrZnxjiwZOk/yy2jBuW1bgXgx70B5IC8eKhh8fwOfWlrGYAB7RXDqn5SSlzOAnheTOgFdhGfCYwk4SyuJnoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qI0PSAyo3xVV5dba0XdlhYvaCnh6xT8P/WDhU//gUvs=;
 b=YotEb70G61fFrJLD48MrosduZ/rF58Sq8ICTg0im9wq0xxZe+d3eU1eCrvnCODd4rPPC+ZM43ubwWI1G53WBn2itohI5kRPdgAMRFBaWMizVNhYTMyVivlXgJjJPVBsFN5k2aa51VWnm83QRuij3SK4ZULfnrl1FnQF9vDHERYGsM6yo4MgNSXubH2D/tOSHkLWfEYu6d4RTHY8l8B19XHy/8GLDqG6iGbjs3L9wSCAhKGYFhOXag5EGxHY0Y0x8XJr8CwONKwR35tKRprhBeFRktaVQ4YoQwvQC8BJYKM440PwUejGiqCZYpQVHlktFAH4+wceRtJB6EiAJ1KHy/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by CH0PR11MB5379.namprd11.prod.outlook.com (2603:10b6:610:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.19; Wed, 1 Nov
 2023 09:36:29 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::90b6:2600:fc14:c366]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::90b6:2600:fc14:c366%6]) with mapi id 15.20.6933.030; Wed, 1 Nov 2023
 09:36:28 +0000
Date: Wed, 1 Nov 2023 17:08:14 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yibo Huang <ybhuang@cs.utexas.edu>, <kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Message-ID: <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com>
 <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com>
 <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
 <ZUEZ4QRjUcu7y3gN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZUEZ4QRjUcu7y3gN@google.com>
X-ClientProxiedBy: SI1PR02CA0015.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::18) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|CH0PR11MB5379:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eb33c9a-4fb0-40bf-fddc-08dbdabe0641
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xM3dA+eK0lqxkMcdKzdhSHXw96xrMQc0SbrmBPXwclyaxUGXCQGnK6faOcDSr46uzda+XR3cM9aYZDTqD2+E/jlo02RRnuvjDH/vUzPam6AMeM34B14CoEwdDNmhJM6qNE+SWuhOWBvOEPj+ZVGvPEIOEshqtjL9I3pCE2Oq4FkgOFiYGOajVx9yH2+xzuEUH0iqfajPXB8//+vwr2HcslwNJThslvDZuTp+hRs3xOx41pTmIEl43Yr4PXkhKx+U8pAYe0RGECOYub6yYDfawgAV219pZiPV1s+QHC7+rR8G6bKnGW8vso22hEU7R5kA/ZlZwGko7oX3vuoY/lnQIAjMZ6vn13xxzcHb8Y1zhzSXCda5bVJsNXmVjiwwotaW/wQdJGhC5IsPnL8pKRjwRCMBJYxOuvgPZIe/OizwE0AOL2+u3TaokVJ6YeLMCmZq+RkQvXyszTOrECMsAhvVEnA7b4sAVIZo6mAiZtYsw1UrdgPP0oWTEMec2D6kboinFEjQaTUqiw7TrEzExvolX8Fifa7TIpNaKxo7px9sjzKCtwuMkCkGFWODdHxSqC38aFUmi+l/ABkgSIUZBReNu0PI/3P9DJUUnbbAqyNcfJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(39860400002)(136003)(376002)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(26005)(6512007)(38100700002)(86362001)(82960400001)(3450700001)(2906002)(83380400001)(5660300002)(6506007)(478600001)(6666004)(4326008)(8676002)(8936002)(6916009)(6486002)(66476007)(66556008)(66946007)(316002)(41300700001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dTW0BDk6kVk+0twIR1CKB6b0mLlemKiITmvWkoU8CVpaO5vcB7/y/Nho2k8e?=
 =?us-ascii?Q?Tp2zA0UQL0RDdR8ucXkjvDGz3rBQUcQVA4klGaVSwZWFFM/XzhPT5Oh6ZwCU?=
 =?us-ascii?Q?rGnxqXM1+l2cfZsEwBrqtHh5daY4pVqUBcLQwvWm9b9l6lw58p9CSuT2bu+s?=
 =?us-ascii?Q?htKAOKhV/vFiXq/ZG/BiSJqxrnuwKwpjD4kMARAL2Xuj2zLBf+viAS9DnjYR?=
 =?us-ascii?Q?iebpOFmPACb44Mp4QqyRhsTAjOYePfOZf5OA35jnG6yepCYY5ud6TA9gjBFD?=
 =?us-ascii?Q?QMZf3eCq5P3q4jPBEMT187tlalMyRe3q29s8hnYWbhcy0gcq4w+sMrDWxkXm?=
 =?us-ascii?Q?M4ER3zvFb3/tSLgJlsFAaxNqjHrm2cGolJGSypY8xHJAjZLbqkc+3tdd1u/e?=
 =?us-ascii?Q?WqghNxCmbsU/PkLimyxIZJuAtM33McyGBXTDMU3WSCuPCCrZ/hJY5ib5kHWp?=
 =?us-ascii?Q?1QoSNNZ5Fd1WmoBF/FBprKewA0tUHlV2vpBtk0l+rLWH8WjW9Tw8oF+Ep53d?=
 =?us-ascii?Q?mBpTV4Q6a8Qst/Khc9FBJgj1lnOIcc5APu8IiedKrKlACPWv7skbG8QQXts8?=
 =?us-ascii?Q?4htUlHgl7xqta8f7gT1+ZIpR5TDejvEb95kxRDjJ3Pzj9V8JHfUoUEE8h271?=
 =?us-ascii?Q?Qwb6rkXpgrnVsBmd28ltFlh5RqhCuBx7iIlXE2Ve3L8WMquq3c1eEtLev3O0?=
 =?us-ascii?Q?swZOKi+YIGPwDQ+4VAZZmzbBH1opL3slK2xxkWjeRTrzDinr+rk/VMt51gko?=
 =?us-ascii?Q?LmzTtgk0hM8gzqI/HYgygT8NpB5XNYA7pEsvUsS+QW5SiNkNt5hFXhZN0YVU?=
 =?us-ascii?Q?hHvkyc4HKLnRhjj9BKGxiCGyBJ5rt9jf/oKZOVmgqs4FEk4n7UZTKBBAfNV1?=
 =?us-ascii?Q?u92d8bA/uqB6UkBoLNz/yNEC5n9w08KZ8RYE8+NWcRpWIyXo7cv4P8cQVYAr?=
 =?us-ascii?Q?AIVVypbz+eMasiD36CikMaLkZz5GYxOi6MOkyTtLSgEywiiKs0KU5bldujWB?=
 =?us-ascii?Q?WnHOJ6Xo+Dpfla2NbcpSKddGKaieaNiTJxvnoblbvCpOn+gbN6HtXb3Bgz6k?=
 =?us-ascii?Q?ejZgvXqny2z8FuPZ5UeN8XdD029zxxd7N2g0HazdSt5FBK2HjDuGuO2bRz3v?=
 =?us-ascii?Q?yLpD5Pf83LtDeKu3Vly9pN93kuHoLfFz3G/Ra73GXoySaqPieJUkwGZQAmXa?=
 =?us-ascii?Q?qOv5XKrg/ngfvITrvwQt6aXhXnwpficL3ZvwYa7dZv5Bx55Qnu2e7gmmadzX?=
 =?us-ascii?Q?Imi1mdx6N/EwS92eSxszPlzo+L6lRIy9WkVdz4g8uEyAgPR4cLXoSIeH1w7c?=
 =?us-ascii?Q?XkUh3OCyRRNv4emkvUGRCxv2WUAgThYa33PucLx5TpJDJlT6co2XMN5E8YCz?=
 =?us-ascii?Q?Q2SpeOm3ULt2zsl0PCmeEFMaliukL+el5V8etzQj3NN0NZh4caL9gAphPUxY?=
 =?us-ascii?Q?3SvH67NWv6XqqmQrTutbkZcb89ao2N4qAgVbTNcLW0rgKY/POG6V6k9KeGqh?=
 =?us-ascii?Q?0xVyO4Iq54SMVhMWDGyAT6FmIAf3khAnco8v0fnT9PtSb0DJ9Ls24Cl540lW?=
 =?us-ascii?Q?cuFcSeFW3NDJSbKbD9zHkrLZaYwiLG4IbiZaVFqn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eb33c9a-4fb0-40bf-fddc-08dbdabe0641
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2023 09:36:28.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJOd2qNfpuFMMhPF3gsUi2WuzK25oKumIMu1r1DLP9VqoWsQtR5kOUqZ3zRFQaW/Q2YW7dWAmGZUxr8vgWpvfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5379
X-OriginatorOrg: intel.com

On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:
> On Tue, Oct 31, 2023, Yan Zhao wrote:
> > On Mon, Oct 30, 2023 at 12:24:02PM -0700, Sean Christopherson wrote:
> > > On Mon, Oct 30, 2023, Yan Zhao wrote:
> > > Digging deeper through the history, this *mostly* appears to be the result of coming
> > > to the complete wrong conclusion for handling memtypes during EPT and VT-d enabling.
> 
> ...
> 
> > > Note the CommitDates!  The AuthorDates strongly suggests Sheng Yang added the whole
> > > IGMT things as a bug fix for issues that were detected during EPT + VT-d + passthrough
> > > enabling, but Avi applied it earlier because it was a generic fix.
> > >
> > My feeling is that
> > Current memtype handling for non-coherent DMA is a compromise between
> > (a) security ("qemu mappings will use writeback and guest mapping will use guest
> > specified memory types")
> > (b) the effective memtype cannot be cacheable if guest thinks it's non-cacheable.
> 
> And correctness.  E.g. accessing memory with conficting memtypes could cause guest
> data corruption, which isn't strictly the same as (a).
> 
> > So, for MMIOs in non-coherent DMAs, mapping them as UC in EPT is understandable,
> > because other value like WB or WC is not preferred --
> > guest usually sets MMIOs' PAT to UC or WC, so "PAT=UC && EPT=WB" or
> > "PAT=UC && EPT=WC" are not preferred according to SDM due to page aliasing.
> > And VFIO maps the MMIOs to UC in host.
> > (With pass-through GPU in my env, the MMIOs' guest MTRR is UC,
> >  I can observe host hang if I program its EPT type to
> >  - WB+IPAT or
> >  - WC
> >  )
> 
> Yes, but all of that simply confirms that it's KVM's responsibility to map host
> MMIO as UC.  The hangs you observe likely have nothing to do with memory aliasing,
> and everything to do with accessing real MMIO with incompatible memtypes.
Yes, you are right.
For EPT type = WC, the hang case is actually because pci_iomap() maps PAT
as UC- by default, then the effective memory type is WC, which is wrong.
If I force the driver to map with PAT=UC, then the driver works normal even
with EPT type = WC.

> 
> > For guest RAM, looks honoring guest MTRRs just mitigates the page aliasing
> > problem.
> > E.g. if guest PAT=UC because its MTRR=UC, setting EPT type=UC can avoid
> > "guest PAT=UC && EPT=WB", which is not recommended in SDM.
> > But it still breaks (a) if guest PAT is UC.
> > Also, honoring guest MTRRs in EPT is friendly to old systems that do not enable
> > PAT. I guess :)
> 
> LOL, no way.  The PAT can't be disabled, and the default PAT combinations are
> backwards compatible with legacy PCD+PWT.  The only way for this to provide value
> is if someone is virtualizing a pre-Pentium Pro CPU, doing device passthrough,
> and *only* doing so on hardware with EPT.
> 
> > But I agree, in common cases, honoring guest MTRRs or not looks no big difference.
> > (And I'm not lucky enough to reproduce page-aliasing-caused MCE yet in my
> > environment).
> 
> FWIW, I don't think that page aliasing with WC/UC actually causes machine checks.
> What does result in #MC (assuming things haven't changed in the last few years)
> is accessing MMIO using WB and other cacheable memtypes, e.g. map the host APIC
> with WB and you should see #MCs.  I suspect this is what people encountered years
> ago when KVM attempted to honored guest MTRRs at all times.  E.g. the "full" MTRR
> virtualization patch that got reverted deliberately allowed the guest to control
> the memtype for host MMIO.
> 
> The SDM makes aliasing sound super scary, but then has footnotes where it explicitly
> requires the CPU to play nice with aliasing, e.g. if MTRRs are *not* UC but the
> effective memtype is UC, then the CPU is *required* to snoop caches:
>
Yes, I tried below combinations, none of them can trigger #MC.
- effective memory type for guest access is WC, and that for host access is UC
- effective memory type for guest access is UC, and that for host access is WC
- effective memory type for guest access is UC, and that for host access is WB


>   2. The UC attribute came from the page-table or page-directory entry and
>      processors are required to check their caches because the data may be cached
>      due to page aliasing, which is not recommended.
> 
> Lack of snooping can effectively cause data corruption and ordering issues, but
> at least for WC/UC vs. WB I don't think there are actual #MC problems with aliasing.
> 
Even no #MC on guest RAM?
E.g. what if guest effective memory type is UC/WC, and host effective memory type
is WB?
(I tried in my machines with guest PAT=WC + host PAT=WB, looks no #MC, but I'm not sure
if anything I'm missing and it's only in my specific environment.)

If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
without non-coherent DMA?

> > For CR0_CD=1,
> > - w/o KVM_X86_QUIRK_CD_NW_CLEARED, it meets (b), but breaks (a).
> > - w/  KVM_X86_QUIRK_CD_NW_CLEARED, with IPAT=1, it meets (a), but breaks (b);
> >                                    with IPAT=0, it may breaks (a), but meets (b)
> 
> CR0.CD=1 is a mess above and beyond memtypes.  Huh.  It's even worse than I thought,
> because according to the SDM, Atom CPUs don't support no-fill mode:
> 
>   3. Not supported In Intel Atom processors. If CD = 1 in an Intel Atom processor,
>      caching is disabled.
> 
> Before I read that blurb about Atom CPUs, what I was going to say is that, AFAIK,
> it's *impossible* to accurately virtualize CR0.CD=1 on VMX because there's no way
> to emulate no-fill mode.
> 
> > > Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
> > > Yang was trying to resolve issues with passthrough MMIO.
> > > 
> > >  * Sheng Yang 
> > >   : Do you mean host(qemu) would access this memory and if we set it to guest 
> > >   : MTRR, host access would be broken? We would cover this in our shadow MTRR 
> > >   : patch, for we encountered this in video ram when doing some experiment with 
> > >   : VGA assignment. 
> > > 
> > > And in the same thread, there's also what appears to be confirmation of Intel
> > > running into issues with Windows XP related to a guest device driver mapping
> > > DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
> > > SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
> > > the fact that EPT and NPT both honor guest PAT by default.  /facepalm
> > 
> > My interpretation is that the since guest PATs are in guest page tables,
> > while with EPT/NPT, guest page tables are not shadowed, it's not easy to
> > check guest PATs  to disallow host QEMU access to non-WB guest RAM.
> 
> Ah, yeah, your interpretation makes sense.
> 
> The best idea I can think of to support things like this is to have KVM grab the
> effective PAT memtype from the host userspace page tables, shove that into the
> EPT/NPT memtype, and then ignore guest PAT.  I don't if that would actually work
> though.
Hmm, it might not work. E.g. in GPU, some MMIOs are mapped as UC-, while some
others as WC, even they belong to the same BAR.
I don't think host can know which one to choose in advance.
I think it should be also true to RAM range, guest can do memremap to a memory
type that host doesn't know beforehand.

> 
> > The credence is with Avi's following word:
> > "Looks like a conflict between the requirements of a hypervisor 
> > supporting device assignment, and the memory type constraints of mapping 
> > everything with the same memory type.  As far as I can see, the only 
> > solution is not to map guest memory in the hypervisor, and do all 
> > accesses via dma.  This is easy for virtual disk, somewhat harder for 
> > virtual networking (need a dma engine or a multiqueue device).
> > 
> > Since qemu will only access memory on demand, we don't actually have to 
> > unmap guest memory, only to ensure that qemu doesn't touch it.  Things 
> > like live migration and page sharing won't work, but they aren't 
> > expected to with device assignment anyway."

