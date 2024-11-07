Return-Path: <kvm+bounces-31083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CD6A9C01AD
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF9721F24071
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F02B1E3DE3;
	Thu,  7 Nov 2024 10:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kcJ6zpIm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA2D1E6339
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730973607; cv=fail; b=Sv2HhGN0nM/GfNALM9WyyFmns/CxjE5guR8KNWqPDep5VLASIBrAYA0zqYOITAOikIfo14UAeb+WekJ9i1F9AuTPRsrFASkNOfMt02dSbb+msz7RbFdC80n9GjsHLEdaGJb1trCbp2BgY3JtyBPJ75i4Em5UJsPTOUKjofAXt0c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730973607; c=relaxed/simple;
	bh=nY7q9gSbEli4aXu3MT9XtC0fOxBNp4Kdu9hTnJ66JfY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nRynlA5eP0ntLoWrLb4wcefamRk7ZEpsCpgGQzp8E+vD/a7TUtmTQpo0N1cv626wO8avZn6ehVftV0T7D2PFxt8JcgdQVDDUTN4TkxjE3J6k5f//0NwCdmUa/rRDTQ/5vpb7p75wxQiwLHb95O/l8zxUiI85M7YTyTMG04HMiII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kcJ6zpIm; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730973605; x=1762509605;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nY7q9gSbEli4aXu3MT9XtC0fOxBNp4Kdu9hTnJ66JfY=;
  b=kcJ6zpImwaIm8eUiMkyP9enQVlO2l6zhrc39htJCO9klI5E54Ss9OtrL
   ZWrOgKt98ll2x880tfcOMLdttoEat4KVaJsgYXIxbA3KpmBba009csWET
   H3KHVm94jOJcRqlVXDYsdBIub6ZFhWUfhj5/nwQozUUslexMt7eMLZi9T
   diLIoihcVbKjjD9abbL3Fy8qdbL1ONpvIOlSftHuAY3wr2+8KZxSq1jaf
   sQ86uMBTjbXjn9wh4xDwykADYe2A4WcxfBEMs/oE5Br24jqEEAQVPpang
   TijK7C9ZgO/NXMmp/IfmlIQ/dBp3u/k7CWr9G3GCTtQuUD2werFWeRd+8
   A==;
X-CSE-ConnectionGUID: 1fIgGiGxS4296gbN0Ht4hg==
X-CSE-MsgGUID: iRK/Jd5LSQmypT7DuhFVSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="48267630"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="48267630"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 02:00:05 -0800
X-CSE-ConnectionGUID: /9eEM9BxSl2eJBfck98I+A==
X-CSE-MsgGUID: 5bgh0SSrSc2uJHXsujbPbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,265,1725346800"; 
   d="scan'208";a="90136195"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Nov 2024 02:00:04 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 7 Nov 2024 02:00:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 7 Nov 2024 02:00:03 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 7 Nov 2024 02:00:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kCN7OktiOBm00iux6nkJS3IFhj9687cfnwI96UBTHD1uESZhwbKueWj50A7vzuu6bcpYcr0K8j4Xb16Y/TSd7PiY2X6svcYsEHk2sX8P4FrlxEBPZEVmvAY1agVvcRV+etwzIjpDjPZbjxYcVD5WF7bfOwOTiIFLtf6h+Ir6FVXhxsTNZax7TmxsH/Y8D0oEdPqlImvKJZ7pMAU5+VwsHTr72g21bOVKX+4cItrRZupPkny6Zpk28FeDHgd51uCXio1jHwekpjwa8k+UJ3XqogeOvDnrQHVw+67tvMkDckKXOMJE3bTRdmNVCYbYkOQ7yIoGpn1lqEWDIiJfs03gbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nIzwp47FRVTd0tEaJQtWrxbEyTtH09ndsW84iEgsegQ=;
 b=cHVYfkJq4bEUF9G1EsARvxKWhTcXB4qpWy09aqDZnWXdHlRpUUrW48hA6qqHNLMIssFm/txbiN0u3Fze4460VdsThrf9QU5eLXzsUvyk00KBAIx2WiyrCRgYZcXOE90JAfYxvAyT0gyvbcZf4Tk4iMziTjBrc0S3RNCGIpoFJBtNWXYmsOrmrknTY9WxuNC/xd2tXddlmJYhPpej+BznANthCcNrkB4t5Z31nHhK/6+ckgv6jy7Fhl40RacSnu+13FifM48uRHcjINC2EkEc/zwuMi9GIxZU0W2j+m/z4uJ72twBk5ZJ26+LwI4WT6Qc0IGX4L14+zmnZlr1rDxVsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH0PR11MB5015.namprd11.prod.outlook.com (2603:10b6:510:39::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:00:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%4]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:00:00 +0000
Message-ID: <b7155c97-fb54-4904-b9b5-291a8ed33014@intel.com>
Date: Thu, 7 Nov 2024 18:04:35 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] iommu: Detaching pasid by attaching to the
 blocked_domain
To: "Tian, Kevin" <kevin.tian@intel.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-4-yi.l.liu@intel.com>
 <BN9PR11MB527612ED148A938C7C490CC78C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527612ED148A938C7C490CC78C5C2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0021.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|PH0PR11MB5015:EE_
X-MS-Office365-Filtering-Correlation-Id: 74aed463-268d-4e83-97b8-08dcff12f13b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L2lXWEkvODdZbHYvOWtNZWNpeEhEd2dEWFlsWXhwRVd0RTVsSEZlK1RQWFdm?=
 =?utf-8?B?cTV2SlBCSmRoNE1CWHNtNUxYMWs5R3NyQlVFMHpVU1k3aVhIQ0V5ZHYyeEdY?=
 =?utf-8?B?VitZNjNYcVAwc3RPOVh6Sm9vYnZrVy8zVDVPL3NXZUZnMUFCNENqSWVrMU9V?=
 =?utf-8?B?VUxjM2o0bnZiajE2MW9vc3pKZnVDWUJwYXdmRkh3VytTZHJXL0d1VGdtSVhh?=
 =?utf-8?B?SlZMSm9yemtCT251Zm5tRFRUaEJYWTkvZjhVUU44UDMvNmdVYjhBZE01cWxE?=
 =?utf-8?B?R0FrTkwrQnRlV3FNRGZjWFRneE93MEtBdUpqWWxOMnNRZGVjZFZKSk9YT1N1?=
 =?utf-8?B?bTRWSzV0Q3V3a1F0K2s0ZWUwSVd3L3lhSGM4SCtQSVhBWWJMTkdJQnZqZzMy?=
 =?utf-8?B?WUtJd25rSmFpSFhkaGwxNVJKN2taMTZKRVc4SkkvM01DenFVMGpyTHJrZVJX?=
 =?utf-8?B?T2JFVmlYVkhDbnJ3dkNXT2tnNFNaeGZpa2piTjhYdUVUZ040WFFmODkxUmp2?=
 =?utf-8?B?V3JwSmpQazNRZDNhcW9TSGhuZ2ZldHB2RjFYV1ZsRE9zeUF5VkF4bUhtTERn?=
 =?utf-8?B?aGNJN2xDNms4R0MvbFU4MDZMdSt4R0ZlYUFxMStRblFPTmQweUpBQkhVSEN6?=
 =?utf-8?B?Z014Q3lxR1VwMTJOQWg5WjFtNzY5YVBlNktkY2VmbVF0QzYzVFA3b0U1blB3?=
 =?utf-8?B?am9PL09rdi9qMFdzcXJMS3BuK3ZQeWJBR3Rhc2pyNXlNR3YrUkhKSnAxMEk1?=
 =?utf-8?B?azNaQ3gvUUdPVkgvZG44ZTZIMjIxSUxrenkxaDdrMG5hWXliNzVyTGIwNFpG?=
 =?utf-8?B?YnkrN0RnTU1jTHdJRjlVUFdRbmRab0VqZnkzZ3JQNmpLQjJBVjZzUGtXNGRL?=
 =?utf-8?B?Zk9OUkRrRTlOSUlxcHRYeTEyTlRZQnhQcXlZMWUyd1krNEVIWEc4bzJLZ00r?=
 =?utf-8?B?eUFuQVV0ajQ3ekcvc1NJVk5xelc2U3pOL3hXb2hpUEhWL0VDV3hTVVVzMzMz?=
 =?utf-8?B?Nm5ncDhMYmxwRmltTENSRllGVjRmUVNheVFacHNRS09mVkVZQkVQM01IUmJv?=
 =?utf-8?B?SWR3TDVQVko3ZFVvUU04cFNqOEdBY0E1YkFIUlpEL3V1bXRQaWpXRjJuaEMy?=
 =?utf-8?B?c3MxSFdUZ3JNTDNnNERxTTRUSmpLODJtZXhTYk5xUUVVaTFZODhiZGNpanpz?=
 =?utf-8?B?bUlrUGhtdm1nVmtTaEVzUXBrbmNtYmNzWjc2MGJlZUhYSy9YKzYraGtnWEpC?=
 =?utf-8?B?ajdXOHd4UkZvUDNSZk5UY2tLUWlBZEMwSm4raUFjeC9IdHdPL3hHK0k0eDkw?=
 =?utf-8?B?RGZVTUhwdnNKYnhwQmszaHhNQmtIUG1JeXFvN1dzVGlidEdvWDEwMEc3OG55?=
 =?utf-8?B?VW9YcmhSWHAvZVJ5a2x6dk52WVBPVk04OXVFWHBpQlRWMTVkZ3p0Q1pPYWY0?=
 =?utf-8?B?WjdDQVJSejdzZXhLbHg2Q1dpTUEweFZtR3BjTWxzR281eW1oVE1RR1NjNDBN?=
 =?utf-8?B?UEpFRHhJRDYrZWNSeHNadmxPK2Y0THlreFJjOCtEZGtkaGJiRzhGazVRdUQx?=
 =?utf-8?B?eXJhQ2x2RWVCQ2lyRnpMbkhvNjZPOHJ6M2FGQmlFTFhKa3ZlV256SEx5bkRR?=
 =?utf-8?B?WW5lejhOeTZpQUdqOURMd2FoaXlsdGc5R0ErYlRJS3cwMTNTbmhMZ1RndHpS?=
 =?utf-8?B?R0h0dVJsejRwUTd6Q3NhN3BncTgvNExEUnRoZW5tamd5ZytSWUg2TFJnYjV3?=
 =?utf-8?Q?FeJchFnCGxvrik0pRo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFlOVlRMRjZnZW4rbDNHQll3dUNoTG1SMTRHcGc5NTNNbkVTdEExM1RjRUll?=
 =?utf-8?B?NGFTc3JuaTlZVzFsVzlFbkl4d29RV3Z2R28wSnNrcEE2ZGlPaHJndTdFNE5i?=
 =?utf-8?B?TWhRT3I4WnBKNG5ES2o0T0RXYmRJYWZINGRsaVUrZ0pmTXczNGpFUTRQWGZ1?=
 =?utf-8?B?YWZXL25mbndBWjR6Q1U4eXRZUFhKSEZaRGtsdHU0cU9wT0ZheTVwSVZFSHZw?=
 =?utf-8?B?Z0YvU3V6MVJtbXozazV0OE14dVk4NUJhWE5wZDJBMTRBNGpkWWllZW93c01i?=
 =?utf-8?B?bGM5VGhaR3RjRjRHRzZMTHk1MTV4a1NFaHdRUEZiQ3lZWVBzaTZwTFpVNWpw?=
 =?utf-8?B?OEFvcnFpaDZ5SHdjdTl2TjhCTUhITXhNb2lqaGR0UDlpQjIwTk5OQUg0Z2hD?=
 =?utf-8?B?cHZpNUdJQm1YaXUyS25wTUVUUEpxd2h2T2w4ZTU1OUthRnNxL09ZWkJlV3k1?=
 =?utf-8?B?NUpkTXQ3VURUUk9yYm0yaW1GOEpxMzRXVWdBN1pYRHB6Zk9NazlCdjVYaXFw?=
 =?utf-8?B?aGwvZWs4TjhFNlRFT24rUWZzRHRVSmNTaDV0VnVEVlFod1pmbUxYOE1vcDB6?=
 =?utf-8?B?dzhWa0VYNmR5TUsxV2ZONDkxc24zeHAzOTVIVU5LZXFaUFZHUCt0VVV2d3Ja?=
 =?utf-8?B?MlQ1Y1huSlErNThaS1VCdnNtbzFQeGN2UEZRR2E1ZHlaYkNDd1F2blVOSDlP?=
 =?utf-8?B?YXIvN3d0T3V0NnZDWkx0NStNZ1hmK1k0U2pYczZVU2FyR2V3b1doanNHRmNL?=
 =?utf-8?B?ZTNiVUJ5UzgrUGxjZGxUTHkxeU9CSStKL0h4V1o2VUMvZFdhZzhSbUUxTDJD?=
 =?utf-8?B?N2FKM2lMamNZNWhUbndNaGNZalJ6dlEzSzNFdW5DeUdyQVRaV0k4d3dhVHNx?=
 =?utf-8?B?TkI1a0hqVmdCMUxNT2VsOFRsSXNxcW5IUVR5NnNHNFlNa1hpNjVLajlJS0lM?=
 =?utf-8?B?RGl6MTc2SkFDa1VCWUo3VWhzR3hKc1UxQ1ozTXNvcmoxb2F0TlZ1N0RKVFRZ?=
 =?utf-8?B?YnFxcDk3QVRxaDQraVZYMlVZZ3M0aG8xcjlOM1pXdTdscmFjTkdEUktZWVhW?=
 =?utf-8?B?c0x5c2dDVWlGSVRITms5TVZDc2UyR1U0cy8yckpQalUzazZRak1DQVpITjJR?=
 =?utf-8?B?c2d3SEJCc21PQXptUHprbnZ1R09JVjFCUG5aZlIwU1lxQmNKS3BxdlgrTkFl?=
 =?utf-8?B?b0o4bE80bFVIcStrMVdmb2IrWmh4aWM1ZGpydjAvVmhmM01ROHRNWWdad0tB?=
 =?utf-8?B?bE5MVXRNNzFQNElnYTRsZzBwaUF0UEdHZVJCUUhiL2FFbjFrdmtxVnhtbjR1?=
 =?utf-8?B?MmY2eUNQMmxwSjBQMURxTG8zdFpoU1JmTVRRcExMQW1jNlhwYmR5c0Q3WDIx?=
 =?utf-8?B?aytuQ09TUEQzUCtYVzllS0FodVMvVWJqbUFncmp2cXFFR0k5bVJZRWNtS1gz?=
 =?utf-8?B?akFPNURGWXlSaDRFMGFjYUVuYUJHVVZjekN0TDc5NU9HSGVoVGpEVEQ2bGpB?=
 =?utf-8?B?VUZhQjVTelNnVElneWRsYnRSV2krZVhRMC9XK2lIMXVVSGNIY1MvLzVlUU9Q?=
 =?utf-8?B?RnptU3lmNHhNUzdYL0k0RElOVHhFbDI1dnpTdHREekZsd1FCUmNDUWNpcGVN?=
 =?utf-8?B?Qkgvd1NMNDY2OXdlMDQ1MHhSVGdReXpaUVJvNFZZM1RGTjdjeVJxZkJvUVIx?=
 =?utf-8?B?NzZ5S3czendQQWYxMXF2enZYZXZYRUx5TzFxK0lwSVNuaGJzOUtMZkN6ajZB?=
 =?utf-8?B?TzhoNXFjMFFqMGYrTmE0Q0haUUZSRXlkc1RWUmprOXk0ZnlmdnRXRlVVMTQv?=
 =?utf-8?B?TmFkenJDSG00RXE2UFF0RnVHVG5ibVQ3WElRVW9xWGdtT243SDg4NjFicksx?=
 =?utf-8?B?VFFzbmd5a2VoTmppbU5xTm1PbDErTW1sbGhoTE1MOFdzUlhmREdTSzBtcUZk?=
 =?utf-8?B?SklodCs3c0tuYStkM1FIV0FWS1pCZmN6ZG91aDhJa3ZNYkRadnhhTks0VlRh?=
 =?utf-8?B?OTFxQnUwSlpYbmVhbmJsMkNFV0w1OGJBZnc1bS9uZlFIWlRBS0NYTlNCUlhY?=
 =?utf-8?B?dFkvS2Exa2RobmI5bU94ZEJiTVZ6SVdlQ0pUZW1lNmVTRHorTTJONTBBWW45?=
 =?utf-8?Q?sLQohQjzvI3xFZCzGVeywKoCn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74aed463-268d-4e83-97b8-08dcff12f13b
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:00:00.4534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Gu8XEi9IxxjV2C4fYdJMP1BENXesWBPZGQ9towPaiwQ9w2tCIBR7cPvyOLXMnIc0Wzy/PvV7bkPFGhitAl0Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5015
X-OriginatorOrg: intel.com

On 2024/11/7 17:35, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Monday, November 4, 2024 9:20 PM
>>
>> @@ -3404,8 +3404,18 @@ static void iommu_remove_dev_pasid(struct
>> device *dev, ioasid_t pasid,
>>   				   struct iommu_domain *domain)
>>   {
>>   	const struct iommu_ops *ops = dev_iommu_ops(dev);
>> +	struct iommu_domain *blocked_domain = ops->blocked_domain;
>> +	int ret = 1;
>> +
>> +	if (blocked_domain && blocked_domain->ops->set_dev_pasid) {
>> +		ret = blocked_domain->ops->set_dev_pasid(blocked_domain,
>> +							 dev, pasid, domain);
>> +	} else if (ops->remove_dev_pasid) {
>> +		ops->remove_dev_pasid(dev, pasid, domain);
>> +		ret = 0;
>> +	}
>>
> 
> given ops->remove_dev_pasid is already checked at attach time
> here could just call it w/o further check.

yep. A driver does not pass that check should not get here at all. So
either should be valid.

> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

-- 
Regards,
Yi Liu

