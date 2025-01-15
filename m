Return-Path: <kvm+bounces-35506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED71A1195C
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 06:52:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 887817A4697
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 05:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D290822F820;
	Wed, 15 Jan 2025 05:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GDlWWNmu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A8B22F393;
	Wed, 15 Jan 2025 05:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736920265; cv=fail; b=q/eTjEC1Ekh4rVZV88vQcJw8pnLkUFPl04SM7b6MuhAE91j4we9KoJI4O5i9J5yNn1d3I09E5cavfnCAPwhxC59ghGjZDOm615PfScjBCuqFw7oHKQ8DiRt266uGstOJ3gDfe80wUzuIGO4JdFa+Kmjm78a7NkGtswvbfo5XjTI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736920265; c=relaxed/simple;
	bh=+NJpI6PoI7e2Iu0AVdWMRIGNe97y5Mvsfgm2a5xa5SE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rEYBweSylTWNblnSdWSId9dbDCPAC0zV3f6WtK2CtLPBwejRTXGnD4eikMdHYzm4hPydMv3BQN5sEkbM7aNdipFb7kzzxyGyA2nD7FFE7kj6X5qez/PCPHuiBR1QFWV+QU0KMrldymcmgaJ7Cvy6JYTJHZpvXk5PyhPfbSkx+kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GDlWWNmu; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736920263; x=1768456263;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+NJpI6PoI7e2Iu0AVdWMRIGNe97y5Mvsfgm2a5xa5SE=;
  b=GDlWWNmu0isRBxjxG/ZLh3pn/07BFqLQymzR9Ju03ZS6Fd/2pXXsvXRH
   UlKgWR0HuWJZ/XDKrTBpIr1YnFtwELJS3wrWe7pXttMyBt5iVzxRPGEEC
   UohysF8Jwfk+YzrD/4W2PWF/IwmExwYTfNZ2eILUwKUGMe6eljEy3Uvpd
   x0mnlH+UWPPHcugVaRM4qLYRw3K6m45qcr9UW1vug64YhC6jaPIIrNJn3
   MTXxMcMhwYRro/CwHO97SvSHI242SE8fWFUKPvfU9wpr9eTSRUObOheON
   IKO7ESXQnKn55bLnCdWMRuXcxOoY+yKx6XWo6zgI2arv7IXFZj2YfnkFJ
   Q==;
X-CSE-ConnectionGUID: BmSZaI6eS06HEBbRJVAFZw==
X-CSE-MsgGUID: iTxtpnNtQ4ehhhNbc7NlZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="48648823"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="48648823"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2025 21:50:59 -0800
X-CSE-ConnectionGUID: oByeYWvDRvui5v/eHwUxkw==
X-CSE-MsgGUID: NZ4EP/GLRiK/uxXvt0ym0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,316,1728975600"; 
   d="scan'208";a="104865833"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Jan 2025 21:50:58 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 14 Jan 2025 21:50:57 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 14 Jan 2025 21:50:57 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 14 Jan 2025 21:50:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UjYtouPO7qxsmxpfiSwOgEHyfWdbM3VQ4LNJ2p0smv9FkE06wY1Bte+Htex3TeFpYgyqtrFjkv+cmLXcCwAkphu2UVW9ye8ugJMHeSaj/hO8zOy/veOJziysyMJI+Qt95FM5VmrjPJKkVltKPflY8Eo2MCKkLVFo8+mRCAogyI1uy6b8+q4fw9mciuKp67vdlHwCVFyLQoYEXWfEBdSinrYlZWx6CuPKKH4AXNrTmmkHod3A6Pxo4kQ4oSVQIz00Y5jea3L2OYY04brrDPnHUkDJMb6Jx5L82sFNb72FsM4ue6sQJJO1cuTq3cDxnJKSM9nL2R1qRtZsSy/+BWsssw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n7LfP8E6C/+KeW8rA5Fqaz865xEP3AnjcgTztWUibjQ=;
 b=XFxiMvHghlN1PAjSpkLbG3L6occqm9MgHOI898hN6KROYU6C2VhzZ4Q96kVcYqjuq4ER2W+gICTvPCjqdD0vEILctoKSh6WWjvzD8+d6rtt6O4/UPPeqj8724llu/sNTIhIO5Mqyy11zAubrm1uqJqnJ/ctvb/TjczZxdbbsEQePZGYSt1AeCD3xBhaDlfN1ZgIe0Ua9AWhKNH8OMrXqrx4GrTMiyPnAdevDzoOIy4AsS1IVGz5NKsZVjZp6mguT4WmyilZVZ/+trsy2Mo5XreNMkaI7sFYuVQErTefeTFw4Gk83fVVs/rnZTJqie2CH3MoBi5/7UUFXovtcFpL7UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB7316.namprd11.prod.outlook.com (2603:10b6:930:9f::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.18; Wed, 15 Jan 2025 05:50:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.017; Wed, 15 Jan 2025
 05:50:53 +0000
Date: Wed, 15 Jan 2025 13:49:54 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 08/13] x86/virt/tdx: Add SEAMCALL wrappers to add TD
 private pages
Message-ID: <Z4dMgs7BKmmuaXeM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
 <20250101074959.412696-9-pbonzini@redhat.com>
 <c11d9dce9eb334e34ba46e2f17ec3993e3935a31.camel@intel.com>
 <Z3tvHKMhLmXGAiPg@yzhao56-desk.sh.intel.com>
 <be581731-07e0-4d5c-bee6-1eb653b7b72d@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <be581731-07e0-4d5c-bee6-1eb653b7b72d@redhat.com>
X-ClientProxiedBy: SG2PR01CA0160.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB7316:EE_
X-MS-Office365-Filtering-Correlation-Id: b404165a-50ce-4e12-18e4-08dd352892bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fs8fE7vkE/0vX1oeGS4KIFH9w249SRLzKDWGRyby6Zz4oFnbzBo2RRrMfcXM?=
 =?us-ascii?Q?QzspjLQ9jxX6k72eLd3EpAv8oJTVPPNpGtP2DUGylHSCDE1w6Qm802OSdlDP?=
 =?us-ascii?Q?Wvpl0e9VUcoGbSw0WcEnREqZvyLwxrszBpvQ93ZzBzi9Rg3Lloec6T6gJRxh?=
 =?us-ascii?Q?fot/jQmPTdiE623atbZWzuFFzhPvZznVXxAAITL/oF2MiirbNP7eKw+3kcCx?=
 =?us-ascii?Q?NyjfVHWuoH94PMzRREOPhiiwKoikkU4BaTJS31CVQQIJkA/I5uOnGPCTz+5Y?=
 =?us-ascii?Q?UnXzxOdvmnn/V46rlMOM63Bp1ia3z7QFPvH/nqsJ5QC69IDukXgz7QO7Jrxu?=
 =?us-ascii?Q?pVFPPMVaFZf4um6J88seZctSrXhJ7HwQPX9+i5vrqv/qRLjjyXBgyE8/GuWe?=
 =?us-ascii?Q?wnD+G2J5OLfPw51xynNo8R75D2mT35Maiw9C234blfItNU3WLtpatF9Wj3K5?=
 =?us-ascii?Q?tLHrg24HEoJyaMwDUi+RVDMBSK9PHprFl9Iez4Ef8I5gGvIWKKJi4j4abC9c?=
 =?us-ascii?Q?r6RzeKcRRiBagl1eXDOWFxDbTLGGZF/lEq/4O2wFiUS4h1s48hqcPWJ+/aZe?=
 =?us-ascii?Q?+/1OQpG0K9SS8fHRht2Ft1ov1vXtNYUmZJX9Q5Dpgp9VnFgvOr1ZzvjtNNPw?=
 =?us-ascii?Q?Q/YhtIQqY9zz8XQbslbC19myCZFSbki2qrNdrNf+TIew4hoVc9XM4SITQFXk?=
 =?us-ascii?Q?XDgz9TailsS+IKgfzofaiLdiei+DjBrSUdDOlRYyHxKpdkR5Z0PdN/p+p4Un?=
 =?us-ascii?Q?2DIkStYdQl81RLzc32qM0C9GbfLwS3AMMbW5geG42us/WwBPkONsZitCVqyS?=
 =?us-ascii?Q?+q5kbysoVx/3C3XJjW+aPqVcpvwOseFkoJv9pACP2FkczFQEvaUfQcwEx4gy?=
 =?us-ascii?Q?VhzFD5QuXODLZqCtCtd7lXILaQJDH0prE30y49aESIUYTcNj4OZx8LpC5Z6h?=
 =?us-ascii?Q?9Or8RiJ+BBPnHJHS7K8Ty7EUxZ/jMngfxgTo6Jx3v0NWp3VPurFCXeMJC6ii?=
 =?us-ascii?Q?Uzlln+CfRcx7ORF6LRlTKJ4WqpzLZjADA1eRYF5G6lYhPqoQEszINsSmESnM?=
 =?us-ascii?Q?F0vADDPh9CL3UFCprfonpr4/cea4MBEhf1t6HSgmE2od2dLkODoN1YuJxMmm?=
 =?us-ascii?Q?zztfbd+zI1/GuVK/1x13AqNXryLz9RavxheeGzURGoJ+xWYfsv0PjNtQfzNC?=
 =?us-ascii?Q?2hCzPjqC13S8udbaw85VMIVh/BKCip/kqvOu8EuYS4h0+mzs7Gn0lLvbVck8?=
 =?us-ascii?Q?KBFiOKgnLF07oFT10pCwYuh4mJqJUKllNXEx3oypDhT4GZNE437u1o/2Z4Xj?=
 =?us-ascii?Q?768UmqNU+zKS6RSktTcO7AtlAXDFP3FKtBm4ZU6HHvvhN/mCyYTT49Our2F9?=
 =?us-ascii?Q?goKxdC6hBY+TA321/dvsO263xO2q?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6n9JNuJz+DPj4Qu9VSFKNv6mnbYp0MmufsGd8Ro2ZFHyFqPOR9b9hRd7Dvv6?=
 =?us-ascii?Q?UCNjlstCfc3hxxWc+ifVrLglKmCZVW5sNhEyvhQcGo9oyrklGJthqAx/2Ocj?=
 =?us-ascii?Q?Cus64EFyvyhEvSUQsueJ8l9oV3igUDnHPzggkmMukQvLqnRhpHy+LiRAisZG?=
 =?us-ascii?Q?R7YroFPe4jjCzN63/qhz0c6nNuwOA1atUA2wBqYjK8W43y7AA3OG9AEmGtsV?=
 =?us-ascii?Q?gt8dl8kTkpyZzXYQMjSoUVcFmVp4gLF6oH690DxlJElgvSKb6/81Xa+7UHaQ?=
 =?us-ascii?Q?RmUng8tEWLm2tZtgOboyIkWBnXfBs/KpqHlNrzUpDROYUm06FUyC2C5BYwYl?=
 =?us-ascii?Q?PavkbNagEa7On6+k1JYv9b+4OXNxuTyQWlO9wSKWKaA7awA1YToSiyKv9ma0?=
 =?us-ascii?Q?y5r0JbDO9dtl1LcTjUlhsK79NBo4t9s0EF8ARr7bVRyrYLPYVrLYaSdrJI86?=
 =?us-ascii?Q?HMq6/1wj+4d950MD0aWZjlG+M/HUDRf6g1G8Ky7b5Nt1wz6/7MnFJR/1Z0Wd?=
 =?us-ascii?Q?xy0yXYSuA7Gwp5dAhRZcnUqjHRxebe0PkDI1A4gOcZDWqzt67MobhPzch4Hv?=
 =?us-ascii?Q?4rhWTcNwd3dxXwcTgtu5+ktN2xXgVCxx1r7J+U68DFxQhjnAUElPs1gY3Eis?=
 =?us-ascii?Q?Vm8rC3Wr5lI4z+556+nKEbtbYs7E16uNVCEdKFLufGIVSQ0Ah1qzZG4Spzf4?=
 =?us-ascii?Q?oZp+gkpPKTn0jmN3HmOGwSC+hAQ/rQTZkUtDps2+CeJY3qB3kfuHRmziDBBf?=
 =?us-ascii?Q?TDxEcNDU1G5hNbOrZOgS1VE3wagAlnJdYvoSsKc1YW3KS9uHiDtSgLAWbWQd?=
 =?us-ascii?Q?vylF/I036i8/nrRQD9B+rzAizEr2Tb3ckz88gqbyGU995gfNhIska5ODyYT0?=
 =?us-ascii?Q?ON5CmTVgXL/+X20pe+5yJzwGLp0jcR6Bm5jnLI3/MwcRmAIcAQtEcHKdiVWv?=
 =?us-ascii?Q?+RInyavz8d9qegbKZ2A9oBL+6mGFlJ8wCn/9Bqk/YH8JZp67XLmy496HoZNB?=
 =?us-ascii?Q?xI8b90QZmiNcxDhmNWsccA0WaIfQgrmba8ckX4LhQ/62Kk87Zlh08FVaJ28+?=
 =?us-ascii?Q?gf0YlZcr+KSf1919D27IGL+Ia/O9a0yDz4lOohSkfh01yyYu2/B2p8elPi+g?=
 =?us-ascii?Q?h3EgSWsVSWKkXgkkca0afbMG8Va3E2s7esD2t5R9Y/QDyNwpt3ZbLfDh30tn?=
 =?us-ascii?Q?cKull9Z6ylzd8ijFLeRlZYjnuBYHvkST/pZJcCwkgiaaCOsK25mtEXwyStur?=
 =?us-ascii?Q?3ea+4TOaGsirzmKF6OTVWRtrFXO/T/YQTsqu/T81PPlrfJt59G631Sjr0LOa?=
 =?us-ascii?Q?OcfToXZjtNx1+MmtW3ZxRlQtPTCAvxB2pD9RFjz5c4M+KuDC0j9wtEztudpH?=
 =?us-ascii?Q?h9YR4szXNEvZkxFRDDzMjE6iyhIZZtV8fduHdmgsfmjkj0C4/j6eMMy6vju2?=
 =?us-ascii?Q?0eLL4UQ9WvgsrnAWlQVaoEqoEwiVJcuvdEN7CLdRqEpXyc/PHDHpQNQWX/do?=
 =?us-ascii?Q?6g/n0V00UCaSJx8EiztDcNRoLumJgH/dKldQx7p5bx0He7pDOfmt8GcmRyXo?=
 =?us-ascii?Q?KNg6heSMvI+dXnjnu5iMGfWXhvyakczwCH846wMBzIf5ut1jI2XzKT35FAdt?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b404165a-50ce-4e12-18e4-08dd352892bd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2025 05:50:53.4446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ozRG7J1T7W2Ni+7bpLAzzTd1ZRytLSbJoPmPAmknn2JwjdNH1mR5PUbAmzj7wrry1MSSCyS9QLv1hvK+0m5RlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7316
X-OriginatorOrg: intel.com

On Wed, Jan 15, 2025 at 12:32:24AM +0100, Paolo Bonzini wrote:
> On 1/6/25 06:50, Yan Zhao wrote:
> > Yeah.
> > So, do you think we need to have tdh_mem_page_aug() to support 4K level page
> > only and ask for Dave's review again for huge page?
> 
> You're right that TDH.MEM.PAGE.AUG is basically the only case in which a
> struct folio is involved; on the other hand that also means that the
> arch/x86/virt part of large page support will be tiny and I don't think it
> will be a problem to review it again (for either Dave or myself).
> 
> > Do we need to add param "level" ?
> > - if yes, "struct page" looks not fit.
> 
> Maybe, but I think adding folio knowledge now would be a bit too
> hypothetical.
> 
> > - if not, hardcode it as 0 in the wrapper and convert "pfn" to "struct page"?
> 
> I think it makes sense to add "int level" now everywhere, even if it is just
> to match the SEPT API and to have the same style for computing the SEAMCALL
> arguments.  I'd rather keep the arguments simple with just "gpa | level"
> (i.e. gpa/level instead of gfn/level) as the computation: that's because gpa
> is more obviously a u64.
> 
> I've pushed to kvm-coco-queue; if you have some time to double check what I
> did that's great, otherwise if I don't hear from you I'll post around noon
> European time the v3 of this series.
For tdh_mem_sept_add(), tdh_mem_page_aug(), tdh_mem_page_add()
- Use tdx_clflush_page() instead of  invoking clflush_cache_range() directly to
  share the common comment of tdx_clflush_page().
- prefer page_to_phy() over page_to_pfn()?
  https://lore.kernel.org/kvm/0070a616-5233-4a8d-8797-eb9f182f074d@intel.com/


4d0824a1daba ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
contains unexpected changes to tdh_mem_sept_add().
u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
   {
  +       u64 hpa = page_to_pfn(page) << PAGE_SHIFT;
          struct tdx_module_args args = {
                  .rcx = gpa | level,
                  .rdx = tdx_tdr_pa(td),
  -               .r8 = page_to_pfn(page) << PAGE_SHIFT,
  +               .r8 = hpa,
          };
          u64 ret;

  -       clflush_cache_range(page_to_virt(page), PAGE_SIZE);
  +       clflush_cache_range(__va(hpa), PAGE_SIZE);
          ret = seamcall_ret(TDH_MEM_SEPT_ADD, &args);

          *ext_err1 = args.rcx;
  @@ -1522,6 +1544,26 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
   }
   EXPORT_SYMBOL_GPL(tdh_vp_addcx);

> 
> I have also asked Amazon, since they use KVM without struct page, whether it
> is a problem to have struct page pervasively in the API and they don't care.
> 
> Paolo
> 

