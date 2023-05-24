Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16D770EEF0
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 09:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239538AbjEXHG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 03:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbjEXHGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 03:06:54 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A2F93;
        Wed, 24 May 2023 00:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684912012; x=1716448012;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ka3fCy3WYFvL4meejR1sHtqdbWT5hwg+ja0Du7fz2Ac=;
  b=kyo6lA83gDc/pEOId4CCKMKfo0tMKknNaVtnUJQ7wMorMBG9pgc3UmV0
   uIyxLwgZGsSxsmDni2Hc9qPaIeGzlzGOhFsgPGMaHk3Li2nvPHZAOwEwk
   919VqDlPc0vdh8to73kXR4r3CvG07/w+ADkYjv6b+TT9uA09bygAlHGFK
   8jxljJ1Pz9Ys7JLIHi71bqHYR06YCfr4Ahq+N8Wjq5LcBe4aO+zi41UgI
   HeVCg4Oben58ifXLwdGSDV3SNSYz+F3TlGnzwyITr3twuTOd9Qi4xoVxj
   SNGFr/cc5eUIQS3s2kNpsSrP6PDBNeDNT3knTfBniLTnRRQCxYkeAGcIl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="439832304"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="439832304"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 00:06:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="698409359"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="698409359"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 24 May 2023 00:06:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 00:06:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 00:06:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 00:06:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 00:06:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeHIqfo1INoN2ZBmIVrrBmyjqzEjLSG9ciRGBi0i4rYKdD8F64icg0o6lf4wHj/fOlkbcoTnzk2IfIX5yKkv689Whn2MClpbvHGmjtsu9OwWD7G+fAUyJChhOCe9w29m2wUJnFCiBo5cz3U56MIBMwZXP41mDzrmuzYaTD/GGqo7RGyWYf9D9xF9jcyvvyeGRDkqufwLesG3WjFtqLwNiU1iguzpaW4OIhBxNJWf/ClBvDrzryhlghfdSqxYB9FCeaGDzI+/VxZJOx9l2Y8kIQah/qbt6h0a+8mZn6wwp/6howS5yyGz6Qqa/kax21ighN7aWPxCuKbptfwxEXkx/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cv8bLi5xJFKJ0Ne+MtO9+20h9vBWdTd5eO9p6hhJyN4=;
 b=Veic178H2m7KF21gWo9KEeuotU0xcCcXmxBfAPhFmyc809RE3DaGK5fnSfQ0/H4+xc63CD51sY2F3lFc1Fs/H4p2bEPYNiuE6LuCjU2cKgzS1rg7ZzRdOBdjuqptbWmQyMnDuFDt1RnOFB0G48pWdkD5H/AOw/y+5LEEDLhTWnmTYJg5IVUPoTMaDKTltpYfLHAs0oqZspRm6lQAy2pmHfZ7fLqkFSGBeo0sIWIs17CMD5PXCxLm/Nl4X89GN5W+oJ1hgW54vnd7sLSJIZkWVoESBlm2Njmtf93ni8ozo2VOAXesPPOCEW32utHpveHIUPB0IY9XnMjDYKq/Rv8miA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DS7PR11MB6125.namprd11.prod.outlook.com (2603:10b6:8:9f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 07:06:47 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 07:06:47 +0000
Date:   Wed, 24 May 2023 15:06:35 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v3 06/21] KVM:x86: Report XSS as to-be-saved if there are
 supported features
Message-ID: <ZG23e/zYAiRlfrk9@chao-email>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-7-weijiang.yang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230511040857.6094-7-weijiang.yang@intel.com>
X-ClientProxiedBy: SG2PR06CA0216.apcprd06.prod.outlook.com
 (2603:1096:4:68::24) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DS7PR11MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: 02401978-9410-4d4e-f059-08db5c25700e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GkKFO3hDfbaell0xXv98eX033IH3NGEmeo+87b/0DhLXf2bSn7z2/5BNx93hYn1jjKWr/w2FrOKW5Dg13Wv+de4BXkNQVncX+/BWooE5/hVpjg5W+PeeeZYilMT1Sk8CCj3EI3eBvpV8vypxnS4+L/dUbhNl7sF6hhSeT3C7kmoK0Sooj85Uadh8mXAeQmfPrZqsh9fECMam3/2NL+bY7pCdOFJ+3FVIpX6UuePp00JdP+vsJmGfnOsezF90uSsFqUPdd9KqUCAH6MlpZORtc9eaCZ58t9r1XIsmCPegBNvoNtKQ6D2zHZuaJnRqWAwCOyS4NLdF4EHTaOaol3cZ/TqYkicDyDkLoLkWjjaUkKOcFuCah+5nBPOLVn6Forp5lXlEU3jUszubowPSGloNTyXrWIvBNSjtf1T2eJcVNP1DwyAhsSdC2RXe462GTjAt1VRILnXrp8vinPMVsGwQ274ttZTguuNTD9nGvqpOgoGosncdpyR3IA3kRHbU8QAqNIJjthcjWH1DBsWjFVMBrp/hZpCppWApnqBiIndrAGSqWVXcNPlW2f+5R7w/zrWj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(38100700002)(33716001)(66946007)(66556008)(66476007)(6636002)(478600001)(6486002)(6666004)(316002)(41300700001)(4326008)(86362001)(6862004)(8676002)(5660300002)(8936002)(44832011)(26005)(6512007)(186003)(9686003)(6506007)(82960400001)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UmLTF8JLgPFomMQ8jAHafk3R+p4784gA0TDMvzwlDzCjCfZkwHdvPTvsnpHF?=
 =?us-ascii?Q?4Wsan5baj0Afl090n2G2Xdsa2ywFnte2UhIxB360OLSd/ydR3ywoYHFk1So9?=
 =?us-ascii?Q?huVh+jzN9AdPKZKBQw/mh1hRA0EipHepskeiYCLQARXAFKFl/sKta9yxiHmD?=
 =?us-ascii?Q?hR+CChoibrnG4LPg7YvlV5r/MkZbXSniU1fSfklx1YtJhTWJ2EO+CdagUhvX?=
 =?us-ascii?Q?hBvbRGMAF9sO/+rsaxSNM7AmLapIHR0wAfaRTYno3eJjzj3e727KTmouuTOP?=
 =?us-ascii?Q?coDYZl5loM/Yiteo+kFPtK9Fx5fdAuvSgJfQmsk4+o2lHVf8rRXYM6WceWMx?=
 =?us-ascii?Q?tPyIWXwAhKLwefFg6rwSC9ph6waGvqzFTRU80eArHufWMtrdaeEzR2Phmue8?=
 =?us-ascii?Q?UBSAvl1VqoUhmOuuIS6DAYWgCSzTn67GrlpilkIPBCs4hZEPnTzgJMDi6pzG?=
 =?us-ascii?Q?/xF+EyoVeTZ3bGsX+jqUP2sF9l6fEK6lZvZOR7RU1VAW8fbHU668B6CNUl0W?=
 =?us-ascii?Q?wTOOETtb0yTlH1DJG311sSThUducAUHeDvp81xGd7IsXMAXM6bQFPjNyoMX0?=
 =?us-ascii?Q?IzIE57Lj5hwUYMRTT09pTH9WhrQEzm4WlcMEtdoCAlSDGQukb6uzCW19bWZR?=
 =?us-ascii?Q?+Yj23MsqD282Hu4vAw+wNxgbuypoQMnIsePaL03VqMvWAEgqi88mf5Z5ykeN?=
 =?us-ascii?Q?n0nWeiZUbdYxciryfm2nEGgrsCgSabYml46boJHAGqdONTsmEKrqouIKWdzS?=
 =?us-ascii?Q?66HKzYJ2qoIvdBd3COd/Y+PlCnZRZ4cfF/H8FNAtiimyQ8s9KsXqTkB0AivY?=
 =?us-ascii?Q?hoaFGFlSp6XIgb5QjLOblDFcRLLYRTSopaLoWWFwNljaAwRP2DwJSrPKD1nC?=
 =?us-ascii?Q?BBlmHFnairLRH/885N2eEx1Mz92h5Rr6XlQIUbHinbhnrAwrnw1S66OYlkMb?=
 =?us-ascii?Q?6Tm68CdFupbZRrLwSYhDpEwEnXKthxaXvkwXmcJkotNWKTU/7OAbHc94V7R7?=
 =?us-ascii?Q?tZ3cr0eocw8iW4mraZv0cAvdfaBB/m7CvmGcJoUlHk5vnXgZcLZzyiZeilBt?=
 =?us-ascii?Q?c8s0VY6RkOxbsjfyL+2d+GXEZoKpskIPhh1meV050pzyqtQa3CjRUTCHxmR7?=
 =?us-ascii?Q?/KI/uqwlhCwLedocHkOF1ZJ4W0SP1hRJLaU6NfSEmlDq54CHfF++HCrvFM9f?=
 =?us-ascii?Q?b3Y3g/qyrJKPXHxT1qhFqzu2Q2DyzaN5oJSrFyYXmkMMbA5tcg+QKSUXNHjY?=
 =?us-ascii?Q?Ql9koEbRLzcpAcUBZYv7vfJfvxMhRFP8ML2lWasC5EVqVML+d9wH89PXiGz6?=
 =?us-ascii?Q?LhxBe/dYNXg4jBUqv6aeRTHulZAWiKm5i5GPACYLGOoeWcUDBvD1Twgh3Ssm?=
 =?us-ascii?Q?T1GrJAEqdq1/n9dNt554JwspOM63TJifq7EBMb2re+hzJ8R5hLhS/jgh3Tlf?=
 =?us-ascii?Q?HaeE/n7h2cHoq+/4b+89+CxQjqjoVg1wGYHJ9jymFlL6l4Do7U563N9ZRNJj?=
 =?us-ascii?Q?o26JlPdgPeaU4v9J5YxUPS4qPN4j5ZCfFbh8YwgVtaSD6KMKHcF1VtbVTLeN?=
 =?us-ascii?Q?l/KHf6ym/NS/OWXl8OMSKO30URsF9mQhxVhxbaYC?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 02401978-9410-4d4e-f059-08db5c25700e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 07:06:46.8696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9NZPgA16SgBxO9wDjGheu09LYbjWygKyaEiU+1qE0QQXpDneOAFDqden9c8b9XpBdBI0hkhTd4LQCDvW5ZGITQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6125
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

On Thu, May 11, 2023 at 12:08:42AM -0400, Yang Weijiang wrote:
>From: Sean Christopherson <sean.j.christopherson@intel.com>
>
>Add MSR_IA32_XSS to the list of MSRs reported to userspace if
>supported_xss is non-zero, i.e. KVM supports at least one XSS based
>feature.

The changelog doesn't match what the patch does.

Do you need to check if supported_xss is non-zero in kvm_probe_msr_to_save(),
e.g.,
        case MSR_IA32_XSS:
                if (!kvm_caps.supported_xss)
                        return;
                break;

>
>Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>---
> arch/x86/kvm/x86.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index e7f78fe79b32..33a780fe820b 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -1454,6 +1454,7 @@ static const u32 msrs_to_save_base[] = {
> 	MSR_IA32_UMWAIT_CONTROL,
> 
> 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>+	MSR_IA32_XSS,
> };
> 
> static const u32 msrs_to_save_pmu[] = {
>-- 
>2.27.0
>
