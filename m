Return-Path: <kvm+bounces-9368-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 435C785F552
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 11:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7EF5B24B6A
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89FE03987A;
	Thu, 22 Feb 2024 10:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJuYSwLB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D033717C;
	Thu, 22 Feb 2024 10:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708596566; cv=fail; b=T5GTcjHW/a5KMVuWcR29UXkdoM9VcZPu49WvevMv9f0n7wvpx4V9TKnsdI4AcI2c8p7Ef0da45pRnXskNbpmTZYYaHQRD52ol9rzSt89L8jyukCqy2MM0c4u9JazOw6OA0q+7lfWabEq0QlcSJ4bXGwEust7nZMUDi6XDFauWSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708596566; c=relaxed/simple;
	bh=pFL2X5pM7MF6ucYDpB+rPVDR+WS1GKOtAiY5Wo9hJeo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uQ+ztdPlKN0RZC1bqeeiKaiNPp2lp5t13ofTS5Sp2UFBrJwiNQ4SU1VMj8HauXqZxHeKciD+dh+jxryXwVG22tUDAJYL3RKNlfvLUZ7qTKIsHV2ls9IHnYmRA9nYIoLpxDast1UVYd3lKAyJQ7floH5Sy9tbspoX+RTJ+cTV7k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJuYSwLB; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708596565; x=1740132565;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pFL2X5pM7MF6ucYDpB+rPVDR+WS1GKOtAiY5Wo9hJeo=;
  b=cJuYSwLBE+HMkySSoTcGk3mHbC/a9sB74bh6zp9wjJE3HyMV11h+XH7h
   BMMaZLTNsiLYXeEyuzXdpiwRP0RTPLpmm9YCBFw++SJIrWhxc6/UcCkas
   QxbHWL4vUvZr0wvm8NZAvJpFqn6/q6/rmCS8BTrl0KAXc+ylaJC7Igg3D
   TiQXeqcV+IVR1RvIGORX8qpfAvAMYFVxWHsl8OFfpCIB4/7xb7zEn44zz
   m9OEgTt+tVS/bQEIlevpKPVsr0wlP+akS59nQCRx0IV/xvGm1cdV5L+Pd
   6sZ/xCoFdDADZcM1uknteT8J6M00/4Pi04+LbHyKqHAujyjw4mas/N0DD
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10991"; a="3304484"
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="3304484"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2024 02:09:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,177,1705392000"; 
   d="scan'208";a="5755279"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Feb 2024 02:09:23 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 22 Feb 2024 02:09:22 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 22 Feb 2024 02:09:22 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 22 Feb 2024 02:09:22 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 22 Feb 2024 02:09:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VOtrJkW05K6ZpdEKoGxM/BkAnqkv3DrpiQeKsp2xAN3rSP5MlP5swje3OGTFWs6QTLMeXzrG4J/7X0U+Ir512vnD2TwjSuJhGSNXJsRw80H6h2qyknNbesm1PEc/xoI/92uKCd1ltFonQET7UZTF6YrQ1uHRfq04kS1JWRRpjga8SW/VqB1P4jPjwGO8XNFtXHRHnkSpibl4YYRJ65lbGx77XhKbyN7J0WaP97C/CYIkjPjybRlL0ALz9AE/NjaXO4LqLjVtJyHLMqz+aBZW2Vfa3J/N6Fp5eC0Q3Ke1TtGyOdhawIPmBi3YpmYmgMI/u/TGyr1gpLmQ68gaF03YTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pFL2X5pM7MF6ucYDpB+rPVDR+WS1GKOtAiY5Wo9hJeo=;
 b=ASanyRSAn7WaawQBXemwblKMOoZ+Qw9oxFpPxqGnv8FFVupjfyUY0NArQk0qUwjWQofHezxrEp8oOPnvwDx3+1enZU0YLMq7DdtAH9z5B036eH0OJgwB7aJIxrsJUvJU8WhsFq5JJAmQkDQXKCvFPYQVtGXoltjQgQVWaNEz26CWRmDOof3VaC9uaVFJu5GOeRpcl+A5V0pWyVRZpLc/sChxz4TuG4mXrKcBW++Eu670S36vT8/5iZ7T1ZBAeS7912/27ZCe1IgKxAUMqDK0u+jKFmPVcoXgaNw1YKib0JlwXVQ98/52nRvGJIu7HpcS8BiTCpRQbQIOx5H3xDJyfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB7280.namprd11.prod.outlook.com (2603:10b6:8:108::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.38; Thu, 22 Feb
 2024 10:09:20 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.009; Thu, 22 Feb 2024
 10:09:20 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "f.weber@proxmox.com"
	<f.weber@proxmox.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
Subject: Re: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock if
 mapping is changing
Thread-Topic: [PATCH v5] KVM: x86/mmu: Retry fault before acquiring mmu_lock
 if mapping is changing
Thread-Index: AQHaZS42AzvE9IDdHE2D17kq53GfLLEWJAaA
Date: Thu, 22 Feb 2024 10:09:19 +0000
Message-ID: <8973cd56d9069ad8d21a404373d95276ebdcd37e.camel@intel.com>
References: <20240222012640.2820927-1-seanjc@google.com>
In-Reply-To: <20240222012640.2820927-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB7280:EE_
x-ms-office365-filtering-correlation-id: e7817711-8cf9-4144-db9e-08dc338e55f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JS4hiq8eB17W8H1G6FfGOCso7YfFghjyuUBu+02oFk2UbZzx3keFoqrRceyrUph3F9UahUqCWm0+tlSO9ywMt4UnAdgIclImFduL/lXjuMiFjuZEIiDUrJs1lJfXRQODJRy1VlaiJHEw/pJhJAN7X5cQRIjlHp/N5un9bLsXB5qPEPXQJpjfC6JBhpjY18OlUE2WDE3lLIzmmuFrlqeXpwsMRvN6BtMuVsBbJZn96QFckxcTZPMbXNLiHqhwZNMga553dWWMsiwCBK9LQbRNBYW3r8fHwSTDa0rT5labsm5aeTioI7jupCBJOoomqry3SpCsNfYI4eNEr+y3E33YFUiHir9KySY/Pwb/d8PHjynD5gSLZeCfQLVDxStXh7/9hmvfamEXAoyZgV8ZeEeQvJgRSz7k30HNDOrwTXLI2qOD5zp16EcC1IjmKtd9fB8xkgNAKzBF3KU0OrEMXer2AQ2gScsdhXxRnTBvGkemgrGqURSWUEy1HmRSa80m1p9SHA+xFAZKNki2lba+EEmUJYYh/8VAdKkjPBi2/NsPrU2I+wZkcVRBQjjE/FC6C5/ifFebGd3ksW+bAUtkZ/vQW6VrKnGdAH/5BIbckk1vKUk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHdjYXJVWUs3QklYTnJQTHJoL3VoMTE0NGF2RTAvR0oxN09mSDdkdStsai9R?=
 =?utf-8?B?SWJnT2ZidnpYc083NnJuaWpRaFVQUWJiN1hudDE1cWNWWk5za0kzb0ZtN3Yw?=
 =?utf-8?B?cGNKMkcwVXBUMWUrNTF3N3JEQVQyN0lWbklMTXpaRnBuaDZmblVvSTFsN2VK?=
 =?utf-8?B?Sy9FNWlTT2JvYkRjZ1FzYXRleWU0WTQ2S3p3SnIrVm9meEovLzMxNDRzOCtn?=
 =?utf-8?B?WTBQenBXMDA2dzBqUExiWlBEdmNpVUxjSm00ZGhkdk5iaFF3b3NhNlFHNHAz?=
 =?utf-8?B?am9GYjJNNkxoVXBqemtVVUNHY2d3VHdUN3A2M2NsYlU0VkNnU2o1YmppOE1J?=
 =?utf-8?B?OUNxdzVPVUdBVnhMZlJPd1k0K2VQYzdWSS92OTVXUktnU3ljWXg4YnRXOWJK?=
 =?utf-8?B?ZFppR3YyZDRIS1ZtcnVDZEpiNi9KSzJubjgwTlBnZjY3L3ljUERKckFIaTUr?=
 =?utf-8?B?WXUzWDRCSm5KSDdVWCtlZC94M2txZTByTG1aaVozcSt0L21NbUVsbHIxYTlx?=
 =?utf-8?B?OUt2VWdiUi9pN1dyblp2cmFQdFVBSld3WlhCbWxtcHZGWGdoY0FkWGJmcFBQ?=
 =?utf-8?B?MGgwWHkrd09BNTB6dnltQ01jOWV0T0d6SHZYZGJTTGNzSWZqNU1ROVdxOWFj?=
 =?utf-8?B?VWR4ZmlESkhKN1B1Ty96Zk5Xa3psL3dpRysxOC96MWh4bGxkM0MzMFNSeGMv?=
 =?utf-8?B?WGsrOW9pQVN6MlphTlZabDdhaWk5SDBON0dDVUdQcjNKRFZQNm14M2NzNG96?=
 =?utf-8?B?cm04Wk1sa3dRMEd0bm9GeEZPcXhBaHZHY0dMU1diUElCdk1WNjdFZmcxbldw?=
 =?utf-8?B?b3hYMkFQSkI4RDJqQUdCMGl5cUlsZ2F5cTkrT3JzUmpSRDBnYVVtZ2xrdlRZ?=
 =?utf-8?B?eFVMYkdINm4xTWtqMlJPN0pxdThpL3k4UmliLzQwVFRYdUFlbnd6M3YvWXF6?=
 =?utf-8?B?anhaYlIxZFBYbWdwT21IUHJpdVFrdithOXo0SG55d0xOYVRvUERsOUlwdktI?=
 =?utf-8?B?UTN6QWlwTHUrM2xJZmJWWkRDWmloYnlHNlR2eU9iQmQrQlduMjYxVWx5RHRm?=
 =?utf-8?B?Y2JLeGpoR1dMMGh1bUpzMk1GNEFwRFdRenl6eUl6QlV5dkF4Y3p1bWovSThy?=
 =?utf-8?B?UmMzQVd2dkJLMHZ2bVYzVUxSK2xIdkEyTWlGTWNuQlJnTU5zSWpQc0wxZzFZ?=
 =?utf-8?B?eGN2cVV1eWpDZkJWWVVsQklQQXFucG9QM3pSSjNmQm9Vdko1aXRIMmViWEk3?=
 =?utf-8?B?R2ZPV0s4bWtBb2tjbjdxbFFWVmkrTVlCcjBLUHFzRnpHbVZIU2ZoekQ5TC8z?=
 =?utf-8?B?ckQrVjd5WEk2TWdGcVpQMlg5R0IzUHdDZmE1cnUyMFBLZmVrOGM0QkdOOTVs?=
 =?utf-8?B?TmlRUkxWaUJIaU41OEhnY3lYelJ6Sm9IL0puWmphWUxnWTkxY201dXIwbmVJ?=
 =?utf-8?B?MzRscEJMeUw4eVEzcjVmZUkxeEc1RnRkTWJGNXRERE4reVlIaVBCemJ3Zysw?=
 =?utf-8?B?VFZ6K3dIREJacnlyQmJFY0EvSitYdndYUUI4ajdTNnB2RHp5TWZWQmNnNkt0?=
 =?utf-8?B?MHhEQTk2SENUN1NVb0pGcFdFcWxQSXhUNVF3WEV6WmdaSmwrOXh2cTVGS0RP?=
 =?utf-8?B?YVVLTVFFSGpyREFOcStSeDBLSlRLY0cxZFFoQWNjdDdtaUFjUTFDUENVNlRH?=
 =?utf-8?B?a25QZFdqMytBWDhwaVFGd3ltdUpBemJ5b2dTMzJOQmtHZWxNUzdNKzhOK2JF?=
 =?utf-8?B?SWhEd2UreGpja25LdUhFMEEzcyt3QU1ldmRLOUxzOVJVa3lQUmx2NmVsbXdN?=
 =?utf-8?B?Z1Y5MXB1cWZBakloem81Wnc5R2p4NXVUVFdGL29ONkxUOVFCOHVQbGYzVTVX?=
 =?utf-8?B?TjU0aTc3clFLWEZPbmpwbUFYQ2tIKy81aklsU1lLa25aa1paTHp0M04wZDll?=
 =?utf-8?B?bkR0QTlSV2hhNWNZdEorb1dSZE12S2U2dEpReEk3TElWb0QxV2VLVVM0OGV6?=
 =?utf-8?B?TUpKaUJuc1ZKZWJNQ09ySUQ1SWdMUDRJMVRHZG05R0gybjlubTk2dnBPUjFI?=
 =?utf-8?B?dGF5Vk92YUNpcHpNQzJEelU0SkVLc0pIWW1DUXhYL0tCTGRuZVFpem4ydlV6?=
 =?utf-8?B?cTlSOGNYZmpLTUYrcnNWVWMvV0JjOGszNkRKZk9xSFRrL0pxR2FVRThpc1ZK?=
 =?utf-8?B?c1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D2E676FF2F30924AA54AA8572C1D39E1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7817711-8cf9-4144-db9e-08dc338e55f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2024 10:09:20.0018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: muVhpQSRrS0Sd24bAyiyxe6peIp0LttVTq0Cj73ZaPw3NIL25+lOES+imblePP1uNQEPLjnce6k+KnMNGcev5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7280
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTAyLTIxIGF0IDE3OjI2IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXRyeSBwYWdlIGZhdWx0cyB3aXRob3V0IGFjcXVpcmluZyBtbXVfbG9jaywgYW5k
IHdpdGhvdXQgZXZlbiBmYXVsdGluZw0KPiB0aGUgcGFnZSBpbnRvIHRoZSBwcmltYXJ5IE1NVSwg
aWYgdGhlIHJlc29sdmVkIGdmbiBpcyBjb3ZlcmVkIGJ5IGFuIGFjdGl2ZQ0KPiBpbnZhbGlkYXRp
b24uICBDb250ZW5kaW5nIGZvciBtbXVfbG9jayBpcyBlc3BlY2lhbGx5IHByb2JsZW1hdGljIG9u
DQo+IHByZWVtcHRpYmxlIGtlcm5lbHMgYXMgdGhlIG1tdV9ub3RpZmllciBpbnZhbGlkYXRpb24g
dGFzayB3aWxsIHlpZWxkDQo+IG1tdV9sb2NrIChzZWUgcndsb2NrX25lZWRicmVhaygpKSwgZGVs
YXkgdGhlIGluLXByb2dyZXNzIGludmFsaWRhdGlvbiwgYW5kDQo+IHVsdGltYXRlbHkgaW5jcmVh
c2UgdGhlIGxhdGVuY3kgb2YgcmVzb2x2aW5nIHRoZSBwYWdlIGZhdWx0LiAgQW5kIGluIHRoZQ0K
PiB3b3JzdCBjYXNlIHNjZW5hcmlvLCB5aWVsZGluZyB3aWxsIGJlIGFjY29tcGFuaWVkIGJ5IGEg
cmVtb3RlIFRMQiBmbHVzaCwNCj4gZS5nLiBpZiB0aGUgaW52YWxpZGF0aW9uIGNvdmVycyBhIGxh
cmdlIHJhbmdlIG9mIG1lbW9yeSBhbmQgdkNQVXMgYXJlDQo+IGFjY2Vzc2luZyBhZGRyZXNzZXMg
dGhhdCB3ZXJlIGFscmVhZHkgemFwcGVkLg0KPiANCj4gRmF1bHRpbmcgdGhlIHBhZ2UgaW50byB0
aGUgcHJpbWFyeSBNTVUgaXMgc2ltaWxhcmx5IHByb2JsZW1hdGljLCBhcyBkb2luZw0KPiBzbyBt
YXkgYWNxdWlyZSBsb2NrcyB0aGF0IG5lZWQgdG8gYmUgdGFrZW4gZm9yIHRoZSBpbnZhbGlkYXRp
b24gdG8NCj4gY29tcGxldGUgKHRoZSBwcmltYXJ5IE1NVSBoYXMgZmluZXIgZ3JhaW5lZCBsb2Nr
cyB0aGFuIEtWTSdzIE1NVSksIGFuZC9vcg0KPiBtYXkgY2F1c2UgdW5uZWNlc3NhcnkgY2h1cm4g
KGdldHRpbmcvcHV0dGluZyBwYWdlcywgbWFya2luZyB0aGVtIGFjY2Vzc2VkLA0KPiBldGMpLg0K
PiANCj4gQWx0ZXJuYXRpdmVseSwgdGhlIHlpZWxkaW5nIGlzc3VlIGNvdWxkIGJlIG1pdGlnYXRl
ZCBieSB0ZWFjaGluZyBLVk0ncyBNTVUNCj4gaXRlcmF0b3JzIHRvIHBlcmZvcm0gbW9yZSB3b3Jr
IGJlZm9yZSB5aWVsZGluZywgYnV0IHRoYXQgd291bGRuJ3Qgc29sdmUNCj4gdGhlIGxvY2sgY29u
dGVudGlvbiBhbmQgd291bGQgbmVnYXRpdmVseSBhZmZlY3Qgc2NlbmFyaW9zIHdoZXJlIGEgdkNQ
VSBpcw0KPiB0cnlpbmcgdG8gZmF1bHQgaW4gYW4gYWRkcmVzcyB0aGF0IGlzIE5PVCBjb3ZlcmVk
IGJ5IHRoZSBpbi1wcm9ncmVzcw0KPiBpbnZhbGlkYXRpb24uDQo+IA0KPiBBZGQgYSBkZWRpY2F0
ZWQgbG9ja2VzcyB2ZXJzaW9uIG9mIHRoZSByYW5nZS1iYXNlZCByZXRyeSBjaGVjayB0byBhdm9p
ZA0KPiBmYWxzZSBwb3NpdGl2ZXMgb24gdGhlIHNhbml0eSBjaGVjayBvbiBzdGFydCtlbmQgV0FS
TiwgYW5kIHNvIHRoYXQgaXQncw0KPiBzdXBlciBvYnZpb3VzIHRoYXQgY2hlY2tpbmcgZm9yIGEg
cmFjaW5nIGludmFsaWRhdGlvbiB3aXRob3V0IGhvbGRpbmcNCj4gbW11X2xvY2sgaXMgdW5zYWZl
ICh0aG91Z2ggb2J2aW91c2x5IHVzZWZ1bCkuDQo+IA0KPiBXcmFwIG1tdV9pbnZhbGlkYXRlX2lu
X3Byb2dyZXNzIGluIFJFQURfT05DRSgpIHRvIGVuc3VyZSB0aGF0IHByZS1jaGVja2luZw0KPiBp
bnZhbGlkYXRpb24gaW4gYSBsb29wIHdvbid0IHB1dCBLVk0gaW50byBhbiBpbmZpbml0ZSBsb29w
LCBlLmcuIGR1ZSB0bw0KPiBjYWNoaW5nIHRoZSBpbi1wcm9ncmVzcyBmbGFnIGFuZCBuZXZlciBz
ZWVpbmcgaXQgZ28gdG8gJzAnLg0KPiANCj4gRm9yY2UgYSBsb2FkIG9mIG1tdV9pbnZhbGlkYXRl
X3NlcSBhcyB3ZWxsLCBldmVuIHRob3VnaCBpdCBpc24ndCBzdHJpY3RseQ0KPiBuZWNlc3Nhcnkg
dG8gYXZvaWQgYW4gaW5maW5pdGUgbG9vcCwgYXMgZG9pbmcgc28gaW1wcm92ZXMgdGhlIHByb2Jh
YmlsaXR5DQo+IHRoYXQgS1ZNIHdpbGwgZGV0ZWN0IGFuIGludmFsaWRhdGlvbiB0aGF0IGFscmVh
ZHkgY29tcGxldGVkIGJlZm9yZQ0KPiBhY3F1aXJpbmcgbW11X2xvY2sgYW5kIGJhaWxpbmcgYW55
d2F5cy4NCj4gDQo+IERvIHRoZSBwcmUtY2hlY2sgZXZlbiBmb3Igbm9uLXByZWVtcHRpYmxlIGtl
cm5lbHMsIGFzIHdhaXRpbmcgdG8gZGV0ZWN0DQo+IHRoZSBpbnZhbGlkYXRpb24gdW50aWwgbW11
X2xvY2sgaXMgaGVsZCBndWFyYW50ZWVzIHRoZSB2Q1BVIHdpbGwgb2JzZXJ2ZQ0KPiB0aGUgd29y
c3QgY2FzZSBsYXRlbmN5IGluIHRlcm1zIG9mIGhhbmRsaW5nIHRoZSBmYXVsdCwgYW5kIGNhbiBn
ZW5lcmF0ZQ0KPiBldmVuIG1vcmUgbW11X2xvY2sgY29udGVudGlvbi4gIEUuZy4gdGhlIHZDUFUg
d2lsbCBhY3F1aXJlIG1tdV9sb2NrLA0KPiBkZXRlY3QgcmV0cnksIGRyb3AgbW11X2xvY2ssIHJl
LWVudGVyIHRoZSBndWVzdCwgcmV0YWtlIHRoZSBmYXVsdCwgYW5kDQo+IGV2ZW50dWFsbHkgcmUt
YWNxdWlyZSBtbXVfbG9jay4gIFRoaXMgYmVoYXZpb3IgaXMgYWxzbyB3aHkgdGhlcmUgYXJlIG5v
DQo+IG5ldyBzdGFydmF0aW9uIGlzc3VlcyBkdWUgdG8gbG9zaW5nIHRoZSBmYWlybmVzcyBndWFy
YW50ZWVzIHByb3ZpZGVkIGJ5DQo+IHJ3bG9ja3M6IGlmIHRoZSB2Q1BVIG5lZWRzIHRvIHJldHJ5
LCBpdCBfbXVzdF8gZHJvcCBtbXVfbG9jaywgaS5lLiB3YWl0aW5nDQo+IG9uIG1tdV9sb2NrIGRv
ZXNuJ3QgZ3VhcmFudGVlIGZvcndhcmQgcHJvZ3Jlc3MgaW4gdGhlIGZhY2Ugb2YgX2Fub3RoZXJf
DQo+IG1tdV9ub3RpZmllciBpbnZhbGlkYXRpb24gZXZlbnQuDQo+IA0KPiBOb3RlLCBhZGRpbmcg
UkVBRF9PTkNFKCkgaXNuJ3QgZW50aXJlbHkgZnJlZSwgZS5nLiBvbiB4ODYsIHRoZSBSRUFEX09O
Q0UoKQ0KPiBtYXkgZ2VuZXJhdGUgYSBsb2FkIGludG8gYSByZWdpc3RlciBpbnN0ZWFkIG9mIGRv
aW5nIGEgZGlyZWN0IGNvbXBhcmlzb24NCj4gKE1PVitURVNUK0pjYyBpbnN0ZWFkIG9mIENNUCtK
Y2MpLCBidXQgcHJhY3RpY2FsbHkgc3BlYWtpbmcgdGhlIGFkZGVkIGNvc3QNCj4gaXMgYSBmZXcg
Ynl0ZXMgb2YgY29kZSBhbmQgbWFhYWF5YmUgYSBjeWNsZSBvciB0aHJlZS4NCj4gDQo+IFJlcG9y
dGVkLWJ5OiBZYW4gWmhhbyA8eWFuLnkuemhhb0BpbnRlbC5jb20+DQo+IENsb3NlczogaHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL1pOblBGNFcyNlpiQXlHdG9AeXpoYW81Ni1kZXNrLnNoLmlu
dGVsLmNvbQ0KPiBSZXBvcnRlZC1ieTogRnJpZWRyaWNoIFdlYmVyIDxmLndlYmVyQHByb3htb3gu
Y29tPg0KPiBDYzogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBDYzogWWFuIFpo
YW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiBDYzogWXVhbiBZYW8gPHl1YW4ueWFvQGxpbnV4
LmludGVsLmNvbT4NCj4gQ2M6IFh1IFlpbHVuIDx5aWx1bi54dUBsaW51eC5pbnRlbC5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0K
PiAtLS0NCj4gDQoNCkFja2VkLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

