Return-Path: <kvm+bounces-55873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D1C0CB37F4C
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 11:53:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFF4F7A43FD
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 09:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 159DC1C860B;
	Wed, 27 Aug 2025 09:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K+N5XAkH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB82D28312E
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 09:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756288418; cv=fail; b=gnZ3MuwS12wYur6Basw8ZGjCWnjpRB3F5nK5dglS4nxJqKfGTIP75mzP948/EXl/RCqd8vF2qFtLc9YBprAe0uimv8IoVBT+wSwTxCzyxcUD9psRjSxlRNNAhva7pVVAurkhr+dkUFEQ98Xk/aYotxls3yl4r01LPU/Yg2NrM+U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756288418; c=relaxed/simple;
	bh=MP5AvSR1BmOZp8WeEiwC3DvB/eGda/a27qvIqeRXetA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bey30K7VaiAlbAJ3NJfBFbkJIZl7YE0M0jE8h94NcxJnkaCthiEl91THaJCVMR6qBUP8CgRRvr7bM/ZLtX2mf7dVdv5Er931EKxK2BqZvP4UvlR1kBmWbUyKfo8/zRklsumEOO+LitHBzErG0TSE766uhZpzvIDbN6WcejNdTOc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K+N5XAkH; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756288417; x=1787824417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MP5AvSR1BmOZp8WeEiwC3DvB/eGda/a27qvIqeRXetA=;
  b=K+N5XAkHcRF8OmmJPZRv7i6hPt0lHvxeDYUNmiWhzqeyIsoSFxSVEwxU
   Oqr6lmn5vjhSyCVmL8tuG2n8cuSI8euYyZhx6q81DnUmXy+y++GuCgbV5
   2sG72FQpDhdulo2D/Aa1VIHu17Rsf5LrJ593KwCE5vAWCVyuoKEumyQWl
   0nVVpbsL18BaA36wGIR/iw9THC/AGt569erZRSwCl8dAzMH844YmfHryU
   eTIWzcM/0by6XfF16xeFDlVmVpHSqjHDhJwZVaWnYnmF8VyRpk3udM7c9
   Cg4W8bq5kOfHQ6tohutyMl4jJFBXf3OoKK1tVThAihJLz9leCQbRmUH3M
   A==;
X-CSE-ConnectionGUID: SLKKPcG1RnW30O6SFcSBCg==
X-CSE-MsgGUID: HlZ/PKVCRsewWz8mdJJOmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62375592"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62375592"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:53:36 -0700
X-CSE-ConnectionGUID: KsyiRWXAQ6W3B70AGIArsQ==
X-CSE-MsgGUID: LY256bG8S4S0G7sHeD47LQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200698559"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 02:53:34 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:53:33 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 02:53:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.78)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 02:53:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RzY3dD7X6fWK5R5VYYORPp6XeWJNs9Zv1KO0g6p6FDDe8H3lEJW90LZJI/ckn3IaZfHLXCIhgzmdJ5jTmGaXH/WGFUEbtd+lzvpCMqFgSH+0NTTRMKvxSsZW683V5N+azCcs/CdFkSSBPTpeC3fR6C5y2TXpGPp6PEgmthID0/2hTBdVg/LvpqvAl1vSHBhwXlSwaGB2ln856TaeR5R+CxgKwu5GN744RjtcpwhqlLjOe9ZGSM3cV/+rxValf0bTsXW6/PNPj5zSsJ5YzFm12l32oxZ0p0HOgvXGggxAgbbUOnY6kC0dB+p3/4L1Le+fmKOp4B5Dej7vF88eNARysA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MP5AvSR1BmOZp8WeEiwC3DvB/eGda/a27qvIqeRXetA=;
 b=HW8ZqEOBizeczuHjjaLRNokm7NtsGbJGTV31/rFQPsWCMEz8Uj08eoKswbDuQ2mrUbjCo5yIitXABMB0ZvSN7fGRlHNMN3nqGhnTLL0aEts8gB/nJUSbuS3G3JRJnxTk8WYaHmLVZIFztP7IEqTIYQnFuK6bq+8RPsolZ/WvCUG/68k10eMvVJGxM4BSNGRLZ1BhyK/UathXsKjUuhAkjeOk2xNMec1F5MLPizcTjB9HU2yoxjLUhW1VwR7BkNWNbqWrhbd5zBtKqdMGQEBeG9Qx08gseXgy1H2SkoKzsBvwzyB4kPBq3AG6u8zdJle+O569OAq1xYeYRUqZ6I10kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6329.namprd11.prod.outlook.com (2603:10b6:510:1ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Wed, 27 Aug
 2025 09:53:31 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Wed, 27 Aug 2025
 09:53:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
Thread-Topic: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
Thread-Index: AQHcFdP1txaByN6LJESEbTad649TFbR0toAAgABRfICAAT08AA==
Date: Wed, 27 Aug 2025 09:53:30 +0000
Message-ID: <37959b67573fe11d1ff4f3c730c49776d3d229d4.camel@intel.com>
References: <20250825152009.3512-1-nikunj@amd.com>
	 <20250825152009.3512-2-nikunj@amd.com>
	 <84a1809495eb262c26987559a90bc80f285f1c0d.camel@intel.com>
	 <0e709b57-0a7e-4aba-8974-e20934ac6415@amd.com>
In-Reply-To: <0e709b57-0a7e-4aba-8974-e20934ac6415@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6329:EE_
x-ms-office365-filtering-correlation-id: 4e29d91c-1d06-47a5-b3ee-08dde54f943b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Ym1kN3htS09PdjdrWDJNRU13N2duTSttTllXWGZLT1VtckhQWDY5K0ZxMjFX?=
 =?utf-8?B?dDhqQ2F6SGQvUU11SGcyZGZuRnJtMktvallKRW5hZHd2d2d0ZGxBa2EzSi9z?=
 =?utf-8?B?VUJNUWQ1SlNKNm04SHJUbE5CMUliQnpUWkkvVXNPUmF3QjJ1cm1XQ2s1NWRC?=
 =?utf-8?B?Tk1OYVBWNHBZZG96QURhblhHZDlIb0pTbERkM2RXV0d4dDlmam1rRVlKTUFJ?=
 =?utf-8?B?OVFJelZDTC82dmlWVExFanJhRUhYNFAvcGhzQlFROFNIdWIzK1lpZHJBNmRU?=
 =?utf-8?B?ZlljMU5HYUdtQmRYWkpCTXdhM2RrYSs5TWVLTlgycHZ1d1UxbmRGbHlXaVFu?=
 =?utf-8?B?QzJNelRKeE9lTTZNN2I2ck05QzF5TG5MYlhwOTF6dVdzdHZYVTl4YmlSN0E0?=
 =?utf-8?B?ajdCNExBS3oyTXVMcFoyMkhjZ281Sks1b085QUQwcmt3NTZMZHJHcHBXZ2RE?=
 =?utf-8?B?bFYwMzdNREVFZy9ER1RzdzE0RXR3UmNtYlljNmh6UTVXemtscWFXelh2UkYz?=
 =?utf-8?B?TjBIbWtkRjJMdEl2MGp3ZFNzUjVnUXVtbVBlTHExbDJnZFNpUHVPVVA0TFVS?=
 =?utf-8?B?K2JmOFJXRWhSQ0s3amlVekl0UDNFMWdwalJVdHM4c011eGlqUzhaSE52TGNN?=
 =?utf-8?B?dlN0MUZXOGJldEJrUXl1RFJtbk9rdWtQL2ZwaDFuQ2xqUEF2RXlvL2ZiSFdG?=
 =?utf-8?B?K3NSNkt3a0xpdC8zZTh5YXVUSk5sc2s2UjBmbEk5cDIwN0FhYWpWUTVhNWRK?=
 =?utf-8?B?ZE93cVl0TWRjZTVVS3IvdW9RZmdzK2d1anAzNUYyVnEzUlozVWUrS3kyTFpt?=
 =?utf-8?B?OFpPK3NKeGdwV1N3SEt0UGR4MTZVNjRweUJzVjVzbGRGeTFKc1VkTXdwRG44?=
 =?utf-8?B?b3ZyRStFOFZDSG5rQTNDcVorbTVRQkVmS1prZmlvUzAxY3JBMm82a3ZIRFY5?=
 =?utf-8?B?S1F6RjRrMmZPd0tJQlNESGpSUE9OMEp4QnhtRVAxNEZYamdVb0p5eWFTZ2ph?=
 =?utf-8?B?eVhpcUNtM0VKRTFleTdycWhrbUJqREpoRWVXeGQ1UzJHSjRqY092aGsvTndP?=
 =?utf-8?B?ZUR3RzhFQWdrUXZSTVhRZWlYbWlCeEd6Ylk4eU96V1ZtV3Z5cEFXRDhwclNu?=
 =?utf-8?B?SGhjOU9ENXNINzk4NmNRSGhjbW51SnpwQit1SEEzR3VuRUs3UjBQUmxxMVc4?=
 =?utf-8?B?cGhoS1B0bnZ3eUZaYUJHaTI3S3lKL2VnNmZLRm5yV0lWNVlYelVZOGRtVGli?=
 =?utf-8?B?ZTNBaUo5MERveEgzNXFNM2g2d0M3Z2I5ODZZNUxtdnpTK0Y1eTZKWnVLNnZK?=
 =?utf-8?B?NjNnRE9IQ1ZsSDBRbEd5aW5XV0J3WmJQMXZPM2gwWmF0OVpZTk9KNG5FV0du?=
 =?utf-8?B?WnVaTjd3TzlMaTA2TjYvRzg4VUlZaDZyczNjcmg0eWJ6dk1iR3BCRHNFaGdB?=
 =?utf-8?B?Q0lDRlZYQXJrY0J5RGdKMHVUOFJLemhGTjJFOGxpOUpJWVkwSlR1OWIxY2dQ?=
 =?utf-8?B?S2N4aFNGYkVVVFVpWTR6NzI2QmUyV2xmU0Q0KzJQcGo2L2JkMllrTXNwSCtK?=
 =?utf-8?B?Z0FUU2RwSFJVcjU3Y2ZRcWJXWDdjWkdqdnpab2JzK3R0ZklxWVJHQ1R0WlBB?=
 =?utf-8?B?MFJZWnR1SGY0MVVmL00zL05WdVVmaFZycUoxNjFHQVFWaHJ5ODhLLzZFc2N5?=
 =?utf-8?B?dHNnNDFVOTdsNFJxajFzRlBuWGJtWEdTa2hhTzUvOXp0TFRxYVNIUitRUElx?=
 =?utf-8?B?RHNkS2RWR2UxRUd0WG9YZzNOVisrbzFUNXQzNEpMY0pMZXdqdlVnNU5CdTVK?=
 =?utf-8?B?blliajFKWStCTGIweFN2VldqSGsvVDU2b2paNUhaQmRNOHEzUTdmK1Z6R2RO?=
 =?utf-8?B?RTg4dDR3RStNamV2ZkZLK2ptMW5FMUJuNnExZWpUdlY1eGpVbkJGQVVIYmwx?=
 =?utf-8?B?cmUwbGtITEVRanRzeGNmZ2tCWFV2RG5NY1oxMEVoSVA2QWV5UXVOeS9Xci91?=
 =?utf-8?B?TWpuY3NFOERBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejh3WXh4QkVoU2o4dWFvUEZsUzZvNUs4U213a1ZMTEtCM080MGx1ajh0aytm?=
 =?utf-8?B?WitIYnZTUUdPcS9tUTVjeGZ4WkR6d0VnMHY0YWlFSmd5WHpJNG5Zc2xkVTFp?=
 =?utf-8?B?TGZJd1pnSE81YlBqZ0s2WkdBdUZydENGbFVrYU9VYS95Q2JQU3d4ZDRYcDRX?=
 =?utf-8?B?V2VFaTBhRUV3a2ZSeE1hSkxqQmwvdlBTeWdlR3lzRFJKMzFXZlRsck9VWlFK?=
 =?utf-8?B?WTlsZ3JZd2ZLK3hrMzlPRE9wSGQvTmN2NTdXODRHNm9HakhTRCtJeUs5TURX?=
 =?utf-8?B?QTc2YjMwYzZoc0dsOElQZld2Z0RRMnNrbzFBKzlwOWdTQVg4SXdvRmNoK0hT?=
 =?utf-8?B?OXNrN1pIL0dpd0w3QUEvUU42c1RmaSszT21uNGxHUEZtTXBGSEc1ZHZqcm9Z?=
 =?utf-8?B?ZXVQTlRyYmh4RDEwSVdqS3pCSjFwZ2ZqTkJBR01RaWNWZS9XNGJTa0ZuY3ZQ?=
 =?utf-8?B?dUc3RmRJZ3d2alhFTzdtVnVvM29ZVEd4UU1TSEtEc2Nzd0JDeHFFanN5YitW?=
 =?utf-8?B?dzBwZjNJcVFvWnVWRTdlWXZTdjBRWWx1QVBSVTNZYkM2dmVhd0V0eHBtTklu?=
 =?utf-8?B?dlAweHUyNElFM2t3SUIyNHZCSDgzd1ptSzJGeUdIRkNrN3ZGV2xNZVE2cmxo?=
 =?utf-8?B?M2lGcjkwM3prOVRMZk1hU0I4Sjh3REdOS3lYdlAwQWZpYXFGaFh2TzZEWnhL?=
 =?utf-8?B?TUNOR24zMzZCbDNEMWtPdk5neFk3UTFUVEE5ZGtBQk1LWGRxOWYwSUJMOEFS?=
 =?utf-8?B?QUNvZWFsVEFObDE3M1FYZnJPWVVuN2Nyc0hGUHVMTG03ZkY2OUlGMzEvSnRS?=
 =?utf-8?B?OVpmYUl3L0R1NWtvc2x3YjJmT1lKalFtaTZwR2RmNlZIU2JQZHVhaExQY1ND?=
 =?utf-8?B?LzJrL1JGYmprenorOHo5MCtLVG1KTmJ5cmNzaHVEVk1QNVpYanorVXphcC80?=
 =?utf-8?B?VFlrbDlHaTlIZTMrM3R3Y2dKZlh6NWxDZkQ0aGlQVGVpNVZDQkpSb0lYYXkw?=
 =?utf-8?B?U084VjlaM0dhNGdLd25ZNkpuZFhyTGZibjlkTHRDYVc4SGpZL0M5aG9jQVpO?=
 =?utf-8?B?WWdXNEpKYm1reGw2MzAxNGpqbGdsanN1ZWQrS0lCTTZMYlVMT2N3YzlWbHJ2?=
 =?utf-8?B?cVlXZ3pXRXFKOXNNcmdwdnQxenJHOTF4Q0p2N21UcisyK0d4UUliT1dBWktC?=
 =?utf-8?B?OFU1SXB6N3IzbkJMSVU3T2hRcEs2N1RlMStwTzVnYUtRZ0VON0QvWVY5b1JC?=
 =?utf-8?B?a1ZHWmNzcXVvT3BYb3ZlUXhqZ2JUMXV4aG5RNmZCYnlxMTFtakExZ2JtcHNy?=
 =?utf-8?B?LzJGRk9jK2pXRmx5aER2STl3NE9YajRGdS96NmtCZ2hib0hvYVpKTjZnMWFj?=
 =?utf-8?B?NHQxdURpcy9YOXdhMFpIUi9helJvN29nZzhYRzZyc09NeFdiWmVaWXdkcytn?=
 =?utf-8?B?RE1CVlNVZnQydGV3Ky9NdGhaYW43RVJQYTl1MVhFbjAxbDl5RitKOGtVbUZB?=
 =?utf-8?B?VWVkVTk2QytwOE0wSkFFS21wcXJya3F6M1FhU2ZWakJsY2dXOG1VUzI4MHFy?=
 =?utf-8?B?OE84VnZ6MVF2ZHpSY0tmQk1QTzRGK1pUMlZJdDdNTXVHRXBWUFp6UUxoeU4y?=
 =?utf-8?B?ZzgvcGtKU3JHNE9KdFNmNTVnZHowV2psc1A0S3IwOG5Nck9EeThzMlY4dFRh?=
 =?utf-8?B?ZHo4R2g0VDhkSEhveCs4TFU0d1Zna3VGcmZNTWRjeTBveGtyV3ZoQkpzZCt2?=
 =?utf-8?B?anV6QXh6YTUrcUV5Nm5CdWZjb0hLOGNIRTlxTXo1WWx6ZFdUTzZ6WmhoRWJG?=
 =?utf-8?B?dE1LY1lNUk9ZZHZHYWlzVzc1NFo0TDMzRFd6RkVWVUhyQml6V1RFUExZaXJU?=
 =?utf-8?B?WWNOSHIvU3FqL0hqOWhBZndhd2I3cGw1bFdHSjNienVxYmt0cW0zSW1rS05Q?=
 =?utf-8?B?UWZCOWVTcVIwM3BIZVBubUFIZjk3WXFjWUFTaWFockpoeitzQkZxYTlmaTBG?=
 =?utf-8?B?VzMzSE8ycy85Y0lWQ3RqTlNKQVFncUFTdGkrb29RUXo5UVZrMUtGSUUvcUlu?=
 =?utf-8?B?Y1JBN052cWwzOFc1d3dDa2Jmb3djRzE5Q2lrSmtOTG0yWnEwR05pd1lZMHhZ?=
 =?utf-8?Q?fvSsI5/VDut1df+eUDS9HuORa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E5F76C7E4B3824D9DE73EBB2D37141F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e29d91c-1d06-47a5-b3ee-08dde54f943b
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2025 09:53:30.8007
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GbzlCRqX9E7RiYbhcUwJNJP0WNbD3Nm2TmGrsGc7x83fmg/67sKgnPQWROK0iDGKuB5ptKmHAWazf1XUANi6cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6329
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDIwOjI4ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA4LzI2LzIwMjUgMzozNiBQTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiBP
biBNb24sIDIwMjUtMDgtMjUgYXQgMTU6MjAgKzAwMDAsIE5pa3VuaiBBIERhZGhhbmlhIHdyb3Rl
Og0KPiA+ID4gTW92ZSB0aGUgUE1MIChQYWdlIE1vZGlmaWNhdGlvbiBMb2dnaW5nKSBidWZmZXIg
Zmx1c2hpbmcgbG9naWMgZnJvbQ0KPiA+ID4gVk1YLXNwZWNpZmljIGNvZGUgdG8gY29tbW9uIHg4
NiBLVk0gY29kZSB0byBlbmFibGUgcmV1c2UgYnkgU1ZNIGFuZCBhdm9pZA0KPiA+ID4gY29kZSBk
dXBsaWNhdGlvbi4NCj4gPiANCj4gPiBMb29raW5nIGF0IHRoZSBjb2RlIGNoYW5nZSwgSUlVQyB0
aGUgUE1MIGNvZGUgdGhhdCBpcyBtb3ZlZCB0byB4ODYgY29tbW9uDQo+ID4gYXNzdW1lcyBBTUQn
cyBQTUwgYWxzbyBmb2xsb3dzIFZNWCdzIGJlaGF2aW91cjoNCj4gPiANCj4gPiAgMSkgVGhlIFBN
TCBidWZmZXIgaXMgYSA0SyBwYWdlOw0KPiA+ICAyKSBUaGUgaGFyZHdhcmUgcmVjb3JkcyB0aGUg
ZGlydHkgR1BBIGluIGJhY2t3YXJkcyB0byB0aGUgUE1MIGJ1ZmZlcg0KPiA+IA0KPiA+IENvdWxk
IHdlIHBvaW50IHRoaXMgb3V0IGluIHRoZSBjaGFuZ2Vsb2c/DQo+IA0KPiBBY2ssIHdpbGwgYWRk
IGluIHRoZSBuZXh0IHJldmlzaW9uDQoNClRoYW5rcy4gIE1heWJlIG9uZSBtb3JlIHRvIHBvaW50
IG91dDoNCg0KICAzKSBBTUQgUE1MIGFsc28gY2xlYXJzIGJpdCAxMTowIHdoZW4gcmVjb3JkaW5n
IHRoZSBHUEEuDQoNCj4gDQo+ID4gDQo+ID4gWy4uLl0NCj4gPiANCj4gPiA+IC0tLSBhL2FyY2gv
eDg2L2t2bS92bXgvdm14LmgNCj4gPiA+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmgNCj4g
PiA+IEBAIC0yNjksMTEgKzI2OSw2IEBAIHN0cnVjdCB2Y3B1X3ZteCB7DQo+ID4gPiAgCXVuc2ln
bmVkIGludCBwbGVfd2luZG93Ow0KPiA+ID4gIAlib29sIHBsZV93aW5kb3dfZGlydHk7DQo+ID4g
PiAgDQo+ID4gPiAtCS8qIFN1cHBvcnQgZm9yIFBNTCAqLw0KPiA+ID4gLSNkZWZpbmUgUE1MX0xP
R19OUl9FTlRSSUVTCTUxMg0KPiA+ID4gLQkvKiBQTUwgaXMgd3JpdHRlbiBiYWNrd2FyZHM6IHRo
aXMgaXMgdGhlIGZpcnN0IGVudHJ5IHdyaXR0ZW4gYnkgdGhlIENQVSAqLw0KPiA+ID4gLSNkZWZp
bmUgUE1MX0hFQURfSU5ERVgJCShQTUxfTE9HX05SX0VOVFJJRVMtMSkNCj4gPiA+IC0NCj4gPiA+
ICAJc3RydWN0IHBhZ2UgKnBtbF9wZzsNCj4gPiANCj4gPiBDYW4gd2Ugc2hhcmUgdGhlICdwbWxf
cGcnIGFzIHdlbGw/DQo+IA0KPiBTdXJlLCBJcyBzdHJ1Y3Qga3ZtX3ZjcHVfYXJjaCB0aGUgcmln
aHQgcGxhY2U/DQo+IA0KDQpZZWFoIEkgdGhpbmsgc28uDQo=

