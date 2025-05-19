Return-Path: <kvm+bounces-46997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E80AABC426
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 18:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09C843A080E
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C07228A1D0;
	Mon, 19 May 2025 16:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PmSBHbQm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D9328852E;
	Mon, 19 May 2025 16:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747671179; cv=fail; b=lRWJfDaB9tTfyo0vAKyjnlyb0/9CYKWo16NxuCEr+b/m/3rld0xCa51XMiMFrX26Ezve2UOeqZlU8DbI4vCmmmJGT21E04CWCiUXLsn/QcBiC8TnyyClqTlk9ukJlwGtf2Hy49RiWR//VA6or2VwRuetFtr2ofejjMkMR9xMDMs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747671179; c=relaxed/simple;
	bh=MJxmnklR5VqnzFMWWyNSuQmz4TzLkzbTh7cbsUSz6UI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bqaQ2nfN1loExLHsUNes4da1RgAopKxp9dZRnUVZ7HKEipCgXU3LLntCVnTe2pjKDreZvGK/F4jpCH7FDt9T8RDgH7UYbif1H6bGiNC5KrgyWbXxZ/P2SOThRpCSDC6EQnIV/Sp2SCnrG98PxocrbflyMeJJZv/TJpUJzLS4Pgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PmSBHbQm; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747671178; x=1779207178;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MJxmnklR5VqnzFMWWyNSuQmz4TzLkzbTh7cbsUSz6UI=;
  b=PmSBHbQmfVlZ2Kb8gjVoRnZu7h4YqcKxcP42EOKjhAh0bR8ulycb7hao
   8o3E9G3f7nFg0cxqCktbSHF4nCL4duSv4BnY51rQqpMK2/TM4ha9lBlVi
   whO8a3bSybsPaED59badXwXqyk1LQMZGvYNgStw2wqGhYCbTR/IsIyv5E
   6yWG81oiBfeWbfoj0awn9NsW/Ke1ohyy7Xrb/WAX6tZtcFUodGvSn6oLP
   1yUyJHbFhyuChXwafO1a5Wk2hwB2ViXN0oJmi5NOFFrPYA6CffhhmKirX
   zZwPm/ux5jBYhD49yKVqcC64QT4sHyoIrWrj2FhHYgOVH/7xwoDwKNj6M
   A==;
X-CSE-ConnectionGUID: m+Y59owfR7u7UoGZoggTLg==
X-CSE-MsgGUID: K4I0lRCNTRyv+pnBfCEZaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="60612646"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="60612646"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:12:55 -0700
X-CSE-ConnectionGUID: pmmY6VoMTMWVPt6mpMfB2w==
X-CSE-MsgGUID: WR3sVJloQaeoOV78JQf6Zg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="143418085"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 09:12:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 19 May 2025 09:12:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 19 May 2025 09:12:54 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 19 May 2025 09:12:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6lQ3ubGc4DKxhFemhTtC6/Gyd/+TnrVimBb/KLRdPOypD93lsrWt9w+TFQrZGSKmtUqelrs9lM1HR3vIdQrGxmqrEJWU2h9eBs5+IHdi2Rs3muw75nYCs8JfcQv2tTewOo5s0Rvm01hsS2lHqjyQBY1Tl7geEtmcE4RGuoY5QKV2TdQcHPl2kHdAr2TwsAQcE8nihVs5QdZVLjqJIHph+V1ljBOu4dRKq/ukaoM/xpZ8YLg1fwL+/g82mCizbEPv++N/cDsJ8G8q5XR3S/Lv0V17/GdPhbrZz3jgtJa5tIoSCDlKLSmUzle68K/TZ2lNIWmm9NE69+rBFuNFPPpCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MJxmnklR5VqnzFMWWyNSuQmz4TzLkzbTh7cbsUSz6UI=;
 b=KyqTnmIXAPJR+FpvkgrxwBmsSEhzdIoS57ED9cRbKEdiCmGh27twEqvMTj9+5nWHDoFXgCl4o8yL44GudwW1ykNyr6W3h6Qz0i8jwPYyyPGFMKytLTxmuQhZHRLyovNnY40fDWL4RwEsr4Sc6kRhxHx2XxK+2o6vrFdS8yCGdAVDsJGJrwCQBtZZbEUD0XYcUiqyi6l6cIbFPlZYobOVBJmrxpw5QOhalx7yVDT1rZBltFCSkJYlrLAoV/OOvx2064LA/xQ64YCY7PBvCdx+8H1i79/+Zznqoe3LE2TmBIUfNDk5JpwUcw9+PAoI00Idqsdm5RzZ4e20JEDhd7cO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB5214.namprd11.prod.outlook.com (2603:10b6:a03:2df::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 16:12:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.031; Mon, 19 May 2025
 16:12:51 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for fault
 retry on invalid slot
Thread-Topic: [PATCH 1/2] KVM: x86/mmu: Add RET_PF_RETRY_INVALID_SLOT for
 fault retry on invalid slot
Thread-Index: AQHbyGdiXv6lSo2xSkiHY9GZD31B8bPZ9FUAgAAsmAA=
Date: Mon, 19 May 2025 16:12:51 +0000
Message-ID: <52bdeeec0dfbb74f90d656dbd93dc9c7bb30e84f.camel@intel.com>
References: <20250519023613.30329-1-yan.y.zhao@intel.com>
	 <20250519023737.30360-1-yan.y.zhao@intel.com> <aCsy-m_esVjy8Pey@google.com>
In-Reply-To: <aCsy-m_esVjy8Pey@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB5214:EE_
x-ms-office365-filtering-correlation-id: 3f66f08d-d7e9-4ae5-87ee-08dd96f0018d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0JJcWwzVWtmNHlSMC9vdm1wSGkwQTVuNncyRXBrdTlnYVJ1OXBVbktUR1NB?=
 =?utf-8?B?NE5NYkJrdXJ4Vk1VK01JUFVleFRsb0xYa0phbW9uUld2NjVQNXY1L3dKdlVh?=
 =?utf-8?B?a1drQzFQZFFFczhaU2VoemMxaElYeVVYMHpad2NvZFg3eVExUjhXM09tbVBm?=
 =?utf-8?B?bVZ0R3ZJRHJtcWdNWWN2b3RQWlZaUC80VGoyM3hyVTBPSnBHWEZhbEFSa1JG?=
 =?utf-8?B?QnVQWjBFNWo4aEZTd04xQm5PTWh5aHRxcFFlbjl6d0ZLS3BSUnJPZ0c5N0wv?=
 =?utf-8?B?RTRrd1ZEZ2xvaVB3ejdOdjdQeGdMUHZ0VkRGcStNSlBsbGV2cFVORVJXc3Bz?=
 =?utf-8?B?NnFPdEtONDlvTXljQXNSeERVaXdUcEFoQVk0dFR4bWFjQ2xxSGh1L2hnYlkx?=
 =?utf-8?B?MXptSmxLRTBZay9SZXprczJVQisxVUdPQlhaaG13UEFyUW5zcStjMnhyeFB6?=
 =?utf-8?B?VDY4NUo1ZXJUeFNQVVZMSnVnR0wyMU9BN0JRZkVVVCtGNW1hZXdBZVBDbnZM?=
 =?utf-8?B?NlFYSkk0dkdVVHB0M3FDZDBqdlpDeFpDQTZ2TjA0ZFc5RlB1ekNBOERaelBJ?=
 =?utf-8?B?akRNNkZCRmplck5GZEdtaloybjZpS1IwUDRPYkhzWmZLYUk4TzgyS0x3dTA0?=
 =?utf-8?B?UWtITEU3YXNKUGMycDdpcjQwV3JiTFJVTmdDZ3JHWk1xM2twVEhiY2kwWUxk?=
 =?utf-8?B?S3RVY3QrTnFZWWlkN0g1dU4yUEZCei92T3MwSlk0SHB6WmhQYUZ0N0ZmeE10?=
 =?utf-8?B?V0k1SzBHd3VkaTFOT0Zld3JBSVVodlAzMVR6OExHRjA3cXIxV1BIbHJyVUlJ?=
 =?utf-8?B?M2ZZYk9TT3lYeDhRMGkxcDNoRlp5aURPTm8rVm9RWGpjZk1PSXNpSzBybXdK?=
 =?utf-8?B?L3FtUjlLaFJUU2FXK1V5bW82cDZoTkxJRGRUMmhFMXpwaWh1MTNYb2c2WFJk?=
 =?utf-8?B?c3lFMXlhbnYwZzF6YTNhRWFSd1d1V1hZQWRGc3NhWGhPZjU2eG5ZZGRSd3Nu?=
 =?utf-8?B?TTFOaVZIcmtabndFNmlXdWJFRjUxWnJYS0cwaE1BRk1NV1Iyc2FwdE1PZHp2?=
 =?utf-8?B?MHhjN3g1OFRzMElDcWpOajBRR2Q5aDFYUnAveUwxOWVHWUNIbTJoWUhSMDFZ?=
 =?utf-8?B?MnpQZklKS0IxSE9iRE9lVnAzNjZTRjZjWStITVZxYWNRM0w2dWhVK0JLVits?=
 =?utf-8?B?NkxPTTMzMlkvcnRlTVJ1dTNiRlFVcktTNkkvS1FKRi8vM05PNkhleFhzYXFD?=
 =?utf-8?B?SlRXanZONUY4M3dvQVF1cWF2QTYycjhCQk1zbGV6alZhcDA5ZTZIUWl2alhF?=
 =?utf-8?B?TUc1TFhYVHgrK2FPcThOSWtUTGJxVzdrWjZkd0ppOUNSdjV6MzRNNEt6eFlO?=
 =?utf-8?B?dFB5bFd0c1ZuSFlCb0dNRFZKVllTeUtaeEFVeW9vdWQwS3JsaVVoMmdGYVRR?=
 =?utf-8?B?TTdiMnFOdVhIMXJyeWQrdE1aMXF4TXVZbkFvbVJCSUxTWGRlYmpINXFTeThQ?=
 =?utf-8?B?TFZOTUtnMGpZSDZlWG9NMTVJeFlUYXJ2M3pWR0pGOW9XYU40Uk9XTnZnUnFl?=
 =?utf-8?B?WmkzUFpvREl2QVNUWklKU0VMTWtnWmpCQmd1OXpQNHVrcXZGdDBsdW9uN2ww?=
 =?utf-8?B?MkFZeXluMmdBRElORmhsZnJ6Z0E4dmFpbXhITlU4M2FKZGcvNFE4bWh4dXNz?=
 =?utf-8?B?RWptaE5yVkpIUkJLRGdJQnBzOVR4MEJiM2tYWnRBYzlCL3FIMURtbGNhZWpm?=
 =?utf-8?B?R0IxYXdRNWFTcWNXMG1GMUZES3hiTzdnc2VmSm5nMW56N0ZvVnFnRFJSZGRt?=
 =?utf-8?B?RjJTUkgrYlluMVJkVUlSWUw0cVk2dVUvOUhZRXJiTHZaYS85dVdNM3hlTDAz?=
 =?utf-8?B?eVNPR0FvKzd6aytSdTgzbk1IbVVheXExK1lwc2lRUFdpUGJ4Kzl5dE12UFg3?=
 =?utf-8?B?a2FubmROUkliMFA2cDhJSnY0d1ZMNnF6Q0FldkZEQnJuVFdxd0crbUR4SEhG?=
 =?utf-8?Q?QGOUL507LrPptEZ+Ci1AMBKSpBoi68=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzY2ZnBDdDNkTTdJVzQ5QkJvaXcvazREUnJCT0NRVHp3Nk5ZU0VITE54VTBv?=
 =?utf-8?B?cVgwOHBEMDZ1eUp0aGlOb1FVZUIrYktiSUl5SDFWbm1xQzRmSDdRRWtZdm5G?=
 =?utf-8?B?RTc4ZjhvZ0JuMHZRWVdSRVJyU1dqdG1GaDVqOXFsSkdZc1JDMk91dzEyajA0?=
 =?utf-8?B?Z2tVelVRaXplQ2F3Z3Y4NXdXMjBkeFhjQlE2TWI2SmM1cXNIMXlvNU9RNG1Z?=
 =?utf-8?B?SlNzQTcwcXRvNU1HdG9JdTIyZVJQbDAxRER2WEVGd1lqQWZhQklsaVU3WTB0?=
 =?utf-8?B?emo4KzFYSkZCT0QrM2hBclJjSWlkM1FkTnBrc2Z0VEtFdndzNERVTnpjTE1W?=
 =?utf-8?B?TzF4eGVUdXdSOTNqZDc2ZFNwQUMwU21PUzJGREYwZXJrZ1lLTjNhVU52RzhS?=
 =?utf-8?B?QjFZVWJEemlHUWRuNWtjMTdnT29LYkdCeWhmOEpBVFJUeEtPbHRRS2taaEcx?=
 =?utf-8?B?RTVoU3p2VEgxT3BwRExpU2V4MEZnRG9lamxxQzRFcFFiVGg0TE5UK2RxY2F5?=
 =?utf-8?B?V25uUllBeG9ZRXIvOXgvMDh3WDhhVVFOT0c1OG14Q3ZKeWNIRklBTDJPblFS?=
 =?utf-8?B?Vk5uaE5wVmFnVzd6bzJXdytUVkJUNU1GbEwxYVF3dGNzS0FSQVVLR1FiWXBO?=
 =?utf-8?B?SXRxQ0RrVXJteW9Xek5zaTd2bzA4UVQwUTJJUDUyUW1vOGdOTldGVGJqczh5?=
 =?utf-8?B?VkxqZ0JHMU5SSmI1T085RkI1UjNoMDdyV0VuQnpqZm9jeEd1V3doci8wdEw4?=
 =?utf-8?B?UHgyVDBvdEdSKzBKaGFOaDY0cmk0dzgwQ0ZrRTY4RnI2amYxdHBnTFI3OXdQ?=
 =?utf-8?B?aHBUNm42c2l1YXZqWFVuMzVValNsZTJyUC9UMGwzNG9oaVQzdWVFdHp3R2Y1?=
 =?utf-8?B?MExaOU1BczJlZEJ6SWxsbjRJWWt0TGhpR3FyQnVRMWRyN1FtS29YbGU4aGow?=
 =?utf-8?B?eTV0YW1VOWRIWUJ2SVUyQnRuN2RvWlA1Y09jZE9PYmd0em1vNkNtcHdLR0NG?=
 =?utf-8?B?ZmxIUlVnaHBoOXRMZTU5VFhUNEsxdmRhNnhPUEhkdTVwQk9VeTlHb254b3Aw?=
 =?utf-8?B?SEFtTzNvWGJESVh4aGszdUxyMThKcjIrQ0JwNG50dDB1cFVXQUZQZEJLZnZS?=
 =?utf-8?B?dVFyeU13MzRLR1g2L1M4YWU1L29ZNjZUSlpFM3pDWmUxdHEyRWJGT3Jna3Fn?=
 =?utf-8?B?SkR1SnM3N0MvOVBFR0I2T0xDcHpETXU1L2FRd21vaEg4ZzRnOURYMU5Qa29i?=
 =?utf-8?B?Z1ptWHY4NzhldVp6VS9MbEoxdXFWbXdOM2NJYUNVOWl5ZGlrRmZvNS9UU3Bl?=
 =?utf-8?B?Sjkxc2cwYkhHa2gwL01JQUlXOWtDR2J2TjNaeGxZYWFhY3VNbWo1dkdTdzFq?=
 =?utf-8?B?ZHNNa09qcnlFbyt6VVFhWjVMOXY4cWhrYzFwRTU5VG4xbTRKTkN0bHdodjF1?=
 =?utf-8?B?LzZVWDZsT2hsajZMUUJ0VTZhbkV3eHhrZ0tQdjhNRU1ySk9BT0RkTUpmckg2?=
 =?utf-8?B?MGtUekx6YTNDWjkrQXZIdXg1VkZIZ3RXdm5PRUVQRjBMTDkvUWorWS9ocFYv?=
 =?utf-8?B?U1NqRXVQRVJuSjZaeVV0MGtQZDY3Q0JjV1lzMmtuUDlVOCthODBVaTIyTTRy?=
 =?utf-8?B?cUFZK0RNNnN3S2lLVnRSalFFWEE2NW1VTGd0VFRQZkFmdGR1a2VXN1E0Y0Vw?=
 =?utf-8?B?ZHJxaHprcTMxbHBzVFM4RmMyYzRGY2xMZWJBTlFmMU1WaHJnTElFWUgzdU85?=
 =?utf-8?B?SFRvbEpBdCs5THFaeFF6V2thbXpVeVpuVjBVNmUxb2tCYVA1T0RMQmdTNUhM?=
 =?utf-8?B?cGprUFJ1MFllL2ZVL3hZZCtsYTZOelZWckNleXk4WEtHSE9aODBpZi8zL3dB?=
 =?utf-8?B?ODNtUm5qVy81R21hVEMrR1FuQUFCQWZ5YThpRmJyT2lSeHBMZCt0d2p0Y3hq?=
 =?utf-8?B?ZmZzVDRQcmxsa1FOZjQ1TGZrbWd1Z0plRllyL2w4U3BSNnJ2TGxSbHJYa0hy?=
 =?utf-8?B?MlJrbi9tL2t1aGJiMEpNdUswYjUrdEY5TEdCcnhCWExKZmdXWi8vMTlabDg3?=
 =?utf-8?B?dnVSY0h1dE5ZeE5BQ2Y4N212cFg2WmR1c29hRGozVXYwaHk5UlM0b24xOU5Q?=
 =?utf-8?B?bExIMWRHMThzUTBkM3BSdVNHN0hwM2R1c3pTQjBhZzJhNUlyQVNXU0V0TGZO?=
 =?utf-8?B?amc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67A7638B5809BF4C990F115E518FEAE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f66f08d-d7e9-4ae5-87ee-08dd96f0018d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2025 16:12:51.8491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sa21xQlEyhbEiPJ6RevnIFYwf200X4et0RQqJ/1P5mg2I6+gKln9xMiwdbzmAtYn1WuBWq8aSy+1iU5yJChIVIMcHWRiXbaS6neYPt8czzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5214
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDA2OjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBXYXMgdGhpcyBoaXQgYnkgYSByZWFsIFZNTT/CoCBJZiBzbywgd2h5IGlzIGEgVERY
IFZNTSByZW1vdmluZyBhIG1lbXNsb3Qgd2l0aG91dA0KPiBraWNraW5nIHZDUFVzIG91dCBvZiBL
Vk0/DQo+IA0KPiBSZWdhcmRsZXNzLCBJIHdvdWxkIHByZWZlciBub3QgdG8gYWRkIGEgbmV3IFJF
VF9QRl8qIGZsYWcgZm9yIHRoaXMuwqAgQXQgYSBnbGFuY2UsDQo+IEtWTSBjYW4gc2ltcGx5IGRy
b3AgYW5kIHJlYWNxdWlyZSBTUkNVIGluIHRoZSByZWxldmFudCBwYXRocy4NCg0KRHVyaW5nIHRo
ZSBpbml0aWFsIGRlYnVnZ2luZyBhbmQga2lja2luZyBhcm91bmQgc3RhZ2UsIHRoaXMgaXMgdGhl
IGZpcnN0DQpkaXJlY3Rpb24gd2UgbG9va2VkLiBCdXQga3ZtX2dtZW1fcG9wdWxhdGUoKSBkb2Vz
bid0IGhhdmUgc2NydSBsb2NrZWQsIHNvIHRoZW4NCmt2bV90ZHBfbWFwX3BhZ2UoKSB0cmllcyB0
byB1bmxvY2sgd2l0aG91dCBpdCBiZWluZyBoZWxkLiAoYWx0aG91Z2ggdGhhdCB2ZXJzaW9uDQpk
aWRuJ3QgY2hlY2sgciA9PSBSRVRfUEZfUkVUUlkgbGlrZSB5b3UgaGFkKS4gWWFuIGhhZCB0aGUg
Zm9sbG93aW5nIGNvbmNlcm5zIGFuZA0KY2FtZSB1cCB3aXRoIHRoZSB2ZXJzaW9uIGluIHRoaXMg
c2VyaWVzLCB3aGljaCB3ZSBoZWxkIHJldmlldyBvbiBmb3IgdGhlIGxpc3Q6DQoNCj4gSG93ZXZl
ciwgdXBvbiBmdXJ0aGVyIGNvbnNpZGVyYXRpb24sIEkgYW0gcmVsdWN0YW50IHRvIGltcGxlbWVu
dCB0aGlzIGZpeCBmb3INCj4gdGhlIGZvbGxvd2luZyByZWFzb25zOg0KPiAtIGt2bV9nbWVtX3Bv
cHVsYXRlKCkgYWxyZWFkeSBob2xkcyB0aGUga3ZtLT5zbG90c19sb2NrLg0KPiAtIFdoaWxlIHJl
dHJ5aW5nIHdpdGggc3JjdSB1bmxvY2sgYW5kIGxvY2sgY2FuIHdvcmthcm91bmQgdGhlDQo+ICAg
S1ZNX01FTVNMT1RfSU5WQUxJRCBkZWFkbG9jaywgaXQgcmVzdWx0cyBpbiBlYWNoIGt2bV92Y3B1
X3ByZV9mYXVsdF9tZW1vcnkoKQ0KPiAgIGFuZCB0ZHhfaGFuZGxlX2VwdF92aW9sYXRpb24oKSBm
YXVsdGluZyB3aXRoIGRpZmZlcmVudCBtZW1zbG90IGxheW91dHMuDQoNCg0KSSdtIG5vdCBzdXJl
IHdoeSB0aGUgc2Vjb25kIG9uZSBpcyByZWFsbHkgYSBwcm9ibGVtLiBGb3IgdGhlIGZpcnN0IG9u
ZSBJIHRoaW5rDQp0aGF0IHBhdGggY291bGQganVzdCB0YWtlIHRoZSBzY3J1IGxvY2sgaW4gdGhl
IHByb3BlciBvcmRlciB3aXRoIGt2bS0NCj5zbG90c19sb2NrPyBJIG5lZWQgdG8gc3RhcmUgYXQg
dGhlc2UgbG9ja2luZyBydWxlcyBlYWNoIHRpbWUsIHNvIGxvdyBxdWFsaXR5DQpzdWdnZXN0aW9u
LiBCdXQgdGhhdCBpcyB0aGUgY29udGV4dC4NCg==

