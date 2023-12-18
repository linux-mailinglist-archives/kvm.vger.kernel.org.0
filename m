Return-Path: <kvm+bounces-4664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 74045816646
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 07:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1AD71F2276D
	for <lists+kvm@lfdr.de>; Mon, 18 Dec 2023 06:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 290388839;
	Mon, 18 Dec 2023 06:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nG2cOQ92"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA83579F7;
	Mon, 18 Dec 2023 06:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702879766; x=1734415766;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=eQKUn6nnkrNLGcWCM5a2VjWJi0fpNT9AbnGtbAReTcE=;
  b=nG2cOQ92Acv6HNRLw6Om+vGDX8g6c9u68PmFcdah8BFdPMfwHAIH84om
   p+kdE6vMjWi+gbSwe7HpkLMa+qEQRTaB5tjhe0Eqt7lxtVY8FMGgEkk4S
   IQu82quvfifKA6UA/SjUu/WwZKlAFtW52My5n2IaDxBMoE7IEoyrILIkh
   aIdYTZ50qNcv+JA1iSco90j96yUoo8qaC1i4ga9aWvDtvipu8u94NPeVT
   HcfaFkayaXGZhmxNFR4T1QEvJFOkEBj1QimztOlRyafvwHWpwsJfrvu1k
   qdlFlsG/SDI/YkWJCs1+6q3+J7t6dYwfluIRqXpjJDA9IAycXnY4d2vAn
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="459786113"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="459786113"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2023 22:09:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10927"; a="1106808775"
X-IronPort-AV: E=Sophos;i="6.04,284,1695711600"; 
   d="scan'208";a="1106808775"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Dec 2023 22:09:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 17 Dec 2023 22:09:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 17 Dec 2023 22:09:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 17 Dec 2023 22:09:24 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 17 Dec 2023 22:09:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZcOZ5x5QzIOZEdE5YkP08mlIIDLJBAUcxOqk8gz/IANTH5j+90QREv/tCW3/H/Xvar3JBxwYxZq6Eb0Os8YSyMGoEBcdI/Yihajgcu89g8nCMr71ZbRT8mKCdnzmIt8xQAdrFAcNcsB45ky8S7Oz/3D3LtzTpKgTn0Ddxh4KGGlBpnmyXkFfJL5cYzuJANihhHk16tzqq2fmmJey9AddO57ml4eWQIK6pDlKJLEKy3nqvVFsoh1GrubnDSimCrqOuhbZLdxETgKzCx5rkyH5OMvPN9K6Dwo+UucD8s/e8ja8wBSxcMRKJc6fA0NI/8nsrj3/knYIuyZOIPEE2P8qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Y4VnWlUMDbuJSfgUPHFeLU9LbLxtoNnHvV+8bVGiwg=;
 b=UQObMmhCqEfIXMTSEMCvTlPAIX/PorNboNPJXSwOcvKvG6EGn2ndf6/D+PGkxmIRG9khBQPVJV2QWLK16mFiN/vI0qKHhzH8LXUkoxW4e4tzBOnP0fpbVJSaUxjPhnKQx7nMxBqDavPG5fzePnSsQ+70Z56cxoFQW3b+tqF3J8tbUwWGpfCCfWRu3sTBwmIj28XXpdeHwxHj2KY34EGXdfNXuDMNlSDcY9XJOckScjNQcyWzVJoQzTfCXcRVgx92vBXxgLgaIaCZP30V6+sWKrm/f00KXzGtKekRIrotPvOBbCxpN3fqHHFly67D1tD0cwOdvZVjwFPhr063WlxJWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB6826.namprd11.prod.outlook.com (2603:10b6:806:2a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.37; Mon, 18 Dec
 2023 06:09:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7091.034; Mon, 18 Dec 2023
 06:09:22 +0000
Date: Mon, 18 Dec 2023 13:40:11 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, <jgg@nvidia.com>
CC: Oliver Upton <oliver.upton@linux.dev>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "James
 Houghton" <jthoughton@google.com>, Peter Xu <peterx@redhat.com>, "Axel
 Rasmussen" <axelrasmussen@google.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, David Matlack <dmatlack@google.com>, "Marc
 Zyngier" <maz@kernel.org>, Michael Roth <michael.roth@amd.com>, Aaron Lewis
	<aaronlewis@google.com>
Subject: Re: [ANNOUNCE / RFC] PUCK Future Topics
Message-ID: <ZX/bOwVVsnO5OEhI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231214001753.779022-1-seanjc@google.com>
 <ZXs3OASFnic62LL6@linux.dev>
 <ZXyzZ8GOtWVhXety@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZXyzZ8GOtWVhXety@google.com>
X-ClientProxiedBy: SI2PR04CA0016.apcprd04.prod.outlook.com
 (2603:1096:4:197::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB6826:EE_
X-MS-Office365-Filtering-Correlation-Id: 8485a48b-e33b-4b2f-5356-08dbff8fe0b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1WgA6zvmd+RaGiu4UpZhC/a8i5c6waVyI/G6dkElkosL4KjuxWyjTYSDfjFkqZ6PPyyH13YRbrzfvOA8YNx7Dl1m3WcC+CwDt9AUmZd+1CVI5b0R2DVYREbsSSpTQzXvTdzRltj2hLHDsFZS2UpFtiErc1FRChQjNBx2l0DbzAj2iIOQz9Ug1oaHgSjS6rxgQoMOpqOVXVEMwI7Fiz0kWgOf6NEaXnhUNxU5fhfsIROPaoksm9QG1F49SlLsch4SaMKcv0A/peqVIagTuoGOdPGSEFCvvySnfC+r0cTsO0edc/L0Iok/pFMWfpgIJfxvEaH5j6tNk11LJsSkdmvNQFMwiVaoCnyHJT7PgPxmL11Yv82xGhD9OTFufi0x1NPmvD90Aqv8SQusIezfK1NQOctv63445OQDTNjeyzLY+TIcJcCqINV84ExQGWEtph70nKlZt+izrEOchrgAUlAwjcBUIa+euZrfXrqPw/SLCOc4EWP9GxMX/TINt6ZlJBvzcZgTl8bYhnCTtEuzqUJJKUBAH8tucH8kVnjFF0ek03EMH+NjdWbnjpMUIrGLvjEy7Z/pmUq3Lu0dOt7JSNsV2LrDfnJCaZ8FuycBSGqNeO6KcfEiEI9190DbHFRIfsX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(376002)(346002)(39860400002)(230922051799003)(230273577357003)(230173577357003)(64100799003)(186009)(451199024)(1800799012)(6666004)(6512007)(6506007)(26005)(82960400001)(38100700002)(86362001)(8936002)(8676002)(4326008)(3450700001)(478600001)(7416002)(2906002)(5660300002)(83380400001)(41300700001)(6486002)(316002)(966005)(66946007)(66556008)(66476007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mHCsJ6uYEGHTbb5vY12mr00CfOptmvnLjZeZBwK4Rj4eMVPRgthbsLcMdOh?=
 =?us-ascii?Q?93aAjJpYjdXqp2uVmd2OzdmJZiHoX8CFpL4JrX6G8tzumJLAkTkVRPBs1USl?=
 =?us-ascii?Q?H8nAjdgLH77MSGdzevzW1rYbpikgZcCJJIqwliPSuBP/bNWgt3p4vO7sLo3A?=
 =?us-ascii?Q?CR5Phq64/hIEvqT2vkQ/XBXLkLzDsPrHHYtSrQzLqx5PlMpQEEqPUvoXkFbx?=
 =?us-ascii?Q?okoyv5zROJC4d8FEtOeBTp5X+970Xke+x0K+EaZdkUjguXUdHQZH8CUXZjDd?=
 =?us-ascii?Q?EsCkbx1sFZkQi7cvqvIqBgjooqYW6crRwEQcpSfrh4uoStnVnviHo/DZe+/G?=
 =?us-ascii?Q?/hhB/GBV0UD5vPUHdxdsA+URndC5Q+nivGDM+A80RY4QGi37Odm3jz/m32M0?=
 =?us-ascii?Q?Ws2OAjOo3Ay/AaTuTOlgtsISvRB6kwl85dL8po9+jzukPB+c6hKumgzlbVqx?=
 =?us-ascii?Q?u4QFlbKbQOUoGegp9O3oaNcwYq/pD7e2F3fwrEJpFqVGwBExjx51I/qRvS60?=
 =?us-ascii?Q?6JYmHDoRSnoXhUm3A9eiLDWGy/fftl/ylw4W9nn6oGY+51hkf0FYniTCSBdK?=
 =?us-ascii?Q?/qvQ3/G4VGInT5FWAmupTcGn6J4xPQ6vgxL0nWVvCgsDXZH/GXTtNVkSIAs3?=
 =?us-ascii?Q?cJoqP9lCtNscKPr+K8NqdBFowv1us0MLdjjs2JXvtYhH+I0KTbrdhPmXXCsP?=
 =?us-ascii?Q?OxV+sf/9ar2uToJ0bPCEyMnVqRkSrJ363fEoaBrUdto5bqfiCHdET9iPkTVt?=
 =?us-ascii?Q?fobyg55HJZf104eO6HvNAchPjqhbEVtqX7FPFvX2wdpPmKIGxiugYxtdFyPp?=
 =?us-ascii?Q?d2t4TnSXzSHQxOUGsdqJ5zHHRU+27hBq4EAH8kHW5n602XnOWZx4TS2VKNFU?=
 =?us-ascii?Q?XBA/onzf4I37/9UyzbpQBjDOOv7F9L4WEXM8QJPH0wihDyCGMF/6flU5SABi?=
 =?us-ascii?Q?khokXSZufcdrnEfvVbaMvim6TEiq9C3entfIBh+gKzyLuWmAXv5J3pD/yrFN?=
 =?us-ascii?Q?Z1Cv2Tzb+UMwkt+/RD0DmPqoMqtM1ATnG6PVI4KlQYCWpIS9y4C8Ok63q/JS?=
 =?us-ascii?Q?6Rt+PIB6AKoeMzwljA7zXHGUxYb8MyHSPVZ3MNxBHYczfNH+c8QBrBPtk5aY?=
 =?us-ascii?Q?Nygv1MrPjE2DB1M+m4M7B1LGZJr1tFFkulnFltdiv15equugtUz9w6saRwza?=
 =?us-ascii?Q?chxOo15g57vgFjUtVarIqRWc8jRtM8hrf1uLMQqwvi5MoAp6CnYR+bZFBwdG?=
 =?us-ascii?Q?uNYrPwDuup0M6vzfZhQietDWuruniBHz7VckSkAtHsKy2tg0cZzFPNx2s5sb?=
 =?us-ascii?Q?j4qTtZ1s8/Sk/kocbUv+kJvemQGlToyn4izP76mlz70kH0K8S8EQI0/n6Por?=
 =?us-ascii?Q?eTnEBN7eS8ysjwpODsmZc8TsQEfmm14vuOaJJcbwlsymW5I3ErId4Jg+KS4b?=
 =?us-ascii?Q?K1LGNaLrd4Q+j0xEwLbRMd6IJTSW9VAlWlWS1AVI4I8eIsNxm9eBLg/ey4L/?=
 =?us-ascii?Q?eChZhp4gcTQWKM2f/IIcJX3btJcwXWD+OndYs3RBHzULNL9lvgL3RuugWqcs?=
 =?us-ascii?Q?uENvSZYrqXlujKmORJrg8MTtk4M0wF4H+8qY+2GE?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8485a48b-e33b-4b2f-5356-08dbff8fe0b0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 06:09:21.9625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nz6PQwBoCDosbNoidvYuK6MjDqzKwB4j3H39ymaG2yKvqvkjBH6vhL0c5RJAzKNCBAgAvtT70xSQBzJn85HTrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6826
X-OriginatorOrg: intel.com

+Jason,
On Fri, Dec 15, 2023 at 12:13:27PM -0800, Sean Christopherson wrote:
> On Thu, Dec 14, 2023, Oliver Upton wrote:
> > On Wed, Dec 13, 2023 at 04:17:53PM -0800, Sean Christopherson wrote:
> > > Hi all!  There are a handful of PUCK topics that I want to get scheduled, and
> > > would like your help/input in confirming attendance to ensure we reach critical
> > > mass.
> > > 
> > > If you are on the Cc, please confirm that you are willing and able to attend
> > > PUCK on the proposed/tentative date for any topics tagged with your name.  Or
> > > if you simply don't want to attend, I suppose that's a valid answer too. :-)
> > > 
> > > If you are not on the Cc but want to ensure that you can be present for a given
> > > topic, please speak up asap if you have a conflict.  I will do my best to
> > > accomodate everyone's schedules, and the more warning I get the easier that will
> > > be.
> > > 
> > > Note, the proposed schedule is largely arbitrary, I am not wedded to any
> > > particular order.  The only known conflict at this time is the guest_memfd()
> > > post-copy discussion can't land on Jan 10th.
> > > 
> > > Thanks!
> > > 
> > > 
> > > 2024.01.03 - Post-copy for guest_memfd()
> > >     Needs: David M, Paolo, Peter Xu, James, Oliver, Aaron
> > > 
> > > 2024.01.10 - Unified uAPI for protected VMs
> > >     Needs: Paolo, Isaku, Mike R
> > > 
> > > 2024.01.17 - Memtypes for non-coherent MDA
> > >     Needs: Paolo, Yan, Oliver, Marc, more ARM folks?
> > 
> > Can we move this one? I'm traveling 01.08-01.16 and really don't want
> > to miss this due to jetlag or travel delays.
> 
> Ya, can do.  I'll pencil it in for 01.24.
> 
> Yan (and others) would 01.31 work for the "TDP MMU for IOMMU" discussion?  Or if
> you think you'll be ready earlier, 01.17 is also available (at least for now).
Either 01.17 or 01.31 is working for me.
But looks earlier is better :)

hi Jason,
Would you like to join the session to discuss "TDP MMU for IOMMU", which is on
01.17 or 01.31?
(6am PDT
 Video: https://meet.google.com/vdb-aeqo-knk
 Phone: https://tel.meet/vdb-aeqo-knk?pin=3003112178656
)

Thanks
Yan



