Return-Path: <kvm+bounces-18985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E61568FDBA1
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 02:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC9441C21F85
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 00:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65CE1CA6B;
	Thu,  6 Jun 2024 00:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0QLMyH4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55853A7
	for <kvm@vger.kernel.org>; Thu,  6 Jun 2024 00:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717635076; cv=fail; b=qaLOBJrkxj8ZZ7x0RVxM2tlWXCiuFnZV51Xn2vsIQcasLvD0F4L/BZb5UfF84hUDKNjai/Hvgc+YfN7yRzkQmfwj/vdhCbeG5YYHfHRBXRkyFRClHW5gSeQ49+WbqNGaVk+9/Av7iauYniKhcYdbNTSYpzRp/4afqNx5qsmn/ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717635076; c=relaxed/simple;
	bh=tnRfCl7D8rlUAeEfqTvsRytyuagvzH/aCcLkfBbcchA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B1J684vkUuL26pRihe3t3v55xKxTXJFUaIAKiEmgwF6nAcPWTRnNXjRG8TG33K2QwJUVuFp91HUihNTFJzuHdNc5EhrR26mHEtaeQGjdsBsObVEDne4/HEnSNmcVNMi7W+82SCVxCVb3OTAtykPb0tRUu6u0pZOm+8YyRnsmfvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0QLMyH4; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717635075; x=1749171075;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tnRfCl7D8rlUAeEfqTvsRytyuagvzH/aCcLkfBbcchA=;
  b=J0QLMyH4lADGxUKSmSvDzccHOBMaD1AEOZRVXG11zy/b3use9X755YQI
   phXxn8MOQV6nEOpkAfllQJrUSRE10i4XpOuAp/FbcrPqCzhdDiK4ZWg0c
   X2wTldUd9esly8hV04hinWRkXpm43y6yCBTgQG4d2kDLLATF7eQPun/Ud
   40zsNvatUFzlJeUlaUahKhcQZ3NLYn4xbpCqgrvC6EP5CpyM7+6t9jP8k
   C6BbF2Z4dzwEK8wBHExiGE9necPNH4vOVJON4z1Kaeil4EvO41C3o2wQ3
   IhE9IiHdCAnMSXoFduaqpVfFTr3s9QONpeu8SvjBbVNtM2Hf+rRJHXgsy
   g==;
X-CSE-ConnectionGUID: VCGD5OCgSby9GuUnkLaB+w==
X-CSE-MsgGUID: UFiBuFUkTO+rnLnOCZl7IQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11094"; a="14433556"
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="14433556"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2024 17:51:14 -0700
X-CSE-ConnectionGUID: NQz6YR/LQ8+DVxqkf0yMxw==
X-CSE-MsgGUID: ogfht6KCTMejJ0UrCIfH5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,218,1712646000"; 
   d="scan'208";a="42239522"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Jun 2024 17:51:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 5 Jun 2024 17:51:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 5 Jun 2024 17:51:13 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 5 Jun 2024 17:51:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0ivn8SL/c6C/xRy+8JQXtKGKNTH1VWW+AI/sCb5I32VsMDNxeCH72hTnzIDXhB644OwynORy6X5kV2KrGsdzBPUBpIUwlaNvgX8TB3X7s4CLtdpCIpfy4L3SRbKWOIbcn13C5Mwc1v3ZTYzQD2Wu4MpzmSWehoCWkYyB0ABeUQ3wThjwgDwUYiThkG88Ln232eLpTOQo0I2S2EkXfAN5RT08B5n1tK2aP1FBQxY6OQ957InOezTmw/G/0yODD8MdnWlb8cdJBQ6BX/YsoXKfpFWYh+CC50pTsLbBQPy+sfp9KEdxDgspmrqh6hXwZAIreclgpsjB+rlI/kS8PTy1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnRfCl7D8rlUAeEfqTvsRytyuagvzH/aCcLkfBbcchA=;
 b=NNOGbwpmXPFeu4oL26w/F+b1+CQUCF99odKkogY5/S60BXvrYVDVJEQ1PExD5q4Yk1f86xURAIaYvHe2RKEFZHLWgW8sY1/UXqOzQLMx7kcH/wBJ4ApPLMYdQBb3CDbdl8bz3g2CDu125xcnyju6vMT3k08nKV77WWbxNeBUklVPwCbElYZNc9UqlaS6C02M/O9835wsrpDf4qp19sdy3l2IVGuKzoYleNVucHd/7joyuwnixhxWJ6wRm0wZ41tGi2HR44hv5Se/fsNQzozTAc172LN5F9qya5f+E/P6B3NMWtvQmBviD+5yNs6mWvjV7RaL5iNBsxTCwC32pRRPHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB4824.namprd11.prod.outlook.com (2603:10b6:510:38::13)
 by SN7PR11MB7589.namprd11.prod.outlook.com (2603:10b6:806:34a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Thu, 6 Jun
 2024 00:51:10 +0000
Received: from PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::fa93:2029:3d0b:fb99]) by PH0PR11MB4824.namprd11.prod.outlook.com
 ([fe80::fa93:2029:3d0b:fb99%3]) with mapi id 15.20.7633.021; Thu, 6 Jun 2024
 00:51:10 +0000
From: "Mi, Dapeng1" <dapeng1.mi@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Like Xu
	<like.xu.linux@gmail.com>, Mingwei Zhang <mizhang@google.com>, Zhenyu Wang
	<zhenyuw@linux.intel.com>, "Zhang, Xiong Y" <xiong.y.zhang@intel.com>, "Lv,
 Zhiyuan" <zhiyuan.lv@intel.com>
Subject: RE: [kvm-unit-tests PATCH 0/4] x86/pmu: PEBS fixes and new testcases
Thread-Topic: [kvm-unit-tests PATCH 0/4] x86/pmu: PEBS fixes and new testcases
Thread-Index: AQHacBpiqBZE0wFcf0iJ+csRBjd+77G6XcwAgAAYjmA=
Date: Thu, 6 Jun 2024 00:51:10 +0000
Message-ID: <PH0PR11MB4824A827E5E6708E3C18DCAECDFA2@PH0PR11MB4824.namprd11.prod.outlook.com>
References: <20240306230153.786365-1-seanjc@google.com>
 <171762865345.2913907.8007283655193550688.b4-ty@google.com>
In-Reply-To: <171762865345.2913907.8007283655193550688.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB4824:EE_|SN7PR11MB7589:EE_
x-ms-office365-filtering-correlation-id: 52b9d76d-1db0-4849-e489-08dc85c2c233
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?Ymw2TldDSHlkdTAyczdvbUlQRk1QcnpTdGcraFNFTkpOdEc5NnUwVEVubUlp?=
 =?utf-8?B?NGJwcEdSTWF4MktyMzRWb1Jma2RZRDBEd3BmSWNnQ3FNdlhCNEpjbWZHZGVl?=
 =?utf-8?B?czhQdko4YlY5OFlDL0E3YU9DTm9XUkdlN1dRbkZESVVsVFp1QUNibXEzdWww?=
 =?utf-8?B?aXpkNDRDcjUzVk5FaitXVXZFeGhDdWlsZXQ1cHk3OXJITnBsUzMyY3lQY2Yz?=
 =?utf-8?B?WDN2Q0F5ejFRK2FuUWRDa3lMdXhDZXNtSmt2R3VVYmk2TXZjY1FYN3VBOHpY?=
 =?utf-8?B?Q0dEZ1ZacUE5a3FmNDJyRmpSb1paMXdIWlhjTnluSDZqTTJ5WG5TSURmcHM3?=
 =?utf-8?B?Rm5LR1VVdzJvdmgwVk1rM0lQUDl1NXp0ZHNIcXl1cFdCa2NEUG52bDZkMzFB?=
 =?utf-8?B?K3VCaTJhSS8wZWlON05PM2k5MHEvYkJiU29ENEM5bTMzL2pmOHArY1l6cHZz?=
 =?utf-8?B?TTE4dzIzenBxcU93bzQ5d1F3WGRhSm1jT0JqQjJvYzNZcmJlOGwzZXh1TmhO?=
 =?utf-8?B?WDd0YitMYVdRZG1JOTlMT0J0cmR1ei9JbWtGYUZ5MTY0UFRNYXpWTzd6dDRL?=
 =?utf-8?B?UlAyZDhqL0dhclp2VG52cGYrdlovdXhnbmRJWDJMNDAxRStKUm9BK041VEY1?=
 =?utf-8?B?RVR4ZDJYV2FiN0JscEJRUHBpSDl4d09uTlFqWkNaSGErRERKanlZcllsb0ZX?=
 =?utf-8?B?M2ZUN2lGaUNhK1JYWWdBYkFqck5rMnBxeWkwc1ZnQnlVRk9tZm44bTBoS2Iv?=
 =?utf-8?B?M3MyMmZoWXZ6MTdBMk5raGpCUWcyaTVQR0QwOG9RZzR1VGErNkdZV1o2cHJw?=
 =?utf-8?B?aVJKMEYzbTEzd3d3ekw4RVh4c2x4d3V4dnBSOHdOK24rK2JpVjNKMkFrTzlH?=
 =?utf-8?B?aW92T2kreUpvUUM1MnFzYzNvdGh5elErM09aa3dpbktLMG1pRGJUci9ZN2Ry?=
 =?utf-8?B?UDJ3ZDBxblBHSUpTcWdXb2x0M29Hck9xUGJWc2hHdzJmU3RtNU95ZUk5cmpH?=
 =?utf-8?B?c3BlWXBnTDl1YUNQRWZBb2VBQlpZMnJEZWszcFVxUVZiK1BFNUNsVU52MDhn?=
 =?utf-8?B?Vjc3SlFEMEhJTWNyRmozL2FtNW5uSlR1Q3pkc01PKzdkM2JGcFdjMUh3Y0Nz?=
 =?utf-8?B?bkVmN1g0M1FwZTJYaG41T0dnVC9nNnB3TFFTeFpucmgyNVBiTGJxU1JLSmVN?=
 =?utf-8?B?UGpvd2hYUUkrbmdsUTBURUI4SlloemNYMTNnWG5pbm16UFNXK3AwVWZ3UHlB?=
 =?utf-8?B?SEJxbGNyL0ZWSHV0S1hZVWEyVWlJZmdwaFEvcEJmcUdNWkVobWhUVGpOd3Zm?=
 =?utf-8?B?VHBEemtFdmQ3MXdsTzFoM2piR2UxQXI4d0x4ZmdGV0Fma0c3L08zclVibUdP?=
 =?utf-8?B?NGEwSjE0WXBneE93RUQ5azlGNndtWUxTL3YzNXo3RW41ZHJQQ3ZtRGFwS3M0?=
 =?utf-8?B?K3FXSzlxYUowQUIvV2VxMlRaU2N5R1B2cUV3UDdCd2kzVEtJWGQrOXFDKzR0?=
 =?utf-8?B?WmE0dVRSTkNidlJtQlBYZHBPUUR4Wkl5S09wdStUL0NHd2VzZmpBYjdCdWQ5?=
 =?utf-8?B?Ky9hMWZmdkUwWFZVb0NrNVEyR0R1RU5yOVVBNUVySFhiaWVvaUUzZWNGQzYy?=
 =?utf-8?B?R2srSXRSVlAxeHIxK3R2YWJrelBaNG5UK0JkRmthWVd3L2t4KzhDbDlLaUUx?=
 =?utf-8?B?YVhXb2liblU3ZzVaNVFhN0ZtTVhPNWhKVlExSmxqZDk0YU9WQUpLV3JZU3RY?=
 =?utf-8?Q?82t8l7ufm8bpwNULB0=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4824.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1JnV2cvckZ2Z1VlYk9Pa0xucWtzUlBZNHYySW1RSXhadE1pWHQ2bXhqV0FQ?=
 =?utf-8?B?aU5mSkJqV0RreHlWSmFPaUs3aUlyTjFIdStCSUt5QmtFU1d2a1orL1dPNWNy?=
 =?utf-8?B?ZHlTanppYzg3RkZNQWJTSSs2YmJjVnNGSzhCaTNVcytJeGt3dk5XZkFIbC9X?=
 =?utf-8?B?dzZQZkVLb0pGcWdDenlOd1NWQUtNODRQZTZ5QjY5Wk54ZmNhVENlUHdQVnRh?=
 =?utf-8?B?anhYUDR3OGpYdDUzOTlhMWsyR09mVThVQnJWVmt5Y1gvSmlPeXlhSDVFSFkx?=
 =?utf-8?B?R0RrQ2Fta1NIUDRjc0grY0JJTHllTGxQV3o4dVZYN0RYakhSTzdZd0Urc2dB?=
 =?utf-8?B?Y1c0WVV0c2EydTZuNnNDTDl5YTFFcjR5NlMyQVRPNHJFVU1lYkVxYktKUWx3?=
 =?utf-8?B?eWthUmlhL0xHeDdtT2FvT1ozeFUzWmxhU0hpZXp3L0JLb2cxTzhvbHBpVWpS?=
 =?utf-8?B?T3BHYUVtT1kzMTZqS0JPczdvMFdhYmRiL005TEtZdGQ4TzhlV0RTVk9ldktv?=
 =?utf-8?B?OXI5N2o1aVY1YlVJZFQ2TCtnRjhzQ3BZOGJtS0pEMmwvZ2hSaWlvRzRqT1p6?=
 =?utf-8?B?MlZyYmJzNkhSaXBuREhzbDRqdWRlbEJPOU96TFJyZFh1MTlPdnhtZGo2aXdM?=
 =?utf-8?B?WGV1bWZoZGUzMmdGdTZ2bW5VUGtzanRFMXhvaHlIdGRBTzM1bTNCTHdHN3lk?=
 =?utf-8?B?SjRQUHZtVGs5Q21iQjZBUEo1NHJBVzJ0dWpyem5UMk9HUnpyV0tIQ3ZHZ2Z1?=
 =?utf-8?B?VWIwcy9jRUp6TUNoaEpOOG5mV0JCZ2FOZFhxcHJ0NHgwbVZkYjk3bGFwSUJ3?=
 =?utf-8?B?OUFEalBVcU5aSzB0dXRDM09WZWwvOFBEZ3IvK1MxcWUvRWpkV0ZIU3VkMzZZ?=
 =?utf-8?B?cEt3Y0szVVVmU2s1blBQOE5ta2hndFhLc1pGQWJaK3U3aC91RU0vL0pBemYz?=
 =?utf-8?B?WmxySDFWbnhEYzhvdEs0NU1TU01JYVFnbHZPL3Y0T0ZjTmQwR1MrSVQyTFN4?=
 =?utf-8?B?NTNQQWhQeEwzYk1LZkdpcFZRK3QxdTlTblFnZlU5SW9SYmJZSDkzYzhVUVJZ?=
 =?utf-8?B?eFQwcVIvbmhzcXZwTDBiZ05teFRmem9Vc2dZNHpmWkFvbE1UMTZDNWI4Mnc2?=
 =?utf-8?B?MVdGWUZ1UnpCSzdZdVRRZTliNXNuaWdYeDc1S2Nkb2RoUkNFdDcySzRHWXlU?=
 =?utf-8?B?S3cyZys2M1lBbnk3aXltek5UUlphc1JzTkFyemdIZVNxK3J4TTVRTTYxNlZm?=
 =?utf-8?B?M3MxVzIya1VSZ0s0ZEF4NUgzSVB2MWhQSGxLbHlUMXhCakVmTnBNZncvQnZW?=
 =?utf-8?B?V2ZuMTl0bG5RcVdsVStiMUwzWGc1MHMwNVcrOWNxV0VQWjZYOCtWeGFjQXJS?=
 =?utf-8?B?Q3FNSHVDaCtwNU1ycTVoS0NYYXE3OE9DT3BaampJTUxndjVndUJ0VVQxem1a?=
 =?utf-8?B?aEo4ZTZhSXNwb2dUL2RhcU8zcVRtS3M1eHZ1RDl2WkpTNitMT2VoOUsyT0Zw?=
 =?utf-8?B?UHY2dGM5Wmc4Y2VGN2UzLytRRXEzMzRqUmFIVDlpMzlZV1BjMnZsSnphZHIz?=
 =?utf-8?B?ZnMrSU4xVm1MUldhMlBwTVRSbEZ2YTBEMHBucURvNDhQTDh0K3VQNU4vWUVy?=
 =?utf-8?B?VGVLN04vbC9tR2hsdlhKdkkrVTJhYlRESGQyRmU2VjlRd3BRWStxUFJMNGpP?=
 =?utf-8?B?SWNzYVBlMlJ0V0QybTR0SWFSUEtHL3BGVXFOaVJpQndpS01Jb3pVOU94SGQw?=
 =?utf-8?B?RGZHM0UzVlBvR0JtTWZMajA2YmtHbUlTekdtSG5iSlVMRTRxTWE2Qy8zZEV1?=
 =?utf-8?B?RWQrSStxQW51d3JqenV6cXBXUDlGVkNtNktDalFaVElCNGxKdTQvYzNkb21S?=
 =?utf-8?B?S1h6L2ZTWWlxb1Q1NUhvZlhGWjRIYUJBT2lxWlhLZmlMNHgwZ0RxL0NIQSs1?=
 =?utf-8?B?WVpXamMvR0hiMmgvY2FRZm9yY1ZKYzdUaUNFZDU2dDZPSlQwcVVzVmRlZ1pt?=
 =?utf-8?B?eWxubGRuL2hPNTYrenNKMHlCOGNkNjhuYklQNTFOdFlmbjR0WXYxMDBMOU41?=
 =?utf-8?B?Y3RlTDZSelNlRGhaVFdTYWJPUEZlc0dIUi9HMFlrWkhGZzV1aFpuNG5Ia29a?=
 =?utf-8?Q?h+LlXlOenWo7QNLOX4fGwbqdg?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4824.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52b9d76d-1db0-4849-e489-08dc85c2c233
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2024 00:51:10.7805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GgyYkkeybE9LhYuMYiFWN33vsA5oyek6GJtokZyKxiKddogEJtiChocBJd0zTJMezvNQsojzpi4dEmIvmPQZGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7589
X-OriginatorOrg: intel.com

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29u
IDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEp1bmUgNiwgMjAyNCA3OjIx
IEFNDQo+IFRvOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT47IFBhb2xv
IEJvbnppbmkNCj4gPHBib256aW5pQHJlZGhhdC5jb20+DQo+IENjOiBrdm1Admdlci5rZXJuZWwu
b3JnOyBMaWtlIFh1IDxsaWtlLnh1LmxpbnV4QGdtYWlsLmNvbT47IE1pbmd3ZWkgWmhhbmcNCj4g
PG1pemhhbmdAZ29vZ2xlLmNvbT47IFpoZW55dSBXYW5nIDx6aGVueXV3QGxpbnV4LmludGVsLmNv
bT47IFpoYW5nLA0KPiBYaW9uZyBZIDx4aW9uZy55LnpoYW5nQGludGVsLmNvbT47IEx2LCBaaGl5
dWFuIDx6aGl5dWFuLmx2QGludGVsLmNvbT47IE1pLA0KPiBEYXBlbmcxIDxkYXBlbmcxLm1pQGlu
dGVsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtrdm0tdW5pdC10ZXN0cyBQQVRDSCAwLzRdIHg4Ni9w
bXU6IFBFQlMgZml4ZXMgYW5kIG5ldyB0ZXN0Y2FzZXMNCj4gDQo+IE9uIFdlZCwgMDYgTWFyIDIw
MjQgMTU6MDE6NDkgLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gT25lIGJ1
ZyBmaXggd2hlcmUgcG11X3BlYnMgYXR0ZW1wdHMgdG8gZW5hYmxlIFBFQlMgZm9yIGZpeGVkIGNv
dW50ZXINCj4gPiBvbiBDUFVzIHdpdGhvdXQgRXh0ZW5kZWQgUEVCUywgYW5kIHR3byBuZXcgdGVz
dGNhc2VzIHRvIHZlcmlmeQ0KPiA+IGFkYXB0aXZlIFBFQlMgZnVuY3Rpb25hbGl0eS4NCj4gPg0K
PiA+IFRoZSBuZXcgdGVzdGNhc2VzIGFyZSBpbnRlbmRlZCBib3RoIHRvIGRlbW9uc3RyYXRlIHRo
YXQgYWRhcHRpdmUgUEVCUw0KPiA+IHZpcnR1YWxpemF0aW9uIGlzIGN1cnJlbnRseSBicm9rZW4s
IGFuZCB0byBzZXJ2ZSBhcyBhIGdhdGVrZWVwZXIgZm9yDQo+ID4gcmUtZW5hYmxpbmcgYWRhcGF0
aXZlIFBFQlMgaW4gdGhlIGZ1dHVyZS4NCj4gPg0KPiA+IFsuLi5dDQo+IA0KPiBBcHBsaWVkIHRv
IGt2bS14ODYgbmV4dC4gIERhcGVuZywgSSBkaWRuJ3QgYWRkcmVzcyB5b3VyIGZlZWRiYWNrIGFi
b3V0IGFkZGluZw0KPiBmaW5lciBncmFpbmVkIG1lc3NhZ2UgcHJlZml4ZXMuICBJJ20gbm90IG9w
cG9zZWQgdG8gZG9pbmcgc28sIEknbSBqdXN0IGV4dHJlbWVseQ0KPiBzaG9ydCBvbiBjeWNsZXMg
YW5kIHdhbnQgdG8gZ2V0IHRoZSBmaXhlcyBsYW5kZWQuDQoNCkl0J3MgZmluZS4gSSB0aGluayBJ
IGNhbiBoZWxwIHRvIGFkZCBpdC4g8J+Yig0KDQo+IA0KPiBbMS80XSB4ODYvcG11OiBFbmFibGUg
UEVCUyBvbiBmaXhlZCBjb3VudGVycyBpZmYgYmFzZWxpbmUgUEVCUyBpcyBzdXBwb3J0DQo+ICAg
ICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9rdm0teDg2L2t2bS11bml0LXRlc3RzL2NvbW1pdC83OWFh
MTA2Y2Q0MjcNCj4gWzIvNF0geDg2L3BtdTogSXRlcmF0ZSBvdmVyIGFkYXB0aXZlIFBFQlMgZmxh
ZyBjb21iaW5hdGlvbnMNCj4gICAgICAgaHR0cHM6Ly9naXRodWIuY29tL2t2bS14ODYva3ZtLXVu
aXQtdGVzdHMvY29tbWl0L2ZjMTdkNTI3NmIzOA0KPiBbMy80XSB4ODYvcG11OiBUZXN0IGFkYXB0
aXZlIFBFQlMgd2l0aG91dCBhbnkgYWRhcHRpdmUgY291bnRlcnMNCj4gICAgICAgaHR0cHM6Ly9n
aXRodWIuY29tL2t2bS14ODYva3ZtLXVuaXQtdGVzdHMvY29tbWl0LzJjYjJhZjdmNTNkYg0KPiBb
NC80XSB4ODYvcG11OiBBZGQgYSBQRUJTIHRlc3QgdG8gdmVyaWZ5IHRoZSBob3N0IExCUnMgYXJl
bid0IGxlYWtlZCB0byB0aGUgZ3Vlc3QNCj4gICAgICAgaHR0cHM6Ly9naXRodWIuY29tL2t2bS14
ODYva3ZtLXVuaXQtdGVzdHMvY29tbWl0LzhkMGY1NzRmNGU0ZA0KPiANCj4gLS0NCj4gaHR0cHM6
Ly9naXRodWIuY29tL2t2bS14ODYva3ZtLXVuaXQtdGVzdHMvdHJlZS9uZXh0DQo=

