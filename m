Return-Path: <kvm+bounces-48337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1475ACCE24
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 22:24:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3907E1761DC
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 20:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787E6223324;
	Tue,  3 Jun 2025 20:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ao7c0E5N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD410C2E0;
	Tue,  3 Jun 2025 20:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748982273; cv=fail; b=og+WrLScXTOgNiVRmSjPVmciqTVF7ILnnCSdbcLan2ZDvhjgE7vNuk2rmQbzoX5HdUfDy/QP/VBTcTRvZzcqQeNaNOj5ccRd8Q9IApE078KOp76beZcBIT4ZRTachH++rnYpGxNRJV4L+O8FsdI+aumqLPomIiiLidAfZ6gOgtk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748982273; c=relaxed/simple;
	bh=o1Z1IVLZECNz9EGen6nE2nmuQROPpdIGmk5L0isgKrw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IdbJy8YIpD9rKxGbcwVKsZ3m7x8tl+uHBRdE1jz0atWH7o8gkUcZ0Xgsn4OOs2Vbx5TSjTIXvVHGsyhE9cDbqS3II6L9Pe54QLDJv+GYZCwKqvqBDh+BdegaaS47I08NApDxzBfvRANrmsJR57FZUrG2Yspj37Iq4rQhoaNtWKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ao7c0E5N; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748982272; x=1780518272;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o1Z1IVLZECNz9EGen6nE2nmuQROPpdIGmk5L0isgKrw=;
  b=ao7c0E5N2dONTs2sO14ck41FvLvdLLLBm89rBA/BbPreYEkcRyQhx5ZM
   SvcIrozupbmrbn0y+wEu5jDLNEw0F4u57oRxABGoBf0FojOkscj42vTO0
   ZDumxKlsbaBvQw0tpWWGbfN/0jPL8aP05KdlV3kntUVd7oXcA4Cgk1Pmm
   gVxjEhxcmiTwvr4MY+dJYJUSrAOpQcuAcpATvsDdNGcRNstUuGl9lWeuI
   yRdowIxDLrTHyarVanlgR432q4amQp3hWsCV//9TrIbs+qEyntnmQ3d0Z
   +hL5H4kQpjtybylOFVMMZgFgySdmpj5aVrSbZSTSyTgSJ9381oxbZ1b4p
   A==;
X-CSE-ConnectionGUID: VGKKn1XbSAOLol7BRRFu/Q==
X-CSE-MsgGUID: uPdm7avCSfeU/q0OURPnTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="73571075"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="73571075"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 13:24:24 -0700
X-CSE-ConnectionGUID: FDbn1UDFQP6AIbp7aLnErQ==
X-CSE-MsgGUID: Dhrmz31pQZOHJuUQSkGo4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="144852059"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 13:24:23 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 13:24:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 13:24:22 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.66) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 13:24:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aiJtKXmrMVnXH49vJDhdHltYOcGu3JjM8vbtB6fXCmYrZO88Kof2FWqPxOlmoQsz3u+kx2ke3Wl+wBVn/KLO6lt9SIK51wzbZnqDzXMv5L+5L8EHtdl20vBj/KtOdntfMIGroNrU9WobwFM7cQyxOQD7Hxhi6blQUuD38/zflLfxcjO4uQDZ8T9FvSti6LCMawsXqLMxHu4dlLJAbYdpe/FsUEz/0wME7mVTHx9bOjNrX3AsywnvCF/TKzZmxNF+V0AdDT/te+cbXCSr2GnuaaGntjEMRcSJZ1bEKBmgvDri2IwvtsnTeVu7PUdpeVJ1NMRe7HpXCtPPtPWR+NsBvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1Z1IVLZECNz9EGen6nE2nmuQROPpdIGmk5L0isgKrw=;
 b=oXLaka8EPF2gsDoZUVHzE02PNAqEPLPAXpdKPDqAnSlgQkwiXQibDLhezkCy1A6aacryklLpkP3UNeAC0PqXxHUsU0y0ldWTnUC42m1wTyNuM0sS3aeU4rWN/tNf5dj7GnYJPwHsB1psD0iU+2p56lKNgHp3NKMgVvEkwjyJtUflio4tS26NP67sZA4aZzU2Qed3m24krE45gYq4UFh4uYLZuMHvk3wPhEL7toFA08SDRFYP/31TLddkNNooA7iOOPSbJTquw9IQVH43v0FANNbZHb3HOuchy3rJxy1t/1wZ5RYc+g9bP+RnMcy2lsaViTt7ixLs4dQ+T95RF/chjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by IA1PR11MB7728.namprd11.prod.outlook.com (2603:10b6:208:3f0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.33; Tue, 3 Jun
 2025 20:24:20 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 20:24:20 +0000
Message-ID: <519077fa-5fe2-4822-865d-88b8fa0d7648@intel.com>
Date: Tue, 3 Jun 2025 13:24:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/9] x86/nmi: Extend the registration interface to
 include the NMI-source vector
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Xin Li <xin@zytor.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski
	<luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, "Sean
 Christopherson" <seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
	"Zhang Rui" <rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
	"Andrew Cooper" <andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-4-sohil.mehta@intel.com>
 <4e6d865c-597f-4281-a07b-94aeffe938d6@intel.com>
 <cd6e6d88-944c-40b2-a343-3d81415d9b64@intel.com>
 <0982b21a-6861-4955-a6a4-4c9ee1aa5a72@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <0982b21a-6861-4955-a6a4-4c9ee1aa5a72@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0014.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::27) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|IA1PR11MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: 832f6c36-c504-4514-e978-08dda2dc9f3a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WHF5dlJMdlp1S1hMM205dzhiZWlQaUhhRHMxbkZvS2NXbm1VV01XOEE4V0Nk?=
 =?utf-8?B?czlwRDNOWlJxTThpTkI4Szd0b1doM3p2VjRjSlRwYW1XeStYZ3pTcVRZYnFp?=
 =?utf-8?B?eHNLNGJ6dXRIZWFEZEpxRCtlRDZpdnFjM1d4Z0R4eEdwM2U5SkpjRFVuTnhF?=
 =?utf-8?B?d0hlQ2o5WHE1QThqZ2QvL0xTeXhUVWxHbTZBaTVtM0ordk9GKzRoRTdjMzRN?=
 =?utf-8?B?TXQ0RE5vRUJ0V0VXM3BkMGVhVnFBVWxFbEhnKy9HZlVOM0dWTk54dC9HM0dV?=
 =?utf-8?B?RzRFQmVqTVNSOHdzUGpKSFpJb1JXM0VtUGhsa0JDRHBiYWJ0Wk9BVDR5Q09s?=
 =?utf-8?B?ajRMSU15TG4rTEt2a0pMY2p3S3pIYTkvNFZHcnlFcjdIUUVsVVhaaVNMelBY?=
 =?utf-8?B?eXhuTUR0REg4ZEs0RUJ1dGFzSGJTcGF2d2t1Z25pUHZsZjhDcEtFN1BIbTNr?=
 =?utf-8?B?OTlybUhyaXFxUzd0T1kxTnlxZFd2TkU5TENHUjVDOXA4OWZnM3RmVXR6ZnNu?=
 =?utf-8?B?NDVhRnVWcGtjWDA2T08vcG55V0RuL1R0V0hJYlZjWXJSRHYzNEg2NGhBWURk?=
 =?utf-8?B?VGlyTDZpOS9VTldYeTBpcm1tYUJjSVBvT3N3Y2dyUmZDWENWcTI5cmYwVjhN?=
 =?utf-8?B?SXRFRW1GWU1oZ1kybE9ZeU1NWjNYdFZmRHpVV2VwdDllZDlvcmdOajE3VUNo?=
 =?utf-8?B?NzhMSDB2SFE4S2ZrSWNNTUo0SmtmUmVnV3k5TkZkdHdZWVphWldFRkJCd2ZX?=
 =?utf-8?B?NkN2RDNtL3JEWnZLWVlTVkdjd0t6Z25FVi9GVHU1YllwSmlaU1h0RnVzOWZZ?=
 =?utf-8?B?NlE1TFFtd3VvZy9ieXZoVUZTejQzZjdGbXZwalpxekVBVk9iejJqV2wveUpF?=
 =?utf-8?B?ZnIxUlUvNGdkQ0FGeEtwVUNnT3ltSThpRzYydGswSUZHckpnWlFlWnR0QXJP?=
 =?utf-8?B?NXE1Uk5VNUxnYjVHYXBIOGU1YTg3RjdZQVJxR2lRREp0MHBhQmNPQS9zUFZI?=
 =?utf-8?B?L2JyOFQvM3JWTElkdzh2MXUxOGZ0OHFNZTFlTXhLSE15dzAzWW5qdGRud2ww?=
 =?utf-8?B?UUhiMHUzWFJOdlppeWU1dlBhMUtISzgveXJ1TWREZzh5U0hPVXlzd1RxTkd4?=
 =?utf-8?B?cnZPeE9jUXlPOXZwUk9lWW9oNytYb2JpVUlRcWJIUHkvWHowazJzeXhxa3JZ?=
 =?utf-8?B?ak9aWnZZN1lyNENpaWRCek9vVEtzYml6bHo4Y25oQzhqbkFFMW5wdmt2ZHUr?=
 =?utf-8?B?TkM3blNKSElUeHlvMEhGZ1hCK3pWeXZ3Y2hRcitHWmY4clpXUHVQcFZzWk5G?=
 =?utf-8?B?VzlVL3dUWi92ODljZUZocnVrR1l0WEVmc3Z1RzFlYnZ3UHY4ODB2dHAyZGpL?=
 =?utf-8?B?c1J3cUdkczZ2amtYYW5jdGxqalMwWThBUTFJcWRuMjhBK3NUUjdCeThmVFRW?=
 =?utf-8?B?dFpMTG4rWUlDRndDeXgvM0lwdVFBRFBLMVJ5MGEwbFJMUCtmU1VmdUE5SHgx?=
 =?utf-8?B?Q2hTUEgxNVBzSFJ5VWZkdTY1ZkJ4ZFlRMkQ3dzV0akJGWnlQa201UWtYZUVW?=
 =?utf-8?B?U2FaNnMvZmg1alN0VUFIYUljUmx6YjRLS25za3NhNEJBaGxwNlg5Vkt1UkhJ?=
 =?utf-8?B?NDM3QlB0bWZ2Uk5La0pjTy9YMG13NTNqRWxZZjZXWmFZRTEzcm1NNmEvajho?=
 =?utf-8?B?TjJEWVJodTZqYnRpRlc1UzBDazc0VjRGaHMwSTZscytTZlY5ck5Hbi9RZFh5?=
 =?utf-8?B?OGF1U0RZYW9tbERYbXJMdWJLWkJObmgzUXIzNVkxRGlkbWlyek1zWWZrRzZH?=
 =?utf-8?B?RS9OYlF1eFZSVkpNbXpPcnJ1SHZVMVB5a2REcmdySllNamFoVFVSL2lyZTdL?=
 =?utf-8?B?Y0gzMWhINGdMT2RNSGJ6dDVHRnpaUTU3MDgrMkFnOW5xak5aNE5ZdE8wRU1C?=
 =?utf-8?Q?Pm9ufScOTac=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVVhU2R1dXRjZjBCVWo0Nk16VFZyM1RFVjRWN0xHZElEbTk3cFhQcWZmMDY3?=
 =?utf-8?B?WklYcVpDZkRMKzV6dlVxTENON1Ewb2JwVUlHam9QeHlvZ1docEF1WWZQUnNV?=
 =?utf-8?B?N3BpVFVPT2JIS2FSdXkrMTVONThpMVVqWmFyQ0x5bm9mdVRNeUFqeEZVM1VX?=
 =?utf-8?B?aGFGY0xJSmcrejhJanV5Y2xKZWJKU2w4TmVpSGowMGJvRjNNSGlsN3EwcmlT?=
 =?utf-8?B?bzJZY3diZDFoVGFSU2xIZ2k4Y29zanpxbWlyQzNGZFN4YnloR0RyQzhibTlL?=
 =?utf-8?B?VTJIZkZCK1Jhelp6aXl4N2JFUlhpVFcvZXlGZDhGK0hqVk9uSFFlZUt5OVFB?=
 =?utf-8?B?b2t4SnI4c2JaQUFidUVkRXpzNzMxRTMrN015d0ZLbFc4WXNGNk9rYVBhVlJQ?=
 =?utf-8?B?aE5tbHlqSnR5TnhjUlBRVERDTUhWdWRoVWNzb1k3VFZaVVkxWk9CeUpwZ2M1?=
 =?utf-8?B?NkpSZ3pSamdPRW5jRGxHWlVoendMYklhV1J5cnNyN1c4TzZzQjVxWGhCMjdR?=
 =?utf-8?B?UThqdU4wN0lIQXRONjBJUkoyZ1V4ZFlFcjhsay9YTnFMRkJjaEUzdHRzdE1U?=
 =?utf-8?B?NndZaWJjSVRSSUhmYVMrZjYzZGNNWHBJYTREUXJPOGhqNUYrVy96NlcyQTVL?=
 =?utf-8?B?ZUd3SUZBNnFYbmliNlF1a2NxeWJuVDQ5WEZQaXVxT1FOc1RLbkFRd0E5RGZo?=
 =?utf-8?B?SWwyMnlaa2VZUmNHeUNPMlJKbENFUWVvR0FRUXVXK2pKSUxWQXIxWVdZaEZy?=
 =?utf-8?B?TDgzMlFobUNWeDBZWXpNOTk3OGNjQ2hCV1ZCNStjb0tMTVRWSkcweHQzN2Rl?=
 =?utf-8?B?Ull5eUFiUVNIVXAremFzRUdPVWZFaTdCS0NtQkQxUjhRZk1Ydkd1UGVMcHVv?=
 =?utf-8?B?bE9zWE1BNEc1ZElKUnhITGVrS3pCWDlTUHRvVlNhai9JUUx1L2Z5N0tpS05F?=
 =?utf-8?B?bHZGV3p6ZWZQZy9UMEdpSm9ud2Z5bTMvcG5BakttVzBoUlJqY1hMNFplRVFJ?=
 =?utf-8?B?UVhsaXhJbVFZb2pCaEtGdGZwY0RKanVEZk1iMElKaXp4dmxqMzZqUE9TVGhU?=
 =?utf-8?B?VDBsZmV5YWtPSjFvcXB5VWhROTVKZ05icGtrZXg4OGNCWWdPaW1VVnpiMDNs?=
 =?utf-8?B?cm9uOUtNOFZaOWJaY1g2T09MS1lKdlJoWjhPemZYQ2JmS0xrZkJDSDJVci84?=
 =?utf-8?B?dUtpQWowQmFSd2xhYW1QTXhTOVJURGVIdWRpeWdyVkpBcUw4RXR1VmdaMEZN?=
 =?utf-8?B?dTRqdXBUUi9PTmFwU2s3cGVmKzR6WEhNQWw0YmJGK3lSdGNWd2xkR2grclFK?=
 =?utf-8?B?SWx6eFBnWHJtUllPbEE0WitHMVJEMXNGU2JtUXBrelRNb1IxVGp3dThWeWM2?=
 =?utf-8?B?RVZlOWkwRTMxSjdOSjZvelNtYlR5QW5WZ2hWSGhkb0lUQTQzOURBbVg5a1dY?=
 =?utf-8?B?cDlDckIwWExSeDdTaWdsaVRHUVQrdnVneFFmbGtnRDdlaDlpVDhlNit6WnU5?=
 =?utf-8?B?RGpBSjRMZ2dwd3dUblZZRHpwcFhYQ2t4TDNhdTB3c1paTVoyZ1F4SjFSR05B?=
 =?utf-8?B?UU9XZzVzcmd2V1pGNXNXejl3YTExQm9rVEFPL0I5T3MwM1l5MCtZQTAzQkRS?=
 =?utf-8?B?OWJIV3lZODFON1EzSDZTRTUva09HWmd5eW9qQWp3NWExcEdobzh2MEtXb1Iz?=
 =?utf-8?B?RDhYRVpVNVlPd1hjOTRCNUVqNjhnUE93YXFaZU91UVlaa1dVRFdJelFJZ3FO?=
 =?utf-8?B?eldoMVcrUi8wT1ljWGRVMjhqa21CeXBIQWF5cmNsR0d5L011T29XRDVmSERS?=
 =?utf-8?B?clpDTmprNVkwV1lmQVBOZFpXOURZaGRYQTh6U2xUWEI2MEMyK2FRa1VYcmRx?=
 =?utf-8?B?aWdRYnZWVlRKUUJ3ZXA2dTR4d3NUMGlDUlhBdDN0anFGaHlwZytZM0g0amVs?=
 =?utf-8?B?L3RxSVVOU3VjMjdJVjZCZ3E1NGNiOGE1NWpOWGxzdWpkMHJtV3N3OStmU3B3?=
 =?utf-8?B?TUQwMHlGcGRqMW9YTzc0ZDVSdkE3ekVyRG00N1NkU1NiMmJXS3hyRDAxSkdM?=
 =?utf-8?B?UUcwTy9OOU15LzlQaFhnTTVjWjRXdjZYTmtETUw2dFB5dFVBemdScmtEK0hu?=
 =?utf-8?Q?uyi4Y7p/2L+jRcTbRJeVfh+EY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 832f6c36-c504-4514-e978-08dda2dc9f3a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 20:24:20.6600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wiR3oD6XS34a79t2H2wceFRdIsavu9URJhj1gkL+W/IRB18KLGUqD12GxM2zVNqI5GXVfCR9nEfPJwzqeOfbMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7728
X-OriginatorOrg: intel.com

On 6/3/2025 11:19 AM, Dave Hansen wrote:
> On 6/3/25 11:02, Sohil Mehta wrote:
>> The 3rd parameter pertains to handler "flags". The only flag in use
>> right now is NMI_FLAG_FIRST. Assuming that more flags might get added
>> later, the 0 should probably correspond to NMI_FLAG_NONE. Agree?
>>
>> The other option would be NMI_FLAG_LAST, which would be the opposite of
>> NMI_FLAG_FIRST, but that seems shortsighted.
> I don't feel as strongly about the flags. But this code has been there
> for over a decade as-is, so I don't think we need to be planning to add
> a bunch more flags.

Sure, I'll leave the flags as-is for now to keep the focus of this
series on NMI-source.

