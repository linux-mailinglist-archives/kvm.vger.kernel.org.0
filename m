Return-Path: <kvm+bounces-35739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 737CCA14C88
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 10:54:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97C9C18846F6
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 09:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E10D1FBC96;
	Fri, 17 Jan 2025 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S0UbUuAd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3FF1F5616;
	Fri, 17 Jan 2025 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737107635; cv=fail; b=u9fiMPdMfb51bv2BWhs4kuOhzbO4s6dfWpDF4+GJ+ESBzuu+NGAlVauWc4tf7QlKlmOpqBVXbd+7F59mmZdK0YxjJn5y7U887Anpzyh+isN70mNB6mN+hrEwzo8MGEQIlllbMMEI206HnC75qG6VS6Lk/DwJ+dZ1HEv99/O7WeA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737107635; c=relaxed/simple;
	bh=RefN6Zs8M5xwzVdhE2BxmI+nKM/aLI22ewiLpyiAg0o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Izjua9nJFeJ/Tf6aNZeu0e1YREzTvfi0YCqQzJsy5wuJ0At49wpo+lBdxv0zq68b+MDpvTooeEQu4g2hYWShxVPS/E4Nfjj4oEkukbPf/8q7GFrJTWoE0G/JFw5gmPeDPGuNsX+sJMV0+njrFPPMoYQvcuhjUosjHltwoX2iaOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S0UbUuAd; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737107635; x=1768643635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RefN6Zs8M5xwzVdhE2BxmI+nKM/aLI22ewiLpyiAg0o=;
  b=S0UbUuAd8b7NNjw2DU84q8ls80OfZEzaPxHqQHtAtV/QBNaaXN1jmSH+
   bfyRf6bvFdWtbDlWfJ0Kz5DUUptF2TOfw/3hImu97IxmdkvhazJ8EVRr7
   1Z2RGINC+7VALxn1HytYsGj1m0fZcR1Az8RntbBnYKMC7WeLDtzj7FQzI
   ooTxT7H4IuL82XvMpbB6DokDi0dkj00/Bda2ksd7rwIGymwJgB9Kr1BnL
   oxaEDAbFt8ASDjHn5LjX60ZOw5F4ZX5A8kPGZ0ezPn0B1hoibE8qUC47n
   jZX7DibB2XI7I3yIRwRgu9+ZVj8KFXk4/Jghh3WE9b6kiIEzt8A8NFzNg
   A==;
X-CSE-ConnectionGUID: HF2uc6p5SM2Wsvihl9QP0w==
X-CSE-MsgGUID: 8x+BZ3ymRl6X6IoOlxxcOg==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="54946030"
X-IronPort-AV: E=Sophos;i="6.13,211,1732608000"; 
   d="scan'208";a="54946030"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2025 01:53:54 -0800
X-CSE-ConnectionGUID: mCRh0dTxRVOqTZ46l2wDGA==
X-CSE-MsgGUID: f3h9mxmvSpuJg/e+ZtlqXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="143046173"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2025 01:53:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 17 Jan 2025 01:53:52 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 17 Jan 2025 01:53:52 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 17 Jan 2025 01:53:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fr57FNv1LTqn7H6d9e57thyqf26tTMoqA23Ed0pgNhPEBmTGT8YI630AdBBp8aH2fM9TDO5w9IGzWQoBAce8svSKhbEnTng5pAlQ7O5v7uqksiUk9pdfR6q3oBB1iltA9tHU8s4adTGeh3jS4ZG3+3umTdhric0tGzPhkj5S5b4zWtGLGW0uRzt3/joUvBMhKAHg7stilbKZhEmjQy5GZM5Poy7ovtSW9xO/cldI7+tTMdAOmTJkTkMFlnEUKOuJhluHqgJv2fh6nnFVB/iECdREVeE8YaWavzPbh+c2RIF5t5PR4x+MDuCshIFJXyPymHLZx0spCQc7Jw/oTRg4lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RefN6Zs8M5xwzVdhE2BxmI+nKM/aLI22ewiLpyiAg0o=;
 b=jqkajHJH9UOf0GDqTpBW4MHe9x40mfa01IGAp0YTMAYVmQZbbVNoFd4bv29pOWBbfulBGUX1L5I2DPtcF3rDbEN8oMzVa20R84cAUuYQi1ahjoPzCpjmLOSG4pmjDSIhqM0oCXRl33YbQWXMMcAjpZD6BMBJa7xWbGOSunUXdyeL+LM2ATAS/WL7V/jdFPgQhUyhC14IiwRIYMDhsbU6JKE4Cn5HN9AQJTr6K4xapCAGumnzZ2OjXGhAoPw/YH6p0UvX6JPLAzfchOFUQYgBt3aXLJGyf+Tb7MS5Daz0tELSSIkr65czx0hLAPKzRNohyoriYxkpJpMYKYavOrRMFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN6PR11MB8147.namprd11.prod.outlook.com (2603:10b6:208:46f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.16; Fri, 17 Jan
 2025 09:53:34 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8356.010; Fri, 17 Jan 2025
 09:53:34 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Topic: [PATCH 12/16] KVM: TDX: Inhibit APICv for TDX guest
Thread-Index: AQHbSdaRKaJIAc3W+kqkHDGtm3kSR7MUKuIAgAABzACABVqtAIAAMPKAgABbB4CAACdcgIAAvPMA
Date: Fri, 17 Jan 2025 09:53:34 +0000
Message-ID: <80c971e62dc44932b626fd6d22195ba62ceb6db7.camel@intel.com>
References: <20241209010734.3543481-1-binbin.wu@linux.intel.com>
	 <20241209010734.3543481-13-binbin.wu@linux.intel.com>
	 <8a9b761b-3ffc-4e67-8254-cf4150a997ae@linux.intel.com>
	 <e3a2e8fa-b496-4010-9a8c-bfeb131bc43b@linux.intel.com>
	 <61e66ef579a86deb453bb25febd30f5aec7472fc.camel@intel.com>
	 <Z4kcjygm19Qv1dNN@google.com>
	 <19901a08ab931a0200f7c079f36e4b27ed2e1616.camel@intel.com>
	 <Z4mGNUPy53WfVEZU@google.com>
In-Reply-To: <Z4mGNUPy53WfVEZU@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN6PR11MB8147:EE_
x-ms-office365-filtering-correlation-id: 60d5c33d-1263-424e-e7c9-08dd36dcce8e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QzBlczZjOXRzc1pqQ1pROUh3U1IwVExzdlF0WFBEYWpHMUZjOTZBMENWVEtK?=
 =?utf-8?B?NWUvdmcxQXpNdFJwU0dPMGowZDRVV2tJUU5KUHo2U2FXeFVtaFRyMHJpTjBR?=
 =?utf-8?B?azhNN2ZPYzM1eVhQNVI5UnVFdDFCUEpHU0NKNkY1Q2NOU2JxSFlSaVRWbUNV?=
 =?utf-8?B?NGFUc00rRGF2M21KTUR2SW9YWmNUalRTR1Jta0sveWFtNGM5dUx1amovVVht?=
 =?utf-8?B?d2lOSWhLdmVVbFVVZEhwOTZpeVg1bGQwUTZsNFVuZEo4K1VZamlyTVBjRnVl?=
 =?utf-8?B?RzhQOWswUHlOR1ZiMmNkYStOQldEWHkzSXRmL3cxdG96QnF5TWoxNXNjenZk?=
 =?utf-8?B?amRmSE9obXFaVmtUNDFvTjhuUTREUVZXS0RLRklaTFdUMnc2TWEyNzc2czFm?=
 =?utf-8?B?L2M3aFMveldPMTh1WlFUbEdjREhoNzlNWExvekVCNmlBRVh2bmhNbmtlTjBw?=
 =?utf-8?B?NDFLd290QkFta1paUGdmcFptSGNLVXRmdU1Fci96M29UZkoxNlQ1RFVNNTln?=
 =?utf-8?B?Slc4aVRPMm4wd3FyL1BpbjRkc1NZaU96MStHelhiM1dmaEhCV2lwQkJVd0tS?=
 =?utf-8?B?WlJyeHl0L0FBbkRlYjFJeGNDSVBiY1Nac1dTc2tBOHA1SmFJN0tCaSt0NDBl?=
 =?utf-8?B?bEE2bkRUWFRRWG5NRXpGS0UzOUNNU05tczV2Vlh5RUxaODJPenpWUFA0cUdw?=
 =?utf-8?B?UjFxeGlIbkszUi9wc1AzM0ZuQjRLQUdudlRScVJkRlZqNS8xN3JPSVJhbjNX?=
 =?utf-8?B?YXQzTU4xT2lmMnlmUU9POUsyZGZtdzYyQ0Z5QzhqQm1LSTB5akFZYXpHc1dk?=
 =?utf-8?B?UlNQSy9FcVpvZ2JmejNTT3hFQTM4L095cjZDbXFxRSs3djVsNVdOTlo0WlJE?=
 =?utf-8?B?eDk1V0xWUGlZQ2p6Q2RZUytvRnh2YXhIOUl0dHkyeGpXYVlTV3pWODNNZGxD?=
 =?utf-8?B?YVRDakpkYWhXb1JpMUFHNEtMMWFvWDZoSkpjWmRUSllsQW04a3psS2daTTU5?=
 =?utf-8?B?NVM3SFYxbktJZDA1MDF5azU1NjVzWm5UWkVudy9hOUNqWk1zZC90UWJYY0NZ?=
 =?utf-8?B?R2lnb0hJVkRKK3RhYkwxbTQ0NXpGV2FQVzUyVHJOUnVZRXhXRnA1UG9NdVg3?=
 =?utf-8?B?UFdZazhJQ2d6NXVTY21ZZmZobWJaL1MrbHVZWVBsbGZtTHFvMkNCNHZZekhp?=
 =?utf-8?B?SnhXUXV2bHRsZ2FTdWxKbkJjbU93WlN4cUIycmZ5eWZWcm4zMk8vbnBtd0VN?=
 =?utf-8?B?QmFwWDE4eVRnRGJENDhZcGVnREZyUXducDc0ZzFlaDM1SldKODlnaEh0YW1j?=
 =?utf-8?B?QWFiakVsQ0p2RGwyaHAzbE1qOFR1NGpCSnFqUjAzTTl4TzE3UGxSRTk2UzBP?=
 =?utf-8?B?eG5ZR2VNSjNKZWFDaVJUZzEyQitSanJNUVVXUnNwZlpDRk5OdEhaZnE1czRz?=
 =?utf-8?B?ekk4b09UODJEVmREcGdJMGd4cm00S3ZXVVc4WjR2VXI0S1JEaDdOeVhnMlkw?=
 =?utf-8?B?akkxamZUZjUwVm5SVXh3RHp1YklkUmFVbXpNOWlKMzhidVFCdU1kamhiL3V5?=
 =?utf-8?B?Qk1aNTliVUZUZTFDWUxIUGVZcG5YQ1UxN1BuSmw3STNRNCsvM2QwOW1rWUVI?=
 =?utf-8?B?bm9vWXdpMnBIMXlQZWlSSitoUmUwdEg3YlJ5RE85LzBtN3c4M3Y3a3lvL2Zy?=
 =?utf-8?B?OS9WS1o4cnl6M25wekJOYW5ydjVucEpZSVB4My95OUFEOGE5NXBXUkZFZXBm?=
 =?utf-8?B?U0VKbjRvb3V4QmJXNG8yaUFORWFvc1hEWitqN0Fwci8wbmVrbG43eUtHMlh2?=
 =?utf-8?B?Q3NYazc5eHJZYTR5d29acE1BQXRoSWJQNHNVRGQvRGdkamoyVk1tdDBsdmpB?=
 =?utf-8?B?OHZ0QThSaEgzSWs3cmlVSVh0cDMwb3E2WERJTFNEWVgwOXAwSVVEWXUzdnlG?=
 =?utf-8?Q?f5469tUdAgCuwnDi8mlGZcFbNovS57y7?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0xkVWx3Z1RTRFN1VkUrYUl5VmZsWkI1MmxQalNBVGMwV0h0czhPMjZGSy9h?=
 =?utf-8?B?Nk85eHZRRzNzeUtvbUtNYkphbnVCWUJGT0sxa0hKckpNZ1NBTlB4bEE1ZVY0?=
 =?utf-8?B?ODJFZWd0clcyTVlaR29KUWlSMlV1RGZYa3l3Z2h3REYzbzR6bkdMZmh3YllO?=
 =?utf-8?B?aTZ2LzFQQm0xZlJZbzRCU2pRcFA5aFByYllCVnV2SGl2cGZHZEo5TkM5b0VK?=
 =?utf-8?B?MU03dEYyR3B6Z3BsUVpkREMyUFozZXRiWVFBcnExSzB5VHhxR2ZyVUdOWkV5?=
 =?utf-8?B?TituUU9jZzkrYWcxUzVHTlpBVU9ObmNmZnYybmc0N0ord2tIK2FibkJGMFgz?=
 =?utf-8?B?aS9oVUg5K2dRanR3R2RoUTB1Mkg3WDVqMkV5WU5iOXhmblZkcGltTE1KQWY1?=
 =?utf-8?B?eWw5YWo0SWtrTHlNL1ZGVnNLcmhhM2l0VnQwWG1XbzFsaS95UlM5eGNFZm5p?=
 =?utf-8?B?Q0NYWEZUbHltR051U1RYRTdEc1lvbk4vSnRaYWN6clE1SkpGY1VMNkVhRHll?=
 =?utf-8?B?d0h0Y3ZxTEw0RjdVazhkV01DSlh6MzMrcGs2VVU3czhNcEhJMEt2WkFIaTE0?=
 =?utf-8?B?b1FEK1pESWVUbEdDcGRoR1Y3bDRBdU1FRlNLMkI4SG9jaDN6MVJ0eFZtVUJ4?=
 =?utf-8?B?RHVMVW1DcmEvNi9vRThLSW13TFdMSTRyTStickJKY0JvV2NETWEwRkxDazQx?=
 =?utf-8?B?U0VaUVdWUFVmU1FHVFJvaHRhMmc2WWxjeXNiNy9xTVdDcGdZRHVEV3hBcFVT?=
 =?utf-8?B?ZEdQV0lMT3kzVU9YOFcxT2RkWE1zSHRUdjZNOW1ndkJma2VNRW5Pa01wOXhU?=
 =?utf-8?B?TitLZTRsWWRkYXo2L1BNM2dHTElWQjdHQ0xXemtXelJMaFZveUlSeEprL09M?=
 =?utf-8?B?ZU9CR0JLb0NveGJVdmRPaTRQektRU2hjMDRkVlhQU0pydXplMDhubnhlM3l4?=
 =?utf-8?B?UlpKYjF1Unk0eEtFYmx3Q1ZRSmxrYUx6T1hWcjBIbFRyZjVOTXhPU0diL0Yw?=
 =?utf-8?B?cldsdmR5ZXZDcGFtbjcrT0tSbzRMNGtweDQ5SWdLZXJvcHorbHZIekl2bzdR?=
 =?utf-8?B?dG95Y0xRejNKZzI2OVZmN2JuNnpUaHFsRjhmNUwvTUtVMHpxOXQwUG05ZWYw?=
 =?utf-8?B?bGVtNjBudTF2ckJYb2VaemNEL1VKenZqekhkMGtKWjcwbDhtRnpleGl2bEFE?=
 =?utf-8?B?VWdYMnFjM0pDekhpelNQSEVGbjYzRURpdkxhM3ZWcmhpMWFCcEVDdzlnbkRG?=
 =?utf-8?B?UmdOZ1hLUDhwdUt0VGhiTHozbkZ4OGx2WVNIMFBGbUNnZkxoQUUydFhVWkRn?=
 =?utf-8?B?VHdadUVlMjVmbWZUQThBQjc1MnJ6OW9uTlo2dFBaOXdUb3lFNXM0bk9WWjJI?=
 =?utf-8?B?Q2dOb285bmcwNGF0dHpPK1dzaktIalpCQm1WNEFVVmt3a1Q4VmtNeTNWT0c4?=
 =?utf-8?B?WUNMbDNvYWt4b1BzTnRIeUxzdTJxVE12Skx0eElzbG03Z0daZ2N5NDI5cVdy?=
 =?utf-8?B?OFNpRlRpNXc0ZjcydGdYS0I0TWZIMlBNNFYxV01aTlhwNHAwTEJZeFI4dWRC?=
 =?utf-8?B?a0VvZ05ISFhTSkJySnFYamlZTm1yZmh0dFJSdmtIMXVqQWtzNm5CaUlEN0Nj?=
 =?utf-8?B?am04MVltOTFoTHRUbFozRDc5eXdYaHBrMklRL1VYUnE5K1EzNUpRbUo5Wk51?=
 =?utf-8?B?b3ByU3M0RTVoLzlxdk1waHo3eDZUWnlCRW92a1dIUHNyS3N3ekdKWFl4OG1M?=
 =?utf-8?B?NjlzeU1TazFqWkNrd1pPWVlaVmFCTEtkcXBwRWRRWGRPZTZQWXNFTVFERWdv?=
 =?utf-8?B?ZXY2aXNIdGltYkhKMGs1Q1NTUjIyTkNkVWYyNjhaYklRMjh6Zmx6b2VjQzZt?=
 =?utf-8?B?SEhpNGVSK0w2cE94bG5VZGdiZ3pNTExCTW9OZjB4T2NQQ1NxMkpGRlI0Ylky?=
 =?utf-8?B?SVUvY0RrQjlPbFVtdHZab295TURNSkNlUVNjN3hyVWg0b2NhSzk3YkEzWXpa?=
 =?utf-8?B?c0dUT0ZiK1VRbnBsR0FtWVdIeVdwNUZIUGtONSsvMmhLYTRNTDY3UFJWczVH?=
 =?utf-8?B?c1AvOXo5RGg1NlhqV250N2dNTXF6bUVVVjRiVmJySFhJN3FZTDBOSmVxSUpE?=
 =?utf-8?Q?djXTJSdQRnj0ktVJo0YGBUj//?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <894F989014CA344F8DF86419B73EF9BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60d5c33d-1263-424e-e7c9-08dd36dcce8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2025 09:53:34.2429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: heGqgA680FgXfvTY8lvyy71frR3g7sbqziGK+NqQPhz+IIXwccTvqt1kOD90Bx9IwoY8RUU442oQrWG1vVJLAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8147
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTAxLTE2IGF0IDE0OjM3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIEphbiAxNiwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFRo
dSwgMjAyNS0wMS0xNiBhdCAwNjo1MCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFRodSwgSmFuIDE2LCAyMDI1LCBLYWkgSHVhbmcgd3JvdGU6DQo+IA0KPiAuLi4N
Cj4gDQo+ID4gPiA+IExvb2tpbmcgYXQgdGhlIGNvZGUsIGl0IHNlZW1zIEtWTSBvbmx5IHRyYXBz
IEVPSSBmb3IgbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVwdA0KPiA+ID4gPiBmb3IgaW4ta2VybmVs
IElPQVBJQyBjaGlwLCBidXQgSUlVQyBJT0FQSUMgaW4gdXNlcnNwYWNlIGFsc28gbmVlZHMgdG8g
YmUgdG9sZA0KPiA+ID4gPiB1cG9uIEVPSSBmb3IgbGV2ZWwtdHJpZ2dlcmVkIGludGVycnVwdC4g
IEkgZG9uJ3Qga25vdyBob3cgZG9lcyBLVk0gd29ya3Mgd2l0aA0KPiA+ID4gPiB1c2Vyc3BhY2Ug
SU9BUElDIHcvbyB0cmFwcGluZyBFT0kgZm9yIGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHQsIGJ1
dCAiZm9yY2UNCj4gPiA+ID4gaXJxY2hpcCBzcGxpdCBmb3IgVERYIGd1ZXN0IiBzZWVtcyBub3Qg
cmlnaHQuDQo+ID4gPiANCj4gPiA+IEZvcmNpbmcgYSAic3BsaXQiIElSUSBjaGlwIGlzIGNvcnJl
Y3QsIGluIHRoZSBzZW5zZSB0aGF0IFREWCBkb2Vzbid0IHN1cHBvcnQgYW4NCj4gPiA+IEkvTyBB
UElDIGFuZCB0aGUgInNwbGl0IiBtb2RlbCBpcyB0aGUgd2F5IHRvIGNvbmNvY3Qgc3VjaCBhIHNl
dHVwLiAgV2l0aCBhICJmdWxsIg0KPiA+ID4gSVJRIGNoaXAsIEtWTSBpcyByZXNwb25zaWJsZSBm
b3IgZW11bGF0aW5nIHRoZSBJL08gQVBJQywgd2hpY2ggaXMgbW9yZSBvciBsZXNzDQo+ID4gPiBu
b25zZW5zaWNhbCBvbiBURFggYmVjYXVzZSBpdCdzIGZ1bGx5IHZpcnR1YWwgd29ybGQsIGkuZS4g
dGhlcmUncyBubyByZWFzb24gdG8NCj4gPiA+IGVtdWxhdGUgbGVnYWN5IGRldmljZXMgdGhhdCBv
bmx5IGtub3cgaG93IHRvIHRhbGsgdG8gdGhlIEkvTyBBUElDIChvciBQSUMsIGV0Yy4pLg0KPiA+
ID4gRGlzYWxsb3dpbmcgYW4gaW4ta2VybmVsIEkvTyBBUElDIGlzIGlkZWFsIGZyb20gS1ZNJ3Mg
cGVyc3BlY3RpdmUsIGJlY2F1c2UNCj4gPiA+IGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHRzIGFu
ZCB0aHVzIHRoZSBJL08gQVBJQyBhcyBhIHdob2xlIGNhbid0IGJlIGZhaXRoZnVsbHkNCj4gPiA+
IGVtdWxhdGVkIChzZWUgYmVsb3cpLg0KPiA+IA0KPiA+IERpc2FibGluZyBpbi1rZXJuZWwgSU9B
UElDL1BJQyBmb3IgVERYIGd1ZXN0cyBpcyBmaW5lIHRvIG1lLCBidXQgSSB0aGluayB0aGF0LA0K
PiA+ICJjb25jZXB0dWFsbHkiLCBoYXZpbmcgSU9BUElDL1BJQyBpbiB1c2Vyc3BhY2UgZG9lc24n
dCBtZWFuIGRpc2FibGluZyBJT0FQSUMsDQo+ID4gYmVjYXVzZSB0aGVvcmV0aWNhbGx5IHVzcmVz
cGFjZSBJT0FQSUMgc3RpbGwgbmVlZHMgdG8gYmUgdG9sZCBhYm91dCB0aGUgRU9JIGZvcg0KPiA+
IGVtdWxhdGlvbi4gIEkganVzdCBoYXZlbid0IGZpZ3VyZWQgb3V0IGhvdyBkb2VzIHVzZXJwc2Fj
ZSBJT0FQSUMgd29yayB3aXRoIEtWTQ0KPiA+IGluIGNhc2Ugb2YgInNwbGl0IElSUUNISVAiIHcv
byB0cmFwcGluZyBFT0kgZm9yIGxldmVsLXRyaWdnZXJlZCBpbnRlcnJ1cHQuIDotKQ0KPiANCj4g
VXNlcnNwYWNlIEkvTyBBUElDIF9kb2VzXyBpbnRlcmNlcHQgRU9JLiAgS1ZNIHNjYW5zIHRoZSBH
U0kgcm91dGVzIHByb3ZpZGVkIGJ5DQo+IHVzZXJzcGFjZSBhbmQgaW50ZXJjZXB0cyB0aG9zZSB0
aGF0IGFyZSBjb25maWd1cmVkIHRvIGJlIGRlbGl2ZXJlZCBhcyBsZXZlbC0NCj4gdHJpZ2dlcmVk
IGludGVycnVwdHMuIMKgDQo+IA0KDQpZZWFoIHNlZSBpdCBub3cgKEkgYmVsaWV2ZSB5b3UgbWVh
biBrdm1fc2Nhbl9pb2FwaWNfcm91dGVzKCkpLiAgVGhhbmtzIQ0KDQo+IFdoZXJlYXMgd2l0aCBh
biBpbi1rZXJuZWwgSS9PIEFQSUMsIEtWTSBzY2FucyB0aGUgR1NJDQo+IHJvdXRlcyAqYW5kKiB0
aGUgSS9PIEFQSUMgUmVkaXJlY3Rpb24gVGFibGUgKGZvciBpbnRlcnJ1cHRzIHRoYXQgYXJlIHJv
dXRlZA0KPiB0aHJvdWdoIHRoZSBJL08gQVBJQykuDQoNClJpZ2h0Lg0KDQpCdXQgbmVpdGhlciBv
ZiB0aGVtIHdvcmsgd2l0aCBURFggYmVjYXVzZSBURFggZG9lc24ndCBzdXBwb3J0IEVPSSBleGl0
Lg0KDQpTbyBmcm9tIHRoZSBzZW5zZSB0aGF0IHdlIGRvbid0IHdhbnQgS1ZNIHRvIHN1cHBvcnQg
aW4ta2VybmVsIElPQVBJQyBmb3IgVERYLCBJDQphZ3JlZSB3ZSBjYW4gZm9yY2UgdG8gdXNlIElS
UUNISVAgc3BsaXQuICBCdXQgbXkgcG9pbnQgaXMgdGhpcyBkb2Vzbid0IHNlZW0gdG8NCmJlIGFi
bGUgdG8gcmVzb2x2ZSB0aGUgcHJvYmxlbS4gOi0pDQoNCkJ0dywgSUlVQywgaW4gY2FzZSBvZiBJ
UlFDSElQIHNwbGl0LCBLVk0gdXNlcyBLVk1fSVJRX1JPVVRJTkdfTVNJIGZvciByb3V0ZXMgb2YN
CkdTSXMuICBCdXQgaXQgc2VlbXMgS1ZNIG9ubHkgYWxsb3dzIGxldmVsLXRyaWdnZXJlZCBNU0kg
dG8gYmUgc2lnbmFsZWQgKHdoaWNoIGlzDQphIHN1cnByaXNpbmcpOg0KDQppbnQga3ZtX3NldF9t
c2koc3RydWN0IGt2bV9rZXJuZWxfaXJxX3JvdXRpbmdfZW50cnkgKmUsDQogICAgICAgICAgICAg
ICAgc3RydWN0IGt2bSAqa3ZtLCBpbnQgaXJxX3NvdXJjZV9pZCwgaW50IGxldmVsLCBib29sIGxp
bmVfc3RhdHVzKQ0Kew0KICAgICAgICBzdHJ1Y3Qga3ZtX2xhcGljX2lycSBpcnE7DQoNCiAgICAg
ICAgaWYgKGt2bV9tc2lfcm91dGVfaW52YWxpZChrdm0sIGUpKQ0KICAgICAgICAgICAgICAgIHJl
dHVybiAtRUlOVkFMOw0KDQogICAgICAgIGlmICghbGV2ZWwpDQogICAgICAgICAgICAgICAgcmV0
dXJuIC0xOw0KDQogICAgICAgIGt2bV9zZXRfbXNpX2lycShrdm0sIGUsICZpcnEpOw0KDQogICAg
ICAgIHJldHVybiBrdm1faXJxX2RlbGl2ZXJ5X3RvX2FwaWMoa3ZtLCBOVUxMLCAmaXJxLCBOVUxM
KTsNCn0NCg0KPiANCj4gPiBJZiB0aGUgcG9pbnQgaXMgdG8gZGlzYWJsZSBpbi1rZXJuZWwgSU9B
UElDL1BJQyBmb3IgVERYIGd1ZXN0cywgdGhlbiBJIHRoaW5rDQo+ID4gYm90aCBLVk1fSVJRQ0hJ
UF9OT05FIGFuZCBLVk1fSVJRQ0hJUF9TUExJVCBzaG91bGQgYmUgYWxsb3dlZCBmb3IgVERYLCBi
dXQgbm90DQo+ID4ganVzdCBLVk1fSVJRQ0hJUF9TUExJVD8NCj4gDQo+IE5vLCBiZWNhdXNlIEFQ
SUN2IGlzIG1hbmRhdG9yeSBmb3IgVERYLCB3aGljaCBydWxlcyBvdXQgS1ZNX0lSUUNISVBfTk9O
RS4NCg0KWWVhaCBJIG1pc3NlZCB0aGlzIG9idmlvdXMgdGhpbmcuDQoNCj4gDQo+ID4gDQo+ID4g
PiANCj4gPiA+ID4gSSB0aGluayB0aGUgcHJvYmxlbSBpcyBsZXZlbC10cmlnZ2VyZWQgaW50ZXJy
dXB0LA0KPiA+ID4gDQo+ID4gPiBZZXMsIGJlY2F1c2UgdGhlIFREWCBNb2R1bGUgZG9lc24ndCBh
bGxvdyB0aGUgaHlwZXJ2aXNvciB0byBtb2RpZnkgdGhlIEVPSS1iaXRtYXAsDQo+ID4gPiBpLmUu
IGFsbCBFT0lzIGFyZSBhY2NlbGVyYXRlZCBhbmQgbmV2ZXIgdHJpZ2dlciBleGl0cy4NCj4gPiA+
IA0KPiA+ID4gPiBzbyBJIHRoaW5rIGFub3RoZXIgb3B0aW9uIGlzIHRvIHJlamVjdCBsZXZlbC10
cmlnZ2VyZWQgaW50ZXJydXB0IGZvciBURFggZ3Vlc3QuDQo+ID4gPiANCj4gPiA+IFRoaXMgaXMg
YSAiZG9uJ3QgZG8gdGhhdCwgaXQgd2lsbCBodXJ0IiBzaXR1YXRpb24uICBXaXRoIGEgc2FuZSBW
TU0sIHRoZSBsZXZlbC1uZXNzDQo+ID4gPiBvZiBHU0lzIGlzIGNvbnRyb2xsZWQgYnkgdGhlIGd1
ZXN0LiAgRm9yIEdTSXMgdGhhdCBhcmUgcm91dGVkIHRocm91Z2ggdGhlIEkvTyBBUElDLA0KPiA+
ID4gdGhlIGxldmVsLW5lc3MgaXMgZGV0ZXJtaW5lZCBieSB0aGUgY29ycmVzcG9uZGluZyBSZWRp
cmVjdGlvbiBUYWJsZSBlbnRyeS4gIEZvcg0KPiA+ID4gIkdTSXMiIHRoYXQgYXJlIGFjdHVhbGx5
IE1TSXMgKEtWTSBwaWdneWJhY2tzIGxlZ2FjeSBHU0kgcm91dGluZyB0byBsZXQgdXNlcnNwYWNl
DQo+ID4gPiB3aXJlIHVwIE1TSXMpLCBhbmQgZm9yIGRpcmVjdCBNU0lzIGluamVjdGlvbiAoS1ZN
X1NJR05BTF9NU0kpLCB0aGUgbGV2ZWwtbmVzcyBpcw0KPiA+ID4gZGljdGF0ZWQgYnkgdGhlIE1T
SSBpdHNlbGYsIHdoaWNoIGFnYWluIGlzIGd1ZXN0IGNvbnRyb2xsZWQuDQo+ID4gPiANCj4gPiA+
IElmIHRoZSBndWVzdCBpbmR1Y2VzIGdlbmVyYXRpb24gb2YgYSBsZXZlbC10cmlnZ2VyZWQgaW50
ZXJydXB0LCB0aGUgVk1NIGlzIGxlZnQNCj4gPiA+IHdpdGggdGhlIGNob2ljZSBvZiBkcm9wcGlu
ZyB0aGUgaW50ZXJydXB0LCBzZW5kaW5nIGl0IGFzLWlzLCBvciBjb252ZXJ0aW5nIGl0IHRvDQo+
ID4gPiBhbiBlZGdlLXRyaWdnZXJlZCBpbnRlcnJ1cHQuICBEaXR0byBmb3IgS1ZNLiAgQWxsIG9m
IHRob3NlIG9wdGlvbnMgd2lsbCBtYWtlIHRoZQ0KPiA+ID4gZ3Vlc3QgdW5oYXBweS4NCj4gPiA+
IA0KPiA+ID4gU28gd2hpbGUgaXQgX21pZ2h0XyBtYWtlIGRlYnVnZ2luZyBicm9rZW4gZ3Vlc3Rz
IGVpdGhlciwgSSBkb24ndCB0aGluayBpdCdzIHdvcnRoDQo+ID4gPiB0aGUgY29tcGxleGl0eSB0
byB0cnkgYW5kIHByZXZlbnQgdGhlIFZNTS9ndWVzdCBmcm9tIHNlbmRpbmcgbGV2ZWwtdHJpZ2dl
cmVkDQo+ID4gPiBHU0ktcm91dGVkIGludGVycnVwdHMuIMKgDQo+ID4gPiANCj4gPiANCj4gPiBL
Vk0gY2FuIGF0IGxlYXN0IGhhdmUgc29tZSBjaGFuY2UgdG8gcHJpbnQgc29tZSBlcnJvciBtZXNz
YWdlPw0KPiANCj4gTm8uICBBIGd1ZXN0IGNhbiBzaG9vdCBpdHNlbGYgYW55IG51bWJlciBvZiB3
YXlzLCBhbmQgdXNlcnNwYWNlIGhhcyBldmVyeQ0KPiBvcHBvcnR1bml0eSB0byBsb2cgd2VpcmRu
ZXNzIGluIHRoaXMgY2FzZS4NCg0KQWdyZWVkLg0K

