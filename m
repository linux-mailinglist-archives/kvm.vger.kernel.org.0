Return-Path: <kvm+bounces-23344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D66948D96
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 13:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C2A51C2233A
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 11:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67EF1C2326;
	Tue,  6 Aug 2024 11:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ItKS1TDY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB1D13B2AC;
	Tue,  6 Aug 2024 11:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722943423; cv=fail; b=GN8ifVmLAoQWtrRXzkceGvAN8P7cLiXe+O/KWk7/PyQBZh76u8jfQSQqT27ad28jzIO4BvEAk5HgzMKHsqbmUmFSQDu+zY9G9a3h9CsRDAiCE2UUe6wLFviftf98fpMDewrKawNSPBPpeCTNODG38KzHy//7LEqJHAbNK8t/Lc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722943423; c=relaxed/simple;
	bh=VOLH/ecCpimlX6U5YFZ+9+G8MDv7KNOg0L2IwojZEBc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uRhtCVXSKMgb7dhyGJZjy6A7QZJOtivKRZJiLsEuThCpwUwSB4JoGwCy3wvILBJ9XHfoOpg1GUPvw5xUV5u9W+wOcXpFGDC8GR19FpSJrdlYBaKuHWY0AXvGK+O7R+E8ITYY2UaihRbgu45rnQ8j8u9+QfvcnpeyGiCEKI1nFEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ItKS1TDY; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722943422; x=1754479422;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VOLH/ecCpimlX6U5YFZ+9+G8MDv7KNOg0L2IwojZEBc=;
  b=ItKS1TDYXNf5810/iJxqi0bJHag8xb5cqWQITxH8959v4+hsvl3uTh+c
   3Mpwo135b0lVTKiYXsV8mq2JF3YA6vev6Yu7Np4Ej5TGY3adD4o5CBbmS
   s/Z0snpyC8zCtaRjvNwYg/xreANplzToBclDNmLQVVy9hl99Lj0QpF1+5
   /2qSzv9AZLqSPVQbHYpghWp2tQ/etMGC0LJDIVe4wZYLbGEzQPo4vEO45
   QKlJLtri0n30rUTr4+OST9O9QuUiQVlEs36at0+ATW/R7Ato1ptl2xQcg
   udV25BBAZaCvlkg5RgYDZ7PwtPLyCeq5iso29lIchZ0SqP6gkEzJYnlHV
   g==;
X-CSE-ConnectionGUID: h5108G9wRDyI9F3ImUvyow==
X-CSE-MsgGUID: ylo7+3NrSHmW4oo96Ba10Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="46356034"
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="46356034"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 04:23:41 -0700
X-CSE-ConnectionGUID: F/hFUHfXQ6Sje9FF618y3Q==
X-CSE-MsgGUID: WgSRu62oTeSPd/SE0YQn0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,267,1716274800"; 
   d="scan'208";a="56413214"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 04:23:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 04:23:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 04:23:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 04:23:39 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 04:23:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sFzbGOVOsCwwNmyr7LdMa9F+WfPOMl1Z1gAnwOYrrl9pMxEMRNdQ79FPhOdVWBJd5/L7/ZoJk6q6aDe13fbsZXcmf5NuZyqYM74yhy9as1ltuHJokH3Nlv0B6nw/5Rw17mJqtdEaMD/9Iow5jFHcB6r2Y3+JZsej1i9GlVo7Nh/kI/TJLMWHZj6sYZ5o+o60qvWCjb1GYQghDT5r/qUXONtM5baphZr8lu6AkOWueKbF5kRoCa/6UAiuY4tIYqK/5MoBJDKl2QlC4T9EMnj7ssG8dpQmgHxh3qQIcA3eofqualGRD5N0nTofbedcvVpC3KULq0vHUCjgjs4/zNGjfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOLH/ecCpimlX6U5YFZ+9+G8MDv7KNOg0L2IwojZEBc=;
 b=pn3xmEXEmI7UKFFPNpQetAVtKQG7huTxRx6CLmXFQ9R1r4P+u6XjE/5Pdyw214NpqMOC1x/FOtXZs3LZNdWu7yGBwxKDU3QZGkruWDQIvETll+Bfwct9oa7b8MS8TboZymBykYBElqMWxCg5tsIqMe+0Igpq9KdlGUpBD3N4MaKvSG3ShZNO4pdMl+ahpETuDcIWIy7oPg1i7GF2GSzSo2S1EAa5LU7slzfbVFmE8S0sWQnkQmcpw+s72l614d7uESvXD8f+GGORy4iZn4FJ6V0csVFEmlYK+7cBAcRfE8JoOuVLEWXnGnjFcJyGWhhUVwzIMZ+ILWZwtyJ8461csw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB8776.namprd11.prod.outlook.com (2603:10b6:610:1c1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 11:23:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 11:23:35 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
Thread-Topic: [PATCH v2 06/10] x86/virt/tdx: Refine a comment to reflect the
 latest TDX spec
Thread-Index: AQHa1/rKNPBipNV/VEC5hoJmd+/L8rIZta8AgACAeQA=
Date: Tue, 6 Aug 2024 11:23:34 +0000
Message-ID: <e0447cc1ce172e1c845405c828cd3b6934b85917.camel@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
	 <bafe7cfc3c78473aac78499c1eca5abf9bb3ecf5.1721186590.git.kai.huang@intel.com>
	 <66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66b19beaadd28_4fc729410@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB8776:EE_
x-ms-office365-filtering-correlation-id: dbb80bc0-af0e-48b7-f1d1-08dcb60a35ea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?ZnJVRDIyZVRITmovK0NqTlg4dEdtbElMbS9Uc2k1SDdqWjJXNlZrTjh0MExG?=
 =?utf-8?B?WEZuS0c3Y2QrWXUrZG9RcDh2RU1vU01RS3hVTHJaNi9xbjd2bUhwNjlaM2g1?=
 =?utf-8?B?dVRVTVY2Y05uRGQvTXhvQzFSVEYySGVrS2RRM2RzLzFSQTI5SVprczVTVmZu?=
 =?utf-8?B?LzJOd0FVMVZEUS95Yy96djR4NFNQbm0rVGpsWGg1QnRMUXhPWGVmQ0V0emIw?=
 =?utf-8?B?bzlHRG9NUE51b1UySFFuYVRXOHZhRTdMMmY0bGkyL3l1Q0QvQTBEdmtaZW14?=
 =?utf-8?B?LzRwY1Fud1RvN0NIcE0wVFRLaWVNSHhSMndYTnoyemVkSzJmbXJCNGR2OFVu?=
 =?utf-8?B?Y2Z2dGM2NldOODBzVnhzR256WXM1cXdYOW9YckhUd3h3TjlvcEVyTitabGJC?=
 =?utf-8?B?cG0wT0xva3B4QzBLNXI4SUUvcDd6R3FRQ1p6eTdpWC9iNDNhQ1pRc3preHlQ?=
 =?utf-8?B?T3gzcTZpMlRPL3hkZlh5K014WlIrVUJ2UzBHSGNrZnN2dDVkYjg3NDAyWXR1?=
 =?utf-8?B?QUdqTlhkWTV5RTBMeVNXcFc2QSs0U2lOTVRQU1IxTVZIMFRZTlZSVjBCeU9F?=
 =?utf-8?B?TEhvbHFGdlZmK2RlcHdDb09JKzc1eUliSzkvWUVxL2RrUFZjaUJ0blhNNXI0?=
 =?utf-8?B?RjRwQ1FqcFllK09jUmEvRVVTWEN1V1BNbm9PMmsrZjlzTU9lU1h4RjBvTGRU?=
 =?utf-8?B?MVlLNlh3WUZxaDZMMFVDVkZoWGRqVG9uTEJrQ3kwM1BUTklTYVpnOFJ1Mmlo?=
 =?utf-8?B?RStIT1Nhb25GYnFQR2FyY0RBVnB3MXUrcjB4bk1BbC9NUHJkVVJzTlFzVkxT?=
 =?utf-8?B?SHNmdHB0MzdmdC9uNjhYak1NTVg2ck1idXpra3Nqa0Zvc1FDV3E4RGl4eUQ1?=
 =?utf-8?B?L3V1S2FMQUF2ZzB2blJwOFRsVEhWL0t5UVhSWTFmOG9aRjNid24vdjAwME1Q?=
 =?utf-8?B?QUttQXZSS1JkQ1NPWGZyRy9QeitxRUVYbFU5K0xOY0NjcURwcEJ2NTMveEhh?=
 =?utf-8?B?bWhCVjlRR0R4T1NVcjNKWFhJbkR0SjJ3UmhmRFFXZ0dNdmg3enFYbmJLKzN0?=
 =?utf-8?B?anFIT2toU1lYVjZBQXZGVlJpSHFTRVdPU2ZVanhDcFdzWURRVEhzVXFvU0x6?=
 =?utf-8?B?VmtsWUxLa25zMjZaU2pHMkp4WlFWWlZFYjRlOFpCZ05WKzU2b0M3OFpTakpZ?=
 =?utf-8?B?OGxwcUt1RGI2ajJxS1Z2ZTlpZ3NxMVlINkNkSDZBYVVrSWFxaUlpQ1Q1aTY0?=
 =?utf-8?B?NEIwRk00Z0E3VkIzRUNpTjZPbHhnQTRCNTdqQ0tXTVFVSGNWanRsUmpGQm5w?=
 =?utf-8?B?YWpub1I4RTFJMnNRdE92V3FOWXB3ekpqRUdWTUMvRzV2WDFENm10eGRhamdN?=
 =?utf-8?B?bW4zZ1lXdHV2SzVVdG0wN1lDUERrR3NvYUg5ak9pTzg4SXBGY2Vrc21GaExX?=
 =?utf-8?B?WVdkRTVTTTQwOHdCdFFNZW00dWZxNDA3dURLN2pPK0xUc3c2SXRwUzlmL1U0?=
 =?utf-8?B?bmdaZlQvM2I3RWlBQ3BQRWpzZDc3Y3c2UjBjelI0anlrVWk5K3BJejNDdy9J?=
 =?utf-8?B?Tnd1MmRiejJ3UElUSDkxWmtBRFcvblNERXZCSVdoVE8vcmo0R0tGa2Q0M2cw?=
 =?utf-8?B?Q2d5WHhMd2pqSHEyQ1pEZFR1cEtxS2pmVkFHS3FTZktxQmFCd2V4cElZWVZY?=
 =?utf-8?B?eXovU3JrWC9QVGlBUDhlbis5dk5PZ2ZCTTU5S0tjZDVoSHpzMUZKVmgzekJD?=
 =?utf-8?B?Q3lLcDBjMFVyRmZxWWNtYkEzbUNsczVmQnI2NmV1dGFGNG9TL0hwQWdER0w2?=
 =?utf-8?B?Y1RydnF3emJEWm1UeGYxeWRDUFVaMU9pWHV3d1pzQjBnRUdqRlJmVXlRQWlM?=
 =?utf-8?B?OW0yMW1PSU5lUENsQnYzWkZTSCtCdXpUc3hBS0RmN0k1SFVFRTVpcWJlN01C?=
 =?utf-8?Q?wA2Tfa93pAw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2p3cithZWFvQ1JTM3JsUEFidlQ4RWpEdXpQN0xxR29hcVlYSG9pV29HSkJx?=
 =?utf-8?B?NUM1a095K3NhaFNWYzZtM3FZa1M4NkxJQkZhMkY5cENBMGp1YytjVDhibTlm?=
 =?utf-8?B?bUVJTmhvUEQxY3l5N0lBWElsendrNEpENkFzM200OTIzeG5MbmZ0VGVaMytK?=
 =?utf-8?B?dTZYUTZQL0toUkVzRG5JZktPdkxtK2xjeXRhbStkcjRRbmI1NmgvUUoxUEVQ?=
 =?utf-8?B?SmlXdnlOYVZSS0N1bFVHY1hwUDRpR2ZuM1dWTGJHUHNNYXUyY3Y0ckNhSnhM?=
 =?utf-8?B?TURtQ2QrSS93eERjR0ZKcHN1ejFIamtQS1ZYOFhIdjFtWE5sMnBQUytWNENW?=
 =?utf-8?B?UHRodHZqbzllaklrcUcxTlV2eDh2Sk83R0h3SWxvc0RqTlZoYnFvOXVqT0Ju?=
 =?utf-8?B?KzErMzhwbWlEZENKZytVL3YraG9sdzRjSFZzWjZPOUpuR1N6U2IyT2I4a1dU?=
 =?utf-8?B?YTRXenM1L094ZndoQk1aMVlYcWpXZ29DM3lwUWNaSnY5ODJGRzEwNEVLT0lh?=
 =?utf-8?B?VG0yUHFUdTFkZ0w2RFpwRUF6VXlUWVFldXdsWk4wSFFmTGJmMnh2TjVldVM4?=
 =?utf-8?B?TWxQRTg2NXNZQVVsbzM4Q2cwWHczZ0phYXJuUTJaVkViVktoL3FIc0FHSEtw?=
 =?utf-8?B?TGF1S0JLMTBhdWlzR2hwWE8xTHlJNUxDdDJJWjB0U0laVE9TemRRVEx4S0VU?=
 =?utf-8?B?YkNrVHBiQzdSZDBGYmJiaklNQmREL0s2bXF2UDArMTQ2dzk5YTBFb3JJb25F?=
 =?utf-8?B?ZEk4VXBUZ2dRYStobFNNVkNrMHFIdDUvZHRnbmVxYlJyWFRJOGpvL0IwY2dJ?=
 =?utf-8?B?akl6UW5zcGxUeGtRQlNablE2WThQd050b3FlTlViNzVNYjNOSHl4RDZuNzVx?=
 =?utf-8?B?anpOUmNBM1RtNC9yYi9pMUlRdkNJV0ljWHorWUZ6bDQxcWlCdlFvZGRFbFNk?=
 =?utf-8?B?SDcxTHJraUY3WDNHREhkS1dzZ0d0NHNjYVg1S3V2ajRwbStCU0M4dkxhb3Yv?=
 =?utf-8?B?djRwVWhRa1NUOXg4eUUxVitaREJSd1BkYngzdnpycWJOcjg2anZ3L3M0WkNP?=
 =?utf-8?B?YWRib1RsQW1WRUJCcldzVlhBbStJWXFmTTQyNTZLU0RlcDNWVEhSQkJyeGs0?=
 =?utf-8?B?bk5xWkNTcHkrQS9ITlBuNGxnUGFyZytrOWFsRVNIMUJ4YWtLM2N2czdHQTB6?=
 =?utf-8?B?TG5tVFBOY2lxYVBmYitwNGM1MEJ5MXRhRGhQSVBRcEh5YnFHeW9oL1QzaE4z?=
 =?utf-8?B?L0FlWXl2T0tWSDROSGhqRmVvRTdnbEJVS0NPejlpYVdwNUhRYU1Oc0RSUncr?=
 =?utf-8?B?RGFCYTVQS1VqaHo0SWhLMlAycklqRlZIclhXdFhjZ1h0R2RUbW82THdhcVh5?=
 =?utf-8?B?UWpKNGZTWWloUlJ5MTMxRGhMZU9xY21JdDBXb2xKSW9EVmpkanFSS0ZnR1hN?=
 =?utf-8?B?VFliOGNtYmhTZmo3TGw4bkorQVJLcksySityZS9FS25WWC9mZkcrL1RJemN2?=
 =?utf-8?B?UnpsSit5TEViaTJlaDlRUkJZSTdzcEdCbWtJL09oL0wvcTBSUFJHaFo4Z3Mv?=
 =?utf-8?B?OHJGbkVPVlNlQW10andFYk44aCtTQ1RSeFo4QmtCY0ErZVd1Zk4wNFVvMlRF?=
 =?utf-8?B?b0kwOXZDYkFtTHpJUG9BLzZ5bUNQdUJZSjlQeUJOeTcxdWNORlRDYkZuaHIv?=
 =?utf-8?B?Q2U0cDdXR1ptdkZsaHYxUGFJb0Y5clVCdkUrdjdoRGlpQ3lKL0VrVEJJVUhy?=
 =?utf-8?B?OUlmc3p6SXJjZitqb2xlVFVQQjEyNVkwWDhYMjNvSUN3NWgzTjBXb1pDaUJD?=
 =?utf-8?B?TGVkaWJqWlFhWm42UFdiQ3FIcjRnWmZ3a1ZWd3UyV1JaZHFVMkVsaUF2ajZY?=
 =?utf-8?B?Yy9ycEVzUitUbWhFbzFTVFBpRVA4bFhWUGU0elMydk02UDBjZ1J1ME01d0lp?=
 =?utf-8?B?MkQwekpEN1E2KzVob2ozdlFISjRGRFdjTEhOcytMTXZaWU1Ed1UxSzUycGZx?=
 =?utf-8?B?OXAzbnQyNWNuU0RiaGgweWRDazZtK3VndWpsUlJWb0lLTG01VTNJL2VQMjg0?=
 =?utf-8?B?R3F3Rm9rWUU0eXJscnRDTUJMVmRTM1pzbTFjS1Azd0dvUHo1eTZBM2ZKYnll?=
 =?utf-8?Q?j19s7jIl6+qdjg1colxVwi7y3?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FCC7F59694F2EE4C87C31EB75A91B408@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb80bc0-af0e-48b7-f1d1-08dcb60a35ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2024 11:23:35.0104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y4OKPIItl2MdHnEk0Vry6lVuW9WRyxtUm0bRUR3kgte/pLFQG0RpYyI42C211nfKkirESxicaTvlR1mnYSJfsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8776
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTA1IGF0IDIwOjQzIC0wNzAwLCBXaWxsaWFtcywgRGFuIEogd3JvdGU6
DQo+IEthaSBIdWFuZyB3cm90ZToNCj4gPiBUaGUgb2xkIHZlcnNpb25zIG9mICJJbnRlbCBURFgg
TW9kdWxlIHYxLjUgQUJJIFNwZWNpZmljYXRpb24iIGNvbnRhaW4NCj4gPiB0aGUgZGVmaW5pdGlv
bnMgb2YgYWxsIGdsb2JhbCBtZXRhZGF0YSBmaWVsZCBJRHMgZGlyZWN0bHkgaW4gYSB0YWJsZS4N
Cj4gPiANCj4gPiBIb3dldmVyLCB0aGUgbGF0ZXN0IHNwZWMgbW92ZXMgdGhvc2UgZGVmaW5pdGlv
bnMgdG8gYSBkZWRpY2F0ZWQNCj4gPiAnZ2xvYmFsX21ldGFkYXRhLmpzb24nIGZpbGUgYXMgcGFy
dCBvZiBhIG5ldyAoc2VwYXJhdGUpICJJbnRlbCBURFgNCj4gPiBNb2R1bGUgdjEuNSBBQkkgZGVm
aW5pdGlvbnMiIFsxXS4NCj4gPiANCj4gPiBVcGRhdGUgdGhlIGNvbW1lbnQgdG8gcmVmbGVjdCB0
aGlzLg0KPiA+IA0KPiA+IFsxXTogaHR0cHM6Ly9jZHJkdjIuaW50ZWwuY29tL3YxL2RsL2dldENv
bnRlbnQvNzk1MzgxDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVh
bmdAaW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+IA0KPiA+IHYxIC0+IHYyOg0KPiA+ICAtIE5ldyBw
YXRjaCB0byBmaXggYSBjb21tZW50IHNwb3R0ZWQgYnkgTmlrb2xheS4NCj4gPiANCj4gPiAtLS0N
Cj4gPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIGIvYXJjaC94ODYvdmlydC92bXgvdGR4L3Rk
eC5oDQo+ID4gaW5kZXggZmRiODc5ZWY2YzQ1Li40ZTQzY2VjMTk5MTcgMTAwNjQ0DQo+ID4gLS0t
IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oDQo+ID4gKysrIGIvYXJjaC94ODYvdmlydC92
bXgvdGR4L3RkeC5oDQo+ID4gQEAgLTI5LDcgKzI5LDcgQEANCj4gPiAgLyoNCj4gPiAgICogR2xv
YmFsIHNjb3BlIG1ldGFkYXRhIGZpZWxkIElELg0KPiA+ICAgKg0KPiA+IC0gKiBTZWUgVGFibGUg
Ikdsb2JhbCBTY29wZSBNZXRhZGF0YSIsIFREWCBtb2R1bGUgMS41IEFCSSBzcGVjLg0KPiA+ICsg
KiBTZWUgdGhlICJnbG9iYWxfbWV0YWRhdGEuanNvbiIgaW4gdGhlICJURFggMS41IEFCSSBkZWZp
bml0aW9ucyIuDQo+ID4gICAqLw0KPiA+ICAjZGVmaW5lIE1EX0ZJRUxEX0lEX01BWF9URE1SUwkJ
CTB4OTEwMDAwMDEwMDAwMDAwOFVMTA0KPiA+ICAjZGVmaW5lIE1EX0ZJRUxEX0lEX01BWF9SRVNF
UlZFRF9QRVJfVERNUgkweDkxMDAwMDAxMDAwMDAwMDlVTEwNCj4gDQo+IEdpdmVuIHRoaXMgaXMg
SlNPTiBhbnkgcGxhbiB0byBqdXN0IGNoZWNrLWluICJnbG9iYWxfbWV0YWRhdGEuanNvbiINCj4g
c29tZXdoZXJlIGluIHRvb2xzLyB3aXRoIGEgc2NyaXB0IHRoYXQgcXVlcmllcyBmb3IgYSBzZXQg
b2YgZmllbGRzIGFuZA0KPiBzcGl0cyB0aGVtIG91dCBpbnRvIGEgTGludXggZGF0YSBzdHJ1Y3R1
cmUgKyBzZXQgb2YgVERfU1lTSU5GT18qX01BUCgpDQo+IGNhbGxzPyBUaGVuIG5vIGZ1dHVyZSBy
ZXZpZXcgYmFuZHdpZHRoIG5lZWRzIHRvIGJlIHNwZW50IG9uIG1hbnVhbGx5DQo+IGNoZWNraW5n
IG9mZnNldHMgbmFtZXMgYW5kIHZhbHVlcywgdGhleSB3aWxsIGp1c3QgYmUgcHVsbGVkIGZyb20g
dGhlDQo+IHNjcmlwdC4NCg0KVGhpcyBzZWVtcyBhIGdvb2QgaWRlYS4gIEknbGwgYWRkIHRoaXMg
dG8gbXkgVE9ETyBsaXN0IGFuZCBldmFsdWF0ZSBpdA0KZmlyc3QuDQoNCk9uZSBtaW5vciBpc3N1
ZSBpcyBzb21lIG1ldGFkYXRhIGZpZWxkcyBtYXkgbmVlZCBzcGVjaWFsIGhhbmRsaW5nLiAgRS5n
LiwNCk1BWF9WQ1BVU19QRVJfVEQgKHdoaWNoIGlzIHUxNikgbWF5IG5vdCBiZSBzdXBwb3J0ZWQg
Ynkgc29tZSBvbGQgVERYDQptb2R1bGVzLCBidXQgdGhpcyBpc24ndCBhbiBlcnJvciBiZWNhdXNl
IHdlIGNhbiBqdXN0IHRyZWF0cyBpdCBhcw0KVTE2X01BWC4NCg==

