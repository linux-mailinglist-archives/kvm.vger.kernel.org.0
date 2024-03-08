Return-Path: <kvm+bounces-11367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF0087623A
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 11:39:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 526391F23444
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 10:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B16BB55C3F;
	Fri,  8 Mar 2024 10:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kwe61Vyz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C24854665;
	Fri,  8 Mar 2024 10:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709894213; cv=fail; b=ma9vgPB0xCh7vt+eHHFA3xeI5oFrS9J4Wl/cnCXHbzIEU1WKq7XehK+xezuB4Ib7gxQHE8G+0lAiqtvnqYxmRYFSIQAEE1jgzQeM5Yk41xG6QzRr0oU9bQDYbyFflq2vixdzjoK5os9NyJG5rj1VWg7pj+1RjK7KQyZ8Mth+HVE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709894213; c=relaxed/simple;
	bh=N6ZfsH3CRW7CKnkJKgOHPZTKKwuLDOKUcTqfCJFIizk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AMHqdX9BX0C9tP6Sv9F9KmHqYJ0g5Q/PsM89fEqnqLLldvIxJOCAbXS4O0X0rZoimwlfJuuYFMgtGYGzeDw5oQrpEZNw/hqZdAGXZ0BE1cvJoSfqwmeBzm7kz0sSKVyLfo4PK+osG7tI3ELSKH43azVP29r9FYSC1ialVK1dnrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kwe61Vyz; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709894212; x=1741430212;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=N6ZfsH3CRW7CKnkJKgOHPZTKKwuLDOKUcTqfCJFIizk=;
  b=Kwe61VyzS6UgWzqiYYIIpcpwdgeOF5FNHLLAGjNWQo/1FZrsa+CoFMKJ
   wE0jDubnIHymzbyzWy+bAwjbWKgR+hKtJBWDeNppJHOvvlT8T4RxMG3Uj
   WkDRmxltBp/Uev5XkglnvmpzuEw7uwCG1hXptCJNHsxXe3KlfKXJtxatG
   QpJFxbmcSCkW+pzUpWPmy1eJ/yuMh3GA8CdF+vhFBmsPCQ8yqVqH8Lwj3
   p3kp6+MvpbyLdTHw4A0XmL/0oG/VdeF/qUAENGrqejU517ANz9vMFPQkC
   1Ijh4v2eAEchUx5NviTJuaF3+nmAZlZskVWJCdAdRTb6AZvgT57Y6L4uR
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11006"; a="4477339"
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="4477339"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2024 02:36:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,109,1708416000"; 
   d="scan'208";a="15126192"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Mar 2024 02:36:35 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 8 Mar 2024 02:36:34 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 8 Mar 2024 02:36:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 8 Mar 2024 02:36:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIuMNU+s3j1Ymj4fHCYgcnOO86Ui8RropSAHcCpcIOAI49wSGF4Dk9psBX0GpU8k/QB9+nfByEppvrjCSM/HEhvklmGaQTADGQHngnmaiHCU+ln4VPP8VkR2lqjZm4SNH6r9oYVk3OhUivQPyfBSGfQ3x7zFjRyWgx4iuBQGDB3fFsaAwETCl4AvwzbcvpSqwhAbySYc/ezHT42II3+W7AsJJhKh3PPmGpCMIwZiPXjh12cij+ARtlp2Lc49f7zJVj4o84nYo6gYrmQngzhCWWVZlkeNNuCVUSl0M7L0mItyh47Jt5Eddxn4N7y7Q4xXcXSa74+zlHqPYGrgqSN30A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6ZfsH3CRW7CKnkJKgOHPZTKKwuLDOKUcTqfCJFIizk=;
 b=RHDmDg0ZzHNksP+a2qogsHVvzdDVBPzT8oZi7InAJF/MWCj+qohVbdD6lkqLayw42MSgHaliieGdnP4Gkt8zlXTfkOQ17Vi73rbSTiLYsCve7XrAPm0LMI4qmecPIluBSka8xjzh1UMHPDaIklDAXywXcRwK84QC8w+sMCmcSoDQ9IL40cT6W9C7/pumEkW+JP2OblOqmG2QVmqOrdeY6SYhFQCUtklcl+aOmY/IRpp88wEi3sMbtYbzoRTNco+g5pwY1hrB8FXORu7fPVaH9I5boKJ/5A4sGBREC4OGAt5RBjOOnhDQKwAgy5DJtCH9jrBaLtXmxBICNl9K0L2mPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7677.namprd11.prod.outlook.com (2603:10b6:208:3fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.24; Fri, 8 Mar
 2024 10:36:29 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.009; Fri, 8 Mar 2024
 10:36:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 001/130] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Thread-Topic: [PATCH v19 001/130] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Thread-Index: AQHaaI2sAEJ0wp/9j06fH2hwQKcyvLEtgokAgAA1ToA=
Date: Fri, 8 Mar 2024 10:36:29 +0000
Message-ID: <6c3ab761bf404f3b60e589f5f5369c7e229a9753.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <eab766ea1477d87a5985039e8fbe81ec5a45bac9.1708933498.git.isaku.yamahata@intel.com>
	 <162cd71a-65c1-4782-92c9-e4bfa6a3af69@linux.intel.com>
In-Reply-To: <162cd71a-65c1-4782-92c9-e4bfa6a3af69@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7677:EE_
x-ms-office365-filtering-correlation-id: 28349b54-1602-46e2-7369-08dc3f5b9d9b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NzU3KS3WD4pgXD3pgUSzqrD/7SsJ5spZSP99QwHA+pFTNS8Vmv3ypuYgDdIpiZgIzfeHL8zEcbZOO3z16+vNSJ+25qu/z+Dmp//kwAq+YewqdCcjKVs5DDcpX2amN05BuO+vjjAAyWVzhCYElddi+JW0oPeVo45BWsYeyB5BWa8eOLOBZKPWwRc0eYwCruD5bEVCrMsz5qXCQI/3M+1S0SAy6WowI6bRibF4j7JxF65p5LkkL9GoY0QRZfbYRIusNY8iauZp9xepdo2Nw/jvjEHIBXvs5ppg2MszugK9egH3mR3XtgWz2TQPOmwqPyNR9Z286r+nrH8q0XxHlHyyKuVC/6OCeD6pX1spyorhGBuV0vfnxJHZzgtOGQNUPOTedGEjJBKpKBYlno0v0dxXOz5CW7PQNUGv9e/lSuUYuv84RALO0b2VVm+V/Wj1F+0QC88iVT17G97N3EHuR1cChigx45536ZIWnvXx4Z9Jne9BAsgDv4lSiHA6hSE1I13mfLAqwCr/qucf08eWqbs7fXtqml1edYbm8Uir9LfKmK/viQx1kUI51WkEsRg415f+8IsstQqNyiGKFv+9XVsgjWMXOdfFLH8h84HFQh1R0UGZDpRCmnxTUG/mNWY/knWn0D/5guVv/yAIenl1r6+UxPgeGIgkf/dduZ4TBgSVe9Q=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmdpNzlTZ0dBMUt6VEU4TG1zNWlxbUxXT0NCLzVKMzc3dEI1bWZuQXNQVHl4?=
 =?utf-8?B?WGdJdHFJZHJmVUpXMFpQeHppMER2WUN6WjJqMFFOU0U3bDdpL3BQeEgrOGxG?=
 =?utf-8?B?WWYvY09VZTR6bklWSGhvKy9nUGV6MTdYVnJueGdRVkhyL3ZpSnBtL2NwYzEy?=
 =?utf-8?B?RWRzZnJCZDd3TFNHSlVJTGhEeTRLYjNUbVpHSG4yZ0N3a09jbnVMRmpaY0tJ?=
 =?utf-8?B?VktvWGViSE9YeWpiYm5CeGRQV3gveWgxVlJkbndUYm45LzRBbFNTNUNjeUdC?=
 =?utf-8?B?MVJMc0VzWEFsL3BremRuYTcyRklDeVN5d0tXQUFzbktIRUFSZGllVkNSOS9n?=
 =?utf-8?B?OW5jdlpkQlNGTGVZZU5pdU96WjF1OE9QaldKeUUyYWloQmlRcXcrNnZEc0ZW?=
 =?utf-8?B?M21BV2RBUHJoeUE3Nit5ZFIzTy9uYng4cHd6UjJWME81QWZtUVFNbHgvck9r?=
 =?utf-8?B?bE9vNEJnZ0NjczlQUTFOUFJ5TDA0UDhyQnJ1K1JMSE80QlJPQlMrTC9zWnpt?=
 =?utf-8?B?a0VBUWIxVlcxRWZQNWx4OEE3MFpnbzU0bnpsRTlUY3h5MHg5OWlITXZSdE5m?=
 =?utf-8?B?Q201czN3Z3BCWUZqV1pGLzBrVWxZVUxRcWthTmFkR3IzZEtXam5tMnFuL2Vq?=
 =?utf-8?B?ZENia3d3TldzV1ZhbjhZZ2UwWG9Dbk11ZjJCdlVLZERGODFNS1RvKzlPNDdX?=
 =?utf-8?B?N3Z3YmE0SW54WmtFYzc0OWI3Y1RXUkNtUEg1WDlFdDFKNTJqd2hjU2liZ3k0?=
 =?utf-8?B?VjVZSmIvUWR5bmR4UlFxbzVEcEdMSmRJak96NGd5L0IwUm5hMzJ2MjJneDVm?=
 =?utf-8?B?Y1JtclZTTW1RQWxVeFB0elN2Y2Jkblk0aVNPQXRIcGRNOUZ3M1RzWWtiaGto?=
 =?utf-8?B?MlVCUTMzRUwwNmhPSHN6bFF5RnhLaXlBUHR1WFdONDRxSGlMYVNzNUlmdjJR?=
 =?utf-8?B?ZzlNZzhDNWNUQzBBSmF1T2N1M3FPMUF5MDFSUXBMZHhpdTVFU0ZXazd1MUhQ?=
 =?utf-8?B?WmhpNVJ0SWJPWEJFdnNQbGUreXVlREV1aEQzWThycVR3N0N3b2xpNWZuQVZy?=
 =?utf-8?B?RHc1MTJLYjN6U3d6dGJIRjNrbzNxbXhTcnl0SkdaQW0ya3U2dWlJSSsybGhD?=
 =?utf-8?B?YXk2eFQxdkdCTElmN3lOQUxSK0hBMDN0TWw5cytHOXlDQUQ0VzVYRnN5bHVt?=
 =?utf-8?B?WHVrWkRFbk4rSnRwUUtFVG5nc2pLUVVpbGRkb0hEZlg2cFRWcW5nNytRZmJh?=
 =?utf-8?B?Ky9vTVkwQmhSMnZNd0xZamhVZytPQTQrU08xNVdWcUpyS1B5L05paFlCOE1S?=
 =?utf-8?B?bkZhaCtQRXdpVlhhUkdSdjVNcVlyRGE3QlByVGhxTVFseGVHaVpIalhleHZk?=
 =?utf-8?B?RWFvODJQSWFMM3Bkck5IcUIvaElqV29aQmlnLy8zb3RBMVA4MXM5S1pvU0RQ?=
 =?utf-8?B?OEJ1RGF3anpNOEFod1dwSCtIRDBzbFFwTU1WcFo3UTNjWEZvTkN0aG52Z3Nw?=
 =?utf-8?B?eERIZVlSYVZhdFMvamhNbUhCd2UxR2tEL2hWWXNnSFVRWjBlVUN0L0M3V3pO?=
 =?utf-8?B?d1M4NWh5TlpJWW9EdUVaaC9PM0V4ejR5NWdUdytNY2MrcnM0VUN6Q1IxTThx?=
 =?utf-8?B?QW9Hd1lINFlNajBHbDc3S1ZGcU9lcXM3MjJsbEIvUHQzMVlMbk16ajBNaEgx?=
 =?utf-8?B?TFJQVHBRdkJZNlpQbHl6bU1GNG9SdmIwWkxjUUF1eWY0blg0UDhua1drejEr?=
 =?utf-8?B?SytYSVY5a1QxNVFRUVhjMVUrZTR3NzhWWk9UWWJWemU1NEV5ZkNYQi9tczVL?=
 =?utf-8?B?R1ZBT0luZk5ZMVlLUTh1YUVpZ3JmWTlscFZGNXZwayt2NndYUjg1ZlQ3NDhM?=
 =?utf-8?B?b3kzNTRVWWRwdXRBVEQ5M3hKdjNMLzRpRVZwM0JnSXpvNVJOeGdBTUt1dWJ4?=
 =?utf-8?B?Mks1eHRlcWdWYW10TjdnRCsrcnZaWFJSYW1NdFYzQmF3THlPN0lTZEpmbEM0?=
 =?utf-8?B?T3poK0JGY2FTeUN4SXE0dzljQUtudWZ2NnNVdUlJSDlJWkVDN3BkVFVWanRo?=
 =?utf-8?B?VEhpRFpDLzhmQlNUQ0JxeDVDbVJjZ3EvWm9IY3JHNXhRV0dFV29MYTI1MVdr?=
 =?utf-8?B?bGdOMWMvNXZHRUpZYU1aNVFDdHFMZlZHVnNvSHQ5ZDNaQkpDc0prdlFCQ3Bv?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB0FB75BCC4B744987FCE6FF377764C1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28349b54-1602-46e2-7369-08dc3f5b9d9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2024 10:36:29.8529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mE6TvgBeZUATnWpJO8ZYxmP+ZuTUUDKNkNlmq8VcWpSqvs6B04lNg/5evbdAh5jVF29dmEtBxBCC3jRPCbXzjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7677
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE1OjI1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiAyLzI2LzIwMjQgNDoyNSBQTSwgaXNha3UueWFtYWhhdGFAaW50ZWwuY29tIHdyb3RlOg0K
PiA+IEZyb206IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCj4gPiANCj4gPiBURF9T
WVNJTkZPX01BUCgpIG1hY3JvIGFjdHVhbGx5IHRha2VzIHRoZSBtZW1iZXIgb2YgdGhlICdzdHJ1
Y3QNCj4gPiB0ZHhfdGRtcl9zeXNpbmZvJyBhcyB0aGUgc2Vjb25kIGFyZ3VtZW50IGFuZCB1c2Vz
IHRoZSBvZmZzZXRvZigpIHRvDQo+ID4gY2FsY3VsYXRlIHRoZSBvZmZzZXQgZm9yIHRoYXQgbWVt
YmVyLg0KPiA+IA0KPiA+IFJlbmFtZSB0aGUgbWFjcm8gYXJndW1lbnQgX29mZnNldCB0byBfbWVt
YmVyIHRvIHJlZmxlY3QgdGhpcy4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcg
PGthaS5odWFuZ0BpbnRlbC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IEtpcmlsbCBBLiBTaHV0ZW1v
diA8a2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBJ
c2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4gUmV2aWV3ZWQt
Ynk6IEJpbmJpbiBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IA0KDQpUaGFu
a3MgZm9yIHJldmlldy4NCg0KSSd2ZSBzZW50IG91dCB0aGUgZmlyc3QgNSBtZXRhZGF0YSByZWFk
IHBhdGNoZXMgYXMgYSBzdGFuZGFsb25lIHBhdGNoc2V0DQpzZXBhcmF0ZWx5Og0KDQpodHRwczov
L2xvcmUua2VybmVsLm9yZy9rdm0vY292ZXIuMTcwOTI4ODQzMy5naXQua2FpLmh1YW5nQGludGVs
LmNvbS8NCg0KSSdsbCBhZGQgeW91ciBSZXZpZXdlZC1ieSBpbiBuZXh0IHZlcnNpb24uDQoNCihm
b3Igb3RoZXJzIHBsZWFzZSBjb21tZW50IHRoZXJlIGluc3RlYWQsIHRoYW5rcyEpDQo=

