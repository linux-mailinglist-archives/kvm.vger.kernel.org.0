Return-Path: <kvm+bounces-23293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2452B94868B
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 02:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2E47284C67
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 00:10:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A238710F2;
	Tue,  6 Aug 2024 00:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dlbFBL/1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293FFA32;
	Tue,  6 Aug 2024 00:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722903001; cv=fail; b=luwZn5XLnT8C4K1X8Tq3DelbpKZfz4vCmpwf/efRepmW/rc3BPJjE5bJ7GxoAtMw9hPqdEdkDJo8YaNchDtKMCfPBvZlS876nAk9UPna4DXmgqp0RDrBVKjbjBhL/d6YTkL/7GWExI8fxh9BuyaYZtrzWopwiJlDBu0C+L//n08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722903001; c=relaxed/simple;
	bh=sl3yWaqs5o73nmZ9OkIGHYguQcjP2oCyfqoGN4Hb5+U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HoR3pHL4JdbBAVqQiNqwpsODhtu1ZHkM3Uz3OurvtaKxeILCM2gRwTDTvsmfD3SH/WBPmHRg0OhstoltxdDJ2GieLDUvbFkMt1pUAwChjqPBaN859kwx0iHKtbLjfT2yWXfXC4jMiwrcRN25ABWulGBZCafoaRkdk7BN9rY4Uak=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dlbFBL/1; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722903000; x=1754439000;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sl3yWaqs5o73nmZ9OkIGHYguQcjP2oCyfqoGN4Hb5+U=;
  b=dlbFBL/1B1mCY5dp70vFkC87XVUFBkb0pMJghovs7B5I1aeklowJ+32N
   XK0P/jkGid6N7OFyBvstQuiBtgk3JsD75t0Gq1BgJIcCjusSPylKq4yDF
   7si9yA8Eh5wGQYL0XTHhB5kR7pPBYkiYqohnrP7O6HsavLAcgXO/31aZw
   Rc9COZVtzV71iNxvtSt0MkwIJObxTwh88JyaJr8kbu9QxDcm9zYASZgav
   42ES6FZXWMG3wrlW3ydRamrhTNQ/PPOpFu8MrPdSlUeCAXBtdK4Af47J0
   H/EVlvdYoqK3RAK6OtBD+Z0+qW8qoJpoITfpGWHiaBsuBL/ieA2Wrz8Ad
   A==;
X-CSE-ConnectionGUID: PrqtNYSbSbCKTNufgQJhoQ==
X-CSE-MsgGUID: Jk/bV0jTR6WXeJo5HphIFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="21073916"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="21073916"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 17:09:59 -0700
X-CSE-ConnectionGUID: qNQOkYabQW6DLIcb2SAm9Q==
X-CSE-MsgGUID: sLGQECtUSTeMyvvdxmi8AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="56245351"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 17:10:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 17:09:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 17:09:58 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 17:09:58 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 17:09:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CMURatsFyOx8AsMQySlT23PgBtdvshpd/KRCrYkb76J7P5UpfA96IV8pArA8yINDRZ2LCVs6ltYmUIwB8YJy0v3K4u9mcXXkVp0oqLYnKpc9+eaPazwfeieuiX6U99SfUIFUmpJLC0YxdhgqYmx9BIdCt4hYQbr584QsJApjANF5gIkxas+6R37BpOyp+GcFb7Lf67bP8znoKdcD4Blp1lXkgjSpTsAU9mP6M3pxG+Opg4QN/FLxsSius23MEAUnlH4uKLOZXhx0GkzLIMhPxsjSeBZRwSQHAIJvl/lLJK126P0RrTOMhaNy2vWvSftF6ZUmIHxh1ds9rbfMcLduIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFemsVxZcTLUv/+btFSQaYHBtE1i57CIigtEHCsudCA=;
 b=t7mbxVE9trH+b6WTmV+twmB8AL8XqVJqNku27hfijbx/qw3ZBdy2oU8Zf9aZERSQ8Ywdo8R8qH34SUfP6yyDWagzcudIIjIl/ZBhC3sUWbHXz2W8pyoGiNc1abvFaNFuD/xPBlhrEypoSH444XG8J2yFcOXsPaSiO/aWUfdJz0YZ6IN8FICnN4NumeiTwnErDQirFMabJi2bZXlrCz177LS9WjOYuxjzN+ikJVGJzzNEcbbC6xNqkG6YSuh3uM2R++umbCXNLgRu7so19WEe7kXfzpk6gK7dPRQr/k9eM/fIejgZg4sVWxXQEyxIy2n+F775fXZ5lnw8cmykkGfi6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 6 Aug
 2024 00:09:56 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 00:09:56 +0000
Message-ID: <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
Date: Tue, 6 Aug 2024 12:09:45 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0352.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::27) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH7PR11MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 746a42d2-9999-4a37-d0df-08dcb5ac1a58
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YkwvUHpqQjZNS2VRUkxxcGtMbjVpYVd2K1Z4U0ROYS9HNVF4b3d5ZTN3QnU5?=
 =?utf-8?B?dVFJelF4bzJHYi9tUzMyNjZPdEFoelZEdHU0K0pScWhjRjN1bDNlakNPQ1ph?=
 =?utf-8?B?eEtacnd4UW5xOFV1Nnd0Sy9DRnJpUWI0NkRLV29palgzYUlFeHF6aTZoSWph?=
 =?utf-8?B?SDNvMDIvMWtFOFFrRjkzbHdpWlhOT0kwbTFFRlUwenhMVFB6c3lrWVU1eGpC?=
 =?utf-8?B?bG5oUFErd1RzYUZhQzNFdGVibElHQmNCUTRMZFIvSkwzbWpTWlZicS9WQnlP?=
 =?utf-8?B?NUhycmVUTWVZMTdTMnRCc0RNOEowVUkrb3ZiMGR1eTFZS1VGU0c4QTBTbmJ4?=
 =?utf-8?B?K2plaEhxV3duc2ZBTEtxSGJYNGhtaUlPZ2d5Q29SUnNHVHhQRHh2UGJKb0pK?=
 =?utf-8?B?cnZ5YXNhUWo0eWh0RFhaZkZSbTI2NFo5MUk0ZVJ0c252Z21tKzlkVC9oMXJW?=
 =?utf-8?B?VmI3RnFEd213YWlTWXZ1YmlyM2c2SjZQR2ozcHNZelpiWUdvblErWVJUNGpH?=
 =?utf-8?B?dVo3Wlo1dkVGWkVsUGN6L25WWlo4NUpOUnZVamJOcFRtQ2wrYkV1d3FXS2la?=
 =?utf-8?B?Sm1wTkRodzE2dzZ5THY5Uyt1NmE3eEkzdkxSc2tTL3dleFVOVEdpOXVQWGF6?=
 =?utf-8?B?blIzaFQ0MXJ3NDdJK0FVcjZWalJmM1V1WGxuTEpRRlF2c3RUSTdiS0NWRWNq?=
 =?utf-8?B?ems4dWF3NkVzMk5KZW9HWTRmc096YmZ0Njg5YnUvd1FBMDdXZjJHSlFWWjlO?=
 =?utf-8?B?UCt3L2NVSldDZ3V2UEpmWGI3ZEMzaWliT2E3QmExaEFVTDlCRFlRQlBoYjJq?=
 =?utf-8?B?Z2VkS282NjFVNThQMks3TjgrNjAvbDdpNkllYXV1N0lZYXJwVHpHOExTbHM5?=
 =?utf-8?B?MU1INGs0bGdNc08vL1BHVlFUTFB2aTNDWStoZVd0WnQ3ZkthcXMrS3Z0S3dZ?=
 =?utf-8?B?M1RDSHVMbTZ5NCswQ0lFUGFoZXcvQlhNaDFiNG52WUJKY0J4UU9XUjVGcXBi?=
 =?utf-8?B?MFFmdG1PMDY4MWFiRTVBa0luV1Z4SVEvTzVHR3BWQnZSTXZiZFFLYnBndVNp?=
 =?utf-8?B?YndrMHZhUHNkTzRmcTdLRXZ3ZDNoLzljbVJ1UG1YZjNFWnM5bUVPZGpPdHRL?=
 =?utf-8?B?UkJ2QkVqSnJnYlpSbnZLTC9JMUExTnZVbDBwR2lYRnNnR2x5a2hmclNPMWRQ?=
 =?utf-8?B?VHBsRWVUN3dScFViTW9MYXpkbStvQVhxK3N6UmdNdnhmQ0dDUXlsa3NnVjRt?=
 =?utf-8?B?bmZhU1FJWS9wam5KK2RzSjZ1STQ5OEd4TEgyYlJRcStpcFJUbG9xaWFyY0dr?=
 =?utf-8?B?M0VXZWMzeDNBRkV3NjBUbG51M1IvNkZRbGhuWWdVSkZucnVEYnN4cWtFZFNR?=
 =?utf-8?B?bXNFOWVUTWRaQ25BZHR2MTlLZDFJTnlEZDBJeUYzbmM1RnpJWXFXcXNVVEpH?=
 =?utf-8?B?YlVHMDNjdHpzTnhGWlE5WXJjRXRTd0dtWnA0SXNuM29IREFkTGlja21WNWdy?=
 =?utf-8?B?QzVWUkxVWkJtUkNEYlJYZ09hMWUxWlZFSHlkazV2d29BaUtySzJjdDl5UnBq?=
 =?utf-8?B?bS9TRHNJT1BHN3k2UFlvSStIUmJXZTBLdFIyWnZPOEpWQnk4M2VZaEVuNlR4?=
 =?utf-8?B?WG14RXBhbkRRYXF5c1lnUnJ5dXJmSHU0bm1jMDlRUGROSzlpYmtmTktLQ24w?=
 =?utf-8?B?QUY0WnFGSWRYMFY4RW1vcUZicUtkRDdEMk01WXpoek9CeEpVdm9XN3gzSjA2?=
 =?utf-8?B?NjNxU0xvWXFLVnRRaElqK3VOeDdOS1hmN0xzdXM0bmZsRVpkR2FkODZMek1E?=
 =?utf-8?B?SHU5WUIrL0RLM09XN013QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDZuTkRXa3h0clo0RFJuWXI1RUR5dHVrZHNUUzYzNVhzWDdJY1JMVnRoWmFk?=
 =?utf-8?B?RldHbXlYRVVSRno4cjlKUXd2VEc1VzhSbjByRWdURmZRV3JDb3NjajhvTFhs?=
 =?utf-8?B?bHNuT0h1NjRwTkxBblA3ZVNvTVQxS3lRU0g1RVhnSFBBQWxoTlNmUjNjOGtq?=
 =?utf-8?B?eFRVRXdBQlNuR2dQM3hLbWFJMGE0dFZHSEt4S2pnRVBka0lQZ0J5WkZsS1Zw?=
 =?utf-8?B?TkN2a3VMV1RFQkE1Z2hIZi8ybUZSaUVVNUcwSm1GTi9FU2Yrc1VKWVhnd0xt?=
 =?utf-8?B?Y28rcXZBWUVzT0dnY3BZQjFkcStZaUVxazlJbTNOK21YSXlpMGFBTjRiSThW?=
 =?utf-8?B?WW5yMjF3bi9idWhQeVpTN1pUZXJqazlITTZxVWdBNXpvc1YxbTlYWkY4b2d4?=
 =?utf-8?B?QURvVDdkZ0RqN3hUWUZvcXhCMXVhOGVlczI2Tmd6d01vT0tuTWNQdDJSRjV4?=
 =?utf-8?B?S1pxdlBOenhZNGxBc1dnNWxYb3FTRk5nZndqRmZrVmhUSGxCNVg1eGl6cjRX?=
 =?utf-8?B?TUxmV3FONDM1eUlDSnV5Q0VUdFRxUUgrTmttN1N4blcwMVRreHhmZXk0TWpO?=
 =?utf-8?B?U09WQ3FGZ0lXaTZzZ2pSNE9oMm5mTFhVa2M5Q1ExV1dXK1gweCsvcFJOYnpE?=
 =?utf-8?B?VWNIMkxRYjRkTmRkYTRpbWZQalhCUkRDb1Vnb3FwaXhsejFpQU56NlhOVnhk?=
 =?utf-8?B?YmcrcWE2RVQyeXVEU3J1WmIwUW5DeWZlUU1Db1hoZ2tFR09BeWVWSEZYbnlx?=
 =?utf-8?B?Q1k3L0I0SEdONTJyaFR4dk5IZFBrNmlHZ2Q3OVIvVWJtMjJYU2JmeVhybkdz?=
 =?utf-8?B?Tk85RHBHNW1wRkpJVW1vem5IZjRROEo5RTluSFdHeW1PaGdZWU8vTkhUZ01V?=
 =?utf-8?B?K1NBREd5MVZSV1YvSlFJN3pXb3k1VkRMbUNieHpjN2lndllmQUllMjdLRThI?=
 =?utf-8?B?ek55UmlSd0xQQThrYXdObkR2Z0VLMnphT2VnTU9sbVYwWTNhOXQzWTc5YjhN?=
 =?utf-8?B?QmFsWG9aVm1MbUtWYmlyRS84QmhQdDE5enVxbk5ybE54eUV4ZGNSb2tOSy9M?=
 =?utf-8?B?RkNkdUhObktzUG9MTk92NVhZYlJOYzM1dDlyN2dkRzZEMDJxbjMzWDgyM2hu?=
 =?utf-8?B?SU5RVUZKcjgycHJKQk9Ma3BOSFpoMXExUE9XM2o0Z25ORXNEUG5OSG95Slo2?=
 =?utf-8?B?YmZ2b3lHeVJVWWtKVlRnTjcxY0wySGRKZHljcWNIN1k4RXROck1RWkNTRFZV?=
 =?utf-8?B?L1dnaUprNWJDc3p5OTVFVGQvV2lNaHYydDN2UXRIRC9nYjUrZGYwTE9yUjUv?=
 =?utf-8?B?WjdpN3FhcS9FcDNCVnBYLy9HdThzaXdCU1RZSlpWSHhMZ3UrTWQ0dTlRNmEr?=
 =?utf-8?B?SC9BNTIxYVhnV09hc01LZkEzUFlUU1FxdXdia2ZmUVdIaWV0WkZOS3FNZTYy?=
 =?utf-8?B?VTZSQWt2ang4N2p0VnI0R2V3UjJzdStwcU16RlJLUjRDcXRPTEdCNkd3Sks0?=
 =?utf-8?B?cml4elJPTkNjcnNJcGJxRnFrRTdQanNJRTNvSWpkdUxITFBrTHF1Y0ZoQlFD?=
 =?utf-8?B?R0gvN0c3ZkxkMjE5M0R0Y1A2VFIyZm43ellCWmxGQkpSR2NPTko5elcrRDVo?=
 =?utf-8?B?RC8vK0V3ay9HSGs3L2grcDNsR2tqdEd2cHNaelREQ0NOYTFDc1MyTzA4Q0Jn?=
 =?utf-8?B?MlRWeUFMODJUVUJSRWxweUswWWN3RUtHLytQdW12K21jMGNsRjdjMHFxSEEv?=
 =?utf-8?B?a1NadkEvZGFaZ000alpvWVhudER5a1NXVHA3bW0za3FuMlhaeHoxeWx0UXB1?=
 =?utf-8?B?RXJRUFI3TkxnMVpPTXVob2lSRjVsUG5sWTF1QndTY0Zhck01M2JKejNoNjd5?=
 =?utf-8?B?Ly9JeGI3K1NzYUsrQVIrNTN3YUorSkRxMlA0NXBtaWRubEFsalhGRi9tVlpC?=
 =?utf-8?B?SWQxMWZvMzNYb2IzN1JTb1hxM0RyWHNrd0tUYjVCMVN3d2d6Q3ZwSW12VG15?=
 =?utf-8?B?aFljR2p5aG1IS0xaSEt2WUJIZnB6UzdzT3BRRjd1TnM1MFdpZEFHTWRRdTJ6?=
 =?utf-8?B?dXh5bDRYeE53c0FyVFVOZWVIaFRlWkIwK2ZKUDd0SmpmQ3diWkovVGVGVGla?=
 =?utf-8?Q?AfFQVvZHnhAjVJOzutskoeN89?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 746a42d2-9999-4a37-d0df-08dcb5ac1a58
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 00:09:56.2383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bkdBQmvwUEaUeR1N7kAvXDCGC1LHw9KvxMa6aH/98BnMtvpvU9qJ8M9v6YHO+SjvvyVRUl0AGRhbfs3PaaykJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com



On 6/08/2024 11:32 am, Williams, Dan J wrote:
> Kai Huang wrote:
>> The TDX module provides a set of "global metadata fields".  They report
>> things like TDX module version, supported features, and fields related
>> to create/run TDX guests and so on.
>>
>> For now the kernel only reads "TD Memory Region" (TDMR) related global
>> metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
>> module, and the metadata reading code can only work with that structure.
>>
>> Future changes will need to read other metadata fields that don't make
>> sense to populate to the "struct tdx_tdmr_sysinfo".  It's essential to
>> provide a generic metadata read infrastructure which is not bound to any
>> specific structure.
>>
>> To start providing such infrastructure, unbind the metadata reading code
>> with the 'struct tdx_tdmr_sysinfo'.
>>
>> Note the kernel has a helper macro, TD_SYSINFO_MAP(), for marshaling the
>> metadata into the 'struct tdx_tdmr_sysinfo', and currently the macro
>> hardcodes the structure name.  As part of unbinding the metadata reading
>> code with 'struct tdx_tdmr_sysinfo', it is extended to accept different
>> structures.
>>
>> Unfortunately, this will result in the usage of TD_SYSINFO_MAP() for
>> populating 'struct tdx_tdmr_sysinfo' to be changed to use the structure
>> name explicitly for each structure member and make the code longer.  Add
>> a wrapper macro which hides the 'struct tdx_tdmr_sysinfo' internally to
>> make the code shorter thus better readability.
>>
>> Signed-off-by: Kai Huang <kai.huang@intel.com>
>> Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> ---
>>
>> v1 -> v2:
>>   - 'st_member' -> 'member'. (Nikolay)
>>
>> ---
>>   arch/x86/virt/vmx/tdx/tdx.c | 25 ++++++++++++++-----------
>>   1 file changed, 14 insertions(+), 11 deletions(-)
>>
>> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
>> index d8fa9325bf5e..2ce03c3ea017 100644
>> --- a/arch/x86/virt/vmx/tdx/tdx.c
>> +++ b/arch/x86/virt/vmx/tdx/tdx.c
>> @@ -272,9 +272,9 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
>>   
>>   static int read_sys_metadata_field16(u64 field_id,
>>   				     int offset,
>> -				     struct tdx_tdmr_sysinfo *ts)
>> +				     void *stbuf)
> 
> The loss of all type-safety sticks out, and points to the fact that
> @offset was awkward to pass in from the beginning. I would have expected
> a calling convention like:
> 
> static int read_sys_metadata_field16(u64 field_id, u16 *val)
> 
> ...and make the caller calculate the buffer in a type-safe way.
> 
> The problem with the current code is that it feels like it is planning
> ahead for a dynamic metdata reading future, that is not coming, Instead
> it could be leaning further into initializing all metadata once.
> 
> In other words what is the point of defining:
> 
> static const struct field_mapping fields[]
> 
> ...only to throw away all type-safety and run it in a loop. Why not
> unroll the loop, skip the array, and the runtime warning with something
> like?
> 
> read_sys_metadata_field16(MD_FIELD_ID_MAX_TDMRS, &ts->max_tdmrs);
> read_sys_metadata_field16(MD_FIELD_ID_MAX_RESERVED_PER_TDMR, &ts->max_reserved_per_tdmr);
> ...etc
> 
> The unrolled loop is the same amount of work as maintaining @fields.

Hi Dan,

Thanks for the feedback.

AFAICT Dave didn't like this way:

https://lore.kernel.org/lkml/cover.1699527082.git.kai.huang@intel.com/T/#me6f615d7845215c278753b57a0bce1162960209d

