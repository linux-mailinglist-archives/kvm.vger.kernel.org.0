Return-Path: <kvm+bounces-372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 659517DEDBA
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 08:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 845DD1C20E9D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 07:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DE436FA8;
	Thu,  2 Nov 2023 07:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jiRp/mJb"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DB32D607
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 07:57:01 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA8E102
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 00:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698911817; x=1730447817;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Sj+mTAtlzHHiexUK9ebZe91uqgksWCD98hgLAnxQPV4=;
  b=jiRp/mJbvfTB0zInU2U4CxCZq+nfEyHHYFzqhICROr6uWEv6orqsx/c3
   fY9TjobR8cqa0665vOmKzGMuDhvafZb1w/TsbkrpdTmuTXqEXuep2is/+
   EYF9/PVDUPGSVINdq7SuLE8YbZKjLsw4V/A3PccUdeFH3RVkCtEzkJtPH
   F+LUSlUQQB9lD19W3gP/OySMcOqQtXqafqooGTWPZC+iI0E283KO6CDC+
   P2Ly+iRP3LL869QSHChrYbE03T9dTZ5iTIv7W6ryx9IS4+G3AnLx01GsY
   puM83csJY156IHjTJtxPMKpEf8xYIUsvnzSElQlNNPU8rAXvrUor9nF79
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="385833766"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="385833766"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2023 00:56:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10881"; a="1092633380"
X-IronPort-AV: E=Sophos;i="6.03,270,1694761200"; 
   d="scan'208";a="1092633380"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Nov 2023 00:56:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 2 Nov 2023 00:56:56 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 2 Nov 2023 00:56:55 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 2 Nov 2023 00:56:55 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 2 Nov 2023 00:56:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aHs/GtEbXJYqeuqaOciqnX9n2XIQnMW72Zx5bUsLFkzMQgwUTuBv5+C0FmU77HkDA/ai3ruLyCokdCXGVL+xyLEXVN/SMRPuwtC+XhDJtpRASODIEJlwP0p16q3CqVFtkIWh/Qsq5nJOAf6VsMoQabcVxJmLbHl2DgFeZe8jnx+IyFiOQIbtS4fN/3SjxufvRWVsfNVSu6hsYw3/SgCuxC+UYhINeHcOBKrEj6e0FOBxh5SJsUjld58KXaLGZ2uDlhgpx9FjfOD1D19yl45tPZJkxIV8As19bT5l9HVzC0VVz2Vn0u76YOP5PWnoKOOItTr9CKmkEHp18BRMnkBUUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aM4xnmmPjJU0QFVqRbtc1Gc6W3P3kVYY5IdN/A9KYI4=;
 b=GswcIkagzTYM+8MM/RBZ2zcYu7kGsr072lwwZllVPhBwv/L1v95aHIZz4SMUn+MkfxoVFFsDiOMfHt/RNWPKbyhvLmIqS93DTPY2MO8iHh3Jui1n2VEW+h+Hs5WwuSGz8sKm03VkKnz4rBvIupXfVffNAP+7R608tg3Q5+zQsZYalhyFIo7xgZhMnS+g+Wo6f+SA20gZnjmufnVeAUdOSEYFaB7vCDJ9M7H4Qgr8yUzDYzS3OtffBMA1VDNddDl9gd0dXYuxqd0vbi2qJFfFMoYidbkcVLcsPsydcizy1VRbQQy9B0VhI4OIYCLFLFptz66CQmM7TQVE8ftDK7w6qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by LV8PR11MB8581.namprd11.prod.outlook.com (2603:10b6:408:1e5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.21; Thu, 2 Nov
 2023 07:56:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e4ae:3948:1f55:547d%4]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 07:56:52 +0000
Message-ID: <04082030-ebc8-46a6-9acb-e2881118f9dd@intel.com>
Date: Thu, 2 Nov 2023 15:59:25 +0800
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?B?UmU6IOWbnuWkjTogUmU6IFtrdm0tdW5pdC10ZXN0cyAxLzFdIGFybTY0?=
 =?UTF-8?Q?=3A_microbench=3A_Move_the_read_of_the_count_register_and_the_ISB?=
 =?UTF-8?Q?_operation_out_of_the_while_loop?=
Content-Language: en-US
To: =?UTF-8?B?5L2V55C8?= <heqiong1557@phytium.com.cn>, Alexandru Elisei
	<alexandru.elisei@arm.com>
CC: kvm <kvm@vger.kernel.org>
References: <7ac00102.1c5.18b89fcf84f.Coremail.heqiong1557@phytium.com.cn>
 <ZUIwt6jWBN037XVf@monolith>
 <1055e84c.1d0.18b8efa2d0d.Coremail.heqiong1557@phytium.com.cn>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <1055e84c.1d0.18b8efa2d0d.Coremail.heqiong1557@phytium.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0024.apcprd02.prod.outlook.com
 (2603:1096:3:17::36) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|LV8PR11MB8581:EE_
X-MS-Office365-Filtering-Correlation-Id: c2899d20-3d03-44d8-57e1-08dbdb79460e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WRaknFYwAGKeDatNWqvar9hFv3TWFIua4O6wURRCWoV2zp+cShwSe+FqBjdHWy3qCQVnHDBaS2alfWz3tvD02HEKQzWOKd5w6VQzMuQvilcdCBcHTlafda6ofc2zmTxu6OvLEtDVCd3BGNMoYRFJ1O+15aPh4GJiRsPLos++AYeAbM5DGLkk1cSPW6tpsOtI21mxjQnnTQ5E9nVsAF8wtXsexOckULDCIyMPAstbsVtT9sXeCovjzzGVGnEsDRZGleKixTKkWhEpKM5HUtIatXeaWh8qjDizlHQfV+GP6Xalya1FkkF0LUbdgpMFeQ09/STx1xToe5WX4Kxmu74BCtOMVv1LBcrW4WhEw5IBS4wv9zlbwZIucJD0uyAGcPEjQ/edCVCxl1NkDjJh+4iDPrEe/wbyLnB3f6wUFdpgvf7k5mMJiS9y2klMFAj1/AP1x2mWlsdxaZzqvvL365t3FabsBREGIG5TbI7BKamuoLp699YbZAHHK4dddbYS8vrmeJFm/22duz2OeLooqj4MgDpxymorgojhmBNmdVE1PUViOzIpoe/dBE+9Emip7TaWASlD29Fn0SFMNerZbs7FXEpiDf/in/eiAypoBqNtZWNs/cQfWVlryoFGqpLbdYWBBmAfp3Ic9R0s5uKRbdlxuQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(346002)(396003)(376002)(39860400002)(366004)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(6666004)(6486002)(966005)(2906002)(478600001)(2616005)(224303003)(26005)(86362001)(31696002)(82960400001)(38100700002)(36756003)(83380400001)(6512007)(6506007)(53546011)(5660300002)(66946007)(66556008)(66476007)(316002)(110136005)(41300700001)(31686004)(19627235002)(8936002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVg1U3JJZDNjblcvenRmN0VQajRiK1JjOTUyVEVBenZiL3FvZEFGdGhycHp1?=
 =?utf-8?B?T1dIdnpKZWFGbyt1Qkx1QWg5QkFkd3hFUGk2VlltdlNHcFFyYTZQQUxZRlRB?=
 =?utf-8?B?cnczWGNvUVpqR2djOW5JbW1QL1UrYmFCdTZuclFDVEdzYlArbDB1S0tGZWl1?=
 =?utf-8?B?YjRMODRVUFN3VEVnZGZ5SXBEUDc5emNKdnh5RnNNNWtNOHZSRmJmb00zVENi?=
 =?utf-8?B?NmZKYzJmd0xNUHpVSGlRNTNrTjRjNjhPUmdoNzRhYkNLUitCVWRQTTZTMEVT?=
 =?utf-8?B?bGI4TnFFV3ozV2RneTI2MnR2VGFIV3RyRmxGcDdPSEpqaEpFWWdVYWgzMDZN?=
 =?utf-8?B?QWR2b2NFaUNHVmVwYmxXQ1NFWEU2UlF0dkI4MXdISzVkODdTYXFpQ01MNEo1?=
 =?utf-8?B?S2FzWFpheW9HU1hzQjdMM1hsUDNyRmVzNGt4dGVBeFJ2TFRhQlpCeFJ5ZGNV?=
 =?utf-8?B?ZThrUW0rYmV0dVgzK3RMNkpPMkpzM3dMeWhGNTBOVHRRWmNhSTk0R0ltMjBz?=
 =?utf-8?B?MGRVMm04cHEyZUZPMEkwOXRQaTROaFZIdmo0MjN0RUNIaTh6RXFLdEpmazRM?=
 =?utf-8?B?UmhhblhiY2M3WW9SeEJzMzdSeUlqeWkzd1IzeWZCZmFoWit2OXZwbmJZYXBv?=
 =?utf-8?B?ZE5oNTdUSmpmbGhjV0JMVWtUbzVyKzAxVHBRYjg1ZS9sNGRYWWp1THJTN2hI?=
 =?utf-8?B?c2krL0UvZWI5QjY5UnBheWRndk13Um1aNEJXK25wVUdQSEZyVFUwQU5Hdzhz?=
 =?utf-8?B?WXdnWkQ5SWx3d2VqU3NPUGhqT2l4UmgwQzlPdVd3cjB3cUxPZVk0dTFjb2JU?=
 =?utf-8?B?N0JGdVBnYzZpT1YvUDg5VHIwMG9uQis2b1FFNWpaUmdFSVZuUys1aHBnMXFt?=
 =?utf-8?B?K2RUWmY1QmZ3cUZ5clRkYmMzRStLRTZ1dGtuRWRKOVErTHBQQnE1Wm1GQXFw?=
 =?utf-8?B?TU84U3l0NkZkNTV6b1VRdWRqWk9PUzFqb1pzSGxDR2lpMTcweUpYa0Y3REFx?=
 =?utf-8?B?L2wrMzNGUHJ3OTNXZnN6ZW5DT1VVRFFWckc2N3Q3dURwdXc4UkR2QnpoNnR2?=
 =?utf-8?B?TTFUWkVzOWJob0QxZFFiQUlYaWtQMDJSRmVBVENSNjF4WmVWV2JwWWNRaFVl?=
 =?utf-8?B?cVpIUTNPdkZLQTBlbzd0dnJ3V0NEOHZENG9DTFBmODhjTTQxQlVRRERLUlcv?=
 =?utf-8?B?dDRKajU3c1pSb24wNElDZmNZU2NYTG9sQTN0UzJ5ZDlhb1hJcDErTmc2YVFW?=
 =?utf-8?B?U3VRUVl0VTRza1VvWFVkQTNaZS8wRGw2TUlrRHRvMkhzWXVhVlJoVnZaTGpG?=
 =?utf-8?B?c3RZZ28wcWg2U1liaEt5T3JETFZVNFpOWWI2YnU3QTZvVW1GQk5GMmY0dWw3?=
 =?utf-8?B?Z2Y5NGY0SXdnQTk4RHNjaDBPK1o2cHZVaUFoci9HY0hnTU1SckVnekF3bjRL?=
 =?utf-8?B?b0RGYVlaWi9vTUpZc01sQmgwcjdxTHpKWU5ORzRrQTlvQjl1SGdvdTFuYm9i?=
 =?utf-8?B?bFZLL2h2NkdtOHhkWTNFQlNFUjlYcDg4SDVJSnZzYkRSR1RiZXdnVEdRNWVM?=
 =?utf-8?B?ckRRQVVWb2t4MFY1YmV4ZkczUTBobFFXSlgrZXVQcWFCS2JaOEVaR3JtQllV?=
 =?utf-8?B?WllNTUZUYSt3ZWpVVXJ4a2IwWGxuaDU3bFc1a2NzV0xBNHdqTFoxN3Z1VU9y?=
 =?utf-8?B?SzJtOWZFRnVydmtjN01SMUt6cjBTaHVGNG8wKzZuSS95b3Iyd0dmNit4Sisx?=
 =?utf-8?B?V0kyRys4dGkvc2YyNEJVMjVmcFp4RDN0cnk2ZnFzOVcrK3RteC82OTQ2b0Nu?=
 =?utf-8?B?bUx2cmlnYjlERklBZjZCdldxZ0k3bXFCK3B1QXVsK0x1K01sWlVNSHZ2Mkgy?=
 =?utf-8?B?M0dVMmZZNmZCWDl3MG41WDZVNVZtVHB0aTVHRFUyQkQya3BlUXU4TGNVdVBm?=
 =?utf-8?B?ME9ydWFRUVhMb3FzRXdGNE1pQm9DdC9rUEJkWkhqSDZKNHFjRExqMEpEQjJu?=
 =?utf-8?B?SXJqVjRHQmhuSjNCU2pVdldHbmM2KzFmUmlWOWRWeGFjR2J5Z0FWYVpwZDZ2?=
 =?utf-8?B?NGdrUTRtenNiQ2dKeTkwL2N1QUw5TlhFUGhqWWE5TnEzdFFWdjREc0xUQnpF?=
 =?utf-8?Q?btIsudg9/CVqY3WOasiIxWS3E?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c2899d20-3d03-44d8-57e1-08dbdb79460e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 07:56:52.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pL/vM2zEPBs4VBgYI5MUtyaemPmKCvtYDMmtN3hpVGJvrQrDq74A7mwrYmLG5N384UKLxW11bueAPphhXj7F/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8581
X-OriginatorOrg: intel.com

On 2023/11/2 15:40, 何琼 wrote:
> Hi,
> 
> Your suggestions have been greatly appreciated, and they have been incorporated into the new patch, which now includes the "dsb" instruction.

Apparently, it's not the correct way to submit patches.

"
6) No MIME, no links, no compression, no attachments. Just plain text
Linus and other kernel developers need to be able to read and comment on 
the changes you are submitting. It is important for a kernel developer to 
be able to “quote” your changes, using standard e-mail tools, so that they 
may comment on specific portions of your code.

For this reason, all patches should be submitted by e-mail “inline”."

You can check the below link for submitting a patch. Also, you can find
out the proper way to send patches.

https://www.kernel.org/doc/html/v4.10/process/submitting-patches.html

Regards,
Yi Liu

> 
> 
> 
> 
> 
> -----原始邮件-----
> 发件人: "Alexandru Elisei" <alexandru.elisei@arm.com>
> 发送时间: 2023-11-01 19:04:23
> 收件人: "何琼" <heqiong1557@phytium.com.cn>
> 抄送: "kvm" <kvm@vger.kernel.org>
> 主题: Re: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the count register and the ISB operation out of the while loop
> 
> 
> 
> 
> Hi,
> 
> Comments on the patch itself.
> 
> On Wed, Nov 01, 2023 at 04:25:39PM +0800, 何琼 wrote:
>> hi,
>>
>> This patch mainly includes the following content.
>>
>> Reducing the impact of the cntvct_el0 register and isb() operation on microbenchmark test results to improve testing accuracy and reduce latency in test results.
>>
>>
>>
>>
>>
>>
>>
>> Test in kunpeng920,
>>
>> Test results before applying the patch:
>>
>> [root@localhost tests]# ./micro-bench
>>
>>
>> BUILD_HEAD=767629ca
>>
>>
>> Test marked not to be run by default, are you sure (y/N)? y
>>
>>
>> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/libexec/qemu-kvm -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.y4c4YHIprP -smp 2 # -initrd /tmp/tmp.KLLmjTuq2d
>>
>>
>> Timer Frequency 100000000 Hz (Output in microseconds)
>>
>>
>>
>>
>>
>> name                                    total ns                         avg ns
>>
>>
>> --------------------------------------------------------------------------------------------
>>
>>
>> hvc                                      26774980.0                      408.0
>>
>>
>> mmio_read_user                 151183350.0                    2306.0
>>
>>
>> mmio_read_vgic                  41849830.0                     638.0
>>
>>
>> eoi                                       1735610.0                       26.0
>>
>>
>> ipi                                        111260770.0                   1697.0
>>
>>
>> ipi_hw test skipped
>>
>>
>> lpi                                        142124570.0                   2168.0
>>
>>
>> timer_10ms                          466660.0                        1822.0
>>
>>
>>
>>
>>
>> EXIT: STATUS=1
>>
>>
>> PASS micro-bench
>>
>>
>> [root@localhost tests]#
>>
>>
>>
>>
>>
>> Test results after applying the patch:
>>
>> [root@localhost kvm-unit-tests]# cd tests/
>>
>>
>> [root@localhost tests]# ./micro-bench
>>
>>
>> BUILD_HEAD=767629ca
>>
>>
>> Test marked not to be run by default, are you sure (y/N)? y
>>
>>
>> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/libexec/qemu-kvm -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.FiBID6KLxB -smp 2 # -initrd /tmp/tmp.oSKZeugleF
>>
>>
>> Timer Frequency 100000000 Hz (Output in microseconds)
>>
>>
>>
>>
>>
>> name                                    total ns                         avg ns
>>
>>
>> --------------------------------------------------------------------------------------------
>>
>>
>> hvc                                  26721040.0                        407.0
>>
>>
>> mmio_read_user             150824560.0                      2301.0
>>
>>
>> mmio_read_vgic              41845380.0                       638.0
>>
>>
>> eoi                                   1109180.0                         16.0
>>
>>
>> ipi                                    106062150.0                     1618.0
>>
>>
>> ipi_hw test skipped
>>
>>
>> lpi                                    141700760.0                    2162.0
>>
>>
>> timer_10ms                      470870.0                         1839.0
>>
>>
>>
>>
>>
>> EXIT: STATUS=1
>>
>>
>> PASS micro-bench
>>
>>
>> [root@localhost tests]#
>>
>>
>>
>>
>>
>>
>>
>>
>> Test in phytium S2500,
>>
>> Test results before applying the patch:
>>
>> [root@primecontroller tests]# ./micro-bench
>>
>>
>> BUILD_HEAD=518cd47c
>>
>>
>> Test marked not to be run by default, are you sure (y/N)? y
>>
>>
>> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/local/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.lrJJqSuLmN -smp 2 # -initrd /tmp/tmp.s18C3k2jfO
>>
>>
>> Timer Frequency 50000000 Hz (Output in microseconds)
>>
>>
>>
>>
>>
>> name                                    total ns                         avg ns
>>
>>
>> --------------------------------------------------------------------------------------------
>>
>>
>> hvc                                    100668780.0                    1536.0
>>
>>
>> mmio_read_user               472806800.0                     7214.0
>>
>>
>> mmio_read_vgic               140912320.0                      2150.0
>>
>>
>> eoi                                     2972280.0                         45.0
>>
>>
>> ipi                                      326332780.0                     4979.0
>>
>>
>> ipi_hw test skipped
>>
>>
>> lpi                                      359226600.0                     5481.0
>>
>>
>> timer_10ms                        1271960.0                         4968.0
>>
>>
>>
>>
>>
>> EXIT: STATUS=1
>>
>>
>> PASS micro-bench
>>
>>
>> [root@primecontroller tests]#
>>
>>
>>
>>
>>
>>
>>
>>
>> Test results after applying the patch:
>>
>> [root@primecontroller tests]# ./micro-bench
>>
>>
>> BUILD_HEAD=518cd47c
>>
>>
>> Test marked not to be run by default, are you sure (y/N)? y
>>
>>
>> timeout -k 1s --foreground 90s numactl -C 0-3 -m 0 /usr/local/bin/qemu-system-aarch64 -nodefaults -machine virt,gic-version=host -accel kvm -cpu host -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel /tmp/tmp.IsEtcs1W1g -smp 2 # -initrd /tmp/tmp.885IpeoGw4
>>
>>
>> Timer Frequency 50000000 Hz (Output in microseconds)
>>
>>
>>
>>
>>
>> name                                    total ns                         avg ns
>>
>>
>> --------------------------------------------------------------------------------------------
>>
>>
>> hvc                                      99490080.0                    1518.0
>>
>>
>> mmio_read_user                 474781300.0                   7244.0
>>
>>
>> mmio_read_vgic                 140470760.0                    2143.0
>>
>>
>> eoi                                      1693260.0                        25.0
>>
>>
>> ipi                                       323551200.0                    4936.0
>>
>>
>> ipi_hw test skipped
>>
>>
>> lpi                                       355690620.0                    5427.0
>>
>>
>> timer_10ms                        1318540.0                        5150.0
>>
>>
>>
>>
>>
>> EXIT: STATUS=1
>>
>>
>> PASS micro-bench
>>
>>
>> [root@primecontroller tests]#
>>
>>
>>
>>
>>
>>
>>
>>
>>
> 
>>  From 518cd47c33fce60ef86ed66dfa9e904b66499933 Mon Sep 17 00:00:00 2001
>> From: heqiong <heqiong1557@phytium.com.cn>
>> Date: Wed, 1 Nov 2023 15:06:28 +0800
>> Subject: [kvm-unit-tests 1/1] arm64: microbench: Move the read of the count
>>   register and the ISB operation out of the while loop
>>
>> Reducing the impact of the cntvct_el0 register and isb() operation
>> on microbenchmark test results to improve testing accuracy and reduce
>> latency in test results.
>> ---
>>   arm/micro-bench.c | 13 +++++++------
>>   1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index fbe59d03..ee5b9ca0 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -346,17 +346,18 @@ static void loop_test(struct exit_test *test)
>>   		}
>>   	}
>>   
>> +	start = read_sysreg(cntpct_el0);
>> +	isb();
>>   	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
>> -		isb();
>> -		start = read_sysreg(cntvct_el0);
>>   		test->exec();
>> -		isb();
>> -		end = read_sysreg(cntvct_el0);
>>   
>>   		ntimes++;
>> -		total_ticks += (end - start);
>> -		ticks_to_ns_time(total_ticks, &total_ns);
>>   	}
>> +	isb();
>> +	end = read_sysreg(cntpct_el0);
>> +
>> +	total_ticks = end - start;
>> +	ticks_to_ns_time(total_ticks, &total_ns);
> 
> A few notes:
> 
> * The counter that is being used has been changed from the physical to the
>    virtual counter. Accesses to the physical counter trap on nVHE systems.
>    That might not be desirable if what you're after is to reduce latency.
> 
> * You need an ISB before reading 'start', otherwise the counter read might be
>    reworded earlier in program order.
> 
> * Memory loads or stores are not order by using an ISB. If there are memory
>    accesses before 'start' is read, you probably want them to be finished before
>    the counter is read. Similarly, I don't think there are any restrictions on
>    what the test->exec() function is allowed to do, so there might be memory
>    accesses as part of the test.
> 
> I suggest something like this:
> 
> 	dsb();	// Wait for loads and stores to complete.
> 	isb();	// Order the counter read after the DSB.
> 	start = read_sysreg(cntvct_el0);
> 	isb();	// Order the counter read before the loop.
> 	// No DSB needed, as per ARM DDI 0487J.a, page D11-5991.
> 
> 	/* test loop */
> 
> 	dsb();	// Wait for loads and stores to complete.
> 	isb();	// Order the counter read after the DSB.
> 	end = read_sysreg(cnvct_el0);
> 	// No DSB or ISB needed, as per ARM DDI 0487J.a, page D11-5991.
> 
> Thanks,
> Alex
> 
>>
>>   	if (test->post) {
>>   		test->post(ntimes, &total_ticks);
>> -- 
>> 2.31.1
>>

-- 
Regards,
Yi Liu

