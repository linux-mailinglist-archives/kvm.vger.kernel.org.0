Return-Path: <kvm+bounces-73208-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6LUzOPqAq2mwdgEAu9opvQ
	(envelope-from <kvm+bounces-73208-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:35:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6E022964E
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 02:35:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 619DB312F736
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 01:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4A5F2EDD6B;
	Sat,  7 Mar 2026 01:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NctJFHtJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 582032EAD15;
	Sat,  7 Mar 2026 01:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772847228; cv=fail; b=s42wMHpJxJfIkkIKJVHq1ajp877B67s7pSPJRtzAjN1DdIRtajxhj4/uo5BlBDM/4STp3CuEcN+8Jpda1lYRIPweWj1ubmbgoIDKs5bP38AHiFbjndOJr3PE4fAlVNy86h+51jsvm8K6UiXJtxdynqrbDECojBn2lQx9uB0IoEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772847228; c=relaxed/simple;
	bh=6xaFynilcsObQhxQZQvLYWR19dYUO+UqceeBCthgv9I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EvTF2NAXtZF8rP5Vepf6lFP4/mWcG/v/PgDnzo26N0CRbZ9WSy6S22q9IRIM3/LurmwpbmoV1FgdUdsxC7W6FIZsL6BgsY7EhuZkqSqjRw6C+k5EGXiKQMVkCXZJfHQMX17sm39m8l3CxwhDif8ku2ixCX8scLORBLFV/xgG/9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NctJFHtJ; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772847226; x=1804383226;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6xaFynilcsObQhxQZQvLYWR19dYUO+UqceeBCthgv9I=;
  b=NctJFHtJb/M0UI5gJTqrdjisS0REUajOUAW9487IQo149ecnurRy0hAA
   oI3G/tuQmOi93gz5HlRX1ddJxFZLRNPnkcU1oCUWyDdLy2gCrlPRWEdCc
   4Oe+VcE/0JxlOykrfEsvVp8RFqfVtgqp1Oa/sQah/d5aKTAngtp+wRD27
   D1T0bEMctGoU+Dk3wGUXuQ5qnD5hh65OMweD4JoLR1pFYyFfsh8yklfEE
   IY4lpma9YHU7sdDCVc4Gahgi3CUPv9hxtRjNCz5Nk7HD7UM6TcJH9zcH2
   FALTToaDMyLqGAcHQFoxYMNYu0BCxZL+nvgv2qoDODVMIG4kkYnJ06Erf
   g==;
X-CSE-ConnectionGUID: kEWKM0aNS0qt0IHVp69U2Q==
X-CSE-MsgGUID: gOesknlWRSObHT4sQRjHzg==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="74036080"
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="74036080"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:33:46 -0800
X-CSE-ConnectionGUID: bLDKaolBQmeKABcGS4DlBg==
X-CSE-MsgGUID: cC78jJ63RNitqcniWxhA8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,105,1770624000"; 
   d="scan'208";a="245371281"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 17:33:46 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:33:45 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 17:33:45 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.16) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 17:33:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JJNfKCCROVMVKoG+agEXZkmhFHy66bl+7gVzKdzR8ewtIyeHtchhOZmlcRfC/eL1dEA+KkvTtUiyCsEA2UmM4ktm2LoaTIzVBqcv6H9nAls36pAFVDsJH095VQ2qjmRZtjKDBoWFkPmshitDO0nVIPQWSre3ifMjR/bsBlg06puaHBNb3vAOlBfAKEctOu7EVVC/jTQG/v6tTz3NXTdgTTAtgyhNfYClziL6lTwCQtXC8wGHyjhXnvL2kYVEDFIGXYAUBNGqD61zNmZdTnZW0PYSekOZQdCkbknb/wcJohghPf+9h2ZNCmWYzMuIbvKxscqC+ar3W3M9Wl3Oyd9h3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mU1U/m8v449jGdZ/5M9I9rRR6CwN9mny8NE86zz8td4=;
 b=jRTHzNYM9Rl4/CNQBUiP1hxe4DJXzDEIZXn3gwEGqPGaB1g7cWsgh6e5D3Nl6scfjJs1E7V3N9kpl5GBVZG2x31lVdrILey+jOGvoph1j/1P3RFZjL7ChJGbtv53m1Cm+rqe2QD+gTPhgwn9wiGVX5xY3tlnektuHBoQdBM0a24c6j2K2VkoNIIxtQYZa/lEZAYe7eY2DyDzl7oBpPhCGVaucsJK0AMHbvWqne7cGweE8KvsJ7mBFncFjAPdACziH9aMABIBNDPaXJQ4BW1LVi3X83KANbxcxKV1bmVvHPOYvMbLBolaknd3lXLuJYPy5oxGAfOtB1wkJ/NAy3Q5dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS7PR11MB6040.namprd11.prod.outlook.com (2603:10b6:8:77::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.5; Sat, 7 Mar 2026 01:33:43 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::60af:89a0:65dc:9c84%3]) with mapi id 15.20.9700.003; Sat, 7 Mar 2026
 01:33:43 +0000
Message-ID: <5134f57b-8be0-4ddc-aa3a-f3a66ceca411@intel.com>
Date: Fri, 6 Mar 2026 17:33:43 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/16] KVM: x86: selftests: Add APX state handling and
 XCR0 sanity checks
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <chao.gao@intel.com>
References: <20260112235408.168200-1-chang.seok.bae@intel.com>
 <20260112235408.168200-17-chang.seok.bae@intel.com>
 <aakGVnGI4jZ8yCUM@google.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <aakGVnGI4jZ8yCUM@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0012.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::22) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS7PR11MB6040:EE_
X-MS-Office365-Filtering-Correlation-Id: 2288d100-e79e-46fb-e63f-08de7be9919d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: yBl9jYCKdOzDyh1e0cagdgEw+FPy9doFLn8vLkJdjH7C3XduigWM+2sTQ75zY/Z2YHO/B3zZk9qm6CbmZ/bu8aIAMk0z/0LJaPBcMiYeoac4FTER3xS6ZVl7GUf2weWCFCIjj0PjfxLd52GqkiyVj5qkI1v2yiukoX572GV0SjGp5O9MaQ334dr9+6rOBU1bRRQ+GfI4fYJM+ihH5rVQX3jdE8fYFfcVMmNRTadh9/rsSUGRr0RnGM+jfWEUhM5hghP6RBvsjw1E1AuDG+yJsIME4Z+vDdi/Gwfl8wkUFsHaQpFe1BcEzq4wsN2q13aprXP37L7WKTsplix6DIL9VQxaPaP3yRv+VytuveOgEM+VO9xiId7itzWOPfXmfXF06UGHG4LWWF4Ke6Gx0/GIuxC386EGlXvefiNluXQnj5LBp8NhkczkBBln2VCL7SNOa5CoUjnbgtucB9Sj5flXLiyn8nxE4gBPOU54T9JH9wk9Jgbqk+2lORvCyfbHMXGrtjueacqHXFZWF9lRXADtTBqozH0XD35o2ycWAf7vuP5E/lVB4B2idjcHUAn5BGCzypTGWRp/lUHY4FiPYoyTffpueYad4fKzrPxLwfn+58+0NM8v9NQ5VuHGDQrmAiCqRxKlbr7db2Hx/iBpBusGn0+TzcHiNP5VYf7HhQAKhLpsXfMDOh11gX2fKh3QVg3kicPMCjkwtc4Ucuup9e9t7+fXss3mW9D6F+xeDOjTaQg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1VzZ1dxeGdpQTIxRGNPOGdleHdBRzVPMkE4REYxMnRZbGt0cGJEd05VZm1s?=
 =?utf-8?B?RGxvMEhURGNCUC9pT0dKYnUyNHZCWlNjWklKZUJDOExDbWhKYVZxeEExakgx?=
 =?utf-8?B?RGZzZzB4TmNndEtoTjd4RzdKeEx6TWEvaGMwTHNucHFFbU5zcDFhZlFQdXFW?=
 =?utf-8?B?MkZGaFRnaXI4UDdlRVJVZnBxRzNERllsa2Z1QU1tcXpiL21mN3NmSVlSeVBE?=
 =?utf-8?B?SndRUkNTcFZ4TUwrTGhGd21qcG1XY1BvNHBOdlViOW9XL0ZGai83a2psNUNY?=
 =?utf-8?B?N1hrSkt0OExsTTNzSzgvZWhMaVAvNmdDYmhNYU11dGg2Rnc0cDU4WURldmRZ?=
 =?utf-8?B?TVNCMDAzSjROUEVmUndKS1c4TlNkNDRCQmZJQnQwTi81RERDcHFiNEEwQWZn?=
 =?utf-8?B?bjI0cFpTSWlQNGtQcldveWpJVXRaSG5yc3ljT1hvTzFlY0twZ3JBaTB0SXZO?=
 =?utf-8?B?MVAvME02WU9TTnRic0RZcHpZUmlud2t6QlpUYzkzWStiNHVEVXNCL1UwQmlw?=
 =?utf-8?B?Y3BDVVk1ZklDWXJlT3MydENwQjRyNEtCcTd2dGt3ZDdsOUpYSFplTCtOVklE?=
 =?utf-8?B?TTFpRXpHS1cyRmcxZnBSeWtZQmxCYmRqNS9obW84NFJIZXJuVkdEU01EdFov?=
 =?utf-8?B?OWRtY0lvZnRlRUN1ZjZDUEUxRGRoRFI1SHZUek04THZoRmFyRFQyOGlEaTB4?=
 =?utf-8?B?QnBVaVo1U3lCYlROeC9aeGN0RjYxdXBBd1dJZCsrdDZHTmNjQ1hLQit6ek5j?=
 =?utf-8?B?NWp5MVI5S1RLMStRTGtzNUhrSDlEN0lHdWhKZUgyTDNxOXpqY0dRS1d4eGZk?=
 =?utf-8?B?LzdZTEhwS1hvOGlSeVV2cGcrOGZuV1dEcmF6anRZK2tPV0w4N1JMU3d6THVI?=
 =?utf-8?B?YnFMaHd6OTd6UVVDWURKK2F2d082MFA5TVg3NlFRNzFqNk03K2krM3BjWlJX?=
 =?utf-8?B?dWhCV1laSGxEUmlYM3FSU3orSThQODZmbElCUGlRRXlzVlpLL21sQ29NVldu?=
 =?utf-8?B?Y3lUd0N5czc5VXByOUttdGRKV2Fwa0ZENE9xTzQvTnpiUjVONEFndGNYYWRz?=
 =?utf-8?B?c0RwNFpDdDgwbHRKWUMvenRMbHNyZ3pTTW43ZDd6bUtiU3VlSEZRTzRqSTdw?=
 =?utf-8?B?MVowMHhvbnlnVEdncWI4aGpYU3ZNZi91TnVNVUN3OWtVQmw5ektlUlNkeWNO?=
 =?utf-8?B?cHoyRFViVmNEZWFFMmFFc1NxaXp3REZMelIxT1dkL0tUSFNOb05RNWRJd3NV?=
 =?utf-8?B?SWpKZFp2bW1IQ3k3VzZ1NjRXY0QxeTlkNFNZZjhObm5uclpKUnJWRnFrY3Bm?=
 =?utf-8?B?dzExdDhiWXZPbW5CM1lUUDN4YUF6QmhCbEpQcGo3cmZCMzdlYmpKRmVaTlZi?=
 =?utf-8?B?akEvM3JENSt0SU05eFRaU1BWemZudUwyTXZiZkZtVWJtR0lTaEkybW9SMU4w?=
 =?utf-8?B?a1RFZjFKK1c4V2xLRU9mcmlFa2k0V3lRbXVSdjFJQ1hUU1JBNUZ1WUtOSW1K?=
 =?utf-8?B?N3RVQURLbk5ncHN1T3k4QXR2SmNWSlRYenN6N1g1ejcvSlgzcVdKWWxVWnQ2?=
 =?utf-8?B?R0trbUtGcGd4bG00SlZ3M2NEbEgrRFRIZVoxbysrZHNiSkJQdFJEdmVxNngw?=
 =?utf-8?B?NmdQS25pN1VYTEdqRkMzSzZwbnFObU8rNjlCRjhmbG5aeVM5cTEzbHZ2Qm8z?=
 =?utf-8?B?TmM3Zmg3aTdJSGgrNHRENFZ0dFNld21heEtDQzQ4NExJVm4wbVJVZWFOU1Fz?=
 =?utf-8?B?VnFYZFo3V0lLUVJZVERoZStWOVNTUTJIUUdGL01rd3l2NE9rT0hGR1lxQkxO?=
 =?utf-8?B?U096T3EzWnQ4ekxYTWw3aUxOQkpqUCtpMmczc3IxanV1a3B1cUdOUzRRaGMx?=
 =?utf-8?B?REFVSHpzanhhc0xWSDI2c3huWTBUZkNJS0UzWGtCUmhvMHptQTZ1T0JMQk9t?=
 =?utf-8?B?OXB3Ry9tZXJPbjJjVVQzL2xtMFRiK0lLT2JjUUoxTTBEOHE4TjlNNHZPUGow?=
 =?utf-8?B?dUlHcjlqMk05eE5GYUcvODZUL29CV0d1NGtXbzlBQmRuTFFKRXA4VkxPL0Rr?=
 =?utf-8?B?TkR4SzIyak1yRW1KNzUxcVZ4WVpkZS96amlMcHN5OUcxMW5QUWtOZ1MyK2xZ?=
 =?utf-8?B?ZXBmU2NSMWMyejdqbmhIcDErV21qdVVRK3NlUVlHUTZjSkxuY256WkpMeU1i?=
 =?utf-8?B?alg3WW1GeVMraStLSnEyaVp6dzQ3TzNCSUlkYUljb1F3NXNvTkZ2eG1mYU51?=
 =?utf-8?B?UEt0VTh3ZE9vTmZBcXM2ME53UVpUcmJ4RXJHdjhCM1ZPUC9USlovYjVjMTJH?=
 =?utf-8?B?MUd2OCt6aWZNb1hVK1h0YzhIUEdkaG9QUTJ6RlJFdDF4akVtTWk3Zz09?=
X-Exchange-RoutingPolicyChecked: JF6qUIAXG3cBhyA6s3TyVxPZzevdoQMaOCRHLTReAfSmmFXuDWXsQm/jmkb4v3wk1su9kPySXBA7dh27Jm8gr9w39Wd/jxt1i5AmI5NV4u5ZBvazf8HYDPiCfBCd1ukuTIO/3GjCgGQbcvD6WjhONWfa0tHsr9s5KZyJSlZjZF+793p0qFJS7+m9w+tfJzBaY04FMZrRyQkhgs1m2HeDk1fe9Q0NglMxaNn8tTXeH3H/pYKZ4jOq7m0K1BkQaFl+aR5CEo+GRDYEOPpiKvQNVBubrv2WjAEBzq3Ovx/JWCVh0SfF3sNBjFP/Ismxc+Na8BGZsD0nKEcq2SQk9r0HxA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2288d100-e79e-46fb-e63f-08de7be9919d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2026 01:33:43.5664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 26vYDIbcECg46KBSaPhWKlOvYQzAkkd+HIfxE/c0JqAB0Utzk3U/HETk0imeMnrYl/YF3unCo/9CG0M/LpFcnyNVadsJUQmqtkzJOjdxHns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6040
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 4C6E022964E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73208-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chang.seok.bae@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.974];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

On 3/4/2026 8:28 PM, Sean Christopherson wrote:
> 
> I assume/hope there a more tests coming in future versions...
> 
> KVM-Unit-Tests' x86/xsave.c would be a good fit, or at least a good reference
> for what we should be testing as far as EGPR accesses are concerned.

Yeah, I can see establishing a solid test set along with a new feature 
is pretty much a requirement for KVM. I'd come up with some updates. 
Right now, yes, considering that xsave.c. Thanks a lot!

