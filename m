Return-Path: <kvm+bounces-32721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5B739DB1F2
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:34:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4ECBBB214AB
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:34:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03DA9126C0D;
	Thu, 28 Nov 2024 03:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZzNtrrwE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7362CAB;
	Thu, 28 Nov 2024 03:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732764872; cv=fail; b=C78oOzdcnOewc21YiwLsxhXrFPW4h/IdcyLJFuIYf8TdRufSlN94vJdsTTBna6teOLrXjlkKhZ2LCxQhxY/o44gKgJERszYNVB4jJ+10b5RtyMpXIeOXZdOxErcNIu0jSnQjZGtybAmUkEcYodVmDdPLuALmTnmYCyHTd79NziQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732764872; c=relaxed/simple;
	bh=QCBzq3pFfSEhFfJ425vfl892XdIIPbxoxLrSWXr/q4c=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HQYz3ysSqYS/flS5Vr5/dIKCkUogFu/Cto/0N8hWkL+z906Sjfcmba6MyuEEhy1XtnbOx2YwY+f/PL45im9VjdUZ/Fa6Vm/UcGQAtpWf0vntaVmPRWUO4BBBXvqzktB1YUYrmcSZndmBc0etD2BMHOBoxGPe6XP0A7vFGR50dGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZzNtrrwE; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732764870; x=1764300870;
  h=from:to:subject:date:message-id:references:in-reply-to:
   mime-version;
  bh=QCBzq3pFfSEhFfJ425vfl892XdIIPbxoxLrSWXr/q4c=;
  b=ZzNtrrwEXVPa0b3ZWypYzzKTObHWtyjfLf9TZlHQTfY08hdWTIkGukcJ
   daYHj96TtvSLbvVgr15hQihMe0COejqQx1jE3LXuzA0qEZQSRRICD63n6
   Y3pN7TNHkNn5xgatZo8eG56RXTbumC62AUq4cET/07LTN1sulvQu2zhsu
   MjsDbzO6Wdr3PihcssQvcvHgjSEfUexr10X2KofuEY4poJOhtV3jI8EWW
   Z/y6sVkkZq1UO1zKqJ5njS+pc7XNnkIGAHgG/qa/hxlbOWaf7OrUWInhr
   yNL/fSGzYpwTHdJ53qdz31Vn1pGrQxL4R69jYwM2fBg7HPaaEHjp5fTVm
   Q==;
X-CSE-ConnectionGUID: Ns45ystaRWmt26lX7WuVog==
X-CSE-MsgGUID: DvLEs3K+SpOWs6L1qji4iQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="32935648"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="diff'?scan'208";a="32935648"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:34:29 -0800
X-CSE-ConnectionGUID: MtfoN3EOREaXesKcR+7w7w==
X-CSE-MsgGUID: zZvkAd4MSFuComfZYNbvoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="diff'?scan'208";a="129624424"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2024 19:34:29 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 27 Nov 2024 19:34:28 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 27 Nov 2024 19:34:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 27 Nov 2024 19:34:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ba7R55yrH5ntKjN5FibfV4eh4qbRRsxGyQQLRm/Wty6ILkagyJs+flusJLw27TI6O0e11NExBvf+SBF1j0n5RX44DOZkKZ2Saez5F5450GORXG8FiYN0viHqonP/M68ARM25utB/zdJtBjT2v3H0XKuus2DEeqHFd0vr4P9iCbzM7bYvHyQhBy1cAaYsmOeg/9vBYjHzx5zeYlgGRUqSgGY8BRtil0EvlUY9WgdQYqnZLDweqZUpbc8gOldi+pMgNDnW9pYEGdF2AiWR832EXVfNZtaJTcg2m/LBn2H6fp1RqYBTFTcXEBE3I4P/V2G4j6t7RaWgywWtIylnqF9pnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oJRIQpnzY/lh+RbfbN6OySfAthks2Rf91W4hgct/wQ=;
 b=c8dC0u54obYG2WBOT8Fh0WL3wMrTDCbd7NKSCLwdIoqFeWBqRM7Tmn2n/6m0zCLFLIz/Yjw4nGM6FhsrYAHRp0R4j+5ylXOUTNOrqUKFiZO07XQghnnL9Vk/Q4MkW1TMQEYQ7h9e1aBBH76Mfk8Y5ewBA0rs4AUptWWmLlRQR2EBAt4I9GBZGsf2vo+z1bM1mIByGcCDil3ynEgvKd7IVzn8czlh1rZM4GgO813lLtlg00aWVnLpAiwTt2r30qTSzu2uZm8/rp5lYOrH3IS2/cuTGk0Jh2ESdhRSf6d5TxqB2Jy6Xoy+EU49ACU9CWlNunLMvrnaKWSgcwZXCxBBSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6709.namprd11.prod.outlook.com (2603:10b6:806:259::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.20; Thu, 28 Nov
 2024 03:34:26 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8182.018; Thu, 28 Nov 2024
 03:34:25 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 3/3] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbQQh4pHKqsDBLVki8PZg9/3tBMrLMCrsA
Date: Thu, 28 Nov 2024 03:34:24 +0000
Message-ID: <7109da789f52dac408f1fb9e0440ad418af6e3ab.camel@intel.com>
References: <20241127201019.136086-1-pbonzini@redhat.com>
	 <20241127201019.136086-4-pbonzini@redhat.com>
In-Reply-To: <20241127201019.136086-4-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.1 (3.54.1-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6709:EE_
x-ms-office365-filtering-correlation-id: d3c3293d-57fd-462f-9c3a-08dd0f5d8e49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b05vdW9kdHpJQW5MQXhmTjI2VW80N3Y5Q1hwbTNESDFZVzRlcXJZRmEzUVV6?=
 =?utf-8?B?OStiWkZlVUp6dDZFWHR2ZlhFV1YweXVGQkNvSWZqOWtsN1VRSmlheUJ3cG9T?=
 =?utf-8?B?SERiSk5XT2dRVTkvamhIaWpCdXovOGFjY1RNVjU4elhHVGdxNFVzWEo3N0Fw?=
 =?utf-8?B?SHh1RXpwbk5KY1l1c0JxQWtqYXhQOWYyME93cFEzREhHd0Q3ZzcwRTZ3eU5N?=
 =?utf-8?B?aFlrM3huMGZZY3hYWlY3UnlhRWorbWxMYkYwKzAxVVhzaiszUGl3cVVIdFhQ?=
 =?utf-8?B?R3ZpMDRzKzhoTzZTOU5mYnpTQlJtM21aOUdDaEZ0R2pKT3BEZnFXSzQxYXJ2?=
 =?utf-8?B?dmxmQktrRTZmVTNMclluc0dWK3FLdmtYRTZQMFNNSHJOMUVrSHB3RForR3ow?=
 =?utf-8?B?a29oQ0VXUCswZU13UXQwMVlVamduRlZOWUhrVlorRmdHSDNwa3hvb1psdTdI?=
 =?utf-8?B?dlppSmdnUU5aNlRyc29RcE9EampxaSs0b2xXU2lKdDNsR3prMWhpMThab0ZV?=
 =?utf-8?B?eVAxeVFRenV1bCt3Z09kMXNld3cxVWlhUnkvR3Z3MFJVMXdadEplbXNFKzRj?=
 =?utf-8?B?N0l6SDlNUytWWnNBVnppZnNaK2pXZWg1OHpVeWpqZm90eklJQWs0OEgvaDRP?=
 =?utf-8?B?cEZQNmlpL01ON21Vam1Db2MwY1FWcTNGVkVjYS9TQ2NRWDkvQlgwMEU2QzBj?=
 =?utf-8?B?REhDODdjb0lSZERvZnM1eTdqd3VMM0xuNCsxbVJ6SDlpT3FWTGJLZGNoU2la?=
 =?utf-8?B?cndJOGgzNEdLZm1mNFZSLzVMNk5DN3FNcDFLbldJTGl5bWpWWFQ2aHV4RHNX?=
 =?utf-8?B?Wm9sc096Rlp5U3ZPZkdRMHVsOGtnNE5GV2l0NUpRS2FjZnUwWlNPZkR3cDFm?=
 =?utf-8?B?dmhXS0dpNGlrd1dxamp1Z1YvaVJkSnQyYk4xVWhiY3pCWlg0WFozWThrQy9l?=
 =?utf-8?B?TythUDZSWEsrL1ZPSlBIQW81TDlkTFV2M2srY0p4cG5qcEovMHJXQzlkSjhn?=
 =?utf-8?B?VkRXKzVScTZmU0hMMy8rdmY5ZWpWRDl1Z2JBeVptTXY2V2tONWs5c3cwRUVu?=
 =?utf-8?B?VVhkZnQwMlBSaVZVUUxUTmMyNWcrR2VqNTNwTUZ0OWdiN3FHRm4vcVBGcjVV?=
 =?utf-8?B?bEluRUJueklKQXhpOEIweHF2Tlk0Ymd1WW9oRW42V2NYQ2tVSG1iQlk1QkdE?=
 =?utf-8?B?SW1LSmxKRXpVTllrVyswYmJBMXU0emFrNWZ5eU8rOEpFSm16ZmJIYytleGN3?=
 =?utf-8?B?T0Y5KzdweEJ3MlNKbnVEUWFkYW9CNEQ3aTJTQ2NydW9YRkd1QXd1dy8yQVh0?=
 =?utf-8?B?MjlsdVVTeHJYc3hYQzFxVnhsQ1FrNFdTTkc3bDhkM3IrUlFMOFdWL25jb2ZM?=
 =?utf-8?B?Tm1MODJ0c0FKOTkyY2h2TjNqMDNQSU5KZklnRW0waEt4YXFrcDVaVllNRDRF?=
 =?utf-8?B?TWQ2TEZCdm5MQzNvYUxDMThqaWI3UHhtdVpZeS9vTjFkUy9BZzhCcXYya0xv?=
 =?utf-8?B?aFlpNmZYS3BtZkh6aDhFTzZiUG0wWjE1SWhxaEpMemVLeUN1OSs0Yk9aMWpx?=
 =?utf-8?B?OS8wZnJzOFY3Wm5mKzlHNDFVUExDRFVEbkl5WUk2Y3dTOEF4b1grVjV0RHJ0?=
 =?utf-8?B?alNiaGRUY1BlVDlRZUlQeExGbEpmdk1ndXNTRU8yQU9PNGF1ZFFEY0RJVEVm?=
 =?utf-8?B?b0tFTTRLMHdXK3B6bHFrN0FWS3FLazFqeW1jRTE5TmRNQ1p5ak14RDZCcEs4?=
 =?utf-8?B?RFYweGQ5TEJsRDJmb3RYTHhWUFNYVUw5NzlvZWdibmpFQ3QrNGt2aXBtOFFz?=
 =?utf-8?B?bjJRbnViUERIUFZ6ZVl5N3dqM1dySGNjYkxOQzYwM1JBMVJzaTJoWk1jMDRV?=
 =?utf-8?B?S3lqNFhXRWo0d0VRUk9ZeXJISUdCTzQ5UVA3OVJzaU9pc0E9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eURLSkx1aGMxbG80NDdSQzlQL0ZFZEFRNEduOUdoN3YyYmVmM2dPa0VweURJ?=
 =?utf-8?B?L1BBSXVLbVJGQkEyckkxT09wVm04eVBBS09jSWxob1UwOWw1a2FreGloaGp4?=
 =?utf-8?B?SElvaGtmZmpPdkhkcjNsR0orUXFpUnU1RytjR0J5cXk0N2pqUjYwT3F6clQw?=
 =?utf-8?B?enBRZjRZMFJwU1lnbmk4Y3dpT09iYjk4Z2Z5aytUVXlDQmNMUGlmdDlvQ0Mz?=
 =?utf-8?B?Ni9NUFhFbGVaWkRvM3VPQUtSb1NOMmdNMG5hNmd0Rm9JRG1CMU1GaVZXOVls?=
 =?utf-8?B?SDFkTmFUNmNwTy9YOXZXb3BvSVEvMGxYb0R3Y1p0M1Q5M2R1cUNBcmlnbHhZ?=
 =?utf-8?B?YjVUK3V4S2lkeHQ2c2VZRCt2bkJqQk90NUREMTNBWkxOTDJUdHhLSVFVakZm?=
 =?utf-8?B?VHZhUlVwNytGUU9HeVJkUHl0RWFDM1hoNlFhZHZpWkhoN0grKzNqSXptV2Nx?=
 =?utf-8?B?TGFsVFYwcHJLSUlYV0U4L2Vka0VQN0V3K2Fpa1I2a3VxRXZxVUthRFFEanQ4?=
 =?utf-8?B?Z2tJdDZ2MElrNFU5STJVYklOMm5VbGZKbks5cEQ3SHM2dVg0V21ma1pqTWZD?=
 =?utf-8?B?dzBYcUZ5dDk0OXZSalFtMDdheDFWT3B2Ujd0bDhwdmUyNzQvenJNV0lwK2x6?=
 =?utf-8?B?aDVVNFgvOVdLUldCYU1kT3hxTWZhR1BzeS82dnRLb0g3bmNjZG5TMHdaeG8y?=
 =?utf-8?B?YlozQU42UUpIdUJ0Um00aUdta1pzNy9HaU5ZRFp0MkVZWUNEVmJoS0duZEov?=
 =?utf-8?B?by82UkcxWjh5eWhnYUpQNUxoNFlGZnRiVHZKSUlQQ0FKV042dU5ONm96V3NJ?=
 =?utf-8?B?ZURRay9uMzBKTkk5b1kwWm1rSjAyQlJGdkhNcHhLYWV4TzJMOEdpY25vTExM?=
 =?utf-8?B?ei9YaGx1VXFQZ1h5bTZhc2w2QnVZY0poSFVOakpMWTU1M0dvbE1xUkpxMkIv?=
 =?utf-8?B?VEoyNUZuaDJXRzVBNGpGNEJlOWVQdnYxbHFSUGEwY3hYTElWV2gyNnZ2dWtG?=
 =?utf-8?B?MGlJUUJ3NHhUZi9UT295WEc0MDZyZjk2cXBYd0pPd01ERmJaL3Zjb01LdW5v?=
 =?utf-8?B?Vnk4djZwY3IrTUIvUytmVWJJTlFUcU80L0JHa2dranVlRUY5MGhiVnFvUHpK?=
 =?utf-8?B?MmlSek5NaVF1U1ZEdWVZWUVoU0xsTlFmUDZHK1IwM0pSUHI0Tnd1RTk5OTZQ?=
 =?utf-8?B?c2ZEZzVodHhjL2s1RjdyLzFmQU51MXVkTlFKdVJhZXQ0Y29mSE5jOWNhVXRp?=
 =?utf-8?B?aURpNDg3Vit5TEE3UUJCTjFSM2pqdzFEbFZtRWIxUXBBellyZjBIdmlJTmxq?=
 =?utf-8?B?am5CeXNhM1BWUldCei9VcFc1cy9IZ2RYOTdpcTZhS1ZjWnJzUVAwd3VKVFpG?=
 =?utf-8?B?WVZDVVg5TWg2VUt4NWpTQ083R1NZVEZwcDhFNmkvZlFCT0ZZRlJFKzBTQ0tV?=
 =?utf-8?B?OWhKa0VMYStKSkluTDRZdUw5b0tPVFk2N2ZNVHo1amw3ZG1aN1dJajFIZEk2?=
 =?utf-8?B?VkFxMWlDQ094THg3cmtFeTBrTFRTT1RnZDBCMWdqem1oNzhXQUUxeG9BSm0z?=
 =?utf-8?B?SDJHazJncU8weHJwd2NQQ09zR0V4b3dqckZjR2V5UEo1VkxwYkZ4VGhSUitN?=
 =?utf-8?B?eGVkenJncmRuekx2TGVjd1pYWk0rYnJVRGVobHFDbGNOMG1IOTVoNGZaMmhB?=
 =?utf-8?B?ZWxhTHNFUmJaL1NvcnRUWEJacjgyVWQrU1l2SW5RRFUxOGl0dXdXSDJZRjZR?=
 =?utf-8?B?Um43a0lRYmlNQlg5WmFyWjYzcmsvRnc1cCtuVlJhdE5rZzZ3NjFPVVdPUGp1?=
 =?utf-8?B?cjFHS2h5Sy9YZXdZTVJGOFcwbkkyT0l2WDA2WXNvMTRzbFpqemNpTkk0Tkhj?=
 =?utf-8?B?TTNFMGI1YnF3TXZFZ0tYdkg3aS9VY01iN1lwNG1XL2NydmNyUVNzb1FUYmpI?=
 =?utf-8?B?K1JXRmoyT1BBcmZOVXV0eFF4MnV3aEZKRjlnRllZV2VOdkg3RkE5TU91Y1g0?=
 =?utf-8?B?QjFnVE4wWnZ0ZWJVcWU4Mml6a0dSZVMxdXVSWjRDUE9xUVBtMHBwcmVETUl3?=
 =?utf-8?B?Sm11d3FSVzA5MFR1bjVLUTRQNFUreUlIeXM3Y1VTLzNjZ0RaYUFCMC84YjM1?=
 =?utf-8?Q?2+yueXh3BQuBL1PJx8XcgHJk5?=
Content-Type: multipart/mixed;
	boundary="_002_7109da789f52dac408f1fb9e0440ad418af6e3abcamelintelcom_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c3293d-57fd-462f-9c3a-08dd0f5d8e49
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2024 03:34:24.9478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /r62+8a/xV1776JHar6heB1KKPfC3S5wbr+fNhdZrVVbOHSOe435Zet27vM4O2Jlg6VZVsI3FUwyz/x82Z9fYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6709
X-OriginatorOrg: intel.com

--_002_7109da789f52dac408f1fb9e0440ad418af6e3abcamelintelcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <36377430C904F5488AD9B6C2BE3D1C68@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

SGkgUGFvbG8sDQoNClRoYW5rcyBmb3IgZG9pbmcgdGhpcyENCg0KPiArDQo+ICtzdGF0aWMgdm9p
ZCBfX2RvX3RkeF9jbGVhbnVwKHZvaWQpDQo+ICt7DQo+ICsJLyoNCj4gKwkgKiBPbmNlIFREWCBt
b2R1bGUgaXMgaW5pdGlhbGl6ZWQsIGl0IGNhbm5vdCBiZSBkaXNhYmxlZCBhbmQNCj4gKwkgKiBy
ZS1pbml0aWFsaXplZCBhZ2FpbiB3L28gcnVudGltZSB1cGRhdGUgKHdoaWNoIGlzbid0DQo+ICsJ
ICogc3VwcG9ydGVkIGJ5IGtlcm5lbCkuICBPbmx5IG5lZWQgdG8gcmVtb3ZlIHRoZSBjcHVocCBo
ZXJlLg0KPiArCSAqIFRoZSBURFggaG9zdCBjb3JlIGNvZGUgdHJhY2tzIFREWCBzdGF0dXMgYW5k
IGNhbiBoYW5kbGUNCj4gKwkgKiAnbXVsdGlwbGUgZW5hYmxpbmcnIHNjZW5hcmlvLg0KPiArCSAq
Lw0KPiArCVdBUk5fT05fT05DRSghdGR4X2NwdWhwX3N0YXRlKTsNCj4gKwljcHVocF9yZW1vdmVf
c3RhdGVfbm9jYWxscyh0ZHhfY3B1aHBfc3RhdGUpOw0KPiArCXRkeF9jcHVocF9zdGF0ZSA9IDA7
DQo+ICt9DQoNCkFzIEdhbywgQ2hhbyBwb2ludGVkIG91dCwgdGhlcmUncyBidWcgaGVyZSBzaW5j
ZSBpdCBpcyBhbHNvIGNhbGxlZCBieQ0KX19kb190ZHhfYnJpbmd1cCgpIHdoaWNoIGlzIGNhbGxl
ZCB3aXRoIGNwdXNfcmVhZF9sb2NrKCkgaG9sZC4gIFdlIG5lZWQgdGhlDQpfY3B1c2xvY2tlZCgp
IHZlcnNpb24gaGVyZS4NCg0KSSBwYXN0ZWQgdGhlIGZpeHVwIGF0IHRoZSBib3R0b20gb2YgdGhp
cyByZXBseSBmb3IgeW91ciByZWZlcmVuY2UgYW5kIHBsZWFzZQ0KbWVyZ2UgaWYgaXQgaXMgZmlu
ZSB0byB5b3UuICBUaGUgZGlmZiBpcyBhbHNvIGF0dGFjaGVkIGlmIHRoYXQncyBlYXNpZXIuDQoN
Cg0KWy4uLl0NCg0KPiAraW50IF9faW5pdCB0ZHhfYnJpbmd1cCh2b2lkKQ0KPiArew0KPiArCWlu
dCByOw0KPiArDQo+ICsJaWYgKCFlbmFibGVfdGR4KQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiAr
CWlmICgha3ZtX2Nhbl9zdXBwb3J0X3RkeCgpKSB7DQo+ICsJCXByX2VycigidGR4OiBubyBURFgg
cHJpdmF0ZSBLZXlJRHMgYXZhaWxhYmxlXG4iKTsNCj4gKwkJZ290byBzdWNjZXNzX2Rpc2FibGVf
dGR4Ow0KPiArCX0NCj4gKw0KPiArCWlmICghZW5hYmxlX3ZpcnRfYXRfbG9hZCkgew0KPiArCQlw
cl9lcnIoInRkeDogdGR4IHJlcXVpcmVzIGt2bS5lbmFibGVfdmlydF9hdF9sb2FkPTFcbiIpOw0K
PiArCQlnb3RvIHN1Y2Nlc3NfZGlzYWJsZV90ZHg7DQo+ICsJfQ0KDQpUaGUgaW50ZW50aW9uIG9m
IGt2bV9jYW5fc3VwcG9ydF90ZHgoKSBpcyB0byBwdXQgYWxsIGRlcGVuZGVuY3kgY2hlY2tzIHRv
IGl0LiAgSQ0KdGhpbmsgd2Ugc2hvdWxkIGp1c3QgcHV0IHRoZSBjaGVjayBvZiAnZW5hYmxlX3Zp
cnRfYXRfbG9hZCcgaW5zaWRlLiAgQW5kIHRoZXJlDQp3aWxsIGJlIG1vcmUgY2hlY2tzIGluIHRo
ZSBsYXRlciBwYXRjaGVzIHN1Y2ggYXMgY2hlY2tpbmcgJ3RkcF9tbXVfZW5hYmxlZCcgYW5kDQon
ZW5hYmxlX21taW9fY2FjaGluZycgc28gaXQgZG9lc24ndCBtYWtlIHNlbnNlIHRvIGNoZWNrICdl
bmFibGVfdmlydF9hdF9sb2FkJw0Kb3V0c2lkZS4NCg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCmluZGV4IDA2NjZkZmJlMGJj
MC4uZDhjMDA4NDM3ZTc5IDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KKysr
IGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTM4LDEwICszOCwxNyBAQCBzdGF0aWMgdm9p
ZCBfX2RvX3RkeF9jbGVhbnVwKHZvaWQpDQogCSAqICdtdWx0aXBsZSBlbmFibGluZycgc2NlbmFy
aW8uDQogCSAqLw0KIAlXQVJOX09OX09OQ0UoIXRkeF9jcHVocF9zdGF0ZSk7DQotCWNwdWhwX3Jl
bW92ZV9zdGF0ZV9ub2NhbGxzKHRkeF9jcHVocF9zdGF0ZSk7DQorCWNwdWhwX3JlbW92ZV9zdGF0
ZV9ub2NhbGxzX2NwdXNsb2NrZWQodGR4X2NwdWhwX3N0YXRlKTsNCiAJdGR4X2NwdWhwX3N0YXRl
ID0gMDsNCiB9DQogDQorc3RhdGljIHZvaWQgX190ZHhfY2xlYW51cCh2b2lkKQ0KK3sNCisJY3B1
c19yZWFkX2xvY2soKTsNCisJX19kb190ZHhfY2xlYW51cCgpOw0KKwljcHVzX3JlYWRfdW5sb2Nr
KCk7DQorfQ0KKw0KIHN0YXRpYyBpbnQgX19pbml0IF9fZG9fdGR4X2JyaW5ndXAodm9pZCkNCiB7
DQogCWludCByOw0KQEAgLTY4LDcgKzc1LDE3IEBAIHN0YXRpYyBpbnQgX19pbml0IF9fZG9fdGR4
X2JyaW5ndXAodm9pZCkNCiANCiBzdGF0aWMgYm9vbCBfX2luaXQga3ZtX2Nhbl9zdXBwb3J0X3Rk
eCh2b2lkKQ0KIHsNCi0JcmV0dXJuIGNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfVERY
X0hPU1RfUExBVEZPUk0pOw0KKwlpZiAoIWNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVf
VERYX0hPU1RfUExBVEZPUk0pKSB7DQorCQlwcl9lcnIoInRkeDogbm8gVERYIHByaXZhdGUgS2V5
SURzIGF2YWlsYWJsZVxuIik7DQorCQlyZXR1cm4gZmFsc2U7DQorCX0NCisNCisJaWYgKCFlbmFi
bGVfdmlydF9hdF9sb2FkKSB7DQorCQlwcl9lcnIoInRkeDogdGR4IHJlcXVpcmVzIGt2bS5lbmFi
bGVfdmlydF9hdF9sb2FkPTFcbiIpOw0KKwkJcmV0dXJuIGZhbHNlOw0KKwl9DQorDQorCXJldHVy
biB0cnVlOw0KIH0NCiANCiBzdGF0aWMgaW50IF9faW5pdCBfX3RkeF9icmluZ3VwKHZvaWQpDQpA
QCAtMTAzLDcgKzEyMCw3IEBAIHN0YXRpYyBpbnQgX19pbml0IF9fdGR4X2JyaW5ndXAodm9pZCkN
CiB2b2lkIHRkeF9jbGVhbnVwKHZvaWQpDQogew0KIAlpZiAoZW5hYmxlX3RkeCkgew0KLQkJX19k
b190ZHhfY2xlYW51cCgpOw0KKwkJX190ZHhfY2xlYW51cCgpOw0KIAkJa3ZtX2Rpc2FibGVfdmly
dHVhbGl6YXRpb24oKTsNCiAJfQ0KIH0NCkBAIC0xMTUsMTUgKzEzMiw4IEBAIGludCBfX2luaXQg
dGR4X2JyaW5ndXAodm9pZCkNCiAJaWYgKCFlbmFibGVfdGR4KQ0KIAkJcmV0dXJuIDA7DQogDQot
CWlmICgha3ZtX2Nhbl9zdXBwb3J0X3RkeCgpKSB7DQotCQlwcl9lcnIoInRkeDogbm8gVERYIHBy
aXZhdGUgS2V5SURzIGF2YWlsYWJsZVxuIik7DQotCQlnb3RvIHN1Y2Nlc3NfZGlzYWJsZV90ZHg7
DQotCX0NCi0NCi0JaWYgKCFlbmFibGVfdmlydF9hdF9sb2FkKSB7DQotCQlwcl9lcnIoInRkeDog
dGR4IHJlcXVpcmVzIGt2bS5lbmFibGVfdmlydF9hdF9sb2FkPTFcbiIpOw0KKwlpZiAoIWt2bV9j
YW5fc3VwcG9ydF90ZHgoKSkNCiAJCWdvdG8gc3VjY2Vzc19kaXNhYmxlX3RkeDsNCi0JfQ0KIA0K
IAkvKg0KIAkgKiBJZGVhbGx5IEtWTSBzaG91bGQgcHJvYmUgd2hldGhlciBURFggbW9kdWxlIGhh
cyBiZWVuIGxvYWRlZA0KDQo=

--_002_7109da789f52dac408f1fb9e0440ad418af6e3abcamelintelcom_
Content-Type: text/x-patch; name="tdxinit-fix.diff"
Content-Description: tdxinit-fix.diff
Content-Disposition: attachment; filename="tdxinit-fix.diff"; size=1679;
	creation-date="Thu, 28 Nov 2024 03:34:24 GMT";
	modification-date="Thu, 28 Nov 2024 03:34:24 GMT"
Content-ID: <053DD38E6BE6A44895507BE442D080F6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5jCmluZGV4IDA2NjZkZmJlMGJjMC4uZDhjMDA4NDM3ZTc5IDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vdm14L3RkeC5jCisrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMKQEAgLTM4LDEwICsz
OCwxNyBAQCBzdGF0aWMgdm9pZCBfX2RvX3RkeF9jbGVhbnVwKHZvaWQpCiAJICogJ211bHRpcGxl
IGVuYWJsaW5nJyBzY2VuYXJpby4KIAkgKi8KIAlXQVJOX09OX09OQ0UoIXRkeF9jcHVocF9zdGF0
ZSk7Ci0JY3B1aHBfcmVtb3ZlX3N0YXRlX25vY2FsbHModGR4X2NwdWhwX3N0YXRlKTsKKwljcHVo
cF9yZW1vdmVfc3RhdGVfbm9jYWxsc19jcHVzbG9ja2VkKHRkeF9jcHVocF9zdGF0ZSk7CiAJdGR4
X2NwdWhwX3N0YXRlID0gMDsKIH0KIAorc3RhdGljIHZvaWQgX190ZHhfY2xlYW51cCh2b2lkKQor
eworCWNwdXNfcmVhZF9sb2NrKCk7CisJX19kb190ZHhfY2xlYW51cCgpOworCWNwdXNfcmVhZF91
bmxvY2soKTsKK30KKwogc3RhdGljIGludCBfX2luaXQgX19kb190ZHhfYnJpbmd1cCh2b2lkKQog
ewogCWludCByOwpAQCAtNjgsNyArNzUsMTcgQEAgc3RhdGljIGludCBfX2luaXQgX19kb190ZHhf
YnJpbmd1cCh2b2lkKQogCiBzdGF0aWMgYm9vbCBfX2luaXQga3ZtX2Nhbl9zdXBwb3J0X3RkeCh2
b2lkKQogewotCXJldHVybiBjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJFX1REWF9IT1NU
X1BMQVRGT1JNKTsKKwlpZiAoIWNwdV9mZWF0dXJlX2VuYWJsZWQoWDg2X0ZFQVRVUkVfVERYX0hP
U1RfUExBVEZPUk0pKSB7CisJCXByX2VycigidGR4OiBubyBURFggcHJpdmF0ZSBLZXlJRHMgYXZh
aWxhYmxlXG4iKTsKKwkJcmV0dXJuIGZhbHNlOworCX0KKworCWlmICghZW5hYmxlX3ZpcnRfYXRf
bG9hZCkgeworCQlwcl9lcnIoInRkeDogdGR4IHJlcXVpcmVzIGt2bS5lbmFibGVfdmlydF9hdF9s
b2FkPTFcbiIpOworCQlyZXR1cm4gZmFsc2U7CisJfQorCisJcmV0dXJuIHRydWU7CiB9CiAKIHN0
YXRpYyBpbnQgX19pbml0IF9fdGR4X2JyaW5ndXAodm9pZCkKQEAgLTEwMyw3ICsxMjAsNyBAQCBz
dGF0aWMgaW50IF9faW5pdCBfX3RkeF9icmluZ3VwKHZvaWQpCiB2b2lkIHRkeF9jbGVhbnVwKHZv
aWQpCiB7CiAJaWYgKGVuYWJsZV90ZHgpIHsKLQkJX19kb190ZHhfY2xlYW51cCgpOworCQlfX3Rk
eF9jbGVhbnVwKCk7CiAJCWt2bV9kaXNhYmxlX3ZpcnR1YWxpemF0aW9uKCk7CiAJfQogfQpAQCAt
MTE1LDE1ICsxMzIsOCBAQCBpbnQgX19pbml0IHRkeF9icmluZ3VwKHZvaWQpCiAJaWYgKCFlbmFi
bGVfdGR4KQogCQlyZXR1cm4gMDsKIAotCWlmICgha3ZtX2Nhbl9zdXBwb3J0X3RkeCgpKSB7Ci0J
CXByX2VycigidGR4OiBubyBURFggcHJpdmF0ZSBLZXlJRHMgYXZhaWxhYmxlXG4iKTsKLQkJZ290
byBzdWNjZXNzX2Rpc2FibGVfdGR4OwotCX0KLQotCWlmICghZW5hYmxlX3ZpcnRfYXRfbG9hZCkg
ewotCQlwcl9lcnIoInRkeDogdGR4IHJlcXVpcmVzIGt2bS5lbmFibGVfdmlydF9hdF9sb2FkPTFc
biIpOworCWlmICgha3ZtX2Nhbl9zdXBwb3J0X3RkeCgpKQogCQlnb3RvIHN1Y2Nlc3NfZGlzYWJs
ZV90ZHg7Ci0JfQogCiAJLyoKIAkgKiBJZGVhbGx5IEtWTSBzaG91bGQgcHJvYmUgd2hldGhlciBU
RFggbW9kdWxlIGhhcyBiZWVuIGxvYWRlZAo=

--_002_7109da789f52dac408f1fb9e0440ad418af6e3abcamelintelcom_--

