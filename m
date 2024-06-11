Return-Path: <kvm+bounces-19358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A9F904645
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 23:35:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FE781C235A4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 21:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24C4715382E;
	Tue, 11 Jun 2024 21:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jovIkY36"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04F8171C4;
	Tue, 11 Jun 2024 21:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718141711; cv=fail; b=mrHNfgtdxZHq9655AMlI4v7gAorMd5pi7Rqtc94GYYQ9TH00vtd79p6y2gFU2PYPZ43XNtDT97QN3JYo3JAs0FBk+mY0JR05L2wsXFp5bYpmwwp/P1C/SrWNIRiGAizS37UEuwZ0pnyL8QWYPyWq4b9A56AoEAXBuiFYhdFu00Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718141711; c=relaxed/simple;
	bh=UequNdfAsVjPOAe7JeOKc0kpJc3Ba1TO8KXN+CeB8+8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ASIO37sgfWuRRbm7R1sierhqZikVKuGPuabYXyYDpGkNMpb9XpdAMpZ15yKhNY/ApHiFjZ9Krvh1oownBM6CkXnWg5tLnKYNEZeJl7dd731EC+XWdF7Y5nTEOCpt2Hh++XmEv9jTO7CcUzrO4nv6XqHxnEDVAgUIoKO/dx6fbVI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jovIkY36; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718141709; x=1749677709;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UequNdfAsVjPOAe7JeOKc0kpJc3Ba1TO8KXN+CeB8+8=;
  b=jovIkY36h7nSwyOfcuArJjw/v0jaRAuxy7E0DNRZmENGHpzLMUKnoAev
   GqNqysWwXKV7jTdy9WuC1X9OsYGUhWXwERULcaxD99I/0q5Qx+WTinK0R
   m8jBPvpjKsV8QgYd6i/FiEPErpEB+xYKUeVdiMfaquuIaQfgFOnohAcKr
   mNh6K6BG6yV67tebIOnBPYIoEyU2p47Z4OPoBHezd0r2oTf1Viid6nuJi
   CC0DFbZRXmMG9O4UiT2iQXvbAvz3APqLkjpV86cwjMu7n0i8CYj6S4zRl
   KDvry4JegKDm4sn3BqD2asGRIUkOtxoilHoedbBZoNRZC4i4ZeMfFO2vn
   g==;
X-CSE-ConnectionGUID: 8+WVWyk2RQGR33yimypFnQ==
X-CSE-MsgGUID: b4dmuyOPRrGYBc5MOGWpfw==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14839653"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14839653"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 14:35:06 -0700
X-CSE-ConnectionGUID: VofApyfWTOuyQxNkr3xHmA==
X-CSE-MsgGUID: PcmHJy6GT7u+YNlfVpLLxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="39501245"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 14:35:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 14:35:05 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 14:35:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 14:35:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 14:35:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z340hEAULlpqoKt0ampQEkyBVTKdX88/CdMexiEhm3dX7u4UOIdRXqiWlD0kl8CXP1s58MDPaYdiXxISUL/QauH2NuYORFEeT8alxKht8xyGA6khureG1nEHojwA5aw+UFm2ZSUKiqt+pb4NMoAphJtMWa24ZlHWq98QEzhHxZeQbngbYDnxa8x4uG/eoqr9CsA4L9NGFoSRvXRhafVP4h9n1sddaCABWWJEsJaRuW7v2tAb8/Xr6I6Np1R0P4Nn/eSxP3YH0a4ylGlwzp2IEA3AXDItBlO7G1kr6n1as/vzrOR5xtZbyUqXOSuh/B/QMsPqT+eRbbI/FTZ03OFCuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oXys8otXHLVeqA8XIQ3e/VL0SiyW6GuR+QfnwdBDnCM=;
 b=MpMoYGMX5X9sfro5qdcoaMV35CnZ6XewJXSbrBADcBmvli1RTfD2SzxCQQvLupl2NY8yyT8XAFoQ4HyhECNdOgCfxe9vQ7oApgN6bEKRs6RttjaXTHEQzeYEyZ5MCx8ZztF7CKpQFqNd1IcXlvNnL8GKidFDZD7GpDPwuOgOCz06z75X8+m6fJxNuwh3vWXI2qgJ4qzus9HXyQ++TSg5rgLYSV0GuPuk0G2TX3MoU6MWc0V8PjOnX8/bkzxETcjVroSM+y1trLNE7A69NEBYeQCS23nEcf5o8jawXhogsYQSsqDxoPy578gf8X0ygtm+RdRE21xiDSrbSbptJbepwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8025.namprd11.prod.outlook.com (2603:10b6:806:2dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 21:35:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 21:35:00 +0000
Message-ID: <fba4628f-9786-4e76-84cb-178508d90fd8@intel.com>
Date: Tue, 11 Jun 2024 14:34:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 2/2] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: Sean Christopherson <seanjc@google.com>
CC: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <vannapurve@google.com>,
	<jmattson@google.com>, <mlevitsk@redhat.com>, <xiaoyao.li@intel.com>,
	<chao.gao@intel.com>, <rick.p.edgecombe@intel.com>, <yuan.yao@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1718043121.git.reinette.chatre@intel.com>
 <09b11d24e957056c621e3bf2d6c9d78bd4f7461b.1718043121.git.reinette.chatre@intel.com>
 <ZmefjsFArRSnC71I@google.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ZmefjsFArRSnC71I@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0273.namprd04.prod.outlook.com
 (2603:10b6:303:89::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8025:EE_
X-MS-Office365-Filtering-Correlation-Id: 4099f691-036f-47e5-04c5-08dc8a5e5903
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|376006|366008|1800799016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NDU4dXdOMHpDdWMxZEl4U25Vd2h5SzdIY2JZL0NlSytoVCsxOWYxbjdCVTRO?=
 =?utf-8?B?SThzZEQraWc3ZC84VEJqZFVKMjNiK3N0VWNoNkhBZHNmWjBiTGo4ZnVrZFRa?=
 =?utf-8?B?SkEralhDRzNueHJEaE1MNU1LTTJybkZ2U0RZMnJidWlqS1Z0WTE0eUVZRTRs?=
 =?utf-8?B?ZytabVUrVStYTnZGY2t1US9kc3huYWo4STF4bnVIc3JJVTBhRWtRNllqejBN?=
 =?utf-8?B?amY5eTM2OSt0NTNSL214SHlPdlUzQUFsbjEvdVJKWnNvSUF0eDNvaytROW1z?=
 =?utf-8?B?clRFaXJsanhQVFpET042LzhEdGFaOUtXUTNBUE1LSlZnbGdYV3ZKVXNNRE1s?=
 =?utf-8?B?OFZvbHBuUVV5Uno0TUFvcmlvY2FkT0N5TWZBN2R5SVpZMVVSL09UYytXdDFp?=
 =?utf-8?B?RWg1VzlLNGt5dUI0Z25nUXNrS1Bub1FNUTJvZmlTQVZEUlZJS3RyYUwzYjUw?=
 =?utf-8?B?OTg4Y3NjR1o2aFpyZGx5NE5ucnp1Y2E5OU9za3VtUWx4a3B0d2crZmR3Mmtr?=
 =?utf-8?B?N3VZVTREeFBPWW1WWmlyU2Z6UjN4T0srV1g2bXFTNmdoZnlpNUQ4eHgrUzlu?=
 =?utf-8?B?MWM5TWxidmVkRzZPM25QZG1vd0NXM1NaY2I0NWdTUnV4MC9OZGxwdmU1WldE?=
 =?utf-8?B?VzFPMVdYWlZLVmNCa2JpT09WNEREditDQWFKc0R0QmpXWVJWUUxhOFkzOEFZ?=
 =?utf-8?B?Mkg4TUpXZklkUkFEZE5WOFBwM1BVV3pzZGV6VVRvazFtVitxWEl2OWIrbWMx?=
 =?utf-8?B?WG9oVDFNY29DMzJibnFyWjNnd0JDR2ZkWnd0QU5wQWZ1QWplWjVSUjlFUUw5?=
 =?utf-8?B?eHhoc3dmVDFvY0VSM1AvREJhVlpXNFRRak5jbU1uUmhIRWFoNDE2VEFMQUtZ?=
 =?utf-8?B?ZGdDZ1lKYVBhdkUvVEVBd1JFeUVvZUtDbm1iTGNKUThaRzRMS05Ia0dIRXVY?=
 =?utf-8?B?WC9JaGhIa3lFZFNzcEY3eFoxRWg1aVppSWVJdFR2aVp4UC9SVUVIREFKd2NK?=
 =?utf-8?B?aWlINU8ycnBVNEp5SGRKQ0k2Sk1vYVZZVkpjVWJBTzdiQ3ZJT2VIbWRMdEJ2?=
 =?utf-8?B?Z2ZDMFY2cVViNDc4eVlrcndpZGpqY3dDanJMUVAzejBzUGRhcVBpL0RON0hT?=
 =?utf-8?B?MnRpZUx2WWVmYklQbFlxSVJ1dG9RR3dUbXBqVmpKaXdQNVZvTmFlUDRrNUhD?=
 =?utf-8?B?aXhCbFVVZy9ITS9lc1JlMHAzdzdIMFpBVm9INmlDTU44NHdsK1pOZUY1Nzd4?=
 =?utf-8?B?WXR2V2s0UFpuTVB1Nm40RTE0akFoSE9DZTkwNjR1bnhTeHUyQUplSE5LTFVE?=
 =?utf-8?B?RThidnVzYjZjRXRRWWhKN2tuMEcxMGQ3aE9FNzZ0WXNXaW9RSmdVRXBvMkg3?=
 =?utf-8?B?dmNGRVh6VmcvaHZVMWM5NWJBMDRqWWtrUDEwdXE1bkhIc3phWEhNVk1XU00x?=
 =?utf-8?B?M1ZzQlMvL1VCNVN6bXliRjNDOEdxWmpjMk83aXQ4WWNDRFRhNmdrOWMwQ21F?=
 =?utf-8?B?cllJT0xqdkIwRk92cHJ6QjFrN2tnZkUzenJFSTdsekcrTnRyQzlmVnc3Mm1q?=
 =?utf-8?B?enZURFNnWnhRUkxURmFJS3RVWGpUb1YrMnFmeGFUZDhCWEFyaE9GUll6UWtR?=
 =?utf-8?B?VVN2ZlE3QlBiQUx0Q3dMYlc3blZWZ2FhejIwN1JuN3N0WWRYVHhJK21JVXBG?=
 =?utf-8?B?SVJBejl2aWwxMEczZ01neTdKajRVQkxCS0NuSWxPOExCd29yb1d5WXlRVTJs?=
 =?utf-8?Q?6aIWSrvQ3PUP4Y8NSJq0kPt+pEjNwZhACM33f9b?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(366008)(1800799016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1dMcEdCLzEvQjZ3U2YvTXhMMExzMUVtQjhORW5leDQ3QWFIcnNGV2xxck9G?=
 =?utf-8?B?UDJqVXhqWDBtSVFuTUZpMVp4ZjBucHFzY085MHNhU2pOdGV4d0dQcVZRUHFv?=
 =?utf-8?B?SE81U3NFaE0xeml3WHZHQlh6eXBldDB5R2F2S1FsZ1RRblhNQlZlc05RRWJo?=
 =?utf-8?B?c1Mwb2liRkFCSWJpN2VKZ2VVeDJqTVJMb3Q3bEo4M2lzVGFvYVJhenVxeUhh?=
 =?utf-8?B?YmV6VEVDdUlnNG4wWEFORFd2NitOTUIwOXFhN1B0WHhqUHFjaTBzdktYT3Jl?=
 =?utf-8?B?dVdBdW5EcmY5c1ZPVHQzVUhKNFgvVlJrRmVMaWVBL1g0QVBCTGpQR1g5TUU1?=
 =?utf-8?B?SUV3SG9aaDl6d3lZK01zalZmb2oreG9oTFljdkZjUnQ3Mk1YTzVEd1puaStQ?=
 =?utf-8?B?aERhQlZpQnZzZHZWVnJIS2VJb0NwWllRSklCOC9IWk9JSkF5M0orTDFYenVL?=
 =?utf-8?B?ai9qN2g0MlJiYTNvRzNYcERjOWRvODRpaUxJaEpESzJFZjAyUTlvTnh6aE9P?=
 =?utf-8?B?dm5WWHJpSUJHRUNBVjVUZU5MalBQY1BwMUdSdzE3NEZXTHBPQkZYUGl3TkhU?=
 =?utf-8?B?VXhTOVA3RFY0YUZibXZPeWxXQWlxRC96QjZBN0VEeHEvVTNtR29HTmNMREdH?=
 =?utf-8?B?ZGV0eEV3ajBySW9sNk1vK3Q5blRYK1dXUjhvUngvLytxeHEwQVprMVpBYlA2?=
 =?utf-8?B?K1d2Y3NwWml2NG5zSjFMbUtsZHdlMGVZK1JwVlhjY2cxRkwrWXJrcGxVSHVo?=
 =?utf-8?B?VFhnbnh1ZHBwT01oWHV0VnRIUTVXb0F4U2lwdEtac0JJUjV4UUV5K29BajMy?=
 =?utf-8?B?ZnVNc0JNN1AxMU1pWnBjckN5RUZVVWxsMDkrei9CdUV1eWFUZGRjQnhjVGxh?=
 =?utf-8?B?VjJPVEhFTHpKZzdjc2l3cUMzQk9vRlNIRzJ5aEJnQ0tPUW9vQkZpdktHNVpo?=
 =?utf-8?B?K3VreERzY3pQbWVqc2xSK05KendrRzFpb3grODQ1c3REUEl4NGZKVHVmVFpP?=
 =?utf-8?B?OTcyMGNzbEpKbnV2N0t6L1ZtdG9kSG54cmxJMUJiMjB5MFNSMWJId1F0V0Nh?=
 =?utf-8?B?Z1JGWGxPSjEzTjBiNjgvWThpelBLQUprVkJuc203Z2RKOXBKUkZiVVloZTVS?=
 =?utf-8?B?ME94T3c2Y0E0M1FTbmpIQmxuYjVLeXpVbXh6WndPVmZPZUkwcENwMytLdHJB?=
 =?utf-8?B?VEdaSWkzOCtVTndYMUNWN2ZxemsrbExXMm9oeGw4c2JYd1pmOXlrQ0w1Rm16?=
 =?utf-8?B?OWtnbFdWMFQvdG90ZW1yWnI3a1R1dzhpVWhESkswM0R1b1dHakl2YnN6b0Q1?=
 =?utf-8?B?UDlHYko5cDU0UjljMFVsTGZlVTArK2tHb3NjQ0VPVjQveUtYQlc3ZjJLT2dM?=
 =?utf-8?B?aXZQcEwrQ29yeTluMnhicTIzdkE3TGVlS04rdloraWkzN2tPb1UyeEp2am5M?=
 =?utf-8?B?dndNUmNPeGVMb290eDcybUQxTXBkWCtHMG9TNjZ3UjN6N3Z2UmoxQ2FweUhz?=
 =?utf-8?B?bFhLeDFHMGFRTlNzQmhIbU85K2VyUmNkK1RLNk9zWHNwdHJwVUNxaWJDT1Vi?=
 =?utf-8?B?dXJBZFJQQm5CTHRBbHpoWTBFTWNZUS93S01qdnV5K2tQMTVkOWlKTFJlRm1J?=
 =?utf-8?B?R2R2YkRUd1A2czNua0c0Nm82empzYlNQcVpxREFQSkwxZ2xpVlR4NGNlMTB1?=
 =?utf-8?B?SlluS2FkbWt4OWU4WkxKK0MrMlpIcFhKeVJkRXNxZDAwS0NmaEhsWVU0Z0NR?=
 =?utf-8?B?VW9rUFQ1K1p0VjE5QXkvditKamxNcFRKdkZXakpEN1lIeGxtZlU3SUwzMllp?=
 =?utf-8?B?MFAybkJwVUp5c2phQ1JiUFNxcTdrNjRYbU5yZ2V5NjVxRGh4YUFDNWREMHcx?=
 =?utf-8?B?eHFWZ3JKbnBaZngxeGdUbVdDU09wUWl3ajlITUxDdS9YRWlQMVVkeUtKSllE?=
 =?utf-8?B?bXRLTm5CSG4yNEkzN3BSTytXMytKYVg1SzdQcEZmbm5mUlU1em05NmdTSGJv?=
 =?utf-8?B?YWNNQ3RJY3E2dnpUZEkwb29KZFhxMmxmM3Nla294SHNqV2x4bjQzMCsrc0Fy?=
 =?utf-8?B?aXpla0ZrUTloeTl5ejJoTnB1TnY2azUycVhKeDI4YlJHRlpKUDlzWVNmNFJw?=
 =?utf-8?B?ODYyNjFSRjF0RzcrWTQ4bHJXYnBMYWJ0NVk3dFIyV2xtd0gwZCtZSGVuTXNr?=
 =?utf-8?B?OFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4099f691-036f-47e5-04c5-08dc8a5e5903
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 21:35:00.5862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6bC30/fiqa1dPj3nsypoEQDeX++TNRg/rMoLWYoCAygi7arwwJAD3dGPNL4ugc6ATtPTsfgL07O6aulK4Vm439CRHgFztrvUhYsbz5/wVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8025
X-OriginatorOrg: intel.com

Hi Sean,

On 6/10/24 5:51 PM, Sean Christopherson wrote:
> On Mon, Jun 10, 2024, Reinette Chatre wrote:
>> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>> new file mode 100644
>> index 000000000000..602cec91d8ee
>> --- /dev/null
>> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
>> @@ -0,0 +1,219 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (c) 2024 Intel Corporation
>> + *
>> + * Verify KVM correctly emulates the APIC bus frequency when the VMM configures
>> + * the frequency via KVM_CAP_X86_APIC_BUS_CYCLES_NS.  Start the APIC timer by
>> + * programming TMICT (timer initial count) to the largest value possible (so
>> + * that the timer will not expire during the test).  Then, after an arbitrary
>> + * amount of time has elapsed, verify TMCCT (timer current count) is within 1%
>> + * of the expected value based on the time elapsed, the APIC bus frequency, and
>> + * the programmed TDCR (timer divide configuration register).
>> + */
>> +
>> +#include "apic.h"
>> +#include "test_util.h"
>> +
>> +/*
>> + * Pick 25MHz for APIC bus frequency. Different enough from the default 1GHz.
>> + * User can override via command line.
>> + */
>> +unsigned long apic_hz = 25 * 1000 * 1000;
> 
> static, and maybe a uint64_t to match the other stuff?

Sure. Also moved all other globals and functions back to static.

> 
>> +/*
>> + * Possible TDCR values with matching divide count. Used to modify APIC
>> + * timer frequency.
>> + */
>> +struct {
>> +	uint32_t tdcr;
>> +	uint32_t divide_count;
>> +} tdcrs[] = {
>> +	{0x0, 2},
>> +	{0x1, 4},
>> +	{0x2, 8},
>> +	{0x3, 16},
>> +	{0x8, 32},
>> +	{0x9, 64},
>> +	{0xa, 128},
>> +	{0xb, 1},
>> +};
>> +
>> +void guest_verify(uint64_t tsc_cycles, uint32_t apic_cycles, uint32_t divide_count)
> 
> uin64_t for apic_cycles?  And maybe something like guest_check_apic_count(), to
> make it more obvious what is being verified?  Actually, it should be quite easy
> to have the two flavors share the bulk of the code.

I now plan to drop this function and instead just open code the
checks in what has now become a shared function between xAPIC and x2APIC.

> 
>> +{
>> +	unsigned long tsc_hz = tsc_khz * 1000;
>> +	uint64_t freq;
>> +
>> +	GUEST_ASSERT(tsc_cycles > 0);
> 
> Is this necessary?  Won't the "freq < ..." check fail?  I love me some paranoia,
> but this seems unnecessary.

Sure. After needing to field reports from static checkers not able to determine
that a denominator can never be zero I do tend to add these checks just to
pre-emptively placate them. I did run the code through a static checker after making
all planned changes and it had no complaints so it is now gone.

> 
>> +	freq = apic_cycles * divide_count * tsc_hz / tsc_cycles;
>> +	/* Check if measured frequency is within 1% of configured frequency. */
>> +	GUEST_ASSERT(freq < apic_hz * 101 / 100);
>> +	GUEST_ASSERT(freq > apic_hz * 99 / 100);
>> +}
>> +
>> +void x2apic_guest_code(void)
>> +{
>> +	uint32_t tmict, tmcct;
>> +	uint64_t tsc0, tsc1;
>> +	int i;
>> +
>> +	x2apic_enable();
>> +
>> +	/*
>> +	 * Setup one-shot timer.  The vector does not matter because the
>> +	 * interrupt should not fire.
>> +	 */
>> +	x2apic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
>> +		x2apic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
>> +
>> +		/* Set the largest value to not trigger the interrupt. */
> 
> Nit, the goal isn't to avoid triggering the interrupt, e.g. the above masking
> takes care of that.  The goal is to prevent the timer from expiring, because if
> the timer expires it stops counting and will trigger a false failure because the
> TSC doesn't stop counting.
> 
> Honestly, I would just delete the comment.  Same with the "busy wait for 100 msec"
> and "Read APIC timer and TSC" comments.  They state the obvious.  Loading the max
> TMICT is mildly interesting, but that's covered by the file-level comment.
> 
>> +		tmict = ~0;
> 
> This really belongs outside of the loop, e.g.
> 
> 	const uint32_t tmict = ~0u;
> 
>> +		x2apic_write_reg(APIC_TMICT, tmict);
>> +
>> +		/* Busy wait for 100 msec. */
> 
> Hmm, should this be configurable?

Will do.

> 
>> +		tsc0 = rdtsc();
>> +		udelay(100000);
>> +		/* Read APIC timer and TSC. */
>> +		tmcct = x2apic_read_reg(APIC_TMCCT);
>> +		tsc1 = rdtsc();
>> +
>> +		/* Stop timer. */
> 
> This comment is a bit more interesting, as readers might not know writing '0'
> stops the timer.  But that's even more interesting is the ordering, e.g. it's
> not at all unreasonable to think that the timer should be stopped _before_ reading
> the current count.  E.g. something like:
> 
> 		/*
> 		 * Stop the timer _after_ reading the current, final count, as
> 		 * writing the initial counter also modifies the current count.
> 		 */
> 
>> +		x2apic_write_reg(APIC_TMICT, 0);
>> +
>> +		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
>> +	}
>> +
>> +	GUEST_DONE();
>> +}
>> +
>> +void xapic_guest_code(void)
>> +{
>> +	uint32_t tmict, tmcct;
>> +	uint64_t tsc0, tsc1;
>> +	int i;
>> +
>> +	xapic_enable();
>> +
>> +	/*
>> +	 * Setup one-shot timer.  The vector does not matter because the
>> +	 * interrupt should not fire.
>> +	 */
>> +	xapic_write_reg(APIC_LVTT, APIC_LVT_TIMER_ONESHOT | APIC_LVT_MASKED);
>> +
>> +	for (i = 0; i < ARRAY_SIZE(tdcrs); i++) {
>> +		xapic_write_reg(APIC_TDCR, tdcrs[i].tdcr);
>> +
>> +		/* Set the largest value to not trigger the interrupt. */
>> +		tmict = ~0;
>> +		xapic_write_reg(APIC_TMICT, tmict);
>> +
>> +		/* Busy wait for 100 msec. */
>> +		tsc0 = rdtsc();
>> +		udelay(100000);
>> +		/* Read APIC timer and TSC. */
>> +		tmcct = xapic_read_reg(APIC_TMCCT);
>> +		tsc1 = rdtsc();
>> +
>> +		/* Stop timer. */
>> +		xapic_write_reg(APIC_TMICT, 0);
>> +
>> +		guest_verify(tsc1 - tsc0, tmict - tmcct, tdcrs[i].divide_count);
> 
> That's some nice copy+paste :-)
> 
> This test isn't writing ICR, so the whole 32-bit vs. 64-bit weirdness with xAPIC
> vs X2APIC is irrevelant.  Two tiny helpers, a global flag, and you can avoid a
> pile of copy+paste, and the need to find a better name than guest_verify().

Will do. Thank you very much for your detailed and valuable feedback.

Reinette

