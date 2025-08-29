Return-Path: <kvm+bounces-56379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12B2BB3C570
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 01:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 870887A708D
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 22:58:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B55F3019BE;
	Fri, 29 Aug 2025 23:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LRAv8OJu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8535B3002DA;
	Fri, 29 Aug 2025 23:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756508409; cv=fail; b=aHSfEROvhhRYT67ZzHhdqn/M28iW2eO8N79C/oKhC1KrU3u5FgEkBtuJMKQo6dNC9o+cVp1bytMwx2gUO/pMudVeM52elZpcB/AsbU2Bd1BZyvijA0mTRiXTAc/kbmpiu3gk28h7Z9enNr1w3TeiI0QQfFI2HZB0yrUr6hicoBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756508409; c=relaxed/simple;
	bh=+A45zzSbXTKR+gMNyDU7SKh+1t16H5IJV2aKRu7EoU8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SwWwU2xwQuzDdzYXsbgjSUnYzIzyWWUJmENkA9v1VASmccFfEMlAuj/iSpbdmuYghEtoEIcyZ2Qu4TfeiyYRDT289Xs9tHWeVkHCsd/BkgfFov6KZ9bB6HbZv0IVzCaJgWUvqtT+40i6/a46/RzpDA7pNpd3UKbRi1yTmC8MZ0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LRAv8OJu; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756508407; x=1788044407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+A45zzSbXTKR+gMNyDU7SKh+1t16H5IJV2aKRu7EoU8=;
  b=LRAv8OJu5jyPjm2ytkRhPeFXUE8LU6OMVD31bKN9qzf7FaZAZi7eI3T1
   vn/uD9czFQAlYJDCm+vnVQKYTDZ3r2GebbVjoIckI5M8AMfZTkrCtvesy
   m94trpDPyRKOWFetHyak1rn3Wg7ff9Mv6nBOBleUNcAo3/ryiaLurhsZC
   ZkFPl2fNES+2wI/rfnOkw8PooxXNnIfQd+JA85xAfkuFkXTkpITylQHIp
   0IkJ/wzhn8hFl01zjXjOATXSoFioxLwCwCzhPS//WRuheefdBmdtwQXrR
   qgOYEmE59W7bw57e0vTy7mDLDFivaBbg+UxqW51nhVn8iQuMSqZOg0B95
   w==;
X-CSE-ConnectionGUID: ehJnZRevSsipyqPdgsleaQ==
X-CSE-MsgGUID: PYdAvIhhSdCzoZ9IjCt7ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="57827140"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="57827140"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 16:00:07 -0700
X-CSE-ConnectionGUID: UuxY0fyHQp2+75dz6Gq/vA==
X-CSE-MsgGUID: 5YmwohJOSf2IXLzk4mdjMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169783710"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 16:00:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 16:00:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 16:00:06 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 16:00:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LUk1XBaHFwMWY+FbI7L8MY0njj4ArYJPPayXQfMFOGRJwHnSkgzS0ElDp2z8F2BXaY+JjR05r/H1V3Osfu9cUzcUZi1nfuNO04dPPOXqmjAuVk4lCUdBDgIjx7HZGWdn6N4hJKEmox7GvdAI5MxypNeWQt4UM4clFnljSbBpXcVyV3SqaRmtvKNlYdFYMXg7HJxZzEH5nClfcd4IRapQuJhLWwhX3go/gW+vTNDGyZGW5JNdVRTgNYpq8AHZ1/iqMQeajgC9jzet3u2mhQNBR1zXmzdghTRAWJDnhoQSBTq0Y4ZvILOWiK6+ZQ0TPvYD0qacOi/z7CrAJCmVvOMhVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+A45zzSbXTKR+gMNyDU7SKh+1t16H5IJV2aKRu7EoU8=;
 b=oM78Q9+aDS4ZkxedPQFAgzajimAhvWJnO26YrKOet8WYNkAnmgVuQB2cZdaWk4b0WXiCjxO45/L+YkX6a7+7NyFIykcOioGEV06aeHp699CpxV5uBvqleo18FLO4vKeyj5AnrqkSp6ADvxtRqY+r2ptbFn1/o8MtqGf8vjonhHtG4Gavv36WFRvXsM1hj53BuUF1LH2YmR3UyWhHV3hNV5vogqcEvSfyGsUICDjPyQ/g5Zzsb6eVpRSH61NUxxM8ORploMLkxyA+5r4TDTxns7UlGZz8L8++znFSciwlO1gSuSd4fwKILW7Al1dRTIvc6/Ok8rtGoJ0RbypQMMREzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4806.namprd11.prod.outlook.com (2603:10b6:510:31::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.21; Fri, 29 Aug
 2025 22:59:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 22:59:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "michael.roth@amd.com" <michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcGHjL8dqNtw+1DUm4eDEQMXeVS7R6DDCAgAAHQwCAABp0gIAAAmYAgAAELgCAAAtxgIAAAGmA
Date: Fri, 29 Aug 2025 22:59:58 +0000
Message-ID: <d6c4e27a70fa66b237f625ec55ffb7b1ddbcd779.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-6-seanjc@google.com>
	 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
	 <aLILRk6252a3-iKJ@google.com>
	 <e3b1daca29f5a50bd1d01df1aa1a0403f36d596b.camel@intel.com>
	 <aLIjelexDYa5dtkn@google.com>
	 <26a0929e0c2ac697ad37d24ad6ef252cfc140289.camel@intel.com>
	 <aLIwlZWdyhBp6I0Z@google.com>
In-Reply-To: <aLIwlZWdyhBp6I0Z@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4806:EE_
x-ms-office365-filtering-correlation-id: a73eeb76-a150-461e-d3f1-08dde74fc730
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWF6UEdUL0VscmhIQVczcWVTaDlCeVo2R1VkOEFWL0tOUWVRQnNTSUxUbERB?=
 =?utf-8?B?Ty9jeWtxQXlNRjlMQ2Rkd0xQVkptek5sL2RBdEhMNlJEdUEzQzh1ZlZhNEhF?=
 =?utf-8?B?ejlTZjJDanFtcUlneitITHZzaEtuenhTR214MWYvZnlacUVEYitXc1loZ1Ex?=
 =?utf-8?B?K0lTejN5ZTV3aUw3eHp3bWRUNVhja1Z6Ky9WSkVKSzVDQVpUTFJqS085NHJ1?=
 =?utf-8?B?M2hOWm9GYzdmYnJ0TmpTOFBweFcwcWtuMU9YRmV5KzRUV2JRaWRoSk05Vm9Z?=
 =?utf-8?B?RC9iV0JaamNCZ2QzaDJONk9SckVrWThSa2tQbmRSYVlTd1RmQnV5OEV4TXVz?=
 =?utf-8?B?eEdJeWhFaDBtRG5OazRUZ3RpRnl4clBvZ05yOFVzTDU2eUs1bm1qaWRDWDFy?=
 =?utf-8?B?SGowdmlwajNWVmtsUnZaWkhNaFhDWjhGNjNvMTVGc2ZvMmhFRHlwVERYYzJj?=
 =?utf-8?B?R05VYlVCOXJ0ZDFiZlNLeWMvd1JQSTAvMDJEeE9SbHhPWmtET293b2Q0Y1Uv?=
 =?utf-8?B?UUkya1RFQ2c3c1czMnpkTCs5Q3NjUktIQS9pSllQQlFVY3hBMmV4bVlXN1Ay?=
 =?utf-8?B?czlqSnU4MFNiZXVFOHFKamtNQU11Q2dBQVEwcXN2VEh3SDc3R0NzRWFiaVVa?=
 =?utf-8?B?c0J0dE9wR0hGUmVLK1RSOVFiQUJMQ0pYd0tFQ3dCNGFKS3JqelROUGRsbzdx?=
 =?utf-8?B?WnJxL1BGSzRhRG4vM1ZCMEp4eFlVblRJMEFZMjlHOXFGc1Bwb1dEMUhtdFNC?=
 =?utf-8?B?bGxKbVBWd2dLb3E4Y1AvSklVK3cwYk1tUnVvODY1eGVMcEZYZkFBTmhUYXFS?=
 =?utf-8?B?OGRndjlMSjVFbGppdXRWbEtOSCtOajJKVU9mL1NuWVR2bS8wSVcxcTFpcUQw?=
 =?utf-8?B?M25pRjZHMVFMUXNTdFdJK09JTGFOU3RpRlVkSlNyTXYvTVE3SU13QVNxTzhH?=
 =?utf-8?B?cTNRYmtGU0VtRmlBc3I3cXkwbmNRMkUzdXp3aGVCRFVTWUMvSVNpeU1PbTc0?=
 =?utf-8?B?Nk9GOElnaUFldVo1cHFCazN0YXBHeXpWSWcrOHBOZVNvLzBZNEpNaGpYSlZ6?=
 =?utf-8?B?ekhjbVdxOTF3UmVtOGtucUFxRWduQi85bFJreFhhV3dvQWtha3JYNmErNDlL?=
 =?utf-8?B?YkxBUW42YmFaTlgvL21uclpSem14KzRPbHFkZTNOYkVWSmJyejM1UHI5c1NS?=
 =?utf-8?B?L3JtcU5LODc0cEsyKytsYkNJUllodVIvVEtvQWdXa2RpR1liYWFnZ3J0a3lz?=
 =?utf-8?B?MjdQR0VCSHVXdkVsVHVUbDZMOWpXWEFMMEUzbVpHNkpLdG53WnRTUVlnRk9Y?=
 =?utf-8?B?VDQzM2xoQWVETDdMNnRVV05LdjdGZG92em1QT3VQWlNDaGZnWnpRbXppemF2?=
 =?utf-8?B?d0t0Z2Z4UkY3d2UwNWt0K2RZU3VVMFk3a1hPVE54TGJXTXdVNTNnMDExTG5m?=
 =?utf-8?B?TEZ4eTNKcGpXWWtYY3JWNjI5cERIT1BPKzMzT01lejNzL1BpV0pEYm9BS3ph?=
 =?utf-8?B?a21PdzBRTllaUFNUb0FKZElXbmltNE1KOU8yaFZaTnJoaTc3SHFpOHRDUjBT?=
 =?utf-8?B?empoV1Jrclo1RzlMZWN3RTZkZGZ3VXdNUlZMVXRCNnZNSXRJZnlVdm9QeEhD?=
 =?utf-8?B?b2toM1N5RHhhb0dkUlA1VHNsdU9Iam9Qd2VpdTNhQWZXamsrNU80WVA3TWRi?=
 =?utf-8?B?ajVvOFpYWjdEK1NzVm16SnhYeSszZWpZSG9GQ0UvWDhKNjRuZGkrUU5TdFJy?=
 =?utf-8?B?VHdlSU5neDVJUndMVi9LTWF0L2dUT25vaTdaMGNKOFlNMUJuOGlucEpJaW84?=
 =?utf-8?B?MjlHMVo0TGd4Qk9STWxNNjJkbWlBRDdWcWhEK09BYTJWbmNiTEFOa2t3UFJY?=
 =?utf-8?B?WitBaGlmdVhTd1l1S09xT01qY2pWbmNqZ2UxbmhtWHQ4UnR2SWVscm03aFhG?=
 =?utf-8?B?RmNSVlFXVnRGaC9VdHJFZm5zRmVBMGlSUUxLRi94akhZaDVuR011UC9ERkZC?=
 =?utf-8?B?NFJ2bHJzelB3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDlrV0tWdHhzTDZGajVUVW9qZ2tQelJzWTNOeTYrek1vMGhuTVErRzdrUi9R?=
 =?utf-8?B?a0lxWkJOQ2cwalRkTXNxU1dGbS9VRzB2YmZpOW5UQVZDRitzUDlSdHRvTUk4?=
 =?utf-8?B?S1FKMkJLNGttamFFMmZ4SVF0L3FmbnR1Vk9iNUFNa21XeW91ckR5c3BFUGVi?=
 =?utf-8?B?SWo5dDRUTmxJVEFJb1YrbjMyV21UMlo3b2J0YnlXaitsTGF2R05BZEVVQnVQ?=
 =?utf-8?B?Q3VCZ2ZFbmVnWFMrK1VYME5NWHgvZWw0YlFPUUwvUVZtT05abmRyNEdoREww?=
 =?utf-8?B?RFhzMTQ4SFRueWJzOEEyY0tLSmN4VDFFb1F5bE1zcW0xQ0Y5dlJkV2tHM1hk?=
 =?utf-8?B?UVZVWW82eDd6NStUTFZ6WXJlMk1GUTdneTFJK2loRXZQQTNHcUZuYXpuRXNB?=
 =?utf-8?B?cU9iV1B3VTFHSk5TNWJZZzVmS3VDN0FRRldxV3BhNUZxKys1dEhiSjIxeVVo?=
 =?utf-8?B?MXFoWUVWNktLSWxyVjhUT0lHVGhqeVlMbE03SllOZVR5K2w2RzQvUHFEaE5Q?=
 =?utf-8?B?UVdHc3pMcnVJOUdIenBZazd4RW1uR2Z4K0p1MzJ6WFp1cU0vZkJpYkl5cDR4?=
 =?utf-8?B?SE5uNVRYV3dZSmlBVjhBTjl1UFNERGFvSm5ROGdqVHhWQUpaZUxPRGJaOE4y?=
 =?utf-8?B?c0tFMDFjcFhKSEtZVkVqaytNcXFNZlA2S2hIdFhxR1VPM05hZGswYXg2TEYy?=
 =?utf-8?B?Z3F0TnBpMWJUR0tEakhtbzFFbW81K05aRVJidFA0bVpOY1c0RzN6VHFNTVZj?=
 =?utf-8?B?bDllWTd6ditSa3VRNHR2R3p6V3pPdG52VkRBalgrOUVEREMrd2lleW1FdFFy?=
 =?utf-8?B?KzRCK0VqaUlYajJaZGxwRldWZ2cyclhobnUwTXk5R1Y1UG80VDdnS3FwOFdm?=
 =?utf-8?B?U1I4RkZBQTJuNmdaTnR6cjF4eGFMT3ZiMmt3QVV3TlVpWnBwbEg1aEdITlVD?=
 =?utf-8?B?VnlDZWd3WVJJMk45RXFKNjNFdVZYSVdMaWNiKzh4RU1mV3NTSjJ1eTkxNnZI?=
 =?utf-8?B?UTBHZC9wUGkyeURidEw1REdXK0kxckxNaERXcnJncnBNRElLSGkzcG9TRnpZ?=
 =?utf-8?B?KzV6bmFTUXhNYUxIMUpuVzlhYXMwMzEwb2Q0UDMyTTBFbFVodElnUEdjc0s5?=
 =?utf-8?B?Y1ptUnViYUZOam91ZjdjWGxwN0ZYVG9NR0FHbGp6Vm13MWxDWWkrQ3pEVGVX?=
 =?utf-8?B?WG9IRThuQzNWak5obDNSNERUNzVjQ0Q2RXpxTGVwT2w2MmZhM1pZNTBWbGJp?=
 =?utf-8?B?QzNtNlJxQjJOL2NXTks4bmxBY1A2QU1jUGZnZDJwbDdDMHBmV3hwWnJrRHh2?=
 =?utf-8?B?R2JERGlxODVzNnpPcWVUdjdSa2RqenZrRThSbUJ2YUxwbmh0NEREK0FPd0sy?=
 =?utf-8?B?ckE3b1cvbldjci9uWjViTWxjQk1FOHIrc29MQStiSHBHQnNZc29oYXE3WjBy?=
 =?utf-8?B?WHVPeXdCV0xRQ2h2eVlZY2FKWXcvdkxoS0hGMXBZQnc0bzZPMjlEYTJnTlZv?=
 =?utf-8?B?NlRTSGtXV01oUjdETHRIR2ZLWEZtQ2FBWEpNKzNZcFY4Zm1jYWNFeGdmbXMy?=
 =?utf-8?B?TnJ1K3BiNE1yQ1hOTWpjTmZmNkRaeDUxdXlOcGZFMkRGSkdmdHpsOGNNb2lB?=
 =?utf-8?B?WnpqUUxmV256cHlsd1BIdEU0T1NMTlBTU0FkeUNaVEo5RTRFV05UMXBxRTQr?=
 =?utf-8?B?cEdQTTNOZTZNek55ZGVVNW5EQWhRWDAwRDFhRi9vTEFxMXJ0T3VmWjlZRW9J?=
 =?utf-8?B?NFhjS0g5TVU4em9BMkhlVlRYc2U2UUxSUlhEUTB4VXRQRHVFSnNINjNpR0pY?=
 =?utf-8?B?Y20rcURWaS9Hdk8xZGFYVU04L2R5VVZwYkh5SmJsazdjK2xaR3pBNnNENzVr?=
 =?utf-8?B?cFhhQmdxVTd4bWRVODhFQ1c3TVZic1NwbTViUUsyTEo2NklZR2Nmd3doSzhN?=
 =?utf-8?B?eG91cmNHZU1WbFcwTWdvT25HMHJ4U29PVVZBTVlDN3VWQng3Znk3MHZMVWlP?=
 =?utf-8?B?Y3QxaFRoM0Y1cU5yZWpJMFBqelRjTlZNSHNqa3ZiWmZndWkwRGJFU0JwbkFy?=
 =?utf-8?B?UGhIa0FiVmdqWC9FdmxUd2lsbTlqVEQ4QlV0VjlCczJ5VnlhMGxPWDFEd1N0?=
 =?utf-8?B?Vit4MGkrNVRLbXVJTmo1RHFRa3hSNHNIaDFuL2hqQ1MwbFBBaUZKRWt3Tmo0?=
 =?utf-8?Q?eOJUX+2gcA4sXbGiilEDHaY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F1BAAD51D937C4C9EE414F95BD09D9E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a73eeb76-a150-461e-d3f1-08dde74fc730
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 22:59:58.6212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: diu4HLLJsIp8ycr12i4xg8kGa5210Ikg+ZGm6nRubUUDjdNXf2BGYmpfteQgGxBd8Vn+vXCxsQjfDCXn4sbMBF9UHFMxjCM482D7N0ahT9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4806
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA4LTI5IGF0IDE1OjU4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEkgd2FzIHRoaW5raW5nIGFib3V0IHRoZSBCVVNZIGVycm9yIGNvZGUgYXZvaWRh
bmNlIGxvZ2ljIHRoYXQgaXMgbm93IGNhbGxlZA0KPiA+IHRkaF9kb19ub192Y3B1cygpLiBXZSBh
c3N1bWUgbm8gbmV3IGNvbmRpdGlvbnMgd2lsbCBhcHBlYXIgdGhhdCBjYXVzZSBhDQo+ID4gVERY
X09QRVJBTkRfQlVTWS4gTGlrZSBhIGd1ZXN0IG9wdC1pbiBvciBzb21ldGhpbmcuDQo+IA0KPiBB
aCwgZ290Y2hhLsKgIElmIHRoYXQgaGFwcGVucywgdGhhdCdzIGEgVERYLU1vZHVsZSBBQkkgYnJl
YWsuwqAgUHJvYmFibHkgYSBnb29kDQo+IGlkZWEgdG8gZHJpbGwgaXQgaW50byB0aGUgVERYLU1v
ZHVsZSBhdXRob3JzL2Rlc2lnbmVycyB0aGF0IEFCSSBpcyBlc3RhYmxpc2hlZA0KPiB3aGVuIGJl
aGF2aW9yIGlzIHZpc2libGUgdG8gdGhlIHVzZXIsIHJlZ2FyZGxlc3Mgb2Ygd2hldGhlciBvciBu
b3QgdGhhdA0KPiBiZWhhdmlvciBpcyBmb3JtYWxseSBkZWZpbmVkLg0KPiANCj4gTm90ZSwgYnJl
YWtpbmcgQUJJIF9jYW5fIGJlIGZpbmUsIGUuZy4gaWYgdGhlIGJlaGF2aW9yIG9mIHNvbWUgU0VB
TUNBTEwNCj4gY2hhbmdlcywgYnV0IEtWTSBkb2Vzbid0IGNhcmUuwqAgQnV0IGlmIHRoZSBURFgt
TW9kdWxlIHN1ZGRlbmx5IHN0YXJ0cyBmYWlsaW5nDQo+IGEgU0VBTUNBTEwgdGhhdCBwcmV2aW91
c2x5IHN1Y2NlZWRlZCwgdGhlbiB3ZSdyZSBnb2luZyB0byBoYXZlIGEgcHJvYmxlbS4NCg0KVGhh
bmtzISBJJ2xsIHVzZSB0aGlzIHF1b3RlLg0K

