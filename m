Return-Path: <kvm+bounces-15178-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D2EB18AA5A3
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 01:09:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87C8E283927
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 23:09:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C1426F060;
	Thu, 18 Apr 2024 23:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P9tId6Uq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBD04F5EC;
	Thu, 18 Apr 2024 23:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713481787; cv=fail; b=UDjCAkGJbRcj1mESWKnZslbfHUC0TLMLFI07yRegEqsvOIsqne0T0SUDNT35TScUmnSKOJ2A7nFRxalgQEefjAaa9JTTBaTpaXqa7ZCkunDjjA+vqeRtHR0lFyKiJFhMuSqvxwFSIVUchVRXTHtnThBSBCxr5Ok7bCqvIWpK59M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713481787; c=relaxed/simple;
	bh=NrQlIRKMN4BcInRx0GoD75XgJ2KY+FMLSVfitckN8I4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KuTOZ2NhwzrY1VvH+9TTkt+IlwNsiD3Xl9/4b011GVDbEE7M0PLliW7VI2eGbymAbLojkyso4+6ocisf5yNGRdJ0xoC2wPekAIP85jdAGFQvG28E74XN9v2Hd1A6cHUQkfMNjXTl24A/ZrZtPEmAdbAnihxxbaThuqa9pjU3jrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P9tId6Uq; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713481786; x=1745017786;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NrQlIRKMN4BcInRx0GoD75XgJ2KY+FMLSVfitckN8I4=;
  b=P9tId6Uqed89lKA0i59CuN7UlXbUTlICZpl0vTRG562X28Xa6MtnHzcg
   oKTm5jnM2I6QpISfrU1MdGkAIkk2Th8Oyp5UoM9RCEpE/CZwWSpzN9kgS
   yHwkGSopmDi/N1BcEtQ8ukR0bBWctONlrNss9sGLceUM4BrP8ZmDyNDA9
   gRhhM5qWTDC1VQnJdtZQdHE/0YOW6SK4S36ZvS25s7+uvzIgjPBAdW7gO
   iSrrg1L4bx1A5Bl0myrDyzSBYzZi8pv6gTQrVY8W6o4wZN8+CttxRDIyb
   Yn/Dw8D/HgxIzfDnzlj1gM4v1hYziTjhA2p7S3diZqXihWSgOywyIYKyn
   A==;
X-CSE-ConnectionGUID: Im+6k1/HTnOa8VXVOZ6vOA==
X-CSE-MsgGUID: YQvAv7AjSoeJMw5+cojaLw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="19626409"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="19626409"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2024 16:09:45 -0700
X-CSE-ConnectionGUID: Fs/jTUVBQWO8WpUSOS0pyQ==
X-CSE-MsgGUID: k66P8h7jRWG0YmaJoyjUag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23758146"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Apr 2024 16:09:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 18 Apr 2024 16:09:43 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 18 Apr 2024 16:09:43 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 18 Apr 2024 16:09:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXV/Xr1YhmlbnQxPEgYW0HTF443GAanYjVIdKwBvFiYhwOGhnsYcnR11LGUWAPc9g385JQ3s9Wwf/b9bY1CorGqVDWAI+Dy1SPf2chDyAj5ZD87sicTrHXEYJPccJTAHOlJ+V7WJGMPZIedTClHK2sTZnVjNRXcS2IRHr+QdrLBePrtnAGTuGj3uw98uSNBsshFr+FQVK9HDdVwf0AIzsld/PHTXGxt9NPqDZBtx3n+PNVERCVCcJDZmDeNxjsXbGLpo6zsPk+INbRpG7mp9PS0RF4MuAONm2AKCTGXYIBk/8qwnyC1OCL0hXjkt3Q22i7TucKMYNK2KMC9jNZkIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NDkFfGPowe2kOddAAs3eG9zVCbCm1+kDR0uIEUuLC1g=;
 b=SxqvDGaBkFk5LV7r/z90TH+vQuPsrbXIvPIQU1RNB3hv3RsVcdhZcdAzJidBfJ1q8ilA9b40eT4Iz1zoqrYopVcT3cBWfPSFiFQWD538q2AZM0Sp/wYy8TbWKzQ15kaxoxkbpKqFU62jYMgXqSNJP2qleOAw82cJgGjiKpWc08Dq6CwRupBS4EEMYAW+xHd6bc8aV64R5GXhPyaiOHPHzLSb/lHzxW0Sn/fNCYfyChQjr2iOgYUgi060Qh/BgxB/+8/IUJngKnQJOpouI0jMqT00Vnc7wPT6jPXdWRlotmYLBqeAzhdVGGtvJk/crJb6cHiRgs7b+pLxkAhraYGUoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB7446.namprd11.prod.outlook.com (2603:10b6:510:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 23:09:40 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 23:09:40 +0000
Message-ID: <22b19d11-056c-402b-ac19-a389000d6339@intel.com>
Date: Fri, 19 Apr 2024 11:09:30 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: Tina Zhang <tina.zhang@intel.com>, Hang Yuan <hang.yuan@intel.com>, "Bo2
 Chen" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Erdem Aktas
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata
	<isaku.yamahata@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <ZhawUG0BduPVvVhN@google.com>
 <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
 <Zhftbqo-0lW-uGGg@google.com>
 <6cd2a9ce-f46a-44d0-9f76-8e493b940dc4@intel.com>
 <Zh7KrSwJXu-odQpN@google.com>
 <900fc6f75b3704780ac16c90ace23b2f465bb689.camel@intel.com>
 <Zh_exbWc90khzmYm@google.com>
 <2383a1e9-ba2b-470f-8807-5f5f2528c7ad@intel.com>
 <ZiBc13qU6P3OBn7w@google.com>
 <5ffd4052-4735-449a-9bee-f42563add778@intel.com>
 <ZiEulnEr4TiYQxsB@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZiEulnEr4TiYQxsB@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0038.prod.exchangelabs.com (2603:10b6:a03:94::15)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB7446:EE_
X-MS-Office365-Filtering-Correlation-Id: 21088b87-5c27-46ce-e4ae-08dc5ffca010
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1p9Kno7FdNtpVUcUd7ZUWk6UMAWoaUbzhfiCoow0GwbVLk6LCqdeAPL5AKsCT0sBSqc7ntqTXpPZU9kOcTVdFs2ih4uow656+ap1+HqMXStrUbhzYg3zga6KhAqcr5R/iCFZctfhm+CTFiVxXI5LZ2aDiYmLfGTSdwQBXzqHm736IHvpPyEQcZc51wn+zfJ5ztth1gBduMsW8R5LJ0/kVmliBL1DS6JsuqhT2+un6Pg6oL6VdOGMwTUqB0NGIHgIvwqZPiiVdI/h8Ep2SeUAUF2eIOKTB8ZiYop29c8uugGbcgfWP1wZLE1pOTz2iY12WCK68OA2aU8H6ifDuMdEsrgtvlXbxurguLg4GgI1PkvgdNTCQ9sYfJ8TE+mmOiemuv4bM+FTDzvsoFxZPVOaz+ZS+4zDpOTiQuJ6ZyL0soIn/djMy2fp8P4SoP/ljMJLS8ve01H/y1ZV08K3iv797aeG4/yp5uIZyl4ZOnVZ/n1zLvM+jeIiLVwKDtll8NkWTrXC/YGPZESfDaPAXcbTSDdOC8F9IfV98Xbb99lSWJMHNU6A4v0ndS9ntPN4o78Ta9f8XXe7UiEzD0D0lULZOzy4ULn5FoaRfIDnSZJ0I55rQjS0F6+CpMCUiOcnYOOklfbYaMP5/N0n5CwUaUEbtH4iNbqXEIf6d4ErxdFEkJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QlNQZXNDOFR5aWFjUkJVb1NZaVJPZmpBWkNyUGxCdFJWVGRPK3dqNTFBQXBR?=
 =?utf-8?B?c3VNdVJ5Yk1UZjNVdkluYVRJQUFBUmN2d2ZKb29rNWFoMEE5MW1tNEE0L0Nu?=
 =?utf-8?B?cGdta3lPZFJnVHFKMmtpalhsZjhBWkxMbTdzOWZETW5HNHowYWViT0FvamJi?=
 =?utf-8?B?NVlHWE92cWxPdFlkTkpTUEdPQVVCWTc4NmtoYkVmZURsWXJsRzlLR1loWUpw?=
 =?utf-8?B?YzhPTzZZamRoR0ZMeGtjcVVoWVlkb2owdk1QQW1FQVMrM1FJNU9BNnpkL2tI?=
 =?utf-8?B?NmJYUWsrRU0wZ3pqdUlQTldGK3hCUFdqbmtXZjh1b3hxY2JES05SOGVJbzdj?=
 =?utf-8?B?ejJYWEE0RFN2d1lOcDE5NWViNk9WbVhaeFBEL0FsbDI4TlUwaWZRMkViM3FI?=
 =?utf-8?B?R0JhWGxuZ2NJdkZ6QlZxeUhoTU5yVTNYRnBCZU9oWWNrZzBGNDcxd0xGRzZL?=
 =?utf-8?B?R0xPdFVGZWg3NjBQUDFPYVV0ZGhoUU9waFB1UExZdUpBaWJUczZkYlFBODkw?=
 =?utf-8?B?VW4wRit4ZnByL0p2TGo1VXBKN2hSNWpiUEVlZ0UraWdNNHhWMDZiMFFKd093?=
 =?utf-8?B?QWZQNlV3bDl4UkxlNmRhd2NlOWE1TEV2VFVpckgrWklUYk5pdTRLTE5lLzMr?=
 =?utf-8?B?c1EvL1ZTOGZHbjNtZGpENVU3UmRnbXdWYUlTMTN5V3B2eVAxMW10YWd6eHR3?=
 =?utf-8?B?VVF6UWRPUk5rV25GS0dBcGFpV1Z5VVB0Ukg3bUhzN2pSUDg3bnNzQWI5MGNm?=
 =?utf-8?B?Q2JGU0FPQW9BOFEyNEIreDJXdjdtOCtSRDAvRVR2WGtlcFdRMW0xblRtcVRk?=
 =?utf-8?B?SHFtdlM5RHI4YXowUmIxSUV2M04yaEhwcVBpa3d5S0R5NDRGL0JpVFUxclVL?=
 =?utf-8?B?bUlIMXpNUTJoOGFQRG9BN05QcVE2K3RHazFocS9QWlhQa1dTZXFtQWlMaTlT?=
 =?utf-8?B?VWtVc2cvVzdxazJxR0VSZ3I2STNNRmtjbENMQWJrRHNpOHdUYngwVUZFcnRy?=
 =?utf-8?B?Vm5oSlM1bUtPZzdqM3ppSm8rV00xYllUNnZxOTIrVEJ4QWxVTEtEdVJIM3JF?=
 =?utf-8?B?bUhJRUdNK1VYUEZqTUd2OE1tNEQrMnA4RnRrcFdnU1ZUcG95Y05SRWhUVU03?=
 =?utf-8?B?SGtkZkR0SFNvc1BXVEJSZGtNaTMrU3g3VjYrNHJmS2c3dWUxUERpSTRmUmQ1?=
 =?utf-8?B?OGVtQURYc0lSbmlVRm51Y21WNUtMZGc0Y0lSVkxjWXpRc09TYkF6alg3WWY4?=
 =?utf-8?B?bVFuRW5neXFNdER1SXB2Nk5UNWZBT2VmWkhDTmZ1UHEwQmZFOGdkN1Nqbmwz?=
 =?utf-8?B?S0llbm9ONktIUFVRaG1yWmRkeE90ZUx0SnNnVGxuaHloWnUyR3RPVzhDSS9k?=
 =?utf-8?B?cXdjazh6NlhHbGNaalVyWUVSWUhMSUZ4c1hFRE9uRDgyTjBFVVlkSzFhVG9G?=
 =?utf-8?B?THJsSElsYmY4b0EzZG5ldGpzVjR2ekxmalJMUk45c1VKZTV4NXhKbHY2WHF2?=
 =?utf-8?B?L09yZ2RZZGxFRG9LYWdVY24zNE9OWWlWS3dOWXRjV1VJbTY1bnlWTE13SVh2?=
 =?utf-8?B?ZGxINWsxODN4aTRGeFlzZW1IZkFvVnZyY2s4SDRaMGZUSjFSSWdCbi9EUDF3?=
 =?utf-8?B?anVPWGZwTzFxMStXWjk1N1FPdlRETzVYekF0Sks0Mk1kNGZZUjNDTjdBMGJO?=
 =?utf-8?B?Q2FpZmJHKzNyYkhQaVFDMXBiRVFRR2h1a2I4MzdZeGZ0RDl5VGkyRk0rUEpD?=
 =?utf-8?B?Rmh6Ym5sNkJOdjFlRjhnczJEK2tPeDlxN21rVC9tZG9HWFpyWXM5TlV1YlZJ?=
 =?utf-8?B?ZXRDZVh4aW82b2MrTjQwb3pkOEM4Z3dUMmhzVTU1NXBWRWEvR2I1RkswWVVq?=
 =?utf-8?B?YUR5MGRhK3oxYXlWSjVzNE9MakJPaTk0WVgwUGxLbDVIcDdUZjhPM0JJK2w3?=
 =?utf-8?B?amdVYWpjMzBMTGJyNllQS3pqQktnVVlsQU83RnZReVBrUHZoYkZYN2FsQTE2?=
 =?utf-8?B?ckFRSnZHTE1YV3VZMUZyejFiMHJia1hvRWhMbUNXVCtOTVNKd2ZzaW5WNXdp?=
 =?utf-8?B?YkNucFcvOWp5d0pJWVVSTlh6S1NyYkNOQW1zMXN2SGxYbmhIcExSSXBwekVT?=
 =?utf-8?Q?uYReRzAIv7awbjZOmj6AvcsI/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 21088b87-5c27-46ce-e4ae-08dc5ffca010
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 23:09:40.3463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32VTK1+eRFK9BBKlsavPUlDs7Ow5iJAHFyzvf43vF0VhxI2OPfUkHQxv8xXHSKUUVxkvxNwqnxsYvpAP5m3QkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7446
X-OriginatorOrg: intel.com



On 19/04/2024 2:30 am, Sean Christopherson wrote:
> On Thu, Apr 18, 2024, Kai Huang wrote:
>> On 18/04/2024 11:35 am, Sean Christopherson wrote:
>>> Ah, yeah.  Oh, duh.  I think the reason I didn't initially suggest late_hardware_setup()
>>> is that I was assuming/hoping TDX setup could be done after kvm_x86_vendor_exit().
>>> E.g. in vt_init() or whatever it gets called:
>>>
>>> 	r = kvm_x86_vendor_exit(...);
>>> 	if (r)
>>> 		return r;
>>>
>>> 	if (enable_tdx) {
>>> 		r = tdx_blah_blah_blah();
>>> 		if (r)
>>> 			goto vendor_exit;
>>> 	}
>>
>>
>> I assume the reason you introduced the late_hardware_setup() is purely
>> because you want to do:
>>
>>    cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_enable);
>>
>> after
>>
>>    kvm_ops_update()?
> 
> No, kvm_ops_update() needs to come before kvm_x86_enable_virtualization(), as the
> static_call() to hardware_enable() needs to be patched in.

Right.  I was talking about that the reason you introduced the 
late_hardware_setup() was because we need to do 
kvm_x86_virtualization_enabled() and the above 
cpu_emergency_register_virt_callback() after kvm_ops_update().

> 
> Oh, and my adjust patch is broken, the code to do the compat checks should NOT
> be removed; it could be removed if KVM unconditionally enabled VMX during setup,
> but it needs to stay in the !TDX case.

Right.

> 
> -       for_each_online_cpu(cpu) {
> -               smp_call_function_single(cpu, kvm_x86_check_cpu_compat, &r, 1);
> -               if (r < 0)
> -                       goto out_unwind_ops;
> -       }
> 
> Which is another reason to defer kvm_x86_enable_virtualization(), though to be
> honest not a particularly compelling reason on its own.
> 
>> Anyway, we can also do 'enable_tdx' outside of kvm_x86_vendor_init() as
>> above, given it cannot be done in hardware_setup() anyway.
>>
>> If we do 'enable_tdx' in late_hardware_setup(), we will need a
>> kvm_x86_enable_virtualization_nolock(), but that's also not a problem to me.
>>
>> So which way do you prefer?
>>
>> Btw, with kvm_x86_virtualization_enable(), it seems the compatibility check
>> is lost, which I assume is OK?
> 
> Heh, and I obviously wasn't reading ahead :-)
> 
>> Btw2, currently tdx_enable() requires cpus_read_lock() must be called prior.
>> If we do unconditional tdx_cpu_enable() in vt_hardware_enable(), then with
>> your proposal IIUC there's no such requirement anymore, because no task will
>> be scheduled to the new CPU before it reaches CPUHP_AP_ACTIVE.
> 
> Correct.
> 
>> But now calling cpus_read_lock()/unlock() around tdx_enable() also acceptable
>> to me.
> 
> No, that will deadlock as cpuhp_setup_state() does cpus_read_lock().

Right, but it takes cpus_read_lock()/unlock() internally.  I was talking 
about:

	if (enable_tdx) {
		kvm_x86_virtualization_enable();

		/*
		 * Unfortunately currently tdx_enable() internally has
		 * lockdep_assert_cpus_held().
		 */
		cpus_read_lock();
		tdx_enable();
		cpus_read_unlock();
	}
	
> 
>>>>> +int kvm_enable_virtualization(void)
>>>>>     {
>>>>> +	int r;
>>>>> +
>>>>> +	r = cpuhp_setup_state(CPUHP_AP_KVM_ONLINE, "kvm/cpu:online",
>>>>> +			      kvm_online_cpu, kvm_offline_cpu);
>>>>> +	if (r)
>>>>> +		return r;
>>>>> +
>>>>> +	register_syscore_ops(&kvm_syscore_ops);
>>>>> +
>>>>> +	/*
>>>>> +	 * Manually undo virtualization enabling if the system is going down.
>>>>> +	 * If userspace initiated a forced reboot, e.g. reboot -f, then it's
>>>>> +	 * possible for an in-flight module load to enable virtualization
>>>>> +	 * after syscore_shutdown() is called, i.e. without kvm_shutdown()
>>>>> +	 * being invoked.  Note, this relies on system_state being set _before_
>>>>> +	 * kvm_shutdown(), e.g. to ensure either kvm_shutdown() is invoked
>>>>> +	 * or this CPU observes the impedning shutdown.  Which is why KVM uses
>>>>> +	 * a syscore ops hook instead of registering a dedicated reboot
>>>>> +	 * notifier (the latter runs before system_state is updated).
>>>>> +	 */
>>>>> +	if (system_state == SYSTEM_HALT || system_state == SYSTEM_POWER_OFF ||
>>>>> +	    system_state == SYSTEM_RESTART) {
>>>>> +		unregister_syscore_ops(&kvm_syscore_ops);
>>>>> +		cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
>>>>> +		return -EBUSY;
>>>>> +	}
>>>>> +
>>>>
>>>> Aren't we also supposed to do:
>>>>
>>>> 	on_each_cpu(__kvm_enable_virtualization, NULL, 1);
>>>>
>>>> here?
>>>
>>> No, cpuhp_setup_state() invokes the callback, kvm_online_cpu(), on each CPU.
>>> I.e. KVM has been doing things the hard way by using cpuhp_setup_state_nocalls().
>>> That's part of the complexity I would like to get rid of.
>>
>> Ah, right :-)
>>
>> Btw, why couldn't we do the 'system_state' check at the very beginning of
>> this function?
> 
> We could, but we'd still need to check after, and adding a small bit of extra
> complexity just to try to catch a very rare situation isn't worth it.
> 
> To prevent races, system_state needs to be check after register_syscore_ops(),
> because only once kvm_syscore_ops is registered is KVM guaranteed to get notified
> of a shutdown. >
> And because the kvm_syscore_ops hooks disable virtualization, they should be called
> after cpuhp_setup_state().  That's not strictly required, as the per-CPU
> hardware_enabled flag will prevent true problems if the system enter shutdown
> state before KVM reaches cpuhp_setup_state().
> 
> Hmm, but the same edge cases exists in the above flow.  If the system enters
> shutdown _just_ after register_syscore_ops(), KVM would see that in system_state
> and do cpuhp_remove_state(), i.e. invoke kvm_offline_cpu() and thus do a double
> disable (which again is benign because of hardware_enabled).
> 
> Ah, but registering syscore ops before doing cpuhp_setup_state() has another race,
> and one that could be fatal.  If the system does suspend+resume before the cpuhup
> hooks are registered, kvm_resume() would enable virtualization.  And then if
> cpuhp_setup_state() failed, virtualization would be left enabled.
> 
> So cpuhp_setup_state() *must* come before register_syscore_ops(), and
> register_syscore_ops() *must* come before the system_state check.

OK.  I guess I have to double check here to completely understand the 
races.  :-)

So I think we have consensus to go with the approach that shows in your 
second diff -- that is to always enable virtualization during module 
loading for all other ARCHs other than x86, for which we only always 
enables virtualization during module loading for TDX.

Then how about "do kvm_x86_virtualization_enable()  within 
late_hardware_setup() in kvm_x86_vendor_init()"  vs "do 
kvm_x86_virtualization_enable() in TDX-specific code after 
kvm_x86_vendor_init()"?

Which do you prefer?

