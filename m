Return-Path: <kvm+bounces-50736-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4724FAE8A65
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 18:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11BCC189D6C7
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC08C2DECCA;
	Wed, 25 Jun 2025 16:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nppNkP4h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81D22DAFAE;
	Wed, 25 Jun 2025 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750869762; cv=fail; b=YxSAU8/II8973uj00PXsnpWWU3ugK6d+zY926a6/KxiraS9pJIr3JLWOkfjdjoLwNzbtpFXw3ToVFNn68zj6T86jLCXNMVnMITqgAcnrjxkJo9ySqylzQFm3ER3iLlqwlfWWJ07PHUPRQN+UgbfxKo69wfGPf9Z1HZKt2rad/9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750869762; c=relaxed/simple;
	bh=mnGdUk5b+DUtq/yE3c1l0XpoqHZ3HA62DOdVg0zlLlA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q/PKExqTgYTxMbEsfbxNJ+dFwXmYP8K3upJ3+jt2a7kBZ4132OCv2jxpRqO0eMfnkJOLJwdEFCzjaLz6SjBGDvIZ3mHFIEZPzTT05FblZYOS4z8Ic9fVgxZgOZoDoFrqXfAfCiJXqLV2lX9E47E8NKfu6LuvIhEZ7PkQWMsTl8Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nppNkP4h; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750869761; x=1782405761;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mnGdUk5b+DUtq/yE3c1l0XpoqHZ3HA62DOdVg0zlLlA=;
  b=nppNkP4hsOCaZRkpwj8vov0uW1fHhAEXY/U22sozYWdV/BIKbBVYXtX+
   lytFpKQ2iSfAKk8ASQhJD8hCF/R/xB/ZT+rs9KBVcqip0kByKzJ14ry5W
   0hclEKj1TP6Zig0tFAuYap2vyci+uwSpY6St/auBU5alNImc4BI44qZky
   pvw4KDj5u+5s07OWESY1eGLSgBm4x8LIriKSXfqTYqkuO9OimqLEGHBub
   aJgqqQ6V9Le28yMks/GzCQ4ek4TlfRmbXAqqtxRY/+Dq3IXN85C7Oirys
   taWBaWWd/nMUTyyg3sI7k7A1cs+J26G99wLEDw7r72a/ysshKZQImBhn3
   g==;
X-CSE-ConnectionGUID: 1IQ2DaukSRWYxpVSfnlFAA==
X-CSE-MsgGUID: wA5SjNx1SgaoMIhMWyKu1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="78579460"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="78579460"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:42:38 -0700
X-CSE-ConnectionGUID: ix+ADaEbRF+rQ7uH3Hmg7g==
X-CSE-MsgGUID: gFGTIpCuT7uVWv31+MRm9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="151881041"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 09:42:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 09:42:37 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 09:42:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.52) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 09:42:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JG7aMSTKPk4RlfRlp0lcwIzqni6jocvO9Gzi6jpidSZTJqWacvfWXUiGheer0NcAsyfHGng8P5M39BEavkQ/jXsf3d/z5ScN52AMJchCjXvKtNCharcuECTbKJ2tgMwQ2NMmxwBKkGPaOAZcb7YjXnmGUdZOdHRutcjh9d8zs555sTEtVljPcSZoDpf6MgcbG4HtMHxs2KSQHHhWjzki/gi6mizca2Z3TbRuicDmeD0xyLB/DPMaVurEETz4aFEiODXhThfaxiNV8aYnwWBVjD6spu1Yot1QtpbT8hyytcXQhr/XZIXKIBDtyLLdBuNm328B5XDOF+9J5rTljg58nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnGdUk5b+DUtq/yE3c1l0XpoqHZ3HA62DOdVg0zlLlA=;
 b=fqSMQG1nSo8+mxhDeXt1SJDtnZ+e7s93G81W28j/7yMrnsxK3stLfk7iKjM2TA8EHFlMMEQO6jFovQl8TCD9zhs5nKZgIFna1SfgxIvRgl35DQz9gCWYh60r8L3ZZbOg9AhWMw3h4bN3UBDz+1Or0eMU58YDVABIA0V8OiH2X4D816dOoIW9qF9hi9Nt2ZJMdLokUCbVy3Sq1noGKIoOo8SEZXNAW9PyS2rAd5pU2cgXyNBgkWdGFTvv6ikjaBaJ8IlMJZHZPWNQW9ycYVGu5QFbBu4iRgcEfEKDfI/AFzsOEubWkISEujehYP24WrstVmRAh1YN2JAnohrgTUZWng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7921.namprd11.prod.outlook.com (2603:10b6:930:7d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 16:42:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 16:42:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Luck, Tony"
	<tony.luck@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Topic: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
Thread-Index: AQHb4EnDaJ09WgGk1kO8vTk6Ar782rQJAkSAgAr5c4CAAB9IgIAABLgA
Date: Wed, 25 Jun 2025 16:42:33 +0000
Message-ID: <ea78b667170a190106f58b866a513e2161fd6870.camel@intel.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-3-adrian.hunter@intel.com>
	 <68938275-3f6a-46fc-9b38-2c916fdec3d6@intel.com>
	 <CAGtprH_cVwWhfXFkM-=rVzQZ0CpY_zcnkF=q5x1n_9Bzm1xKfw@mail.gmail.com>
	 <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
In-Reply-To: <bc492cb2-1d30-4a30-9eb9-d48b09cd29a9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7921:EE_
x-ms-office365-filtering-correlation-id: a8479218-93b1-4380-68b9-08ddb40748c8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ME11ZzV4SzNsZERJeXcraGswY0h4UUpQdmJjd21QVS9UUTlaSHliamdMd3RC?=
 =?utf-8?B?SFBHSnZmRUNYTmdSZXdSY05zK09xUWVoM2dRUWVSVEFGVk1KMVlodHRuZiti?=
 =?utf-8?B?bFBxUU9ieGl3TWgzMHZ3RmE5cjh1TWx0c0VDdkxQQjd4SUlJV09GTHRuV2NX?=
 =?utf-8?B?M0dqbld4WENhZUUwVmQ0NklqQ0VrZ3IwUC9lZ25PZkhId25KeDZ3VFJ1cUNq?=
 =?utf-8?B?R0pUQTdNMzVDTEVXMkFxL2hRelV1eE4zZ29vTVI1c2l2RStveDhlTmJwMEVw?=
 =?utf-8?B?OGRxZkloV3REK3FMcTBsOXFqMElUbXMxVzRsdzRVdU1uZUtUWnZ4dFFKVkJW?=
 =?utf-8?B?NXZNSjFxaUpjRFRxQndaRERXcXprYjRKYzZWZmlWY2dKY0R3dy9CcmlLQjRI?=
 =?utf-8?B?Q1h2YWRkT3dURVk5RlY3dkE5RU5wblA5cDNJS3ZmZ0tyYUt5eGl6UlhGbWxz?=
 =?utf-8?B?V2JDT0xsWGpGTlRKZ1ZiUFR4NTMxSUYvWUdJV1NnZUY2bWhCUHBGYlplS1dG?=
 =?utf-8?B?cmlhVWFkdkhqaE5vMEdESVBWM0NNU0dSMnNieGR0b09GU1cyMTJwOXkvNE1i?=
 =?utf-8?B?bURkT2dyNCtYbjN2aFlaQVZDSjdKSStVcGdRQnduQWlHeFdFYlRsc1AvT3BP?=
 =?utf-8?B?S3B2WkY0MVdFQlRmUEhWWXRpaG9oZGhOcWFqTDRnL2JkcUIrbWxkQ05oSEdl?=
 =?utf-8?B?VC9uY2FQTGdmVTFpMWo5VW42WjNLQ1AxZ0l4Q0JiL3g4ODg5bWVmZzFQVzlw?=
 =?utf-8?B?L2tZRFZra1djU01wK0x3Mmh3M2JCOUFlVG5kZnhNa2s2SCtIVHp3SUJEeE1a?=
 =?utf-8?B?RDVqRkk2Q0h0RVVSRThYMXZQZTYxTy80K1BMWnJTbG1meVJ1b1BQYmF5QXJC?=
 =?utf-8?B?bnVBem1pTkZSQmoyL2JhNFA2UkZXZ0d1WmFsbjI3d20vL3hjb3p1bXdUUTNY?=
 =?utf-8?B?ZktFZW5xRStEMks3b1JFVXlrK0N0TVp6N1hTcTdYSmxOQWJSWkNJcUFnMkJp?=
 =?utf-8?B?aTZlN25IRVpUdWRWaG9nRXRlRTVVaVFYOEVOZlUxdU9VT1RadGZhcnMwUU5D?=
 =?utf-8?B?SWNjNVNBVFpEUTBoV3V0UCtCQ0NpeVdLOUVDMTVJcGxna1U3NEJsQzVXeHNk?=
 =?utf-8?B?UjR3T3FYT3IvRmRXRHQ1NzZaMXYrNlc2ZzM0WURFenVQWU5FNkhDM21Galdj?=
 =?utf-8?B?WmZ1R0UrQldPUVNvVmFtdUxMRHZyZjhhM3BOMzN3YTVEczdWL1VDRllldk03?=
 =?utf-8?B?aktNMk5xOHBIUHo5RUd3eFlwV1dkNGx6SHAyNnkyUi9veHBjK2FkOXhRdWN1?=
 =?utf-8?B?cXJWbkNXaExWZVNYalYvWkZja1BmQ0RRWSswZ2ZmeERUc2VHWkxTMGxiY0VF?=
 =?utf-8?B?ZlFmMzIyN05aa3FVN2FwajY5aUk3UGx5bzNqMzFYV0NuWk15LzNtVGhtbEU5?=
 =?utf-8?B?dzBSb2s1RkNnMWlxZkVjR3pxNktOanJuTHdsWkJ0S042YzdQY1pQQlNEL1RK?=
 =?utf-8?B?Q3haL3U3MlBVdXVkbGswSFlBL3R2RDlTVHBtdndiQ29FQmczQ1V2dXdvWElQ?=
 =?utf-8?B?SDNWZHF5S0h3WkkvVlVzeGw3NlY2aXNNTXk2bXozbmVIaW1PMmFMZFltd0Fl?=
 =?utf-8?B?MTVQeXJPSVJUaXdqZTMyR0ZhNkJYcGJsTnN5aHNzaUpDQktZbDdTQ2NCSXM2?=
 =?utf-8?B?Mk1YOHRVeU1aSVhldnlEbmxydVpDLzZkem9ydUJBakZ2WUNLQUROY0ZCZUZT?=
 =?utf-8?B?ZWpZS3VpSU1nRzNCbXFPUDhNSDR2UGxtdTN1clkyaXVPd2JOeC9wcTltVkNr?=
 =?utf-8?B?S1dSNXEwQkpIemx3OWQwWERVaS9LcEFTZm0yU0dvUjJkaWdZcDBCa0h1ejE0?=
 =?utf-8?B?TDhOd2ErbVVwNFpLQTdSYTVwbXF0Z2QvWDhDc2NMWDNrV3RKNnJCYTJOM0py?=
 =?utf-8?B?OFI3MWFnMzZCK0NzSFd1eVNsNWVhck5JODNhdXp2VWdpcFdWVFVLVGprcXBE?=
 =?utf-8?Q?QMtCxH2rQQklhd08PcRX3Mh1R4Cclw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXI0RGtTWGJsZVBnRlM4anpMTEVEZTVrZ0dZWTE5WFRlTFNqVlVqUCtXaTRu?=
 =?utf-8?B?Vzg0dlhjMVltdVZIWWZwTHpGTGVVVVlSc3FEWThoZkY4K2ZDY3ZKSmY3a2xr?=
 =?utf-8?B?emVDLzhyY09OQkZVR1pwb0FmcVlsUXpoU1djamZsR3pqeTJsSitCallBR3Vr?=
 =?utf-8?B?ZFN0UmxxUE9JQ1dCM3cxMzNjb2s1RzBWSGNzOUoyRXE5djg5VlBacnFIY0dI?=
 =?utf-8?B?cWpSK2RuZFVJZ2cvYktDbmtOYVRxQ1kyVFllM1JwYU1DVitVUlA3dnBJWko4?=
 =?utf-8?B?VVE4aC9BM3A3S29DWGduRkhLdUVWOUFmSnNOZDJ6TzR3UTZxTzNlMGFnMmp6?=
 =?utf-8?B?bS9YYk5lNFpkbVRMOEM4M0VpOUlCRnpCeURnYXV2UWpzMkg3M0RlZldwckdh?=
 =?utf-8?B?ZmZWWDFOZTVQa2NNNXM5UFJOcnlsZ2VKUWs1Qk8rcXZVQ2E5a0FubXorejR0?=
 =?utf-8?B?Y1hLUy9adk9rTXhVR0p3eG1kT1R3MFpOZnQ2YkdSODh2RGVOQkhBK3dnUTYv?=
 =?utf-8?B?UWkvSksyUXdIbHpwTlFlSkNxVzJYaUpJTnhQOFFZdlk5dUxTVmxFU2dLT3ds?=
 =?utf-8?B?UEptc3R2RGFiL3ZvOEZCOWN3OEFOdDB6ekNCYmtyc2dPd05VdnNYVlZJeUVB?=
 =?utf-8?B?aDdib3l0d01RQUNiem1JSnZEOVlySTZ2WFNFaDJJdE54a2lPWVFtcnhrTGpi?=
 =?utf-8?B?VUEyaFZsWjhCdlYvTUswRnZoZ2ZwWGx3NUxHbGV6RGpLdVIvdzNsclRpR3dj?=
 =?utf-8?B?Rjl5d3B3RC9GajJJamdFTU1XMllKdXVIbVFxc2hGRHlWTDk3SGVRWDhSODNt?=
 =?utf-8?B?UGkvVFVod2Z1NStvQUJoMXFXVmdnRlgySFJ3YTdwR1ZaVWhrb1MwRzhOOXlC?=
 =?utf-8?B?S3VXZkVmUXBwQzl4SWV0ZXE4UEhkRC9CbGpObFNxdzAwUnJTZFJaU0FaSThD?=
 =?utf-8?B?SHJUSm5vQzlXOXZJUTV0N0puRTlZYWYyMGNSOGhaN3B3SDU0and3cHkzcDdM?=
 =?utf-8?B?czVXQTBZcldJTkpFRmtJOURGQ0FTOW8rMjVHK1d1eUMzN0dMWkk5UDlha2Fz?=
 =?utf-8?B?MG5wZ2NyY3R1MDEwOW1QSkhPZkJsRSswTWVnSzVydUFlQ09mUlEveENNbnJG?=
 =?utf-8?B?NHJNTDRlRFMvSWYyL25yY2lGSVBzUWlRZDU1bUd2bHZFTnhORVpMMWxmTk5r?=
 =?utf-8?B?MmY2VmVCcDBpanZVSUVQK0FoOFdGQTIzN1NZa2x4WG9UU2lpNVR5ZEJwWUVY?=
 =?utf-8?B?WUxMTEF2eEwxNlB2L0J5MStRVndzUlJ4RTZhb0RGdXArTDJ6cGlQaTRGSmpt?=
 =?utf-8?B?VFBVdlBoSjNHQWdVSzljVS9pTDlOaGRoangzZW5kVzFxMU8wcXR5T2dZekU3?=
 =?utf-8?B?Ync1V3VLcUQ1Zm5la3RlV0R1RUtaRGkwYzFtd2pmS28ycUhqNVNadW00MVEz?=
 =?utf-8?B?dDhyT1Q5QUhyLzV3WE8xek10THZTS01NVHhidkZENnRxWS9MQWRhQTh2dStY?=
 =?utf-8?B?SHU5TTJDUUNpYU1xcGx3VU8waGJJMm51YVpETFhKZVpqWjZJS283TUFIR1pH?=
 =?utf-8?B?NVNxWTZtYkd6L1dKam05dnQvUFhFc2lleXh5T2orY3QzMWY0dFRzajN4Z25R?=
 =?utf-8?B?M2pPRGpmV0pFWmNhb2toTUhtVW9BRkE2MUxuWFFsL0hLQ2FtYmhYKzZPSVBG?=
 =?utf-8?B?ajhsaGxkUGhZaG1BbzJtNkQvOG9SVDY3emxHYU9wN1VJcEFhUnlQQjZpeFps?=
 =?utf-8?B?MFk2RzQvYVMvL01wL1pXQ0RIU243VktRQ2xrMXJNakNrZmRSZUxhMEM3YnJT?=
 =?utf-8?B?djB4UjdpcGJabmpiU2t0MXNMc09DQmJJMUNtTlJBZTFDalVlT1FSNWREbGpm?=
 =?utf-8?B?SHhMZ2RyOU13amw3YUNMUTJsc21DSTllbHBjcVBCTkYxNThWQ1pLdU93UE1O?=
 =?utf-8?B?bXRYRTdUb3NGa1JaM3pDK0dEU0EzV2FOSDhKY3NCbjc1UVlSaHVETE9qTUlX?=
 =?utf-8?B?b1J3bWJnYm5MU3YwN09NSGRVWTl4Skk0U3JYeUM5RHFwNkNRL21CajR3d05T?=
 =?utf-8?B?QjhNYml1RGJKOHpCRkJOMUlLSFdST3ZHRUFyL0w5V2haekFHRWZzTVdlNFYv?=
 =?utf-8?B?RytJQ3dZNTBGaXFuZW5kdkJuREZ3STNvY2htWit0WkgyZkZZUGg3MXdJR3Zu?=
 =?utf-8?Q?gqXMT0ypsfu44n15Bab23/U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF46B3A1B0FE334F98AE10956E3F8507@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8479218-93b1-4380-68b9-08ddb40748c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 16:42:33.4839
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bC9YlqVObqAlBgL2igXQNfQuTq7DRVqQp1nCiKaLWZlPvm+hy/u+cVOFmmdWSH33/NeNBsaLjNWwyjUeJ9PN4i9anLHeD0yLLcwAU1vu8Ys=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7921
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDE5OjI1ICswMzAwLCBBZHJpYW4gSHVudGVyIHdyb3RlOg0K
PiA+IFRvIGVuc3VyZSBJIHVuZGVyc3RhbmQgY29ycmVjdGx5LCBBbSBJIGNvcnJlY3QgaW4gc2F5
aW5nOiBtb3ZkaXI2NGINCj4gPiBjbGVhcmluZyB0aGUgaW50ZWdyaXR5IHBvaXNvbiBpcyBqdXN0
IGhhcmR3YXJlIGNsZWFyaW5nIHRoZSBwb2lzb24NCj4gPiBiaXQsIHNvZnR3YXJlIHdpbGwgc3Rp
bGwgdHJlYXQgdGhhdCBwYWdlIGFzIHBvaXNvbmVkPw0KPiANCj4gVHlwaWNhbGx5IGFuIGludGVn
cml0eSB2aW9sYXRpb24gd291bGQgaGF2ZSBjYXVzZWQgYSBtYWNoaW5lIGNoZWNrDQo+IGFuZCB0
aGUgbWFjaGluZSBjaGVjayBoYW5kbGVyIHdvdWxkIGhhdmUgbWFya2VkIHRoZSBwYWdlDQo+IFNl
dFBhZ2VIV1BvaXNvbihwYWdlKS4NCj4gDQo+IFNvIHdlIHJlYWxseSBlbmQgdXAgd2l0aCBvbmx5
IDIgY2FzZXM6DQo+IDEuIHBhZ2UgaXMgZmluZSBhbmQgUGFnZUhXUG9pc29uKHBhZ2UpIGlzIGZh
bHNlDQo+IDIuIHBhZ2UgbWF5IGhhdmUgaGFkIGFuIGludGVncml0eSB2aW9sYXRpb24gb3IgYSBo
YXJkd2FyZSBlcnJvcg0KPiAod2UgY2FuJ3QgdGVsbCB3aGljaCksIGFuZCBQYWdlSFdQb2lzb24o
cGFnZSkgaXMgdHJ1ZQ0KDQpDb3VsZCBhbiBhY2Nlc3MgaW4gdXNlcnNwYWNlIHRha2UgYW4gI01D
LCBhbmQgaGF2ZSB0aGUga2VybmVsIHNldCB0aGUgZGlyZWN0IG1hcA0KZm9yIHRoZSBwYWdlIHRv
IE5QIGFuZCBraWxsIHByb2Nlc3M/IFRoZW4gYW5vdGhlciBwcm9jZXNzIHdpdGggYWNjZXNzIHRv
IHRoZQ0KZ21lbSBmZCB0cmllcyB0byBtYXAgaXQgYXMgcHJpdmF0ZSwgYW5kIHRha2UgYSBub24t
aW50ZWdyaXR5IHJlbGF0ZWQgU0VBTU1PREUNCiNNQyBhbmQgZW5kcyB1cCBoZXJlPyBJdCBkb2Vz
IHNlZW0gc2FmZXIgdG8ganVzdCBhdm9pZCB0b3VjaGluZyBpdC4gQnV0IEkgYmV0DQp0aGVyZSBh
cmUgbWFueSBjYXNlcyBsaWtlIHRoaXMsIGFuZCB3ZSBjYW4ndCBjaGVjayBwb2lzb24gZXZlcnl3
aGVyZS4gDQoNCklmIGd1ZXN0bWVtZmQgdHVybnMgaW50byBtb3JlIG9mIGEgcGVyc2lzdGVudCBh
bGxvY2F0b3IsIGluc3RlYWQgb2YgYSBwZXItVk0NCnRoaW5nLCBpdCBwcm9iYWJseSBuZWVkcyB0
byBkbyBzb21lIG9mIHRoZSBjaGVja3MgdGhhdCB0aGUgcGFnZSBhbGxvY2F0b3IgZG9lcywNCmxp
a2UgcG9pc29uIGNoZWNrcy4NCg==

