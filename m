Return-Path: <kvm+bounces-55120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EB37DB2DAE1
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:25:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F3507BA308
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C32A2E4272;
	Wed, 20 Aug 2025 11:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tr/C9JsA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09C74414;
	Wed, 20 Aug 2025 11:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755689142; cv=fail; b=gQbuykwJD7kO0cpTFpcZZU0covvQkB7FJCGbgRmcVClUr+sw+jvquYcyUNKkeE6b0qZ+B0Qqkz5TptHIgGz45dLu+OjJWfqR8294zookFVTWk3XgCCTy00zdPfT5DcCnzUl8odCwwEIEPDXP7EzOxtGoFqM3TuNMK40nZR0XVkY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755689142; c=relaxed/simple;
	bh=bqRqF4NMTWbMstGH2PtrQ04RuxQvvAtttltXGwk3v64=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AOGmI+5ROL6OvJUiYdUAAUIaXtff4FlXryxQQxJuXVNxLVY4ZBbf/8uOeKup/XI+h1F82eSTysKJkIDwZXS0q4l7Yfd3QWNt+vxU1k/zghAIppJ1zDFgLWBx8wSuTkQB0c2t/0UWYch/RcwlDQjAdcZ/m/4ee5FxT44XmLCcWDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tr/C9JsA; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755689140; x=1787225140;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bqRqF4NMTWbMstGH2PtrQ04RuxQvvAtttltXGwk3v64=;
  b=Tr/C9JsAc/tWHrAJ+IEAVTHc0Mdf+MHIc+rRU8curqI9ErfMau3i0d/I
   inflmaBC+Cq7tFJ+eM4UZbvFDRVaVIbGP8NeZxWYHyX7Ca6h81N/BxVu+
   6wIOxMa7OeBu77JLm5agqHCoMdTy3nQFEZ/OKcmzEfkmaIEYNg39CVFYv
   tjHBm0NOU8iJgJb9OdrpZ9eC8lV/efONgjexmaf/J0OJEkyFVdY9LibIq
   jQZl6UhBHrXvmGjqnGprD6UbyB65EwK6K/HVdEeD+lsTpVMZZo2ULiIyO
   Uu4naJkzGCy87dP0QS6IOKdvECGL0Yr6rA03N/fVkU9Y1H0oEZ8k7c2XL
   g==;
X-CSE-ConnectionGUID: Zp2gPp9STg6FDwI/P9x2qg==
X-CSE-MsgGUID: yMcUuLBOQRe+o6ZB7xhiHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57152205"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57152205"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 04:25:38 -0700
X-CSE-ConnectionGUID: WJpM6dcoRmeMfZLfbYaCdg==
X-CSE-MsgGUID: uPX3aj/JTV2SQOM9lCiz+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="205264737"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 04:25:38 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 04:25:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 04:25:37 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.43) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 04:25:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=byhChcghIRsWusEtx1ySXQAa0lk7WKzf3l+b9q1lQ/bfY3hd6avAcfrgetbOvLRKMOlYmyoHeCMs19q0xnabWqF7JxRgpOIRNDJzUk95nzcU6Q3tT7caNgQGt6UylVrpjEDuMC3B0S3g3oCtSOkln7gxFD0UCxEwAV1YYOtJUAiJTf/Fht+dvcLrZXRxmB5DrdKC6tnAIopndDtkcjijYAKszUv1ilOFz5iSuqIObRFTJDBkkzd1AzhCYrN1G0KGLamW2/VQA3eKR43oaML9iMoFAGxt2wNZ23F5JDSg2aOUe6Yls5EQpmFM7IAyAlOuBv4VL8AZX/fOE/rcBwwWJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bqRqF4NMTWbMstGH2PtrQ04RuxQvvAtttltXGwk3v64=;
 b=yB6ctZIewuv+cfuRyGA81EadXsJ/Qz9gQSlmB3c63+guVAHD94Qj5RqvbfZFMaqwiCCjMyh8eA776kiGLVkgSL/SnZzEBXDwT2xHFJbzbKqzPYXSYB7AtqAO4IO3bTpOb+tnYU+1BQqIz1AzGjxRCU4J+oT9z/0TlVGYm/0x3WzvAnEirDirxV0QKcuFxUCDIsxFc2w0M9enXgTpj8I03ioDnbUd060riiPaxMg57OPmmyJk88vqAVu9wUBl51DPeb/D1VlBIa2m+CmSIPFwybrPWXFnZsoZWtikynJBP7MQukBRhZ/vsEPstzC4ey/lk6f7fXMFsWoI4H/bkeLQ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH3PPF496D5EAB2.namprd11.prod.outlook.com (2603:10b6:518:1::d1c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.13; Wed, 20 Aug
 2025 11:25:29 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.013; Wed, 20 Aug 2025
 11:25:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "Ketan.Chaturvedi@amd.com"
	<Ketan.Chaturvedi@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
Thread-Topic: [PATCH v11 0/8] KVM: SVM: Enable Secure TSC for SEV-SNP
Thread-Index: AQHcEWPQdZxXrAFNm0qw+ou6n1juBLRrO5EAgAAr4AA=
Date: Wed, 20 Aug 2025 11:25:22 +0000
Message-ID: <755ca898eab309445e461ee9f542ba7a4057d36c.camel@intel.com>
References: <20250819234833.3080255-1-seanjc@google.com>
	 <afcf9a0b-7450-4df7-a21b-80b56264fc15@amd.com>
In-Reply-To: <afcf9a0b-7450-4df7-a21b-80b56264fc15@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH3PPF496D5EAB2:EE_
x-ms-office365-filtering-correlation-id: ee9f3242-8a52-4e0c-aeea-08dddfdc40cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TzJNMGtxRmdTR1BxazhMVk1YcmsyYlBIVXJibXdUdEFwdVBDM1FwWGZwMG5l?=
 =?utf-8?B?ZHFjK2dqR2o2TVo5ejVFYTlzMy82dEdxaUpZNEFGZm5mSGJxd0Vja2ZOaWdJ?=
 =?utf-8?B?RHE0T0JEbklSQ1NpcTZRa28wcVIvYy9uU3JRV3VLODh3VkpleE91L1JYeU0x?=
 =?utf-8?B?WVE4TmptcW5OYmJ6cjFEWGxjNXlSbUpzc05DMXRQWjBIR09HSE9PRWZ5ZGRu?=
 =?utf-8?B?YVlHdDBxb2FrU3c2SFRzQWVOMCszd2I4L2lHbE1mVDNvVzlGaTdMcjhUZ0U3?=
 =?utf-8?B?eDJQUEswakpSUVBuRHgwejhHeXBlNWpsaHJZK0RRTExEZjZpSEdacm0rOXlT?=
 =?utf-8?B?RlpyVzc5NGRVdk4wakg0dUoySFRFTXJiYnpnNUJVWDViSXk0NWpFbitWYVcy?=
 =?utf-8?B?ZEJTTU9oQURHc1VkcWpYcmx2SUl4UHlCTG9TTE9vOWVkaEptS1g3VFNlZWV2?=
 =?utf-8?B?cm9IdGZpRXFsTmJLRTFSaHp4cUMxVnNVMlVVTEc4MHpsMXhuN1R1azZHR0FR?=
 =?utf-8?B?ZGl2bEVnZS9HTlRwYTg1K0tnS01yYTNSNW5TMmgvdG1KbEdJWEZqaStNN3li?=
 =?utf-8?B?TjdlZm1hS0w0WnQ2NHEwSWxmRlo3ejZheVhPQVFLUHozbDZ6ZWdNUVl6Wm93?=
 =?utf-8?B?TXU0Z2ZsRXJUTTZKQkJFUFdtT1VrSE9RcGd6Vkt5NjFiOGdaK1IvSVMvWExR?=
 =?utf-8?B?cFVGZlNRcmY4V0Y2ZUp0Z0ROT1lyM1VlRkJIZWwrZ1RwMU9JK2F6bHhqUzUr?=
 =?utf-8?B?RGthQXpwWnhzeEt0a24xTU1YVkZHT0ovSWpuYjAwM1o5TDdXQlNVMmtGelhS?=
 =?utf-8?B?MWJJcytHbzcxR2Q5U0RiTEZ0V1hIUWo0QkZMZjVnZG01aHhpUUlrbGtXQjAy?=
 =?utf-8?B?bUJ1YnNuKzI3Y2ZNZFlWUVcvT0ZGdXRvRFR2WXZCb3QzbWNNSml4TlBGM2k5?=
 =?utf-8?B?TkVmUVdYc3hNL1lkVGkzN2lQU29iUE5tOWprSHc4ZUtRbDZHd0kzVmhsMm9R?=
 =?utf-8?B?QWRnb0ZCT05uNWFYLzhlOEdnbHhPRGpiV096Z2lNUlc2cHJNNXh0VGF3bDZo?=
 =?utf-8?B?V09BaDZLbEhCNU50dEd6V0pmODBidkd1OEtKZTNKenUwZzFVNlBVVGdaMDQv?=
 =?utf-8?B?RnZvUjNtSWZId3QrTjkwWW1TUmpZSVE0WEhudUdHYU93bTN6d2VFanB5SjJj?=
 =?utf-8?B?aVUzeW5wTkxBMTV1Vnhhd25jUG1PT3phMUZQRklLREZNTnlLYmJ0WXI4UWoy?=
 =?utf-8?B?YWp6WTFyaHhJNGtTbnpZckF0TkxXOC9VNEFJeEpKcU1ucko0VElmRUhrbnBP?=
 =?utf-8?B?aElHU1d0OEk0Mis4SWloWGhlQm5PTy9MNENwb0RyZmlDeHl1bElYcmlLN3hh?=
 =?utf-8?B?QmR5Z3Vvdi9ibU1CYzVTdHgxS0VUUW9aTkphWUUrUzZ5a3ZjTWhQQy9laytx?=
 =?utf-8?B?dUkrYVFXRWloQkkvcTFTM2NwTmlIaU00dFpKQ3pNajNOYUphaXRkYnFoVUJW?=
 =?utf-8?B?WnhMYkllVysycDk4azZma3hDZHZpQWI1NlRMUFVscE5WYnl2c2NSb3JVVnRS?=
 =?utf-8?B?UnZVTWdJdzVKWEhxYXJlS3JFL3I5UTl5aWpGNUFKS200RGY3akZJN1JiWHFD?=
 =?utf-8?B?aVhqU3RzMmdjcUNzbXhYejk3VGZEL1YwN1c2OXg3dEhFSmVIUFBNNmwzZkkz?=
 =?utf-8?B?c3l3STJ3ckFVR0Z5UklKbnFJV00zbGJLbkhBNWJVZGM1dWJWS1Rrb1dwczNB?=
 =?utf-8?B?bEdkazducTJ2VVNENnpzN3drQWpLOVF2Vk1QTzczdW8xcURzelNIVkRVTWZw?=
 =?utf-8?B?TUJCN1pINkxDWWZReUkxRDdpZkovcXhjdzVoekE5REZDQWVMTnloaWp5V1Fm?=
 =?utf-8?B?dGFDeFlVa2lBaDFFWFprSk1UTUpZamtsbE51dnVWQ0R6YjRhU29FN096bGpE?=
 =?utf-8?B?ZVFiK096OERFRjZKOUMrd2Eya01ZL3hTVjlYbnR4OTNoTXdzS0JGMTRidGJN?=
 =?utf-8?Q?NurjyCz/L5CyejkziUJLN2IbGf4/7c=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmowMDY3REpJc0RmN09JY0JzQWl2aFVaVGtBWm41bHJoYy9naGNLNnpKekpS?=
 =?utf-8?B?OGFBT3gxcjNURjJWaTR1dkF0YnRaSFRNaFM5VVZ0TGU1eXMvL1pmM3gzNzY3?=
 =?utf-8?B?aVhLSzgvRkFaUFphZGdhUlVhSXNFR3AveXN0a05EUlJHVm9SOXFxSlh3Smdv?=
 =?utf-8?B?Yy9tdkJTZzVCTVhpZWlUUFFMVGN3SDV2emJqOFNvSHE4ZTY5SjVtWlIvMWtQ?=
 =?utf-8?B?bnVYN2s4a1JSZm9NYmJTdVNnTlRhcTF5YTcxVkp3MS8vbEhlRno5QzBKQkcr?=
 =?utf-8?B?V2JwZEdKTEoxbFozRnNjRldOVFJMb1ZQNHJ3cnJpRnArQUZZdzJoK0ltMnJX?=
 =?utf-8?B?TXdKdnFmVUNrUU1jZmVqa3A2YkpHd3pJZXpQTStYVVRQVjQ2K3pYTkU2RDFo?=
 =?utf-8?B?YlhVaXoydjhGY1NBYytJd2g5VmtSdXFhWnNhM3BLV2dQcDloZXJXcU9Pa1lW?=
 =?utf-8?B?ZXRHdk9zdENFL0VjVnVrY3VIRVBoTHFiTERQZExFVGhEeEYySHc1WVl1NGZO?=
 =?utf-8?B?TlBJUFFhN2FZNTZEK0NnQUdPVGpTUFdnaVF5b1k2bTRKbHgyVnpGS1Y2V1V4?=
 =?utf-8?B?K25Ib1hqdkZUaVl4WGdoNmVtaGpWK1BKZWxkRVo4Uzg0OUhSWFlMaWMxaXJ4?=
 =?utf-8?B?eEhMMklsZGNwVmhRYVRhQ2VvU0NCcVJKUGFPVnhRVEZoUlNGZlM4OHFFeStw?=
 =?utf-8?B?aUlFcnFUb1JLWWNPdzhHMWliL2pnSzZPWXBQd2hxVzd6QU14VVZJRHc1N0wv?=
 =?utf-8?B?TWZXU0h6a0Fub1VLSTVOOTg5bDBIL294dFp4TmtvaGZEYXlPYTJiNTdCZW5j?=
 =?utf-8?B?VlZwL3pvNWwxV0p1ZHNnQzBHQ1VYYzQ4VUhWMEZENG1nMkdPUTJXZ21FVEV1?=
 =?utf-8?B?ditVelJBMUNmbEJGZGU3RDVCN0ljWkQrRHhTNXRFR1lWSzdvK3NxVHdOeVVY?=
 =?utf-8?B?MUFhckp0NjZObnB5QkVwUi9kREJvRkNpT3VibExBZ0VuV0dUKzE3UE5kSS9z?=
 =?utf-8?B?Q2tmK1QxcGRsMC9ET2pmV2Nrak5ib2pTc0hpcW1UM1YwZ2tiYnJVYW5hdHZL?=
 =?utf-8?B?OTM3Y0xvQWE4M3lUblBmYTdMVnBhWGZaMEZXR056WWRpTTZKQTd2MUFueGFY?=
 =?utf-8?B?c2lGR2d6dGM1Y1VBaEZ1NzMxWU5BVGJ5eHlrS1BoRXpXR1JhUXlnaGJXd041?=
 =?utf-8?B?TTBFTjJhUWs0UWVDNFdDLzJkS1NWRXFsOE1IeXdhMHFSd2MrdlBsbTNDV3lQ?=
 =?utf-8?B?dUNxa1BJc1hRRUZ1bmw5czR5SThBaVAxUTM0bVVheGhwdndQZ0NhQnZRZlk0?=
 =?utf-8?B?dTZJa2U4VWg0cHc0bmNPSmdlSk5pc0FRdjBuVEVMWFZpMW5SLzhERzhXakJZ?=
 =?utf-8?B?MFo5dXdPdFc1eno3RXduNE92MU8xUDYyVUNucXZGdnE1VDNNa1ROaTg3QlpY?=
 =?utf-8?B?ZUFWaEdPWnE5MUJ3S1JNd2pUSHltMG9POFg2QkVlWFZUNis5RStMbFlOODZs?=
 =?utf-8?B?d3pydzJMc1M1aDE1cHJSK1JkcEw4eW53eS95dzlMQUJpQzlHajlHMHV1cnY1?=
 =?utf-8?B?bnhTMFRYWEpmN1lSdnM0VGZWaHdIVmlIWnNJU1Zsemw1dURxV29ncUhSajh6?=
 =?utf-8?B?eFJLbk9Jb3VwZ1Z0cXR0Wlc3WEZhVDRJMEdIeGw2WXhXbDZrdlVlYmJjSXBu?=
 =?utf-8?B?Y2Njc1lYYnZHQ21ybG1Wek1GYm1HM29zR3lnZzY5RXJqZTdpWkNMa20wM3Fh?=
 =?utf-8?B?aUtoWThOZ2xjT0FKcHdIakVzb2xzQ28wK3dOM3RNTlcrQW5PeHR2eHFONW8z?=
 =?utf-8?B?RkIvK0QrNXcvOWw0bW5mQjlRdVJGVkljZTk5ZG01YjJFbyt3dHBnOHhhaHg1?=
 =?utf-8?B?NE5RYzQ2ZXF5STJUUFl1cUR1NVJyUUJvQldidDZrdm9YVks3NFJKK0xQdDZG?=
 =?utf-8?B?RzVlSnMrSE5HRjN3ZFAySm9YclErdGVKdmV5TVN4VVdmUDhpRmpjREduMUlQ?=
 =?utf-8?B?WU5WUmozWkJ2SkFlU2NhZ2FmSlphQ3pKUldETDlsVllrUzNxVU1aVEVQdlNY?=
 =?utf-8?B?bGhrUUZDbWk4cldWcnR2U2hIbk15MEFQZDZxT2ZsVUlnOXhCcEE1T0g5QTZH?=
 =?utf-8?Q?b5IYtshJPi6EhPg8KujzaaObY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C02B2A30442F9A4BA815E4298191CAC8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9f3242-8a52-4e0c-aeea-08dddfdc40cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2025 11:25:22.9304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MAvBelN1m5AH4L1H7raIkeCTkBd2wY/qiLv3pX9bKHr/ZCEHPfkV8VYKeREaU8vY9EWUNTKtBRmdIiWBVSTx8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF496D5EAB2
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTIwIGF0IDE0OjE4ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+ID4gwqAgLSBDb250aW51ZSBvbiB3aXRoIHNucF9sYXVuY2hfc3RhcnQoKSBpZiBkZWZh
dWx0X3RzY19raHogaXMgJzAnLsKgIEFGQUlDVCwNCj4gPiDCoMKgwqAgY29udGludWluZyBvbiBk
b2Vzbid0IHB1dCB0aGUgaG9zdCBhdCAoYW55IG1vZXIpIHJpc2suIFtLYWldDQo+IA0KPiBJZiBJ
IGhhY2sgZGVmYXVsdF90c2Nfa2h6wqAgYXMgJzAnLCBTTlAgZ3Vlc3Qga2VybmVsIHdpdGggU2Vj
dXJlVFNDIHNwaXRzIG91dA0KPiBjb3VwbGUgb2Ygd2FybmluZ3MgYW5kIGZpbmFsbHkgcGFuaWNz
Og0KPiDCoA0KDQpJdCdzIGEgc3VycHJpc2UgdGhhdCB0aGUgU0VWX0NNRF9TTlBfTEFVTkNIX1NU
QVJUIGRpZG4ndCBmYWlsIGluIHN1Y2gNCmNvbmZpZ3VyYXRpb24uIDotKQ0K

