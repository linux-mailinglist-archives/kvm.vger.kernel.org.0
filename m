Return-Path: <kvm+bounces-69630-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id Hw0cE/Pae2noIwIAu9opvQ
	(envelope-from <kvm+bounces-69630-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:10:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D0DF2B530D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:10:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E15123006821
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 22:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD6536A02E;
	Thu, 29 Jan 2026 22:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hRmyhWIN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985BA369210;
	Thu, 29 Jan 2026 22:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769724652; cv=fail; b=jiHuHESRjvZWTPkgkHx8bXYLEf/s92biylGexk7oyjmyH76fIIxkE+xuzQYeK/5vKYO/puuRDRyHvOZ+xokmyBKUkCzY/ge8YlatAy2PHei34dXYteYYMi9SZRmxuIhqqMBvIWgxAP7x4rheBYnq8vhmQ2JJLjeNGSqPbF5ehvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769724652; c=relaxed/simple;
	bh=8BiDWkfsgvt4lB+1v4j+CxznBOI2l8l22YhPbirewNs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Y3zYcAhQND2eAFpE/riMtjhQfpH/NUy1oDPQ4kkkir0ZiJdp6WHRTR4m2kpWRgWJSCaMdDNhTDxelNsBXip+a1z9fr5Og8G0gjzMa3NBVB/YOg0zYvi/66EMeLZ8AMfIddVMjO3vnhRIpxwhPGCOHYG5uFVTdSqt+xnE9S608yw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hRmyhWIN; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769724651; x=1801260651;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8BiDWkfsgvt4lB+1v4j+CxznBOI2l8l22YhPbirewNs=;
  b=hRmyhWIN7vGVi4ymb/aZ/im2GKOd7EZsgep+nC8y9i1BLjh7rrc2XNar
   NHPxhDxZpRBwhDxIDxB3yCb1bl8ydV+tWtjt2UWOlMioOt9KvTRIMX/Sj
   iCSJUgxMe9ST9RLQy8Eg1QA6AvRzTmTQYtd1UA8YetxNPmgV6AhydGyLm
   2f9r3n6AJ5/DTZsd2COOlOWmxAGDqjFIccN8MCH6O4R5ynHDJlKXeEzva
   qFqSDDEzH5MXISsaoQJ0BvgMkvEhWX7m+S++pmKEhPHIgArB/9WjoncV1
   6RMd7375+YPKKwYo5PeZeoD2Jq53RpV6pImDkSJ1yAK9amR6QsJRjUNsx
   w==;
X-CSE-ConnectionGUID: 2zvGQnZmSb+zV1VUnNN94A==
X-CSE-MsgGUID: YMeS1CxoQ6CZwCwLjcPzZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="88549590"
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="88549590"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:10:50 -0800
X-CSE-ConnectionGUID: jPuKhGcvSayStz5/g+0eFQ==
X-CSE-MsgGUID: qObaTpIOSNW7o0az3L16lQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,261,1763452800"; 
   d="scan'208";a="212772213"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2026 14:10:50 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:10:49 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 29 Jan 2026 14:10:49 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.55) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 29 Jan 2026 14:10:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a1TwXCtpMvNnNcOh2SqguFb64V/u+UcAIVVz+dvMYkj/ydEfHorn9pEQkhTCQ955qgjh5r1hsE+n+7ETUlmovvtI65VggO/RtCS8urk4lkT44MjI22z3IZ65JPGbi8AG24PwvpXfiHttLQLvYQ7Xl8OL1w8lUSFRKPZfhi6yoKAytn2FrYrb+txC11C9zfuuHf5WSdZDH+9ttXulZ+kjRg3OLIuNskD/x+8jZdHiYUP430HUYdUCOQSHjE7mwm4EPVKeZZKLJKEm3eogXJx9rxfbc9oV0Wt6x11lGnT9wK+nBLmy9799R0EC8uJ0arANiIjigNPNkQTh90IHebgJUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8BiDWkfsgvt4lB+1v4j+CxznBOI2l8l22YhPbirewNs=;
 b=Elwy1jclqnnYBhW3aEVhwn6pw0Rout1lZ81/PZL4BJV1kAN9twxhjU7cTlPEt6qF+GqjhfrnnzuxV2yTuBUcRCznGA81WO3l8aHbM3qUfMPfoIfNFDdNNl/rYMojiFbYh74D77B3CMSX26MBRt6YD8zLSJgwj1Ywt9ZRB79qYmC6U//zUcS8USYVZ+k+z/+OR85cwfts57rG0lRMl0PXg19qs+g/Ld2nxtHttJUVzZqQJLQ7LMGxwxf6SKAx0t8cvNVDP0+JEn95xdBvO3T/ops3BNh2USJRWsVQxzjLLIngphO136SbjMFYYPH66II7tl/QHNBbReQVhygaXf2IiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4808.namprd11.prod.outlook.com (2603:10b6:510:39::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 22:10:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9564.007; Thu, 29 Jan 2026
 22:10:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@kernel.org"
	<tglx@kernel.org>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "sagis@google.com" <sagis@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Topic: [RFC PATCH v5 02/45] KVM: x86/mmu: Update iter->old_spte if
 cmpxchg64 on mirror SPTE "fails"
Thread-Index: AQHckLzJq8v9Vhu8u0ueQ1FsCiqC7LVptryA
Date: Thu, 29 Jan 2026 22:10:41 +0000
Message-ID: <fbaeb0d2f4658efd4c7bb61ac0ba2919c8226a36.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-3-seanjc@google.com>
In-Reply-To: <20260129011517.3545883-3-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4808:EE_
x-ms-office365-filtering-correlation-id: 78435478-b96f-4d6b-2d74-08de5f833e25
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?clEwR2k4R25iN1pneElVVVorYnRMenFxSGZRNzk5QjVKeUpuMEt2VmF3Z0E3?=
 =?utf-8?B?WEVOUGRTdFlEU0c5cUF5NUNqMmJ3UXA0YmNlZmx6STJVZnkxZnBaQlZMTHJJ?=
 =?utf-8?B?VjZYakhENGRZcU4vWjdTTEp0a1l6OTlnR29IQjRGRHNBQlorOVExL054bW5u?=
 =?utf-8?B?djBrS3Jjb3hUNG5XY01KclNtVWxUWjZUNU5Vbzdkem1TbHM1WGRYWnRrUk16?=
 =?utf-8?B?cnZ0QUtRYkVSRDBXSWtDWDZxRTR5eVNFRzBCSml6VlY5WWlFb0VQM0pIRkt0?=
 =?utf-8?B?UnVHWHg4OGIzNURNdUE1OVNuaHdsT3lUSFFMR2JuYmZQSnhRbTFybS9ZbUky?=
 =?utf-8?B?bXdtN3J6cDNsczMxUUE1UWdnU1h0T2ZsUGttRXZ1eU15bkVpeTJ1eEd6S3BL?=
 =?utf-8?B?SHlxUDEzeTFQcTVrRzFKWUk0VC9SZ3k2c2ladTNYZll2eDdQcFRlT2hLZVBQ?=
 =?utf-8?B?UTk3TzVvREpmQk9jelAyWmppUWxJbEJ6bXpJbkZscjYzeGlRenhOLytnVXk1?=
 =?utf-8?B?SDZsU1BCZnJTb0d5c2QyWVpDRUxreTVpdW5oZ0thUjVDQkxNMEhNQjZZaWdp?=
 =?utf-8?B?R21haGdxTXkwUzAwTm9YSllKdUhZdkM2U1BvSzhjMklESkNvRUFWU3JqV2pt?=
 =?utf-8?B?WFdhME9WdmMzNWN2dzMvSmVWV3R2WDdhc09tZzBtUDBhNXRoTnBzbFQ3WVU2?=
 =?utf-8?B?aEQxbW56Tis2Yzh5SkpZc0JTZUpXNFJDdzV3UVd5UGF5MkNubXRRYlB6cXVu?=
 =?utf-8?B?RW9veUxZSzgwSzg3SGhuMzU4anZ3MmhEc0lzRU5rcVNTSVpPbnpCUXREWXd4?=
 =?utf-8?B?V3pTZzR2am5uUitjdFRGMmxqdWZhR1hueTJDVENLUEtyMVNZWnBtZjZBRHRj?=
 =?utf-8?B?TkQrWEZ0MG5vYkhQOFk4R095YXlZZlRvSi9iWlMxWVBGOVcxZGUwT3l5MzdF?=
 =?utf-8?B?bzVEVU9YN2ZJRDk1RGgrRm94amwwQVlxbkRCQmwzOGsrNjVUeE9vMnNGMDBD?=
 =?utf-8?B?ZE5IQUxXU0dtcUVkdFExZVMvR21aVk43UGZJak1laVZIV0hpWVFwYmYrWGVn?=
 =?utf-8?B?YTJpVmc4ZWxHNGozWDBsdmFQbUticDZNSVpwR2tFZllPUTJhQTFoNGNyMjJw?=
 =?utf-8?B?ZEhCRnhkMTcrYkFWZ29qaEZNMnBRek5oSUhtSnc5Ykthcmh3b1g1K3ZGZ3Y5?=
 =?utf-8?B?K1lod2lYZnBSWjRRZHhwY21HeGxGMzFlcVdOcDl0ZHZIbDAyQUdDMm85d094?=
 =?utf-8?B?WjRvbzFIM3dIMVJoOUVkOEsxakJzUXpyNjVrOXU2NkxBVUdGdzdtN2h4WlBZ?=
 =?utf-8?B?dm4xQVdCYm9jeFJrQjFkcXRkYmsxVUtJUTlGa1RvTSt1VWxnSFQzck1LNExS?=
 =?utf-8?B?ZUkwV1dQc1M3SW5iOGJRMGVOQ0lhYm5MaDUraCttN3hWSEtaMVFVZ3JkQmVH?=
 =?utf-8?B?VkRiYUpsZzNJWVpGVlNRSmlUNkpBcmxQY2Mzc2RUYUxnR2pacnlWaU1BVGow?=
 =?utf-8?B?dUZvMFhaWXNWZk5PWXVBUk9rUFdFMHc0MmlYNWNuSHVVRytaMVRWWUtDQVNX?=
 =?utf-8?B?TDJGamtldmcrYW43THdESHR5YmR4eCs5ZjhTYXcybUczYUtsV3d5UUJ1SGZ1?=
 =?utf-8?B?c2liTG8vS203MnBUNjNLZm1GNERjZHBUMitISFhCTVRkUDdHM2xSTkdkL0Zi?=
 =?utf-8?B?c0RwUUFyMTQ4R3pwNDU4Y0hjL2ZSYzFtdFhYWmYxZkFYamxsd3YxZE1HNGlN?=
 =?utf-8?B?Wnc5V2pFME5QaS9hZ2UwQUJTTzRHMlV5UnpyNndHSzZRZUJqaU5GMXhpSnph?=
 =?utf-8?B?UG9rZHFjaDcxUEF3ZnI5b0tQalZlUzdoN0xpQVpUMWtzTExzTHBJSDdERUhq?=
 =?utf-8?B?SVVDd2MwMTh5c0RJSnI0OVJVQWo1TW93dnllS3BUbXEwRkkvNXlkczhheXhh?=
 =?utf-8?B?NllFd3RRYUIzZlk4ZFZ1WmVkRlR1djB0Rytqalpha01xVTJxSUVRYmNjTTAy?=
 =?utf-8?B?aHZIYmVOZHp2QVNmWjdwb2M3U1FxV2VNbTJNOStCWVdSTk1NbWd4UStBMmNX?=
 =?utf-8?B?SmRMZTRleDFQNlpCN2dReGJWVGp5L0VscHBqTWpBREg4SDluZERDTmZUdk01?=
 =?utf-8?B?RVMxcDAwSDlsc3ZtMEVYV2hXekZ4TDVNa24zeU9OYWVqZXRacFBiQVVCZ3A4?=
 =?utf-8?Q?1f1SHTuzwhHOEo1/bNEwmhw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QzRNREJGbk5BNEhOaTM3TFpSUlRCTkVISUROck0xZ2pDcEV4elVBRXpndllG?=
 =?utf-8?B?SVNBcGg0cDB6MzVRUitCb2dvWEdjOXBCT3IxZng3VHBMQzYzK05iRlF1NkRR?=
 =?utf-8?B?TGVSNXNxeWFoWlNkRGRCNmlsVmZabTBxeDNmSUkyS1MrWm1HRDJJaS9XcUV4?=
 =?utf-8?B?ZEQ5cnJLRjFjcnlhQ3krbG5rMGd5cjJXZmUvS2crV2xxbVJxZWI4WVJQOE1K?=
 =?utf-8?B?WXQwbDVZLzJEemZ0Y0Q3bnlUWEZaK1Fvc01XaEx1SE56RmF1QWlMVjZrSzN3?=
 =?utf-8?B?eG9TMjh5enlCSmg1TS82Smt6ZWZEanIrdWpsRTMvSkVOOUpSWjhwUzNpN2dR?=
 =?utf-8?B?cDl2cXU0ejBPbXF3My9iSWlHSktNalFYa3VOZUpFVldMNVRiaXpjaWlMWnhm?=
 =?utf-8?B?UkhUVklYaFNKRzlaVjVxR2I2SDVaUTlLZzIyNXFDdENUeUZncjF5OE1SUVhK?=
 =?utf-8?B?MEtETk9xenU5OW9GOCtKNld2YmR5V3d4YXlWSFcwditXREt0Ri9WZVpZazFw?=
 =?utf-8?B?cjhjaVUwL1RLVCszSytPdmRaaXIyNEl3RmcrRVBvaURnRVNSNjJsUUxmdmVo?=
 =?utf-8?B?MEkyR0RhbGw4V2ZDMjlMVjlnUzVvM1lVTFZ0Y2ppYUQwelBxejJFWjZBMlVV?=
 =?utf-8?B?eldpaUJlY2F0Y2tiNm9udzVhNGtrdUVqYXFzYms2U2VYdUt2T2taeVpCdS9y?=
 =?utf-8?B?aE1HWjVNQVpXKzdubHBaak5DYUFFdktBSmhLNTA1dzIxb3VHQUlUejNUNmxL?=
 =?utf-8?B?RStwd1BMbTAvYXJlSGMybDQ4MXBwWnltYjk3NEJSK0txQzRyNnNtY1B1VTNB?=
 =?utf-8?B?a1ovWSs5bDhIc0NtNW4wUlRDandTbTY2Uk1LcEJQcHJIaTFQY29WSTdjQS9N?=
 =?utf-8?B?TCs3Y2NpVW5mSGg4ZHFQZm1BRTVqMG1NdXNLbjlYOG1UQmh6N0tNMTdCSGZR?=
 =?utf-8?B?dm1QQzNYRnlEay95STByUFQrc0xvQ2M5SER4Yy8yRDhVUUV0TGtTaXhWRTlB?=
 =?utf-8?B?RC9tbzVoNEUrcG0ycjJwbWJaYXVWV0FNb21kdHlDcXNzamRTMFh2aXAvNjJH?=
 =?utf-8?B?YkgzUGs1b0lNOGNLRVM4OGQvZ083RXBjMG05UGc0UVMzOVdpTmdOc1MxTklN?=
 =?utf-8?B?N2lxT3g1QWJHaTRKM2U2aURqWkl1WlM2WVNsbStVVW16bGxnR2hiaWw4cDhn?=
 =?utf-8?B?NjFUYkJwSC9DNk8ybmZqdENBa0ZzK2JCck1TYmFyUGp0OTlUTE0xY1Z5Tksr?=
 =?utf-8?B?dnpWaWg5WERvRW1rUnd0YUwxZ2MxS1Bva1hIT3huVC8xUDBvNWhVMXV4UXRr?=
 =?utf-8?B?WmpDNEpnTmlnRkRVYi93Ui9ISVVDWnhDZnIvYkFkZ2pVVkRtUUlaNzlhQjBP?=
 =?utf-8?B?VkEzbDRWdGRlMlRCRS9tb3UraGVJZU9veTVISStUQ3gzaDlmaXl1SHc2bFdQ?=
 =?utf-8?B?LzRxYWg1cUZkaWlFcnI5R0ovUk51d1U2U084Vm9ieFFhMmRvUnZlbE5DeHZs?=
 =?utf-8?B?UHRJbitiV0owSmttSFRJVlh4WDlPY0lldFFFNUNxSk4raFViSlRoMVRZVi9S?=
 =?utf-8?B?SzhNUnNpUXJxQjBQcHpmMDNRVFRYU0hKWHN0NkI3T1lvMnVoSkwrcWpVaWJ6?=
 =?utf-8?B?YlYwWkN5K3lFTXovVFppOEdLc3dGVmw5V3V3N09VMHdodTRlVk1kdzZWanli?=
 =?utf-8?B?cE9tZzZBZmZOcXlJMm5NejJjOEpsaWkvQVRrTzlUYlNQMFlZTWFSSUpaTjUz?=
 =?utf-8?B?T3FuUXJyNzdFOUhUUnJtM1Z4bkpqU3RPWloyTW9sUlBYeDNBckFEZEphYkVk?=
 =?utf-8?B?T1dDTnFHa013NFp0MFhkZmJvTS9TaFhkZnZiZG42dzllSDA0WXhHOFhnSCtn?=
 =?utf-8?B?bTZ5L0hvZW5aekxLYVphS2lXbmVTQmxkd3B1UXU1Z3ZzRUZVZG9FcnlsbGRv?=
 =?utf-8?B?ZG9qSUVoQzYxRmZxUldaQ2ZQV0RPZ3dycTA5dW9zdk5TOHVUS2JPT0JuM2Y2?=
 =?utf-8?B?MHNSS1ZTMytEUUJXZGJQYnZmeEo2NkdUK2JaUnBKRERyMEhnVmN4KzJWWm9C?=
 =?utf-8?B?VXU0anRlUTJsakVpbTBFK0psakpvNGtySGRpZ2NzbUMxWHZtMmZESnlHaFZW?=
 =?utf-8?B?SWlmTjJiS2VhZ0lNRERMMFhNWWNxY0JKb0RIV2M1NjNEZk01bHAvUjJtc21a?=
 =?utf-8?B?S3kydnB6R3JLZWtBRG5PbzRxTkE4MEF4UHBtRTgyaUFBKzBHOFBYYm5tN2k4?=
 =?utf-8?B?ZnlXZlduZFVXV1lYREdDZHlxaG1sOFAwamNNWDk2cWZQN3dyVFQxbTZmZzl0?=
 =?utf-8?B?NXdLWk9mbkJkYjZRTTRabG4xUjdPc29kOEdVZTZ3ZWNkSERzM0QzMlQzY28w?=
 =?utf-8?Q?rcbnCGh+s3JrGHD8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04FA4C4BAD91344BA98F1A24B2C37FBB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78435478-b96f-4d6b-2d74-08de5f833e25
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2026 22:10:42.0869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3RbfKx8JETvM04gF5X9LkJTI6YtINhcZGky+w9E8lnPpmtC/+vFMu36chQaAaiQdz4yrCviQHbpeXR8w14xBAc17aTWp6HmrVAi5Qz1h6Xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4808
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69630-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: D0DF2B530D
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE3OjE0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBQYXNzIGEgcG9pbnRlciB0byBpdGVyLT5vbGRfc3B0ZSwgbm90IHNpbXBseSBpdHMg
dmFsdWUsIHdoZW4gc2V0dGluZyBhbg0KPiBleHRlcm5hbCBTUFRFIGluIF9fdGRwX21tdV9zZXRf
c3B0ZV9hdG9taWMoKSwgc28gdGhhdCB0aGUgaXRlcmF0b3IncyB2YWx1ZQ0KPiB3aWxsIGJlIHVw
ZGF0ZWQgaWYgdGhlIGNtcHhjaGc2NCB0byBmcmVlemUgdGhlIG1pcnJvciBTUFRFIGZhaWxzLg0K
PiANCg0KTWlnaHQgYmUgYmVpbmcgZGVuc2UgaGVyZSwgYnV0IGlzIHRoZSBidWcgdGhhdCBpZiBj
bXB4Y2hnNjQgKnN1Y2NlZWRzKiBhbmQNCnNldF9leHRlcm5hbF9zcHRlKCkgZmFpbHM/IFRoZW4g
b2xkX3NwdGUgaXMgbm90IHVwZGF0ZWQgYW5kIHRoZSBsb2NhbCByZXRyeSB3aWxsDQpleHBlY3Qg
dGhlIHdyb25nIG9sZF9zcHRlLg0KDQo+IMKgIFRoZSBidWcNCj4gaXMgY3VycmVudGx5IGJlbmln
biBhcyBURFggaXMgbXV0dWFseSBleGNsdXNpdmUgd2l0aCBhbGwgcGF0aHMgdGhhdCBkbw0KPiAi
bG9jYWwiIHJldHJ5IiwgZS5nLiBjbGVhcl9kaXJ0eV9nZm5fcmFuZ2UoKSBhbmQgd3Jwcm90X2dm
bl9yYW5nZSgpLg0KDQoNCg==

