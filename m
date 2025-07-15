Return-Path: <kvm+bounces-52407-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DBE0BB04D22
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 02:54:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8F9E7A4BCA
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 00:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ED0619882B;
	Tue, 15 Jul 2025 00:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dEJs0Ek3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A64367;
	Tue, 15 Jul 2025 00:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752540874; cv=fail; b=tiBu29byyaPM3CQofLy4ylnpqvLSi++4DMoUT9kFT51pc0/W+BGUxkAWXGhGn5UdoCeeBvO531tj5gDcByQssygwxyZtJfY5U2ywCiqz7tPTrN4QixJ1aaDuuYIgSTKMwKrInBo6ClFsqxOVNiPrLfmxzlSg0gbjjlOZyIYTxUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752540874; c=relaxed/simple;
	bh=p3ar5IaYhB7A5dqmI/8bdHMjmlkv3/V7T/dH09pldTs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CMdMVfdtYTTgO8MlHJRg2+QZvUgPqwX3Km5wQVOMtZ1pYl9KB0a6dcv5umpEluStVpHHB8a/noa+1vICyRdK0zzitGrhD/41ko0Oht6SsA8tv4TgzzUhr4VQ4BtBnE9Lw0h0QFU/EfsmP1v7QFNFY+z1/A/wgzkzSa047kEcoH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dEJs0Ek3; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752540873; x=1784076873;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p3ar5IaYhB7A5dqmI/8bdHMjmlkv3/V7T/dH09pldTs=;
  b=dEJs0Ek3ezGQwx9kyVMyvdp8K3oIt3sXjEClCM/s/f2qbZYyIynu400a
   ygRsBgVoK1K3+Y24at3frZhKW9zChvmmcFCa/pWt4y9fidP9bekxThZ6r
   apflb/HGaPu8oqRt9gEKHEc1eBIL1WV2XK/JCQdofie3nYzE9OmSutsf+
   WrRLSnDEJsEaJRFnuh243Ahxue2LNnNa7OU6hQWwTu8G8+m0c0eIqkvPD
   gjtmdRtLh2mvey4jgUYKkoD4qkjnkyFBgczlVwb97POQg+H8NrmlYD6e/
   fydb2FKoRoPpsl6aDKlv6ezEfSAePGzLrs5+dGKLobFL3JjcLlQqSX6iT
   g==;
X-CSE-ConnectionGUID: 8NXtkfS+TtKdmEMfEpg+hA==
X-CSE-MsgGUID: 0XwHgk/yTQaKYGZPjeQ6eg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="58404300"
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="58404300"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 17:54:32 -0700
X-CSE-ConnectionGUID: HGYniwApRRq9yVo0tcvOZw==
X-CSE-MsgGUID: /v9mp/tuQPysUMwPJId+SA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,312,1744095600"; 
   d="scan'208";a="162739329"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 17:54:32 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 17:54:31 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 17:54:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.88)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 17:54:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+DgwBoVSBNRFXEhPbG5QK51Es7b5V9/rwe+tFWYkDPr2QqsWNXSad+qsh1xsyjh8I6on/6cZy/BvuGmPMQS8j5MqegOvjbAm398cM5jvAztHXr6ajiC31vr3tLucHyx+qKUHCEZaP1IngBK2gu6mGjQGnfC8M5uyCuYjbsJa5m/9qj5ZDBgVIo3/XPOxNu0eMu9hmD88uvSq7yAIJAd32b7h5KMa0U4jEZANDWgNzFrIlfQ+u0Zx2Lx5gYm5+x/2XkSAO626lTraViBrv5uprl1xpkJZmvQ7HZRm+q1Bh5cET61J3yUQEkSCpvfYZwWy/nDQhMRiGyr3OwKBgdIyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3ar5IaYhB7A5dqmI/8bdHMjmlkv3/V7T/dH09pldTs=;
 b=w/EJ+XymBnNNoVPyKNoPZ1NlOGUFrgM8CBmnyjjAaiXbYcD7uUZ4qUUkow+p3pUvtwfrSNjO7N2qVRGKF1NvYVxJZyqktoOcD3Tb1XB8QsKamqrrZ6nMmOKz/mgb1nPRokrN5pYidrJBBmFJfNHFm5fxJhMq9T0AUggA+reuomQzztbjmMq/ZCaXCTKLCsdyQJ48fuDfFyqicKskWGbsZmZwv2wDOIjdIM62eRH/daT44yO/A2h7b3Utk5E4jWyHlqvK23Juc70jkb/+VFQAqAf8TrkP56R0ZsDmLs0p0rZB6GVKQS4Zf4ojIoQ8IlgCIy5nGsnKeQATkoM2bH9eBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4961.namprd11.prod.outlook.com (2603:10b6:303:93::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Tue, 15 Jul
 2025 00:54:00 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8922.028; Tue, 15 Jul 2025
 00:54:00 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "nikunj@amd.com" <nikunj@amd.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] Improve KVM_SET_TSC_KHZ handling for CoCo VMs
Thread-Topic: [PATCH v2 0/2] Improve KVM_SET_TSC_KHZ handling for CoCo VMs
Thread-Index: AQHb9ELH4M8ZgU37UEe/zU/E2TfLgrQyVNkAgAAIgwA=
Date: Tue, 15 Jul 2025 00:54:00 +0000
Message-ID: <e1151fff87e0f0f26462fed509a41916dd6ba8e7.camel@intel.com>
References: <cover.1752444335.git.kai.huang@intel.com>
	 <175253196286.1789819.9618704444430239046.b4-ty@google.com>
In-Reply-To: <175253196286.1789819.9618704444430239046.b4-ty@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4961:EE_
x-ms-office365-filtering-correlation-id: 57cdf7b0-7277-421b-adb8-08ddc33a1600
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?akNYMDY1Z0VNd2hKZjB5OGwyVXNDWlVuUkhvVEszbGFMN0lzbGZ2M2dSRU51?=
 =?utf-8?B?TndTUHEwbU5jdExta1BIMUlCL3NPUDR5YTBoK0RLdk9LVWlJYm81T1hkcGVs?=
 =?utf-8?B?RXZIdzRJT1F2eUMrcjNaclZxdnFpR1g4RkNERytqUk9qMnNPTHNYY08wQ1hK?=
 =?utf-8?B?V0NGL2MwQ3hzRnp3NkhoMk1lSHVXUWhWeVdWaGpZRTVFRS9SNllmMWpYTklC?=
 =?utf-8?B?OS9TNVdQR2ZDOTNITGR2ZG5WSjIzRXRta2UwRVdiS1J6dTdDeE0zQnBRR2Vr?=
 =?utf-8?B?cVRqZ0pRTUVORytYTmk2SnYrMWd4UllEWlpmMlBYTzZJb2dqc2pxc3piTmx4?=
 =?utf-8?B?R0lyZ2ZCQjVwbFdHcHJLOU4zN2ZHUHJkVXg4MkMzcGhwUG9iUUdPZlBYQncw?=
 =?utf-8?B?R2RYa2MyVWVkNmE3cDQ0dnp1NzQ4NjRPZHpnclBGb3I3KytlR3BoVmxmSVVl?=
 =?utf-8?B?T0dYK3dPaFQyL3lXbE5JWE1KdkhkdFNVc3YwT1MyOVk4L1BDcWNDVlNwOEV0?=
 =?utf-8?B?bm9Ia2tBRmFYZTNVTEQ0M1NRYXV4ZHNCU0RFUjIyN0lKU3A1Q1JKVkhrbkhw?=
 =?utf-8?B?dnNmZ09OSXBXaUE1c1JXS1lxNUFTM1BzZWZWc3BRUlAzdExxcWRNM2dJTlpI?=
 =?utf-8?B?WktFOHQ2QmhocElTeW02YmE1U1pyYzQ2R2poMWE3SHo5OGhOS2hKaXdZdjFr?=
 =?utf-8?B?aXNxbVdQZlBnbzNxTThoTk1oZlIxa3VvMU40NEtFRXNoU3EyMDNHelJSblRX?=
 =?utf-8?B?bERsYzVRMFRQWjZsaHpDcklEYkpnWXlXeEcrQjNYd1BJb284eEIyTldDY0J2?=
 =?utf-8?B?ZnZWbkdBMUdIaHF4RUpROE5DakRVZGFUeWtWZjdVZTVCM2hKdW0xTlN4b3BO?=
 =?utf-8?B?bjBISk4wSG5yTmxXQ0VGQWtVOUtzVU95VitxNldzbUlVb2V1anRmYkpORnFX?=
 =?utf-8?B?U0NFN1cyeGZMTlUxUWNCR09hZCt6SzdZTHNJajR5cU9VYnhXTkplR3p4YVQ5?=
 =?utf-8?B?NWlqUTNFbU9JdlQxL2RXZ2pzQW9BQW5Hc01ZcmE3UmczYWx6OXR4eno3NWFl?=
 =?utf-8?B?anhhQnJ2MWZFT29hWERJdEYrVW1hSHloczA3Ym56M3V3N2g2dmlheEJYYWE2?=
 =?utf-8?B?aVBSTGlyRWF6Z1FETWxUVlRJUFZKam9aUHR1RFlnNWpqeS9mdE0zeURRZWRQ?=
 =?utf-8?B?Mm05VHVCYUpoYmczbW5jWUxEMS9aOHdnZlZuTytkZVVVcVRodU1sNjdxV3hI?=
 =?utf-8?B?am1yNXBGQXRQNEJ1ejlEMjBlWDJaWE1wQlQzWjhkbU1ZMmZSNTVEQnVzNFhN?=
 =?utf-8?B?bFQ2S2pTQ01hZSt4NVUyUTZURXQ3T0NhOHMydUg3d3Z6YVc5NnE1UHlFTi9Z?=
 =?utf-8?B?TW1TT2UrRDVGYkRrbmNXY0pRZlN6UEcvNzM1U2UvdXVoKzJmMjdtUXJpVTdL?=
 =?utf-8?B?RFJBQnFGdGU0cmJTR1pvUHN0KzZ4NmhRUTRYUGJQTE1DTkhNd3djNjFvVy9p?=
 =?utf-8?B?anBmVlpwUnNCWkFFRG5vNzRUWnRMN054Yk83TGMxNmoxZEV5amVkWHNRaGsx?=
 =?utf-8?B?dlYxSllLWG9UbndFS0lRRHhXNXhBTnFkaGlDdzBEVlJZbXdvTld0Mko3bzEx?=
 =?utf-8?B?SXVhWEwxSm1tdWpXZitXUk1pbjZDKytMNzRyZnZqYjRsY0tWMDdrOWNJR2kr?=
 =?utf-8?B?YjhmSTAvS3dtWmd4N082RlMyN2EzMzdiMGZaV2tCajg3OUtTSWVRbFRjY1NC?=
 =?utf-8?B?dUduQVRTZ1hSc3M4TytPbXNZM1A5cFozR0ZMYytIcktzZWxpOG9yYTYxRGdt?=
 =?utf-8?B?THVxWlIxR1B3RmVEY3FhWVoxLzlqcndWN045SjM4bkVlYTlxRldaMXE4SEVK?=
 =?utf-8?B?NFJUd3ltdUJ2R0hFTmVud2FRWWZIaExqQzFndXg3Y2FNY3paOFI2aC90YnRU?=
 =?utf-8?B?REZjRUV2bUFDdVoxcWxjTHhOclF0RDVoR1lpemNUd1hnSTA3d3B4eG1ncTFu?=
 =?utf-8?Q?o1m9bSJFogTHfxOaxWFJLafP+mB/pg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkdRdFVHOFIxTXQ5dVNsdVI1KzJOL2p3WWJaYThVbFloZWI2RkZmcG80SWRZ?=
 =?utf-8?B?ZjgrUEFReXA0M2dDanduNXBTQzFKNklCa2RWUE1zaENyUEZ1eFdubDhtaXdw?=
 =?utf-8?B?Yno4ZTViR0Y3dTVlZE9nU2Z4WmFwZWhSN21VVlN1Z0pnZUk2Wlk0TEtVTm5z?=
 =?utf-8?B?NGJIR1FzeFN5OXR4U2NhSTZHSy91RFJBZXpaTzZ5SUtoQXhqaTJNM2VBN0tM?=
 =?utf-8?B?QUl2M1g4a3RGbDNQMzhhbCsyUndja0dsSy9KMWZrZW11KzZTTDFBYTVaMHc3?=
 =?utf-8?B?Q3JiZXUrVmFTMkg2ZzdLM0Nyc1VVQ0c4UDlNeDdyLzVyempzV0RtV09kSjN1?=
 =?utf-8?B?M3hETEh5MkZhbmV0ck5FSzhKWmZZSTljMGhkV25weGdXcGxkZ00vSzBVOVhj?=
 =?utf-8?B?b3h4UDBtTStNaDROUlZ4cmZBbnY0YXJYQnR6VVZGUThZdy96c3NSdWpjbWdC?=
 =?utf-8?B?SWVoTTBqbDVaWUJHbUlIdHdUMVNCcTIrQXhtNC9sRUh1eXlkaEhTQWtWY3lo?=
 =?utf-8?B?OTRPekRwLzE3dGVBdDA4V1MvUklsTm55L1RCcDhIQmlsaHp0aGtLWDVCSHBG?=
 =?utf-8?B?MVlHM3lBQ2ZmRHBMbGFwVUVWelJzTlFTY09yS1V6L1B3VnRLQTBRTXlBRjFM?=
 =?utf-8?B?Rkp0cVVGZklVUDBWTjkxUUZrb2JCNHV1OWE3TkRTaXRkNGEvQlE1Z3NRM2dk?=
 =?utf-8?B?Zm1uMWwzakx3Nk50bHY4dVcwUW1ybHJLR2JoZkw4ODQ5dTJLYnR3cjJmaFJt?=
 =?utf-8?B?WWhhU2ZIVGlqZC9qbnBMUnVreGlCT0lQdEF1QkFhak5lY1ZSbzkzOW4yWk1L?=
 =?utf-8?B?QWVWd0dzWUxIOVFDWktpUFcydUYxbkt1cTJheE9WNmpnMyt3TWpoWmRGcml5?=
 =?utf-8?B?QUdnd0huMnNsVUpYdG9yN3NPWFR6QnpyN1F0cWk1ZEhJQ0g3Z21RaEhpUWtq?=
 =?utf-8?B?dVdJVzQvdEl5SFIxOTFqemZ6RHRGYW90ckNYallDc09IUU0xRlZJbWpvVUF6?=
 =?utf-8?B?bklzOE9uK0NBTkJ6bkFhSXpnbitFZmRCTGpzTXI1M3BzcVJRZXMwME5Ia1dN?=
 =?utf-8?B?Z3VZWW9YR0t6Nm50K242MnN1Qjc4aHdTZU9tNzhSYVFMTFBMUEFUYTdCOGdq?=
 =?utf-8?B?UGpOZjNKdzU5TVVISzIvUVFHMUVmZm5MV3BHSktOTThmMi81aFdCQ0FLN3FX?=
 =?utf-8?B?MVBTekYrQ25aZVJWemlWZFdCcitSNUJhcDNGOXVvL0s2RGplQXBlU0o0T1ZN?=
 =?utf-8?B?YmVydFlabVFaQXd1bmdFcnFGYkMzYmJsSzNaSUl0dUJFcUJEQ1g4QXhUSzlh?=
 =?utf-8?B?WXBHZkh0OTZZRHZJZGI5STIxczdyWC9zSDlRRlZEY0Q0T2Z2L2l4OWl0VUpp?=
 =?utf-8?B?eG05V0ZrWUhMcnVpS21peWM4YkN6dE02cEVlYnYxckZUaDRwZVZMZUJoL2xJ?=
 =?utf-8?B?TGhZNTA2R20xZjJyQUZONmh4eTVEREh4dml3cTBlVGsxRWlGMXNSSmk0ZkN3?=
 =?utf-8?B?SlVWU0Q5SFJOaytSM05IcTBmQXJvaWVha2t2b1czZUVnZEduVzB2djNPaEtu?=
 =?utf-8?B?ZFZZN041WjkycUJIWjkyd05RbU9kVGw3Y2EzcDR1Z0hidmVKZEY1clRYL2Q3?=
 =?utf-8?B?UGdWWnkzSVQzNFIxWVFJMEN4eDJDZWh1Z2pMY1VyQXJleWN5NWc2TExIcjA5?=
 =?utf-8?B?MnRwcWVzd1B0VHcwcmVyTk4xekt4MFlsNkVFc0VaN0w4azBVVXdHd0RBWHZS?=
 =?utf-8?B?ZUZULzA1UzFBTjFhdnlMVVR4V0IxbWNWRzkrcGNjdjVJLzd4SGtKVER1dG9m?=
 =?utf-8?B?Q3NBTW1ZZ3l5TCtIWWpqQi9JL21EQitNTXNwQWxjdW9HSTFxakl1RDZjZk5Y?=
 =?utf-8?B?RjJFRWJXV2FkM3YzRHFTaTZDZmNuTmRXNzJ0MktRVjFSVUlyNi9hejFsVXRR?=
 =?utf-8?B?bEFEOFAwL2dwSW5YMm01OHVoOTlIY3hjTFlraGpIeEZQZU1FenJrRWtIWWZC?=
 =?utf-8?B?eW1iVThxQnQ4K3NVVFVKdm5DeVI5Y1duSnJIVjJ5ZEdmVjR6UXN3L3BDVFpP?=
 =?utf-8?B?WHlHVkIrTTE1Tml5TGJUbmZXT3hqUTRqYmRoQWl2MHJNZHBxOHF6MmhiRS9x?=
 =?utf-8?Q?Chchftl6flV21UpVdJ1dwXi1H?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D65A3C4BEE8644DAFEE4C694AED7419@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cdf7b0-7277-421b-adb8-08ddc33a1600
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 00:54:00.0671
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pIA9pJHpJINk0xx7nSEKjhFgZ9899C3ZU1qPbpg3J9ma+Vjlo1z67taNdsgtLVuSrMFJRoZF7Tnfu7Q2+5yvHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4961
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTE0IGF0IDE3OjIzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIDE0IEp1bCAyMDI1IDEwOjIwOjE4ICsxMjAwLCBLYWkgSHVhbmcgd3Jv
dGU6DQo+ID4gVGhpcyBzZXJpZXMgZm9sbG93cyBTZWFuJ3Mgc3VnZ2VzdGlvbnMgWzFdWzJdIHRv
Og0KPiA+IA0KPiA+ICAtIFJlamVjdCB2Q1BVIHNjb3BlIEtWTV9TRVRfVFNDX0tIWiBpb2N0bCBm
b3IgVFNDIHByb3RlY3RlZCB2Q1BVDQo+ID4gIC0gUmVqZWN0IFZNIHNjb3BlIEtWTV9TRVRfVFND
X0tIWiBpb2N0bCB3aGVuIHZDUFVzIGhhdmUgYmVlbiBjcmVhdGVkDQo+ID4gDQo+ID4gLi4gaW4g
dGhlIGRpc2N1c3Npb24gb2YgU0VWLVNOUCBTZWN1cmUgVFNDIHN1cHBvcnQgc2VyaWVzLg0KPiA+
IA0KPiA+IFsuLi5dDQo+IA0KPiBBcHBsaWVkIHBhdGNoIDIgdG8ga3ZtLXg4NiBmaXhlcywgd2l0
aCBhIHR3ZWFrZWQgY2hhbmdlbG9nIHRvIGNhbGwgb3V0IHRoYXQNCj4gVERYIHN1cHBvcnQgaGFz
bid0IHlldCBiZWVuIHJlbGVhc2VkLCBpLmUuIHRoYXQgdGhlcmUgaXMgbm8gZXN0YWJsaXNoZWQg
QUJJDQo+IHRvIGJyZWFrLg0KPiANCj4gQXBwbGllZCBwYXRjaCAxIHRvIGt2bS14ODYgbWlzYywg
d2l0aCB0d2Vha2VkIGRvY3VtZW50YXRpb24gdG8gbm90IGltcGx5IHRoYXQNCj4gdXNlcnNwYWNl
ICJtdXN0IiBpbnZva2UgdGhlIGlvY3RsLiAgSSB0aGluayB0aGlzIGlzIHRoZSBsYXN0IHBhdGNo
IEknbGwgdGhyb3cNCj4gaW50byBtaXNjIGZvciA2LjE3PyAgU28gaW4gdGhlb3J5LCBpZiBpdCBi
cmVha3MgdXNlcnNwYWNlLCBJIGNhbiBzaW1wbHkNCj4gdHJ1bmNhdGUgaXQgZnJvbSB0aGUgcHVs
bCByZXF1ZXN0Lg0KDQpUaGFua3MhDQoNCj4gDQo+IFsxLzJdIEtWTTogeDg2OiBSZWplY3QgS1ZN
X1NFVF9UU0NfS0haIFZNIGlvY3RsIHdoZW4gdkNQVXMgaGF2ZSBiZWVuIGNyZWF0ZWQNCj4gICAg
ICAgaHR0cHM6Ly9naXRodWIuY29tL2t2bS14ODYvbGludXgvY29tbWl0L2RjYmU1YTQ2NmMxMg0K
PiBbMi8yXSBLVk06IHg4NjogUmVqZWN0IEtWTV9TRVRfVFNDX0tIWiB2Q1BVIGlvY3RsIGZvciBU
U0MgcHJvdGVjdGVkIGd1ZXN0DQo+ICAgICAgIGh0dHBzOi8vZ2l0aHViLmNvbS9rdm0teDg2L2xp
bnV4L2NvbW1pdC9lNTFjZjE4NGQ5MGMNCg0KQnR3LCBpbiB0aGUgc2Vjb25kIHBhdGNoIGl0IHNl
ZW1zIHlvdSBoYXZlOg0KDQogIEZpeGVzOyBhZGFmZWExICgiS1ZNOiB4ODY6IEFkZCBpbmZyYXN0
cnVjdHVyZSBmb3Igc2VjdXJlIFRTQyIpDQoNClNob3VsZG4ndCB3ZSBmb2xsb3cgdGhlIHN0YW5k
YXJkIGZvcm1hdCwgaS5lLiwNCg0KICBGaXhlczogYWRhZmVhMTEwNjAwICgiS1ZNOiB4ODY6IEFk
ZCBpbmZyYXN0cnVjdHVyZSBmb3Igc2VjdXJlIFRTQyIpDQoNCg0KPw0K

