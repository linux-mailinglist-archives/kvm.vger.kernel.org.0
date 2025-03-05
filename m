Return-Path: <kvm+bounces-40124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF11FA4F555
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 04:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D8093AAA42
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 03:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F60F16CD1D;
	Wed,  5 Mar 2025 03:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EytFG4x1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4DC41A8F;
	Wed,  5 Mar 2025 03:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741145130; cv=fail; b=f+vu4+sfUIxgSLfyJ1ytJ6q/gpiZgXXXgPjeLGtE6NVnlPgNDqX5xc6JCuSUdtGlGihwBZqUhL/kK0ElxCYssrwIw8IETnF4d5XKYtz4uAdLo/dA33fO8J2eDjS1YdfwoYkUyLIJXj/m6jBKBMWV/iywCobA0ucHFmuSVAxMh6k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741145130; c=relaxed/simple;
	bh=da0dqDVFoi/HVOBttSl+CHqWPHcYLgZquHcCq+2qQ4M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JQWAptd9tQ8JzJbE0SL4e9+NSJ+OelBavk6i0HhdliZWAH2HrMOcTb8upDWnpmfgqYOc1vLmS8NetNTMorBYXl8vgNoefm/NYaok5LB+b+2hCUR9lUvOP0Nj+HofVlvxp0KjnhWvkv3BZzozC23OsdR7lVmC9/cPEtMenQxE+Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EytFG4x1; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741145129; x=1772681129;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=da0dqDVFoi/HVOBttSl+CHqWPHcYLgZquHcCq+2qQ4M=;
  b=EytFG4x11M5Cy9azl7nWq9wAm82mZMc9x3RLnor1zke9feUFc25MaxF/
   ZILg3TBdWJXbjVe6dHSghtCJzy750JL0rOr5K+87VZmYqiuRA28A3J/ET
   u+cY/0BNvSHOyUEN2KIkY1M5dJ3QhHxbZJ4WLtceImbU9k5cwFgnQZfGb
   vzjiEXvxj1VLa2ZUNXK0UQx/snH8b9Ozjd1D4dw0aEX6FYBeIiFV+eW5o
   tgkUbdfPBkm5/YPxqVa3IHapm6c26jt35dsNy/4qS8CCG9AO5Lo3nID2z
   ndjieAB2rRyv1eF/wwY7SyQ3vdZ4ojkOLw5sRblvHSy3ocGDtj9jCckNF
   Q==;
X-CSE-ConnectionGUID: G0XTs8u6SSC6nZOiOhcfuw==
X-CSE-MsgGUID: fop2Hp0FTTKmw8VgVOLxkw==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="41339868"
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="41339868"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 19:25:28 -0800
X-CSE-ConnectionGUID: 5xndoqXtS6CBj97oLlrsUA==
X-CSE-MsgGUID: Aekon91zRPmkrbVJxm2MNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,221,1736841600"; 
   d="scan'208";a="141808741"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Mar 2025 19:25:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 4 Mar 2025 19:25:27 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 4 Mar 2025 19:25:27 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 4 Mar 2025 19:25:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lBJo0d8FDV7NVVszZlgYKUdfuq5pUTiO3kv3lguvg9VwmgjKAmGbN0EbP6ZCcEdOHdW5TzHFTVMDaeGGIYeyqCdCiqx8rHFtrZ9rV42my82WHIe8IHRy2Vc1WkneryRagekYbn5zkX8SgpVpuiDNrU1kTHWY6tJP+AM6Jm7uEGthG+U1A5apFThIAZ/tbbw9z+nXv4PsCcfhlluEkClpYJiJSnWSaYMVA0LQR7D5qvmwUn2lI4H+jGPVLh8ElozWTl50YtjqqhH28wJ0BA73XRUPAhYQBN2zxK5GnqqeSaLYASBrDk+h4L/c/aIF3DE/Gbu3oehD9gARdjK2s4w5WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C1FC58U2wqnbn+ij8u7HvV0Of+/SkEEAZKqymElfD+Q=;
 b=AcdUiertuFQ124nY6MLAzYN1vREVAN6FkaZnzapeg8cvt9+bL3dsRi1kzZug1H2a63FoCWYcGwOdZuSCrTV6QdTu4t+HQshSnmOQFCYQwdC9BWK2CZ47jX8nfbj1JkeBV8e8fmZaMCGeq8FbiI72HK9+N4F9hh4H/HlTPBpIKqlycq7pom0nZXssI64Po3gKFO6BnXXh2qVM677zuQPWftdFIvyyT0PnS6fEBe/NlJG1H1CUC5Ryd17uQDCq9tnZpq9zynm0grWRWl+gAWmlBtH3uj4lwFBGBnDvA+5tG07JwmOKfk/dJ/S+Gor/e0jt3iYgdvEmhbWuuJR3yw6o4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM6PR11MB4547.namprd11.prod.outlook.com (2603:10b6:5:2a1::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.28; Wed, 5 Mar 2025 03:25:19 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 03:25:19 +0000
Date: Wed, 5 Mar 2025 11:23:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<xiaoyao.li@intel.com>, <seanjc@google.com>
Subject: Re: [PATCH v3 3/6] KVM: x86: Introduce supported_quirks to block
 disabling quirks
Message-ID: <Z8fDzqsjsue6PHBh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250304060647.2903469-1-pbonzini@redhat.com>
 <20250304060647.2903469-4-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250304060647.2903469-4-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR02CA0127.apcprd02.prod.outlook.com
 (2603:1096:4:188::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM6PR11MB4547:EE_
X-MS-Office365-Filtering-Correlation-Id: bb4cc380-a781-4411-ee57-08dd5b955b0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nyXw9SvpMYRC+pxaN55tcy9oNEqgbFm1Xgy9ZJbtAcG19d5KweBosjMO7yUU?=
 =?us-ascii?Q?nH657RZJp0fJLwCsMzESU9/tYT0jM5R5Y9pRx+brK60L1tVLrQET1CJL5jcK?=
 =?us-ascii?Q?oP768jO3YZw+2KEFYN47IY7TnzRHXuDjBrd5Y6hqM+/Xy+feDVsaoSemo7+w?=
 =?us-ascii?Q?tf6Xcbt/+ogGu7iWbwUzqO9ojhaO+FLK/6fVM5GW2k/mC1cFd26LmhIjQDoZ?=
 =?us-ascii?Q?T/uI09Rg/YAFCD7Bz01mx483lLWR9Cb7RhS89FaqUePgfMJVf6Ek6Mkutska?=
 =?us-ascii?Q?+GqvZ5izrXPUYxmqFEzQw0nYmpjCbj2PwjWtUDBPMyZ3/kV2cqDERGYenG53?=
 =?us-ascii?Q?AyOImtYOQEu5jT4mxYpzSu099D3l7XkJlwXZhdnTQicNDbPbCoLlO6CuwY12?=
 =?us-ascii?Q?NBrKU6NpzhrZG8cPeMn2DpqXxhtoWYk4Jvw3wbvY2ZEUdzxfxz3l1s5I/N7I?=
 =?us-ascii?Q?Zg8yFOQrrwASsP6D9AyCQSk+0FkZM5w2ZUsr4Dwu8G1ISeQUU65OQLDgzxZD?=
 =?us-ascii?Q?iY5C0RCR6/xWAJjSift5x06+Y4WYWJ1wDw2fyM8vU3UJ1+sR3QBUksdcRdov?=
 =?us-ascii?Q?qnke02ndWLdiNN2F1nTvgcZyorfVXX+xUigTNHXBN2yxB4XEqMQekawTR1uy?=
 =?us-ascii?Q?CwikNU96vrmZBZVaKdQsqeGy2ya1C5vfXefOQZF3baC5FHLORxLD2kxiBEvP?=
 =?us-ascii?Q?IMnOV2QohlHGHNgQG1jXgoG1fFstLU1zH4i/b+9j10Xj9JuVPhG6X7r4R+H5?=
 =?us-ascii?Q?fxs26K1ZowaL2XQVTsamBAvsOznbikSiEro04iXihXKs+Uf0j7SAbqkLszm4?=
 =?us-ascii?Q?48xhm1zJhd4MwFPf5Hl9wuRoY8bIW7elxQUW5QSXVz9RuL0C3eLbeCVaDdHW?=
 =?us-ascii?Q?0O1Mmoof/P0zP5x/9QxAQjb4uJ0UyLPpaR+MTtu+te9zzQxQZronjE8MF/yo?=
 =?us-ascii?Q?cTioX3P89ZqeIjuLNuoNiG4f9aDBfHavkKwoexGpzFUYrKP4OMDRMkHgH0wN?=
 =?us-ascii?Q?Cux3eNRh6qOqW/knxh61dTFEwLPqkLSKOyzZvfkAnHj2QlaykvVakArkmjn7?=
 =?us-ascii?Q?1R+1SSWYL1W421cxfrfWECEjsEaFqD1Iut2NbfDoSRXOOtKYQaBUsiM+FaGP?=
 =?us-ascii?Q?3XbsD/sZ3Ugu7HuVXbCNV6XLyCC6MdI7oHoaOKv2d8i2RvkFmuAsEbs9F+qu?=
 =?us-ascii?Q?mkCEbdJKKiwmYYGl+jGiEVs39/EU5NN4GyPjgIoySALZIWItf/77fFe7748Y?=
 =?us-ascii?Q?Vz78vgDYA7ZKXR3gqpvzqhgY5DxofT52449jzH5V0EpPzlvBElVDjeR16Cbo?=
 =?us-ascii?Q?TAM3L6TShHQL574MJN2Sev67lgTnd2OtjcDX89w1vczpXu69WQ155fV/UEHN?=
 =?us-ascii?Q?9VmaDrJAREghOdpdMB8zV5dUXymw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ed+Qfg5B7fioBegzxPIrLgmjOSS+V3C2zGF1tsjCDXL2pMkDGglkKlGoTvCh?=
 =?us-ascii?Q?wVOcn11QW0eJpIvDnK06YhfSsyr0P+QJ0BkVA94VbGEGX+NFd3RzQAXYAJ5E?=
 =?us-ascii?Q?+LPpzcdq4Cth3iXQoFKmLm4jNhwICaWFOS7W3SrwLwfxoxT1v87Mn19dV1Sq?=
 =?us-ascii?Q?VyXYC2CRWeDRmPgIwQG3KIpAKxbQnKOsMDSYSYaUv1X4twVk3cDhzlEySPkN?=
 =?us-ascii?Q?QHfhVHy3KtLxy3aHn0Zu8YKWeiAyP82eYHFEVUIkuVWuuGMv7RAlFQfTMCfx?=
 =?us-ascii?Q?dgMFTtzPNPy8UHv7nqkkZYOfXupPf3fKZ3DhP3RbltgNrCrE4BEBZUTTDeqQ?=
 =?us-ascii?Q?mgSZbFJ0JZoJseIZb4TOIxTxi5eKwF2j92nkZstrXwYYld9BB7gBItodd2e7?=
 =?us-ascii?Q?PfUX7H2l0nXx0qOOlz5O54of0SfwG0YPEUj5oHRyFN4ns0ZpVTL+Bc8PFVoH?=
 =?us-ascii?Q?dtUBfzU5espgyqsmCx42woenjQd/LLzcXluFHjw0F0BYRoV/n7txkmYnHWc2?=
 =?us-ascii?Q?EBxqi72ws7LB8FV0jVDY3SO7Kkz1GPJETDkX2GCi4wP4+mIzENeNDID7K1+e?=
 =?us-ascii?Q?/0vM5m6lMiF7zChsGI5CXzMbECnq7UCfVh+Dt8obo8rqXAL/Tw5d5x9RXmxl?=
 =?us-ascii?Q?Wooed9x1y7NQw4QiZ86ndhu1whbMVu5plTT/nALcM0v9oCdZqRmmh+FoDqlC?=
 =?us-ascii?Q?BbHdmujtbmGMEu2ISZ3uI2CUzQE36liUXPfxGSAytrZqv/RvjogEpiujUFS8?=
 =?us-ascii?Q?LEY6+A2eXaNyqcLU+AR4C4Wv9iQxHdTwzTt6FFWOnqake5qOO21u/mxFgwpk?=
 =?us-ascii?Q?/9h1G6jYKUP+/TY3/kTXRls8wZ1BNykcCvQIBBcV6ZX6Aaaz6TTBNax1CeNR?=
 =?us-ascii?Q?B+JUaY86FYQueTYWL12R+oqsG1b65Dg5Y8Cf4A6jhgvltTa8JpyfD/1G7s1M?=
 =?us-ascii?Q?548tN+qNY/gNdQ27Qwx85A3fHincTtqRYLsRzkC8HCdgpvL7iL1uHOfv2WZ3?=
 =?us-ascii?Q?xWXY2Ve9RNdjAc8vK8c8bgi8mJGe3qmaK8OglTA5tGjzvH8rz+pyod3oi93W?=
 =?us-ascii?Q?8Dz+mY5Rx6gwk3muvEivh/7Q+5ZQbnYdelMXlM8d9hNLveeg+cpe+TeElbqg?=
 =?us-ascii?Q?ActdJYcNgC3MYqS9rVq+fsAx/LIyVQ3xQEOpnAQw75GRvYv+lrGpR5kq3pPs?=
 =?us-ascii?Q?VIxsjP+i0dnYJcCWvEF43HHWDf7kirI5s6TZJRS6klzFYdmDaL/0NxpJnY+q?=
 =?us-ascii?Q?3SQ34DuLNFv0eJ4wQxY4u5ilt5jStDOxiJkmtjpMBBFfP8KQDv5CJkhch/kw?=
 =?us-ascii?Q?u1/e1/LfJX6TWoDj46SEptM5NNnpqZV4RkjN0Ka2SElnqyxDxjMd/QfJ8CwX?=
 =?us-ascii?Q?ck1ARJYi5Lv9OQ/6l58HptXxTUdx+T9EwhAHqTFyN+g8+G6peTcNAYjqTj+U?=
 =?us-ascii?Q?P0C3tK4ui+KfCE5z1irNiCICNTRfBOFjDBzV7woDh99t5oXyWqTYnBP3l2x1?=
 =?us-ascii?Q?sPXMFxRjCf5LVhP/JVPJjlXx5ZAbBkz0cpDihXskFumDKUfC4IB+8plQEKAV?=
 =?us-ascii?Q?KQ874QS6OdbYruPzO1/JvKpwXGw8iJUSnBiNYlZeTSOp24Kgx/nBN9+6oyT6?=
 =?us-ascii?Q?Ow=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4cc380-a781-4411-ee57-08dd5b955b0b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 03:25:19.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mH41J6WTR6C9RGd0qugnwrfNE9e/4D+1pnwPf/sJUjCb+zJDF6xAk6/Yx71dNjie+HTQSHFyhTYU1sMwg7A8og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4547
X-OriginatorOrg: intel.com

LGTM.

On Tue, Mar 04, 2025 at 01:06:44AM -0500, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce supported_quirks in kvm_caps; it starts with KVM_X86_VALID_QUIRKS
> and bits can be removed to force-enable quirks according to platform-specific
> logic.
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> [Remove unsupported quirks at KVM_ENABLE_CAP time. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++---
>  arch/x86/kvm/x86.h | 2 ++
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5abea6c73a38..062c1b58b223 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
>  		break;
>  	case KVM_CAP_DISABLE_QUIRKS2:
> -		r = KVM_X86_VALID_QUIRKS;
> +		r = kvm_caps.supported_quirks;
>  		break;
>  	case KVM_CAP_X86_NOTIFY_VMEXIT:
>  		r = kvm_caps.has_notify_vmexit;
> @@ -6521,11 +6521,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  	switch (cap->cap) {
>  	case KVM_CAP_DISABLE_QUIRKS2:
>  		r = -EINVAL;
> -		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
> +		if (cap->args[0] & ~kvm_caps.supported_quirks)
>  			break;
>  		fallthrough;
>  	case KVM_CAP_DISABLE_QUIRKS:
> -		kvm->arch.disabled_quirks |= cap->args[0];
> +		kvm->arch.disabled_quirks |= cap->args[0] & kvm_caps.supported_quirks;
>  		r = 0;
>  		break;
>  	case KVM_CAP_SPLIT_IRQCHIP: {
> @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>  		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>  		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>  	}
> +	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
>  	kvm_caps.inapplicable_quirks = KVM_X86_CONDITIONAL_QUIRKS;
>  
>  	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 221778792c3c..287dac35ed5e 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -34,6 +34,8 @@ struct kvm_caps {
>  	u64 supported_xcr0;
>  	u64 supported_xss;
>  	u64 supported_perf_cap;
> +
> +	u64 supported_quirks;
>  	u64 inapplicable_quirks;
>  };
>  
> -- 
> 2.43.5
> 
> 

