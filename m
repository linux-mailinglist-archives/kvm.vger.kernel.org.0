Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BCC5EBABF
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 08:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiI0Gc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 02:32:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiI0Gc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 02:32:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B7390835;
        Mon, 26 Sep 2022 23:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664260376; x=1695796376;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DImJJfBhMuloGCAgsnaJtOcDgfFIUtOrXf5oXFzHI00=;
  b=Gn0RFPRmswF/FlPrD/mbdRg4coP4taObXGqwiSpitayXt6S/SyOdoDU3
   cRLherqv0+D6k+DMBvpQFKrNqbouxLmWXXqHimaAFR+7QVgvWMXZdzFns
   T3opmY6kGMSfa9DkTmupE/Ma1s/WFWKwtkaq3fvYhsR/2cWljAqc9cpzn
   wmZBlfefYwcBGJukMUGk3GpYkrVvi/jvR9ZcvIWZqej/FRTMXEnWctUOE
   aAjJt4cHcjKK1gGYTJ44yIRaMstjgl017H263RKvUrFD3IPvFQOYxCFwK
   VMpDzo8KHh8ZNOSf2S9g8q7HQHZqZIzuj/uD5fzIQ5mNucWLL1fZ7SMdm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="280956388"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="280956388"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2022 23:32:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="654611945"
X-IronPort-AV: E=Sophos;i="5.93,348,1654585200"; 
   d="scan'208";a="654611945"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 26 Sep 2022 23:32:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 23:32:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 26 Sep 2022 23:32:54 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 26 Sep 2022 23:32:54 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 26 Sep 2022 23:32:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NlBTYmprZqJ6jXjVTRzJ0bjrKpqOQBC855faL6t+ZLl1ZE1hTmiY1QfxYDOBaUlm4+XLjzsgIE8rh7wBMdA5xwG23miAhaaw3WCkaM4Y7GIxzpTfc0C51p3NF98/73f7G67+f+ArS8nlsW7lsGA5in6yL9V11nXn7aQn55I5qHcHZEQuwZAS2inaAIKZiqkccIjshTPo+PkEicXoelORn3MnHmYHSkS2KA25oGrc+uXP8SuIML1h0vjI/eF+Gbs8AD40Y4X9XUPYSnYw1OcI2WZnka70mhWsh1EaJogHWMDHLZXMGhAn9Wa+DaWJ1wTuskuSDYIbRC/RIcTFf7MTKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHNMf4aWIQpqssFvPnqQa0t9vBCyCSBy/uSmphWDFmk=;
 b=i90FWI9jRHHO/B71ZxnfUwsSjfBTcOYS0m/42XVYy70QQ1kUazuJeTXEKNYYytuLnFDntSXGq+ysLYrAGGDemfJUBH98qnlk5JPt+PrehtneJ3kK3OpZV9voBA7pGn7rGHYtR6KU+uOYQ3P+/2X7CZK+su/WJfHhjxApVIOpBC/BrmElQ0o5V+kbT36AGVLdthr/lLkYK35Iw3rwzTZST1BuSDZacAdDi/0sTrlPp8cDvjaGJ8TMSFv/7S3OgO0X4027JRR8TpoZ1JpiXH8cfX7OLbP1UN/aCyCWE24JYJjoPEKZ9SHRHzWuPRT1+DM2bX2f/IjIiL1hPC7rrwhGZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by SA1PR11MB6807.namprd11.prod.outlook.com
 (2603:10b6:806:24e::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 06:32:51 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::a071:6245:5340:793b%6]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 06:32:51 +0000
Date:   Tue, 27 Sep 2022 14:32:51 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jon@nutanix.com>, <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC v2] KVM: x86/vmx: Suppress posted interrupt notification
 when CPU is in host
Message-ID: <YzKZExaU2k7qfcS9@gao-cwp>
References: <20220923085806.384344-1-chao.gao@intel.com>
 <YzHRKO1v5N/BIQl6@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <YzHRKO1v5N/BIQl6@google.com>
X-ClientProxiedBy: SG2PR04CA0182.apcprd04.prod.outlook.com
 (2603:1096:4:14::20) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|SA1PR11MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: 83446b13-3a35-406b-3755-08daa0521a52
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUiJku9i1m42wBKcfzLacnaWlMZV2FJrXMMjEvMHjiHs4wA9kbe1ihfpEvEYV+QGN2bYaiyj0jpq7oniExK0jzLT5bW//4dzs7h6uiE7qBUpjV/pLibU0grkNnnEWTfRiuzSM+SnSLIIdQ7IEAzgpnW7C16vFlnd7JjUrnOLqSgpqeaXlrPMhw9AzD/wrHs1RTL2tbTVmpVt6qL2RsiZNaip0jSeZyUZvwHYPpEBOUeSFocMlOesPDYsI7+EnvIDnlj58mtMI6bhVM+048U41jCjl++H4CQgoBoH95/Zra17xSjyYhxvcr0Prna94fhzaW1WU3qlLWQAbNe60bTNFME9CNS9cU5t2z8nrxJ2wJ4RgvX7HsVHAMa9McN3nb7Z2LSNXIZuJ/nlnJwS7RmsBfXKfy915zAJTJ/T6qwEFHkJTc4JjYrUebkR7sQNyCfApujBmKEeB3j3e6zzmaE/+4wWo0S5ZK1Hx/AD0P+jdFcLsqd0UuVBwzThwnxKeSFZu4SHlYcvT4LZV22Vu4yA3gmkt54GToc3g5ECy7zFJ1wjUiKLLmiQfwWmfp7cBSRsMfkqoIjUBTY23spKW5E3MahhdkFfze0AnNRY1+z4Ca1aVcUh5Ej0yUnwdYowyFblISphE9vQXB0LkGKs7EErjwPGgE8AcMRSU8RYiXKhHQ1TGOGK7Q2ndmgrXsvZaH9MZ05DrjRMuaRg7KGDjvCKsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(366004)(136003)(396003)(39860400002)(451199015)(26005)(6512007)(9686003)(2906002)(7416002)(5660300002)(44832011)(6506007)(186003)(83380400001)(8936002)(86362001)(6486002)(66476007)(66556008)(66946007)(6916009)(54906003)(15650500001)(4326008)(316002)(33716001)(8676002)(38100700002)(478600001)(82960400001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?14fQBOqRGYnoeNyfucBZ6eYzlXmGlSUk15XPqbUdoEXyt22HZ1RBEIQJNUxM?=
 =?us-ascii?Q?kvj8gUxCp4WQm0RRfKsAn1kfdE9CPL3dRheP2SBFek37audGGijYj8VIK7jb?=
 =?us-ascii?Q?tiw/BUiyCfsvJ5liYJTsY/nHjpAt68jPRy2IKia+JbeHSlV4AqfhxAEty2aL?=
 =?us-ascii?Q?wI8NPXwqUk9f9b9VIXNB1guU8XLjwvQz3+Cagd3zlVwCF985QbbEa7bKBYT6?=
 =?us-ascii?Q?yd31BVLLVb44ToEbSoRF32Lb80Qm94RdYhGFWZmXRei+A3UN2SxzhZLAjLDH?=
 =?us-ascii?Q?RJMk6gGgzBAZlrt+nM3fxkxq46Y1wQF1ODyrQEp4mLOcONak+PJrSGXjgKrl?=
 =?us-ascii?Q?vwOxgwMOVUAJHjHycsQWLDPx4zaY6KR87uYY38v60voJ7k/8YW5F4LZ2Lbtx?=
 =?us-ascii?Q?PkEYI1IyepwsDPa/kBi8A0c/HPb8kQ48FEJTj7ZvTEKgS9/0S4oJ+4EEj2jd?=
 =?us-ascii?Q?BqrTqVGrTx8XZHphs57YWyWcPevB5JWEwy5kAtM82/KUV3BR2rPWGyZ7MhPu?=
 =?us-ascii?Q?mU/mSfTI/ExJTlIaMyWnnAd/Z35G9p2qTvR4gWHB/izLg35YOaCg7XmwEd8m?=
 =?us-ascii?Q?7Bh2Qg9fz1UqUX+45mHd4cVf7pXlRQ/z7dyEJqPfF95k3fUzHBQcg31LR8qi?=
 =?us-ascii?Q?1OGte8Oo8MyE/qsTrxbTxF1+aM1O4toMSc6vPP5Ld9OmNHF5mf6FoCdXF5oW?=
 =?us-ascii?Q?THYlJ0G/ddMR/fJ+4DmmYcAGuQuRanQ3QvYdlSP6nKIYoRNMjflwMS1Xambb?=
 =?us-ascii?Q?2HNRVZYTSrF1AhaqyJc9vFhuc6Bn9xZECbIg/oQFnfeyfEYGL1+wxJZafjxm?=
 =?us-ascii?Q?5fHeargdoJFOSw7nkARr1SDOp6+GnkpOqgJTW2ocyrUV8gdhxpWa8nheizt/?=
 =?us-ascii?Q?hborOpSl7LgkQ1GqZG+HuM23n9d/L6dqm2E2mlXZJLUmTBszFP4ssuZ4h3ME?=
 =?us-ascii?Q?yKBbAgZJWIFxHRQu1FznlnZUEaNIaYOSZuB9gLhc0mQbO3ry0Aj6gvek/A2F?=
 =?us-ascii?Q?PXI6JYre4okJlpH4gOP+UspRx9DWjrYc9o9sExXCRLO0sP+jM3+3DkUS54LR?=
 =?us-ascii?Q?+3skSPbCH5ZZJignSR+XBMimUtBvhlpYmVZvR6usJ0KmqUwP7BRm/BBQc8/2?=
 =?us-ascii?Q?+R1Y4KoZ0Ryw8sFyTfbK4sNsgewohxMvGK4ES5Vio6qtI3JFm+COO1BI8fxo?=
 =?us-ascii?Q?7VHCaGzwouD8DZOXljR2O4tqhZcdB12jYgAbE9bmzdFuKeWgJa4xrMCB4a7o?=
 =?us-ascii?Q?7n0d4njD4W6BODuaAQhfXFu1lAtBUVABHqc8pkJe0eYfW19KIq/072qjPZNr?=
 =?us-ascii?Q?D8ZvGrZCS4/Jg/aBhWwMfNxGx2Gz7K0EMIQQKHHb0SSBkysQYbdNl0EVrFBX?=
 =?us-ascii?Q?pFrftFnvJZFD2c54+SQjC9eYtF82PGBorgFvInKAO1yHM3N8Jj7qnXR145kE?=
 =?us-ascii?Q?Lav1GXmKOgQEGi+fhdu32sq7uTLBgXpo82KFDAzatkTTkXldwBZ4ChT28d7T?=
 =?us-ascii?Q?FJ+zfoCQWn5G7DgG8LRMmTrS390II3wyNHXhGyDoH74o/lsbQf0X5BF64xsp?=
 =?us-ascii?Q?3mh6g0fEsJrCz5O2CWraIkb6UXB2zz+UlsGEuyGu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83446b13-3a35-406b-3755-08daa0521a52
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 06:32:51.7579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OICiJH6jtQm1bd7+3ssxYMNlGKxCYqsFkbgVBRtlo3Cr2VfZNvX4aeH5uhFktFL7KrRC7JdGQv52dNIXg0qizQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6807
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 04:19:52PM +0000, Sean Christopherson wrote:
>On Fri, Sep 23, 2022, Chao Gao wrote:
>> Set PID.SN right after VM exits and clear it before VM entry to minimize
>> the chance of hardware issuing PINs to a CPU when it's in host.
>
>Toggling PID.SN as close to the world switch as possible is undesirable.  If KVM
>re-enters the guest without enabling IRQs, i.e. handles the VM-Exit in the fastpath,
>then the notification IRQ will be delivered in the guest.
>
>The natural location to do the toggling is when KVM "toggles" software, i.e. when
>KVM sets IN_GUEST_MODE (clear SN) and OUTSIDE_GUEST_MODE (set SN).

This makes sense to me.

>
>I believe that would also obviate the need to manually send a PI Notification IRQ,
>as the existing ->sync_pir_to_irr() call that exists to handle exactly this case
>(notification not sent or handled in host) would ensure any outstanding posted IRQ
>gets moved to the IRR and processed accordingly.
>
>> Opportunistically clean up vmx_vcpu_pi_put(); when a vCPU is preempted,
>
>Uh uh, this patch is already way, way too subtle and complex to tack on clean up.
>"Opportunistic" clean up is for cases where the clean up is a pure refactoring
>and/or has zero impact on functionality.

Got it. Will move this cleanup to a separate patch if it is still needed.

>
>> it is pointless to update PID.NV to wakeup vector since notification is
>> anyway suppressed. And since PID.SN should be already set for running
>> vCPUs, so, don't set it again for preempted vCPUs.
>
>I'm pretty sure this is wrong.  If the vCPU is preempted between prepare_to_rcuwait()
>and schedule(), then skipping pi_enable_wakeup_handler() will hang the guest if
>the wakeup event is a posted IRQ and the event arrives while the vCPU is preempted.

Thanks for pointing out this subtle case.

My understanding is finally there will be a call of vmx_vcpu_pi_put()
with preempted=false (I assume that preempted vCPUs will be scheduled
at some later point). In that case, pi_enable_wakeup_handler() can wake
up the vCPU by sending a self-ipi. Plus this patch checks PIR instead of
ON bit, I don't get why the guest will hang.

>
>> When IPI virtualization is enabled, this patch increases "perf bench" [*]
>> by 6.56%, and PIN count in 1 second drops from tens of thousands to
>> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
>> VM-exit round-trip latency.
>
>The overhead is more than likely due to pi_is_pir_empty() in the VM-Entry path,
>i.e. should in theory go away if PID.SN is clear/set at IN_GUEST_MODE and
>OUTSIDE_GUEST_MODE

I will collect perf data after implementing what you suggested.

>
>> Also honour PID.SN bit in vmx_deliver_posted_interrupt().
>
>Why?

VT-d hardware doesn't set ON bit if SN bit is set.

Enforce the same rule in KVM can skip unnecessary work, like the
following pi_test_and_set_on() and kvm_vcpu_trigger_posted_interrupt().

>
>> When IPI virtualization is enabled, this patch increases "perf bench" [*]
>> by 6.56%, and PIN count in 1 second drops from tens of thousands to
>> hundreds. But cpuid loop test shows this patch causes 1.58% overhead in
>> VM-exit round-trip latency.
>> 
>> [*] test cmd: perf bench sched pipe -T. Note that we change the source
>> code to pin two threads to two different vCPUs so that it can reproduce
>> stable results.
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> ---
>> RFC: I am not sure whether the benefits outweighs the extra VM-exit cost.
>> 
>> Changes in v2 (addressed comments from Kevin):
>> - measure/estimate the impact to non-IPC-intensive cases
>> - don't tie PID.SN to vcpu->mode. Instead, clear PID.SN
>>   right before VM-entry and set it after VM-exit.
>
>Ah, sorry, missed v1.  Rather than key off of IN_GUEST_MODE in the sync path, add
>an explicit kvm_x86_ops hook to perform the transition.  I.e. make it explict.

It is ok to add a separate hook. But the question is how to coordinate clearing
SN with ->sync_pir_to_irr(). Clearing SN bit may put PIR in a state where ON/SN
are cleared but some outstanding IRQs left there. Current ->sync_pir_to_irr()
doesn't sync those IRQs to IRR in this case. Here are two options to fix the
problem:

1) clear SN with the new hook, then set ON bit if there is any outstanding IRQ.
No change to ->sync_pir_to_irr() is needed.

2) clear SN with the new hook, add a force mode to ->sync_pir_to_irr() where
PIR is synced to IRR regardless of ON/SN bits, inovke ->sync_pir_to_irr()
on VM-entry path with force_mode=true.

Both may lead to an extra check of PIR.

>> @@ -101,11 +95,16 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>>  		new.control = old.control;
>>  
>>  		/*
>> -		 * Clear SN (as above) and refresh the destination APIC ID to
>> -		 * handle task migration (@cpu != vcpu->cpu).
>> +		 * Set SN and refresh the destination APIC ID to handle
>> +		 * task migration (@cpu != vcpu->cpu).
>> +		 *
>> +		 * SN is cleared when a vCPU goes to blocked state so that
>> +		 * the blocked vCPU can be waken up on receiving a
>> +		 * notification. For a running/runnable vCPU, such
>> +		 * notifications are useless. Set SN bit to suppress them.
>>  		 */
>>  		new.ndst = dest;
>> -		new.sn = 0;
>> +		new.sn = 1;
>
>To handle the preempted case, I believe the correct behavior is to leave SN
>as-is, although that would require setting SN=1 during vCPU creation.  Arguably
>KVM should do that anyways when APICv is enabled.
>
>Hmm, or alternatively this should do the same?
>
>		new.sn = !kvm_vcpu_is_blocking();

I don't get this. Probably I am misunderstanding something about vCPU preemption.

>
>> @@ -172,8 +160,10 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
>>  	 * enabled until it is safe to call try_to_wake_up() on the task being
>>  	 * scheduled out).
>>  	 */
>> -	if (pi_test_on(&new))
>> +	if (!pi_is_pir_empty(pi_desc)) {
>> +		pi_set_on(pi_desc);
>
>As much as I wish we could get rid of kvm_arch_vcpu_blocking(), I actually think
>this would be a good application of that hook.  If PID.SN is cleared during
>kvm_arch_vcpu_blocking() and set during kvm_arch_vcpu_unblocking(), then I believe
>there's no need to manually check the PIR here, as any IRQ that isn't detected by
>kvm_vcpu_check_block() is guaranteed to set PID.ON=1.

Using kvm_arch_vcpu_blocking() has the same problem as using a new hook
for the VM-entry path: we need a force mode for ->sync_pir_to_irr() or
set ON bit if there is any outstanding IRQ right after clearing SN

The former may help performance a little but since the call of
->sync_pir_to_irr() in kvm_vcpu_check_block() is so far away from the
place where SN is cleared, I think this would be a source of bugs.

The latter has no benefit compared to what this patch does here.
