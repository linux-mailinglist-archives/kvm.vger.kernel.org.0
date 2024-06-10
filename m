Return-Path: <kvm+bounces-19240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF4A902633
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 18:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F3CF280F61
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 16:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B8114262C;
	Mon, 10 Jun 2024 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bD23k6ju"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF851DFF7;
	Mon, 10 Jun 2024 16:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718035236; cv=fail; b=CJcArk8C8SF8q/FFUdPPb8RjLpdgkl5hHsYjaRiRQeHBX2JNC5U8NWXZM7uzh9uQnkLWopInbAM6gEsVtXhkQ26GIT45otBEx7+MmmcOS/XUObSeoAEkyPQmY5dcWs/v10mi3dWokf9TKCeTw7Ms5qykjqBbzPZeYQA4qYHnuwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718035236; c=relaxed/simple;
	bh=FqisHBYRYPr3FA64UYlA7i/E3vjgzhULNu1qric1r5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MEk2dPGcAvGZX9QIKL91G16S0Tt1yFM8JykzkcJix1ZqqCHqp4UJAU3j+lBEJHkd80EwRv8iczqXJETM4UdT2FdjsKLbNSVD2EVm6EFKuwOonvrtWVH210X5jSyRnkEFKS36O90t9A6H1B1kEqpZaGqaE+dvO3VAuZE40S9y75U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bD23k6ju; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718035234; x=1749571234;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FqisHBYRYPr3FA64UYlA7i/E3vjgzhULNu1qric1r5M=;
  b=bD23k6ju79yw/3CozKQdzZIUslPtRtMrcvkvYj967QQQJUgnZGHWPkRe
   n1DNpNDP2wOoLJYLtyOtn4bV5S6JF7sXrvS0APhqlJgfPa1TzYJu3JufO
   27WpFjNp3+Jwa28RG0TuBb8tQFUwMzUc2+u1KI9MrtwjYSVbR4QyfE26P
   8WqFjJ4bSBVDc8mNIBkrIsmdx0IIi6irnGLL0owg0jV3ydBAnpbk+m/+3
   jQepoiFSGHGbsEFq354yn1U60EezKHhn+sJWEn1mya9Epd4w/TDZLbuTJ
   Tgvbb6QLJkun0ON1t2GvEgGF4VtFTH/tlBKVWYCCryh4AtpzLhMdFKi9n
   A==;
X-CSE-ConnectionGUID: P5LFi6aFTfyTF1cxU11z0w==
X-CSE-MsgGUID: IKmxAJyTS46wUM1FpOBaDA==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="26105506"
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="26105506"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2024 09:00:28 -0700
X-CSE-ConnectionGUID: GlhPKX6sQTup4mEE58sZig==
X-CSE-MsgGUID: cPKZdVv4SwG1yeVPJn223A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,227,1712646000"; 
   d="scan'208";a="70274745"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jun 2024 09:00:28 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 10 Jun 2024 09:00:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 10 Jun 2024 09:00:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 10 Jun 2024 09:00:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kj4naZ0e+O7FVNesYRuw/j80LWpuNu52dB5mCi36IFmaMA+RRt5tnelX8qkrWWtWFR/aT02p4qQhjfdnKbzp8vJxzD9OFgYvH5ipadJ6EMVtKhyyXlYsoeOpedHJBC/Ut4ciun0+ppIMt1k6cymIt/8bCsmG/tSub8fJPUXVy85R3YVJI/sw1e++no2E/hFoFDDudrPS3pNXdhzIi5pVhZRCAGPnfcWvWQ2AzFA3DUxWmRpcbLfDMHX/JkJVe31pvRcPnw0COGgoHbiMUP4vO1bXqUWb4tfmcpEjt8Q7ojPPBB8VBe+UbYkq0qGWRWiLAwjQ1IGkCSBJw9O1BHrPgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqisHBYRYPr3FA64UYlA7i/E3vjgzhULNu1qric1r5M=;
 b=hOhwQFvfjOjohIsqwRIcY19c9Q7hv2K6vTNjP/dAe5zXoAHmqLx/GeJpv547sED8yTbvL/0ta19zp8LSjKZPtEGK81PE23okxkYmq2wdpYJ5mDU8In2F7pexP2qUXADvt8aXLWV2SM1R4Wfgq1BfpQlZELo43RnJZGDugLocbOsHcJmGEc3DJGs7Z/hln9g5pQ3iAfUWPzQxUCm6egRyQJnZ5xYjH8fs4P2oJHpXdl4PGTTBfK4qcaymJeTkTWFqKsENW+9o5EZ2KQ56MA4kWiPSdQT8Im99MBe8l72QixeT+VX3JZRqM9S0ZPPobQoe+Vuv6QQ7CJtMp6sdM1eDJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7571.namprd11.prod.outlook.com (2603:10b6:510:27e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 16:00:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Mon, 10 Jun 2024
 16:00:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Topic: [PATCH v2 09/15] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Thread-Index: AQHastVuA3gf0B2hd0WXTTAj0WB0+7G8CKWAgADD1oCAANY3gIACjGeAgACbAoCAAG7RgA==
Date: Mon, 10 Jun 2024 16:00:21 +0000
Message-ID: <76e0c5e9afd7df08d586e267443ca5dba48ca377.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-10-rick.p.edgecombe@intel.com>
	 <CABgObfbzjLtzFX9wC_FU2GKGF_Wq8og+O=pSnG_yD8j1Dn3jAg@mail.gmail.com>
	 <b1306914ee4ca844f9963fcd77b8bf9a30d05249.camel@intel.com>
	 <CABgObfb1L4SLGLOPwUKTBusN9bVKACJp7cyvgL8LPhGz0QTNAA@mail.gmail.com>
	 <9c5f7aae312325c0e880baf411f956d4cce3c6d1.camel@intel.com>
	 <CABgObfYd4TWq4ObUzkDruj_e111cTniWtXckzB_Ft7SOdv7YMQ@mail.gmail.com>
In-Reply-To: <CABgObfYd4TWq4ObUzkDruj_e111cTniWtXckzB_Ft7SOdv7YMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7571:EE_
x-ms-office365-filtering-correlation-id: b4d13049-1aa8-4720-08b6-08dc89666ee0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MHh0eVhYdnBmTWtucXYxcjFMRzdFQ2k1Q0o1elVOWFZ5RXBCOHpBTWJ2ZVB3?=
 =?utf-8?B?UlJtdW1aalR1clNBbDhCWmZHVnFlWXRmQmlVYTRFTndsRDRjN2tTUVV5TjZX?=
 =?utf-8?B?d1JOb1Q3Z3pQYlVBa2diNUVSWWNLT1ZldDBRWG9ZeXQyS25HVExXMlJWTjV5?=
 =?utf-8?B?b0FtRGwrSG9abGQwek5yd09DYURtRHNGaHJIbzd6dmtwbStPNXp0K1VFNzBM?=
 =?utf-8?B?ZlgvdXBRMWpmU3MwSFNQZGx2Z2VWUHZSZ3JQOWhDZ2hoajE1Z3NBM1N3dVc3?=
 =?utf-8?B?SnlGR1JmT2loTXZrWWdzWEp1bHB4R0d3Z0ExQ2JWdVpZQ1daOEQvSDFIZFZo?=
 =?utf-8?B?cmwyV0xqa0hBZXRaM2lIdlpnaXVGVVJMZE50WGdYeUNPbE1GYkEyOFNzY0dY?=
 =?utf-8?B?T2ZzSi9LTFE0emNVeitpbXp1b3hjQy92cnFrWGFGcDRTNFR2S29wcHVRVWVV?=
 =?utf-8?B?eG9XbmNxbTI4UW0rWDFvbTV3cFl3TG5GVjFYSEhKYTBXanAzUFI2bndxcVJE?=
 =?utf-8?B?cDB6cUNwK2xJb1hBVm12RnUwQnJwYjJUN0J3a01mb0dQcEIyYTJiWjkwTnBj?=
 =?utf-8?B?QmxLTHVPMmxEZHVXYnoxZVNzQ05kcnFLOEh5OFZScmc2bCtLOE9la2JoU3FE?=
 =?utf-8?B?YS9DOGlsU08rejJxdVd3ZmpmaVRxVWJndzk3R1pLaXYwWkdqRHBvNmtHMVhq?=
 =?utf-8?B?VjhNSkxnL0h0SnVraCtKNHdjNEtjUlVkbUtzejdZc05yQUNweTZ3cWZsMlFw?=
 =?utf-8?B?ckp2T0lPL1d5bGtvMzNEZUNONlVtMXlWSFh4cWFxcWRteXl6c1V1RGtyU3hE?=
 =?utf-8?B?QWcrMVg3anlYM0MzbmIvVktEVk0zbnFucnlLbXd5NnJjSzZpSFRQUmxmNXp6?=
 =?utf-8?B?VXpLczlFa1VpdGhZS3EvbnNENHdxY1A1TzRGaWpJaitqV2hwa3RiYnhmajlD?=
 =?utf-8?B?VTNNeUlYNWtKWDVEck91V3piT0NVSVJ6MGMramwxcS8zejVzeExEVy9YZ2Uz?=
 =?utf-8?B?YXJMZGRMb3BiL3NSd1VjL0c0V3M1TW1JTkNtejJBS1pESHU1dEZFNlRuQkV4?=
 =?utf-8?B?cjI3cFF3cWttV1Rjd0RHY2tCWU8rQjhIN2dkM090ODZYMlY2a09vdm9BK3NS?=
 =?utf-8?B?UTM4cWdUcU5wUjAxU2hxemMyWDV6OWRiLzdMdkQ0aUNueVFPbjZMc0pERklI?=
 =?utf-8?B?RE4yTDhBdDVTSy9mYVFJWVpkZHVrbHB1S1BrL1Z6TE40R2w3MjBqMnVQcXV4?=
 =?utf-8?B?eG1heDNnREc1ckV0ZkVoUDBnRkkzeWxGVlB1NzY0VGZyVkFkclo4cDJZY2d6?=
 =?utf-8?B?eWNXTzhNclBrM3JsdDllZUtKUDhHWjhIL0NzYXRaMk1HRHBtUnFNUlpma2hJ?=
 =?utf-8?B?UGJYRUtiQVRaK3VIV0hVZUFEM3hjNnlrT2RlRERpWThUUS83K20zTWVRUU1G?=
 =?utf-8?B?cGhRREovaVkvSFN4dTdrOGg0Q1pCT0tDd3FLTnkzaWRJZFpzWmwxR0tKdnlW?=
 =?utf-8?B?M1pNU2ZiMGMybDdlTStqR25iRE9BL21ocTFYK0l6eWtDcXpXc1RhQkpodDhm?=
 =?utf-8?B?T3N5VXpSYi9BRUZaYnRFM2VjZWJGRnpLZ3FtQktsOHNlMHBVKzNHdVRjTzE0?=
 =?utf-8?B?MFIwemdzVUVYbldzZ3J1ZWtrc2UvR1Yyb3ZFdmNrZEdRN3pIT2RPd1lFNXZB?=
 =?utf-8?B?R2pNbGJhNWdBQUVXaEdLZEJlN2o1UCtjd3QxazdCQnhnQ2o5QkdIejV4bGIv?=
 =?utf-8?B?VkxUd0dORkszRHEvbjJTWFpKWTM5dDdHSlE2djgrZHFEQXE1akpZa05Ga0RT?=
 =?utf-8?Q?bv6dqm+Q/aKId9Q5lTemU7uHQSx4eHjo0AJ/Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bXcvMFpWSmNZUnd4eXhmUGdvajZPbjJZajlmMWpYZFowVll4aVYwb0tBMWxX?=
 =?utf-8?B?eEsraDFrTXFIWXpiSkZmMzZXa1VlT3RVTjF4SE1pY2hEQklDL1lidHpPcTlZ?=
 =?utf-8?B?Q0VqQWxjbndFdW5Ebm5mVkJwSVNXNVNrVlBrUExIdnA4b3haUmVqV2p2Ykdx?=
 =?utf-8?B?U29lTjgvQVFxYWgrVklJWnNMYkl4QU0wWGt1SHczV29LOUl5a1BJSW9GOWtt?=
 =?utf-8?B?N1pidHJLZ3ZNSFF1Y3I1YzJmV3VDeFZvbTRPZWlISkNoMUcvV3dyZVVCL1dJ?=
 =?utf-8?B?eUZmMThwV3pmTkxUbnBVcUxGc3JTNys5TURXK0FHeTR4Wm01dVVzV2cxcUZU?=
 =?utf-8?B?SEVNR1pTVnZ1RlJOeWw3NWtNTVR2eGxpRE05Z3F3dGszRVBmNWJOOWtzZGY4?=
 =?utf-8?B?Z0I1Y3NWSXhqcmxKTksvei9KeGgyRjZxaVUreFoxcXZ3Q09FVXUzeElGTDdp?=
 =?utf-8?B?K3FoZkFxMnI1U212dWFkVEs0MExpbFRyUkNIclhTL1lySlF3M3prTlU1NXFk?=
 =?utf-8?B?U1RJa1ZJbzc0c1BpbXBIWWV5VFJ4Q0FPcXNNeE1vY3lyUEh5Q0VtbE1PK3Er?=
 =?utf-8?B?V3NmZVNIclpYbnl6d3RTM3FjTWQvYlUxTHJ1dno5N2lvalFpZkkwNjhYS1JF?=
 =?utf-8?B?dDhQRkVrZ2NMdVpUbTNJL05xWkMvSjBleVV4djdvOCtCSjRnODJWTy8wTzJQ?=
 =?utf-8?B?RTdjNTNlODhYWjlpejNIa1RkbDJiMCtiQlYzdVAxSXBXTzJ1bzRTNkpLb3Az?=
 =?utf-8?B?OERQY0dwK3A5WkQxcGZmUHFIZFlpRlJ4MlNwaWhodkhXa3NxbyswOGJuSmVJ?=
 =?utf-8?B?TVBSYlRwb3hIMnIvc1A0a09ZNVp5bG1yb3g2VlJBV05xZExTR2FRQlc1NkFk?=
 =?utf-8?B?bUNnVHlPL0JDa3ZlaWh3NzJFcVhIT2FMenVic3RGd0llR2xzV0dERytKU0NZ?=
 =?utf-8?B?TklWb0ZCSUw3Z3kvNmJQNER1YWR4ZWh1VTZzWGV6V2ZkOUtrb0wzS0Y3eE9j?=
 =?utf-8?B?OUpVT1ZMZDZkQWtGVmsweUtSeHAxcnNXckMxYVJpMk9nbXh1ZHdrRlBpd3N2?=
 =?utf-8?B?SG5EWFFIYVNEdHAzUDcwMGNlYTRsNUUvQzVrdHRkbzZlSEFKQVN1ZnRiVWpS?=
 =?utf-8?B?TmN2S1IrSXVqS0k4b0VhMWtaRFROcU9UODFYR1Q5emZtWEJRSC9TMUkwaU15?=
 =?utf-8?B?bjA3emVHMFFCVld6T2FBbzFRQjdSWlJZU0hGSjdaWmxMendvTXpnOGlrQlps?=
 =?utf-8?B?SnI4ZGRvcmY2YnBXcEF3TEc1elhtQzVzRkdlMXY4L3hvZXNpMW81V3B6T21B?=
 =?utf-8?B?MUxMOWVhdHQvZy9ZT2pPS3o3M3hZMjBod1EzQ1ViUlhwZVFTOXVkYTZtb0dv?=
 =?utf-8?B?Y2RrdXNyMWVNZFhTMnZjSmd2bWNESG1iK3JjVFcvUU1pb2dIc3U4OVk1UzBz?=
 =?utf-8?B?UW1kVWJDMjRuK2xkb0g2eDJ0NlhxRENid01uTDRMZkxLKy9KaTQ3L3hsYTBT?=
 =?utf-8?B?UlA2N1hBcndjdk5DQ1J1VVYvOXB6RkdLeU1HbXl6OThtcmpFNUVVd2JIaE4y?=
 =?utf-8?B?V21URWtzZVVrbm1oczhWc2o5OEE5Tll5aXJpWUFHNVU1ejFrbExhQWxVclFC?=
 =?utf-8?B?a0F1Q3ZqTFNaUTY5T3Y3YndLK3d5SGgvb0FmbWY5M1hhQncwSjFtZUZyYUVv?=
 =?utf-8?B?V2VpRUFSYVZVRy9VeGRhV1hUbzRmMzBMUDB4YWJ4QkhMM2dhT0w1anpDdGlS?=
 =?utf-8?B?Z3ZuVnFVRXF6NzM3Y0V6aERZeTJOUWpPR1VwUWtLV2FVOW9rZ0NjNmNucDI0?=
 =?utf-8?B?WVZBbE1qamJYYjFzcjRQay9YdDVaN0N6blBOZnBsdWRyTDJ2T3dpV3ZvYStj?=
 =?utf-8?B?ZXhyd20zVDZmb0VDZjJXSy9HWTNUaldHNWxMV3h1dHgvV1oxTkNscTVsT0Nh?=
 =?utf-8?B?bzhyM3NDckhtNVFnWURDUU95ek1OSnIzRXNUYXE1V1ZnandZYmdueXBjQ0lk?=
 =?utf-8?B?Y1JucnlYZWRJZzF2ZDJsVjYvMnNPalZoQlNkeXhKcVFxRHQyUkF6T25GcERC?=
 =?utf-8?B?YXBtN0wxUm1mQnZmMDBoVkNyaUprdU9RblNaWEd5S2hFRGxSNlVsYUF3TTJL?=
 =?utf-8?B?QitrVmFDZVNxQXJpd2Q4eGtiSmxvWXNJSDNlRFVDQnhpZFdQRng1VVdPdENO?=
 =?utf-8?B?RkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F7A5457BE84D404D88E776DA47ADA13F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d13049-1aa8-4720-08b6-08dc89666ee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2024 16:00:21.9508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bW7cMX8iWBiC9JEmpDdu32B0kl7/aOHPx6pNiKVmOx1Il+AjivTOw646syJruNAS1Kmxz5cCPywBFuIVkoZ7ycBz6mFXjdAbmFYA2abPeNM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7571
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA2LTEwIGF0IDExOjIzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IFRoZSBwcmV2aW91cyB2ZXJzaW9ucyBjaGVja2VkIGt2bV9nZm5fc2hhcmVkX21hc2soKSBt
b3JlIHJlYWRpbHkgaW4gdmFyaW91cw0KPiA+IG9wZW4NCj4gPiBjb2RlZCBzcG90cy4gSW4gdGhp
cyB2MiB3ZSB0cmllZCB0byByZWR1Y2UgdGhpcyBhbmQgaW5zdGVhZCBhbHdheXMgcmVseSBvbg0K
PiA+IHRoZSAicHJpdmF0ZSIgY29uY2VwdCB0byBzd2l0Y2ggYmV0d2VlbiB0aGUgcm9vdHMgaW4g
dGhlIGdlbmVyaWMgY29kZS4gSQ0KPiA+IHRoaW5rDQo+ID4gaXQncyBhcmd1YWJseSBhIGxpdHRs
ZSBlYXNpZXIgdG8gdW5kZXJzdGFuZCBpZiB3ZSBzdGljayB0byBhIHNpbmdsZSB3YXkgb2YNCj4g
PiBkZWNpZGluZyB3aGljaCByb290IHRvIHVzZS4NCj4gDQo+IEJ1dCB0aGVyZSBpc24ndCBhbnkg
b3RoZXIgcGxhY2UgdGhhdCByZWxpZXMgb24gaXNfcHJpdmF0ZSwgcmlnaHQ/IFNvLi4uDQoNCkkg
bWVhbnQgdGhlICJwcml2YXRlIiBjb25jZXB0IGluIGdlbmVyYWwsIGxpa2UgdHJpZ2dlcmluZyBv
ZmYgb2YNCktWTV9QUk9DRVNTX1BSSVZBVEUgdG8gdXNlIHRoZSBtaXJyb3IuDQoNCj4gDQo+ID4g
QnV0IEkgZG9uJ3QgZmVlbCBsaWtlIGFueSBvZiB0aGVzZSBzb2x1dGlvbnMgZGlzY3Vzc2VkIGlz
IHBlcmZlY3RseSBjbGVhbi4NCj4gPiBTbw0KPiA+IEknbSBvayB0YWtpbmcgdGhlIGJlbmVmaXRz
IHlvdSBwcmVmZXIuIEkgZ3Vlc3MgZG9pbmcgYml0d2lzZSBvcGVyYXRpb25zIHdoZW4NCj4gPiBw
b3NzaWJsZSBpcyBraW5kIG9mIHRoZSBLVk0gd2F5LCBoYWhhLiA6KQ0KPiANCj4gLi4uIHdoaWxl
IEknbSBkZWZpbml0ZWx5IGd1aWx0eSBvZiB0aGF0LCA6KSBpdCBkb2VzIHNlZW0gdGhlIGNsZWFu
ZXN0DQo+IG9wdGlvbiB0byB1c2UgZmF1bHQtPmFkZHIgdG8gZ28gZnJvbSBzdHJ1Y3Qga3ZtX3Bh
Z2VfZmF1bHQgdG8gdGhlIGtpbmQNCj4gb2Ygcm9vdC4NCj4gDQo+IElmIHlvdSBwcmVmZXIsIHlv
dSBjYW4gaW50cm9kdWNlIGEgYm9vbCBrdm1faXNfYWRkcl9kaXJlY3Qoc3RydWN0IGt2bQ0KPiAq
a3ZtLCBncGFfdCBncGEpLCBhbmQgdXNlIGl0IGhlcmUgYXMga3ZtX2lzX2FkZHJfZGlyZWN0KGt2
bSwNCj4gZmF1bHQtPmFkZHIpLiBNYXliZSB0aGF0J3MgdGhlIGJlc3Qgb2YgYm90aCB3b3JsZHMu
DQoNClllcywgSSB0aGluayBhIGhlbHBlciB3aWxsIG1ha2UgaXQgZWFzaWVyIGZvciBub24tVERY
IHJlYWRlcnMuDQoNCg==

