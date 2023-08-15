Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90B877C5CE
	for <lists+kvm@lfdr.de>; Tue, 15 Aug 2023 04:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234184AbjHOCWQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 22:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbjHOCVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 22:21:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B1C173F;
        Mon, 14 Aug 2023 19:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692066108; x=1723602108;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=nC0zImcMj6A18czSPBep1fxkrsQzEfI5tzjBiawlFsE=;
  b=gQC18SIo/r+IoZL5+IXcc7sfIuhY/0hsfn2OlmrRJNVEtJ1CPFEYO8ET
   K0gCW9H5eFHDxhhrdTpF21CuWHe9xXYm3IkiLNUa8WwCyIFlR1wjDP1Y9
   Vq450yuOTlixu2NpilrLc4xjQKl5wUoMM5ClFXWHEI4VjuhTtBH3SwRB3
   gdj30TLUyMMT+bp3Yz2C00kjQ49t5p/7yxj7sqga90GAib8hw8pvTQIc6
   xo7N8agqzvS02PXVxW3vfBugn1tqHhE6vkyPWapq4WI+4AFhNKgdHZDNV
   D7jP0XV+W/DZ6QqxsOOeQhlZESqnnn51tLS/C7NK8UDEnDR9/h1DkKJjc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="369656230"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="369656230"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2023 19:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10802"; a="847876786"
X-IronPort-AV: E=Sophos;i="6.01,173,1684825200"; 
   d="scan'208";a="847876786"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 14 Aug 2023 19:21:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 19:21:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 14 Aug 2023 19:21:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 14 Aug 2023 19:21:46 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 14 Aug 2023 19:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dBdUDSjzt8qqQ301mFuoDO1c2NQduSxtSfagwv1JUcw7OzBKayeV0H3ukJbNaveGMM+UW/1llM+ZUzcyydnYFyesezNJWqIv8QlpVpeHxm3xMrxV8KBa/g/Rn9ykfn4SUiS/7ZCxRAu3U/Tkpe0a0HMVx6atw7/VMUX0Xo7mZcbsC/o3WWQJ6DzvusE6vdKXS+JXa6nRunudfB9iwn9KgW/83TjlGT23ZXWUkNDYSjZvxlPq0QZ/zxzIxykshmk8RGvSh/KQgPq683Kb/fHMzMY3POLrbluibyorKH8PEa1llUq63DtcezlaOGq3Cj4+WDxQ0o8NfBvoD8+KW7oRIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k5uPTHZ3Y4gQ6tfMCgiF0wcRtpGpu7YrtGImTqYpRVg=;
 b=Gp09upTw9XbThWjHU95dIV4dp7VV4sdGsVQpxGxpLrlj7sG24sYK6zD0nYSk8m6mKcQ4PB0ZrNUbWaiWX6K3X4DKgF/l68Fhq8MqVGvfZFD6pNGXmsr9rJwGp9F+hbbQ8SulGCpx9Qst5cQvHH5e+zNGqpnBqHmqnMZ/40fM2L9EIUuaffj3neB/YekjVq9rDU91bwu1T0wgYGmg5Zd0vMyhV90oYAIjDsV+ZsPZLpSWYhgZB4iYD06QkVbBUwlz/FoC/yA3eONAwZK84sNV4/c6kla41PEfw/BEJ2+nTJYRuO2yxSoISvyfDKkVdJPcxaDyQ5KTqTFZqHvX7Iy8Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6864.namprd11.prod.outlook.com (2603:10b6:303:21b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.26; Tue, 15 Aug
 2023 02:21:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::1b1a:af8e:7514:6f63%2]) with mapi id 15.20.6652.029; Tue, 15 Aug 2023
 02:21:38 +0000
Date:   Tue, 15 Aug 2023 09:54:37 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     bibo mao <maobibo@loongson.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, <mike.kravetz@oracle.com>,
        <apopple@nvidia.com>, <jgg@nvidia.com>, <rppt@kernel.org>,
        <akpm@linux-foundation.org>, <kevin.tian@intel.com>,
        <david@redhat.com>
Subject: Re: [RFC PATCH v2 5/5] KVM: Unmap pages only when it's indeed
 protected for NUMA migration
Message-ID: <ZNra3eDNTaKVc7MT@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
 <20230810090218.26244-1-yan.y.zhao@intel.com>
 <277ee023-dc94-6c23-20b2-7deba641f1b1@loongson.cn>
 <ZNWu2YCxy2FQBl4z@yzhao56-desk.sh.intel.com>
 <e7032573-9717-b1b9-7335-cbb0da12cd2a@loongson.cn>
 <ZNXq9M/WqjEkfi3x@yzhao56-desk.sh.intel.com>
 <ZNZshVZI5bRq4mZQ@google.com>
 <ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com>
 <ZNpZDH9//vk8Rqvo@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZNpZDH9//vk8Rqvo@google.com>
X-ClientProxiedBy: SI2P153CA0015.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6864:EE_
X-MS-Office365-Filtering-Correlation-Id: 525bf631-b4c1-4c42-32ec-08db9d365ae5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: baVELJPkJOIZZobnwd8puZLjy0V2eO7TIKcZvPZdaCOlqguf3PKspJmdlIJMWNIOHzLTtyaOMK6UTPuGInj/OACuBm5P3CUQPHZDHrPv/WuKYiw72y98+e03aD89n8SldDnedcf9s5GQeTI5VweY+TU4dcoIU9fr6Nvpwu9k6QAaEJzXbn7IHcneGXvPfBR8eYW0g0loaRbRhPWjVRmArdKQA9qrfp0viG6ei6Yept/DYhLwCnsgVT5NeRv9c6jQYUCdl7KdkBraYv4LPmc9xtiuhnPG80+Chjk0WzPALcpq9rwc4gNgfKazPXnT0RQfVTXy5qYQ1weNt00wQ/qxpkFe3aAPc+PMXb7DO43LZaXAMTZDaYFYnTiOGu8WENWzNn634amelEEwK6n8Y2ODehXoMZ7oeaduniGZWH0CfYC+nZsoSt84eDgfH0H5J2Bzd1p7TZ+d6piE804fiEY1YfqBbp2TbjLjBy0xJ48wjV6PD2Dp6TwKl3tPh1P7Ne/IE5D4efehS/VUTH7F5zfnK/UouFFkYNWhbtc3bCTArnQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199021)(1800799006)(186006)(38100700002)(6486002)(478600001)(82960400001)(7416002)(2906002)(5660300002)(3450700001)(86362001)(4326008)(6916009)(66476007)(66556008)(66946007)(41300700001)(8936002)(8676002)(316002)(6506007)(53546011)(26005)(83380400001)(6512007)(966005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5HEhopEawgZ6Hp/1SUVGacib4ectpgOVBKqMznv+1+kLQcbziKlnr1K7SQDT?=
 =?us-ascii?Q?4/YhqdR0ror1AVbRkIj1+Fwxpfj0imw8bqjXGpuz6Q9E5UwbZv60b6i3nogl?=
 =?us-ascii?Q?+JrRmaNp8R0zJ2j/1tgE7a58+6ViG3xmWD8fItKz/PFsQK3E2lgRRKD1s4AQ?=
 =?us-ascii?Q?5w94TDnAER6mKQxO/DyZzJbMkVz+WYHwWHYTr0vSTOvmRePCDjUikHXz2BvU?=
 =?us-ascii?Q?Nca6fAVSxuLAyJTSHywf6Rm4pJG7/fpYcjdojze7W+RDRYTQtqPwJXuxX3+W?=
 =?us-ascii?Q?YMzLbJcFKJQzXEZMK/NoAqCnBSZzmCo1A4BfFNesMCQxGAE/VDYCvc1WQfSU?=
 =?us-ascii?Q?qNUyiuA3hO1QALYiGCU9Hf8vzBHKrjwKBfkl3ZKehFy9ngFwnW5KA6vMOZb9?=
 =?us-ascii?Q?jU+CKw3BEgAl1wWN/oLeX8S0Nyc/X6dt6nA8JTv0ZM41IxXm3gXAU+VjRKyd?=
 =?us-ascii?Q?lV1/QQCnWb9odKmNrpCOkzrG+P+JGR27deAxWgjRQ4+swH94aVqZuct2PXK1?=
 =?us-ascii?Q?TuWvjj0vh/e2tBmx8I7z6gzwfjfXpMiF9SGSfy8HOczwe3oFzZ6GV9owSKT6?=
 =?us-ascii?Q?jiUyp+6u6qmpRkd9A71/TcriSnY/WGF3zGPUGdyOxYhnmPdmviB6Z4l1LGwG?=
 =?us-ascii?Q?dKOkjV90VnQKCkjj2+5sSQpUVjCvE+0Q42XHwqMnt/+ojyPcNdFceItjhi6d?=
 =?us-ascii?Q?CzQ64WjJAEiRinK2TTiplJM/fa+pzwIneqhbxRfghm1qLHWC5+i558L1x5ww?=
 =?us-ascii?Q?ff6dW/K+tuO2hVX5DVL2i3DgK0jWShS0c1scqTL7xz5PPdDIK5F7YI4UukIL?=
 =?us-ascii?Q?OjIoGPQmI/AFvMFOSKnpgFUOWJcGfrigCnZJmaULWN2HH4nFM+vhjLCp9/Sx?=
 =?us-ascii?Q?mUfqtgwtU2hX7moFFQhSzwuJuwayz3RNNrm2PGF0ndr4P7Y0RiVxgPQ1FcVD?=
 =?us-ascii?Q?74y7Gr9w7XLp6z3MiJ2vVvD9prz0ai6qUcsfzEkGbTB/PMqL9M1xm9tgkfOi?=
 =?us-ascii?Q?plVA8hKOMwCLYZaR1Rh09JDVDQLN18mkvlF0kl5FhjZ04J8ZFyuCFoW2CMWu?=
 =?us-ascii?Q?B30o++MTJt0hw15O++7DWvt/SdvX4gvHOjADaFiF7ZkESAyTNDrOHu7y1eVT?=
 =?us-ascii?Q?IN89Aqy1XVjGxG3kQb6Np0CldWMJ9qDpdG8RtOy4ILZm7prRnJBsbmUNSnHB?=
 =?us-ascii?Q?FdcWR/zjqLh+pP1DXlDTElS9zWPNsCiyquun9xvwZwRudYYGM072Xb8u0do4?=
 =?us-ascii?Q?ouylwZ6ZwzIP7D+EuKeYbQrqHlf9kEPUuLxBecW+9oe2ZMLMS4ZlPg/xAd0o?=
 =?us-ascii?Q?+JBTnXCLCm5mpaJ1HmIpZSjPfqRMPXQO5B3vnCExu9j7nOC9jUrvNc25SEdm?=
 =?us-ascii?Q?O6USLNR2/+4ux+gDOZNKJ4KLhXYaf2xx2ru0Ibk0Y5/52LGKtgjswthSOtvr?=
 =?us-ascii?Q?wp7vn307HxTLhr4mut6iECaXdAI3XSDWhQ+IBZW9uCkOSChF4LWcbz8yKFux?=
 =?us-ascii?Q?Jui/qky6hb/bkLODjGSmNAQ89oBX5Gqt7TffGVBlCTmJbuaTu+wBdsftezfr?=
 =?us-ascii?Q?VsCKY6k+k+CpPVWiqDOEo2yqL2BZsHj6Ttd7U8g5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 525bf631-b4c1-4c42-32ec-08db9d365ae5
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2023 02:21:38.5785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SNHBFDN83d3PbGfsyNMIj8LRS5AUq6GpdHFQsoPSTp5/k2HmrxSW4gNR0fm7j9WNYNaHlr4m6/0yJnkKAwRk9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6864
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 14, 2023 at 09:40:44AM -0700, Sean Christopherson wrote:
> > > I'm strongly opposed to adding MMU_NOTIFIER_RANGE_NUMA.  It's too much of a one-off,
> > > and losing the batching of invalidations makes me nervous.  As Bibo points out,
> > > the behavior will vary based on the workload, VM configuration, etc.
> > > 
> > > There's also a *very* subtle change, in that the notification will be sent while
> > > holding the PMD/PTE lock.  Taking KVM's mmu_lock under that is *probably* ok, but
> > > I'm not exactly 100% confident on that.  And the only reason there isn't a more
> > MMU lock is a rwlock, which is a variant of spinlock.
> > So, I think taking it within PMD/PTE lock is ok.
> > Actually we have already done that during the .change_pte() notification, where
> > 
> > kvm_mmu_notifier_change_pte() takes KVM mmu_lock for write,
> > while PTE lock is held while sending set_pte_at_notify() --> .change_pte() handlers
> 
> .change_pte() gets away with running under PMD/PTE lock because (a) it's not allowed
> to fail and (b) KVM is the only secondary MMU that hooks .change_pte() and KVM
> doesn't use a sleepable lock.
.numa_protect() in patch 4 is also sent when it's not allowed to
fail and there's no sleepable lock in KVM's handler :)


> As Jason pointed out, mmu_notifier_invalidate_range_start_nonblock() can fail
> because some secondary MMUs use mutexes or r/w semaphores to handle mmu_notifier
> events.  For NUMA balancing, canceling the protection change might be ok, but for
> everything else, failure is not an option.  So unfortunately, my idea won't work
> as-is.
> 
> We might get away with deferring just the change_prot_numa() case, but I don't
> think that's worth the mess/complexity.
Yes, I also think deferring mmu_notifier_invalidate_range_start() is not working.
One possible approach is to send successful .numa_protect() in batch.
But I admit it will introduce complexity.

> 
> I would much rather tell userspace to disable migrate-on-fault for KVM guest
> mappings (mbind() should work?) for these types of setups, or to disable NUMA
> balancing entirely.  If the user really cares about performance of their VM(s),
> vCPUs should be affined to a single NUMA node (or core, or pinned 1:1), and if
> the VM spans multiple nodes, a virtual NUMA topology should be given to the guest.
> At that point, NUMA balancing is likely to do more harm than good.
> 
> > > obvious bug is because kvm_handle_hva_range() sets may_block to false, e.g. KVM
> > > won't yield if there's mmu_lock contention.
> > Yes, KVM won't yield and reschedule of KVM mmu_lock, so it's fine.
> > 
> > > However, *if* it's ok to invoke MMU notifiers while holding PMD/PTE locks, then
> > > I think we can achieve what you want without losing batching, and without changing
> > > secondary MMUs.
> > > 
> > > Rather than muck with the notification types and add a one-off for NUMA, just
> > > defer the notification until a present PMD/PTE is actually going to be modified.
> > > It's not the prettiest, but other than the locking, I don't think has any chance
> > > of regressing other workloads/configurations.
> > > 
> > > Note, I'm assuming secondary MMUs aren't allowed to map swap entries...
> > > 
> > > Compile tested only.
> > 
> > I don't find a matching end to each
> > mmu_notifier_invalidate_range_start_nonblock().
> 
> It pairs with existing call to mmu_notifier_invalidate_range_end() in change_pmd_range():
> 
> 	if (range.start)
> 		mmu_notifier_invalidate_range_end(&range);
No, It doesn't work for mmu_notifier_invalidate_range_start() sent in change_pte_range(),
if we only want the range to include pages successfully set to PROT_NONE.

> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 14 Aug 2023 08:59:12 -0700
> Subject: [PATCH] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
>  mapping is changing
> 
> Retry page faults without acquiring mmu_lock if the resolve hva is covered
> by an active invalidation.  Contending for mmu_lock is especially
> problematic on preemptible kernels as the invalidation task will yield the
> lock (see rwlock_needbreak()), delay the in-progress invalidation, and
> ultimately increase the latency of resolving the page fault.  And in the
> worst case scenario, yielding will be accompanied by a remote TLB flush,
> e.g. if the invalidation covers a large range of memory and vCPUs are
> accessing addresses that were already zapped.
> 
> Alternatively, the yielding issue could be mitigated by teaching KVM's MMU
> iterators to perform more work before yielding, but that wouldn't solve
> the lock contention and would negatively affect scenarios where a vCPU is
> trying to fault in an address that is NOT covered by the in-progress
> invalidation.
> 
> Reported-by: Yan Zhao <yan.y.zhao@intel.com>
> Closes: https://lore.kernel.org/all/ZNnPF4W26ZbAyGto@yzhao56-desk.sh.intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 3 +++
>  include/linux/kvm_host.h | 8 +++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 9e4cd8b4a202..f29718a16211 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4345,6 +4345,9 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (unlikely(!fault->slot))
>  		return kvm_handle_noslot_fault(vcpu, fault, access);
>  
> +	if (mmu_invalidate_retry_hva(vcpu->kvm, fault->mmu_seq, fault->hva))
> +		return RET_PF_RETRY;
> +
This can effectively reduce the remote flush IPIs a lot!
One Nit is that, maybe rmb() or READ_ONCE() is required for kvm->mmu_invalidate_range_start
and kvm->mmu_invalidate_range_end.
Otherwise, I'm somewhat worried about constant false positive and retry.


>  	return RET_PF_CONTINUE;
>  }
>  
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index cb86108c624d..f41d4fe61a06 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1960,7 +1960,6 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
>  					   unsigned long mmu_seq,
>  					   unsigned long hva)
>  {
> -	lockdep_assert_held(&kvm->mmu_lock);
>  	/*
>  	 * If mmu_invalidate_in_progress is non-zero, then the range maintained
>  	 * by kvm_mmu_notifier_invalidate_range_start contains all addresses
> @@ -1971,6 +1970,13 @@ static inline int mmu_invalidate_retry_hva(struct kvm *kvm,
>  	    hva >= kvm->mmu_invalidate_range_start &&
>  	    hva < kvm->mmu_invalidate_range_end)
>  		return 1;
> +
> +	/*
> +	 * Note the lack of a memory barrier!  The caller *must* hold mmu_lock
> +	 * to avoid false negatives and/or false positives (less concerning).
> +	 * Holding mmu_lock is not mandatory though, e.g. to allow pre-checking
> +	 * for an in-progress invalidation to avoiding contending mmu_lock.
> +	 */
>  	if (kvm->mmu_invalidate_seq != mmu_seq)
>  		return 1;
>  	return 0;
> 
> base-commit: 5bc7f472423f95a3f5c73b0b56c47e57d8833efc
> -- 
> 
