Return-Path: <kvm+bounces-46382-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2CDFAB5D2A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:29:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2B17519E36CC
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A948F2BFC83;
	Tue, 13 May 2025 19:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oByNSPKa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC8A191F92;
	Tue, 13 May 2025 19:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747164547; cv=fail; b=I8CXzzUhTXf4KFVd/ipgtabhoqAvOIdZiGImQusQaeOsBFXueyz6BLbJEw4cNGhFuvojQ36MhhwsAxQNh5EJ0v+3C82NaEEqwbPXqZsrJcmIcHwJtz5vmmXiBut4FtoVOPjaWZmVdRmYi9k5f0VgwtFZlco9nRsW9mNnSpSQrvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747164547; c=relaxed/simple;
	bh=ZPH0qyGm4PM2vNoHKeiTIpRmGkZFoO44cxYy86vicK0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sQrmEm1XqZs9COOWVVdvYSIgoKXGZOym/UzcxMO+oh1vkH/hQ9FrST9uunlmu68Zhbn2hsGYJHzo+voMdnISxWyBt3YzfQQO18N6l+XReV0nwd0DETvCp6Bq+T8CE0AtFEEFd09Y2HZ1SrORKpl1PzqkC3Sr0O2XUHZ6pOYkzB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oByNSPKa; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747164546; x=1778700546;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZPH0qyGm4PM2vNoHKeiTIpRmGkZFoO44cxYy86vicK0=;
  b=oByNSPKaPQrUpVFJ0mYG7vlVetHOT2JZCbtP5KADeBHIufbAG53MIzy1
   vrhds3233HhgtHl2H8u0T6enqCWFgIEcf2uvZbDwk+EoIPr0+rjIkszc+
   Blm7lPhPo78EYlTe5lEGfYnfBr+Src3p6tpo2r0NitHUxy5X1IJKcCtNj
   fYqyHp/W8rsPFXeZVbPxJb5qt6IFiRznBvdfltpeZfi7MFxxXk1P7iG1W
   /LTJJ+zPtMZNaQv6E/8e58S74wp8kSvdg9E097avDwV6EBhrWZT20DXrf
   xlpSYX8uLOcrFjdasUdrPHUEbnbJAIMnG5VrG7xelbdAwk8P+Dt2xM6EU
   w==;
X-CSE-ConnectionGUID: zqvNONmNSeSCGhA6p64kAw==
X-CSE-MsgGUID: HrqvbY8wTFyAvAv77IHIUg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="48140918"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="48140918"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:29:05 -0700
X-CSE-ConnectionGUID: GvdF/c9vQ5ahqtxGWl5hBA==
X-CSE-MsgGUID: fq8nYq4eRrWixuFEsWBNWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="168744526"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:29:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 12:29:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 12:29:04 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 12:29:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HJIrGKKUwjO0sfVngLPF/nYqXMU4y1O1uCZbqp5HuqJhCEgYCKpB+TuhzNMVMhAj42ZUckeLg5Ef4aitpEddZ/pmvk9UNhWLokDdm3a4kMvDxdIRS5c9/EVf4lPHB13ygcOxfwEtfQan/3B+nhmMy4jw2pJQ7GDnhYWdm4aNUIoCH2BPewY3KXu9YtEciAQFZ6Jx2Kf51VSqiNFQuJBWgoclHyhC6hhtgVbkXaonCsEtKE1m+9HYXZiVa1BixERdEYEjbTCOkjK2nhxRm7JZ7oVYd7XZrZyioE870sl6Er/dZ/dpP/9CCHo4pDV/cOg+4tV8asaL/cKK06PnbdvT1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPH0qyGm4PM2vNoHKeiTIpRmGkZFoO44cxYy86vicK0=;
 b=GYKXuqaZ5/wr3wY3UKjZQcCVzO4xCQW9UVphkk91kKxbaJZ434RnM9C4gcYyPD9/DihXYBZytgyPA5n19Loht1BuROUzDTmiotpn6JQqo0M0kADVghWSXZb/9dJWtmvdDDbaBM+q6lg/f9GxDVNNGJxyttXv2BRKqwjHWvuVZ+uw0NbAzUkiZz84tcp5JDnj74gKiEzZ1WKwxfJ5EXUYEVZblexx5cvnzAgrqreqj8Z1aA5byyDl+FwLILIKcHUMDFXXIqiDOddMelhGpZbjEvmqrEA6Li2RkYEMquRAhx2DaNmyKHH2fiaai2Plqasd0TCLcL6q6RCfdCu6Hfr9kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7799.namprd11.prod.outlook.com (2603:10b6:930:78::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.23; Tue, 13 May
 2025 19:29:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 19:29:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge pages
 with TD's keyID
Thread-Topic: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge
 pages with TD's keyID
Thread-Index: AQHbtMYReEDdaL+lSEC7fDtKyq53g7PREQCA
Date: Tue, 13 May 2025 19:29:00 +0000
Message-ID: <40898a3dc6637f89b59c309d471d9f4a8f417a9e.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030549.305-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030549.305-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7799:EE_
x-ms-office365-filtering-correlation-id: c9f35475-4dea-4a4b-658d-08dd925469d8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aWY1ak9YRGI3S29vWjRUWjNZVGpEQ3ZyZDBKRS92UWpaSklzdWdWby9OL0Iv?=
 =?utf-8?B?MHorSlFPSFRxOXNXT3pKV0U0SWpFckw0dEdIeExXU1A5Q1JUUmZ1TVBtVGEy?=
 =?utf-8?B?TVN1bmt5MUtJR0w4WjBJbVZkY0JqSFRGNHBJYzh3WkFyQmp3VGMxWmVlSWtI?=
 =?utf-8?B?Q2VDYytCY2lZVzB0ckhWSDVma002TU53RUY3ZzZOM3NydlI0cmlrVjc4YnFM?=
 =?utf-8?B?aXp4U3RNbmtPRE9Rc2QwVXpDbXdqSGt1VStaMVdDQU41NXo3Y0pDZTBMRHUy?=
 =?utf-8?B?TS83dFlXdi9EcmM3V1FXRGlmR1FVejFjbjJoczVwMU01VDFUUWJhNFpvMWE0?=
 =?utf-8?B?ZWlPSUs4ajkrYUEvM2VKMytycUxpdkcvSHZMbU9MQzJ3eE14V3dOQk1EUFRU?=
 =?utf-8?B?ajloNDhTd2kyTEJ4R0F1cC84bklrU0o1ckVhN1AxS3RTY255K25vTDA5UnR2?=
 =?utf-8?B?T0FUQ3huZjVqQjR2VWM1cDlPdkVQM1ZTMHdjVjhCNlhrS3FpalhqeGl6cmtI?=
 =?utf-8?B?ay9ScHE5OVdRL1hNdFlSUUR4azd2ckptWGxSWFpGNG85UnZwN0t3dHVSTVds?=
 =?utf-8?B?akRoTUZob3B5Ync5RDdJZXJJYmZEQnlZTVg1bW02Y1d6M0IydkFleUcyWkt1?=
 =?utf-8?B?QjlUd2NZa01YWDdjRjFCTjZFRHJzMWF4RVFaM0MyV3dnNk92d0RqSGg4RWl5?=
 =?utf-8?B?czVJUWJsTTNqam9qQWZyU2VlN3NYbzBTSlR0S1Q3akh6cmlHb0pCMGxkcnlt?=
 =?utf-8?B?bnNZeG9xUlpmRy9jL1I1QUFiS2tXMVBDcng1R3g5elJXaGNvREdqWE45OGpJ?=
 =?utf-8?B?SVBWaGRkbUluOTl5U1czRW1iSmpIRlRka1ZNcmlVL2s3Z3JJYm04Y3FoUlRr?=
 =?utf-8?B?M0Jya0xZQVBzRk1IUTNIMmFNMy9oOHduaTZvMXVQdnBjd0pqdG1GS3VHbHFB?=
 =?utf-8?B?S2NTUjcwdGRMbzZQTzlYV3RXaUpDT1J3R1p4ajFCRGpqaldjZXlDcVA0Wkpl?=
 =?utf-8?B?VDRlQUdnUi9ZZEUxdjZJSy9Mc0x6ajZPVHNDY0lzYURoYWFhajNDNUlGNjZN?=
 =?utf-8?B?T3lsaVUzVGdoa2tGSStwVWtxWDBjMmd6eHYvZWV4NUpuYTJKRXBOeWRZUmJ5?=
 =?utf-8?B?ZVpQaHhWK3JEczQvNnZUSmpNNkZyMDFWNXZpekNPZXYyKzN6Tnh3L2o4ZVJT?=
 =?utf-8?B?NWVkUEtBbFlFOW9Xa21WRUhSa1NRekVGeEJ4dzViOWVKNHVpUTZmdCtnZE1T?=
 =?utf-8?B?dEJja2dBZTBpcWRVN1BnYUM3RENoK1hLUlA5V3dJcGNJWERxQ1k1TkdBQ0dG?=
 =?utf-8?B?ZzZYNnBJc0hrZFdDVXpPMmVacHQ1WU5ZbVR1VTdEYmFBeXlhSDZPSWZVcXVM?=
 =?utf-8?B?RzcwSTBCWlh5akI4VDZVZDdYZjdKTVlwVTBnMlBHTUVDZHhxdFVSWm9aZUY2?=
 =?utf-8?B?aC9nWEhYeEZvWHdENXJTZld4ejFWUFVnaDhlck5tMk5iOFZoNTEwT05zY0pj?=
 =?utf-8?B?bENmbnBxeUttZUtQejFOcFIzYjh0TUptYitBK0pBdlRwK0xRZVQ1bm1XOWx4?=
 =?utf-8?B?MVZwd3FjZ0NHbHB4Q2VzNjNWMXFhSGMwUE0yaFQ2MnlwMUt3ZWd0SmllQWhB?=
 =?utf-8?B?YUtVNDFPT3V5bS81YUh1VytqeFptT0FMSG0vNUE0OXhLR1VFVmJ1WHJtdEto?=
 =?utf-8?B?ZkhrR2Exb1FCZmNKV0RpOHdWLy8zWTAxNC80RU1nVTdVUEVFd3RzRHVvRlpS?=
 =?utf-8?B?TWt5Vko5TTdORkFvenU0VW9IVzlOc2Q0WG1lM1Fsa1VRQ3RuNmFwem13R0Zr?=
 =?utf-8?B?K0NRV3I2OXVpWllPOHhsdWVzbjdzdDBqeGRvS3JibGx1TGtjckVSblNOYm1a?=
 =?utf-8?B?Vjljb3VMNzRIWXQ2Qkt4ZzdzSG0rVHIyMWlPdUw0YzlQNTFuTjdtRVY2dEhi?=
 =?utf-8?B?Mjl4Zis4bkpoamtzVGhnRU5iR1FPcy9aUm1mU3dwbUs2RjVIU3MzaUE4NmJ6?=
 =?utf-8?Q?wP4B2LE2mOAwQvmQK36s4G9LanjqOc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z3lvSzlqdmFzVTY1SitmWFUwMVVJTUcwTWRVMEdvTFBKRFRHdHFKZE9QZisy?=
 =?utf-8?B?bE5HQWRvR0NxLzZqZnFQS243YmtkZTRUcGQ5eVhWbGIrSnozNGRtbTVTTTVo?=
 =?utf-8?B?WUNGeDRFd3RuQ1FYZ09JdWF0TlpOUmRMRE9aVXhJckUzMmQ2bjArMzVHUzBK?=
 =?utf-8?B?em81SVJZUyt3NzhsTmNmajFkQXFTbzNpQkNMSmUzcFQ4RitZWGhkNm5ZeGQ1?=
 =?utf-8?B?TzU5K0Yrbmg4NnRXOUt0ZVVzRCttVzUzWWwvelhzUCttSGR4RU5scnhNaENK?=
 =?utf-8?B?TVJUVUpDL2lwUWVaRWtwbVBYQVljTmZyajd1V055RGRWajVvTi9BKzJ3a0U1?=
 =?utf-8?B?UFMwLzdUS1J2Y25MOGRuZGRuYmtRTWt5YzBXV1lJQ2tTUzBVbnU0V2wwV090?=
 =?utf-8?B?Sy9oeUdxN1pwT0Q5UHpEb2RhdkRyYVZjUnZDRkpMZkxzS1hYQzJrZm9xRi9X?=
 =?utf-8?B?T05MMmtvQ1FOcW5qR0s1Z2UweU4yTGs5eHA3R2hTK0xYRGNycjlPaWNJd2xW?=
 =?utf-8?B?RFFkQzdoaFZjUlF4N0R0MUxBODR1bzhSdmVxRWlxNkh2T3gvYmtSVVk2U3Yw?=
 =?utf-8?B?UEFweFJHL0NjK1kxZiswbHh2UlBEc2Q4cjRRNlFVcDZxRUNTNnJzS1FLbGRt?=
 =?utf-8?B?VWFQaGgwdnNCRUgxTVBFSUc3d1NWNU51VVBWYnJZQVJTOXVGM1VNcHRRRmtQ?=
 =?utf-8?B?R2hWdEwvM2FYeHM2b2FYWnpEbXl5YUltWGI0NFZCWnRWd21OZjhWSUc3ZlBE?=
 =?utf-8?B?WSsvOC9UZHNEYlFDMEZaR1dQRW5GbjZ5UzNKNHhZQ2tiSUhEUzBwQlgyL28v?=
 =?utf-8?B?OEk5K1hSN040K3JLckc1QkZSQVNoU1p5WXFOV0hxUnBVVThiWHNCQzdoblZO?=
 =?utf-8?B?d1BHcS9VcjF1R2RqVW1RREpUdCsvS2dNUG0vNjFIZ3pOWWFKcDZCSWJ4Q3Fo?=
 =?utf-8?B?WHpZQlRyRk1DeWJyUTBmWnN4RFZaOGhzODdOMmE0Y0pLaGxhU2JZK0dCKzhK?=
 =?utf-8?B?R3BVQWZQWE54OXZEZVJHMmZQTENvejZ5cWk2d29pbHIvRnNuQWFaTVhFOHRo?=
 =?utf-8?B?WmRiSEJhUDhYdVhiWUpHZkRWRDNkclVDY0NPZGVYRmtSZ0o2V1Z1OVhPTVdE?=
 =?utf-8?B?eWJ1bll6Nmh3ajJ1TGtQWXdEV3h3TnZWN1IyS3k0THlmekUrbkZGWU5wTFRO?=
 =?utf-8?B?YU9VcXY0MksrMmF6SUY3ZXNSeStJWjdoUFpzbktVTUtsa1VQYTlGeUR0VWhx?=
 =?utf-8?B?Ukt3dllMTVZoZTJoc3lzdG51djNFZjNQSW1MaGdsOWI0NSttbVFuTE5yMW85?=
 =?utf-8?B?aFY1RWtCQ29ZVUFUWlJuQlZHZ3JLTy9mci9zKzBsd3FUK29jaHB2c0lOQ1Iy?=
 =?utf-8?B?ZXBOVGp3RnIyVWJzYklTWUNFT0VVSW9SVGJWaU9WY2RlaytPV3B0ZE8rWEZx?=
 =?utf-8?B?TlBFMkp1ZzB6QWsyQW9BVkwzYnBTb1Q5cGs0Q1IydFl6dGpHQm0zMUcybCtG?=
 =?utf-8?B?a3E1MzBLbU9DcWN3N1c1ZXFhQXVXeUFtS1M0T3RXWDVHMTEwS2VYVjdiK3FP?=
 =?utf-8?B?WnloT1pZQ25xVk1FaE4xeEFCQXJMYUQ4eUtJNVhWUEJycE50YW5pZnZzWlZs?=
 =?utf-8?B?Q0NWbWlwcWRDV2h3VXY3bFFkdUxMYjdVR01PNTBnRjIvWUdWTTYxVjVseVBZ?=
 =?utf-8?B?ZFlKWmtJOVYvc0c3QVFDZlh2RjY1SEdPZWlJZGpjQVlMOHUzYTRja2hsd25v?=
 =?utf-8?B?cG5ER3lqQXhQUjk5VDlKcXJFaWthSDhYL3Fjekg1Z3h3dDE1NXBCaU1lZUtn?=
 =?utf-8?B?ZElJZkx0Z3QzWEkyUE95SEhJU1BIbS9iL3RLYURIREpQRWQzSGUyaWFzbyth?=
 =?utf-8?B?LzZEbHJrSnN0c0V0cXp1VVhzaExCMno1a1VBdnQydU5zZnJBdG40UjZEUTdG?=
 =?utf-8?B?T0ZjV2FRek82NUdhSXBCdHoyVEdSa1paUE4yY2I3NVo5UUwwcCs1WmhsWnZR?=
 =?utf-8?B?cmoxbmdNWXBzY2kwK09xZ1Z6RnF6ZnNPQWNZcnN1MnE4bXdRRjNnU1BIcitE?=
 =?utf-8?B?ZkVvUm5PdUZ5UEZDRjdxdWRkQTI2RGFoOE9STjIzRzFGdmZZbjZYcnJYVC91?=
 =?utf-8?B?aFljQURkWkx2WDY4b0YyakpNN3hKYlRqOVdXZGdLaVNNZDJvNVRJVkk0SDFK?=
 =?utf-8?Q?jA+zN8NoLU5oSlrJ+hVl9us=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA4ECAA1849B27458E487BDD23DE8A70@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f35475-4dea-4a4b-658d-08dd925469d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 19:29:00.6975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KhuIMGYxApSYbyPLnoq7TU0QnVfAIQwxeLyN493BsAe5UY0xHW9rr2ZbprOqqPfHEMhGZZn53U9Dsczc8yKLhLLyoND2c7wt3QrFx3RpYd8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7799
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRnJv
bTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQo+IA0KPiBBZnRlciBhIGd1ZXN0
IHBhZ2UgaXMgcmVtb3ZlZCBmcm9tIHRoZSBTLUVQVCwgS1ZNIGNhbGxzDQo+IHRkaF9waHltZW1f
cGFnZV93YmludmRfaGtpZCgpIHRvIGV4ZWN1dGUgV0JJTlZEIG9uIHRoZSBwYWdlIHVzaW5nIHRo
ZSBURCdzDQo+IGtleUlELg0KPiANCj4gQWRkIGEgaGVscGVyIGZ1bmN0aW9uIHRoYXQgdGFrZXMg
bGV2ZWwgaW5mb3JtYXRpb24gdG8gcGVyZm9ybSBXQklOVkQgb24gYQ0KPiBodWdlIHBhZ2UuDQo+
IA0KPiBbWWFuOiBzcGxpdCBwYXRjaCwgYWRkZWQgYSBoZWxwZXIsIHJlYmFzZWQgdG8gdXNlIHN0
cnVjdCBwYWdlXQ0KPiBTaWduZWQtb2ZmLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVs
LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGlu
dGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29t
Pg0KPiAtLS0NCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4LmMgfCAyNCArKysrKysrKysrKysrKysr
KysrLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4
Ni9rdm0vdm14L3RkeC5jDQo+IGluZGV4IDY5ZjMxNDA5MjhiNS4uMzU1YjIxZmMxNjlmIDEwMDY0
NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS92
bXgvdGR4LmMNCj4gQEAgLTE1ODYsNiArMTU4NiwyMyBAQCBpbnQgdGR4X3NlcHRfc2V0X3ByaXZh
dGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gIAlyZXR1cm4gdGR4X21lbV9w
YWdlX3JlY29yZF9wcmVtYXBfY250KGt2bSwgbGV2ZWwpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMg
aW5saW5lIHU2NCB0ZHhfd2JpbnZkX3BhZ2Uoc3RydWN0IGt2bSAqa3ZtLCB1NjQgaGtpZCwgc3Ry
dWN0IHBhZ2UgKnBhZ2UsIGludCBsZXZlbCkNCj4gK3sNCj4gKwl1bnNpZ25lZCBsb25nIG5yID0g
S1ZNX1BBR0VTX1BFUl9IUEFHRShsZXZlbCk7DQo+ICsJdW5zaWduZWQgbG9uZyBpZHggPSAwOw0K
PiArCXU2NCBlcnI7DQo+ICsNCj4gKwl3aGlsZSAobnItLSkgew0KPiArCQllcnIgPSB0ZGhfcGh5
bWVtX3BhZ2Vfd2JpbnZkX2hraWQoaGtpZCwgbnRoX3BhZ2UocGFnZSwgaWR4KyspKTsNCj4gKw0K
PiArCQlpZiAoS1ZNX0JVR19PTihlcnIsIGt2bSkpIHsNCj4gKwkJCXByX3RkeF9lcnJvcihUREhf
UEhZTUVNX1BBR0VfV0JJTlZELCBlcnIpOw0KPiArCQkJcmV0dXJuIGVycjsNCj4gKwkJfQ0KPiAr
CX0NCj4gKwlyZXR1cm4gZXJyOw0KPiArfQ0KDQpIbW0sIGRpZCB5b3UgY29uc2lkZXIgY2hhbmdp
bmcgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKCk/IEl0J3MgdGhlIHBhdHRlcm4NCm9mIEtW
TSB3cmFwcGluZyB0aGUgU0VBTUNBTEwgaGVscGVycyB0byBkbyBzb21lIG1vcmUgd29yayB0aGF0
IG5lZWRzIHRvIGJlDQp3cmFwcGVkLg0KDQo+ICsNCj4gIHN0YXRpYyBpbnQgdGR4X3NlcHRfZHJv
cF9wcml2YXRlX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ICAJCQkJICAgICAg
ZW51bSBwZ19sZXZlbCBsZXZlbCwgc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ICB7DQo+IEBAIC0xNjI1
LDEyICsxNjQyLDkgQEAgc3RhdGljIGludCB0ZHhfc2VwdF9kcm9wX3ByaXZhdGVfc3B0ZShzdHJ1
Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwNCj4gIAkJcmV0dXJuIC1FSU87DQo+ICAJfQ0KPiAgDQo+
IC0JZXJyID0gdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKCh1MTYpa3ZtX3RkeC0+aGtpZCwg
cGFnZSk7DQo+IC0NCj4gLQlpZiAoS1ZNX0JVR19PTihlcnIsIGt2bSkpIHsNCj4gLQkJcHJfdGR4
X2Vycm9yKFRESF9QSFlNRU1fUEFHRV9XQklOVkQsIGVycik7DQo+ICsJZXJyID0gdGR4X3diaW52
ZF9wYWdlKGt2bSwga3ZtX3RkeC0+aGtpZCwgcGFnZSwgbGV2ZWwpOw0KPiArCWlmIChlcnIpDQo+
ICAJCXJldHVybiAtRUlPOw0KPiAtCX0NCj4gIA0KPiAgCXRkeF9jbGVhcl9wYWdlKHBhZ2UsIGxl
dmVsKTsNCj4gIAl0ZHhfdW5waW4oa3ZtLCBwYWdlKTsNCg0K

