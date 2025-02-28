Return-Path: <kvm+bounces-39651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE5DA48E3D
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 02:56:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9ABB7A5495
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 01:55:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFA583CC7;
	Fri, 28 Feb 2025 01:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J28gRGw1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C53748F;
	Fri, 28 Feb 2025 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740707795; cv=fail; b=EYW/eAgVDjP723BHpFdIq+OOzeCaG8GF/wNB0ddpwusECsWHYNql+XxM7KaJgdECcV5FBkhY6o6ZSKz29U3NCYrkqnGPfamV7ZVRw5hpX5BH2KZp/yUYiIDEVt+vi+6o2VJjHy7jB704W13rXXBz2o0kBDVFVht8HeOMrpcGmCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740707795; c=relaxed/simple;
	bh=osbdWUAS/gpvTL75ySENgZNNRarrTyMk1WdHCB9Zsgg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=getcgMFLiYXs/RbZt8mOPAJ8SbnXbHswYLgrxPrPSRf0bH/qC+pnylfoF3yim1sMlh2nJzIPfnKSFxN0n8PeAW/ODvsfMlN4wRR46GEZrgBMR734spxyKsNg7NU2L8mA6+abXXynsu2TSVDzRXoXjaDeEeSxRXBuWAQ8BNMBTQo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J28gRGw1; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740707792; x=1772243792;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=osbdWUAS/gpvTL75ySENgZNNRarrTyMk1WdHCB9Zsgg=;
  b=J28gRGw1LtXhSVVnHExYWwnxwESSAteI4Mli4bVbLe8tvmyhtv0mYGV1
   v13u8JqArDmkJBLV2whuJ38kFZxPDG8kfHzObOFbTH59ZEzoGXHZtYZHw
   El94jevX7NMJp4CdJM3uBeDGhcwAUXhwmH/+B+Sx63k48mDOXMhOxEiVo
   zLji2Oud/Y1kVdF8Ke3EsrY+FTIzDj5dgJHxbt+YFqPDX85R0aZPP+hKN
   jdw5MJVenkP3seyXHUP8R/8HCboZZsDSMGnTFS9A0UMmM//KuHc3Hgd+Q
   XCO41e4WHaJrhV0Dd0U3XWt4LInzbLBVGexsa2BbV7eK6ABAxGbylmIJU
   g==;
X-CSE-ConnectionGUID: HZtVY6wYQtGdB53jkaDD1A==
X-CSE-MsgGUID: 6hQw7TWCQbqFifC+5e5vcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="52614073"
X-IronPort-AV: E=Sophos;i="6.13,321,1732608000"; 
   d="scan'208";a="52614073"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 17:56:32 -0800
X-CSE-ConnectionGUID: Qug+w6xVSg+MfEhpr/HpNQ==
X-CSE-MsgGUID: Yw5hezZyS/ixkGJtwb7EiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,320,1732608000"; 
   d="scan'208";a="148018544"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 17:56:33 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 17:56:31 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 17:56:31 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 17:56:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YPsLIcqr7+DOABZeH9fy/reiKadgp7a7VQ/KiQou1/sJTTEgwR/LP+dM1L+KSVJAsTR3jTyoEYZfrgdkQe0frdJ19gFOzH8vGvrUMoEI+O/SK3MPrloWrrPoC5rohHlORlYvq1nIMejEzt3+ZQ+1v6jnx9lOL6c6GJDm54NGyYl9XRzAdyXKsYvf7/L8U+WYBMApACb9MhNGpwEw3m1WTFtUTBRuLp3G0QO0u/9NbOXc7kTrYiE/3vQNFUugfLDz8CpnD+OpfqxYq9s3/pxL+U44G0qhkT9l3CcZnvUjE2lfGdGM1aiaLDQZQCXwI/zfrHQ1kGAkUuCFX1u6JrLIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yE15hVQm94jwRngGBcEfoxgxNf6ftiFFEGoDmZWXn4Y=;
 b=v8nJLnz2WsPXOy2zqp8EhoEIEsb0yIIWxEwdrxDlZfob0F4v4xBD4dKkI4oTn+XhZXiA4rOAVxpBr4AIzuVdo/9b+myTvslYXfT35tonejWulr7JkR2VyREEYssSl5umnOLFHCJFAFoP+5zudwGvTAM3uEw3KogDeIbA/8IdV5jDt3/oTvtxc3IshWUX5cO8uvT/29gcFl51oekLrSnkIE0++Mfq3sBo7mholJGOjEq5c5XffL0BaA6xDEDi6CihOyrI7jQw3LFiK04HPKr21hucJiu9H7ZtWuMItfjfBcxAO3rkWiKcQDP6l9tol14nAhV+lDdB8O33OuvIK5p6Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 MN0PR11MB6181.namprd11.prod.outlook.com (2603:10b6:208:3c7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.19; Fri, 28 Feb
 2025 01:56:11 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%7]) with mapi id 15.20.8466.020; Fri, 28 Feb 2025
 01:56:11 +0000
Message-ID: <e86039e7-b3e5-4581-9701-06fcd0ebda20@intel.com>
Date: Fri, 28 Feb 2025 09:56:03 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 33/33] KVM: TDX: Register TDX host key IDs to cgroup misc
 controller
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, Yan Zhao <yan.y.zhao@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Zhiming Hu <zhiming.hu@intel.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>
References: <20250226181453.2311849-1-pbonzini@redhat.com>
 <20250226181453.2311849-34-pbonzini@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <20250226181453.2311849-34-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::9) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|MN0PR11MB6181:EE_
X-MS-Office365-Filtering-Correlation-Id: d0d83343-ea67-46f8-d14b-08dd579b1354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UlBqeFRPcFExWlBZTG5sS1FCUG1rdlZIc1hHcmpxSmlhWEVEZzY5aUJZeGdO?=
 =?utf-8?B?T24zY0I0dnA5WUtITklGejY2STJGcmNRV09ZbmRDR3NhdEExNnRReXkzRmFG?=
 =?utf-8?B?UkxVWGQxRmRXa3dtZjB4K21ta2dsUDJsZTJRNEZmUE1mekM1SHo3c3YwNlBQ?=
 =?utf-8?B?OHNTa2FxNjM0bHdBWjRIRmY4L0c2OXBlM1FvdksvaG5pVzd5Y2tPQXdlSW0y?=
 =?utf-8?B?NlNOanJzQnJvaW1qODlvQlR3dUdXVkRlblBkUFJiTTNCejlnUVB2bXQ4MFc1?=
 =?utf-8?B?azZpajlSNS9XV1JkQjk2eENMUU1BazZYa1FpWlN6eUJGUEZTR3hUMjNvbVhB?=
 =?utf-8?B?SEo4cVQ0bzJzQnlzTlBmcmtWckZGbEJxa3F1RlZYRWdlQ3RhaXMrN2lZTm1T?=
 =?utf-8?B?Ylh2ZXJkMVlzWVh2SGN3NTFoTm5TQS9HTEJFSkgxamJ5dHk4dXZ6SmhNR0Y1?=
 =?utf-8?B?Q29tTjlMM2E2Zno0RmozN3BEb3RFam54K0ZaMGRndTZLM3hhQUxENE9qTllm?=
 =?utf-8?B?K245TDEzV1VGaXlPMi95WmpIZFVxMS9mdjdsMVRRL1hYWmJsbFNxaEMxTWxJ?=
 =?utf-8?B?RXhvenZ2THU4Mi9hRERPSUg0NUp4VWlpQTBxZXBBdXNTelhxaGUwU05CcmNq?=
 =?utf-8?B?bnZxQXg0RzRCaXk5MXF2NGhCN0d4MWlJS2NRZFZWbjhMVStDMXpWL1pLV0Q1?=
 =?utf-8?B?b29HblhvbStVNm1xU0tiWnpnQnNpdnBCQWNCWmRjdlJFQXVyWUVZb1Y4WXdE?=
 =?utf-8?B?dEFmdHdDdDEvRXJncEo1cEpRbHV5TUVhOXVTc0p5VmFTUHhhbEF0YVRXeXJO?=
 =?utf-8?B?UjAzU3M4WFZPUUltNEk3OURpTjRyMVIxRmZ4K0EvSDF1RWVmNGh3RHFVRlNP?=
 =?utf-8?B?amJPS256RXBaWTNTMUhabFZ6dGpQMTh2bXlYM1VjVXduNzJ0SUN0Q2MxK2Rq?=
 =?utf-8?B?Z2VwN2JvK2MvdzNzdzRtTGhQWmlsUmVxTmliR2ZzdHBkVU9HN251d3J5cHgz?=
 =?utf-8?B?aHVHeFFwQVF1OXplQVFFbHZOZ1Q1RzdGd0Y5RGU4QkpoaFFFMStObVFzQ1kx?=
 =?utf-8?B?dnhGRFZTM2dCaWZBQUJQRFQ5SXhUYTdDT0JRSnVOUzQ3WGtzMDR2elIwQ3Iv?=
 =?utf-8?B?UXdJbGQ1MGw2N2FGakYrRVRnM0dDaGVnZU1RVkMyQUJ0QlhCSWE5dDBUYnIw?=
 =?utf-8?B?a0UyclA4VHNwdzlKK1ZuakhYZXphNHg4MmtmY3hWcWMxWUtLMG91NVl4WmQr?=
 =?utf-8?B?Vy9rQktmSVlZQkpEYUl1cUJ3aHZSVDNyNDdLNGJVZHlxUHduaFB6RzBOQ2Qz?=
 =?utf-8?B?ekZ3cCtBSENYSXA1d3BJRjNFY2NQUGlvaEE4SXcvTTVJY0dJKytESUJxNnE3?=
 =?utf-8?B?aWVEaEx2L1dFQjNmSnhGNXRHdE1GclhiZUc0NTVoOGxoaGU3aENGZHZnTHRP?=
 =?utf-8?B?aXJ4MXpxN0k5OXA2OWxsb3AwK3dWSUc3L2EvOTgrK2w3eWZxbFpzSVByTDZG?=
 =?utf-8?B?dGg2UE5lVmVmcmlUcWc0VTg0YzlSSFppZFE3aDlzSWNOTk1wdGt3L1BXcEE2?=
 =?utf-8?B?b1lHRFhPUDN3SG5lRUpkK00zRVdNc2RpVFJNNHBYemZsaFY0S2FTcC9STWp3?=
 =?utf-8?B?N254V1ZNMEluUXpYM1RSR3VJSTlrcFR3c21iNDVEbUJvZ2NzODllQkNzdXVv?=
 =?utf-8?B?ZFBJcXlLYXNkNTFWdnhaVGdKcU1lRnVIRFlkSnplN2EyRUZhM3UyTjJxMkhJ?=
 =?utf-8?B?OEVXaFRoelJRR09HZVJvOEdFeEExdndWQ2s3dDZKbTdGTWZ6ZUQ1ZUVoTEVK?=
 =?utf-8?B?bVR3QndGNHQweWt1REhRTEtxa0I3bENaNGtQdExUaDM2QUVyYmxjKytDWlk5?=
 =?utf-8?Q?CcUx7v7B/zftU?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVlRN0o1dllIK2l3QWlkZEw0alJQM0NQWEVGd3orK3FSc0JNSG50OGRqaTVY?=
 =?utf-8?B?L2J1Njl1SjJPRzZubkhqTW1sZXkzeFViaDQvSCtUSnFIYVlPUlltaUZpRjB2?=
 =?utf-8?B?aW8rMGg5Y0lBdmtZZWdtOHhBNFAvVnRUTUFBWW9LSW1OdjV3UDdnaTVjcTUx?=
 =?utf-8?B?RkRldjQ3d3BLUHlYclljS1A0NGxvSjQzbkNFMTREak9yVnc1dzRwc2Zrc0ls?=
 =?utf-8?B?d2kyOGF4bEdEaHR0MGVqT3NLa25qZ1EwMGFJSEdFenFyWGsvNFByQlFkY05H?=
 =?utf-8?B?clRubGg1d0ZiUlVjczI4S3pITzV0NFBCUXN6L2hnRms5MFlDSTllRDN2NG5K?=
 =?utf-8?B?R09jazNHcEh0QW04NHU1eXdoK0hybVBPdlBUaGdCdUFYZ1ZSUUtIZ1JTQ1kr?=
 =?utf-8?B?Tm9ZakVGTVBnVTE2eW9MTVZOV3ljWEE0bjViSWdPT1RxTVFZSHI2UDJDQ2Ir?=
 =?utf-8?B?Rkk5OCtpR3Y5NjB4VDQ2WEJ4T0xvNjVaZkRGdURFN2lFS0NyS2gxZklVeXB4?=
 =?utf-8?B?R0RuQ2JweXhjU0V5Q0JwSlFRMXBOZUx4TzRpbUlUSzNFdktVWFAyRWVobDJJ?=
 =?utf-8?B?UUtKR1pCSEZ4MG1BemY4TkNvZ0oyUkk2cGs0MmhwNkZuVk1EMjJ2ZCtNSWVk?=
 =?utf-8?B?VUJ4RU9IckFtM3ord1c0QkZTT3NMS25PQmF1NDFLeUNQcHNXaGlIUUNRcnhH?=
 =?utf-8?B?QUVneS95ODN6VmVaYnlITWRzb3JNYXcydU11SVQ5dHlqK0E4aW40cGVhZnZp?=
 =?utf-8?B?NENDeGloYlpRdmVSYXNKSmxuZ05GMFdyNUk0OVYzY0FrRTZ5MTJ4blJkcFJQ?=
 =?utf-8?B?NVc5Um5FK3YwZU8zNmY4V1lwbWE3OTNBQ3RoOHo4b0d5U3VTTlVZUmw0UUJJ?=
 =?utf-8?B?eDk0MlhwTVphMGtUdGZtbEwrcGgvLzNsUUxIaXFtSmxXT2pha05hb2MrSFI5?=
 =?utf-8?B?MGdwVk8vRldoaVRSVUtOK0JPYW1LbWtKaCt0WWEvNDdvdHNRMXJaVkdUZ0hD?=
 =?utf-8?B?TG9oZ25zdVBDWUQvVDh6WEdDVUE4Q0wrTjEzV1hUaUtQaTY4clJHTGQ4b3Zs?=
 =?utf-8?B?Rk1nbitrMXFyZEJVRFFZYzYvV1NvOWgxbFpOVmFPNFh0Nzczb2hkTUVTcjcz?=
 =?utf-8?B?ZUtlcldCVXZUUktsTndkVWxBUDFaWTM1WEhKV3ZzazE1YnFtRU0rSGwrOStZ?=
 =?utf-8?B?NWhkZ0w0Q2FpZjUxSW5LeExJVHMwalViQVcycm4vNCt3cjZtTTZiMG92L1k4?=
 =?utf-8?B?WHJ3L2E2N0t1eGlLdzZvWTJaUU5UeldwV21XckVMUmhNMCtiRjNIdjlKTzdB?=
 =?utf-8?B?VmF2K3I3bzNDbGVMN3FaTUFyQjZnWlFVWThLT0lNR2d5elhsaHhZM2pydnpm?=
 =?utf-8?B?Ny9qR2t1bEpGbU03eXQ0UTlJcjBMWnZQVXAxbVZtdUJJZ1dFZWVOYXF3SkY3?=
 =?utf-8?B?SjFIYXZmby8rc0hrYTgzVXFYbmNjcmkxb0hweGMvWmhqbUtVNGJHeUZ4dyts?=
 =?utf-8?B?ai9GaVQzOGNOcVlYUTlmazBscGhZQ2FmditaYTBOTklmUHJ1Nld2Z05sMHdX?=
 =?utf-8?B?a2E1aEo3djN6RDhhWHY1dVlsQWVBZEVIYWEyS0pHUk9YY1YvbWhkbWJCcWJ0?=
 =?utf-8?B?eGVZdUtvUmhDL2NIUXk4UmJxaVNPRVZUdUUwRWlubEN3RWtaRDZTUmh1bXo3?=
 =?utf-8?B?ZHpXM0dNNVI2QlhjNlJ5TVV2Mmozb3lxclZSRG1vZXhjdHBrWG1PMmZHWHZk?=
 =?utf-8?B?aWdxM1lxSXh1MFdHTDBvdzJDeUt4dGpYZDNmYVNKWTRFRnV6TmtadytudWlv?=
 =?utf-8?B?ZjBTdTNWK1llc3dBOUNZb3dQamZYdjYvVEpFZE9ScjBGSFhCZkkzbGZBcyti?=
 =?utf-8?B?ajFKNVBuNk0wcjcxb25nQ3J0ZmxQZWVWRzdSekpoNkxjaHh3Tk5MeUd3Tmt4?=
 =?utf-8?B?WU5adU05V1ZqZnVSNkpBVjcrbFFpdkNVSHBoMGVzSC9Zb1k2ajY5M3Y1MjQ0?=
 =?utf-8?B?Unp0OUgrVW9XVWFmVjlzaFQzVG1HRW1RUXJoUVNmWHdXdktFdzJXc2tVakN2?=
 =?utf-8?B?K1ROVThSaWp5d2NMekpYQkJvZkE3dzJzQ0s2Um1taTN3QVlRRHl2NXlMNGJt?=
 =?utf-8?B?UFNnZmNvR0xjdmEzWXYxczVaalJ0cERIMStoSGtUcldxaTZnZERhTlNUbTYr?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d83343-ea67-46f8-d14b-08dd579b1354
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 01:56:11.5738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCKlhsRGnwyWxgkHzlPgwI6ICZVceoF8FFKO9PENnN1LJJEZBSX5hMr+qe1F4MN6gIx8HeRIW4v7kENcNW8FCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6181
X-OriginatorOrg: intel.com



On 2/27/2025 2:14 AM, Paolo Bonzini wrote:
> From: Zhiming Hu <zhiming.hu@intel.com>
> 
> TDX host key IDs (HKID) are limit resources in a machine, and the misc
> cgroup lets the machine owner track their usage and limits the possibility
> of abusing them outside the owner's control.
> 
> The cgroup v2 miscellaneous subsystem was introduced to control the
> resource of AMD SEV & SEV-ES ASIDs.  Likewise introduce HKIDs as a misc
> resource.
> 
> Signed-off-by: Zhiming Hu <zhiming.hu@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/tdx.h  |  2 ++
>  arch/x86/kvm/vmx/tdx.c      | 14 ++++++++++++++
>  arch/x86/kvm/vmx/tdx.h      |  1 +
>  arch/x86/virt/vmx/tdx/tdx.c |  6 ++++++
>  include/linux/misc_cgroup.h |  4 ++++
>  kernel/cgroup/misc.c        |  4 ++++
>  6 files changed, 31 insertions(+)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 52a21075c0a6..7dd71ca3eb57 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -124,6 +124,7 @@ const char *tdx_dump_mce_info(struct mce *m);
>  const struct tdx_sys_info *tdx_get_sysinfo(void);
>  
>  int tdx_guest_keyid_alloc(void);
> +u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
>  struct tdx_td {
> @@ -179,6 +180,7 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
>  static inline void tdx_init(void) { }
>  static inline int tdx_cpu_enable(void) { return -ENODEV; }
>  static inline int tdx_enable(void)  { return -ENODEV; }
> +static u32 tdx_get_nr_guest_keyids(void) { return 0; }

static inline ...

Otherwise will trigger build error when !TDX_HOST

>  static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
>  static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */



