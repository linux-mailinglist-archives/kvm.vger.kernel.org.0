Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37CBA6521A4
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 14:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiLTNnV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 08:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbiLTNnS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 08:43:18 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69D0018E34;
        Tue, 20 Dec 2022 05:43:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671543797; x=1703079797;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TJHRiFRD8i7fv8e9yb7Zn9pFq7pqRsyhMEqTtJHo4C8=;
  b=OMl0WD1tCJko6i0O8PESweBBYwAw9am6JFj0cILRUxzgJXq3aDz6ixFR
   2i+G/etvyDOYO2l9iPyt6DqfDp6qWzT0vaSH3prBY4IDL1U3WtbkpKQTZ
   D7ekgWeDqgQMDyYCUWjxU0iPuzitAdT0gSZVG2skITvn0VknZjHu2gDOK
   /tm7D/NS+u/pAIQK9UlPUnuatmajLtBLbUD/31HsOJHIy+GtawARelp0n
   oLh1dVCIGONPlqp5sIiWwOHSP4lXBe1Q15UO/5yKRouJwN/+4F85Tj8QI
   tmeT0g6mt0NQ7SHJzMbNXSBEFQRQb2LEFZpqzCWzj8XdYc68uxQT2ZWnK
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="299955212"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="299955212"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2022 05:43:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10567"; a="651004573"
X-IronPort-AV: E=Sophos;i="5.96,259,1665471600"; 
   d="scan'208";a="651004573"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2022 05:43:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 05:43:12 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 20 Dec 2022 05:43:12 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 20 Dec 2022 05:43:12 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 20 Dec 2022 05:43:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dzbqNvgGI7QQs5bbI1dATcRjPNSdYgGhdlgb/hoko1hOeR+m/1X3F2a0mfJXW3DGaA+1UjTQszaq6p3NOkrrJ35zT/FCsUIjAZsUEzy560Vq0VRn5p1yI+Y3fGc3aSt1yvQ5Z3c9LoSmavW0qyRZWTcUmkaPZ2Jr0VKcyUGjtjECULGUu+O1VUACRlVYU6142z7TkT8qhZgV3j0L9mvlGJpWsQISwhcO7LXYDUJjCqnrf1bAef4hpPM6DPIDrC9n0doAherly8Q5AjKb3btE/AbUHX/v1uRk6O+ayvMkH+lj1NUp8d3H1h5s8VpUeNcoA5vO3NHJUnqyPk1JOwnVMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUK8MOVMpxcLSeWu6m6gO4g2Ce3arzL1syk3wXAoY/I=;
 b=bLxA17JZgxqHO7K6FQxvTrrAN/1JmKiHNDMZ3IWe3YhARyEMBawdo6XlCkFDOrjCDdz847p27b4WVHZoKoCAlCqpYZQ6dVOkYZo7X/41pMLVD0mUpvsrn+9oYDw80CQ7tUi7LlVScxbbrmY31Ds9MPoOjRDRMx0WUi9hH2IBnsKpv0S2clTRbMGkCSkDnXQ5M8BxOk2e9Sqad3nSWrQ8HHYsM5leZWqnjT+VikGvUsAHNX9cy2IrIT726W7rVLn8LJYf7ER22w96uyRp+nYwCZEfoOjnKugjJAWvq9+USGSlq6dfrSIp1O1OSC2qNslDnPQdIc8NGv2EFbo+j5Q28Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by BN9PR11MB5513.namprd11.prod.outlook.com
 (2603:10b6:408:102::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Tue, 20 Dec
 2022 13:43:05 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::5cf5:bbad:8442:f2b4]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::5cf5:bbad:8442:f2b4%2]) with mapi id 15.20.5924.016; Tue, 20 Dec 2022
 13:43:05 +0000
Date:   Tue, 20 Dec 2022 21:43:08 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Zhang Chen <chen.zhang@intel.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Message-ID: <Y6G77CTIk8CvtTLn@gao-cwp>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com>
 <Y5oviY0471JytWPo@google.com>
 <Y6BtcutjgcgE8dsv@gao-cwp>
 <Y6Cb2OrkQ8X3IvW5@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y6Cb2OrkQ8X3IvW5@google.com>
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|BN9PR11MB5513:EE_
X-MS-Office365-Filtering-Correlation-Id: c53bd1e3-b6ce-4b9b-5874-08dae2901ed9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 96soKa2DF1Ao9U3WSggdzQMrIg39V/ySp5DMkj80xJinG0PaHGhxPAmguTX7MK517OKsPYzzJYZMWje/g1FkvOYtWxo1tRcRmhVo/Jp77ufRXZceZd0y/dtrl+3jTA/GyaLtea0OfFQieLZMfwZ0jqqnbH5WGraXJebcisFlRL7YYGDbT5tru1VJJ/OmcnHTKtVpH08VOyIWlFP7z2LHO+S5GzeFCW3W4TMCOfju4fPmKLhXO2HLg9vq6ExXqYnhpSLyDQnLDqzBfUHY79Z2Ap48GAojaJku1cMEvPpbpUrjRJmFsVr/1o5lzuSrADIOqyra2Z2kGCCq+bburNYOXShFxw3SKc0qaAiuURhdNJ5FXgLqnaKGDLJVlO3x80KnDYKf2feEhjCxa7cvFyeORWJi86p2d2qmXs52v3LfmdllYdFRpEASUMqbXwTiIT5/gW8LfMQFnw9/ehhpt+JtEnf+HXCVkdaMWCl+dyLZdr5WtAxifZzeF3RHeJgibt4cf2/hmm5yMXJq7zTlDptnLtyBAOVa+Q8cAImXGiY2lRYGYU1PFU7dQ8qb69sJ9c0NoBZ155Q0Ns8S8/GYgFJCKMKb3x6+XQiQBsE7RlL7c0VI2KPEpeHYtjHmmTodwOnzqJ2PDZoqZ5EqXxC60XaKLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(6506007)(478600001)(6486002)(2906002)(186003)(26005)(6512007)(66556008)(66946007)(66476007)(8676002)(41300700001)(7416002)(83380400001)(5660300002)(33716001)(4326008)(316002)(6916009)(8936002)(9686003)(54906003)(44832011)(86362001)(38100700002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G4dtvIWI4SNusqMpJoBVn1BRChPc/zJFw0ApNFfU1Z6oL0EDoYtHw9ncRWNq?=
 =?us-ascii?Q?bMUL7h0gAbgDCcbvhEQYl53fRFXLxnQ8XK/wU1qZcuzM3tDj4st/QBGdI53l?=
 =?us-ascii?Q?PHionYpeXm5lXqZIVYo3kGBW306+LiA1mxrTnFRXHh1z+dXXp4lkNdEbdpxA?=
 =?us-ascii?Q?ixy7axslIltdVUV8me7KbbfqbBDwcQ8ocVBC278UebWAwgByemc6E8EPkuJY?=
 =?us-ascii?Q?f2KNtMHA/HoFF0wNHkoPfO61jhHcQIIPov9JqVO/rT7PFzRMEXuJudqI/b5m?=
 =?us-ascii?Q?RBIjEalfI3FG3nArEopDzY8cDG/tnPmR1gZFOGg0i5Y5JitMYZM8NawypO2e?=
 =?us-ascii?Q?+muopWdL5bLuzTA/xgwF4UeTCePiVdFdTg6LIM9IHLk1Q+mZ/JEUqHI+J+GO?=
 =?us-ascii?Q?w717NDWssepQj1osZofwhBoTQTfercz15iRL+MbwMI6MM8SBzEpipIb/X8GT?=
 =?us-ascii?Q?1HM+HAiiUOI8yxBZF160sJP4ncy4C9kQvklfWXJv72hCaeic7pYExv01tmzi?=
 =?us-ascii?Q?/TPeV5luhxfZizljN4vQPDQYs+MBsvsxLSPKOmIdI8fwdhYJ+puVkJH853gj?=
 =?us-ascii?Q?nAj+/sqxfkcsYhDD6vwz+nkPo320sIKHwsJDjfJUFylQrJxT0T83QHJT80T+?=
 =?us-ascii?Q?IO/Fn/kNEmShONaEW65gsvtWWLIhF/WONMNUrKzvbn05Qp6EEDWKTT1ZeaGs?=
 =?us-ascii?Q?FZP0dXCR1/X/4Ve1KXWT9pxdf1acQg1woI5nzyLJd1xRH3SLlQKBo/rW7P0N?=
 =?us-ascii?Q?nrNVEfMFwHdOjSKR679dqd94+7V2dH1t5pkPnfzD9xyjE5E/U4j8JQRgxOD2?=
 =?us-ascii?Q?vm2RSwP7BlEHR05ITxje2FN2nPyryAFWhq3rtqCxngeuYpvSRASeQb8khcAS?=
 =?us-ascii?Q?5BmPI4DwROib6MTL2Kq2KLYkZBmtDFxaItB1kcQH+UJYCL6ocJS3iva1P2vv?=
 =?us-ascii?Q?9SvrJ3dODZGA22D3hwzQcv3+Bv9EoUkYCgUJfdCw626eZTWW3woaWef9mmeG?=
 =?us-ascii?Q?1rQ4lFP2oypg5vL98BRKUwzK8Zl7NQKaKy3y6IHne8SxQK5wN/9gBBrxQ0GA?=
 =?us-ascii?Q?JzoENsgJeQJOZnQGb6WdFjiGzm1B73159y62mZU3HEQHu9q+bbCiJG2evK+h?=
 =?us-ascii?Q?LFroUiNWfAdKUJ3ZCUJXMvieKo59J/g7GoDsYcDedAsCvwLxSoC29rbx9M9B?=
 =?us-ascii?Q?yOgIBpnJLCN15NLLdkz+TUXbGCX8pRN29tSNdv7sHvp4mOYsZGY64RGZmyiF?=
 =?us-ascii?Q?YaSH5Okj/Kc9bLMx5GXiiAK9u/VHdxnMKZfwRoqsdT3lwkoQyM46A+69CKMg?=
 =?us-ascii?Q?64BUQtYG4SkfKlAkFSfrWpszidKBpIDHxNzZGyoBtiACRnbYUjQUe0PhytH5?=
 =?us-ascii?Q?YyIfjnUuzrBbvwQJm0qPi8NEqL1PLL/fSaE7jfp9Ty1wgo1QLcYyS8cPz1Vb?=
 =?us-ascii?Q?Uebf/+Pmxm15bgmiM5rI4Ii0zvOG60WHbDOdugJfcOK7fMrBA4Zah0/yuvv4?=
 =?us-ascii?Q?P8F7PcUZCK3xnoAp/lKHEHW4G/Qt3jwGq3lIgcVWOEQjTy2aib/7/IJhn3Vu?=
 =?us-ascii?Q?Co5uxiiZAfj+GIzpy9WZj07e92IPlCKWaKMncSQl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c53bd1e3-b6ce-4b9b-5874-08dae2901ed9
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2022 13:43:05.4418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kT/B8pRgCuU9kz3JNQY5Yt/JNg6nMSozr4SYGNNQgrLBuX8EM4tR88elNRC+55Hr46Zh3k8zjeH8+C6wBlYWgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5513
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 19, 2022 at 05:14:00PM +0000, Sean Christopherson wrote:
>On Mon, Dec 19, 2022, Chao Gao wrote:
>> On Wed, Dec 14, 2022 at 08:18:17PM +0000, Sean Christopherson wrote:
>> > To me, this looks like Intel is foisting a paravirt interface on KVM and other
>> > hypervisors without collaborating with said hypervisors' developers and maintainers.
>> >
>> >I get that some of the mitigations are vendor specific, but things like RETPOLINE
>> >aren't vendor specific.  I haven't followed all of the mitigation stuff very
>> >closely, but I wouldn't be surprised if there are mitigations now or in the future
>> >that are common across architectures, e.g. arm64 and x86-64.  Intel doing its own
>> >thing means AMD and arm64 will likely follow suit, and suddenly KVM is supporting
>> >multiple paravirt interfaces for very similar things, without having any control
>> >over the APIs.  That's all kinds of backwards.
>> 
>> But if the interface is defined by KVM rather than Intel, it will likely end up
>> with different interfaces for different VMMs, then Linux guest needs to support
>> all of them. And KVM needs to implement Hyper-V's and Xen's interface to support
>> Hyper-V enlightened and Xen enlightened guest. This is a _real_ problem and
>> complicates KVM/Linux in a similar way as multiple paravirt interfaces.
>
>I never said the PV interfaces should be defined by KVM.  I 100% agree that any
>one hypervisor defining its own interface will suffer the same problem.

I am thinking there are only two options:

1. Intel defines the interface.
2. Every VMM defines its own interface.

Any middle ground between the two options?

>
>I think having a PV interface for coordinating mitigations between host and guest
>is a great idea.  What I don't like is tying the interface to "hardware" and defining

Do you think something below is better than the intel-defined interface?
add a new KVM_CAP_* and a KVM_FEATURE_* in hypervisor CPUID leaf to enumerate
the interface. And add a new virtual MSR 0x4b564dxx for guest to report in-use
software mitigations and assign one bit for each software mitigation. On MSR
write emulation, call into vmx code to enable some hardware mitigations if
the corresponding software mitigations are not effective on host.

I am afraid it is late to switch to above approach because e.g., if Hyper-V
decides to support the intel-defined interface, KVM probably needs to support it
for Hyper-V guests.

Can we emulate IA32_ARCH_CAPABILITIES for AMD guests so that AMD can re-use
intel-defined interface?

>the interface without even trying to collaborate with others.

I will pass on this to related Intel folks and ask them to collaborate with
KVM community on future PV interfaces.
