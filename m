Return-Path: <kvm+bounces-30889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3469BE297
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:34:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D80C282CAB
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 09:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AAB41DA10A;
	Wed,  6 Nov 2024 09:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iZgeQeRa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8927A1D27BA
	for <kvm@vger.kernel.org>; Wed,  6 Nov 2024 09:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730885635; cv=fail; b=bkr8BK5Kiyt2/aDPIhFwjFsNdEcaxblmOsM9LKVvx3hzMXo5eZFA2A+nGc86mDSuEzc+1tz6BpuMmcsc0tTDgjkJdL6xLpaMUbTicN2mtzquIXArr43Ivq6oF7Vck1fEMMEYU2mNfw9i4fbUeKtlnzgz7gsVqCNAJYC4nm9iqrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730885635; c=relaxed/simple;
	bh=O/wu6s6D8QtJBtGwGCX8dDmXNmOYYx58L/Xk4Qb5sW8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=W1zq2WjV9srRskvQYNQAab56z6VjHpQOyoXJ+UTGoB2FOM0h2sJM9hqfC3QiuQBghJ8KhZaZoQPDvTETyIy/7Pc07K7uHoo4GD1CURMDfpWH+QNBL6Np0+v2wyPWk0woE305cGb0ev/37IEBi5zS0RhnR5Tna2l8+ymIXFfapvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iZgeQeRa; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730885632; x=1762421632;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O/wu6s6D8QtJBtGwGCX8dDmXNmOYYx58L/Xk4Qb5sW8=;
  b=iZgeQeRaVeBwt6WL5TFutTgBJ4xsUlC8NK6tyyvkCDGZcnpUh/UoJ0aY
   reCaSbwQrLnk/Dg9bWmjmtVpNCOPclJlMjDnP+7M0xpwda+l5GMAmXjgC
   WcQJUFoqPqYpEYRSnHqXEnf1zcn7ilGqEGRzhJt1KEYUHZbQTozIez02i
   AaZ9lUH+SI3desz55p4h9nqvzO/uuA+cwSWZI3lYPnF7AJd6p2VX5Ss0v
   4s7H8JBE7WELaGpbK6snX+Gf06vjqLaFjbMqeUHIlVKqi7fJ/O/VLo/Du
   y3NpX+Sew1bARBzuQx9nmNecwytJ9Fe7aOtfJFcsebfDYm6YA3Rq3WWHS
   w==;
X-CSE-ConnectionGUID: e2pvxmKhRWCqwIdZ/wOcYQ==
X-CSE-MsgGUID: LbCoQ+lRTJmvYZE2G7xqlg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30854073"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30854073"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 01:33:52 -0800
X-CSE-ConnectionGUID: ZRjXLp5BQNi0C0PSpa1IDQ==
X-CSE-MsgGUID: AbQYQE1sSwmsAeX2dUMZlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="83986258"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 01:33:51 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 01:33:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 01:33:50 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 01:33:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WFqHK/2ahfH5KaRckuuCDnz+z9CvHwG6v/D9vMcXYRixDOUPEKDn/J5a4L7vbNYEWOXx71UQNBqpWGLrkwBK8LzAzYacTieJEMmvhQnqJWjcektLiHYyCVsVlv74D992ZS+XlKwrcdOBrQbBwJdNhAU1vVYN2ajYH8VTL6ohlhGimJEbCZCmNelD6MK3vngIUOvpwofmKLAQLql3M3PflX5vcEUggP4JoYm4Q0Trbe3DWMy605H5DgRcpMJ+w6hKlNot22ZYo29Lx0GX1B0ACQnNtVQcoafTgYY91jG1RQjlEj6QU+6M5RKbKFBYg0a4S57t0dOYlQrC3s7w0uVBVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O/wu6s6D8QtJBtGwGCX8dDmXNmOYYx58L/Xk4Qb5sW8=;
 b=X8fgSNPVKtCnyPi9j2YzibxvzlTbCmeGwPDmNyu8XttiG4/PvwHuNWwlo8DRPY6vOOQ1XakTafePBBxPv3Wy/vbiLodXXw38vAHsqTi54rLn8me4EvHdMf0Nh3fj+LnMUlN1KgEgAneP1QfutDYdfi9MMsOjjw3I9rfNpGtcOjWpyXXFeLbcHa3KnD8E3tQKUQ92cGnElCqkUOS01gxOcGVb6f/lb4HfDeDgtcAtu6DIXCI089mL/+j3tjfuvI9ysqVcFOjT4ZE4lWl114cZWtZzFM/v1y/fQc53312nvhqAPSb8o/7bN0CnmStKdq+a+EQFxZZRN3D2CgLeo63oCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Wed, 6 Nov
 2024 09:33:42 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8137.018; Wed, 6 Nov 2024
 09:33:42 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Baolu Lu <baolu.lu@linux.intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"joro@8bytes.org" <joro@8bytes.org>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>, "nicolinc@nvidia.com"
	<nicolinc@nvidia.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "vasant.hegde@amd.com" <vasant.hegde@amd.com>,
	"will@kernel.org" <will@kernel.org>
Subject: RE: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
Thread-Topic: [PATCH v4 05/13] iommu/vt-d: Prepare intel_iommu_set_dev_pasid()
 handle replacement
Thread-Index: AQHbLrwggahcyjOhz0CbdJvK653nqLKp3scQgAAIPYCAAAo2AIAADuKQ
Date: Wed, 6 Nov 2024 09:33:42 +0000
Message-ID: <BN9PR11MB5276CEE6DEA8AC3B3B9334028C532@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-6-yi.l.liu@intel.com>
 <BN9PR11MB52769400A082C0CE51B48EA98C532@BN9PR11MB5276.namprd11.prod.outlook.com>
 <9e00e062-6a05-4658-84fb-1ac5f2502bd9@intel.com>
 <c47a9f3a-cb36-499a-a788-c84a14cb4f48@linux.intel.com>
In-Reply-To: <c47a9f3a-cb36-499a-a788-c84a14cb4f48@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB4952:EE_
x-ms-office365-filtering-correlation-id: 492b437e-a2a0-4018-4c22-08dcfe461a38
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Skh4LzduOVJML2pVYjloM1Vjc3BXZ1NiaUFRRkFHWFRhejh2Z2xObHdhTFVX?=
 =?utf-8?B?VUlDUXNyenk4RE8rbTNQSHl0c2NUWmp2dFVIREUwSXViOU5rNkVrNnlVUWJn?=
 =?utf-8?B?L2NvSVpoWEVOU1hRckZPV1czcHFWYWRLSDNic09RbUE5YlZ6QlVCL1JzamVF?=
 =?utf-8?B?dWZPYm0wbXlKcEd1UE90STRkdzdydW1Gc0dQYndVUTZJS2NGdnpWZ2pGSDlF?=
 =?utf-8?B?VlQvc3ZoWjdrVnRyM2dKK213U05ld2hpaHdYS0FPbTluaG9oZmJleG1UVFE3?=
 =?utf-8?B?L3dlalZRSEQrVnZlOXpHQXNtUHVJVDhkWDdGYVJtZVlUTHJadEVFMnJQTW1v?=
 =?utf-8?B?T2JHVFBHUG05VDBYM0NiK3pzZ1VkaVdVTW1XTVlzU2RNWGtxZEVWV21TbUU1?=
 =?utf-8?B?TTZRVmlCSTBBYS96NXR0dk9UcDNrWDFMc1ZWZGVkNThVN3BxVmdYbkJIUjdD?=
 =?utf-8?B?UHErd01QMDNlamNReXRDNFRnWkxkZHd2MDQ4RVc1NlRWVnZNTmhCdEQ2REpt?=
 =?utf-8?B?eUhxUFpYU05taWhPa1J6UHRGeDBINzFlZ3dyelhGQXFDSHpDV29kNVlqclIz?=
 =?utf-8?B?bmMzQWhUOE1rRFd2SzFyODJsNU5kSkRMTU1UdGNVaFBIRWJ5QkhQbDNUb3Qv?=
 =?utf-8?B?MFZmYzFVdlJ1U0Z6YlJLZ2k3TTdocVBGSjNGTjJldmpsME1FdDgrR0M0c3BJ?=
 =?utf-8?B?UHpIeTk0ZDIyR2kwUWpDK0dJeldjNFRlSDRKM0pTcFFMaG1IajQ5SmNVMU96?=
 =?utf-8?B?RXh5Wk4xRitNTWZDSVRHKzl3Z1hEayt3aWV5QlpyRzhiZEQ2MTdINjVqT1NR?=
 =?utf-8?B?Uno4anV0d25Zakh1UWtBUG5WaTJGN2FvWGhQN3g1V3hSWGJYdE5wS05hcDY2?=
 =?utf-8?B?dnBSMk5OcnBRV2hBY05vVkdwNnVZajdFZ0I0L2hYMXlIM0sra1BMNjBGN001?=
 =?utf-8?B?ck1kK3gwSk81THpoaGo1UEZ1dmJ3N0NQMmZGOE00S1VVUGdiVFRmTFZaQmd1?=
 =?utf-8?B?QlNhbkNWVmpGNzk4VEcwVm5nMEdockpmZEhiTGpZT3RVemdtRm1CZHRoeVR1?=
 =?utf-8?B?YitlUnFjNGRya3prWStSOWJkNjI4S0VVUVMxZGszZDVSQ0lxaStUaDNDcTYr?=
 =?utf-8?B?MGFNNjdlcHE5QVVuTVNZM0UrRGVMRzFPTHNwOTdrbTU3emRYbFdGVExnMU9R?=
 =?utf-8?B?NS9UTzNCRjl1MHNNSHVkZTZJamJ2R1J3d0NtTWxwd1VXempKcDdVUXR6cTBO?=
 =?utf-8?B?NkZDTFgwZWhSNS9ObXhTVUlwNDdsZ1JCbnRDL1J5MHdqSEZXdDFmbUszUXBs?=
 =?utf-8?B?VktzLzZCYUhiWVVSY3ErZEc1YTkvM1JINit5d0V5cG1Oc1MxZkRHVWhYdW9L?=
 =?utf-8?B?WXJUV3RQTjJjOXlRZnYyY3J0YmVJUmsza0VZQjIwZ2VzUFZEcUxWejlmLzVM?=
 =?utf-8?B?a3ZGL3BLamV6Z1lvQ1pLRW1kaEdGWCtzUFNKUEFmYzBtaklKZHpqVFNoOVR6?=
 =?utf-8?B?b2tNL0I3TGg3SEZwTUJoNCtxWDZaVVdYTEErSXVpUDJZUDJ0MmQrUmp1ZjM3?=
 =?utf-8?B?aVYzR0I4OEcvMUxXUzExak1LSmYrZUdUSER1cy9jUitmNVhOSFZwUHZ5aTJj?=
 =?utf-8?B?Tm4yM3haOVl0Zm9TbGRyWkJiR00xQWM0ZXVZNzhDZ0pxeGVzZEhnZW5ZQjMz?=
 =?utf-8?B?TGRWWTB2aWI4dmQwRDVtazdVNVZCVjdQcC81WmhMZ05peWthUWZsZWdQTFdZ?=
 =?utf-8?B?bUFFMFVYb2RDQW1GbkxWS3hPMXRhRlV5MDJtbUdnWkNkOFg1U2VWeCtxc1Ny?=
 =?utf-8?Q?RnzqG+c27XGB/uvEoi/MUg3S0FOrM2cseI6Lw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?azBtTzFxTUE1R2RVcWJURUtpakpybjJFaUFhQlU0R3NXanNucnpYZllBSzlz?=
 =?utf-8?B?OW1BNTBmd3FqellYOVV5NXRLMnE2K08xY05yNjhBUitESDB1MFNTMkxGbzhp?=
 =?utf-8?B?OUREWklOV2N2LytDd0tJMjN3L1VTSnl6Smg1T2xiNTR0OExnM2swZlVmcXY1?=
 =?utf-8?B?MkxnQm1DZVdqUWtGMGcwYkxVMGppcXJkWWs2WVpYWlpGY2FWL2xiM2pPTjdY?=
 =?utf-8?B?cW1xdzJLS0N5TVplNWczRXZWUmN5SEdxZkJVL3h3a3JtTm55RksweDFERlNr?=
 =?utf-8?B?a0NnZUJBTld0RDdPSEZlSVAxcmR6R0FEQ20yeGNrSHdCeHV1VTV3N2w3UXQ1?=
 =?utf-8?B?RWlTWFljZzJ6WGVPeHVoaFd6SEVoQ0F6c1ZHbGhHMytPK3dJaHVsUktBTkJ6?=
 =?utf-8?B?VGNGNlZ3cmVsOVVscmE1aWNkSGRMZnIwNFVUdnNOQ0QvNFhTdWtEb045OXNw?=
 =?utf-8?B?M3hJWkdqTEVaSEJhSzB3YkIvRGhzVTB4SGcvb3NCZURrcEtxQWt5OUFhaW9X?=
 =?utf-8?B?OVhudUVKYU0rR0Y5S1ZmeEYxWFFsM3FSUEZseEFyeUgrcjdrWnYyaUZnL09Q?=
 =?utf-8?B?bU13NWFmRVhYcVgwcksvdkEza3J2cWFPUlBOLzREOXlyQlhCZzdXMTFOQ0pU?=
 =?utf-8?B?Vkc1V0wrZWdvR3dpbE1iUE93TmRaN0ZUeW04RG5oNks2RSszWCtKcit4ZWU0?=
 =?utf-8?B?QlNSWDR0emFuS2Y4Z3ZDRFRzU09uM000YlF1ejhmbTd5YUFSbzE2V1p3cXBt?=
 =?utf-8?B?YldyaHJIa241WDByc3NsQ1d3NUVGN2h4bjhTcHI2eUFsRU1yUnRJK3p2Kzh6?=
 =?utf-8?B?VC80c1NzZU5yU3kyN3VGV0x6WDg0aUZtT0RHelhoa0xNVTk3SnlmMWdFYUV3?=
 =?utf-8?B?UkhHVHdlWC8xRFZuTUF2Slo5ZW1oYUNXNnhKUHFKakZxcEhPZmlkeGpmU243?=
 =?utf-8?B?dWszWHhlZVhQbmJybGx2Q1NVMGczN3MrV3hZVko4UG5aN2dMUHNRbjFFZUxy?=
 =?utf-8?B?LzlvUGtCYThqMXFaVGE5VU1Mc2IzbTUwck1hWXhXT0twYlBNYzFJa1B4NGJq?=
 =?utf-8?B?alFCdzZZWXZnVCt2QjVpb0xmS0cyL1IreVlnQjZOUG1yUzI2cUxtQ2xkeXdw?=
 =?utf-8?B?QU1NdG00UmhlZE9GNlhNVWtIekhwYU93VmF0SjV6VHhWQXdaWmJ3c1krUEZk?=
 =?utf-8?B?Snc2QWJTallGZU5FWUFrQzdKSXRjZ3hFNlpSckYrUkxmeXZnaHFHR1U2cnlR?=
 =?utf-8?B?TG1qcUpodGE2U2I2VXl2bXdTdG1vSldZcFQ2bzJZZzFHcmxXdmljcDRWV1Nl?=
 =?utf-8?B?MjI0WC84cDZycUM5bTJBZ0RzaU9yc3FpbmR4OXhpZWFxVks3WGpKQnI3a1RH?=
 =?utf-8?B?MGw5RlJUWTRSWEd4aVM0d2VVMStGN1A2QWFFMGZuaVJyQm1rdm8zYXBId0Qv?=
 =?utf-8?B?emY0ajIxRk5LQUoyY2FnREx1b1E2N3ZhNUpvdzZuMGUrb29HUFJuR2NmZzJW?=
 =?utf-8?B?S24wL29DZDhvakdvdjFydkhVd1ZCL05TY2U0ekN1bUNPaFY1aHZqaFAzaS9v?=
 =?utf-8?B?RkIxbjdTSmU5Wm56SjVRbVZQMHZZTnQySWxGSVNnVlNNVk4xZFhXbm4xenQ4?=
 =?utf-8?B?SzF6VXhlSkc4dnJHWlc1WGZDUkt0MzFpOU1CbGRNZXE3RFNYOVE2bDIyOWpB?=
 =?utf-8?B?b2JUdFVVaEdadk1QT3BRWXBFbVJNRllmRURQUGZ6b3FuY2JQVkd1eTVhYUZC?=
 =?utf-8?B?RndRdTRTQ1RvYU0veWFvejNTUUpIWC9oQTZ6a0FackgzUklzU3lkRWtTbnhM?=
 =?utf-8?B?djc5UnZCZVpZdkZVWWtHbXlUMFo3Z2NTdWxrMU1adFFHT1JkR1hVaGtPMGZG?=
 =?utf-8?B?dHErYmJJM1E2VmFpOGNMWmh1cS9WQm5YT1RyaGhnbCtaTjBuZDBrVG1aK2JJ?=
 =?utf-8?B?VzYwTnIway9HVFJyMTNHVUwzb3E1NWhtdjFtdzFyR0plL3RIMTl3eHhURCtF?=
 =?utf-8?B?U0YxdlBpSmdya2NsMlR0RGVQdWMvZFJwL01qaHhVbDA2MUtNZFJvdmtWRDhN?=
 =?utf-8?B?Z3p4emFmMkgrSlJpcTREa2lZSXZSMnREbGFUcC9xYU43eXRrcVFtMThjdTUx?=
 =?utf-8?Q?aTvQpB3A4PiUuFbv+GXsvUSbq?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 492b437e-a2a0-4018-4c22-08dcfe461a38
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 09:33:42.0633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GsK9o3KaUensA9yv4kX8z4m3HltmEaY7lPMMpVzKd8pjYUWuJEwAaklHGI0he+5mR2jk/95La9cLzRGr/crZ6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4952
X-OriginatorOrg: intel.com

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBXZWRu
ZXNkYXksIE5vdmVtYmVyIDYsIDIwMjQgNDozOSBQTQ0KPiANCj4gT24gMjAyNC8xMS82IDE2OjAy
LCBZaSBMaXUgd3JvdGU6DQo+ID4+PiBAQCAtNDMyOSwyNCArNDM2OCwxNyBAQCBzdGF0aWMgaW50
IGludGVsX2lvbW11X3NldF9kZXZfcGFzaWQoc3RydWN0DQo+ID4+PiBpb21tdV9kb21haW4gKmRv
bWFpbiwNCj4gPj4+IMKgwqDCoMKgwqDCoMKgwqDCoCByZXQgPSBpbnRlbF9wYXNpZF9zZXR1cF9z
ZWNvbmRfbGV2ZWwoaW9tbXUsIGRtYXJfZG9tYWluLA0KPiA+Pj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGRldiwgcGFzaWQpOw0K
PiA+Pj4gwqDCoMKgwqDCoCBpZiAocmV0KQ0KPiA+Pj4gLcKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0
X3VuYXNzaWduX3RhZzsNCj4gPj4+ICvCoMKgwqDCoMKgwqDCoCBnb3RvIG91dF9yZW1vdmVfZGV2
X3Bhc2lkOw0KPiA+Pj4NCj4gPj4+IC3CoMKgwqAgZGV2X3Bhc2lkLT5kZXYgPSBkZXY7DQo+ID4+
PiAtwqDCoMKgIGRldl9wYXNpZC0+cGFzaWQgPSBwYXNpZDsNCj4gPj4+IC3CoMKgwqAgc3Bpbl9s
b2NrX2lycXNhdmUoJmRtYXJfZG9tYWluLT5sb2NrLCBmbGFncyk7DQo+ID4+PiAtwqDCoMKgIGxp
c3RfYWRkKCZkZXZfcGFzaWQtPmxpbmtfZG9tYWluLCAmZG1hcl9kb21haW4tPmRldl9wYXNpZHMp
Ow0KPiA+Pj4gLcKgwqDCoCBzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkbWFyX2RvbWFpbi0+bG9j
aywgZmxhZ3MpOw0KPiA+Pj4gK8KgwqDCoCBkb21haW5fcmVtb3ZlX2Rldl9wYXNpZChvbGQsIGRl
diwgcGFzaWQpOw0KPiA+Pg0KPiA+PiBNeSBwcmVmZXJlbmNlIGlzIG1vdmluZyB0aGUgY2hlY2sg
b2Ygbm9uLU5VTEwgb2xkIG91dCBoZXJlLg0KPiA+DQo+ID4gQEJhb2x1LCBob3cgYWJvdXQgeW91
ciB0aG91Z2h0Pw0KPiANCj4gSWYgd2UgbW92ZSB0aGUgY2hlY2sgb3V0IG9mIHRoaXMgaGVscGVy
LCB0aGVyZSB3aWxsIGJlIGJvaWxlcnBsYXRlIGNvZGUNCj4gaW4gbXVsdGlwbGUgcGxhY2VzLiBT
b21ldGhpbmcgbGlrZSwNCj4gDQo+IAlpZiAob2xkKQ0KPiAJCWRvbWFpbl9yZW1vdmVfZGV2X3Bh
c2lkKG9sZCwgZGV2LCBwYXNpZCk7DQo+IA0KDQp5ZXMsIGJ1dCB0aGUgbG9naWMgaXMgc2xpZ2h0
bHkgY2xlYXJlciB0byByZWZsZWN0IGEgcmVwbGFjZSBvcGVyYXRpb24NCmluIHRoZSBjYWxsZXIg
c2lkZSBpbnN0ZWFkIG9mIHByZXRlbmRpbmcgaXQgdG8gYmUgYSBtYW5kYXRvcnkgb25lLg0K

