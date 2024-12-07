Return-Path: <kvm+bounces-33250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7F79E7F93
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 11:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 295A4188457F
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 10:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 058251428F1;
	Sat,  7 Dec 2024 10:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CrwISwhS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41051ECF
	for <kvm@vger.kernel.org>; Sat,  7 Dec 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733568253; cv=fail; b=r1+32oo50O23nwedDqN7lKOauTCt9Wu3X5CyHQjh0XwXV6Uh88F+7RKb04U2PyE6BRSwj0y7rEcchVMDcixjvlTFaImvLaIAGnomFROoJZMUqlSL8f7+0wWd6z7smt8FjWJmlN9XtFzQsoIm3ryRxOzah6U328o9t9ocUyBzP54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733568253; c=relaxed/simple;
	bh=6z8pFdysbh51fFi6MMWw9bKUl53xTBaYMPsQcartud0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xx+0bPrZnB3ZaPFm0neqcqYpDg+WVWRiyHiCpBFGVGFWk29N0LAV7wMP3dw2FO4Jv9rlV7NNuDRrLHchx/zkDLqSM7XXPL5Hikje5JuFKn49b+agYj1dpAlPwHdzAf3k4OzBZgYiz/NvIj7myNGB6//wq7ds4W6BUOMi46O3ncU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CrwISwhS; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733568251; x=1765104251;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6z8pFdysbh51fFi6MMWw9bKUl53xTBaYMPsQcartud0=;
  b=CrwISwhSfMbjYzl5Va67kT8hCLYNVQckCHmaqhFXd45pTOK1Lvy3gUaN
   3MJsREfSssnvNBK4El80FJo7P2UhoQg8obObQJmKdqTVd2R30MSJMwWaf
   hlh1n38hqI9Fe+VLbqDn4j6GEK6s4N5Abixc6fzTjP1QvvOQMzCwKi/gC
   wnZD4mCRz8u2ePlkomT+9K7/M5LuhFL0dAcxEX4YDPnalWDdMbkX25S2z
   p1FSz/9hYNfpCwUIRCxxUhzkAisilMO5kuPgu+qzrjsJn9FWRI12tVttB
   2qhnXGc1yF6SLkZt3BiHWfNeD7JqVhpPvHbf+VBOg40Chb0Sp+GkzVSOX
   Q==;
X-CSE-ConnectionGUID: 3p2hXy5YQJSXF7OsZszDLA==
X-CSE-MsgGUID: ZHEQ4X1EQ5ujs14ex1bHuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11278"; a="59316724"
X-IronPort-AV: E=Sophos;i="6.12,215,1728975600"; 
   d="scan'208";a="59316724"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2024 02:44:10 -0800
X-CSE-ConnectionGUID: aMwHvv3dRcyA/NLYSQiYEA==
X-CSE-MsgGUID: q7GFtk9tSpWxXAB/nzbwlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,215,1728975600"; 
   d="scan'208";a="95427505"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Dec 2024 02:44:10 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 7 Dec 2024 02:44:09 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 7 Dec 2024 02:44:09 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 7 Dec 2024 02:44:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekcdaD6W0BaSrx+Wxkp1bHHyd3JGqqM/xxmzqDeCYLXi4ivRN6eq6Y+DQUXiNBGDUXXyjCRQ8HqUjhdJb57vjIaRHt8VmauHgj8uLwSFTxUHkjUP+Of6qr9IXtco9j2Lvjlq053OGP6qrDdRFoywsoe8DbGsrTU+FebMxL/+f74MuL/BrDUGfRbJGxeEHFNj1Pysr63P9dhUkUOihCP28ZCSyOwC+qt62jtHQQY/AM1N/4IUdG90PN1FtdVkNbr5fBeICFGc4XCkrytnAjWaYUm7JA2yqHZzpfNAY+pQaMGoFN+ycJBhFm3UGxOQ/MRuKoGnw54gHjtAXDIp0PC9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZS5LtVcl4akDxeYMWahcM6tfCwqyiXOKmT+NFoQVfek=;
 b=hNcx7psnEE1Ha3dgTi2kmKaHheomD7D4eDDfazHmwOBFSDSW9PAYOh96kmmUR1i8VG+cCK/73WfjXoEYFPtMO0dg4wFerEuTiW9gmhORlp1SQ8PNljksoy4FmzFRNdGs0CIM5PAg0d4izCx0EToIRpojTw+9hw8jnXAa6Am/O40yhCmIIDhSRIkN2pmzpdGx209r/BoFvny7bd2ZmOdjqswr7g3Jt25yZ8rztXnN9zf95KjFU1WkighGYmVV58GQjUKT9ZS3u3v8bJkJwd7McyoJBRtuuoORnlhPqkNM/aIa5az8wqKIs9u7MHMLhdnAlpEAvxHPKhUX6XJtTMskEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA0PR11MB7909.namprd11.prod.outlook.com (2603:10b6:208:407::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Sat, 7 Dec
 2024 10:44:07 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%5]) with mapi id 15.20.8230.010; Sat, 7 Dec 2024
 10:44:07 +0000
Message-ID: <0f93cdeb-2317-4a8f-be22-d90811cb243b@intel.com>
Date: Sat, 7 Dec 2024 18:49:04 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/12] iommufd: Enforce pasid compatible domain for
 PASID-capable device
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <joro@8bytes.org>, <kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<alex.williamson@redhat.com>, <eric.auger@redhat.com>, <nicolinc@nvidia.com>,
	<kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>
References: <20241104132513.15890-1-yi.l.liu@intel.com>
 <20241104132513.15890-9-yi.l.liu@intel.com>
 <39a68273-fd4b-4586-8b4a-27c2e3c8e106@intel.com>
 <20241206175804.GQ1253388@nvidia.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20241206175804.GQ1253388@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0035.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::13) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA0PR11MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: 27542ced-0db0-4fa3-b3ce-08dd16ac1300
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXdncUZLdk9HWHNiOEJqZ0NBeU1JYVFvTlB5cEtublZFaTQvd2NrdmZFMU9F?=
 =?utf-8?B?c1VUbE5iRy9yK0pSenNvd3hXQ0RJcGphcThPd3ZpVXBENDFCdWpWMTMwL2V3?=
 =?utf-8?B?bG5lTEl3L2I2aS9oRUsxek1SQ2FJSXVERUJCVWkzbkF0WndvK3U4TEh4VDR6?=
 =?utf-8?B?SkxTSFM1WHRzUnVubFNqQ3pmZWtrWXgvVThsdmF5S3plZmVsbCtka3JqRHdm?=
 =?utf-8?B?OVMvQlhwOHZCNU1TVXIvU0RtaGJjdTgrL2tpVFNra0ZhT1BTSDFLQmQvRDJF?=
 =?utf-8?B?SVROdWtTR3d1dERROVFqd3dDMWVTYjhrZzh1VkhLako1YWl1NEliU21RM1Ev?=
 =?utf-8?B?MldHRkNGRmZVR1J3KzUrZ2EweFdjcUJwUzlJcmdIYVp3TjdxZ0FvYnBnVkxD?=
 =?utf-8?B?aWZJVU4vWi9weHhOQkYvcWRzZmovT1U3OFd5U09haGppYWxQcGQyYkpXQUYy?=
 =?utf-8?B?WTNSZHo0U3NJOTVRaVhaRGVjVWZ0aExRY0ZjV3hJcVAwRFAxbGFndzM4bHl5?=
 =?utf-8?B?TG54MUc2SlROWWRJTG4rdFRhRmk3UHNiYTlUbXl5bVN3RXlQWnVMVzczYlRa?=
 =?utf-8?B?NVkxbmdQdkZlMkR2emJZd1c3SWw2dFgrVTgwK2gvUkFSQnRWM1dzOEh6b2ZO?=
 =?utf-8?B?K2ZXeVVxeit3S3V1ZjA5Q0oyWmVrTXNOZWpoYzRGWU5DT1Y1c3VYblpRMzNl?=
 =?utf-8?B?c0NjQkoxN3ZCOTlRT1lYZCtJcHI3TG1uQ3RXUmxJUXZKMUkyNFhsYTJRSVFC?=
 =?utf-8?B?TDljVXhGenJSbHU3V0t6MWlmdkdJM21nTmdTaDdzbUg2d0lwcUVWMXBmOFkz?=
 =?utf-8?B?OStvSlJ2bVhmcUI5MlNzWG9lK1ZQaHlzaW95TFY3bkF3VTRJbVBGUytNcm5n?=
 =?utf-8?B?VVVyZ3VyQVFmZUZ4Y2oyV1pmRzd2TkRhVXppR3pzMkk4UDhoSGp3WkFwTnQr?=
 =?utf-8?B?K2wvY0xkRGl6dFRZRVJhRVN0YnFySFk2eVBlU1c4UGNyVDU3bmFYbE5ocHlK?=
 =?utf-8?B?bWcrNUdJTFVqOGd4RjA0T004dUVLUmlGeXZOWU04WW5XTVZYVEJUVzFzMzh2?=
 =?utf-8?B?OVM5N0l3YUtRc0hvTXY4azVmNWppays4V0U2aUxDVm9NSStKd2o2N2JoS1g2?=
 =?utf-8?B?a3RaR2FIZFRFUUE1TDc1SVlxc09YekVKQ3U2aGJpQyttWFUyM1I3Y0UxMmlO?=
 =?utf-8?B?YnFsYi9ZWVU4UzFpcXk4MFkzVENqMTVXbFdhakg4OXpIZTR0b2piZVZ0T0VW?=
 =?utf-8?B?ZlBSM2JDRmZHeFlGeEdJQlJ3bFFpQ3I1cUR0dENhU1Q0ckVNRFQvV0QxRDhk?=
 =?utf-8?B?SlVPQlBIUXlFSFl6VkFIUXRmSWQ0S0tXN0tvSDFVek1oWkxMQksvTHVMK21W?=
 =?utf-8?B?NC9Mc0RlanFpWG5tVERhTkhLd0s0aVo4Rk10WTl3amswWkFiOUVQMlJpRWoz?=
 =?utf-8?B?SWZvMXI2bjlXekFhTUkyYUNpZzNJWkxoUWZ1V1VtUkd2aUdFQ2t1aDBDM2Rj?=
 =?utf-8?B?UjgvUUtKME5tRmV5enhjaDgwUzV3aGh4aG12VEpjNWVFRm96QjJxOERxWTMv?=
 =?utf-8?B?VEp0ZlZ0cnNaK2tpb2htZElKQTJBcjF4WTZVSFpxdTF5SUJaUmtHNlBoWHYy?=
 =?utf-8?B?Y09pUXo5SVlzRkI2amhSRkQvU3Q2TjI5MVhVYXlPZmg2K2JwN0Y2VWVMNFhS?=
 =?utf-8?B?eWxPUEYwL3pmV0k5WHg0U3NmcFRIVjg5SXhhdHpUUFhlaDJraGp3RG5zbW1V?=
 =?utf-8?B?S05MbEdYOW1xNnV0NUtmcm9iRnVTY2E3YmxYM3YrUDVzb3BkSkRXNEJ2RUVz?=
 =?utf-8?Q?TbZZl2BIb7LJNADiaTtU2KEVTQkjKrYf/ONOc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czc0MnZFdVQ4SmxWeC9wYWp1QTJxb2l2QmxRaXJxbWZVSjJJZzBSVlN2emxG?=
 =?utf-8?B?SVEyU0hGNWRKTmovUVNtVHl1WWpqRHBmaVlhbzhGeU1pcGhkTWxDbGY2WUZt?=
 =?utf-8?B?Z0Y5T2E3ZnQ5VFRYTm9OYmNLS1FQNElmT1J5OXZhdmV4TFJBZCtXUDBaRTk4?=
 =?utf-8?B?aUt3dUc3RndrMVNSWStueCtOYmVNQ2tDZUJrS0RhM0hhQVNPMG5STVZzbGUy?=
 =?utf-8?B?cWZFb2ZMdGUzMFBYZlkvRFZxd0ozYXZ2SW5mSkR6cGFKK0NEajBvKzZ6VzVN?=
 =?utf-8?B?S1dic3VnbXBHQ3R3YUVsY2N4Z1h1NVhPcXQ3UDNKVVVVOGUrSnZpTm03aWRL?=
 =?utf-8?B?VEdaMERCeHZIT2xRVXhvU1lxVDlqbGtPN2NBMXRadTBBZmpTSTIrekdOK1dO?=
 =?utf-8?B?dkZYYXM0TmRoMWpVSTQyNHBQTy80YlFCbGNZR1dLZ3I3UUhRYlVEOWhDSWxa?=
 =?utf-8?B?RUwvcHNxNlVML3cwVEhCeklHM1grS3JXTTFMbXNITFRwclVpVWhPdGV1ZTY0?=
 =?utf-8?B?WEkzbEI0MzRCcy9BMklIaG5wWTVUa2NWTC95c0NhS0l6TGoxTm83aDk5dlEw?=
 =?utf-8?B?N0ZuTS9XdlNoVkZCUEREcDBEVEx2UnZDODltSDI2a1k1WmpaTVJmSTB5YnEw?=
 =?utf-8?B?TjVlZG93dW1qbGVVSGE1ckIwWUVwbHAyWjVja044WHhXbElMSVM3RThTeCtV?=
 =?utf-8?B?YW80a3BPd2VGTVZscTl2VktXRHRoWHFWVVM4USsrY1AwTmthaUFXMnNwSVlU?=
 =?utf-8?B?Y2JodmpEbmQ3czVrRWQzOVIza2ZzRm91L3BlcldzQjVHUjZXQUpidHlHQnBS?=
 =?utf-8?B?NzQ2M0djWG9vaVFpUnBLdzJiRHJsUmYrN1dqV2YreHJMTTF3ZklieXpjRzJl?=
 =?utf-8?B?UTF3aEUzcXNXaFBnVk5mTlNmRXBWLzAxbTZ5VS9LSXhWdG1yU1BaYjNrUUwx?=
 =?utf-8?B?YlVsN3EybXJrUTIzREVHUWFNR0JGT05RTlQwcUd0RkVCaU9uMk9QV2p6Vlho?=
 =?utf-8?B?NFpYaWkxaW8waWt4b25Nd2F2VnAyWnY2bVE4L2dYZE1HWENvY2ZuYWV3T09V?=
 =?utf-8?B?dkhHa0VMdTZHN1RsVnZobFQ4K2dsU2JFZzd2QTVESGJhV2Mva3RGdi9hNkZk?=
 =?utf-8?B?RFU3bHdTRnk5a3g2ZnF3QUgvOXhTUkJHMWN4dTBIR0cvTm4wY04vazdqek5V?=
 =?utf-8?B?MGNJZXc4a3EyU1A4SWtKbmJOVzRpMWkvaEFmK3JncWMzblpySWVCalRFNW0x?=
 =?utf-8?B?M0xaVngvays4L3dPdm8zRlpQclpCTlN5Mmh0SWQwWVViMkUzYWlSb0ZlRUZO?=
 =?utf-8?B?VTIrbFJMYkh5aE41UjhMd3RJYm5oQm0xRS96Z0RnK3lYYkhScHc5RWtUbUQ0?=
 =?utf-8?B?ZGZMMnk1RmJXUnJTa3ZROHhkbi9LelVYcWRrQy80VVJxWHVDOXk1eW9QaHRP?=
 =?utf-8?B?dHcvZHB1NXVkMUJkdU00LzkvVHFmNGhvSldkSVpnQnIwMlFBN05JVjZIYk5y?=
 =?utf-8?B?K0VuZmY1VW9LYWwrR1Yzck85OTkvbHhWeTk4ZVFrRk56L0cvKzV6endmOFBF?=
 =?utf-8?B?M0htL3pUcU1SVFg3czYycDhoa1pzYnh3T3pvWDY5aG16S1d1U0ZCeFNTM2RW?=
 =?utf-8?B?M3p4WGJQcndXUmk0TUJTQ0JQZkhITHRON1JMU0hJZXJVa1hkOVdVTXdvREFH?=
 =?utf-8?B?MTJicEpjS3lPbVQ2WFNaTUVnUXFpNldmYXRMMVpIVTRybnhWZW11ODVuK1R3?=
 =?utf-8?B?MVdBZTRoM2RwNFd0M2tNRHZrdDZWeDZwNTRZc0pDWklGTHl1L2VzditESDI5?=
 =?utf-8?B?UVExY1AybHpTejArNnY1RDR0MTdUVVA0cy9oMHFiMHNqOUl2MU1hOXNGRStN?=
 =?utf-8?B?QklOM3lWdVhzUnltNThHN091Z2lOODhwYk1jSlg5ZlFXMGFqdTE1L0Q5eDNE?=
 =?utf-8?B?aDgyNTJBRFp5aXBxazdYQkNKMUoyN0Y4bGhINm53ZEE4QWVGV3FJeCtPTkRk?=
 =?utf-8?B?SXZCaE1jR0tRY2N1TElZYmE1ZWVZWGs1R0I0S1hEVjJqZC9pZ1FwczkvUFFX?=
 =?utf-8?B?Y3AxanA0aER6QXNJMjZIcDRpUnFPUFZBN25qeVJEejI3S25RdEhyNDc3dEhL?=
 =?utf-8?Q?Kz9HJXPtvNAt9GCiQvXfDg1+Z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27542ced-0db0-4fa3-b3ce-08dd16ac1300
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2024 10:44:06.9069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESUMJZfyp/wdxZfbxr8+W6nlgupzD0uQXbOebvT+nMXOIBPomJNYY6NQLL9ecQZRPG2dzAaeTfC/n49UslL+lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7909
X-OriginatorOrg: intel.com

On 2024/12/7 01:58, Jason Gunthorpe wrote:
> On Fri, Dec 06, 2024 at 03:57:39PM +0800, Yi Liu wrote:
>> Hi Jason, Vasant,
>>
>> When cooking new version, I got three opens on enforcing using
>> pasid-compatible domains to pasid-capable device in iommufd as suggested
>> in [1].
>>
>> - Concept problem when considering nested domain
>>    IIUC. pasid-compatible domain means the domain can be attached to PASID.
>>    e.g. AMD requires using V2 page table hence it can be configed to GCR3.
>>    However, the nested domain uses both V1 and V2 page table, I don't think
>>    it can be attached to PASID on AMD. So nested domain can not be
>>    considered as pasid-compatible.
> 
> Yes.
> 
>>    Based on this, this enforcement only
>>    applies to paging-domains. If so, do we still need to enforce it in
>>    iommufd? Will it simpler to let the AMD iommu driver to deal it?
> 
> I think driver should deal with it, Intel doesn't have that
> limitation. I sent patches to fix that detection for AMD and ARM
> already.

ok.

> 
>> - PASID-capable device v.s. PASID-enabled device
>>    We keep saying PASID-capable, but system may not enable it. Would it
>>    better enforce the pasid-compatible domain for PASID-enabled device?
>>    Seems all iommu vendor will enable PASID if it's supported. But
>>    conceptly, it is be more accurate if only do it when PASID is
>>    enabled.
> 
> If we want to do more here we should put the core code in charge of
> deciding of a device will be PASID enabled and the IOMMU driver only
> indicates if it can be PASID supported.
> 
>>    For PCI devices, we can check if the pasid cap is enabled from device
>>    config space. But for non-PCI PASID support (e.g. some ARM platform), I
>>    don't know if there is any way to check the PASID enabled or not. Or, to
>>    cover both, we need an iommu API to check PASID enabled or not?
> 
> Yes, some iommu API, I suggest a flag in the common iommu_device. We
> already have max_pasids there, it may already be nearly enough.

yeah, the dev->iommu->max_pasids indicates if a device can enable pasid
or not. It already counts in the iommu support. Since all known iommu
drivers will enable it once it is supported, can we say
dev->iommu->max_pasids also means enabled? If so, in the HW_INFO path[1],
we only need check it instead of checking pci config space.

[1] https://lore.kernel.org/kvm/20241108121742.18889-6-yi.l.liu@intel.com/

>> - Nest parent domain should never be pasid-compatible?
> 
> Up to the driver.
> 
>>    I think the AMD iommu uses the V1 page table format for the parent
>>    domain. Hence parent domain should not be allocated with the
>>    IOMMU_HWPT_ALLOC_PASID flag. Otherwise, it does not work. Should this
>>    be enforced in iommufd?
> 
> Enforced in the driver.

ok. BTW. Should we update the below description to be "the rule is only
applied to the domains that will be attached to pasid-capable device"?
Otherwise, a 'poor' userspace might consider any domains allocated for
pasid-capable device must use this flag.

  * @IOMMU_HWPT_ALLOC_PASID: Requests a domain that can be used with PASID. The
  *                          domain can be attached to any PASID on the device.
  *                          Any domain attached to the non-PASID part of the
  *                          device must also be flaged, otherwise attaching a
  *                          PASID will blocked.
  *                          If IOMMU does not support PASID it will return
  *                          error (-EOPNOTSUPP).

> iommufd should enforce that the domain was created with
> IOMMU_HWPT_ALLOC_PASID before passing the HWPT to any pasid
> attach/replace function.

This seems much simpler enforcement than I did in this patch. I even
enforced the domains used in the non-pasid path to be flagged with
_ALLOC_PASID. But just as the beginning of this email, the nested domains
on AMD is not able to be used by pasid, a sane userspace won't do it. So
such a domain won't appear in the pasid path on AMD platform. But it can be
on Intel as we support attaching nested domain to pasid. So we would need
the nested domain be flagged in order to pass this check. Looks like we
cannot do this enforcement in iommufd. Put it in the iommu drivers would be
better. Is it?

Regards,
Yi Liu

