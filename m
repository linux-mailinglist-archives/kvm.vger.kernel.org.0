Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A18A36BCB7D
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 10:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjCPJws (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 05:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjCPJwq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 05:52:46 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA2376055;
        Thu, 16 Mar 2023 02:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678960348; x=1710496348;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=syLpTQDl8H23kWz02lHeTqn1WOZ/IfhWv6nbT44lSco=;
  b=fOz+LMKgBkmaqRB4HHTu+vyB5QLOM+c5rs5Owp5+v2EGOEd6c4kVB6Gx
   h/ZnShdUnox/Xti47I1OfzVGq3fZze/Q1u/CM5tOohVVjD+RtNq+odtNa
   4dAZiOYxlz6fwtsvsjSvK36lXdWtzB1TAopDYwOmOrF1B+OljDzhy9v9Y
   4Ba7bYXgdmD28cwnmb0rweH/AysRZ23CggmW71puOSJv91MoSo2JHHjvO
   596O5RlFA6BnavayFt4rQFQotQ5n83J8wsKurvZhsAwzVZNnJZSEmcFfn
   nxL2Jhb2BPJLEOUoKXEfqxgdJB5DLUM2fhnBg8abWmpCB1uJobD50WjOZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="317592041"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317592041"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 02:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="679843700"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="679843700"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 16 Mar 2023 02:52:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 02:52:26 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 02:52:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 02:52:25 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 02:52:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OcxfzV53ulhFdpbUKj2gZT9cpuI8GSGG5F14X73u3CiN37BJhyZBQOP/6jwJAPJoV8SIL/e0uLBIcFsCBC7cTjTcde8v+ZO1KnIzez68TsHQ9fdTODVvsd3Bi2QzDqbTif/8chH3MZ1CrfBOnNHCeVCC59Tos4hpKADxmQE8ITmaDLkoQ7VrujmXaQ1AKSnl6EflfvShvcJX+cZfoZ/tgy/LW/9vDsMZe86ogZhpaGKdQ2YLnMqCHSmfneXARQOxtCRNZx2tiDMwkbJoQhFHALSDQ9zmFna/x5jksxD7ucppmGvGxutCN4/pUc1WqXpgrkq4l8aVw5yJeA+o4DTKKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MWpg5BA2Hi1rcvyjJFmck8E9zWKVSMtBgyBOP9EHwfQ=;
 b=fbU3bz67x+XljVwwBT/wbUkGyzbCbNi96X+ZrHRxzoPCa2xR4wb+z09luLZn9z8N0DxYX7lrjhXsW2Q94edtD2LRdnG2veiPfaRbOe742fXqT7TRrwRGxV/SBcCktghp6ATPRdShzLbv5McCLQkZDU3s4tn/FQWYKPt6H801QlGUmYhCse/9Qo0YMXGsdS/VNmLgAV71+KZRavWLhc5LMkZ2JG11JYRAnwCl1FclSuTUvZkkrT0nkwMDJWwffhv++9KtckVg8UK3PWry9qZSU9bT1yKnwws/uT9Q7stlHHgJwiVRPhktZ/OXGMkd1r0qLa4SgbRhh3epk63+DpMi3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5674.namprd11.prod.outlook.com (2603:10b6:510:ec::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Thu, 16 Mar 2023 09:52:23 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::b00e:ac74:158e:1c7e%4]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 09:52:23 +0000
Date:   Thu, 16 Mar 2023 17:27:47 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        "Ben Gardon" <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        <intel-gvt-dev@lists.freedesktop.org>,
        Zhi Wang <zhi.a.wang@intel.com>
Subject: Re: [PATCH v2 14/27] KVM: x86: Reject memslot MOVE operations if
 KVMGT is attached
Message-ID: <ZBLhE3jyx/n54XQS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230311002258.852397-1-seanjc@google.com>
 <20230311002258.852397-15-seanjc@google.com>
 <ZBF72+flVlEbfg70@yzhao56-desk.sh.intel.com>
 <ZBHnugUe0SSmQKGI@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZBHnugUe0SSmQKGI@google.com>
X-ClientProxiedBy: SG2PR04CA0169.apcprd04.prod.outlook.com (2603:1096:4::31)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 78be38e3-28f9-4f12-3f9b-08db260423ee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K6YBGSbM7myzxKpsfvcjtPz3/LT/vQykk8yf3RQVmKzEwN3TiNd0TmWtTy2sRyzq8JeITJv4uwch6YFoF+Jpc+7T5bWU5m/5FPd9Gt751fKj/KuzVvXWyk7bqKbDpPnPAbWVnM99pMQn4lZcdOSNifiuT+Fun5JdGPmzDNldZCZBXT5SFzLJt9AXVHH0XRKZm5UaXEhLXbOZxAicD1g/PNI5INnw2TjWHBDh2UJ3NtX5l5dT3WZiCsFDnsNk4+XklZxVDydxTAUhR0n7RLGPsbH1BjTilCDH+J7A2w6Q8IfpPL4lN4WVx3EbPibaiNWfNvq5wfjcdtU2M/YuJ38IfhiIKQSs0I0fh5pkfrDiJw5n7PTG0483DyDUsv1W5VjnAMmOcNHqnDC8OxH+m591+UEOWRAIy9ae7k1hYLrGkOw1N9ZpC2J+lSsAUCbbWzU8UBPpCW2bQ7nQXBYx29NejL9m2B/4aNJq9SJuYdON/vSWB+lpQkX+sgxm4XSUmmTJX3ncudDiQGfD0CMnNNeEpoUwqZx1JqCW3d3TAZuMyw7aC4XDFXd1ypdZk4fR5jFcpnQno7e4jAbgqlCFLAUzdZk5644nX2SykohZSZzSd0zLFVE5EPOX4YexDiLb+Mm1Y5SxUQlC4hjF0cBX+H5wtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199018)(8936002)(4744005)(5660300002)(41300700001)(4326008)(6916009)(86362001)(2906002)(38100700002)(3450700001)(82960400001)(8676002)(6486002)(6666004)(186003)(478600001)(6512007)(6506007)(26005)(66946007)(66556008)(54906003)(66476007)(66899018)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cGVlTJ2E+SvN2yIhuMvGOFUXZbuIjNRkVVxZIoNfM+PHMrt9qbArk2eddxjG?=
 =?us-ascii?Q?0rs82rq2Ne6eZo/IB5Hd05vPxrcRUia7W5K89fEx4YlcSLjk/wWhoTHcMWml?=
 =?us-ascii?Q?lBYIMPWwAD0c/Eu/EvO3nsdOmbYnfy50tdmVjveBOpT6qv1N9qhPbWAg6fD7?=
 =?us-ascii?Q?Q8Ubq/eSq23j+m2ErmIMyTA17xBQciYxptk1VxiaYal7cKOXaehphm7Vk11L?=
 =?us-ascii?Q?hM3m9LbAtajZqEj36vBImow8iq2nLFVc2uaPe6xPFNZw0iPFZu5ZMRNLpVUL?=
 =?us-ascii?Q?2jURGmW32dtKQ8iiV4w0y0aV4ga0KuF40lKbwD+RrV/vpNoH6G/8zuKOG0+u?=
 =?us-ascii?Q?GeuwTbZwR2snuRkGAFwCCJm9q5slejMgBTWzAj84lD1Hgilp7juBSSEUaD6k?=
 =?us-ascii?Q?/7Zw4j1u3xIWO6pnqYrH7JGJz/veSHV4Tw8Datj7QbLnI8VfA7SYMX7nt0eu?=
 =?us-ascii?Q?9mzeRkNqzjocjq0/HY5jM3+LzPSCGBd0ofxLO1TCZy6V7NuO8W0G4umvXrur?=
 =?us-ascii?Q?aqXZib8onYj3NGrXDHtrO3g+7aUSR7nHnrlpu+RKhieYBf/PDSoMuVfsKJqC?=
 =?us-ascii?Q?JrFGlUVJz32RXSZGSvSL6sfoZe25j8BBMFR3kKiDiUqIWCDkOLDidBTYwmkD?=
 =?us-ascii?Q?YelSPVQ/Bm9vCeZhVua5yvkVMPEvLzy2X2s5UkqDszrM0zrZF3FhKbngaFH7?=
 =?us-ascii?Q?q+Mzu2kl2dBGQoUhy+gzAtGA0xG3x7FXbIzoqdLKKVfPsPGmzbOvk/M/jgPY?=
 =?us-ascii?Q?yK84ry3HZtWqqqyncw8+ohvVrxjWNY7Vq/d9r2c1EHEdNzR1mrXvMGBsEJqE?=
 =?us-ascii?Q?sG2AEX+q4ct3BYcyHesNgkujKfk4i88TNeQdXhRkaEAw8JojTR5m8L3qnNIf?=
 =?us-ascii?Q?YS8px6isdZHLuVzZSL+/fzKdLHcqz4hWUxoTn1lNbuYDa88PQXZ3GWcU+aJY?=
 =?us-ascii?Q?54i3EzDeuPc9AXO1fugGcZ5SWifcX8rktLItOQ1WSOPMVu9H/RhBVf2SOfxv?=
 =?us-ascii?Q?7dBWcKjtWAZRVvR8tNVr2EzSU7xNIDjoM6I5/QRPs8NBb4uUIT3n45sS4LPS?=
 =?us-ascii?Q?kGeI6E1s9TQEbZcBlXq6wJvmzN+Cl8wu93CCO8EwqXKfiqvS2OSKKEaEZApr?=
 =?us-ascii?Q?nrEFTjM45Mratpdcf7RCnBwJMTUDkfD5yNZB/byn8G/yWHhnp61vpg5NNCSO?=
 =?us-ascii?Q?W3yH8l7xIyLRDIj3ZSY52FYqptkNJU+uGOLU7KGKco4a2TNaRs+Oc0TaLrN/?=
 =?us-ascii?Q?+jz99rE0ybIaWv9imgUu/EVuWLjGDDaB4O4zrGTcOPpbUbIeqicR6pRe5JlN?=
 =?us-ascii?Q?613YFC1uIIyvsoLNdcYfO2K4M38lUJ5cs+eQiOBnvIDeDKwwwQA+v0T6ewTl?=
 =?us-ascii?Q?vgK9a04MYRiwYtDbWraVXiFPQC+Yc+0g01fBT5Ic0P6PtfuLv4/1GfXFHOrH?=
 =?us-ascii?Q?fmSFEOnlmjgy1lr7DILxcvzVAaLg6oKgVE3MzK+B1ja/scZ0VLMRO+lNocWq?=
 =?us-ascii?Q?QdW9QTWMigsoPMKLsoS568Ya+H/0bkNd3Jh8jBv2D8h7CE8MwoUNg2E3BGeX?=
 =?us-ascii?Q?fPB+vKsXdPihchbcqBewae4+ClGsUFegh8vjNRn0nhFi3c8S3wEG2cLFQSjc?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78be38e3-28f9-4f12-3f9b-08db260423ee
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 09:52:23.0111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 69Wig+UnqQlzZAr4bUOiTOMfrWRJRKe7Vd/1RYM349FdKYV3eucvcEp+t+YZaQB7bpjKlltXTJY64iCmLcgf3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5674
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 15, 2023 at 08:43:54AM -0700, Sean Christopherson wrote:
> > So, in theory, the new GFNs are not write tracked though the old ones are.
> > 
> > Is that acceptable for the internal page-track user?
> 
> It works because KVM zaps all SPTEs when a memslot is moved, i.e. the fact that
Oh, yes!
And KVM will not shadow SPTEs for a invalid memslot, so there's no
problem.
Thanks~

> KVM loses the write-tracking counts is benign.  I suspect no VMM actually does
> does KVM_MR_MOVE in conjunction with shadow paging, but the ongoing maintenance
> cost of supporting KVM_MR_MOVE is quite low at this point, so trying to rip it
> out isn't worth the pain of having to deal with potential ABI breakage.
> 
> Though in hindsight I wish I had tried disallowed moving memslots instead of
> fixing the various bugs a few years back. :-(
