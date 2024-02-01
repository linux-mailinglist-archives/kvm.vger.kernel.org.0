Return-Path: <kvm+bounces-7735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 51646845BFB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 692F3B2BAD1
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F9E6626CC;
	Thu,  1 Feb 2024 15:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NMjpDHmd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9C779E5;
	Thu,  1 Feb 2024 15:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802284; cv=fail; b=UoFuP+ue92w7SiinAjOIhxqRlcYWh0kbwv1GZuopbj8UHQcJWYsRsifx05Pp4E/206W6gJvotX8YlPvZUvtu1pn4zqjWZQ+4QeTO9GoXHb1W9O0RGdqhsUXEbtn1lN2e2KtN4RBcshqkxfLurr68cyvTIOEqyEdjw9xbsa0QIUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802284; c=relaxed/simple;
	bh=CMArwdCucRIuWPa894s3MQWn7D0HrpSeb+LQNZPefUk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e1p4UMJfGS3vVBm9IEYmZfobJ939Gl/DQ+zF1BgvjZVnIuusLWzuAZXXsdCGqVpB3b6hHoieWgr2pRZ9gP0oI6ETGGWpHo7l7wRtGq2CURVdRyZS7U3Y3nx+fJzmvJEdHXIdgMXyuK7WLXXA+MwQn8HF7tuFUYdVyCPm0RBMbCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NMjpDHmd; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706802283; x=1738338283;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CMArwdCucRIuWPa894s3MQWn7D0HrpSeb+LQNZPefUk=;
  b=NMjpDHmddEbnolLmpCO7gUBcmmbySfsshCllwzp797U7bwYnDqePdQ+t
   +ou1CQKQKw4SOvo5p5MrWwcN/KA2ucu/MVkziPEgkAgjXnmxOg2H0/Y0Z
   0wSVAk2UZFm6fNU1rkl64nULvU7Gu7F/yRgVIn7X13sTJxd/UKgqzyCUo
   b7D9BHmlDitm5Flo5gNjKCGCXY++u5NX56+ZiubG9lyycj5BEEqvbFmp6
   lWkU8pPgG2YpW53f3+O7fAbchCeGdU3vmu44nMtmI95ymCSdVs8x1nnl2
   4f1H0yHcf2RxFeGwAvmrArY8SOVAZ12eq94KVJNCG4aFVJt6Xn73TRAvP
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10969"; a="3781377"
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="3781377"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2024 07:44:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,234,1701158400"; 
   d="scan'208";a="4396994"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Feb 2024 07:44:43 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 1 Feb 2024 07:44:41 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 1 Feb 2024 07:44:41 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 1 Feb 2024 07:44:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnHp4wXPtvJNIn1yqKR/Q8qXsbIqSZsTxkxqh439YLUG/3nrFsJrNN0+TYIjtYOXTVQcpukyMHjKG75zA7mk/JwxMwDlXsueOEBSp0cK1aJMwnz4GZEbGltI1cLVfDbUAflxSjLTEpLlMb5IDk4jWNaJRvg9fdgd+IRuvKdBl24hT87ZaBH1hfzWsk1iN3jRI0hs7kOTyByHW2sRBEkefcMgQSs3/mFqvOgmVz+vl7XE3Gn60QGBgo2eKIp7SqdIN/7RnvmBO4KTYvN9JRIe7F7xxKtaa8o3+UivXQYHy03GZy+9sz4u/mywIzxlklf32IgwDHtxYwmjCeIKgZ0xBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8in9VMiBp9YiFe0zY1rsLDdoxg+m9ULmfsSAnTq+Jw=;
 b=jcZn2kbbC9oLI54ypiTKIeatH/VMPi+nu8TSo1trWLRQe3tCqf/d0mkvi2lK8Mc3moWaWgWz3+7zvacX/CQKblrMo8HIPD8KSsD52CjNNJ/XcciWKZzc8LS3/qyl3hJcZnOBEyTfS/oSdOoqK2og4JMtHPpV+Sa0gPg1JLdSgyM8ku6dPOKd0RB5a9dx7OGVXsBQpVsgXihc4kmazrJ+OL+BD3IKMwXhj5UQRqWv9s35EpjYG2Hs8dvOAyzIGjoiFjKiIKN0dsztp6sJEoX6dNwwgjlAAVmzVuYHOhvYPnBg1zGXayMXxdBF/kFxrp+WuXW3Cx3a+FHtLXqvJ28Few==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by BL3PR11MB6363.namprd11.prod.outlook.com (2603:10b6:208:3b6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Thu, 1 Feb
 2024 15:44:39 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ff69:9925:693:c5ab]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ff69:9925:693:c5ab%6]) with mapi id 15.20.7249.024; Thu, 1 Feb 2024
 15:44:39 +0000
Message-ID: <dbcff3a5-8b02-4cc0-9d8e-1116ff7a3ffd@intel.com>
Date: Thu, 1 Feb 2024 23:44:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/cpu: allow reducing x86_phys_bits during
 early_identify_cpu()
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, "Kirill
 A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
	<x86@kernel.org>, <stable@vger.kernel.org>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <20240131230902.1867092-2-pbonzini@redhat.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240131230902.1867092-2-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|BL3PR11MB6363:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d2fd41f-7f09-4fe1-da3f-08dc233cb2ed
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mWFvMGEaFUUbYlw1NoEMFuGTh5gGvYQVUGSw4VkV3mxnk8aSrXF80EmBrNk7jnSdrZqFYXXHCMBwQporjBOrJ5t3itmW4EITXqYJhU0AnHLQwgRiRMaGCEhS5k87hVn5fp6L6bmiRhhYOsK49ntMx57ZKdzjg10DCMBWLJj6MCNyFMAa5jvvXxb1mJzgfv0VvXm6BKi+tf/fQq4xvL+7lK285x+DosYyCPmJ4peJmz6YPWDj1ydrMlV1s4gOwMmc0zSC1SeEMpuvS7VyJBPmdUanDmSHkUmFh7GPLnFNKFTORdzW8xeryJ5D4MBTpVVgZrtNFGa7Ni/BUv87fhq/piPFkpPksgQTeQBShhDI1NIXTQuGgTwlAKH9N6is176B0durMbcD2VOcbSQPGnkymoHMbbqxYRIfSRsFhM64E0RCe4q1vONOTKHY0Ef3gWp+3lV+NIxxBsP8W0CUeH1RuBGmAmrfdQ+G/QKzjvwB3Atg9Q6zL2QaKRFcm0VBurfux5Etl/Vz7pUB96bJCZdTyrg/6b0tpSerS4bLIUEQYutMveNNLhaqsjptlbZnM+vXOlDW+7bVS6qwfMmermz2NKEuO3BdLyAP+NtFXHj3uVacAaJ4Lh88GBLL2wQ5Fq7AccoiSleM9cExjV3dW4DYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(376002)(39860400002)(346002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(53546011)(6506007)(6512007)(4326008)(478600001)(5660300002)(7416002)(316002)(8676002)(6666004)(8936002)(2906002)(6486002)(26005)(66946007)(54906003)(38100700002)(66556008)(66476007)(83380400001)(82960400001)(31686004)(2616005)(31696002)(86362001)(36756003)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkEzMGtyRFZVcWZrMG9QeWg1bnBrRUxkRzBwYjFBK2VHemlmOUdsVHQrRHNj?=
 =?utf-8?B?UGt6Y0tGYnhkQlpkMVY2L29pTzJNYlpOWmkvdHFpZUhuUWpvTTdHV20wMlpw?=
 =?utf-8?B?MEJFcG1VKzVVVmtvN05OQnp2UVFMNTRzb2kwbEY4T2hzV043SlF0ZExQbVU4?=
 =?utf-8?B?S2pKaHV2Sml5RndTa054TE5GN1ovOHFtMFlGOVptQTh1am1UZ0NPZXFnSDRK?=
 =?utf-8?B?aWZMZjJxM1VxdkpzYVFpSUxQSHFzZTVSMVJpQkFoYWYzM1oxSEdTb0swZUhE?=
 =?utf-8?B?NHN3QTUzY1cySDVUZHFjMUdSa3NrLzh5K3RFYkEvRk83WUhmNkEvZC9zZUJK?=
 =?utf-8?B?aStDN0dndDJ0Zjh4dldlY0tZb3RiNHRTdkt4Z1JVcEcrUEpKNk9oeStLMU15?=
 =?utf-8?B?OTlVeXFMSjdITnNTTGNMVzZCVG9INUV0WnkwVWM4cHp6NnJCVXhMUnY4cjJn?=
 =?utf-8?B?ditKUVJkL25QMCt0NllSckViSkVYVWJEMUVQOTM1cWFpT0pJT1E3R2p5OTlv?=
 =?utf-8?B?L0pnbEJUaEtPaW5YRDNiWG1sc1cxZGlCMkxIQVAwa050WXVlNlBwUDVaN2RN?=
 =?utf-8?B?b09VMFNNVmdLRWxCTGQ2Ui9LQ096V0pvQlpFaGNJU0ZTem9BQmJmWkRhM3RZ?=
 =?utf-8?B?cDRUL3F0NWZicU1Ga3piTkU3RElJb1JtbnNNR1A0aVZ4R1dJajhwTGVhWmYv?=
 =?utf-8?B?MWQxUU5ML2NxMW5YeTNmdENnOGxydjRndEhnOUkrQ2N5UmRLbUhRdjB0NjBN?=
 =?utf-8?B?ZS9oMm1WSjlVNXpQYXRWWWw5anJCaThqOSttcXRFY0dPUlJadjZtRTJ5MHoy?=
 =?utf-8?B?elViQklTMTdyUmZsNGdnQ1BtVFZwZzJmRXRBd2dKK3JnSkNhclZPMW5TTkFC?=
 =?utf-8?B?RGVtalVPcFNVRFYyWERMbndWK2FzeWJ3OHN3RENRT3BCN3QxRDFEaVlDWGdn?=
 =?utf-8?B?NW9CWVBidXhxK3hBdnNualZyQWRnbmtlajR2NXU2N3JNcnE3VFVFTUIvT1cx?=
 =?utf-8?B?bkFjUWJTaUM5MXV4aTRKTWNCWVpWeEFIV25vUzJPaGUyREFnV1daaEM1aGNK?=
 =?utf-8?B?M2V6bFNvbm9wSU5WZ0d1am9GODREdGpVelJjNWNJTUhNZFJCdzdJQ0kyU3F2?=
 =?utf-8?B?anhhNC9xUlJDcHd6aWVjdjY5cWhkaFRTcEFZaVF4YWQrVjhvSFYwdnp5bmYw?=
 =?utf-8?B?K3YwaWp0SDlybmpUd3ordEJPQTdIL0RnQkJOZnRTUGpXbFZBSnlTd2drTlNi?=
 =?utf-8?B?THd5THU5czZwZllEUjB0b1V5akFHek10MU5rdVhFSEw1Y3g2VmRXdHJlRUw0?=
 =?utf-8?B?OW9OeVFKQmVaRUdKZ2tIK3JjR0plZ05aOGxQMGZnS2U2UE91MmwvUkF2Zm1O?=
 =?utf-8?B?ZGx0YXFRL2NMMXQ5RWJJaVM5VzlGZ2RiTjh3ZlpYSkZOY3VlN0RGMFc5UUF6?=
 =?utf-8?B?dkFMSGprZTZYM210ajJwbFFTd0dZbmdnMDYyMU9TUWsyZVdUTWpPbUliSjRZ?=
 =?utf-8?B?SUo5NHRoZS8yVjhnRmxEN3Y4amdWK3VuZlZ3b2JQbzFjckxHR0Q5aHVjNkNN?=
 =?utf-8?B?R3NxYkk1b3NqZDhjTm1ZTlBVQ1dNbkxQYnd4d0tGL1BYUTJrTGc0TllKOFJH?=
 =?utf-8?B?QStTMDNnbHpDeFh5VmlSVkNyTStVOW1pb0pzc0dLTmFqU0xMWk1IMHpqbXBL?=
 =?utf-8?B?NVdjMGp0UkhsK0RPUVV1UitGdU4zVUhHaFlTc2g0ekVmZVJLQTFEVEFVOVFu?=
 =?utf-8?B?MEswTUhYNUlvMytTVUVwVFpFc0R0Q1VBN1ZQbHZBRWlvY1JtaHNmcm5JQkpt?=
 =?utf-8?B?SGNhR3Z1eWdzTDJqTHFOc2pyN2x5cGVKWEdFU0F0UXgvL2lXcndjb3M2YUY5?=
 =?utf-8?B?dTZXR0lEclVwOEI1WUZGbzRjUjUwU3E5UjdlOU9WVXFxWlJNTk5CQnRSYXhi?=
 =?utf-8?B?OXlTRUNWTWFQUDg3S0EzbVRXYlhaK01hcUZKN21JaDR3RTFpRmNFdFhqT0Jn?=
 =?utf-8?B?TXNndFUvVzJiazBUN1VsVHBuQTZLcmVuQmRPVkpkZ08zVk11M0tyWkpDQzVE?=
 =?utf-8?B?Q0s2TG41VGZWdEdhcDZqMXUvSURlMk10UzJ1ZHliS3dFWkJtc25rV2NmUzZB?=
 =?utf-8?Q?BPI5Navex9PerVdxN1wixqjxd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2fd41f-7f09-4fe1-da3f-08dc233cb2ed
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2024 15:44:38.9971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0iAy71+2B9c0dJKwoe7NJwzlrGW2XKetT4TPSlFA1Yp278Od8UUopY249QTIDo63k0YXAOfZ/c1w510jpKpPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6363
X-OriginatorOrg: intel.com



On 1/02/2024 7:09 am, Paolo Bonzini wrote:
> In commit fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct
> value straight away, instead of a two-phase approach"), the initialization
> of c->x86_phys_bits was moved after this_cpu->c_early_init(c).  This is
> incorrect because early_init_amd() expected to be able to reduce the
> value according to the contents of CPUID leaf 0x8000001f.
> 
> Fortunately, the bug was negated by init_amd()'s call to early_init_amd(),
> which does reduce x86_phys_bits in the end.  However, this is very
> late in the boot process and, most notably, the wrong value is used for
> x86_phys_bits when setting up MTRRs.
> 
> To fix this, call get_cpu_address_sizes() as soon as X86_FEATURE_CPUID is
> set/cleared, and c->extended_cpuid_level is retrieved.
> 
> Fixes: fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct value straight away, instead of a two-phase approach")
> Cc: Adam Dunlap <acdunlap@google.com>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: x86@kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Kai Huang <kai.huang@intel.com>

