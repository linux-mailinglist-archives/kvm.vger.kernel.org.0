Return-Path: <kvm+bounces-14948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A56918A7FB5
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 11:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32C7F1F22916
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 09:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED088130482;
	Wed, 17 Apr 2024 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AYkjLsQe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48301292F2
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713346375; cv=fail; b=FVWVbHN6Y4l2Q7vnsOrVO9EOhlMszOjto/VZhlmI0UXTJwzd+k2vmVE+gWjETRd8PJtHUkItQnCAXWgOd2YYGuZ+83OJ/JiAsf06chJ5SpQ6hfITYYV2AfTh9jupd49e4o1CuseEHlgmma4K2GEMQMdWxZho0sVXBEoQr+mmEAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713346375; c=relaxed/simple;
	bh=Z2qOgYBwwm9ultAYTC8ZigQWUBjfiz/kYc9zLFM97+U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ZtB+3azg3+6r1zkf6+NFH9lcOhMjclDu7Yn4UZ/QU+MXpxr2DenL0n2DXA9EO23OiL1HwsClZzfyzUqCgesLKTCgmESbw6ieVWHaUReZwsEg2vZeuGTDLlOwXii/gsY/b+nyShqm2Z15Gd8nLbbvXv2G7ESB9bEaOHzeKYSDEK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AYkjLsQe; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713346374; x=1744882374;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z2qOgYBwwm9ultAYTC8ZigQWUBjfiz/kYc9zLFM97+U=;
  b=AYkjLsQeZ6spGOb+PacPGDQbMnP+2CoTZUrIDtGwdOiS/+IvDii51fq5
   RR9oWM0/5r1qwERXNfFnxm/n+B58rqF5UsWPO0x94t5zw5AsTDta1AfwD
   uRDVP7EUcfVms682DM+tgRRPOcrCEOQz+zzUnemvs1ISBCjpDzmY8rlfX
   f63iVmDb4PaUM8XgjMvklHhH2kFVSYf+xh5SCnrt3AG7vqB5yx3/XfUrl
   8ARhCY1sfrpPjg1jUwLmoYtKGMmm62Q2EVBSm7unUl7E/Bj0w19UPFA7G
   DcotxA4tiWKBSx0ZHUeOjuhnQpZI+9fWEhUTdGzOXGHmQWCvt4Y2oqSL4
   A==;
X-CSE-ConnectionGUID: dZzfepciRE+8l8vyoi3qJg==
X-CSE-MsgGUID: /v3nCd3QQmSYy0YloLqsPg==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="12665807"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="12665807"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 02:32:54 -0700
X-CSE-ConnectionGUID: /mwAffH8SR+qpUM8mYtICA==
X-CSE-MsgGUID: W5LEf2uXT8iiN3zO/yGZDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="27363758"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 02:32:54 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 02:32:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 02:32:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 02:32:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBiy/CbXaGKSVHAJ9vVNpUeY0vTXs7Am2NU52m2Jy3Mvh+ZcaSTkNzBYm+p9H2TdlaXBy7YvkMnWl5G+Miki2uHgF56qu/D2uSFWQUqtmpv4o3JuUvF/xuQebox1+G79xC/RQm0ReUI9Hn3dkaUPy4GcExMAeuk38KpO1N/hTuOjTAxRYx/0fuRiVnqPGra2Aw5InmqN7Z65p312HlP2pVxMnH9n4EVheWKlLmzO6ppP9ZIbI4Kdz3XA70X0rnifK9ZV6rKgrduOijcRc1i46DeCS18LRqC5zjIM1sr097Sv0PBgojhWGKrAlIfvo0R8w7hLOO+WSzZDN3jxbKs/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44A7ulQH1Cw/KnQIoSLFKobVPr5sg4NnXQgzUKERWyM=;
 b=BsIkY7iUNO7DgkCQlfYuapx+TRsFkkWmo19JO/sy/kEgTVT8E4FvhrfYFl591uouB8isDFuWA+wb0zzAorp2iwebdDF91D7XDRuUYQiBC4idTFWltu2+QYsDf8EobyJ7ZcNkCHPLpsXZWFk50yNM9b6C7Htcj+xIpr5kyt4l+tDGW07b3SyMbpAhB1ePydJZimh7orBTBHLhQUl1fK0oknOEUDLFUWUCDV7h9SkBKk+BVgTl43YWTyCDZ15NESTMVdGTbKcEU6FLTTy2CVzMRNxpIW1LwM/PBBNmwuVYWcjZAkXOPnByV2tgO+sgZT6JEzPPdsJ4AeWXWhbrgIkFPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB7768.namprd11.prod.outlook.com (2603:10b6:8:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.25; Wed, 17 Apr
 2024 09:32:51 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Wed, 17 Apr 2024
 09:32:51 +0000
Message-ID: <a25e0d86-1290-423f-8694-192402db5fd1@intel.com>
Date: Wed, 17 Apr 2024 17:36:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
Content-Language: en-US
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "eric.auger@redhat.com"
	<eric.auger@redhat.com>, "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Pan,
 Jacob jun" <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-11-yi.l.liu@intel.com>
 <BN9PR11MB5276F533511EA5E9D0D9BF968C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB5276F533511EA5E9D0D9BF968C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS0PR11MB7768:EE_
X-MS-Office365-Filtering-Correlation-Id: fa4ee206-4096-458b-c26e-08dc5ec159d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nPyG9MB9T4RXWKszJmyW3W8CuREfUY30Zwnj/VF5lvIedZ/qCwASE10oY798XT+v7wZkUoPPO5XUJxcXeAxvx0HaEamAH0/T6MgYdiztOiSHiHal7W98FVBrldiVCXkFTVT00AdGtiQZqbiPwPeQRd00C+A48UCN3P5jZO0Jb7ZaUQfbQgRWDaaWviz6vtuJTh9ae0zkXc6XA3IMm0szDS9s3Sorq4TS3CL9qKBbLAbJRiMbhmGhrUADkTMReM1uJsHdjbnYjahL/9laaLF2SMELJiXFc9jWhFK7eO1c/9TDZrpfhBPg6m0j11hjRip38DY7iZRW5rthlUNf1iqtUflMg/ys8VZwqKVYJLg12to83JigEAg0En4AK/PXyMmv8KA9l+Iq27PzLsxJj4ylFAK7r5MlHXlcIJof3YkJ30pVy7yc+vP7z15dtwUJGrLIZTXWQB7ls97tfjazqGFc1wVofzWvnVxmCMxqHfCHFfNcxn+dG1ATh7UWjYX/EKmCRYTzGb1eHyuA4T83l9cPRSJ23vTiP9dgWqo5bgzoYqInxtOmPu9QJ5THMZTUxjhcnw5Xil/D2LWvMsvigHcYDvFCf8G2MZmLUuKhbYRNckWkxmwzemLDqOVOQdcoOb8lAm0nWHWcXNCLxF0sX2Msg5ZIjXmApofLPBnyipB+rMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWlQcFVnOG12M1Q2RUN5NzI3dUZhUDRBR0JlbWVDNHFvQlpRQVEvUFRwZVlw?=
 =?utf-8?B?d1dkR3NENlV3aGpmT1ZZNFY0Wk1WeHhSWmxDSmQvRy9hMFdrMlc1ZU5mTmpZ?=
 =?utf-8?B?Q0UzQ3M5OVRSenN3Zm1jRktXV0FxUll5b0Rub2ZjVDJjUHdReUVVVW5DSkMz?=
 =?utf-8?B?eUpHUkdsL2FJRm5rQ2w4akZ1czFsY3J5S2U2YXQrclBsOXVkK3hRc2VTampr?=
 =?utf-8?B?K29Jdll5Nm40VlZIcjVCVFpsYlc4VXc2bk5va2pRR3h5YTFJTkFBOWRRYk5F?=
 =?utf-8?B?NFZoS0Eza3FxTTVNa3BnYXdLQzVkTWFWa095cTN1ZEt1OFBSWkhRR0kyUCtZ?=
 =?utf-8?B?SnMwczQvSjNCVlZvMEl1ejVaUXhOV25LK0xHQUZGZ1U4andzNk04RHA4bTJE?=
 =?utf-8?B?a29rZllrSEtweTBjV1U0UlJTTGNpSklBNm1FUVBURzVRUDcrTk5GY2plR3Bi?=
 =?utf-8?B?RURmeUFNQXhRTXVqdEV6dWNqWlBKc1NySHlHZ3Qva0tQdit0U0Z5b1BsUk02?=
 =?utf-8?B?VDlXTmpIa2pFRk02UStaM3h0K1hvVG1WckRKaGErK09zVnQrYkxmWmtmUGx0?=
 =?utf-8?B?VnZrOEN2OHdpRHQ2OHg2YVN1a3VLUTV4dURjL2pxUFU0aG5BOHRNc09RbG10?=
 =?utf-8?B?NEMvTm9XUG04MHNlN2FnMlcxTFpOcVEvUXdmMFUzSy9TcGV2VFgrcHVTWVNE?=
 =?utf-8?B?VXg4YVdTb1JwbytaUXV0bjBwRUk2czNYZ3o3R2dmZk9INld5MHpwQm9KRDZw?=
 =?utf-8?B?TEJJZ1V6eEEzL1hDcmVncHgzYXhteWxvOXlmSmJkSzBocTNpWjZVK0FJN0FK?=
 =?utf-8?B?M1hJUDF2MHU3UmRmSUF5OThpSm5WQmY5RllRYzZseW5ZeExPcEZZUCtSc2E2?=
 =?utf-8?B?aFhqNGk0eGgvT09RbkoweXV1MUYwVS9uVjFMc2pSQjh3UDVzM2hFZVFtZWFR?=
 =?utf-8?B?MjhwdmFjVnViU1VJSTNESm15ZHdUUmNCT0tVNnJiMjl5QkVIQnUyaHI0a1hT?=
 =?utf-8?B?QjRQc0hCSDFUM3ZDZU53Rmh6LzRFSUgxU2RRZFpURnVmUEF0eTgwUEdBS3NF?=
 =?utf-8?B?ZnRJVkNCemlWUm44QkJjM3dESDd3VjNHOThBM2daSm45VE9yY29IMHFCSDU5?=
 =?utf-8?B?OUt3S1dESHVPTWxuWGMra1haSHB1bnI2UnZHa09JUW5DV042NTg5N2w2TU5S?=
 =?utf-8?B?Z2lSbGtlM0ZCSjg1ZFJIckdBWEszTjluN1JtcC9hNUY1ZHE3OFdZWmNhZmNn?=
 =?utf-8?B?ME9jR2E2YWJMcHQwbFBTY1pCTVdPODM2SDFmeitKRjBaZ2VVSW9zYzBBZXN4?=
 =?utf-8?B?ZUNHZkxITGFSVjhrVytNRzFPcWdHTjc3WEJBdTNPak1QejhsWUNNVFRTN0RH?=
 =?utf-8?B?bWJYRWhoWlBtV1Y3RzlNWkJUbndVZ25zcUpHU01sR3hwdENST05vdFA4dHRk?=
 =?utf-8?B?SDZFc0lBVENTNi9kelIzd0VBQWRtbTExYnNWUWZ0djkzNFViWWhBVjZHdjV6?=
 =?utf-8?B?WElpYTNoRXBRci9kK3paWW9Ld2xmYnBRM0ZJSE1MWWdBeEV1aDJwS3I3V1Vn?=
 =?utf-8?B?bEpiYi9uaER5WHY0T0dmVndNNloxMEZ1UG1aVVlSMm5HY1dWNmZVd3NhdE1h?=
 =?utf-8?B?eEhzZHBOYnBHWnhYTGpzNVJpcWpnVTZTSzg4VmRnSFE4VGNsRHpHNTlCbVcr?=
 =?utf-8?B?S3hmSkdkeEFxOEZucmxvQldvZC91YWh5T3B0Z0R1YTNMYTcvYXZOaDVxYW90?=
 =?utf-8?B?SnZDV3FTKzNFOTRBVlp6ZE9NRGVKamhrV1dZY3l0TVUzSDJEcGVSbXdiSjYz?=
 =?utf-8?B?QnZnTTRGMVdNWUhFWGhHcjRsdjRTT3JqOU9BSUxsK3VFU1JIN2tPcmx0MEsz?=
 =?utf-8?B?eS9zSHU2MnZwcGZyVUhLOHExeVRxOVpMTzdwWEJsUVFmTjlrYXBnQlFvNCtr?=
 =?utf-8?B?ZWN4cHU2VVNRQ2pvRjhyTDc2bWRjTW16eHdiVlFLeDdXSzN0aVdwcFY5UGVu?=
 =?utf-8?B?NFcyR3NXSWFQY1Raa05IS0tMV3JPaEM2czF1cXMvZ3hhR29RUnU4QTA0WnI3?=
 =?utf-8?B?VDBqU3V4TWRnWlBlSTNINCt1RFU5K0pxaWZhamxVVitzM3JHbDBZaEJ3QTh6?=
 =?utf-8?Q?j+R0Rn371OL4Ku5XPHrnykrck?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa4ee206-4096-458b-c26e-08dc5ec159d8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 09:32:51.1894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cNQBPjelpieC8bkBNiBrwWA9bCju4j4br9wgUNLz9raMIQ4PK+1KN/nUBUHUhTDJQsWGWpA0/aoitgcsNvB2Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7768
X-OriginatorOrg: intel.com

On 2024/4/17 17:03, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Friday, April 12, 2024 4:15 PM
>>
>> If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
>> is fine, but no need to go further as nothing to be cleanup and also it
>> may hit unknown issue.
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> with your discussions let's remove it from this series.
> 
> If there is anything to further cleanup it can be done alone.

ok. Would drop it from this series.

-- 
Regards,
Yi Liu

