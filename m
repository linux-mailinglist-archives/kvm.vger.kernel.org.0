Return-Path: <kvm+bounces-26452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 55596974857
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 04:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1217B2874CA
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 02:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BDDD3BB21;
	Wed, 11 Sep 2024 02:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBdFYb6y"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C919138397;
	Wed, 11 Sep 2024 02:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726022986; cv=fail; b=Bk82HIhAbtuXiAhmjGOu+cWGgNotGjaGnpLLjPE3XC41ltV6uT7nAarsDMOfC20t23Ocb+r3xIJYxyzuaC9kUFII/V1azOBObkTmY8RRD7YWBr8NeMJDNKbWeaM+Hpj4Wvmm3eVNXlASbl+/COTR9FwGTrpmCsOx8e4UlBSRvhU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726022986; c=relaxed/simple;
	bh=SHnz/Z2vGcelNTfWN7/x6+Dq8sPuxnDd7i7fJLruOo8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=azoDiwXakdi4Sa0tQvl7f+EMUl5oc1we9U8ErRyCKcm7/fSYQ8ItMqVgKwVR113yNHbP9At4uU3Whpqr2CPEQD7lKYK0gICnX1Q25qoqipegCc3zGNzF65pUgC9n141D2o2fYyp/It10pDZJg26USjWutHqTGwg+Ja95l9leH6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBdFYb6y; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726022985; x=1757558985;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SHnz/Z2vGcelNTfWN7/x6+Dq8sPuxnDd7i7fJLruOo8=;
  b=KBdFYb6yQuj+glVhgHIeOzw2iNvISsB3SvDHcCVMIhw+jLXNTgW3yb5J
   Y8IPFwu63oBdbxgbSaT+5QxdgaWfhb18J2ZzhQdY6pWbFEueOcDB8Cyff
   BVNu2hPLjWLRjPmwp/R/BPII0tH87kDSwILEbvzg5jLYackpNx/PxiPaB
   oqCFTux34UVtvGzhwmlqhmf4noVYilkQYwNi77yLWEz4imKs9zHcff8If
   DtoQYPcUAN+cmlURmnxGXCfrmykYWUCiHFznx6PZJW0SSaUJwj81JnnKR
   QojLuwdXn3PmOiMC0W1TldWGt6LQLMQU2SzlWkyp+/QNibeEoYyTtJDkh
   A==;
X-CSE-ConnectionGUID: 6dIfLJczSfyG1sSUg5E/kw==
X-CSE-MsgGUID: X2lDBSVgQqO3QDw/IcDx/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="42280032"
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="42280032"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 19:49:44 -0700
X-CSE-ConnectionGUID: psYIlZ9qTA2vWlWHhDKG3w==
X-CSE-MsgGUID: xwBL2hthRVWwuYX0j3tTIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,218,1719903600"; 
   d="scan'208";a="67068063"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 19:49:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 19:49:44 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 19:49:44 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 19:49:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bLbjFeYGbKj2O6PdCf9jVL9jTiLcMbYUmKtuaMCi+SQ1dU/LRdeCOMIHtY2vWG1/zVdRsCsBbs5EbLEzc/bIgVLoGV2f76MHNdp0oF1uqJj7oRODvDkmSSDC93bubwhWXx3M8lOWXVk6k5QZrPZVbk5VKQyT3CTExnXVPbEg0r7r8Gg30eIOp8QV8BSd33AFXMOqYlyJFFjXZ+kh8m5YDNhwxS44Lpipqa1DUrGe9HvXKJ+u2kHvPzJnjxj364/lrUOJ5Hhp/8EUH1DdLDnDlBPURkYmcKwOWM7CdAFwOd5Ia2GytVFwllUZ+Rl99qqNWaEmknfblU/NCrbVr6v3Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHnz/Z2vGcelNTfWN7/x6+Dq8sPuxnDd7i7fJLruOo8=;
 b=nwZik/NKwW1D+5RKntI5gi2M0zTulkpnagi5fSsi2DiNxgrzr9GfHqyVXvctvq18VNbkYmYKAxexPeqZVGvr3Kh0qcAsLO6RdXY1CbIDkb6jIg0V92BcjMPnE0OlZMCOYeFDHpPkF1LjBFm+N3VnYC1Ot6iwZLWzNYIATrsKCliyMR+Gc4X+lwtE3fLaunF4MXP7sVXE0Fg8yVnst//ZMjtqVu/tb8UkxNoBfUpD8MI95ACcfplEafZNlANM4cqpO6PRhVGKUIHZD2GEeRsXI13nvPeCZ8d1yfxeT8EuO8+Utytq1tOOrz2oUNDwynmIYjmGppBy9mve/gR7R8V3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5299.namprd11.prod.outlook.com (2603:10b6:610:be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Wed, 11 Sep
 2024 02:49:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 02:49:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 07/21] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Topic: [PATCH 07/21] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Index: AQHa/nevS8T8CHGyE069KHS2CZ0GrLJR7SKAgAAAaAA=
Date: Wed, 11 Sep 2024 02:49:36 +0000
Message-ID: <6a96cbda177a04434b8b26c3bcb04a60de5a920f.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-8-rick.p.edgecombe@intel.com>
	 <ZuEE6fflBualiidx@intel.com>
In-Reply-To: <ZuEE6fflBualiidx@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5299:EE_
x-ms-office365-filtering-correlation-id: 0e22ee50-5d8f-4281-b410-08dcd20c5fbb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SmpSNDdwdE9kanFsMC9PUXFBZjA0VkxZa2p4UGxlZ0I3U29NMWkyOEtHZTVW?=
 =?utf-8?B?dU5nSkk2RG5jMjY5S3FRVWhHa3dVbWN6SXhKSllTdzQ2QUo3SE5FM05oYUow?=
 =?utf-8?B?MVk3L3lrT1NBdC9DS3lZYUkrb1JjNnZqOEkva2k1UUNZSHo3WnltcTVlZ1Ns?=
 =?utf-8?B?NEJldUNDV0sxQ2EvK2p3SlZhNVhVUlREazE3Wkk2cDIvYlBHeWhjN1V2Mjly?=
 =?utf-8?B?T0JjL0tzREl6dUtGWHhtUzlWSU0xUlV2VlJGRzdZaXM3NUhRSzgwK0dLSzFB?=
 =?utf-8?B?eElmSTc2dzRHVC9oTkJ0RzdMeVJCNGVxRjAvRSttc0tGbkFlOHRiRDVTNmh4?=
 =?utf-8?B?ekhuRHluVmJ0YTFYbXdQOUc1L2kxNzJnNWY0NFZnMEVXZ0dMMlY4ZFF0dG5K?=
 =?utf-8?B?ZVl2NDJXZW16QkI4VWdSZGt2UFpUN1ZEa050MWxoa1p2aEJWdkFLVXVwWnU1?=
 =?utf-8?B?eTRjRVhKZGZVdjN1L2xDL0RlMGpqNHV2MHROMlhKeDloNzNtZlhZYjU5NG80?=
 =?utf-8?B?dmpSajllS1JOUkRPL0NpRnF5OVRkTW8yZXZkZStxZWxkK2lnb1drT3JOVDVS?=
 =?utf-8?B?ZldvOERyWjZIamlsUXdjcDhTTVUzd1A3R0YyMms2c0tiaTBDZ3NkS1pRakRj?=
 =?utf-8?B?NUJJWUppWDhIWWhNTXhwSGU1S0xjNk9NYkFid0VGT2tHZ3JLNGNKYXhTL0w3?=
 =?utf-8?B?UHZLeTRwU2FQUHhLM0E5cmxJaXhvVmdodUgrYnZ6VWlFZEVNM0VXMGhoaHBT?=
 =?utf-8?B?QmZUVkU2QThIazJPS3Q4bUFBN0p2dXBsUEUxSDREc1JuSjlHQWJCU1JCQVND?=
 =?utf-8?B?OTJQSFZ1M1NGZFl5cTJCU1cweCsyekROaXZoRXc2b2ZDQ3drSXZCRTFlZzRx?=
 =?utf-8?B?dDhkemNXd3dNOE1pMzRpdnh1Nm15QVY0MVowUDYwQzROS0JIYmpWK240Qk5Z?=
 =?utf-8?B?RjJCSlpwcG11L09pSk1mTlRWTDFUS2t1ajYwNk5UQnBySUVsbE1UdzZoS25z?=
 =?utf-8?B?QW9vSnhDY3M1VTgzU01HSWR6czFUOGFEaS83RlR1VEhRS3lyaGRQRDcwMk83?=
 =?utf-8?B?dXJqYVZ3c05UN1JIcDZBY2xFVHVyaFo3QzNLSHMvRWErQ2dHKzA1WWdyUSto?=
 =?utf-8?B?cjgrUU1lRDlWbzBQMzFrbEc5VlFudklLRU91TGptV0kvTWZ6eTBZWkNZWlFk?=
 =?utf-8?B?YnV3VXU1OXZNenBWS3NURmRROTFJYVdBUlMwUUhVdVg1RkNWeTJEdnR3b05s?=
 =?utf-8?B?ZU9Qd1BiRTlvVUY4UTBmL051UWJqbWFXR2VtVWNiandESjFNN1VtN3luM1dx?=
 =?utf-8?B?Qm5pUWtvcTJPOTZ2eDJScVp4ZGN1ai8weGt0VkNQQzdxZzVFcGpSazZmR3Vr?=
 =?utf-8?B?dS9vVHdBS1g1KzNSN1hUcjdra0taZ1hlRnN6RTJoT3lmeXhwYnk1UTkxNWo3?=
 =?utf-8?B?QWNxY242aTRzblNmK3ZaRmIrMUJGTDRGM0dZemI2SlNWallncVlBYm5TT2dW?=
 =?utf-8?B?enhtMm5JdkVqc2NITysyTHl2MEdTbVE3SW92ZTkyOU5rRWNLcS9PcFBUSk5j?=
 =?utf-8?B?L3BoVjE0R2ZpTnNVNGdHcXBtckY1WUt2NTNDZDdHMUVQQkFWNXh3RFNsWlF1?=
 =?utf-8?B?QVV1Vy9ITVo5S1JYWVR6OWV6MWRyNC9wbUdmdThKbktIUkJpWG0xTjVnT2xx?=
 =?utf-8?B?K05nSnV1WUxwQUdzYWl0RGpWaHYrZmlUTTFBRVZ4bHYxVUpWRjNXQnY1WXZW?=
 =?utf-8?B?QU1IZEtwWmhIV0FtRm5rQ25yc2FhLytYKzRwOW9NZXhOMEJRRlRobExieExN?=
 =?utf-8?B?ZEs3WDc1ZXdIV0Y5S0pnT3RFZ2M5SFU2T01rZFJiczZ0NW0zMFB6bVljWDA4?=
 =?utf-8?B?SENRZGRuSTc2dlN4K0FUY1ZBR2tPZm9WTlpUcXF5a0luQUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TW16Q3hkcDk3eFlnbU8xeTE0eHdBc3ZiMUNkeC9jaUU5ellia0RscmdjTHF1?=
 =?utf-8?B?bUVBZnFkcHVPYm1BSDYyYUVZK0RnY2g1MlZpSlRPUExZLzladmZxWW9xQ2pD?=
 =?utf-8?B?Ky9INkxuTFBhdGc5VzJ2bDEwek56c284dUpXRnEwMTF2ZUpRcTNONWE5ZG85?=
 =?utf-8?B?ekNhdTY2Umk2Zjl3amRzWDZoU1cvTW1KNWZ3WTNnYTlxOU5NdnRpMjE0MGdy?=
 =?utf-8?B?QVRCYzJJd0JPVXh0L0JTRlZvUlNtdWoxa1hEVXY5a3BKMFFkUSs5Mm9uMTlQ?=
 =?utf-8?B?bi9PZ3RaYjVMVG9VY3I0MmJ3TnM0MDMvNGdLVmRQWkxJZDBkMHdCMFZpMFls?=
 =?utf-8?B?V3V3NUhkNkF1MVNKckFyaGQ1NUkvMUxnQk5VODVBK0NvN3Ztbnc4Q21jK0VQ?=
 =?utf-8?B?Z3kzU0VqZkFCdHppNUVKRzZRbU1PVjQxblRxZ2lmY3pZUStOWXd3RmJ1UEtv?=
 =?utf-8?B?cDg0ckFFcGpWS2JrUGZQQ05keXZGcUExVzRFRG16U1gwNE4wRk1jT2UzRGd1?=
 =?utf-8?B?VW1yTThKQ1FCMVBzM2cvRGg0WUhOS1pjOFJjemFmRjBmT09Wc2diRXZaa1dZ?=
 =?utf-8?B?Zk9icjM0RVAyUUhLYmlTWUo2ZXlLWGhYK0E1bURNTDZUOGY5aXFqblVSaURu?=
 =?utf-8?B?cFFnNUsrcFhGZVdOUUsvTVJqVmJDY2VzQ1JUdXF3ZklDY3BvdkttcXBVc1lJ?=
 =?utf-8?B?NWdqaXllOVAvdGpJamhGZlRieWdSUSs4WGprOW16aVNuM3VtWWNWUk1QNlg3?=
 =?utf-8?B?MVNHS1hmaDZOVlkwYzU3TzRMU3E0ZG5QdHdITmQ2R1VJYVZSenM0OTBHRGpV?=
 =?utf-8?B?Sm9FdkRWdVA1WmJOc3R4VWgvcVoweU85aUx1S25vdWtLZFFYNjJuOXl3QnBC?=
 =?utf-8?B?TFJGS0dmeGNFRzdrcTNKVDJtazFHRERKdWpVOG9MNE5ud3hLcnp1aWVHbVJ6?=
 =?utf-8?B?U01hQ2doaHBHcXl5UzFOVVpwNmxDclYxckJtZlRtVnZ1WUF3eVptRklqUWta?=
 =?utf-8?B?b0dTYVltY2xla3pPcFJFQXprejJJTmRRcFNRWkVUVVUwS2pCWWcrMDVYc003?=
 =?utf-8?B?NGRXcmtEdG51ZWZ5dXdGSDBscmFiaTlGUHRuT2tDRHVzSjdOQVhaYXEzUXNm?=
 =?utf-8?B?REtCMkt3R01RYlF1VXhpa3ZPc3hQbk16Q0NKcEI5Zm1ERDFXRWRWbnFNUWxs?=
 =?utf-8?B?NFRTbnhMWk1Uc1JJSmFJY0RLSnhlOHB0MVMwVkN0KzgyWlc4TGRZNllDNExu?=
 =?utf-8?B?V1FuR3g3MDVMTXdCVENseGthdWFHaHVBWEZDREJTaVhyVUVLNmRjRTJOZzgz?=
 =?utf-8?B?TS9XWjIvakFhTlhtcWk2cE4yMTJYRnk1b0U4YTBRN21lSk54THRPbGQ5WnIv?=
 =?utf-8?B?bzB6MXRPeDh3RkJJaHpHYmxqNngvRGUrR0dHdzhpN2s4eFg5RmZKSFhYSkpl?=
 =?utf-8?B?RSs3OWI2RzJwRVh6cFUxeDJvMXlQcHFrNnB3dWpjZUwweFhOVFZUN2hhWGhs?=
 =?utf-8?B?aTByV3hsTVhJcEJRVFEwT1dlTkFYb2tTa0FtTkRYQ2EyVU9uRE0wOUxnZ244?=
 =?utf-8?B?TENKdHlkSkQvQk5KVUVTU1BrdGV4WmtpNDNaMldOclNKRGtuTUpvL1dxeHRv?=
 =?utf-8?B?ZTd6cWNFV21yN0lVWXNRc0JseFpWcjFETzB1Vk1QVGdIOGhPSEkrUUlnS0VC?=
 =?utf-8?B?Y3RLa0xFQ2NNYU0zOUZsOW0yZGd0N0JTQm45OEFkdXdYQUg1SXc4K0M0MHds?=
 =?utf-8?B?eXNjRm5vSXdUalUwMFdrcjY3MDFRWGR6c25rY1JvSm1KYjcxOTdlbGZIMkZl?=
 =?utf-8?B?RmZGVlRTVzQvRDAxUjBUSmpIQlBSTU0zak5ZeUE3bGI4REcyNFBwcWtsN3JB?=
 =?utf-8?B?VWcxYnJYbnp4Y3RwYlBqdlBZdVA3R3RKZmRVOTNLL2pidlMzbHhqa1hBTDZK?=
 =?utf-8?B?WlZzRlZiNW90aE1vRVFuaGliQVFtelp4Zi9RZjkxZ0tIcEFKUzQrOGEvdHY0?=
 =?utf-8?B?Sm9RODhTV0RxdEpmSG5jM3hYUVpWLzBZUzVhYnlxMzRUV2dMbDArRm1OUlNH?=
 =?utf-8?B?THpJV0l3U29rYjBVbjNWMHREZlM1STBhQ29YK1dyOVdsbFI3REh3cGJQMm52?=
 =?utf-8?B?SzN2czZPVUhvSTVQWng5T0M3dlR3dndLb3NlY3JRdE1SNnp6V0JNNjFRVGhO?=
 =?utf-8?B?Q3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <882F4583AEB12244BD2D0F6F0952D85E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e22ee50-5d8f-4281-b410-08dcd20c5fbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 02:49:36.6871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aztTsN1TgimltZuuTi7IVUHGrGEMCYfIA2qs6uTCu4LbWXDXmmG+js9Uh4v22VdA21ZJvAXUu5eVy8HZlm9neCFaShBumupN2R5QMEpn0Sc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5299
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTExIGF0IDEwOjQ4ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiBp
bmRleCAyZWY5NWM4NGVlNWIuLjhmNDM5NzdlZjRjNiAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL3g4
Ni9rdm0vdm14L3RkeC5jDQo+ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KPiA+IEBA
IC00MjgsNiArNDI4LDExIEBAIHZvaWQgdGR4X3ZjcHVfcmVzZXQoc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCBib29sDQo+ID4gaW5pdF9ldmVudCkNCj4gPiDCoMKgwqDCoMKgwqDCoMKgICovDQo+ID4g
fQ0KPiA+IA0KPiA+ICt2b2lkIHRkeF9sb2FkX21tdV9wZ2Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCBocGFfdCByb290X2hwYSwgaW50IHBnZF9sZXZlbCkNCj4gPiArew0KPiANCj4gcGdkX2xldmVs
IGlzbid0IHVzZWQuIFNvLCBJIHRoaW5rIHdlIGNhbiBlaXRoZXIgZHJvcCBpdCBvciBhc3NlcnQg
dGhhdCBpdA0KPiBtYXRjaGVzDQo+IHRoZSBzZWN1cmUgRVBUIGxldmVsLg0KDQpPaCwgeWVhLiBH
b29kIHBvaW50Lg0K

