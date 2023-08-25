Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D063788DAC
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 19:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236734AbjHYROj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 13:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242699AbjHYROV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 13:14:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFED2120;
        Fri, 25 Aug 2023 10:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692983657; x=1724519657;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=dF9pzKQ/J2QOg9UjZXhP3AbE3RcdvN7Z7FcTjfSjEFE=;
  b=WMC1rW9jiNwWwPeH/mSKTAE8YZI61Yh+fUCIQxW+UJaZgyeMD/tnWbH6
   yCG98/sk4udrClltkkgXVXCyDgvR5efpteaZgIA5La4ZNH7Gc2M8XUbqE
   tNDMCwerfrKKk27t92oGQYZvMuYDYQamVe0pgLxg6fSqyE3FbAnyA8b5m
   uNRgkdoN5LSTYmILNdZRnjP0bSolW5GEDOwCxqKwdXvHhNeRmax+s8AFD
   IVqQvvFgkzgUayuArMPWKU2FmMr7R///2YIO+pjXuELimoY3VlPyyvsrR
   rVHF/lgaxRIdnBHJ6WDM5ptkY+pZN2QRfEFAsjIo/ZDajQxbAVHzRNWoD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="354289177"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="354289177"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2023 10:14:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10813"; a="803041369"
X-IronPort-AV: E=Sophos;i="6.02,201,1688454000"; 
   d="scan'208";a="803041369"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga008.fm.intel.com with ESMTP; 25 Aug 2023 10:14:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 10:14:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 25 Aug 2023 10:14:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 25 Aug 2023 10:14:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 25 Aug 2023 10:14:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HYUGB17LcZBXMQolL2eQzIW94o7ch9kJxdNXsn44jimmOQvhkXhr5hmRWOl1xe9HWwZGZymmXsHumaRm6K0myzhLuoZlxZBax+bTXI+YW7I6aEi/3YCWnL+RTcHrsEyHSXEKY+nGEd2XE1arxqGRJwHY5LQK1lpDvhumJJyhpLiVqeOR6/w0zOUec8mrIduqqiz1/wxJX+YaYxOnCqhdiYy8JVTSIQk9Ek3cW4ScMnmCbRB98QOCbk6sKqsNeYItDeMwlNSQyDujLvc/WuYTVIEItvZDU8Iu6r+sgynQXMQCxel0CG+WN6o8NWRKuT8fByZNPu07LsQoJ4HGnQ84rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dETvMoM3++42dFElHG8myZ6c52jMlbwy9xcXw2vanp8=;
 b=K3Kw2EeyAuuT/rmtHFRaSe6sS8w9WrC/X10MqkaNsqKKtPfD+WBl/pfnPhtrwKzaSYdJiJdaw6RclJ6xseMm7ZcLiJDusL/KzSDwcgiCqZ6bmKRpwWGKEyakp8+YhsZha5xTD8Q602QwvX50XcLWWyP0FkCeYCkXt4KLorJtMFYnEX5Gb0DDVjjrpiqRhIAaZ4v12RIY6DyfrRHiRmm1YpJtLeIPRvQIpXT4pIwr1zOaItbExyEmWmhZrltLY2Su2AY4VsFX4BY2S/rHwTDCchig6Ycq/4/HWJF/C3KwgM5kRVNLs/xlGASV+7TWdT/tYBLxDqpO8gbg9Ym3umONuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM4PR11MB5390.namprd11.prod.outlook.com (2603:10b6:5:395::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.27; Fri, 25 Aug
 2023 17:14:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::47e:3e1f:bef4:20e0]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::47e:3e1f:bef4:20e0%3]) with mapi id 15.20.6699.027; Fri, 25 Aug 2023
 17:14:13 +0000
Message-ID: <96c2ee7c-b74b-fa38-e9c1-debb4eb71e8f@intel.com>
Date:   Fri, 25 Aug 2023 10:14:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.14.0
Subject: Re: [RFC PATCH 2/3] vfio/ims: Support emulated interrupts
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <cover.1692892275.git.reinette.chatre@intel.com>
 <7a08c41e1825095814f8c35854d3938c084b2368.1692892275.git.reinette.chatre@intel.com>
 <ZOeGQrRCqf87Joec@nvidia.com>
 <84629316-dafa-9f4e-89e9-40ccaee016de@intel.com>
 <BN9PR11MB5276D9778C48BD2FD73CE9658CE3A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <f46f44cd-2961-7731-d5a2-483c9e5189d1@intel.com>
 <ZOjd+7TxunlKSjTA@nvidia.com>
From:   Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <ZOjd+7TxunlKSjTA@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWH0EPF00056D0F.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:11) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM4PR11MB5390:EE_
X-MS-Office365-Filtering-Correlation-Id: 356038c6-ccd5-491a-780a-08dba58eb49c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 30NhnVhuFFX7mGnpN2qn2E+FVvQk9ao9/yFpbGRHldOCPZ8KAj/sbKUI31DqImLo4eVDe/bDaOYSEKsYr3lcyOGDrbG2Z/Lw0ip4QiYXCDW4ygSDjwUpRBSz2bILk9OEgF2Hl+u2skNJVFcGzJBLst6vbyGS6joqiu703yVFJimn71MYTH0TFczNOcgfcbFNJN3ZJvlio9SZx23Vh+6IpdTKa1N+AHLQUhE2SFLI3+vLjk95h1IIfieJm2lAi8jcrZKbOpeGMYQGYcwf5nZEmxUCGhLWWRY/wl1gbzlWzkx1rTW9HeiXDcYCUOZyc3Y9+PeRIN0Vp8o0prFyYVtUJNlHCBYjJcPEEbP8eFgKS7ffBqQXwZKTt/7eSONx5yHegldhH2UcCpUw6FiXQ6XOdgnTAvmhCqqt+cWQkI2VRo+iO0TcIKhrykfcUgTHk3Nu19WX3j4ZYXTw6MKstAJ9TzRMELN/4s5xnzwJiPyCIHbJ01fZzx1TCwwlCNpjipntmEf1/X9W8S7TySQyqYYFPVFsoWnqiIdm/WELYbPxDlOs2AtpZbX58SbOmgzVqrrNK5KtiCfIpvKedDCCvlW4eV6OfChS++V/4l8zW6F1htL965In2Dcz5WlQFCU2l/LTYeHNxtJvkYWSUSZhjJGDzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(136003)(396003)(39850400004)(376002)(186009)(451199024)(1800799009)(66476007)(54906003)(66556008)(66946007)(316002)(6916009)(82960400001)(478600001)(26005)(38100700002)(41300700001)(6506007)(6486002)(53546011)(86362001)(31696002)(2906002)(6512007)(31686004)(4744005)(8676002)(8936002)(2616005)(4326008)(5660300002)(44832011)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UFpUd3hZRGNiR2RJd1JCNFJscEhoVUlSVE53alA3RXZBV0crcytKNGlRemdm?=
 =?utf-8?B?aUo5a0YzNWNkNms1TG5LbUNDaHhxbGxFcUQ4NmVRTmtwLzEwMWN6UFVlVFZu?=
 =?utf-8?B?S0wrbTFhelNDODdPdUVpd3BnQTJMbkE4S05LRHk5RUJOZklJejVKdlpIeTN6?=
 =?utf-8?B?dVcrUnZMVEV3VWRDQVBJK3V2cnJYQmRNNWVubkVSeXAxUmN3MHZoR2VMYkZY?=
 =?utf-8?B?dnFEUUg0MCtZR1hwejNULzM4cmRveVMxVlIyRGxpY0J5cFRITTdxbGE0c0Fo?=
 =?utf-8?B?M2ZlNFFjVkZJQ2luNXJTYjQwNEFFNGhvN0FrdGhiOHRMYW44S3lZMTJ3L1pG?=
 =?utf-8?B?cGtnOWdzRjdKU1BNbk5EMTVvVmFoMHBvYjhPWERBelBidHBRUTdTZWJMNzEr?=
 =?utf-8?B?REhBY3N4ZDBoZXVWUU1FVVpBMGZHYzVzdm54Z1NNbmRISzd1SGNzWFZ3S2o3?=
 =?utf-8?B?Z3JuSG1NcUVVWm5ZNXgyQ0FnR0JxcldUUEpUSmh5T3JVKzdRY0k5QTlWTUha?=
 =?utf-8?B?dXFjQlJrT0l3YUJMd0MrZHRYRUVqeEd2OGdjRG51SHNmaU5ZNDR1ZWJlSExJ?=
 =?utf-8?B?VlJMSDY1NGtSd0ZIM2l5RlpLVlRERHBaemlOVFpXNzFwdDJIV2srQVVxay9G?=
 =?utf-8?B?cmJMV2pZTHNnM245RmFBTy83dEt5OExZTWN6cWpKQkRicHp2blZNL250b1NN?=
 =?utf-8?B?cGU5dnNTMnVTc3UyV2VnNkl4ek9OZzNLZjdiV3l2SkwzYzV6SWdXYUM3dC9a?=
 =?utf-8?B?MEVvSmJJUzdjenJJdVZ3UGhDMWNQRnl0TmJuODB0aFA1OS9SY0VPdzVoaEVx?=
 =?utf-8?B?eHlUbGFBVEErSkZsVkVnUFdZbVVhUTcvd1VkajhWaGRmelVHbWJER3JxZjFZ?=
 =?utf-8?B?d2RRdEZIdFN5ZzZZVkpmM1FSbTB2YUhldzI2UXZiTjI5ZmY1Y0tVYmZHQXVu?=
 =?utf-8?B?dW5ML2Y3dHFDSmNqQ0ovNXlvVFlsQU14ckw0V1FUKzhuSm5KM0o4RythendW?=
 =?utf-8?B?cFl6cUVGZmxySDdQdm1VUVdUTDNQZTNsSlJZeHRqUVp0YVJseXdIdHlKRWZL?=
 =?utf-8?B?cmZQMVZBTVpsVm8xUmhhUmlyUnpEcWNocVJCNWNXZFBqV25iWXp2Um5mWjhF?=
 =?utf-8?B?MS9aenFYQi9PZElYd29sYmJlMFowVGk4YTlWWVI2NTJLZXV1QWtRS3I0d2lr?=
 =?utf-8?B?cEVjNnpzVEtOeEg4R2xKczhFOVlWV1JwSytiaHJNRjlwUUVkbVc1L29HbW81?=
 =?utf-8?B?b0E2WGtjUE5hRFl2NGd1bnJQUDdDUEE5MFVXYnVlMXNCd1dLcmFYeVFwRTY2?=
 =?utf-8?B?dmtIMXpEZ2dPaFdBY0tLb1h4Rlovd2dXWFNuYzNtSDkvQ1luRWNRNkZFRHpt?=
 =?utf-8?B?UnFwV1V1bG1lMnFuY3JYa1V2L3FmSXNkSXhHSERrWjdPTjMyQ1JkQmZqa3Iw?=
 =?utf-8?B?QW5JbGN2dW1meFBCSFRETSt2UFMvN0pGRW02MXlrMGFZQVJKM3ZJbWdXaTRy?=
 =?utf-8?B?akJxSzdNSWJRZTNxTWRTeHkwWTB0RlF4RnBNaTUwUEJ3cW9kVWUvbUNjMlNX?=
 =?utf-8?B?aVpYUHptK3BMc215cnRkNjNKbTdaczVMZmFnNzFYd2VPRFBTL0QvZHBvMEFR?=
 =?utf-8?B?amd4a2ZOVmc0SElVNmNtR2Z4VEM3SDM3Z015NXpaOUpPNE9sUXpEeDdxQkc0?=
 =?utf-8?B?cktNenpMV290OXp5ZTFVZVRnaFl6M0ZDM1V2OGJ5Q0o5ZTBzeFRpR0Uya1ha?=
 =?utf-8?B?cWdiNjh6YjZKYk9vVThGRVB1MC9LNUZwM1F0UjExZVp2WWFLck5mZDZYb1pG?=
 =?utf-8?B?VUtBS1dpcHNEUUVRUGFLZmYvZlRZYVk0ZEc3OG9TZ1NrVjVKOUgyMVN3MjUv?=
 =?utf-8?B?RmhyUnNDYnBEVFA4YjhXbThVMU0vL0QzakJiY2ovMUtwSmc0SWZqTGVDOGwx?=
 =?utf-8?B?Tk5GY2kybXVycTVuVG5HTFVCaFFERVFFRkN4VGVvQWo0RG1iaU1uSmFaRTVY?=
 =?utf-8?B?eVNuemxSeVkveXJEYTlHNXVKL1FnamFXMXN1REFjTkpPbDRTQmNaZEdDc0Rx?=
 =?utf-8?B?bGdXK3pIY2ViZ0F4blN4UTErMVVTeVZYRzVyZEdNTXczU0Y0VnRpdlJJOXg2?=
 =?utf-8?B?UEZOLzg5SHBMMk9XNFhveWVIZGg3dnlpZExGanpDb3h6NGQxRXNZWVpvQTBJ?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 356038c6-ccd5-491a-780a-08dba58eb49c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2023 17:14:13.8300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2p/tkV+jK2tD+hXLR+sgAnaHU0sE7hcjNxyYLtn3cc3iQCYdKEkmeeL9tqks7AE6cIZnUQ4QKMTgi8+uKYr0G9DYo3InuKYrnFnYEd0KjQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 8/25/2023 9:59 AM, Jason Gunthorpe wrote:
> On Fri, Aug 25, 2023 at 09:55:52AM -0700, Reinette Chatre wrote:
> 
>> Thank you very much for your guidance. Instead of Jason's expectation that
>> IMS would be a backend of MSI-X this will change to IMS and MSI-X both being
>> a backend to a new interface. It is difficult for me to envision the end
>> result so I will work on an implementation based on my understanding of
>> your proposal that we can use for further discussion.
> 
> I think the point is that emulating MSI-X is kind of tricky and should
> be common VFIO code, regardless of what path it takes.
> 
> So I would expect some library code to do this, entry points the
> vfio_device can hook into its callbacks (eg config space and rw of a
> page)
> 
> Then the other side would connect to the physical implementation,
> sw,ims,msi-x,future
> 

Thank you very much Jason. I am thus hearing the same from you and
Kevin. I'll work on this.

Reinette
