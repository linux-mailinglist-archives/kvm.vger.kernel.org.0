Return-Path: <kvm+bounces-46405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE9D8AB6001
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 02:00:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E637F7A988D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:59:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 302F61F5E6;
	Wed, 14 May 2025 00:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LN7TBQoY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFEF023BE;
	Wed, 14 May 2025 00:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747180824; cv=fail; b=sd/CJ9u8Z80Q/Yqmr5U+qmi9zsQvfuXfgR5TExKHLhkrUROskYdQOsDdCBm32a6UrRnNU36kUswFjWNpRlheqRy+rIET+R7YcX930wcgFnxZebIeF0N0gA00FyfSLexcV80o0N9ZSkVnUsMrok8NNJKXq+UdQcLD5jV4lHpmNpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747180824; c=relaxed/simple;
	bh=Cy4NQXu8x5AcxUqv3ymcXC6Eq/I2gJPDUc5sKOdISzI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rPf8DqrBUa/BNHd9958Nn6BHBYzD00lr4yhXJxjffFYQKgXMPMErO4MJVGGLXVtUC09FcRqqk/8ozLvxipf3cUA2RvOhtK7CZRwdnyDshx4v5zjvr4kBu8L6TbUnj8R0WPxeWB2tGk0SLTQVEt9BohLn7G3679kJGBE/UEWKGLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LN7TBQoY; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747180823; x=1778716823;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cy4NQXu8x5AcxUqv3ymcXC6Eq/I2gJPDUc5sKOdISzI=;
  b=LN7TBQoYa1P2ffpzw3aOSx4KV5FD0WT8AkukKQ8XouysaTX59WCgrymL
   USmdNUAFdMYdly2Px2dpOdm9fU3pVWPbP2urowWWBCJM+pYSIhix2hD+V
   Uv3RJvQKZ9/uKePI/MWDEaBPw6nxskZBVbCLpUxHAh/LR7lU/8EZXzL4Q
   HLIJtlFEy5qmTt6nP7snYH2WPL7NMLabDWImk+eFq6bjt36fmmkJtkNZI
   e0IQMIaSVGeUfCl/F4PcGuDMeUXsd/cKv8MWvhjH6O6J6Bn17dRi7gEhj
   jLEenFARFSsUpKoqbWLV3ifYBCUJpUaDsFwYUST+VTEgpb/Akger4WD21
   A==;
X-CSE-ConnectionGUID: Vg28dL0/Sx+nfxXRqjtciQ==
X-CSE-MsgGUID: raXYTtmUTTeeKjR6CmMhKw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="36683120"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="36683120"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:00:22 -0700
X-CSE-ConnectionGUID: sZIByJfJT2qcpVU6ZjXECg==
X-CSE-MsgGUID: MuYAOTSdQQuuDVtCSePiRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="138361375"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 17:00:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 17:00:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 17:00:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 17:00:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vNDAinJkmbpjlTdrG00EjFj5oW86aYW0xDPNe4ajGw7aWOkUawV9kq9FYOkFwDpMqfOvcYb0UZClz16HuiQlL0FqP7ETGBQViDagIv7a7Iv3no7l7nggJF2rND6PFcVEqMGir1FrZZVKwu29ewHjL1u8Wuz3Fqfwb0Mas3PlAIXwBaebpiqkg7aPJYI1BGEwOvy42QfGetvoB3v0IqMoiG62djnxwYO0Z9D7GokipriwLkbGujbhuJBapV61eSKDP633h2AV6ylOYYNmYVjEv6yJNwvF/wxPBz2ci1JS5G22yFsB2GlWg3IX3zxVaQ4pibtKZKz4UTNFOrX3YzVdig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cy4NQXu8x5AcxUqv3ymcXC6Eq/I2gJPDUc5sKOdISzI=;
 b=QdShVmJ2M0NOLeEsD2b4hg/mBtdNI10cykeH9GAZYl6xRnwzkQDAyliNngNoUfDBsLjTjekUfmDCJ3vJyXtxnGSLtiSoTmEkTDuqo+yMUkZRCIw2lRms2ZIbtO2hyAqmhh0Kb9Ojr16pBY6EDMfjO+LmrT7MlsXrjzDsQEJ4rN1uH0RvQjASQgTJ/wm+8HyLRRWJ40D2Z2lxH3Hsb7EkcO12bDGZSwJHHDNNUcnksU702bE+RycUFTrmZIP+G9Kpk+fI7CAnBcnxUz/judjHyxhZ9UTAQ3TdLs4gtNW2QT8xygLy3kJlZXeEf3b/fVmqb/M7AaLfb2xicuVEbjCyuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15)
 by MW4PR11MB6888.namprd11.prod.outlook.com (2603:10b6:303:22d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 00:00:17 +0000
Received: from BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c]) by BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c%6]) with mapi id 15.20.8722.027; Wed, 14 May 2025
 00:00:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"x86@kernel.org" <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Re: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Thread-Topic: [RFC, PATCH 08/12] KVM: x86/tdp_mmu: Add phys_prepare() and
 phys_cleanup() to kvm_x86_ops
Thread-Index: AQHbu2NdArquWBZL3k6ZxRzni0e1trPFhLGAgAM9bgCAAMm8AIAFRXMAgAJ+QIA=
Date: Wed, 14 May 2025 00:00:17 +0000
Message-ID: <8668efe87d6e538b5a49a3c7508ade612a6d766b.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-9-kirill.shutemov@linux.intel.com>
	 <aBn4pfn4aMXcFHd7@yzhao56-desk.sh.intel.com>
	 <t2im27kgcfsl2qltxbf3cear35szyoafczgvmmwootxthnbcdp@dasmg4bdfd6i>
	 <aB1ZplDCPkDCkhQr@yzhao56-desk.sh.intel.com>
	 <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
In-Reply-To: <2bi4cz2ulrki62odprol253mhxkvjdu3xtq4p6dbndowsufnmu@7kzlzywmi22s>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3303:EE_|MW4PR11MB6888:EE_
x-ms-office365-filtering-correlation-id: 71982225-1834-4298-fc46-08dd927a4fad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?NHZtQ3BKeHpzV2d2Z2tjSUxRRFJJR3FrVDduSVNLUjNhY014K0VkUGFGUlQ2?=
 =?utf-8?B?T3NlZStqbEJHS3NLTFh0WWdxazdycXVPQmR0Z25xSHlhVjQ5dEx2RWpLWUtO?=
 =?utf-8?B?dzJ4RmU2TlhFSHFXaUdHVWdwdmlnNHZYWHNEVy9pdDhIbUZBWFBqeDBNUUdw?=
 =?utf-8?B?bFc1VWZBMUtkVE1iMGhtZWUwVExoMk56K1NEcUxuVkQyNEpZbkpuSTN5ckpM?=
 =?utf-8?B?d2VJeko4K2Y2OUZxZnhaU0pzUFdEOUFCcCs4SEVrRGRJYzQwWDR3Z01wU1V5?=
 =?utf-8?B?VndsYXJUMUwreXpGT0FFc2trNUNoTkVvbEVoL3RKTmRuUGQvTFBJZ0owcnlq?=
 =?utf-8?B?eGNjRmxaSzN4WnBBbWwvME00NFBuWFppSUdDZ2ViRldvZzhwVmhIRm9tUnBh?=
 =?utf-8?B?RmtsWUFnVy9obDVhOEhTemZGS0FLNEpGVEFXSFRNMlVZbWVEQWZUZHRtNnJm?=
 =?utf-8?B?QWdzeVpEK2pXaUNxQkVnL25DZFU0U0pBc2o1NlVCbzl6RkRzYWtVd2piSlN6?=
 =?utf-8?B?Zk1qUndhczIxTGx5K3o2ZStham5UOUdETUprRFFZZjRNOTdvNmFKQ1U0N2E2?=
 =?utf-8?B?bHZ6VndKbzM4blkzZ1VNazN1MlJDUjRhTXRRWFBta2R6eVZSYTF6NUsrbnRm?=
 =?utf-8?B?cWFrdDFmbnhUYzlVN21NMHlSWU4rVG9RSGRVU1FVeVlzUXcyTTNqUlp2MW1v?=
 =?utf-8?B?RkJBQmx6S1JDMkFVcDQzWkZZaXVoMVA4UlEyZ0oxUUg0dVhrM280M25taVpQ?=
 =?utf-8?B?cU9ScExEN3M0U2VlYVhGZ1VuZDhPdEVrSVJNUW14K05DMzVnN0RML05jUnRv?=
 =?utf-8?B?alkremxpUmdOWHdRT255MWhyWHYwYjdzNmdXMGVLVEVSQWtiMnJSK2xLTlE4?=
 =?utf-8?B?NGNpaUNWRStWVmYvVXpmTUtVRlFVT3lSNFZOMkl4Q2NUSkJLKzd3ZU43c3A5?=
 =?utf-8?B?U3BaRlFzSlBIZWx1cm4rdTV1YTVYYjJSajhaZmw3R2J1RS9HYStBL2xsRkpO?=
 =?utf-8?B?WDNFTnlTSkJXeGlLNHdTL0FGM3E2bGJBS1prMnNpS1lybU8zcVYzS3hiV3do?=
 =?utf-8?B?ZHJaR2VGZGpTbXNiUnNQeGM3N3c3SXF1L0lqeUVNbWRYZGNsUlNFcGYwY2px?=
 =?utf-8?B?SzNGbDcxbS9sa1Y0MDBhMGdzTUgvaS9sUmFWeXlsTFNHZDh2NlN3b21YWkZT?=
 =?utf-8?B?MThDUXhEM2xLNk84aWZjL0YyR2dTYTh6bndXNFB0MXlUSGlvTUxYbFI0OUF6?=
 =?utf-8?B?U2pmdXAvWkdWbVBaTUlTc0JVaHVLMU9YRVZtSWhPaS81UEdESmlvaE9lT0t4?=
 =?utf-8?B?enpqQU9JUWgrRFQ1VnNIZi9WU3cvd3FvQ1gzQlBPRjdrSEJTaTdIeDcxQU9U?=
 =?utf-8?B?TWthVlMvRjFNN1c0YTNjMTBlVEh2MEJhbkxscjJjNkFVZ3dzd00wNnhNRzY2?=
 =?utf-8?B?Q0lweHAySm9ndTlkTldVN21uNHQ5bDRGQjY1emNvOEVRT0U3QVVVQmQzTjZ4?=
 =?utf-8?B?Sm9HNkZFRG1DdkZPN1k0a1VLc3ZPT25rWXRhSzdmQjJsRkdwS1UxdHVRdTA1?=
 =?utf-8?B?bGQ5SWxKOFk3U2RUK09LTzU3MU1SNUxJbC9qSnZ6cHV1bzFyYzVocTR5VXN4?=
 =?utf-8?B?d2JHdjVBTHZtckFtUERTSEpSaWJ5N0FMUitvUWs3RlhMWmxpZzVsNG9zVGdz?=
 =?utf-8?B?YWo0NExidXUzUUVSbHNETXJiRm0vZExhV2E0RG12T3VacFRyZ2Jrc3JjZ2Jt?=
 =?utf-8?B?QSsySTloQXhtNzdDelhKdW12elFNQnZXY2ZXM1ltdnRTR09vaFIwM2FEc3VY?=
 =?utf-8?B?RzFJRUJpWWw2bUkxamNuTGNCM2pZSWkyTnZsVTJma1IvRHRWcXRrb0p1SFFa?=
 =?utf-8?B?czAveEJaOEw2ZHpjTTJRRjkya0JBNGM0Zjl6eW5hd0ovb1EyVjVmU2d5bzFC?=
 =?utf-8?B?clNQeEkvam4reVFISkhCdDJGNTl4bnp1ZzJyZzBReTgvbkVmbUxXZXgrSExR?=
 =?utf-8?Q?Zo7rhODqSyol1lmub0BB/XXxeiIslI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3303.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU55Yy9LeDVmMTJMWnNma2crbmk4TENjanhrVFNrOWZwZm5aMXFiS2JmVTZz?=
 =?utf-8?B?UHJNRHFJWUVqL3hxc283TEc3Y3JySlpHZ0FYczljVFlwL2dxRUxNc09XWldO?=
 =?utf-8?B?Z3Y3dCtOOEpwSjdOeVk4MTNFNlpDYUdTbU5CS2d2MEtkMGNpUkRuc0RvNHBD?=
 =?utf-8?B?Y3JQeEJPcExhZEZQTlVOcytNVlhVU2JnMUxpaXJQRFNlYVN0YmF0Z2hTZHdF?=
 =?utf-8?B?cmNvRHZVbDFBcFpleXp3MkhqQUpLS1hNRXUrUHR5MFRzcEo1SVdTaW94YW9Q?=
 =?utf-8?B?bnlsU201UmFrVVlRM1poTHl4cktZZFJkd2xhOXJ6VW40L2l3ck5qNW1uK1ZP?=
 =?utf-8?B?ZGx3eHFTcUdJK0k1a2VpdjdYVlpFTS9UQXNlTThtejVtZFpma3c1RXZtZTd6?=
 =?utf-8?B?VVRWa2RDTGJhL0ZFRmJnSnhFMEJORk9hVXRDNHN6Snk1TEhnR1ZTb2o0U0Fo?=
 =?utf-8?B?VVFHNkpVbUVRY1pUeDJKRWdoR2VPalRCeG56aHRoaWJhd20zY1dldThPbnVk?=
 =?utf-8?B?WFZjN2xPWStEMWRhbGFScG9GMW1ScjJUOWV6VE9RZFhNYnZCOTF0TXZZUEZI?=
 =?utf-8?B?YitvcWl0aUhQcHhrc1NpemFmaTRHRXRFUDlHNDFIR2Z3ZkliaXdEY2JoQlJW?=
 =?utf-8?B?bkw1YVhIdExYNXp0YlV5cVNFZVBBOElKNEdQWWFOVncwOUdhS1c2ZVRmVVJI?=
 =?utf-8?B?VkdYMU5zWGd6QkE5NWh1TGFkZmFEU25zdjAxOFdtWGNCVkYyNjc3RGNONXhQ?=
 =?utf-8?B?cjF3OXpabHMzc2FRZWdyZVVVK0hxQmx5elFYaW1IUlNZZjJaREFLR3RyQWt0?=
 =?utf-8?B?eDJyaXk0OHF0YXN3bHNBOWRxN3oxK05wQzRkOGZmeEdMSThGbDJVaWVETXZ1?=
 =?utf-8?B?QlJlRm40WTdPQ3ZLTUROa2lLS3BrYmNIc3R1UDVQSUdxbCtTSG5pT2dOcTZo?=
 =?utf-8?B?aGhDYlFVaEQwOU85aVZ1bWpTTmtBMjJrNXdhUXRDN2ZwZC9lbko1d0ZuZ3Av?=
 =?utf-8?B?ODkvUUdpUXplWG8raHFIUmdNZ3l3em1TRXVkZ1lDQTliaXBMZW9SZXBXYldT?=
 =?utf-8?B?RVhPOFptZ05JcjJoYURXUkhYbXhoejNRSG5KVXViMXl3endoRWlzb0RHbHpk?=
 =?utf-8?B?dGE2akE3VWhkZmxpNjFmbUs3cldselhQNE44elZqVS9DN3U0OTRYVk1Ka21l?=
 =?utf-8?B?dWZGRDNSSGp6Z29CL0t0Z2ZJMnJSOU03RUVFeityb29iUkRvcGg1NlpiYjc1?=
 =?utf-8?B?VEFLVjNTRy8yUUp6eGtsU1BUOHkwQXVZcENFYVd6ajRpc1ZWOFJLSDBWU3FF?=
 =?utf-8?B?RmphOC9hTWFYRytjZ3lBc251dzk1K1k4ZjZFWFNObkFLemRzaFEzR0VGMlox?=
 =?utf-8?B?RWJqMWNBN3dBNk5iRVU0eld3RU9JNFZnZ1J3V2RFUjBUNEZvOVFnRVVwa1ZF?=
 =?utf-8?B?azc1SzZUMXIzTzlUYU1WVWF2aGY5ekEzSURhTTdLcEEydEgraUo5REdpRVpX?=
 =?utf-8?B?V3JDaTJRam5VbksrNklUTDdVVW94aTg0MC9BdmZpbE85empDc3F5MWhhQ200?=
 =?utf-8?B?bGdQTnFMUzVETmc3T2lvTFlSOWZvU2pCNTVmS2xzOHZrVmt6a3d5VFBPQlNJ?=
 =?utf-8?B?QUxpNGxJUEFEY2Z2aGcyWFAveDNzUlg2KzB1c1J3d1E4K1g2ZFBhUWM3aTYr?=
 =?utf-8?B?ZDlVd3gzMlEwUnpkRmZPRE9QVkErb1h4TDA2UTVZTkZodHpVanVxRU94eFZF?=
 =?utf-8?B?clY3RVFBM0lpRmV5THZTaFFETTFlTVhtSjgxNzB3QXJvZUtIOWVndWhQZWh3?=
 =?utf-8?B?VmxWN0ZoQ3cwNjI3L3JhUzlwckZZMmZHRWYzdGRsZU8rLzRTRml0cUEyVEpx?=
 =?utf-8?B?QjlwSVlKVXowcmxzRkF0VGhaR2lhVFBBaDBSbndqOS8xbmk5YWpxNGJZaVF4?=
 =?utf-8?B?QlJ0aVg3OWlJd1ltSFVNTzVvbUJEQk5icXZKU01TV0FlejlkbUpLNXBPYlF5?=
 =?utf-8?B?WjlJQzBwTjBrNjJocXozOHM1ek04VjYrbWZDVG5QYU9YbThMbTkxMWNTeXNt?=
 =?utf-8?B?Y0pmZ3lNdGthZThxaitqNTZvVkhBWkpCWFBaNWlDamRHSmVVbkdBUUN3aWVa?=
 =?utf-8?Q?BPKh6ft7gAz15o1ojopUalZ0f?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C146A5F958E0B499DE6212E80F7FC32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3303.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71982225-1834-4298-fc46-08dd927a4fad
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2025 00:00:17.6906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2Ll22e2Gphoo80t7qyXzRxoh6Ru9zNLCY56IROkr85VsdbrzTeApSrV3Tj3re8iuEEWWH7xPUeWLH5kYMsRAJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6888
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTEyIGF0IDEyOjU1ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIEZyaSwgTWF5IDA5LCAyMDI1IGF0IDA5OjI1OjU4QU0gKzA4MDAsIFlhbiBaaGFv
IHdyb3RlOg0KPiA+IE9uIFRodSwgTWF5IDA4LCAyMDI1IGF0IDA0OjIzOjU2UE0gKzAzMDAsIEtp
cmlsbCBBLiBTaHV0ZW1vdiB3cm90ZToNCj4gPiA+IE9uIFR1ZSwgTWF5IDA2LCAyMDI1IGF0IDA3
OjU1OjE3UE0gKzA4MDAsIFlhbiBaaGFvIHdyb3RlOg0KPiA+ID4gPiBPbiBGcmksIE1heSAwMiwg
MjAyNSBhdCAwNDowODoyNFBNICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3JvdGU6DQo+ID4g
PiA+ID4gVGhlIGZ1bmN0aW9ucyBrdm1feDg2X29wczo6bGlua19leHRlcm5hbF9zcHQoKSBhbmQN
Cj4gPiA+ID4gPiBrdm1feDg2X29wczo6c2V0X2V4dGVybmFsX3NwdGUoKSBhcmUgdXNlZCB0byBh
c3NpZ24gbmV3IG1lbW9yeSB0byBhIFZNLg0KPiA+ID4gPiA+IFdoZW4gdXNpbmcgVERYIHdpdGgg
RHluYW1pYyBQQU1UIGVuYWJsZWQsIHRoZSBhc3NpZ25lZCBtZW1vcnkgbXVzdCBiZQ0KPiA+ID4g
PiA+IGNvdmVyZWQgYnkgUEFNVC4NCj4gPiA+ID4gPiANCj4gPiA+ID4gPiBUaGUgbmV3IGZ1bmN0
aW9uIGt2bV94ODZfb3BzOjpwaHlzX3ByZXBhcmUoKSBpcyBjYWxsZWQgYmVmb3JlDQo+ID4gPiA+
ID4gbGlua19leHRlcm5hbF9zcHQoKSBhbmQgc2V0X2V4dGVybmFsX3NwdGUoKSB0byBlbnN1cmUg
dGhhdCB0aGUgbWVtb3J5IGlzDQo+ID4gPiA+ID4gcmVhZHkgdG8gYmUgYXNzaWduZWQgdG8gdGhl
IHZpcnR1YWwgbWFjaGluZS4gSW4gdGhlIGNhc2Ugb2YgVERYLCBpdA0KPiA+ID4gPiA+IG1ha2Vz
IHN1cmUgdGhhdCB0aGUgbWVtb3J5IGlzIGNvdmVyZWQgYnkgUEFNVC4NCj4gPiA+ID4gPiANCj4g
PiA+ID4gPiBrdm1feDg2X29wczo6cGh5c19wcmVwYXJlKCkgaXMgY2FsbGVkIGluIGEgY29udGV4
dCB3aGVyZSBzdHJ1Y3Qga3ZtX3ZjcHUNCj4gPiA+ID4gPiBpcyBhdmFpbGFibGUsIGFsbG93aW5n
IHRoZSBpbXBsZW1lbnRhdGlvbiB0byBhbGxvY2F0ZSBtZW1vcnkgZnJvbSBhDQo+ID4gPiA+ID4g
cGVyLVZDUFUgcG9vbC4NCj4gPiA+ID4gPiANCj4gPiA+ID4gV2h5IG5vdCBpbnZva2UgcGh5c19w
cmVwYXJlKCkgYW5kIHBoeXNfY2xlYW51cCgpIGluIHNldF9leHRlcm5hbF9zcHRlX3ByZXNlbnQo
KT8NCj4gPiA+ID4gT3IgaW4gdGR4X3NlcHRfc2V0X3ByaXZhdGVfc3B0ZSgpL3RkeF9zZXB0X2xp
bmtfcHJpdmF0ZV9zcHQoKT8NCj4gPiA+IA0KPiA+ID4gQmVjYXVzZSB0aGUgbWVtb3J5IHBvb2wg
d2UgYWxsb2NhdGVkIGZyb20gaXMgcGVyLXZjcHUgYW5kIHdlIGxvc3QgYWNjZXNzDQo+ID4gPiB0
byB2Y3B1IGJ5IHRoZW4uIEFuZCBub3QgYWxsIGNhbGxlcnMgcHJvdmlkZSB2Y3B1Lg0KPiA+IE1h
eWJlIHdlIGNhbiBnZXQgdmNwdSB2aWEga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKSwgYXMgaW4gWzFd
Lg0KPiA+IFRoZW4gZm9yIGNhbGxlcnMgbm90IHByb3ZpZGluZyB2Y3B1ICh3aGVyZSB2Y3B1IGlz
IE5VTEwpLCB3ZSBjYW4gdXNlIHBlci1LVk0NCj4gPiBjYWNoZT8gDQo+IA0KPiBIbS4gSSB3YXMg
bm90IGF3YXJlIG9mIGt2bV9nZXRfcnVubmluZ192Y3B1KCkuIFdpbGwgcGxheSB3aXRoIGl0LCB0
aGFua3MuDQoNCkkgYW0gbm90IHN1cmUgd2h5IHBlci12Y3B1IGNhY2hlIG1hdHRlcnMuDQoNCkZv
ciBub24tbGVhZiBTRVBUIHBhZ2VzLCBBRkFJQ1QgdGhlICJ2Y3B1LT5hcmNoLm1tdV9leHRlcm5h
bF9zcHRfY2FjaGUiIGlzIGp1c3QNCmFuIGVtcHR5IGNhY2hlLCBhbmQgZXZlbnR1YWxseSBfX2dl
dF9mcmVlX3BhZ2UoKSBpcyB1c2VkIHRvIGFsbG9jYXRlIGluOg0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICANCiAgc3AtPmV4dGVybmFsX3NwdCA9wqANCglrdm1fbW11X21lbW9y
eV9jYWNoZV9hbGxvYygmdmNwdS0+YXJjaC5tbXVfZXh0ZXJuYWxfc3B0X2NhY2hlKTsNCg0KU28g
d2h5IG5vdCB3ZSBhY3R1YWxseSBjcmVhdGUgYSBrbWVtX2NhY2hlIGZvciBpdCB3aXRoIGFuIGFj
dHVhbCAnY3RvcicsIGFuZCB3ZQ0KY2FuIGNhbGwgdGR4X2FsbG9jX3BhZ2UoKSBpbiB0aGF0LiAg
VGhpcyBtYWtlcyBzdXJlIHdoZW4gdGhlICJleHRlcm5hbF9zcHQiIGlzDQphbGxvY2F0ZWQsIHRo
ZSB1bmRlcm5lYXRoIFBBTVQgZW50cnkgaXMgdGhlcmUuDQoNCkZvciB0aGUgbGFzdCBsZXZlbCBn
dWVzdCBtZW1vcnkgcGFnZSwgc2ltaWxhciB0byBTRVYsIHdlIGNhbiBob29rIHRoZQ0Ka3ZtX2Fy
Y2hfZ21lbV9wcmVwYXJlKCkgdG8gY2FsbCB0ZHhfYWxsb2NfcGFnZSgpIHRvIG1ha2UgUEFNVCBl
bnRyeSByZWFkeS4NCg0K

