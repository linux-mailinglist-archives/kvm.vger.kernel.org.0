Return-Path: <kvm+bounces-29174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4DA9A40FC
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 16:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8575B289663
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 14:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B33151D4161;
	Fri, 18 Oct 2024 14:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hQQ8ATZL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81A04C69;
	Fri, 18 Oct 2024 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729261253; cv=fail; b=Hu4mJToZGWlcNYL/9JP8Lzdl3Z4dHLIrgUboGogsMt2ZTfrHVbjYJfCFzK2zKS7Zam6AEyRASwQ8TSCP6RQOMF+rr4Dpjy09Yg7X3AC1WTcjm93vn/o7cPsqwQeVBQ2F78xzUNaQGIvF+/cU+lekTTZATZLF34QXTVP/lLzh9Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729261253; c=relaxed/simple;
	bh=ilrBMOPxZ/ByJJCJ362VPvJInHi8BYP77uvWFr0yvdQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fxD8+3QIwlGeev4AdN97xRiy4xMyfCZOAqT7bdc6pbEboDkiMUplijmZGYSdyzJxvZXWZOcLMNTrwOauuhGm+liTabR0ELz5RtLziLaPSKKHyNHRWg8wObcN7WWL+VTdc9s5aUjqb15+ckGgN98gbNjlKRYoNaZUBdxxT6sL8Lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hQQ8ATZL; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729261252; x=1760797252;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ilrBMOPxZ/ByJJCJ362VPvJInHi8BYP77uvWFr0yvdQ=;
  b=hQQ8ATZLR/Ac2mel3lxftQaZztvPgihaEKlJ72KP+9a0qwTkpE7JCHSp
   sRpN5WjFoYAx9uMkb0jN9ZqOq2MRHZKCVHxM0/8h6RD1chT7wmc7281/7
   rGaKdMdYnil0yj904sGToFJlmuU0puWfI9gFhJkfNsuc2cGr7AA14Y0Wt
   Iokgaa1As4b4VSoi1xqnQjNfXcm01wPkfSQL8UjmsZvBxbIFJpJFapps/
   FwYsxU3GZ+8BMzlcCAdG9SO65VcTo0PQ/Vk4E4ekuOc6cZB5St/eZWFJf
   9cziNZgTg/Fatjwn6i1UpNKBjOHtrHRD53/Y1HeRqv9ysJP5+DLK15SS+
   A==;
X-CSE-ConnectionGUID: m15uNGUZQQS0eh3Fhsh3dg==
X-CSE-MsgGUID: tSSoZSThSc2kxScBDX98VQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11229"; a="28885684"
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="28885684"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 07:20:51 -0700
X-CSE-ConnectionGUID: eDage6GxTr2oRVfcEYTbBA==
X-CSE-MsgGUID: t+q0ZSxwRjex8aFFqjojQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="109703299"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Oct 2024 07:20:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 18 Oct 2024 07:20:50 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 18 Oct 2024 07:20:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 18 Oct 2024 07:20:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 18 Oct 2024 07:20:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tt7OGCfF496Gt/DsFg/MtvXo0bkcbg4Ovq09JinAzYi0boXwZneRYYjO1LZoWVfY4b2wDfOmKjaZTa7xM+dIQohDi93eXltSB7YVCCVkuWE/pOtoHMH26ieRQuv1aVNXguDbLI1GKsZ904j5hu2PLjYHT1l27yLY9123YQxmAXIEW84BrVhI67a90LFSrjhrYkSdzPEvRnN2NEoWKWjK8Sv9di4cVbYzxKr0XdCuajHRVHyEmBEiM4D1d2/3MuF/0SyDw7YyxhBolfS8ughWSHMyV/BPfiXciJYanCDEM9Z+6MDq0IZGNhb2R85jsfO+5cGIau10q4Ozn/JcGjUj+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ilrBMOPxZ/ByJJCJ362VPvJInHi8BYP77uvWFr0yvdQ=;
 b=Z+9DrsHZZW01LRPHu6Pt0cbC4bu/3jT2MBYR4dvJZDpNUq3c1NDs1akFE5NkzA+eeQsU6W2T//LvqqGsQf3G5d3HOp+O/MApXkdP9EYIgFPyDxiEFdDX5ZcfBc90LLTMyDKABCtHbwWoWpjBYBPTr/3n6jnrzRRrK1H8Bu64SUsBHt+EI0s1RyhbcMhrn8nHdeIJZvc5jANm/jFPrTlH78Qx6aAJJPph3BJ/yLT1h/LjXhEJaenonWWzhG+y13tfuMmqqSwIuvmSflPiapcTaYLaMjNr9W/OPBjknGwczo/65ThjaptwHv3qfvopqxSbn+mpAITOxVQcJ7o+g0S6mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV8PR11MB8464.namprd11.prod.outlook.com (2603:10b6:408:1e7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Fri, 18 Oct
 2024 14:20:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8069.016; Fri, 18 Oct 2024
 14:20:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "yuan.yao@linux.intel.com"
	<yuan.yao@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Topic: [PATCH 18/25] KVM: TDX: Do TDX specific vcpu initialization
Thread-Index: AQHa7QnTM8YJSmcK70mWBvdOl91Ku7Ik046AgFoKj4CACy09gIACI3sAgADI7wA=
Date: Fri, 18 Oct 2024 14:20:47 +0000
Message-ID: <0136dbcb2712828859447bc7696974e643a76208.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-19-rick.p.edgecombe@intel.com>
	 <20240813080009.zowu3woyffwlyazu@yy-desk-7060>
	 <1a200cd3-ad73-4a53-bc48-661f7d022ac0@intel.com>
	 <1be47d7f9d4b812c110572d8b413ecdbb537ceb7.camel@intel.com>
	 <aa3d2db8-e72c-42e2-b08f-6a4c9ad78748@intel.com>
In-Reply-To: <aa3d2db8-e72c-42e2-b08f-6a4c9ad78748@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV8PR11MB8464:EE_
x-ms-office365-filtering-correlation-id: a91ba8fc-fcd8-4b80-9c61-08dcef800f64
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SVBsUmkzNldFSm8zSHBlZk9YbnduTkt6alVBSFdROVpOSkdUV29aclluQ0Zn?=
 =?utf-8?B?Z05zL3JjU1FaN2NsdHFUUmRRUjFvSE9VSVd2b0JRZEt4SUk1VmtxNDlvVWow?=
 =?utf-8?B?emF4aC93OGdlaFRCRUhub0tTVWwzM09PTXArREhKMjNUb2YxdUJ1WTFSSzd5?=
 =?utf-8?B?Y2hiamc0N2wzTUNtMnNnTHZUdFFOV3lPK0I3ajRENlZwYzVyQTIydkhEallB?=
 =?utf-8?B?S3VFQVVNbmhxY0FaUmVmQ0lVNmtiQUZlVXFGaS9xQzhHVnhHT1N0UDc2bVBZ?=
 =?utf-8?B?V3ZnK1lEbWlTdEhHT0hYZUkyNE04QUU0RHQ2VU5yWjdRT1dRREozMlp1d0RS?=
 =?utf-8?B?UHVqSlAvR1RWdnYwMDFCWlNvRFlJRnZ1ZTJWbldoS0czNGR1V3dRMisvajJ4?=
 =?utf-8?B?TzZndHRTUmVwN2lqaFNEYXNXR2wvV0JmTFFTMm4xNmhheEpTcDVyaXprTVJL?=
 =?utf-8?B?MHQrczZmeE1LOVkrdW9BeU05czE4LzBwdXg0MkNXczR2QWwvT3poWlZzdUlZ?=
 =?utf-8?B?RTVabUEwanRyZTk4c2E2QS9OOXk0M253dnVtNkptbVMxczM4K3piMWFDSVhE?=
 =?utf-8?B?S3o5RXE5NlE4TFJCZUduUjREYnRxbXN1Y3hiei9GL3FKM0tWcUlCaE5iYzhM?=
 =?utf-8?B?anQ3MzNEeWRaNTVOV05WRmY5TEtmMGk0a1kzdlpuR2h6TEtLaFlQR2g5Zko3?=
 =?utf-8?B?c1dCT2VMQkYwdUpqUHE1WWhtYlB6QnhrQjB6UmJNQ21nVEV3TDVVSVNQZGpj?=
 =?utf-8?B?UVJoS1JDNDFPWFM1a1kybWNKY3FleWVUL2hUMFFCUWxoekJ0NzgydW9TbzBY?=
 =?utf-8?B?bXFlK29YT0xNMGtEcnB0WkVUNERiY2l4TU5UQTBtZkVMTUNZUHFST243NEdI?=
 =?utf-8?B?L0xXa1BYQXVCZ0hTYlpsbjJJL2ZEV1ZjS2R5TXNUVmRYa2hsNjROUkNzTk5q?=
 =?utf-8?B?YkxDV2FIWVhWUGY2WGRzbEJiZXJEZ1hWNEZLRzYwV0FWSXBiK2FZN29NUzU4?=
 =?utf-8?B?MkxOTnhmMXNzRVE3U2R0Y3hOYmwrcWV4cDZtVDFWTmNmalJ0UzZOT1IxaGtC?=
 =?utf-8?B?REdzVm9YUUFxUWFVY3Z1M0Y1ZUFBM21kZVRHdHVMUGg5dTVUUUlWaHlhYUxs?=
 =?utf-8?B?Y1IyK2ZQckY3L1IvTmJMYStyN2VzUHRjazBDbUg0YXVJRmxZejV1cklNQzAw?=
 =?utf-8?B?Z1pHSitoMHpiK0NWNVB1eVZFbkc0Z2x4SEowSWRPYWpzQWdXZ3Jjd3N3dkgx?=
 =?utf-8?B?RzI5bnFPSGU1M2dKRm0wZ3czbkl0TjAzdDl2L1VoamJscW5wL290NGM3ZElH?=
 =?utf-8?B?cURYb1praU1DbFpYYWRnSWgxOXlqYUJwR1BpOHhGYnhtWVZuNXd0RnhFTGxy?=
 =?utf-8?B?VlRxblN2KzhGcWxrY1lvcm4wNlhrNWJPZTBMYUNxb2daUkw3bVo4bkVyVEVo?=
 =?utf-8?B?QTVBSVR0eW9KTHhNZFNySEZDR29wYXh4MTNWaW5tclB0SzdkUTZSMGhpY1BD?=
 =?utf-8?B?OTN0dUZ1V1lEQXBpaGxLUSt4T1NLWGQwdElNNStreHN6dzJuT01KOVUxaXpi?=
 =?utf-8?B?Z1IrZDB3RDBqZnkrOVkwZEhLYmgrUEtob1RCVVBLZDlPcVAwdjl6QjBESjJV?=
 =?utf-8?B?TkRRUXVlemg5ZUNhS1pJMXpKbHI0eFpwSm10VWgyV2ZmMEJYQkpDNWlIYlY2?=
 =?utf-8?B?Y0lVWE9nNWFVeVVZdHMzUEc3bi9wcDc3TmJudTVlV1BmYW5FcUtSS0lzQzhE?=
 =?utf-8?B?ajdyZENZMCtraVRqRkw4ejdRWVM5Zy92RDBVN1hVSlBMSXQ1L2o4T3ZFS0pO?=
 =?utf-8?Q?S244SLwNFxFPlDxXquvKzTPSjynxdiaJ1tZEU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2dTejNJd2lkaTdXT3krWUVWNjNUVVJKY3M3Tmh3RzJFdEFSUnc3OHR2VVVp?=
 =?utf-8?B?YkNvdlZtUUZzVGtpdHVxUGpoZlZSMEd5cjloNEE0TTRJSU9CZ0VsK0kxNmVS?=
 =?utf-8?B?YzlMTFgzTWhhaHR3cEZDbFkwN0xUMDlqakd5L2dTU3V6MUdHWFI0SnRMbFV4?=
 =?utf-8?B?WHFsaGYydUxWZDljTXFkSnQ1SXBrWFBNdnNTSkVkVXNaVTV4dGYyM05DeDl2?=
 =?utf-8?B?N0gyS0tyMjcwNThwTm9KVzVrdzlPMWRaSHBDcGY1SkNRbE5IbUNEV21FOTZM?=
 =?utf-8?B?Q1h0cGp2TDJFdEdURmdVWWJGaisyVXhhN1JoM3JvM3FLWEpWcUxqYTVqeHJG?=
 =?utf-8?B?S1dZb3V4VEFjM0ZaeGwyaG5OUFJFOUg4NlY5cW5VVlZGaEVmOHNWRzgrd3FM?=
 =?utf-8?B?TlhSdDdTeWhHa241d2JHVlRZZFdrRjhkcnZ4NExWdXoxYjh4REhiSUdRL09Y?=
 =?utf-8?B?OTgzK0FZR2JjK1FLL2RBQXYzWnRxTDU3WHIvWUZublloNUdya1ZHS2wyTDRU?=
 =?utf-8?B?V0QyVHdFR2dCNHp0dUo4dHl6Y2g0TDNrNHJyZXk2U1hrNUVQRm1ZaFpSQ1FS?=
 =?utf-8?B?UzNhL2dTVFdYZm1RelV4aGVXVGxZVm9LTEdWUlNzZFZEbzdma013elQ4WjVV?=
 =?utf-8?B?YVpOankzVTRuNDFuNFRtSkd6OGRuMXFZTCtRcHc1L1BoUnlvVVpwTlFTU05x?=
 =?utf-8?B?R3VCajF2dWlSWDRHNVo2WmRISzEwbXA4RzdKTUZTSXhibk1WNmcvZXhQZzVU?=
 =?utf-8?B?dnZMdjNkRTNxemcvUlMvZlJrU2hldnBJRll0NEpqYVd2NkZVNUtDR0tONXRW?=
 =?utf-8?B?UG5pTGpFVm5QUFluRk0yQVZjU056WW83S2svMFRyZTFnYnhld2wxV1JzeHVP?=
 =?utf-8?B?eHd4Nk1hQ050Z21KRERJRllDWTRDQ3hlSUlrclpTamlsNUlvdStJN2srdmRz?=
 =?utf-8?B?NGEreXB2bmV3cnMvem1IVU1jaVpGYlQwdXZFTEsraFN1RWoxMXkyWVRyNXlI?=
 =?utf-8?B?OEV1b3ZYQmNNTzlmbjIwSVhWVXpBRVpWNE5ZMHRxZjFrZmxuOFdxSFBiUldv?=
 =?utf-8?B?dFdDcW9Vd0xuUExKY0VqeDZCOXFZSUx3OFdoejNxcGttZURpUnMyNGVMNjRG?=
 =?utf-8?B?UG5DbmFYRXZGZEdRNlJOTHRqbEY3QTdFbzRxMTdSWU5hWVJmbUMwN2RzcGlR?=
 =?utf-8?B?NW81VVpZRlFVU0hQeTVTSmRRWFJSQm1Objk2WXh4QjJqSWczb0xFMVhqSTdx?=
 =?utf-8?B?VnVjaDRTTGMzY3loSkMxWEZzNXpTNDU4U0t2dDdWVUxZNjhHQkxlMTVDQWNB?=
 =?utf-8?B?RThsd1ZRUmNOdkpHOTEveVQ2bTdGdEh2NVdKWEtPa2x4eGtacWM5MjJEdDhi?=
 =?utf-8?B?YnlhOXJra2pBMUd1d1hyTmcvZFA0dW5pTDBuamxrQ01QM251T0p4a2hCSHpY?=
 =?utf-8?B?ZFplQ0FKcWY1RWFlekE2SlZxUjNyakRCamFFRW16aU1lYWJGblBWWUQ5Smpu?=
 =?utf-8?B?Q3lieFJKVE9MTmU3bkwyNHp6N2tJRlRsNEZjNTh1ZloyZmVUT2pJbTN3cWtp?=
 =?utf-8?B?U3N1anhsbjNWbUhBS0l5Z0xId2s3bGFLY2NTUTVpUzdMbjYrclVZRHdFUUJk?=
 =?utf-8?B?ejdjdDdJemJ6NS9UemJ0dlc3T0pOcWRJVlh3NkdCWXA0THRsN2pkSm5OWTBD?=
 =?utf-8?B?eDBTbzNGR2s5Wk54eW9ieFVsQXg1MTBSOHVvMk5oZFR2VzVndU5CZis2aFhs?=
 =?utf-8?B?QlMyV3VrSUN5cHg0Nmlwbk0rT1VFNHU5R2g5S2Z2MDFrclhrZkg5Q3pjRFBa?=
 =?utf-8?B?aXpwK3V6VTduaHpoYW5ycU1zL1c1MEd2M3NCcVV0TURyblZEWERBQ1NUV1pR?=
 =?utf-8?B?aTJDUmRwbE5EeVJvV1huY2hoSWtLejRoVU81TThvbnBzdlppemdSclV0ZXR6?=
 =?utf-8?B?anBhWlh6dlBBdERhZGlxcTBKbi85REFXdmFwUmsvWXkvMmQwWnpDZ3ovZkJp?=
 =?utf-8?B?RjhzQW0xTFN3T1R6ek4wMlFVdUo0TTlNSWdDd3kwdEo4bndZdUpNRUtURzhJ?=
 =?utf-8?B?eW15VXdVaUtieUNQZHpxOTdQcEZTMUI3MWxjZktUZlo5V3FFb25wb3RRVUhj?=
 =?utf-8?B?dEx4Y25TSnZYRjZyTnl3WUpoZzdIRExrYVdqajhOR0V2NUJDVWVXa3F1TEtY?=
 =?utf-8?B?YXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <84912F6FAC8FB54EA1E6ADF3BFA58B16@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a91ba8fc-fcd8-4b80-9c61-08dcef800f64
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 14:20:47.2788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rrm/OJuOcowZ80KO4G9vc8ne4/xzIurgIUi6xJM96OX6Q0uouclfuuO8APFyS5hbNavT+jom/+TlYwQloge4qEyS2Se7LejMrxuh43pDEsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8464
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTEwLTE4IGF0IDEwOjIxICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IEtWTSB1c3VhbGx5IGxlYXZlcyBpdCB1cCB0byB1c2Vyc3BhY2UgdG8gbm90IGNyZWF0ZSBub25z
ZW5zaWNhbCBWTXMuIFNvIEkNCj4gPiB0aGluaw0KPiA+IHdlIGNhbiBza2lwIHRoZSBjaGVjayBp
biBLVk0uDQo+IA0KPiBJdCdzIG5vdCBub25zZW5zaWNhbCB1bmxlc3MgS1ZNIGFubm91bmNlcyBp
dHMgb3duIHJlcXVpcmVtZW50IGZvciBURCANCj4gZ3Vlc3QgdGhhdCB1c2Vyc3BhY2UgVk1NIG11
c3QgcHJvdmlkZSB2YWxpZCBDUFVJRCBsZWFmIDB4MWYgdmFsdWUgZm9yIA0KPiB0b3BvbG9neS4N
Cg0KSG93IGFib3V0IGFkZGluZyBpdCB0byB0aGUgZG9jcz8NCg0KPiANCj4gSXQncyBhcmNoaXRl
Y3R1cmFsIHZhbGlkIHRoYXQgdXNlcnNwYWNlIFZNTSBjcmVhdGVzIGEgVEQgd2l0aCBsZWdhY3kg
DQo+IHRvcG9sb2d5LCBpLmUuLCB0b3BvbG9neSBlbnVtZXJhdGVkIHZpYSBDUFVJRCAweDEgYW5k
IDB4NC4NCj4gDQo+ID4gSW4gdGhhdCBjYXNlLCBkbyB5b3Ugc2VlIGEgbmVlZCBmb3IgdGhlIHZh
bmlsbGEgdGRoX3ZwX2luaXQoKSBTRUFNQ0FMTA0KPiA+IHdyYXBwZXI/DQo+ID4gDQo+ID4gVGhl
IFREWCBtb2R1bGUgdmVyc2lvbiB3ZSBuZWVkIGFscmVhZHkgc3VwcG9ydHMgZW51bV90b3BvbG9n
eSwgc28gdGhlIGNvZGU6DQo+ID4gwqAJaWYgKG1vZGluZm8tPnRkeF9mZWF0dXJlczAgJiBNRF9G
SUVMRF9JRF9GRUFUVVJFUzBfVE9QT0xPR1lfRU5VTSkNCj4gPiDCoAkJZXJyID0gdGRoX3ZwX2lu
aXRfYXBpY2lkKHRkeCwgdmNwdV9yY3gsIHZjcHUtPnZjcHVfaWQpOw0KPiA+IMKgCWVsc2UNCj4g
PiDCoAkJZXJyID0gdGRoX3ZwX2luaXQodGR4LCB2Y3B1X3JjeCk7DQo+ID4gDQo+ID4gVGhlIHRk
aF92cF9pbml0KCkgYnJhbmNoIHNob3VsZG4ndCBiZSBoaXQuDQo+IA0KPiBXZSBjYW5ub3Qga25v
dyB3aGF0IHZlcnNpb24gb2YgVERYIG1vZHVsZSB1c2VyIG1pZ2h0IHVzZSB0aHVzIHdlIGNhbm5v
dCANCj4gYXNzdW1lIGVudW1fdG9wb2xvZ3kgaXMgYWx3YXlzIHRoZXJlIHVubGVzcyB3ZSBtYWtl
IGl0IGEgaGFyZCANCj4gcmVxdWlyZW1lbnQgaW4gS1ZNIHRoYXQgVERYIGZhaWxzIGJlaW5nIGVu
YWJsZWQgd2hlbg0KPiANCj4gwqDCoCAhKG1vZGluZm8tPnRkeF9mZWF0dXJlczAgJiBNRF9GSUVM
RF9JRF9GRUFUVVJFUzBfVE9QT0xPR1lfRU5VTSkNCg0KV2Ugd2lsbCBkZXBlbmQgb24gYnVncyB0
aGF0IGFyZSBmaXhlZCBpbiBURFggTW9kdWxlcyBhZnRlciBlbnVtIHRvcG9sb2d5LCBzbyBpdA0K
c2hvdWxkbid0IGJlIHJlcXVpcmVkIGluIHRoZSBub3JtYWwgY2FzZS4gU28gSSB0aGluayBpdCB3
b3VsZCBiZSBzaW1wbGVyIHRvIGFkZA0KdGhpcyB0ZHhfZmVhdHVyZXMwIGNvbmRpdGlvbmFsLiBX
ZSBjYW4gdGhlbiBleHBvcnQgb25lIGxlc3MgU0VBTUNBTEwgYW5kIHdpbGwNCmhhdmUgbGVzcyBj
b25maWd1cmF0aW9ucyBmbG93cyB0byB3b3JyeSBhYm91dCBvbiB0aGUgS1ZNIHNpZGUuDQo=

