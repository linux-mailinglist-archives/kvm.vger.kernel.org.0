Return-Path: <kvm+bounces-54632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E161DB258CE
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 03:14:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDB851B67C63
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 01:14:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F03A417A2FA;
	Thu, 14 Aug 2025 01:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hHNLgEwz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637542FF653;
	Thu, 14 Aug 2025 01:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134060; cv=fail; b=CxmMf3QF7UP0DQ8160vsabV1Pa2VrOntcVJU+98tC88uD6LoXQbRYs99dSQlU/PNskd3T4OP9azUsc+wEtPJ0qcCF0YKl1e6QijYslW3/xnTAPcP40ySj+nGI/Vq1dsFrYEoylwkiCp5IQUoX6uHhXuIqXEJmCNpc/pw4nRu0cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134060; c=relaxed/simple;
	bh=DjGYyfxSlSmW5/6adUbAuX1/3Q2Io+1KNTYr+YmAChA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZEZsJ8aeGDHaZdZ2UjsoIBIOGXIKE6w9K1vvm4yAa197lORtp+EImEZ9svTDSUXCIu1teavpxBQmmsEuPjk0SnELeeGiewMJoOu7I05D67Yw3Zzya+fq+hllTeTc4FOKyhE0n/ypkN7ZKLHekGQuvGLWHSwePcgiS6Zf3+G8VKs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hHNLgEwz; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755134058; x=1786670058;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DjGYyfxSlSmW5/6adUbAuX1/3Q2Io+1KNTYr+YmAChA=;
  b=hHNLgEwzbPH4r8hWZLFuERzt+z56tF1M/x/OgdPOhCU9PjpdzDWjRRIF
   irt8qSyteB/HYtb2a7poM+FBLY/PX0MT1PBBllqcBMn9kfng5dZN9MptW
   adpsu1nJ3BB2cd0WfXYDUinBViwbCMGuNelplM+tRg/n02dFIuBc9smy4
   nBE2CjeA6HIUm1w5O6k9mM9Z/q0927cJTX0LACDwhqlTEs0fuVsr8LTL6
   4JvUDlils5Nh7hVuJJw0ZcQcgeJqOtsaepupMddsi0exQgV3shxJOBieD
   7KBSL6PV4aQM/rRnedBfr4kHwawFI2hySm+3N/tB0BDQNjakhGLLWUDCR
   w==;
X-CSE-ConnectionGUID: 99WahjVpSWqMdhZ5pauJGg==
X-CSE-MsgGUID: 9JdX9HvzTcyAxBoHUbpgzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="75015818"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="75015818"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:14:18 -0700
X-CSE-ConnectionGUID: sicr9fKsSuWL/DRQgKU8SA==
X-CSE-MsgGUID: LVlbZnKdQs+jnw7w9N4a/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="167424626"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 18:14:17 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 18:14:17 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 18:14:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.71) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 18:14:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=udNVK//2lorEemqeqzog/Ire2kp533GAKIsB2Y5ZbULTZjaJho2ZvlTkSWc0lRvd2ZHuXsim9qYWqh+nm/1j/11zUdRdpEpioDYhF+mjF4t2Gn9fkXheG2hoVeBGJSJsl7hGsfdzXzjIdDyEUrWZVxmC4KnQH8MxmhMldaJgDC+b36PGk1/S92htnIAxymMia9TutyIeQprjE4X71OewrkQZYcq44CvggqLM2h4BqGO2NQPQRn72K+l168a6aJiVk6f1JfjFUwQekGNcf0PbwiE9/C7jaB/9NtkJedv7TiDzDwvV4RFWW4nLq2OVQEIaIFtrHq/VtJz17A7MZJ3y4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DjGYyfxSlSmW5/6adUbAuX1/3Q2Io+1KNTYr+YmAChA=;
 b=AgjjfsBO5MovL9eVFbgH2PuFUQRbuHW66BAS83ddKVnbXmj4kr5fWvZi8Nc4yt2G1D81zxFnq8mW8UGHcE+sPTO96NTpOrhlRqyHU0VPKT48ka4Eyc6qt+k3xK944/xLHy9uyCF7BzGSHrGMmGRNKxAol7I6kgy6imNV1qEK0a8ccAngncGsTW+uOZYlftaNzNDSErDw8n3D0GBCG4EiG0meeg9haccKXr2b0mHu5VANVXfRfG6qbw2XZuv+5N/RnWdxCzqL4jwfeY05Pf4qCUn/0W9I4pp2rmKdx7J4ubFUdf7dLqyYfeEg/q9iPD0mGJy+bB7FGSN8rIOS5xnOVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12)
 by DS0PR11MB6542.namprd11.prod.outlook.com (2603:10b6:8:d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.24; Thu, 14 Aug
 2025 01:14:14 +0000
Received: from DS0PR11MB8018.namprd11.prod.outlook.com
 ([fe80::3326:f493:9435:d3df]) by DS0PR11MB8018.namprd11.prod.outlook.com
 ([fe80::3326:f493:9435:d3df%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 01:14:14 +0000
From: "Guo, Wangyang" <wangyang.guo@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, Sean Christopherson
	<seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC: "Li, Tianyou" <tianyou.li@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>
Subject: RE: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to
 virt_spin_lock
Thread-Topic: [PATCH RESEND^2] x86/paravirt: add backoff mechanism to
 virt_spin_lock
Thread-Index: AQHcC+yQEgE5TQe78E2AKtk/v3wmArRgo+CAgAC1XSA=
Date: Thu, 14 Aug 2025 01:14:14 +0000
Message-ID: <DS0PR11MB80186AF86A0924C8240437C09235A@DS0PR11MB8018.namprd11.prod.outlook.com>
References: <20250813005043.1528541-1-wangyang.guo@intel.com>
 <a79307f2-e6be-4e59-a74e-16e09ed69e8f@intel.com>
In-Reply-To: <a79307f2-e6be-4e59-a74e-16e09ed69e8f@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB8018:EE_|DS0PR11MB6542:EE_
x-ms-office365-filtering-correlation-id: 18288500-6cc3-4a21-b623-08dddacfe244
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MzFZMkNYVU9CVURCaExIeENNZCtKaWp5MitZNGIxY1pFM2pBSU53OHFmRStF?=
 =?utf-8?B?eUo4RFlGK0ZWWTZSM1RiRnM3Z0dyeGNObnpJQTFYKzRIZlVKaFZVVy8zUk1s?=
 =?utf-8?B?WTkzMUdaSGJSSytBdkFZbFhMS3hWQmdmMVNRd0lSSTlGdCtmbkhQK3RkT1ZL?=
 =?utf-8?B?N0lzMWFSaEcyWnVxaGpzZVNaZlRpeFVnSmdBN3VNcHRSc3RXNGNsbGNRYU5E?=
 =?utf-8?B?cTJZMitBandBM1RLLzlIZzBnQllpcXBmNUtBVm9Cc0Rodnk3S2FBeWY0aGZU?=
 =?utf-8?B?ZHlOZU8zbjBCbFZ3WmZrYzM0WE1Pd09hWHlFbWJoZTd1aVFxTDhlb3Fab2R0?=
 =?utf-8?B?NFJETUhPajJEWEpYYTZxM2x6S2ZxU2UvVUplSFl6cko0bUkrS3Y4SjZQa2pD?=
 =?utf-8?B?YVhkeVlrY0FrcjdoeXVsaWw3NncybDZrYW04Z2lEWU9JOWRLQUQ4LzNpa2Ri?=
 =?utf-8?B?TVVqUTc5QjVJelRCYlpKWVZUWlhlZy9MZE80QjdaS016bWlOZ2dvQVkzU05k?=
 =?utf-8?B?SVVuekhIZ2lZMFU0VkxmM2dCS0RBaDhPUStHSjBsRzVzR3FFZnNRWlFvbkFH?=
 =?utf-8?B?K1YxRGVzcG9zUUFNY3hRYnRsR1d6NlZHYUM0U3lMbE1GVWVFSkNEbEQ5TTNX?=
 =?utf-8?B?OGt3ekJFOGxRK2tZRUc1ZVVzTHpNc2NwdmZmb2lNb25zODdTSUxlNTB1SGZK?=
 =?utf-8?B?YjlxU3daMjVpOGErQzZqR253YVdqRTFZTWNlbUZXZlV6ZUJrbHRFMlZZUnIv?=
 =?utf-8?B?NTdHRFZXYUVUaHBMTFdFK3hoVEd6QlcyZjdoa1NGQnlzT2lhQXlxbkRQdDZW?=
 =?utf-8?B?VFdaV2dyL1JWOVJPRHEzQVhpdEdjT1UyWmp2bmRCN3NSWklXUnlZaFhLWHBH?=
 =?utf-8?B?YnIyQm84Q29qZmRHNkRxMFkwUXFLUXhlLzhEWmQzNGYyWVErNldOSlRua0Q4?=
 =?utf-8?B?N3B5Nk5EMWlTQUViMEQwY1I2SnFKQjRhNVlnK2lDZDAxMXE0Y1gxYXZUOWEw?=
 =?utf-8?B?bytMVENUNlV1WUxBZzRmUmpxcFB5THBKOThURVJRR1VtZ3RJVFdCR0RuVHI1?=
 =?utf-8?B?M3ZwRjQrZEhLL3lmSGxkSWpBejZNbHc0YjdnS0I4cnNZYVlPVEU2RXlWVzJ5?=
 =?utf-8?B?QmFJS25iZ3krYzlkYktFdFNSd1BKYVZHUXdwK3N4TGtyd293d1VQWU9hK3pJ?=
 =?utf-8?B?RjdzYStMampvV2FPUnI0Tk11VCtUZnNuOTlXbys5UnBzdlZnQ2lBS0JHYmhB?=
 =?utf-8?B?UWpSMmUzbjVxM1RrcGdlRUFrRUVybzVRYUJ6WFUwWktvQml0SHVsMTBBTFhl?=
 =?utf-8?B?dFB5ZE5KZjJuSkdadmg1WjY3NzVVVFNKRHdCUkswd2tTZkxYMmRDV0FxWTd4?=
 =?utf-8?B?dEpFaXUyaTZPUVdjdHl6RFBxU3A1VFdwS1dsQndOM2dZREpYQnlWc0EyVFNv?=
 =?utf-8?B?ZzBxUWY0NnlQblJvT2NyOVp2NURBTWh5eHVNbTRmNERBckRlZGdVOTVOUjRG?=
 =?utf-8?B?UVVWbW9nS2Q3RG4rUnVVYzMrRVVVZUMzcjJ2RHFYTmh0eE03R2pFTXl5cWo4?=
 =?utf-8?B?UXFhZ3NCUXVhbDEyQndOY2FWNTFHWGtQRWNFK2ZLTWxwTnNKWEo1MEJCRktq?=
 =?utf-8?B?d2xWdEpSSjh0U284TUtieUMydzF1M2szWmovLzBtZmtnaGo0enpjUnBKNm8r?=
 =?utf-8?B?L3g3di9hSFp6TlRwUWM1Rlc5aG5ZY25RRnpyditJUnFqUU12Q2Y4UWVqZ1Fv?=
 =?utf-8?B?cTduNWFuSUloQjRXaHJIVlpnQTlvMWxnNXdOOWp2Rm4yaDBUaTQwK0tJZUxN?=
 =?utf-8?B?NEpyYm1PZk9JeWtCdnZMc2hyTnF1TlltNFpQMDZpbUV0dEFqcVpqdngzaHQw?=
 =?utf-8?B?WXNwZ21xSWd0ZU9UNHJzM2dEVkthVkJ6aEVtS0RBRFhYWElnNUVKUHM3Rk93?=
 =?utf-8?B?ZTcvMkhPWEo3amVsbC8zYzRBSkFidXFXSDFjd1JPV0lxb2I1L0lwZFRZbXI3?=
 =?utf-8?Q?UPMlnAYY0yOJ6EbNmOR8bVS26Jchz8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8018.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cytMc1B6Uk1ybkR2eWVhU0NiSC9NYzlpS1BhRE5wU0VRNVJRbytZcmhxVFht?=
 =?utf-8?B?QTdlTCtXaFhodUZDMFlKRGUzK3V0TndxMFhJMm5FOEtuSzNHVlQ1V2tvMi9k?=
 =?utf-8?B?Smh2a3laOVAvRkIyZWc0Y2FseWZ6TmNyU0RlUnZxc3NZcXpmb0lJMVY0ZG56?=
 =?utf-8?B?c1d5MzEzVUtpbTUvTVdqWUMvcU5NYmN5MGNjcUUxVkx3dnRPUlljR3NMTCtk?=
 =?utf-8?B?VWE2NWRZb3BJQW54R3p2WnJTZ1dQMnNjNlZaOGNaQlhITHRab3BqdUJJQ0to?=
 =?utf-8?B?VnF5eVVOVFZKTUYySlpQL3N0ZnZoYzlSYTNpdCs5Q0NoZnptRU9qbWJOaDhR?=
 =?utf-8?B?ZVF0VUlFMXBEL0VhMXJTeHV5QjZZR2ZtbG9OdDBKZlBBVHIrUzVKMHRqODYy?=
 =?utf-8?B?Q2ExSWdSWjJMNzYxYTNDUXNmRDYrWmZPRkRLK01mazdMa2RIaE5wWjA2bjFI?=
 =?utf-8?B?T21HcWR1Wkc1eVp6em9QL3RGV2FwR2xwOGRzcTdBTHlFWVAxZ3lRN1FqZ1dp?=
 =?utf-8?B?dXZ6ZFRTVDVOSTVXS3poYndjd0ZJdjQwT1N5bUkxcHBoMWFWMUw5bmxFcmtZ?=
 =?utf-8?B?aXhzVlRSTDZyUzRXdFdWSWFHTzdBckxYWDFGZ3V5RDlJZUZxRVBhbW9BVmNj?=
 =?utf-8?B?TDRZVkh2ekRwWTBFRzF5UytKWTdhcVR4bVRBWW9TUVhGTDJLYzNrSWV2WWdZ?=
 =?utf-8?B?MEg0RFY5cVFXQ2xlWTJJdTYzK0JzYzU2UWNBWDJockJ4bDl0YXR3RjEwL0Qy?=
 =?utf-8?B?MU5QQTdaUEpZdVlIWURkeGk2WlNMMm1iVkhmZUJDME1uNmpqSDE3M0FPYVNY?=
 =?utf-8?B?azByYmZnazlhN2dUYlF2QkRISm5oV0VxQjFTbHdJYjIvaEZJdlhWdDN3SXNU?=
 =?utf-8?B?dThQYzViNS96OUJwODg1ZXZyZGROZDdlelB5M2VGblJoU0U0a0lGUXlpekxD?=
 =?utf-8?B?T3ZaTXB4RHNwa0d6cDVWODgwb00rdjczdnBJWEp3NlRtb3pxelY2OUQ5UXl5?=
 =?utf-8?B?RkNLa1JoTEJkUVNtRnJIN2NvTk9IeEJLMEZEblZUbkJsUVJFN0lQQUQzMlhp?=
 =?utf-8?B?ZXlVc2xsby90OXF0QnlKbVUyYUphR2lmaEsxdmJhTWVTbUczNTBCbHFCcTRP?=
 =?utf-8?B?dmRPMXFPeEFUci94SWlhOVVhcHRmeU5aLzcvbnJ5MGVBZ25aOS93NnlKRDRG?=
 =?utf-8?B?ZGsxZW55eG5TWm1FSmwyVVlmd1hqOGVkUFdkNVFmTWhOb3RVRDBoamU0Zkhx?=
 =?utf-8?B?YVRYYThVTmdHbDJKR2hKZGFhU3hXQjBWUVFkN1FLMG9LOS9rMmZnc0ZQZGdv?=
 =?utf-8?B?R25UVmhOREo3OTAvS2RKbCs2ZmYrSU9FVS82R0E1NjF0aUoxKy9LMlIydFRT?=
 =?utf-8?B?QnhJMnpXajZYK0xjekFmZ3kybUhEbEVxTENRM2ozVTJnVityRytkMHF5TGdS?=
 =?utf-8?B?WTZ6NzQ0NGl4Mk1PTTg5SUNvalo2N3JsakJpS1ZvdzVvSjVDcGxlZGJVTnRB?=
 =?utf-8?B?SHpzNnJRTmtjdHdCSVVZUUxtcUlKb3ZPKzMxYUhhdmVVV01iV3VDdmhidmJC?=
 =?utf-8?B?VXhxdnVFRHNHNDhXVk5JVStYMTErY1d6ODVub3JXbEl1Y2lkREdodDNEbGZq?=
 =?utf-8?B?aFJTY3UvcWUxVmF5eUd4amh0YVJKVG40NEtFdStjVjFxVkorOEo4V0dkWGdW?=
 =?utf-8?B?Ylg1OE54dWZSSkZOYzVGWVduK3lOQXkyNFA4UjR6RVlacXYrVTRpaDdISW1I?=
 =?utf-8?B?WXVkaHZ6QmxYejEvUDhHRzZOYndac01MMittSGlDLzZlZzYwZUNqaHByUmwr?=
 =?utf-8?B?ZGRJVzArWW5DaGJ6ODg4NVE1V1dSRTlIZnJXSURCRy9hdkpid29nOHNHN3RN?=
 =?utf-8?B?WDBzM3IwbWsyRmxLZWRUNGd5dEVnQUpvVlY4UGJPd25YNHMwWmlubHR4cVZ4?=
 =?utf-8?B?Z0lBNWpCZ2h1VUlRUmlPU0J0MitOc3JsdCtsRDdTY3BNYitvYlRFekpjM1gz?=
 =?utf-8?B?bWs2ZmZRUGcvVytjSlFVNGFDSy82K1J1a1BtaEV5YUZGNFRibzg3d1VSUXpu?=
 =?utf-8?B?U3E5REdmSjlQNkhYRnA0WDMxSnNSRlBLK1BXM09MdEI0dUpXRWQwY2R1Z21v?=
 =?utf-8?Q?yzMQ3Y7YMTLPHRUMOyMPZ1ujM?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8018.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18288500-6cc3-4a21-b623-08dddacfe244
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2025 01:14:14.5333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ymi1PIiE7E9K/q8BoosRIChBhE9/XruFRLdLVvSkdszVGTFYZddTb35GYAUnGVqMLJ52x7GcE2+gql1FGgQ/2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6542
X-OriginatorOrg: intel.com

T24gOC8xMy8yMDI1IDEwOjIzIFBNLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4gT24gOC8xMi8yNSAx
Nzo1MCwgV2FuZ3lhbmcgR3VvIHdyb3RlOg0KPj4gVGhlIG9wdGltaXphdGlvbiBjYW4gaW1wcm92
ZXMgU3BlY0NQVTIwMTcgNTAyLmdjY19yIGJlbmNobWFyayBieSB+NCUgZm9yDQo+PiAyODggY29y
ZXMgVk0gb24gSW50ZWwgWGVvbiA2IEUtY29yZXMgcGxhdGZvcm0uDQo+IA0KPiBXaGljaCBzcGVj
aWZpYyBsb2NrcyBhcmUgZ2V0dGluZyBjb250ZW5kZWQ/DQoNClRoZSBtYWpvcml0eSBjb21lcyBm
cm9tIGxydXZlYy0+bHJ1X2xvY2sgd2hlbiBkb2luZyByZWxlYXNlX3BhZ2VzLg0KDQpCUg0KV2Fu
Z3lhbmcNCg==

