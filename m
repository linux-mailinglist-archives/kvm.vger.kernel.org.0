Return-Path: <kvm+bounces-14749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 456D48A66E6
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 11:18:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1A58281F9E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 09:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350EF84FC9;
	Tue, 16 Apr 2024 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aOp5Ztdm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884B684D05
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 09:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713259082; cv=fail; b=rW5YtLzKNAbYXkL81qNokrb9toKAoqIjwt18GAqBwTqZMR0h+GErVoxUbcJ7mTcyuY+2A5sFCyPWclbMZtQrn4y1crnd8K2ldQ2HoAg5kfuDlcSt4gD5YJMJFxz9QVY/wVskHMyhuorXEq+NGtpfNqOl5V9usJcxL3bm2h4De2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713259082; c=relaxed/simple;
	bh=vNi2jQGBlc0t/xean8KrYvXL9yOCMiJksrq1hgfwIwo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HKHg6grLPgDuqGxzm52MBXWvm5hXL56qhXpWsIJ2sHgfPM/vbVDziBm8wv4wl/SRhKJcGIXGL2X4lj1Zbj3o0LX9ZgqrGa5iztwDHAkVJYIPb9T6RHoEJkyGzsQkD3P01Pv0avRoPYbx3fsUanhGvO8FnKIFU9didWJvqMWbDiA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aOp5Ztdm; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713259080; x=1744795080;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vNi2jQGBlc0t/xean8KrYvXL9yOCMiJksrq1hgfwIwo=;
  b=aOp5ZtdmAihFScj3NXi/73vlMDQX4Id/fJK1PhbMxjABXM1YBRUAfwlB
   bKnSOtXoOLBA50iwv8chg2YEs2SvQRerbYdsmvx1BkxYfzqcZaph6cmiV
   dJAcMIUCkL/ddxG35+ur5Wt5dkW9fFTwp9WVfaI6Y4AiPXwZJ8Qic/qva
   W06fvZ6vtmAUiFNTgVn93FAqUuVS5Brtte5JODmMbaQY4BPh2CwpaAnYn
   3+VSeVqFsO9fDSEiOErt8xYH/R9rpw6ipZevnChPji1nd3pqjX/M6sTaG
   bkhUWWTyejjv91imK237DaZHyPt3NK47WNqB8UNePt7KeCCRKemJmS49j
   g==;
X-CSE-ConnectionGUID: D0TRoxakQHGV/5ls0PHYEA==
X-CSE-MsgGUID: s5Dh11d/SpiEWzdUKeJsAA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8795785"
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="8795785"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 02:18:00 -0700
X-CSE-ConnectionGUID: NfmP4Tu6QGO4P6ciQxod+Q==
X-CSE-MsgGUID: hSgyFgDVR/eG324f9HDXdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,205,1708416000"; 
   d="scan'208";a="26851827"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 02:17:59 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:17:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 02:17:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 02:17:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 02:17:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BqfUr81wmFAAmnNpY/giZF88lxBRsBllTeCcbp5qLCpBkl5kSFf7zKtG+kphRbloz0//YXeyvH+veSogBnYZtFC01XWORrYkw5pgDO1rUg8IYRlKfep1EoRKHXsgadyzR7fFYDXhuBGmffeLdtOE8MBJxGdgMqoAlvrIkdPygRdfOUx1/mamoP2oUiJs9XedUEm/Gkqds9jDdFRkLGSlVl2nBTVDXrcyUMmFHLiKDrsv4gL1ARH8NMjunJcoDXu5Kag/cPhf/EeJwuJYJnKjfna1JqafrH5GastijXkgq8djnw8PvaNqzV1MmongfsjrIjdGZ9ANPDcq0mQmpMYikg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Q4HdXdZImpGGs1aWevZG8hhwhIcihVX+4hxZaTYf4s=;
 b=jNts2BDfuhzJb1FrUdaBHMZg/qdj/Pr3Sxwyjynzahx5XhyBUGY/x+KOimoNSCvllu8iIQIEJ3Rg/y6mglD12yw6IdDVUQNnUPZDyO/bU3huNSKpmFVQoIf+vX9gNB2vgyMg7mkaaCa4arIDQ1joEzYa7MsNxb6fc8OUDL67QBWPabZEs29joo56bYBRWlckHbjoGsw8j5NZhFHv/n5VLljlewxGh/3ys3GSkU2auCMIjxnAKY/wfy7Fgh5BtzSVJb3CSPkweUYqpKSVb29Kg55iO15wk18GgPLl+s47prmruucrNTIiEBXVJXr9OaHyGoSS66Rm5cIclIGB5nmWWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL3PR11MB6316.namprd11.prod.outlook.com (2603:10b6:208:3b3::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.43; Tue, 16 Apr
 2024 09:17:55 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.7452.046; Tue, 16 Apr 2024
 09:17:55 +0000
Message-ID: <373e52b4-e663-4b2d-9a6b-feaf3a93892b@intel.com>
Date: Tue, 16 Apr 2024 17:21:26 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/12] iommu/vt-d: Return if no dev_pasid is found in
 domain
Content-Language: en-US
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <robin.murphy@arm.com>,
	<eric.auger@redhat.com>, <nicolinc@nvidia.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <iommu@lists.linux.dev>,
	<zhenzhong.duan@intel.com>, <jacob.jun.pan@intel.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-11-yi.l.liu@intel.com>
 <ed73dfc1-a6a2-4a19-b716-7c1f245db75b@linux.intel.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ed73dfc1-a6a2-4a19-b716-7c1f245db75b@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0131.apcprd02.prod.outlook.com
 (2603:1096:4:188::6) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL3PR11MB6316:EE_
X-MS-Office365-Filtering-Correlation-Id: a5ff2af0-dc77-483b-b900-08dc5df619bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HeN4msYOrKOWJ2DAEHFOq/qJl45SAmlcTnoeOkjY2VDWm5/xpBUaJ7GQuzf8oWVh1jHeZJwbgpbGnXmC9x4q7Bc0HSoSdg7hMhlTgAkcTmYg6z+9u7psLplY303pEKAcY7KzZtG5W8KPZC/MsJBK0baF0g8UaP9Msz7PQ8lKJ4eYvjOAu5veD+F4Yj/TneNU6348wCO1LOhZ6XSZNASRAvfLmqkL4cyI80tD4fT2V+30HhewQuCggOWz+X5ItzEQgzlDjdKMqk7/CQv9Cfud55KmdHb4GA7TLhmSjcIeTzyo5EMF9TIlrqnlseUf5pI/G2HN/XEyrhCj2lzxN980MZ1YAKkjUWSvf/3ASS1hdWPumfeqQo+RM2fDWXZh+fd/+gwdVKKOAijFqH7BZQ4sEf158m1E83VZCJxvC1jfPFvEXdwx0CT5yR9ObtDAx6XfgcIzecaPDg3hOkM7UYqCWeIrNHgORsLFlveirbTcbO+dApVZLPuWPQH2D0iZl0fJtBtoHOoXNlK73RvyAXOPcB6dtxmZp1wumt6HG2ILsh0Fd9uGAebRIYJj8Grz/O0XQ3fYC+Pn3C9YEzXeLLjPrYhxuhm2Wcs9pIpcCwI+mIzSfOcbI39szAzP9r2SVCfsvF4bsA+9N2IZxiyxMpGKjOux5oFL+MXLTCp87OHdw2c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm1qTWxNdWxMVVVKVVlmUERMelpFdUZtQjlnM2FRYWF4YlZxOGR2VDVnSExL?=
 =?utf-8?B?YzllNjhzU3NNMTRHZmxMdXhxamplZGlLNFBjVUp2L0hKQzA1dCs5NWY2N1dU?=
 =?utf-8?B?Skg0dE51aFN2STB0OXFUREEzbUQ1VytxVHNHQ2tuUFRNQ2ZJZ2R0RnZ4TDNV?=
 =?utf-8?B?Z1ZobGZYSzQzQ2JjZFJFTzdlRytZc0xpNE82MjZ3UmlCSk5WbzlaMlZ2TjRK?=
 =?utf-8?B?dFdCYXM2MW9vWWdVamNLYVl4Y0llNVJDR0pVdGtWWkJLcVBoT3BSRGdtQjRq?=
 =?utf-8?B?WUJPaGd1REM2a3pZa0puNmE3aEl2akFsejh3b1YwUzlObTh1dkZSV1BPeDRO?=
 =?utf-8?B?UDNURmlKUE1pTDBMOXE0KzlIOVlvbWxUaitSZk0vRmE4cW5sVndQMVo2WVIw?=
 =?utf-8?B?MG90QWU4RUxnT0MzWmxEUEFjSXFNdWo1ei9SamdrS3I1TlVpbFlpY2hWZW4r?=
 =?utf-8?B?VHRaYmhEQUF2OFRGRktBWmt4cCt3ZHFYeDFObmtZSmUvQWlkWUZGL0ZWbEt3?=
 =?utf-8?B?NVIxWWtUVlBKSVVTRExMdjdPcG9jSjlSUHdaZ2NZdURxbTZlVERGV0xZNVBO?=
 =?utf-8?B?UlFWeU15QkdQTXRtV3AxSm8vend3REZUOElLY1JYN2o0M1ZTRHdYYlVaM1Fu?=
 =?utf-8?B?M016NjhpaDhIL0JOaDN0cm1WQTRZQUlSWndabEdrcUtURFAzV3NiaVhXR013?=
 =?utf-8?B?ay9wZ3R4Nm5WNGZEVmsrMzhCanp5TnlYUHdWajgwdDlZdm8yOWxvTkRvQ3JO?=
 =?utf-8?B?UXdzVHZNVHJRZHpvMUs5aERwMUlxM1g1ZTV6NXV2YVhpL3lVVk0vZGRhSHpr?=
 =?utf-8?B?NHlBTTVnS2lnRjNRemUyQ2JVVXJYaWpWUVZPZC81K3pWVFhXTUxHZ2FsTDJ5?=
 =?utf-8?B?UXl2alAxVHBWQVFWcVhRbzFlUkdxZ0htM0l6a0c3MGhwa1V0RHZHcFdCY0Jq?=
 =?utf-8?B?WHYyWXJLN1FBRmJPYXJjbk52S2Q0bEtlQlNFWVp0QjRRRGk2QzMvQS9YcS8z?=
 =?utf-8?B?ZVpJc2N2RGxYaXRVdXp4YUpPaEF6QUY2ZSswNXYxeHBORm5TMUlqZk91bkc2?=
 =?utf-8?B?dVI4VXRyTks2MFh2V1JkZHR4cGh3UHpxUXBld3lTcDNyUlFRZ1J4THNwNE5O?=
 =?utf-8?B?YmZ5OStMb3RwUGJLQWUva1E5SzI2NlY3ZW5LODJwOFFpMC9FRjBFQU8wVlhI?=
 =?utf-8?B?VFg3cEhMaHNxMnZHaGJNRWJhT2wyQ3NHaGM3d09iU1kvQjZveHZBeDhmd1dZ?=
 =?utf-8?B?ZWR0ZDQrRXBGOFlWeHJrSXREMnhaTGlTYWZuMk9LTHFCUzhncWZ5eUFHaHh6?=
 =?utf-8?B?bmtVV0VhMVVRelpBcmpCcEdWSUJnRVNZQ1ZidGpUVmpBTXZRRUpVQlErL013?=
 =?utf-8?B?RHJqLzdUeUZ0MUJDd1pld1NsamFjN3VIWjR6T2lzbnJVTjg5N0tQNXVyRmJs?=
 =?utf-8?B?TEJDU3JML3R4YUgvd3Z1N2x4OVIwaGxmOW9ETGc4ZzcwaS9ITzNMWU9FVlps?=
 =?utf-8?B?UmxaaG85YllaQ2dtcDA2ZlY3N0wvVGNXQi81NWY1Z2hIWlU2bmlKRjJpd05w?=
 =?utf-8?B?QzQ3ZUNlSkxUbkcvVlpxZ0oraWNrSUFtRVZobWJKSThzeTh3cHVBbzZqVlYw?=
 =?utf-8?B?NWh2L1AwZFBDNXB1bDZCNmM2WUdzKzJkVFhYMk9WVlhoQmhZZmdFdkJvWjRY?=
 =?utf-8?B?Yjd3dDBJQ2RmVVAwMGE2SGNXckx1MU9XWjIxdzBBc0swbEp1S2J2QlRsZmUw?=
 =?utf-8?B?MGt1NmVkaWdqQTVpa05hakh5QzBmazIxa05xRTFoUXg2OER1ckhqZ09MTXVD?=
 =?utf-8?B?RVdLTlVUQW5lYktkMlRzcC9YWkxNam9mcExDZS82UzdyY1hKSEdudzExYVdP?=
 =?utf-8?B?Z3BwRTliN1Z3Ylh2OEFyYmpmK0d4eG00STdGck1hU1g5TnpHYkRYd1BZSTVU?=
 =?utf-8?B?cGcrekxpdEJucmlYUXl3Y1F6SG1Fd0RQTTR1RDcvenRwU0lOcmxMd3kzcmN1?=
 =?utf-8?B?Nk12bTR3TngvcTFQeFI0OWdoRndrSDErN2lsVGU5aDJLV1AxMHhhMFhzdXRv?=
 =?utf-8?B?RWRYbVBzWkRVempSU2dVa0lpNkRQNUFXSGJYMHdkME0yUm1kL21SQzNUQmhI?=
 =?utf-8?Q?TtnqjxxEFkQQauSu6fu81+hzd?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5ff2af0-dc77-483b-b900-08dc5df619bf
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 09:17:55.8182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBkW3pq+0aSWRSugTWCWMsryVWRE3VwtVQUhx3B9quwIqWS9By+OC2He+OcEZf8rEkVKb9fV3KnSx7d1kq6qvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6316
X-OriginatorOrg: intel.com


n 2024/4/15 14:04, Baolu Lu wrote:
> On 4/12/24 4:15 PM, Yi Liu wrote:
>> If no dev_pasid is found, it should be a problem of caller. So a WARN_ON
>> is fine, but no need to go further as nothing to be cleanup and also it
>> may hit unknown issue.
> 
> If "... it should be a problem of caller ...", then the check and WARN()
> should be added in the caller instead of individual drivers.
> 
>>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>> ---
>>   drivers/iommu/intel/iommu.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index df49aed3df5e..fff7dea012a7 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -4614,8 +4614,9 @@ static void intel_iommu_remove_dev_pasid(struct 
>> device *dev, ioasid_t pasid,
>>               break;
>>           }
>>       }
>> -    WARN_ON_ONCE(!dev_pasid);
>>       spin_unlock_irqrestore(&dmar_domain->lock, flags);
>> +    if (WARN_ON_ONCE(!dev_pasid))
>> +        return;
> 
> The iommu core calls remove_dev_pasid op to tear down the translation on
> a pasid and park it in a BLOCKED state. Since this is a must-be-
> successful callback, it makes no sense to return before tearing down the
> pasid table entry.

but if no dev_pasid is found, does it mean there is no pasid table entry
to be destroyed? That's why I think it deserves a warn, but no need to
continue.

> 
>  From the Intel iommu driver's perspective, the pasid devices have
> already been tracked in the core, hence the dev_pasid is a duplicate and
> will be removed later, so don't use it for other purposes.


good to know it. But for the current code, if we continue, it would hit
call trace in the end in the intel_iommu_debugfs_remove_dev_pasid().

> In the end, perhaps we just need to remove the WARN_ON() from the code.
> 
>>       domain_detach_iommu(dmar_domain, iommu);
>>       intel_iommu_debugfs_remove_dev_pasid(dev_pasid);
> 
> Best regards,
> baolu

-- 
Regards,
Yi Liu

