Return-Path: <kvm+bounces-73331-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8DZhCcb1rmnZKgIAu9opvQ
	(envelope-from <kvm+bounces-73331-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:31:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1512023CBB3
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 17:31:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id EFD65300B292
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 16:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD91C3E3DA3;
	Mon,  9 Mar 2026 16:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bl5p1oXE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AADDC3C1976;
	Mon,  9 Mar 2026 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773073426; cv=fail; b=Ps20odBmqEj10mXmEYV+c3WUGxFMsw/M0MtdTsWOYDLojminvHmxo7Gd/eMsvHkEO+VEsKwg83eW98ff/4uBLPmWRHUgibj63C+6F3UeyekOpOTsVsWhSILRUYL6q5t6UH7UfHQQl5XMkgPwJwgnFkxhGRX5m1EaUlf3YrtMjWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773073426; c=relaxed/simple;
	bh=NjqeAWZGTMVbesvahj1JJjCt4FghwudDqdoaEMRfiGM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p9rohmc7brjM4D57hNGBFybS2Em/oUsLxC68vgjQMFatgWNT9oMCKDuAEkEUh4CjgE/X28Cyit0QZ5jJsjLSqK725GrrDYvJiySDBN7Xwdnq0iwixb2I5d+wJ0dyvwNmEdyGaPfIYDu8cLzEkofxX3HiujKWBxsvNRsCM7dfaqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bl5p1oXE; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773073423; x=1804609423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NjqeAWZGTMVbesvahj1JJjCt4FghwudDqdoaEMRfiGM=;
  b=bl5p1oXEEj+ErJEcodSlRKZX3byLIvajGTDZIPnteHaf7NlfbhcgxFlB
   CvtyN/2+GTp78yVmpD+57228EkF79U/iV8CwJj8B3icRiQSWO32a3BNmD
   1HJWenPy6CecUk0uUBOPepSHCf0FIpWzk4aBMxVK9D8H5C+OC6caPHk9B
   Hh2IAt+ZoFAtTJk9f7q4f59efhx6mcb8KLnCNXwCesEo776WtUHw/RVlF
   r5Jl/s1CJof9TJy1BogX9Rbd5aKCUMeebB8xtLAZz7lN89gr2SFVO76ml
   s95N2dVr9gVpRwK25UxZd822b53/4A2URCEHgA1VmfRnIwmxzu8JIy0+D
   Q==;
X-CSE-ConnectionGUID: s7sts2sdRYSG6Tomkdxfvg==
X-CSE-MsgGUID: fGIAsvIATY+tXDLz6vrsxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11723"; a="74004755"
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="74004755"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:23:42 -0700
X-CSE-ConnectionGUID: TDbiR4eASwihRZ0+x9TYTg==
X-CSE-MsgGUID: iuan3EL8QO2xtfLzgvsfHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,109,1770624000"; 
   d="scan'208";a="219741853"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2026 09:23:42 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:23:40 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 9 Mar 2026 09:23:40 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 9 Mar 2026 09:23:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ko0tSFYl/K7TzUeMnIYG7K91wmy5/hB77NfG4FBeWOm57oy/CyjQQ7eEPIK7w/ww1MogzWAov9VZulk+jVxryz0IykBJts5mZZLA1myIbcoZDLuZVbFaJUoWYeKMLyLLbeNS82EISdx7R8v3PBJgR2VwHiCS41EBGiOx8qkDfIzNQSMopgdRzKxKYRTLXSzVLIRTJ4pqqkOWRqjjXwtMmUm0ejg3P/OSmPszDmCAzD4+8+3ARTZsMtHUAQMm72eSUdoS+/l6WDf+Nho/yqqGYW84IbkmgLdgoeunvpdPZCvNnAip04OWks0EpH//ymBxJ3R+c4jAt1aNj4C0uqJZuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NjqeAWZGTMVbesvahj1JJjCt4FghwudDqdoaEMRfiGM=;
 b=Bf+l+xfGzhqRDubel4Eu8jOxTSvLMy/zBQoojm/NV5UfXJxxcNs/ADsJZO8LfdnngtpMtwLfGbzt05sSmQ4J8qofb+mPwTKKvt6iqjbYoXhzqaa1Ht4hdwsPsY/SifPS9+bW/RObGNY4LV4iHPmYFORAIABW7oeumxyDw0+MAkaf5gLCtspP1EDTbgQqJjuGXmodjoVddKcGEAGPybyYIBx41sQ3d4xH2DVCqrzffBhMfSBIhr7sgD89eM9QsrknLL8GEsNwfkqX/9XaBDUqgJUnkqZPVnMDoXAiFiEjkilgiQMWcTU5+OEVKPYi2wk7GKfWXxB2lVHqt8M3UMf+Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH3PPF37A184CA6.namprd11.prod.outlook.com (2603:10b6:518:1::d15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.10; Mon, 9 Mar
 2026 16:23:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9678.017; Mon, 9 Mar 2026
 16:23:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "kas@kernel.org" <kas@kernel.org>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Huang, Kai" <kai.huang@intel.com>, "tglx@kernel.org" <tglx@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "x86@kernel.org" <x86@kernel.org>, "Gao, Chao"
	<chao.gao@intel.com>
CC: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH 2/4] x86/virt/tdx: Pull kexec cache flush logic into
 arch/x86
Thread-Topic: [PATCH 2/4] x86/virt/tdx: Pull kexec cache flush logic into
 arch/x86
Thread-Index: AQHcrc5Ti4gbDCF2wUONkHnQ5+PqXLWlWkaAgAEMt4A=
Date: Mon, 9 Mar 2026 16:23:37 +0000
Message-ID: <966ca112d6619039f18c441d84657f23694dd4bc.camel@intel.com>
References: <20260307010358.819645-1-rick.p.edgecombe@intel.com>
	 <20260307010358.819645-3-rick.p.edgecombe@intel.com>
	 <d16e808b16d9c23f7db34e576c4dd82eb9772831.camel@intel.com>
In-Reply-To: <d16e808b16d9c23f7db34e576c4dd82eb9772831.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH3PPF37A184CA6:EE_
x-ms-office365-filtering-correlation-id: 4d175b94-302f-417c-7e75-08de7df837cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|921020;
x-microsoft-antispam-message-info: QV4O1hoAf9e/iBA80ArMhfDN7Jut5RZlwssmPs79/y+ExJ3Yg6auVezlQkU4iJqxHTKQhKAzgynIE/Mr1GAt31Fr/M85u1qnZpM8eSFG0iaJd/PLg16MxP+2OHT+GEErYAFqmlrO9s/kAnH4sd5zQHp2dYV4z49Bcs2VE3kTflAwv0YAPy6lva+j+zDcrbnZsy01uFmCnee0iUtEeOQL0hUkQaYA35n2p0KnLjVsvM8KyHpRHQ0A/vBzizt8V5YkEvRjiH2zh8TRkuPIv4J77q4gqpqSed9qbkr9ZE9A8IYhFQvZ5Vb40ZTbKqKveWAZy3IX6EeJ6AXBX0qm7+Z+ppN6ypCe+xUwqGkwoBoEn0FiIX0N15OoWvQMCXgTdL+BnCSnPoFnaT0UfsI0wQ7GZkFYxAjO1Ha01SjFD2EfuyeYcyoRvgIOJro+I/fEQlil8slGcuAq+sBCaRPvyjB3LqbWlg7cxIVxfPcAccaTO2fKq+t/mhYP+mR48esf3zXglTllmGHFA0jCKPLfOxTIGVtdh+dDg1/xdPCy7PaWAcRv24lxlNSw6Jw5X8nF5iWzHYWPeasWJR6vGwNl2b2stMCKelXv4tsyRgUuhxj/1eZFCV5z4yjVWW2VydelkMoLBWbyElDIr5zdi3OADbalZfCEn2WkCvZbr/JwgzwhMRtRG4yAkvJo+PRQMlJWaioE6RzUqwB/bWCevx1EExHZdjoVpKAJ2w0NNJvX7B5xpJVr2SvRfKCpsD1rzYQ0VpJv5B1Z5wOB4/8y2HXS9jB0ZeJL8JuysWJLcl0Railcpb/xxaXgSW/GB/+SDoRVRRMI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0RRVEw5OEFZelVwaUowYXZwZ3NEbFErejNiSFhIYUFobERhMGphcEZTd0FT?=
 =?utf-8?B?RFMxUTVRWTE5QWdaYlYxOHAyT05TMThrM2xVL09FTVB0R0JIWkFRLy96d0pn?=
 =?utf-8?B?UXZiOTZOd1ZveExYK2N0bDh0UFdDZzJXREZmNjNBNEtCUUlFWVduNTd2amZW?=
 =?utf-8?B?MytNMUFiRVRDb0pIUEdqalBGT2d5YWZ5d1hJa3ZkRW1kaFB5SXhqMTJhckFX?=
 =?utf-8?B?TDJpRGhXRXhUU1hVR0I2czdsQ0pKK1ZRUXZVRXZ2K3RNMzk2WkdXOUV6S2E2?=
 =?utf-8?B?cG5WZGhqNEhIVzVickFzbzltdTltWEZsR2VDRy9VU2VQcGtZUC84RXJyWmFX?=
 =?utf-8?B?Z2NpRDloRHducXFnQ3RuUDhRTW1WdUpRNlRoN21zdnlnMnBXaThOUFh3bUJm?=
 =?utf-8?B?NFltR2xFRDZVUSttc1pJcXZ2UGczWmFmaTBWc1VRR2FxLzlaSWZac1VOTDRP?=
 =?utf-8?B?RFl3bTk3WnpnbXY5aWFBSGtLblljM2s2elBMTFRnRkRDamxjZXdVdWdnV0lM?=
 =?utf-8?B?aHFVZ2hzaUJKZUVORjUwd3NUejFFQi9wRHVYQlZybzNTeCtjR0d1WnpiWHpH?=
 =?utf-8?B?bVdzaUlwZERjUnVoSmViTXNrMjV1UzBwM05zWHpDRFR4S2FOdWRxNzlYN3B6?=
 =?utf-8?B?Z01LampGUmwzQUdMa3B1RnBHRTFIUU1mcE9XVFlNbGd2MldmYjFRSWVFazBC?=
 =?utf-8?B?T2pFa0F1cVAyT1ozNk5kUnVyZklHclN0djNQSUQxV000dEpmRzF1aGN6V0hK?=
 =?utf-8?B?MW8xU0hZSkJLUVRoNXZoZi8ycmUzMnJFdm9XckZ4cStaSWF2TDM4Sm01aHBh?=
 =?utf-8?B?MTI4eGtUMUZxQWNOdE9CcFQ5eGFJRUJJalJhU2VJcmdyM3c5WTBUdnIrNWd6?=
 =?utf-8?B?aC81MzVvd1NqQndITWpKQmNTVE56YStwbVgvVXRiUTRCRTYrazZNeEtUOHJQ?=
 =?utf-8?B?Y2Q3ck1JcllqbHVBSjVMbGJuck5JTmt5VWZXMENjLzVxdUp5Qms4Vys2S3pn?=
 =?utf-8?B?R3ozVGRxZDBmM1FldXo1SUd1ajB0MVBCM1RpY3NQK3JER3NaazdCWmZTajdT?=
 =?utf-8?B?QVNWZVVmcmx0K2NJeVRGNDhwTHY0cUoyWkh5SGl4RUVzTWgzaHFUeGV3YXlC?=
 =?utf-8?B?VmVnTUxYVkl1R1dMbURWd0JFYVphVGJRVjZ2Yk96VTJvdGlGbzFITTVOWDFs?=
 =?utf-8?B?UHV2Qy9nVGt4UGNReHRDTXg2U3RQTW0ycFh0MW5EeVlCQ1VHR1FZRWJ4cmlv?=
 =?utf-8?B?R2lLU1NDeURXNHpxMElRSTlCSDgrc3ArcUVuYkRWT3JGU3FKSTJjQjF3c3JJ?=
 =?utf-8?B?K1dzdFFObk1tNGI3QTNDRDl6TUNjbjYyOWtjb1d0dTlDaUZtdTByM0owcVBV?=
 =?utf-8?B?MitRZy9SeG5WWE1UWE9OMFhSQ2FCaTh1Vkk2dW1NQnlYUHBpY0w1S3pIZ21j?=
 =?utf-8?B?MDhNZXZBMGFabmFWM2RUdHI2bUZZS0JiSm13QWluWU4wc1oxdUFxTnpvYlJt?=
 =?utf-8?B?YXNld05aK1hBVjR5WlJnQ2pLVjRVRmIzU0RSWDEwTXVZY0RjS3JtQ0FEdW44?=
 =?utf-8?B?dzFLelhZUDU1MUFWSjRjcW9uRXNZRlg0SVVZaHM4SEN6dHlRbWYrK1BDNkpV?=
 =?utf-8?B?RCtVdCs5a0NFMHVaZ0k4OHd5UGlrVXMrb1kzclBnQUdUT0NBbkhCNGNrYWRL?=
 =?utf-8?B?VlRLL2doSThqK0FLU241MkVNRjlXbW1EdEtOSSsrQmMzaHQ3Mkx3MmhpNUFJ?=
 =?utf-8?B?dWtnWlR3cGlsV0JPTzlaVElmbldxRTBZaklwaG1Pc3lETG95aklHY1NZTnlz?=
 =?utf-8?B?cURZWnVmQ1R6Wmx6VHJ0K0NjNndIMkZSUnJ6Sk02Y2wxNFNoVUN6bmUwamV1?=
 =?utf-8?B?WTI2Ulc3M0RnMVBTNE41Y0x2dXUrK2NFTjIxUFQ4MlpoVHBaM2EvVFdUV1ZF?=
 =?utf-8?B?RDhTcEVHOXJUbVZoYjJ5aG1majNBS2tGNWRsM0VEcEtDTlZQdDMvWHExTGZQ?=
 =?utf-8?B?MHZJb3BSb3hjdlN1UUFBanBrZDQzTDh1L3pjQjExSmtEYkNjRmpMSDRjWDhG?=
 =?utf-8?B?QWhDRXo3VHE0UWdFMXRySXd5bTV6SFlvdFErekovUXF0QVQ4ZzkrWE1OaFlK?=
 =?utf-8?B?aE10d0pWbWRGV3dsQ2ZMRnVEZWt3YVRVOUk4VHBYRXVoNHRDUDVaVHQ5VWdX?=
 =?utf-8?B?cjR0dld4SHNJbDJ1ZkJKeVA3bHBmUjA1UWdQcWhwV2dBU1BiVFpuWnNlY1Fn?=
 =?utf-8?B?a3VTSzNPVjNSRjBEaVJ6dmMraXZWSXBsV0dhb2hmeGZOY2pVWXRqZ21lSEdX?=
 =?utf-8?B?ZitSSEZFSkRkbENpZFA4ZUZSWEhRd3QyWExaTXpLazhtU2o2Zi80T3lpM1p5?=
 =?utf-8?Q?+1Zt4eQBKVXFgUmI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B8F045F5CFB04479DB1190A493F631A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: rq9Rbt6lJZ+ZY4JCYQz1bxpca+UAFNYNRWBVqbBo9hwh59D6bhoAyPabfMhIGR4Gohmc4KzYNQ1BVZZuwq1aXl+jacvZ8akPL2U52tA+4MIX2cRUB2yary9rkPzlq5weZtbt+6+XDEkH3cRRvNKMu/DFcMRkArFd2N3Puixjp2V2BlVUeHQRitg0TgsSzd1+BY5kjfiT26I/LkY7fkfI4pZzuwKU4kuVDUGXP2Z7H2EmNfQMws1ANFlrbjsMroMvSMkJm6roEwD5BRi+3Dy+5S//+QthBhsB4RkDIfhm4KouDsPsEc9FzjL8i7DiswZEypZGjxawJh7kDqoOn4OSrg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d175b94-302f-417c-7e75-08de7df837cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2026 16:23:37.4126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JpWykgDH3JjIHoKt9H051rNPJyd3Fsf69jMoh1nTn1ovuxf3gJfdi7QuGDGFU3D9vHxLwoY6pDDwaoKNiVlDYEwPXo0+mg33OGi9ssjZm68=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF37A184CA6
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 1512023CBB3
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73331-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[16];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAzLTA5IGF0IDAwOjIzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBG
ZWVsIGZyZWUgdG8gYWRkOg0KPiANCj4gQWNrZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGlu
dGVsLmNvbT4NCj4gDQo+IEJ0dywgdGhlcmUncyBhIGZ1bmN0aW9uYWwgY2hhbmdlIGhlcmUsIGFu
ZCBwZXJoYXBzIHdlIHNob3VsZCBjYWxsIG91dA0KPiBpbiBjaGFuZ2Vsb2c6DQoNClllYSB0aGF0
IG1ha2VzIHNlbnNlLg0KDQo+IA0KPiAtIEN1cnJlbnRseSB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zv
cl9rZXhlYygpIGlzIGRvbmUgaW4NCj4ga3ZtX2Rpc2FibGVfdmlydHVhbGl6YXRpb25fY3B1KCks
IHdoaWNoIGlzIGFsc28gY2FsbGVkIGJ5IEtWTSdzIENQVUhQDQo+IG9mZmxpbmUoKSBjYWxsYmFj
ay7CoCBTbyB0ZHhfY3B1X2ZsdXNoX2NhY2hlX2Zvcl9rZXhlYygpIGlzIGV4cGxpY2l0bHkNCj4g
ZG9uZSBpbiBURFggY29kZSBpbiBDUFUgb2ZmbGluZS4NCj4gDQo+IC0gV2l0aCB0aGlzIGNoYW5n
ZSwgdGR4X2NwdV9mbHVzaF9jYWNoZV9mb3Jfa2V4ZWMoKSBpcyBub3QgZXhwbGljaXRseQ0KPiBk
b25lIGluIFREWCBjb2RlIGluIENQVSBvZmZsaW5lLg0KPiANCj4gQnV0IEFGQUlDVCB0aGlzIGlz
IGZpbmUsIHNpbmNlIElJVUMgdGhlIFdCSU5WRCBpcyBhbHdheXMgZG9uZSB3aGVuDQo+IGtlcm5l
bCBvZmZsaW5lcyBvbmUgQ1BVIChzZWUgWypdKSwgaS5lLiwgdGhlIGN1cnJlbnQNCj4gdGR4X2Nw
dV9mbHVzaF9jYWNoZV9mb3Jfa2V4ZWMoKSBkb25lIGluIEtWTSdzIENQVUhQIGlzIGFjdHVhbGx5
DQo+IHN1cGVyZmx1b3VzLg0KPiANCj4gWypdIFNlZToNCj4gDQo+IAluYXRpdmVfcGxheV9kZWFk
KCkgLT4NCj4gCQljcHVpZGxlX3BsYXlfZGVhZCgpO8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqANCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCANCj4gwqDCoMKgwqDCoMKgwqDCoAlobHRfcGxheV9k
ZWFkKCk7DQo+IA0KPiBjcHVpZGxlX3BsYXlfZGVhZCgpIGNhbiBpbnZva2UgZGlmZmVyZW50IGVu
dGVyX2RlYWQoKSBjYWxsYmFja3MNCj4gZGVwZW5kaW5nIG9uIHdoYXQgaWRsZSBkcml2ZXIgaXMg
YmVpbmcgdXNlZCwgYnV0IEFGQUlDVCBldmVudHVhbGx5IGl0DQo+IGVuZHMgdXAgY2FsbGluZyBl
aXRoZXIgYWNwaV9pZGxlX3BsYXlfZGVhZCgpIG9yIG13YWl0X3BsYXlfZGVhZCgpLA0KPiBib3Ro
IG9mIHdoaWNoIGRvZXMgV0JJTlZEIGJlZm9yZSBnb2luZyB0byBpZGxlLg0KPiANCj4gSWYgY3B1
aWRsZV9wbGF5X2RlYWQoKSBkb2Vzbid0IGlkbGUgc3VjY2Vzc2Z1bGx5LCB0aGUgaGx0X3BsYXlf
ZGVhZCgpDQo+IHdpbGwgdGhlbiBXQklOVkQgYW5kIGhsdC4NCj4gDQo+IEFjdHVhbGx5LCBhZnRl
ciBsb29raW5nIGF0IG11bHRpcGxlIGNvbW1pdHMgYXJvdW5kIGhlcmUsIGUuZy4sDQo+IA0KPiDC
oCBlYTUzMDY5MjMxZjkzICgieDg2LCBob3RwbHVnOiBVc2UgbXdhaXQgdG8gb2ZmbGluZSBhIHBy
b2Nlc3NvciwgZml4DQo+IHRoZSBsZWdhY3kgY2FzZSIpDQo+IMKgIGRmYmJhMjUxOGFhYzQgKCJS
ZXZlcnQgIkFDUEk6IHByb2Nlc3NvcjogaWRsZTogT25seSBmbHVzaCBjYWNoZSBvbg0KPiBlbnRl
cmluZyBDMyIpDQo+IA0KPiAuLi4gSSBiZWxpZXZlIGl0J3MgYSBrZXJuZWwgcG9saWN5IHRvIG1h
a2Ugc3VyZSBjYWNoZSBpcyBmbHVzaGVkIHdoZW4NCj4gaXQgb2ZmbGluZXMgYSBDUFUgKHdoaWNo
IG1ha2VzIHNlbnNlIGFueXdheSBvZiBjb3Vyc2UpLCBJIGp1c3QNCj4gY291bGRuJ3QgZmluZCB0
aGUgZXhhY3QgY29tbWl0IHNheWluZyB0aGlzIChvciBJIGFtIG5vdCBzdXJlIHdoZXRoZXINCj4g
dGhlcmUncyBzdWNoIGNvbW1pdCkuDQo+IA0KPiANClRoYW5rcyBmb3IgdGhlIGFuYWx5c2lzLg0K
DQo+IEJ0dzIsIGtpbmRhIHJlbGF0ZWQgdG8gdGhpcywgY291bGQgeW91IGhlbHAgcmV2aWV3Og0K
PiANCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDI2MDMwMjEwMjIyNi43NDU5LTEt
a2FpLmh1YW5nQGludGVsLmNvbS8NCg0KV2VsbCBJIHRoaW5rIEkgd3JvdGUgdGhlIGxvZyBmb3Ig
aXQuIEJ1dCBJIHllYSBJJ2xsIGFkZCBhIHRhZy4NCg==

