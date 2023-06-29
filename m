Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B08E7420B1
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 08:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231787AbjF2G6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 02:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjF2G6v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 02:58:51 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE8919BE;
        Wed, 28 Jun 2023 23:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688021930; x=1719557930;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/lyEyV5F1FCW1oe1ClJZnnQWStO3rjA55E0XM7EtecU=;
  b=XpUlKyoPBCU6n5yc5fFnCOaDbpKZfTCyK+aO8o4qEhD5Bjsbp3JF4XLC
   O2lo0s54h7P7mBYBbtXtMGUS/83pnx6aUtlCQH/FCePxg+Z27Fnz33YTa
   u/tFEH2ePUdW80fKVeezrt6KbE+ahsMtlZ+v+8p68QgPvQvb7gd/rIoCS
   FL+Z4hnEUaipTQXhfHGT3/FTXusEsVZDsOsspcNj5npHdRRnpArMcBkax
   rv4DEJ95vDFHVrxwlogfu+SJiM4Z2Lb992/6K3CYDE5n6Z8ruStgrw0Pk
   1MMHC1wii5hVLgvoL7S727/M5jS+S2bg86NpLMQ3JeXqtqHnH/dGSLv/4
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="425709117"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="425709117"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 23:58:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="717253051"
X-IronPort-AV: E=Sophos;i="6.01,167,1684825200"; 
   d="scan'208";a="717253051"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 28 Jun 2023 23:58:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 23:58:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 28 Jun 2023 23:58:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 28 Jun 2023 23:58:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 28 Jun 2023 23:58:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/6ZchgPIpq14tPGzAjr/6NP7Jd0+wt2aYHeekDKlS5zpMLgr9p0BV3nLMKIvkV1ckZvFSHtOb9xdoG5srL+4KnMByQfHT0sQgKcJzhFaTN+UoOU5bzvmsD+jQKk09VeUQzFpmY0urZaN+I+F8jWfUAO7Tr345zsOlKeilFcPVZpfL/BeyGrzHoxKUteHC3KvoNyu2jtelKssaCd8zSDseWKpiFzIFQGlY6oLMnP62preNb7NS/pdLDT+cmPOxPuTguVNvez7kzHBpV9/8QVzjNlQLIe1VNoCYnN/CzLtCIIfyADfakEwYPC1PZWui22rhPvz94gkQBQ4SCOpq2dLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ngm7aJaYotjmxpw4zkBLi20pGgW38ZYs/9/tlYK8PQk=;
 b=h2wh/1rWozdoPzcsF8x6ge7XFEmNUXrkArJQ8fjlWgecfUZarK7kvcWca7pFIR5pBWAsggAQaOlaFQR2Lpkg+fUNTuf3AgKDraNEhGQt8iny05eTRfvJfgWb1QyY0el24irJNK2kRyHSQmb8397XCp9ptb+Yskz9DOPMFFPricyRi8FYWPbSTFupOPNz9zBE+xpkgogClEnFG1me1nJLOhe72bNUhKoBPehyE4XtjPMTfzycaWEdCD8UmNLIux6q9F5euo7gImJNZNkZNmL5TQ7nnxq04uQ82wWhLURcqhG1oz8aWJBant5JmwkZi6yaiPc7TgUT3cr8w1MgfZuh+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by BN9PR11MB5449.namprd11.prod.outlook.com (2603:10b6:408:11e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Thu, 29 Jun
 2023 06:58:05 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::5817:cb8f:c2b7:f1e5%4]) with mapi id 15.20.6455.028; Thu, 29 Jun 2023
 06:58:04 +0000
Date:   Thu, 29 Jun 2023 14:57:53 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
CC:     Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <kai.huang@intel.com>, <David.Laight@aculab.com>,
        <robert.hu@linux.intel.com>
Subject: Re: [PATCH v9 4/6] KVM: x86: Introduce untag_addr() in kvm_x86_ops
Message-ID: <ZJ0rcVpSjbZInnIq@chao-email>
References: <20230606091842.13123-1-binbin.wu@linux.intel.com>
 <20230606091842.13123-5-binbin.wu@linux.intel.com>
 <ZJt7vud/2FJtcGjV@google.com>
 <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bf5ef935-b676-4f2a-7df3-271eff24e6bb@linux.intel.com>
X-ClientProxiedBy: SI2P153CA0010.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::13) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|BN9PR11MB5449:EE_
X-MS-Office365-Filtering-Correlation-Id: 19c87e33-cf11-4bc6-4b8b-08db786e2f64
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qns4hZqWF0FdtalyfjfgX0j6KlbF2VlotLetuJsQQExeSZWQIF2MhMUvS95W7VDyiHTBKjMUk0gD1I0rWG8wfS9HcTkgR04U2Js2KaitwmQvGR6+Qi5ejRv7GFl4Yo4/NtdyjJlLf71KunhLE+tK9r/wTiY82qtC34/bsqW3dtiKWb2Tgk4VYu6ZUOTroCSxZsuh35HiC/NPa9zqpRKYsy2RQkCtxqhmFQy7mJchoAcdoXY0y986cuu+OAXgMV+nWLyoOOEHH6YuSB7l9USLhNytmx7opDNBAtY7l2lEkwMdfs8FeAyhZfSPz46cjA+GxXKoFrYiCqweQwnAd5Z9nlrUFkLiMKobDWMLPxr9tx9BnAW5T2vUrSEnzvzsakzAWexXdYPgQfmlNwmIU7SIbTMRJP8ebnmOVuipE/L9lj+FDIbOCm4f2cfNChzioSMk67OrHWkHA8c53Hu+FdulePtrMeLsOLFWe25yW8R+/YqE01Bkp36rZciuCxDWQu2zUP/HzeSnwna/RM7M2J82pC1wKWgwLGEx/fiZt1dSu7opo1WxYDlXA/c46QaJJscD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(136003)(376002)(366004)(39860400002)(396003)(451199021)(6512007)(44832011)(66556008)(4326008)(66476007)(316002)(6916009)(478600001)(66946007)(8936002)(8676002)(5660300002)(4744005)(2906002)(26005)(86362001)(41300700001)(6666004)(6486002)(33716001)(6506007)(9686003)(82960400001)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZpjvDjbzcgLO1ygdHkheNwNFIU4iP3e2yTOBawWoMnGFF2LPF4yoKP26TnXG?=
 =?us-ascii?Q?/wLf5MloQKWWhK4AbrOtJI7iR3t1gSGm6idZmXNfddMtra+8nK13ydaaCvun?=
 =?us-ascii?Q?V6zaf2Q8xaJ9fdWdtwaQjMfyOk7XF8Ag0qsM36ooS7NqhsXutHVsrQO6PvH+?=
 =?us-ascii?Q?VUvx6ixJpjzP+y6vqR9aZqgD5Ff1fS5KVAJB46r7iQJI41wXVp7KZUKXlwYr?=
 =?us-ascii?Q?XBu0tO8bOj2akMa8NhJfFL2lGWwCInPveCBhm5C8Za460lPnKx7VtccJsVqd?=
 =?us-ascii?Q?zFNDWMiQ9kVM7BSkMl1M6qmPO7vNrkHg8j0zJpNpJP7fhNBAgiAwe/Nets86?=
 =?us-ascii?Q?03qtGf9W+48XHIwzEicDYpTOJ7v6U06yHr3ibGIGwcX3aXeJMHW/vcIWNvWo?=
 =?us-ascii?Q?uDObU6mokX6JFOQ/4wh4dvljHMHFyIBfNg2TqJOG6siOINdpkwHrKSR9CQAs?=
 =?us-ascii?Q?SClzpkcW0p1mC9vNoSTRN712ARO77WWR7TCYMIwMiOA9z+sTsAi8Qr3ScGsm?=
 =?us-ascii?Q?swSIyAICPA9YijWLk/fTx6DB6F5WaLnFSfpWC4Dm5D3AcUGe8DKoFMu4X85i?=
 =?us-ascii?Q?gCcioJYgP46ToHxJlYemvmE61svgh7JpZiaT+u9mZF+1ePm5LbQb0Wxbmwpl?=
 =?us-ascii?Q?uV2Meb5gPtwz++s27fz99JQl9fjRHsALSI7gzPJs8x3a2YOpt0BCpo/KFxKX?=
 =?us-ascii?Q?a/Yj0ZI3STq6Wk4Mb17aRcLjqpX0wc68dAb+MAqL1oJchRrM71a7otA5280Y?=
 =?us-ascii?Q?icZPIR7WEa4DE2/goFn8d+sSEKNPdsqonr//Y79ootLgO3O8wc7jj3vBT2j0?=
 =?us-ascii?Q?1lL53wfs7CfM57FwzDhwLXc5U8l7dWuXeDvrVUojrJ1w4y+cOInO3f+/QZZv?=
 =?us-ascii?Q?BdIN9nu/1pR/bTTiOY1knqRiw19MyN/8AedDjzGFFpJOHXlIno6N04llwaOJ?=
 =?us-ascii?Q?e+vkfHSQbNL4549wBvZf+avL9G5RxrZHuTwcyFLksYgMtgN+Wb1faRhtwvgY?=
 =?us-ascii?Q?k5wmpaSnfvFt0Ush2vtHoZ3aty33cq7k0pjp5/c51cXES/7+xcGChlStds90?=
 =?us-ascii?Q?K7BEXqW1W17jIXo0CFn/HeWIN6EDSFGeIYTU6+iuW273xOK0V0cgtgLX3/i3?=
 =?us-ascii?Q?3JL3Yp9ql2kwQWN778Dl9n5uMOR0X+Jq4PMkttN5fPl1qiHV7vHrm/QNArFw?=
 =?us-ascii?Q?L+q/iKqlscgD1gEaoxkLEfMIATQis2AiQOv2UXBETW9dzq3ZuRFHYYFTwJC4?=
 =?us-ascii?Q?VShHZmCc4YtY0lrpSvqbaCzhHzWbykjalWwp39pMuUoaLWyjryBrqTUDH2gb?=
 =?us-ascii?Q?4LzcUVB8nIS1mdY8NmsWn4vuKRwvslnKsOhHtS1ZOGuMs8sH5iC8pkva1rU4?=
 =?us-ascii?Q?jcyqqMhGkFtfOSDKrM3F3vrRD0vTiHqj7ruN4DgP15barAs+Sh8BKCihQisy?=
 =?us-ascii?Q?sW2X7//enFMPYQr8mkygS91WjRQ5Mj+01kGcCp/SPvRHfqYPd8DEH0u++YLv?=
 =?us-ascii?Q?pHcybXWpMfk18yX88BTSm2EGlrIUHsUSgFbBd6m72B58IrFpfFOSiM4aqg+C?=
 =?us-ascii?Q?0uCnoWcc/9sk5fhdkF8IaBTfoc22GATwO/EimQxK?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19c87e33-cf11-4bc6-4b8b-08db786e2f64
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 06:58:04.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XGsXJOSbt/L3v44twQMPIXq1GyK9Kz3BegXg7NBc1RxUyQODNy/M7FdiQb2zXUQz3Km2SctUiObW+ryJc0ASaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5449
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 29, 2023 at 02:12:27PM +0800, Binbin Wu wrote:
>> > +	/*
>> > +	 * Check LAM_U48 in cr3_ctrl_bits to avoid guest_cpuid_has().
>> > +	 * If not set, vCPU doesn't supports LAM.
>> > +	 */
>> > +	if (!(vcpu->arch.cr3_ctrl_bits & X86_CR3_LAM_U48) ||
>> This is unnecessary, KVM should never allow the LAM bits in CR3 to be set if LAM
>> isn't supported.

A corner case is:

If EPT is enabled, CR3 writes are not trapped. then guests can set the
LAM bits in CR3 if hardware supports LAM regardless whether or not guest
enumerates LAM.
