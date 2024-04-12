Return-Path: <kvm+bounces-14572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD078A36BD
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2F081F260C5
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC541509BA;
	Fri, 12 Apr 2024 20:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ekIMgdne"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60BA814F9C6;
	Fri, 12 Apr 2024 20:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712952588; cv=fail; b=o7IEV/qZxwSz7dzmj9vdbdhGf4mIph5T4yiPYRgbTKz59BZL7jgmvNfnU15qRekhSJfIs3NTwjUQrXzChKqf8d3/cbbLxAui3HlFJ8ALtJAPwB43UbYUT5Z8YCAm3jMU2s3CHguT+h2vlVIO50mdqnE7uctFt3Pxln/5146YvmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712952588; c=relaxed/simple;
	bh=+12x3k37Th1YhwEI4tOkgFmpvV7q7HyJgAA+9BnyimY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nw4PLf7K3dYJ3C9zAoYMeKcdXMyhv5b6rTpsZFWg4BqwGdBpGAQR5fYpftlBw5ngnoJyRJEOVJ3YOQUmO/+VMqROnrvGeVEiv19PZi301uqPtn0HCqp6Rwv0hRGjIMfepg/eUq+R2XTvr1VIMAOMtTgiOBa7uAhi/Hg48tYDR3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ekIMgdne; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712952587; x=1744488587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+12x3k37Th1YhwEI4tOkgFmpvV7q7HyJgAA+9BnyimY=;
  b=ekIMgdnekVSY1lWxE1FdTEBe52GQBEz3rXqUktyV7NUAPKptLmP+7F8u
   IpuR9VdTKJXsjj+nV5O/waRgETd/rOPkSjc+2cnVa3tgnhwVD4ttLlnSM
   DUxRkRX6ylCmHE+blRpE6tCUz4uRVklfd8rL6QyZJipREe4Rz7Md8O++n
   Euasbe5FP3UWFkRHnDo9AXYWSfzPXfVxK4qoQB/Tj97GTor4IG1mgV9in
   H63E3RNETopzlN2hJ3K8sDx1Pl4+pM1ucSc26bZcKwItPXkYwMKlXgP/l
   4vSe/c9vbIi2+pA+tAtZSj3Pbj7maBl3b27Kr2X1elKdBZ1bl5KUzaYwk
   Q==;
X-CSE-ConnectionGUID: D3R+AsUuQXChN4/j7/3nBg==
X-CSE-MsgGUID: BwZhxUUwRHePFjFw8LXQ/Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8341519"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8341519"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:09:46 -0700
X-CSE-ConnectionGUID: NTvadOngQvaUwAGOMakLNQ==
X-CSE-MsgGUID: M0xatTy9S4KY4aXzgdfd4w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="52491646"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 13:05:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 13:05:46 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 13:05:46 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 13:05:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxgpwuAXmhKEJ/nxV5RoRNQbqOfEN6K+tEZORISGqj1gbppJ+Ba3xzxe5v9qWEB9z77TQHqXeyRC/qaqdEBACdYVyOocNDhOr35/jxjli6JDtYKnDDC5607y2tCiGOfinJiN92OcX5wMNVFNgXntbQdSd7MTD16vyKGDtsC9UYNgYHRhTj9nkr1/iIzd4JizWGAdCGgK9cSjhSZRCDufGp4UUQ4jxavGbDIsY5V4yTvb6ulRnuZVo5LstgMeuTJBw+YB8sJLSQ+iQEDl2BmaAP+y4sX0Tp+vAl1/eQrr+lS3yhbmf1LG7DwR9L8e/6GHTE+ojwKFij7g+xOWfSz4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+12x3k37Th1YhwEI4tOkgFmpvV7q7HyJgAA+9BnyimY=;
 b=IRanzegYGAKaJGZDyScoMlcG2oLOUT9SzqarxiNAuyMk8UsMJQh2ppa1jZMCm9l3Ij/JOqoZ4LMLDhK0JGMP6zsyD47hsTJEOuhRSxrpN6lfTKWDL2a+GRhiMUzd1nCtDnLFM1Es7SVx0/1n42Vjjs55wKERyuZUsUViHulOLljYeD+BLOJP1VFX3a0ObP3whUTKmbJuGLfcNG5xa1iGJCFBamQdYcVosPiOfu1zzEzN2qW5cjn/ssNa0Lrx+GlJqF72RMDDMVT3XXqUbF0GHDzQWOs8C2Zfazb49JB96F2357WIZyu/9DsHRg5Xv+bHS76DLbRy+xWbhGf2EicolA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4731.namprd11.prod.outlook.com (2603:10b6:303:2f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Fri, 12 Apr
 2024 20:05:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 20:05:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "davidskidmore@google.com" <davidskidmore@google.com>, "seanjc@google.com"
	<seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "srutherford@google.com"
	<srutherford@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pankaj.gupta@amd.com" <pankaj.gupta@amd.com>, "Wang, Wei W"
	<wei.w.wang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Topic: [ANNOUNCE] PUCK Notes - 2024.04.03 - TDX Upstreaming Strategy
Thread-Index: AQHah3qOMqOgejWDsE6lTffyy9yei7FcJJkAgAJt44CAABa0AIAAE3AAgAAzlgCAAAskgIAAE5mAgAAfEYCAANyAgIAACmCAgAAHM4CAAAowgIACJcGAgADccgCAAA75gIAAAsoAgAA5l4CAAOdlgIAAlpaAgAAo1IA=
Date: Fri, 12 Apr 2024 20:05:44 +0000
Message-ID: <a5dd127e9f13fb012edea4a02492abe34fd3c259.camel@intel.com>
References: <8b40f8b1d1fa915116ef1c95a13db0e55d3d91f2.camel@intel.com>
	 <ZhVdh4afvTPq5ssx@google.com>
	 <4ae4769a6f343a2f4d3648e4348810df069f24b7.camel@intel.com>
	 <ZhVsHVqaff7AKagu@google.com>
	 <b1d112bf0ff55073c4e33a76377f17d48dc038ac.camel@intel.com>
	 <ZhfyNLKsTBUOI7Vp@google.com>
	 <2c11bb62-874e-4e9e-89b1-859df5b560bc@intel.com>
	 <ZhgBGkPTwpIsE6P6@google.com>
	 <437e0da5de22c0a1e77e25fcb7ebb1f052fef754.camel@intel.com>
	 <19a0f47e-6840-42f8-b200-570a9aa7455d@intel.com>
	 <20240412173935.GH3039520@ls.amr.corp.intel.com>
In-Reply-To: <20240412173935.GH3039520@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4731:EE_
x-ms-office365-filtering-correlation-id: 201d6659-fb4f-4be3-211c-08dc5b2befc4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: =?utf-8?B?Y016eW5vYXNPamdxdmtuZDd3blVPVDVydFdweDUzMEV3WXhnNU1FMXUzS0pP?=
 =?utf-8?B?QjVld29Ya0VmMkZtc2FjMDhiaWMwREtEQnFwdGJFZE5CaEtjWFVHNXlaOUlm?=
 =?utf-8?B?VE14Q25QTWlFZUpJTkh3VEFDdDRtcDlablNSTkZzcG1FRTlmbldrUHRyV1lJ?=
 =?utf-8?B?MFgwN0V6Tlp4RW91YTlSblRhaFNtbGpKWklISzhvT1RHTFNlT1NQVFc1WEk4?=
 =?utf-8?B?Sm5JbFBmSUUveWEvNnpoVVdOSjhDTjNEUk8xUXYvWWVJQ29zTUJiSjZmTDlk?=
 =?utf-8?B?d0tXMmhHV1kxdmNlOVcrQWZZVzZXcWxQaDFSNDBQNisxclY0SHhaNGc2YXFl?=
 =?utf-8?B?Y28rV2QvTFZobGdlbURBQzZDck9sNWRRWmZmN095V3NGZlV0cTc3Z085N1FK?=
 =?utf-8?B?K09hMGRFVEJZNWJKczBicnl1VzI1aUxUNHRSQmRLazk4QkVtVjgzVEgyZjgx?=
 =?utf-8?B?SmZwM2Y0MEVVeExjZFBrU3VscS9DMFNnYmZMeUh6bC9QVlBWM3hpSE5PNkly?=
 =?utf-8?B?VDJVSzNXamt4SEcyZ3VIM2QvYTc1VER3VW8rV1QvL0RpY0tjZ3NMeHBBSHFs?=
 =?utf-8?B?eWFxTlJhM0hQTXVNbFFnMFBtRzBla3cvTSt1R0d0NDFlWVpBV0VwZWlocHB4?=
 =?utf-8?B?alVJVURwUmNkb0FnL3dJL0hSOThQaG5uQ3VFOFNXRmVob0Zmejhzc2h1dGZ6?=
 =?utf-8?B?SmpybkQ5WVVBZVkxTUVQLzY3L0Y0a3F6TS9jWEgrd0lsTlN3bDlHenVZSHpw?=
 =?utf-8?B?ekpPdVpDZ0tzMlY1eWlhd0FTUHJTa2dxaXlOd0tmak5wRTNINkZxMmlxUjVB?=
 =?utf-8?B?SWVEOGtjVVpkVnR2U2UxS0NqWWdGRUo5c1NyN0hsd21CV1VHQkVwcFV0dTJQ?=
 =?utf-8?B?YTQ0d2RGZUhnK0U2WVVyS0ZaNWd4MWpJSklVUTZzdlBmTUl5dWptVzlDZEIw?=
 =?utf-8?B?S21pZEN0THhxa09ZQ3A4YzdqSGdTSjlNZk1YT04veGZwai96Y3pDalVCbFhD?=
 =?utf-8?B?RW1OUGZXNis2bnZNUHZvR2dFZXRVVnV0MDlyMGJvcDc0ZjZIS1FJWnY5OFZX?=
 =?utf-8?B?dFEzcktEY25WQWhVNW1iYlVoR2kxL21JRXhMYTF4WXQ3bWZjeURRN3pnK21T?=
 =?utf-8?B?ZXEzQ3AzUHBuTEw1Uks4bUhmK08vL01DcVJ0b3VIcUgxdFZncGhES1NBZHdN?=
 =?utf-8?B?RjloTDBqOFlIdDVrZUhvQ3VtbllzU3U1WTNqNTRwVUFpQ2UyMnA2QnFYYWZs?=
 =?utf-8?B?SERRNmhhVEJkWm9mY2ZTMXpBSWxQUlQ1cjlMaHhFYm9KUDQ3ZXk5aU4wc3NH?=
 =?utf-8?B?VGxLM0FXaW1lS3RRYTd5TWkvRndCb0szWDBjemNQamdjYlBXSEV3d1dWNUpH?=
 =?utf-8?B?MjI5bzVHYVR6Z2dEQnRPeVREcldNWWFzaTZaOTlvMndYZ2RuZUhLdHZUQ1k4?=
 =?utf-8?B?ZGsvZ3hCeDB2WWVxQyt4VmxiT1hmYTJRazFJeEthZzN3eGVFQ3dzdkQzREk0?=
 =?utf-8?B?MWR2OEN4VkZVR01pdTFzMGFvdDdrVHRRNHhLUXplcVdoSFBBbEJaaTFMcnJa?=
 =?utf-8?B?UU95YXQ5QjdVSktDZXhPcEtFcjdxUFRqVHdVa1Q3V2FSbm5TcjdRUGtRblJ2?=
 =?utf-8?B?a3o0cUdSRW9CU2ZyMmh4b2l0RzhPazljRGsrM1MxeFFSME5NK1RaeVVWazlR?=
 =?utf-8?B?OFpEWjVETk0zUml5ZXlKVkVWbmRDTllIOGlsRk1CUFdUWXFYeEZCR3JRTkdk?=
 =?utf-8?B?WHpQNXN5UUowWlJFOFVDbDdmUVY0Z3RHMFlkNDRmUDJFZE1vRkovaDhTZXhz?=
 =?utf-8?B?N25iVVRFMFludEZBVGo2Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFoxaTVnbE4xUnJSOG9VUFUvSmdpdHVqY3Npems1Y0pEUytkWjFTNDhyNDAx?=
 =?utf-8?B?RjRWa3pSdVlva25CR0FZbm81c2tYc0VXaHc5S2RpZFFhckd4ZE4veFVURFFu?=
 =?utf-8?B?eDR0bCsyaVprR0VpeHh4RGVCSmlGdkUrTElrakZRYlBsbXI3RWxtQWc4SnNi?=
 =?utf-8?B?emFsM2g2RkZXVi9GQWJZVFV5S0hZY2dBUkZnbGxoYklqeXZSaGhNSXp5Rm56?=
 =?utf-8?B?MkFUZ1A0VUU2YlBZSDFNSHRUaWovc2Z2VFdjR2Uwd3d6UEEyUXVwUU5EYmZw?=
 =?utf-8?B?cG9OanFFTHhHVmJDQzJHOElmblQrb0pWQmkyVHNFZW85Y0NXY3NNS0NwL2xx?=
 =?utf-8?B?V0pHWTNpdXJJR1Q5dGptTU85eHZJbEMwWnkrUkFUZlVkdjZaMmJJbllKZTJ6?=
 =?utf-8?B?T0tpM2gvOGRQQWNJR3JTMEFkbUpxS3o3cFg4YXlnSHM5N2hvcVZhTFB5b2p1?=
 =?utf-8?B?S3prZkl4SWFZVmdVTDFzT1REcUFQNERUZmdka2RQLzN4ck1oR0liK1VnRDNr?=
 =?utf-8?B?dnRTUk9SSlhSQllkWUwxVVRWVE5EMFlWK1NBcTdhTmtZUTBhKzEwRllJaGlr?=
 =?utf-8?B?VURaVTRwdXFIT01yU2k3WEp1Wnd5aDVXYjJjVUZwR3lJdGdHNTNuT3VUaFRY?=
 =?utf-8?B?bnpJbGlJd2JWK0VaaERvbVVyQWJncUNpb0U0UW00empyeFFWUVNiM2hiR29J?=
 =?utf-8?B?SE9OeERreXp3Nmd6M1VYNmNkTEpRMmlwdjcwZE56RHp1emNRUmhsSEZsdjJE?=
 =?utf-8?B?d292cU5uaXVDQU5Tdyt5WmM4N2h1aXd0MmgvbzFzQm9OeGthSmpnc1daaXpy?=
 =?utf-8?B?NFZBekhHL3B1akx6RlREOTZmdEpNWXBicFVMVXZRQ1Z6c3hTeUJ2QUJKdjcv?=
 =?utf-8?B?Q1pQVXExOU96QTg0SVJjY2NSWnAxa0t4WTN0MzdQSVgyaGtxMUtpaGlJTW9D?=
 =?utf-8?B?SXExNjJ0TGRlcTQvOGFXMEFlUC82czRDK3hCUmNISmlOLzVRRVpGd3RTaHVZ?=
 =?utf-8?B?UTZjb0srRHkvN3oyeTVIbGwyenlvc2o0cUt3SEVYUllhN3RoYlB5ZHpjUlp5?=
 =?utf-8?B?UzRaVERLYjEwZFVrL2VLK1NueFJYTitaKzZ5K1ExMXRMcGlGVXNXYlM4Zm00?=
 =?utf-8?B?ZXJ0Nmh1Y0djVjcrdmZFaEN6ZlA5WHFMVlVwVFdzL2JEcm5GaWcvNHpmUWo5?=
 =?utf-8?B?aklsWGV4eUhmRFV5L2s4dHdOZUs3NDBXUnB4UDFFMXk3NlhRUWZxN0NyUW5s?=
 =?utf-8?B?ZVROQjM1TktjRHFMS3BiTkpOUU9JV1A4b1BSZEMzRUhnak14QU5MY0N4REJH?=
 =?utf-8?B?TkZXaFlnOC9YQ2IrVTFnd3BZY01CaGg4K2svZmllbGI5Wk5aMFRLME4wK3ZF?=
 =?utf-8?B?Uk9XNkpGZm1RQ0FtMlB3cllBYWJWRGxKR25nTkk5YnA5V2puL3RUdTNIa293?=
 =?utf-8?B?SWlSWkc5UC8wbmU2K0w5REJvYmNwdHgvZkFzak5xd2hpR0NIa3ZSNGprL0Fr?=
 =?utf-8?B?OG1KMjZvSC9HaDdqOVp3TWNtb2pBK2tKcEpySmZlSzQxVjBCVzF3MUJVRW1v?=
 =?utf-8?B?M2xZMFVoeTd1d0dUdS9hTytKMEJMM1ZrdkJrMVB0cjBxRlJaOTVzNmpVejFU?=
 =?utf-8?B?eXlZczZvSW5VcnFWTXcrbmZWc25taTVQRkptVlVsZDBxcjY3Y0p1RnRFL2NC?=
 =?utf-8?B?enJuSVJKN2RrQ2JWZlJZV3F5dHFIVmQ1TjhXVnlpS1EvZDdRNHVMMTlGQ01P?=
 =?utf-8?B?SUFGeWZWSjMvZWErbWtDZkZ3Nm51ci9VY3VyRUhFQS9aZXdvaGpiNUZwM3Z5?=
 =?utf-8?B?YmZWMDhXZDRvMTJTb3liT1paRWJLZFlmN3lXRU9paG9sRlIyajQvR2JnOWpH?=
 =?utf-8?B?Z0tNUklyNElFTDdadnczaUN6Wk1sb2RsK2EzRDFrcFJyalR5L1B6QzBrUWFw?=
 =?utf-8?B?b0psTUlkTURkMjBaVEtDTnNsakZ4SUdyaTFXWVR2ZkJsWjQrclI5eFhoMVkw?=
 =?utf-8?B?VllRSHY0ME9QTGNBSDNqVHNBdmJiZUR5Ym1SQlljL1B2T0ZnYVJyRGt4d1pr?=
 =?utf-8?B?RVlubkJLM3R4LzljTTdzSTgwaCtxU2ZKOWhlYzc5UmQzR0JnSVd2bEdocWFW?=
 =?utf-8?B?b3h5dEZDSm10Z09rNGZGNjR5SEwzVFRqODllUG41U0EvSzd6eUFsZHUzblV1?=
 =?utf-8?B?Y1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12D8B82501E84E4993D798E83AF350D8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 201d6659-fb4f-4be3-211c-08dc5b2befc4
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 20:05:44.4061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0qVxcki1cUmyfPzxZoxy4HC0HGqrMZMuV4T9MSJ/KDNOBHj4VQm8L4Mg5D1H7R+RLBveMvhlA6ZCRB7b5DK67Un/x0FJIiOW5YFqvu2s0OQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4731
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA0LTEyIGF0IDEwOjM5IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gRnJpLCBBcHIgMTIsIDIwMjQgYXQgMDQ6NDA6MzdQTSArMDgwMCwNCj4gWGlhb3lhbyBM
aSA8eGlhb3lhby5saUBpbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gPiA+IFRoZSBzZWNvbmQgaXNz
dWUgaXMgdGhhdCB1c2Vyc3BhY2UgY2Fu4oCZdCBrbm93IHdoYXQgQ1BVSUQgdmFsdWVzIGFyZQ0K
PiA+ID4gY29uZmlndXJlZA0KPiA+ID4gaW4gdGhlIFRELiBJbiB0aGUgZXhpc3RpbmcgQVBJIGZv
ciBub3JtYWwgZ3Vlc3RzLCBpdCBrbm93cyBiZWNhdXNlIGl0DQo+ID4gPiB0ZWxscyB0aGUNCj4g
PiA+IGd1ZXN0IHdoYXQgQ1BVSUQgdmFsdWVzIHRvIGhhdmUuIEJ1dCBmb3IgdGhlIFREWCBtb2R1
bGUgdGhhdCBtb2RlbCBpcw0KPiA+ID4gY29tcGxpY2F0ZWQgdG8gZml0IGludG8gaW4gaXRzIEFQ
SSB3aGVyZSB5b3UgdGVsbCBpdCBzb21lIHRoaW5ncyBhbmQgaXQNCj4gPiA+IGdpdmVzDQo+ID4g
PiB5b3UgdGhlIHJlc3VsdGluZyBsZWF2ZXMuIEhvdyB0byBoYW5kbGUgS1ZNX1NFVF9DUFVJRCBr
aW5kIG9mIGZvbGxvd3MgZnJvbQ0KPiA+ID4gdGhpcw0KPiA+ID4gaXNzdWUuDQo+ID4gPiANCj4g
PiA+IE9uZSBvcHRpb24gaXMgdG8gZGVtYW5kIHRoZSBURFggbW9kdWxlIGNoYW5nZSB0byBiZSBh
YmxlIHRvIGVmZmljaWVudGx5DQo+ID4gPiB3ZWRnZQ0KPiA+ID4gaW50byBLVk3igJlzIGV4aXRp
bmcg4oCcdGVsbOKAnSBtb2RlbC4gVGhpcyBsb29rcyBsaWtlIHRoZSBtZXRhZGF0YSBBUEkgdG8g
cXVlcnkNCj4gPiA+IHRoZQ0KPiA+ID4gZml4ZWQgYml0cy4gVGhlbiB1c2Vyc3BhY2UgY2FuIGtu
b3cgd2hhdCBiaXRzIGl0IGhhcyB0byBzZXQsIGFuZCBjYWxsDQo+ID4gPiBLVk1fU0VUX0NQVUlE
IHdpdGggdGhlbS4gSSB0aGluayBpdCBpcyBzdGlsbCBraW5kIG9mIGF3a3dhcmQuICJUZWxsIG1l
DQo+ID4gPiB3aGF0IHlvdQ0KPiA+ID4gd2FudCB0byBoZWFyPyIsICJPayBoZXJlIGl0IGlzIi4N
Cj4gPiA+IA0KPiA+ID4gQW5vdGhlciBvcHRpb24gd291bGQgYmUgdG8gYWRkIFREWCBzcGVjaWZp
YyBLVk0gQVBJcyB0aGF0IHdvcmsgZm9yIHRoZSBURFgNCj4gPiA+IG1vZHVsZSdzIOKAnGFza+KA
nSBtb2RlbCwgYW5kIG1lZXQgdGhlIGVudW1lcmF0ZWQgdHdvIGdvYWxzLiBJdCBjb3VsZCBsb29r
DQo+ID4gPiBzb21ldGhpbmcNCj4gPiA+IGxpa2U6DQo+ID4gPiAxLiBLVk1fVERYX0dFVF9DT05G
SUdfQ1BVSUQgcHJvdmlkZXMgYSBsaXN0IG9mIGRpcmVjdGx5IGNvbmZpZ3VyYWJsZSBiaXRzDQo+
ID4gPiBieQ0KPiA+ID4gS1ZNLiBUaGlzIGlzIGJhc2VkIG9uIHN0YXRpYyBkYXRhIG9uIHdoYXQg
S1ZNIHN1cHBvcnRzLCB3aXRoIHNhbml0eSBjaGVjaw0KPiA+ID4gb2YNCj4gPiA+IFREX1NZU0lO
Rk8uQ1BVSURfQ09ORklHW10uIEJpdHMgdGhhdCBLVk0gZG9lc27igJl0IGtub3cgYWJvdXQsIGJ1
dCBhcmUNCj4gPiA+IHJldHVybmVkIGFzDQo+ID4gPiBjb25maWd1cmFibGUgYnkgVERfU1lTSU5G
Ty5DUFVJRF9DT05GSUdbXSBhcmUgbm90IGV4cG9zZWQgYXMgY29uZmlndXJhYmxlLg0KPiA+ID4g
KHRoZXkNCj4gPiA+IHdpbGwgYmUgc2V0IHRvIDEgYnkgS1ZNLCBwZXIgdGhlIHJlY29tbWVuZGF0
aW9uKQ0KPiA+IA0KPiA+IFRoaXMgaXMgbm90IGhvdyBLVk0gd29ya3MuIEtWTSB3aWxsIG5ldmVy
IGVuYWJsZSB1bmtub3duIGZlYXR1cmVzIGJsaW5kbHkuDQo+ID4gSWYgdGhlIGZlYXR1cmUgaXMg
dW5rbm93biB0byBLVk0sIGl0IGNhbm5vdCBiZSBlbmFibGUgZm9yIGd1ZXN0LiBUaGF0J3Mgd2h5
DQo+ID4gZXZlcnkgbmV3IGZlYXR1cmUgbmVlZHMgZW5hYmxpbmcgcGF0Y2ggaW4gS1ZNLCBldmVu
IHRoZSBzaW1wbGVzdCBjYXNlIHRoYXQNCj4gPiBuZWVkcyBvbmUgcGF0Y2ggdG8gZW51bWVyYXRl
IHRoZSBDUFVJRCBvZiBuZXcgaW5zdHJ1Y3Rpb24gaW4NCj4gPiBLVk1fR0VUX1NVUFBPUlRFRF9D
UFVJRC4NCg0KSSAqdGhpbmsqIHRoZSBwYXJ0IGluIHRoZSBkb2NzIHRoYXQgc2F5cyBWTU1zIG5l
ZWQgdG8gZG8gdGhpcyBpcyBjb25jZXJuZWQgd2l0aA0KZml4ZWQgMSBiaXRzIGJlY29taW5nIGNv
bmZpZ3VyYWJsZS4gU28gbm90IG5ld2x5IGRlZmluZWQgYml0cywgYnV0IGp1c3Qgb25lcw0KdGhh
dCB3ZXJlIHByZXZpb3VzbHkgZml4ZWQgYXMgMSBhbmQgbm93IG5lZWQgdG8gYmUgY29uZmlndXJh
YmxlIHRvIDEgdG8gcmVzdWx0DQppbiBubyBjaGFuZ2UuIFdlIG5lZWQgdG8gY2xhcmlmeSB0aGlz
Lg0KDQo+IA0KPiBXZSBjYW4gdXNlIGRldmljZSBhdHRyaWJ1dGVzIGFzIGRpc2N1c3NlZCBhdA0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vQ0FCZ09iZlp6a05pUDNxOHA9S3B2dkZuaDht
NnFjSFg0PXRBVGFKYzdjdlZ2MlFXcEpRQG1haWwuZ21haWwuY29tLw0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9rdm0vMjAyNDA0MDQxMjEzMjcuMzEwNzEzMS02LXBib256aW5pQHJlZGhhdC5j
b20vDQo+IA0KPiBTb21ldGhpbmcgbGlrZQ0KPiANCj4gI2RlZmluZSBLVk1fWDg2X0dSUF9URFjC
oMKgwqDCoMKgwqDCoMKgIDINCj4gaW9jdGwoZmQsIEtWTV9HRVRfREVWSUNFX0FUVFIsIChLVk1f
WDg2X0dSUF9URFgsIG1ldGFkYXRhX2ZpZWxkX2lkKSkNCg0KVGhpcyB3b3VsZCBiZSBpbnN0ZWFk
IG9mIEFUVFJJQlVURVMgYW5kIFhGQU0/DQoNCj4gDQo+IA0KPiA+ID4gMi4gS1ZNX1REWF9JTklU
X1ZNIGlzIHBhc3NlZCB1c2Vyc3BhY2VzIGNob2ljZSBvZiBjb25maWd1cmFibGUgYml0cywgYWxv
bmcNCj4gPiA+IHdpdGgNCj4gPiA+IFhGQU0gYW5kIEFUVFJJQlVURVMgYXMgZGVkaWNhdGVkIGZp
ZWxkcy4gVGhleSBnbyBpbnRvIFRESC5NTkcuSU5JVC4NCj4gPiA+IDMuIEtWTV9URFhfSU5JVF9W
Q1BVX0NQVUlEIHRha2VzIGEgbGlzdCBvZiBDUFVJRCBsZWFmcy4gSXQgcHVsbHMgdGhlIENQVUlE
DQo+ID4gPiBiaXRzDQo+ID4gPiBhY3R1YWxseSBjb25maWd1cmVkIGluIHRoZSBURCBmb3IgdGhl
c2UgbGVhZnMuIFRoZXkgZ28gaW50byB0aGUgc3RydWN0DQo+ID4gPiBrdm1fdmNwdSwNCj4gPiA+
IGFuZCBhcmUgYWxzbyBwYXNzZWQgdXAgdG8gdXNlcnNwYWNlIHNvIGV2ZXJ5b25lIGtub3dzIHdo
YXQgYWN0dWFsbHkgZ290DQo+ID4gPiBjb25maWd1cmVkLg0KPiANCj4gQW55IHJlYXNvbiB0byBp
bnRyb2R1Y2UgS1ZNX1REWF9JTklUX1ZDUFVfQ1BVSUQgaW4gYWRkaXRpb24gdG8NCj4gS1ZNX1RE
WF9JTklUX1ZDUFU/wqAgV2UgY2FuIG1ha2Ugc2luZ2xlIHZDUFUgS1ZNIFREWCBpb2N0bCBkbyBh
bGwuDQoNCk5vLCB0aGF0IGlzIGEgZ29vZCBpZGVhIHRvIHVzZSBLVk1fVERYX0lOSVRfVkNQVS4N
Cg0KPiANCj4gDQo+ID4gPiBLVk1fU0VUX0NQVUlEIGlzIG5vdCB1c2VkIGZvciBURFguDQo+IA0K
PiBXaGF0IGNwdWlkIGRvZXMgS1ZNX1REWF9JTklUX1ZDUFVfQ1BVSUQgYWNjZXB0P8KgIFRoZSBv
bmUgdGhhdCBURFggbW9kdWxlDQo+IGFjY2VwdHMgd2l0aCBUREguTU5HLklOSVQoKT/CoCBPciBh
bnkgY3B1aWRzIHRoYXQgS1ZNX1NFVF9DUFVJRDIgYWNjZXB0cz8NCj4gSSdtIGFza2luZyBpdCBi
ZWNhdXNlIFREWCBtb2R1bGUgdmlydHVhbGl6ZXMgb25seSBzdWJzZXQgb2YgQ1BVSURzLiANCj4g
VERHLlZQLlZNQ0FMTDxDUFVJRD4gd291bGQgbmVlZCBpbmZvIGZyb20gS1ZNX1NFVF9DUFVJRC4N
Cg0KSXQgc2hvdWxkIG9ubHkgdGFrZSBiaXRzIHRoYXQgYXJlIGV4cG9zZWQgYnkgS1ZNIGFzIGNv
bmZpZ3VyYWJsZSBmb3IgVERYIHdoaWNoDQphcmUgdGhvc2UgdGhhdCBLVk0ga25vd3MgYWJvdXQg
QU5EIHRoZSBURFggbW9kdWxlIHN1cHBvcnRzLiBUaGUgb3RoZXIgZmVhdHVyZXMNCmNvbWUgaW4g
YXMgQVRUUklCVVRFUyBvciBYRkFNIGJpdHMgKG9yIEtWTSB2ZXJzaW9ucyBvZiB0aGUgc2FtZSBj
b25jZXB0KS4NCg0KPiANCj4gDQo+ID4gPiBUaGVuIHdlIGdldCBURFggbW9kdWxlIGZvbGtzIHRv
IGNvbW1pdCB0byBuZXZlciBicmVha2luZyBLVk0vdXNlcnNwYWNlDQo+ID4gPiB0aGF0DQo+ID4g
PiBmb2xsb3dzIHRoaXMgbG9naWMuIE9uZSB0aGluZyBzdGlsbCBtaXNzaW5nIGlzIGhvdyB0byBo
YW5kbGUgdW5rbm93bg0KPiA+ID4gZnV0dXJlDQo+ID4gPiBsZWFmcyB3aXRoIGZpeGVkIGJpdHMu
IElmIGEgZnV0dXJlIGxlYWYgaXMgZGVmaW5lZCBhbmQgZ2V0cyBmaXhlZCAxLCBRRU1VDQo+ID4g
PiB3b3VsZG4ndCBrbm93IHRvIHF1ZXJ5IGl0Lg0KPiA+IA0KPiA+IFdlIGNhbiBtYWtlIEtWTV9U
RFhfSU5JVF9WQ1BVX0NQVUlEIHByb3ZpZGUgYSBsYXJnZSBlbm91Z2ggQ1BVSUQgbGVhZnMgYW5k
DQo+ID4gS1ZNIHJlcG9ydHMgZXZlcnkgbGVhZnMgdG8gdXNlcnBzYWNlLiBJbnN0ZWFkIG9mIHNv
bWV0aGluZyB0aGF0IHVzZXJzcGFjZQ0KPiA+IGNhcmVzIGxlYWZzIFgsWSxaIGFuZCBLVk0gb25s
eSByZXBvcnRzIGJhY2sgbGVhZnMgWCxZLFogdmlhDQo+ID4gS1ZNX1REWF9JTklUX1ZDUFVfQ1BV
SUQuDQo+IA0KPiBJZiBuZXcgQ1BVSUQgaW5kZXggaXMgaW50cm9kdWNlZCwgdGhlIHVzZXJzcGFj
ZSB3aWxsIGdldCBkZWZhdWx0IHZhbHVlcyBvZg0KPiBDUFVJRHMgYW5kIGRvbid0IHRvdWNoIHVu
a25vd24gQ1BVSURzP8KgIE9yIEtWTV9URFhfR0VUX0NPTkZJR19DUFVJRCB3aWxsIG1hc2sNCj4g
b3V0IENQVUlEIHVua25vd24gdG8gS1ZNPw0KDQpUaGUgQVBJIHRvIGdldCBhdCB0aGlzIGRhdGEg
b25seSBhbGxvd3MgZm9yIDI1NiBwb3NzaWJsZSBsZWFmcy4gQnV0IGl0IGFsc28NCmFsbG93cyBm
b3IgMjU2IGJpdHMgb2YgZWl0aGVyIHN1YiBsZWFmcyBvciBzcGVjaWZ5aW5nIG5vIHN1YmxlYWYu
IFNvIHRvdGFsDQpwb3NzaWJseSB2YWx1ZXMgaXMgNjU1MzYuIFRoZXJlIGlzIGFub3RoZXIgZmll
bGQgQ1BVSURfVkFMSUQsIHdoaWNoIHNheXMgIk5vbi0NCmFyY2hpdGVjdHVyYWwiIGFuZCBkb2Vz
bid0IHNlZW0gdG8gaGF2ZSBhbnl0aGluZyBvbiB0aGUgc3VibGVhZnMgZWl0aGVyLg0KDQpXZSBj
b3VsZCBhc2sgdG8gbWFrZSBhbGwgZnV0dXJlIGJpdHMgY29uZmlndXJhYmxlIGFuZCBkZWZhdWx0
IDAuIEZvciB0aGUgc2ltcGxlDQppbnN0cnVjdGlvbiBzdXBwb3J0IHR5cGUgQ1BVSUQgYml0cywg
SSBkb24ndCBrbm93IGlmIHRoZXJlIHdvdWxkIGFsd2F5cyBiZSBhDQpmdW5jdGlvbmFsIHByb2Js
ZW0gZm9yIEtWTSBpZiB0aGV5IGJlY2FtZSB0aGUgbmF0aXZlIHZhbHVlLiBCdXQgdGhpcyByZXF1
aXJlbWVudA0Kd291bGQgbWFrZSB0aGluZ3MgbW9yZSBjb25zaXN0ZW50LiBFdmVuIGlmIHdlIGhh
dmUgYSBuZXcgbWV0YWRhdGEgQVBJIHRvIGdldCB0aGUNCnNwZWNpZmljYWxseSBmaXhlZCBiaXRz
LCBpdCBkb2Vzbid0IGhlbHAgd2l0aCB0aGUgcHJvYmxlbSBvZiBuZXcgYml0cyB0aGF0IHN0YXJ0
DQphcyBob3N0IHZhbHVlIG9yIGZpeGVkIDEuIFNvIEkgdGhpbmsgVERYIG1vZHVsZSBndWFyYW50
ZWVzIGFyZSB0aGUgb25seSB3YXkgdG8NCmRlYWwgd2l0aCBuZXcgYml0cyBsaWtlIEtWTSBkb2Vz
IHRvZGF5Lg0KDQpXZSBjb3VsZCBhbHNvIGFzayBmb3Igc29tZXRoaW5nIG1vcmUgZmxleGlibGUs
IGxpa2U6IFRoZSBURFggbW9kdWxlIGNhbm5vdCBzZXQNCm5ldyBiaXRzIHRvIGZpeGVkIDEgb3Ig
bmF0aXZlIHZhbHVlLCB1bmxlc3MgaXQgd29uJ3QgYnJlYWsgYW55IGV4aXN0aW5nIGtlcm5lbHMN
Cm9yIHVzZXJzcGFjZS4NCg0KVGhpcyB3YXkgZm9yIHNvbWUgc2ltcGxlIG5ldyBpbnN0cnVjdGlv
biBiaXRzIHRoZXkgY2FuIGxlYXZlIHRoZW0gbmF0aXZlL2ZpeGVkDQphbmQgaXQgY291bGQgc2lt
cGxpZnkgdGhlIFREWCBtb2R1bGUuIEJ1dCB0aGVuIHRoZSBrbm93bGVkZ2Ugb2Ygd2hhdCBiaXRz
IGFyZQ0Kc2V0IGJlY29tZXMgaW5jb25zaXN0ZW50Lg0KDQpIbW0uLi4NCg==

