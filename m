Return-Path: <kvm+bounces-50827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F305EAE9C2B
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 13:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 990801C20773
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 11:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81C752750EE;
	Thu, 26 Jun 2025 11:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bAN+vnjK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F351A5BBE;
	Thu, 26 Jun 2025 11:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750936106; cv=fail; b=PAx3WcBFWm6dE95z1/xGgTfCgNVDhuk5D6fCW26BNcGi1M+BVzvFJvbKU7XPX5ZahUf1m1gUcUlnc1pWCo3NobytMgYckonc7w7tyqMQZ/Dgs/78Jjc/RMJ48iXDL77WUEingFXy63mrtX6h7yrNo8ACmhjfBbaCPbRYy1YqPDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750936106; c=relaxed/simple;
	bh=3M39wb12yJsKymdA5bxl3eAln2IF1D9Ljg2GxiuWuI8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=s1iTdTOcElsjrLba5qkCofDtlS67o0yEnFkzaGEHbX4mvM1dFYb1choNPAM0RBguAFvE8vlsiDbofWkd9nkbpCM60+iz83123ZnuDyOc0CSGkAfU1m6MM93kqTsIIQXhsj8SknX9ThorEDzlb8aMhOXWG7YUZiyeLtrLS5nAy5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bAN+vnjK; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750936106; x=1782472106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3M39wb12yJsKymdA5bxl3eAln2IF1D9Ljg2GxiuWuI8=;
  b=bAN+vnjKfKLBDpEuLkbRb0q5yp1RM/YyiEEo8+tV/38GIngqdV6sCtyj
   SIBU58ckYsbExfMkVhEeQBlfCN8klGcktKVFevi8baU2s/fETtR6KwAiU
   yNx6A2t3wMtITn8r+0RI0njCR1feTTZGD3dwJUdevqteDvDfKSeDHmHDc
   Wk/5mcayFKVZXbbZ0VXu+ZBCZE8p7jhuJt34muVxaE3D85S7L31jXe4GG
   qilXIrnZmMcId36llc0MpQ3LtqvXzknx3Mw5Wwl/NS1aOaB9h018ZeylE
   Ze0ot2tefkYuOk4cOzG1zWU8QDu9wKfc7Wfd8U7wWv8Z146rvCiC0wo0p
   Q==;
X-CSE-ConnectionGUID: SWeb1sI+TbaCh6JJBqhmSA==
X-CSE-MsgGUID: jdTzm4iHQUicg//9q9bLwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64663236"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="64663236"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 04:08:25 -0700
X-CSE-ConnectionGUID: xlpgVhXkQ4GIIRTAVsQykQ==
X-CSE-MsgGUID: 59RMZsB9S5OlWefxfyPGMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="157991013"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 04:08:24 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 04:08:24 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 04:08:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.45)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 04:08:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+vyZj30qi4oEeSrAICso4ohrqydbwvGvRe1nGrTGi1tqlUC4QrBFTNHvl8wVkSrqwWUfZpSjBxwqEI0+y3G2A75hHYBc9tcrO0GznWnUCqz5ELcRSyNdyrn1L6biIN6q0P3PfBdWb+eJN3rn1bbTYO0Cp+/jLJ27UvDQDmyTohDhz2V5gAPm1t3+jFei2jHh9JBphWYupI8ElxVQi+chDtJaLWoiPFAkwYk+H9Udm16R0S1cwKi6H7g+K5hIR6hYaRzGLl9zT7oORjt1mVBOe/dCMaAQKCOXgZLaGed4nKlrcOuXxc4fHgUgQFcBk/yNCSdccK4rWonaRpADsQ35g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M39wb12yJsKymdA5bxl3eAln2IF1D9Ljg2GxiuWuI8=;
 b=ngQI7KEsS1QwdX+rNU3MlBz8uBYE7/0QF19flQ8lzSWa+KFgxcfQil8oB02jql/8U97jyegLGoSG+AnEcuJzlTAoBtk/OIoCyXD/BC9Nc/vu3XosO4QpqANllUtq1n7C5NsWZVPDuTykmFz7BDwxs1KD4SYqo3eFEccm7vl7/v2zp0DUx4Zt/1J31HMT7JWaOuSbrVfs1uiQR5QkPhOhWWUOVWRzrbqIhsQHBkMiRaGt0+zwFznJZpOrG7ud7MB5NizQYERtlhCIl4cxjAUn9do1d4wYVCiy6zioRgvo0vru6tDMfuxtFh7+RqXUTiqTlw0qspcf/S8yqQGGmXT76Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 11:08:08 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 11:08:08 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Topic: [PATCHv2 02/12] x86/virt/tdx: Allocate page bitmap for Dynamic
 PAMT
Thread-Index: AQHb2XKqHP8h0XH8IUWO9sF+JPLhmrQVYkiA
Date: Thu, 26 Jun 2025 11:08:07 +0000
Message-ID: <cb164ed520e0921ff525db73754759a5c1d135c3.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-3-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4771:EE_
x-ms-office365-filtering-correlation-id: 6d17913d-b3c4-4de4-b89e-08ddb4a1bb40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?N3dOQkhHTUdNMnVvK2t5WXpqMU1RKzhTeisrWVpabFBFOG5iWU04Z0JCL2s5?=
 =?utf-8?B?WlFYQys4OERJV0FZMG1QWnpZSEJTUmJsMC91aUFJY3FGbTZTVlBianRXU1ZM?=
 =?utf-8?B?anpxY2puVi9hRFNwbEEzcGlWSzdOSENDK2lRNWE5a3dHN0c0VHhodk1GemFL?=
 =?utf-8?B?TWFjNWVCUndyTWxKOVlZVUlMUGNTeWlBWHNFUWpxVjZoRlRobnQrVytxOEJW?=
 =?utf-8?B?WjFDUE1ZV0g5YjBxaGEzZG9qMEd1Nm5CN0xPVE0wdCs2Zm1Yd2h2ZVhRclBN?=
 =?utf-8?B?aUo0V0FqcjduSDl5bWt0WFNjRVFCWXhiZ2k1QlpCd2RFak0vdmZlcVB3RG5T?=
 =?utf-8?B?THFiZm9iSE92RFI0WHV4RkN6anV4VGV3M2hxeTlvcWZNN2Zqc3NiRCs2TXZL?=
 =?utf-8?B?L0JQVzk3UGtrL0NBaDJEcEtCQ3JtMy9iNkl1bkVrbzZua3ZaMUVscTJRcXk3?=
 =?utf-8?B?R2JNRlQyLzgzK0dUNnhFUFFTZDVBTW5ZRlFoY2w5Zzh2RTdIYm9LNHN0TlZj?=
 =?utf-8?B?RERVK3VOT2ZNWUpUWkVrMmJNQ2FScVdZOFZtblRyRFUxMjBzVk9xODlwYml3?=
 =?utf-8?B?QmdKaXdPYTJManFnNDNxWVRhNTJsYnFYczcwVjRlRFF3YUpoY3Zsb0tGNjVQ?=
 =?utf-8?B?MjI5T3FaVEpvckFEWjRxTllYKzZpWFVaS1JQQlBLUUdvUU1FSXZibVZ2aE1V?=
 =?utf-8?B?TzhGeDM2aG9IM21wZ24xZlFldCs3S25EdnRjUjBEVitYZkFVaTl3TkRUdHRW?=
 =?utf-8?B?TzBlQVBDMU5hcWQ0Wnd1Z3VXdDVXbVRyYUh0MnJiVEk3Vk0rSTUvSVpndDNZ?=
 =?utf-8?B?RVR3OWpDLzlrRlZoZVF1TkFkaGpIMFRNM0d5TDFFbFM0K25ZUE94T0s5V0ZZ?=
 =?utf-8?B?UUR4aVlrNzJHSFRsOGJHWDBqa2wrOG9xbXAwVkZnSmxwTlRWNWxaYTRlb0Rh?=
 =?utf-8?B?ZCt3dFEyRjdiRzQ1WmtuVTdUOWhyRHgwSlUvUGNqT20rNVdCN2FjekJKM1p6?=
 =?utf-8?B?NlR0cTdmbStqUytEVTdlUUlJcnRKQUZJUzY5akF0U1FaZkcxc2pCK042UjQ5?=
 =?utf-8?B?NDRKcjk4bEh6enl6TUhiV3VQbm9hbTQ0MFZXNXBwbjJYaXZ5Tk9OZTJwZEhV?=
 =?utf-8?B?enRjZGpWOG5GbjFRclFHdnNNR2VNRVJaWTc5T2tocThUTEhUVStrdng5SWo2?=
 =?utf-8?B?cUI0cmV6NE5Ec1NsU2k5WEJSU2pMQlF4VkJRbTVVd0NrSHAzU3B4VFhQOHFP?=
 =?utf-8?B?eGR0dUc3NjhFS3JoY3prN04vM0t1QjJpTkZwVGFZMjhqY1JYU0w0RmJvYmho?=
 =?utf-8?B?U2R4Vk5Jb0FjL3hFa21YeFhlaXJBMFRFOGxOdU5JQmEwRFEySmU4SWpudzhI?=
 =?utf-8?B?bTBpOUpPSVg5NXhydG4ybXl1aVlYMUd5Z3ppM0pWNENLZkFSTnlqNGJIZU1H?=
 =?utf-8?B?cnExUDlSOWJ4SzVpZFd1VmwrZjNqUmk5VEFnL2JWZnh0NUl1Ynd6c0Vta3Vy?=
 =?utf-8?B?cEc3elRaa3Y4TFlYNE85Si9NSXlWemVmTTNidFFMdml0dk9MWUJtZ2ZTZWZE?=
 =?utf-8?B?R1ZlRzVpWHU4RkxneWtIUnk0TDR2U0xLYjdZalB2QkFSaGY4WERBYkdFQ0xT?=
 =?utf-8?B?OGJYR0hzZmxieFRkZk84Tm0zVU0zbU90NTBmNU9idFdsRmRjcDNjSEZnYVJZ?=
 =?utf-8?B?Zmg4Z3lrTHBQTnZKc1lZUTRhZkxvNG40bnA1dVR6eFZBTHU0SGdnWkVQTGhw?=
 =?utf-8?B?cUozM083SDVJWDdxQk5QVWVHYit6WGp5N3FQWmtYek9kc2d1Mno5bHlLakxL?=
 =?utf-8?B?aTFFWDl1U1M3QkhueGdrbERadlB3QXhNemVOaUpwVjBlaDA3eE9Bd0N0NHJK?=
 =?utf-8?B?R28wWFJWSmxjVzJvUEgyRjFXVmhEU3c1bXNUazZaWDVtd3l4Q1NMaFEvUlpD?=
 =?utf-8?B?SnRpdklkSGZQaHJvK0t4M3JDOWV0TlY0aHYxZ3FzNXJUdnhzdGZXTUJxVjhT?=
 =?utf-8?Q?TCT9t5uc2DZj5RkmdOIj7Xppksziws=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGV4TTdoOGFLN0xVeW5DN1NrY2l6SXQyVlkwQ0w2MGNlTWZKSUlCYXZGWWJx?=
 =?utf-8?B?c05uaHVlS3ZXRFVFR0VtWTVEU2RNWlFEbkR2OE9GajhZdFpCdTQrTno5REw5?=
 =?utf-8?B?czR1NU94WDFrZTg1VHNqZDVSSFlFek1qYXRHN0YvZWZMMFR3cm4rRTZKVmUx?=
 =?utf-8?B?TnZ1ZndnbXhuSWRHWEw0SEpZbUFMUDV0T3U2NDhXWGl2OVlWM20rRXFOcjlO?=
 =?utf-8?B?NFYzNmwyRWNRNVRrbzJBRjhMb0ZBV3BtRlRleE5BT241NXFXa0dZeXlGbjFM?=
 =?utf-8?B?MzdUR2I5NlZFb1FYdUhYMGVIWGdza2N5K1pjWm5XUEwyTS9CNDhmRkpCUzZF?=
 =?utf-8?B?T0wxM1dHajdpc2NMSWxJV2pUdzhmVWFmcjczeWk2MmhIcjJBRTJSWUNvcVZY?=
 =?utf-8?B?dVA2QTdIR01PUG5WM0trcWx2UkNlNkNSVk5QRm9HY3R0VjhtL1V5K0syVFdP?=
 =?utf-8?B?WVZsM0FWdDJXbnNVam9jV3lTTDNNSERKa2hRenNMSno0bEhRNVVFV2hNZzRG?=
 =?utf-8?B?TnhXYVBUSzk2SncycE8xbjI2a0RWZ2YwOW4vei90ZXEyd2JSQjVNWE5ONFBy?=
 =?utf-8?B?VlJWMVFIYlRRRHlpOEQwTmQ1aW9QckpjaDhDcnhiSmwyeUIzRTFIaDA5bjMv?=
 =?utf-8?B?WHl0MGtZVDNybUJ3bzVCY1FjZjgyQ1lyS0szbHNTNUxFSjF1UUsxN3gyWmJK?=
 =?utf-8?B?bGU3LzhSbDlUYUthdXpnNHlDaE9COGJXaW5BenJETXQ1a0laVVNtZWZySkt6?=
 =?utf-8?B?azFZOWNkMmlZYWVQbzlKcnZZODRxTjFqdVAwS1RUWjlvL0pyTTQ0RGJoT3JX?=
 =?utf-8?B?OHRqYytsUDk1OE9UQTdUQ0hDY0FieEdkNlhnVnV4RzRXRjVoM3BDZGlDODR0?=
 =?utf-8?B?RzEya2hYejBsSkk5R21TN2QvVXBGQmlRdVcvWitpRnpBQ3ZYaTBmTmhsclhN?=
 =?utf-8?B?RWQvRUFkVmhDdlJBa1lVT1JkTXBGTm55U0hsN3NhU1dXRFZWd3lwSDBTVjJG?=
 =?utf-8?B?ajc1dkd5MHZCN3k3bHhJbXh2YlhxRktoUFB1bnpWalAxSnF0VzM2a0NFclRO?=
 =?utf-8?B?Q1FKRDJRTHlsWWptTHM4dFF5N0lHREFyL0RPL0xzek45U1RLSFlpNDIvaXkx?=
 =?utf-8?B?Z0ZIUEh1SzB2TFUvaDRmazNqRVFrdDRwcmUweHRPNUcwYVJJby90aHR4WEF6?=
 =?utf-8?B?OFQxM0tRNVR1UzExNkFYQ1U1a1FJejlVdDd1a0xnRTZUYVBFVzFlUXVWM01h?=
 =?utf-8?B?K25FNjM4TGttYnlLaFcxc0xpRzY0TGR3aXdaL0JBWkh1L1dYMTFEZXRKN2lz?=
 =?utf-8?B?bU1OdENwQnY1UXRocTZoa2J5RFNrUHptdmxXU25lbzNUNC96dUREZG0wZmtx?=
 =?utf-8?B?dWxTZDRkWFRlc2paNVpvM2RTckFZNm84ZDd4eE1XVVp5WXhSQytpRWpkWjRm?=
 =?utf-8?B?OXlhQndBL25sOEViS1cvNll2aXZhWXl0VDlEMnR2Yzh5anlrMFNwc2lmNnhY?=
 =?utf-8?B?OTlwcUx6S1o1R1hCUEhNVGhVQW5DUFFDY0Jid0c2Yy9ydFo2dzdESG5iMGxu?=
 =?utf-8?B?cGNsM2hBRy9McW85NVZzU3QzUzZMeUZBbTB0Q3RNdXhoQzBEclhXaXU0V292?=
 =?utf-8?B?c0JFNlVwKzZRVGxGWStEcjJXV3ppM3haQWtGWkNRN1E1V3IxUlY5bjJNaFJr?=
 =?utf-8?B?Zk5MbVhzVVpvSkVURUwrSTlzY3hkOWcyYWFKZ0hwUXZBc1Y2MXBNL0dLVUx2?=
 =?utf-8?B?NEVhOEpKaDBkOHV1cWxwZHVSZTQ2dlhtMHVvTVJ6V2hPV0w1aHg0dU1EVVdr?=
 =?utf-8?B?SlVSM0d5bUR5a2dVaFQ4a25hU0lkRjZSZjZKWjR0MnEzMm5RUTZqU29pWHpm?=
 =?utf-8?B?TXg4SFRxVnlRaHJYYnBycWtHMlNubjRUb1VoeUFuSnZDRldZQTRkbkgxMzU1?=
 =?utf-8?B?bVlIR0czOW4vdEMvWlNiVDhrRkRaVldIRTMvcGxDNy91ZzYreUZGakxTNnJO?=
 =?utf-8?B?ZC8xQUVwOHAySkIrZ3FxM1R6eUFuSUdJdC9PWnR4bEREc3pWaldvTHZNOXd1?=
 =?utf-8?B?d21tRVh0YzhXYmlDSFJKYlVHN2N0bDRmT2F0bWlucm5rRlE3ZmxLZHdwRGhx?=
 =?utf-8?B?N1V0elFyeFRVRlVIODJ1Z3BVQktPczFzNFdwU3BDazRhWGlNelBlQk5sWHli?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <315E230819007A4895A883C5A175FE14@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d17913d-b3c4-4de4-b89e-08ddb4a1bb40
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 11:08:08.0730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oVrgqOgdKOW2Mpr6hoXpWLfYtXkLn6SIo7rjMorCcW+XW9+cuJjSfJ6Pna135a/Io4civ5MIt8e13fRpUAFazQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4771
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IFdpdGggRHluYW1pYyBQQU1ULCB0aGUga2VybmVsIG5vIGxvbmdlciBuZWVkcyB0byBh
bGxvY2F0ZSBQQU1UXzRLIG9uDQo+IGJvb3QsIGJ1dCBpbnN0ZWFkIG11c3QgYWxsb2NhdGUgYSBw
YWdlIGJpdG1hcC4gDQoNClBBTVRzIGFyZSBub3QgYWxsb2NhdGVkIG9uIGJvb3QsIGJ1dCB3aGVu
IG1vZHVsZSBnZXRzIGluaXRpYWxpemVkLg0KDQpTbyBwZXJoYXBzOg0KDQoib24gYm9vdCIgLT4g
IndoZW4gVERYIG1vZHVsZSBnZXRzIGluaXRpYWxpemVkIg0KDQo=

