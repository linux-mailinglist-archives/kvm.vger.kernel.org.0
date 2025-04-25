Return-Path: <kvm+bounces-44254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C281AA9BFA8
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 09:21:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B36DA3AA831
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 07:20:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2233322F169;
	Fri, 25 Apr 2025 07:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSn1Rv1o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BBD1E86E;
	Fri, 25 Apr 2025 07:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745565665; cv=fail; b=aHEHoHaShf7sYNfuDvJUV+tkFWYx8+A6PRzlrJusnILXjKku/58kEroRmmaZWY6HPie5BWyHPXOFvuu8Pvx6kCg0Fe5rN0xasNjwMIk0HQ3xEZj6Wq2a4rZb22vLpEf4YCCksrNRySz46FUionbCByy2c2JY1nQbepNfjEB8xXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745565665; c=relaxed/simple;
	bh=+eI6AxSldOrytjLdf/pEJI2OACepnBSinNsLJ8ntfc0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=X6pyE6I6gGst9RyGWyY4oYK4VoK31TbWdrf3+Nrz5heQ5aZlvHZFac+aQYF9NGcleOUZvcRLWnc6RQ+7aOaZMsCImrIdkNzanDFrGf9MHdxGfiuZuMytq+SHdBkYHm9Zww6Brd3XQstZzntr3JKCXiDd4MSqp9RvgbIKA53OpTQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSn1Rv1o; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745565663; x=1777101663;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=+eI6AxSldOrytjLdf/pEJI2OACepnBSinNsLJ8ntfc0=;
  b=SSn1Rv1ox+CVgKjEHS7cOwlakMgSkQaN+zsXKoCQ7eSyuIkpcVTUvuic
   lG1vlQL28tbA5wa2Ipx1vocfngWRbVrn0bcC4bjGCN3PUF/j9krUxeIQP
   ubkgk0EixSW6sLv3wMIiXt+Y5kpbuwtP6YdCgqYey4zzzYp6UxZKlO2sA
   gBGlFA+hSzGPGlrZzNZ4X5dDT3L4SkCQvxqPTLDHtcOXHKVsum7mlVxjt
   2w8V0Xg3kaxoQLmv961mO0PcD65WmoCQ+v1Muyz1tgrhSEBoMCZAcY3C7
   Qqz8Rkx1zcWCNNTXLCBjfLx7jDjRJLJMsawKVNbMGSBhGtFj1DeBuX4c5
   A==;
X-CSE-ConnectionGUID: T1d4uY61RriAkypguEgL8w==
X-CSE-MsgGUID: EvQ1wJr0SeyuDst7dlVtFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11413"; a="51041725"
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="51041725"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:21:02 -0700
X-CSE-ConnectionGUID: ABDdqWksTAyPY/Ark0SvIw==
X-CSE-MsgGUID: rBi+54kpTIWMw+EIa1VOLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,238,1739865600"; 
   d="scan'208";a="133364283"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 00:21:01 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 25 Apr 2025 00:21:01 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 25 Apr 2025 00:21:01 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 25 Apr 2025 00:21:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o3E4ZX46GtjsWuAkC+QhIYB1Ks2FFH9JJkS0Njx01tw+KyLP/m4/s99JqlhTWrdE7uHTbYSLEvgOXX61qSRT0cCeXcHkSVoMZva02ElOJo9vqcBIM/EHmJQ6y/7/qKZFRVDJBCjXY8in/Iy+KgrwbzjwhlOOn9kktc/P5tgqbCxH63HEGaD9/lDMf5LPOKBAKQK1W6x7tPrn0cxiQ0vthaBNKVEBnmvPp91zsbFUN9ZHz7GY+5NrENER4dEB8NcA9uIinbQIrY7c3f/eHHoK5We+r5oyEOLCTUT9s+Nsm4YqopPxQ5gbMZlkSS4Jb7fj+BJW35NT+vsyHfLxk41BQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nf8TQgWCc1Uw5v9W62IRqK7NwvYE11B3hwzHE/AfJqs=;
 b=l/N4SBdmcEwMhIDcqTeVUMgNtvRQbzevhkD+DvC0W8Vtqz6bkhMZqWXLzCC69GbVuof5kQ/ygO/OgB0sRAl7+r6b+29KV3O6DTdxGPcTddIdPtLZxPscu+4GkB0RO2mizZdcNcyGYkIk2D/5Vi63kAY8o/K3Cd/Tjtck/9R/2REzwKutHywxYk3e8tJIbAuHm5UOBocW0pG6btH6UxPIDfe0asShYrQk9t5nfilpnswte/nm+I5H/USWm+m/3HmbqlO4Ljb+zhymKxrBEQn0Dr05x49u1Fae6BvXAqGGgzSMRYPLHsFhjkvYguH+hpTStjxFDJHILWfg18bsRmWDlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH3PR11MB7202.namprd11.prod.outlook.com (2603:10b6:610:142::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.26; Fri, 25 Apr
 2025 07:20:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.025; Fri, 25 Apr 2025
 07:20:57 +0000
Date: Fri, 25 Apr 2025 15:19:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aAs3ZPJAQR89XORB@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <a7d0988d-037c-454f-bc6b-57e71b357488@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a7d0988d-037c-454f-bc6b-57e71b357488@linux.intel.com>
X-ClientProxiedBy: SI1PR02CA0008.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH3PR11MB7202:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a0eaaf-c43a-4b15-5ad1-08dd83c9b8f7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?u15sT9NTR0lS5Mik7VAoAd5xh1C0WHZ/e0ikJdmYFdmergoDRNLMx9Exi0?=
 =?iso-8859-1?Q?2WROziGkiwIUo5hX6QXF4iNpyF6OA/Ff42i6h2pSqbspYmbFB3JEvFCW69?=
 =?iso-8859-1?Q?RQ3t7gSG15FGXzNHSIpqDrL4vayHM/va6DXTtBMV/1Z5Q+R4gufahz1k/N?=
 =?iso-8859-1?Q?PvIW3blzaJ2elybi4GAfNjdO1Rq5Wjx1GQ3XU4tQzcUGcAHVa7UD6jU5xL?=
 =?iso-8859-1?Q?dKb9VLp26sKbLX0fJqN7kqUP6WuoR/PFE+NtII5hgweX0nPmf7R2qYqSAZ?=
 =?iso-8859-1?Q?8c8z8oLBb+1rfpm38kmQXChfKJY7Bije2NdTjCXeTVMk2pqhx4tCoBwMdb?=
 =?iso-8859-1?Q?lMQM1zZDeHTkyrwtB1jTDW24oVXeOuGP24XOaq+O2Rt3RECic4hR2h8XAC?=
 =?iso-8859-1?Q?2kxZ2HVv3OS2PmFLzd3MDl4THYlOcWpcNGdt/pfmPqlvBXqpSRH9FWUrpb?=
 =?iso-8859-1?Q?i8DHbevajS9qcrZXRr8E5CKPeuVuzOlVelWtO4/m16RoTsJFAOVBl0WWzL?=
 =?iso-8859-1?Q?X9zxXalzDVIkn4OvR4+El/vpoE89fkmcmug7da+REQcajOeiKrGRiJVwJX?=
 =?iso-8859-1?Q?NOhpPWpkRy6zgz3zFELp/KBqRlA7CRzfZ5rkeO27SFqDdo/PybScm8VZWo?=
 =?iso-8859-1?Q?V7usWxduah9h7eoIPxNcS51X1ToouMhVsaPzBhwLd/3GP9qGKvr+79kEp3?=
 =?iso-8859-1?Q?lHaPLGkmmAV3O07TEQOROY5Rs/wSce8XGwoe9tp4fQDEpM0ejAo6IncZdB?=
 =?iso-8859-1?Q?dqw4N8zhkF3waPVsOyZOZL/9EbEoQ4EITi0OO5KGEL9xsuMpIsXOnG+ekx?=
 =?iso-8859-1?Q?oqakZ5jcMfJmburdIyC0PAytIUn3LX+6A3t8YBdx1naXz7wKnIgITm/l61?=
 =?iso-8859-1?Q?We/MOV+F4VPFxualaN/ozExWPMxo//hBjNbLtJ7hp9HNnCdd4vOLX+t4nF?=
 =?iso-8859-1?Q?oYqbalDI3GC3HATSS0GOCCcScRyeJ1RQPc9c7kRHyoQtFd6M1BJAduWb5k?=
 =?iso-8859-1?Q?qdME0LntVR3x3A9dT6vHxp0fK8cBCFS7LciXfJO+LZXILpqAW0vjDKhw1R?=
 =?iso-8859-1?Q?BVmB1/Us4Qb0tYgVUs2W9ObTxjTjVsFItllLlD3oIiFqNia7Qx+O/8ZCG9?=
 =?iso-8859-1?Q?hIv1R9Ux605Z/mBG6tliTZ7XeVWA7IEWTPFV2/k2m7qkFcokKPHK8yZosk?=
 =?iso-8859-1?Q?BWXGcXftb/QmQkjOKWXBakS2aQoDnyQP7YZVwTfiKqVBpPJ6hHe61apg0O?=
 =?iso-8859-1?Q?brHQoRJRUT2tX0mOICrEO2ZBZfGY79+RiDrZaDwBZjZX622zZAhTLOHrLj?=
 =?iso-8859-1?Q?9MATBtPprEpEF4RKBb5/IN97f2n7PucvAtzE7OqfJvPPPirwf5rIc0N1VA?=
 =?iso-8859-1?Q?LRXd4GQUmgrzaEl1YhwY5IybVYnbKTbsmrxZlDcx4t7jDi9iHZ/LbntRpx?=
 =?iso-8859-1?Q?pR9Hr5ukQsob6lzAnIumn1AcZ8JjWbaB9mKKSTbK0yqmO0C71BNcjml9q/?=
 =?iso-8859-1?Q?A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/Je6o8W0mhf1Y4HtiY5fhwgKUKQ1XsO6A+W5WtJnfwkClxJ+tdgfpf0YEE?=
 =?iso-8859-1?Q?EyIs+G0A7F8LWTZrOA5f/DoySnHAas/WR3qV1pOJT3OI+UQSP8sWU/SmEA?=
 =?iso-8859-1?Q?bGBUMe10WEfWAIpe2y6XWfZRogp5vQOWotEqWzSoX7UktKtjLxQQQ/Xbfa?=
 =?iso-8859-1?Q?ZyeZ3ORUvPAUc1Q5vZECgamVxjTJkzizryaAl7pAfcF5Z8E0oeC9YhixNv?=
 =?iso-8859-1?Q?enwP1Xyrmad1dDNUq8kY8+rENRWJXXtKhWdxMwGD7Niak+gYn+8amOG+/v?=
 =?iso-8859-1?Q?RQvUB1oOwUWNBexNplTas0AoPPTfUNDJLqg6E/lNp9AmYGW8jQH+Du57DS?=
 =?iso-8859-1?Q?1Raqzz8LJogC+zpjMeO9hiYsbxwl5bJADzLggX+Yz6wJWjHLaIex2uY4Yy?=
 =?iso-8859-1?Q?wWZOsEkHh+jtGXWcamMeglz8Doe+PqM2JnEokhCzroLIj86ZOuO5Fbf6RO?=
 =?iso-8859-1?Q?9KTbpIBpgcwZgAdC3LvLxaK3wXa2o1GyG9/XncjxE2KIUThAmCrJGPsvXq?=
 =?iso-8859-1?Q?79DBTKoSFLm8SWMVFZFh0ItfpDyd/guKxnAOfQaziGnx2m8X6UOE50bsbq?=
 =?iso-8859-1?Q?l5Ox8gxIIyG3ta2+b21ED7xT4YCgw1Ep0H0c9Nm7y1OK8gM+cGej03ahaE?=
 =?iso-8859-1?Q?S9bY3H9ZpH21Tjd2SwoWAXAjr7ZGAuxH6BWefn7XHajjxDmvCW3MI8AJgI?=
 =?iso-8859-1?Q?JTTkSQh2t5v9/6sOnkOVwvVyIA2v+q3HIAOiVNk3UzdJdvHBkbsDYWeKPY?=
 =?iso-8859-1?Q?bejxEyCzLc/RbxH5L38uVnqiyFuEEahqC2v+LwkG1ZeqPy5BaIwCwzjnfR?=
 =?iso-8859-1?Q?aDyiTgT66gJ8Hm796nTIJqUBnyCv/9mbeFm3tpUdX4XTEQRzNf/a0jYokS?=
 =?iso-8859-1?Q?uorFJpaC7iqz7RWRxYXsWD6+IzNXm67bWRqPyoKOQYHR4sAd1cuIoWre2G?=
 =?iso-8859-1?Q?KEspaBZBOLCoD8WPzwSh/kPgUvW0x+p1Bd+dUotJ6cCldJvDWuUXm4jTf5?=
 =?iso-8859-1?Q?odcLozkrhjyC1UARRZaMve8FQhv+DepInsbho68Y0Qcuth4cIUZuifI4tO?=
 =?iso-8859-1?Q?qB6h26G6oHYS3vmz3pVI2MjJ/Zk6vs+Qyt6T2GS4nZl5pkGRdbB0id3k9h?=
 =?iso-8859-1?Q?ZOx0lg+C29DLdamlgfJC3JIXYRPc2uY+ZLDuzwf2X3JarkhMjyCjbviN8F?=
 =?iso-8859-1?Q?RR6pV6rv9cngzrOisB6PXNvpS3Cnz7aq8/nF9k6NL791Ud6tDQJCbc/GRT?=
 =?iso-8859-1?Q?B4pLUoHjVnQHF7vzVds0i/ShDu/gcnFaRnwlSyVR2GZnm5GEX8lnIIpXYl?=
 =?iso-8859-1?Q?aviIXsyO8FnlimqMamk2JRL9pWYdiNjflI32j2Kneq1XoFSLrMXvjjovbM?=
 =?iso-8859-1?Q?hqbTFCr032P7g5MsuSUjI20q1BZySalgnIdVw8qkiRwGl8JuxP5HPzpNaz?=
 =?iso-8859-1?Q?jdgKyAlAGdV0yV5FwL4KfQwAJ1+nfrWQpB/l7GEST/1XmXfXg9Ei8s43km?=
 =?iso-8859-1?Q?Wuu38aD47nv8YNXQUJRgBJOrCLsY/pWiUvSKpe9m0xRLD+Yripc5WHvdva?=
 =?iso-8859-1?Q?mETq/3EHJPgOi6BJP5cKf1C6mOlBJ7yXjyIsZe8a8x35qHCx/bSOBxHXfJ?=
 =?iso-8859-1?Q?lJkJysGRkn8/8WQT37t21XAx1qt4vmKeIFaJMPUET1uGVVm69EhBFHKw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a0eaaf-c43a-4b15-5ad1-08dd83c9b8f7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2025 07:20:57.4718
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoiMQWQTDgIbThANjWQ7FpeGRFyARb2MOxqeF7Te9ndvgZRuzMfvgLKzLsv9HAN2hqIEn9pSpiQn/h9PJjNYyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7202
X-OriginatorOrg: intel.com

On Fri, Apr 25, 2025 at 02:51:18PM +0800, Binbin Wu wrote:
> 
> 
> On 4/24/2025 11:04 AM, Yan Zhao wrote:
> > Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> > 
> > Verify the validity of the level and ensure that the mapping range is fully
> > contained within the page folio.
> > 
> > As a conservative solution, perform CLFLUSH on all pages to be mapped into
> > the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
> > dirty cache lines do not write back later and clobber TD memory.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >   arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index f5e2a937c1e7..a66d501b5677 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
> >   		.rdx = tdx_tdr_pa(td),
> >   		.r8 = page_to_phys(page),
> >   	};
> > +	unsigned long nr_pages = 1 << (level * 9);
> > +	struct folio *folio = page_folio(page);
> > +	unsigned long idx = 0;
> >   	u64 ret;
> > -	tdx_clflush_page(page);
> > +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
> > +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> > +		return -EINVAL;
> > +
> > +	while (nr_pages--)
> > +		tdx_clflush_page(nth_page(page, idx++));
> Is the following better to save a variable?
> 
> while (nr_pages)
>     tdx_clflush_page(nth_page(page, --nr_pages));

Looks better except performing the clflush in reverse order :)

> 
> > +
> >   	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
> >   	*ext_err1 = args.rcx;
> 

