Return-Path: <kvm+bounces-71371-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id lDLcBlmPl2kD0gIAu9opvQ
	(envelope-from <kvm+bounces-71371-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 23:31:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F531163319
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 23:31:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CD4A2302DF4B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 22:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D644329E5B;
	Thu, 19 Feb 2026 22:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N6Jbnbs3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC61328469B;
	Thu, 19 Feb 2026 22:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771540292; cv=fail; b=sGJVl0/50NexxfR79OnTo2mojt6XqcFmQDV2yZsMc+OSRAKwJOOjSvF3ZynRkCsYpjO7EZUklt46Qe+x6I9dDOtLWZ8KsCupT3DdqPdb1Zak8H0n5KKRre1AQliCF0FB7JbRT7/za9du/lbcXcL9qh3v+0Kz6rHf52aUnDgf+lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771540292; c=relaxed/simple;
	bh=sPkOiodIVtj9Urpn+ZmF6Ftngl+REkOIRj9r/0fPy3I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JnXCjoQ1Q0tocrayXdkc3/aqSDvAwPMn9MxuX8heWxDqHWsaDGMlGw22QYNMtGxNnDeEMdKw15/+/IgLmJVO+CtcSlJTkWW9+oGwnakD5k0VpECASl3A/YlxB6ZH4fHz+b8C2rSzInjEABJ6JidU8UJlLzoHWiPthpRZdd8Zqfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N6Jbnbs3; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771540290; x=1803076290;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sPkOiodIVtj9Urpn+ZmF6Ftngl+REkOIRj9r/0fPy3I=;
  b=N6Jbnbs3lD8kumsXNUQs9QDOIxuufe+4cEa5mbp6+MSQuJLgBuI+EEM+
   sFIN6uSS9AKhm0y08pmEK54YG4dVGv4PpQIltG97dkiauTm3IxM1aruUs
   x/83+rTVKBBiQsApC3yT18vAcSGv7RIHZtEZnQFmUD/xEDhRC+lhZiTPU
   uaIHLICz63YcYS5IGbw8fGX1aorSut7vgUegRgrRgXCVs2K9FF+O4GfjM
   4/mzcQwDB+o5r+suboOQsr0RnIBgzBcl1L8hi0yojGTnqpQu7F+XPA+Tx
   hg9nNRh67MFq5588eQfo2MBiEf44/rBIrJ5YLmJ+BEYoWW2J48z/JwP2M
   g==;
X-CSE-ConnectionGUID: XxMEfG0xSZm6mXbuPaGH4Q==
X-CSE-MsgGUID: M+jDVuSsS6iGP8Z2kA8FdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="83355960"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="83355960"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 14:31:29 -0800
X-CSE-ConnectionGUID: vSYRgzimSu2fyDEEVef3HA==
X-CSE-MsgGUID: LjhX8DgKT5uE4ET8n5swYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="214794206"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 14:31:30 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 14:31:29 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 14:31:29 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.15) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 14:31:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t6WyldVREGeCJ1ySGoHthKLyAGaLRgZ8gbAeNVoQJqXKguNdQY0hL+MZ23WwQtFxF47Hwp1Qk23+t3ICSITF53kRnP0HcBiIGhp3KQ0nKswv3MTew7Fjtewfb06DkZgiKEOoQmsu7ob7Ir16xpNYA1c0t4v83HxKea56dxuz27Tke0cmDCn86Vm+ef/HHPNDvJmT29hOvs9QK4XoBgw+zoyk+vcB4NHBpmaOkwUNBJauvP9SdrtvAFbG71ozS6d65VsODDSB43bw6YlVp01f2N94POqAM/CVwg+vIySVMgt210dVhlTb521ZIMi1jhOIgU3TRb7Hy5vJDAtOCZncIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPkOiodIVtj9Urpn+ZmF6Ftngl+REkOIRj9r/0fPy3I=;
 b=gEHWCwWbCRtQGWT+gZRMY8JzNkPHn1tw4IrfBjXaBoABnZdRr8C9+d7TNBHfbjNUx29AsS+qLE/hHsovYDVQVwCh3QRq4LtXKRzHbUC32cjm513RM3kCgFyCdqahF/XlnveLVjMt2jgfPjVGK63kCphIn+idEpSYKdAriNwqptTOeDg5qxSFN7T/E99reEL58iB52OHSkGc4k9g3vqf/V9evQbdmLULSjOHv4HF1vyNyeKjkgvag6bI2u5mP7L3YmdtyTYFauB9A7znOy4LcniAsIpvZCyZUb8IWN7Lhj5OKkqhO1abW0nxyRjQMkDoLsJypMtkbAv3YejOCryyM+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 PH0PR11MB4981.namprd11.prod.outlook.com (2603:10b6:510:39::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.16; Thu, 19 Feb 2026 22:31:25 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 22:31:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 10/24] x86/virt/seamldr: Allocate and populate a module
 update request
Thread-Topic: [PATCH v4 10/24] x86/virt/seamldr: Allocate and populate a
 module update request
Thread-Index: AQHcnCz7Hw4x5dVNOEG5CoBzcugQtbWKppgA
Date: Thu, 19 Feb 2026 22:31:24 +0000
Message-ID: <1aa733f9066dd85c1d4f880c5c48b40c76d518c7.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-11-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-11-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|PH0PR11MB4981:EE_
x-ms-office365-filtering-correlation-id: 4f2dd7f3-593a-4ac2-f525-08de70069d88
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NEJ6S0orczVxNkxqdmdQOHdjUDd5clljT0cvVGdKZ1JVSmhlTWVOeHFCWFAz?=
 =?utf-8?B?UW0zKzBpQXdhYmlIWTRmcnVBK3ZuekpaOGh4QTBPcldpZFVuRVpObHlsYnhZ?=
 =?utf-8?B?MG9CNjhyS25LZFBLKzlEQ0ZaUDZVUVdpaUUwZjRLRWJ0MXhzQkNQTXA4Mzdp?=
 =?utf-8?B?MXBaVEpCZG5PYjZqemNPdXFzRTMrL0E5Ym1tRzlvYnpYZ3pJMWZRWXlZK0U0?=
 =?utf-8?B?ejRMK3V4Q2xNL2thNFZ1TTk1cUFLSitwcGJLZ3l0Mzh2V0RTMkFiTXR3RVBo?=
 =?utf-8?B?VktEVGdvWjUvUG5ZdFR1TURoVXJtQ2UveUUyTm9kTDAwdDdxeFlkK1E5TEcr?=
 =?utf-8?B?TS94UW13RWVIeGZha3dWNGxaOVFSdllQcVhTMnRpanNlQktMUGNqZVhxQ3Bz?=
 =?utf-8?B?Znl2QmhkMSt5MWtBbEtMa1dUdWN4U1NuQkxKYnAwVHdSelhuRnpjeVZQdWln?=
 =?utf-8?B?eFdHd2JhTi9FU0dlVFFxNTFmVmM4SUtBVjlHVE1WcFJrOENWSTNVNlBmRmlo?=
 =?utf-8?B?TGEralBWMnR3cC9SMmd0bHkvdmxKNzByTWE0TkhKVDhxTUhyTGQzbitZeXFX?=
 =?utf-8?B?bjgxSitZMnQxR0llY2FXekdXc1hlZG1KZmF2RUkwemRQMy94MlBpSkhIclc5?=
 =?utf-8?B?Q3V6dG0vVGp2SE9aY2R4YVQ1L05Oa0RiYXNzVXhZSEg1MHNmZzl3OXh6bUlp?=
 =?utf-8?B?MGhES0psRVFvNTJJS05Ua0lnU2ZBWXpNZlVLSG12RzVLZnd0M29talJyMGNU?=
 =?utf-8?B?WC9BY1dQSjZ5RHNwS2lXQkk3S3dkQ0Z5eDd5QStvYUo3WndoMk9wdkdMdXZO?=
 =?utf-8?B?OW8xenlWV2R0K1FrSkhRZjIwUWNCaXhYYVRyWStMTW4rTWZCdHJqTW1qai9t?=
 =?utf-8?B?QU05ZHBXeUN0ZUQveTd0blVMaUViSkV2VjZWTVhpL0FDaEtJVVFSRzI0Vzhv?=
 =?utf-8?B?V3llckx2OXZBdVh4dGtOaUZPc0JLUnpWRmg1dEVhMmNQQnpWbUwxUy9WNnU1?=
 =?utf-8?B?UkdXMEJKNUxsdFlOdy8rTUxEME1xMTlMOStPOXhzTlhwcWV5K3Flc3AzVEZC?=
 =?utf-8?B?a05VcUlGdzRydlBBWGlmOG1McHdLTkRSUkUzalRMaWtQT29wUUE0akZkOTd3?=
 =?utf-8?B?emsrVUVWcitBbFl1T3A0b2ZCcnF6L2lKS0dDWUFRK3V3SlZHTjMxQldQSHBo?=
 =?utf-8?B?TFVDL0FSbDhPTkxSTFVhMFRYSHMxVjdlYldLa3QvcFZLSmVJV3l3UmJQUEo1?=
 =?utf-8?B?c1pwMHpSQ1ZXc0lRb3NVczFZVWlKTHZGSW9mbTNLWHl5WUFacld6dlFRbjVU?=
 =?utf-8?B?Z2doZE1xb3hUd1laTFlHKyswdHl0ZXMvaGloRzNabXdmNHRldDJJNldpREgv?=
 =?utf-8?B?K2xQS1h1cHNOczFZWVhOYzdnbnhSM1V6RUZ5Qm9ndzR5TFhIbzNQUCs0UmtI?=
 =?utf-8?B?UVlDMndQaWdSa1hqVEcxcVp5TkN0cC9vZnFpQXZ3a2EzdjhoYldpc21KWHRK?=
 =?utf-8?B?bkgyME84WEs5Wk15QkgvVEU0dkZ5TmNLUXFsOWxPUnhKU3Y5bVduVWtpdnZH?=
 =?utf-8?B?MFVlcFdGQy9FTEg5SmsxOVlDYTNxOGU3L3JGWjhmTUJRQ04ydU5SVGdGZTZU?=
 =?utf-8?B?MHVTZUFVcG9pSkxnV3BJbmgxeTBqNWRnWm0vdEJXWTc1VXdCbHRHckJHMzBD?=
 =?utf-8?B?NnZkQzZWL0hIaTZBY0hMajZOMUZncmR3L3VtdTFHTGUzLzNuVC8vV210ays2?=
 =?utf-8?B?cHBUdHdFTHJXYmk4TW5oZWx3QnlDU3prMUdQSWs4MmJxZGxPZHd3Zkdha0RQ?=
 =?utf-8?B?Z1JKNXVEd3hUVk9WQTRXWUlvbDlGNDE4Uzhra2RaQ2dabDBNZUNqU0JFQ01l?=
 =?utf-8?B?TDVjcTB1TGNTMEk2WkJTY0VWbkNUVjNiSlhnWFZoeDRnTzNBdEJsRUZEUWoy?=
 =?utf-8?B?STdMVjZGak9VMUl2Yk5oYTgyUUpHSUFUUVFNc2hoTHVBTDRVMnlLUUxRc3lr?=
 =?utf-8?B?MDdPMHhqV1VHK3RHMVRKUDhsOE1rRGxvNWw1WSt1RDYyZEFFeXZra2NHc1Nx?=
 =?utf-8?B?cTZIb1YxRkNFOVNaWGZRS0I1bWpPUXlyVWNraGxFU3U0NU1ucVQ0ZDNUTWVr?=
 =?utf-8?B?aUZPNnZFK2c3VENaeGdveml6NURoOE1NR0ErTllrK3VGaGpxRHB1QUV3SW44?=
 =?utf-8?Q?Zi9H2ScWQHqgV4sfdRP9cMoWjWS4yOf1aoIRdWlKXv9w?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZTZRb1p0NEdydGZoeS92cHcxTld5Qi9odXByR09WK1A4a0xIL2hVTVBwc3My?=
 =?utf-8?B?Sld4MWk5V09ObnZFVCtVNHdCQWVEeFVMU0tjdExIY1RHalduaDVieDlnOGNs?=
 =?utf-8?B?VU1OZWt0d1ZFR0h1NjgwamFhRktvZENNOE53OVY5RmRiWXFsaWlMK2phTzFY?=
 =?utf-8?B?UUJzMm1MZVVHS1pxKzZRdC9BQnI3ZnF6UlNydmhQMU5EdCtqQWpoU21ORlFB?=
 =?utf-8?B?MnJRWkdianJZUnVjbisyTFhaSjNqM1REU3Q0ZUpXVm1HZXJmSHhSemRmVWRp?=
 =?utf-8?B?akpSdkdrRWZOeHZMbTRBc2x6QTZKeVdXVmIyNEFRQ01TRmk5QXZwSDA1NGhG?=
 =?utf-8?B?Z1NZdmIzaC8vcHdtOTBoUGdXeFhqcGNpRkFtZHFFdVhLbGpZZkFRUTZGejM4?=
 =?utf-8?B?NkRESHJJTmJZN045ZmRMSS9tNDB0dkx2YWVWYjZPZjI3WGZZYkJaVTVvV1Jq?=
 =?utf-8?B?Z1JuTzBqaTFkM1krYnQwWTV5M3NCZWFSZ29ZRlFjNUZIdUNQY3B2cjIwblRX?=
 =?utf-8?B?Q1RJRFgxeHI5KzFMMSs4VjZYV1RrbThCcW0vMDdsRXdjNGpUeDJUSEwxNVF5?=
 =?utf-8?B?WWtIQ2gvMEJYeVZsRTV0Tm10TEQ0Rmp3UXRUaXA1MTkzTXNoSmJqM3BqR0NP?=
 =?utf-8?B?czRVbng0bVdUOU9pa0hoS3hXZVA2bUdOV1dUN0VnUll4dEhYYnVmenpnVE9u?=
 =?utf-8?B?ZytjdWREc0dJN2VpVCtycnIvakVjcXhEeUJFc1FyTkdURGZBbnVTUHIrMkxo?=
 =?utf-8?B?alIyakVFaGh4UnZMTzhITHIxeVp6QS9ETFdqTEd3SFc2Q2UxalVWUEsrN0xJ?=
 =?utf-8?B?Sm13K1RLRndlWUMvVVdTR2YzL2Z5SWswRHIrRTVMaDR4YVAxUTRzRFZEd25T?=
 =?utf-8?B?QWJVWkNORjA0Y3A3UDYvdUxDbXV1cnloNUVWYzhWTmxHVTR2QXpJdmwzcldE?=
 =?utf-8?B?V2VOdk9jUXowc2FEdTRRTU1BaXM2OS9hb0JSYUlLWVUwQUxJVlYxMHhNdEZP?=
 =?utf-8?B?dEJVc0ExeU54UVIzZ1Boc2tYa0xCVDdDYi9vUzUzOE05Z3Y4SU9mR0twK09n?=
 =?utf-8?B?TmxTUDl6NWhINkVsYlp4cTJvRkdSOXAwN0dlNllkcXQzME80QllDaXFJQ3pk?=
 =?utf-8?B?VUJPUS9sNDgwZHdGQjNiU01kdHVtVWQ5UU9sQVB5K1BxMGhPSWdzcHF5NnY4?=
 =?utf-8?B?TXZMZXJRUiswcUE2bkE4ZHpNdFpHa245Y1dpdkluNkp6MnYraFFESXF6WUdW?=
 =?utf-8?B?bmNxcnVRUTl3RGM2aHhlWUU3WVpBdnI1a09JL3BENkovRjJrU0h4WUMvWVkx?=
 =?utf-8?B?WDFaNlNGVkw5MlhYM1prWUtaU1kxOWpxTzYvVEloK0pRWEJ5SGJoWVB6cDFL?=
 =?utf-8?B?V1RMem1RcU13R2t5bU45YlRtUS9KOTk5eXB6SUlSdkdJWmJ3WXFFUE5WVXcz?=
 =?utf-8?B?UE9oMFBEYjVIdDZjcUZGcnV0SFVMSmV3MVRjMEtRaTFzbTlPMjN4NGU3WVds?=
 =?utf-8?B?T0pYamI5K0R3Z2U4Nm5kK1AxY2Qyd0Yxa01iNndRekYraGJZdjdzeVhLUkg4?=
 =?utf-8?B?Y2lpeVNicjE0VEhOTFFIS2tmdmdSN3dNZm1xcjJjVnJJR1Yxek9MalhEN09Q?=
 =?utf-8?B?bnhQU3hoNHI2MGxjWFAzYVBINU9uMHl3dXZjV1NLZmlkTUVjL201WVA0d0lV?=
 =?utf-8?B?M3FEK3JhZHpoNW1YRmFkVmZNUjhqQ05vaTFrYjhoM1Rrc09LSFRrY3JBYU53?=
 =?utf-8?B?dW9HQURRTFJxNkF6RWs3NjlVdHlScEpCYUVtY0Q2cGhpT1QvN1djcnQxVWJG?=
 =?utf-8?B?TnBHMjhLV092azZES3dTZWRrNThWZmhaNFk2L0Ric2l6QitmK3JuTGN0M1Rv?=
 =?utf-8?B?aDQwT2xhZDRJMnpVa3k1YzlKZ2NURk1HVHFJV2gyV1BMNnZYdmlleHJxcnUy?=
 =?utf-8?B?eURrdUN2aVJCTm16YzVVMXFyUU1nLzJjOGdIMWl1ZnpiV0hJN0xSZGNuT1RD?=
 =?utf-8?B?VTN0cmpnODhQQ3FReXZSZUgyZFhVT2dvczBJTnRqMFYxOUJZWE5leXBiTzRJ?=
 =?utf-8?B?VWJ4ZzRGZDJnQ0xtN24rK3l3MGNUdFlQR1NVbXlkc3lpUE5KMVczaDhMc0k3?=
 =?utf-8?B?UnFYYWNwdFI4T1pHTEhLRDJ6TEN6QitIZWRKbHIzK2FYNHVrUElpUjIzbnJr?=
 =?utf-8?B?MmUzV0hycWtxSWx3Vm50d3dwV0FFSjB3WitJNlRSQmZDbVdXR0U4SUhucTdh?=
 =?utf-8?B?Mk1zbDluR28rYjBMMFZBZFpMVnJLeVZzNUgxV21DSDd6d0xsWncyb25qM1Bl?=
 =?utf-8?B?RktteTJnemtZNTRtLzg4c01ZWXgwMk1lcGZYaFZ5cUhqaHQ3Q0RuQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CA4506A2DF21F47B228655D348E1FDD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f2dd7f3-593a-4ac2-f525-08de70069d88
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2026 22:31:24.8141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CNbKYtMZnixO9Ave06ld1y8fk4BNld52piGW5dzbfckuu2AuZip//nhdQ4Kb9dsCDoxDsWcnK4dfAlI7WqIhVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4981
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71371-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:email];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6F531163319
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gUC1T
RUFNTERSIHVzZXMgdGhlIFNFQU1MRFJfUEFSQU1TIHN0cnVjdHVyZSB0byBkZXNjcmliZSBURFgg
TW9kdWxlDQo+IHVwZGF0ZSByZXF1ZXN0cy4gVGhpcyBzdHJ1Y3R1cmUgY29udGFpbnMgcGh5c2lj
YWwgYWRkcmVzc2VzIHBvaW50aW5nIHRvDQo+IHRoZSBtb2R1bGUgYmluYXJ5IGFuZCBpdHMgc2ln
bmF0dXJlIGZpbGUgKG9yIHNpZ3N0cnVjdCksIGFsb25nIHdpdGggYW4NCj4gdXBkYXRlIHNjZW5h
cmlvIGZpZWxkLg0KPiANCj4gVERYIE1vZHVsZXMgYXJlIGRpc3RyaWJ1dGVkIGluIHRoZSB0ZHhf
YmxvYiBmb3JtYXQgZGVmaW5lZCBhdCBbMV0uIEENCj4gdGR4X2Jsb2IgY29udGFpbnMgYSBoZWFk
ZXIsIHNpZ3N0cnVjdCwgYW5kIG1vZHVsZSBiaW5hcnkuIFRoaXMgaXMgYWxzbw0KPiB0aGUgZm9y
bWF0IHN1cHBsaWVkIGJ5IHRoZSB1c2Vyc3BhY2UgdG8gdGhlIGtlcm5lbC4NCj4gDQo+IFBhcnNl
IHRoZSB0ZHhfYmxvYiBmb3JtYXQgYW5kIHBvcHVsYXRlIGEgU0VBTUxEUl9QQVJBTVMgc3RydWN0
dXJlDQo+IGFjY29yZGluZ2x5LiBUaGlzIHN0cnVjdHVyZSB3aWxsIGJlIHBhc3NlZCB0byBQLVNF
QU1MRFIgdG8gaW5pdGlhdGUgdGhlDQo+IHVwZGF0ZS4NCj4gDQo+IE5vdGUgdGhhdCB0aGUgc2ln
c3RydWN0X3BhIGZpZWxkIGluIFNFQU1MRFJfUEFSQU1TIGhhcyBiZWVuIGV4dGVuZGVkIHRvDQo+
IGEgNC1lbGVtZW50IGFycmF5LiBUaGUgdXBkYXRlZCAiU0VBTSBMb2FkZXIgKFNFQU1MRFIpIElu
dGVyZmFjZQ0KPiBTcGVjaWZpY2F0aW9uIiB3aWxsIGJlIHB1Ymxpc2hlZCBzZXBhcmF0ZWx5LiBU
aGUga2VybmVsIGRvZXMgbm90DQo+IHZhbGlkYXRlIFAtU0VBTUxEUiBjb21wYXRpYmlsaXR5IChm
b3IgZXhhbXBsZSwgd2hldGhlciBpdCBzdXBwb3J0cyA0S0INCj4gb3IgMTZLQiBzaWdzdHJ1Y3Qp
O8KgDQo+IA0KDQpOaXQ6DQoNClRoaXMgc291bmRzIGxpa2UgdGhlIGtlcm5lbCBjYW4gdmFsaWRh
dGUgYnV0IGNob29zZXMgbm90IHRvLiAgQnV0IEkgdGhvdWdodA0KdGhlIGZhY3QgaXMgdGhlIGtl
cm5lbCBjYW5ub3QgdmFsaWRhdGUgYmVjYXVzZSB0aGVyZSdzIG5vIFAtU0VBTUxEUiBBQkkgdG8N
CmVudW1lcmF0ZSBzdWNoIGNvbXBhdGliaWxpdHk/DQoNCj4gdXNlcnNwYWNlIG11c3QgZW5zdXJl
IHRoZSBQLVNFQU1MRFIgdmVyc2lvbiBpcw0KPiBjb21wYXRpYmxlIHdpdGggdGhlIHNlbGVjdGVk
IFREWCBNb2R1bGUgYnkgY2hlY2tpbmcgdGhlIG1pbmltdW0NCj4gUC1TRUFNTERSIHZlcnNpb24g
cmVxdWlyZW1lbnRzIGF0IFsyXS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gR2FvIDxjaGFv
Lmdhb0BpbnRlbC5jb20+DQo+IFJldmlld2VkLWJ5OiBUb255IExpbmRncmVuIDx0b255LmxpbmRn
cmVuQGxpbnV4LmludGVsLmNvbT4NCj4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL2ludGVsL2Nv
bmZpZGVudGlhbC1jb21wdXRpbmcudGR4LnRkeC1tb2R1bGUuYmluYXJpZXMvYmxvYi9tYWluL2Js
b2Jfc3RydWN0dXJlLnR4dCAjIFsxXQ0KPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwv
Y29uZmlkZW50aWFsLWNvbXB1dGluZy50ZHgudGR4LW1vZHVsZS5iaW5hcmllcy9ibG9iL21haW4v
bWFwcGluZ19maWxlLmpzb24gIyBbMl0NCj4gDQoNCk5pdDoNCg0KQXMgbWVudGlvbmVkIGluIHYz
LCBjYW4gdGhlIGxpbmsgYmUgY29uc2lkZXJlZCBhcyAic3RhYmxlIiwgZS5nLiwgd29uJ3QNCmRp
c2FwcGVhciBjb3VwbGUgb2YgeWVhcnMgbGF0ZXI/DQoNCk5vdCBzdXJlIHdlIHNob3VsZCBqdXN0
IGhhdmUgYSBkb2N1bWVudGF0aW9uIHBhdGNoIGZvciAndGR4X2Jsb2InIGxheW91dC4gIEkNCnN1
c3BlY3QgdGhlIGNvbnRlbnQgd29uJ3QgYmUgY2hhbmdlZCBpbiB0aGUgZnV0dXJlIGFueXdheSwg
YXQgbGVhc3QgZm9yDQpmb3Jlc2VlYWJsZSBmdXR1cmUsIGdpdmVuIHlvdSBoYXZlIGFscmVhZHkg
dXBkYXRlZCB0aGUgc2lnc3RydWN0IHBhcnQuDQoNCldlIGNhbiBpbmNsdWRlIHRoZSBsaW5rcyB0
byB0aGUgYWN0dWFsIGRvYyB0b28sIGFuZCBpZiBuZWNlc3NhcmlseSwgcG9pbnQNCm91dCB0aGUg
bGlua3MgbWF5IGdldCB1cGRhdGVkIGluIHRoZSBmdXR1cmUuICBXZSBjYW4gYWN0dWFsbHkgdXBk
YXRlIHRoZQ0KbGlua3MgaWYgdGhleSBhcmUgaW4gc29tZSBkb2MuDQoNClsuLi5dDQoNCj4gKy8q
DQo+ICsgKiBJbnRlbCBURFggTW9kdWxlIGJsb2IuIEl0cyBmb3JtYXQgaXMgZGVmaW5lZCBhdDoN
Cj4gKyAqIGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC90ZHgtbW9kdWxlLWJpbmFyaWVzL2Jsb2Iv
bWFpbi9ibG9iX3N0cnVjdHVyZS50eHQNCj4gKyAqDQo+ICsgKiBOb3RlIHRoaXMgc3RydWN0dXJl
IGRpZmZlcnMgZnJvbSB0aGUgcmVmZXJlbmNlIGFib3ZlOiB0aGUgdHdvIHZhcmlhYmxlLWxlbmd0
aA0KPiArICogZmllbGRzICJAc2lnc3RydWN0IiBhbmQgIkBtb2R1bGUiIGFyZSByZXByZXNlbnRl
ZCBhcyBhIHNpbmdsZSAiQGRhdGEiIGZpZWxkDQo+ICsgKiBoZXJlIGFuZCBzcGxpdCBwcm9ncmFt
bWF0aWNhbGx5IHVzaW5nIHRoZSBvZmZzZXRfb2ZfbW9kdWxlIHZhbHVlLg0KPiArICovDQo+ICtz
dHJ1Y3QgdGR4X2Jsb2Igew0KPiArCXUxNgl2ZXJzaW9uOw0KPiArCXUxNgljaGVja3N1bTsNCj4g
Kwl1MzIJb2Zmc2V0X29mX21vZHVsZTsNCj4gKwl1OAlzaWduYXR1cmVbOF07DQo+ICsJdTMyCWxl
bmd0aDsNCj4gKwl1MzIJcmVzdjA7DQo+ICsJdTY0CXJlc3YxWzUwOV07DQo+ICsJdTgJZGF0YVtd
Ow0KPiArfSBfX3BhY2tlZDsNCg0KTml0Og0KDQpJdCBhcHBlYXJlZCB5b3Ugc2FpZCB5b3Ugd2ls
bCBzL3Jlc3YvcnN2ZCBpbiB2My4NCg0KSSBkb24ndCBxdWl0ZSBtaW5kIGlmIG90aGVyIHBlb3Bs
ZSBhcmUgZmluZSB3aXRoICdyZXN2Jy4gIE9yIHlvdSBjYW4gc3BlbGwNCm91dCAncmVzZXJ2ZWQn
IGluIGZ1bGwgdG8gbWF0Y2ggdGhlIG9uZSBpbiAnc3RydWN0IHNlYW1sZHJfcGFyYW1zJyBhYm92
ZS4NCg0KVXAgdG8geW91Lg0KDQpUaGUgcmVzdCBMR1RNLg0K

