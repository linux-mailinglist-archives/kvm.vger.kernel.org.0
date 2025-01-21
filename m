Return-Path: <kvm+bounces-36184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E930A1861A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44003188BA0A
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C3AF1F76AC;
	Tue, 21 Jan 2025 20:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ffQ7udEb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305FB1F543E;
	Tue, 21 Jan 2025 20:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737491105; cv=fail; b=LChSax8VjJ3hmQ+6ml4I9QA7K0qjsr2pXk9D62N6yI36cjprN3pqxucoDYgf62xLmtbx9eJRziWqI72lVAQTZzuAOwGPhZMt3dgQeoZAkFqpM2Ak8WUNZbc+fDjdp5LsifMPS+FVyHTUQYaDBTGmtCUzgWQaaBY1Pl8hxTFmtyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737491105; c=relaxed/simple;
	bh=FvKUKopObPucdgG28NcnIS4lPHedMOEwlfE1TQaOiao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VH4WrjkIlwy5mSDIfSkK2xM75v7KK8bRQacAvWj1qMSqnyHUnrxoKhZcM2114oQsTvJGR2O2UIHirdARcNFAiGdPQvmaRRGnsMNbje57sR6RU+hNWpcQVIi6Uqnng0UNivRyxqz8j5br0b8eTnu+b+l0DzgzeuTJ8Nycem0p8h8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ffQ7udEb; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737491103; x=1769027103;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FvKUKopObPucdgG28NcnIS4lPHedMOEwlfE1TQaOiao=;
  b=ffQ7udEb6mlwmstfWadVshxEbEHwvneaTvNUpjyQQ/Lto0M3cOfTWp9x
   AVDjubiCqRz1tK20N4fYKauknxmCD5iw55hAa6UY0jU9kGwGZQ+T2KTY3
   EbkDefHXo4Y9NKzSc60pY7pU03302hSfuvHjGedzFJQHzAmPGgx6Fx63M
   S70i7qrsUHTXf5du0d1wI8cxUzqVISj5Eiu9MTUckhQv48MEAAzD6U9Sk
   ey7UBCLD9EYQwcOX+WRKnris0Ci5ZxJgGJJD/O5eMfSHfXT9kbcOJySci
   2SYEQSf9VzlRSsajJCkLyxsRn1918M6FmCr503u+QcRsD19YbyJdFmUoM
   g==;
X-CSE-ConnectionGUID: YScQrYPjTja0kZKhFpHXMw==
X-CSE-MsgGUID: 0eF1iQSxRw6uHGjnSINB4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11322"; a="38172618"
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="38172618"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2025 12:25:02 -0800
X-CSE-ConnectionGUID: R6xepVnwRFenXVADjCdJwA==
X-CSE-MsgGUID: jWc85wgQRiuftu8+Oh4XiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,223,1732608000"; 
   d="scan'208";a="107455555"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Jan 2025 12:25:02 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 21 Jan 2025 12:25:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 21 Jan 2025 12:25:01 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 21 Jan 2025 12:25:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HBvNEliQIA66h5GXAJ5vixJ3MB270HM+lgIMBtz9uHG19e6pHRswdOeQwifBYaoZW3VitvbuBmcTDLxil1t92KeLQOk/eJZK6VuavOFpsKRLGYv85kZWq1Tacp6g7N26rPOFdux+8Daef84KJ6TxFeG2HjgX3w74JFRQN2x3vTrD4FXX2cDgTaLCcJ/ajYl6+v6gz+GgW1TOtJp6blaPPX694//urigTjxuH3PDUUVlwa3PMPVWiqBJjNwz5NJqsMK200It6Gdgaw7ouujkV7TjI5O37b0KHWQlRfNV24AT4ynvdZeSQCd4marb5GkfKGdTeSmuYUoIPLjVFT2/r/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FvKUKopObPucdgG28NcnIS4lPHedMOEwlfE1TQaOiao=;
 b=rrxY607RVxMpR+i63+mVynrTdDlxFpX6Bc0GmJzSURvEnbO76yEs/E4vRpp6pyYcLiFiqvtJAnDE8HDuAzuhvJzNNeXyTqiVh2YYpS9RiIUgWeS51nls3W23fJ0tPv+DdOsWFLNTVZuTY0cshmcyKQ7rA318M139GetKOUG+TfbiOKGfkvWDSwnChOys3HgvqXQpROcq4dJvgNoB55hV/PZoOqkuldsYLUj6Zo/pHOVk3HH4//++9ZZ1prosnmY+THPFjUhsYDm1PLp9E7iHljb13hMq29exQfIdBTe1UkSTijmOa0hRGTkdE0KvPn/MVzHmBYdurzBuMZxvlM3+2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5913.namprd11.prod.outlook.com (2603:10b6:510:137::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Tue, 21 Jan
 2025 20:24:44 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 20:24:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHbKv5FM3B1aLjYHk6i9GmMdsvqorMP32yAgBJPmAA=
Date: Tue, 21 Jan 2025 20:24:44 +0000
Message-ID: <2227406cbc6ca249c78e886c301dd39064053cc4.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
	 <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
In-Reply-To: <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5913:EE_
x-ms-office365-filtering-correlation-id: f770ab4b-2500-4db3-157a-08dd3a59a4cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?M0tFZGp4aFI2M1dBV1lWUGR0c2JIdE9hclI2VVByb0pWb2xiZHdPM05IR1Z3?=
 =?utf-8?B?QU9yY1N4OGFZOTFCY2VIcktMdnNTK0kvdFk4OG1XeXJudCttSndxcGcrdFdp?=
 =?utf-8?B?ajBRNmZOM3BDR2tXNGFRcTNWZzJ2dWUyQ2l5WWQ4cDlYTmhPV1RDbzUrWFBC?=
 =?utf-8?B?TVExK3JHdlJuQzVONVJRZE0yZEJadnRCVXYvK0dkVG5VSURMVWNDNUdiM2x2?=
 =?utf-8?B?UlFDaUF1SUt3SS9TclVHc2cwT3hBelJOc29pSElZcEgzUVdCQ3JWRitwTFp4?=
 =?utf-8?B?TGZTTHphb3RZRG1yVWN0aWMzRXlldit2WGxaRUM0MzVpK2FmcDdQWjhwNXN4?=
 =?utf-8?B?eC9lT0Ztb0VPK21mS2tvYlVvZEtlNi9yekdUNUdJcmRFam01QnorNlFWVThM?=
 =?utf-8?B?bGF3aHdjNksvemEzcDVMZURhcy9BUW92OUxhWTFLWEtnbC8rU3lWZXBSNXlB?=
 =?utf-8?B?OHQyS2xlRHpJcGFxT1pWSnJXU3VtRW4wZ2pab3BOR05iSHExZkRhUlhiQVpP?=
 =?utf-8?B?L05XQmhuWnU1SlZvaWdwYjFxSXp4WnY0NDBWM1VSRENjSGhVZ0FWMUJ0dmo3?=
 =?utf-8?B?NExSNU00RDV1OC84UVlidWsxNmF1Q21RS2tBcG41UGgyNXFwQW5tNStFcjEv?=
 =?utf-8?B?Y2NseXFtNGkxWGtMY29CbklQbEFJeGlQN1FDSVdCWFN5OThJYWZsWnR4Zk1i?=
 =?utf-8?B?RlRwL0Q4UUVVa2FOeS9IWEFlUVRZQ1NUclFDUUFVMGIwd1NUR25wbUdQSjVF?=
 =?utf-8?B?MlhRWjVRMHdsL0lxLzRHZU5GMFRnNHk3RnVvMWF3bFZVcjFxa0hZbTFwMEl5?=
 =?utf-8?B?TUJwNnZpdnh5b0p3azYxcDc0Ry9uNVFNaE9rK0tGNnBrZHR2cDBWQVhoQlB4?=
 =?utf-8?B?b01kbTlLYlRWR0hHM3p1azZvSjJYMVZ4eDZKTERQMEhOdXpTaTNWcDQ3VlBs?=
 =?utf-8?B?YVlLdHZzTjRlWTFNQmtROXdTQ09zUnFWQTd3RTNydzdhWFJ0YzBqaHpJTG5x?=
 =?utf-8?B?d3NraE1xdFFUM2llRFhMa0tRQmNrb1owNnUwN3hFS1M1QnhDTTAyakxVSU1H?=
 =?utf-8?B?S3gyMDRrMlJLSWpMbjBmL2JaY08wOWlzaTVGK2E0L214MytKNERTRnNUNnFm?=
 =?utf-8?B?dUhyRnJwSDFXaHViTVp5TlAySDRwRUpRUmppaDQzb2dtcUgwa0x3Y1I3T1Qv?=
 =?utf-8?B?UXZJOXJuUzAxOUlRM2xpT1lnTjJmNDl4NENqSk9zTnRUek13U0Q1VHlDeEc0?=
 =?utf-8?B?NHNEQ1RCYXE2WVh4VXB2czZYR09XMi9sL2JJRm05TUhQMUU0OCtvV2kzb0Jm?=
 =?utf-8?B?SFVDUk1BUHQxQWNTYTdYZ3pYbUFzeFlzTkJoelc5dW5jZEtqRHg0eG1xRWF6?=
 =?utf-8?B?TDJMMFdXanVTQ2x3SHl6ZW5YVk00UHNQeXBjRlg1M1BBOXdwSlpRcUJtR0or?=
 =?utf-8?B?cmtJRk1mMDh1YytGK3JWdjh6REZ1SjFuOUk3b3BEY0xjZ0pPbkF3WUt1eXNo?=
 =?utf-8?B?NHdRclhZWVJvVjNQNXQ0MlRNMzdqa0QzQmlTaEF5clEvRjJsTHNCcjJiOGlR?=
 =?utf-8?B?SmhGUFNrU3BNQ2VTV2E0U2Nna3ZiSi9YYndqNml3YlUvNzNVOFd2SkNxcDVP?=
 =?utf-8?B?c09ZL2ZrWHpPVTJXaW1Jck9ncXNzYXJjR2N5TjBKaDNOeTFxdWxxajlKUzk4?=
 =?utf-8?B?aG1iczFDNDM2aUNSb3dCV2oyN0swdGdtV3VUZmhiVU5ORk5lREVBNXMxcHFF?=
 =?utf-8?B?S1hHSlVSWVI1T1Y4MWFlQVI0elhiNFBKZFBVYzYzWk9Ocmp5d3YvQW5EckFI?=
 =?utf-8?B?MUZ0bnRUYjZCZXhnM08xNG5vQ3VzYjhjU2R6a3ZyZENHYkM0dndZU2VIanlw?=
 =?utf-8?B?bnkxc1RGcXpPNW1EL3gyNU0vb1B6Qkl1Z1NnSG5UOG9uNERFakNPcEZkMmlJ?=
 =?utf-8?Q?U/cDD5K0rAUCO9LML5NovjskH64Ng1cx?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SnRuZjB3L2w2VWpUaVFWWUF4M3ZMQUg2NHhnQ3BWeU01SFVnbkdZWlRDL2k2?=
 =?utf-8?B?WThPRkdzcml1ZUV5SmZRVmpJaTV6M2M3SzJpQTlZME5iMTFRSUUyTDBMa3Qx?=
 =?utf-8?B?NWs2TU43cnhrazRtMVptKytYeXMwZjVwTEZzL0dMQkdjaTZubUZBL0VKcmdy?=
 =?utf-8?B?TUoreGlKY05pRHovS3o3cHNvNWpwc2R3RlpqVXFTczB6VkYwZlhtczZlOUZv?=
 =?utf-8?B?eTl5cUdyVjQxUXM0cEFrQm8vaXZUd29EMDUyTWhNZ1BGVy8zUURhVURkYkVP?=
 =?utf-8?B?ZzBrd1Y4dHNNdC9IbFgxRTFtN25tKy9VTTVldlFhZGNoazlVWVBmOFB1NHRB?=
 =?utf-8?B?cG81NXYyVTBSNXFKNEVScHlCamRyMmNnVTRMaytQVDM5MURXcmhkQzlXOGtH?=
 =?utf-8?B?TjJxZG90NXdKdGdON2JBS1NsZVRjVVRoMFBDMkJlZjdUcFJ6WGNEYjFMcHB4?=
 =?utf-8?B?czkxQTIwcVhjdzNzWDVXNlN6WDRYaTJCQUxkZTczSTZWT1Nrb0V6M2ErRWg3?=
 =?utf-8?B?alJvKzN2NnFnRFNZcHZtZXNwdXg1OHFvSEZwQTBhRnE1d3MrNXN3UFpsWWFz?=
 =?utf-8?B?RGtTd2NVWDFuRmVOZlp5dnpmN0dEMUlHR0lzL0ZnL0NZMjBhaVZQZHlXcTNR?=
 =?utf-8?B?czl0YUhzeDdESXhIZHh2SEdVa3BSeG5rOHJtZExYT0J5QjUwTktCRXdpRmpK?=
 =?utf-8?B?TmUzNnYrRmlzWmF0VFNVQjF4K3ZITjBzM0lmaEgyNVlvOWcxVk5ENGpDOGNo?=
 =?utf-8?B?cXpYUDAxVTRSeU5XUFJHT1ExWmhzOGlMUUUyQWR0VUZMeDE5dkJYU0xxcHhh?=
 =?utf-8?B?S0wyRjNqeGRmZFdFdUhQd2hYeDZyR01NakVWOVYvOUxJcU4rZU5PNmdOYURI?=
 =?utf-8?B?NDlLeHA1b1NuVXdMSy80cDFjSDhvOE5OQUtZNThBU2ljekwxUVlITG9ndk96?=
 =?utf-8?B?SWRMVVRrMWoyL3k1cGw1MG54ZUJjekVzRHllcUZodCtoY3pjT1g1R3ZtQ081?=
 =?utf-8?B?Z0FSUEQ4bWxydmEwbk9OaCtIcTJ0aVRURUNLSEF6OFAwWDNoSUd5MGE2T3JT?=
 =?utf-8?B?WkRhVHFBS1JGQWduMWdXRnNibStUY1VCRk4xUFowNTdVdVljcm9mRlEvaTQ1?=
 =?utf-8?B?S1U5bGFwUUd1SnVIT0JabFhOVzM2b2ZxYU9SaEo2TW1TdmVKSkdPSGUyVkhD?=
 =?utf-8?B?S0FxLytRakE1UWVUejluRkJmK2VGQlg5alJvNzB5aWpDNW43RWVjdFBibjkz?=
 =?utf-8?B?V0RkdmFRUFI1YTRNWHBqSU9WM2VKM1pOUkFuZTJDVEF2M2tWdGpidi85cGFU?=
 =?utf-8?B?aTFVaTRBSzdtVzhlbDJSUytSZkVZY0Y0TVhRZW56M3RCNW02bERVREdpVEpP?=
 =?utf-8?B?NldHTTRXZzFYOHVaYnAxSGd0N1FkRUw1ZkxDNjhCeWRTVzdJMklXZllGWmZD?=
 =?utf-8?B?d0VsME8xVzNJdVdjZjBqR2k3Ym1VTmREQXdwUDhTZXMxNnhlWWRrRlNzSEto?=
 =?utf-8?B?ekxYUis2VWFVa1B4dDYxbEZCM3A2aTIxQUMvczZkbzBCbUFpZGRzNVltZmF4?=
 =?utf-8?B?Rlg5UE81SlRXckl0cCtCckowV0lZUFNSSStzODZKM2NOektYVHJMZmtVMTU4?=
 =?utf-8?B?dVJmdFM3ejd3dXV4Nnh4NFRpM21XbldJTHBFZ3l2dWZ3ZTVSbmdNTWxjY0l1?=
 =?utf-8?B?RllwR0VCcjgvdUFzQlMwdGFYYmhsOVpxeTNQeWpwOWE4NENqNE9rSzBzU3BK?=
 =?utf-8?B?MGlXVWRJMk1MT2dTMHErMmNsa3RzUU4yNGN1eXV6VUlZemZ4b0J5d0h3Umwz?=
 =?utf-8?B?dGtSVjBXazNrTDg2d2NERE5TaVZNOStQUFBqTWF0bExQaTBQVzFTNXJlRXZ2?=
 =?utf-8?B?akFmSjd2U1h6NThpSjI1WXJUMURDK3FzVUxraExreWxFZ3BrN2d5M3B2K3Rn?=
 =?utf-8?B?Q2o2RC8zR2NTKzVEQThpNktjb2JzSU1USkNYT0ljMVFkNEw0SmlKQ0phOUNO?=
 =?utf-8?B?T05hc3ROY3NvYVQvRlV6OVdXUkxHa2NZK1lYb1VRZy9HUUdXdkh1K1pjMWpL?=
 =?utf-8?B?TThJVldHUzI4czlOV2FPOVFFbW5KNEJwZUdhSExMd2R6SXgrNHArMTRlcmtB?=
 =?utf-8?B?bytsRVZVNi9YcnZQU3hYbisvcjJMUlNVZi9kc3B3TmpNUitPaTYyTzNFUmQ0?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1D441CFF3C0A54484E3F764C1CD178B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f770ab4b-2500-4db3-157a-08dd3a59a4cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2025 20:24:44.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u4cQM9k3oSQVioBUZTapde1O3OmtJvGlGnxSxfTRZcQCTg8VJ63Ofo94DfIPRTX+j08DNHuO6HPr6LUuBmX6zmw5QvOruQV8oqFQ9bhdGeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5913
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTAxLTEwIGF0IDEyOjQ3ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiAw
eDFmIG5lZWRzIGNsYXJpZmljYXRpb24gaGVyZS4NCj4gDQo+IElmIGl0J3MgZ29pbmcgdG8gdXNl
IHRoZSBtYXhpbXVtIGxlYWYgS1ZNIGNhbiBzdXBwb3J0LCBpdCBzaG91bGQgYmUgMHgyNCANCj4g
dG8gYWxpZ24gd2l0aCBfX2RvX2NwdWlkX2Z1bmMoKS4NCj4gDQo+IGFsdGVybmF0aXZlbHksIGl0
IGNhbiB1c2UgdGhlIEVBWCB2YWx1ZSBvZiBsZWFmIDAgcmV0dXJuZWQgYnkgVERYIA0KPiBtb2R1
bGUuIFRoYXQgaXMgdGhlIHZhbHVlIFREWCBtb2R1bGUgcHJlc2VudHMgdG8gdGhlIFREIGd1ZXN0
Lg0KPiANCj4gPiArCQlvdXRwdXRfZSA9ICZ0ZF9jcHVpZC0+ZW50cmllc1tpXTsNCj4gPiArCQlp
ICs9IHRkeF92Y3B1X2dldF9jcHVpZF9sZWFmKHZjcHUsIGxlYWYsDQo+ID4gKwkJCQkJwqDCoMKg
wqAgS1ZNX01BWF9DUFVJRF9FTlRSSUVTIC0gaSAtIDEsDQo+ID4gKwkJCQkJwqDCoMKgwqAgb3V0
cHV0X2UpOw0KPiA+ICsJfQ0KPiA+ICsNCj4gPiArCWZvciAobGVhZiA9IDB4ODAwMDAwMDA7IGxl
YWYgPD0gMHg4MDAwMDAwODsgbGVhZisrKSB7DQo+ID4gKwkJb3V0cHV0X2UgPSAmdGRfY3B1aWQt
PmVudHJpZXNbaV07DQo+ID4gKwkJaSArPSB0ZHhfdmNwdV9nZXRfY3B1aWRfbGVhZih2Y3B1LCBs
ZWFmLA0KPiA+ICsJCQkJCcKgwqDCoMKgIEtWTV9NQVhfQ1BVSURfRU5UUklFUyAtIGkgLSAxLA0K
PiA+ICsJCQkJCcKgwqDCoMKgIG91dHB1dF9lKTsNCg0KU2luY2Ugd2UgYXJlIG5vdCBmaWx0ZXJp
bmcgYnkgS1ZNIHN1cHBvcnRlZCBmZWF0dXJlcyBhbnltb3JlLCBtYXliZSBqdXN0IHVzZSB0aGUN
Cm1heCBsZWFmIGZvciB0aGUgaG9zdCBDUFUsIGxpa2U6DQoNCkBAIC0yNzkwLDE0ICsyNzkxLDE0
IEBAIHN0YXRpYyBpbnQgdGR4X3ZjcHVfZ2V0X2NwdWlkKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwN
CnN0cnVjdCBrdm1fdGR4X2NtZCAqY21kKQ0KICAgICAgICBpZiAoIXRkX2NwdWlkKQ0KICAgICAg
ICAgICAgICAgIHJldHVybiAtRU5PTUVNOw0KIA0KLSAgICAgICBmb3IgKGxlYWYgPSAwOyBsZWFm
IDw9IDB4MWY7IGxlYWYrKykgew0KKyAgICAgICBmb3IgKGxlYWYgPSAwOyBsZWFmIDw9IGJvb3Rf
Y3B1X2RhdGEuY3B1aWRfbGV2ZWw7IGxlYWYrKykgew0KICAgICAgICAgICAgICAgIG91dHB1dF9l
ID0gJnRkX2NwdWlkLT5lbnRyaWVzW2ldOw0KICAgICAgICAgICAgICAgIGkgKz0gdGR4X3ZjcHVf
Z2V0X2NwdWlkX2xlYWYodmNwdSwgbGVhZiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIEtWTV9NQVhfQ1BVSURfRU5UUklFUyAtIGkgLSAxLA0KICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgb3V0cHV0X2UpOw0KICAgICAgICB9
DQogDQotICAgICAgIGZvciAobGVhZiA9IDB4ODAwMDAwMDA7IGxlYWYgPD0gMHg4MDAwMDAwODsg
bGVhZisrKSB7DQorICAgICAgIGZvciAobGVhZiA9IDB4ODAwMDAwMDA7IGxlYWYgPD0gYm9vdF9j
cHVfZGF0YS5leHRlbmRlZF9jcHVpZF9sZXZlbDsNCmxlYWYrKykgew0KICAgICAgICAgICAgICAg
IG91dHB1dF9lID0gJnRkX2NwdWlkLT5lbnRyaWVzW2ldOw0KICAgICAgICAgICAgICAgIGkgKz0g
dGR4X3ZjcHVfZ2V0X2NwdWlkX2xlYWYodmNwdSwgbGVhZiwNCiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIEtWTV9NQVhfQ1BVSURfRU5UUklFUyAtIGkgLSAxLA0K
DQo=

