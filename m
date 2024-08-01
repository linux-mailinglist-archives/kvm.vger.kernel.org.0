Return-Path: <kvm+bounces-22893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BDAF944576
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 69284B2257B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9308E158546;
	Thu,  1 Aug 2024 07:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IsuppPcO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557CD22F19
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 07:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722497577; cv=fail; b=dm3AgMk8hxNP76FznLXYbVz2u91RYcD/qU3hKpW2RgAW4Jsp1kis3XglkN9Y2AwjfZj65701kK0VhOYLSirwxMbfD8xgn3EceiQx7LGqOIK8gSILLy0sbv+5khH3sPlRxWDFW4CHgfy5dENi4LnUWn7s9zXNLdX3ojdGn4Expds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722497577; c=relaxed/simple;
	bh=HAAx5BVL8yYz5Y/cC8Ub976JNsLiNbtBqyKM+uBy0kQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=uKkJ8ok8BhFjgx8syxmmBUcqywYW5e3oSLTW1Oe5VQ8zuM8UPdlWr2hcXv+9Dy0bCHrNQCrMxYLZFnf8ha4QcW8Sq5RCJkBfFd5nFp+0arjPZudRjm5wOHMvdehMN8vKGCxXdkprTAvXJ4/WY5uz5HbHS+NFUe9sYJxUPrAYp7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IsuppPcO; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722497576; x=1754033576;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HAAx5BVL8yYz5Y/cC8Ub976JNsLiNbtBqyKM+uBy0kQ=;
  b=IsuppPcOtO+NpLxu4xTAhtIlPzelYubmXf3i738UbUfX9INtUYZz3pY3
   mzoMjshl9mWEvRe8lBNdfVBCH53Dyce2+j0neiMqCIKLMe67ol0y2jgLK
   WOsKfJgjt7fZRgYvRVJZ1DOSJjIWcogN6Vn98DpSOnWOaTjz9OXNQKKIm
   KaklOjdFog+DSibnxGqGf+3KGi7Bqj4DKtPGyym9wk7vI0pvO2mGIJTbp
   PXzbW32P2AB4r72eXAi/I7P6BZcCTsOjAOY+JBLWLwictIv0o707IB1/V
   LiRBB0QdilPkaOcqZrEbwj1TuqSAqIxNijhKwoGQ4FLRqqBweV1HnbZ1E
   w==;
X-CSE-ConnectionGUID: uMh5oQShT6SiL3LKrL/aIA==
X-CSE-MsgGUID: DvCPlr1eROy8hTvk4U9lzw==
X-IronPort-AV: E=McAfee;i="6700,10204,11150"; a="20246552"
X-IronPort-AV: E=Sophos;i="6.09,253,1716274800"; 
   d="scan'208";a="20246552"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2024 00:32:55 -0700
X-CSE-ConnectionGUID: wwQh48OsQs+A/GjoE+hN7g==
X-CSE-MsgGUID: 7l2Ov2Y+RyGiKTpyK4pmEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,253,1716274800"; 
   d="scan'208";a="59755146"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Aug 2024 00:32:28 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 1 Aug 2024 00:32:26 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 1 Aug 2024 00:32:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 1 Aug 2024 00:32:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cE1xsFgZlCUAoE4cdCr3Mye0Wzq8uHA1kOYJCO8PIUKbr+s2o6/4NcM9HJLD7vV0EWPa7FQkoOcusenL7AU66DYN2ajzBc/xCHkjXNoLwUhba204OyTakXE45PFEXDSgIjXxtwv2h4G2rYAM1q1cf7q4Ypl6HYvQVwXo9se/RJwO7490Aq4Do1VslU4LiVQnr34hLU5oKCvul74uiGtZf4oYCSrbjfjOy53JtR3EFWdWx9bh7epmgwqRG8dsvZ7cqcx3iLz+nfPONiLyGzovucu7p3LH3Apm/Sk2nvADbSFxQKeEcAC7TXiO/Vowf5TIvlHVbLIwYzii0UOU4PaqRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MSsmORUCCY+fuhPfXmxXXxEflB3VdknDdIOyX7wVhWo=;
 b=vK6qK8PoWKvxLQ0EEazaXV4dlGEceE/i5jlH3lleVRYyFCsvjolqIyIOLb8ELP2mhCZ1ZtY3vJes3pncA6/T0xVR4N6QyHq/YfKdaBz0ElJFDzTZ4UbMWI9eznGZ44yeJ+KpLbwXF9Km4RFlF+RaoVrCfp+t2z5eHKybgaHdNyrUC2X2wkf4ZgQPfzKhqbez4TwiDrn3SbpfJoTGDZSduiQp0yDh6QwDPK7NMCHBHXsBfYja0RihKJWdzGbpHaiaLrcwJauO6sna2NMOFFtanf7UDgJrjVlyV28PuQAFrtEKII6DV/fSNG2E+toYRelgHyCAApaAc+tyRtmJ4vHA1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by SA1PR11MB7040.namprd11.prod.outlook.com (2603:10b6:806:2b7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.33; Thu, 1 Aug
 2024 07:32:19 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::47aa:294c:21c9:a6b8]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::47aa:294c:21c9:a6b8%4]) with mapi id 15.20.7807.030; Thu, 1 Aug 2024
 07:32:19 +0000
Message-ID: <bfda9a70-5b03-4e5d-85ee-ad2f6f5e59b7@intel.com>
Date: Thu, 1 Aug 2024 15:32:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/6] Enable shared device assignment
To: David Hildenbrand <david@redhat.com>, Chenyi Qiang
	<chenyi.qiang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter Xu
	<peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Edgecombe Rick P <rick.p.edgecombe@intel.com>,
	Wang Wei W <wei.w.wang@intel.com>, Peng Chao P <chao.p.peng@intel.com>, "Gao
 Chao" <chao.gao@intel.com>, Wu Hao <hao.wu@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, "Lu, Aaron" <aaron.lu@intel.com>
References: <20240725072118.358923-1-chenyi.qiang@intel.com>
 <ace9bb98-1415-460f-b8f5-e50607fbce20@redhat.com>
 <69091ee4-f1c9-43ce-8a2a-9bb370e8115f@intel.com>
 <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
Content-Language: en-US
From: "Yin, Fengwei" <fengwei.yin@intel.com>
In-Reply-To: <d87a5e47-3c48-4e20-b3de-e83c2ca44606@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|SA1PR11MB7040:EE_
X-MS-Office365-Filtering-Correlation-Id: cc90c999-ccfc-443e-574e-08dcb1fc12e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UGsvS0lkSUJLNzJRRWlEQ0MwWWV4cGJvOUpPa2ZjNjRqSmREYzlmbHMxbU91?=
 =?utf-8?B?eS9qYTdGR0JVenR2OVRjSkd1K1dzNnpDUGhacEF2RitIZk1YOEFLNzdmUzYx?=
 =?utf-8?B?NC9GUWhPQjVRMVhXcTlXVDlBOFZxbWJ3bjcwN3J2OHpWQ3AvdEJYRjdheW9i?=
 =?utf-8?B?YTNDUjQ5dTNWVkVFeTdGQVdEcFNwOWp4aElLNGZGa010YVNOMWM1eFNMNXVS?=
 =?utf-8?B?djhVNE5ycExVZUJVcFR5dVlvbWxKZVlpb1k4YU5EMll4MVB6YUs1dWxHdGd1?=
 =?utf-8?B?SG5mcDJJWFZpUUliTkZucDdCZUxwVHRMVjkzU0dMNWNZRkJGb3lvMkJrV1Vz?=
 =?utf-8?B?UWVhb1NPWVNrR1A4ZklYUW5VbnpiY3dXdmV5dFJYWVNRVUZlS2E1NUhVUDhU?=
 =?utf-8?B?aHpaNnNwbkNyL2J1c2pPK2pFdkVHOStBaHhucFZEd0w4M2R4OVNGUXFrYkc4?=
 =?utf-8?B?dlY4MkJaTFA2K2FieVF0SWNKUnNCYWwrazgvNmxSRzBHOFZGNkJ6NGFRU1N6?=
 =?utf-8?B?WkE5WlJ0MlRKd0RpcjVXSE9aMU9mWCtIZDI0enJkcWJoRmdnUVNGWkErVVY5?=
 =?utf-8?B?OEpBaVRLRW5QdFoyK1RpNGRyb01JSjByaWhYdVljcnhyS2xFcU9FZVA5dzI5?=
 =?utf-8?B?bFYwTlN3RjErc3YvTGhrUUdCWmhITmlVM0VTa2lNaUVTblFRaUg1bGVyZDVm?=
 =?utf-8?B?VG9XUzc2a1JtcFpPbVVsWmY2YVZmMVQwVGVNSnR5SHZ2eFpoZmx3NjIzYU9V?=
 =?utf-8?B?Ri9WTHU1ZmhLS3g5ZnpEcUE4OVBTWGJKS1VWdGcxTVNrTU1aT1lER1RVcFda?=
 =?utf-8?B?eUplY3ZlVEtZd3cxQzNSNnZPVlE3VkNJRC9NdnlzUVV1MW1Cb3RKTTAyNXVx?=
 =?utf-8?B?K0puUlBXNXdoZXNIRWFxUWIwWG9obG80UHA1bkhBaDlCVmdtK2VEYTdCeXdx?=
 =?utf-8?B?RWo3YjhFUEZkQjY5OFJIanhpdGRMQ3dPSkU3TmxkK2ZVNXRNbFkxVndBOS9O?=
 =?utf-8?B?ajBDK1hlRC9xZ0RsVDM1bHFMVzNURVJ3cy9OazZlRGkyK0hOV1JsTDZwOEFG?=
 =?utf-8?B?a2tzVmFrRnJZQWZtWkVKcU1WdEZ4NWhTeEhQNWFvTjljc1FVb2tsNklWcUtB?=
 =?utf-8?B?RytuaEhOeEJOSFdVd0NqMThieWlaME5Nd1Y1eWFiU0FwSmpzNmMvUlhodmQ4?=
 =?utf-8?B?endmdXJ1K2ZPeC80VGlsS3BBbkVLRzI3WHBEbW1JQWNqTlVxYjlpTWRvM3lp?=
 =?utf-8?B?QUdxYWtVWks4YzZkcDF6dHp5dWlmNGNOeWlFcWM1cHdnSHVvV2twUDVQUDRm?=
 =?utf-8?B?TVhsL3V0REJkc3oxSEFpaWk1N2xORHd3TnRPZTFCR2lwNjB1Z3M3NVlMTnUy?=
 =?utf-8?B?VE9ZYXhIUTVGSkRpUVlFSjNpN1pHMmpJNDFVYmVNQldKZ0xPM2Z1bjVkN1ll?=
 =?utf-8?B?T1BZZXk1TGhrK0YvOTI5V0dEc2ZNS3VIT2EzSWRaY2hXVTB1UHZPS2h0dWp2?=
 =?utf-8?B?aEZDb3BBOG1UdDgwbUxGMW4vUXRCbjJJS3BQdWRjcHpqUEgxOEhOY0I4RXZa?=
 =?utf-8?B?NG0zMDBPMHU1eXF5WHVvY003U0RDSVA3YmZGSEI3Q0VtcUhCUFd0UFg5MkJv?=
 =?utf-8?B?d1o5bGNDTmNPbGQ2T1lWay8rdFVXa2FRN0Y3TkJ4NEhDRzQzMWFMTmxhRTB5?=
 =?utf-8?B?aDBiS1lkNm5xSE5OWXpBWWFkcjNYS0ZiZVdIUjNjd1BxZFNhaVZJdmxwWDJk?=
 =?utf-8?Q?fcP04XH8U5w0jkVcR0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVQzMWpHcnFXNVFvUzdOWTZuZGpiY1M2eXVsaFdUUnowVlBpUy9FSUJBeGFV?=
 =?utf-8?B?UlA0ZW0zUlpoODZUaStBM3RTbWZMVHhWZHZPRmtydkF4YlhXVW9WNXZxTmhr?=
 =?utf-8?B?OGJkUnlTeHFXSjVnVFVXNGg2UnJPTjE2dWszQzEvZytnZHBHU3ZpanRXb2dp?=
 =?utf-8?B?b0JBbW5DdmJYNlR0TVBlTHRwN0pBRUQ2REVBNFBQQ3ovLzUyYWZjQk1ZQmxV?=
 =?utf-8?B?VloxYk9kbFkySGdrUlVSeFJITE0zZmw2Zit0L3pycTB3REZnTm9rYU9nWjls?=
 =?utf-8?B?di9HK0Q3R1kzd00vcy80SGJxcU5hY1d6VE9VWVVxTWJ4YjRTVVlBUkNTd08w?=
 =?utf-8?B?bmRQMERBTkI5QU5wY1BoWEVaeEdVN0U2SXBuMGc3YkN1VnA5WDgyM0xkS2RI?=
 =?utf-8?B?T081ZjZzNlU1eEVZZHVwb2ZjeHArRG1sTDlCRmxaOWRUelJsalRiM3J5RWFo?=
 =?utf-8?B?blgvL1lWaVRMT0VES0ZuNmYyVC83UkludU9ZZU1WS3MwM3ZyS29VYUpvZmNy?=
 =?utf-8?B?UHBrQ0FEVUZ4T29wM3B3Tnh0eko0Z3ZQK1VIT1JBcHNReXJPUjd2ZElxSnhI?=
 =?utf-8?B?RGNLMndZdVQ2RTROV3RDdnFQYUZSOE1CVTVacFN5N1RaYmxFLzAvUnhmbkRn?=
 =?utf-8?B?RDlVaEtydjFIeVl0dk0vS2dnZFdZVHNCdHJNSmZTN1BrZitmNDRqSytOMFhq?=
 =?utf-8?B?Si9uNE5nSlBkVDBtUTlSV3ZMYUt6NnhKc0dSTVQyb1BqSTZFcno0ZHFqT2Qy?=
 =?utf-8?B?ZUxESjYzWWt0MnlvUG1WSVNmNlFXMnNIS1U3STZtMVZ5TFIyVTBBQTRZck41?=
 =?utf-8?B?dTV0bW1HT2REM0hEa0daMjdydENUV3M3NnZrRFk3dnZxRHQ1MVVPNUdURSt3?=
 =?utf-8?B?UytKQndqaGw3dkFQR2lqbmdjRm5hUXgzemxSOWhob3djQkNTWVN5cU1rU1VJ?=
 =?utf-8?B?TDd1TkVjbFhXQ2kwYzZTSTMwRlBWa29PUkxhTzR1UkJCeDV4YWd5SWFPdDZq?=
 =?utf-8?B?YzhENVNSNU5ZbFlKVlhzWmE0eENZN0VlYWdIS1RkTTFvQkxQY2RDQXA2WjhX?=
 =?utf-8?B?VkYvcVdGYm0rRVdLc3NqQW9IdS9OVnBsMkhJekhpMldXR2ordzUrUU95b25Y?=
 =?utf-8?B?V1g3SW9WWFJFeUducU9VWnRvRnVsWldNRGxrTWIwc1VkY1ZMNnR0QU9jUmpa?=
 =?utf-8?B?cng1bEllSVhsRVo1NFZaR3RjdVNoa1NHZDNlZGlPSFBKb2FsVkd6Z2diakxk?=
 =?utf-8?B?b3FRaTRiWDh0Z09JcTY1SnZMOUtrNlYza2JSR1MzYzVEeGpuWDIrUDAvdWdE?=
 =?utf-8?B?bmcreUcxTzBDelpjd3FJZGlTMngwVUtqOVp4SVBqcEdxNThzZ3E3SVVzWDBZ?=
 =?utf-8?B?bk1qemxjRzkraVZYVWdUUDl5MEM0K04wTU1FNjNZc3FxQ0ZzWUYwajdPcVFI?=
 =?utf-8?B?UUpWbVVEaHpxdHhya25sRTZCaTBZL3IrcUl0c1Q0cDI0bU5UUVU0TkVnTlln?=
 =?utf-8?B?bnFRMjNpYm04MllXU25wMkw3WmZJQU5vbEFCdEhqZDFBcjN2ZEtsV1BMYmNQ?=
 =?utf-8?B?ZkJqVnIvSmRQblRGRW1xV3Y1b09wbCt3a2pBSU93TXdGSmtybFd0YlBtQkJm?=
 =?utf-8?B?UzArSnVaTU1BSTRGakVuakM3d2VoTytHMytoWTcxT082WFZaL3Z0aXZaM3pS?=
 =?utf-8?B?dkZodDh3REpWc2dMUTNGYjlhTmFja2ZYMytEcmovTUkyRUU4V2h4TGhROWpq?=
 =?utf-8?B?aDdqWmZHdEI0c0Jzak9vckx2ZUp3cVFBTDNmdTBwQ2IwZjB5d1F0elVyNkZN?=
 =?utf-8?B?N1NBMnd6dzN2amozakcxN0RGTTF4M3F5YUtrdERBUEczQXRaRVlaVWVLSDdU?=
 =?utf-8?B?d2xha0lXUEdzdEJGdE4xUWdONFFlajF5d0dtV3ppVGNRQ1R5YjdwU1BmZ1lM?=
 =?utf-8?B?RmJVN0JkQzZUYnYxZGF5dEl0SjYyMU9EMEs0UE0yUHdmaytqV0hUTW5aSTNM?=
 =?utf-8?B?MzJpTkpNQ29FeWZHbXk0WFFRR2k4azNUMHdwQW1oTlQ0N1ZqcGhTTGJaeDEr?=
 =?utf-8?B?VjVUUU9EeWRHTUZ5MnNaTGxwQXVVVm8xQjJBU2pKVDkwa1ZCUVJEMDVXQnJj?=
 =?utf-8?B?cmt0YUVJQVVHN2NrQURwbDJCOXlMNDVTWWtoSjcya3lqWGYrQU1acUcrQzAx?=
 =?utf-8?B?U0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc90c999-ccfc-443e-574e-08dcb1fc12e6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2024 07:32:18.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iNQSAP1eRGAFwUGZ5mduHNY2hXRI+aR39Xtff7FmhwavRlPNkK/B5t+xcC1i1DxktWgh2orihhjnyq9jraMNDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7040
X-OriginatorOrg: intel.com

Hi David,

On 7/26/2024 3:20 PM, David Hildenbrand wrote:
> Yes, there have been discussions about that, also in the context of 
> supporting huge pages while allowing for the guest to still convert 
> individual 4K chunks ...
> 
> A summary is here [1]. Likely more things will be covered at Linux 
> Plumbers.
> 
> 
> [1] 
> https://lore.kernel.org/kvm/20240712232937.2861788-1-ackerleytng@google.com/
This is a very valuable link. Thanks a lot for sharing.

Aaron and I are particular interesting to the huge page (both hugetlb
and THP) support for gmem_fd (per our testing, at least 10%+ performance
gain with it with TDX for many workloads). We will monitor the linux-mm
for such kind of discussion. I am wondering whether it's possible that
you can involve Aaron and me if the discussion is still open but not on
the mailing list (I suppose you will be included always for such kind of
discussion). Thanks.


Regards
Yin, Fengwei

