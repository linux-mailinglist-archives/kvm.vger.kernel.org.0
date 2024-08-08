Return-Path: <kvm+bounces-23662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE8C394C776
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 01:52:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61B60281184
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 23:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27243161320;
	Thu,  8 Aug 2024 23:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nQlFhQQz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9187155A59;
	Thu,  8 Aug 2024 23:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723161143; cv=fail; b=E82ytGQERzwFglJuVfOu1Nf6qnOEz+kTIZKBk5JLxYLiGHE2cKXDxI7lmGSxwEHUuHmhzW6WFdrq3L3Xc6cTZo3lxd5fckRg/06sBGSVZdP040xLbdLOJajaQVMq7b7ZtVpohFVEEwlHQOUyBd8Z70eK2352BT/bWlEiTYX9X/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723161143; c=relaxed/simple;
	bh=sA3AcKp731pDLsjSgXxPeu7sximHxwrV4brlp0lTt3s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U8mCWwkyFoMv+Xo4y+n22yo/Knoa245I6qxG0B62NrDXI0qLnD36x2poMnSAv8NTYBuXoFSldWcty642o8T6mKrXyH21BxL9foEAAoKXDvMto/OvkoGNNJGus6I9ZwFXfIQXn2gKUg2BzgwNLbtwJtdMISpwEtp0FT3aL4p8lo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nQlFhQQz; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723161142; x=1754697142;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sA3AcKp731pDLsjSgXxPeu7sximHxwrV4brlp0lTt3s=;
  b=nQlFhQQzQQsKeBmNomNQFmy/meH9blNZxzgEH3wjigOn6i4Cuf0MMNOp
   wE8o3g6+8FSHnyowEAIKVXWMXVrAoNuH/G0/9p6bq6hlTBPhFX1Iuw//l
   c69s8UmUGpFGtKcXUqiK3UU5GNKaIW9tnTXhd3OiidIeNSaSB5lzX/qWF
   FBJM8CAzPt+8mG0FV7zPUqX5DA6qbgb4QAtJDxDoOqq/kh27Vjh8DD9H7
   yOf4N37wqPnkdUZDIyiFTnjjh9W9cOQHi+1JPP26hGXpq2uZTb/jZ8nJb
   eZ22zZR0RiftbZT0jmg9f7oycr5DZ3P+n6J/kL5HDEPpkBlHcAXBHLpSx
   Q==;
X-CSE-ConnectionGUID: rUhb32ZgT4KuMo/nezaRiA==
X-CSE-MsgGUID: pLFLAcYVQK66fVKNXPhn8w==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="20980950"
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="20980950"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 16:52:21 -0700
X-CSE-ConnectionGUID: CnIBqhVcSUW8bKuIWjgEUQ==
X-CSE-MsgGUID: pc13rNXlT3C1ffMuUAHukg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,274,1716274800"; 
   d="scan'208";a="57365959"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Aug 2024 16:52:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 16:52:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 8 Aug 2024 16:52:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 8 Aug 2024 16:52:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 8 Aug 2024 16:52:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T0Z75NXuDxVAMTUsCzy/iGQURmNZ/RPYWK358DNBW8HI36gJukm8SJmrTIVhlopL6ultMAkJLgP5SroHWPvyDKOcd70kHnh9kNu1FnT5gl1LLm/vZRTp3/RsJcZVxTSM59iUx5fXdmw5q6HI5UQWUxcc4/PoEpJS5cJbosi/wLenOwa6y2zexrXLEzDm6QC5dFmel1/rYYVHn0/PfW8ZAR2fwwTzkJJyeHtp6awh3B8Ci2/c96vY7UU2DMV1lkfSnRgNzMQc2X6Nm8OeVm8l4LDwQMlR8YX8xkCxckZpA3UyRhPu6XywxBa0noZAWRoTH7tHdMLg8rf1K5IdQIW+yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sA3AcKp731pDLsjSgXxPeu7sximHxwrV4brlp0lTt3s=;
 b=aOpQc6zzzda0XGxPI5R2LlMd5ogqYiXkBX1KgzXbUOAeSA9/Yz1TnoGHSqj0iab5dXZFtRL6LVR5p9iRlWqfM3tkjbJ9P7AIfT5+WDIj3N4czAlf02IbeMArK3oOtFHsf1oRm3t/ftFCiiMmMv1QRB7/2FsE2C291dpGfhU4kc15f6Y96Kbc13hoFVOdVfYiaKn+GzTit8FZa9TiMNhqgO1eEEl47ppLYp6JrefF2bfVWX5HmqW3zSuDeWTb4SQgK0yjJ/ZCV1+CqtNzO0MANuvqtBt8YrveL1Ix7JLzU+kf6wiSDjRMbix2YNMXgJ+hLSsIdvzZBepHOM00XT5dzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CO1PR11MB5171.namprd11.prod.outlook.com (2603:10b6:303:94::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Thu, 8 Aug
 2024 23:52:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Thu, 8 Aug 2024
 23:52:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "Qiang, Chenyi"
	<chenyi.qiang@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
Thread-Topic: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic
 information
Thread-Index: AQHa1/rIRlz/jvOVzUGBp7cF8OmbMbIdTE6AgADfuYA=
Date: Thu, 8 Aug 2024 23:52:17 +0000
Message-ID: <5ad53631bc340600618e618c1d4b7c55ed76402a.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
	 <0e36f025-9a8f-4f75-af4b-bc6252c29abe@intel.com>
In-Reply-To: <0e36f025-9a8f-4f75-af4b-bc6252c29abe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CO1PR11MB5171:EE_
x-ms-office365-filtering-correlation-id: 061fa979-7b71-4d26-7cfa-08dcb80522a7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?K0Yvd1c4dlh4d2pvYThDcUZtTHR2RlgzNlZNdjUyVnpzOXZNNUdFMWVPaXVH?=
 =?utf-8?B?QnVwL1BRYmJKc3JsMHNOS2J6NXlzSlQxKzZPd1FaSTZpNE5FWEQzc1RUbTlZ?=
 =?utf-8?B?VU9qSE02cXh1WkZGa0kvNTFLc2JxTEU0clNKcVNYZktZbkZrOGx1WTB6MndO?=
 =?utf-8?B?VG82cXJ6MkNibDNBVGlaMnIzN0YrUkh5UHlWcjljaGxlamZuc3FUVlVsNEtG?=
 =?utf-8?B?UEJCc2RGNUxHdldHQkt2aDJyNDQwWi9ISU9HaGxLVWpkTHZwNTgrdWhqTm44?=
 =?utf-8?B?TWRJcmhLR2VMelBNUjFtazFDUGZibkdZRkE5R2JraUQreElVUW45aHpLVzFE?=
 =?utf-8?B?SGJoWjVyTkFOdmFvUFBFNmNlVmliaG00dms0NnFmNkJGZ05FQkgyZHp4WTdC?=
 =?utf-8?B?NU5oUjJLS1EzbTdjRU8rZllISVJVcTZCWmJ3U1ZUOGgrRld3R1dkMzF3ekJB?=
 =?utf-8?B?ZlJWYlF6bnZ1b0hob0hwcWFZMTVPYlczams0V3YzRXYxYjVIcks5OXFDMGtC?=
 =?utf-8?B?VDNMTjlmbktoOENhTWQ1NWgxVmVTOHhCUXhGRlpLUmZXYkIycHV4ZUZ4SkZM?=
 =?utf-8?B?VGcyM3pXNC9scmpVRFEzTTZoL0FIeFBmZ0RkMzErVkpvYmVjb1pUYWQrL25K?=
 =?utf-8?B?SE92U1BPcUlCY1lCTnBHQlFpUXdTWGt1Z3owMWJ4akttd3ppa1BLYkI1c3F0?=
 =?utf-8?B?dkkvYWV6dU54cVNUb2t6d3YxQVlSbWFLNk5xMi9nenRVek82eUlURCtmZkR2?=
 =?utf-8?B?eW5HSnFYbllJUnE3Y29DdGhYMHZLRzVyaHUzWHFOWEh4TW9lMVBuODhNU3dF?=
 =?utf-8?B?eG5XSy9pMEU4S0dQR05kbXNiS2llTm96b21HaHFSeVRBM0JmT0lMMk01Z2Ur?=
 =?utf-8?B?OXg4ZWJQN0h3WFdqV0kwWStkSkNndWYzUW55T0NucjNVZ2g3M255cEZYM2FQ?=
 =?utf-8?B?SEdFd2FFVVRjTDBaL25qSG9WSDcyZ0luSXNoNU14d21KK0pmWFp4WnQvNTlO?=
 =?utf-8?B?MmtWYzUyOTlBallBQTR4WnREWW8ySytKbFp6YVhnMzY5ZVAvOW4xakEvK05u?=
 =?utf-8?B?cTUvWHNWWmxPZ2xYZndFcGVkSThSV0ZqeVBtUU1nbnZhSklqNExmajdQc3hm?=
 =?utf-8?B?TlVveUdUK29MNjJhSmhBRTFNWTduTkJRMzUvVXk0NCtnR3FaOTVDc2NpdFg3?=
 =?utf-8?B?MVFOcTd4SmFJdkQvT1RsdXc4ZVc4SnFsQjdsK3QrMmdaN0NHZkR1cjBvb2dP?=
 =?utf-8?B?a0twVXBwZld3TFI2NGZQWmVXc1gxWitkQ1RDaTlaSVB2endtVXQ0Z2UvWDFi?=
 =?utf-8?B?TDVDMmVIaFZqS3VqdTR1MGFieStTdjk2QzVNRUh6UmZFWWYxQ1pLMThPZVd5?=
 =?utf-8?B?NTFkOHg1bHZiTjBFaFFzU29lQzdHU3ZKRGJ5cldaajlOVzEyakRmOGdDSUJB?=
 =?utf-8?B?RzBpVUxrQ1hiNUp0SytGaWl6NXBEZVFoWTlYc0NYdmcwTS91aTRYYWJra25M?=
 =?utf-8?B?OGJacy9aSk1ab0ZoVHRESXFHRUpmeXJId2dHTVByV0JsMVlFZkNUOVV2TzZJ?=
 =?utf-8?B?MDVzVWI0VlRzNThtZW5JR1FRTUlSWjNpMnZBYlc3MlV3SlJjRGFLUWZ1Qis3?=
 =?utf-8?B?SVNCaWxmQm41c1NQaTJwUHhIcC9wVlZTK1pTSzg4YWYzNHltWEhId2lKSFRO?=
 =?utf-8?B?TWwxY29HNGtWR1Yxb1RLaGRldU5yT3pFTUlBWmU3UEVyNXZGNCtiSEt6b2ds?=
 =?utf-8?B?dEozbjRNU01xUEFadmRWYzF1eTVUYi9RR3pab014cXBnQnVydnorTXA4MUNk?=
 =?utf-8?B?cjgzWmxSdUhWdk45dGlRenVJVDg5ODhOVW5UKzBWWWZlRXM1bGJ6MXJ5QkVv?=
 =?utf-8?B?OURUZklwa3oyaFVQOGNDV1pGT1FrUEtiNHY0NHp4cWFvVFV4MWxsMjEvRzJK?=
 =?utf-8?Q?Kt3t44HV9Kk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WkEwNDdrYStFb1pKYkp6SVluTlNzTnJCaUxtcTEyOVJUV3FVbmMzT2krU0Qv?=
 =?utf-8?B?bUJScHBBZlVQdVh2d2dXUWFSbTZaWm9ZOUNCTzArb0owVkFUVi9jdTVrbEJD?=
 =?utf-8?B?dHhBa1I2VGg3ZXVaTXNJTkRRYjJ4V0o2cVdTcGlGbXVVQ2twY204Y0ZXVGsv?=
 =?utf-8?B?MlB1Y1dxSUxKVncrM2ZkekVrS1NENkhaLzI2MDIvRWlyTXY2THpxZEdLRlpF?=
 =?utf-8?B?QzJneUVCdjdRM1lvOVd4Z2dNR3F0T1hoWXJ1OHMrQytVVXNRUVExVUtIQnpB?=
 =?utf-8?B?T1hJOFd3V0ZJbUg2dFYwUVpZc3hPQy8xMzkyejk0dXllei9Cd0FOTm4zNkRE?=
 =?utf-8?B?VERQOWZrOWl1ZXJzaTAzU0k0K3NVb2dPK0RnVVdFenFaQzltdXllVXFqM3Nv?=
 =?utf-8?B?djZjbUZjcHIrMi9DVDdVN3EvdTZkLy9Ob01wemNmbnNOR0hnRHlCd1ZLSC9J?=
 =?utf-8?B?c2piOEpYcjMwaEQ3NjdxQnVEa0VVSjRJV1loMklMYktCYVRiT21qYjF4cFNF?=
 =?utf-8?B?dHF6WjhkSnhYdlRacytyZjBGTFo5eHVoenpaWmVBVDJjdGJYdTZmZzc1a29s?=
 =?utf-8?B?eE1zSWJ2ZkVzWERUZEFIa2dHWmFLS0lURHFJdXAyRWV0Vnk4V0ZTRlFJeHJN?=
 =?utf-8?B?aE5oWHRVZG0zaEhwNGxmdVZmci9xcCsvUWhXbVdYZWl5d3VMcjgvWXR0d3Rk?=
 =?utf-8?B?cGNZZmtXOTlITUZIaHJ1aGV2d0N6cVRZdE5vanh3T3B3RXBPRUx6WnpNaGFE?=
 =?utf-8?B?TlI2OXJUMXpoZFpOYWZVWGRDeEZScm9UYUxvdW9haG5TQXYwOUdZY2FodnIv?=
 =?utf-8?B?a3Q5cGFFczV1aFlGZHA3c2QzOHh6V3pFNjllQTdTUUhnZ2tuZ3N3Q1lmSXNw?=
 =?utf-8?B?VFMxNmZvZE5UVnZTTHRpQTg4TlNJRTR3Q2JJeVJ1V1VIU1Rab2p2WGNaWEtj?=
 =?utf-8?B?TGVsRGxxM0M2K2Q5dVMzQ1J2NEhSeFN0d2Z0Z2FaOGoxeHlXTmxCTEwrZERU?=
 =?utf-8?B?SlZrTTJlWFREcTJyRjJrU3JBVjdYaUc4dUswbW5mSXgyaG5kd2RuZUhIbDhi?=
 =?utf-8?B?OC9jcGNPeUdlN0FrRDBYYnU3bUNIZW1SQld4dytJdWZZYk5FNjVFMVF4Y2p1?=
 =?utf-8?B?cEU3TVFtT0JEcmhGUUZxREh6THlJQm03Qm0xSVpnVk1FcyttT2dGMEkxcjgw?=
 =?utf-8?B?dTZudVRFdi84c2h1WFFwQ3ZBNG1ERDhVc0pJamdEVEw5b21FcUhlOVcvS3g4?=
 =?utf-8?B?VUVhYW9xZUxvc3U1S2JYbVRxRHJMZzMrbGwrYnhJT25ucWhOaGJ4MmFiOFNa?=
 =?utf-8?B?aGtnY203bXRHbDFkQWxJZm9vWHU0Z2dqcFRNb29Ycm03N2l1WmpiUml4djgr?=
 =?utf-8?B?RDVSeEY2SDlWWHBsM3lpc0xkQk9YZVBZNE1URlQzNEVtSFhISnJUYTVNSDNX?=
 =?utf-8?B?anRnYzVoZHdDcVBaNkVnQWlBS3dsV2ZVSFNTcTFvZkhCN1UxTVY4NFNPVGdI?=
 =?utf-8?B?MUtyZDBodUJmcnRRME02aDNXWS9lZkV4WFJERFlFelI4SXMwUTNDbkJkUTEw?=
 =?utf-8?B?OFRkUFYzeXJhdnl1NnpOSkdGL2xpalF5bkJuRUNCQllCWDQ1cGNHK1ZpSXNx?=
 =?utf-8?B?ck5iL0g4SS9Yc2RCUjgwTmE0dFFIQUhITGwyWkY5NU5sRjZiRWtleXdqb2VQ?=
 =?utf-8?B?cXhVb25kMXJoMEp1L3RONjBRRDhUSW1Pd3JCUDVqNzRhVnJVN1R6K1ovVlk5?=
 =?utf-8?B?cWM0TWV4NDd2cGx1Wmc3UWhMOVVjYmFNZExpanZWRXowdVpzZnhKWnFhOHp0?=
 =?utf-8?B?THo2QzZhN1M2cXVTQUR0L2hXN1FYbEVINlFjSHI1ZnR1ci9vQ3ZDWTZIbGo3?=
 =?utf-8?B?WTZHcDM3MjZ6TVdUOURpSTJwT1lPVDU0U1RPbkpsUjQ3T3haWHdZdGNqVHVi?=
 =?utf-8?B?aENJdCtwcFlLcTJRZHhYM2dOcjBKQktjWTlCVUNzY0ZTYmt5NHFzTWJ2MzRw?=
 =?utf-8?B?Y3JEdDhtVUpQTmMyOFBjZkV3ZmJodjlNL1Naa2I2RXo4R2xEbUZsanplcVVp?=
 =?utf-8?B?cE85dTBBWngzeWpoYm9zNUpFb1ZCQ3g0MmdzL0luVTd2d29IY2JGcXVxbzlZ?=
 =?utf-8?Q?CHweNo0ZgopcXVBUg/WBvkqhp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <833AC6A64F543C449B1619CFAEEADFFA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 061fa979-7b71-4d26-7cfa-08dcb80522a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2024 23:52:17.5411
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZgTUQMBQ80KfmVuMe1f5/ahFvkPdw/2bk8ISBqlsp3oI7zLq6RGIED9Rve8OMHt54lNJtPJMEIGd0CkJgT/N4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5171
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA4LTA4IGF0IDE4OjMxICswODAwLCBDaGVueWkgUWlhbmcgd3JvdGU6DQo+
ID4gKw0KPiA+ICsjZGVmaW5lIFREWF9TWVNfQVRUUl9ERUJVR19NT0RVTEUJMHgxDQo+IA0KPiBP
bmUgbWlub3IgaXNzdWUsIFREWF9TWVNfQVRUUl9ERUJVR19NT0RVTEUgaXMgaW5kaWNhdGVkIGJ5
IGJpdCAzMSBvZg0KPiBzeXNfYXR0cmlidXRlcy4NCg0KRmFjZXBhbG0gOiggVGhhbmtzIQ0K

