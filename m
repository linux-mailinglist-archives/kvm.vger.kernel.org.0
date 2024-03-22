Return-Path: <kvm+bounces-12465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDAD78865C7
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 05:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CE691F2486C
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 04:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFE638C09;
	Fri, 22 Mar 2024 04:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fyssSIkT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A306FB2;
	Fri, 22 Mar 2024 04:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711082008; cv=fail; b=u3kD+7UvuCdyKfz5qrTK6l84OyKaYtcO32+pbjYTuuRag5WrfJ20gU4rInLee9d6ppwpigcd+lbg5IsM7+nPHLSIrNhN3pTug5vmiZw71xIzh0iJsVAqPq9zUZTddIE5NWWLhEMTbQtB0NXS1gVcqGmfiOM3yBROaYRfYHqPJBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711082008; c=relaxed/simple;
	bh=TZeZWgL0AHPEKYYhmGTPQVW0eVx7iurp4zeOg1ulyT8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LfDdtH0tiygheNjqgMSN6K1vy+0VZPFvWKiejMxgItNO4rSGpf2EaxK1K8WXEuuBMk8wW9iDq7PT+cUfrdJDyJJjYMWyZDsKfzP/ZaBMlyWkQiFaZf7wfRYzjCATVkp5vRV7KjQHfb0ZzZyRVjnVrwqalRqatRyrMSAfKDmEmjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fyssSIkT; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711082007; x=1742618007;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TZeZWgL0AHPEKYYhmGTPQVW0eVx7iurp4zeOg1ulyT8=;
  b=fyssSIkT6oq1waIGvpDy0nud8fHs/ZzoSKgPmqMowfU7ntHL/kPGvjZk
   HYeWSFThcyuVjlZQLnCNV9+kpvBrEtMnSQR5D7WLaCLieGGZksOAFLtFQ
   N4I062HeZ/90vcu+xzNvfByAZL3sFt0CZ++3mi6fKi/57k4NEZh83hw3j
   HiQ+nyCUpmI92+QTQyT7BMqpn0MujB0l8Cof6jvtQgDf2M+f+hS8neCn1
   BojGqvo6ieTmxcWT+P+S8Yt2EpiXQltLF8OP8M9yeJQicJKxZJie4+qG2
   550lMs6cQFdJMUJW/aObjWHn01ftPodXmlr0VNkDlFTOcLNgo1gkMHCcQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6007261"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="6007261"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 21:33:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="19329317"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 21:33:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 21:33:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 21:33:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 21:33:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbSudzuLK3pVsOYag/h+tgBWNP6PHp2DDKlCpjFprgJXVAVDUC9alfGV8NwX8eotfwFwW05KN78362+3WmJgfkA5Gdn7HJkFiA770VZq3zluqkL6VqxCG9hUGIilQPBrlyIwVOrsFV3EW+GH79vV944YfCLVgaG7eiwPq31tevUvBHOmG6JAs9GfnL9Rv9iFIjOMX7ZHC9XKLM3idjzettEHQ7hgOXDAmocbdJOa/AEl7liu+2zt3COGciDlwAvdEJykApQWdFxBvzmTyGH9PVxc3bePi6liK6QPD3YQPBJqJTZ9lWIF1XVQ5Op866GXWKVxEtPiunnKq1Bhnva1xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZeZWgL0AHPEKYYhmGTPQVW0eVx7iurp4zeOg1ulyT8=;
 b=ny8b15uGWGCzS3u6Vcj4MaCymjfjMP41FkwOTkDGjCjG1z2T2tfqIpqtg7+TxNuF3IEvb2rlcpq55PML0BUVkXp8p/c9Hv3MIdpNJAXkpa7oWxYa0awhCLRdMg5tYEsXsoz4RA7BK3EBbtoKnOiGvPoQFWfLqB4XtfetgzmhPpoPFRjOmSeEWzyHjsoAOPyfs5inQ5QgE1SNcuQ4WmxPQmYALQL9lMEw76+ss5n42HYRm7WTJjRBliR5trPEGqiEvsLIAkdYl205t0nKeWpQoGs52cg7J7DgCiQU4B7IaVN7bCh2+KwvKfImeS2YjKHYCXadRbwH3JSMfyClUTf44g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Fri, 22 Mar
 2024 04:33:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 04:33:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yao, Yuan" <yuan.yao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHaaI25sKFXSTHmB0GBadO6nsPCe7FAvNyAgACPPACAABFQAIABrfYAgABHpgA=
Date: Fri, 22 Mar 2024 04:33:21 +0000
Message-ID: <5f8aaa652cc112fc61b9b13b6d77b998a2461172.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
	 <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>
	 <20240320213600.GI1994522@ls.amr.corp.intel.com>
	 <46638b78-eb75-4ab4-af7e-b3cad0d00d7b@intel.com>
	 <20240322001652.GW1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240322001652.GW1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7272:EE_
x-ms-office365-filtering-correlation-id: a1e1cd61-d8ef-4567-ad24-08dc4a293472
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qJcIlesqf9Vogg50XqjPEFFJBjbMageV0n8UbpIzc3PAaaGOOog2CGmJ7q/GHgbyLjG75EarvMyPumCN5eao6j0CYhPbRj6Mje4v3AzL4lxmQpaK5NWwlDKmrRptNp17xmRK6XgETEQKhY2jRrnILZJFOYmBw4/iNwx5FPTMd1tbZ2jJLs5PxaivjmfRHggUaNMC08knHUb9RgnRA9hX2iZ0bBBknmfrR1vIRNY5r6ANAfvgCTpwCPihKp2avfR6jjKA+BfsEncGEWwCKA70slQ3a8VtkkiLiFvt2QrEzx36tDkPpvTy8UxaH5EjOoj2ukps6oXWI4sdEhHfSiDMVthJSLDcgBVxcr/kOGmjMnOjNvM/+ACr/dA7hogk+I/1CZGJI7wQqnaonR5no54Mxn8UTh48SGNUecdqWeHDhe/b7tk9YgevnJjUQWeH70GsYIXqJ1BiT+5yiIGuPR5XMDlvK2w2eUkihNGo6fFTk06wn9HB9OvFPiyuFw/T1RUWNeQ65YBlbixAkuafuRqmlLw9dYLf/kt2N+JWu/pdgqqBkSFMit+oo07YSaoarkCZzjqy40eBGedYrjCbgsyLPSEJVBkQpFpGzlf1L1ud5OrIs8/7ky5hu0MkIR+QWI/Y1skQS9S2v0wpksW6WxchqUqpQeyOjI+B7RlXKwfDiChPGKDNBOtJAokQT1IHqOqnejxpwi+eX0T+jUvVGyQrFZklkBQ3o2zTE6ycVN36GfU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L01kUUNqS1pCMldxZmRMWGorT045YWFFNzBDMmJTVDA2bld5RkVMS2MvaE8v?=
 =?utf-8?B?czZmOUlpeVQ4MEZUR2FHSjBXZjNBeC9rZW1EWk95ZWZPeFhTbUkrMVpIbHd2?=
 =?utf-8?B?aUtzUVU2eEtxekM3R2hXU3YyYmQzODhHbm9iUVY4a1JRSjR2NFhGdlN2NEcz?=
 =?utf-8?B?L2VwR2dIdGtaWE9jazlRYlFHbnJybDg1TjdraFdwTnpwWW1rR2QvRnNhb0hr?=
 =?utf-8?B?cnJoWmFXWEdPcU9QemtRc3FFQXY5djNWSTNGRzFSdGR2U1FoQVAyWnJ0QlpR?=
 =?utf-8?B?aVVEMnlCUkxUc3ZQTzdqM3ordjYyMmloUVNTNEVyK2k0bmRQSm10amhWbEZu?=
 =?utf-8?B?ZlI3SW1hNEhYNjY4NjJ4RTNrTkNXbkY4WFFLRldBRWU5OWxtUmdNa2xHcDY4?=
 =?utf-8?B?M3V4MlpHMFYrUG11ZDRhSDZYYU03cm5PTDhCNUt3ZmEzcmg3aStXdW5mZHQ4?=
 =?utf-8?B?eHRjVVAvRk1ha2dxYUdwZ1VZWGRMTjNoa004alRQVzNCdlF3MUM4MmQxUEl1?=
 =?utf-8?B?RE40NU5KSGZwWERBMDd4NzNKWnpyQ0hqaGhra05iZ0dVTnlaZll0bUJNUTUz?=
 =?utf-8?B?UGpMWkp3K2tpdG5WT1Z0SXoxZVNjYjc3OThqdHVtS0V6WjRhb1hXQWxBZVdH?=
 =?utf-8?B?cGZpdkhkbkpHbEw5N2UzRUd6TW5WK1kxK0QyZGt6eG9GV04yaGdiY2tWU3o5?=
 =?utf-8?B?OTRLQWRSaExvSDMrOXlGRUVuU0FFVGtlRExtdllXN3k2aG1hdVFENzkxcVVz?=
 =?utf-8?B?MjJCb3pScEdka1VJWUtVQVBjQkVjSVpoWVY1aWVmenBzSVVNTXBpeE53d3dD?=
 =?utf-8?B?V1VjQVZIVjFhQi8vMW9wRDEwR2hqYmllS2F0OHJQalU4bEQ1aXJ4d2g3WjBW?=
 =?utf-8?B?aW9hZU9mNkpQNkVCWWx5TENSUGluRmlBUXZrTFMyYUJUYS9BeUJCUy81U2dH?=
 =?utf-8?B?ZWkrZFREOVhEWjNUVGtyNHFtYi9xTVJiUFYrTVVvL3l4WmZsV3pXWkVtVG1R?=
 =?utf-8?B?NjJxU0dTb1JYcXhFYmtUZ3RnRklhT2ZTemJ1eTVWYlJmQ0VJSFpjbXNBK2lR?=
 =?utf-8?B?TmZZNkxaZWNtKzB0RTcrRkJpa2o2L3AwVnhqanNML2lnSkJEczljZTEvYmVl?=
 =?utf-8?B?YXVmUkk4bnJFaTNyYk1QbC9jdXd5S2V2aGJocFBGQWUwUnBpTkZrT3NWYlZ6?=
 =?utf-8?B?ZGM4QnQvcStHblZYOGVwTktXQ29HMWx2NExsSzlRQjBqYXZhOXdaMkdNUWR5?=
 =?utf-8?B?TU5XRUovdVh0OEdOM2xTRC8zWDJSZXhTSFE4RFB5Y3BuNUVwbXVWNWVTOVJs?=
 =?utf-8?B?UlYwOGw3aHFYekZZbHRnSEJndmVuUXF3R0ZjVjRIZ294OVhuRGcvMzlCbFNv?=
 =?utf-8?B?VXNCbHlTZmJrY2s2eGl2b3BxV3lLRWM1eTVJMElSNjcxNXFScEFvYnJDVHBC?=
 =?utf-8?B?ZnIzL01OSStYbWxqbm91MWdQbWpIS1ZNS3NacC9CNHRodU5WTklHejNTQk0y?=
 =?utf-8?B?VEhiMjZ1WW1XMkcrS3VENVRjMEpNZmZrNThQU2NvUUJ1aHlDWVhQWDQrbmJT?=
 =?utf-8?B?dFV1THU1WmJtN3JVTVViZTdLbit6bmR3M05kVWZzRWMrdnNnWVpnSHYvS1dX?=
 =?utf-8?B?SElLZHhsdXVBalFGTjhpdGxjQUxncm13SHVSNVdzNitUOXFUV0tXS1lwUTRQ?=
 =?utf-8?B?d1JFMC9pT2NjRGhEWGZ4VmxRMnU5bXJmRUZ2VUN5ZFFQTDdnbElVb0t3YXJh?=
 =?utf-8?B?STUyWWRqVVRmTzk0NktiTkU3RWpZcCt5dllvQ01TVG9DT3MxUHEzQXNKTTI3?=
 =?utf-8?B?VHQrM0JVRGRubk1PZjBTTTRwTzF3ZTJtQ1QvaGdDNkxXR000Q2JWWmtDS2Q0?=
 =?utf-8?B?S2d2SG5UTzQvcFdPd3Z5cTVVcXdKVjl2MlFoNHVzcURhOHkwUjNtSlc0cVlp?=
 =?utf-8?B?MWlibElYQ0t4Sm1TeUdKMDBjZ2FnbEt3MmtKaGduNkxsNHBrdjExcmRmanc2?=
 =?utf-8?B?NkYvM1FhSHExRTE5cCtkdmFIQkc0TnZBenlBWTFTSXVoT3dTUFplWDRsNlFV?=
 =?utf-8?B?MlhlYUcrNW5JVmhUZFI2Y1lhWnVadytHTVpTdXpSbE5ZSXNzZjZCMjUxZGs1?=
 =?utf-8?B?bW9oM0pVMUU0eWF0ZDg3NDB6MXR4bytqMGkvK3h3blpYU2hOMlZ6QVNsZlIx?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BDAD6F12B915D45BDA634F9B5891254@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1e1cd61-d8ef-4567-ad24-08dc4a293472
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 04:33:21.3433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mrc1ix3NopybbrdU7A7JeprV+yQS8ia3K31Ik+qxGztClolUf4e4oM9Ymc9kg1WWpsokokOTHNeIZRdqjbujEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com

PiA+IA0KPiA+IFNvIGhvdyBhYm91dCB3ZSBoYXZlIHNvbWUgbWFjcm9zOg0KPiA+IA0KPiA+IHN0
YXRpYyBpbmxpbmUgYm9vbCBpc19zZWFtY2FsbF9lcnJfa2VybmVsX2RlZmluZWQodTY0IGVycikN
Cj4gPiB7DQo+ID4gCXJldHVybiBlcnIgJiBURFhfU1dfRVJST1I7DQo+ID4gfQ0KPiA+IA0KPiA+
ICNkZWZpbmUgVERYX0tWTV9TRUFNQ0FMTChfa3ZtLCBfc2VhbWNhbGxfZnVuYywgX2ZuLCBfYXJn
cykJXA0KPiA+IAkoewkJCQlcDQo+ID4gCQl1NjQgX3JldCA9IF9zZWFtY2FsbF9mdW5jKF9mbiwg
X2FyZ3MpOw0KPiA+IAkJS1ZNX0JVR19PTihfa3ZtLCBpc19zZWFtY2FsbF9lcnJfa2VybmVsX2Rl
ZmluZWQoX3JldCkpOw0KPiA+IAkJX3JldDsNCj4gPiAJfSkNCj4gDQo+IEFzIHdlIGNhbiBtb3Zl
IG91dCBLVk1fQlVHX09OKCkgdG8gdGhlIGNhbGwgc2l0ZSwgd2UgY2FuIHNpbXBseSBoYXZlDQo+
IHNlYW1jYWxsKCkgb3Igc2VhbWNhbGxfcmV0KCkuDQo+IFRoZSBjYWxsIHNpdGUgaGFzIHRvIGNo
ZWNrIGVycm9yLiB3aGV0aGVyIGl0IGlzIFREWF9TV19FUlJPUiBvciBub3QuDQo+IEFuZCBpZiBp
dCBoaXQgdGhlIHVuZXhwZWN0ZWQgZXJyb3IsIGl0IHdpbGwgbWFyayB0aGUgZ3Vlc3QgYnVnZ2Vk
Lg0KDQpIb3cgbWFueSBjYWxsIHNpdGVzIGFyZSB3ZSB0YWxraW5nIGFib3V0Pw0KDQpJIHRoaW5r
IGhhbmRsaW5nIEtWTV9CVUdfT04oKSBpbiBtYWNybyBzaG91bGQgYmUgYWJsZSB0byBlbGltaW5h
dGUgYnVuY2ggb2YNCmluZGl2aWR1YWwgS1ZNX0JVR19PTigpcyBpbiB0aGVzZSBjYWxsIHNpdGVz
Pw0KDQo+IA0KPiANCj4gPiAjZGVmaW5lIHRkeF9rdm1fc2VhbWNhbGwoX2t2bSwgX2ZuLCBfYXJn
cykJXA0KPiA+IAlURFhfS1ZNX1NFQU1DQUxMKF9rdm0sIHNlYW1jYWxsLCBfZm4sIF9hcmdzKQ0K
PiA+IA0KPiA+ICNkZWZpbmUgdGR4X2t2bV9zZWFtY2FsbF9yZXQoX2t2bSwgX2ZuLCBfYXJncykJ
XA0KPiA+IAlURFhfS1ZNX1NFQU1DQUxMKF9rdm0sIHNlYW1jYWxsX3JldCwgX2ZuLCBfYXJncykN
Cj4gPiANCj4gPiAjZGVmaW5lIHRkeF9rdm1fc2VhbWNhbGxfc2F2ZWRfcmV0KF9rdm0sIF9mbiwg
X2FyZ3MpCVwNCj4gPiAJVERYX0tWTV9TRUFNQ0FMTChfa3ZtLCBzZWFtY2FsbF9zYXZlZF9yZXQs
IF9mbiwgX2FyZ3MpDQo+ID4gDQo+ID4gVGhpcyBpcyBjb25zaXN0ZW50IHdpdGggd2hhdCB3ZSBo
YXZlIGluIFREWCBob3N0IGNvZGUsIGFuZCB0aGlzIGhhbmRsZXMNCj4gPiBOT19FTlRST1BZIGVy
cm9yIGludGVybmFsbHkuDQo+ID4gDQo+ID4gDQoNClsuLi5dDQoNCj4gPiANCj4gPiA+IEJlY2F1
c2Ugb25seSBUREguTU5HLkNSRUFURSgpIGFuZCBUREguTU5HLkFERENYKCkgY2FuIHJldHVybiBU
RFhfUk5EX05PX0VOVFJPUFksID4gd2UgY2FuIHVzZSBfX3NlYW1jYWxsKCkuICBUaGUgVERYIHNw
ZWMgZG9lc24ndCBndWFyYW50ZWUgc3VjaCBlcnJvciBjb2RlDQo+ID4gPiBjb252ZW50aW9uLiAg
SXQncyB2ZXJ5IHVubGlrZWx5LCB0aG91Z2guDQo+ID4gDQo+ID4gSSBkb24ndCBxdWl0ZSBmb2xs
b3cgdGhlICJjb252ZW50aW9uIiBwYXJ0LiAgQ2FuIHlvdSBlbGFib3JhdGU/DQo+ID4gDQo+ID4g
Tk9fRU5UUk9QWSBpcyBhbHJlYWR5IGhhbmRsZWQgaW4gc2VhbWNhbGwoKSB2YXJpYW50cy4gIENh
biB3ZSBqdXN0IHVzZSB0aGVtDQo+ID4gZGlyZWN0bHk/DQo+IA0KPiBJIGludGVuZGVkIGZvciBi
YWQgY29kZSBnZW5lcmF0aW9uLiAgSWYgdGhlIGxvb3Agb24gTk9fRU5UUlkgZXJyb3IgaGFybXMg
dGhlDQo+IGNvZGUgZ2VuZXJhdGlvbiwgd2UgbWlnaHQgYmUgYWJsZSB0byB1c2UgX19zZWFtY2Fs
bCgpIG9yIF9fc2VhbWNhbGxfcmV0KCkNCj4gaW5zdGVhZCBvZiBzZWFtY2FsbCgpLCBzZWFtY2Fs
bF9yZXQoKS4NCg0KVGhpcyBkb2Vzbid0IG1ha2Ugc2Vuc2UgdG8gbWUuDQoNCkZpcnN0bHksIHlv
dSBoYXZlIHRvICpwcm92ZSogdGhlIGxvb3AgZ2VuZXJhdGVzIHdvcnNlIGNvZGUuDQoNClNlY29u
ZGx5LCBpZiBpdCBkb2VzIGdlbmVyYXRlIHdvcnNlIGNvZGUsIGFuZCB3ZSBjYXJlIGFib3V0IGl0
LCB3ZSBzaG91bGQgZml4IGl0DQppbiB0aGUgaG9zdCBzZWFtY2FsbCgpIGNvZGUuICBObz8NCg0K

