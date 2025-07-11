Return-Path: <kvm+bounces-52192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B45A7B0234D
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 20:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7AA851CC2027
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 18:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642822F2342;
	Fri, 11 Jul 2025 18:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Coe8D4oC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385922AEF1;
	Fri, 11 Jul 2025 18:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752257022; cv=fail; b=qUVp1+A3qqrDVfTkefhT8jdPVZs5gdy1xvPWzQns4bPwbrRk6UOx6mv2lSgyz2zwD/vVI9na8F1nAjgwZUXvUEer5hGYNVutP6BJgnUSSdJ0121nksFt+kmTMQZmBuTUe7RBcZsqXL72Deq9tp4Qiecon8o+yg7aMCoNAVonEno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752257022; c=relaxed/simple;
	bh=KtKsdpyIXmkes8y3xqDeltxi0/7jGSij16hLco11wio=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h5yDjQtH2nKimNK7bcErhyG4pS+muoDisjv/axQGeg8Lbug/9RnehS0P5gvNiX73ogVTAVFG5p8mE0QHq0f1I8MSONbZXoWIotYS8KPyC7yCNQvuLOx72paIqxW7dyX9QRm4AbZI4r6zslh8TFHXNWwZpjqP4OuNfUZLforlAh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Coe8D4oC; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752257021; x=1783793021;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KtKsdpyIXmkes8y3xqDeltxi0/7jGSij16hLco11wio=;
  b=Coe8D4oCRVjYOa56vEOke/4ps53WZuURc/DucV+MnJu24NcJieAAO791
   E+wn9H1eXRtrVzPEYUDrzUMF2hR7PAlb2PX+SOGt2S2tiB7MDFdZ6mkGl
   1kdIfxn1ZyAJLJ7OBS3zSdkm/OqsRp/pd4YjgV26F2YKomjkEzGIxMgb2
   p1+518R9VJo+at3lQf97el0f9rPeIKL4D/h0bpD4ukONmqX7kY2eD3uZ0
   bDm8+RJ4SxzvxZh9worqqayz12caHh1vSQXAM8HJAt8kEQaGLdsIxYCeV
   CD6Kivw2YxFizEZTtUwQJWtHZy9HFoe+4hZ7YS3IBRKIsyBUkIMC0hmi8
   A==;
X-CSE-ConnectionGUID: hfimontkQIyZzw7wNTfdmA==
X-CSE-MsgGUID: vM2i2GVrRC+OS1R/5h8lqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54417745"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="54417745"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 11:03:40 -0700
X-CSE-ConnectionGUID: jZiCejXsTMO/Dx93kQ+q2w==
X-CSE-MsgGUID: fEindKBlTV6f0CEOtE7asQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="156763018"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 11:03:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 11:03:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 11 Jul 2025 11:03:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.77)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 11 Jul 2025 11:03:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JV7is07T/OaUxihz+TbImDqBxcX41jxB3ewctJQArpHZWrmbcnyD1MWUzNepcNFQRelCldu/9LxzG1ep85en6alM9NvFaOlRNRYsbm0WEUtICVi8U4pBuVMYwDJRpj7+mM+/IIzTPTxUoX6HoVjFT6B8j4+N6Q5ftHSZCTHspo5ehLZQJZow/5BnXGNLqTQxBKBXO3n+ubR+yV/XhXdDlxkRjlvlIPjfeZ1G5CsyVfjsXj0Fqya1sWMGf+njKuBpXQkHeNdP5EGAHFidz21qNpemBOwePga3ziklAOC4fptv5rQD2JmcMI7ShoNqTxqLVEk2TMvu5mies6KG78vmpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KtKsdpyIXmkes8y3xqDeltxi0/7jGSij16hLco11wio=;
 b=BLuoWrHW6QYJ4oakl2uJWAAFFIW5Q5HBsgV3Ao6WvoCIRrgL7wcbb1yqge8TpT/29osyG+2pC0uleqF9zasCP/UKOoL3YsiSVoxCugMyob6WyudeT2n/u8Gtk0j7P/ls7T6kYfX3J/YDYURtO0/rzD2alzCrxNrtbMHNnDMoq2O+Iuaz120QUTMTUcpjTzxQWIyzqQWDQnn2O0IY40kcjGQP3DfhBcmyhQ4F0EfiJZbTtJZfFamMVInOIYFFSy5z1LTTA5t+zi770IiolaoI9VNZecPg2qd64lhtUBHU9z7p0p0QjPKLITGwVRP/J/oQdFX/uWoHZnhUEll04tVu4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6214.namprd11.prod.outlook.com (2603:10b6:8:ac::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.26; Fri, 11 Jul 2025 18:03:33 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.028; Fri, 11 Jul 2025
 18:03:33 +0000
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
Subject: Re: [PATCH v2 3/3] KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to
 KVM_SUPPORTED_TDX_TD_ATTRS
Thread-Topic: [PATCH v2 3/3] KVM: TDX: Rename KVM_SUPPORTED_TD_ATTRS to
 KVM_SUPPORTED_TDX_TD_ATTRS
Thread-Index: AQHb8milQ6nQ1+wixUGI/cY8GkTumLQtN2UA
Date: Fri, 11 Jul 2025 18:03:33 +0000
Message-ID: <f14461f0f51d52c28c7be5decdc2e6a3e54db7bb.camel@intel.com>
References: <20250711132620.262334-1-xiaoyao.li@intel.com>
	 <20250711132620.262334-4-xiaoyao.li@intel.com>
In-Reply-To: <20250711132620.262334-4-xiaoyao.li@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6214:EE_
x-ms-office365-filtering-correlation-id: 5b1374fe-15ce-41e6-8c97-08ddc0a54003
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y3VJcm0vZGc2c0ZybGhPUlp2Ulc0ZURJM3NVTTF6TmFnWWUvdWZpc0luZ09K?=
 =?utf-8?B?MWd4YnBhcEhrci8vVEhVY1BzcWtGUVdrTlBIMWNEeDNCSXNQa1JMWXV3VTgx?=
 =?utf-8?B?Rk5aYUtTMHMvcS9NajFyU0I5Nnl6TmxxWlJySUdxbXZtN1Z4dXlNdmZFUmVu?=
 =?utf-8?B?UGhEdXFXdXp5Zlk2WkJIaWEzdEhIbnZJU2FnMElQT1BHNkhTMFAxYWlvZ1hQ?=
 =?utf-8?B?TEkwR0ZoT1VYSm1MaHFqKzlNRzJvUzhTUUJjZlJTMEpuSlo5T243TTlyKzJK?=
 =?utf-8?B?cmFnTy84NWhLTkQ5czc2Uk1PNEpveXNBaE1Da1dOOGIwSmVCZlV4T3JCdXEw?=
 =?utf-8?B?LzlyYTl1c2MzSEpFM04xOWY0Z1l5ZjVqMXE5NGNjZ1c4K2djY0l5TitxN2JZ?=
 =?utf-8?B?SGZJNlQvMlBicGhHZndIN1ZEUzJPdEdQNjcrak5pbEtZbENhMFJqWXJQZ3Jt?=
 =?utf-8?B?RzhMQkMzUTRZWmUxVmFMOUdINHU1MEIybnBNV1ZqWHg0V0pnMGVRWTVja1Nz?=
 =?utf-8?B?aFE5dVhuZTF2TUhSU1FXV081eE9hUDhTdjQzKzBPNTBzTm1HVnhlUjFiVVNP?=
 =?utf-8?B?bzcxNWNxTzAveUFmR2xrZnBaeHRPRHRRZklZZWxnUC9FR25wc1FxWUl6bHJB?=
 =?utf-8?B?K09rWERwYUFJNTIrdURNT3hSeHNnLzl3M2pSMTNEV296T0hGRGx3MHNVcUor?=
 =?utf-8?B?Nk15SEFyRUF5Y1NKeWZrZWlESWU3cWdJU2hjVHlxdE1zTHd1a1ZWYWtLcVY2?=
 =?utf-8?B?Ykl3ZTBUZTBOdlRKSXZmODMzUFVHeW92VlYzaWtNbmlwTDRmWFZhT1ZWU3g0?=
 =?utf-8?B?ejNEZGxPSk5DTXFRTkJqbm9HcEtsL3BoSlFjV0cwdGplY1NkaUp2NTJacHJ0?=
 =?utf-8?B?SkhveUw3YjlCQkptUXoxTWZrMEowNDZHQUFvSDdaVVZwampQc09WbU9qeWRG?=
 =?utf-8?B?bUdaNXljSVkxd2NrMHhjRVJhL1JsT25LcUNSWUFoS3I2b0ZTQUEwRjdocnRI?=
 =?utf-8?B?UTErcXE5S3RqNGlFbVpiU2VSWnljOUF5bkhNU0szR0VIUFJiTmVhQ1hCWG5G?=
 =?utf-8?B?SndQTmxTTWRsNkE2OFRrQXlsUW1hbk95VHdnYThUTklOdnBBeTlaNWROR2k4?=
 =?utf-8?B?UXAxdXhlNVlEaGl2dGpmRjBveFk5WDdjREd0WElja0dOZ0w1aGxLdmhuVmNV?=
 =?utf-8?B?ekNYN0M0MTFwZk56NW9FU1dxRUIvNEtlZWFITldOVFRWREZlbUErR3d0SEJr?=
 =?utf-8?B?c3pEZHJYS2tIVjdPRldMQ2lYRUFzUFB0VGMrMGJiaEI5cXFnT1ZhSHV5NElY?=
 =?utf-8?B?K0xSQWlOZ1dPbnNhZmNVOGVLL0ZRTzF4amJ6WnNPWVQrSDhPWnZnUUJmd0FS?=
 =?utf-8?B?R2ZNbVJqd3g3am5OLzdWVTFEYUd1K25TTndVVkVIN1dVVFF6ekU3czJjbHZN?=
 =?utf-8?B?RnJiRGVVeFNWK1hnUXpHUEpmSUM3RldFUk1FRlF1OWhqVWxJUlRDU1VoRXlR?=
 =?utf-8?B?Mis4N0p0bXNhOGZLYUpadERVeHN0QTJqUWp4VnhuQ29vWVpWaW56SzZaWmg2?=
 =?utf-8?B?Q0FZazNDam1PS2lVTGRrVXZZT1dHcCtZVHRjdEdKOTNDMTlkL0ltY1NEdzNt?=
 =?utf-8?B?dDh3aGZUM0REVXBTRlYyRmRlend1R2tKc3JPOU5NUjVGandCQnZUYU9kUWxB?=
 =?utf-8?B?L2Z3WjNCSkdkYk9WYlFvNXZreTVkemUyRE9NaU5VekFhMW9JMXUwUkRwUmNN?=
 =?utf-8?B?Q1g3UUlUZjFLeEVDMFpMT0NRYVlkMGl5R1E3T2xmZDlWREhzWlJNOENvUk1L?=
 =?utf-8?B?dVUxcHJDNktQZWw0RmhKS2RNTG9rK0RDZUVuZWU1S3ovTUtQT2xDUVNjeTB1?=
 =?utf-8?B?SDhRV2J4WldqYjNpWDZYZFpNalZHTFlFaG14cHFEZmM1NTFva2d3bnRMNWNF?=
 =?utf-8?B?bVNyWXhnVDIzZDJseDAzYXBDQldYbDlIVUtWaW5WbUFqQWlzRkFUcUw1WE54?=
 =?utf-8?B?emV4YWFvdUp3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFhUTkszMEVSSVBwSXZVZmxGalRncUM4UFlHd2xsTWZ0ZnBoazZ1bG9PdHpM?=
 =?utf-8?B?M1M1K3RqNERPenhrSkwrbC9KMElzZjc4OSs3c29INXhzSzIyd1N1RE5JbjMy?=
 =?utf-8?B?TzdOSXF4K3RUNDQ1N2RGWUx0cHE3S2hkUG1LYXl3TXpEVm9wUEFwdTVUeFFH?=
 =?utf-8?B?alJWUENJcWFDN2hkMFBiVktXQWV1L3JocVVhTmxMWklJLzNrL0FLMGwvRk1p?=
 =?utf-8?B?dHdpd29RbktPOGpydXF6cVFzLy9vUE84VWg5dFk4TlUzenRXcWo0Tlk2M21B?=
 =?utf-8?B?aFc2VUVDYkh0Zm5zdWY0b0xQMUwxQXcwYVNoNEhtTWI5eWo2ZTYzTklPYU5S?=
 =?utf-8?B?aXBpOEtIRktqb3ptREhlcHhya05UOXJNbTNsL252VkVoTkp0NWZXREFWU21s?=
 =?utf-8?B?WURmQll3TndUM21aYUZwZkh2N3RTNzFYU3ZEK2d6dlhDWFN4MG1udFc5L1dW?=
 =?utf-8?B?czIwcktURldZOUg5Slp0RlpCdzFub1BCT2xLNUhhaThsUTdHME1nZ012UUR0?=
 =?utf-8?B?UGd6ckYxeDZaWkY3OHREelZOS2dXZFczdEFjTWZRanFVQzM3ZUEwbmpYMzM3?=
 =?utf-8?B?RGluOUxzKzhvWCtENklEcnVnZnBmSFBXcmFaczRxTXBzVzlnb0wrcytSbGho?=
 =?utf-8?B?WFdwcHkwR2hOdDFMendkRHRyYXNWdmF2ekJiVUVoRDlwcTR2bmVnTk84bHpF?=
 =?utf-8?B?MkNJSm4vVWR2MDVCVnRlQWh5OENuZkQ1ZDRZa09ibmE4c0YyaFVwR1d5Q0xl?=
 =?utf-8?B?S3pHVDdTZXlNMDR5MjhoRUpKR3FOQTVPdC80VXFYTzRCZVRZb2NXa1VGVzEy?=
 =?utf-8?B?NlI2UUlEVUw4UlhnamN6NGlKYjd5bm90R1JoY2gyYTU2dkZvS1hqeXpHM245?=
 =?utf-8?B?VmtaMnlGVE5vZGVURGdkRG9CMFY3QnJMb1lkU2RCMmVxWVZXeWR2cVQzTUpT?=
 =?utf-8?B?dVhWYXhoc3pSRXdTVXM5M2NKekhyMC8vVzB6KzYrK2VwYzNCVjYvZ05vMXBz?=
 =?utf-8?B?RTd3RUR2WTdRbjdYSG0vSHMwTzRNZnJWVEt2ZXRFaytEdGFuaFpuL2xPOGY4?=
 =?utf-8?B?cmpYUGQyTzkxa0FWOEZyZlVSNGozVW5VNk55UGROTDJyVkFodmlTemVwMGNw?=
 =?utf-8?B?UGFIUXFQaVFZK1JBb1hyTUFZblpRZnNhN0oyejVhZkJnZFFZUW5GbFQxdCtD?=
 =?utf-8?B?UWlQQjFFakNHdUVoNmFMdCtCSEN1L1hOQnNnN0dOalIyaDFwakpxY2Ewcitx?=
 =?utf-8?B?R3NXWDZXeWRzdk5CMTlRMU5qUWtuNlpuRXhFbFZqck8wa3E3c3hRQ2Z5dmpn?=
 =?utf-8?B?TGt6YlovZHBOZkplbmpHZjhHbnJWRzZIK29NU1VqM1dWbGs3dXpmRVBPTUhz?=
 =?utf-8?B?aFFsL3hYaU9YaXIvYm4wTkZ5WUFnVGhaYklmbmtKc2U4WDZLR1lkZ0R6MUxs?=
 =?utf-8?B?UmpUeDdobWtBYnJySGFUZFNyK3pseityaENZKy9CbTNJWmdUN3RCUW4zb1Bp?=
 =?utf-8?B?UE1WcnE4MmkrU2VuS0dqN3lIaGs4d2Z2bnEzWTE1dDhQZGt0b1VvSmtYNUo1?=
 =?utf-8?B?R1V4ZEhhTGxmUlVKME5lWDhLNmJ3N1IwYXd0WGNSc1lOcjdMMU4xVUo4YzN3?=
 =?utf-8?B?VDFqOWdJdHVJWnpBVVhiamphYXBDSTZoRS81czhnUUVWMlJhYnVGNlB2V1FF?=
 =?utf-8?B?eDJqUW1FTlRrL3VjNFFVMzBJT2hqZm1SZ0IveXJXUFlEc2dMY2paWkhXMUho?=
 =?utf-8?B?VFRWYXFDSVRhY0Y3b0RQcmVoWUg2bnZyTHBtenZFaDU5RWxsdzJNTHJSNTl2?=
 =?utf-8?B?NkFiT3c2OG9SdEFNa2VPcGVqaVgwN1pibjY4VUhEakVhdC8vdTdZcmhYTG1h?=
 =?utf-8?B?SFNuMlVuWkJsNzUvaE1xVUZvamJWQkRmeGl3WHNOeFQ3YUt1elM4c0YzSE5M?=
 =?utf-8?B?NUhWTHNHN1NoUitaeXFiaGhmQ1V1TnRwS2VJb1hxaUk0Vm4zQXJ3TEg3ckVO?=
 =?utf-8?B?K0JuNU80Z1dObnAwd2tXVDJzQlZtRFZsNXc0Nm5XTE9sWnZGYldvb0xPTHZq?=
 =?utf-8?B?bVdMaGpEc3JjazZCL0hSZG5IMjNIOXE2Y29hME85UEhVbXI0YmkvNWxGT3FK?=
 =?utf-8?B?Si85dFk4TWJyejhRa2NKNHNxUnFXUEhvcFBqMkxCMVFLMFdrMUlBcU5ncU1h?=
 =?utf-8?B?UkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1F93B93EB2B5743A6337A1E911FE7DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1374fe-15ce-41e6-8c97-08ddc0a54003
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 18:03:33.1997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wFhbcSyaS6RPZ+TNUFfo9D7YYxFwbVjdwbpdmgVZ3RhiwxmHPkEhLxJpjF1ZxcgEiLePyyvQQwYBg2RUqEvsZ8M2xCer360oYKH8fNec5gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6214
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA3LTExIGF0IDIxOjI2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiBS
ZW5hbWUgS1ZNX1NVUFBPUlRFRF9URF9BVFRSUyB0byBLVk1fU1VQUE9SVEVEX1REWF9URF9BVFRS
UyB0byBpbmNsdWRlDQo+ICJURFgiIGluIHRoZSBuYW1lLCBtYWtpbmcgaXQgY2xlYXIgdGhhdCBp
dCBwZXJ0YWlucyB0byBURFguDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IFNlYW4gQ2hyaXN0b3BoZXJz
b24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBYaWFveWFvIExpIDx4aWFv
eWFvLmxpQGludGVsLmNvbT4NCj4gDQoNClJldmlld2VkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmlj
ay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo=

