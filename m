Return-Path: <kvm+bounces-18454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E7E8D54EE
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 23:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 901761C22A4A
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2C9183991;
	Thu, 30 May 2024 21:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XOF4t/Kf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6551836CE;
	Thu, 30 May 2024 21:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717106273; cv=fail; b=ZAOOVBaF7uHQo4fPBkk2YctNrQobSnbfZ+nlox+zfFgAQSJg9+3S2Z1m1FT/3aPgZOYTi2AGX9dhiOfKjUhraop5aSaukmv/QzyNkR4Li2Qno8nv4Nc4kJPYeJrM9lOAHdypSNHsp92aBbjZKs7A5a2tYdEM2ed17Y4ZTWyA9EE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717106273; c=relaxed/simple;
	bh=AGV0F/dJqNN0k2N6WWJJY12gfRts1QjHILp1St/oiC0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=msPwhkt3K1lu+CgBr4Bzk0IKJOk6HUwszk3v3Q6cCxDcyoOdoeyuQs+UwzgkI8M1zalryF84FsBZky/PzcaagU9pw7sXRpVnVbKXzPqg//JcZhGwp+EYjr5wFRmBnfz9wvtbpq6aVbYyTqNUl03ZZhyLvrBIU+1seEJntChSy4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XOF4t/Kf; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717106271; x=1748642271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=AGV0F/dJqNN0k2N6WWJJY12gfRts1QjHILp1St/oiC0=;
  b=XOF4t/Kf8GaPBQT/5RUqp451q0BSzjPPOSsVQn+7NHbSauK4HSq7Z9lo
   Z/Aj3em2H4Q6aeI583T0HNNY/rbYazcviVPsIe9kRl4O1UJqBeN59t3VC
   e53T0Cc7oqN+pFZep4AASQNCFS85S/UbBQ0042N/+IboW6Sg//n0Znoql
   M+sK96Ah8eaz5eInrBkilLKwwb3Qbr1WBBNDMjk2scrLjDXKQtMZ4rbKv
   FedJ1xol7iH0jYEU6+LTt99vU8FH9Uv7nkPuWwlYngKOJAHIMQUCuQYSH
   WlduwuImmP0kJMQu3Tbw104kM9Jt8BUCyUf+W9LEfZLqbekOnzzcLuefN
   Q==;
X-CSE-ConnectionGUID: FS1aKX1tSnms6zE/JdZGXA==
X-CSE-MsgGUID: 9PPRqhNqRt+6ackz+ofisQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="31159853"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="31159853"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 14:57:50 -0700
X-CSE-ConnectionGUID: UZ1/4EBzTOOHGLBm0Y4Qzw==
X-CSE-MsgGUID: R8Qg9q8FS/OFeojqebRzqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="36042021"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 14:57:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 14:57:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 14:57:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 14:57:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYpgEYw8rT0KKgpdD4UYCSlTA1AO7HddO9NIfGui4Vq8pUph2bJDaZFGbtCoCRDOBDY/vPeMe/xoHSfFBVDKs7FvpIcnfZWaHE1x3NtzDngq+0sahkWwfdod+85DP1zdSv+3yF+XtkwHKvAJNJUFbIZuUJMzLlfLA8d1UYSPqjpux51uSF0CnuSfV8lCWkiU2qjtAaMyKl/rSYDqM6RcpS0BUKUNFlzUz1yGGbYi9buiacaTXHjisQd2yRafCpbVzKgruXO1+c8aMY2CWqQeZ/Erz/6p4ayKOPrX2pbu4TwENXz8+u4EK8zCjjG9ggQiURXdlRTY6/26WpSyv4HIFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AGV0F/dJqNN0k2N6WWJJY12gfRts1QjHILp1St/oiC0=;
 b=T2JyxJy+8FmuHxkj5DR5gU8PR0Qu3Sxf/vWcY4SHPpQzfTHOhQj434TF3bwBiJdTrz/C796zcqyj1FCYpvnNxzC427pZ9aY2BymVk2NmM/IBDn+exkSxLJbdVSzRIAA8W4jYFLOw2whjGnW+XFVCiOpPrn54XS/9wuAO8e+bNp4PJE1sde18PyzprNdlaiQgvfV7INJ3BOIIuJgdQ8hMzgT2qDi1YGwxgM1Uoj4HWT+40Wu2avjwFh1rFpE3KrvbFM8jtw96n47yQdvNxZnfzhq8eMrC2tqWBHeJxuvnyUy4GUWh6QCDPCnQmlyXKdYrt49Juv7ueZqQarwnfs84mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SA1PR11MB5828.namprd11.prod.outlook.com (2603:10b6:806:237::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 21:57:47 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::d099:e70d:142b:c07d%6]) with mapi id 15.20.7633.018; Thu, 30 May 2024
 21:57:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHastVuA3gf0B2hd0WXTTAj0WB0+7GwUyQA
Date: Thu, 30 May 2024 21:57:47 +0000
Message-ID: <643a2ae1c0e894a4dd623dfe8c8f7ca5eb897ce6.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-10-rick.p.edgecombe@intel.com>
In-Reply-To: <20240530210714.364118-10-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SA1PR11MB5828:EE_
x-ms-office365-filtering-correlation-id: b3d5edc2-ab63-4564-45b0-08dc80f38aa3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WmF6VVVoalUvUGNxQzRFTHRvK0tUaXI4MmtidlNwV0wxQlJuUzZYNnJuR2hk?=
 =?utf-8?B?VEdkNzlhaURiQ21rSHpGQWRvdkkyakFtd3NtTk51emdYYXhTdjFMZ1hPaVB2?=
 =?utf-8?B?UWRzVE9oQU5POWk5cFFLVHZVdXk3RUZWTmdpWExTMk5jU3J1ZlVIdlJLTzF0?=
 =?utf-8?B?V25SU096ZndaQTBYRHNYbCtyMmxQRmhlc1poUVF5L1E0elBBOHlJWW1uSDI4?=
 =?utf-8?B?ckpMSndIdDMxMGNpN1ZEb3dnZFdUM0ovMWdnU3ZGazczZFROUjFRa3NtOGcv?=
 =?utf-8?B?T1M4b3ozNUE0Z0RPSlV5UzI3bEJqTExxUEc5MUlHV3FzVk1TMitSc21JQWww?=
 =?utf-8?B?M1NqRlYvWERKZzNiQmowOHlrejg0U2ZUSWF5L0tld0ErK3ZwaWVpZVM0M2Zo?=
 =?utf-8?B?bjc3M0RUYVI1UmdHY25wUnJ2b2hOWEs3d0ZqWlkyeFBtUGtTeHJrMks3Wmpi?=
 =?utf-8?B?Z3RGc2tvMEg0Qkk5MmtwamVCQ05jRnFtczMrTUNNVUhnazR2RC9IUlBacy9C?=
 =?utf-8?B?R0l4NmlCbzdvVWcvUXMzS1ZZZ2lUZzlTem03eFk2L2tpQXRhMDMzZGtFbnho?=
 =?utf-8?B?VGs4Ym9Qd3VvQ0ZGSG9qWVFpenpJZDVES3NobjNRVjJzc2xzeDYyU0FYbUdi?=
 =?utf-8?B?Y2VZRzJTa2lNWEF3R2EwckN0eGlmbDJiYmxaV1I2L2psTnlxa2tzcjBNQm1U?=
 =?utf-8?B?NGJKSE9OdHNhWm9wVmFZaWJrMzdGL0tMNkdYVFlPcXFWM3MxQUVCRWxGSk9Z?=
 =?utf-8?B?Q3dUcmZObkkwUTNaQWRrZ0xmQ1M1S0N1NHVNblQwYWlQcUloSm5STEFaQTlo?=
 =?utf-8?B?RGY2emN0T2R2MzZiTEl3cWZ4TnhENnhBYjl4YXZoVnZwYkpsZ2o4TmgrZWlx?=
 =?utf-8?B?NzdtNTNLdmpUY3BKYzcrTnFxN095VkQyUXlHRXkzWDZ3OUJGVjhQU2JMQmRV?=
 =?utf-8?B?d3ZCVG1mNGxvK21JeWp2M2tlek9UeDFtQnFjalYvTXpDUEtzWmk1QzVVRzN2?=
 =?utf-8?B?TnRyYUdHd210RFZqSWZJbjhaZDdobjh3MDg2d0hBTVoybFFPdmtsUWxVTStn?=
 =?utf-8?B?eWpWSzMvY3FhRWhPaFVTOHlPOWR3N1p1czFXRW1tckFmYjg2cDhNWU9NWWow?=
 =?utf-8?B?NzdydXNzZDhMOFErVW9TdUlHWElsLzJScUR2TVE2QTVIZFcxeFd4V2dPUERu?=
 =?utf-8?B?NlpwZUtEMGR3eWlsTHkyQStqYTRHcWw4eHNNeE0zcEJZTWdhbS9jc0FlL2Fr?=
 =?utf-8?B?RnVXV2oxaWFlazFUSlRCYVdWUmZjUWt0NHBaQk5VSEtTM1FCYnR0RzlBdWFp?=
 =?utf-8?B?T29yVU00dE4rUnE0Ry9aTE8xRFhWTUREb3J3aUZQck9pOFRNMklCR24wY1oz?=
 =?utf-8?B?WUREZmZiUDZibll0c3pDSlJoYnhJUUVYSGtqbjI1ZFRNbkRoRi9GQ2lHdFh6?=
 =?utf-8?B?TmI0VHRhNWltTk4rc1VGUUZOUzRiZmlweGhEQzc2cU9GZU1xeU9oTkxCdUxr?=
 =?utf-8?B?TTRubkJWQlhVc0NNMk1SK1luSW8vbE5lcUZUOHlOQWtJTFJpK3lNUVpXTUpq?=
 =?utf-8?B?ZllpTzJ2ZnBFajMvK2tDem5RVW92WTRCM2U3TXBsVlBqRjZ0UU9HN3VzR0lV?=
 =?utf-8?B?WU04azJaU0dFcnNmcWE0RlNzTG5wN01sV2t0Vm82ZVRGZHRnR1dlNmg0MUQw?=
 =?utf-8?B?OUdLRnd5NGNMLzVWZnNwcUp1eldnN0Z6YWszNnBOZ29OSnE5eDNpQlQ3QkJW?=
 =?utf-8?B?d3VnZ3lJbWg4Qnd4MW9YSzNEUi9TSy9RK2lwcVZFQjJyYmMvZlhxV2E2NEFS?=
 =?utf-8?B?UldqUGtxRVVuUUszUldpQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?KzZ5OGEvc2wvQlpQMXZiYUlObVJXdnJQMU9jSE90L000T0g5S0gwSC9EU01Z?=
 =?utf-8?B?OTBIU2dxWnpVWlRWWm9PTEd6S1dvWUI3R3ZKZEtHUk9yQklMRWl2S0tUd0hW?=
 =?utf-8?B?WGoyZnhCOWZEckN3NE1oOVJsdE5PMUkwZXRWODExYUkzWXcvV1dTY0FPV2lv?=
 =?utf-8?B?STB0N3ZtV2htZmZoSDBSNHN6bDMvbWduVklSR2E2YWRkMDV0UkNQSFlvSllU?=
 =?utf-8?B?eHIvalQ1M0JtS05nYlRydk82TVA1RDh1b0NCYllES1BaNC9KTmlxNldyRnFr?=
 =?utf-8?B?V1FtTVBFL1NDdUE3eDhxWHlGbXpreTBHakJoRVlxVkVvaDREWHF5eHVSWTdK?=
 =?utf-8?B?VmMrempSZkVDZDQ2NHBsRmZzM1ZhZzlsbVFZUk90ek1GQUErMXYyaHdMZ3JS?=
 =?utf-8?B?UU5sRjVERENWd2ViVlZWZHNQZVFFU1pGcGxNeWR4elBWRXdSelpkT0ZVdHlX?=
 =?utf-8?B?dTZDenI2WGJuN21Zc1NtQyt5WUNCenJVSll4TktmeXZGeFNiN25oeDVPdHlQ?=
 =?utf-8?B?dUt0UkJWUWtxc0Z5aTJIL2JUTlFEa0RjVFdlbFhHUFBRVUM5Y2RrT216MFNW?=
 =?utf-8?B?ODlya0FURm16b0N5Y2YwV3dSSXV5ZzBZay82UWppTStaVnV1aVVDNWVjMmFX?=
 =?utf-8?B?STBBNVU2cXp5dU02RzJNVDgvWTArajhiNnlYZzZpRlRKM0E5UVJvQ2E1U2lq?=
 =?utf-8?B?M002K0dpdkdHQU1MYTkxMkNWYnM5T0x4MU9YcVVBTGxpeE1Vejk3Q3RrUW9W?=
 =?utf-8?B?VHdVNVd4TzlqcGd2NDBSN0Z2L3Nka2ZVb1NINldEeUNSa1h0eDBNSDBFMkdO?=
 =?utf-8?B?K0ZLRkJLQlVqYTk2SkpZMEFEemhSeW8zS0lpNVdpVzBpOHRTQlA5MFdVU0xm?=
 =?utf-8?B?bkd0Uk1ydk4rSTFOd25qMzI0RTN0M1poMnNkZ1ZDdkxCeFlYcEMxK29SK01X?=
 =?utf-8?B?dHg5bDdTZzZubDRHV3RybFZhSzEwVUYrS3dTSGhVTHlSQ0k1K3BQWE5zaUtX?=
 =?utf-8?B?YVZYd2VqYk45Q3hDc1BpaWpFYUZHQ0VuTWlER2lwMGtKVVErTlJONXF6a0I3?=
 =?utf-8?B?QnNxdGU2QjNKblQ5cENOREM4cXBOT1kxOUtzRVFpZmJiaXhtWk43OUhWZ21u?=
 =?utf-8?B?azBRNWRyT01qSVlqanZ2MXJGY1VUME5DUkdlR1B5VTFZU0RnSzJiSHkyRTVi?=
 =?utf-8?B?RGwzYTJMR3lhZlpicmdQRDhKeXhUZzNvaFZNTWRsbEJBbHg1VmtnRlBlOTRZ?=
 =?utf-8?B?eWYvenYyNEU5ZTlxWm1wZFNwaXZvb21ISktTTXQxVnNNdVhDMW5Fa0hGdzZQ?=
 =?utf-8?B?TkF5eVJidWxOS0xSdGFNc2FBL2F6Tzd1bUt1MkVoSU10YndSSS9oYndGbUJO?=
 =?utf-8?B?M3dydm9WK29SZlNUdzRSYnA2V2JNK1V0MFJ2ZjJMTkVsL2REY2ZZcXhaUHFH?=
 =?utf-8?B?QWhVZ3dza3NOSU1YbXhLR0M0ZWcwYWxtUVgyQmFUdXpkZU1JSEZ0ZXdhNjRx?=
 =?utf-8?B?ZHVmMGNjR0l4WHpqc3BYbzJCT0hWdExMZDY3QUxZVVVaaFBCSzluN3FwZkdI?=
 =?utf-8?B?ZUJYZVhibFZqa3FSOS9hMWxwQ1hFQSsrRmFFZzQ4M0hrenJ4UkYxK0NKYi91?=
 =?utf-8?B?RHdMWkF6SmpmUkZsQjd2S1BubUYrUXRzRnUyVTVRbU96c0lUQ055Rkx6Sk1u?=
 =?utf-8?B?MWN1ejhPMDU4YlA1cjJVVHJicEsxLzVVYUdmalFsaUFSMGZ1Z2h3ZUw4QmR5?=
 =?utf-8?B?MkdsZmZwNVZUcWI3YnFaSDQza0wyaklqc0Jwc0xnSGxxSkFERmFCa3JBVG5N?=
 =?utf-8?B?WEpKV2hmWVQ4cGpZc1Z3NXJqdC9yYW1VblphK2s2V2F3R2NRMndNUytESWtF?=
 =?utf-8?B?Rk44VjBXRnM5QUZWUWNMb0NrbkV1L29GNkZOREZIMHFwcFhRQmtmdE94elFm?=
 =?utf-8?B?VVRVTmpZeWd2M1dWcVpueDQrMkxHc2JVVldKcTAvSWJYdXp6bVFBM3hqNERu?=
 =?utf-8?B?WjNvOCtJSnduWVVJVFVjT0JBZ0h3U3h0b2ZCd3NKdDd1OGlSSkY3dUVuNUdC?=
 =?utf-8?B?U3FGMDNBamJpS05WcWFnMllvQjUxbjU0RnFyTlREWnpvL2k2d0dNTFNRcXVr?=
 =?utf-8?B?RFBKajJROGZHRUlvQmNNakZGZGZlVXVzS2JNS1MvZ281T0JBc2hSeDF3OS9n?=
 =?utf-8?Q?zp0BWsgax7S2IpGOywudWrw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <64C4564D850B844AB06CAA419B2A855D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d5edc2-ab63-4564-45b0-08dc80f38aa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2024 21:57:47.0847
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k68EsGU1axGHO+bsHl2euXvp8jhIs1ghGJUSyii97VdMdsrGI08LWYogJ5BCb6NaqoM3cFBEsK1UJ1Oy8hFunDJSpj6Nz/l6144SjDEJIKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5828
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTMwIGF0IDE0OjA3IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gDQo+IFVwZGF0ZSBoYW5kbGVfY2hhbmdlZF9zcHRlKCkgdG8gdGFrZSBhIHJvbGUuIFVzZSB0
aGlzIGZvciBhIEtWTV9CVUdfT04oKS4NCg0KSSdtIHdvbmRlcmluZyBpZiB0aGUgS1ZNX0JVR19P
TigpIGlzIG5vdCB3b3J0aCB0aGUgY29zdCB0byB0aGUgZGlmZnN0YXQuDQo=

