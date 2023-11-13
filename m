Return-Path: <kvm+bounces-1584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE687E97D8
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 09:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7661B1C2091C
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 08:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D315D168DF;
	Mon, 13 Nov 2023 08:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AGyIw9Ls"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5AE13FEB
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 08:35:39 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B6210F6
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 00:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699864537; x=1731400537;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=7+6t12jX7RJ6goeLzax09zVOv/sAsDIagn44+rtq5G0=;
  b=AGyIw9Ls51vUhTUBdO1ZuTVUP/kM7x9Vex9erxbDRiTXkzbHxbUd/QKk
   I2m9fG2dN4F+gtbUrDpikyScpQIpnKhIendSHAd2DwkWEDK0SoPTEt9HK
   f/wN7/o5GNS7aNYU9A8wHh+FQE6ZOWh+l0LiVbym0vxf4yi4RqpHrtfG+
   GEvqEHmU6XmALI7QRvRPaAwBnYVYXthMeAwV0ASPoNpnbN+ZPkiR+p6kO
   vwTuOkGDahWS0eO9FZpv1D4YoMasPomIdv54QluFBDeNHGXBR0ewvgd0i
   lFlVROSbMpiRiR9wNfLYNuyIBl90mU5pY8mIPQHNiXn/yIcaQgpagvRuA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10892"; a="394296284"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="394296284"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 00:35:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10892"; a="764274772"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="764274772"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2023 00:35:37 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 00:35:36 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 00:35:36 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 13 Nov 2023 00:35:36 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 13 Nov 2023 00:35:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0a//cfSIRt0AervmLw6jfvv444evq7BlVw8rAI04Ql95jAwIaJuX6Oq9ZW5rTLSfJsXAeXeP6mZo33AhIGE+Us9DxZwHIeA4uwDEo7cAml1ZAmTocc8XtDSsAACDEnj7qE1ZdfI1kR4FfGTjTriuw6dnmW8RmS0FpbbWgnN+mQ280TAfeDz9WKi1Alz3Og/x6q33e+y4GwcwOGFCuCwqZQUjRVksiM18N9shXjB3JZ91Sk29KWs6c8Fuv9Bye4xC9lCkvWbeQW4RTPFtbs5NKb+SsFip0p+vwu/vgfajnNKOjQW1UzGnL6OKVspO25TjbINqwIVvbCSUa3u9IfYhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjsmVYx/5r2d5/N9ONHfjfsZwBF7Toyw20YrvCXc7F0=;
 b=GhHSsuqltFaE5qC0IIDE5euIkUT2rIu8Tck7XwdzSQvy3Pnkz6vlfgZZnhe+PExEIfj9Y8Cag8cNn01gyBHkd6OG2zXi+ZWkdLZoVtDbNFbyaz0QPu+BRhPNrFuq1lcvIEBz46JX0iysGzDyhEw2LjUymJG6IQqq9UofZGc8501VFCHMTC8duTbF7DzcOXfXETf32OvxoEdshHVz37rqCmHRYNm2zNYsONcjJOHKytF3hE4e1KXIxIw1HcB/uUfizDs4xieMuUClfRn/Ih19Opll48/ac60gVoItc6b+J7HkKYUt171J6bXieq8vf1Lm0g2lEDka7SOt+GbBEkRzrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB8449.namprd11.prod.outlook.com (2603:10b6:a03:56f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Mon, 13 Nov
 2023 08:35:34 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.6977.028; Mon, 13 Nov 2023
 08:35:33 +0000
Date: Mon, 13 Nov 2023 16:07:12 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yibo Huang <ybhuang@cs.utexas.edu>, <kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Message-ID: <ZVHZME8yTCd2JoBN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com>
 <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
 <ZUEZ4QRjUcu7y3gN@google.com>
 <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
 <ZUlp4AgjvoG7zk_Y@google.com>
 <ZUoCxyNsc/dB4/eN@yzhao56-desk.sh.intel.com>
 <ZUp8iqBDm_Ylqiau@google.com>
 <ZUsPQTh9qLva81pA@yzhao56-desk.sh.intel.com>
 <ZU5jzV06Wm92win2@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZU5jzV06Wm92win2@google.com>
X-ClientProxiedBy: SI1PR02CA0011.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB8449:EE_
X-MS-Office365-Filtering-Correlation-Id: ae79db24-4660-44b2-ce07-08dbe423806b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4bVz4Q1QfsWApFWXK4Ofjijn2Dmz2lOwEH0bs0RxVvs3CsUWYJVFlGt6T6m+46zbQrUHtN3cauNPlqb3IZUIZCWvp/n39ORlSo5zt8AJhvHINQ2/8qLD8LCGom3Vn39sxcwmKWIK1gjvZRMpz+Ycwea8r4et0UZ35B5bP3sRjJUrr2QRRWHrV8+wPChT+f8098azeYhYcP7QoVukn88CyPy+Z4dnOrrtc7D5q8L757fHbANsauU2KXITEi/cDdrzokwfmW3OQfYybDrKazhCMIKiXFSEIe5QmdweZ9CcAHW4mrI7MjW8xhwkUB2N+LcPqOh4pI89IExlTrsqT3t1SUCU6UhUbKrrOat1Sszn84r/OmrnnbTaZ9v2++Yszu9Wny361EYzjO8T1M5RMs1QdUd6naMvt8PzGfT+wNG449SweU3FF3a1GKO0YEf1KFUJ2/kctm2L899kTSgG63ASPumBefdzlkn3Af6ZFdobny6bFVCOQxulSVMPZd0q/5wAxr5nufJSQnAsA7eiKJgqIYEmhhPHoLaG/YygUqlWMRqnj9Q1kU3cW1N0pTmLwUir
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(136003)(366004)(396003)(39860400002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(82960400001)(316002)(83380400001)(66946007)(26005)(478600001)(6666004)(6506007)(66556008)(6512007)(6486002)(8936002)(2906002)(41300700001)(6916009)(4326008)(5660300002)(8676002)(38100700002)(3450700001)(86362001)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ji6IlMVaJXJJhQUPTpXaS5+Ql+w4H7LeCwZuoz+4aHcTNsisoiuVbc0Acxvd?=
 =?us-ascii?Q?0x/MegOOi4M6e+InOjJzfdiiFm2syTIteyZ6z7yGJHfcyuPJk/M8n2U60uOF?=
 =?us-ascii?Q?RIlvE+5+368O5iRAzJjAy40knxQqCohkV67gzBEpLSfqUIoYGFlYUiUgYUR2?=
 =?us-ascii?Q?6lphnuUvRTbyQl+ThZ/EsX2Mw/vHdYu1VQEmJ6YuYwZQajYXtHdSQ+IVQUfj?=
 =?us-ascii?Q?Q4AfRIlOC/ChihrnscK/NWTbs5PNK/KWcwEjUm7JHjeC5LrVWIrWi3tE7IHF?=
 =?us-ascii?Q?Nwjvbts6aA64nk+v6L9jz8RBiKcyYQBXqbEkuw+p6Z9dmpRt4HXJT/zaAm8l?=
 =?us-ascii?Q?cYOHIUOIRfmZe17I9pmsT3Vcqi/tFn/i+pwukoH71nDx4toWQ4v1ZTVHp8Az?=
 =?us-ascii?Q?1VzoeviB+umju44j5Ep52Y68JdoLApnvzjeCLMbfnaAUNe0fkYsjM35X3bwj?=
 =?us-ascii?Q?pnYt+sapQtNvoW1dknYPWmzNyBX/bOUH8hKjd82uozacOQGYZnDTVv5fvo2i?=
 =?us-ascii?Q?bDZOP8GwlspKt16jZGEvr8f5ROBKHel5p+ehtDr5nSioN+n9gHhJTg5Momjc?=
 =?us-ascii?Q?xnDP8Z1wV364c2DNHtE8nLQ7k39AUBUuBqwMSDnmbUWaKm7rDUt4pdmvLCfg?=
 =?us-ascii?Q?uOXXoGDobVempRzzAmotkDjYUMk/gVPo0SzKAH2QeCoeaX32XQsCinpdsA6y?=
 =?us-ascii?Q?IegnUJkoM++/udWy4uccANy2NKNoo2sT6XSa8nw+MOLnV6IJzATkoeAuF/Mc?=
 =?us-ascii?Q?Be4uWfdaAg6FG2PYtw1s6sl2oWV/Mk6R8WQ7MBP6d5+fuCghjMN7NtQRvmpf?=
 =?us-ascii?Q?Y4Kz9+fDvGplq3Vcnu7/tjIY4qfsX5aUo0W4Dpny/5EV2oN0LfWcSYPTKo1A?=
 =?us-ascii?Q?HAOhzxZmLKNIup3x9zeVreKfgjZAqMXgT63OSjRV93CpRzkSYTU8cShaHDXQ?=
 =?us-ascii?Q?4i6fMbKoQdQxcj2b17FXgKu1APdcpvihm/urmhRPkhaYP0AOwk+k4f2cjypK?=
 =?us-ascii?Q?e50v344L6YitpnuPAkHbcckgY6CZzoylkky0qqJ9cO9ERswxRLmYU1ZYuLjm?=
 =?us-ascii?Q?cFhWy1zNBHZ5ZEhVIlPbNRyoSvLfB7dwA/aHOOsHYrjY3rs8hEqiVcejmqZa?=
 =?us-ascii?Q?bxnT5sB28XVbQcfZrqDmIAunSCpqpKbbJbtIy98X4FRwVmSr5XkGt8WOfpMv?=
 =?us-ascii?Q?GXjTJxzOZhW1B9SkXcTbCHj/T0NwxHMwt8XzMfHJAvJqWWdgNPAc8jTY64ss?=
 =?us-ascii?Q?5ird1YxlotirV1aRlO/akMxB81HsCYgFHzSRbff0qazxTepu3tmb+IxfhEF0?=
 =?us-ascii?Q?trLuCsmg/Gs40iHIXUhTrYVKPPkVSMqNu8SxDqaFGOMRwBhX87hvgaryvYFe?=
 =?us-ascii?Q?ytIs7+euAQGOwbiyj55fTQTngnEklXVQEXbS+NUar3mPNppng1VyMM6kq/YO?=
 =?us-ascii?Q?MLh2pjsdkdCNyJnG7eDxih6y95IOVghTJ5iTxLI3S+f+PUMwNemIYIkzh+D/?=
 =?us-ascii?Q?HZrHg5hEuvIL8ejqpzYpct3VbbrpG07FCNNSkwJCSXOYbsmaKdU1gQLBAnNf?=
 =?us-ascii?Q?dxCf/980GYS/3Fc2S2I98kytvMf66Hdz72mi02KK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae79db24-4660-44b2-ce07-08dbe423806b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 08:35:33.6052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ivzfl9n1esb+WpMyanRm2z8wy1iEuAvblYbY1Ew4edLSsDHL6qo9uJy2ZvkeYu1/IiVTk8kmaW9MWRD/+qlmpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8449
X-OriginatorOrg: intel.com

On Fri, Nov 10, 2023 at 09:09:33AM -0800, Sean Christopherson wrote:
> On Wed, Nov 08, 2023, Yan Zhao wrote:
> > On Tue, Nov 07, 2023 at 10:06:02AM -0800, Sean Christopherson wrote:
> > > On Tue, Nov 07, 2023, Yan Zhao wrote:
> > > > On Mon, Nov 06, 2023 at 02:34:08PM -0800, Sean Christopherson wrote:
> > > > > On Wed, Nov 01, 2023, Yan Zhao wrote:
> > > > > > On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:
> > > > 
> > > > > > If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
> > > > > > without non-coherent DMA?
> > > > > 
> > > > > No, there are snooping/ordering issues on Intel, and to a lesser extent AMD.  AMD's
> > > > > WC+ solves the most straightfoward cases, e.g. WC+ snoops caches, and VMRUN and
> > > > > #VMEXIT flush the WC buffers to ensure that guest writes are visible and #VMEXIT
> > > > > (and vice versa).  That may or may not be sufficient for multi-threaded use cases,
> > > > > but I've no idea if there is actually anything to worry about on that front.  I
> > > > > think there's also a flaw with guest using UC, which IIUC doesn't snoop caches,
> > > > > i.e. the guest could get stale data.
> > > > > 
> > > > > AFAIK, Intel CPUs don't provide anything like WC+, so KVM would have to provide
> > > > > something similar to safely let the guest control memtypes.  Arguably, KVM should
> > > > > have such mechansisms anyways, e.g. to make non-coherent DMA VMs more robust.
> > > > > 
> > > > > But even then, there's still the question of why, i.e. what would be the benefit
> > > > > of letting the guest control memtypes when it's not required for functional
> > > > > correctness, and would that benefit outweight the cost.
> > > > 
> > > > Ok, so for a coherent device , if it's assigned together with a non-coherent
> > > > device, and if there's a page with host PAT = WB and guest PAT=UC, we need to
> > > > ensure the host write is flushed before guest read/write and guest DMA though no
> > > > need to worry about #MC, right?
> > > 
> > > It's not even about devices, it applies to all non-MMIO memory, i.e. unless the
> > > host forces UC for a given page, there's potential for WB vs. WC/UC issues.
> > Do you think we can have KVM to expose an ioctl for QEMU to call in QEMU's
> > invalidate_and_set_dirty() or in cpu_physical_memory_set_dirty_range()?
> > 
> > In this ioctl, it can do nothing if non-coherent DMA is not attached and
> > call clflush otherwise.
> 
> Why add an ioctl()?  Userspace can do CLFLUSH{OPT} directly.  If it would fix a
> real problem, then adding some way for userspace to query whether or not there
> is non-coherent DMA would be reasonable, though that seems like something that
> should be in VFIO (if it's not already there).
Ah, right. I previously thought KVM can further remove the clflush when TDP is
not enabled with an ioctl().

But it's not a real problem so far, as I didn't manage to devise a case to prove
the WB vs WC/UC issues. (i.e. in my devised cases, even with guest memory mapped
to WC, host still can get latest data with WB...) 

May come back later if it's proved to be a real issue in future. :)

