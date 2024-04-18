Return-Path: <kvm+bounces-15043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA2A8A9022
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B5721F21E9E
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CA845CB8;
	Thu, 18 Apr 2024 00:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="is+WbknB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF32B4C69;
	Thu, 18 Apr 2024 00:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713401236; cv=fail; b=U7NdAKEqSKIbabVCglgCU9OaVDzdN+4MxRymsNXxu3TOq76tWraslgJ5GxmlDxmmhrSw/tSUGCN9qwraiVAah7PexAgI+asehbQBd2+/zFHh6vmgbsYpws5fz1/M61PPJpnfdRd9c6ypr/s3Oj1XiLRjpFZYSJZ3m+QhmQtsGNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713401236; c=relaxed/simple;
	bh=h62rF652a9HrHnEWlfb0haaDI9Nr/FTKWOqhaAo+lgk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OkhJiMng4m/iHtfm3EChIj9NLfAF+Vbv/gjb9GLe67MmgkvHg49V2obCVtzbBX43P7QgXdcW+XRiboZwI+bs/4d8NACUaTQbv3GR2pp5yVhD6442gfEMzSv7OV0bQpds/ngNp2CN94+th03StA0eZTMZaAog+9q7e4vuQuu4JCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=is+WbknB; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713401234; x=1744937234;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h62rF652a9HrHnEWlfb0haaDI9Nr/FTKWOqhaAo+lgk=;
  b=is+WbknB5m68DsnyFPwX1OrCVBgGsSK/pEr9lzqtNUQMD2mT8/p7nfHt
   EY6pUI7EQp4iOoOCmt+aXHJzU1zwpvhxzFMO+9Kj5d1MEFZEseaLRipaa
   AQX2E32H5IzBlm2rWtGjbavL74I+LU8ttxT2F35rzFyeoUFFfab2EuzH6
   r+xvh0nbZfgZPPkFbrUymNpUPGJDKPXgdBwAITjKPNc3licqfT8Ip9m+Z
   r1kDoSdbZvs/FAIK8vj0E6nNvZ32YiZc8q0NO01I3KJlxYtfIsZettSOj
   PiLQkwsRrQx801qoGyiI/jrcM0RrrGN3ybBbWq1lAububg8RdVh+odtFM
   Q==;
X-CSE-ConnectionGUID: rRUewUxLSdqGOxIKkRZ4eA==
X-CSE-MsgGUID: m1/fkNXaQdipuvsrMSt1lA==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8848384"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="8848384"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:47:13 -0700
X-CSE-ConnectionGUID: 7PI0mV/WQ4iwd0miMW/Gog==
X-CSE-MsgGUID: tFh0EYuzQ7mn5XCz4IPV5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="27384726"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:47:13 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:47:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:47:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:47:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRGGJ9ngfBxBoo/azYnGUTY7LlsaXmr+rGFpptxTqhA0lHHXZ+cQ4ccE6tO88yQkBZQ2CMhI7rVy5IjwsNHXbNSLQ4LlzwvETcKEuxauh6ICMCG0CoBcC11GMZdj6r5AidFgty8OBaYZTbS/G4mXaqykOIpneBXtewoYZS6S1V7RvmMefSVH0A2rjZxg1m2SyfLfm9sLi+AYCj0gnwPW2lLIQuN/LJf+8Lsv7MDSDMX6DBgWdnO5m7abFPpyJxOpZm22yIA/O45secG4LNCNYhj9u6TzYnL7dgCHjmZEJtc8iTuNsYEsJXqgdRbU+YUYZ7ilu2DdEf68wXrR1Cc7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C94vBqsOoQUmMvzer1mZxum8S5PVeTzDkllxOOga1tY=;
 b=I6Kb/uN00jCzb9zC7CXchIKaNZlDXpYwtnLozud05wN7ZfozahcIukRUuZ+7Eu9MHRjTQuseXPo+YtR4dE8XN441Ggziyibl/Gp2bgnneyXBwjvMCIGxjyLUWI1S6uppWg7033obItRxBaqQFuWi8ld/FAUz2OusZP1RLbQMy0YJW48ug73PCb95pyXO8tfZcUUX1cV50LnTIonWbdF6P0VZAVSokNxQR4HgpQdxMQjHw84gxsMvqT4LivwFEZpOEwY6RKRPFnbYmRNbyCGkcWb4oMCED8+dnj6dfaiPVSLN3rvJGiiSbSMm2MKDZTlDCePfOR1U8GGU8iN8muD2Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH0PR11MB8144.namprd11.prod.outlook.com (2603:10b6:610:18d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Thu, 18 Apr
 2024 00:47:09 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 00:47:09 +0000
Message-ID: <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
Date: Thu, 18 Apr 2024 12:47:00 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <20240322212321.GA1994522@ls.amr.corp.intel.com>
 <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com>
 <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com>
 <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com>
 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com>
 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZiBc13qU6P3OBn7w@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::19) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CH0PR11MB8144:EE_
X-MS-Office365-Filtering-Correlation-Id: 52650961-3834-4cc6-0d95-08dc5f41141c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q5rysHq+zfrDEF5Lt9eZGUGBo6UGL5vAHftm2mduDkc7sUdeXRI+fTw2z1fxDin8dVGPtzEq9XaOD2naureHPg3CtUo+pf0wPsDujRImRXyTFrzvpCSRfNYONH7uo2kzLLMX2OoXKWe6eyKfUM9WwAZfaVeWmEuFVq3OjA/w5AMoUMdE8T5wM5kBRdD+MCMQIHanKfm9e2W5E2nKfs7OUHmWhxWl9GI/v2ccD4mQGhMso5Fm9d5RlYwUCZX4h8IAkJLY4raUSht2p/K+Po2z/frQCAEVnWXrQ8kOpofSXzLkIYS1J4HeFa5GwrygnOT2ItQ8xVmdF9KRTrmwqvbP0mQaclfWpBpcucasy1TExlhmITPWkybDDrM6COBFHM6xSTTJZnh05bB83Srex2PPJJmS3KobXQ9Trq2c8V7L7TwtN1IqDTd78oCCSk2n5WGSHmtuBzfmKfC8ILuW0m139RubBvrEOrvQLYgDS2WdmruignZv/hnLcFz3kQKQxjUHzMsZr4qVMj3M93NclrFFbTMcoAwIM2zG+ChnF/AByS53RYGOfLGLIel53iVgcL+RRbbSg0jaPBl97zpC7cjmxDpa7FPZ0Sh3lBT1Y45u7Dffz6ay6IC1NWztCdAfIZ8xFHGxxxdkr6WE13dIeaGh0NUcls73obDShckqXO66igo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0NYYWdSMVNuTitwMHVkd1ZtWkE2aG45c1hsaXdZRkpWenBPUkk5T1p0bW5R?=
 =?utf-8?B?T3QyR3ZGdGRiQUJreVVJdE1HM0FqOEU4b2F3RUZISGJsWWZuQ3c5dmFwL3pt?=
 =?utf-8?B?cEwrNGdSUnFBRDFRKzBlODJSL3pYdVorMWV2R1ZpdktVRk5JTWNTYTlEeE4w?=
 =?utf-8?B?Mm9xUzJzTFlEdDI1blNOZ1cvRldDUEFhaTgrVTF6cjU0Mzl3WCt1WXJ2UUFC?=
 =?utf-8?B?aXVJclFzRWFJdDl2OWh1V1UyR2Q5NTlwVWhOaVkvbU1VMjkrblM5OVJWc2RY?=
 =?utf-8?B?bHNVWkJaMHhNd3k0MVk5K1grdElFWmFnNzFyd1BKdDkxV2I2QkR2ZkhGM0dB?=
 =?utf-8?B?ZDlGZzJFSHpVM3NhSWRIU2w4aEwwUkk3SWg1Ly9MdzFFOFZKZEV2bEcyMUM2?=
 =?utf-8?B?UXR5NW1ETjRkbysvZVgyc3FVbHQyd1dQc0ZFRXJ2MjVsSkZqeExmbzJwdjZv?=
 =?utf-8?B?RGl6YjIxOFlHYW5Yb0RHZlEzRnBGeWlvS3BoVUdLc05PSC9hL3JTOGp2eFk0?=
 =?utf-8?B?QktOZ3ByNk5OYWVNbHRQbG95QmsxOFVvb0RzOHVheVMzTjBCZ3lOakwwQmZG?=
 =?utf-8?B?blFCaklvMjFtdnFtTGtsaTI4WXI0QXJoUzVrTTVvbHVMa0phM1dkNmhKZm85?=
 =?utf-8?B?Nzh0VWV1K3VHbjJzL2hrZTBRUGd2UlNDZlNWVHMrcUtMT1RSbXgzUHFqN2pV?=
 =?utf-8?B?ZFVNM0t5eFVTWkJKZ0dEaE9iYTlRQjJCUTBQSkVtSUh5OW5yOS9xKzN6R043?=
 =?utf-8?B?dStvdkNYV3YwTUtDQ3FYSkFuemJGc082ZEg5VjRVM1JTVXJwSHVoUTZtczUw?=
 =?utf-8?B?a0F0MGJOVER2RFpXMENBMG1FRHgxSkgyMjYrYVFVRk9aQ3BSTjJiOU9zQUQ3?=
 =?utf-8?B?MlBIQmpydnZNNVVXNzZ5MmRYaENKL0JwNHg4VE03ODdpM3RBd24yWUovVHRQ?=
 =?utf-8?B?bDN6dmlTbDlmenIrTXppM1d3WElvRmJXanZDVU8xdXJFNmF3aC81Nk1Xb3ZG?=
 =?utf-8?B?S2I0TzZXQ0dVWklvbTI4MDZ3Q3FUQTBWekVJbUd4NHhBTDBMNnlCQWtXSG9q?=
 =?utf-8?B?ZGNOZFU2emVEQkYybjc4WER1YzhxUG5DRmUyNkMrMFkvUVRiMnU4SGZXcnNC?=
 =?utf-8?B?a3I0dG8rQ1dWT3BKQkdvSENSc1VxcVUrNFk5YzBNaUQ4U3pMTnhSeUtGVDRF?=
 =?utf-8?B?SlNZU0R1WkxJcHoxNjB6R1FGUnpWNW5rdGRCZVE4NTYzaVZiR1VCaVlVNXlz?=
 =?utf-8?B?aWJLSGV1VEZLZXJkTWoyL2szWnUxdmJBS1dkdEg1dTllQkxUVFo4VkJSMjVR?=
 =?utf-8?B?L1doWTRQazhsczJ2bGxPeC83QWRzWTFvbjNtM1Zya21Gd3VncXJ6RVQ5b1pN?=
 =?utf-8?B?Y3dJelplY014MmJCbkxkYXVoSW95YjhiN2EybFBGQnBqMW5nMlEzdmp1UjNT?=
 =?utf-8?B?cFYxQ1l6SUlJVThGWjhpL3l6T1MydkFrZHhhWlZBODE3dXgxNnEwbWFPSVdM?=
 =?utf-8?B?T3RQV0drb1IxUkJxeUIraE5WN2xlVW5wY0dNb0NUaHhkWkJYTmc3OU1Kendw?=
 =?utf-8?B?QW9MdmZMZWhQL3U5ZlV1OE9XVSsreE4yS0ZhYTVRK1RodWxuNDF3MHd3ZlFl?=
 =?utf-8?B?TVcxaDlhMHM3R1RxWjhhMkc0VG5PUnJDSDJyWXE0eDBpZXR5Skt0QU5uUjZp?=
 =?utf-8?B?dWl2enppazBNU1BjcW1aNmMwT1hUUklMcEM3OXVLV2pocjdCYTBjNDNDdXpi?=
 =?utf-8?B?OE9CZnRuWUliaU9nU2FDSVNGcld1R3ZMYXViVXk5akQyZnk4Yk93RGk3RlEz?=
 =?utf-8?B?ZzY0NmZOSForSHlVdGpCVjBVQm1MaFk1b091dGhBYXl6TVgvZjh2bi9teDZF?=
 =?utf-8?B?ZmhzTCtGKys3K2VzSlA2Y3ZXaTdPSVdGcmRRSkp0YlBYNzNQcjZjNjJNYzFO?=
 =?utf-8?B?a1kxajB5SnBhck5EUWZXQ0Z3VjQ0WHFwbGJTY3Y3dFpNMVRGL0hrSnVHT0dz?=
 =?utf-8?B?NlpGczNNQlplTk5sNzlkRm9mdkFJVVBvRk92cVhzcXZxWmhBRmJUaXFNK2pv?=
 =?utf-8?B?a1N5WWpQU2ZOK2NlVm40SGFYWVR2QmlWTWdXUjVrWEw0L2xyMWRsV0thVHd2?=
 =?utf-8?Q?RFhMU98suG6yceSf9jIF+XxtO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 52650961-3834-4cc6-0d95-08dc5f41141c
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 00:47:09.6577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obC7jfxJzv92KrLnuabOuFSbLeTqsicj2ib3MAGJXp5k8WuyCey2RNeY5+UoElMfEqWAk2EPzbZy+gAp91lpiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8144
X-OriginatorOrg: intel.com



On 18/04/2024 11:35 am, Sean Christopherson wrote:
> On Thu, Apr 18, 2024, Kai Huang wrote:
>> On 18/04/2024 2:40 am, Sean Christopherson wrote:
>>> This way, architectures that aren't saddled with out-of-tree hypervisors can do
>>> the dead simple thing of enabling hardware during their initialization sequence,
>>> and the TDX code is much more sane, e.g. invoke kvm_x86_enable_virtualization()
>>> during late_hardware_setup(), and kvm_x86_disable_virtualization() during module
>>> exit (presumably).
>>
>> Fine to me, given I am not familiar with other ARCHs, assuming always enable
>> virtualization when KVM present is fine to them. :-)
>>
>> Two questions below:
>>
>>> +int kvm_x86_enable_virtualization(void)
>>> +{
>>> +	int r;
>>> +
>>> +	guard(mutex)(&vendor_module_lock);
>>
>> It's a little bit odd to take the vendor_module_lock mutex.
>>
>> It is called by kvm_arch_init_vm(), so more reasonablly we should still use
>> kvm_lock?
> 
> I think this should take an x86-specific lock, since it's guarding x86-specific
> data.  

OK.  This makes sense.

And vendor_module_lock fits the bill perfectly.  Well, except for the
> name, and I definitely have no objection to renaming it.

No opinion on renaming.  Personally I wouldn't bother to rename.  We can 
add a comment in kvm_x86_enable_virtualization() to explain.  Perhaps in 
the future we just want to change to always enable virtualization for 
x86 too..

> 
>> Also, if we invoke kvm_x86_enable_virtualization() from
>> kvm_x86_ops->late_hardware_setup(), then IIUC we will deadlock here because
>> kvm_x86_vendor_init() already takes the vendor_module_lock?
> 
> Ah, yeah.  Oh, duh.  I think the reason I didn't initially suggest late_hardware_setup()
> is that I was assuming/hoping TDX setup could be done after kvm_x86_vendor_exit().
> E.g. in vt_init() or whatever it gets called:
> 
> 	r = kvm_x86_vendor_exit(...);
> 	if (r)
> 		return r;
> 
> 	if (enable_tdx) {
> 		r = tdx_blah_blah_blah();
> 		if (r)
> 			goto vendor_exit;
> 	}


I assume the reason you introduced the late_hardware_setup() is purely 
because you want to do:

   cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_enable);

after

   kvm_ops_update()?

Anyway, we can also do 'enable_tdx' outside of kvm_x86_vendor_init() as 
above, given it cannot be done in hardware_setup() anyway.

If we do 'enable_tdx' in late_hardware_setup(), we will need a 
kvm_x86_enable_virtualization_nolock(), but that's also not a problem to me.

So which way do you prefer?

Btw, with kvm_x86_virtualization_enable(), it seems the compatibility 
check is lost, which I assume is OK?

Btw2, currently tdx_enable() requires cpus_read_lock() must be called 
prior.  If we do unconditional tdx_cpu_enable() in vt_hardware_enable(), 
then with your proposal IIUC there's no such requirement anymore, 
because no task will be scheduled to the new CPU before it reaches 
CPUHP_AP_ACTIVE.  But now calling cpus_read_lock()/unlock() around 
tdx_enable() also acceptable to me.

[...]

>>
>>> +int kvm_enable_virtualization(void)
>>>    {
>>> +	int r;
>>> +
>>> +	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
>>> +			      kvm_online_cpu, kvm_offline_cpu);
>>> +	if (r)
>>> +		return r;
>>> +
>>> +	register_syscore_ops(&kvm_syscore_ops);
>>> +
>>> +	/*
>>> +	 * Manually undo virtualization enabling if the system is going down.
>>> +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
>>> +	 * possible for an in-flight module load to enable virtualization
>>> +	 * after syscore_shutdown() is called, i.e. without kvm_shutdown()
>>> +	 * being invoked.  Note, this relies on system_state being set _before_
>>> +	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
>>> +	 * or this CPU observes the impedning shutdown.  Which is why KVM uses
>>> +	 * a syscore ops hook instead of registering a dedicated reboot
>>> +	 * notifier (the latter runs before system_state is updated).
>>> +	 */
>>> +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
>>> +	    system_state == SYSTEM_RESTART) {
>>> +		unregister_syscore_ops(&kvm_syscore_ops);
>>> +		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
>>> +		return -EBUSY;
>>> +	}
>>> +
>>
>> Aren't we also supposed to do:
>>
>> 	on_each_cpu(__kvm_enable_virtualization, NULL, 1);
>>
>> here?
> 
> No, cpuhp_setup_state() invokes the callback, kvm_online_cpu(), on each CPU.
> I.e. KVM has been doing things the hard way by using cpuhp_setup_state_nocalls().
> That's part of the complexity I would like to get rid of.

Ah, right :-)

Btw, why couldn't we do the 'system_state' check at the very beginning 
of this function?


