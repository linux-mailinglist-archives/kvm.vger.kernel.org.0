Return-Path: <kvm+bounces-13380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA68F895852
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 17:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD68B1C23337
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 15:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3901F132464;
	Tue,  2 Apr 2024 15:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T/0qsmgr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80EC1E480;
	Tue,  2 Apr 2024 15:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712072270; cv=fail; b=KB2WaMiDZdyVZu+E/n7npO/x4CTvEv3bjRDd08kv4OpowO2e/GMg+fG8lzwKHiMKkLnxA0LvMbNgEHjlV5AgaQAf5d9B3K46AH+yeIsL4sZFUsMnEB0AGsl+8bQrd09gD3MidphKuvgaAKRjBJgAf8S0cwlImTNWyHan97wTIKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712072270; c=relaxed/simple;
	bh=lXEoehiGAGwAef8r15Q85HKPQ6Dxv+H8PCdH3N9tjfA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GoiXOLF4vNivQ6ixs9FqPXd/gALR9HhHbb8SgTrLBnLfd35D6CHA0vgwLCGdO4MnxdApo9IWiBUcerpRrSgWNoiu1A0Rs2ALQ3NSXUMCbSH+5EtfF0oJxmiodIPlTPkfXES8zi3mJ2rG/nOWak2FUG5j9ZSXO3zmXUf7gKX+F8o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T/0qsmgr; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712072268; x=1743608268;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lXEoehiGAGwAef8r15Q85HKPQ6Dxv+H8PCdH3N9tjfA=;
  b=T/0qsmgr09A8Ph2GXIrJUsg+SFOA/XR6QnhnHgAuX3aVKQMDoNvthdW0
   p1FKyChu/Hv32G9/B8IwWsAVuDA1JWk3Vfdpw9nK4dBYtTBxWShWFp/PS
   fKZTnK3+I+SrF4sRnSRZwnyKINDIplx/XYe3xVPvr8j4a4EbE3c+33w8y
   UPyOGfDRyzrPMMvUo+iD2YoJA+sEpGPa+Df51ZPPPsQUq301sZ37nTGKt
   nkFHJmSDs5Ms6HXgWpA8Kc9pS9VwBM9b7R0ncMWGhfXLWk915xODrbI+M
   YS1ljIcgFHrl89luAJlSGLaCvuLeXLeC0VMYIzrVCRhaSq1SVb8zhBeRl
   Q==;
X-CSE-ConnectionGUID: dmX62T+2RrWSHIo2OJMr3Q==
X-CSE-MsgGUID: nuyGM14WToS+U7RN44kcUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11032"; a="18410079"
X-IronPort-AV: E=Sophos;i="6.07,175,1708416000"; 
   d="scan'208";a="18410079"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Apr 2024 08:37:47 -0700
X-CSE-ConnectionGUID: 8HjbV6+aTPWgiE6wt2qo3Q==
X-CSE-MsgGUID: WkDJxqYLTAa3yUG+3Nxxlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,175,1708416000"; 
   d="scan'208";a="18687882"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Apr 2024 08:37:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 08:37:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 2 Apr 2024 08:37:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 2 Apr 2024 08:37:46 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 2 Apr 2024 08:37:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HjSZN50zh2MyHUelaYtr6e9rhfixe2lKJGp272VYlLt0o4XF85YOHj3SUelYne9jy8xs8XJNseHp/FH3e9aMjrBcdWO4UvJqpYCXlIh5wo2T8m2ZfKcy2B/Tx/DV8KZgTKa533eOQZSZqi/qUYwWO97a2BOd+lu89PpTJfw/KgWFfs9huKDXljPSM5nxqjucTUd9RDDMQrpSWgDnjYSAOsirZVL5noA62D9KvfmtweqgKQ2gr0ROU+9p7K9H+9/mFEtgoRqZeXZ/sDHTbD7Or8lOvnWjhBYFtNPE5sAoFUN99urJWA0upSFHo45B5ZJMgmBqSX7ekZAR2UB9VWfJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXEoehiGAGwAef8r15Q85HKPQ6Dxv+H8PCdH3N9tjfA=;
 b=MeWfEr/sRu4bK1DBFRF9E4sG7XbKhZG4fGHCUOt78a6+ivbZfq4dpxYCMvv6dcgVBW6GV+7398rJQKsvxZpi98ydInBXSQzWU7QlZyVXjjPNWfLONGF1KlR1a9CwwxMUqBtUcHiURPYGvaSZQfaFHaEmTE2ACLnRLoVRsjwk9f+Q64GsVgZ90Uh+lzArm8IQXgjL8yoYnHZrufbC6ebLCWgXmxzUCCKkFKPW8aoFztQH0lRpUsSIkMcirH2jkNx7VN9Wo1i0ykVgmRSM3cyiimzzgPueVXWcvrr/iljuZSsmAbaQlf6XaJmYmO8xD0vkeFPJZXmxtDVoPQG8cc6BLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW6PR11MB8339.namprd11.prod.outlook.com (2603:10b6:303:24b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.25; Tue, 2 Apr
 2024 15:37:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Tue, 2 Apr 2024
 15:37:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
Thread-Index: AQHahROw4OdylotJ/E2mNUes0vqsdg==
Date: Tue, 2 Apr 2024 15:37:38 +0000
Message-ID: <848d6bb6e4b0c53b6870bdc1cdf0c22e766313ec.camel@intel.com>
References: <20240313003211.1900117-1-seanjc@google.com>
In-Reply-To: <20240313003211.1900117-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW6PR11MB8339:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KTGlQvaq9Mt7vylPVq5/ZjWk104sAb9gtrvU8niXtBvPtkWR7h2ANP0pxwdVaUIVUOU6ehAX7PCK72bKW1Hyu5vUqnysMACpt/e8k+Ker09xFJnMj9yZS6yI+xmWrsQU5Ttg9vt/MJ/473Alw3iCYJJSkZSC7DYraUfGkZAA/2/3uymiW2f091gTDTvNMGt2UZ4l8EKr/Mea4NHB5ByygbP0BBygUXRR8OUyEvr6oKI+0ccbNoF7T/cnEWiRKERL/jgnX0+Lpa3hFeHW5+xNITje+S75yRwqNumusizKJ44a67rdArspF04+DksI8+YTWZjvPhVYhFhOICZ+rzb27FQKIIH3XSC2622vUYYmnsfKYwPOqBo1LHB3PQ6rBcKnhDQctBRvoNGJZEzUjtekeyBOSv/+9CUqkKZ+raJjPDufztn3mXmmBd217RVe425dPPbnwedsdUg0d2LhbR20j+2E7aGhZRt8oihJwCYrqGnkvc3f7aOeGBB+F2K9fKTBy9bl5eZjeuQo1oYZDJgQ9sqGultNUThGj9bhJtWtn5doNqZeQqmoVaMTnaNWyOUJmbBp9bZW1KWDufxdN9RWEEFs2VA10UL0SQ6QKZTLg307heHSBNZWCsNeEtKMmJcktlXJQLHWjORcXK5rSAp7Lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MklFWGloek1mcHd0MTFmU21CTmtXQlJBM0dCRkpHOU1jSlIrTXkwS3B6OHlP?=
 =?utf-8?B?M0ozKy9kcXRiVGhwT0lZaUFWbTJzVFdsdE4vaDVZNnZYUHVwY2g5ZFB2bjNi?=
 =?utf-8?B?TzJFTzQ5UTQ2SVVJZmpTOHFnbXVROEM3YWdzU0RXY2xiL1ArOU9YQWUyaUwr?=
 =?utf-8?B?NmY0UVpyWGE1amo0N2ZlVit2eFl4T1hvYUxIWWVFZDg5SnlWQ0J0TkJNbFgr?=
 =?utf-8?B?MU82SDJUeHgyeEI4eE1yREJuc09kd0NKYTFQVFBGaHFrQW9QdjNUNjlLazlL?=
 =?utf-8?B?STNCaVlSbm5Bb0VDNCtYNGp5d01taWNMVWhod3ZVb3lHRXhXcDB0andleHR6?=
 =?utf-8?B?d1VQQUZ0bHNqQVVpbFI4RmpXM1RJWDlxbk8rbGt5cThkaXFYdmxsdkZqZHp4?=
 =?utf-8?B?aWx5NnJxOUprU3ZPQktLT1B1cUZYeW15YkJNTEdEc3RmSEFsWEdjdnJaSWk5?=
 =?utf-8?B?UDJDekRvOTBrUnV4UDQrWGhqd2c5WFhZK2JOVExuVEI3ZVZ6cnBacHRUamZw?=
 =?utf-8?B?aC9KSGUxQTVpUUpwNElOTU9IaDJjVFRkajZCNUQ1elVEZ3l5NjBFekpnVkJB?=
 =?utf-8?B?NU80VXVDK0tTdy9hS3ZJNndqK1FVWGdKWDhzdzJtSXQ0WFA4cGo4bFExby9i?=
 =?utf-8?B?QldNNzl3RUUra3RnT0NXSjkzVE9xcmFUc1FnMUVqWXFJQnBCZFpuZlVrdXFH?=
 =?utf-8?B?OWtvL3lsSGVLWlFkcE02ejJyZTNKNHMrcDhpWmYyWlF0b1VZVkgrNGltOUNz?=
 =?utf-8?B?b1lMWStsTUczN1N2akZkcUhtQTNneEZ1SEF2UVdVMkVMYmdkK3ZSWmU0S1dS?=
 =?utf-8?B?UWNrWmFtc09pRFBQRHZwd1ZCRG81RktrdnJQTGduZDVuWEZMeFA3bG43UzBt?=
 =?utf-8?B?b2hvcHdmelMzbVV1VU1IN3ZLQWFhRGo3YW5tWVpGZmdoNEZJMk5FR2dGZWg5?=
 =?utf-8?B?aG1qd0FSeHBBSHNOSkNXckNaVWNsV2poOXJTS21GNExxeUhuYkNVMTN1T2F1?=
 =?utf-8?B?S09ycTBWMmtZclN0SHgvemRlUnMwTFZqQUNUK1YyT1BPakNlcldGSzhWbFlE?=
 =?utf-8?B?SUVYaDRWcHBHZTd0MTNGSnNWdnlaN0lMbUF1Z3Z5aWJUNDVFUHMrM1hNU2xR?=
 =?utf-8?B?OU1ncUZ5UVN0QjJMUVZiWEFPcTJTcjNNUlF1clJZYWNSTm5sU0xxT1doQTF4?=
 =?utf-8?B?cWE1NHZ2VU9oU29NT2lrQlF1OEhHcXN2NUZBQi9lU0ZHVGJhdDJjT0x6YUJK?=
 =?utf-8?B?VEVLYm0rT28zNk1qQ1hlN1BmaUQ2VUtRend0d1RBS2l3R2w2TVRtQ1JaNWJV?=
 =?utf-8?B?aDc0ZzdyVUhvdHdaM0pwQjZVV1gza1hCMkEwVFR0NTJRcnd4OFlmZmVKMnhV?=
 =?utf-8?B?RXNiczBGZ0FzSEozOUZtcXhxTEl6UUloTmpsajdHZE9wV3MwYWUxN25nVlhE?=
 =?utf-8?B?TnRlY0pjTm1wT0E4Z0xuTlUramd6MXdtQlFIR3hNdStQc0p4V0E4RnVMTnlv?=
 =?utf-8?B?UklxQlJJa3NkVmJtRC9GN2VUVXdrczBzTGJJNzUxQWQwVjBEbmg2c2l1UDlZ?=
 =?utf-8?B?NzRMakJWWCtHVTEzZnRrSDIrMjNDY2tlQS84azZOSnJZWVl5ZS9TZ2pGS2Q3?=
 =?utf-8?B?bThRbUZ4YnN0aVp3clBOKytCSjUxMkJVd0hlbkZDV2RiZEh5UTNhQTA2RDRU?=
 =?utf-8?B?QUJQN2ZBSHRtbnVPcXBPRG90bm1aQmV1azJhaS96bkVmckRxbTFuR2ttL09S?=
 =?utf-8?B?d1RWeDhuRHozREIrUnBwUHZaMC9sc1dMOEY4ZVVSKy83THMyRTR1eW00cisx?=
 =?utf-8?B?YjF5RUM1WkgxanR6N1ZHeldqUWxBelBSU0RyMUlMTmw0TDZEVDJBWFVMdjND?=
 =?utf-8?B?eEE5SUd6dUVDYXdYRkMzSkdqczNPYVdrVHJBMkQ5WXlBOUV0ZEcxWjBuT0ZU?=
 =?utf-8?B?QnVuc1hhMjFCdm1GLzdMN2Y3YmdsZVlFY0FmOVF4Vm5mT2Q4RmRaZlF3ZVN4?=
 =?utf-8?B?bDBTTEc3Qjh6K1RIK01PSnhhZktuWEMyaFBENHRWOXlpcTVJRHdBZUVXZ0E3?=
 =?utf-8?B?cjZic3J6ci80RmxFMDVudkNlNlZDK0k0THE3bXJORDJlZlpvVTJEVFhKQzRI?=
 =?utf-8?B?c0lhNVRZRWdRZXZ2QTE3ZllRVkJBa2ZzQlIxSnFKTXZINXdNcWlCUEsvNFVV?=
 =?utf-8?Q?Ncb3ku+v0OT2aavHAF+qOBA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <774FDBF18D9D4143A1DB4802405247D0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37d572a2-4d1f-47ad-364b-08dc532ad382
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2024 15:37:38.1453
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4FdX5i3ekm1j6TAh0/Xd/FIHpju1B9b/l5hbnEIlPifqlsgRJUsyPpL9QJtivfLP6pZpRghvl+C80sCiI3CGABqmjHsVKgRsErfmtPmXHYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8339
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTEyIGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBObyB0b3BpYyBmb3IgdG9tb3Jyb3csIGJ1dCBJJ2xsIGJlIG9ubGluZS4NCj4gDQo+
IE5vdGUsIHRoZSBVUyBqdXN0IGRpZCBpdHMgRGF5bGlnaHQgU2F2aW5ncyB0aGluZywgc28gdGhl
IGxvY2FsIHRpbWUgbWlnaHQgYmUNCj4gZGlmZmVyZW50IGZvciB5b3UgdGhpcyB3ZWVrLg0KPiAN
Cj4gTm90ZSAjMiwgUFVDSyBpcyBjYW5jZWxlZCBmb3IgdGhlIG5leHQgdHdvIHdlZWtzIGFzIEkn
bGwgYmUgb2ZmbGluZS4NCj4gDQo+IEZ1dHVyZSBTY2hlZHVsZToNCj4gTWFyY2jCoMKgwqAgMjB0
aCAtIENBTkNFTEVEDQo+IE1hcmNowqDCoMKgIDI3dGggLSBDQU5DRUxFRA0KDQpJZiB0aGVyZSBp
cyBnb2luZyB0byBiZSBhbiBBcHJpbCAzcmQgUFVDSywgd2Ugd291bGQgbGlrZSB0byBoYXZlIGEg
ZGlzY3Vzc2lvbiBvbiBURFggYmFzZSBzZXJpZXMNCnVwc3RyZWFtaW5nIHN0cmF0ZWd5Lg0KDQpU
aGFua3MsDQpSaWNrDQo=

