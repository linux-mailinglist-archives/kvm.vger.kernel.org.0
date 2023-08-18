Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 912637802C6
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 02:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356743AbjHRAko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 20:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356775AbjHRAk0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 20:40:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767502D65;
        Thu, 17 Aug 2023 17:40:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692319222; x=1723855222;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=iYuPFGNZEZBAbVX/5gmmaTlH99ZFf99lUIWjXUDmBNY=;
  b=EyebIGVqUvltsJKR2ZoSF1zxeS84Du7FHAGsBKmY5IkGjl0cNAOXeSjj
   nLJOiWnYmAEJUfoCwsZ9pMd1PJXfEgewx5KbccjFyMsLFJOTU9Da80iZe
   xDx0TDZXJhNq1NtXSc8a3c1po+0KBxf1paXPprWINa/zqayp4jaNb4ksK
   jOHkiZus5imIXiX+kqtM0czIVR+mLPKAOCb8dCnGcb3QI2wGt5+3GaGjd
   Pv0YLtpZZ+jNVxJWhravgkFLKa/jOkBnjjVn6xwZd/0JNW8k5ZPtdGMDJ
   IUSVPZ313HXITN3hxSUxbnL/uCZabWEr3gMspbFD5IFa9HDEY922z+rYT
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="375754078"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="375754078"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2023 17:40:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="804917886"
X-IronPort-AV: E=Sophos;i="6.01,181,1684825200"; 
   d="scan'208";a="804917886"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 17 Aug 2023 17:40:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 17 Aug 2023 17:40:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 17 Aug 2023 17:40:21 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 17 Aug 2023 17:40:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 17 Aug 2023 17:40:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aLTamB0DiJvNmZFSvVxwqyLbDTLv4Sh0hd4afpolPOt+wJp/zGq3cVGOfFtd1xo+35LV3gN6eaOmyUG4u/k3laQW/W8EbUDLI6wlB4I1O47SrjM9sPYqYQoPRerx2GsyZLXiD1ofA631yg8GFcOum9bI7NomwVMJUd4dSaoOJz1zhe0vwcMWiDvPDa2B8MOrADNHlfMV8s7p6cRTqIxyuEr4nffcHuaE7eS/GoRWamTv8sldhUUoWVkYXfoDlu8tva8dbzhcrXuKTXXRaOzX12znlJagbmmLfJHORa5dRKKygPi7AVWjB86FeWNfnSzwAmLBZZ6eyMgLRH7UvfSgjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/N6i3VMKlrdu3He3pbI051EGsDLnhbrsVW5dxPbPweY=;
 b=kDUTAh8LNBU4n7xslFtJbgXJ8SQ6JKHbmevZwoA6uooyF6KzRBhF9UghWBvDncrufqHIrLtBxrCg1hjmISVPmjFU3uCNXOIHMwvXyOHmAGJjlUfX68Wm+UTwWFUHVFeN9NF7184rXe9a6u3XguJYtgxITFFkepeUt6a2kWq1F+/4L25qMiz0rF5Gw/0ck6ySjpXgYK5kJ91ovgNZ4dWUm5004PYTjNWIUPllTsOXzdfPVtZA+puQ5+S3gMjd+Jwan1QXBQokSzg1VCToyqr0lZyhOZRXQF+vnV6h1jRQgC4x8e56IaRHu7gwjS8SvxvfykfSGs+TGSot4neIzVTqRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7611.namprd11.prod.outlook.com (2603:10b6:806:304::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Fri, 18 Aug
 2023 00:40:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6678.029; Fri, 18 Aug 2023
 00:40:18 +0000
Date:   Fri, 18 Aug 2023 08:13:15 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     David Hildenbrand <david@redhat.com>
CC:     John Hubbard <jhubbard@nvidia.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <mike.kravetz@oracle.com>, <apopple@nvidia.com>, <jgg@nvidia.com>,
        <rppt@kernel.org>, <akpm@linux-foundation.org>,
        <kevin.tian@intel.com>, Mel Gorman <mgorman@techsingularity.net>,
        <alex.williamson@redhat.com>
Subject: Re: [RFC PATCH v2 0/5] Reduce NUMA balance caused TLB-shootdowns in
 a VM
Message-ID: <ZN63m5Dej5MBLTqr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <846e9117-1f79-a5e0-1b14-3dba91ab8033@redhat.com>
 <d0ad2642-6d72-489e-91af-a7cb15e75a8a@nvidia.com>
 <ZNnvPuRUVsUl5umM@yzhao56-desk.sh.intel.com>
 <4271b91c-90b7-4b48-b761-b4535b2ae9b7@nvidia.com>
 <f523af84-59de-5b57-a3f3-f181107de197@redhat.com>
 <ZNyRnU+KynjCzwRm@yzhao56-desk.sh.intel.com>
 <ded3c4dc-2df9-2ef2-add0-c17f0cdfaf32@redhat.com>
 <37325c27-223d-400d-bd86-34bdbfb92a5f@nvidia.com>
 <ZN2qg4cPC2hEgtmY@yzhao56-desk.sh.intel.com>
 <5c9e52ab-d46a-c939-b48f-744b9875ce95@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5c9e52ab-d46a-c939-b48f-744b9875ce95@redhat.com>
X-ClientProxiedBy: SG2PR04CA0165.apcprd04.prod.outlook.com (2603:1096:4::27)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 624d5e18-2666-4ec2-a64b-08db9f83b1ff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bmuv+1YyLBsz7QgqwDh95eiz+/p2yyWVm4pul9423lJP6qsWJ8FkTY1E6JxxCxAfYFOX/zC7EELO7Z1Oly5HQWFyRGGwWq+NFTq597cQWWtEiPCAJ5IxxsWnjjywXiJTd7xwSFUJpz4RUWkZgkv37NsC7UJdnIhzpdzo6CzJWGnmKBnWlRPwjEeeZXSnRi+O1kHjKF+77FEUTLuarbEFnn+m5ZGBXElteU3P2K2OrV5PVhj4KF7QCw85lfTmGH0Z9ghiYJ+1VvMqmi4u/BpNiZy4tq07jAH/7ywrGkPdKMdHh3eDDD0FN04e63WjBy+uWMMLd7hJr/KimsfWdl0xKcbL4tXq9U39vs49AihZ/27+TgcgLyes7PoCZwODh13MTOYiMH5iogggFC0aN09s5U6RAcky+VVZDa5bHvqW6/vN361nXOH80YXY0ABZveoJN5L/lT7wGXDRQvPCqw15TDNnpQNnDp+USTTZcI2C6lPY8otBKfX2gXeVTL7Yto7zX0v3/v3EqybjLoSBRqRNnzs2h9oNDHe0naEAxS2q4VhzCCqgvx0FhR/HdwBXHW6h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199024)(1800799009)(186009)(86362001)(82960400001)(38100700002)(5660300002)(66556008)(478600001)(6506007)(66476007)(66946007)(53546011)(6666004)(6486002)(54906003)(6916009)(316002)(26005)(6512007)(4326008)(8676002)(8936002)(41300700001)(7416002)(3450700001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ZMz1p5oprpqCK46HOc3AoaS+Rfo2B9OeUs2LVICMsF+L2egxAJ5JOlAGKQV?=
 =?us-ascii?Q?j3YbivdUVgWFGd0FAMSOiMahitjoZRq9+rSbciH42WbvVbED6RJjjg2e2onC?=
 =?us-ascii?Q?ex7McNglIFyByrILbj3BtcGfkS0NJCdDqleT20x4SsJxzUWje/Jqg8NC20gM?=
 =?us-ascii?Q?zS23IT31FX6ssOC+1E3gF6sI0EO2WdexfP81Kp2Ea8sz6OXUne2z9yFR3kG+?=
 =?us-ascii?Q?TcqAwRJMe8VH8KYIhGnQs0xDuJ4sFjEPgb9u18yjocgupsM3CwIVKwrZS8yb?=
 =?us-ascii?Q?UjoDZYUINoKTkSo1rXb0wsW4iE8DVSXoZZ3I9ft2Ruk/YirYwXFClJlgiARa?=
 =?us-ascii?Q?fw8/PZEw6b4zN+W16WKRKMycVt22OMTnODLYD4nK2kWFGDgRFDnQPfI9D7D2?=
 =?us-ascii?Q?C5x5IjDqL4SwYRfOK06JDRcrJYRHFNcXjNAJhwDL9JUXpBbKtFL/12tXbWVX?=
 =?us-ascii?Q?Jebwk9ZXvdPD4PxtNI97dDzjnP+Dw8Si5YUzpNG4k5PbT/d4tjExHeexjCh1?=
 =?us-ascii?Q?2LR3GOLN6JN+a/bng8jOuoyAViobEavjC3jIBLcjZ505vuXM+bfjlpKn8VRs?=
 =?us-ascii?Q?5oFiJzQ8jKlic5lWHIyY3xvm8tNo1gLFva2scdjamP4xpB0Azs+EfUg6vcqQ?=
 =?us-ascii?Q?p7rp2HCMMe6sb3VvLjThG7rykOvTCvpurn35yPC8i7Wos7faH87w3MoU0bxp?=
 =?us-ascii?Q?UIaZXpHFlU81e5BBcs1Bx0C7+z72twVqMR0z/JmpU/3/mzjQ8nIpzUXqUa5O?=
 =?us-ascii?Q?pA1h8+fREVJEe4Fu21RfUMqXeG0qtP3slNwVA6HjvRTjG+ugTZdhVWCH7Zux?=
 =?us-ascii?Q?YcZ1GEB2GyTGEhM5wY03BXwBO0vN1mGYAf4+cURmP2SjZqSye7PTd1edwI4I?=
 =?us-ascii?Q?FuMPeYW3mTLBZOAMpbPJ8ge2vqTWM10IUUMEvebqF13wCPx8lyl9dU/XDjJS?=
 =?us-ascii?Q?khmV39/P1cQ2qbZii+yfQ/Qfxkk5d2WTI9NohbZTUu3uAcK2Fdt2Na+sJQcZ?=
 =?us-ascii?Q?O/7TRPRzUGVdL0IHWITO1t6hZD0Gghs6eR4Ztxb5R5zdq0ZR9QUuk++oYHM/?=
 =?us-ascii?Q?GVG6TxtE7tApngJFx6a1y0EUmp4SLo4qhQijohNtbuR2Eerc5p2PwearpC5K?=
 =?us-ascii?Q?dsvSss8/WTMJhcOOMUoO8Kir5qc9UiSf1fVvKv5ADuBLp4pVEFxp7UT6VUUB?=
 =?us-ascii?Q?sym8zNkC+y+KCh1Z5oh4h9yeprJMjcatDTmXZ+HkorK0CVqu3GK954Yr2DBq?=
 =?us-ascii?Q?Xh3rE6DVmT5zX4286rLOVhpLAj7mOZFL2EF23GgClq0XB2BFDD7Z+2Pa6h4Q?=
 =?us-ascii?Q?imb7CGt49hPmhDJv8GrEwon+iPqDCDYQ9Go0EAGk5B0N6GKKwS6K47Wv0Ht7?=
 =?us-ascii?Q?VSxcdD8Lf4CRXTdQvqXDbCDWu9F9n7njAi56sMnbE8clsCqEpL3n6qhfBuXU?=
 =?us-ascii?Q?plva2nfZpsaE7fuUcxZ9drbYj2TJHlXXThNfrA1EUicY7NuQLMYgw6zJgxou?=
 =?us-ascii?Q?oM4BPHhaKX8shUq60skxBKw7bPF5dVdL8q65gnF/AxwU5mW53W9H4GJyLE35?=
 =?us-ascii?Q?eJvqRZmY5ev4MGDzB+fCL+fT1Np59lz2ZXoJIWCr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 624d5e18-2666-4ec2-a64b-08db9f83b1ff
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2023 00:40:18.0639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HzH+HOAb87KU8qlz9LHEegv7oKbJ4CdicxJg2YTXOx2ym9zyQdb2QVJ5qeQLS5scTetj6MGmgBmwWqLzRtrpaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7611
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 17, 2023 at 09:38:37AM +0200, David Hildenbrand wrote:
> On 17.08.23 07:05, Yan Zhao wrote:
> > On Wed, Aug 16, 2023 at 11:00:36AM -0700, John Hubbard wrote:
> > > On 8/16/23 02:49, David Hildenbrand wrote:
> > > > But do 32bit architectures even care about NUMA hinting? If not, just
> > > > ignore them ...
> > > 
> > > Probably not!
> > > 
> > > ...
> > > > > So, do you mean that let kernel provide a per-VMA allow/disallow
> > > > > mechanism, and
> > > > > it's up to the user space to choose between per-VMA and complex way or
> > > > > global and simpler way?
> > > > 
> > > > QEMU could do either way. The question would be if a per-vma settings
> > > > makes sense for NUMA hinting.
> > > 
> > >  From our experience with compute on GPUs, a per-mm setting would suffice.
> > > No need to go all the way to VMA granularity.
> > > 
> > After an offline internal discussion, we think a per-mm setting is also
> > enough for device passthrough in VMs.
> > 
> > BTW, if we want a per-VMA flag, compared to VM_NO_NUMA_BALANCING, do you
> > think it's of any value to providing a flag like VM_MAYDMA?
> > Auto NUMA balancing or other components can decide how to use it by
> > themselves.
> 
> Short-lived DMA is not really the problem. The problem is long-term pinning.
> 
> There was a discussion about letting user space similarly hint that
> long-term pinning might/will happen.
> 
> Because when long-term pinning a page we have to make sure to migrate it off
> of ZONE_MOVABLE / MIGRATE_CMA.
> 
> But the kernel prefers to place pages there.
> 
> So with vfio in QEMU, we might preallocate memory for the guest and place it
> on ZONE_MOVABLE/MIGRATE_CMA, just so long-term pinning has to migrate all
> these fresh pages out of these areas again.
> 
> So letting the kernel know about that in this context might also help.
>
Thanks! Glad to know it :)
But consider for GPUs case as what John mentioned, since the memory is
not even pinned, maybe they still need flag VM_NO_NUMA_BALANCING ?
For VMs, we hint VM_NO_NUMA_BALANCING for passthrough devices supporting
IO page fault (so no need to pin), and VM_MAYLONGTERMDMA to avoid misplace
and migration.

Is that good?
Or do you think just a per-mm flag like MMF_NO_NUMA is good enough for
now?

