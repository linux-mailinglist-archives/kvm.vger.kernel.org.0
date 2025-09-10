Return-Path: <kvm+bounces-57255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01ACBB52300
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 950A7583D7A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0A22FE591;
	Wed, 10 Sep 2025 20:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bmCvJJFC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0E827462;
	Wed, 10 Sep 2025 20:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757537568; cv=fail; b=cKGDq9oBblRdu7G+GNt99D2/4u5iEXTvQuKiWV29G28u6Dcm22NBFan6J/OHwd4pkiAKlYoAQmfr2gXDVit5+tmKxeo27L+3oaMtse22YbHrzoznzgWjhNcCnlBYRw+K0FLRJMh7gBWgveyKJVZE3SjnElsMJgDEWqyTJUWBTq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757537568; c=relaxed/simple;
	bh=C9Dm22eL9Yhj6IZdcVZjbYuIVgIDsGhqz5y/rnVtiGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NSlR2ehlYEUutuMi50JtV4YhaNEHthQTw1ydl0NNsG8Zk0fXffxGng29Wy+5W8fHXdmRS6zLE0/3cl7iQku9TsOYEUrz8GgpWSY6C2iUr0ls4tgwE2r1cGbvdCiF9IGLyOdTut5zK30ny6A/5hGEYzGwYl/JLQ1VqcXcNNSOCog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bmCvJJFC; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757537567; x=1789073567;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C9Dm22eL9Yhj6IZdcVZjbYuIVgIDsGhqz5y/rnVtiGI=;
  b=bmCvJJFCWHsuRQBN71MSnu163fgNvBGw3b12KOXkdmvdQx2ebzMsHF91
   YBXDe2Ka4wt6o8OBe9F4NgdLrzL05LKcj4N4wEb9y+hIBOX0evhU0Zc2O
   Ehxl2Yk+OnVibgg5xEaET97DuSgZGlFcWMWc5UaT0G459tjPRH6pPustm
   1DrNdKIxdUiTLloxSS11sz/kmUJ10IjeKvm5eJLFFDLjvWn7NqcLNDF19
   uaywHb4PH8DLNag1PyVUdhqltq2UvTyfE9jFttzxLveTQ2hmM5Es8dpJ1
   iCwLxX4w8Q5xOKGZZRSuup363C04XDZrT5/dqlqjaCTpf714ZSFlCnwKe
   Q==;
X-CSE-ConnectionGUID: f8oBWhhDTcG2JV5Uk6Jc5w==
X-CSE-MsgGUID: kd1VlPGORzeRxn+dChynAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59780345"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59780345"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 13:52:47 -0700
X-CSE-ConnectionGUID: fEnH1nKFSFCUNRop4X90cQ==
X-CSE-MsgGUID: 9NUdLFQPQdyQm78Dazl5Eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="178706808"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 13:52:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 13:52:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 13:52:45 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.49)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 13:52:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f6+4PMxAt87rAxhJyhQbWCXgL6zrmBDM/6fINBnjoZjgBfmAwsAt2R6lR6Z5ZcuEHdtQCE2Z2QlLe5j727uE+/iPTK9YkURAvG1z2+V7NQKVo8e+ITiTOloP4eP+s/PSY08nkOLntXd8FoIhibKWpHj9Ud8PxiV1PjQ9ffcVK4Tj1SK62yOVaDhB6aWWMBLtBhgLo7ytEbPDL8xYxG9JUwkk7by7z1ZRzddKO/ujUOX38wEcajLXz39YfGdqxd03nDcALlD7c1rUJwI0S4o1CbqCTf+IbGq26WU51Mbp6cZXAHFh2BhqrXpEsK9zWQx++A30RLgtsWcYHx7VVrbQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9Dm22eL9Yhj6IZdcVZjbYuIVgIDsGhqz5y/rnVtiGI=;
 b=kcXLiSQHYHEbpaYhZ3anc+FAmuQ3UbkWHNnAzH8gaeJBHCbCrtg1/C1S/m/6sJrRPNfJ3rn7JC0x++9HY6c39ZnSad4hQfLzW5DuDVGNm6kBPKQwlF7/O7wfuE944SsST5VbmXeJLwo+I5975WO+lU27iaNxDpdq8u44XtWgvoAeJCp+CIs2x3czXkqRhiNR5c1oOvtsCRqvo5yQe/UHzfcG5X+lJDJdUpz2z+qFpNU3GtjWqUt4GVZyqtux/f9XkhPFdX8WHAWNYzXVs+Cq9qII+/3xxeJsIQo0gG8CqJwjfF20JftOq7VyZKrnvTm+TWGnQfhMaJ+p2wgA/7fEzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4978.namprd11.prod.outlook.com (2603:10b6:303:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 20:52:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 20:52:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "brgerst@gmail.com"
	<brgerst@gmail.com>, "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"x86@kernel.org" <x86@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"kprateek.nayak@amd.com" <kprateek.nayak@amd.com>, "pavel@kernel.org"
	<pavel@kernel.org>, "david.kaplan@amd.com" <david.kaplan@amd.com>, "Williams,
 Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: RE: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Thread-Topic: [RFC PATCH v1 1/5] x86/boot: Shift VMXON from KVM init to CPU
 startup phase
Thread-Index: AQHcIbhd14UC0LurTkGsI74DGd7tB7SMDyGAgAA0mICAAAbbAIAAG4WAgAB/hZA=
Date: Wed, 10 Sep 2025 20:52:41 +0000
Message-ID: <BL1PR11MB55255A7D0148F35E58FE37F3F70EA@BL1PR11MB5525.namprd11.prod.outlook.com>
References: <20250909182828.1542362-1-xin@zytor.com>
 <20250909182828.1542362-2-xin@zytor.com>
 <1301b802284ed5755fe397f54e1de41638aec49c.camel@intel.com>
 <aMFcwXEWMc2VIzQQ@intel.com>
 <16a9cc439f2826ee99ff1cfc42c9006a7a544dd4.camel@intel.com>
 <c29abf85-aafe-4cf8-b4e8-6d3b5b250ce6@linux.intel.com>
In-Reply-To: <c29abf85-aafe-4cf8-b4e8-6d3b5b250ce6@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4978:EE_
x-ms-office365-filtering-correlation-id: dd7a2eee-7d65-402f-44b2-08ddf0abfc5e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?alJMNlA5WlhySUFKWklqa2RmS3d1eUNKb0ZVQkV6a0NOWjg2bVIyYXU4R1ZU?=
 =?utf-8?B?NlYyQzRpbnNwcDhpR0J0ZWpybkhNVy8xWTlWRDZaR0g2dUNpV05RcWtDendl?=
 =?utf-8?B?dEE1T2pKM1JNb1FZcHdINWsybDhGeHdHWUZHQ2JYK2d2S2VBLzlaejRuMThi?=
 =?utf-8?B?Yk1UWXBLWjVQeW9hOG1ldXdrUzYzb0t5eXhVV1pMOWZ0amRSQStZTGJVcTBu?=
 =?utf-8?B?WTM4Y3dOdms2S1p6UlYxQ3I4alAzTHh0bmJ6eW9NNlZJY0pqeWxSR3VyMm5m?=
 =?utf-8?B?RFRBRy9Kb0Y3OW01a2w4Tmo0UmExWnJYUllFL045ZGEzOXc0eUMzYkUwNHJq?=
 =?utf-8?B?b1RNWEJ2RmxUWnA0WnVPR2R6VE0xTzErbFdxbnV0bTFxa2dxb2k0QndSSGlM?=
 =?utf-8?B?WTR5aU02Z0s4WGdjYzU3VDNsMnRsVUtXd3NSaVY3MzBBamM4UVFIV2tRVnFJ?=
 =?utf-8?B?TjF5MTVvb2dzN2dUN2ZUVHI0MzJNL2k5TU9pamk5R2ErWW5tOXhHREZOUGRj?=
 =?utf-8?B?SnByZjlJQjBhcFZlRzFYWlluQ0RvNjNmZVdWNHIxM1NRTGFGdUJsc0c5dFFS?=
 =?utf-8?B?cjNralg0UHkwRHNOTEd5dTZFQjVncCtxNEJHT3BFbExpcmpuZGxaVzAxd3Ar?=
 =?utf-8?B?cFBpL1VMZjdudlVoTk9vRCtTWHhrb2YrVFBnZDU0QkRsU0pXNHZVTVlPSWFh?=
 =?utf-8?B?U0Z6UHlCQ0k0d1UyWkp1Z1ZhNTlGRTgyTU01R0E1YUFCVDBwbUZHWSt0Vnc3?=
 =?utf-8?B?bFhOamlFZ2l1czJsVll0MGRmcnUvbVc5RC92cXBldGpkcG83TkFQOEJ6Uk1Z?=
 =?utf-8?B?dzZqSkFxRGpqZ2JORW1iOXRrM2lQMWtrYkVGR1MvTEU4b3NSOUE2c2hFN05K?=
 =?utf-8?B?YW5WVG9WYm1nQ3JSQmxOYXk2UmlnNWpmMW9IR0ZDNUQ5ZktTS29SbzVrUVI1?=
 =?utf-8?B?N1gxekkwVmpvSngzenFMN2VQYmhTRGxTTUNUR1VnZ3BodzBzNlhMREs2MWQ4?=
 =?utf-8?B?d3Z1NzgvUnphOGdhSjMwL0UrWDFXSlRBSXlBb2YxNkpYbHl6MWRVcXJtbVhG?=
 =?utf-8?B?bFliS1RvOGlOci9Qc01zRTM4ZUE1c202QTBybFZpd3VzT3lrS1JxK3JETkJk?=
 =?utf-8?B?Wm5ZT2NTbzg0VVBkbklWaitFS3dhZGg4aGs1K0IveVI3MklFSi8rTXdtNjBk?=
 =?utf-8?B?MDlTaWxhVzVPamsxeVJUWitiNVlJanVtSWt3cTdrL0VmMjRZamJzdFUrU0h6?=
 =?utf-8?B?VWZWZHRuUnVkb1ljSU8vdVowTi9LRnFGdWM5RlBZZEp1SVRoOUZXRjR1Zy8v?=
 =?utf-8?B?T2RiTktPcjdJNnJYNUJmNk1jMGJLdFFlTGdzQ0VZNktuTFB1ZzlodTN3M0FV?=
 =?utf-8?B?NC9qWmxJaHFBRk9xRlgzQ2MrYzVEcmd2ZXlIMFhJWE9EZ2NSOU5CYTlnU1Ba?=
 =?utf-8?B?YjhYSW1iOU0yRWNzZmcyOEI0QXVvNlUxTHVDeFk4OThOU245TStwZTlwZ0NO?=
 =?utf-8?B?NUMwNWU1ZmtMcVJTdHBjMmlKMFBvallQQTZpdVdaU2NKTDFGZTFXa2xlUDdZ?=
 =?utf-8?B?R216ZkZoSFNUaFBBZWxucm5UTktNVHJiYkxNb0NReFcwOUdwcTZ6QzVLT1BJ?=
 =?utf-8?B?SEZHYWpWWkJaenVmeHhQUlRITFRuTll5ajVLaXFUOTEyRHpBK0tMMS81enFN?=
 =?utf-8?B?SEpXU2crQWJ1cVFJK202N1Nac21HeFBlenpLK3VzeHJHOE5HQlhiRjI5cjRV?=
 =?utf-8?B?ZmRrWWgwaVdpVHlITTlKWWlrNzJCMEpVTTNDUWJLZExXWktqV3hNZlhEVEYv?=
 =?utf-8?B?OWlIUzdZL1FrYVAyVStHMDl0TzAwUXYyS291TTF0MklBWHZzdHg1UUNKYjgy?=
 =?utf-8?B?Ym02aENRSFFKU3dub2lOdzJHL2lwVVBLWGdvTWlPNGgxVldYaXJEZzVKa3Uz?=
 =?utf-8?B?eXNKU20yMGM2c2JuWkF6bE5wZTBQYU9oTW54OXltQzhGL0hiRzFCdmZTdHZk?=
 =?utf-8?Q?zlv17Cnvwe5vMrqGbTZRriYBz79mtQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHVueXZ5TmhxVHI2cllESWFpMnpMcnRBbmgwRWo1bDRRakRIZW1zOFhsczBo?=
 =?utf-8?B?OW1xVTJjL2ZHTm5JQXNjQTdmS0pTd0xBVDU3ZWJFYTRweWM4cXJLdGczRmdD?=
 =?utf-8?B?NllNb1l3NjdVY2dROGJuQmNyWnNaK1FvNEFHUFhxc3FMbXJiQ2djcTllZDN1?=
 =?utf-8?B?dDBMZFZFTGh0Z2REMTQ2MGU3Y3lKSTRKRVNJTzZZbVdmU0xoSit2VlhjZHRq?=
 =?utf-8?B?dXMwNGhaSVd1WFlNZTU4UkFYU2JLTk9temJLQzdpbkMrdkNUcDlwNGdKK2xG?=
 =?utf-8?B?Z1ErVUl4ZURTVTMzVW52Ny9FNEpGaStZa1F4VFZEZkNzWklOcldTNXNZMElX?=
 =?utf-8?B?cklXaDdYTk1IMGFNdkRJaUx0UTJEaDJNVVNGNVMvN1kwNWcyQ0JHSVNzc1RY?=
 =?utf-8?B?Nmpia3hoaGxZNXJCZDZHWlVIeFpQQkUxMXpZVzB5KytGUloyUi81VFBmdVF1?=
 =?utf-8?B?a05NNDdxQUtZMWVNZ29OVTRXbVpPWFdzKzFHZUNSS0RDWW1LSG5VRm5jTXZT?=
 =?utf-8?B?V0FTSzBZK0JYVFcyZ0UxOWF3eUVUZ0Y2a3FBZ2JqcEJtV0VoUmlJNkV4elhX?=
 =?utf-8?B?dzNLbVhwbVg0U2lWQTFNNUZvOFp3ZjlCR0pyNThjWi9IbDZCL0pNdlA2RkJX?=
 =?utf-8?B?Snh6M21UclAydVhMVWJwVC84S0RtekxabEs4c21tSHJOWkhZT0ZhYXhtWXVX?=
 =?utf-8?B?QzN2RC8zOGpaVzQxM0RaTTVCT3JkZzBNY1psdWZFYTRzeDFnT3VyRk45aFFG?=
 =?utf-8?B?R3BQK0VMZGJ6VEorYmltWjY1aTdjT2xjWkkvYzVCeVV5R0UxcDIyRzhIbko4?=
 =?utf-8?B?bGhEUlZDOVFtSnNpd1RzQmxmZmJheXJWdEY1ZDVlWVVTdkVaWnRPSzFkOW9E?=
 =?utf-8?B?MzM2c3VwU1JKeklaaDJUT20wcS80WDd0aEdCWW1NdkVSb0JvNHBhbXRiSUd5?=
 =?utf-8?B?SVB2NmZxcHBYeDFmOUpvTHFYNGZLTlFYZHhvTnZKMVAzNXpKbGJTcCtuZDZ5?=
 =?utf-8?B?TVBIK093bWQ2ZDBmWDBRQmgxT1p4UGhjWmgyZi9STlJCbFFSeHR1bnQ0dUJp?=
 =?utf-8?B?ZFpsMVQ4dW9KeGc3a3RKY0ZFK1RsYVdzSHRwbmZGQlFIV1JwVnVsVjFyMDhT?=
 =?utf-8?B?cUdIMTZMdXY1T2RrNzJYZ0NMUGhJNmNpdmdNdzRBd1pzSFlNdktmOHZPRnlz?=
 =?utf-8?B?dE9wZ05KS0dYdWc4ckRZV0c4ODNWY3Y0S3RJVGZ6NW1uM28xMGdCamEzMDZS?=
 =?utf-8?B?aTJKK2NnWU8zZmhoQ2txZ1lYVnhQL0dBWVFlM21YOFB2cjlJZ3NLVDAyTGpl?=
 =?utf-8?B?Nk5WMFZFNmVUOFBMa0VPckdLTVBlbDEvUHVLRzB0N2VKM011am1FbWEzNTBk?=
 =?utf-8?B?cGZCb2dxcC9Wc25oZC9WWUxQOStOMmxmZi90Tm02VFlEQWFMdmlIbXRWUVdW?=
 =?utf-8?B?NTQ3U2Jmczh4QTArY1NxNDhXblZJOHFhdUpRV3kySzlkQzQrcytCMHBTN3Fi?=
 =?utf-8?B?aDNBYkJiQ3lmZkhVOXN1dG5CTjBoME9tc1VtTFQrb3gvQlVuaTFhZHlZWmk4?=
 =?utf-8?B?Z1VDczVsakR1L1NQMzdHbkJvTk04YVVjRXI4QXkvUnc5WDhzdm5JeDdVVk9F?=
 =?utf-8?B?RUxhd2RmcmhxNldxTE54OE5uRS96Mjg1MHhBR0JpSmE1bDlHKzNxamxac09l?=
 =?utf-8?B?SU1qYXB5V0NNcjdsaXlnV3FLWGFiWndHVkM4a05FRHBZWENhRTVOZWI0cCtN?=
 =?utf-8?B?N3dvTkJLa2JGS2RLQkxFRSsxaWJTRVlMQk01b2JuK3dNaGVBYlc3b3dRbG5H?=
 =?utf-8?B?eVd0SVh6Z0RvM05yYXJHNEh6UVNaU0tOTjJaRlFoRSsyUCtzK29vWCtkMzJY?=
 =?utf-8?B?cW1lNDlvdjBZUzdUOVh5aSt4Tk5CZWx1eTdBWDhjSWZ0Rm13eGRqb2V2WUlL?=
 =?utf-8?B?YVpBUW5MTFNncnI1QkYyMzEwUHNqYjQ4Z1BNYWx6SklJUHJlS3lYQS9SVUJK?=
 =?utf-8?B?TGlSTGcrN1laUjh1RVEvN0tVQm8yNHZTUDNsYjFzaWIzRVlyNU5wZnNST21S?=
 =?utf-8?B?WGRUanVRM29tNmV0VzlNZlZBajhJd09Qam1aNW42Yk05ZU1YaDNSNG1Ed1ZD?=
 =?utf-8?Q?twQ2r3Ml6LaFeGSYuKjdnJEPG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd7a2eee-7d65-402f-44b2-08ddf0abfc5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2025 20:52:42.0432
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IlvCHzAPFaspDU7oLefXzO8OfaeUCBEZW1DPdNc6L2R5N1fMe4MvCK9kyn0j5iuABZ/4uiSCYLgNrR8KAOsRWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4978
X-OriginatorOrg: intel.com

PiA+IFNpbmNlIEkgdGhpbmsgZG9pbmcgVk1YT04gd2hlbiBicmluZ2luZyB1cCBDUFUgdW5jb25k
aXRpb25hbGx5IGlzIGENCj4gPiBkcmFtYXRpYyBtb3ZlIGF0IHRoaXMgc3RhZ2UsIEkgd2FzIGFj
dHVhbGx5IHRoaW5raW5nIHdlIGRvbid0IGRvIFZNWE9ODQo+ID4gaW4gQ1BVSFAgY2FsbGJhY2ss
IGJ1dCBvbmx5IGRvIHByZXBhcmUgdGhpbmdzIGxpa2Ugc2FuaXR5IGNoZWNrIGFuZA0KPiA+IFZN
WE9OIHJlZ2lvbiBzZXR1cCBldGMuICBJZiBhbnl0aGluZyBmYWlscywgd2UgcmVmdXNlIHRvIG9u
bGluZSBDUFUsDQo+ID4gb3IgbWFyayBDUFUgYXMgVk1YIG5vdCBzdXBwb3J0ZWQsIHdoYXRldmVy
Lg0KPiANCj4gdGhlIHdob2xlIHBvaW50IGlzIHRvIGFsd2F5cyB2bXhvbiAtLSBhbmQgc2ltcGxp
ZnkgYWxsIHRoZSBjb21wbGV4aXR5IGZyb20gZG9pbmcNCj4gdGhpcyBkeW5hbWljLg0KPiBTbyB5
ZXMgImRyYW1hdGljIiBtYXliZSBidXQgbmVlZGVkIC0tIGVzcGVjaWFsbHkgYXMgdGhpbmdzIGxp
a2UgVERYIGFuZCBURFgNCj4gY29ubmVjdCBuZWVkIHZteG9uIHRvIGJlIGVuYWJsZWQgb3V0c2lk
ZSBvZiBLVk0gY29udGV4dC4NCj4gDQo+IA0KPiA+DQo+ID4gVGhlIGNvcmUga2VybmVsIHRoZW4g
cHJvdmlkZXMgdHdvIEFQSXMgdG8gZG8gVk1YT04vVk1YT0ZGDQo+ID4gcmVzcGVjdGl2ZWx5LCBh
bmQgS1ZNIGNhbiB1c2UgdGhlbS4gIFRoZSBBUElzIG5lZWRzIHRvIGhhbmRsZQ0KPiA+IGNvbmN1
cnJlbnQgcmVxdWVzdHMgZnJvbSBtdWx0aXBsZSB1c2VycywgdGhvdWdoLiAgVk1DTEVBUiBjb3Vs
ZCBzdGlsbA0KPiA+IGJlIGluIEtWTSBzaW5jZSB0aGlzIGlzIGtpbmRhIEtWTSdzIGludGVybmFs
IG9uIGhvdyB0byBtYW5hZ2UgdkNQVXMuDQo+ID4NCj4gPiBEb2VzIHRoaXMgbWFrZSBzZW5zZT8N
Cj4gDQo+IG5vdCB0byBtZSAtLSB0aGUgd2hvbGUgcG9pbnQgaXMgdG8gbm90IGhhdmluZyB0aGlz
IGR5bmFtaWMgdGhpbmcNCg0KU3VyZS4gIEZpbmUgdG8gbWUgdG8ganVzdCBhbHdheXMgb24uIA0K
DQo=

