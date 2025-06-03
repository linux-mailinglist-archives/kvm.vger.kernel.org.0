Return-Path: <kvm+bounces-48341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7BA9ACCF31
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 23:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 681E23A4B72
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 21:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF2223BCF0;
	Tue,  3 Jun 2025 21:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F7pT4hOA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3327081F;
	Tue,  3 Jun 2025 21:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748987181; cv=fail; b=c0syflZdv7Z3mJZMm0Eg3Q9baCj6yktcIzsyI/SPfm8tp8+MaSBpM61O2MJ7xZTTjDIKIpzx4RQe+ghEicZSxkpciqayd7xdfLgrSHGtzvTJF3LTs0C4yRZRgl6uNSTW0ZsxIvrN6scc2zEdCbDRSNhXVTE4+wClJ8tGvD6ZPPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748987181; c=relaxed/simple;
	bh=+s3oEPnhPP12ltG1k/vj5TK8mrXa26iAEwDcvHQT3cA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=K7OGRNW31wSZJYhN9A/Re51VDZ6KJOfvw6/+HSnxbTwuzcnC6SD0nsMA5ieIiEqp2Y3sQui7dvxCOsnZZ1r0z/+ikUrKcJ9nSzbJWzfVuWMMmRCUt4l6jcXXz+Zyil38PFoA77enYPeGPqYhvQJhZgSQE+FlCz9VwpVS6tBywyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F7pT4hOA; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748987179; x=1780523179;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+s3oEPnhPP12ltG1k/vj5TK8mrXa26iAEwDcvHQT3cA=;
  b=F7pT4hOAnapZXOr9itdYPL4uErsBGSiCj9o3zYDeYcujIwAAzSVcN9M7
   66sy37epbpiMFldIijh1vJBa+Rv2C0aZOFYgNCLGQ9JbyNGhpjVHOkgCZ
   P91GOlIRkQMdEw8ENs/iYqEDomuhZncX2F7jUztcejZE+Ro6FWk3uqfwe
   dCuXoQK4L1foCfju/qQmrjnx3/gZHm9UUclL5csd2/w5UrLSElm1mhgRZ
   J2dbUGexMFU00nySLfXCyn8P4AuBoi38LJQ41m/TDZIHczknlfyRP2v5a
   ELGUd+h2JRuPJoYlsorTsuqKpjX1Ee6l2iTNtZoMdw6O6SrUsbAIw9pGp
   A==;
X-CSE-ConnectionGUID: 4xcYD1L3SeSbFAFd4XolAg==
X-CSE-MsgGUID: T/4P8+ZtTkijxeaA97Rsaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51119041"
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="51119041"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 14:46:06 -0700
X-CSE-ConnectionGUID: Scwh9iQISv269vV3LAJfjQ==
X-CSE-MsgGUID: pYFarQYiRwiXLkVLXvi+rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,207,1744095600"; 
   d="scan'208";a="150034636"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 14:46:06 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 14:46:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 14:46:05 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.69)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 14:46:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AiTR632jbYUdLSMFQH0KjCofGD653eSXguEPHG50WGPfJ796Pz0529eCZ6HL0gHixbrr8my3Nv5OVlItUDIutLML9isa6f6Gzc7pBaN2QG7sTUaVJHz0oAfQqiSub3fDB6ctD6bUTiFcfdsHVnC5aWUmEvreB14qj5AHMswpsji+MBJuKmFdVBMQiYew0ujgMYY9MK2+E9vgvhz/5tHJ4up59882IBQnbI4RvWr1t1537HosKd1g4IAoOafHWsksOWTRgvw6sb2CmTfaiFtOYZXKPjQyEO8mgU5jFVVV3YzPTeoH9UPLPvL9JFAMOkAZqtWsyv+xNluHc67seUvrLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FuzG6+0pSiZtwM8TYusfbPxlF9adFlqtl52wpSJ9G6o=;
 b=vmUNO229tYuXLoFCBWY8dtzLyeH24/XVV97oYB/87zkmj8PINI9cw8zTMRmD2Q6SH9QBw6eqiGmmvaJYBDV/VS0FFL7GE73wpUoo84V+USpXWotiKJXnKJqdxj3cZXZeyjmzWAUSFh6nGfKXI2D7wTubjnQzRMXKtWr2VJpb92GwlsVyovDdVGMoU9dr3XKI+1xTg5Mp4SCUXyjjDxCxYHhYwMgl7qC3QEbWW85AkHQ+tUXgPBkcxfkIecR9kS/ETL/7C6dvK8WUTyd6Oa00cUf5O4m07/yLnNrlKDTrECvVJhaiwyW9V35xTvzBfw5xrLwSoXN714mEtocp04JuVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by DM3PPF4AE904FD9.namprd11.prod.outlook.com (2603:10b6:f:fc00::f1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.37; Tue, 3 Jun
 2025 21:45:49 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 21:45:49 +0000
Message-ID: <56a641ac-5433-4edd-9552-b31f4cc9d591@intel.com>
Date: Tue, 3 Jun 2025 14:45:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/9] x86/nmi: Assign and register NMI-source vectors
Content-Language: en-US
To: Xin Li <xin@zytor.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>, Sean Christopherson
	<seanjc@google.com>, Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
References: <20250513203803.2636561-1-sohil.mehta@intel.com>
 <20250513203803.2636561-5-sohil.mehta@intel.com>
 <9950dc5a-05ab-4a7c-a4e8-34012ef98549@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <9950dc5a-05ab-4a7c-a4e8-34012ef98549@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::23) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|DM3PPF4AE904FD9:EE_
X-MS-Office365-Filtering-Correlation-Id: c972fd9f-5b05-4e5d-b552-08dda2e80117
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cUV4bHNvV0RIY3g5Z2VvSjdhWDl2VEJtdkZDYUw0TzZCSUVxSEZjVG90MXgx?=
 =?utf-8?B?TEtmZnJLdkdNQXBuK1RvKzd3UzV0ZVFQRVppcGlHdHFoSXZtOEEvZFVuK0pT?=
 =?utf-8?B?NjUvQ00yTlRkTkxZMEZWckYyeGQ5R0NmSXdGVmFBUUpxcU9SRXk4bUdZM2tU?=
 =?utf-8?B?blg5MVFoSFJZRXJjY3BsbEExVDhLVFNuSytTVUY4Wlk5aGdQU203SHJJTFNS?=
 =?utf-8?B?dkZHQVc3NjZReGh6NG9XSUFaQndKSDNRVm80aHFhL1Y2Qlo1amVDajdCcENL?=
 =?utf-8?B?ZGhqK3YzUk5CeVZBc0E2ZEFkbDN3SDNmUWQyTWExb2l2OEE5aHVPTS9RT1NI?=
 =?utf-8?B?REdzVnZTOE5hRU1PUjVTOWlya2NSQ2U5eVhkeUp0ekthaElJMUpmQnB3dGtB?=
 =?utf-8?B?K05NZ0FVcXpLcUlmck1wRUNkaXk3K1hPZDdTN2hnRnNCa0NRampRTlV5dE5j?=
 =?utf-8?B?aG51YU1pWEw0SmUzS2wxYzhTa3dYR0FSYUNHMUZaTHNBVXZtZ3NiRW5iMFdp?=
 =?utf-8?B?VmRlZXJuWDZENDF0dkUraTVYY0NkYzBLSmNHck5zMWsyd0o2bjJrU3Rrc2xt?=
 =?utf-8?B?RVJyUDBWTWZPa3kwQ0RTVGo3YTlDbHkvdm1JaDBIekoyTUpLVlhkR0NPRFBa?=
 =?utf-8?B?Yk9Cc2kwcWt3cEhPbnFFbHBmbjRRaU5UV3R3TDVtMzlBdmk2ZFk0OTRoQjRm?=
 =?utf-8?B?NW9lUXBwWEZOc2g2eHQxYmhHR0pobUxFT0JFSW5SaC9HUmZ5YVd1NnlwdTlk?=
 =?utf-8?B?K2lFdHAralIxZWZvODFEMWExN1lPSTIrNnc4YnQ4RmxuZWowaldRQkVURzVU?=
 =?utf-8?B?cFc5NExjNVRoNWdaT2taTnFvZnZvOGdlekpyMDArTjA4dERMUStLQmxiWHlo?=
 =?utf-8?B?R1hnZVBNdFJiZGJwYXkvYzZQckUyYXJpM0NhUHVGUy9YQS9pNllDTzJUd3Vr?=
 =?utf-8?B?ZXpaT0FFNWIvMkdHR2dwZGs1NFk4TVF0dVdVNEsrVFVlYXUrbkVSOUtpeThW?=
 =?utf-8?B?dEk0bjVPU01rTnd5c2Y0WnljMy82cXVKcmd3UGt5OHJUZG1vTS91dmhKWjR1?=
 =?utf-8?B?eEFGNlJpMlE4UEJHK21XUHJhazUvZU5UNFNJY285RXp2MC9BQ05XMzl3UnRY?=
 =?utf-8?B?TU9JVUhIeG55TUpOY1NodlMxOWowZENmLzZkVzluNUVWWTVYc3Fad0IyR1Vu?=
 =?utf-8?B?bm0wRS9LZnJOeWlPVVRiZWhRU3FRT0NIUGVMUE9EbWJPbjJmV1cxTGtJMW9D?=
 =?utf-8?B?UHppNGVTanIzdHNUQlBBcWFMOUp4d2lRc0xscml1MHdrRktDcnArRFdMeCt5?=
 =?utf-8?B?N1RWeG5zYXYzZjlVeXUxV2dxSzg4M1pFQ1p3Ujd4d09FOVJhVEUwc24yZkJ6?=
 =?utf-8?B?SFdiZGRTL3ArRGpJVUlDbGE2ckppRzdtQ2tQcFJIc0xCSVB6emVXYzN4bzVQ?=
 =?utf-8?B?REFJZkRXWGJPWXFBOExqQ3ZlVXJtS0EwdVdpNDQ3eFo1NW1hQldPSlBVNU9G?=
 =?utf-8?B?QzNBRGJtNUlPMDE5Q2JzcS81UDF4SndsazdkQ3Via3JETWdYcmNrdWtUNXZT?=
 =?utf-8?B?MUQ0c21OQjdteDlxejk0QnBFUlBWSjR6VFRPdk96cG1nOUlOdzd5dWtVcXJV?=
 =?utf-8?B?ZFJMUEJZWmk0OTN1Wm4yYkp2RHZqMEFnenNLMkVOZENma2ltZHhRRTJaRWlN?=
 =?utf-8?B?azhybUJocHZ4NmUzU29jampSRkdvOXpOYUlJWG9HNnhLZWpZNm5oZkY0V29k?=
 =?utf-8?B?STFGMDRzOEZsWThKWS84czFiNVlFUGJZQUh6Rzg5TEtzOGREbTZDUUFQd0hK?=
 =?utf-8?B?b0tzQSszK1N0YlVsbVlSOHhUWjl4UzVWWmlIQlpnZU5qU29abGxZYWxzRW1O?=
 =?utf-8?B?VEQxdXVrVmlqU2VsZ1I2ME8xWSsxWE12WkxENVZ2aFJjUms0N3JIT0lmT3Nl?=
 =?utf-8?Q?h2zqidI5ZD8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVFraG00d1ZaRWRRSWZsdk1RMHJpYUsxWXYzallaWmV0Zi9GbWNjd3VseWVV?=
 =?utf-8?B?aGYwL0dWYzN6T3B6ejVnRm9DOXRmZ2daUFlEYk1nZ3RrSjhvOFB6MjJMOG9i?=
 =?utf-8?B?UmxrUTN2R1B3YS9YZExEMm4xSUU5elUxRWJ1V2laYzFpeXdvdDVzQWQ3RVdK?=
 =?utf-8?B?U1FIOWtPOS9qVENmKzFpNzlvVlN3MGNBcEZqYzBDNm1vdHhYY0VuTXVHaDlO?=
 =?utf-8?B?cE1xTW5BT05UcUVyM0dQNkNyaWxWcHRkZURxYzU1dGQrMTNieVJMSVN4Vk44?=
 =?utf-8?B?WS8vYmRBTVdidzBmZXpUY0xRRTkvd1JlNUVVelc2TEdsTVl1ekRLYXFkVS8z?=
 =?utf-8?B?dk8rdVcrbGVTZCs1eWRBalAvNFVqbjZlZzZtcXBHN3hITGJ6TS9RcysveUF5?=
 =?utf-8?B?SU43RS9XN1BabllwU21tVGVkRVcrVlRCOExBSEUxa0tISDFkOU82cVBmYjBm?=
 =?utf-8?B?TTlSYVVHTFA5RXgrSk92UUh5NzRMdWE3L0NrRldQUnNqYXorcHBwc3ljV0FG?=
 =?utf-8?B?ZUdLMnhranFWZFFvcGoxdE5jOEFxR1FDSHVITGdudFVySlNtQlB3UEVsSzZt?=
 =?utf-8?B?S2NsSzd4VDdxOXBxaDE5TENrU1JyYldRdTRyelRRelJzSlZ6d2dwNzNpNXp5?=
 =?utf-8?B?aDhFbUlVUlBZRklEL1JDeHQraG0rTWJkNDE5eVJHRVk4ZklUMUd6RGhmVVly?=
 =?utf-8?B?NUhtY1I1UkFmVVR4dHJKanBiNmlHeXJXbTZhS1pKa3dETEdDQW93ejF3dGFN?=
 =?utf-8?B?RkZlcjJWUWE3YkM1eHA0U1E5UFZObmVTR3VQL0l2Q2t3RStWOUZMSm5JQlJC?=
 =?utf-8?B?RVVmVUJWSExmSjlGZmtBMTEwb1pFQXpoM3dFREVUQWlPSFJIWERkT2pycE1v?=
 =?utf-8?B?TnhsMFZJQ0Erd1FLakthNSsrMEQydTRKZDhPR2RKWjRJdEswWXFpWE41ZVk4?=
 =?utf-8?B?U25uWnlUWldHdXJQMnZtaVArazFqa0wzVU9nUktUWllFdkZHOHA4T0t2WXFo?=
 =?utf-8?B?YkRrRzl0L0tENHdqTUROS2hnVHFqd3Z3RzFUR0FGU01mTDBlb2RxNEo3aU93?=
 =?utf-8?B?N3d6SEUwNWt0OUw5cEphazAwTHVUVzI0NTA1ckt0ZWlmZzNTM0FMcHpGc0Ry?=
 =?utf-8?B?ejRxTk1iQkt3TnpvTVk4VzEzTDFVQmJDc3VFNDdvL1ZpcGdlNE1kRmM5WG1n?=
 =?utf-8?B?djJoWjRuSWJaU3JQY1VxbjVOTk8wWEs2S1BHQUovcDg1TmlXdXRrRWc1SXlT?=
 =?utf-8?B?QzEvSmRYUXNCWkxWT3JjcjNSd21KNFZVTjRieFU1eVNHOVd4MWw1YW5ycW1M?=
 =?utf-8?B?V3c4Zkd3UTM4bEtFaENCU0pPZytXTmt1cUZSY2ZHUEdlOThhSHJDWUxjem5m?=
 =?utf-8?B?a3dkdU5lQkpLMzI0cmJ3bXdQWWQ2amJiSVFleFB3bEdCQkRFV2M5TWZwYjcx?=
 =?utf-8?B?ek04OVgxQVdhM0xsMTBIS1REcm5tUUo0Q2NVbjUxVHhrL1FEOUo3VnBxbEM2?=
 =?utf-8?B?Sk4yMU8vUDFwdGdUalQyeDR5ZmVhNHkxSUlET2FvSXNNVWt2c0Q3R05BMFhw?=
 =?utf-8?B?c0dTd0xzbklibm1mK1BhcmpNaEZCck1tanB6TGZnZG1nMzByQlRXcmUvU0dj?=
 =?utf-8?B?Vi9tTDFGMHY1dkc1V3FpSEZzMW1zdDNiRWRSbExNL3hSV1lqSHpUaEZqY0Jv?=
 =?utf-8?B?MHZlaGEyTktvcVY2dy92YmlyazhnYm8vVksrYThCRHpmYjBnbzlndi9zZ3A1?=
 =?utf-8?B?ODZnRFdZRFhuemdxSTFKdm9KaVRFNHRqbUMvVDBBTnBJeXV6Wkx5ajh0bVQr?=
 =?utf-8?B?U0w0MDNEYkZKcjloRnpUK1JjMkY5U2NwWXR0bUdES1RjeDhkOXlpVU5sS21u?=
 =?utf-8?B?eVBDYlZYWHJUSXkwRFkrVXcvdlFrLzBPam5KRENxSG5lVnFsSWo3WWFzM2NH?=
 =?utf-8?B?SVU2UklHbm52WUFHcW5ZNnhRdjBuQ1BJOGcrbmpneGdhVGhpVlBGYmMwaUFw?=
 =?utf-8?B?Qm5oK3JFZU9RRlRYT2dxZktmcStFZmF2NVVDcUNscXlsZkx2M1FPVCtLTDg1?=
 =?utf-8?B?Z0VEbnVGTjhmTkVRaVM3QUx3RlZsQzkwWU5VcHpGZHlxQk5wSzJKWmdmNzVZ?=
 =?utf-8?Q?6OTwdfn32ExzJZBHkZuPLWZo4?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c972fd9f-5b05-4e5d-b552-08dda2e80117
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 21:45:49.2319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7IfuHc0FqocWwfpXrkK1UQXrsH6+WByq7i4fg+4DpA5v6jeCblXBmpQNdpxdlKwuJAGmkDobJ/KJIEBg2yeWIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF4AE904FD9
X-OriginatorOrg: intel.com

On 6/3/2025 9:34 AM, Xin Li wrote:
> On 5/13/2025 1:37 PM, Sohil Mehta wrote:
>> Prior to NMI-source support, the vector information was ignored by the
>> hardware while delivering NMIs. With NMI-source, the architecture
>> currently supports a 16-bit source bitmap to identify the source of the
>> NMI. Upon receiving an NMI, this bitmap is delivered as part of the FRED
>> event delivery mechanism to the kernel.
>>
>> Assign a vector space of 0-15 that is specific to NMI-source and
>> independent of the IDT vector space of 0-255. Being a bitmap, the
>> NMI-source vectors do not have any inherent priority associated with
>> them. The order of executing the NMI handlers is up to the kernel.
> 
> I'm thinking should we mention that the bitmap could be extended more
> than 16 bits in future?  Or we just don't emphasize 16-bit or 0~15?
> 

That was mainly to justify the value of NMIS_VECTORS_MAX defined in this
patch. I will include a sentence to mention that the bitmap size could
be extended in the future.

We could even set NMIS_VECTORS_MAX to 64 right now to make this
future-proof. Though in practice, I don't see it happening any time soon.

Sohil

