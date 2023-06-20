Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B89B673649D
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 09:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjFTHdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 03:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjFTHc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 03:32:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7166611D
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 00:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687246376; x=1718782376;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rwbrw0Soz74P6/lLtRcFpI+3KCuozd8ZeGXOWP74Im4=;
  b=BFXa/9pk8UyCoBzpV8VyMkc/yh93ijta/dWCBCHYvatIXtO0tvlSQgJz
   fovAZC6SzVjB6cE8v8ALtXqP5enewMTOEPh2hVewiGplYk45BkhLtouJe
   w7ggBbPXcMQq/hUMhZbY/ARCc/Ca8S7h4lWiWYF705BsZPAN6b5TnZ5jc
   tCrFMj2Z3pz2/r1QWEE4xBFdxLnfq6UTi/TRP1dyjX+IEOWSZMWI6mBEQ
   9dia/KG5PP6DCL8XruuskXZl6eI48hq6YN46coeSil0lB+QFOgNkxPPV8
   kZTAn8kKdXQ6uo43PSgPQDNQkKohBzWPyCKQWMCicwLm6EOZL9mrG4oiq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="358659534"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="358659534"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2023 00:32:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="858475237"
X-IronPort-AV: E=Sophos;i="6.00,256,1681196400"; 
   d="scan'208";a="858475237"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 20 Jun 2023 00:32:50 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 00:32:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 20 Jun 2023 00:32:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 20 Jun 2023 00:32:49 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 20 Jun 2023 00:32:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PfxX6Pke0kFFUvH17p2kVEUjAod3IhDNBlUaT0IPZBBs3HkvFt5C0KdvrRCnM2Ftuxq3GkD4llHWT1GN4Cv0DpFMkOpk7R/4H1Z1vGvOaEWo6k2JOtmms1k/BKPe4RAGNVyy9pHBrW7A33E8RJw1w+AqFI7psbMvog1eE5kPUQyinfRwg0ktGd7sQXxfV7LvF9kJ0WiAXz0hDeltZGrosnl43Lk/F7Z1fuCuY9q+3Z4xqwmTMWK44qpGZ71Tx/OCf2awXi3uRQLnYzaRQLP0DFmxMz42Bqtb70FitepEMFe0WU0vutAo/2kg4Rl1hCvvBBso0EvNSPxa9hv+0P1sOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1oqzeqV/0vJWLI21w/SbMtFpl/ik/FCTYx2vkLaWxT0=;
 b=G/c6H3i2TWzsqY3LZtmgXuEbeHi+lyBlZHLkCDKY8UaowMogmL/oiFOVxoN5MNndYTix+I0QM6pbiSKm5LEdzTjxRx8h4VtDJNIKlIk3kZG4vCGKIr459OixRHHb3CtFi/jso/snIcmULgs5/vKWeiPwLAksFDFEb574g2pQYONTlgMsEsMqWpO7zhjXblWVq2sxg0rA5QnWYKTXuiX2zUd1hB7XfLqPVUa7IpYuaD450i5SHf7QDO3UiqcHAccZQah30QD8pNBqInxUvtBKfnwRfb5rp98SyaOX+RuzvexNXX7oGfiYgVTLf1jv3vnMr/uGaV+l6TIekFPGgVSKmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17)
 by CH0PR11MB5268.namprd11.prod.outlook.com (2603:10b6:610:e3::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Tue, 20 Jun
 2023 07:32:41 +0000
Received: from SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a86d:e44f:380f:86c6]) by SA1PR11MB5923.namprd11.prod.outlook.com
 ([fe80::a86d:e44f:380f:86c6%5]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 07:32:40 +0000
Date:   Tue, 20 Jun 2023 15:46:21 +0000
From:   Jason Chen CJ <jason.cj.chen@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Dmytro Maluka <dmy@semihalf.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "android-kvm@google.com" <android-kvm@google.com>,
        Dmitry Torokhov <dtor@chromium.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Keir Fraser <keirf@google.com>
Subject: Re: [RFC PATCH part-5 00/22] VMX emulation
Message-ID: <ZJHJzU607QOYeRM3@jiechen-ubuntu-dev>
References: <20230312180303.1778492-1-jason.cj.chen@intel.com>
 <ZA9WM3xA6Qu5Q43K@google.com>
 <ZBCg6Ql1/hdclfDd@jiechen-ubuntu-dev>
 <75a6b0b3-156b-9648-582b-27a9aaf92ef1@semihalf.com>
 <SA1PR11MB59230DB019B11C89C334F8F2BF51A@SA1PR11MB5923.namprd11.prod.outlook.com>
 <309da807-2fdb-69ea-3b1b-ff36fc1d67ec@semihalf.com>
 <ZIjInENnK5/L/Jsd@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIjInENnK5/L/Jsd@google.com>
X-ClientProxiedBy: SG2PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:3:17::20) To SA1PR11MB5923.namprd11.prod.outlook.com
 (2603:10b6:806:23a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB5923:EE_|CH0PR11MB5268:EE_
X-MS-Office365-Filtering-Correlation-Id: 6305f035-6d8c-4264-e766-08db71608756
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PYbu1Ln5bTcgt00TUL3pI03b+HMSvi0Kh6b+AfkG9AJp7ldBCbF2+14JjI7r5f5+lbOs2eWnjgNVYnZsIDBZ7opcxgZQQXn2Uhaq2MF3Yow7H3bfDIziGD+4uiGg/EgqCKPh/+vUetdqQceGLWTupkCpMGQD3oPltx95Xa3emPUcF5qu+9hSoehyJ85w1Irrw8WBk+sE5Uk6jnImZ2H6itKgQUz63nctM7lUC9HEb/HP7U5HiB2Ad3J3G7QiWf0T+3v2ubhhG5+vlhuJKe6TITiL0Q/DmGUXqwqLd+8Ch6d2RY0qkdH2p5LXSL1jC80apgtqfNkTwdAOh7GxesF0hNma5lcQ4eDmX7BJMcsjq35KptqGRtN1aMlp9mBNsEX75bAP+KQsK+y6Rx6wwP5FaBAYBYF5PVqyGWZRyJR3/3/WPYHbP2K3XZwDpCuu5c63KjaUqVEJFf+1Bkba4En2SnBD1Fa9mNtilcvMXupaRwOI9v8dNJNleI/KuHdQUqyrxjXFPrOkxm4mgjnegaAQpEo0+EHbMenaBRI9mPKFU7lCvutWC+kBDoOOCwMcHugT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5923.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199021)(4326008)(316002)(6916009)(66946007)(66476007)(66556008)(53546011)(86362001)(33716001)(2906002)(83380400001)(8676002)(8936002)(5660300002)(82960400001)(38100700002)(186003)(26005)(9686003)(6512007)(6506007)(41300700001)(6486002)(6666004)(54906003)(478600001)(66899021);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+sbx9RgrLB3j6kaZkqzMfc0ZO4KEVnVejgE0qrjHPT9Stzb/3C4tauuRd6pB?=
 =?us-ascii?Q?FWg7bQ4/mT+/qJ+Pq/zysstgYbNB8NfIu4jyR445KTYzDY/isSiX6Oi2cYuu?=
 =?us-ascii?Q?JE4ieOhK/Na0ILji+HMXky3KgH1fb1IRwW/8KwXrUkgbQWTaSUMjhrkjz0u6?=
 =?us-ascii?Q?LSQZJ+7EkpVPwl1gG7nYASW0tXwrj1/3B7ZFTV1Yx5whSAWvqxdHxP8CiYGF?=
 =?us-ascii?Q?CivQ/W8LNhTLYfDVTyQ81tF3VeMsu4vywgc6Fk+1aJN2gg8KGfGNaPmE4WjX?=
 =?us-ascii?Q?WyGvjwz1N7qUAB6uEx2gXjHJAbeA3xSb+VaDs8ybgWncyV3m817MXhTx1PjX?=
 =?us-ascii?Q?QN3M1eEN1wes/lcbR/q7X6PZ0D1zPjMPeijMSADgP1gS2Ft/wOYlcs8V9xUL?=
 =?us-ascii?Q?Ih3g2Z3x280bV96xSGgmt9e50pU0d6EpHUnLImiWcedjNIs3Ry8QOL6mhtuF?=
 =?us-ascii?Q?H1YFYkFoNPaDnm3WGyIq6kxLcJfzhdkhSk0EDIvkcPGT+NEascEP/z14q2ov?=
 =?us-ascii?Q?ZY6WkqXf8zOavN/Na+2GAL+xbh886QkoPPPRhPx4OJ/Lj9EWp+u0GVW5zLNR?=
 =?us-ascii?Q?fNSRMomOfmnMu39t6I8BI8cwnP6Oo6GZ9D/z0cyJrx6RuZL0FGRWMwaBrm2x?=
 =?us-ascii?Q?wDbS7dt4YfxacUZo9J0ExUPP0Sii2SETPJD20gXixqCPaKmxXOTj15xDLJgc?=
 =?us-ascii?Q?oQcWhmcJQp0mrP4MbdbC+arGDBT8Vp6jCfWG3rxMbBqlosFGIemlmW+YYQ0K?=
 =?us-ascii?Q?+XtUKdvhLCVSRob4MTdjqa7OhPycPkQmFJhJjTczx/G3GKWHLwCuL2HXeTsi?=
 =?us-ascii?Q?ooMhQSKSdpTPrCr3SdY5fxchTPHTxxMigegiVkLH54mY0wmqoIH/ddD1/2Q8?=
 =?us-ascii?Q?5Wt99ngl90tN7W4b7NzMFstR2I9BeShHQ8isQ1Ziep4EgbW9b4aPbKAFXx0y?=
 =?us-ascii?Q?IkbTd5yx6I0GDHCneelO+S28sKpI2AAzwTFKaEKd0zm6BmcsRp01ljroHpBz?=
 =?us-ascii?Q?1t6gDJuBealEDwdlzX1aiuQHehp//pqSvvOJoKKbbiOJkPJ12/NG6qCOnYuG?=
 =?us-ascii?Q?e3q5cZEfZgrBAapLg0aUm4BuEy9QR4PCIumhPsQjyIBBZnmVHRjstr21w+0J?=
 =?us-ascii?Q?o+sLbIVv+IEvJc4OHuXBbrnyD++PiPL+KuWdeeT5avNJXhadCnhLfJR764K2?=
 =?us-ascii?Q?tLcIaGAGRp3PDUYugPJywKd0AAT0p/4JeEi4coP6UZDcUJewYs4QbzJTuJYZ?=
 =?us-ascii?Q?D0hBLcKkX7MEyVMfkBgVtPZtE6jqhW0/qmsDEm/PANJOkAuV7kGX0TD+zD2v?=
 =?us-ascii?Q?z+9KMGmjgtPu7oq+aVD20KA8fVaAtRIsP2fqIkYTwuhmEMpq9F7N/9QFI22I?=
 =?us-ascii?Q?w1DpYvnFsSbq4phjF5hbDc1ioTXSWi+8sEO7l04l5Wk1Kmq8lzhNTlcdyGG4?=
 =?us-ascii?Q?URenWBxO2dRfzS6YSX0v49wCWtgq+pf1OkpLxAizEDYp7c2bhr4XLZy3lNWa?=
 =?us-ascii?Q?r6o2CSsIt7MWh4Q29uHdt36ABHIGlEfqWuzN4e3D9NgpkQZnxG2EKzOHU3sZ?=
 =?us-ascii?Q?1fV6BCK2av2wPPi8DJUyNdjTdVHvxqZ6Af621Bdx6yQgVlGUBNQnagE/at+2?=
 =?us-ascii?Q?ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6305f035-6d8c-4264-e766-08db71608756
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5923.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2023 07:32:40.6722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rzd6LXTYfMoVy9GQaBFKCTYfI4Fvuzh4p3Is99060p12qDxG8z/CxmOf2dCu6MQ91yW9kQ9rR6mKnggSmXWkSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5268
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_06_12,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 12:50:52PM -0700, Sean Christopherson wrote:
> On Fri, Jun 09, 2023, Dmytro Maluka wrote:
> > On 6/9/23 04:07, Chen, Jason CJ wrote:
> > > I think with PV design, we can benefit from skip shadowing. For example, a TLB flush
> > > could be done in hypervisor directly, while shadowing EPT need emulate it by destroy
> > > shadow EPT page table entries then do next shadowing upon ept violation.
> 
> This is a bit misleading.  KVM has an effective TLB for nested TDP only for 4KiB
> pages; larger shadow pages are never allowed to go out-of-sync, i.e. KVM doesn't
> wait until L1 does a TLB flush to update SPTEs.  KVM does "unload" roots, e.g. to
> emulate INVEPT, but that usually just ends up being an extra slow TLB flush in L0,
> because nested TDP SPTEs rarely go unsync in practice.  The patterns for hypervisors
> managing VM memory don't typically trigger the types of PTE modifications that
> result in unsync SPTEs.
> 
> I actually have a (very tiny) patch sitting around somwhere to disable unsync support
> when TDP is enabled.  There is a very, very thoeretical bug where KVM might fail
> to honor when a guest TDP PTE change is architecturally supposed to be visible,
> and the simplest fix (by far) is to disable unsync support.  Disabling TDP+unsync
> is a viable fix because unsync support is almost never used for nested TDP.  Legacy
> shadow paging on the other hand *significantly* benefits from unsync support, e.g.
> when the guest is managing CoW mappings. I haven't gotten around to posting the
> patch to disable unsync on TDP purely because the flaw is almost comically theoretical.
> 
> Anyways, the point is that the TLB flushing side of nested TDP isn't all that
> interesting.

Agree. Thanks to point it out! I was thinking based on comparing to
current RFC pkvm on x86 solution. :-(

To me, the KVM page table shadowing mechanism (e.g., unsync & sync page)
is too heavy & complicated, if we have KPOP solution, IIUC, we may be 
able to totally remove all shadowing stuff, right? :-)

BTW, KPOP may bring questions to support access tracking & page
dirty loging which may need extend more PV interfaces. MMIO fault
could be another issue if we want to keep optimization based on EPT
MISCONFIG for IA platform.

> 
> > Yeah indeed, good point.
> > 
> > Is my understanding correct: TLB flush is still gonna be requested by
> > the host VM via a hypercall, but the benefit is that the hypervisor
> > merely needs to do INVEPT?
> 
> Maybe?  A paravirt paging scheme could do whatever it wanted.  The APIs could be
> designed in such a way that L1 never needs to explicitly request a TLB flush,
> e.g. if the contract is that changes must always become immediately visible to L2.
> 
> And TLB flushing is but one small aspect of page table shadowing.  With PV paging,
> L1 wouldn't need to manage hardware-defined page tables, i.e. could use any arbitrary
> data type.  E.g. KVM as L1 could use an XArray to track L2 mappings.  And L0 in
> turn wouldn't need to have vendor specific code, i.e. pKVM on x86 (potentially
> *all* architectures) could have a single nested paging scheme for both Intel and
> AMD, as opposed to needing code to deal with the differences between EPT and NPT.
> 
> A few months back, I mentally worked through the flows[*] (I forget why I was
> thinking about PV paging), and I'm pretty sure that adapting x86's TDP MMU to
> support PV paging would be easy-ish, e.g. kvm_tdp_mmu_map() would become an
> XArray insertion (to track the L2 mapping) + hypercall (to inform L1 of the new
> mapping).
> 
> [*] I even though of a catchy name, KVM Paravirt Only Paging, a.k.a. KPOP ;-)

-- 

Thanks
Jason CJ Chen
