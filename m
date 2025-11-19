Return-Path: <kvm+bounces-63673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A861AC6CE9F
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 07:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8E95A4EDEAD
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 06:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7D1C31AF16;
	Wed, 19 Nov 2025 06:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kh//NmfV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB03191A4;
	Wed, 19 Nov 2025 06:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763533525; cv=fail; b=aMNSB8c2YwwUbM9PeYAiJOBvxzDKUrf56hhAj3K3J8W9GbCP5eD6YvkDEhC0FJYdUVH2e2lYldWPsc6fYMs0/GdMesN3A2qzqh1BImOXJl9zJzKOAExSDDeZpaB4U4X26DAO++rqM0sNm4MlOw+xoioQXom5810tD9X+zVFheZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763533525; c=relaxed/simple;
	bh=A7+6ULnJm/yhH/A7jc7iFe5cN4Gu0mxSXY2vVwwTU+g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=r+9lDoc0DTnKP6MMiPDY7CMOnIALVY6wCmucewSX4Vll9mpUPNQ6Uq4JMXkb5Dq5CMUT6A+Y8RwUlngv+Cz3LdCWJ+B5C19fH8MjlxJPXDnnFZ7r6Ufg155rgUjysxO7bEB9f/2uvG7XjYezm7bJ6oiZgoF4CsXz4KAII3aREuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kh//NmfV; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763533523; x=1795069523;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=A7+6ULnJm/yhH/A7jc7iFe5cN4Gu0mxSXY2vVwwTU+g=;
  b=kh//NmfVVH4aLEnuk5p8oZu84zAN13ts4w/m0zk6v/YvfxkKDbw8x/33
   RGvLS5zZfdpB7BR4mLJlAMIT35xhnXjaB8d49FYQeIKa0EQSZStW7iFhe
   Opr090eiDTgVD6f31LgmHlqfEYDsdAZXbdUDwW5KxQ1ma7SdM4d+9L/Kt
   M5brk9vrPVDcRDpW4cBA7f/gk/TwBPHFnJ9v3SegZ/oElwpaWwLrphMXw
   7NfniTDKPDqbwZUe1zQ1tCY5776NzOpD9By4evM8HXUtAVC1w5KnrOLNc
   k/ZP8OdMr+0wAKlgvvnBWxrUCX7MFs4VgSTlHZGxQFsX7y0GYIVQxcjWu
   Q==;
X-CSE-ConnectionGUID: yfnxnBLoTVyL0VHTeB57QA==
X-CSE-MsgGUID: cq045finQY+F+KlqjI3XSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="75891783"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="75891783"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:25:22 -0800
X-CSE-ConnectionGUID: bA/8D2B0SuijW+oyZyvT4w==
X-CSE-MsgGUID: /S9XYZ2UQwS03sTOZUXNag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190993534"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 22:25:22 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:25:21 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 22:25:21 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.70) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 22:25:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e6TvCRDamEwNegIAk2ABfu3iMF4hY8g3t65iFQWSuRorHNRyQMCj8u/kh2TAbamXG69NLA5gfPKFC4RfEUIA/Br/NGj5OduXRr3ZFnfuJIAllzArOR8wQ2pFxhCzd5025WW8INfaY5nCmYgj1YCS/dznOQ8z9+Yua9jmKKbMl/PJnluvysqSZQsJJfTbVe9Y1F361KkePwrObAlVk4Xl5Tt6R5F/nEbqaooWNYDn23BuEh5QkKQAgJJmoSRYYkmfDWXJg/6+6McJ8z7cX0WOmoTVlRB04tv0OcN4iSLF+jQSsShkQqsATe5fDhMFxY9QhIkMGaCH5eDc8Xs4Iaz2hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=moZGnR6O/lvD4BlWuYWJCawdFbS0eljt/eNwmws2XVg=;
 b=NGDavBM4IiguFgTWaHxqp7yXRlr0siCTvnVlzI0KaqYzO7VgjD1LwfH8LjkGdfNOdMr5yfqXujb6lErBPzYwaEleFZruTxOyF3SPVGn+jP0YI3Ze7BMhnFF0FdTlqguhjDErz4vOevThbIKKRI6xEgBiiGYO06wP4iDKN4T7vRE/UrTSqEpNo+pbGlyhY0Fq2v6Vqrw1CWP7xyqdZ9VgeK8csG5i5GMIdz+i6yVv2Oc1S00F52lVqYRkMCuXPpwMTzefbGwUx79/3rCLPk3X45cFAtdt4r3kZVomewF/mo6eLBCV5ztVD1/uBJTAGMuXoaILWraXR7wjLVv84k0ONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL4PR11MB8798.namprd11.prod.outlook.com (2603:10b6:208:5a6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 06:25:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Wed, 19 Nov 2025
 06:25:12 +0000
Date: Wed, 19 Nov 2025 14:23:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "kas@kernel.org"
	<kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aR1iR4knhC52JsUO@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
 <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
 <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
 <35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35fd7d70475d5743a3c45bc5b8118403036e439b.camel@intel.com>
X-ClientProxiedBy: SGAP274CA0020.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::32)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL4PR11MB8798:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a19656f-e6d0-4fc5-6f51-08de2734654a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?IeA+IfnhEIkgmFhR6uJOSlP2mlSb7IyYzJdmhayB71WIzOkjq2bbkucMsP?=
 =?iso-8859-1?Q?R9lGQI9JZxkc6oEZ+lnnkKRZBMCsKv3FU8YM43tu3rq3f0tfQoJCzjWxu6?=
 =?iso-8859-1?Q?pXNIc+6kTgYM0rixzygyZYKB23AS/97t4eBkfu6wZn+9kYG5+5IBjf2uhY?=
 =?iso-8859-1?Q?xLVrRagHVnydTOwKWdzdeLap7WE4BZ/Ubw25VCQro5KgWEekPr5Pw0VJK+?=
 =?iso-8859-1?Q?p0aRMBr1S2cB+3uB2mvVRED93WNmcfVQnQuXkOSXZXE2vt3SkajJ5C8Zp6?=
 =?iso-8859-1?Q?QIF3nRbW5SgsmKSOAU3dyedgxEwtTo6xVW57tb/+CCtd0b8Wg9mQFOxz6u?=
 =?iso-8859-1?Q?FWDiLWOIaT8F2NWNc36zgY7d3PhiUxkoPA47a5uEvuVHKcrWonpKttunJ4?=
 =?iso-8859-1?Q?UrRKuAqY2Cxj7oymRZIu9cwhDd0wEz6OWMQelAMVrKkr0/pse4Wn2zljPT?=
 =?iso-8859-1?Q?CqI3FsMzw1nrAp0koU3n8jbarB74yqd5HTjyFBY2Zt31FVyKMkQQRhkv2B?=
 =?iso-8859-1?Q?6b6EEYl/jcbNi5ezGgM13FiXXvwfWXbVPU/aRcgIuy+Expd8yYAM+DtK1D?=
 =?iso-8859-1?Q?S3zBe8y2GhIoG+k88FqsdnssOlNf0qC9N63mbifzwzhd69mtR2qW/LU7wX?=
 =?iso-8859-1?Q?lTesdEn+RsGyoIZrgkOmeYFzPtw65fNEog+/ARvg+RbMgDrxukkzziPqur?=
 =?iso-8859-1?Q?jlaNqSR3au6AOuYWTZQRFrpipSeveJyGF2bnaZYiu67EZz2YJp+5C2B6FH?=
 =?iso-8859-1?Q?lSxNMBXWoEB5OUXZoNK6t5fkZ9s7kwdV91TKkvygphiJbJpR8DcOwWdSYr?=
 =?iso-8859-1?Q?NisIijfF8mLhcJIYhB7I7OtPujeP0Rd2fQfJZx/SSJd/YkEp33JChoFIUG?=
 =?iso-8859-1?Q?QKg5tqWkJd4dxaVpEV34Ht+ELhLDKxfqFog7tu9m1/UC+r6KDvNbK+2goe?=
 =?iso-8859-1?Q?Qe86O711zlaRPdZ6HRpccSOKO83qt41Xd2PbmOfJysGq77VPBHzKeDoxgp?=
 =?iso-8859-1?Q?TjtFTG9rVTj9tdSIhMXeqP09tpf2lVUIDumxPPn+caYUfr3vyACWuvbHfX?=
 =?iso-8859-1?Q?MipPZavJI/XtnX7M7WzgPqLmSg4RnCuTWnKwf2uteGXRTjXlhrb3RtHegc?=
 =?iso-8859-1?Q?IkfZHyb0NwtX3q/MYRqYHaJRbNgo27nd7zUOHN/gRJFpSbDnPHhVEzb871?=
 =?iso-8859-1?Q?C+VjAzEpjdsRzydD3/IdKJsqo3G0b5oUlvk/paDMf+9dInhUzqn1xRUZt8?=
 =?iso-8859-1?Q?frOpSKAmXaKe4Tr55qPR3rmFygz0SzRg4wT/JdjWhl7YfwvhqErM73089F?=
 =?iso-8859-1?Q?NwWD2GDu0mRUSPZiFhD0yeKNDNvgHgTfhiTCTe9tDSHwBP7iRMkPaBfi3A?=
 =?iso-8859-1?Q?bTiriU/Z/Ps2cmID99EzJUf21OTMdPOAHJS5poWkOF3Lc0JtZCOf2U6AXZ?=
 =?iso-8859-1?Q?+gGqgLV97H5OfymxrR7WugReR9FBWO5Xcfc9S+nIKb2jNnwPCw+fop7jX0?=
 =?iso-8859-1?Q?kuYFydMlsafXHyEKqS6caay6HrctL6oZQkS36DDVJXlA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?f3g+W/K2HK0U0C2Zigq+YeiImWgFifAYmFPCPU4Y9Rth86S1J+8ogAHDbk?=
 =?iso-8859-1?Q?+eH96rod43Mvcc8z2Ks8HBv+GOqyYWv6sLpnOXG9CTnOBK2pdip2VaF8yz?=
 =?iso-8859-1?Q?tCwa5YzBuSVicWMi/+lmRwBm3OJiL2koeh06JamUwq0NUetOr94Z0xvvax?=
 =?iso-8859-1?Q?3M3P8iJDoOXRCSVfcB16PwZHmp20sjEqF3YQfVR4wqnKvyrfMoIkrQB8rP?=
 =?iso-8859-1?Q?LhwmLWtkfUINdx4uTTLg71Hs0J2JYrJegqLKYAA2C16H4eFRO0Jjh1dwhE?=
 =?iso-8859-1?Q?I0g9aa/H4gnn934lEUbgX3GNIPXKTsuDC/RH2PANBal5JwVOloN46qwfSB?=
 =?iso-8859-1?Q?enk7fCwdv4/nmgCWGqD7fox3xQVAlXoL1GQC/NrUFZLJkjGKx51magekrH?=
 =?iso-8859-1?Q?pw7ZlfVnRYz0qMAD+I9q4VxtMoGEnByALzPVzCFOWXe7sB/9hwIKMbxgVB?=
 =?iso-8859-1?Q?wq0k7np81Ut1iOYIOuimwRjfNocoST93uWOUOEHQAuhL9cNUTE0IX0z8zZ?=
 =?iso-8859-1?Q?9KUL7Zx8XSO8ACNVGXJOO5NkQmx5IS5xMHmF/zz2sfHwgmt73gbzZx5GtJ?=
 =?iso-8859-1?Q?6LdQ0jzOmB0iKQsZKq5uw1YFh0Mf7JKg4xEGOAlNlK21wPLotK9VG+GV8L?=
 =?iso-8859-1?Q?68RZ7DTsXb8DOrj6pJKi0X0H7bQmaUBFMaCfxQgxEqduFQggwvggPaZCGs?=
 =?iso-8859-1?Q?N+fvfkWj6ivKVOygkRG+hj8gpKLyhkkN4Vo4TcIsffC1pqxShDbEuQ/2KG?=
 =?iso-8859-1?Q?lftls3CPn74U6Ugqu1Wqo1n198Kn1tqw0UxdqaN3l6pmPWcH/h7Ht5uUG5?=
 =?iso-8859-1?Q?C4mGGtR9n1hS6Ko0WQXDj/fq+5zL4MpMRrTBFhIAQk4e51cG/yv9/n5nIy?=
 =?iso-8859-1?Q?GSUECLTjyKGipzWlq8Yvy6ezN0ZKfydVE9G8fLpor+HvOg8WW3B5GS7mTR?=
 =?iso-8859-1?Q?XKMsysGTjkExeDOflKne+a2bapO3CRo2/NwHZjtai2fA5nBAIKLeBjaRNG?=
 =?iso-8859-1?Q?TPqhL/7Ci7CvilmOq2nFPj9hmf8qG8VEXZO2PvSvB+HrLA97g46ktI4lPW?=
 =?iso-8859-1?Q?1XTnUMeK6Fie2ECrE0J9Z+rflFYNTWi6nX1uqa41oK5PFRpTDGhsEPaOzu?=
 =?iso-8859-1?Q?e1rdVYUEgwksWRHZMCfeQT7Zx2kisrt0wIwZqAArYIwiPW4TgUljQmddnN?=
 =?iso-8859-1?Q?cJopEQxtTQNf7oR1deYaJMP8ZDR5jROQoajxtWsZTiFG4brZkAILBk5roJ?=
 =?iso-8859-1?Q?6ES2nM9BhAp90AiJWg0k0z41uNXSH2SvJwCbcIkq8SaWhEg7n/FlizP5Ye?=
 =?iso-8859-1?Q?gciB5LxOAN03F+hF5LcCtzNp7+UrD+uG6LYQWHj80nBa4MdYrxcIgDozap?=
 =?iso-8859-1?Q?iC7vu51HAqQWPdkXpibHSUTQx1rkffterLX0Tlm3ESbLh+3OaTet19mcRz?=
 =?iso-8859-1?Q?cx03PXeLslwg+Ju5WaO5HH/R+YMeaHoxrh3RPtzT1wRvqWdqK/dyjG39io?=
 =?iso-8859-1?Q?j/usiF4Yimis7uEFMnChpJ270eQA1DJkYxhHB4Im8h7CehOhGImp5HfaMW?=
 =?iso-8859-1?Q?gf8xWyIyxC7SK9zUFVPDK8bmbmNs90g8lg9F697tFYKdS0zPMdcZA9Y5e5?=
 =?iso-8859-1?Q?grtsSjlGHH+ikICBzCN8AvUpZ2JaWmf0fH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a19656f-e6d0-4fc5-6f51-08de2734654a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 06:25:12.5999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3NvTR1Z54/EfK04LCkdGOm/q3xJ2bDVu5EdgJkAQnmtU7caR+vOqkgUQ17DBX++MkN7hmR3PYZdcfFINlSCXUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR11MB8798
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 06:49:31PM +0800, Huang, Kai wrote:
> > > So I am kinda confused.
> > > 
> > > Perhaps you mean for "shared memory of TDX guest", the caller will also pass
> > > 'only_cross_boundary == true' and the caller needs to perform TLB flush?
> > Sorry for the confusion. 
> > 
> > Currently 'only_cross_boundary == true' is only for TDX private memory.
> > 
> > Returning flush is because kvm_split_cross_boundary_leafs() is potentially
> > possible to be invoked for non-TDX cases as well in future (though currently
> > it's only invoked for TDX alone).  When that occurs, it's better to return flush
> > to avoid the caller having to do flush unconditionally.
> 
> Exactly what "future" cases are you referring to?
> 
> Why do we need to consider it *NOW*?
The API kvm_split_cross_boundary_leafs() does not force that the root must be
a mirror root. So, it's better to return "split" status and let the caller
decide whether to invoke kvm_flush_remote_tlbs(). This is for code completeness
and consistency as explained in [1].

[1] https://lore.kernel.org/all/aR08f%2Fn7j0RyGlUn@yzhao56-desk.sh.intel.com/
 
> > 
> > Another reason is to keep consistency with tdp_mmu_zap_leafs(), which returns
> > flush without differentiate whether the zap is for a mirror root not not. So,
> > though kvm_mmu_remote_flush() on mirror root is not necessary, it's
> > intentionally left for future optimization.
> 
> You mean non-blocking DEMOTE won't need to flush TLB internally when splitting
> but the caller needs to do the flush?
I mean as an API implemented in KVM core, it's better to have
kvm_split_cross_boundary_leafs() to make any assumption on whether TDX
internally have performed the TLB flush or whether non-blocking DEMOTE needs
flush.

We can return "split" and let callers decide flush or not.

The optimization to avoid invoking kvm_flush_remote_tlbs() for zaps/splits on a
mirror root alone can be implemented in the future when necessary.

> Anyway, all of above are not mentioned in the changelog.  I think we need a
> clear explanation in the changelog to justify the change.
Will do.

> > > [...]
> > > 
> > > > > 
> > > > > Something like below:
> > > > > 
> > > > > @@ -1558,7 +1558,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct
> > > > > tdp_iter *iter,
> > > > >  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > > >                                          struct kvm_mmu_page *root,
> > > > >                                          gfn_t start, gfn_t end,
> > > > > -                                        int target_level, bool shared)
> > > > > +                                        int target_level, bool shared,
> > > > > +                                        bool only_cross_boundary,
> > > > > +                                        bool *split)
> > > > >  {
> > > > >         struct kvm_mmu_page *sp = NULL;
> > > > >         struct tdp_iter iter;
> > > > > @@ -1584,6 +1586,9 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > > >                 if (!is_shadow_present_pte(iter.old_spte) ||
> > > > > !is_large_pte(iter.old_spte))
> > > > >                         continue;
> > > > >  
> > > > > +               if (only_cross_boundary && !iter_cross_boundary(&iter, start,
> > > > > end))
> > > > > +                       continue;
> > > > > +
> > > > >                 if (!sp) {
> > > > >                         rcu_read_unlock();
> > > > >  
> > > > > @@ -1618,6 +1623,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > > >                         goto retry;
> > > > >  
> > > > >                 sp = NULL;
> > > > > +               *split = true;
> > > > >         }
> > > > >  
> > > > >         rcu_read_unlock();
> > > > This looks more reasonable for tdp_mmu_split_huge_pages_root();
> > > > 
> > > > Given that splitting only adds a new page to the paging structure (unlike page
> > > > merging), I currently can't think of any current use cases that would be broken
> > > > by the lack of TLB flush before tdp_mmu_iter_cond_resched() releases the
> > > > mmu_lock.
> > > > 
> > > > This is because:
> > > > 1) if the split is triggered in a fault path, the hardware shouldn't have cached
> > > >    the old huge translation.
> > > > 2) if the split is triggered in a zap or convert path,
> > > >    - there shouldn't be concurrent faults on the range due to the protection of
> > > >      mmu_invalidate_range*.
> > > >    - for concurrent splits on the same range, though the other vCPUs may
> > > >      temporally see stale huge TLB entries after they believe they have
> > > >      performed a split, they will be kicked off to flush the cache soon after
> > > >      tdp_mmu_split_huge_pages_root() returns in the first vCPU/host thread.
> > > >      This should be acceptable since I don't see any special guest needs that
> > > >      rely on pure splits.
> > > 
> > > Perhaps we should just go straight to the point:
> > > 
> > >   What does "hugepage split" do, and what's the consequence of not flushing TLB.
> > > 
> > > Per make_small_spte(), the new child PTEs will carry all bits of hugepage PTE
> > > except they clear the 'hugepage bit (obviously)', and set the 'X' bit for NX
> > > hugepage thing.
> > > 
> > > That means if we leave the stale hugepage TLB, the CPU is still able to find the
> > > correct PFN and AFAICT there shouldn't be any other problem here.  For any fault
> > > due to the stale hugepage TLB missing the 'X' permission, AFAICT KVM will just
> > > treat this as a spurious fault, which isn't nice but should have no harm.
> > Right, that isn't nice, though no harm.
> > 
> > Besides, I'm thinking of a scenario which is not currently existing though.
> > 
> >     CPU 0                                 CPU 1
> > a1. split pages
> > a2. write protect pages
> >                                        b1. split pages
> >                                        b2. write protect pages
> >                                        b3. start dirty page tracking
> > a3. flush TLB
> > a4. start dirty page tracking
> > 
> > 
> > If CPU 1 does not flush TLB after b2 (e.g., due to it finds the pages have been
> > split and write protected by a1&a2), it will miss some dirty pages.
> 
> Do you have any actual concrete plan to foresee this is likely to happen in the
> future?  E.g., why CPU1 wants to skip TLB flush after b2 due to a1&a2 etc?
> 
> To be honest I don't think we should discuss those hypothetical problems.
Sorry about the confusion.

I just wanted to express why I thought it's safer to do flush before releasing
mmu_lock. However, as I mentioned in the previous replies, I can't find any
current use cases impacted by skipping this flush. So I think it's ok not to
flush before releasing mmu_lock.

Will update the patch comment to explain why the skipping of flush is ok.
(I think current upstream tdp_mmu_split_huge_pages_root() lacks a comment of why
it's safe not to do the flush before releasing mmu_lock).

> > Currently CPU 1 always flush TLB before b3 unconditionally, so there's no
> > problem.
> > 
> > > > So I tend to agree with your suggestion though the implementation in this patch
> > > > is safer.
> > > 
> > > I am perhaps still missing something, as I am still trying to precisely
> > > understand in what cases you want to flush TLB when splitting hugepage.
> > > 
> > > I kinda tend to think you eventually want to flush TLB because eventually you
> > > want to _ZAP_.  But needing to flush due to zap and needing to flush due to
> > > split is kinda different I think.
> > 
> > Though I currently couldn't find any use cases that depend on split alone, e.g.
> > if there's any feature requiring the pages must be 4KB without any additional
> > permission changes, I just wanted to make the code safer in case I missed any
> > edge cases. 
> > 
> > We surely don't want the window for CPUs to see huge pages and small pages lasts
> > long.
> > 
> > Flushing TLB before releasing the mmu_lock allows other threads operating on the
> > same range to see updated translations timely.
> 
> In the upstream code most callers of tdp_mmu_iter_cond_resched() call it w/o
> flushing TLB when yield happens, so the "window of stale TLB" already exists --
> it's just not stale hugepage TLBs, but other stale TLBs.
> 
> But I agree it's not good to have stale TLBs, and looking at
> recover_huge_pages_range(), it also does TLB flush when yielding if there's
> already hugepage merge happened.
> 
> So if you want to make tdp_mmu_split_huge_pages_root() handle TLB flush, perhaps
> we can make it like recover_huge_pages_range().  But AFAICT we also want to make
> tdp_mmu_split_huge_pages_root() return whether flush is needed, but not actually
> perform TLB flush for non-yielding case, because otherwise we need to revisit
> the log-dirty code to avoid duplicated TLB flush.
> 
> And then the 'only_cross_boundary' can be added to it.
> 
> Btw, a second thought on the 'only_cross_boundary':
> 
> My first glance of 'only_cross_boundary' was it's a little bit odd, because you
> actually only need to split the hugepage where 'start' and 'end' is in middle of
> a hugepage.
> 
> So alternatively, instead of yet adding another 'only_cross_boundary' to
> tdp_mmu_split_huge_pages_root(), I think we can also make the caller check the
> range and only call tdp_mmu_split_huge_pages_root() when the range crosses the
> hugepage boundary?
I don't think it's good.

- The code to check if a range crosses hugepage boundary is cumbersome and level
  dependent. As you point out below, [1G, 1G + 2M) does not need splitting if
  there's only 2M mappings, but it needs splitting when there're 1G mappings.
 
  For an API implemented in KVM core, it's better not to assume there're no 1G
  mappings. Not to mention TDX itself will support 1G in future.

- When a range is determined as "truly needs splitting", e.g. [1G-8K, 1G+8K),
  tdp_mmu_split_huge_pages_root() still needs to return 'split' status since
  splitting may not occur due to no present mappings or no 2M mappings.

> E.g., for a range [1G, 2G), it's doesn't cross any 2M boundary, thus the caller
> can skip calling tdp_mmu_split_huge_pages_root().  If the range is [1G + 1M,
> 2G), then the caller can know only the first [1G, 1G + 2M) needs splitting. 
> This also saves unnecessary iter walk for the rest range [1G + 2M, 2G).
> 
> I think if we only consider 2M hugepage but not 1G page, then it should not be
> that complicated to check the range and only call
> tdp_mmu_split_huge_pages_root() for the range that is truly needs splitting?

