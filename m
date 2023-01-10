Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A23B1664B03
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 19:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239417AbjAJSip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 13:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239517AbjAJShu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 13:37:50 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E69983D2
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 10:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673375585; x=1704911585;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0+pzuM92C5hOmggpLtihy1+9vjoJn/hkSg4PnQeGym4=;
  b=PEFT9752RMCgvA/hQyTzRwIsp7b8H1x+xrRMLO/NFrcRVJ72sy3WY8Kw
   vNzwDp1grVnoel6P+dJ7lW6di4WHdSfQ/VIRxtY7cHvA01BUkXBUL7wlK
   WG1S4XUHd6POXYNUidODFdkL0JFfHh46WOKBhydt8g1g3ou53xoK4LPSI
   Jv2TJhZLm0Aoz54fSpS0TLHXQQ1uXr1BZqBT9LAbrsedZorZ6VYJNKRHZ
   evdfnO6p2ml8xs3hdiFog57HEM1xRGVB81v4xOCaI6svK9G7jJUA79gsS
   aFVgy6zq5swpN9ngVvjmXbCWXjsegkUmQ6RG6ez3TOdR6VKZuKOIsmwpU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="385531917"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="385531917"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 10:33:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="687662376"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="687662376"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 10 Jan 2023 10:33:04 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 10:33:04 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 10 Jan 2023 10:33:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 10 Jan 2023 10:33:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 10 Jan 2023 10:33:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mG0Z2QuvhHFxoKolObKagnC91V5O/5e3QBajYCytPJNHqPr9iPZEJc4qufiykvBmBSGPf5wBvsaPN5naFlQJqOqn2c65kISDaQ8vQ46TfRS5jvzIw1JKodx74z/ZDsLRkv4t8cRMzpvnTRAqdPRy3u2jk0FM8AUfz68gcyow8RnmooEq6O85mDZx6pLav4M4wfi4zGhqU06PPqBAr4kmd8kaVDcgIB3pFzz4Xqqq0akc0466aSqmJeKlClpXoXOp9MvyBvPNVTpyxc/RxOUVxIwLEjzSP11NkTBmqqIrPqM76z0jsHqO+wRwjE1HL+0ci47IMDS3xiTYHTC0aaGYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJK+48zSL6GeSk81G1RtQBfO0iCExa/o2UmbSz70XOI=;
 b=SrV19QLN0JchIhqsSAX/wA43eqVF4daUNM98Zi1YfB8zoajF6s1XBJoNMMuwrymf2ZtjDFvqcaF005r5TRfgB4+nesd6xUbopPYwQK5RrPLLHxDx05rL/8BCAILAojON1nXHXNXXWsFqUck+ZTwo/hDvX/ymF2J4gEXqEw/KS0QZ76KA6RKXaegVGQ5rqAicxMBvDQ8KpDz7k89X8yuJQOjYR//e6gFxmQDEUjYF2Dy+yZvKotStJ4duKSe8J/ItsiRY8KIYspCzucOObUMxwYWBldoP0NPr8O5amj66vvulTvFJX6mkODUMj4u/3wZjnlscnZU0Dp5i7Qon9Uqctg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by CH0PR11MB8213.namprd11.prod.outlook.com (2603:10b6:610:18b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 18:32:59 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 18:32:58 +0000
Message-ID: <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
Date:   Tue, 10 Jan 2023 10:32:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
Content-Language: en-CA
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0037.namprd02.prod.outlook.com
 (2603:10b6:a03:54::14) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|CH0PR11MB8213:EE_
X-MS-Office365-Filtering-Correlation-Id: ef8b5ab1-8b2f-4d3b-3556-08daf3391925
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GrTrquWOE2v8DLqWx2uoBmpxQdST1U/JZI8m/C1gFpYSrIPymY9zRH04m4gl2BqZ/hHfAwzp/jAwQwUqtKcemsQAlbP4Xj33JoXdcfLJ4WTb453+AHO3L1occakWnIjSzMsFSh2k3JexJ95xucxyf2CZXt9sMualvWdyuSEUZoRMDuzr/NW8/2cGIocsR91NbLC6VvHvnd0YIEOJZN59YZbpovvkkyLQD/NbYybnaQfYhtVRIojfs5PXRz7qnwl3slzAVHMI3LcHuTCTn/SKiDBgCYM52K6rTcwMT2Hpppn0U6rEUGaL+EEBhLWDOg+dEjkbsmvBBpxTV5iSq8yuiXIsSI9h8i9KsDamyKZ5vD2aTKBX6omPmnSSFJoRXVLQb2ftgjBOXXSZ54WcjqftS6jL8m5lRoDPsNLAmyYMxRi4GKD6tr7akYYS0SUQpC9pEoVH7LyjSZgbHvdXh3na7ssGyqYNAY/bvUSleD5Q4S8XboqXEXG/QJ9dy5FIBTa5Z90mXRIFAlys+0tk2ZeOCGQiSq4MYNtaNVLy+uyrhnOfOnfRzQWHB2UhfJUed/QqCDGTm/8H3Y2c3CQ9W2rpwd9t7bABXndK7CrgdSEQPcGZgtEFLorcLtA+PCx9xZeBOJhUyuZpd3BonCxFs5I9BikU5t8SlKizrYDUh0EAnebHNv9WwMM5iQO+rQPO5JxjyL+cF4SOexZZTTBVNMo84YkPt+s0XSNLVSBD1skXqD9Q7OfwmvVcJpU7O0XzXEj+w+eF0c6e0bLOqI0hTVjRT26HsRSHLx1SfXY7wGKdWn4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199015)(31696002)(36756003)(6506007)(41300700001)(86362001)(53546011)(31686004)(83380400001)(478600001)(8676002)(966005)(6512007)(5660300002)(82960400001)(6486002)(38100700002)(8936002)(186003)(26005)(66946007)(4326008)(2616005)(2906002)(316002)(66556008)(66476007)(54906003)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEY4TjJuTGRBamxJdjcxNHJCMk1yZnJISWt1ZWZ6c3VzMTk4c2JWNGY1aWVZ?=
 =?utf-8?B?ZUZuZXJ2NXhuR3VHNkY4TTRucmdBNXRyU0NaRnArNzRsS1lTbGlKT0IxQlBN?=
 =?utf-8?B?YkRtcHFsUVVLY0ZmamkxTTFYUHRkcGMzaGY0ZloyVCtPenJ4K2FvOTZhanNE?=
 =?utf-8?B?U3I0V1R0N3JUbUd5ZHpvSE5nVGJncnZpSTdCdWZiQTAzZS9wVnJaZUxtVzhn?=
 =?utf-8?B?REwzbU5DeTk0b2pRUXc4TzYxQVVtdlgvQWFMZGdMVnV5dEUvRjJTQ1hFdlgx?=
 =?utf-8?B?NXZOKytibVNnOTliaFNRWU1UUzFtL3U1d3ovWVRQSDNWWEVmdENreCsxZVdo?=
 =?utf-8?B?ek91NENvYWxrejVuM0paYnMwWnR0M0FXbHkwdDlFemVOb3lMN0tGV0NrQUJt?=
 =?utf-8?B?TXRNMFJuenhqOWV5OWFrd0ZFTk03cGo2YzdHeEhLUUJHTWk0WGNtaWQ3ZnZD?=
 =?utf-8?B?N3lQeWpMQWNWeG5JcDJjamlrZWtuai9EVFZXUDZ1NHZGR3kvT2l1LzQ3cUh4?=
 =?utf-8?B?KzY5aXBaYzV5aGUvbHgrSmduSnJoU3hIVjlYRmYvOG9JSktYZUZNcldtZTV4?=
 =?utf-8?B?L2hxRVF3bCtpTmRzY3JtWktFbkVHNWs4dHBubTlzSmszek44SFdyTUkycVc3?=
 =?utf-8?B?eVplT1lrWk02a0ZHOWtrbTk5Q3lMTjBkVStNdXkwMWxpcm9xT0VPTVkxZ2tN?=
 =?utf-8?B?MkJ3SnNRazczSlNucVo2NEtKZllkRE8rKzZQZkRaVDY5UFgwT0NnSzFRcFhJ?=
 =?utf-8?B?TzRmNzBack9nUHR0UWxFWm8wZnBhTU56ckdBRnlRYUdMcC8wU05lLzYzY2Uw?=
 =?utf-8?B?WlRuVXp0MzNwUitWTE9nSTZjN2RWb0VhdDUvdnZ2eTFnd244S3BUUWpSQzB5?=
 =?utf-8?B?VGt5OEw3MVN6QldCZnZHWUYxc0NDQnRMS3ZjZTJVK2FwRXVWblNlUHZTR2Zk?=
 =?utf-8?B?cnE1dWk4OWpJaEV2aXlKeDNnTHVvL0IwMGdmV1FlcmQ1ak45SVFGcnFGTGdH?=
 =?utf-8?B?UXE4bTBxRENmcDZRdUMwUGdmaHowdmxRZ3JSQnpFcERKYUZzVlFTVjltdGFZ?=
 =?utf-8?B?UVF3cW5aQlIyMzBRd2wwMnpmU3hFR2ZqM1VKL0gzelN2WFNHS0VqWFhoN2RS?=
 =?utf-8?B?cDFFYUlsZWhpR25YNis3MklqU0c3UWdNRVh0SldFVHVUeUg2MWhRMDc5b3J4?=
 =?utf-8?B?eEEvZHVtcHUwZzJKblU1SlJHT0Y3NTZFei9OOHBmS3h0OFFKdDN5S0sybnFk?=
 =?utf-8?B?Ykl2MVowZnNVUW9rNVJtNmd4YUFzWkFMWEVpYmlaZEpaVjMvaTZhaVdtRWtW?=
 =?utf-8?B?aVNhVXdmKy83azh0SzBmT0cxVHoxRlhzbVFtZzFkWHZPYXBZSEpxbHhpazFJ?=
 =?utf-8?B?WEpZWndFUHQwNFFsVlZpdHF4Z0NmZ2VLVWJFRXY3MEduMlc1ckdqcGNneSt3?=
 =?utf-8?B?T2U4dDhJR3ovaXozdkgySFZ4RHpJRHQrRkxOUHdqZTkwcTBQM1RjTVFRZWhS?=
 =?utf-8?B?dUo2dnFBK2hGdWZpUDhJUVluY0o5K1U0eXlyRE1Cei9hVktQRmVIMUZDY0Rm?=
 =?utf-8?B?ZG81QkN3RmhjUTA1Um9UZUZxQWlJYTZobmovUGVDekpqSUV4akNTbEFkNGIw?=
 =?utf-8?B?eS9GeGM0WXZaU1JCN1VWaHFaZUN6Z1BoREk1NTZSTGVTSXgxMVhUTXRhVEtC?=
 =?utf-8?B?SlhKK085RHh4M3Z6ZzUyUVVuZUlCZFJCYUpZdzZPUjlQTStVZm1XaEs2MDZh?=
 =?utf-8?B?eUN6bVBZam44NFc2dTJpdmJRK1NlZGFFellzcDJxZlNZdnpVdndCaVp6UXo2?=
 =?utf-8?B?SXMxWmE0Y0MzWk5waFh1NHpwQlRsSnVINDRKRUhLenVLTkcyYllabEFaWXlz?=
 =?utf-8?B?Z2JJSmJMb0o1L2UvT1FyTW9hUVlCTnBrb2FoZzVJeGpCZHRFS3k3eHpUdERD?=
 =?utf-8?B?ZHRJV3M5Rno3dGd2TTNxQ1VKa0lGdGNjUlVlVkM2K1k2bythZGhmcXJwWld4?=
 =?utf-8?B?Tzc5UDRzY25kMHMrUHFQcmJ3clZGdy9HZnE1MkpMbk8vcFp2eVp6Vk8vQTl6?=
 =?utf-8?B?LzdIYzE0Sk1LSnM4QlZPbkJ0SExoU0ZiQThYRk11R1E1cU1GTFVHMm5BWERI?=
 =?utf-8?B?eWJJQ3JRWG5hVXZMOVd4TFZmQm5jdFluMkNlUTRnaTRDVllIV01UOWVGM3Q3?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef8b5ab1-8b2f-4d3b-3556-08daf3391925
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 18:32:58.8931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4I7gjD51IdHjGfsrLnt9alQ7zM2hOX1nZSDXOe1LhGeXFAK6ZJ8DD6oo/BWZfBbHoIly5gzVrrRQ0+LGXnipesQS24ogfEw1bqxZx/GAF20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8213
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/2023 6:49 AM, Aaron Lewis wrote:
> 
> When I run xcr0_cpuid_test it fails because
> xstate_get_guest_group_perm() reports partial support on SPR.  It's
> reporting 0x206e7 rather than the 0x6e7 I was hoping for.  That's why
> I went down the road of sanitizing xcr0.  Though, if it's expected for
> that to report something valid then sanitizing seems like the wrong
> approach.  If xcr0 is invalid it should stay invalid, and it should
> cause a test to fail.

FWIW, we have this [1]:

/* Features which are dynamically enabled for a process on request */
#define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA

IOW, TILE_CFG is not part of the dynamic state. Because this state is 
not XFD-supported, we can't enforce the state use. SDM has relevant text 
here [2]:

"LDTILECFG and TILERELEASE initialize the TILEDATA state component. An 
execution of either of these instructions does not generate #NM when 
XCR0[18] = IA32_XFD[18] = 1; instead, it initializes TILEDATA normally.
(Note that STTILECFG does not use the TILEDATA state component. Thus, an 
execution of this instruction does
not generate #NM when XCR0[18] = IA32_XFD[18] = 1.)"

> Looking at how xstate_get_guest_group_perm() comes through with
> invalid bits I came across this commit:
> 
> 2308ee57d93d ("x86/fpu/amx: Enable the AMX feature in 64-bit mode")
> 
> -       /* [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE, */
> +       [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE_DATA,
> 
> Seems like it should really be:
> 
> +       [XFEATURE_XTILE_DATA] = XFEATURE_MASK_XTILE,

Thus, the change was intentional as far as I can remember.

Thank,
Chang

[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/include/asm/fpu/xstate.h#n50
[2] SDM Vol 1. 13.14 Extended Feature Disable (XFD), 
https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html

