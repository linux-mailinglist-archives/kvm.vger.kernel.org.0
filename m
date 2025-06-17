Return-Path: <kvm+bounces-49751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A619ADDB46
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:24:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 769207A667D
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 18:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D870823B610;
	Tue, 17 Jun 2025 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DCEGDvPY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667B82EBB80;
	Tue, 17 Jun 2025 18:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750184656; cv=fail; b=A32jqW0bDp2Ur6QN45Q2AEV/pe4Q9MfdMjeZO3qY+dtbq9LWvtOwZ6yEudr+Y06brO2ZZ+3DDnh0hRZKGciXC+nNcIoS7p5OJwAEt5CvR/KTV0mwKPsu60IMQu1gTh2cKwEjq9T3hNF4DLWs3lKtVRRIHtpGnv2gF6apwgnen5o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750184656; c=relaxed/simple;
	bh=3jUutbxoF5hrab6ZxYIJOVQcKP0QizKhVXQEVIepbvA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JwNV+WhpJvt4wAITTJPilm2ijA9gt2W+0xfEM9vx3TNvp4HooDy8l8Xl6/2mQ2J4W0MzaQ+WZXInxxXRV8CWi/JF5jWZEqnRG/d9cjqIB+xFvNsjvJ8T/pY1y3w6Er7FFGhtbOARCkXqGMyZYKD8vG7Jf9pwf5Tgq4vEpoitXTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DCEGDvPY; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750184654; x=1781720654;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3jUutbxoF5hrab6ZxYIJOVQcKP0QizKhVXQEVIepbvA=;
  b=DCEGDvPYMc2/NouIJqOi3Nl/NHgO+K8Vlz/Lolqb3AU4x3DEBMZ7g10q
   fvGLpdnm2P9FbxzOidLN7690ZstkAZFOmjui0i2qeKKjo7HAQdi3wAgd9
   5wIE7AttJxVyadeIN7Ig2mpisHKcufPcUrL7sU/+Jo+vmydPV/0JFgUZp
   jcs1g1t9+p1dK2gicMoP7jRAUko9Ohg5kvxAaEjyiXXUjPPNVKd1+IePO
   04hlmJmhnnQjDeIIkcckCCSdBfQpl++a9PHZoQvzTwhSUOdIfDWi5LdWH
   yDLMsh7h3AbCulmaJJAb54QxKgqjw47AOJ+uPXaDDQISWjtt3x7budXLn
   Q==;
X-CSE-ConnectionGUID: FDsIgrqtTRG5FFj8oG+Pxw==
X-CSE-MsgGUID: 8krXgv4SRCmL+FMBcSsPnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52356792"
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="52356792"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 11:24:13 -0700
X-CSE-ConnectionGUID: KFE6tcPNT4KyUfzHIjO6Bw==
X-CSE-MsgGUID: toD6dDpZR2e+GHS08nrpew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,244,1744095600"; 
   d="scan'208";a="154186170"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 11:24:12 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 11:24:11 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 11:24:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.57)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 11:24:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hDVdnmxLGS041MUB0ywLZNouP31y41HxOUdAaK9nP629vA4eG1NVKSXeib3J/0sprPFjh7nJsJUv8nRTKnHtTzY/bLMddIr6n2HfcQi8cey5cgcNcjnMNkS9IPFvyIMGIPj39CV8ItsYvG6iRkxf/qeVeIYiefX7Z3wQNQoJbhfMK581n8c3C7TLhS4PXn1d3UZoYCBeKt8S90w/Xgo8/aUQV6W/yx9ES05m33oAGuqdFOCc/8bhO7deHXf1aFsRJ84nK5y2lhS21aqSP9LcP3OG6cG9ZDhS+Suxj8uyeq9Yu9A7D1HaAZFraSAiCVRzu6/MvOBPNUUql+cFYmriNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Svr4+v6ltZ93HsNSrBJkbIKbnYXBB4c4zq1FKOv7jmw=;
 b=gc8Msq8fdLrnuqLTyIp0HBQupvZFMQ7S6hSc9yGoYJANhKMlDGB2QqF39iYQ2bmVma2/3MpaEMpP/cGiFYViTEWsnzmPv1ofgwSoU4kcy3Ir9j/wBxYrdZF/c6eBr0Mw27m9aSTKGHCvOQ9cisFOgQpvHWcWYlbp3Q5kEJnXEQV9+SIbKXChDmWFpW9r4NGqM0SzhwL4bu2GHX3HJ8kkpKH0OfyTVF/NJcHlpQCDR9KUjwxHclsX6NClNEw9cMbeesgGSkD+JtQRa3wx8Y/UY+Bp4yb/VPJO9Xh1F6v220nDlGX7wxNoVvYk2lmT5WuNridQ4ShciDrPrXVEjJdKkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by SJ2PR11MB7670.namprd11.prod.outlook.com (2603:10b6:a03:4c3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Tue, 17 Jun
 2025 18:24:08 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 18:24:08 +0000
Message-ID: <fa32b6e9-b087-495a-acf1-a28cfed7e28a@intel.com>
Date: Tue, 17 Jun 2025 11:23:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
Content-Language: en-US
To: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<brgerst@gmail.com>, <tony.luck@intel.com>, <fenghuay@nvidia.com>
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-2-xin@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250617073234.1020644-2-xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0061.namprd03.prod.outlook.com
 (2603:10b6:303:b6::6) To BL0PR11MB3315.namprd11.prod.outlook.com
 (2603:10b6:208:6c::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|SJ2PR11MB7670:EE_
X-MS-Office365-Filtering-Correlation-Id: 6175bed4-561b-459e-42b0-08ddadcc2548
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Rm5va3ZQTXF2UmJkNFphditZYUgzWVdmOXJOcmVDUWJCU2RQSTBuaTNSMmQr?=
 =?utf-8?B?ZndVNWJjaWdXS3EwY0EvWkZpN1BPUmNVOGY2dW1QWXB6S0tGNFlFcnp0UVBC?=
 =?utf-8?B?WmNLRzVyTGxQNUE4SGZuaVNyWGxUbjY3L0FJQUpUdmFKUFR4RGhOSVA1aWZl?=
 =?utf-8?B?bndmUEUwbHd4cWsrRHV4S0ZuajhKMmdHTEQvTm85dU5TK1F6S2ZHZmdyaFpD?=
 =?utf-8?B?R0lqcGFwNmhleEhBSHQzSzNLODRVMER2R0lOelJLcGFHVG1EYnlETnpYczJm?=
 =?utf-8?B?RkV1ZG52bHFodE1nS3F3L0FQTjljbkpKMVA4QVpLN3lWalFmZFVMdjMyZWk3?=
 =?utf-8?B?dzUrYVVMd0wzcUtpQkF0MU54N0NLWmp6T1ZQTmViR1VJVHZ6VmJBRFU3YTNF?=
 =?utf-8?B?ZHE1djRzN2l4cmR2QlBiMmNTQlNjMTRvT1ZEQ0FoVHprVTREd1U3eER1RHlF?=
 =?utf-8?B?UVYxbVJ5dTdPeFQzS3NtaG5YSkpQcy9sNnBZK0xzK1VmQzgyTmhSKytqZEJ4?=
 =?utf-8?B?Q3dic0UxMk1vdk4wRWlIbW0zSjVEaHFMdFRwUVBQekJ1SDhSQmRiWEM4SmJK?=
 =?utf-8?B?UlBkcWRyYTArNS85VG1HTGg3TDhvbzB3eFAzU0NPTGg0by9rM2ZOSFprdEpJ?=
 =?utf-8?B?SHNvZ04vK0h1anVjN2NzQ1FZbUtsVWNCTWs0bU4weWM4cjE2RU9qd012M0Zx?=
 =?utf-8?B?WVQ5ODhha3BNcHdIODBDL0VXWFM3S1Juc21QSmxmTW9PdFNaNUZtS29KWHhn?=
 =?utf-8?B?cG1lUFJ4TVhlVjJoMDlELzU3bzBYTmkyS2pSMmphMWlCOVhGcmRGWUxmVUhS?=
 =?utf-8?B?am9kRVV5WHBBRnpMWVdkY1FFb0xVNHgxclhZUjVsM24wdGlIbnU5MTlxYUVm?=
 =?utf-8?B?YVFodUFYaTh1dVJuTjJ3OWJQZjBYREM2MGZ4UzJKNHJyVSszenc1QWFrOGNj?=
 =?utf-8?B?QVNUK2Iwb3Jyc1hmS3pSb3dMSWFpL1BYc0MwOWs2aUxjcUpCWE1aNlhEWkpk?=
 =?utf-8?B?V1Y1bG5CUVFJUlU0MktqU25oV2I2VEJWY3RabmFGT3hFVDA2OGFoM3dYZng5?=
 =?utf-8?B?ZHJqbHM5RVBBb2lyOFRiMEJ1TXloYXRCUGxJdlVkRUMySVZxcUVHQ3JaWGFV?=
 =?utf-8?B?QTViZmI5WXZTRGpDa3hGd29rTlZHcXNmR1JYRmZiR2dtMmkvUktuVHVpTUJP?=
 =?utf-8?B?cmxHYkIwbWRCMGtBc0hKR1RVN0VWRTRUN3dmT05aVlV1NkkyMTBQdUdZLzdR?=
 =?utf-8?B?M2pBejA2NHZWZ1ZWci9GVVpySDg3TTY5N0NKOUh4VTFPcXZxSGtNS3hORTFC?=
 =?utf-8?B?ejVWcEtwWjkvT25IZFl6b1QxbU03NW5GVnQzVWJ0S0kzL2daMlFRSHprbTBT?=
 =?utf-8?B?dnpiV1dycFBNY1I1cER3Mmo0WFRBTjcySmJEcSs5cGhqc3R3RVZXcTg3T3Jh?=
 =?utf-8?B?RVA0MTJqaU5NSENxT3F4VHhESXk0azBwU2QrSjFwWE5nMTZIWXQvTTczbGVK?=
 =?utf-8?B?cmUrY1MwYnJaeGRPVWE4OWcwQWhMaURPTlkzMEN4UllTMS9JME4zUFR3ZTN0?=
 =?utf-8?B?RTIvbkF6bUszdU1iWTJFYkp3WUFQZ3dhMVlYd3JKS2FkTE82Ni9pTmdkSzNE?=
 =?utf-8?B?UUZYcTNzblF0enhXK1hrSjNRMVVaalpCd0RzcVQ4WGVURjhpZTNHeGVaUmRX?=
 =?utf-8?B?dXppVzJQQ1Z4NmwxUjBNUHV4YXA2VGpsay9jdERaYkYvSlp2dzVKbEU2TWxl?=
 =?utf-8?B?TlZ6eEVsamRrWEZUWGJwOG9wK3BOZXFRN3dVUHd1UFhXYitMRWVGQ3ByZzhi?=
 =?utf-8?B?K1owT2pvR0NPdnZOUUM0MlJ1bTRPK2VWekRlZHRCUlhicHZKOVc4QkdyS0Qx?=
 =?utf-8?B?TzBrc0I0TjBQWnNTK2JNdG5JaWZZU1laS0xEL2szT2EydTBJTEdJU2lNVlMr?=
 =?utf-8?Q?PZICCNUS+xM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHkwekY1RFllUytCc016WktaM2tYd3R2VGlMYzJzb2RLQWRpYStsdCtXc1ZJ?=
 =?utf-8?B?dmxqeC9tekl4ZHczTkIzRm1QdVpKV0NTR0grczRIeThGblJLNXJoMkhuNDJS?=
 =?utf-8?B?L3E5NzR6cGFoY3U5SE85ZWQ5UG55SWw1STJMQzRBNTAxREliay9nOVhnckVH?=
 =?utf-8?B?THZPRENzc0RSWWdndlVicHY4OXBmeEV5U01XN2RmZTZPL3RFdFZYWmFKYitV?=
 =?utf-8?B?SkJ6VG9KTDhSU1dWV3BxQ3plR1BPc3lyUTUvakt3Z3ZJWFdXcCtjMVFzL3cv?=
 =?utf-8?B?Sk9nMGxBLzVVQmdqdTJWMXN3dlNmQ0ZFTW9TMkNpdkVnZVBVVVJSYnV2ckFD?=
 =?utf-8?B?NDQ2azUwWGVLMzllaDdSNldpWkJ5Vk9SQmhzdnhlUVdQcy9uWW9mbjFMaUt1?=
 =?utf-8?B?TTQ0VElvR1kwcGhYSERCVGlMZ0RhSGsyRXFUR1JTNVk1ZDJpU3hBejh2SG9S?=
 =?utf-8?B?c0dDb2ZwK2J4MWxEWVJzN3VBeWttR29NVC83aE1TVTVyZ0RZYmZaWE1CNlpm?=
 =?utf-8?B?bVBJVGdHY0ZWKzVVWDZjQjIzWVBPY0hTak0yRHRsQlB4UnR6QkJFMWlQYk8v?=
 =?utf-8?B?eGxNTzcwTHZ6VHFpbEplTnVDUTdKMFRsWVc5T1BLS1JCdlFHWmJiNXltd3Fx?=
 =?utf-8?B?OTBaRit0azMyOWZzM0w2L2pJUmZyZlpMaHpqSmJpZW4weUIzVThYSW5BSG5l?=
 =?utf-8?B?aWx2U0YrdTZudXdKcEZ6T3JPMnB0Uy9KUXFHclVXSnh1ditDK25qRFZsU2Fk?=
 =?utf-8?B?ZVJ5L3AwSXM1bjVRMm5Lc0lmOEE3cG4ycTd3Yk80Y3k1dmRaM2lqSVVtRm9Z?=
 =?utf-8?B?ZkV3MWkrY0RxTTNVWnBsNDRKTUhBZkJPYzROUzV3K08xdmxXem1zTmpTZFhm?=
 =?utf-8?B?TXJzWFRYdU1BZ1Z6b29GWEpwWk05cUxWbFNsSFBTOEYvTjZPcDEzMVp3VHNa?=
 =?utf-8?B?WU12NWhQMVVyTUlZSTRhSVlQaWplTW5ydnVZZHVEZmNCZGUrdStrSUFEeEhs?=
 =?utf-8?B?eHFtSGs3c0twOGRxUHUyNU93c2RDK3loSkVsYkk5T21pYjZDSlU0cDI3U2pQ?=
 =?utf-8?B?eUdnUkEvaVlSUUJ1Njlna0lCSkc0K1BYY1IxYW1VUHdUS0lhaDZBYXkvam1Y?=
 =?utf-8?B?bzd0eHJDaU41TlZuaURVSjN0V29XVjZkSXNMbWdJbm1RMWZjN0QrS2swNjF3?=
 =?utf-8?B?RmtaZUp2RktvVEpZbFNsQjJoWlBKdkQvdHNOR0p0cVpTT2xrcnpwUWZHQzFu?=
 =?utf-8?B?QlUvSy9nZlpDcWFrTFRQT3BxYy83WXdYSHZEbncwSUl4em05c3VvT0hHM3pU?=
 =?utf-8?B?YURDZzRNS3ZJdkRkSVIybFBhVXdRbFAyUlpxNHBadDU0cjNkb3hXY3ZtcUtS?=
 =?utf-8?B?Y3VlL05VdENIMDB6Mk9VMjAxc3RWTjFTKyt6emx1Tm0xaHNRTGRBdDY4V1ZC?=
 =?utf-8?B?bDJIRXVNOHBHa2dIOVlYeUlkVGYyb1E1cHRBeFlBZU05Q3d6aGdrQ0NFWXI1?=
 =?utf-8?B?RDhTb01qbUE5Vkx1a1o5MTFZSkNjclA0cjhDcTJFZDJXQnNDSG8wZ0UzaENO?=
 =?utf-8?B?VkM3WDJ2UHhaZWpSQzRScmpzMW9UUXlsOVF6RCtCU1pXYW1yVk1peEFLSHBK?=
 =?utf-8?B?YTdGaG9xOTUwWlFTV2w0Y0x2Q1liRDAzdThPZTRWZWNHTStzR2lhQVlUdWVk?=
 =?utf-8?B?bTFKdUpQaFYxRHFnMW1vUVVkbGx5V1h5cjZxVWI1d096cDh3VUwzbEY1YlNL?=
 =?utf-8?B?Mk0zSENHcUMzSkpVTGRrQ0RxUjhRS0JycFRjSEpjU293ZjI5bDlhMUVUVUpt?=
 =?utf-8?B?VVBOOFM4aEVNY0plRmJibFJBT2ZydGxyZ0g0WEp5TXBsd0lHdzJsTU1PWXNU?=
 =?utf-8?B?d2NOVjRXR3lXMDV5NXgycVFXTElFWkdXbFZ2dEs1TFB1c2hXbzhnTXp3N085?=
 =?utf-8?B?bUxGc0RQUnJRUmcxMys5UTdBd0lRcExTNVdDNHI5UEhiZVJjVDNTWkJzanA1?=
 =?utf-8?B?NUVDZVQyVWVmQXc5dnJncXJLN3Byb1crZFNseFFJVzgxUGdQZGtSWnZwVTNF?=
 =?utf-8?B?WTVEbWJDc0RaOTJGSmFaZ2FWRWF4RWF2dmZjTUFZa1Z1UXhmMGprdTFYTlpR?=
 =?utf-8?Q?XFjHnzBq05xHi1sXROdp1hVnG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6175bed4-561b-459e-42b0-08ddadcc2548
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3315.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 18:24:08.4279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZ6ugtIokVGlpB0ESNVQMHftBRDoTte87s82s3FCobwv9a5UGKU56oOSzubZOAYnyUoeCzgRguhLGk9ipfax5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7670
X-OriginatorOrg: intel.com

On 6/17/2025 12:32 AM, Xin Li (Intel) wrote:
> Initialize DR6 by writing its architectural reset value to ensure
> compliance with the specification.  This avoids incorrectly zeroing
> DR6 to clear DR6.BLD at boot time, which leads to a false bus lock
> detected warning.
> 
> The Intel SDM says:
> 
>   1) Certain debug exceptions may clear bits 0-3 of DR6.
> 
>   2) BLD induced #DB clears DR6.BLD and any other debug exception
>      doesn't modify DR6.BLD.
> 
>   3) RTM induced #DB clears DR6.RTM and any other debug exception
>      sets DR6.RTM.
> 
>   To avoid confusion in identifying debug exceptions, debug handlers
>   should set DR6.BLD and DR6.RTM, and clear other DR6 bits before
>   returning.
> 
> The DR6 architectural reset value 0xFFFF0FF0, already defined as
> macro DR6_RESERVED, satisfies these requirements, so just use it to
> reinitialize DR6 whenever needed.
> 

LGTM, a minor nit below:

Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>

> Since clear_all_debug_regs() no longer zeros all debug registers,
> rename it to initialize_debug_regs() to better reflect its current
> behavior.
> 
> Since debug_read_clear_dr6() no longer clears DR6, rename it to
> debug_read_reset_dr6() to better reflect its current behavior.
> 
> Reported-by: Sohil Mehta <sohil.mehta@intel.com>
> Link: https://lore.kernel.org/lkml/06e68373-a92b-472e-8fd9-ba548119770c@intel.com/
> Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
> Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
> Cc: stable@vger.kernel.org
> ---
> 
> Changes in v2:
> *) Use debug register index 6 rather than DR_STATUS (PeterZ and Sean).
> *) Move this patch the first of the patch set to ease backporting.
> ---
>  arch/x86/include/uapi/asm/debugreg.h |  7 +++++-
>  arch/x86/kernel/cpu/common.c         | 17 ++++++--------
>  arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
>  3 files changed, 34 insertions(+), 24 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/debugreg.h b/arch/x86/include/uapi/asm/debugreg.h
> index 0007ba077c0c..8f335b9fa892 100644
> --- a/arch/x86/include/uapi/asm/debugreg.h
> +++ b/arch/x86/include/uapi/asm/debugreg.h
> @@ -15,7 +15,12 @@
>     which debugging register was responsible for the trap.  The other bits
>     are either reserved or not of interest to us. */
>  
> -/* Define reserved bits in DR6 which are always set to 1 */
> +/*
> + * Define reserved bits in DR6 which are set to 1 by default.
> + *
> + * This is also the DR6 architectural value following Power-up, Reset or INIT.
> + * Some of these reserved bits can be set to 0 by hardware or software.
> + */
>  #define DR6_RESERVED	(0xFFFF0FF0)
>  

Calling this "RESERVED" and saying some bits can be modified seems
inconsistent. These bits may have been reserved in the past, but they
are no longer so.

Should this be renamed to DR6_INIT or DR6_RESET? Your commit log also
says so in the beginning:

   "Initialize DR6 by writing its architectural reset value to ensure
    compliance with the specification."

That way, it would also match the usage in code at
initialize_debug_regs() and debug_read_reset_dr6().

I can understand if you want to minimize changes and do this in a
separate patch, since this would need to be backported.


>  #define DR_TRAP0	(0x1)		/* db0 */
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 8feb8fd2957a..3bd7c9ac7576 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2243,20 +2243,17 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>  #endif
>  #endif
>  
> -/*
> - * Clear all 6 debug registers:
> - */
> -static void clear_all_debug_regs(void)
> +static void initialize_debug_regs(void)
>  {
>  	int i;
>  
> -	for (i = 0; i < 8; i++) {
> -		/* Ignore db4, db5 */
> -		if ((i == 4) || (i == 5))
> -			continue;
> +	/* Control register first */
> +	set_debugreg(0, 7);
> +	set_debugreg(DR6_RESERVED, 6);
>  
> +	/* Ignore db4, db5 */
> +	for (i = 0; i < 4; i++)
>  		set_debugreg(0, i);
> -	}
>  }
>  
>  #ifdef CONFIG_KGDB
> @@ -2417,7 +2414,7 @@ void cpu_init(void)
>  
>  	load_mm_ldt(&init_mm);
>  
> -	clear_all_debug_regs();
> +	initialize_debug_regs();
>  	dbg_restore_debug_regs();
>  
>  	doublefault_init_cpu_tss();
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index c5c897a86418..36354b470590 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -1022,24 +1022,32 @@ static bool is_sysenter_singlestep(struct pt_regs *regs)
>  #endif
>  }
>  
> -static __always_inline unsigned long debug_read_clear_dr6(void)
> +static __always_inline unsigned long debug_read_reset_dr6(void)
>  {
>  	unsigned long dr6;
>  
> +	get_debugreg(dr6, 6);
> +	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
> +
>  	/*
>  	 * The Intel SDM says:
>  	 *
> -	 *   Certain debug exceptions may clear bits 0-3. The remaining
> -	 *   contents of the DR6 register are never cleared by the
> -	 *   processor. To avoid confusion in identifying debug
> -	 *   exceptions, debug handlers should clear the register before
> -	 *   returning to the interrupted task.
> +	 *   Certain debug exceptions may clear bits 0-3 of DR6.
> +	 *
> +	 *   BLD induced #DB clears DR6.BLD and any other debug
> +	 *   exception doesn't modify DR6.BLD.
>  	 *
> -	 * Keep it simple: clear DR6 immediately.
> +	 *   RTM induced #DB clears DR6.RTM and any other debug
> +	 *   exception sets DR6.RTM.
> +	 *
> +	 *   To avoid confusion in identifying debug exceptions,
> +	 *   debug handlers should set DR6.BLD and DR6.RTM, and
> +	 *   clear other DR6 bits before returning.
> +	 *
> +	 * Keep it simple: write DR6 with its architectural reset
> +	 * value 0xFFFF0FF0, defined as DR6_RESERVED, immediately.
>  	 */
> -	get_debugreg(dr6, 6);
>  	set_debugreg(DR6_RESERVED, 6);
> -	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
>  
>  	return dr6;
>  }
> @@ -1239,13 +1247,13 @@ static noinstr void exc_debug_user(struct pt_regs *regs, unsigned long dr6)
>  /* IST stack entry */
>  DEFINE_IDTENTRY_DEBUG(exc_debug)
>  {
> -	exc_debug_kernel(regs, debug_read_clear_dr6());
> +	exc_debug_kernel(regs, debug_read_reset_dr6());
>  }
>  
>  /* User entry, runs on regular task stack */
>  DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
>  {
> -	exc_debug_user(regs, debug_read_clear_dr6());
> +	exc_debug_user(regs, debug_read_reset_dr6());
>  }
>  
>  #ifdef CONFIG_X86_FRED
> @@ -1264,7 +1272,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
>  {
>  	/*
>  	 * FRED #DB stores DR6 on the stack in the format which
> -	 * debug_read_clear_dr6() returns for the IDT entry points.
> +	 * debug_read_reset_dr6() returns for the IDT entry points.
>  	 */
>  	unsigned long dr6 = fred_event_data(regs);
>  
> @@ -1279,7 +1287,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
>  /* 32 bit does not have separate entry points. */
>  DEFINE_IDTENTRY_RAW(exc_debug)
>  {
> -	unsigned long dr6 = debug_read_clear_dr6();
> +	unsigned long dr6 = debug_read_reset_dr6();
>  
>  	if (user_mode(regs))
>  		exc_debug_user(regs, dr6);


