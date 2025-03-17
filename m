Return-Path: <kvm+bounces-41159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7627CA63DF8
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 05:12:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C43E188F9C6
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 04:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2375214A9A;
	Mon, 17 Mar 2025 04:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fzS38Fb9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A961136337
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 04:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742184733; cv=fail; b=QeddzExQt32QBzOfGdjPHalaO6ndfDVAClCAA5OTQSMVdAObOR6XdhFj3rIUw6cYHHUXXbC7NOXFOkHrss0nRpkvl6LxMoLCsNx/0fU+FAays1vyI4TB3AznONczhLTgf5zLIZUfxktKGPK+Fx5GlSSi5RhjIpA2D2PhYEPBaz8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742184733; c=relaxed/simple;
	bh=5cv2/oXTHIQVke5qDg2rAfECy9X522hQD+PRy+kT+XA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YPrenFCb2N2h+0iO3qbEkQqkoiV78mQK3eZOBtduZ/GBZE7BhcLvlGNUgqgz7DHlIn95lZXRCHOFAIw4HZWfJTUgrKm8cLEGH0FyI125nF9i+uYLDphRQpgsE8x4LrsXomMR7C0KJDmK9jOTbQKoK+cCN5xO3GT0tfVlhZf0h4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fzS38Fb9; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742184731; x=1773720731;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5cv2/oXTHIQVke5qDg2rAfECy9X522hQD+PRy+kT+XA=;
  b=fzS38Fb98G0rUsUOO1REth8F7jLyovYgi8OeOC4LUfggrxOOpYyeu41E
   vwaa9KMqMKE1+VcjqklQIyFP7/dH68gaWKe5tdiR+323BRVxNy4VqN5OX
   kj+eKXkdgt6SfPBCriYjX+L8qLeY69XHncUUoVPwiwzA6C8ScBYQZNQlo
   9zrKxKGMIFWhkWCo5E1SnvfoICktnFM9DDwYW5kLLVXu39iDlpg/Hy9Px
   Bo5bZpmz2GaRpQINIXJMQeprtkZTBCP5HIn6TtpYjvHSbZhnHdXgoaywX
   v3r8tAZMTIl4jffORyn8GuQgA/CRp61kXZUDyCTf/1M0uy4pxKgNJkfY9
   Q==;
X-CSE-ConnectionGUID: DV0k6Bj1RQKkWu0E8A/g+g==
X-CSE-MsgGUID: QzdAITU3RG+vvMT2cxKsyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11375"; a="43134761"
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="43134761"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2025 21:12:09 -0700
X-CSE-ConnectionGUID: etFK5nZUS02K5lRl+yr00A==
X-CSE-MsgGUID: OQTQnfdnQeO6AvXAHY5POQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,253,1736841600"; 
   d="scan'208";a="126008932"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Mar 2025 21:12:08 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 16 Mar 2025 21:12:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 16 Mar 2025 21:12:08 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 16 Mar 2025 21:12:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWn+fIPU2ZmpIS9RSDlMkMWSHZD4HJ3Vo/J34O7Fp1wLG/4BK7T8HDyAmhfSHuEhlyNPb09Ts4xvS2gdzAfiAzjSpeqANsuuis2SSDzbOHUNglTk6z+j9/0ca6GeWrUysTfGFRFC7gXaQh2D4VzfCA57ou5tC3akB3R8HZ8Hl7CsaEmAAf5M/Ebb1mTMVHCKRiaHzPWxDgwtWN17cdInEm5pbq7ykxlxQIKlemCVIck+jMcTZQ9o+sjUdCtuorQDBe6GZ7Hjf+M8gwPmVJoC2oQZ+85RaIl37rIiu+pCGx1c7a93Z4zca5oUqXMXxZl+BLMLG7iupIlGcFa6KzK3KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hmsp9FJymewRVd7MjNj16ifyx130I5ZDhk1Fi/GqnU=;
 b=pgtHN7/mAyojfJPDCoVHT5qrBh8KbYZmFTxBFpIpxoxB77aRbwTglQmM9ZU3vWEh1B1gH7ifLxVGm4fYL1oPFBTRufTcgCgAKMkuUsEGTEbobPD6LD17kNAzi4nTDVHSpSHDm4veE11Kw7jI3LYQDmzEwbGczUzQ0qRAWKF8wVK0mzkCYTXNJxGSfLMwWBIb/y1/iVhd3Oyt1aZZkO97YXCoe0fNWnxgTh3J9NrdnbsVVyTWgFEjAgxH/bo+hE7LKnnkXt9xrnYg0jdfTnpc8UIjkj3dZvNRQN8BcIXA7OCn4dg2SlR0oXrU71Rgn3JId+MEP3sZ/t4JtZv9TSCV0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 IA1PR11MB8831.namprd11.prod.outlook.com (2603:10b6:208:597::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Mon, 17 Mar
 2025 04:12:06 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8534.031; Mon, 17 Mar 2025
 04:12:05 +0000
Message-ID: <683c844a-e260-424b-b55f-46eec06f355a@intel.com>
Date: Mon, 17 Mar 2025 12:11:56 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/7] memory: Unify the definiton of ReplayRamPopulate()
 and ReplayRamDiscard()
To: Kishen Maloor <kishen.maloor@intel.com>, David Hildenbrand
	<david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>, Peter Xu
	<peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>, Michael Roth
	<michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>, Li Xiaoyao
	<xiaoyao.li@intel.com>
References: <20250310081837.13123-1-chenyi.qiang@intel.com>
 <20250310081837.13123-4-chenyi.qiang@intel.com>
 <a5fa4844-e4c3-4d7b-a08c-ed0ce77d9028@intel.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <a5fa4844-e4c3-4d7b-a08c-ed0ce77d9028@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|IA1PR11MB8831:EE_
X-MS-Office365-Filtering-Correlation-Id: 725b4346-542e-45aa-1f5e-08dd6509e048
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d2hDdVJBaE1PVjVwc2tJQThHVGFRMUpqc3ZnT0N1MzRmMkpmMnJDbDFJQkxR?=
 =?utf-8?B?MjRvRnRNVmE3TlZrNHFzRjgrYUZOdGxYZ3lIRXR1SitGRC83ZUx1eWNxdSt2?=
 =?utf-8?B?cWZHTE5jMkMxOGhVczNEaG1Jdnp0WHo2bStGc2NNTFFkaEdZbzkza2xMYzQy?=
 =?utf-8?B?ekJLS3JFemtxNnlQL2t6bU9JMEhzT0NvNmlaSTBxa2kyMWhKVzNUbXJjKzFo?=
 =?utf-8?B?WmtlblVFVFRaYzhYRDAzUW92a2Y2czhJQzg5ZXY0bmhSd3NDejJPeWxBMjlI?=
 =?utf-8?B?WDZXMmgyVHFodlJUV1pXb2g3alFZKzNGakYrUUhoM2o3WVcyaVFnbytxZ05a?=
 =?utf-8?B?clo0S0NqejlSSGtTNGlFYldDc3MyMnJYWm9qOVhDL3pQanBQSGZ5QVRqeTBC?=
 =?utf-8?B?ZXZudEU4RCtWdXRYSEI1bE9RZ01kNjVqMWJGc29EQXhOQmpCZldrUFAyZFcy?=
 =?utf-8?B?NlJxdVpJK3N0V3Y3NVFnN2VNdEd1NkRua2VlbGVPSDM3NEpkOGlRT1RqOTg1?=
 =?utf-8?B?QzRHT2JjM0VCYVJrZ0ZpbFRiRFpJc2xlZXNZRnJyK1JXd2E5VU8rREh2c2xJ?=
 =?utf-8?B?SDNhTms2VzdIODFlOVVaa2ZPOE1nLzdUYWthSjlOdTNVaEVhL0xJR004aVRx?=
 =?utf-8?B?c1JJTWhRNkdCbS9EMFl4aHpzV0xleGs0aHVFWUV3dU40MzRzaU5BaWQ3d09D?=
 =?utf-8?B?ckFrWnZ2MmVaSGxLQmdtYWNLZ2ovK1BLbjZNTjhWTno1TTVpYURYUzlBRjhO?=
 =?utf-8?B?TW9QMk01Z0lOK2NKQmY3eFRIR0lSMmpHK2IyNVYxTDBRbjFJZm5WWk5NQk1l?=
 =?utf-8?B?Uy96WDdYMjR0M2hiWE1JeTBrT00wV1g1Mi9FdkJNRWs1OTBoV1NyYnhSYWJy?=
 =?utf-8?B?R01oRURabzkyaVY1UitOa3VuLzhsckpBRldnM05xekt5VkVDdVpQT0liY0VP?=
 =?utf-8?B?R0VzUUdaL1EwSWZjM2ZRWUhGWmhkbmN5TmgwY3dzMHFnR1plUjR1b1hjbFVC?=
 =?utf-8?B?QUNNeFhlcnQxaDE0WVhlNUJUdk9mTk0wNFE3NU84RXhWVDNKNDJCWC9sRHJC?=
 =?utf-8?B?dHJwQXIyb3hBK1ZFY2I5ZVZyTmE3ejlmNFdPVzNvY3ZNdjNHYUNlbVNVOURq?=
 =?utf-8?B?OGdVWElya2VGWFlSSVQ0VndZNXR1aXQ3WWlmOGlGZ2RSa1lmVmFyR3UrcnBZ?=
 =?utf-8?B?TjcwRHhJSHMzSnlZTU0wVHJiMjV3T0ZxVHJiNXJMNlg1dnV6cmpJTS9mc2Q2?=
 =?utf-8?B?M1VtZ2J3V1doZzVvVjRTV1YrYmVCQm1wUUNqYXhydHNBNE02RTZEMmtsVURv?=
 =?utf-8?B?UkJyL29uV1hZajRLVHpnN090OGRvWEhSamh2YTlIWjdsTmY4ekFxMDUyS0gr?=
 =?utf-8?B?UlNsWndmT0FzMnRTTG9MY3dlc1R6czQ5WnNGa3g4MnZVdDB4ZlhJUWI1WjRQ?=
 =?utf-8?B?RmZYSmk3VEM0NTBheFJ2M2N6VXQwT05CSXFjYjczNGQyOHlWMnVlSXJ2WkxH?=
 =?utf-8?B?alVBTUo0emFQby9rT2Nsc1p3dmE2VzV2SFJRUExVNlk4R1AxeHZhWmFnbDF1?=
 =?utf-8?B?blh4bkNVYXoxdGNUeXhJY3dSQ1orOER0T0tlZ3lOdVBRbEZuRW5DQmZXcUht?=
 =?utf-8?B?b1pZUENJdkdUeXYvbGhyQU5UYXAvNkRhQ1E0N3hST01SQVBsdGpOQzRGVzNC?=
 =?utf-8?B?TVNXdlVGU1pJcDh6V25ZWktHZzY2ank0c3h4dE5OWDhyY3psNmk5RmJBVTFa?=
 =?utf-8?B?K0RwOUE0UUZUYlVnY1dmV2xOOENCTjNoMFByZVdaYUdueEZIZ253NXBBelRk?=
 =?utf-8?B?endYSlBuZkc5eTZURnYwNnFiVGh5aldIMnJmVXV5TXgrVXdyd0RQdzFPaGlv?=
 =?utf-8?Q?qWiu9Q5Z7aLHn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGFLUXZyREljTndEUGliVmc4amdDcUEyUXpyNGpidmhOYkQ3R3VPd1lNN2lh?=
 =?utf-8?B?S0E2MGdnLzNNV0swcjdEZ0FqMUh0alR4OFhsVWxYODRoMlFLOE1xSU5EUjRl?=
 =?utf-8?B?WWdiUnRxQ1VSbmhZOFhJanpxUEpxSk0vNzUzUTk3VlpoVFhXMXpISHlINExz?=
 =?utf-8?B?bXoyQkYyblNPMHhpTW8zb3FvazVGNG96c2xXbDVFQ3JCOXMwZ0lpcWQxSEc4?=
 =?utf-8?B?UXY1N3ZjNUZwWldoamxiRHhjVU11OGVhZkhHSlNEcjBIcmxvUVVwRmFuOE9x?=
 =?utf-8?B?WEliQmdteCtmemFxNXd1R2E3OFlldEh3VXhBRm5HeEV5cmZwVGVqSk5McnJa?=
 =?utf-8?B?NTRIYkFzUjdkZE54ODcrWUZaU1hzejlYVm5jVGY4TUdGMGRJV3E0N1ArdDVV?=
 =?utf-8?B?MEN2K1Z5Wkh3b1ZWaXVIV1hPQkFDZEdqaXY4UTJqait5ZDUrQ2xCVXp6WGt5?=
 =?utf-8?B?cDAxcnZqQUhwS1dabWQ5ZlI5ZFlFdXFyRjBISjNmNHpqVDVueGJ3SXV2Wmh5?=
 =?utf-8?B?cHRPbG1SdDhDT2xhaElBdDdiaU5Za0JFNlBCNHY1ODhmSitKcjExSEZmbTFE?=
 =?utf-8?B?OU1RTTljWDZuSmN1NTFlTk1QK243VzdUdVE2NmpzTy9EK1ZqRkFYOFhCajcx?=
 =?utf-8?B?RUpHcnRaQ1JzaTNjNUU2OVRDTGIwR3diK3lUOTdjK0NnMnRjbnZMbVZzNUtz?=
 =?utf-8?B?VGVjeWNBK0tjOEtpSStwR3BkT0dFVjgybytiTVk4VEZhYVN1ZlJibEw1Qlc2?=
 =?utf-8?B?RnBwd0NiaVI2UksxbFhRVm5pS2k1TzdTWUMvbWY0S2taOU92dHlISXZ0cE1H?=
 =?utf-8?B?NU85b3UzNXRkc2F5WkhGQ21zaDNBWEMvd1pOdzhTc1JaczhQdG91ZGp1OVdB?=
 =?utf-8?B?cUtSbFRzWWJQK3lPdUNNYkV2Q29NOGdZK0k4OGN6VlBOMHFNNm0xcXAveW5t?=
 =?utf-8?B?WWdhbkp1c3p5VkxJT3M1WVVyYnVhc3I2aW93dXVNbVpZai9zTVpvRXhQRkFh?=
 =?utf-8?B?NG9NZklyRVBYdFlrNWhBR1BBWHVPazZNOFd3YkZYVC9sZEFvZ0cvYmVQdzY4?=
 =?utf-8?B?Y2RsbXUxbFRDdVdNMlo0SEFCbXEySEdaWWlUK3dxSkFNcVpyMGtCNUVpTDBs?=
 =?utf-8?B?eWZURkNJUWhYU09Pdjllbm9vRzNvRVR3WEJiREphZVBlZHljL1hyeXUwanNV?=
 =?utf-8?B?SkRTOSs4Y2RCczZ3QWhpVldzVVEzRjVGakZwNHlrTXovRUdkazJUL3lSMFBK?=
 =?utf-8?B?RkEycGF4RmRwczZ5ZjVxUG11dTdiNVRkcmNyRUxQV3NmdElNK01zaWtPUmp6?=
 =?utf-8?B?WVFOeW40djVRUngxU1pRU0twSGp3VzgxQjBLbjFmbUJocXlOa0I1VjNaell6?=
 =?utf-8?B?eEdzVXUxY3VTTU4wTUp1ZU50SVVtK2NvR1VRQWV6M1VFak9ORURBRUtMMTVM?=
 =?utf-8?B?N1h4M3RpL0xIQnBWNmQ2RXJYVkx6My9aZDF1T1AvZU5Zd2oweWE0ZzRHL0lU?=
 =?utf-8?B?SGJvU296N3ZQSDhiOFRpLzB3MUJYeFphdjB4eWtKazQwaFJXUllzVU16eVZL?=
 =?utf-8?B?RnhGNFR2MXBtYWtTbHhVNHJUWDJRNTA4OStCQ3p1d3hsQ0JrMHh5UEc3TCtP?=
 =?utf-8?B?V2xTMHE2ajA3bGl4Wm9FTTVkTnFyVDFvc3ZoMTdTTWhZRUdRVDdCUlVuMVR5?=
 =?utf-8?B?dVZ2Qmd3dTlRRitnMlFUT2NacFBlcWVTUXpTYWd2blE4Zy9BK25UYTZBVEQz?=
 =?utf-8?B?V01Za3k2MnJxQThUa29VL0tZejkxeW84NGhxNGxPSW9PUXBXdlRhWFFnSUZC?=
 =?utf-8?B?dzBERnZHeEJEa2RtNnZXZlJTNEZRRnR4QUVUV0JiTXJOWER3RzhjUjBaVGtp?=
 =?utf-8?B?cHd4RFdOeUo3VCttNndCT1J1N3lSNkdxZ0IraG9nd0NVbHFKZlBFZzJpV3JV?=
 =?utf-8?B?c2V5djJxaWFtUm9JSFYyZXNZdUY2VVl5QkFHcm83cUUwbHZhZXBOd1JUd0hP?=
 =?utf-8?B?WmF2UVpOK2M4ak9nNGpSbFRUZDM3L1dzTEZlZVdrU1Ztbjc1TzZEdjQ3Tnda?=
 =?utf-8?B?ZXZmeTRDcFZJRWxjOUwxUGlJUmtCcUs5U0U1STFrckN0MjljMFdUZEpPWThK?=
 =?utf-8?B?MnZ1Q3hydjZha1VpdmZuQlArU0RJTUk0TWtYWlowalpHaEVHc0lNT1IxcW9W?=
 =?utf-8?B?bVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 725b4346-542e-45aa-1f5e-08dd6509e048
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2025 04:12:05.1808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wtuD9sVV+att6KPVWz7BdhZF7sL4bSq/NrWKLY/tW7iWakhNzEBQvedWgCYA2/9o4iLuofhpgcIAGddfcZRapQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8831
X-OriginatorOrg: intel.com



On 3/17/2025 11:00 AM, Kishen Maloor wrote:
> On 3/10/25 1:18 AM, Chenyi Qiang wrote:
>> ...
>> diff --git a/migration/ram.c b/migration/ram.c
>> index ce28328141..053730367b 100644
>> --- a/migration/ram.c
>> +++ b/migration/ram.c
>> @@ -816,8 +816,8 @@ static inline bool
>> migration_bitmap_clear_dirty(RAMState *rs,
>>       return ret;
>>   }
>>   -static void dirty_bitmap_clear_section(MemoryRegionSection *section,
>> -                                       void *opaque)
>> +static int dirty_bitmap_clear_section(MemoryRegionSection *section,
>> +                                      void *opaque)
>>   {
>>       const hwaddr offset = section->offset_within_region;
>>       const hwaddr size = int128_get64(section->size);
>> @@ -836,6 +836,7 @@ static void
>> dirty_bitmap_clear_section(MemoryRegionSection *section,
>>       }
>>       *cleared_bits += bitmap_count_one_with_offset(rb->bmap, start,
>> npages);
>>       bitmap_clear(rb->bmap, start, npages);
> 
> It appears that the ram_discard_manager_replay_discarded() path would
> clear all private pages
> from the dirty bitmap over here, and thus break migration.

Exactly, but migration for confidential VM support with guest_memfd is
not supported yet.

> 
> Perhaps the MemoryAttributeManager should be excluded from this flow,
> something like below?

I think it would already fail before reaching this path if initiating
confidential VMs migration. But adding such check or assert for some
hints is also OK for me. No strong preference.

> 
> @@ -910,6 +909,9 @@ static uint64_t
> ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
>              .size = int128_make64(qemu_ram_get_used_length(rb)),
>          };
>  
> +        if (object_dynamic_cast(OBJECT(rdm),
> TYPE_MEMORY_ATTRIBUTE_MANAGER))
> +            return 0;
> +
>          ram_discard_manager_replay_discarded(rdm, &section,
>                                               dirty_bitmap_clear_section,
>                                               &cleared_bits);
> 


