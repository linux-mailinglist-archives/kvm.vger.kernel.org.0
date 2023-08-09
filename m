Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 490827750FB
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 04:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbjHICjb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Aug 2023 22:39:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjHICja (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Aug 2023 22:39:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E49D1980;
        Tue,  8 Aug 2023 19:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691548769; x=1723084769;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YOwcLlC0YVUlJqmgLjhuJwNEJe82E0OAWxwh/WhTp4c=;
  b=O1sonyPyK6aiU+AJBmBXp2c134+hxxBUOJT6VIXUMplf0USVjJJxIhYS
   AXBhIIUWbPSTkJBkaFsVRks/GIaWT1/fH3ATqF/m12F4aw8S6tw6eb+vE
   1GxtE9SBAwAfNtJwXWwT5f4/DQuUZKtzIdsVhTVKWeooIUhhQjpv0GaCw
   sG5zObFZ2VswT0jbsljAGJ9NndKLS6wz3lTfK3o5/upcq17ZEyF+gCP/E
   qyzHyfgUK/51dDcOdZs+0ngP3lBVnhzd18iFV+KazCyJ5C7ON/amjfsLn
   pqvHdIcp1X1jF/2IxrzlP9D38AgQITqiBXoNTl6wT8jJKXMr/ZlemXNGq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="355969563"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="355969563"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2023 19:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10795"; a="725186630"
X-IronPort-AV: E=Sophos;i="6.01,158,1684825200"; 
   d="scan'208";a="725186630"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 08 Aug 2023 19:39:29 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 19:39:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Tue, 8 Aug 2023 19:39:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Tue, 8 Aug 2023 19:39:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Tue, 8 Aug 2023 19:39:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmlX21ps4fuH21VSv191CDLAbnXX10JqsHa3Vhx8JkSDb22SBOVEHEK8XRQfao0QKphFNEh9o8yqDqx3yKXLUIA2pVU+wDOQKl+axLBF1eVo/dJFkG8rM4oSojRvoIBXNAZ558NnC/BwO84NV/81V2KRij+p12ziyT2bK/q/KrPjNAKJHyOydymmaZNZvueZ7piC+sV5azfvpmDNQuXOe8oF4/EdfWCpA7TlQImf8N57y0yYUOOxwb13LA1fbZBaG1aPYQYP7hn9aZKlkeSTarn/IdTtvWRgQMbf3OC+DMvuZ5EfNZleCyAk/vXLuhziWH12N5L9CeJi2NbsqLNiUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=28onESP9y6dOvN23mX9/SiGpXf52A6fb2/b4YCPHy60=;
 b=JATC9blc3S3DwYiOdrFWhxUInfMRiJZg1NEi1ZvGlTXpYJx1/lCUSStOfE7lmvD3YkELAy730AqwUESLkbBcmixWCDjo1PpEjfG50Nh/Iw4syIzn6rdkvGrjBDC2XphDGX2BzmjN/1ONaCwnAgfVMnnG/WIPurswHPP2MJYJ8Hx0oPbp2p0WRDPicwPCxk7qz+mAcVQcUkfdA2QhVWB5q0GlIakprfoe9BcrVzJy5IwGHcY30XFRxYsteCL+kFt4JKA5FbOwI65hnoO0TZVCOn3xuJKeDj0fu0SFPEH45dnZqkmwvoHh3pYY/AIFks3dRRFZFv+UtFeFiwde00OQlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4920.namprd11.prod.outlook.com (2603:10b6:510:41::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Wed, 9 Aug
 2023 02:39:26 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::94f8:4717:4e7c:2c6b%6]) with mapi id 15.20.6652.026; Wed, 9 Aug 2023
 02:39:26 +0000
Message-ID: <4826a406-c06b-c383-9e1e-60916b24332b@intel.com>
Date:   Wed, 9 Aug 2023 10:39:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v5 09/19] KVM:x86: Make guest supervisor states as
 non-XSAVE managed
To:     Sean Christopherson <seanjc@google.com>
CC:     Chao Gao <chao.gao@intel.com>, <pbonzini@redhat.com>,
        <peterz@infradead.org>, <john.allen@amd.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rick.p.edgecombe@intel.com>, <binbin.wu@linux.intel.com>
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-10-weijiang.yang@intel.com>
 <ZMuMN/8Qa1sjJR/n@chao-email>
 <bfc0b3cb-c17a-0ad6-6378-0c4e38f23024@intel.com>
 <ZM1jV3UPL0AMpVDI@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZM1jV3UPL0AMpVDI@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:3:17::29) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: 71cdf8ec-ba03-4255-c4d8-08db9881d905
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FT63Jmdv3sXN4xKCx56aQ7kLXgqbEaHZHjXpuiCFfNVGELT5UlR6PUS0Ln/nQz7El+mz/NoFrUnewc2xG7mPjQKqW4ZJ89dZJhz+uZ15P2uioqnchSiAgoPQFG+s6RMmgVQByTBuqmjZn+dR/MrQSyBVZvb9jvJ7WGdyzMJYAxz2Vl0Dg1egiDpkA+GihRBgYQZwiJCChXOOQzWvlR2u1NnhJH9sGqvWGmRo0HOlQhp+RMElw7T8iOKNWBlsZRSAmaZPkvEAHG+uvZNmXDUfqLbmUTYOYh3fPmRv5uI7oilnmEwny6/7x6MyOxF+j/dTz/ayNk3Rw5wOMFvUEct0Lsk/0lboNgBWXLsxLXmqSzCG9Wvnf/yzKQh42h0J3czqNO0guq14OObtIqhkWjpjji5RVhJt9EHQcXEo2xm9+o+5zIJamFsN9OqCsBVaTZB8Pfx60RVTRVHZ+uk/W+Haab3j2TQ2O4KsqNWTIz4blE0OBqTeslQeLHdzA2u6HqgdWMxPYxBDI5ecb2Uyl1VfMVRyNaqJgwSZln7qDcur80fhNd4NZBNJzKVmrqE18VsCPPB9QTgqAfNS1l/QHhw0mGb3UFAtXIkkQHdEA+EPDpmp/wv2A+NPOAWMHfvvLeymGbps4mGtgS8Yu7Q9MfBAOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(376002)(396003)(39860400002)(136003)(186006)(1800799006)(451199021)(53546011)(6506007)(2616005)(36756003)(26005)(6486002)(6512007)(6666004)(31686004)(478600001)(82960400001)(38100700002)(66556008)(66946007)(66476007)(4326008)(316002)(41300700001)(66899021)(8676002)(5660300002)(8936002)(6916009)(2906002)(83380400001)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmJLRmJJc1FWTVhjL2NMdnJhOGw2b21WL3YzRlBaMFl2SDFMMkZGMXl5a21D?=
 =?utf-8?B?REdpem9aZkhUWXRkekp6Nk5TRElrZDJJTGNoQ1dLVmY3cUVuemZaRDVRcEpk?=
 =?utf-8?B?SmFBditOeXROdHBDd3B6QVordTc4Rzl4ZnlHc1BRM3lWREYwUmdORjJleXpO?=
 =?utf-8?B?a1NDQ0YyU1o5T3JwdXdpK1NDMHY4ODR2UTBrYlI4OE1MUWZLVG5mNXJSMmRr?=
 =?utf-8?B?ZDV0YzJFVlBYMXR1VG5UbHJ6SmpnTjhKSnBwLzMrTEo4bUdWU0psLzBPT1dF?=
 =?utf-8?B?M1ByamRjTmhCa04rdTBVK1J6bkdFRkQ4TGprNkNyblpjSnJaam1MUUZDVElC?=
 =?utf-8?B?Njd6SXFkc3lSRTVISGQ5VDFKNmhjcTNmSFJFRnlnQTV4bVAvMlpnYmk4Nksr?=
 =?utf-8?B?KzNlcyszcGNPSk5pUzRGdEVoaEdNMlZ1TXMra2poR1Q0emZCRTdlbTg1M1VS?=
 =?utf-8?B?dzMrVi9kMW0rVzM4RXRvWGlBOTZkUGIrWXIzdlhNNFcxSzNvdVNydlErSDlS?=
 =?utf-8?B?TkRlQTNwc29WakNQcW44c3AvQ3hYTUdKSVhpekpVZFNIYWxZeWpGWGRqdG9l?=
 =?utf-8?B?RUt5WDRpeFVRcjlQN3dsK29IbTJUNlJyVUZ4ZHQ5Z1BKak01NnNsRnoxY3kz?=
 =?utf-8?B?eWVrclZMSWZ6bGZBZ1NMblpwSCtSTDB5UDA5a2FDTm8vR0xRRW8ydnFtcEJT?=
 =?utf-8?B?T1l4UlV2WnlwMXIrc094ZXZIV3RPNjZqd1M2UzFlcDd1UmprMzRGdUJobFZt?=
 =?utf-8?B?ZHlGTS9JRHRyeG5hRGk0VzlPcUl1ajhUYi9KelF6czN1WmpEUTd3M0RkV0lZ?=
 =?utf-8?B?MnF3TUFhb2kvYkZod2FyRlBZbU9weFh4b1pQTHRiRFI1UXU3WlF6T3JBcWJK?=
 =?utf-8?B?aC9LeEJhWlNGWUp2VzBrYmYyVGxWL1Mva2RpZUVXYTFLUHN2WDU4U1h1NTRB?=
 =?utf-8?B?M0JiUFp6MEc3ZGZwMWM4THM2cStwQWVjNWhISzJDR3duaFoxbDRXSWNGUnV6?=
 =?utf-8?B?eWtUMlhma09sY3pLR0t5c2dVMW1LbnJiODJNOFI0Z1FFazVmSWdMN2NCenBV?=
 =?utf-8?B?ZzNwOFdvMmNLV3JLRlNFOVhWVHhScWdvcHdPWWpIYXdQWTVLRzFLUlVpdVZm?=
 =?utf-8?B?OUFWSjNkamwyUHJiTVFLM2JZeTkveFRNQWlqc2pDSFY5ZWd1RGpCSk1CRDMv?=
 =?utf-8?B?WUw5UjVPamJhUnpwWnUyeEdHTDJPY3p5aWlhRjQveUhIWTBMOFR4cFRPaHl4?=
 =?utf-8?B?ZjRtUGdyRVBlODhHc0NRWnZzc2ZEN3ZXaWhqT0dFUkZVYzlvT1pRbWpmZHFt?=
 =?utf-8?B?em9ONC9CajJDZ3d6MVk1alc0amQxc21jbEsrcFNKWTBlUEJyRnBuVGpSMlQ2?=
 =?utf-8?B?MVJtRFRHcGFqam9OdTFFMURCZDdrMkhmNmVTdXpEVnF1TG10a21HUHoybVZQ?=
 =?utf-8?B?S3o2L3NwYXloMW9CUlRCMnY2YU1tb1RZWTBMU1pmbTFleWEweHQyVjZ5dWIv?=
 =?utf-8?B?TmlXUlVZL3hoUXBXNU1QUEI0UWhTZjU5Y3gwd3MwaUNrQzJ2RGJLZ3JuR0c5?=
 =?utf-8?B?M3VpL1JoUDZTZVRFdFAweElIYzh6WHBHTDlEYXE5Ky8xNFZjSFIyR2RNN0Ez?=
 =?utf-8?B?YjlCTXZpb0EwOWduUkxuV3NVWTAzbVgvdFd3S3ZTZHc5bTZhWEdQNHBHSWZs?=
 =?utf-8?B?SllaUythR3ZPakl6bUNYNTA1Y0lUUnN3dEN4d0VseDk2YlE4Y0dKMHNOS0Jj?=
 =?utf-8?B?enNmWkdka3ROd1dwRU9aUStMVENhMzdpZEZ3UU1tZ3BwcG5vcGpOWjc3UnlU?=
 =?utf-8?B?cHJtVkFMWE05QVBsd0tHM0dBSjJqV01uM2lJSVFxSzFpUSt4dmg1alFaMXFj?=
 =?utf-8?B?SE9WTkhSb0xvRXZyV1ZLZzNsK2V1VWVoNzBrWFptWmJzelZDbERwaUttampG?=
 =?utf-8?B?OEhlME0vYkt5d2oxbzA1NWMreVZRYTIzQTV5ZmxidkNpTWJDNHZMNUhBaHBH?=
 =?utf-8?B?d0xCVGxPOTNKanF3YnJyeGtoeUhzbXNDN0k1NkdMNmhNcjl3S1R1OGZoNGpX?=
 =?utf-8?B?NUx2dys3ZExOT3c0MGxGNW5xRGhOa1ZBTi9nRkcvQjdaeGc0UzU2QnlUTzNB?=
 =?utf-8?B?cmFjOE5abFZvS1kwQW9KaG80Zk9ka3o3TkhnVzkyaGJlalk5Q0N3bVNQbmdH?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71cdf8ec-ba03-4255-c4d8-08db9881d905
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2023 02:39:26.3772
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l5eGnkPMJL8dTD0KOU4CrYU6MD3lsaK2Nc1FJ5kxoC64ZyEN87sirqlpM4GjONLup1tPOcSN315mE5JGAUOMHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4920
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/5/2023 4:45 AM, Sean Christopherson wrote:
> On Fri, Aug 04, 2023, Weijiang Yang wrote:
>> On 8/3/2023 7:15 PM, Chao Gao wrote:
>>> On Thu, Aug 03, 2023 at 12:27:22AM -0400, Yang Weijiang wrote:
>>>> +void save_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
> Drop the unlikely, KVM should not speculate on the guest configuration or underlying
> hardware.
OK.
>>>> +		rdmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>>>> +		rdmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>>>> +		rdmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
>>>> +		/*
>>>> +		 * Omit reset to host PL{1,2}_SSP because Linux will never use
>>>> +		 * these MSRs.
>>>> +		 */
>>>> +		wrmsrl(MSR_IA32_PL0_SSP, 0);
>>> This wrmsrl() can be dropped because host doesn't support SSS yet.
>> Frankly speaking, I want to remove this line of code. But that would mess up the MSR
>> on host side, i.e., from host perspective, the MSRs could be filled with garbage data,
>> and looks awful.
> So?  :-)
>
> That's the case for all of the MSRs that KVM defers restoring until the host
> returns to userspace, i.e. running in the host with bogus values in hardware is
> nothing new.
CET PL{0,1,2}_SSP are a bit different from other MSRs, the latter will be reloaded with host values
at some points after VM-Exit, but the CET MSRs are "leaked" and never be handled anywhere.
>
> And as I mentioned in the other thread regarding the assertion that SSS isn't
> enabled in the host, sanitizing hardware values for something that should never
> be consumed is a fools errand.
>
>> Anyway, I can remove it.
> Yes please, though it may be a moot point.
>
>>>> +	}
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(save_cet_supervisor_ssp);
>>>> +
>>>> +void reload_cet_supervisor_ssp(struct kvm_vcpu *vcpu)
>>>> +{
>>>> +	if (unlikely(guest_can_use(vcpu, X86_FEATURE_SHSTK))) {
>>> ditto
>> Below is to reload guest supervisor SSPs instead of resetting host ones.
>>>> +		wrmsrl(MSR_IA32_PL0_SSP, vcpu->arch.cet_s_ssp[0]);
>>>> +		wrmsrl(MSR_IA32_PL1_SSP, vcpu->arch.cet_s_ssp[1]);
>>>> +		wrmsrl(MSR_IA32_PL2_SSP, vcpu->arch.cet_s_ssp[2]);
> Pulling back in the justification from v3:
>
>   the Pros:
>    - Super easy to implement for KVM.
>    - Automatically avoids saving and restoring this data when the vmexit
>      is handled within KVM.
>
>   the Cons:
>    - Unnecessarily restores XFEATURE_CET_KERNEL when switching to
>      non-KVM task's userspace.
>    - Forces allocating space for this state on all tasks, whether or not
>      they use KVM, and with likely zero users today and the near future.
>    - Complicates the FPU optimization thinking by including things that
>      can have no affect on userspace in the FPU
>
> IMO the pros far outweigh the cons.  3x RDMSR and 3x WRMSR when loading host/guest
> state is non-trivial overhead.  That can be mitigated, e.g. by utilizing the
> user return MSR framework, but it's still unpalatable.  It's unlikely many guests
> will SSS in the *near* future, but I don't want to end up with code that performs
> poorly in the future and needs to be rewritten.
> Especially because another big negative is that not utilizing XSTATE bleeds into
> KVM's ABI.  Userspace has to be told to manually save+restore MSRs instead of just
> letting KVM_{G,S}ET_XSAVE handle the state.  And that will create a bit of a
> snafu if Linux does gain support for SSS.
>
> On the other hand, the extra per-task memory is all of 24 bytes.  AFAICT, there's
> literally zero effect on guest XSTATE allocations because those are vmalloc'd and
> thus rounded up to PAGE_SIZE, i.e. the next 4KiB.  And XSTATE needs to be 64-byte
> aligned, so the 24 bytes is only actually meaningful if the current size is within
> 24 bytes of the next cahce line.  And the "current" size is variable depending on
> which features are present and enabled, i.e. it's a roll of the dice as to whether
> or not using XSTATE for supervisor CET would actually increase memory usage.  And
> _if_ it does increase memory consumption, I have a very hard time believing an
> extra 64 bytes in the worst case scenario is a dealbreaker.
>
> If the performance is a concern, i.e. we don't want to eat saving/restoring the
> MSRs when switching to/from host FPU context, then I *think* that's simply a matter
> of keeping guest state resident when loading non-guest FPU state.
>
> diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
> index 1015af1ae562..8e7599e3b923 100644
> --- a/arch/x86/kernel/fpu/core.c
> +++ b/arch/x86/kernel/fpu/core.c
> @@ -167,6 +167,16 @@ void restore_fpregs_from_fpstate(struct fpstate *fpstate, u64 mask)
>                   */
>                  xfd_update_state(fpstate);
>   
> +               /*
> +                * Leave supervisor CET state as-is when loading host state
> +                * (kernel or userspace).  Supervisor CET state is managed via
> +                * XSTATE for KVM guests, but the host never consumes said
> +                * state (doesn't support supervisor shadow stacks), i.e. it's
> +                * safe to keep guest state loaded into hardware.
> +                */
> +               if (!fpstate->is_guest)
> +                       mask &= ~XFEATURE_MASK_CET_KERNEL;
> +
>                  /*
>                   * Restoring state always needs to modify all features
>                   * which are in @mask even if the current task cannot use
>
>
> So unless I'm missing something, NAK to this approach, at least not without trying
> the kernel FPU approach, i.e. I want somelike like to PeterZ or tglx to actually
> full on NAK the kernel approach before we consider shoving a hack into KVM.
I will discuss it with the stakeholders, and get back to this when it's clear. Thanks!
