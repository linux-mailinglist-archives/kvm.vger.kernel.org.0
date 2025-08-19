Return-Path: <kvm+bounces-54958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E0F9B2BAEA
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 09:39:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44366627838
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 07:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402A93101A5;
	Tue, 19 Aug 2025 07:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TlwaPRIA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DEA281366;
	Tue, 19 Aug 2025 07:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755589104; cv=fail; b=mO4eOrT63ynlIPsp586wj25UeBb1oz0a+EI7IIJChXw4keceXAZByF1lpQ6+Q5JR3MyHONZec6Iny+oBm5NXoKbA3D6XT9G6XQgsDJOs5w6xtsBPOgTrfuoCeVShkKzyfCqJCi9jbrHP/pWYNhrxRiOe3yNUMT0p+3K6mM4x5J8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755589104; c=relaxed/simple;
	bh=DHlHueHHrlqTNyGeyH2XxF6R63ukLHf0IC7A7Wzmib8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gU5TLVblD0hyKHCSj/KqpAfhnvRoDvz2fboaup5Ba4SKPpcW8OJx4bsRl7RMwB6lnNeG2an2lS2RZRFtxbN2Du+2dtiP2RsKIMPenxKY0GsKra79/fGQ8+sKlDeInC84yb2EznPqqhzwdavsfj2QiELoeYHOist5jancHazAimM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TlwaPRIA; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755589103; x=1787125103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DHlHueHHrlqTNyGeyH2XxF6R63ukLHf0IC7A7Wzmib8=;
  b=TlwaPRIA2P8o3uo/8WLiyGAXyey2gEcRF44H1FLJhGntIR/DXj+WN73C
   ybW63wDgt7MRuRUR8O4x6wpMEijkf7ze8tJnpG6nyFrSjvgL+L1+oX7AQ
   tZiCo2WtCJZHrt5aoFcRAvwzkn+0W1eBLjxMaTjxIFdHtcQrhIkx2zZzM
   zZbVE4m4m1h7sjDmQGjXudDz0OAGTFBvG1u9rFffsQfOtN1Yu1gtG1CeE
   RNPK9tOqUSjG7g5pIFcnjGf20N2HDNj0NTzPgzofDgjNufmPjniExjj2Y
   WS3+hJ6uTir+ikWPS0uj2hoXNYd+N7gchPYuFGTj/Hq59a6dBYY/u6ljy
   A==;
X-CSE-ConnectionGUID: rDCtNtNLS/ixP3kchiuMWA==
X-CSE-MsgGUID: JycOt0eKTO+tQZbWYi0cBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11526"; a="57751578"
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="57751578"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 00:38:22 -0700
X-CSE-ConnectionGUID: vjHzvh8cQ1qOrS0v0hR9Zg==
X-CSE-MsgGUID: A9nN/vg9SLyvYO/zSxOoeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,300,1747724400"; 
   d="scan'208";a="173137073"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 00:38:22 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 00:38:21 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 19 Aug 2025 00:38:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.62)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 19 Aug 2025 00:38:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YeaCszdfRtCM/oONYwbyJEgLSUAClD+2gZzVTkPmZ+Ht2o0Rr4ZlgqnznFIYGICEyuBKjG1MgYdMoKDT1bp/+bdWimVRJd8xVHigf66xAF8VdtzWcihvkxZCYygiblTsqLMV7+iIQ41NSmdRDB/wubBHMC0vP9JYZc0pHhnLm2o7z/edZDZQfhfWapQq2rGtd9X/YFxMDDHM/rKoHM+NulwtUl+A1vaP5iOnFNEB/3Tu6QuwcEJVDGbtyzcFilgnGBPWASfiiyYOQg6x4dEMWsQIl+PTosmEiY4lNmAUz/paA5D/pMhG7L5J6XFmr8uFr3y7KkZKtZLxnKwen7y5aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M8QGgtgG2PT9wNxymzcJ9nPihBi/W2+JQhYYyyiFHEs=;
 b=f6lsRmkDzrch8FMPfKefgnUptImZDPyTyT7ECXGClapxi5uvoLbHUjdn38ZO4iIHqVW7eSGPmpSR0/eyPYQDeoN3x9SUXmCka8e80YEUtqhaGILgWhsJndc3u1cd7CP4xTOF2EV2wQiJxLnd+iNWZaAKjPOGLnd5Cg20cYMJuf20oPQwHVxdIXP4X6h1HG6frBATgIjNd0ndABdGBsIXbAROhAD6qjQlELPCAxZ3sjmGfMwt/iWnpy6FtovaFxococMZZOdNCnEGvY0OWMepGvX1RRPA6YjYpirFxfsEpvJzbLFV/3P4RLO+nWAbLLlQAfGekBZY8vYjrJZOWbivdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by LV2PR11MB6071.namprd11.prod.outlook.com (2603:10b6:408:178::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.23; Tue, 19 Aug
 2025 07:38:17 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9031.023; Tue, 19 Aug 2025
 07:38:17 +0000
Message-ID: <968d2750-cbd6-47cb-b2fc-d0894662dafc@intel.com>
Date: Tue, 19 Aug 2025 10:38:12 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] KVM: TDX: Disable general support for MWAIT in
 guest
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Brown, Len"
	<len.brown@intel.com>
References: <20250816144436.83718-1-adrian.hunter@intel.com>
 <20250816144436.83718-2-adrian.hunter@intel.com>
 <aKMzEYR4t4Btd7kC@google.com>
 <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <136ab62e9f403ad50a7c2cb4f9196153a0a2ef7c.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU7P194CA0020.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:10:553::11) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|LV2PR11MB6071:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e48e52b-da00-4a0d-7b73-08dddef35ce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?anE0UVovUG1hWGFpTXNyejJTV29EMlo3TTJVVGlzcTZQaVlPb0F5T3NVb0tB?=
 =?utf-8?B?SDBmU2NrL1hVdUp0SkNLenh3aDJTcGFKYUh1L1dJbzNENGNPTjdDY0RTQzFk?=
 =?utf-8?B?Z2ZkdU5ERGkxYThIK3BTQWdVNG1DWm9seCtWeFJHdUQxSlFHaWhxMFlhcExu?=
 =?utf-8?B?YURzRTl0bFUrWUhUNzBaeXNSd1l4RGtoV2pmUEQzOTVHRjA5YTBFOU5ITzhv?=
 =?utf-8?B?WFVjWk1YSDF5WVBtN2lOY3FuZUdCMHNKSFFWeG9RV2NlSnIydWxYQjE4c3Fu?=
 =?utf-8?B?NVpTdjlka0ppbVBIeEkxZEQyWmNmdDVXUUNUdXk1bXU1QTlxM2tzNkRxUElE?=
 =?utf-8?B?K0xzYm5YNUNIaWxIaW5pZXE0N0JuLy8zbkF5anE0aE1oS2NHRzdnS3NPOVdK?=
 =?utf-8?B?S3J1ZjZhOEo2ODJ0QlBXa3laMWM1UWVZRkZkbGpVMStIVTY0bVBLajVNaVhH?=
 =?utf-8?B?OEdIbmZOeUQxaXVvdmtqMzJQN2pzNjZvaDdSdXA5Tm5EaHFkaTE3TnpETWhk?=
 =?utf-8?B?Tkp4WEorRFhJZ0U4QlZRYUZWdzhhN0pxcE9wL3VpcVBtMllhYjlBWXNobVlK?=
 =?utf-8?B?bi94MHRnb0FrL1lLMmpkNkN4ZmxrRC9zM1Y0YWVLeGtPaCt2bk9DWUVJejVx?=
 =?utf-8?B?Z05IVmlKd1UwNWtQQmo0aXFNdEFnMkZ6UDQ4TjI5T29YOEZZZ3d5aEZIejJV?=
 =?utf-8?B?VUsvRHBpWGFka3kzcFdsMStXdXgvbFJsR2tFYjFxdjNCM3dyTUVzQWxQY2JO?=
 =?utf-8?B?dUY2cHZ6a203bTViV0d2ajV1aEtHaDB2UWU3RTZrQnEwOHJhVEo0OVMyNy9Y?=
 =?utf-8?B?NFg3bVdXUVU0YU1hdlRLdWUyOTgzTk54emJrWmVFVUgyN0o3cHFWUVpEeEJi?=
 =?utf-8?B?Zm0vWHg1N2pCc2JNeVVMWHVwenNyeVIrclJjNGpLa3ZRSERjdVF0cXZHbG5Q?=
 =?utf-8?B?N25zTU5ieWRMVDJzV2JFWmE2U0Y5TGlmTmlFaUxMNXJjaTdqQys4Q2IwQ0tW?=
 =?utf-8?B?TVJxSGhNd2FkNnRLTG1PMCszVUZNTzFSQlUvOTVOSUNvWWNUYnRUOTdaV043?=
 =?utf-8?B?emhETnNpSFR0Z0R4TmFMRVl4K3ZTZEFFdWlOTFdTT2pTQnVpTE1lVC81RnRk?=
 =?utf-8?B?ckxudDBWR1RyenhHYk8yZGdBeGNlQnY3eEtpMUdNcHlKbnJOT0k4ZFdkc3lW?=
 =?utf-8?B?QjdHNFlSUFByNjBFWGprS3o0SGc0T1ZLdzZlWlVGV25tcVUzOUIwRXZGb3lK?=
 =?utf-8?B?Nkl0NEpTc2RRTjJ2THExcGJjajFHMTZTR1BteHZueFl6SFZuaVI2ejFLVk1T?=
 =?utf-8?B?eE16aGRLTVRXZ0FMOXE1d2dpT2p5MUhTQ3gzRFEyUzJxUGFWM290VUdWYVhL?=
 =?utf-8?B?Y0N2TXdvc3BoZUsySGZ1c2lEOFpvMjZ1cjBROGQ2Q05kWENMQkJ3VE1LYm1N?=
 =?utf-8?B?TGpWMnVRdVltcmY0TUNwWDhVb0RtTk83STNxZmdGalZ1aGRuMjRpQm93T2lN?=
 =?utf-8?B?eHZldklvQy9zYXUvTzBuRkNCd0prY1JjaVJiU0JIWjJqN1VEWVhSb0Y0dUtn?=
 =?utf-8?B?SGViM2JMRXMyL09jQjRWdFBjQzUrR2VyczFqQlRZdVp6VHJxT3BrNlNRaXRj?=
 =?utf-8?B?VEU1aGhuUHBqbzFJN2h6dElveDZCUzZGa3hKT2JaMmVOMHNmcDZRbU05NDFQ?=
 =?utf-8?B?eDJhVmR6dzYyYnpYdGNwdUtFLzVFVWt3ckcxa0I4NlJCUmtLeStHNldRMmRr?=
 =?utf-8?B?YjNSYmJMbzg0UGQ5N1AyT09YN1MzQ1l6Sk9mcnc5QjVBUXp3aW4rdmhPS3Iv?=
 =?utf-8?B?amVKV05aNDN6blVDR1QyR1E1elBVcThTZ0YvRHhucnhyMEVYWEQ1YWphL09K?=
 =?utf-8?B?bW5Ic3NXdXRKS0UwN2MzZjgrZWJhclg5ZXRVR2l1MHVaOHc9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2F0aTdhTXhHWnptR3VObjBMTTZZY283Njg3Ky9VQVQ3TUNjdEY0NElhQnJN?=
 =?utf-8?B?eXlHRU0zMGN0Q3lTTUZCYklWUHo3eGt3Zy92MzlvVWdDaVh3L1FSWWxqcVZ1?=
 =?utf-8?B?WnkzU2J2MGsxWkpjVy8zM1R4YmFaRmZ2ZG5FdUdiSDdreXNJRlhMeklFLzBX?=
 =?utf-8?B?b09JUDBrdTVDWVUxRHY2UHJBNDlMb0ZHZUtSaldnaGhWWHFmTjhSZ2R1NUsv?=
 =?utf-8?B?amxVTXFoVTUxRUxUVGFDQy9BWS9rbXp2NGdydHY3RnBVNEg1ZWVxbGhCOGVE?=
 =?utf-8?B?clRheEo5U05zNVNmeW1pVjA3ejN5dFNmV1p3WVlreTNVcFUyWHQ0ZFluWk0z?=
 =?utf-8?B?Z1dQRmh2MmpVZjIwU0RTb2FacTlIOGV4VWdENndiRkVvZnpodzZYekVMdjAz?=
 =?utf-8?B?R0RTem40MmY3ZEtFbjkvZTBGK2VUdVB1VTd1bGUyVS80MGp2QUs1R05EQ0gz?=
 =?utf-8?B?eUcrdXNFemQvOFlwT1ZTL1R3enRHWTY2d2pMSnFBUE9GLzVvUmxobkVTZDVL?=
 =?utf-8?B?TUdRdXBsdEY4ck84eVBHWG0yZUtCYy9USVJhNmdDdU1EYjlvanVpUC9pU2VS?=
 =?utf-8?B?eGg0RERJOVo3SGFoWnBZdnF4Uys1dS83NGo2UGd1R2oxUm9OYURDWC9GUHJ5?=
 =?utf-8?B?RnU2Q0RNam9hb002ZXJIZHRWQ3pRTUthZmVuaWwzazdIbGFMdlIyRU9FdEQ0?=
 =?utf-8?B?NGVUU0M0L1pqVys4ZXlEMUpGSUVETDEwU1RrTWFrRDI2eUNkZ0QyWGRBV1pL?=
 =?utf-8?B?NzlFN2JnVmNFNW9zRXBsd1QvK0Q2akYyS0hKY0hlNWQ4SnpWR29GdlBEdVFu?=
 =?utf-8?B?WXZRWFhkQ2t6cjJDd3M2cS92Z1NUdWVoeE1FeGNhb1pzMEVtVml0V1BaMDlx?=
 =?utf-8?B?V0wyU2Y3WUpIUENXRWNOZS9mMVkxQVM3MlVscmdLQ2kyK2hpZzIwalJac29U?=
 =?utf-8?B?SEs2MkZSNy9aTnhRYlBWVEVFU2R1MVF0NHZyWGtvcTVnZUcvMitabGdSeVdH?=
 =?utf-8?B?UGNKZDdPbXdITitkRmFaMGo2dWtQYTJTQzkzY0FWM1lrYllLSDNYQTJxTnRF?=
 =?utf-8?B?UTlob1ZudmpaKzJvazhiYTJwR0VjaHlLTU16amZST3BqOEVzdDVOZmF1Q3Fq?=
 =?utf-8?B?WWJydldocHhPVTBTZUZKVmVsRmJhczhzWUt6anVEYmdYeGk4OE5oV09pc3Fv?=
 =?utf-8?B?T0F1QTFxazNRcG9hR2dJZ3Z3a0V2U3ViWFRKREh5RDlkTk5Ob2lEYnhwaFB3?=
 =?utf-8?B?bkRzQnl6MGhXU001YnQ3d2YyUytrM29qOEttakV5ZmZFNzBJVXdTZnhJZkFF?=
 =?utf-8?B?VkUvV1kxSUhHYmtBeS9LWWNZZGZqck9OUnU4ZThGTUQxNEtHY2JGTGlLVUlS?=
 =?utf-8?B?TnlyOXdXQ1M5M2ZmbVYzdGkvV1EwSkVudW1DQnVnR3ZrNWRzVWloU2F2Y0ZC?=
 =?utf-8?B?TFZIK0NFV09DRnJoTVNRN3FBdGhSS0VvblBXMUNoQXlOeTNFN3lzSFBGaW9L?=
 =?utf-8?B?V21PcnlOUTZsVURGUWM2U3JmaUxJYVhjRExXQldHUVJ1Y3pUWGJiSnhScERQ?=
 =?utf-8?B?RXE5L1pLRmc1V3ArVytER2NFQXRQbFF4aGpSQkFYQ1Q3Nm4yT3FlejgrWitl?=
 =?utf-8?B?NXFDYmdCbEhXUG1hdEdscWxRQmtlRDZ6TVB0cEtZdWZuRFpPOWRRNkFkcHJ1?=
 =?utf-8?B?Q2FWYmNQU2tXcStkaGl6SjdlNG9Sck1ZcnErclRsY29aRzl6V1M4YnNHN3lm?=
 =?utf-8?B?cVFTcVhOSnhxaUhETDdLakdTRzZ1YWtJSEMvTUhhWENtNVNScHVOcE5lbmhj?=
 =?utf-8?B?cmNxNWNnLzA2U1Vwamh4VWdKZE1yK0ZmL1RKeWpxSGlaOWQ0REd0TzNQMjJ5?=
 =?utf-8?B?K0x0bGFWOHhidUtkQjJPQmtuc0JDTVBCMG5OTEpzeldaNGpxS1JKOFIxVW16?=
 =?utf-8?B?WVRWTElya0hjUmIxWjc0NndwV1FaZXR5ZUgxQ0cxbXNYVkI2VGJQcDBNa1oy?=
 =?utf-8?B?RHh4ckgwNHBBMzRid1pSNGJhQUo2YWJMQWZYZ0xWMjU5Sy9qZkd1OHRTMUFv?=
 =?utf-8?B?d0k2ZXlES0FZRGhPcFRxK2hrejZ4QTBGRk9EYTB0YUdvUnVkMHFoTC9heVJt?=
 =?utf-8?B?d21ZZGpIWlhOVEpuT3ZQUGZzS0o2cWNQRnFnVHFLMWM4MGN5ai9icyttemY0?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e48e52b-da00-4a0d-7b73-08dddef35ce5
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 07:38:17.5747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEkiqjuD4B4czikiF7jM1GCjtTo0JbuIp1arSQvOD0j7AaTBLzEu/VgzwG1VJQZdFF9/vtnrI2n6fbCinlEWOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB6071
X-OriginatorOrg: intel.com

On 18/08/2025 21:49, Edgecombe, Rick P wrote:
> Attn: Binbin, Xiaoyao
> 
> On Mon, 2025-08-18 at 07:05 -0700, Sean Christopherson wrote:
>> NAK.
>>
>> Fix the guest, or wherever else in the pile there are issues.  KVM is NOT carrying
>> hack-a-fixes to workaround buggy software/firmware.  Been there, done that.
> 
> Yes, I would have thought we should have at least had a TDX module change option
> for this.

That would not help with existing TDX Modules, and would possibly require
a guest opt-in, which would not help with existing guests.  Hence, to start
with disabling the feature first, and look for another solution second.

In the MWAIT case, Sean has rejected supporting MSR_PKG_CST_CONFIG_CONTROL
even for VMX, because it is an optional MSR, so altering intel_idle is
being proposed.

> 
> But side topic. We have an existing arch TODO around creating some guidelines
> around how CPUID bit configuration should evolve.
> 
> A new directly configurable CPUID bit that affects host state is an obvious no-
> no. But how about a directly configurable bit that can't hurt the host, but
> requires host changes to virtualize in an x86 arch compliant way? (not quite
> like this MWAIT case)

It is still "new stuff that breaks old stuff" which is generally
"just don't do that".


