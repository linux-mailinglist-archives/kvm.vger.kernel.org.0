Return-Path: <kvm+bounces-17961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 098478CC3C4
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 17:07:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 359F51C228A6
	for <lists+kvm@lfdr.de>; Wed, 22 May 2024 15:07:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C8132C1A0;
	Wed, 22 May 2024 15:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mmzYvbFX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09325755;
	Wed, 22 May 2024 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716390414; cv=fail; b=UGSd66ksI/Soo8WgXLhR+pabRN3cjJlrA27CBV6kdKCMH54KvODCn3VFVwZ58uhzx4CfaDZ/2vepidvZdxsr9oFoWNT+CDpFlF9L19Dy+Jd9KSrH3DlShF1vSNPnmvUehA1B0qoUCZN3cM6r+upRK3Oda/Mk6qIvRqc533LDP/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716390414; c=relaxed/simple;
	bh=g7rzCWD1phSEQjUZLdohroaj3Td6HJ+WVD3hG3bW5p4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eX6QGQEHrKZXlHLsHh+SsejWUytIazk2LYZT1LRfppL9OC2aaZje3RbFp5XKiImQMKmzS7oVkoHxakYEBo37m439s+4zRp8/Os3uDRuyi80JegpFhd+2Rta7zd5L43ro3EyrXj2en1JAigwQM/u26rsiWT/1ZC9508Na9BqfBc4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mmzYvbFX; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716390413; x=1747926413;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g7rzCWD1phSEQjUZLdohroaj3Td6HJ+WVD3hG3bW5p4=;
  b=mmzYvbFXaIJo5+ymHXuzKL12LuCWOBtQ5HOpgFkspwnUpRcunDaTAwME
   orJq/1cOuHCjqS7rTNShA9HQ4MEMsGiYmD7B4HvWyDtbhlaWVk/mgMY+T
   o6nLrojxLw0TNuWDKSbntCucX1oNUKAg1a8pKx+KIt/vKKZDEJUDk835n
   Pu3JeWWT79Od/1LjI9bZkEFOh3r8E6LMKiMopK0qZLRCZYrtdU6JoxI4F
   pawCuBxRO5Cnulo5Ws+a2ePib2IBM1z53Y2SoRdQsCXgtbl2z7K4ueieM
   RdX2LR+HXj2xzs3oUQHBtKitmWmrc4m87HcuXmOxfSAYX3CA6TeTgas3i
   g==;
X-CSE-ConnectionGUID: YlrP3M2GQA+hAdArOHbZpg==
X-CSE-MsgGUID: 3ciUfhPBT8KIBYArxCgWkQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11079"; a="16490996"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="16490996"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 08:06:52 -0700
X-CSE-ConnectionGUID: rMfsUW4+QzGsHqwgExM/JQ==
X-CSE-MsgGUID: 1kIBYjebT56BBTLfZ4wyBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="38289782"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 08:06:52 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 08:06:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 08:06:50 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 08:06:50 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 08:06:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mweucGQWO7zpRVgt+rMLvCMh2MYk2+Ka0C/pKT/ZEpgn3hlu+BnXCRS/VfQQc3o/AS4JajAyh6DCrnO2JbNZKouZM+EsZnSnZFr/6DElVo3UHGP0qT7t/i64ZAPtSV2EJotedm3Yvsd4UojNCqnvw83yGeE624802zkLyy/CwkmZwlaE+jOpDgdmKgzQMPQcrJfpbRnpxrS+k+i9btXVzR9eUWO37e2Spgwd2UfuQI3r8FuyO7n7We4O/b4kIUzeV7KHqEJE09ZVixqAaONXMfuG5DVUeKfUXyP3uwTqCYjNlnTHb4LoXHg/aqUCsjpgKLztDMF2DEjUu7Gjo6OhXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7rzCWD1phSEQjUZLdohroaj3Td6HJ+WVD3hG3bW5p4=;
 b=lzt10F4oaAT4tvk9PJge19eGBwPoK9rA9PlM+3Z9cw3N21Io/zDF5Nn3wPFQpruxvugERe+ynLHjVDBZ6Rn4s2lnUWuDtL+WxXTY6wE0DH1sW8yHWejWEAF+fHi0ZhCInwEu+1Y7moJc86RamyD5k9Xc9QzTVxDKWSu+8fptuho5f1tHVgxJY5QZDkZhZ1627qP3HEgM4YruuVqGX2oT1FRr1tPwpqwWala2jg1LsZoKBIlqZpxsC41IfXcFhzS/XXH0h9b/Eahgfv9YrD/ED9YWSikSdvTQBDe2ai/dOPU3XIl1ZrZvL7CAEQ8eiAigB5aIK7qpVlXt7FdTMl9t9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7649.namprd11.prod.outlook.com (2603:10b6:8:146::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Wed, 22 May
 2024 15:06:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.016; Wed, 22 May 2024
 15:06:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Thread-Topic: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Thread-Index: AQHaYwfynhk8CrwGC0ayixDi2U+bW7GDdNgAgBaGEYCAAHzagIABMoyAgABcJACABGfugIAAfJEAgAABmACAAptQAIAAZWkA
Date: Wed, 22 May 2024 15:06:47 +0000
Message-ID: <40fd07cbd39c8c8911b2e46f2314f7dbf20d4a9a.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <20240219074733.122080-25-weijiang.yang@intel.com>
	 <ZjLNEPwXwPFJ5HJ3@google.com>
	 <39b95ac6-f163-4461-93f3-eaa653ab1355@intel.com>
	 <ZkYauRJBhaw9P1A_@google.com> <87r0e0ke8w.ffs@tglx>
	 <ZkdpKiSyOwB3NwRD@google.com>
	 <a170e420-efc3-47f9-b825-43229c999c0d@intel.com>
	 <ZkuD1uglu5WFSoxR@google.com>
	 <df5fa770-1f9b-4fa7-a20f-57f51b0d345b@intel.com>
	 <12ccd0d3-e9a8-47b6-9564-7146d0a79f3a@intel.com>
In-Reply-To: <12ccd0d3-e9a8-47b6-9564-7146d0a79f3a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7649:EE_
x-ms-office365-filtering-correlation-id: 3d6bf847-7692-49f4-fd99-08dc7a70cd3e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SktPNE1wWEhLNkczZmZ3WFJCaS9IcmxGbmw1WUtWa0JhYVV1cndmSWxIS3Iy?=
 =?utf-8?B?Si8vekdRb054OW5rYU9DelVVZTVsUzhZV0dSM2o2ZjFSQWZVWW15WTVpMS8w?=
 =?utf-8?B?QlpOZS9PTGJveExvWW42WXNJS2tqU3J2eVVycWhJQ20vOGVoZlEzbjFTMTZt?=
 =?utf-8?B?YjduckcwTVZ3L1p6K09sMVN6TEtFUXlDRCtxb0pqWFhtS2dVVzBDbzZ1VENV?=
 =?utf-8?B?eElGKzgwM211eDVqNUNFR1BsdmxZdnFJNzRNQldRUGxScnZVa25ZN0FOVzV1?=
 =?utf-8?B?Z0ViY0tNamk3TCtDWEZWbnowZ3VScm5UdldUdm95Y0RiUDlBUkFIemZEUTNi?=
 =?utf-8?B?eHNIN0tIZVNuMUZwZVpLRnM0MDF1RmRRYkV6dEpsenA4clk1d1FRaXFiK0hx?=
 =?utf-8?B?NTNUakZpcHllb2RndlV6TWVxeFluWlNjMDNzYUE0R241REozaGUycU9IQjNK?=
 =?utf-8?B?R0xZaVlIOEdNVzlXcm5DN3d1ZnhZNkgzeE1Zc1UyNlRQc3hnMDlOK3hEMy82?=
 =?utf-8?B?OWloa215UnVxMGJ3NFVyY3V5VUFZMDR0NjlGRTZiTDNYYlJIM0RBWGhCRWZN?=
 =?utf-8?B?ZmFDUHUrckNJQjFYN0RxRjR1Vmk3dWlMU2paVkt0VENxdldqamlsRzdVQ25B?=
 =?utf-8?B?NE9PU21DVklNRmZ6aEUvaDBRcW5sT1BFRzJaNHZEU3RxOGR5UHRCbDU2Z0p0?=
 =?utf-8?B?MEdUV2JiNE9EdHNZMENWbThmck1zWmpoaVVxaUhVcFRtRWo5QzdWKzYxR3JD?=
 =?utf-8?B?dXNWVFpYaFZYTEZjbEE3b2pQaFkzdFNCUmF4S0MvTExLMFE4c3JSckR5dTNT?=
 =?utf-8?B?ZHh2SGV2M0l3NVhsMXMvZ0hkaEJqdnhiWHR2OWVxdnRXaTIyODhpaXQ3QXRn?=
 =?utf-8?B?ZnpLU3gyaUJ0YldYL1JoaW1rZWNSMkpTN09xTlBIVWc3eFZBU09LWUVSQ25U?=
 =?utf-8?B?bzZnWktTZm5td1orQjIzRTZnWHdGNlZhVWVFRkhXYzNDWGZRR2IzNG5PSjMy?=
 =?utf-8?B?V0dIMm1EU2k5azZmMlhLaG03R1Q2azBNVEE1VEZjbjRCRVR6NlEveUpaMFM0?=
 =?utf-8?B?UFoxeit0R24yN3NnQkkrVXNLUGkydU5DSDNDMkVQYXZCYzRBbVBJYnNxYzNC?=
 =?utf-8?B?RGIwWGZSeWtLd3p0M0t4N3B3ZlBEeGpRdDJJT0xvZDlycUZlL1BzNUJJM1Zw?=
 =?utf-8?B?QXhSQWFCMFcydE9PWkRReEpQTER3dnc2VEZvVEdTakN3cE05WlpwZDBNeE9P?=
 =?utf-8?B?U0VleU5JRWFrc0lTVFF4LzJYbk5FYVdaUkJta21aYXFVSlRQT1pRYXBuRHM0?=
 =?utf-8?B?a0k4MHFsZUQ5dUFPUnhMQVROb2ZESmFGeUdQTUwxRFNRTGJMdllSV2FaZm5o?=
 =?utf-8?B?S2RDWVcxdTBDeVFXL2VVZzFWMzVXbm01N3libTh5NHZ0M042cDJIMm1vZnFu?=
 =?utf-8?B?NW4zRFg1ZkdjNkZINmRLRnFXN1JxVFp6LzdZUXFXTFpDL05NY1dwWjcxQ25l?=
 =?utf-8?B?YkVMNEN3bVNZdmlLSDVHRE9lajdNTTRTNGZTbUlhRSt4K0VGeFg0SGhHdFBy?=
 =?utf-8?B?ZHV0dVYxb2luSE9HZlJrczR0ZjlkU3c4VmprbHJ1aHV5a3VoMDZvMWEwTzc2?=
 =?utf-8?B?aGQ2VURJL1RmeU8xTlJodUYrOG94cS9pdTZYNWdiQUdXZVZXQ3I2Z3d0QjM3?=
 =?utf-8?B?bXNhVzR4UUJuTldoWVlXZ2VyejI3dm5yUC9yMXIvQjQvTjlSc1lmYVJ3eGpC?=
 =?utf-8?B?bSs4ckNKN2txQ1RYVHpZRG5KK1lFZ2tjTVV6eFhPbWZ1andWdGZuYWFUVlQz?=
 =?utf-8?B?ZE9NQTBBcVBTY2trek5VZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUdGUThSWnVVNE5aUmlGQ3RlbmtqSUFKTFVqT1l3WExqcmRWaHhMam9iTjUz?=
 =?utf-8?B?ajJ1MUJPYThkWlJNQWZlMThaVWdEdFlqUDg3SVdiYjlkME5hOEZqbXR6bjVk?=
 =?utf-8?B?bmNQV0ZKUEZ2emRrc1gwRUxCbURTb1ozMytKcU1QaGllcDZHbTBoSGdiUHE5?=
 =?utf-8?B?Q3p5bFNuVGt2QXhiL2dYQ3pkempKbUhnSnFEMUxiN2ZrOGpZZWx1WE4vTjNm?=
 =?utf-8?B?VGZoSXFuL3BEWGlZUm5EeFRUNkNyYUN1VmgxSXBZaElrZHRtSWx4VWs3aTB3?=
 =?utf-8?B?clEvaWRpb3RVVlRReWpRQWJYTXMxakN4dEgrVklvTGE1Y3M1bmxXMjVYaWND?=
 =?utf-8?B?VWVHenBqazdyeW1kYnJnUXJhOURJcVByQzRmQmlnUTBRQmZxNlA0VTdtZ2xN?=
 =?utf-8?B?aDBveEJGZUtxcEZKWnd6WG1kRjdmd3gzWVlLYUhhZmN1eEIvZVA3VGlteTFp?=
 =?utf-8?B?b0hqZVVWSHAvemw0bjlpOENGZDBFNTRpaWRKNHM4QksxYU9pbCtycUpSWklJ?=
 =?utf-8?B?NGNWbXN5dFNXQU9yaVUwSTI3SmNmUVdPdTRYN0ZsdHNDQUlkUlAvZzNFUGdj?=
 =?utf-8?B?c0R0TDZzcGlBTGhuTzVvUVNjQnFZMUhXSXE3ODVra3JIdWFhdG1OeDV1akkx?=
 =?utf-8?B?UzlHS2wwQkJRZy8xcmQ3WGxqVDZlbms0LzRaSU1IV05VVktWSzU2OXJqZlQy?=
 =?utf-8?B?Q3AxVjkrSjY1Umo1T1RHYU9HZi9YeHQzS2Q1N1QzOWZiVUtyZkh5NzJHaEJP?=
 =?utf-8?B?dnpiSERjNFBkbTRpQ0JnSEJBN2kxYTVhWnlwQk10anEvb3dwenVhaStnT3J2?=
 =?utf-8?B?SGdqSXVPR3BOZWx0ZCtDN3Zzd3Niakl4V01MamxuNndNUXh5QndqSFRRd2or?=
 =?utf-8?B?cU05YjhIa3Q5anp5clVHbGxxUDlMRW1RdW9xb0l0dWp0bndWZWUrUnpRTFlI?=
 =?utf-8?B?TEdybG9TMDJWWHg3NVB2YTFUZ0JuZkN5TTJ6dDR0MmQ5RDNlbm90MVBNS0cw?=
 =?utf-8?B?Zm1ZZ3hGZllxWkt6dlF1RUdpelZwWlRpMXFDdkVYK1pDZlJKVmwyc0ZFaXJT?=
 =?utf-8?B?SVo3Wld2aGI2OW5wRmlxMjhPS1R0ZERXOUNpRVhwTm5WOVYrV2JySEVEdkJy?=
 =?utf-8?B?dk9YUWI0UldCOFhzak9FTFgvK1pYWStYUk41T0JKcko3TUZYUVNpaThNL1U2?=
 =?utf-8?B?RkZndjVUY1k0bVozODN1Tk5adytvWktweUE1dXhOaFhjQ3p2RTcvV2I1MUZN?=
 =?utf-8?B?YmN4ZCsyM1JscWpJZjNzd1hwNXpPTSs0cTkvSTVNYU5GV0JqL2pRQnd2bGd4?=
 =?utf-8?B?K29zMUVJa2FFMnNSSmh0ak9WMGdQSXlmN0ZYYUYvK2tHVGcySEVuNEtaM09R?=
 =?utf-8?B?S2piazQ3UnpOdGdSUGZhVFZ2SThzZTM0L0xvZ09GQzVsZEdWSC9ZY2lCTWZy?=
 =?utf-8?B?TEpBa2xqT2Z5S3c5eXdGQitjNEVkWkZOaSt0Wlc0NUJ0T0hKWG9SZ2xrSnVO?=
 =?utf-8?B?Mkh1cGdza2JOVis3c05pRHRVajZOdVBON0xMZjVtQUlXSmZVbCtzdkxRK2Jy?=
 =?utf-8?B?UkRTbGphTHd6cFpqbFo3cnhFekRKUmlzbDZ5RkRRYnhwaUM0WURLVVltOEha?=
 =?utf-8?B?amRqN1JoSjkrLzB5UFpsdDBRMDRpUWw5eW1icU5qZVdMalkvMVVxc1dtM1Fa?=
 =?utf-8?B?Z0RhajJzdTZ4Mmw5OGJoQW5UOFZZVGZnMTNLN3R0RnhzQzN1d1FRT0svREdz?=
 =?utf-8?B?TEFPZE9XY1hubXo5S1Uwd0V4bWtGYjFCc1NobUdmYTZ1MjNmQVVraGNsMEVL?=
 =?utf-8?B?MXdxY2xPdG1YS3RXYVYzbmZEZzNNVzhZUDFqT3RsczdZaXJGdDA2amxSM2NM?=
 =?utf-8?B?dCtsY0s3YnRlNEZoVDBEV3Ixb084UmlSYk9KUmVoK1dzQXU1R0ZlQ3cyUjli?=
 =?utf-8?B?WGgwOEJ4YzNGelo5b0ljVG1OVXhzOGdJOEI3U0xRSG1jdzNnV3hFUis4eWdV?=
 =?utf-8?B?M3BXbHpuNUkwM0w1dXZUVGhtSHdKWkppeEYxVWVzWGVaWmFNRGxEOU1OMDVC?=
 =?utf-8?B?ZXhlYk1WZjNCemxpcFFJWlBiSjRTZnQrVWxWbHJwRmRYMTg3NHp6UVVrNTZz?=
 =?utf-8?B?SWhVSEVhdXRPY2RoYlJlRG00TVIyMWNRek5BcGJ6ZXVyYWt0ZG9BK1lpYmR6?=
 =?utf-8?B?VkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7A39F031895A84C8998B8F4207C1299@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6bf847-7692-49f4-fd99-08dc7a70cd3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2024 15:06:47.7875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ntud9qMOpDkVRDf9J4p/euQadCNZazNBWl8oarGrXM32NBhzR1SkTau1mgcumNdCIROF1oEa1e37MeWsnE9765JH0+rM6zl4aoXZqhKPX5w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7649
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTIyIGF0IDE3OjAzICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gU2lkZSB0b3BpYzrCoCB3b3VsZCBpdCBiZSByZWFzb25hYmxlIHRvIGVuZm9yY2UgSUJUIGRl
cGVuZGVuY3kgb24NCj4gWEZFQVRVUkVfQ0VUX1VTRVIgd2hlbiAqdXNlciogSUJUDQo+IGVuYWJs
aW5nIHBhdGNoZXMgYXJlIGxhbmRpbmcgaW4ga2VybmVsPyBUaGVuIGd1ZXN0IGtlcm5lbCBjYW4g
cGxheSB3aXRoIHVzZXINCj4gSUJUIGFsb25lIGlmIFZNTQ0KPiB1c2Vyc3BhY2UganVzdCB3YW50
cyB0byBlbmFibGUgSUJUIGZvciBndWVzdC4gT3Igd2hlbiBTSFNUSyBpcyBkaXNhYmxlZCBmb3IN
Cj4gd2hhdGV2ZXIgcmVhc29uLg0KDQpJIHRoaW5rIGVhcmxpZXIgdGhlcmUgd2FzIGEgY29tbWVu
dCB0aGF0IENFVCB3b3VsZCBiZSBsZXNzIGxpa2VseSB0byBuZWVkIHRvIGJlDQpkaXNhYmxlZCBm
b3Igc2VjdXJpdHkgcmVhc29ucywgc28gdGhlcmUgd291bGQgbm90IGJlIHV0aWxpdHkgZm9yIGEg
c3lzdGVtIHdpZGUNCmRpc2FibGUgKHRoYXQgYWZmZWN0cyBLVk0pLiBJIHJlY2VudGx5IHJlbWVt
YmVyZWQgd2UgYWN0dWFsbHkgYWxyZWFkeSBoYWQgYQ0KcmVhc29uIGNvbWUgdXAuDQoNClRoZSBF
REsyIFNNSSBoYW5kbGVyIHVzZXMgc2hhZG93IHN0YWNrIGFuZCBoYWQgYSBidWcgYXJvdW5kIHNh
dmluZyBhbmQgcmVzdG9yaW5nDQpDRVQgc3RhdGUuIFVzaW5nIElCVCBpbiB0aGUga2VybmVsIHdh
cyBjYXVzaW5nIHN5c3RlbXMgdG8gaGFuZy4gVGhlIHRlbXBvcmFyeQ0KZml4IHdhcyB0byBkaXNh
YmxlIElCVC4NCg0KU28gdGhlIHBvaW50IGlzLCBsZXQncyBub3QgdHJ5IHRvIGZpbmQgYSBuYXJy
b3cgd2F5IHRvIGdldCBhd2F5IHdpdGggZW5hYmxpbmcgYXMNCm11Y2ggYXMgdGVjaG5pY2FsbHkg
cG9zc2libGUgaW4gS1ZNLg0KDQpUaGUgc2ltcGxlIG9idmlvdXNseSBjb3JyZWN0IHNvbHV0aW9u
IHdvdWxkIGJlOg0KWEZFQVRVUkVfQ0VUX1VTRVIgKyBYRkVBVFVSRV9DRVRfS0VSTkVMICsgWDg2
X0ZFQVRVUkVfSUJUID0gS1ZNIElCVCBzdXBwb3J0DQpYRkVBVFVSRV9DRVRfVVNFUiArIFhGRUFU
VVJFX0NFVF9LRVJORUwgKyBYODZfRkVBVFVSRV9TSFNUSyA9IEtWTSBTSFNUSyBzdXBwb3J0DQoN
Ckl0IHNob3VsZCBiZSBjb3JyZWN0IGJvdGggd2l0aCBhbmQgd2l0aG91dCB0aGF0IHBhdGNoIHRv
IGVuYWJsZQ0KWEZFQVRVUkVfQ0VUX1VTRVIgZm9yIFg4Nl9GRUFUVVJFX0lCVC4NCg0KVGhlbiB0
aGUgdHdvIG1pc3NpbmcgY2hhbmdlcyB0byBleHBhbmQgc3VwcG9ydCB3b3VsZCBiZToNCjEuIEZp
eGluZyB0aGF0IGlidD1vZmYgZGlzYWJsZXMgWDg2X0ZFQVRVUkVfSUJULiBUaGUgZml4IGlzIHRv
IG1vdmUgdG8gYm9vbCBhcw0KcGV0ZXJ6IHN1Z2dlc3RlZC4NCjIuIE1ha2luZyBYRkVBVFVSRV9D
RVRfVVNFUiBhbHNvIGRlcGVuZCBvbiBYODZfRkVBVFVSRV9JQlQgKHRoZSBwYXRjaCBpbiB0aGlz
DQpzZXJpZXMpDQoNCldlIHNob3VsZCBkbyB0aG9zZSwgYnV0IGluIGEgbGF0ZXIgc21hbGwgc2Vy
aWVzLiBEb2VzIGl0IHNlZW0gcmVhc29uYWJsZT8gQ2FuIHdlDQpqdXN0IGRvIHRoZSBzaW1wbGUg
b2J2aW91cyBzb2x1dGlvbiBhYm92ZSBmb3Igbm93Pw0K

