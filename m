Return-Path: <kvm+bounces-64747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78338C8BC68
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 21:07:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F9B73BAD05
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 20:06:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D6F34250F;
	Wed, 26 Nov 2025 20:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OI9qne72"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EA033DEF7;
	Wed, 26 Nov 2025 20:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764187567; cv=fail; b=oxVUq8H3LMhZ53CuWTC4iubvz4/Iip/sy64QwRL6YejLW75OvOcSW5Q9I3Z5USQuzQWjvCGRhdxdOYV/y+3umLw8T/yMNbkUhFwTJivrx++0hLVEJSsLjk3ogpN4gyIhBeVRdF45FtCmXOdsSntY9iKLemsYlXgNJY1FrauYbuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764187567; c=relaxed/simple;
	bh=QoAraM1oOHcKEOZqE+u7GaldON+WZr312LqPAmUyLaw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cPpBE7JevgjgCZvYTb7WMWWqZW6c1nUhdIOmTzXV1lXfRMVZApYek3Gz/xI/zm6hZt1Q2+V81580eau7LQhLVurqb0NTIbKutW8o/HHlyp3kXVdOkuq3TJYK+UCuL6KrQragNgZ6LivuTu2tqqrNH/fRFpQRkj5P/mu5K/Gd9/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OI9qne72; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764187566; x=1795723566;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QoAraM1oOHcKEOZqE+u7GaldON+WZr312LqPAmUyLaw=;
  b=OI9qne72WYO7+VV1d/0n6N/SnMvvQxEVAPk9toYvqab3CPdWx6/PoSVd
   5o9nB/gRdyJJMyliYDYSae6BTRv9iVuvmVsQ7QjqWaZy35DQ7rpibRRj8
   9HkfpK2yaKutVGOBtmdf88dI9OVyrrr582HO/QGeZj62aAV6r9546F72V
   m87LJM8FtIs6bAkpkFxMJ+XPv3B1edp31bvIkN2FDm5l/8E91OMEM0Upb
   LwDv88IYJN3dxWzbWw5fi8j4nr/hwLSdzjqx+SNv2+D595fwBu4zoF14P
   MXGoy9lriYZBmnvgpcjhAVW+l7w6Z2KcdQ60B5cQ47av8Xv+R1HRuzA5L
   g==;
X-CSE-ConnectionGUID: 5fEMC8k0QpGgnmPq2hdFKg==
X-CSE-MsgGUID: 63jt0PorTqWgir6MgT0a4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="76921826"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="76921826"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:06:04 -0800
X-CSE-ConnectionGUID: jcOaOtXTRNSUOuCIUO8Ptg==
X-CSE-MsgGUID: 2HKZLXsITC28kgU8Hr6cpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="192166628"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 12:06:03 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:06:03 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 12:06:03 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.51) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 12:06:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P1opUjKiblqZyFo8DhkFayPIFCRuH5K3daXWIprPYWsSngqW9a3+/5i6LQBNz6OcV/eVgHEjfad8ubFZxPgZ0CXZziFrG+pKCim6pP0zmmw8kR6odihypmi0mL2M4hrJpruSJHVxL+iyKkQYyQ5ysgVd4HDBVPC3e+tKWO/5++k8kmJlKAyJE/zPTZ2yIBuNK9pzZMCKvfml6GBtRgV4RL05wAm2QqCa0nJBklP+SP9vdoWc39l2gs29oYiZpWrrLC5hAnkzLBk2QwYK5C/v62YiJUZV6XW5zU1Dgss3pF3V6PCinfqnfSaCL/0+lZgnlxwRAG34zyKv2n+CmF0zQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QoAraM1oOHcKEOZqE+u7GaldON+WZr312LqPAmUyLaw=;
 b=vMqCizp+Zy+A5iOM2WKQy7U9suiBM6PvGVnNAoPUZvPdfvAjQo0TL1jXL3TfTO9ThYi1BPZ1T/IpYrjIiTxCActa8xqdeTT3AA4EPHGzdOTaTVEGnV2rCqZQQDAfIYniPfi+pI8P6B2G8FUulsrzSSWKYjgATc6DoSmKL4CDdiOdbRzPnrAoqzu1J9YA8JEyxCzG53HRvS20qCyKtAKgucD7zC0iGk1NXZa3VvENhL6XXkupVLe4Bc6taoIkErbzjIQNSvj0Vl1eMGED5NfduuQm/LEsuqo+7ccw3Pj19TcnSyaHt61MzTSL5F5+cD6SLJIC8Kbz2T7twlmbBE/dLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB5871.namprd11.prod.outlook.com (2603:10b6:303:188::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 20:05:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 20:05:59 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 16/16] Documentation/x86: Add documentation for TDX's
 Dynamic PAMT
Thread-Topic: [PATCH v4 16/16] Documentation/x86: Add documentation for TDX's
 Dynamic PAMT
Thread-Index: AQHcWoENC/WRfYAFS0qVUQPt9qsqdrUEyy0AgACf+QA=
Date: Wed, 26 Nov 2025 20:05:59 +0000
Message-ID: <8959e398871906a2f1458c35a8f3c4f44945a0c7.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-17-rick.p.edgecombe@intel.com>
	 <96775d7e-e0d9-404e-bdb0-8c95db7f09cf@linux.intel.com>
In-Reply-To: <96775d7e-e0d9-404e-bdb0-8c95db7f09cf@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB5871:EE_
x-ms-office365-filtering-correlation-id: 59570f92-0b74-4ea6-86e2-08de2d2737ef
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?d2MzckUzamVuT2NkYVg3bGs2TnVjMTM3Q3EwbUgzZmRHZWlyUThXRDlydG1h?=
 =?utf-8?B?ZE5oM3B1OWl3akhnNkNFK3B3REZMbDF4WWpwOUhkNVpEMDlKOEg3YU0rdGtG?=
 =?utf-8?B?ajVQRnVqR2owQlZOSTYybFF0L2I2VTdWVjJWZDhoQTk0eGhPTnd1MnFHckxO?=
 =?utf-8?B?azZJYm1nUTZqRm14b3RCZGFMdG01WE8vSGhnaTNVTWxNNXAvQUR2Y2hLbUFW?=
 =?utf-8?B?aHlxZ1kwMlI4MDZ3TnM0M1E1TzZROEZIYTc5dEdCN1RLMlA1ZWl3YUNERjBD?=
 =?utf-8?B?Z2xhL3djN3NYVk1BSzBXRG1WOGhFU2ZDd0plNmVhUTZlWW42eDZBSThaWXhI?=
 =?utf-8?B?L0V0aExxcnlYc1RPdTc3TVh3bFVCcTR0TTJHSHRTYXZOSExUNUZQdlp6c29H?=
 =?utf-8?B?UkduODNJWW04aUE4a2hwZFZsOWhuMG5lVEJSdURoQkxRcmk3WVRDanVGT2gw?=
 =?utf-8?B?Tzc4d3Z1RUJXNk9hRmgyM2dvaEZCNG5ZU3FBOU1qd2RON0ZMTVdzclAvMCtv?=
 =?utf-8?B?bTZoR0RBaXFqK01FNG5YalB5WVBsclVZa2lzVTNndzVlc3UyV2x5T1NzR1l4?=
 =?utf-8?B?SnRBWVgvQ0hZb3pmRjl1SHltcjdhNG0ya3BmRmJzQ01peUtIV2pGM0NYSmov?=
 =?utf-8?B?dGdJU3RMMFVKeFZ5cHFsUWh0d2tFTVgwK1ZNc3pDdURlQjlRazRlRDI4UnZj?=
 =?utf-8?B?cjBwZDUyb0wwamFKVTJPd21Hb0ZsV3Y2Y2tpYjFZS1h3dStQVzhVUEk0VldU?=
 =?utf-8?B?VE9BS3QvTXAzbzZPS1NtUlFDeUxQZktPZG9ldlZXbHU5VDVlMVl0Zmp2NGo3?=
 =?utf-8?B?YVhWallveEdsc05VY2tySHVyTXNiM1BqeHYzOG5RZ2pINHh2UFVVNFlRYStK?=
 =?utf-8?B?VXRlS0N5Z2xKMDFHVktLTmM4SDRUdWNXeFFKRlBCSDU3RFV0ZjZpM1IyRXV6?=
 =?utf-8?B?eGNzZFNxazZhM1lMT1YzTGcwcm82THNhU1BhNUlqckhoTXNVNXFvOE52aWY1?=
 =?utf-8?B?akV1dCsxZmF2UE1FWDI0WVZ4V2QzWDA5RE03UTdzRFJPcFlQc0ZDbTlTR1c3?=
 =?utf-8?B?eEtEY0xLM3NCTzNDQnFBT3JPVUV6d0NhWGtUUFR0QlYwMGs2SHEyMDZ2bWNE?=
 =?utf-8?B?anZSTkZvN2hSU0dEQ29pYk1ybHBpVjdFMXdyVE9MZ1k0Rko2UGttRXJHOWFT?=
 =?utf-8?B?a2h2ZEp5UVdMcE94T3NXTEk0L1N0MkhpU01iQkRjVXRBN1NlVnRKRVdPY2VC?=
 =?utf-8?B?dmU3YW1SbSt4TnNieUZ5dktCbU5oNUxBRC9weExMOFpOeExIZ0duazIwWS9u?=
 =?utf-8?B?Qnd5Tm5tN2RYNTVxOGdXWUovNitsWGFqcEZ4ME1KenBFQWpITFZURVdKWldD?=
 =?utf-8?B?UWJ3bU93M3hld25TLy9Nc05DQjJlZm1vRk5LWFlQNjQwOWswMFJxcm5GbUkv?=
 =?utf-8?B?Qk0rNUcvSTgzQllZcGN5ZnJ0dkR2S2paRElhQ1lkNmozVURLc2N2aVlxeHEr?=
 =?utf-8?B?TjRZNGRXUnJIREU3UTFGZzh4cG8zREwyT3pJVDJIK2NjQzFla3hBczd6SERJ?=
 =?utf-8?B?U3R6dC9kMlZqRm93d0hFdlJFd3J1T1d1TXZFcU5NOGVqQXR6dW1TUE1TZllQ?=
 =?utf-8?B?YnZscDV5TjVIbTloaFVtSWxxSExmd09vZVdIanFkR0R1V25aNnNWVXdhcWRI?=
 =?utf-8?B?Q2tsN3E4N2tZNDY5TDhUd2xLN0V5WlpnK243Y0dSWDlzaFcybm0yYUlYZUJG?=
 =?utf-8?B?b25KcVVxeG1wQ0h1U0hZRGNNVlJMSWx4cEVrUHFXc2NHVmo3SWZnMG1HcFE5?=
 =?utf-8?B?ZnErOVpuVnU5S0I3R1hIOHRrL3I4T3ExK1lYa3ZIR2xFKytkTE1SaEtOMEpD?=
 =?utf-8?B?TkdFNFNkYUJIUFE4ZWdsT0d6QXpzOExyc1hLR2ZCSXp0OXhaN1JWc0VtamNk?=
 =?utf-8?B?THZSN3Z4Z0FRVmtRWTM0Smd1K1dSbVJMUFZnVHNZY1RPUU1LajJIZlVnRktT?=
 =?utf-8?B?WmViRS9RSUlXdnkrT1VBMWs4STQ4dnl4dEdVTGhBeGJLNVFibUVHM1MvUlc3?=
 =?utf-8?Q?x1KBJL?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L3FpNFBSeC96OGs2UW1iVm9pL2plT1ZpWUJCMkxzY2JYOEpXcURKWHNwOW8y?=
 =?utf-8?B?d2FsVWxaNnNMOU9SaFVVVWh4b2l5YXl6VzFvajBhd0V6blJUTVRpaWYzcEl6?=
 =?utf-8?B?UEdVYm1XZ3ZkYUlEdUoxVjRyT0NEbTJyWk9NQlgrNTRvbEZZay9wM3RMc1lh?=
 =?utf-8?B?VS9OTUhSWVpHYWFOcFM0VWY3S2hESEFPNUF4OXhVblAzQXRqcmFSRktFYllQ?=
 =?utf-8?B?dEw4SkJibDVnaXFVRHROSUdGMGgwcnJoM2tGaERvN3ZPV0pIY2RkNVFpejVz?=
 =?utf-8?B?cmRCMmRubjIwd3ZDQmFpbTJmYnBBNEh6eFc0K3RuVXd1K2s0eFpLTlIyNDEy?=
 =?utf-8?B?blkxejRiODJCaFM3T0NPbGR1TGs4ZkVYRktYTlBwRlY5MTRxOG1UOGxBWXVV?=
 =?utf-8?B?VmxBR0pJR09kdEFZSGlxRW51bUZDRTM2ejhTcVF3d2twOXBJNjVGMmNZWXpr?=
 =?utf-8?B?ZkxabUVVMmVqdE4xNUpqMS9ja1NZVkpnTXM2OEl1WXBaV0l2QWNCeHF2Nm1j?=
 =?utf-8?B?YXhQbmZPeFFXM1p4VFpTRDM4aERQajUyWitnTC9FdE1SeSt1VU02Q2NRVXRh?=
 =?utf-8?B?VFZ5MlJabHlTNDN5UXJQc2Z3Rk5vV1hWM295MlhqNW1PQlpkZzZpeGo3Mmhh?=
 =?utf-8?B?UlhCU2pZM1FUS2M5ZnhTeUJaWVdvTVdJTEVUZElqWVIzdzRrR2pEeEhiN1JT?=
 =?utf-8?B?anlrclg5Ymk2eGs3Tjl6Q2VDSktlczRDNFcxNXZFUWFpZEY1M0Q0WHRjOTJj?=
 =?utf-8?B?WWJ3SFNmbXp4TENUelZ3czg0dHNydXRrOFJPbEJveW51WkNqamFmeitpaWxi?=
 =?utf-8?B?ZGxYbWlwMDh4eXV5ejljVWtNL3E2YnlCbFc4WVBoYkRxWUkybVhBRzBob1Qx?=
 =?utf-8?B?RUFaTGg4V1hSMjZGMnJGa3Y0bC92RFN6ZUQ2S21hcUZJV3dBcWN2WWhub0NE?=
 =?utf-8?B?aisyODBTV28xZ1RuNjR5Nzg5Y242UFRrWllQQ1oxeUNGVlA3SGtUWjVvdW50?=
 =?utf-8?B?emlMV094cU9BQzRMS2xOMkFoMFFHbFE0Ui9ZTXQ0RElhcE5Wbzd0U2dZenlR?=
 =?utf-8?B?aEZMeHAxck9zZzh6WFlub09IbkZZVGdlSEhBampWY3ZrSGh5dTdVVmlTOGpP?=
 =?utf-8?B?ZSt2THpETWdmNVNud1JudkVURzQ3ZFdYazVZNE1kQ3p4a0o0Y0RKUklQM3FJ?=
 =?utf-8?B?bzVtSXpXaEhUOEtIR0I0MUJDTUt5amdGUHhReVI3WTR1d0I5T3l0RTVjM1VL?=
 =?utf-8?B?QzdtdVBLREtjcWhmdmtmZEtVZGlLUk8xVHRSTnZMaTIvbkRDTEU4c2NXeVA3?=
 =?utf-8?B?cXR1S1NCdVgzUU1tU2lXR29mQnVkOStWRjlZblN6dUhmRmpiWXlpcXJjK3Zx?=
 =?utf-8?B?R1NzVk1KL3JiaXlsUE95Y3Btd1NCVUxKQTM5amtaRXQ3WlJOWXRvVmtQQjZL?=
 =?utf-8?B?REhZWlpCc3VMWTFmbGlKZmdlRkZVTWZhQ1ZSQ2hzaW5oVmJ5NFhvUWg2MnRV?=
 =?utf-8?B?eVA0RUpuWDJxNnRvazNORFJzYkdKdWZiRHR1N3FxM2F3RGRKWjNabHp4bE9O?=
 =?utf-8?B?c09pRmhGMlNQazRUUDAzdkhmTHM4TGVtOU0wa2RNa0VmV2RWZER4NTlzandT?=
 =?utf-8?B?bXBPeDNtU0NiaVgrYWZYL1pFbmNnTEM0VnlYQVhRNi9ha0EvOGVMeHl2OHN1?=
 =?utf-8?B?b0VpYVhTRzRHOHEwYWN0dW04bThHbG4ySHpOQmVKT2NuS3ZCY256VG5QbFNr?=
 =?utf-8?B?dEpqa2pXYWdFbG1UektEcjdCcnpRMFVGOXpqcFVlUkVLejhUOEl2SEVRVm00?=
 =?utf-8?B?TFVUWmgrSDdnSmhJeFBOQnJsSndrcnhnMTFhZnphaWF0UjlTSWdEeG5FMTNO?=
 =?utf-8?B?d2owNnRMcDBhNlRxOXgwNGRqT2lUOU1laElVcjNELzhsYW5GRTMvQ3d4YmhD?=
 =?utf-8?B?dU1hSHpad0JrUkhIa0ZIZFp5OUdSU1Jydnh3RUh2d1JQMVdjQ29KY1dDb2pa?=
 =?utf-8?B?RnUxcXYrVDZBWElNWjcwQitsK2JJZnBjc2xhd2UyUFZXYnRVKzNOZXd0ZEZx?=
 =?utf-8?B?UVlVMWFNVXloZlRyN1ZMMngzU2IxQW9SNS9nMGxJL2p0dUkvUU9WdTg2SVdy?=
 =?utf-8?B?aXBFWHJ6YnVtMlU3elNwYVZOSnVxSDRUVWFTVVBHRUgyZ1B3V214VkYzY1ow?=
 =?utf-8?B?Unc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3DFB074D93BDDF4EB9CDD828658DF3CF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59570f92-0b74-4ea6-86e2-08de2d2737ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 20:05:59.8363
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ic7MFrvNBRrHPUnMfaQ5ebR/68xM0VuaXhl0tRGbuX7cuUr25XWzbYQaK7PvqkeDwfZgpSKFYjFdWwCXV2zgGZGjaTWZq7/zq5wBJWC8ZoY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5871
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTExLTI2IGF0IDE4OjMzICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6Cj4gPiAr
UEFNVCBpcyBtZW1vcnkgdGhhdCB0aGUgVERYIG1vZHVsZSBuZWVkcyB0byBrZWVwIGRhdGEgYWJv
dXQgZWFjaCBwYWdlCj4gPiArKHRoaW5rIGxpa2Ugc3RydWN0IHBhZ2UpLiBJdCBuZWVkcyB0byBo
YW5kZWQgdG8gdGhlIFREWCBtb2R1bGUgZm9yIGl0cwo+IMKgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgXgo+IMKgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgYmUKCk9oLCB5
ZXAsIHRoYW5rcy4K

