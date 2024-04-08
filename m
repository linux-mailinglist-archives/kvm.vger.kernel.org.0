Return-Path: <kvm+bounces-13909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B846D89CBC9
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 20:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDF821C21B96
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 18:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6111272BF;
	Mon,  8 Apr 2024 18:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mFF055rQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF5E847B;
	Mon,  8 Apr 2024 18:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712601544; cv=fail; b=ZDhf2OFB1Mk1esfl5R8zizc/5EMnFRgEAzclrAmQ7et/u1uDDovwE6XLDqXV65fxXxKObEGPMR+cPlXHVoIbwKpSODhe5KQ3gSsi57rEuUj8UV6h1R78Esia5DePPldTbZG/mHRjSr7oCUmgv62xIfm7b+jN/OKFMH38/nxDAtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712601544; c=relaxed/simple;
	bh=pC+otzdF2Hdp8oNYzFKAc3pACzvBQ3PeFz50pgzL9t0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IL4v2rLFq4IdubaHZAdxBBIn6TSY22jXpLGlUvHMM/MqK8zlvFDeielzvIC8kkIfUao51ChWexZrFFje5CiSiVZwu8WrH6dIxMFF4EnpUaEWOzkmVlnHWjCHdEGpj/UFRSMfZf+INtdBcbMToD7H92IKxE1fcxcLSCWSer68BDs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mFF055rQ; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712601543; x=1744137543;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pC+otzdF2Hdp8oNYzFKAc3pACzvBQ3PeFz50pgzL9t0=;
  b=mFF055rQ/Xsh1Ji/w0ZLYAUVpT7qZqKcqC7E49iXmfL2AY8nMxTyvw3j
   NuYr/3RJy0fgYkjSnnUkE8SIZF6o4wzg5krNE8Qt83zPIXx2WqJtOUrPQ
   R/MBRWKEy5lhqJY+ue6uS/1gs7sfEklxcZ0qHinFWkKy00KHFOezqLuvK
   YZMXKcDVexf9iHIVZgk61bCxsRxqfPYNydfugi3c0cI15wcKGgCeZ4fAm
   SZaoQTndfn9tNJVJAOg7ckgfnQZ5IpjSZBIwJ1YenGmJLi5W4EvW2OpSf
   wuAEDXeu6XfiQ5QOzmRvEYnK0CT6wODZmquPMKtuuY0Vn8Wil5IkFKsfC
   g==;
X-CSE-ConnectionGUID: er04L7WmTuefNvORtuz1aw==
X-CSE-MsgGUID: AajhU7yrQyaH/xq+aSscQQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="8076406"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="8076406"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 11:39:01 -0700
X-CSE-ConnectionGUID: ayS7KknyTjSop0ECKUHg8w==
X-CSE-MsgGUID: ZNSAz4zzQuKh2W0jM73beg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="20029432"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 11:39:01 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 11:39:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 11:39:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 11:39:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 11:39:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMtCBelbIc88i4qa+9tGt9tM5WfQMbkmQAyseRNdfdH7BhZ8iCJ9vcJ89g2db8khyQZU3E8qN/i25WbCvSrptItNIrtZmy33F0++p17sut9jN2t2zjKKsJ3gJL/SFuYxfCtb3h8CofThvzd/8Uq5RrJUTX5lJYzq6I+gKxG+9qAekO3K3LFs9h8+e+B3YuvOoHmvzKOW+IgwN/UvhduhnMgEyqK4+uWtWUo+6NbmNUUQEYaiw684CpEIC50TiBFUJDUcuXCSdktiQuc9no1+S+ge62a9IWlEnT/Mo/vj8WgYj5JPHHGy0lLou6bUlNkyZZZTW7XUL+unRBzsrkc2jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pC+otzdF2Hdp8oNYzFKAc3pACzvBQ3PeFz50pgzL9t0=;
 b=WO4672Vs+Ik/lEesZwx1FCercWJsn8xOqg0NX30Qq7tk5MQbzdi4sI+ZvH6++f1cfGhtkFxunLk6/KxZ0OQNe8PjmDPzj5+wCbKDso168KQYyBl2G5lc8GTgWZxG76jDJbRXXab9iw4bMXaE/8YjsnW0k64umzwp9WtmmM+lGJQEmdFyy36IuJNSHszIA0Ot9SG/iJJ8wRNxPFwoFPQAxDYN+CUFYlHh4ewV6lqbBD+m3l9xu1itzmkzCcTQUbwGuYgCJUdxDmbTDcgT7L0HBYrgJtYGQ4SziFBfymCv/be2Lf3RQeh0RC+BGCJ/Yv1YnUsbQnhuz2IP/VbvxsbSUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA0PR11MB7378.namprd11.prod.outlook.com (2603:10b6:208:432::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Mon, 8 Apr
 2024 18:38:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Mon, 8 Apr 2024
 18:38:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHadnqikJftpAPTRECy6a/NFCG2mbFe2xEA
Date: Mon, 8 Apr 2024 18:38:56 +0000
Message-ID: <c11cd64487f8971f9cfa880bface2076eb5b8b6d.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA0PR11MB7378:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aforw5CPBS5EJqJdYvj4e1PZyUYdKuuMzpKXMLmaFJ9EBVEJdmk/tp5IsfF+5xK2X31A+y/YY7SeV+nUBBEYwQCCwCF+rD3s80WqLSkZLLoGEM9Ff0aSd7NEILVR/YtaGauuNWzZHR8IePPh8srgqkx6KZbdBLrqz8B88UXvbzdGsmtxfsXctmHnWJNdKf3dbq8Swf7eJaBEPs3iPg5ilX8UVictX6/w1ocXmagDKWAWPwSB8QL6lvllFaZs1OPypLUSfzmf4cgWazUAUj2lR6L6/zb2CHGX4cuZvAShrxMYQBGrJXd0zx0xYCGv+oJ1SBYthawt62tR4GSNI909HKRpPFsiBTX47qyVc0iVltKhp490bUwh2RN6L96dQiJMmNexS0NaPhw7Cit2amMXzooWJObSRLGhLe4WF8wZnu36UFlfk3qrxPuQiAkBkjacWecHQFGInxggCxNGsEivnxbYsty6rijEsTDnuRS3StQ95/jzFdMghA54gks+C2dM2Ue0RtZCYSYFdENB2htvTiVyQ+C6N5jNnEcflp8obGsJLT8uP+iZ8toBSi/MsyviNbZCWqeXh54AL9D/1GkLj7VExQ7AGdLZRJNCUVxchciCP7QtMXa/E4Kt1wA+i9+KqT9/kNt6r+yAnLYVthlLJabrLI+9fCnqCVs2TDBc5OA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUpTVGdPMnNnRGJTNUtLWmVoK2pMcHZPSmJzR0lTREd3K3BWK1VDUVR4dzMw?=
 =?utf-8?B?Yks3ZGZYcHVGTDYxMFhZcFRZRUlxTWhjTmRpbEU5YkhReDBkYVd0bkluUnFC?=
 =?utf-8?B?TytBOTZBd2pJdnhhUldSeWhOVWZEYkVjNm5GQjdIUXcySjc4bFJVMWV1c25v?=
 =?utf-8?B?Sk5ZaHpkZ0FXc0diWnNZeG9RcmlWakU3eFNQZWw1QVVhSTVUWEovTTdSM2tz?=
 =?utf-8?B?ay9kNWtFcEpqY01BZ1JobDUwWDBCTmxqb29jWVNtVUlVcGFtRkZSOFdUc2Ev?=
 =?utf-8?B?d0EvVHBaQ3h5anVEUlhBZmF3OVY0TkRqeGFWdUVIU0R5Z2QyUWVXWnl2OHYz?=
 =?utf-8?B?VGxPYzNJWElJejZMNkhHVUlCOU51RWtQbzM4cDR3ZGlzaGJLVEpmZVRJWk9T?=
 =?utf-8?B?eEJEOEZUS1hRL29vUGdseXp2Q2FzV1dkUWJpYXZLc0RWN2h2eW43b0Frd3pQ?=
 =?utf-8?B?VUlwbHlJUmVjV3dhK1lDalE4TFh6ZmJFbitnb0Iwd3RNdG1mb21VTjY2bmNx?=
 =?utf-8?B?amZ5MW5oOGE4L1Iydmp4NVhOUHJqRWZhOURFZlZrMFRLRGNJc1VLKzdRUHFI?=
 =?utf-8?B?NlhFWUNTWG9ZQkpRMzI1c0svM1ZFWXdydk9LWHRZTi91cXg2dVdiaEI0Wjhj?=
 =?utf-8?B?NkNpMlQyTVA2Q2RTTmNSZU9kZmhsZmlZZUk5djZBVEN3YU02LzhycG9ydnZk?=
 =?utf-8?B?SG02NFNUa2ZrWWFnY3lzbThPMkFONTMreUFFOHNKWWg1cUdBOGx0NjZoOHJE?=
 =?utf-8?B?bnBCYk1HelBVZnowdmUzNnljaHc5KzE3bW9CcHFSakRiTmp1L1JCbm9JSjB3?=
 =?utf-8?B?cm01Z2lkdzZoZEsweHN2cmV4YUpUMUxNRTNmUm9peTk0OEdmTE5LaHh5U0lE?=
 =?utf-8?B?bjBEWkcveGIvbG0rNXdKNFl3a1g5cTk5dm14aVBBa1MyNHkyVDdlRGVmYVR0?=
 =?utf-8?B?ZzU1SHdpQkQ2ZjJ6MldBNmF2WTFTRWZaL0VYUElLdGt5SWZTbHJ2Mm4xOG56?=
 =?utf-8?B?bWtrQ2xBNjdFV0I5TTZ1Ly84SnJJWWFMb3lGZWVucCtmRk9BVkloL0hvKzN0?=
 =?utf-8?B?Sm9ERUdNVkdENlorSUVJcEkrWGtQc1JvbUpETldLc2p2WU5ja2IwZGlidStz?=
 =?utf-8?B?UFVzZ0U4K05JNUdvOTU0OWhsNThnWDVZQzJlMEQ4citidFkxU0QxeVNyeGk5?=
 =?utf-8?B?bzdHcWRLbEQ3M0VmVGoya0tZY1JyNDEzMUljWU5oejVLQ0t2aTZaU0JmbWNk?=
 =?utf-8?B?QXBJMFVuOHlIQ2hoc0RZZDhUTFYwUmE3STYwUjNsQUFqSjBmalN0OTUrempy?=
 =?utf-8?B?eVdKcWRuUXZIVC92YjQrby9RSy9RK2QyQTQ4YW9rUWRuR2RUbEQ1eGMzUGxG?=
 =?utf-8?B?clNLMHZNVVdEa2dsWUxNaHJYRE5wRTBQZzRBWDZqN001UERLZjloZ3M0ODha?=
 =?utf-8?B?d2RlbXZtM0t2NXowbldQUnJPWk13MFlwbGJvYnpydVJtbXR2czlrQzFkRUdp?=
 =?utf-8?B?VGloeW9WTlZ1TyttQnYvbW5pSEFISHVhVUxIVGdJbngwUElLaFd1dHdLWVl4?=
 =?utf-8?B?L3JJVWZRTm5sRmw2K0doa0NUWHRHRlAwdVlSMXZlMm5iT2pEOHJQR1lBRnNm?=
 =?utf-8?B?MFhmUytQZE5DT0Joekpyck5vUGVBejE3bjNRUU82Mkd3VUZBYklJVG1PRTBX?=
 =?utf-8?B?YnNJK3BPTE4xcEhGaEVlVGhwZ1FqMkVZdG9hVlhzdVRMN01wTGpKdW5UN05p?=
 =?utf-8?B?TnJPUkFVc1VGNUYzZjNsTkhkZkllQWlnazg4a1JTb0cxWWdMdUdXYTlFTmsx?=
 =?utf-8?B?UHF2ZGQ1TVdyYjFnZHRaRGtkRFZrbWlGTGgxdUVmalVxeFBOQ1VOcDg4aERE?=
 =?utf-8?B?T1NlRS9tcHJ6SU10L2ZndUx4NkdwVzF1YWw4QVVseWh0ZjRiRzJUenoweWZj?=
 =?utf-8?B?NWExZWVCM1dhb2RiR2FNSTVyV2pGQjNNNlRVK2paMTZEdjRJWWhLdzYwSDVV?=
 =?utf-8?B?dkhQYXRJNDUvR0UyeHp2dkFJMWhvcDI0aFc0QzZ1K21wRTNYTGZrV3JZcXpw?=
 =?utf-8?B?a1ZMTm1RdVE2V09oMUJCUUZQQ0YvWnY0V21rYkJhdTVFdTlTZFN3aVAzOFhl?=
 =?utf-8?B?c0ZLYmZueXhxTVROWlBpN3MrUDh4ZXVobUF4Q1hBU09VNlhYV1RHcEIzejVt?=
 =?utf-8?B?c1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73B51263DCF6694DBED2EF017EF5D683@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93756c19-b704-4ff6-0e2f-08dc57fb2633
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 18:38:56.8471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2lOBclL+TKwj4M6JA0pwbXuBvRFt/1yB9e/3n2uqS3PvkZFEpENN4W7VyGeDP9pkNOnSbDUBwC0WCgvT9ZpsZ56Fvmj25mNd57w02M4I4rA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7378
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gK3N0YXRpYyBpbnQgc2V0dXBfdGRwYXJhbXNfeGZhbShzdHJ1Y3Qga3ZtX2Nw
dWlkMiAqY3B1aWQsIHN0cnVjdCB0ZF9wYXJhbXMgKnRkX3BhcmFtcykKPiArewo+ICvCoMKgwqDC
oMKgwqDCoGNvbnN0IHN0cnVjdCBrdm1fY3B1aWRfZW50cnkyICplbnRyeTsKPiArwqDCoMKgwqDC
oMKgwqB1NjQgZ3Vlc3Rfc3VwcG9ydGVkX3hjcjA7Cj4gK8KgwqDCoMKgwqDCoMKgdTY0IGd1ZXN0
X3N1cHBvcnRlZF94c3M7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qIFNldHVwIHRkX3BhcmFtcy54
ZmFtICovCj4gK8KgwqDCoMKgwqDCoMKgZW50cnkgPSBrdm1fZmluZF9jcHVpZF9lbnRyeTIoY3B1
aWQtPmVudHJpZXMsIGNwdWlkLT5uZW50LCAweGQsIDApOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChl
bnRyeSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ3Vlc3Rfc3VwcG9ydGVkX3hj
cjAgPSAoZW50cnktPmVheCB8ICgodTY0KWVudHJ5LT5lZHggPDwgMzIpKTsKPiArwqDCoMKgwqDC
oMKgwqBlbHNlCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGd1ZXN0X3N1cHBvcnRl
ZF94Y3IwID0gMDsKPiArwqDCoMKgwqDCoMKgwqBndWVzdF9zdXBwb3J0ZWRfeGNyMCAmPSBrdm1f
Y2Fwcy5zdXBwb3J0ZWRfeGNyMDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgZW50cnkgPSBrdm1fZmlu
ZF9jcHVpZF9lbnRyeTIoY3B1aWQtPmVudHJpZXMsIGNwdWlkLT5uZW50LCAweGQsIDEpOwo+ICvC
oMKgwqDCoMKgwqDCoGlmIChlbnRyeSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
Z3Vlc3Rfc3VwcG9ydGVkX3hzcyA9IChlbnRyeS0+ZWN4IHwgKCh1NjQpZW50cnktPmVkeCA8PCAz
MikpOwo+ICvCoMKgwqDCoMKgwqDCoGVsc2UKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgZ3Vlc3Rfc3VwcG9ydGVkX3hzcyA9IDA7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4gK8Kg
wqDCoMKgwqDCoMKgICogUFQgYW5kIENFVCBjYW4gYmUgZXhwb3NlZCB0byBURCBndWVzdCByZWdh
cmRsZXNzIG9mIEtWTSdzIFhTUywgUFQKPiArwqDCoMKgwqDCoMKgwqAgKiBhbmQsIENFVCBzdXBw
b3J0Lgo+ICvCoMKgwqDCoMKgwqDCoCAqLwo+ICvCoMKgwqDCoMKgwqDCoGd1ZXN0X3N1cHBvcnRl
ZF94c3MgJj0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKGt2bV9jYXBzLnN1cHBv
cnRlZF94c3MgfCBYRkVBVFVSRV9NQVNLX1BUIHwgVERYX1REX1hGQU1fQ0VUKTsKClNvIHRoaXMg
ZW5hYmxlcyBmZWF0dXJlcyBiYXNlZCBvbiB4c3Mgc3VwcG9ydCBpbiB0aGUgcGFzc2VkIENQVUlE
LCBidXQgdGhlc2UgZmVhdHVyZXMgYXJlIG5vdApkZXBlbmRlbnQgeHNhdmUuIFlvdSBjb3VsZCBo
YXZlIENFVCB3aXRob3V0IHhzYXZlIHN1cHBvcnQuIEFuZCBpbiBmYWN0IEtlcm5lbCBJQlQgZG9l
c24ndCB1c2UgaXQuIFRvCnV0aWxpemUgQ1BVSUQgbGVhZnMgdG8gY29uZmlndXJlIGZlYXR1cmVz
LCBidXQgZGl2ZXJnZSBmcm9tIHRoZSBIVyBtZWFuaW5nIHNlZW1zIGxpa2UgYXNraW5nIGZvcgp0
cm91YmxlLgoKPiArCj4gK8KgwqDCoMKgwqDCoMKgdGRfcGFyYW1zLT54ZmFtID0gZ3Vlc3Rfc3Vw
cG9ydGVkX3hjcjAgfCBndWVzdF9zdXBwb3J0ZWRfeHNzOwo+ICvCoMKgwqDCoMKgwqDCoGlmICh0
ZF9wYXJhbXMtPnhmYW0gJiBYRkVBVFVSRV9NQVNLX0xCUikgewo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBUT0RP
OiBvbmNlIEtWTSBzdXBwb3J0cyBMQlIoc2F2ZS9yZXN0b3JlIExCUiByZWxhdGVkCj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHJlZ2lzdGVycyBhcm91bmQgVERFTlRFUiksIHJl
bW92ZSB0aGlzIGd1YXJkLgo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiAr
I2RlZmluZSBNU0dfTEJSwqDCoMKgwqDCoMKgwqDCoCJURCBkb2Vzbid0IHN1cHBvcnQgTEJSIHll
dC4gS1ZNIG5lZWRzIHRvIHNhdmUvcmVzdG9yZSBJQTMyX0xCUl9ERVBUSAo+IHByb3Blcmx5Llxu
Igo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwcl93YXJuKE1TR19MQlIpOwo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVPUE5PVFNVUFA7Cj4gK8KgwqDC
oMKgwqDCoMKgfQo+ICsKPiArwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiArfQo+ICsKPiArc3Rh
dGljIGludCBzZXR1cF90ZHBhcmFtcyhzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB0ZF9wYXJhbXMg
KnRkX3BhcmFtcywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHN0cnVjdCBrdm1fdGR4X2luaXRfdm0gKmluaXRfdm0pCj4gK3sKPiArwqDCoMKgwqDCoMKg
wqBzdHJ1Y3Qga3ZtX2NwdWlkMiAqY3B1aWQgPSAmaW5pdF92bS0+Y3B1aWQ7Cj4gK8KgwqDCoMKg
wqDCoMKgaW50IHJldDsKPiArCj4gK8KgwqDCoMKgwqDCoMKgaWYgKGt2bS0+Y3JlYXRlZF92Y3B1
cykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FQlVTWTsKPiArCj4g
K8KgwqDCoMKgwqDCoMKgaWYgKGluaXRfdm0tPmF0dHJpYnV0ZXMgJiBURFhfVERfQVRUUklCVVRF
X1BFUkZNT04pIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLyoKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogVE9ETzogc2F2ZS9yZXN0b3JlIFBNVSByZWxhdGVk
IHJlZ2lzdGVycyBhcm91bmQgVERFTlRFUi4KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgICogT25jZSBpdCdzIGRvbmUsIHJlbW92ZSB0aGlzIGd1YXJkLgo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgKi8KPiArI2RlZmluZSBNU0dfUEVSRk1PTsKgwqDCoMKgIlREIGRv
ZXNuJ3Qgc3VwcG9ydCBwZXJmbW9uIHlldC4gS1ZNIG5lZWRzIHRvIHNhdmUvcmVzdG9yZSBob3N0
IHBlcmYKPiByZWdpc3RlcnMgcHJvcGVybHkuXG4iCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHByX3dhcm4oTVNHX1BFUkZNT04pOwoKV2UgbmVlZCB0byByZW1vdmUgdGhlIFRPRE9z
IGFuZCBhIHdhcm4gZG9lc24ndCBzZWVtIGFwcHJvcHJpYXRlLgoKPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FT1BOT1RTVVBQOwo+ICvCoMKgwqDCoMKgwqDCoH0KPiAr
Cj4gK8KgwqDCoMKgwqDCoMKgdGRfcGFyYW1zLT5tYXhfdmNwdXMgPSBrdm0tPm1heF92Y3B1czsK
PiArwqDCoMKgwqDCoMKgwqB0ZF9wYXJhbXMtPmF0dHJpYnV0ZXMgPSBpbml0X3ZtLT5hdHRyaWJ1
dGVzOwoKRG9uJ3Qgd2UgbmVlZCB0byBzYW5pdGl6ZSB0aGlzIGZvciBhIHNlbGVjdGlvbiBvZiBm
ZWF0dXJlcyBrbm93biB0byBLVk0uIEZvciBleGFtcGxlIHdoYXQgaWYKc29tZXRoaW5nIGVsc2Ug
bGlrZSBURFhfVERfQVRUUklCVVRFX1BFUkZNT04gaXMgYWRkZWQgdG8gYSBmdXR1cmUgVERYIG1v
ZHVsZSBhbmQgdGhlbiBzdWRkZW5seQp1c2Vyc3BhY2UgY2FuIGNvbmZpZ3VyZSBpdC4KClNvIHhm
YW0gaXMgaG93IHRvIGNvbnRyb2wgZmVhdHVyZXMgdGhhdCBhcmUgdGllZCB0byBzYXZlIChDRVQs
IGV0YykuIEFuZCBBVFRSSUJVVEVTIGFyZSB0aWVkIHRvCmZlYXR1cmVzIHdpdGhvdXQgeHNhdmUg
c3VwcG9ydCAoUEtTLCBldGMpLgoKSWYgd2UgYXJlIGdvaW5nIHRvIHVzZSBDUFVJRCBmb3Igc3Bl
Y2lmeWluZyB3aGljaCBmZWF0dXJlcyBzaG91bGQgZ2V0IGVuYWJsZWQgaW4gdGhlIFREWCBtb2R1
bGUsIHdlCnNob3VsZCBtYXRjaCB0aGUgYXJjaCBkZWZpbml0aW9ucyBvZiB0aGUgbGVhZnMuIEZv
ciB0aGluZ3MgbGlrZSBDRVQgd2hldGhlciB4ZmFtIGNvbnRyb2xzIHRoZSB2YWx1ZQpvZiBtdWx0
aXBsZSBDUFVJRCBsZWFmcywgdGhlbiB3ZSBuZWVkIHNob3VsZCBjaGVjayB0aGF0IHRoZXkgYXJl
IGFsbCBzZXQgdG8gc29tZSBjb25zaXN0ZW50IHZhbHVlcwphbmQgb3RoZXJ3aXNlIHJlamVjdCB0
aGVtLiBTbyBmb3IgQ0VUIHdlIHdvdWxkIG5lZWQgdG8gY2hlY2sgdGhlIFNIU1RLIGFuZCBJQlQg
Yml0cywgYXMgd2VsbCBhcyB0d28KWENSMCBiaXRzLgoKSWYgd2UgYXJlIGdvaW5nIHRvIGRvIHRo
YXQgZm9yIFhGQU0gYmFzZWQgZmVhdHVyZXMsIHRoZW4gd2h5IG5vdCBkbyB0aGUgc2FtZSBmb3Ig
QVRUUklCVVRFIGJhc2VkCmZlYXR1cmVzPwoKV2Ugd291bGQgbmVlZCBzb21ldGhpbmcgbGlrZSBH
RVRfU1VQUE9SVEVEX0NQVUlEIGZvciBURFgsIGJ1dCBhbHNvIHNpbmNlIHNvbWUgZmVhdHVyZXMg
Y2FuIGJlIGZvcmNlZApvbiB3ZSB3b3VsZCBuZWVkIHRvIGV4cG9zZSBzb21ldGhpbmcgbGlrZSBH
RVRfU1VQUE9SVEVEX0NQVUlEX1JFUVVJUkVEIGFzIHdlbGwuIAoKPiArwqDCoMKgwqDCoMKgwqB0
ZF9wYXJhbXMtPmV4ZWNfY29udHJvbHMgPSBURFhfQ09OVFJPTF9GTEFHX05PX1JCUF9NT0Q7Cj4g
K8KgwqDCoMKgwqDCoMKgdGRfcGFyYW1zLT50c2NfZnJlcXVlbmN5ID0gVERYX1RTQ19LSFpfVE9f
MjVNSFooa3ZtLT5hcmNoLmRlZmF1bHRfdHNjX2toeik7Cgo=

