Return-Path: <kvm+bounces-71186-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SB7tAZHQlGlGIAIAu9opvQ
	(envelope-from <kvm+bounces-71186-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:33:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5760514FFDE
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D8FD6304917A
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5E3378D61;
	Tue, 17 Feb 2026 20:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lOvljdsd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6C9378D63;
	Tue, 17 Feb 2026 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360243; cv=fail; b=fqCeUnv2y6fU2iRWHWgxg5+kSm1aWc2ewzDmHKkt3NwZ+2p6ZYHDXqawmfT8cho9whtilQA/np0yCz6npYy1Peh6zqic8az/URch2L0GMCqA7+uLj+VoVhWQaG8PvLujDFutD1fdn7L8+s3kqr7E1ymUTmEAE8YmV80bEoqUR2g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360243; c=relaxed/simple;
	bh=igNzbk7XxBZyxMPHUqpPZ5E6OWWvKeeRuT0an1TnEIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YE8oW4luJpAdv7TisykOhVntJDsDCSNv2P3bn9+c6yGAk4DLfD1XMCp8cKA4qRv9TkCjldBYshZzjG1CYElzDLOhejoZAFBYxOOSRGG92TJv0FEgZekg9TCDHkFDbV7QNjO1EWtm0dPoT4373Yx3hubVKIITCB1nlWbG7Bz0WCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lOvljdsd; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771360240; x=1802896240;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=igNzbk7XxBZyxMPHUqpPZ5E6OWWvKeeRuT0an1TnEIA=;
  b=lOvljdsdCdnbs4QgRolyHGPfeuPRkvFEWAsEnQvewRGBDtSS7ryRLyzm
   MMW/hEEE8vmxaxpcP4YE4XoDg6V7CwSXhMUQAy+OBjRJ9z5SSubu9Y6Mz
   0AAha9FTS0NofNIaDmHa12nS+5HksbONMteiDg6+pFj1rJn2I/TlkKgq4
   uOnQ0osC7GD7Im080StYCQ+dg3ef5MCGBjQBd7iN9mRv2XNtezD1TV9Rz
   yw1PeefNPykZfZ3srArSlCIbDv8rRj/wjbpTQ2hBhYCaOWkLjjyvH8zAJ
   ysMFTXXqYDr1Q3tML2p8xgXFGBPRi5ZbzJJL9LZKjjzzPtkMJmT+JTG+s
   Q==;
X-CSE-ConnectionGUID: 0EChl0iPS3qHDCpWxCqtuQ==
X-CSE-MsgGUID: mtP/fLwAST+uzy0dXOmWag==
X-IronPort-AV: E=McAfee;i="6800,10657,11704"; a="72506315"
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="72506315"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 12:30:39 -0800
X-CSE-ConnectionGUID: nojbsuwGSh6R5+1gh2PcKw==
X-CSE-MsgGUID: 9u9NjHOvT3+9fXkIxp8Eow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,296,1763452800"; 
   d="scan'208";a="244582343"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2026 12:30:40 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 12:30:38 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 17 Feb 2026 12:30:38 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.37) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 17 Feb 2026 12:30:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BazWChL0jr2YSFI4oDENfKDMYlwc5Irk9RYbMPwKkUk4JQids3QF3QnR3huDRJ78tLME5/gT4OqVm+4c9b89A5Tn5VcyDtK0HcwsUI+04PqFkK+KfgEyaLwUCHMwaQvxl7CipLaVJe/7wkBQjNjMCx+elHv7fFlQMAuIecryRb486C2kJcHc3An9NSefBWcuEXWpQ5GmcVNZqKF9u+BJcBnFebaIcFJ+aM/DcaBEKBMf5M5sj+Ot12Dx4nyRB0LL+PIoDz+rcCbpuNJ2K98y8dVG30IRAkxsghVECaWHqi9nBgo6S9Mk7SpTv04YFwvrUUjE+cqwGhlKUDC+58gNPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=igNzbk7XxBZyxMPHUqpPZ5E6OWWvKeeRuT0an1TnEIA=;
 b=e8W7QpsPNrBOqvn3Rdj0czlKbX+coAnMagJX43nlyCe2Pesi7+srkZp0mqlOy4wPGGnNet2a7EqcBoUqQ89z6byEtdaJgWiRKn6UznyfIrwdg5jSESLr8BQi5Agps64Hr3rLUiCYiAo9cHYv2Pf2zE6EKxeMGwqobr9fueU6pVfFlhYvFuAYlt351habA9PH8vVN/mMP3QBvNFQqPOhqAjW4y08K5ewaC+MEoZ534aYA/gLWapax5vM/da/TfAROIccOpeXUSUrHGGjA04Pg3kItN3waJNXT/OJkHewBJxFemob9TpL2WIt2hQ+tpZqLftL3LY1GflJrkKFW1W3gvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by IA0PR11MB7936.namprd11.prod.outlook.com (2603:10b6:208:3dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.19; Tue, 17 Feb
 2026 20:30:36 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9632.010; Tue, 17 Feb 2026
 20:30:36 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "namhyung@kernel.org" <namhyung@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "acme@kernel.org"
	<acme@kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 10/16] x86/virt/tdx: Drop the outdated requirement that
 TDX be enabled in IRQ context
Thread-Topic: [PATCH v3 10/16] x86/virt/tdx: Drop the outdated requirement
 that TDX be enabled in IRQ context
Thread-Index: AQHcnVFb9iqZyCLtM0iMN9IRRY2SGrWGxqIAgABB6QCAAFVZgA==
Date: Tue, 17 Feb 2026 20:30:35 +0000
Message-ID: <95bab89e7be9837cfed4ace1a5af4bdcb7682ebb.camel@intel.com>
References: <20260214012702.2368778-1-seanjc@google.com>
	 <20260214012702.2368778-11-seanjc@google.com>
	 <4317ad31f4ef883daee264f72f032974c044c0cc.camel@intel.com>
	 <aZSIUJ_NXAMLVWJM@google.com>
In-Reply-To: <aZSIUJ_NXAMLVWJM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|IA0PR11MB7936:EE_
x-ms-office365-filtering-correlation-id: f0cb110f-7a3b-44ca-0034-08de6e63681a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cG4rSlNXSnRLSlBOdUdpejBOUSs5VmVzeTY4bzBNellydDlrZUh6RURtd3BP?=
 =?utf-8?B?Mk9YQXVFMVUrL0ZIS3pRclVTWERabGkyTkgxTWdRNXlqU0ZMMkowaVhEeGVr?=
 =?utf-8?B?VittM3FjMzZJRng1cmp5M1FrUmRGOXk3eHlsbFREUm1iZzI5RnJUY2tMOSto?=
 =?utf-8?B?MnJCSXBJRnNJcG5Xb1RKTTRDZVpnaW81SlY3ZmpKM21tOGhVZFBFR3Q4U2d6?=
 =?utf-8?B?ZW5yS0NHZVFFMUVmL3BaL0hCSUZ6Wm84K1pickw0alpacUp1SXBHZjArV0RU?=
 =?utf-8?B?bjB5dENrU0ZNbXBjMzU3eFdTRG8vNE1VY3ZTT1g0MEU5eUd1VXk4cjg0UkZQ?=
 =?utf-8?B?bVdzVUFXdUsrK3RJUTM1dE1kT0tvQ0Yvdmwya3dLQWx6NnBOQTlwU3BVL2dp?=
 =?utf-8?B?Y1NUb2F0YUhkNkRnOWcxczh2S0k1b3luc2laRTdCeUlsRHgrcE9wQ2daUWda?=
 =?utf-8?B?R2dOTjlTQ2Y1ZXlGYWlpOTVpU1VxZ28xSFBUZ29aSkVyVi8wRnZTS2ZydHh6?=
 =?utf-8?B?OTcycGl3U29CMkl4bVptaFRnNHNpNllrUGZkaFlacWdhNnBDZTBvMENFWENC?=
 =?utf-8?B?SXpWVHZtSGp0QXVWV2FhVUtiRU80MVBFcnd0TFF4ZTlla0N2RmZZMVBWK2VM?=
 =?utf-8?B?NllFaVUwKytxUjVPTGE0aTdaNjdSTzI5SncrZk1WOENLT1cvTC9zcTdNT3dr?=
 =?utf-8?B?bFJmWG1WRUZYbGhZZ3lQVTVCUG9NN0cxVWdKK2ExL2ljRjFza3BuM2gxeXpr?=
 =?utf-8?B?QkN1QW51TFFoNUJCN1hQNVpTelVZWFM5NFhvYms0bTZtOUMzbUNoV09iU0w3?=
 =?utf-8?B?NTBZeTk2MG5wN0lZQ2lSZFViWFZ1aWtLYjlNNzZDRHQvajd1VkNqNEd3aXFS?=
 =?utf-8?B?TE5oOG92d3g1d1BXM0RLY041UEtjN0Y2dkJpOGE5T1lkcVNaN3h2VUZueVoz?=
 =?utf-8?B?V2FiR0h0M2hRdUQyTUZHWmdXM3JkQVhZRkpvU29uZEk4YldEdHZpZWVjeXJs?=
 =?utf-8?B?dzRFbVFXTFRvZTZlNFV6OVIzN1VDTE4rRmpHSEkxRkRza1c4ZUd5aThTaXc4?=
 =?utf-8?B?c3k3SUFLQ1RNN3BjaThuU1dicDI1Y1JHQmtJM3B4cUxoWENheXRMYU1qYVAw?=
 =?utf-8?B?eVF3dWM2SGtEYVpaeDRUUFkwbUlkTk96WmxpaDdpUkQ3U2J0cmZURVVkanpS?=
 =?utf-8?B?clZ1UEY5VzZLN1B3RFdoSmNITEhQRU9Od1NWT2U0UVRZWFNNSWRrTWlXVXpX?=
 =?utf-8?B?SVZJMGppMDBZVVVOajd4dTZZN3VVbHJnU1ZMRzN3MXZxdkNsbmZXRXIvRnJ2?=
 =?utf-8?B?L3YzVWdERkxJWTdleDNUclBQazduTzg1RFIzSHQ4ZHQxa05od3BHUlBZOS9B?=
 =?utf-8?B?RFJJcGYzdzc1NFNwWThVSzdVS25jMmZCUGdoK1phSURkbm9raHVzSlNlWkZM?=
 =?utf-8?B?L2ZudjlJbXpBK1B3RnIzeHRaUUJaSEVqYnYrdFo0bDJ3U3dQbFpzYkthaUJu?=
 =?utf-8?B?RVoySGtXOFJpQ3phSjVVWnVoTFBBZDQwcmZqaDVBMEMwUW9nZ3d5MkdIR0hQ?=
 =?utf-8?B?VXZSNWQ2THpsOVdIaU1SN1d4cmtFZ0FwMjA5Q1d5N0NaaCtxNnpmS3J0RHQy?=
 =?utf-8?B?em5PQjZaeWs0VHdIaUJyOXR0bTVWdldMa1BhazEzRTFkMFBuZmhub3VGUjhM?=
 =?utf-8?B?dFR3a2RmK1JHTWNva2MrMnFqQ1JQcCtiNXo2eU5pc3JjZHNrdnVtVXNxWUFk?=
 =?utf-8?B?OWVWRmsranVralljR1hSTU9iYmYvcmZvUGlpdnVIbUFkUi9EVTJEanppNmNr?=
 =?utf-8?B?QTIvQlpxU1lsN3hjaGxtck01TWNNTW8za3JjMThPSVpXMWg1eEFmNm1DbzZY?=
 =?utf-8?B?d0xDbFRkNUVuTzd3a1JtZHFXWENGdzBHOCtRSzJyMGVjcVJQcVdMa2ZNb3RX?=
 =?utf-8?B?Nk82T0NKZWIvTEtNZjZTZnFsMlJFMThCNmt2OElVNDlMWVpCMG50UUkxRXc3?=
 =?utf-8?B?d0RQSVFJOU55emJrRE9IUFkrY0hKLzJNY2FMdDlET1N5RW8ydG81VTZKd2l6?=
 =?utf-8?B?N3FNcUVEVmhXWmMyR2NmcEtLcWx2NXF5TDR0anFPUVlHYi9FSEFQR2VmbnR3?=
 =?utf-8?B?U3ppbmhVMXhCblo2SkxxWmoraXdWdE94V0s4WklCQkVWTG1zQ3JGOUIxUzlo?=
 =?utf-8?Q?4WrbXo/PvA4TejQ4wbJuKCIImlzEJJpagWyUFfYCxrwV?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0kvWnpCV2xzRlNGU0FPaHZQd1FDZVR6cFk0aE9ReTQ0Mk5VQ0k5Mm1TdTFz?=
 =?utf-8?B?b01YRUJicVh1NmRsQktEc1dXcHZuSWM0TWFyVFpZVndKS0NmbWFYaXNqMkpa?=
 =?utf-8?B?NEFPc0o2RGx1UXZBYTFJV0NuWnV6ejdxd1JXakFrdGVTSWRKMHMvdWcyUEl0?=
 =?utf-8?B?ejg3T2ZyK3dhaFdvQXZVUnJwb292VmkvemRRRDRZTkNheStiMkkyMnJzelpX?=
 =?utf-8?B?S2FLdStCeTJTVGpoNk8rYVQ3TGYvTnhtMDZBS1BBNkV2WnpnVk1oVDJMeVBV?=
 =?utf-8?B?SmRUeGxiRWxsTG9HYzh6QThaeFFXbVNLdEhJTDVpOWxvY1VBODd4WnczVU1q?=
 =?utf-8?B?Q0hXUElhSDYyOGdKbEJMUldFN2NRVUxlRGxkaWtrdlBsNloxeWpkVXAySU84?=
 =?utf-8?B?NXZ2cG1UZXdjajFBN0t3UHRoaElXTTB4dWlHTzQySWZ1VGV5UGR4RjdJdWlE?=
 =?utf-8?B?TUM3UGxqTy9YY0NTMytCZWhIMVIwWm80REx4TmxKcTI3SVd5dmx1ckh1SEsv?=
 =?utf-8?B?Rk00ZlRsQURacFNWc05lc2NWT3JHY25iNWN5Tmo5d3p2Q1hSU2pBT01VeVlV?=
 =?utf-8?B?eUtJNGJDaVFJSW5Qd0lvc2tPcVJUdmxtNmZmRitGQUY3eXNRTWVMREttRUNL?=
 =?utf-8?B?elFHMU1sa0JicEhERnFxSERMaHNIYVJMUTBsOHdKU3h2TG8yZ2RCa2ZUVkFJ?=
 =?utf-8?B?TFIrcHNodlAxTi95MmNxZmpwZUJzUkV3RnFXM1o2bE9kWnArS1RwL1B2TFpx?=
 =?utf-8?B?eHg2cy9ic3RwckRrK1NGZTJWb2drU3BNZVBrMEV2TWNvSzZJajg5VStyTjA1?=
 =?utf-8?B?UFdpVlFuQURzVkNVc1RKZjlGamJ6azhwMTFXc0lHczJHTm9mMjRWbllacVNi?=
 =?utf-8?B?MzlKYVA0ZzFlQzNGdEs5eCtFckF6SktuYXVNVmdkeGJUOFVRN3ZlaDVFejJz?=
 =?utf-8?B?dUZNelJtS2Vka2duMXc0dnA5a0lSMzZnSTFnSEZzV2k5K09LUHdDS25tSXJ5?=
 =?utf-8?B?dlcrOGNEbjVuNXNWRjlYUVczeTBXVXl3TVF1blV4SGpkU0dLZzkwcmdhbnpE?=
 =?utf-8?B?NmU2bFVIYjliZ1BOcFRtMDlHdFhNNUFvVitZM3M5SnFWNlVXVFdZS3ZzUU1t?=
 =?utf-8?B?ZEZ1aDNwSFBRVjk4emMvcnhWRFVXaWpyUlBKY1ZMZHp5cHhjNFpFZWpqRWRz?=
 =?utf-8?B?dW9uUjVNN1ozUHRoL0pFS3pHNHVkNm1JRytmYXErTHdFT0FjaWkrdWF2R3pS?=
 =?utf-8?B?QzV1bzNZTVRITjMwVnJOVDE2cVRaU3BRSUxManNBMEpjSXZPOGI5SldTdHNR?=
 =?utf-8?B?T3ZmUmFrblpqQUtGMkpMS215VG5TUVY3RGpaaXpyNWhRbytRajQ5TXk5bzNT?=
 =?utf-8?B?VlJqRmxqNFpTQjdZVGViR0tEQmhJN0JVRlgzd3RrWk9SZUErd1F0ZXRucEFS?=
 =?utf-8?B?ZXVVMnROblN5YVlzNmVLVEVKV0pVc01FSkJ4WmhQZ2tpaTRPZGY5Q2FaT2pT?=
 =?utf-8?B?NWhFTXJGN0ZURXJuQko4QWFKVzF2VTg3VkpxYXJCTm9DZ2hrdXFOeFgyS0Nh?=
 =?utf-8?B?RTJHdmFqR1VhY1didnBZZTQ0a0tlQ0NIT2ZYMmJpS0QvV2w5c2V2UG44U0l1?=
 =?utf-8?B?d1grOEhSWmxoZFBIYW00L3ovVFVPR2xjckJ4R0hlWDBqWld3TGhZU000akk5?=
 =?utf-8?B?bWlRbVpFdW02ZnNHVXZUcjh3WXE2bjBTUnE0MlpTaEIwaG1SOFZpZHBrdjUz?=
 =?utf-8?B?YWdDZ1pHbUJFNTByb3RYTHh6ejR2LzEwWFI5cFJOZnlSQi9xRnhFYnVONHAy?=
 =?utf-8?B?RnlIanFjYU1vYjYzV1kyWVNDSlQ1RHpqaFZNSSsrR3RPUExhSHdhTkRWNEV0?=
 =?utf-8?B?eHA2M2lncStjbU1RVVNrbFplZjZGWDRKcW9DK3AzdmtMSCszZDVhbE5CVkdH?=
 =?utf-8?B?aFVaSWhHblc4VGdyYzZrc0JoVlVlSGh1M2N6RnhoRUNxVWFEcE81M05xWmdW?=
 =?utf-8?B?UXpyMmI0RHloVkxwQVE5aDFPU0g4VFNRNWJheC9XY0h0T1BmdEhSTUgzOEto?=
 =?utf-8?B?ZFdNc1dQT1NMSnNXaDBFcFNETmd2VlVtYTVxK1BvdnEveXJQSEdteW5pSU9Q?=
 =?utf-8?B?M1Y4bWNBdWtKZWdBbE5LTXhrelJOL05kNk41d0RjRVFZWGZjTm1wTXhqNTVn?=
 =?utf-8?B?MEF5dWwvTFoxUlpLTmd3T0xYZUFsb0tXUXM3OFBDeWYvckJTY1M4c2UzMmtz?=
 =?utf-8?B?dWtEYzgzVVNMbWg0Qno2REJrM0tBSm9XOFYwc0ppbi9NRlpLOEtSQWFjMkx6?=
 =?utf-8?B?OG51SlplajFPem9aamNvZHQ1MC9RRjVOb3owSW9EM3pnUnV1OHVmdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2679D6DD3B31374C96BE939C3E718FEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0cb110f-7a3b-44ca-0034-08de6e63681a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2026 20:30:36.0365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blNUWzw+7z2gI/9+4aGijJgCMceZlsEm3LAFATR47cfuMBSb8seIGXmHNfMi/FrgvxRw6ZA0cRXI1CmOWVeJcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7936
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71186-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5760514FFDE
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTE3IGF0IDA3OjI1IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEZlYiAxNywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIEZy
aSwgMjAyNi0wMi0xMyBhdCAxNzoyNiAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IFJlbW92ZSBURFgncyBvdXRkYXRlZCByZXF1aXJlbWVudCB0aGF0IHBlci1DUFUgZW5h
YmxpbmcgYmUgZG9uZSB2aWEgSVBJDQo+ID4gPiBmdW5jdGlvbiBjYWxsLCB3aGljaCB3YXMgYSBz
dGFsZSBhcnRpZmFjdCBsZWZ0b3ZlciBmcm9tIGVhcmx5IHZlcnNpb25zIG9mDQo+ID4gPiB0aGUg
VERYIGVuYWJsZW1lbnQgc2VyaWVzLiAgVGhlIHJlcXVpcmVtZW50IHRoYXQgSVJRcyBiZSBkaXNh
YmxlZCBzaG91bGQNCj4gPiA+IGhhdmUgYmVlbiBkcm9wcGVkIGFzIHBhcnQgb2YgdGhlIHJldmFt
cGVkIHNlcmllcyB0aGF0IHJlbGllZCBvbiBhIHRoZSBLVk0NCj4gPiA+IHJld29yayB0byBlbmFi
bGUgVk1YIGF0IG1vZHVsZSBsb2FkLg0KPiA+ID4gDQo+ID4gPiBJbiBvdGhlciB3b3JkcywgdGhl
IGtlcm5lbCdzICJyZXF1aXJlbWVudCIgd2FzIG5ldmVyIGEgcmVxdWlyZW1lbnQgYXQgYWxsLA0K
PiA+ID4gYnV0IGluc3RlYWQgYSByZWZsZWN0aW9uIG9mIGhvdyBLVk0gZW5hYmxlZCBWTVggKHZp
YSBJUEkgY2FsbGJhY2spIHdoZW4NCj4gPiA+IHRoZSBURFggc3Vic3lzdGVtIGNvZGUgd2FzIG1l
cmdlZC4NCj4gPiA+IA0KPiA+ID4gTm90ZSwgYWNjZXNzaW5nIHBlci1DUFUgaW5mb3JtYXRpb24g
aXMgc2FmZSBldmVuIHdpdGhvdXQgZGlzYWJsaW5nIElSUXMsDQo+ID4gPiBhcyB0ZHhfb25saW5l
X2NwdSgpIGlzIGludm9rZWQgdmlhIGEgY3B1aHAgY2FsbGJhY2ssIGkuZS4gZnJvbSBhIHBlci1D
UFUNCj4gPiA+IHRocmVhZC4NCj4gPiA+IA0KPiA+ID4gTGluazogaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvYWxsL1p5Sk9pUFFuQnozMXFMWjdAZ29vZ2xlLmNvbQ0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+ID4gPiANCj4gPiAN
Cj4gPiBIaSBTZWFuLA0KPiA+IA0KPiA+IFRoZSBmaXJzdCBjYWxsIG9mIHRkeF9jcHVfZW5hYmxl
KCkgd2lsbCBhbHNvIGNhbGwgaW50bw0KPiA+IHRyeV9pbml0X21vZHVsZV9nbG9iYWwoKSAoaW4g
b3JkZXIgdG8gZG8gVERIX1NZU19JTklUKSwgd2hpY2ggYWxzbyBoYXMgYQ0KPiA+IGxvY2tkZXBf
YXNzZXJ0X2lycXNfZGlzYWJsZWQoKSArIGEgcmF3IHNwaW5sb2NrIHRvIG1ha2Ugc3VyZSBUREhf
U1lTX0lOSVQgaXMNCj4gPiBvbmx5IGNhbGxlZCBvbmNlIHdoZW4gdGR4X2NwdV9lbmFibGUoKSBh
cmUgY2FsbGVkIGZyb20gSVJRIGRpc2FibGVkIGNvbnRleHQuDQo+ID4gDQo+ID4gVGhpcyBwYXRj
aCBvbmx5IGNoYW5nZXMgdGR4X2NwdV9lbmFibGUoKSBidXQgZG9lc24ndCBjaGFuZ2UNCj4gPiB0
cnlfaW5pdF9tb2R1bGVfZ2xvYmFsKCksIHRodXMgdGhlIGZpcnN0IGNhbGwgb2YgdGR4X2NwdV9l
bmFibGUoKSB3aWxsIHN0aWxsDQo+ID4gdHJpZ2dlciB0aGUgbG9ja2RlcF9hc3NlcnRfaXJxc19k
aXNhYmxlZCgpIGZhaWx1cmUgd2FybmluZy4NCj4gPiANCj4gPiBJJ3ZlIHRyaWVkIHRoaXMgc2Vy
aWVzIG9uIG15IGxvY2FsIGFuZCBJIGRpZCBzZWUgc3VjaCBXQVJOSU5HIGR1cmluZw0KPiA+IGJv
b3RbKl0uICBXZSBuZWVkIHRvIGZpeCB0aGF0IHRvby4NCj4gPiANCj4gPiBCdXQgaG1tLCBDaGFv
J3MgIlJ1bnRpbWUgVERYIG1vZHVsZSB1cGRhdGUiIHNlcmllcyBhY3R1YWxseSBuZWVkcyB0byBj
YWxsDQo+ID4gdGR4X2NwdV9lbmFibGUoKSB3aGVuIElSUSBkaXNhYmxlZCwgSUlVQywgc2luY2Ug
aXQgaXMgY2FsbGVkIHZpYQ0KPiA+IHN0b3BfbWFjaGluZV9jcHVzbG9ja2VkKCk6DQo+ID4gDQo+
ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcva3ZtLzIwMjYwMjEyMTQzNjA2LjUzNDU4Ni0xOC1j
aGFvLmdhb0BpbnRlbC5jb20vDQo+ID4gDQo+ID4gTWF5YmUgd2UgY2FuIGp1c3Qga2VlcCB0ZHhf
Y3B1X2VuYWJsZWQoKSBhcy1pcz8NCj4gDQo+IENhbid0IHdlIHNpbXBseSBkZWxldGUgdGhlIGxv
Y2tkZXAgYXNzZXJ0IHRoZXJlIGFzIHdlbGw/ICBJdCBzaG91bGQgYmUgdG90YWxseQ0KPiBmaW5l
IHRvIGhhdmUgYSBmdW5jdGlvbiB0aGF0IGNhbiBiZSBjYWxsZWQgZnJvbSB0YXNrIG9yIElSUSBj
b250ZXh0LCBzbyBsb25nIGFzDQo+IHRoZSBmdW5jdGlvbiBpcyBwcmVwYXJlZCBmb3IgdGhhdCBw
b3NzaWJpbGl0eS4gIEkuZS4ganVzdCBiZWNhdXNlIGl0IF9jYW5fIGJlDQo+IGNhbGxlZCBmcm9t
IElSUSBjb250ZXh0IGRvZXNuJ3QgbWVhbiBpdCBfbXVzdF8gYmUgY2FsbGVkIGZyb20gSVJRIGNv
bnRleHQuDQo+IA0KPiBFLmcuIGFzIGEgZml4dXANCg0KWWVhaCB3ZSBjYW4uICBMR1RNLg0K

