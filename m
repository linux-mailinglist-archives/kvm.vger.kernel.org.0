Return-Path: <kvm+bounces-34988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5961BA088B5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:06:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F98716876A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 07:06:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5761B2063D0;
	Fri, 10 Jan 2025 07:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fe0DLPuo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830191CDFD4
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 07:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736492794; cv=fail; b=RQK/cQAFKj6k0Il22Fspf7iMeNMltKgZYByL2jBVhzQav6Um58psulpHeppQQN61m8pxCgOYJ/3MnsmS9beVN7UztlPqwz4QlKBwei3Ezz3OU2oXl7yYSbYPHx4YLTA2iPytDCo3TZXkyPfBF4vT7b6MFQG/ZwCzxionYx0cfu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736492794; c=relaxed/simple;
	bh=b8pv1hS1e5T9Y0/kRVlPsyiHtiesMqTGgs+vDSGPa5c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fi/NptgUo+ScnsdAYYxG9ysQlrPxp+3OLVzlxcrMh+FvKE9sga80guQECx9fTRTFwmIHrtokpjjl2qHqU/tRLqJtcdEKdY/raFkybnm4+mz90rYP+nSM2iBo4bCPN9wBeDyfUYMnJHAS+J/ehm6qtdvMMQL2XM2Q26Qty8KabbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fe0DLPuo; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736492793; x=1768028793;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=b8pv1hS1e5T9Y0/kRVlPsyiHtiesMqTGgs+vDSGPa5c=;
  b=fe0DLPuo9O06i9ACIRuLISZxLIsZHD94EJZoi+DP1l/8scmO2lHByRWj
   l3KLp+dSMTa5OtG4kqFShjGsiSrtarY+0Y+IsZ3Jl03QSjWLXfjbAzNn0
   nC35JRxXZlABO2wC/idBKH9RzAKCrPzUwUp6e87e6dy2TbxMwErqorxOW
   LVwwe8btTN7ZHLuQPdwrjchktZ5Um13yzs70T0hxYeJoIPhr+lwWdCewb
   06txdMzCYmX7OjVoBYI+jYVAhVslBGNzjkDEaQB1Xwvj+tsfkUf7/GNMH
   RhfDAPz0jtwdmDqLbqCjpDwv9E+enBIM5amSSMrc10AF9M1zDGtoG7Y2s
   g==;
X-CSE-ConnectionGUID: ZHgN2qoMS6e4IMLuKAxnRQ==
X-CSE-MsgGUID: bDZI0C4GTKKBfHJoUveBuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11310"; a="36886289"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36886289"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2025 23:06:32 -0800
X-CSE-ConnectionGUID: IshrtL2BQIO/hs6d9xR8Sg==
X-CSE-MsgGUID: zl23+/TtS0ytqhskMgN2vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108696716"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Jan 2025 23:06:32 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 9 Jan 2025 23:06:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 9 Jan 2025 23:06:31 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 9 Jan 2025 23:06:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IBldhgxlWfXFlYL//M7q09ob0oCS8kSffvRkjrrkQsIcy6KUlMCJnNVjh+icKMkj/2NqFH48qKGM644m33KWneGoeDdd3LT1K90/u+KZk9pBmPQgNl8cvp+hUBgShpFDBfGgJGkLV32/vkNz/shqTJnWdCDnxMe2cwb18f1R2C0zzCHuZDfjalGuUQIDgr8XtxoKpYKNnKHh221L/EcIpS8s2c9d7MXirTEn9BujnX2LB3dowLi/JckKBb6PsveD64TwLLLXMlC2Us7jq1yVWG47ydhLlNHNr7lbTXNxgRwTwHSVkwfa5NVY7Lrzrt2H8c5o0abenz0CCQc7FO6yQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VelU2MWTvFbSJ1zX205u/wC+1NM3OW8j0ghmBv/qWjY=;
 b=SCqVsh4q+eNdGMITooiLuiVpon4Ivkm5lS6Zf2Un4Cj4Oe5lieVpOow52Kc/jeTGhnJnf5106dvP4GRoEm0aHjo1Pnt2ejzJnKB2hb/NyStCCu9gCcoivm9o1RIeMs/QxJucFCs6Z1pfT28Oz+WhOJA8H+aK+xEa5Cl9u16Jb53AYKsIAb1G0t9IuiticWAFU38Lh5Muo3msdzLS8gXok6E2oeNkfmrOkVnstWM0DHT96Z3ttkOFpajwvRWWVKgDD1NNhjn9crzZ5aux2zOgOzwORFjyVcpfE7iDjluOPh6G108ZQGgB1KkdRC786CAK/Dz9CJCBL3KcxI4KNAe1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 PH0PR11MB5109.namprd11.prod.outlook.com (2603:10b6:510:3e::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.11; Fri, 10 Jan 2025 07:06:14 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 07:06:14 +0000
Message-ID: <1361f0b4-ddf8-4a83-ba21-b68321d921da@intel.com>
Date: Fri, 10 Jan 2025 15:06:05 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] Enable shared device assignment
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <2737cca7-ef2d-4e73-8b5a-67698c835e77@amd.com>
 <8457e035-40b0-4268-866e-baa737b6be27@intel.com>
 <6ac5ddea-42d8-40f2-beec-be490f6f289c@amd.com>
 <8f953ffc-6408-4546-a439-d11354b26665@intel.com>
 <d4b57eb8-03f1-40f3-bc7a-23b24294e3d7@amd.com>
 <57a3869d-f3d1-4125-aaa5-e529fb659421@intel.com>
 <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <008bfbf2-3ea4-4e6c-ad0d-91655cdfc4e8@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0038.apcprd02.prod.outlook.com
 (2603:1096:3:18::26) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|PH0PR11MB5109:EE_
X-MS-Office365-Filtering-Correlation-Id: ab87763f-1b09-474c-adcb-08dd3145457b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VmFYaVoyVFRIL0JuUzBoV0hKK29IQzBHc2lOd1VBSldXK05Ba1k0dnVLNzlv?=
 =?utf-8?B?eHZkcTZVNzJ5RjFmOFhseWl5d1EreURwcHVvWDNIVTl5MHZnNmJHM3Y0M1Fz?=
 =?utf-8?B?ZlM2NjQ4d25CQW55VXpnbjI2NXg0bktSSWNsNXZ1d1VYRzk2M0g5ZE1uSzM0?=
 =?utf-8?B?SkpTQ1BhaVZ5VngzRkM0ZDNuNmVhWkVUaEN6OGdVZklsejVzWGNqSU45c3Z1?=
 =?utf-8?B?aGRVWG1hUFlma2dLWHJCN3hHTmh1UGMxTm9iUGRFc0hTRGQrczlreTgzSTBp?=
 =?utf-8?B?SjhUbHBlUVpkb2FnSEd6Umt6WVFJUHR4KzBUQjA4Z0R4U2poMFkwT3A2RENv?=
 =?utf-8?B?REtiMW1sNEJwM1JPVE1sOG9PMW1CQStZUSt2L0NHalNtZnNqZFBIbDJHOHQy?=
 =?utf-8?B?Z3RCdk5PLzdXSnRVZElNSmxiL0FrQ1ZtT00rdmt1aUVaVTU1VHlvcnhjekZS?=
 =?utf-8?B?U1FQSlpaTVhVbUhLem5PZTZZblNzclNGVE9RRU11bmZ1S2xPQ1lwSkdSOS91?=
 =?utf-8?B?TzAwbGxlWmhHVjJSMWRvVktnSks5QjJjTUw5Ym4ydERNQ1JXL08vQ29BbzVh?=
 =?utf-8?B?SU5VRXdEMDFnT1BlY3VPSjFVWFpEbzEvSC9aUFZncDFuamVvUW5sSXFXY0hH?=
 =?utf-8?B?dm50UWYvOHFUUktOM3ZId09GQTlDT084V0drZ1VjL2kyMEJlVHVjK1Y5R2Rt?=
 =?utf-8?B?dk8wKzJlZW9aNCtqeFU2Z3Nmbzg0OGVnNkpsVHF1eFhkYmpLWCs5K2VpOWxk?=
 =?utf-8?B?QWtsYjlyLytNdEs3NzNEdGl1cUtsalpVVmlqQkdhR2hUaGhCeEtJZXBBU0g1?=
 =?utf-8?B?QzY1TzE4NHJlUEZhQnR3YkVzdnJ0cUVCYWxPV1ptakl0WmN3ZlgrOGpSZnY0?=
 =?utf-8?B?OERySFhnUXFtOGdNaWFhRVZWZTdDdjZmQVpsVm1MVCtpMitST3d0ZWZsR0t5?=
 =?utf-8?B?dmhWekxQZHVMQVgxSUFhNzI5aWNESStZVG9rTmhjSkR1d0ltTkFDeDRvemZu?=
 =?utf-8?B?cCtzNElESEMzYzB2S3kzNlhqSnFBWXZ6bnNhL0ZpSGMvQTd3VVoySXlRYU9S?=
 =?utf-8?B?eVYvYzUwUnNYZWs1dmcwTHA4UkVaRXJVN204UlNkQU84b1p6SEhlbmJRR2Zp?=
 =?utf-8?B?eTQxUGEvRGVqTlVDRXNwZTlLR245UlVzRUNIRUE2bmhyWFFWeHduc0dPYmUv?=
 =?utf-8?B?c3ZVb2kvRU5QeFhOSXphRVBXMHlRTHA2Y0pmNnVHWk1WbENzOFdwK0NXVVNl?=
 =?utf-8?B?VE5VVUtPNThVc2MzcEhDU2VIWEI2ZkVIMk5pV3JkTndnaDZJQU9aWDllZWVq?=
 =?utf-8?B?b2V3WE9IOUl6aHFRQzB0eENuV1VPWGNWU2pod3BJejFXcFdwL1lYOXR3bjhT?=
 =?utf-8?B?RDk1RDFsVHRWeVdUYlhPMFlzUUpnMnUramxUcUdNSkt3NzVuWkdTc05xalFH?=
 =?utf-8?B?UC9FWDZNRnJQRHFhVkhQd3crT1dheUZoeG55NFk2ZUVmNUJ2bmUrakZULzVN?=
 =?utf-8?B?OHhaejQ2bEpWRTFaKzNwTk44VmZ0R05XdHpiSnFYMUlka3RNSEhjVXZIRElj?=
 =?utf-8?B?Ymwxd05TRGI4d3YwNEtySElMbHR2MUJXMVFoNXBiUlFhcnc4T25hL2owTG9X?=
 =?utf-8?B?aXdrRmp6K2IzS3o3SHNSaDBLOUVZZWRhMkJaTVhGSG5seWhuZ2dSSC9BSGNP?=
 =?utf-8?B?VVNDb0EvZFNMQi82MkpKOTM3Y3YyMjMxcDFRMDNUSVNRN21xMjFFWFE2TGRG?=
 =?utf-8?B?cGd0SWorYUFFVWlobXdweWtpWHVZQ0RLS2VJUVk3a2J1Qm41cmRjdDdUZVV4?=
 =?utf-8?B?czBrUHdReUh4UDlZZCszdz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M2ZZT1FaeU1uN1JzZ0t0MGdCQkVJREt2OGxiMmc0cllnazBYeGFwczlyMmhK?=
 =?utf-8?B?UXdPNEFMdk5NYTN1bFlJR1k4LzVBRGcvWktOY2ZwQTluMFRGT09yQ1FuTXhK?=
 =?utf-8?B?Tm1nU05BcGtRZG1MTm9uS0pxQnM0Vm95S2FtT3I4czVFWTdudU1NTno2dHN2?=
 =?utf-8?B?c0x0eHJMN0tVQ1ZrS1ltYlBGL1d0YStuMXVkanpnQkM1QnBvZVJQOThSL0Nv?=
 =?utf-8?B?MWx5dUUwcEozUVpQd0tOSGpyd0hFTjZjY0RQQU5EUUZpd0dxbDBNTzNPVHEz?=
 =?utf-8?B?Q09zcWRienYyRnRpdDl3OXUrbjZ1VS9lMUUrWGtVYVpKMmMzREZLcVJFZ29r?=
 =?utf-8?B?aWRnanhsai9mY2drZTljbkZYWVgybFJDOGV6QkQ2T1NIUi9CSkJzTjNWTzFy?=
 =?utf-8?B?Ulo1cXhTUWdYajBSSmIwOU92Y1cvdkVYaFoxdlNLenpNY3FBNTVrVWdQYU1R?=
 =?utf-8?B?VUZTckJjV2pTVUttYVp3bldxVHRTUDlselU4QlB3N2w2MU5xM0RXMlNsejdS?=
 =?utf-8?B?d1FmWFdPMjkvMElmdTROc1plN25lOUlrYUtPTFE5NVZVUXl1L1QwSmtzNzRR?=
 =?utf-8?B?VGpDejFyaXpFb1V1b1ZtSnJGbE9vcVpDZDRxYTJsenRON2V6ZGRLLzFzRy9O?=
 =?utf-8?B?T3hTb1RoWjZKTm5ER3RQNitBUmRTQTVhTXdGdmxic21WWFhKSGxFZWFzR2tt?=
 =?utf-8?B?c1YvVjlMUUlJSVZ3RjMzeTJGSE8vbTlWUGRrZGVMQ3JwTGliNnRVRFU4YjVt?=
 =?utf-8?B?WnJPNGdjOXpXeXF1a0l3akRNcUhrWTd4eGlPaE0rTzlHYi9rN3V3OERqU2RT?=
 =?utf-8?B?WnBGVW1abldkeUpBV0oydW1TVEZ0cTk0akJpbVFpd0FIbGFwQ1hpdEFxUEwv?=
 =?utf-8?B?NWRMbmJWanpEeW05NlNWaXIycC8xajk2dUlQZDFHaE1oZjE5UTZ0QUoxSmU4?=
 =?utf-8?B?aG5vZ0xlRktJbmE1VG1Ocy9UM3JrelU1RXJidTA5QWNFamlxRlhxamQydFV2?=
 =?utf-8?B?SzlMSTlDRnR5N25ZdE9ld1BOczlKc2x3cnA4WkpmakRBai9ya2lIa2R2aWQw?=
 =?utf-8?B?U2Vnb1o1d0FBZjRqczg0VW1raS8zbTVwbXcza0VnNzJma1I3Q2F0bm1PTkph?=
 =?utf-8?B?TEY3cjZScjN1Y3lWbHhBeXNYQ21rS2F2YXBUZ1hIelBReGdwQjVqY3gyU0RR?=
 =?utf-8?B?Ty92RHI3ejdPZ1RHYzV5UWJ3TkNpSGpPK0lvb1hNell3aEYxR3VHWE0zS2Iw?=
 =?utf-8?B?c2lUaXg5OW1UaThEcXBTd2xSSmpDR0kzTzVzMU5TMk1MOHg4YldWMzFNSTBu?=
 =?utf-8?B?QlNPZFVxWUZWVVllR2dTcS90aE1qekgyNWl2cEwwWlNhM3FNOFRjTERodDFN?=
 =?utf-8?B?cEFyM2c4bkk1bnBrbkxtaG13SzlYYkhpYlN3SjdkZ3NZTjBBNkJPRzVxRXl5?=
 =?utf-8?B?Z3ZOWWRFR3JTYTV6cXpUUlg0ZWpKSmNPMERsQXJzYVAvbkZBWTd2WmhuaWJu?=
 =?utf-8?B?VlljaWF2VWRFYVJvd2REM2UwUHd0S3ZDZFo5OXZPeXdTem5uZXcwOG9JMW5W?=
 =?utf-8?B?YU4xNEtOeStmNTRuT0tPcDJxY2dEc01JRnJ1dnY4UDZCanlxcVJxeDJFOHZM?=
 =?utf-8?B?dzZzejFPV2dUeURlV3NHa2ZPMm82UUp1WjlUdkN1U2FnbDdYeGNFejQvN1I0?=
 =?utf-8?B?SWV4NUJmay9FKy9qVmk1cUtaT01PZkhhWWN0dVRPK2dGRS92NnJnalNiUmd1?=
 =?utf-8?B?SlhoUit4MHhvdjJnSGV2RlRmZkhVZnJIYWRqMUpVRVYydlBLcWFFcDVFWUNY?=
 =?utf-8?B?YThXbzZ0UUtaZFBIelI0bUNzS1BHbTE1VnFiOUhBNmt1bUJ5OHRhcDk4R3hk?=
 =?utf-8?B?ODRNR2cwSW96OWQxSU1PUmFncTZpVUUveC9ySDJtZTUydUNlRHlvNHFEQWEz?=
 =?utf-8?B?WmdBZWIyUUNoQnczYnk2RStRMjk2bitpKzdtd0F4NGdoRGhJOHUwM0EyOXBE?=
 =?utf-8?B?ci9oQ0tOSFBKQ2VFWEs3dVJSc0dscDhueFNaTWVuUnhZNnhqdmpTdmRTUjFN?=
 =?utf-8?B?dCtBS3VWK3hwZm5uajZocGFzNmZCVWZaTnpKak1iWUhYMDV5b0FaNXgxWVRl?=
 =?utf-8?B?NWYwWnJKTXlySGpPVHphb1VKNnIzOGZxSmJRamJhR0N4Qm8yU0VqRHQxTmtS?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ab87763f-1b09-474c-adcb-08dd3145457b
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 07:06:14.5826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DlV2ZawSv5JdlIfsNOpVZnoHR0ZMF8SVdBnqWSywRxVRpVrdpgVvNKwtIqZ+v4vDPW/XOrV616AJTMory2/k4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5109
X-OriginatorOrg: intel.com



On 1/10/2025 9:42 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 9/1/25 19:49, Chenyi Qiang wrote:
>>
>>
>> On 1/9/2025 4:18 PM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 9/1/25 18:52, Chenyi Qiang wrote:
>>>>
>>>>
>>>> On 1/8/2025 7:38 PM, Alexey Kardashevskiy wrote:
>>>>>
>>>>>
>>>>> On 8/1/25 17:28, Chenyi Qiang wrote:
>>>>>> Thanks Alexey for your review!
>>>>>>
>>>>>> On 1/8/2025 12:47 PM, Alexey Kardashevskiy wrote:
>>>>>>> On 13/12/24 18:08, Chenyi Qiang wrote:
>>>>>>>> Commit 852f0048f3 ("RAMBlock: make guest_memfd require
>>>>>>>> uncoordinated
>>>>>>>> discard") effectively disables device assignment when using
>>>>>>>> guest_memfd.
>>>>>>>> This poses a significant challenge as guest_memfd is essential for
>>>>>>>> confidential guests, thereby blocking device assignment to these
>>>>>>>> VMs.
>>>>>>>> The initial rationale for disabling device assignment was due to
>>>>>>>> stale
>>>>>>>> IOMMU mappings (see Problem section) and the assumption that TEE
>>>>>>>> I/O
>>>>>>>> (SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-
>>>>>>>> assignment
>>>>>>>> problem for confidential guests [1]. However, this assumption has
>>>>>>>> proven
>>>>>>>> to be incorrect. TEE I/O relies on the ability to operate devices
>>>>>>>> against
>>>>>>>> "shared" or untrusted memory, which is crucial for device
>>>>>>>> initialization
>>>>>>>> and error recovery scenarios. As a result, the current
>>>>>>>> implementation
>>>>>>>> does
>>>>>>>> not adequately support device assignment for confidential guests,
>>>>>>>> necessitating
>>>>>>>> a reevaluation of the approach to ensure compatibility and
>>>>>>>> functionality.
>>>>>>>>
>>>>>>>> This series enables shared device assignment by notifying VFIO of
>>>>>>>> page
>>>>>>>> conversions using an existing framework named RamDiscardListener.
>>>>>>>> Additionally, there is an ongoing patch set [2] that aims to add 1G
>>>>>>>> page
>>>>>>>> support for guest_memfd. This patch set introduces in-place page
>>>>>>>> conversion,
>>>>>>>> where private and shared memory share the same physical pages as
>>>>>>>> the
>>>>>>>> backend.
>>>>>>>> This development may impact our solution.
>>>>>>>>
>>>>>>>> We presented our solution in the guest_memfd meeting to discuss its
>>>>>>>> compatibility with the new changes and potential future directions
>>>>>>>> (see [3]
>>>>>>>> for more details). The conclusion was that, although our
>>>>>>>> solution may
>>>>>>>> not be
>>>>>>>> the most elegant (see the Limitation section), it is sufficient for
>>>>>>>> now and
>>>>>>>> can be easily adapted to future changes.
>>>>>>>>
>>>>>>>> We are re-posting the patch series with some cleanup and have
>>>>>>>> removed
>>>>>>>> the RFC
>>>>>>>> label for the main enabling patches (1-6). The newly-added patch
>>>>>>>> 7 is
>>>>>>>> still
>>>>>>>> marked as RFC as it tries to resolve some extension concerns
>>>>>>>> related to
>>>>>>>> RamDiscardManager for future usage.
>>>>>>>>
>>>>>>>> The overview of the patches:
>>>>>>>> - Patch 1: Export a helper to get intersection of a
>>>>>>>> MemoryRegionSection
>>>>>>>>       with a given range.
>>>>>>>> - Patch 2-6: Introduce a new object to manage the guest-memfd with
>>>>>>>>       RamDiscardManager, and notify the shared/private state change
>>>>>>>> during
>>>>>>>>       conversion.
>>>>>>>> - Patch 7: Try to resolve a semantics concern related to
>>>>>>>> RamDiscardManager
>>>>>>>>       i.e. RamDiscardManager is used to manage memory plug/unplug
>>>>>>>> state
>>>>>>>>       instead of shared/private state. It would affect future
>>>>>>>> users of
>>>>>>>>       RamDiscardManger in confidential VMs. Attach it behind as
>>>>>>>> a RFC
>>>>>>>> patch[4].
>>>>>>>>
>>>>>>>> Changes since last version:
>>>>>>>> - Add a patch to export some generic helper functions from
>>>>>>>> virtio-mem
>>>>>>>> code.
>>>>>>>> - Change the bitmap in guest_memfd_manager from default shared to
>>>>>>>> default
>>>>>>>>       private. This keeps alignment with virtio-mem that 1-
>>>>>>>> setting in
>>>>>>>> bitmap
>>>>>>>>       represents the populated state and may help to export more
>>>>>>>> generic
>>>>>>>> code
>>>>>>>>       if necessary.
>>>>>>>> - Add the helpers to initialize/uninitialize the
>>>>>>>> guest_memfd_manager
>>>>>>>> instance
>>>>>>>>       to make it more clear.
>>>>>>>> - Add a patch to distinguish between the shared/private state
>>>>>>>> change
>>>>>>>> and
>>>>>>>>       the memory plug/unplug state change in RamDiscardManager.
>>>>>>>> - RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-
>>>>>>>> chenyi.qiang@intel.com/
>>>>>>>>
>>>>>>>> ---
>>>>>>>>
>>>>>>>> Background
>>>>>>>> ==========
>>>>>>>> Confidential VMs have two classes of memory: shared and private
>>>>>>>> memory.
>>>>>>>> Shared memory is accessible from the host/VMM while private
>>>>>>>> memory is
>>>>>>>> not. Confidential VMs can decide which memory is shared/private and
>>>>>>>> convert memory between shared/private at runtime.
>>>>>>>>
>>>>>>>> "guest_memfd" is a new kind of fd whose primary goal is to serve
>>>>>>>> guest
>>>>>>>> private memory. The key differences between guest_memfd and normal
>>>>>>>> memfd
>>>>>>>> are that guest_memfd is spawned by a KVM ioctl, bound to its owner
>>>>>>>> VM and
>>>>>>>> cannot be mapped, read or written by userspace.
>>>>>>>
>>>>>>> The "cannot be mapped" seems to be not true soon anymore (if not
>>>>>>> already).
>>>>>>>
>>>>>>> https://lore.kernel.org/all/20240801090117.3841080-1-
>>>>>>> tabba@google.com/T/
>>>>>>
>>>>>> Exactly, allowing guest_memfd to do mmap is the direction. I
>>>>>> mentioned
>>>>>> it below with in-place page conversion. Maybe I would move it here to
>>>>>> make it more clear.
>>>>>>
>>>>>>>
>>>>>>>
>>>>>>>>
>>>>>>>> In QEMU's implementation, shared memory is allocated with normal
>>>>>>>> methods
>>>>>>>> (e.g. mmap or fallocate) while private memory is allocated from
>>>>>>>> guest_memfd. When a VM performs memory conversions, QEMU frees
>>>>>>>> pages
>>>>>>>> via
>>>>>>>> madvise() or via PUNCH_HOLE on memfd or guest_memfd from one
>>>>>>>> side and
>>>>>>>> allocates new pages from the other side.
>>>>>>>>
>>>>>>
>>>>>> [...]
>>>>>>
>>>>>>>>
>>>>>>>> One limitation (also discussed in the guest_memfd meeting) is that
>>>>>>>> VFIO
>>>>>>>> expects the DMA mapping for a specific IOVA to be mapped and
>>>>>>>> unmapped
>>>>>>>> with
>>>>>>>> the same granularity. The guest may perform partial conversions,
>>>>>>>> such as
>>>>>>>> converting a small region within a larger region. To prevent such
>>>>>>>> invalid
>>>>>>>> cases, all operations are performed with 4K granularity. The
>>>>>>>> possible
>>>>>>>> solutions we can think of are either to enable VFIO to support
>>>>>>>> partial
>>>>>>>> unmap
>>>>>
>>>>> btw the old VFIO does not split mappings but iommufd seems to be
>>>>> capable
>>>>> of it - there is iopt_area_split(). What happens if you try
>>>>> unmapping a
>>>>> smaller chunk that does not exactly match any mapped chunk? thanks,
>>>>
>>>> iopt_cut_iova() happens in iommufd vfio_compat.c, which is to make
>>>> iommufd be compatible with old VFIO_TYPE1. IIUC, it happens with
>>>> disable_large_page=true. That means the large IOPTE is also disabled in
>>>> IOMMU. So it can do the split easily. See the comment in
>>>> iommufd_vfio_set_iommu().
>>>>
>>>> iommufd VFIO compatible mode is a transition from legacy VFIO to
>>>> iommufd. For the normal iommufd, it requires the iova/length must be a
>>>> superset of a previously mapped range. If not match, will return error.
>>>
>>>
>>> This is all true but this also means that "The former requires complex
>>> changes in VFIO" is not entirely true - some code is already there.
>>> Thanks,
>>
>> Hmm, my statement is a little confusing.  The bottleneck is that the
>> IOMMU driver doesn't support the large page split. So if we want to
>> enable large page and want to do partial unmap, it requires complex
>> change.
> 
> We won't need to split large pages (if we stick to 4K for now), we need
> to split large mappings (not large pages) to allow partial unmapping and
> iopt_area_split() seems to be doing this. Thanks,

You mean we can disable large page in iommufd and then VFIO will be able
to do partial unmap. Yes, I think it is doable and we can avoid many
ioctl context switches overhead.

> 
> 
>>
>>>
>>>
>>>
>>
> 


