Return-Path: <kvm+bounces-52190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0986B0232F
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 19:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20AC83B725B
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 17:51:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DA432F1FEF;
	Fri, 11 Jul 2025 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J96giaA4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1068B1B4242;
	Fri, 11 Jul 2025 17:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752256327; cv=fail; b=NV+SoCt4k4yvZw/SiSS8xsAXRl9Av6Adk8DJL5g+mPcllGgooS4hSXjLqeWBcdgI9GB2OjKV53cycH1p4Cx8fHyj1DljsNHQ9j9oXXXewGvduSmyvXJ6FQ+yzbv8NlxUALAu3QX4NWIxT8F8o3Ti4RNTccF7imAxPALEcpUSFNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752256327; c=relaxed/simple;
	bh=yxwuup8EgANjGwfJK2OT+5Su+UyGsJt1ZKiPOW7A1hc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nHDuz8g4MAR2pnHiHaxZ0gMfy8/5uZdv2ozUK7bjRbZxUzvYMzCAnxI03Ve9zcvCnMw2E5KMZn5JRpf88z+XWOduSYUGiH2boIlImm2aR+EcGo+z3ZYngKnAaPVkXiu0iMY/ORmr3lc2QaoorwtaIVatIl8SrgdWrMaecY3t1n0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J96giaA4; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752256325; x=1783792325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yxwuup8EgANjGwfJK2OT+5Su+UyGsJt1ZKiPOW7A1hc=;
  b=J96giaA4QnE4rTDFT/8+FNy3QGTYbMY/XSqic4MAS/REzWXH01Am1gBT
   SSMc2sEj9PcamtBdmAIugPwK/VZ2rlTrbiTpmE4Y7+NX3mqBaD6ukltcu
   xiad67f5qerJwBj0E12h0EwyDTvhgCgmT1gbugvF+SjN7fGfGEsnXfGmP
   8Twq2IxU9XTfLKHe2LUlqmiqwbvzLZqQmmbQQBjUpM+yakQu9SzRAlY6J
   YF0of0lCMmnrV2tlX4swYyUCJ9Q4ZZBTRcsQFQUYYnK1jnTbpXs2FM0HB
   k1Uyw2rGRhjU77ouvIdvflIVquSTAQ3ovM3VX7Oh5NaPHrg2eJMC4Dz7h
   Q==;
X-CSE-ConnectionGUID: stlW4le7QKGAVpiaDYMKtA==
X-CSE-MsgGUID: dLcvqEn6TeqlIqP5iPJuTA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="65258214"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="65258214"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 10:52:04 -0700
X-CSE-ConnectionGUID: QEUBmexfTOmVECBXeEkIWA==
X-CSE-MsgGUID: LGoBhUK3SdiQrH6QO6NzdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="156530164"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 10:52:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 10:52:03 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 10:52:03 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.54)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 10:52:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JNqMFa4VQn2GKCEcJOOpfPFCWUTRu2RX+RqUx6qhC/EdEonIceQLTqOvf9Q9w4918hTMz94n6isd5NFdprwd65MizLS5kPatPjHwPYer985oT8qE3KxaA8GgHF7zkQiBnZ8/GFEuK0efgk2TlCyxPd0XGRQD4YQgxhJIP2pAVossYnFDKS/4JnUP8RVtjCsuplJSy9/mVShjy+9EVR36+Z5pIk9e1XgeUf7MEqzL7WX9EbLoI+yMI2g29Pi70m9FE60nVphc22saYO0fchM+7AwtsrfyzGoGUFX6vuhBXjZdrJl6kzEN9m2C4bqVQb+l/Y4f/kK05cw7UZRn3dkn8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxwuup8EgANjGwfJK2OT+5Su+UyGsJt1ZKiPOW7A1hc=;
 b=AkkEipDBoMSrvzFoAPhl/sRrIXiq3+Km5BoP6snQYDwqE0f8JaMD3HhYmUD8bEghKmWW5hkbZhnaMMTecfQwNqi5yO8YRX/jxSU/6QlfBN4N6Ge+H4Omu0J0r7uMEjWjprWmy1L8Zp5J3PmMO2S/4L0iWIypopmu5PuOCKw4hkbyzW5WaXqsn3r4nQtmtVr09eri/HfxsLI8z9q3Tm8tBaaWQquKZwbA9sI/jAtoCS7g2lyV5WRU22J5pjOjE97T4LexBNnzRfiZJh12xuFJIl3v0DmIQNTaB09EFznryj6DLONpJ+t2nWdgpuJGmYPFEwfN+GeuPvLMSCsfpYdrGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BY1PR11MB7983.namprd11.prod.outlook.com (2603:10b6:a03:52b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Fri, 11 Jul
 2025 17:51:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 17:51:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Huang, Kai"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 1/3] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Thread-Topic: [PATCH v2 1/3] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Thread-Index: AQHb8mihlI+FIXjU50ySbjKMZHdHe7QtM/0A
Date: Fri, 11 Jul 2025 17:51:18 +0000
Message-ID: <94f7657e9ba7d3dee2d7188e494bf37f2eaddee1.camel@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
	 <20250711132620.262334-2-xiaoyao.li@intel.com>
In-Reply-To: <20250711132620.262334-2-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BY1PR11MB7983:EE_
x-ms-office365-filtering-correlation-id: 1d073a93-b633-462f-8f27-08ddc0a38a58
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VTV0NGtCN2FSTFhoTFV0alZ1cWJyZWUzSmhuaWpGYUdEUm12aXlnbmNrNXZj?=
 =?utf-8?B?ckRYNExOUHc0b0lIbzBCc0ZaYkcyRTRUckZtK2RKNVM0R0FsbGlNeEU2VUgv?=
 =?utf-8?B?TjlSTVhXSGJKNHdlckQ4aEpES1hPdndiQkk3OXBWN1ZPVkQwWFhuTS90Ujcz?=
 =?utf-8?B?TzNVWEsrYlkrTGlGNW5jL052REtGdXBUaDNxbyt5KzVCU1o4UXFPdUF2Nzgz?=
 =?utf-8?B?djJOa3Z1WFVaUTlxbkxhQ1ZqbUJGaUVCdDdXazNaNVEyaGwwZ1lRZ2ZoZFJU?=
 =?utf-8?B?WWpWM3U4T1pveDlZbWpLV3ZYcTR5TzJwT3JCNFg5SkRNQjdDU3lKVFpJaE5U?=
 =?utf-8?B?b2RqVEV0cUJuMjZ5SGJzZGk0R3YvOHcxdzVuRy9XUzF3ZE9tTys1UURZbDJa?=
 =?utf-8?B?RS9Lekh2dk4yNDFnWE5MSm5kanpMQmljNWIyYUdRT2ZwdW1IVVpHenJIVU5i?=
 =?utf-8?B?bGJHelNmUG4rR1dCV3paVjZETDRVVUQva09lcDVtMHVZRjNiZmxDZzRNZldS?=
 =?utf-8?B?aERtTm9GS2FqMVJScDRBMFYyZlJPd25EclNQU3BGeHFPTFY3clI3bC9NVzJ2?=
 =?utf-8?B?eG92UHUyMWFTa0pLaU1kb0F1bkdRNDB2MEVScldIS0xqUCt0SWVYcUc2Vk9N?=
 =?utf-8?B?VHB6dXBvRjFhOC9nZm81UDZ3REQ4eERiYWp0Uk01ZFFNZ2tYY3AzaVh4SzRL?=
 =?utf-8?B?VXJJeHBybFVVUmRsYWZzWkNUejcrMFZpTy9QaGIrcExMK29sdUlCa1JocW43?=
 =?utf-8?B?K1h3T2M0YW9jc2JZQzV6OHdNWkR2NTZIZEFCK0xzQmJzUFp6SFFzVkZybWJJ?=
 =?utf-8?B?Q3RCWEEwdzVyTzd0ZkZURm1tN0JGL21EKzhjOWZUaDNSc081VktHZlFRQmRN?=
 =?utf-8?B?VDJRN1hBc2VuZWNSc2IwQVhKOTg1cDZ1V21TaU55L1ZLYVk1dE9KdDBMNURt?=
 =?utf-8?B?Wlc3WE8yYlhjdUJja05vSjRSZUJWUitBVVFDM1dGTTd5ZTRCVUxjSXdxaWEz?=
 =?utf-8?B?L2VEeUdPQkduL2poaGZ1dGhCcHRrNWFwZDRTQUdrOU5hNklCS0VUblQ4ZXMr?=
 =?utf-8?B?elF6eWt4OVZ6b0o5ZVVETEFsTGdSM0g5UnlNRi8wQ0RYbWpxWjc1aEVIeXJv?=
 =?utf-8?B?YjdJTGs3TVQwUVAyek5DQ0FGSGJkOW92cUQxbUk3SUw5bXpUWU95a2NMalhm?=
 =?utf-8?B?aWdvMWZXK1ZHWHF4b0dnYlNKZFpsT1V3R0d6L3JVRjJFSzJ3blB0RGJub20y?=
 =?utf-8?B?TWJ5T1V2Y2IzUnh6WE1mcEVwalNXZkNSTFRiVFRBUlFhSlFjRW5GTzI3R2xt?=
 =?utf-8?B?U3J2TnRBbnN1OWlEVURJWE5MNStIT2hQVkExMHBhdzZPNG5PUGVFbHN6VnBj?=
 =?utf-8?B?NkRUR244bFhOVVE2Slc3SDdtVWQ2Q2NZZ2E0bVovdHc2dyszR3RQczhRSVFX?=
 =?utf-8?B?QTgyeVhIWlhJSkNLRWY3cnRYK0xEZFNhemMwdlI4VTJZc1JUMERJMDF2OUwz?=
 =?utf-8?B?V0kzYllhMk9aM1FBdGYvZ1hEM3JtbXVHU2drMnBIb2wzeXEzNGJ3UXFIVHlH?=
 =?utf-8?B?R3JBQUZESWdXejJVYVV4ZExsbU9WYi8xS1lhNmhJbitWSktub3Jha1hLVDIw?=
 =?utf-8?B?UHhobEFoNERmNWd3RUNMTVNkOG5CTm1RK005NVhPUEt0WWRyODBvVVJmd1c1?=
 =?utf-8?B?MjRZNWxnSnFLVnAxMStyRzB5M0dyUWtxazhqZUdiak9kOTdYZHIybGU1OGp0?=
 =?utf-8?B?di92K1RZVkhsUFgvZDIwMWwycHZGSFhyL0VsaFdpa09hSHZaaU8zQ2JtWnFP?=
 =?utf-8?B?Q2lPN09MZjRRRXlUVVh2YXdDV1Y0S0k3ZTRjOXdnZXVsTnBqd0VaeENWcW5q?=
 =?utf-8?B?UjFpMGZvVHdYVytpWmN4a21OZ052d3E4U215ZGFzdFNWOWlLVkx5bFh1SU51?=
 =?utf-8?B?Q2NwQVkrbUFJa3dzcXFiSmJDc0RpdmdVU0ZBMUNBbTREQmtRS3Q3dXVoeFRI?=
 =?utf-8?Q?EIgSSgDEKrv/TY+v7ttchmoTQCJxDA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dGIrTDZQZTJ2cmZFMUg2d28vVG1mY3Z0WU9RZXNZT2dCQW5Rb2J1V0wxc1Rn?=
 =?utf-8?B?S3Q3RnRkTUpHRUZuenRMcFZXRjY1cG9ETXNWcDAvTnZHdVE4T0xqS0ZGR1F5?=
 =?utf-8?B?ZzZibDE0azRnckJqU3B6WldrZHJUUkxWRHRYWXJpTXhkRGJnSXFOWTlQd3Yw?=
 =?utf-8?B?TWNlaHU0U0pCbnhTNldhNnBqMklteE5hZ3lUcmhQUk9jakFvK1RUWVF4cXAv?=
 =?utf-8?B?c1h6dGhqOVFyQzV5Qm9USmRVWXpoeEtxQmM2bWZyMTRzc1h5Ulk0bElMa0pB?=
 =?utf-8?B?R09zNW04S2VidXZ6eHBvV28xUnh2NWQ0N05FblNVbGRCMWZvS2hJcTlpeFV4?=
 =?utf-8?B?WmtBVmdpRVJHbWd6N3ptSkJMYllaZnFMdmdidCtZZkw3WW10YWswYmwrQUR1?=
 =?utf-8?B?QUJtQmNSeDdJMzl1aURLTTBZVmp0WVJLZWQxbzNhV1JZeXlRZWpRWGNJUGV1?=
 =?utf-8?B?cExiUjAySWZSOEl0T1ZLL1hqQm8rTFB5bDNFMG5lOWJSRFJtSU1sR0FuOW9k?=
 =?utf-8?B?Y2hIUzFsSXdMLzZBb29NVFArU1RvOTJQSzRZTTNlTk9CSWVmTkZlbkZQYTBo?=
 =?utf-8?B?TE83MFlBZ0ExWUswdHpQL01qWkdxRHpQZzhHZmNXQTBwZSs4c2ZSazhhZEll?=
 =?utf-8?B?M0tENHJILzZtYUdZMit6V2ZPSDUrczI1K3pJZmMvTjNYVm80eDNCYWIwOTBx?=
 =?utf-8?B?MkJSZFdheGExWXdCN0lTZXFpQUZqNEZBKzFHVndjSkp3MHNpN3NmTmE3L2hj?=
 =?utf-8?B?ZFBmOHFXMUY4UEtiU3JIZ2JZcU1SQmU2SVh3WmlDTURtdE1HVlM3MFJ6czNy?=
 =?utf-8?B?TUtPZmRCTEh0UTZnV3ZLKyt4V2VQRzNqcU5rZ3U2MUVrYy9KMFIzckhVN29B?=
 =?utf-8?B?TDd2MHRDQUMyL05rbDZ3TXpOSSs2ZzF2REdGZnU5U0xQNnIwMnpwZHhDQy9a?=
 =?utf-8?B?T094RkhpQXVnbDU1RkpGV21wRjg2b1hMWmY4THlDbVh0OEd3Qlp3Q0g4bjBr?=
 =?utf-8?B?QjV1VVZuemxCZHZpRzdEQkFwTnZkbWhUSExkeDF5Q2llVGVHeHJrb1VQUGt0?=
 =?utf-8?B?OS9oT0RxOElrYWRTVUw4T2NkNHR1VHRKUVRoRlR2NUEvb3Q1b2QzekxiQzBG?=
 =?utf-8?B?QnAySG13WVZrTTVFOGVpTDdyREhEdThGN1h3TWE0YVdxWHdPRFRsMEdEdkJk?=
 =?utf-8?B?QXU2WDRpeWNtTEQ2L0NWSXVwZ0RQUi9mSkJoa2NpcGl1THBpalpvQ2JYeEFG?=
 =?utf-8?B?RjdsWkNaMXo2Qk1melplRVpnMlZEbFhGYVNTbzhkQ3FEV1d5ckkxM2EvNUIy?=
 =?utf-8?B?VldncjJ6dXZyWkRZMzRhdjlNNHpwWmYxNFFnRDRBY2dLMUw5T3VkZFJwdHBC?=
 =?utf-8?B?SmFHeGExNll4L0F5c1h5TGlXTStQc2tPMkJoUWY2K3djT3k5YW1tU01zQmJh?=
 =?utf-8?B?M1Z4VlBhbmZlZS9wdHJWTG9tVW5IOTRHT3U3czA3TzFSY0gvaktnN0FvOEZP?=
 =?utf-8?B?VTNpMDhWblhUcXN6Njh2VXJHOW1HMzhCNmtCa01TeEUydWhaQ2t3RTRySGhy?=
 =?utf-8?B?bHNQUUF5SjlDaHhlcVVrZnBiZTVRL2VHVmk5emc5UkVRRzVKYWRFUi8xV3JV?=
 =?utf-8?B?bnhnNmc4Z1psSjlmZjJDZ2hSOGxYczRPTzFtMnBnSGNtY3Rsek04RUR4TlpM?=
 =?utf-8?B?UWFUVHY4aHZBcjlUQ256bGVTQjNOWmN6a1g4Zmw0akNkQjNDa2hWM21iSm9j?=
 =?utf-8?B?ekh5RTk2THJ3aTQ5d0pPUWtCbk9IRjgrL3dxYW9iMUFYVmFZc0FTYU4xUHo1?=
 =?utf-8?B?NzA2MERFSjZoTDFFTXF2VVlxMjJjT0FxZ0JtWG5CT2oyYlJaNGVLUXkxYVhR?=
 =?utf-8?B?KzdoaXRMdUxQM0JZa2tHRHZXMEk3aWJ6Zkt3ZDRIMnh3a3hqcStyMnN4MTJJ?=
 =?utf-8?B?TXlGUFdsR3hCbzQ0KzFWc3dFSGVUZjljV2QrTVQ2QVNNMjdoc3FEaGVyckls?=
 =?utf-8?B?OENRekhiUFcxei9jT29BZG9WOUVhWnNhQ0I5MXVTNFp1QVlyTnAwbVVrbUgy?=
 =?utf-8?B?MlVKUzBvMkhpTVl4WmQ5NFI4ak1JNUdJelZ3YmxQbzI4NUhSZnhQbFptK0dK?=
 =?utf-8?B?L2lhS3hUSnVXMnBWYkZBSGw4TG5pVFN2azFGMXpVVlAyZU5QSW1NMDlOR0JP?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD8FDCBD0BF6404DAF0AB9137C923623@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d073a93-b633-462f-8f27-08ddc0a38a58
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 17:51:18.9583
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zKlaE/XTu2IOwV9VTfAKXfUtnPVLxlkc1xvy+TQqrY0FuC1uxPjQyu579TYD5/r77dhCD/mGLRnlRSpF3Fax8qCDjXKM/YA3uBn2FSsmGNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7983
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDIxOjI2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBG
aXggdGhlIHR5cG8gZnJvbSBURFhfQVRUUl9NSUdSVEFCTEUgdG8gVERYX0FUVFJfTUlHUkFUQUJM
RS4NCj4gDQo+IFNpbmNlIHRoZSBuYW1lcyBhcmUgc3RyaW5naWZpZWQgYW5kIHByaW50ZWQgb3V0
IHRvIGRtZXNnIGluDQo+IHRkeF9kdW1wX2F0dHJpYnV0ZXMoKSwgdGhpcyBjb3JyZWN0aW9uIHdp
bGwgYWxzbyBmaXggdGhlIGRtZXNnIG91dHB1dC4NCj4gDQo+IA0KDQo+IEJ1dCBub3QgYW55IGtp
bmQgb2YgbWFjaGluZSByZWFkYWJsZSBwcm9jIG9yIGFueXRoaW5nIGxpa2UgdGhhdC4NCg0KVGhh
bmtzIGZvciBhZGRpbmcgdGhlIGltcGFjdC4gVGhpcyBpcyBzdWNoIGEgc21hbGwgcGF0Y2ggdGhh
dCBJIGhhdGUgdG8gZ2VuZXJhdGUNCmEgdjMsIGJ1dCB0aGlzIGlzIHRvbyBpbXByZWNpc2UgZm9y
IGEgdGlwIGNvbW1pdCBsb2cuDQoNCkhlcmUgaXMgaG93IEkgd291bGQgd3JpdGUgaXQsIHdoYXQg
ZG8geW91IHRoaW5rPw0KDQoNCng4Ni90ZHg6IEZpeCB0aGUgdHlwbyBpbiBURFhfQVRUUl9NSUdS
VEFCTEUNCg0KVGhlIFREIHNjb3BlZCBURENTIGF0dHJpYnV0ZXMgYXJlIGRlZmluZWQgYnkgYSBi
aXQgcG9zaXRpb24uIEluIHRoZSBndWVzdCBzaWRlDQpvZiB0aGUgVERYIGNvZGUsIHRoZSAndGR4
X2F0dHJpYnV0ZXMnIHN0cmluZyBhcnJheSBob2xkcyBwcmV0dHkgcHJpbnQgbmFtZXMgZm9yDQp0
aGVzZSBhdHRyaWJ1dGVzLCB3aGljaCBhcmUgZ2VuZXJhdGVkIHZpYSBtYWNyb3MgYW5kIGRlZmlu
ZXMuIFRvZGF5IHRoZXNlIHByZXR0eQ0KcHJpbnQgbmFtZXMgYXJlIG9ubHkgdXNlZCB0byBwcmlu
dCB0aGUgYXR0cmlidXRlIG5hbWVzIHRvIGRtZXNnLg0KDQpVbmZvcnR1bmF0ZWx5IHRoZXJlIGlz
IGEgdHlwbyBpbiBkZWZpbmUgZm9yIHRoZSBtaWdyYXRhYmxlIGJpdCBkZWZpbmUuIENoYW5nZQ0K
dGhlIGRlZmluZXMgVERYX0FUVFJfTUlHUlRBQkxFKiB0byBURFhfQVRUUl9NSUdSQVRBQkxFKi4g
VXBkYXRlIHRoZSBzb2xlIHVzZXIsDQp0aGUgdGR4X2F0dHJpYnV0ZXMgYXJyYXksIHRvIHVzZSB0
aGUgZml4ZWQgbmFtZS4NCg0KU2luY2UgdGhlc2UgZGVmaW5lcyBjb250cm9sIHRoZSBzdHJpbmcg
cHJpbnRlZCB0byBkbWVzZywgdGhlIGNoYW5nZSBpcyB1c2VyDQp2aXNpYmxlLiBCdXQgdGhlIHJp
c2sgb2YgYnJlYWthZ2UgaXMgYWxtb3N0IHplcm8gc2luY2UgaXMgbm90IGV4cG9zZWQgaW4gYW55
DQppbnRlcmZhY2UgZXhwZWN0ZWQgdG8gYmUgY29uc3VtZWQgcHJvZ3JhbWF0aWNhbGx5Lg0KDQpG
aXhlczogNTY0ZWE4NGM4YzE0ICgieDg2L3RkeDogRHVtcCBhdHRyaWJ1dGVzIGFuZCBURF9DVExT
IG9uIGJvb3QiKQ0KUmV2aWV3ZWQtYnk6IEtpcmlsbCBBLiBTaHV0ZW1vdiA8a2lyaWxsLnNodXRl
bW92QGxpbnV4LmludGVsLmNvbT4NClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNv
bT4NCg==

