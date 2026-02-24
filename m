Return-Path: <kvm+bounces-71581-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UO+1LTE0nWlINQQAu9opvQ
	(envelope-from <kvm+bounces-71581-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 06:16:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 39A88181D9D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 06:16:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9DDD53069E78
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 05:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5250E2874FA;
	Tue, 24 Feb 2026 05:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EqRhfF2T"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7591DE8BE;
	Tue, 24 Feb 2026 05:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771910182; cv=fail; b=R+rVNHeGL2Si/Wq//UN4LJhpt2ZDbjcLx/W+xIAq4buFuBdFuMGm+Sg8ERPTLBGFLVbq/9Pv99jDmu+F/1SP3jqf8yBBx2ImTSL7yRBbxOqDXHL9ry8oleNAzcBN9Y6JqyH7eSqLmuc3BCYJq1cxPpW4mdiNTyVtHV/LnbXTN4I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771910182; c=relaxed/simple;
	bh=In/PYfLLhThmalrXBEQHONbuIbmLgBgVh2Ikux66l44=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T2O2vewg4Wh1epo7JUKtSG6vG2PB4D2a0sM1oa9C4ZGTixI0V9fWmLeHoNyAIDHczEa+VgpNZQDsGCrEwIrwt99JvIDxmmAGIibK0wmUSAW3tbMd8XYuQF7aCJ76eMAs1csANKZTMfyc6clI8nKAU44xSpkkUJBlLmL2erfTTXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EqRhfF2T; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771910180; x=1803446180;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=In/PYfLLhThmalrXBEQHONbuIbmLgBgVh2Ikux66l44=;
  b=EqRhfF2TX55dgfFhXBm1SiM6ScclZyIqRmJUzHY4iiiHujA35MjjWzjk
   QAGhzgXt596H+M4QVc00v8oHDU+wmHfkj9gBzfiAGoo1zuDvfL6Xmi3w1
   pyjiT5liVIRNI6DhsIchQrI8HOC9y70C/cMvvahfV10Z88QM7pOeoHb7/
   E2uJ+J+cf5ECkcp4W/qa8hVYF8fjvOUC4u3lP4FRc3jGgYgvoax0ov/Z5
   /D5zdP+qPjnRvDfznPbn0mjT5QWuh86ogtJ/z55foteLGk1Xe4JqKjV/w
   AxeIexnTI5FWisbB6PrFSgqpqk5Js8tTt4ixlTWnis3YWVqQxl1QgoeI3
   g==;
X-CSE-ConnectionGUID: NNr1rWUtR5iyNd9yvzyz2Q==
X-CSE-MsgGUID: SxF6qhk4QeOvbzR01TE2eQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="84012775"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="84012775"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 21:16:20 -0800
X-CSE-ConnectionGUID: g2c9k0WcSR6A6bpLebZbWg==
X-CSE-MsgGUID: HXfLEpDTRY24k+BZuNCKDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="246378560"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 21:16:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 21:16:19 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 21:16:19 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.11)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 21:16:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vm2vyc6yCGOYUMe2f7CsgyphUG9uxdr4CWtg8Z2Tz2aJui0PwL/aRKNpmQ4G4B5JBHaNMCX1660FPKfSkyPjJLLWvOdPTve1MSAyyW2fSPWe8tOOQJWw0m3h4oFSUInPL3ciEpdQvsvJpvGe3YwfLa3p9S1edLJzuy4qsrK0FKd0nAhJdoTm973dNf+qI3qtXbcg/lqQhJW4M8AAfIGAL9ue4sKuyP5bHX3KNPqoFjtyJhjqC5nStpKRBBSjoshTcgFL+m7b/zW2+olsdhIk2hrc054pFw8laUZjrR1BrPH5mwU6GicNyL9zHmOo6bDCFLzqU3h7OqqRoQ2oJErV7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQtJrLGN6m5NJ24/t8H6F1wJSYgZIkoQFJeDznIXj0I=;
 b=RIuf3aR4kEAr672ZD+H2+QBEfqmlVzVHOCQqxFqgJDPZYjEcRIDdm8OJJBeNiSWSrVKEhscjdhM7ru9tYP+oirGTCJXQRHxpj8HBWW2uhfq7Gg9NzxGDRKo7Pq21xB0pkVK6uEaowAjjPUG2X2CTsRn7m8seztAgQdBTqg6uMEeJBKKK5l1bmRO+Y0REg+Mfd48+m3wRo8StG0NZLmHsZhUNiON5gAx2RpDPlKFRugNOpxvQWjbjec7NNWXsumdZb+Gzes/AGJCfF0U6EAHSX0q8ZMDRQ4F/F8qnOD6/LJkNH6vQklJw8ohIqw5pbnh4WlN1IL/RBj4SjvgStnQHYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by MW3PR11MB4650.namprd11.prod.outlook.com (2603:10b6:303:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.19; Tue, 24 Feb
 2026 05:16:11 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 05:16:11 +0000
Date: Tue, 24 Feb 2026 13:15:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 10/24] x86/virt/seamldr: Allocate and populate a
 module update request
Message-ID: <aZ00DQ2YwcwfgQtP@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-11-chao.gao@intel.com>
 <1aa733f9066dd85c1d4f880c5c48b40c76d518c7.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1aa733f9066dd85c1d4f880c5c48b40c76d518c7.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|MW3PR11MB4650:EE_
X-MS-Office365-Filtering-Correlation-Id: cda15884-fe4b-484f-b2fd-08de7363d2ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?oWaBycBGwue4JJEPuuT7jSfb6mBVx4DOBBpDrWDrN8Qg4nIekAYTeQ9jEX?=
 =?iso-8859-1?Q?O678ak9ywn3p6wyi2cRe5pazf2yRCvA8gjnnfKD1bZcp/UGxd1uTCOnWGB?=
 =?iso-8859-1?Q?BmWAlrnLLsLu2XCJ8O0oD4VnRO4tPYQGzbZL0bQnqqeo2MEknd2eaMwlow?=
 =?iso-8859-1?Q?RF1ownCLiIIYVJvnoiEZhzAjA1Qy9cOMCNQkGHPNVmfTYYl6bSXjbPwFn9?=
 =?iso-8859-1?Q?Cgnv6EEOFKpK3Zc6x5Fg1AQXKEjH/e0jVVoytysFyHe0og7Pk/KkXlEyo5?=
 =?iso-8859-1?Q?1o1r86/q4/4DdgP1WL/IjuN/uL/uMCxURAFfiPJzr9Knd+8iCjXha/XEim?=
 =?iso-8859-1?Q?Z6tmjTUrTk1ieimlISe4qWHrdO9VhBJRxJ/EOwVctuwmh41Bc+GbBnip1m?=
 =?iso-8859-1?Q?4IJqWLJNreJQp4YBEF0g4ecNMqqPSrqcw7PSK36XSfhU7WpEb5I+p7+0te?=
 =?iso-8859-1?Q?H243Ml2AX67Sx7u9Cq/E12rLFWC0rlnNoDqQZ9D37u0blxsQY3qK/WBkfo?=
 =?iso-8859-1?Q?Pqa0zwjZT7DwwvOlDHTStyXZuRR1sUdNfkKohxz6NHVz7/MfenhowET+hc?=
 =?iso-8859-1?Q?qYRBWkvX7oUfB1HfcJwVyAmSb5JW8lEcg6T7pXCJa3nkSPnx8/oJR4YvQ4?=
 =?iso-8859-1?Q?18rxZYBWWIb8CxMbihYmMFH8BIo+rZ7uxAyU95kXwEpKAhJiwzW8kUf7uY?=
 =?iso-8859-1?Q?J2kLoYD/bkgyxKlIAJ6GJSy/eFQ+kdhzHyhVN3ksiwCPRzG0bVBTW4Pjar?=
 =?iso-8859-1?Q?hhezhPYetluhzaSwpSgLMPVGTs/DRigjlkWtbK4gjPBJFB6PkHVsx4Ftmw?=
 =?iso-8859-1?Q?E+l4vjhkIlRpT+y9WUPeHZZWBkBMOdfahkNvEsIH1ybMCP59WN1RzAzldS?=
 =?iso-8859-1?Q?iRDO4bhlqSflszXi5gSiYIYGcidIe7WB77zANFkcuNAF9q0T1aTSjm0DLt?=
 =?iso-8859-1?Q?2vG7/oUi03wODfsoizvcHUEEfEMmn9wQXRKMuepdXzrXUMr8ZXIBSGGxsu?=
 =?iso-8859-1?Q?uOx7gcWMyy4T3jQOqNfnddhNPmuQadqNlPW6+U/br729lwNa3ft9jmQnZc?=
 =?iso-8859-1?Q?teoIak+4fp1P+KhNN0qMZRUvt7Mao7+QU6CM/dJqAZHTeLjJjftRJETLg9?=
 =?iso-8859-1?Q?4EYr7bAf13bLGizxFpB44G6Yyj+Y4HZqXUf3hXAoq5ZaUzKuy7ufVyZa9A?=
 =?iso-8859-1?Q?zOyw6S0MFT6SjVOnsQbTKENefsuzL1JzTTH/V/j7qYQGd7a4odDBP1XLZ6?=
 =?iso-8859-1?Q?1DEzi7HGhq8H0MVLEDpSYMElFPwEIIJEbRO7TkVk7KRXHVd81SdObeIZG4?=
 =?iso-8859-1?Q?U3ii+IsXN7710ONMT9jgOi7CGRWrFVPRmtaC9CqZ8FX7sVMcY9ipANYDck?=
 =?iso-8859-1?Q?gCdy3eXupE6BTU7WXlbLrkB8KJwQpr9KJVErHATaDA/+g0HHzSR5W+ra5G?=
 =?iso-8859-1?Q?URxMo7t9HsQiFb1VcQspBpD53QdQ6B63fE21Lk4SgZJLTDtXsXnshYprML?=
 =?iso-8859-1?Q?hwkOA7ceSTfigFEkoCv1xUgrtvy4jWE8o20+pgVxEuiIoPW39iAa7t/Jjx?=
 =?iso-8859-1?Q?84pIH0NgO4+4YYUfBCs4hnNWG5Z8peRhyssG0CD4y22efvn5lpapG0IDYi?=
 =?iso-8859-1?Q?JT5srO/gGRRlWOn/qXB4iW9dfXK0OZeFhJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?j6Blxt2UZM7ZJijvkPq9L/k4OBa3v52VoZ4RDpvq60a9MYMy90j47TJ+jR?=
 =?iso-8859-1?Q?30bajbvLhGQXIxT8LxyZTMnKQjftVyBo21nrGoDVV6afA47KxivDgTduJi?=
 =?iso-8859-1?Q?gTwqKeWPLmy5wCPwM/B3vRMmA8t3kyQegFwryv5pQ6mNl86ApPcprWA1H4?=
 =?iso-8859-1?Q?ubGH1PJGRJbmsQ6bZIRoT5VtoPaQMAve8ERUg3ld89uMOIggFKwX/A/h1Y?=
 =?iso-8859-1?Q?WwppfxjvHXd9SN6e78NUkRIzWy2pof3xxecfTXh5mabS8YXdYE1kYVgAkH?=
 =?iso-8859-1?Q?7BUjLiSl/yvWDD+L+guUMV7u8gjm+yW5WWtX8dPo6Za257+nSCZcqcy3FT?=
 =?iso-8859-1?Q?yH+QESVLjL4VO5RsUTkx0sasjiiiCeT16MW3I5ih/Ylvfmv/eHz0HJJl8d?=
 =?iso-8859-1?Q?ik5YZmNYy0J18+ujTYvkyEVtShaatgGqGwczs905QjIlWODlxYIbDzikxf?=
 =?iso-8859-1?Q?dgwxw5KEB+mrkg+bD0ZV3ofdKdCKkLXix6zIpJygr9uiLLVQpmlR9FInWz?=
 =?iso-8859-1?Q?RnVgB61vUkifIyGomjeExUcAOxPPvKgkX/Z3y/8NMiEy9BVFvg4qHi81eB?=
 =?iso-8859-1?Q?pMh0UsDXgmME7mwmYH3Me+RsjfSqwuOfSNmEzuwhIG1++iiUuMfMJhcwjb?=
 =?iso-8859-1?Q?Daf/cRFQ5kcjzpHl3kl3Vo9WopdyXg3KJ1xlGpXjmCFPQUrYHzgGLDKILY?=
 =?iso-8859-1?Q?oIYO/NAyWlLREmOtU8JIAGoEDJ+gymfVyho5qNNDWZH57aZs33G069nOT4?=
 =?iso-8859-1?Q?faGzHcDjUW+/mhbMdyHVVJZd3rmlSd2/9l66CpGg/zZ72E2VG77/je9bZU?=
 =?iso-8859-1?Q?D+pJnpCtfftEWks9O6sVzJ98JVsZP49ke5hcWITbpUZB74t3QH1ccJBhqp?=
 =?iso-8859-1?Q?bc8dszZRw1o5cP+JdZrqdfzUvom7yuCxYJF2ej25Xon2eIkBq0GKdGeRVx?=
 =?iso-8859-1?Q?m6FFbYhSB25qAf0+g3aNVdyx4ALwKL615u6NUdK+f2bR0dkBHUx6LUytZD?=
 =?iso-8859-1?Q?aGda67bo/FHWY1LseJCr19djvxfqAgVrbUhQh2tNB0thbQI0qZGO81RKD6?=
 =?iso-8859-1?Q?eOcTiOWIE+N34zN9nrxGZB06lurdAvx2TkPU7U94CF985J5Jg8jgXHwvE4?=
 =?iso-8859-1?Q?o6meSoNf5UoS/ZyYTwhP8YcZPlIA/w7R/hVz1q7YUK1pDP65BfkrVCgai5?=
 =?iso-8859-1?Q?DNTPCaHoRa//CiMXMIim3+z37LUEa0sn/PZxPe6F2MXQk3m3OFCJiK0e2R?=
 =?iso-8859-1?Q?RtAwuRjQ3pj3QZGN74ziUUACdqNl0vjGHk3JAf0ffjsUM80kel9ebNptfX?=
 =?iso-8859-1?Q?+Xnpkz1y0V9hFhP88nhuDJtwqonV6EtUYbrFuzL5YyO4AHC229m4KERq4p?=
 =?iso-8859-1?Q?zJLyNqAyo9aPedooInx2l8clE5hLpe3BbdSlw5w3gL/BOs4ma8YKbRJCv2?=
 =?iso-8859-1?Q?jELrdrj6pmKzu9ifFeF0K0FWdLe2MuSJmYYrXVuoUgY1qH1moO9rCZq/Fp?=
 =?iso-8859-1?Q?PDVOqWh3dM9txgFZ4B2g24eoeTliWrPebcci2F+DgdCvnmTJEURJb4DUuL?=
 =?iso-8859-1?Q?TVkRLInAWdK7U2lCwnIhqyEGaSQGEoDmigmjWpZgZWKNVlXODKNMWreQkE?=
 =?iso-8859-1?Q?Nb+kCbLXbiBmbjzgF1HB86dPi7G0ooh8gvVolMxNNDBktS7EDsOV/O1cbz?=
 =?iso-8859-1?Q?4+ppTMF7/OAxJbJ+5mMgdlMXnxDqqS2nN8c3WAumE212qAvMW/xBtYTlzs?=
 =?iso-8859-1?Q?IRKB+gzL9pznPGua238SOUvoDWudAn5gLGo3RyoJ7Ord1iccvUzRSRl8HT?=
 =?iso-8859-1?Q?btXsfq2UWg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cda15884-fe4b-484f-b2fd-08de7363d2ea
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2026 05:16:11.3416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MqXr5g7la/Z7FvksOMtvdvpKGzhEnNkU+dPOzYIvnzNzRJx+nKp4k9YV0FT0A866kBY7LSmZR9h40ieOSapGzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4650
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
	TAGGED_FROM(0.00)[bounces-71581-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[25];
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
X-Rspamd-Queue-Id: 39A88181D9D
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 06:31:24AM +0800, Huang, Kai wrote:
>On Thu, 2026-02-12 at 06:35 -0800, Chao Gao wrote:
>> P-SEAMLDR uses the SEAMLDR_PARAMS structure to describe TDX Module
>> update requests. This structure contains physical addresses pointing to
>> the module binary and its signature file (or sigstruct), along with an
>> update scenario field.
>> 
>> TDX Modules are distributed in the tdx_blob format defined at [1]. A
>> tdx_blob contains a header, sigstruct, and module binary. This is also
>> the format supplied by the userspace to the kernel.
>> 
>> Parse the tdx_blob format and populate a SEAMLDR_PARAMS structure
>> accordingly. This structure will be passed to P-SEAMLDR to initiate the
>> update.
>> 
>> Note that the sigstruct_pa field in SEAMLDR_PARAMS has been extended to
>> a 4-element array. The updated "SEAM Loader (SEAMLDR) Interface
>> Specification" will be published separately. The kernel does not
>> validate P-SEAMLDR compatibility (for example, whether it supports 4KB
>> or 16KB sigstruct); 
>> 
>
>Nit:
>
>This sounds like the kernel can validate but chooses not to.  But I thought
>the fact is the kernel cannot validate because there's no P-SEAMLDR ABI to
>enumerate such compatibility?

Emm, the kernel could validate this by parsing mapping_file.json, but the
complexity wouldn't be worth it.

>
>> userspace must ensure the P-SEAMLDR version is
>> compatible with the selected TDX Module by checking the minimum
>> P-SEAMLDR version requirements at [2].
>> 
>> Signed-off-by: Chao Gao <chao.gao@intel.com>
>> Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
>> Link: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/blob_structure.txt # [1]
>> Link: https://github.com/intel/confidential-computing.tdx.tdx-module.binaries/blob/main/mapping_file.json # [2]
>> 
>
>Nit:
>
>As mentioned in v3, can the link be considered as "stable", e.g., won't
>disappear couple of years later?

I'm not sure when this link will be outdated, but we'll definitely have a TDX
Module release repository with a blob_structure.txt file describing the format.

>
>Not sure we should just have a documentation patch for 'tdx_blob' layout.  I
>suspect the content won't be changed in the future anyway, at least for
>foreseeable future, given you have already updated the sigstruct part.
>
>We can include the links to the actual doc too, and if necessarily, point
>out the links may get updated in the future.  We can actually update the
>links if they are in some doc.

Regarding the documentation patch, I don't see the value in adding one. It
would just mirror the code and become outdated when 'tdx_blob' layout is
updated.

If the concern is that tdx_blob layout changes could cause incompatibilities,
that's not the kernel's responsibility to prevent; the kernel has no control
over external format changes.

If the issue is simply that links may become outdated, that's a common problem.
We can address this by referring to blob_structure.txt in the "Intel TDX Module
Binaries Repository" and dropping the specific link. For example:

  TDX Modules are distributed in the tdx_blob format defined in
  blob_structure.txt from the "Intel TDX Module Binaries Repository". A
  tdx_blob contains a header, sigstruct, and module binary. This is also the
  format supplied by the userspace to the kernel.

>
>[...]
>
>> +/*
>> + * Intel TDX Module blob. Its format is defined at:
>> + * https://github.com/intel/tdx-module-binaries/blob/main/blob_structure.txt

I will drop this link as well.

>> + *
>> + * Note this structure differs from the reference above: the two variable-length
>> + * fields "@sigstruct" and "@module" are represented as a single "@data" field
>> + * here and split programmatically using the offset_of_module value.
>> + */
>> +struct tdx_blob {
>> +	u16	version;
>> +	u16	checksum;
>> +	u32	offset_of_module;
>> +	u8	signature[8];
>> +	u32	length;
>> +	u32	resv0;
>> +	u64	resv1[509];
>> +	u8	data[];
>> +} __packed;
>
>Nit:
>
>It appeared you said you will s/resv/rsvd in v3.
>
>I don't quite mind if other people are fine with 'resv'.  Or you can spell
>out 'reserved' in full to match the one in 'struct seamldr_params' above.

Sorry, I missed this feedback. I'll use "reserved".

I even updated "len" to "length" and changed the index to start from 0 (to match
blob_structure.txt) but somehow missed updating "resv."

