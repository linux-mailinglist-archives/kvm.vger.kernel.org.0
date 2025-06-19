Return-Path: <kvm+bounces-49997-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4227DAE0F93
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 00:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D7A71BC3D96
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 22:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 982EC25DB0A;
	Thu, 19 Jun 2025 22:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WVbBQxgs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013B521C185;
	Thu, 19 Jun 2025 22:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750371843; cv=fail; b=AH2Coesy3qvc3XoCwxTTqupB97szbsczIhA7/wkqBxv7XwbONT636MFQNq7Ws496oJDUZAZqfrtPEKAtzWR/w7OFsf+SOB0KX0MRRPIKKDniL9gkYN+zu9JAeD+yfPTieOS1ztZ6KxphNbe9Hs1EIvDr9b9qgKQWfPwdjs0Iimw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750371843; c=relaxed/simple;
	bh=O1OWNSP5mMnmndpA5xmBWadMu0ppLDSYwKpLOkJRndM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BZax8lxa2g7nKZLdGCcZC4CXoouwHYx7DjkzrzqSIBI4HAV80WinGw/Mp71iMIT4kme9lpFPRkw3pwgDExvEjZsnJrXLvJ9PsSqszmTHM1JQmPHj7m41w+TW5TVvRaplF70aPvfGoIxow+iWJMF35TELznF166iv1DSpjp2NnLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WVbBQxgs; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750371842; x=1781907842;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O1OWNSP5mMnmndpA5xmBWadMu0ppLDSYwKpLOkJRndM=;
  b=WVbBQxgsBHkJWuYGtVN8VREegXxwBE+EnGa7NlwUnjDW+Hv2EFZWJdFE
   cgi2+poKmiv68FjOMdCPkOHP/rXW7UHy0j9vYN6fP7KRLUIdDhgk+Ptm3
   NYXmsVT/cogwTlqZVEpF0ba1TXQKscfRbEozxqi6Rx8rvabuYniJTivF2
   Ceo3Ei+0PRfOIZg7CmZm0ANK6r5rhclqKi+L5wsYKRZVBMckZRrF8WTok
   6AgxK1mKogu1DDeay4/exKfRjrpE5yAe5HS7loGgWYGP0HbQwCML0QbS6
   VZjzyK1wl9TFfNaAztnEUJfTsFy3FoSrhVoT7hIIBNGfW3pPK78ZGSXW0
   Q==;
X-CSE-ConnectionGUID: mLHTvjBNTLC6WAiunq6prQ==
X-CSE-MsgGUID: Yr9uHqdsRWyNxwEwWJ4T0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52329726"
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="52329726"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:24:01 -0700
X-CSE-ConnectionGUID: h/gJHwcdRRCYV+TZJewpmw==
X-CSE-MsgGUID: nejZCCgcQqaXCvOs5pzI1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,249,1744095600"; 
   d="scan'208";a="154759969"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 15:24:00 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:24:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 15:24:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.51)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 15:23:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gkb/A482JMWitLvWGBfAjyOi1ksRgZN4g3PivDfKZB/1Gow7dHRsZxEYuOAue99O08/S+gekgXUTAhxfltZCA+Qu9kBR01tI+88A9+dvL8xfcHGRDfyOZQbPJNehkAxzV6gqE26DIu7Zryl3fiP+5bRJuxDZn4K36zQiPfTm0kfrGUrFyLG9yg/pEY7qP1qp5Hlg3dToNaOJRSiwttqSHBWnkqrVwYDCIHQYmCr2LzIDQ0JZehLs9sP5RpReO+NV6Xs/gpQ4v3Pqdp73J8qrEYngEfbEaViQZCp6yn76xG2nBMLsUwvqari9dXoxq5fRhDrqMyex+IYB2xzIr/L/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rdcAJGVIK9u+Nttx3POFNTQdi1ePRg1LI8buWIaNwcc=;
 b=BACklUK3egDw1Wp0VqVN7L4tq/1c26jInH55Mhb4pxAnCzf0cRaCWE1cQSF82fEPKlJhskRwbkaGrvmjB6OO3uDpCcOTJjql8wCqUrl+/9TcEsbVx373xBz+crc7cP3nAPIeL27qUJ2pSvwW0wr/GbGC1l+OoiGZ7Zq636NdoM4PNFJav4hn26ph5pLm9d20NWcJUUVPCytTPLOBBs9q9mdr1EhB+lNFMFwXThzcStDfq8rR/CnRMIkOqjy0AO6WVHr2D6bTd3BIGV9aBkktlVh4KNa4911Kr0TZMfFyvvJIqAkbwO+XDe65Nvq+Tull3Yj8r3MRffE+B0R3dXyjSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3322.namprd11.prod.outlook.com (2603:10b6:5:55::19) by
 BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.26; Thu, 19 Jun
 2025 22:23:43 +0000
Received: from DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e]) by DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e%4]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 22:23:43 +0000
Message-ID: <e112848f-eb8a-48fe-b70e-2146f24a113a@intel.com>
Date: Thu, 19 Jun 2025 15:23:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 07/10] x86/nmi: Prepare for the new NMI-source vector
 encoding
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-8-sohil.mehta@intel.com> <aFO/q52D4XkzmO4i@intel.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <aFO/q52D4XkzmO4i@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0254.namprd04.prod.outlook.com
 (2603:10b6:303:88::19) To DM6PR11MB3322.namprd11.prod.outlook.com
 (2603:10b6:5:55::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3322:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 60217fa1-df17-420e-3b84-08ddaf7ff278
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YXVjWGV2TzJLUG82MVZaeDhLdWVIdStsVi9HWmRUTHlUNjZ3SWd2MTlXQnRz?=
 =?utf-8?B?dU81aVFPWVBmeUdIemZ0ZDFJQU5rV244czBQZ3QxaDRHL3BjY3M0V3hVSjRw?=
 =?utf-8?B?VWxrVVZaYWhiVWRNYjh3VjRkZEJ5b3NqUCtPdnZ5TTRNdnRLcytCZWxHUzJ6?=
 =?utf-8?B?THEyaXZUdHNGVW5GK0JyQllnZzhFdUQ1U3Q3MkpoQm4vK1lsZkVFaEdVbFZX?=
 =?utf-8?B?UmQ3M3FISVpPRnh4WGs3eGZYSEs3ZEFuWnBPY0h0REhseTYwTXlqVHg0ZXUr?=
 =?utf-8?B?dmsreU1NOG50dHoydi95OEw5dWgySEJyelo5WFRHNFN0bC9FVTNkRitLclNt?=
 =?utf-8?B?SUxBU2JVOUhYUDI0cWRpaXgyNDZjMmdZZWxCNWhaNWZaOHhTSko1aFRMSmFl?=
 =?utf-8?B?TGFBSnFvbjY1aVhMZFBmblUweTJzc0xTTGRYdVVSclhFci8wREozeXBCYy83?=
 =?utf-8?B?dTdLQXRkYUFnNzVmOGttREs5WVV0VzFyc3lxL2FUV2JWSWwwc0phWWxsK0tT?=
 =?utf-8?B?ckV3ajk5Qk1qbEtQTW1BZi9FNll4NkxIT0NqNVk3QmFDaldLaGJYUHNWQ1dZ?=
 =?utf-8?B?MEdOQWhWNFp1RmpwVXJQSGlmN1ExRnhtRFdtUjNYSVc4aWFtTDhkejVpczhw?=
 =?utf-8?B?Y0w4VzNLdXJ1a2pxL0hQTjc4YkQ4STVDc29RWFVTNVVPdEwwT1dFSDk2VnRN?=
 =?utf-8?B?MFpzbnVnYkVWSGFlVkdmdlhUOVpxQ2JEY0hmd1BjTE5NYTFSdS9TbWZFT2Fx?=
 =?utf-8?B?cFpvUkJRWmVFdnpJdjJHRnVsQ2NsSm9KR3hTUUdjQXNZLzJBWlpvMlRGTytx?=
 =?utf-8?B?TncrdWNWbWdMQURJUDhadjRUOS9DMmtGQzI1MTZZaXpBcUdBTWl1c1hWbHY2?=
 =?utf-8?B?Q0dlZFJBUkxQT3BBNTA3ajlLYmdUM21mMjJ4VWhQR0tVakZ3cDZabVlORDJk?=
 =?utf-8?B?MHBYN2NtL3dJTmlEVFRFT1FXcEdyTXl3UjI0M0tVcEJkOW9YM3JBSG5IYlRU?=
 =?utf-8?B?LzJXaHFURWw3S3gwTFN0aDQraVhVenZYN3RqaEc1Uzcra1JzY0MwNmF0YTJw?=
 =?utf-8?B?eExrSFIxSnBTWWJYMGVQS01zRElycHV3SHJUaksyYTNYT3VYTWVtbGdvSXVB?=
 =?utf-8?B?bFlDQUtjVzl0YjVGUnlvTHhmVDRLQWIyRFFSeTR3bU5SK3hYZFYyVm9wZHpq?=
 =?utf-8?B?UnYyNGFta0paVXV6ZGNXSUk1VTFERFZnSUkzN09UaW9IZnJ1cHJHbVRNWnFC?=
 =?utf-8?B?blFJQTFiZUhEcm9iL0lqOS9LN3dKWGV1aXdBVFdzVmdsS0g5dHBCN0NJOVJz?=
 =?utf-8?B?RGJyek1aMExZb044czNrL2wybHcrRnZYdFBsTzFGQXpZRFo0R1VNdG9KandU?=
 =?utf-8?B?RFFtWkZNcXlUYzhhNVpNZk53Z3d1S1RQc2J3eGlublA4TkxlVkRyTXZOaFBZ?=
 =?utf-8?B?VjdzYkxmMUxOK1B3VExKdGROK3EyaVRLRGZUeU5iRDdmaE9UL2RocEVidmxz?=
 =?utf-8?B?cUtFRzdWQUJaUElqOHo1b0RVMkZuRjQ5RWtDNEk2ZyttcG14WXExbVhpdUxp?=
 =?utf-8?B?ZXliS05xNFovYVRkZUlCdEFHSi9vN1NKNnhxQTJ3UGlVZjRPajdtakp3UUor?=
 =?utf-8?B?Uysxay9RcnBnSDFVVnRYWU9iNzNTVXpCQ1I1aE5NNENCbnVRMFNBdWd4QjRw?=
 =?utf-8?B?U3ZId29tQm0wRnJ1WHFrSnh6TTBNVGZuRjhXRFhMSGdvOTFuSDhnMW1ybGVj?=
 =?utf-8?B?MG9BaTlNRkdxd3d3SFRKNDdIUnVjRmJBbjczcUJOVFRIQkF5dG11b3l4OTdX?=
 =?utf-8?B?Qk5GQmFnSHFRSCtISlBqbXZ5MUhyZXpQVlFGdWxFWmpQQTVyOGU0aTE2dXBr?=
 =?utf-8?B?YXJlY2xTbHZGZ1Q2dGxMZ0VlNjBFa2YxZTYwMm9DcGpuNnc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3322.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q1dYbVdGMlJ4RVFuam04MzZoV0Uyc0Q2NlRlQzVwelUvNm90QWo4VUZKUmpC?=
 =?utf-8?B?U3Y0NWh5ZU9CZ3RHTUNRbi8xRlVDcVdVVjZBd1lrd2g3VU5aZGFlYWFBcCs5?=
 =?utf-8?B?OUhqUmdjZXd3WC9rbWI5L01rTC9nOTE4MHkzVWd4cytiRVhIUmNHTjNFaHZX?=
 =?utf-8?B?Q2RXZWh3MFBXYWxJajQvUXJvd2dHVWt4QUVLOXUxajM1QVR2b09jWkk3Qlcv?=
 =?utf-8?B?RDJBdTZkMUxlMmJ0MlFqMldOUFF4cnZmZnJhVENvNDNuSXFTanlTTFpaNzVx?=
 =?utf-8?B?VXBMY043bW1zU1B5N0VVc0lwMHhka0Y1UmpxRnVTdHJzUXdtRStsQmtGbkRh?=
 =?utf-8?B?UTdUdlNtOGlaeHFvZ2txaFQvdDBhdTZhcU9JWVp6NFRUaCtJRkoxQVlSWWMx?=
 =?utf-8?B?UWtyanRRVjk2L3pDQmN1MytuQmgzaTRReTF6T0EzaGV6OFA2bi8wdUplSkRU?=
 =?utf-8?B?RFF5dTlwTXhIWW0wRS9GKzh3aHk3cmFwbm9HdGV3NFl3WHNsOEYyUnJBV2hI?=
 =?utf-8?B?VFJSMzVoWFRBS3JyYlgzOExFZnRlVGJOZkFneEJSTHVyNTAzYlM0VDFhS0xK?=
 =?utf-8?B?c2E2eEVFU1lBeUZLRjg5cUtaZmZSOGo4SUYySTVwNnRHd0RZTDczZEtWZklu?=
 =?utf-8?B?ODMyZG9nU2Zhd05RaFd2ZTBLUVJTbHA5WHRBNlZVTSsxMlNkbndqN2krbms3?=
 =?utf-8?B?a3pWOUF4anBKK1NjdU1oeWFNcVVmcEc2YTdGT2VERlZDeEVmRzVVak5ycC9u?=
 =?utf-8?B?eXRrZXUvN1JjVDJPVXFiWlg3elJQandnUzNpTDhwNTR3N1d5OHpCdnR2YXdr?=
 =?utf-8?B?S1IrSEZRVmxPWVhibUtaTFRQU1QrejhmamxKRTN2RjJHQTloZ3l5VU10Z1N1?=
 =?utf-8?B?U21XNkx3T3FjYXZQVlh0MjArNEhvK0hDam5ITVprNDZKTmtXRGdncEozb0Ft?=
 =?utf-8?B?RE5IeVlPUGdCYkJjaE9kVlBPZXJyS0RucVc4V0R4RGVPZ1p3V1crOXBtRUlF?=
 =?utf-8?B?L2FaZVFSZFhhUDlTSXlXcXBpZjJ6bU1jTFlMNzFjVkVwcUpsb2kydnBmL2Nr?=
 =?utf-8?B?MlNJaWJteTJiMHpUVHl4L05TN3BvWS95T0xXSUx2QjVJODUvVVY5SWdYK1h5?=
 =?utf-8?B?dkh5LzEwdjVuUHRtcUExUlV0ZEpIWGpoclZibTllRWVuUEF1S2xtU0EyaXoz?=
 =?utf-8?B?VktTVFA3dWpMNERZUUI5b2Fobit2NVMzV2RCS3YrdXVPeFp4ajlkaUhhZjhP?=
 =?utf-8?B?bHlmako5eEJyekQ5eno2RloyMXNJRjlpb00wcnJVc1NGdE02TEtQVlYyZ1ZJ?=
 =?utf-8?B?dlZjYUdCVndZWXZ3dUdVNjRtMThEMGMwNk93K3I2ZzJTNEdaeTgyUUNzYzU2?=
 =?utf-8?B?cnlnRXNLRmIrVDRpK3h6SFdOWlltT3MrYWx1eVZGZlVuOTZzckMwUmVvM0VH?=
 =?utf-8?B?dkdGQlNXa1ZYVWk4MDJVbmdNQVB5QW9sQnY2bTE4c0lRMVpGb3lkcEx0dnMv?=
 =?utf-8?B?U0dMM21YWnpJRU9VTngyMGVYeVArbTFSU0ZsUzd1QkNLK0pCR0FNemNObGY2?=
 =?utf-8?B?MzNndXJBeXB4Q0xySmgzM2MzNngxQkp1eFpSWEpYS2xCU1hkSzJkZG9aM01i?=
 =?utf-8?B?KzM5WDBnWFVrWm1DWnQ5cTMzdTBxMUJKelhRejlwKzJjNUp1N2FuUW5aZEIr?=
 =?utf-8?B?ZjZHbU5hMFdtcEtRbENDV1kwMDAySFlHU2ZtbEU0eDFrb2t0YURwb2hQdi84?=
 =?utf-8?B?WkRTTHFNeUdicWNLalVMRW0xcGJWRlA4TU5vMTdWU3psbkxkbHhGYk9IMTRr?=
 =?utf-8?B?UEtDKzlsNmhQNExyVFRpc24xcmxzM3JveEFUblh5MFhoZnFqWmFhZWxrRFJD?=
 =?utf-8?B?RGJRaDZjdlFPTmNjZTVaRXFKN2tJOTZQMlRlZmhLbWY1WG1RT0xxeVlMd05n?=
 =?utf-8?B?TDhJMVFmUXZ4b25SaCtmcXdqZ3BoaytrOGhEOE9Eb3ZkelF2blp5b1NURjhk?=
 =?utf-8?B?N0JReHZLYVpnR01MVTM1SEY5U0hkM2hNTHVwU2tJZkZTUjJKb0F2S2w3SnB2?=
 =?utf-8?B?TFJEZkVkdThvT2ZtOExVYjE4YVR3Qi9yblM0UnhpMXA4MWdodUd3NUl6b2Jq?=
 =?utf-8?Q?JRejmwyAYwLFwQH3girVd6BUa?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60217fa1-df17-420e-3b84-08ddaf7ff278
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3322.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 22:23:43.4035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YwgbnPR2SCiKADxRtTptAFgwdT681BaQo4PxDjdJvjvRWXY+Lq3NnOFmwJYOPOKOC0zmCavdn7vECSFN9G8oRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com

On 6/19/2025 12:43 AM, Chao Gao wrote:

>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: Xin Li (Intel) <xin@zytor.com>
>> Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>> Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>
> 
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> 

Thanks!

> One nit below,
> 
>> --- a/arch/x86/kernel/apic/local.h
>> +++ b/arch/x86/kernel/apic/local.h
>> @@ -24,22 +24,24 @@ extern u32 x2apic_max_apicid;
>>
>> /* IPI */
>>
>> +u16 __prepare_ICR_DM_vector(u16 vector);
>> +
> 
> This seems unnecessary. local.h already includes asm/apic.h, where the function
> is defined.

I added this because 0day was flagging an issue with i386 allnoconfig.
But, thinking about it more, I'll instead move the definition of
__prepare_ICR_DM_vector() outside the CONFIG_X86_LOCAL_APIC section in
asm/apic.h.

