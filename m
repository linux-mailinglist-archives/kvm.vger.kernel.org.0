Return-Path: <kvm+bounces-71577-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNgcOkcUnWkGMwQAu9opvQ
	(envelope-from <kvm+bounces-71577-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:00:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 90BFB181382
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 04:00:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DC460303F453
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 03:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FB623EA8B;
	Tue, 24 Feb 2026 03:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dZE24pYw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BF2417C3;
	Tue, 24 Feb 2026 03:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771902017; cv=fail; b=r78R3lI4nCYlpIOgVTwSzdg1y5RNsghBWVbbga697sTl0tmr8OJPY5+RcVpPjOmPygX2LueKvdFj+PB3PgXCk5WEhLXuXVuT9dc3nDY7LrIkgFxJ7d06LP63bv86NxSkIJOJnJ+sGYN+cWIkZdGG75PqR4cwmcHkcMMNFWCdhRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771902017; c=relaxed/simple;
	bh=b/ag4dT4U+KA/77s43n7z3oCeg39SgZ8nb3IcHkZw/g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rxH0Cf6JEQuV199owo3KNXce/rptJ4KmoGCvf/OiNueIDPRjEpPf0cIu6HTIRFWl4gL94U88R4Hh31ZkRr47fYDMpWyFCOILld3v3WUNjDQpFQjigNUcEbGkYm1utqAFvaVfFHhi1B//yM6yciEMmMmOJxB4mYZtpeYsCdhYmm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dZE24pYw; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771902016; x=1803438016;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=b/ag4dT4U+KA/77s43n7z3oCeg39SgZ8nb3IcHkZw/g=;
  b=dZE24pYwhBJU+BlDtUKibzF3tCU1JhHc+piNiwYgQhVwe9OtXcoCuSXG
   8TwBlRCdDU4LxNE/I7pmkoskLBYJQuDMYH9LBC4xnsJoOfLhrG/xtVv8i
   axn1MwH0nQ2sm1HHLZwPcnNKyeK0/03B7AeED+XYpdbXxQCx5Xq0CvOhb
   nJ+VsluFG8oYz+3s4uZvcmRVcgTpg7+Qp6TGi5aKPJRIY3IgcHurVpDbg
   xjXOnKAFzNdxJ5pYF/V9o65modpjYKJ1dBly2fiIp83Odfr/UlAV8iTQY
   h7n7X8CCjeKMYJYNZS0VfmQn+Rdr9im+YuVvwXZL2+299LRm+gliVcK0j
   g==;
X-CSE-ConnectionGUID: bjWI0xmiRSK8giwVwSkISA==
X-CSE-MsgGUID: zQs3FPREQYuF8UCRQHBQmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="71940561"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="71940561"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 19:00:15 -0800
X-CSE-ConnectionGUID: jkmGgJ7KTWyrikrunKG6bA==
X-CSE-MsgGUID: 2rwpZmDhQ5W83YzMjnlLEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="214044326"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 19:00:15 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 19:00:15 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 19:00:15 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.60) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 19:00:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wW/K+17sbFN0wS3yhsmw4cNb41KMDKtMvKRbJZdEOQ90MYLWac2Pf5KKYUtNNzR8G2uUrg6VEIRP8uvhrqtEApyGKRoF4DGCoyDqG+2Vl4cPjiW61O2bI1/AcltEskVSlin1PetiRo3gYISErD/Aak8l+VZvtU6zi4tacWTFcbRJZF4PYnrnAWjt+9dmJqxc4zUA1DoeRx+GYdL/RGsu2BY0i51YusVxaGnzUUBz0n/qsq7CaVto3ZUDpNxhzqEZaytyY7WNq8ts9YEXgVgM4mIf2L9IFnLRIoUgJoAfKnaaCyLZTyZP+AY/FaVSgmufzDzAyib91zAQ7RVl0XZ+kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kWe7cjTCkkiX4CGK1qUtMRBV6Dsm1oZxlKT8I6Y9Jqg=;
 b=XZHlrSurYlH/DsxM4yGbh3M7zTpXK95ufns8Xgl/L2f9EclLMbzYtoxklivFcArL1J4+NInHImjyWybcfMVJ304gCyfwlC8pqQcK/Np787Er6Wvn6Y4vEQvl2kXZjM+bBKHi0w60huMiUooMvkPkpbTcXt5LZjIvQ0Z7LR99uIK0TZ5VZ8lUA8874cfi2ICJJ112mvfoSIsjCtGmlsWyrxsafKU1FF0p0byHlWjwE2lKgXPHklcmpsSL5ot8BgbtgS/EVgVb7PoWJ5Dyk0AxAwLttedoOjaGBVYNvrZG7ywfLFCM1LbHveNzjS9RmT0ERb7oE+CxdSs7qei3kC++jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CYXPR11MB8756.namprd11.prod.outlook.com (2603:10b6:930:d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 03:00:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 03:00:11 +0000
Date: Tue, 24 Feb 2026 10:59:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Chen,
 Farrah" <farrah.chen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 05/24] x86/virt/seamldr: Retrieve P-SEAMLDR information
Message-ID: <aZ0ULTpWJpGjOKLU@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-6-chao.gao@intel.com>
 <88141072be073896990f87b2b4c33bdd99f38b29.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <88141072be073896990f87b2b4c33bdd99f38b29.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0094.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:22::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CYXPR11MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: 151ee54e-3a5d-48ca-7a27-08de7350d338
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?kWB9sR6hosL94RU2uVKN1rp0q0JLVpNzvK4SiW0K3m207h5/7M6S4iltAxA5?=
 =?us-ascii?Q?Lum5suT0mgUuxrZQdfiEMmaGginpYtXxYQhDL2eZ0xUiF4hcvT3ZQ3h2WDM+?=
 =?us-ascii?Q?aS6mfs+JJoB8lSnbbBLewKhB7GRNSg3s6xfOfJI4ATj/+y9cqEZC2AEaJvJU?=
 =?us-ascii?Q?GsmIgyt4KTvj4FW2BsHVH7yfgdR7wM4wMSicB6wb2C53/KvSDMJs+YALi93W?=
 =?us-ascii?Q?bPtEM10umGnEnreSSL1WDOo02HgD/XYE8gyk0/wpNoDwYe/AYc2+ojk/Fwme?=
 =?us-ascii?Q?MrChJ42qiKqZs61VXvnKvah6/1SMNlKbReu++rprpvPVp65grqG3gwSAeMPN?=
 =?us-ascii?Q?ihatg1RRm+wAtzU4x+qqFB/WvHT9l97Eshu+kmKhIvOM80XrQYiihVFjPu4x?=
 =?us-ascii?Q?aXq6ijVXdOVZeEmMgOKr9Lmjlw7KHW+4R07Tc91n2AM3kWgI9aE0aaa7leDK?=
 =?us-ascii?Q?wSx6NYGq6byJyXS+hlXQcZl1vr0bAcR5FNPfRjVf3Ch7fPmXwdXysKIDGjjI?=
 =?us-ascii?Q?erTxytPcumSBvZRbTNWipF+6ststTMcNseGjIqgrgJpqhpG1F4vdkM/c0EyM?=
 =?us-ascii?Q?AYXouTOPzDYyZcTl6/JO2+2B+cXI+T07SJv4YrNE9z1+3EHyrCwgls5KeJMU?=
 =?us-ascii?Q?jdwPucNhMqs2HnrSFO3/RCMGDAKRcn0idMGkrDKDHChn3JIu+u2/vkD5++fq?=
 =?us-ascii?Q?ZL7804hqhEAyQtuMH/HMH+SHTH3Ebk1Wom/AT0RTiQBqIq9iyGVcZoTNa847?=
 =?us-ascii?Q?2vReFc1c5LCI1YMNBJFUfSjQXq0BmO70aFLRBUksMfXFjF3zCclBkqtXf+SX?=
 =?us-ascii?Q?I3SZ5Med8Ns3ioOBZUzedY5DAJbPQLde2OrddLS2WT0WwPYyhUZWTlcgyIsR?=
 =?us-ascii?Q?dtW9ytgkcpNheqixaqJCD5HadFc4q2dcpH1+Mx3s2ETBpkz8iXgWMjxLmNq1?=
 =?us-ascii?Q?NBXWOlebS3mw1W5RzFbBTnIhveAg1BJH4ni80q1LaXoxQA0YnIJZdN10iHc7?=
 =?us-ascii?Q?335/PFMpM+DhYx++HYubcR50rD66Chl2K1QE5+Xl5oIiCBAyyrvnKkk2Mdl8?=
 =?us-ascii?Q?AoVK4/i2ak3km8B0+KeMpU3dw1VQZ7sBPzkZJs8OLZSZQ5srdnHWaJib/C/Q?=
 =?us-ascii?Q?3Nq1XaqPmXgQnuwkU6a7ff2SmK66QhTvUMoNfnrFaFUBWxztY/iDKIgr4Tmm?=
 =?us-ascii?Q?4iACHQhH9ewlhLU7tNeoZLigTJDvinhXopu9cxtYgnucXyAO0Qjqx09j5g6w?=
 =?us-ascii?Q?LqoLviiHX7ICvVn3zOeN1aQeHP9L7svUKJchsYFdrTJLM4bEdb5Rnysp+7Qz?=
 =?us-ascii?Q?T1rtNY2PSM5A9cgZ1k6JgQOW6Js1HI295AbZUFk4L0E8NvwDur8bR+qdicAw?=
 =?us-ascii?Q?Cip6Yyx2EjFAJQczKJqVTHRDM+rRn37kaRWdugNZYInEwZuWc8DFr+U+hLSx?=
 =?us-ascii?Q?5Fmyf8ZDUHNGZrB0SYxCrEjIhObhOMTwqkOzALKi7qP+N2MaQDrcJC0uJqyb?=
 =?us-ascii?Q?VFUnm08tujmwNCiNiJdA2mFhMqqxqhfIFzFzfod9q77De8x/XGKkU38mszd/?=
 =?us-ascii?Q?mF8ybRoN+6XZcMEYldk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NLHKjbUigWyDrmQUD05kuwEdCR0yBtUA3/DWEcu9yCS4Wpk6PlvBTryQAB8w?=
 =?us-ascii?Q?9xEfTj3C+NHov/uUGZHu7po8za9PZC0cXBz9lCs7f27HoOI2aYXKgKZHvdSP?=
 =?us-ascii?Q?dVxVLemlXbyqsBDd89WG4hEwAKGPGwTrpkgUXYhwV3b7tc4VdEMToEDBy4Sc?=
 =?us-ascii?Q?RpVk10wL2Q2rangS6rO49kCozOpjc3XgnQjPp8uIzvL3Z8pVJMUqswG03pvI?=
 =?us-ascii?Q?SMLF/iAGy99RL25D8dTa3wVCZK4VdKK9/LSerKfM+mBddMM8+LTuXjnHtDFJ?=
 =?us-ascii?Q?H7iYASWOo3keC06jBvCX5ebrYfAEh1yOA60U8r8djKsx+TvjPBJYqi1P194i?=
 =?us-ascii?Q?IuaaAFuDyY9WLLcczgJ4Mj3FcMtf0VHCwkv8b1xBpCErz5b5ZYIPPyzsz0bj?=
 =?us-ascii?Q?wWzud/mb9RcC6wJGrgxsrcxa6OabFPYEVaNw/52RDZP9AKkUSQCXQV5/qoQ+?=
 =?us-ascii?Q?UJR8wsy9wKBhERmQQ7V9RkhuTnAXv+WQ5921Myep9KmGBsyBk/4ywecLzvgi?=
 =?us-ascii?Q?10h8ajXuYVdmDV0otNtlRySqvLR0jqGer9beyTNEWUB8hVA/3gdCgf+L7lJO?=
 =?us-ascii?Q?k5mQbk18b43UdOoJ1mpeBvnYF1oPwn8KQzLdaN5uC/fcD6YqvX4LdgPl+7JO?=
 =?us-ascii?Q?v2X2eYZfF8Y/HWnWjFkaRYsdUZ0DUchtRQYnZZ0MKfqm2FHsUmTeZMP7s5kS?=
 =?us-ascii?Q?QBhtqKgPVFG9JOYrCrEdI20qga8kpmSEz3wZujrrZxFnjE45bIAkYYnxDceA?=
 =?us-ascii?Q?Fxyc+NwIEOExfslQrTq5zyKjHGwZJqcz2YpbU71sNpOV9oMHeXLa/ihBWi9g?=
 =?us-ascii?Q?BDlKXpKL53sAykwiGZv196F3KWKTwDo68lwAco6LKPc9/eYYX1WkYWE1yfif?=
 =?us-ascii?Q?vE8iAN6d/x35Z+NKFKyByr1Yg3hXnvSHBVfLtmZqOsVl1+xKwbDYhvWVbQqF?=
 =?us-ascii?Q?g8OLNOo+0KgqYTWqFGXZ3gjocsYVBmQctRKddmurcaCTY8VbU29/6K6h7ROg?=
 =?us-ascii?Q?9BATF1sfIVMDBRxBB3JQKW4WbaG1FX25b2Mr2puEs/jjn6drLG8MDPc4xxsF?=
 =?us-ascii?Q?ZeIdEznNyPnwe/2K2CS+89mhR+W5IgKoOgnH3rxwVW3UURlOW0VGRfEQkfFK?=
 =?us-ascii?Q?pogmzGyJNMnUve2AXBvleJpfEevpbaPy5Ot3pISSD0S2LKalKul0X2lIZCVK?=
 =?us-ascii?Q?qrQvUhVMI4d3wK+W8pa9nP/IHGeRdOlBymzcJHX2SI3ZahPivGKE0sKG5pxi?=
 =?us-ascii?Q?AQiDgT/CZoY1khCkks7XXcX8ZOyuer9auRBf4qcX6yx8NtiXwSdu+uazE+ul?=
 =?us-ascii?Q?1iv8EpgO58Z5abThzVH+4TIC+wRGzkci9qs3HRn1Lhp7CCgMFCzHsmdEWsnL?=
 =?us-ascii?Q?TcY7BJzqxQ1YZrxRjUzQWT1ArQ6u24TgPumKH+6rEuI4gkeTHs6lbrVgZT5s?=
 =?us-ascii?Q?sqEtMvdOV//1GroE6eDpwD+JoNzN+U6PsYhGYUpAYruFS5rbOMDVVmKLEp/U?=
 =?us-ascii?Q?P5gMPBBJcaUdKdGnFWLiA9b1VJP2z0/LcvzJaQC6L6D8OLASzV+HGGRytGtD?=
 =?us-ascii?Q?o0y6dx20uKW8WGgDZTUtRn54ufKh8O6AwrK2aRStAxc9hrP4/yzwVRJi6X2t?=
 =?us-ascii?Q?GD+ymNdWir3K8V6BLXZORpO9RmmrvxWc4znmrqohq4kyjSZlEbA1+YC/dEE6?=
 =?us-ascii?Q?8BxJBez0U1lNjOsdUjC1Y+fOCjwL7buD/lPsk1JGuywyV8yfdkl0mJiHO0ag?=
 =?us-ascii?Q?5pdHN/LZcQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 151ee54e-3a5d-48ca-7a27-08de7350d338
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 03:00:11.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6R1H5/zS5+y558Pocm2wdTDxxuM8kNk1IRpk/8iEwIkR/p54fTtaAO9iTRREnCAYqf2W5UVmOGLOGfPw8e9mrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8756
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71577-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 90BFB181382
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 05:36:33PM +0800, Huang, Kai wrote:
>
>> +int seamldr_get_info(struct seamldr_info *seamldr_info)
>> +{
>> +	struct tdx_module_args args = { .rcx = slow_virt_to_phys(seamldr_info) };
>
>Should we have a comment for slow_virt_to_phys()?  This patch alone doesn't
>really tell where is the memory from.

How about:

	/*
	 * Use slow_virt_to_phys() since @seamldr_info may be allocated on
	 * the stack.
	 */

I was hesitant to add a comment since most existing slow_virt_to_phys() usage
lacks comments.


>
>Btw, it it were me, I would just merge this patch with the next one.  Then
>it's clear the memory comes from tdx-host module's stack.  The merged patch
>won't be too big to review either (IMHO).  You can then have this
>seamldr_get_info() and its user together in one patch, with one changelog to
>tell the full story.
>
>But just my 2cents, feel free to ignore. 

I'm fine with this. But let's see what others think about merging the patches.

>
>> +
>> +	return seamldr_call(P_SEAMLDR_INFO, &args);
>> +}
>> +EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
>> -- 
>> 2.47.3

