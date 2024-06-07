Return-Path: <kvm+bounces-19096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 873D4900DAF
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 23:46:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D2111B218D0
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 21:46:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 962D715534A;
	Fri,  7 Jun 2024 21:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfslGqtQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66181411F1;
	Fri,  7 Jun 2024 21:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717796793; cv=fail; b=sz4cSqcMwceFOHTHThkL/Y43684lSvZ5x003AD3P6pj/Mr9PIvqDutmrXbNLljxB+65No2nbEUBdvR3ZRTmt0HR5xzTCb/F2v8ARhvv/oP2YaFSZ1QfAa5b5lN6/Pcj5xsD21BUt6yPwVLUEvyGCNTdHxca8q9FbURMY8XAep0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717796793; c=relaxed/simple;
	bh=dkei+zO+xXNddr8fbE95bcVWj5XoQNcL8fZJhRS0fL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bKgNOmx6T2cWIw0+znskG/rkscpsbCjNMemaZHDOSOB6K1BjWOqavyrPcnEKZgmbeLkhvOmDLBwlzqV5feSBB3pSbaUQyTd8CKIp3gnv8U+g7yRRGhLq1irNVZ6nruFUzzwnbNiqTx/Ir/+5uGTdEx+dxq5tK5wK8zHgeo0HdSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfslGqtQ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717796792; x=1749332792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dkei+zO+xXNddr8fbE95bcVWj5XoQNcL8fZJhRS0fL8=;
  b=dfslGqtQ7AAyawtsZG5YgsWxJxgKhwjDo7X1KdPbL6QSxpBk6Npid9No
   XTboEZSrUDuXT6gmEtBUBEmtm68DmrDQtuVFp9kRIba6+WbM19vZcE3Tg
   q6+uM4yUjklQpAWs2zHFEQVfwQ0hxi1W2xsiQGiDkxH2YT/tUq0KgY9Ge
   TNr7tu9T73q+LrgTNTEttaxiTVUyGgIAy8rPrJ5DadUcOOeeEQcuRLm9F
   FKM5ah0HIXyYadIKKU0IsuRlzA4E9e8POg2pDNcdPyeM9cOyU1TdmqqZP
   K5h7CA8FsENZPdhoBQJlGGDmfcWuhW4OmP+RBepPSdYSAH2QfVJ+HfJiA
   g==;
X-CSE-ConnectionGUID: ruJh1rM5Rl+9DWHYZU4KzQ==
X-CSE-MsgGUID: JEqnLdljQ12Q0P9dZZO31A==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="25109766"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="25109766"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 14:46:31 -0700
X-CSE-ConnectionGUID: zSJvVR+OSvqPEYxuQ8Ld7w==
X-CSE-MsgGUID: XFmSMqviQkqH26OeAOXE0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="39117407"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 14:46:32 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 14:46:31 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 14:46:30 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 14:46:30 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 14:46:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GtKDQZJDYsKdeCQcEAWC0DdrR9iKalw44bzYkWgmUGuGB6zN359b//TF4ywQV5B7Wp5GXqilB1YlAbkC6TtHmBu9dS5RFKbm0OOXWLmTd6kOm0PXWZVxyntLhGN2sviTRXG/0jl4sfueYxIhk8Z5lrK5mSaomJ49g1/80QG1IE7p9+tYBNfjtJAS6bVoIgsQky+zgyX9QHmYd/JvB/1rARTUVKFU13FkWjFn05b3qymZ2scdKNspUzVM0eHMjQWQ0F3RSqm3cuXaGGchAlVNqQ1AEBYeR0+8noFlSKyGCFXskjtWvPnBQ9HzKpZwMl1A7C6kvbYyumJ4GLdxvAqfOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkei+zO+xXNddr8fbE95bcVWj5XoQNcL8fZJhRS0fL8=;
 b=YW7X6jBTd5flTeZcSrg2XRGicLxqfnnKQhvpl2USQCWWbIwXVMKJM7cwXlThs3UrGT7DW0rVOi7xw82KaAAIOxzFib3NRZRqjkhGCx3wvC6iVryu1roIug97M64sQQjZVAvo7w+5N8FXclyS1N892NH+9DP0tu8MKMy3mTcbU3Wpeg7SG6FEZqy7hmJoDmhf66y3AYoz/cqnu6g/8YWCgxDWJosGc+JP4b/oDAhrIMQKWjgAOGMUAzt6UF7wj3H3e/4bE1zFYkpBCZP1icM6CVGdEqnaMw6IJEXYUEplw4zFMASeAzlgJOFVtNAVDAQlRuT5QnKqmjG7rliltF9Q4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN0PR11MB6033.namprd11.prod.outlook.com (2603:10b6:208:374::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Fri, 7 Jun
 2024 21:46:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 21:46:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
Thread-Topic: [PATCH v2 11/15] KVM: x86/tdp_mmu: Reflect tearing down mirror
 page tables
Thread-Index: AQHastVrZBAtPhU8HEOPIJjeiY0PIbG8OJgAgACqCYA=
Date: Fri, 7 Jun 2024 21:46:27 +0000
Message-ID: <c2bab3f7157e6f3b71723cebc0533ef0a908a3b5.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-12-rick.p.edgecombe@intel.com>
	 <CABgObfbA1oBc-D++DyoQ-o6uO0vEpp6R9bMo8UjvmRJ73AZzKQ@mail.gmail.com>
In-Reply-To: <CABgObfbA1oBc-D++DyoQ-o6uO0vEpp6R9bMo8UjvmRJ73AZzKQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN0PR11MB6033:EE_
x-ms-office365-filtering-correlation-id: 02804b5e-a07e-444e-9a26-08dc873b490b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|366007|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?WEVVd25JcnFSOEluUk1lQmxjYTdXYUdvWEFWcjliMGJuNkFHSzJJNDJuUXhD?=
 =?utf-8?B?RmpsY1JKTmEzOXhxbXFDeXBZS29RaEdPVUJmSTVHNlZ1ck1nZ1VHU3NTSDU5?=
 =?utf-8?B?di9IaVdFOTJRUUVDd1J1UUh5TGRoUUlHekRpQUZuS0MzNi9rZHh0Z3gyK2wr?=
 =?utf-8?B?aVhXd05uVTZmTms5R0tPZEM0OVFnZFdYUlFDS3N0Qm1hNTRDSmFLeUljd1FB?=
 =?utf-8?B?Sk9OZnppNE52N3ZuV2Q1cTZVSE9qUEdZZVdib3ZPRC9nQmhhVGJjV2ZQRlVJ?=
 =?utf-8?B?NENWSUNyYzN6WmtnMGtqaEVaaGVDaC9OaU02WFJMWkNoREd1STk3WnVHSWNG?=
 =?utf-8?B?Wkl6SnBXVWpFRWt0M0oyMVZmWG9acktSNENwRy8yR3BSOE9sTXpNTGthelJI?=
 =?utf-8?B?UU1WYytqZnI0VEtkNTNnQUlHWWFQc3N0OHVQY0RNOTFBeWRBR0JoclNKWmxw?=
 =?utf-8?B?cVUyUlp2dTZvTEhvZFJlazdWS0t3ZjhBL01kcWpzRmhtaUtQcUNvS0Nwcmpv?=
 =?utf-8?B?NWNVa01iZWRsU0lJZGZKMlhtWk9rdTA0UHpXVkhIK3hOL1dMRUVJaEgwU3p6?=
 =?utf-8?B?Z0xkdlhLNXcrVkd3ZGxEU3Z6ZGM2em1oL0UrV0FlOEtrZnp5MmR3SUI0Zmt2?=
 =?utf-8?B?ZXBocm5XRDlmV2NVMTFhbHFZQlEvNS9CczAyVytLcm9tY0tvZDZMeTFHZVhU?=
 =?utf-8?B?b0dJRm9kRDllU0dxMEFRN3Bhd0dNa0wxMFNnTXBKVll1ci9RRHlQSnpLdUli?=
 =?utf-8?B?dWVzUU5ZZ240S2gvMTgzVDBtNVJtekJKcFpsaytROTd6K1RmQ2syQ0tNdVpr?=
 =?utf-8?B?b05aYXQvZEFHb2g5QlRUV3gvRmVlckZaTzZwWXphRXFWaVlsbTVkQkRJem43?=
 =?utf-8?B?cUpQZVJ3ckpYVFE4QjJ1czdFRElVWVBleFV2UHp3dGNqMFNqN0Z4TUlDK3cz?=
 =?utf-8?B?YTBZT29rbmtaTDRHd2dHaFY3MEVHb1daQ0ZVWnJmRE1Ib0xLVVR3cFRNUE0v?=
 =?utf-8?B?ZXg3L2FuRWRQai9tU3dvWWZOb0lNUEhwOUQrY2UyblpaYVFNSHJTUXhNV3k1?=
 =?utf-8?B?TEdzVXMzcHk2bHpNbmI0UXhaRStST3Fob0NCTE1CdG1VN3RHM3hzcHhERVpp?=
 =?utf-8?B?RHM5UnQ5UzVsRkE4ZS92WUV6ZENldkpCZC9WTC9UeUw4cHRQNEk4bzJhVHI1?=
 =?utf-8?B?dXg4TUY4NGp0ekx6ZTM1QmtIbUNZN25JMSs2Qk5iNFIxOCtiTzJxOXB6Z3kw?=
 =?utf-8?B?Z3BEMlVOYUFjblFmc2JGVXdJeU9DYXJPSVhKQU1nL2tjY2dveXNBWTZaMGRQ?=
 =?utf-8?B?RGNjK09QenpiNEJQQnhlVVhLS3g4NHJuMlpuUjhlVUphcVU2dmU0UVlyV0dv?=
 =?utf-8?B?MXRtakd6UzR1elJBTWU0TkJxb2hINVVQV1Nvam1weXVGUWJRdEEyQzZsc0Q5?=
 =?utf-8?B?QkZiMllGdk9haEJCOFlIMGU1SllXcC82a1c3by9VdHdzWUZOb0Zsbm1FSHNC?=
 =?utf-8?B?VjNnR1VEM2ZEaTVnTzBqUldKTEhGQkZneUxobHRXNGFhU0lvUkprdmN1Yi9W?=
 =?utf-8?B?Yy9MQW9tRHcwYi9yTm91S3YzWjZnaG9TR1kyaTQrUlpWTy9UaXlKVWx3V2hj?=
 =?utf-8?B?UmxZSVl6eWtrMzhURmVqMkdpUjR1TDMzMkI3Y2dhd1NzMk9QOTgxYW9SdHJY?=
 =?utf-8?B?TENvOFBjRlErbTNkK0hSNXNpK1JXRFNzZ1puSFVSTnEvZkNZZXlWcUk0UENj?=
 =?utf-8?B?OTRvTlQ0UWpUTkVzYjRTdmlwbDVEMDh1aGtDeWxMbENrWUFGbFZ4aTdKUnU1?=
 =?utf-8?Q?3ktVXwBhyN9j/JunLizDV2Qdz8UCGMfVYryvs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWZjZng0Zit6MGhpR000Uk9sVEtQanVMZFR6b0oyamZ3Q001UnR4ZVBuMXJY?=
 =?utf-8?B?NjZuMXloU05aS1YrNnNFL0pNdS9VU1hlOFBIcWsrNE9COFZrNXFCbGpkbWhX?=
 =?utf-8?B?TGlLeHJ5NUxZNXRQQXlETDU0cXNEbHdQdnpmY0J5UnZsYS9GL1UzWHZjRExO?=
 =?utf-8?B?TzhxYXBQQkRadHEzQ1h2ZDJjMnE0c25iN3FMaFNKUFJDbnJGZUhhZU1zUXRq?=
 =?utf-8?B?NWZ1TzNiTkdnRHZRUzRzWWxLSXJYVC9vRWljZlQrVjRweHIwbEtPMHY5UTg0?=
 =?utf-8?B?Zi80MElvdWhxYzRUbDc4U0RsRE5YbUJWbXpLU1pFcVdhT09aOG1hcW0yTEJi?=
 =?utf-8?B?K1ZqV1lEdlBPVE03ZVJ3VWV1K3NoQkdwSEZyK0txZ2xGbnJyK0RrNzFTVUdr?=
 =?utf-8?B?dEdWeVptVFNURE5JdlR2dDBtS0VRREgxczA0SDU4b1Irbkx3bG1GREdkaEh4?=
 =?utf-8?B?SThMZ3JZaFZzUCtMRkp4SEQrNkxTTDdNMHE3MWxtbER3eDJlcWg3M2N2RHZT?=
 =?utf-8?B?cUtNbXAvdWNYdVdLZkRnMjZuQXJsc3R3WlptT0Y4TnRTQ3dHTGlUMDgzdTVY?=
 =?utf-8?B?ZTZqVGFUckI2MmFmUFFQT2l0V0Jpb0hwYVBhSzQ0T1cweTdITFJ2RUlJbXo4?=
 =?utf-8?B?Y00vR0NNZEw4Tkh4LzJtb3ZSc1lSNkNmSkY4VC9BM0dFeitNd3BLWitoQXpG?=
 =?utf-8?B?RkJQQnBVRXBYd0trRUpwemZ0cGl0Njh1am96U2w1V1ZXWS9EYmc1MEcxWkxB?=
 =?utf-8?B?ek9LNmMrejBVQlV3azBpRkxNNWxkbjgvTFNMWXB6R3NjTkdYL2x5RGhPamk1?=
 =?utf-8?B?cStLYkhybHJqYlphWEtJaE55SHc4UVVKMERtYzlKMlJQNnBQRVVIV00ycUJR?=
 =?utf-8?B?YVRGRkxoWHBLZnQ2RTBGa0JEZk9VUWtBTngyNFA2Y2ZoODFjSmxuWTlKcmky?=
 =?utf-8?B?LzBuYkNtU3NBU0tYSVNTbUwrRUZBK3psbXU3dGNTQ3hLMVRlWEhhUDduSTli?=
 =?utf-8?B?TlV1NlY5Nkd0bDl4OXAzT2U4NGpSOWRidGNZOTg0NmVrNDVRb2dTNnFaMkw0?=
 =?utf-8?B?Q3JZMTNoSnBsMTF4c1RPN2RuTmJOOHRrWldBWGZ5TmIwMVdhVmJYMlNqSDA3?=
 =?utf-8?B?Y1RYTWZhelBwT1pwZ2hSb3Z2NmRZMHMvbEw5V09wWnZRVWl1Y0FQNzdyd2NH?=
 =?utf-8?B?V3F5N01TNkgvNDF4UUx0UzVZMXp4OVJraHJob0hJaDNWUGdqeUNHSnlhMTdx?=
 =?utf-8?B?UHA1Y1BPWGZCV3M5ZS9HUGt2ZVBJQzFPUkd2ampZbWNxT1BmQ2tLUDE3WmJu?=
 =?utf-8?B?WnhZWmpUVWg0d3JWTVZOMWtzT1FUT2tLWGttd096a2tHcDg5Y0NYM0s5WDRs?=
 =?utf-8?B?NkVDTzdUeVFYNnJYakZPRXJFVEsvaDN3cFBBSHA0V081OGFqak85UlpRNlZM?=
 =?utf-8?B?WFJCb29yNk1ENER0TnBFRDJOM2xydGk3VzMwN0w1a1ZnOWZNK1JXL1VDZE5m?=
 =?utf-8?B?d29hcS9qdnF6WmNiOTYwVGZWTEg1b2VOMmJVQnBybWR3QmhiL2FaeHE4UC9R?=
 =?utf-8?B?MlgzaTdvdVdMeCtydWRua3RNYWUyU3pmRzFRS3pHSjRNY3ptWHhac2MyMWxE?=
 =?utf-8?B?dnBmblo1czl5SXNEVVB0bVE2V2NzTWtnZEtNUzQxMWNsL2tFYnNPeVl1TmV2?=
 =?utf-8?B?dXNwZk9PbVdwekh3NmN2djlVeHZzZy9qYUdBWWdpT2FJMHhLMXdCQ0JCRmI1?=
 =?utf-8?B?L1FuZEwycWxFSnFXZWZrZCtKRWtzR0J0dkYwQmtHajJGUitzQVRJWVk3UGpO?=
 =?utf-8?B?YXlMbDh4YVQ0cnM1ejVkVVQvK0l3dzVjUzVGUHR2TkN1SHNjVXNhMTdhRWFH?=
 =?utf-8?B?MTlvRy9pQVZTNGh0d0Z2UEl5QklEd3IyMzJGazZ6Wm9qbmhVVFBxUHprQ1hX?=
 =?utf-8?B?NUNCODdFcVkxcHdwWVprNEdDM1U5Y0FuWElNUk5UVXpxNXBiRkNEQkNZSFVE?=
 =?utf-8?B?U1JjVkV5SGxJK1Q0N1NqUHQ5amtiQlA2a1ZLbVd0WDAvbVo4ZFpkMkkwYS9h?=
 =?utf-8?B?eVA5UkdXSCtpcWMwVHNud0c2UmpudzkvVnNjaFVHUlhQOE5wTWJQbkI4NGpr?=
 =?utf-8?B?dW9CQUFzV1JwbU9JQzBNMC9vZFk3b2xiOGVMMFRqUVduMjllWFBIVnlVbXla?=
 =?utf-8?Q?/6/6Galj59/3vDyiMLw1XRw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <237F087DC681AE4A870549B3AEFDCDB4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02804b5e-a07e-444e-9a26-08dc873b490b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 21:46:27.7774
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rGUZOQ25mQQkZu4HhwClorg2k25dnjuakhPlImMeVZpQOv4/HOwLT3teJb1Vw/Nw9Bb5UE76BPp2euVSqtA9GkEPn18MjQkCu19RFn32DNs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6033
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDEzOjM3ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOgo+
ID4gCj4gPiArwqDCoMKgwqDCoMKgIC8qIFVwZGF0ZSBtaXJyb3JlZCBwYWdlIHRhYmxlcyBmb3Ig
cGFnZSB0YWJsZSBhYm91dCB0byBiZSBmcmVlZCAqLwo+ID4gK8KgwqDCoMKgwqDCoCBpbnQgKCpy
ZWZsZWN0X2ZyZWVfc3B0KShzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdmbiwgZW51bSBwZ19sZXZl
bAo+ID4gbGV2ZWwsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHZvaWQgKm1pcnJvcmVkX3NwdCk7Cj4gPiArCj4gPiArwqDC
oMKgwqDCoMKgIC8qIFVwZGF0ZSBtaXJyb3JlZCBwYWdlIHRhYmxlIGZyb20gc3B0ZSBnZXR0aW5n
IHJlbW92ZWQsIGFuZCBmbHVzaAo+ID4gVExCICovCj4gPiArwqDCoMKgwqDCoMKgIGludCAoKnJl
ZmxlY3RfcmVtb3ZlX3NwdGUpKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLCBlbnVtIHBnX2xl
dmVsCj4gPiBsZXZlbCwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga3ZtX3Bmbl90IHBmbik7Cj4gCj4gQWdhaW4s
IG1heWJlIGZyZWVfZXh0ZXJuYWxfc3B0IGFuZCB6YXBfZXh0ZXJuYWxfc3B0ZT8KClllcCwgSSdt
IG9uIGJvYXJkLgoKPiAKPiBBbHNvLCBwbGVhc2UgcmVuYW1lIHRoZSBsYXN0IGFyZ3VtZW50IHRv
IHBmbl9mb3JfZ2ZuLiBJJ20gbm90IHByb3VkIG9mCj4gaXQsIGJ1dCBpdCB0b29rIG1lIG92ZXIg
MTAgbWludXRlcyB0byB1bmRlcnN0YW5kIGlmIHRoZSBwZm4gcmVmZXJyZWQKPiB0byB0aGUgZ2Zu
IGl0c2VsZiwgb3IgdG8gdGhlIGV4dGVybmFsIFNQIHRoYXQgaG9sZHMgdGhlIHNwdGUuLi4KPiBU
aGVyZSdzIGEgcG9zc2liaWxpdHkgdGhhdCBpdCBpc24ndCBqdXN0IG1lLiA6KQoKQWgsIEkgc2Vl
IGhvdyB0aGF0IGNvdWxkIGJlIGNvbmZ1c2luZy4gCgo+IAo+IChJbiBnZW5lcmFsLCB0aGlzIHBh
dGNoIHRvb2sgbWUgYSBfbG90XyB0byByZXZpZXcuLi4gdGhlcmUgd2VyZSBhCj4gY291cGxlIG9m
IHBsYWNlcyB0aGF0IGxlZnQgbWUgaW5jb21wcmVoZW5zaWJseSBwdXp6bGVkLCBtb3JlIG9uIHRo
aXMKPiBiZWxvdykuCgpTb3JyeSBmb3IgdGhhdC4gVGhhbmtzIGZvciB0YWtpbmcgdGhlIHRpbWUg
dG8gd2VlZCB0aHJvdWdoIGl0IGFueXdheS4KCj4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgIGJvb2wg
KCpoYXNfd2JpbnZkX2V4aXQpKHZvaWQpOwo+ID4gCj4gPiDCoMKgwqDCoMKgwqDCoMKgIHU2NCAo
KmdldF9sMl90c2Nfb2Zmc2V0KShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpOwo+ID4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jIGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11
LmMKPiA+IGluZGV4IDQxYjFkM2YyNjU5Ny4uMTI0NWY2YTQ4ZGJlIDEwMDY0NAo+ID4gLS0tIGEv
YXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMKPiA+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvdGRw
X21tdS5jCj4gPiBAQCAtMzQ2LDYgKzM0NiwyOSBAQCBzdGF0aWMgdm9pZCB0ZHBfbW11X3VubGlu
a19zcChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdAo+ID4ga3ZtX21tdV9wYWdlICpzcCkKPiA+IMKg
wqDCoMKgwqDCoMKgwqAgc3Bpbl91bmxvY2soJmt2bS0+YXJjaC50ZHBfbW11X3BhZ2VzX2xvY2sp
Owo+ID4gwqAgfQo+ID4gCj4gPiArc3RhdGljIHZvaWQgcmVmbGVjdF9yZW1vdmVkX3NwdGUoc3Ry
dWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB1NjQgb2xk
X3NwdGUsIHU2NCBuZXdfc3B0ZSwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGludCBsZXZlbCkK
PiAKPiBuZXdfc3B0ZSBpcyBub3QgdXNlZCBhbmQgY2FuIGJlIGRyb3BwZWQuIEFsc28sIHRkcF9t
bXVfemFwX2V4dGVybmFsX3NwdGU/CgpPaCwgeWVwLiBJbiB2MTkgdGhlcmUgdXNlZCB0byBiZSBh
IEtWTV9CVUdfT04oKSwgYnV0IHdlIGNhbiBnZXQgcmlkIG9mIGl0LgoKPiAKPiA+ICt7Cj4gPiAr
wqDCoMKgwqDCoMKgIGJvb2wgd2FzX3ByZXNlbnQgPSBpc19zaGFkb3dfcHJlc2VudF9wdGUob2xk
X3NwdGUpOwo+ID4gK8KgwqDCoMKgwqDCoCBib29sIHdhc19sZWFmID0gd2FzX3ByZXNlbnQgJiYg
aXNfbGFzdF9zcHRlKG9sZF9zcHRlLCBsZXZlbCk7Cj4gCj4gSnVzdCBwdXQgaXQgYmVsb3c6Cj4g
Cj4gaWYgKCFpc19zaGFkb3dfcHJlc2VudF9wdGUob2xkX3NwdGUpKQo+IMKgIHJldHVybjsKClJp
Z2h0LCB0aGlzIGlzIGFub3RoZXIgbWlzcyBmcm9tIHJlbW92aW5nIHRoZSBLVk1fQlVHX09OKClz
LgoKPiAKPiAvKiBIZXJlIHdlIG9ubHkgY2FyZSBhYm91dCB6YXBwaW5nIHRoZSBleHRlcm5hbCBs
ZWFmIFBURXMuICovCj4gaWYgKCFpc19sYXN0X3NwdGUob2xkX3NwdGUsIGxldmVsKSkKPiAKPiA+
ICvCoMKgwqDCoMKgwqAga3ZtX3Bmbl90IG9sZF9wZm4gPSBzcHRlX3RvX3BmbihvbGRfc3B0ZSk7
Cj4gPiArwqDCoMKgwqDCoMKgIGludCByZXQ7Cj4gPiArCj4gPiArwqDCoMKgwqDCoMKgIC8qCj4g
PiArwqDCoMKgwqDCoMKgwqAgKiBBbGxvdyBvbmx5IGxlYWYgcGFnZSB0byBiZSB6YXBwZWQuIFJl
Y2xhaW0gbm9uLWxlYWYgcGFnZSB0YWJsZXMKPiA+IHBhZ2UKPiAKPiBUaGlzIGNvbW1lbnQgbGVm
dCBtZSBjb25mdXNlZCwgc28gSSdsbCB0cnkgdG8gcmVwaHJhc2UgYW5kIHNlZSBpZiBJCj4gY2Fu
IGV4cGxhaW4gd2hhdCBoYXBwZW5zLiBDb3JyZWN0IG1lIGlmIEknbSB3cm9uZy4KPiAKPiBUaGUg
b25seSBwYXRocyB0byBoYW5kbGVfcmVtb3ZlZF9wdCgpIGFyZToKPiAtIGt2bV90ZHBfbW11X3ph
cF9sZWFmcygpCj4gLSBrdm1fdGRwX21tdV96YXBfaW52YWxpZGF0ZWRfcm9vdHMoKQo+IAo+IGJ1
dCBiZWNhdXNlIGt2bV9tbXVfemFwX2FsbF9mYXN0KCkgZG9lcyBub3Qgb3BlcmF0ZSBvbiBtaXJy
b3Igcm9vdHMsCj4gdGhlIGxhdHRlciBjYW4gb25seSBoYXBwZW4gYXQgVk0gZGVzdHJ1Y3Rpb24g
dGltZS4KPiAKPiBCdXQgaXQncyBub3QgY2xlYXIgd2h5IGl0J3Mgd29ydGggbWVudGlvbmluZyBp
dCBoZXJlLCBvciBldmVuIHdoeSBpdAo+IGlzIHNwZWNpYWwgYXQgYWxsLiBJc24ndCB0aGF0IGp1
c3Qgd2hhdCBoYW5kbGVfcmVtb3ZlZF9wdCgpIGRvZXMgYXQKPiB0aGUgZW5kPyBXaHkgZG9lcyBp
dCBtYXR0ZXIgdGhhdCBpdCdzIG9ubHkgZG9uZSBhdCBWTSBkZXN0cnVjdGlvbgo+IHRpbWU/Cj4g
Cj4gSW4gb3RoZXIgd29yZHMsIGl0IHNlZW1zIHRvIG1lIHRoYXQgdGhpcyBjb21tZW50IGlzIFRN
SS4gQW5kIGlmIEkgYW0KPiB3cm9uZyAod2hpY2ggbWF5IHdlbGwgYmUpLCB0aGUgZXh0cmEgaW5m
b3JtYXRpb24gc2hvdWxkIGV4cGxhaW4gdGhlCj4gIndoeSIgaW4gbW9yZSBkZXRhaWwsIGFuZCBp
dCBzaG91bGQgYmUgYXJvdW5kIHRoZSBjYWxsIHRvCj4gcmVmbGVjdF9mcmVlX3NwdCwgbm90IGhl
cmUuCgpURFggb2YgY291cnNlIGhhcyB0aGUgbGltaXRhdGlvbiBhcm91bmQgdGhlIG9yZGVyaW5n
IG9mIHRoZSB6YXBwaW5nIFMtRVBULiBTbyBJCnJlYWQgdGhlIGNvbW1lbnQgdG8gYmUgcmVmZXJy
aW5nIHRvIGhvdyB0aGUgaW1wbGVtZW50YXRpb24gYXZvaWRzIHphcHBpbmcgYW55Cm5vbi1sZWFm
IFBURXMgZHVyaW5nIFREIHJ1bnRpbWUuCgpCdXQgSSdtIGdvaW5nIHRvIGhhdmUgdG8gY2lyY2xl
IGJhY2sgaGVyZSBhZnRlciBpbnZlc3RpZ2F0aW5nIGEgYml0IG1vcmUuIElzYWt1LAphbnkgY29t
bWVudHMgb24gdGhpcyBjb21tZW50IGFuZCBjb25kaXRpb25hbD8KCj4gCj4gPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCByZXR1cm47Cj4gPiArwqDCoMKgwqDCoMKgIC8qIFphcHBpbmcg
bGVhZiBzcHRlIGlzIGFsbG93ZWQgb25seSB3aGVuIHdyaXRlIGxvY2sgaXMgaGVsZC4gKi8KPiA+
ICvCoMKgwqDCoMKgwqAgbG9ja2RlcF9hc3NlcnRfaGVsZF93cml0ZSgma3ZtLT5tbXVfbG9jayk7
Cj4gPiArwqDCoMKgwqDCoMKgIC8qIEJlY2F1c2Ugd3JpdGUgbG9jayBpcyBoZWxkLCBvcGVyYXRp
b24gc2hvdWxkIHN1Y2Nlc3MuICovCj4gPiArwqDCoMKgwqDCoMKgIHJldCA9IHN0YXRpY19jYWxs
KGt2bV94ODZfcmVmbGVjdF9yZW1vdmVfc3B0ZSkoa3ZtLCBnZm4sIGxldmVsLAo+ID4gb2xkX3Bm
bik7Cj4gPiArwqDCoMKgwqDCoMKgIEtWTV9CVUdfT04ocmV0LCBrdm0pOwo+ID4gK30KPiA+ICsK
PiA+IMKgIC8qKgo+ID4gwqDCoCAqIGhhbmRsZV9yZW1vdmVkX3B0KCkgLSBoYW5kbGUgYSBwYWdl
IHRhYmxlIHJlbW92ZWQgZnJvbSB0aGUgVERQCj4gPiBzdHJ1Y3R1cmUKPiA+IMKgwqAgKgo+ID4g
QEAgLTQ0MSw2ICs0NjQsMjIgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3JlbW92ZWRfcHQoc3RydWN0
IGt2bSAqa3ZtLAo+ID4gdGRwX3B0ZXBfdCBwdCwgYm9vbCBzaGFyZWQpCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBoYW5kbGVfY2hhbmdlZF9zcHRlKGt2bSwga3ZtX21tdV9wYWdlX2FzX2lkKHNwKSwgZ2Zu
LAo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIG9sZF9zcHRlLCBSRU1PVkVEX1NQVEUsIHNwLT5yb2xlLAo+
ID4gc2hhcmVkKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmIChpc19taXJy
b3Jfc3Aoc3ApKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgS1ZNX0JVR19PTihzaGFyZWQsIGt2bSk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmVmbGVjdF9yZW1vdmVkX3NwdGUoa3ZtLCBnZm4sIG9s
ZF9zcHRlLAo+ID4gUkVNT1ZFRF9TUFRFLCBsZXZlbCk7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoCB9Cj4gPiArwqDCoMKgwqDCoMKgIH0KPiA+ICsKPiA+ICvCoMKgwqDCoMKgwqAg
aWYgKGlzX21pcnJvcl9zcChzcCkgJiYKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoCBXQVJOX09O
KHN0YXRpY19jYWxsKGt2bV94ODZfcmVmbGVjdF9mcmVlX3NwdCkoa3ZtLCBzcC0+Z2ZuLCBzcC0K
PiA+ID5yb2xlLmxldmVsLAo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAKPiA+IGt2bV9tbXVfbWlycm9yZWRfc3B0KHNwKSkpKSB7Cj4g
Cj4gUGxlYXNlIHVzZSBiYXNlX2dmbiBhbmQgbGV2ZWwgaGVyZSwgaW5zdGVhZCBvZiBmaXNoaW5n
IHRoZW0gZnJvbSBzcC4KCk9oLCB5ZXAsIHRoYW5rcy4KCj4gCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAvKgo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIEZh
aWxlZCB0byBmcmVlIHBhZ2UgdGFibGUgcGFnZSBpbiBtaXJyb3IgcGFnZSB0YWJsZSBhbmQKPiA+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiB0aGVyZSBpcyBub3RoaW5nIHRvIGRv
IGZ1cnRoZXIuCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogSW50ZW50aW9u
YWxseSBsZWFrIHRoZSBwYWdlIHRvIHByZXZlbnQgdGhlIGtlcm5lbCBmcm9tCj4gPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogYWNjZXNzaW5nIHRoZSBlbmNyeXB0ZWQgcGFnZS4K
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIHNwLT5taXJyb3JlZF9zcHQgPSBOVUxMOwo+ID4gwqDCoMKgwqDCoMKg
wqDCoCB9Cj4gPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqAgY2FsbF9yY3UoJnNwLT5yY3VfaGVhZCwg
dGRwX21tdV9mcmVlX3NwX3JjdV9jYWxsYmFjayk7Cj4gPiBAQCAtNzc4LDkgKzgxNywxMSBAQCBz
dGF0aWMgdTY0IHRkcF9tbXVfc2V0X3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQgYXNfaWQsCj4g
PiB0ZHBfcHRlcF90IHNwdGVwLAo+ID4gwqDCoMKgwqDCoMKgwqDCoCByb2xlLmxldmVsID0gbGV2
ZWw7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgIGhhbmRsZV9jaGFuZ2VkX3NwdGUoa3ZtLCBhc19pZCwg
Z2ZuLCBvbGRfc3B0ZSwgbmV3X3NwdGUsIHJvbGUsCj4gPiBmYWxzZSk7Cj4gPiAKPiA+IC3CoMKg
wqDCoMKgwqAgLyogRG9uJ3Qgc3VwcG9ydCBzZXR0aW5nIGZvciB0aGUgbm9uLWF0b21pYyBjYXNl
ICovCj4gPiAtwqDCoMKgwqDCoMKgIGlmIChpc19taXJyb3Jfc3B0ZXAoc3B0ZXApKQo+ID4gK8Kg
wqDCoMKgwqDCoCBpZiAoaXNfbWlycm9yX3NwdGVwKHNwdGVwKSkgewo+ID4gK8KgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgLyogT25seSBzdXBwb3J0IHphcHBpbmcgZm9yIHRoZSBub24tYXRv
bWljIGNhc2UgKi8KPiAKPiBMaWtlIGZvciBwYXRjaCAxMCwgdGhpcyBjb21tZW50IHNob3VsZCBw
b2ludCBvdXQgd2h5IHdlIG5ldmVyIGdldCBoZXJlCj4gZm9yIG1pcnJvciBTUHMuCgpPay4KCgoK

