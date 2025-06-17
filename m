Return-Path: <kvm+bounces-49775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 218A7ADDF6F
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 01:11:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B057217E2A6
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 23:11:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3327E2F532C;
	Tue, 17 Jun 2025 23:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="flt5SUD8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D95296160;
	Tue, 17 Jun 2025 23:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750201857; cv=fail; b=ULd/7pPI1VzhxO99bFNvR5erPqnYOt7zBUlZonQjSXJn0Q733k28+Bomm+SUEMBYq4la4Jn5p161j6SefOsgLMgR2dgZbnS/O94Sthd6foUdEIpJfJfTXa5Bd3K1jGxau/wloe/C2KoQAnXSZA2yWVSmRm4GXREIbU/58WbJCfE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750201857; c=relaxed/simple;
	bh=74z04wP85DEutLMOXvKmHre5urbyCNTc+cksWug//ug=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BwlB3moF6rKpshlA/i9gixaq3xyDCiONTebTFO/gcTT+ygVT/o0SlEEYFAWauu/0fHQHNl6ICD3419+IYl51rRnHekj0GM1NLcaz5XBs4hYW0Ic0copzpUSqZU6gCb6JIwyJbNr6NSBLgXOmrQdsK5ClSnrDytBXePDorKYcTCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=flt5SUD8; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750201856; x=1781737856;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=74z04wP85DEutLMOXvKmHre5urbyCNTc+cksWug//ug=;
  b=flt5SUD87dfXtVMlBgW63GgkDJCD6NKXcJemoKNJ+dwuPAcTF1+vCoY8
   AUJDM+NmOBRWraMcb7xuQgtRPrHlv8G0VaRPkgaoWTcvFr7NmhSGSG9PP
   hjpstr1VyNseovsk2ZMj7iJH1A2q1sFvDgYD9qqq74UWvtQ5BF6LDza6p
   vyEI8o4eOFc0SnFnPxxHzv0DWdl3kKxjy1AyCaJiChWjHA4n0O1Rv/Ag5
   brb69FWpcO3ZBNn2LU0Wao36kFe9nJwzGhZDkMN/Dp6ip/WUd/SghmR6M
   CbdQtHGCvx2JqWSa7GjFqWOUPEBXmyNg0cvpTVBy5Y1FN923uCO2p8X1R
   w==;
X-CSE-ConnectionGUID: gOOckFXZRyeGue19qBTDUw==
X-CSE-MsgGUID: Jwl1QzzSSHucDfxsfuH6Ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="62676756"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="62676756"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 16:10:56 -0700
X-CSE-ConnectionGUID: eFBHhab3SUysObavOx3AVA==
X-CSE-MsgGUID: sbD6AXVHR+yIfXOs9Klwag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="148856257"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 16:10:55 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 16:10:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 16:10:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.67)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 16:10:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m/UkE05bkEqfoxs+6oXdjHP6OHgktif2LSiSjWTaCjMrfZm3zN7TgDzT7HSLjlDiZNcJF9/4p+nwq6tncilSSNerBtpfINHl6B35oazFXoJ3CxgwUY5H/FkmFcHelv+fEdXNsavgVok95nyf2Hk7qhvmKz7I+sUJOhROGgwZgLqD1x/DXQiojWYRFMd2wnoC2Wm6N7tSMZJrSqZ4/M2YEBafioQV1iJe/he1xhOjGG2a6nZ4mBUuFqC6AnOqt8qbc8T959nFcQsYUii0GGefoWXX73d6lPpg1Vlgwy0w/csQA+pmJR2q0IgKcGcqTTj0K/cSyYE6jyMi3cUubHyrOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRmfqi2D2vlBI18WqSudXByV/9UfrNtsHrpxmSlyPGQ=;
 b=q6K2xw9+J52/+RU+g8kO08717A4URkvJnLMsIGPiGPGpdfB1kyAVGZ/dmQTRqCTEm2NUj/xwd+JVgeT0u7dsWKKsFtu602NtiN0JyQoqyaUQO5U4gr1sXAW0yoinmvUj9kUJEaKH/Bu8HaakBFuNv+BvXfGyxSMAysKqOGbDX3pEjmphMk3bXKx7wjYhf3vg7zsdMpg80FbsbqmC7DB6cJ7RnPWpBQWeqMU+kASs40yr2Y/fluxkThYQ4IDEzPeoLLeiyCk3Jcz+qHE+4FwkcDrnN7m7d54a0gwY2vkZ3Nle5NucEapGf/9wEJgCD/lASqeJ5ZnzFX3x3Bwgii+LZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SJ0PR11MB7701.namprd11.prod.outlook.com (2603:10b6:a03:4e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 23:10:28 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 23:10:28 +0000
Message-ID: <276d66a1-dafe-4ed8-aefd-8f60e34ff575@intel.com>
Date: Tue, 17 Jun 2025 16:10:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<brgerst@gmail.com>, <tony.luck@intel.com>, <fenghuay@nvidia.com>
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-2-xin@zytor.com>
 <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com>
 <aFHUZh6koJyVi3p-@google.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aFHUZh6koJyVi3p-@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0357.namprd04.prod.outlook.com
 (2603:10b6:303:8a::32) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SJ0PR11MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 71c74e86-1d28-4853-3b7f-08ddadf42614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UGRCMHYwSWlMU1RYSHFrNEdkMUJHcFVNd2xmRzZWcEZ6K3NxbWtSUlk0SXdM?=
 =?utf-8?B?WURzZGJPcDdnV2MvZHhTbjB3ZThpMGgxTVRDVWFYMUUxdDJwN3dlanB0dktj?=
 =?utf-8?B?UmV2aGVMMWJ2M00rVWd2eXhEaVQ1a25OY0JXQ0ZqM3N5ZWM5UXA4NTNLZGxp?=
 =?utf-8?B?NWZzTjM3cEJQWlBDWGcyZlkzcExuWEZJTWdGekhLS1NQanpCWWVTYzBkY1R6?=
 =?utf-8?B?U3p3c3R1NkFQTURMLzZ2UWdibDlyK0FXMGpxOG90blBKcDhOVGsvTlhuMEhk?=
 =?utf-8?B?TlFabnFnMFlqN1dueHMvd0RHQUdyQnBjN0EyZ0dmMkliTXBmU3J6K245T3hF?=
 =?utf-8?B?S2dlUVRmWU1MdGw3MURqbWcwVWVLelRseGF1KzRUalliOWwyUE5JcTA1anJP?=
 =?utf-8?B?bmVIQUNOUkptVm85b21lSlQwRStTdnhHVU9HVkdCSkVjV0FQWjMyUTVzUFVU?=
 =?utf-8?B?b3FnR3AyM3pId2N3OElDeHhXWis4L1pRTldwbENSUGgxNVBUZm4rcGxkUFVX?=
 =?utf-8?B?cVlOeTdEemczWTFyTHZOOGR2OUVZeWJDeTZjU2kvVFdxaGVOWlNzeU44VGdw?=
 =?utf-8?B?ajhFOTZYNmJ0MlNtYnh6VlJnQ0UzUStXbGpHUTdRbGtGS3Q3TGF6M284emt6?=
 =?utf-8?B?OElLUGhNKzlvYmZvNGhJVnRrZkJacnpDUTRuSDdHVWhHTHI1SU5CUlhna0Q5?=
 =?utf-8?B?QlBlZTVIN2IrYUU5UjdpMjl4aEVQTktiTFdvdFZMTyt1UzlQY05wT1JWVmpF?=
 =?utf-8?B?WndDZ21OYWNHMC9EUDI3RW44dndSQmIwb3diQW91NmN4am5Yc3R5akNHVWlO?=
 =?utf-8?B?dzEyNTkzV3pUQ1AyRDBGZnd3YVIwUjgzMkgzTzlYYjhwdHE1QUg2K0ZnN3ZP?=
 =?utf-8?B?YVNhTll3MENGMUpFWTlMWUVMMExKcmhRcmowUW9Nay81dzhMUkZucCtqNTF2?=
 =?utf-8?B?STVTaVkxZXNNbi9NK0REQThsbzN5dFpYTmFGMmYzdWJQK0dUVXFQUXRGZ3or?=
 =?utf-8?B?VzZ0TGZ6dzNrUUE5UU43NFdUZ0RxMnFpYlk0WGltRTBTQmRIekpQbnZuMHN4?=
 =?utf-8?B?OWFCQWNEWWllckdlWElYNEZZSS9ybmh3Ulpwa0xWdUY4T0tET3dnME9wcnhV?=
 =?utf-8?B?bEs5UUhmZzgwU1FaeTlabzIzSXRrK0V6RWpaSzZqUFgxVlpyNDFBcXd4alhD?=
 =?utf-8?B?K3c1ZDVIL2hWajJXZ3Z4Y0F5MjFxZW5KQ251LzdlVkJVaDduVzV2RlY4WW1T?=
 =?utf-8?B?dnNzT01aUUtJNWNnR1QvRWNxRTNXQUNNWEJtczZDaEpjQVNFWVhzT1dzTzBJ?=
 =?utf-8?B?Yk51MjE5aTRERVczSVR0ajZMY0NLUnNVR2RwU0xSSEplc1NKYnFOWHNjaHhY?=
 =?utf-8?B?NW5tM0lBL3RKNVhJSjhOZS94dlk4ekhpOTBvK0pKUUZLcVJMRDVUSWc2YkxD?=
 =?utf-8?B?OGZrVnEwZFRRUkd1SUZlL2Y1UzZsUG8zNmVDZ3hoeFhjaHdnT0ZTMGh0WjRr?=
 =?utf-8?B?VGZIUElBZ291aXVvcHQwemNONUZwNjNFTm02aTZXdmgyaVVWdmpxY09MNnFG?=
 =?utf-8?B?QjdEUUhJYjE4Uk85LzhFZm1XZFMvU0ErdEpkSUNMUnpXMFVlYTlnWEhuMjFC?=
 =?utf-8?B?RTVKKzRZU1VGK1A2VzZvajBLdUs3NCtzQUpIR0hTRUx3OW1Sc0lWS201b2Iv?=
 =?utf-8?B?bDhSMk1qYnZ4T05xV3NBUkNOdXRGT29CQWd2VFFNQXU5NmgzK3lXVmV3TnRT?=
 =?utf-8?B?TXlURE5SVjd3UEdoSXg5ZVJCWTdnZFBiNlRvWFNyeHhRbTRrQ2hnMUZxQkNm?=
 =?utf-8?B?QWF3bTloRVNpcWIwQUlIc0dPdGxEM1F1eFU2V0RRenB6WEZ0SVNHdEVrRlJu?=
 =?utf-8?B?MGZENVZqUFZUZm1qRUwrcGZtTC9NM3R2dHRCYm5Dcjc0T0VoZ0Jmd0dQZ28z?=
 =?utf-8?Q?MoppOHTCPoU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3kvQ3B6KzI4WHBCV3hLYmZrUGgwQlRxZUEwbGMrR205SmZ6VTFCd1VrbWhp?=
 =?utf-8?B?NFVVeHZuOHAwSHF4dFp1ckZncnk3UUxIWDgyK3M1akxPYndnb1Ridyt3cjU2?=
 =?utf-8?B?UklrTy91ZmxQY1VXelRzcFA2Vkd0dTVUSHNkREZHRnk1T3JHbWlKUWNrMEFm?=
 =?utf-8?B?Mm43VzFmOVVoNXBkZ1FEaEU1TmQ2aHdwT2dBYU9yeWhSaDNMSXRFamN4S3M0?=
 =?utf-8?B?YzFjYUdaOHdvTHR1UEpRcG5EQ1pDWkFzN1JxZnVDdnhhelNPUjd1V0Q1dFBU?=
 =?utf-8?B?WUFDV2Y0ZnVnd0NVS09JOXJyajQwRVk4dHRUbUdJejY1dFd3SW1jSnhaTk5H?=
 =?utf-8?B?cWl6ZnBtdjhPeU9SRkFYYjc4MThZR1dJdkNFSnBJRjEvNW1RS3p1M1dVZFVO?=
 =?utf-8?B?NnBVcWR1dDlEQURoOENhU3BVdjRrRlNZUEVpQjhHTVBBTDdBNks2WlcrdTdT?=
 =?utf-8?B?VzNMQXV0amRDb2NPNjhoQlRDbnBhZHhZVUhGaWZOTkVETzZWUlN4UVRnQWh3?=
 =?utf-8?B?emhiazhYQkp4MkFRWmNGSnRnd2RBZGZPMXgwM09MOFB6b3NVTzAxNXVHRUMw?=
 =?utf-8?B?SUxKVVA5RFNMRWtsZnB6dFpHbEc4RHdONGhTdHJlejVLeUpXcVRwR3diajJE?=
 =?utf-8?B?YWJKNCtaakQ1NnZ4SkhwRDZDMXVyR3BvSUtLR2cwL1I3dFZrUUFuV1dleldT?=
 =?utf-8?B?OVo4QlM2T2lEc2RNZHAzRzJzTUVaaGxvYmFXQmt5cHVjbVlGejRsMkM3WkpK?=
 =?utf-8?B?a2hwNFNXRGVuZjlJaStMNERsb1hYOWNLeC9mVFNBMFQ4UXRZTHpVK2NaU0wx?=
 =?utf-8?B?Z3VXdXFQSThjR1lYQ0I1OU1aUWl2dzR4b1IrWFdQa2RXYzNwNkxjQ3RYQ2pZ?=
 =?utf-8?B?dDM5SVZsWGlSK0lSOUc0ekhkaE1mZHZzWitWdmRqc2FrYkRIR3VSZENRQUpz?=
 =?utf-8?B?UE1RbU5mbnpGeE13WnBHWklVSGNVTUYzcHJsSW5EQTJSNDR5K0J0dzBraXBa?=
 =?utf-8?B?QVROZmRuOG9WSVNGbTBKd2wxVDVram9KZ21TWDF6aG5JOER5bVNFbXFTZjZv?=
 =?utf-8?B?OFBVUEpxdjY2U1F3dTN4eTBtSUdGNXZqRGxtaHhaRVd4NVRuZFgvM3BiUERD?=
 =?utf-8?B?V2poOWt2eVlIL010d3c1Sk5STXBydXpUK29DREMvSk1uSUhDWHplTzgrVHFp?=
 =?utf-8?B?WTFVZUtpWDBqTjJNWkJtZkdHanpTVm9scFFzTFV3MUlTdW9kZ1RvY0Zwb3g2?=
 =?utf-8?B?azFtU1RhVkdOaEJDMTg1Y053NGRCU2dKNTg0cTZnL3dCaHUyVytPR0tNaGxV?=
 =?utf-8?B?LzY3SVROaXJMZTZ3ejFxYXZmY1orWERja0FiMjJTaXlGNnlsOGRDUjFaRG1T?=
 =?utf-8?B?aE1DY0FjMjNNNy9lMlM1OWNlMHB2d1VtT1lTbDlQYnhtTHN6dE9DK0taU2to?=
 =?utf-8?B?OUJTaVRoaE1Ga0x5SHo0bGpBWjNpU0h0dXZ2KzhPSTJaR1hUcDltcExzV1lU?=
 =?utf-8?B?N2l1blVGemhRK2tmQ1pBc1NtMEZwc2JkSDVIclNFeU5KZmZlRHhod3IyWnRl?=
 =?utf-8?B?M2pzelVEZVlBZmNpMjc1U3JBM09ZZHhtSzE3VGN0aU1aZzJwZ2doRTZpNFU3?=
 =?utf-8?B?ZTB4UjhzRVU2Qi9MRCsyL29rSWZOdmVYNERSWGdZbzlTLzJFcFpCQ2ZzZ0Uw?=
 =?utf-8?B?bnVsZjd4aDBwZ3kxR0xlckJ6MDdzdStSdzVjaTRmSlN0N2JudEh1bE5xSHl4?=
 =?utf-8?B?cEk1NTlaa0M2MnE5c3VKaHdqa3lpT0lDRkdjc3h6ZndtQitkZ2trNUFvQnFy?=
 =?utf-8?B?L1VqR1A0M1RScWJHZURUTlFXTUVwRW9MVTFrWDdEUUJ2aWloeDY5d0krSjFI?=
 =?utf-8?B?VHdGdGVSOHU4ZTNNc1BQNUFwQVpXb1BmZXVYUlI5Q0Jya2NPaGduZ2xKN1ov?=
 =?utf-8?B?R2RVcWJhTWlkS2tJcFVkMVlmL1hUbDJMaFlpRmljTlJhNWxwaGo3eXZaaEZY?=
 =?utf-8?B?UWdXcVVJcm5mU0tub1BwaE8rNmh6cXYrOWJ6M1FXRU8xNndVZnJrV2JxVnpE?=
 =?utf-8?B?Y3NBaDBuSytsVnF3UWtwN1NmYzZsTDlIajRVbEFaYU1xU1pzbG9ZVjFiM0Z5?=
 =?utf-8?Q?6KyfNR4Rcr92I8dmLB26kboWX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c74e86-1d28-4853-3b7f-08ddadf42614
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 23:10:28.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SIN8RR98eUzbOd23Pouj/yDok5aVZG1CRpJnKk+o9VdPc1I6j0rz54Ents9SvQG87mpQjp1fmFd1ECD9A6fCiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB7701
X-OriginatorOrg: intel.com

On 6/17/2025 1:47 PM, Sean Christopherson wrote:

> Ah, and now I see that DR6_RESERVED is an existing #define in a uAPI header (Xin
> said there were a few, but I somehow missed them earlier).  Maybe just leave that
> thing alone, but update the comment to state that it's a historical wart?  And
> then put DR6_ACTIVE_LOW and other macros in arch/x86/include/asm/debugreg.h?
> 

Yeah, that's unfortunate. Updating the comment seems the best we do for now.

> /*
>  * DR6_ACTIVE_LOW combines fixed-1 and active-low bits.
>  * We can regard all the bits in DR6_FIXED_1 as active_low bits;
>  * they will never be 0 for now, but when they are defined
>  * in the future it will require no code change.
>  *
>  * DR6_ACTIVE_LOW is also used as the init/reset value for DR6.
>  */
> #define DR6_ACTIVE_LOW	0xffff0ff0
> #define DR6_VOLATILE	0x0001e80f
> #define DR6_FIXED_1	(DR6_ACTIVE_LOW & ~DR6_VOLATILE)


