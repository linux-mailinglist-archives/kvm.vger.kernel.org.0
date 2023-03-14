Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E7A6B8CCE
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 09:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjCNINK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 04:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjCNIML (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 04:12:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A80623100
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 01:11:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678781461; x=1710317461;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=isbKsaUI43ssr9CpGZYuRlyhBBFDgghlYO3VUcw5zss=;
  b=gmFZ4f32WXy7v+Y25st3ABvVOER64GnudsTqHbY6BTdD1Q3Rk7Iwx1o1
   2dLep7vmyjPx4qDxEP1cyZSyvi89GQRD4dArjbyrPQAgywi/ZgibWOKbX
   HXWrhaCprXozm5tF5zGDGLiXOCExmbkFSA2WOe3aTkCG2TzbSM7tgpZrZ
   z9xlaIhDDVUrsIIzjLBlFLMgVBp6iHKIMoV/dZvmB0f4cvyHSn34PBDnn
   8UOQxC62QnWIQIwaPuaF/Sj2xik8B4IDMpX6l3u6lQa1VzeThOsTOtYmW
   OUoobuesF1mk4iQcAiHojDTw7W6RZgJkvkJBp0GhbIpFPfMfnWKQsfnR5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="399948610"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="399948610"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:10:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="822274266"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="822274266"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 14 Mar 2023 01:10:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:10:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 14 Mar 2023 01:10:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 14 Mar 2023 01:10:58 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 14 Mar 2023 01:10:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgR2qGq4kOO4F/Hbq3Lp9o34/MngJdsExAgXySorRIBh6ok8bmvZ7BVKlTQk3aa/MK5ZvCLSxuqQtmYpidS+ltxOWdrEOt9fFQuJpXbWZKBtBl3+aGRWk3zuJE7eICDwGq+kC9qmlX6dhXe6a2ZifEq0Jc4kIk6XZowYywzk3G0TQIPfVNDGY3o3n10iYVNZwPR2hLIxdjWUWrJ5WoF7Vjohcz9b/sUIZBlbjsPFyAx/Wsq9K4QyMkzS3Y6kcjsYuEVns6S5AaCrDTjF3JCC1VChnWz3bbgBQUIoURErI/Kjf0xGbFNJUGixcYZOIhIA59CLwnmftALLpUls60E8tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Azv932mdf+rqSlx5vyNjbQYDbuLv7sHXJoSu6c5lv0E=;
 b=S2J8dpeKFugnUtAe6sLIaJKP5i4ecL8jike9NdRN+d5Lg1uPWmHaZMQtkEWh9ROvcRyNsyrBLxzWXE/7iwZYfwbk44oWT9FAGRbtmA23F5YjgBpu4XZ2VwPYkHxEo5UDbmawT+J2sPoF45jxQlotgDDIb+9ugm49DgGtbtQr8Qma23FwsZTuE6pUsX0Q3SzL+OG9mIHco+BskKeJAWGrZyfCSC7BmzXjFjgsSGF//VZGl8l5agdjKeson7N1a8PvYX9maowvh7vDcB47o5PwKw6y5surM0biPKOJGFcnMYmg+Hf/ZhkCBr0NWGABh9+8DDvp0O2XZBM1EpTr+U+H4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by CY8PR11MB7314.namprd11.prod.outlook.com (2603:10b6:930:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 08:10:49 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::fe3a:644f:1a2d:eb62]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::fe3a:644f:1a2d:eb62%6]) with mapi id 15.20.6178.024; Tue, 14 Mar 2023
 08:10:49 +0000
Date:   Tue, 14 Mar 2023 16:17:35 +0000
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH part-1 0/5] pKVM on Intel Platform Introduction
Message-ID: <ZBCeH5JB14Gl3wOM@jiechen-ubuntu-dev>
References: <20230312180048.1778187-1-jason.cj.chen@intel.com>
 <ZA9QZcADubkx/3Ev@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZA9QZcADubkx/3Ev@google.com>
X-ClientProxiedBy: SG2PR04CA0160.apcprd04.prod.outlook.com (2603:1096:4::22)
 To SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB5923:EE_|CY8PR11MB7314:EE_
X-MS-Office365-Filtering-Correlation-Id: baf92b98-4c70-49d2-8175-08db24639f07
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QNuULxko8yFZcln7pvMbrdPMb4iWfARdf8TuRooQuK1rIcnBlHcgVatIkouFceBLkiFuBlbVExm8jOseBY17XHlyIcqj+0qmp2Kg7Hn3Xr4fsu2kqmPfKX8Kxf5FGr3ho0tNUuaiCsNyiLw1renPOmnGjiMbuqth6vXwXqYd/JtOBUCPx8P2Xqq0Qx+mCmRJtOlmoGn/XbQOx1gcZMNsZAeaVNtHVXJhSGMncf2Ik2dSVs5vllRJEa0DCdd7sH5g4TJFWqe5OJxZ5X7re1ApElBbDRUFujaNj5aEBKjq6NwseMj+FgHEz3B/u05SMjmlbeIdLdx+tF3aHxodqdsprSsFOsiJcliVMm2gQY+dtgnfSmUOnMVK+vtxdhMpnau2MGUCdyRkAVbum+op7Y5ow8D22ke8GcHq10U/zxeUmbPFHLeNZpbaQk3Lw2bGclfP3i9QjigoSOV5SlV79+zNCrnQuD5iO4ZC/cJ1fZeaqQt22wEczsc42d4+AgjfiEslVGf1Gsm509VuZuHLPbKeQr8uGq5n3MXKQSTtJY1JPntKYAYrLhoaLuLKVNr2g5Ev4VfUSsmEosZwYladPW4tidO+d/hxDx1dTraAbxBcxVRo0bkZTv0AZAywMCTcJOnm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(376002)(396003)(39860400002)(136003)(366004)(346002)(451199018)(86362001)(33716001)(38100700002)(82960400001)(8936002)(66556008)(66476007)(8676002)(4326008)(6916009)(66946007)(41300700001)(478600001)(316002)(5660300002)(2906002)(83380400001)(6486002)(186003)(9686003)(6666004)(26005)(6512007)(6506007)(84970400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eSFlIY8fSuSAQtbOtOxxOwFieZXhAkYPH+N0NfyLqK5Ee2cFjIU6t/cHd5By?=
 =?us-ascii?Q?ay4qNr9Kel1Rd10xkV11xoCynZkHt7CHAh6MVTnP4BEv1YExhgaK3xT3VuVM?=
 =?us-ascii?Q?bn/fOa3VIp4h2AIdUOtfTSVACrPlpD6Pozk9IPXYIxBHAVqowcUOcj0DLXgl?=
 =?us-ascii?Q?1XvAnN7LSabkz0LB2wSSSGxz939tkGM+o7akXDVCdCmDkjboq/svHgGggqib?=
 =?us-ascii?Q?gF+wHoLbpY+oxz5bLXMUnwDmJnQzmmTwbOYp98qqb8DcdKnsCluIrrz9sDcD?=
 =?us-ascii?Q?JaQxwgi5SRvNhpVQYPBkAkTr4ZG+RDySDeYMkAbRKuO1R2C5WJneVYYFs5QZ?=
 =?us-ascii?Q?RXMaBh3xTNcdP2aa7caRtN1TwW/OKA/l1UtTNS7elhUntRDrUP/0JPrTXyj8?=
 =?us-ascii?Q?psMe99X3QICSE5rkGCZlztwJaHHRv3gd9RyoQDqVf6/BX0Eaw1HScdJrg6Kn?=
 =?us-ascii?Q?9mMf91b+rFNh50QVb6CvBMOU4x9oFs39n4cpqBfGg39Fd68iaqv42yYLp4MU?=
 =?us-ascii?Q?35NJXfGfp0ylVygbPfImUABB7ER+8O2Yxj91t8NLGmq2eERmSz7EH4/k3MIr?=
 =?us-ascii?Q?Xiu73T4MGu7s60sLHDYvVWhKE3O02M1E9AYn4coHrfd24C3g9zAmsgTSwW9o?=
 =?us-ascii?Q?0iCObRdyMvOsUve5TxH+e6phGoRTi54mvHV4A2Xxzr4vsQ+qhozC4iMRd1F9?=
 =?us-ascii?Q?+ZsClOCUiMKXpLEommVCvNFvW6zOx13r/rV9hSV+cUouxyz2z269N2J9M5m0?=
 =?us-ascii?Q?LKtkgzrAJtqummB3A4VgFYI01mUpZ+qgBPj+unc8DicZ2+EVLUKCzCPFWCpP?=
 =?us-ascii?Q?bDAAKNs6SdeR0gtUJxXyWLv1Vg06SR+7J88xoK1jHoTpp0UkqelwGoCped1A?=
 =?us-ascii?Q?PnpC7X6S66FF1lfTcBslvWnoXRFi08MNjkSHQDhkSxz6nrBHdpsSwE9fXypq?=
 =?us-ascii?Q?IMra6LM3Ur8HjrEnq+GhRI4pjRgUIrqxFqSBpK2pzrnpTsKV+n68Wktwm9uh?=
 =?us-ascii?Q?fiW8Uz84rUBigV/YKR74mDn3gbN2z4yGU8jSmikGPVCvoQ8iMuz1J+yxVDq/?=
 =?us-ascii?Q?R3maIA32qtbU2WFhNqJBGJ+RMSqYYTgNgHm59b2Y7ekZeGxCBv6pdNHfQOCW?=
 =?us-ascii?Q?n8fy5VFoidovRh+wggMfc5pWcQawYMCYyccsSvrpSzFu7sc2TIRa9xuse1V6?=
 =?us-ascii?Q?rQ6/1YWXGt/dfpx2W2VZVkEjWOoy2zN/9lqPn4vDKBHgllGYVY8yLSSOr6GD?=
 =?us-ascii?Q?A2HFDp022l2AEbeMvXBsfdR5LqK3FpSe84/k9+f8tOxApy64Afp9sjKWDwt0?=
 =?us-ascii?Q?vP234MKU9mEFw1Qb0jqJtBvH8qL9bIk6YR6kcOtCuYlP7/RZ+qy0lUgRoAQW?=
 =?us-ascii?Q?CtLsHnKkY/Cx3m631qD81enktfeJkjDYmRc676LfMAOLp+l6aGuonNbE80BW?=
 =?us-ascii?Q?5BO06YYNZXnAZPlKhP8DEwNtBRtR+sc/VSR1e/i5esGfQimj3BcTRJ4Ce3+G?=
 =?us-ascii?Q?MEFotMEYHsa/p9rUtv7v7s/HZ10V4b09FizdylXtLmjHFkplScGWyPWvKRz6?=
 =?us-ascii?Q?4R744zuRe7aefK1AaydFhGaojz3mqBN5fgl9N+mMc3F//1UFUXQ8SpK0M5hG?=
 =?us-ascii?Q?kg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: baf92b98-4c70-49d2-8175-08db24639f07
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 08:10:49.4300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ceQM2/8xyz8p2g3Vvz7zaRjIsuyeMpJwH8Kdemz6eEj4mACh0LJ4nzZe6jJcs10b1A3iUzCEfAvIQSvcEJn1Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7314
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023 at 09:33:41AM -0700, Sean Christopherson wrote:

> On Mon, Mar 13, 2023, Jason Chen CJ wrote:
> > There are similar use cases on x86 platforms requesting protected
> > environment which is isolated from host OS for confidential computing.
> 
> What exactly are those use cases?  The more details you can provide, the better.
> E.g. restricting the isolated VMs to 64-bit mode a la TDX would likely simplify
> the pKVM implementation.

Thanks Sean for your comments, I am very appreciated!

We are expected to run protected VM with general OS and may with
pass-thru secure devices support. 

Yes, restricting the isolated(protected) VMs to 64-bit mode could
simplify the pKVM implementation, I think it should be considered.
Especially it could benefit vmcs isolation for protected VM - it echoes
to your comments on VMX emulation.

But we have a pain point to support normal VM. You know, TDX SEAM only
take care protected VM, it has dedicated secure EPT, TDCS etc. for a
protected VM; while for normal VM, it still go to the old KVM logic as
legacy EPT, VMCS kind of thing are still there.

For pKVM, we must rely on EPT, VMCS, IOMMU to do the isolation, so move
them to the hypervisor, and KVM-high need to manage them through pKVM for
both normal & protected VM:

 - for EPT, technically, both paravirtualize & emulation method works,
   we choose to use EPT emulation only because we do not want to change
   KVM x86 MMU code. I am open to switch to paravirtualize method
   especially after TDX patches got merged - we can leverage from it but
   with more consideration to support normal VM.

 - for VMCS, it's more tricky, as the best solution is that normal VM
   run with emulated VMX to see full VMCS features, while protected VM
   run with paravirtualized VMX to limit supported features (which
   simplify the implementation in pKVM for VMCS isolation & management).

 - for IOMMU, it has similar situation as EPT.

> 
> > HW solutions e.g. TDX [5] also exist to support above use cases. But
> > they are available only on very new platforms. Hence having a software
> > solution on massive existing platforms is also plausible.
> 
> TDX is a software solution, not a hardware solution.  TDX relies on hardware features
> that are only present in bleeding edge CPUs, e.g. SEAM, but TDX itself is software.

Agree.

> 
> I bring that up because this RFC, especially since it's being posted by folks
> from Intel, raises the question: why not utilize SEAM to implement pKVM for x86?

Some feedback in above, I suppose SEAM can be leveraged to support
protected VM, but with some further questions:

 - how to support normal VM? if we have tradeoff to limit normal VM's
   feature (same as protected VM), then things may become easier - but I
   don't think it's friendly to end users. If we want to run normal VM
   as what KVM can run now, we need to add extra code in SEAM.

 - do we want to follow same interface? My feeling to TDX interface like
   SEAMCALL for SEPT PAGE.ADD/AUG SEPT.ADD etc are complicated, for pKVM,
   we can actually use simpler & straight-forward hypercall like
   host_donate_guest, host_donate_hyp, host_share_guest.... And further
   more in protected VM (which is TD guest in TDX), PAGE.ACCEPT may not
   need for pKVM, and page sharing (based on SHARED_BIT) may also have
   different implementation for pKVM.

 - do we want to leverage the page ownership mechanism like PAMT? I have
   to say pKVM also aready have one page state management mechanism can
   easily be used.

May I know your suggestion of "utilize SEAM" is to follow TDX SPEC then
work out a SW-TDX solution, or just do some leverage from SEAM code?

-- 

Thanks
Jason CJ Chen
