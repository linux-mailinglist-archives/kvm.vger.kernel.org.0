Return-Path: <kvm+bounces-21470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2423792F55C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 08:10:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D56B1F231A2
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 06:10:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA5313D50A;
	Fri, 12 Jul 2024 06:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FhvIiZ53"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B1F13B297;
	Fri, 12 Jul 2024 06:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720764623; cv=fail; b=i3BYt3LMN2bwnPpCMcEkoAjVVGp307pfqbnxsw2FU5oIiExHs7WANDkIIvj7iI3es+NLvoNP+hP/IBFl/tbADf7LsTlVuN/ZLTZTJ1P12lfDfmiaDhNhLnjTe1eBUpLWycKyQ2SY3OJVGZ+EcxwVPOYlKFOwc9ardFoXcW9dAlY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720764623; c=relaxed/simple;
	bh=YhzGqlkgcIsyXc42Dy4frV9B/b+H7VfGPFqgezSgqcs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qYwaJ3aL3NJ9onIIr7HemmeNEj6aFAwlO7KB9pmTNeTmNw4TA2vd78tI8rE/Ss0yrGKzVgKCs5JQ2+mDg6genY6hRmpYrTgzi3VtWHPqe7bNIMSGiMNy0QLbPD38fnWHWFWmlRR+HMD8lj7i5CyBiw4hfvM/VJQHtE6KRSp69NM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FhvIiZ53; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720764622; x=1752300622;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YhzGqlkgcIsyXc42Dy4frV9B/b+H7VfGPFqgezSgqcs=;
  b=FhvIiZ53ox4iAPnvAwig6wUuetZ1QExQyx92KZ42cyGVaYA22Dc20th0
   0456NZqs4l4v5jYmJsJQmq2lswKMokbU76j7JOA6/RHtSSEkC9PF3iXgh
   piucAPm6OTpsSmyhBKZ0wwiIrUL7OmSULYWtvkh/IsDN2GhA1pNfxwfT7
   G3vIRShxzJddEFCrsLXwA09rrf8gJcrCwBi5ZtxcDMij+HcbvuzLUCiGN
   xxT51h/XBvrALqV4/zKUY77gdNfDO9hMzG9joudcNf/LvlGv15c/dlkzw
   /VZ7kHajyGPdj9i78BGz+v8y2Zagp4f5PR5djf+kNKsU7ZwdKPmV/TiYP
   w==;
X-CSE-ConnectionGUID: QoyRD39HTUmzcRfVseZ02Q==
X-CSE-MsgGUID: uihq7njDS5iBhH2fjZKtng==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="18307468"
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="18307468"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 23:10:20 -0700
X-CSE-ConnectionGUID: ZXfseKtrQT+PhXyicRUlBA==
X-CSE-MsgGUID: 1PJ0q0WdR8SA2zu8k8psLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="48565398"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 23:10:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 23:10:19 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 23:10:18 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 23:10:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 23:10:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RVMygD1Bo6MMu/yNWhDzvbt5Yvypr+UjawB7jc15nRa0bQtvvmMz3FL8T4SjRAGU0VkM+V01AEHoEmtBsKdIJuBmLJ+eUUEqIaX9r2HW8OM5h4fgdyXC+2GqE1owTYuXvrJ5vl+iuVhNP96zCoPcR8acNgqGxxVVuFF2eVCZnh3fTbnbRSYPdrFhMv99HDXf/bf3mqzwEy8nbIOioc4M6hAPx8BvgTudCmhsKP5NNVUh6la3/CUkvROF6fOXIjtWbrylwMsFFhq/fZtmru4vuYoTNO6U9kNSelcrRESNsvaWEx7H12Gr9YTod6wueK9h04m/nAzIqoZb7aZ2dsYxcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ATyRSeclUJd6c7pX5iotcmKmjCQAP9wttW+sNIMrwT4=;
 b=SCFXZMbHcv/RNpxyx+z3/U8RDvU4QWWZ4G/GqmM4XwKIgm2E0n5R8srWDGa4RbxH0mIG+rbAZETQuP7Ftfba/b7t2JI+7N9BPqB3Ksc47qtS+jHcVy8HMdlectM4r13MYUyHx6bNOHVP1iw56XldoUyRLl6JBIST64YEX3Cc2im+vxgZntIqoL2N2RijxCySMjLg7K85kSb5tTPm0AKxY4XFHiEV657UIF6a5rP828y6I0RWXL+vWzoGyHam5ng9mJyargWDLEGcTp2+Ve7tLSvrilfT3+lKZWQ1//2bmu/nk+IFmPki9kq+msSaOsnMOrKmOyC8sur03VEZ7lF+YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7540.namprd11.prod.outlook.com (2603:10b6:806:340::7)
 by MW3PR11MB4524.namprd11.prod.outlook.com (2603:10b6:303:2c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.22; Fri, 12 Jul
 2024 06:10:11 +0000
Received: from SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29]) by SN7PR11MB7540.namprd11.prod.outlook.com
 ([fe80::399f:ff7c:adb2:8d29%3]) with mapi id 15.20.7741.033; Fri, 12 Jul 2024
 06:10:11 +0000
Message-ID: <46496896-0dda-4d2b-8092-021d33e4862a@intel.com>
Date: Fri, 12 Jul 2024 14:14:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
To: Yan Zhao <yan.y.zhao@intel.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: "Tian, Kevin" <kevin.tian@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
References: <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
 <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
 <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
 <e568a45a-4e1d-4477-ac10-103cd605eff3@intel.com>
 <ZoJDFyqzGVuntt94@yzhao56-desk.sh.intel.com>
 <20240710144044.GA1482543@nvidia.com> <ZpC8zalggIyzdTFQ@yzhao56-desk>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <ZpC8zalggIyzdTFQ@yzhao56-desk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::18) To SN7PR11MB7540.namprd11.prod.outlook.com
 (2603:10b6:806:340::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7540:EE_|MW3PR11MB4524:EE_
X-MS-Office365-Filtering-Correlation-Id: 717b66ad-44c8-4bb1-24fb-08dca239497c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bTRybjVya0xsQ3RjSUpxZURmc3lqd2pxbEsyd1hZMXVSOFFYSlcwdGp2ZDFG?=
 =?utf-8?B?MzNZa2tZb0lkSHhMUHg4UC9GajFOUFBlK1VvbmxSSzdWcHYydDRqR1ViTWM4?=
 =?utf-8?B?R1pyS2lDYnh5SGdabTBKOXYwbW5ZWlVZYThzRVRETVZscWh4dHFBZTZ2QTJP?=
 =?utf-8?B?MnRpY0hLY05keklQM2ZndVRaa0ljWDkxZVN5azkzU0kyazVqK1Qwby9KOTJO?=
 =?utf-8?B?RmkzWVVEZWlJUkU3YlBNUk9XcjBNMUVNUnZJUC9zL1V4ak9sSUhpdmF5SVJm?=
 =?utf-8?B?bmFYQlA0ZmNDUzhBN3c4dEdMR0hueFMwblRlYjYxeStXSENFc3ZTSGIzY2t1?=
 =?utf-8?B?bGlkK2hEZ250bEFwNHBtSWJmRjZFNHA2YlZOTGtuRnFhZ1hOTHlJWXJ6WjVl?=
 =?utf-8?B?UXRKQ1FJTkhMQnpOK0ZFUDk4TTM3dER3eDgzRVp4RGdmWkM4QUx1V1NOL2ky?=
 =?utf-8?B?eDk0clR2aWJ0ZWJNYzBqdXdUVmV0TWxwQlBNUEYzT3ZPUHAwQUZZQVdsaUVC?=
 =?utf-8?B?cm5UVDg4OWcxMDMvcy8zT2JKcll3S252NmdwYk12SWJZYlpnTWdlNzlqa3Ns?=
 =?utf-8?B?dURwNVFCRm94YnRlamR2cWhtSzBBcHpidDNsZmUyV0VieitpMDJmQ3FCOHpx?=
 =?utf-8?B?RWRyZW9ReGFlTXNBQmRaQnF1RkowS1JKaWtlUEpjZiszb0pRbFdqNGh3dm0v?=
 =?utf-8?B?TE1ucWZRZlR0dHpLVm5wcCtQQUNYR3ZqbjZWdkFZNExSQjlQemdVZm95YXF1?=
 =?utf-8?B?VTFLV0JXVmxyc3VRcWc2bWpCREcydmtnb1hMMkZQWEdvOTdOZ05aVlNFN1g5?=
 =?utf-8?B?L1NTSmhpdEx4ZU42eTd6QWdaWUtET2l6T0NoRzAzUWVFbjFUMGRRMktsYlV5?=
 =?utf-8?B?Rk5pV2NGMFA4eHdZT3YzZDdyMVFDdUE4dlIvZFVnL1NkRFB5Q0JzVDRZNThY?=
 =?utf-8?B?N1FlWDNHZkdzRXFwQytBSVJSVHhHT09kR0Y2NUFUa1dIMWFZZUNqNVA0TVM5?=
 =?utf-8?B?cEdWL04xK0pHWndBQVIxbzYwdHpQaXdYQjlrK2d0ZStvc2pkQ3Q4UUoreTJP?=
 =?utf-8?B?USticXZRZll6Umluaml5a1hFZ3J6cVpTVlVLUkl3RTFINUVXMi9RbnlPRHFC?=
 =?utf-8?B?ZTJhYUR6SllYdEV6L3NMTEsvQWdBTXZHT2lDbDVKZmFGakhINVFlVmZTTVRG?=
 =?utf-8?B?dnZvNDU5SFZmZUMwckpjbXlycDVHZ0UxTXJOclhqcHBXME1hdWZtYTcycHRH?=
 =?utf-8?B?bWlGL2pBR3pQZnYrMndha3ZVc05WTWE5bFh1N1pHSllabi96b0ZZYnUzYmNB?=
 =?utf-8?B?VngxWW9PRC8vU2ZwZm5MbEIyZHV4M3RlbVlybzJyOHNLblQ1eVlFTTRzcGcx?=
 =?utf-8?B?MkZkb3EvdXZJSXQ3V2ZBeG53c0JJUjA5OC9TeGFLeVZvYjdQbTlVUnNrZlc5?=
 =?utf-8?B?SGEza0E1S1NTUFhvMWtTQU5uNEZEM1ZpR2RTR0RiQ3I5TUNvaXVDaFN4NjNN?=
 =?utf-8?B?T2F0ZmlvUE41MXlvK2RWZzNHOUgzb082VXBIdlhTREdUZTJ4U1djaUtMN2tL?=
 =?utf-8?B?VWJhU2FmRERKVlMwS2hTZDZMbHFpTnY3TEFocjVZcmlkV1dtN3JTY29LV1hq?=
 =?utf-8?B?ZXpRaGVCbzVUOVVxR0lteGZEK3N4UG9neUp4ajNMeVRMM3hQQWdaVk9zcUhn?=
 =?utf-8?B?TEpoS3hOalhLcTkzR2VNclpTdFF0cHlVQ3c0dWxBWVFBN2tCd0JCUms3djNq?=
 =?utf-8?B?ZVUzbDRvWitVNGhPTTRuV2lIdEhuNEtuL042cFo5U3JlVEpUMDhodzFBVVo4?=
 =?utf-8?B?QXA5Q0ZQZVJpdzFvQVVHdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7540.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bDdvajRreVZCN0RMN1NCRVRyYk1WdzdYYzg4QTUxSFBHb3crZVJUa1lGa1NU?=
 =?utf-8?B?TEo0NGU3NGkrV2s3TFVQOTJSNnE0bThJZjZUaXpBaHltT3RHc2U3R1RORXY0?=
 =?utf-8?B?cGpIeVpiZW9GWVdQZ1hEUEljRnAyQlpTUXhEWDZ1T0NZMitVV1hPK1ZYQld5?=
 =?utf-8?B?VmRDdTNNc2JVbVl5N0Qrb3hIZUQzbFhnRlVWdkVaUTBFWmFwUlB5eStaZXBJ?=
 =?utf-8?B?MFdtOG94OHk1ZFZPSTJ0OG9tcTUvd2FIcGI0akdKOW9lYTVhMXh5cW1mTjQz?=
 =?utf-8?B?bFJkV09DUTZvQnhxanBwUDZLS0N0cTFJTkFNcWsxOU1WT0krTjJIRy8vTkdr?=
 =?utf-8?B?aEFGRktib1FmMmpQdk1UOUlSR1JoZ2dJWFVRL0l4UVBzYi9YbjJvT2JiMWxt?=
 =?utf-8?B?emppeGxWSmFTeEhaUUUydGhuU092Z01JUXVRbjRpcGJvRnM3bkl0VmViNFdq?=
 =?utf-8?B?TC93ckpQdkNUc3JMRlJacUN3NG1ONE05TUtYZi9FRXQyUzNGYmhxbGp0TWI4?=
 =?utf-8?B?emJQaVU0VmNWWENkamxtMVJDNkp1ejNmcjQ2bFFvWWZKdCtuV1JoNHVQR1lw?=
 =?utf-8?B?WmpFSkZ4ekg2M2VUbVp6R1hGbkZiUjRhVE0yak9Xb2NUZ2NCN3ZMUzBndWNU?=
 =?utf-8?B?M1JFSkRuWTR6akhadXZXVk9uckJtR3pBTjEzdHFJbTM5eFBQSjM2dkRHaTh3?=
 =?utf-8?B?eVFFdVNQQnYzdlNiUnRLeDhKN2VaUWNudFBiaStlTzM2NUgreGRjYWU1USsv?=
 =?utf-8?B?T1V1bndEbHp5SzdCOXh1SUxFbk85Zi9UMVp1RnhvVUNZaUNlNlB0M2xFa0VN?=
 =?utf-8?B?cDZnakpuN0FJYVI4M3ZNK1RldXhzS0ZacFRvZGxLUkJrNE92TzRnMGN5NVdm?=
 =?utf-8?B?THA0enZ5MUdUaEd6OGZIVzVuc2RhMUpOMmtHQ2swZTB4NVVXQUpSUzA4c1Er?=
 =?utf-8?B?ci94MmxyREUrdTA2VkpQTk5SR0cvM1ppZUJRcTg5dThCajJ5cFlyWklQeUtG?=
 =?utf-8?B?aDdOL3JuU003Z1lNWmo4ZGN4ZE5XYjBXUFZ0UWI0c05iZXdISERiYU9lR1lT?=
 =?utf-8?B?Nld4OUlIVzFHbEV4YTZKd01UTk51TGZDZnJWb0wwT3ptaTNSc0dpVWh4aEpj?=
 =?utf-8?B?VlF5RTFjaXI3ZUpzWUpjb29ra0U4QUVDcW1OcTNvUWxuWnFQRkpCakluaVRJ?=
 =?utf-8?B?Ti9ZRHpTQ2YxOFZDM0NhdGhRTFVzdGpLZ3dpN09KekRRdGZBUVdPcWJJUTVw?=
 =?utf-8?B?SmFSbUdVZGJrS2ZkMWM1M3BXZkw3dHllMkprczlTUDJydzdQRGl0ZS81UURj?=
 =?utf-8?B?Ti9MZUF5ZjFndUNrdWpZZmhRTldFSS9qUjZXR3I5RitzeDZwZEhReFA2QVNO?=
 =?utf-8?B?L1ZQUW95U3RobG9FelRMZjE0d3pYdE56d29qWVAyS1JxbVcxN0RUWmpHNFl4?=
 =?utf-8?B?SUJPNmtMVmt3Y2RVcXdEVDU1dzZrMTZ3NHd3ZXFud0lqS1E2QXJTK29zREJS?=
 =?utf-8?B?MlhTZ1FWNjl4djM2L01adDZvMkJyNElucGRxVEVXSU5OWENUVXhEWldkM1cw?=
 =?utf-8?B?cVBqQ3B5TzVaNzhEUzY4U3IvVFpqK3Q4OUxDNmJwRFp2YVRiUkdwdm45KytQ?=
 =?utf-8?B?dWJsak5aYi82Snc3RWNWRUlxbkxiMnpnNmJHVFhYbHpZVEZ6WEdpTVMzUHdi?=
 =?utf-8?B?ak1xa1U1d3FvYkhTZ3Q0ZTRPaURkaFdkZGZNZzU4YXBJcGwra09Na2Ixem5k?=
 =?utf-8?B?YUhiZnF2dUQwMXJYakRCOHcrVXFBRUtTNGJSYTBaVlhQbDMxc2FHNHBjMERO?=
 =?utf-8?B?Nk1LZmRSZHJMakMyZ0lab3ErWUxhbXFtVm4xM01YeEw1a05KeXZnM3h0Rmlm?=
 =?utf-8?B?OHRJcEQ1VE12YmVyVlIzVUhNeU1VZUNEdHp3RGFiYW1Tb014Y0lROXBlM2tx?=
 =?utf-8?B?a1BseUc3K3FlRHUxbUF4ZGp6eDRJMGpFWUV2bzUxanM3SUJSekNKZzJtaGg4?=
 =?utf-8?B?UTF2RXVxdGorRGZVeGlNZk11OEVqbi9sL25NWEtIRWRLZFBuK3JsaGRZRm0v?=
 =?utf-8?B?b3dGOEtKUW5LK1l2M2ExTEtKdTczQXFMc20rR2hHSi81L3VTVTJhaXdES3pl?=
 =?utf-8?Q?sDWIDZTd5NUzB75xA8BoBhZso?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 717b66ad-44c8-4bb1-24fb-08dca239497c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7540.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 06:10:11.0621
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sU2nQ0N+r+n2e3glAdlDqqmJ1b1bXGfMhhE9ZYzjOulRIb31Yt9INmCiSnTgGMzW2T9TtqPJoQOLpmh+z5WMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4524
X-OriginatorOrg: intel.com

On 2024/7/12 13:19, Yan Zhao wrote:
> On Wed, Jul 10, 2024 at 11:40:44AM -0300, Jason Gunthorpe wrote:
>> On Mon, Jul 01, 2024 at 01:48:07PM +0800, Yan Zhao wrote:
>>
>>> No, I don't have such a need.
>>> I just find it's confusing to say "Only the group path allows the device to be
>>> opened multiple times. The device cdev path doesn't have a secure way for it",
>>> since it's still doable to achieve the same "secure" level in cdev path and the
>>> group path is not that "secure" :)
>>
>> It is more that the group path had an API that allowed for multiple
>> FDs without an actual need to ever use that. You can always make more
>> FDs with dup.
>>
>> There is no reason for this functionality, we just have to keep it
>> working as a matter of uABI compatability and we are being more strict
>> in the new APIs.
> Thanks for clarification.
> Regarding to uABI compatability, even after being more strict and returning
> error when opening the second FD in group path, the uABI compatability is still
> maintained? e.g.
> QEMU would correctly reports "Verify all devices in group xxx are bound to
> vfio-<bus> or pci-stub and not already in use" in that case.
> Given there's no actual users, could we also remove the support of multiple FDs
> in group path to simplify code?

QEMU is not the only user of vfio. DPDK or other applications may have
usage for multi-fds.

-- 
Regards,
Yi Liu

