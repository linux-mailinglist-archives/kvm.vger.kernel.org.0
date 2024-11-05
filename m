Return-Path: <kvm+bounces-30702-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EFD89BC7B5
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 09:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3201283258
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 08:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4916E1FF049;
	Tue,  5 Nov 2024 08:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k9szkmZg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB61E1FDFA3
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 08:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730794124; cv=fail; b=aLRZYK9lIVPlFzAput11wXgOdDxj/N8Hh4Nz7g82qkW1qL0Y9z0Kzgwhc8vL/d532wSuo2xJ6cW9/9RA1equxnGMn2zE5SF05Pz2iebDNHLUobfOgzT4GjTNfEZjInC4f8rz9oziUNCVEpdv1aJig1rTkAY08hocYH22x+4gEyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730794124; c=relaxed/simple;
	bh=iahh99GkDbmGVsFl2RhF6Vmwag7XL6Z9X99BFrpsIPc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lHRz0TSnojNoWUb7072d67hv8o87v/mtoUVXNkfsybntQdNUovqyV21uoqdYx25IFSXW7OnvvzW2/ZEW8Rl1eud234UkYfvnbbydlGNlpT2iuBzbXK5Ndan0tKrm//uQTEnglYThQhLFg21HOtmWLj30tHQRPkf//+aYm8aiVJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k9szkmZg; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730794123; x=1762330123;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iahh99GkDbmGVsFl2RhF6Vmwag7XL6Z9X99BFrpsIPc=;
  b=k9szkmZg9yg9xuCQrOWy8frYxVlCShsAc9soW9D18yo4x5MOkXfWqhC/
   ldXrbxuvuaG+4u1br8NWgpgzSiC5sjxRTGV2TLNZfQshuWvWkjw/zuakh
   1V2lHk+DVTqkMe6XU+tMgDf0NHc6qicUI68/UI8kOX+lkKG9iUKpYqO4x
   L3jW3BPVEYy6L6M/eVJvN/J1vjOY7L4dWXh1PLd8D9LUSjloL5yCqxS0+
   4Rl4wLVdjCJfJiD2nJlkAy3pjJ8mlzs4TKqxmLle8a5hTIlvwC3PzM6rn
   qdJfPJHmatevoFjYMtlABEeP5pgHdWGTZsOY5oKy6bVr8lVwc66p3s1hL
   Q==;
X-CSE-ConnectionGUID: DIhqSdokR6GjxMWYx66Pvg==
X-CSE-MsgGUID: C/jRx+z2R6qL4MkWAg7SVA==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="30403075"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="30403075"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 00:08:42 -0800
X-CSE-ConnectionGUID: VkuVGf/PR9uviysrmAuzIA==
X-CSE-MsgGUID: 6pwJOtShQfKrN+k/cvIpXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="84728252"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 00:06:37 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 00:06:36 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 00:06:36 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 00:06:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OWnKhaTNvmefZ8tgTW0VLW3JBJuiFoCoLz0HVN7gpRJlnCIXGM7ibnEyKtV5CGk6QufIXVaDwDjUBskuqBAh9UsMjOzW/D5odPQGZ1hUGqF8zkG93kfPwkPqKN6JAHP9d1omKkt8I69YRYtTh9Ibidc6mzfFCBPXVWvN33gscscQFPOVMsT9sqVgqR5x124D2jfK4uAp9iLMeg2JBXqD69t281WMe7J+olXYxFB2V8MiUC4LBls+Qo94xHx2meHc882mhHZ4tgCQkqSMLmSaYI3pkyoBQOg0nfo2BrYNihVPUBZIT3KhPlHTavY6qtwvVhs8NEy26UdmKtX+NjWS2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HL3+moDJwS850X5OjJkhwev0dJJSI/escjUFcQvaBdI=;
 b=kGdCIFMI5LJOm+KDxxwqs9wOZj+6m2wBDiV4R95FEf0uXMr4avJPZuYtiF7Wd/5uxGqm+qTTNDILQS+iBr5FywzUWNobxuMdBiflVJLs+SG2K5g2IXX6P1bmBiTBE17WddzuyMeeN/IJ/IsK+EJ/8oAv2yD+jANomCzNsy21CVzy7WXVb/x8giKT9JJYapYfW89KeDC4x0IwKT/VO05ChezrgIysMr7Iwp9KGK+OmmUMNwwJdfZmEXZ4+TEk/Z2iSfpxYIJOPF2MzcyfRTKnwG1hvrqDPC7LUyTz6r0ziGZXYhWKDl5UnRLw3z30CfAphUMdxq1lI6fwgYbegQnGxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by SN7PR11MB7491.namprd11.prod.outlook.com (2603:10b6:806:349::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 08:06:24 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 08:06:24 +0000
Message-ID: <64f4e0ea-fb0f-41d1-84a1-353d18d5d516@intel.com>
Date: Tue, 5 Nov 2024 16:10:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/12] iommu: Introduce a replace API for device pasid
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-2-yi.l.liu@intel.com>
 <9846d58f-c6c8-41e8-b9fc-aa782ea8b585@linux.intel.com>
 <4f33b93c-6e86-428d-a942-09cd959a2f08@intel.com>
 <6e395258-96a1-44a5-a98f-41667e4ef715@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <6e395258-96a1-44a5-a98f-41667e4ef715@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR03CA0125.apcprd03.prod.outlook.com
 (2603:1096:4:91::29) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|SN7PR11MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ecf3d30-0e44-431b-8c07-08dcfd70bdba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VlR0WklTRXRUendMWUZveDJVTkpzZkdnV2FPYUN6Qld4d2lMTkY0VHNkY0M2?=
 =?utf-8?B?ZFBIeFUzKzg3aEhHdERwczhwd1luN0xCTFhlVjFTNTNBRnI3Wlo4dC93cElY?=
 =?utf-8?B?eTdqcWFOTXdtbkg4aW5IS1NHbDNsSXNIUjBYbGhlUDZmNHF3MWd2K0xlQklr?=
 =?utf-8?B?YnNEY1ZHOXRtS1BOTTdSL1NsT3ExZFRIM3lBVXk1SGJlNHYxcDQ4d1lKT0Vo?=
 =?utf-8?B?VEZSZGg0Q3V0SHZXcGRydlByNFN2RU0wSldET0F6RjllTkZVSCtUYitGcDEv?=
 =?utf-8?B?bjMwM1oyaXVnVEQwblJqc3VYV1lOVGZjYkpGUmtjeTBNbmpHWDUrWVdoOFBD?=
 =?utf-8?B?Wis0eWF0MUorS3BsQ0RDQ0I1b05YeFU0UkFDRHQ1c25IR1JpL0F3Mm5wZGZw?=
 =?utf-8?B?OWlUdkEzeDNtaXlzUVpobW9yM3hMeVNpRUZ3ZEw1SVpQdzZCajBpRFpUanla?=
 =?utf-8?B?elR6ODRkMm1NLy82Z1Fra1RvVWN3MS9TbnY0UUZGaEI2OS9HSVhFbzZSYVdP?=
 =?utf-8?B?cE1IVUFVUk4vNmhqd0lPLzFYTWlQZWlDSnU2MWJJa2d3dDc0VlFtOWcvSjk1?=
 =?utf-8?B?dndYSVJvWFFsdEovY2xJdGZxR2pvalUrSlc3d2ZiZ0pNQTk5RHBGemZ4VW5J?=
 =?utf-8?B?QWlNSGRjQWRGdm1seEpUV0YrSWZYN3JibGZjWjJmM1R2Q28xNUkzWEhrRm8z?=
 =?utf-8?B?c3pDbUZGYzY1bVNKQUpxQWhnNHU5M2Y0T0t0N2Y0MytZUTFMSUZVcDVrV0Nl?=
 =?utf-8?B?S2o3OEMvVnJkejIvZlgrb1BhUzZydk5TM3crdFd0dDBiSElhQ0RCTFRPWloy?=
 =?utf-8?B?TEoxNFgxVCtsK2xzSERDREwvT3VWL0pvS25UNmZTczAxK3FJdU5Iak9lcmx2?=
 =?utf-8?B?eklSU3ZCeCt3STErQi9VWkF6bW0vcVZ5cEhqZzFIbjhnNkh6RHB6U0RoUTZS?=
 =?utf-8?B?QjJCbDVNcVpkdktKV0JCMGRIeXh3ZUlvd2NmU201dHlWM0lEa2xiaFM4dkhz?=
 =?utf-8?B?MlRYK2hGUGg5d0RrSVpaZnlSRElML1JIOTlnSzZLb1oyb2lHZ2NBS0M1aHlH?=
 =?utf-8?B?R01wamduMUdwK0pqYnRYVEUwZGFYV1ZNMFIwK0ZNYzN0blp3S3lEcE5QNGt5?=
 =?utf-8?B?a1hOZXJhRHJPOGpXQ0FDcFBJamp0UUpUT2NNOUdoSUVmWGJEL1V3VmxkQ3ND?=
 =?utf-8?B?aHdyZjI0cnZ3Q1lzUy9vTFd3NlZKTFNnNmNBUWhuYVFCSzNUd3NVdzJYRC9m?=
 =?utf-8?B?MmZLd2dJTnp3Z2RJdTNZTTNVejlQcGszbzZyOW5naEFNaE5vUWdnZklJOXJR?=
 =?utf-8?B?TXVPYjJ5MEtiNG5YbVZuUkw0RHpkMGdmcU5oSlpTN3RiNUNVdW5GclB0OW1t?=
 =?utf-8?B?L1kvdjVDTWVQUDg2NkV3U1MrMzB3NlI1NC9rZWhlQWJMY1IwRkdCUnlFMWE3?=
 =?utf-8?B?bWI5bUNORXk4bE1ISlBHcWxBOEpPSVFLMVhvYjJvUmZkQlV1OU9tY00zWSt2?=
 =?utf-8?B?TDhCbGR1dUFGb2VOaVRJYzA3dUdTQTVkc09URURySC90WmoySThzQ0Mwc2R4?=
 =?utf-8?B?THNsaUsrNndrc1ViaWhkc2tDQWNYeUROb0t3ZTY4UU9OWWV0WE1OTzFubHBm?=
 =?utf-8?B?MVZWOUZmbjA0N3pTUm1RUTBaWitQeW9URXBhbUc1aGxHZGhXR3F3SStUZUh5?=
 =?utf-8?B?Sk8zZnRWencvM1J2cFZqSmZUUzJRdWRqMUhnRFdzNHZUMi9zTTVNMFV1RUZs?=
 =?utf-8?Q?1a1W1pP36sMkN12Pp+LHChMA54l1spRhV5J9MY8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlczZzdhZWJkSTZUOU5BQzI0MnlmTitPUlhGMlIybTBsNVhVSTQ1cjRNMk5E?=
 =?utf-8?B?NzdpUTNHODM3T1BRd1lYamFFanFEWEtUeTlSNUx4WStkM2tja21XWDVsd0hw?=
 =?utf-8?B?ZlVJYXB0VHhWYVVIcmN3NHp2Zk13SUhUTzdGZ25OUlNKRWFoTHRqaEdjYU05?=
 =?utf-8?B?bFF3a2lENktveDd4cEh2a3BOWXRBQVFZNmFLelFJL3Y0VGRVbzI4bDR1T1pk?=
 =?utf-8?B?c3RPSDAyeWVYdm12NURwMmdlME5nNmhVRlBkRktPMVY2dy82eGdOcjFtaEYx?=
 =?utf-8?B?cjhQZkxmN0NJbC9DTmx3MUpzM2hEazltZjBDanVkK1FLNTNlQUZWSlUzRHZi?=
 =?utf-8?B?U0JrY1BuL3NPbC82YXRTSHRzM1hpUnd2bllySzVMS1NtcVcvcVY5N2RlT3ZW?=
 =?utf-8?B?T241V25TQktsODc4YklMTG9zUHNRaDJFVEg1ak5ycXI3ZXNySkZoMGo2MUg4?=
 =?utf-8?B?V1BPWjF5TGlBRitkQzZWRmVLV1haQW1rQ0Jtci80M3dwS05ZS2ZZMFA5ZGxn?=
 =?utf-8?B?SGNoeFQ0dlcyMWllaHcwWWpGVlY4MUsvdzBsYmtySUJ5ZnVMWXk4RzkybDUz?=
 =?utf-8?B?SHRoSXNMeDg3WkNsRFY2aVluVld2V0ZPOHRvbEF6RnhvZ2UwWWRqUzJBOUMy?=
 =?utf-8?B?VUJ0N0IxUDNoTUZNNk54MTAvT293YjhnRVpGcm1EZjU3enpHdURhOEErWis5?=
 =?utf-8?B?aHp0S2VyZUdaMzlET1k2L21kdzVkc1BNcXlQK2tidkk1NWhQdVlxL0N3WGVD?=
 =?utf-8?B?OWFwMk44bkdQODRyV2V4L2dudVBjeFVXRC9TdEJMRC90QzFxWXJKdE5LRGV3?=
 =?utf-8?B?bStpL3V0bm9mZU5Bb2V1NFBXUCthYlhNYVZkdWhHTGtibGdMVzhtMEZOL1hZ?=
 =?utf-8?B?VjlraFF1OG5PYVB2V2FxaEx0UTI0NlA2T2lCU0xMOFNmRkJMcHZ1NnJvRVBu?=
 =?utf-8?B?QmJmdm5mNXZqemJJNVo0WDhUempicitYMS8raWFYa0VVRVhidVkwQUNoSXRl?=
 =?utf-8?B?RzdqSmEzVGF6Y1NtYTFXQ1QvQVozaUY1ZGppenRDdnpuZXJBOWZjczZzMzJO?=
 =?utf-8?B?b01hRUt2MS9WeWlLbjBna3V1elhvRzZaU0NWa05NQ1dHdlpjUXZLNWtHVlZz?=
 =?utf-8?B?SFgvdWZ6djlCRHN6YmxwWFQ5ajBlb1lwekxrQnFtNHRsT2FqbXcvRkpHMm01?=
 =?utf-8?B?RU9GMS90VTU2MVNyemt0eUxIT1l0RGxzM1JnTlhIKzJYa0lKM1JpVjZjS0Fr?=
 =?utf-8?B?TUhsTFF2aUhmNjlsbU9TeWVoTVZaSlVLT1pEZ0hjVkQvU3lpMmpvVjlOYzZ5?=
 =?utf-8?B?UHBxTkdmN205cjFleEgwWTJHMWdOL3dOTzNjcDBYVW43ZXBEUEZEZFM5S1hS?=
 =?utf-8?B?cytzTXNzZ3lnUUdVS1EwaXBUZ0x2bkpyQXR0YzhmS3B6bk5PZ0w4N1VBNm16?=
 =?utf-8?B?ZFM2eUl0Qm4zOXMzU1BEeTM2RzhaRmUvY1Y2blZSVXdyQ2dvQ3dyZ2UyZUNZ?=
 =?utf-8?B?V2NFQzNTK0I4RFU4b3BLRTMxL00yaVJVWWt2Y3ZjVUlhTHRCZEhFMTFqZHdp?=
 =?utf-8?B?bStiSWxLUy8rTlRpVk84MVQycG5zNTgyM1Vtb0tXcVhtSDlIcEVHL1dSaEh2?=
 =?utf-8?B?Y3FJSWlMcUhud2FUWUljYTIwU3JTOXRsQkNWWmp1VG5pSW8zZlY2bEdibXRM?=
 =?utf-8?B?dURXRUFOelEzLzh2bERoTEFybFByV2VnZDJRa1owdXJYZzdBcEQ4d29NZE1Y?=
 =?utf-8?B?TTFDSldDcVFCaU1SQXJRYkdnbWVrczEzb00rZTNGU0grall1R0ZweEFGeWZk?=
 =?utf-8?B?NkNqcEEzTUU3TkhkREozSU5uVG9ieGRoOGdqRHlUcVQ4eFYwaWgxU201Tis3?=
 =?utf-8?B?WEtVVXNXTTFqRGVvSURaT2JjNzg3aEs0Nlk1WE94SForS2s5U3JvRU9yUEpW?=
 =?utf-8?B?TExsSGJYTmhKV0tnUG5IVXhNL25zcFJTcTIxUlB0NXdTK0R0ZVBKRXVCWlpU?=
 =?utf-8?B?Z3kvRmgzZWpRVnRzcGVhR3hHdDduQW84VVFyTitydHpadU56WEFaNmQwb3Z5?=
 =?utf-8?B?TnNnVEdNMTg4VDhRYS83SHIrckliV3NwTjhDa1gwVmxuMXZvc3VtRUUreGZG?=
 =?utf-8?Q?+xWENw1fFlIU8V8mmPEf1v1Ti?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecf3d30-0e44-431b-8c07-08dcfd70bdba
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 08:06:24.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r1Hrv1EbuLaB3TBzvHaXqUd+DZwMblBUQFXARAb2vuJERSC5tv0X+Vja9FLYhV6MUiDqokJYvbTcVeFMWVxttA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7491
X-OriginatorOrg: intel.com

On 2024/11/5 15:57, Baolu Lu wrote:
> On 2024/11/5 15:49, Yi Liu wrote:
>> On 2024/11/5 11:58, Baolu Lu wrote:
>>> On 11/4/24 21:25, Yi Liu wrote:
>>>> +/**
>>>> + * iommu_replace_device_pasid - Replace the domain that a pasid is 
>>>> attached to
>>>> + * @domain: the new iommu domain
>>>> + * @dev: the attached device.
>>>> + * @pasid: the pasid of the device.
>>>> + * @handle: the attach handle.
>>>> + *
>>>> + * This API allows the pasid to switch domains. Return 0 on success, 
>>>> or an
>>>> + * error. The pasid will keep the old configuration if replacement 
>>>> failed.
>>>> + * This is supposed to be used by iommufd, and iommufd can guarantee that
>>>> + * both iommu_attach_device_pasid() and iommu_replace_device_pasid() 
>>>> would
>>>> + * pass in a valid @handle.
>>>> + */
>>>> +int iommu_replace_device_pasid(struct iommu_domain *domain,
>>>> +                   struct device *dev, ioasid_t pasid,
>>>> +                   struct iommu_attach_handle *handle)
>>>> +{
>>>> +    /* Caller must be a probed driver on dev */
>>>> +    struct iommu_group *group = dev->iommu_group;
>>>> +    struct iommu_attach_handle *curr;
>>>> +    int ret;
>>>> +
>>>> +    if (!domain->ops->set_dev_pasid)
>>>> +        return -EOPNOTSUPP;
>>>> +
>>>> +    if (!group)
>>>> +        return -ENODEV;
>>>> +
>>>> +    if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
>>>> +        pasid == IOMMU_NO_PASID || !handle)
>>>> +        return -EINVAL;
>>>> +
>>>> +    handle->domain = domain;
>>>> +
>>>> +    mutex_lock(&group->mutex);
>>>> +    /*
>>>> +     * The iommu_attach_handle of the pasid becomes inconsistent with the
>>>> +     * actual handle per the below operation. The concurrent PRI path 
>>>> will
>>>> +     * deliver the PRQs per the new handle, this does not have a 
>>>> functional
>>>> +     * impact. The PRI path would eventually become consistent when the
>>>> +     * replacement is done.
>>>> +     */
>>>> +    curr = (struct iommu_attach_handle *)xa_store(&group->pasid_array,
>>>> +                              pasid, handle,
>>>> +                              GFP_KERNEL);
>>>
>>> The iommu drivers can only flush pending PRs in the hardware queue when
>>> __iommu_set_group_pasid() is called. So, it appears more reasonable to
>>> reorder things like this:
>>>
>>>      __iommu_set_group_pasid();
>>>      switch_attach_handle();
>>>
>>> Or anything I overlooked?
>>
>> not quite get why this handle is related to iommu driver flushing PRs.
>> Before __iommu_set_group_pasid(), the pasid is still attached with the
>> old domain, so is the hw configuration.
> 
> I meant that in the path of __iommu_set_group_pasid(), the iommu drivers
> have the opportunity to flush the PRs pending in the hardware queue. If
> the attach_handle is switched (by calling xa_store()) before
> __iommu_set_group_pasid(), the pending PRs will be routed to iopf
> handler of the new domain, which is not desirable.

I see. You mean the handling of PRQs. I was interpreting you are talking
about PRQ draining.

yet, what you described was discussed before [1]. Forwarding PRQs to the
new domain looks to be ok.

But you reminded me one thing. What I cared about more is the case
replacing an iopf-capable domain to non-capable domain. This means the new
coming PRQs would be responded by iopf_error_response(). Do you see an
issue here?

[1] https://lore.kernel.org/linux-iommu/20240429135512.GC941030@nvidia.com/

-- 
Regards,
Yi Liu

