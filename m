Return-Path: <kvm+bounces-26153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A007A97239A
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:26:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD6A7B2264E
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 20:26:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD1018A6B1;
	Mon,  9 Sep 2024 20:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i0NV8Aaa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC13618C31;
	Mon,  9 Sep 2024 20:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725913571; cv=fail; b=uDoPUnNxWXmCizufMuPn7Fhit/3h8hD0GOGHbwgqIUKRAcg8EMyG6yK6Ytz/PBkmgeReyowM9XoQK02k1ECVrGITEAIdr6VoRC6IAsTxAUVlWccn5t4Rrhbq39KAR7nK1r8GVEgBkwItU/tJkCIz0ntTMO2yC0Vku/zazqSCZxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725913571; c=relaxed/simple;
	bh=NTE6HuXS+SdrZwaRnh8UMZMRA2VRf549ypWY64wnbCc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZHcRc7pqMosLGJQx1Myjw0WCV6bnFl8B73Vr4NvkSmqEYIogulOT4dRqp4ZqCiHBI5Ro7IyJtZ2kWwJhlvoMDmP9YjFUiRTr0jRp8IfJoSjS0LqNkpIwe1ssmlgMUaBjWkZxXTQiFFzNzIszusDUGLyjO25qhktYWerU7K8USOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i0NV8Aaa; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725913569; x=1757449569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NTE6HuXS+SdrZwaRnh8UMZMRA2VRf549ypWY64wnbCc=;
  b=i0NV8AaaqDeR4tu5UdsvRt2c3aujQgl2zjf01bo5MScnsAqJsdJV/R+V
   8wIwD8PY7ml0psyGIWy5k/wU1i0o0ajg0ahERjlWXDsto4XUcmiUk8QG4
   N06a8OHEonbvr85ieUVH9gS6xu+ebZTgUnvKCnIsYg1rkYBZBsfh+e9VQ
   EwOM6TNLQWOVSB/CNVbckiL98hbQKyArL9PwpS9rRuAGqk3IaFWiAuxyi
   Hutk74IdaXYSiJGRPbV7Jc1gHMExt/9JXFhVssw/yx+G9RSGqafMEUbJw
   pcYhqkFhdkYkKcd1KDKt2nsqx7Sn1HKcipSIXHliNISXNQ3sl9PYFS6Lz
   Q==;
X-CSE-ConnectionGUID: NWb49lLjQKagrXh6qpSZyg==
X-CSE-MsgGUID: Q8VI/fL6Tky2+cpicMperw==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24131743"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24131743"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 13:26:09 -0700
X-CSE-ConnectionGUID: wDotlYP4StSb7Ej29PMPew==
X-CSE-MsgGUID: WtOwa7kCTgOChIxTFVFvSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="71584161"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 13:26:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 13:26:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 13:26:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 13:26:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mcZqxucS7KfKpzZBr7TuTuv58cJ5HDQbhDhXODyLWY7nQW5V3PivXQZnp84q3HX731XhyhCECTS/dXTd3JgEF0yPXlCdud0eKCd553agWEM95qthUKLY1T+zrx0v3zJ0wi1QjNs3exF4wgYoa9KfMGE60v+gX1UvXSISiYkrG4HvbHx/VRVixTq66+iVZU8dce2x8ujfbURbT/Kj3F8fqaPEZrtJ8C0YTj1b85+7SVPfr5QwU8QjEqC97AzBGGfMTm0s67v8m6Zy+mUAtWvEgg7r0q6m7vLxSe8MyfgHJ4WUn+/23FReg9wLtF3tZR41bOvrnvk2vTkd3HqBmBEC6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTE6HuXS+SdrZwaRnh8UMZMRA2VRf549ypWY64wnbCc=;
 b=dqt3YxYgjP6zfB3KL+xAXceF60Z46YgBkWB8zFNDupph9j44hULJyeEskXx1cPiA25zu/H0Xs0eD1vybJs6e/UwPVEfFNhG8SCG6N29SCRbhLOCf5mjig+owhT1PG0ZXUX2UFpcFFii4cvdm1G+0dS3tZZrTzwHyZNHrM5nkgeDHf2qMm7GvGprkMII4kccF1pzCscpoyHqoOWGJZfzw1XhJnnelcc4LvPavxYZlb5UqgAXjZWHfg6tVYoP7kAzyFzGcXGXJ2IyWTLF2zHSr7xDWZ5fjOtB1elNFe/2qprPCMeCvag/CSFCnN7XEck/sDvQP/GRZPhOaWHZ6cdeVaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4902.namprd11.prod.outlook.com (2603:10b6:510:37::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Mon, 9 Sep
 2024 20:25:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 20:25:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJJ/uOAgAXxIgA=
Date: Mon, 9 Sep 2024 20:25:59 +0000
Message-ID: <79284e4134ff7de08695a3df4dab643ceb3b458a.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <4cd18b6e-5e64-4b7d-9dbc-fd4c293cb4db@intel.com>
In-Reply-To: <4cd18b6e-5e64-4b7d-9dbc-fd4c293cb4db@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4902:EE_
x-ms-office365-filtering-correlation-id: bd4c8ff8-09cd-44b7-63a0-08dcd10d9e1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UElXYTBEcWhKNlgvUGxrcDBpTkdlVUhHdVhIQjdqZW9JZllTT2V0bEpWNlY3?=
 =?utf-8?B?MENFNlZ6SVZMSkw3YkNBR25zRlNlbG00UGJoZXllY0xjL25CQW4wSk56ZVAy?=
 =?utf-8?B?UE5ZS2xBdHdXNkgwZmg4SFJONStwbm5uVG9RSTFIZTBmV29WRGdPSUcxR2Za?=
 =?utf-8?B?MnlMRG5vNitjM1UxaUpZbDArL2tzZHc4RGhUNit3THV2bUFDVUkybHppZXV2?=
 =?utf-8?B?TmowN3N1MzJFNGxGbk0wSkZkZjBQWGM5M0lKbk5vdW5FR0dzSjVIdENqaEhN?=
 =?utf-8?B?bzFqQXdCQUp6V2VqMGRLUXZRUXFPWG1OQ0xDbllXSDZCYUVhM3RjZHlDUWR3?=
 =?utf-8?B?SVlNekJsZHhnQ2I4Y2VPYndNMHhRaVIrMGRQZys5YTgzWEhHemc4WG1qQ1RM?=
 =?utf-8?B?OTV1L3lBY0V0OHFlQ1lZTXJtOTN0aXVWek5NL0kwcE9LNC95Y2FUSFEyc1hN?=
 =?utf-8?B?eldGTDdGR2ZnZmhyWCtHWmRuUnR0L1d6YmpLWDg1RUZuK1NBZkNkdFVKUkxI?=
 =?utf-8?B?V0FOYXJPYURIRnZDOGJYVC9aOUc3ZVlVdTJEeHVrZkQ1SFE1YmxUQmlnaXlQ?=
 =?utf-8?B?T3dDMi9rc3RrRklqY3F1blh3Z0dIc0VYTzFoOEtid3Ezd0VVV0VpNWJaenpC?=
 =?utf-8?B?QmN3YVZkUnY3VklMSTJqaFNHM3E1VUNLVkdvNExqbVMyRDJyWGMwamEzV1VC?=
 =?utf-8?B?NUQxazE1VjZsRXcwYm83cVQ2OUVYYndmSDJJNTRQTE1EMndpall3Tk1DT3dS?=
 =?utf-8?B?MFlaK2tCdm51REJiTmJac2lVOW85UnBJY1NUVTJDb0Ivc1BqZFFYMVpnMVh0?=
 =?utf-8?B?RVEwY2xCUmt3a2xBUGVkV1hHK0hrZVJXcWxHTjM2ZGFhSHpZWWkwMzVBVWo1?=
 =?utf-8?B?VEh4Q01KQ2p4aHQ4dGlrR2NGK0Y1alNQcHJCR21Xd1p1QUZ2UzlodEFYeDNa?=
 =?utf-8?B?T2lOaVp2MlpUQVo5c3J2d3cvVGF4c0lKWlpWc3ZmVzZod0VKMjg4ZzRZQlBI?=
 =?utf-8?B?bXBTQXBDR25hRWdZSHVJSVo5cHRkRmVFNmd1eXlYMEpZVGhxblhPSHo3cS9v?=
 =?utf-8?B?U2JVam5wYzBCL24yanNjelkrVjkzdWVOOTd1Z1U4OXNuWlR2MW5XWG9oMVUy?=
 =?utf-8?B?ZkdIbGZNT1BjLy9wVDRoQ2tHRHN4RllkRTh2QndwY0ZUTUR6b2pwYml6UHBH?=
 =?utf-8?B?a3FpK2NyNUthNVdsNUh4eWFpakJxVm1JdFd3Tndld052emZUVE80NURHTmtm?=
 =?utf-8?B?OThBZzdZY0o3ZHF2QS83TWxVMU1tRzJjMkF4WjZOLzZvUHREZExmRjNzTjNr?=
 =?utf-8?B?OGt1NkVBTHE4TjJON0pCZGhKZmp6U3ZnZnU3dERIaUp6L1hxNGFWTjBMbTJM?=
 =?utf-8?B?bExKK1hxTkU3RWR5bkQ0VndsOEV3ZHNha2YyUHVlZHJyWjNjV2Y4MkZMK2Vx?=
 =?utf-8?B?Z0R3cmlhQlQxQU1EbjJrZVR6TEZWTW16MTFaWnlPbHNwTll0Q1ZTR3RXMDI1?=
 =?utf-8?B?UWxWV3VYVVlPbnFaT3UrWGNEeG5iRE4wRXpFL0xKdzVRNUZZdkRnZzJtaTVF?=
 =?utf-8?B?bCtrYXFTbWNMNTl6R3VKUHV6aWtxWjJ2SDRoRUxTTFJuRjFTNG56bFFZYmxN?=
 =?utf-8?B?c0Q1WmI2ajRnendpeTl3eGtucHNsclVuT1JiMGg0V2xPSlc4U09NWjhWNGdZ?=
 =?utf-8?B?R2ZUM3JMZlV5REhNM1I4MGpFMXJ1QWQxZFdMSXl6a2lqNHB0UCtnMGorTFQ0?=
 =?utf-8?B?SEJ2L1lVTnJIMGFxRDd4ZDVTYUZIRzBISXNZMnBVRFI4aEtZTUdHQmVkQnhG?=
 =?utf-8?B?MFVaM2J2dURINkM1T0FTbEtuUlV1VzBacEl1cHc4OGdqNWRpMzl6QllHSDZ4?=
 =?utf-8?B?YnovRFU1Mm43dzJWS0MzTGlhNVFCM2dOdTBZQ05ad3Q4N1E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXdXS2tQemNHc1dKR3RSQkNNVTl3cFJ6b2hRQTBvQ1czTE1FV0ZFdFFheXJR?=
 =?utf-8?B?L0x6Vzc0QkM4RWg0dU1zbmswQk84aUdIK3pFd3ltWHQwNTB5NS9LUGFvWVdr?=
 =?utf-8?B?aHRZUDgzSzQxa0dSMldTalJra2REODZPSTFtaldlQTVTSWFCdVZyY2tldjNh?=
 =?utf-8?B?N3M0UkRqWCs4cnNsVThUeWhTaUVpbFdIV21CN295c01MOWZZd0tNVDBQY0s2?=
 =?utf-8?B?L3pyZStjV3J0dXF6VmpCVCt2andMR294WjFpRlJQZTdxYS9EbitHN1VqVzE0?=
 =?utf-8?B?Rjd3MnVDZjBSNDNNSUt4YUJ5SmtNUFR4RlhyL2JpOThrQ1NLczZPUGdoaEVM?=
 =?utf-8?B?ejdDUHNRWmlGRzhSOExoV25HWkpHNFlGaVJqdVlrOWkxWHBNVFBaSGJoY1ZH?=
 =?utf-8?B?YU1wSkJVVTd3MGRROVVZRlRSVU4wMjhhRDJwQTFtVzd2YmRMaFRrcjdnV2tW?=
 =?utf-8?B?cER3UDhoMGlqL2ZGV2ZuS2J4OXpjdm1jb2lFenZQWVlNS1ZqQ0tQZXFvYjcv?=
 =?utf-8?B?ZldBZjAvYndOVVhSNkIxYkozOVVaWlArcDU5djN5VEoyUlFBa3grRXNYTVB0?=
 =?utf-8?B?UEZSc3dsMisxTURESHYvQ1ppb0ZISW1IRWI5VzhYaVZ2YURSUG5zeFZSaEJl?=
 =?utf-8?B?YXkvVXoxVWlnaERjREg4SXVIcE05UmdtUWk3bXBxWkdndVIvR0M5dWp6SE9O?=
 =?utf-8?B?bVJRcnFUMzByelJJcXdlK0oxWkQrWTNzWTlkbXRISktkUXV6aW5ETVpUemJl?=
 =?utf-8?B?TzZZZzZYNUJSK1Y5OU90eE1mVUJFUjY0cEtBKy9WdTB1anZpenVROUFuVUdh?=
 =?utf-8?B?VkFpY1dIRFphc2xJb0JEd1RrZ0Q4SXhwMERBaTY3aHJZMC9xeVZTb2lBTklL?=
 =?utf-8?B?bnJubnZaWVBvRURhb0lpbm9LU0dsL09kU1dMalEzSmVhT25OMlNPTkRNZU1O?=
 =?utf-8?B?cFVzWGUzRldENW1kUzRqMmFkNHRkVDJCUTlTcGR2SUFnQVordVY5Y1pBajRG?=
 =?utf-8?B?WVkvT2RvSEVLRFJhUGQrcDUwa3pRQTVQUWdEUXFIRTBoS05iVCtVNjAzdTUy?=
 =?utf-8?B?YzBYcWJVck1XcGFZWWExT1ZjbERHOWdGREpyTDBScm41UlQ3ejdDNUhDcDY2?=
 =?utf-8?B?Z2RTQjJ3UjdnVklVd1FMalpjMEhlWDBzSTd2SWlwYzBTTFJhdU52Mm53OW9B?=
 =?utf-8?B?YjV0d3hIWUoxTGVaOUtvSlZ1bS9nVmMrT1JYbWxLQVNBR1g2bnN6L0s3OXNo?=
 =?utf-8?B?VEEwdlROcjg2N1lPbmw0M1dEOVplKy9EakFrQ3JBelJrejZrKzgva3Q2bGEv?=
 =?utf-8?B?Ujc2dEp5S0o1ZWtjMFZ6OXFrY3BudCttbkU0VVVaUVdBei81MUhnMWNxdnow?=
 =?utf-8?B?TGVBY2JPNDRKZ1hQR1dNbW1qTUVqelA2a3dhMldCVDFzakRWWG9Jd2J3MUx2?=
 =?utf-8?B?ZHB0NTVjTG9uRW5VR1J1Z1VyRXo1RXRLNGhpVzFXQzBIVzhQeFMxNHBOZ08y?=
 =?utf-8?B?RnZKNzVMcU1UWE8rN0ptNFc4VFRxdlBTQlAvU3o3d0RINW1TQlRLL3VpRVVH?=
 =?utf-8?B?eVNWSjNJeGk3TnZ0TitHT1JHVUU0bCtHNkIvMnJzRmxIa0srdlFwOTcxV2ZC?=
 =?utf-8?B?U09LTml6UTdPbjVkcDNVK2w3YVE2SkRLVXJobjRwQnN2L0U3cUpaZDhseHND?=
 =?utf-8?B?d3U3R2Y4M2MyTmY0UWJqN0R2ZGY5ajFWUDFJNDlCZXpSSkFQd0ZyaGFBenVu?=
 =?utf-8?B?b1BGQnhGZGFqRDJjZWRlbzk2VThIaTd5VHBPV2x3aytyRnJWRU8rVndBSjlu?=
 =?utf-8?B?OGUxVlhndEpSVTlLMFB4Y29qbDJobERFN2NZdm1tYjZRemQvVDB1L2lGVUM3?=
 =?utf-8?B?WTVLSmdRQ2NIb3NSSFpBOWl6K0pMYVFHOGkzU1FsbEw3MXFoYzVpT0t2ODVT?=
 =?utf-8?B?aHJGL0YyOW5GMFBWbzh0LzV6bVY2QUJIN1NDK0QvTENxUWJZbVVicjNCQlFI?=
 =?utf-8?B?UHhDbFBXaDBhQ2Nwc3hDemk5TGQrajEramlKckx3V3ZHYlRoZVMzcEt3M1hn?=
 =?utf-8?B?WWFwWjhBSVpnREowc3ZzNEJqRytCcXg3aEZpTVNyTmx2R1Y3WkhSWHJOeG8v?=
 =?utf-8?B?dmVERExlQ2FpZDMzdEJGNWgwSlJkVk9lYmhEVHpsaVdDWmVzK0ozb1prS3Zm?=
 =?utf-8?B?WXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6647AD426DDFAA40A12DD6522AE15B82@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd4c8ff8-09cd-44b7-63a0-08dcd10d9e1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 20:25:59.7047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9ui/EfVTDfDo/lrkdI6mgYF1xd1iuKBjreFjnnIPAbQWr4J1zy+6tNy3sosnLFIx/7RbX1SRJ1lg21hZtDzcgu7/OMBYgQx2s6A+FCSpD+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4902
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDEzOjQxICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAz
KSBUaGF0IG1lYW5zIHRoZSBfT05MWV8gcmVhc29uIHRvIHJldHJ5IGluIHRoZSBjb21tb24gY29k
ZSBmb3IgDQo+IFRESF9NRU1feHgoKXMgaXMgdG8gbWl0aWdhdGUgemVyby1zdGVwIGF0dGFjayBi
eSByZWR1Y2luZyB0aGUgdGltZXMgb2YgDQo+IGxldHRpbmcgZ3Vlc3QgdG8gZmF1bHQgb24gdGhl
IHNhbWUgaW5zdHJ1Y3Rpb24uDQoNCk15IHJlYWQgb2YgdGhlIHplcm8tc3RlcCBtaXRpZ2F0aW9u
IGlzIHRoYXQgaXQgaXMgaW1wbGVtZW50ZWQgaW4gdGhlIFREWCBtb2R1bGUuDQood2hpY2ggbWFr
ZXMgc2Vuc2Ugc2luY2UgaXQgaXMgZGVmZW5kaW5nIGFnYWluc3QgVk1NcykuIFRoZXJlIGlzIHNv
bWUgb3B0aW9uYWwNCmFiaWxpdHkgZm9yIHRoZSBndWVzdCB0byByZXF1ZXN0IG5vdGlmaWNhdGlv
biwgYnV0IHRoZSBob3N0IGRlZmVuc2UgaXMgYWx3YXlzIGluDQpwbGFjZS4gSXMgdGhhdCB5b3Vy
IHVuZGVyc3RhbmRpbmc/DQoNCj4gDQo+IEkgZG9uJ3QgdGhpbmsgd2UgbmVlZCB0byBoYW5kbGUg
emVyby1zdGVwIGF0dGFjayBtaXRpZ2F0aW9uIGluIHRoZSBmaXJzdCANCj4gVERYIHN1cHBvcnQg
c3VibWlzc2lvbi7CoCBTbyBJIHRoaW5rIHdlIGNhbiBqdXN0IHJlbW92ZSB0aGlzIHBhdGNoLg0K
DQpUaGFua3MgZm9yIGhpZ2hsaWdodGluZyB0aGUgd2VpcmRuZXNzIGhlcmUuIEkgdGhpbmsgaXQg
bmVlZHMgbW9yZSBpbnZlc3RpZ2F0aW9uLg0K

