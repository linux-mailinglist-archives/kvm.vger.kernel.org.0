Return-Path: <kvm+bounces-16839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55ABF8BE656
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:46:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788B81C22A81
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28A7160785;
	Tue,  7 May 2024 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8rvuiro"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0DD64A;
	Tue,  7 May 2024 14:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715093157; cv=fail; b=dqarjsaCQXA/ymDJ2FWwBBy/ti5+bruW8Am/mSx69uLOABsIwEyB9Q9XLYEQ9Mq2Ulu/Q7dOYtsfoJdo2fcB1bm/GSOgmLeN5YyOCiFV0rQ5O1GNEDIpDxgBqGAMbzMSdiTbosiee4jYtsSmfp0RU9EfQOdhLaCccXdi7f+npDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715093157; c=relaxed/simple;
	bh=Q8Pre6IIYC6+HlgkVjgbQGiU1MSCCJBj18/8MnY4VJU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XbvHc2La+f/xJY7CH3onb1z19h09BOSvle+H0DTi9Qlrgy87S0zeEhSPHLrIogSRqaKin/e7LOsxLe3B7RbxE/TY1MKFqHzA8AzmC/rB/xxhkEcuxiNyc4tvGZsUea7Y3RPN1qNU/cOTjy3g3MjdUFWrpqPVvVR84eEXGuPoTHg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8rvuiro; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715093156; x=1746629156;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q8Pre6IIYC6+HlgkVjgbQGiU1MSCCJBj18/8MnY4VJU=;
  b=W8rvuiroij6PYKk6rfFobvaZvnRKIsXnzZwZQF2Up/TCIz1kM5CD7cIM
   OT+AI0ahozq0ukUXS7K8auMdYAWH5IlM4C0rrzAlUU7ay0ih6EHpYAxgt
   2Dw8atwaQR9VCU5ka1Or87iePg2aJ7rAnFP+a3z7j1iOp9f/pCcMOd6KM
   ezTZQlcfoA8gsr+iDY1iFQPoSnjLRWjiwUW3B6k7k3QQtwckruU0KMRaq
   o19p+F3HRj4u2Nv/UvagjgATngtrKQl0UVIyhTwVeJSvvQkc5tHW89OBB
   2Lq1TiUQGA6P/c8wfLBMm4+mhllKRy2z5ALKdiJ/9XY/9iP8IW7LNXTYw
   g==;
X-CSE-ConnectionGUID: O63JMxHQRRqUlrNv12wPMQ==
X-CSE-MsgGUID: x7QxwZ/fRbCeV2JvdMzqTQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="14681255"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="14681255"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 07:45:55 -0700
X-CSE-ConnectionGUID: ukJ957PEQkWWcYJw6cPPnQ==
X-CSE-MsgGUID: Ex2LlAD1TFeMuraLdKiYQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="33228835"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 07:45:54 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 07:45:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 07:45:53 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 07:45:53 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 07:45:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LG7VKHsCMJVTsKCR1B91y45RG5yCyeAPDvdZxPdkrmjSvwV1njaDyal7MmJi6MBq0fEEp5QVVwPSK50B1r0PWCTYWGtuxrJuWxQxKdjV8URSfBh8XhLTDm7OxIVYxYj69t9/ysCwDuNSYSQ+dB3+XkPzesvjJbRbJT6nM9x0l91tHjXY8y58ZNrdMmQNa/kt4RzlTJwJNDNqK15EMZMRMZtiUNTwlRzpGFxiI2iDSbEbkwJhI9Al+zLZEoFD3y7xPtsKycB9htGbmFc7NDH+Amfe18If60bjOivuLgtpq/YQ3unlTQkTh1pXjqansbW/JbZY/hTH6mjKB8JX0fmd0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8Pre6IIYC6+HlgkVjgbQGiU1MSCCJBj18/8MnY4VJU=;
 b=JEMARL7pEU8f32O2GZfzVzmrJrsAVPTpDW+QJ7JF3B+9LsTXzwLHzj/4BVJwiOeJSI7tyTRsQ9Qp+odPBh9ZDskOgU4iBNpeviQfqvFfnw7StXMffaDC/XsFZCqE/tuxPza2fVU3RQeyA3lZ4i3ImsAg3w2e0LrGccwRtzcyhL1C+Ejr9or0GqO7qyRAzbCJqBwXJs5QVZcz5Ske7/Boo/+hFa1HtXv4X02oDLt4uoiS8NVbepEKvxi6nMdikxVd6t9XzwgbQpfYC4PaYkCAgwvIx0d8CxVrzmCMcyemicDOFJaKgcdU8N8LrUvNRECPtsNc7YRwQUC5FT5R2rWm8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.43; Tue, 7 May
 2024 14:45:52 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 14:45:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yang,
 Weijiang" <weijiang.yang@intel.com>
Subject: Re: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX and
 advertise to userspace
Thread-Topic: [PATCH v10 24/27] KVM: x86: Enable CET virtualization for VMX
 and advertise to userspace
Thread-Index: AQHaYwfynhk8CrwGC0ayixDi2U+bW7GDdNgAgAbyCQCAAIJfgIAAbDuAgAAFmYCAAPKPAIAABtCA
Date: Tue, 7 May 2024 14:45:52 +0000
Message-ID: <994d42e4c4fb74899474a87766d7583507f13a73.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <20240219074733.122080-25-weijiang.yang@intel.com>
	 <ZjLNEPwXwPFJ5HJ3@google.com>
	 <e39f609f-314b-43c7-b297-5c01e90c023a@intel.com>
	 <038379acaf26dd942a744290bde0fc772084dbe9.camel@intel.com>
	 <ZjlovaBlLicFb6Z_@google.com>
	 <8a6c88c7457f9677449b0be3835c7844b34b4e8a.camel@intel.com>
	 <Zjo46HkBg2eKYMc7@google.com>
In-Reply-To: <Zjo46HkBg2eKYMc7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|CH0PR11MB5217:EE_
x-ms-office365-filtering-correlation-id: e4ed4d8a-c8b3-416b-29cc-08dc6ea46493
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?cnljZFRWbE93OU1VWlQwbW9OSzNKV05SeDFaYzIrUVlUY3g4ZnV2Q2thMXhz?=
 =?utf-8?B?b2htRjFQQURIcldNRUlkZ2RUNjF6bm4vUXlXNVVxL2tWYnRpTzc3K3YyRHJI?=
 =?utf-8?B?bkROU0JYMkxZL2dlMXBBYjI0SWdWY3NJSnhYTGFkZDQxR2N2S3pHUzNPM3gz?=
 =?utf-8?B?em8xa0x3QTJPY0UyQ296NDYwNTg0UUExNXhOVXVDMmJtWFFHZjl1L0NGeW5T?=
 =?utf-8?B?Z0RHcHBQNDZYcGVvbUN6V2tUcnQwczVjUGt1UUI2N2hSMFAvOVNkd1R0OUdX?=
 =?utf-8?B?eEZ6TWhCeXloaUxzWFBmbnJnY0Y1aHcybERlcXFacmVuYlhOTkFIa1A3YVY2?=
 =?utf-8?B?dnZDUWZZc2hyU3RQVU55ZUNVdFN5MXF2bTdhbzV1ZnZEdzd5VzNla2hLYllT?=
 =?utf-8?B?OWo1ZXRVb1NNMXdTS1B0Z2RhSVBsWjE3Y1Z0SHMwQTZRZjZkUTU5QlVtMXIz?=
 =?utf-8?B?MERSeWY3RUhIb0dya1RoUTdQSlVUVTdlcVVrMGxRbEVhRGdXSXdiaXpRQlBY?=
 =?utf-8?B?MVl6aExnUEpDU2JGRnBkQytxdFFSWEpGYUI4ZFBzRUVqMXRhL3FsTVluZm42?=
 =?utf-8?B?VXh6RUtXZkF0eWsxSml6bVoxeEx6a3hYNEFvY0JobWp5U2RTV1RrZUxkNlVj?=
 =?utf-8?B?MkpWU0lJV3lBMzhPemJHSEh1UnRpUjZ3V0cvcjFMTjc5K3A1NWFFeVZiNyt1?=
 =?utf-8?B?cTVNVEFMaTY0a2dUdEZqdXlVZTVoMVBxc2dXdUw1ZzFoZzlCUXBDVjhyRFVQ?=
 =?utf-8?B?QTRIOTBiMWRYT2ozb2xQTDFZNnd6TkprZTk1VVNxeFZpbHRYdDkxTzlvNU5Q?=
 =?utf-8?B?UlZWL2JPdi96S2psOVk3dFVjT1plNHZXY2xYd1FBWWNxV0syRmVwakJ2VjJ1?=
 =?utf-8?B?MGVlR2ZYVDdpL2ZKMWZ1YTJlcElXODZkRXorK3h5U1JyL2hRQmIvN1J2MW91?=
 =?utf-8?B?ZFF2WlQ3NkZmdk04VW9LaWJ2cmE0SjdaYmF1QUFiM01GOTdOQXN0dS9ncmN5?=
 =?utf-8?B?Wlg2MFVVSE92ejdPZVdoczdPRTludTMvbm5ab1pNZmkwU1VDdzV6NVM0bGRD?=
 =?utf-8?B?ZFhsQ0xnY2F4RWlzUDlXeWtxUkJkUHI0R3lVR0VnUlJrbUZWVmdZakhDUk5O?=
 =?utf-8?B?UFZsVWtia3JkaG1WMzYwN0JaYXc1SzJ6WnhtUXhaNzV0V25DQ0Y4VlU0Q3cv?=
 =?utf-8?B?a0RYUDh6T0VHaDI2aGgxWWR0WGh5MlQwRXZ0U2xWdmlUYUFwMFhMTGRjaXlh?=
 =?utf-8?B?VnV4MFNpMVV6bE9sUlBGK21IY0p1RzlZUkdCbk44NE9wZDdFcUpBNFM3Mm1o?=
 =?utf-8?B?TWUyMHBhdkFCYlVYTUt5Zm0yajlvdlhuNGRvNTlteGFEalJYS24vKzE1VXRh?=
 =?utf-8?B?eWhYWHBvMkV4OGgxWWtVVXh4UU1LZFFHSDlrY1RSVkR5TENyVnlzSGo5Rm5P?=
 =?utf-8?B?VWt4QWVyZHY1TnZQQkZVaGYzOHVNRFlVcXdzbUhzc2tmTUllcG9lL09hTXdM?=
 =?utf-8?B?VWJGSU5VNW9pbStVaGlaTWZMNm9UR0JCZmdwdVdHdDVjTDAwcTdyR2JNZTlX?=
 =?utf-8?B?d1ZKVVErN0J3dHRqVU9LdDZablVHTjNaOVpGZzVrd0tpcGkyeUNpTWMzSWMr?=
 =?utf-8?B?dzRlMnFLRlRNME5kd29zdFg5WXlpaXorczFCdVdQbXZzdmlXazBnSFArRlNG?=
 =?utf-8?B?L0o1TlV5b3pvWGRxajFsTm4rK090TDFFUHljeHN6NGhlc1lrcUU2S0R0eFlh?=
 =?utf-8?B?SE11YS8xaTJDQXlyTldIWkJkUmhYQ3RkUVlSS3RmUUd0NjRmaXRSd1BGZDJE?=
 =?utf-8?B?aElnUG1OcG5aejJZVGR4QT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXlGRUxYZS9XcG5BcEtCWjVWS200OWgvWHZrdzJ0Y1hWOUYya2hiRVdLZDFH?=
 =?utf-8?B?VWp5cVlkWTVlRnpLdEZnUjI5aTg3ZEhhVlRrSUFVZ09taXIwRGhhb2NHbDZH?=
 =?utf-8?B?YXBud1QxdFRoWjV0WUpqNERvNWt6WGllNlFVVkd4SnBlL0RYRzlQOFp5bkcw?=
 =?utf-8?B?Q0RvczJ1WHh1ZnNGNnhWQ3hhUnM0T1RhN3ZuUktiQjZ6ZXZ6eGkvdS9YdCtw?=
 =?utf-8?B?TlFpblVXSDQzbEpJNlQ0bUIxb2l0dWgvM3VvQTNUendLcy92NGNOWkNsdHhU?=
 =?utf-8?B?YmhTZGtTOWlqWEVVNkNIWitFZElJSVI4cG9SOHA2NTVGNmQxaVN0UzQwOVRW?=
 =?utf-8?B?WGJOY0RoTDhESWc5QVJZUjRNRHh0V2N1QUlTSWszdkZHQ1JXOHhuMkpUSHdC?=
 =?utf-8?B?NlQ0TEhTTC9ZSCtRS3VTMUJicGhIMzNQU2VkbmE3RDkxc0w2SlNHZkVkNGVu?=
 =?utf-8?B?SFgvaE1ndy9oWmNSTzhFYldXODl1UFY4WEczTzZ1OEpmWHNUbVRIYk5rY3BP?=
 =?utf-8?B?SEJqSXhUS0VYUDBVYnNHTUlPRlJvbXZMT0x2ZkhIcGNFWU1UaWtveUNpaWJE?=
 =?utf-8?B?OTVpay80eklzZUJNMGRuemhDc0tjWEtKRldmL3djcWlUUGlqa2NtdmdBWU1W?=
 =?utf-8?B?OWp2UVRlVXQrZlRKS1M2bWc2dWEwSElra1RtdXFuenl4QWZCREd2RjdVNHNX?=
 =?utf-8?B?RmN5MEM0TjU3ak1taWxGUlNZYWdwbWZ1QVl6YzFidUhGdmh2U1IrNVZKT2R1?=
 =?utf-8?B?VSsvM281ZUR5bjJEaWZUK1k1NjVJVkZRRkdwY2twK3Z6SjcwSzlQSWxWNmFY?=
 =?utf-8?B?SUlvR3l0QTYvTndZN2h3UFdlaVRZN1ZvcFBmNWtINnRvRFZ2YmNzRUIwSllM?=
 =?utf-8?B?cllvMjNMVDgxa0ZHQ242b3F3UVpGVzM4RWcyR2Z6NWlhZ1crbFVZdTVjdllp?=
 =?utf-8?B?Z09sa09iWGhabUdyYXN0cm4wSDNRZ0dteVpvYzZhTmhCbm9zdEsyVHhkUXFU?=
 =?utf-8?B?aHhTRGNTNmdUeGhyQXp4YmJJa1h1Q2FlVnloSWlVbGFqRCtkM0IxMm5LREZ5?=
 =?utf-8?B?TENWWkdTSEh1RzN6OHRqTFlraGxKekc1Wm8yekdsNEw5RjArYSs5Y0M4R2dE?=
 =?utf-8?B?UURiRXdvMFVFaHBJL25wbmRzZndJQWdmZExvNitBUjc4U0R6S2pXblBkNHRi?=
 =?utf-8?B?YkFIL0huWkNMbjlzRkFrdExoWmlLR0JjdVUwbG9TZmJsZkxFcGExcThBdXpV?=
 =?utf-8?B?Q0tSeG10UUhsWXVveHkrTWhNVDMzeFBDT1lzdHgyMVRXSmhmYUd4dzlXM1BC?=
 =?utf-8?B?c3NZZUxNZmJLL2ZKY3ZmelJmY1RxU1NMQlpBSllKSGhQZklZM29BVWdxVHZy?=
 =?utf-8?B?V0twMnBZWGZxNzl4TlkrbFhoK2o0Y2F4anBtYWR2N0F3T0JveUwwcGQxc2FY?=
 =?utf-8?B?elZnUGFNc1N1RkZ4S0NJNVV5aUxtRzltcGlzOTZjM2loOVZOZ25FL2h0RW9p?=
 =?utf-8?B?VXhjSVRaQmdMVmdib2ZCN3dON1RkUk05MFhLRjhIYTlTUkxMOEU5alhUMXlG?=
 =?utf-8?B?cE50Z0phUlZvZEZRYVYxM2VIRG9LUkgwUlBhNzJ0dDJ0ajNheUhhQmJ4bkli?=
 =?utf-8?B?RjIzWVdCSkpYOVlZU3lRQy8xZ09ja25oaEhoMlRQbFFxS2JJNDFlVE9iT2dr?=
 =?utf-8?B?MmloaFlBOGloZWd6dkF1NG4wNGE2MmVwaTdFczB3UHlwd2JQd1lBNFNjejlM?=
 =?utf-8?B?dStNd0R5TFJLMkVudUpYLytBdGxCNVFGcDhDU3ZrbUhDZnNZNkN1TzNrU21h?=
 =?utf-8?B?aVQzTStjWVhIQStmYm5PK0ExOXlsYndoaEc5REkxNUFLVjlaNzZudk43NmZa?=
 =?utf-8?B?WGdQaitEN1VDanhLeEdmUkRXNktFdkkvMnlaM0dQU2t4T0JZZWN0akxMTkJT?=
 =?utf-8?B?aDBIcVY3clZvNkN2aE02dWNKV0pibHl4dkhydVNqRzcvZ3h4QTJxMEZNTGty?=
 =?utf-8?B?N1BDUmtFTnArY2hYaFVVWTZJZWJWbHlFNnNOL0Zka1QxeXpkUjBrb0svSmVC?=
 =?utf-8?B?Z2tUbXpiNVRmTUxBK3FBanIvdEN1dVVVNTcvZnRTY05PY1lGNXl2bUNoaSta?=
 =?utf-8?B?Z0MzOE5kTlNiZFJVdjFtVTZkZ01yZXowc0xnMHQ2TzZON25JMDZPcWFPQXE1?=
 =?utf-8?Q?p+vvfwCJG5LLrXF8hHVUCgc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C8D773D4572EE4386F9A0790979B8F0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ed4d8a-c8b3-416b-29cc-08dc6ea46493
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2024 14:45:52.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+5Cv9gmEq/e92vSdpfr8AgJYatJ7vO29hj9w8HNdP/uh4/MfDxVLWHwMk50jOwr46evr1ap92No1NmR0LRYwD+ONX7wZasOPjUabS+JiWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTA3IGF0IDA3OjIxIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiANCj4gS2VlcGluZyBYODZfRkVBVFVSRV9JQlQgc2V0IHdpbGwgcmVzdWx0IGluICJp
YnQiIGJlaW5nIHJlcG9ydGVkIGluDQo+IC9wcm9jL2NwdWluZm8sDQo+IGkuZS4gd2lsbCBtaXNs
ZWFkIHVzZXJzcGFjZSBpbnRvIHRoaW5raW5nIElCVCBpcyBzdXBwb3J0ZWQgYW5kIGZ1bGx5IGVu
YWJsZWQNCj4gYnkNCj4gdGhlIGtlcm5lbC7CoCBGb3IgYSBzZWN1cml0eSBmZWF0dXJlLCB0aGF0
J3MgYSBwcmV0dHkgYmlnIGlzc3VlLg0KDQpTaW5jZSB0aGUgYmVnaW5uaW5nLCBpZiB5b3UgZG9u
J3QgY29uZmlndXJlIGtlcm5lbCBJQlQgaW4gS2NvbmZpZyBidXQgdGhlIEhXDQpzdXBwb3J0cyBp
dCwgImlidCIgd2lsbCBhcHBlYXIgaW4gL3Byb2MvY3B1aW5mby4gSXQgbmV2ZXIgd2FzIGEgcmVs
aWFibGUNCmluZGljYXRvciBvZiBrZXJuZWwgSUJUIGVuZm9yY2VtZW50LiBJdCBpcyBqdXN0IGFu
IGluZGljYXRvciBvZiBpZiB0aGUgSUJUDQpmZWF0dXJlIGlzIHVzYWJsZS4gSSB0aGluayB0eWlu
ZyBrZXJuZWwgSUJUIGVuZm9yY2VtZW50IHRvIHRoZSBDUFUgZmVhdHVyZSBpcw0Kd3JvbmcuIEJ1
dCBpZiB5b3UgZGlzYWJsZSB0aGUgSFcgZmVhdHVyZSwgaXQgbWFrZXMgc2Vuc2UgdGhhdCB0aGUg
ZW5mb3JjZW1lbnQNCndvdWxkIGJlIGRpc2FibGVkLg0KDQpDRVQgaXMgc29tZXRoaW5nIHRoYXQg
cmVxdWlyZXMgYSBmYWlyIGFtb3VudCBvZiBTVyBlbmFibGVtZW50LiBTVyBuZWVkcyB0byBkbw0K
dGhpbmdzIGluIHNwZWNpYWwgd2F5cyBvciB0aGluZ3Mgd2lsbCBnbyB3cm9uZy4gU28gd2hldGhl
ciBJQlQgaXMgaW4gdXNlIGFuZA0Kd2hldGhlciBpdCBpcyBzdXBwb3J0ZWQgYnkgdGhlIEhXIGFy
ZSB1c2VmdWwgdG8gbWFpbnRhaW4gYXMgc2VwYXJhdGUgY29uY2VwdHMuDQoNCj4gDQo+IFRvIGZ1
ZGdlIGFyb3VuZCB0aGF0LCB3ZSBjb3VsZCBhZGQgYSBzeW50aGV0aWMgZmVhdHVyZSBmbGFnIHRv
IGxldCB0aGUga2VybmVsDQo+IHRlbGwgS1ZNIHdoZXRoZXIgb3Igbm90IGl0J3Mgc2FmZSB0byB2
aXJ0dWFsaXplIElCVCwgYnV0IEkgZG9uJ3Qgc2VlIHdoYXQNCj4gdmFsdWUNCj4gdGhhdCBhZGRz
IG92ZXIgS1ZNIGNoZWNraW5nIHJhdyBob3N0IENQVUlELg0KDQpBIHN5bnRoZXRpYyBmZWF0dXJl
IGZsYWcgZm9yIGtlcm5lbCBJQlQgc2VlbXMgcmVhc29uYWJsZSB0byBtZS4gSXQncyB3aGF0IEkN
CnN1Z2dlc3RlZCBvbiB0aGF0IHRocmVhZCBJIGxpbmtlZCBlYXJsaWVyLiBCdXQgUGV0ZXJ6IHdh
cyBhZHZvY2F0aW5nIGZvciBhIGJvb2wuDQpIb3cgZW5mb3JjZW1lbnQgd291bGQgYmUgZXhwb3Nl
ZCwgd291bGQganVzdCBiZSBkbWVzZyBJIGd1ZXNzLiBIYXZpbmcgYSBuZXcNCmZlYXR1cmUgZmxh
ZyBzdGlsbCBtYWtlcyBzZW5zZSB0byBtZS4gTWF5YmUgaGUgY291bGQgYmUgY29udmluY2VkLg0K

