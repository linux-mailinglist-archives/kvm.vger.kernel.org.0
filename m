Return-Path: <kvm+bounces-35528-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB59A12288
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 12:26:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32F7F3A5CA0
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 11:26:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466602135B0;
	Wed, 15 Jan 2025 11:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OhZpL90Q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA01E9910;
	Wed, 15 Jan 2025 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736940408; cv=fail; b=EqrM7Jqmd6I3Xs7q2FnIn/AipFqKUtQiFtwNrTb8Sto5ZqybZXEDomeOzs7r7JidWFzDnKEvelS7WCs57viFHkmdfpbAlSUZKmhRtutt8H4frVLQqbDZ3Z03bT1N5iqxuLJBbrsK65PPjx/uyN6O9tCeCUXyJ5/UJ+L3g8z26WI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736940408; c=relaxed/simple;
	bh=1/XHFVI7qi1k+YwIxrTyDI9BRtQ97cd7s8290g4hSBE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Omx2+v//ud+aex/2UBQk9ycC0HCzT8DIf+TSoF8SLjejtHhPjLRgr+l2ECMvAkiyg+DEv48QxSxYe1+/1PmFyRhKU+3uvhT8k9ZBEg2i96xoONEz+r1OAJoFmMYKXVKIeS7N9ex3lMQRsbCm0v5UKO20mGvu0JYTPvfqIRbxdlg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OhZpL90Q; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736940407; x=1768476407;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1/XHFVI7qi1k+YwIxrTyDI9BRtQ97cd7s8290g4hSBE=;
  b=OhZpL90QfSqQnpVXbQAJolqdINfP4NxaZsLKBalULUQyfOrhPdZ15Ebs
   022/v2YACeHtGkQpNzWEupbKhRvj4RKCTQjAWQoyCCK5XMlzyaGdGwYxn
   KdmfyCToqvPdRebQdlH3ujBepQHZ7PS/wcZ3HXsYoF11v4cI/mmtrcT1t
   5OsRlK/ScfwArdnMATE3ZJZJrD3VIufvOqCa75frp8ZBHygki0yMBzwr/
   AD4860fO8Hrs3GnNihwpY238Hm6NAkb1M7c3hcL8U5/tPfvirWMhafp6G
   70oOrr+vKd+WBoTRWydNVVKbMxqN2/Nx363rDVVcIywV+LFuFsO+Ejvf5
   w==;
X-CSE-ConnectionGUID: nmLfK24STyW36BFgb6v+HA==
X-CSE-MsgGUID: NZKBf/tFTCiNgFADZuyIZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11315"; a="47758270"
X-IronPort-AV: E=Sophos;i="6.12,206,1728975600"; 
   d="scan'208";a="47758270"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2025 03:26:47 -0800
X-CSE-ConnectionGUID: 7HjzwZgjRe27pcIcM6Ighw==
X-CSE-MsgGUID: OWVRLjLzQjWWtWEVfbIdiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="110090435"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jan 2025 03:26:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 15 Jan 2025 03:26:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Wed, 15 Jan 2025 03:26:45 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 15 Jan 2025 03:26:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gIdC36YE+HN4m/tQiYsWhJdDd06EB8Lp5/mQ26GRclbgnUpuqIPUddsHqUo6nP3W+nRwLLXEe0ZurIrXWVoeGERg6nmYL1a8kCD2p8JrVZcbGCKW53+C1w/g2/vSKF8HaFG1CvO5QOHFy4fPjw3aJc7rD/c4CV+ggjE3ELzS5m42sGt1TVKoXbSsWNx7AMv36y5nZdnZWdzsIIcxFy8/yYd++mCh/TUkxrJpMPXP163epT/nBW09Kprxq48KScY7WbNVfGwFgu5ebUOPuHBjbi2gUqnwiTK7pcv1B0+eIJp9tSQyot/d53yc4cNHdnDOxzXoVus3ujlG118bNoUK3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/XHFVI7qi1k+YwIxrTyDI9BRtQ97cd7s8290g4hSBE=;
 b=WX16HMr+KS3w1jHtwSnmQq62LxttYpjy4pmjGtFbls5O/r5SgpYDHStu10ukS/iFYzfHFzyr/0F9lD4bv3b3GQTrnH9x1Mgk5X5I4l0a46Q8dgRYcrNFkl12f6nH2MC7Xn54j0WMXHMIHPJhQfqS3dL2M7LHb4oS0MpMZTaU6lfQpXXE8QQ58kj9M9CejnxwtP6UKkC3wP/GZWBmvBjzsRJc2iKV4eQLHGuYUNDKT3DpofIMikCnEun+L6P/2lzJ1gkMjvXtCyZ+QusvlrwG2oXsiEPUZ9LTCxDpUohPJnweYgzrqqRycwwB0tr+eA5Yk7/7ydOyW3Z8QJPw0xnkqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB6965.namprd11.prod.outlook.com (2603:10b6:806:2bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Wed, 15 Jan
 2025 11:26:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8356.010; Wed, 15 Jan 2025
 11:26:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/18] KVM: TDX: Implement callbacks for MSR operations
Thread-Topic: [PATCH 07/18] KVM: TDX: Implement callbacks for MSR operations
Thread-Index: AQHbSp023vmrBeua3kihPS5EMPwmCLMX62eA
Date: Wed, 15 Jan 2025 11:26:42 +0000
Message-ID: <34ed02a6aedc7dcb35df9ce639e427e4d1a61f72.camel@intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
	 <20241210004946.3718496-8-binbin.wu@linux.intel.com>
In-Reply-To: <20241210004946.3718496-8-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.2 (3.54.2-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB6965:EE_
x-ms-office365-filtering-correlation-id: 6af86b3d-03a6-47c5-f40a-08dd35577c9c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QjVNRm5PRTFidnlHOFFMMllSQnpWSlpLeWpqd0h5WU5CdUswY3lpWXZaUm9Y?=
 =?utf-8?B?MWxmb1JsZVBlS0lvSmp2cENtZUVEdGlTNi9xMFhJYkRucWZPVVd0VUQvd2lu?=
 =?utf-8?B?TVA0QUxzZGR3M3lIR24xcGZncllHdlZjMll5eWxLV3U5bmhSQUptWHpzREpD?=
 =?utf-8?B?NlBpK3Avb1ZnUTBseWlSdFZURnZtL25HbWFucnUvR1VtTkVoYkdjQ3AwQlQz?=
 =?utf-8?B?WGpwRjJPcEExOGMrbHRVdFp6YitlaitBa0srS0xCam5DTjdVUndDVURRb1BP?=
 =?utf-8?B?cThnZ3Fqby90cVcwM0NNZk12MnZrQyttQWU4MHIwVjQ5UlZTZml5bVhyeHMv?=
 =?utf-8?B?NXkwWmlmc3B6UzJwYUdUL1NyU3ZFandWNVk4L01RRlZwQmtEbm1xbGVnMjdS?=
 =?utf-8?B?T3JQK2lMbjBCMWIvenJIaWtsSUhYMzg5WlFCcnVGTUxPVVhoZUx1YkdXR1dK?=
 =?utf-8?B?eFlqSlh2Z2p2dFpoVDErSmdFRXEvWCtLdm1Kd2FBQUt0SngwQ2lkYys0K255?=
 =?utf-8?B?VFhIT3FlTER3clZGeGNLK0JSaHBSL2VBY1hadzBwVmtMZUROcmlNTHcwQXZC?=
 =?utf-8?B?TFE4czZOay90TTlmQUg5dUNuZktCL2FHaEdxM2h0cUhjbEtjYTEvdmxadUYw?=
 =?utf-8?B?eGtGSVlra3g2RGFMdlV1Q1Y2dFVDMFhQdnZycDNaZlVoamd2OTkrZjhKa25E?=
 =?utf-8?B?VVlYdVZiR3o5QWhIRFNsTHpkRVB2bmNSd1VlYzBwRWVuVmxYaXdvVmxXbmVk?=
 =?utf-8?B?S21HdVgwUlJURkl6ajcrL3BseU5SdFVyQnNyRzZMa2J2Zys3dktIcmorZ21P?=
 =?utf-8?B?clAyakdyM0p5WXhjTWZvL1lQYm1Qcm12aXFvUnFvVkxqL1pZbFpMVUJzVVVh?=
 =?utf-8?B?ZE9UVFFwVHZEY0FQQncvL1Vwa2VVOHZPSFZxZ1Z2UGhGZjF6MmR1MkYrc3k5?=
 =?utf-8?B?OTV2cW5NMDlWVUtBR1NHVnFpbTRlN0lMenBWWm1BWUl1NTNZRnE5Z1RzT0dv?=
 =?utf-8?B?OTZVOWNaK3dGM0FOQ3FXNHM4WmsvWTllcy8yRFh0ZWdzbVk3QWVsc2o0NTI1?=
 =?utf-8?B?c051aFFlaW1lNzY4NG0vY24zeElyODV2NDZ0WHp4WXJzWFF0RTRIcFNINTFW?=
 =?utf-8?B?VFU2Q0Z3dGN2N1N6eHhsSFV5QlE2b1lIR2dSd3BpMjB6ZGx4MlMwbklCQ0tY?=
 =?utf-8?B?V0VCV3dKbzFVSzN3Q3N5eHdIUXFKYytzdFE3czA4bmtBRkRwVmQyS3ZMRVkx?=
 =?utf-8?B?RnlXelV6enhZYkZnMlkzS21wMUIvMFRJcWVBMlRnNGRmd1diYVRqc0ZrU2wy?=
 =?utf-8?B?OHVzY3FDdGlNUUdBcEFwQTAyQ0kzNWtaMGlKUWJSWlZKRG9xRHoxc0F1Wm1a?=
 =?utf-8?B?Mmoyem9RRFgzVVRvZmJuZXgxanBMMUJoYy9xNmlFdHZ0djUxczRMUnZGRERi?=
 =?utf-8?B?S3RvR0YvSGxuWG5JUDFJWlJ3NjZXenErTERhbjlaNVhJS2JkZVcvaEhnSjhx?=
 =?utf-8?B?dlVsZzdkOHJsSmxlN3lSRU5jSnVBMFBEdmNNSTcwajFSQXFhdkZ3RkwrMjJn?=
 =?utf-8?B?QVBWa3UxZlZwVzJxNHliUGYyVk1UOTJLV09IbGU0aldhdjRJWU8yS3RHU0ln?=
 =?utf-8?B?Unczb2lRZU9IU015YUR2YXVWTjdRaEhBVVpGZmFhNHEyL3R1cDRPY0IzcWpr?=
 =?utf-8?B?S21qTVY0dXRMWDlzNnQrakxGRGpjYkh5K1E0ZExqWFY2U3RWbWhDbjYxdGhK?=
 =?utf-8?B?RFJyZkFneFViK1dYUzlSUXV2enJQcjZPWWVwbHJ5WWRGQXFIQVVDRzdKTjIw?=
 =?utf-8?B?MFZscWh6V21mMFFrVUtCNXJYam5uWkU5ZDRIS2xPQ1IzQVRGVC81K0NZemNI?=
 =?utf-8?B?dXp2ZjZUOHBDZDlXTWZGcndybXl1dFRub3d3R1FRNmNnSzZmTFYwOThPS090?=
 =?utf-8?Q?pQ7sBO/ibfAx+4JHFJGtEhwgAmzEQLb3?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K3lGQldiVTJHSEhsbW5heVVMZlcxeXVqOTFqMmJGRUhNUm5yZS9OWk8zQUFx?=
 =?utf-8?B?Qk41VjNxOHIxVHVDT2hNUnI5OEJVaFIzVllQb0h1U09ZdiszM001ZjEwcVpH?=
 =?utf-8?B?bzZQS2Fyb1BLSWhkd3N1VW8yMFJzMW5DTVZDM1k2bVptbnJrZlhHeHdGaThW?=
 =?utf-8?B?aTlsdHl4cSttN2d2ZzZJV0pEcVR6UmNWQ2JWT0wvRVUyVXByV1ppWlc5M0ZO?=
 =?utf-8?B?ZSs0Q2UzdHFlai9zb3B5YzlDTVhiTWk0cGJoK3VialY2Mi8vTHJ2anV3S0pG?=
 =?utf-8?B?bjBZazRVZ1k0QWU5ZDBXbFRtVUN5UVYwcDVMZ01xK2g2RXpldHoxbG1lTTdY?=
 =?utf-8?B?ekU3ZWdFb3VZOVpaL2NZU2N0QzlZWXlHMWxhYVdobFJkcVpSUjA5UFZnbGkz?=
 =?utf-8?B?eXVMYWtQeUl5ZlIwSVNhUEE4SWhTU1ljbCsvSHpJQjZIdnQwVmtGSWwvWURw?=
 =?utf-8?B?U3dsOENRTkdDN25uMG9YZUpsL1ExWWsxK1FCNm9UN0lRRHIyWlc4NDE2RWFP?=
 =?utf-8?B?SUgwNlAwWHZlM1BuTmhLV3BhZzBUeGIwSFJVMzQ1MUxaSUgwT1M1SWtFTDdM?=
 =?utf-8?B?cHZmeVhHRFNYNi9ZbjhJZDNOa3Z6NkkyYUt5c1FNeER2aEY4RmZDV3hVQUky?=
 =?utf-8?B?RnNiNEEwOVhaTnRDWTFJVGE2aDBOV0Q4ZUNaYldGUi80TFJvZUxDdTZGeGFL?=
 =?utf-8?B?YzFNVG9NaXhUY1h5OW5EWXNPaXhPYytMYWx6ZG1XOVJERjZlRmh3NnFITkVr?=
 =?utf-8?B?bTlWUURsNU84ZktvNmlIYXNWYTBJSlAxY1EyNUNsWk1XQ3gxWjUzZ0x5NFdE?=
 =?utf-8?B?Z200QmZQVm5jdFA0STlqaGduaS85dDhFOUNSWUFYU05ZUXhLZllxWERUKzlE?=
 =?utf-8?B?d0ozejdRd3VUK0hXSHo1bnd5QmVGTHpoZEJyY1gwZ2wyY1NJWXZJb0hFTENI?=
 =?utf-8?B?WHd1eDNzQWtwd0hmeWdZdkFMKzY2RGJXOG9ITnBUMC92eFVWMVVzRERYL1Zr?=
 =?utf-8?B?VS9UMnpxNENNclkrSjZpalNKcHI1QU01NFJBWjg0WDdlTG5FeWxzaXFURUNn?=
 =?utf-8?B?RTFlYmx5SXZUcFdUWXd4Syt4SG00V09pWThRSTVlMjcxSS9taVh6eHlRREVJ?=
 =?utf-8?B?K3owTmRZbDVCVkhBVklia2c1d1I4emhHeE5rNkMrdW9XMXRRYnFKSXovditt?=
 =?utf-8?B?NHNpenkvanFQZDdXN1c2NHI0MDZIeDlhTk5NTnBhMmI1R3Q0djdXRHMvb1Js?=
 =?utf-8?B?Z0VIRUxXcjN1aFFiblBGWm9JOUg4YWVXVjlhcnh1a2JGNm9OYjVqMHQzUVVz?=
 =?utf-8?B?Tm5KT0dOZ2o5QitFa3B3NzBQUXpaS09Nek5iM01IdUJ1V2l0cGw5VjlRRU8v?=
 =?utf-8?B?d1F3eWo4UTA3SjJPTnBnQmgxbU5CV21qTDRKWlNnZ3h4UWl3aUF4RGVRNTll?=
 =?utf-8?B?bkVJTzBDL2w4RlJpYVF2THdOaUJrb1VWVHZFdkI0ekFBWmE2ejR5dC92RFRN?=
 =?utf-8?B?RkVqYjArMVJSYUswVHhUaVRiSXFsd20vdFI4Q3FxL042Vm4rcDdUZWdPK1RO?=
 =?utf-8?B?NzJGRzNwWEdFekxZU1MrQjdXalJwck1JUkZqWGxid3VPWkd4QVhYcVp0cnN0?=
 =?utf-8?B?UncxN3JpRUlMVVZjdWhPdWw3dndoNEpxeDVacjlUUlh3ZU45SENIUFp0Q2hM?=
 =?utf-8?B?M3QzblNEWW95ZUdKb3AyV3lLemtXcTNLc21MUjE0L1RiWHAvSzhlM0tHd29r?=
 =?utf-8?B?bkNXRHpsblFRMzl1Y1hLdUhLTThzb1hYM0lsZDFwSmljWlAzaDA5QUxseWhz?=
 =?utf-8?B?OTlIeDNJWk5ldENjOTR0NXpXQVEwZjBCN0VYOFVQL2Z2NnZFV1ZBOTZCWHRJ?=
 =?utf-8?B?V1k5QjR6N0NVbEdXaEVSbHFHcCtWS2FxSFZOSTE0RWhPcENzbXVhbjJCTXVB?=
 =?utf-8?B?NU9qR2tEZVlUZEFSa05mWkh0bHl4SGNxZncxVHhXV1JEY21xeHhvdTB0RWJG?=
 =?utf-8?B?VHk2Rm9TOERsdjdwRno5SXJIR1hDanlRWFdUZ3ZKSUlrdWFnTjVubU9WQitw?=
 =?utf-8?B?QkVJYXRMRnNPQXJVaERwZ3ZaRTFmRUhySlpjbGdzQ0dRQXVZRWpNTkxBRHo1?=
 =?utf-8?Q?j9lfG6zpdpNCPxXnR4SfL/3Aw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D62284950635D44B9C241BAF95BCD0A7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6af86b3d-03a6-47c5-f40a-08dd35577c9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2025 11:26:42.5355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: meEzA0cWPQTifSh9o2UrTXAs3/klXUmcCrRz21Douha6cNELNaFJnkJa7I729jI4TXdr/9MvTfh1f6IEpqa7PQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6965
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEyLTEwIGF0IDA4OjQ5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEZy
b206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IA0KPiBBZGQg
ZnVuY3Rpb25zIHRvIGltcGxlbWVudCBNU1IgcmVsYXRlZCBjYWxsYmFja3MsIC5zZXRfbXNyKCks
IC5nZXRfbXNyKCksDQo+IGFuZCAuaGFzX2VtdWxhdGVkX21zcigpLCBmb3IgcHJlcGFyYXRpb24g
b2YgaGFuZGxpbmcgaHlwZXJjYWxscyBmcm9tIFREWA0KPiBndWVzdCBmb3IgcGFyYS12aXJ0dWFs
aXplZCBSRE1TUiBhbmQgV1JNU1IuICBJZ25vcmUgS1ZNX1JFUV9NU1JfRklMVEVSX0NIQU5HRUQN
Cj4gZm9yIFREWC4NCj4gDQo+IFRoZXJlIGFyZSB0aHJlZSBjbGFzc2VzIG9mIE1TUnMgdmlydHVh
bGl6YXRpb24gZm9yIFREWC4NCgkJCSAgICAgXg0KCQkJICAgICBNU1INCg0KPiAtIE5vbi1jb25m
aWd1cmFibGU6IFREWCBtb2R1bGUgZGlyZWN0bHkgdmlydHVhbGl6ZXMgaXQuIFZNTSBjYW4ndCBj
b25maWd1cmUNCj4gICBpdCwgdGhlIHZhbHVlIHNldCBieSBLVk1fU0VUX01TUlMgaXMgaWdub3Jl
ZC4NCj4gLSBDb25maWd1cmFibGU6IFREWCBtb2R1bGUgZGlyZWN0bHkgdmlydHVhbGl6ZXMgaXQu
IFZNTSBjYW4gY29uZmlndXJlIGF0IHRoZQ0KPiAgIFZNIGNyZWF0aW9uIHRpbWUuICBUaGUgdmFs
dWUgc2V0IGJ5IEtWTV9TRVRfTVNSUyBpcyB1c2VkLg0KPiAtICNWRSBjYXNlOiBURFggZ3Vlc3Qg
d291bGQgaXNzdWUgVERHLlZQLlZNQ0FMTDxJTlNUUlVDVElPTi57V1JNU1IsUkRNU1J9Pg0KPiAg
IGFuZCBWTU0gaGFuZGxlcyB0aGUgTVNSIGh5cGVyY2FsbC4gVGhlIHZhbHVlIHNldCBieSBLVk1f
U0VUX01TUlMgaXMgdXNlZC4NCj4gDQo+IEZvciB0aGUgTVNScyBiZWxvbmdpbmcgdG8gdGhlICNW
RSBjYXNlLCB0aGUgVERYIG1vZHVsZSBpbmplY3RzICNWRSB0byB0aGUNCj4gVERYIGd1ZXN0IHVw
b24gUkRNU1Igb3IgV1JNU1IuICBUaGUgZXhhY3QgbGlzdCBvZiBzdWNoIE1TUnMgYXJlIGRlZmlu
ZWQgaW4NCgkJCQkJCQkgICAgICBeDQoJCQkJCQkJICAgICAgaXMNCj4gVERYIE1vZHVsZSBBQkkg
U3BlYy4NCj4gDQo=

