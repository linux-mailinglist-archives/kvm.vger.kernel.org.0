Return-Path: <kvm+bounces-43605-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBC2A930FD
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 05:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75D994A04C7
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 03:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AD42253955;
	Fri, 18 Apr 2025 03:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P1plOb2b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6010F9EC
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 03:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744948210; cv=fail; b=NvFcTtTWv4qXdO7HerQDLiHbTCkknEyX36vLy0VUkUzlg7+6q3ZtRnR0DAeUai4MqT74ThLWoVc9a5oXm9eDSkeF+p44qqRH1EprVnCVvPeDeEKRWvyFTYFa1MkJo+Lb2MNU8l5LBO4Xcw4YxmsMRqEKdgcW3MoswE1u7OXBu/g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744948210; c=relaxed/simple;
	bh=UQ33f/khKI5OpDjCfuzYVQzvb93utOIl1UmeSVM8EfQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=o/lwUfAwQsJZEYRai6LKbgPa/FbKelPvUQnNpezMKp+lrKVwn8gbMXm9eI4OmqdwdpHEDeTwLXIiOqNnBjyJDgcwOL9jAgHAhYhdQ5TomepjQaGxh+CWz/bJkpd96mstbXVfLaK0ERRNH6phB2ECBVE/h9FslI7vVQ9q94wAtek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P1plOb2b; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744948207; x=1776484207;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UQ33f/khKI5OpDjCfuzYVQzvb93utOIl1UmeSVM8EfQ=;
  b=P1plOb2bUHZQCFq+Inpk6uiQsWBnJJGt5HvJ+0jjLIqaA+knKTOWw3Zx
   fZPHsAOq+WGP5MXVLNTvvBbRsJUxnr8UHr2R4qKb59luizv1jax/bdAqV
   WSwkHhc4E/sEMtitbikkIrUkFA6rTHGMDK1jjWCvN1WcpQc/AdtTEGd9r
   /GDL9YViKJBox3wJuKGRxiCcGvZl4O24WPufOe0wk6lcN9LTjWT94PG0h
   U9BFXCQu4ZZ2/K5Xf6i7eG8AOcg42Fa0aFsXRfepP/TnM2cDanSMMZEeB
   Ylr0F/Zwk9Par+b18c2cVeMtjub+aDq8M7ZTN8pcyygMWjM1TW/F8skdw
   Q==;
X-CSE-ConnectionGUID: Q8DDiECNTI6qSsU83hJing==
X-CSE-MsgGUID: TvvBKgVpSPK4tRIcJrwbbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11406"; a="71963008"
X-IronPort-AV: E=Sophos;i="6.15,221,1739865600"; 
   d="scan'208";a="71963008"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 20:50:05 -0700
X-CSE-ConnectionGUID: s+iBjtXSS2qDPKuz+1W91A==
X-CSE-MsgGUID: uus1WTEtQY6YeTHrLiPS3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,221,1739865600"; 
   d="scan'208";a="135830669"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2025 20:50:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 17 Apr 2025 20:50:04 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 17 Apr 2025 20:50:04 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 17 Apr 2025 20:50:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GkzyzhSc9+box4yvuEz9ESY/zr4pJ2we9m8c2xRKQWC3lA7VqmGnDzGuZZLfNjmF7t7xnX3oh0lJZD7N54grsYcyXtzFI7nxHxGSUPqktDtz7mZgOTb5hFYYIjQE/YpH4NIvX7VyPKBJb6pDg5FrTyFi3g9Gq6CphOPzf7nMRssXtv4tUpiCBCvqKHiOqM0oa6Vj6HJd/LmkkjagaOB54o+tK7j7EzhB5b/DOGeLCE5zsIQRU4AnSgyXzL4s6l8551ynzwuccZOY67DjwbAj94iSrgImoR9g3JotZ0tnUgzoW40qDJHPzw6x5FRF5L6tiCZY3sIP7jSoLZgfQ7dA0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uaZgZV/OVgnFfr0BX8AsWNARpZtYpxWpudUNBszit0=;
 b=vzId0YQPJpWmEfAvXUlK+0lwS8VKF2EFEpsBL18y2ytkMkJ1fNsgr0dx1YjHagJJnKNEqm4bjyp9eIJq+1zOUy5QsTOxB7/1a7Rz5pW4J+kseiBqdCwfoqtstGZLT0NnXL6vraDcJIzqJzFt594/52DCUtnJuKmhgd2XhRXW14w5v/Dt5Z6j10ER6FLclavSscGSY8SaHyEnygj9Q0L3jvJoG83tRSH3LAFCCE8Yyj3rrmjkSkpQ6vBd58ZeFuQMvqBUmm5t11gR4klyDsTvyl6gSmOfKwzUz0cIACQfR3vQRodlfqYKd3g/LQlogsBPOVz1oo3eqo+u3TLYz9+Zpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DM3PPF31D2DA56C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Fri, 18 Apr
 2025 03:50:01 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 03:50:00 +0000
Message-ID: <84a35f4e-69d3-40c2-b92e-5c9f0b78ad74@intel.com>
Date: Fri, 18 Apr 2025 11:49:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/13] memory: Introduce generic state change parent
 class for RamDiscardManager
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250407074939.18657-1-chenyi.qiang@intel.com>
 <20250407074939.18657-5-chenyi.qiang@intel.com>
 <402e0db2-b1af-4629-a651-79d71feffeec@amd.com>
 <04e6ce1f-1159-4bf3-b078-fd338a669647@intel.com>
 <25f8159e-638d-446f-8f87-a14647b3eb7b@amd.com>
 <cfffa220-60f8-424c-ab67-e112953109c6@intel.com>
 <fd658f30-bd28-4155-8889-deda782c56eb@intel.com>
 <43b949b1-bc8b-4b7d-ab3b-206cb88d4756@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <43b949b1-bc8b-4b7d-ab3b-206cb88d4756@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:820:d::13) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DM3PPF31D2DA56C:EE_
X-MS-Office365-Filtering-Correlation-Id: 48066928-d7fc-4e1e-f274-08dd7e2c180e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SzlaUkdLODhKRGFOUGRTMGtnZ1dvQkZFNnYwRm1tTTJxcFdxdlF5TjBZa0VR?=
 =?utf-8?B?SG1ZZ2o3ZkJ5L2JCK3BpMVo3T0FUV0xkTGYyRnFSZ3ozL3o2ZHM4WE5IK2NQ?=
 =?utf-8?B?Z1l1Z1ZtT1QyYjBkY2cyaU1XWG5HQWh5dllPMFZkYm82eFFrdW9oTnoweTRi?=
 =?utf-8?B?T29YVW1qNUlBRjk0eTl2RGYwd3Z5TGw2WjZEYThlT1l3bnBaKy9HQi9ETjBo?=
 =?utf-8?B?ZGNLbXVSenhCdVBJR1Z5YUN4ekIyZzlpRlV3THR2MHVZbFVKSS83bEFZK2Uz?=
 =?utf-8?B?UUNHSXpSeUl3ZEc0Uk9sTUE1cVJ2ZGZwRG1KTTYxSzFKNU1ycEc0K3FwdGpP?=
 =?utf-8?B?Z1htV1FqVUJkQzZMY0NWMG5MeldtbnYra2cvWjRZek13Rko3Q0hDTUVjMFI4?=
 =?utf-8?B?QmJvdUdUdnE4VzFSNWEzOC9hYmdXVTUrenY5NWpXQWs3Qlc1LzZPMmE0N0JH?=
 =?utf-8?B?LzFJUWMvTGt4OE1jYWxrTFdpUWVVc3U0ZW9SYTJwS1ZQeC8vS09ZQ2tIai8r?=
 =?utf-8?B?c2Njd3NFMGhKckRycERhQ1lxMS9KVHBKTGVISFZoYkw4SnQ1MHFDN3pUSmFY?=
 =?utf-8?B?blVFNlZTRjR5c2QxTE9pOWxndjZUZGlBTjVrVENpd3lIaDZSWURZcUNndnlz?=
 =?utf-8?B?TGhpN2syZ2RRRTBNNmtWNWh0cEo3UGFOUHpxWmk3Q0hHdGI3cWpuTUZoYXBz?=
 =?utf-8?B?aDhWWVl6akcyYUJHeGRsdnJZNFVrcGpCTTFnbEZId3MwcytOYklIM09kWnZx?=
 =?utf-8?B?TmZYdWtMUENwRThQRDlDNkFrbjN2dExKTzdQSkVaeFlHV0ovbXJlZ2UxcjZV?=
 =?utf-8?B?N3Zwc0dxdG5qM0ZIY0lXY0kvelo1YWtJRGNDV1FNYXRyTGVPZWwzL1JxNTN1?=
 =?utf-8?B?WnBIczZRSGtjRzdGdUZnUS8rVEdnWTJnelNOVTNUenBRT0ZrY2xlaW5HTHZs?=
 =?utf-8?B?SkF6RFpaWXBvNm9qdEUwb2ltS3pPZHpGeFRZK0dlUDduemNlUk9PdUFNUGR0?=
 =?utf-8?B?S01uYzh6ZUZMd240bzIwTzM0Slh3Rlp4M2lQU2M5UFhoNlp6T084cnEyM3Qr?=
 =?utf-8?B?VUwvRnRNdlNGdERjdWh5VUg3TEZqT0o0c2VHRzdhL0dQa1NVVldkWmJTcVlw?=
 =?utf-8?B?QnNnTWJBcUhjRFZjR3AxaHRIUUlMTkpoQWs0OHRxUVJEM0pxS09SMDZtWUlI?=
 =?utf-8?B?M0g2Y3FYU01VSlZ2QzV5bTFWSXBaQ2dFK0NnSG0rVXpkWlRoaFhoSFZXaUJl?=
 =?utf-8?B?Qmd6MFlzYldkMXZ0U3R6L2JuVmFaTEs4V3NhVnBNclhnMUgwZCtueHZxWEJa?=
 =?utf-8?B?TWRHSDZFdWJPVTBLalhuWEtxQXh3TTM1R0wva1BHeEJ5aE5JUk4xV0JSQVVi?=
 =?utf-8?B?Rm9rL0NZSkd2bnAzejZFTkwrWGE4SzdmS2NTSUg5dmZEb0J4eWNKS0VVS0xT?=
 =?utf-8?B?aTRvUm4weDRrV2o0ckprN0JJKzRyVHJrWXBoTWllaHZDY1Y1U3FWS09lM2lw?=
 =?utf-8?B?L25wWi95THlTYkpmWW9wbmpFSExIQndXQ3RUcmZFeE90aWloRFo1NG9RSlVs?=
 =?utf-8?B?dHBLQVNQdlJGaGI0WmJ3YkZNS0xDaU5RdGlWUnhqaWZmaElqYitMT0YxY3Bu?=
 =?utf-8?B?ZGZOYnJQVkU3K3lkN3RNZjIvemRjaFM2b25pR3owbTkwa2ROOTZFQlkxRjhV?=
 =?utf-8?B?TUlqWFZMVG9ZN2JVRGtRdCt3R3Z0TFdSSUZHQVAybi9EV014VzYrUER1QjNM?=
 =?utf-8?B?bHVxd28wZnpVNHF0SDNra2g0SmtJSWw3akhERVVBM1VIaG9iaXZuSUhLQVFB?=
 =?utf-8?B?LzRFYkZsM0tQVVdCTFREZ3BxbTM0azN1eVFUZzdYcDJuS1JIN0p0dkpNcldl?=
 =?utf-8?B?WDQweUJ2Tjd0bDNoUzBwWmgvUGtBMTRMTEZiSFk2a3hKcGpCTVlWZGVFK203?=
 =?utf-8?Q?jU4H02i6moU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnB6MjdTaDI2OGRUVTFKekxlTXlpQjA1ODFhaFE1d1J3Yjl1OXJMbUZMZ1Nv?=
 =?utf-8?B?Mlk2ZGVwNTVmM3ZuQUF2UmJIK3JYREhDZ0lxckppSmFUUThuWUl6YlVVbnlx?=
 =?utf-8?B?V0o4YjdlQVZ0ZHU5REJIMnVCSXpLZ3N5NGdXbVRYdUZLWVhQU2IwVlhNUFJt?=
 =?utf-8?B?N3F2WG1kbW5Lalc4YitaUTJiSGg0YWlHZWV4eFBDbTdlN0YrRzIzeXBuNE16?=
 =?utf-8?B?SFI4ZGVRTUE1UWlGbW5XbSs4Tm1MOWtPODNDamlSQ3AyYjI5RTNXbk54MUFm?=
 =?utf-8?B?MnZXQWw3L0lobERySjlTTXZKeEhxR1YzL3FBdEl3Y1BlSlV2ZU02ZkVBWXJ0?=
 =?utf-8?B?d2wxTC8xWTVJU0lmWTdXaE5rbmxpaEF5eUZ2RUhjOUVvN00xZGtFaWxQTkRV?=
 =?utf-8?B?MG1UVG9PczlrTnNtcXVobmlxN2RBWWhXSi9GMFNlVTh4aGVwR2VNSTBJZW9u?=
 =?utf-8?B?ZE5XMk55OEFIajR1MDZJUVhMZGJxR2E4Yy9PNjZpSktRc2pNTEpvMC83aC9U?=
 =?utf-8?B?cE5GOVNJKzh5OGFnTksvN0JDMkZ4ZDZFeFNzck4xbCtjbDMweDA3c3JGT25j?=
 =?utf-8?B?eko1aUFpcGhwVVJMWVk4YXZsZmhHbEVKbFhOcDNjT29CZncvRWJnUEpkZjhk?=
 =?utf-8?B?bDNoeVIwNWxhc3k4aTdpSWt3SGVkcEIyMGdQOW41bGFDdWQzOHp5R2JNOWNq?=
 =?utf-8?B?U1Bnd3Z1UGpPSytSbHA2OEF1RmduTUVDdXJIZ3YxUndCNkJSWjhtbEo4d0M3?=
 =?utf-8?B?NzRVQmxvS3haUElneWFGcVFBMVNYUUJ1bWVoYWZ4SHJwb09ZM0FhZWI5RU90?=
 =?utf-8?B?ZG1kVjFEMHVhajYrc3UyQnlxL3BLZmVEb1pYcWdyclE2TmJsTUp1dnFOR3ha?=
 =?utf-8?B?bmh4QVZWUSs1QjlTWlZzSUZzUGc5b3RMNVBlc3RwZmFRUTNlRnViSU0zdmE3?=
 =?utf-8?B?N1hialk5TWprZFBpcEhHcmg4VlVya1E3dkdiaFFvR1orWlVTdThzUDlWajhG?=
 =?utf-8?B?cDZVTjZKU3dHbS83MXB4T2lqMW5EK2hRbEJmRHlMc05QK2tsTUkwOXY4bEdE?=
 =?utf-8?B?TUtVTkkzU3FxdzRXQjJUdUdtd2tLSXQyNTZpdzExcjNsSDBtL0VYZnoxYTNK?=
 =?utf-8?B?Y2hpUUdNRTRET3lDSEFrZm9GdURKd3VDcDUrSzRGalVERTlITit0YXV6MFMw?=
 =?utf-8?B?c0JRaDk4VFBYeXpEdFZUaFdwbWM2R3JKVFVFOFJOc1J3U2dHQlB0T2R6M1pK?=
 =?utf-8?B?MmhtTldkRGxjeHZxWCt3Yzh3N3QvNFpYOTVZV1N3QzRHTk56R01jaFQyV2hV?=
 =?utf-8?B?Z3U1TmJXUytubm56RWp4SlplR3Jwb0Q2UWh2eEg4MGEwdkszR2hVVmFSS2ow?=
 =?utf-8?B?V3U5U0M2NkcwZEdLMDF2aHVST245V1JZREYwckdSWVUzL2FjQzdUVXNhZGd3?=
 =?utf-8?B?MzlBU3R2cEJkRGNxcUxOb2ZCY3QrRGxTcThJZ1QwNlJHa3BzOU4yVDIycHF2?=
 =?utf-8?B?REhuVUY5em1sYlFtbVVzV2NQMkZScUpvdjl2RzJIU2M4bmJHKzVDcFdkVWNo?=
 =?utf-8?B?V2dnSmZmSldyQ25vbXlVdktSUlNjMlJHU1RhSWJTYmNZK201aWpSQXZCeDhS?=
 =?utf-8?B?VzJUaE9lWGlVWEhYUDI3MFR1RmppRno5eGNwbHpiajhoVG1Vc2ExZVFudzB2?=
 =?utf-8?B?NEFtT1RjMlJmcmY0QTl6Mm9oeTdld0NLcm1sTlVkbXNZK2NuL3dFei8vK3Ez?=
 =?utf-8?B?bW5XcDNaREt5eHFETTF0aXlqK1MwbU54MmdkR1VWdGRIeGV0T0RJb3JLbUt6?=
 =?utf-8?B?NnRyNTVWYWdNNVJacHIrdWw4aTFLc2IrMkpVL2NzL3RKRTJVWFZFY1lRZWlU?=
 =?utf-8?B?RnJ2VWV0UEJkcUtPM1lZdWg2ME5GVHkwbFZtV3daQm9FcVc1ZytaaEMwZ2tj?=
 =?utf-8?B?MzZ0cm9jaDlQQnlaSVJHeFkzQ2Mwd0NPU1J5TUZTN3RRd1lOeXJPWFhlL1Vv?=
 =?utf-8?B?V1hUZ3BiMDN5VHdiV2xjTkIyNWVGUXhlZUhETmdBbWYwMlppT1lYdFl3aWxR?=
 =?utf-8?B?MkxPUGVZWGJwRkV0Y1VtOExuNlYvWkw5NDdHczdtL3RsNjRqRHhvd0dNUXps?=
 =?utf-8?B?SEFod0FuVGVaWXBiNVJCYWpPL2o0dTlkYXM0cjk3Vml4dTUzS1pZNUJ6MHZB?=
 =?utf-8?B?VFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48066928-d7fc-4e1e-f274-08dd7e2c180e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 03:50:00.7347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b4iGRYiWwqOnnMkmbyTb5I/zSWT++Vc+oiH+rdtO/uaYUXOA/+zYv26kvohpMmoSEl0eyEHlFFbWKoqFpvfAtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF31D2DA56C
X-OriginatorOrg: intel.com



On 4/18/2025 7:10 AM, Alexey Kardashevskiy wrote:
> 
> 
> On 16/4/25 13:32, Chenyi Qiang wrote:
>>
>>
>> On 4/10/2025 9:44 AM, Chenyi Qiang wrote:
>>>
>>>
>>> On 4/10/2025 8:11 AM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 9/4/25 22:57, Chenyi Qiang wrote:
>>>>>
>>>>>
>>>>> On 4/9/2025 5:56 PM, Alexey Kardashevskiy wrote:
>>>>>>
>>>>>>
>>>>>> On 7/4/25 17:49, Chenyi Qiang wrote:
>>>>>>> RamDiscardManager is an interface used by virtio-mem to adjust VFIO
>>>>>>> mappings in relation to VM page assignment. It manages the state of
>>>>>>> populated and discard for the RAM. To accommodate future scnarios
>>>>>>> for
>>>>>>> managing RAM states, such as private and shared states in
>>>>>>> confidential
>>>>>>> VMs, the existing RamDiscardManager interface needs to be
>>>>>>> generalized.
>>>>>>>
>>>>>>> Introduce a parent class, GenericStateManager, to manage a pair of
>>>>>>
>>>>>> "GenericState" is the same as "State" really. Call it
>>>>>> RamStateManager.
>>>>>
>>>>> OK to me.
>>>>
>>>> Sorry, nah. "Generic" would mean "machine" in QEMU.
>>>
>>> OK, anyway, I can rename to RamStateManager if we follow this direction.
>>>
>>>>
>>>>
>>>>>>
>>>>>>
>>>>>>> opposite states with RamDiscardManager as its child. The changes
>>>>>>> include
>>>>>>> - Define a new abstract class GenericStateChange.
>>>>>>> - Extract six callbacks into GenericStateChangeClass and allow the
>>>>>>> child
>>>>>>>      classes to inherit them.
>>>>>>> - Modify RamDiscardManager-related helpers to use
>>>>>>> GenericStateManager
>>>>>>>      ones.
>>>>>>> - Define a generic StatChangeListener to extract fields from
>>>>>>
>>>>>> "e" missing in StateChangeListener.
>>>>>
>>>>> Fixed. Thanks.
>>>>>
>>>>>>
>>>>>>>      RamDiscardManager listener which allows future listeners to
>>>>>>> embed it
>>>>>>>      and avoid duplication.
>>>>>>> - Change the users of RamDiscardManager (virtio-mem, migration,
>>>>>>> etc.) to
>>>>>>>      switch to use GenericStateChange helpers.
>>>>>>>
>>>>>>> It can provide a more flexible and resuable framework for RAM state
>>>>>>> management, facilitating future enhancements and use cases.
>>>>>>
>>>>>> I fail to see how new interface helps with this. RamDiscardManager
>>>>>> manipulates populated/discarded. It would make sense may be if the
>>>>>> new
>>>>>> class had more bits per page, say private/shared/discarded but it
>>>>>> does
>>>>>> not. And PrivateSharedManager cannot coexist with RamDiscard. imho
>>>>>> this
>>>>>> is going in a wrong direction.
>>>>>
>>>>> I think we have two questions here:
>>>>>
>>>>> 1. whether we should define an abstract parent class and
>>>>> distinguish the
>>>>> RamDiscardManager and PrivateSharedManager?
>>>>
>>>> If it is 1 bit per page with the meaning "1 == populated == shared",
>>>> then no, one class will do.
>>>
>>> Not restrict to 1 bit per page. As mentioned in questions 2, the parent
>>> class can be more generic, e.g. only including
>>> register/unregister_listener().
>>>
>>> Like in this way:
>>>
>>> The parent class:
>>>
>>> struct StateChangeListener {
>>>      MemoryRegionSection *section;
>>> }
>>>
>>> struct RamStateManagerClass {
>>>      void (*register_listener)();
>>>      void (*unregister_listener)();
>>> }
>>>
>>> The child class:
>>>
>>> 1. RamDiscardManager
>>>
>>> struct RamDiscardListener {
>>>      StateChangeListener scl;
>>>      NotifyPopulate notify_populate;
>>>      NotifyDiscard notify_discard;
>>>      bool double_discard_supported;
>>>
>>>      QLIST_ENTRY(RamDiscardListener) next;
>>> }
>>>
>>> struct RamDiscardManagerClass {
>>>      RamStateManagerClass parent_class;
>>>      uint64_t (*get_min_granularity)();
>>>      bool (*is_populate)();
>>>      bool (*replay_populate)();
>>>      bool (*replay_discard)();
>>> }
>>>
>>> 2. PrivateSharedManager (or other name like ConfidentialRamManager?)
>>>
>>> struct PrivateSharedListener {
>>>      StateChangeListener scl;
>>>      NotifyShared notify_shared;
>>>      NotifyPrivate notify_private;
>>>      int priority;
>>>
>>>      QLIST_ENTRY(PrivateSharedListener) next;
>>> }
>>>
>>> struct PrivateSharedManagerClass {
>>>      RamStateManagerClass parent_class;
>>>      uint64_t (*get_min_granularity)();
>>>      bool (*is_shared)();
>>>      // No need to define replay_private/replay_shared as no use case at
>>> present.
>>> }
>>>
>>> In the future, if we want to manage three states, we can only extend
>>> PrivateSharedManagerClass/PrivateSharedListener.
>>
>> Hi Alexey & David,
>>
>> Any thoughts on this proposal?
> 
> 
> Sorry it is taking a while, I'll comment after the holidays. It is just
> a bit hard to follow how we started with just 1 patch and ended up with
> 13 patches with no clear answer why. Thanks,

Have a nice holiday! :)

And sorry for the confusion. I missed to paste the history link for the
motivation of the change
(https://lore.kernel.org/qemu-devel/0ed6faf8-f6f4-4050-994b-2722d2726bef@amd.com/)

I think the original RamDiscardManager solution can just work. This
framework change is mainly to facilitate future extension.

> 
> 
>>
>>>
>>>>
>>>>
>>>>> I vote for this. First, After making the distinction, the
>>>>> PrivateSharedManager won't go into the RamDiscardManager path which
>>>>> PrivateSharedManager may have not supported yet. e.g. the migration
>>>>> related path. In addtional, we can extend the PrivateSharedManager for
>>>>> specific handling, e.g. the priority listener, state_change()
>>>>> callback.
>>>>>
>>>>> 2. How we should abstract the parent class?
>>>>>
>>>>> I think this is the problem. My current implementation extracts all
>>>>> the
>>>>> callbacks in RamDiscardManager into the parent class and call them
>>>>> state_set and state_clear, which can only manage a pair of opposite
>>>>> states. As you mentioned, there could be private/shared/discarded
>>>>> three
>>>>> states in the future, which is not compatible with current design.
>>>>> Maybe
>>>>> we can make the parent class more generic, e.g. only extract the
>>>>> register/unregister_listener() into it.
>>>>
>>>> Or we could rename RamDiscardManager to RamStateManager, implement 2bit
>>>> per page (0 = discarded, 1 = populated+shared, 2 = populated+private).
>>>> Eventually we will have to deal with the mix of private and shared
>>>> mappings for the same device, how 1 bit per page is going to work?
>>>> Thanks,
>>>
>>> Only renaming RamDiscardManager seems not sufficient. Current
>>> RamDiscardManagerClass can only manage two states. For example, its
>>> callback functions only have the name of xxx_populate and xxx_discard.
>>> If we want to extend it to manage three states, we have to modify those
>>> callbacks, e.g. add some new argument like is_populate(bool is_private),
>>> or define some new callbacks like is_populate_private(). It will make
>>> this class more complicated, but actually not necessary in legacy VMs
>>> without the concept of private/shared.
>>>
>>
>>
> 


