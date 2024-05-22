Return-Path: <kvm+bounces-18002-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7088A8CC9C0
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 01:39:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F9C51C21AA1
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 23:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C943314C59C;
	Wed, 22 May 2024 23:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HIdJSx3S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB5824B1;
	Wed, 22 May 2024 23:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716421132; cv=fail; b=nphpdmCsFC5nHbqJiR+pE43B/Xvurz/gDI5jxhCeiR2mUZZQvmoK43AQw1jC/4XHRRJuvHh0QcHd4Pon0f+Y7v7OtTE7oqPtsg+3EWcWf42Rl89RFEX8yrnw83pQrTyuILLK2dXxZ4ZWSYYGbbYy3TO65OLp9Cqleqi+fJpHgvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716421132; c=relaxed/simple;
	bh=tl+ph6t/iGpdw2SnxaKVOX3Gy/vUqau0Gk9FAc7ra/o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I21hEtEIsilNhvEVd/CuT94Qs4RWQ0600csJmW/Y+ItFAwQUs36QO+nacfOsLl3TPLp3wBCFlXyvC/tZTmwx6lGL4QHweZXQG9HshyhhLsaGmLcvyWhWW4FzvmnXGHiG8QzYtjRqV/Fu37RgkG90pd0s4kqIUvy80inaMCzB4KA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HIdJSx3S; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716421130; x=1747957130;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tl+ph6t/iGpdw2SnxaKVOX3Gy/vUqau0Gk9FAc7ra/o=;
  b=HIdJSx3StrLUYkEe5O9I+6V8GI/beFiaOj0zznETSWaKsQWO0TokNudz
   I2PFSRC0+SU/HFnmjmFlDOQbCCgpAc5OYPg0NA0ECvVr+/Wr9A3aoAgZn
   xJzCrgTWumLClvA9ffmoa7NayvFRtSHtq50H9ODAehe3bESTGn1+QHO3n
   fLPDmsP1WWSa7kjD1B3rTP0m8W3XPLHBrmw+fqeHEbBARxiV+newPT+bp
   htHkiPw/YGTRwnWiKXBQHCY80SxgD0aoXrpb9Ov9tZKUnsYjOs0d0U0r/
   S21yekwoI5KvfkS3R/vmkbhgKSitApyKcxYGrf+yWU4Txbsu+UgGcbaqw
   w==;
X-CSE-ConnectionGUID: k6V9s5bnR2msaE/v6dt3Gg==
X-CSE-MsgGUID: BV7PpivbS0a7no6E+NISaQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="23374573"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="23374573"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 16:38:49 -0700
X-CSE-ConnectionGUID: mAKlvwukT5qSbAi3l1qr3w==
X-CSE-MsgGUID: eRDkrA3uSf228M7JlnSf3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="56700723"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 16:38:49 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:38:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 16:38:48 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 16:38:48 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 16:38:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QOBupKbZeT9DZpIsU+jJWXP3aZnj+xLGM1LA8ixHW/zYHSx8QrKjq4XxkHEGBSIThPD8PEMQECCzhDFjcJrbezmbIhSq4knW2248SLofEknsEFIGqLlFtH0O1dLMkVPHWRpzDHzbKkMWUlfopE0YZ293Iv8R8OaVZHAso867gNbME6CMx10mBmtAqplc9RYnTq7vyD/W/xAG3A7e4Jhg87gu9ADLiJjJuxs1szh/h+/0rCGRXTE7U+lJOwACltP0LT+SzRgvat45eUGiJ/+RXdiYgIMrgy2U3ElLb2PEwwD6B8JQCx2kUvosUAM5snayeVkc81p/FyebdctIwVo3oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kq3ErOJFwPFH5X3aRZGGH5a07iOuKgn9dgV6cgev70=;
 b=Hrj7Bxq3tCEUByVrqfg0xSoyq3VCIHC59BUB0nDdy0AuR4HBDopLKylOJoUisGvcCegRGS3Ta8EocHmtJgzvcJm/kkPqoYs/EPfTtUDDdKPVspN+gKc0eiDmq6uInwOoumHWyvny0ccS3ISt7MmC9y+32T9UqHEAH82qCZ8nEEl5RN6ZbtGVVscVVoPnxtZGoKTr4rK+VXsjxibhrHCopEQ3yLZWhtBRqSSpLd+S6LsbCxcEqi0dJCQtZ4NJ644Kk2tnNz50PCxM+lNvPsrbtQTYseQh4HWsUPt8g9FUmIg5RaYJLUh0krHieaCzTS/2GdxNy6ZqGsunVTmp9Lwf5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB2535.namprd11.prod.outlook.com (2603:10b6:a02:be::32)
 by BL1PR11MB6027.namprd11.prod.outlook.com (2603:10b6:208:392::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 23:38:42 +0000
Received: from BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7]) by BYAPR11MB2535.namprd11.prod.outlook.com
 ([fe80::391:2d89:2ce4:a1c7%5]) with mapi id 15.20.7587.035; Wed, 22 May 2024
 23:38:42 +0000
Message-ID: <2b6e91c2-a799-402f-9354-759fb6a5a271@intel.com>
Date: Wed, 22 May 2024 16:38:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] vfio/pci: Support 8-byte PCI loads and stores
To: Gerd Bayer <gbayer@linux.ibm.com>, Alex Williamson
	<alex.williamson@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Niklas Schnelle
	<schnelle@linux.ibm.com>
CC: <kvm@vger.kernel.org>, <linux-s390@vger.kernel.org>, Ankit Agrawal
	<ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>, Halil Pasic
	<pasic@linux.ibm.com>, Julian Ruess <julianr@linux.ibm.com>, Ben Segal
	<bpsegal@us.ibm.com>
References: <20240522150651.1999584-1-gbayer@linux.ibm.com>
 <20240522150651.1999584-3-gbayer@linux.ibm.com>
Content-Language: en-US
From: Ramesh Thomas <ramesh.thomas@intel.com>
In-Reply-To: <20240522150651.1999584-3-gbayer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0001.namprd04.prod.outlook.com
 (2603:10b6:a03:217::6) To BYAPR11MB2535.namprd11.prod.outlook.com
 (2603:10b6:a02:be::32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2535:EE_|BL1PR11MB6027:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e54f063-e008-4a64-61d7-08dc7ab85077
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|7416005|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dEdWQm9zUE5lUHJPdmVvQi9Sb0w1eEJ6eGdmbVo4b05zQVVqSktZR1NldnR1?=
 =?utf-8?B?dVFQV2xrYXlyV2YxamRuOFhCcDFYWTIrUTdpcitqT2pZZ0pJb1BNMmdLTEJP?=
 =?utf-8?B?dGN3bEVUZzlpdHN2bTZPR29iY0xwK1FjRThJNkViZzFobXBHdm9hazRzUndP?=
 =?utf-8?B?NzZwT04yeGgyT2lWVWhDWlZFQkI0bDlZNENGRnplSHNyVldCM0FUN3VjK1c0?=
 =?utf-8?B?WEZUWHNQZVVmbFRrdERXaVJuYWM1cU5OcHZzK3JZUktQa2tURERaWXBJZzVv?=
 =?utf-8?B?SWlmY1VmL2dUVzBicEVIdTdkUC9DbG9NYitieUxzVFRrZHlWeHg3Y05weEtP?=
 =?utf-8?B?MUxMZlh6THRFNWNBQUNVMkhXMDZzWHZ5bDMxQk42dEtaRkJDQmdBUCs4OXdl?=
 =?utf-8?B?ejl3SUdyemFiTTVBVGVjc3hjWTFrNi95aUFTbUF3aWUxVDFmWUdLV013NnAx?=
 =?utf-8?B?cmZUd2dqSURIa0k1R3g4Q3JZbUNZSWo1M0NtTzltUmFkdmpZR2pMOEV4V0Vj?=
 =?utf-8?B?b3BlWlVGNGcrMmFMb0kvRkorSTVQMlMwNnZuK1RidUg1RnV1WEw3NE0zYWFF?=
 =?utf-8?B?ckhDWkVOQ1VDbnpLbmwvVEtiWVFjTDdGUUJ5dDBjU1VUbzFaRlJldC8wMGxj?=
 =?utf-8?B?V3RsNUFGS3VJeWFlbWRNeHNiZm9vT2FmYzJ3cEJLZlBGOGNseU9iRjNTTDdB?=
 =?utf-8?B?bkwrR1Bxa1NtemlpUUgxUTVaZGNTWmU4SFEzRWU0ck1LeXhSZ09kU0d4ZlR6?=
 =?utf-8?B?R3hZNjJiV1d1b1pidThtYnN4T3RIWmdyam8wTkw1SnMyT0RTc00ydUdZMlpE?=
 =?utf-8?B?WVdCVGFBMEFhZ0p6c1ZTZkJ5dTd3Rm1YcTBldERoNVhvYUVUVVA5c2wwb0dk?=
 =?utf-8?B?cHdJQ2JrbzNhYUltMExFTFNjVEt5TitrQ0dvSEdDcmU4dnE5Z1RkdHUvYjEx?=
 =?utf-8?B?aVQ4cUFRZzYrbkdDQnY5cXNCL05KbEIwNVBHdzA2cVZVRE1YOXZBT05jYnFt?=
 =?utf-8?B?T1M1V2Y1YkhvWjFLWUMxZmFPakV0RTJGYWxaWkgyV09BR3dPbHRHZ0xyZERj?=
 =?utf-8?B?Q1NpbjFkaWliREpSQmE0N1N1Wm1XaEVDZFBLOFJJbmdManhDbEdxb3dYb1Y4?=
 =?utf-8?B?Z0Y5ZlZPaVdCYTFHRjFVaDVGR21UNmxvMnQvUjk5dmxQVTBmYytQWUwyZHhv?=
 =?utf-8?B?aTNVV0xCQTcxRnBOejQrYW5RMWFZVDdBMXBVQ2pZcHVmTGRsckIxT3FOK3cw?=
 =?utf-8?B?ZG5vYWdqRXQzOWtTdmRBc3RKYjZaV3BaK2tQUzhKZUxSZzEvNWpIenhRWGli?=
 =?utf-8?B?WEpHZ0MzNjFrcFV1Mkg4eUlyQ1NhL0FzYlBhZzJBUGY5eHJKbkE5NElMQytP?=
 =?utf-8?B?V3ZqV0xwbUthWGlZUWs2VGVUTzlnT3F1NXJvb2hPNnVhRzFpTFl3M1ZyMmpS?=
 =?utf-8?B?RllTbGhOMExBaGUzSGx5TzNPNkY3bnBxL1IzMmNySjBiRDd2bVhOOGRtWmdU?=
 =?utf-8?B?YmNITnBjU2JXSkI3YTBuamlZMHJVUXl3dGEwSXJ2M3k2bjhueEJDcXRid0hl?=
 =?utf-8?B?MFpVS2RPWXp1ZXQyR2pkcWZ5U2VQQkN2REozQ1dTZ0J1Vk1hUjVaSC94bGpa?=
 =?utf-8?B?aXRGZG1iSERVKysvd3lmMCsxRERCRlJqUXRIMmZIRVJsdmJoSlNFeW8yOThP?=
 =?utf-8?B?bEdZb1cxWnhrQzE2U28vTXJxdjVnOGVTNDRxbEI4K1FSaUF2K0JNNEpRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2535.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzNKcmlXRTM0ZXRTYkg3ZVBzQWw0Sm40YXFEamU5SkxvZVI3MTRvZ2dPdytH?=
 =?utf-8?B?ZVBBQjJIRWJ5WDhZNDdycmtsNThtOGZqQXBDN1RKeThwOXl3aWtmSlkyZWJi?=
 =?utf-8?B?cmpTSWpLQk5pRUlSZ0xtMVFrYitBOGdBVTd3VHVydmNMOWpkTjJxeVU1ZmJV?=
 =?utf-8?B?VXh4RlFiM2Z4ZTNzNnVXMjV2UW1OcTRxUnEvWnhTUldpS0w0b1ZScTVVK3Zj?=
 =?utf-8?B?ZVBuV3VlRk12dmEwTTZDTW8raWNnQ1phUUhzdUc0VjFLbkhkSHJqbGd0OVY3?=
 =?utf-8?B?L002VE1MM29QWEdJNThGU1pIYzRYMkZabG5RUURuQnVEV2d1RkpMZ2phN2U5?=
 =?utf-8?B?ZjVWRVg4REdsUkgxdkRKVDlWUUVXMXBZcDVocDQyUUdzTUM3RTlPRGVham9z?=
 =?utf-8?B?R1E2SUhNZHE2ZG80YkJmTlZ1ZGV2RmVPdmpYNkV1THlNbEgyenhyVXd4MjZK?=
 =?utf-8?B?WWhDOC9kcExROXB0cDRwVndHcS9YWnpIeVI3ckR6YUJLK3VVUnBtWlZOd1pW?=
 =?utf-8?B?VHRmY2RxODZBajdteEhIaFEwYkJ4TWNidHRLNzFkaytQSzJpZDVyVVhucllU?=
 =?utf-8?B?ek5oS2gyYnJKU1IxYmozVmhIZys5QkdyR3dvcmd2U0Q1TnluMHdnNWJkSGx4?=
 =?utf-8?B?ME5ONlplTjgvVFlQSWNKSnU5MWxMNzAxbnhUdnYrb2gwUUc1QUE4VmtWbUpr?=
 =?utf-8?B?VWpsYmRGd1RTaGkwRmJRcDJVRVdJdDJWZjlkMXcwanc5OWcxdW44Z2xwZGpL?=
 =?utf-8?B?S2ZVOVplR0tDVDYxTTFIZVlRUDVqZ1ZCajRHSW5ncVR5Q056L1lOM0tHVUhK?=
 =?utf-8?B?SUxBRjRzK3kyY0kveFUvR2xEWTJacWswdll5eWo1aW1rSy9BREVsQkVYVm4v?=
 =?utf-8?B?Z3hnS25BWVh1cTRMeHRta1lkRGh0all4QXJSbjI5OWpjay9Bc2VMZ1NNUU5i?=
 =?utf-8?B?UElpSG9ybzBnbmZ2N0VFa1REcGhkRnh2MnlJeWJKWGI4bkYvODRjNnhGZG9L?=
 =?utf-8?B?cUttWTQ0T2JaeWFvKzhOd0dhVituSjhTS0hDMEV2YUl3bStoK01GSUYvMWtp?=
 =?utf-8?B?TjBBRW5iRkVJMEoxRkxxeVFKbXNRMi9YL1J6anV2bHdQcWlwWHNTMFhEUDRS?=
 =?utf-8?B?Nksyd1FkMFJPazVYUytzMUlUQmk3TTBnZUpKTVhTclhoRkxacWZpSGxYbkdF?=
 =?utf-8?B?L1Q2eU5EdTJaY0ZtQm1ETHhZT2JGeHRXZHJIbVRQUE11TE8zMzdsNEV4U1B0?=
 =?utf-8?B?OU1JNG1kbUlpNUpXenNOdFVUU2RGOTRHQjkrVjQ4Nmx6TXlRTXZHSkcxdkpt?=
 =?utf-8?B?TFAwdVZuNGpDS21wMTNNWXV3SVJTdEVJTkFYSDN2WUFMNlg1RDNBU3BpaEVr?=
 =?utf-8?B?cnl4YkxCcGpWdWM3bGN6YXdmRVIxa204OWxoQTBzU2JmeUlGQXN2TS9lSVpP?=
 =?utf-8?B?UHRsd2EwK0FYcGRxMW13UVNrd2FjVXZTbExjMlIvSFVmbEJhUlY4QnZwRWFT?=
 =?utf-8?B?WVBVRXRJWUQvYmR4c3FXcHRZY3EyWFpoVjUvR0luaTFYM3FwK3p1ak5aK3B2?=
 =?utf-8?B?dTYxaHBZQWJnQjN2THAzNjYrSUFoeXdzTDhBRE81YUg0V01XaVVvbG5UQVRz?=
 =?utf-8?B?ZFpOS3hnT09VWmV1eEo3Ykc1NTREUjdFSmtucSt0N2x3dXMyMWZZazN1SEZq?=
 =?utf-8?B?YlhCcC8wSytLbXlWem1VT08wUEI5VVB6dFRkNG5velFqK2tJeml3TlNyWDhm?=
 =?utf-8?B?S0lOMXIxK29UWnRNQXZZTFZJbmRKTlFYM0xCSnBlS3QvSmc0bFVtWHNpWmxW?=
 =?utf-8?B?bVB4QmNRVXhpYlcyNHFNRm5KTElhZlE3Qk16c1VQbW0vYU9pWVlDWmNhMGNE?=
 =?utf-8?B?VE5ITDZZdWRyemR5OXc4MmpXWnplbkNETnAyQ3dicnBBVzhzNVdaMzM2WjlR?=
 =?utf-8?B?YVZDWGR5cUZmcU0rdmVaQm9weTlreGhZWlExQmlqcGVlWVZUbSsxTGNhbXNx?=
 =?utf-8?B?aU9rUXd6RlJUeHIxbUp4a1NQanRtK2t4b3Y2bXYxWlRLdTFIRVRSemdPT2t5?=
 =?utf-8?B?QjNWS2s4M1ZpL29INDY1K0RJWWp5SDB5UTJIRWRLNkRuSVhJZzVPeXdhNXZC?=
 =?utf-8?Q?yE0qj9u6EQe75Y67MRp8NFEsR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e54f063-e008-4a64-61d7-08dc7ab85077
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2535.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2024 23:38:42.3316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 55He/crPTwXD+gKxDngDDpn+sZ2gc93IcvhV/ODc+JGZuHSA9rbwMHhfw1u51D3+ouIptS59VT5oFvJaM2stRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6027
X-OriginatorOrg: intel.com

The removal of the check for iowrite64 and ioread64 causes build error 
because those macros don't get defined anywhere if CONFIG_GENERIC_IOMAP 
is not defined. However, I do think the removal of the checks is correct.

It is better to include linux/io-64-nonatomic-lo-hi.h which define those 
macros mapping to generic implementations in lib/iomap.c. If the 
architecture does not implement 64 bit rw functions (readq/writeq), then 
it does 32 bit back to back. I have sent a patch with the change that 
includes the above header file. Please review and include in this patch 
series if ok.

Thanks,
Ramesh

On 5/22/2024 8:06 AM, Gerd Bayer wrote:
> From: Ben Segal <bpsegal@us.ibm.com>
> 
> Many PCI adapters can benefit or even require full 64bit read
> and write access to their registers. In order to enable work on
> user-space drivers for these devices add two new variations
> vfio_pci_core_io{read|write}64 of the existing access methods
> when the architecture supports 64-bit ioreads and iowrites.
> 
> Signed-off-by: Ben Segal <bpsegal@us.ibm.com>
> Co-developed-by: Gerd Bayer <gbayer@linux.ibm.com>
> Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
> ---
>   drivers/vfio/pci/vfio_pci_rdwr.c | 18 +++++++++++++++++-
>   include/linux/vfio_pci_core.h    |  5 ++++-
>   2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
> index d07bfb0ab892..07351ea76604 100644
> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
> @@ -61,7 +61,7 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_iowrite##size);
>   VFIO_IOWRITE(8)
>   VFIO_IOWRITE(16)
>   VFIO_IOWRITE(32)
> -#ifdef iowrite64
> +#ifdef CONFIG_64BIT
>   VFIO_IOWRITE(64)
>   #endif
>   
> @@ -89,6 +89,9 @@ EXPORT_SYMBOL_GPL(vfio_pci_core_ioread##size);
>   VFIO_IOREAD(8)
>   VFIO_IOREAD(16)
>   VFIO_IOREAD(32)
> +#ifdef CONFIG_64BIT
> +VFIO_IOREAD(64)
> +#endif
>   
>   #define VFIO_IORDWR(size)						\
>   static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
> @@ -124,6 +127,10 @@ static int vfio_pci_iordwr##size(struct vfio_pci_core_device *vdev,\
>   VFIO_IORDWR(8)
>   VFIO_IORDWR(16)
>   VFIO_IORDWR(32)
> +#if CONFIG_64BIT
> +VFIO_IORDWR(64)
> +#endif
> +
>   /*
>    * Read or write from an __iomem region (MMIO or I/O port) with an excluded
>    * range which is inaccessible.  The excluded range drops writes and fills
> @@ -148,6 +155,15 @@ ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
>   		else
>   			fillable = 0;
>   
> +#if CONFIG_64BIT
> +		if (fillable >= 8 && !(off % 8)) {
> +			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
> +						io, buf, off, &filled);
> +			if (ret)
> +				return ret;
> +
> +		} else
> +#endif
>   		if (fillable >= 4 && !(off % 4)) {
>   			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
>   						io, buf, off, &filled);
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index a2c8b8bba711..5f9b02d4a3e9 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -146,7 +146,7 @@ int vfio_pci_core_iowrite##size(struct vfio_pci_core_device *vdev,	\
>   VFIO_IOWRITE_DECLATION(8)
>   VFIO_IOWRITE_DECLATION(16)
>   VFIO_IOWRITE_DECLATION(32)
> -#ifdef iowrite64
> +#ifdef CONFIG_64BIT
>   VFIO_IOWRITE_DECLATION(64)
>   #endif
>   
> @@ -157,5 +157,8 @@ int vfio_pci_core_ioread##size(struct vfio_pci_core_device *vdev,	\
>   VFIO_IOREAD_DECLATION(8)
>   VFIO_IOREAD_DECLATION(16)
>   VFIO_IOREAD_DECLATION(32)
> +#ifdef CONFIG_64BIT
> +VFIO_IOREAD_DECLATION(64)
> +#endif
>   
>   #endif /* VFIO_PCI_CORE_H */


