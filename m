Return-Path: <kvm+bounces-14479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 090408A2AB8
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:16:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BB301F22554
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F3C7502AA;
	Fri, 12 Apr 2024 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FukpbDhM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD1F1EEF8;
	Fri, 12 Apr 2024 09:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712913392; cv=fail; b=Gu1hq5YyJ3deRcv9KfrOFSY45IYUa0sr3ookZqH9Rsrrx6gPmBD+DWm5TNn6vkjClq9t7RsFo7+C+5zauLW6LLRLd2jlD3CtrWK6f1HxdROltce7B40jVn3QyAPi+6XyJKEXlTIqB+zDUXVADoSTYU8QV83MlIbcYa0b5B92P9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712913392; c=relaxed/simple;
	bh=lXURzvpQy6x1/H3hzQqOVbcm6LBqWWnXyPji6UC27bM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ITmGyGuPdaQmJW6RTm7fvsEJyTlmWRu/Fm+oTUiQzi40CILKFgxeuN5GILYN+c7YaWkClcakjx6lbJsLzKILrOo78EdvddtmHYqUAJm1BeRg2zalPE5tKpQ2L7ueo0GN6W2TSzGWj995/gQkwMaUTvUgeuRn+B0dAalsMY6tYrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FukpbDhM; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712913391; x=1744449391;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lXURzvpQy6x1/H3hzQqOVbcm6LBqWWnXyPji6UC27bM=;
  b=FukpbDhMhKICz+0xYLqI/KWLzRlKuRq8GLTVg796fDvuI6Est2htNeEQ
   0d/3kAItAS5jUgMGlmz4HQ3a+wDjg9u3IC+/d/qzal1TE40F/l36JH+F5
   CZyrMKBKApzMTXwoVy2NoecMXD6CmAwO+SswcgiyZko3mVTlvkUzCMQq7
   pEvU+qzudCNXDmtCoaMRlSoKG0f3/x+XnX+hz6B5ZybVWn7ss8wb439WW
   t8qkE6E6YI3BlW6urUtSngyZys4O4UcyVIBDBTGtzWrC2mEFQRIP8ED1k
   d/a32oC6YOFB1hxJN9MM/FjSU/4tVU7aBiA4Cg9PAsc4McCzCAyNWpOpl
   w==;
X-CSE-ConnectionGUID: tVCAROCMRn2HBdzXL6P2BQ==
X-CSE-MsgGUID: voRo/jjMSPenmdpFPJ84Dw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19757997"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="19757997"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 02:16:29 -0700
X-CSE-ConnectionGUID: wklUZsnfT7ero8k/9LKyJg==
X-CSE-MsgGUID: O0hUmBAOTGSFGcp4gHJcGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21757317"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 02:16:28 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 02:16:28 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 02:16:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 02:16:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 02:16:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7VYK/Ve1v1SUy9osNG/qOBmneCFQ5Bd8ocw6Z2Q8I1sAqm/rU4CUsPOZ6rSenTTeBDVZNn5o4iaWNftxJ3gaj0uDfoucacmb30rYB6DW0scl+nOM9RG83vTH593VN0mbc7ck2eehFPMdPPzEahSupQkWTLC+Sw8q4phMXE4+xbtU2532PlrX5U7Mb9ybtPIxueyLJl7i8zloA7wecoQdR2EKTg5DBRLyPO7He2j67H/fZMzaR7uqGpLTPKr3uzFCNYimmEmwWe1tnby7YfIym1cG5f5Z9KQyVbVxsgZkV/wUED58N/fGqO1ajx1ImAI+OnA2WXsAF40HKyCykusIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXURzvpQy6x1/H3hzQqOVbcm6LBqWWnXyPji6UC27bM=;
 b=VOyli7wQjZLADE7IDe/YykwH9+JdIM/SBfM/Vxk5mVVY9voqD6Dp4BoVAFBpr2/JX08veI9J/RgyAwuLQlcBqZArPTZUIaia0oqUJ0kC9mOorUjYrzQy5GFdG7gHfup59XQLKkQJ4hT4TdPkN9d25VKI/lREdMRj7KcpO2NZ2VmD/EhtkRzi/EgXgIzKf/ewh5bR7OxbAK+AoHNCuaR6xcIPou9qt7hjGw/ImFlilkkbif83mFLLHL7po6zFudeirmkOxbrZAwlSZasXXOAJtimUgr3Vzvrv8oyjqKZa5+/2G4bqHqIFckZELNQ+3dH/c1J3lkaFjmRkJTBg/NmhCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 09:16:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 09:16:25 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 06/13] x86/irq: Set up per host CPU posted interrupt
 descriptors
Thread-Topic: [PATCH v2 06/13] x86/irq: Set up per host CPU posted interrupt
 descriptors
Thread-Index: AQHah6hf9srldbbdPECjRLpjdfKYWLFkZHcg
Date: Fri, 12 Apr 2024 09:16:25 +0000
Message-ID: <BN9PR11MB527696368E4022DBAC9DD7768C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-7-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20240405223110.1609888-7-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4664:EE_
x-ms-office365-filtering-correlation-id: 16bbae4e-e6a0-4066-ce2d-08dc5ad13a43
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/8GkVO/GilaHPEOJO9GklzVrEBtjbLRJTGKBCidCIzK/I880R10xVrgihJeotivsrT9uNaMjqBF9aWNdUxWRS+1Up+PfcKdVifFVNt7/xNDQIr4EsVa+Jk/DE3Lv2r/dd+Zk9kX0Fxt+XHPA56Y2DDbkoqXFusU8qIgSPs9+r4hgmY2VpSVIimT/TDVP5yHYVIWCm/iF0xiN5mDfJaKrMw6VleyZYBiEr9oBZ2a0k5YRpP8aWg1jnuFpLIgO7vKj1zfTf0hUDXjP+Bn+3WseCiBRD61hCtIu6xTwAWQPh55P3gmU2SxVEpUBvOd0fGRL7Ar7dAzoiFz3kgHmh2JX5JOdkxmV1M241Tmmx0bt4KWIWY7CSxU580XYejs82dq/rxgYQHg6oYGHiybusvZux+K66x2F/omDEvj/sPjVdrwP1gnBSRJWEHLdkySBbm/WdgAYiJ29O2usWOVevBnI+kx6PXq9TY6s9x9q9N1UPpQzt/GDygJjW5kffy+LsCh+n7rLQfqp/DiY6usBsHANMTuCl5J2hJvLbkAsaYUcQBI4vigpGnVy9kqb+9Iq+bjeJe6GcNESiRuvH6L1iwVxsP110XevYCWXyl1GMj+Bi2WIXrGbGzTY3D4ml/WwGe3Oue9pJVfrwgLamphjSiWSv/Jpvyrj3EIkDqLdQl4COtmA9K6AP+LTZXqUVHogpPEcjf2KG+VVrKLGs45IMv9LvtvIpeUEGbUeNPLysWiSDY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CPr0bGzaVliEN+NZ7Ckqgvb7hDlJTfRC45HxUUv3MeYdZ/nxv08DSmIzSQ1V?=
 =?us-ascii?Q?QIPa1cdhF024aacJUvGWl+IWLHi2edxNxXX53bpgs3TiHWHRfaw7s6tYGXe8?=
 =?us-ascii?Q?810o111bK2eOcRCLPQVvbiiM85lP+J8Hdm5ZFUoqXXhj+LOqhy4mcsnQqOQ1?=
 =?us-ascii?Q?GeDtuX7WK9Hjrp32cMcnll2e7Z4hKY/jHYI3+0nEL3YXI1PVOEbGi8QzMB3k?=
 =?us-ascii?Q?L90wUa6DuZ67KnXBA5+XW0FAsMSW3tcAEsHVlNg/AEHXoRNHrKBEvZhxprV0?=
 =?us-ascii?Q?E8ZKPMBM/3D0ShHZIYTWW4wSUb4V6iZPW1OqVO4Y32/edwUgm9xR4Dz3N2dv?=
 =?us-ascii?Q?pRl7qGAiRjVjPCl6ZBKpT0taI+3JSUIt/sHrflaJF0a2oPVz5Jd4FdKs5PzE?=
 =?us-ascii?Q?VvNSUs5Ov3zhSz40DH8EN9XgEIYFmYMyS9I2tv7JjGjChy3mhV+cxSe5hnBO?=
 =?us-ascii?Q?MfpybWViN/+hKgAJG/sGcFYdPI1a4yUWcwBdnAWwB7MhrjTTw1cXA5XU8eg7?=
 =?us-ascii?Q?GJCbPstIXHYhZZS34cfFgpAjkvpw5q6oO+CMPsAd9i82goGsC2vBmGGzPUom?=
 =?us-ascii?Q?X8jkW23E/nGOzH2MHWW1noUAeyKpIRir1/F851pneqQNYefZCTmSqIIUx2W3?=
 =?us-ascii?Q?NzoWK5Tece8UZgIprpN3C0EGvOBInRVMa6RwX/ty2DdoXREcRdo4V1JksFk/?=
 =?us-ascii?Q?3d1MJO/9aDX/ZTBCzjyjSH2v3pJH2vYzfzq6CTnBChMjWJZ84jlXJddkjpOI?=
 =?us-ascii?Q?sSxk9r7DsrgNLoz60D50jgmHmtgw8wYUWAuBXxkZtQTBOLjjuVyGNbTWJhS1?=
 =?us-ascii?Q?ryItoOIhWIW7f3zf59/ZHb22Oucaf1iJmH/rYKZan4Q4vu3N/nbDzFzK6wos?=
 =?us-ascii?Q?rbenZlztMg7wE9ExvXUXZd5LQ27SxOy+NHnM8xXMPaV49YelRUGcEr2JCfM1?=
 =?us-ascii?Q?35y/4xZI5BmbGvggSoh5iCoiB0NHOQHVxAod2rRFTQQUtcUpC5o69/eBLdGU?=
 =?us-ascii?Q?eyezEGIH3stYAFqSmDLnSmG16TR971Nse1NQDFXsggnzWLqsB76W0tiJsApJ?=
 =?us-ascii?Q?+3AUZ9AISHuTJbzxgySO9AugzU8uxU9LxzBeLZJv6ImcAHMVMQtQukTHsbGU?=
 =?us-ascii?Q?yxJZ8w4TvdlQV7oFtSrJ81SEetQ3zgskaMtxwWl7k1YPuubElLkgAhTYLj5p?=
 =?us-ascii?Q?HSJeJfrTc0HKYKPsmCoRUWadh3URoZQeeAcrhneE1IvBzKyWxrpb0bvtyIQB?=
 =?us-ascii?Q?lb9fY6aaEfNUlUwe42dVOmQ6ZHvw8IxDIGE7EKGsu+95sDFT7QP+8HsjRJCt?=
 =?us-ascii?Q?1s4QXvBGYE4S22fddoUHzQ+qIStOD5VEMmfmqj9z/SgnumwFMFzDNwIwCzLI?=
 =?us-ascii?Q?hvBhlBjX8ivYXM3DeKGIfSfmVe44uXezR5oeIfYha8EJLVvYoEZ8z2V2+bm1?=
 =?us-ascii?Q?fQLr4sCuRsYygB1TVaPmEIQhTdUhPGYYC5ksp+WCf9vzjC4V8HMEGcxjYgF9?=
 =?us-ascii?Q?5x04lxMG6skTl/4uXMDua1ey/8P1LAtt5uTqzHfZa95t0cvcYfdwEUbvajHT?=
 =?us-ascii?Q?Xznv9qzCPtwaatOV00YeEPyuM/5+KS9swtJ7hBkv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16bbae4e-e6a0-4066-ce2d-08dc5ad13a43
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:16:25.1656
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S6Q56gAEE/jt1Qy5DDso3fymuSC/Qt/xA2bBTK+J4w49cFi19yYEmFQARjxaK8KCeug9VGGhBCa9f7hyT28kYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4664
X-OriginatorOrg: intel.com

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Saturday, April 6, 2024 6:31 AM
>=20
> +#ifdef CONFIG_X86_POSTED_MSI
> +
> +/* Posted Interrupt Descriptors for coalesced MSIs to be posted */
> +DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_interrupt_desc);

'posted_msi_desc' to be more accurate?


