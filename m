Return-Path: <kvm+bounces-47781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 813D6AC4C20
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 12:20:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429B81796B2
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00958259C94;
	Tue, 27 May 2025 10:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hjROixKW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF94E254844
	for <kvm@vger.kernel.org>; Tue, 27 May 2025 10:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748341198; cv=fail; b=jl9B0elS8x037w6o+eD2pJio2V5c28zMecS/n5CsDpwkPPmf/fvY8H6D02CBKdWBp46csZhUSQy5bg6o57Aw1v4qdRePgEvx7ANzEl1KMMOUdk47Gu7xh6R9b0Owm6JjrzBKkNp+H0CBI5XXvj21un8fa+lq8ucTJpzyGcVqzD0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748341198; c=relaxed/simple;
	bh=LlEAxOM70B/vuCm6sk3P1F6Os+4pBX7AdKo92NpYzzs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fXY//vH1v1XWYZhLVvIhWzWIY9+q9wHagMnl1+FCPHizF6VkvdvqqkhwAf3+FItrlgoFOrNe3MriHxX9rA3UwGp+qLlX+5wEi4bvT8suqwDjDVszNNmWT8T29rVJe8FxjjdRbD+PzB128Ef9e6cYiZJF5WFOE8neCayfz3bb0k4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hjROixKW; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748341195; x=1779877195;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LlEAxOM70B/vuCm6sk3P1F6Os+4pBX7AdKo92NpYzzs=;
  b=hjROixKWcL5QBLTCIvOPePD+tv+Z53OhMmD7TYJ5zJyJUwmQ+tn5HVrk
   JgK8FduWaa2pGlvaBinvHGAXxrkng7rMei1TfXt9lv/oSMntQVqm7/2EG
   50yBrw/IGaHtgg7fLHHR1cWAbmvOoNYhRSSs/GUQyQWquO8CkHd/xKSaO
   jrI9z3sa4u2Zgw7xqAm+DUqYJ8MOteOlm8oPjODFax5i5LOKDK37bMoro
   lmkrXHYw0zwEpu2yL3mi/RaMLRCffKatAa1o1F39U+cZSCXGN1vQcVdCi
   zwacul88Cb8XVyoPcEbaABrbAvWOoZEklsOG0d3aPzKRz6a4KGNCdN7vh
   w==;
X-CSE-ConnectionGUID: HOMuU0xSTMyoqr12dQKpGw==
X-CSE-MsgGUID: RzxRw0L1TpGcpIHSZg0Ryw==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="50434815"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="50434815"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 03:19:53 -0700
X-CSE-ConnectionGUID: 8xFrcaXQQQyJVu6OKB0gTA==
X-CSE-MsgGUID: 1uZtXINiR86L4a3oYJ9QUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="142705051"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 03:19:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 03:19:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 03:19:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.69)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 03:18:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vYkV2t//d3e0m1jsMNeEcmf3fVl6Vxy3uULCDSpytfxHCuemskJeb6IVGa9ZKLsy810EyjAFZcttE2DhqGR8q8Nl3PfRy0/ZJCbOTrhXhMvpwXt1oViPhUKDhJc5S5pfA9+jeFTmYOkL4Cx3k1p0qfSRxaBObE0ODlNEwwLnnenCv5KHwpTuDAC/ppXriIstRTok931LHTis8p87urNjQVUQuISiPjyfSU5+VMxCiPkFEiKYjHXu3jDTwEc9QuSoU16pp2zFZJ68bVm33W/EZAhimRbVNVy5rV6mM3Cy2R/10/EO7Vlh4l/uTWjQ+2VwfyTjViQGUxH8Fxbv7Z61bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtwwZSUYhC4XiUnDqOD2PNOiKrtINJBBYK5FT/XzTFU=;
 b=eTEmvutd3I0hJHCrS/HFE+EtFvsBn1YbqC2GZKrVAMfl1SQ0VCTJd6Y6L/q+MPIfrn0mG9sX5gCYDGlUib7xV4d3iPdidVyf/TnfMWQ4uLTMXD4wbV0iS5UcW82f1Gho8sJ+Z5lwkK3+71cyPdLRZKv8mz7RUu9jq4BoIXF3duiL6g6Qn+OCXnAAhLm8JsHm3UroJ1zB+us2GstWfWlb2v3I2pwnFDXOlaWDACER8YOB0ukxz/YBkPvd5cutPzQKpiAiRvcA51f/gYiABr6x0aOu67eqUtpG+N+N2rG5nj10iVUgkLSSKOT/MLTIOV26y85nrc7LGYpb5CBiJA+pCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 IA3PR11MB9256.namprd11.prod.outlook.com (2603:10b6:208:57f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.24; Tue, 27 May
 2025 10:18:49 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Tue, 27 May 2025
 10:18:49 +0000
Message-ID: <475254ca-6da3-4216-8e88-858d42724958@intel.com>
Date: Tue, 27 May 2025 18:18:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/10] ram-block-attribute: Add more error handling
 during state changes
To: Alexey Kardashevskiy <aik@amd.com>, David Hildenbrand <david@redhat.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-11-chenyi.qiang@intel.com>
 <c6013cd5-a202-4bd9-a181-0384ddc305ab@amd.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <c6013cd5-a202-4bd9-a181-0384ddc305ab@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR01CA0022.apcprd01.prod.exchangelabs.com
 (2603:1096:820::34) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|IA3PR11MB9256:EE_
X-MS-Office365-Filtering-Correlation-Id: b6ea38ea-9df1-47c6-5578-08dd9d07df3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SnprNmc3MDNOQlZCcE5Wb2htd1hXWGw0YVpHN3p6bXJtT0Vwc2Z4dkp6MUV1?=
 =?utf-8?B?K0lpa3h5aXFjYlFleDFrbjBhZGtINHI0Sk81UjZ2eUhPK1JJdTZVaGxoQUt6?=
 =?utf-8?B?ZUpHdHpGLzFMUTJUalNBTlJMUWhmUzhWaWpwejhBRVZXQlN0SHF6dS94NVhj?=
 =?utf-8?B?MGN3K0puQmswa3V4NGd4UklWeENrQ3Fka0NUTzM3UENPM29kT2VyY2lOU1Qv?=
 =?utf-8?B?RVhpNnhyYjVvaDlKSWFRY05CQnlwbWgyWW1UOWE1K0ZlTEt6cjNZV0tEbGNC?=
 =?utf-8?B?MTNBV0c2OUF5Q0o2M0lob05NQnU1UThvVTBnMExZWGkvZ2tkVHJMZ0JKYmFD?=
 =?utf-8?B?VjFIWVRjdExmcG9uYUUwblVKQ2drMDB5ZzRES3lpTTk5YXFWOGphSUk2TjYz?=
 =?utf-8?B?MXQwMHVobm55WG90a1AxUGNwS2pVTDdjZ0hMUDFwNWV4YzA5WGdzekNJZldE?=
 =?utf-8?B?ZUI5Vm5FTEQ2RC91djZodEwyY0VrNEdrTFFsTkdnWnZtWUh1SFhzeTlYRXdF?=
 =?utf-8?B?N0Q0bW9YcnZERGVxM0pkblNsM0pBNTgwYXBPdnJwbUJmRXNDUHVQTDRxQVVQ?=
 =?utf-8?B?K001YnhucklHL2dvMlI2dFNZaGhKWXBMQnZNSGRHNDFMK0lyZ1E1MlZWbEhy?=
 =?utf-8?B?Y0p5bTVjQmQ4Sk9DckJmSUdkVEhNT3pjMXhMTm9OdGxlRlNiVGlRRUFncDB0?=
 =?utf-8?B?U0NqT2cwR3JtMVg5bjk4dnEzSmQwRUVaaUlIcjdlajVGQjVodzBmcGc0UDNN?=
 =?utf-8?B?Nld2TWtGYklBK2FyNUJyUkJzYU5ZM3ZySzVoYjRxelpxUGwyeUNMLzVPaUhp?=
 =?utf-8?B?czZxU0VEQ2ZNa3Z0UFpMd2lzVlZnRnRaaVdwNzVlZE5LZHhhRDBKRmYyblRZ?=
 =?utf-8?B?S05kWU1QUWV6dHJBQzFaNVRuNVV1ajV1aE9LU3Bjd2ZXQm51MVNtTkp2NTNh?=
 =?utf-8?B?ZmNxc0ltNktHM0ViR3R4ZUdMN2xYcXlKNXZpTWVDa3BjT3pBRjMwdDZHZUFP?=
 =?utf-8?B?Y0NuSnJSVUhQSm1jeTkwQTkyV1BDb3Uvc2pzTUdTcytyZ0NwMjRpMUtRRzNM?=
 =?utf-8?B?R3U0MDhCd3VZdVlyenp4YWJBTUhEQ2N3aS9hZDlqQ3J3eXNQZUZMY2s4L3g2?=
 =?utf-8?B?QkFiVW5aV3hxNUl6YTlYNzgyVVRWTEtpbm9kckhvd3c0anZ2c2gwOGtRR1JF?=
 =?utf-8?B?RjFzVCtUQ01NNXZDNkI3OWl5NWhEcXlRQ0JNdHU0bGpMcERzWHprbDFaWjVq?=
 =?utf-8?B?MDVaaVFDRm9VaFhNMXpTdGFqUUsveThOTjBYaHphRGhOM1RSc2pqY3IyWjlJ?=
 =?utf-8?B?UHB2WnhlVktjNGg0MG9QenhQMzFmL1ZSQWxOc0Q0cWU1d3pmWTdzSDBmaXJ3?=
 =?utf-8?B?cTRndkl5NVRIK3R3Q0l3YktZQWIyYnZVSDc3UjRwb2wyYWUyNnJuTnMvV1Fs?=
 =?utf-8?B?NjV4RWJ4dVpiZzFxSWhCemlWUGhvdXl0dGVVd3VJWEl6Nk9qNW5SU3o0a3Bo?=
 =?utf-8?B?RWV5RmlBNzF0cDRNS3Z5bEpEYTJWajUrQkNhRXlkV01CM29RMEcxUXB5M0l3?=
 =?utf-8?B?TlpNamw4MnE5NTdrZko3L3JVZXM5RklxcEpoRlh0ZXFVTVhtSnRWQU83d3lp?=
 =?utf-8?B?Q2xQd0tYMUZRN3VTcm5QU3NjUGxxRHBzWHhPK05rcmNSZkJ2UXlyWFhpMWVO?=
 =?utf-8?B?S2g1UnNaSzhHaU9jZE1PNWR1aDBRcHZOSWcxOEFwUStIdWliRlhlOTZjeXpi?=
 =?utf-8?B?cFFOaDJZTlI0NVFUWkwxRzRWR1I0bUd4VUJKUGs1Kyt4Y1VaaTUwM2U3UVVa?=
 =?utf-8?B?aGFLMmpXMHRGbEh3SmY1bnJNK0IvcUlaRGt6RzVaMWNsRnNvRllDMWNVVW1E?=
 =?utf-8?B?U25YbUM0VnMwQytLWUwyaHVVV2dySmw3UVQ2QUdBYUIzYy9GejlrcUYxc2JX?=
 =?utf-8?Q?HIVKWhO0Ni0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzJrb2p2bWtoN25mOC9vYml3WWVJanRtRENQNnBtTFhCR3JEUVNvY0RPMWZy?=
 =?utf-8?B?dlBCTm12Z0tINjlxU1pjWm80L1gzOG5rNEtKVzdBc2VEOUVhbElHeG9ocFVx?=
 =?utf-8?B?T3NHMlhZWStuZWZWTUpOQWJJQVJBQ282bVludjU4SEEzVW1jZGRxQVhVWUJw?=
 =?utf-8?B?UGFUMmt3N1QyWExKSnp3MDZKaWNUWC9jN2xlSU1pb1g2M09MQTJqNmtxQU15?=
 =?utf-8?B?M3h1dXBiU3dQSUIxRWpuY3JsMDhuT0J3ZE0wNVg5NFFBbzdPVHVXNHc2WUJO?=
 =?utf-8?B?VXNaMk00RTlXYlBYeEpIOEoxU0RYMWIwWDJqdkVtMnBKQlBkTnhpUFk0M3dp?=
 =?utf-8?B?SXdKVlJ6VmdkTzBYVzBiOGl4YmcvNEEvK0ZtRUJRdDVjNjJsUlA5bXQwbFln?=
 =?utf-8?B?YllnSnkvblZ1eGRneG95MDhURXhHYUZ0QmpzRGJ2WmtqRTZmRS9MeFNxVGZs?=
 =?utf-8?B?SlgyUTBXMFgwVGcwa09aYjUzampzSHprQ241VU56NVBOajJwZG41RmxGQWFr?=
 =?utf-8?B?ODdhZ21OY2Z3cW53M2tTYU92dkxMNitudzBEdzROVDNOMWd6dm1QSnIxUlRI?=
 =?utf-8?B?d1VXSUozYmxQUDJIZmRuTmNqaUtjUGlOSnBnYXZzYkNxZjdDSVFneDJ0a3py?=
 =?utf-8?B?OWU1N0JhZGVxSCtrTUFRVkkxTkVUTE1hMkpSRnhpM3pSQzR6NlNubHMwd0w5?=
 =?utf-8?B?dHpGMXZpd3pZTTNHTFIzaGlzK1lnbE45eEtXeFRRSHUvU1p1cHZ2clJZeisx?=
 =?utf-8?B?S0QyenZIYktNMmN2UzhHLzlPbkhtV01IUzhGUlUycjlqTmxwVlhDN2c3dUFm?=
 =?utf-8?B?dEd6d3N5amJkMWt4UE1obE95SUxuN0Z3QUY2YjJteDJrczQySXZKWm5rQjll?=
 =?utf-8?B?aU5WM3NpL3JrTE5sQ0FHSThEMVZyVlBVQ1lCdG9Db1FTMHg1cWxMU0ZQQksx?=
 =?utf-8?B?cExiUURxUzJtZ2t1NGdHK0FVcy9wQnphaU9MNUJHMUNQS0s0V0Z3NXFlNk1p?=
 =?utf-8?B?M3JMWEgyNEFCZlhsMnZPTTJFUktra1dPU0dhRjUwNjhVS3Z6dXdFbm1SbXhT?=
 =?utf-8?B?dURGQmZVaHNoK2xKVmY4dDFwYVo1SFJ0d2dyQjE3L3grcVJxL05xWDVmNld3?=
 =?utf-8?B?cFRaV0dvVUxxODVSeThZL0ZSM2FuR3J5d21Ga1FUSG5lNGEyaldndzdaZml5?=
 =?utf-8?B?OTBOd1lxU2grakhNb2Z5TlpiOWd6dlZvNklvZ0xpOTQyL3NHRXVtOVF0aUhk?=
 =?utf-8?B?c2JyWnB0VkovMEJVbGljSmV4bjF3MjBlU3I2ZlJTUnEvb3phRVZjV2VPVnNV?=
 =?utf-8?B?bWZNczJTUGdUNE11Zmc2YXFDZ2VFMjlHR21Kd284Vk5tTW1wNG5DMW1lenB0?=
 =?utf-8?B?N2Y2YUhNek1XMFVvUzVUTDNCdkR0WWNzRmZLajdqcDk5aU4zaUdheFI3akhr?=
 =?utf-8?B?Z2hHUm9WcjFFNERNNU1xdGM2azFUaTgzQ1lmeDNoaFkwU3RyQ0pEaHpFRkVE?=
 =?utf-8?B?VEUxaElSeThETzRjcUQzMGRNUUt4NDZJSFBHOHY0QnpHcFR5NkI4QnloY28z?=
 =?utf-8?B?NHkxUEdYYk15MHVJb2RudSt6OVRXMk52ZVpBSEdvMlhxY1Mvd3pBaEJlZDV4?=
 =?utf-8?B?MG56MFdGTkN6SnUzS1BoWVZWZGNXTG5jbXFBb2FER0RFM2xFK2NmaDh1Wlph?=
 =?utf-8?B?NW12eVNvR3ppdWYxb2pGSTBXRmdTT3l6QU5WUHQ5TU11akpLNEVHTXhYVDVN?=
 =?utf-8?B?S2Z5VjNmWjFvUkozZzJJWjBscmQ3S2E0R05GNElsSjhUSWpoK3VEYUg2dG1Q?=
 =?utf-8?B?RWtxd1pnRkR1S05xd1RhaG9KaWRtaUNvMHcyVUYrMXdjMkIzVjdCNUd6dFNl?=
 =?utf-8?B?SmIySFNPOWhjS2o0VFRPVUdGMEx6YWFnZHRlcDY3T0NFWEFjV3JlS01UWExu?=
 =?utf-8?B?RjF3Y3pGeFhKNm8vbWlJb3p6cHc4WlpXS2RFTThzVVdZMGFhYlpFdHFCcDg1?=
 =?utf-8?B?M2R6S3pQWGordTM3YW4rK0lRc1pmQ1lpNTR5cE1TRnpEMERYZ1ArZmdOSGV5?=
 =?utf-8?B?OXFlQ05VelJrcEZHajBqcG9ZQVZYRVFOZ1d2bmZhSy9WNFdoQVVTZzEwY3R0?=
 =?utf-8?B?LzQ3M1o4T2RFQk5rZExDc0tvbHlZM0V6S0RpOUtiQUhvVzZPaFFLM3pESW1l?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b6ea38ea-9df1-47c6-5578-08dd9d07df3e
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2025 10:18:49.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnUBvP5LfZEgBlL2sfCmdtK6ToBZqK5IheZG1ussLdukq6dS0oQkLW4LighdFbtRqjNZkF0TiGGdc4d2bvpB+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9256
X-OriginatorOrg: intel.com



On 5/27/2025 5:11 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 20/5/25 20:28, Chenyi Qiang wrote:
>> The current error handling is simple with the following assumption:
>> - QEMU will quit instead of resuming the guest if kvm_convert_memory()
>>    fails, thus no need to do rollback.
>> - The convert range is required to be in the desired state. It is not
>>    allowed to handle the mixture case.
>> - The conversion from shared to private is a non-failure operation.
>>
>> This is sufficient for now as complext error handling is not required.
>> For future extension, add some potential error handling.
>> - For private to shared conversion, do the rollback operation if
>>    ram_block_attribute_notify_to_populated() fails.
>> - For shared to private conversion, still assert it as a non-failure
>>    operation for now. It could be an easy fail path with in-place
>>    conversion, which will likely have to retry the conversion until it
>>    works in the future.
>> - For mixture case, process individual blocks for ease of rollback.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   system/ram-block-attribute.c | 116 +++++++++++++++++++++++++++--------
>>   1 file changed, 90 insertions(+), 26 deletions(-)
>>
>> diff --git a/system/ram-block-attribute.c b/system/ram-block-attribute.c
>> index 387501b569..0af3396aa4 100644
>> --- a/system/ram-block-attribute.c
>> +++ b/system/ram-block-attribute.c
>> @@ -289,7 +289,12 @@ static int
>> ram_block_attribute_notify_to_discard(RamBlockAttribute *attr,
>>           }
>>           ret = rdl->notify_discard(rdl, &tmp);
>>           if (ret) {
>> -            break;
>> +            /*
>> +             * The current to_private listeners (VFIO dma_unmap and
>> +             * KVM set_attribute_private) are non-failing operations.
>> +             * TODO: add rollback operations if it is allowed to fail.
>> +             */
>> +            g_assert(ret);
>>           }
>>       }
>>   @@ -300,7 +305,7 @@ static int
>>   ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
>>                                           uint64_t offset, uint64_t size)
>>   {
>> -    RamDiscardListener *rdl;
>> +    RamDiscardListener *rdl, *rdl2;
>>       int ret = 0;
>>         QLIST_FOREACH(rdl, &attr->rdl_list, next) {
>> @@ -315,6 +320,20 @@
>> ram_block_attribute_notify_to_populated(RamBlockAttribute *attr,
>>           }
>>       }
>>   +    if (ret) {
>> +        /* Notify all already-notified listeners. */
>> +        QLIST_FOREACH(rdl2, &attr->rdl_list, next) {
>> +            MemoryRegionSection tmp = *rdl2->section;
>> +
>> +            if (rdl == rdl2) {
>> +                break;
>> +            }
>> +            if (!memory_region_section_intersect_range(&tmp, offset,
>> size)) {
>> +                continue;
>> +            }
>> +            rdl2->notify_discard(rdl2, &tmp);
>> +        }
>> +    }
>>       return ret;
>>   }
>>   @@ -353,6 +372,9 @@ int
>> ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t
>> offset,
>>       const int block_size = ram_block_attribute_get_block_size(attr);
>>       const unsigned long first_bit = offset / block_size;
>>       const unsigned long nbits = size / block_size;
>> +    const uint64_t end = offset + size;
>> +    unsigned long bit;
>> +    uint64_t cur;
>>       int ret = 0;
>>         if (!ram_block_attribute_is_valid_range(attr, offset, size)) {
>> @@ -361,32 +383,74 @@ int
>> ram_block_attribute_state_change(RamBlockAttribute *attr, uint64_t
>> offset,
>>           return -1;
>>       }
>>   -    /* Already discard/populated */
>> -    if ((ram_block_attribute_is_range_discard(attr, offset, size) &&
>> -         to_private) ||
>> -        (ram_block_attribute_is_range_populated(attr, offset, size) &&
>> -         !to_private)) {
>> -        return 0;
>> -    }
>> -
>> -    /* Unexpected mixture */
>> -    if ((!ram_block_attribute_is_range_populated(attr, offset, size) &&
>> -         to_private) ||
>> -        (!ram_block_attribute_is_range_discard(attr, offset, size) &&
>> -         !to_private)) {
>> -        error_report("%s, the range is not all in the desired state: "
>> -                     "(offset 0x%lx, size 0x%lx), %s",
>> -                     __func__, offset, size,
>> -                     to_private ? "private" : "shared");
>> -        return -1;
>> -    }
> 
> David is right, this needs to be squashed where you added the above hunk.
> 
>> -
>>       if (to_private) {
>> -        bitmap_clear(attr->bitmap, first_bit, nbits);
>> -        ret = ram_block_attribute_notify_to_discard(attr, offset, size);
>> +        if (ram_block_attribute_is_range_discard(attr, offset, size)) {
>> +            /* Already private */
>> +        } else if (!ram_block_attribute_is_range_populated(attr, offset,
>> +                                                           size)) {
>> +            /* Unexpected mixture: process individual blocks */
> 
> 
> Is an "expected mix" situation possible?

I didn't see such real case. And TDX GHCI spec also doesn't mention how
to handle such situation.

> May be just always run the code for "unexpected mix", or refuse mixing
> and let the VM deal with it?

[...]

> 
> 
>> +            for (cur = offset; cur < end; cur += block_size) {
>> +                bit = cur / block_size;
>> +                if (!test_bit(bit, attr->bitmap)) {
>> +                    continue;
>> +                }
>> +                clear_bit(bit, attr->bitmap);
>> +                ram_block_attribute_notify_to_discard(attr, cur,
>> block_size);
>> +            }
>> +        } else {
>> +            /* Completely shared */
>> +            bitmap_clear(attr->bitmap, first_bit, nbits);
>> +            ram_block_attribute_notify_to_discard(attr, offset, size);
>> +        }
>>       } else {
>> -        bitmap_set(attr->bitmap, first_bit, nbits);
>> -        ret = ram_block_attribute_notify_to_populated(attr, offset,
>> size);
>> +        if (ram_block_attribute_is_range_populated(attr, offset,
>> size)) {
>> +            /* Already shared */
>> +        } else if (!ram_block_attribute_is_range_discard(attr,
>> offset, size)) {
>> +            /* Unexpected mixture: process individual blocks */
>> +            unsigned long *modified_bitmap = bitmap_new(nbits);
>> +
>> +            for (cur = offset; cur < end; cur += block_size) {
>> +                bit = cur / block_size;
>> +                if (test_bit(bit, attr->bitmap)) {
>> +                    continue;
>> +                }
>> +                set_bit(bit, attr->bitmap);
>> +                ret = ram_block_attribute_notify_to_populated(attr, cur,
>> +                                                           block_size);
>> +                if (!ret) {
>> +                    set_bit(bit - first_bit, modified_bitmap);
>> +                    continue;
>> +                }
>> +                clear_bit(bit, attr->bitmap);
>> +                break;
>> +            }
>> +
>> +            if (ret) {
>> +                /*
>> +                 * Very unexpected: something went wrong. Revert to
>> the old
>> +                 * state, marking only the blocks as private that we
>> converted
>> +                 * to shared.
> 
> 
> If something went wrong... well, on my AMD machine this usually means
> the fw is really unhappy and recovery is hardly possible and the machine
> needs reboot. Probably stopping the VM would make more sense for now (or
> stop the device so the user could save work from the VM, dunno).

My current plan (in next version) is to squash the mixture handling in
previous patch to always run the code for "unexpected mix", and return
error without rollback if it fails in kvm_convert_memory(), which will
cause QEMU to quit. I think it can meet what you want.

As for the rollback handling, maybe keep it as an attached patch for
future reference or just remove it.

> 
> 
>> +                 */
>> +                for (cur = offset; cur < end; cur += block_size) {
>> +                    bit = cur / block_size;
>> +                    if (!test_bit(bit - first_bit, modified_bitmap)) {
>> +                        continue;
>> +                    }
>> +                    assert(test_bit(bit, attr->bitmap));
>> +                    clear_bit(bit, attr->bitmap);
>> +                    ram_block_attribute_notify_to_discard(attr, cur,
>> +                                                          block_size);
>> +                }
>> +            }
>> +            g_free(modified_bitmap);
>> +        } else {
>> +            /* Complete private */
> 
> I'd swap this hunk with the previous one. Thanks,

Fine to change. Thanks.

> 
>> +            bitmap_set(attr->bitmap, first_bit, nbits);
>> +            ret = ram_block_attribute_notify_to_populated(attr,
>> offset, size);
>> +            if (ret) {
>> +                bitmap_clear(attr->bitmap, first_bit, nbits);
>> +            }
>> +        }
>>       }
>>         return ret;
> 


