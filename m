Return-Path: <kvm+bounces-51097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C9709AEDE9D
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 15:15:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D64941BC08F9
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 13:13:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D35C28DF17;
	Mon, 30 Jun 2025 13:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gBOZE4gx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A7028A1DA
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 13:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751288984; cv=fail; b=ek8Y1BkqNCub7YPOiLIA4tHpgTaeQ244YYA0mb8cjhyG0hvMFwLBT9USXG7y40PPaVPVOxAsa1MHwBFXBeuIpUYqQZ99Kl1tLifdB5Dh49adxRJYBzz0id5VA3r94Xj21zxTHshr7li6eeTF5f0yjMFKmiGjkDVmXAmpkSW0fYQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751288984; c=relaxed/simple;
	bh=KVzxwLb85OGQcSzyoRMERUM2cVQd/dQ/FKjcMGWGNq0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=G8GEwwqO6gxvVCrwYqjG6j4X7L6FNcZoKqdN7WAy2eVAXXH5NtZCrHNpJ2/3HpkN6qzfNCNlCxiDip//GITDSYDXQevGP+jVejTP7g8wrZk9aVsAOnfHqnG1/zWRgeo3GBFBaR3QOjQfhs5utf33t/f9fguskGRrw3DHe6pKtGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gBOZE4gx; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751288983; x=1782824983;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KVzxwLb85OGQcSzyoRMERUM2cVQd/dQ/FKjcMGWGNq0=;
  b=gBOZE4gxbMcDpWfRYpJkgBYebQVQxt4G2SJHWsGMfJBSeVadFCUWuXOL
   uKLnRcQjt0eiXj4TtrwEjrLcmwt6E5m9hXJk4S7HT4q/x1HCdKbYr+ENd
   nuz9LHlHSYqlnz1odSWMuU+6kIFyK3CuVWp5eZdZV+qaPH3fuTUxaBrjg
   86lBFNLInvh155PXV65ZIpmF5llHh3hAYSgAg45db3/O1D+7rEz+9Y1JG
   WGv9Vy9+tJVf0Vd7nN+N9zprn5DvUsZ/XM5FRNIDNUKQOEePWItecUPUa
   wxB5DpD4o/I997mLeLZ25CyTFW/g47gl7+00SLKERSyw7NkwhalyY6EZw
   g==;
X-CSE-ConnectionGUID: FwaeZLedQzeix7Uc01kz9A==
X-CSE-MsgGUID: yxNS0gPCTA+oWsTWjdoBgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="57319168"
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="57319168"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 06:09:42 -0700
X-CSE-ConnectionGUID: 4CDNwtG9QIGRiREqK3wQaA==
X-CSE-MsgGUID: gL8UNFjVQSyfX/yVi6sGVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,277,1744095600"; 
   d="scan'208";a="177121840"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 06:09:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 06:09:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 06:09:40 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.60) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 06:09:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y3Rm2ijQxf7ZKLyWJuke6t96dI0QRejwDwisog+WmRyxoikDyk43OM1VMngfIASVGIs8HV5Eye9BYlGnXRi65pqYFxcTWq3QbRdO6Xa/gqb4FhCUqyD3TLuHO8SxfcOOTPMtZrRXZnIABxUT0X6KPGfgjbK/qnTsiG4EygA6gHkgJI3qqeZviUxqGfxhyyNEGjWV8mnMS59H+QRXhQqqBT5P02n1JbwQ4iZ5LJ35sod9Je57for83OZo4FWUgrDK1yrEKBh31f8dPN53k31JB28gccSupmxN3dJqyj52vXa30XtuKkYC60Sk6wh4+/2yb/TKVUQTUSipDRT6M0QCUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+XK6qsBlA6BsJOBseU5IuZXvKPjYxIaGHZeRFm1Xl8=;
 b=R7vV3L2AAHpknfJ9Ewqk9q80mbewtq2RCNExi5SpUM8tK95wyhqImTAHezgJqhoqjMu6ctiL4mwgISJ/kF2RI4R2y6UU9YOxKTiA52jGCAl6MXNxtpmbWkrDZGmWPmVZRbTlehSedl6VY+/Ebw4vhgi4Z/0wecQDDjXahmiHmXTIvqJaEkRJEzUgfQ/AQOwEr92DboeAYrHVG7YcdkHY89LTYYFbwwWxtHrB+rOQaBjACPGesIhIYQd4jSezVsCms34okKWRJndxnejsWxjChpe/sMXqoAtdWNWSM966wVgeJDv5V32GTNmIU/eaPg6JnE4YIaNjUL8T1bFLEHv1yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by BL4PR11MB8797.namprd11.prod.outlook.com (2603:10b6:208:5a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.30; Mon, 30 Jun
 2025 13:09:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::1289:ce98:2865:68db]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::1289:ce98:2865:68db%3]) with mapi id 15.20.8880.027; Mon, 30 Jun 2025
 13:09:36 +0000
Message-ID: <005c3ac7-dfa1-423e-a095-01b5df535b9c@intel.com>
Date: Mon, 30 Jun 2025 21:15:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
To: Alex Williamson <alex.williamson@redhat.com>, <kvm@vger.kernel.org>
CC: <aaronlewis@google.com>, <jgg@nvidia.com>, <bhelgaas@google.com>,
	<dmatlack@google.com>, <vipinsh@google.com>, <seanjc@google.com>,
	<jrhilke@google.com>, <kevin.tian@intel.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20250626225623.1180952-1-alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0013.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::25)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|BL4PR11MB8797:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ea510fe-f444-4b15-e761-08ddb7d75ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|42112799006|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U0QvZXEwcTk5TlA0d2hOZFlPdTlhc05OMWV5YnM0UXF5azRFdS9oRk9JbmM3?=
 =?utf-8?B?cVhFdjNaQUMrZlhhaXVDNnl6M2ZHVmV1VDI2QzlMSldNZ29nREZYTVB6dlAv?=
 =?utf-8?B?aFRFd2dGUUxoeTc3ZXV6cG9ld3dOMk9SaEVnVS9ZSmwyb29sOFBiTFpOOVhl?=
 =?utf-8?B?MXlzM0w3U3p6YXArdkRPcXdLTjVOVVZCTXZ1eWMydFhmcTdjYmg3MTUydVlY?=
 =?utf-8?B?M212ZnpBRDdBdXNoVFJzejZYeU5UTW5SdUZUUjVGemo5Z3laODFLZzduZ0Mz?=
 =?utf-8?B?aE1VeHR4dkdINXRvOWVXVmMza1V3S2F0RTNxMlJ4ZlpmVEM3R2RzcTJWNFA3?=
 =?utf-8?B?NzNpME0xeTJ1VndxNE5SaVBGWTRRZUZ4eWJmTk9VTTV3eDlJdm9aTGVOWWp4?=
 =?utf-8?B?TzJ6cHJOUFJUVVJQMmtmWllHNWdxNXJzNW5oSFZNUi9ZUDNwVzVXblg1bXJs?=
 =?utf-8?B?cjFtN0J3RmlzNDZtaUtzMkxGaTNNcVNFV29wRWMzNVcvSGJlN0R6OWM3UW5D?=
 =?utf-8?B?RVRNVDFNOHFrK1dqaDV0WUx6YVM0TGFJZ21jcGhyUkU5NDNTS013aWZRM29V?=
 =?utf-8?B?TjEvZUV3UnhTUys0ZlI2RjA4VXFrRzVOVTlFbURXRzZ2bnZjVFYxaGl1VFZq?=
 =?utf-8?B?MmNKRjF0MEkyR0tONDdWMklOZ21yMTBXR25RTTdBRkFFU2p1eWVHdS9COTVU?=
 =?utf-8?B?Sngrczc3eEFUUVliZ0drTi9tcG9ES0xZc1Y5Qk5jYitmdVVKSlcwZmZ6ZEN1?=
 =?utf-8?B?MkpEUkxpbFJyT0ErTFN2azNzY1pPbEw5SFlGY3dMejRhL0pXdWZlSnNhRHdz?=
 =?utf-8?B?SjQ5MjBGeitFU2xFK1JRSG0xbVNZUXR5WUswcWxEMlU0TnBFUzdCRzlqWnhR?=
 =?utf-8?B?K0NRTzNWcmF5K3Q0Z0plRHp1YWd2bytIT2FWYkF6aG9ONlQ2RTk3cFRvZkls?=
 =?utf-8?B?TTdBc1RUQnJhT244MkpJQlV5bFVaeEl6MDRENmpFbUJBNzdWS09ibnBNZCtD?=
 =?utf-8?B?Y1B6cmxIYTJVNGUxMFdQaTRxdjRGRkdZdjBkNjZ3emh5SGhUalVaQ2JWcnRC?=
 =?utf-8?B?cnlUOGM5cktlazhsQkFraGp0NEFLZ1ZTZHNVODh2cjlGdzVJODdKUWs2VWFU?=
 =?utf-8?B?MStHdlY5SFNkNEV2UloxR2RsYVZRY2hOdGpNSjdYckNNNExWeE50WFhhODR0?=
 =?utf-8?B?bjdDckhiYkhxcHltS1BVRS9rZUgrNU5NNmFmcnBOT1UxemJoc25lU2tySm1F?=
 =?utf-8?B?MjR4MndHUTloSW9hZmR4SFpIQlNmaG03c21zQ01MUHVGb0JSMXhXM3BiQWdT?=
 =?utf-8?B?Y2ltcnBDdm02L2JxeGlhUlBBcnlxa2dBM0UyK1k5OThVbUFoSCt1MEtFbUhZ?=
 =?utf-8?B?YnR0NHdnUGNCMjJXU0ZMNGZaRUIxcU1DejhDTDNvVVR0NGhvVzRTZXZBSVU2?=
 =?utf-8?B?bllqQWZMOXg1Ym5vQ1p5OUJnTEFiSVJzSnhZalJpWHNDYUptbkFUNkNHRXlV?=
 =?utf-8?B?TEJVWEt0L2dxbXVSalR2cU5UazhXMGNNTXNhVVAyOFVlRE1lRC8rekFoZHcy?=
 =?utf-8?B?S1MxVHQwV0pnOXlpRXhITGlZK21rU1czZG1DMElXOUhNeXhGV0RYMW5hUVdF?=
 =?utf-8?B?UFdJWWk5ajEyUndtd0Ric2lxY2NVU3NUcUF1RjVEa05Pdkd0bVRaa25RTVpm?=
 =?utf-8?B?elpleW53T0Ntd3VkYVlvRlFrSy9QZSt3QUdWNFBxWlFzcERKMGlWdmZENW1R?=
 =?utf-8?B?UUU3YVBGNXFUQWhFeXNJckJvYWdMT0kyQ2hUc3hCdFVObU5UUy9QdzVsMkhR?=
 =?utf-8?B?L0dQRWNJUjJTbmV2bUNQaHpkWHY0V21udWdMSGZDYzNQRUc2aFFad1VuM3Zl?=
 =?utf-8?B?T3V2RHZsTzc3Y2w4cjZQMkZmL2JuMWVKUVQxem5ZL29sdjdMb0xRZVFnQ2xG?=
 =?utf-8?Q?IpwAcJsD6mA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(42112799006)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDRENDVPc0JDRW5Ld0tOZlZ0T0w0OFNuaFk4MFBvNlArL1IvcnhhMS9Nbk8y?=
 =?utf-8?B?eHNzY282MHVwUy9HcW5oc2RrK0RqTkc1RTNjSW5qekJQcUh5ODJSYS9VSHBP?=
 =?utf-8?B?WitxUlN2QmN5UTZGUW8xeTJkMSs0Q1pXTDdnbGlaYjAxQVNQdWFMR2VWMncx?=
 =?utf-8?B?U3AySE5qb1BYRWUzZ3p5bnFTODlrKzJlRzBKWHdFTkRQVVdkL3loRUQ4NWxa?=
 =?utf-8?B?UFlJTlpRWWRyZkw1TGVOZy9kSG1mZkRKM0ZJNzErOVJ0ZnBXc1U1OFZLMmJX?=
 =?utf-8?B?TjJOZ3JjQmErSWVwZEc0eitER1p3Q2dNZGNpUFhpUGtVS3lqVXFYZ253YzRs?=
 =?utf-8?B?bXhUZXhkNzZuQnpSU00zcHBoYUlKK1dQV0ZRcHJob08zR0xRUDAva2hzSjBS?=
 =?utf-8?B?a2o5WG15VHdpMitFSDVnUDg0MnhQbXlGbFN2bjk4ZjFjeUN0TlJKM0hCMWs5?=
 =?utf-8?B?aFJhZzMreFlod0RNb2lEUjhrNnkyZWhyZ21SYkhUbXZzMzNqbllPaHBSeFRw?=
 =?utf-8?B?ZkZFOVAyS3ZUeThqR0JEMk5Nc3FRVEQ0Q2dxWDRTRkdpSVFrcC92N2lKaTFT?=
 =?utf-8?B?RjArMmc4RndlVDkyTXI3TnpHUHZ4a3pERk1pU3ZhMmxuN0d2dXVwcEFvcDNr?=
 =?utf-8?B?M1EvZ1FoMEtDTDF1aUJ1amJTZzhqQTZxZUkwcDA3ekNpVlRFUHdWYWhaMVZK?=
 =?utf-8?B?K09Vd1ZzMmIwYWMzSXRwYXoyak9nMnBhUU5mVEVnM1BJT3UwRnQwWSs3YlA4?=
 =?utf-8?B?a1VxV01kZ0k4RGVvSXRCZm1PVDk2S0lkcVVUOTBvTDU0N0F1REpwZ1pJbFFP?=
 =?utf-8?B?Zmw1ZG1vcXZET2YvTTZwaktiMGVhSk12cFBkUjhuVmdVOHVjYndxclc0K0tB?=
 =?utf-8?B?dXYxSlRQTk94cUdRZzFLOHB4OVFmYjBuOHIzNTY1ZjEyVi9HTW51ZXc0ZStL?=
 =?utf-8?B?NUFnd05lT25rMzJjRCtVMmQrUUNFejJSb2NjZDBhWFRDK05iZGgrREJWajZt?=
 =?utf-8?B?ZjFUQUJpWFp0SitpazUrZUk1V3hOR1NFaXlGMGhIS3BjM1haQmhMdW9wOHpz?=
 =?utf-8?B?N3A3R0xKb3JtQUxSWU5Xd3FJTHBXa2t4QmJjenFjMWVPaE9YaEw5QjBNQmlx?=
 =?utf-8?B?ZFpkNFViOXBJcDFvMFg1cE1vcXlKTG83YjM4L0hDWWVjS0UzN3U2dy9wMVZx?=
 =?utf-8?B?R3h2WTU5UEgwRUdOOCtaWVNwZVl3RDdoKzdLQ0JoRkgvOHpTaVVwMzNyaGJH?=
 =?utf-8?B?ZWdva2ovM3cyZGcyNDIrNkxib3M5TUJnaUh3T1NqdE1CbnF1MW1NODdFWU5T?=
 =?utf-8?B?U3RYcDNyYjdTSUpCc3pHaW5mY0g1cWpFRURiOFdpMU1PbytFbVgwSngrQTlv?=
 =?utf-8?B?dklvZWord0VGV29QN014UmZ5Ulo2SGNvUGpKdDBXRHdaWm1KUXBseXkvVjFy?=
 =?utf-8?B?d0dnb204UUpvUjBWeUIzdlA4TTl2Mlh4MjlLdmZFeWpkakxaeVlvMnQrdFAr?=
 =?utf-8?B?NUcvbHcvc3JDUDVCUDVReHNwelAyclAyejk0bGRlSUMvTUhwZ0VzeWFsckEx?=
 =?utf-8?B?N2haYWxRQm9uRGdhT0FMaTlKNkhpdU9qRWxyenFvMEg2eEhQTTBuem8vREFJ?=
 =?utf-8?B?MzQ4UXZKaTlQSDBadDIwWEZ4YlkxVnhpeGIyNnV5VGlhdzM3L3FINjFNdVJs?=
 =?utf-8?B?K0Q2ZDROTnRQV1UxcEZRZHlKSld6cm5TenZvbmtqbko1UFRaV0FRTFFqL283?=
 =?utf-8?B?MzRuT1hZdEJiVDhZUFo4bG85amRUZDlzWmRncXY4cjh0NG1ZYXRaUGM1ang5?=
 =?utf-8?B?Wi9wSVlkaEJ4azJRVUlqNVhaYlJSWklWWHBaYzVWNjJ3Y0JPSU8vUVRvQ0ZQ?=
 =?utf-8?B?U3Jta2EvOTRNTG5WR3hsYUx3RTM4SEJqZmxSMDIzZjlETUpEVzFkSlpKMjRn?=
 =?utf-8?B?cTNpNVdGdXZwSW5OTXJNRnFIcllDbUphQllsYjhTWVBsU3dwMDg1TXhQdVd6?=
 =?utf-8?B?ZGZzR1F3YzBtcnVnb3BZWFA5amFnV2IrVTgvbmc0VHZWTWwvNXRWYnRwMGVX?=
 =?utf-8?B?OTJ1bklNUSt3YU40UHJNV0pVL3RYV01GUkR1bGNoNTNnTUtyKzBnN1lqdlEy?=
 =?utf-8?Q?KUIerC4GJ29BHLewX50e+02u0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ea510fe-f444-4b15-e761-08ddb7d75ce4
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 13:09:36.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QvVF4+h4PbmJ/s+t/uEgDck83TtEPpIkTFd/g1+WPuBRa2Zv6cIcvO3iH5W2FsgihXS0v0wD5uALERRi8Gw0EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8797
X-OriginatorOrg: intel.com

On 2025/6/27 06:56, Alex Williamson wrote:
> In the below noted Fixes commit we introduced a reflck mutex to allow
> better scaling between devices for open and close.  The reflck was
> based on the hot reset granularity, device level for root bus devices
> which cannot support hot reset or bus/slot reset otherwise.  Overlooked
> in this were SR-IOV VFs, where there's also no bus reset option, but
> the default for a non-root-bus, non-slot-based device is bus level
> reflck granularity.
> 
> The reflck mutex has since become the dev_set mutex and is our defacto
> serialization for various operations and ioctls.  It still seems to be
> the case though that sets of vfio-pci devices really only need

a nit: not sure if mentioning 2cd8b14aaa66 which convers reflck to dev_set
mutex is helpful. Perhaps, it's welcomed by people working on backporting. :)

> serialization relative to hot resets affecting the entire set, which
> is not relevant to SR-IOV VFs.  As described in the Closes link below,
> this serialization contributes to startup latency when multiple VFs
> sharing the same "bus" are opened concurrently.
> 
> Mark the device itself as the basis of the dev_set for SR-IOV VFs.
> 
> Reported-by: Aaron Lewis <aaronlewis@google.com>
> Closes: https://lore.kernel.org/all/20250626180424.632628-1-aaronlewis@google.com
> Tested-by: Aaron Lewis <aaronlewis@google.com>
> Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>   drivers/vfio/pci/vfio_pci_core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

Regards,
Yi Liu

