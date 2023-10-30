Return-Path: <kvm+bounces-66-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 668E97DBA13
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 13:44:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 859C41C20B10
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 12:44:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38AA2154A9;
	Mon, 30 Oct 2023 12:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="POUTeFtG"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911816AAD
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 12:44:30 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1639C9
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 05:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698669868; x=1730205868;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=RIZ1UhwkKDLlepfNkhFEESjePTSHLyx19j7Oy2f30xk=;
  b=POUTeFtGujSqyWvopdFZu0WLRNdoem8xQwVC0S+taCQtJw/DX7SUryvx
   9iwL2AHUZtz8Vg3dc+LME8t8RRDBojSBbMucv3fDxNGl47INinLvkdTkN
   83ru1dOhCisT+KX1x8UJ+1Lco4edPcpXC+SYFb/Umh5TdUK6+fiskHKsk
   ridDcNz6N4PzkI5eCxthBuQev0z0bKwYAkyfsQVVrERNSJ5mDuH29Xbn5
   /6QBnGSbjcGJi2VbTjYjmsZaCRetjBk+ZtUZND3E2vXRNm9Y9tXUeykUw
   Zm8GPWJHbQI0A/tGUwfhgz7S8k4XqmBkOflNAiKSEA2ivpafYNoapUgmB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10878"; a="390921013"
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="390921013"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2023 05:44:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,263,1694761200"; 
   d="scan'208";a="1453528"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2023 05:44:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 05:44:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 30 Oct 2023 05:44:27 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 30 Oct 2023 05:44:27 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 30 Oct 2023 05:44:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIAmJQ3MvAmdj1WNr2XCaeizZSAo7SMF5Wxgaz5+QNp0DFHGG1aAYrtQDoAzRZzr3Rnly1LhqYV+GRurpG0EAt3IBYEOY2v/7aICfg21STzwQuCj6zsclG30Ny6DEHJYclIHNxoTyjsFO5xCwWDtvje83mk8f3QNMQwR2wk5xfvkCrYNJ4qs/cbH9QivtVqzwyrYMcaHRulxBxbzw7OluptzCIuiUGDn4bL+6BLE1NBLQfDAqZw18RW0t/ulqL4TOegPbSAA5T2cHtXTPK+VPXqqjaaSJ8RFj4DaTMRX09APpZGcii5Pxaq7fKBXM4R4NT7d8PTn+xwbkRW4BJLpcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=88OOT93Uas8LNRSI7NNy7xaAf5VEoGhjZxKNFddvTMI=;
 b=RVPcp6ycvg+SssbowT0oSA0C/a8zJza0rD1TM1T2/uuodCyRXYa3YD6uomJ4WwY0a0cpGjt/4GVwLZ9EmUA5xvxy1vONf6MWsiFvi67bAZm4R/fewPkmuvcXbRoaDGiKVgXb2YKl7HK7vCOAyPZuL9Sco8BNb28Mhkg0gEdAsIEdmNdl4NozIvWr4EIosReR/OLtGufJTN/7OYOckUmtwqBOLYj6kwiDlZq2fTDKaqY4BXksiwXy8W5+68fPfL29HgO94bluoBu3i/J+VOshC8vZCbrAkiBFnLQmy3Duv8Exnbu4rzanBdqfDioUw6jpVll1z6yuUAa8Zxo6npvu1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB5325.namprd11.prod.outlook.com (2603:10b6:5:390::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.28; Mon, 30 Oct 2023 12:44:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::3228:6596:fe02:211b]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::3228:6596:fe02:211b%6]) with mapi id 15.20.6933.028; Mon, 30 Oct 2023
 12:44:25 +0000
Date: Mon, 30 Oct 2023 20:16:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Yibo Huang <ybhuang@cs.utexas.edu>, <kvm@vger.kernel.org>
Subject: Re: A question about how the KVM emulates the effect of guest MTRRs
 on AMD platforms
Message-ID: <ZT+eipbV5+mSjr+G@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <2C868574-37F4-437D-8355-46A6D1615E51@cs.utexas.edu>
 <ZTxEIGmq69mUraOD@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZTxEIGmq69mUraOD@google.com>
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB5325:EE_
X-MS-Office365-Filtering-Correlation-Id: da98e2a1-08da-41ea-6adf-08dbd945f274
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WogOl/4hv5PhrOxhAn16pPnwYyYSZDE/N5O3HRIxWgh4MwNhXihmcgeZS/I+wlWXEtHGXSdSjDDcFrbg8/M6KGzYSz/yohj3j0v7xRkDZDr3VbPEFWIp6neVG6VibzXG9lpI8IASdwrW8JySuwKIBwty0jdA2FTGNF7s99dlP8wpor1+FQChJWUTozN4tuLIS+OLig10SuLZbMhn2NTCUD2ZL+oyxS0M3l0qFFRdLsBi5fVLeAsm49h1KR8NQk1doAjtwFxHKziPr0fufZpfZ0Mn8NWyhqyWv2svhs/pPirMFDeSl4e2C2XmHzccpWbsYOtuEBSlE9sTWAn69fquThxAX0DpuiyeC71ofBfnD6403MSLjT5oz4y0t3RCyUdE3/PWmEeCo0nSnGhWHeMcxZylP7ai1eNNkwBu/BDN7AzLg4lmSEgC+FQ0nOzx2d8suURfA63OtxBUbFe7olyX9flDuDQKHM4d9SYy6hQp997v1ThjCbJIoFWr4hIaIDgXfY2GTcJf5WsyzkyboH/vluCUyp9ijKRoGaaobIHdT/sYFwz1rxevJAjoZHO71ads
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(346002)(376002)(136003)(39860400002)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(6512007)(26005)(38100700002)(86362001)(82960400001)(3450700001)(83380400001)(2906002)(478600001)(6506007)(6666004)(8676002)(8936002)(6486002)(66476007)(6916009)(316002)(4326008)(41300700001)(5660300002)(66946007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UxxTWNFHnlfXdqly5UGr+/AHyIATH72wsuq4XeqtM333lGC5znVql/s3GMCP?=
 =?us-ascii?Q?pui/yzumPbsJp+Nz46aeQErOiqWW7MwPNap/wRqi4DI4VN87qheEu5h+GFcC?=
 =?us-ascii?Q?jc5T6Gg683ggwpbLac9l9pn1pXc5xlCnK8Uh7+ErsE/CVCh+R7ZtTzFjXxCt?=
 =?us-ascii?Q?vgheE7qhwnN5JEiPd4x/pfia3v35Xfg3tzNBkXnIxq4qEu5WLsEGtAbfwxnU?=
 =?us-ascii?Q?m4MjHR7tmKyA9l5mjea7gGjEs+OtSz1Yc1M1P20MLKhQEmlVdXv7hfaFQzZ4?=
 =?us-ascii?Q?pBcMQV1S6cUmJGohsqxCD0BKKcmXf2eyNsy91dTCyfhYyCfhX+XvJLVtkRMK?=
 =?us-ascii?Q?vnB/4XHWZ3EbDK8GQbtutSlpyIgKf+3xdxlbs3J4s3kvrkVKzzsyJg9IePa9?=
 =?us-ascii?Q?4xM0m43RBUXNo4By5rcEcDnFQtUCvrm9HXh6Eg0i79AiS+avJmgs0OrbId83?=
 =?us-ascii?Q?Tu4A8d4qOEKNKQPs9IJNtxEoi0Be01FfcIZWqMNa0gRSyi9jils3R4F2lsRG?=
 =?us-ascii?Q?bZSnodKwf3Rx9akq5n9IQF4BfRjlbDvFdlTdO6CD+k/Z19ZL40DTed+ktxhc?=
 =?us-ascii?Q?shwWSxY8Jsg19og2BGn7kwndFBUvAr7w5ITygVpgAWj5TAjcWVI8CHHn33q3?=
 =?us-ascii?Q?7/WLIBfcwdGrqCWVhoMnwcXTCSbWTutmPqY4ABOT+Vk+4fi4XCXA6J1iz7ue?=
 =?us-ascii?Q?fjenqD9Qg/r4eR+iFVN1AkrC6FeDQeYg9lCOu3B/TnBk3uMemvzsOL3UGdO4?=
 =?us-ascii?Q?wOANXTAs+bHUweG/nM776YiLGZGmgwieXZ4AIjeOPifG/riUPNfF3JNvJiar?=
 =?us-ascii?Q?4Ih7OtYnK7RtOVweLk6RwGEwVOBw908b7juuUCNM302gcArFa4mHaquI9Baq?=
 =?us-ascii?Q?uBi/kMC5yTw+7mYr8NOqGqd10Q4yswPMODHpLTzQ6LBh+RrUwF8hiZpSn4Js?=
 =?us-ascii?Q?zgPZaB8mqFRcBMnpqv3GMbVaFI/LapYdImZhx3x00LzkdDGKsCGsp/Piqsyn?=
 =?us-ascii?Q?SwPp6yK0UbK0mCQxaS/H7EdmcjCas332VVu1V5XLwgi8fvZlghMajliHpjal?=
 =?us-ascii?Q?7KgA7QKWMm6egulWw21d31IPXvBWMZNcjflUvaQ8sXpjedcH+/O6xpov+m6g?=
 =?us-ascii?Q?BaIRc2uNb+t//428uDxMMlFcfzQiKwpTpu3dF8qbU2tnJlL9KFjYTyAenijw?=
 =?us-ascii?Q?AbsUhm/FjhhldmrdqcBWv0v/NMHMcYULD/B2Ii71XpIEl6Z6r0Da2s4Fmqtf?=
 =?us-ascii?Q?q/6wi3Gtjj8xwoCjwP1T8xewvm3QS4A57LRsxCQDXEovWOWgkJmYuBYFMYjW?=
 =?us-ascii?Q?WWuS7zmYvVm2yBRmqgKzdrvT0XIXjrfvnGrlVGdb/HR0E/Vx9QirBg70WuaQ?=
 =?us-ascii?Q?hmwlmoWJ+zxw7DBlnv4IbTGIFGzcEWgBazK+vjdKxgG+H/3qZeoo2JJnJTqP?=
 =?us-ascii?Q?wkabDoVVVKXtTgJAU8JPlx2MRpf7vYW0KkB2Tja8uH3WQa5HhGYt87JMI084?=
 =?us-ascii?Q?V8HGHttCeIXWG/Xa0sk7algKohCwgpd6gwafFeiTRVfQCCfxhkNmFCzcmGfp?=
 =?us-ascii?Q?0UMfro4wbprl4gngrCySPBC8W4pdSNLTmnJnWeRi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da98e2a1-08da-41ea-6adf-08dbd945f274
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 12:44:24.9830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btVyOxWHqggvaOK6JwGAkqd2e/BPGtfvFpeTMBLrmBWVkU67Rf7r/FnFJOPwTzlFykV7A0Of1XqH3O6F8+D4Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5325
X-OriginatorOrg: intel.com

On Fri, Oct 27, 2023 at 04:13:36PM -0700, Sean Christopherson wrote:
> +Yan
> 
> On Sat, Aug 12, 2023, Yibo Huang wrote:
> > Hi the KVM community,
> > 
> > I am sending this email to ask about how the KVM emulates the effect of guest
> > MTRRs on AMD platforms.
> > 
> > Since there is no hardware support for guest MTRRs, the VMM can simulate
> > their effect by altering the memory types in the EPT/NPT. From my
> > understanding, this is exactly what the KVM does for Intel platforms. More
> > specifically, in arch/x86/kvm/mmu/spte.c #make_spte(), the KVM tries to
> > respect the guest MTRRs by calling #kvm_x86_ops.get_mt_mask() to get the
> > memory types indicated by the guest MTRRs and applying that to the EPT. For
> > Intel platforms, the implementation of #kvm_x86_ops.get_mt_mask() is
> > #vmx_get_mt_mask(), which calls the #kvm_mtrr_get_guest_memory_type() to get
> > the memory types indicated by the guest MTRRs.
> 
> KVM doesn't always honor guest MTTRs, KVM only does all of this if there is a
> passhtrough device with non-coherent DMA attached to the VM.  There's actually
> an outstanding issue with virtio-gpu where non-coherent GPUs are flaky due to
> KVM not stuffing the EPT memtype because KVM isn't aware of the non-coherent DMA.
> 
> > However, on AMD platforms, the KVM does not implement
> > #kvm_x86_ops.get_mt_mask() at all, so it just returns zero. Does it mean that
> > the KVM does not use the NPT to emulate the effect of guest MTRRs on AMD
> > platforms? I tried but failed to find out how the KVM does for AMD platforms.
> 
> Correct.  The short answer is that SVM+NPT obviates the need to emulate guest
> MTRRs for real world guest workloads.
> 
> The shortcomings of VMX+EPT are that (a) guest CR0.CD isn't virtualized by
> hardware and (b) AFAIK, if the guest accesses memory with PAT=WC to memory that
> the host has accessed with PAT=WB (and MTRR=WB), the CPU will *not* snoop caches
> on the guest access.
> 
> SVM on the other hand fully virtualizes CR0.CD, and NPT is quite clever in how
> it handles guest WC:
> 
>   A new memory type WC+ is introduced. WC+ is an uncacheable memory type, and
>   combines writes in write-combining buffers like WC. Unlike WC (but like the CD
>   memory type), accesses to WC+ memory also snoop the caches on all processors
>   (including self-snooping the caches of the processor issuing the request) to
>   maintain coherency. This ensures that cacheable writes are observed by WC+ accesses.
> 
> And VMRUN (and #VMEXIT) flush the WC buffers, e.g. if the guest is using WB and
> the host is using WC, things will still work as expected (well, maybe not for
> cases where the host is writing and the guest is reading from different CPUs).
> Anyways, evidenced by the lack of bug reports over the last decade, for practical
> purposes snooping the caches on guest WC accesses is sufficient.
> 
> Hrm, but typing all that out, I have absolutely no idea why VMX+EPT cares about
> guest MTRRs.  Honoring guest PAT I totally get, but the guest MTRRs make no sense.
I think honoring guest MTRRs is because VMX+EPT relies on guest to send clflush or
wbinvd in cases like EPT is WC/UC + guest PAT is WB for non-coherent DMA devices.
So, in order to let guest driver's view of memory type and host effective memory
type be consistent, current KVM programs EPT with the value of guest MTRRs.

If EPT only honors guest PAT and sets EPT to WB, while guest MTRR is WC or UC,
then if guest driver thinks the effective memory type is WC or UC, it will not
do the cache flush correctly.

But I don't see linux guest driver to check combination of guest MTRR + guest PAT
directly.

Instead, when linux guest driver wants to program a PAT, it checks guest MTRRs to see
if it's feasible.

remap_pfn_range
  reserve_pfn_range
    memtype_reserve
      pat_x_mtrr_type

So, before guest programs PAT to WB, it should find guest MTRR is WC/UC and return
WC/UC as PAT or just fail.

In this regard, I think honoring guest PAT only also makes sense.

> E.g. I have a very hard time believing a real world guest kernel mucks with the
> MTRRs to setup DMA.  And again, this is supported by the absense of bug reports
> on AMD.
> 
> 
> Yan,
> 
> You've been digging into this code recently, am I forgetting something because
> it's late on a Friday?  Or have we been making the very bad assumption that KVM
> code from 10+ years ago actually makes sense?  I.e. for non-coherent DMA, can we
> delete all of the MTRR insanity and simply clear IPAT?
Not sure if there are guest drivers can program PAT as WB but treat memory type
as UC.
In theory, honoring guest MTRRs is the most safe way.
Do you think a complete analyse of all corner cases are deserved?
I'm happy if we can remove all the MTRR stuffs in VMX :)




