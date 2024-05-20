Return-Path: <kvm+bounces-17772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 790428CA0E5
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED6E11F21B53
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 16:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BFE3137C24;
	Mon, 20 May 2024 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AD8OoB2W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30D79EF;
	Mon, 20 May 2024 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716223986; cv=fail; b=H2AFmrmwG4NiHIgANg5nMQN/Re5AO2k1gWngaE9MoMYGBgOmDIks2wchighraW06lEMG+rzJEX0V+hTBERkiOgqLJTTnzJtMd1s9Q1MEy0h+sySC/+dz2L3EE8VPk03fkM2Gq2y7mY9m88MdBuTOGH59Uj0YxL+NRM6YmiTTYfk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716223986; c=relaxed/simple;
	bh=qnoTJCjtWRAJxCyMc35OdFy/ljI5I2RVNnBH2UukuLs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WKmPHXiXz3d/ZL/GVp8A3jGLVyh0qFQm1A6RxnqP7V2vZhfxg7f0Rh3EVX8PVWUciCOjzNVcQVDJZMHLruwLdcx2coPeGA/H0zgICI08joKK7lAJO+VOL82VbS2wV+f6MR2moFk1omsvbTmGMmx8RrsnYW6AJ1mWBiYqDVaxl1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AD8OoB2W; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716223985; x=1747759985;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qnoTJCjtWRAJxCyMc35OdFy/ljI5I2RVNnBH2UukuLs=;
  b=AD8OoB2WJLvzY2jyQ2puBFpe0JZLV+fIG4RKsI0xnIopPVgAbXkMLZwN
   QlZyW5sLBfhrlhMY6+cp8Sk4yp5UGVfe3zBGUhRO73/D73qwERz2PRh0W
   AOp6NGyG2FgNDOoLoeDT1Fk49YP2k6+mwoS/c0bChfNhMH3ITkY8TE58s
   vFrRKikrpGRQdL/15WCUVvoSWU/0CAOCZnjZ8IvCNjqPs7gwuvWbZJQZj
   RCcpQQfZpmO2/hwRZh89GuGNTryLk98bR3WiNwzwim6LLtIIjfe6sv8hH
   Z11sKi0mbfF0kyceuOXLw0o04XPA8+gnSSudjLaCAC1WT8aaQ2Md3bkxc
   Q==;
X-CSE-ConnectionGUID: 2/eiPPaCTdGBMmULSwKOCQ==
X-CSE-MsgGUID: 9JeQS0ItQ4e0iTXO3cbITQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12215243"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="12215243"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 09:52:57 -0700
X-CSE-ConnectionGUID: FVuRmAY4QNmirzL3UNfriw==
X-CSE-MsgGUID: HiwX0tOhTNaT0l9EKkMCDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="32765979"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 09:52:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 09:52:56 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 09:52:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 09:52:55 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 09:52:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTKgD1sHN09twS4OsGU7zH2+8vQDJT6cqcJUj88oPDdPIIIoOjBPTi/J2BNoCqqo/ib1+1Q3qHH54eqQEN2HoGlCvdQCz7e3pSWrrF+769gmU4ZGViNkvv0jmHCCelbv/cEvwDoZjzGyTGi07g5SdAfzOavaucC1DfIZg2npnXGBOEwPVywWKoDI0znFWJyGOT5iWHVvIQghF46L7rx3Ab3jEJmnqkn1VAP7qgO1CWznkkn8zn7EH0j5dC1l/Ez2LMZ1kNd1Iv/IjuO5huLliRJ1+FOuGez711nMCef6Iy8SD1DOHqeFHj+43K7lQ0ewgzbjbWe68IyBtRGMVe76dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UDpC8NZZvSXJNvqtqU7cN/YRNweZIJdA+urigHXxGrM=;
 b=NtTBSkwF7hl58VzDZ1sIAFWF1TMCmq6dn/thoeYBGV8fblo5CWDzGWfga1odwCELXrX3V8aP86CdHqfOY3suca7RQETnRb7oZe8B4IkkictQXA7nYfpwE0MFNGaS4/qJKQzx7AcqMhknjOfRF6E/k5X7DrUboajXC6OQ5vHhq/KaNDwJzWgAit/cmqw70J+Y0RHv4ogYbbl/heP0O396p5cM1Q0XmpjilVxcSbon4k5nu+0VNX6UerhXGawBvpl19/L+oHodpeOzz+K4KwrbTUHdwwErcfd/VhSMhJXRU+eBQwWhTxV4V8wZqx+HJ/wGcw85WtWo3y2bxpOPlU1d5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB8319.namprd11.prod.outlook.com (2603:10b6:806:38c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 16:52:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 16:52:53 +0000
Message-ID: <d0744767-e393-44cc-8786-5419afeaf2b5@intel.com>
Date: Mon, 20 May 2024 09:52:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1715017765.git.reinette.chatre@intel.com>
 <a2f7013646a8a1e314744568b9baa439682cbf8a.1715017765.git.reinette.chatre@intel.com>
 <c2baeb4b-5cad-4cb9-a48e-0540f448cb15@intel.com>
 <Zkt2gNFxC0MHyIRb@google.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <Zkt2gNFxC0MHyIRb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:303:b7::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB8319:EE_
X-MS-Office365-Filtering-Correlation-Id: 41386f54-8962-4a91-fe5f-08dc78ed4aa1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFlQOHRkR3N0aHlkUnByVG84SzVvejZHUVBnUEc0NFNVRzVkVXdUeUo5YmJ0?=
 =?utf-8?B?RHhoY2lwM1hsRWo0WjkzcG1IY3pIbTNoUWx2NUVIN2hET0RiVERSTldZSyt4?=
 =?utf-8?B?ZFFqT052ZFRkd2lOZXZHYUdjM0FTVTdyZStQYXpxNGJZRGhyeUl6MlkvUmtF?=
 =?utf-8?B?ZTB3UWVRZDhOSC9FQTdpaW9xa0dkSVA3ZWwrTDZHM3QvZWFNZ25PcG5SUHRh?=
 =?utf-8?B?VVYzSmEzajFUZFZYVjhydjIzTzRlQUlCM0hDbWUyanFERm1BWS9DT0FEVkM0?=
 =?utf-8?B?NmRycEhMZXhEeTBHV25jR2pRVDZSd1kwYmxYeW9iNm5GYVFDMVJpakR6UXF6?=
 =?utf-8?B?NzJ1SHBkQ0ZtYTgwOWVsQmttM3ZObjFUNlp4c3l3bnVjVDYzNnFmaUk4Mm1j?=
 =?utf-8?B?SjBEUFdoMTBURnZOUXI4QklETGhGdmNkV3hWZkNhRDhGVUQ3K2NVYTdYUTUx?=
 =?utf-8?B?blFCT2lDeTloS1MvaUpiZ05QYVdRS2JIK0Jack1MaHBnQUNzYkZOVWFibDdr?=
 =?utf-8?B?cVB1L2ZqSnBaRG9IaXl2a1BycFdNY2lFMnRjQzV2UkhWSGlQM0RQdGM2QTFN?=
 =?utf-8?B?WGkxaVRzTk5vanRmdkdyMjF6ZFlFQzFRMng3aWNjdmF1aklKRXhHNzIxbWI2?=
 =?utf-8?B?NzgyNGhHOS9lbkZmV1lxVEwxaEhKRFlLTGV3blJlVm44RlhFTlVTS1lQWVI1?=
 =?utf-8?B?K29XZ3dUUkJKR04xcVA3MjlaNjlxNnRicXpLWkMwbkN5Z2FWd3dXWm5lQlVk?=
 =?utf-8?B?NVZrU0t0L24veGVKeWk3cDBGZDQ5S1Q5UzhPZWh0Qy9XaGppWUNkOElzOGJ4?=
 =?utf-8?B?cGt2Y1lBVlJhQUJDUll5dzFQenlpYkh1TS9QZUVqVHROamtqVFRCNGM0UG4z?=
 =?utf-8?B?K0V1SERBNGdSOUI5UHpoaEh4blZZUmxKVUFwR2Z4WEJFM2hqcVVSOGpWTHRT?=
 =?utf-8?B?YUNZNnl5Q0VnTWJPNHQ3ZUpUR0hvYXp0N3hXS1JtNmd6RnVUK0F0TWtqdWwz?=
 =?utf-8?B?Z0h0QnpOaUprVDRPU0F5eTdTWTBZeDEzVHozb0dVTjA5MUJ2VWR1K3hvOWE5?=
 =?utf-8?B?R0l6bEFoWjEyRjU3WXZCTlFGaUFKQzJoZGtpSXZZVlA0TG1oL0tkejNMTnJu?=
 =?utf-8?B?VHlYcHYrVlJnWWFuTzJ5N0ozS3lzVW8yVTBNclFqQmR3UFZJc2xQdTJhOHZ6?=
 =?utf-8?B?WGdmRHE2VHV2UWJwV1MrTllsVGpET0N0dUwwL3Y2dkI2TEpjUzlqYWFCSmkw?=
 =?utf-8?B?NjB2dmtpSzZqQVFTS0RFeTJyVG9lQW85cWZ2NEkxYVFac1E5YU10SjZSZ0I3?=
 =?utf-8?B?eHF2ZHdTb3plaG9BamlLYlJjQ0JldUt5KzVGTUxRZWdjUEVDSGJ0cVRtL2Er?=
 =?utf-8?B?bkVkcDRoRjVhRDBqS1FWVURWYnNhVlQ5VEpjSWhqaHBQeFE3bFhOMGY3WUlZ?=
 =?utf-8?B?SWdrelhHdUZUcmZPeHdFdHAyN2Q0eUZnOVl6OEtxUnhuaStSdVNTaU1TOGlP?=
 =?utf-8?B?Uno1R1FLckR5ZnkwUXZUMXFqU25YKzdaaXhyekFxRUl2WXQ4R2RUVWRCVGtK?=
 =?utf-8?B?bXowK3laUTZvaXQxbXRFL05xRkVPeFdFZUpHaHdRblh0UCtJTEpnZGsvOWRJ?=
 =?utf-8?B?a0p3aUNIYlhjYUhvWWJMNDBXQjh1enNqS25EaUhjOWluMWlGeHNMaWlFWERt?=
 =?utf-8?B?TmNqVTRBdDhNNkJUdDdTQkZhK1JoTU1Yb2RSc3Q3SDZFTjExM3ZTNlR3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TklDUjJmMVRrSFEveFU5SVJlU2FWK0NpNEdkYlFHT2hKNGtueDNZeTc0OW1i?=
 =?utf-8?B?Zmt0SGdxeXJJYjdvN2Nsbml0QVVNbWFnckR2RW1pQUV4cGxmU2wrZXM3emIz?=
 =?utf-8?B?aURIR01ISTR1bUs2VjFDSlBQMjlZS1VZcnUxZC9Yanpma2ZsbG9EbktmQ1B2?=
 =?utf-8?B?S3NLME9JbnEvVEZXM2lYMGk5czBKQ3dqOCt0VkxsMGpEL3hqUk1KU0dra0dE?=
 =?utf-8?B?R2F4MUtabWx6Uk0xMmRvYmxYYnFsZFM4MXUwTVl6VWxHLzNwOUZTWjRhbGFP?=
 =?utf-8?B?TmFrWXBmTEF0MVRmUjQ5OGRHN0tDUU5LV3AyVXc0anFwTHk4aURoakIrbE1S?=
 =?utf-8?B?SlF0MVBTTmJOS3pOM21JQ25EcXVhT3hIYng0RWE1dktzZDYwU244SUl6TGVm?=
 =?utf-8?B?bmpDTmNqckF4WkxOaXpOUGVXZ3V0WFJLbWpTeFRHalJaUjNsbm1va0RuUDlS?=
 =?utf-8?B?b0NtT3hDakIvSFpVUDE0Mmh0Zkc2cDZQdDNWQkVHK3pvTlArdTh0VzEvSm9y?=
 =?utf-8?B?ZWxCL0xhcjhTb1hFeEozbTdjRlpZRnN5WWh0ZklyRU9TRUxyeHFlaDFiZXUz?=
 =?utf-8?B?Smc1dVlkcmFRVDFwbnJ0S1BtVUlyc3I3dDc3TUEwemRleHFOemwwMnZBaWlx?=
 =?utf-8?B?dVJTTTBWUVZTcFNHd2lUMEczMElsUjY4d2NZekFaTU1FY29UV1lxTEJtNEhK?=
 =?utf-8?B?TVVyOFVoV2xaTTk4SUREV2JnaUVKRTlKOUpJNDlTNjE0RzRiMlI4K2I3Ukgr?=
 =?utf-8?B?a3Q5bzhGREtlMlJoTVZ5K3pnblpZMjVCUDlRUENXWFhETGNsL2dTVVFJYWVT?=
 =?utf-8?B?Z3B1LzFnLyt2b1JNRCtEaWhrN3RIOU9BSDFtS0J3Y2xiblZsbitLbjNHQlhy?=
 =?utf-8?B?anJIRmw3aTEvYk9FR1h6dW9tcmp4UnZnR2l1NEU0VzdTY1dnL09lVFo5WExX?=
 =?utf-8?B?QXQ4R2dZTW80TDlZaW5Hc0lzc3F4am40Y0pIcmNWaXlpVmwwVGsyRVQvei9L?=
 =?utf-8?B?VzNJQzJXS1BMblM4UDQvRVU3YXVVWGwyZ3FET3VKQzZJMzMrTWw4c1c5ZjlM?=
 =?utf-8?B?ZGp3WUJzTFlVSWs2SVU0TFpqS0tlUnc5STJ5RWdWOVhsdCtKRlRDZDU2SU0v?=
 =?utf-8?B?VjVnTmxpanlyS1JVWWlZRkVVdmlPUUMwT0RsWDBaOE1KOUlyY1pUWFVaczlt?=
 =?utf-8?B?dnNtdisrSWd4N3Z5M01rYjh1Yk9nU0M3R0MwTmdxclNvZmR5OEZ5M2Fhb3N2?=
 =?utf-8?B?WUNGMFphM1dZT0hjMWs3dW1XTm85SzEyWFA2SlI1dUltRTVTTnlPa2Z4dW5W?=
 =?utf-8?B?Vy9YV0g2eXUxWFFQdlVaTlpvZ2ZKQXNtdnIwc1ExRGFLYUhxYUNCeHFFOE9k?=
 =?utf-8?B?cnZQV1hrei9lM05ONGZ0aWRsRGs4K3hkM2R2U3FxWTJscjE2L1FLQ3poVGVJ?=
 =?utf-8?B?Z1BFT1lrb0JwV0ZvYmdmcG5wbmVGeVNjVnAzeVE3RkxNRnVOMzhqM2kydDNr?=
 =?utf-8?B?NUp4Q3dFMFZNZy8xNTFwaHRraTZHU1dCMVZvT3daSmRFTWZGVVJ1NVdwK2dY?=
 =?utf-8?B?dkRUSlp4T1FGZmFTVHFuRjZMdGlFNHd2eEg2RWNQdW5BcVc2Qyt6TG9pUFhH?=
 =?utf-8?B?dUlDTEJuUjVXYndDZHdMNmJQV3piYVMyMmp2eit5VzF2eGVZR0NxNkJnRE9J?=
 =?utf-8?B?ZzgvVFJkUEcyVjJqN0IwQ1JTdFhqMWkwY1BEMEtIQk9LNSsyaFRSOEM3d3Fw?=
 =?utf-8?B?cHJFUVpWS2lqWWRQWUJZNGJMMXZCUmZ4eW1nR3U2alRndGVvR3lRNi9KWlow?=
 =?utf-8?B?VUNsZGUwN0NHTjFXeEZrWVgwK29iaTJUbDNGUXlwT3cwYU42R3R0QkJmeWJV?=
 =?utf-8?B?WWNuVzBmYldKeTE3QzdqcTg0U3RTYVFTUEhMQnJiM3RIcjhqNzcvbVUwaGhE?=
 =?utf-8?B?ZW1xMnVnUzBFdDAvYlY1bml6S2JOTlJFaVBNblpXK1d0RFU0L3VTWVhHTlR0?=
 =?utf-8?B?V3J4OFR0Rk5uTERXSmpiUXQ3aWk3cmFZTllyL1M2eTVKdFVQS1dKa3FIVXJv?=
 =?utf-8?B?U0JiKzlPVUxMdWFOaEtubi9FY2RDb0tPaURtNW5lK0xVN3JXWDB1N3JSbURk?=
 =?utf-8?B?L0Y0dnlXQXpkNnYrTUxUT3N6Q2VxTDd3MlJmUWZ2SHlCNyticmFNMWRYejdn?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41386f54-8962-4a91-fe5f-08dc78ed4aa1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 16:52:53.6510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B64xD2jnH4pk+hyF9VvV/yg+ozHIdurZmW1kNSdronGYydvy5yDvaC+aH7n91261iCbHLJJk1zOWHjgegv8K9foYxpOy7qs2fdQQSD3Sk6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8319
X-OriginatorOrg: intel.com

Hi Sean,

On 5/20/2024 9:12 AM, Sean Christopherson wrote:
> On Mon, May 20, 2024, Reinette Chatre wrote:
>> On 5/6/2024 11:35 AM, Reinette Chatre wrote:
>>> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>>> new file mode 100644
>>> index 000000000000..56eb686144c6
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>>> @@ -0,0 +1,166 @@
>>> +// SPDX-License-Identifier: GPL-2.0-only
>>> +/*
>>> + * Test configure of APIC bus frequency.
>>> + *
>>> + * Copyright (c) 2024 Intel Corporation
>>> + *
>>> + * To verify if the APIC bus frequency can be configured this, test starts
>>> + * by setting the TSC frequency in KVM, and then:
>>> + * For every APIC timer frequency supported:
>>> + * * In the guest:
>>> + * * * Start the APIC timer by programming the APIC TMICT (initial count
>>> + *       register) to the largest value possible to guarantee that it will
>>> + *       not expire during the test,
>>> + * * * Wait for a known duration based on previously set TSC frequency,
>>> + * * * Stop the timer and read the APIC TMCCT (current count) register to
>>> + *       determine the count at that time (TMCCT is loaded from TMICT when
>>> + *       TMICT is programmed and then starts counting down).
>>> + * * In the host:
>>> + * * * Determine if the APIC counts close to configured APIC bus frequency
>>> + *     while taking into account how the APIC timer frequency was modified
>>> + *     using the APIC TDCR (divide configuration register).
>>> + */
>>> +#define _GNU_SOURCE /* for program_invocation_short_name */
>>
>> As reported in [1] this #define is no longer needed after commit 730cfa45b5f4
>> ("KVM: selftests: Define _GNU_SOURCE for all selftests code"). This will be
>> fixed in next version of this series.
> 
> Don't worry about sending another version just for this, I can clean this up when
> applying.

Thank you very much. At this time this is the only change planned for this series.
I do not know the status of all completed and planned merges during the merge
window, but I did a quick check and this series applies cleanly on top of today's tip
of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git. The kernel parts
passed a bisect test cleanly, while the selftest encountered just the warning related
to _GNU_SOURCE.

Reinette

