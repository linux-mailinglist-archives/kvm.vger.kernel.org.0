Return-Path: <kvm+bounces-55737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89E54B359D0
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 12:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45C7C5E7026
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 10:06:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D39A322763;
	Tue, 26 Aug 2025 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kE8Wc3op"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4B42FB97D
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 10:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756202794; cv=fail; b=n5cWDxmMbxMavNkdg0I7tfj+qRCI3ZYeE/OhgeWA4gX/KTOGsoFVPmXUK2r1VekyoQg8NONappR3l/GijMvA+6W1Ca/AFa7Kai9G1u++HUSmTX33H+FTB8kcSFHGS3zhe+pEFLB9w8nNDEvNbjy7QfDAoAcN6Z1uR9KXZOmO8Lg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756202794; c=relaxed/simple;
	bh=rYam/uhtFFe4SncCVvyBlPl+8BgNz4TGtXFFoHf5Esk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gpuvdAFFXG8XxZOuWU+dhvPmfhxowGr/c2vNFau5Q0MNGIMxqWm49LoIzlKEo2w91Iapm/knVs7b0lXzp7fYCXFxAYsxnGEBqHOjOxTQS54qkmzIAX1Lgm2fN4URd8AlZvN6Two37HkFsduFTUYZ640sijbl/93TsetivPWDE8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kE8Wc3op; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756202793; x=1787738793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rYam/uhtFFe4SncCVvyBlPl+8BgNz4TGtXFFoHf5Esk=;
  b=kE8Wc3opCYYHPJRr4iH7CEbyrq+27Pak0w1Yh8sw8b9UGPpC3dwJDPb8
   LfFtnedcZ1hwDeLr5TpONWTccftay5GHoiR8ci/kONu81pEElxwNzT6Fn
   YLzhD0O97ifQDP3pLbx6UVMj/WUy6aipoBWg2ZksSSnxSiG/x5YDuHK6U
   5yoRI72K9cw+AkqJE4CyjcIAti28n28iot/HkP0fe1e6J89cFsKhIwaVt
   0PRPW1dESXJ/TDdISI34PYM/IEQgkhUBYqDbI70f9qkyoSmfJ80WeowmQ
   rq5VAjBoIHLJx2Hjp2CfXhQuEnFhteX5nSCVMwxUHIrkBi2Hr5E2l9MB2
   g==;
X-CSE-ConnectionGUID: 9lZ3XR90Sgao5KtXZjcj8A==
X-CSE-MsgGUID: 0wYsc1YsRLuMZkCVeOOdLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="57632196"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="57632196"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 03:06:33 -0700
X-CSE-ConnectionGUID: RoagnmzyQ6CBFqqEvXJ3pQ==
X-CSE-MsgGUID: Z7RDbSHBRgiSFPmo+DsU5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="173710062"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 03:06:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 03:06:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 03:06:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.43) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 03:06:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ugaKniiXmZU3jFc7RbGfcMhj19rMQ7mknRZHkVWqP8gvjaLN1R0BDqeR9yz1CRYvKdYOH61U49qsS+vxpvx8C5j6fWIXrWIde1634C9f9ImXzGRKcMKQgymJyYI8hcgPQKfwJ+icLEQMVk5W3OBT3EpMDeNIkgHGwrw9ojwQH8ZsOC8082yToRrXy9REOJUoZ60Gq7BS2LiAW/GJivJssE+cidAUQ3ACkCfRSLX4Q6wNF5NDohO50uheV5V9JKa/u5a2YfIZ3hZanbunTF+cZMNTou8/YQ1gqIAO+unPRYW8lNKDPWFefTDyD0nua5EQhq15n3565EFB2cGuAfENqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYam/uhtFFe4SncCVvyBlPl+8BgNz4TGtXFFoHf5Esk=;
 b=uTSKsL14glVF2BvmF885qCXosVcCoE20rvW5DV9OGKPvFX4mV2H+JY+k1ILsQNkXjAikLxye4MFTRpmcRGkyzCSRZEM5kMGOap0ty+7eSYSsEL1zFty6virp/vJXlltAgIsqHA+EaV+3bLnNnUesXThDxvOYuX214DF+c7rBTFVvzTsOHB2wcwGLzJncdSebQXLbgo5YiRDzaA6sNi2H9+WXMpdQ/1nJAHTNn0MsJ7pW3kjd19SLZH+EZCMTJo40JlC5QT5TItPsl2XGUHNfixJn6KHo0jrd1JUj/6o6g2bxqQI3ohdCXgjI4qbOoz3kntNmELWjgcir1bF8AIZXfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB7881.namprd11.prod.outlook.com (2603:10b6:208:40b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 10:06:28 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 10:06:28 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
Thread-Topic: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
Thread-Index: AQHcFdP1txaByN6LJESEbTad649TFbR0toAA
Date: Tue, 26 Aug 2025 10:06:28 +0000
Message-ID: <84a1809495eb262c26987559a90bc80f285f1c0d.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-2-nikunj@amd.com>
In-Reply-To: <20250825152009.3512-2-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB7881:EE_
x-ms-office365-filtering-correlation-id: e7657cb1-cbc0-432a-3f9c-08dde4883932
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OFlCVS93cFNLUGZJZnVoRzl4WXhXNHZwN09yRTV2bC8xbFVLUVE1ZzNlM2Vu?=
 =?utf-8?B?TEg0ckZYZ3czVHlPZ0Y5WlovRnovWHgwSmw0L0NrMjZuaXFBd0ZGMEdDLzNK?=
 =?utf-8?B?dzJ0cXh2TUpLYlFZZk1mRzJYZklQZzliMnpBRDMxUGVoTkhWTDVUS1BVbFpB?=
 =?utf-8?B?b0JZUE55L0dMSVJrQnhhL0VxUU16UDloRUVjWW91UXo2aEF1bktUVENjZ2dQ?=
 =?utf-8?B?U1lWeE1KT0dNTWZTUkNnSytsL1l0UUl5bDhVVDl6aFFJWGxkMk9PZ3VkN0oz?=
 =?utf-8?B?byt5MmtCdm95alRXbElWbjJlS2FkYzVCODU4R0lRYThZY3RmYWNTVDdhVStx?=
 =?utf-8?B?ZFpDUENhbUVDSUZMeWpTTGZqUkN1bExkRzVKUGZodmtqaG81QUhFU1AzK0Vv?=
 =?utf-8?B?MXRhaGZteUFxVnFnYUtjcGlFTEhnUEkzUmtaTjIycURPUkVUeWRDVlh2WVFl?=
 =?utf-8?B?NEFaeW45ZUlLSHBCN2tncDdmdDA1TTR0UU9DVktQT29kbFp4dFFRZFZPUy9R?=
 =?utf-8?B?TXNaY0tkQ1JJL1VQZm1MR29oaUJxRFg1cll2Z0VscGZPWjdNS3gwT2ZTSnVw?=
 =?utf-8?B?ZWZ4MFIzRXV2SEJVUUl6WVJYdnFwTkcvMHArcTVtWnF4a1I2NU51OVVTSTZC?=
 =?utf-8?B?Uis3WC9qTDlERzlmc1FxVVpKbkQ3VWY0Q1NHYWh1ZHIweTJOYm9iK2I5VFZD?=
 =?utf-8?B?SCtrS3VWazhUK1FpTGZoZW5DdWUxbTRsTVh1UW0vNThhVGFhRVJmYzZXUEdW?=
 =?utf-8?B?aGk2elpheFpBN3RDaGhydERsU2VUb0hTSHBtMzVDdEJNbVRlNkZ6Z1dSYlpU?=
 =?utf-8?B?N1p4Y2FaS2lid1loUjU4SThuYUNTRDhUU3o3aklSb2VTMkM5b2ZPMGFHSlQz?=
 =?utf-8?B?TGREZi9nZnk1MWNXcUtETFd2eStXUWVlZEluOXIwU2hlNWNoN1NzTnVUMWpR?=
 =?utf-8?B?MXhBanR2aHBvRnBJTDE0bTBveWYycDdSUFYzOUxSTUUra1FyRnpSR1Y5c0Zt?=
 =?utf-8?B?VDRwQWtDbTQ0VXdlR0toN0RJV0ZKNTJ4amt2YUYvZmI4STU0aEtWZytuT21D?=
 =?utf-8?B?VGhlQW14TUN5VUdLTXhRRmNHbVlzUW9lWGVmVW1sWFFTQmJPbnVzRGNpTDdW?=
 =?utf-8?B?UlY5bnROMXY1blJEVklucC9reHRaaW1ySkh1ZVhoMjV6ekozSmZRRWxoUGhn?=
 =?utf-8?B?NVNnU0I3VDFPUXl2dy9XNkJVVlRISi83a1BwdzRrOElQZ2lYcnlGNm5ycVFD?=
 =?utf-8?B?TjhTbDk4R292cjV6THBCTU14Yk1OWThJZk1hdE0zV3pKTmNzenlVbDUrZlJ1?=
 =?utf-8?B?KzQrcDJvdVpLZGZkRnNzV2o2WUhiMUtRSnVWeUlMeXg2NzZoUmpzR0Jlanll?=
 =?utf-8?B?RFAzdlRuS09RNDV1TTdyYmlxNnVxVVQzOHFEeWk2TURPc0FLUTdEM0ljbWVs?=
 =?utf-8?B?S0NhN3FxVUtOK0srMzVWdWZ1dE9zWVVNclRadm9Hb29yK1NPUWpEVHdHUGxk?=
 =?utf-8?B?eThKS2pmK1hjeXBEUVFqVHFXVkdaeVFmOTkzVGVQL1Q4V2VURWhaeTdkSlRx?=
 =?utf-8?B?eFBHNnpvR2VEV0FRMG5YYmlQQ3RmL2dmSDh4endacVJ0Z21kd01GMmlmTjNZ?=
 =?utf-8?B?OE5PNHlrUU5pV1BNc3g0Z0QrVCtBQW9Xd3ZLUCtQVSsxTU1NKzd5czFQNzhQ?=
 =?utf-8?B?VUdBMi9LeUsyTS9NSjNIa1M0bmc0dnJjSWx5dGRJWEx0R1pEOU9HV2p0Y1FL?=
 =?utf-8?B?U2JkVmh4bXV5QkxDeFVHKzI0NjY2UzQ5ajFxWU41NE1lQWw2T25TMXQ5OXZX?=
 =?utf-8?B?K3ZMdjJrRncxanpLdnZveDFSTlRZc0FOSGNlekh0cVFvck05eU8zd3ArbVBn?=
 =?utf-8?B?eExiOFdMSlBvN0ZYeGQ0aUJCVDBZMTNQeGt6ZkFPV3piL2t6TGNvN1kxM0pJ?=
 =?utf-8?B?K3pyd2tnTjFrcFE4MEljS2ZINTQrREpwSG52b05ZS1hzZDZwTy8zVGZIYkNr?=
 =?utf-8?B?OTNObTNRVDFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWliR1ZwcWNnTkc4MTJmTEhueEVqNndtakhNNHUyS3NCbE1SNlBoWmxMR1lO?=
 =?utf-8?B?b0F3V2dNTW1panAxTGJRQlFSRE02QmFvWGErb3VpQVlrSDVYVEt1d0JCME1l?=
 =?utf-8?B?Q2l2QXd0Z0RTQnJ5dlF4LzFTM2xQVmRCZUppWGhHamdUK1I3Ni9tT2tXYVdD?=
 =?utf-8?B?UkxOaFBIU2d4V3Vid3VkOWQ5N3dDcnVhL2x1TGRJcW9rVVlmaWZUQnVsKzU2?=
 =?utf-8?B?ZVBOQ0hCVWJLVHM5NWpMM3hqL0Y4OUI5aU1kVTVVRmU3UW5tdGdIbTVxOStQ?=
 =?utf-8?B?Ymlhdlc1ZGltbzBvV00wbmhZNk0rMkNvZ05aMEdlTlpGM0RCOFY5UHpKTTdS?=
 =?utf-8?B?eTgrT0V0MG5RNnJuVlA1M2ZQcVF0eC93N3JpQ1hwdXA5UlhZTm00bmRmdmNa?=
 =?utf-8?B?NFNqOGpQcldtM2tYQ3JqRkxtUDBaZU9SRW92aWdnMzFUa0MwZ29kUWlhVFFw?=
 =?utf-8?B?djMxZk5zWnR2b2NJSW13UGFVMWcxTHc3SG5FWlpBWURZZTFLeXB6N2ZUeDZr?=
 =?utf-8?B?NlFZTjBVREZBb1BEbEhwOS9xMUZwSWN1aHhsYVQ4TEJ0Y1J2MHNYK2MvcTVW?=
 =?utf-8?B?Vml0UTZSZncvQVNXNXZtcFpqaGdaajg4RVBUZ2tVK21aaS9zblN3Q1UrWTNl?=
 =?utf-8?B?YmVaeXVwbE50YU03d2trbEx5dmR6ajBvT0tOYkFDcHFsL0YwbVZKSVdFK0Zu?=
 =?utf-8?B?V2xsWVJwMGFMejZaVHIzNC8vTkVwdnpDL3NCanpkZ3k1YmtDZm9sZ0gra1Vk?=
 =?utf-8?B?R1BaRzFBSFAyZ0x4R3RLcGRiUER1OEtFSUo1WW91RUc1L3BWaVI5NU9uOVEz?=
 =?utf-8?B?bG9ubXFxZlZJcVovQTdwaXlIWlYrb3RSc1dtL0tSZ3RYeENqRVlWTmx4bmJR?=
 =?utf-8?B?ZlYzVXdBK21xaXFxTzVUR0l2S3FHdDFDNVExdFJhb09pSWRUMXYrR0Fqa0dC?=
 =?utf-8?B?VnZkVmtEU0t0TnpCcU52KytLaVhKbi9CaGNSUmxUZ28vVndzeHIwUlcxM0Vo?=
 =?utf-8?B?TVVGS3kvcUg2LzdWdVhTWlRkK1NHZ1Zqbit5S2g5K04wM0tpYnJuaklHTjdG?=
 =?utf-8?B?R0c5bEdPbFdvR3pnZEJhbmNjZTkwTDdVaTVSVy9iVVJ4eksxUUlYTG56d2tl?=
 =?utf-8?B?bjZnVkVseGxyVmJ6R0hGdUFMTzZOT3BSK2psWjZmSHJTNGpDSkd0Mmx5cHNI?=
 =?utf-8?B?c1lEOURCUmR6UElYZU9CTlhVZTZNblJReE9wZFJvbDIyN25IZGVLcWlHWkNx?=
 =?utf-8?B?WW1XcnpGMlREVUpWNWkrUWh1aGx0dklOWUVzR1E0TzFtLzJQaW8zTEQydTAw?=
 =?utf-8?B?bEwwbThTSE92VElqUDZUSmptYWo3aDVzQ01wMVpBVzVYdGhOZ1dFZ1hDWUJL?=
 =?utf-8?B?blRkYXU2YURCUlFwM0NBRlQ2R0pjM1BEWHZVbkFlb1JJaEtES1ZHUzdxVzl3?=
 =?utf-8?B?MFQ5VXpJT0k5SzVwdWJ2dytGUlFhcStQcUpJQzRYRVVQTmR6c3ByN01DTXRY?=
 =?utf-8?B?OFRMUGtJd1FQaytDcndNMStrWUQzcGJVZVdCbDZCUHJvMmU1L2QyMWRmZGV1?=
 =?utf-8?B?TE1JN0dkSUdUZU5YQjVWTHpNQTRLU3Z3K1I5bkRsL1FDUFVXNml1WENNQWRy?=
 =?utf-8?B?NGFTNEZ1cy9VT1Zxbk4rZXBvMlkvL2xacG1nK2c5U3dGbTNDNDhBU3N4N2Rz?=
 =?utf-8?B?ZmdvajNIK1lsY3dwTCs3ZTRDcEgzdldPeTEvWVEzNGNST2c5RmNTMUNKVmU1?=
 =?utf-8?B?enVvV21vck1YNm8rbS9SV0ZEY0xSQ3A3KzZKWG9qVGNmZnlBL0lBT1NiUUZh?=
 =?utf-8?B?RlFZRzZKSFpVWkgvWTZIanlXakphY3VtWEJmRUs2bndzMVhVU1RkUnB3VEFF?=
 =?utf-8?B?QW5uUGNyY2hPTitGSll1MWdSWDNFSVR4Y3VDc2xONnZQY3g2NXBiSXZpbmVN?=
 =?utf-8?B?T1FaWGtSSmtWNC9mTFIyN2tsaGg1YVNHR21IL1dwZ1MranUxdzk5bEpZc0pE?=
 =?utf-8?B?Y2grc1pWc1FubklOeGFPYUVPNERpalVMYitpQ0hYa3JqMnBia2VnMkNiMnk5?=
 =?utf-8?B?WlA0OTByUWVsU3U5YnZsNFF3OFBOd3dVZmxzVW4va0RHVDZHQVdOUG9mSzJs?=
 =?utf-8?Q?04YQSm0c1Ixc3Sbi1QE50Iz5P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0532BCFDFA4AFC408E8BF6ADE52F5219@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7657cb1-cbc0-432a-3f9c-08dde4883932
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2025 10:06:28.2340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zh9KzAa/iRmH18HVObpC9dFl+YRDumhrQdV/CLnCF2BJV6fwS7AZf6UZliXPETv9t4ZrThlD66OwPz4DZk185g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7881
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA4LTI1IGF0IDE1OjIwICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gTW92ZSB0aGUgUE1MIChQYWdlIE1vZGlmaWNhdGlvbiBMb2dnaW5nKSBidWZmZXIgZmx1
c2hpbmcgbG9naWMgZnJvbQ0KPiBWTVgtc3BlY2lmaWMgY29kZSB0byBjb21tb24geDg2IEtWTSBj
b2RlIHRvIGVuYWJsZSByZXVzZSBieSBTVk0gYW5kIGF2b2lkDQo+IGNvZGUgZHVwbGljYXRpb24u
DQoNCkxvb2tpbmcgYXQgdGhlIGNvZGUgY2hhbmdlLCBJSVVDIHRoZSBQTUwgY29kZSB0aGF0IGlz
IG1vdmVkIHRvIHg4NiBjb21tb24NCmFzc3VtZXMgQU1EJ3MgUE1MIGFsc28gZm9sbG93cyBWTVgn
cyBiZWhhdmlvdXI6DQoNCiAxKSBUaGUgUE1MIGJ1ZmZlciBpcyBhIDRLIHBhZ2U7DQogMikgVGhl
IGhhcmR3YXJlIHJlY29yZHMgdGhlIGRpcnR5IEdQQSBpbiBiYWNrd2FyZHMgdG8gdGhlIFBNTCBi
dWZmZXINCg0KQ291bGQgd2UgcG9pbnQgdGhpcyBvdXQgaW4gdGhlIGNoYW5nZWxvZz8NCg0KWy4u
Ll0NCg0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5oDQo+ICsrKyBiL2FyY2gveDg2L2t2
bS92bXgvdm14LmgNCj4gQEAgLTI2OSwxMSArMjY5LDYgQEAgc3RydWN0IHZjcHVfdm14IHsNCj4g
IAl1bnNpZ25lZCBpbnQgcGxlX3dpbmRvdzsNCj4gIAlib29sIHBsZV93aW5kb3dfZGlydHk7DQo+
ICANCj4gLQkvKiBTdXBwb3J0IGZvciBQTUwgKi8NCj4gLSNkZWZpbmUgUE1MX0xPR19OUl9FTlRS
SUVTCTUxMg0KPiAtCS8qIFBNTCBpcyB3cml0dGVuIGJhY2t3YXJkczogdGhpcyBpcyB0aGUgZmly
c3QgZW50cnkgd3JpdHRlbiBieSB0aGUgQ1BVICovDQo+IC0jZGVmaW5lIFBNTF9IRUFEX0lOREVY
CQkoUE1MX0xPR19OUl9FTlRSSUVTLTEpDQo+IC0NCj4gIAlzdHJ1Y3QgcGFnZSAqcG1sX3BnOw0K
DQpDYW4gd2Ugc2hhcmUgdGhlICdwbWxfcGcnIGFzIHdlbGw/DQo=

