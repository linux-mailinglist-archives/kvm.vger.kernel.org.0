Return-Path: <kvm+bounces-60038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BC37BDB8F2
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 105EB4283EE
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7715A30CDBB;
	Tue, 14 Oct 2025 22:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="POn6b5gU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E052EA73B
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 22:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479450; cv=fail; b=PUJfG0UwUuRLK54eWPYiTqEPRVsSltM+F1zuZ7b2DqcL9NqdSTxB0b/IZ/lNeSRK7EBs9xczg77s4AQcKKIqxRd0zafbQA2RGfu0owqIJhh9ItN9+fZa1yUH/RY2a6hFH0EDGAKb84M3KEyeH24YbpTRKC9h1gnXmeVQycY+ERU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479450; c=relaxed/simple;
	bh=iIsooa+jpR4wXU/YVa4MNdwN1wy1lZbERP4qQtDsKk8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TIJLCqY4Z7Ol++tRrsdbKaIdKs1Xx8S4G2TVOJqMP00m9I0Zo6zXEUL51OGCLsEtaTrznVc9K/CYT0R1Qz84Ia4hMWlBdH8TK3PZwpeavHJw0bFLc1dokH5XEPww58rKSytFBpAuYcYbwmB1NJuW2BKGdbFMvoA+uUNcEU40Mvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=POn6b5gU; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760479449; x=1792015449;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iIsooa+jpR4wXU/YVa4MNdwN1wy1lZbERP4qQtDsKk8=;
  b=POn6b5gU88ukG5dO2/BYGzccA4Z3/z0mysCyvgt71GVrs8uD9oEvTXR1
   8tv2qw6TAYTh/qSJNqCYYqF0VTXuwoSqOEjqJCRW1wT1m6auhLGJp3Wcx
   tjQ6cnXWpruKe3U2BsoSs1A2usJMdXZuXDgxbCn1Gml2BA11o/pEkJxHW
   Vn0MnJ5sn/wdQ+Elyf8cQHd9CNfTb62kQgwAOJhee4J8AZJXbGpCADGtD
   72qXc6R8hbUAdZUyVLYypoy2wdJFDIdNVZV6pGxCBzEzeZLtNe3fP1/x9
   4ZU0q+SUDx0+xwNBIOo//aWfJb33GS1RUBuvkO5KxAyB0CYPJ4z4Qzo+Y
   A==;
X-CSE-ConnectionGUID: ndQ4Onr9Qp2C2ayNhcguNg==
X-CSE-MsgGUID: y0sYwqMTSQKdNiDj66ahrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="72920788"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="72920788"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 15:04:07 -0700
X-CSE-ConnectionGUID: 31srJ0yfSlOygoosnGgLNA==
X-CSE-MsgGUID: 6IkADhjmS1STHF3CeFqRfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="181216287"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 15:04:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 15:04:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 15:04:05 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.2) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 15:04:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ef5Q3W6XPLS9REYzjZ2YCd/EpOli/kdAGHkgpAAF2xSY8nK+3veOAw8j0PEdrheqy5kvLE4fwgVgRX8W+nynnhHWGg1Kl3GU2qEO+HkAJe7Boo3B79ERikKX/SM06KwHhYmgunzkBAXUkg5kif89QMFXPR4zVFzX/eeUbv2zkg802SYCv5veeHcC4VbU+GUIMpSjuT9KDjIztKv7b4vWIgJl2pmEG99DXLfLF8CDB+zreXiJnQm5W3XzcPAgcdWWj1YERFGSSmVe9aEur2YksqKx6K26sXZkKTuBXg9v1EOyHNkY57nPiP0JQytzlK+R2hvrwhm8Zl8Wsa9gVKKY0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iIsooa+jpR4wXU/YVa4MNdwN1wy1lZbERP4qQtDsKk8=;
 b=TD/Ox7Pa9ymMTJyC8baSAf8TinENoYNmKk12pxD7i2itwrcb8yrge17ISXv5TvkueGAk8b4oW+sJu3tdoM5BiNWArKdZYS5qjPqAJrHqXO1z+mQbQXCWRAS5daxrEEdwBAa5YxOd+YkRIcwPD4JppgYXUXtCEKH//55YCVS9H8kQ6kq/QphN81lQovZblp1/k0E6lVIpXocCa/qQKhYsgEuVb0X7OkTBcQZ6CXW/2ACnYMocUjUL+13UBj0aGHCzsGeYKaVGuXT2d00YGfOA4sX1ZiEVMv5n7v+ngeXCfIcowSZh4mu3Z3dF7yiOg7Zptuhbs67d8/PNyfgoo0Xwkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB5012.namprd11.prod.outlook.com (2603:10b6:303:90::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 22:04:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 22:04:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 1/7] KVM: x86: Carve out PML flush routine
Thread-Topic: [PATCH v4 1/7] KVM: x86: Carve out PML flush routine
Thread-Index: AQHcPAo/xEqiO5NKG0KpiJqF3Vm5crTCNM2A
Date: Tue, 14 Oct 2025 22:04:02 +0000
Message-ID: <77d07401b9bf6bc6b10c1eda7c09d3e8a64debfe.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-2-nikunj@amd.com>
In-Reply-To: <20251013062515.3712430-2-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB5012:EE_
x-ms-office365-filtering-correlation-id: 1484f74f-7b16-4089-b83c-08de0b6d95c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dzNYRGtiTE1UdlZ0SktzVEpTNzMvdmFvOXZ1cnNhdWtPV242WkpOZEY0Z25R?=
 =?utf-8?B?OWthYnZxcDFyMmd3OHVEaGoyUWJFbkJoZEpmZGxydWNWV0FSM1RKdGlJN1VW?=
 =?utf-8?B?Mm9tZGNQQit1YzE0NWw2bkU5SlROS3NmYnRmemJBV3J1L285TjdtQjAyZUt2?=
 =?utf-8?B?RHR1MzNBUVRuS2puUGZld3RWYmVHQVVwcWtFanBkYkd4ZnR2MkVPb1FuUWtl?=
 =?utf-8?B?eTBVbFprZTRrOUJ5ZmowbFpYM2daZ25CSDVKTG1IY0tSUjlPanpMVmxHQlVH?=
 =?utf-8?B?K2x5TlIzdDhKMzVvNTdSTUdqbnRNc3BIMFA2K1NMTWpmSFptcy9TME03T3pJ?=
 =?utf-8?B?YmMzc21aOEFsUm5MVGVjdHpGdmtjdWltdFVxb3YrT0Rac0ZuR0JacTJiMTQ5?=
 =?utf-8?B?OVNUTk8zUHZMeExXUnBURnFmNTBmK3Q1WTdYRHp0dnBJbXZ1UjVPQWxOekFU?=
 =?utf-8?B?ZUx3VUw3dk9DRi9lS0wxbi9mZitGYktYMXlEWXFmdGtVTUZQalF1a0pCdmNp?=
 =?utf-8?B?amdoVDV0eSs3dVk3WWhESFNEZHBsbHBmTFRLZUZmQ3p2OWl6L0l4OExORERS?=
 =?utf-8?B?ZlFUY3RPQURxRitvdUZOaEtGWDVpKzU4TnhVdDBLK1phU0p1WHRhMUxja3FQ?=
 =?utf-8?B?eUxVZTdHNmNnT1VCQmM5c1hRa3F5aGtGVEMyREw0UGZDK2xkUnM2RDBhMEhG?=
 =?utf-8?B?a2xwQm1ROThIaU9paUpuZ3hnMWZtYURWbWxwbExZQmF5Y3JlVGkyamhVS2Rj?=
 =?utf-8?B?RDBJc2tQMUJ3T29rM0FRRVYrcWs1K3doTXpja3lHV1JFRDErVTNJSncxcWN4?=
 =?utf-8?B?ZG5wWkJYTXUrQlpUelN4Q0oyME04WWJkclBnaHNxM3J2dDdqS25GTVFReHpy?=
 =?utf-8?B?ZXFMZDRCMU1FUE1meWNhQ1Bpa2NtbWkvbHp0QjFrdzB1MHg4aExZTThPbTR3?=
 =?utf-8?B?bWxxUnlYZ09QbjlQY2tQSUZqMkkvVXhEVUZnZ2tsNkh0ZEFRUHppc0Rhbi9W?=
 =?utf-8?B?TlhIM2I3U0M5OStqMlUxd1lGUHFQYUtjd2lBTlR4TWdrMWhXM2VwMUpyTUIy?=
 =?utf-8?B?L1VobUI5bjlZT054TEVQOTZ2c0liRXh1NTdlNmRFcVJGNUhibGhBSkRncnRs?=
 =?utf-8?B?dDNWVkQwek5kb0hPbDBkM1pJclhaY1JKWmZtL3pnL29aY0ZIWHpvTjRKZFlV?=
 =?utf-8?B?bUhzKzNtYnhWT09DcmJpVVN2M0JmQThHWjZIL0wzb0VZZ2Q1S3RabURPNGJh?=
 =?utf-8?B?cnRGeHNVQ1Z4WXN5MXlWUS9kdVRSalBEZnNnNkRrT3BZU0M1ZnBSbGJhbTc4?=
 =?utf-8?B?WW5yVEhmQTBsNE16QTdCYm96ZzhWSjJPMWZLajZzc2NlSC84TXZJbkZUNDZW?=
 =?utf-8?B?dlhBQzE5MHY0UGIvL2U4N1pTQldGMnpXU0dja2d3M0lqZWhheUVPVDN3UmhQ?=
 =?utf-8?B?dERtSXBrMkw2ckdMdUJzaHk2WkNLREJ6dURqdmlVUzFIZSt0a3QvcjYxUzB2?=
 =?utf-8?B?NW5FdWJJdjBZa3Fza1pYL3RrVXBYMU9kUk42RzJ0aHZhN0xxeTNMWUZmZEdW?=
 =?utf-8?B?Q0EwVVFKeWc4ZGRRUDlCTjhjL2NZb0dDYkdmdXl2QlVqNGMyTzZWUGpBYW01?=
 =?utf-8?B?WkFub0Fad1ptbFZOZ0N4aW9pU1FZU2kzMXBZUGVpckp3SFMvMklKd3VMZURF?=
 =?utf-8?B?RXU3R1VIbnRleTV4QklWT2FWbkR0RXBNWEpyV1V1cE9PekFPMzlnSFFXM2N0?=
 =?utf-8?B?by8wN2h5R2M2R3VyWmxBSW5mSW5Wa21mQTlEeVBJYW05RllURUllMnU4aGNR?=
 =?utf-8?B?MStlYXEra0VkVVpXdWNUZG8rbVhyaGFicVR5SFVpby9TMmxMdmhRZWVpQWRq?=
 =?utf-8?B?ZStpL1VkdjVhWngxQU4yY1dCZHRIcGFNdG9MU1lRU2VHWEFvdVFhc0NNcmtp?=
 =?utf-8?B?Ym1FREdkYWtyU2VWUDFBa293SVUyb2IyVnAyRGRyakVxWkQxSS92cUhJaGIv?=
 =?utf-8?B?Z2hzTXFERXoyTmVFUm93cE5iYzRXVUVtb1hwL1RTMm5FYlpobFlRNWt4NVYy?=
 =?utf-8?Q?gGXTQ2?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T1NQb1Y0R0xqYlp2eHRibWhjazJ4Q2tmaHA5d2RJZlNzR25GK0UvTE5TOXZa?=
 =?utf-8?B?SWExMlFwRHQxWkR4enVCVlczMFpOMmgvenVnbGt1ZW91ZUI2RFhsbHd0c0hR?=
 =?utf-8?B?UmU1ZzBsQ01HWnNUT0Zpemp4NTQ4MS9QNXpBL0NuWGQzN1pJZVNINXVUeCsy?=
 =?utf-8?B?WFljKytSNXpFTFNwSE5Wazk4bDcxdHFYVmkwakRXbTE5UmlwSkszMHNCUnhv?=
 =?utf-8?B?bXAzSlhRVDhjZmNRbFZLajNvNHNhQ09WRnNlVHJIV2hJV2ExVzFhQlZNNWZm?=
 =?utf-8?B?azZEVG85QkN0V3ZacGNNK0lnOFA3ZkJwREVnTlhLWWVGOEV1S2l4VmErY1dN?=
 =?utf-8?B?enN6UW5URTR6ajFJdzlJSUsxQk9FTGNHa2FRaDBtSER2RTlPUkRORXNKWUZ6?=
 =?utf-8?B?Y1ZVRzZpS0srWDR4akk5OUJ6d0pKTVNDVVRXamZaOHZ5ZFhNdTRVZTZLaXBo?=
 =?utf-8?B?TGNuWlBBZkpKSmg2bndiL08wamJvZU14K2Q3Y1pYdEpvZkw0dGYxTGtlVEJP?=
 =?utf-8?B?M01uMEhrNE1Ob3pTWEhKdnBKL2tPNy9QT2tBQjJVbVptaU1QT3BwYU1GT0RE?=
 =?utf-8?B?dk9YQnVCVGoxZEF5RTZPdTljQjVpQWN5MnFoYzc2d3I3RE1XcFlaN2lQQlgx?=
 =?utf-8?B?RHpzUk5obThpcUlNeG9pOGFzZ3NGV3YvbXZvR0lBTko4ZEJEbG92bzBsWG5x?=
 =?utf-8?B?UkFqd2JBZElDVmJkeWlPY1RFSkJNY0VKMVhhZkt1NVY3Y0lWWUlnMEkyUVlm?=
 =?utf-8?B?UnlEYjAyTEd4d1VRbThiQncyUWNxc0FSbHp4RzVQTXFpOGtQb2VoeVVnckRk?=
 =?utf-8?B?dVdBenRZVlV6UWx2S3hVTU5yRVNYd09FeTFTc25jRTF3ZEF5WklkeGpES05D?=
 =?utf-8?B?MmN2bHVnNUVLZG1DTzRuOU4zUVZlQTRXQ2t1Qzk2d0xtbnU3MWt2ZDdKeXFu?=
 =?utf-8?B?eU0zMEY1WFhaT3J4aEdNWDVzNjZTYzc4L1FPcGZnQVRENnBHTFNKZEplaVpW?=
 =?utf-8?B?UURWMmNkSzhjakxHLzFNRkZET09Wa1k3U3crR1NlMU5ndCtSeTdrak5wRFRj?=
 =?utf-8?B?Y0NHeGJzMWpkMzJhb1lzVld5WjhKLzZISkFha0pCQ1A2UkNMeXhFTDVUMGNj?=
 =?utf-8?B?VXpjOFFmYy9PQ053eVpwM2RjQWNDRlB0S0hQUnRIL1p6ZGpWS0U1TE84K0xq?=
 =?utf-8?B?a1lxWHFQek9CajJ6RWVEUVdyUG4rZVBjdVJiQ0hwQkNQL1NBZ3BrOS82MkZN?=
 =?utf-8?B?RVpoczVIb2VkNjJjN2g5WEtkNWVtbTY5RUpHbTlPMTJobUxkY1FzS2VPQktv?=
 =?utf-8?B?ZjhmZHk0N2hmM3lLWWwxcjNvRHd1eG83Y3lyNjRmU3hhQ0lLSVMzUE5DaHhS?=
 =?utf-8?B?THF0WWkwL0VONzVqSGFKSlZPSEdIM2tSWWllQytVbnZSNFRrbFVHa0VOTjlt?=
 =?utf-8?B?ODdtbWRKb2pNamh5K2FxaG1FeTR6a2dncjFXK2JwSFA3ci9LRVRrNEY2WWlV?=
 =?utf-8?B?UzUyLzJPTmtJT0NjMTk1a0hGMnhleTZYWGJ2VTFsM1B6RmxwV2VMRG5EUkpx?=
 =?utf-8?B?VmNOTWNOeXM3MDBmMWJBQkpaMVdUQ2wrWjdvclprSlhuVkExZklTc1hRTDh4?=
 =?utf-8?B?emRhdWdOd0ZjbXNESVRKaGs4eVdQdTBXdzdudDRGeXY4bjhYNUo5aWk2dmpj?=
 =?utf-8?B?cERSak1BL1B4bXc5SkFDSXJ1MTJTMitiODFsQlNFQ1BQeHBWc3oxVEdERXhw?=
 =?utf-8?B?TmlKQ0tSZGVQUXU2RlBjbG1XbExBSVErMVJ2NGFhbjcycFQ0LzIxTVFyMTk3?=
 =?utf-8?B?UVVHYzFLc3FKZVRBNGJNTkphV0hCQjlUSTNMQnFaNlJOSllWUGF3eWRiZHR3?=
 =?utf-8?B?bHNncGczTnlobUM0TVRUYTlGM3FFa3Q5OHg5aHB1NmlUNEVueHVqQk1leVJO?=
 =?utf-8?B?T20vUnBUVTg0cXlJZ1NmT1JBYjRhdzQvQU4zOE9rbTlyV1l6bURVT2EyanpK?=
 =?utf-8?B?Wm14VkNubHhTOHlDTHI4blp5N2liSzJocU9yWGhTNFo5aUNTcjdwd1NGb3dY?=
 =?utf-8?B?em4wUnpQS1ZvSytsL1RuTkdkQU9jaDJ5S2JyeVlKVHFjTEFwNVdGTzV1eVQ1?=
 =?utf-8?Q?PwwP4zz3zX7ldbFseLGUyVbDV?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD5048FA73B3B34A9F20CC8038A90589@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1484f74f-7b16-4089-b83c-08de0b6d95c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 22:04:02.5532
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2nAhJPepIDDKQRPrQTWUZfrFm5Eh3tDofMcoOPN1kPSm/MpP3h9NGvcNy9eCNlZ3RLkLyP/sZYAO+8q9KciqGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5012
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTEzIGF0IDA2OjI1ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gK0VYUE9SVF9TWU1CT0xfR1BMKGt2bV9mbHVzaF9wbWxfYnVmZmVyKTsNCg0KRGl0dG8s
IHBsZWFzZSB1c2UgRVhQT1JUX1NZTUJPTF9GT1JfS1ZNX0lOVEVSTkFMKCkuDQo=

