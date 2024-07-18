Return-Path: <kvm+bounces-21853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09833935039
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 17:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 65B9CB222E9
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 15:56:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87C6F144D16;
	Thu, 18 Jul 2024 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kFTWV+2R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E2B4D8B7;
	Thu, 18 Jul 2024 15:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721318152; cv=fail; b=qKDUU72bC8xnr3qyr5u9pvkpFMmwYkejYosjK54ssnhXjkidSjAiysVgNMh2AzrUIzAQv4Ji0hIgOHCvPMrpYZ8INz6Fr6kHYJUQ1rpZshliISOu7IqMJLnHQsd1d2e5mozSu/3q7MqhExQDoWM2BV7wTSDa4sE+U4/KXgQ/8vc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721318152; c=relaxed/simple;
	bh=bw8bExEf/+xPQD9dNl7EftUk9LlOHxW+CtBSwVme/tM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lKdCYTbvUF9fUi7J4h3Wv4W1K2iusHkXI7HfiYjuU0cQS5jP1JfOLt2jXZQ/xTNs+fkwTZZW3JfT4J6gaHrBOciCXCWMfAYYvMP3LwIH5po5ZOoBxch5x4g3wx/yp7lF3pYpX2+zuEEpW7bNpt11zovylbAiKOBQ9V4j1Q5zp6M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kFTWV+2R; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721318151; x=1752854151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bw8bExEf/+xPQD9dNl7EftUk9LlOHxW+CtBSwVme/tM=;
  b=kFTWV+2RriBhFi0C9HdrC0bJnjTQ94RcuZy/W3kevMcVGq8kzcm2MyYD
   QsBFk2+8JnDKIqvPb8JGNc9lxLtTlptXQnmFT3EhrjQQu/AcReKL/34fd
   TW+FTRIm2CV5rSXhHIIf/7g36dFVUGUNiV0TGnlJqVXm4enhVVXTC+KJk
   hd2e4/fCKFD1CDbvWMeqC4pGKk6W/Z+fKpUu9tWFpJ8dk3carH0rpJNwJ
   UEbxUf+yq/+Yzj5sZ6diAfTia6xe6MVK27h1s+TBnt6Hj2QzelG6LxAWs
   Lh2QUEOk/4Pm9B9SSVejiyCgF/+i0D/Zr7no1Xc0d0dIAgVQsugiJWS4H
   g==;
X-CSE-ConnectionGUID: yUw5CEXSR9Sa5v7ZcyYBGA==
X-CSE-MsgGUID: MbknHearR6OwU0EgWEleIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22700461"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22700461"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 08:55:50 -0700
X-CSE-ConnectionGUID: TB73EQOUSjOA/vDRXB2Vhg==
X-CSE-MsgGUID: d29g1M6UTt2LT2jyOmNanA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="74039307"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Jul 2024 08:55:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 18 Jul 2024 08:55:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 18 Jul 2024 08:55:48 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 18 Jul 2024 08:55:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mRkXmvMkKEnov9ADXoEuXxcoOmNyrJyR1H02uB+8KGSHMmWBmQGi6ijQWwqg8JEhngqa/u9y1v2pbpEHYlCWRCgGrGxHHq32krXd8TcDkc/FZ+SLwwtG6F8FPL5N2wN0lIh7SmRGT2q8y8mlt1dCTSLmhfz9n6qO1HUya683+p3w1heeK0VndJe+UAIJyr4Bz5d5/EUK6sPyyCf3xhvRKOW0/h1XQtCoSDRPhfhKUkVQ1Nhn6QnkAaVj1ysr/nEEZx2AafvcFrt8YZ+HCSSBbFIDLmeGjRfFavzfr+bzBAybF3TT+7slbKbW4L4ifWKAxOFzworiYVTPwb35sw0qNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bw8bExEf/+xPQD9dNl7EftUk9LlOHxW+CtBSwVme/tM=;
 b=GlJ9UaZmjk+XTFPMwM/E47Y54UEBWsOrAvZvH2YoLtsZWKXYlq1nRDVtIOE31fHLto0Vn0MVAcAm1DFOSqDrhCm/VzTqTJfLzsvDHYxPEmILe3EUql0tevm7HVF6gxvcnPfq16w4WpY40fWKU9RyseSxmT7vzpcJBBpBqm/6m7DQObpWg3X+7pCzYbpD2Mnzxm+Q5mM3RHXHtVZmo/T9/jPX0wG/PSjIU497YUPi/UgKfgcKv66RLzjBf5AxLq/b88aqT5tv77De/7ENy6GJo/an0Oe/6woS7VW9F0KSs8Vlh2sAAW1WqYposAuNwTJw+pN/wpsKcT3jE3t57VK5uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB7153.namprd11.prod.outlook.com (2603:10b6:a03:48d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Thu, 18 Jul
 2024 15:55:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7784.016; Thu, 18 Jul 2024
 15:55:33 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Topic: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Thread-Index: AQHawpkmqvK9+rV8gk+Fb4hYJXFjCLHRzw4AgADIg4CAKjF9gIAAB5eA
Date: Thu, 18 Jul 2024 15:55:33 +0000
Message-ID: <a727eb488b69c9674e8ecc2d099aec00af58fa7c.camel@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
	 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
	 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
	 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
	 <20240718152823.GG1900928@ls.amr.corp.intel.com>
In-Reply-To: <20240718152823.GG1900928@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB7153:EE_
x-ms-office365-filtering-correlation-id: bb24c677-9f9e-4cf5-7584-08dca7420edf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y2tGL0ZYcW44eGZWRVZQYnRibzZUeG5iVDFtV1FKNjhUbmtkSk55UE5yMlIw?=
 =?utf-8?B?RWxHV1dMNmRZNmZaakh5bWE1bDNCR3h0dkROZENHVitYR283TjlJM3RQcmRz?=
 =?utf-8?B?Zkl5ZWovRms2MmJYQkI0YWk4YTNkZmJwbnA5VVNhcE1IR0thc0JzQ1NDWSs4?=
 =?utf-8?B?UnVEZy9lQmVwRHhqR3o2SGpKVmF1WENnWS9tMmRpRjRwai91bUlGa3FoTUw1?=
 =?utf-8?B?R0tLY3hoQXBoV2VyNFpGZjIxT0tkSWJuKzlGVHBJMktYNS9pKzU4dGhqRUYy?=
 =?utf-8?B?cjlRNmh1L2VBNDZPLzBnM3cvY0d0TkdIbDZsZllHUEMyTUg3Mmc2akhlUnp3?=
 =?utf-8?B?ZHN6azNlb1B4U21HK2hDL0FlenBlLzhOdXNFRzBNd2YxcHBBVElzRGFnSkt5?=
 =?utf-8?B?VTB5ZFJHT0xiYUVHbWpiZFNYLytmUWFvK2VDZjdWZ3NqYWZ4U3YyeWZLazVy?=
 =?utf-8?B?dmp5N1NsNGFNWEhBMWJNZUkwaGhOdkI2Y0I4aXJxLzVsWUppVTJ6YXgzR0hU?=
 =?utf-8?B?eGRoM1Yvam9tZ29tMGdlb29pRnNQTXBocXBOQjBRMGh0Sm1wN1VwUE5PYzF2?=
 =?utf-8?B?TVhRdG83Q290bXlJZHdCazQ5KzNZRnJVcUR0c21DOFFMRFdXblM0MFdGUnJy?=
 =?utf-8?B?RXg4MisvT2ZUczE5TlpEK3lOVnBMSy9sM0NWOEZ5cGprWnkrMjZSbGY2eWRL?=
 =?utf-8?B?T3NteVhMbitkRENCcFY3M041ZmZvWVdYQkozZ3dSeEdXMHdyUWFKa3BlYkEx?=
 =?utf-8?B?Sjhvbk1NNUdTRnVQTmgvSlhpT1QzYUxaRURJakMxb3pvMkxOeDNiMGZlMGhW?=
 =?utf-8?B?d1FOaUNhdnhuNXdBVTRHU2sxRWVrb01GMTI3dVdOWXovMXV0Zlg3eWsxb3hD?=
 =?utf-8?B?RWdHL2FRWkhST243WGUvRGtUZjd3a2h5Tlh2R1lSR0gxdUk0TmYrUUs3N1ZW?=
 =?utf-8?B?Vmd0cS9MYkI0ZEN6b0JLRlkxWGJ5UG9Ta1c2V2NzeXJYSm9ETENuSzZNZ0dw?=
 =?utf-8?B?QzJyMERHMWYwby9lSjlGdHlxbklWeFNhWTQyMlBNVk82ZXVNWEp1TDhjSit5?=
 =?utf-8?B?SGJna2JrZU1JMTBhaFFiQXZJcm5tdkRQU1ZORFp4eHgzU2dmbW9wK3JhRlBy?=
 =?utf-8?B?Q1dQb1FldTQrYTNXTnZqeVk1aUw3QmdSWkh1TzRGTnM2K1lFZEpmdUxyZE9G?=
 =?utf-8?B?N0VUZ0JmNitESDVWRjI1aXl2Njcrc0YyQkNQRENsM014ZGpFbUZZY0QwdktO?=
 =?utf-8?B?V1pnQlFjWXpyWVNYb2NKWWtqMEdyVWR3WHhQWDI4TWFidFVpelJpM3VxQkpI?=
 =?utf-8?B?c3RXeEhYMFZSenE5b3lSQUl3VTdsbnMvUzJMOEhhazJDNU1YVVU3ZXZGeWVL?=
 =?utf-8?B?TkNhSFdwVHJtcWdaOTdpQ3ZxaWZWK0hrUmVGSUlvdm9SYjluM3kzdk1lWUVV?=
 =?utf-8?B?bkxlWEQ1ZGdyOG1td3BJLzZ1cHhvNDhpWU8ybTVYZG5RYzNDb2JJYUV1YnBz?=
 =?utf-8?B?cVlhNkIzNVFmcmlRNFcxQzZ4YUluYW5BS0NEaStkTjJ1MXd0SDNHWEFXL2RJ?=
 =?utf-8?B?ME83Q3FtTVMxU0dla2ozNWFvb21RUmpkVlZlZm81NS9xQW02QmxlMFV6QVhE?=
 =?utf-8?B?dG95UlJuTGJQZ3lwVWdza3hRV3p1cS9PVlF6WmN0ZU54L3RicVNuOUZMQ2tk?=
 =?utf-8?B?ZFN4cWFVaDZlL0JZSEo5c3NTb0h1V085LzNQODM0REdQaUJJK1lwZlovYzND?=
 =?utf-8?B?RVZnYjdwakkxRGxxOVBxeEUzTk55NWlXWlpVVFdjNC9ST1VTVjE1ZG1SVUpl?=
 =?utf-8?B?dTJOV3VsSkcvaXd3YTI0TG51N0FhcmsvVDdSbWRacEh4dkxEME15SUJTTkI4?=
 =?utf-8?B?THZmRGNqTjdGYnVhTjRuQVg2ZmEyd0htSjJDc0hWUEhQN2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djN4NEhGR1QvRjl5LzJseHFSeGZKc29FbGdjdWhWYlY5U3c3dWR0MklBSGJr?=
 =?utf-8?B?WFVCM2pmdVlOTVA4L3FzUXFIcFZxcmQrZzJFVks4QVpGY2k5S1AzRlpoSURn?=
 =?utf-8?B?UzdSaUJFRE9KSDVSMXMyZzNKMDlBZVByZDBWRmpLQUtoOENUQkYwUkNUOTFK?=
 =?utf-8?B?azJkL1hNUzMzVHlOSzlXVzJzYVhDVGt0RWZ1M1lXZWZFaFdnYXlUZ0R1MUhF?=
 =?utf-8?B?N1Zvd2V1OHZKS0Nsb3lWcGJScWRqeCsvMjFnK013RlZSK0dRYUp4NGZXcWUz?=
 =?utf-8?B?WWM3dEJFanZHRVdTcjZ4eTBYam5JU1ZpWUN6OUhqdWF5emhORVZyOUsya2dL?=
 =?utf-8?B?WC9JaFd0ZFJFY0JQc0p5eXZ4UE5SdmZMa2RJRmV0ZjNjL3RiVXQvQklsTGpj?=
 =?utf-8?B?RGVxYnloQ1VjUmJ2dTN4THBPNHlBR3dBTFp0bHI0QjZpR2FZYit5aTRIcTE3?=
 =?utf-8?B?VWtMWWpmcEErVXpldkkrSzdtbmlmaXMrTExmYkxYaEY5UURMVXBiRmF3dnVs?=
 =?utf-8?B?eTdIT3l2OGo1cEhLU3hPV2k1eWE0QVo0dXJpUlRvTUhxbHhtUm5rV2IvZ3hy?=
 =?utf-8?B?NGNZdzFmMG5GVmhiKzlXZk1VL0FTVDRIeWVoNk9yQVphcXV6WWY0cGdIYVhH?=
 =?utf-8?B?cmZhS3Exa1FLRnJRTGp0bGZQTmtjZktvdjlpa0wvRWV2SUQzd01Fdnp2ZHND?=
 =?utf-8?B?OXZza2J6NzkwZ2NxK1NweXUzdVd6MUl3K3ZzOUZESWlCM1Z5dVgvckhwd2Rm?=
 =?utf-8?B?SzRwNVQrcUNTZmxlMCtYdm1zVnEvV3ZDQ3hCaHRxT0lpRlMwZU43VVpjc25K?=
 =?utf-8?B?RTQ4R0U1bmdxVGxMVURSMkt1VEZ0b3I5OGJzQTdyWmx2OFFCbE1lQTZ2NWg3?=
 =?utf-8?B?REhCM2Q2ajVENFNFbElwaGMvQWxmY0NNOTJmenNjU0NlbkZSMEVtc3dXVm9H?=
 =?utf-8?B?ZFlhbEVzS0xKNHF2dWRnMEJOT1E0bnI5L3ZYa1VhZmR6U2lINzZWM1FCT0Vk?=
 =?utf-8?B?V0tOaGs4M3RCdi8xYm1VblVHTUMrRlE1VzdNMGQ2NjNPTWExWHp6UXgvTEgv?=
 =?utf-8?B?OXZ4OXI3b3BQYmg5eUQzemwvYnhzeDZwY3QyTXVjSWtkdHBSRW8rL3FWbTQ4?=
 =?utf-8?B?UjFZUFVoTEFpQU1pYWwyMmZtaks1Yi8rREdlb2NuSVdSMjZzb2xMNlBHay95?=
 =?utf-8?B?OWtnUm1FS0VjWkRmS2JxL2ZocHdjSE1GTzl6WGtzSEVTMHYwWlZZU1IrRytC?=
 =?utf-8?B?dENXa2xtdUVqNGEwUWlWYXBGSVpUT3dNenhibmhMa1cvR1JLU08za1ozRFhw?=
 =?utf-8?B?S1Nmc0JsUytPSCtpdVZTWGZReWF5SDl0WTM2SkZqZjVRMkdjSFpuN0dNV1VU?=
 =?utf-8?B?K0FyTTEzUTdpVW0wRHUyZjBGZXpxcHZwcEdrMHdxQXZ3SEFZUFFkVWF2dEta?=
 =?utf-8?B?bDI2RUs4UzRNT1U1RkFqN01RQXRJZmNEclNTMVV5bmNtazNCN1JJa1dkUUZo?=
 =?utf-8?B?VEw4NWFaMXFTNTBLRXlvY28xaGJPdHZIRWptV1o0NStORE1DWmtCU2w5S3pB?=
 =?utf-8?B?aDNJTGkwemN4WWoya21CdE1iMFBid1U0QlVzWVR2R0lqMmdTRjl5R0JCSmJH?=
 =?utf-8?B?ejhwSkxvckdWT1BTTEZSM1lwSEtLaURjZzNUWGp3WStEdktJcEwvUEt1Qll1?=
 =?utf-8?B?VG1JWlVSb3diRWxuOU1wN203OVpRbHBPdTNUY1E4NEpiMGw3ZHI2enZZZTdY?=
 =?utf-8?B?WVlwY2creE1uSXFRRFRnd25aOFpiWlgyMWRPT0o0ZmkzWlRVWGdZRnZianp5?=
 =?utf-8?B?WDRDbnNuWnRObFczbUpmZFpjaGtjSnVrbmFjUGdzUnBNWjlZYVpkNDl0N29Y?=
 =?utf-8?B?U1I4aWZET04rbi9JNnlXSWE4YmRCQjZ1UFRadjBQcnlmdkk1aUhmTjlaci9a?=
 =?utf-8?B?ZmliNlU1VHN3MER2clFFQVNLb3FnSjNERnNFQ2N5eDZCU3NYQ1pzM3E0LzR1?=
 =?utf-8?B?OG1UYlJMV0VZVS9NKy8xVFpuTDVxL21PWUhTbk1Db29mWXpCM0NkMFo3a1pS?=
 =?utf-8?B?M1BSV2o0WE5yOWdoZGtHSkZ0L2FLR3pEU1BWQ1ptbnJiaFdFRWRqaFBDMFA0?=
 =?utf-8?B?cEpzRmJ5RytDWlorUUx1WWhZd1FlTkE5cGYyUTlaUXNEcUhpWEtvdHJWM3hX?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0788CD613ABA8C40BFB38044A0A95409@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb24c677-9f9e-4cf5-7584-08dca7420edf
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jul 2024 15:55:33.8599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpINaqq/CDDDvGVwcsE77GwR8KrYZJMSpTpRR15rorqiVy2b6SsnEzz75AGUqgmhjkm7pCxGCcwe74X4Ac7zbvAMsfRyTMj0CMKyPUOH3Lc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7153
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA3LTE4IGF0IDA4OjI4IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gQWx0aG91Z2ggaXQncyBhIGJpdCBsYXRlLCBpdCdzIGZvciByZWNvcmQuDQo+IA0KPiBJdCdz
IHRvIG9wdGltaXplIHRoZSBkZXN0cnVjdGlvbiBTZWN1cmUtRVBULsKgIEZyZWUgSEtJRCBlYXJs
eSBhbmQgZGVzdHJ1Y3QNCj4gU2VjdXJlLUVQVCBieSBUREguUEhZTUVNLlBBR0UuUkVDTEFJTSgp
LsKgIFFFTVUgZG9lc24ndCBjbG9zZSBhbnkgS1ZNIGZpbGUNCj4gZGVzY3JpcHRvcnMgb24gZXhp
dC4gKGdtZW0gZmQgcmVmZXJlbmNlcyBLVk0gVk0gZmQuIHNvIHZtIGRlc3RydWN0aW9uIGhhcHBl
bnMNCj4gYWZ0ZXIgYWxsIGdtZW0gZmRzIGFyZSBjbG9zZWQuwqAgQ2xvc2luZyBnbWVtIGZkIGNh
dXNlcyBzZWN1cmUtRVBUIHphcHBpbmcNCj4gYmVmdXJlDQo+IHJlbGVhc2luZyBIS0lELikNCj4g
DQo+IEJlY2F1c2Ugd2UncmUgaWdub3Jpbmcgc3VjaCBvcHRpbWl6YXRpb24gZm9yIG5vdywgd2Ug
Y2FuIHNpbXBseSBkZWZlcg0KPiByZWxlYXNpbmcNCj4gSEtJRCBmb2xsb3dpbmcgU2VhbnMncyBj
YWxsLg0KDQpUaGFua3MgZm9yIHRoZSBiYWNrZ3JvdW5kLg0KDQo+IA0KPiANCj4gPiBCdXQgc3Rh
dGljX2NhbGxfY29uZChrdm1feDg2X3ZtX2Rlc3Ryb3kpIGhhcHBlbnMgYmVmb3JlIGt2bV9kZXN0
cm95X3ZjcHVzLA0KPiA+IHNvIHdlDQo+ID4gY291bGQgbWF5YmUgYWN0dWFsbHkganVzdCBkbyB0
aGUgdGR4X21tdV9yZWxlYXNlX2hraWQoKSBwYXJ0IHRoZXJlLiBUaGVuDQo+ID4gZHJvcA0KPiA+
IHRoZSBmbHVzaF9zaGFkb3dfYWxsX3ByaXZhdGUgeDg2IG9wLiBTZWUgdGhlIChub3QgdGhvcm91
Z2hseSBjaGVja2VkKSBkaWZmDQo+ID4gYXQNCj4gPiB0aGUgYm90dG9tIG9mIHRoaXMgbWFpbC4N
Cj4gDQo+IFllcCwgd2UgY2FuIHJlbGVhc2UgSEtJRCBhdCB2bSBkZXN0cnVjdGlvbiB3aXRoIHBv
dGVudGlhbCB0b28gc2xvdyB6YXBwaW5nIG9mDQo+IFNlY3VyZS1FUFQuwqAgVGhlIGZvbGxvd2lu
ZyBjaGFuZ2UgYmFzaWNhbGx5IGxvb2tzIGdvb2QgdG8gbWUuDQo+IChUaGUgY2FsbGJhY2sgZm9y
IFNlY3VyZS1FUFQgY2FuIGJlIHNpbXBsaWZpZWQuKQ0KDQo=

