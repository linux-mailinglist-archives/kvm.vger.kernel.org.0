Return-Path: <kvm+bounces-62947-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 71D92C545A7
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 21:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 237E74EB67C
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 19:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D52F2BE653;
	Wed, 12 Nov 2025 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j8mSjDfP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0019627A904;
	Wed, 12 Nov 2025 19:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762977559; cv=fail; b=S0Jl0HhbCbzwAgwevdtAW59teiEDdOiQOssefc0lFOvC4qQWjHRzXCEa+zdIYniw/5EQrNxTT7gdQhASEgz+U0ODryJw5gi5WEiSbAK7mnTbc9pe4rvxlODyv+1Cx2dNZlLt3wqGUQcmEyQKgBVkZTXSJcd9one//CltzHKrUwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762977559; c=relaxed/simple;
	bh=Gi1hVR7Q5f/lzaITJde+pXO++HTSFfAyGvo+0PcX9a8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gAYNEkW5Y419FBxP+tBiAcl73NdBUo4QriCbtl9igeB9LdZ2U1R5QFRNnsxQd4ODYK2oSm2jZp63u1Qr7yz8aGfCZvy0mmI14jzhKaDXxKdAUVIV1lCJAr3BBb+c79oobTg9quaI46qDdFOGcow9s4v1E1b5YK7ats2oDRmuBpU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j8mSjDfP; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762977557; x=1794513557;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Gi1hVR7Q5f/lzaITJde+pXO++HTSFfAyGvo+0PcX9a8=;
  b=j8mSjDfP2idnEuaU6UudyiJeZ9AzqGQk2N94zjamVUyybOu66fYySq2f
   3bb9kYoeKQkc07fPK4hW8vkm3Upwc97QI1Hw4ORjNt6H1ePadZ0zEW1bm
   OjWADJVDoSqGj5J20FKMP8H/ANDlj+Vjy557Vr0wnDw6eFSpsbsH6xrUx
   QBjVr3pMJ4vf31kv89Ni+wIX7Vra5QwMX1LIIVXWL/XN41vcdxqnjqSFL
   dsGyanAg2+ZXUAsVbzOsgTzhVGoRBehqkitcQp8quHb8JspGraGSb1rEr
   h1usaOUpNiE9VGV9z0sZxpPlQpqnD5HLaTMOAoF/5veIwHMfiAnKD4vLb
   w==;
X-CSE-ConnectionGUID: X4mjcR2uQHWqHf4t1gAvTw==
X-CSE-MsgGUID: nZ0BtPwkQqSR7WSL8OjGZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="68915404"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="68915404"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:59:16 -0800
X-CSE-ConnectionGUID: znD2juYJTnaNqzhF2z3Khw==
X-CSE-MsgGUID: BD0Ft4nxSzmGvRI6PWLv8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="190047626"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 11:59:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 11:59:15 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 11:59:15 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 11:59:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hCaRsg0UtqSd8yLebnQWiRDC3fqzuEYx2U0h/lRmu/7VHmQc6Fj3GIgQ7/1HJQhwWqZbDp9FHKbJFAfsxG9Tu1+5Kw+vwtoxxTI0EzhGhVzNHukfP1jalRqgspOrd9AWCLzh4Eq0lfivyejXNc643Ig5nhF6C3NQFfs2z/DEgQ8+4rXeSjYeLW564ao4fgWBJxErXsxJf5iIYoL6Ru5VmLjJRwP7oWEjc4ScWUBSyqfeYWOoJ7vINUlaEBnWCx0DQEhlRopPWoZ3c8yxl0phupxwBJ9hWGpxLG71acvEtXxGcvCLFjOTj2yiREXmyZLH/gJkQG1Np6CEWQxmjrSzqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gi1hVR7Q5f/lzaITJde+pXO++HTSFfAyGvo+0PcX9a8=;
 b=Nkui93+PnQYmcURhyvbaEIkf5tPUSmTHxkL4qmj2klqvpamH5fWELv1sShfhIBVDi+EfzBDlldvyAbVwzUuKtTLKu++feMD1z8LEM5GxSiSG4ANftagRm+IEModWsVPemd/DMrRe4zmNjtcS27hUzgwCkh0rYoFTs9XT4oRH0oAnz1LYMI30AxpcAwiuiAzuB9FN0WTYLo1r2/AqHCTP+YZH8hlLkCiiHTk4SOSOT7/5MXAT4d5pDqRn3obYdQk5lJWDVB0Z/0FZhr0C9vtfemgSK4f+9oABG8w3P00Z8AZdkmDYTVxyU/6YKnJ7EihGiimMwfLip7uRRf3ast8IRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7759.namprd11.prod.outlook.com (2603:10b6:8:10e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Wed, 12 Nov
 2025 19:59:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 19:59:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "thorsten.blum@linux.dev"
	<thorsten.blum@linux.dev>, "bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"kas@kernel.org" <kas@kernel.org>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
Thread-Topic: [PATCH RESEND] KVM: TDX: Use struct_size and simplify
 tdx_get_capabilities
Thread-Index: AQHcU/gkAfgZ+wGWiES13FGnHy0VB7TvdbAA
Date: Wed, 12 Nov 2025 19:59:13 +0000
Message-ID: <4a2a74e01bfd31bc4bd7a672452c2d3d513c33db.camel@intel.com>
References: <20251112171630.3375-1-thorsten.blum@linux.dev>
In-Reply-To: <20251112171630.3375-1-thorsten.blum@linux.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7759:EE_
x-ms-office365-filtering-correlation-id: 06b4e1e5-58a7-4502-4696-08de2225f3c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?c0NmeTU4NjBVU24wQjhicGFkYWdGNmNyRlNjKzFYcEFBdk9OOHJzYys5eFFH?=
 =?utf-8?B?TWdJRnFoOWl2S0NvR20reDlIZjZzOHJVS3Bxc05YTEMrQmNoblN4RHlNdUd1?=
 =?utf-8?B?VXVPYnJSWm9vek11L2xoWUFkNVdwUlpHU2pWRFdoN1lFc1NrRy9STlhOUVRm?=
 =?utf-8?B?ZHorYjRrNCs4LzZzVE9xZTFqREhKeCtKcVo1enVwTjFGR21TNGduZkUrQ29Q?=
 =?utf-8?B?MHBxb05iTFBmc3A0c2plWVNTOStwdldVM1hmdG1UWi80KzJFWHBieEVNY2xS?=
 =?utf-8?B?Q1VXTmtxUmJLZEtReXFscWNxY0t0NW9JalFHRk5VSXoydkRqUTF4U3E1Vnpz?=
 =?utf-8?B?eFlzQy80YWFNSWwyU092SWNmMm9ETy9DQktrVUZDZDhGcFRGbDVmM3FXditD?=
 =?utf-8?B?T1RwbDNXcFllL2NSYVlybXhsU1RpSFhxcDY4V21iOFkrVGtuRVVhYWhaU1I0?=
 =?utf-8?B?YmJtUTd6WXlTNW5VelFJQ2pUY2J3cUk1TjlUejJwenp1cFhFVE9TZUxaV3VL?=
 =?utf-8?B?dlRaYzRBejZmTW5rYmw0anVOd29WQ0pnV0hYRC9mSkp5MGk1dFJYd0FMQzdx?=
 =?utf-8?B?c21uZDJFSHdtV3NHMGk1dXkvRk9QQnZ2M2JBRTVSTmNWb0toMWVtSlJPL0Jn?=
 =?utf-8?B?ODVrd3llaTRzd3BzZm5sYnhjcHd2bVM2akVaVDFwd2g1bEVwVk4wdUJHWGIz?=
 =?utf-8?B?N0xPVG5mc1RWNkovOHJJVjMrQ0ErK0JHdmpoTmRKRDZOdkFLNzZpTXUwbFg5?=
 =?utf-8?B?N0U5VjJBMVU5VS9zak93cFd3ZXJZazB4NGRmRTVOUzQyY29kVVJsZmhiSStV?=
 =?utf-8?B?TFM2YjFqenNGYk45bWJEejB5M1BkU09IeGdnMDlZWTN1bHZQNmwwbkZEZUhl?=
 =?utf-8?B?ZDRyZURiU1ZNMnFtYWVZbFdKYVNXOGpOLzJCL0hvYlhQcHhXSVRPU3orMUF0?=
 =?utf-8?B?MEZkd3hobEJJSVdTNHRpWDYxb3J0V28xN3FDQk4wdVZRdDhKRU9oTDVld21q?=
 =?utf-8?B?M0ZpUllJRWFDRUZiRzFGOXFsVDRLNldRL0FiRE54MS90SThxQmtsa2tKeHhE?=
 =?utf-8?B?c3ZDVWZsRERWcUhKcXJkNEdGWE5kckJ4UUM5SklxVitKazcxMEZ2ZXFYMUpI?=
 =?utf-8?B?ZU1Jdnh4VGFlUkJvOUlrbEp5clNtQlpTdmhtMHJvakViN2VKQzlweEVacG1E?=
 =?utf-8?B?RmFqblJYclJIVUNpY2F4dXJLSmdSZW5OTFJqMjFHS1RsaHNxWUZ5a2k3TVVt?=
 =?utf-8?B?RUZ2Q2J3MkhYV0dHNWpBZFhrNmNyZ096V2tSSWRYY0tkaHJaazhoOGYxODhn?=
 =?utf-8?B?cmx3TG80WEpPS3lzeTYzdE5CMlZ3QWRveVNjSHd6a0E1N0N5YWJwaERqc3VL?=
 =?utf-8?B?cTdJNnZnL1Y4cGJFMUU2NzN3d0RHdFhFYUZYWW80OU1vUkFkcTdHdzRaL3pJ?=
 =?utf-8?B?LzhGbnJoVjVSYXQxNFB0d2s5YngyQ2FQbFQzNDQyZXVudjJIQXBvbUtOWWhp?=
 =?utf-8?B?V2VkeVZrbGp3WHJnN0FnbzJLMFlXR2d0b01JYXBMZmNzMHBaMzhpdFhjYUQv?=
 =?utf-8?B?V1dwR1NDTlh1VG1aTzRFSG5Panp5YlowcU1ZZnZKZjFHL3hEM0xxVkZ3SFAx?=
 =?utf-8?B?Z0J2d1NJbStUa3ZRbExrRHVRMWZpVE9kMXl4SXRPZUNCc1psOXRDSUoxYVk0?=
 =?utf-8?B?bnBhYnJsSHBrcHBVR1hCOXdidTJ4MUo3d2RlWGlwZnNDZDRXcEtrd05EOGVH?=
 =?utf-8?B?QmhBQU1rRmMzcTBiblR1R0lQZFZtcEdSZjFITXVYQlh3TnNXMHY3OGt5a3gv?=
 =?utf-8?B?cW9lK1RlbTdqMFRoTUF3VXFnOHVwdDBTV1g4cHpZdDJiSlJWYi9YN050UkJO?=
 =?utf-8?B?Q0EwcitNUi9ieTg0SGRCMHRtb3JrcWNzNktrNHduMmNCOG45aFB5aVQvbmJR?=
 =?utf-8?B?VXFDaE1MWkp2RVk1Ui9paWt6UjhZV3lzRUdHY1Jrb2MyWjZkWVAyMjRTSFpl?=
 =?utf-8?B?UWgwQTQxNnFseUtKWUFnMWVIbjYrdG5Oazd0RTlFSlFHMktjQW5LM3RqSnBX?=
 =?utf-8?B?M040aHozZndkb1ZUQ25zMEp1clhJQ3J3ZEQ1QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0JaNGtnSGY3dTFCM3JjN2g4VUxVQ0xUSE8ySEtzSWRjZnB5NlZaa3J1cS9S?=
 =?utf-8?B?NUdEYTJqREU3SG4xTGlZTHRYdlR4Y1pvaGxESmptY1FTOWZNMjMzSGZ1SkxI?=
 =?utf-8?B?VThFQzQ2azRpQ01QeENHUDRGWXRwenlyMG1kRy9saHJaOENBLzZCQlFZUUNG?=
 =?utf-8?B?Y2pFcHkyNUZ0RVBwSzNMMnhLelBFT2w4YndOaVErTkVxZkJSSWE2TTdtZGNq?=
 =?utf-8?B?M2xJLzBPOThVS2FBUXArQmFKazM5ZFJDSGp0WXNFK1NoSFMxTnVtYzd6WFcz?=
 =?utf-8?B?aFdOZ2ZaVkN5N3p0NkxaU1MyczdqbW1qaGRpV2RhQ1cxY0lZVnIvOUExVGtm?=
 =?utf-8?B?L1E4U3lSbTJRcUYwVE1JeGkydGdqRXFzdWgvNkRZck4xMGl0eHEydUVTbzJW?=
 =?utf-8?B?THdJV1FyMTk0OXM1cTZqYm9BWWRYMHlZeEdtZDNZUXZJUmdpRmRYbmlnYXJW?=
 =?utf-8?B?M1VYc1dMSXVoTDBqaTlrTFVBZnBUWGhkYlZya2xZSjdxOU9CdUJqU25vS0Nk?=
 =?utf-8?B?VFNrNlJnd2xjWDVtd0Z6M0EwKy8zSWE4L2swcElyM1NNdU1GamI0OWR2dnJl?=
 =?utf-8?B?THkxTnBFWmFhNDAyV3ZndXJsZjNTMVZSa3krVk1ld0F2NWxKODc2UWdJMVps?=
 =?utf-8?B?T2RWeDMxbmhvaHQxVU03dWU4RnVTVUcvNmFXUXlVSy8xUG92WVVlejlvUXdB?=
 =?utf-8?B?Q0Jtc0U2eDcveVFYTjdlVWtQakIrZ1RlR2xvbzdtNXpxUzFJQVpXY3AxRGMz?=
 =?utf-8?B?OE9OaFdwcnQyNHZCaFFwU1kvUGxRYTFYSkNkZ1M0NTdHQVB1Vlg1SXVSTnNy?=
 =?utf-8?B?Vmx2cmkrUlBvdytGK0dKQkFTOGNTeUFYL0tyUGVQMUhYSXpTV3RXN0pmUjdo?=
 =?utf-8?B?MFVpYlFINUxacGZBM2xSNHpZNDA4T3NjNE5pQ012UWF3MXpZY24yZU1xd3hM?=
 =?utf-8?B?TE9qVWdoekxuM0RWaWpGZWhaUmRGVXpGbTRTVkI0ZkxiTDRSdytTNXVueHkx?=
 =?utf-8?B?Q3Nxc3BMOWozMVRsb25LS2x6TGs2RDNyNE5LUkV4TFJ3elkyd3U2MDZhWE9n?=
 =?utf-8?B?ZFRDcVd2R21IbWhsQzNwMElSd3VxS0MwSmRTMDQyNURsZGUrRkdlNlgybk41?=
 =?utf-8?B?WTJNdGFYdlRDTDgrVytRdVJaUDhkZlhIRnVDQm1PSUFkUDBtU05DT3NlRUVT?=
 =?utf-8?B?bjVEdnROVHVSQWhyWHpTOVpoSlR2bnd2ZW9YU21qeE1rTEthRkpZcVVXaHFX?=
 =?utf-8?B?MlFEQ25qaDd4a3ZtWmtRWi82Nkw1UTBOckVTaFlQbnRPNHkzZHE4MVlmcSsx?=
 =?utf-8?B?NVB3Qjg5NmRtWTd2TWpxSzJObVZLY2tzTncvUHBhYmNGaERQV0x6cnZ4Wi9F?=
 =?utf-8?B?ZERaUlJLZzVRQ3k3R09PU3dZd3B5d2g3Nm5GaG51Z290MmJsaGFKSnFSaTlt?=
 =?utf-8?B?dURwVlluOWhoT3dvY0JaMEFIUzFvdHhiRVJYSUtFSmFEaWh6SFVyMFJKWm45?=
 =?utf-8?B?a2xaY3RscmZjVVFCZks2OTJsMkhZOVNObjcwK1IyeWxoMCtNZ3hrRENITVNu?=
 =?utf-8?B?TGRzUC9LaWQ4S3c5aTRuNGtkZ2QrSXp6c29oZHhURzhSVmJSdW9aVkR5TkVy?=
 =?utf-8?B?clFDaTRELys1ZXJnMXdpNlhzVzExbEZFekRtNWlKYnNDcUFyeHYwWWh4ZmRY?=
 =?utf-8?B?ajQwTXJINGtwMmZvUVByb2prVGJ2NDBrK09WOWVqWVVZUTA1OTUrd1FuemRx?=
 =?utf-8?B?RDdOclRiTldMd3J5REk2MHQwcVFBajlLdUErMi8wOFNJbDJlTmhSZlJCdnVl?=
 =?utf-8?B?L1QrNCtuN0FLcW5XWDRZemhFNkh2L21ZdzFVa3Q3bDltaExoSDN3VVcvOVRk?=
 =?utf-8?B?VDFtUXNiczVUcVlwOUhtZjVndHYzeUZSSFBMdnRzK3NvWEVFUnArbTNUZXZ0?=
 =?utf-8?B?NGxMZ00wNW5ML0djazU4NjdSL1JjY1dsbk9WZDFWOTJwaHphVG5mRlRZV25v?=
 =?utf-8?B?aTROakZlWmRWV3FCMWRCMTNJZk5pS3h5N0RnaW4yQ3dUejdPWk9WSmlTUHZM?=
 =?utf-8?B?YzhzbmRqaEMwRTlZS2lLZnZVbXJHdGNUWnpCMXVvR3RGZDJ2SEJmVm1OUE51?=
 =?utf-8?B?U2dvelI1SGI4bmt0QzFFK0tQL2M4MS83azRKdVZ3dTBjZk55eE1zWGJFSGJW?=
 =?utf-8?B?VGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D310C94073A6564CB6C7F3D38A631236@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06b4e1e5-58a7-4502-4696-08de2225f3c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2025 19:59:13.1750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UkRcga6Hu6U+FzRFGRhdPl1epXXjktRbDOsbOx8RsRtvgm6/DzRKffnlN6KeXSIuKXSVhISV6rqCz7R9nyNYrcJnJGweVyC20xLERIo5F2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7759
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTEyIGF0IDE4OjE2ICswMTAwLCBUaG9yc3RlbiBCbHVtIHdyb3RlOg0K
DQprdm0geDg2IGxvZ3MgYXJlIHN1Z2dlc3RlZCB0byBzdGFydCB3aXRoIGEgc2hvcnQgc3VtbWFy
eSBvZiB0aGUgcGF0Y2guIE1heWJlOg0KDQpTaW1wbGlmeSB0aGUgbG9naWMgZm9yIGNvcHlpbmcg
dGhlIEtWTV9URFhfQ0FQQUJJTElUSUVTIHN0cnVjdCB0byB1c2Vyc3BhY2UuDQoNCg0KSXQgbG9v
a3MgbGlrZSB5b3UgYXJlIGNvbmR1Y3RpbmcgYSB0cmVld2lkZSBwYXR0ZXJuIG1hdGNoaW5nIGNs
ZWFudXA/DQoNCj4gPiBSZXRyaWV2ZSB0aGUgbnVtYmVyIG9mIHVzZXIgZW50cmllcyB3aXRoIGdl
dF91c2VyKCkgZmlyc3QgYW5kIHJldHVybg0KPiA+IC1FMkJJRyBlYXJseSBpZiAndXNlcl9jYXBz
JyBpcyB0b28gc21hbGwgdG8gZml0ICdjYXBzJy4NCj4gPiANCj4gPiBBbGxvY2F0ZSBtZW1vcnkg
Zm9yICdjYXBzJyBvbmx5IGFmdGVyIGNoZWNraW5nIHRoZSB1c2VyIGJ1ZmZlcidzIG51bWJlcg0K
PiA+IG9mIGVudHJpZXMsIHRodXMgcmVtb3ZpbmcgdHdvIGdvdG9zIGFuZCB0aGUgbmVlZCBmb3Ig
cHJlbWF0dXJlIGZyZWVpbmcuDQo+ID4gDQo+ID4gVXNlIHN0cnVjdF9zaXplKCkgaW5zdGVhZCBv
ZiBtYW51YWxseSBjYWxjdWxhdGluZyB0aGUgbnVtYmVyIG9mIGJ5dGVzIHRvDQo+ID4gYWxsb2Nh
dGUgZm9yICdjYXBzJywgaW5jbHVkaW5nIHRoZSBuZXN0ZWQgZmxleGlibGUgYXJyYXkuDQo+ID4g
DQo+ID4gRmluYWxseSwgY29weSAnY2FwcycgdG8gdXNlciBzcGFjZSB3aXRoIGEgc2luZ2xlIGNv
cHlfdG9fdXNlcigpIGNhbGwuDQoNCkluIHRoZSBoYW5kbGluZyBvZiBnZXRfdXNlcihucl91c2Vy
X2VudHJpZXMsICZ1c2VyX2NhcHMtPmNwdWlkLm5lbnQpLCB0aGUgb2xkDQpjb2RlIGZvcmNlZCAt
RUZBVUxULCB0aGlzIHBhdGNoIGRvZXNuJ3QuIEJ1dCBpdCBsZWF2ZXMgdGhlIGNvcHlfdG9fdXNl
cigpJ3MgdG8NCnN0aWxsIGZvcmNlIEVGQVVMVC4gV2h5Pw0KDQoNClRlc3RlZC1ieTogUmljayBF
ZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiAocmVhbGx5IHRoZSBURFggQ0kp
DQoNCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaG9yc3RlbiBCbHVtIDx0aG9yc3Rlbi5ibHVt
QGxpbnV4LmRldj4NCj4gPiAtLS0NCj4gPiAgYXJjaC94ODYva3ZtL3ZteC90ZHguYyB8IDMyICsr
KysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMiBp
bnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiBpbmRleCAw
YTQ5Yzg2M2M4MTEuLjIzZDYzOGI0YTAwMyAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4Ni9rdm0v
dm14L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+IEBAIC0yMjgy
LDM3ICsyMjgyLDI5IEBAIHN0YXRpYyBpbnQgdGR4X2dldF9jYXBhYmlsaXRpZXMoc3RydWN0IGt2
bV90ZHhfY21kICpjbWQpDQo+ID4gIAlpZiAoY21kLT5mbGFncykNCj4gPiAgCQlyZXR1cm4gLUVJ
TlZBTDsNCj4gPiAgDQo+ID4gLQljYXBzID0ga3phbGxvYyhzaXplb2YoKmNhcHMpICsNCj4gPiAt
CQkgICAgICAgc2l6ZW9mKHN0cnVjdCBrdm1fY3B1aWRfZW50cnkyKSAqIHRkX2NvbmYtPm51bV9j
cHVpZF9jb25maWcsDQo+ID4gLQkJICAgICAgIEdGUF9LRVJORUwpOw0KPiA+IC0JaWYgKCFjYXBz
KQ0KPiA+IC0JCXJldHVybiAtRU5PTUVNOw0KPiA+IC0NCj4gPiAgCXVzZXJfY2FwcyA9IHU2NF90
b191c2VyX3B0cihjbWQtPmRhdGEpOw0KPiA+IC0JaWYgKGdldF91c2VyKG5yX3VzZXJfZW50cmll
cywgJnVzZXJfY2Fwcy0+Y3B1aWQubmVudCkpIHsNCj4gPiAtCQlyZXQgPSAtRUZBVUxUOw0KPiA+
IC0JCWdvdG8gb3V0Ow0KPiA+IC0JfQ0KPiA+ICsJcmV0ID0gZ2V0X3VzZXIobnJfdXNlcl9lbnRy
aWVzLCAmdXNlcl9jYXBzLT5jcHVpZC5uZW50KTsNCj4gPiArCWlmIChyZXQpDQo+ID4gKwkJcmV0
dXJuIHJldDsNCj4gPiAgDQo+ID4gLQlpZiAobnJfdXNlcl9lbnRyaWVzIDwgdGRfY29uZi0+bnVt
X2NwdWlkX2NvbmZpZykgew0KPiA+IC0JCXJldCA9IC1FMkJJRzsNCj4gPiAtCQlnb3RvIG91dDsN
Cj4gPiAtCX0NCj4gPiArCWlmIChucl91c2VyX2VudHJpZXMgPCB0ZF9jb25mLT5udW1fY3B1aWRf
Y29uZmlnKQ0KPiA+ICsJCXJldHVybiAtRTJCSUc7DQo+ID4gKw0KPiA+ICsJY2FwcyA9IGt6YWxs
b2Moc3RydWN0X3NpemUoY2FwcywgY3B1aWQuZW50cmllcywNCj4gPiArCQkJCSAgIHRkX2NvbmYt
Pm51bV9jcHVpZF9jb25maWcpLCBHRlBfS0VSTkVMKTsNCj4gPiArCWlmICghY2FwcykNCj4gPiAr
CQlyZXR1cm4gLUVOT01FTTsNCj4gPiAgDQo+ID4gIAlyZXQgPSBpbml0X2t2bV90ZHhfY2Fwcyh0
ZF9jb25mLCBjYXBzKTsNCj4gPiAgCWlmIChyZXQpDQo+ID4gIAkJZ290byBvdXQ7DQo+ID4gIA0K
PiA+IC0JaWYgKGNvcHlfdG9fdXNlcih1c2VyX2NhcHMsIGNhcHMsIHNpemVvZigqY2FwcykpKSB7
DQo+ID4gKwlpZiAoY29weV90b191c2VyKHVzZXJfY2FwcywgY2Fwcywgc3RydWN0X3NpemUoY2Fw
cywgY3B1aWQuZW50cmllcywNCj4gPiArCQkJCQkJICAgICAgY2Fwcy0+Y3B1aWQubmVudCkpKSB7
DQo+ID4gIAkJcmV0ID0gLUVGQVVMVDsNCj4gPiAgCQlnb3RvIG91dDsNCj4gPiAgCX0NCj4gPiAg
DQo+ID4gLQlpZiAoY29weV90b191c2VyKHVzZXJfY2Fwcy0+Y3B1aWQuZW50cmllcywgY2Fwcy0+
Y3B1aWQuZW50cmllcywNCj4gPiAtCQkJIGNhcHMtPmNwdWlkLm5lbnQgKg0KPiA+IC0JCQkgc2l6
ZW9mKGNhcHMtPmNwdWlkLmVudHJpZXNbMF0pKSkNCj4gPiAtCQlyZXQgPSAtRUZBVUxUOw0KPiA+
IC0NCj4gPiAgb3V0Og0KPiA+ICAJLyoga2ZyZWUoKSBhY2NlcHRzIE5VTEwuICovDQo+ID4gIAlr
ZnJlZShjYXBzKTsNCg0K

