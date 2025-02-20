Return-Path: <kvm+bounces-38806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 785DCA3E87C
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2025 00:29:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 530DC702729
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 23:28:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61B562676F1;
	Thu, 20 Feb 2025 23:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JzWM0YQw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31001D5CDD;
	Thu, 20 Feb 2025 23:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740094088; cv=fail; b=s/is5z8YmU4Ae9AeisJYJmh2Xtma9cqVlDh/4DQmej50KAF09zHleyeSvQCN1Hk0y39xXJu7zMCPCN8VD86JpZN1UzOmOCsWYANS2vMrIYzrL3yzeAMNNmazFKT30ez9hhda2cHPDZBxLS7W7Uz1D8/d/fK1MPrh4ocU2ixevig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740094088; c=relaxed/simple;
	bh=V3JX90f1rkkUdpuViacNFfKtsz66s5z1aKwuo1L/LSE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mOsFPrjslD7wYDctmid1e3fSODmahCiDDg3zLxeQYBWdRNSUiqO8oY44WcGQxr0S2bF0zHvK0ilt1vvqPbP2dhwkWKq74jYVC84dWAIH5J0r6eB9O56YFrrsvoeemKRQjdCWgoDvyHzZULQIaPsZ1FwSQe7dB0ONuuOITjjPoYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JzWM0YQw; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740094087; x=1771630087;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:mime-version;
  bh=V3JX90f1rkkUdpuViacNFfKtsz66s5z1aKwuo1L/LSE=;
  b=JzWM0YQwXCJJwtZ85qsm3MWjBlCJRh4sxFHCr2AW7jhEbChE7hV5vUyi
   aURAOdLyX2FvLNyh60aeXyG+mzFLHTmOzTeil/ZtRadrmtBaNYIA9OWp8
   BRKuyKSpFdhlQ5asX1Uhg5UyjQWBFH55tyheUxK70/yyAjT0Qia6NmQdl
   oYyRPq/ps4ZBaAoAdk8TpbNLuGdTwKqylmliZkmnOOM+Kugk9fsM9nfMJ
   9VZOjSpghQcfif/daeast+gWFidFxShSaGVd93rnllosdIQZ0wcrbT/19
   2L0autBnas66jLm1JU81b3v3sxOiNdZcYwH4mKW6J4QfwNKEk8XDKHMtA
   g==;
X-CSE-ConnectionGUID: gkB0Zh72SvuwvgEZA43qMw==
X-CSE-MsgGUID: DeHy7cdaR0Sh/sB85F+VwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11351"; a="51114877"
X-IronPort-AV: E=Sophos;i="6.13,303,1732608000"; 
   d="diff'?scan'208";a="51114877"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2025 15:28:06 -0800
X-CSE-ConnectionGUID: 5Q1bs/IHTOyiPxru2NGoPQ==
X-CSE-MsgGUID: 6XOvc4UdRzeOsddcHJ7Tng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="diff'?scan'208";a="115048624"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Feb 2025 15:28:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 20 Feb 2025 15:28:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 20 Feb 2025 15:28:05 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 20 Feb 2025 15:28:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V/O847NyynGZp0fy1sRhNSPVA1S+znOLBG2Sj5BH1Qlf3y8je1jA7ZmNC6tXC27klw6AA7F1ILr7D++BHHmXDBYZYF/DWizWyLvnYiEGCx+yFDPixHIu1NRq1OfrefPKsW5ejOGmAGIA6Wi05aruePe/OsLJcWuxCNZ23TIL0TcJQ7abDRDdP2zZ2AH2/nohr2UjTNzqlsFNIkTQtb+mqq3UlLHlRNuqnR5JKMPGM0Qa410OFQ87ygU2a+rDEHy6NvZ3AEh0kwBA5hEIs7kTB4TVaPQbSf46EoR/Nvxjj0mdkx9/1ohfcw/Q4fr0b9Dw8litiC7sPoRIZtXu0Ep0VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PgTORc2kP4LaRD/cBTZUSCal7xeAR3bi0bn/T/XskRs=;
 b=WPFac9ZAUu5kIEkryOzYpx3FC0ZbI/+jjV32NnyIvcBc9TGPcaWvls7YrVpvJ2EKoT7mtUTSh9X3GghmVU6NEGCbCpzNXvxwDI3OKEY/yW3nRuX4CI19LnCkBQfSMbELx/3zdWrvr2VgKe5UZtB6VPriD/6CPYdFAUKGg3LfuEEAPLOlOTTPHkAAZwhvA6PNfJIT70gpFoFuAZJ7C6PobEuxhyHFxhHHVDncGQeYaVjKERE6A3mXwDN50gR6KX05TZ3OGyFmEE5h/u+ojyzs49r0tRJtzGUjMWQUm3aoJWTW+n8HyGvLsMBxlJxfYYlJNxBbaB8fe086D2enyGWLMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH7PR11MB8034.namprd11.prod.outlook.com (2603:10b6:510:247::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Thu, 20 Feb
 2025 23:27:48 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 23:27:48 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 12/30] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 12/30] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbg7nYI8GDjT3QHU6dqFONXgQRo7NQ1qIA
Date: Thu, 20 Feb 2025 23:27:48 +0000
Message-ID: <64168d1d11afb399685067c6f8d57a738bb97eb6.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-13-pbonzini@redhat.com>
In-Reply-To: <20250220170604.2279312-13-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH7PR11MB8034:EE_
x-ms-office365-filtering-correlation-id: 2982db7d-e507-482e-d27d-08dd52063027
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|4053099003|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0FkdVpsbHA4WWx3N1M1TElBYUVlMkFBaExIcithd1h0U0dlcGNhelh5YjZp?=
 =?utf-8?B?d1VyNlN2K1ZzMDVoRy9kcXhXMEdyMFlwanV2b3pHQ3RCV1o3N1NmRXJZdmVm?=
 =?utf-8?B?Y3l4Mi9ZdGdUSWJrZThRdDdpbXNYZWVyTXZ5V2tNZDVRbjhGcVpMcHh1UjFP?=
 =?utf-8?B?MFZqblpCTVFnUWFjWWxWMkVMc0FkYUZwZVVtcmZpUm5wdHZndjgrUGQ4NUZI?=
 =?utf-8?B?T0xCcGUraWlQSTAyTmFZbjZWbmFiTk5tNjRyTkJZa1hJYXBFK1h3RHJZQWdn?=
 =?utf-8?B?WjBWWFhHN2ZyMXVobndyNGs4Q3FLZWZjNkJNMVFRY0l1b1MrMmhzdXpURlp1?=
 =?utf-8?B?dkdyMzdLQUpORXhMRWJzZk9sb3VRVGhhT0pMRjlzWllMVmFNTytxVnFHMUVU?=
 =?utf-8?B?bng1TUwzd0VoV1M5RW1taXVRSWpPU0dCN2JXeng2QmxNSjZ0N1RiVGNBVWF6?=
 =?utf-8?B?OGtRaFoxcEQ2eDdvU1ZqZlZXRWZzY3RoOURJTE5neGJnckpYalFOYjNrVTJK?=
 =?utf-8?B?UWlub1NyT0Zjc2U0S2Q1bmJoU082U3doWkRyQnpWS3dNRkNnN3pWN0ZKekph?=
 =?utf-8?B?NFFaaVBoNnZhbURHWGxRclV1UGZVLzRZQWVNeXhiOG85cyttaVJ5MWZ3WTJF?=
 =?utf-8?B?cVBKQlBjUzN4Z0xTdExkeVMyVzh0ZGNEVFYxWWNZV0F4cFdMTnZPKzYzMGxX?=
 =?utf-8?B?UHMzbmhzMGZxdyt0VnN5d0ExZGw0bVFrOEt1VW4vcGZabkNRMUIvUWNCMmI2?=
 =?utf-8?B?KzRnb0ovbUh3RE1zRWVsVC9LRjdLZVhkS29rRGNtOEtoeU0vR1hwTFAxTHVK?=
 =?utf-8?B?MlVLdGxDRmNud2FiOXZpWmhMT09JSks2ZEtjd1VvdVdlcWhMRUJWV0Y5WWRM?=
 =?utf-8?B?MlcvZVV1bEdrUE51NEovZndubVd1SmtPLzMxaDQ0d0xFLzRvRHUwMGF6VTZy?=
 =?utf-8?B?VzdraUhISEhId2RwYXcxM0dEVWJDcmdCaVlIRm5HS3hVVTB6cjRUcXkzZjRN?=
 =?utf-8?B?V09zNHFYYzNZNHJZR2lGaVlnRm83ZmN0U3krVUJLU25tRjR3TGJhSVU3Nkoz?=
 =?utf-8?B?YzY1NWY2SFJRdFYweVg5MTBXK2d6U1ZsZlhmKzFCOXc0MlRSZDdRbkFNWEpS?=
 =?utf-8?B?U1pBeVpFSXZxUU9BbENnMnVaOUZTQ2lmb29CdENlaldMazJMT0N4bkxDU21L?=
 =?utf-8?B?OGwzZ2MxUjJKRG93REI1a0J2bC90RitnMFFDcnpTK2NCTGdzNUVxai9lOVFl?=
 =?utf-8?B?d1RWQUIxQS9VVm9qenFucjQ2MDdxWnREdTQ0TEhZeExueW9FdjBuQXBJczFI?=
 =?utf-8?B?eWI5UEZBL3g5UTlEellHdFdzYXI3eXQrQjNKK1crT3hYWDdUVHlUOFE5MWxn?=
 =?utf-8?B?SjVwbkxNUkRaNzYwRjNBZWVORXllR1JTckVJSFFqc05tZUhReTJvNU8yY25m?=
 =?utf-8?B?d2s3TUpUYXRCL1hrY3dTOXVRSnd3dXkrN2UySGYxU1dzdENWMkdEUkgvUzhl?=
 =?utf-8?B?dUZyVk9NZVhkU3VXd2FrbEtsaEJGUHMrY0FyeUIzTVAvRU9Pb1dwQklFaWVl?=
 =?utf-8?B?WXJKa2RjUnNldEdoV1M3UDlqUzlWdWJ2WHBwaHhwaTgyOSt3cTgwRUcvN09h?=
 =?utf-8?B?OS9CbjdkL2loSCtiUzZGKzJYSHJpbjI4c05YakpKWktQRnZrV2krbHpiWXZh?=
 =?utf-8?B?N1ZsVmkySjZ3ZDRvL0pRbEFMa3NmdVN0eHdBWDhzYW9jV3FVdHErVkc5dkJ6?=
 =?utf-8?B?WGY4Q2tXaUdkY3JGZTQyZDlKR2htNjEyLzlJa2dIVlk5SWhBTkNrSzFEU0ZT?=
 =?utf-8?B?aFRtcE1SMGJhZXRYQlhPdkJqejRQa2lreWorZ3VvVTZ1bzR1RklGa0t0M1I3?=
 =?utf-8?B?NnVOdElqOHN0SGhCczJqQ3R5K1F2Y1NNL290UUc4bWppVUE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(4053099003)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXBSTGJBR0w2d3krRnVDSTJHbklWTHdZNHBwUFZpWUJSdHpBTUNqQ2dYMXNE?=
 =?utf-8?B?TjBwYklLK1RFNndaaVRlQjdMS0NNZ1BYMlhaMFFibTlNRzg4Vkt2SWd3V09R?=
 =?utf-8?B?dVN4YmttKzFrUEt2cG50ZlNnaWxrRmNQdWljQzM2K0MvUVBrbmQrUlQvcU02?=
 =?utf-8?B?RGozNUFrWFRmRTlkZmxNWUtZOVJ2bTJ0Wk82bFBJY21NYVRXbWF1RU1qQml2?=
 =?utf-8?B?d1dsVUtSa3B0eHRNTVVrNk8rT0NORDRSU3ZkVUU4Tk9IOGlDMFNMSTM0Si9k?=
 =?utf-8?B?OGtzdjNlbHRYOVFUanBOZ1NtbDNDd09FZ2F1dHJTNEdYTzdBemszTWNpYmg4?=
 =?utf-8?B?SDlsVGhOWkdOREVRQjlvekIrYnV5dkZNYWlJSjIwb1h0STJNU2tSREI2bDJv?=
 =?utf-8?B?YmV2ZDFVTVJFWnBRSkE0TTJWMVdkUVhvVE10SCtWVzZrV3pNVUUvL3pjRkxS?=
 =?utf-8?B?bmkrOERPTk5lTnZiOVdjOVgxMlNjOUpNaUdkZ1RvZ3ZTLy9Ham1TbjlyK2Vz?=
 =?utf-8?B?TFZGemtpbTl3TE05bHcwM0N1bkJybm5XY0FqSDdXcW5Jb29DNmVmZGlVek1T?=
 =?utf-8?B?VERJZkJjbjRiZGtLSzJNTFYvZFRMUWJGNzBzek5XaS93ek1YUHg1WlIrWDJa?=
 =?utf-8?B?aUlDWkVjeThxMU5BdHI1TVpReFErMjRMa3VuQjRsTFhxS1NGRGRzc2pTcW9R?=
 =?utf-8?B?aThuTzZLZWpQY2sveVZRQjNWeVVWUDJ3UVRrbzZFSU40c2dJbWdtUEhRT1U0?=
 =?utf-8?B?b0NjNGp4N1JabytXVkFicUNUYi93MGJ2VFUwMStiMFNwV0NsSGgvR256TERr?=
 =?utf-8?B?RXNhYWdzck84OU12aGJvdHI5ck0vTHUzeldZL05rQnFWS1IrcVA4azFSWHRp?=
 =?utf-8?B?azBERGdHQ1FoNFYzVnRGTitCM3ZhTFlwQnRUZnV4Q2JqRmdTSVRzbjVmOWZN?=
 =?utf-8?B?bUFHMkRERzMxRHBQaFIwYnVkYmpMUVhGMlg5V21MWERvUHVjS2FTMUMwWEtj?=
 =?utf-8?B?eEl3Uml6TXhkQVFwUk9uN2VBOERlcFREMTI1cFA3SElWVzJOQ08zWTdtYlUy?=
 =?utf-8?B?SnJqZkJ3MkoyRnhsb1hFVWYwcW9EWG9NNDFTazNQT2hrQ1VOckhpVEtmZ1Nj?=
 =?utf-8?B?NG1qQVVLWnA5MkNZcG43OGJDRG91NDUvRXJBOXhRWG5kVjhadlpyMyt4NUl5?=
 =?utf-8?B?RG5IbDRCYkZaV1NtSE9OVUVBZlFuUzhEbE51UDNINSs1MURzckRJSFdhT3lM?=
 =?utf-8?B?UVROYTA3Z25pQmgzYU9mdWtOdmVCQUUvejVtV2p4aVFacVFabTlIM1J2WGIz?=
 =?utf-8?B?eldFeldmVS9URnVwbnM1YytoQmE5cE1QYWVSd0VqRjFKZ3lDbHEydmFiY09p?=
 =?utf-8?B?V3p4TTVQWFJrRkNkeHFyblEzY1RqWHVIcVR1MzNSeFpVUHZMNGxRdEZ3eEs5?=
 =?utf-8?B?L1Q1QXdndjBPSXJ5MUk3WE8rS0dXUjNkRnp0YWRnZzVkaHgyNlBZQy9hcFBm?=
 =?utf-8?B?N1dkcExRZlgyYW1iVWdqemdWM2VQS3diQWpZSkVydTJYdjVpQjNUdGo5U2dL?=
 =?utf-8?B?T0trdHlrRkxUeUZkSkk3a3RLT2REbmk5cFNQQ1ZRK1ZrQk1oQU5laG5YMW8w?=
 =?utf-8?B?V1A1ZE40VUxCZGRETjQ5MUc2M3RVbHJCcysrcjY3OWtGZjRFTThheUpFc3Z5?=
 =?utf-8?B?U3ZueWYvb3pKTDdMTWVhVnVEUi9zcHJvVFFJYi9MdDd1WEtqOUR5R0tWbmN1?=
 =?utf-8?B?TnJlTU5pQUFCMi9PSzFSSGpsTjB2MDBicEMyS1crc3dpNWdocy9WMVpOL2Fj?=
 =?utf-8?B?aHB5TUZuTnFiWEhzR3oybkd3dWwrQ2FWcWhHVjI2SGk1WFVFMmE5andpdXRr?=
 =?utf-8?B?ei9DTWdXSGZoNitsN2tDRXZMNytDTFBpa1ZVM2RQcWVVZHp0cEozaVVXU1FB?=
 =?utf-8?B?ZUxVTUxwSmxGWEFpY21iTkdoYmhkQllwbER3Tkd3TW5jamJoRTVmcXZwY3dW?=
 =?utf-8?B?WmRsaHVWWHpuaFBwcXc2K055aE5DZnFGc3ArWHdSZjBUbll3cGhBZDBSOFRO?=
 =?utf-8?B?S0ZnR29odmNFMXJscis0NS92V2hTOEwrc0pQVWxSUWVKOEdEcjdncDJMVHdE?=
 =?utf-8?Q?pdm5xbiHOC2aj4IaXyyNwHOJ8?=
Content-Type: multipart/mixed;
	boundary="_002_64168d1d11afb399685067c6f8d57a738bb97eb6camelintelcom_"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2982db7d-e507-482e-d27d-08dd52063027
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2025 23:27:48.7345
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpigyqj+ffkVJ9JxnG2qm5SZj7/ez+JFzNBz7Xqzz4tR0mgqsBwy5icU+jevcC8cXvBn5wUpSOgp23UG+Xgz3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8034
X-OriginatorOrg: intel.com

--_002_64168d1d11afb399685067c6f8d57a738bb97eb6camelintelcom_
Content-Type: text/plain; charset="utf-8"
Content-ID: <31D79E4CE27DF943BFF0715214A6EC8B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

DQo+ICsNCj4gK3N0YXRpYyB2b2lkIF9fZG9fdGR4X2NsZWFudXAodm9pZCkNCj4gK3sNCj4gKwkv
Kg0KPiArCSAqIE9uY2UgVERYIG1vZHVsZSBpcyBpbml0aWFsaXplZCwgaXQgY2Fubm90IGJlIGRp
c2FibGVkIGFuZA0KPiArCSAqIHJlLWluaXRpYWxpemVkIGFnYWluIHcvbyBydW50aW1lIHVwZGF0
ZSAod2hpY2ggaXNuJ3QNCj4gKwkgKiBzdXBwb3J0ZWQgYnkga2VybmVsKS4gIE9ubHkgbmVlZCB0
byByZW1vdmUgdGhlIGNwdWhwIGhlcmUuDQo+ICsJICogVGhlIFREWCBob3N0IGNvcmUgY29kZSB0
cmFja3MgVERYIHN0YXR1cyBhbmQgY2FuIGhhbmRsZQ0KPiArCSAqICdtdWx0aXBsZSBlbmFibGlu
Zycgc2NlbmFyaW8uDQo+ICsJICovDQo+ICsJV0FSTl9PTl9PTkNFKCF0ZHhfY3B1aHBfc3RhdGUp
Ow0KPiArCWNwdWhwX3JlbW92ZV9zdGF0ZV9ub2NhbGxzKHRkeF9jcHVocF9zdGF0ZSk7DQo+ICsJ
dGR4X2NwdWhwX3N0YXRlID0gMDsNCj4gK30NCj4gKw0KPiArc3RhdGljIGludCBfX2luaXQgX19k
b190ZHhfYnJpbmd1cCh2b2lkKQ0KPiArew0KPiArCWludCByOw0KPiArDQo+ICsJLyoNCj4gKwkg
KiBURFgtc3BlY2lmaWMgY3B1aHAgY2FsbGJhY2sgdG8gY2FsbCB0ZHhfY3B1X2VuYWJsZSgpIG9u
IGFsbA0KPiArCSAqIG9ubGluZSBDUFVzIGJlZm9yZSBjYWxsaW5nIHRkeF9lbmFibGUoKSwgYW5k
IG9uIGFueSBuZXcNCj4gKwkgKiBnb2luZy1vbmxpbmUgQ1BVIHRvIG1ha2Ugc3VyZSBpdCBpcyBy
ZWFkeSBmb3IgVERYIGd1ZXN0Lg0KPiArCSAqLw0KPiArCXIgPSBjcHVocF9zZXR1cF9zdGF0ZV9j
cHVzbG9ja2VkKENQVUhQX0FQX09OTElORV9EWU4sDQo+ICsJCQkJCSAia3ZtL2NwdS90ZHg6b25s
aW5lIiwNCj4gKwkJCQkJIHRkeF9vbmxpbmVfY3B1LCBOVUxMKTsNCj4gKwlpZiAociA8IDApDQo+
ICsJCXJldHVybiByOw0KPiArDQo+ICsJdGR4X2NwdWhwX3N0YXRlID0gcjsNCj4gKw0KPiArCXIg
PSB0ZHhfZW5hYmxlKCk7DQo+ICsJaWYgKHIpDQo+ICsJCV9fZG9fdGR4X2NsZWFudXAoKTsNCj4g
Kw0KPiArCXJldHVybiByOw0KPiArfQ0KPiANClsuLi5dDQoNCj4gK3N0YXRpYyBpbnQgX19pbml0
IF9fdGR4X2JyaW5ndXAodm9pZCkNCj4gK3sNCj4gKwlpbnQgcjsNCj4gKw0KPiArCS8qDQo+ICsJ
ICogRW5hYmxpbmcgVERYIHJlcXVpcmVzIGVuYWJsaW5nIGhhcmR3YXJlIHZpcnR1YWxpemF0aW9u
IGZpcnN0LA0KPiArCSAqIGFzIG1ha2luZyBTRUFNQ0FMTHMgcmVxdWlyZXMgQ1BVIGJlaW5nIGlu
IHBvc3QtVk1YT04gc3RhdGUuDQo+ICsJICovDQo+ICsJciA9IGt2bV9lbmFibGVfdmlydHVhbGl6
YXRpb24oKTsNCj4gKwlpZiAocikNCj4gKwkJcmV0dXJuIHI7DQo+ICsNCj4gKwljcHVzX3JlYWRf
bG9jaygpOw0KPiArCXIgPSBfX2RvX3RkeF9icmluZ3VwKCk7DQo+ICsJY3B1c19yZWFkX3VubG9j
aygpOw0KPiArDQoNCkhpIFBhb2xvLA0KDQpUaGlzIHBhdGNoIHN0aWxsIGRvZXNuJ3QgYWRkcmVz
cyBhIGJ1ZyBDaGFvIHBvaW50ZWQgb3V0LCB0aGF0IHRoZQ0KX19kb190ZHhfY2xlYW51cCgpIGNh
biBiZSBjYWxsZWQgZnJvbSBfX2RvX3RkeF9icmluZ3VwKCkgd2l0aCBjcHVzX3JlYWRfbG9jaygp
DQpiZWluZyBob2xkLCBzbyB3ZSBuZWVkIHRvIHVzZSBjcHVocF9yZW1vdmVfc3RhdGVfbm9jYWxs
c19jcHVzbG9ja2VkKCkgaW4NCl9fZG9fdGR4X2NsZWFudXAoKS4NCg0KSSBwb3N0ZWQgYSBkaWZm
IHRvIGFkZHJlc3MgaGVyZToNCg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC80NmVhNzRi
Y2Q4ZWViZTI0MWExNDNlOTI4MGM2NWNhMzNjYjhkY2NlLmNhbWVsQGludGVsLmNvbS9ULyNtMWU4
NjMyOGU2OWIyN2U2Y2M5OTc4ZjkwZGY5MjMxNDRkNjk5YzM1MA0KDQpJdCB3b3VsZCBiZSBncmVh
dCBpZiB5b3UgY291bGQgc3F1YXNoIHRvIHRoZSBrdm0tY29jby1xdWV1ZS4gIFRoZXJlIHdpbGwg
YmUgc29tZQ0KbWlub3IgcmViYXNlIGNvbmZsaWN0IHRvIHRoZSByZXN0IHBhdGNoZXMsIHRob3Vn
aCwgc28gaWYgeW91IHdhbnQgbWUgdG8gc2VuZCBvdXQNCmZpeHVwIHBhdGNoKGVzKSBmb3IgeW91
IHRvIHNxdWFzaCBwbGVhc2UgZG8gbGV0IG1lIGtub3cuDQoNCkJ0dywgdGhlIGRpZmYgYWxzbyBt
b3ZlcyB0aGUgJ2VuYWJsZV92aXJ0X2F0X2xvYWQnIGNoZWNrIHRvDQprdm1fY2FuX3N1cHBvcnRf
dGR4KCksIHdoaWNoIGlzbid0IHJlbGF0ZWQgdG8gdGhpcyBpc3N1ZS4gIEJlbG93IGlzIHRoZSBk
aWZmDQooYWxzbyBhdHRhY2hlZCkgdy9vIHRoaXMgY29kZSBjaGFuZ2UgYnV0IG9ubHkgdG8gYWRk
cmVzcyB0aGUgYWJvdmUgYnVnIGlmIHlvdQ0KcHJlZmVyLg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCmluZGV4IDA2NjZkZmJl
MGJjMC4uOTExNTQ2N2YyMDhkIDEwMDY0NA0KLS0tIGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0K
KysrIGIvYXJjaC94ODYva3ZtL3ZteC90ZHguYw0KQEAgLTM4LDEwICszOCwxNyBAQCBzdGF0aWMg
dm9pZCBfX2RvX3RkeF9jbGVhbnVwKHZvaWQpDQogICAgICAgICAqICdtdWx0aXBsZSBlbmFibGlu
Zycgc2NlbmFyaW8uDQogICAgICAgICAqLw0KICAgICAgICBXQVJOX09OX09OQ0UoIXRkeF9jcHVo
cF9zdGF0ZSk7DQotICAgICAgIGNwdWhwX3JlbW92ZV9zdGF0ZV9ub2NhbGxzKHRkeF9jcHVocF9z
dGF0ZSk7DQorICAgICAgIGNwdWhwX3JlbW92ZV9zdGF0ZV9ub2NhbGxzX2NwdXNsb2NrZWQodGR4
X2NwdWhwX3N0YXRlKTsNCiAgICAgICAgdGR4X2NwdWhwX3N0YXRlID0gMDsNCiB9DQoNCitzdGF0
aWMgdm9pZCBfX3RkeF9jbGVhbnVwKHZvaWQpDQorew0KKyAgICAgICBjcHVzX3JlYWRfbG9jaygp
Ow0KKyAgICAgICBfX2RvX3RkeF9jbGVhbnVwKCk7DQorICAgICAgIGNwdXNfcmVhZF91bmxvY2so
KTsNCit9DQorDQogc3RhdGljIGludCBfX2luaXQgX19kb190ZHhfYnJpbmd1cCh2b2lkKQ0KIHsN
CiAgICAgICAgaW50IHI7DQpAQCAtMTAzLDcgKzExMCw3IEBAIHN0YXRpYyBpbnQgX19pbml0IF9f
dGR4X2JyaW5ndXAodm9pZCkNCiB2b2lkIHRkeF9jbGVhbnVwKHZvaWQpDQogew0KICAgICAgICBp
ZiAoZW5hYmxlX3RkeCkgew0KLSAgICAgICAgICAgICAgIF9fZG9fdGR4X2NsZWFudXAoKTsNCisg
ICAgICAgICAgICAgICBfX3RkeF9jbGVhbnVwKCk7DQogICAgICAgICAgICAgICAga3ZtX2Rpc2Fi
bGVfdmlydHVhbGl6YXRpb24oKTsNCiAgICAgICAgfQ0KIH0NCg0KDQoNCg==

--_002_64168d1d11afb399685067c6f8d57a738bb97eb6camelintelcom_
Content-Type: text/x-patch; name="tdx-init-2.diff"
Content-Description: tdx-init-2.diff
Content-Disposition: attachment; filename="tdx-init-2.diff"; size=769;
	creation-date="Thu, 20 Feb 2025 23:27:48 GMT";
	modification-date="Thu, 20 Feb 2025 23:27:48 GMT"
Content-ID: <8626591A65C80344B2979F079D195F32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMgYi9hcmNoL3g4Ni9rdm0vdm14L3Rk
eC5jCmluZGV4IDA2NjZkZmJlMGJjMC4uOTExNTQ2N2YyMDhkIDEwMDY0NAotLS0gYS9hcmNoL3g4
Ni9rdm0vdm14L3RkeC5jCisrKyBiL2FyY2gveDg2L2t2bS92bXgvdGR4LmMKQEAgLTM4LDEwICsz
OCwxNyBAQCBzdGF0aWMgdm9pZCBfX2RvX3RkeF9jbGVhbnVwKHZvaWQpCiAJICogJ211bHRpcGxl
IGVuYWJsaW5nJyBzY2VuYXJpby4KIAkgKi8KIAlXQVJOX09OX09OQ0UoIXRkeF9jcHVocF9zdGF0
ZSk7Ci0JY3B1aHBfcmVtb3ZlX3N0YXRlX25vY2FsbHModGR4X2NwdWhwX3N0YXRlKTsKKwljcHVo
cF9yZW1vdmVfc3RhdGVfbm9jYWxsc19jcHVzbG9ja2VkKHRkeF9jcHVocF9zdGF0ZSk7CiAJdGR4
X2NwdWhwX3N0YXRlID0gMDsKIH0KIAorc3RhdGljIHZvaWQgX190ZHhfY2xlYW51cCh2b2lkKQor
eworCWNwdXNfcmVhZF9sb2NrKCk7CisJX19kb190ZHhfY2xlYW51cCgpOworCWNwdXNfcmVhZF91
bmxvY2soKTsKK30KKwogc3RhdGljIGludCBfX2luaXQgX19kb190ZHhfYnJpbmd1cCh2b2lkKQog
ewogCWludCByOwpAQCAtMTAzLDcgKzExMCw3IEBAIHN0YXRpYyBpbnQgX19pbml0IF9fdGR4X2Jy
aW5ndXAodm9pZCkKIHZvaWQgdGR4X2NsZWFudXAodm9pZCkKIHsKIAlpZiAoZW5hYmxlX3RkeCkg
ewotCQlfX2RvX3RkeF9jbGVhbnVwKCk7CisJCV9fdGR4X2NsZWFudXAoKTsKIAkJa3ZtX2Rpc2Fi
bGVfdmlydHVhbGl6YXRpb24oKTsKIAl9CiB9Cg==

--_002_64168d1d11afb399685067c6f8d57a738bb97eb6camelintelcom_--

