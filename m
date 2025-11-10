Return-Path: <kvm+bounces-62576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D02F4C48EDB
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 20:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C3EB3BBC6B
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87BE6330B3E;
	Mon, 10 Nov 2025 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jr+PtW1E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9DD330B00;
	Mon, 10 Nov 2025 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762800646; cv=fail; b=uJ4WkYz1pA+Miuvwbs+WtluC1lSLseNHQqdXozNC9R48FoNc9/z+kg6+0wtjHgGsXnvyP2dbiVCi8a7q9mL9VGw5fdR50uIQ/bfCGH8sATy7pDFQxKPthAm59bjCvklSMN5AH3qUA/tW0mGCFy62SgpV635fy3qpmIuPzPNPj6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762800646; c=relaxed/simple;
	bh=xTV7QYZzZy1UG+4DKnlxrotJdO+aq03oW5uR3bLH5GI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FT8YbHQj60uTt/nicxqn7iasjM9fxqM9i4taxSlcD9H4OyHELcOgMyAWFx4yhHXv+/gzFqIg1gGKw1wlsoxBosfwohAsSF/3takDzf875pt5RK+Sv0gyGzifsDg6xA6XPpRbnbo39JIECgfQTDnV033YzCg03ZeONY0R8UK3VSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jr+PtW1E; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762800645; x=1794336645;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xTV7QYZzZy1UG+4DKnlxrotJdO+aq03oW5uR3bLH5GI=;
  b=jr+PtW1EFeZzDtxwxdP50fhb3cIfPAqWYPOQ38SW6Bk9Q1IdSOodJI6u
   dEm0TQ/ve97jX1Fx33EkX+Wz9kAbpUybf6H5bmbIDAfiHZCXyvOK7V6qp
   ow8176i5vxDEiaaWTlVIw6c0b88LIymyt+sFIjuilopMRlawqg9x6w30i
   8RMKJwvnDaOds61aXYspWtJEtKp9TPEVRaX5mtxArohebXfCluZFTcull
   brRgQ8sp4AiE8RETJRH3J+lMTOF/y70rDzCf5TvmQ2G9WMi5IdkPcfnFR
   Tg/xAMc/ymF6KWh66aGdVQN2pwubtUP/zUzqdfMgBILv6/QPflIBDIaHh
   w==;
X-CSE-ConnectionGUID: vcEt9UsnSs6CujTv9r6bug==
X-CSE-MsgGUID: ZSm8wxMrSvWGRk/Gcg1hYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="64898015"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="64898015"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:50:45 -0800
X-CSE-ConnectionGUID: udsDuok3RqmjMCrMNs79Zw==
X-CSE-MsgGUID: s8yupxxISlKzD2R9wvCegA==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:50:44 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 10:50:43 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 10 Nov 2025 10:50:43 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.16) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 10 Nov 2025 10:50:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PdYE3L4ubj9fozNAN64OF8OZw/QpW0j07MRuaCdxILN7vYkIZnFBXi4n5LZUb43CpXa19m6QRNi8DURhkfCdnAcWEjrCtrDEnUiCqMeZapEBGS2w0wGzaC2uBXa4M/r2YeWL2oiHujV98Ac/j8N4SM5OJxaEBHo1BfMMttous6KJ6sci3O08Ewj/yrxLPNMDYBMHfz7ik7kGZCOPQy8/w0A+JkBTytaZFSGr+pAMb+Qiiz/eOCx279WEA7VilzFsemka8tm3vndPqTydyHy4cH9XtnrQW4F6HMzw7DAiyEodPFhE7fgRpiGGHeZz9c5FlUO+y5qxtdPpkXXNKwdZ8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oskcQLjnTfSlWk6/hgRugdfijfWdOri3KL552CA4nl0=;
 b=dPlgOZqVIHK1ilhtIwBjz7mow+0+0YgqvGiGflxEqJ575ZpeN7KZVFALT8Iap3zEEex6r1aKiin8ZKrr1rZ1ZuuC0RXDO2rqpSjm4oVuPYpsQQSpgS2MGdT3fAEo2OulDPIqxDy1u4WXHWvklwjvSYesZkJNb4Pkkg0ieXr/xHiCzgLjS8ToKuAKaxgscuyuqhI/SgpeFI7xts1N50DCdhFQACPAoumOtL5+VLJTSg2PhJz+GLE4R/IUfQw8HTMnH9E5Z6UKoq/+mBPL8hFPoz/gj0mgwz7Pu03Xk9F49L2JdqSz+NCVvgINU5lleMSE51T40pxqnlHt3X352EOk9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS4PPF0442004E1.namprd11.prod.outlook.com (2603:10b6:f:fc02::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 18:50:41 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.9298.015; Mon, 10 Nov 2025
 18:50:41 +0000
Message-ID: <2bb461a0-1332-49c8-94f7-fd8ba562b752@intel.com>
Date: Mon, 10 Nov 2025 10:50:39 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v1 00/20] KVM: x86: Support APX feature for guests
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <chao.gao@intel.com>,
	<zhao1.liu@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0065.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::10) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS4PPF0442004E1:EE_
X-MS-Office365-Filtering-Correlation-Id: 732154de-4020-4e99-8b21-08de208a0c14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dXVFbUVQL01qWXdDTWFtcU1MMkJBNldkLzZRcnB3bjJRZ0dQOVA0L2gvam1T?=
 =?utf-8?B?aG9xZkE5cGFIUEgvMjZtaVhNQ3JreHpuNXVpM0FnaEx4MUFGdnM3THVkYWpM?=
 =?utf-8?B?K0ljWEFVNWNPdGpaRUtseDM1ejhkRHFwdEdQRElTQW1aYWY3M3J5U0Q0dlEx?=
 =?utf-8?B?ZmVOczBIRTN4YWR3OXE2d3BLQmxNdXB6YnM3bTBpVDRlZHo2NlFqTlFjS2Ir?=
 =?utf-8?B?TjNlT0lWdEJxbWt1QWZsd2NsdWZZNFRDQVZ0WFd2YmVuOG5OWE5hbmw1SkF6?=
 =?utf-8?B?Mk1EMTlBSzBjWXRmZUUzYVlLR0VrZWIvRWM0eUFJNlJ0b3h1Z202WWcvVXpx?=
 =?utf-8?B?R08rQ1ovdDhTRDFqT3B4d1lteTFMZ25HVnozRXVHb2NwT1ZuZlF2dVJSQ0Mz?=
 =?utf-8?B?dTVHeTZVZlgxWUpXQVNORVpOUzhtTGR6Um5nVWlUNzB6cXk1N2xMc2kxNGJV?=
 =?utf-8?B?WmhLcjNJVkJEZUpDR01ZcENvZ3VrVmY2aW8ycjFXa09lVXZjbXNHY1lYYnUw?=
 =?utf-8?B?VlB2TDZBanFVbWhHZUxJTWFDVFlRVTFaa0cwQUpYQU5VMElpSHExeTBqbm9P?=
 =?utf-8?B?bDVNbmJHVG8xcGxyVVd3WThERUV1OHZoZ052RmFEVWhJQ2ZoelAwblN1YkJ2?=
 =?utf-8?B?aitPOXZWV1Z6Z3BPRjY1a2tYSFJQTWhmaHZkTUNzV1BvZDBiaFpyQ2ZJcGhP?=
 =?utf-8?B?Zktha2dNb2cvUEJxNnFaQ05uaVRxY1FFQ3lkU0dFT0hvTUFKL3RnMjlmUlJM?=
 =?utf-8?B?TFE3eFlidWFaY1o2K1ZDemwzTlVCdDd6eis5TkczaUlkRVBWSS9xWEpocUVq?=
 =?utf-8?B?emJacGlTd081TEIvTzMxcXFUWGpWVHNnTkNrOWRXK2pQSHZ4aGo4MTFvd0g5?=
 =?utf-8?B?QTVVZ3FUUWdQbFp5MGF3RjRQcUZSRHBHcC8yWUdQcUk3a0tUL3hRUHFmTHJB?=
 =?utf-8?B?ZGtuVzJaeUxJWVVJcklsUXJPczlNK25WOXoxTFRMTTlBblYxSEZPUHBZdlor?=
 =?utf-8?B?NS9iNkplQmNHL0dnNVYvMVNoRDIyWHpPMHpKRkFjNk5lajFVUGI3aGVUa3p3?=
 =?utf-8?B?V0s4bEZnZS8vaHdWb2FxcjVXSngzQ2swVHRVdkE1YXZDLytzSlVzN2duS1Zl?=
 =?utf-8?B?dzUvNkNvVGtPTkkwWUlaQnk3U3JVWWZmRjhORWtaWGhWUEowZGxFVEUwN1dO?=
 =?utf-8?B?NVhnd01yV3A5SlJ5ajBHZ0tadGRZc1FBNi9tdkFFYTVsd1IwS29QVXlmOG1N?=
 =?utf-8?B?VmhkWkdjVWtVUWVIRFFSZlVtM21uUXo5T0pUY0hyTHlGUlllUnN3VkQrS3ZW?=
 =?utf-8?B?STZ6bzFHNmF3OHI2azltWG5RTmQzaUlXS00yYzhjYWJVcEpTYXIwQUQ4c2FR?=
 =?utf-8?B?bWg2VlhleEpncWQzd1FGRTFCVngxVFczaVRyKzRKblVuMEVSS3NCakZTRmxX?=
 =?utf-8?B?RVAvWGdTRytGd0tqVFZHTzA0elB0WkhBZ2ZWODFrRTIwY3lVNUxSMWNYb1Bs?=
 =?utf-8?B?ekRyNlVteStvdjJkMlZnZXpLM1JCd0pLWHdLRjQrdWw2cWdKd0pvdTc3alJv?=
 =?utf-8?B?QSt6SmZtNXE1VU4vQ2U2Rm5yanFoVzJWbmFuY0lKWnR3S04yQitZTHJubGhV?=
 =?utf-8?B?MWJtdFdXUkxyazJvZGVnTkp0ckRPdnhFSmxscVdwTEdGV1Y0NUhGYUd1SU1o?=
 =?utf-8?B?cml1OXpMZE1ETkM2TmVFNTRWUmpXeU1wa1BTMnhEdVNDRGpsdXRiZGN0SUdS?=
 =?utf-8?B?SDF5OTRobnVoQmVGZ1BDcHZxQi90YldORHFKOThIL2s3UzNxa2hoUlI1VHA5?=
 =?utf-8?B?U09mZWZ5a0grbGRTQXRZTFJDcVR4SGdCSzBLV2g5QmZlZXNMSkdyZDlzbEJX?=
 =?utf-8?B?dUZxTndxelo1M3N3UFRpa25GRXkvRmYzTTRuVVJMM052eWNyMUVBbkJ5cW5z?=
 =?utf-8?Q?jt+hIuxkiGrwsfhuhy9P6jbB1Ax0+nL2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHI0RUxIb1dSOU5hUTNQUy81Z0k5eDR2djZ4MjRsZXI1MTlCM0lJOUhBb3o4?=
 =?utf-8?B?YzFCZmNvK1BWcE9NSjNEanZyanRxTlQ5akIwMGdBRDFVbVU2emFramJFK3Nh?=
 =?utf-8?B?U1pnU0NibGwvTGhDN3J1TUZlbnhmWVZEUTlEeFZJeURqenE1MG0rQlNVR2Zm?=
 =?utf-8?B?Q0ZHYkpTTzg3N2Zob0swUlZjcXpCemZzbC9EM3hDR001S1ZyQ0FvTjluSzhV?=
 =?utf-8?B?QXFPT2gxdnhJcEFHNjZFcmhJVmhQMWJtbVkyT0N2bXVDK1BCNlZGbFpHWEtT?=
 =?utf-8?B?UUtVdVRxeG5tSmhSZzNlMFZEbWgwbFVBcjQ4OUtzdDBSR01NTnQvS2xadXBk?=
 =?utf-8?B?cnF0MG85Y3pURk0zK0dadzBwaHZBbTRzbDA3TlJJVmVobWQ4c3ZUYWNuU2tE?=
 =?utf-8?B?TTcvL1J4RFNMaWtEclBpVW1aUVZ4VmpKY3UzOENkb1ZMQkZ3dDVMaEtnVW1o?=
 =?utf-8?B?QmdYaGVXcER5a1M3c1pKNzdab1k5MStwcndKMUJFcXhVZThKeFNyeWRGL3RQ?=
 =?utf-8?B?SEpFR0dyS3RRMDVkS3o4NXpQTTg4YnhZTU1PTkJaVC9qdkZNeStDMUVCL1pC?=
 =?utf-8?B?dTRWSWNRTGNJU2tVSWp4U1hxVE0ySHhKRUtIYXZMSzA4YUlnd05YU3FxdGU2?=
 =?utf-8?B?QS91Z2ZHNWtDN3lOSlA5aERMaDFLUFU3QXlSMEpXbG9tR1J6cDd2d2VEZ0JJ?=
 =?utf-8?B?eE1JTUozaEZRS2pLSS9DdkxUNFpMQmduVERmQit2eERPTW5CVlJ5K2NCcWRa?=
 =?utf-8?B?aksyQkxscnEwWGRhQ1ArQmR0UDZ5dE5pTDJOdFh2YW5xSUh2bG8zQy9OTlZJ?=
 =?utf-8?B?L0tIa21mRHdySzd0ZVhMTDNyQ0hrbTRzWFBVd1Vsdzh3MWZvWXYwQk9EbTBo?=
 =?utf-8?B?b1RwcTcxQUxOV2pCdkZqQWJXQ1J5OWhtV2Q2RUdjZE1kQjR3SFBtWkIvUkY2?=
 =?utf-8?B?RDFLQW9pYnMzWjR5WGxKejMwQVJhdVBlMjJSYmlGQ1RuYmRoTVZwNTZLMkV6?=
 =?utf-8?B?N3pnazR2QnA1NXdyWU8xUnBBdjJEMXRHd3BwMG9XODRJa3NzWmR2SlZLZk5j?=
 =?utf-8?B?RXo4aXRFMTU0bElIRm0yUXRSaCtQSjhTTWljV3R6NWtEZGZQTlZkdzFabUtW?=
 =?utf-8?B?aXUzZ1BNN2xBSmpWWjIzc1dPQ3pMcncyOC9ybGhFdHlVcjY1ZDlnYjQzNUJv?=
 =?utf-8?B?RGZiRzVpZVFTclJ0OGpYSUppeVJjMUg1RDJjd1AyYWpxUTRQQlZJRHNla3RM?=
 =?utf-8?B?THJlTGhSVkp4Tmtia25YbnIxQkVZVnl5aFJ3SUdRSVJBQU1TVmRiQzJDa3FV?=
 =?utf-8?B?ZTdlSVREN1pMMWs3ZVk4bTVMYmw1TFk0aWVQVE5IN2N6WXdGTDJqa2pJVWRR?=
 =?utf-8?B?U0tTOHhWcUFhRi9IVklIK3Rqa1BWamsxc09zc055SWNIWEtvMWg1M3pTL1RW?=
 =?utf-8?B?b1RxK3kzODlyMGdKSGxtdUFTUkxMcFJvWFZUK0RCQ29lUVFCNE56WURiZ094?=
 =?utf-8?B?ajY4b0ZWQXQzbUUyRCtVSXE1MGJ2dk00bDVNcWhmVE05dGMwUXlYV0kvSjZy?=
 =?utf-8?B?R3VjRmF3eER2UUR0TXBqVDdPazBFSldBTkFGc1pDWXZzbWgxMHkvRW1lUnVD?=
 =?utf-8?B?b1lxY3FmY2w3eXN5bnNQd0lVZ0dudVBTeHdVOGR2OGhiSktzenREOVpmL0h5?=
 =?utf-8?B?N3UrZWh3Ym1IaEVxaVJQYlVwTVZieHJEUTJFUERlTjlkR2dKb01ISURJTDhw?=
 =?utf-8?B?ditjdjZOeGlNODZRZldiQk5LUXRlWVNhRXRiSHpTS29YM1ZIRk5icStlRjNl?=
 =?utf-8?B?VlBDZFZIcVVhTGkyZmh6Nnd5ZzE4RThSaVdGZDR0cStua0k3d2tqVGhWRGt3?=
 =?utf-8?B?VDE4RldyQXNtbWZnSElPKzAvNUVybVpzMXdNR1hTc1krVXlZdGpPazhORmtl?=
 =?utf-8?B?SzcxL2twWU96OWthVDhISzJzSnpua3c5WkhuM2NucjhFc0t1RjJ1WnVZcEtm?=
 =?utf-8?B?SXFmaEJVYmVsQndGclMvNEZ2bk40dkFUM1A4SVZJWjI3UVRYMHdsZy84MzhC?=
 =?utf-8?B?ZnJsaHNEWlZFa3hLSWQ2eWNGT0hFa3dsWjhwOFIyUm40dVpDQ3dlYkpOcHY4?=
 =?utf-8?B?N28rdnVSK1BHTzNxK1hoemY0Z3RNZjNFdHFiK1g2QTlQV0trSXo0YTBLcnZW?=
 =?utf-8?B?ZGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 732154de-4020-4e99-8b21-08de208a0c14
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 18:50:41.5865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hyMn37Gw1LGi/kO58Pwh4TlpTJ9n7pPVCR51mANi/Ju/qf5WRJ95R9sE82oBHXB0ZAlp+THpSQOV0Slwn1PTdR/3no56CMsraI23ktelkCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF0442004E1
X-OriginatorOrg: intel.com

On 11/10/2025 10:01 AM, Chang S. Bae wrote:
> 
> This series is based on the next branch of the KVM x86 tree [3] and is
> available at:
> 
>    git://github.com/intel/apx.git apx-kvm_rfc-v1
...
> base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c

I don't think it really matters at this point. But I just rebased on 
6.18-rc5 during last minutes.

