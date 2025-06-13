Return-Path: <kvm+bounces-49533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 21F4CAD97CC
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 23:53:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 767407A79B7
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 21:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA26B28D8CB;
	Fri, 13 Jun 2025 21:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ldhVKbZq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E52E11CF;
	Fri, 13 Jun 2025 21:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749851596; cv=fail; b=VfFZc9E7X4ErwJxWZ0gfzhcGFHYg2v5GiBNbVvyYxVtaGgJguY9UbZ/GhRFjYIJo9DyQLOiGiuQ6n+nJoRx2P+TOFLh0gdjztAfZ0BCRT6wxGPbstwRWd4AmwgYa3udu/3dQWoKMMA+fICjc54O1bP64Ddk6x8RsnRklTzpiIJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749851596; c=relaxed/simple;
	bh=M8idIXu62pOm8K/fU+RvnvzDLOcvTG1gYPsL0RaecKo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l+uywPuXSeNZz9L4oRXCUMR3RIAa0ZOM5gvPQQAJXihNXVQjyGA09SO6QlzfJ+FozeWrVflGHws6+5DrRI47OB6H5/cp2Cc1PJF+1oPsTK1Z80YKw7E8fw7rFu/XnaUjMN5Mu4JiDBNsin6ldxfnKEf6o3PFMx1eZBJxmNTtc04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ldhVKbZq; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749851595; x=1781387595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=M8idIXu62pOm8K/fU+RvnvzDLOcvTG1gYPsL0RaecKo=;
  b=ldhVKbZqQobYE780/dZS9O7lw1+ammiGsmwiBCNousT0skuz7im2Jx+J
   Kf/d32bdK6oFqEGbD6k7ZPXuTUGOlJAfbMyFCvAMM/v/ACLv2kTvkZMHZ
   DhLVH7jtsj7LopFsB6ZKbhYsLGU237UnTlycqnllmSuuDSKHicWJJrUTl
   ksiL9twv7ErxyiE45zY/PuWWKmHfal9oYcMKenw2BzUpJWFlqG90uhF1I
   D5syFZ5bLazO2S1fXNXWMDQAEjU8GMQEsOxxpzWcucH8ikR+YubOYl/16
   8YcgEnLvuO5tgmLq2xpP648J+C6pb0Hkz10/X8Nd/YKzsvyNClrvjjEDo
   Q==;
X-CSE-ConnectionGUID: 8om125uHQSi34Q4WMKDWZA==
X-CSE-MsgGUID: 7KDA72gVTXS8QPrcigw/fw==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="63429902"
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="63429902"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 14:53:14 -0700
X-CSE-ConnectionGUID: iEhRhnpCSAGEDnG6gsW1eA==
X-CSE-MsgGUID: MnHPyNFgQzGmTUOmg8FlbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="152900157"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 14:53:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 14:53:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 14:53:11 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.44) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 14:53:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qkfAjfIQxEOG7hQj1Jf29beBuhHyicW4sQSF+5Vhw21njFGJPcVEgB6nTBzCyNHAdfgFNTdgX/JZ/nDy33DVOY8CtAnCSFfG+BcqteILY2VZG83GS48pzmkMDx19nPx6LoV5kvaMLonnI6w+l/22f4cy+79gsmsCC1Uk1NlrrK1dLnWjzIh/WagHytUox0BxJBC/oLVjvO4dG+OkBmTD2cahsfal3LMGsfqsXPaah55o94qS2ZlAsBTJmpEAGJTmFaU0vBtmaxbvNLT6orb5v5yC7UKHh/ud2d8bCjrWQUXFC8VdXrqemMWS68REV2VKzr6TqAORwzGp/jAKAzzxcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8idIXu62pOm8K/fU+RvnvzDLOcvTG1gYPsL0RaecKo=;
 b=w5f5NvEXEquXh+z3hqxwDNoMN75phqlx18ctDnOAXpfBBiMjsKAHPMmNXmT1xbqsCN6Ho49Zg1pwrrru+SH4CeWJJXPAlkqfWv1pxPHx5c757R1vFeVgJx4Ygbmbxtt77ceVXSwECBqclYjlwdL8rGCOwlrtU8LqZ8GxlPOSFh13AjSA0OcPuRKTpAgSuspYiHD4oW6lTzR1Uy5qVUerZe39BUKZt2g0mJAHeUa4X3WjaQXjuxANe5AZnIaxO1j4XjqHK81dIP8I0AdUYeit4Wqa+A++ufHZ1pr0lGRRqwRtefaAyvZlZ83yDLuFy19VaNncpHpkyQ1bG5Stc+Hm5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4742.namprd11.prod.outlook.com (2603:10b6:208:26b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Fri, 13 Jun
 2025 21:53:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 21:53:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyA
Date: Fri, 13 Jun 2025 21:53:08 +0000
Message-ID: <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
References: <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
	 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
	 <aEmVa0YjUIRKvyNy@google.com>
	 <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
	 <aEtumIYPJSV49_jL@google.com>
	 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
	 <aEt0ZxzvXngfplmN@google.com>
	 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
	 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
In-Reply-To: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4742:EE_
x-ms-office365-filtering-correlation-id: 40a06abe-4b43-4d9d-9035-08ddaac4aeee
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Zjd4Z0NnMmh3T2U0dXZxVjFSTFRXMTYvVCtyN0FyN3BuaGRRS3FsczZvNHYw?=
 =?utf-8?B?djF2d0xJeTBDNnBadlAxaVFQUGMrWFNlanpBVlNFM2c1bk9JcFRIM2NTV1p6?=
 =?utf-8?B?cnRGZDIyODlTWU90RGpJZTF4STc4QmF3cVducVpXMytlWi9VeEJWRXZVN0c0?=
 =?utf-8?B?RFpsQWI3MmJra2lYeTVHL1pCS3B5R2E2SGladS9yKytjWitaM0xFOXVwZDdZ?=
 =?utf-8?B?cWNsMnpiT1ZFN1VFd3dIUy9PUTRMM2NsalA4UU5yazdhOWZpRDFWOXFLUXNT?=
 =?utf-8?B?SW1pSnMwVlZwOG1WRklSWmY5NnJ4MVhqS0ZiMmNKeG9KaUV0Q0F2MWtxdG1P?=
 =?utf-8?B?NUVXLzFFRStCdVhVVnE4akMvaUo0STRQaGdQMHJjQmNyRGI5VzZVVmtLcG92?=
 =?utf-8?B?c1hybzNPVlpNYXd0dnlPaVNLUi9YdkdiTTBld1gza0d2V0RmNE5uWlFCQTVV?=
 =?utf-8?B?eWdISUl3WUdBeldXMjd4RDNPcjlYcGRHMy9ZWlMwMEJOamNXOU1tMjFiRjB2?=
 =?utf-8?B?TjEwcG5sRCtJMXNveWk3eXNLQnREeFc3NmI2d0dhTVBJbFc2VjdzVytiejVi?=
 =?utf-8?B?RU01OTNtR011TStRWlpCazBaVkFVMVozU21zRDViOUpRNkU0dkN5bUN5dUNw?=
 =?utf-8?B?NitEVTlJZDNiS1ZTUThCeEdwRXF0VVZiNWdOYXRJODdpSEIzY1hoYktnRGkv?=
 =?utf-8?B?eFVhbE5MTjVaZlFYYnZNbWxKZmxIODhMRXVhck5id0U3aG9XcHRUNVNJWEZj?=
 =?utf-8?B?L1hoOUR1Sy83cU91UTNXNFlmTjV6b1EydmRrNXJTZUZoR1NMOXRoTlBlb0U1?=
 =?utf-8?B?WUUrcVV2VDhvWmY4QktqNmg4QzBId3FIdlByRjQ2RStEWTY4aGVxd0doOEZU?=
 =?utf-8?B?SjlxZFJ1Um1Kb05sbzRoQyt0ZWhlTjhHUXFnVWhuYmRDVFIvS3JodldLbm43?=
 =?utf-8?B?VnZsaHZWSnJrZGoxTUlrWmQvVnRNYlVTc283ZWZrVlBHaTU3RlAvN2lPaDFq?=
 =?utf-8?B?NUhVdGRmWFArcXROdmJzMENvcmpKZDFyVzJVY0RvTnNZcEdSYVA2US91RXkw?=
 =?utf-8?B?MHg5NmRkaERNM1Z5ZU9JSTRUR1lSeEtGd1REbG5LM1kzdVNLemwyZkFIK2FI?=
 =?utf-8?B?SnljVFREbjlTN0NMWmk5bGNSRjM3cUF3VGZmVnVUL2pIYk5FaEVNb1NJNndt?=
 =?utf-8?B?bkV4cWIxSkwvcmdGdkNLOUtGbzh1bEJZZDFsTC9EMGFOTml0TFJtdFB2bVFG?=
 =?utf-8?B?cVV1bExKeFJqRFBrTnp6SmVTcWNab0JvMDFJekdoQ0NQaEliTHZMSm1vWmhV?=
 =?utf-8?B?ZHBOb21UUzh3RmZoODRQQjJ6clh1WDZxSnFVY2ZnSURXZWt5RXJlSFR0Vzg1?=
 =?utf-8?B?YUZqWCtPZ3RQTGhNK1RqdWhHVURGaENsVU40L2JuQWw3Z05qNUdsV0NUejFK?=
 =?utf-8?B?aHBib3FLWXdIMTNRVmZFTE0xa1JtRWpCbkwwUmNnam9OQUVLUnVXY05OZVB5?=
 =?utf-8?B?TlBjNWJ0dWk0aEZJWTNOb2g0RGxLVkFFZWtKRFRPR2QrQnVBQ1V1aDR1QnZP?=
 =?utf-8?B?R1FFOElqb2VPL25LNEpYcm9yMTZjYkgydTJNbGJjK29xWDVtM3JvTnY5a1FY?=
 =?utf-8?B?ZzJIVGpTa2t0UlVtWVA0RmtjWjJ2MlJFSENtZ0ErTzA3amJSeXUwRXRiajEx?=
 =?utf-8?B?dTdYWFYxMjgvUVFMeTRNS3IxRW1wOVJybzRKeEZDd1pJNHNJSE1SbHA1SHlW?=
 =?utf-8?B?eHpPbkQzcTdSckFOUXp3Rkd0QzArMU5ZeGRnQWJocTR1TlFsV2x2L2RYaEs4?=
 =?utf-8?B?Z3dKSEdiNE1MVUtWcFJTd0lISGxDLytQYzFHVWJvK2FpQUtXcnNvTHBwdVVO?=
 =?utf-8?B?UnZGU0JJUU5CbFlNQW5VMldmQlkyY1Z5Z1dLOXBLd3AvWTIxdHpPK2xrQlBC?=
 =?utf-8?B?MHhhODBUUnJUSzlmYkpaNFRJWm95TEtwM05NdkNoWWxmK0hTUU1yTWZDZXFO?=
 =?utf-8?Q?6rRT3nbuBRQtcgeDebSBI0jZwv6GW4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NDBvK1ViOFRkMEh0V2dMNlE2aTF2cTVldnNQb3J4RVhua2NRMDlFa1NCRW5o?=
 =?utf-8?B?b01nOFptMUhrOFRrTjRvMS9oTG9yRlh3dkRGdVkwdDZVV0x4QWx2b29pY2Fy?=
 =?utf-8?B?U01mV1FmR2JjUGlLQTFuUlpVdGdILzJsR1VrbWdSdmpNcEt1T3ZIYWpZN2Jn?=
 =?utf-8?B?VmE3TFNMVWFnYXVrRWlMZDFucjZYanNraTdUUTVZOTN0cEs2WTBicjB5T0NE?=
 =?utf-8?B?Z0ZTT2ltekhZTHo1bkVNQ3luOERjNTJqQjZQbzBaVEs4bFVBbWR6OExVZWxX?=
 =?utf-8?B?ZmFJd0IvS1A1aGpHUTZlWng0WEZwQUdrWHdFQVV4UEtsd1EvcXQwbG1mbXkx?=
 =?utf-8?B?dUdlci9IbGpiclEyNVlOQ21wZWdaajNFdGl0djdqNldsL2g1bnhUWU05VXVL?=
 =?utf-8?B?ZXlzM0kzR2NXSm9mQy9sYmZwREl1TU5vRTByWU1pbzNzaFE4MkhDSlpCWjFu?=
 =?utf-8?B?SlkvZHdoUVhWVGNtVnl3OVNJcWVUc012QUVlanMwUGI1eUVidHk3UHdGOWlz?=
 =?utf-8?B?WlRXeldJblJIR3FNei9VdkVhWXpyS3MwVndiOWp1TVR6U1hSdlNiMms5dlVB?=
 =?utf-8?B?L2kzYWtWd280Z1hFS2dzdnlZUXVNSDFrR05hdE5lK1RGK1FSRXNJYUMyMGJz?=
 =?utf-8?B?dnhtdHVCQmFpOUROeU4vV0ZmSG5nRzNhdHB1MTdkVlV1N1ZKc3I2MmhSYWxu?=
 =?utf-8?B?V3RoZkNXYmNWS0c0K2NPU1VPYXNneFFyTnlOVGlpdDBOclk5bzRIZ050Z01O?=
 =?utf-8?B?VkwzV1JWQ0luL3lDN0ptMFQ3YjdpT3hyd0F3TVRQMHZ5WE9Db2trdmpPNFIw?=
 =?utf-8?B?dzlUWnpXeFNZNGxFS2llQjlvSWdBWFlrM2lncmpEcWhTTzNxVG5wb1hnbmdY?=
 =?utf-8?B?NGpOSnV1bVgrSG5yaXRIWWc2KzgyVDBzQ1pueHhPNkR6T1NLWmtiWGFGV3N5?=
 =?utf-8?B?cTV2OHp4UGlQQlF6dE5La0hqaXhCbU9qS014YzJEZkx2bDdLZjc4M1ZPNEww?=
 =?utf-8?B?NXRVK21Va21PZi9iOUFNbm82TXdOMWhEc29lbFBscmtlSDMzUEt3bTRENjY5?=
 =?utf-8?B?WXlzMUttZVlKNllvNG0rVDNVT1RvL3JIQS84QTkxZ3dWdmtRRW1FWFRMczZL?=
 =?utf-8?B?dWtBWTJNczBGNUJuUnJpZ0IyY3U2TENDbmV5cW9GVlR2TXo5WTRrS0lhSFlo?=
 =?utf-8?B?eE11cmdPRnphaVhidit2TE5sRDRqN1VhQlpyNURxQ3AxbVZ1MXNmckorcTl6?=
 =?utf-8?B?cmkxNmZmTW5KWHo4SEl5QTVZdTY2cGJWWDZVa3lnVmQwb0NObmRlM2JwMjVL?=
 =?utf-8?B?LzhZd0Q2ZWM4Nno2V1VpdjRHNThaNTBYdEpjZ2VadkoxZzM1WkpNVTl3N0t3?=
 =?utf-8?B?RUVHMDcxSGJwTXF4WUZ5VU4yTHI5Y1M1clZudG10VmRiTEFpZ0Ivb0o2NHVn?=
 =?utf-8?B?Y0Z1UVNIVTNjaGFvVFBaWjNNcTFKZXRFSzlRaXBoY2kzeE1Ha2g0ek9pQjJX?=
 =?utf-8?B?c2VzMVNtVE9IZXR3MzFxTzc4cjBiYnE0QmE2aVpNV2RkUzlScDlQOVdsN0tr?=
 =?utf-8?B?dzk1Y1picXdYMXhPOHdVQzRKZkl5VDhleXhLRDJDeUovRjd4c2Y0d25aakd6?=
 =?utf-8?B?bUVxQldITkVXRUxkUmtHbnJwWC9pWkF0dnJ5UmxjWHp2K2IrTHhKNWJwbGRP?=
 =?utf-8?B?b2srWGZhTlRKN09TQTJHVG5pNkROR1FaMHZDWHd0Y1d6cTZqMTJLRVAvRGhJ?=
 =?utf-8?B?SzY3MnJ4MW5DbG56enF6UU00TGhhUHVPcnR6Sk1pMEt2dUZsZTczaUhNZU4z?=
 =?utf-8?B?U3lkdkc3UnZrY0g2VjZqOG8xYXloOGxwb2xaSzFhb0xzVmJYZjBkSVJpd3Fh?=
 =?utf-8?B?YytNQ2pJZDFoc2NDbWFsWkpOaGE5bm13ZXlrNG5pWGhOUW9PZVJxd0lKOTdP?=
 =?utf-8?B?dkJiaXJOek4vVnkwVUxBTW5wcDFIQTRiWEdsTDd1TFBLemFpYVpCUU1OaXQ0?=
 =?utf-8?B?ZFRocDBObjRZNithWDBpVzM0Ly8vUUF2b043TE1HY1BrQ3RxcitSNlJVNi9V?=
 =?utf-8?B?VWN3ekQvZCtPdmZZTXBobU5YUUQ5RSt2TVptMTF3c1ZqQWpIWk1iZ2RoT1RV?=
 =?utf-8?B?OUtWK1ovRno5bEh2eTBLNVFSUmlrWjNlSmNpemlNT2U5R2pPRS8rRGZKRi9X?=
 =?utf-8?B?aUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD131EE88F24564396E450AA9CD06FAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40a06abe-4b43-4d9d-9035-08ddaac4aeee
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 21:53:08.1067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bvYLoQTsN7L+nr55pb+bLEBZ0KD6fa4Z4z+ERPgq5lrUL/JWe0l1+2UBeWx5P0s9bnW/+WgdTBHvAqtly63dELiJK/s6AZrCec+WHSOiVxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4742
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTEzIGF0IDA5OjMyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiA+
IEV3dywgbm8uwqAgSGF2aW5nIHRvIHJlYWN0IG9uIF9ldmVyeV8gRVBUIHZpb2xhdGlvbiB3b3Vs
ZCBiZSBhbm5veWluZywgYW5kDQo+ID4gPiB0cnlpbmcNCj4gPiA+IHRvIGRlYnVnIGlzc3VlcyB3
aGVyZSB0aGUgZ3Vlc3QgaXMgbWl4aW5nIG9wdGlvbnMgd291bGQgcHJvYmFibHkgYmUgYQ0KPiA+
ID4gbmlnaHRtYXJlLg0KPiA+ID4gDQo+ID4gPiBJIHdhcyB0aGlua2luZyBvZiBzb21ldGhpbmcg
YWxvbmcgdGhlIGxpbmVzIG9mIGFuIGluaXQtdGltZSBvciBib290LXRpbWUNCj4gPiA+IG9wdC0N
Cj4gPiA+IGluLg0KPiA+IA0KPiA+IEZhaXIuDQo+IA0KPiBBZ3JlZWQuDQoNCkFyZywgSSBqdXN0
IHJlYWxpemVkIGEgb25lLXdheSBvcHQtaW4gd2lsbCBoYXZlIGEgdGhlb3JldGljYWwgZ2FwLiBJ
ZiB0aGUgZ3Vlc3QNCmtleGVjJ3MsIHRoZSBuZXcga2VybmVsIHdpbGwgbmVlZCB0byBtYXRjaCB0
aGUgb3B0LWluLg0KDQpBIGZ1bGwgc29sdXRpb24gY291bGQgYWxsb3cgYSBsYXRlciBvcHQtb3V0
IHRoYXQgaXMgaGFuZGxlZCBieSB0aGUgVk1NIGJ5DQpzaGF0dGVyaW5nIGFsbCBwYWdlIHRhYmxl
cy4gQnV0IGl0IHN0YXJ0cyB0byBnZXQgdG9vIGNvbXBsZXggSSB0aGluay4gRXNwZWNpYWxseQ0K
c2luY2UgTGludXggZ3Vlc3RzIGFscmVhZHkgdHJ5IHRvIGFjY2VwdCBpbiB0aGUgb3JkZXIgMUdC
LT4yTUItPjRrLiBTbyBpbg0KcHJhY3RpY2Ugd2UgYXJlIGFscmVhZHkgd29ycnlpbmcgYWJvdXQg
Y29ycmVjdG5lc3MgYW5kIG5vdCBmdW5jdGlvbmFsIGlzc3Vlcy4NCk1heWJlIHdlIGp1c3QgaWdu
b3JlIGl0Lg0KDQpPdGhlcndpc2UsIHdlIGN1cnJlbnRseSBoYXZlIHRoZSBmb2xsb3dpbmcgcmVx
dWlyZW1lbnRzIEkgdGhpbms6DQoxLiBPbmUtd2F5IGd1ZXN0IG9wdC1pbiB0byBuZXcgVERHLk1F
TS5QQUdFLkFDQ0VQVCBiZWhhdmlvcg0KMi4gU29tZSBub3RpZmljYXRpb24gdG8gS1ZNIHRoYXQg
dGhlIGd1ZXN0IGhhcyBvcHRlZCBpbi4NCjMuIEFmdGVyIG9wdC1pbiwgVERHLk1FTS5QQUdFLkFD
Q0VQVCB3aWxsIHJldHVybiBURFhfUEFHRV9TSVpFX01JU01BVENIIGlmDQptYXBwaW5nIGlzIHRv
byBzbWFsbCBvciB0b28gYmlnDQoNClRoaW5raW5nIGFib3V0IGhvdyB3ZSB3b3VsZCBsaWtlIHRo
ZSBub3RpZmljYXRpb24uLi4gTWF5YmUgd2UgY291bGQgaGF2ZSB0aGUNCmFjdHVhbCBiZWhhdmlv
ciBjb250cm9sbGVkIGJ5IHRoZSBob3N0LCBhbmQgaGF2ZSBzb21lIEdIQ0kgbGlrZSBjb21tdW5p
Y2F0aW9uDQpsaWtlIGEgVERWTUNBTEwuIFRoZSBURFZNQ0FMTCAob3Igc2ltaWxhcikgY291bGQg
YmUgaGFuZGxlZCB3aXRoaW4gS1ZNLg0KQmFzaWNhbGx5IGp1c3QgY2FsbCB0aGUgaG9zdCBzaWRl
IG9wdC1pbi4NCg0KVGhlIHJlYXNvbiB0byBoYXZlIGl0IGhvc3QgY29udHJvbGxhYmxlIGlzIHRo
YXQsIGFzIGFib3ZlLCB0aGUgbmV3IGJlaGF2aW9yDQpzaG91bGQgYmUgZmluZSBmb3IgYSBub3Jt
YWwgTGludXggZ3Vlc3QuIEEgaG9zdCB1c2VyIGNvbnRyb2xsZWQgb3B0LWluIGNvdWxkIGJlDQp1
c2VmdWwgZm9yIGFueW9uZSB0aGF0IHdhbnRzIHRvIHJ1biBodWdlIHBhZ2VzIGZvciBvbGQgZ3Vl
c3Qga2VybmVscy4gQSBrdm0NCm1vZHVsZSBwYXJhbSBtYXliZS4NCg0KSWYgdGhpcyBzb3VuZHMg
Z29vZCwgSSdsbCBnZXQgdGhlIFREWCBtb2R1bGVzIGlucHV0IGFuZCBjb21lIGJhY2sgd2l0aCBz
b21lDQpzcGVjaWZpYyBzcGVjLg0K

