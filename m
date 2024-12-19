Return-Path: <kvm+bounces-34090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B29679F7267
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 13F6716FD83
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 01:59:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5E478F34;
	Thu, 19 Dec 2024 01:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WnjOxQfX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA34170809
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 01:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734573419; cv=fail; b=CxbDqirLAOg9O5kF9EWmvJ2Kb3ysRwlnLiaB1A1xdBN4laRWchKHhPCGHVEkaXm56wzU3Opx0mJhxgc7vp0e+lyvxzLvyuLM4CdfTk8+q58WuP0mcqYR9DRPMmJ2iFtfdjZa7vCXpLlW81YyHKf815CZNaWvWl/5GZ1tT9IhELE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734573419; c=relaxed/simple;
	bh=n7i95pYVXG6O3ditvaV9CESkKWEx8khHrQ5QOkMJdow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bwiG0ayp4Rx2opipe4UKMWlpebtsAxFFZHPhRw6PfUiqdYIwzLo//f168dmlUEC4uuygyb19W2A8fFDBGRRktr4M4xzrYzFY1iQ8POcR2p84l7Run2dqAIatfSpeWipvRU/RVtPgUENC4F5l5s4wVNTTFCa9QapylkCWE7O/K5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WnjOxQfX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734573417; x=1766109417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=n7i95pYVXG6O3ditvaV9CESkKWEx8khHrQ5QOkMJdow=;
  b=WnjOxQfX3iYqNa3DT6hjLuH3n3IvjJ9v6G9m+XeYK4ZYqYcTq+ADRPpo
   Lu158zZlEbC/Xr123L0fOq5umF02DgS+y9N7vz3kvlxJeGHldp+x+nnVH
   1igP7JdcJrVyza660IxCoWMIgm3OyYUvKEad8afa8AB+bz5DIClOvf5uQ
   tWdrRsq60/cDMlqC80zmTFfOkqnAPs+uxbgAflCVdCC2dsJ9xsZJrjG67
   qtRVQkrKr6f6EAbETYgSmndwYWiEA9dPOEaKx7oQoymWT4IDimkMxJXjw
   jPisNmYHClcyr4tsHsoPFCawLtufsVc3g/xIVT9gWX7HkIwQQHWzJzF8L
   g==;
X-CSE-ConnectionGUID: BO3lD3+TR36Hf9Iul6so4Q==
X-CSE-MsgGUID: CdAVZ3EdRC+6g9nY6xVdxg==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="37913788"
X-IronPort-AV: E=Sophos;i="6.12,246,1728975600"; 
   d="scan'208";a="37913788"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2024 17:56:56 -0800
X-CSE-ConnectionGUID: Jq09CoSDRN2wRBy0VtJLSw==
X-CSE-MsgGUID: 5X268O3OTAOuYOw2k8+VYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="135371560"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Dec 2024 17:56:54 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 18 Dec 2024 17:56:53 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 18 Dec 2024 17:56:53 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 18 Dec 2024 17:56:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JfujGG93oOQydKlCWfr/TEyHrDvxq0vdDYTgqoOmc8JfDYk7wKXT3cBw8O013Xl2zHmWsjC9RtXkjdZmgu39JSWC4rosH+E22vdoMh6sZf1BA7yIsl4x86SYxD3q0dWs96ODmy9d2p965O8AAXtotyPCA2v6JzWY5g43XHmbWTqDpRQ9W/dqbd7xjvh7T5Qc3yPDSyOIuAw9n6N1jsZpw3GYRpwfIx001VQk8x4KyUq5KHV7IBN0LISVprLZA7DYzu6gKiR5vrca/LwGbD++0+JxFDNe23nHYdb4+bqU+HZEW7bgcBzBU4pO3y7Xjd9/7/N7Fp2IFsbyK3z0SSYCvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7i95pYVXG6O3ditvaV9CESkKWEx8khHrQ5QOkMJdow=;
 b=Ctqv1Ib9gCJ/QJvGdTPLcp9MVVF571mzTWqlCg+zgr2MRpNCHub3YTyzwX4lr4if13wghtLQfkjUiWZLemGe2XF7R/8bes8T0r4HruHTSdxflD71xe8+vEuJ38xoBSnR0hNMWeEo3dKzX85QGDfaYhkfUgLuvQ8iyfBXOg+aoJgZoAE7Vv0mu99mkRB+yC9yGvnM6yCdU/FbwKrE0vN7mQjVcfpDw1HSvgQJcl/9widyrZQO0jdbVrFqkI0mbaJ97c+ZzmmWJfl5E1EBywvXcKvf21ofqXKF0HEL/FekvUjUie3ANPSZY1g4zrpa8mz7jbI5nI1SSHPa0hJvxSVd6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN6PR11MB8145.namprd11.prod.outlook.com (2603:10b6:208:474::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.25; Thu, 19 Dec
 2024 01:56:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8272.005; Thu, 19 Dec 2024
 01:56:23 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Topic: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
Thread-Index: AQHbR4iHazsMJxPtGkeCIJI86qO187LZjbkAgAVIvYCAAPE0gIAJ9kIAgAFI/QCAACwNAIABsF4A
Date: Thu, 19 Dec 2024 01:56:23 +0000
Message-ID: <f58c24757f8fd810e5d167c8b6da41870dace6b1.camel@intel.com>
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
	 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
	 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com>
	 <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
	 <Z2DZpJz5K9W92NAE@google.com>
	 <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
	 <Z2INi480K96q2m5S@google.com>
In-Reply-To: <Z2INi480K96q2m5S@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN6PR11MB8145:EE_
x-ms-office365-filtering-correlation-id: 555df771-a142-4f32-595b-08dd1fd05734
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|3613699012|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K2tWa1lQUUF5UEdzMVUxNG9TK0ZobXlwODBxRStoQklRZ1k0Q0hVODN0UkJ1?=
 =?utf-8?B?Zm9ra0E1ZHp3YkM2STBCakpHSzg4TU1OTHZ3dlhLeFh6WXdZbEFxT0JZWFVQ?=
 =?utf-8?B?QVZjUTZLTStsRnNvQnAvVU9oM1VGOGRtY3M5MkR2UE9iUHRVS3VTNUVNbnVx?=
 =?utf-8?B?NDRGa0xnVndUZ2RDYnl4QVFTb3UreWk1aWJOUUpYQXZCM1dtOEp6VjZIZ3o2?=
 =?utf-8?B?UTBrY3lsbkd1dnAxeDQ0YzkzaitRRUdwRnJtYStJV3pwNkVoQVZpcmUrb2ZQ?=
 =?utf-8?B?TG9vczJXVWh4bm5McnlDU0M0Q2phZUdkK3NURnNQL2k1amFkeHhoVnFBZEgw?=
 =?utf-8?B?UmczQ3pxb05HaGVTMG5hRERCR2g4MFFnSGdUTVNTQmpYSUs1M2J2REdycDF3?=
 =?utf-8?B?TzN3cm9DWkFjakJPcEpvOWZMM1dONUNRZ1VKRWZFODMrWUFtL3Z4KzdFVlVx?=
 =?utf-8?B?TW5nazFPUDZNQUJtaDIveityL3ZPNFdsdWFqNm9RUHhSeklJSXNnWjlJSlJQ?=
 =?utf-8?B?emY4K0I1SlVNd2tWcWpyRDE5QTdrYXZaTXBWbVE4akxBRGliYlUxYS8xaGJn?=
 =?utf-8?B?N2NHNFA4b1dKWEtzOE9tZjczek1uN04zU01kNitQZC9WN0VGWG1waGNQNmFY?=
 =?utf-8?B?QWtYV2RQYmhyRWoxWkJUSjBvR3RTaU4zQzhadSs4V3pzakFQbGx4T2ZXZitt?=
 =?utf-8?B?dU5iTHJJZHFCKzUrckZ3UjRVL1I1VUk3enNaNHo2WVRFRWszdVIyQ0Qwc3JP?=
 =?utf-8?B?RFJ3enk3N2k4b09wS0FHWXU3VVJTSzNHb1FSUmM4OWpFYWZnalRGdWN4RDBk?=
 =?utf-8?B?UisrWDFiSC94NHVGaHdYbUdlRTAwMnRmTVJ6dEpSYjRqc2o5Sm9XR1BHR2c2?=
 =?utf-8?B?Y3VkbElDM2lhbjY4TVlJWGIwdXN4bzg5N1JBclVkS0cycE1qdHp3TmZrai9O?=
 =?utf-8?B?dnNZUDZOYTgvMTNoZEdsemhVdWQ5UWdUVWQwV1RnSkZ5TldtbWEyVi91MHNn?=
 =?utf-8?B?aHZWUXpLRHpCWWlRQXpZaGxzelZBQnU1RlVGVDd4KzRGWHpzTno1VktHc2Fk?=
 =?utf-8?B?dE1qWjZHR3BrdHNVK1pUVkZkcXM0NUpRWDVNbWxKYTgxS2tnY3d2UDZaVXV6?=
 =?utf-8?B?UnhISXhPd094SXBTc1FoOFdGZytTM1ZITkhvbFV2OFNMQldiMisveThRMEpR?=
 =?utf-8?B?RlVyVTc0TDFVNTJURjJzUDBuWUppMThheTBBc3hwd2w2YmI5T2FBdHY4Umww?=
 =?utf-8?B?L0JkRHd5Q3NFdFczUXNJWkw2V3MwVjZveDNaVnV0M1FjVnlqOEp1VjRJc3RR?=
 =?utf-8?B?Y09CMnBPK1hTdEFJRmYwcGNva3htOUxpNnRmendoZWpUNnFCZ24vOXd6M3gy?=
 =?utf-8?B?eWlaMVBmNDlWK2p0ci8xUENzSGJpZGFZdGR4T1lZNFg4S0l4VEhmb25qMFJF?=
 =?utf-8?B?QmZaUUdIaFA3MDBJY2dqaHZSWDVTdWlkTHcydktINlZ4Q1Vmc0RMYmhBck80?=
 =?utf-8?B?UjZnNEdvdFBRZEkrZElvS1RHUzdwZ0EwM2tKUGVIWGUwWDFvbmVrYkNxSS9S?=
 =?utf-8?B?a1RBNkU3YVRYaFFlTEZyaFpWdEdsOTBFZEZxcWlxcUhxQkFKaFFDYlZyYWtQ?=
 =?utf-8?B?U0pzR24va1F0SFdhNDIyclZwMWtQNFUxUStUZXVxNnVCOWRvc01ja1A1bTB4?=
 =?utf-8?B?ZU5ic2crbXRGMXlqSWFuaEh0OEpsWEhjZituaUN6b1p4NU03WU9VcEpwSFps?=
 =?utf-8?B?U0dUcDNNS1dtRWRZK3U3TTl0QWVuVUNMMWxjdDFwSkFqNHlGZ3E0QXpFTHYw?=
 =?utf-8?B?RWYzTmtIUzVRNkZOMFhVeDV4WWlkQTlGWklTQ0R4K1BLRHdoNWl0VjlhcHBt?=
 =?utf-8?B?MmlYQmRKc0s0QkpIOHp6Z1R5NU5GcEt3WVRKcEFjWGk3aUhOYnJ3eVREaVhM?=
 =?utf-8?Q?LrfxeWXVMFw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(3613699012)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RittRnVnRnFOK0RpYW5iMlFxZlkxM3VXQVpuSFhScmZwUEQ4QXFueGpVeEsz?=
 =?utf-8?B?K3BWU293RXVuZkR4QnpWM3A1ajNuK0Flc2MxZGM5enI1eVprUEhBbjJCb1lW?=
 =?utf-8?B?OTZIdFU4WkNZc2lnVzhjNEVWbDg0MXBBa3V0VXU2QmtLSGl5bElKYVUyYWxa?=
 =?utf-8?B?UlRNeVZweGh0R2R0Q3NWdlRrOEt0SU1mQXMxcmxWMFh3VzhHeXRod2pBZ3NM?=
 =?utf-8?B?emowL0t5ME9mM0Z0WVlZY2tRU1FDWERGZzFGYmpvazdkUkdQbGY4VEJjWkZY?=
 =?utf-8?B?OS9XREpnQzdYU1FSaXZaMzI1YU9rNFhOWEJmdyt0YUhjYWdTN0pCMGFYM1oy?=
 =?utf-8?B?V2tMeTFVZ3kwVlo5Vk5RQndDRmZSaGxOcXFFeFU5VldJeWhTcXlKaVNjeTRV?=
 =?utf-8?B?dzNxM25jWXBZSk8xb1NkVW9CQktodGpqdnRBRkZTeEp2Wjk0eGpERTRjdGNC?=
 =?utf-8?B?YWdrYXJRUGJuMUpoSkpHNHpuSFVXMTUvVDE2T3VKSnRaSlZvK21lQWNqeHg3?=
 =?utf-8?B?eTBFNkQ1OG4yMURlbTlBcmtMVWlOdHE1VDI3bzZUWVc3WUZGcVM2RGhhL2px?=
 =?utf-8?B?SzFnSjkrNjZtblBncFZ2MnNEK0pJSDZwYzNlZW5VZ05KS1MxdWhnczhGN0Ev?=
 =?utf-8?B?Y210Y3NpVm1paVJCUkFocmttenVUcnhCOUpraTFjNklxcE9qSGxodEZ2RjdX?=
 =?utf-8?B?TWhzK2hCeVQ4ODhGQ1NFeS8yckIzTFRmR1A1ZmJhbjNmZ3RTSmhEajBlRW5h?=
 =?utf-8?B?MFZ1bUZza2ZqcFl2VFczbmhyeU9rWFJhUFlQdHFjdkg2RXBFVnNBejgwcmp4?=
 =?utf-8?B?T3M0QWlkS3N3UGluWGhNV3h4YS9POWtuS09lVFhIcWxyNG5pWG9JMUdWRUE2?=
 =?utf-8?B?MkxHWkg2QTlTQ3ozZkJyRGpORFRzQUxpdk96NmJGdzJFeVZTU3pDeDd3aDR0?=
 =?utf-8?B?Y04zOWIycTBKMUs1Nm5RR0pobU1oUWhXRVFkU1J2dlgwQWJvSnJKTmxERElk?=
 =?utf-8?B?RmxvUVQyM3pnZm9RaEpHNDg0VUZpUW50NFdLeEw4MUlVeEV2dmRlb1M3MzFU?=
 =?utf-8?B?Wk8yZXVJbEU0ZkR1OWRtc2ZlNTZveXYwUHU4MjNFR0lKSHA3MnMzcHpaK0pr?=
 =?utf-8?B?OFRib2dpRG10cFM5NlVHenlQQm9ab0V1K2ozVW1CTGtLRkZDN0dVdGlLWHFo?=
 =?utf-8?B?KzBITlpIQUtSaUlqaVJTb0NKYU12Sm5zSGlwSWt3aDkzdWxsalJNME1vUkpO?=
 =?utf-8?B?a1RwUU81TTZ2NFlWS0NQclVXNXEzZjJZUTNiY0NndXQ3c1ZNRmVkR3lIK3hy?=
 =?utf-8?B?WHI0TVFOZGRYbkhkcWRCM1JBZklndEUyOW1IUHEvNHlpemNRb2QyQ25scGFa?=
 =?utf-8?B?SkxtWms0U01mZXIxVi9KRHBTSHhteG1reEJxRitHaW0xKy9LMTNhZnUzR0RN?=
 =?utf-8?B?ODUyMGNCemZCcjVmR2JMTjlnNVpVU1c3TTdJOHZxQ21LazdyRnl3SU9aRVQx?=
 =?utf-8?B?MWJ1SUJ3bTB4YzRxQW45MHIvKy9qV2lEOVpHV3RFUkRNY0M3Y2l0UkNBRDVC?=
 =?utf-8?B?THlpN2k3NS9PN3psdFNMMVhaNUg1WDI4bWZIYXZGOVErcldrRTNibnNDRWJN?=
 =?utf-8?B?R3JPREdIeXEwb093NFJyZ2RIcUlRVk5WanJrZ0taRnhMVitGcStUSEtBYkd3?=
 =?utf-8?B?bjc5VXRaM2lWT1B1UlVxL1pjOGZqcEQwbEdGNjA0WTVFcjBHRTdTY2xWd1dK?=
 =?utf-8?B?RGxwcDNwaTg5MlllNlllV290RWUrMGhyeXlIYXZzZFJiczNSU2owd2R4TzZO?=
 =?utf-8?B?RzhGRFZyZVEyb24wVXQ5ZUFOcXhXK241bk45U2l4VDg5VlpCMWhHQ0I2bWxl?=
 =?utf-8?B?dStXTTk3QUVkMkRMYlFQNGF0NHVHQ3BnODMzNndHekk0QkVnZCt6M1Y3L2dn?=
 =?utf-8?B?ZndRMjlvSzZpeURBemdMUUVyam1IMUZPekZqOEdFK3Q2ZGJVNkVHWlo5SHJs?=
 =?utf-8?B?TW5wdGExRHlqbjF5Z0xDN2hkR01Zb1liSkltYjI5TzlEVTF4eURUaEg4a3o0?=
 =?utf-8?B?RlBad1p0TmRrdFVUQVp0Zml3MUxZUGZGUjAvaDdEOXZHekxYTzR3WTRrVnV2?=
 =?utf-8?B?aU53MXVHSXd2ZlNvMTVjVWdKUDhnbHpXRVRrVitNNWJpWUFVRTROV3pOeXln?=
 =?utf-8?B?Wmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5BB143CE66FC6E41A15B92F478FCCE9B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 555df771-a142-4f32-595b-08dd1fd05734
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2024 01:56:23.2929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L/QXwRNm4JoporOqZDMrfhPeNnRkFA9cdC16fO1Tnm9AXJMEB1VxZkNLYoRYOfNbqDQmy2i2w1yUXdE6Kx71BAAW0RCl4HjsQrysw1D+sdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8145
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEyLTE3IGF0IDE2OjA4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIERlYyAxNywgMjAyNCwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBJdCBzZWVtcyBsaWtlIGFuIGFudGktcGF0dGVybiB0byBoYXZlIEtWTSBtYWludGFpbmluZyBh
bnkgY29kZSB0byBkZWZlbmQgYWdhaW5zdA0KPiA+IFREWCBtb2R1bGUgY2hhbmdlcyB0aGF0IGNv
dWxkIGluc3RlYWQgYmUgaGFuZGxlZCB3aXRoIGEgcHJvbWlzZS4gDQo+IA0KPiBJIGRpc2FncmVl
LCBzYW5pdHkgY2hlY2tpbmcgaGFyZHdhcmUgYW5kIGZpcm13YXJlIGlzIGEgZ29vZCB0aGluZy4g
IEUuZy4gc2VlIEtWTSdzDQo+IFZNQ1MgY2hlY2tzLCB0aGUgc2FuaXR5IGNoZWNrcyBmb3IgZmVh
dHVyZXMgU0VWIGRlcGVuZHMgb24sIGV0Yy4NCg0KT2suIE1vcmUgc29mdGx5LCBLVk0gc2hvdWxk
IG5vdCBkbyBzb21ldGhpbmcgb3Zlcmx5IGNvbXBsaWNhdGVkIGlmIGl0IGNvdWxkDQppbnN0ZWFk
IGJlIGhhbmRsZWQgYnkgVERYIG1vZHVsZSBhZG9wdGluZyByZWFzb25hYmxlIHBvbGljaWVzLiBT
YW5pdHkgY2hlY2tzIGFyZQ0Kc3VwcG9zZWQgdG8gYmUgZWFzeS4gVGhlIHJlYXNvbiBJJ20gcHJv
YmluZyBmdXJ0aGVyIGlzIGl0IGZlZWRzIGludG8gaG93IHdlDQpwb3NpdGlvbiB0aGluZ3Mgd2l0
aCB0aGUgVERYIG1vZHVsZSB0ZWFtLg0KDQo+IA0KPiBUaGF0IHNhaWQsIEknbSBub3QgdGVycmli
bHkgY29uY2VybmVkIGFib3V0IG1vcmUgZmVhdHVyZXMgdGhhdCBhcmUgdW5jb25kaXRpb25hbGx5
DQo+IGV4cG9zZWQgdG8gdGhlIGd1ZXN0LCBiZWNhdXNlIHRoYXQgd2lsbCBjYXVzZSBwcm9ibGVt
cyBmb3Igb3RoZXIgcmVhc29ucywgaS5lLg0KPiBJbnRlbCBzaG91bGQgYWxyZWFkeSBiZSBoZWF2
aWx5IGluY2VudGl2aXplZCB0byBub3QgZG8gc2lsbHkgdGhpbmdzLg0KDQpBZ3JlZS4gVGhhdCB3
YXMgc29ydCBvZiB0aGUgZXhwZWN0YXRpb24gdW50aWwgdGhlc2UgdHdvIGJpdHMgY2FtZSB1cCBp
biB0aGUgVEQNCmVudGVyL2V4aXQgZGlzY3Vzc2lvbi4NCg0KPiANCj4gPiBIb3dldmVyLCBLVk0g
aGF2aW5nIGNvZGUgdG8gZGVmZW5kIGFnYWluc3QgdXNlcnNwYWNlIHByb2RkaW5nIHRoZSBURFgg
bW9kdWxlDQo+ID4gdG8gZG8gc29tZXRoaW5nIGJhZCB0byB0aGUgaG9zdCBzZWVtcyB2YWxpZC4g
U28gZml4ZWQgYml0IGlzc3VlcyBzaG91bGQgYmUNCj4gPiBoYW5kbGVkIHdpdGggYSBwcm9taXNl
LCBidXQgaXNzdWVzIHJlbGF0ZWQgdG8gbmV3IGNvbmZpZ3VyYWJsZSBiaXRzIHNlZW1zDQo+ID4g
b3Blbi4NCj4gPiANCj4gPiBTb21lIG9wdGlvbnMgZGlzY3Vzc2VkIG9uIHRoZSBjYWxsOg0KPiA+
IA0KPiA+IDEuIElmIHdlIGdvdCBhIHByb21pc2UgdG8gcmVxdWlyZSBhbnkgbmV3IENQVUlEIGJp
dHMgdGhhdCBjbG9iYmVyIGhvc3Qgc3RhdGUgdG8NCj4gPiByZXF1aXJlIGFuIG9wdC1pbiAoYXR0
cmlidXRlcyBiaXQsIGV0YykgdGhlbiB3ZSBjb3VsZCBnZXQgYnkgd2l0aCBhIHByb21pc2UgZm9y
DQo+ID4gdGhhdCB0b28uIFRoZSBjdXJyZW50IHNpdHVhdGlvbiB3YXMgYmFzaWNhbGx5IHRvIGFz
c3VtZSBURFggbW9kdWxlIHdvdWxkbid0IG9wZW4NCj4gPiB1cCB0aGUgaXNzdWUgd2l0aCBuZXcg
Q1BVSUQgYml0cyAob25seSBhdHRyaWJ1dGVzL3hmYW0pLg0KPiA+IDIuIElmIHdlIHJlcXVpcmVk
IGFueSBuZXcgY29uZmlndXJhYmxlIENQVUlEIGJpdHMgdG8gc2F2ZS9yZXN0b3JlIGhvc3Qgc3Rh
dGUNCj4gPiBhdXRvbWF0aWNhbGx5IHRoZW4gd2UgY291bGQgYWxzbyBnZXQgYnksIGJ1dCB0aGVu
IEtWTSdzIGNvZGUgdGhhdCBkb2VzIGhvc3QNCj4gPiBzYXZlL3Jlc3RvcmUgd291bGQgZWl0aGVy
IGJlIHJlZHVuZGFudCBvciBuZWVkIGEgVERYIGJyYW5jaC4NCj4gPiAzLiBJZiB3ZSBwcmV2ZW50
IHNldHRpbmcgYW55IENQVUlEIGJpdHMgbm90IHN1cHBvcnRlZCBieSBLVk0sIHdlIHdvdWxkIG5l
ZWQgdG8NCj4gPiB0cmFjayB0aGVzZSBiaXRzIGluIEtWTS4gVGhlIGRhdGEgYmFja2luZyBHRVRf
U1VQUE9SVEVEX0NQVUlEIGlzIG5vdCBzdWZmaWNpZW50DQo+ID4gZm9yIHRoaXMgcHVycG9zZSBz
aW5jZSBpdCBpcyBhY3R1YWxseSBtb3JlIGxpa2UgImRlZmF1bHQgdmFsdWVzIiB0aGVuIGEgbWFz
ayBvZg0KPiA+IHN1cHBvcnRlZCBiaXRzLiBBIHBhdGNoIHRvIHRyeSB0byBkbyB0aGlzIGZpbHRl
cmluZyB3YXMgZHJvcHBlZCBhZnRlciB1cHN0cmVhbQ0KPiA+IGRpc2N1c3Npb24uWzBdDQo+IA0K
PiBUaGUgb25seSBDUFVJRCBiaXRzIHRoYXQgdHJ1bHkgbWF0dGVyIGFyZSB0aG9zZSB0aGF0IGFy
ZSBhc3NvY2lhdGVkIHdpdGggaGFyZHdhcmUNCj4gZmVhdHVyZXMgdGhlIFREWCBtb2R1bGUgYWxs
b3dzIHRoZSBndWVzdCB0byB1c2UgZGlyZWN0bHkuICBBbmQgZm9yIHRob3NlLCBLVk0NCj4gKm11
c3QqIGtub3cgaWYgdGhleSBhcmUgZml4ZWQwIChpbnZlcnRlZCBwb2xhcml0eSBvbmx5PyksIGZp
eGVkMSwgb3IgY29uZmlndXJhYmxlLg0KPiBBcyBBZHJpYW4gYXNzZXJ0ZWQsIHRoZXJlIHByb2Jh
Ymx5IGFyZW4ndCBtYW55IG9mIHRoZW0uDQoNCkkgZG9uJ3QgZm9sbG93IHdoeSB0aGUgZml4ZWQg
Yml0cyBhcmUgc3BlY2lhbCBoZXJlLiBJZiBhbnkgY29uZmlndXJhdGlvbiBjYW4NCmFmZmVjdCB0
aGUgaG9zdCwgS1ZNIG5lZWRzIHRvIGtub3cgYWJvdXQgaXQuIFdoZXRoZXIgaXQgaXMgZml4ZWQg
b3INCmNvbmZpZ3VyYWJsZS4NCg0KSSB3b25kZXIgaWYgdGhlcmUgY291bGQgYmUgc29tZSBjb25m
dXNpb24gYWJvdXQgaG93IG11Y2ggS1ZNIGNhbiB0cnVzdCB0aGF0IGl0cw0KdmlldyBvZiB0aGUg
Q1BVSUQgYml0cyBpcyB0aGUgc2FtZSBhcyB0aGUgVERYIE1vZHVsZXM/IEluIHRoZSBjdXJyZW50
IHBhdGNoZXMNCnVzZXJzcGFjZSBpcyByZXNwb25zaWJsZSBmb3IgYXNzZW1ibGluZyBLVk0ncyBD
UFVJRCBkYXRhIHdoaWNoIGl0IHNldHMgd2l0aA0KS1ZNX1NFVF9DUFVJRDIgbGlrZSBub3JtYWwu
IEl0IGZldGNoZXMgYWxsIHRoZSBzZXQgYml0cyBmcm9tIHRoZSBURFggbW9kdWxlLA0KbWFzc2Fn
ZXMgdGhlbSwgYW5kIHBhc3MgdGhlbSB0byBLVk0uIFNvIGlmIGEgaG9zdCBhZmZlY3RpbmcgY29u
ZmlndXJhYmxlIGJpdCBpcw0Kc2V0IGluIHRoZSBURFggbW9kdWxlLCBidXQgbm90IGluIEtWTSB0
aGVuIGl0IGNvdWxkIGJlIGEgcHJvYmxlbS4gSSB0aGluayB3ZQ0KbmVlZCB0byByZWFzc2VzcyB3
aGljaCBiaXRzIGNvdWxkIGFmZmVjdCBob3N0IHN0YXRlLCBhbmQgbWFrZSBzdXJlIHdlIHJlLWNo
ZWNrDQp0aGVtIGJlZm9yZSBlbnRlcmluZyB0aGUgVEQuIEJ1dCB3ZSBjYW4ndCBzaW1wbHkgY2hl
Y2sgdGhhdCBhbGwgYml0cyBtYXRjaA0KYmVjYXVzZSB0aGVyZSBhcmUgc29tZSBiaXRzIHRoYXQg
YXJlIHNldCBpbiBLVk0sIGJ1dCBub3QgVERYIG1vZHVsZSAocmVhbCBQVg0KbGVhZnMsIGd1ZXN0
bWF4cGEsIGV0YykuDQoNClNvIHRoYXQgaXMgaG93IEkgYXJyaXZlZCBhdCB0aGF0IHdlIG5lZWQg
c29tZSBsaXN0IG9mIGhvc3QgYWZmZWN0aW5nIGJpdHMgdG8NCnZlcmlmeSBtYXRjaCBpbiB0aGUg
VEQuDQoNCj4gDQo+IEZvciBhbGwgb3RoZXIgQ1BVSUQgYml0cywgd2hhdCB0aGUgVERYIE1vZHVs
ZSB0aGlua3MgYW5kL29yIHByZXNlbnRzIHRvIHRoZSBndWVzdA0KPiBpcyBjb21wbGV0ZWx5IGly
cmVsZXZhbnQsIGF0IGxlYXN0IGFzIGZhciBhcyBLVk0gY2FyZXMsIGFuZCB0byBzb21lIGV4dGVu
dCBhcyBmYXINCj4gYXMgUUVNVSBjYXJlcy4gIFRoaXMgaW5jbHVkZXMgdGhlIFREWCBNb2R1bGUn
cyBGRUFUVVJFX1BBUkFWSVJUX0NUUkwsIHdoaWNoIGZyYW5rbHkNCj4gaXMgYXNpbmluZSBhbmQg
c2hvdWxkIGJlIGlnbm9yZWQuICBJTU8sIHRoZSBURFggTW9kdWxlIHNwZWMgaXMgZW50aXJlbHkg
b2ZmIHRoZQ0KPiBtYXJrIGluIGl0cyBhc3Nlc3NtZW50IG9mIHBhcmF2aXJ0dWFsaXphdGlvbi4g
IEluamVjdGluZyBhICNWRSBpbnN0ZWFkIG9mIGEgI0dQDQo+IGlzbid0ICJwYXJhdmlydHVhbGl6
YXRpb24iLg0KPiAgDQo+IFRha2UgVFNDX0RFQURMSU5FIGFzIGFuIGV4YW1wbGUuICAiRGlzYWJs
aW5nIiB0aGUgZmVhdHVyZSBmcm9tIHRoZSBndWVzdCdzIHNpZGUNCj4gc2ltcGx5IG1lYW5zIHRo
YXQgV1JNU1IgI0dQcyBpbnN0ZWFkIG9mICNWRXMuICAqTm90aGluZyogaGFzIGNoYW5nZWQgZnJv
bSBLVk0ncw0KPiBwZXJzcGVjdGl2ZS4gIElmIHRoZSBndWVzdCBtYWtlcyBhIFREVk1DQUxMIHRv
IHdyaXRlIElBMzJfVFNDX0RFQURMSU5FLCBLVk0gaGFzDQo+IG5vIGlkZWEgaWYgdGhlIGd1ZXN0
IGhhcyBvcHRlZCBpbi9vdXQgb2YgI1ZFIHZzICNHUC4gIEFuZCBJTU8sIGEgc2FuZSBndWVzdCB3
aWxsDQo+IG5ldmVyIHRha2UgYSAjVkUgb3IgI0dQIGlmIGl0IHdhbnRzIHRvIHVzZSBUU0NfREVB
RExJTkU7IHRoZSBrZXJuZWwgc2hvdWxkIGluc3RlYWQNCj4gbWFrZSBhIGRpcmVjdCBURFZNQ0FM
TCBhbmQgc2F2ZSBpdHNlbGYgYSBwb2ludGxlc3MgZXhjZXB0aW9uLg0KPiANCj4gICBFbmFibGlu
ZyBHdWVzdCBURHMgYXJlIG5vdCBhbGxvd2VkIHRvIGFjY2VzcyB0aGUgSUEzMl9UU0NfREVBRExJ
TkUgTVNSIGRpcmVjdGx5Lg0KPiAgIFZpcnR1YWxpemF0aW9uIG9mIElBMzJfVFNDX0RFQURMSU5F
IGRlcGVuZHMgb24gdGhlIHZpcnR1YWwgdmFsdWUgb2YNCj4gICBDUFVJRCgxKS5FQ1hbMjRdIGJp
dCAoVFNDIERlYWRsaW5lKS4gVGhlIGhvc3QgVk1NIG1heSBjb25maWd1cmUgKGFzIGFuIGlucHV0
IHRvDQo+ICAgVERILk1ORy5JTklUKSB2aXJ0dWFsIENQVUlEKDEpLkVDWFsyNF0gdG8gYmUgYSBj
b25zdGFudCAwIG9yIGFsbG93IGl0IHRvIGJlIDENCj4gICBpZiB0aGUgQ1BV4oCZcyBuYXRpdmUg
dmFsdWUgaXMgMS4NCj4gDQo+ICAgSWYgdGhlIFREWCBtb2R1bGUgc3VwcG9ydHMgI1ZFIHJlZHVj
dGlvbiwgYXMgZW51bWVyYXRlZCBieSBURFhfRkVBVFVSRVMwLlZFX1JFRFVDVElPTg0KPiAgIChi
aXQgMzApLCBhbmQgdGhlIGd1ZXN0IFREIGhhcyBzZXQgVERfQ1RMUy5SRURVQ0VfVkUgdG8gMSwg
aXQgbWF5IGNvbnRyb2wgdGhlDQo+ICAgdmFsdWUgb2YgdmlydHVhbCBDUFVJRCgxKS5FQ1hbMjRd
IGJ5IHdyaXRpbmcgVERDUy5GRUFUVVJFX1BBUkFWSVJUX0NUUkwuVFNDX0RFQURMSU5FLiANCj4g
DQo+ICAg4oCiIElmIHRoZSB2aXJ0dWFsIHZhbHVlIG9mIENQVUlEKDEpLkVDWFsyNF0gaXMgMCwg
SUEzMl9UU0NfREVBRExJTkUgaXMgdmlydHVhbGl6ZWQNCj4gICAgIGFzIG5vbi1leGlzdGVudC4g
V1JNU1Igb3IgUkRNU1IgYXR0ZW1wdHMgcmVzdWx0IGluIGEgI0dQKDApLg0KPiANCj4gICDigKIg
SWYgdGhlIHZpcnR1YWwgdmFsdWUgb2YgQ1BVSUQoMSkuRUNYWzI0XSBpcyAxLCBXUk1TUiBvciBS
RE1TUiBhdHRlbXB0cyByZXN1bHQNCj4gICAgIGluIGEgI1ZFKENPTkZJR19QQVJBVklSVCkuIFRo
aXMgZW5hYmxlcyB0aGUgVETigJlzICNWRSBoYW5kbGVyLg0KPiANCj4gRGl0dG8gZm9yIFRNRSwg
TUtUTUUuDQo+IA0KPiBGRUFUVVJFX1BBUkFWSVJUX0NUUkwuTUNBIGlzIGV2ZW4gd2VpcmRlciwg
YnV0IEkgc3RpbGwgZG9uJ3Qgc2VlIGFueSByZWFzb24gZm9yDQo+IEtWTSBvciBRRU1VIHRvIGNh
cmUgaWYgaXQncyBmaXhlZCBvciBjb25maWd1cmFibGUuICBUaGVyZSdzIHNvbWUgY3JhenkgbG9n
aWMgZm9yDQo+IHdoZXRoZXIgb3Igbm90IENSNC5NQ0UgY2FuIGJlIGNsZWFyZWQsIGJ1dCB0aGUg
aG9zdCBjYW4ndCBzZWUgZ3Vlc3QgQ1I0LCBhbmQgc28NCj4gb25jZSBhZ2FpbiwgdGhlIFREWCBN
b2R1bGUncyB2aWV3IG9mIE1DQSBpcyBpcnJlbGV2YW50IHdoZW4gaXQgY29tZXMgdG8gaGFuZGxp
bmcNCj4gVERWTUNBTEwgZm9yIHRoZSBtYWNoaW5lIGNoZWNrIE1TUnMuDQo+IA0KPiBTbyBJIHRo
aW5rIHRoaXMgYWdhaW4gcHVyZWx5IGNvbWVzIHRvIGJhY2sgdG8gS1ZNIGNvcnJlY3RuZXNzIGFu
ZCBzYWZldHkuICBNb3JlDQo+IHNwZWNpZmljYWxseSwgdGhlIFREWCBNb2R1bGUgbmVlZHMgdG8g
cmVwb3J0IGZlYXR1cmVzIHRoYXQgYXJlIHVuY29uZGl0aW9uYWxseQ0KPiBlbmFibGVkIG9yIGRp
c2FibGVkIGFuZCBjYW4ndCBiZSBlbXVsYXRlZCBieSBLVk0uICBGb3IgZXZlcnl0aGluZyBlbHNl
LCBJIGRvbid0DQo+IHNlZSBhbnkgcmVhc29uIHRvIGNhcmUgd2hhdCB0aGUgVERYIG1vZHVsZSBk
b2VzLg0KPiANCj4gSSdtIHByZXR0eSBzdXJlIHRoYXQgZ2l2ZXMgdXMgYSB3YXkgZm9yd2FyZC4g
IElmIHRoZXJlIG9ubHkgYSBoYW5kZnVsIG9mIGZlYXR1cmVzDQo+IHRoYXQgYXJlIHVuY29uZGl0
aW9uYWxseSBleHBvc2VkIHRvIHRoZSBndWVzdCwgdGhlbiBLVk0gZm9yY2VzIHRob3NlIGZlYXR1
cmVzIGluDQo+IGNwdV9jYXBzWypdLg0KDQpJIHNlZS4gSG1tLiBXZSBjb3VsZCB1c2UgdGhpcyBu
ZXcgaW50ZXJmYWNlIHRvIGRvdWJsZSBjaGVjayB0aGUgZml4ZWQgYml0cy4gSXQNCnNlZW1zIGxp
a2UgYSByZWxhdGl2ZWx5IGNoZWFwIHNhbml0eSBjaGVjay4NCg0KVGhlcmUgYWxyZWFkeSBpcyBh
biBpbnRlcmZhY2UgdG8gZ2V0IENQVUlEIGJpdHMgKGZpeGVkIGFuZCBkeW5hbWljKS4gQnV0IGl0
IG9ubHkNCndvcmtzIGFmdGVyIGEgVEQgaXMgY29uZmlndXJlZC4gU28gaWYgd2Ugd2FudCB0byBk
byBleHRyYSB2ZXJpZmljYXRpb24gb3INCmFkanVzdG1lbnRzLCB3ZSBjb3VsZCB1c2UgaXQgYmVm
b3JlIGVudGVyaW5nIHRoZSBURC4gQmFzaWNhbGx5LCBpZiB3ZSBkZWxheSB0aGlzDQpsb2dpYyB3
ZSBkb24ndCBuZWVkIHRvIHdhaXQgZm9yIHRoZSBmaXhlZCBiaXQgaW50ZXJmYWNlLg0KDQpXaGF0
IGlzIHNwZWNpYWwgYWJvdXQgdGhlIG5ldyBwcm9wb3NlZCBmaXhlZCBiaXQgaW50ZXJmYWNlIGlz
IHRoYXQgaXQgY2FuIHJ1bg0KYmVmb3JlIGEgVEQgcnVucyAod2hlbiBRRU1VIHdhbnRzIHRvIGRv
IGl0J3MgY2hlY2tpbmcgb2YgdGhlIHVzZXJzIGFyZ3MpLg0KDQo+IA0KPiAgIEkuZS4gdHJlYXQg
dGhlbSBraW5kYSBsaWtlIFhTQVZFUyBvbiBBTUQsIHdoZXJlIEtWTSBhc3N1bWVzIHRoZQ0KPiBn
dWVzdCBjYW4gdXNlIFhTQVZFUyBpZiBpdCdzIHN1cHBvcnRlZCBpbiBoYXJkd2FyZSBhbmQgWFNB
VkUgaXMgZXhwb3NlZCB0byB0aGUNCj4gZ3Vlc3QsIGJlY2F1c2UgQU1EIGRpZG4ndCBwcm92aWRl
IGFuIGludGVyY2VwdGlvbiBrbm9iIGZvciBYU0FWRVMuDQo+IA0KPiBJZiB0aGUgbGlzdCBpcyAi
dG9vIiBsb25nIChzdWpiZWN0aXZlKSBmb3IgS1ZNIHRvIGhhcmRjb2RlLCB0aGVuIHdlIHJldmlz
aXQgYW5kDQo+IGdldCB0aGUgVERYIG1vZHVsZSB0byBwcm92aWRlIGEgbGlzdC4NCj4gDQo+IFRo
aXMgcHJvYmFibHkgZG9lc24ndCBzb2x2ZSBYaWFveWFvJ3MgVVggcHJvYmxlbSBpbiBRRU1VLCBi
dXQgSSB0aGluayBpdCBnaXZlcw0KPiB1cyBhIHNhbmUgYXBwcm9hY2ggZm9yIEtWTS4NCj4gDQo+
IFsqXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyNDExMjgwMTM0MjQuNDA5NjY2OC0x
LXNlYW5qY0Bnb29nbGUuY29tDQoNCg0KDQo=

