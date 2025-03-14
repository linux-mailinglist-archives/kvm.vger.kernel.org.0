Return-Path: <kvm+bounces-41048-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87346A60FCF
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 12:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4E18C1B6077C
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 11:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF31C1FDE05;
	Fri, 14 Mar 2025 11:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WdbYvq0J"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3421FCF65;
	Fri, 14 Mar 2025 11:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951269; cv=fail; b=rY/XdXuBcoHdsid3Ytm71DJPacmvztyMXRV28CCgxDkQdMgwUZL4ztUww6CunwkUIiyO9ku6uEPKzwpw955mxuGScA31Yxy5WhyjwvNQvnZTkMe+y2/As3VH7srAbwSyfdny6BUhilsE5qzqan0NqY9X8BmYmygIP2pxuiKIYg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951269; c=relaxed/simple;
	bh=0j0bW2dJVlQyfciGyUukKM7NZqshTY+KAtnvpmpIVCE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FLlA/7MBAiWfZKpsrhhRdxvU8p/THHtP3nHB6KgKmSEJfVOPOWfdGY9K6QwIpHxct0D/61L0pFx81PPYiiDuXtG7MfVNkeNDTe25fOF0G1XAmKeCQ5qJ0WCW4IASLfCFLUxdvApP8LByWd4y57/UEZ/vS9eIRXbtrDLvHR0o1ZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WdbYvq0J; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741951268; x=1773487268;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0j0bW2dJVlQyfciGyUukKM7NZqshTY+KAtnvpmpIVCE=;
  b=WdbYvq0J+B1Q3yqmryDooVg7IE6rjsA8+SBZoIXK40kaIMHUemmdJazw
   yBOKXSJMrpjaP4Mi+5xQjwyyM/Co2Jaq+JJCc8aWVBOlU8Gk4XaX3bKbg
   bXzAOHtjKQX1hRqGVj+0QXMhKNAATrdsldHJUqEynbUbJFcKc8YzreFOF
   pN1KEeG/CAFFtl4G8f1tg92Eq1/gghtDsxwF3HKLn5eETQUy9ZaB0N0uk
   Q5qvrK4l6Q8rPpuyJTfwnxjmyRSKg3hqjpJMbBhkKJj9FqNPKq0CZOX7Z
   HZ+yNGtK9aG6lAx+9NfihPCLWFZj0GtNwf/ToAn8UYDOXN+bOBfZI9T3S
   A==;
X-CSE-ConnectionGUID: xJXHWyIARPu2sk7wqgOk9A==
X-CSE-MsgGUID: nktSiJ8UQ9y8vAbiHnq/dw==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43133445"
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="43133445"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 04:21:07 -0700
X-CSE-ConnectionGUID: tn5ThUazTIO+qviwhqy8bg==
X-CSE-MsgGUID: yzulfR8gSc6abyRY5OYQIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,246,1736841600"; 
   d="scan'208";a="152113962"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2025 04:21:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 14 Mar 2025 04:21:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 14 Mar 2025 04:21:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.46) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 14 Mar 2025 04:21:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qa83+oRmfUmnK8cY1Dh9Dm2smARUaTpQyPTFeKKgmwqLT+3rBOZbl0wVFL6yJ21MJDNyCk4rCWA+GAt+vTTjxqiBoMRZNkcPLHBPsZ2Na5kJDtehkJi8WuaYz2wesYE1hH6N/pgqp6p2pcqvcVLPYVQ1nVc5oXbhKJ5Wc0O0tVFTk2E2BEO5nzQBENqJUCAyeeoRFpqd0BxZK5MGrVhKXLvj8kseYhCUhfMRUn/3w/KU1Nhb5sB0CBC566rUrf+P+PJBmkSdUjklByyI6Ki6/yHh6+3UooVS6V700P+SynqirZ5DD6V8dmDVtQCIOXJx39h54D4s5dtJCF6FKwp/LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WnQv5qlPuU6qG1kFlP8WKN3IoTsTH0EgSVN0h/CSRBY=;
 b=YWJenkO/IpoSiux6vLHNyXr9vmTIyqf1NAJu1uSLHOwrEfDUNvqYovZHIlOTvkEma50Stb+Q8bg85/7vMAusx27DnaiW8/HXqqYmxHoWDqjmZ8jm9PkMEFerzG3/3iqCOI7fVyhiW+GAvBCqTgsiP5Vm438YCB1sqJlyl5KoaCRWFXakmXNcVEWLc2DNpolrJl2Z8pbd1iXDNMb6Fselg/cV+6nWr7kKSoRtv1TyNbtOtkWJCANeB1cedh2SF85UsRiN6exQtkBmltji8H13Iq/zUzcDuaDUlKrxpcGU8a8G+oMGVv76BXJUKq05BWeYQ1OsT2RCuq5mbuLjscALkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4913.namprd11.prod.outlook.com (2603:10b6:303:9f::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8511.30; Fri, 14 Mar 2025 11:21:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8511.026; Fri, 14 Mar 2025
 11:21:04 +0000
Date: Fri, 14 Mar 2025 19:19:33 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: David Hildenbrand <david@redhat.com>
CC: "Shah, Amit" <Amit.Shah@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Roth, Michael" <Michael.Roth@amd.com>,
	"liam.merwick@oracle.com" <liam.merwick@oracle.com>, "seanjc@google.com"
	<seanjc@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Sampat, Pratik Rajesh"
	<PratikRajesh.Sampat@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
Message-ID: <Z9QQxd2TfpupOzAk@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
 <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
 <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
 <18db10a0-bd40-4c6a-b099-236f4dcaf0cf@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <18db10a0-bd40-4c6a-b099-236f4dcaf0cf@redhat.com>
X-ClientProxiedBy: KL1PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:820:c::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4913:EE_
X-MS-Office365-Filtering-Correlation-Id: aadd13da-6eee-407b-2e3f-08dd62ea4ef9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eugsxsAe/qgi01vXIHp0erhyTwG86i+mW9slr+0jrIXbAwEesB0IBOFU7+a0?=
 =?us-ascii?Q?J8VGAA48ilTbqhAHukBAbx8aZUhseAX1heDCBk+hvz+TH9/im6oNb+s1rK5O?=
 =?us-ascii?Q?PC5juSh9pCTwmn1M8pH7rACg9JzrzoxaAkfITtkIuGihk+4tUaoN0XyYT10D?=
 =?us-ascii?Q?dADJaQqUc0Nq/ZR/ss5GLmpMqmHSA/ajjkJLJgz9msCMe6TVfvgic3an2IFa?=
 =?us-ascii?Q?NQ9GQZk+nLs4vfulfkN7PtrAY9lO5o5KZZtfnjNS1WmQhpFmNyyCKIBsVgsm?=
 =?us-ascii?Q?XvnsZEOfB8ML2d07t/bb5Tm7Sw19Ji3oadg7Jh+jDtXjONYyDRjk9Pywk+gM?=
 =?us-ascii?Q?9he4LTGAC2yIPmooPKCNIFmTzPaoydHHyLVmyZvjvrdA2hkkpgVCF1pOaunl?=
 =?us-ascii?Q?5h8mAGILGs45fBV5Fh9CywK/8R8b3kzQiwRddoltSPqjzoJgtZQNlfIIlabO?=
 =?us-ascii?Q?yjgk7dguTC5BF7HmkqZwT/eVpz9XifztNj5USacc9xMAevq22SHx45kJOO0Z?=
 =?us-ascii?Q?e6UtV+jsMpLVpVGuNQh5b+lGDtF2YIYyquFiFrseGx/Aelf66a9vf1WDLU9O?=
 =?us-ascii?Q?mAVR3HEu5d6gMzamdbtW48kouF3ha07Ht//9RE1VWw9K/Xm7hOx7Yus9LbIv?=
 =?us-ascii?Q?/4fHXCRVynnHIkbERbTd3fPRanWAvLjBMbxkVtfooF4ML06Eg3ftPsjV6tjK?=
 =?us-ascii?Q?dfJ01qe1b/pDtSyRBc1T8SFhsv+OJesy4POv9EpQfpY7V25/X5VeET9pWwEz?=
 =?us-ascii?Q?x9rFJTOhYtF+UIt7RzJx11iNtELUmKPaw0TJMT/usI/73DTBQlCDr87z9p+R?=
 =?us-ascii?Q?X39+wQIXcQKpXbHOEtj3xfzK7qjUlEhPBndHGVpMuQGxBC1aMGo5YDrF8rre?=
 =?us-ascii?Q?CtKtLVj9xRIBUOB2L+xZS1uuMi+K5BVk8Jev8ATALne5g1DMeH72wxrPFVfL?=
 =?us-ascii?Q?+kX1x1sd2tBF8FnwZqfxWaGkXxhL+U0ULilfOrkOsTKFdaCx8I/7BYwBErVj?=
 =?us-ascii?Q?3psvXxfAn51eBIovhz7NvRCGObtoVN/b7IjDmFxx3qBzC9+iVXGPA9Nq5YrQ?=
 =?us-ascii?Q?CtK1J+ByZZ4AZNAF4GGxN9g61daO1uAN8MyRZ39akGipMXBpf34bSUDdMpbL?=
 =?us-ascii?Q?K2UMfRlMor6KWLMZoG5HOTRX8ZZakEi4Zb9v5pSBkLerTMwIo+HYuIbQFOML?=
 =?us-ascii?Q?t3iVE+KyfnOYR4AdiXLevaP+cLNir3kIIMqcPvNmdQ33tjnD+0qmiKRPCAHb?=
 =?us-ascii?Q?JbRyFNbxfW8T+rHJvEfB8O0AIbsXzO9VXSoqNLv9OQX5+GIoz7laZvvWu70n?=
 =?us-ascii?Q?hjl1OAyExtisNgABnngJtYPF3nhrnPsI6iOQv9kOAUnFoQ5KmrjIwru0hQog?=
 =?us-ascii?Q?UNY369Gkr04BeMjTYWjDVdMAPx6e?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iyLWkZFUPppCBzWXaTRsVMRsb0Z/LumPr0He4T1tQxzyQ9MYzlJe+HqY6D0/?=
 =?us-ascii?Q?gAU1choSS27FZf/fIKdL6RXWau249Dekc8TfB0NnbsPs3rC7eGWfwbEORKi1?=
 =?us-ascii?Q?w2FrPD6dccSZVtEIdWqSJE7clrZ0jWeeGS2+lKwTNxEOELDk7MQ91zVurbIz?=
 =?us-ascii?Q?86o+fbhemCzh2jZX7EHHcS1WGiI0wEHY1/H75uZH/0uANAAoM/XLUtsvFwoZ?=
 =?us-ascii?Q?Xf0foqBrj3C0njktYvuEjs/qDuFNz17J/+iuvLgrZX5oMOGBKx/i2Tyh8V8G?=
 =?us-ascii?Q?B82JBy5t5nhoJXLbF22l+hs7YVUepr2weaWY0bsmiD5pRnDM/6GIksiEvwWr?=
 =?us-ascii?Q?gy9eXBr95wJU0BnF1Jt+qn+cPLc8+mlyyQq1xs1ZZQPThO6j8snikXz/sZU/?=
 =?us-ascii?Q?YIqfUj47XIIYeV9t699piIS9I9iHeVHas4eRx1Cxwbx0aP5UMxn4RWIH5wE7?=
 =?us-ascii?Q?CnH3zf6FzyyNwLzqySwFOuZ/4ShrUCcIJYIfrMkkYwfiOxIvfQFBE8BVJLI+?=
 =?us-ascii?Q?7QaJ9whvST/y7CkxAmhFnvKe0nm9j9/h+Vkdccl2rOpnXCtdmsxM+UWUdSlt?=
 =?us-ascii?Q?S9KFQSXHW2AM26WQxyyGstglq9XfatWHao4KEK95dJwFk9zwgqXV4i86VVOc?=
 =?us-ascii?Q?h2HIvcRYMfhIMqAuNo4GTuZPZs5OdSy0J4aNAoSQfCHm2oW6TaQGP33VfQ6Q?=
 =?us-ascii?Q?iXgbqnKRoFNLfrGfp/OwKisuRxH7IaQS/JThvsxEA5LfEn5f3ocoCS+lEILT?=
 =?us-ascii?Q?ScG0w13vjMOmI2X7W8kszO+dJetJ/smVQpZ20pZzufD/eszG4ArVdOYXj8+H?=
 =?us-ascii?Q?Uwn7q8wyS25ygQyWTJ6JkMSJZtmErXuPjBhuF3QXJLZihcqraV+B4WQvz76W?=
 =?us-ascii?Q?X19XkPct25HG+SWifjANkSDwvCfuWMIvHZa4Qm4xqh2ZUqnaWxSGzrQ1u0Ax?=
 =?us-ascii?Q?2VsHcmoUAkNF6KYY7F9EuQe6CcQTOGZPogLUedIsZVrUMnaBsA/i2eaZT2q8?=
 =?us-ascii?Q?GkoHTmdj+rufge8cwYrP5T/C4jiLcK8Lg3jQ+Sl2Dft28WZl4YXbC2ZYYuMB?=
 =?us-ascii?Q?oBv5kQvWnCxjzxeRYlo+irdl7K6WwKlumEMae6JqLveJ+GIVX8wFRg7JWmB7?=
 =?us-ascii?Q?LrGRtO+2eFJ9bKoa1GVP/CxxJZX494tVxHmx1tVnqpeoT1+WAChIzREVkS4r?=
 =?us-ascii?Q?xiC4OnMCXtTxfsaHJTj4B2+h9/b/qsgdncfjlKM7NhujaEZ6/YWS2Dk974n8?=
 =?us-ascii?Q?aR1g3VjS4OrhY2J7xDOavQYh6nYVLqWL/4VC+ybGyfbsBdXqcBHH4wDKKHep?=
 =?us-ascii?Q?YXuVG4DsTyKOLujAZhcTc3oenA40wX6raWVTFnI5+JCEMu6gHJKAQECd9CVb?=
 =?us-ascii?Q?xuLtp+dvzZ+JhXFxuB0v1tP8D6jsYCCPFbedv/0vUoqxR5VRuww2PHg83U7u?=
 =?us-ascii?Q?jmaukV7rHy8peRlP03kYzXhRDyxa6kXX1LR38trvLf1KRR9nkU0xWmmxz002?=
 =?us-ascii?Q?BudZUE/u9aBTAuwa7MUQcMMlbubm4HYOdbqq0fNoq6mYc/5O2elDwTNbX5o3?=
 =?us-ascii?Q?MO7uaq85BxqOOPTdJbv+AjmRJF6uRC4/HWT1lM8t?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aadd13da-6eee-407b-2e3f-08dd62ea4ef9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2025 11:21:04.4685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rhOBRiTVzXUKofVE4V/fKtWD9DNpNucg27ACvnq+CAWmb+7+dT3PFwql47EAuUHiNftiuGT3zf0puayg1e8vUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4913
X-OriginatorOrg: intel.com

On Fri, Mar 14, 2025 at 10:33:07AM +0100, David Hildenbrand wrote:
> On 14.03.25 10:09, Yan Zhao wrote:
> > On Wed, Jan 22, 2025 at 03:25:29PM +0100, David Hildenbrand wrote:
> > > (split is possible if there are no unexpected folio references; private
> > > pages cannot be GUP'ed, so it is feasible)
> > ...
> > > > > Note that I'm not quite sure about the "2MB" interface, should it be
> > > > > a
> > > > > "PMD-size" interface?
> > > > 
> > > > I think Mike and I touched upon this aspect too - and I may be
> > > > misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
> > > > in increments -- and then fitting in PMD sizes when we've had enough of
> > > > those.  That is to say he didn't want to preclude it, or gate the PMD
> > > > work on enabling all sizes first.
> > > 
> > > Starting with 2M is reasonable for now. The real question is how we want to
> > > deal with
> > Hi David,
> > 
> 
> Hi!
> 
> > I'm just trying to understand the background of in-place conversion.
> > 
> > Regarding to the two issues you mentioned with THP and non-in-place-conversion,
> > I have some questions (still based on starting with 2M):
> > 
> > > (a) Not being able to allocate a 2M folio reliably
> > If we start with fault in private pages from guest_memfd (not in page pool way)
> > and shared pages anonymously, is it correct to say that this is only a concern
> > when memory is under pressure?
> 
> Usually, fragmentation starts being a problem under memory pressure, and
> memory pressure can show up simply because the page cache makes us of as
> much memory as it wants.
> 
> As soon as we start allocating a 2 MB page for guest_memfd, to then split it
> up + free only some parts back to the buddy (on private->shared conversion),
> we create fragmentation that cannot get resolved as long as the remaining
> private pages are not freed. A new conversion from shared->private on the
> previously freed parts will allocate other unmovable pages (not the freed
> ones) and make fragmentation worse.
Ah, I see. The problem of fragmentation is because memory allocated by
guest_memfd is unmovable. So after freeing part of a 2MB folio, the whole 2MB is
still unmovable. 

I previously thought fragmentation would only impact the guest by providing no
new huge pages. So if a confidential VM does not support merging small PTEs into
a huge PMD entry in its private page table, even if the new huge memory range is
physically contiguous after a private->shared->private conversion, the guest
still cannot bring back huge pages.

> In-place conversion improves that quite a lot, because guest_memfd tself
> will not cause unmovable fragmentation. Of course, under memory pressure,
> when and cannot allocate a 2M page for guest_memfd, it's unavoidable. But
> then, we already had fragmentation (and did not really cause any new one).
> 
> We discussed in the upstream call, that if guest_memfd (primarily) only
> allocates 2M pages and frees 2M pages, it will not cause fragmentation
> itself, which is pretty nice.
Makes sense.

> > 
> > > (b) Partial discarding
> > For shared pages, page migration and folio split are possible for shared THP?
> 
> I assume by "shared" you mean "not guest_memfd, but some other memory we use
Yes, not guest_memfd, in the case of non-in-place conversion.

> as an overlay" -- so no in-place conversion.
> 
> Yes, that should be possible as long as nothing else prevents
> migration/split (e.g., longterm pinning)
> 
> > 
> > For private pages, as you pointed out earlier, if we can ensure there are no
> > unexpected folio references for private memory, splitting a private huge folio
> > should succeed.
> 
> Yes, and maybe (hopefully) we'll reach a point where private parts will not
> have a refcount at all (initially, frozen refcount, discussed during the
> last upstream call).
Yes, I also tested in TDX by not acquiring folio ref count in TDX specific code
and found that partial splitting could work.

> Are you concerned about the memory fragmentation after repeated
> > partial conversions of private pages to and from shared?
> 
> Not only repeated, even just a single partial conversion. But of course,
> repeated partial conversions will make it worse (e.g., never getting a
> private huge page back when there was a partial conversion).
Thanks for the explanation!

Do you think there's any chance for guest_memfd to support non-in-place
conversion first?

