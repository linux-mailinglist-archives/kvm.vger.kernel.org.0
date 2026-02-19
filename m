Return-Path: <kvm+bounces-71359-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ly4M5tCl2lXwAIAu9opvQ
	(envelope-from <kvm+bounces-71359-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:04:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 451EB160EA3
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 18:04:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B8E72303C507
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 17:03:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540B134CFB9;
	Thu, 19 Feb 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CMeMbNeo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CADE2882A7;
	Thu, 19 Feb 2026 17:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771520613; cv=fail; b=VVKX3gNwaH0zGZi6c0rdFsR1nasxrJ9JmuGovNafy0Kjw2sjiKGcZTMenxP9meczxiJFSZKe9LLmOVmBpVMSrbF+ovUUhPb/+oJlzykbWMXAZTvJx399uvV8hKq3Yy1npZW4J/j51uhUiNOdWvYIVqZpnoqdwEkCvKnCdCq4GZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771520613; c=relaxed/simple;
	bh=1KRIFnUAtCHLl646yIclk38K9Pu11cgCFCdW9V5/35s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HG1oEbl+0kDKHJ3kiL734nmNlvThc6tT6LYcTo2+x1dYnI0Bu05f3FudoRI8d2qjefuvLKSAGiT98UJ/6H2dv9IL7tGyMcLD4YPJi21WlYm5RFgk1QWyBV1LD+cn7/6p3xHRMZWpgeShTJHVCkGCV6rLaLxousqX6eLb3Kz74xs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CMeMbNeo; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771520613; x=1803056613;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1KRIFnUAtCHLl646yIclk38K9Pu11cgCFCdW9V5/35s=;
  b=CMeMbNeo2pNCJQRt9d/mhc50VUZ0g3UpbrdBteb3l9/WXFIr9mB0LoaA
   1PeJO10MYg0wyxXLAOTd8FiNQAfjcyaU5SAS1LOxzbRtxTk+W8o9tryG7
   gPHZ+sdDG4+kONvT2kIf8KA3H0u8uKCDCiWtts086+u4jznKt0iCT6rFt
   6SHmyBevLhIfxKGIWesnUKT9J1+yBG88UT6g7e0hLQyKDzsJkJbs/+rX1
   peePAuGJn9Qpo7MI2/cgdCKIg27JWrFEAtmOh5q75PT4vk0xR1Q1mYepv
   8++vU4KBZA07C7EHRbrnTBuINp08II6fkuIIhNxgeIAw1cfwipfaw3YEF
   g==;
X-CSE-ConnectionGUID: VhUMCrVnQS2NoTK8i43Xmg==
X-CSE-MsgGUID: w9tvDP06QNmwF5gMr8VYaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="72711878"
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="72711878"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 09:03:32 -0800
X-CSE-ConnectionGUID: 9kdJbYSfRUOTBizaNbLrgg==
X-CSE-MsgGUID: +d/PnF/iT2aRXKPIgIDQxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,300,1763452800"; 
   d="scan'208";a="213186605"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 09:03:28 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 09:03:27 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 09:03:27 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.18)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 09:03:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=faI1w0W7uJUtcRUy2nLbGG1PdFI+PThE0SOepU9tc277ooz+8gOaujHdjBipeyGEyx1c7VRtY7o7fPlPcTFGuZBkG5CYRv1WwpLXqkrH9uJRAboxUPh1r+iycW+H+kHccIasY6H6rp01Y487os5fOUkYxui/z3LbokNlKVT3w3AgSxQPpmp8fS6qE02Hn1/cwlBuwkXqAIHfVBBxNFHOg0aqsn8xqtK5VVZ+kjMwaEIp81WtVJkozW+IfBZ3Jw9N42tSpKOIqinCELIodgprzQYeFKHjylt/NgqYYC2z/gWZWv+R980fZ+i5I0oHVxj9Z0V3HJG6NtZzq0EAXwGECA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a1EQnzgGeRHh77RHTnNlOl79UUY2gTy2LvEgH+N2Iyk=;
 b=wT1+9OoR2+4F/9VcybADsUtLlJhK5xomAuiMPypzJxAsIO6cejv5+n1kQGlBAxH23QQge1ITrRNK+Z2QdipeVRoMHYHqoRpCaBqxp30J8ZImdCfaLr2PfxuaAO4kWNiywZ2P4XG/yz5hTsBgTl4/vJA7//d0w7Ve/RdlfJfxwZkzaqLz/gpPENNTuaaANBUR5SgX4zVFBPdfjKswepm0IYO1y85IGzDP1N+fyuB+0fhWjZ2glm9q0SnGDfC5QgfxtnmzBCLczqnpWZdW0yND6guDkV2IGmnbCQ7Ta7cQvGLXy479D3jwtfMBbIxA9OJfdeXQSIf1PmWjPsrWyNHaXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB6813.namprd11.prod.outlook.com (2603:10b6:a03:47f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.16; Thu, 19 Feb
 2026 17:03:24 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9632.010; Thu, 19 Feb 2026
 17:03:24 +0000
Date: Thu, 19 Feb 2026 09:03:20 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Ben Horgan <ben.horgan@arm.com>, "Moger, Babu" <bmoger@amd.com>, "Moger,
 Babu" <Babu.Moger@amd.com>, Drew Fustini <fustini@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
	"vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
	"dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "bsegall@google.com" <bsegall@google.com>,
	"mgorman@suse.de" <mgorman@suse.de>, "vschneid@redhat.com"
	<vschneid@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "pmladek@suse.com" <pmladek@suse.com>,
	"feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
	"kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
	"fvdl@google.com" <fvdl@google.com>, "lirongqing@baidu.com"
	<lirongqing@baidu.com>, "bhelgaas@google.com" <bhelgaas@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
	"Shukla, Manali" <Manali.Shukla@amd.com>, "dapeng1.mi@linux.intel.com"
	<dapeng1.mi@linux.intel.com>, "chang.seok.bae@intel.com"
	<chang.seok.bae@intel.com>, "Limonciello, Mario" <Mario.Limonciello@amd.com>,
	"naveen@kernel.org" <naveen@kernel.org>, "elena.reshetova@intel.com"
	<elena.reshetova@intel.com>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "peternewman@google.com"
	<peternewman@google.com>, "eranian@google.com" <eranian@google.com>, "Shenoy,
 Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Message-ID: <aZdCWCTDa777gfC9@agluck-desk3>
References: <679dcd01-05e5-476a-91dd-6d1d08637b3e@intel.com>
 <aY3bvKeOcZ9yG686@e134344.arm.com>
 <2b2d0168-307a-40c3-98fa-54902482e861@intel.com>
 <aZM1OY7FALkPWmh6@e134344.arm.com>
 <d704ea1f-ed9f-4814-8fce-81db40b1ee3c@intel.com>
 <aZThTzdxVcBkLD7P@agluck-desk3>
 <2416004a-5626-491d-819c-c470abbe0dd0@intel.com>
 <aZTxJTWzfQGRqg-R@agluck-desk3>
 <65c279fd-0e89-4a6a-b217-3184bd570e23@intel.com>
 <aZXsihgl0B-o1DI6@agluck-desk3>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aZXsihgl0B-o1DI6@agluck-desk3>
X-ClientProxiedBy: BY3PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::16) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4ea9e3-32ad-43ba-b757-08de6fd8caa5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?/KhYG9uDYVEu6AAQrstWYxTAAcxIB9ivAavhHC/T8ibLVYC0jMP7DtTzLlf4?=
 =?us-ascii?Q?2VpbCQI2TVQHEas6x96mkt4lZ8bspNqCMkY+DV+oZf6xsXXqDWEN4RqrzS70?=
 =?us-ascii?Q?vG2udT38GR4pIst1F+Ac3010ovBhBLKkWkWH9TL2Fdnv3fae8fTbGGj7y+xj?=
 =?us-ascii?Q?HypGmLA2Y72YUYBzmO8zlF771TPmUG5xKAAh8Jy5GMOzP+6D4ptRAENT+B4Y?=
 =?us-ascii?Q?bvSh4+ZLzDZZQCbIYv0zokkd4wlmno43Vo0GNihnzdXFBmtL+dzyphthNUWs?=
 =?us-ascii?Q?DHeHyBkJZInkHIPATUugPCzA57NVMzKc4pvu8vW+b8C2QSCQF+ILLL5MB6x3?=
 =?us-ascii?Q?QAo9GVX4vvhw+n6jWtscR5t9bE2BC+3h77tg5Ti1CzdaA7s2AxXJBDaT3Z8b?=
 =?us-ascii?Q?LQBrB/uJ6qGe/zCa4ioBZKPdfIOBMPcNw/ac81U+uyMK9ON9LoL7nEnaYS4w?=
 =?us-ascii?Q?Iq2PtkBUQf7JJXw+dEJ/4kY+RIHpLeZI64QoRbqq8PFQXareTh8U/gU/3QEW?=
 =?us-ascii?Q?aRsFhXeHK3b0YdsF7j27P08P9X1h9zt2hN71WHN4BArhi8/EB0Wmyu1/27Ag?=
 =?us-ascii?Q?pCIXJ2L/ssTjn4UswShFImgH8u5+9PLnkf/kPfnl9nx8pdLbdsCXL4czqskV?=
 =?us-ascii?Q?W1ZG+mwop73CA9Sbu1gs+EF5ZJcVygsJGW29mlsfPDfyeuTNh2x9LAxLUKcq?=
 =?us-ascii?Q?jtbB7UiwuIs+i3oSOYn1spoXhLFBHe2/q4uQ0cwQJ3ZSr1zCM8uZHxnAzWsr?=
 =?us-ascii?Q?0sKkwE4D0fBm4YSpPeksyiSjVb8fF3E4snhDnkJiKapBtSOhTVMjqhC6ZQO0?=
 =?us-ascii?Q?5GbMmQ9wJqfFdM5tUA2xGgFWGdsINptM1miCrQ+HkUOBhVy3a1CLv2Cc4rIQ?=
 =?us-ascii?Q?zjBj2kIVjGr5EWH88OxnPtMdAK2igb+Km03Y0pp1fahBDFPKEDCNh0DhYGCv?=
 =?us-ascii?Q?2SXVegFF7XACv2TwlkBEXzu2AJRmcQ6Ax5XTBj5vPteEGQV8FOrBXbmlF76J?=
 =?us-ascii?Q?bk5aIwhJGun3owJtHbOH7Q51IG8jYDI/GYMTjbxWFRHHAnttdsVB+MEhyAA5?=
 =?us-ascii?Q?JVnCR9AQ2/PmZ86CovKBN6vgXqRxk9lFPHXmvxu7Wp3RCGJOCjG6sGW/gulT?=
 =?us-ascii?Q?tOf2b9oPj+6vFYshOv5Ryr3D1rDXtxt3UoJfGZ7W8BHnRIzS8aEhgGSz3LXk?=
 =?us-ascii?Q?CxdOZ+JfGnIYGpcUVDR+k3DfCz/DCePwemAVTceDobDde3ej1nQRqfvPXZx+?=
 =?us-ascii?Q?4fwDbrM6PKpFXFO5VY4fq8aPHFKlqU+HIcYZAFmgOg2EC1PmbGZVEKwxNLhy?=
 =?us-ascii?Q?dEph4ad957qBEBBar1La7Lr/C3+8PliJQl/30axYXG+ZMm7pTeFVyTvo7V0a?=
 =?us-ascii?Q?sNsbyC/Jf8QWAlU1OLBeKK25vG8ij4tfSjPW+52JHOryBXyQPn64hiEk5yED?=
 =?us-ascii?Q?GIcDqWh8IBVEhM5x2QyMzUkyLTfq7QQHyJu/VPGB/6uaFsGiobzqMeK8l0tM?=
 =?us-ascii?Q?MZWIHpgQqShir3DaGjzarHg/TN4esiNoylCOYguVGHfb0hu8jJXrtB38bI1T?=
 =?us-ascii?Q?nw4BqY9HXJ7dO5BAuJo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?25DFprUqHvEKIw/VyW/EUQ8T/pbdQRvFhcMWnE+kVVWZ3b6pFEZt4moAiiHV?=
 =?us-ascii?Q?9axq2MbBRwfbPn4cPUQoTlEJP16c8hL45rmQotnT12Sl3M+1J2Zm0B+3dhlY?=
 =?us-ascii?Q?8yPaE2+H3YR0rM7bbDGHZYYkEzKfe6QaR8woGu7qPxRzHHo9qC5u9M/8bv3V?=
 =?us-ascii?Q?ASZRwf7Es+v/tvi92/4cAx4sL5bUhldvDJT6BvOipAFabNVzghX4Pz2cgrUH?=
 =?us-ascii?Q?ZsOp23AlGZSG1Jwa5uC/z7U9xcVtJgMK6yMApcuFNJZwhTytvs6J/jOWI1Ie?=
 =?us-ascii?Q?EifkFnqJVcZf2fOhLqHgZufCpqtmT2A8YVNZEQVpIjSRDXgtKmTabcdRU2fr?=
 =?us-ascii?Q?AEs0msVZ4O+yVTNo2DE8Ty6NfWESwioQKrJMyDoIvzyeaobTkA1/Q5cRWYZG?=
 =?us-ascii?Q?3iiJB9iz/yEMPIP0ag7HKn+Atql2Amzt7+nn8nPJ0oZk07/b0GT1rwbIFodL?=
 =?us-ascii?Q?2zWueRrrDz7DwnwbrBv/GHKDdZYX0ivmGeo17yJnPTXChy1hImAVW4lL2FGj?=
 =?us-ascii?Q?f1KWMdURVkgdMEMBgjHzyxz+oD5k3wT/1pqrBBQ3bTJhCk3HG6BpkECmh0wJ?=
 =?us-ascii?Q?o2CKP64aLidwZG9jDrStlTCyLiGTIQY/p58neHWtIwdHgWRrRlCQlRgoncDF?=
 =?us-ascii?Q?4PRTMSbvxG7FpmvT3Ts2yXQPjP5/5bTeM9XCZ8Q3uPi4mkULizphB0EOLduv?=
 =?us-ascii?Q?Culp1GvezkjxCvLL0DlYoISoM+iXiT9IDk23hzRp8JV1u4gEcHtCafSYlfqR?=
 =?us-ascii?Q?siWYvOR4pRo9EOYHX4JEurhnC/Ok0CcJsyJ1OuAvfW1pb7CD8S2sUB4dyPJb?=
 =?us-ascii?Q?FKv3JU8mNdxFm37FpQk1vr+MzLIt/Dmo43uhzPe6WwdMBfH9JVYuA7GgK0EZ?=
 =?us-ascii?Q?GSx30Jk0/NUnkC8yBYWtnGb6rHEwTd+o0D8VFQeN0zug8xOAwLG4yNrJtBSs?=
 =?us-ascii?Q?A3q9xE+bKZkqWqDIk8OURslHK1RsBhrKC77etKTmkbaA9iw7U0UIr4QJxaEZ?=
 =?us-ascii?Q?e00SQuNGct038anyIrFQ4yClxFZp8JUTsBw6bgcQHl3nWlNJICWGsG69euJJ?=
 =?us-ascii?Q?6Y67dtEeL87hNMiJggStT/kE0fflZOmFuAIL5mo8owaKEoRU4cXmnzgMoVRs?=
 =?us-ascii?Q?dwui8DoVRUq0MEV9eKM20ES7HvUbsiEI62EbR+vxYSYMuo6jSfOCtgp3Dain?=
 =?us-ascii?Q?Xzc+uzmN/X/S9dWHl5rXxwm9JAyHhWn3aJPjnBL3bihggVkuD7FQwA/WwWWi?=
 =?us-ascii?Q?jNzLCvlkFwij+wCq5bKFuQfx2GnAyCQJ5Q17soNy3y9l03bM/OFq/TB3PLu2?=
 =?us-ascii?Q?UzNUegFRwWro0EhHmUg3DDIeLkPLF3gRKoyq3z3Gu2l/NYziasggLF7au00R?=
 =?us-ascii?Q?x1G4qFij7PnvkfN/rrBBiU8UbLGN7Dcf6u2j5K/9en+Z6bJOAwDppDgQphNG?=
 =?us-ascii?Q?S159YRgtpbDMTmlUD7ck6faAVxEfB2zl9wg5faQqr9dJlF0OMc+3mPuKi9FQ?=
 =?us-ascii?Q?GcNTngtxx+apSvn2gI0FV9VSA9O5WBRpmgILmy8tK1nwxbZ5c/zFePIoycMP?=
 =?us-ascii?Q?etkLIk/7ca5QoNmlq0lJu7xkHw2B9V83cXkj3svjWSx/EJI12SP4gv57/mCN?=
 =?us-ascii?Q?NKNHSd5aJ6Ucr5p3ZvsOtu572FyboBAfvR5qUq5DK5iTBwP0oR29tek7TX0e?=
 =?us-ascii?Q?nRdjgjB0xIA4tBx8QXfWrSYA2wYUbT1Ai7txqK+tWYvdpER7qIzn5bHqf7c8?=
 =?us-ascii?Q?gKgWg4TDdQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4ea9e3-32ad-43ba-b757-08de6fd8caa5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 17:03:24.0955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WGUc4N4Cut3vj5cwxDteTo2EEPk56lHzvan7GL6oOsGQabi6W9fff0poblN3/Yspeu3AfZuPhYzVuCZrSrXQLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6813
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71359-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[46];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tony.luck@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 451EB160EA3
X-Rspamd-Action: no action

> Likely real implementation:
> 
> Sub-components of each of the ideas above are encoded as a bitmask that
> is written to plza_mode. There is a file in the info/ directory listing
> which bits are supported on the current system (e.g. the "keep the same
> RMID" mode may be impractical on ARM, so it would not be listed as an
> option.)


In x86 terms where control and monitor functions are independent we
have:

Control:
1) Use default (CLOSID==0) for kernel
2) Allocate just one CLOSID for kernel
3) Allocate many CLOSIDs for kernel

Monitor:
1) Do not monitor kernel separately from user
2) Use default (RMID==0) for kernel
3) Allocate one RMID for kernel
4) Allocate many RMIDs for kernel

What options are possible on ARM & RISC-V?

-Tony

