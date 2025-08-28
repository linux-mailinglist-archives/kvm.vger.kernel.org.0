Return-Path: <kvm+bounces-56008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCADB3910B
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 03:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 835501B2291E
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 01:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE7A1FA15E;
	Thu, 28 Aug 2025 01:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qsqi8Nr/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55111A9F9D;
	Thu, 28 Aug 2025 01:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756344423; cv=fail; b=Fpu3ImQqmxbLp9VqCQOAtrgKzuyohZhTHHTaS2lYRkClkKE6rML3S5R5wgsxtkomHnjX078nV/DN/GSpsdgIdIzg9gRPuaEKPR6O5kUqFj+45MIkV8WThPo2i65S7NE8OpAwcxzP9Ij59K3s/uov1UmtJUs7HohuojSgS2kW5D8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756344423; c=relaxed/simple;
	bh=1k/7mtBwspPUsuiJlVek56dXigwLel9J4tZQ15VHsLo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lp3CRJgqdEIkGXxl+dW0YikgpoQFh9II7CERCwE1GWFuJ18j/bHO5Zx8Xws/rDm5gPc1hoCTUwtxF8ogkixrLP3zqcu/VekUb1himvqxdFkg/UaczLUHUPVpd7+fDjV6nVNfujfk7tLlBxKEkp7ztpGVeirVqqEGX76zRNHhePo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qsqi8Nr/; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756344422; x=1787880422;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1k/7mtBwspPUsuiJlVek56dXigwLel9J4tZQ15VHsLo=;
  b=Qsqi8Nr/cE4tLOzD/pgr3wDcMiBuLt/ZOrRIFV3kFg3tyIGnGatZz7uJ
   /+JzDGzvjSjxJfuihBeF8HEXFCM7EuSH2oAvkZXVj6LJXdBx6Qqz4mAhR
   //p0AYjkGaJ2DGI1aqZu4Dg+cJnMW7SJlF8bwHbRZpkOTfssEEBNhTlgg
   OzkK7PsNpw/YBzft1nQa1pBLERBe1ntvHhMIWzPwKPRxomaPjuZ9inJEz
   Sk5hi3l1fXJWHi982v/kaZeoQXoPFEqv57CW6ulujfeTQiOe5farwjAEE
   R9D6gmsc1cgycvP9crWrcTP6nheKZSZ1HxZuJv1eT31ohEaXfeEGvwNqj
   A==;
X-CSE-ConnectionGUID: RzGikuBAQEmVbCwE7axiTQ==
X-CSE-MsgGUID: BVVwiCmdSeCbjMn/1DC0ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58703547"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58703547"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:27:01 -0700
X-CSE-ConnectionGUID: 6KeevB/SRjqkIIKpPoW9WA==
X-CSE-MsgGUID: 6muttMJpSe69HvpJI4ZgJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="170154419"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 18:26:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 18:26:57 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 18:26:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.41) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 18:26:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s+yi86gaMy2yJZrRsOLxZn1HW7DTT7zUIm50UDK2XhTJwdaAnevMJy4yxJ7LzFRCUEa+U4Oj+zGFXBSWqQ0AV5xhBCwDqI3ICSmtM8ht8lvYsonurQR06knITl4EkoLiZFUr9T4Q4ziH+cG7o5fDlOoeaMz+az08VF9ZmVjPMd0XoLRaz3If4qBAZ/LDvgm/8dlHEnBiEaBNrJAGqXuWdoTiOX//lJuyEWJhTwviozOiQ1F7dsHh9cNcBua1mFjiw0mdbLdh/hZv/cAF4ODZ1tcCBeNlF+pVPi6IMIN4tVx+AAGK+ElA4xh3S0Eduz+FvQzhlczoci+8vtbQezEGFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1k/7mtBwspPUsuiJlVek56dXigwLel9J4tZQ15VHsLo=;
 b=v4iVLjwHFchOpl8xpteXxymIU5OEYhts96SmmPtXl69uUBd4AyrEVeVPOyB4KPr5ADhC7yRp9r2OrGWu7PRi1q1MowjegIuQ+Y5rJQW0H+cG8kEGo/J23okZj24FQTBxwXMP/XF0gC5vawZVKLkX4rCL4q5LSCBSwY6zyFQApRDDvlYTIGIlou5yqEFy+SjuTiRLX+nLjwgQ38VPxJ4aWsBbdZ0idtFBWA8zAaej4qGjs57vBP0KfzkzK/pkV9YQTR+m+x7J7po7LpLmpW7R1uBkodx9OypnhfuLGp/ZB8GVZYx9I+BpCfdEGxmDT8Y9R+G/gfIixBNdvyxtqBD7rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8584.namprd11.prod.outlook.com (2603:10b6:408:1f0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 01:26:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 01:26:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Topic: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Index: AQHcFuZRH7A9gjtzDkWLIdW2XN4AQ7R2KoyAgAEUWoCAAAjzgA==
Date: Thu, 28 Aug 2025 01:26:50 +0000
Message-ID: <6bb76ce318651fcae796be57b77e10857eb73879.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-3-seanjc@google.com>
	 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
	 <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
In-Reply-To: <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV8PR11MB8584:EE_
x-ms-office365-filtering-correlation-id: 7f5db146-6861-42d3-e1ac-08dde5d1f684
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WVdvSHlBeWlEc3R3NjhGKzk3MitSVDIyM29xV0RRNjJLZ0E0Mjhpd3NIQXdv?=
 =?utf-8?B?WnorZk9PUTlIR25rNmxpMUVZVldLc1V2bU9DSjVLZzVEMHJCWHMzMXBkWGpU?=
 =?utf-8?B?blJ6czA5Y3dOenJvaGk5MmNYSXQ4YmltRnhEUDhxREdZUjRxblF4MFBPcnEr?=
 =?utf-8?B?L1kyU2tQcm5uWTQ2bjNRaGZFa1hFRDBhRElXOG1ZU2VCODVPZmFpVGlENGg3?=
 =?utf-8?B?eHdpbWxGdFVBMVNGQmZCSlA1TjNLOUNRcE9SK0FYWmpXS1J0eGxybjFpclRw?=
 =?utf-8?B?N1dBb0dZWWNRbGltcVJFQjNjUWc0bGQ0OThiejZ6c1laL2VtWC9aK3NqNUZr?=
 =?utf-8?B?ekd0YnhoaXJEVEUvby9LYkpQaTlpenFHYTJYRFZ4WEZsWkk5MHh1SDBVd0xF?=
 =?utf-8?B?SEhoL25UK1AydTRqVlA5cy9jVk5wL2U3M0UzUm9iNmRIeFpVN1F6UXF6T1Mx?=
 =?utf-8?B?NGpHeWJLLzl1V2N3RGZBd1gxNW1qd1U0THFaSDRxaGE4OXhEY3JPb2VJaDdB?=
 =?utf-8?B?ZFFWL1ZTb1piV0FWS1djNG5TcjNQdGF5eDV6TkxlaUFUdTlxWkQ2VjRGNW95?=
 =?utf-8?B?Y1d4cURmWk0wS2FFWm8zUUpSZnhOWWpOdis3TmN2c2dTalVsWlovem9YUUdM?=
 =?utf-8?B?bEZsTmtxM01PTjdkemJ3T1YxNjE5UXA2cHZOaVVhSkF3cEJJL3ZFMGxxaFMy?=
 =?utf-8?B?bDJPYmQ5RVRnMXV5QzkzY1gwMzRoMk96Y05PUmtYNHc0RjBUaVJXTnZPWUIr?=
 =?utf-8?B?ck5JMHFtR0hNNHJqeHMrVXZUT0tFZ3FRVUhWa2NQNWdrdmJrdWRyVGJ0U1A5?=
 =?utf-8?B?MnVCZ1ZPN1JCdjk5WkExZVZSd25aUVpUeVg5SXVOWThleUgyTW5aZUJybXFi?=
 =?utf-8?B?VDlnMGt4QUlvZlJ0UWE5UlRCVVpKRjRqTEcrTGt2WUVPK243eHQyd2lXcmE5?=
 =?utf-8?B?NVVBNThhZ2Z4OUE3cEFBdDVIRDFTdFFpV2thdWIySUtGeWZudHFqczhIRnhy?=
 =?utf-8?B?ZzBLSzgzZGJ3VXl3L1lIL3pBRTA4N3pCZFRUcDlFK0RSMGRzRjE1THkvazMy?=
 =?utf-8?B?a3pacThPeWduaU1OMlhDRTVQSEZCdVZqVk1zbWRsTkk2ejk4dC9hQk1uakxS?=
 =?utf-8?B?Wm9FeXZNMm9GRG5WaVdtUHhuS09BSmc5WFQwbnBCMVlRUlhGWHlQVURadDdt?=
 =?utf-8?B?K3Vmcm01Tk1ZK0ZZMEp5QlZkenhobldQZWpiY01BZUhvL3BCSGoyWTRwRElY?=
 =?utf-8?B?dy9FRWEyajZ0SnJpbmZSZC84bHRTTysyQkRSblBJbm53aGJnR1FEenA3dlB0?=
 =?utf-8?B?RDN5NXEyMVFWOC9SdG1DTkJZNWg3N0pEZ0Y5K1ZmckF6a09KMXV1cjFjcFN6?=
 =?utf-8?B?M0ZsYVhzTEMzS0FnaDlDTHBTejFIUEpLM09FWk9ZSTVIajRvNzk3SHQ2WG11?=
 =?utf-8?B?VzZneVRhMG13c2JUODRCTUNuYnZQUFBUWVdkSDNPZ0NyRnZNUm5VNjg5ZzZ5?=
 =?utf-8?B?bzM4Vm1ZUVdLNkV2RzJ3MTJxdEFxdCsyTEpqWEMyRnBtdTA1TVNXRDdZeFph?=
 =?utf-8?B?aUROMmJaS2JmczBtWEYyNWwyamt3Wm1xYUo0N0VVUDIwa2xmU3BCMUF3Q0pj?=
 =?utf-8?B?RktZMEVLOU42ZmFSa2U2S1Y1bkkwN21oaGgvUm1WeWtTV2JNcVVkN2xlaHRP?=
 =?utf-8?B?KzVZR05PTkNtL3Rjb0lYTFRzVEZRL0tTa1JPWlBvVElkNE1xbDRuajB4emk5?=
 =?utf-8?B?SGJlWWpsVkl1b3J1QkFmZHZ4WkZvUzhFNWNpY1BoWS85dldMR0FrTDhmck9k?=
 =?utf-8?B?aXNmaXZ3bmNqTjFiUVkzS2NQZmpqYllmb1FBL0lMTjloR0E0RVI4SjFmcVpn?=
 =?utf-8?B?V0tlcnJlUWZrRERPWVpIL0hnVkpPVTB4dEMxRVM5cThId1FsSDBwQmxTSld2?=
 =?utf-8?B?dFl4R2p3L0xYOTF0NWMrWXBKZzVIUHpDeUV1WmtYUVpKaUxIU3VKOFlqRis4?=
 =?utf-8?Q?vPfMCpcIsdnaMQRJS9vxRCZETSHNWA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UVoyKzQ3RDMzc2RHVDZSV3JZR0Fjb3FsWVpYRFRnRVZZVU56V1VJZWFKNTEy?=
 =?utf-8?B?dEgzK1NWLytERyt3ZWVjQ1dsbXhrVDQ5d0ZsbkoyQlAwbUZHYUswUzlERmtS?=
 =?utf-8?B?L2lLb2hMVEJ4VXBMQ0xRQit3Q3ZtLzYvRmw3MFliaFhHQytsQUdjNlpoZCth?=
 =?utf-8?B?OS9jeHplYTFoOXd4OGJkd24rNEFOdUZNMHZtdGNubTlQRXArRlZzSlV6VTF5?=
 =?utf-8?B?M2p5M2ZGdDJTQXc5MG9mWGpFbTBoWEd2Qk13b3ZXRHN3L0Vkb3VoSmlzK0Yz?=
 =?utf-8?B?WDdrandIRTJGbFhCOTJvR09URTRpa2ZSOGxLY2daVW9YcVljbzBRdTI3aGVX?=
 =?utf-8?B?Z1J5ZkgrdUVhUXZ6eWFTU09oNmp2ajBoT2tBRjk0eDZ0amFSSitnSGZRUjRN?=
 =?utf-8?B?eCtnZTREVGNBUm1WRlIxeWVNcWMzcW5ZVGUvZnNuNDF6dWQ2dk5xaUphRHZK?=
 =?utf-8?B?a2t3UnZvcFFURkhUanBFNndYd2pCZ1JUclIwaU5ITG1sUm9pam1iNVQxeFRZ?=
 =?utf-8?B?ZnpVdmFwMHNuRThSRzhxUVA0K29TWFpkNTluNENSVnVDTnp3dEFUeXVVY1N0?=
 =?utf-8?B?OG1IRzFzd2F4anBVRzhvSWk5UXVwTTdJby9id1JXeW5QWG9zM0cxMTFzdVlM?=
 =?utf-8?B?SVVHeEY3bFpDOHROZzJXZW50NUYvejJsNWZ1RXhQYURBVE1jR1NUNzhiaFJx?=
 =?utf-8?B?ZWU0ZkduUEhmdk5hVHBBSWw1OEkveDA1WkhlVU5ZOGV2Y0ZhNThQbm1pa2Jm?=
 =?utf-8?B?clFvRUl5QXl1RlJRay9OTVFqRTUwTjZrY1hNY1JOMEw3UFFBeDB5dVBVa0JE?=
 =?utf-8?B?RytVUHA3QmxmbHRjN2VlSDJTdmFvaGcwRGhaQU1BSFllZ2luZ1QvYnJMYWhL?=
 =?utf-8?B?OUZFa3VJbDhvbm1vc203ak9KcEQvRXJRL2lQYlIxVzdjbFQrK1B4dlFvTDlS?=
 =?utf-8?B?U2tFaWl5RFdSS3hSSHVXdjYzRFJnMmtrN0hlSkdObGZSV3FEWXVkZVgrYlVO?=
 =?utf-8?B?TWMwOENtcW80V3ErbHM3ZEF2V1krUDhINExKeGhKUXF6YWRSYVUxQTE5Qmha?=
 =?utf-8?B?OGdjL0NQTnFLQWxMN2R6NEI5VGxNczBzc3Mva0l5ZlR5N0NIRTlxM3pCdzV0?=
 =?utf-8?B?TmxMVVJHenNCblpMb01HQmIrYy95TThZVFUxQkwzekxwWmdhbWlFSnR2elJt?=
 =?utf-8?B?UmV2SkNLejhqOWh4N21hSnQvcXZnVmVHUDBRejZ3NHhnWS91TE5FS0RLWklu?=
 =?utf-8?B?R0ZNam9YanBXVTFESUdTS2NPR2Y5Y2NCdVpVYkprYXlvRDQwOW5wQmpCanpF?=
 =?utf-8?B?RGdtWnNicEFHR1FPWUw4b1ZzZDI1czU1bXJmd3AvUi9KVHJiYVFpclhMMGFJ?=
 =?utf-8?B?T2NJVm1oMjZQUEV0QVpZRi81QU1UTlFnNFNwbVl6TzVYU1pkSkNFeDR2WW5z?=
 =?utf-8?B?T2pvanZ1RWVPZnlRWkhxVXFtaXByQTg1SWFuQVBsSi8zTkpoZ1VlYVEzcmYw?=
 =?utf-8?B?S1dtdlM5UUo5bzJmbktya1RVRXV0VDltTkgwQXl5NzBtNjBRS0xzYjg1Ykwx?=
 =?utf-8?B?T09wMldsaVowdE5LK2c1OFplVkNWZ3k0cXd3bjBXZVloZU5MKzdwY2ErZlVC?=
 =?utf-8?B?S2Q2UUtwUHNjd0dSd0MxRjBLbjF1ZnZQNFhGZlNIZFRYNmdFcEI4QVZHNTdt?=
 =?utf-8?B?VnIzQ0RpR2NxWHh2dGs1Sml1bzA3NWM5TUI4bUJwcEx0NHB6bDZkbWFtNU9k?=
 =?utf-8?B?Yk5JMkM5bnRyajFHaFllRUE3dkpIV09FTXNqMHlTekRNRlU1ditwenAxSFox?=
 =?utf-8?B?M3psREVRYXZyM2ZoU1VGbWM0bkQxSDZuS1pzbTJwNkJoL3ZteVlNSmdhK2I0?=
 =?utf-8?B?NWdPOVl4Zm1KaC94bFBPZDYrVC9ualh6eXNsaFJOMUg1TGJNbS9XUU9kRUU0?=
 =?utf-8?B?b0Z0c3hRdldYNFduQTZxeG53azdwVWR4VmQweW9aU1ROZkZNRnNleGVDUmNM?=
 =?utf-8?B?RXk0bElNWUtwQU9SU0R5K0duQ3VLOStPMGZMTU9NTHo1aEJSaEpuRGNBQTYx?=
 =?utf-8?B?OUU4cXUxK3hURjZQM0lrVm13NmRrdXVGRU9YQ21yUFErMWNKMXRxczdsdmUz?=
 =?utf-8?B?OC8xbmwwT3lVejl5U0RPQTJmWlgxYngzQnd4eVplaG9WUExodER0U1VuMzUr?=
 =?utf-8?B?V2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1F5D3E64800CCE49913E58BF691A6DC9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f5db146-6861-42d3-e1ac-08dde5d1f684
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 01:26:50.2931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DPkFXThWUaNQdAjcpD0bCYq15TXvyP8OfU5nP7y1aO5T+NxgGdltBaOM44OShqIV1CatpkQ/GKwbB6Cfg539Tf4+iG7KE+jU9veGq40sGzY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8584
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDE3OjU0IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gPiANCj4gPiBUaGVuLCB3aGF0IGFib3V0IHNldHRpbmcNCj4gPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgLm1heF9sZXZlbCA9IFBHX0xFVkVMXzRLLA0KPiA+IGRpcmVjdGx5Pw0K
PiA+IA0KPiA+IE90aGVyd2lzZSwgdGhlICIoS1ZNX0JVR19PTihsZXZlbCAhPSBQR19MRVZFTF80
Sywga3ZtKSIgd291bGQgYmUgdHJpZ2dlcmVkDQo+ID4gaW4NCj4gPiB0ZHhfc2VwdF9zZXRfcHJp
dmF0ZV9zcHRlKCkuDQo+IA0KPiBZZXMgdGhpcyBmYWlscyB0byBib290IGEgVEQuIFdpdGggbWF4
X2xldmVsID0gUEdfTEVWRUxfNEsgaXQgcGFzc2VzIHRoZSBmdWxsDQo+IHRlc3RzLiBJIGRvbid0
IHRoaW5rIGl0J3MgaWRlYWwgdG8gZW5jb2RlIFBBR0UuQUREIGRldGFpbHMgaGVyZSB0aG91Z2gu
DQo+IA0KPiBCdXQgSSdtIG5vdCBpbW1lZGlhdGVseSBjbGVhciB3aGF0IGlzIGdvaW5nIHdyb25n
LiBUaGUgb2xkIHN0cnVjdA0KPiBrdm1fcGFnZV9mYXVsdA0KPiBsb29rcyBwcmV0dHkgc2ltaWxh
ci4gRGlkIHlvdSByb290IGNhdXNlIGl0Pw0KDQpPaCwgZHVoLiBCZWNhdXNlIHdlIGFyZSBwYXNz
aW5nIGluIHRoZSBQRk4gbm93IHNvIGl0IGNhbid0IGtub3cgdGhlIHNpemUuwqBTbw0KaXQncyBu
b3QgYWJvdXQgUEFHRS5BREQgYWN0dWFsbHkuDQoNClNpbGwsIGhvdyBhYm91dCBjYWxsaW5nIHRo
ZSBmdW5jdGlvbiBrdm1fdGRwX21tdV9tYXBfcHJpdmF0ZV9wZm5fNGsoKSwgb3INCnBhc3Npbmcg
aW4gdGhlIGxldmVsPw0K

