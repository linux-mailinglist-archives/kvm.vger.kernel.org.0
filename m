Return-Path: <kvm+bounces-61570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6101BC224C5
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 47AAE189C84D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5832E346FA8;
	Thu, 30 Oct 2025 20:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/lkKzgl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC0133554D;
	Thu, 30 Oct 2025 20:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761856386; cv=fail; b=t3O1c2TIg4O5hQlbGfdE8l2RV+aI9T83oCtfI0FLWaem5Jw27/8i+ZAsxhTFWOOdMq8wUTW7E6K/elFKW8RKlbIUsFvcBk3WxpnnTxTwer94g7lAHE70KXuwk6ohjLM8Vd+vLUJo4qns6UraiDnyKttu4cDcgDlHhFYGVlsPsJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761856386; c=relaxed/simple;
	bh=g6kxR7v/B2KE26oPQ37eKRKddKjiY1OJ2sxNJtRDBOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oY6Ygt5hKke6EAILVT1Tzj+atQ5ZYnRI4eKpfbQofKbhpuwXlyIe8wUNjIbCiiIYoNbd3biDvk7bXVPmmEITG/4l59F6LoW0AGADLICDzKeFSTke2EOkQ2nc/jtcaSxLtM+KLfRQJpNSRzg/TX1fuJ1BrUxfn87BymwDn5HsTn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/lkKzgl; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761856384; x=1793392384;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=g6kxR7v/B2KE26oPQ37eKRKddKjiY1OJ2sxNJtRDBOQ=;
  b=M/lkKzgl3unuUC2+JHbtT2uweiOTXhpOGkSe17ZdvPxyc7h2m+dUDfAg
   UPKqcflZLdxdtycn3wecu2xAzOVcQ3n099K+E7N8h63oiGNk6ZAf4oNvq
   KWeoLXakav+YpFPYOT+z1H6xk+K35XkRHKLXySfTOfOgx1Xi/zS5JVhMm
   9lYWI1IWBCp7gWsToktM62p9GK3vZ+1Sfw1trXsu0oka1gHi/DxlJeeYm
   Fv+MsX6BMZOUzThcz4+6qC3VRR2nOg2hK/7qBa/szsyqvD6XlyU6MdefM
   P1kNwWwHlR84NNDEuFTKgd0j/w1Fh83Ua1ExViAyXyjd6SfTX5gnQJNca
   A==;
X-CSE-ConnectionGUID: u3N/YjpzTo++C2vK37LyPA==
X-CSE-MsgGUID: eY/Fpq9hS82o59kIV1hP/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63939295"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63939295"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 13:33:02 -0700
X-CSE-ConnectionGUID: SeN82GCqSeGPw/7TrEN1KA==
X-CSE-MsgGUID: 83M1r8z3SkSmekTJ2ja9IQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,267,1754982000"; 
   d="scan'208";a="185262607"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2025 13:32:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 13:32:53 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 30 Oct 2025 13:32:53 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.17) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 30 Oct 2025 13:32:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jfOKGkNUd8GK7uo6q3gP2GevzOjG5GI25a+F8RCBecHkA/RUYMTlqwiaACxjJuOmEgFNROYxXiOiesu2nwPSz/lt5Yk5dgxVlUxrUeD1z6Qd0zH4z39Ywiqqt/Tt/LwzeX36h2Hq5C8op95SEFDSo1S8mfmlbaZJB7n3ldhuRTRty75B1uV3kbccXjxLvxGxIPUZWMDxC+5urrj04B5nYWMYEo9XdTJl3GmSCYx/XAajH7WligpDOTm3aRqNx2V4yuimaRiBs6XvEB1ShRU3mwdhRt4swdUViDkV/aUqw52GBYDG1k+QEGiWotZ5EdLTlMgCuYbpiFrKGb+1QdbhPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VNIkldKxhJK9RgSIFDZZYEB2yRku14V45O0gtb2GTtU=;
 b=PK9JqQ+GaOGJtn9tBRUL4/oqbC7WS6RGv7LUi4oV0ArfOnNNDakjYxPoqDJi8Db0/kMxgnaWVmdH4EHpERNfEwSXSueHzcyAEXuFvRAgT+WBKF/w1lnHzlVuYT2hfRui25b/nzVL35QmFl9C4uFyAS8bVqEuI+gHIMWVyHkUFQT7pBwl9QjNGwD/UJKxcOoAijR/rCBDPykXMwq0MhDgAm4KvtSYRIuofL9pK0b7mkjbwvLuWij+NMHJQ8fBZV9p2qOEapwGiwCC3AG6yQvEcwuSjIrGAcMmcBKSKlHmq5KkGRNWVFCX7VtQ+sWw37aKuMq03C6O0H8GWovYjSL6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 MW4PR11MB6960.namprd11.prod.outlook.com (2603:10b6:303:226::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Thu, 30 Oct
 2025 20:32:49 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Thu, 30 Oct 2025
 20:32:49 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v3 10/28] drm/xe: Add sa/guc_buf_cache sync interface
Date: Thu, 30 Oct 2025 21:31:17 +0100
Message-ID: <20251030203135.337696-11-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251030203135.337696-1-michal.winiarski@intel.com>
References: <20251030203135.337696-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0101.eurprd04.prod.outlook.com
 (2603:10a6:803:64::36) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|MW4PR11MB6960:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a7d389-7adc-4504-c652-08de17f37de2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Ym9iU1Urbzg1eVhXWmtJbUtnb2wxYXRMWkZUQ01GWlk1UWM0QW5XaGJibjl3?=
 =?utf-8?B?NGExcms5YS9CR2xSZTQ2ODFVbnBMa2Vsd2phdEVhNmVVamN1ZHNacWRieHZU?=
 =?utf-8?B?cGhjUXl0VnF5YmxaeFRiTExtTkNscS9uL09oYkRVTkJJZWRiV0M4a0lyNTlD?=
 =?utf-8?B?N3NSMStuTmxWc0ZKRXR0OE8reGhpMzEvc2gzZG54elBJWmNCeVVDWmdnbE9G?=
 =?utf-8?B?Tkg3M0lpV0xHZ1BudDJuZVVGdmEzRmpRSjB3bzcyS2EyY2I3eXpRbXBpUXBl?=
 =?utf-8?B?Vzh4QysrMEUxK2tQaXdsQlB5ZVdjSVJkVnRpQitHa2Vjd0k4Tll4SCs0em9s?=
 =?utf-8?B?WENLWmlpeUovSnY2T29qNytvQzF4aWQyRTRzb1ZYQ29kL0hTdXMyZHhERFZQ?=
 =?utf-8?B?bWFDc3pwcVpkWWU4RE9YdWk3QXJQQjlWWW9oaFBQY0xTU0RVQkNvZHBzTURZ?=
 =?utf-8?B?YU1PTTNFVkVjUENueUxBcFpWTXBxdCtER3h3MzdqSFpydHNzaVhtSEFhVkdp?=
 =?utf-8?B?UEI1ODRxdXArQ1dSNW1sdkpHbTJrUUROajh4cG1NREE5VlQ3SkdnN2tvRW84?=
 =?utf-8?B?Rzk3blVSYWNpM1lYMlA3TEM5RGcyTGk2UDV6dzJGd2s3dURmbWwzOFUyQ1dZ?=
 =?utf-8?B?L2NwdkR2MURCWndiRWt6L0FYWG9BR3pVMWpkUkdSQlVqTXNhNFNKYXNSN2dC?=
 =?utf-8?B?eVJ2aXl5Z0w2NVpvcnRzWHNVVmdxaXFVWlh3WG9qWUc1Z2VSOTJZQ3diT1VE?=
 =?utf-8?B?QmV1dyt5UytBSUxHdXlxRWVWamFBcFRIcENLUzBYY1ZzeDdmOXZFNFNBYWpW?=
 =?utf-8?B?WVlIUzN3VmJLc2ErWVNHN1BOR2sxb2tZS1A0MExtMk96UGl1NkkyVEZ2MTJ2?=
 =?utf-8?B?TWFEOFJ0R0VOeGNsR09IeUVVV1BYUnhGQndyVkY1Z090QS80UWxZNEcxYVJV?=
 =?utf-8?B?aTNrQllnOFFockZVTkoxQ1NUcGpQVm9udlhsTUYzRER6TWhZeWxmSm9LejBj?=
 =?utf-8?B?RGcxYnBBd05HYzkxWHFPVjhFc2dSUnIvYi9rVmx6YVAwSTE4Vm5mRitXNUlu?=
 =?utf-8?B?VHZ2d1NEKzVYUHArR09aeHhZT2VFcmpNbmg0RGExRU9vMjVTQ1h1UVV6cVRp?=
 =?utf-8?B?NE0zNjRhZHFKUThCQmJnZjUxR2c3ZUYzQkI3ODQ0eUlNT2dxSmZwYjkyRnpC?=
 =?utf-8?B?Wjk5WlgzV1gxVWd5eWpBRURxVnFHWkdqNzZXLzYvd3ZPRVhtaFhYV0FxWlR6?=
 =?utf-8?B?aGlaQUxaQ25tQ201YWMyMTZLd1Rud2xBUDlOUXZJNW5MaTArV0dJQ2I2OFF5?=
 =?utf-8?B?T2NDSUx2VzMrRUV3cDB6cElyZkRyUE51MEsrY3U5NXRsV2RWeEk2bjR6eE5T?=
 =?utf-8?B?YWxFZldwS1pPY015Yjl2MXVCMEtQcWpIWW1DTVhxNGIzeDBGWG1iWnNnRFZi?=
 =?utf-8?B?VTdldkdQdlVaOEtpb0RqODNZbklYOGUxQy9OalhuNWYzUWVEK2NKcHRrYk9I?=
 =?utf-8?B?RXR5TlN0MThmRkFnNGlCaWF2VkdINFQ4bnk5NHVzZjFVUnhXNDhnN2Q3TmlL?=
 =?utf-8?B?anFoODVDdmpUSk52b1F5amxzT0REUkpDMUx0c2ZjR3JEaU1SWkVDbkplSExG?=
 =?utf-8?B?SWpQTjg3VHpVRGo3aWV3a3Y2VHNvZ3kvU1NEdlowZ1c3eWJHell6V3kzVjE0?=
 =?utf-8?B?UmFXYitsTW1VSzhHdTVjMDBHMW1OWElqZWMvVWxoSUdpSWwwZVk1dkx0THFu?=
 =?utf-8?B?MUtZc3R0SWpOMmRTWWtiUTB1TDl0TTZKNDVHYmFNeXRhVWZFTTJHamg4OVBR?=
 =?utf-8?B?VHkyQTBCcW5lUFlVdWlSRFVpalBJeFdaM3JLenlUQlJxNFJqbmlHTE92d2Nn?=
 =?utf-8?B?YkRkL1ErL1RLajd5MEhkaGxuVGVxdS83OG52ZThKVC9JcTZiOFZJdEU1ZkY0?=
 =?utf-8?B?eDJZUVRFTk5CV1dhVng1aDNGUzRJTEdCOUJobHo2T1BpV0VVbzMzbFR1TXg1?=
 =?utf-8?Q?VM/ImuL3rX3Gycy3TtyP6f85+W7GhU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUNhVVZDSitBUU9FcU5xQkE4TlpOaTgzcTZUTzlQN01yYzF5RVhBYlBXdFU2?=
 =?utf-8?B?M0pjNG41eEFqOHplZGRDT3JnS0s1QU5tWDVLVm9lODhqN0RqYjBuVXovaldP?=
 =?utf-8?B?UFk5RHZuMGE2dDRSY2JKUnFybEl4QmlOZFFNWVZHdHNjWXlJUkZubVJPdnZM?=
 =?utf-8?B?enJpZ2FBNlM5Yk45WGNydDJaUk4yMjhWL2hkSzJEQlh6R29aQldMcEowVWMw?=
 =?utf-8?B?VURka2doQ2E4NzRBRitvTFB0Tks2cG03NExTdHAvMm9tQS9sL0JrRGlQTDVx?=
 =?utf-8?B?MHNNUDlGbzFUMkl4MTJwc3B1ZXJlaERkT2swOTJXbGJ6d1hQVTJKUnBkLzNy?=
 =?utf-8?B?QVFZdjNocG9hOXJtOFpVa21lUllaREdYQTY4QWtCUE9ZbkkzeU9heUtWRWo1?=
 =?utf-8?B?eEhxYWVOVlA4RDR5V0MyMW51OHhNSHlIZ0FjL1dySUQ3VHBHSGFRNDhzYjR0?=
 =?utf-8?B?cGx6Um1KZFFCbGJNKy9ZOXZDdnBEVEpyd3ZNRVEyMlRHMW52dk43YUcvejho?=
 =?utf-8?B?c3FRVDJ2MWZMa0RlTnFad1U4VjRHcTk5YWJGcy9yMXozM0FDL1FQKzMvWGhS?=
 =?utf-8?B?UEZOODFZZk5URmxFanBKRHZ0NVRnN2h3aHVQQkcrRmdvQTVOczRueE5PNlNK?=
 =?utf-8?B?VnlKZEZJaWUyNERvdVdGM0dmbGNHUU5DT3k4TStVN2UySmsyUGFXSlphaWJJ?=
 =?utf-8?B?a0tMOGNoWVdMMlFHbE83MzhDaXNadmlNYjEwNUpjbXhTRzlzTmxUbllrdnA4?=
 =?utf-8?B?Wkh6djJ6eitQdHFLNS8yZzMvV0JpZ2V4RnE2VW9kUlRQcGZiMkRQUFhXaDMw?=
 =?utf-8?B?MUUxSk5Sek9pSVArSkJETW04NWZ2UWRVV0pBVjJneVlPNHBpL2JJMXJBcnFz?=
 =?utf-8?B?cFVxSU4xa0pxV2RvTi90SDQ0NEZxY1I2bkVaY0xxZmxnVjdBeWZHdkZtZ3hQ?=
 =?utf-8?B?ZzFaVzFMU0ZhTUdJMThMQW5vY0UybksxYVRLMndIYjdITWVxRlFXOWdnWmtF?=
 =?utf-8?B?UytZYXRCUS9EcCtkNk5pcElHNmVyRzZyZTNlU2RGL2ltNFJmN3BiaHlUVmxr?=
 =?utf-8?B?Q25hYWY4K1A0bnhIdjJYWWN5SHViYXNBTDFaK243VUtkYmtpK2VERHVTMC80?=
 =?utf-8?B?SGtEUTE4VFBUSkxoT2RuSndueW1FZzhlRmRTNFZhM0E4T1JBSG80WjNkOVhS?=
 =?utf-8?B?NFBkM05ocVZqd2x0alpITytzTEVDWEliNllIWEpmL0liK050UHFHTHB2ZDAy?=
 =?utf-8?B?dmFrdUl0Wm0rWTh0UzNyNFh1TFFTMjZSQmh5RENncG83aUViR0FKWXZwYXlN?=
 =?utf-8?B?aWFjYklMYS9wWUpza2VGOXdqZnZpS010bVdGRVkxK0szMnY4V2tFODVQeDJ2?=
 =?utf-8?B?TUVWaGNjb0pvVVFWMUQ1eXA4TitCdFhJWjRvZlFENm10U2VNVmExYjlwRXU4?=
 =?utf-8?B?VVNLTnRuakpiZlhuRGJ5UEUra0h2V0JjUHVLNU01bVloWnovMExFU3dZTWlB?=
 =?utf-8?B?U2FqVEZQeEJ1VWZFbWZSNHcrRGZ3eVBndG84TUkwUHB2ZnFhUzNuRUZ4NXdH?=
 =?utf-8?B?SXgrcjZmZkdjMStFUUtXY3JjV0tJWTM4RWhwZ1dhU0FRdlgvN2MrdmtZWng1?=
 =?utf-8?B?VHFlcnYwb3pjaEFZTnMxVFRhRVJyOGJLdTJmeUhVYWZnRjNMV3RJNDNFdFBL?=
 =?utf-8?B?ZVF0Tk50RlB2VzU3SENGVTFGS0J3ZllsZUVETWdJbnBQRVVOeHFNb0UxQUFM?=
 =?utf-8?B?VFBjYXVxbURZN0RjMDlYclNmVGJDcHVaMGhqUzdjNFo2TGxFUjI4azNaNktU?=
 =?utf-8?B?bDl4MjBnelRicEkvaEZyM2hvNjNZYUQzMkkyQ1E1RWZFRHh0NUlNN1RjQVA4?=
 =?utf-8?B?cGN4YXpFZmhKdUc4YURkRDZVYkc1dUtGNFg4WFd6RktKRG9oOEZQQjNiSjkv?=
 =?utf-8?B?NDM5dTkraHRBM0dJUGVjRldlcXRMNDVHSHZQemhQcTlGVjlQLzVjOWFKSTJ6?=
 =?utf-8?B?VTkydkhSK0RKYU9FVVA2LzZtZXM5aHU4MTVSWmdyb1k1clBINHhZbkxTRG5y?=
 =?utf-8?B?WGRQcjV3Vk1ucnF0TStGcEtDTWRNZVJVVVUvaVh1Z1hKbW1aOTM3d3lkTkMr?=
 =?utf-8?B?K1FzaDJNSGEwR2VUUUZZNzZpSDZsVDk1cTdiSTREZnhoZVdSK2JLWWY4bjQx?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a7d389-7adc-4504-c652-08de17f37de2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 20:32:49.1331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vn1E68GtjUhx4fKyYarB1frs0z4+DIpVJEV5ykv8Zo3EcF73O/IljUBSas5D+ReeV+quM5Gl0oXPYvy9CkNvrvjK+cGEx0dgeZq6CYVtjFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6960
X-OriginatorOrg: intel.com

In upcoming changes the cached buffers are going to be used to read data
produced by the GuC. Add a counterpart to flush, which synchronizes the
CPU-side of suballocation with the GPU data and propagate the interface
to GuC Buffer Cache.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_guc_buf.c | 13 +++++++++++++
 drivers/gpu/drm/xe/xe_guc_buf.h |  1 +
 drivers/gpu/drm/xe/xe_sa.c      | 21 +++++++++++++++++++++
 drivers/gpu/drm/xe/xe_sa.h      |  1 +
 4 files changed, 36 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_guc_buf.c b/drivers/gpu/drm/xe/xe_guc_buf.c
index 502ca3a4ee606..4d8a4712309f4 100644
--- a/drivers/gpu/drm/xe/xe_guc_buf.c
+++ b/drivers/gpu/drm/xe/xe_guc_buf.c
@@ -115,6 +115,19 @@ void xe_guc_buf_release(const struct xe_guc_buf buf)
 		xe_sa_bo_free(buf.sa, NULL);
 }
 
+/**
+ * xe_guc_buf_sync_read() - Copy the data from the GPU memory to the sub-allocation.
+ * @buf: the &xe_guc_buf to sync
+ *
+ * Return: a CPU pointer of the sub-allocation.
+ */
+void *xe_guc_buf_sync_read(const struct xe_guc_buf buf)
+{
+	xe_sa_bo_sync_read(buf.sa);
+
+	return xe_sa_bo_cpu_addr(buf.sa);
+}
+
 /**
  * xe_guc_buf_flush() - Copy the data from the sub-allocation to the GPU memory.
  * @buf: the &xe_guc_buf to flush
diff --git a/drivers/gpu/drm/xe/xe_guc_buf.h b/drivers/gpu/drm/xe/xe_guc_buf.h
index 0d67604d96bdd..c5e0f1fd24d74 100644
--- a/drivers/gpu/drm/xe/xe_guc_buf.h
+++ b/drivers/gpu/drm/xe/xe_guc_buf.h
@@ -30,6 +30,7 @@ static inline bool xe_guc_buf_is_valid(const struct xe_guc_buf buf)
 }
 
 void *xe_guc_buf_cpu_ptr(const struct xe_guc_buf buf);
+void *xe_guc_buf_sync_read(const struct xe_guc_buf buf);
 u64 xe_guc_buf_flush(const struct xe_guc_buf buf);
 u64 xe_guc_buf_gpu_addr(const struct xe_guc_buf buf);
 u64 xe_guc_cache_gpu_addr_from_ptr(struct xe_guc_buf_cache *cache, const void *ptr, u32 size);
diff --git a/drivers/gpu/drm/xe/xe_sa.c b/drivers/gpu/drm/xe/xe_sa.c
index fedd017d6dd36..63a5263dcf1b1 100644
--- a/drivers/gpu/drm/xe/xe_sa.c
+++ b/drivers/gpu/drm/xe/xe_sa.c
@@ -110,6 +110,10 @@ struct drm_suballoc *__xe_sa_bo_new(struct xe_sa_manager *sa_manager, u32 size,
 	return drm_suballoc_new(&sa_manager->base, size, gfp, true, 0);
 }
 
+/**
+ * xe_sa_bo_flush_write() - Copy the data from the sub-allocation to the GPU memory.
+ * @sa_bo: the &drm_suballoc to flush
+ */
 void xe_sa_bo_flush_write(struct drm_suballoc *sa_bo)
 {
 	struct xe_sa_manager *sa_manager = to_xe_sa_manager(sa_bo->manager);
@@ -123,6 +127,23 @@ void xe_sa_bo_flush_write(struct drm_suballoc *sa_bo)
 			 drm_suballoc_size(sa_bo));
 }
 
+/**
+ * xe_sa_bo_sync_read() - Copy the data from GPU memory to the sub-allocation.
+ * @sa_bo: the &drm_suballoc to sync
+ */
+void xe_sa_bo_sync_read(struct drm_suballoc *sa_bo)
+{
+	struct xe_sa_manager *sa_manager = to_xe_sa_manager(sa_bo->manager);
+	struct xe_device *xe = tile_to_xe(sa_manager->bo->tile);
+
+	if (!sa_manager->bo->vmap.is_iomem)
+		return;
+
+	xe_map_memcpy_from(xe, xe_sa_bo_cpu_addr(sa_bo), &sa_manager->bo->vmap,
+			   drm_suballoc_soffset(sa_bo),
+			   drm_suballoc_size(sa_bo));
+}
+
 void xe_sa_bo_free(struct drm_suballoc *sa_bo,
 		   struct dma_fence *fence)
 {
diff --git a/drivers/gpu/drm/xe/xe_sa.h b/drivers/gpu/drm/xe/xe_sa.h
index 99dbf0eea5402..1be7443508361 100644
--- a/drivers/gpu/drm/xe/xe_sa.h
+++ b/drivers/gpu/drm/xe/xe_sa.h
@@ -37,6 +37,7 @@ static inline struct drm_suballoc *xe_sa_bo_new(struct xe_sa_manager *sa_manager
 }
 
 void xe_sa_bo_flush_write(struct drm_suballoc *sa_bo);
+void xe_sa_bo_sync_read(struct drm_suballoc *sa_bo);
 void xe_sa_bo_free(struct drm_suballoc *sa_bo, struct dma_fence *fence);
 
 static inline struct xe_sa_manager *
-- 
2.50.1


