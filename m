Return-Path: <kvm+bounces-46376-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37401AB5C2D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 20:20:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6B48A7A9A15
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77252BF978;
	Tue, 13 May 2025 18:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XRcVxJUx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AF38BE5;
	Tue, 13 May 2025 18:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747160419; cv=fail; b=PLI0pqpE226VnGgdRXhxNUsHd1+7cqwaMyXu3ibdPkXs5Se3hFQiIcefr19sW99sqDTZQfksNTGSxkTi/9Q2ldr+wHkKNygptX9tmtyAItuf9M+QlZ1C9gcD7C6Y3ZU9wrCi+s4pZM7L2XaYan6YVQZMvgotm8cLHLyihLprKck=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747160419; c=relaxed/simple;
	bh=aBYBhOLwhHwOBmBbBVd+zULZlR8PfSONiWNfotgCkA4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BW5D4n8mEMbcpn8nL16MRozD52lC1DTNC1md286cz59FykDxMTzAvjkhpEMi25c5N8Lrd/8QL8z8APBufSfBemCVh84zH+EAfR9y4NCvoolJjpEwYooQk3S6CMGcTs1Dzzs6eKmLK3O3sR6v3ZbL7nN29yQ1FBgv8ASRWvEpskA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XRcVxJUx; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747160418; x=1778696418;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=aBYBhOLwhHwOBmBbBVd+zULZlR8PfSONiWNfotgCkA4=;
  b=XRcVxJUxkO6EQluuvj2/Vo6i0H+5b/EeKj+tFHZlpgcIt7VAJe4tGALD
   5j+dHITlehjuIAkXAR9x/E4rJ13AjE1cTuYs+cZKqzMUWJIhCBiyZKbr1
   J5O5EXajhjhLIx06hb22r4DzitiBceHTT4aMqrg7HYVPUJJMpXNsU7XvB
   Ee+EUW1+XCloL6byAFWqHURNLFYBxaNKWXMWAp0+UZppt6otLTi04sB4u
   82Vwe1lCe9V31EDUelHMqAlI83SXnlCBui0Z/HVX9immZKZqAic6NXbss
   Rg8O9kqkhp0FCm7i7EYla7T5U9R/DzfnHFaTbv7WhVMw4hiWVQ7gyD5Eb
   A==;
X-CSE-ConnectionGUID: 6p2cDRw3SCabFrDaZZ+rTg==
X-CSE-MsgGUID: 6ylcdreRRO6HS6RU8napYw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="59256116"
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="59256116"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 11:20:16 -0700
X-CSE-ConnectionGUID: koyDuVdqRs60SKfbDzwgHg==
X-CSE-MsgGUID: OnXbYafVTRKiuNzSW51joA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,285,1739865600"; 
   d="scan'208";a="168723732"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 11:20:16 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 11:20:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 11:20:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 11:20:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G3foMmTjfAqfk82Y/UGIoOYMU4qMNTIJFNd1dj5RCi+4/nOn7kIXTl502k/ijUJmUxtR/j9prLQDJ7j8XpTMXTKrl4HzeB+X/pPoyW8Mu2Y7EG3Zv/ewYSMZiRhoECVNal9aAHK4p4kPmdw3qQMN0ROFOhOKA8iMwZYLbfSW4NOtoCmbmQEtlAbSpzNarSn/YqCf4ahNAYXwIONG9atpxr87if1F/JSxLqf82O45RwC/RQ1bYOQaO78A+EWib9Yrz4CMqXlxmIw3LmsADxYmndy4oT1yZvi0CxaEV7j7xAqFFUVdCDMK15qDNEMihaFur1usOYSjExAs3QQmTxJiIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBYBhOLwhHwOBmBbBVd+zULZlR8PfSONiWNfotgCkA4=;
 b=xMGA7fXxmRKMbL6xXPP67OBBgcTd0Ixq9qAAxyb7cpcI5N5qGILhHTzjIZXhMJOSAdbViT42Jq6P0xjQldJyxVRvkvYxbbduMX7ShIYuNP61ScPlJggoJVflV2sDpPTe8TI1wdQ+Wul6z2iCgFBNTSMzduB7s85IfrQ1EFrQT2x3X5MpWsh7+mykmZQhCbjUMlvd0/OjsPgyWMLixvLXY0pQwY5fDswtVL1LUYvSUs8Ljs7n/vvV8h0YHTXZXeOO0k/RdaeZOJRX2tmiNNaaRBjJ8U4kR500uj42cJvvEuvnKkwhsZIIygsz8mEuQR5OIrE+7En6EG0WoKdf+MBHyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ0PR11MB6623.namprd11.prod.outlook.com (2603:10b6:a03:479::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Tue, 13 May
 2025 18:19:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 18:19:56 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Topic: [RFC PATCH 03/21] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Thread-Index: AQHbtMXplPLpm4nddEmAiCVIEk5qsrPQ/bSA
Date: Tue, 13 May 2025 18:19:56 +0000
Message-ID: <fd626425a201655589b33dd8998bb3191a8f0e2f.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030445.32704-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030445.32704-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ0PR11MB6623:EE_
x-ms-office365-filtering-correlation-id: 041ad0c2-9909-4cba-b043-08dd924ac3ed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?d2xycHBVbW42UURGY3kyMmdHRUh5bFcwc05oeGNQS1kwdUQ0Y3VUYXZwYWtr?=
 =?utf-8?B?Z2xTSTFKTVJrNlMrb2dqaWxxV2xlbWJiZ0tmNTlBTnBvVHFkZXdSenB1Y05G?=
 =?utf-8?B?VkFLOUhwSVhVejVOazRZbjZ6NkI3OHRlaXhGQU1IMTFkMjI4K2pSRVJWdGll?=
 =?utf-8?B?NnM3aHFvMVArb2cvUktJcFJGU0FOSVYrRXRkTkNObWlQeDZTM0J1OTZSWFFo?=
 =?utf-8?B?NXNpdTcvQVJsM2NNOEVvdzhyMXNwNUMxdWlOaEl2WU5kMXhUUUtUTnNKTnI2?=
 =?utf-8?B?VWFnSksxV0IxNzlUQmRHMHVJOVpEZWJKeXlFeWpzUWl4UVczTllBWjUwTXMv?=
 =?utf-8?B?VTUvbTF1SmJJK240QmtITStoVXMvTlNWaDk2NElzcHl5WDlKSGZ4RHl5K1Q5?=
 =?utf-8?B?d2ZQeU1pUXdWRDB0WDIzQkZabmd3aGkwRzZUZ28wUW1JN1BCT1AvSk9qckpu?=
 =?utf-8?B?ajNtK0dObzRDYUNQY044STU2V1RGRnFCd0xTK3NyaDBBa1VES3pVMVRkVmpw?=
 =?utf-8?B?N2FMQldtTlZsMGdDanRFM3ZDUk9WUFBtQ0NPdU50Q2tucmdzYldvRkJsMllQ?=
 =?utf-8?B?dkgraGkzaVRkTTF0SFc5QytSekVtZHdoc29rK3cwc1N0RkI5emovTTF4Rm1Y?=
 =?utf-8?B?cEY4dFQ4TTdTZC9pMVdkVFI0cG5URUNpOFhoUFhMYVhLUkRlMVNaV2VOb3NY?=
 =?utf-8?B?V2RFbk5YMEVyNGFqczE0UjNBeVAvdTJOYktERENrbWV0RFc0Y2JRUlh2Smdl?=
 =?utf-8?B?MGFOZzViWWJjbEx2ZDZob1NhbTlqTkg5VUZ4Qnh5Zm4vNzFCQ3BIN2M3OWhD?=
 =?utf-8?B?ZE5TZWN2eEl2WGN6VXh6UkZoc09CQ3QwVXJha25FQWFUOHcvRUF5K1lrSWRC?=
 =?utf-8?B?STczMTVhbUdDMzl1SDBZbXVsRmMvYkVpcEtUZmhxd0R6S3EvdUpPMGJKSmll?=
 =?utf-8?B?VVdTazlmYllqSVdsTzFJVnVUcVM4YUN5QVZyQjFHLzg2YmRsa05henFKNFpJ?=
 =?utf-8?B?akNNSWkyUmJXVVVISkVvN1dmbXYrTVhCbUk5NkxmT3U2eTQySVZSNXVJa3Vk?=
 =?utf-8?B?VlladXNFRWw0U3pJbEFucXFpSXRUVVJsdkp5NGpON0QwMkhCUGdqMlJZdEpB?=
 =?utf-8?B?UiswN2pBaHhHVWdZOVpoMnVsemRTMWd3bEZqaTd4TkZaR0g3TjYvb3g2dzZ4?=
 =?utf-8?B?d3RVK2JITWhNTkRIclJmUUhBNCs1aWEyOW1NajN6Rk1GRnN3akllbTV3UFd2?=
 =?utf-8?B?d3RnbDNsQ0s0TzBvM3BCQTAzekF4WlJKcHYrcnU1cC9yYThNQ0lUL1psYTV6?=
 =?utf-8?B?a0dEUGhMcnRpbDlDQnRzVjl0T1BUWHlDSExGbnhtSyswTm5pZzdjdy9idmNv?=
 =?utf-8?B?ZlRjRUVSclptV1ZUWjU2NitxTW1WY3RvWkxRSEU1TzNKM21CRDVSSVUxank3?=
 =?utf-8?B?RzNHV2JUN1QxdXFqUFoxWjVja1RvTXBTVzVZZzU5WWlYNXhIWUZTOXUyRmNp?=
 =?utf-8?B?bER5L0hzU3o0dVVwa3ZiN3dmcTJhVXB1dnhOZk9DdGdrV3FpcUhCcVEzMjN1?=
 =?utf-8?B?T2hFOXFwZUoyYm5Jb1VJRDI0WmNPaW0zMzVldVp3SVZFbmg2dEVtMkRDV2Jv?=
 =?utf-8?B?NGFDUDgwNkJtaHgvVU1WR0dYallLa1U4VnZQeUpMVEViY3BIZStWZFdrNWZi?=
 =?utf-8?B?R3JsZm1tVGdTRWRRNHVIY1lUNjhuWGFhUXNOMXNRemozanMrU2ZqMGZJODFv?=
 =?utf-8?B?ZGhkcWRzOFlac3hEL05OeEtMY3pXN29zNUQvM2dFNXdjZXgrUW9nTTV1SThy?=
 =?utf-8?B?ZU43YldWc3dFTGk4R0FjYi9FOG50NnNBQTA4bHFTNFNWNmtDSmdRSVAzNEl3?=
 =?utf-8?B?TzBFTFMvTXZOa293d0JNOEJoaUVUUGJPSVJkYlRrZXNVUWZlQWhSMXpTUzdX?=
 =?utf-8?B?aWFCR0EycTJRSXlHYzFGT3JqL3ZqRmF1cFowWlpQMmQwcEcvNis5MmEvT3F3?=
 =?utf-8?Q?D2/CW/BN05FT9ovd7YqxXw7XlnCUNw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TlIyZ0VVWXRCUFBpMWhYVkprTy80NmRhVEpoa0pjWXdic0xnU01OVW5QSDB1?=
 =?utf-8?B?enZLOENRSDlRV1FWSG93UmM5U1hxWW42cE5ldmxqYit3NnloWDc0MGh5czJL?=
 =?utf-8?B?ZVVEWUtqR1dhbHNTSG1CajV6SVA3YkpYbXpqZ1ZKMFpxZXJ1d3V3OEZydUtt?=
 =?utf-8?B?bCtnR1BzbUJDWEV6MnFqMXllU0lNR3B0azJKODZFRVlsTHRDTkt0N1RJV0wy?=
 =?utf-8?B?TFpmeGtvemdEaGhMMTJncGdnOGh2Z0VwaGVsWnVkN2lVSHhveUtvTFVIeWt4?=
 =?utf-8?B?eFpaS1R4bUdGMXFzeks1Sm5IbnljVXAzMjRQVUdGNzBMWld2UVIzTDR6QnpE?=
 =?utf-8?B?bUJ2OW4vbUw2K2tuU0djcGhmUU5PcDJ6cHoweGFpWGd1SUdzanJpZEVPVXdk?=
 =?utf-8?B?OGNrT1RaSWZJeFdIQTZDNHBqQ2ZuSEJTL3FXWTNCK2JSU3VQNXZLL296ZG4y?=
 =?utf-8?B?ajd3VitwRW9pYW9pb3dybDFSRUQ5VkxVdHNqQzZZTm9FT2hiOVZZZ0NvUW9s?=
 =?utf-8?B?VXZVWTZqbkgxRWUvYVZyeGVDL1VPVzFEYS8yejBhd2RFMGxIRHZkR3VWODAy?=
 =?utf-8?B?bFJtUE5nRlpVc2ljVElWR21uYUIvVTY1WTExMUpLMkdSQStGQ3duUEk3ajZ2?=
 =?utf-8?B?N1V3S1FVRURNVkdyVEZ2dFdtTnRUTm5JSVlraG0wMkNOZzVzVXRlZ2xtVDJ4?=
 =?utf-8?B?RFJENXJJQ2Q4b1ZZWitleitoTk5mV0l5VHRyM2FFTi81cXBha2I5Q2E2cmJD?=
 =?utf-8?B?cEVMZmFsSTU4VTdKYkEvUmMvZ0x3ekNwbnVJUXJ4Y0FWaEZpblhvR1d3cTVM?=
 =?utf-8?B?RWxwdGhBTCt4NXRkbTd6UWJDbGxwM3BVZGRQNTJsYVBRYUZsZ2hZWVRpR2xx?=
 =?utf-8?B?SDFuMUpvZ2QzT2IrOUM3clRNaXdpcEJrTXB3eTNyc0FWUVBDMnpzeE9SUEFR?=
 =?utf-8?B?bHpMRjk3Zm1DZHp1dWFWNzdrMytKZzRxSjVFVjA3Zm5VVDhBUDROTmFicEpM?=
 =?utf-8?B?blY2VHlFVStCYVZXMTJOM3Z4Znp3SE4ybG1LVkxDclNudEFmQmJsYmE2UVRU?=
 =?utf-8?B?WlRlUXJsY3c4dGdJRmdrdGdybnR6MG5MTWF0K0w1VEpqY0kyWWFTQVplNElE?=
 =?utf-8?B?Wk1HL3pzUHV2TG5iZDVna0I5T2U4eVQ2ZUJRMEpvZjZiTjFRTWgxNkZXU0pT?=
 =?utf-8?B?SkVMZjJ5ZjFxc0haVjdlMHdDeEUycEowd2VTWTE1c04vOEhKYXhBWlNJLzlr?=
 =?utf-8?B?RHViQjRvU1ljd2ZnOWN1UDhVZEgxOGtsMDhRN0cwNkF0dE0xVnJoZ3N5MUxW?=
 =?utf-8?B?NVlDMUhYNmx4d1BNclpIazIxcHFhRXNXWHoxMVBXZ3d2MXBERzFQTG83ZklQ?=
 =?utf-8?B?bjliUVpLbWdDcHhjYU1UUFBYajhiWTg3K1h5REs4UENWV0M0dERDUC9hUVBL?=
 =?utf-8?B?czByQU5aenBOYmdxQlNQcTd6NG5EbUxRWHRyWm5NcC82aS9URm5mY0Q4RmIx?=
 =?utf-8?B?N3ZRZS9Lc0lkamFTbmloMzBJL3VQT1JpaThEUFloaHlPczJGTEpRLzkxWG9p?=
 =?utf-8?B?Ym5RdldBWXU2dHoxdWdYWlNERm4xSHJTOVluK3pTZUdEenJvaTdFY0lsME13?=
 =?utf-8?B?SGlydjhUNjVxd1h3M2ZpSUhqYlEwanA4MnJXcjk5ci9SSWR4YzBHdXlyZ2Jq?=
 =?utf-8?B?NHFvZmRIWXU1VFErckJ5NXRyMTliaEY3YXc4azdZd3F4Vk5QcGQ0V09MQzVv?=
 =?utf-8?B?WDkwZ1R5c2x1Y0FrM0swT3Y5N3ZnQzFJMXB3eFF6aUlPYzZadGhKbm1RU1ZW?=
 =?utf-8?B?M0xNV2drbERuTVZXdHRETHo0anJHVHpCMFYwVXJsbkd3WkNKaFRmejBjRmFm?=
 =?utf-8?B?T2NIWVBXOTl1ZzFiRUcxL1AzdWVnS0tRNnBoUTByRXZFNXZldVlJSUo1by9v?=
 =?utf-8?B?eFRWWU9ScGxZUzJJRXhlZGRoVk5IZmVST0d0R1U4WmFqNjI3TW9DVThCakhZ?=
 =?utf-8?B?OHNYK3NHVm1CUldVTExiMUhaVVc3VkpwTXJmUEN3Wm1aRUk0WlErU3A5RURI?=
 =?utf-8?B?d1IvckR5U0JSN1BUVSs2dEdxa2NoQk9WOEdrYVBWNDdDYm11RnJZOGJSZU1C?=
 =?utf-8?B?NWx6ZkNrQzY1cGVsbEJZMEI2SmI5eEx6bG1ZRzR4T2xULzc2Q3cwRWpNL3Bi?=
 =?utf-8?Q?UnsoT1LHHwJhVvcJGLoSIP4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC06B12EA0B21240AE2892C01D39DA06@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041ad0c2-9909-4cba-b043-08dd924ac3ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 18:19:56.8472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NTJPeacetl1GnwsVCiQDFoCu5mVWxolIY/bI7U5PFw5jKV5gu0u+a/GJayvzJFMQrnWeU7XySlntCDayVY+zIBCFq7coI8u0oySCrWTP2D8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6623
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRnJv
bTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQo+IA0KPiBBZGQgYSB3cmFwcGVy
IHRkaF9tZW1fcGFnZV9kZW1vdGUoKSB0byBpbnZva2UgU0VBTUNBTEwgVERIX01FTV9QQUdFX0RF
TU9URQ0KPiB0byBkZW1vdGUgYSBodWdlIGxlYWYgZW50cnkgdG8gYSBub24tbGVhZiBlbnRyeSBp
biBTLUVQVC4gQ3VycmVudGx5LCB0aGUNCj4gVERYIG1vZHVsZSBvbmx5IHN1cHBvcnRzIGRlbW90
aW9uIG9mIGEgMk0gaHVnZSBsZWFmIGVudHJ5LiBBZnRlciBhDQo+IHN1Y2Nlc3NmdWwgZGVtb3Rp
b24sIHRoZSBvbGQgMk0gaHVnZSBsZWFmIGVudHJ5IGluIFMtRVBUIGlzIHJlcGxhY2VkIHdpdGgg
YQ0KPiBub24tbGVhZiBlbnRyeSwgbGlua2luZyB0byB0aGUgbmV3bHktYWRkZWQgcGFnZSB0YWJs
ZSBwYWdlLiBUaGUgbmV3bHkNCj4gbGlua2VkIHBhZ2UgdGFibGUgcGFnZSB0aGVuIGNvbnRhaW5z
IDUxMiBsZWFmIGVudHJpZXMsIHBvaW50aW5nIHRvIHRoZSAyTQ0KPiBndWVzdCBwcml2YXRlIHBh
Z2VzLg0KPiANCj4gVGhlICJncGEiIGFuZCAibGV2ZWwiIGRpcmVjdCB0aGUgVERYIG1vZHVsZSB0
byBzZWFyY2ggYW5kIGZpbmQgdGhlIG9sZA0KPiBodWdlIGxlYWYgZW50cnkuDQo+IA0KPiBBcyB0
aGUgbmV3IG5vbi1sZWFmIGVudHJ5IHBvaW50cyB0byBhIHBhZ2UgdGFibGUgcGFnZSwgY2FsbGVy
cyBuZWVkIHRvDQo+IHBhc3MgaW4gdGhlIHBhZ2UgdGFibGUgcGFnZSBpbiBwYXJhbWV0ZXIgInBh
Z2UiLg0KPiANCj4gSW4gY2FzZSBvZiBTLUVQVCB3YWxrIGZhaWx1cmUsIHRoZSBlbnRyeSwgbGV2
ZWwgYW5kIHN0YXRlIHdoZXJlIHRoZSBlcnJvcg0KPiB3YXMgZGV0ZWN0ZWQgYXJlIHJldHVybmVk
IGluIGV4dF9lcnIxIGFuZCBleHRfZXJyMi4NCj4gDQo+IE9uIGludGVycnVwdCBwZW5kaW5nLCBT
RUFNQ0FMTCBUREhfTUVNX1BBR0VfREVNT1RFIHJldHVybnMgZXJyb3INCj4gVERYX0lOVEVSUlVQ
VEVEX1JFU1RBUlRBQkxFLg0KPiANCj4gW1lhbjogUmViYXNlZCBhbmQgc3BsaXQgcGF0Y2gsIHdy
b3RlIGNoYW5nZWxvZ10NCg0KV2Ugc2hvdWxkIGFkZCB0aGUgbGV2ZWwgb2YgZGV0YWlsIGhlcmUg
bGlrZSB3ZSBkaWQgZm9yIHRoZSBiYXNlIHNlcmllcyBvbmVzLg0KDQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
SXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1i
eTogWWFuIFpoYW8gPHlhbi55LnpoYW9AaW50ZWwuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L2lu
Y2x1ZGUvYXNtL3RkeC5oICB8ICAyICsrDQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMg
fCAyMCArKysrKysrKysrKysrKysrKysrKw0KPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5o
IHwgIDEgKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS90ZHguaA0KPiBpbmRleCAyNmZmYzc5MmU2NzMuLjA4ZWZmNGIyZjVlNyAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vdGR4LmgNCj4gQEAgLTE3Nyw2ICsxNzcsOCBAQCB1NjQgdGRoX21uZ19rZXlfY29uZmlnKHN0
cnVjdCB0ZHhfdGQgKnRkKTsNCj4gIHU2NCB0ZGhfbW5nX2NyZWF0ZShzdHJ1Y3QgdGR4X3RkICp0
ZCwgdTE2IGhraWQpOw0KPiAgdTY0IHRkaF92cF9jcmVhdGUoc3RydWN0IHRkeF90ZCAqdGQsIHN0
cnVjdCB0ZHhfdnAgKnZwKTsNCj4gIHU2NCB0ZGhfbW5nX3JkKHN0cnVjdCB0ZHhfdGQgKnRkLCB1
NjQgZmllbGQsIHU2NCAqZGF0YSk7DQo+ICt1NjQgdGRoX21lbV9wYWdlX2RlbW90ZShzdHJ1Y3Qg
dGR4X3RkICp0ZCwgdTY0IGdwYSwgaW50IGxldmVsLCBzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gKwkJ
CXU2NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpOw0KPiAgdTY0IHRkaF9tcl9leHRlbmQoc3Ry
dWN0IHRkeF90ZCAqdGQsIHU2NCBncGEsIHU2NCAqZXh0X2VycjEsIHU2NCAqZXh0X2VycjIpOw0K
PiAgdTY0IHRkaF9tcl9maW5hbGl6ZShzdHJ1Y3QgdGR4X3RkICp0ZCk7DQo+ICB1NjQgdGRoX3Zw
X2ZsdXNoKHN0cnVjdCB0ZHhfdnAgKnZwKTsNCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBpbmRleCBhNjZk
NTAxYjU2NzcuLjU2OTlkZmU1MDBkOSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYvdmlydC92bXgv
dGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYw0KPiBAQCAtMTY4
NCw2ICsxNjg0LDI2IEBAIHU2NCB0ZGhfbW5nX3JkKHN0cnVjdCB0ZHhfdGQgKnRkLCB1NjQgZmll
bGQsIHU2NCAqZGF0YSkNCj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKHRkaF9tbmdfcmQpOw0K
PiAgDQo+ICt1NjQgdGRoX21lbV9wYWdlX2RlbW90ZShzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdw
YSwgaW50IGxldmVsLCBzdHJ1Y3QgcGFnZSAqcGFnZSwNCj4gKwkJCXU2NCAqZXh0X2VycjEsIHU2
NCAqZXh0X2VycjIpDQo+ICt7DQo+ICsJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0gew0K
PiArCQkucmN4ID0gZ3BhIHwgbGV2ZWwsDQoNClRoaXMgd2lsbCBvbmx5IGV2ZXIgYmUgbGV2ZWwg
Mk1CLCBob3cgYWJvdXQgZHJvcHBpbmcgdGhlIGFyZz8NCg0KPiArCQkucmR4ID0gdGR4X3Rkcl9w
YSh0ZCksDQo+ICsJCS5yOCA9IHBhZ2VfdG9fcGh5cyhwYWdlKSwNCj4gKwl9Ow0KPiArCXU2NCBy
ZXQ7DQo+ICsNCj4gKwl0ZHhfY2xmbHVzaF9wYWdlKHBhZ2UpOw0KPiArCXJldCA9IHNlYW1jYWxs
X3JldChUREhfTUVNX1BBR0VfREVNT1RFLCAmYXJncyk7DQo+ICsNCj4gKwkqZXh0X2VycjEgPSBh
cmdzLnJjeDsNCj4gKwkqZXh0X2VycjIgPSBhcmdzLnJkeDsNCg0KSG93IGFib3V0IHdlIGp1c3Qg
Y2FsbCB0aGVzZSBlbnRyeSBhbmQgbGV2ZWxfc3RhdGUsIGxpa2UgdGhlIGNhbGxlci4NCg0KPiAr
DQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHRkaF9tZW1fcGFn
ZV9kZW1vdGUpOw0KDQpMb29raW5nIGluIHRoZSBkb2NzLCBURFggbW9kdWxlIGdpdmVzIHNvbWUg
c29tZXdoYXQgY29uc3RyYWluZWQgZ3VpZGFuY2U6DQoxLiBUREguTUVNLlBBR0UuREVNT1RFIHNo
b3VsZCBiZSBpbnZva2VkIGluIGEgbG9vcCB1bnRpbCBpdCB0ZXJtaW5hdGVzDQpzdWNjZXNzZnVs
bHkuDQoyLiBUaGUgaG9zdCBWTU0gc2hvdWxkIGJlIGRlc2lnbmVkIHRvIGF2b2lkIGNhc2VzIHdo
ZXJlIGludGVycnVwdCBzdG9ybXMgcHJldmVudA0Kc3VjY2Vzc2Z1bCBjb21wbGV0aW9uIG9mIFRE
SC5NRU0uUEFHRS5ERU1PVEUuDQoNClRoZSBjYWxsZXIgbG9va3MgbGlrZToNCglkbyB7DQoJCWVy
ciA9IHRkaF9tZW1fcGFnZV9kZW1vdGUoJmt2bV90ZHgtPnRkLCBncGEsIHRkeF9sZXZlbCwgcGFn
ZSwNCgkJCQkJICAmZW50cnksICZsZXZlbF9zdGF0ZSk7DQoJfSB3aGlsZSAoZXJyID09IFREWF9J
TlRFUlJVUFRFRF9SRVNUQVJUQUJMRSk7DQoNCglpZiAodW5saWtlbHkodGR4X29wZXJhbmRfYnVz
eShlcnIpKSkgew0KCQl0ZHhfbm9fdmNwdXNfZW50ZXJfc3RhcnQoa3ZtKTsNCgkJZXJyID0gdGRo
X21lbV9wYWdlX2RlbW90ZSgma3ZtX3RkeC0+dGQsIGdwYSwgdGR4X2xldmVsLCBwYWdlLA0KCQkJ
CQkgICZlbnRyeSwgJmxldmVsX3N0YXRlKTsNCgkJdGR4X25vX3ZjcHVzX2VudGVyX3N0b3Aoa3Zt
KTsNCgl9DQoNClRoZSBicnV0ZSBmb3JjZSBzZWNvbmQgY2FzZSBjb3VsZCBhbHNvIGJlIHN1Ympl
Y3RlZCB0byBhDQpURFhfSU5URVJSVVBURURfUkVTVEFSVEFCTEUgYW5kIGlzIG5vdCBoYW5kbGVk
LiBBcyBmb3IgaW50ZXJydXB0IHN0b3JtcywgSSBndWVzcw0Kd2UgY291bGQgZGlzYWJsZSBpbnRl
cnJ1cHRzIHdoaWxlIHdlIGRvIHRoZSBzZWNvbmQgYnJ1dGUgZm9yY2UgY2FzZS4gU28gdGhlDQpU
RFhfSU5URVJSVVBURURfUkVTVEFSVEFCTEUgbG9vcCBjb3VsZCBoYXZlIGEgbWF4IHJldHJpZXMs
IGFuZCB0aGUgYnJ1dGUgZm9yY2UNCmNhc2UgY291bGQgYWxzbyBkaXNhYmxlIGludGVycnVwdHMu
DQoNCkhtbSwgaG93IHRvIHBpY2sgdGhlIG1heCByZXRyaWVzIGNvdW50LiBJdCdzIGEgdHJhZGVv
ZmYgYmV0d2VlbiBpbnRlcnJ1cHQNCmxhdGVuY3kgYW5kIERPUy9jb2RlIGNvbXBsZXhpdHkuIERv
IHdlIGhhdmUgYW55IGlkZWEgaG93IGxvbmcgZGVtb3RlIG1pZ2h0IHRha2U/DQoNCg0KDQoNCg==

