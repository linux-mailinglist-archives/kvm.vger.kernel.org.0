Return-Path: <kvm+bounces-6138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AB4382BDE1
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 10:53:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 338551C25AF4
	for <lists+kvm@lfdr.de>; Fri, 12 Jan 2024 09:53:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6255786F;
	Fri, 12 Jan 2024 09:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Du9KTIU3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BCC56B74;
	Fri, 12 Jan 2024 09:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705053068; x=1736589068;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FPdfpw0WZUm/iOXzZuKfmQozG49iFsQuMT8wBOhSSbE=;
  b=Du9KTIU3QUpTNLnENOdGAkaKrfwD4bxAK88WPMVNxQX5RVx3ysPpmZiq
   oGMrmYWjoXMaddf5C7R+m3iIl2AmiWU9BAH+c0r/tg7S9IMHE7+bCeSrL
   3ru3C2VwI82x4Wux08Ki4ckeYph3TLXigIEpKr2B7jiyzp68P7NKIXXAv
   CWHRhFdwM5Wyq2XUAejMTbivtW+FYVix242fqmXZFjFYJBVOO3ZQEfs1L
   PPrOTP6IEoGXN68NdX06p7npYxqqd/O4MQZbOudGotjGz2jrIatqwYFwR
   d4TS45DLd2U5G2flmep14QduyuPC2BQtUdXl+uOa9OvR/epehu4g7+rVR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="485307053"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="485307053"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2024 01:51:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10950"; a="775958961"
X-IronPort-AV: E=Sophos;i="6.04,189,1695711600"; 
   d="scan'208";a="775958961"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Jan 2024 01:51:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Jan 2024 01:51:06 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Jan 2024 01:51:06 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Jan 2024 01:51:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEmAWTBIKyrz37qK6C7jBv2gDf4DllZWuB2wDHMZKkoX4diNy2u0y+/KinOoRtPv6uoA2xmkM40eRsHuDBA9JwG9vnjM/PmxVHioUJrKWT+eje+Wfq67gddWsQXlYj19vx8jt9bui/zvy3MDkkhvrmCWld2Fs1T3nH4aZ/zL6DDzXxHO2nhKfUfxKcLgpaJd7MmPm8CdpukLm4Xsg71AA6DIKAGkjxm7611uhW1WnX7N2dgPC4m46kXAHHUS4ej4y/lx8ob1mhbrqazbcEV9ofwVoZsbq6l0Nf7FX/uVf43IO1Pnw4gZ2cIb6snWy7UUC9g+XqJTcF46dk7ozOLdOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPdfpw0WZUm/iOXzZuKfmQozG49iFsQuMT8wBOhSSbE=;
 b=GvrxxDR0zR3pgSnXKzpwox9y2/6IAdWPpWWYa+KNfNshIrKj8tZgZSRMQx4Poei/ETFNMjIBfYJ2BZDUWcT+xjZzs5dQG06v/SjNZAK1p9x4WJ3XKhbJG31hJMddtjAi1VvsYmhwiUKr22Ooz0fDVXKaVyY6CMw9W04IA/qci9ejxTTIYKaPoG/7rc2gvGzZHehoi6xgljClKvvu0pE1qGhvJxEqFQitgBZ9meJBhzsVe3ATfS61jCVcGOO0mWZT9+l7BvKBk+5RasPtXsf3OY4ohHvInAIvc4qpPOa4Q/+1XlOt4zHWWDK3B5Zp5hhbCC/2TNRcKZW7fMz3/8VFMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22)
 by BN0PR11MB5710.namprd11.prod.outlook.com (2603:10b6:408:14a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7181.21; Fri, 12 Jan
 2024 09:51:04 +0000
Received: from SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277]) by SA1PR11MB6734.namprd11.prod.outlook.com
 ([fe80::8ccb:4e83:8802:c277%4]) with mapi id 15.20.7181.020; Fri, 12 Jan 2024
 09:51:04 +0000
From: "Li, Xin3" <xin3.li@intel.com>
To: Xin Li <xin@zytor.com>, "Huang, Kai" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Yang, Weijiang" <weijiang.yang@intel.com>, "Christopherson,, Sean"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: RE: [PATCH v3 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Topic: [PATCH v3 1/2] KVM: VMX: Cleanup VMX basic information defines
 and usages
Thread-Index: AQHaC4qSP11mhPXdtUaggDGBDHZ2JLBjmx0AgACNOICAcjlxIA==
Date: Fri, 12 Jan 2024 09:51:04 +0000
Message-ID: <SA1PR11MB6734789DDF72683C9C783F70A86F2@SA1PR11MB6734.namprd11.prod.outlook.com>
References: <20231030233940.438233-1-xin@zytor.com>
 <2158ef3c5ce2de96c970b49802b7e1dba8b704d6.camel@intel.com>
 <47316871-db95-4f72-9f3a-71743d97d336@zytor.com>
In-Reply-To: <47316871-db95-4f72-9f3a-71743d97d336@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR11MB6734:EE_|BN0PR11MB5710:EE_
x-ms-office365-filtering-correlation-id: 48d70093-f0ec-4525-2b12-08dc1353fdda
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /UIGaG4uvO0QAJ05icr221VwogGcEQ1FLDvLFmW2T/k6weV1qJiJ4fuolZb6vZpWI4A3mJhOaKqky91QtJGDtq6MPOrYoEAzs8o2fWJIHuUwxf9BzJUJK8J01YNyE22sxQoZT4GJ6bYKgtWbS15cRclrnsz+hff6TYNHaySus4hAK29LgqUBh/3bUB3K1n0b8U/HJBN+28VF0zZ2w6DqCqaB1Oq4xYzvJcwTrzgbdYDhf3lfuYsm/CXlZ0wwWRc0tsxpew7OrcPGImdNTYgSd7kvKBNvR3Es41Rg4E9RCImS6n2xze5vzVVtXMlWs66zkuDJ4WOCVGmc6G9csrBnuCrycqa5jezfljSRtqOxH+bEb+a00gvyo93tE5yAhysAPlAov2HxLKylOdOch2mo6sS3HnFu483u9jWwy+2Q0d1L+ug5JJPWbEMHMrG+taMmpADsu7XUq8AcVBw5QSfzk5eOLdWkQQ1VokzoF8HbkLhGLrr97sp3H6RPpt0QWDYqd8FaUVpSR975PhNqJseLQBa4tmqVMQ2bWPx+n/8HBRs4zKcrgeQENI0PFmIBiyGLE0J4fZAYMAHf3MuK8/ZdWkdGvI+uo9eIpTKALKU3ydWNAjZavS646La0AmpNZW3F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6734.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(136003)(346002)(396003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(82960400001)(86362001)(33656002)(66946007)(66446008)(64756008)(66476007)(66556008)(76116006)(110136005)(54906003)(52536014)(4326008)(8936002)(8676002)(316002)(26005)(71200400001)(38070700009)(478600001)(6506007)(9686003)(7696005)(122000001)(38100700002)(41300700001)(7416002)(2906002)(4744005)(5660300002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nk9CUDZxTWQwdXBMbVc1Z20vUFNrNk9QVjF5MzZzekF5aXFOa2ZpdW9mME5L?=
 =?utf-8?B?NVdCOFlHUzZIMlJPR1Q4RnRMcGdFY0ZFZDdzdkN6SldXWXI4QWdDa0Q3aS8r?=
 =?utf-8?B?eVFhQi9SUEtuU2xHSzFPQ0wyS3FBdHdjeU1URTR6amFTMjJQclZod29obmhB?=
 =?utf-8?B?TXBQR21PcE0zMUZIK0J3SlVQSXJCQWVpRzIwYUp2eDF5UVBXU0lrUTdmRkVi?=
 =?utf-8?B?ZkhZMFpuYTRPWk8vbGF4Y0VGME9WRWZBVTlQajVzWHdnQkpwRnJXandNb3lC?=
 =?utf-8?B?MUdBYUd3OW1sOGV5RlZnRVVwMVhVMVIyKzZpUEZWUEhxTnVEN1RNak9OaFVs?=
 =?utf-8?B?amdFbG1UeVFDUXlXVytLL1ErUnZIQ1hVM0RVc0FxYzd3cW56RVpBaWFvN0lM?=
 =?utf-8?B?aUpiaFhPeTczakJNbkFxVkxNMUJmRWtEUkw3bjQ5cUZQNUJtVUlYR1BHOEcw?=
 =?utf-8?B?UlY4ckNmQTZTYU13N1VDMWVWUW5lR3d3S2J3aGg2dU1UdEpqY3cxV2RRcEI2?=
 =?utf-8?B?SURoYzlaV3NDMnVpa21iNk1TbU5Ndi9qN29aZ0g3S1BrWUErQ3kxMllOaE5E?=
 =?utf-8?B?WFZOQjlRcCt5NVVoZ2hMM2Y1UndCenhTcDV0YnpQTUtwb0xaS0ppcUF1N2g0?=
 =?utf-8?B?VS9aM3dRMS9VbDl4UjVlT0d4VTR2L1A1TktjaFQxM1lqcnRjVXB4YlNWSWVo?=
 =?utf-8?B?U3ozK0lQNU91ZWpMUGwrUHR1aG5qNVdHMytsQzRIOGs2cGdSMHFMc1U3WVI2?=
 =?utf-8?B?SEVjaXp5Y3p1bU1pM1pzb3J3aWVFZDNBWHd4UzBtT2VvZDhiQXF2Q2UvNjl2?=
 =?utf-8?B?U2wrRW1XMGJrd1h2bWlqd0ZWWHZqUklCUzNHcjUwdFhVQVZhL3ZBWDBRSnYr?=
 =?utf-8?B?c2ZJL3duSEc2K096bzM0V2hERW5uUmRsY1pEWkY4Yzd2dTE5d0I0MXZ3SkpN?=
 =?utf-8?B?TXpDUUxUY3QxUkxINU90K2w0Q1U0eHFRQ1hFRFhJUzl5bmwxQlJ0a0VJQVIy?=
 =?utf-8?B?ampqOVpYNTRSUklBamx1ekdWNCt6alhUNGk5dHZZNCt5eWVjZVB3a2h5a3Mv?=
 =?utf-8?B?MzNVRGlReklzY1BsaGxwQUZSejMwZmxybnhqVDArTFdsaDJnT2NVYzRRUVBQ?=
 =?utf-8?B?eVNiYXI1ZnpvWStJK3l6U01NSVBGS0p5SjBQNmF6aXNBVlNHRzB5a1VuZUk0?=
 =?utf-8?B?VFFuUDUvMkJGWm1uRVdyamxaY0JUWEh6OEU0eld1S0dDWkpEeU8wL00yZ1Zo?=
 =?utf-8?B?QlB6VWg2WnpmeTgwWkRvenBSQm9CSHJtaVNEdFNUOWtHSDFrODhWOGtNYS8w?=
 =?utf-8?B?NVJTRlRuZnhqOWVNZnJxSFEweGJXRHdqQ3ZyT3pRWmFpNVk4V2ViN2x1QlBN?=
 =?utf-8?B?TmZndFdxb3lBeEVNTENRMzBxazFlMXBUcmlZZHlqZnFobVBDcXMrbExFQkl6?=
 =?utf-8?B?S3B4MUNiSmw5dmF5bWk4dklOc3A2bnNrR1BjUGZvYWhLUi9mTFpqM3NZejNT?=
 =?utf-8?B?Vk9UY2NFWjFvSU9rUThMWGRqeUNZdStVU2svbDNiUnVRV1FiUTY0RFBYVTl2?=
 =?utf-8?B?cWxmUEJJRWxlQTI4ZEsvNU9WbVl4aXo2UGRFT2Z4M0l1NnJGWGk2cUYyZkdP?=
 =?utf-8?B?L2U1cTYwVGpUQlBCTUJQM2syWFh5RnA1VzZhOWUyc2ViSHNLZ1BHc0tqcHpq?=
 =?utf-8?B?anJsRUc5MTM0cmliaGdCS2RhcW43VEdJTDZYRUpGLy9OZU4vdHc0RGpjN1cr?=
 =?utf-8?B?aUJCeno0UjlvbHM0eUxSbFpRL05mUmloOVpROTM0STFtWVJHUG5ON09jR1dI?=
 =?utf-8?B?OVNWT1ozR24xSStEL0JpZE9KVEU3T01mRStGc0JGdjZNVld5eElucWtNalpr?=
 =?utf-8?B?UXpGYlljcHFZS29KazVodDQvNnA0bXNIL2hxZHZpRXdaNk1wVlorM1RmY0Z5?=
 =?utf-8?B?aXdlakhDaEN2Zno3SUo3Q09iR1R2ckU4SHptVDdBYWlkUE1TVTBrYUpOWXFC?=
 =?utf-8?B?RWEwNUlUN05wNGhBUjIvMGFjWTJDV2FBMVdPbmhPYWF2Z2U4WHVsU0k1M09C?=
 =?utf-8?B?N3hiN3pMQ0pKc1ZpWVVpUjVISFBrTUhMMVppbU1mcGliVG5WVzZiK3p0V29G?=
 =?utf-8?Q?5c6c=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6734.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48d70093-f0ec-4525-2b12-08dc1353fdda
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2024 09:51:04.1571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RlNIm0DavC3Rk/DBt3s0g3tjHfJYHrYHfqscdQ8K8LPHppRAOiQV3AIMV+rT1zRAQmPwtx9m1q+sbYQotbxoQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5710
X-OriginatorOrg: intel.com

PiA+PiBAQCAtNjk2NCw3ICs2OTc1LDcgQEAgc3RhdGljIHZvaWQgbmVzdGVkX3ZteF9zZXR1cF9i
YXNpYyhzdHJ1Y3QNCj4gbmVzdGVkX3ZteF9tc3JzICptc3JzKQ0KPiA+PiAgIAkJVk1DUzEyX1JF
VklTSU9OIHwNCj4gPj4gICAJCVZNWF9CQVNJQ19UUlVFX0NUTFMgfA0KPiA+PiAgIAkJKCh1NjQp
Vk1DUzEyX1NJWkUgPDwgVk1YX0JBU0lDX1ZNQ1NfU0laRV9TSElGVCkgfA0KPiA+PiAtCQkoVk1Y
X0JBU0lDX01FTV9UWVBFX1dCIDw8DQo+IFZNWF9CQVNJQ19NRU1fVFlQRV9TSElGVCk7DQo+ID4+
ICsJCShNRU1fVFlQRV9XQiA8PCBWTVhfQkFTSUNfTUVNX1RZUEVfU0hJRlQpOw0KPiA+Pg0KPiA+
DQo+ID4gLi4uIGhlcmUsIHdlIGNhbiByZW1vdmUgdGhlIHR3byBfU0hJRlQgYnV0IGRlZmluZSBi
ZWxvdyBpbnN0ZWFkOg0KPiA+DQo+ID4gICAgI2RlZmluZSBWTVhfQkFTSUNfVk1DUzEyX1NJWkUJ
KCh1NjQpVk1DUzEyX1NJWkUgPDwgMzIpDQo+ID4gICAgI2RlZmluZSBWTVhfQkFTSUNfTUVNX1RZ
UEVfV0IJKE1FTV9UWVBFX1dCIDw8IDUwKQ0KPiANCj4gSSBwZXJzb25hbGx5IGRvbid0IGxpa2Ug
c3VjaCBuYW1lcywgdW5sZXNzIHdlIGNhbiBuYW1lIHRoZW0gaW4gYSBiZXR0ZXIgd2F5Lg0KPiAN
Cj4gPg0KPiA+IEFuZCB1c2UgYWJvdmUgdHdvIG1hY3JvcyBpbiBuZXN0ZWRfdm14X3NldHVwX2Jh
c2ljKCk/DQoNCkEgc2Vjb25kIHRob3VnaHQgb24gdGhpcywgSSBhZ3JlZSB0aGlzIGlzIGJldHRl
ci4gIEFuZCBJIHdpbGwgcG9zdCB2NC4NCg0KVGhhbmtzIQ0KICAgIFhpbg0K

