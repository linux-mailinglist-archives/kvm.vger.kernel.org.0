Return-Path: <kvm+bounces-25510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA01E966042
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:12:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6040D281138
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:12:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2228B1946C4;
	Fri, 30 Aug 2024 11:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dd0v8FpL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DDD718FDAC;
	Fri, 30 Aug 2024 11:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725016177; cv=fail; b=h/IO7hazE6dbYEJnM0SEkJ2oc+W7Ps01LF2iZcPSLrs7q6UrwFpAPLH760WJW0yWybW9Gi+bCqwECRcRvhJ2rP42huEMzTpZvEZnd/rWlOC1wjdFhJz/3dq+jzqTyb/mQ0m6rEqIyO/h5Ea1cXQHnLqcQPUzj1cpXgY4+ng0PsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725016177; c=relaxed/simple;
	bh=uy1AZBjBm+1WzvQxLTjkc+MJ0kGFiAfQ/isT9K/ngPI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WK/AJoP5D/SyL/i71KeaT5HvldZitI5HCNSTAYvT1TNgnH14rol38Y2Dc+TeBiZ/Muxmgs6Vq8j0YbdwuLyVVe2VtOHr3pzIbj6MQIVP82Ey6ppsxPPjO99Q3XpuaS83oYe+ERHVIPO8klRAES+PiCLINj2iWreJfufhIC6B8pE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dd0v8FpL; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725016176; x=1756552176;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uy1AZBjBm+1WzvQxLTjkc+MJ0kGFiAfQ/isT9K/ngPI=;
  b=dd0v8FpLUO8tK/blsNjb6r0NET2rqagAHlrQZr2XuX9+BLXnEa6O8quD
   rhviaRBs7qVBcPL96ju4hdJMG/gd9ZMXhFvAtrpmanlConmjyTgo213Ej
   HE1WPLKI7M8dg76Isk4QfhX+NpMDPl8HSCfwlx0GVZDMMmVt9cixs0WEH
   aQWkGbRZvnYiCzzlVK+n4QkHf46eJ1WTe8f468LwHeD268B18N3uvwwov
   QoCm6oElU8dm6xUogQ9KeEUw0stCQqvg5kFr8GghNvB8z0Qp6YUOpIPp1
   vsnrRF3XcaxsVNJGaBfSnOjmjxl+fA9/mUrCy31qKTIndH6TXFsuIAuo3
   A==;
X-CSE-ConnectionGUID: xeeTgVlxScq7VmCRSC8oJA==
X-CSE-MsgGUID: 4ZUVHDrLTeeGBiddujRZRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23609626"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23609626"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:09:35 -0700
X-CSE-ConnectionGUID: NaIPElXtQWej6bVrs9NoLA==
X-CSE-MsgGUID: +JEhs9t8Tsi9ZCIiyt4LCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="94603182"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Aug 2024 04:09:35 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:09:34 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 30 Aug 2024 04:09:33 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 30 Aug 2024 04:09:33 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 30 Aug 2024 04:09:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xq8PSZ201p8oczI1smLLT9lLlKxRNp/VEesPqNr3yP75MLlRRmDRSggbpkV9oAflE7Qesf1wpYCPmayTWv6/oRAdanUkUw7yqw9GkxgBP7FhF8ASzCCKEcHuCcmwgo7IP5ZnfI2yw+UtPb5OehEUE6MtKL9js9pSEFP6QZn2/sPRFDAAFWQKUdUJ+cNYk807fo2ZFN0C9JE0DC/JGjMgICcj/l9sBYzEneTMDgvE5iBgiU5nvnOxZGbRRENBCaiz6ZQHp+6v4cbLqUp9oQ5p69mIZgUAL8zDfsb6LFQ8hpkNtnk1fblVYhKjMk3TT7e8tzW1FW1dr5FkjwOGuL71Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uy1AZBjBm+1WzvQxLTjkc+MJ0kGFiAfQ/isT9K/ngPI=;
 b=N3JwT5PhTdxA+Y7P3FUbeY2VCYSEte7XFokIkWDWcf98Sl/9rqKc8Cj7zk91NAiujW8/icXF8zW9RUxRuuDamnpgmVqJmookIJ6vAeGyBAarHWLClEi5ssE71/IaZ3/FRoSkc0kNwEwshHsJxToPXGDom3p3cS0yT8mxf2Y4t8AGJI7wApQT5YlsGn+lY8Eo8fOW24hdOLFBFj4rym7YZ98LV98P/EaMZr4SezNA4YXL5xeTwLzlW1ywhSlGyVvT6BjgykpWAHnKolyr4C9yB3ZJCuVZ2z+lcz5TlSongUErxx1MDjU12tJ3cApXunaNVsmw06qV4+/JVhYfYV2cQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB7488.namprd11.prod.outlook.com (2603:10b6:806:313::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 11:09:31 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.019; Fri, 30 Aug 2024
 11:09:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHa+E/xnJeJIU2HBUe1bw/wL2vrsbI/htKAgAAiuIA=
Date: Fri, 30 Aug 2024 11:09:31 +0000
Message-ID: <fd965db365b08bd88179318bef30c5de15542699.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
	 <de4e1842-1ca2-44aa-b028-359008b591fd@suse.com>
In-Reply-To: <de4e1842-1ca2-44aa-b028-359008b591fd@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB7488:EE_
x-ms-office365-filtering-correlation-id: 8498223b-db8b-48dd-e6b8-08dcc8e4392a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q3g3WnlTdTh2NVlJeU9sbmFXbEpvNVU0WUNBaURXNTk5Z0gzOW0vcTk0c0Uz?=
 =?utf-8?B?K3FCVE4vY2pnajd6N0ZJdXlYSUZQYUQwam13WlhkNXRiRHJSSFFaSEhCZE45?=
 =?utf-8?B?RU5UamlZN2hIMFNpdVVOVUpYdU1kU29QL3crVFJzeUlMRmdJaUVpZlpsV2N5?=
 =?utf-8?B?eVcrQU9Jc3laelUxR0Rzb1hGNHpneFVnV1o1ZWtPWnBjOERjd2xhMEdtSnhN?=
 =?utf-8?B?Y0dwTlUrS2xreEpZKzRWOUIxRFArd2JUS2t0VS8yVVIxUVRuOXZJVmdqbWxm?=
 =?utf-8?B?S3RRNVY5MjVvREFTTks5a0RKZXdrY080SG5adVNZcDY2NllZMlNGVEVabWpZ?=
 =?utf-8?B?VXgwZWt0UkFZQS9WTWNSb0d2YWY4c3BMMHRzZUhNNXF4YitMdnBRQ20xeEtO?=
 =?utf-8?B?L2U4WjVuSW92aVpVVE9mbW1ERTlyZnBwZ3AvbFlwVWVIYmExazBwZkpBcmxt?=
 =?utf-8?B?MytqYU9iT0VJUDhPMjFpVkJJR2dDV1VlYTlvV0hnTFowbFkvYk9INXFWSVRJ?=
 =?utf-8?B?TVc2Smt0VmQvUUpYRjZhUEhWcUs5WktHWVBDSURzY3NwWlh4cmtIaG5idS9V?=
 =?utf-8?B?ZmJPcWp5ZDJaOHY5VnVxeG4wQVVxZlFpZVZQRSs3RTk3TTRMQXl6dnYyT2xu?=
 =?utf-8?B?eFZsOXZNaU16NytTZkZoWE44UXdtekNNd2l5R3J4Rm9tVlROSElPTFEwb3NO?=
 =?utf-8?B?MXBNZ1I4aVJjbHlvckI0T1dqU0s5NnU5d21MTC8zVnBzVWxwa0ZJM2hnaHEy?=
 =?utf-8?B?Mk1JNFZvdkVLMU91elhIOWpsMEpxSzJtdG5vUWJiRk9zaTM0WkJrdEdrWXJo?=
 =?utf-8?B?YXg3VEVIQTU0ZmpGNjFWTTVMcitYQ1ZZcklvZjNyTGNtU0lEMDFyZXRLUitF?=
 =?utf-8?B?SGtTTTJxSm1Wa1JZdGdaRzJwZ3E0Q1QvZVhsZXc0WEVZVzZwM25BRFBKTjlh?=
 =?utf-8?B?L1gxN3lyaTBSTjdiaXBDTWpnc2p4aEl6RVRQRmQwVTVoaWlJeHk2MnFrUHpv?=
 =?utf-8?B?ckc2cklaVCtVck5ONDBWY0I3Y0F4RVlGcWVNTVlveWUxYnc3TVlQZkJHZWVi?=
 =?utf-8?B?WUdmWHNmdEFkdUNNWWs2U3phNEJtOFNLZkhSc3BaTEx3eGRxdFpsUTJHVVVE?=
 =?utf-8?B?Y3kydm1UNjlrYzExWXlaaGgxeTlSVnUzald1LzAwNngrcitkZTFNQVB1NXRT?=
 =?utf-8?B?UG96N1RFbllFM1NlNkZGelVtR01acnJZanhadmpFMWZFZkxNelYzSVQ3RGNM?=
 =?utf-8?B?K0FuWHY4U1VCOG9EdU1vMUg1NENvZ3gyZkM4NDBsczlYZ3pMM1N1eGxkK1JD?=
 =?utf-8?B?WDU0anNTL0lVaExZY243RGdjMWk3S3pQOXZBUksxS2ZVdUNMM251djlUQzhl?=
 =?utf-8?B?TkhyUzBuTWg2M0QzWUNWVDV4d0RNSEhSOFlFaUpORktmeVk4VW5pSjliSGEz?=
 =?utf-8?B?ZUxrWExPdmQzdWxmM2FTQnkwT2hrV2VLVXRBT3I5bVE0QTJQRk5sb21BZW5r?=
 =?utf-8?B?YkpCa29WVVhyS2RkeTJUQmpnNURVSWJWT0kwcXM1OUFHMjNNTjJObGhQMHlQ?=
 =?utf-8?B?dFU3eU1YWjU3c0JaZEJ3TmUvVUJPZExFYmdUbEdsdDF2R2VTT2N3ZVRkNXpu?=
 =?utf-8?B?c3N6VlpHN3hZeEJVZ1NHZFhTNjRXWnpma1p3azdCa1Y2K2I0MzJrNVNQcHFl?=
 =?utf-8?B?TWRxQXlwMjllM3o0WFUzT0hwLzU0VDVvS1B2Z20rb09TcGc3eFJQdStIRmFz?=
 =?utf-8?B?VXY3b2MzclAxWUhPQklRS05Ybnp5WERuRFV5bHdJYXdmdy9FcHdhMm9wV0ow?=
 =?utf-8?B?STZwOUgvVmZ2QmRKL3pNMFhOWTVGQkpSeUluRFVGdjRlb2YvL0w5NW4weEpP?=
 =?utf-8?B?d21YVTh4K0hIRG13QVovTjA2ektvVGt6S3BYblMrUzFOdXVFZzdUZjJYV2x6?=
 =?utf-8?Q?P0XlqTO0BdU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmY2aDJ5R3RCbVcwaURzZDZweWFpSmtWTEZqS2k2SC95MVpGeFNNbUlxTjlW?=
 =?utf-8?B?eEwyR0NLeFY5NkhxU1MybEZmeGRCSmIrM0QxcTVkVjdyWFMvdXNsdXhEUHp4?=
 =?utf-8?B?eXQvOVdPdGNPQ00zMWE1SU1DalF6b2l3bFRGNnF1YjBOUFRxZUtlNnR2OUVa?=
 =?utf-8?B?Y2Z5WXdlaTBITFBQSzErcVhubnFwMk81UFVxQWhGS1lKbU5aelBMQUpDd3JL?=
 =?utf-8?B?Ty9ZTmZHSmp0SlQ3bFJITVRYK2xCeWJ6UElrVFVEdHc0MS90MzlUM1FRVGFL?=
 =?utf-8?B?d2lIY2k4SzZEdU5FQjM4SG5vMUtCUkhScXFGWFBHd2I1TGVFZkxSTithTlBp?=
 =?utf-8?B?K1BHMFJLeDZ2OUlrcm9rc1A1MEhPK0JMZUNxQ2dmMVBZZ1FjQU4zQzVhSVl0?=
 =?utf-8?B?QUxJczgwQ2ZEWTJKZDZVQndlakF5TGVBTmFSUDFuTUdHampiRUh3ZDBESXBr?=
 =?utf-8?B?SFA3N2VXcGFYSFB6NGRZWWVsUjlsVC9vS0ltVHNub1hpU09ZbitqNFZ4aGd0?=
 =?utf-8?B?QWVYVFJJVi9lSUpZTU5ORUxKb080bXdvZGUwWnhwM1pMQUF1Q3ppWjQzdFZD?=
 =?utf-8?B?UHJNQjZDc3dkSzN4MUlCbjVBNno2ZkJXajJHanBCUUlQZUNmcHlvSEJRaGds?=
 =?utf-8?B?dWZET2xiOWVCQzN4K0ZhaEZJSnhUdjFnZHc3dEJnclhXQVdWalA0SE4rSmNa?=
 =?utf-8?B?NDhkbE0yZldvOGFEa0tNY1p4U2hKMHAwVFlhUG10OVgxbFR4R1VmYnUvQVRQ?=
 =?utf-8?B?Zm1Yc1RyaTIwT1NQSmRnSEFCYjJFWStQNlZlSVIxbXZOdEl1d21yL3M0QTBx?=
 =?utf-8?B?U2ZzVGZUeEtFZG9HejNOZXFzUWRPM2ZCaHlTZjUwMXFCeWwxWjhjTjI2SlU1?=
 =?utf-8?B?TmhsNkJ0RmQxdFR2K1QwWG16MjFRS3VoSmFlM1FXNzlsKzJuUjVnNXAxSUxB?=
 =?utf-8?B?MFE5a0hxNUtUVnpZZmgxeTJtRWIxUklTSDFjV2lVbWx3MEd6QmZXQnZOR253?=
 =?utf-8?B?ZFFOcnd6U2tEaFFDeTN4UjVzeSs0K0RnOXVOZHpkckVjOHBnYUdqcTBlSnZ6?=
 =?utf-8?B?VVJEYVlhV0RCT2NjRDluSVE0bmIreTRHTWJwMEsvdmM1by9lcEdkTXY2RUNz?=
 =?utf-8?B?dEwwZERzMFQ3N05oZ0xqeTd4Z1V4VjAvV0c4bU5ZMlQveE10ZnZrckQyWGdu?=
 =?utf-8?B?MFYvbVNQazVlUEZLN3pFaXNTd1NmWFhpcWF1WitlVnFMQXNRSVRyTEwxa01n?=
 =?utf-8?B?S3IxRUI2V2JOUzYyV3FFd0E4S29lajljNHhhc01aYzJHUnZxQy9TRHBXa2pt?=
 =?utf-8?B?SksyUVpxaGtuK2dQM0RJQThwQUFGTCtpNTlSS1UxT0RRdnZQMGRkZzhyeVVW?=
 =?utf-8?B?VHRJdWNZRFFDYVcwQUxReUp3N0dUOUttemhDQjFheDZBaVpqWjFlb1pWemQz?=
 =?utf-8?B?b2xNZndldmZETStqVEF3eDFCR1JiV1VUM3FOSDVZbEV2b2VOR29kenJJMElq?=
 =?utf-8?B?Q0Q4ZnYxRCtCczlYUGdOVXVQSXhCVFpFL1MwbWVtbU5OczRYbVlWTXlyVFky?=
 =?utf-8?B?a0txUnpad3d5UTBHbXN2UDNsbGhUajllK2NsRXV3eWNMUlJNWEsxUW53cHh1?=
 =?utf-8?B?TXJVVG5lL2pMUkx0Uy8zbkErMjFNVUVRODR1QWM4Z0dWWm1QYTg5akZXUUx1?=
 =?utf-8?B?T1VrdzlrMFI2bExzMmJIV2szWnpIUVJZOHZ0enl2UnNKbWxuN2tPenF6ODlP?=
 =?utf-8?B?SWdnMnZmUzlydExMMEQwT1hzVUpzUFNmblJWU0I4UC90b290VzhBelNwNnBy?=
 =?utf-8?B?UXp6Vm9tN0loYTNQaCsyZWpSM0dQcTFJc05qRDNoVklQZlpnQUtpbUZBSDBq?=
 =?utf-8?B?cG9MTERLcXlKalJRWjJScHVmUlYrNUtjcWpsaXFBaCtET1EzUUhQcm5hOXNH?=
 =?utf-8?B?R1Uwak1NcFo1U0xZQ0Fwdm5JRmU5dDRGOWtHZ0lYV2RFN05meGk0RWhqY1VM?=
 =?utf-8?B?Z3B0VGl0bnU4YkU0YXpldExrVWlRTmQ5aFpQdWdaOHd0bUcvVkhjcDB4S2FY?=
 =?utf-8?B?Y0JteS8wd1E1UmNURTQ5UDU1dTlLcG1HTUVINENlajFPTXpxaEMrY1pZcHFG?=
 =?utf-8?Q?oBpLoKy38pGth+TfyB+jpEUNr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8734664E3E0C5A42A39D8ECE5E131BD7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8498223b-db8b-48dd-e6b8-08dcc8e4392a
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Aug 2024 11:09:31.6868
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WkPg8NFgGFJR3dmkSNTOKLGdknZA7anrenmMOH2rYwBM5eBUJCcp+hmX5zCxqnpej5hdAxT4nSmwBaY2BXKHQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7488
X-OriginatorOrg: intel.com

DQo+ID4gLXN0YXRpYyBpbnQgcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQxNih1NjQgZmllbGRfaWQs
IHUxNiAqdmFsKQ0KPiA+ICtzdGF0aWMgaW50IF9fcmVhZF9zeXNfbWV0YWRhdGFfZmllbGQodTY0
IGZpZWxkX2lkLCB2b2lkICp2YWwsIGludCBzaXplKQ0KPiANCj4gVGhlIHR5cGUgb2YgJ3NpemUn
IHNob3VsZCBiZSBzaXplX3QuDQoNCk9LIHdpbGwgZG8uDQoNCj4gDQo+ID4gICB7DQo+ID4gICAJ
dTY0IHRtcDsNCj4gPiAgIAlpbnQgcmV0Ow0KPiA+ICAgDQo+ID4gLQlCVUlMRF9CVUdfT04oTURf
RklFTERfSURfRUxFX1NJWkVfQ09ERShmaWVsZF9pZCkgIT0NCj4gPiAtCQkJTURfRklFTERfSURf
RUxFX1NJWkVfMTZCSVQpOw0KPiA+IC0NCj4gPiAtCXJldCA9IHJlYWRfc3lzX21ldGFkYXRhX2Zp
ZWxkKGZpZWxkX2lkLCAmdG1wKTsNCj4gPiArCXJldCA9IHRkaF9zeXNfcmQoZmllbGRfaWQsICZ0
bXApOw0KPiA+ICAgCWlmIChyZXQpDQo+ID4gICAJCXJldHVybiByZXQ7DQo+ID4gICANCj4gPiAt
CSp2YWwgPSB0bXA7DQo+ID4gKwltZW1jcHkodmFsLCAmdG1wLCBzaXplKTsNCj4gPiAgIA0KPiA+
ICAgCXJldHVybiAwOw0KPiA+ICAgfQ0KPiA+ICAgDQo+ID4gKy8qIFdyYXBwZXIgdG8gcmVhZCBv
bmUgZ2xvYmFsIG1ldGFkYXRhIHRvIHU4L3UxNi91MzIvdTY0ICovDQo+ID4gKyNkZWZpbmUgcmVh
ZF9zeXNfbWV0YWRhdGFfZmllbGQoX2ZpZWxkX2lkLCBfdmFsKQkJCQkJXA0KPiA+ICsJKHsJCQkJ
CQkJCQkJXA0KPiA+ICsJCUJVSUxEX0JVR19PTihNRF9GSUVMRF9FTEVfU0laRShfZmllbGRfaWQp
ICE9IHNpemVvZih0eXBlb2YoKihfdmFsKSkpKTsJXA0KPiA+ICsJCV9fcmVhZF9zeXNfbWV0YWRh
dGFfZmllbGQoX2ZpZWxkX2lkLCBfdmFsLCBzaXplb2YodHlwZW9mKCooX3ZhbCkpKSk7CVwNCj4g
PiArCX0pDQo+ID4gKw0KPiA+ICAgLyoNCj4gPiAtICogQXNzdW1lcyBsb2NhbGx5IGRlZmluZWQg
QHJldCBhbmQgQHN5c2luZm9fdGRtciB0byBjb252ZXkgdGhlIGVycm9yDQo+ID4gLSAqIGNvZGUg
YW5kIHRoZSAnc3RydWN0IHRkeF9zeXNfaW5mb190ZG1yJyBpbnN0YW5jZSB0byBmaWxsIG91dC4N
Cj4gPiArICogUmVhZCBvbmUgZ2xvYmFsIG1ldGFkYXRhIGZpZWxkIHRvIGEgbWVtYmVyIG9mIGEg
c3RydWN0dXJlIGluc3RhbmNlLA0KPiA+ICsgKiBhc3N1bWluZyBsb2NhbGx5IGRlZmluZWQgQHJl
dCB0byBjb252ZXkgdGhlIGVycm9yIGNvZGUuDQo+ID4gICAgKi8NCj4gPiAtI2RlZmluZSBURF9T
WVNJTkZPX01BUChfZmllbGRfaWQsIF9tZW1iZXIpCQkJCQkJXA0KPiA+IC0JKHsJCQkJCQkJCQkJ
XA0KPiA+IC0JCWlmICghcmV0KQkJCQkJCQkJXA0KPiA+IC0JCQlyZXQgPSByZWFkX3N5c19tZXRh
ZGF0YV9maWVsZDE2KE1EX0ZJRUxEX0lEXyMjX2ZpZWxkX2lkLAlcDQo+ID4gLQkJCQkJJnN5c2lu
Zm9fdGRtci0+X21lbWJlcik7CQkJXA0KPiA+ICsjZGVmaW5lIFREX1NZU0lORk9fTUFQKF9maWVs
ZF9pZCwgX3N0YnVmLCBfbWVtYmVyKQkJCQlcDQo+ID4gKwkoewkJCQkJCQkJCVwNCj4gPiArCQlp
ZiAoIXJldCkJCQkJCQkJXA0KPiA+ICsJCQlyZXQgPSByZWFkX3N5c19tZXRhZGF0YV9maWVsZChN
RF9GSUVMRF9JRF8jI19maWVsZF9pZCwJXA0KPiA+ICsJCQkJCSZfc3RidWYtPl9tZW1iZXIpOwkJ
CVwNCj4gPiAgIAl9KQ0KPiA+ICAgDQo+ID4gICBzdGF0aWMgaW50IGdldF90ZHhfc3lzX2luZm9f
dGRtcihzdHJ1Y3QgdGR4X3N5c19pbmZvX3RkbXIgKnN5c2luZm9fdGRtcikNCj4gPiAgIHsNCj4g
PiAgIAlpbnQgcmV0ID0gMDsNCj4gPiAgIA0KPiA+IC0JVERfU1lTSU5GT19NQVAoTUFYX1RETVJT
LAkgICAgICBtYXhfdGRtcnMpOw0KPiA+IC0JVERfU1lTSU5GT19NQVAoTUFYX1JFU0VSVkVEX1BF
Ul9URE1SLCBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpOw0KPiA+IC0JVERfU1lTSU5GT19NQVAoUEFN
VF80S19FTlRSWV9TSVpFLCAgICBwYW10X2VudHJ5X3NpemVbVERYX1BTXzRLXSk7DQo+ID4gLQlU
RF9TWVNJTkZPX01BUChQQU1UXzJNX0VOVFJZX1NJWkUsICAgIHBhbXRfZW50cnlfc2l6ZVtURFhf
UFNfMk1dKTsNCj4gPiAtCVREX1NZU0lORk9fTUFQKFBBTVRfMUdfRU5UUllfU0laRSwgICAgcGFt
dF9lbnRyeV9zaXplW1REWF9QU18xR10pOw0KPiA+ICsjZGVmaW5lIFREX1NZU0lORk9fTUFQX1RE
TVJfSU5GTyhfZmllbGRfaWQsIF9tZW1iZXIpCVwNCj4gPiArCVREX1NZU0lORk9fTUFQKF9maWVs
ZF9pZCwgc3lzaW5mb190ZG1yLCBfbWVtYmVyKQ0KPiANCj4gbml0OiBJIGd1ZXNzIGl0cyBhIHBl
cnNvbmFsIHByZWZlcmVuY2UgYnV0IGhvbmVzdGx5IEkgdGhpbmsgdGhlIGFtb3VudCANCj4gb2Yg
bWFjcm8gaW5kaXJlY3Rpb24gKDMgbGV2ZWxzKSBoZXJlIGlzIGNyYXp5LCBkZXNwaXRlIGVhY2gg
YmVpbmcgcmF0aGVyIA0KPiBzaW1wbGUuIEp1c3QgdXNlIFREX1NZU0lORk9fTUFQIGRpcmVjdGx5
LCBzYXZpbmcgdGhlIHR5cGluZyBvZiANCj4gInN5c2luZm9fdGRtciIgZG9lc24ndCBzZWVtIGxp
a2UgYSBiaWcgZGVhbC4NCg0KV2UgaGF2ZSBhIGRpZmZlcmVudCBpbnRlcnByZXRhdGlvbiBvZiAi
Y3JhenkiIDotKQ0KDQo+IA0KPiBZb3UgY2FuIHByb2JhYmx5IHRha2UgaXQgZXZlbiBhIGJpdCBm
dXJ0aGVyIGFuZCBzaW1wbHkgb3BlbmNvZGUgDQo+IHJlYWRfc3lzX21ldGFkYXRhX2ZpZWxkIG1h
Y3JvIGluc2lkZSBURF9TWVNJTkZPX01BUCBhbmQgYmUgbGVmdCB3aXRoIA0KPiBqdXN0IGl0LCBu
byA/IE5vIG90aGVyIHBhdGNoIGluIHRoaXMgc2VyaWVzIHVzZXMgcmVhZF9zeXNfbWV0YWRhdGFf
ZmllbGQgDQo+IHN0YW5kIGFsb25lLCBpZiBhbnl0aGluZyBmYWN0b3JpbmcgaXQgb3V0IGNvdWxk
IGJlIGRlZmVycmVkIHVudGlsIHRoZSANCj4gZmlyc3QgdXNlcnMgZ2V0cyBpbnRyb2R1Y2VkLg0K
DQpKb2tlIGFzaWRlLCBhbnl3YXksIHdpdGggd2hhdCBBZHJpYW4gc3VnZ2VzdGVkIHdlIGp1c3Qg
bmVlZCB0aGUNClREX1NZU0lORk9fTUFQKCkgYnV0IGRvbid0IG5lZWQgdGhvc2Ugd3JhcHBlcnMg
YW55bW9yZS4gIEknbGwgZ28gd2l0aCB0aGlzIGlmDQpubyBvbmUgc2F5cyBkaWZmZXJlbnRseS4N
Cg0KPiANCj4gPiArDQo+ID4gKwlURF9TWVNJTkZPX01BUF9URE1SX0lORk8oTUFYX1RETVJTLAkg
ICAgICAgIG1heF90ZG1ycyk7DQo+ID4gKwlURF9TWVNJTkZPX01BUF9URE1SX0lORk8oTUFYX1JF
U0VSVkVEX1BFUl9URE1SLCBtYXhfcmVzZXJ2ZWRfcGVyX3RkbXIpOw0KPiA+ICsJVERfU1lTSU5G
T19NQVBfVERNUl9JTkZPKFBBTVRfNEtfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1RE
WF9QU180S10pOw0KPiA+ICsJVERfU1lTSU5GT19NQVBfVERNUl9JTkZPKFBBTVRfMk1fRU5UUllf
U0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1REWF9QU18yTV0pOw0KPiA+ICsJVERfU1lTSU5GT19N
QVBfVERNUl9JTkZPKFBBTVRfMUdfRU5UUllfU0laRSwgICAgcGFtdF9lbnRyeV9zaXplW1REWF9Q
U18xR10pOw0KPiA+ICAgDQo+ID4gICAJcmV0dXJuIHJldDsNCj4gPiAgIH0NCj4gPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oIGIvYXJjaC94ODYvdmlydC92bXgvdGR4
L3RkeC5oDQo+ID4gaW5kZXggMTQ4ZjliNGQxMTQwLi43NDU4ZjY3MTc4NzMgMTAwNjQ0DQo+ID4g
LS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5oDQo+ID4gKysrIGIvYXJjaC94ODYvdmly
dC92bXgvdGR4L3RkeC5oDQo+ID4gQEAgLTUzLDcgKzUzLDggQEANCj4gPiAgICNkZWZpbmUgTURf
RklFTERfSURfRUxFX1NJWkVfQ09ERShfZmllbGRfaWQpCVwNCj4gPiAgIAkJKCgoX2ZpZWxkX2lk
KSAmIEdFTk1BU0tfVUxMKDMzLCAzMikpID4+IDMyKQ0KPiA+ICAgDQo+ID4gLSNkZWZpbmUgTURf
RklFTERfSURfRUxFX1NJWkVfMTZCSVQJMQ0KPiA+ICsjZGVmaW5lIE1EX0ZJRUxEX0VMRV9TSVpF
KF9maWVsZF9pZCkJXA0KPiANCj4gVGhhdCBFTEUgc2VlbXMgYSBiaXQgYW1iaWd1b3VzLCBFTEVN
IHNlZW1zIG1vcmUgbmF0dXJhbCBhbmQgaXMgaW4gbGluZSANCj4gd2l0aCBvdGhlciBtYWNyb3Mg
aW4gdGhlIGtlcm5lbC4NCg0KT0sgd2lsbCBkby4gIFRoYW5rcyBmb3IgdGhlIHJldmlldyENCg0K
DQo=

