Return-Path: <kvm+bounces-41483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C778BA68B94
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 12:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42221188ABE5
	for <lists+kvm@lfdr.de>; Wed, 19 Mar 2025 11:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3569255E44;
	Wed, 19 Mar 2025 11:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MabM3BSG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CB3253351
	for <kvm@vger.kernel.org>; Wed, 19 Mar 2025 11:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742383401; cv=fail; b=VKdgAbtyB936CUbT4wHNJuJQE6gsQRhqECyBsi/HIm3VNULssd7mzRst09etLx1zfCHSiofJ5ld3r/7TXYTyib+2AgKT21Erih4BD791XvqolQ6b7dUnedy5bTneKm9wYTCVfjpyw0HcAzeevDLgvNDVIgXhr/15nXMJuYFqwD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742383401; c=relaxed/simple;
	bh=U0FopiRTuGlUiRAtRzk0SomA4k5B4g/JpqUYKUpRMWM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tiRh7/fR0nmSFAKm5MY9dSZeAluKiAmM/unzJIDhKawJT6MtpMr5QBvZQyZXwl3Sf/oD0Ar4SFidAlp+zJefnvICq2sdgQENTqr4eE4ZBRA5HX83piqLt8xtYNBUPVc7I1+Vkjste9k8Ju38o9aZ8yTo/7K9mxNi23xRGfCUmJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MabM3BSG; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742383400; x=1773919400;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U0FopiRTuGlUiRAtRzk0SomA4k5B4g/JpqUYKUpRMWM=;
  b=MabM3BSGLDLLjU8hklD1CJ1i3eTn9sceVCpeiI5qZL6Mccjh3agkBeCa
   MqjLHJ9zPu4Vfu543OWaWd0IyikCzuBrn3NgtqHG7vYeQZnnFlFAs0WiO
   N1sy/TSoaCmMUIYhLpvLKkKuGDw6hw+oN0pixeb4Ddyl4exw3Bt+cLwBX
   i4g+siaHt3zcdcKGVxgq/uA93Ku1ss/UhWwhQ/VxConsNjkPKxrzG/VEn
   JP/f4EA1PjzqaG1LL/ApmcEE21xITSeji5zNm4HIvzhiSGyzPaQjdX71B
   0wf5o1zNEZYUt2UbWUt3ZyaT1Z62O9wEs9y0umtlJqXjN2MBQbFJZNDSJ
   g==;
X-CSE-ConnectionGUID: 1BzG2u+NQ2uIA7/9pBPISQ==
X-CSE-MsgGUID: zB6j8fBeTTW0u4TkvpFS0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11377"; a="42738871"
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="42738871"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2025 04:23:19 -0700
X-CSE-ConnectionGUID: XZyoBefcSEWM/XcYT94X5w==
X-CSE-MsgGUID: nFmABuUHSDmKAV6fp/1iqw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,259,1736841600"; 
   d="scan'208";a="145769801"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2025 04:23:19 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Mar 2025 04:23:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Mar 2025 04:23:18 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Mar 2025 04:23:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rWmn+OjQWcsIrevlkqm0YccAaL8GR+jFadWWZflwbSusYQQu3XZXTlhjLiG72EoOtT9BVxz/R0mqNnNSbttKEWfMCzH9kbH9LM8MhHJeOjGJH6zhhrsxWC9JRaFo5qSyoJh9hNunT+zy/gw6zckQ+IAUr2tj5VuaReRKK+t+SK8RE8JrAHMD0rwcAtNTQL2xbFdR4U5THahQOPk71Q7AYCcUSlk33o4eik8cBtzvEecq8n+LY4ZxSiT7wKZuXBPUWjI0OivLKxAI6w/quh1aQ80EJ/Jb6Bgnco2lHdSXtpcEa+e5z4mZ/mW/V46M8BvjT0dNKXtrrc/9uwDeyCbzPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LdEIbveXHtmxmtfr0U/ka7cP9thXehCqCl1jwqUTin8=;
 b=hj2GtP5ZxI38kG9CKjW+snPTmpiCvXniZDBToKuFiGdvHPhu1loLeh17/1elaoTIfu+5USeCJVQ0cQXoSxietW8oJOzG1teul2ljW6EEifYs0LkI0G38Bm1YdVyr4tqyrpqiiB8VSkHW1woXVmlXALrQcB3nKFZyhQVIOKeom9JlPS4YrqoAM2cOA3XiD3mT8W1LRYGQH6hYBriyX4WePCQ4lf4S/EFW1PwwGhOjI3IEZPR/JAF68k/kbphE5rYtSEdVz8hfpUqr8XQAkIrNy3aKQlApcMmnLrBKclXCZCx45KwJJW7O+Rb84mhDrCKtClYC8wS8A2s79nHlTfdoJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
 by MW4PR11MB7080.namprd11.prod.outlook.com (2603:10b6:303:21a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Wed, 19 Mar
 2025 11:23:17 +0000
Received: from CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb]) by CYXPR11MB8729.namprd11.prod.outlook.com
 ([fe80::680a:a5bc:126d:fdfb%5]) with mapi id 15.20.8534.031; Wed, 19 Mar 2025
 11:23:17 +0000
Message-ID: <4bef4a8c-6627-4054-83dc-79d41ca03023@intel.com>
Date: Wed, 19 Mar 2025 19:23:07 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/7] memory-attribute-manager: Introduce
 MemoryAttributeManager to manage RAMBLock with guest_memfd
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-5-chenyi.qiang@intel.com>
 <2ab368b2-62ca-4163-a483-68e9d332201a@amd.com>
 <3907507d-4383-41bc-a3cb-581694f1adfa@intel.com>
 <58ad6709-b229-4223-9956-fa9474bad4a6@redhat.com>
 <5a8b453a-f3b6-4a46-9e1a-af3f0e5842df@amd.com>
 <9c05e977-119c-481b-82a2-76506c537d97@intel.com>
 <4fd73f58-ac9a-4e24-a2af-98a3cbd6b396@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <4fd73f58-ac9a-4e24-a2af-98a3cbd6b396@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0005.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::17)
 To CYXPR11MB8729.namprd11.prod.outlook.com (2603:10b6:930:dc::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CYXPR11MB8729:EE_|MW4PR11MB7080:EE_
X-MS-Office365-Filtering-Correlation-Id: c1631d29-4c0c-4310-b472-08dd66d871dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RlMzYmVNNm43R2JIQWJoUWpwaVJlRG4rME9WQVVrdjZqRUJLUnJ1ZnZIeWNI?=
 =?utf-8?B?Qm5BK2hCOHVMYWljOFJBcXpxQzlNbU5ZZFVITjlEb0lNd2l5VW4rWFY2QmZM?=
 =?utf-8?B?TE5NdjJvVkt6SytOaVgybkJneWF0NUlwK3ZKZ1Jsd0IwaGY0eHhwUFIzVCtK?=
 =?utf-8?B?MkRWMGtSaHdodG5uNHFQcEZ3OUdBM3dtVXRycVZXMDdlc04vRjhHVFk4dHdO?=
 =?utf-8?B?c1lWSXJ4eEZNRWhVLyt0NzVqRnRSR2NSaEhiblFGWUxPanBaU2paQmpYNFJG?=
 =?utf-8?B?Ty9SRVdsKzFHTzJ6ZGJXbmk1d1MxYWhJQkQ0eEpXZ3hmM0pteUozVGV5TTFQ?=
 =?utf-8?B?QXdtcjJSK2Y4enRVSjdOOGJyZnNEUllvNmxEUS9FWUllWGRBcFYvZ3JkbFha?=
 =?utf-8?B?ejBUdS9uRmxGNHBaUUpmeGJvYTZJaXJxL05FdCtmR3ZWbFBEbWVrLzV3c2hr?=
 =?utf-8?B?NVJKNHgyREpZM01TTGt5VDVIODM3eXVkQ0tHY1RmZUlhcjlWYzJwNit0QlRo?=
 =?utf-8?B?OEdoU3luZDdQdHlFTWtBMnRWNExnRzVvWFNCL0YxVDdBT2Mzam5oK2JGcE1T?=
 =?utf-8?B?U2JWTGJaQnV1bDhpV2xGTFhBNk5nR2ZFZXhpTVFmWjJjWmFxeG40MUI0MWJN?=
 =?utf-8?B?cGdzWVptZjk1K2d0eTVEWmpwUTRXNkpTMkk3OG9lOWEvYUxQYVRHQnBaZzlm?=
 =?utf-8?B?Wnc5eUhXK1A2UDBmVWJRNENvL1UzWlpBZDhCa1BPUkMyeDNwYUQvbTkyMzNQ?=
 =?utf-8?B?NnErblo0emVzNWV6U2UzM1FKN01ZajhQNDhpd0o3dEtqdHlBYUNidldBS3RN?=
 =?utf-8?B?SWNpY0hITiszNG44dTl3NnJZYm40NXoyWG80clFGU3pNdWdVVXB6WkQ0QVh1?=
 =?utf-8?B?WDd0TGh1NFlpZDEySW51TXovcGdMRHpTWjhZMkhUa3hsUFgrd1R5VWwxN2tw?=
 =?utf-8?B?czZvNXh3NVV0Znp6VEFidnl1NkpxV2FtSis4M0EvL09CZCtxd3R3QnNCTEpp?=
 =?utf-8?B?bElZbHNMa3ZxTVBWdnNDeDJpenBPODM4UjdSdkdwSHQ3UjZhM3psZHZMTUk1?=
 =?utf-8?B?K0htc1RseWxwR3FYRjBOYmRad2VFV1pFL3pWUDJ6a3RmbHJhOERsWW1iYm83?=
 =?utf-8?B?OEhXakNBeHIxdHJmSTV4Q3FpMlFKbjBOaW9oMGUzOUZ0SDg2TnFVRUZXVTAx?=
 =?utf-8?B?TGhTY0F4Qk5QZE1TdFFMMFpmZ2VpbG0rNlllQVJsTXVySEVwNmFvUGRJa3ZE?=
 =?utf-8?B?L3ZaN3RmaXhyeldwODBFUGloTXVjd052K0Q1TzBVcXlySkNPT1N2U2VoNFVD?=
 =?utf-8?B?QW9Tc1ZpNGZjalEyckozVnlOTkRIWjZoUmpiMlZGKy9kaGNsZHdkVlYwZHpi?=
 =?utf-8?B?OGxZVW1Cb3oxMFNGUVRrQjV1cE81UDZSMHY5UEkrV0t4bDdYOHVvaGwwWWtR?=
 =?utf-8?B?L0ErdWhBdmlma0pYUzFSeHJHZG9pc3FOQ2xnZHdFV1BJdGdYRTVQWFJHRngx?=
 =?utf-8?B?aU9DdkdSM2dOMWVwc1BFTE9EUXM2Zm96RkJZeHpzWEhvZm1Qclo4N0dzSmc1?=
 =?utf-8?B?NTBvTndqWTJoQ3Q5NlNaTXdROGF1V1JoM2dwMFZlTFFWU2Z0VFptNVdXOG9u?=
 =?utf-8?B?NVlIaVljMFdGUTViNHp1ekpMNmRXSGtkVUlwZFU2bU1uUStJTnJpZ2hoTHVh?=
 =?utf-8?B?SlZzOGJMc1dYNW5HY3BNRVFTYjkxK0xDeHFFcmw1OHo5ZzJGSExTV3BKd2Jn?=
 =?utf-8?B?WE9MbFFmb2VGQWtJdzRocmRiQURNN3BURmVsUEhEZGhzSHZvZm1VYmxzWW40?=
 =?utf-8?B?aCt0aXE1SVh5RmVjb3hlUy82U003MFluS2tmdG13ckZSVWZSK21QMk9oZkQ5?=
 =?utf-8?Q?j+CkuV90nfhig?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CYXPR11MB8729.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cU9iMEFkdWRETWJUMWtNWHpjVXRTZ2FrYVhRZjRDVkVWN1E4aWE1MGd5SUtV?=
 =?utf-8?B?Q21OZ3VNeHNSMUtYZGg3dm92UFpzMFB5d2d1MzdqckFHZ1daNjkzWlB1bGxC?=
 =?utf-8?B?elMzaitEU05JeDNETHNRdXdWTXlWYXJsSmJDTkttT1hJMjd2MkRsMU1OMjhh?=
 =?utf-8?B?bTg4eDhaVWpnZ1MvZWRSMDR4enJ0Y0J4bit6R2JYN3V6aUgxVUgxblFsSTl6?=
 =?utf-8?B?eUxVOWFOV1VqUUdsK0QrQWRJMm9IRUdNeWJnZHVFNlJEMnl6UlZ0ODFObTI2?=
 =?utf-8?B?b1pBVlVRVzZZRWRuSHF3cVlvVkdGK1k2Sks0dzM3d0hNWG5LMks2dzNNQU5X?=
 =?utf-8?B?NWpTMS9mT0dpSncvVXpVYWtRTjlPU1Y2UHdjazhKQWNtUVkyN0xZTnFSWllt?=
 =?utf-8?B?eWs5M2ROck9DcTRhTlRCUEwvZUJOMFEvUjRVMEM3dzNheHNiT2gxQk9GR05p?=
 =?utf-8?B?b29Zb1k1akxlZjM5RTdUQ1l5VFhWb1BaVDAzclVhTWxhTmpsa0FlVHZsbm5S?=
 =?utf-8?B?cDVlUDdnUWtadDJWNEd5Z2ZWWUVwcDIySXJROWo0NWx1dnQ5UFVLcjR1NDdz?=
 =?utf-8?B?c1BIakFlTFZkOUR6L1UwUm9pbFdMY05sRzYzV2xIK0VvRlBJMGoyU1MwejhZ?=
 =?utf-8?B?Q2NJZjZ3ejJVdVF4VDl5YnpqcTJmV2NNZWZRVllxbFZFNy83eGpBRzB6cnhS?=
 =?utf-8?B?V09ZT1NIMVpHWXA0K21XM01YOWtJVGNzTS9ub0RaL2xmQlNzQUNuTmNCOThk?=
 =?utf-8?B?dU1Ka0hIanpiTVBYZW5hamlFS0hGUGxXa29TWHZINDVXV0wrTU5abjFucCsr?=
 =?utf-8?B?L1p2RGtlaitLVCtHVXVEcjRwNGxXSUNWamE3aXUvcWRUZmVnd0J6TWNmbDBl?=
 =?utf-8?B?Z2l5WDZTaWNzWk9yYVlKOTk5eERkMkF1UDFiZUtRbi9IQk1aY2hxblk0WnNY?=
 =?utf-8?B?a2g4S2Nid3NieG9jWURUMGoxeUhFTjBuRzVTOWpoajlndUZMelMvaVJKWklh?=
 =?utf-8?B?UEZzRzA4VjRGOG9mT3J0Tm1wVkRIN1VRN2JydTIwS1RKdWR1YzlFWXlISDhY?=
 =?utf-8?B?a2tKaWgwY21vM0dBam9DUlR1TnpPUHBKMzRuOHRubzhFcFFJUU5VdmVVTVY0?=
 =?utf-8?B?aWlIaE1IL0NkWmI5Z0lTbDhkWDlNL0xUYjFVU2VyNjJJMUtSdkJEU1RBb2E0?=
 =?utf-8?B?N3lvbS9hNzN6Z3c4QXVjd0luWWZGTjJqLzdoTUZYQmIvT1NuYXpRZElUQzZ2?=
 =?utf-8?B?RGt5RUhTRWdiMjF0cXl0WDdaZVEvWTI0SGdhK1dDWUx6UkVNY0dlbjEyOThJ?=
 =?utf-8?B?SFU2VVg5YTVnSlkwQVg5aDRUOWxlNkhBMDhSM0RCVEc3Q1p0QUgwR2JnU0ZB?=
 =?utf-8?B?d0NaSEUvVlE4ZXFtSFhSalZWOFloRXdYcmp6K2VvbkR5ZXZQUTZDbklXU0do?=
 =?utf-8?B?NDRZZVZrWmRUeFBuUXNmNC9jU0g0c3F4NEU5Nm5TZEdxaG52N2c5UlMrem5z?=
 =?utf-8?B?QTJPaTM5OFVLR1N1T0FRWGozOGtDc0drcEVnaE1IblNvWGsrZU5PZ2Q0SGZq?=
 =?utf-8?B?NEw3UEpObm53ZW1taHRNSFh4dnlycFBlRUgxZGh6TWNQeUZ2VTJuaUJZcHFU?=
 =?utf-8?B?dEY5NVhpSERtT29VeHIxSmJIOS96RjJrekdxQWl6QkUyQXFUVmdrK3BaMnRJ?=
 =?utf-8?B?RXNTZzJOREpBS252eUxlNHozMFJWR2lzOXFzVW9Jcy9FK280UnR2M1ViUG1L?=
 =?utf-8?B?R2NIZ3pLTWFsd29zMWR4dHp0cTQ1dFYxaWRDYlBwL1pCazU1dnUwYkllRmVY?=
 =?utf-8?B?UFkzMGtVci84VllycDFIdGxmZzJpc0Jlb3pJSWI0ZGtydHZ3dHlMZlBUUUhX?=
 =?utf-8?B?MXYzdEVNNlNjTEMvL205NzkvV1F0MEhBbHhpSDhwZlcyOWtQUVpGWjdxNmZk?=
 =?utf-8?B?cVVhVTdCTVR0VG5HaHNNc1QwTlI5dysvdTZ0Mit4dFJOZlJnb253Tmc5OGlI?=
 =?utf-8?B?dUpqWlB5bnI5TWszZ3krMDl5ZWQxNVNhOVN2MVNPREcxWHcwSUpOdExaSU9B?=
 =?utf-8?B?NzB6b04wNWYxeHVqd05VaEdkeVV1bjNvMmpjekpCOXN4U1RrempPNWJ2TnlH?=
 =?utf-8?B?TjYyMTM3MkdObVBCd1VmRjcwd3NWeVRFTDZja1pPU1YzdXA4ckRONlFiczlN?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1631d29-4c0c-4310-b472-08dd66d871dd
X-MS-Exchange-CrossTenant-AuthSource: CYXPR11MB8729.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2025 11:23:16.9532
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMIDEl3Q2JuenDBofMF8TlYy7GAeSXfdikJsyyg4DBS20QJCWhrFtW+CYEdGidellSUu4YH5+j94TxOOUl+CIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7080
X-OriginatorOrg: intel.com



On 3/19/2025 4:55 PM, Gupta, Pankaj wrote:
> 
>>>>>>> As the commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>> uncoordinated discard") highlighted, some subsystems like VFIO may
>>>>>>> disable ram block discard. However, guest_memfd relies on the
>>>>>>> discard
>>>>>>> operation to perform page conversion between private and shared
>>>>>>> memory.
>>>>>>> This can lead to stale IOMMU mapping issue when assigning a hardware
>>>>>>> device to a confidential VM via shared memory. To address this,
>>>>>>> it is
>>>>>>> crucial to ensure systems like VFIO refresh its IOMMU mappings.
>>>>>>>
>>>>>>> RamDiscardManager is an existing concept (used by virtio-mem) to
>>>>>>> adjust
>>>>>>> VFIO mappings in relation to VM page assignment. Effectively page
>>>>>>> conversion is similar to hot-removing a page in one mode and
>>>>>>> adding it
>>>>>>> back in the other. Therefore, similar actions are required for page
>>>>>>> conversion events. Introduce the RamDiscardManager to guest_memfd to
>>>>>>> facilitate this process.
>>>>>>>
>>>>>>> Since guest_memfd is not an object, it cannot directly implement the
>>>>>>> RamDiscardManager interface. One potential attempt is to implement
>>>>>>> it in
>>>>>>> HostMemoryBackend. This is not appropriate because guest_memfd is
>>>>>>> per
>>>>>>> RAMBlock. Some RAMBlocks have a memory backend but others do not. In
>>>>>>> particular, the ones like virtual BIOS calling
>>>>>>> memory_region_init_ram_guest_memfd() do not.
>>>>>>>
>>>>>>> To manage the RAMBlocks with guest_memfd, define a new object named
>>>>>>> MemoryAttributeManager to implement the RamDiscardManager
>>>>>>> interface. The
>>>>>>
>>>>>> Isn't this should be the other way around. 'MemoryAttributeManager'
>>>>>> should be an interface and RamDiscardManager a type of it, an
>>>>>> implementation?
>>>>>
>>>>> We want to use 'MemoryAttributeManager' to represent RAMBlock to
>>>>> implement the RamDiscardManager interface callbacks because
>>>>> RAMBlock is
>>>>> not an object. It includes some metadata of guest_memfd like
>>>>> shared_bitmap at the same time.
>>>>>
>>>>> I can't get it that make 'MemoryAttributeManager' an interface and
>>>>> RamDiscardManager a type of it. Can you elaborate it a little bit? I
>>>>> think at least we need someone to implement the RamDiscardManager
>>>>> interface.
>>>>
>>>> shared <-> private is translated (abstracted) to "populated <->
>>>> discarded", which makes sense. The other way around would be wrong.
>>>>
>>>> It's going to be interesting once we have more logical states, for
>>>> example supporting virtio-mem for confidential VMs.
>>>>
>>>> Then we'd have "shared+populated, private+populated, shared+discard,
>>>> private+discarded". Not sure if this could simply be achieved by
>>>> allowing multiple RamDiscardManager that are effectively chained, or
>>>> if we'd want a different interface.
>>>
>>> Exactly! In any case generic manager (parent class) would make more
>>> sense that can work on different operations/states implemented in child
>>> classes (can be chained as well).
>>
>> Ah, we are talking about the generic state management. Sorry for my slow
>> reaction.
>>
>> So we need to
>> 1. Define a generic manager Interface, e.g.
>> MemoryStateManager/GenericStateManager.
>> 2. Make RamDiscardManager the child of MemoryStateManager which manages
>> the state of populated and discarded.
>> 3. Define a new child manager Interface PrivateSharedManager which
>> manages the state of private and shared.
>> 4. Define a new object ConfidentialMemoryAttribute to implement the
>> PrivateSharedManager interface.
>> (Welcome to rename the above Interface/Object)
>>
>> Is my understanding correct?
> 
> Yes, in that direction. Where 'RamDiscardManager' &
> 'PrivateSharedManager' are both child of 'GenericStateManager'.
> 
> Depending on listeners registered, corresponding handlers can be called.

Yes, it would be more generic and future extensive.

Do we need to add this framework change directly? Or keep the current
structure (abstract private/shared as discard/populated) and add the
generic manager until the real case like virtio-mem for confidential VMs.

> 
> Best regards,
> Pankaj
> 


