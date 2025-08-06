Return-Path: <kvm+bounces-54122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA422B1C9D4
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 18:33:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A41CB3B8EE3
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 16:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF2F1299A84;
	Wed,  6 Aug 2025 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RCf+b2lf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B70619AD5C;
	Wed,  6 Aug 2025 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754498014; cv=fail; b=JgLek77AZUMK0nnmF/gCb6n2hhYKyW/bZRTeZuJ1knQV/w0yhzURoMN69/8hdAja1wZPBWwtnTrx3pvwPgoNZDYPV0jbf3X9XJyy6S0TsXk/JtuuQqx7VlOBvLlPWpDC6XNopk4uM4YfMyy3c0hgHasIAcobty4J6gml3DLBtHs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754498014; c=relaxed/simple;
	bh=TUFnqRghqfcP8CREo6Vj6vehBQNoRmhOftmCeCw1W/Y=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=scTvzQHWaQg2d7x7xEJhMTLxb/RNrUm7Eosa5/0Y2s/shX6+cUxTaLukYpbhE7qa5anQFo5PmlhTC6ZooYkhsrTDBcrRh62JUrod/8v8aECg0VrAfJj9S9N2+aDexUuY51D683LTUOAcYRSERFjDFu4VcSbx7b4/IDzj2y6Sh/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RCf+b2lf; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754498012; x=1786034012;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=TUFnqRghqfcP8CREo6Vj6vehBQNoRmhOftmCeCw1W/Y=;
  b=RCf+b2lfZgTNj7J0W6Fcq+CrfhkvrFA9rumVGz5FY5RocMjFCObeIXCq
   cqAfmv4ajUYhF+cx0c32Xu6DlswGr1So7BaI8xbgyAWdGoh1PjFdMgqyq
   X8hWMfx3xHzAyceOzY/M4YjCSGC4UDuwu7pdzSOuoMnXqz3zsnolPpDNZ
   +ZLo6E7HGu6YkU6YUdUxUEFOIBOe0TOUXxjuWUim0rIlHZE2UdB6zP/FH
   hFliSzNy1VxvFATqqahj7Y/IrM6jDmnlobPZhsr8ylFljhlFpVdvH4B6d
   fhQCGJ+rvT7BN+YBeeOoDqeuz21BZq5w1WZMMWiIZB2Gw96dUIVGztoH4
   Q==;
X-CSE-ConnectionGUID: c+eBcj0nSmOyrQWw0JjhnA==
X-CSE-MsgGUID: 9fZJgIORTmO0QR3vzGcxOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="60661008"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="60661008"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 09:33:32 -0700
X-CSE-ConnectionGUID: FEJJUSx+S4ahtLez/4df0A==
X-CSE-MsgGUID: jBeVysY9SHObGNvZd4zmKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="165159005"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 09:33:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 6 Aug 2025 09:33:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 6 Aug 2025 09:33:31 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.79) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 6 Aug 2025 09:33:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NZ5MLi08xlBJXuUZhziEu2Y6rF6EQ8MEfOZzP9GHkIxeVPen6IQ4wEZQ4AiMkO7pkE8mxQquzfa1pgwBiDFhuJmIqDFjK0AJcl8tKY5+WVPbFaVAiwGWk8DhO7HVLRYZiikDpkR9B6WtFPy6g3p543tfwLcQbaHO//TupeVSLNC4tgAyGGFlSTEZeTXb6AaCC+pYJzYjti7T45Hea4pR05TDMqP6VhN6HB+Nyf0NMZ0U+FDkz+2ACBhItnjlp9GIovre3DQ3U5jpWNc1ut9ByoD87LQq1G61T3NoJE0KiKyCuXQ+yla8dSyXuJ+1cSY1wbPQmd3t/9G0YcOPpWKRGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Tjby+qdTVFA72t2zsgIvn63wiElga2I9yG/0wpZLuQ=;
 b=OI0eCa89KZN6AggKk1/kzeHOgynV9EfOzX3R338ojCAzealunFw6irjRgE8gefUdEXxs6JduXr4k9+4L9zfBbNLfZimb2sTIO92cXB0L34OP5KURxt78R4vvZ+H73GZeMuFWi50bu426PXr1e0o6Raj1mJTglDSScwdel+nydXZ/yEB6lSKbGqAP/DjDBz1C32zqEfI2xnIGdNnktEnEIdPgL/jwtB6yfv9sZl74stVFguir5F4InobyylK3Cz1s5k4z3IkdP1NYwaFzgFvpBy7mYEN/PGj3wFoaXLJ5qDB2TNLC+5U/pBRFfphEmvjdu/sO4bVAvtTZ8Doa/h76Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA0PR11MB8334.namprd11.prod.outlook.com (2603:10b6:208:483::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 16:33:29 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%2]) with mapi id 15.20.9009.013; Wed, 6 Aug 2025
 16:33:29 +0000
From: <dan.j.williams@intel.com>
Date: Wed, 6 Aug 2025 09:33:26 -0700
To: Sean Christopherson <seanjc@google.com>, <dan.j.williams@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Chao Gao <chao.gao@intel.com>,
	<linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <kirill.shutemov@intel.com>,
	<dave.hansen@intel.com>, <kai.huang@intel.com>, <isaku.yamahata@intel.com>,
	<elena.reshetova@intel.com>, <rick.p.edgecombe@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	<linux-kernel@vger.kernel.org>
Message-ID: <689383d6c2d9c_55f09100fc@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <aJIL2wR3p1o_N4ZE@google.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-8-chao.gao@intel.com>
 <aIhUVyJVQ+rhRB4r@yilunxu-OptiPlex-7050>
 <688bd9a164334_48e5100f1@dwillia2-xfh.jf.intel.com.notmuch>
 <aIwhUb3z9/cgsMwb@yilunxu-OptiPlex-7050>
 <688cdc169163a_32afb100b3@dwillia2-mobl4.notmuch>
 <aJBamtHaXpeu+ZR6@yilunxu-OptiPlex-7050>
 <68914d8f61c20_55f0910074@dwillia2-xfh.jf.intel.com.notmuch>
 <aJFUspObVxdqInBo@google.com>
 <6891826bbbe79_cff99100f7@dwillia2-xfh.jf.intel.com.notmuch>
 <aJIL2wR3p1o_N4ZE@google.com>
Subject: Re: [RFC PATCH 07/20] x86/virt/tdx: Expose SEAMLDR information via
 sysfs
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:a03:180::48) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA0PR11MB8334:EE_
X-MS-Office365-Filtering-Correlation-Id: 0199baf5-5233-419c-c8d6-08ddd506f97a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UlN4UHFoUkcrb2hmTnpYTi9vSTNhY0FxT1lYVVpTZVhQTHlnSThMNWJtRUdX?=
 =?utf-8?B?VmZ2aG1jQmRBZ1RnQmgyRFl5OHZmRnVkeGZYOERUeE85RzNLTzFkT0l3RWMz?=
 =?utf-8?B?cVpGbTZURERxY0VZY1RCRjBBVC9GeFpyTlFFOVdKRkloTWhUNlFrejBmNnVO?=
 =?utf-8?B?d0NRMUh5RFVLWVhnT3FEbjdkejdnWFQrZDdwOFBWSzNPcFBIY0haZyt5ZFFD?=
 =?utf-8?B?empqNVFMSVFaQjVzMG9YczhGMlQ2TmphbU13bHBaZXcyOXRKSjA5T3hoSlRu?=
 =?utf-8?B?K2w2Q3UzR1pEK0VheXlzTEpKNTB6QTBGU2o0cnN4QnlwQkZSTkx0VXArN2Fx?=
 =?utf-8?B?ZXBiaXJ5cy9FbXViQ082TWZtRkttazFkazFicy82anhpeVpLZWxrbDFaK0Ny?=
 =?utf-8?B?U2luU0gvMlBoM25ULzZLMVhzdGRnbS9KM1Byem5Lb2xvZmxWRDd5VmxuZEd0?=
 =?utf-8?B?WTVjdEFPYWw4RmZ6eFI5blNzRFVJVk9yaEx0VXVjYWNKUzRVbXdUeTBsM3kr?=
 =?utf-8?B?eGhxVlNza01rOXAzWHYvaHUya1ppRFNjYnpBdDNvN1F5UTBxVVlSdnJ2M2ht?=
 =?utf-8?B?V3haY2RqTnpOcXg0SnRKTUVSRXBpYWNnYnJkUjJaQ1dMTGg0RkkxRjdlSVdW?=
 =?utf-8?B?M090KzE5M0dtdGRpbDBSaythU2hFcW1CY0lZemhUTnIvUFR4b2s1cVFvTTFz?=
 =?utf-8?B?VGZXQm9zVEZ5VnZYTDFTWVA3YkdhWUV6MTM0MTY4a3ZTU21lZ3JsNnNWWFNZ?=
 =?utf-8?B?Q2h6VWs5L014VkVSZ2YyajFRUUMrOWJHQjFrcU94ZDBPTEpWTmF6K1FzNEZX?=
 =?utf-8?B?VEkyaXdTMFBrNHpkUjhnMmVkcVJCcGxnWVRKZytJeEhWRzBKaW1qRVZDN2kv?=
 =?utf-8?B?WEppMVJqNVZtQ29jYUhXL0lsM1V0QW5YK3NIS0RWaEo0OFZmZXBmT3RaSHRa?=
 =?utf-8?B?QVErK1dDQjRqVFBuWGdqN2RXSVRHcWN3SXZ5TGpNaElPNWJmYmlBRGdESU1H?=
 =?utf-8?B?aDdSWGd2YUd1NmpodnM4THVhTmM5akZCQ3BjbFBBMHBtZDZCYWZ2YkNHcnZI?=
 =?utf-8?B?VWVBMVFuOElFMlN0U2gyOWtyNERvanVmMmR3MElBVUExZ2VCUUtNVEwrTjFv?=
 =?utf-8?B?d3VHSTlkMmNBaHM0ZGhybUI5UGJFMUVWYTlEWTVzcFptenJPaHNYb3AzajFV?=
 =?utf-8?B?QWxUYmhURlpWRHc3TmsrY0JabEtoNEdLc2QxZ09VNi90Yk1xa1p6bHFqRWNl?=
 =?utf-8?B?TUp1b1U1ZUluVVljMXFzc3NRbFYydW5COWhBYTRJRUp1S054dDFwRnVDSEZl?=
 =?utf-8?B?MmQ2ZTU0VC9GMmpnSHQvK2dkVFVseUZCQi9ud2ZId0F6L1FHUDdTQllucUFs?=
 =?utf-8?B?VTJNNitkV2hBTXlLZk4wK1JlSWlsY1UyNkg2QnlwVUM4bm4vSTAxQlNHWlMr?=
 =?utf-8?B?T3BqZzhVek1YbUJURS81aGxsQmQveE52MGtuT0VUeGRrOUhRUGFuVTNqbEtz?=
 =?utf-8?B?a2dLVnJlbHlUWnJzc2F4WUE0TGU2WHowRmROZGJDRklyVjNzME1FcFh2UDRq?=
 =?utf-8?B?NkdHa1VBWU1TZDNBUUxxSHZTQytqWTdEcGZuM0k1clFKL2VyL0Nwbis0T3NE?=
 =?utf-8?B?M0E0SDQzMVZNeXJBd3c1WS83Wk5pRkZPOXZ1WU9iY2VMRGVMYVVQbDJLcHNk?=
 =?utf-8?B?azJ0SUdsYUlRSUYzN0JYMjhVU2JIby8wTXdPUjc5NVJab0JoeENpZFVYRHUy?=
 =?utf-8?B?OXpPK29hMkFrbk9MK0FLc1JEQmlPSnZIVVI5cVhDR0dLWUpzbUo0eXE1ZE80?=
 =?utf-8?B?QkpVQVc5V3hNQ3M3cGhENG00Y2duZWVDNUxQdFBKUWR0UHp4ZWFzTnlzUE9P?=
 =?utf-8?B?SEd4eUEvWkxDenNTbXhCTHZNc0NqT0ErZUNnRW9sYnYwbDFkUko5VVpQd3pB?=
 =?utf-8?Q?93uqWOCVC58=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHA4RkZ6MHhqN29GZ3RwL1dpZ0lBZE9VRmZSVjFIYlpUeFJ6VEZLWUJxNnRB?=
 =?utf-8?B?NkZuMWlwdFdrSXJGRHFBNEtOS2FxM1ZhdWM2Y1ZMVW1BOTJYb01aa2VuOWsv?=
 =?utf-8?B?dkcycjcwMXQyWUg4cVZnTnhhd3cvQWF5OWZPMlRCYWVtc29ERlFJd2V2WlVW?=
 =?utf-8?B?bzVyWGJVRytJM1N2MGl4NTVqMVdQUnprSWRLTmlFY2RnYlJ0OHcxb1RLVEdS?=
 =?utf-8?B?SkR4YTRMWnRJL2g0dUpxWkZsazBqVXdHWEttenUrZW5HL1dGZ0owdjBCazVM?=
 =?utf-8?B?akpaZXh1NmJoSDNndTA4YWR4U1dLeUFLSnNvQjVSTWkwSWpDbmM4Q3hkR240?=
 =?utf-8?B?WkpaRjlSZU1pVzFzTytUekIxdFF3U09IbWR4SjFFazlHYmNNMDQ2T3ZiZHdP?=
 =?utf-8?B?MmxlRkNQTnlQSkFCc0pYeWpYbFF6MG9Kano1bmFOZkhiMm5TVUQ0dUU0NkJx?=
 =?utf-8?B?RVQ3NU9US1NVZVd6SXg4THdLMVNOT1RmSGtNQVUzNnh1RmR2TGNmNHlsTUNq?=
 =?utf-8?B?OTl1RUVRdUZaTVpHdWdQVzVjTjNkTllXcHk3RGxXTWdhM0FGSHd1ZEZlelpH?=
 =?utf-8?B?NFRTQStybWJVY0FkYkN6RWYyS3R3cWxnOXo4WWF0S3J6anlrSlJEZm1jUzJ1?=
 =?utf-8?B?cTBKeVlldmY1eTRKVUg3NDRTZU1TS1lacFJCWWZhalEwWUVmS1RtN2JmM1k4?=
 =?utf-8?B?c3pMN2NRTVZjbDNxZGVFcklDT25YbCsyNkM2N1huRHBOMVJNNjBpSHFEZy9l?=
 =?utf-8?B?czBsY0pnY3ZYMmJEalo4T1dzTW9NSmY2NDdwbE15YWtCUFEvNFJCZTNGeGxK?=
 =?utf-8?B?S3UrNy9nYWY3WU55RHNLSmVRZ3Y1c0NtYy80QmpCTW5ELzNsN0c4RjhVd2c5?=
 =?utf-8?B?Uk0xM1ZxckpQU0NTdjNmdm1GcWJnU2cyeGJQRlh5aHRTSmVTU29WaFVjWWNl?=
 =?utf-8?B?bGo0Wk53ZGxocHo5amNuUG05NnNMRmk3UVZOb2JPV2NzMnlwZlBQRDFySmVy?=
 =?utf-8?B?Q1F4bEpyNWgvSUZjMWxMcU80V0VJL3FGWEcwVHpBV09JMmU0eGgwZnJDSXpi?=
 =?utf-8?B?MDIxYXBlbkhBVXU5Z2tXMDA3cERsWGdzMi9sQTJUZ0Znc1NRb2poUVp5TGQ4?=
 =?utf-8?B?UXZ5bk1kdTZPTC9wdGJCazkrNmZ3WHlOWDU3ZUF1aE43WjhtV2FhV0FLQW1u?=
 =?utf-8?B?ZXFGU1hpVmlGaXF1YTdiTmJYUit1Y1R5Zjc4dkxxMWgzNkduMUV6OVlxSDhi?=
 =?utf-8?B?ZzJRWnJ2Vk9BMllTcEw1dDA5WTk5U285L2lGUy8xaGlMTGdOMVVJK3hnK0p0?=
 =?utf-8?B?dUIxVzlxQm8xY2RWSXpyTlgvQ0RpdGt5VTFGSTl6YXVteVFRRE4wQlZscXdH?=
 =?utf-8?B?R3FBZjdBencyQ2t3T0hFVVh2RFZWWnR6TXlTSVhoQmRRdjQzYmE5MmdrV1Jw?=
 =?utf-8?B?V0EvdEh2eU1pRktmaUd3V0JBaU9DbmlTUFNBOGxMckI0dWJBM2xPZ3puUjJ4?=
 =?utf-8?B?QWdtYW4wYXlVczBtSTFiVkpRSzczUEJQaDhwWjVGSnp3SHRUYnVCWlV1NUNz?=
 =?utf-8?B?STVIYVF6cm9rT2dGYzFnR1pPUGtybm1wQzRsSmMreGhHT2dpbU5sNXp4L0VJ?=
 =?utf-8?B?ZjFJK2oxU1hSb012SG4zQkhlWGhkdGRhSUdWdHVSQWJzTXVYTGFPRkdKN1Zk?=
 =?utf-8?B?RWZYTndERlo0dXVYQjBEdkVIaXJtZUY4cEZ4WmUyc0VzcmdXUm9rT1AzejBQ?=
 =?utf-8?B?ZzRNM3ljZ3R4a2c0eDZ0Y1FGVi9xVnB3MTRaNWhZM2Y5aFdhZlJUYlNqY3h5?=
 =?utf-8?B?cGI2TGFGMk5uMmRwaTBWYlg3VzFTQmdmVmR2Q3huRWYra0tBc1BTOVNLb3A0?=
 =?utf-8?B?dEMvTHhHd1Y2aW9oNW51R2dKZW9ucGt5V1IwNEJRUGRtY2NUSGpwM3p1eHdK?=
 =?utf-8?B?YVI3NnpMTWNPSHBGYXZ2cTlTY25jY3psRDEyQUVXWFoxUk9LaENFN2pHSnpC?=
 =?utf-8?B?S0FMa3QrTDc1Y3VCNUdPK3lsUDRWWlpjMU9idldHRzFIWmJIeHcraERscisz?=
 =?utf-8?B?K1BCUi96UkFNeWhEdEdMTkgxUDlyNllza01Ua01HaHZ4MWpJU2xQYnJaNVhn?=
 =?utf-8?B?bEVEOXdOczBhRWloblpCNjMyRFp6cFgyM0pJcTlHalBjQWdTamhDNkROWkQx?=
 =?utf-8?B?MFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0199baf5-5233-419c-c8d6-08ddd506f97a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 16:33:29.1381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AVQX+ZM/2faNjmhdSyf+C1i/Lk3vjZXfwi48+d8GPnL0V11zSqkqVMEDvHVH4hwJiGBkBv9NWhwkgB3+QaKaN5OKZDFQwf+CblNwsgKNelI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8334
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
[..]
> > Sounds reasonable to me.
> > 
> > Not clear on how it impacts tdx_tsm implementation. The lifetime of this
> > tdx_tsm device can still be bound by tdx_enable() / tdx_cleanup(). The
> > refactor removes the need for the autoprobe hack below. It may also
> > preclude async vmxoff cases by pinning? Or does pinning still not solve
> > the reasons for bouncing vmx on suspend/shutdown?
> 
> What exactly is the concern with suspend/shutdown?

I was confused by Yilun's diagram that suggested vmxoff scenarios while
kvm_intel is still loaded.

> Suspend should be a non-issue, as userspace tasks need to be frozen before the
> kernel fires off the suspend notifiers.  Ditto for a normal shutdown.

Yes, tdx_tsm can stay registered over those events.

> Forced shutdown will be asynchronous with respect to running vCPUs, but all bets
> are off on a forced shutdown.  Ditto for disabling VMX via NMI shootdown on a
> crash.

Ok, to repeat back the implications: async vmxoff is not something that
needs to gracefully shutdown the tdx_tsm device or system-wide TDX
services. Those are already going to error out in the force shutdown
case.

tdx_tsm is a module for system-wide tdx_tsm services. Its lifetime
starts at tdx_enable() and ends at tdx_cleanup(). Until a refactor
completes tdx_enable() is called from the kvm_intel init path. Post
refactor, tdx_enable() is in a system-wide TDX services module that
depends on a shared module, not kvm_intel, to manage vmxon. kvm_intel is
a peer client of this shared vmx module.

While the TDX TEE I/O (device security) RFC is in flight the
implementation will go through a phase of userspace needing to
demand-load kvm_intel. The final implementation for mainline will have
broken tdx_tsm's dependency on kvm_intel.

