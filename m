Return-Path: <kvm+bounces-59545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CD0A2BBF1AE
	for <lists+kvm@lfdr.de>; Mon, 06 Oct 2025 21:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A8C4E4EAA7E
	for <lists+kvm@lfdr.de>; Mon,  6 Oct 2025 19:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AF3248176;
	Mon,  6 Oct 2025 19:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K33t+hNn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5362D1D54FA;
	Mon,  6 Oct 2025 19:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759779255; cv=fail; b=J28082hK5oDK3wxbmtiOxXxFIi02+LLuX9DeEjpyQBDrhyGCFlvjb4dZmnS/PDEYevcVsYA1d8JVZgaY8c4qEQBv/xglxN3Cpcrc8KpkygNP/1UaWT8nnpc/rZnqn8UQMxSSeQj9Txft3PBEC/gN6jA+7OH6KdwqT943GpUdSm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759779255; c=relaxed/simple;
	bh=M4+QPocNtu+XBX/TshfzhagAYiFwDNDEb3MjKUW0Ick=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pytKmA4LvVjXm7LqWEj+bXJ6N6bRfrXMEaf5csvhwHSBBFOn+dN4DM7ggiSQNWlYqdu1Xmafr+yktJGBCmFBx723b9OHgfAvKJxkgdaHczvuYGHbF6qjer93sLFcRSLZE/O/yjtYt05XBySqI3CrbWScT8VG5EgesINT8S+3Fv0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K33t+hNn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759779254; x=1791315254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M4+QPocNtu+XBX/TshfzhagAYiFwDNDEb3MjKUW0Ick=;
  b=K33t+hNnO79GuIwxVFuc1jRLd+90T97BpCaEjdxQ5BaAMAxwR9OjPGdy
   67PCY2FM67IYx53x/5ArgXjfzP1ZrQZmK5ouClXQb/cUTvHkH8XHFRcx9
   KfKPgRQSkkohyKJcksYGXSO8OAKwm9Rdqnu44kIH7lWS7sPZ8AlYv3utz
   OKa9lupnqkScJ+PTAeRquFIFvQujlARXyVJ5WzjhOqrRG1e9PuZNLfl7T
   UancikF51aWAAK69zyZJly4tyAdkSaddHSIc8Fj9o2NF20Df+o+sZRVi1
   0lWzcZs+d4Pja5qkauw/JSx8+7DucogxLCmWn67fIFznhSeCrLgNaS+s9
   A==;
X-CSE-ConnectionGUID: nvKWlfD3TE+jBfNPS39K1A==
X-CSE-MsgGUID: 6TFkOTY0TuuZ0nwb12oU+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="65808867"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="65808867"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 12:34:13 -0700
X-CSE-ConnectionGUID: uspZGP6HTjCWsAqD1utNwg==
X-CSE-MsgGUID: H+I4gdbkRUeCAYDbICJJ9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="183985862"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 12:34:13 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 12:34:12 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 12:34:12 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 12:34:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAOcyiVGym7cI8D7FE8A+PkamBtIhRSXXJjqnJ8yC9x5qsZVSaWrCFJIcg0nGJ/rQ7j6ESnYnhp/GWYWzkAjlYugo4Tdv5pD5XTTROY2H0+dBv1OdwvPtvdT5TNu3tpjFXMKWIsgn72bbuU8aKUwYUP8PTuRVsdjAgjbbaTCofVVvdvs39/mW8hL45kUZYpliraOJyOIUxdacxTc8cJAWoBAV28yx1O8lobF4zM5nngjtZC9Iv70FysGZ0+qqVVEJh2qpXl2LXoT8WqpyUQCe+vLcBc4iTVD8Q+sCVW20+rDPCVgm6b8mM0NWXGyE34bF26eH76POnu/IsRAZlP5+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M4+QPocNtu+XBX/TshfzhagAYiFwDNDEb3MjKUW0Ick=;
 b=cm7zF5G6V6jUdcq3N1NNv1LbjATmRWisNsUsYuDiTna+C86VoqupFFTb69fgqF8UjFUbx4JmB3pg43IVpH42rBtXdjrqiL9AhilwxVW15/+MBsud4+tNACCO49ZyaTXZPp90vD5bfLsvM8+8RtCqtt8XaKl2LJbsh2zDfAiPCbminijL8QOGsKSx14c0i2H/0EZDsrO2lCh+1jZos5XOhY2KCeSMTTsZrA/hjdijWJZ+him02ObZjfE2gb5HhoQki4hcX4g/e/6iAbEzU0INRSqkC8tKqrYYUBLT8minYsj/uPH9sCKHxe9U1cRxWuETWRkV87HDHD0gkCM1q4y8fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6785.namprd11.prod.outlook.com (2603:10b6:303:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 19:34:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 19:34:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCH v3 04/16] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHcKPMzhddSbzRYF0iAPzAr3eQJNbSlMMaAgADeWICAD49SAA==
Date: Mon, 6 Oct 2025 19:34:03 +0000
Message-ID: <850f7ce0571cb54bc984c79861bdfd104e097eb9.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-5-rick.p.edgecombe@intel.com>
	 <ba3de7ec-56bd-4e24-a9d3-5d272afe4b0f@intel.com>
	 <b8b99779f0997cef83c404896ee3486e98418a4d.camel@intel.com>
In-Reply-To: <b8b99779f0997cef83c404896ee3486e98418a4d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6785:EE_
x-ms-office365-filtering-correlation-id: 270633e4-38ed-42a0-55b3-08de050f4e9f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?bWd1VW5xcTRUTzdhNXVjZlFqS0RvYkRBYm5EYjlYSTRYUjc5eHNCTEdtTThZ?=
 =?utf-8?B?Vis1eGcxY2dBWE9rZW12R3hKNFNvUXR5azFvcDNhbG54MXYwRi9ZcjZlRjhh?=
 =?utf-8?B?VGpvaWhrQkVPczZ6TWxTVm1TanV2MWk1WDVtZjhzbHFLemtSNytaV1ZIMlVx?=
 =?utf-8?B?MXlHcy9TOVZlVFdSTHVBYWk1dE1KYWZrak4wbmZ3NG4rV09RT3lva3R3SXhi?=
 =?utf-8?B?ajIrajI0RGJsYTErSUZzWWNuckIybEE5SFRMMWRJeGMrRmpDc3l6WGRxTzBk?=
 =?utf-8?B?ZmR6ZmVmZUNYdmlIcEgraUtFdlVtcjBBUE5NN1F4QkRGN2JHZW1WbDNId09N?=
 =?utf-8?B?d0gvSWxKL2hwaFhvbEg5dzhES084bGN6dDJsTTJNb0pmS0Y0bVlJTCtXVi9a?=
 =?utf-8?B?S0Q5eGU5NW11cjhTVm9zNDQwT0FBN0tTVGF1MCt2VGNFRmFObUpDTnlIY29B?=
 =?utf-8?B?amZqdU45YmRwdHFQakhpMlhQNXV1ZHNXUFMwMmdYa3ZKV2c1SXkwV3QybENQ?=
 =?utf-8?B?SlpqT24zcGp5bzdkM2J2blltNEhYY1AyQjlmVGwwT3FVQ0hNbTNOZWZ0N0xW?=
 =?utf-8?B?MmdlMklHNHhPL04rZmpxUDJaOGdLeVU3Tm90eGtZL3lIZ3VkYkJGYllqMFdx?=
 =?utf-8?B?ckM5VDFIcG1WN1VyQVFsTzZRMkJEY240VzFBQnJqT2VySUFtdHlXaVAwOVA2?=
 =?utf-8?B?ZUkrWmFvMHJUQUxHZ0JTQ0hxWGhCOTRxcTIyaXdrbDJmdXN4U2ZJUkhML1dr?=
 =?utf-8?B?R0tEU3JMV0NGZ0V2TVNQTDllZGN2MGhnOW5EUG5iWndxb3Y5NFlHQ3h5aS90?=
 =?utf-8?B?ci9XcDFvclc4QnFBUmxhbThQdWVsWlBaSWp3VUhOb2o4NlpidzJCbmpjNkto?=
 =?utf-8?B?N1JiV0ZEQW81RDB0a0c1VEZjaFl0R2t2SHZCbEthWDc2NHovZ054cDFCRDJ1?=
 =?utf-8?B?Mkx2SWt5blZJZVdVWFBXY2k0SzhRcmNSK0djWjAwejVtb3BiVWtIR29MMXAx?=
 =?utf-8?B?dDIyZTdIM0dOR01aejRrNjZYeUJVemxCVzA4blcyTHBZY2dWUHFRRzZaUkdP?=
 =?utf-8?B?WHFrRytrbzl2N3BSdVlvNVJEQjhLb1Q0eTlTNVpUWnZiUWNqQjltVmhTd1Y4?=
 =?utf-8?B?eU11OHJmaktnYjBPdmRLN0c3QTJtZS80UnFVZ0N4MEFyaldEVkZ1VzdlNHZB?=
 =?utf-8?B?SzkxZG82N0psMFFWcnFCeFoxUisrTWZYWGxTZmJ4enpzOXc3bXEra1F5OHdY?=
 =?utf-8?B?eTZabzB4UmF2WnRpeHJHWURySWN4YkQ1QXY3dWJ2N0VJRjRtKzRjenEyVDN4?=
 =?utf-8?B?SEJ1VGhGbGZPN2l2QzFOUDRibWJJalFZdW12Lyt3YVROek9TL0JiUEh1aHFx?=
 =?utf-8?B?NUR1aDB0a1FSREVBMmNFOVpBSXR5aTFRN2pPcjk2U1RJK21LOHFNM3FiWE5v?=
 =?utf-8?B?SmtpdEVIM0xoeVdiNW1GTldLZEovZHQxc3NxM3JNcjBldGZMWEZSZkkrWlZ4?=
 =?utf-8?B?eDF3RHVOcXNrekUzcUF2ZDV6OVYyVjZXUlREUDFoZ0Y3bTkwMlgzU1lsbkdk?=
 =?utf-8?B?MWFCZmpXWE1hdVZQbklhaXREU2Q3Vi9oL2VSZDRQRlE5R0EwRGFTSDRFemJh?=
 =?utf-8?B?bDAyRVVwOU52UUJYQUs2aWoxVndwSFVFc2xrU1RYYnBiZm1LQko2SmRRaFlV?=
 =?utf-8?B?SkVDRXdCMmducFBRZXR2NWtta1oxdHEwdEtzWmtwOTJCWkYwZG5PbEdJZWNP?=
 =?utf-8?B?NkN5U1JsRG1SOGZyekYyd3dRUVp3RUxobGhwR2VqckRSZmxzTUxLK1NQS1pz?=
 =?utf-8?B?Ynh3UEFjSEszemxnTHI3UXNVUUJJQTVudjFQT3FyV0RvNVJPMEJxMkdHZnB6?=
 =?utf-8?B?dXhBRXU2V01YUmk3SGNqVlgvdXhPVkFKNTFLckhqa1JMd00yeGZhNCt6RFRH?=
 =?utf-8?B?Q2o4eGtJTE9jMmFrbzRaamJMQ2h4NUFpQUpaWFBoS1JSOGszbTZLeGxVeWlH?=
 =?utf-8?B?Uml2RnFGTmx4d0l6ZURqOG9RVEhkMlVWRjNCT3hTcGhPTUc3eWZaRUl5QTFB?=
 =?utf-8?Q?GKMRgO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WEFXYUtsSm5ZN2Y0cVQ3Y2d4S0pybERRUGZwZmRLeHlrMThtNFZmTHdqN3la?=
 =?utf-8?B?a1UzaTBwUmR2bllZWmJUSTRMV1A1dkxoKzlkaVh0R1pUbXpqSG5BN0NvWWQ3?=
 =?utf-8?B?MHJYMk1HZmZuV1ZYV1dldWF4cnI2ZHk3M0RZaXptejRxRzlkbWNYdTEyVmUy?=
 =?utf-8?B?a1UyZENYUnE5L1dnNkJhNnBqSDhuOGdqMFZheUdsdDRTblkyUDBSV2xxQXJF?=
 =?utf-8?B?dWI0QWVpNWhqbmd1S1V4KzhRYnhBa3ZwYWZ6QUZjbmZxQUYyMWY2cVhQZ1lJ?=
 =?utf-8?B?Q0VJTXRYWHU5UVIwVnRpMTlhMDNDMWFTeXpGUjhGbWtmeXVVU2txamNWUmFU?=
 =?utf-8?B?NFJPbDFVeW9DakFWTS93Z3VkNjBlcVE1cnhTeFlrQWdqZUJMM2w4dWVVa0Nj?=
 =?utf-8?B?TkdJb2wwVWVQblVweU50dXlnbFhTcS9MRmt5NzRvQ1NOUndTNFgrR2JLR0Jq?=
 =?utf-8?B?dmQ3RmM4L0NNSlBEOXNuclp1Y0U5YUUya0tIS3Z6b0hhcGxvbDYvdlFGZFlG?=
 =?utf-8?B?d3VqbmY2ODczbHdiYVhpZ1pjUitQTTMwU29hQWRkUXR6MGsrdkZ3NXNTbFVt?=
 =?utf-8?B?aDRWY0pKQUU4N1Zja3F6ZkFqRU9PakUyb0RzYmtjcTJLbGhOY3lFQndFdWZT?=
 =?utf-8?B?Q2JXNVB5MjhpM1dneXgwbHIwUGJzTjRoKy82WktVQ3R5akVYOEpQalg2UFA1?=
 =?utf-8?B?d2Y4eDZMTFI0N3c3YUtjSDdOdmpTZ3BDd3kySnNwbWlXMUxBeFJEakNPSU0z?=
 =?utf-8?B?OXl4SkRLcERwVDZVcGo5V0htUExmM3I4THFCL0pDYzlGOTBuM0tza1ozMGx6?=
 =?utf-8?B?cWJHRFhLT0lFZXArTmI5NmZyVzV0aC9icmJJcnIzd0RjSXhjVjdPWlhvTTVq?=
 =?utf-8?B?TDhlWXVlV05McHQ5MkRSdmYrUHlZS3NrRDg4amx6aHRSZ2lQWW5hbjJZOExP?=
 =?utf-8?B?K3U1ZjFnYTg4VUthTzJVZ3ByZGphcGdvMVMyK05LTEk5MGcxVXNVSzQ3V3p2?=
 =?utf-8?B?WENVMXI3dFRqUFZ0VkFOQVJ5Yjd1QmNZWUs2NzJhbWx1aTNkeFZ1bnNySk5V?=
 =?utf-8?B?cmRVYmJuZFRzR3NNaUJXRWtJdU1Kc1ZmNXdDeU5CZGlqT1pxSWlXaWhONE11?=
 =?utf-8?B?WWlKeUF0VEQ4cU1lb08xZ0RoVCtQeklob3Rma3YrRjZNVG4wNlhRamIwcFEr?=
 =?utf-8?B?eWZQakpoVHZ1THFWZ1QxZFByV3M1YTFUYzhFN29WN0xwZXp3b1FwVCs5VkU2?=
 =?utf-8?B?enBab3NpY2h2NEYveXYrUmZLYmFEYzNXUEhrQmNjVFpFam5LRnVnS3VVcEN3?=
 =?utf-8?B?MVFLWjZoNXVlKzRHMXpPWG5xU2VvRWVEQWk0UHJ6TGdJSEJGcDVGb1E0Ykp0?=
 =?utf-8?B?OWE2VVJNSDRDSDNSbEhoazNUcnNTTmxhWTEvVThiZ1ZqQWZ3anBWRkRacjVh?=
 =?utf-8?B?ZzUrYkUwT29hbEx3NlBMNHpsL3U4dElSVzQ1aWIySTIyZFJsTU4zenJGbjQy?=
 =?utf-8?B?OFJWNW56T01GYVVxVU5lTStma3V1K0NxTkJVTVJiTkJWWkhqNThRTldGQzd2?=
 =?utf-8?B?TW5UMStJM1NzRUtmQlA1YTZqVVQzZ2d0Qlo5WE83MjdNajU1TmxoUWdHK2xw?=
 =?utf-8?B?cnZLUjlwK0twZ04zeGpHK1hkU1V0VGhZNC9kRFhRNktETXVpVzVERU1YMTI4?=
 =?utf-8?B?MUZBWFRURTlxUUY5aTVwNFMvTXhxbTllSXJZT3haMzE3MUszRVRDTGdlaTRt?=
 =?utf-8?B?b0JwU0dpMWZ1WXRsSHQ1Z1M2STZDWlNNSnpOVEhqTzRqVWNhRVE4YkNrazJp?=
 =?utf-8?B?Um5tb3JPSmxidkhzcDRGMnk4OE8wMUgzMGxVdkpNK0R4dEZwRldUSEJKbXoy?=
 =?utf-8?B?WjlHSWxVb0xoNUU1RzVlVE85bWt6NGpvYWxVK1NqNlBGTGxnUC9kNEZzbGty?=
 =?utf-8?B?dXZ2Z29IZEpJREd5UFhWd08yZVRJTndSa1loUGYzb1o1UWhIb2lHVVUyek4w?=
 =?utf-8?B?SFhpRnZ0TlFBRzRUVllIVS9ycnNMSXVxMUc1V3Q2dTU3WDR3KzAydHJqa0E4?=
 =?utf-8?B?Q0laeEZYbnViZEVocmJkaTNZRkVqTnpSMGMrenUraFRkMTJWWG5RR0ZoVWR1?=
 =?utf-8?B?T2c3eGxwMXJYYjFvckRvenQ0dmcraVVRUFQxR082ZjNrS21NVjNrclNTeEg1?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB2F54C666DEBF4EBEC509606BE6931A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 270633e4-38ed-42a0-55b3-08de050f4e9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2025 19:34:03.4569
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kfZzNviJ7Df0DMkl7LldXXfLJaUgqdi4Vi6u7kJrsnabyJqGMNFHTBnWmitrsjmgvpKG5N2Q6ojlrm6o8AbDJtzDAdPSlXeRThiHx9OdBSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6785
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA5LTI2IGF0IDE0OjU3IC0wNzAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gWWVzLCBpdCdzIG5vdCBzeW1tZXRyaWNhbC4gSXQgd2FzIHByb2JhYmx5IGFkZGVkIG1h
bnVhbGx5LiBJIGRvbid0IHNlZQ0KPiB3aHkgd2UgYWN0dWFsbHkgbmVlZCB0aGUgdGhlIHBhcnQg
dGhhdCBtYWtlcyBpdCB1bnN5bW1ldHJpY2FsDQo+ICh0ZHhfc3VwcG9ydHNfZHluYW1pY19wYW10
KCkgY2hlY2spLiBJbiBmYWN0IEkgdGhpbmsgaXQncyBiYWQgYmVjYXVzZQ0KPiBpdCBkZXBlbmRz
IG9uIHNwZWNpZmljIGNhbGwgb3JkZXIgb2YgdGhlIG1ldGFkYXRhIHJlYWRpbmcgdG8gYmUgdmFs
aWQuDQo+IA0KPiBLaXJpbGwsIGFueSByZWFzb24gd2UgY2FuJ3QgZHJvcCBpdD8NCj4gDQoNCkFo
LCBhY3R1YWxseSB0aGUgY2hlY2sgaXMgbmVlZGVkLiBUaGUgcmVhc29uIGlzIHRoYXQgaWYgdGhl
IFREWCBtb2R1bGUgZG9lc24ndA0Kc3VwcG9ydCBEUEFNVCwgdGhlbiBhIG5ldyBrZXJuZWwgd2l0
aCB0aGVzZSBjaGFuZ2VzIGNvdWxkIGZhaWwgdG8gcmVhZCB0aGUNCm1ldGFkYXRhIGFuZCwgaW4g
dHVybiwgZmFpbCB0aGUgY2FsbC4gVGhpcyBtZWFucyB0aGUgVERYIG1vZHVsZSBpbml0aWFsaXph
dGlvbg0Kd291bGQgZmFpbCwgd2hlbiByZWFsbHkgd2Ugd2FudCB0byBqdXN0IGNvbnRpbnVlIHdp
dGhvdXQgRHluYW1pYyBQQU1ULiBJIGd1ZXNzDQphcyB3ZSBtb3ZlIG9mZiBvZiB0aGUgYmFzZSBz
dXBwb3J0LCB0aGUgdmFsaWRpdHkgb2YgdGhlIG1ldGFkYXRhIHN0cnVjdCBtZW1iZXJzDQp3aWxs
IHN0YXJ0IHRvIGRlcGVuZCBvbiBpZiB0aGUgcmVsZXZhbnQgZmVhdHVyZSBpcyBhY3R1YWxseSBz
dXBwb3J0ZWQuDQoNCkZvciB0aGlzIHNpbmdsZSBjb25kaXRpb25hbCBmaWVsZCBpdCdzIGhhcmQg
dG8ganVzdGlmeSBtb3JlIHRoZW4gdGhlIHNpbXBsZQ0KdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFt
dCgpIGNoZWNrLCBidXQgaWYgdGhpcyBrZWVwcyBjb21pbmcgdXAgd2UgbWlnaHQgd2FudCB0bw0K
bG9vayBhdCByZS1hcnJhbmdpbmcgdGhlIG1ldGFkYXRhIHN1Y2ggdGhhdCB3ZSBkb24ndCBlbmQg
dXAgd2l0aCBzY2F0dGVyZWQNCmNoZWNrcyBhbGwgb3Zlci4NCg0KSSdsbCBhZGQgYSBjb21tZW50
IGZvciBub3csIGFuZCB3ZSBjYW4ga2VlcCBhbiBleWUgb24gaXQ6DQoNCgkvKg0KCSAqIERvbid0
IGZhaWwgaGVyZSBpZiB0ZHhfc3VwcG9ydHNfZHluYW1pY19wYW10KCkgaXNuJ3Qgc3VwcG9ydGVk
LiBUaGUNCgkgKiBURFggY29kZSBjYW4gZmFsbGJhY2sgdG8gbm9ybWFsIFBBTVQgaWYgaXQncyBu
b3Qgc3VwcG9ydGVkLg0KCSAqLw0KCWlmICghcmV0ICYmIHRkeF9zdXBwb3J0c19keW5hbWljX3Bh
bXQoJnRkeF9zeXNpbmZvKSAmJg0KCSAgICAhKHJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxk
KDB4OTEwMDAwMDEwMDAwMDAxMywgJnZhbCkpKQ0KCQlzeXNpbmZvX3RkbXItPnBhbXRfcGFnZV9i
aXRtYXBfZW50cnlfYml0cyA9IHZhbDsNCg0KU28gdGhlIHJlc3VsdGluZyBsb2dpYyBpcywgaWYg
dGhlIG1vZHVsZSBoYXMgdGhlICdmZWF0dXJlczAnIGJpdCBzZXQsIHRoZW4gcmVhZA0KdGhlIGZp
ZWxkLiBJZiByZWFkaW5nIHRoZSBmaWVsZCBmYWlscyBzb21laG93LCB0aGVuIGZhaWwgdGhlIFRE
WCBtb2R1bGUNCmluaXRpYWxpemF0aW9uLiBXZSBjb3VsZCBhbHNvIGNvbnRpbnVlIHVuZGVyIG5v
cm1hbCBQQU1ULCBidXQgdGhlbiB3ZSB3b3VsZCBoYXZlDQp0byBtYWtlIHN1cmUgRFBBTVQgd2Fz
bid0IHRyaWVkIGlmIHdlIGFsbG93ZWQgdGhlIGluaXRpYWxpemF0aW9uIHRvIGNvbnRpbnVlDQpo
ZXJlLiBMZXQncyBrZWVwIGl0IHNpbXBsZXIuDQoNCg==

