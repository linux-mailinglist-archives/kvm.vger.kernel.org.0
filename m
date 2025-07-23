Return-Path: <kvm+bounces-53265-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 669EFB0F71E
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25DDAAA7C83
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:33:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024491F3B8A;
	Wed, 23 Jul 2025 15:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D7yJHDSE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B770F1DED4C;
	Wed, 23 Jul 2025 15:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753284833; cv=fail; b=tqZG+jYO2vHDbHJUD5fKTssum2ZDAVQH8ORIffOqKGXHnUMPe8iv+yPsdErkEJOLZnns9wpqgRgPA2LxMZsuKe8neI2fi5CU7+wFjXgxmX7uMSX7yt4gPqdrNntlmztJgZa4UyE5Gkz9agYF1GFn6dMQnNLrP5aqMtKzsUmp55g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753284833; c=relaxed/simple;
	bh=bgPmj8noyk4I43Jk94w39MXowQTQAbdGxNKxMAHC+oQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bB22+KTW1UW+OdUqNnFyjfFiwD4ahgQTlpAOpSQE9PY9IF8vHQ432ZWk7wa+1SGYwwBfnRwjczZcWgIfy4TQQwQ4F7JHaj23lLRrpp7EQTI99xHXh9porI5FRKgYIhu28Nu5w1jotYLkORYtAqSf6T40W85wFGIEAoMxLzhB5yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D7yJHDSE; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753284832; x=1784820832;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bgPmj8noyk4I43Jk94w39MXowQTQAbdGxNKxMAHC+oQ=;
  b=D7yJHDSEkA7R+LPecGRMToTMix9acX3eZxr14BICMnVVF5y6Wz5dzVt5
   uSoKRDFn4wa1dvrkAwXe5qBbzs/8fPskXTHRITLQffvzJF1IyNXaWvo95
   z0HV1fs0ZSXzBwYiyehCw7aEdh6brw8k17u5eFAHRqq5r04WM2vzXj8my
   QT9hRo/fTvWXcKxDMB6Ev7NvZiTQgUkRKsfysRJo5uF+0phIW2/7reh/Q
   +fSAV8352i0aFU/TJ3eJYccSPx8IrGStYRTLjq1g3dza7543Rc0tMMPps
   qOpGJ2ESaEVexB42gNduwZ82WL9TmlSaJJAT5O9gytoH14+3ZFE+4o9Sz
   w==;
X-CSE-ConnectionGUID: 2f/kzw+NRlC/VVbOJD9YxA==
X-CSE-MsgGUID: 6XiCP4nWR6G7A3dkFeHNxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55720888"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55720888"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:33:44 -0700
X-CSE-ConnectionGUID: 59FaVUy2Qg2PpJZAHPinbA==
X-CSE-MsgGUID: EmnWd6LIRNGNJyviJzBwjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163799470"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 08:33:34 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 08:33:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 23 Jul 2025 08:33:32 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.79)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 23 Jul 2025 08:33:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WTXECa/YS1hhZrd1fWeJ5bq6E4TuFJ0M+omtOo1UC89WkgzH/GRXb+cI9IOsD0xkyb7gKOywILYADlJ4gK+JvO9oZaz/k0qyapNcawL1pDAJOSE/kWMCkzoHpT6kBQEoperR7prI2CFz7/6uVAqK2H318xrxdeZ1NklSuKwfnLE8WtL4QVv2dFjgTY2mx6VqGuOgREui0ty8YT+chOc5pXZz4aa083am2zd4q3OwNaEE+ePnXvYwHUJz4Ws+RHQFOrZrPrMwWq++M8crFsyVaEY83XbayBge+Oyg853t8cKYY0WRWH414CpOVpG35sJdvnsQI4/kfZSF3VirkNEY1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgPmj8noyk4I43Jk94w39MXowQTQAbdGxNKxMAHC+oQ=;
 b=ZlxWn3SOwvUj/hicyYg8IQGYMc5mnSsbCsFwTDg1IFJZ9Tu+r7+OEhZevuUZT82nFh1Akcjcc3suXbp4YMfPL/sMjHFhIV40RgSq+8rpKJfH2i/DrOeU4jUNlO8vbMQeukbMBSvev7lUq7E36VNQgO684pr/kXaIWfC7Dn1dwHA+vhWEl+4g7A8QKRlLRN5xcpnWPzmTxtIpENOg8lilJJb1ZjBly8C0Q1r6cBoexKT46W8Q9Oc+KKMQ7BIK5kAEexEh7MeFd8WDXeN/W64LAqARd3MAeT0SQtOfwc7wS9wgp2MmFkr7CsruILd7bE+3aCM1H4ZLV5Mu3bP3vSJ8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6309.namprd11.prod.outlook.com (2603:10b6:8:a8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 23 Jul
 2025 15:33:28 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 15:33:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "bp@alien8.de"
	<bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Topic: [PATCH V4 1/2] x86/tdx: Eliminate duplicate code in
 tdx_clear_page()
Thread-Index: AQHb+8ovx0yLPSIy6USdKkSakZSGBrQ/vkCAgAAI0oCAAAHTgIAADQeAgAAAxIA=
Date: Wed, 23 Jul 2025 15:33:28 +0000
Message-ID: <6d91fc951cd39110db8f9b5565e88dba39eecfcc.camel@intel.com>
References: <20250723120539.122752-1-adrian.hunter@intel.com>
	 <20250723120539.122752-2-adrian.hunter@intel.com>
	 <f7f99ab69867a547e3d7ef4f73a9307c3874ad6f.camel@intel.com>
	 <ee2f8d16-be3c-403e-8b9c-e5bec6d010ce@intel.com>
	 <4b7190de91c59a5d5b3fdbb39174e4e48c69f9e7.camel@intel.com>
	 <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
In-Reply-To: <7e54649c-7eb2-444f-849b-7ced20a5bb05@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6309:EE_
x-ms-office365-filtering-correlation-id: f3fbb526-df9b-40c2-172c-08ddc9fe4579
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cko4RXRkVmhuT2Y1VGhDcE8yWlpveFhWTWJ2THBxV2dLY09BbWZMZzY5UkdO?=
 =?utf-8?B?MGYwYkYvbFpCMGtuKzdoM2dmckR1U3IzQ2lnZm9NNFNGQ3d1eTBpN3pVRWVY?=
 =?utf-8?B?VHFsMDBURjQ5Zno1RTlYWTR2dHMwVUVOYWhhNEJJRTNWOEU4SWlUd3ZKRzlU?=
 =?utf-8?B?OEY0UlJXQlBJWTBqdks3alJjNVB5UzNIZElQTi9ONzVTbW5MMFgybHpUWGV3?=
 =?utf-8?B?aG9ydDVZc3dtMkp4QUdGaFcwUDJjMWEwUHNPQUJEYUtFZXRMaCsrTWw1NGh0?=
 =?utf-8?B?MVF3Smw5allKcWd0d2ZiVGxJbjQ4akZlaFNNM0pFWG1Lczl0eUZJYkVkSzRJ?=
 =?utf-8?B?SU4vTnlYMTBkSzBkRG5BVzBmVU9GWWhTVkVTR0YxS3dVdGRKTWx3VXdMSzFM?=
 =?utf-8?B?Q05UWUI3akVFcVFIbCtvSk9TV0ZyU2I4SEtzQzdONUdHc1B0b3duelYxQXNS?=
 =?utf-8?B?d01mSW9QcUtmUlBQNjlOazYvejNycmpoMzdSRFFmcGVXUHl1ZGcxUFkzYWh5?=
 =?utf-8?B?U2k0V1dlSThtem5pbGhMWStpRkIrVnNOUm05Z1FHMEhpY0tjNUR1S1NlWFVh?=
 =?utf-8?B?cEhGdnFML0hiM1ZvK2l1d2lVTUZmV1MvRlRGMGRHOC9BdE1XYlljVVY4bno0?=
 =?utf-8?B?Um1IQmpaTnluYlZvVDMzeWdGT1lGMStoZEpRZDc2bEFVTThsRUJSclgzeGc0?=
 =?utf-8?B?SWttVGhnTERqSXBueVIxYzRCY0FwR1lOKzdlYisxTXdIbk1nanF5a2ZkekxU?=
 =?utf-8?B?czIxM2xsOXExZFY5UVkrZGpWR3NPZENCSURkbGViRkQ4VU9nZ0p6aFpUaU1J?=
 =?utf-8?B?SDMyZkFXaEJ2WjgyM1JLcWMzNnB2YnhLa3lQci9aa2hJRHYwUVNYRWNNOEJY?=
 =?utf-8?B?VTNIQXVDb3lIbjI1K1RQK2lXVnVzYjFvelI3ZlpwUndRN0RWRGxHbW9aRlBn?=
 =?utf-8?B?aTJqY2FTVm55NW53ajVubUE3YWhoanpXRmQvcVZxUjhNOWZpd2I2UVQvWXFD?=
 =?utf-8?B?c25UUGRJZVAxNDdOak1aMU41Z0IzNGtsM0tEOTJTdTdWZ0FsWS9DOERNayti?=
 =?utf-8?B?TEtBRWRGdlVQMWZMaDlZdGl3NU5rZnhVdGs4MG5vdmtwNjdRSk9qR2FmSGQ0?=
 =?utf-8?B?VjFTUWlEMXI0dVFWWTdsTHI0ZFJRUHdSd2lhVkh4bTBGUmVtd01TRFBjNE5i?=
 =?utf-8?B?YlhJc0tUa1JNUjJQQXhlYzhteXdibXA0aVdrZUtVT3gvRkgzQmk1ZDIyUEp6?=
 =?utf-8?B?VllkMm1LT0xBalNpYVlzMEV1WXgySDQ4RkFYVWZCaWdJMFpVMWhweGxwRk50?=
 =?utf-8?B?Kzd5YVp3N2ZaYnlJQ20wUXdNUjZoTWNTYkpjL0dsZEN2ZDJyNm9yck9rQnVV?=
 =?utf-8?B?YUh3RTF5TVdlVDBhS2wrZTF2YmtPQXJCdUtOWDVVWnZ4Wkp1dEVqdzJLOTIy?=
 =?utf-8?B?L1NrejBBdkFoSHBqUVN2VDJzT1UrOTFETVZyYWcxdXZ1WVBsS1laYWtCNmdS?=
 =?utf-8?B?VHZjMm9VTzZ0OERFb1NTcnhlM1Qzak9WNFJ3SjBtRFJQS2FTU2RDY0lhMlNm?=
 =?utf-8?B?NWdBekwxVXlaT2F4SlVTclZweXpHUlBkQ3pDZjc2M2E2Nm4wMml4MHQ0T0Y0?=
 =?utf-8?B?MFBDU3VJWXN1a2hiV1dkMWpmNzVZTXU4VFl0cXNRWG1DZUw1K2pyVWNnZmd3?=
 =?utf-8?B?OFZGdmNIMUU5TEFsZzhnQXA1NXE4SmNpWFp0K1N1QWE5alpRbXFVUmFLZnpt?=
 =?utf-8?B?NDl6MFkvSWViZHJnNDFoWWNMWTAwWVdCaks5aytoUit1Q25xZGlodE5CUnFk?=
 =?utf-8?B?M1FkUUtRN0hPQzcrWnJXRnlXOElWSmRFOHRtRWNoV3hkaWdzSUtVVXBBKzI4?=
 =?utf-8?B?eWw0bDVsTm45emphcjZ4QmxSQkVJRVFPR2VxYzVIamNUdENHdk1EZzRFM1VK?=
 =?utf-8?B?ZUR0RFFPaUVMb0VLakVNcWh1dGZQajNqcnJ4NHdld2luVjhBblMyWVJhdzE4?=
 =?utf-8?Q?J+Y7lGa47ugZ7nE0tuwuJnIRqhpBP4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWpzZEhkTkg2bytMYXJzWjRxUmhEZXRIZ0Q5b2hmMFE0TTU5U0xxbVFQRmsx?=
 =?utf-8?B?UTZvb0FvNGMxRWw0UFB2dm1vZ0dYYzFSSWNieGxXVTJNK0VjUE5LR2V6NHF0?=
 =?utf-8?B?d1JmeU54ZStPSGpxdlBsQ2NRZ2FxSEdENDQrSlIwWFJQTDRpTkhIZmh4SVNV?=
 =?utf-8?B?RjNwVDFRaVRYOUVSTnR3N2lnRjV6TVVrRlFxd2cyWGNaL1ZVSU9vaC9tRElU?=
 =?utf-8?B?d3h0S0ZoRlBnSWtnK0NqcVpwQ3ZrR2pWRnU3a3FsVUZVdlArWmM4V0YyZmdq?=
 =?utf-8?B?WEtic29acEQ2bTFCQ1FYcVd1UnhSUFNJeE81R2o4bzZLQngyZ21ab1M4a3c5?=
 =?utf-8?B?QlZ0bFg0TE9uQllPVDBYVlpuL2hnRVlhZ1hWWmozQW82d1p0NkJidVJNaDZX?=
 =?utf-8?B?aHVkeDQrVXVPOWFzdmhJNThXNDd2MlhXZTZTd1FaZE5vUGVza1pwVEJ6WW1H?=
 =?utf-8?B?L1VZbnJwVTFwL1l6K0xhdDc2TUozdm9nMkhCemloRXZmUGIzUzBScE5CazB1?=
 =?utf-8?B?eHdIT2tGSFpuNTErQXlTUmpUdUZoQytHdDVqQXNxVnlWanJlV09JTUJ0UmR5?=
 =?utf-8?B?Q0JaYnZia1dGQk5SMFZwVFVKOWhxRUIwWlFsTUxHWklqcnBRaE10N3A4eGpo?=
 =?utf-8?B?MVBlYys0aHFiUzR6aE5pTTVzdFV2bmJwOU1uSmlaczBQSjJmY202Q2VkdkdF?=
 =?utf-8?B?M1VjTHlNUjdGNEhzRjNZbnhxQnJ5MG1VNWtBMUorWTF4ck5FdkkyWUFDazZB?=
 =?utf-8?B?bTZFTkI4SHovYmE4VjgrNmhEdEhkNVMwMTg5K01naDM4V0JDSlFRY2FIUkxj?=
 =?utf-8?B?akJORDl3UjlmMStRUllZSDdlMFRNckVGL0h0OHRhUVc1SjYxa2I4b3FSTHIz?=
 =?utf-8?B?M0twRFprdkpjNmpyVytaN3h2bzFWVnJCQlFXanBDNitzNUpKMXU1bVEzckxD?=
 =?utf-8?B?YTRNL1MzODlwVHpHYjZxUUJjTGVKWjM4cjJHRnlJTk8wdkxxcy9BQ1UwdnFn?=
 =?utf-8?B?T0dlL3FXV3kzMWZyano2TFBMZmw3QTdwem5oSDRxZkpYVnZ3a1NUdGdCTFZS?=
 =?utf-8?B?V2ExWHR2a05BYmw2N1lBRFJyN243ckQzZ01ybS9NN3BOdUVCUXVpcWRqRWJi?=
 =?utf-8?B?SEIvOEJFbXAyaVc5ckVnSmdCQklscGZDR2hzcmV5REtRL1lKTTZyaXpMR1Ny?=
 =?utf-8?B?SXdDcnlqeU1PUnBHaFdRSmU2cHFxN2RFT2VJclIwMUEvVEdtaTRPaERKMXJk?=
 =?utf-8?B?OWdWZGRlMWtBSkpPWHRMZktzT09WdDRKYlNvNXFvOS9xdzJDbVNpUnFEenRm?=
 =?utf-8?B?NnE4VDFMNlR5T1ZOZFJVMHAyeXRYNGgwbnE1b3VrVVFzWEpQUDZJTEZkS1Zt?=
 =?utf-8?B?SEdINXFycDdscU9ySjlYUjY4VXpYcjBuR3JseXhyallFbmd3SU1rQ0JPS1Vp?=
 =?utf-8?B?MUVYSHN3TnFhemdwUXMrL1RQL2lhVlN1QXh6UEgyYXdJWEJpZE1YVDZlaGdR?=
 =?utf-8?B?N0FteCsxTjVFZzZha1JtaEhmb3NNTWM2YWNzSzZRRFFnYm9lWk9HZk9ZWWVN?=
 =?utf-8?B?U2tBN0duVllQd1RsbEpmTjlUL0sySDFFNWZSRG5OaURpTGJDYy8va054SC9q?=
 =?utf-8?B?c3kzOEo0VTcraG5ubk1wWTVzLzMxVjNrZVJMYm9PdXpGc2FwREg4b29wajdV?=
 =?utf-8?B?aitaSWtBdUxBMFhaN1hzeHNMUnB1YlVzVzQzblFuMDNVZTNISjJIaXlGMFFI?=
 =?utf-8?B?OU5McDEzc3MwL0RId0I3SzlRVXhrOTBRQW1oVzQwUTZ0L1cyQnpoVkl0NXl0?=
 =?utf-8?B?ZjdFT3lqTlVrc2pYZnNlNWQxT1ZPRUtHSnI4NjVGVC92Y3A4aFI3aEV0Rm5J?=
 =?utf-8?B?TG43REhzeUZmRWhIK1FWSmVIUEp3enI3YmtmeEF6dnREL2ZQZC8zSFV4b3lo?=
 =?utf-8?B?R2F1QkxEdmlubFMzTUlDcnRRM2R0dU1hTVljMXlaaU9ISFJaZlJzU3FsWVda?=
 =?utf-8?B?YkNCOFMrMHhmUW1YRitlUTRiNzRLZkV3ODBUVGFPRHk4a2pNSVMvL2xQNTM2?=
 =?utf-8?B?aVdFUDlCTVp3RUZMZ3VoVGVIV3ZtbXhBMmIxdW41cGREaDA1YlR4MWlIdjVj?=
 =?utf-8?B?c2NLN0l4Nm5WYUNlWjFvTEViTmFGY0RRaVJCY25VOGRCMW1aTVpWalhyZ0hl?=
 =?utf-8?B?ckE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E009196872AD1443BD7FAA631E35F635@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3fbb526-df9b-40c2-172c-08ddc9fe4579
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2025 15:33:28.0886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fHrr1jtlfYyk77qxUumiZJAIpG80VETFNevw6QTl6VwluJJBMglT2blQuRUJ+xU+yB2qVeRBGNw3Ya10gSRN3u0X8mc6uPu6knDKcbeMgcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6309
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTIzIGF0IDE4OjMwICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiA+IFRoZSBsb2cgc2hvdWxkIGV4cGxhaW4gd2h5IGl0J3Mgb2sgdG8gY2hhbmdlIG5vdywgd2l0
aCByZXNwZWN0IHRvIHRoZQ0KPiA+IHJlYXNvbmluZw0KPiA+IGluIHRoZSBjb21tZW50IHRoYXQg
aXMgYmVpbmcgcmVtb3ZlZC4NCj4gDQo+IEl0IG1ha2VzIG1vcmUgc2Vuc2UgYWZ0ZXJ3YXJkcyBi
ZWNhdXNlIHRoZW4gaXQgY2FuIHJlZmVyIHRvIHRoZQ0KPiBmdW5jdGlvbmFsIGNoYW5nZToNCg0K
Q2xlYW51cHMgZmlyc3QgaXMgdGhlIG5vcm0uIFRoaXMgZG9lc24ndCBzZWVtIGxpa2UgYSBzcGVj
aWFsIHNpdHVhdGlvbi4gRGlkIHlvdQ0KdHJ5IHRvIHJlLWFycmFuZ2UgaXQ/DQo=

