Return-Path: <kvm+bounces-49540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24721AD9859
	for <lists+kvm@lfdr.de>; Sat, 14 Jun 2025 00:44:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE5D817CD71
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8909C28E605;
	Fri, 13 Jun 2025 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KO8qabaw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0915A2E11B9;
	Fri, 13 Jun 2025 22:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749854638; cv=fail; b=QM+iS0Vq1BDet7srJQ3KA9ieHVd7ZAEAQdARrmlZXVVRJDxvkUGuWD7cgm/lDqkS0NbKKWZF3id5lG1MLAOq381HMXNQR5vqJNPDfRYk6kwRAdJU2M7f7eCppK1w93lKTAoPuqxQzFUX5Q+Bk3TYODIGPuf164IDd2Y7lb1MuA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749854638; c=relaxed/simple;
	bh=RBpGDATcTwwv+7rUDRSD2LWFgJeGCzrEd68+sSX6bUY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bFAZKEDMtK6UBV+qD6kUaZwqX0kEUNZuk+B+3hS/719/1BWkfm2B6tWEJ7ciq7RwAHpJzxwecx9RV2ygSs7oAOZr87GY+01uyhZpGe2egjJcos3agT6bs6nbyaIimR0cT0eW/zMKcrVE/MkhzPoJO6bzzqCaHhZZlnbaeC6fOsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KO8qabaw; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749854638; x=1781390638;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RBpGDATcTwwv+7rUDRSD2LWFgJeGCzrEd68+sSX6bUY=;
  b=KO8qabawG4qiSORWrCoO6dYCLVgqU4y4WGzZ8Wasbj7OYK3elbtg41e8
   JjNtmkxJZVVVkgT9BaFRnlkK/89ff1oBwQvHt7LGtsxoiWftI18lCzxwX
   MplNfwd75lZQGSVJ+oF5W1qkUNaeTsjTT/aDWT4XIBiRYlxVmfAjiXEX+
   gKCWOHnuU23LlNZaZcN9cQaOgMFLAFU77gwRvhRcoTnI7X6jYh02ROozw
   s78NokHh93mInwWvXMg/N3Jx+aYYiqZLmyibzmNTYNQb3uxq4neWF4+HU
   7qxfwh4e1qrq/Rf6aOmkkRgknizHmlGzHvel+laxprad33ATr4XsK+J8L
   Q==;
X-CSE-ConnectionGUID: uEt7hWwYSVuxUxELPyevbA==
X-CSE-MsgGUID: BUdRPR5SSd+JiMdwsFRUxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11463"; a="51949328"
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="51949328"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 15:43:56 -0700
X-CSE-ConnectionGUID: ns6J5WWpQ9WCubW7p8J63A==
X-CSE-MsgGUID: TxeQqtYMQCayWytfJmtrTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,234,1744095600"; 
   d="scan'208";a="152913408"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 15:43:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 15:43:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 15:43:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.45) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 15:43:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZeAdQShPaUqtSYhtALpHeWGHfUNvWZltbksSW7LNRIF3ldoKAz2sm6H1ib3z07yFtfYXG97EZL6nhhDRlP7jD5cx+zQXAwxPgFf+NKuePNo0s5ybEqp1SePdMugX+TAe+fMHj1C8j8ABGGoCcQkLkTjejMYddWbgJ81BtMbrJ29gwAt7e1DPf9A/RrR3YYMoFKlS5g2NS2i4EYth8I8/5XqddxQaIXQMFJ+nucl3EFGl6MRqHS//MjtJryd8H6J10TBTabRfpR8iycOYqsUJyRacdm4qpv8iHCOXKcIJeIq4SlUior2qkAPUwnE/euOGZ++k11p2Hh6LmLusJqDZEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdnuD0v+attH/WT9phLZMIF6n5FRhEEs9rBxIMAEOYQ=;
 b=pKkKHMIuzqSzmx9prjguF5hBZ4CZsmLU67OoWACZRh5LDZrLDNBQn020CJNpX1UXz+d/fb9oYs83UF5ylELcXxbqrw1GBw8clOv+NYbpoM5rmyVJa3f3GytnWUAQ/ltTCF4ZI6b4AUMOaXr9ipNQpcp/mOBeFsZdR7cqSeAh746mv0BtT5HUC2mta1QEBX0ggWfv+LvYR29TqvIuP1BdyE+eTVu1gja7a5b1tvU/dDc2EtYBaRsNbuVLsFU8rDg7SnHhUWseAmCqnc8qW4tOMAcWutaFp2j5umLDewyqXxjA/mhnA63SdJhuki0e8MrJTV7MX2pkt9T6whrWlCGsbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3322.namprd11.prod.outlook.com (2603:10b6:5:55::19) by
 SJ2PR11MB8299.namprd11.prod.outlook.com (2603:10b6:a03:53f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.19; Fri, 13 Jun 2025 22:43:37 +0000
Received: from DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e]) by DM6PR11MB3322.namprd11.prod.outlook.com
 ([fe80::fca4:6188:1cda:9c1e%4]) with mapi id 15.20.8835.018; Fri, 13 Jun 2025
 22:43:37 +0000
Message-ID: <ac28b350-91a4-4e6d-bca6-4e0c80f4f503@intel.com>
Date: Fri, 13 Jun 2025 15:43:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/3] x86/traps: Fix DR6/DR7 inintialization
Content-Language: en-US
To: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<brgerst@gmail.com>, <tony.luck@intel.com>, <fenghuay@nvidia.com>
References: <20250613070118.3694407-1-xin@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250613070118.3694407-1-xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0196.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::21) To DM6PR11MB3322.namprd11.prod.outlook.com
 (2603:10b6:5:55::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3322:EE_|SJ2PR11MB8299:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b873018-ca1a-4751-d1d5-08ddaacbbc0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Rk5sMERLeEVkMUtrTGE4Q3BKRXZoeU9hSVVENUdVUWYxMkdERGhNN1pxb3Iv?=
 =?utf-8?B?aS94MENmU2k4YURJazRjMlRqcGpLUjQ3Ykc2NUxpNFJXRndGK1hFWGs4Z2l1?=
 =?utf-8?B?L0tSL1dNVW1GTTcxUFFiMy81bUdocXFiK2VLTCtHeTdpVm5rWnQ0MGpXTXpS?=
 =?utf-8?B?d0V4OFl5cWZlRTNub1pSeUkrc3NXVDU5eDdTQndoRDlJdldNRHg3WkcwbXhK?=
 =?utf-8?B?eUZ6d2kxaGdqQU84WjR6ZVlUVnFvQjAvS1Fwb0gzaGM2YW9xQkdtSEFjR3dD?=
 =?utf-8?B?MmNRMkdzNHBwczMrUTgzR2lRSFVKb2FHZmR2QVdHd25hZU5IdzVHYXhwSlQv?=
 =?utf-8?B?VGp0OVNsT2NsUG5nU05OQnAzZkxWNzlYN1dBSzJyR010SElmL1ZEalBYS0V5?=
 =?utf-8?B?ZEZIZ3hkZFR3V2FaQlIwRzIyTDFnbm4xQk5uNVZKNUxmTjY2Sk10elhxNDVj?=
 =?utf-8?B?VWlqeW9yKzJhS2dFM3lOYTVKSWFaZ1kzdjk1d3FGMHB2bWVMRTFMd2NMTHo3?=
 =?utf-8?B?eHVLaDFybzRISDdqd1hUZ2wvdVl2L0o4ZFgrSHhna2xERDR6VGRNVUJacHc2?=
 =?utf-8?B?dWJOV0VUZXV5MjhGMVlUQm5waHZ5S256S3JIQWFaVVZYTXZvbFBwbzc4Q0lt?=
 =?utf-8?B?NEhZQzhUZy9CUEZYaFI2S1QxSktSNmR3VEdZSVFaN0QxM0RZZ05rWVpOMndJ?=
 =?utf-8?B?WnVSNVRRNVZhMk83UUFqMlpSSlFVVFkxeGtOenQ0Wks5Zlk5M1lhb3ZvbUdC?=
 =?utf-8?B?dEc5VXk2L214Z2VYZnVPcDFzSE5rai80WUdDSlVDWnRMMzV4V1Nyckp5ZFFD?=
 =?utf-8?B?MkRUZ25aWXR5TkxhYkQ1alh0cGhMa1c4K083QkIrVXZpOXluYnhodDhWTEt4?=
 =?utf-8?B?U2ExVUkwNTY4YWtNM053d0pTTGRhQk16eGhEV1oxaG1mV3hEV2x5K3dhd3pP?=
 =?utf-8?B?N2xHR3lYYkhVUjJwQmF6ZmlkWUR5c09GRlh1QWE5d2EvSU5FanNmK2RFVi9y?=
 =?utf-8?B?NWJidDVXbkJxWTRiNTlIQzVLNEVqd051U3BxUHR2MnRrUW9SWEFqV0hCOE1R?=
 =?utf-8?B?cHZpdnhWVGtpSTFIMEhGOS9GV2MyS3l3RW84NVhBQUR2dXVmVDZqUmlrK2JS?=
 =?utf-8?B?ZWwrc2VDUlZwVUVPUStmTjdRQk1QTnRBeVFOOGlYVzdhQXNkRVFtRnhMNE54?=
 =?utf-8?B?ZWVYZTI2VXlQd3ZjSC9zQXdrcFZEVnRzcEtRMU1KMmVUSVlzeGN5WGpERldN?=
 =?utf-8?B?U1loVW1mY3hYeUc3ZHRLQUNTa1dyWHM4b1o0MFQ5a1R6Vjhld25NaUFHckRO?=
 =?utf-8?B?NGd3NE1Pc2E0UXlXTjFrU3RSdytwbHJuTFRndHc5SXZoaEk4QUdWVjNoVWZp?=
 =?utf-8?B?MSs0ZkVSRDdaUkJGaTB5R0xKdXR2emZYM0prd3ZHTlNQQXFuSHJvZlpjMEdr?=
 =?utf-8?B?YjA3b0hodHJ0cUk0a0w2YW5tNEQ3Y2lxWUtJb0ZuOFN2T0paeWE5YXJ6Uzlv?=
 =?utf-8?B?UlBNanBIQVBxQ2xxdFlEOUUrY3BKUUdWQ2xzSjdrYmJHWEIzbmV0d1AxMkRj?=
 =?utf-8?B?eHp5NUJ3djVNRTBRUDNLUXg5ZnNQRmk5bU4waGpJTVVsZ0tqZnhhNi9xT3VY?=
 =?utf-8?B?R0RhdG13WFpqV2lyWVhjRmVFTG5ZeVJub21QUXF4WDZZaEhpT1M0VmMyTllq?=
 =?utf-8?B?a1VoZ3NpUWE2MmFPakcwMitpWHdFQ0xET0FQOXFUMUhVMENmMjRXNGRlT0hQ?=
 =?utf-8?B?V3NYZXN0TGl1b3VGSEVRSWZNREtZYmJWVFMvMGlRN3VKYW0vQldCNUxSZjR4?=
 =?utf-8?B?UVhjeW5icyt2RlVXVGEwUDNhS2FUdCtOWXBpZE0xOHRXQmJnOHA3b0dzYmd6?=
 =?utf-8?B?ZzJ4S2VweForSjAzbGUxRE9aUkwxT1JRU1RGNzZKTWxkYlpmcDBvZnU4bTdJ?=
 =?utf-8?Q?5QyI5spLEBY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3322.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUJBZk0vbmFiWG52Wkx2MVNoTU50bFpQOU9IbDBERDBpZE1UWXJxRUZFZFJh?=
 =?utf-8?B?R05SdXVwbi8vRFgrY3hOV2FFOWg5Vm4zZXY4aHptMUVCSlcwYklJMVdoUkVm?=
 =?utf-8?B?bEV5ZWdld0NnVmF1UitQZ0d6di9ScVlteEVya0pwYXBwN2FZdnQzazZGbkVM?=
 =?utf-8?B?NVpyZkFya2l4S3kyOFdsWDFJYXdHZExUTllTQ0YzSlEyN0V6d0k5UWNIcnpx?=
 =?utf-8?B?ckl0cW51WHFVaHJWU2RLU1NZQ293WGxoNlhSYm5VVnVSQXluTW1BZERMc3F5?=
 =?utf-8?B?cEo1UE5pUUY1YUhTVGZ2d2tLUEkrbmtlYkRLTStWV0RzcHBPTGQybDdXa0ds?=
 =?utf-8?B?azNaSU45NXErUk5TbzFyQkh4MkJwaWtJNWNPZGNyZmpFVVB5WThGYjNXeCs2?=
 =?utf-8?B?TmNGNmRxNFpvNlhHbVRPSFQ5V3ZxSzdZMWtoOTBxdDNHanZWZlVueWNkS0lM?=
 =?utf-8?B?dUtkN0tEdEY2bFA2ZXJOVmRUN2pldU9MT1RzbkxYRmdIYWlsNGNReTlMZ3Fq?=
 =?utf-8?B?UUlBbmNGSlFjU3ZjUFgyZENWZ1RrUDN1VjB3aC9WTWJhVFNGam9FL1R3TDZa?=
 =?utf-8?B?K1BVNFVqQU9pZjBkY2RaeEpsdnUvZGJnTzU3eDdRVUVxQTlmdk1WS2ltcHFm?=
 =?utf-8?B?RUkzK1h5V1QrWWR0b21rcnh5NGpOZVJTNEtTOFBPdnRqcFdoUWhvQ1hmWTBS?=
 =?utf-8?B?QUlYTThJMnFObURmeDc3UE9OUkdjK2tKY3JIUjNqbkxtRWVjV2VhOGlpb25n?=
 =?utf-8?B?d3d3OEtMaWhNbzA0Q1VDZXpoUmc0dWhUWjAzcitjaHFZMklMT2FROWsraExS?=
 =?utf-8?B?VXlXN0tzTmFZU09XVHlGeFRMOFBpRUZmQ3ZlcThYbVRGMkJvWEJ0OWdXOUZN?=
 =?utf-8?B?b3BpZHVPM2FBeVoxbVJMRVJjSGgzVk1IMHNhU2JMTXBGelNsRFVSS1ZsRklC?=
 =?utf-8?B?dHBudUxtY0hKLzZES0tDSnJvZWFnTi9ucVZXK0hRanpBU293QllBM1ZzUGxS?=
 =?utf-8?B?L0lXS0twVk5lM01sbytrQ3JNKzNHdnM5bmZIbzB5cmxLZzk3K005ZUd3Si94?=
 =?utf-8?B?azBNSnVFazhSV3dZUHFnRy9ieXY0R0l1YWZRRC9jaFIrNDcydkYwbnVIbEEr?=
 =?utf-8?B?eit5WHhBelQxWXlHMzhjQ0RLbG5DcFgwNnNVS2VBc1IvV2R0NU1MbS9Wc1hC?=
 =?utf-8?B?RGF6dG55YmJDemJ6QXJCcnQzWEEvK2U4dmVRRms5cUpmKyt3WitMLy9RSzNE?=
 =?utf-8?B?YmM0MWlQaXdXR2luM29DczlxaTlMdXBnNlJreC9UbU1zVkE3ZGpITVcvUS9x?=
 =?utf-8?B?c2o3V3llb2lEK0FObmNhVy9oamlnQjA3T2RIUnVmeGdhTkRCR3VOWXVBcCtF?=
 =?utf-8?B?ZGlxM3lGcngwYkZocE5OVXJvYWJxWUdQalBrRmQ1aGtObGVjTzVENTNESzZm?=
 =?utf-8?B?VXdTNTB2eXlwc3h2V2JsV3dSTEEyeGwwZDJJWkhIWUZpQ05tZVVoU2dxdVBx?=
 =?utf-8?B?TkZuQWEvY3Eya1pIYnU0aFp1bUpXYzdzenZuYjM4QlZra2M3d3FpRzM3Vnhs?=
 =?utf-8?B?TzUzbzE5bFNqeTd3VmovT0s0cVQxRVRhMHI5NEJLWVRxQ0VxZkFFaHlVbU5C?=
 =?utf-8?B?RG9DLzlrTzZwVXhQT1lRV3NTc0hKNEtDTzcwVFRFNEp2N0N4N2NlRHlnTmRZ?=
 =?utf-8?B?UXV0a2F4UmY3dVp1anVYeXJEOTd2eVBIQU9LMWJ0LytENXpCM0MzQU5XWE1s?=
 =?utf-8?B?bW9wYkQwNE9YWWZvTklObmxHV0lVWWtLdk1UaFlJSSttNFBmUm5zNTlqelRy?=
 =?utf-8?B?U0NWbkNwWjU1WCtLSzdBL09uN2hNeHJrMkJCcC9nRjBnaG5xd0YwcnBLZGEy?=
 =?utf-8?B?ajJFT2pTU0tkUVgwRzZVcThWamYzUCtEdGE5dzhQdzJSQklGK0RRTHN3Titu?=
 =?utf-8?B?V0Z2enE1UlRKdms3bDlxTzJQUmR3OVhFL3BET0w3R0pwYmFuais5emczL05r?=
 =?utf-8?B?d0xOM0JHL1BnLzhIY2hpOGZnZm5VQlV5RHVEdkxsMzJaamZLQU1aTTdUemk4?=
 =?utf-8?B?ZVdZSkhnRU1yUVpyVytkcjdIL1l4cTNRZjlVL092MjFJQy9wQ1loWitWSlpZ?=
 =?utf-8?Q?xZDlZZHlBJv+xOusqhwB0CYpv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b873018-ca1a-4751-d1d5-08ddaacbbc0f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3322.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 22:43:37.1826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oAtKDq3F97rq4aQuKNNXDhzDN9GDxnYHZkPpctuMMItG38l1fIw5DHANDw5w0IdIPZLrXB7F2saaSGdXVpu+ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8299
X-OriginatorOrg: intel.com

On 6/13/2025 12:01 AM, Xin Li (Intel) wrote:

> 
> Xin Li (Intel) (3):
>   x86/traps: Move DR7_RESET_VALUE to <uapi/asm/debugreg.h>
>   x86/traps: Initialize DR7 by writing its architectural reset value
>   x86/traps: Initialize DR6 by writing its architectural reset value
> 

The patches fix the false bus_lock warning that I was observing with the
infinite sigtrap selftest.

Tested-by: Sohil Mehta <sohil.mehta@intel.com>

I'll try it out again once you send the updated version.

In future, should we incorporate a #DB (or bus_lock) specific selftest
to detect such DR6/7 initialization issues?

