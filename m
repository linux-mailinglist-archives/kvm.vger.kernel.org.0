Return-Path: <kvm+bounces-46998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7507EABC444
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E63CB1B65254
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:19:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3C5289374;
	Mon, 19 May 2025 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rz36PN7w"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5038A289356;
	Mon, 19 May 2025 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747671452; cv=fail; b=kgPtYMIckd2GvKhznthHSQqwfKVjyrMqKvAYlFJSVPmONSUyVlKjsEtFuPQsS3ybzzaTqUMSByJXE1aAUJKarPzX2Jnk1FsJpFeSOP1i3+VfFOJ0Cfu86qoIStB2gwKEz+eFKwcgBY6rW2tUCgCzG+NabNDCDUcG9peGGFOhIwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747671452; c=relaxed/simple;
	bh=5J4keNMgZo+O+MtEND8NjNDziBD2ZG5ErC6CFprkV1w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qCLu/cnTzGNYUf8Yfa00+kuSe72o4t9dvHDv946WWWHI4q97VHRHov+Jml/lIpz3dOFDTQksNddKAoS9i3PttQySoq6MT0GKTIKkxGXTqeeUTRdEUyWpTeucsBv2iw7P3xb0EPd7Y4yz0mpxrQFut2LEe7rhvk0Lmg2Qxcjthhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rz36PN7w; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747671452; x=1779207452;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5J4keNMgZo+O+MtEND8NjNDziBD2ZG5ErC6CFprkV1w=;
  b=Rz36PN7wi1Mrb+QARvkqnQTJ6d6PxISocYz6/mgWHGmK8sNuae+IKXWu
   8yDSD7nAbO39WzbCM1ZcT4o7c9gMnvDJY2HC3iDs7VzUWlrnrXHxo6vaR
   I9WMoJ3fR7Q0uM9x1ZP8gOTbYleL2fnOQXGhtONwBOugaFdpO6qysGf7L
   QbCccU2SOAa1ooAWqnkbsCa69GzyA2Ww0Dl4OlWp2ET/zhlFWPc6R8Dkp
   E2UyG+2PJ59+IIY1XoWMU61Z0wD19hYwZSO7yr5mSuNEe4y0MjIBinpkp
   LRwPcUuc2y502sDg2LQaK4Qv1T3J7GLZeVRDbQ5gk05djmtsc81EwSCIH
   g==;
X-CSE-ConnectionGUID: QWPEAOHZSoiC+eL8y2bEcg==
X-CSE-MsgGUID: 2cc3hDCnRTq+3KW7jrTi9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="49453901"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="49453901"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:17:31 -0700
X-CSE-ConnectionGUID: 2xFI47EqTRefXVX0hR/lyQ==
X-CSE-MsgGUID: lDjJdEcsTSOo92ZXPxTlUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="139924863"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:17:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 09:17:30 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 09:17:30 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 09:17:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GoFfsq8VZkeohT0P99INRcozIBS86RI302KiD7HJWJSa7PvOqow38KI5LNWxJrMZURfk2lPua9os50btcDUpQbRrve41a+mLfmB2TfB8aSNF1+xfoJWF3sJcK4EbCIaoh/mfbS5uNwk09Zc8rzWIfC4O0jH7Z0A6fwLARyO2ivi2Qc0u1kw+wvm8UvJ33rGVBp2D+pci9oHlvcqZqbjRsVUguGBW5McfKKX3gxGQsGe5KHUR+p3iZn3tEefqRRyOTnEnSPkY8ooeHP4vKg2lghOSq3AEZtAWuC4X1zIe7YZPwIfB8DiLZd7UqCYgDYWxkixvbv9ui0FR+41cAwcxLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5J4keNMgZo+O+MtEND8NjNDziBD2ZG5ErC6CFprkV1w=;
 b=XEJsHFzakUTW8n3zGABYT9tD2zlJV5G26iOAtdlBoUQM8r5H+Wk5Q/mW4xhzM3CTJnBdMqz8vIR2a13CUips3PZdHLBOOInPJbEgOk89qFY+UCxokYDyUKNAfWiK4hqulNUWwghE4qusgcTbSqTYD0LNco0j/Jt8Yjt2G6UhSSbSSI7uXJuy6j+NSDSKFHWVWvMd3E5MHQhHhs4el6FiRqXWSCUJ/74BBHqKBBg/OB75Pc2xI40QQ0F/76CtbFJyq9PYEpHqfVQ/tl+XC0ur/j3ev8BB1TP/3nTBcEkVndaMgK5Ea7/XiF9cTiv9rIa0i3Ja12XuSNm0hpD1tgq47g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5971.namprd11.prod.outlook.com (2603:10b6:8:5e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8746.30; Mon, 19 May 2025 16:17:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 16:17:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
Thread-Topic: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Thread-Index: AQHbyGdiXv6lSo2xSkiHY9GZD31B8bPZ9FUAgAAZ3wCAAASjgIAACKuAgAAGsQA=
Date: Mon, 19 May 2025 16:17:25 +0000
Message-ID: <ef5e4e27f482f573546c386321f07e150951ff83.camel@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
	 <20250519023737.30360-1-yan.y.zhao@intel.com> <aCsy-m_esVjy8Pey@google.com>
	 <8f9df54a-ada6-4887-9537-de2a51eff841@intel.com>
	 <34609df5b649ca9f53dfe6f5a134445f1c17279a.camel@intel.com>
	 <aCtT9zsGmPiH2S6L@google.com>
In-Reply-To: <aCtT9zsGmPiH2S6L@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5971:EE_
x-ms-office365-filtering-correlation-id: 9b684f6b-ad49-42e3-792c-08dd96f0a4ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SUw2SFdkTG40OFpPNnVycHJPZVpIRjMvWEVQYkx0ejBkdVFUTUphVWczUHVI?=
 =?utf-8?B?aWZyVW0rN0dMTnI5TWdadFBEY0VDajNoSEpaQjViMW5peHhpVkdyWEduWFJs?=
 =?utf-8?B?QkY5VFBRaGlKTWlubXAyZmtuTjBUcFBpbE9wVDRNNUdob0xOazdQL200dFNj?=
 =?utf-8?B?VTF2Z2xCRmxoSmhxeWE3SldlWmh1ODVOZ05EUW4xTThVdVllRUcvTlBVMis1?=
 =?utf-8?B?UjV6cVJYaXlZZUVYd2s1T0xRbWRMdTRHMklTdSs1cUdzZjRJczMwdWsrdTJD?=
 =?utf-8?B?QmZDTkhBUkhmQ2pnbk50TGMwSTdld1lRWS9TcUtEZDhHWlhxb1JXbFNxdm1y?=
 =?utf-8?B?Q1p1SXpSMUIrWWN2QTdJZkswYjRHV0JheU5UcmtwNzVXcG11NmtzVmhRVXJZ?=
 =?utf-8?B?ejNrWmdmM2phT2oyZHA4SWVtdS94WFA0TndBL2diVzk2WllOM3NFVlRLc3pV?=
 =?utf-8?B?OE5RNUxESWg4bHQwcUhZd0J5SWJGeFVqOGNMa1NuZzBKK2kxU3l2Rk5rTXJL?=
 =?utf-8?B?QTRBaHZ0d1RLRjArVW9adUdHOERQY3hxNUo0NjJUMlBmT1dYaWVJSE0yUFFQ?=
 =?utf-8?B?U2J2emVKd0hrNkd5Z1k1VTM1K1Q4N1RuTloyU2l1VTR1eVV0cUNPQkcwQmlk?=
 =?utf-8?B?RmZSa2YreGtXYkZoZmplS0hPSXp3UVp5RnorR1M0ck1QeExDYkY1aklSQ0Rm?=
 =?utf-8?B?dk1oOUFXYktLUzREM2NmdmU4MHZkN3NoMlpNNzhQdW9XcllpeUJuQ203WW12?=
 =?utf-8?B?QjlFazgyWmxiYi93VXRlbTZFTUkxS2gvclBUWmpKdmordmExR2hUU283SlEv?=
 =?utf-8?B?dFNIZFVWNFFvOVhpUGJ5Ni9TbnRTckxiYjlwSDN3RGR3c1lKUWVpNEhjRmtL?=
 =?utf-8?B?UlhMQUk5MXlGVnkxcmMvVXpKMXN2NFZQY2E2ZmljZjdsRklWUGk0aDN6TDdR?=
 =?utf-8?B?QkNSVUlQcVNxaHA4SExZZ2owZlRTWWVndWxEVGV1S2N3Z1BZTVRUV2ZVZDBP?=
 =?utf-8?B?S1RuK0VWRXJ3Ky9XYXVQNlhwNkdxY2hwQXRuRmFXRTBpYWt5dk45WEw5THNS?=
 =?utf-8?B?UmhRN3dNUXc1a1ljcmVyMGFrU1BwN2xoTTBLRGRwd1NjZ3lyYXVXMGdKMGNa?=
 =?utf-8?B?THNncUVtdXZZaUROWXFtVzk2ZW95VUZNVTQ2N2R0TnhmdmgxSUIxSjdQajUv?=
 =?utf-8?B?TXhyWmFjSnAySGNRTGFEK2N4aTViK0pvbUtibS9mcE0xVFQ1WFl4RE5Ta1BO?=
 =?utf-8?B?aDJjZWNaZ1BQeU5sdUp0VUJFY21OVkVWMHJzeE15U0p2c0c5V3J2alhMbG9J?=
 =?utf-8?B?cFcyclI2MUhMcGRnbjZhVG45a0E5Nk5HWm83dUtPWXp3cDZ5NnV0U3kwaEdr?=
 =?utf-8?B?Zy8vd2cyUWJ4Um5hYittcU9OQmZYVHhBRlZIb0xoN3pIeWF6cFF0cUtxWFI3?=
 =?utf-8?B?RFhVSHlub1o4MllFUExDNTdndGh5aXMveDZINmNyYVozZ0JvNys5Y0lDMUtT?=
 =?utf-8?B?NTVkaXlVN0ttdXZHcW5wVHRLOHVVYy9iajF5UnNUc2JMQVRnMUNnbWxDRG1t?=
 =?utf-8?B?WUp1a2w3M0V0MUtrOUw4RysrUWRnT3JMQjZXaklhNGduWDl5ZTNLc0NuNkNw?=
 =?utf-8?B?bGpvRmt4VVhuVFdFeDdjYlFEME9YY2VMaWNwajNwUlNTYXFHc3dhbjNIVXZG?=
 =?utf-8?B?cUY5YjN4VXhZMGhDbWhYSzNxdk16bVBEbSthT1Q2L1hNWVBEVWxKbDdsVGVF?=
 =?utf-8?B?TnY3VXpKb0RPeGpmMUxPdUd0QjBqVXRCb1BVV2h3ZUVabXQzZlBsZk01NE9z?=
 =?utf-8?B?Tm1QSDZsakFBQ3p4RVNoNUNLRUIrZysvcy9VQVhCZC8ySnYxd253UVIvVXJk?=
 =?utf-8?B?K0xRelZpaWVGWmlPRVFWeFZrNTEvVlZ5WVpCZlUwZERsM0c1clpUUkVTZzR2?=
 =?utf-8?B?VzczSS8zUWFPWERsOThOUDljbFo2N01BNGVHOUE5REF4dHR1Nk5YNHUxbkxX?=
 =?utf-8?Q?oxqxtTiY5HG5LuggaKkIOogQXkI8WQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cVpLTTFCQU9qZjcwbEFIUW5tWmk4UmdYUVdoNWJyNzFNcFpFUmNMMlRhc1dY?=
 =?utf-8?B?a2Q4R2loeWNSK1Mxd3pMK2tZL1UwbVJtY0FmZTU5ekU4QU5GZWFpbnFxSkMw?=
 =?utf-8?B?TWpQUjl4ZzBQQ0pDQ3pUYzBvcy8xZGxTd3lVRUtPQXFmMXlvVTFyaUNjU3Z1?=
 =?utf-8?B?Z1UrbjhxRWRYRTlFRWZrM05lSlZFb3FsbzN4eTRwUkwvWUR0dEVPNDBjZFVE?=
 =?utf-8?B?Q3hWSnptaEYxUUtxYkRxaE5uU1JjSzhkbUR3Nm1uUU1YYnBjYmtQc2lDOVFF?=
 =?utf-8?B?UUFnUHZTaEhUcnhWSDVSeEl3ekhZdmZ3d2JqcXN0VlVmYXlXQUNGd1Jlb0hU?=
 =?utf-8?B?dFhCWFIwNmpPUUh1bEl6eEhGRzF5OUxhRDVOTXlLMVpZdXFYWnlhMVBnVHhN?=
 =?utf-8?B?UytVKzVQZWhncW5ScmcxQTM5TUZCeWo4QTFhKzVvdVA5cExNK3ZXY3lkUE1m?=
 =?utf-8?B?YS9KblZiMlJoTXNuSEhJUUNOcEQ5TFVvVHBsZkVJeFpSTUFhR3VKSGNHUzVq?=
 =?utf-8?B?aTNIR29laE41T25yUmNUWXNVRjVpWWFsbUdYQzdkbFV4am1EMzRrbGZlTWdk?=
 =?utf-8?B?NS9zZHE4MUtjWHhQMHNhWlcwTzhRWEpyamJFV3Y0MGdlTlBiV3J2dGxIM1Vo?=
 =?utf-8?B?UkE2N05IT2xweHB1MUwzUTEzR3ZFN3VrWEFLdGwzNm1FYVZKT21Jd0RKbjVo?=
 =?utf-8?B?WXYxNy9ZbFJ1MFpTY0UvUmttN2FrR0JmV3F4WGJIN2E5TWlqWDZYVGtBU0Z1?=
 =?utf-8?B?ckFsTnA0SXBpWXhvT2k5K1ovQ1BIWTVMVjlDVjN3RnZKTVJVcXhaUWt4UjFB?=
 =?utf-8?B?UmRraVo2RkxBaXdEMEUrRWI3U2xFT1BPYzJueWIxTzhheWttazZNT2x3MXdB?=
 =?utf-8?B?RUhrVjkxN0djUWdQekprdXRSblNDSWFiR3FjTHJ2VHBBS0kxTU4wblRQanpq?=
 =?utf-8?B?OHg1TlNFSGdBUy9rOEpoR1gxMjRGWTdNMHVwcnhOajRISGJmTnNaRGoyY001?=
 =?utf-8?B?OHFKblpOWlhpOTdDQ1R3eno4c3JhcTkyYlFCRy92SHNZalJ6VTFKQnRqRFRp?=
 =?utf-8?B?ZlFBYUEyVXZSZi9ZaTRYQlliR0NzaDNiOXJWNmdBSUZrQlpwRkZGUUx6SStF?=
 =?utf-8?B?L0dnMFhiSFFSYTBVNWY2WUYwVStLVHpGSmYvTUZtM05zUHprUFpvMFVSazUv?=
 =?utf-8?B?dXo4WUtuYXczTnVBbnBkdHo2MVhnNFhPN2N4QUVHWjY2US9GMkw2c1llazlG?=
 =?utf-8?B?a0lWVnZpVy9wM1ZKVUlXWVBlbjBMMHo3aS9tUllXZUtMRk1oQWZHcFpSOG1y?=
 =?utf-8?B?a2dDUG5SWjFXN3RZNmFvN1c5KzZXeW04Wk8zVEp3dERKT2R0Y004RVlUZ1dU?=
 =?utf-8?B?clVQR2YvS3BiMFBCSFpzWXZBL1pES2dSL1YyUXlwZjh0djhNY2ZkN050SWZC?=
 =?utf-8?B?S2FNaVk0Zm5LeUtjM3g3ays5QUt0RDNvYTFpSE1DdDYyRXIrYVZ3UEV4L0hx?=
 =?utf-8?B?cEhoSysxNDJmanRqV2xJa2J3Y1FuR1FOYzRJei9QSitYMW1yNWIvQmVXMWcz?=
 =?utf-8?B?bnZtN1R1SWN6ZEx0cmgvb255UllVQzRweW90UVlkZWl5VTRrZHRhQTJtZi9Q?=
 =?utf-8?B?R2RWcDFRa2xGSUlsQXhLK0krZGl2RTUyaWlYVWFHcWlsbW5ITHUwTnRkZEFX?=
 =?utf-8?B?eHdCNDlPRGV5eHR1c3R6TTd1bFhxTmxOM1phZWFwNzY2akpmWGQ4ME5sYlZp?=
 =?utf-8?B?NHg3UENUZ1QxbmdDeVdBVVpocFU2QWtYSU1UOWRZdk81WmJ3ZXg4cm5BbzN2?=
 =?utf-8?B?Y3g4NmcySHplOXo5VkJCY1JRT3lVN0RCdm9Hd0ZFR2YyMU9PcWpYaEhmSW5B?=
 =?utf-8?B?cHdBK1VjSXl5TnZ6ckpwd1BFcXJMc1dqejRPMExlb293LzM2QWZkK0dMRWNp?=
 =?utf-8?B?ajBHME5qQXlQV0tHYkpUcXhyb0Z2cFZGRVNwcUJMcVJVSzU4NS9Ub0pHcXlO?=
 =?utf-8?B?bGZvZkM1bE9LRS9wZHRyODY3OElrbmtPdHZESW1UY3BZcFZCbzZtc2hIS2RS?=
 =?utf-8?B?VE1Sak5lSDQ0Q0ZCNE1yTnoyekp4bUVLRnZUYkp4VW1DSjhZV1lFNkgvMVhJ?=
 =?utf-8?B?VUJOR005aGIzV0w4bkszTEJvcWJaNlZUU3JKeTQxbU1nVjlyY0VlV0x6bHRs?=
 =?utf-8?B?UGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F57AC08D8208DA438D697E262277A16C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b684f6b-ad49-42e3-792c-08dd96f0a4ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 16:17:25.7442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FvrUPm4bG9a0zGuKldgaRWHx0QCr8xU3m6g+P7TQ3/hsEhW4fsXTfspNz6XCqq0Cx119/Ov0/xVnCHfR5WMv7f+jcAUnPnEBhPvIIDbBYBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5971
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDA4OjUzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBZZWFoLCBhbmQgSSdkIHByZWZlciBub3QgdG8gYmxlZWQgdGhlc2UgZGV0YWlscyBp
bnRvIHVzZXJzcGFjZSAob3IgaW50byBLVk0gaW4NCj4gZ2VuZXJhbCkNCj4gDQoNCk1ha2VzIHNl
bnNlLiANCg0KPiAsIGhlbmNlIG15IHF1ZXN0aW9uIGFib3V0IHdoZXRoZXIgb3Igbm90IGEgInJl
YWwiIFZNTSBoaXQgdGhpcy4NCg0KTm9uZSB0aGF0IEkga25vdyBvZi4NCg==

