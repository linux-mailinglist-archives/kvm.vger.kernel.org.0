Return-Path: <kvm+bounces-55506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F54B31D2D
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 17:03:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD4203BA915
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 14:56:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC713308F3D;
	Fri, 22 Aug 2025 14:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JnsMxJfG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B821D26AA83;
	Fri, 22 Aug 2025 14:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755874564; cv=fail; b=UcL2ikiHmglHuGt1xBjB3VhEczDVe9rcVW1yeN7pzbH4glJPVGo50gB/9boaCWMQ64ofbpYmzbCjXZwzasNOnajOLMDNqZqBNz188Zg+/4Ly9oW/eZsAjjSPcQZ03Ij4hJWO2XoFp3d5g+rV2I10YtEJVgW1eQ68M28dwi73FKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755874564; c=relaxed/simple;
	bh=vDJE+2lsfuum0Yrgf8c16doshD5FkkpwznbdQNI04JQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gaWePt3Oh8J8BfOxsCPUiSLLe+RGyci9zgZZzs/NLTbF2pOBPbZC2CXJ/ISdoXJbGfNteAIQGXOKE6sd7TE6RaKOa/ELqHrL58tm4cBn4HIT414ec5BLUJZXM3chyHEqqJmJ22Wb9/KO20QiFnIchqQouzS2j+if95bx2uq2xHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JnsMxJfG; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755874561; x=1787410561;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vDJE+2lsfuum0Yrgf8c16doshD5FkkpwznbdQNI04JQ=;
  b=JnsMxJfGix9tu10qVhGsRo+CmCix3s2vROO+fmty0AjKSuhXHTDrOnrV
   adU6vlhJhE/zTS6apyJgfQUD/uKv21f16vm79QnjUQmaomescF5/7bBOw
   oW7alTAYyk9LrpIhe/Jn9hsffvWXkjzkPDhwrt2yHxRAkriJ2X39hgu60
   EHO/SaOrQ8VZfCDhCpQMJBDYOy3v0MIou5+zX7p8EG/T/xodmex+tIExZ
   BfoSgsUyKdiRdX41SFEwfxlqXPyyup8TDabpTb0llk9mUa0o+sdnOGD+Q
   n3VtjRdvJvdSiaoQJEmq59SPdNJ8L8UC6XyPN4jNBfgstaszqQ18uCnsM
   g==;
X-CSE-ConnectionGUID: fA56aqwnQyyhvvBGCbYPNQ==
X-CSE-MsgGUID: fSMIrSQuRD26lzFVXNkXaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="57200901"
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="57200901"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 07:54:29 -0700
X-CSE-ConnectionGUID: i2rgHsaNTa+hrLvnRkcgjA==
X-CSE-MsgGUID: AM4LqszfTZ2qI21R0qUuDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,309,1747724400"; 
   d="scan'208";a="172920649"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2025 07:54:29 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 07:54:28 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 22 Aug 2025 07:54:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.62)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 07:54:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eesjv+6BPHtmLzuNj4uhALTwUpv9TKRoGAIGMvGnRGVstVvoefRaxN83tjHzhYmAksYXToTBh4v0X5BJ0LfDDTpv8iSdgIfdZXa638R0PmaPpZ2wo3BspwyOiF2PKWtRsV8PP1uSJYpgsFSzLA7lpc3KtWVMLb7AfyNdJSZsqJLwnI7cVpbCE3xPuIeDk63D/gf9at8x04NKXCAKoqS3+MstHLsKhnYwzVXP1GZrIeizihP8V1nGyzr0JDTxE+0KS54zvcPhSePfLCYdaHqySXnvrGdXwvlx0RZavp7y4IPMXxSF4yIRPy7w0FdrLuOzIrW89gfkak/NNc29dBvXqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h+lu1HvKT0mO/4I0iLSuQiswO5yV/Q7vUPSmBVm7Bzc=;
 b=GG47nX7RbsMItQuX4KvOJX+0vJoJaqiYgxahuHi6UFYjKo2hBPC7u1GbmnJhUfxqKn+8nL2QG7JOJLCm89UggjnNrhgyIHPjBdAnO23aViUEFlRfjn4inzXl2QoxBgvBsYBq922YmZZVS3MEz64jJ3zK9KKruTfpUlKqHI3k67Dgz7Zn5Xl6ycAkmTWdwoWjxjfvRyM2WvJZxfmLpNpLRtqy3J9YoAWiJKdHhFbn/Ih+kcqoQshuMmoipZ4tic0gG+pjGu/vnP1J2Pgz779iFqBY9mPL4KUA/6u/bHBw6rO/8TbH5YXrNT059pTo2XUaanI/BbeqgHElL+ofUZXRrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by IA3PR11MB9254.namprd11.prod.outlook.com (2603:10b6:208:573::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Fri, 22 Aug
 2025 14:54:25 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 14:54:25 +0000
Message-ID: <fcadc80b-aefd-4a22-b910-70d9c97fa5b3@intel.com>
Date: Fri, 22 Aug 2025 17:54:18 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: Borislav Petkov <bp@alien8.de>
CC: Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck
	<tony.luck@intel.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, Fan Du <fan.du@intel.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>, <yan.y.zhao@intel.com>,
	<chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819213247.GJaKTtf1er-Ced_mzP@fat_crate.local>
 <10587d02-1133-45fa-9ec8-2288a8868b68@intel.com>
 <20250821132521.GDaKceQXfEWHVwrlxV@fat_crate.local>
 <441aaf76-977f-487e-9db8-80edcda6078f@intel.com>
 <20250822135422.GDaKh2jhb5ooQ6QOe9@fat_crate.local>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250822135422.GDaKh2jhb5ooQ6QOe9@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0104.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bb::17) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|IA3PR11MB9254:EE_
X-MS-Office365-Filtering-Correlation-Id: cf2e32cf-af65-4198-7889-08dde18bc921
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SVlVSUZ1RDdIQ3pvMm94SCtYRHRIR3JTSVdmSHNwY0ZaNDE4MTMrYWtybmhN?=
 =?utf-8?B?SUkyblZFTlUySDRwV0pxQy81Szh4VVptQnlYVlMzMGV4L3hoME1hRkhnR2to?=
 =?utf-8?B?empEdjZWaHg1RWl5SG43UHJMVzJQc1BuMGpqWU4xTXorSHFzUC9zeVpEcUor?=
 =?utf-8?B?T1JLa2VzcW1DK0E4bGVtUTB0MmY1Vng0VFA1a2N2NmFFWmIzTDZ1QmEvaGEv?=
 =?utf-8?B?NU1xS3NxYUJSSHd3YjR0eXNkRkR6SGo0TlBmWnlUaUVKZTRzWkVQV3FFSlM1?=
 =?utf-8?B?NUVVcFFtTnhkRDNmRlA2VjVaUUplK3pEeVljQ1VEUEo2enJ1L3VEN0NwanND?=
 =?utf-8?B?Q2Y4WVZMRnVXK0RacDVPL1BDT0NWZ2RvN2FheVZKTm9SM3dobTJncmRSL1NF?=
 =?utf-8?B?bndrSTBYOU1Fb1BYSld2dGpNYnBnbmNTVC9CUnZraFFmZDAwQVhJam1YYVEy?=
 =?utf-8?B?OHVZd1Q0S3R2aWY3VFZLTGs0V2dldk1oOHMrR0VUZkpCVG5nN0szUlEydzIz?=
 =?utf-8?B?clgzOWxRT2pCTzJkTFNUSUwrY3MvOVRDMnJqQm5hMHVmRnZPOW9mT1JpZDRh?=
 =?utf-8?B?eWY3OXh0TVJGUmdCSUFtQ0E1Z2d5ajlOSTRMZDkzaEJieHZWZnB6UzgvV1Ni?=
 =?utf-8?B?ejEwSU5UcXdQK3BSQjZKWVVkU3RJb0pKMW9DREdUWWo4RHcrVUVaSlVQdlJ2?=
 =?utf-8?B?b2oyNGVqU0szUGVKcHJ0MDJNdnB4M01FYmpVbm5yamZCaHlmOHFRVngrOHVh?=
 =?utf-8?B?RmhpTmdDUFloNFNIRk1JSkVWY1NKRHIzYXhYby9ibHJydTV3ajhjMW5zbzZ6?=
 =?utf-8?B?SHZYakRNamtpOUVxS2MzM2FHL2w4djVCVlBDWmlLQ2k2bGNlNmlGNHJyQ1Q2?=
 =?utf-8?B?d1lQb3BLVjJKWVZybTY2Q3RCNzZ0dlE1NFZpaTE5QnZCMk9WblY0enFZcG4v?=
 =?utf-8?B?MTZRR2JiMUxXbnkxNUU0SnpyQkcyVW92NTV2RDFFdE9LZU05VkJJTzN4UVE0?=
 =?utf-8?B?OTJhbTl5Z1E2emZWekFGTkFZUnEvU0tpcExNOUlDMjRCemZaMDE4MG1YMG5h?=
 =?utf-8?B?YjFIYk14YUhYbkIvYU81d0g0aFRHMXNxcy9NR2UyVjNqS0JVcU14SXFIRGUy?=
 =?utf-8?B?Y1V4WnpFNWEwbHpqcjY1VXIvUDB4QU1iL0ZaTVhtQXhiSjU1ZXJ1dHBrYjJN?=
 =?utf-8?B?dG00OWpXRWh5OHdBNmNBNW1WcXpiTFFGa0I5R2dvbHQ0elMvYjJaQ2ZZYnNh?=
 =?utf-8?B?Z0hpWi80UGRaamJTMW5hdW9TWWtjbUl4TytoVHFaWTRGbkJrRkcyZlpYYXM2?=
 =?utf-8?B?RFp4d3Fac3ByVE9sd1JoQ2daaU5SWHVnQmNKVXpLVGl0R3ZjSW5TZkxCbHlS?=
 =?utf-8?B?b3p5anAvUk8vaTVBbDdSZ21OUW94QU5TS2Qvd0NXTnF1aTloTVZlcEVpV3pT?=
 =?utf-8?B?ck1YeTlKOU9TNzVXZ2w3Q0ZLVGZGa1FKVlJqRW5SOTlpNlBYSG1SWXFFeWZD?=
 =?utf-8?B?Qm1URmh5ZjZ4aUp2aFFrcDMxWUFkSU5KNDhFYjdIc2p5dnVQWGJuK3NaWlJ2?=
 =?utf-8?B?cHl2NWtOMnF2U1R5RytUWXBleUxoMVFpYTFUM1NqNzRBaStZVEs3OVJBWmkz?=
 =?utf-8?B?ZFp2NmZBbitqUFBERVdNM2szck15ZDZYQjBNdmFZd0JmMG1NL0tuR2N0dkVR?=
 =?utf-8?B?REJWSVJ2LzNSaGU1bE9yNWhlcTVhN2xid1JjejMveXcwRFpBcHQyOUhNbnVF?=
 =?utf-8?B?SFhGY1E2UzFTTVRHM0NTWVNPNWYvTlZ2bnNrMGdZUi9YMFc1QWVXK3E2TGUy?=
 =?utf-8?B?NUxxcE1XTmRQK3RhcGQzV0sxRngyWnhQc1Bxdkt3KzhmcEQvbXkrbFdQWDhs?=
 =?utf-8?B?eUFwVmxoTWhIRmJhOVlIZWwzZ1V1TEs4YzlKTE95UXo5OVZzditDbHphSXlC?=
 =?utf-8?Q?HQ8aIIy1vDM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d3ltYmZsWjZvT3Z1TEhDbTlMdkdack5xWVd0NjQ3Yk15NTh4ZmROM2h5Z1dy?=
 =?utf-8?B?d3dmY0RUc0ZOaVBiYVRMV2FOeG5jWm1JN3ZxODJhZVJaNDVGQlNkVU1GOGJQ?=
 =?utf-8?B?OGZlVHlHZUVzbE1maGFJRngvNHVyVG1HdEp2VXNnSlJLQUloMDNmT2s3ZjNG?=
 =?utf-8?B?R0pYdWt5SzhJb1p1dEQwNEtrQTlsQVJQUDM2ZE91UVVJeVZ1MDBwT21za3B1?=
 =?utf-8?B?ZEpDSGZMSU1DbWxhQXkzV1hZRElsUE5MUnErQSsvNWxhREcvU1pXQmsvbU9u?=
 =?utf-8?B?cXkrWjNLeHZuWncxSjBPZSt2RnpyaHdCeXo4aG5UMzZMRmZrNno3VXNxK3Fy?=
 =?utf-8?B?K3dLWjAwVldNelpGcVpuZmw3ZTJzWkVoR2ZaSkdZTk9WT3N3anFrMWpvTHlo?=
 =?utf-8?B?M282U042VWp3Wno3TlluVHJxZ3kzQVpFYW9WMUg5YzVIeSttUDI1Q05SZmM2?=
 =?utf-8?B?QTBIZENiRjRZdlUzUk5WanJyWWFRRkNTcGVPNHFwUEJqSXJXbjdpRkhMVkd3?=
 =?utf-8?B?SkVMV3ZnQmJZUk9EUmdoZ21iY0kzQVlPM1JEV2lRT0JGVzBCcXFnejJpVVor?=
 =?utf-8?B?UjJHNldzRkhmUElSMzBtWU5ibVd2Z3R6WkpxN2dxWGttbzlKT05iQmpVK21v?=
 =?utf-8?B?OFJrempqdWN2UVZUTEw4OFZtVEFIdW9tRnY4NGFUaTVhOWE2Qkp6SzRiSnda?=
 =?utf-8?B?M2dYbm9QeFV5Slo2ZzgrTkQyY3ZwdTBXc1VMZDNnUGdpeVlQTGl1bjJnSG8z?=
 =?utf-8?B?RzJKQTVKak9laUdhUVlxNUs2dTcrLzAwZHZXa1lWbDQvWE1YTEFkaWNxUHhV?=
 =?utf-8?B?VFIyaEpjZ1BVNUdqaGtoZkJxN1I2VWpmbUpGdXVNRkhWaFBicXpKaGsyQlM1?=
 =?utf-8?B?d0xRWXJPZE0ycG8yMzJadmM3dEJva21ONzI1U2ZodC9tQnZVTEhUSGZoUDd1?=
 =?utf-8?B?czZVNXBaVUNBWE1XbzVWcnIvNE5MSjZ5K1AyNnhTYTFGNWJCNTZIWDZ1TWJ4?=
 =?utf-8?B?MFVoeTNyblMrR1VlV2lhdy9paWpuTW5YR0xubkYxOVJWdG5OTUd1MUtOdEYy?=
 =?utf-8?B?WU5SSGxpekFEODhzSTgvZHV2K3BNSmozQTBQNDZxRjhWTmRYdXVMcXczajlt?=
 =?utf-8?B?aS9HUlBoRHlEWm9kY21vOEszQWlXV1BXQnI5dU1NMDIydFoyb0M4Z2tFUnNF?=
 =?utf-8?B?ZnBmQ0p2UHpiSk5BbE1KMHh6RVdCZGt2bGtCNDFrZ1cwRFlJVWN5UStJVkkz?=
 =?utf-8?B?L3Z4Y25ONGs1WnZrVk5IamZYRVFzZEhrVjFIMC90RzJ1WUlKSXp1NWJLT3ZJ?=
 =?utf-8?B?VnJ3dy9WNWM0TG1EVC9UbXQ3V3FPTDVmS0t2U1poZ0pEUTJTcGtpeHVxTHk3?=
 =?utf-8?B?djVmWXVHZ0dnRjV6R0NnNXQvR3FzVUpaaE0wNXorN3ZNQk5oWmNnYmNuWE5I?=
 =?utf-8?B?QmFwVHF0MVpDNGlqTWU3Zmo0SklaMjduMlpseUFhaFVzWkdaVGl3UVd5M1VO?=
 =?utf-8?B?eXNsNEJNZ1ZlaFViT0NVbG9oczVab04rdFh3NnIzSkhuYzJNbjVubTRzRk5I?=
 =?utf-8?B?a0lBSkNNRkppcGREWk1MUUUybTdSanF2c1BpRExOU0d6QW1NL2FSSXZpQVcr?=
 =?utf-8?B?TEFuWUpCNkxhVTd5bUpvSjlGajFoMWRMUFBJRCtOck4vYmYwYnNJNUpVN3hX?=
 =?utf-8?B?MEhqTEJPYXczdzlsaVVjMXlZTDd6dmJnbERDRFlXKzdxckpuRUJsSlkrUmdI?=
 =?utf-8?B?WnFjSjVVVTV4ajd0R0hqeGVhd0NtRnM3ZVZYdkRueWNqbHNQZmc1UllDVmJW?=
 =?utf-8?B?MnlUVUxDU0c3eS9zZDc1QnRRZ1ZWbVNMVWRlalNkT3JvWWdoQzRveVV4VzZ5?=
 =?utf-8?B?bURMakZqYzhsVGRhRGY5QXZVZzV6K0hUZFJ0eGRZSlBzSXBmOHJqMElvK1RB?=
 =?utf-8?B?SUNaNWV5dDRicW1EanJjcGduUC8yQ21iaEwwYnZFWDIrRndxeW1MNEpWNEt0?=
 =?utf-8?B?MERBV1pGczFxUC9QQ0s2YzVCMjNLTy9INFF4bGhYSHhCNDdxVURkYlA3ZWdV?=
 =?utf-8?B?VjFMWEpWNU4yTHY3OVhQVmliVXB5b3QrNjhnVDd5UHQ3NzVLdFZFc0p1ZWJj?=
 =?utf-8?B?SEJLRnJPVnRsZUhFZWRHUVM1dlVWUkx6bXozNGZIZnUyZGJSeGJMUGVWemdz?=
 =?utf-8?B?Z3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf2e32cf-af65-4198-7889-08dde18bc921
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 14:54:25.0617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQCy68ZhuUpHkG38wUjfmpvKQrderOoHl8NzubnthDtpjjUU2+r4LWX86kgrqyg81xsmz+Iesb91meJLrZ/dRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9254
X-OriginatorOrg: intel.com

On 22/08/2025 16:54, Borislav Petkov wrote:
> On Fri, Aug 22, 2025 at 10:57:36AM +0300, Adrian Hunter wrote:
>> Not exactly.  I just want to fix the bug whereby the mce handler fails
>> to mark the affected page as poisoned because it does not remove the KeyID
>> from the address before looking-up the page.
> 
> Lemme ask this differently then: are you ever going to need KeyID in mci_addr?

No

> 
>> No one expects to find non-address bits in struct mce addr,
> 
> You're preaching to the choir - I don't know whose idea it was to shove
> a key ID in an address value... it sure sounds silly.
> 
>> However, it is allowed to extend struct mce, so adding KeyID or raw MCI ADDR
>> later is quite possible.
> 
> Why would you want to do that? Do you have a use case?
> 
> If not, you can drop that whole angle about adding KeyID later

Droppin' it.


