Return-Path: <kvm+bounces-51011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF41AEBD28
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:25:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 579E6647855
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E27526AA83;
	Fri, 27 Jun 2025 16:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fDQwAcPn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD571C6FFD;
	Fri, 27 Jun 2025 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041478; cv=fail; b=G3w4rG1LGEcFX3v6B+GGaP5dePvusrPs3iOxKwPH4lMZI//7GXJOv97dL6so4urfjTw2g1JP053rpp9mlkks/m9w/Gr3prBOqdYKU6VD2mXk8TywfYrLC8QVm+CP+DKAYbFfXLIEF3qCLTTmthcBDlOa2h8e84EBn2ABEF28hVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041478; c=relaxed/simple;
	bh=/uCxuji25i4yVRrsYgmczyCZIv93PctT+Kh0H1s6i9Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nru0k/m/Lm+IXm2DNliE19UZZ73VqujeAQbHLnMp4Q+zpyEr2E/1wZjwzqrIi5zio3omaVns4ixO5Z6IU7QqBMsXuZH7rvJCvjqVMP8fH2+S2AhFph4FqsZ0QP8thYAG/D/shq12B0Jy7ThvB96BAEdA7ISsaL/Lz646JhJuXIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fDQwAcPn; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751041478; x=1782577478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/uCxuji25i4yVRrsYgmczyCZIv93PctT+Kh0H1s6i9Q=;
  b=fDQwAcPnRvi816H8pthrG3WfKoMdVCHnVWUYq6PHTJEMgPwoZR/YDkPc
   w+VxW6NVp6A9v24h3pZdzoFdwIrm5bPfhanmjJk7/fFEGHleFjR8ogcUa
   AXL4+pJW1O6KPDrTGpOmWMk7+qAD3DanV8VFBDO9iYCG7ZembFRrVHQwB
   UyKGvj7OjiHYbY6RchB5N/XjiBAhX5FOD9OyHGj0V2kfW9rdUOP3qcWQg
   9Pk0TnwckW25yYUIZ10Cd95zOg2B7uZoDbszjbV3tzo2rbAE9Mv/cJOHi
   56ctkQ+tmdhyOk4jOP2JisVHMihu46zLlWTWoqkTfpMT3uaaN4UMTrhU6
   Q==;
X-CSE-ConnectionGUID: UiIF7zpmTaW5fJ0aX089rA==
X-CSE-MsgGUID: m6j2qfI/QzSMmKFLyCGdrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11477"; a="57036214"
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="57036214"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 09:24:37 -0700
X-CSE-ConnectionGUID: 3P3sqTdTS9O9RSt/XJFq5A==
X-CSE-MsgGUID: mcah5usiSk2SEt80Jop38w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,270,1744095600"; 
   d="scan'208";a="152368402"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2025 09:24:36 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 09:24:36 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 27 Jun 2025 09:24:36 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.74)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 27 Jun 2025 09:24:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=imDtA2xhVEuED9bXksR0Gc9z6chJuX8kmFtmNXOnq5hv8atmcI9Fyr0pixprKCtAwWE3N0iA6R8uwGeF9NtUxEEBZ/tCJdNlAjgJPwLlksF4Koeu6Jmi1iv3Y5PL2GNyyT8MSlbPUYHEwRvIYlc2LvYlmhFVfvCtFPjHK9qtHwVs+2vJZoS17aLNp7/McETjaA3aIvo5RbO+KcNxBdbMFxPdMWrjwmfqY/Pgp5QaEAHaYHZyemiy7TVlle3gyh6z2T8NU642qA5IK3pGnbrlIRh9Pr8rICrPIqYGD8Q54JRPtqXn9H9mRVEHyqA092+iskJdVQZLpECiLS4sIDnDiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uCxuji25i4yVRrsYgmczyCZIv93PctT+Kh0H1s6i9Q=;
 b=sa1TkvxZl5z/qjg9pnY8UTw7x7AOCwiVYbO2HlSBTvSYsWBdpLpgHAT5H2Q9T7OqkGEybSTuKIwD8+42R1CnGzgFIMxsgxyOZhIhmPfCxmX01NMHPVyf990jR23LyolLVWezUwJWhb/DV3VOqQ81X9kdRKMU6Qx09gU2ggT68216LgQM2T4HFrOMNKB+ldUaxof835VijtE6HFmr89AyLNy3A3T1Whjlh4/F+we0ImGDih7LRN9UlZz8IUU0+hhQ84hNFjk8mslfEg10wdzN2AN8mTU+yAXLdiMaHqlS2SYnTSQn6TW17F74zyKgxoz/Lg1JRfPJ30ri7QPvtBCKqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB5264.namprd11.prod.outlook.com (2603:10b6:5:38b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.22; Fri, 27 Jun
 2025 16:24:28 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8880.021; Fri, 27 Jun 2025
 16:24:28 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>
CC: "Annapurve, Vishal" <vannapurve@google.com>, Borislav Petkov
	<bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
Subject: RE: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/xH1txe69zU+wjMA9RpcOPrQJAXsAgAFgjQCADMwmgIAAAM+AgAAPRAA=
Date: Fri, 27 Jun 2025 16:24:27 +0000
Message-ID: <SJ1PR11MB60836014330204B2FBCC7418FC45A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-2-adrian.hunter@intel.com>
 <487c5e63-07d3-41ad-bfc0-bda14b3c435e@intel.com>
 <ccee2a0f-18fa-4037-bf97-f359e0791bf6@intel.com>
 <d443db90-ced5-43d0-9f85-ad436e445c3a@intel.com>
 <9a4752a4-e783-4f03-babf-23c31cee4ff9@intel.com>
In-Reply-To: <9a4752a4-e783-4f03-babf-23c31cee4ff9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB5264:EE_
x-ms-office365-filtering-correlation-id: fe9a6df4-9c9d-455d-8a56-08ddb5971689
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YlgvWkpWVnYyemt0NFNJS0tpQVFkT3ZPdjNzMWlwbnJTMTVuYktFdHFSZC92?=
 =?utf-8?B?YmpuR3lVZTZzRThMMTYyVzU5SC94QlJ4QTJBdGMyMEU1VmtRc211cUhIbEND?=
 =?utf-8?B?T0tYcG1UVkVtNXd0QUc1dGdqZE05eGRteXNYbHJhaVdrWFlDTEEwUkluNmVr?=
 =?utf-8?B?VWFBYTZURzdhWjdrWHlrdnBaNjZRbEFkbURHOERxRjFGeS92TTI5Z3RLZXEr?=
 =?utf-8?B?U1lGZHpGM3VHa2dsdjBiSjFlbDZzTWltOVJDcytQelNnV2JSY0tHL1BEampP?=
 =?utf-8?B?L1p5amgxbmVWNFhYSlVpL3Y3d0R5ZjM2SGRCcTZ4TmRKYjNjSmlnVEd1Y2ov?=
 =?utf-8?B?YkRhZWVLUDh3WmUveks4eElHN1FFV2VkNVl2UnJMUFQyQlJqMTdTZlNQSXN0?=
 =?utf-8?B?Y2hYd1p2N1hlN0VzTCtHT1pPT1JqLzZib2ZGeS9ScmVZMngwcHhCL1pqWk4x?=
 =?utf-8?B?NlY0VXhkV0I4NExzNG1FaDVEVCsrVTMzck9ocGtuejdvSUo3ZFJiOEdmUm9j?=
 =?utf-8?B?eFp1VXE1YVFzV1pXVy9Pa1o1b3VwWmErS2VpTVh3REMrUWo5L1Jub3JaTFJt?=
 =?utf-8?B?QzhNNkJuVVhaRXFYeTY1bEViZkZTWTFoUlVlRGVJYTB6dkIxQi9XdnFTaVhS?=
 =?utf-8?B?V3ZCbE1JTm8wWU5ud2p6SCtMbW5uOG05OEJ2N083TDVUSzBIYXpJekh4cWdL?=
 =?utf-8?B?ekhobGJUWk5Id043ekVta2NpMEVDazJUOFlHb0lmUkhvc0hMcmV3OWowK1hM?=
 =?utf-8?B?VndPMTRVNm9TODVGNy9XVkZIWWJVY3M1MjFISmJZeGxGMVArRFdWdmJjaUEy?=
 =?utf-8?B?bzJFa2pURXgwRkROeVdRZnhGdUdwb1R4VHNyZVVRTXhERGtjVEhITU43QklK?=
 =?utf-8?B?citvdldIdlZ5b20vam4vcFVMbHpNUUMwa1NOQzdMME9MNnQ3QXZOd2dHcU9U?=
 =?utf-8?B?NGF6OGQvcktBdVRueTAybDhySjVHdzRDMUprQ04rV2tRNHNDQ3h6VWdZUjM0?=
 =?utf-8?B?bkplaGxBKzVOOUwxbXdNVldqUloyeWliSHVLbEx5b0pZQkg2OTdkNW1iOWNz?=
 =?utf-8?B?VHJkclcrUGUyVTkzVGJJNmNrZGE5SmFKNFBCelg0RGExY0V2WHJxbUV3dFVu?=
 =?utf-8?B?YVh3c3VwV2ZmajRpc2NYUnNwN2dmQ3ZqZ3pJR3IrR2dTQU0xWExjRzYzZEpy?=
 =?utf-8?B?UHk5a2Z4dkR4bUI2bUtRZW93ZmRLVlE0bmtRZlpsemsxclFOVjAzdlA2T2pq?=
 =?utf-8?B?RzdNZFNoVjB6bCt3YlI1eTBMYTF3VTNFSGlMNXEwS1BWSzNCa0dHZVlNYXpY?=
 =?utf-8?B?YzBNQ09QRUI0SVhtT1VNdG1OZ0FDRFVqTlM1R0JXQ1FHbUJBNmpDcGsvYVg0?=
 =?utf-8?B?NjVWeHF1Y3JGNno2YzdNUllNV2FkY3pEWnVnTkRmanZwWG5EcFRBRDdscmpa?=
 =?utf-8?B?ZGhTSFI2MnE1R3RXTUdxbTFUd2Jid3owMkRXR29YQzdvSk10Wnhpcmdoa3NI?=
 =?utf-8?B?dWY1SkJZTDFJU3EvaHBmNVdEM2kybG1vM1pMclhrYWczaDVWbkNrdXpkMSs4?=
 =?utf-8?B?M01HVVFVZEVpQWpQWXljTHgwR2dlU2RhcDVYUm10dFRQMVlicTZuUzVCOGg2?=
 =?utf-8?B?STFRM0xHV0gvdlJ0M0FSNzdFbGllZ2V0cWIrN25sdXA0UXJMbmlha1RSSXFv?=
 =?utf-8?B?aWIxT29sN1Q4VC9KOXJqb2ljU1UwV0dmUC9pQ1VGbDBGMngyODYxWkQwblla?=
 =?utf-8?B?NXd2ekovQk0vYUUvRUdLV0UyZVo5cFB0Y3FMb1pOajVHVU85ZDhHc0FpcGpl?=
 =?utf-8?B?aGhIU0FkOXVQak9hZ0lwdlJMNld6c3JmZ2RHSXF4ZWJpaTZSQ1JjNHRlcElt?=
 =?utf-8?B?bnlTQkhjQmlWTDRWNzEzRENmOHNIclRxaTNYSmhsa0tvYWFGZnpWR1R6NjBH?=
 =?utf-8?B?QTZmZEFlaEdZNUxqQzhkejEyVkNibGJFVjBWcE8reVd1RXhYREJka05CVmEx?=
 =?utf-8?Q?CcVE/bqoN1ujviA89fUZS56Oavb6MU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVk4SGpGSHhRSTZwUkpZQjVCb2UyNkM0c3BJWjVSb3N0L2J1WlQwL2YzbDZl?=
 =?utf-8?B?Yk04b3NGNEdmaW9aZ0I0eXBUaHltamtnbUwrSU54aDYvVEdwdFoxTzZYZmJq?=
 =?utf-8?B?Q2lYdW5oUmREcHdIRlJlWVN0SXZ6a0Y2a2xWNGdBYTRBUms3QW5ETG81Ulp0?=
 =?utf-8?B?Q0V4U2VTbzJBUk44UUNubmZRRlhoeUt6eitBV0Z3WC9RQ3V4SXUrMEJJMmdh?=
 =?utf-8?B?dTlvdk8yN1Y3UUtwSVVkak9wUUxBRG9vWVdzSUJHZjdiNTcyMmpxTTFkaTdz?=
 =?utf-8?B?Y2k2Zm1aRjdSL0VEdjVFcml3S096TkdtbHprdmNkMTlYZERtaThzQnFCdUZM?=
 =?utf-8?B?L0EzOHRKeEtrTmJnc0dXRkprRmw1SVd1L2hmQm1RR1JrWEIwZURFSW9XdzB2?=
 =?utf-8?B?QjlGQ1FlNVFqZGRSTnhpUFA2M3JFdi8wRXJQTGxXSUNsNVQ4Ykp2ZzZZWnMx?=
 =?utf-8?B?RWpmSkpFNjNBbGExNUFaOFpZSzZoRTc3QVJjNDA5RDlDYkhtQ0ROaW1xT1VZ?=
 =?utf-8?B?cGxOeVNlNFdKZWpBZVJ5OGFMMmI1NWpRQ3UyQ1ZqUXJORzhHeGtLNDBqb3JP?=
 =?utf-8?B?RXl2bkZxK3lCWktGbmdTRm1RQmNnMlp2U2RSRERaNkR2WUUxUFY0NHV5OHp4?=
 =?utf-8?B?QUpZTVNqVUprVHJsQXhFdHc0K3BZLzJjMmJNYURxbHpSeVpteTh6amRoYkVB?=
 =?utf-8?B?Slpyb2VWOEVzeXlxVlVUelhoRnFhOGxoZWl4aHdwaGNpM0JBOEMvd01HSnNr?=
 =?utf-8?B?R2t2Qk9lSDRyS05ZcXhwNFZGOVd3M1ZKSVdlRUY0YXJoNjNnVWsxZU9NSnRI?=
 =?utf-8?B?OFVkanJBeFlLQ2t1YmlmRXRWVUpqQUxnRDJLT0JsTnE4ZTA3dG9mOUd0MUNZ?=
 =?utf-8?B?aG9Ja2toRE1qUlBJRjBtSVc2Y0dTRE80MEpVZEt1NmRCVHZ5M09OUEZOUEVz?=
 =?utf-8?B?VGljd0U4QnhaNUtIWlMydEp3NG1LcG12dFd2cHBTUjdIZy95dnNaZ0l3UzJw?=
 =?utf-8?B?QTh5eXVWamJyNGZ2dVZWZTRYUEoxYmozK2VOc0dtTHhnODRNb09SNDhOTzVM?=
 =?utf-8?B?K1B0Y2xBdUZWUWRNSTRINlNsM3g0YURFUStuUDVLZ0JzT2JpVXlmWHZUSk1x?=
 =?utf-8?B?UlVpNUcxT3cxMVo5NCtCSXJhdEpuLzBQV3hPZjVNTmF1Nm0xMlhhelREOXhX?=
 =?utf-8?B?TEtnWFdOTFVkRlpZMktoN09XUmJPM2tMMXpVbXBnY09MSStncVNqN3pCa3E4?=
 =?utf-8?B?YVhaaEJHQ0xzRVBNTS82TTVYUjZtaDYrU2h0Z1pUVTBUSUZaVXk3ays0OW1r?=
 =?utf-8?B?ZHlEYTZ6Rm1uMzNhRUtNRTBHUXBDZWE0YXFleXBDMGxmS2sxSnhCWjNwSWNa?=
 =?utf-8?B?cnQvejZDcWlubWsrWTFnRlY3aXVqK1N2anp1Z1J6b1d5OHFuaWhtK25qcmpw?=
 =?utf-8?B?MEx5WXVScFVocHRBOXo5UEJDTVV0ck9Bdnl0RVpKclByN0FYQUp2ZzYzSGRr?=
 =?utf-8?B?WEVjUXh5NUFDUlV3U2FjSjgrZGVUY0NyOUVmRkIxcUp0eXZKMDNtV21BYTN2?=
 =?utf-8?B?R2FTL3hPSmZmT1R3VWlMem9tOWwxbU15cm1zcytFNHo4OTNUdVdGcStIckxQ?=
 =?utf-8?B?U2E1YllxOS9mL05xWUVyamJiQzRhUW1KYWkyK0R4Z2pnSkprSG43VGtSeEp2?=
 =?utf-8?B?WkZzNTZwTEFOVU12TDFKWHUxWTZSMUtFT1NQZ3g2aVpZN0FrVDl0bUpwalc1?=
 =?utf-8?B?SnFBZExGSUpyMmw0aUNQSGdTL1dhS1pxR3Zvd01CZGRnbUJzQ1kvdDlDdFY5?=
 =?utf-8?B?REQzZUgzRXdtTVhZVndTOVVDb1gzVGQ3akNyZWpMTi9GMnFRRUROY3BCczlr?=
 =?utf-8?B?djlNZHA1YS9WaEtRbnMycDA0R1kzZWpDaWE2SlRMelhvMG5qa0RzM2dMMENX?=
 =?utf-8?B?RTNRZnZrQU9CcTB0a0JLRXh3Slp5YUdyZkFCS2JLcW4vNVBEMlA5N2JrUlpt?=
 =?utf-8?B?YkY0MDk5RnZoVVBLbXZZWnVob0tlVXJNMjZzQ1kxalVoSHFnKzEvU0NWSTgw?=
 =?utf-8?B?RWNGa05NeENqbUdQTTRFZ05KUG5uakxkNGJqclpLNG55VlVEVzhUNVJ5Tk9x?=
 =?utf-8?Q?Qw4QnqBz5NMIhNQ6ypwIp1ytW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe9a6df4-9c9d-455d-8a56-08ddb5971689
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 16:24:27.8737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pp6oEwWAcT34k23NFs95yt8vISxfM5V7ih76IQPqVL1Nbrg/1wv2rsxbMdrQR2X0B1EUAn6c554PMpEoKnpFkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5264
X-OriginatorOrg: intel.com

Pj4+IFdvdWxkIHRoYXQgbWVhbiBubyBvbmUgd291bGQga25vdyBpZiB0aGUgbWNlIGFkZHIgaGFk
IEtleUlEIGJpdHMgb3Igbm90Pw0KPg0KPiBVaGhoLCBqdXN0IHN0b3JlIHRoZSBLZXlJRCBzZXBh
cmF0ZWx5LiBIYXZlDQo+DQo+CW1jZS0+YWRkcg0KPiBhbmQNCj4JbWNlLT5rZXlpZA0KPg0KPiBQ
cm9ibGVtIHNvbHZlZC4NCg0KQXMgdGhlIG9sZCBzYXlpbmcgZ29lczogIlNvbHZlIG9uZSBwcm9i
bGVtIGFuZCBjcmVhdGUgdGhyZWUgbmV3IG9uZXMiLg0KDQoic3RydWN0IG1jZSIgaXMgaW4gdXNl
ciB2aXNpYmxlIGluIGFyY2gveDg2L2luY2x1ZGUvdWFwaS9hc20vbWNlLmgNCih2aWEgL2Rldi9t
Y2Vsb2cpLg0KDQpTbyB3aGlsZSB3ZSBjYW4gYWRkIG5ldyBmaWVsZHMgKGF0IHRoZSBlbmQgb2Yg
dGhlIHN0cnVjdHVyZSkgc29tZSB0aG91Z2h0DQphYm91dCB0aGUgaW1wbGljYXRpb25zIGFyZSBu
ZWVkZWQuDQoNCldlJ3ZlIGJlZW4gc2VuZGluZyBhIGNvbWJpbmVkIGtleSthZGRyZXNzIGluIHRo
ZSAibWNlLT5hZGRyIiB0bw0KdXNlciBzcGFjZSBmb3IgYSB3aGlsZS4gSGFzIGFueW9uZSBidWls
dCBpbmZyYXN0cnVjdHVyZSBvbiB0b3Agb2YgdGhhdD8NCg0KLVRvbnkNCg==

