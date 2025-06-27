Return-Path: <kvm+bounces-50928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E155EAEAC04
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E18DE3BB87C
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 00:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8C662AD31;
	Fri, 27 Jun 2025 00:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JgnntNKw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E349460;
	Fri, 27 Jun 2025 00:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750985556; cv=fail; b=RqwnrTYhzYIxr1/BKTLo/h+mUImt9Ixspk5+cPs1XO6MNYdX8LWJtIm7zrCNmTtJseJV7vfF31wuflZjOcNgXpIuwYcI6qEHR5I137vOwicL4tqFZKrN89a8seHGBMTmYNStXt/RlEBSK1Y++0wwQ8KD61eMY4AqP8qdDoHcAjU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750985556; c=relaxed/simple;
	bh=NB72kTYnmAAKVx+tZPya44WG8pVqo5oU0Dl7CPgZgBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QDrBv9TGsnWkx5L/WCpMNcjS8xVpasxt17HDZRTSkImwvjn/mc4AKtqywsBf5jPFHvW8NP/c1VtFW1MNptG18ln21OsP5S/IAut5d7i3xwe87DlqBq/8p7H0/Ng4iXpmo968GorePs7uFZSdMG5XJ+1Qz1QXurhmE7UWg9IsGZU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JgnntNKw; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750985555; x=1782521555;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NB72kTYnmAAKVx+tZPya44WG8pVqo5oU0Dl7CPgZgBE=;
  b=JgnntNKwZgVPPo74gXp9htJqT49elcq2a+lWsusnSF53abmZQkjo9dsJ
   63MQKo2XP1RncB987MF6JVxgTcHBI2aXIhpMP/kndtQhBxOF8Czmmly3Q
   QyaV3eIvZjse88RVLFJYeGZ4xTbEpTGWwNQtbYY9PZX7VN9YUGo4vM3GQ
   hqUp3cDZD7anEGxBxHS95xsW+WKPxKcu0kiY0g7+/FV9m6Z5GCX2x3j/3
   iTV2PFr5JSb7DD/XeVp5WC7FI3oY0DOPtuiaT6dfkJeOx4X85xt9ZCLtx
   WVzOuDdX7DWYZqTDNPNajSHeFq7Bv49OpWV0bEqoowy0nj2x7qP4efOBM
   w==;
X-CSE-ConnectionGUID: IHiDY6s5TQK+l2iAW2mmMQ==
X-CSE-MsgGUID: UWtrIa/WTA6Zdba9r/gGcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63556148"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="63556148"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:52:34 -0700
X-CSE-ConnectionGUID: 04Mr/ngpRKeKJJebNa4sxA==
X-CSE-MsgGUID: FZBGCWC3R1WTqhfy5S0MnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="158149169"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 17:52:33 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:52:32 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 17:52:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.84)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 17:52:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ipJIg9BXHkvQJifc2DXdRt8xpOehiR7gqw20vz/eYSNC+acsaYBxtrGKyGgfvd9KKKID5HEE9RQY+dFQrZpFwpG9Yv8aVPdzslaky7xVHQcAmT0MRC+tIIu4F6QpzbMLS/X00lb8+PsHRwAA2SgL5DLmny1iFD2iH1w3HwXOcZOEVk2S0fMnqdBKC33P1CKZm45TuhJnyIx1d0X8jiUM47z15UCcRwLH6Q6KGotOGbVdyUVg8k5mtBQb58MsbLUYeIBquxChS7cJXof0GEIjliGmTLnAn6WgpkkvTb0PPkmNQEt/67HYUj+2em+jtRIjdZsHrUFdJKg3x1QMTJHDTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NB72kTYnmAAKVx+tZPya44WG8pVqo5oU0Dl7CPgZgBE=;
 b=jcrXAg3XFD2XnTWpiHw2upp4I8ldWu36FSRhp3WUWl44BE+SuBxupJI42h7uvLcAunQJ6SzppWFF4QG4gPUWS7Q9W1UCCK72G+WpYjEVtd9CVCIVBAs/PQ5RWqg2Lx+TPFL2RcYhcQeIdJROww8IiI6k0YSgwafSlAncWVs3DRGN2Oohyyz6nO2SBqaehZU/bcSoRSLlzxw/M1AnYOV+ZzrwK/GFS6+V5SBtxALE3HRmBAGvmXJ80l92gEDpg8FsufBnqh2TwLFPPQYvVW7Mbqb7SJGKNZEN8gbDgJYOLhO3OLLniqcX80ItfgYVS+pO5seZZ8+J2yki6HsUcyx8VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ1PR11MB6178.namprd11.prod.outlook.com (2603:10b6:a03:45b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Fri, 27 Jun
 2025 00:52:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Fri, 27 Jun 2025
 00:52:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Huang, Kai" <kai.huang@intel.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>
CC: "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>, "sagis@google.com"
	<sagis@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Chen, Farrah" <farrah.chen@intel.com>
Subject: Re: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb5ogI6Y7iL9CkW0uTZON0g1sc7rQVxZ+AgABTegCAABVQgA==
Date: Fri, 27 Jun 2025 00:52:22 +0000
Message-ID: <5049e63e22c66aa0a97912417c29eff007468ab4.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <323dc9e1de6a2576ca21b9c446480e5b6c6a3116.1750934177.git.kai.huang@intel.com>
	 <554c46b80d9cc6c6dce651f839ac3998e9e605e1.camel@intel.com>
	 <0d32d58cb9086906897dada577d9473b04531673.camel@intel.com>
In-Reply-To: <0d32d58cb9086906897dada577d9473b04531673.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ1PR11MB6178:EE_
x-ms-office365-filtering-correlation-id: e51a8c5e-10ab-417d-ba79-08ddb514e0bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?aGhvaVZmM2tEcEo0aUxpYkFIblBvckdtMTZDZW94V29FazY4cTdjTjVOQW5H?=
 =?utf-8?B?SnQ4SS8zVWc2bVRad2tVUEd5QWpMSytRQk1EQzRJYXhUQlVoUUhBdlBNQVNj?=
 =?utf-8?B?bUZrU05jbVNEYjlCUXcxUVN1NHM5cWZZMFZFb3lJR0I3Tk9haWQ5djJGMTc0?=
 =?utf-8?B?dFdVT3ZjeHFOVnM5cjZBc0lEbzNncnlIT3JCYzh1UURiYmUvNFRhOFJoS0ht?=
 =?utf-8?B?UzdGckNqcGJGemcvck9QbldtSEYwRHd3UUlSTTkxeC95MExWSTd6dUF2dk0r?=
 =?utf-8?B?ZHllNk84YzRwSmtyRXQ3R21HTjRCT3VKVDFRRVRHb3lQTTZSSG9TWFJGTWJ2?=
 =?utf-8?B?TWc2UTdlTW00WXMxeEFjWnEyaU1nVmhETEkwMHYwdm5ibmY3SUZJNFdLSllQ?=
 =?utf-8?B?R2hSckpjNW42YXV0bUdiZ2JnQjBIcjZLS3Z6T0JWRWxYdGRtdVprWVgrcVdv?=
 =?utf-8?B?cEZrRHpBUWVuK3daeDNQVUZOSlpJMXY4VGU4RTVWSW1kZTRMbGxWZkswdExO?=
 =?utf-8?B?RS84b244YUNSR3VTYmROTXFVUE5oYzNVQUoyM0pyRS9oV0t2dlBZVmltZTVS?=
 =?utf-8?B?eE1wdWd6ZWlNTWZvK3gwYlR1UDRabDIvOWp0ODlxazZucmFDcE1lb0FweVhE?=
 =?utf-8?B?N05kaVJRWTNOd0FBS1VRTGJYUXMxM2l0cEhXWW1rSDBTb01FK3hGell1ZkVX?=
 =?utf-8?B?Yy81VmFiaTA5SkxtVkVVTG5wNHpUSkM2WGNzMW9iemlweSt3ODlsZnlBakd0?=
 =?utf-8?B?SjA4emlhdStVU3RSM3E5S0xjZnNBWDk5ZDA3RlhFaHl6T0tvTDBpcWZYYVBp?=
 =?utf-8?B?b1FSdDJYR1VON2FXWkpacEM4bHN1Zmpwd2NCdkJPclZtekhZdHc4YVFac056?=
 =?utf-8?B?c0s0amxIaXY0dm1nbWkvbUFGQzFhanBJWUVOZE1ucDZBU0pLMlpsUjhGZGpi?=
 =?utf-8?B?dmF2a1ArYkY5VWJsTWlPRTRuU2lPNUZ1dkI0MnRDdW42YTRiWTZOcTZHL01s?=
 =?utf-8?B?NFRCWlUzaTBmK1JmblBGb242WHlieU50QjdtRE96LzZrMWtrdHQ2MHpsQkdu?=
 =?utf-8?B?Mmh0ZWk3cVFhQ3BodzFCV3NqSm1PWVF6Ty9RSkxmb2REL2xlR0taQk85ejZK?=
 =?utf-8?B?S1ZicmxwckZ6WlJ6MWgwbUxkYXZ5RkhYRThoRmhiU3BZbUNyNGZkWG9FRUpm?=
 =?utf-8?B?RjNsbmpNWXFnSDB1TnVHSE1MMjl0Z0ZxTDVFUnVzblF1dlpHeXRzL25rc3Fn?=
 =?utf-8?B?Q3ZSSmZpcFJRRlZxOWR6ODBGUjBkcWduL0U5ZS85NUZCUGlQWlRUT2Y5MSta?=
 =?utf-8?B?UVp2R0Uwdys3Z2EvMXhhWkI3SjgwMGpkZ1RWd3dDSTV1VW5VdFcwMzBVU3B0?=
 =?utf-8?B?dDZKYndTMmdUemhSWHp6MzlSREpLRnpCNkpmR0lXeWZMNTdWbkpWWVJ2Qkda?=
 =?utf-8?B?bEtCVEdIWVlEY2g5S1p4SitwS0JKYURlKzkzZEFOenY4MHRubDB2dzBhMzQ2?=
 =?utf-8?B?dE5haXJXMGgwTVNQeVJTR3VqRktXNzZGa2hiQmZ2d3BXek1aR2czVHNITWI1?=
 =?utf-8?B?OWxySlhXTnE4ZkRXNjlCcitCM2thekVzUG13ZExVNjErZzFNbUh2VHJCbm05?=
 =?utf-8?B?TGJyc2gzV2RLeEpKZUxhMG9mSjAyWk0yK1o4cUFwWXpjK3kxWkErMVZKb1dk?=
 =?utf-8?B?azNTbDVWOUJqZFptemJYaFg2b1NBR1ZvWjQ5bElzUWJYeFdtUTFGbFFHeG9s?=
 =?utf-8?B?NFRUcm95ZDdxL3dSbHFteWtHWDYvYlRnbUZNWnk4V1NudlVOdVhIOEY5K3oz?=
 =?utf-8?B?Q0dYNDJ4TnZRYkVzb3p6ZE93RnN4ZitzUU1hT2NVVkRkdXBscVB0ZTJ5bjRx?=
 =?utf-8?B?Tk9wVnMwU2t0MHU3QW1na2Qzb0VaS1BURTd6cG1xdXBvM1YvZkR1aGFpc1h4?=
 =?utf-8?B?Q2tLdFltYzFhL0swVUNhL2xDeG0wQ3IzQ0ttSjRjbWE1cEpNRFNBRHE4TTJ3?=
 =?utf-8?B?eHNyWlBSd2dNRWlBNHo2V1ZacWM5KzZtc3M2VG5GWThKYWJ6N2FmeEVpL2Vk?=
 =?utf-8?Q?tzZr94?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmduSjNONGM1Nzh1cHZCTGgzUjBaZmdqSlRGSzFMR0VnZmJ2MTFiMHhoYmtD?=
 =?utf-8?B?UFk4RFR5dklkQ1NnS0ZKSjczemZzTVplNzJrYnJTeEY2SlYyLzJTR09EcXU1?=
 =?utf-8?B?bTJndmZNTUZZa09JdHorMjZWMExzcHBRckZBaFExb1dFa05GSUl6aGhrTkg2?=
 =?utf-8?B?RmxNMHlHQnY5S0s0R2ZVTHVtTlJlbXRpN0ZxZng4SzN0cXNpYzFRRzlkTUtX?=
 =?utf-8?B?Qi9CQWQ3eFhLZ01HUGVVRmR6L25jQmZDTmhBK2ZuVXIreG1Ndm9WeTcwRGdU?=
 =?utf-8?B?dzJGZXoyUUFoMzZJUkxzd1V1TTRWNHI5SG5yWmx2TDRoQTJrOWlhMTRZMEps?=
 =?utf-8?B?d1NKWnBJb1NZSnBUbGxtTW9FTEZvampOVmhRemFZeUdHYnNvMVVZK1d6VStt?=
 =?utf-8?B?UkZ6STNTNklZK1hQSS92U1VxdHc3Y21oMnhRNnVwRFdXdDFTWjBySG1TQml2?=
 =?utf-8?B?dEtXUCtqa1AyQUY5aFNrME02dlRzU052ZnlEOUY3YmxrZEFTV3lmUE9YYkox?=
 =?utf-8?B?eGtZWGV3UWJMY0xHYWhjWEtnbnVSQ2puTWV2Slh3bmt6ejF1L0ZoM25YVE5o?=
 =?utf-8?B?U2NuYmRtSUlVT0pEWnFJRFVpZjRIN3ZCUnFRaG1LMzBZNVpCTEZTSFFPNkFY?=
 =?utf-8?B?dEk0RzdtOC9yYjcvTnkyWGRyOWVJYmR0TllhQ0g2K2JTNGtsZitLZHJkTHhM?=
 =?utf-8?B?MmNNS2twd052b2cya0NvQ2cxZlg0bUk3bWhDbnh1U0Y3MHN6NnUvQVZ2Z1Fa?=
 =?utf-8?B?Zko1aWxITVVCUTZUOGVvWU5xZG05OE8rc1BMZW1kd25NNmFPeFdMbFl6YkFs?=
 =?utf-8?B?a3MwN1pZeVprRmNtTmtGamVHRk9PU0hFb0ZQMmsrSWxUTTNQazVQbG5ncm5J?=
 =?utf-8?B?WndZVUorOVk2N1ZJN3QyVm82UlFBdEMvK29ubXA4V2ZqRVF2V0hqMVBaYWlm?=
 =?utf-8?B?cW5ua3h3aFZFSnZISVdIZDg3TkxuT1JJTUN1ZkMrVDJkQ0tHVXc2YStpUDhL?=
 =?utf-8?B?Yk83MzlFa0RPSkxWSkJMUHgvaEFkbDZFSzgwUDUweE5CaVZiUjh2SzNidEZz?=
 =?utf-8?B?dlFxU1ZmTVU4dC9RajFQSkYwVjcwUGVlZ3REczFlYjBCYU5WL2tKbWlyemVq?=
 =?utf-8?B?WG5uakJ5eW4vbktHQ002ZHpkaHZJdGJvV3VOVDN0TUgwd3JrMHpVeXJKUWRQ?=
 =?utf-8?B?QnA4cjZZQUtpVU5WeU8welBScW9WNkFYNFVXOHlLanBsZnlDeTI4V0NZREh1?=
 =?utf-8?B?NWg4dE90TUtDakpLQ2YvQVZNclpJWGtLVVY4OUtqY1Nva3ViV1RCVXAyWlJ6?=
 =?utf-8?B?SDNDYnQ1US91UEQwOFhrTTJQcWxjSnNtclQ3QTVsTEkzeW54NmdsTWJKOWUr?=
 =?utf-8?B?UEVDV1YzRk8yV2U0dGVveVRXUVRlaTVyMU4wUjFZUTBwSWMxTlZNYkhwNTZC?=
 =?utf-8?B?THEyUFQ0YXV6dm5KcFpIeS85SVdyQ01JS2dqTy9hU3ZTUHZSOCt1aUR1VDBy?=
 =?utf-8?B?RlNzeldKSUFyYTVQK1hMRlh5dEhFWlNPUFVkMnVUZis3WkVwTnQvZ1FNOTZX?=
 =?utf-8?B?SmdvUU1HcUE0TExZeW9GYVNnTDlWaUpDL2k5NXZqN01yWThIajhza0hjR0lQ?=
 =?utf-8?B?Vk1hck42K3ZGOVQyS2FnMWNUMFJCb21XNmJDdm4vbEJaT0JuR294UEJPMnVk?=
 =?utf-8?B?VUU0YnB2YU9JdXlKQXExMWtxSjAyYXViUE1mZXY4YzFaOE4zbVAxTnViUHBS?=
 =?utf-8?B?RFZpbU94L0ltMjRMQW95c1Zpb3FpWHVqMmdpSXNFdnNOQ1NsZEM4amQwR3g0?=
 =?utf-8?B?aXBWZ3lzWHpVZDZ0N0ZHWjIrVTVhS1ZyTXlkR1AwMWR6RktWcXBCV2l5RjdF?=
 =?utf-8?B?Ymg2dmlaMm1LeVJjTGMwVDlBZ3E0SENRbkFPNk9Hc3A5N0E0UytoSG5oaVRF?=
 =?utf-8?B?WUp2WU15aUYxN3U2S3U4NzEyR2ZWUkNGcjdPUFFBYnpwM0RHTCtsLzJnV3dk?=
 =?utf-8?B?L0hxdUVSbEMxN1Nkc1FNMjRlZitzN3RFWFpXYnNRckJIaFFtS3QrV0Q2SXdS?=
 =?utf-8?B?VER1WFp1ZGI5UTVocTBZWktPaWFob2pmMERiUUtrR1BWRXcxdXJYbTd1ZXBz?=
 =?utf-8?B?NVk0ODhXVGZPY1ZlaWtnWW40Tk0vRmNiZkpRNk9TS1lXRDY0OEc4citjVHR1?=
 =?utf-8?Q?T+4PfCQfaNPYCY339JsSn5Q=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C7AEE262EA2AD44B3F3FE5CD33F401E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51a8c5e-10ab-417d-ba79-08ddb514e0bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 00:52:23.0545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IJRQlFDpx3kpXSCuKEtawk3+FOZxziCDvs7rwsDYbScvF35wB5r4+T4rk7DhgQ9Z6MUG9S9eCnM3hG6lCRdSjGKEPiOqXRti+xYKUD/5tgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6178
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDIzOjM2ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAo
SSdsbCBmaXggYWxsIHdvcmRpbmcgY29tbWVudHMgYWJvdmUpDQo+IA0KPiA+ID4gDQo+ID4gPiB2
MiAtPiB2MzoNCj4gPiA+ICAtIENoYW5nZSB0byB1c2UgX19hbHdheXNfaW5saW5lIGZvciBkb19z
ZWFtY2FsbCgpIHRvIGF2b2lkIGluZGlyZWN0DQo+ID4gPiAgICBjYWxsIGluc3RydWN0aW9ucyBv
ZiBtYWtpbmcgU0VBTUNBTEwuDQo+ID4gDQo+ID4gSG93IGRpZCB0aGlzIGNvbWUgYWJvdXQ/DQo+
IA0KPiBXZSBoYWQgYSAibWlzc2luZyBFTkRCUiIgYnVpbGQgd2FybmluZyByZWNlbnRseSBnb3Qg
Zml4ZWQsIHdoaWNoIHdhcyBjYXVzZWQNCj4gYnkgY29tcGlsZXIgZmFpbHMgdG8gaW5saW5lIHRo
ZSAnc3RhdGljIGlubGluZSBzY19yZXRyeSgpJy4gIEl0IGdvdCBmaXhlZCBieQ0KPiBjaGFuZ2lu
ZyB0byBfX2Fsd2F5c19pbmxpbmUsIHNvIHdlIG5lZWQgdG8gdXNlIF9fYWx3YXlzX2lubGluZSBo
ZXJlIHRvbw0KPiBvdGhlcndpc2UgdGhlIGNvbXBpbGVyIG1heSBzdGlsbCByZWZ1c2UgdG8gaW5s
aW5lIGl0Lg0KDQpPaCwgcmlnaHQuDQo+IA0KPiBTZWUgY29tbWl0IDBiM2JjMDE4ZTg2YSAoIng4
Ni92aXJ0L3RkeDogQXZvaWQgaW5kaXJlY3QgY2FsbHMgdG8gVERYIGFzc2VtYmx5DQo+IGZ1bmN0
aW9ucyIpDQo+ICANCj4gPiANCj4gPiA+ICAtIFJlbW92ZSB0aGUgc2Vuc3RlbmNlICJub3QgYWxs
IFNFQU1DQUxMcyBnZW5lcmF0ZSBkaXJ0eSBjYWNoZWxpbmVzIG9mDQo+ID4gPiAgICBURFggcHJp
dmF0ZSBtZW1vcnkgYnV0IGp1c3QgdHJlYXQgYWxsIG9mIHRoZW0gZG8uIiBpbiBjaGFuZ2Vsb2cg
YW5kDQo+ID4gPiAgICB0aGUgY29kZSBjb21tZW50LiAtLSBEYXZlDQo+ID4gPiANCj4gPiA+IC0t
LQ0KPiA+ID4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oIHwgMjkgKysrKysrKysrKysrKysr
KysrKysrKysrKysrKy0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwg
MSBkZWxldGlvbigtKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVk
ZS9hc20vdGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiA+ID4gaW5kZXggN2Rk
ZWYzYTY5ODY2Li5kNGM2MjRjNjlkN2YgMTAwNjQ0DQo+ID4gPiAtLS0gYS9hcmNoL3g4Ni9pbmNs
dWRlL2FzbS90ZHguaA0KPiA+ID4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4g
PiA+IEBAIC0xMDIsMTAgKzEwMiwzNyBAQCB1NjQgX19zZWFtY2FsbF9yZXQodTY0IGZuLCBzdHJ1
Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gPiA+ICB1NjQgX19zZWFtY2FsbF9zYXZlZF9y
ZXQodTY0IGZuLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gPiA+ICB2b2lkIHRk
eF9pbml0KHZvaWQpOw0KPiA+ID4gIA0KPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9wcmVlbXB0Lmg+
DQo+ID4gPiAgI2luY2x1ZGUgPGFzbS9hcmNocmFuZG9tLmg+DQo+ID4gPiArI2luY2x1ZGUgPGFz
bS9wcm9jZXNzb3IuaD4NCj4gPiA+ICANCj4gPiA+ICB0eXBlZGVmIHU2NCAoKnNjX2Z1bmNfdCko
dTY0IGZuLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gPiA+ICANCj4gPiA+ICtz
dGF0aWMgX19hbHdheXNfaW5saW5lIHU2NCBkb19zZWFtY2FsbChzY19mdW5jX3QgZnVuYywgdTY0
IGZuLA0KPiA+ID4gKwkJCQkgICAgICAgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncykNCj4g
PiA+ICt7DQo+ID4gDQo+ID4gU28gbm93IHdlIGhhdmU6DQo+ID4gDQo+ID4gc2VhbWNhbGwoKQ0K
PiA+IAlzY19yZXRyeSgpDQo+ID4gCQlkb19zZWFtY2FsbCgpDQo+ID4gCQkJX19zZWFtY2FsbCgp
DQo+ID4gDQo+ID4gDQo+ID4gZG9fc2VhbWNhbGwoKSBpcyBvbmx5IGNhbGxlZCBmcm9tIHNjX3Jl
dHJ5KCkuIFdoeSBhZGQgeWV0IGFub3RoZXIgaGVscGVyIGluIHRoZQ0KPiA+IHN0YWNrPyBZb3Ug
Y291bGQganVzdCBidWlsZCBpdCBpbnRvIHNjX3JldHJ5KCkuDQo+IA0KPiBJdCdzIGp1c3QgbW9y
ZSByZWFkYWJsZSBpZiB3ZSBoYXZlIHRoZSBkb19zZWFtY2FsbCgpLiAgSXQncyBhbHdheXMgaW5s
aW5lZA0KPiBhbnl3YXkuDQoNCkRvbid0IHlvdSB0aGluayB0aGF0IGlzIGEgcXVlc3Rpb25hYmxl
IGNoYWluIG9mIG5hbWVzPyBJIHdhcyB0aGlua2luZyB0aGF0IHdlDQptaWdodCB3YW50IHRvIGRv
IGEgZnV0dXJlIGNsZWFudXAgb2YgYWxsIHRoZXNlIHdyYXBwZXJzLiBCdXQgSSB3b25kZXJlZCBp
ZiBpdA0Kd2FzIG9uZSBvZiB0aG9zZSAibGVhc3Qgd29yc2UiIG9wdGlvbnMga2luZCBvZiB0aGlu
Z3MsIGFuZCB5b3UgYWxyZWFkeSB0cmllZA0Kc29tZXRoaW5nIGFuZCB0aHJldyB5b3VyIGhhbmRz
IHVwLiBJIHRoaW5rIHRoZSBleGlzdGluZyBsYXllcnMgYXJlIGFscmVhZHkNCnF1ZXN0aW9uYWJs
ZS4gV2hpY2ggd2UgZG9uJ3QgbmVlZCB0byBjbGVhbnVwIGZvciB0aGlzIHNlcmllcy4NCg0KPiAN
Cj4gPiANCj4gPiBPaCwgYW5kIF9fc2VhbWNhbGxfKigpIHZhcmlldHkgaXMgY2FsbGVkIGRpcmVj
dGx5IHRvbywgc28gc2tpcHMgdGhlDQo+ID4gZG9fc2VhbWNhbGwoKSBwZXItY3B1IHZhciBsb2dp
YyBpbiB0aG9zZSBjYXNlcy4gU28sIG1heWJlIGRvX3NlYW1jYWxsKCkgaXMNCj4gPiBuZWVkZWQs
IGJ1dCBpdCBuZWVkcyBhIGJldHRlciBuYW1lIGNvbnNpZGVyaW5nIHdoZXJlIGl0IHdvdWxkIGdl
dCBjYWxsZWQgZnJvbS4NCj4gPiANCj4gPiBUaGVzZSB3cmFwcGVycyBuZWVkIGFuIG92ZXJoYXVs
IEkgdGhpbmssIGJ1dCBtYXliZSBmb3Igbm93IGp1c3QgaGF2ZQ0KPiA+IGRvX2RpcnR5X3NlYW1j
YWxsKCkgd2hpY2ggaXMgY2FsbGVkIGZyb20gdGRoX3ZwX2VudGVyKCkgYW5kIHNjX3JldHJ5KCku
DQo+IA0KPiBSaWdodC4gIEkgZm9yZ290IFRESC5WUC5FTlRFUiBhbmQgVERIX1BIWU1FTV9QQUdF
X1JETUQgYXJlIGNhbGxlZCBkaXJlY3RseQ0KPiB1c2luZyBfX3NlYW1jYWxsKigpLg0KPiANCj4g
V2UgY2FuIG1vdmUgcHJlZW1wdF9kaXNhYmxlKCkvZW5hYmxlKCkgb3V0IG9mIGRvX3NlYW1jYWxs
KCkgdG8gc2NfcmV0cnkoKQ0KPiBhbmQgaW5zdGVhZCBhZGQgYSBsb2NrZGVwX2Fzc2VydF9wcmVl
bXB0aW9uX2Rpc2FibGVkKCkgdGhlcmUsIGFuZCB0aGVuDQo+IGNoYW5nZSB0ZGhfdnBfZW50ZXIo
KSBhbmQgcGFkZHJfaXNfdGR4X3ByaXZhdGUoKSB0byBjYWxsIGRvX3NlYW1jYWxsKCkNCj4gaW5z
dGVhZC4NCg0KQ2FuIHlvdSBwbGF5IGFyb3VuZCB3aXRoIGl0IGFuZCBmaW5kIGEgZ29vZCBmaXg/
IEl0IG5lZWRzIHRvIG1hcmsgdGhlIHBlci1jcHUNCnZhciBhbmQgbm90IGNhdXNlIHRoZSBpbmxp
bmUgd2FybmluZ3MgZm9yIHRkaF92cF9lbnRlcigpLg0KDQo+IA0KPiA+IA0KPiA+IE9oIG5vLCBh
Y3R1YWxseSBzY3JhdGNoIHRoYXQhIFRoZSBpbmxpbmUvZmxhdHRlbiBpc3N1ZSB3aWxsIGhhcHBl
biBhZ2FpbiBpZiB3ZQ0KPiA+IGFkZCB0aGUgcGVyLWNwdSB2YXJzIHRvIHRkaF92cF9lbnRlcigp
Li4uwqBXaGljaCBtZWFucyB3ZSBwcm9iYWJseSBuZWVkIHRvIHNldA0KPiA+IHRoZSBwZXItY3B1
IHZhciBpbiB0ZHhfdmNwdV9lbnRlcl9leGl0KCkuIEFuZCB0aGUgb3RoZXIgX19zZWFtY2FsbCgp
IGNhbGxlciBpcw0KPiA+IHRoZSBtYWNoaW5lIGNoZWNrIGhhbmRsZXIuLi4NCj4gDQo+IHRoaXNf
Y3B1X3dyaXRlKCkgaXRzZWxmIHdvbid0IGRvIGFueSBmdW5jdGlvbiBjYWxsIHNvIGl0J3MgZmlu
ZS4NCj4gDQo+IFdlbGwsIGxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25fZGlzYWJsZWQoKSBkb2Vz
IGhhdmUgYSBXQVJOX09OX09OQ0UoKSwgYnV0DQo+IEFGQUlDVCB1c2luZyBpdCBpbiBub2luc3Ry
IGNvZGUgaXMgZmluZToNCg0KSSB3YXMgbG9va2luZyBhdCBwcmVlbXB0X2xhdGVuY3lfc3RhcnQo
KS4gQnV0IHllYSwgaXQgbG9va2VkIGxpa2UgdGhlcmUgd2VyZSBhDQpmZXcgdGhhdCAqc2hvdWxk
bid0KiBiZSBub24taW5saW5lZCwgYnV0IGFzIHdlIHNhdyByZWNlbnRseS4uLg0KDQo+IA0KPiAv
KiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICANCj4gICogVGhpcyBpbnN0cnVtZW50YXRpb25fYmVnaW4oKSBpcyBz
dHJpY3RseSBzcGVha2luZyBpbmNvcnJlY3Q7IGJ1dCBpdCAgICAgDQo+ICAqIHN1cHByZXNzZXMg
dGhlIGNvbXBsYWludHMgZnJvbSBXQVJOKClzIGluIG5vaW5zdHIgY29kZS4gSWYgc3VjaCBhIFdB
Uk4oKQ0KPiAgKiB3ZXJlIHRvIHRyaWdnZXIsIHdlJ2QgcmF0aGVyIHdyZWNrIHRoZSBtYWNoaW5l
IGluIGFuIGF0dGVtcHQgdG8gZ2V0IHRoZSANCj4gICogbWVzc2FnZSBvdXQgdGhhbiBub3Qga25v
dyBhYm91dCBpdC4NCj4gICovICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQo+ICNkZWZpbmUgX19XQVJOX0ZMQUdT
KGNvbmRfc3RyLCBmbGFncykgICAgICAgICAgICAgICAgICAgICAgICAgICBcICAgICAgICAgIA0K
PiBkbyB7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXCAgICAgICAgICANCj4gICAgICAgICBfX2F1dG9fdHlwZSBfX2ZsYWdzID0gQlVH
RkxBR19XQVJOSU5HfChmbGFncyk7ICAgICAgICAgIFwgICAgICAgICAgDQo+ICAgICAgICAgaW5z
dHJ1bWVudGF0aW9uX2JlZ2luKCk7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcICAg
ICAgICAgIA0KPiAgICAgICAgIF9CVUdfRkxBR1MoY29uZF9zdHIsIEFTTV9VRDIsIF9fZmxhZ3Ms
IEFOTk9UQVRFX1JFQUNIQUJMRSgxYikpOyBcICANCj4gICAgICAgICBpbnN0cnVtZW50YXRpb25f
ZW5kKCk7ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwgICAgICAgICAgDQo+IH0g
d2hpbGUgKDApICANCj4gDQo+IFdlIGNhbiBhbHNvIGp1c3QgcmVtb3ZlIHRoZSBsb2NrZGVwX2Fz
c2VydF9wcmVlbXB0aW9uX2Rpc2FibGVkKCkgaW4NCj4gZG9fc2VhbWNhbGwoKSBpZiB0aGlzIGlz
IHJlYWxseSBhIGNvbmNlcm4uDQoNClRoZSBjb25jZXJuIGlzIHdlaXJkIGNvbXBpbGVyL2NvbmZp
ZyBnZW5lcmF0ZXMgYSBwcm9ibGVtIGxpa2UgdGhpczoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L2xrbWwvMjAyNTA2MjQxMDEzNTEuODAxOS0xLWthaS5odWFuZ0BpbnRlbC5jb20vDQoNCkRvIHlv
dSB0aGluayBpdCdzIG5vdCB2YWxpZD8NCg0KPiANCj4gPiANCj4gPiBBbSBJIG1pc3Npbmcgc29t
ZXRoaW5nPyBJdCBzZWVtcyB0aGlzIHBhdGNoIGlzIGluY29tcGxldGUuIElmIHNvbWUgb2YgdGhl
c2UNCj4gPiBtaXNzZWQgU0VBTUNBTExzIGRvbid0IGRpcnR5IGEgY2FjaGVsaW5lLCB0aGVuIHRo
ZSBqdXN0aWZpY2F0aW9uIHRoYXQgaXQgd29ya3MNCj4gPiBieSBqdXN0IGNvdmVyaW5nIGFsbCBz
ZWFtY2FsbHMgbmVlZHMgdG8gYmUgdXBkYXRlZC4NCj4gDQo+IEkgdGhpbmsgd2UganVzdCB3YW50
IHRvIHRyZWF0IGFsbCBTRUFNQ0FMTHMgY2FuIGRpcnR5IGNhY2hlbGluZXMuDQoNClJpZ2h0LCB0
aGF0IHdhcyB0aGUgaWRlYS4gSSB3YXMgbGVhdmluZyBvcGVuIHRoZSBvcHRpb24gdGhhdCBpdCB3
YXMgb24gcHVycG9zZQ0KdG8gYXZvaWQgdGhlc2Ugb3RoZXIgcHJvYmxlbXMuIEJ1dCwgeWVzLCBs
ZXQncyBzdGljayB3aXRoIHRoZSAoaG9wZWZ1bGx5KQ0Kc2ltcGxlciBzeXN0ZW0uDQoNCj4gDQo+
ID4gDQo+ID4gDQo+ID4gU2lkZSB0b3BpYy4gRG8gYWxsIHRoZSBTRUFNQ0FMTCB3cmFwcGVycyBj
YWxsaW5nIGludG8gdGhlIHNlYW1jYWxsXyooKSB2YXJpZXR5DQo+ID4gb2Ygd3JhcHBlcnMgbmVl
ZCB0aGUgZW50cm9weSByZXRyeSBsb2dpYz/CoA0KPiA+IA0KPiANCj4gVGhlIHB1cnBvc2Ugb2Yg
ZG9pbmcgaXQgaW4gY29tbW9uIGNvZGUgaXMgdGhhdCB3ZSBkb24ndCBuZWVkIHRvIGhhdmUNCj4g
ZHVwbGljYXRlZCBjb2RlIHRvIGhhbmRsZSBydW5uaW5nIG91dCBvZiBlbnRyb3B5IGZvciBkaWZm
ZXJlbnQgU0VBTUNBTExzLg0KPiANCj4gPiBJIHRoaW5rIG5vLCBhbmQgc29tZSBjYWxsZXJzIGFj
dHVhbGx5DQo+ID4gZGVwZW5kIG9uIGl0IG5vdCBoYXBwZW5pbmcuDQo+IA0KPiBCZXNpZGVzIFRE
SC5WUC5FTlRFUiBUREguUEhZTUVNLlBBR0UuUkRNRCwgd2hpY2ggd2Uga25vdyBydW5uaW5nIG91
dCBvZg0KPiBlbnRyb3B5IGNhbm5vdCBoYXBwZW4sIEkgYW0gbm90IGF3YXJlIHdlIGhhdmUgYW55
IFNFQU1DQUxMIHRoYXQgImRlcGVuZHMgb24iDQo+IGl0IG5vdCBoYXBwZW5pbmcuICBDb3VsZCB5
b3UgZWxhYm9yYXRlPw0KDQpTb21lIFNFQU1DQUxMcyBhcmUgZXhwZWN0ZWQgdG8gc3VjY2VlZCwg
bGlrZSBpbiB0aGUgQlVTWSBlcnJvciBjb2RlIGJyZWFraW5nDQpzY2hlbWVzIGZvciB0aGUgUy1F
UFQgb25lcy4NCg0K

