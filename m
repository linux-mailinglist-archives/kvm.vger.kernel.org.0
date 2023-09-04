Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39110791300
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 10:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238178AbjIDIKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 04:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjIDIKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 04:10:04 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1026919B;
        Mon,  4 Sep 2023 01:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1693814977; x=1725350977;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=PxR8V1G+bu1+UvMbfrWsX5r4PbfGuJRi1/bY8/0GPno=;
  b=O3UFxUjnHkI8UGCGvKB7PhyxnTRZ5CFM1jzrdHcp8lCWSp4OVqeoM2Xq
   jeuxw/z76xIXJvvdJ2TXylB3XTJIXr7mv8lRw1azkMIgShyNLzV/NRCCp
   u80eACtGfxuzaRW/zFWHysR+SNPUXp7nIdiPQnpq3LuvFsAh26a8zc6Vl
   RIs99zXC8Nl2+tfeSmdLYUaZyEeJVZuxWBRgKr6+zkAI+YG4XVtL9JTHh
   2mpT4gXlegBDBRv44xzCQoCJapyIJNHcPLGVGC5ExbyXje0f193wNbxgH
   GD1nEveR0MEKJJI2oK+8WPFNlHcOzn2Yl7ovOSNTu8fZbeXdAiF2BIWS8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="442940773"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="442940773"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2023 01:09:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10822"; a="883957292"
X-IronPort-AV: E=Sophos;i="6.02,225,1688454000"; 
   d="scan'208";a="883957292"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Sep 2023 01:09:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 01:09:32 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 4 Sep 2023 01:09:32 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 4 Sep 2023 01:09:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 4 Sep 2023 01:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXXArxpP03A1BrkXOoEWMMQcQQGahiUNqqG29/kWH0mw6yiAHTcT4/2Ds4WLfXTS/P2OmRfZ8QHumVwEL238TKn9oMruWODStVrk2XU/28D+iOVwSKvoNOqVem5OBFfgXsjQ932NmM8H0l+0FNFTnZfDobsqGM62wYk9bBhdZhcY91YQzr1REKSfOJMeatXbSNtcV09BrNoV++NX/pbwHq5VCkHcKt/vYdmrGhwiSlnXfJvO5YTrR3NMinSet0MnOh8k854YdLJ+H2MW+8e9KzUyibCskW8ap3Hm5f7LeJ64g00MeScbH3/ERKAbwGqnAaZHAZZUw90tEic5kl4J3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+UAU8NvB+KxmvIiTzZNIAhtXouWAxuHhPnV1GppK0U=;
 b=XZ3nhmHtb9Z1oB5LcO9WwN8jLeT9sZcfHwH9Bwh/oJgXWwkx2CB5vHThLEQIie31XN3c9NiUoRLPaXQaSKpJvYbRR3Ak71WqWWNgDjNT1GefjoE/SKePbYip1DujpXgFVSUgwtSpYhI9s5XjOYCFKTLo9V9rktnYtlWWFf4h6Wma+jtWFbDx8zMvdY6T1udwBvT1v1ZqFjW8G5qnbJ153yhtqooYpsY/thwE2EFwmwfapm8JRqXe01q9I/kq+F4p0Y+6S8E6WtUKrYzHAvYOMl/3ojHJm5u9eJ/PRqSSO50E75J0+Mqml93Ox9zwVxeZokyUcXP9lqt6lKg113NgLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5112.namprd11.prod.outlook.com (2603:10b6:510:3b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.32; Mon, 4 Sep 2023 08:09:29 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::5e79:2d52:51e:f602%6]) with mapi id 15.20.6745.030; Mon, 4 Sep 2023
 08:09:29 +0000
Date:   Mon, 4 Sep 2023 15:41:51 +0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <pbonzini@redhat.com>, <chao.gao@intel.com>, <kai.huang@intel.com>,
        <robert.hoo.linux@gmail.com>, <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v4 07/12] KVM: VMX: drop IPAT in memtype when CD=1 for
 KVM_X86_QUIRK_CD_NW_CLEARED
Message-ID: <ZPWKP7nVyOg4jJo0@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
 <20230714065326.20557-1-yan.y.zhao@intel.com>
 <ZOkgka+DX4KNm5Mp@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZOkgka+DX4KNm5Mp@google.com>
X-ClientProxiedBy: KL1P15301CA0051.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cab37f8-b4b1-4fd0-4891-08dbad1e4309
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4xOXShKzABSqSg34QUYM1Hf84kDo91LDg1Lzqv+igapEME5D3TitRQvnuB4AwuPe7hGwxIFk3W8Dkaj8cYbl+B9mQPlioihu23VFm9I3QBDv9j0JmeaFEwf6nYiZY/VvNmeAzLjoO4V8jhklYpCxu0umtw/Dfbw22uF42NnhuBM1gWnqRxnsarWSYCAIapbKsx1/bNuWPYUOUb2TpzUtkpxDnqOIIDVRzsWQH55gC3GV8w11ZUC5iIZnkM6aBd5x/Lpbyhy5SyxS7zxPxTGsQU2DXqB9Z36maZOWwhYe5lmSPiGs6mK6wNbf4C3dwHrZgX1QTlshXlRp0jPNIjDiKEeXrdO4+aj9OAOj6r+F1A0/TY3BH0iUspfbgnNpZDl4IVdBSGwUffDp1YimXtBPV22fnAjDDWFyGKVTW9p4KmAQSDqyPuK5vDCXEJy+/GZTxp6RGBUpA8Lgfl0BoWBeHotU8mGdEALwlfNkp+vIzWUhHSKRYooefCVquY40YuEDIEHrJqxTx8rug/0SFB7rlm5Ppd9eplZdAGKUMSwKe2LPHWJ6Ua/GsVqq5DakA9xt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(1800799009)(451199024)(186009)(8676002)(8936002)(5660300002)(316002)(6916009)(66946007)(2906002)(66556008)(4744005)(66476007)(4326008)(41300700001)(6486002)(6506007)(26005)(6512007)(3450700001)(38100700002)(6666004)(82960400001)(478600001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+lSoSDb9NQwFqUsS76uPO3AV1ViYT8HRnufdhOUeSjFKVUnCJ/gplGw4b7XY?=
 =?us-ascii?Q?emyANOa3EXZWMvEV5taNHYJbJvfoxgof932Rbvg6VXxpWsHsOE0U5FdB3BlR?=
 =?us-ascii?Q?iXlFocYBFst7MnPDVaeKTaoF4vMoghAOth9A+HPYVuxt4f+Ytza+WgvNooKl?=
 =?us-ascii?Q?TZEiL2WDf2HemZ9Pzqqv6H0O76BwyzxyJ0mat6yXQm69YIgJQaxrChBwbMnN?=
 =?us-ascii?Q?NidPbTrQ4fgdfoqcvvxq3PCcl1TN1jNYLETW80roBn8Dx3yaKIw/HhCq3Dx7?=
 =?us-ascii?Q?BNnWH1Hv4KCEgBWcROS3LHSn6ZTukKGzK7z89fUbHZ9qI4QmrO6UDRbHiYY8?=
 =?us-ascii?Q?W8tuWEvj30I957HBQsA5QFEPEApJ6KafOSFN02GIRjaTHuO9/G3UKi4N6tBn?=
 =?us-ascii?Q?6PRNzn7bKiFXKDqAzMMkRFHaxJlyi5qFLbUIKe7hABwiG5GHCs02QKAB4LON?=
 =?us-ascii?Q?w4o3rSTLu3gcker1iqTYD7XpoiXbpGrUvFEAp7JflfY/8wJW36plFh35qr07?=
 =?us-ascii?Q?0Tftn0W5w+X3T0IjgGlSNVKSQXWSTJiT/GE78ztiTPr+VCgoZKjPJhBVDR/T?=
 =?us-ascii?Q?ik+MhOjRNHxR9dMAbZ6AwCSk3rd9ccfC1xmt/SeVhs+zBQjm7pVhBQlI9zzF?=
 =?us-ascii?Q?whvnYdThwg+LvkLJopKjATBOhd41R7UnwqW++ta6NqvEZFk1tq/5ozw4BgRr?=
 =?us-ascii?Q?j/2bRmFueIK2aPy90gKwn3AM20A9vE9bdyv3dHlzgYNSjnn4vuULV4cbs/uI?=
 =?us-ascii?Q?95nh6xDVfjqEItPvYrum3aIJE3am9dIqPiE6oLp8HwO/NVXPYIzmM8p/33pq?=
 =?us-ascii?Q?KSE/fkUMCw7CnN6q2QU4XqunMRnCZAEg8AlqpPiuFWo0QwMMln9rbUQnrWwi?=
 =?us-ascii?Q?A/N7BHK13Bdyp7CcBMD1dLBCDuV6QdVLrJFYc90KT+o/RdxF3QOBpyUDdIaB?=
 =?us-ascii?Q?BnWDD3IOvyS7kwjSonvE9Uf7q0y5QKgiESCJXUOXjjWd2HDkm49gGvJ88j3o?=
 =?us-ascii?Q?D8qFUMRVhlBoQWcYxP5p4c6UdppnmPDYPjEHM6IV8z8ZWvTHL9U+sUui0DE3?=
 =?us-ascii?Q?rOOfnmWUeNYI0a9C0mk2vHp7FZEZD0l5S2hmY+R3oh9aYfQAB6KLtAMwHN0G?=
 =?us-ascii?Q?Q5oE3BXh1J06TbJalaqdzYrvAL54gujyTOTaYfr4jav0xO8ObzsVyZeiUJLr?=
 =?us-ascii?Q?JMYbREpXSfyk4SQA77u4UALixl4aeechsJu06ynfCg8OrieTc0Pdu/GjBNf8?=
 =?us-ascii?Q?kKnhLJT9E/o1G7HEsGiJTKoNObNB/Gg/RwtONyU2Aj/8bOHznRUDfCbMsBdj?=
 =?us-ascii?Q?TkUa4IjfYEBOsOCvcMFmqXnYhGg69cdKxRmt/dUHZJmKGZj0tQ9BsRSIg/hb?=
 =?us-ascii?Q?F+HP2BmnwEKERTxuBpK8assJAZmM0vdXWwoGN+TzkYIctCAm9M3188vXtdl0?=
 =?us-ascii?Q?AGUpFTugtMaAkup0KRD/pd9vCZVyD5i2TOuv5jVc/546lL+m8kYhSVRtM584?=
 =?us-ascii?Q?vWMmEfgWkTlKTcBi30GMrMPwUwVHT4vbnPyaucPfsnAhcaw+/F+V82xHyQBq?=
 =?us-ascii?Q?fhXULnYJCmGSbhSCXBXnwub5vrlAyBul192yYZMe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cab37f8-b4b1-4fd0-4891-08dbad1e4309
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2023 08:09:28.9828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1yW3NqAaxJbRVV7v7q7W7IkGE8mNd0nIj+AOl9sPQxD0R9zQ3LRzA5T8Jc6NfeBRPp26subbK9mUu8epzF7mHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5112
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

...
> > BTW, returning guest MTRR type as if CR0.CD=0 is also not preferred because
> > it still has to hardcode the MTRR type to WB during the
> 
> Please use full names instead of prononous, I found the "it still has to hardcode"
Thanks! yes, will avoid this kind of prononous in future.

> part really hard to grok.  I think this is what you're saying?
> 
>   BTW, returning guest MTRR type as if CR0.CD=0 is also not preferred because
>   KVMs ABI for the quirk also requires KVM to force WB memtype regardless of
>   guest MTRRs to workaround the slow guest boot-up issue.

Yes, exactly :)
