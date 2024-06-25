Return-Path: <kvm+bounces-20501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 829B79172F3
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 23:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 029CC1F22E98
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 21:09:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4180217DE2A;
	Tue, 25 Jun 2024 21:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iQfJUTzx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD0816B39A;
	Tue, 25 Jun 2024 21:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719349771; cv=fail; b=XxCWsEk1b0t03449srZG5+IyAXglWKDkYMnDe9CxAYDjix/umcFndwiMB0m2AvlWBeEl+7AUeijEHNqw7gfyBFGNR9k8k8T3SNr4s+YDaQuqcAPkDXsjSmu61/OwNcXMMMg2kTaBXFcVDcEfpXGvdNo8Flx3OYXDj41pmgUouPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719349771; c=relaxed/simple;
	bh=HiPPIamz4BSBSCcT2K2OmnaN/UqmeqkCVW7M2CEkS2U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=As0H4j0B6Iy3lWJmJbq35bM29q6djQfl2jmiRb0ZcoN28x/Bf96PCkVKD8Hlhqj+Y93gbDQ74BcdPV5DBrNRI0MXS9x6OaHCVlCECgrLRMa77mM6MqZvh3TKjhCLtEy5HhIKkjXFILyfB7o+CgMJIGuURAftd2y3Rpkt4+KLQPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iQfJUTzx; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719349770; x=1750885770;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=HiPPIamz4BSBSCcT2K2OmnaN/UqmeqkCVW7M2CEkS2U=;
  b=iQfJUTzx9KHjjHM5AgnNbEm0yc5jcZRH7yp+63YCr1Y26gaZVAs6flKd
   FA5ijoAd0j5GuHObNa+to50KqBeXGUDZkg7lXF6V2BMEB5L/RVt629N0Q
   kcRow9HaPv/nJyiqp0mLDAgZd/LSDMog2grUwWgYvGsz4Cd7t4tjO0ozo
   VB9bM0hYeERzNicH39vhDNgN0Ml2C/XwwWPzKMHPUU9yQb9F/b7vtnQci
   IjtcazCBQ/VsA/Pd7y9x026ookigubDzS3NjnoQze+F36rwc3IyxoV9CT
   cXLM/jjfSyDmz/lb8v3VjQ5B4znHju1oyqb++b+spxf9S4dyJdnkcvQWe
   g==;
X-CSE-ConnectionGUID: Fsv5uxV6R8WrwyzM++4vJA==
X-CSE-MsgGUID: euQPk7N5T92cHbXnyaRUxw==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="19287038"
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="19287038"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 14:09:29 -0700
X-CSE-ConnectionGUID: Ov/YybGsTQ+dFbpcQyYPsQ==
X-CSE-MsgGUID: rL09i+B6SNyfPgKHQSSNjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,264,1712646000"; 
   d="scan'208";a="43844305"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 14:09:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 14:09:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 14:09:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 14:09:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 14:09:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/6VPyQYZwldfkMFaZ+Mg6j55LxO2SdO1nGXj1ccsaxrJfErQ8qVh7SYhcnr+/bUcQDik3cXHUjCq1r9F9sC3FPT6447+pgle1SslFfj1MpoKxuCZLU3fdJ342yW7kvjyVAm0QwnK3z3KSYHdbQE1X9O8acYdRxlWgml72yNu6W8rCOME+6WPf+sfMEb2ibODRmhvfNX2cLqjmaZqJtqAohXbtZOrA7mnt7AyGHCvGowTmSREoT3i0vlG4pjRecy8HgDoWSKEOTUi71FFWkx4okqOQUXr1wCKivfWTHrQitUGH72UMAb66zDgbB+WQfVeV8uZA9OKNj5HIzSl3XpNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiPPIamz4BSBSCcT2K2OmnaN/UqmeqkCVW7M2CEkS2U=;
 b=D0e2cCI5wpjYOpSx2T/iF8+S2FMRFb9sSBMI6fGbdbCyEg6dQH0d+yjnm21/9nWAeVQI/3NBfYgiq7ge75dxfbReTGi8P/rLPSk0eXoHOc4ENYQpXWwwtf+3RJ7TMxJk4tOedn6c6t7qQuPD4aAXTHL9CHuHs2Arm1Sf1BY+hqWeah+MHls0jTm0/bAcvfI+KD+CxghkxsyH2+ajFYjXo+1BDjXTvzpM013iZbvB4PEhyQeGNOjEzDXXdgt5cPlc/Gi4ad5IgTa2S337H1bNsHKfBA2oGmdTzTXtPQ0l3Kp10X8jCX+Hl6rYBHfUUZ2FaO8IUpXYrZyKWLaAcizmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8394.namprd11.prod.outlook.com (2603:10b6:806:37c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Tue, 25 Jun
 2024 21:09:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 21:09:25 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Topic: [PATCH v19 110/130] KVM: TDX: Handle TDX PV MMIO hypercall
Thread-Index: AQHadnrQBvAJmB6j80e0mbgOJfCyfbHYq/+AgADu9YA=
Date: Tue, 25 Jun 2024 21:09:25 +0000
Message-ID: <07e410205a9eb87ab7f364b7b3e808e4f7d15b7f.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <a4421e0f2eafc17b4703c920936e32489d2382a3.1708933498.git.isaku.yamahata@intel.com>
	 <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
In-Reply-To: <560f3796-5a41-49fb-be6e-558bbe582996@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8394:EE_
x-ms-office365-filtering-correlation-id: d4bb651e-45af-4b45-b1a9-08dc955b181e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230038|1800799022|366014|376012|38070700016;
x-microsoft-antispam-message-info: =?utf-8?B?UkVYZXcvMklNOWxrZFhEcUdhNlBNdHJ2aU1pd0ozU3pXeWRXeDNyZGpQTmZ1?=
 =?utf-8?B?elVCN0pIdEs4d09Lak9zWEJyUzRCS1M1M2V1TjViMkpoNTUrMFBGbmdFU0V0?=
 =?utf-8?B?Y0w1SVhFY3g2Z2paays3cVdkN1V2emJpa2svQmhERWJCSHUxRnBJS1VhUG51?=
 =?utf-8?B?V3AyQkVqb25yWVpwWHVmcDlTZGZwa1BpUVQ2WkhwSXpQOGFXd3dXVkxMT1pj?=
 =?utf-8?B?VktZdGhuUEY3OUZaaFFHWnExTzY3c3FpdjhMcGsxUnhYdVJ5dE1xZlhFMmFK?=
 =?utf-8?B?T25EMUhycm5QMEE4WWNDY3U4Mno0bkpONUdQN1dINVR1UWFwam1lazZxQWxC?=
 =?utf-8?B?Nnc4OGQvMTJBV3RmcU5yLzRxQkZIWnhuU2RpeC9NV0dLbzhHMGNmS3JYNWZn?=
 =?utf-8?B?dzYvWm1ST2ZqV0t1Mjh2ZGpQYzd4UUpjc2QwWGd4QXBWZU9OdzJlUHAyWnA5?=
 =?utf-8?B?Q0pMQVg4K0ExUWtVTGxib2xtQUR6NmVpaHIyL2RyVjdSS20reVdtMERXZ0dR?=
 =?utf-8?B?anNiODJESjZpWjBRcHRuZHdiOWtzT0ZvTlB0Y2kwTVAzN0dpQjNnYkRFbDhB?=
 =?utf-8?B?bFFpSGFiSHdUVzdHcCtuRWZ1b2tWYzAwVjh1VTAyVDZQOE1FK29Da2JkWDJV?=
 =?utf-8?B?QUs2OTRVV2hHNnZoNUM5RHRFTUJHNlkwNmZTS3B3Wm82UUNUOUpRSmhWcElC?=
 =?utf-8?B?Tno2QklUMGxhOUxETDNQSWVld3RVekovR3k1MEYzMlo4LytjeWFlNXpUOGhs?=
 =?utf-8?B?WFJYRElZbGdHaGlEbGw4dHZZV1JsZUlnWHFLUUNPS0pwbExjN0JWYWNKd01L?=
 =?utf-8?B?V21EcEpMRTAzMHk2SFllQ0MrLy9tWWk0eDlwMk1ZT1ZybGJ2akFOM3E3Z3lQ?=
 =?utf-8?B?Zk1Tb0tmTzE2MHlBUHdNckNNLzRwZDBjUjU0c0g2eCtRWkh2K21MMGUzYk4w?=
 =?utf-8?B?S1BSRFdjOUNyR1dhVnJSMTZDV2hBb1JVNGROWXNxd1BTUVltNkw1elNOMGND?=
 =?utf-8?B?QnEvQXJOREovSTRuc2Y4UFB0b2JHYisvS3BUcmdieHh6ZUl6YnE0YnVlNWdU?=
 =?utf-8?B?eExtNjVCV2lIRktsRlpKTlVMOTg5SUpNWnQrSm05OXRleEt2dzFTcWNLcWZ1?=
 =?utf-8?B?eFV6R29LYS93K09GTnl6WmMzWDRJTnY1TGFkUm1vTCtJRE5zOFNmQ1BUQnhV?=
 =?utf-8?B?Y3I2em9ldHMvQ0tIWnRsNmlMeXZkMndKcVpuRmlFK29ZdDNRaGo5ZDMwZUNv?=
 =?utf-8?B?U3VYcDE4Y2dnVlRIVVpqd0IrbFExc01WV2oyeVprZUUyTlgzZWU5YlBDNVBo?=
 =?utf-8?B?NGNoZjZmbmJZS2I0VEtWWTBkMldKd0N5Qjg2OFU0MTdOM0c0bGRETnNIemx6?=
 =?utf-8?B?U0tZcDhhZVZ5NEtyV2pHekFza0pPQUxWcS9qSFUzNFBsaW1tOEJhY2F6NTEz?=
 =?utf-8?B?bVdLRzlrWGpEM1hnVzJJcWFBYmhnRTRYYWdjcWQ0MnFSNFlycFV5UW9SKzRq?=
 =?utf-8?B?QzV2RXhvenU3R1d4VUFibnViTFdyMmxZODBIT05jdmwvbitPaVJ6N2l5T08w?=
 =?utf-8?B?b0x1TVZ3T2M2VWVUMXhNL0lBWjk1KzVnQ1Q4R3ZIZzA0TUhvZFE1Ry9rNU9o?=
 =?utf-8?B?czdQSzBockVFckxyaVVuY2RvbGlmU25admFTZEkrOWFwUjVGa0lNRTk4ckw1?=
 =?utf-8?B?MWJNRlM1VHhoaTFlVVpkaXVhSjhuSkl6S0RrN2VFRGQrVnU1em5RMFYzZWgx?=
 =?utf-8?B?R0lBQkl2alJSYzBFaktJVHlpN3pzRGVIY1N3eng1TmpxampGYXFENitKaVZV?=
 =?utf-8?Q?r3yVv6Hf0wmQEsw0HP/NIMplYfDxgYRwNmGAQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(1800799022)(366014)(376012)(38070700016);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0h1bUM0M2tlUU1uS1BodXY2UDBPQkNHQ1BkZlV1Z1FOVDRwUnBDMnVWcjhn?=
 =?utf-8?B?eVlZSDBKdUFkWmdMVHErSHhXNHlNTkVFUTU2dmh2V2FRVGpDM2g3SEtpN0Qw?=
 =?utf-8?B?OWtpTS9kRjlnS3RZbTFTWG5KWTE0WitFVXN6eDBmbzhlK2hIc050WkpvbGxD?=
 =?utf-8?B?KzZUZ1dZTnd4cFN2MW1mU2M4dVNCS0hiZmgrY1B5MGdyTTh4dzM2NEUyZGxL?=
 =?utf-8?B?UkdGZ2cvN3hHS2pLTWx3aSt6bGpMMXBGeFREaWhNbWpKc3U4OVdTYWhiWFhy?=
 =?utf-8?B?QWc4bzFUSjR6VnNaNW1NNnNSMnNXRndJVDNKNGYvK1FjNGFPSWpVcWIxaDNE?=
 =?utf-8?B?eHJub29FeDlpM2VpUHIxeXdmbFhCdlRiZkFMZVl6Y2RlNUhKaHppWGJRN1FJ?=
 =?utf-8?B?am1SYzEzMWgraHdpNUdkTHpuMTkrYURnYVVXQW1kRDJMNnVpc3MyaWNrNDhF?=
 =?utf-8?B?OXRuMUgwTXQwWGZCT0Jzdk52TWdEcW9tY09xdUJ1bXl6UGxKc0FkenhKcVpC?=
 =?utf-8?B?Yk12OWQvdnhPUW1ieVdoWUw3RFptb29tYzVEOVdaMlhnakJONjVvNkgwanR1?=
 =?utf-8?B?K1ROTjVQS2xpSU5neWhXUTJ2L3QwdFNvYkpOT2ZRQ3grRVJWM1lEU0lwRHo0?=
 =?utf-8?B?bjJqK3JxVjFXMmxpaVNFbjRDTFh1VjVKVEtnczZMTjhJNTFoOStNRElMcmhZ?=
 =?utf-8?B?eE5VT2FoU3FFcXVKMFgyckl2RTFOamsrQ0gyOXgwVVVOR05vamN5WHBFZG1M?=
 =?utf-8?B?Z1ladWhUOXBRUitjSDFOcWRqWFRucmVLWElsRkJjN2hWTlAvY0kzYUwwVms0?=
 =?utf-8?B?ZTRJTFozMjJUajNhbGp2SWNid2lZOG4rRUNYd3phMVVzZUk0dmhnNjZpdXkw?=
 =?utf-8?B?YzZLQjhKWS9Mb3o1aGduZjV3YktWaEV2RldKUGlMbEJPUnNSb0tnMFdVK0x2?=
 =?utf-8?B?MHZ2S1poV2hDbGZJaHJRY3dEK28wQkRBUnc0NWc1MmdwU1IvUHZKcUM3SDc4?=
 =?utf-8?B?VU50YnF2dHhKVXZjRjJNOXlwR0FzRXRzSmNNcnBxRUtzZ1BYM3ZkWGJOOFhS?=
 =?utf-8?B?NDlXdUx0RGg1ZW9UZ0lDYnZQUmxpL3A3WEN3aUVTL29mcDFxNGtBTlJNQXEv?=
 =?utf-8?B?TWd2bnEvVmdFdVc1WlRXT0NySE1ONHFVTGdTODg0cTczeHhmL3ExV2lUbHpt?=
 =?utf-8?B?dFZva0xzSS95bE8wK1hyd1FuZmFocmJNOE9NTGJla24rNHQ1Slc4VzB1YjhD?=
 =?utf-8?B?Ym1hUVIrNThkSlgxd2tUV1ArSUZtdnZ3MCtnb0dZN2dwaitxZk96SkhVWWlB?=
 =?utf-8?B?c2tybFlnT0YwYjRVMzlSNVo0ank3bnp0cEppcFNETS9rRlFaQmx1em1KSEls?=
 =?utf-8?B?ajROSzB2aUtaMDEvMXdHRGVYMjRzOXFrZEg4RVpMYkdGVjlWVmt2ekdreSsz?=
 =?utf-8?B?RllZdEdnWE5URzcyY0ZRbjJweDZqci9CQkpmTWZWK3ZDYWM1cVBLbUM3VHRu?=
 =?utf-8?B?SXB1eko4NGJyM2ZyYkVURWxMVXlHV3U5V01QUkZqSHRMVXo3bmNVaGlIRy9k?=
 =?utf-8?B?ZXB3VVdvTnR5VnN1d0pzcWlzeGxjYkVYbGpUTTBpVUdhNENjaGFha01pOTJt?=
 =?utf-8?B?bDZhRXhEb05qN1Vhb0h0SmpNNjR3QUlmaDVqV2xkM1g3Q3RFNHlNSVFnZ3pT?=
 =?utf-8?B?Tnp4VExPVnYveEN3Wk15V2g1VTBvTUZhT3QyU003K3NZR0VPSzFxcVZ4dytj?=
 =?utf-8?B?WHVnVjVKNlkvWkVpZ1RuMENXdmpYRExFanZXTFlVSUVNdERhT2x6cTZHSFhv?=
 =?utf-8?B?SytySFdPMUtOOVZqcWkwb0ttMkkwTkFjQm8yWmxqOXI2U2RXN0tWZysvT0lO?=
 =?utf-8?B?bTNYZUZzWlpSTEVSdGF4ZnlGdGk5UElPeWo2UzkvVUhpWjRjckJOeWtSbkdo?=
 =?utf-8?B?N09XbXFUWVY3ellLSnNMMlp0ZXdETFJieUZMKytoR2tiamsxYXI4VWVSbk9X?=
 =?utf-8?B?ZERBTjRVRXE5cWNZS3ZHWEVmRy9ZRkZhTEhUYkVxMkVOWUQ5cXFMbDc5RHdo?=
 =?utf-8?B?QUd0THJ4RlBQUUpXbXErOG1mdHptWTUrUWFORWF5amM1QmhvK3o5YmhzS1Fi?=
 =?utf-8?B?UVZsaUk5NE5hQzNQcERKRkQrT0haY2d1L2JaZHA3RGFPNTVzKzB5eG5HM2pO?=
 =?utf-8?Q?0BvZmxytFJ7n933U0fFsnGw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FBB20551D1DC744DB440C358AC55E1D3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4bb651e-45af-4b45-b1a9-08dc955b181e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2024 21:09:25.8661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Y8CnHxQW8oLvCcvJpjXUNmPhhLesCTfqcNr3AYtF7iM1qBrRUJ01jGYChZfN8lJdzqg45PgLWJzZ0x4GR+Ll0UUQYAyogaOxpMGO9bY6KA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8394
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTI1IGF0IDE0OjU0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdwYSA9IHZjcHUtPm1taW9fZnJhZ21lbnRz
WzBdLmdwYTsNCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc2l6ZSA9IHZjcHUt
Pm1taW9fZnJhZ21lbnRzWzBdLmxlbjsNCj4gDQo+IFNpbmNlIE1NSU8gY3Jvc3MgcGFnZSBib3Vu
ZGFyeSBpcyBub3QgYWxsb3dlZCBhY2NvcmRpbmcgdG8gdGhlIGlucHV0IA0KPiBjaGVja3MgZnJv
bSBURFZNQ0FMTCwgdGhlc2UgbW1pb19mcmFnbWVudHNbXSBpcyBub3QgbmVlZGVkLg0KPiBKdXN0
IHVzZSB2Y3B1LT5ydW4tPm1taW8ucGh5c19hZGRyIGFuZCB2Y3B1LT5ydW4tPm1taW8ubGVuPw0K
DQpDYW4gd2UgYWRkIGEgY29tbWVudCBvciBzb21ldGhpbmcgdG8gdGhhdCBjaGVjaywgb24gd2h5
IEtWTSBkb2Vzbid0IGhhbmRsZSBpdD8NCklzIGl0IGRvY3VtZW50ZWQgc29tZXdoZXJlIGluIHRo
ZSBURFggQUJJIHRoYXQgaXQgaXMgbm90IGV4cGVjdGVkIHRvIGJlDQpzdXBwb3J0ZWQ/DQo=

