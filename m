Return-Path: <kvm+bounces-58116-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84215B88259
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 09:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38FB45664A8
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 07:25:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41A92C234F;
	Fri, 19 Sep 2025 07:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbLwITac"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C9E29ACEE;
	Fri, 19 Sep 2025 07:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758266740; cv=fail; b=LIOFxf/m2weha55lERN534R9W/m1yeVwK/J1+cqlNF7Atwa+bkJNuEI3sgPLblKZ7NZOZkIDed9jIFSdx3g2U0bckybFKU3AD2QgHghqqst1vH1ev1xzbkfqabM1ItN+1HkT8UjOiA+HMw/t0fDq1bz5ouC/ItJY/2SFcS7x1Ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758266740; c=relaxed/simple;
	bh=ws0oO7HTTmTtFrKTjsG29DHWec4+F0KdesvsMYDLO3A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ubaP1hKc62pf8P3YKXW5pv7yZ/urRLraZjBT5wkaOPyMRh9Ah+05TcoTK9lTdvom7qKhlNRwR18D29axwbYIDLs8x1VGJ/SklG0eMlCxlI0//vg2em5iePxWTSZ9F7AlYByGrL2XpdKP0Wa0W40bOU22CpU+33uBUkPW5ZyjWDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbLwITac; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758266738; x=1789802738;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ws0oO7HTTmTtFrKTjsG29DHWec4+F0KdesvsMYDLO3A=;
  b=CbLwITacvOhCZYQ1bG30BqYSzsl8+HYTk2DSvhAOkuQIP6giQQddQ/Fp
   CetfbedP+dTUiYeD4nffGETp/Wh1JHwDEcoVAPOH80ORjcCLwsJnbrwgC
   N24nK3UmboVUEwdwN+ya9bum64GfXvLSMbQS/AO5DjIa3w3ju5nphR8LS
   jxQgUSkNYvlAffAmNpoq2RcsFQOclJMgkhoKmcQfjOqZAHJqSauRlFZHY
   lOq3/HdSDrJjg8W9NX5qwbthwIXXArllRS4wkKGRsni+IAkpZUT3N3VPU
   fN3cS6andw7HBitxUhmRpKH+iMusu6AbXDakf4ZIpl6DtpV/A3dXeA0j3
   g==;
X-CSE-ConnectionGUID: Rq67Hi59RzmvWB39mlR/5A==
X-CSE-MsgGUID: GzF6S2toS2CidqPn3PLk7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="83209843"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="83209843"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 00:25:37 -0700
X-CSE-ConnectionGUID: CcuY9zEbSYK6+5yNZjbo0w==
X-CSE-MsgGUID: z1nb1qnYRjCPFMrn7rSLPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="206713018"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 00:25:37 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 00:25:36 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 00:25:36 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.46) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 00:25:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=riH9l5jpyu0DMkZEy69nCTz6pLoWg2sb5tE6ybl+lGCCsiUAbRBFIPfWGypnnIU1mefN7ApWh3LjyFjZLMyXMtCh2ZccaBjI8cekV6McyiqX2LgxGUotkWLS0O/k7xGTqmmXYwK3kfEiJiQ6ZRjCw6Ye+A1JiSqJZr/H2Q6XXeAimIW441/sWS7zf5cv531rfQUSgf5uvMdEYG01dhri/OSVHzEA1CgVtC/NHvdx4kSA/pQ9/tFw5P1ULI/XSzWdFR1+lrtJBM6+luJNnJ2lmTgLlb0+HEXsuEt6lQisdkXb2KAaVkNo0D8VJR0I10Zgxxax574vFJ+LQa5kAvuDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws0oO7HTTmTtFrKTjsG29DHWec4+F0KdesvsMYDLO3A=;
 b=lwjB+dwCTn/3/tDFX9gpiGYgTGurBXWYHYHcrnMDoawlwuHwZ4+7wVsR/43K3zA30o89HdNYrQcWnCC92GyCARRsp0qviO1BIidYjIPU/9chK3/lFxP6nAOls6PH7TP9Ubzto+EJwZ6Hv/gyvqsLLjnHJC7jdW7yGllFSbH6Y5uS1STWLn++2zPMQNrhJGMG02IpKE1RWZCwV0IKlhGu4KmrdzzmHB+1hVDP2cTSeVoaX71w8UI2sUDxacViJQqGEB/Ou3WLxx2kHIVo+b3aILZUmiaSOvTaT0YformDVbqKIfLcff4VzHl7Mb7RMeEdEr+zRBygszB6bPlofY6Fjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Fri, 19 Sep
 2025 07:25:32 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 07:25:31 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
CC: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Topic: [PATCH v3 06/16] x86/virt/tdx: Improve PAMT refcounters
 allocation for sparse memory
Thread-Index: AQHcKPM0s1whGFHeVUeSuikKt1/NBLSaGz4A
Date: Fri, 19 Sep 2025 07:25:31 +0000
Message-ID: <f1018ab125eb18f431ddb3dd50501914b396ee2b.camel@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
	 <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
In-Reply-To: <20250918232224.2202592-7-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|LV8PR11MB8724:EE_
x-ms-office365-filtering-correlation-id: d3c7d791-7214-4d4e-f7cd-08ddf74db771
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VDBieWlRMTJRM1B5TitKcUNPUFVRKzdoeUd3bStkdFFuNk95MXNiR3I2cmFl?=
 =?utf-8?B?UUtNaVE5UVpXejNRaUZzZE1rWWxCaURoK0ZuK1ZENTRsQlY3L3BoaExzcGxB?=
 =?utf-8?B?UzRrU3BTcDZDL2hOMG9SSlhOWGVNSml5dWpIWlI5UjFuTjdpYzZCK2REVjB3?=
 =?utf-8?B?bUxNSGNqSE9uczQ3KzBtZEpJSzJRQTJTdityN1I5Sk9GN1gvdmhSdk9NZUJV?=
 =?utf-8?B?Z2RyNndpSVJMRmkvc2lOOWJyNDAvTHZqR1ZXQXcwR040ZzI2eTZCcnZkVDN4?=
 =?utf-8?B?YXJ3QURNSm1uanNlR3IvNzVxUHVWSjNuNzJwTjlNSjhwdFRxU3E1c3QvK04z?=
 =?utf-8?B?Sk5JQVBvWVZUcW96bm5TTFJGbFB1YzM1U3VJV29FSU9GZ1hoWmVpV3JHVG9M?=
 =?utf-8?B?aW1BWTBUazRqSHBkWGRrOU02YVhVVEJaN0NRR0kwcDFnZHgvZGJLUHZuVTZ6?=
 =?utf-8?B?aXdvWHlzNGR5RFcrajF3QVhHMVQvRUpKaURqMWlZbUczbWpleFIzZENCVUZp?=
 =?utf-8?B?TkhzWkowLzBQZFh6N1k4VVI0TFhncS9GS0tqNWM2ZmhCNnM4aCtpNjFjUWVH?=
 =?utf-8?B?RVNQb2hKSXZydStNMnJJRlVSSlFrQXI1RjVXT0VMNWFaNFF4eU9VRU9aaC95?=
 =?utf-8?B?MWljbVRqaGttZlVBa0hxWHZlRTlVcTU4ZEMvOVdZZWpobjgyZ2ZPT3lxVnda?=
 =?utf-8?B?TUU3UDZldHQrcC9abXJXOGM1VVdGZzJuNWJzanZWRUxuSG1IeXBUQ1gzc0x4?=
 =?utf-8?B?OE9ZMXMzU25oYUNOdk9TZ0hPUzdZVUVJZHFSd09xZkFiMkZBM2JLWERoOVdQ?=
 =?utf-8?B?dnNVSmF5WWZESHlONUJ3MlBNU3ByNEdTTE1tc25lV1FteThxZG9vS2FVeTRX?=
 =?utf-8?B?VkhTSzlaaFR5cDB3UHdIMXNCOTErOGpjKzlCQWZub2p1T3AydDUvMzJGUHl5?=
 =?utf-8?B?SldQblhVZHdhaDlxQTB5UkVkWkoyc2dHcllEOXhpV3lVdW10aURvVlVSUVBH?=
 =?utf-8?B?TWp1UTI0Nk5WcjNvL0pDcmZ1dVQzMTF6Nm1pV0F3UVFXZkdoWUtheng0TnVr?=
 =?utf-8?B?cEJrYlFuOUo5MmxFeFljNWUzbm1yRTFzc1Zhd3JLamZPN09FcWp1aWhiY1Bn?=
 =?utf-8?B?a1pVYnB5VEdweTZ0MlM3K0xUdVp3OStHc01uNGwwS3Y4LzExczR4bHltMDUx?=
 =?utf-8?B?S0NFdDNVU0ZocmlDVmZRMlNGSGZZdStqWG4xUmRIWkFhLzZLWTUxV1VCVFRl?=
 =?utf-8?B?MXdsbVpUc0N4Y1l1cjd1WndhM1JGckdBTys1dnZkNUJzWU5pVEw4czJCcitG?=
 =?utf-8?B?bmlnd3ZjSDJPa241S1BOb1FlbGl6VHh3UTc0Ty9xekEwb2lzK3EzRGZiZzZs?=
 =?utf-8?B?NnZRT0dMWTBscUdBOXYySExzanB1bzB1SzZ4ZFNKbVpybko5Rkx6TkdhNzJS?=
 =?utf-8?B?TmlNRnhSclF1MUh4L0dmNkpEc25RbW1nMTNPVWFHSjdadG8rM0FhT2tHYnZF?=
 =?utf-8?B?K2ZVVVlWT1NyNlMzeVdPMUdUb1h4c3RTL1paOHErVW5NZXNFSVlvdm5OMFNs?=
 =?utf-8?B?U3I2NjdaOXFWUFUrdDFWczhaV25TSHpYaUhJOG9BQ3ptY0pEQjVhUGEzTFI2?=
 =?utf-8?B?cjV4RmF2cTQ5S2YyZ1ZYV252NW1nRTF2Wm1VN25zMEpDVlpVNWprVFU2a0xQ?=
 =?utf-8?B?QWJ0WDlwZHVjTG1QYTdDdnpSNFRYR2hvN0lTWkc4ekloUGI0R255VVkyS2s2?=
 =?utf-8?B?YzMzRzYwbk1QZFJnT0ttQXArTGNDVFVWeTYvcTVUZkpQMGZzZUl5d0NlVE50?=
 =?utf-8?B?V1U1V09BM202TDFRVnMxNXBRZWQyWHE4cFZNOXhZbUNpdjhUclcveWpwTEs1?=
 =?utf-8?B?RGJER2pRM0padnV2WEVyL1d3amNnOXFpdWtsSFlUeUlUQ2lNSVJzUU9SaGkw?=
 =?utf-8?B?Yko2MUdZb0duSFBtazdoZUh5L0p4aE5vUjVVcU03andGOUxVTzBGeFh4ay9Z?=
 =?utf-8?Q?7vZq9SRv026owTWu1ZNkfi5LZS1X40=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b1FyRXFKMmxHbjlJcUJqQmUvaVFsTlphYk9sc2JWZ05sUzF4ajNCRWhtLzBk?=
 =?utf-8?B?cDByU2hZR25qM2tsb25ic2FMdlRPSDNveUtNbHhqMnkxN1BEN2RnbThXRjdq?=
 =?utf-8?B?bG8vc2RyVU5YOEFlQ3F5bEpjemU5R25rVkVnMVk1K3dDUVltMVZ4aWpYQTI3?=
 =?utf-8?B?WVA4aFFxNUdodEU4V1ZNanZKaHB3NXpFR2dlYVppTVVFSWRSUEZYNkdjWnF2?=
 =?utf-8?B?aTMzdmlwVEdrRWV2bG1kRnJRU0ljTlMzbUV2NXJ6NUF2eFcrKzNYZS9tbmVV?=
 =?utf-8?B?Ym45eCtuemE5ay96bTJZMnhZRklyU25HUmhyUUZ6TEFvZVNjNitPVVpSblhw?=
 =?utf-8?B?eHphZnhIMFovYk5wNHZnWWZPZytIWW4ycmxGSi8yWWhRQkgrZDN6ZmNxcjRv?=
 =?utf-8?B?OXc3QWxsUEtuYmpWaEgxSUlYRlB4OHVodWJnTHoybXlMZ2c4NXFFQ0xkWlBu?=
 =?utf-8?B?cUdlbGFqNW1iK1VXMEJXSTZvNEhKTUkzUVJCaHFuTE1qb2xxbkFLSll2SXlt?=
 =?utf-8?B?Vy9TdUxNaGZGYkN2SWJ3VnhSUHVvQmpBYmFnc0lKbHVFU0tyS0N0SE55KzNV?=
 =?utf-8?B?bGxIR1N6Y1lNeVdHNlpzczRQdng5cUFQSGRHTUM2d0UvV25Fc29GbUc4NlNW?=
 =?utf-8?B?NUkzYUdXdnNxdkZoMkpXT1UxVkgyQ1ZhcFpaNmJ3Tzg3bFhrekhScGFQVlNn?=
 =?utf-8?B?NG51OEpzYWxIOEZFVUFKYXNnVDBlK0t4RFFJZllzVjdtUzFsUWZ1Y1dnWVBt?=
 =?utf-8?B?OTRWSVlPOUs4ODBhQmxjQlRuOGdpbnpsamtkSHlldGtweGFQbVFnN1Bxb1RR?=
 =?utf-8?B?aGNuY3ZHTnBNSW5TQkRQSW1idDhnRHFOaHU0bmFWa0RwZjUvaHUrNTVFTTBL?=
 =?utf-8?B?VEpMVWliS1NLSkJoUXpYZFJRcFhwSUZMR01icmhUQTJqWjcxYW8xK1JaY3FH?=
 =?utf-8?B?Z3BtWnpJRmVhOXpFNGJCVWpxdlZ6dm4rL3hDVHJaNG9LYVlIUDZmRkFIa08y?=
 =?utf-8?B?dHdKdHJnTS94YTU5REgrR09oQUVVOFlhT2VtRCtraXJVeUNTcFhrM1pxd1Vl?=
 =?utf-8?B?MElFdk5idFQwOG1yTjdwSHJheVFMb0NobFVyQ1ZSR2g1RndJK09WMXlNYkFQ?=
 =?utf-8?B?Uy9BeXZadTlHWkZwUUdxaEhuOWRiajU3V1RESEcxNDlpTnpyOGdxcS84N01v?=
 =?utf-8?B?RFFRZXZHZHZHVzl6bkNqaldlS2w2RWpkUnYvcjR3dVYvOWRHWlBlVDMzWnZa?=
 =?utf-8?B?bHRKOFZFRHdpaTVkejRUU1BqVGw1ZHM3dk5zelI2UkJKenRxVWYvaUF0ekNr?=
 =?utf-8?B?L0Y3TmxralNpWmRPcHhBbGdZckkyL0lzbDBiK3BnTHFSUGJueVJKUUpNWnI1?=
 =?utf-8?B?bWFGcWNSdDB6VXA4Q2NWR3MveWVrc3hYcWxIa2dWTWpaUUhkelFRdktSSmF6?=
 =?utf-8?B?b3pqNnJHbVhISUNjU3R4Q1J5SjdmQUw1dGN3a0g1elVyNFZnM0NKQTlEc2JD?=
 =?utf-8?B?a081ZERFV0JCaTdWbnNvd0NWOEw2NUNDVU1qWXpJWENMTW9USVhVOHVwOTNX?=
 =?utf-8?B?Z21XZUh5MXhMU0ZXMHowTERjVnVpNkQxeXcySk9KQ0NQOEtNQkMzKzFzL0F3?=
 =?utf-8?B?NkJMQ0F4R3JqYkJQSEQrbGs3VlhjbzMzU243SFFQVlVqKzkvaW1xaVhvWVRG?=
 =?utf-8?B?aVdJWFNpSjZRL2o3cGFUSDgwdXhYSzlNWitnYW02WUdiTDdlT0tGbFd1OVRz?=
 =?utf-8?B?RW13WXJmbUZtQys5R2RqaXlmVkVOSTFMUnNJWVpNWm0waXB2bjVRUGx0T1ZJ?=
 =?utf-8?B?SEpkOVg1MWtIN3BHdWZ6OVFuNGFvVlJwdXh1dFgwcTgzNXRIaVZnb0I3c0Zq?=
 =?utf-8?B?SkxIQWdBeHN2Q3JKeU5BMDZtbENzNWZvL3JDSWtUR080d2prSDM1dW03WTBU?=
 =?utf-8?B?c1hHS0xmQU9wYWJnOEpMQmpVMlpsclZYaVJTMVRXNUtvakI2d04zb01kQ2w0?=
 =?utf-8?B?bTJHY1IyWVhQSGJUMjFFdHpvcDB4eUtLaFZyTkRXSmhXdE1qUnZWOTY1UCsx?=
 =?utf-8?B?T2VQaTJvOStJSjdkeDZFU1FYTklnWG0xc3JMUXBNUnhrbC9yNXlGL3dsTDBS?=
 =?utf-8?Q?sxP/kyXO3C0d/J8iK0OJd7e3e?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4DAD0D3D28E05A4ABF16EF0E0F6C2F2A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c7d791-7214-4d4e-f7cd-08ddf74db771
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2025 07:25:31.8353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oEM5Y5wZ0glLLkfYjyDzG0F9zAmJzsv1+Btp6t3THkUSd6S+BEYNneKFhXu3Tf7ftZXIwNWhNk34saCXh47U+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8724
X-OriginatorOrg: intel.com

DQo+ICsvKiBNYXAgYSBwYWdlIGludG8gdGhlIFBBTVQgcmVmY291bnQgdm1hbGxvYyByZWdpb24g
Ki8NCj4gK3N0YXRpYyBpbnQgcGFtdF9yZWZjb3VudF9wb3B1bGF0ZShwdGVfdCAqcHRlLCB1bnNp
Z25lZCBsb25nIGFkZHIsIHZvaWQgKmRhdGEpDQo+ICt7DQo+ICsJc3RydWN0IHBhZ2UgKnBhZ2U7
DQo+ICsJcHRlX3QgZW50cnk7DQo+ICANCj4gLQlwYW10X3JlZmNvdW50cyA9IHZtYWxsb2Moc2l6
ZSk7DQo+IC0JaWYgKCFwYW10X3JlZmNvdW50cykNCj4gKwlwYWdlID0gYWxsb2NfcGFnZShHRlBf
S0VSTkVMIHwgX19HRlBfWkVSTyk7DQo+ICsJaWYgKCFwYWdlKQ0KPiAgCQlyZXR1cm4gLUVOT01F
TTsNCj4gIA0KPiArCWVudHJ5ID0gbWtfcHRlKHBhZ2UsIFBBR0VfS0VSTkVMKTsNCj4gKw0KPiAr
CXNwaW5fbG9jaygmaW5pdF9tbS5wYWdlX3RhYmxlX2xvY2spOw0KPiArCS8qDQo+ICsJICogUEFN
VCByZWZjb3VudCBwb3B1bGF0aW9ucyBjYW4gb3ZlcmxhcCBkdWUgdG8gcm91bmRpbmcgb2YgdGhl
DQo+ICsJICogc3RhcnQvZW5kIHBmbi7CoA0KPiANCg0KWy4uLl0NCg0KPiBNYWtlIHN1cmUgYW5v
dGhlciBQQU1UIHJhbmdlIGRpZG4ndCBhbHJlYWR5DQo+ICsJICogcG9wdWxhdGUgaXQuDQo+ICsJ
ICovDQoNCk1ha2Ugc3VyZSB0aGUgc2FtZSByYW5nZSBvbmx5IGdldHMgcG9wdWxhdGVkIG9uY2Ug
Pw0KDQo+ICsJaWYgKHB0ZV9ub25lKHB0ZXBfZ2V0KHB0ZSkpKQ0KPiArCQlzZXRfcHRlX2F0KCZp
bml0X21tLCBhZGRyLCBwdGUsIGVudHJ5KTsNCj4gKwllbHNlDQo+ICsJCV9fZnJlZV9wYWdlKHBh
Z2UpOw0KPiArCXNwaW5fdW5sb2NrKCZpbml0X21tLnBhZ2VfdGFibGVfbG9jayk7DQo+ICsNCj4g
IAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiArLyoNCj4gKyAqIEFsbG9jYXRlIFBBTVQgcmVmZXJl
bmNlIGNvdW50ZXJzIGZvciB0aGUgZ2l2ZW4gUEZOIHJhbmdlLg0KPiArICoNCj4gKyAqIEl0IGNv
bnN1bWVzIDJNaUIgZm9yIGV2ZXJ5IDFUaUIgb2YgcGh5c2ljYWwgbWVtb3J5Lg0KPiArICovDQo+
ICtzdGF0aWMgaW50IGFsbG9jX3BhbXRfcmVmY291bnQodW5zaWduZWQgbG9uZyBzdGFydF9wZm4s
IHVuc2lnbmVkIGxvbmcgZW5kX3BmbikNCj4gK3sNCj4gKwl1bnNpZ25lZCBsb25nIHN0YXJ0LCBl
bmQ7DQo+ICsNCj4gKwlzdGFydCA9ICh1bnNpZ25lZCBsb25nKXRkeF9maW5kX3BhbXRfcmVmY291
bnQoUEZOX1BIWVMoc3RhcnRfcGZuKSk7DQo+ICsJZW5kICAgPSAodW5zaWduZWQgbG9uZyl0ZHhf
ZmluZF9wYW10X3JlZmNvdW50KFBGTl9QSFlTKGVuZF9wZm4gKyAxKSk7DQoNCihzb3JyeSBkaWRu
J3Qgbm90aWNlIHRoaXMgaW4gbGFzdCB2ZXJzaW9uKQ0KDQpJIGRvbid0IHF1aXRlIGZvbGxvdyB3
aHkgd2UgbmVlZCAiZW5kX3BmbiArIDEiIGluc3RlYWQgb2YganVzdCAiZW5kX3BmbiI/DQoNCklJ
VUMgdGhpcyBjb3VsZCByZXN1bHQgaW4gYW4gYWRkaXRpb25hbCAyTSByYW5nZSBiZWluZyBwb3B1
bGF0ZWQNCnVubmVjZXNzYXJpbHkgd2hlbiB0aGUgZW5kX3BmbiBpcyAyTSBhbGlnbmVkLg0KDQpB
bmQgLi4uDQoNCj4gKwlzdGFydCA9IHJvdW5kX2Rvd24oc3RhcnQsIFBBR0VfU0laRSk7DQo+ICsJ
ZW5kICAgPSByb3VuZF91cChlbmQsIFBBR0VfU0laRSk7DQo+ICsNCj4gKwlyZXR1cm4gYXBwbHlf
dG9fcGFnZV9yYW5nZSgmaW5pdF9tbSwgc3RhcnQsIGVuZCAtIHN0YXJ0LA0KPiArCQkJCSAgIHBh
bXRfcmVmY291bnRfcG9wdWxhdGUsIE5VTEwpOw0KPiArfQ0KPiArDQo+ICsvKg0KPiArICogUmVz
ZXJ2ZSB2bWFsbG9jIHJhbmdlIGZvciBQQU1UIHJlZmVyZW5jZSBjb3VudGVycy4gSXQgY292ZXJz
IGFsbCBwaHlzaWNhbA0KPiArICogYWRkcmVzcyBzcGFjZSB1cCB0byBtYXhfcGZuLiBJdCBpcyBn
b2luZyB0byBiZSBwb3B1bGF0ZWQgZnJvbQ0KPiArICogYnVpbGRfdGR4X21lbWxpc3QoKSBvbmx5
IGZvciBwcmVzZW50IG1lbW9yeSB0aGF0IGF2YWlsYWJsZSBmb3IgVERYIHVzZS4NCj4gKyAqDQo+
ICsgKiBJdCByZXNlcnZlcyAyTWlCIG9mIHZpcnR1YWwgYWRkcmVzcyBzcGFjZSBmb3IgZXZlcnkg
MVRpQiBvZiBwaHlzaWNhbCBtZW1vcnkuDQo+ICsgKi8NCj4gK3N0YXRpYyBpbnQgaW5pdF9wYW10
X21ldGFkYXRhKHZvaWQpDQo+ICt7DQo+ICsJc3RydWN0IHZtX3N0cnVjdCAqYXJlYTsNCj4gKwlz
aXplX3Qgc2l6ZTsNCj4gKw0KPiArCWlmICghdGR4X3N1cHBvcnRzX2R5bmFtaWNfcGFtdCgmdGR4
X3N5c2luZm8pKQ0KPiArCQlyZXR1cm4gMDsNCj4gKw0KPiArCXNpemUgPSBtYXhfcGZuIC8gUFRS
U19QRVJfUFRFICogc2l6ZW9mKCpwYW10X3JlZmNvdW50cyk7DQo+ICsJc2l6ZSA9IHJvdW5kX3Vw
KHNpemUsIFBBR0VfU0laRSk7DQo+ICsNCj4gKwlhcmVhID0gZ2V0X3ZtX2FyZWEoc2l6ZSwgVk1f
U1BBUlNFKTsNCj4gKwlpZiAoIWFyZWEpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsJ
cGFtdF9yZWZjb3VudHMgPSBhcmVhLT5hZGRyOw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+
ICsvKiBVbm1hcCBhIHBhZ2UgZnJvbSB0aGUgUEFNVCByZWZjb3VudCB2bWFsbG9jIHJlZ2lvbiAq
Lw0KPiArc3RhdGljIGludCBwYW10X3JlZmNvdW50X2RlcG9wdWxhdGUocHRlX3QgKnB0ZSwgdW5z
aWduZWQgbG9uZyBhZGRyLCB2b2lkICpkYXRhKQ0KPiArew0KPiArCXN0cnVjdCBwYWdlICpwYWdl
Ow0KPiArCXB0ZV90IGVudHJ5Ow0KPiArDQo+ICsJc3Bpbl9sb2NrKCZpbml0X21tLnBhZ2VfdGFi
bGVfbG9jayk7DQo+ICsNCj4gKwllbnRyeSA9IHB0ZXBfZ2V0KHB0ZSk7DQo+ICsJLyogcmVmb3Vu
dCBhbGxvY2F0aW9uIGlzIHNwYXJzZSwgbWF5IG5vdCBiZSBwb3B1bGF0ZWQgKi8NCj4gKwlpZiAo
IXB0ZV9ub25lKGVudHJ5KSkgew0KPiArCQlwdGVfY2xlYXIoJmluaXRfbW0sIGFkZHIsIHB0ZSk7
DQo+ICsJCXBhZ2UgPSBwdGVfcGFnZShlbnRyeSk7DQo+ICsJCV9fZnJlZV9wYWdlKHBhZ2UpOw0K
PiArCX0NCj4gKw0KPiArCXNwaW5fdW5sb2NrKCZpbml0X21tLnBhZ2VfdGFibGVfbG9jayk7DQo+
ICsNCj4gKwlyZXR1cm4gMDsNCj4gK30NCj4gKw0KPiArLyogVW5tYXAgYWxsIFBBTVQgcmVmY291
bnQgcGFnZXMgYW5kIGZyZWUgdm1hbGxvYyByYW5nZSAqLw0KPiAgc3RhdGljIHZvaWQgZnJlZV9w
YW10X21ldGFkYXRhKHZvaWQpDQo+ICB7DQo+ICsJc2l6ZV90IHNpemU7DQo+ICsNCj4gIAlpZiAo
IXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkNCj4gIAkJcmV0dXJuOw0K
PiAgDQo+ICsJc2l6ZSA9IG1heF9wZm4gLyBQVFJTX1BFUl9QVEUgKiBzaXplb2YoKnBhbXRfcmVm
Y291bnRzKTsNCj4gKwlzaXplID0gcm91bmRfdXAoc2l6ZSwgUEFHRV9TSVpFKTsNCj4gKw0KPiAr
CWFwcGx5X3RvX2V4aXN0aW5nX3BhZ2VfcmFuZ2UoJmluaXRfbW0sDQo+ICsJCQkJICAgICAodW5z
aWduZWQgbG9uZylwYW10X3JlZmNvdW50cywNCj4gKwkJCQkgICAgIHNpemUsIHBhbXRfcmVmY291
bnRfZGVwb3B1bGF0ZSwNCj4gKwkJCQkgICAgIE5VTEwpOw0KPiAgCXZmcmVlKHBhbXRfcmVmY291
bnRzKTsNCj4gIAlwYW10X3JlZmNvdW50cyA9IE5VTEw7DQo+ICB9DQo+IEBAIC0yODgsMTAgKzM3
NywxOSBAQCBzdGF0aWMgaW50IGJ1aWxkX3RkeF9tZW1saXN0KHN0cnVjdCBsaXN0X2hlYWQgKnRt
Yl9saXN0KQ0KPiAgCQlyZXQgPSBhZGRfdGR4X21lbWJsb2NrKHRtYl9saXN0LCBzdGFydF9wZm4s
IGVuZF9wZm4sIG5pZCk7DQo+ICAJCWlmIChyZXQpDQo+ICAJCQlnb3RvIGVycjsNCj4gKw0KPiAr
CQkvKiBBbGxvY2F0ZWQgUEFNVCByZWZjb3VudGVzIGZvciB0aGUgbWVtYmxvY2sgKi8NCj4gKwkJ
cmV0ID0gYWxsb2NfcGFtdF9yZWZjb3VudChzdGFydF9wZm4sIGVuZF9wZm4pOw0KPiArCQlpZiAo
cmV0KQ0KPiArCQkJZ290byBlcnI7DQo+ICAJfQ0KDQouLi4gd2hlbiBtYXhfcGZuID09IGVuZF9w
Zm4gb2YgdGhlIGxhc3QgVERYIG1lbW9yeSBibG9jaywgdGhpcyBjb3VsZA0KcmVzdWx0IGluIGFu
IGFkZGl0aW9uYWwgcGFnZSBvZiBAcGFtdF9yZWZjb3VudHMgYmVpbmcgYWxsb2NhdGVkLCBidXQg
aXQNCndpbGwgbmV2ZXIgYmUgZnJlZWQgc2luY2UgZnJlZV9wYW10X21ldGFkYXRhKCkgd2lsbCBv
bmx5IGZyZWUgbWFwcGluZyB1cA0KdG8gbWF4X3Bmbi4NCg0KQW0gSSBtaXNzaW5nIGFueXRoaW5n
Pw0K

