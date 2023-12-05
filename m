Return-Path: <kvm+bounces-3430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 531FE804468
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 03:01:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B5F91C20C0C
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 02:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039343FEF;
	Tue,  5 Dec 2023 02:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SrqkK12Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C47B4;
	Mon,  4 Dec 2023 18:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701741664; x=1733277664;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rtTdrNU6BZ1zCnzYV/KIqWIcsOuL+YPtT5ZDQzcW/YI=;
  b=SrqkK12ZXc3UxGNOORO+jWTpOQMQ2fHSrlHv35HH08kcxvjFatfRlFuo
   GusRNOQBmbgqx1etmaiW0cOZVHAlvJme0YpVgF+3g+TVMd6stEeqKOtsB
   d5x39e2C8xGuBKe9PWyq+Q33mOY1ps+TrUez/W5Tv+0x9r0y5utKPeMHQ
   0PGBfwfm3XXCsP+XjE9jUnI8bCHgJ/wQkiKd+HgThv6Mn225jrVOEQoNY
   To07FHygV7ELaI9g1kEfmqlPkd1TZ0szEZ4wt9MaYRoYRCES2uC+xobSN
   5gqalG1XIdMAuKglBunHxZSPwazaO7S8xUwpfo2e1Xa1JeSV1hm/Yi4zq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="12539601"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="12539601"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2023 18:01:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10914"; a="1018050121"
X-IronPort-AV: E=Sophos;i="6.04,251,1695711600"; 
   d="scan'208";a="1018050121"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2023 18:01:02 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 4 Dec 2023 18:01:02 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 4 Dec 2023 18:01:01 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 4 Dec 2023 18:01:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 4 Dec 2023 18:01:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ICoyo3r6ws7SvKVbaQnnN4Fcj/sN3cEFKtI22GTEaVzfEyOPcBNWe4AH8esHGukU4bHlEmc7604c1gi+0zgd3WZDs47gc+45PnuWHUNkmaFIkriZsEAVs1hsPgJ/ny7BR2bpfteU3D1dk/uLrAXyam/bNWNLjidDw9GV+JA3BthtSja+KFyMwib6xeeIdUoC0ZjNQu/AdcYL2o5ul/cg0jH775DXw0IjtF5i7fjupsjMn8qmlRqzHa+4ptsFIXIP/sKt2OJ8d+EB/K8zyiJTIHfYYgoZ5BgTo9bvYNDqo0wgMscgPGFORtHdA4tBVWNjM98aJz0GRmlkJqkhI0K/cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgZUfGxOkGcdHLbe+Ar5aA/7v4ZND9fvHxnGFi+XEAQ=;
 b=Ki18H0cK1FpePd+2XHQaELwIBgdARVZN0mnx4pRoJhp+WNxjhgTwcqKU6ra+iMIHA8ntVFb2T5az0brvs42CIJ5Gmzc1UPDTjyE4agB5188KaJS3EKQ1J+v3oo8QYzDrTrBEIDk89/WOonvoQYcf6nJ6cXhqACTgCPAFGErwavONBldE4POiD1PPQZyKGXcDZysZOpdGTmyYHs0GaSLk0HUyqs0GUFiI8vVdy1o4TW2/R7tJB5gBE7dgRjiJD3TobUuvtUKDD7s52S14aAU8vY1UIjggU3PdjCSBzt1ULlk0aOcpBsM3rwd0ZslmmmTh1oFhkztHW5MVJqjjRrn7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BN9PR11MB5339.namprd11.prod.outlook.com (2603:10b6:408:118::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 02:00:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::32a9:54b8:4253:31d4%4]) with mapi id 15.20.7046.027; Tue, 5 Dec 2023
 02:00:59 +0000
Date: Tue, 5 Dec 2023 09:31:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<alex.williamson@redhat.com>, <pbonzini@redhat.com>, <joro@8bytes.org>,
	<will@kernel.org>, <robin.murphy@arm.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <dwmw2@infradead.org>, <yi.l.liu@intel.com>
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <ZW59jO6FIVHI7Y6J@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <20231204150800.GD1493156@nvidia.com>
 <ZW4AeZfCYgv6zcy4@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZW4AeZfCYgv6zcy4@google.com>
X-ClientProxiedBy: SG2PR01CA0168.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::24) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BN9PR11MB5339:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf8b831-e485-4147-3dd0-08dbf536064c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4D2eqLx2jSqk90NH1bdIkhHvD20Zen8iWHcKhJRFKygHyhrAdQf2HwD+azNT+0gFoBZp8ub6IL7+agM3zZtR9ELaJ0qw48TXWEd5kXyBXwBCeGNwkOkYD5W8T/n6Ex5LoTH3ai7ZbyEybW6w4fgLGSY/fVv7HtzMJTO9IN7A/Av6RcUFBmgMp6XAEGakf+wHUQPHsz32N/8ZbSuUaPo+WQx3WIIjCuUF9dVv1dO2dITNjtQtgJqSljRXr7uvchX2oEotSq58MQOn3eZLBVhyu5LXRNUvJAl1dmvREPV4XMqYJo6HIv7i+UYxqCqWjtLBuc4xs4xoTPLSk/xWe6GRpSR96csYpuFmPzZiLzNB7KZuToDOIi2oIdiOOWZblvM9GQDHccql4HeT0ZTj0yC5Fb78Nh+W66wkrTSB7AezYMEwvcZOKsBp9Sht/HDQGmaIR3EUvZ6KhuCcKhbLDeUPh2M0F2bDaA2S5W/hGOSgZ/IOQ7Z1VTsqmSQMWvhmgAvTGFoao1nqaRJ4ZZBVa1keR1apK1ZX2yE0UNH3scepNsd/353/JLh4OhR73aySZOGNbEzBtgznKyUNu6bjXZKmEMjwzR8mSJ4HfDMpTJIsJDI90dHwOAQPfcX3TdncAW+3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39860400002)(396003)(136003)(366004)(230273577357003)(230173577357003)(230922051799003)(1800799012)(64100799003)(451199024)(186009)(478600001)(26005)(6486002)(83380400001)(6666004)(6506007)(6512007)(82960400001)(316002)(66476007)(6916009)(66946007)(66556008)(38100700002)(5660300002)(4326008)(3450700001)(2906002)(8936002)(8676002)(86362001)(7416002)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?js1UT1W9207aq5p7Ilej0sYFfov8iYRDotSMnzVuPmilyNRsGOcX5MRYFEOa?=
 =?us-ascii?Q?MAmvUMBNoFTl/5OWkFvaDNnPXuI8omHWmiyDbWy+I1aTm/AyyWvKazTmwr0s?=
 =?us-ascii?Q?Crp5w21aj92FyBRCo17eGEVk0A+x537vFaeGWxLAmtc7ZN0FNGheb5muwqzx?=
 =?us-ascii?Q?JMExMs0JOyFfcM9jq/jrHk2WcypaD0HA9EWG60ud82sN+LTBtzZXPpqjWfG0?=
 =?us-ascii?Q?QTHKlCCA/Eo/93p31/W2d2raYs8VzA6jYIc8RwwTKyYwJbHk+BrEABksycp5?=
 =?us-ascii?Q?JfXKAiij68mogc3Lm8VEHOzLDyIa8VHWB/OMsLsEAZNecGX7EJdo3uZLIwHD?=
 =?us-ascii?Q?5F4X25rwf6soycxtiL4fdqLGVjNNgSK4CNjid9RMXyT0+7fzaJUr43ScgGHA?=
 =?us-ascii?Q?Od+oosmdHPxZU+YyPrrMmu12iNX5ihz6e5bVWU8T55SttEjYrFzi4WEHtQL8?=
 =?us-ascii?Q?IUonXlLDAZQVvRJ82AzuGvuCA4WM4o7hkCng/xW89v4Tmy/rCeTKVGLR/Zm2?=
 =?us-ascii?Q?W2vFWhDfg/+6lNHHY4WYG/Ex5FALfdY1mLAjkkJNBFIv/Hn5OdWvW/wZoL6Z?=
 =?us-ascii?Q?W1lserqMkmaVA4Qar+mNO/rr044B5M8hUnbxMMWWRvDZDCz6hSftHCLAjcYw?=
 =?us-ascii?Q?w1By+bpPPzMQyjoRHFDttsI1zp7GqRO/1EhtgzWObuQRUHanwmSWz3JLUSiq?=
 =?us-ascii?Q?d2nLXWbnAYmbfBRxJYZWLhwv1T4jPEqLYGddGuuLEZDpUpXeCbpDAHEd8NFE?=
 =?us-ascii?Q?MW3fIcdHXAK3dnEn9K5lk/Qs633HwkVQNRZ0snkz9zRokKf9+XSBVXe61NWW?=
 =?us-ascii?Q?Y17roP7PfnALsYqZqQevN3DWuUAmuXDLfm22JHUelo8dnZQeyBtbSRZGgMN2?=
 =?us-ascii?Q?usVE1UuCUkH98BdaqIziZsPjvSxVabDV/St9RHBXv0alzmGgtS4k6FpnSvKX?=
 =?us-ascii?Q?iHWGzDuWuYrcgc+kCl1jloussN/KmQvkOQqpjRakjgdyJzdnjV+g1IwZuolt?=
 =?us-ascii?Q?H1OaKahmA8lytIh+WFjh33cscsy76pcQ9Q1lTplHOmBHMuZW/UDaRcTeqqRS?=
 =?us-ascii?Q?fXs1nN0URKf3cWztkjavQ9CkT0lWZXVELsrd2WiX1jPRgvuIdPpcsnp0DXUh?=
 =?us-ascii?Q?66jpI+flb3FlVYAeF3u0AgN7ksNSUD5360WmZkettnYxJ3oEmu8Zky7mr/jS?=
 =?us-ascii?Q?lGvYGPzVn9RkCXO14n18cKmxM1y9j4wIPsNQ70/DGuO6rk5iHKVGF+4pqJrV?=
 =?us-ascii?Q?yKjcDGueCC1xLQH0g5z76bJmWMLhvPtNxP4LFas17M9sbWCPr3m930MiMTRc?=
 =?us-ascii?Q?odrqR8MXl8CrOiksgvgsxv0dehEw5RDBMG5Cd/3rxFqRe5TCFkhwkD4dQixT?=
 =?us-ascii?Q?7XudfnneLwiajct4rDaHIOi4P9BHdp9xNkOumyt4LIBC3Z9ss5RHgdqFcyOi?=
 =?us-ascii?Q?lAvXbxWBWw2RD60r1zhtAZqb/8c0Rrhaz6n8+XYzZktd6fQqQl/hdBe+PTGt?=
 =?us-ascii?Q?sXTaDGnzwyHtXQEarxI2RMAYCyg8nveVl6mUhopBiYTccfr73hKC5IxsTKz3?=
 =?us-ascii?Q?SdVgZNbbzfuCeKPSZI6CzKix4ATrFTjT0Hpl0/bW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf8b831-e485-4147-3dd0-08dbf536064c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 02:00:58.7420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 92YaK3YDB1uq1/Kr7gBeqgqMYr2ebMFzNiLcFTlVeeJxjNAU55nP8raKtPKhN9AqMmcye5oSxnLDg9GiQ3QZgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5339
X-OriginatorOrg: intel.com

On Mon, Dec 04, 2023 at 08:38:17AM -0800, Sean Christopherson wrote:
> On Mon, Dec 04, 2023, Jason Gunthorpe wrote:
> > On Sat, Dec 02, 2023 at 05:12:11PM +0800, Yan Zhao wrote:
> > > In this series, term "exported" is used in place of "shared" to avoid
> > > confusion with terminology "shared EPT" in TDX.
> > > 
> > > The framework contains 3 main objects:
> > > 
> > > "KVM TDP FD" object - The interface of KVM to export TDP page tables.
> > >                       With this object, KVM allows external components to
> > >                       access a TDP page table exported by KVM.
> > 
> > I don't know much about the internals of kvm, but why have this extra
> > user visible piece?
> 
> That I don't know, I haven't looked at the gory details of this RFC.
> 
> > Isn't there only one "TDP" per kvm fd?
> 
> No.  In steady state, with TDP (EPT) enabled and assuming homogeneous capabilities
> across all vCPUs, KVM will have 3+ sets of TDP page tables *active* at any given time:
> 
>   1. "Normal"
>   2. SMM
>   3-N. Guest (for L2, i.e. nested, VMs)
Yes, the reason to introduce KVM TDP FD is to let KVM know which TDP the user
wants to export(share).

For as_id=0 (which is currently the only supported as_id to share), a TDP with
smm=0, guest_mode=0 will be chosen.

Upon receiving the KVM_CREATE_TDP_FD ioctl, KVM will try to find an existing
TDP root with role specified by as_id 0. If there's existing TDP with the target
role found, KVM will just export this one; if no existing one found, KVM will
create a new TDP root in non-vCPU context.
Then, KVM will mark the exported TDP as "exported".


                                         tdp_mmu_roots                           
                                             |                                   
 role | smm | guest_mode              +------+-----------+----------+            
------|-----------------              |      |           |          |            
  0   |  0  |  0 ==> address space 0  |      v           v          v            
  1   |  1  |  0                      |  .--------.  .--------. .--------.       
  2   |  0  |  1                      |  |  root  |  |  root  | |  root  |       
  3   |  1  |  1                      |  |(role 1)|  |(role 2)| |(role 3)|       
                                      |  '--------'  '--------' '--------'       
                                      |      ^                                   
                                      |      |    create or get   .------.       
                                      |      +--------------------| vCPU |       
                                      |              fault        '------'       
                                      |                            smm=1         
                                      |                       guest_mode=0       
                                      |                                          
          (set root as exported)      v                                          
.--------.    create or get   .---------------.  create or get   .------.        
| TDP FD |------------------->| root (role 0) |<-----------------| vCPU |        
'--------'        fault       '---------------'     fault        '------'        
                                      .                            smm=0         
                                      .                       guest_mode=0       
                                      .                                          
                 non-vCPU context <---|---> vCPU context                         
                                      .                                          
                                      .                       

No matter the TDP is exported or not, vCPUs just load TDP root according to its
vCPU modes.
In this way, KVM is able to share the TDP in KVM address space 0 to IOMMU side.

> The number of possible TDP page tables used for nested VMs is well bounded, but
> since devices obviously can't be nested VMs, I won't bother trying to explain the
> the various possibilities (nested NPT on AMD is downright ridiculous).
In future, if possible, I wonder if we can export an TDP for nested VM too.
E.g. in scenarios where TDP is partitioned, and one piece is for L2 VM.
Maybe we can specify that and tell KVM the very piece of TDP to export.

> Nested virtualization aside, devices are obviously not capable of running in SMM
> and so they all need to use the "normal" page tables.
>
> I highlighted "active" above because if _any_ memslot is deleted, KVM will invalidate
> *all* existing page tables and rebuild new page tables as needed.  So over the
> lifetime of a VM, KVM could theoretically use an infinite number of page tables.
Right. In patch 36, the TDP root which is marked as "exported" will be exempted
from "invalidate". Instead, an "exported" TDP just zaps all leaf entries upon
memory slot removal.
That is to say, for an exported TDP, it can be "active" until it's unmarked as
exported.


