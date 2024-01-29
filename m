Return-Path: <kvm+bounces-7300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EA883FC37
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 03:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E888284EAE
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFA6F9D6;
	Mon, 29 Jan 2024 02:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KIbKmClC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E45EAE5
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 02:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706495451; cv=fail; b=YVAT2uLAwNPnm0rS3ulJRNezYKmD4OKvObwWOIj5Lsr3YM696fzW2P1y1salWxkEstzsbjp2WQq0CAGttfBGUDODKmKPIg8we2ayqoOgnzwEe2vACulNt/+Zk94HR7v2eT2M1bs8QD4Xjc9prS+r/UTMOD3C08LBhWsLvkNxWXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706495451; c=relaxed/simple;
	bh=9iLJh0qHdKUYxWA0AW1n8/l1GHmT3tx/4H1TqbUhxso=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WPupXNaRXB5xdvGTU9fepOCiV3cG8BCe8UEiu11UE3C6EK4QL9noCBNLGqYb8MK1ZVEPz8GdhrUuR+c6sKTJnWf2fhleHfnnkBjlc72yA5J7VZTyTeMaA0b1g2ZSgQCm8JnGSKD4HYjOGk86a7zhHhL/kOYe2qg0e1SbVQhqs7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KIbKmClC; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706495450; x=1738031450;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9iLJh0qHdKUYxWA0AW1n8/l1GHmT3tx/4H1TqbUhxso=;
  b=KIbKmClCecp7Q+GMTatTd1JQjnB5M0xr8KaxzjrQVyCFQK0Y6DTwbArX
   ttL5/uus7GFAf+twGtxugFj12Q+bgz3/8Wx2QW3/Buoxw0bTPCXODXuQw
   KhqwHORYWMZnin/Tl72c6pgcExWybta+WfloLrtxzI2ABhk5trKynCyBZ
   63g13Do53Y3l4RmtOJ1fvdsFwVjCRYTBoES3VnQuWK2IXQKkSuxDpbmSD
   wI/X4069SFGXa46/saqI0klkCqatZ+TUpOkAabd9u7LoNnl28kEsU4l1D
   UQG6sklGCKneu4foQdiEhU0+nGaNUnG+RCe6PIXGTnqh1wtU0qlsNlrCD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="2721049"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="2721049"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 18:30:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="29366613"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jan 2024 18:30:50 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Jan 2024 18:30:48 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 28 Jan 2024 18:30:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sun, 28 Jan 2024 18:30:48 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sun, 28 Jan 2024 18:30:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yy2VGlC13HEUxvSjd9w/rQxlieCgeB6VnXI+R9wzbDHisA6F2YmvXOHZ7X4E+8odj4Ww4KGZREkIxEbyRt2VhbPg+2i+rMjjl8of54AXa8099eOPAT2UpLLh+pfo03rkMlDbi2wJYJg+lOZ92GIekRrjVTHp805s1EmvOfua6rWFqK/hW9GgQ/R/KJFrB2W81IblpIg+0FPZddRfOOobYYEP+qp6T/9VaUrSXst0qsEjJ9sY0rm+c2KH32t+uMJ7iUfLAzo+Vp9zPPO03OsR3MDUz0/e7oE7aM5uILmQnBX50bQYMI++iix9YTrVONTdmM+gWlXkQSUnOgQ3JJnpVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGe3G2gjnDYpnjeLvfLtK3283DGxHs+wPMzp9224cJI=;
 b=Zu5XjFVEew/dxDPcrTH01M8hZjEPR1d6Wls2CdpqdzUFczZWzmjRsEwFchG0uQI6FgGXN4+r84Hom+rYKahxu8q750qsTg8OXE+0D+cy2QeYjE8P9/9WiW4KRh/okbK6MTD842hiOAviDAQuL/hu7L5R5YTlaBqP1aKU6KEuA5nhghcg7UoRyDhwzn/h93mCucKEbJlmjNKFpmB1+HSkU3j9HZ5M/H7SRkswkTv+iwyozouJrSRL10K60f30DvnYrXfn79a4vuWkHaO4CAfpldr6dN+RN/tHDX2QmU9L7fqGcJ1SwyZWXLha8kSxTtUchQJyrh5aWoBm7oml+x+12A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SA1PR11MB8318.namprd11.prod.outlook.com (2603:10b6:806:373::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.32; Mon, 29 Jan
 2024 02:30:44 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 02:30:44 +0000
Message-ID: <08966170-651e-446b-aac5-47e6156786b9@intel.com>
Date: Mon, 29 Jan 2024 10:30:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 0/3] Fix test failures caused by CET KVM
 series
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Christopherson,, Sean" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
References: <20230913235006.74172-1-weijiang.yang@intel.com>
 <CABgObfb-cfZTW=xb7Vf3Fh0pAsQkkrrxuB2MczrR5X3bTpWr3Q@mail.gmail.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <CABgObfb-cfZTW=xb7Vf3Fh0pAsQkkrrxuB2MczrR5X3bTpWr3Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:195::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SA1PR11MB8318:EE_
X-MS-Office365-Filtering-Correlation-Id: f51078fd-5d57-4929-1a1a-08dc20724b42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FETPDIxYd7onLShb2uOrUDirU7jAY8xzZn25KtgXhMYZldFb5EwlqOmVUX/O1md93Pvb+08msp2uZl5IVbdc9SdjSib0b3UTeziiKA9uh23ZqTG/kG67j9uK7moYqiqlMOJIZixcjosz49illiMhMT0IR9Z8GWJ+rJmksc2Tx6xkNWMNPPlW6PHMza5bRCHdH8CCvdB4VpkUrg3QTDvU99M6Dn9Ue+cXl6Awrp7mI90vxaDYbas9tPdvFg3exahz10lJFaga9tZBMO8//QfDVIz24OTr5rSubGRlzdkK0xaqQqOj+uc3ee/Ee0vjUdN0c32G8unjPT3p8exsZ6vx249z6a7dfMWoi27EkQ6Ey3EhfR3wTvCVLGvDpjYugJNU8Ztdv+WO6L/BzEFsTu2V33lLvidVgepTXjPw11ElaSNaO5w4r2XKKkBzf40bpdNC1CO7/bCJ7lR8D3Tsmtd5OrtPs+6ZydEXx019bm+k+Nypejg0pA2Zu/GA6vUXApf+eBsluTkmH/Z/p5DY/88KV1KMZlwwO9ior0PtMbLple3cimQid3GXcOaRObSovRX96TUSum6h6L+pq/ixi9PyOvQKfLgWNjmSHZ403KufmnpVY5ZnNBkqakk3kPKx6dmHYSTzeJ5c/lBtE5k+ONzRxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(346002)(136003)(396003)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(2616005)(6506007)(53546011)(6512007)(26005)(83380400001)(6666004)(8676002)(8936002)(4326008)(5660300002)(6486002)(478600001)(316002)(6916009)(54906003)(66476007)(66556008)(31696002)(66946007)(86362001)(82960400001)(38100700002)(31686004)(2906002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDc5ZEJLeVFZVzlReDQ0TmM2UzZucyt2cHFrcGtGUVVpMmRMNXkySTErN3hH?=
 =?utf-8?B?Vit0UitoRVJCYTZvTWJrUVF2T2VGSWpPcklaWVlnS3VsV1BhSXVGS05OTXVm?=
 =?utf-8?B?c0U4VkRsQVI1Zmw1UWlYUXI4ZUluL24vYnhVeUJjem5wbUZzdkxIQkhpTU45?=
 =?utf-8?B?OHNDZHdsY3hQRngzakZURWsxMkc5ODUxMGFCQU1jSGZETWRGS1dHT2FZRE0x?=
 =?utf-8?B?d3c2aHJlQlZjV1dtRGNiay9XdFZwQUdOcG5pOHdoaC92d2owYnBrcElLZktS?=
 =?utf-8?B?VEZqbDF3cDhxTUFOeTB4a0cxQTk1NkZnOHMxb3krTHFMbnB5QmdYQ0pWdWpI?=
 =?utf-8?B?elZWSS95bHBDdmRYUXJsdEpKMlM1UmF0RXlxTFRrZWl2WkZYYzY2ckl3MzB6?=
 =?utf-8?B?VXhFakVvM2tkVUE1OEwwSEpaOTFrZ2F4czRYYmtrSkZGeVVLSHNwRjJKcVdP?=
 =?utf-8?B?QlNtT0JNc0RseWhHYWhpeU1GTE45cE5sbVJKMHE1YXBzL2FzSWhJR3k4WkNX?=
 =?utf-8?B?Z0NMaVlhWjlhQ2JDTUZGOStSSXNYZEVBZi8yQTM5RkJQb0dlNHpxMGU0dVd2?=
 =?utf-8?B?OHp6alhKeVFzalA3d1RXTWsyUWZSRUpXNW13ZHJWQ0NnTUcreFl1TFZhc3pj?=
 =?utf-8?B?T2orMnRDNEg2ank5cUFqRE5rSEZxVndGTTRlcm56ckJZS3Y3N3ptUkc4RXFs?=
 =?utf-8?B?ZDdsZGo5WWg2Y0ZXbmZ0dDJLZFNNMXREM1JrRThib1UyVWV6cHRRaDczYjR6?=
 =?utf-8?B?UDBGUms0TUJNdE1rT2JXZ2xmQmV3eHo4UmR0d3R4Z2Z4bWxwUWlqQURNb2p1?=
 =?utf-8?B?QWRxWk0ySjgxY3FJS0VvZ3N0RFdzQldudWZrZ2praGt5TmFYWk8vVmZOeEM2?=
 =?utf-8?B?N1Vad3ozZWhiS0VZaHNHanRyVjRVVkZtOUVENzk4ZHB0UzRxdndabzVJbkpH?=
 =?utf-8?B?bEFnSjJBNEtiTXpGR0xkYVEzS0h1K1cvUHh1VGtvNXRBMTVjajhFUHluVURQ?=
 =?utf-8?B?QTRVbDRKc1ZGelptZTFTTlZkVnpCRTQ1eW0zbWFuaDltVzR5ZzZMbk5QRW1B?=
 =?utf-8?B?OWpIQURCUU9scTkzK0lMT1RiNUJqRnNOaVU2VDJ5RjZ2NU02ZEtVZ0Fvekl6?=
 =?utf-8?B?Qk9STkFwbk9zR2xQellhVXhKb2FocVVRVUUwTTllQmhpL3lSOEI2YStTZ0dI?=
 =?utf-8?B?TjdtaCtpa2RJdUl5SmFBT1pxMlJPenJNUUQ1VnkrbGRGNjhmenZDQ21MVEF2?=
 =?utf-8?B?S1dGdDRhV1AvQzk5MUFnaitWMUx5VzlqK1ZFeTdaM05Xbk11eVFpaVl3Q21k?=
 =?utf-8?B?ZXdha3JCOXkvclVFakpONTlmOW1LV2VHWXl5SHFLOEJVU1M0aEhHcklqYStM?=
 =?utf-8?B?MEZTRDA5TWV5U1lXSTVUYjluNkFSbWd3Tmp6ZjRVOVY4S3ZGcUkrejQ5UG8w?=
 =?utf-8?B?U3htaEoxQSt1QnZCY3VQMm0ra2Zac1QyVkg4dG9wVEhIRHRZOVVaQTZZUzRu?=
 =?utf-8?B?RE10d3JqWjdoL01uVFdVemZnU2luZ3I0ZHpmbWdSdVhKRU02SVB3RE1PKzda?=
 =?utf-8?B?NjZZNE5jUmtnakJRNmtTNE1KQmgxUTlkTWZPb1ovSTBlMzF0Z1VOaHdCM0ZO?=
 =?utf-8?B?OTRVNGdWTEF6VnYzKzlLVmt3Q0tpWDRRYWJha3hYVmJrY0NXd0t3enFIU1R3?=
 =?utf-8?B?VVVweDBIbGpSM1lkYWVWQTZkSkhzemh0WUJHQm5xMWRMYmxCbWltQWd0dDVp?=
 =?utf-8?B?OERhV3FvRHQzUGNRWWNVU1c5MGxjbHlEUmw0dW1lYnlXVmFxeVhYNmlYRUFi?=
 =?utf-8?B?aGhZbUVZZ1pFMzlONndMYnhHbGd2cTNTc1c2S3kxdVZIRWx3cTBKckRYWkxn?=
 =?utf-8?B?WWhBZjdHZThEQ0JNM0RFWDJwQ2dGaW94c3BzS09VcTdDS1orQisydjZYQnYw?=
 =?utf-8?B?SER4OUN5OUdKV3JkaGRab2drdSttYUF3TndjT3dOc01Mcy9JNFVubURMK0tj?=
 =?utf-8?B?ajF1cTE0dDZ4emVDeVNnbzFheVdnTC9rbkl6dHpyc2FCbC8ySTc2SE5lb1Jz?=
 =?utf-8?B?MlNOMGc0VWhEbVBHNEIzVDVmY1U4dDYwYUkzeWRCazZlaTJxV3d3TVIwV29Q?=
 =?utf-8?B?MzRWOW5BS2p5cm0xQzliZXRNVmxUdy9NOStQNWJRVXROb0h2ZWYwdmdDL040?=
 =?utf-8?B?UVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f51078fd-5d57-4929-1a1a-08dc20724b42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 02:30:44.3603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IC21eP+Mw5cWv67FolprjgEK+J6vpgZcQKUryItUt+xk5UndAxkemDGfjQIUYUG/RQs6ACxqGQcd3TBqMmv3Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8318
X-OriginatorOrg: intel.com

On 9/20/2023 11:44 PM, Paolo Bonzini wrote:
> On Thu, Sep 14, 2023 at 4:55 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>> CET KVM series causes sereral test cases fail due to:
>> 1) New introduced constraints between CR0.WP and CR4.CET bits, i.e., setting
>>   CR4.CET == 1 fails if CR0.WP == 0, and setting CR0.WP == 0 fails if CR4.CET
>> == 1
>> 2) New introduced support of VMX_BASIC[bit56], i.e., skipping HW consistent
>> check for event error code if the bit is set.
> Queued, thanks.

Hi, Paolo,
I don't find the fixup patches in this series merged in kvm-unit-tests, could you double check?
Thanks!

>
> Paolo
>
>> Opportunistically rename related struct and variable to avoid confusion.
>>
>> Yang Weijiang (3):
>>    x86: VMX: Exclude CR4.CET from the test_vmxon_bad_cr()
>>    x86: VMX: Rename union vmx_basic and related global variable
>>    x86:VMX: Introduce new vmx_basic MSR feature bit for vmx tests
>>
>>   x86/vmx.c       | 46 +++++++++++++++++++++++-----------------------
>>   x86/vmx.h       |  7 ++++---
>>   x86/vmx_tests.c | 31 ++++++++++++++++++++++---------
>>   3 files changed, 49 insertions(+), 35 deletions(-)
>>
>> --
>> 2.27.0
>>


