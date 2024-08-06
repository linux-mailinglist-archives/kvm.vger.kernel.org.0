Return-Path: <kvm+bounces-23299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78E969486E8
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 03:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C4E81C222A9
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC7E5AD5B;
	Tue,  6 Aug 2024 01:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R8Linlff"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DAC8F77;
	Tue,  6 Aug 2024 01:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722906848; cv=fail; b=DGquV9IwcL5McMmFHecWu4BJfDeV0XRZiPgVNvf/fx7RdiWVny2NKjigF270dDH/2G/Kwt9drPMoOTLAHMDbXB1YD3aAUaYGVdfNlfQ1E5/Jiqf50RlYrkvr0l/m+Q6PqfXsQnYXbXqPDlFUfo/ECIgghDfiWOqvAhRSE3uKdhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722906848; c=relaxed/simple;
	bh=/QY7GBUDUSCLxqCcwQ3NZwkwcBr1tvBnEQYcPq9WRTk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jt5HvgM0p/2wUGa3py9OG2HcB4ePcR2x9cFoZVlJCw44ipg8B0pnyRqpbC/yVQOqt1wjxd9mNHNbhrFSn7NFwSEQYaZOj9pIOxpNACwA4iwDMCMq4j55zNWkmIaBlijj+Oe6j7O7VkXeuSyzv2CaAdxBDU0AAZcSer5/H4icTE4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R8Linlff; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722906846; x=1754442846;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/QY7GBUDUSCLxqCcwQ3NZwkwcBr1tvBnEQYcPq9WRTk=;
  b=R8LinlffWscVGnwL7hI14VVP5LDzMgUvZETE7pceshV8NgC6aosRJ42W
   o7ZBGig29PLQXi38+/2NZ8RYh8cIPLLGmmmB5PsC9FHnZXb/epCmSOaVY
   ZT8QzFrIklrSQ5BDN24dNczuPSIPundwb8DcE+sJLEMzgPhJfXKP+ewEo
   Zk+x0OnCI2hmOHmxb6k7iyOM+YvYeZcCjTyg+uMtg+/G7pVNO+J3NNJ6I
   IutiNo4VSwsrHzofjc1XYpZckUiTZ6OPlCsiir94SN/9+ex2n246siUsZ
   C+hJhAAhJLQvfDb/xBUnoX7LTZq0E2TQlX1Bl6XT18LEqcctFHFmR/ahx
   A==;
X-CSE-ConnectionGUID: 2kMhYm9RS62qDlHReXSEGg==
X-CSE-MsgGUID: xmE5X56sR9K+Zoc1vOhWGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="32279994"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="32279994"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 18:14:05 -0700
X-CSE-ConnectionGUID: 4nt1I2fISwuBA7/NYUIz1Q==
X-CSE-MsgGUID: xcAKHw8ETveg5IGQtxR+rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="79597445"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 18:14:05 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 18:14:04 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 18:14:04 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 18:14:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jyvQgd8H/8nNWrYfYhZnDOjFF60TMlIobKoX+9knTmyb81QW/gpqhzT8CVljrvvHnLFkLx3buIIMigzA2XyQ3lKMuc+9uNVmdCthqB4NgCNJ7Qx9y6ouPNtI5xQqiM5EQTg4LG0zU44OYCa8Rb+Z72vitp8Ml2ZWxttHPoo0cPSrR/f9L+srbE5IsTcvJ5sgcrge7ik4m7OYKGMSjGYqR73Vu4WvihgnDc6nYIDO6XRxPtWRjbJ07mf4F22P13Ro/mQrog5Az8mSONDZb83SJDdumNU3m9jl3zA1NtjrxX+bYB+i2rrr3mxc4O6lwXI4MYXEeGzWQa74hA8ZJoHQUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9rNEH6BuG+ZUcc+eg/R4qSMpVZZNUSLtTJTuArMFP/s=;
 b=KG0EWyfw7IeTOeI+npgPLmL6VFtcqFdZ00gvglOVrkOzaD0cs+YhLkVrbBNMR2Y9hRU3NboBXTcwACMumD9gbGH5OKM5cEQFV0U+5wKqnPmD/ml9nqdoxYRBryUFtLGO2yTNOtBpwiNmxB3e8cerjremTV06DOiq00HFvIEFAOHvRXT+rl8Z5Bj+zg29rVMLrYwAAL2NwzumtD8T8MlKtWCAraehO/LYKa+cJGBIwFr5+fqAi6nrAu7vXWmG0HcWsTNpQs7kgFV3xOCV9sbGijs3Kfe1T0TbAJ15YBN+y80aQ9+QyYps2jTjuVdAxQjARmSfx+lDimz/LEcy+ql5FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CYYPR11MB8359.namprd11.prod.outlook.com (2603:10b6:930:ca::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Tue, 6 Aug
 2024 01:14:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Tue, 6 Aug 2024
 01:14:00 +0000
Date: Mon, 5 Aug 2024 18:13:56 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Gao, Chao" <chao.gao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
Subject: Re: [PATCH v2 02/10] x86/virt/tdx: Unbind global metadata read with
 'struct tdx_tdmr_sysinfo'
Message-ID: <66b178d4cfae4_4fc72944b@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <7af2b06ec26e2964d8d5da21e2e9fa412e4ed6f8.1721186590.git.kai.huang@intel.com>
 <66b16121c48f4_4fc729424@dwillia2-xfh.jf.intel.com.notmuch>
 <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7b65b317-397d-4a72-beac-6b0140b1d8dd@intel.com>
X-ClientProxiedBy: MW4PR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:303:b6::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CYYPR11MB8359:EE_
X-MS-Office365-Filtering-Correlation-Id: 8347e188-9e7f-4e4b-d9a1-08dcb5b50d5c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OfyApJCO+3yT91Sv7/5u/4XDzKZdJTRVmIpBgpujnvCc9mhg2hD5f/MtkHfd?=
 =?us-ascii?Q?J4kLXWkeg4OrLarFwEGnM+pHeqUQaXZpzs95Eoa5W3p1hNAjTq+EPCajWt6Z?=
 =?us-ascii?Q?Mt8myQN7jgUzcsJwz6ORmG7PAxmqVa/sfwxPAmwCseRkeZaVgD2lOgrG85FJ?=
 =?us-ascii?Q?RdwVONb16gBI/lv8LdCZ1e1c5I7Nd3emKDuAge8eD7OJWOBGZ+NoLn4+3Amg?=
 =?us-ascii?Q?ImOxIG8uxrTE9XRGgjYKWAA2q1Tj4vjfFg5lJp/C9BPCy7zvlnZgeHAfQxp4?=
 =?us-ascii?Q?W8Yke6KP3kswsqQ9L/uBmXe/zKl3F+v8TVjIfwlgsSzaqLPrgUqyNO2PPkB/?=
 =?us-ascii?Q?sln2M/lI69iDfDOkM6LVOXv+zka5YP+MDBrACNpQNlM6CzGpa33nU7w0Vf+Z?=
 =?us-ascii?Q?DFRb5O/4cLhECQJD/5J88uEkDeLLTenWcZ7w/c60bI3lapLv4ZtrHK2a5gpa?=
 =?us-ascii?Q?KW/YlpEMeq5Bps8MXe+fhpy1PEVWIJcaN2eVeujPyrzWaCKE9Ql/Lwys9M90?=
 =?us-ascii?Q?EIReTZ9cTzUrAm86v/ypEv621hP7icOMZJxy0c0luT5bNYOh7I4/91qlaVcN?=
 =?us-ascii?Q?IxEoM23J9A1pvfSWgK2dO6ZWojNom29gaPzEg5e6Bl3Q5L8iQEcbuoeD29Uh?=
 =?us-ascii?Q?w18nWbSQ2FAvKtpqG+lo6RV8V+1oAu9aYXSYbTIX7wQxcTVY+6dUHHQtTCGi?=
 =?us-ascii?Q?kW2yK8mmxslW3payQs5TM3UFP9Czni1EIwOlgyLpRVqLx2HtTq40yuvyxLqn?=
 =?us-ascii?Q?lpYGeyJUCfVXRGA1hrQM19afHcFAdCUpDk6lYaZnWR7izsveL0tILx6AU0FH?=
 =?us-ascii?Q?SduEJEGjh1RRqyXOVdJDdprkUl6TMD6DLD3PK0A3hxKxj+K4u0zic794Mtoj?=
 =?us-ascii?Q?a+8/vO706mutAGTcYcl1oqGBnIfms0vuLdfZ59QZ8bDRGLxZ9XklUxKJxqa7?=
 =?us-ascii?Q?EFmoHdpaQaLzBY6n064rpqhBpD1GsAcYLwvf96y3bByariDRuxytlBg+iiCo?=
 =?us-ascii?Q?AMvrFErhG7/QL9xjWA7eXfOoWq6F9j/aPOrlobCqurPpqIDIsfPZ6fxfrpdI?=
 =?us-ascii?Q?F4aIYVjHXLLENH7D26Ey4k8+WqNnf35oE/wDp8Hkmf1+GW+piUZuZhVf3MBI?=
 =?us-ascii?Q?XH1TZp6Ds4EV6P+1eNW0+ptK4qI6IvNUHcH3h3e78Jh6nzwRO1Tm/6uRT1+L?=
 =?us-ascii?Q?A6gBoNVpxbvMP4vip6gKEAvToiNo6zWH5JFLBB+yxzPRp4zhbNlgin9GsVYL?=
 =?us-ascii?Q?6sJz3kSG4UmhlnEGn+Idzbg5xZDTtFkko8bqVT2l6c7t2aerxlkgNHpWyEmO?=
 =?us-ascii?Q?/9oQK0wLF3S3V6T1I2SBAYUx6w74v7DaVm1pF7IjfUV38A=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l23T6qT5EmePwJ31Qz7yMo2mnnlraMCx6gTlW90vLSH3DNfGDhKXkdQebds9?=
 =?us-ascii?Q?STHg+D5QHtKbtTr9zlfcNUa4OQ1cKt5Q/hJf6DN+1YUjXICRnhhKYEOqAO8B?=
 =?us-ascii?Q?1qbGLguDb1g6UtpBwuUI8DBLnVDtujThURmFQJe4aDDzZtQWNIed1jyQRW2r?=
 =?us-ascii?Q?ZUB+B9X4KHyaU6H06aiXF43yrm+eLalvMYrx2En3VujqYo9mXk6qypx4z2tH?=
 =?us-ascii?Q?2pYgz+b4YB6wgqGSNczH/S7WQiDyVfYu3H+pU+vOTZZhil0JkivmebVTU11U?=
 =?us-ascii?Q?ykx0DqG+S8RGTOrLWR2WY3rkNLU3hbyjyTMxHTM0Tx7km+KfEomTR7hVrQ6z?=
 =?us-ascii?Q?hNnBqeWwozuWvnhoBMmLR4S6KYM4ymN8GLQHDW79xp+i1fpyse8BKvet925y?=
 =?us-ascii?Q?sRLJKYRsu0XJapGrw59TzJmxWbWrJKX5waPslLNDO3HyntKcuhu9AWQRjgkT?=
 =?us-ascii?Q?xwtj8x2CAS1nSUsItv5lBqgvY9DDFbnzZrP8NUx1GWD8E46qYN/xtohDE7Dw?=
 =?us-ascii?Q?Z+1FQgoc+m2yQBJ/LD10bxyy1IVbfB+nO9KIiu81Xpzl0cpI0MGDEsKbw7IG?=
 =?us-ascii?Q?LFurFTN2nces/PgxkH6Bu5KT6lX7WzNL5AMYkFRyEZCg/+IRaFWAmJCMflTs?=
 =?us-ascii?Q?jZ9vx8kNZiayNcrmPpCcjHW2NsEIJdq2/mYZtZUbu18BV2wUBv4Wk9tlkv2O?=
 =?us-ascii?Q?3fh1GDt3C99cavmRoEG75bKlmWsYp/sC/jP4JsdUVYcZgdy88nkCYTU3ysQr?=
 =?us-ascii?Q?wl3LZ5kL3fwxlT28Y6V8odviSU9kYXJykkU4saFa4unUxvaAuMsThW2XmDCC?=
 =?us-ascii?Q?zbqNq8Q5UMv84x0rs6nFm7n+J+wMiF8ZxUwS/dp//genRwQqX78zTNW7hSLU?=
 =?us-ascii?Q?ySn/asxAODnC3y2dltyDI6SwYOaGKJwvzIomQ7p31oG5czlLYqT7X/OsQn2x?=
 =?us-ascii?Q?gh1MtYze4HCQQSVrMaGNlnCEiILHywPxtFpbPDZ8c6WcktnzbJeCtB3QO+s7?=
 =?us-ascii?Q?oTdHGe8naG7oc12RdW8em/B2GRNgjbZCvCtKjUMTMWtHcflJGZsvGqapRcNW?=
 =?us-ascii?Q?fx3Iw3CbkM/1pKQnep9n7qvxVfths5G6PyCfVIzUiX1hPgXSREHq9IQMlAdB?=
 =?us-ascii?Q?NnGfbFhRWJgHuWVWoY4YE403+5Fyg+E8896Yg7L7DnIGabwgI3qb9RzBBXZy?=
 =?us-ascii?Q?jJU5M5i5kePiT3FdWi7Y67kJaE8cD4hcLavla47XEbwMpAcZnRz+pvlcm162?=
 =?us-ascii?Q?wBBTKoTBb0LJKCdiHRqTHpK2ziQdgsNRlwHVqnP19rTqPFQjL7S5q3tYvl85?=
 =?us-ascii?Q?dghxiLRA+Xs/uGyadYJY+vte4sH3hJPQcvzU7ScrCyylSdHEoZd9edrvUKsu?=
 =?us-ascii?Q?1WMw/KJiLVQpBUY+t1sNpF18mGvOSs0fXaxehWSLCJvJvxaHsmSLL8/MPIsy?=
 =?us-ascii?Q?lx0n1nH6wY4Znlb8vqezq4XUHUCg5PfhzJDjCyNC1bo+SKdRhIg+z2g2q4o7?=
 =?us-ascii?Q?B7krF3UbRSXYblW9hU8sQlAIpTjftoZtAyj0/8u0ZTsPtDTmx3TP1zCWQ8ZE?=
 =?us-ascii?Q?FcAwAyCpgBjQiyg6/mbKh/TgsyoF/TUAMB4UHaI6Kd51uJ6zTfrY1kT8NT4m?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8347e188-9e7f-4e4b-d9a1-08dcb5b50d5c
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 01:14:00.7612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8EQHaMNpxBKH1ZSk7WV/38ff0bLlGe983jAC+7irX1FrnTZS+pcv12IDLyCR605kvzHapheygrW5Qi5DYwsacihNZoz2BUCYSBcDBkRcj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8359
X-OriginatorOrg: intel.com

Huang, Kai wrote:
[..]
> > The unrolled loop is the same amount of work as maintaining @fields.
> 
> Hi Dan,
> 
> Thanks for the feedback.
> 
> AFAICT Dave didn't like this way:
> 
> https://lore.kernel.org/lkml/cover.1699527082.git.kai.huang@intel.com/T/#me6f615d7845215c278753b57a0bce1162960209d

I agree with Dave that the original was unreadable. However, I also
think he glossed over the loss of type-safety and the silliness of
defining an array to precisely map fields only to turn around and do a
runtime check that the statically defined array was filled out
correctly. So I think lets solve the readability problem *and* make the
array definition identical in appearance to unrolled type-safe
execution, something like (UNTESTED!):


diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4e2b2e2ac9f9..a177fb7332ae 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -270,60 +270,42 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
-static int read_sys_metadata_field16(u64 field_id,
-				     int offset,
-				     struct tdx_tdmr_sysinfo *ts)
+static int read_sys_metadata_field16(u64 field_id, u16 *val)
 {
-	u16 *ts_member = ((void *)ts) + offset;
 	u64 tmp;
 	int ret;
 
-	if (WARN_ON_ONCE(MD_FIELD_ID_ELE_SIZE_CODE(field_id) !=
-			MD_FIELD_ID_ELE_SIZE_16BIT))
-		return -EINVAL;
-
 	ret = read_sys_metadata_field(field_id, &tmp);
 	if (ret)
 		return ret;
 
-	*ts_member = tmp;
+	*val = tmp;
 
 	return 0;
 }
 
-struct field_mapping {
-	u64 field_id;
-	int offset;
-};
-
-#define TD_SYSINFO_MAP(_field_id, _offset) \
-	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
-
-/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs),
-	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
-};
-
-static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
+/*
+ * Assumes locally defined @ret and @ts to convey the error code and the
+ * 'struct tdx_tdmr_sysinfo' instance to fill out
+ */
+#define TD_SYSINFO_MAP(_field_id, _offset)                              \
+	({                                                              \
+		if (ret == 0)                                           \
+			ret = read_sys_metadata_field16(                \
+				MD_FIELD_ID_##_field_id, &ts->_offset); \
+	})
+
+static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *ts)
 {
-	int ret;
-	int i;
+	int ret = 0;
 
-	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
-	for (i = 0; i < ARRAY_SIZE(fields); i++) {
-		ret = read_sys_metadata_field16(fields[i].field_id,
-						fields[i].offset,
-						tdmr_sysinfo);
-		if (ret)
-			return ret;
-	}
+	TD_SYSINFO_MAP(MAX_TDMRS,	      max_tdmrs);
+	TD_SYSINFO_MAP(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr);
+	TD_SYSINFO_MAP(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]);
+	TD_SYSINFO_MAP(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]);
+	TD_SYSINFO_MAP(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]);
 
-	return 0;
+	return ret;
 }
 
 /* Calculate the actual TDMR size */






