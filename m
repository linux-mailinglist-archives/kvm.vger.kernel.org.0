Return-Path: <kvm+bounces-71136-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0PHSFfKDk2k46AEAu9opvQ
	(envelope-from <kvm+bounces-71136-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 21:54:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73C2F147967
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 21:54:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2F0593004C95
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 20:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03901305045;
	Mon, 16 Feb 2026 20:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k4kGqaKb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7592DFF04;
	Mon, 16 Feb 2026 20:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771275241; cv=fail; b=ozWZtx5dx70ACH2h+o5yuZxqH4668sg/Z+jepV/C6Jjk4mQ/qECrMg/orXcnNAh2ZyRH78UoxjCbxF+vd5HU0Dtp7QnZyxLMeJZ7db7ZokcJLIuIrG+2CYi/PdKYzYLmfyCgKSoeb4EucPoWJp1AMGCj20S6DHjksJw4UcOi7YU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771275241; c=relaxed/simple;
	bh=E156TYVpHvXZ/VTLete3gClOLHGZCo3U+gnhFOfvfWc=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=BIUI1HGzBZds5APDQWSe0ku66qlVqKZ7CvTRivuVcY7SQESBEuDymiln/dLZH1uHk/libjjaqIjoixwfpco3hxtJG0lfVGL75hGFE5HeWNVl96LqMZvY1BcG/ySPppbWMhIYl5Bh49m7QM7HIcVFLOCAAOhV1ejCiPeDVVGfkSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k4kGqaKb; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771275239; x=1802811239;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=E156TYVpHvXZ/VTLete3gClOLHGZCo3U+gnhFOfvfWc=;
  b=k4kGqaKbOtdL1Ud/+eB6AB0r5mDhlQ1DVY6NjzCoB/Z71R6nhFGjCV8+
   l9r3w4bfvyoQuKzhBYf8J11qfaiVrBWfW0fIVAcYk2HCmCUGWNCdZDR1b
   pjg6yMZtOu4oHyZXRpXlizJxqmzNhgvafOCHk2m8N6GBgJ0BTMO2Y3DEs
   DjpFTtpfcTl3kqIOIIc3lMDH0Orev2GUETjOT4lpQA97YfhjGDSjCzxRh
   UPgqwoAaiaGZl5wbPaFrRrdoLhKKKc80d/HuF0QxvOdx8xuCJMMGKQGF/
   3U34OUkIgRSZXKhwQq5voj+Wa7UD2/UkzJHMGG9TFicY2Qd+R9De8tbO4
   Q==;
X-CSE-ConnectionGUID: lXQTSOUvSZOghdxCwS3VAA==
X-CSE-MsgGUID: TlOrhfdCTyGWy7s1jEvCLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11703"; a="72255311"
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="72255311"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 12:53:58 -0800
X-CSE-ConnectionGUID: ySMRRwh/SWa2lT5Uo67g9g==
X-CSE-MsgGUID: KgYGIkYTS1WbfqRCI7Km0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,294,1763452800"; 
   d="scan'208";a="213712824"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2026 12:53:58 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 16 Feb 2026 12:53:57 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 16 Feb 2026 12:53:57 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.38) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 16 Feb 2026 12:53:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Px/8ibSQyYDOvjpxaf0wyeq+iS7tf2XxLsnpEWhVrgwbHErxZAKx9qYlPgEqMAheyKD+KyLMqLQ6dXnhG+4R9OGN71Av1THjb67WOKd8eH94daitziNZyurNpMoJyNyZ8opN9ZP5wfD1S8LnpTyV6/YS8S97J/9XiufWVPqg1jmywRauH8q7zI5jGLbA40WU030NqiAX2DogNuOaCpIS2/V77jvG6acWZ6u0x1P4xOZgmR41dffUQGejl9zqm7GwKBgyoec8VUGjIswsR6vn00hza0VJW6QkDsGLtkqIMTVFS8Q/9ALhv01811L/fTa+Nh8gH9HtUZUfxrOvds0nHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+quVNLM0judUgjcrbrureQnKygrE61pPFOe3q0kR3YA=;
 b=TApaiXrdO44SudNSGGRzCRgR5eI2AG/jTmZTXWZaklvPQNd2mboQiEWlVeOs5eDHzHZ+2LUKS7BrSUdt7hBypN5P2R1I1j//eGv1DKLTgZltoBHXzs+6HVEyGi25Zp11uBE0DKqK+rJQ1bGxfTCXH22ccmuHV7EIIV9dT7WX/WiO4duYhJtv30VZv4q4Y1trUEOGJEffFSnnd6nT/DHxHD3MtfZ37R8dwY+Z2xonnWz62bFXdSRojWLDQGwvJwSuRlfG9IxqKeesE/jE30PK23S+sDCk+Rmg4+JYAHxXMPtFC+3jzY9Zy7piqpbrKNtIPIrHtDGH+c0m+Y7px88fNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by IA1PR11MB6539.namprd11.prod.outlook.com (2603:10b6:208:3a1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 20:53:55 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9611.008; Mon, 16 Feb 2026
 20:53:55 +0000
From: <dan.j.williams@intel.com>
Date: Mon, 16 Feb 2026 12:53:57 -0800
To: Sean Christopherson <seanjc@google.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>, Chao Gao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, Dan Williams
	<dan.j.williams@intel.com>
Message-ID: <699383e5939ed_2f4a1006f@dwillia2-mobl4.notmuch>
In-Reply-To: <20260214012702.2368778-6-seanjc@google.com>
References: <20260214012702.2368778-1-seanjc@google.com>
 <20260214012702.2368778-6-seanjc@google.com>
Subject: Re: [PATCH v3 05/16] x86/virt: Force-clear X86_FEATURE_VMX if
 configuring root VMCS fails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0011.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::24) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|IA1PR11MB6539:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f2e9d89-b627-4a71-52ab-08de6d9d7fc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QURzY3Z6MTBVdHFGaDdsM1V6eHRNTDA0UFBuRHNPdTZXdXFHdUZOVmlJdVM1?=
 =?utf-8?B?MWhIRytLTUluTWVGZ1lWa01wUjNJM0h5ZmFTd0NzdWQ4cE90MlVoYlRWQWtZ?=
 =?utf-8?B?SittV280aldIMXg2cmJCLzNhZFVlRDQ2MXdCUDd1K2tQVitWbWVCQWNSRi9X?=
 =?utf-8?B?cGRjZGdNS1dtMkR4QTM3dGhDTnVRZHVrK3FHYklVd2lNdUR6U1NhcHE3OUFU?=
 =?utf-8?B?WXl2dUxGR0hiNFVzMmpSN29WbEE3SVB5dnZxUURaL2NkTFZXcFZrVkExSmgr?=
 =?utf-8?B?NHlJVE9GOEJ0UktlSHQwaUI2dlpLSnNYeTBsNU40NDFRd3NoY3VIdHlYczIv?=
 =?utf-8?B?L3AzYSswM2lBRndvOGVCNURWd3VDK1N0ZU1LdTVNRXAwNno2YTdTUUM3VEV0?=
 =?utf-8?B?dEpjSWp4WUtZZXJkaW9XQ28xTVFjNjh1YjA4d1dOeEF0bzF5NnZYQjYwZWpn?=
 =?utf-8?B?N0ZTdVZwZytKWGQ2ZWV4ZFVKNkxOR2hFRUNORHpyUzk3bDBmWDVFZVozVTRG?=
 =?utf-8?B?T3dXS0IzdjQ0QnFXZFhWQ2VPTFgxaGZ2Y1VtcUFNK01jWkF5YzBWdnNUTEpR?=
 =?utf-8?B?TDF0ZzJNcTlBVElLTlZpSWc4YU9SU0luYitEMU9XYThUdG1mOXZvbTByUnhQ?=
 =?utf-8?B?VVdiK2ZXU2x0RHc0VU9LcGZWdGF0SjVUVzJldWJLcFVHMWs3TGZqRXoxd01t?=
 =?utf-8?B?dTFrdHNhamZYWWM0KzM2ZzJRVmxQemE2RUZ0MnR2eWI1dmtaVnFCUXRDMUdO?=
 =?utf-8?B?eEZocFNkaFk3VGxHRzUyL0lvZGlqQ21GUGdBWFA0NWRtdlhYaklEQVpKVHg4?=
 =?utf-8?B?bHM0d0ZqZEhNYlg3YVhNeGdVQVRaYTM5N00veldDRFNhSlhCUmVKazI1Z05k?=
 =?utf-8?B?MGtKQjA5R3ZEbHYzWkpFR0ZMaEFJR2ltb2hmc0NJb1RXNUlEcWdiVCtyUk1F?=
 =?utf-8?B?bHkxbVFKN2xEaWFTV2FTOWxHUU5kd2pCK2xXam9nUHh0cXNvNkZuZlFZN1Rr?=
 =?utf-8?B?Sk96M1pYSkpMQ0V4N1grQTZSc1lqbUx3akJqaXFVYWNzSGlvemhqRHQrNDR2?=
 =?utf-8?B?ZlhQNElxVkdWc0MwNVFoMEwrVEROckFpcFczWDJZUXcveXQ0NlYvQUJjbXds?=
 =?utf-8?B?SDVMYjEzRzlwZWJiTHIyVDRLNktFUFBqUXNiOEpaMTVCU1V0K0RlQWtqSTJJ?=
 =?utf-8?B?VEZLYUtiRU4xUThnMjlZdjVyZjJPUkt1ZDhBdnVoRTljT0N0NmYxZ1IwNVFW?=
 =?utf-8?B?NlBrbk50SWNJMHlRNlNZLzEwNE05SXpqNnFnL0w2ZkpDbVJDZEU1Qy94V1ZF?=
 =?utf-8?B?ZVJVUHh2MFdNOTRlYXZtaTlDdXVZb2xiMnVIbUR5eDBmVXVqMmt0S3p2aEZz?=
 =?utf-8?B?VHRTTDYvN1h0V0hvS29CQnJiOWhyUGtJdTRrMjd2TXpoRWdDRlNZMHUyRldR?=
 =?utf-8?B?cUhINlppdE9XekdrSzNnSkVoWVlpanI5OEFZMVAza1ltWjQwcDhOVU4yQlU5?=
 =?utf-8?B?S0RnNXdMN2dCdFlGWVVNTi9WMllQeHZKblhvR0JYa3QwL2ViUnplcjltQXRY?=
 =?utf-8?B?Y0M0Tmk4WmFId1IxU21SU1l6TmF5RFpISWxsQUV6YTlKbTRrenhjeU1Mdldi?=
 =?utf-8?B?WXZkUGFqNzErNGFHTUVOaUc2T0dBZ3JUOUJMLzNnaXJoazFQMVJzSjdqcUhF?=
 =?utf-8?B?NmVWUE1vemlqekxGMjg0czV0Tzdvb0VCVU9pNmVSYzRkN2ZUMXNsZ1h5MlRw?=
 =?utf-8?B?SFNEa2FiUFJpclErTUxwVGdtVW9WMWhGMjBralZrdFZxOFBMUWpCK0VPS2Ri?=
 =?utf-8?B?T1BjSlcrMzltdkh1aElydGVmeWlxcU9oZDQvK3JSMGV5OTQrVXVDOWMzL3JM?=
 =?utf-8?B?d0diS2x1ajhKYjY5bGVvYW5ZaTRKS3RFcUd2WUdhckluR25rS1JwcnVpc0Uw?=
 =?utf-8?B?QWJQdUJQdUJYTEVIak13L2tZYlZhOFplb0Z1QW5hamt0Rm9oNkxHWWlXZEVp?=
 =?utf-8?B?SE5iUGNtVTBYTUtCY3h5UnZWOVpXNDhURFdFYWVzNmNDRmhoSmNBWjkrT25y?=
 =?utf-8?B?RGR6b2F4SXZZcHM5U1pNdmtwbmk1dkpreXFRdDJld01HWXVRYzJGZmtjcmJS?=
 =?utf-8?B?TisvdW04bVFuMTdra3BVY3VNRkNsWmppbDB2ZmtINFYvbmxTZzArMEdpdm9w?=
 =?utf-8?B?dEE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjFDMkR4aXd4RUc0a1Z4aTd1WXdweUFqaVc3WHhDNXpUUDRNcGtVaDFHbXVK?=
 =?utf-8?B?aVBPVHkzRXRzY1Q3RS84Z1BGSEk0OVdxT1RHb0JZWk83Y0wxQ0hkcDhWYmdS?=
 =?utf-8?B?OGFESUg0Nk9hS3luV1h4bjlUOFV5UXlIWXdhMHNtSzdGdkUxeWFHOHlkWFdV?=
 =?utf-8?B?TXZCVmc5Tmw4SEtCUkt4anFHRVUyMGVZZnR5aEoxcnYxWFYweTJIRWdPTUJL?=
 =?utf-8?B?TEp4WWhBSmFXNlptRk0zRHRzdVVJNmV4UVNkcEtoYmpBdGIyQlN5YVYrZHNX?=
 =?utf-8?B?YkpqMFRsZHVPaSt6SUJNc085ZXZ1QjZ5VW1KMGRYV09nU0JwYkFKRDlXOEpv?=
 =?utf-8?B?Y1ZPdTdtazRoVDY4akxWeStadEQyRDlVS3BZa0xzN0VFNFBCTlR1SEoweHBB?=
 =?utf-8?B?cm5HWUhRL0Y0UysxbytJNlZmUklSR0FpQUduNHJMN3ZFK0IyOFBmZXNHVG1o?=
 =?utf-8?B?cDNOMTRKOFFva1NiMlozVU5hT2h2S0QrQUtqNkdIcTFLY2UySkF5c0E0c1ov?=
 =?utf-8?B?WUJBSHdGOFNZQU5TWnBjcVA1U2V5N0ZHeU9pRSszNEp1eks5QjQ4OERNQ3pR?=
 =?utf-8?B?TUgzWno0elJtSER0YVArZ2JQVXNQRVZFTm1nQnZ0U2xueThwdHQyY0tRNE9j?=
 =?utf-8?B?WVExTEQrWDZnZEhSZDlXOUIvcW1jUDBKcmRtdjMweDVvOWFBWUp5cW5Kb0hw?=
 =?utf-8?B?Y0lmODRFWkw4ZG5jSXNHWDZnb1pud28wRzIxU1d6cGhmMnlpWXZ5U29tK1FN?=
 =?utf-8?B?N0s2RlczYy9pOVdTQm1rTm9nNG14RGgzMFlwYURMWjY3SDRhQ0dhN1dybWVy?=
 =?utf-8?B?azBxWmErTENObWdLQ1pVWnJuQ2htQzE2L0xWYnovU0x2YzZSdllPSGpTZFNj?=
 =?utf-8?B?QWt1VE1DcGNEWm41dkRYK0JZSnhGbjVibnRWbG1yQ1h5Y1NHVno4VllvMFpj?=
 =?utf-8?B?cGUwempibXNSbFlyQnFBQ2dOZjJUc0Y2TnJieTNuRUZpalBFMjNPY1VOT0s3?=
 =?utf-8?B?aklEOHZ6Y3RPcE8zNHJYZnFpQWZnKy9DWUQzWkhVT0s2Y0k5WVRVd1NKSk04?=
 =?utf-8?B?c1Y1U1BBZ2JRTG5zSGs1UnhyeCswNklHVGVjUHAvWXk0dlZ2SlI1eFhiQlJm?=
 =?utf-8?B?cVh3MlgzY0x1NHBYejUzOXRNZlk0ekt0WmZTWEdzSmtOQ1JuNmtsczVjTlNu?=
 =?utf-8?B?WWVVYk1jQWJ3M0ZmbVJJN0RnZVRqMlZsaTIwcnNRdG5wZkp4UUFhdlRud2lw?=
 =?utf-8?B?MkJMd2dXSXB5YjkzY1Avdm5iMk1tRmpvd3oxaXhmbFY5WDh2NUw5YWo2TGgv?=
 =?utf-8?B?SHJ1cXhIblM4ZncwcGphK212TUprT1JVVEdQb1oweDNlSUxrWE42TW9BWG9x?=
 =?utf-8?B?REpSSmxMTEVySEpYdXJ1VHlCMU9QREs3Uzd1Z013YW9jcFpaSXlXTDNDUFBI?=
 =?utf-8?B?dXRpbGVZeUkwWGR5ajg3LzN4S2g4TU1zNHhvK3lPMmFFVEdROCtFMFEzaFRm?=
 =?utf-8?B?WXlDV21YTStKa3NxejVXcHNuYTZ1d29yT2Ftbk5KNG9nUEZOejVVYjRTbVFk?=
 =?utf-8?B?SEUvdVp1bTZDVnp0cXcza3ZKbEdRMTB1UEo2VU1QNDZmWkJDN2JhTTVzNEli?=
 =?utf-8?B?Y2tSTU5XQmdrZUhuOVk4Q042VStaZW4zSzhWNk5XdytiODBDNEVvYm13MUhp?=
 =?utf-8?B?VWY1ZTJNWkRaUDVPakRKb1lxbUduZG1DRUFoa2dqdUZOUGFXOWZjeXNNYjFS?=
 =?utf-8?B?ZDNVL0NDSWl4QkxmTDVJYlg1cnRDNkthVWlGQmZvR0U2ck0yZm5BSmh6cmZ3?=
 =?utf-8?B?UTE4My9SNzRkUmtkS2kvNEpGNHZTSk9RTWQ4UEZKVGtyK1hhQjlvajJJQSs1?=
 =?utf-8?B?RTFBb1pib1dkY0xKYXBndVlOZ0ZBZG1CTlZ6c0tBM2V1bEJCZFkxYXhQd2gx?=
 =?utf-8?B?eG5kUUphbXhndVNqQ0VaWXF1QmZoamxNUE81bTlkZDVBa0h3Rm1VVTkyNzd2?=
 =?utf-8?B?b29mYmRTNUxuNjV4dUxBV2t6Qm1sZHRBdC9VOFdPL0pYUDVyUXB0MWlUeFZj?=
 =?utf-8?B?OFhGTUpmYkdTY044TE9ZTDUxV04xeTZrUm9lM0haS25MSmVzSWN3cThhUG9m?=
 =?utf-8?B?c2FuYXhtN01nbHdlVjlKZGRCMXkyMmFtRk5xMGxLQ2ZBbldyTVdDWjNtM29G?=
 =?utf-8?B?c2hkWWtQcGlCVnl5OVZNNk9yRS9LVHRZMmVHRzcwd0VteTVsYThGd2hidVh5?=
 =?utf-8?B?Rm41V1NTeGRsWGJCSEVCZTFmQUxkUFpqejVhdWZQZFdHOC9veEpSMmU1SThH?=
 =?utf-8?B?bWdwQW50R2lDQXlZSG8vTlg4bzdZTGRZK0NqK1hzMFliREFYZEc1Y0Yzek03?=
 =?utf-8?Q?QihuLyDR6lMbaZBs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2e9d89-b627-4a71-52ab-08de6d9d7fc1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 20:53:55.5962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6kLrREhnot3Pq/CgK23Q6iqbIDkfxaBwMtPxP6y1kTX7i8WTYdUSCKQ783tFTRvVRbJUt0zEzT+35oi4/xWJqJWkE5157kqriQ+RLuRHe8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6539
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_SEVEN(0.00)[10];
	TAGGED_RCPT(0.00)[kvm];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71136-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 73C2F147967
X-Rspamd-Action: no action

Sean Christopherson wrote:
> If allocating and configuring a root VMCS fails, clear X86_FEATURE_VMX in
> all CPUs so that KVM doesn't need to manually check root_vmcs.  As added
> bonuses, clearing VMX will reflect that VMX is unusable in /proc/cpuinfo,
> and will avoid a futile auto-probe of kvm-intel.ko.
> 
> WARN if allocating a root VMCS page fails, e.g. to help users figure out
> why VMX is broken in the unlikely scenario something goes sideways during
> boot (and because the allocation should succeed unless there's a kernel
> bug).  Tweak KVM's error message to suggest checking kernel logs if VMX is
> unsupported (in addition to checking BIOS).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
[..]
> diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
> index 56972f594d90..40495872fdfb 100644
> --- a/arch/x86/virt/hw.c
> +++ b/arch/x86/virt/hw.c
[..]
> @@ -56,7 +56,7 @@ static __init int x86_vmx_init(void)
>  		struct vmcs *vmcs;
>  
>  		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> -		if (!page) {
> +		if (WARN_ON_ONCE(!page)) {

Is the warn_alloc() deep in this path not sufficient? Either way, this
patch looks good to me.

