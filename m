Return-Path: <kvm+bounces-49789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23842ADE0A2
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 03:23:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF22A3BACA6
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0673918B495;
	Wed, 18 Jun 2025 01:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScJnuB//"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D59170A11;
	Wed, 18 Jun 2025 01:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750209799; cv=fail; b=Ae2Gtn+QdV/gEsshZVCkH9tqYKjoozqS38xRe599TT0B+Z3ijulJ1Dnbkhy8IEf/1Z6gxs0OwZ22w5O1KPGsLjTgzlSlBLU23MakDcuJ+IkMz1JKp4aVP5otlrTr/FyLfrxbD1qc5wUfWAW1W9s4+eqU17OBydTA1n8PvWGCUNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750209799; c=relaxed/simple;
	bh=AlHVyyFV/dvzCd7WJW/Yf34RWMwaFp2n7Md8r/5gNvk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HpvrFZAyR47tzd8ol6nGZ+5IrpisV95ac7HS6tAWuoSCIi1ZmxSUjIlgTbDUDT6kqanZZIsE1UWbFrUOZ7ieT8oTwXFEEu08swWr1PwivzIjNe6bc9vlUJCoZy+0Q2N8/o3oxbGJrTBRvpkds/NTfrbqkbDfMnHcSVsr/1Lb3Pc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScJnuB//; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750209797; x=1781745797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AlHVyyFV/dvzCd7WJW/Yf34RWMwaFp2n7Md8r/5gNvk=;
  b=ScJnuB//AlFuo2FB/e4PB4Kpb4spnuQyrQofCS4gWQwaP8QIhj8iIUv4
   oN5TfGqyWW8uzg3ulngLVhfD1loXyQbpTMgwpu4nVZY54jIH/1s7LxP5h
   XiOfJ83U/QOuOmM15DA61viLmW4CtMd4CYK5WlC5+8zIwoCFYs27xPYTC
   bLbYg7OFRFHeBJnFcyNO1oOAVGsW1I/bhT1cdqCV7sOn9LCHY+maMjDnJ
   3EHx4iYkDaLOvfs1uQqtT9rgx0Vr125nMRbLyU2KQqANF9ejcJ2er5i5q
   W0Dy6VoeDcNM/iPyxyYDDLN4TRsx+8aIVK7yA9yyENPGMhnAry5piNoYK
   A==;
X-CSE-ConnectionGUID: DVnL738GRnqpL15jr6QVsw==
X-CSE-MsgGUID: cJdWbmQ5S96/+5uyPdS15w==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52279992"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="52279992"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 18:23:17 -0700
X-CSE-ConnectionGUID: PlcKBy5tSlG07l+mERtLgA==
X-CSE-MsgGUID: nfrab901Tpqt5kqZLSx19w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="148901745"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 18:23:16 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 18:23:16 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 18:23:16 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.85) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 18:23:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cPHFvbR4hN5MmV+Ge5rrmZv4Fquuxp+H17K0Hdxj49oC1WIaPyxIRAeaHVIDaWaX5eUfgCG/OPakMJzKWTZLKBpRCKLMkVGM01NQNC5X9V/I8E5gY+6bwExcxFUsDdulOrPid/aEk6EfthtRvMZaLKjlCWcUhCIUbziblBD8Nc51fxQY0U2a0BXEE9cFz3ymklZrQG9woO0iehGVzLV2nZQZ77O+lvE3yaiFvuwhZS2bPYODtwf8EWz8Os4HA8235zw/0B9r0dPwI3njs/3pzjexx5Kq6DSh0Efkj60oFzPSS01yRQ4rtMkt0cbPMt+um1pzps+Pv3Kex9iLeOVikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlHVyyFV/dvzCd7WJW/Yf34RWMwaFp2n7Md8r/5gNvk=;
 b=PeK+9EeFbOVcom+2ZsjJydQYsu1oNLWMdzBmEmFxjB8EiNKmPvbPUG9iL6Gh9abGFFkcrzSpKnyQDv1AnodVq9g3HwC1/FmCDfsMrpRDEKfbZ9FgUz4xIR94i+ToW1617JwO+Q8PYguG4AOD6byxpihWneLotam6VydYkZOiuzgGvOyPZ+fe4y6KsNeDNYt/uXOTuHTy5TesOwO+OMmaTYPH6k1XT7yZTkvJD6NFbRlz4tabXVJqmU1b0EfYFltHX0Yazb7xfjf70FpTH3QBpWJgrJZinQVBxqiRzzI+vU4gEU1/eOtFR51PhMeJTFoFPiu8MsYMUPw2QKBmhEYXXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB7245.namprd11.prod.outlook.com (2603:10b6:208:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Wed, 18 Jun
 2025 01:22:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.018; Wed, 18 Jun 2025
 01:22:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABmsIA
Date: Wed, 18 Jun 2025 01:22:59 +0000
Message-ID: <803d857f730e205f0611ec97da449a9cf98e4ffb.camel@intel.com>
References: <aEtumIYPJSV49_jL@google.com>
	 <d9bf81fc03cb0d92fc0956c6a49ff695d6b2d1ad.camel@intel.com>
	 <aEt0ZxzvXngfplmN@google.com>
	 <4737093ef45856b7c1c36398ee3d417d2a636c0c.camel@intel.com>
	 <aEt/ohRVsdjKuqFp@yzhao56-desk.sh.intel.com>
	 <cbee132077fd59f181d1fc19670b72a51f2d9fa1.camel@intel.com>
	 <aEyj_5WoC-01SPsV@google.com>
	 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
	 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
	 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB7245:EE_
x-ms-office365-filtering-correlation-id: 43229231-5088-4c88-d399-08ddae06a9aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SmdRcW1iOUljWEpSK0Z6cE1GZGI5NzI1U0xmeVd4N2VDM0lPb3BlT0dqeHc1?=
 =?utf-8?B?VThrNm5ORlQydHd6K3FGVHpoWGhJWEJ5THI4SHNsOTVQaWRYWU1TS2hmdjNB?=
 =?utf-8?B?TnJmbkVXeDZjK3EwbUQ0bm1YbnJkT0l0bSt6SmVmN0tzRmIwY1Q2TmNaL2tP?=
 =?utf-8?B?UGRreEt6aW44RWVmeUZHL2ZuaFo0WTZLeWNkc0ZSYW9xRnVRbDFyQXZYbHdB?=
 =?utf-8?B?aEg2bEhxQmFwK0VMSEpTM1hYbUxram9tb1ZlN2FxZDhYNVd6SW1RRWRRRkly?=
 =?utf-8?B?UEdMQUpxZ2hGalJpNGRmUUpnaEt1QlByUFQ5djVTeUM5dzc2a040T2xWckJZ?=
 =?utf-8?B?ZU9zMVpEeFBRa0pjTlIwcXAzYUJSUXV0YWpwSEdrRjFIOWtzS0ZWY2RLa21C?=
 =?utf-8?B?RVRqYnpnaWpRWlRzbjJpcTAzeDU1OUxzdVdZWThOSkNvZTZWTFY4a1dTRzUz?=
 =?utf-8?B?OFdvSDBEM29GNUU5VExIaXgrYjVBZWc4Zys4eW1WdVNtVFBlSUNDeCtTZmp4?=
 =?utf-8?B?MFN6ZTd5azBuV2pFRDlyV0ZSa0xxU1VNamg3bWdnb3pGd3pPcDdFUVBuRDd5?=
 =?utf-8?B?SFN2SytZVTZuS0lkNFB0UmJpTmxYaXNRb0ZvOWhjemViVm93QUlmOFEzWFRW?=
 =?utf-8?B?dmRFbmdJUDZVS1lsNm5ocFAwYk1TQXJRUlFOalBJU25XbGY4U2NjdjlQdFdW?=
 =?utf-8?B?ZVNJQmQ0Myt5T01CQkVXYzVoSlVDeEFQU0pudjQxUjdoZGtGZm9vM0RRUmtU?=
 =?utf-8?B?cE91N1RMeUpIaFBGczhFNmZVZVZCdUlnKzExc1UwOHBYbGJoMkpKWE1LRkR6?=
 =?utf-8?B?ZGw0dnFTLzUrdUJLenQ0dGd3SzJBMmRqM3pSZlZsbUdpOVJLcEtMOWZPVng2?=
 =?utf-8?B?Y1B0UGRESVRLNUpDaEM0MWpQenozNjVET3FML1FDdTBxUHgxOU1POVdDeGg4?=
 =?utf-8?B?NzA0NlVhQm9LV3Q3TDdWa0crQ2pnZU5jWU5RY2ZYckFHM1VMeFIvZFhKOU12?=
 =?utf-8?B?aVhXNjNRbEQ0T0JLb3RMMGlSVis2bHYweTY1c0RkeHI0b1hjVDZBNnlhSTRk?=
 =?utf-8?B?NSt0dFgrRlAwNzV5RzhCRkRZZldPbTZ2V2dTN0tmUlFiczlGbEErUGxrU0M3?=
 =?utf-8?B?RTNuUjVoVEtvNkowRWp2Sm9CMUZiVDhzbXFiWUpZYlZEMnF2QVlLTFR2SFFi?=
 =?utf-8?B?VG1VaW9ianhvbXp3NHJoN2o2TGx1VGRWY2d0dC8ycDUvS3dOR2dKVjhwUlZx?=
 =?utf-8?B?Ulk0ZENLclpYOC8ybldJTXI5VFFwSHZSb2MyV3d0dE94Z3BNSE0xeEIrSG1J?=
 =?utf-8?B?Sm9uM3YxMk1oc2tuLzgvbVdGdlc0REdTd29zR0xrVklYVThieWExUklHYlRZ?=
 =?utf-8?B?WStGSCs3VFo5MUl6bjJmN0t1ZGlLbGRhbXhuUlFsN1IwRUZubEpZWGh2dDlZ?=
 =?utf-8?B?YWhZdVJVMkhGVS9kOXNJMFBWR1M2aEFiVTV2U05qa2pOV2pFdTFrdW1ienJ0?=
 =?utf-8?B?azJiRG1YQ2xLSS9OeHFZbWR1SFVEdlllenRSK2Zzdy96ZjRJNmZqa0FveG1r?=
 =?utf-8?B?WWQ0dFduSlZIVmlqeEErM09LRUpqTWM0VFFNNHVLdVExaEJVa3o3aUtPaFIr?=
 =?utf-8?B?MlJ5aXlDT2g3WjZaQlVhOWpmYVNvblFWS1FKNjM1RW1jdzc4Q2dUcy9yQ1Fs?=
 =?utf-8?B?OHoxT0szdUlkT0lyUmgwRjJoQm1STHJUYm5tN2VzTDg1TjBUaWxJMCtwaDFo?=
 =?utf-8?B?NHRoZmFkZVRvZ1dmTXRwRHJ1Q2wveURsc3dGVWZ5alkxc1JmVzhqcHUrVm8z?=
 =?utf-8?B?RjdIRjdNa1hRRmNybDJHQnNmbGZpNHZkM0haQUZEUnFoSWx6OVMrZFgvcStT?=
 =?utf-8?B?S1ZjVC9zV0dINHZHZGJvZEY2L3ZYL3E0SHplMEgvSUQwTkEyOGpyRjQzVHBI?=
 =?utf-8?B?bWxiU2V6Y25uWDlZR0NPUjNJbEk3UHUxWjNiT2tKM1NxM0RHU25nUE1MVGJB?=
 =?utf-8?Q?/nxNhBRJMvV7likjy4orjpQuKcXjr0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1FZbUV3bkpla083QVdWTFBvV0UzWks1SEIwMU5pbm5DNE5kUVRKVXFIMTJ5?=
 =?utf-8?B?OWJLcUpuWHZtUWtxbnQ4OXdZNFRsa2k4L0MxczE1UmdXOUhJWExMVFQvVzk5?=
 =?utf-8?B?TkNmQk83UjVDeklhcldSWklEaCtSbVBUZHlibUFJZ003eG8va0dMOEw2bGV6?=
 =?utf-8?B?ZVU2UXZETFJ2Mmg4ajEzbDRBUkJjcjh3OUxwQ0ZqTFNpdXpBcDZHcEVjWjNG?=
 =?utf-8?B?S2s1ZjE1d1FtRHdVK2RoekRWLzRTMmJMNFg2eThtaWM4NU42UzEvU2ppcUFj?=
 =?utf-8?B?MUJjQ0RLM0J0Mk5CN0pXR2dYQkFXMUtJY2gwemxORERXZS9SbXQ1dkc2QTVM?=
 =?utf-8?B?VDMzZEkxMnMwdnZqRkRYY09EbERSZ0UxMzZ5ODJvNGZBbnRnMzZwaDFRMXpy?=
 =?utf-8?B?azA0dzJkUkhSdTdQY3JjbTloVDJEWXFUdS9xY0JHYWF3anROMVhBMm1LODha?=
 =?utf-8?B?TzZjVWV5MVRmb0diUnZpRFR2U0YrTGJYcnNia0QyTTJoU21CWkFidlJIWjRa?=
 =?utf-8?B?eUFiY28vQVRZcS9YaTBtc2N2NG9zOEdrR1c1MGgvckRoRmpJYUtrdFRTWnJD?=
 =?utf-8?B?QUh2YnZEcGpWait2dFhDc3YvdUxBK29Mbk5aUHFqenRpU2xPeGtERnQzNU5D?=
 =?utf-8?B?QnJSZVZaQzJyZHIwTUVpUG80Y0RFUUlrcERGa0RENmF1Kzc2QkFYSDJOc0xt?=
 =?utf-8?B?bkIrSURoSGxzR1hhbDBtYXVJMkhSTFVzN1dUK2cwTUo5dE5FQ053WVBzMjVm?=
 =?utf-8?B?VVZpbkhreWdpR1VSQS9MczNoazNGREZ4NE95UkRHTFh3WG9FVjluU09WUU5M?=
 =?utf-8?B?QUpMK2tUeHRHTm5uSld3Y0pFRk1HaTE2N1diZGdMSEtFUWkvYXJBSGZUenM4?=
 =?utf-8?B?bGpGT3lZZWd5K3VaSzNkVE5EVmpxaHZsamcyeHhPVC9WRHA2UkhSdmx2RzRh?=
 =?utf-8?B?UXUxczhqdS80azk0SUxDOGJLa0hQLzVqOWVEWjF6ejMybjF1OUp0NHJqVFlr?=
 =?utf-8?B?aG5ZbkFmd0lzbDhPWmQvOXcvcXo4WERvQ0JxTUdQd1FibVNVSzVqS2hrVmRE?=
 =?utf-8?B?SUVUMDdENXhTYkVSWmkwQWlOZTJwdjBlcTAzOGt0YjMzbWk0VGxNNkMva0Y0?=
 =?utf-8?B?UFkxQXl2K1MyMHp0amU3b1NTVEtOd0tpbkIyZkRzTUdPOUpjdnA1eSthOXVu?=
 =?utf-8?B?ZzVOT2RrUmtyS0hHUG5ub1k3V0FLZ0JXUGMySzBWWmRxdnc3SDFGN3RVd1hj?=
 =?utf-8?B?U05mUkZQSkYySnFqbXArNXcvV2xUS0hOS0U3cHdUbjRNbCt6cU1sNDk0T0ZE?=
 =?utf-8?B?aDZpTXY3MDI3Z2ZWYUdmR0FFbVliUzNQdWpVd1pwU0J3L25tTktpdVZZL25l?=
 =?utf-8?B?a2wrV1N2dXh2ellMVGx3dEFxRGxzSjA4N1p2K2sxeVpNRzRQOVBOTVBmV1hG?=
 =?utf-8?B?YWxBWU9XV1ZBbk1JczJDMzBvb2diUjVicElQT05CVWZXWE1YblE5TE05a2hl?=
 =?utf-8?B?NjlMS1BmMlNuSWVZZFhQKzk1cFR3d01GdVd1N0dzUUtUVzd4MnlJbUdvNktF?=
 =?utf-8?B?ZVp6MjRLWFZtdzI0ZE80TXZISGJpMFJjeWlWK1RsRGRWT1YzeWRFdm5TU2xh?=
 =?utf-8?B?aU5QYWl6WDYwSkJHaCtqeDdHSEZvbFF5L0RKdW9NVjRqbFJNODFIYUI4dlk5?=
 =?utf-8?B?R2xkUkM3c1Nmbk5iTVZmZ3BzQ3VTeUJLdWw5WUVCT3g0TmFOZEVBTVJ0VXpC?=
 =?utf-8?B?SlNub2l5VkZYNUdRSU5DSlVUZFMzTUtnWU5Hb2lNeER5VkNSOE5XN0hBTkNF?=
 =?utf-8?B?VHpDblBoMm1zQXRXY2RxQU8rQVBrYkxKdzRUVlNnYjl0aEpkKzlUWkE5Wkln?=
 =?utf-8?B?RytCeDVWYTJEZmVXZFExdWhZMExsT0ZwdVVyWnRBQ0VaR3NjQzRxVlNkODdp?=
 =?utf-8?B?T0diRnNyam85b0U0TjlpS0plQXVjVHZHYnM2ZlhkNHJSNXBrMHUreTNQMkpZ?=
 =?utf-8?B?TmkrSEZvNVgvRmJpL29GZ0p0WWxFOENoK3d5Qk42NVh1MFo0YkkwOGV3Nmpy?=
 =?utf-8?B?eGdmRlZwaTJ4amNqNC90cElXV2ozWE90R1J5cG05RElyWmN3THhGYkV6OHBO?=
 =?utf-8?B?dFA3QnN1OXlKNGZOSmtlb2RVZ2grSVBiQU0vVlVWUWVwOHFzRUNUZ0Rtc1Vs?=
 =?utf-8?B?Q0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <343C14E39450F148BDCE2EF11D4CC871@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43229231-5088-4c88-d399-08ddae06a9aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 01:22:59.5969
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFwynba3U1QUDaCf54RdnzG7jLk1CGso9z5oqF+/Y+dllOfyd72COAGPTTxfKc5wz/2P1SPwDxIpGVjaBpoZi60el//53WOEsreW7PqRvao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7245
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTE3IGF0IDA4OjUyICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBo
b3BlZnVsbHkgaXMganVzdCBoYW5kbGluZyBhY2NlcHRpbmcgYSB3aG9sZSByYW5nZSB0aGF0IGlz
IG5vdCAyTUIgYWxpZ25lZC4NCj4gPiBCdXQNCj4gPiBJIHRoaW5rIHdlIG5lZWQgdG8gdmVyaWZ5
IHRoaXMgbW9yZS4NCj4gT2suDQoNCkluIExpbnV4IGd1ZXN0IGlmIGEgbWVtb3J5IHJlZ2lvbiBp
cyBub3QgMk1CIGFsaWduZWQgdGhlIGd1ZXN0IHdpbGwgYWNjZXB0IHRoZQ0KZW5kcyBhdCA0ayBz
aXplLiBJZiBhIG1lbW9yeSByZWdpb24gaXMgaWRlbnRpY2FsIHRvIGEgbWVtc2xvdCByYW5nZSB0
aGlzIHdpbGwgYmUNCmZpbmUuIEtWTSB3aWxsIG1hcCB0aGUgZW5kcyBhdCA0ayBiZWNhdXNlIGl0
IHdvbid0IGxldCBodWdlIHBhZ2VzIHNwYW4gYQ0KbWVtc2xvdC4gQnV0IGlmIHNldmVyYWwgbWVt
b3J5IHJlZ2lvbnMgYXJlIG5vdCAyTUIgYWxpZ25lZCBhbmQgYXJlIGNvdmVyZWQgYnkNCm9uZSBs
YXJnZSBtZW1zbG90LCB0aGUgYWNjZXB0IHdpbGwgZmFpbCBvbiB0aGUgNGsgZW5kcyB1bmRlciB0
aGlzIHByb3Bvc2FsLiBJDQpkb24ndCBrbm93IGlmIHRoaXMgaXMgYSBjb21tb24gY29uZmlndXJh
dGlvbiwgYnV0IHRvIGNvdmVyIGl0IGluIHRoZSBURFggZ3Vlc3QNCm1heSBub3QgYmUgdHJpdmlh
bC4NCg0KU28gSSB0aGluayB0aGlzIHdpbGwgb25seSB3b3JrIGlmIGd1ZXN0cyBjYW4gcmVhc29u
YWJseSAibWVyZ2UiIGFsbCBvZiB0aGUNCmFkamFjZW50IGFjY2VwdHMuIE9yIG9mIHdlIGRlY2xh
cmUgYSBidW5jaCBvZiBtZW1vcnkvbWVtc2xvdCBsYXlvdXRzIGlsbGVnYWwuDQoNCktpcmlsbCwg
aG93IGRpZmZpY3VsdCB3b3VsZCBpdCBiZSBmb3IgVERYIExpbnV4IGd1ZXN0IHRvIG1lcmdlIGFs
bCAyTUIgYWRqYWNlbnQNCmFjY2VwdHM/DQo=

