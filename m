Return-Path: <kvm+bounces-59958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AF5C2BD6DBD
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 02:19:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F1704F4381
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 00:19:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F5702D248C;
	Tue, 14 Oct 2025 00:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lHfZOZDh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEFF42C324F;
	Tue, 14 Oct 2025 00:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760401137; cv=fail; b=qax/guR1Lm2mWbu7xLT/xUo5BP5nJAAWcQSGVlTpaTMxvy7okwwjyUUSJcxe8EiZMGTVHWg16jS4OtVuL7vMY964qSaQ27eaFINNF0SFCgI+EirUrfnMb7Cjk58JXOPt3PH1Zk0acsfxNp1DmcN+T8Rf1CusOfWxKyqvWMucSRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760401137; c=relaxed/simple;
	bh=C9rvLNgJ5E0MjrL0VloSlgpTdFvfHlXtW48Ip055p90=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=qti+CmvucuBY9F/cKCyehR8NnQ/ZHk7phtT3Gz6BGcI5MKmVb6pMLqbyZM024jPR5ELMaLqH973G5Xvovnq5jX4alCLSmQkMRFOSAmzyGsMARcltYpfGjaQNVEtXQsHHGGRDNIFpLDhsw7ynFsn7c6x4VKEKcpCG4Ft6s06+3d4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lHfZOZDh; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760401135; x=1791937135;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=C9rvLNgJ5E0MjrL0VloSlgpTdFvfHlXtW48Ip055p90=;
  b=lHfZOZDhLF4FlwSwonB6QBbst1huUcZqt3HXvBX8tQmsRXxJ3xSJoh+C
   AEMCLPMACiEz9Xj2QDA+cXjwIDpX7Yl+jFxYfpd2SrJmegosPvKumfdAt
   1bB0ttRX/FzRF1lpR6UvFDmBrAMV5KKAqIv/unR3Im4f50mENYAKvwyFN
   AEgD9N2oaAg35hRw1dYcNU8aP11QtiZUQq/WaEY17722FWkLf+DyqVQGh
   zQ/8bpJ1w99DSM/o/srn6msK1/DhiL8W0aN3d54C3QN511mdH8K2Az8BF
   6q2KwDJut0dHzIroRDgUyvB5akw5soVYrXuDRLvd5/p4v9sh/Pk23H38t
   g==;
X-CSE-ConnectionGUID: YfsqqfIoSHixtUrPlA1h3A==
X-CSE-MsgGUID: rsLdTdm6T5G9mPZwUlPXmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="62589012"
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="62589012"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 17:18:55 -0700
X-CSE-ConnectionGUID: d8O5YTq8T+WFv0/Nq+mfrg==
X-CSE-MsgGUID: +hHH2Qf+T+WbPZpSlL3Uzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,226,1754982000"; 
   d="scan'208";a="205431366"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2025 17:18:54 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 17:18:54 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 13 Oct 2025 17:18:54 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.62) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 13 Oct 2025 17:18:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XyXHMmQ3VOYrIgQ0cKKc01BebdTMSlhqIYS858TAHQhkgKXwhaXPEtIMQkM2OWlOjEuifZX3YqQL6OcTJ3H8UpmGUBqqSYeo5+TFKvaPlxJEkXKnk+FCAqVgRKsBatBRoaAvUUUOfgHx2Rsk3d+sIDGliOXiBlLrIL7X2feVVXcCLN20GfDRL3pXwtW74vWzMHmh40DTk9v0l7CR8arZtawje4WAkmWZrUQZ8/cXpPrjJb/tLF8eIX+U9YrX26CabPQMzafAIF7Po+O7rwsesDOlrvtlIzxVTYD6fA4UrDBXJaIAVVDOQhY0xbIpB10grkNM1kLvpWZ3TNnycNAgAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nkah1nJoso3HL6/4hdVQij1+CkFwauf6P4dxO2N2JWU=;
 b=T7L1DW6dhbrbv+FfnI37KK0LJch4DZVd6ct5yalVucMV7cijjy72Hrm6PPQbj7YxfioAGSWnviBEixbX2NzPc6EEd3ZtRopKQkUqNUokbEq5XgX2tmtRX6Q5t4zW+Rgn3wpjWo8wwcwMbntDShGHJzg940J0yczLMqqnRklHLKrOqT9J5Nxp9dIE14elLUnluEcxyYqqhXtVi7JW7O7zvkFg9YtnyXtHEBQX4S4vN39QN7b4DgArkf3elOgbcHQNYhYxYspuSzUwfunPCo4/8/Ygwz+igzEW4nhH+eau1zmKbAMfTQDPt8xOSJp5E7FYPgI9TduVvgLEG098vIeRSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ1PR11MB6107.namprd11.prod.outlook.com (2603:10b6:a03:48a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Tue, 14 Oct
 2025 00:18:51 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 00:18:51 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 13 Oct 2025 17:18:49 -0700
To: Sean Christopherson <seanjc@google.com>, <dan.j.williams@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "Kirill A. Shutemov" <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>, Xin Li <xin@zytor.com>, Kai Huang
	<kai.huang@intel.com>, Adrian Hunter <adrian.hunter@intel.com>, <aik@amd.com>
Message-ID: <68ed96e9bd668_1992810019@dwillia2-mobl4.notmuch>
In-Reply-To: <aO2QJ-YapvJXxE1z@google.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <68ed7bc0c987a_19928100ed@dwillia2-mobl4.notmuch>
 <aO2QJ-YapvJXxE1z@google.com>
Subject: Re: [RFC PATCH 0/4] KVM: x86/tdx: Have TDX handle VMXON during
 bringup
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ1PR11MB6107:EE_
X-MS-Office365-Filtering-Correlation-Id: 60bc1533-fe8d-477f-976d-08de0ab74072
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TGQ0VUlycUhCeFN0eHYxN0NwN3ByZ0JkcGNEUkJCbmFYZkxGLzJncDFHRHo1?=
 =?utf-8?B?ZXd5VE1FTTZNSWs0NkFMUXdQcWZxR09TQll0azYyQVEyQ2trNURMS1lzT1ll?=
 =?utf-8?B?ZTJ5dHkzaHlOME9HdDFPRm9xMTFvb2FYMGdpc0tOOGZ3clZJMTgzdjVVSEhX?=
 =?utf-8?B?TGd2YmlIMXdnckZhTm10alpzRlhod01rTzl3S1RqUXd6NWNIalArQzcrRXly?=
 =?utf-8?B?VjVtUjYrM2NRd0tPa0NrQ2dHRlBkTmRvWXJWWVRIU29pU1NlcFFzblJqMk9L?=
 =?utf-8?B?cEZxbWhpQllUTEVidVVhbFZ3ak1ZbTFYQVo5NElJb1RmOElvdXFMb0RwV1Jy?=
 =?utf-8?B?bW1KZzFLY0JLZ250Q3FNbXdyWnRiSndEV21mam5rNmtMUS9NWUo1aUR5YzBy?=
 =?utf-8?B?eGZuVlU3ekZRbXIvcEVMQWpHcEx1bFRjRkx6dVdScDRnWDRDWkwxa3ppbWM3?=
 =?utf-8?B?Mmh1cWdUc3RrcXhDWVI2VkNNbVc3bWRpRlZnZ25FN2lDN3lYdkx0TnQ3aWlh?=
 =?utf-8?B?cjRjclFkeExidExFWldSWExteFhZQ3dwa292QzYzYUxCVGdITUpRd1JkYnk4?=
 =?utf-8?B?S2w0RjY2Y2ZaRjIzQzQxQzdySm5ucTAxbFEvV01XcHYwMTdna0VJWkF3TUk0?=
 =?utf-8?B?T1NkazRPN2JWUVhSK2tFakhwRmYxVmcvbDZWbUkvbC9MaGYwY1Y4NVpZZjFG?=
 =?utf-8?B?U3Jnd2JTZkdzNDJVZENNWkt5bXZwUHB2UnhnVDdqMXFWUmRDUzh0a05WM0FN?=
 =?utf-8?B?OXZZREVtVHU4ZXUxQi8vNFF1bXZ2YzExSkt6M3hEVGZPL1ZldDRKWFIxeC8x?=
 =?utf-8?B?Z1hiS2ZPYWdGSi91ZXZCYXRkU0t1bitEYlVTK2FBTVB1VUtvZkltVGRMU01w?=
 =?utf-8?B?TUdXR3JORzYxaGdVdEQrMjZsemlxekRMcUxKYVFNRnV3a2hmMGZIcVlhd0Zk?=
 =?utf-8?B?M0NwVTN1Ui9ud01jZnh1VTFFWEpzbjFjbEVGV0ZJNWVNT1hzZDRBeHovVkdB?=
 =?utf-8?B?TFdpRmQ5UnkrT2tPWnZPUks2VzJIR0RILzZ4VkluWG1WWVNicUFIZjdUTGxo?=
 =?utf-8?B?MGlrRWR1V0JjN2pzV3JSS1k3WmFYMjNuazlSMDFGZGttYTdrM1lWMXRQVmdK?=
 =?utf-8?B?RHlMMlM2d1R2RDNRY0QrNlNFSHBrZk1YMittTjg4eFpKeVdLRWVmUkNaeC81?=
 =?utf-8?B?SjNwTzRneHFNdUpxSHVBcUY0WHErWGxBL3RTamtzZ2pZdUJGaGh4Z1YzNitp?=
 =?utf-8?B?cHVIUDhndDlsc2RyejJRWTVuOHRxTjdVelhSNFJCK2VONVdraDBmYjB5UFBm?=
 =?utf-8?B?bExyck8yaVdkL293QlJlcGFyeDlDZ0N4U3JXZ3ZjUWZHWEU3UUd6NVArbVRD?=
 =?utf-8?B?WXR3bFpLcTlzMERicEo3Z0h2VFBmdkVqdmxoTnB0VS83SUc5SUU2R1E3Q1hD?=
 =?utf-8?B?ZTViVjNMZ0xKR3RCcFhHTER5SUltSHJ1TnZRRWhRbUtCd0ROUjJTdFJpSE5r?=
 =?utf-8?B?bkdidTdVVnJtalAxWTJpNUNhOXdqTmpKcStxV2pNalhON3RwclorbmQwZk1i?=
 =?utf-8?B?dkwzamV3c25tdmc2YUw4Y3d3QnF1dFF1TjE0ZWFXY2xBZ3BlU0E1TVpzWW1B?=
 =?utf-8?B?b0R0S0RMR3B6K2FZc0N6MzJITGVPOUZiMVB1RWdSc1NCcWFKZkp4NExuTGZP?=
 =?utf-8?B?NHFkZVVxNmp3S2h2Tm9YNkpKN3RGeEdVdkdDUmRLWGtBSENXaFZPQTREcncx?=
 =?utf-8?B?aUlQZHhNeWk0NXFYS0NVVitrNWlPMkYzVm5iWXRHMS9sTVlCOFI1VWJwZldI?=
 =?utf-8?B?UGRpcUg1L24zUERsT0d1TUllTXlsM3lhdkJSa1UvaDF5WGZabE1kOUZlanV3?=
 =?utf-8?B?a081OFJvSkxVbzFCMkRnLzdoL0tHVEZ2UURGSWd5N3RCQ2ZWZFBwV0lqb1Zk?=
 =?utf-8?B?RmtyTDIrWUdJTWZ0Y2x5NE1vMm00OE5CRnkxYi9WSHdlWkZzZEZNSUVvQ1lH?=
 =?utf-8?B?L1JUUHZUeCtBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmtBeW50L2JqWDlCd1VrdlZXaGZHT2FIWityYWZYK1Rqbk9HM2ZtdnRaMnVn?=
 =?utf-8?B?c3A2Z1cxRzNTSkY5dDBSbUMyQVZrckFoTnVFa3g4MS9qNVRWMHdER1Z1T3BB?=
 =?utf-8?B?aXFobWMrVlZ5WHFiMUlYT1JNYUVEWTNSL2JpNzUyZWt6OU5BQzBhYjhPbVRY?=
 =?utf-8?B?cnpaL2xjSmhMampJRHFNdzBMaWtZbktDcDZiTnJFTnNMb0c4ZEQ4WjNiNnFr?=
 =?utf-8?B?NEEzYWVSSFQ0Y2dWTlB5QUxyRDFxTkx3azJLb3hHWTRwaldVV0JLOHAzZkFv?=
 =?utf-8?B?ZnduK3h1MmhXdkJ5QkJURGtMSUZqdkJYanZVUS9idGE2NGdxd2h1ZGpOTmxB?=
 =?utf-8?B?UURWZEJCL1JRRnlsdFV2dmVFRjAzSDNramFoTVFKZlhITnJQUmg4RG5EcWlI?=
 =?utf-8?B?dlArUU1FSVJsSlJYRnFQdjJJNUlFMG42Sm4vY096ZUpsZ0thRUdIc2FhOGMw?=
 =?utf-8?B?UXdYR1NhWmJwdFdiSnU5VVF5QnliS2NzOVYwREhISForYXZqTmJZemhnZFZS?=
 =?utf-8?B?ZHcvZTlmT0NnYmpCRWhkQmVMeExCQ0FWU1JIWk9FZmRsczlpK3RiaWpUYkpx?=
 =?utf-8?B?T3RydDAyMWxIVkgrRXJTcnJ5ZC9pdWY1M1dCMHJRaGdtZWVPN3BEdDcxYzdD?=
 =?utf-8?B?QittYnJVWFFsMVVmamdjcU15YUlWaVlZM1hpZkc0UlhIbjEycE04b2NQZHJs?=
 =?utf-8?B?M051RkRKMUxwTis5bU56YnZ1dkVHWVZEaEQvY0FVN1lkK2hYbHFCbmY0b2xi?=
 =?utf-8?B?RHlLWkVOZ1pzRXZxS0pEbEVJanYvYW9OaG5Kb2NZMk5mNjVwNzBHMTg3VU94?=
 =?utf-8?B?d1ZPZkVTbllTNkUyOFdHcVEydmNVVjFId2xTdG9UL2R2VzBWWXZ3RTVZeEc0?=
 =?utf-8?B?UUdEcEZTYjVuZXJMSTliR2dZM1Zvb2sxaU9xS2hlQXRKUTNGdThZU2FlZWVh?=
 =?utf-8?B?aEVxcUxteDR5WWRZbnBWZ0JOTEx1SDd0V2daQjVhNWc2Y0pRRVFBNmFMajVR?=
 =?utf-8?B?cmVGVVQ3QTFKRWtZZ0lsMjFOd0UxaFpkUEJnTkQvMFpWZ0YzbGdLdmpyK096?=
 =?utf-8?B?RWZoRW0zQkdXM0F0ZVNkeHpDdzNNbmpnTUlHQ2IvcTZaK0ljZnd0U2xDY2Ra?=
 =?utf-8?B?NjlvS3VXZkVMOUtJRXliaHIwbHJ1WmVuUEFHdVlJWlFuQittRGFCaEhwZ3Jr?=
 =?utf-8?B?ZHgwZnNUbWpXNEg0MXk5SG9VVWZRNTNpSms0THJ1ZTZ6bmhpZ2lVd2NzRTlO?=
 =?utf-8?B?aWxHSWM1bzRWMGJWZit1MlordWQ1bzB2d09KeXVoalRXYTArTlpRYk9WMGZ3?=
 =?utf-8?B?d2VCaXVEaklPd1BQY0h2Sy9od21sbnJENG5GN0d3U3cydml6K3NQR1lObUhL?=
 =?utf-8?B?cld2b1dOVDhNbkhaS2NPdldaN0tmcjdJekduandzeDAzdnUrVElaTWdLcGZr?=
 =?utf-8?B?RUhGbnR0WXp4QmpWL1VXeXFtZE9NcERPSldLcW9vQjR0NndwY1hJQWxqSllj?=
 =?utf-8?B?TmQ2WW4xMG1hODV0cGFLbVVyVWUyZUlTdkVKK3ByZkV5ZnVUMXFhMDJQVm5w?=
 =?utf-8?B?cURqWDFMdEtZQ0RMMk4rVEZlaUdoRmM4Y1JDc01aZWdHNlpielZ4N2N2R1BU?=
 =?utf-8?B?S3h4K1lPZnpRNGdyb2g0U29oeVNMbFJpTDNWVHBwZSt3Zm5wZmtpNW5Fbndy?=
 =?utf-8?B?RC9BVVVhRE9qL3Z3b3A3Z0VCSmNwamlpcnFuTjBNUDNDMmlVWG1SZ1V0QmRE?=
 =?utf-8?B?WFRSWUF0NTVwYXJyTEdhWkUrWStscmM1d3k3dEU2U0twNG1CaVdEdlpoS21W?=
 =?utf-8?B?V3dhRnVyWVRubGlnNHJBdXdxRnBHLzJSODRjTjFTSUFCVU5pZi9BOEQ0MFdS?=
 =?utf-8?B?REZwRHlzWXdJRC9rcmJQSGxEcHFTMXZ1MDRTekR2QkhuSFlrL2U1S0xrRHQ4?=
 =?utf-8?B?RXJwSkpXaUM0M0RqdDJBcXgyTzRGbXhsZGFxOHprc3d0dXUyeFRzaTFEYkZl?=
 =?utf-8?B?RUxJM1hrWTc1M1VRdCsySWFXSjNaaGJkUWNDaUdLRWtWeit5THdHRVRXNjll?=
 =?utf-8?B?VUZFVkdlTFMrSEpBQkhFVjlaOVFLTGwyY3dJQWEwNWVzK2t0ZkszYXZLSjJE?=
 =?utf-8?B?WjF5a0ltMFNRVkJPWnJXUm1xeXBGeWFMY3JsUHI0aW5RY0x3bGh4VG10V01P?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 60bc1533-fe8d-477f-976d-08de0ab74072
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 00:18:51.2766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NeWU77/cSrG+DpL/m9wEVSQ07UfmkTlccPkVR+V7JLJQ4ksWQ1iW6O5zJqPuC3y/aysXzvEV5Y6g1z4dBhEM9qU5/JtEHEkDfM732e5GeBs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6107
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> On Mon, Oct 13, 2025, dan.j.williams@intel.com wrote:
> > > Emphasis on "only", because leaving VMCS tracking and clearing in KVM is
> > > another key difference from Xin's series.  The "light bulb" moment on that
> > > front is that TDX isn't a hypervisor, and isn't trying to be a hypervisor.
> > > Specifically, TDX should _never_ have it's own VMCSes (that are visible to the
> > > host; the TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so there
> > > is simply no reason to move that functionality out of KVM.
> > > 
> > > With that out of the way, dealing with VMXON/VMXOFF and EFER.SVME is a fairly
> > > simple refcounting game.
> > > 
> > > Oh, and I didn't bother looking to see if it would work, but if TDX only needs
> > > VMXON during boot, then the TDX use of VMXON could be transient.
> > 
> > With the work-in-progress "Host Services", the expectation is that VMX
> > would remain on especially because there is no current way to de-init
> > TDX.
> 
> What are Host Services?

That is my catch all name for TDX things that are independent of VMs.
Also called "tdx-host" in the preview patches [1]. This is capabilities
like updating the TDX Module at runtime, and the TEE I/O (TDX Connect)
stuff like establishing PCI device link encryption even if you never
assign that device to a VM.

[1]: http://lore.kernel.org/20250919142237.418648-2-dan.j.williams@intel.com

> > Now, the "TDX always-on even outside of Host Services" this series is
> > proposing gives me slight pause. I.e. Any resources that TDX gobbles, or
> > features that TDX is incompatible (ACPI S3), need a trip through a BIOS
> > menu to turn off.  However, if that becomes a problem in practice we can
> > circle back later to fix that up.
> 
> Oooh, by "TDX always-on" you mean invoking tdx_enable() during boot, as opposed
> to throwing it into a loadable module.  To be honest, I completely missed the
> whole PAMT allocation and imcompatible features side of things.
> 
> And Rick already pointed out that doing tdx_enable() during tdx_init() would be
> far too early.
> 
> So it seems like the simple answer is to continue to have __tdx_bringup() invoke
> tdx_enable(), but without all the caveats about the caller needed to hold the
> CPUs lock, be post-VMXON, etc.

Yeah, I like the option to hold off on paying any costs until absolutely
necessary.

The tdx-host driver will also be a direct tdx_enable() consumer, and it
is already prepared for resolving the "multiple consumers to race to
enable" case.

> > > non-emergency reboot during init isn't possible).  I don't particuarly care
> > > what TDX does, as it's a fairly minor detail all things concerned.  I went with
> > > the "harder" approach, e.g. to validate keeping the VMXON users count elevated
> > > would do the right thing with respect to CPU offlining, etc.
> > > 
> > > Lightly tested (see the hacks below to verify the TDX side appears to do what
> > > it's supposed to do), but it seems to work?  Heavily RFC, e.g. the third patch
> > > in particular needs to be chunked up, I'm sure there's polishing to be done,
> > > etc.
> > 
> > Sounds good and I read this as "hey, this is the form I would like to
> > see, when someone else cleans this up and sends it back to me as a
> > non-RFC".
> 
> Actually, I think I can take it forward.  Knock wood, but I don't think there's
> all that much left to be done.  Heck, even writing the code for the initial RFC
> was a pretty short adventure once I had my head wrapped around the concept.

Ack.

