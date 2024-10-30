Return-Path: <kvm+bounces-30118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5817A9B700D
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 23:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D135D1F22188
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 22:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B805621745A;
	Wed, 30 Oct 2024 22:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y6Pl+gNH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9581CF5E0;
	Wed, 30 Oct 2024 22:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730328787; cv=fail; b=AawpVOvWCWVeWxeql0ZZMwESYQIon9SMQVz5R15ic2O1DTkXNljJ4dIdlfuxczCOvJcUllG6J6SBfziTDTKNELlzA4e9T96EoJ/lJ0URsCgb7GrtoTz9/LBFhSka5o3k7v/6uKXeCr+VwQSvOCCEzqul6rhIon0JLc6tA/8P2Uo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730328787; c=relaxed/simple;
	bh=4/OisKpTGjy4hCDb/WOnXVFRlJuUkLFzMgCNfeWUNTo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=DACNrwriC1Dfq3wmItdwooKtSPjxB1mZ7kWHKrmL2QYA917G0HnDqHH+Yqi5J4EDg+ZiMJAVre4ADTDmoiHgmJmzh2bBi4ydAEKkLKb5xIeDqcdeCHRei0X6CVHtsvm43rG5flVa8UzNVwz+aroOrZ5VjpaK+T3NPDph/EK5De0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y6Pl+gNH; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730328785; x=1761864785;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4/OisKpTGjy4hCDb/WOnXVFRlJuUkLFzMgCNfeWUNTo=;
  b=Y6Pl+gNHrDH9AuG/gCkxRh1ZfhpGah2+9NSosKh5gAwuP114en+kUfPo
   CLlmd63K3fjAd8WVNDHitwpCBaVXJflMgVQCVBeAwD4upcoCIECiBrBfQ
   ildJP6scTnm5DC82pIj6X+K3LR3uG65D+6Hcr8yhJ9BxbU5DRAeMghgOl
   p831fjquDHUH/juvWNIAhIsqhTqqNKEz7SwBr/4zNnNSGYemL1HJPkzo6
   vqqmhZFCZGHD33nI1fHrTEWi0rKRBKvSzbCrBQyYSLLGcPg79ffdYw3/R
   03msWDYQZ3YHLnZkS4w+8DJUxYH6yGDioISa1cH6C+Cy87Bd+LDu+EVUb
   Q==;
X-CSE-ConnectionGUID: jEvvNxFTTIWBBD6VHEihYQ==
X-CSE-MsgGUID: X4rv1/RPQJ+M1YmX4RcoIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="40589429"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="40589429"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 15:53:05 -0700
X-CSE-ConnectionGUID: nmP5n9t9TLmt1pri7w5Cqg==
X-CSE-MsgGUID: jIDYT+vNQDa5wHHsATrlHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="81999359"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 15:53:04 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 15:53:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 15:53:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 15:53:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VhSEIkM0PDkzcUtiglpbqG6VFCvM3DhRCcKTi7b/IMa47mXjCbevTCJRANeKMSW7CoYv0FXyFgX8CFkoZuwt4J2mWWPC6iTf66TUhZP3wDBXeydG/r1n9Wtb7yykTtq5Xm78o+JmmtmnPIIKzTibfpGkgezThAjUlSi9HjqQjxSWk6NU1zejkBExixw/wbsoUvJiaSbPRotep3woUTL76PtKEPX/0ZPdIzdkn/IXw55eL2exkRM7lNMLCNibuINBsWMI4u3Szaqc9oZaGSXaYj5LpJ+l9HFKm6u2jUVpYzFyIr3lGcBqjiEu0VocmCKElIUHrA83/UnXsk5cVFxl6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4/OisKpTGjy4hCDb/WOnXVFRlJuUkLFzMgCNfeWUNTo=;
 b=JvUx19WkbHLKZ6NCxJIeipHsn45f237vd18eIPT6VSsREgWA2W9/gQMQKBi/vkWhR+JH8MtPIcpqHUx3mzmf07245cXN+WeP4Bknuysaf1JadVYcH4BntfCe553U7XthMXtSECHx9fWIEdwih+KdT8nNnn442d4ddkb+fVUttRY0CbuN7Lr7UKyy1lG8DDPp1xoMXw8/HAJR9sfIzbXZJ0d/4XYOKUsA1g4+71wkyoDyo7DoJ7mMnLh4190PDDSFUGpz020isMezbZbtnBOHBbOLO7kp+l6jNT9fYTEPbYhQXT8Vswsa0iqClemUNc1yxJSjKrRJOgEOGjAsMZhcBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7408.namprd11.prod.outlook.com (2603:10b6:8:136::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.20; Wed, 30 Oct
 2024 22:53:01 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 22:53:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 12/25] KVM: TDX: Define TDX architectural definitions
Thread-Topic: [PATCH v2 12/25] KVM: TDX: Define TDX architectural definitions
Thread-Index: AQHbKv4rkwOWaJyVUkmgVUvire2auLKf4ueAgAAEC4A=
Date: Wed, 30 Oct 2024 22:53:01 +0000
Message-ID: <15011d0beeaf690880ca1abe5f730a815bd4c7e0.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-13-rick.p.edgecombe@intel.com>
	 <25bf543723a176bf910f27ede288f3d20f20aed1.camel@intel.com>
In-Reply-To: <25bf543723a176bf910f27ede288f3d20f20aed1.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7408:EE_
x-ms-office365-filtering-correlation-id: 8bdf5031-4706-4adb-6753-08dcf9359b70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VzVpNTREOHBFYTYyRllqU0dCOGV5T2N3QzQwUXdzbE9oSElHMWcwa0NjdU1y?=
 =?utf-8?B?ZU5JSHB3RDluZ2FKOHVIbjZGc1Z2bDN4SFdXUWdRcFdmWFFrT1RocXRRVnUz?=
 =?utf-8?B?a2tiNkF3YkxwdzF5WFUvMmw0TC9jaVN4L3ZGMzJxdTFXSE1ONmJrdmliVEpK?=
 =?utf-8?B?dHBybWVKZ3l2VS9RVGx6VktlWmlGV29Dampta3RLY0plaTlzd0xEaWprY1B1?=
 =?utf-8?B?UnorUFZnNkZBamNEcExST3MrUkdMRnRuRUpOQVhWU0k3MkhJZmFLNEtydDlq?=
 =?utf-8?B?MytQUDZ3QkNLSEpwYkxoN2JSY1dMSjVvcDZQbElEbmQ5ZmlVU21md29PTUUv?=
 =?utf-8?B?MHJYelY1T0ZONlA4TEZJV1Z6UzQwM0ZpZjhYY1F1aEc2MGJhb2wzNXdISVo2?=
 =?utf-8?B?dFhFYUtSbG1YK2JHbVFGMnBuT25NclUrU3AzajNFYkN4U2d2MmNjYjFmeFlS?=
 =?utf-8?B?UUVpSXBRRmRxWDhWcnNuZ3NldElLOHdKSWFJbU52eTlEMHp4NjVQc2pndDkx?=
 =?utf-8?B?UndpdkphVnB6a2NITk5YSEgwMWdUSjVEVGVKOGNETlRhUW0zVUw3bGJUV3pi?=
 =?utf-8?B?NFpXa2tHZ0UzMzZaUDFiMlUzbFV3VWJPVVZmVlpHYjgwODNpZUgvSG13UThH?=
 =?utf-8?B?QzhBd1U3ZWljN3dHRGVuOFdSSFJnKzZRQ2E1cmZCMWZDMnN3NHlRMlJvenE2?=
 =?utf-8?B?aGFpSm5UREtBOUxXbFU2UllGYnFaaU16bFVsOUxNdFRoU2JlT3lPbmF2aVBr?=
 =?utf-8?B?elMxZnRaZzhnMXFiSG5PM1JtR01nV2RncjlROU1jUzBYOFc1dWtxblZHaE9l?=
 =?utf-8?B?THIrWTJ4OE5QV3lqVHdYYkFoRUZkVXJHVEk0YlRuYXFIUWxTWnpVd2t3cXJK?=
 =?utf-8?B?YU10bFlmeEl5aU5DT2o5UFMyUVZkUlU1b1ZROWtuekM4d3dueE5BdHowQ3lE?=
 =?utf-8?B?cDVGM1VkYy9zaFBPbUtQOGxrcFZoeWVKUEt2RTZIbk9pVFpQM0VtSjE1d1NV?=
 =?utf-8?B?SWQySHpYR0dsOERGR1Z1QTA4QVR2eHZROU8zYTdMS3MxUDZhNFVRdmMyWTE4?=
 =?utf-8?B?VjRubytwRzA0UkdnaHk3NlBTa2xTVjNWM2h6WDB3OTExWkVwaGxBNHMrTUZH?=
 =?utf-8?B?eFErdWpGL0w5TXdEOCsyMG8yK1JGMWpaa3pMSTVxaFozNUtkdmpYQkJuenkz?=
 =?utf-8?B?OTl3RDdRaGlmVjUzTjNqMnR1VlB6eHVLejBmV0w1K1ZEVVVUUTFiai9kSnQx?=
 =?utf-8?B?cGZYVGZvc3MwOE8rdXE3NWJ6Vm5tSVU1VXkyeEhqejlTZnF0OGlINFFoei90?=
 =?utf-8?B?UEkxQld4S1ZlZlFRVlhQRzdjbXNmckdwVVNlUmdobE9INklYWEcvUXZybjZv?=
 =?utf-8?B?VDgyc05GYjBzamkrazdVZXlqUXd1N2xLalRrR1hYNlJkVFRhZk9tUld0YzNM?=
 =?utf-8?B?dkZSOHo2WHdvTEVabDd3dVBidE5IQnV2ajVzT3JERDU3NlZHMWVPT0hlTFZI?=
 =?utf-8?B?MXdMdzNvKzRudUU3TDhlampSTmNSNkFzbDhBY2ZoTldkQXJTZDNXTzRUNmZn?=
 =?utf-8?B?d2dYUWFoWUpEQVU4WGJxdnAwM05SZExuU3k4bjF4L3BncmJ2UVdlWHVBcEVy?=
 =?utf-8?B?K1ZSM0pxMW44ODI4ZjRpMHRrRnlpNEk1bGExR2RaNXVjQk4xWm9ydkIxSzJr?=
 =?utf-8?B?MUxSSU41VzhhWGcrVHN1M2lRcWgrOW1FQTZTczdPN1dBcVJWN2UrUmlwWloz?=
 =?utf-8?B?NnhSdHovWHlOb1BpWFJWSENWcXZuWHplWE40bnIxNTIrVGNFdWY1NmhHRWdK?=
 =?utf-8?Q?FIRrE8HrjjkJPMxgmdaK76F0z63vBpuZDGYog=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFNUMThUZC9lTzQydzc1UTdrUENhazdXcmFBdENsNXY2eUFXb1piTXJDN2Jx?=
 =?utf-8?B?cXh4bk05WmJOMm41U2dKdjdqNCs2NXY3bkhsSlphOFkwYzI2cVdBamxFWlBJ?=
 =?utf-8?B?YTlid0hxOHZvR1cvUnFhSzF6Z0l2RDlYRlNKdW9jc0lNVnFEUWFZWUZNMUla?=
 =?utf-8?B?QUpsaWFtZFkvemMwaloyQUM2dHYzRC9vNktwT3JpM1hOVVhXc29wTEs4UVo5?=
 =?utf-8?B?VFV5a21UV2duVFl5Y3daNHNna2NFc3RZQ3JpZnZsYXVTT1RvQ0JyTjZQWVlB?=
 =?utf-8?B?b0R2L2h1eFdDbjRmS2RzNUF6dUNVTVdMTkFNR25WNWlTTThIY3RCMkpQNTVm?=
 =?utf-8?B?Q1g0Nm5NN2NUMS8vejdqT2xybjYzQVFwUjlIZTlZRmR6clYwazBSZ25sSnZo?=
 =?utf-8?B?ajJPUWUyNHc4TXM4Q2VWbzlmK0UrV1hNcFgycmhyL0lhNlhzMXFxZU04d0E3?=
 =?utf-8?B?VXpzSnE4N2Z0cEIweU9LNW1OdTlaYUpCSmQyQ2l0QlBIZkVnRHZFTnU2UWFE?=
 =?utf-8?B?YXE5Q2s0Tm1IZ2tvbWpwWG5FMkZCTGhNdldSbFp6eStMWXlKbUdYckFoUVZW?=
 =?utf-8?B?c3E4UnkwdHBvSEZGeUM0QjhpNkdUWWVDVW8xbk5JazhqWmdMR3ErVUtwOHJu?=
 =?utf-8?B?UDE2aGlndzhRZzRRWVVLUndwd1p1em1GUnBIaTN2em1uRmZRRU9YRGhoL0RJ?=
 =?utf-8?B?cVpabm1CaVg5cVZMcGtoOWlYUk1aUVZSL01mZllwS0s1N1FKUGJZclNoZU50?=
 =?utf-8?B?THp6TXNtTnlHbS9IRWV2MTZ2MzlXNEM2YUtrZkUwZVdCMUkyZjFXalFjbktX?=
 =?utf-8?B?K1VEWHQzaDRKbWdxeHN4a2NVVkwvN2t0c1pycGVJdjhPb1BUbG53VTJJdEdx?=
 =?utf-8?B?YWtmTTAvbURSeWhtUmRMOTM3aGtJU2Yva3BSZ1BQZTlSZTJwSFU0d2h0QlJ5?=
 =?utf-8?B?V09mVmh0dGZsYXo5WlZoUHVLYWVQVG5wblI3NlZKL0hzaTdGT1FqN1FuaGR0?=
 =?utf-8?B?YnFQcHI4RnV2eFVTZGhGYTV1dVBveFl5UEFreEVwNXNxaFFZQ0lnemtQSytl?=
 =?utf-8?B?R2FHRytmeUVWM3dVMjVlbEk0UFQ3UUhDaEZ2eGNaSXF1QmtSbUVWSlVHMC8y?=
 =?utf-8?B?T2hhOXZJRTJDRDcrT3RHN2x0ZU1XR2poTyt2ZktaSERuOWlFTFdhL3U1cVBN?=
 =?utf-8?B?T0Y4dUVjUWhXeDE0K2kwcFhaOE5QQ09OMjVqR2VXMlhnSzFLUXlYQ3FoRVd6?=
 =?utf-8?B?WGx3U3VJb2RpdEc1MUVyeHh5cUpWaUZoL3Fod2hwOXpDUlZNeEQrbVJGRmhN?=
 =?utf-8?B?blduUzczeTBmZldjaVdxbjJXMzEwcy9zK01rV2NpVGlNbmJZY01IYURDTDN5?=
 =?utf-8?B?d1h4clVRNm1xc0RRZTNDK2dKaEp1RkNBKzY0eHA1eHJRaU1KV1p0RWZNbEc5?=
 =?utf-8?B?WStNYVJuSXQ0dDVuMXVOSnFvYjdtL2V6NTB1bTlyQkVMeXlYREUrZkZmc2J2?=
 =?utf-8?B?bnNDY0I2aDA2Y3pYb296eTNXamN6SFRHeS9WdnFlM05sM3VrSE9qc0hSTEpL?=
 =?utf-8?B?U29GcFJlWW53OG0vUWVvbWpUZWtFVlNVUWd4ZFZJd2JaaFh4NFBlaVhxNW10?=
 =?utf-8?B?VHBIWS9UQkd3Z1Fsb1ZIUS9PbExweGdaa1dNVUZDNkdndGxMT0pJaVd0WTU3?=
 =?utf-8?B?eHV3elJwUnIvaW5nVE9vQU9LVzVaeG5hekxyMkxYek5LRG1pNStrU2t4Ymw1?=
 =?utf-8?B?dUI3WHFjOW9qSVR5SW8wM0dKZCtPZHFySk5icnR4dUk3MW9QMHVCS3E5OWM2?=
 =?utf-8?B?R240NUM1b0xBZHNLS3VPWVJFWFVCWThtOFgrOU5YOGdsdFlaeW5MNHpsSDdR?=
 =?utf-8?B?c2pwL01GaHV4elpRUHJaMVh6TW1GZHVVYXFvVWlMcFdlRnArTDRmNzdVRlJs?=
 =?utf-8?B?ZDlTK2ZSeDZRZGNVQmh6bG9zeGRDckt6RGlFUVZXdjUzbWpZOE9LY1FybndJ?=
 =?utf-8?B?ZU9Rb1I5U285ZzdieWdXNitoSE5sOU85dnlsRHVwODQ3STJPNzFLWERvbFox?=
 =?utf-8?B?ZnBWZnE3SjBJT3prazV3RmE5WGhzRUhtZVF2MmxFOEdWZnFwdlBNclNHem50?=
 =?utf-8?Q?xKbutuIQnaqQ3rf1xiNCtLZvp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <03C27488D4BE144883197B642A0B32EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bdf5031-4706-4adb-6753-08dcf9359b70
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2024 22:53:01.5778
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /EMqF6UrRrjd96MSNdqmk1UkLdTGf4A3kEBggg2fW58DqVW71E643dpcUE7pGq5Zeaw5t2HwlC3P7KtH8BbgQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7408
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTEwLTMwIGF0IDIyOjM4ICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICsjaW5jbHVkZSA8bGludXgvdHlwZXMuaD4NCj4gPiArDQo+ID4gKyNkZWZpbmUgVERYX1ZFUlNJ
T05fU0hJRlQJCTE2DQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBURFggU0VBTUNBTEwgQVBJIGZ1
bmN0aW9uIGxlYXZlcw0KPiA+ICsgKi8NCj4gPiArI2RlZmluZSBUREhfVlBfRU5URVIJCQkwDQo+
ID4gKyNkZWZpbmUgVERIX01OR19BRERDWAkJCTENCj4gPiArI2RlZmluZSBUREhfTUVNX1BBR0Vf
QURECQkyDQo+ID4gKyNkZWZpbmUgVERIX01FTV9TRVBUX0FERAkJMw0KPiA+ICsjZGVmaW5lIFRE
SF9WUF9BRERDWAkJCTQNCj4gPiArI2RlZmluZSBUREhfTUVNX1BBR0VfQVVHCQk2DQo+ID4gKyNk
ZWZpbmUgVERIX01FTV9SQU5HRV9CTE9DSwkJNw0KPiA+ICsjZGVmaW5lIFRESF9NTkdfS0VZX0NP
TkZJRwkJOA0KPiA+ICsjZGVmaW5lIFRESF9NTkdfQ1JFQVRFCQkJOQ0KPiA+ICsjZGVmaW5lIFRE
SF9WUF9DUkVBVEUJCQkxMA0KPiA+ICsjZGVmaW5lIFRESF9NTkdfUkQJCQkxMQ0KPiA+ICsjZGVm
aW5lIFRESF9NUl9FWFRFTkQJCQkxNg0KPiA+ICsjZGVmaW5lIFRESF9NUl9GSU5BTElaRQkJCTE3
DQo+ID4gKyNkZWZpbmUgVERIX1ZQX0ZMVVNICQkJMTgNCj4gPiArI2RlZmluZSBUREhfTU5HX1ZQ
RkxVU0hET05FCQkxOQ0KPiA+ICsjZGVmaW5lIFRESF9NTkdfS0VZX0ZSRUVJRAkJMjANCj4gPiAr
I2RlZmluZSBUREhfTU5HX0lOSVQJCQkyMQ0KPiA+ICsjZGVmaW5lIFRESF9WUF9JTklUCQkJMjIN
Cj4gPiArI2RlZmluZSBUREhfVlBfUkQJCQkyNg0KPiA+ICsjZGVmaW5lIFRESF9NTkdfS0VZX1JF
Q0xBSU1JRAkJMjcNCj4gPiArI2RlZmluZSBUREhfUEhZTUVNX1BBR0VfUkVDTEFJTQkJMjgNCj4g
PiArI2RlZmluZSBUREhfTUVNX1BBR0VfUkVNT1ZFCQkyOQ0KPiA+ICsjZGVmaW5lIFRESF9NRU1f
U0VQVF9SRU1PVkUJCTMwDQo+ID4gKyNkZWZpbmUgVERIX1NZU19SRAkJCTM0DQo+ID4gKyNkZWZp
bmUgVERIX01FTV9UUkFDSwkJCTM4DQo+ID4gKyNkZWZpbmUgVERIX01FTV9SQU5HRV9VTkJMT0NL
CQkzOQ0KPiA+ICsjZGVmaW5lIFRESF9QSFlNRU1fQ0FDSEVfV0IJCTQwDQo+ID4gKyNkZWZpbmUg
VERIX1BIWU1FTV9QQUdFX1dCSU5WRAkJNDENCj4gPiArI2RlZmluZSBUREhfVlBfV1IJCQk0Mw0K
PiANCj4gVGhvc2UgYXJlIG5vdCBuZWVkZWQgYW55bW9yZSBnaXZlbiB0aGUgeDg2IGNvcmUgaXMg
ZXhwb3J0aW5nIGFsbCBLVk0tbmVlZGVkDQo+IFNFQU1DQUxMIHdyYXBwZXJzLg0KPiANCg0KVG8g
Y2xhcmlmeSBJIG1lYW50IGFsbCB0aG9zZSBtYWNyb3MgZm9yIFNFQU1DQUxMIGxlYWZzIGFyZSBu
b3QgbmVlZGVkLiAgU29ycnkgaW4NCnRoZSBhYm92ZSByZXBseSBJIG1pc3Rha2VubHkgcXVvdGVk
IHRoZSAiI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+IiB3aGljaCBzaG91bGQNCnN0aWxsIGJlIGtl
cHQgb2J2aW91c2x5Lg0K

