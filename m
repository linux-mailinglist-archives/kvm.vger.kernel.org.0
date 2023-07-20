Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046E675A42F
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 03:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjGTB6n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 21:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjGTB6m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 21:58:42 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BF61FE9
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 18:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689818321; x=1721354321;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2eO+95X03CoaShmwNamHWvV9AavITDERNoNG1JcyBsQ=;
  b=OfdRQrNPYMvQ9i1WZRXtMVzlYjIs/6kue2Twi3BZer0KarpG9MEr+xXx
   4yHLfhyq10GNLWsYsXUw7zIUcW9ZysptFLjWqqo4jP8FIBn6hkt3mgxKI
   fWpwtdqNHbpHhdpW8j2x1Mslo5dWogVyCLsidVUboaey460mZqUeHi7nS
   yFXwmKA0Cnq9E/lq+pG/dgvoBuNd3CAi7zt+d5iMb52BZSBT3CvVBKAoy
   7UwgpvpA6zZ0aPgw3nZ8gABjluZREtd0mzYA/terPCDY36nOCEr4saQJO
   6MboBghIu6o3w24k+QD9w19AaV6Qho6pj7+Ciy5favXCC4bVjkgM1OxWP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="397482690"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="397482690"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 18:58:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="814332432"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="814332432"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jul 2023 18:58:17 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 18:58:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 18:58:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 19 Jul 2023 18:58:16 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 19 Jul 2023 18:58:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZempf3ZL8zE1frf3R/uVtCIxE4ut8HIePHWlPA7FYB/XiQYR0p2um1p81r25VQkv3jqHM9ILBUccAOnWwLgfCjDXLkjWqSbRryo0YAoRmJFYlB5QEpgSOlSObkNQUnG04Jq+hqNRPbqS9J24n7+ZlKhweTV3DMaRpqJFwehPLEHaETsqm5n3T7OF5f7UsHNGQR64GVjqFDDDSc9MegKqt4lx81pG5v7x5/tXD7ORlnPgX6LRqNefglnbAMJbo7lT/5A0UccoHBMwIEOUOAvJmh/rarA5JofaRrJE8jGa/Aihr4k0eHTflPqDRYE785nyKzBmJ+YQlq/IVUpyccxQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DW+5g0PeH+m0YR3r6xzkxO3UdVYTPXkk3FyXg5HeoJA=;
 b=UlzH2Igkq7UMGIzQYM9Fxd0jsHPJODsSjV654izGmgPLnlZt7q4hSshOqN4MO+hqrCV7/vVKywGbJ3ebUjqDRna5q1hcztSXxlOcB9IDDmrgFP43w5SVXLhZVqWdroNdY8OFn8DTq4dhHMlyhu3OXWEu7S7r5WQQ8isAeZJYmyZhPyNrEar+SVITvY/umbzt0uMCUJxFHmOD5ih/oknIlXkLcL1Fr0Z3SRp9PQ35raRSnK+pBAqidtXymc1FigIDZuwjCYJMMXdo+rwWkOqDHI2Tx9jIhjQWgwln3uX3CPqby1e/jBAL/GSkImQCH8HnuMPo1da3oNlwWennr+D54A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA0PR11MB4589.namprd11.prod.outlook.com (2603:10b6:806:9a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.23; Thu, 20 Jul
 2023 01:58:14 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 01:58:14 +0000
Date:   Thu, 20 Jul 2023 09:58:04 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <ZLiUrP9ZFMr/Wf4/@chao-email>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
X-ClientProxiedBy: SGXP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::33)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA0PR11MB4589:EE_
X-MS-Office365-Filtering-Correlation-Id: 9162b82a-e829-4510-cdef-08db88c4c6cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n0SnpQxNO9YjzVh40KI97EPXeVjhmdVvkWMgfjDjGpDEHXvFjRSWKtkmw+PlL1j77qRmcczcqcIZ2gPy5hNwqSmSpxahqH7QK+8+rxsSf6dntzipFoJd0cAqpY5MwMDrfCQfvWcxGWQ/lBv1h/Dx7EbKbUymV9qQ9OQtwKsWBGOFo5869LVezZ43a/Yziff2g5jdOj+wDzYeaBEExK+p2tiHdLqOf1LkG7LO+A6zkCTuw7VYudqfzTZ0x0tfLrOT2M2uq8XYKSdgUWk/QxHmx3vE4wd368oha9cqts3hVu+AUkkQmXAx/K2PADsOR8ur4vT2sdiMAINW97le/KKWiJpNPYQ9JB0mEF6nNxPXi+WfOlNxqOpPLJjLxDTC6Tv4+nr4W8dqWuUa68tUr23gi4KMoLg4zBjqYY1BlHwdyrMh8961l7FxsOubJIR/WoGXlERMUrsymq2jDSuSHV3lmBzP8sFkNV/WWRTjpExKpq/wEAAv5be/CAorRQ1EUxFHD9Zv7NTofIBtzeNY3g+nHnSRvyabJJxE+K60E1uTs5Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(136003)(366004)(376002)(346002)(39860400002)(451199021)(6506007)(186003)(66556008)(33716001)(54906003)(478600001)(26005)(44832011)(9686003)(6486002)(966005)(41300700001)(66476007)(316002)(6666004)(5660300002)(6512007)(8936002)(8676002)(4326008)(6636002)(83380400001)(66946007)(6862004)(86362001)(38100700002)(2906002)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTVI4Lq2XH6MqTtHuJkkQ//pKKT/virIwi5TVAoBpMPPxtfx7V1dyAuTU6nX?=
 =?us-ascii?Q?WRVCPLj5PC+jEaw9Fv5dg4REYUHzsMs63jazJFXeIMx5NAhAR2nZfoXrQ28O?=
 =?us-ascii?Q?t7KkHPUvNhkJfEJzp08Ps64LR+kAXLdY+WuuOYfHOK499yvZNIomzeBTAa1s?=
 =?us-ascii?Q?7xsFvDBoB/+zIlvw9eW2DFWZWjcPsZx38mGWNlxGXx4iBgITwaohmwqRYZE1?=
 =?us-ascii?Q?WPLjL1HPV4D7cmQJNSXzAexrzc1hZJT3hai+sS0M1Pn9BP4oRu0YWoZoiNZj?=
 =?us-ascii?Q?gXYbd215IU/bngDgdNBg1fz5KYdxAfzcEtf99CC96TJiVTgy5z2PDZftdB8f?=
 =?us-ascii?Q?koQj+HIZcSmPoZMfwikx48Q7FJRABMxophHKv269HttMWClbpm15+zVBQiUS?=
 =?us-ascii?Q?0/z0BdH04OdcHH8KDCs2h1YJ/dGYJzWy2KQxw7S3SUM0khFuhBglwTVNcvWh?=
 =?us-ascii?Q?OYeBc6n4nehG6hkLvHRumR1CYxU+PdOFZLy1wXQQmMmZSInvi/ZbYiY139PY?=
 =?us-ascii?Q?vNoczKB+vUiEPuoqT5HtGL2rhZYyt7SL4AaU1cfc2CsBrWMSsEXq56/KpGY1?=
 =?us-ascii?Q?h3Bta/YLax+a3crDXCnyi16iVHKVzr/3EGqQM+mbmi7MZYP59Nn2i9DUo8KX?=
 =?us-ascii?Q?8xllkBLgTlm5zyy98wfTLti98PfeSc4u7C8da9Mr6kNhnfKmDb9bPAd7dO1q?=
 =?us-ascii?Q?r35vgCwympmi9sa9O+zu0811Mll2QhhxcdbedsyVuerFE50J4AC4d008ZS0J?=
 =?us-ascii?Q?EYW6Mdmk1L2fXA2jWAS3HBVa+MRy+x3u5oxu234iZU831TwFzQPAkP2Aoa6V?=
 =?us-ascii?Q?SDK+v8z7BDkC2nU89NRP824ka9hLytnGu1ZUIgImzwVBPeAfNL7bynC22jnY?=
 =?us-ascii?Q?K6FFvvmq3e+S9pBHebG1WOun3zlLeMwbvIA++6ktNKdYnRHdSE//p2/26ZAy?=
 =?us-ascii?Q?USF3rW9YgdlkeFfZ+uphLW7QIZxLO+bh83J7idq0V2ACIksTB2LMBZgKvfs/?=
 =?us-ascii?Q?XTZW2PJvwywzOnVFMx4B0V+CQdrcMSi3vwMvbKiKreVpzrAxL3PkUqHp+Kco?=
 =?us-ascii?Q?BLSTHcNP6sDO4FYnuARRnbQDVk27I6NrZv53Ovh9GroXew44JIErVfnjcyFi?=
 =?us-ascii?Q?ycSo6p7i/qSzIjYr509UB4qPW0fTbiV+eEY0FqwSkejFokxc0sxTD/CnXmzn?=
 =?us-ascii?Q?CJ6emJinI3TMbkvzRxVnb5vkw0pPBsQ+WYUrZPYlzX+yYxyQYKvuImJ0c7HZ?=
 =?us-ascii?Q?xahn8u3ewv5Z78IhmvG7mJfX8qEZYWhS9Tf51gI7LUTuVpY60pjU/IZMxG8T?=
 =?us-ascii?Q?JRqwJLLkKcwEfFWF/UmpxwMT+saWn4lT2k4hXXqMZQc+z+edMctdr0d+Fc6S?=
 =?us-ascii?Q?GgwWEvL3IsuMu0+IVhk4vcUOiLDMeLZOqu8FqM2Ar9hSICxo3P47AMXKZVTM?=
 =?us-ascii?Q?UVlQP0skEQZ6p+5KhXTZl59XzIx9sh7FUj9pmq/dBVRqI4YSAcGbrLAAUGjv?=
 =?us-ascii?Q?neQUw1G8HC6S3C5mrp9bdvdOGt/khusXp43Zck97vJZhG8XPr5AFJ5XxQIgW?=
 =?us-ascii?Q?Iy7euAqBx26udpMIH+HFHa3ciggm7anfyI55V7Bh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9162b82a-e829-4510-cdef-08db88c4c6cb
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 01:58:13.5833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XIiuRB2Ijj03/9/wGJaRWdIp2XhBS5VgQqh/l2cyiTleznBFqxPJfh1xQi3DcF1u26UOYxHCCnyDdBknf9+Xvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4589
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 09:25:14AM +0800, Xiaoyao Li wrote:
>On 7/20/2023 2:08 AM, Jim Mattson wrote:
>> Normally, we would restrict guest MSR writes based on guest CPU
>> features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
>> the case.

This issue isn't specific to the two MSRs. Any MSRs that are not
intercepted and with some reserved bits for future extenstions may run
into this issue. Right? IMO, it is a conflict of interests between
disabling MSR write intercept for less VM-exits and host's control over
the value written to the MSR by guest.

We may need something like CR0/CR4 masks and read shadows for all MSRs
to address this fundamental issue.

>> 
>> For the first non-zero write to IA32_SPEC_CTRL, we check to see that
>> the host supports the value written. We don't care whether or not the
>> guest supports the value written (as long as it supports the MSR).
>> After the first non-zero write, we stop intercepting writes to
>> IA32_SPEC_CTRL, so the guest can write any value supported by the
>> hardware. This could be problematic in heterogeneous migration pools.
>> For instance, a VM that starts on a Cascade Lake host may set
>> IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
>> CPUID.(EAX=07H,ECX=02H):EDX.PSFD[bit 0] is clear. Then, if that VM is
>> migrated to a Skylake host, KVM_SET_MSRS will refuse to set
>> IA32_SPEC_CTRL to its current value, because Skylake doesn't support
>> PSFD.

It is a guest fault. Can we modify guest kernel in this case?

>> 
>> We disable write intercepts IA32_PRED_CMD as long as the guest
>> supports the MSR. That's fine for now, since only one bit of PRED_CMD
>> has been defined. Hence, guest support and host support are
>> equivalent...today. But, are we really comfortable with letting the
>> guest set any IA32_PRED_CMD bit that may be defined in the future?
>>
>> The same question applies to IA32_SPEC_CTRL. Are we comfortable with
>> letting the guest write to any bit that may be defined in the future?
>
>My point is we need to fix it, though Chao has different point that sometimes
>performance may be more important[*]
>
>[*] https://lore.kernel.org/all/ZGdE3jNS11wV+V2w@chao-email/

Maybe KVM can provide options to QEMU. e.g., we can define a KVM quirk.
Disabling the quirk means always intercept IA32_SPEC_CTRL MSR writes.

>
>> At least the AMD approach with V_SPEC_CTRL prevents the guest from
>> clearing any bits set by the host, but on Intel, it's a total
>> free-for-all. What happens when a new bit is defined that absolutely
>> must be set to 1 all of the time?

I suppose there is no such bit now. For SPR and future CPUs, "virtualize
IA32_SPEC_CTRL" VMX feature can lock some bits to 0 or 1 regardless of
the value written by guests.
