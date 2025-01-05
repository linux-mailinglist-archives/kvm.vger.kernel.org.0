Return-Path: <kvm+bounces-34570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 335E6A01C17
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 23:13:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8450B1883132
	for <lists+kvm@lfdr.de>; Sun,  5 Jan 2025 22:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D2B1D5179;
	Sun,  5 Jan 2025 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aTrz2L/F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE94AA920;
	Sun,  5 Jan 2025 22:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736115183; cv=fail; b=lbT6tzq0JVkLKuLn7V78aocdKFNo36PBgE3IK6lq/zVCRn54Q+ubuG85nxOF8h1RdAN54teTu5EUHq5BvMGjd/DqjCJGZ4jFUVTIxqpigQC1YAYKiQCoAFGvGMsNs/vjHEWyZqiAFf+98Gj2HLrjfOB0zzg8xMOHyEw+0qchQqM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736115183; c=relaxed/simple;
	bh=jzWRyImA6vhYOyXagpHEAXyrv4uJO7z7CT3BimiCxIc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XLcTtRRLTMVe/6ZpeRiYuFh99m/z1DscLyCAuoMg6Nhr9Nz4bKR5Qwlql9C4ObVqGdtb6MdShbwTqKDvxzmNGIkKvDmG5p/RhATNqeroms8+9zT59hzQ5a5iXydRM78aqE+7NZbIQ3+nB+RULpoYewD1bCD/DYTtsclqO7b6uZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aTrz2L/F; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736115182; x=1767651182;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jzWRyImA6vhYOyXagpHEAXyrv4uJO7z7CT3BimiCxIc=;
  b=aTrz2L/FXh8tQeBuwst/yH7/xMh0KwB90BCPi/5R2Zyxy8Ku3x34rh1s
   zfTXccq7btctbGF9EE/NOcYf7UqgSrhoghD05vPXAZ+J552wXej+yD5Te
   otC3YWypHDmp24cRoranBuEcsNqB6Lx1y5NOM0ypYqyeG8H6dTuDqiFVL
   BfNarpgEdHTPdiMOzVVgwu12bugMbCx2dS8vuLKf2A7R+LiPYIZ8nEM5I
   1Zs+P9G13VQJq2MstVqlO/5HpFxdIvVVJ0gh26aygPbkdACAB/kGZkzzr
   xay49tCiWBRsSOuRfRijsyoIV0HATlI79nYJIuTEsNiZJ8wgLcgqzfFcA
   Q==;
X-CSE-ConnectionGUID: Q/zqaI8uR0Gk+yFaOir/DQ==
X-CSE-MsgGUID: Cyyx5wplSdmaHW5FdSAyQQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11306"; a="40199871"
X-IronPort-AV: E=Sophos;i="6.12,291,1728975600"; 
   d="scan'208";a="40199871"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2025 14:13:02 -0800
X-CSE-ConnectionGUID: VHUVrMrKT/GXHanS7X5VxQ==
X-CSE-MsgGUID: 3C4aTD7NROSstJrdB1GYrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="133201052"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jan 2025 14:13:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 5 Jan 2025 14:13:00 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 5 Jan 2025 14:13:00 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 5 Jan 2025 14:13:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HpBs3NVCxB2B8+L5QgfqwVj7UACdP7yMBgk1dIuth14ITN7H2eD+/CTUJzxp6zKC97m9TVQOCOcDupmTzJywOCLsBQc5ZczVj00nKfy/gGmuF+psfZkyTN2QU+ALEcGEwcsVryiRhTTH9m4BOeJBysKERr4GZS+Xz05r4xGuFhzx54x92xleSValmIfimIHhQT/T50A7qotqzlsg/ds4xqY4o0kM/CgMUh8J4k2KhcJi5Z0cgAGzerl0KQUVNrQqul6VgnYBGyF3xSDtMJpTyuMpv7xdZCf3n8W36D7Mwnh/B4KEH2nW3V7j7ot6VVXl/707TcEr265fvG3V1TOKvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jzWRyImA6vhYOyXagpHEAXyrv4uJO7z7CT3BimiCxIc=;
 b=Ud0S/lkkFTdp+c7HztthsJFuzz2QtTgkZdEbbrEArIL7G72G5U+roBrXuI63kveJSm6O+FPfALPQ0cd/yHYHmnOnM8E5E9Skpn0pdC13BBDigsh6iNp5d0Nfc2/DLi6FPLJKQZPARESdQhDGoUcU8fCs6kK/zV68WylT1xD5sRgSAh+fD5OYqXyGIQo2vbaEc2eiScoJgZhMDmDK0u3ZXE3BRxtXg29Z1I+y/cOK0ml0rdAcF+dZMkbz8n7JVWaqLALgzodzkxgX5zb1GZhSsv00GZ8g3Vhn++1wfYFdM40OxeVm59TNsNR2iDneA+KYZYElrqmXP4kVePWghyTmJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4904.namprd11.prod.outlook.com (2603:10b6:510:40::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.16; Sun, 5 Jan
 2025 22:12:55 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8314.015; Sun, 5 Jan 2025
 22:12:54 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 18/25] KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS
 extension check
Thread-Topic: [PATCH v2 18/25] KVM: TDX: Support per-VM KVM_CAP_MAX_VCPUS
 extension check
Thread-Index: AQHbKv4tKy295KkA0EqaIpyPkx2BsLMJJ+yA
Date: Sun, 5 Jan 2025 22:12:54 +0000
Message-ID: <08a02ded469a50cc6d0ae3998d9f3e2ba643c7ed.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-19-rick.p.edgecombe@intel.com>
In-Reply-To: <20241030190039.77971-19-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB4904:EE_
x-ms-office365-filtering-correlation-id: f304dfcb-33a7-49d0-922b-08dd2dd61a31
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7055299003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z0puTUNxODJFOUxnZE5pNGJsNE1oSHIwdGVBZkNZdjFrei9ta1FobVIvVXM0?=
 =?utf-8?B?V3hiRWc3akhSMENXM2pLaHBHbVdzSVNKQkpxbzBiWGdJUVRSYW9RZzVlMEZM?=
 =?utf-8?B?SWltdGx4WlBWWUY2Sk03emtZYjNkWFk2OXhRSUdBT2dvOUpadjJjRmV4Vm1E?=
 =?utf-8?B?ZHVjYVdwa0YrMXNIb2NNWXZjRXFEVE9BNDhsWDg4RmFjblg2MmRLZkJ0QzJ4?=
 =?utf-8?B?aXczR2l6eWtFMWhIK1Z3YkI2ajZBZXVwN0FoOGZ0M3NJRGF5Q1JUekxYbXp1?=
 =?utf-8?B?R0NyWklkRys5MEk3NllRc0RWNGNVUXZzQmp4VUd6SlFWRWRRblhaY3lxTzZQ?=
 =?utf-8?B?NGJaMHFRelpQcHhtSVU3MVpGbnRZYng1MDZTeVRqejk4MEwyajRqZ0pRd2J0?=
 =?utf-8?B?MWFEQjkzS3ZIODFKYUFVSDA2SUhLUHJqV3E4cUtIT29Pd1R2L2VoV252N1R2?=
 =?utf-8?B?RjVNY1JOUjlXdkFJTDVhU205NVpMdy9aSFZkWG5teEQwNG1IczRMNFpaeFRI?=
 =?utf-8?B?TCsvV3huTnBteWtJdi93K2ZlMWMxNkNibU9jNzVYQWlHWGtzRmJPRHBQVlU2?=
 =?utf-8?B?MHhxU3A3M2dvbUlWRFRscWlMOTV5MmYvSWJEckZjYVJyTU1pMDRPVHpKQmpQ?=
 =?utf-8?B?MkJkRG11T1AxWGFlWXh1OC9wMzQxNitPcUk0QS9JamV4SVNkWFdpZWlrWHhu?=
 =?utf-8?B?bThRSVB0S0ZEdlhXbVNtZGlhVVdqbEtmYTROMjhadmVQYzQwT3VoMDc0ZGRo?=
 =?utf-8?B?K05WYzYyanhCNDFuTm5TR3JMTkt1c0xzL3V1QjdFeHNvdFNaRzV5b1VlNU1O?=
 =?utf-8?B?UE9LRHQyZzlJaGhLSldVN1VyV1R3MWQ1eTlWd2VVZzJmYXRXeFZ6czFZRmdh?=
 =?utf-8?B?dGVFNGt2V3cwSlNzNTdtN1NTYzNFU3BUNGFjeE12VEpaSXdTZ1BtMXdQQjZP?=
 =?utf-8?B?U0NZWTZSVmdabVN0azhCaVMvMTB6YlMrOFBaS1hzSHBQV0VwVEZjY2orY3Fi?=
 =?utf-8?B?Vi9XNFhYZ0Y5STEveHVzN1VERmlTWFNjQVlVRTlVRGtzSytTQVd6dGdweFZk?=
 =?utf-8?B?WGlUM01PRmQ1TmRJRWVHajdFMm9DbkIydXNIblNHK0dUdlR2RHRaYm1zNzdn?=
 =?utf-8?B?S0pYcUVHUkYrN0hXL1piWG9kWXRjd3laWW1vTXZSeFZLRW9rbmJVRkZvc1M2?=
 =?utf-8?B?aWkwQzd6UmJCYW14M3NEQkVhVEdKRlJwcnVjVTlVSmtPZnkvcDdtRjBHY2E5?=
 =?utf-8?B?ano5Z3pReE9NcXdMN0ZzSUpDaVNBTFFjdFpZei9LUURTRjRFSFhEbUpEMkxm?=
 =?utf-8?B?NnpCZ0xYdVEzdmx0UjlaN1dRVkRVRWt4VnFqelFrVk9UY1V1L2lTQjY2TzY3?=
 =?utf-8?B?a1BUV01VNVZwL3dmTi9tRmhBZStNbXFuZ25tc3JMMjBIZ3paejYxdVdSTWZh?=
 =?utf-8?B?OENVdFhBcVFCWHJ0UkJHdHdyb0FiZ3RFem5NcWRIdzh0eDIrTkU4M3JJWFg2?=
 =?utf-8?B?amRwYTRZaGRkd1VyTmZjY09LNUh2b2FoVGo5MCtpczU2S0NwWkJKd1VNYi9B?=
 =?utf-8?B?dTlIbmZhWW5DeEtoUXNxdHF0K0E4OVBxWGN1Y0lxMmYzVE9XWVNGNld0RkFx?=
 =?utf-8?B?ajluYy9tRm8vdkZpRklyK0RvQUdPVDRRWUloa2FGRndSaVYwWGRuT3BNWTJS?=
 =?utf-8?B?MTdiYXVzaHZzRWdKMUJTZ29YZlB2aWl3WDNwS01IOTdXMU5BaytRTndXTG4r?=
 =?utf-8?B?L0xSZUMvV2hTVlhoWXlwK0ZtZ3NlRFZzRjR4dGllNDB4SkRTOVFFUUdsSkJr?=
 =?utf-8?B?Uy82UmJveHlwb0xlV1FIai9ETjUxV0ZKUjlhNkoxQWJlK0xyaThoZVVDd0JJ?=
 =?utf-8?B?cndOSm9UUGJwQ29YMjBSZXRvWkMyV0pCVVVDcFJ3OCszZE0xUDI5WUJsaXVR?=
 =?utf-8?B?YWoyenFZbklacVJEQlBOY28vM2c4QW9mOVN1TDE0TWNoNlBIVUc2cml6cjla?=
 =?utf-8?B?WmhwY0gxMlpRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7055299003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkhYbFI5dThWaVd4U2ZnVm8wczVOMHVFWWM4SjBRV1dnR1pySkJrRllDY2E3?=
 =?utf-8?B?YVgvWkROVEF0WnhESWhLWHorQnBlb2lvL0hYK0liS3hnb1VKOHdjM3d2MC9U?=
 =?utf-8?B?RHIwVUxTKzl3MHFuK2RzMENWN3EwS2tLemZqSjRIWWtVSXhOQlNHTFFHQjRI?=
 =?utf-8?B?Q2l6ODRDK0VwemlVSTBFZUlxemlJaGFzTHQvZG04NmdKUUt3VG1BQUpmczF1?=
 =?utf-8?B?b0xlVjlaR3I0Z1htL0FGekdSTUl0MjBtWHl4UlZmNW93SG9rWU9IYi9ERU1x?=
 =?utf-8?B?SVRPd3l3M0RQdXk0dWZvS05qWWNza2F2dngyd0dVMXdPVS9BbWV6Qm1FR05F?=
 =?utf-8?B?dW11ekVQQ1JnRXBaMEpCbzVUR1FHc2s2Mmlmajl1bTV0QXBjaVl0M0FtL09Q?=
 =?utf-8?B?ZVQ1OHp0bmhuR20yRkhZTUd3ZDRXaVpIdzM1SVorUUdGc29tc1NJNzJEVmFj?=
 =?utf-8?B?U1BreDVuOTFubW12RWhiaFBQT0hLL1k0b0JuWEpnQ1doWHI5UGI5eThkQ2xD?=
 =?utf-8?B?eTFaQ3Q3M05EbFV0Y2tVcnVFZEpFbTE5SStoenZDNjVIdW10L2o2aThKVkth?=
 =?utf-8?B?VnZhWml3ZlBhZmhmc0ZIMHZMaWpYWG16TWZuWnlydFpGdmhrdVJSRVFUeURY?=
 =?utf-8?B?aUsyYmpVS1RMaXU2VVZTL2dCTTNjZjRFaXFkSUhST0dZUUdleEN3M1NRL1Bk?=
 =?utf-8?B?aElSRHFGbVBMMnU0YlppTmN0QmMvVVBuSysweWxGNkFQdnVkc016RmlLSkhN?=
 =?utf-8?B?eTh5ZTU1Qkk3cWs4a0pmOE90VEU2UFJNMlc0bG5zSWQyTnQrUitBMVdYQmc0?=
 =?utf-8?B?NFVMWUx1SmNKdXYwVFRhNVV0TkZ3OTFYc3Y1WGJTNnRIb2Q2cEQyNnFucldi?=
 =?utf-8?B?anRKdnpKS0o4NTVvNk5oeGhCSkhORzZnb0puT3l0TGhkNUNlODhtbkZxbk1w?=
 =?utf-8?B?T0pUY0l2L3NYeVhMY1oySVgyQlN1ZU14b1VIRnFCRHNUeWQ5dFdBM2lMTlZu?=
 =?utf-8?B?MGx3SDMzMnZUK1AzTE9XK0NsLzlub3kxUytVZndzdEZTWkE2K1orbC9BSXln?=
 =?utf-8?B?STJ2Z0lLblRXU24rV1crazBXVjdCTVZ3OCt3RXU1VVV6OTMwYzFaa1VWYk1E?=
 =?utf-8?B?aUhLRWdrVGtPVFVuZ1FzUU5qMzE1MnJjL1locFo5L2J6ZVgzYWc5OS9ZUTZi?=
 =?utf-8?B?QzdraG8zei9FaE9CUnVnVFFoRW1Pa21aVW5BZ1oxK09nWTBWYVloWUdoVW9n?=
 =?utf-8?B?TUJPYk9WUS9GQ2R4aFppRWlqeDBXQ2FpczM0NGN4aGdTOXM4WG9QejJSYzRM?=
 =?utf-8?B?emRPN3dVNXlzYmRCVHV3MlJONmJ3a1hLSWZocXVQUm1XTDhLcFlHWnJFb0ZL?=
 =?utf-8?B?M2JxcXl5YUg3ZG83enIySnFaSUdGTkcxbzhLYkRXSlpMWFBjcnBmaWdXcGhE?=
 =?utf-8?B?cDNxNHByR1VaSXp6MzZWVFNlSlVFbDRDV2tXSWJkeHB3dEJicitGU2xpWGto?=
 =?utf-8?B?MS9RcDhLYjBxSkFSRWNJdXRuMzVPM0QzY3RXRGpkYTMxeDBZL0s2MUVyODgr?=
 =?utf-8?B?cDQwaDRrcWNoUEtHMndoeC9EejBuTjFjWWZxRFdLK3BkcExhUzQ2SzdPbVEv?=
 =?utf-8?B?bFM4eHdHOWVzUTE4RXdCMmJpZFlHMmd4RGdDclJMU2VadDBnbXdrVHg4Z0Mz?=
 =?utf-8?B?WHozQ3AzcHVOUW5DcFFGKzVXWDNKU3dMM1lGMTNNeEJ0aUx5RXpCUUxyVFo3?=
 =?utf-8?B?N0FxOU1qd2FHZEVtWVhGNEp6QlVYc1hSWjZWTy9VcGluNm82MGFYYlQxVlVz?=
 =?utf-8?B?MHp5NVBrZUV1K2p0dkVBUEwzdWFXY1FSeUtDanhJcTl0ZXR1a0RKbmY4a3NJ?=
 =?utf-8?B?bDVIcWNRMmF6NEJ4eFRvaXQ5K1QwL0kyc1hZc21VanpINXNRSmorT3pPRThG?=
 =?utf-8?B?Ti9XWnJxVFVONUtBSE02c3BpQW9pVHlmblZqZFdMbTRjc2tHT3ZsQU1xUG5o?=
 =?utf-8?B?S0VRTWpEclorSTdUOGJFanZ6WTYyVEJIYXUxQ1pKVkFmYTkzblU2K290dHRV?=
 =?utf-8?B?WnFLd1RwUXQ1dllBaVlZd3dPaGtISmR3WkVSWTVTTFBIL0V5M203d0Q3bTY1?=
 =?utf-8?Q?hlsoVaxTXy17hnb1QPwHCnaA8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B930EB0E5DE4554995A33D9FBB39EA0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f304dfcb-33a7-49d0-922b-08dd2dd61a31
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2025 22:12:54.1713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C+DZxIVGQLT64UNWji5tCOK3gPSatzlmv2SlJ7+OfNIE5Pz6iqlDcCQrb/mS/1C9NHZ9EvC8Yn6OPBtkYWVnTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4904
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTMwIGF0IDEyOjAwIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gTm90ZSBzb21lIG9sZCBtb2R1bGVzIG1heSBhbHNvIG5vdCBzdXBwb3J0IHRoaXMgbWV0YWRh
dGEsIGluIHdoaWNoIGNhc2UNCj4gdGhlIGxpbWl0IGlzIFUxNl9NQVguDQoNCitEYXZlIGZvciBh
IHNpZGUgdG9waWMuDQoNCkkgdGhpbmsgd2Ugc2hvdWxkIGRlbGV0ZSB0aGlzIHNlbnRlbmNlIGlu
IHRoZSBuZXcgdmVyc2lvbiBvZiB0aGlzIHBhdGNoIHNpbmNlDQp0aGlzIHNlbnRlbmNlIGlzIG5v
dyBvYnNvbGV0ZSB3aGljaCB0aGUgbmV3IHBhdGNoIHRvIHJlYWQgZXNzZW50aWFsIG1ldGFkYXRh
IGZvcg0KS1ZNLg0KDQpUaGlzIHNlbnRlbmNlIHdhcyBuZWVkZWQgc2luY2Ugb3JpZ2luYWxseSB3
ZSBoYWQgY29kZSB0byBkbyAocHNldWRvKToNCg0KICBpZiAocmVhZF9zeXNfbWV0YWRhdGFfZmll
bGQoTUFYX1ZDUFVTX1BFUl9URCwgJnRkX2NvbmYtPm1heF92Y3B1c19wZXJfdGQpKQ0KICAgICAg
dGRfY29uZi0+bWF4X3ZjcHVzX3Blcl90ZCA9IFUxNl9NQVg7DQoNCk5vdyB0aGUgYWJvdmUgY29k
ZSBpcyByZW1vdmVkIGluIHRoZSBwYXRjaCB3aGljaCByZWFkcyBlc3NlbnRpYWwgbWV0YWRhdGEg
Zm9yDQpLVk0sIGFuZCByZWFkaW5nIGZhaWx1cmUgb2YgdGhpcyBtZXRhZGF0YSB3aWxsIGJlIGZh
dGFsIGp1c3QgbGlrZSByZWFkaW5nDQpvdGhlcnMuDQoNCkl0IHdhcyByZW1vdmVkIGJlY2F1c2Ug
d2hlbiBJIHdhcyB0cnlpbmcgdG8gYXZvaWQgc3BlY2lhbCBoYW5kbGluZyBpbiB0aGUgdGhlDQpw
eXRob24gc2NyaXB0IHdoZW4gZ2VuZXJhdGluZyB0aGUgbWV0YWRhdGEgcmVhZGluZyBjb2RlLCBJ
IGZvdW5kIHRoZSBOT19CUlBfTU9EDQpmZWF0dXJlIHdhcyBpbnRyb2R1Y2VkIHRvIHRoZSBtb2R1
bGUgd2F5IGFmdGVyIHRoZSBNQVhfVkNQVVNfUEVSX1REIG1ldGFkYXRhIHdhcw0KYWRkZWQsIHRo
ZXJlZm9yZSBwcmFjdGljYWxseSB0aGlzIGZpZWxkIHdpbGwgYWx3YXlzIGJlIHByZXNlbnQgZm9y
IHRoZSBtb2R1bGVzDQp0aGF0IExpbnV4IHN1cHBvcnQuDQoNClBsZWFzZSBsZXQgbWUga25vdyBp
ZiB5b3UgaGF2ZSBkaWZmZXJlbnQgb3BpbmlvbiwgaS5lLiwgd2Ugc2hvdWxkIHN0aWxsIGRvIHRo
ZQ0Kb2xkIHdheSBpbiB0aGUgcGF0Y2ggd2hpY2ggcmVhZHMgZXNzZW50aWFsIG1ldGFkYXRhIGZv
ciBLVk0/DQo=

