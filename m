Return-Path: <kvm+bounces-28828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 789C699DB44
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 03:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CBDF1C2145F
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 01:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF7EF14C5B3;
	Tue, 15 Oct 2024 01:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2D0/ZPv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C655184F;
	Tue, 15 Oct 2024 01:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728955465; cv=fail; b=dyd6W3Gsh1CwMUhmchu2cOtFy0rVVM4eJADBNBhLRV2/eUOQoD7K2utCU9c8XMywQ6w+ySWZVNB40OXnmUV+ovqpwUVvJ/MdRsLxIVlLN3X3CLdEJspSdv4J8SWJLMreQrcH2SiFHrcZEevpLUUgzAq+bl/nBUZ9MSeH6HD1XKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728955465; c=relaxed/simple;
	bh=NJOtq0AaFP/0y22r+irqDWMBxxOXnKt2PasKiZQGT6w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qAwyjv0h8yP4TEv5QL+bl6oE4RDA/ym18FhHJq+T6GTV37Cpbkjd5EZj+coZ9HTPVL95qkmWPapMXCb6eWNcKnd1tP08UJqqTaqII3SKdAdhze5GKy8HGM64WLy6kfKWuZpXuBADCtPOCCr/hYmjwTSrLSqprpiz4bPrUUQMoBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2D0/ZPv; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728955464; x=1760491464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NJOtq0AaFP/0y22r+irqDWMBxxOXnKt2PasKiZQGT6w=;
  b=A2D0/ZPvdpuj8pwT7hkgS21rSvZhztqsOUFUOCTBYl6ITAS7erUy0o1v
   pzqnJ9nS8ebPMS2w/oGqzPOkMQltZZBpJi0LpzooybteYUAUHS0r0Nrsb
   kPQxKVWYlAHZXNSCFqRZqSwIApZzhIEAgRM39dqpWJXqJCX3fwtg7hbIw
   F9KHo/SuA+YhIEiu47VDbLpl+QxspHfG4vUy871QGONDOX0vfF9IgXrzA
   GY/FHrJYkC2kM+MfLInC4s7bXkafG1yapc05+XDYJ5P4fbSvqIRPUtzYC
   ekLp/AO8ZHdIigMS7OHvbkqsxs0pFhb0MDp7Ne2XvY7dLXiW8MCao0pIK
   A==;
X-CSE-ConnectionGUID: HQbnSiyeTpKKf/CZ+zndqQ==
X-CSE-MsgGUID: wz7AexJ/T7y+AflVl0uOpQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28414772"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28414772"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 18:24:23 -0700
X-CSE-ConnectionGUID: /+12hBHtTBOJagejvXZxTQ==
X-CSE-MsgGUID: /Smn3OSxRqab7jQLG8eRSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,204,1725346800"; 
   d="scan'208";a="77739973"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 18:24:23 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 18:24:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 18:24:23 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 18:24:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ie8UzNu9FRrmruVJAvyA5Ko7N52hWXEMLGu4RJ9eqtBlBrvRbzfgjN5BXIcAjdgTBwNQjihvK7zEp6Tac0QyYHO5bZRwrCetNlpdQMhy73hb99aD14ck6Fv/Vz95HBFGHaszHTSt4MTeaArPgF+7g+HeJoktlGaxlx2Ntqvd+ejB6fX3tmcN4JKaD2ibzpw4Ub5r16QpVHC1+x8X7QOloq69PIHA1i9O5GOIN6Bfhm8cmB+noG2o+ZH4RCl1YJrHGA/qlH79HwLU1Qv+TqRJztiauTXEmlZUOwEtwxdPZHiwJ5LSrf/9OGFN6VxTktzH9zFC2aJ5z5hTvmkY4SZlGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJOtq0AaFP/0y22r+irqDWMBxxOXnKt2PasKiZQGT6w=;
 b=lI9NhCqZBJALU5rYKXgJA9GghQSTR1lai/zmtxZZHR+S7H5zmsgp4FWL/NJJSaS1uRjwg2Cx8NZNlEYnBZWOTY0AAND3LlqTPq7lfH1bPV74ZwdsG4N/Oejytez++Z0up+LxYHv7/v1GR+mL3OmjZT6uYaXhWe3aL3RZGy59SeZwodA+aFSURi+EMwbItlV6X1zEnm4TObihUYvXToW3xGGwJomHrKoXZowDs9T3IMvEfRL9WvU2PdatYrFonNLmHIv7wxG07jdVxwsouVANlrI24M65uUMOB4hnlB+M7sx9OttxqCSA4Ipc1SEi1FqJdaHC+VlMx3mA7FR/s5T38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB8183.namprd11.prod.outlook.com (2603:10b6:8:161::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.26; Tue, 15 Oct
 2024 01:24:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8048.020; Tue, 15 Oct 2024
 01:24:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yao, Yuan"
	<yuan.yao@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIABDTgAgAAL3ACAABXhgIAAC2gAgAAItQCAABS2AIAEHmMAgACTNQCAAQ19AIARYacAgBSwvICAAoX8gIAAzAUAgABIogCABZFGgIAAcFaAgABbXACAACdFgA==
Date: Tue, 15 Oct 2024 01:24:20 +0000
Message-ID: <b82eb5dc959a28ae3463071f5b3d9ee5d33a00b8.camel@intel.com>
References: <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
	 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
	 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
	 <ZuR09EqzU1WbQYGd@google.com> <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
	 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com> <ZwVG4bQ4g5Tm2jrt@google.com>
	 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com> <ZwgP6nJ-MdDjKEiZ@google.com>
	 <45e912216381759585aed851d67d1d61cdfa1267.camel@intel.com>
	 <08533ab54cb482472176a057b8a10444ca32d10f.camel@intel.com>
	 <ed6ccd719241ef6df1558b69ec81073a3b3cf77c.camel@intel.com>
	 <6571596d-b8bc-4759-8378-6cc8ecd65c97@intel.com>
In-Reply-To: <6571596d-b8bc-4759-8378-6cc8ecd65c97@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB8183:EE_
x-ms-office365-filtering-correlation-id: 5551cddd-f5e1-480d-d50b-08dcecb81818
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cjJ3c3RtcHlBbUo5dm0wdjFSTmI2dkhDbWYvd082WTFScW9uV05TVnczWTQr?=
 =?utf-8?B?NGxDeC9kMVJ1a1RjcUtvcTRuU1I1alRvUm1pcDcyMFMwVitYQWEvTFd5dmtw?=
 =?utf-8?B?elpTQjZnVmVSV3BySEVmVThqMThQMFhCRi8wb2drdFh5Sk5uNjJVc0xHK1Av?=
 =?utf-8?B?NWh0NnpjRXFwSU15THRYMHMrNzZqMDdWMEp0QzJwMWc3eFlUNVRPc0pHYnhW?=
 =?utf-8?B?dEdCS2xvSWpET1ZVcWFwRDc0R1U1dmg2RE45ZVNJTm9KMUV0UFM3RlBaZllo?=
 =?utf-8?B?dlJ0WDFrVmc4VXZiQlRDeExMZlFEMmZ5RUFEWUNyMndrclhrVERPaWt6NDRH?=
 =?utf-8?B?VmI5VnV3d2pieGh0OUo2eVNReENuNjMxSHRHOWZYTFplU2xYVWI4ZW1vb2FZ?=
 =?utf-8?B?WFhhaXl0TFN5aTI4ZHhETlR2bWkxWVI2aUtHbFJKSExveGZzc3Z3cGJ3ckpY?=
 =?utf-8?B?OGVFUzN1Q2pQVkNrandXRHFOOGhMeWVSTUxLZzJTYlEzbDM3S1BCSWIvNG1t?=
 =?utf-8?B?TWpMNm4vcDFndFNKbTF6YVdxVE50clA4V0xGT1hHZkNKY0xNcDV1S1c5Z2JW?=
 =?utf-8?B?MGNnaHVuSHI5Wk4yeTRiODVFMGhDV2gvS0I4bnc1ZkRYQkk5VmVwdzcvTWQz?=
 =?utf-8?B?RmJFSWdyaHVEMUhOakJnK0lLclVzZzcxWWpydlJHMDd2OWFOQ0NRWWtjV05E?=
 =?utf-8?B?TklTeWtpR3pmUjBZSnRpbVVGMHFsN0FqSXljcnl6VTZrT1JaSUZrdEhXU1pJ?=
 =?utf-8?B?Ymp3ODgreVpFMk1pQUxWVm80Y2t2Vno1R0JjUW5sVEpSbFRobXV1dTRBSTBp?=
 =?utf-8?B?dlI5RVJEYTR3NjY1cWx3TEEzb1diV1FBWjd2UCtjZWMzV0puU0NxdFFxb3I5?=
 =?utf-8?B?WENZRHh3SGYvaTE2MmFWRWZKMlVVZG9UWXBORU9JeVRqU0hlSlBidkhmWFFj?=
 =?utf-8?B?RC9EWnJnTHVDYU0yQnpPaHNPTll6SEJ4L3JrSWdLRGNUaEtVdVUzUytVQ2FB?=
 =?utf-8?B?K1FoTk9qeHJHbXh1a2VsL2ViOW00T0hlSHNlNXIrVXR1T1BkOXZoMXpXaVVD?=
 =?utf-8?B?YlhOb25kRHhuUlJRZWlMVlFiV0x0cDAvRXpINll2bXZlYmloSXNiOXFPNWk2?=
 =?utf-8?B?TFgwSlZQejU0VkU2SUpUMFNtb2drS3dQeEVrMUdmMncwOVdybnZpblc2a0sr?=
 =?utf-8?B?dHJyY0dLRjhsVlp5Tk9jN1lObmhVNGx6QXZSeWprdmU3S2EvQUQweElsa1Ju?=
 =?utf-8?B?MldBeTNleHdxR01lR2dxb3k4bWNSVkdqbDFYandhKzM2UFJHVTdDTTdIeFNv?=
 =?utf-8?B?eUNBZGRtQTR5WE1WRFBqUndGcEd2ek1yWURodURtVWc2eXpKd2ZFN1FVZW9V?=
 =?utf-8?B?WDh2MkNSMmF6S0ljSjI1Tm9KU2Q4Vzg1OURkdWdqQmZ2VWQ3eHFtRUtHVVNu?=
 =?utf-8?B?YmNGZTZMMlU4cXpTS2xUMWdxajNuSmt3QUpBaWdsV0QwYStWc0NLNGpqaW5L?=
 =?utf-8?B?Z2E5MVpJOC81dm9WVmNtejY2MHEvYkxqQ3VoaU8zaGF5amcrcm9PeGlvU1J4?=
 =?utf-8?B?TkdxWEkzWDl2ckpLYTB5d2RaT2NtSE1CNmhvR01LOXdsL3Z5bzI0MG5ZeGlr?=
 =?utf-8?B?Vk1Uemk2b3Q1SFVweU96cEN1Z0w2L1FWdDZNNlFLLytnd0dBZnRxN1RBSy9a?=
 =?utf-8?B?bmFtZU00TXZiZnRDamJiRXgraks5UGlZNHNhWXJlV21DQWx1dVFiOHo2VEpk?=
 =?utf-8?B?aHE1cWI1VC9ITTBSRWJ3SkR6NnI1VnAwNGx6OVR3VmRrOERMVmhPQzZSWFBq?=
 =?utf-8?B?VFZRZXZUckFVa2RvNzZPZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTRWWjN0eVYwajh1QTVRRCtHUE1lRVBDWHVTU1d2ckZrZnVXRTRMcFpaK2Ns?=
 =?utf-8?B?d1R2OUxFaHdkcWxyVS9PYXVtZ3NyZ0ZHUm9EN1IvdzhPZ0lyeCsrMHBxVmdQ?=
 =?utf-8?B?ZzI0cndicEI4Sm1jcVhmc3BNOXI0c2RxVW1Pdmw4Q29oMG1nWkpqMDZWa2o5?=
 =?utf-8?B?L3UwWUdkZzVjbytxdkE4TGEyTGhHYmZuem4vb2JZR3VVcVdENEUyUi9zdFFy?=
 =?utf-8?B?RFFadU9xQW0zeXZRd20zYU5qRFg2MlVGWEJmNWdqcEw1b1BrcnFKNzJFdnpi?=
 =?utf-8?B?OHIxU0Q5R216UHNQcktlRFFyQ3gwdm9xMkJTMXlkV3Awd3hjU2dmRjh5STJW?=
 =?utf-8?B?UGladzdtVkJRMTlXQVkzd3drYkRTb3RJY0tXS3RTU2NSRnNVT3FaS1BLY0dk?=
 =?utf-8?B?Nk1SZ3BFZ09pK1NDNWpvMVVBclI2YzVCT0tzSmF4ekNYa084WnBvaHhaTTIy?=
 =?utf-8?B?VjhmT2Joc0t3MUxWd0F0SE5JQktMc0Z0UDdPRW4yNG9Xb0E4WDduZXNjalBt?=
 =?utf-8?B?ZW9VTEtmd2JOd2pzNjV4Qkd2ZUExa21yc2NzTVU0N1RuWEJWa2E5bnZiTkZa?=
 =?utf-8?B?L1MzT3dVczRrbno1aHAxZzg2ekhQb3dtank5WE52WTZ6bkwvQUszdENHOTdX?=
 =?utf-8?B?SGoxdlBTemR3RmwvSnErQlE0NnY5NFJaQzRDS3JBM3hJY0Nvb0Z3a0Qyb3dC?=
 =?utf-8?B?emFxOGhUK2l1b2FpZEk1N3lpanB4Sml5eEx5NjZPNWdjZFNHS0MxeE52d3V0?=
 =?utf-8?B?cVpZcWhUTncxRkxsanFTTkVUaGppWms3SmhGSVVtSURkUVk5SjYyVHJaT2Yr?=
 =?utf-8?B?aklBQWE3ODN5MWxjMU1qTWZaT0NiOTFnN2FHdUNNa2J6L0dRUmU1U3I1OXFF?=
 =?utf-8?B?T1dtaWFYMlpGd2kxQTA0dHcyMlhVSER6SzFZcy9XbUlsYmVTWFJMdGhsYnd0?=
 =?utf-8?B?eUZUM1hiLy8rVlA0WWYxVTVQQktCZHJKUC9UU2JIM1ErbElKdU9rVVBXcDM0?=
 =?utf-8?B?emFNUGMyU1VLUWdOTjVkeFhaL1FMZ3pHL2dEQ2NRcW1Pb1J4dlRRZDduc1E2?=
 =?utf-8?B?aHZPbEZYNzJUNnlXOCtka2FsSFFSaEJJTWRsQjVjUlBGbnU3aGNsamxWUjVI?=
 =?utf-8?B?eFZVbmNRcEJPNUVPSDZEaVhnd0hscGVXV0dKbk1MNXJIa2FaRVkyRlMvSHBT?=
 =?utf-8?B?WTNGYno0R1kvRW1WNmNsZENnRkxIbEZEbGNSMnA3ZFhCQk16WXFtRytMMmF6?=
 =?utf-8?B?Y3pDeVNIRlBrU24yYXR5Qm5TV0N4WVBxZXoyUUJ2T2dKVWZ2YUNNMXIwNFUr?=
 =?utf-8?B?aENvVlhrNU1weVFmTnRqclhBeFVzcDBLQ09vSDVQWVVRME9leXZJbHMrMXdi?=
 =?utf-8?B?Wm92YjhuZDdOQ0xXeERMSEhBeVloQzJkL2ppT0xUUzlvTFFvV3pwTkZwVXIx?=
 =?utf-8?B?b3UyK1FOdHQrZ0loSHh4dDlEazNSUkZiemFTR1d0Ry9FM29nc3Q3TGxTS0hn?=
 =?utf-8?B?SWhvNmpnKzVIMDNYWlhhSkg3WHZkV1JITTdtUTVZbnkyeTVObDdlSG1rNm1X?=
 =?utf-8?B?NysvTUlvWWVpWlNNbGhxY2xESmx0Q1AwaEJpVjllM1g2UTdmek1FZTNkOTVZ?=
 =?utf-8?B?M0hUMFFpT2lFdjMvS01VeWo0Ukxsa3J4bTEra01qTzIrK29YcGVxUnF2WW9p?=
 =?utf-8?B?ajZIckxPTU5wYW9IclRYdEhzWEZnbUJWb1I5aU42Z2orMjkyTUM3QXRRUUtl?=
 =?utf-8?B?dlhTKzVBNzNkUnRsUTBpcmlPOU5uamJoT0FhQ1ZUZTlrZHROZzBiWEtQRmpP?=
 =?utf-8?B?MXUyWEdyWWNBcWZ3RkVFZFJSbm5yN0orOFFmSkNOc3dLZWI1SW1VQWprRzBK?=
 =?utf-8?B?elV4aUs0aThiQVQxSGUzdm9oRkxSWDEweW94bGhEQkJTVUF1M3pJYy9ybW95?=
 =?utf-8?B?VWEzczFtTWFSd1J4Qlg0K0plbDZzNnBicVZXMkIxTVdISXdqU2dhT2xwelJO?=
 =?utf-8?B?dCtGV0U0UG9OMkNmSlBhaEJiYXpIcDJsWkZ6ZDhSdmFQZ0tqSFhjZnNJZWtx?=
 =?utf-8?B?RVRGK08wbWZRR2EveXMyVUVEcUpxd1BLVHRLS1EzQVlxalV3YWk0RjU0N2dU?=
 =?utf-8?B?cys4dzk5ZFBWZk5hUyt4RXFONG1BcVUyMUluaVgzT3FsUXRHeDByYmV0eTRk?=
 =?utf-8?B?NUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70B433BD16A9B440958B8D2F2E5697CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5551cddd-f5e1-480d-d50b-08dcecb81818
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Oct 2024 01:24:20.1700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9Mi6XMC2v5dD0Qj3Rl6Nn2nKzm9UYz4DRLG8aD++1Ck4rzD54bf+6EYs/W2sVXAp+oChntMEOvQCqYqadyeAIVdx9TlyfMOxYfu3TqVL508=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8183
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTEwLTE1IGF0IDEyOjAzICsxMzAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+
ICJJcyBnb2luZyB0byIsIGFzIGluICJ3aWxsIGJlIGNoYW5nZWQgdG8iPyBPciAiZG9lcyB0b2Rh
eSI/DQo+IA0KPiBXaWxsIGJlIGNoYW5nZWQgdG8gKHRvZGF5J3MgYmVoYXZpb3VyIGlzIHRvIGdv
IGJhY2sgdG8gZ3Vlc3QgdG8gbGV0IHRoZSANCj4gZmF1bHQgaGFwcGVuIGFnYWluIHRvIHJldHJ5
KS4NCj4gDQo+IEFGQUlDVCB0aGlzIGlzIHdoYXQgU2VhbiBzdWdnZXN0ZWQ6DQo+IA0KPiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9hbGwvWnVSMDlFcXpVMVdiUVlHZEBnb29nbGUuY29tLw0KPiAN
Cj4gVGhlIHdob2xlIHBvaW50IGlzIHRvIGxldCBLVk0gbG9vcCBpbnRlcm5hbGx5IGJ1dCBub3Qg
Z28gYmFjayB0byBndWVzdCANCj4gd2hlbiB0aGUgZmF1bHQgaGFuZGxlciBzZWVzIGEgZnJvemVu
IFBURS7CoCBBbmQgaW4gdGhpcyBwcm9wb3NhbCB0aGlzIA0KPiBhcHBsaWVzIHRvIGJvdGggbGVh
ZiBhbmQgbm9uLWxlYWYgUFRFcyBJSVVDLCBzbyBpdCBzaG91bGQgaGFuZGxlIHRoZSANCj4gY2Fz
ZSB3aGVyZSB0cnlfY21weGNoZzY0KCkgZmFpbHMgYXMgbWVudGlvbmVkIGJ5IFlhbi4NCj4gDQo+
ID4gDQo+ID4gPiByZXRyeSBpbnRlcm5hbGx5IGZvcg0KPiA+ID4gc3RlcCA0IChyZXRyaWVzIE4g
dGltZXMpIGJlY2F1c2UgaXQgc2VlcyB0aGUgZnJvemVuIFBURSwgYnV0IHdpbGwgbmV2ZXIgZ28N
Cj4gPiA+IGJhY2sNCj4gPiA+IHRvIGd1ZXN0IGFmdGVyIHRoZSBmYXVsdCBpcyByZXNvbHZlZD/C
oCBIb3cgY2FuIHN0ZXAgNCB0cmlnZ2VycyB6ZXJvLXN0ZXA/DQo+ID4gDQo+ID4gU3RlcCAzLTQg
aXMgc2F5aW5nIGl0IHdpbGwgZ28gYmFjayB0byB0aGUgZ3Vlc3QgYW5kIGZhdWx0IGFnYWluLg0K
PiANCj4gQXMgc2FpZCBhYm92ZSwgdGhlIHdob2xlIHBvaW50IGlzIHRvIG1ha2UgS1ZNIGxvb3Ag
aW50ZXJuYWxseSB3aGVuIGl0IA0KPiBzZWVzIGEgZnJvemVuIFBURSwgYnV0IG5vdCBnbyBiYWNr
IHRvIGd1ZXN0Lg0KDQpZZWEsIEkgd2FzIHNheWluZyBvbiB0aGF0IGlkZWEgdGhhdCBJIHRob3Vn
aHQgbG9vcGluZyBmb3JldmVyIHdpdGhvdXQgY2hlY2tpbmcNCmZvciBhIHNpZ25hbCB3b3VsZCBi
ZSBwcm9ibGVtYXRpYy4gVGhlbiB1c2Vyc3BhY2UgY291bGQgcmUtZW50ZXIgdGhlIFRELiBJIGRv
bid0DQprbm93IGlmIGl0J3MgYSBzaG93IHN0b3BwZXIuDQoNCkluIGFueSBjYXNlIHRoZSBkaXNj
dXNzaW9uIGJldHdlZW4gdGhlc2UgdGhyZWFkcyBhbmQgTFBDL0tWTSBmb3J1bSBoYWxsd2F5DQpj
aGF0dGVyIGhhcyBnb3R0ZW4gYSBiaXQgZnJhZ21lbnRlZC4gSSBkb24ndCB0aGluayB0aGVyZSBp
cyBhbnkgY29uY3JldGUNCmNvbnNlbnN1cyBzb2x1dGlvbiBhdCB0aGlzIHBvaW50Lg0K

