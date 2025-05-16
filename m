Return-Path: <kvm+bounces-46752-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E18AB93E9
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 04:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14F403A54C3
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 02:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40E0D2253FC;
	Fri, 16 May 2025 02:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GL2mowth"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D3B20E31B;
	Fri, 16 May 2025 02:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747361107; cv=fail; b=HHYZIOMGt9bTNOR+N/UsxyxcqQUspRGhTfNXbP2x5YrWD1LsX3k1x1hH3bIyEnAUzbUl8/LJumGUg4wX6BkkbB2t3bz9ks5VcfmEJBhT2lehF4+i+6dYieYdXreRFR5avVaVaMMMb3Knhv0eLSO30TLCGGbcjN5KIfzcCivW898=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747361107; c=relaxed/simple;
	bh=7nwFqJd1uhuk9u+FmQ/axPegwWqnDxqyqI40iFOaXa0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=aShGFqgIBZCLoxtrWFrMQ4n8n1G8H9n7r78S2E8E8PISU4mzegoXoaplOFpUYzJ5mKIXNPIDqfb+/dcZdpyy4kKlf1B++7hArUP3N7P2lgeuqFdUNiq9tGpvBMPRQFv3L7i11UDLBpHU+SaY67BwVJRXdQxHlMaAek0pZd6MGrY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GL2mowth; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747361106; x=1778897106;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=7nwFqJd1uhuk9u+FmQ/axPegwWqnDxqyqI40iFOaXa0=;
  b=GL2mowth9CUTiHuDUFVi68BtI5PKqmQX5BwwJ//zGrb9kZx1IOkCDze/
   TsfErobM+fl3TZwpLBUoaMXmEKY0uyx+ortNL+NE96eO1J3e4J6qD6c/J
   Ap4ZnObOwVIbj5QEN295jOLH4PVgzwQdLXp64WrgzSao1OqmvzclvAtRE
   /+23V0clGeRMmUdjCWe696kquudmiPOZWS8yx8qUWlR3JT7AX4jq5r3zj
   2dWXscxpSKw4121ScGHTOKXR7dwTikW5pD4dsl6Wqt6fnBh9cwF4M6C0F
   dBqbmFxxLJnFM5VjDtjOm25Tc1MY/JBEpOzmx+swjsGzFEBLklbWmOgAV
   Q==;
X-CSE-ConnectionGUID: a/fJ7XqCRI2MX1J7HeLfHw==
X-CSE-MsgGUID: PMQd9c+NTvK10EbllYbL9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49480619"
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="49480619"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 19:05:05 -0700
X-CSE-ConnectionGUID: xULW4oMSTFqm9Klsy54bmA==
X-CSE-MsgGUID: 8H/I9qeNQqyaXdZCpBaJ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,292,1739865600"; 
   d="scan'208";a="161853813"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 19:05:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 19:05:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 19:05:01 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 19:04:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hjc24ymgoXOB9p+wyKdkNkrUZ9/xVnBbhOyS7LdIS78l4z+vzigOX/nX4er9V3BM3XNUXzna0NmHLiGWo1GgU8x02U+0731qRxEfZbi1COztUR2ibGFcu47rnS1Kpk+qzz3Jt9doZrojlWBO3Bjuy9iFyGCwPGIveG812lAm6262nJuY5rydd2Ped0z1ZIChupoiM6KhtJiiQxz+L3hB99fP6iXRGUe2pTJpfIsfo8+ggy46EtwtiMBDpu9RxU4t7Njkfat3HnC/gKNfqhFCMUetEMgvA40v2A73cBi+d7ea9Esm3Zqm2V4iPeKgOPqwMbVOpjEFPoHf9+qYtQCziQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUhWTyiBFrNXmuQjccjLW8b2JLwK1gFaDzfrXM/W0l8=;
 b=RPHtQkpibXzEwMtmw7Iz7OUr/BbKM56PCvjc5dD+plCwB9Oyaw7q9FzC6+TcLyx6KK/aWoPdELBovmuxKNzqc02Mz7HvWJ6LtLCaC6MeDvWwbTJ/J9HitU9xdXMNtsB0CYjluPdXn+IBY4qnwsEZX9r0r+AoLcRBbOEzX83VVV4R0Ktt7/F0fJK9Ki0cceF+iSmPVqcgs5vpZ66XAuTdnvw5UHLHiJeSstO0oDt0+66SUkDEtv+7o5vxX63ViQ933iibODzykWV7+dxFCpip2Wl4SL6k2d2Q2IfSGIj5sWbMN+qtGO9RYcG9RlYPYRYuGXdV+pLwHQS53ThjeS4T+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 LV3PR11MB8601.namprd11.prod.outlook.com (2603:10b6:408:1b8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.33; Fri, 16 May 2025 02:04:45 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 02:04:45 +0000
Date: Fri, 16 May 2025 10:02:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
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
Subject: Re: [RFC PATCH 05/21] KVM: TDX: Enhance tdx_clear_page() to support
 huge pages
Message-ID: <aCacu2KrpJ/85Ezn@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030516.32740-1-yan.y.zhao@intel.com>
 <6e9d7b566e7e67699b012ae84d83f36de32098a5.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6e9d7b566e7e67699b012ae84d83f36de32098a5.camel@intel.com>
X-ClientProxiedBy: KU1PR03CA0043.apcprd03.prod.outlook.com
 (2603:1096:802:19::31) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|LV3PR11MB8601:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c14efa-7348-4b32-81fc-08dd941e075e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8IQZ0J7IgI6Co7Pt57Kps9hYQLgABefJULYBHCnvI1K6lGsMTPlypwQBO3aZ?=
 =?us-ascii?Q?ukYpqO6FU39PZHg6XCWjoSgBUvLC6sUIIx3xOPv8DO2qAziCnNA9pDTjj1d8?=
 =?us-ascii?Q?3yTeuD80b7vRhvg0E0IH2s3VjteqJV2m2GVmjpqrbPMAZ114qqnjGaWoc8PW?=
 =?us-ascii?Q?I3FBiAm7H8NhAtUeYn2oFTHm6+ebvrNIlR192snuLobH4ABubSdZsCuETlUn?=
 =?us-ascii?Q?wx0xqkAFjMLqYj+3QKdWS+939SmTLEFKy43nWkTL3DMk/RIz1vBZEQpxx6fU?=
 =?us-ascii?Q?pyLXYYLGjpuJv+03DYMlicr684MfBtSX+Ef1t7uabSOrqO5/XayoxHmr6nNd?=
 =?us-ascii?Q?4jxKJXBr1WbCjGqmfJ+0gLvK02d6BX3KaO6RtqHQN71ncH/IkOdG+TWsg1G6?=
 =?us-ascii?Q?LqjgDcdKoGeVTcXkuOSAwbRAZv6tLIn10c8kNSJFLBwsMY2gknSnJzrTLCLb?=
 =?us-ascii?Q?UZt6lh7vxTiE77GS+U4Ek3uaS3Wq+B6uy/pXsoQ4dg2iu8NSivz7YbsTQovu?=
 =?us-ascii?Q?JNXO0IEqLq2ZHycyXCvFgTfO7hKL5KGAEHCqhqzLZProYNKeIBkojY8eMnE8?=
 =?us-ascii?Q?/go3aTdKl2nT9WPPj8nGbYeGBNdxD6bmLxuhXOSWEeLNR2q3ZT7PlN8v8BBZ?=
 =?us-ascii?Q?YJjbHgufKPg0qQ0HRdahl2t2n4YUPOPWDaAjxxF3VKAEFoOv51IoOKURx/9p?=
 =?us-ascii?Q?RgAo3D7fWKaZ838w9CbWsvOyGO7imjw5TVPioj2NYtEdntlApf+QQwen3/do?=
 =?us-ascii?Q?M+GceAmJdA2vSJx0aiMQ/1TprxnoR/87f/3KYfaEOdYQHxrdhGAdcr1CR196?=
 =?us-ascii?Q?gwUEbLaiMr+pfbqwzgP1OIID9Sm7RlL0mzoDF1ybhynMmHyN/gS6J++jkOaV?=
 =?us-ascii?Q?KGCo11l9D8q3u9Uv3F65EynpmBK4CvPmrFTHRkcRxhPCn4T4yhUvS1PyLpZy?=
 =?us-ascii?Q?bFVmPXiQAjyNcbBfhgYjJIMA1frkTIDp3Wv6AtqCguR6EKyZ6ZDHLFE+aI5Y?=
 =?us-ascii?Q?jS++Wy57Yv+7T2MzLgjCmMTOdAuHhpZFq+ztSpZCic+lr58nznDy/VSaZYrl?=
 =?us-ascii?Q?7GkzDqqrtD3m8cXJkV3CEF2HxtBcw9guQ7zHVxzqLYS+RuK86xnPwJLodz3m?=
 =?us-ascii?Q?Hip1EwQE5kvDz8/ZMJbcvzlh7V5wVxWwCYDfzMqEmkUzEsax8nXM3J3d+EfS?=
 =?us-ascii?Q?vc4yJzqNgsKg3XePZh85jyN8SAmUccSkFcSlOaXR74xcPDDNoLtwSnrZmX7A?=
 =?us-ascii?Q?ZZTODNEQm+l6Da3xQsHphsyEjoQI5KP7VxP3D5G6u3oH5wLp09ShmilQRvJL?=
 =?us-ascii?Q?o5NWI+91S1haKb8SQ7fnQr8c/L78+SKbwxOrw+weMRzTXGkhZYStW0tRbyOW?=
 =?us-ascii?Q?D19TEOIJMigCjsKqcx8U5TW/8mBgCJYr+tmbUMV7yqMgWyD4lzd/XSat8VyZ?=
 =?us-ascii?Q?DiWAzfxF248=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ypfQ6myOzKDRT/GXOys2dCYIrmVovIjKoyDo/zxnYCRE8XpZY7D1M90E4yP6?=
 =?us-ascii?Q?ZYGNli43iWeTpInSugJZF1VvoLXrvqSwSdu8F5rNOh+RMmPjj2EIhmHj23Rq?=
 =?us-ascii?Q?bBGEWfIYKwnlKfn+YZAAiaaLzAPvg+Z7id+69gP3xL9dy08HgQqeVLv1Mv2X?=
 =?us-ascii?Q?bQ1eHy3plx+j5l5Q/EMrpKuTdKlzCh4bmBSD3iDOzeArZEgb0Qt0kk2Vr9Sz?=
 =?us-ascii?Q?XLqirqTCIyPp9Cr8hsJfH6xKKghF46EFl0wC5HOXZqqrrQRUtQv5bR1eC3uH?=
 =?us-ascii?Q?sNyW8c0llijLMye2VUGr2ViWzOUtqItJsJRxXDguC2tbSKGJjnGvKcpTf/qL?=
 =?us-ascii?Q?d9Ra5D6y9IX1f/P7ZxEvOOAHQVRUqJBfBNbHNEJpVWgy6DmNEEZfJhAKQFPo?=
 =?us-ascii?Q?EbTG51GDUI7oMq8uMpVscr9IV+/XoujjUz2NwtNvd3vV9Sq+LP/e2+31E2Yg?=
 =?us-ascii?Q?enY3UgWZYU5csKZNXlRhQtTbUDGFH2DqvytxYUeiHX4VShI9jinAHOaelkqX?=
 =?us-ascii?Q?OwcEAoMugsm7ZkvhynSN0pGaQq/QigrKQ0x+Egji9nyvkPTb2PeEg4cKeTRa?=
 =?us-ascii?Q?HB7PxKaU7Wmz4FBxmCPRNrwTKsciNmFajRt9EwGEevg3n+ci+BhWVPGTh9oe?=
 =?us-ascii?Q?0gvtnAfFXCNQG8dZCPqVQ8UudAVxY9lr2sCBq4x3uUz8U7KsDdif95mfP8io?=
 =?us-ascii?Q?Y3ASc6b2rbw13/Rvc6Y2WrV8Dxr3vF0MU23aV7dmzea9obhlof334oOV6BH5?=
 =?us-ascii?Q?yNkB91d+nEw7e943NKqZrzbMNZ0/02PA3gu+CbXwFKLdaUh9OhvyjhFfg2j7?=
 =?us-ascii?Q?PXCnERTz1TbNY0+zsMrgGVxFL951upk6NakoNsaL0BH700cOvzh8iMkWPaVy?=
 =?us-ascii?Q?Tdamwefc4KhuT4PiwvGUL4QPjK4myLXIMsgORnLWx2+wwyeCjzbEkKMPDcwA?=
 =?us-ascii?Q?EeaGPiLllfwjkJaOtjYjt/krOFyYmJ4hRe2RHecFsagl9FFThDr/n8cNHWXv?=
 =?us-ascii?Q?mil+Vm4IGNfcYJSnQWfVWtLsXRJWZ9LMDyzEzcrCk6GUTzkg7liRXrVRE2JB?=
 =?us-ascii?Q?nnvoCqrFfcfBdIt+cv41sXBnhJZx7u9BtZjYbdsjYSCfzaVfaJdTt7A724uK?=
 =?us-ascii?Q?UfLK1WkxYwlO4ALNheS5as9yWBRVMzJqjW5qYDfSTAh6xiQ7L833HiCy/v6e?=
 =?us-ascii?Q?zu+i1zwujWrOIFFpy0itQRMBT0NasAmlIBhTEi2rcc9n3cTs+0+sBrWUpqad?=
 =?us-ascii?Q?MOuDRrOUtauGOUEpXegiCeNc5fZDNo/4oMyU6/VX7QLByd/0acrLXoz5elXe?=
 =?us-ascii?Q?eha0x/3GyG6Tov3vvUbhlxZXEiu+UHAGs9Q+pcn/70V1ww+WMbSy5HnH2krd?=
 =?us-ascii?Q?Mnb9awcNlqOCbDSBWu8lL+4CVox3FFOQMt4CrzpKl/O8FHV6/w3T/80IUVIb?=
 =?us-ascii?Q?4T/w60IVDTQe27mH89uli3l87etDU89hAD2K/RNRvEkE44XblMp1hwozctFc?=
 =?us-ascii?Q?nTgZHtSnHnmKRDtsc53ChzXwqYdAeu43MpOm5ZWK2beHVBVljnTW12FM0QHf?=
 =?us-ascii?Q?GzuZNKk0/vpInu5hFqTk28vi96c05zUCVcU7KFIu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c14efa-7348-4b32-81fc-08dd941e075e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 02:04:45.1833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GgnTqQotHt+bOn8z0TkT+nPHGlPQ9PaRzw4TpSc3TfSitsHYa4uFUruSk/LPBjirkqhb1dOwKoRqvopNwDtfQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8601
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 03:17:40AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:05 +0800, Yan Zhao wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > KVM invokes tdx_clear_page() to zero pages using movdir64b().
> > Include level information to enable tdx_clear_page() to zero a huge page.
> > 
> > [Yan: split out, let tdx_clear_page() accept level]
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 03885cb2869b..1186085795ac 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -276,7 +276,7 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
> >  	vcpu->cpu = -1;
> >  }
> >  
> > -static void tdx_clear_page(struct page *page)
> > +static void __tdx_clear_page(struct page *page)
> >  {
> >  	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
> >  	void *dest = page_to_virt(page);
> > @@ -295,6 +295,15 @@ static void tdx_clear_page(struct page *page)
> >  	__mb();
> >  }
> >  
> > +static void tdx_clear_page(struct page *page, int level)
> > +{
> > +	unsigned long nr = KVM_PAGES_PER_HPAGE(level);
> > +	unsigned long idx = 0;
> > +
> > +	while (nr--)
> > +		__tdx_clear_page(nth_page(page, idx++));
> 
> You shouldn't need both idx and nr.
> 
> > +}
> 
> Since tdx_clear_page() has a __mb(), it is probably worth checking that this
> generates efficient code, considering the loops within loops pattern.
The concern makes sense!

Will convert level to size and use "for (i = 0; i < size; i += 64)" for
movdir64b().

> > +
> >  static void tdx_no_vcpus_enter_start(struct kvm *kvm)
> >  {
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > @@ -340,11 +349,10 @@ static int tdx_reclaim_page(struct page *page)
> >  
> >  	r = __tdx_reclaim_page(page);
> >  	if (!r)
> > -		tdx_clear_page(page);
> > +		tdx_clear_page(page, PG_LEVEL_4K);
> >  	return r;
> >  }
> >  
> > -
> >  /*
> >   * Reclaim the TD control page(s) which are crypto-protected by TDX guest's
> >   * private KeyID.  Assume the cache associated with the TDX private KeyID has
> > @@ -588,7 +596,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
> >  		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> >  		return;
> >  	}
> > -	tdx_clear_page(kvm_tdx->td.tdr_page);
> > +	tdx_clear_page(kvm_tdx->td.tdr_page, PG_LEVEL_4K);
> 
> Why not the __tdx_clear_page() variant? The patch adds it, but doesn't really
> use it. Just implement it all in tdx_clear_page() then.
Ok.

> >  
> >  	__free_page(kvm_tdx->td.tdr_page);
> >  	kvm_tdx->td.tdr_page = NULL;
> > @@ -1621,7 +1629,8 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >  		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
> >  		return -EIO;
> >  	}
> > -	tdx_clear_page(page);
> > +
> > +	tdx_clear_page(page, level);
> >  	tdx_unpin(kvm, page);
> >  	return 0;
> >  }
> 

