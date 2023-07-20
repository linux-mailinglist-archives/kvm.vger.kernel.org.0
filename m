Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB9E75AC27
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 12:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjGTKim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 06:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjGTKij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 06:38:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6458B10F5
        for <kvm@vger.kernel.org>; Thu, 20 Jul 2023 03:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689849509; x=1721385509;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=a6LSaw3PEyCb5KT3vSKoBWMIHzUqlRFoLPuhV9360Gk=;
  b=djr+kFfb6pnFTe1Zwc0hC0njIGQvN4hVDbZHRMb5V956pIZRyzfWx0Bd
   N3aTlwkEB0xUc63SVKYtqq9qVr6lF6xW9rlOKu5AxpFsD6dlLIlrideZg
   4givQUbblmLJudqR9F550pmsB1CPCf4GM2yCiS/dyBdlL2GGfWwpb6S5P
   DEomciZFBVpkLKeKosPHtomiN7KUvoWWNLcwo/0kU9O1+RRmKJC8yEDDl
   6ubwhLehnxW7kZx4rRp3mmt3AFvj8XmIkzvEmqrsPsrbJF0vj5QsMwc0i
   AiN+tetPY8XbtknkjO+2uKTd/zhkj4eQ5YDzZ3dtqqy02V4S2axIJxE5d
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="364154179"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="364154179"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 03:38:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="794418823"
X-IronPort-AV: E=Sophos;i="6.01,218,1684825200"; 
   d="scan'208";a="794418823"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jul 2023 03:38:28 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 03:38:28 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 03:38:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 20 Jul 2023 03:38:27 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.47) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 20 Jul 2023 03:38:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XskpdP8hGd8Ts+WhCqCF8/n2IiIk2eDCFAXbAo5YrD4cjL1FPppK6wlcEw3EeLgGGd+dGq65jaoYiuRGa5ko2K8Jxs2aMqBHPCoThP8eskFM0ZEOUY7xWg4ZzSnHP0pB1ZZNNpbD0WlBVBekwwf30sDZkjysdbs7HkuxsNwkvnBrKPzqgAUIEdBanwa2DI6Y4gfnUNUwHpih7xp59kVEzwzMUYQRZuaetvgGbtY7vB7iqtgaazf/2maRF/0RQP4AwOnppW5RGXk7QGDfpihXVGZDZsP9oSq4T+OTzWtVPVwzjCOHoXgGvYTfYXiUNlMtQFQBBOR9Id4mK7hh/IGGkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+OZte/TY1PsZjlZDHMJNgY01VF+Svmd5qVJGL3VS38=;
 b=mVqafPw2Wddo0hI2Eme9C+Yg5Ln0RJIOfw8e6DMyCYSEzWO09/moHAUzOuCJHTR/Wr0nsA6jKXyYvaYhgpxMN8lbq1efRcQlvfBXGCIHHS44pinlpFEQ9AAgA05dOyYmYpsxzwD2up/KpBA+mA09bpMle7WTC+44LnhUPewnZoaG/VEIBr/YJnF0b/mnobhQquh0Izu5cNq3HcFkrYszmX/Mkuy1EGlK68lnyi+RUVGtnFNSmoqsKe8ag02AAjy2o7lqNyU7IfQmGgQVvLeZR9BGJgKcgqarvMpxxhRrehowWTkvr9SqIBAjY+le1AtH+rPUMCo1HG+UhcaYALaCIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by SA2PR11MB4972.namprd11.prod.outlook.com (2603:10b6:806:fb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 10:38:21 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::2803:94a7:314c:3254%7]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 10:38:20 +0000
Date:   Thu, 20 Jul 2023 18:38:10 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
CC:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
Message-ID: <ZLkOkjUYI3av/SJn@chao-email>
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com>
 <ZLiUrP9ZFMr/Wf4/@chao-email>
 <5f519f61-f80d-700f-099a-6f34de3522cf@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5f519f61-f80d-700f-099a-6f34de3522cf@intel.com>
X-ClientProxiedBy: SG2PR02CA0106.apcprd02.prod.outlook.com
 (2603:1096:4:92::22) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|SA2PR11MB4972:EE_
X-MS-Office365-Filtering-Correlation-Id: f01dcf6e-510a-43bd-5ad0-08db890d6f86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0h3j5JM+/R58hJ3gBJY9U5A64D1oOW57eQNtLe4nng8S/e20jS6IRxCnpdPVmq0lWt1SvWfDCtI2qcTgYP46y9xbnOhFGXBHDitlMJKWc3OUxbEKe2Hv+b4rYGCSG236glyPv2eObZSDBEj6fcJgo8iyThaEVXWCBnGvmnHNKEWY/ndc1tM0NYbrzIdmW7XP0oszutpYwJFARSoPRiktSrmHNBVKqyOgOvGe3NoEi7tSniwoH9tAoNZJ9+aBI+yQLiNwwbHJsTBbmpTKCpCtICcmD2yj+lnyropE3jYIny36p+Q2EHqmzLy1iSb2EDCzMVcl4H1/nesyvyPdyAZ+Js1fEYE08ZGJ6wg3yVccxwSFqHllq34geyLvyjlEE7QYAITe1kAcjoFG0c1lgdMFOmNilk6ENmEJBU2ETP5ji76QBfSA1mc8PEWgAG7O1AJP8M8zzbwCo6nDVSsK0y+9c4PyhykXgdA/4nxSob0YpUtuc/gyP47CW3RDLwJ84xUqkVIz4hYsUYL/+rGp7EO3QaPHbIgyBcwwIBuPxnc5O/Zm119ftG8gPwVqVpgsbdIA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(366004)(396003)(376002)(346002)(39860400002)(451199021)(6666004)(6486002)(54906003)(478600001)(6506007)(9686003)(53546011)(66476007)(186003)(2906002)(26005)(33716001)(6512007)(66556008)(82960400001)(66946007)(6636002)(8676002)(5660300002)(316002)(44832011)(6862004)(41300700001)(8936002)(4326008)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eLKvI5j51i8LPBEptpvGOZJzeLY3a+iurdq5tPiQDWXehYwbwxYdofQ/En4H?=
 =?us-ascii?Q?tQfJ6tKyzBR3shQlkNCTCu2AFgZOvnDvlxO6Rk9fBOlV9NQ0gNHWDbstnWPJ?=
 =?us-ascii?Q?kNvfqMM47tEKsN+cWcFCuUJYulB2iLujDnIdyROWfwOLNCP7spiqaY0PTqw2?=
 =?us-ascii?Q?eUiR3h7hRv33GbdgmR/JFtABj6eFUi53nmJo9Iz+ezkP7wIYVZ9RGNiSjo+6?=
 =?us-ascii?Q?BQQIaLI5SxIeQEScOtlhZVe06mfUZ3iFGxFpJfd9SOTm69efkwhgDU5hiCyg?=
 =?us-ascii?Q?WK9904j+6JPf/0BDBG4/u4OpTR9TQ/PNzEOSknJtkg/VwwDZB/fKfdB30nxl?=
 =?us-ascii?Q?TEAd01IFFrfbzBPil6GgjIuxNSpKnRvSXWUp2B3W0mws3JEHt30a5NdjTm3r?=
 =?us-ascii?Q?vJiMtj1pz7SeQ6C8Ccym3t/9kHCkdMKlZyeo8oloa84nM72UumjJpK0KDIR4?=
 =?us-ascii?Q?lwwV8ZRxcHdcraH3tRKvn/N9y5NSBbQvQaPiBYSnD8UVjoxB9f7Ua+Hyv4pL?=
 =?us-ascii?Q?n2wAUh118xNidHNH7i6kk4uALxoVMglLaDGhfLhOZa6UUvNWP20St4uj3163?=
 =?us-ascii?Q?AkNg/3kK6ntBWt51Amnx1SB1mKNuYeCiFZHsV/jZj8qdILh6qdFrPADbs42q?=
 =?us-ascii?Q?AVOKZpwEfXBF97026hx21rJTflHahQHpq/G2Y9BGhjFxQ9VvpfeIjW0mq0wN?=
 =?us-ascii?Q?mb/vZA3iPcFpImPm8jAvtKy/0d1HX6C0g0lXn55QRgM39ev/16+zJx0okw2/?=
 =?us-ascii?Q?/Hac3vC4aKiWmD6gyp3oAWNV5LUzyQZ2ImnPJUtYvza964gpe3xDIAYuxakW?=
 =?us-ascii?Q?FGGRuTYeUeCfMLEGqQSDW2vzYp4zkdPXZAklw+o7FOVrk69I1MAxV7CqDft5?=
 =?us-ascii?Q?ABN266UNw7lZMfEIYMb8y9FQZKBESUm9PleTInt7xwCAnBWnbIktfrCbleeT?=
 =?us-ascii?Q?iojPHkKsHsRtukxvilclM+8IA9iFwZe+bQofYv8E3dBVi08nuhymx6AR8Elc?=
 =?us-ascii?Q?/vs+WUOkLbKg/+vatvy7ky4ShkpZjACoUg8dUwntoJA3fQP/och+REom+EJn?=
 =?us-ascii?Q?/zqcvdRREtmjSueoJMYSIjsgcJk139TPMLjQhM0CmL8qtRzAe7ak4h/wIOYO?=
 =?us-ascii?Q?XLCGnmuqbEN1kWaTAprV3Nu8CNV7Tp/Nc2hQvjnwvvotHEA76WttzITAGJCT?=
 =?us-ascii?Q?d0syegULCnD059UFgQBvgYZPCakSOyqmR3F9+u2Meb08neB5cTwyN0YZk2DC?=
 =?us-ascii?Q?fCg2k3QqGCRs351AqNK9bEnB27TioGv8/0KinlrnYZXB+A1S4M+EF9XC6cvR?=
 =?us-ascii?Q?uRiDt8fIZEXsnqBygH8ozEVqe9vjbMZfM0X5+OsF+AevGx5RQ6HmcVM011UX?=
 =?us-ascii?Q?aVMODQMffGdFbZnfYZlA75aQUYR4m7CzymFLjP6Jofx5SVNm1TsOH5u1Q/8q?=
 =?us-ascii?Q?oFibvKX2NK6yb484gCZXZOo7rQgFkKe4obdHvD2qoXZ1J/WBAQDOsw5jxlCA?=
 =?us-ascii?Q?gDlYZZdbHSUFJthc137OJUwL82k5/J4qXcMDK4+s4HO6jsfjKaHNZCVPUS4R?=
 =?us-ascii?Q?RXvXuOQwCMq0XNkU+6CzhZJRhvBRW+XakftD/smS?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f01dcf6e-510a-43bd-5ad0-08db890d6f86
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 10:38:20.4436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eLLSgoHXsPdHGR5XpRHtVn1kevgJt9CdrNNwx4/f9JFS3+53FMP+TTH1shs24YLvT3KZ+Rgtggs1QNao5UayWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4972
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 20, 2023 at 12:04:48PM +0800, Xiaoyao Li wrote:
>On 7/20/2023 9:58 AM, Chao Gao wrote:
>> On Thu, Jul 20, 2023 at 09:25:14AM +0800, Xiaoyao Li wrote:
>> > On 7/20/2023 2:08 AM, Jim Mattson wrote:
>> > > Normally, we would restrict guest MSR writes based on guest CPU
>> > > features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
>> > > the case.
>> 
>> This issue isn't specific to the two MSRs. Any MSRs that are not
>> intercepted and with some reserved bits for future extenstions may run
>> into this issue. Right?
>
>The luck is KVM defines a list of MSRs that can be passthrough for vmx:
>
>static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS]  = {
>	MSR_IA32_SPEC_CTRL,
>	MSR_IA32_PRED_CMD,
>	MSR_IA32_FLUSH_CMD,
>	MSR_IA32_TSC,
>#ifdef CONFIG_X86_64
>	MSR_FS_BASE,
>	MSR_GS_BASE,
>	MSR_KERNEL_GS_BASE,
>	MSR_IA32_XFD,
>	MSR_IA32_XFD_ERR,
>#endif
>	MSR_IA32_SYSENTER_CS,
>	MSR_IA32_SYSENTER_ESP,
>	MSR_IA32_SYSENTER_EIP,
>	MSR_CORE_C1_RES,
>	MSR_CORE_C3_RESIDENCY,
>	MSR_CORE_C6_RESIDENCY,
>	MSR_CORE_C7_RESIDENCY,
>};
>
>and only a few of them has reserved bits. It's feasible to fix them.

Yes. But note that a few MSRs will be added to the list soon, in the CET
series and the FRED series

>
>> > > hardware. This could be problematic in heterogeneous migration pools.
>> > > For instance, a VM that starts on a Cascade Lake host may set
>> > > IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
>> > > CPUID.(EAX=07H,ECX=02H):EDX.PSFD[bit 0] is clear. Then, if that VM is
>> > > migrated to a Skylake host, KVM_SET_MSRS will refuse to set
>> > > IA32_SPEC_CTRL to its current value, because Skylake doesn't support
>> > > PSFD.
>> 
>> It is a guest fault. Can we modify guest kernel in this case?
>
>I don't think it's a guest fault. Guest can do whatever it wants and KVM
>cannot expect guest's behavior.

OK. I have no objection.

But I still think adjusting guest behavior is the right thing to do.
Because I don't get the benefit of emulating hardware precisely in this
case but the cost of fixing KVM's behavior is obvious: if guests write
to the MSR frequently, they get a lot of VM-exits. I think correctness
is important but not always the most important.

We are working on a real-world project rather than a toy; we should take
other factors into consideration.
