Return-Path: <kvm+bounces-6413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 307118311A7
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 04:08:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54C9B1C21C92
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 03:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E82F63A4;
	Thu, 18 Jan 2024 03:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S8Q9/f0r"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA805665;
	Thu, 18 Jan 2024 03:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705547317; cv=fail; b=CAPHPjcV/b8QJZTn9NgGd8RdF5nJJ9DVdCymWt2Paau8I8qq0xQc1d63iUea1Qk/V26fRhDnWoXlbYqgYV9UyNXxf47LpDtixiwKQaPBgRK1wD+4lYT12xvdIIlBXgHRd3A5gmymJBC4q2LjdYkQP8nUz5l7qCzyG7FGl2gf66U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705547317; c=relaxed/simple;
	bh=jnrECfHPIzalqRmBj/LeCJyfMmRrHHT++zxWTpx6iGc=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Received:Received:Received:
	 Received:ARC-Message-Signature:ARC-Authentication-Results:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-senderadcheck:x-ms-exchange-antispam-relay:
	 x-microsoft-antispam:x-microsoft-antispam-message-info:
	 x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:Content-ID:
	 Content-Transfer-Encoding:MIME-Version:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	b=oUk1G9ZXkynA0/sFYn7FSDdPLfJJFgC3QSC/+Uy162SWUhVPEtDE0YbhVjslDv06qMaJOXs0XitODhQHFfoIKbJGx0gjQqMi9vmC/KTglUMJUDH6mqGXB5vgC29scqOE20iv0kBynGww+W7fBMKTUL6Ud+dheAGEw/ZMstw/BtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S8Q9/f0r; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705547316; x=1737083316;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jnrECfHPIzalqRmBj/LeCJyfMmRrHHT++zxWTpx6iGc=;
  b=S8Q9/f0r7gm/MxCdFUtVSSi8UjMvRbhW52YYz1UgSlvELJpnt3XobzxS
   5eXmB3hV0rbMPzEc6m6QcRSQz9E/QXgmziE1IB3ZldLgmqo33aQVZ1BtO
   nyqDH8gf3h4M8KMlNU3E4cyQJbs/h+nC0I7BCIC3OBJecSF3Yjxu+iwFh
   cQovCIQxedRt3G99jNUpFc8MbbY77KcxG1YFOn20gfBAA06AAyI/KtVoN
   xvAdGbrBZ+NX2j7rQN9WUH+OicQHCvwLYiTTB9J3Bdj/xonfAcXUJf32h
   WKGhQSMqL7KNuBJnx0yHW16P7hzHRvSE5vFmbBNzJ3y/8gXp1H4cHi+kU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="18932041"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="18932041"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 19:08:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10956"; a="787960729"
X-IronPort-AV: E=Sophos;i="6.05,201,1701158400"; 
   d="scan'208";a="787960729"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jan 2024 19:08:33 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 19:08:33 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Jan 2024 19:08:31 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Jan 2024 19:08:31 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Jan 2024 19:08:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDGWnDA7hPl3UK1vOrPBHf83mj3Y0yo5xlP2XjxrcF2zD8GoyCvAGYJPeAiiLH8zTUpIJ7PWzODn4uHCyJd09EPYIUKNXNZ43+R9QbomqCqJfSy/2vJo+zlOdtrI3YdH5MqUJLHnklfr0kLyFQEqK6mjQJgyH6XtstRyJuraFf7A3THonlxf5cJ5e9rxRaeGDZHe+WuuFsBuCjv8FEe/YCO3TjWPU32rwb2BN6T6gFolDaLpqsg8RjnJYUFCWtyNPgNYtwpXlv2qiBq4CogltabdyPj4v19123wWePydAnwLq9XRbU9Wa2JowcYMBlm5zRk1b6UApedE1PqvBEpIzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jnrECfHPIzalqRmBj/LeCJyfMmRrHHT++zxWTpx6iGc=;
 b=L//2KppwQ9dilFosNdcUAzgsbYpdmDz9TxMB3G+G4fzLf7pSF8T2Kh3dduxDkqCzs1MQUo0edGFj9VAaolSp0pJztbl4/cv+cQ8vfNFeecF57kAhLf37CdEhBjVL9s+dbcRHSkUrOopifba1qzIMn46AGSGsDHXU2+1S42xU7atS21SG7nryr6p0PiISbz0KZnJgmyVcqvA2/Z/OIws+BGcd5xeQEeoxhvZj3fs5+T6hWrXSqYOLKSxFwaQ13zAEaBWoSUtxwBhi4DRwMXYtyihb23kHhZ/FRQZ9Qb/l8qKzkm4y8v58JWEQBNlZJ0qcy1RutmUodd8S2KrutrYMbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB7144.namprd11.prod.outlook.com (2603:10b6:510:22c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.23; Thu, 18 Jan
 2024 03:08:28 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ca1e:db:ee01:887]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ca1e:db:ee01:887%5]) with mapi id 15.20.7202.020; Thu, 18 Jan 2024
 03:08:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xin3" <xin3.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v4 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaRT8Fg8dZJ6KNyk+kWUJ6VvYyeLDcFbiAgAIl94CAALEGgA==
Date: Thu, 18 Jan 2024 03:08:28 +0000
Message-ID: <6d8d04899f00a05ef2512f24f81e58fcb4dad098.camel@intel.com>
References: <20240112093449.88583-1-xin3.li@intel.com>
	 <ZaY0UbFjwCYh4u/r@chao-email>
	 <SA1PR11MB67340002B67910588EE335B1A8722@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB67340002B67910588EE335B1A8722@SA1PR11MB6734.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.2 (3.50.2-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB7144:EE_
x-ms-office365-filtering-correlation-id: 308fdb4a-1bc9-4fca-fa05-08dc17d2be3e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHfivWvftyfaLsLPRlirXuYMVHnoqi8FemzsTpbxORo376zHKfVWvCfivlXq6jxgznfDBZj/qrIRBTiLRIlI2yi66EVdr9ax7H1il40G3FuZhpYWO6lYbh7ZSzd/Y7BwLIFTaEHeQk+LHG18GAuIgwAGScGKBFH4Eu+kfk+aWOlZcq8gnqSTn4pyQvUNVc5MxuPtNOKwZdjr4ZmXPWOmqnbm0oLYFdXzmD1npih3x8bOGTy9EOPdFz8AeMha0ym61lR+pv7NN9Cv7ZeJCpuZIq76ERw/bdhFcShRuRxHMyOvvlS/g+NjpPtd/vXsMkKbEVdUr9gJGnI9yBzGea4TO3t/3RBks1vuVo4vwPKFBRr1cifCDcEX1+5+7SiPbfuGrUuwTlaryIAXWWodaBHeV3w0G6U+TRSnHABNwGc9WpWdB1v34H9PMHtCtCrm5PagkWjjMYTxZHRKTPe3yV8OFEv80OeYEEjGC4Nim+gZWd4PnW6cSrfyLjIV/utXpP7Sv61LVyMIh5yznokdKB8fFlsKX3xroh4m6nFaFd9Z+vs6uH7B2vN0149UnLdlLNbljiAZwxFODKlM0jRVlJ1DkKI7apyPaXGvvnjzzq3Tnto/pUx4XTuJ9p7QxGp11ldV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(396003)(136003)(366004)(39860400002)(230922051799003)(1800799012)(186009)(451199024)(64100799003)(122000001)(6506007)(6512007)(71200400001)(66476007)(66556008)(66946007)(6636002)(64756008)(76116006)(4326008)(316002)(54906003)(110136005)(36756003)(38100700002)(6486002)(82960400001)(478600001)(8936002)(26005)(2616005)(83380400001)(86362001)(8676002)(66446008)(38070700009)(2906002)(5660300002)(7416002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTRoR2RBNjU5czc2Nlh2RTlZRUZFT0hvK2NnSTR1R1c5aDBkbEdnQ0JJZHY0?=
 =?utf-8?B?OFpkNm5zbTNrZmxTUkQ5R1B4M1l4KzlJNEhjSm0yTVlGNFNXWjRZSWlqWktG?=
 =?utf-8?B?MjVDelI3NjhkdVdnNmYwQlUrUy9XbTM3WThHejNCOE5OOGtnTjBmTktwUXMy?=
 =?utf-8?B?Zzh4dHVoeWZOS3Q1Ly9VQ25XZjFYL1QrTWJUVWMzZUsydDcrT1N3eEVlTDg4?=
 =?utf-8?B?SUN5MHRQQ3ZGRWVtUzVzdklHY0hRQXFDZzlQYlFUME53enNERlBqS3Q5NjVw?=
 =?utf-8?B?NVpNV0s2SEhqb0lkemt0VVpmL2Zob0MxdkdpNVpVcUpTU08rbGVjTU9IaUEx?=
 =?utf-8?B?ZHo2UnhRRm5Wd2xCYzN1bGkydW1uUmhLNmV5a0NjTlEyQzJWM1U3TkpGNkJr?=
 =?utf-8?B?OGx2MXluL1BWazJrVU16UUVKMGh2endCM2hLUW9rZ0d1T3B6bzZ4Zk1ra0hL?=
 =?utf-8?B?c1JJeDR5MGFNRlpqTmhFQ2ZoSzhZVkdjL1dBVmt1Rk9LclBmRTEyTFIrRWhJ?=
 =?utf-8?B?d3ZlT3VIcjJlQ0RsMndyYm9HVnBIQkFhS0trUjFyODJxTVJQQzVDRmZPZTUv?=
 =?utf-8?B?TjVZMlk5WVFPemhQMDRJS0tUbm9Jb1UrVUhKd0FPaHpyZG5BMnZkSnlmcm1p?=
 =?utf-8?B?aHplQ0JXT0xiV2xDTnJ0akFqbk9VTkk5VU81dk14TXY2eDNxUWZhaTZFS1hG?=
 =?utf-8?B?N1JNNjJiZ3hoYk9RTWZpeTltOHlOdzNMVW44OS9JVkxqbm95Qm5LSlRZcDR5?=
 =?utf-8?B?NGRXNmRQZi94ZUtIaytyQ2kxRWZHU1hQbjVWMXNMcTdoNm5WNnNiRzRUR3do?=
 =?utf-8?B?WjU5cC8ySldmam1vSjNkdjE3WkUrNmJJSEhXelhpUnZoY1ZZVHMyQ2dnbXZB?=
 =?utf-8?B?cmZQMFlnUEdOV1p1eWZ5enhHc1RBZ0lWTmRLcG1oRWMwUUtUVGZQTXpoRW5D?=
 =?utf-8?B?aEVCSkdLb2JEOE1HdDVacEhHeUhKcmdLcmdxeXZNN0NGQlVzazd2RjduV1J0?=
 =?utf-8?B?cEhwZkFld1E3c0krc0NtMU9qbHNUREdmV2ttbHZWaVRMUGc3QTZwQ3B2aVQy?=
 =?utf-8?B?dXYveG1RN0U3c2ZTYUMrZGdVcG03cmhNcXdKdjhSN1pscFh2VDJMMG9zeHEr?=
 =?utf-8?B?YlJkN1Y1MkkrVUdobkY4MXArZE5NdEt4S3BDK0wrZFB1TCtWb3huTm9GQUwx?=
 =?utf-8?B?YkRUaTRWeFU4bDhjNEZRczA2VXFWSjdjR1NSbXQ0SVNOOVR4WkVEajdHQ295?=
 =?utf-8?B?T1RJV3kvOEZGQVpyWEpwVFlQd1h2eEtnY05lSWlaSU5sZTBwWWRDaG14TlZa?=
 =?utf-8?B?QllXUVV2RUEzLyt5ZFM2d1RZVHNHNllDNmNZZjNaOE1hNmZGZFp4NUVXR2lL?=
 =?utf-8?B?TXdIRUhFR2IrM1Z2bzJncWxpbVY5bmd4VTh0VnhkWC9rdENmblZkcEQ5cUhB?=
 =?utf-8?B?alJTd254MmpEWTFUblpiRkdQRGJJaUVTM0s2ZFVzdGUvZitVTTBLcGdhRTNx?=
 =?utf-8?B?MWZGTzNzRWFoU0I4YjF5L05pMWhqMlRoRFFxYjhqZ2lMRk9GTnVNSDlOdzVu?=
 =?utf-8?B?akhJdi92M1JyamFOZFJyREZHMzRuSGdzMTJJMkoyUFRBRjcyU295Z2xxT0Ni?=
 =?utf-8?B?NjR2YTIxY3NkUWxzRTh3Nk5HZ2p3aEoySlR1R05HVUJXbDFqTEdYdlNYSi9t?=
 =?utf-8?B?M0hRYXlGMlNWVWNsWVBmSE5oTldHUUZpdHE4SHNFZHFLK1pOU3JqMXBUL3Ix?=
 =?utf-8?B?RHBBS25CMnkybDY1Rnp1WkQvUlQwQzJINmR2VXBucVN1WUtuekdGYnN5dDV5?=
 =?utf-8?B?ZDBsOS8zMzBISURmaXBzaS90K2xJdUVxcFYrWXJQUjR4ZyswWjRXeGFUcXZi?=
 =?utf-8?B?aFBRTkpsUExJcFkrSHNOMmNpcy9lU3NKcXRrcmUrTkRGZWtpbUt3dVZMOWUr?=
 =?utf-8?B?b0wweGNFQXUwTTBmN1ZMOGdKUWtGK21ma0JTalVTVUk1V1JkbXN1SDdHSTEw?=
 =?utf-8?B?STB1OTFlQURTWlBya0FIejErUW9OTy8rSDdzdXo3NU81NU9UNmpsVTdTdG5U?=
 =?utf-8?B?RGlyREM0WjlWZDM1MGhFVlJZejdGUkYyN0ZqTDhFVFhZWjlpMFRhbUZQWHk0?=
 =?utf-8?B?YjJVY3haTk16Vllxcm9ucDBOOG83TTU2dzFCNCtIbmcwR0lML1lHMHhTYU5N?=
 =?utf-8?B?d2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F7BDE44A7ACDC4787C7D669E8394094@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 308fdb4a-1bc9-4fca-fa05-08dc17d2be3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2024 03:08:28.1758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uniko0TnkJoyLGp85b+u6vAmoyg7JopwfBuFcCKSzXDIqY+sfMJZ+jJjPKhxKcq+EXZelRI+dbDKlQdYXeHFQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7144
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAxLTE3IGF0IDE2OjM0ICswMDAwLCBMaSwgWGluMyB3cm90ZToNCj4gPiA+
ICsjZGVmaW5lIFZNWF9CQVNJQ19GRUFUVVJFU19NQVNLCQkJXA0KPiA+ID4gKwkoVk1YX0JBU0lD
X0RVQUxfTU9OSVRPUl9UUkVBVE1FTlQgfAlcDQo+ID4gPiArCSBWTVhfQkFTSUNfSU5PVVQgfAkJ
CVwNCj4gPiA+ICsJIFZNWF9CQVNJQ19UUlVFX0NUTFMpDQo+ID4gPiArDQo+ID4gPiArI2RlZmlu
ZSBWTVhfQkFTSUNfUkVTRVJWRURfQklUUwkJCVwNCj4gPiA+ICsJKEdFTk1BU0tfVUxMKDYzLCA1
NikgfCBHRU5NQVNLX1VMTCg0NywgNDUpIHwgQklUX1VMTCgzMSkpDQo+ID4gDQo+ID4gV2hlbiB3
ZSBhZGQgYSBuZXcgZmVhdHVyZSAoZS5nLiwgaW4gQ0VUIHNlcmllcywgYml0IDU2IGlzIGFkZGVk
KSwgdGhlIGFib3ZlDQo+ID4gdHdvIG1hY3JvcyBuZWVkIHRvIGJlIG1vZGlmaWVkLg0KPiA+IA0K
PiA+IFdvdWxkIGl0IGJlIGJldHRlciB0byB1c2UgYSBtYWNybyBmb3IgYml0cyBleGVtcHQgZnJv
bSB0aGUgYml0d2lzZSBjaGVjayBiZWxvdw0KPiA+IGUuZy4sDQo+ID4gDQo+ID4gI2RlZmluZSBW
TVhfQkFTSUNfTVVMVElfQklUU19GRUFUVVJFU19NQVNLDQo+ID4gDQo+ID4gCShHRU5NQVNLX1VM
TCg1MywgNTApIHwgR0VOTUFTS19VTEwoNDQsIDMyKSB8IEdFTk1BU0tfVUxMKDMwLCAwKSkNCj4g
PiANCj4gPiBhbmQgZG8NCj4gPiAJaWYgKCFpc19iaXR3aXNlX3N1YnNldCh2bXhfYmFzaWMsIGRh
dGEsDQo+ID4gCQkJICAgICAgIH5WTVhfQkFTSUNfTVVMVElfQklUU19GRUFUVVJFU19NQVNLKQ0K
PiA+IA0KPiA+IHRoZW4gd2UgZG9uJ3QgbmVlZCB0byBjaGFuZ2UgdGhlIG1hY3JvIHdoZW4gYWRk
aW5nIG5ldyBmZWF0dXJlcy4NCj4gDQo+IFNvdW5kcyBhIGdvb2QgaWRlYSB0byBtZSwgYW5kIGp1
c3QgbmVlZCB0byBhZGQgY29tbWVudHMgYWJvdXQgd2h5Lg0KPiANCj4gPiANCj4gPiA+ICsNCj4g
PiA+IHN0YXRpYyBpbnQgdm14X3Jlc3RvcmVfdm14X2Jhc2ljKHN0cnVjdCB2Y3B1X3ZteCAqdm14
LCB1NjQgZGF0YSkNCj4gPiA+IHsNCj4gPiA+IC0JY29uc3QgdTY0IGZlYXR1cmVfYW5kX3Jlc2Vy
dmVkID0NCj4gPiA+IC0JCS8qIGZlYXR1cmUgKGV4Y2VwdCBiaXQgNDg7IHNlZSBiZWxvdykgKi8N
Cj4gPiA+IC0JCUJJVF9VTEwoNDkpIHwgQklUX1VMTCg1NCkgfCBCSVRfVUxMKDU1KSB8DQo+ID4g
PiAtCQkvKiByZXNlcnZlZCAqLw0KPiA+ID4gLQkJQklUX1VMTCgzMSkgfCBHRU5NQVNLX1VMTCg0
NywgNDUpIHwgR0VOTUFTS19VTEwoNjMsIDU2KTsNCj4gPiA+IAl1NjQgdm14X2Jhc2ljID0gdm1j
c19jb25maWcubmVzdGVkLmJhc2ljOw0KPiA+ID4gDQo+ID4gPiAtCWlmICghaXNfYml0d2lzZV9z
dWJzZXQodm14X2Jhc2ljLCBkYXRhLCBmZWF0dXJlX2FuZF9yZXNlcnZlZCkpDQo+ID4gPiArCXN0
YXRpY19hc3NlcnQoIShWTVhfQkFTSUNfRkVBVFVSRVNfTUFTSyAmDQo+ID4gVk1YX0JBU0lDX1JF
U0VSVkVEX0JJVFMpKTsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKCFpc19iaXR3aXNlX3N1YnNldCh2
bXhfYmFzaWMsIGRhdGEsDQo+ID4gPiArCQkJICAgICAgIFZNWF9CQVNJQ19GRUFUVVJFU19NQVNL
IHwNCj4gPiBWTVhfQkFTSUNfUkVTRVJWRURfQklUUykpDQo+ID4gPiAJCXJldHVybiAtRUlOVkFM
Ow0KPiA+ID4gDQo+ID4gPiAJLyoNCj4gPiA+IAkgKiBLVk0gZG9lcyBub3QgZW11bGF0ZSBhIHZl
cnNpb24gb2YgVk1YIHRoYXQgY29uc3RyYWlucyBwaHlzaWNhbA0KPiA+ID4gCSAqIGFkZHJlc3Nl
cyBvZiBWTVggc3RydWN0dXJlcyAoZS5nLiBWTUNTKSB0byAzMi1iaXRzLg0KPiA+ID4gCSAqLw0K
PiA+ID4gLQlpZiAoZGF0YSAmIEJJVF9VTEwoNDgpKQ0KPiA+ID4gKwlpZiAoZGF0YSAmIFZNWF9C
QVNJQ18zMkJJVF9QSFlTX0FERFJfT05MWSkNCj4gPiA+IAkJcmV0dXJuIC1FSU5WQUw7DQo+ID4g
DQo+ID4gU2lkZSB0b3BpYzoNCj4gPiANCj4gPiBBY3R1YWxseSwgdGhlcmUgaXMgbm8gbmVlZCB0
byBoYW5kbGUgYml0IDQ4IGFzIGEgc3BlY2lhbCBjYXNlLiBJZiB3ZSBhZGQgYml0IDQ4DQo+ID4g
dG8gVk1YX0JBU0lDX0ZFQVRVUkVTX01BU0ssIHRoZSBiaXR3aXNlIGNoZWNrIHdpbGwgZmFpbCBp
ZiBiaXQgNDggb2YgQGRhdGEgaXMgMS4NCj4gDQo+IEdvb2QgcG9pbnQhICBUaGlzIGlzIGFsc28g
d2hhdCB5b3Ugc3VnZ2VzdGVkIGFib3ZlLg0KPiANCg0KUGxlYXNlIHRyeSB0byBhdm9pZCBtaXhp
bmcgdGhpbmdzIHRvZ2V0aGVyIGluIG9uZSBwYXRjaC4gIElmIHlvdSB3YW50IHRvIGRvDQphYm92
ZSwgY291bGQgeW91IHBsZWFzZSBkbyBpdCBpbiBhIHNlcGFyYXRlIHBhdGNoIHNvIHRoYXQgY2Fu
IGJlIHJldmlld2VkDQpzZXBhcmF0ZWx5Pw0KDQpFLmcuLCBwZW9wbGUgd2hvIGhhdmUgcmV2aWV3
ZWQgb3IgYWNrZWQgdGhpcyBwYXRjaCBtYXkgbm90IGJlIGludGVyZXN0ZWQgaW4gdGhlDQpuZXcg
KGxvZ2ljYWxseSBzZXBhcmF0ZSkgdGhpbmdzLg0KIA0K

