Return-Path: <kvm+bounces-16360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 682E08B8E8D
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:54:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E89B1C217A2
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 16:54:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B932F14285;
	Wed,  1 May 2024 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PUn7F3zp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C52F134B1;
	Wed,  1 May 2024 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714582456; cv=fail; b=X9rBTOSk1zyNsYa/zNIynu2UltjmUUflmvS0roSCs9fUYICDAqY8FDBGxLq6X1qSKeXiVM+uniaaTaOIwvKSG0W5sL6rWi9ubG21cs0b/4wY1DNH7MI3gBvZxlqX9dhz5+2D8KvX5S19oOqZYuH7dUrdDYSYvUHciBJjWyVzrDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714582456; c=relaxed/simple;
	bh=lewglwi+RsLgYBpLpdTYJcOfB5Xfb9AxmB82lmgLNlk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GfnCLuDUE4CB8dMUtpaikBNAIHOFq8iCw4sYeaGGBvDPNKhwntCAoD7hCvZv/M0PecOnQTxkBhD31g1+zBjZZgwaaADeImVmKLNRSIHM+lpZCC/KsnjHFk0n/snVqHk5V0hVjWV1aQ2/rS560WlyvPJKPbTstm05eDG/UssBxQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PUn7F3zp; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714582455; x=1746118455;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lewglwi+RsLgYBpLpdTYJcOfB5Xfb9AxmB82lmgLNlk=;
  b=PUn7F3zp5ZZnAf72e8EOplUv3PBwfGAznHaIeDAJZfEO7m0oaiwU8+BE
   mnJjlqIcrgegee1T7QvdbcB3sb09NKEnnPpBRuG606QHK5McRdIBd06i1
   I6hEbV8mhk22dL+hF0K1K3wSfyGAxjmIogBC04bKPH+pIkKawxBQzv55n
   3XR/UkttZUkEHoZmUDi6Av9P02NTM08N9/aXQkDDSlngwICIK/QaZqtMB
   e3BO4hgOeNA0GyDP0GtFdBVzyDbXOCCOBQaiVIq7hKfikNSCGcr8zKmAN
   hiTqn5Iol+VHI5rKSGV+ia5L79OMBMzQ5W/uXQWgF5TOVRU4cEwpR+3jA
   A==;
X-CSE-ConnectionGUID: IFU14yQfTIuOQwfR2fw3AQ==
X-CSE-MsgGUID: 8Nje7LC2SDeVvsQqnzUDWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10169862"
X-IronPort-AV: E=Sophos;i="6.07,245,1708416000"; 
   d="scan'208";a="10169862"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 09:54:14 -0700
X-CSE-ConnectionGUID: WXdWbQgxTk+IYtAohWxKCA==
X-CSE-MsgGUID: Ot3hGALfRP+P9yLCbAIvdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,245,1708416000"; 
   d="scan'208";a="31641925"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 May 2024 09:54:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 09:54:14 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 1 May 2024 09:54:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 1 May 2024 09:54:13 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 1 May 2024 09:54:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPJriMX5W4jV5Im5f8Qulpouq8beoSUOV9L1oOQ7Rj8sxsmwe8QmnqsFB9NJcYt5PMMwyBHPGFRR+W2VQXD1oUqdqyi6OWd0YIIbAwFCOoGvB0yss9lOGkdFzoQZht6dmuwjjcNNWrdsi5CjSPMrh3ImrQjT8bxu4OsHEDIKVBFwFGGTvmd/KzNGID7xIUf7yiPKwtgJNTmhHa17uCJXsRpGr4Hf+dNLhQulQwiMA9NDZPw8JeFotoSxzppfV3tEUL7Ig2WHagD0beKsQxZm9TtiPT6MavR+NNn/+G+K7PJETAQJSnvJ8iygY9vBXYDsr+ZN9NmHgLaFiffPlYSnIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2lTtnITVADic96YRif4AKQW5RJhp+F4MhhFlY94Rz0=;
 b=JiTqlZsw73307THji3I2qeuY9hXmEOV8OrijyqDcnu9uQssprUu+sPO65Rq3w7nX1C4WQ/aVcXUzWLgEIu6QXw/lMB49TMrYYILJ562Bh2PwzLBjXCAKiHXSymxQ+bf4fqVITQH4Roa/2LczuGwLjMpgen3pnrK1CAxHtsDoR3yK+U0iE+xbWv5aepe+abTgbMi+XCbOIlVgg6LGemOnBd6O//rcMn/nIkzx4iKZJ4l+PHB1AP+4YgAIqkRMT/+3IFZ+Rju7SyiVzoSuoRIBcQkzEnw09+ZqBRqeKQ6bNwptToohslWK6INGSQQlrgx+4O8wJs7WjII9CJ23jV29Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8239.namprd11.prod.outlook.com (2603:10b6:610:156::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.29; Wed, 1 May
 2024 16:54:10 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.023; Wed, 1 May 2024
 16:54:10 +0000
Message-ID: <399cec29-ddf4-4dd5-a34b-ffec72cbfa26@intel.com>
Date: Wed, 1 May 2024 09:54:07 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: Chao Gao <chao.gao@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <erdemaktas@google.com>, Sean Christopherson
	<seanjc@google.com>, Sagi Shahar <sagis@google.com>, Kai Huang
	<kai.huang@intel.com>, <chen.bo@intel.com>, <hang.yuan@intel.com>,
	<tina.zhang@intel.com>, <isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
 <Zgoz0sizgEZhnQ98@chao-email>
 <20240403184216.GJ2444378@ls.amr.corp.intel.com>
 <43cbaf90-7af3-4742-97b7-2ea587b16174@intel.com>
 <20240501155620.GA13783@ls.amr.corp.intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240501155620.GA13783@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0070.namprd04.prod.outlook.com
 (2603:10b6:303:6b::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fdaa096-28e2-4003-1e4b-08dc69ff52c6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUR5Y1R4bjJOZUwrcWZvVmlyRkNIRjBtenVxYkdYRlVnR00rb0FJYWFPRnlh?=
 =?utf-8?B?NENiWlc5MkdtUjZrRnM0c3RRc0pmM0QyZWtjTmdVNkQ0c0ZER2VicW45MUMx?=
 =?utf-8?B?b21lbGVyNzlIVDVpelRJRktDUU5pcEZaMjkrVVlHWWRTZzVjazd4M0UzM1Ru?=
 =?utf-8?B?SENFNTVFaURXbUZKa2FmZCtnajNjYnZoVUNYdzRKNVVCQStsRkltVEUzblBZ?=
 =?utf-8?B?clhOUzJIYnBlVHpDVHJqK2p0NTN3ejdQREVNb25oMnZqMW9yQ3lCczc2NGd6?=
 =?utf-8?B?Y1g3ZVpBcmloSEJpeXJXbXp0Zk9aZmxSQzZ6dmR4YVRISThPTVpFcjdWNWhP?=
 =?utf-8?B?ZElWT3dZKzhMdDU5aGNLYlB5MjhIQVVFQzZ4L1lJM2J2bEovOW4zNXI0NXhR?=
 =?utf-8?B?eWN3Yy9GZE9wNFpTOW5nM25XdmJKdWdLdnN2K3BtTkU5Ny8ybDRHNGpGRnlv?=
 =?utf-8?B?L2dQODJaSFMrenY3WEtVVERXUUJaZ0lyc2xFR2UwM0dtdkJyRmZCL0RpR1hE?=
 =?utf-8?B?TkRUWFFMemwxcnVoVE5Ec0p2VHZCNHpDSXBHT0t4T0JkUWpuSjlRMm9HSkVC?=
 =?utf-8?B?QmJWOWpRRUhxK1JmWDB6UHpnbGJOY1VmZnhVOURReWM1UDA3SUgrYnR5dmtU?=
 =?utf-8?B?Z2JFRTFUUTBwMElnaFd2RklSbXBlVDNDb08zUzAwQllTWUgyYjNmNkk3T0RE?=
 =?utf-8?B?Y3VRL092STB0VmxUSTFvb2g2aVBtSWkxWHlTOEkyRDR1Y2hOakZNV1lGbUpx?=
 =?utf-8?B?WVNJWTFTNkNRdkJuVUtGTGFSKzZaOVdkd3NUazhVb0pYUlQvc1J3MVJaSEdi?=
 =?utf-8?B?WDYzd0gwYVExb1Q4OURRVG4xcmpLM2VaQy9uNXBSa2NLWXpsL1FQRDRZbGFR?=
 =?utf-8?B?dXpTRm9MT09xbVptQWRoWXZwSkt0WTFYcFlFM3JRbitDdi80R0QzRjQxYmx1?=
 =?utf-8?B?UkNEb0hIRGMzcXpESnNPMHRMOG5ocmRtTEc0QWxyeFlLbFhBRHM4clVtcFZk?=
 =?utf-8?B?ZldwYittWE9KRUE3WEJZemRJR3Q4bERMODB0R3dQOVlNVW4yZkJRQXA1eGE0?=
 =?utf-8?B?MjRKR1h5d1hHTnNMRC9YUHVqNmVOY21qRVltN3FRUTIvS2wwbmQ4WE5ySXd2?=
 =?utf-8?B?UEZ4M0puMUQzRGZKZ2lqdUxOdHVob01OSThZTFpyZzNLb2tDNUNGV0I1KzRh?=
 =?utf-8?B?TDd1OFlvYXNMMmp2MmZ2ZDg0cGcvMDJJdDR4R2ZNL3VHZk1zMkUvclhFejdv?=
 =?utf-8?B?M2tJamltZ014S0s5dWhQRWZLZkRPR1REZk84QjIyZjEzdzZISllYekliSDl2?=
 =?utf-8?B?dXdOVDB5Tjh3SGV6QTYwUWhqSjV5bElGYTZkdVFuT1FuK0FKdDBFS011UkJX?=
 =?utf-8?B?Z1VWYXAxRUxzNEhjd1FaVy95bTNGZWd4STNGRzh2YWtnZ1FNRXRCdkRlQ0NT?=
 =?utf-8?B?dW53UGlsUjAzck5GZmdReVZSaFVCc2JqV2tncGhKYlpacEpuUkkwMzIwdDVP?=
 =?utf-8?B?OEFXdCtGMTRSOFZhRHh0c3NtZ0NOMFk4dy85ZGd0Zk5rQTZkWUJaMVRXbnV2?=
 =?utf-8?B?cDZTZXVrcGVNT0UvL1doQUVjSEZLRXV1d2Z3eEJLSGt6U3F4SEFOK1dzM1Vz?=
 =?utf-8?Q?IUo0T4gQylUxT3IbBTF8ruJijvPH8B74eoCYYt9cP5DY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1h5aVAwNTdQbXBuY2tOczQ4Zi9WalRXemprSGlETkFBeVhYSUsxVGM4VDEx?=
 =?utf-8?B?NUpxaUk0NG9Nc1djSUp6bWVyM0hlQldsMGF4ZEx0a2tseTBDOTNqZWFnU2o3?=
 =?utf-8?B?SEJOdERzbzhKc2c4VkRxSVhQQ0VBaXhiR09LZE5lSU9aMWZYWnFWQ29Oekt1?=
 =?utf-8?B?b3RBdHZvaElmZXRJZXdSOXhnc1JtTXJjTzFqTlBnVU9RSUtoZ2Q4bXBpd0Zh?=
 =?utf-8?B?a3BybHJKSlpoZ1JBTDhrTDZBZmtRSXB6UkZ1WFFucUdiZkhpN0NvU044cWxV?=
 =?utf-8?B?Ymp4MlcwMVBVM3FLbHFDZjJGWi9SRU12UE5ubWxaVURBeFZ1OHdsN05aYlRT?=
 =?utf-8?B?bWdTWXNjaEwyZ1Z6Tlpibk5FTGlBRmxWb2luNGF2cVZqZHY5a3ZFcUZsSjZS?=
 =?utf-8?B?V2xYOGFpVEpPVmtHenF0bG5JS2J5c1NFU1NNczlnMW1HeVZIVVFoRWx5NjJy?=
 =?utf-8?B?RlI0bFY2N0k3TW9KVnFxMTJuTjZoaDBPTTRHRFovTGFpVjZOakprWlMrM1hF?=
 =?utf-8?B?MUoxa1pNdlVJWUExd0VvVnpVUFlhMGlMV2pmUkhFWUpXTXVvcFVmQmVLQktC?=
 =?utf-8?B?RWsvcHo0MUZmUExpMFU4dnNpWVMvNkJNcUtrOHE5bWVDdUdkeVplSnBoYjA1?=
 =?utf-8?B?R0lHRkU0bWVNaHM2TmVhSmhWUHBzcFJ3UDh4dDFNVnprZmRLbU14d0N2ZkNQ?=
 =?utf-8?B?K0VQR2RBTUZJWEFLVHZ1cGpMcm96NThQeUlnbUlNRUxxMGVCWmVaNlVSaWFZ?=
 =?utf-8?B?eVp5SythWW1WRHlacjZqc0UxcmhOWXFDSTA0eVk3SWZGZThQd2diNWo0Rzdr?=
 =?utf-8?B?b2hUNFpuMGQ1RmVRNndTckNPak9HYXdmbjEra1BpaEJQa2ZST1NPb3VEYWxT?=
 =?utf-8?B?NWlmQnIyUTVxMGUwZHJGVkV2Ri9ScUtYY0hERUVuamFnN2ZQS1BLTWJPRGtT?=
 =?utf-8?B?ejVDKzRFb1F3dk5MY3JKS1JuMjNUTS8xdi8xcTVzY2RHK1NKckJOQ05GUXVT?=
 =?utf-8?B?ZkY1aVFyR0k4N1BuOGdibzJpWjVpK1gvT1RQMi9ZbEdGQ2dMUk5kQ0RvaHkr?=
 =?utf-8?B?dTdTY0U4a3RTVDZvOG9jUkdMQWp3WnYrWVVicmU4UlhNOGxxVmR0bUwxNVp2?=
 =?utf-8?B?dTRFMXBSTjVNQml2ZG1paE9WZWlTOWhjbTlTdzBIamo3VnJRay92VENQNVo4?=
 =?utf-8?B?Skkxa0ZvQTBnWCtBcnFmb1hPamxuOGNDSGRZL2NWNjZvNXZuOFhZQWlmbkox?=
 =?utf-8?B?NTBhNGsxa2FOVm02NG1XcUpadkt5ZndsbHhHZkRwc0hSTVhDV3JyVlVLU2Na?=
 =?utf-8?B?blFMczRkZnFtejVzemI1TTFKRzV6NHlIVEZWNlZPelJyTWlqK0dQWHprdkFT?=
 =?utf-8?B?VC84RnBMakUwVGUzOFJ3bmMyQmxYOFJidERBTmNkOEQ3WUJ1QzBTUGhuWDJY?=
 =?utf-8?B?NzJDekpMKzFkR29veWRzWVhpUSt6WE5MOE5aR2I3bC9LRUl4RE9yWnY4Vmor?=
 =?utf-8?B?UldmMW1Pall0WEZLOTQ0andteWRyNk9mc0hrN01qTVdQcVp5ckFxMHJaY2pP?=
 =?utf-8?B?NFpzRnFoWkFGTlBydlZQaTNxRDlCeVNuMWVJTEZCbWI4WHBCbS90VGl5VlAy?=
 =?utf-8?B?YUVybEYwVE5uZjJ1TUl0RlhLT2Y2U2sxb1ovTXlXVElQUXJZd2VKMWh6a09Y?=
 =?utf-8?B?UCt0SDVBWFhPdFVtTjhsVGhMcGJPbmorTVJvSEpkYWhwVkJoOE5memVhV0xB?=
 =?utf-8?B?RXJacDNrQzhVTGhMN3RsVTBSQStLTFc5MGFMUnVHQkxxVHlnSHlxK2U0Ti8y?=
 =?utf-8?B?SWZZdmJlY2xLSUdHMFU2bVNZbkNNdW8zTWo2Q3BZWnVPdEdLNzM2aTY0aDNz?=
 =?utf-8?B?RDlrK1FuQ1VIR2llT04zcmZSMTNRZDd2WHNTdlk3L251am1zV3hDVjNXcHVH?=
 =?utf-8?B?YmhSbW5aRDZnNVorcGJLejIyVS9Ib2MrOUg0bytQOUQrVVQrdkVOMHFodGFn?=
 =?utf-8?B?eVA2Wk5sMFU5VmhxV2RUU29EcnhCQk9FVUZUU05pTURmZ09rYisva3NRc0xm?=
 =?utf-8?B?c05kdWlqKzVYMTZrOC9KZmZiNGFGazRGcEl5bGlLOWRhL2g2bVg0NFkzM1Vr?=
 =?utf-8?B?ZmpNRythM2xaREFxelNqaHQzUFJDc0VaZk1xTWNvWlpKcGN6Y3RIY0RqdGtX?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fdaa096-28e2-4003-1e4b-08dc69ff52c6
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2024 16:54:10.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SFqQf1cWE/pFXc3h2k9oK1S376fsuWq4NxwEiQtNo1xXNWPeBV6UGhbrvjcFMTBxNnB13F59BbrSW4ypqYk8MGdirN7rIH7pFcMSnpCEAkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8239
X-OriginatorOrg: intel.com

Hi Isaku,

On 5/1/2024 8:56 AM, Isaku Yamahata wrote:
> On Tue, Apr 30, 2024 at 01:47:07PM -0700,
> Reinette Chatre <reinette.chatre@intel.com> wrote:
>> On 4/3/2024 11:42 AM, Isaku Yamahata wrote:
>>> On Mon, Apr 01, 2024 at 12:10:58PM +0800,
>>> Chao Gao <chao.gao@intel.com> wrote:
>>>
>>>>> +static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>>>>> +{
>>>>> +	unsigned long exit_qual;
>>>>> +
>>>>> +	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
>>>>> +		/*
>>>>> +		 * Always treat SEPT violations as write faults.  Ignore the
>>>>> +		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
>>>>> +		 * TD private pages are always RWX in the SEPT tables,
>>>>> +		 * i.e. they're always mapped writable.  Just as importantly,
>>>>> +		 * treating SEPT violations as write faults is necessary to
>>>>> +		 * avoid COW allocations, which will cause TDAUGPAGE failures
>>>>> +		 * due to aliasing a single HPA to multiple GPAs.
>>>>> +		 */
>>>>> +#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
>>>>> +		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
>>>>> +	} else {
>>>>> +		exit_qual = tdexit_exit_qual(vcpu);
>>>>> +		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
>>>>
>>>> Unless the CPU has a bug, instruction fetch in TD from shared memory causes a
>>>> #PF. I think you can add a comment for this.
>>>
>>> Yes.
>>>
>>>
>>>> Maybe KVM_BUG_ON() is more appropriate as it signifies a potential bug.
>>>
>>> Bug of what component? CPU. If so, I think KVM_EXIT_INTERNAL_ERROR +
>>> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON is more appropriate.
>>>
>>
>> Is below what you have in mind?
> 
> Yes. data[0] should be the raw value of exit reason if possible.
> data[2] should be exit_qual.  Hmm, I don't find document on data[] for

Did you perhaps intend to write "data[1] should be exit_qual" or would you
like to see ndata = 3? I followed existing usages, for example [1] and [2],
that have ndata = 2 with "data[1] = vcpu->arch.last_vmentry_cpu".

> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON.
> Qemu doesn't assumt ndata = 2. Just report all data within ndata.

I am not sure I interpreted your response correctly so I share one possible
snippet below as I interpret it. Could you please check where I misinterpreted
you? I could also make ndata = 3 to break the existing custom and add
"data[2] = vcpu->arch.last_vmentry_cpu" to match existing pattern. What do you
think?

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 499c6cd9633f..ba81e6f68c97 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1305,11 +1305,20 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
 	} else {
 		exit_qual = tdexit_exit_qual(vcpu);
 		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
+			union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
+
+			/*
+			 * Instruction fetch in TD from shared memory
+			 * causes a #PF.
+			 */
 			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
 				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
-			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
-			vcpu->run->ex.exception = PF_VECTOR;
-			vcpu->run->ex.error_code = exit_qual;
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+				KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+			vcpu->run->internal.ndata = 2;
+			vcpu->run->internal.data[0] = exit_reason.full;
+			vcpu->run->internal.data[1] = exit_qual;
 			return 0;
 		}
 	}

Reinette

[1] https://github.com/kvm-x86/linux/blob/next/arch/x86/kvm/vmx/vmx.c#L6587
[2] https://github.com/kvm-x86/linux/blob/next/arch/x86/kvm/svm/svm.c#L3436

