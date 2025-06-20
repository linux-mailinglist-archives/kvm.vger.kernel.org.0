Return-Path: <kvm+bounces-50158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B56B8AE2298
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:59:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12C261C2184D
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F9F2EAD08;
	Fri, 20 Jun 2025 18:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cUVH/yts"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D051FBEA6;
	Fri, 20 Jun 2025 18:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750445966; cv=fail; b=B39GNE3naq5SOjzJj7B8oamHYCCtJEgCazcSxCI6OqTjLoswwlV0gEb/eQIlIDT8zYssmak3ZB8ofoC4tx38Xog0cQHnyxSomJc9O1+oX5/BlvggeJ4hK4XQGhHlqkSnjidJAV/d+ZODu8BxYX3N5Zlo8l91/9SePUCelIk4MMY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750445966; c=relaxed/simple;
	bh=VZju2JY+7oPTcHOM6sDtLMJp3cfTu//if3x4VEVrZ0A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XLxnPXIUYo3r7gyoE27r7Yddv0KXT27jQcRH0IabOA58SkdIGQz1u9kjYuIMqsagWZx4VqjfOsLiwF4fhQ6glKsY7pg/QDHxxLV8LNDl8wB1jUSO5Ca2ZOrKwzyrjgk6+6zjHeT3FI/4y+ac3D4mD7twPX4ln5fKGJAVYCfhpt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cUVH/yts; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750445965; x=1781981965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VZju2JY+7oPTcHOM6sDtLMJp3cfTu//if3x4VEVrZ0A=;
  b=cUVH/ytsB1Tii1EFNT+jrDTP7KUKBt1fHP7XcFierU4bxnRXSchCrEbK
   KWjMmQ4eR5/8U0h841ocHdCNfjhtg3Yz810KoSXBwk++ryb6Tu7cTlEHP
   qLTzqqpYdVWehKN65fuVhQwZ38GcTn2/Tk2oWuW8BRPir/zK0iiLEQ1un
   1lUphkJFZWjY8t/aG+mQX3IRq/G8dFXopMesLo68bAcUFAZAw3zkfIeqK
   6l/LzvkJxk9zadsCoe4YwWYvEa3x9/wLGEnpuqAIJJZ4rmt7mplbxgxtM
   5oP1w0vkky82sXyGZczjrfwl1bSFVad31NQnUiLPz9kLvQUAfb3u7zzrg
   w==;
X-CSE-ConnectionGUID: oIjNmfkEQLy3/uFaSto35w==
X-CSE-MsgGUID: 23tAopHzReSG4PoLO5Lekg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="63401783"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="63401783"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 11:59:24 -0700
X-CSE-ConnectionGUID: +yGqi76xS5OpsOd8iZf2Ag==
X-CSE-MsgGUID: nmZPP4EvRlO2UF2GCOqPVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="174595055"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 11:59:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 11:59:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 11:59:23 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 11:59:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pudDfaPvQmiXGMaRQW1/3TRtDHkIWYm1T8sqvrkp0r4G+Ypkc/RTCpMbFlHqa/cpzI7w1h5cmuYaa/XE0gXDVAmDq0y9kIG+ZM9vcBu9okGQpyA4HfUJZ7G3Kbbf2eDkevd0q/tAaDHT4I763DY+Ou84/tAno4pTs/2/NUfVLl3VM4KiVbYN7j5M+dZx5gfhEIFK0dFU2bKkeK8H5VGEITcR446F0qb+ycuPZyzJRdDvLkRNOfLv+h8AbLeQ/gzN+AD4pjT8fAqNt1cVjnc7V0SEbwFDmYdJTu6nc993nYKVqXp8a1Z9URvO8rW+9cnSngsi3kFCJJ8l+nIPacnbDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZju2JY+7oPTcHOM6sDtLMJp3cfTu//if3x4VEVrZ0A=;
 b=uA2HG5rzInXsOXbn+Dv0IBm2P1btssTDZ1+gRQFZvSxwTbffCd6t5LXJFINc2gxX7uSo78t4eitcqik3MFTU9HpAVPnrvSrXSX+2CIJA+g+u7dLKpZ1eVAMh/DFTN7hTiuuLYOD8fcUkkR4Ymtbok2aIIG0tLemzoQzofuhv5zO1DCAbRIz4c+h58h+stdD5jsMDFyYRIuCRG0Fcv8CxXQBLKhqgQYpROnZQKEmILDb+E9KAsQV60RmgI5a1OmqiUS3yAUA8jArBejIi4O9aDvowyieJ+1ekyaHx7eMbtcb7Y+YpvaVHyFam70SUrTH7M9WVi4H+c3XNDyqTq0nNyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6218.namprd11.prod.outlook.com (2603:10b6:208:3ea::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.25; Fri, 20 Jun
 2025 18:59:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 18:59:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Topic: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
Thread-Index: AQHb2raQMvS71doOpkSd//tZsUmNFrQFK1QAgANI6wCAAAL4gIAAKpgAgAEMaACAALJ8gIABx94AgABM3IA=
Date: Fri, 20 Jun 2025 18:59:20 +0000
Message-ID: <1cbf706a7daa837bb755188cf42869c5424f4a18.camel@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
	 <20250611095158.19398-2-adrian.hunter@intel.com>
	 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
	 <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
	 <CAGtprH_PwNkZUUx5+SoZcCmXAqcgfFkzprfNRH8HY3wcOm+1eg@mail.gmail.com>
	 <0df27aaf-51be-4003-b8a7-8e623075709e@intel.com>
	 <aFNa7L74tjztduT-@google.com>
	 <4b6918e4-adba-48b2-931c-4d428a2775fc@intel.com>
	 <aFVvDh7tTTXhX13f@google.com>
In-Reply-To: <aFVvDh7tTTXhX13f@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6218:EE_
x-ms-office365-filtering-correlation-id: 426a454d-b6ac-413f-7138-08ddb02c9077
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NWZiS3NhbWcrSmpPSE42YXJQSjNrbVgxVFdCT0UrZVhabWNXcGlUL1NmNGJZ?=
 =?utf-8?B?YkJIOFNHVzlBMmM2ekpBRjRwbWpubzZCdmxGME9iK281R1p3b1VOdHAxUmFq?=
 =?utf-8?B?aUdmRU4xY053Ri9acFVpdTdjOVY3ZXBubHBaOWlrUFE1SjJOZnN6WVVjUFVs?=
 =?utf-8?B?VlJsTXN6dnJLYkJWVTB4eG9GaWo3TzdHZHJtRjNTSFlwMjZ5cmxqQUZ5KzZK?=
 =?utf-8?B?TDdLVEtjb1VtVm50QjVCQThSMS9JQ2M2VFNxMWJMbS9xSldLTFgyVlN0VGcz?=
 =?utf-8?B?N1g1azlvVFRuQ24xU3BDeGl0MmdFRnI5VksyOGI5aVJHUVZCZHB0UWh4Yzls?=
 =?utf-8?B?aFU4SHhLMXZFd00zS01IaklRc2JIYUpyUTFYeUoxSUhIV2piVWMrSWJPOHFB?=
 =?utf-8?B?NjY0am15K3NWais2eXZUMkpLL3U1WHU2TXJ3UnhOVDY0ZXBHbGVWNTZlVTRK?=
 =?utf-8?B?NS9sOTVRU1JLTWVtTktXZVBDR1Y4UmNEU01DMFZGeGloZ3h4L0dCOHpFNFVO?=
 =?utf-8?B?UHpjQVFDb0VhemsrcGdmS3draGZnMjZrOE9ZbXNiNkcrUGYvRjQvRFkyUklE?=
 =?utf-8?B?dk9CQUdxMkd4bDZNNEFvclBQZCtNTmNJSzF2Y09qYW9yQmRqOGhGclVjaTYw?=
 =?utf-8?B?T3MwRzRVS25FVUFqZENYcGpNOVZ2cy9meEJtZllRSzN3TXdBazdDTXFoalJt?=
 =?utf-8?B?L05iMksrMXRGWFlKN1Vnak9Oenh3amNEZ0syck1TWWgzaGpHSnhkcHRSdUhM?=
 =?utf-8?B?R2N5NUZsRkFWOWF2MVgvUnNENHZiRkV1Ty9NWDBvZTBwWjJ5a1NIZjBEQjZF?=
 =?utf-8?B?TWo3dXF0SjJGaWFRVUF5SE9jSjFXaVBhZHRTNUVtbWRRYVprMjBnSHRaeTIz?=
 =?utf-8?B?eFRWZWhOMVNXUlExZzgzeDFJSFhseU5PNmZ6cVlTcGRRbkRrZ0VTamdLMkNj?=
 =?utf-8?B?WFFBcXVtZkNTVlFyYllHelIyekcvc1NHN3E2K3hHd3BpVit6aUFtVngwOXJC?=
 =?utf-8?B?U1grL3Y3R1VFOUcrZ2RONXczVUgwNmI4ZURrdmJTbEg1YmxYM1c5UURCNVNZ?=
 =?utf-8?B?b2JUb0QyUHBVTnhSTWhtbGFtdjQydFpRYUZVWWF3Y1RRZzNrWFdhdFVVd1RF?=
 =?utf-8?B?RjlFUTAzeU9QenhORUJ0djhvOGdDdWQ5RllmSUtZQ1ZwNTJ4ZUpCSTMycks5?=
 =?utf-8?B?RjhudFQxK3A0ZGFwRXBxTTk2LzJJUlJaTnl0TXRmWjF6UEhMT3I4MHdnZjlS?=
 =?utf-8?B?aGN6RGNsSjVlN2JuT0QvaWRGQnY0K0RDRGlUbEhQUzFrY3FDRHBTZCtsZWlh?=
 =?utf-8?B?OHQvRmJLZ0FuTmZOL3psMnZzUFBqdTFJU01FSy8vOGRFRGNxWTlBeWI1UWFs?=
 =?utf-8?B?YlRsNk9oNi9wVzE5Q05URGxldnByOEMzakIyTkl6QWtZalRiSVJHQ1U5SkhI?=
 =?utf-8?B?Zy9OYjc0eXhiQmN1dXhiNEJrWmNrejBZVlUwRGRCN1VoeHl2alBITStJMGQz?=
 =?utf-8?B?eGhaMm1EM21DWTlYZVJBM01XNDVYZHV2WHJjcjlJVmhUN1U0SEc5RTdyN2R6?=
 =?utf-8?B?TWxJT2JacUlXVFVqenRzUVFGekpKcTVpNkdwL1RneHNMMVdjcVk0U1JmN1kz?=
 =?utf-8?B?dHluaFFIaGFGTW9lazFKZ2Q2WDMzbHpXUmQvcHNPZWtYUGx6b21aOTdkNXB1?=
 =?utf-8?B?VlhsZHllUW1zZEdNSEhOVnVoaUtwQ2FZYXIzOVhRbTBDTGFYM01yb240RHlo?=
 =?utf-8?B?K0t6cCswK0gzbzJsZG04Ylgvc0NqTHN3Zmdma1pHYjFjdlhNS0kyWnhod2Rz?=
 =?utf-8?B?OTNqd0VWV2YxbjJkUHRuditETWxyWjFrQzdsbTY4K2dvcWVWNGFYRTd0R0lJ?=
 =?utf-8?B?VFNhckJzMmRUYUtJVC9XTUdleHlRUFJ5VXplTDRyallWNTJRZVU0aytONVE3?=
 =?utf-8?B?SVU5QVZ1MSs4UVpROWVQZVJ0WVpXellRWGhlR1NGcTVEVHJKcm1vWVloT1Nn?=
 =?utf-8?Q?qsq9vosluu1qkJAkOG2r2OUUpU2TXU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTQybXhBT2R3OE56WWphbXQyVTJPaExkNEJYRFNMOTlYeXA4Qlh0eVhEUCti?=
 =?utf-8?B?QUZ3WEQyVFBlbjlTcUJ5NHZXc1ppT2dzNVRudWdDTTRFa1JWOVpWT3JjOTNM?=
 =?utf-8?B?Z3JrNSsydHFKMUwzWCtCd2Ztc2srUk1rckN6L1Z1cS9RajFFcWRpamRsSnNU?=
 =?utf-8?B?c0R3am1VQk1KQjJPSjkzdWNuRUJUR203MThmaENXeXJOQWk5b2ltbGF3Qk0w?=
 =?utf-8?B?Y0tpSktLeDJQK1VFR0xVdG5aOXVERkVkbHVEa2U5WVY4VGJObjU0NTFqVm11?=
 =?utf-8?B?YU8xaUJSemFqcXYxcy9pb09Zcm10ek8vUVl2VG9rS1Iwc0dHMTlXcjdpWDFE?=
 =?utf-8?B?Wi9ZdkJ6L1hJeDEveUN3YnhTYUFqNjBCV1dMSkNpajVaTXJ2RjYxRmphOWFo?=
 =?utf-8?B?YkU2bDdQQ1R2RTQ1cDhUUTRUaGpsOE55ZlY3azc5bGNWdHpmSzcxMVN3a29F?=
 =?utf-8?B?bFY3SlJISm1sMkZmMzY3MnByWUU1RTRuZEhBamNFY3h0V3VZWHV3WWRUSVlJ?=
 =?utf-8?B?SlYxZFRjK000emhHTzlIcG9nc29OaXYweURLSFdTV3prU0FrcTFrdjZ0WEd6?=
 =?utf-8?B?d3pvUTZRSXdUMHh0a2pLR3E3MVBrTytTUHFNZDhIYTNJaUQ5RmZCamwzYmJY?=
 =?utf-8?B?NDRXUUF1SlFmMlZETkVPWWpkUzl2b1pzR21zRzhPUU80cEp0UlpYN0hjRWs1?=
 =?utf-8?B?dGZXMVRpSVBLQlhBbmFWa0duY2pST2d3aVJ6dVVHQzViTEdRdVJaNjFDcjIz?=
 =?utf-8?B?QmVrSzhwSEFwZXBzNEZnTnJxMGphS3JycWROME9BeWRMdUpYWGhtd0pUV09n?=
 =?utf-8?B?SWhvWHEzT3RXVVBJcGxqdE51bHFIOUM0ZERLQ0ZCc0NYdjNrK21hOGRVa01Y?=
 =?utf-8?B?YytxQ0tTL0kvTU4vSHFOTXo0Vk5QQi80MWlmZTRyWWQzUm9ucmpGckkvV1ZJ?=
 =?utf-8?B?YmlBSnh4b0tCYmx4VmpXZS9jM1ZhOUlzU21VbW9oYy9lN1Q0MXVWbitCNzNF?=
 =?utf-8?B?dFhsZmVXQi9hR0Yrd0RJdjV0ZFZ5STVkMGpEVUZZSzB5RFlnZVA5UEFqK0Qz?=
 =?utf-8?B?ZkphNEZ5dDg5L2dPWlBWUWltU3IycGxTcDRIbW1iT0dGSnIzSHZmSXlaWUJh?=
 =?utf-8?B?QVc5SEVZYktabkVzalFJK1pCUW4wY2tnSS8rbzFwQVpvUE9zaUYzcEFjVVkz?=
 =?utf-8?B?S3lhdUt0M0VWbnUwQWlBSm84NDJYNFNJQ3lJTnBVZndja1JTN3dhOWk0MEFX?=
 =?utf-8?B?eW5KVTRnNlhldC9hM0dHZlljalVLZWF4akg5NGZSUXF1UXFCRzU5RFJNWmxI?=
 =?utf-8?B?VndNS1dUNk5YaTl4ZjVEbDhjQWlDOGU0WW9QZ1N3S29ZOGFVUGVrQ2dYZkVX?=
 =?utf-8?B?MEpnWENOVGhhMjFmQUhuVDFydlBSNEVnU0NHMDdPY0JLZXErZ3VNQmJDczFu?=
 =?utf-8?B?K0d6NnhGcnE1ajZrOFFsMHpINVZqR3p0RlB5TUpFQjVGY0R6bU5KK3RqTXRl?=
 =?utf-8?B?ZEx3T0wwZ015K096STZTeENZakM5d1dsWGRWU2l0Rk5wdXpHR1NzeEo4R1FL?=
 =?utf-8?B?VFFBelNkeloxZzl4STFNbWxFVXlzWTJ3VTZhSEdNMUlOVzh1cVVJckM5Nk9k?=
 =?utf-8?B?V0V1S0kyTTViYTh3UE5iWFlsT3R1OFlCb25PRDkycTVRVDlsUUFUZWZIQUF6?=
 =?utf-8?B?aElwR1ZRN1pKT3VuUnl0bHNkY1RkckpXOFo4dHZUVjJCMUxlL2lESnc4SGZq?=
 =?utf-8?B?dXpWNGdDWU9KUE5jdlF3RlFrdHB6U0lESWY0a1NPdnhIWndvTm93VW12bng3?=
 =?utf-8?B?ZzhKV3VBVHIyaWJNOWMrZFZwRmVKRURrR3JneHFpSEVUR3QvVXZVcUpOZ0Zs?=
 =?utf-8?B?azZiRWIyMTJia0FBbVNiWGdEN0hhS1ZvQ0RVclBRSXZodXlsajVuSENNdVVX?=
 =?utf-8?B?TTV1VU4rb3ZFT200YkN6VHJZSm1VOFFKVWt1SzBWWFJVZENXWERzSmIzYmFL?=
 =?utf-8?B?RUErQ2FER2ZhVkQ0cFJNMnI2bmN2cjRuUTJOOUxYK0VIcm1xQlF4UDJRejYw?=
 =?utf-8?B?bVFpYk1oZmY2OUt3dDdMY2dreCsxOTg4UWhsbDBNLzhhYkdlM1pEUUFrQjF4?=
 =?utf-8?B?VkZMa2tKazhTRmZhdllaNzc0OUVCZE55Rks2eGZIelJtNm5GNDcvalFwVXNV?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91B2E70DB978EB4E93134EC7B3243866@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426a454d-b6ac-413f-7138-08ddb02c9077
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 18:59:20.4753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 34d2JG6YHdHv+TiFbl9TSwy55DonlhCKB0CtEGYs07qP4F1XzjUslpdK1PBAL4HRvGdbQkFqKA/Gb+2mOg9zUUTMagfNYMpK/aRrm1DioBU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6218
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDA3OjI0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFRoZSBwYXRjaCB3YXMgdGVzdGVkIHdpdGggUUVNVSB3aGljaCBBRkFJQ1QgZG9l
cyBub3QgdG91Y2jCoCBtZW1zbG90cyB3aGVuDQo+ID4gc2h1dHRpbmcgZG93bi7CoCBJcyB0aGVy
ZSBhIHJlYXNvbiB0bz8NCj4gDQo+IEluIHRoaXMgY2FzZSwgdGhlIFZNTSBwcm9jZXNzIGlzIG5v
dCBzaHV0dGluZyBkb3duLsKgIFRvIGVtdWxhdGUgYSByZWJvb3QsIHRoZQ0KPiBWTU0gZGVzdHJv
eXMgdGhlIFZNLCBidXQgcmV1c2VzIHRoZSBndWVzdF9tZW1mZCBmaWxlcyBmb3IgdGhlICJuZXci
IFZNLsKgDQo+IEJlY2F1c2UgZ3Vlc3RfbWVtZmQgdGFrZXMgYSByZWZlcmVuY2UgdG8gInN0cnVj
dCBrdm0iLCB0aHJvdWdoIG1lbXNsb3QNCj4gYmluZGluZ3MsIG1lbXNsb3RzIG5lZWQgdG8gYmUg
bWFudWFsbHkgZGVzdHJveWVkIHNvIHRoYXQgYWxsIHJlZmVyZW5jZXMgYXJlDQo+IHB1dCBhbmQg
dGhlIFZNIGlzIGZyZWVkIGJ5IHRoZSBrZXJuZWwuDQoNClNvcnJ5IGlmIEknbSBiZWluZyBkdW1i
LCBidXQgd2h5IGRvZXMgaXQgZG8gdGhpcz8gSXQgc2F2ZXMgZnJlZWluZy9hbGxvY2F0aW5nDQp0
aGUgZ3Vlc3RtZW1mZCBwYWdlcz8gT3IgdGhlIGluLXBsYWNlIGRhdGEgZ2V0cyByZXVzZWQgc29t
ZWhvdz8NCg0KVGhlIHNlcmllcyBWaXNoYWwgbGlua2VkIGhhcyBzb21lIGtpbmQgb2YgU0VWIHN0
YXRlIHRyYW5zZmVyIHRoaW5nLiBIb3cgaXMgaXQNCmludGVuZGVkIHRvIHdvcmsgZm9yIFREWD8N
Cg0KPiDCoCBFLmcuIG90aGVyd2lzZSBtdWx0aXBsZSByZWJvb3RzIHdvdWxkIG1hbmlmZXN0IGFz
IG1lbW9yeSBsZWFrZHMgYW5kDQo+IGV2ZW50dWFsbHkgT09NIHRoZSBob3N0Lg0KDQpUaGlzIGlz
IGluIHRoZSBjYXNlIG9mIGZ1dHVyZSBndWVzdG1lbWZkIGZ1bmN0aW9uYWxpdHk/IE9yIHRvZGF5
Pw0K

