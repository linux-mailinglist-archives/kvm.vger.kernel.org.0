Return-Path: <kvm+bounces-31670-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D1C79C6478
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 23:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ACE57B62115
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 21:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47C8321A4C6;
	Tue, 12 Nov 2024 21:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OSGf4qzP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10802170DF;
	Tue, 12 Nov 2024 21:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446523; cv=fail; b=LDbLU3eQMt8nt/hsYtvhUrT+Tgydn2Ik06GDgqkFFxvrQCKAtyDrYZ4DkQCk8doUZQvi+SXc1aOZld8q1vlySAc8rZBPBpGIUC1TUBX8aQvCyTTWNfb0Rl+EqedNSHjPFSbrW9mNYQER50VALYGDvkE9P3U1+jJipUkH5ZCLj+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446523; c=relaxed/simple;
	bh=hsrOuSH3Vkudn9z6VRy/j0JA5o6cA30bpEAw0Qcw6Zw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DQwPC0Q60/2Oi4QYAlX+pHgNFOVKe6PAlgCWxXC6xOJlfFmWXdbTq4yvSx4100U1VCCEFBLMq2if8Acf/f5XYeFlPEIS2vK9hUp63mrSm4VbjxAHHU9goWwZolSng4Fmxzxum4PTiZeMqyUtIm4gwWJKMsqjczNjFhGYRdACjIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OSGf4qzP; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731446521; x=1762982521;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=hsrOuSH3Vkudn9z6VRy/j0JA5o6cA30bpEAw0Qcw6Zw=;
  b=OSGf4qzPU6S5funPTgH5mRVS5cIBjYiG1HyC9y3+RnsASuAfQ48krZzJ
   AeE33nXF5L8Lnyh4KjeNIQuPo5AHvNpEM9ZpwFn1jhwvhRB44pLDxNo6Z
   1w5LQgfZ8Owmug7w19oqPKmgvk+iLCdBYx2LBLo17SOr2ZPNXGfTKCTG+
   Pl7SKG4QH7uJuBq4maYurqMRuKwwiDbTr5oHuJAXdvvgY1z9sajx3pyBV
   oNGMz3GIJ4w9x1WDeSfSzu03wJcvY1O3lpDvvFNCTXNi5urJO+JqnCra7
   t+A2dErweKtT4ECoB2kEpLKyt/TjRoJoO08vDvtnj2hTsdGCwRvy2rKE+
   Q==;
X-CSE-ConnectionGUID: MxeKx1f4Rb6N2EyOLXjfew==
X-CSE-MsgGUID: 6GcgzJzmQ0Wa5iSmRRZWFA==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31407873"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="31407873"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 13:22:01 -0800
X-CSE-ConnectionGUID: R3uwPP8hTbOxTNN3djdd5Q==
X-CSE-MsgGUID: xGFF2Cu6Q1aCxszmF4cG/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88465029"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 13:22:01 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 13:22:00 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 13:22:00 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 13:22:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbakrcHo5AhvQI820sxyPuc9x8VPtwPAdegi0judNw8WiD01cD+0gbr9FGmvy0o2dC0p/Lkz6QQ/QdH0VcbBp+paElEhHLxs41US0E2qJ1CoovAln0aF7LT3rMBmXcgj/IfLUNX+Sm3Mq9Fk+MoGKWmRXSMVv1ImgEjHaPXxZpcBU5MXmGgIu3H/ByUAXUaG6HRTJgUGO714GD9MIjLv68hH6r4L+WesnohyajftNO36CrcjJG8/elctFQSyOxyM2fvje9Vcd8cggpMMQDetYUnUS4mkziJO2FdQ19b6yyNt81A/knaLEsWoyqIFTfzd3CC9ZkdqiiJhDLl2p1l7xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsrOuSH3Vkudn9z6VRy/j0JA5o6cA30bpEAw0Qcw6Zw=;
 b=gdP6yzL0FoVjeUzl4RtCnpbpom1iEebzpvTBB30ONn7m1g0gZYEU+8zkDU/L2R70X+h6lDLzlz8PccGlrAv30kM11uDBpptJJjRfW3wEuiS0R+r1dO/NwkQFb126yihVLz0nssKnTy7cuVb2RTvBpHpDVmyVK4ERzofuKZogyHQhTYN/uHbqTomm49KXfuGPSTL4qmnIVZhJ+LcFdUQI5TniPdHroUv/XjgRUA3+EQcKH7CuEdCKWEwGOAiGOjmHL1G3qmEZE4FSzMIdchQUUlyELQ5d3ELsE16Yr3JqroyM+QtY8WAxdBrDiIOGOi4CxPqcctKmPeu6zrrZ/qNpmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB6993.namprd11.prod.outlook.com (2603:10b6:806:2ac::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Tue, 12 Nov
 2024 21:21:58 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 21:21:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yao,
 Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 06/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
Thread-Topic: [PATCH v2 06/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
Thread-Index: AQHbKv4/OZy7IxcUCEyDBU35onzMdrK0Kc0AgAASBIA=
Date: Tue, 12 Nov 2024 21:21:57 +0000
Message-ID: <1e1975a134b401c506eb5c4d0f093ce1e286d032.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-7-rick.p.edgecombe@intel.com>
	 <4df744b9-041a-4ed7-aa34-a78923f79cf9@intel.com>
In-Reply-To: <4df744b9-041a-4ed7-aa34-a78923f79cf9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB6993:EE_
x-ms-office365-filtering-correlation-id: c37f1008-7c75-491f-10d0-08dd03600a3c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bjJTbTR2TEFLNVFjM2lVZGlXblpVU1BvN29yZWpPc3BIMTZDcHdsREhua3dU?=
 =?utf-8?B?ZEJhY3ZRMkhKQndUb3V3OVlZbFZwMU41OTVyY1l1K25QdWNVWHZMTHlJQ0Zy?=
 =?utf-8?B?LzNrZk1ZcEkyRVZ2ckoyU2FzMFFDdkZZY1VmNVN5N3gzVk42bGRrMGxCL1pI?=
 =?utf-8?B?UVI5S1dEVHZaTVpQdHFndXFOenNDM2syVHlLNlIxNDRIQTdVenJrcXoxSWw4?=
 =?utf-8?B?Um1IeTEwNUlOOFdrckNUeGowN1FmT1hyZ3BhNzA5YURCSGVSd3ZCaW4wUzV3?=
 =?utf-8?B?a3NNRVNFTkk1ZXVXT1c5L0lJa3lURlhPMSt1dmFqeW4wU0JXNytGQmJ2STF0?=
 =?utf-8?B?VTRpazI2Vlh0TFZ1a3Z1NmZwN3lNY3VFZXp5cHFCNmUrQ3o2Ri80eEc2ZCsy?=
 =?utf-8?B?eGRSV2dmcmVCRHFWODZHOFc2bDBSUlZJaW1yN0ZNYjFwTzZrV0hjVjZtSXFy?=
 =?utf-8?B?QllPK1dRTm84NVFCNkhiWXJ3aGNwSDRnbXdYU1drOUtYR05BUGMrMk02M0Iv?=
 =?utf-8?B?ZGVZUThaQUtOOFByUk15RDJNNWR5VkU5QldiZXRoMTdwSk1QLzNKbi9mUFFV?=
 =?utf-8?B?QURkRUwvM1NvcUYrdCsyaEVpZGhTV1lnRkpEWmpIOUUzbDVmQis4UFVsL05a?=
 =?utf-8?B?R0xjbDM2TjRJT2NKK1NoWjNOKzZmQjlyTDM2TVo3bHhVeENGZ3U2MkdDa2Qr?=
 =?utf-8?B?NS9zYjYzOHBUYSs0QWJKRVRwV005SlNpOFZveVJlN01uU2hCRU1CWGRrMW9P?=
 =?utf-8?B?MlllL285Q241SlVaOVBSbFEwbU9TN1pyc1VlQ0h1WTdLZUZVRlFVNUl5U05M?=
 =?utf-8?B?dWwvSXl5MXJkeU90WU56cUMrZERUSGhVZXhzanZkWEJ5ZmppZlkrbzdFY3F5?=
 =?utf-8?B?UWcyNzB2clFBMFJqUzNxeGw5bHVxdkxRd1p6RURVd3VGME8ycUJtZlRXcUtC?=
 =?utf-8?B?N2Vsby9ZYUsxWWkwSXk5OXhpTGJvcHJuc01QRkFxRmVjSVA4YTVzQmtNSEFG?=
 =?utf-8?B?NWVhMjRKd0dtNTl2VUlJaldtQ1BETW5oOUx2RnFRZHpmZEUrbVU1dzZZRDJQ?=
 =?utf-8?B?MnRITERxL3QyakQ1YVl4aEhpdUZlU1FlZ1VQN0YyVkhTMEtkbDRGaWQ3ZEsr?=
 =?utf-8?B?Y2NhVDUzU25MR2dhbkhxcHZPOUtRYW95NEVQYzFuSWh3UVJwdU1kOGVuTUU5?=
 =?utf-8?B?cTlWY25YV05KY0xUNXJWSFpWWDV2VUFUT2ZuT0EyMjV3MFJUSDMvd3NIcW91?=
 =?utf-8?B?Y0JDZ0ZEbEJ2MUNBbG8zT2c2TVA2N3F5VEtTUEhGTWMvam5NM0ZHSFNZbU1a?=
 =?utf-8?B?WklpVnd2aGdWZmFKMDhyckMvMm10QUEvcDJEMG5DNXhENVRYWTZQK0dEUnc1?=
 =?utf-8?B?Z3NaS3ZVY3V1cFM1UjJ6alY1K1FaMEZHWXFXdkE2enhoaGsxTjJPRGNSTTRH?=
 =?utf-8?B?YlRHQjNxRGQ4NFNnL0JiQ1QraGVleXRZS2RlRnk2cDFkMEd6aUt4eExRUytN?=
 =?utf-8?B?VUVIczJCYTBNNHJUY2FabitZS3gvZS9Fb2g5ME5INnFjRWMwdVBSZGo2U2lZ?=
 =?utf-8?B?aGZCNlRtYTZlQVQwaGlKMTd6WVBOeWQrNDFWR3l0MGkxWHJxR01yb0M0Yytu?=
 =?utf-8?B?RGN1QmRlSVpHL3N2djJwRzNuVGdEcGd5bFdJbkFHL0JkKy9vV0V3SXk2MHlh?=
 =?utf-8?B?ME5qVzQreVE4VnQvTHVuVktXTzlzSUZOZkxkMzdicUZ0RXBFUlUyTXVIaS9a?=
 =?utf-8?B?Vjk3Ykhjc21JNGdTZW5vdTR2dEE0a3d5RmFmeTFLTk5Xd1g1WG1PVHI1bG56?=
 =?utf-8?Q?uA4oqAmomToHC85TsPPfa6GPbPWctxnSF7q7U=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dDFtNGI3ZkdYcFZDUlU0bkVvSjBJZktZeE4rNGNlRzM0WEpOaUFRMDZXTFNa?=
 =?utf-8?B?TzFGZFczVThUTVV6VjlkcXd0d3JrUmNTREtrdnAva0NxaWF0Q1R2ODE5N2M4?=
 =?utf-8?B?QXVYSjB2bFdZRFBkVFRFSjhOaDNZVWJVN1VOYTU5SFMySE13T3lCWlRIMXJF?=
 =?utf-8?B?TnJqT09UV1A1SUpKL3BJTzArMTBPaUlvZ09YTmlBQ21qcGo2ZmpsUlRaR0hT?=
 =?utf-8?B?NzBLUHNhV2VYMlpmcmFZaGZQcFB6Um9jdFlSMDhPTllaK3FZODN3TzJtUGZH?=
 =?utf-8?B?aUMzK1FadVpRZ1pjLyt1TVpVaFIrL0hObHVkUzZjWlFteXpncDVDcjgvYkpJ?=
 =?utf-8?B?UGdGNXR1VlYzdkZRc2g5ZHJEK2JPWDFiKzNSTDBMTWtqRGNQYUVmQllHWXFi?=
 =?utf-8?B?cnlDd3JXejNJWHlMTXZHWDJQQ3ZvbXFZaGlNUGxRM1NsdFFvcTRSQ0luTkJH?=
 =?utf-8?B?VmkwckRQVWNwUUtjcEVzUHRub3FCeE9PYUpGdC9EZUc5MnpZbzNReGd1eFZw?=
 =?utf-8?B?UXRnVnozS0hRZk1JOWNpcGpCVm0vUTkwL2kvK1Iva0tTU0szaCtOMDBDNWQ0?=
 =?utf-8?B?TnJ3OEtVNFZkRGFGbjB6V2NzWklhc3NaTXFXQ0VhTmlWL2s2cUhtUGRhWGQz?=
 =?utf-8?B?MkxTTm56ckdsSS9DUEtaaEpEWTJwaG1FOHBYek9CaE5idzlreFR0WXJqUVV0?=
 =?utf-8?B?RGxBNnRQelVqRWx6UHRtN0RmdkFZMUV0NTh4Qmc1VVEyRHFqdG4zMm85Uyta?=
 =?utf-8?B?SHcxcTI2eVVpdUhyalQ1M08yMVVla3IzcG1VblpiTEVFRE83cnFiMVdNMFFq?=
 =?utf-8?B?Qm9lOTErdE0vNTN6NE1NOVJoRDVxUjh0amFqSkVTeXgrNVk0OU5ST0UyNnpT?=
 =?utf-8?B?NDh1cVRNME1UVVUvRmJRbGVFT3hqOG5QM1RtMCtUTHZPWTFFT2t4alNHb1Ri?=
 =?utf-8?B?UEJuRTlkK3JSOWdrVUFiVnFjWlIwN2pWTDFZbHFUQ3ZrYm5jeHIwVkhIMGZC?=
 =?utf-8?B?Q2VIMDFLUXVsa096Y3dxZzNobytHOWxxWjFjZXdoazRFUDYxckUzSjRFWUFK?=
 =?utf-8?B?SzV2OGRhVUZjUS9zWUhXdlZ3MngzMlc0RnM4b0l5S0FaR2lId21lb2NoMDBW?=
 =?utf-8?B?QUhzQ29qRkJWQ0oyWXh5RXJrZUhrRGpmV09ZVUdhVGR3WWFTMnA5QkRjRTdz?=
 =?utf-8?B?UEIvVi9Cdk1mNEc3aW1tc2YvODg0RXh2cFEwT1Y0OHpJSzZrTDR4MWsxNzRh?=
 =?utf-8?B?dlJWNkVpZ3Q4T1A2OG5TbitTU1FrdU1LamFWeEljRUFnaEhkbTc0VzJBVjZE?=
 =?utf-8?B?YjFuWkh5UkI0NHdxV1pDakpHQ0FIYWpPNHFBS0JYUGthQ1FDYm1uc2F3Y2Nl?=
 =?utf-8?B?azJnclF6VERBU2xCVTBWZFdnYkZhNU1iS3NKd2Jlbm90L21WZDgxeEkvWWRv?=
 =?utf-8?B?R1FCbDRvRDMyUEticmsxdEdYL1lzak15NzBRTkNYY291bEZUbnE4aTJIN25I?=
 =?utf-8?B?c1VIa1RkVVptVlFIZmVyNjdkM3Z6R0FydXVjeHdNN2NEa0dTQ0s0elJ0aVR6?=
 =?utf-8?B?M1l3UHdISjNwSWxvWGhQY25RcE9oOTNHeEpLa3dYbEUrL3ZBaDJ3TC9jeFFE?=
 =?utf-8?B?eHc1ZEJrSmliaGFSY3c0U2Z3TXg4ZVVVM1d0SjdhQlRXdUE3dkVJYzBnZUdl?=
 =?utf-8?B?aFFCQmkxbmRDZTZRSm1ab1ZUREV1b2NwcVlMMFdIazVUVnJiVk1Pc3RlSHFl?=
 =?utf-8?B?TWo3Vk9QZDdkY2JPZ0tkbFIrYkQ3dklJYkdmYmF3WjNWSkdXNGU0N0tJWGtL?=
 =?utf-8?B?NVMyZ3RXcjdxd1pDbDRrYTJzUWtHamJQWTBCZUc1dXBPdGlWR0w1eW9iR0ty?=
 =?utf-8?B?YXdPM0lLMkpKS1lpdFZ3bXQ1MlVRZVV4TmN5K2t3d21QbzdPTm4yMHo1Yjgw?=
 =?utf-8?B?ajFoVkdXWXNreTVjb29Nb29BNldsQW9SeUJ2c2I5dVVLTTI2QzFlMzJ2Y0ox?=
 =?utf-8?B?dzlIZGJZVVJ0aU1HV2JlNWUwaWc5b1pVWTVYQWNXVURGRUkySjdjYkVlZjJa?=
 =?utf-8?B?WFdvQVd1a0ZWY3J0ZlJvTlBLWFpTd2t3d1FhS3VFOEk0U1dHNkVlNjVDOXE3?=
 =?utf-8?B?U1RqZkY5bWdUWitRNnFQUXozT3hXQW1UZndwdkJDTlp1MWcrNmFydU9iVUN0?=
 =?utf-8?B?cWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5FC9CA638B55274799AFE922FE0E9B8A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37f1008-7c75-491f-10d0-08dd03600a3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2024 21:21:57.9882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4eoG46KHTFN2/F6RoesqM5mHV/baMKgOcuaO/WjC/5Ae2sXXOud6QvMD5iIvNrThxo9QzjaWQar8h0eeojNCtBVceQgngoaLPXCPoIY6e4w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6993
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTExLTEyIGF0IDEyOjE3IC0wODAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
T24gMTAvMzAvMjQgMTI6MDAsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+ICt1NjQgdGRoX21u
Z19jcmVhdGUodTY0IHRkciwgdTY0IGhraWQpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB0ZHhfbW9k
dWxlX2FyZ3MgYXJncyA9IHsNCj4gPiArCQkucmN4ID0gdGRyLA0KPiA+ICsJCS5yZHggPSBoa2lk
LA0KPiA+ICsJfTsNCj4gPiArCWNsZmx1c2hfY2FjaGVfcmFuZ2UoX192YSh0ZHIpLCBQQUdFX1NJ
WkUpOw0KPiA+ICsJcmV0dXJuIHNlYW1jYWxsKFRESF9NTkdfQ1JFQVRFLCAmYXJncyk7DQo+ID4g
K30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwodGRoX21uZ19jcmVhdGUpOw0KPiANCj4gSSdkIF9w
cmVmZXJfIHRoYXQgdGhpcyBleHBsYWluIHdoeSB0aGUgY2xmbHVzaCBpcyB0aGVyZS4NCg0KSG93
IGFib3V0Og0KLyoNCiAqIFRoZSBURFggbW9kdWxlIGV4cG9zZXMgYSBDTEZMVVNIX0JFRk9SRV9B
TExPQyBiaXQgdG8gc3BlY2lmeSB3aGV0aGVyDQogKiBhIENMRkxVU0ggb2YgcGFnZXMgaXMgcmVx
dWlyZWQgYmVmb3JlIGhhbmRpbmcgdGhlbSB0byB0aGUgVERYIG1vZHVsZS4NCiAqIEJlIGNvbnNl
cnZhdGl2ZSBhbmQgbWFrZSB0aGUgY29kZSBzaW1wbGVyIGJ5IGRvaW5nIHRoZSBDTEZMVVNIwqAN
CiAqIHVuY29uZGl0aW9uYWxseS4NCiAqLw0KDQo+IA0KPiBUaGUgb3RoZXIgZ29vZnkgdGhpbmcg
aGVyZSBpcyB3aHkgaXQncyBnZXR0aW5nIGEgcGh5c2ljYWwgYWRkcmVzcyBwYXNzZWQNCj4gaW4u
wqAgSXQncyBteSBvbGQgMzItYml0IHBhcmFub2lhIGtpY2tpbmcgaW4sIGJ1dCBldmVyeXRoaW5n
IHRoYXQgaGFzIGENCj4gdmFsaWQgdmlydHVhbCBhZGRyZXNzIF9hbHNvXyBoYXMgYSB2YWxpZCBw
aHlzaWNhbCBhZGRyZXNzLsKgIFRoZSBpbnZlcnNlDQo+IGlzIG5vdCB0cnVlLCB0aG91Z2guwqAg
U28gSSBsaWtlIHRvIGtlZXAgdGhpbmdzIGFzIHBvaW50ZXJzIGFzIGxvbmcgYXMNCj4gcG9zc2li
bGUuDQoNCk9rLCBzZWVtcyByZWFzb25hYmxlLg0K

