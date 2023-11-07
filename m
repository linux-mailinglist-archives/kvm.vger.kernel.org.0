Return-Path: <kvm+bounces-866-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4117C7E384F
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 10:55:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 648811C20BA9
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 09:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C56912E6C;
	Tue,  7 Nov 2023 09:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JYJjg8F4"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3C8C8E4
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 09:55:22 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43B01BCA
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 01:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699350912; x=1730886912;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OQ+qBtJmAizgBoYd0uhFJyvUZONIeIQT+2kSOlopid4=;
  b=JYJjg8F4rsPDuKFwFzeNDgrHwF7XvFLgsgynpaBQHcTg8EQOwRx9kwJF
   rujXwV43RT6tTZfYw1AIw5zkGsNc4KMNs6Y3PuVVEXtYasDr7NUsi+5gZ
   OBrfT9VHHH8z9U0xOas/dve7OfaN7BlvTUFBNXVWTAv/XN/L0UFs+PMJX
   fwblOjyubVxGUy9DtfA/ye3r1P/p4iGAvLP0niLm896zaolw/3DoQIP4O
   rKo7J0lQfMDtUfDMUWy9zQmV3okNHEvSgzd5Y3pFMcvxHjGpmUhEwCLVb
   tA5C1xvszpDREcPAc6nBCupcLRKJgo8hsqI5vEwWsn7ghuw2YiHV47vpx
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10886"; a="455955994"
X-IronPort-AV: E=Sophos;i="6.03,283,1694761200"; 
   d="scan'208";a="455955994"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 01:55:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,283,1694761200"; 
   d="scan'208";a="3932719"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2023 01:55:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 01:55:11 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Tue, 7 Nov 2023 01:55:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Tue, 7 Nov 2023 01:55:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Tue, 7 Nov 2023 01:55:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WXlRZHb+Pl7CaSMmuGI6xj1LoDBpxTXblQwZB4s6N1HjBg4W6+DqiiL3JzyowFyCL9fdWrLHhgY8P8H/My/CIh74vBd6YxLy21dpiBX9XN3mErjHJkN39NBP/XgcDP2CVVlN15pzDHpDZyFpbaBEu6H5f1yKam+40bVwsUdD9Q7/RkGJRteMN6IK77qZJCHk9zJXZgJr2fTOSpIr/y29Wu76lJiXnNoJv397Q5z8TCfqKkYyQpXwREsG2Wo3fk46EEZ61/Fsa0UpKf/4FOONMud8YWUkFudU9kfqc1nKY+eNMMVECaPjmCHdILO8nb6bfzrNA7llkvJJxKuZdSOaGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wk1hdvUyHHHzwtb0NQAc1f8aUiiCQ+MBZlfGh8GbqeQ=;
 b=jXEgjSpX+F54dAI+8P5EOUk1djJZXVNpv1uHfH09IlhutH22kHi7hy8r2Sh/oQPGIFFOOfm+UNK2g/NJX0HUqZUVWcV+NsLq70KLmyjIch1dykr86xLqbtWpXrQNHCCwD6IGqiti2sxG8952RWg/bJnOoF2PQkzGAyirvQoIwV3PxPx8kPg+pBwtvprgVq9sCMITTQLI+wNZmHFC5du3w5Ixs0/HoS+JCxQuzbJeGYUx6lhng4M8f3IUfkSOguxYWC+9IF3PaY44joJF0A2AejN3l3+HEGjijP2pA/cqCA+n1CBOSO/tgSBHkzB3Vvk7BXOQdPXkJHHjKQrX7m+K2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO6PR11MB5634.namprd11.prod.outlook.com (2603:10b6:5:35d::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.29; Tue, 7 Nov 2023 09:54:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.6954.029; Tue, 7 Nov 2023
 09:54:51 +0000
Date: Tue, 7 Nov 2023 17:26:31 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yibo Huang <ybhuang@cs.utexas.edu>, <kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Message-ID: <ZUoCxyNsc/dB4/eN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com>
 <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
 <ZUAC0jvFE0auohL4@google.com>
 <ZUDQXbDDsGI3KiQ8@yzhao56-desk.sh.intel.com>
 <ZUEZ4QRjUcu7y3gN@google.com>
 <ZUIVfpAz0+7jVZvC@yzhao56-desk.sh.intel.com>
 <ZUlp4AgjvoG7zk_Y@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZUlp4AgjvoG7zk_Y@google.com>
X-ClientProxiedBy: SI2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:195::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO6PR11MB5634:EE_
X-MS-Office365-Filtering-Correlation-Id: 953d4e04-7c9f-46b9-5b15-08dbdf779612
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /88bW2Guf6dsqBbuNeKdkoQ3uVRsGRTpD1H4I1bmRzoR23mViQ+nv8SrFM4ULKwI7yp2M4GzcXmfnpWMc0PDdBQJg7ZI8TlashKRZatIQQazBLQM39b6iBg6JcphXke4Q/Iul9pIgYllt2wZX9Uu96NWSwfdQSV3Clunu2qJsmEH6e8A7RGS8Uf4uQgMxY2JyxexqFKfhVuhb27WCf7AC8KVxxoBtPpfdwvLDz4A9fun32uQ59AjQeD/DrnmcAI85jCtA4jiA3iJsUJZ1Vf7oe+33vatdbXKU4kLhghDjkscFZCX9SCRmyArHTEwv9ndEoR3xh21LYnyHPdHmOzrT4hy9JFP75wzx3PiQaQRaBmjyhw+k6qvbZaKDqB7hUqNBnX+Q2TgYixoGtK+dVuqBWP4BkwtGMKoUozy9fBePCAmcBSsVQwcu1MAjOIgCRusqYH3WZ/md5BS2HDixHTVJtQpMkn56eNHNf6k6uOrue08Ssanc3PQmlzSXw5m5IZxRAlX+OvO2NtoGtZW1kHAW+TPoXo3SyuCS9mj7aZGeNbDazJnrUL1deZ6X77fwKmY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(39860400002)(376002)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(66476007)(66556008)(66946007)(38100700002)(86362001)(6506007)(6512007)(82960400001)(83380400001)(6916009)(26005)(6666004)(478600001)(316002)(6486002)(2906002)(4326008)(3450700001)(5660300002)(8676002)(41300700001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BbjHaAQZniL5cMb1TNdfJXTCR521I8qhNv8MJ8mqwje2Vo1OThaoswlch8Cw?=
 =?us-ascii?Q?6kcpTHcVlQmnFSK2zo7Yo215niVTji5JuRURBMOraIgtQW78r/B03Db0dYkM?=
 =?us-ascii?Q?czuD0wBO6YZ+u30RVr8kgzz+6JDTP614V2yxzfl2rh5kz3ewKFGwSXfNSMUw?=
 =?us-ascii?Q?6C6NfZXMxio3KlOfIb0SKap9h2VDnbOLXVZPBdtzQbOjc5lP8hVZNZKxCP4p?=
 =?us-ascii?Q?c2sNlHUujyXI/PwU1N9Q4FursUI5efSYBc9n+C6PwwWp5F/yvbrKnbNjwIwE?=
 =?us-ascii?Q?+Fyyw9GihmcyP/POLaWg/9a5UGE8olJJkunal4R92ssyos0Im00wu1Eeinav?=
 =?us-ascii?Q?I2LupY7lfp5ilUDB36ZjKp6xBCQWLqrIyKTvQKNOl0AjEkt4HDicAxZmYcew?=
 =?us-ascii?Q?Iud67eQj3aSw2v/qWgcrQkpRGSVeYdcch8c0PsnrDhj0KIKLCPrr9M2dvcs7?=
 =?us-ascii?Q?/x0M8aej7bmFAXFOxH+ZQUO1q15YkU4ZG9vgJhThcBvozcUFCDs1ZsBZ5FFr?=
 =?us-ascii?Q?kZIc8ETX3ujCrGuUvPs4PwyZYEGv7CbgolM2aDR0ZOiZ5QcQB5Gi7a6Ha7tA?=
 =?us-ascii?Q?XA+9eFCE0prrtPK0xLmgdZjHsVIAcpJkIG4OhFJzLwD8ah7HiMF4mPAZ/+mu?=
 =?us-ascii?Q?XCDfJ+cT+DT/DUGFsD1+yZKKfOIvPr/j18lwSojKNGLe9NSZ3/0c0VlWi6ku?=
 =?us-ascii?Q?CeJxmwhGilMROOL0rXM1VSB7cinYdz1NbJeQsN/DnQUnnzyH8KfMVBdYwGpQ?=
 =?us-ascii?Q?38Hm5XGW1bX0VNEKcPFnxR+/7hgZX8xA8ZUi8dS4bxNA3QLHoOYuqm85cw2v?=
 =?us-ascii?Q?gmaasAQShwWNaZ8rFjo1Nw5BMLu140OMlZR6pY5trOu60t1YKpOkVgBkt5k6?=
 =?us-ascii?Q?hZQJgX7EojRBwetjMaCY0Fg1p+P/Zfh8MS9xFUlSYkJ/59r4XThW3b48rgMH?=
 =?us-ascii?Q?HPIyvNmq/8Hpyi1Tkk35B9mhwIcSXQM8hi/RCkk+GXpFfHwARr3THYwXFQYP?=
 =?us-ascii?Q?aUgiYceXhEuNG0i6dEMGG9lJaON199SRExgkijN417WvHa942629+Js+NkZt?=
 =?us-ascii?Q?1/2H/fedUF3APQBaMHzzaaRM6eqkm/YBvLpJXyR3p2YRXu8UfVZyRsjWqGrv?=
 =?us-ascii?Q?Bk8i0DCNrupWWDJI/G+tz9Cek/9GuQ9PcLg+jB7n24TGV2KRzXbL6HIaANmL?=
 =?us-ascii?Q?fs4m7cMrjk2G8pw+oFwD8udTnRxdFrA1ua1+ddoDu0kYNRVUCzDGsvRy9JEk?=
 =?us-ascii?Q?81NJ7+yXHzh0blaSQYLZKwrKnhJ1G75rmMi/xRa6jqlq6xqVaQgTcrRSmsXm?=
 =?us-ascii?Q?A9k+zyKolpTBr3y+vqyLDM7e6A1+6zo5Oa2J28QwxR5mmGTTeFoeWtoxQP2Y?=
 =?us-ascii?Q?tR9QyRQF7IfQVbBc65tcqGZLxQyhmxLhczMTuHEB7PeNs09BcMyk1TL/sIwo?=
 =?us-ascii?Q?VRAXCz0aqzZm1Kmk/G34iF+1cKwRCbSwA7Hq2EZCu/zRY4xtLTF6yyc4t/Zx?=
 =?us-ascii?Q?YeFsXD87Pn1eRD4ZbPBkJhdmphrG8+der9QblLnqQOTWPMzgviEXnwTabbwW?=
 =?us-ascii?Q?vvYllpjQ2WLiB8CRtTtyI6IMG1Jq0Ui+tsKBxW7r?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 953d4e04-7c9f-46b9-5b15-08dbdf779612
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 09:54:51.6445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DWKMKARmr0sdq3kNV3FblZe6U3FeXj3JwIyaIwhgtX9bcfuqWJSjUeWYpXqCUA5ayIUj1ZYw+gviiDp6naJJ2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5634
X-OriginatorOrg: intel.com

On Mon, Nov 06, 2023 at 02:34:08PM -0800, Sean Christopherson wrote:
> On Wed, Nov 01, 2023, Yan Zhao wrote:
> > On Tue, Oct 31, 2023 at 08:14:41AM -0700, Sean Christopherson wrote:

> > If no #MC, could EPT type of guest RAM also be set to WB (without IPAT) even
> > without non-coherent DMA?
> 
> No, there are snooping/ordering issues on Intel, and to a lesser extent AMD.  AMD's
> WC+ solves the most straightfoward cases, e.g. WC+ snoops caches, and VMRUN and
> #VMEXIT flush the WC buffers to ensure that guest writes are visible and #VMEXIT
> (and vice versa).  That may or may not be sufficient for multi-threaded use cases,
> but I've no idea if there is actually anything to worry about on that front.  I
> think there's also a flaw with guest using UC, which IIUC doesn't snoop caches,
> i.e. the guest could get stale data.
> 
> AFAIK, Intel CPUs don't provide anything like WC+, so KVM would have to provide
> something similar to safely let the guest control memtypes.  Arguably, KVM should
> have such mechansisms anyways, e.g. to make non-coherent DMA VMs more robust.
> 
> But even then, there's still the question of why, i.e. what would be the benefit
> of letting the guest control memtypes when it's not required for functional
> correctness, and would that benefit outweight the cost.

Ok, so for a coherent device , if it's assigned together with a non-coherent
device, and if there's a page with host PAT = WB and guest PAT=UC, we need to
ensure the host write is flushed before guest read/write and guest DMA though no
need to worry about #MC, right?

> 
> > > > For CR0_CD=1,
> > > > - w/o KVM_X86_QUIRK_CD_NW_CLEARED, it meets (b), but breaks (a).
> > > > - w/  KVM_X86_QUIRK_CD_NW_CLEARED, with IPAT=1, it meets (a), but breaks (b);
> > > >                                    with IPAT=0, it may breaks (a), but meets (b)
> > > 
> > > CR0.CD=1 is a mess above and beyond memtypes.  Huh.  It's even worse than I thought,
> > > because according to the SDM, Atom CPUs don't support no-fill mode:
> > > 
> > >   3. Not supported In Intel Atom processors. If CD = 1 in an Intel Atom processor,
> > >      caching is disabled.
> > > 
> > > Before I read that blurb about Atom CPUs, what I was going to say is that, AFAIK,
> > > it's *impossible* to accurately virtualize CR0.CD=1 on VMX because there's no way
> > > to emulate no-fill mode.
> > > 
> > > > > Discussion from the EPT+MTRR enabling thread[*] more or less confirms that Sheng
> > > > > Yang was trying to resolve issues with passthrough MMIO.
> > > > > 
> > > > >  * Sheng Yang 
> > > > >   : Do you mean host(qemu) would access this memory and if we set it to guest 
> > > > >   : MTRR, host access would be broken? We would cover this in our shadow MTRR 
> > > > >   : patch, for we encountered this in video ram when doing some experiment with 
> > > > >   : VGA assignment. 
> > > > > 
> > > > > And in the same thread, there's also what appears to be confirmation of Intel
> > > > > running into issues with Windows XP related to a guest device driver mapping
> > > > > DMA with WC in the PAT.  Hilariously, Avi effectively said "KVM can't modify the
> > > > > SPTE memtype to match the guest for EPT/NPT", which while true, completely overlooks
> > > > > the fact that EPT and NPT both honor guest PAT by default.  /facepalm
> > > > 
> > > > My interpretation is that the since guest PATs are in guest page tables,
> > > > while with EPT/NPT, guest page tables are not shadowed, it's not easy to
> > > > check guest PATs  to disallow host QEMU access to non-WB guest RAM.
> > > 
> > > Ah, yeah, your interpretation makes sense.
> > > 
> > > The best idea I can think of to support things like this is to have KVM grab the
> > > effective PAT memtype from the host userspace page tables, shove that into the
> > > EPT/NPT memtype, and then ignore guest PAT.  I don't if that would actually work
> > > though.
> > Hmm, it might not work. E.g. in GPU, some MMIOs are mapped as UC-, while some
> > others as WC, even they belong to the same BAR.
> > I don't think host can know which one to choose in advance.
> > I think it should be also true to RAM range, guest can do memremap to a memory
> > type that host doesn't know beforehand.
> 
> The goal wouldn't be to honor guest memtype, it would be to ensure correctness.
> E.g. guest can do memremap all it wants, and KVM will always ignore the guest's
> memtype.
AFAIK, some GPUs with TTM driver may call set_pages_array_uc() to convert pages
to PAT=UC-(e.g. for doorbell). Intel i915 also could vmap a page with PAT=WC
(e.g. for some command buffer, see i915_gem_object_map_page()).
It's not easy for host to know which guest pages are allocated by guest driver
for such UC/WC conversion, and it should have problem to map such pages as "WB +
ignore guest PAT" if the device is non-coherent.



