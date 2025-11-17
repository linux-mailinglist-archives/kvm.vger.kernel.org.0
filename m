Return-Path: <kvm+bounces-63420-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 44A9FC660A4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 20:57:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5B5EE4EB149
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 19:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B43E32C30A;
	Mon, 17 Nov 2025 19:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lUAyDE2P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E31313530;
	Mon, 17 Nov 2025 19:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763409462; cv=fail; b=Jr+kpZY4OvYtGgFdFtQTwd9+TZ21LDPKmv7BfAQl24LsGQvG7UjuUF9aC4AOp1vcIXm+GYcZLsdkwyTrWaW36Lh04zTsEJcC3W5pvbELwPs6BYus/Q+iQMXWkgLhhKAoSW1VHzNLWl8omibhgEWe1qLPBG8KC2xwCFbTqTVU4wE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763409462; c=relaxed/simple;
	bh=J7MNYfhs7Srr/OjlcKJR0JVSufL6rP0LHPkvMKmobhs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ss1SKIx0HAbZ2p7WS5XNwLS6EcnqLd1LgPwYP/jNw4R118afrJUF9BwgQzB0gVzNDZm2OjHLn0DBOz8Spa1vq6A87mZgejRehmgW4CNtNLXryj1Px0cbJCD3kLGHoVnpl/jNneZaZ0CuG+LxLVekvm1IXrA24vU8w3uqgEEpbF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lUAyDE2P; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763409461; x=1794945461;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J7MNYfhs7Srr/OjlcKJR0JVSufL6rP0LHPkvMKmobhs=;
  b=lUAyDE2PUzf/a3SiXJh++Q10v0lvkMUNeQ02TUqhpTWonCdc/lllvkUP
   zcHzbu0mXknJsUfMYnuMyoFH+uaty6px69TyzZi+5HIWdMNdflDitUXjA
   F2IEpFNjiICwK4Z3tkkAIT0qOKIt5oGU2AA/9Hudn1tPKiUaOPf8E5Onm
   PKxh6I8v7n8U5xP3BQdenReqn0eNJTE1m3QTBZlRjXihQr+q9fcyA5Lnt
   2QW+S8jAaKVluZmBp68GjLexIaDvYT5NXCvqG0OI1hxemHgQ/zQ4nvibF
   URadSGfh8XPuqRkAZkA1n34vwdR8XSnUDh//7D27xJChYyP4j1/AvYHxl
   g==;
X-CSE-ConnectionGUID: mVWR649mTgyDbZ0z5OiISw==
X-CSE-MsgGUID: omfNePL5QkaNRGJOO8gEcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="75740404"
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="75740404"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:57:41 -0800
X-CSE-ConnectionGUID: b10MAwv6QECVcIinDSbUhA==
X-CSE-MsgGUID: JKB9dZtkSS+GQmvX3cs9rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,312,1754982000"; 
   d="scan'208";a="227877086"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 11:57:41 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:57:40 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 11:57:40 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.19) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 11:57:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MF47+6y2c+qDG0ZYTuheBalFG5LAj8umNDNokU8pdxzMEwQPK60ovRHfIXGjU0OsHywDh985FbSvwGtLqRL8SUxSwiG0gKvEU/kJSnQD6jzpcRoJ4w6ztXc93Yek1eJHpl+z7syV/4mtzd/jCMmPiOh/PLXeAadtPliusuqLyb41CzZfFxVFhaWMR2/nQgC/v27+MNecfkc6+8MXTpd7bkNBxAPKDYpFNo7YuAFgxMBHtj+TV1UTw6PvtUh6u/D1h3grSQloaeDhS1RA+IG2N+8mmgghoh3ZESGWxGsw7rntym3jofouS9aPjRrdqBWbK3DYXj+o/+SJkQT5Wr0vCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VsxeHWPPpaPhU4tqmIxAseE1U236Y2fqc+fL8m6rKbI=;
 b=vWWSigtW1aKXteyX9Srz8FS8QaE3rz0zsfgMA6yEWetD72JuQoAHcT7t0LYZTrc6l+4luYzGfGAn5o52HRBKtMiFaCbtqLexRXixcjWgjQT/cN6NRO44Rc0RG5cIggrsZFpoe4R7qHkWf5Jyaz5QCtxpBHN+R+/2KME+s7rqHJN/9rstEcWcbcdt1TIJpbqdd38bTONgFBgvkEpqCJvtkliTtgtDWI0zef8Ja9kPqTcUaWIH2Ml/U5IugHuFQeevMr8hiPFOYzVk58s0z5mQZlhzZY43vEcxf5aq2Ck2+zQ3yhjB6szWEJX/bqh9R33IGkrXLh+9kFzpSL3YTeN9Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 CH3PR11MB7819.namprd11.prod.outlook.com (2603:10b6:610:125::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Mon, 17 Nov
 2025 19:57:38 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 19:57:38 +0000
Message-ID: <9f413215-bee5-429a-9ba2-843f9cb96280@intel.com>
Date: Mon, 17 Nov 2025 11:57:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/10] KVM: emulate: enable AVX moves
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <kbusch@kernel.org>
References: <20251114003633.60689-1-pbonzini@redhat.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251114003633.60689-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0069.namprd08.prod.outlook.com
 (2603:10b6:a03:117::46) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|CH3PR11MB7819:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9c668d-bae6-4521-aa78-08de26138f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a2NZU0hQbkJ4RmZCcml1Z2h2Y0RGZmJzMjloTHZuS2s5RlZxZm9WVE02QnlB?=
 =?utf-8?B?NmNNSXhVZVE4a2VKb1lreEFuQ0kwOEdGaGEraEZHTjAyZ1ZGQlB6cnFtcUR6?=
 =?utf-8?B?NHRIUng4RUdRZ252VGFpeGRFdG12d1Vka2N5TSsxU1MwYkhLTk9oMlpEcWZM?=
 =?utf-8?B?WHArcFBoQUJkQnNQczE1czhIUGdtc2V1eEhzcDcyV2dYKzNqOWxIRjU2TDJz?=
 =?utf-8?B?QVdWRFJEbFV4QkRyQ2FSZHJ0RmJnd1lnRWMweFdoaGR5NGJNaFFZNGlzcUx1?=
 =?utf-8?B?ZTU5UmpWTzhjaVl2QXFGeTFFWEYxd2NhTXFZbXJKbFpxQW5mcmtwYysxZzl3?=
 =?utf-8?B?d1docUt0WHlNWlVJWWZUaDMyaGZaNGVqaVdPeE5GVk9CTGoxcVBwZ004UlZs?=
 =?utf-8?B?RXRSMkQ0YWswc0xBSytuRVNZQXh3L05DV0pIQURTeEp5K0J5ZWk5alkvSUZ5?=
 =?utf-8?B?elVNWjRWSzVoRWI2WXM4bzNyNkhOa3JFdkQ1cUVRWnF1QTdVUEkyQncrMXZD?=
 =?utf-8?B?OEFwVUFoSUk4OUUwWVUvS3daNzhGYUl0b1B3SzkxckVMYzBjS1JhU0JIZ2w5?=
 =?utf-8?B?RzVGTWw5aXBuN2Z6YmZJbmxXNGFtcGxuQ0h5TEZRTmhod0NSV3BmbzRIMEE0?=
 =?utf-8?B?ZitUeTY2VGdWMGVWZ1U4VmRkK3FvRkE4VDhBOXNBWDBSZ0NSdlV0SnMyR0hC?=
 =?utf-8?B?c0RHMFpXNjBTRjVvNUtDVHMxREtNc2xUYjhuczdJVk9OOGlnckZZWktyV09E?=
 =?utf-8?B?NWF2MWFUSCtta0hHZEtzVExCdmN3ZkRzU1BJeDk4d2UzektMZUMxZ1VabGZY?=
 =?utf-8?B?MTQ2Z0tmUTJudXl6WUtRU3VGY1VUMVRQeDFDNHpWYjUyRkVjeEF4Qk1HMU50?=
 =?utf-8?B?UWh6ZTN3Q2FQSTk3TWJJcHdiM1UyWEVRR1RFWVp3RGl0YU90WlRvZ0ExeXBa?=
 =?utf-8?B?bXNjRVA2eUx1TFdtcTB2aUtJVFVIMHlJek1lTFdXR1U1YklOd3VhQzlCaGpr?=
 =?utf-8?B?TGZOK2V5N3h3VWJNQ213Z2FVcXpiTDFiWW1NYUtiNHEvZ1VRdlI2dTAwMFpl?=
 =?utf-8?B?d1g5QTRWRi9jbzRBR09NYkZ0cm1GbW1tZUpYUUlQdDg5OFJnSzZiUzRJaXBC?=
 =?utf-8?B?RSt0MmJEZnlEcmNGdkE1b3Q3MlZ3VWVwaFJ2dzAwN0hZRnMvRTlRczUvL2I3?=
 =?utf-8?B?RGZEcVJxeVFUdVhWR0lIeEcvOXRTWHF4SElvYzhtWDBNMWEzRmV3cTlNeitR?=
 =?utf-8?B?ZjJvbk9oVjQ2aHpJR0VXYmI3SS81Sk0vKzFWM0lrcUltYWREYldCZ25jU252?=
 =?utf-8?B?VURKOXM4ckM5aWdnckpPbUVHNTB2MmZrbytPYnJ3cXdSL1RXRGR0bzZLaHBn?=
 =?utf-8?B?ZWg5ZUxGYW92elpBdVFQdjZMaVphUFc2bi9hT24xRDZyK3preWNpR2RMalZK?=
 =?utf-8?B?TGQrVGs3WnR0TUJweFV2c2t2ZWxMbk10alRGbTZybW9NNWg4ektEVjNlUXZ3?=
 =?utf-8?B?SFdJN2x2RUxLeWcwVzlwUytVbGp1Sk1mdGRHRVJNenpZM1d6R3IrSWtrVzFR?=
 =?utf-8?B?QjlLWVFYMFJVb2dPcFRMQlNUVkhxQUlyNGZGSGJkbXg2WmE5SGQ1RVlLeFkx?=
 =?utf-8?B?ZGhEaktYUTVWb2QwMTIrMFFvcmR6QUNvaUhKN0FTRlAvTFNLRVVQTW9BckdL?=
 =?utf-8?B?ampCRlNtRkk1bm9QVkU3TEM1NHJhTVBrdm93d094ejJUM25nbmVXV25kZjNF?=
 =?utf-8?B?UFdEVnNjSGU1em5hZ3oxNmlVT3hjM3lPVmxla2lqZG9nKy92UzJLZTJWTDN3?=
 =?utf-8?B?TWVIOGYyV05POXdCNC80cFVLWmVyeERUd0d1TVJBNm13Vm9ab2srUUp4aEYr?=
 =?utf-8?B?QTVnaitoZUFTSDFTcGJ3UG8yLzZUUnZTa2V2VjJybVh6aGZEaWFaeWhHWjhS?=
 =?utf-8?Q?OaJVK/WuzsFYvLxRddH/8c3p4upWytJO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0syZWhWdkEzQmY5T25LdVozcW5OYVlQVkFZOUEwTUtRM25qY1R4UjkxLzFK?=
 =?utf-8?B?M0lRZlVXVkZtQy9BQnNZKzIzeUkyc29OSUFtN2d6NC9KaGU2YzVuVXNOMWZ0?=
 =?utf-8?B?MmpTMzcya1MyYVBGM3RyRjdlY1c1T1ZFOFJJVVVCczhFUStpdVhqZXlUVnpm?=
 =?utf-8?B?Yy9pZXN3TFF0bDZKNllQQXhObm5sYWhNRFJiRUZ1UGtpMWNKWXpySW1NN2Rz?=
 =?utf-8?B?b0RYNHR6cDh0d1hLa2tCVWRra2JBNnJJV3VjVkY0M2V0TUpWcjNDeWhsVXBJ?=
 =?utf-8?B?VVJNN0xLcjYrNDV2Rk9SMEVUeUVabmJJTGJWM0EwUlhzd0pPY2o2a0RmOThj?=
 =?utf-8?B?ZmppeUxha2U4TmhnNjEycC9mNlRUbU1nZkhWcGYzZ2t1NlN0Y3FlLytGTFRI?=
 =?utf-8?B?V2RRWVpwVTVmZmpPOGpiazhLNGt6Q0J5eVczMU1Ma2ZlSkNpdnJJZTFrRURu?=
 =?utf-8?B?M2ZNNUt2OGlzZ0FQdXlralJpTXplM1pKM3o2YXZEZWs1NkxHUUJ5NWw2Ukgy?=
 =?utf-8?B?eWdBeFVTVUVZVGRuTGk2VEovM201OHBzMHRlckt2UWRPSlYwLytVTnRIc1ll?=
 =?utf-8?B?aVBMQmhwSTR4NVpoZXRPY1k0bFdyQWF6bFFhQWFRM3h1SkdMNTFITkpQKzVX?=
 =?utf-8?B?UUE5TGFESnFRTEhTb1gxWEtzVHlaS1J6aE01WXlnZVI4ZzU3cS9jQjdWUStD?=
 =?utf-8?B?K0xiT0JxaTU0aHhMS0ZmYnJYTlFnZVFHRWRZNERnWFVxdWZTTXA5dXFEaXV4?=
 =?utf-8?B?VmxwODFZc3NwK1YxNERTNjkyV3pqMnMxV0Y3OVpqcnpYellVeW5xcHpsWWpq?=
 =?utf-8?B?UFJvNFAvM2RVeHFzVEpydks5SU9JNGFBMHYrZ1JheHJyTW9naE51eHJnRVA2?=
 =?utf-8?B?T0JNRDd0ZjdEQ1FQRWd3cE5IZWZNTENCejFzNFpFZm9wMEkxaFFucHoxQWsr?=
 =?utf-8?B?d01kQ3BFWllrSjgzQlFGVnJOWEM4OVppb0RWWnUxY2dpbFN2WksyVDV0VnFJ?=
 =?utf-8?B?QmZkRExJYmIwbVRSaHQvOUV2QjYwczFwT0hmTjBwd05hdkFJbFRuditUOWVL?=
 =?utf-8?B?WWtOQTlvQlp1YWQ3WjVIeG9uR3BSVnI4MWxZNVJ1WUZTUDZkb0lkY0hDVnpu?=
 =?utf-8?B?UExSRVUxWE10UmdQOGUxOUtxeVpPMk9zNkJUSFMrM0U4RWYxZHJlNXl1Nzll?=
 =?utf-8?B?bmdtcFZqYXRQTDhCTlc4bURrWFVWaldvdFNSWGVWZWc5UXZ5Yzg4djZjRWt5?=
 =?utf-8?B?Y1FnQmhVZjBsc0NNbWNUbElRVHFLNGxkSTFOaUlZcFRiVzdkTEhHanFSQUM5?=
 =?utf-8?B?NHNwekpoVEFKeEFZSGJDbDB5a3lHY1Q5VlZFbWczSkRkVGtTRkdjbWNyRTA3?=
 =?utf-8?B?bm9lZkFiRmlPUmRVbThNSjRqM3VsMmxwYzJMaGZwcUVQd0VEVHRIdWxtcGw1?=
 =?utf-8?B?REFLcXhncTJXQ2xucGsyRmhCYlFMcE43QXc3WUVLcWg0UEVrVlhGaHpqam9I?=
 =?utf-8?B?TWxqd1hLYXBaNmxOUEF6cUhZNkV4VVZFdGhOeTd0VXpBWTUvRTY0Mm1kdzFF?=
 =?utf-8?B?NmpRcjFpMHBZN2srVXoydmJaM0FJK0t6TFFrenVGdk8wVzJFMEMyVzlPMzM2?=
 =?utf-8?B?dk90d1RMRmEzZjlFVEtyK2ZUOWxRWUVlMHE3SlllSE5PS2tkcHFLNWpJZWdh?=
 =?utf-8?B?ZFFOci9PemkxWHMyRU81VDQyL1NCcm1RT09PVFd5QUdoTG50UU9FNnZPTFBm?=
 =?utf-8?B?MDY2aFhPUXorSWZ1R1BzMUVBSkVXRU9rbVJEM2NpNm1QbTQwVjFPZk5rbnJs?=
 =?utf-8?B?K3VLT2taVk8ySzUzZmczTG5nZlR4OWkycEtiaVR0WlFWUE9YaWpVNTB4Nlla?=
 =?utf-8?B?cFRFWUJDTTdGRjJodmwvd3FrUGJLZUNsYXJ1dzByRlBNREp0OEZLQzV5dWs0?=
 =?utf-8?B?SDVYeGwzdE9SUndtVHMyMXo5cy8zYld6ZXh0UFBsbVFFdXU4WDU3aDdRaDdq?=
 =?utf-8?B?WmZJUEpBSFNCa3prbVM1VWcwVTFrYURSZXRLRTJ2aCtrZ1kwb0RsdnNBb1c2?=
 =?utf-8?B?dzRMTU5Ld2xDejNsUWh6L1phRC9GN1RsSjhBamVGRnZvYkRwaUdRcjlXbThw?=
 =?utf-8?B?RVZMQ2dRQSs5dmI3VmlDdWdSNGYyUFVTY2dBQ0R0aGdvUkxQVGRKMU9XbUpM?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9c668d-bae6-4521-aa78-08de26138f0c
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 19:57:38.5659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpZT/os3qkth1BHNPjdx9y46kn7Tb5C49sd+i67u+eIevNpeLIciggWP0RTEB2LLDXnGmLkiqsjzMDD4/HA1XCIEvkFtZQC8VHH4DPoYF84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7819
X-OriginatorOrg: intel.com

On 11/13/2025 4:36 PM, Paolo Bonzini wrote:
> 
> While at it I also included a small refactoring taken out of the
> APX series, by Chang S. Bae, some cleanups, and an extra MOVNTDQ
> instruction.

As I'm preparing REX2 support, appreciate this effort! I’ve added my 
review tag for the obvious and nice cleanups.

I can also look further at the VEX pieces and other related bits, and
would like to follow up with test tags unless anything else comes up.

Thanks,
Chang

