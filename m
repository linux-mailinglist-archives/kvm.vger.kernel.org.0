Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE5B8744429
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 23:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232526AbjF3V6m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 17:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbjF3V6i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 17:58:38 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E657B423E;
        Fri, 30 Jun 2023 14:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688162304; x=1719698304;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=e8PgrsqpU+hyUU8bb7YBIUGZlliO1Qe0tD0HV9rtGZw=;
  b=f1WXfiU5LaJKEIf023l0+Grl4MtMWCmBkxevY2/WGw8yU2tK3eh5Q25x
   Fz8J41Um56N9EMDKzM1Bt5bx7GrkFjSxaPmesbBYObbvZbMFltj8HR0tu
   ZGP1kzNu5BWaJgAj+19Qft5w4FCveReNiXUJcjQc+WYow+Bjxx2jfOzx3
   0PxBfC1aQTqcCIRpaP8CwMCUliPdRZF01xgkN5+YRQBDKKzFEanl31QqC
   QNLWq4c76Y/UibXdC757I3jeB3v9I1Tmrf2BOjkdq1Qv5oUh7A8Pz3eMa
   Po8jOh9NiIBwpEDwmb4A9YP1iPr932mcipMgrEwLqCaC00qZUxZFFGA7u
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365079794"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="365079794"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 14:58:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="721107614"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="721107614"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 30 Jun 2023 14:58:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 14:58:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 14:58:13 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 14:58:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 14:58:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRR5uyaM2826YvcI2gVRxn/AxO3whEX9vC52jFwne3S/O0qtaSu97cV7d67kJYRHM5gRnkU1GxyFkbid6OY6HT2gw0hEoXiwz1e7q4cGhtwcw5NRKU81SvYB53aE2drjEoc20/RUFw85ir70mEczQoBtUmcT331TSvXWlgpqA3OsmdSHZ6uuXrqNCtp6yuBtTT51cdhdrWctZULZk+4fgjTHgkub5omnV6cYOfritWQ6HSh+p7mpIxxidxZqjw1v4yDVdgmxmg7Qm1GIximFfzPmgAcy/KbJOzWCvwVdBpevGD+zAXmDNxQa8qqQUYQBBLYM4vNeOKlQcrlsRG5Cbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MHHdTrHbWv7TqOq/DZT0hIpA2DqmbUVc0msZ1I4clA=;
 b=Z4ob1wbCzHWc44CXQzqF8M7/jTpiueuj/eCQlZaiF2eQo187m/PceRbt8MVn1iEO/mwaK8aW3A+E9FcAEd9pRLgUFIik7ia/NtZxQk+V2ZVwT7cnOSGT4YfEZiNc2XSP7VKM31//+igP8gJwjnmqy6ZXdiSclq+Q/V0B8PWrsSyZWKwWZwy/Mf6z1yluJGferd7mT/MUC3TVMRQ9s3HIgH2bYs8CxmStw9cfqqY5XWeKE2Jnd1Qnw++IQ/JhesKqvtBOgz6hBdDVGGgDrWsxJw5LlZnlV4jvG9WsQXGbxEtPXIZCiVpzWcqVJ/e2Och/JYGx5kLuf8FVF/xcp9nGJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH3PR11MB7913.namprd11.prod.outlook.com (2603:10b6:610:12e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.19; Fri, 30 Jun
 2023 21:58:06 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::aeb:12b5:6ac9:fab0]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::aeb:12b5:6ac9:fab0%7]) with mapi id 15.20.6500.029; Fri, 30 Jun 2023
 21:58:06 +0000
Date:   Fri, 30 Jun 2023 14:58:02 -0700
From:   Dan Williams <dan.j.williams@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
CC:     Peter Zijlstra <peterz@infradead.org>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Rafael J Wysocki" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <649f4fea74e89_11e685294b8@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZJ9IKALhz1Q6ogu1@google.com>
X-ClientProxiedBy: MW4PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:303:b6::6) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH3PR11MB7913:EE_
X-MS-Office365-Filtering-Correlation-Id: 61796764-de7d-4536-f7a7-08db79b51587
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D6DoqutRliZAQkjHLNInL0MK82Pq+o17mtUFuAR4yXTaBvqh5ZmGxln58szWLTL4KdZTuEUxJFtIF5Hc9Q4nioTHnUSLZe4DkLk1uP7YOcaYwAxGJ6L9TQF6NkgtTNTK7TVjInB6djrCEJcdZtp6qD66a5OpHwRqonsg9hcT39BVsjWm0EM+vgPgkuYtixrIzPJLcCtPbNS4uh0vrV/tr5ft4IX9IhNR6m4y5pZPQseSFZ2IGszl2NVMG0y4uyEn+Z/hffefSfT7JElqO8TrauedPexNDoSFwUakpQhhFE5trVRA++3LBKKVzDWe6oy0TTWW5zHuw7SYe/bClri1La6psnzg7HQbiz8KfKksXzFJW5OjaLTMjb+tKiT8xRpbpPhrV19nDZRrHF5/Cf/J6SIheCx20gG7PYgI4oqMiPeLKhqeA6XIYiMzCumzsYSZ779LyAVeOKIhQaJ7YOCyeBpRNOhZf00P9UxOc1ixqX97VYjSfHIfvzH26MAlch6fqJWufVHirL10SXAH0KKB55NgPzoUMyMP0yA1dOoX0Tw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(39860400002)(396003)(136003)(376002)(451199021)(83380400001)(2906002)(38100700002)(82960400001)(8936002)(8676002)(110136005)(5660300002)(86362001)(54906003)(966005)(6512007)(41300700001)(66556008)(66476007)(4326008)(6666004)(316002)(66946007)(6486002)(478600001)(186003)(9686003)(6506007)(7416002)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OIHh4Z7kjGjTBaMqGD7gyMl4MEzll3hhH0hIVFRMAe6Agvzbowq0bBFjou5G?=
 =?us-ascii?Q?6o3XsDzUsMMB2gMhG9cPvXkPz+Puh5Ge4iseuGhmepBU1sj6kROPHs8NMi0o?=
 =?us-ascii?Q?SxhuYWtoMg6DtcbusEvB1Egq1od/KxOXkAOi/NDWVBCN8plSg5SZK9tzYrNi?=
 =?us-ascii?Q?v9DjYTO3VLEe4sEnZFQsDQuQjv8sQBHAnGNEtBjuVnpcmOZNUA+BZYPtKmyr?=
 =?us-ascii?Q?iWk6muwcoqdkB8JE3TkOt0DC/lhhm08ojMXBPEvKF7lQq7dgJnc/BVbQMbyx?=
 =?us-ascii?Q?Z7lOHCQMBReaaG4uB93Qn0mCc5SaD4J7Vu4XOdqDqXDVFJWCzcdRNx6N9vmj?=
 =?us-ascii?Q?X5DPFq/46bV+T8IRFIE0Q5oopvYsaHYIODv3s4MF2daFQzNvfLKeNNznCCXN?=
 =?us-ascii?Q?Px3QwLoLxVBEMZlU5bskxAxewaBUobax3QeWr46piIXgDpyR5A1PAZJ9Ktjp?=
 =?us-ascii?Q?DGkbHBPkqttWKR7Fi2DjLF0sKB4EMOj+DHoelcpqRy4Yk09sQNw9nMpuP57y?=
 =?us-ascii?Q?E/G/JYeogcYmNjtgjHnqTRprdSnOJpDMGK/BFwpMt4cgSqlshNXA6r8Lk+/3?=
 =?us-ascii?Q?CZK334VzdknrvQefiWmOg++dlNvTigViCJtNG8rPYVql94dUlFlgQyJbUN1O?=
 =?us-ascii?Q?AMgvluPwTkXqOv0PEuWaC2+89e3VUx9JXujBtuR9dDnbemSrKN0IRthribmb?=
 =?us-ascii?Q?2wQg8evdl9BxhgoNbSu5SJiHkc1r45JjDQO3hiGfc7U6L9DR2RY9Ewa2q/w9?=
 =?us-ascii?Q?CauV6tcaHl/foZB63MUrTsbeSsOsm8Enraet18mot93te0c5lldAp86hiqLu?=
 =?us-ascii?Q?nkXsmoaODE7XWH978FSJohrruHmzBrhx6TftBSPWPS9YoyFWRnnJL3p7TS3T?=
 =?us-ascii?Q?2eeH28t/U7K9uYla55QmaHqDHLATAVK+oPtVaCL4r9vJ5QFdccF+Oxk1JC/Z?=
 =?us-ascii?Q?o0JqAMQ+HLu9+gRegdywQBe/sIFNGZ3Qp1r07r/eBtACfE2zAbhHghdmc+MK?=
 =?us-ascii?Q?dQru0gSOkiEkFT9Hikd4cx9ni2T7k4snTH7M3zL1ANhySuMAQ2Gsol3im0rg?=
 =?us-ascii?Q?tmLyCAgLG351vfyNvE3NaExq3VaJzlo6dAREdI3xGYV7zWaHL5mrESr5kSdx?=
 =?us-ascii?Q?8XzEeVyOn3MQBU4IWlN2HYu5D6pPYgLdC9hp9WN5C0D4ozybcYfXL5tzQgSv?=
 =?us-ascii?Q?YQyVwXIUee1XVTGxcu5NGRiX+TVeqWWibVJstV7WAG2r3pU0pf+wgmM/cS3I?=
 =?us-ascii?Q?nICelpqeRZ9+boA2ZXuSQxPJ/GNnXO5HzCjfi4UPlRRqWOzt1jhz/jPTfLjJ?=
 =?us-ascii?Q?TZSxoJhMKP4/nBwQ6uoUK+6U5rgp/suzoArL6AWnq2P6jEzsx1z/a/8iDqwf?=
 =?us-ascii?Q?yHnGmA96PEM6zugllqudKDWA941ohYkeDV8++N2gl2c96//uY8WUO6hiY6qs?=
 =?us-ascii?Q?cxhXn8XZqPuq/7zqKXoc+gQ0UgVG9ZMxBwm4QZh/fCJgbxGa4jydNrX+gOiH?=
 =?us-ascii?Q?wjGtAovxJSA15wcUo8HXcnnGWN6XkPWLmprCT/uCm0IB6lN4ThSwNudgpkfP?=
 =?us-ascii?Q?LrF4OSTgJ0cghWXDMpswG0i0dt2hR0U/AJTBZKewqYv1gzmEm1NcLXiMYzeE?=
 =?us-ascii?Q?Rw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61796764-de7d-4536-f7a7-08db79b51587
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2023 21:58:06.2544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T+WGci5A7Zg/UPLnNdLoUO+wURIFuBD1Obk+jCKnKRyP970fMbwZT9hXlXm/H6Zh0qlLv9jyC8HeAJuWls7cZ1Fle+n7RCKg/okOb9tL4fQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7913
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Isaku Yamahata wrote:
> > On Fri, Jun 30, 2023 at 08:30:20PM +0200,
> > Peter Zijlstra <peterz@infradead.org> wrote:
[..]
> On the flip side, limited hardware availability (unless Intel has changed its
> tune) and the amount of enabling that's required in BIOS and whatnot makes it
> highly unlikely that random Linux users are going to unknowingly boot with TDX
> enabled.
> 
> That said, if this is a sticking point, let's just make enable_tdx off by default,
> i.e. force userspace to opt-in.  Deployments that *know* they may want to schedule
> TDX VMs on the host can simply force the module param.  And for everyone else,
> since KVM is typically configured as a module by distros, KVM can be unloaded and
> reload if the user realizes they want TDX well after the system is up and running.

Another potential option that also avoids the concern that module
parameters are unwieldy [1] is to have kvm_intel have a soft-dependency
on something like a kvm_intel_tdx module. That affords both a BIOS *and*
userspace policy opt-out where kvm_intel.ko can check that
kvm_intel_tdx.ko is present at init time, or proceed with tdx disabled.

[1]: http://lore.kernel.org/r/Y7z99mf1M5edxV4A@kroah.com
