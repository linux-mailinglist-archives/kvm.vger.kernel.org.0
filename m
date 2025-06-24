Return-Path: <kvm+bounces-50532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3CE3AE6EB1
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:36:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D924217C854
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 18:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C56CA2E6D1B;
	Tue, 24 Jun 2025 18:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eL/6eAFH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DB123BD00;
	Tue, 24 Jun 2025 18:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750790170; cv=fail; b=PGdakBNvkPD2d3O6LPA50XR5zTX2nfhiosWHcoChF6PvAQMobGs3o6baAjPK8rzuYsWWLT55Fzx1pS9e6xBd0LHQd+hzZGI/e0qpiecnmFOdAaXU++EirnN+SB7Ed2JHY0zuARPpJf6P6Il8L0lEaJHGrS624WyqbU1GYMqMlnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750790170; c=relaxed/simple;
	bh=k1f0yYRl+J7p0Yw+x0jFBztuwjtLftcohXsHIgDKxHc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PIIllDz5iNFNZ3a4pMRg7BISM7HFs5pQ638+snCXeMEgAxzmKN+AymynsUKkXsT2s4VkSSi0wOOP/vb2fp4k3D7jO7jGtlh8E/adN4nwMGym6DRIUK8FoFDU41ovls+Ws54aj/sOR5p4xFbS9Kla7jS8Dyn1sHTahJvsdaW6Afs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eL/6eAFH; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750790169; x=1782326169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k1f0yYRl+J7p0Yw+x0jFBztuwjtLftcohXsHIgDKxHc=;
  b=eL/6eAFHQPM8SpnNYbg2bu+Zsau4v651ZhV1LPwqnEmCAi9uugXtG628
   Vd0ejwUwiUah01Nw8CSXW+ODyCpILR79l7cZY0B1L+JehPW/XC2OoT83/
   ClxzIMPy8rsIe5WgOfLBbGnv3RmDR74teOH/BSA0vA/SBdaXR3U4FptOQ
   o6gejm73aTvTdiyAg29xAJUyDqupPco8vp6ZRrHNXiUFxsS0q9OmCKOiO
   KD/KhwJpyqPrRj7Hh+c/qkuRpQptPQ3vFgxtxE44pt6QWWcKlvTdL0cl5
   NJK+EScL8cRTv6yZpRRkJc5cQvIXJ+sCzw//iyuAQBttuy/8VrVEOSNFz
   w==;
X-CSE-ConnectionGUID: omQDnRkxTIKytzdK1E7Vgg==
X-CSE-MsgGUID: NkQSruLwSCmzM/F78nptRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="52766522"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="52766522"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 11:36:07 -0700
X-CSE-ConnectionGUID: QPdBjRSiSlmmRPAXxfJ3LA==
X-CSE-MsgGUID: ezdJS6hoQ3qZFz/Vb3gLCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="152163339"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 11:36:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 11:36:05 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 11:36:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.55)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 11:36:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDlBdC3CnfJbM8siPrD0DE2AdfRNFFY0EuiNI4J2THYtvPx1LYgnaoRrYe2TIqCzGqUeqCP7AhzuYmyNmfVIZeSf3N7DcoHpr/xXxg9o1n7qwdlb/qSpPAab2S/BqbbemMsoPTdhBkQEZkp6NtuPUqAKj4y7ecW5Tn/bBhMaKW9umekP4BW38fyQFydLCCpsjYByztd5QVaUfRjgv4KEWhL6FA6s1CncklMkz+VRSTwSWzgnbXXMsKyM38m9AJRonkgeF9RZYEOenY9qPPLOxH7CX9fyZNc+1BwrfGrHmj9NoG0hLLqv+CC5t/0h/zqtH01QBrFMwHsD7sO+KWK2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k1f0yYRl+J7p0Yw+x0jFBztuwjtLftcohXsHIgDKxHc=;
 b=b2o1EQsBzYqo3nQThlMSwqKb04yKdpXBTtLdGoJNR4vy4My90fZxowDaQG8gE3aNeK2WR9VPmunfl7sbSasGiRXDJ6RCjnwmLoYfLn736nWHaGkKOlRBKo+ratgFY0KhXsxZcI2EtB2JOnK5sa+s9sTiHjiPk/yr42rWikV41ZHK1NibZPnc356PYaRUo17N9T5ZEEqgJ1FOS7q+CbJrOtmSPPstnz7056zIHjuB0b/QGB5Iqv0HIXdwERtKFD6nJPpAT69WcdCZjWLcAfYAwD55F6iEQtg6AzyL4beZYb9N+q8qoYO9oWUg/h9kwJrU9E937Cqdn1LpnnvYLbmAtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Tue, 24 Jun
 2025 18:36:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Tue, 24 Jun 2025
 18:36:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "seanjc@google.com"
	<seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "tabba@google.com"
	<tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gA=
Date: Tue, 24 Jun 2025 18:35:59 +0000
Message-ID: <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
References: <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
	 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
	 <aEyj_5WoC-01SPsV@google.com>
	 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
	 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
	 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
	 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com> <aFWM5P03NtP1FWsD@google.com>
	 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
	 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB4824:EE_
x-ms-office365-filtering-correlation-id: ad138ea1-2dfd-4a86-9bce-08ddb34df75d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YjhMMUdHSWJFcmloN3dtdjA5TlYrUTJwb1ZKc3k0SUNjdFpJQVVEdGdpc0xD?=
 =?utf-8?B?MHFzdHFpWkpMckVzK0Q2UFpUMlJWcWk1NDdQd2FQR1FWZ2dNbERoczhYRUY0?=
 =?utf-8?B?QmZybGdEN2tMc1IzZTUxendySlNJQ1RJcUhCQUVUTjIvcEZCekFHbHpBbFBO?=
 =?utf-8?B?andSbWRmN3BVM0VwNzJhVDY5UVNpNnk5STliU0JHdHk1NHg3R3V1QUkvajIw?=
 =?utf-8?B?Q2pOakxYS2VaaS81Tm94T1p0bkRNeGdmV3c0UzdjU3ZCUlhGSy9vbmRUNUND?=
 =?utf-8?B?OGtZMFQrNng5ZGFKWU5KMXlnalpaVWpWa3oza3pxeHpLd2JISGlacnpTR0l1?=
 =?utf-8?B?MEF3VHdSRldOTjcwVzlnZWZzYWZTU3BCVDgvbjV0Q1BzOGRGSi9ubTkzNXJE?=
 =?utf-8?B?RXAycHNiM3ZPTTNjZWFjd2VXcEtwYlowZTlJYzZVOE9GRW5MdGU5UmhCU0VK?=
 =?utf-8?B?RkpHNWREOXZKN1p4dDk5dzBHMmMzWTlQUkNjVVFkRHUwdE5kVnFvQW9WUWVz?=
 =?utf-8?B?azZjVEFNWGFTRFA4T0JqVS9QNU5uM3hmQlhzKzhuNHVZaHVlSG9wNDVXQWRW?=
 =?utf-8?B?WHFSWEJsY0g1MCszNk1Zby9RZXdGSjkzeC9DY3FqL29pTGtOMTZIWmlKTWI3?=
 =?utf-8?B?SnBNL2tWVlZuRWVYVnZYajhaYkw0NFROdi95ajJHRWxrSFpzZ1R4OHFFdVFL?=
 =?utf-8?B?R21LWUhvSmNwcFN2bmc0bXhzc2JUUXQ2ZVNTR3dtVENWRG5LSmhQVXgyOWth?=
 =?utf-8?B?NXlTTU1DRXJ3SXpOTy8wVGlZWWhhSk5zNzlSN2tXMmdmQk9MVTc3WGUyK296?=
 =?utf-8?B?dUZjYklWVlRMajNXUGMweVcrL1IzbnQ2ZXJjRDNnWGxBZ0JjallGV05Bd1VB?=
 =?utf-8?B?UXpRbU9LWXZYb2Y2RGZUTGE3amx3MjMrYlJ4RFR1YVlwRlNUK1N1cHkrZUtu?=
 =?utf-8?B?SE93YTRCYURYTFBYT0NFdkNpN2s2REpPc1NVb3ZQMHJvV3ZOdEcvUUtlZXMz?=
 =?utf-8?B?WUJ6Z0UvR0R1ZkN2TUJBeDhkbVcxRlh3aWZVV2Q5V1NIVFo1bW56S05PR0ZX?=
 =?utf-8?B?NEdiYm5zM2E1RzBuT0hhK1F6cnF5ZCtvOEFvcmVERys4V0pJbXVlSWF3d0FW?=
 =?utf-8?B?MjJwMWFLMWRreWlsNnJ1OHFobmZKZVJhL2poeXp4SFlnN1l2NDVVUk1FWnhk?=
 =?utf-8?B?NnJZTytaZjZnbHVjUGs5eURVdjRReitib2x0ZFV4amZmbHkwUWk1Z0VDdDUx?=
 =?utf-8?B?WkRRUTRiTE5nVnV4UnZqc0lGVlN5WExtY285aUE5S3I1aUJHQW02R2tMSHNE?=
 =?utf-8?B?Rjl4bllId2F5UHQ1Ky9QblZwZWhWb2Z3TVNCVmxaVXpJcTIyZTV6SFJ6eUFK?=
 =?utf-8?B?RS9pbzFwSjRuTmthZStlNWpxOU9XZER1SmNCMFRvbjY3OEY1QmRqKzJrUXBL?=
 =?utf-8?B?TmRMVE5xZldlTXhaT3JSb25zNml1YTh4eFhTZnEwTUo4KytDancwd3pnSkYy?=
 =?utf-8?B?d2c5U0VUd1cxcGhhbEtYR2tJZW9KMU9nMUs0S1ZKMENrbXRZRzAyQWMvUGNh?=
 =?utf-8?B?cFBDcWVETXIyYnZ0MTBNdXphdTBZdTRyL0xCSnVnRWxESjE5SDdxVXc2Q2RX?=
 =?utf-8?B?clIvK2IzbWUvZ2EydWtNVW9kZ2RjWkVNcnNyRU5MVEdmZkREZmFaQjZ2VnJ1?=
 =?utf-8?B?ODdJUnhWbjI4NThCWWZQeVNURHBqR2cwcmUybFdqNC9YZGVwazlhZFNWdnBI?=
 =?utf-8?B?aXVENmhSbE0zem5jakUydFovWWpyMytTL2FlTmdCYUNOdGs0QTRuNEFueWIy?=
 =?utf-8?B?VWR5aVJkTjhveFVRcCtPeTltVVpRSk0rRmNXb1k0RTE5RU82SlJORldObTRl?=
 =?utf-8?B?QkdJekdLNUJ0cEJmNEpxWVZlZC9SZUpFVDVQSDNEMmdmR0JON2xpald3Y1Bw?=
 =?utf-8?B?cDB0ZUVzTE9XMHlnWENiUjFFQVFpNmpkMjY5VThvbTNtaUxucno4VWlXZ0N3?=
 =?utf-8?Q?AnNDkpzYhCh5mFJZxmxjLbxQ/8qCCE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aXNrNjMvVVd1bWdFWkNYT1lZcDlzR3d2V2JvQWcySlNTSUdodGJLUGU0WmND?=
 =?utf-8?B?UTZOem1oOUhuUTdMYWVWdE4zTVlIQmJzSXhtUU55Sm9HYzFob1JUM1hVTmxt?=
 =?utf-8?B?WE5NZCtvY1dDUlhnUkp2Q0FiM1p1WWl1Q3ZPVUp6bjk2YjlEdG5UMmYrSGkv?=
 =?utf-8?B?N3dnMmhLdXhrZUZaU1ZoSUloMit1RTltUTFtWTYvTS84N1lIK1BaRmhEOTlZ?=
 =?utf-8?B?bVN5aGNEbEh6SXVJaXQ2K20rc1NvNVB2aldMWUFDQkRHWVB5MlhtWWw0UEV2?=
 =?utf-8?B?MFBxczBFY0FJaHJPTldKS2l5a3ovUkJDckhxbGM1OGFyZ2c5OVRtRzJzVTJS?=
 =?utf-8?B?WmEwRDZGS09YRnNTUlFlOXhJdlVJMlUva2hyaXNxem80c3dIQVhOZ1NJZHJV?=
 =?utf-8?B?V1ZNbzJyblBCWVhVSzJpZ01aTmFVdHgza1hMaGNDU0MyazViR2JYTVV6TTlO?=
 =?utf-8?B?VldsZ2hiS0VFZm5jazliWG9GL1phckNFb3R5UDVGK2ZWdUNoZ25wOWpIc3Y0?=
 =?utf-8?B?blhTTVVDb0JxemJ3cjJ2ZUgyaWR2K01KbkFCL2JLSy9hZTBUcm02ZHZEUmNs?=
 =?utf-8?B?M1JFRTl1eVBxbmlSVkZhRHhWZmNSZGtWMVgyWVpYMlorejc2NXhETDRPVS8y?=
 =?utf-8?B?MU11K3dOb3BVeVRFNUd4QVZFampIWGI2bWp6NzF6bGl0Y2pxUTVTWUdFSXd6?=
 =?utf-8?B?MWlrVHlxYndJbExrSC9TS3kwQUZvMjdhcS9hWTBNdUg3b3BKallFbDNjMllv?=
 =?utf-8?B?S3J1U0thRmtTTTlvSThiWUloM2pOOUR0Nmg2N0g4NFdGUzhDd1BGc3FMYWZx?=
 =?utf-8?B?V3d0eTNLbk1Odnp1VlJlUC9XQlRlYzgwazVmOVRMdlNkZ2Irem01dkd0allC?=
 =?utf-8?B?SjUwM2VQYUVvL2xHSWhQQW5tekRHalAwZ3dadXEvKzZOcmhWbXFsOG5vaE5i?=
 =?utf-8?B?YUUySjlZU1AvTkxTV2ozZmNWVTh0YW1OMlZMeTk5YzN4VW5FdWQzdWo1WGNR?=
 =?utf-8?B?RWk5aFdCSmNzRHdRZG40M2NFNjJ5VFFveGdCaktKd2Z3ZXBjdU52Y0tqRTRw?=
 =?utf-8?B?NUZ4L09KUThBY05DQXE0NFJ5SjhiVEFBNHZEd01PdkRGK0ZocW1lL3JmNUYx?=
 =?utf-8?B?NnZYNVFmczY0dDBUZ0xQNVV0K3dnOHNwZk5QbHlBK0UyRXhTNGdHa1R2Ukl4?=
 =?utf-8?B?YjdZeHYxSlRqejYrSEVKb0NVUkQzcGZzaTVXRS9RaFNEdWJ2cW1uQ2orZFRw?=
 =?utf-8?B?MGtNVE1EWGttYWd3YWphZGRjSFBIWXQwWW9GUGxYZG15b21UclVjcGtLUkhW?=
 =?utf-8?B?clUyRllSdlY3OENTelJQd1pyc1lLc1huMmd5TGtTK1JwdlRRT3NPMkFwd3RP?=
 =?utf-8?B?Ulh0b3dFMm00NG9wQUd3ZStpVXk5VWxKdlFBeVlWNExQMWNYSlhGbjZWUnRm?=
 =?utf-8?B?YUs0M3llNXFuV1RUVVgyZDBoWVlXVEMwaWZydTJNYm5BOFJGK0FzNGY1RDJG?=
 =?utf-8?B?SFNPWXdkc3puQ3plUGVudE44U3M4Lzk4bEtEQWJUaFovaXV1ellMaThEWHE5?=
 =?utf-8?B?aEwwTGl2ZHJiRmc5ZitwTzZCRWJwK1ZMeEF5QytKaU5kUUFKdnVKWTM1U0Vo?=
 =?utf-8?B?Q2piZzJ2bThkbG9GcExYVnRub3Z4c29jcSs5aEhsem1NMCtLNGlnNzMyemN6?=
 =?utf-8?B?TFF3SHhpMzR4SnN2M1JNaWtZTjBIUS91UWxoMy90aSs2YnQrVXRXU0cydmJI?=
 =?utf-8?B?QzFMUkxNMGd3SFp5YjVnc1ZYRWFXMVRoTUkrWk9RL3hiRFhQVnBOZ01jZ2ti?=
 =?utf-8?B?MytubDJLbUl2ZjZYOENtUlJ0bUpNU0wwdCs1eUZKQ1J3MHNodm5uMktLTVk0?=
 =?utf-8?B?NTZEVm43Nlk4eUtyTmgxKzlvSmhDWXdNaGpFRk1QR2IrWWJwWTVYdVJBbHNr?=
 =?utf-8?B?ei8rdGxtbnJTVm84Y01Cd2RqaTFFSllEbHBDQWI0Q1MzcHNQN3ZzME1VYVdl?=
 =?utf-8?B?bGs3MVA1eXNDKzZJZ255Y04zN2VrVStiWTYrMHo2NERMMG5aVEpEd1lxUkxv?=
 =?utf-8?B?RzZuWkN3dFA5Wk44N1ZhWmxzaGRMWitMeXpoK0w0YXg1RUg5Z2h6VmpvVGZR?=
 =?utf-8?B?UXVkVnBuRGZYRW00RkUzeWxPcVlPNEVuYm5ld3RqazlKc0NTRTVWY2xLdmM1?=
 =?utf-8?B?T3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <95C6931CBF52C34D8AC166C05DDE68BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad138ea1-2dfd-4a86-9bce-08ddb34df75d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2025 18:36:00.0177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qWcHhXcZAGETiXDoW40XNWt6ADhX4iGlUm1bFRNTts7QBig8lv/ka85hotwh3VhFS53iCkhI5r3i5Gs9CU/2uBIvlQ3gtNkmIVeDpoEWzD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4824
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTI0IGF0IDE3OjU3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQ291
bGQgd2UgcHJvdmlkZSB0aGUgaW5mbyB2aWEgdGhlIHByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwg
aG9vayAoaS5lLiB2aWENCj4gdGR4X2dtZW1fcHJpdmF0ZV9tYXhfbWFwcGluZ19sZXZlbCgpKT8N
Cg0KVGhpcyBpcyBvbmUgb2YgdGhlIHByZXZpb3VzIHR3byBtZXRob2RzIGRpc2N1c3NlZC4gQ2Fu
IHlvdSBlbGFib3JhdGUgb24gd2hhdCB5b3UNCmFyZSB0cnlpbmcgdG8gc2F5Pw0KDQo+IA0KPiBP
ciB3aGF0IGFib3V0IGludHJvZHVjaW5nIGEgdmVuZG9yIGhvb2sgaW4gX19rdm1fbW11X21heF9t
YXBwaW5nX2xldmVsKCkgZm9yIGENCj4gcHJpdmF0ZSBmYXVsdD8NCj4gDQo+ID4gTWF5YmUgd2Ug
Y291bGQgaGF2ZSBFUFQgdmlvbGF0aW9ucyB0aGF0IGNvbnRhaW4gNGsgYWNjZXB0IHNpemVzIGZp
cnN0IHVwZGF0ZSB0aGUNCj4gPiBhdHRyaWJ1dGUgZm9yIHRoZSBHRk4gdG8gYmUgYWNjZXB0ZWQg
b3Igbm90LCBsaWtlIGhhdmUgdGR4LmMgY2FsbCBvdXQgdG8gc2V0DQo+ID4ga3ZtX2xwYWdlX2lu
Zm8tPmRpc2FsbG93X2xwYWdlIGluIHRoZSByYXJlciBjYXNlIG9mIDRrIGFjY2VwdCBzaXplPyBP
ciBzb21ldGhpbmcNCj4gU29tZXRoaW5nIGxpa2Uga3ZtX2xwYWdlX2luZm8tPmRpc2FsbG93X2xw
YWdlIHdvdWxkIGRpc2FsbG93IGxhdGVyIHBhZ2UNCj4gcHJvbW90aW9uLCB0aG91Z2ggd2UgZG9u
J3Qgc3VwcG9ydCBpdCByaWdodCBub3cuDQoNCldlbGwgSSB3YXMgb3JpZ2luYWxseSB0aGlua2lu
ZyBpdCB3b3VsZCBub3Qgc2V0IGt2bV9scGFnZV9pbmZvLT5kaXNhbGxvd19scGFnZQ0KZGlyZWN0
bHksIGJ1dCByZWx5IG9uIHRoZSBsb2dpYyB0aGF0IGNoZWNrcyBmb3IgbWl4ZWQgYXR0cmlidXRl
cy4gQnV0IG1vcmUNCmJlbG93Li4uDQoNCj4gDQo+ID4gbGlrZSB0aGF0LiBNYXliZSBzZXQgYSAi
YWNjZXB0ZWQiIGF0dHJpYnV0ZSwgb3Igc29tZXRoaW5nLiBOb3Qgc3VyZSBpZiBjb3VsZCBiZQ0K
PiBTZXR0aW5nICJhY2NlcHRlZCIgYXR0cmlidXRlIGluIHRoZSBFUFQgdmlvbGF0aW9uIGhhbmRs
ZXI/DQo+IEl0J3MgYSBsaXR0bGUgb2RkLCBhcyB0aGUgYWNjZXB0IG9wZXJhdGlvbiBpcyBub3Qg
eWV0IGNvbXBsZXRlZC4NCg0KSSBndWVzcyB0aGUgcXVlc3Rpb24gaW4gYm90aCBvZiB0aGVzZSBj
b21tZW50cyBpczogd2hhdCBpcyB0aGUgbGlmZSBjeWNsZS4gR3Vlc3QNCmNvdWxkIGNhbGwgVERH
Lk1FTS5QQUdFLlJFTEVBU0UgdG8gdW5hY2NlcHQgaXQgYXMgd2VsbC4gT2gsIGdlZXouIEl0IGxv
b2tzIGxpa2UNClRERy5NRU0uUEFHRS5SRUxFQVNFIHdpbGwgZ2l2ZSB0aGUgc2FtZSBzaXplIGhp
bnRzIGluIHRoZSBFUFQgdmlvbGF0aW9uLiBTbyBhbg0KYWNjZXB0IGF0dHJpYnV0ZSBpcyBub3Qg
Z29pbmcgd29yaywgYXQgbGVhc3Qgd2l0aG91dCBURFggbW9kdWxlIGNoYW5nZXMuDQoNCg0KQWN0
dWFsbHksIHRoZSBwcm9ibGVtIHdlIGhhdmUgZG9lc24ndCBmaXQgdGhlIG1peGVkIGF0dHJpYnV0
ZXMgYmVoYXZpb3IuIElmIG1hbnkNCnZDUFUncyBhY2NlcHQgYXQgMk1CIHJlZ2lvbiBhdCA0ayBw
YWdlIHNpemUsIHRoZSBlbnRpcmUgMk1CIHJhbmdlIGNvdWxkIGJlIG5vbi0NCm1peGVkIGFuZCB0
aGVuIGluZGl2aWR1YWwgYWNjZXB0cyB3b3VsZCBmYWlsLg0KDQoNClNvIGluc3RlYWQgdGhlcmUg
Y291bGQgYmUgYSBLVk1fTFBBR0VfR1VFU1RfSU5ISUJJVCB0aGF0IGRvZXNuJ3QgZ2V0IGNsZWFy
ZWQNCmJhc2VkIG9uIG1peGVkIGF0dHJpYnV0ZXMuIEl0IHdvdWxkIGJlIG9uZSB3YXkuIEl0IHdv
dWxkIG5lZWQgdG8gZ2V0IHNldCBieQ0Kc29tZXRoaW5nIGxpa2Uga3ZtX3dyaXRlX3RyYWNrX2Fk
ZF9nZm4oKSB0aGF0IGxpdmVzIGluIHRkeC5jIGFuZCBpcyBjYWxsZWQNCmJlZm9yZSBnb2luZyBp
bnRvIHRoZSBmYXVsdCBoYW5kbGVyIG9uIDRrIGFjY2VwdCBzaXplLiBJdCB3b3VsZCBoYXZlIHRv
IHRha2UgbW11DQp3cml0ZSBsb2NrIEkgdGhpbmssIHdoaWNoIHdvdWxkIGtpbGwgc2NhbGFiaWxp
dHkgaW4gdGhlIDRrIGFjY2VwdCBjYXNlIChidXQgbm90DQp0aGUgbm9ybWFsIDJNQiBvbmUpLiBC
dXQgYXMgbG9uZyBhcyBtbXVfd3JpdGUgbG9jayBpcyBoZWxkLCBkZW1vdGUgd2lsbCBiZSBubw0K
cHJvYmxlbSwgd2hpY2ggdGhlIG9wZXJhdGlvbiB3b3VsZCBhbHNvIG5lZWQgdG8gZG8uDQoNCkkg
dGhpbmsgaXQgYWN0dWFsbHkgbWFrZXMgS1ZNJ3MgYmVoYXZpb3IgZWFzaWVyIHRvIHVuZGVyc3Rh
bmQuIFdlIGRvbid0IG5lZWQgdG8NCndvcnJ5IGFib3V0IHJhY2VzIGJldHdlZW4gbXVsdGlwbGUg
YWNjZXB0IHNpemVzIGFuZCB0aGluZ3MgbGlrZSB0aGF0LiBJdCBhbHNvDQpsZWF2ZXMgdGhlIGNv
cmUgTU1VIGNvZGUgbW9zdGx5IHVudG91Y2hlZC4gUGVyZm9ybWFuY2Uvc2NhbGFiaWxpdHkgd2lz
ZSBpdCBvbmx5DQpwdW5pc2hlcyB0aGUgcmFyZSBjYXNlLg0KDQpGb3IgbGVhdmluZyB0aGUgb3B0
aW9uIG9wZW4gdG8gcHJvbW90ZSB0aGUgR0ZOcyBpbiB0aGUgZnV0dXJlLCBhIEdIQ0kgaW50ZXJm
YWNlDQpvciBzaW1pbGFyIGNvdWxkIGJlIGRlZmluZWQgZm9yIHRoZSBndWVzdCB0byBzYXkgIkkg
ZG9uJ3QgY2FyZSBhYm91dCBwYWdlIHNpemUNCmFueW1vcmUgZm9yIHRoaXMgZ2ZuIi4gU28gaXQg
d29uJ3QgY2xvc2UgaXQgb2ZmIGZvcmV2ZXIuDQoNCj4gDQo+ID4gZG9uZSB3aXRob3V0IHRoZSBt
bXUgd3JpdGUgbG9jay4uLiBCdXQgaXQgbWlnaHQgZml0IEtWTSBiZXR0ZXI/DQoNCg==

