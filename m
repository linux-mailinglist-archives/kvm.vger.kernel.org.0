Return-Path: <kvm+bounces-55260-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C957B2EEB3
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 08:52:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BDC0AA2326
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95672E62B4;
	Thu, 21 Aug 2025 06:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DKVdndVk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4D236CE1E;
	Thu, 21 Aug 2025 06:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755758990; cv=fail; b=nwQANh2pcvzAD/g8aQaw1SUkNWkcnwf/25hEhuWBoVnYze75ztiIkw2qyi/eHDc6xlYPuyMxh5/TJzqbUHlXTfhhWT+BW48kzSbSW9SjGGL35nrKSi+M5kz8bJAzv/czkiVlPRiVcOWWN2qId778mCVhstqq9GXyZLRywK880QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755758990; c=relaxed/simple;
	bh=yuI+5dOREp/MfXvoHRN7ga++11KYo+pdCNPJwiePDy0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tK+RKutcTyUbL+H6ye7uiJ12irwDZJNdYcwVvaBrRj2usKUtV78KrKy0gAmxqS2HFy2E+z4c2q8BHpVKAlH2JKMmHO7lI/qEeG6hzycoKs1YiSzZpxobPqvg5xPpWrcAAyuPq3s7eraia11mZ+ZzMpdGAbGk65COEJ04r1IeNxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DKVdndVk; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755758990; x=1787294990;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yuI+5dOREp/MfXvoHRN7ga++11KYo+pdCNPJwiePDy0=;
  b=DKVdndVkk/YUKOd53m0McDFaPmEwnNRMZscLxOwcetO+yOC0LguMcwk1
   WUc3Zi9BrhfaKYHl1X05YUlaGdP+Xwq8S2kUnSxAymriiToTehqKHOdtn
   lMbHe0XXz2tqu61JWBrgG611q5XacgymsfK3IHjcAltoQExh1aBs38drq
   6SgCUcYg9C7D9Tt9XjiKFnSFQ3SSj/vdP3kE9SrKtCAmOCaWQk118Drm7
   Mf1JF6/mCmOZzDcN/PxhgQFMp52X2LSdTVMknrux/q6eYlL0ARWTPjpAu
   pa549S+ZzP9Z8Z04RJV2l5u/76KRgiGXxBHet4gZWgXWo7DbY5A9j9O/d
   g==;
X-CSE-ConnectionGUID: eC20I/NpS5CpckZ+MfeyrA==
X-CSE-MsgGUID: 87cNVp3lT0WfISXMUw5wCQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="80633473"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="80633473"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 23:49:49 -0700
X-CSE-ConnectionGUID: zP8oN207TaqsiRNNaIG56w==
X-CSE-MsgGUID: tyKKbgJZQZ6IrLasD25iwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172748732"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 23:49:49 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 23:49:48 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 23:49:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.86)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 23:49:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=owZZzF29f65AOqG9C/LHyrx+ZQeblPkP3qfxxFLrtjdAt7sZnB5Mg4S1AhkocAv4WAbr6d4UFmGOlhqkeXVsIDyXo3r7ZtwUmuIT/rIRxq4w16wGihrYe/elvN7Kl2tsdCkZhuH3+L5gIrwurLh75luL/Xg3hekShmq1hTsw3VJrF+hJ/Lgo1WeVCV3jFsa6M+MLiSMXsma7DpFJ6tGk0F+fDR84ZD0nHQiQJ5KVISKAF5PDhqg7S3qfovIELqTgpKKjnP+P2vknCsm90Src829w36RQww4tlYu3d5u/4vfttgyeW0rr/mfbH1qMMHkx9hdETzO4GUY64PjNXGUufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEHTtMthH4BvDCfE3AYjTTRZZJEHo/AqQIsSxgCuN7I=;
 b=ieDIoPSWUIC/GnNLTjuyQDFLRIOngGBD8gXW+SCg/G1WWvu3dRu7dCq7HurOI5EuzY+ctIFAT2KMXp+/g9sx00dC2G7rTxtrDWmeq9d4c2UznThO6aET7DB2O5tGSZ1wsbrn0Hq6JFKagowvKVV3aCwiBnvmYLHHo/2X53tjZz9rrbYgj+AiU7QrsbvDp5WD2A7OAgVc4X9mJaAUaoLTsWBkKBAdq5oBwb6p+CUeb/dm7uqwAfYkBeuBgjHn3pGk67RvLVLY9PpnCE6TTdRVtP6N1/ksr+FXd+sz4DIz70vU6zoDtisWKV50QYrB39AiCE2sCcMJzhKV6nLfrsI9cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by CH3PR11MB7347.namprd11.prod.outlook.com (2603:10b6:610:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.15; Thu, 21 Aug
 2025 06:49:13 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9052.014; Thu, 21 Aug 2025
 06:49:13 +0000
Message-ID: <a000ac49-a671-49ff-8c5c-aa82930ff20c@intel.com>
Date: Thu, 21 Aug 2025 09:49:07 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: Yazen Ghannam <yazen.ghannam@amd.com>, "Luck, Tony" <tony.luck@intel.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Du,
 Fan" <fan.du@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com> <aKS5ixhgtCYIvErL@agluck-desk3>
 <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
 <SJ1PR11MB60833C7AE2FA8D8200EA3645FC30A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <2b86c458-f63b-4f74-8fcd-1456ddad4d7a@intel.com>
 <SJ1PR11MB60831ED23234A274D3DCDD6FFC33A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <20250820175610.GA936971@yaz-khff2.amd.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <20250820175610.GA936971@yaz-khff2.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB9PR06CA0010.eurprd06.prod.outlook.com
 (2603:10a6:10:1db::15) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|CH3PR11MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: 43fa366e-5eae-410d-b8bd-08dde07ed6de
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UEpzNlczUUh1SG1iSHZMeTJleXE2ZlFNYVM2NUhQKzRDVi9OdW54SnFocnEr?=
 =?utf-8?B?TVo3aGZhMGR2aWErRTBXWnpNUWVjR2Q3Rm5hVUlkbGNhdEs1OStLb2xVT3hT?=
 =?utf-8?B?UTJvN1AvZm9ER1F1dlNiZWdGRXZuRW5Wa2tVLzZWd3ZxdzNuZEpJMFFvNTJK?=
 =?utf-8?B?SFViSFk5WEluL1ZqUHAzaUtZU0hWOXJqRHBSdzl1WEIzU095YzhlSFMrS0E2?=
 =?utf-8?B?dURqTEcvOUhtTFpJN3UwQWtuSGkrTlhnVzlTeklpZWNRWERkNTJBVWRNUjBN?=
 =?utf-8?B?eVhGZmtHUkI0ZmFGdG5nbm1iajVSWmFwVTU1SGdmSzNVVCtwejZ5SmpsaWIr?=
 =?utf-8?B?eUl5S25NZFUramE2SWtXVkM5VUs0a0k2YmtuWVR6aHl6UC9vNVBHZzZMNExI?=
 =?utf-8?B?ekx2YWdub1dzZERmSjJlc1o3ZGhkNUxLVUp2N3FHZm15cXEzOHZyYW5ueFpW?=
 =?utf-8?B?aGc1UGlmcEwyMFJsQjFiSmxHQWh4L1NaQXJSUWVYSk5tOWVFamI5Z2VYWTZs?=
 =?utf-8?B?YWp6bSt5SytSQTJNY0NsRU9ndUc5aGF6UU53WXk3YXBhelVLVmVvMEgwNWNh?=
 =?utf-8?B?QXhyQnlieGpFckhhaFkydStSRys4Rndqb1BUbkZoUGJncHVRYmVFK01vUWd4?=
 =?utf-8?B?c2dzc3hPbzVTZ1NGSGUxbUZOZ1FSbk81UDczdlVuUUs0RU9oczJCY1gwblYr?=
 =?utf-8?B?V2FSVUVCVmcvRVMxaUFnQ0t6a08zWjlTS3FIRi9SSm1HNG5kSjFoK09XL1p5?=
 =?utf-8?B?Z2p5emN3NXAxeUMrWlVVRFBNQWh6ODB3K0NQdG83bHlDMjYyb3JIcXNaSjAy?=
 =?utf-8?B?bFRuZVY3WWo5Z1ZlTTk3LzdJa2V4UHFGeW4xUEpBQVBsZDd4bGppa1UxbTlp?=
 =?utf-8?B?ZlBmWnNoNlFybzRYY3BRQm55KzdJTFA1UHllSlJ6VDZtVGR4U3B5NW15cktU?=
 =?utf-8?B?RmhwdFB1ZHBhdE5oRG1nSlQzZXdiTlllZ3JNUGtMK2ZoeGNGbTBQd1NiL1U1?=
 =?utf-8?B?bDBSdjdXS3p4QlJtMk41MFdmaVJnYkZuOVVvTkYrbFE4WitoNWtkdVYwdThF?=
 =?utf-8?B?cHd1dFJEcHltSXZ3Yk1PaW11MzhQR00xZ21aVVZ4K0hBSjA2bXFSOTJyRis3?=
 =?utf-8?B?ZmUvT0U2OTNOdHhJLzAxMWJXR25aSFJlNlQ2eWJtUXdvUWk1eVlrV1hLcHVh?=
 =?utf-8?B?N2tFTFl4anNqREZZZStJOERBekd3YytSSnJUMjJ2VzRjcm9CZ21tMUdIOFE3?=
 =?utf-8?B?T3lkRmswSnczWlBjQ1BCWTdqL25mWUVuK2FMTjlITTBRNVZCZHVJbUJRb0xk?=
 =?utf-8?B?Z0lqVnAwSER1dnQrSThFU0tWZE9TNHNEL3Y0TFR1SFVocEJtRy9oanRxOWxB?=
 =?utf-8?B?dWo0L0pPbUJTalBjZ2IwRjN2VWdjL2NzaDJ6QmY3R1JCNmJrV05sV1VaZFNU?=
 =?utf-8?B?RG1XREZIZFRkeldyRzdnSnRTWnNaY1U4L0NScFVJYW9iZFRpWmFldHZoRzRO?=
 =?utf-8?B?VFQ0NWdPbXBZMjVkTFBmU1gvWHhUZ3Q4bVFZWDV2cDF2WEUzeWxVRFFxUnJM?=
 =?utf-8?B?R1ZXWUFKNlBzZFBvYnU0SCs3dXdwcU9ZcDduaWI5L29kY0FhR3dOSytPMUp4?=
 =?utf-8?B?Zy9haWN0VE1taUUvS0wwRTVBbE44Vk1TQnI2ZHA3dXloM0Q2SGNBbG1lQXRr?=
 =?utf-8?B?eVBDU1AzL1N3YUpqSlBjNW9GWlpGWjdhd3YxWnVCWWh5NEdVcFVXUVk0Q2VT?=
 =?utf-8?B?cy9mRk9BaDNVWTZsSXFOZFJ5VDJ6NmRzdXQ2Q3M1OFM4dmlQNDlhOWduNXZp?=
 =?utf-8?B?REFYeVhUSTZWbUx6eEttSTRRU0UxVGgwSFBFVG5pSkxMQWV0MTQxVGhzYnBQ?=
 =?utf-8?B?UHFBYWIxaFRhczRtcnM3R0NLWGJaeFoySGpNRXpXMlBJL0NlM3JSQTNhazhv?=
 =?utf-8?Q?WYQ9KGvg0pI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MmNwZ283ZUxiOGJwd011elViSVROaG1HQUdWQ2s4d25kanNBRU45cTFpN1FI?=
 =?utf-8?B?MCtZb2NYMGVQMlFuakljcllKSmhuYXI1dmpRZ2JZQXhXSmRqYXZyb0hYOU1Z?=
 =?utf-8?B?Z2hJSVdoNmMyMkpjNkxiQjVaZWNZUCs1OGtVZ2FJZGo5SDRiK3lCODBCL0gx?=
 =?utf-8?B?UUlERWUzcmdTTkI3OUkzYUZ2NXpJMUNyN0RjY0MrdGFxVjMvbVRxMzM0Vm13?=
 =?utf-8?B?OWtqYmF0WFJ5eHhqMVRPOFM3cDNPcWl3djJOcDlaTXJLYys3cm9Ma3liWG9y?=
 =?utf-8?B?aS9PRU9xaWRlL0xxbitqOTN2eFNtaXFMeGFvVWRwZmJVTllpaURSb1FsT1hq?=
 =?utf-8?B?d0JGQU9HSlUzaEtML1dVcHZBYjVXRTQ4bG1LODRHVHFhWHFjOFlrNXZYeEZw?=
 =?utf-8?B?VzRtVGUyNHFsbCtZMWRhaG55ampidEFaU3d1SVhwRGNRNzlMSjFGbXFwQldG?=
 =?utf-8?B?V0VIbTgxTlNsRDlhYjNiZWJESXNReVZwRldwZVp4ZkdOUjVQa0F3UzJLVzNQ?=
 =?utf-8?B?UkVGNTd5T2l0OEtRakdrZWxSWUdGckVSWFBibk8rYU02QzVoZkt3YTNpbG5m?=
 =?utf-8?B?MUROeFJmNmZTQk5LdEhxQWJSaHcxNkRDRDFWdUltdXFTZEtvK0lFNFI1OXkr?=
 =?utf-8?B?TjF5bTF4YnNoUEVjU1VNdDU4dUZHRXFVY0JGV0xucWIrY2hiNzkvbjEyR245?=
 =?utf-8?B?eC85UVBWRlcyVm5jSlcwcVI1TnJZK0VPQ0ozZGp4Uk1yb3NvNGpiUUR5T3h4?=
 =?utf-8?B?REFYWlY3M0wxNDRNVDBrSVNJT3p3WW1XVTdRam5sSzRQTWxkSHovTExXVnZv?=
 =?utf-8?B?bnE3VVZHNEozQ1V2UWI5NjBuV1RCUGJBdVk3bEltblRTOFVvaUxoYWVtTVFa?=
 =?utf-8?B?cmdhemU3U2RkSXZTQjMyQXk5NXB1aW9ReHZlQlZValRkOHppL2MzL3RGL2ta?=
 =?utf-8?B?T1hBOGRkYkVodUphTmhjNW5ERlVpUU9PSnFPSnlVRW1QSkREWVJTMXQxWldi?=
 =?utf-8?B?SzFkdjlIUEtSU2plbm42ODY4bkZPeUNJTW9vNWkxN09hOCtQKy8wZ0JmS0xi?=
 =?utf-8?B?bG9vTkdsejcvSlE5YkMzUjZkWjVDVlZ2a3k0Znh3U1NPazQ0OUloZHNuZ3FB?=
 =?utf-8?B?SDBFTlJNc3FsM1lySmMwbURrSDFodjMzaVArM3A5dGxRK2plTmlyVmczK25s?=
 =?utf-8?B?dXhWRnhISW1ybUdXQVRoeEViN0FqakZNaEF5dWdiSEp1ZUtDcHNRMGt0WVc1?=
 =?utf-8?B?K3dxVXZUdUNCQWpxQWNsd1VFbUREeUJqclJtdTdLQW83V3l0MWNvNTBydE9K?=
 =?utf-8?B?c2ZpUGtGQldVNkJZbjJuZ2RJWmZRWUFzVGdrcjFIUVY3ZVZUV0pFckp1TDhL?=
 =?utf-8?B?c3VsbDh1WVVYV1pmUy9JTlRJalRPQnNCUFFTb1E2QjlhWC9qTVFMMFN3a2ds?=
 =?utf-8?B?NnZwQlFDNEJhNktzVVdLd3lqSXpwNWNXbDN3TGVjR3BRVzlaVjdOZXg3TGhs?=
 =?utf-8?B?TDJzbTBjOHEvMUsrcVRHRFVMUU9xTk9OYkZNQTFPUHVRU3AzaTllRG5MNXUv?=
 =?utf-8?B?TDJ0b1FFWGh3Qy8rRWdyRlBOQmtKY2N4ZCt5VG5Lc3l1L1dqTzBEbzRKcllM?=
 =?utf-8?B?UlhRdWtiWnFWSFBlQXc2SG82eURtaTV6RDhhbnNBZXhLaUdDZzkrbENHZzB2?=
 =?utf-8?B?VzdQVVdEU3ZIWXQxcjM4WElKR1ROcy9DZnBUSXNJb3Rqc0VzeHpJUGh1ajhR?=
 =?utf-8?B?VEZTK2dicDg3UktDR0FUL1grRnN0eitub05mbUZBV3c4YkFVc3E1MUpsdkdD?=
 =?utf-8?B?RmU3dUV0eEtmb09hWCs5aTRRcm9MSUpHUm91REh5c3BuMzVKczUwT205ZGw3?=
 =?utf-8?B?byt5cTFQeVBTRGVJZ2J3Z3phTTl0d3dLT0dpcDQwZjl3bExKMmdadUZTc1E0?=
 =?utf-8?B?TnR2MW03Y0lqZ3pXL0VXek5PTzhocVIvanFiV0lnVVl5WmZSYmxiTStoSFc1?=
 =?utf-8?B?RGxDaFVLSlNMcHdvdGhLek10a0hmNnVROU5POGhpbnpPQTZGUHZGV3BhWFg5?=
 =?utf-8?B?YVFwWWpGTjlOVUFUUW1CTXM5bVA3Q0Y3MWJzcmFxTXl5eFpEV2dZWTE4VHhH?=
 =?utf-8?B?b2trVXlLeWo0VG1ybG9rTHdiSXY2dXFsd0FEK29JeS8zR1p1UDdrUDdiOTJM?=
 =?utf-8?B?OGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43fa366e-5eae-410d-b8bd-08dde07ed6de
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 06:49:13.4565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZmzo0Zoc4TmpHydXCnOOF1eZMvJgFEpV2LkXtiVEZtB1pgRQ2I700mfW79PP0JVdvcvnEbuqmIO/dO/w1qXxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7347
X-OriginatorOrg: intel.com

On 20/08/2025 20:56, Yazen Ghannam wrote:
> On Wed, Aug 20, 2025 at 04:12:28PM +0000, Luck, Tony wrote:
>>>>> For struct mce?  Maybe that should be 2 new fields:
>>>>>
>>>>>    __u64 addr;             /* Deprecated */
>>>>>    ...
>>>>>    __u64 mci_addr;         /* Bank's MCi_ADDR MSR */
>>>>>    __u64 phys_addr;        /* Physical address */
>>>>
>>>> Would "addr" keep the current (low bits masked, high bits preserved) value?
>>>
>>> Yeah, it wouldn't make much sense if phys_addr was the same as addr anyway.
>>> Not really thinking
>>
>> The other option (but a bad one) would be:
>>
>>         __u64 deprecated;       /* was "addr" */
>>         ...
>>         __u64 mci_addr;         /* Bank's MCi_ADDR MSR */
>>         __u64 phys_addr;        /* Physical address */
>>
>> which would be good to force cleanup in the kernel, but bad for preserving
>> ABI (since "struct mce" is visible to user space via /dev/mcelog).
>>
> 
> /dev/mcelog has been deprecated for a while.

There is also mce_record tracepoint

> 
> Is the mcelog app still in active development? Could it be updated to
> use trace events for MCE info?
> 
> You could also just fix up the address value in the mcelog notifier's
> copy. I believe it has its own cache separate from the MCE genpool.

Is there an advantage to fixing up later rather than when addr is
initially assigned?


