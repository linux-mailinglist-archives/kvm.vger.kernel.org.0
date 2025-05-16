Return-Path: <kvm+bounces-46766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D2E2AB9603
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 08:33:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F6971892DE0
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 06:33:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25B001FF7DC;
	Fri, 16 May 2025 06:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="INTclFAo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE46D1D88AC;
	Fri, 16 May 2025 06:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747377205; cv=fail; b=IW1pkwDBOxHbYK3+yYC4eKPKsiRnX7/0a/FeE3ynDAwv/eTqjEy9LrNaHfqdqtgi6/sw03X08P5ARULTIERbruTLywXSWEjPQYrWnN6sj3+GnAI3mJrC6iULnYiwpjpLxxvJCNvDOv687E5KA14SaIHHXYKG8uB/MiiXe+reANo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747377205; c=relaxed/simple;
	bh=lmsLFItUvEHDDZ/FhCsu5yUDugDaRequYWLutSoaEwg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uYN1c3jnHRUCNcHB/QslGpx0ZJUxIpiFlVAc5A14wtcRsXaA3yKEXMaaFORjEn4FqDFyDnG8CMM384cfTn+txw205kNK8xBNIavZ1cGMvSjYlEibxPcPRMh03Eawzu/RgUD9eP7D1oU3T3DTJGyUyNfI62MoouOasnZaSMzMkac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=INTclFAo; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747377203; x=1778913203;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=lmsLFItUvEHDDZ/FhCsu5yUDugDaRequYWLutSoaEwg=;
  b=INTclFAovjgFPxTxBgu6yAqHrTpcCg6XIDDQfIlP4HFC7Cz6JUlph7Sw
   9WTXZ5M86zzOaWW+2MjVEFgajzgLmiN9W4FPNevJpwR1nRBx1DpNXrvDh
   mlwzLXH2vt0+d3F4ymPmU8cBp3gFCu4fqx4ukvBAwV/OAKqzFcBhfxMmn
   jGUZCjb2WQcQIVBVKbd/hOplWFGCDHYBvWPzG+SQ0LjkqrNiou0+PaJXu
   SAlkJo2Q2q4aKmOiJUUfMbR/se9cjDfd8sMes7RgJA0/0HGLmBi0YO8g2
   oZPP6ktHRlS/4UD3s9mZuxfHQxW5juA9ZZNYb/nBG+l7bn1VwqNyzjiRp
   g==;
X-CSE-ConnectionGUID: tf/cfYSuRKKroOxWe2fo+w==
X-CSE-MsgGUID: vFcyOh7DS7W1ampES1bchw==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="71843901"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="71843901"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:33:11 -0700
X-CSE-ConnectionGUID: vXs3DRXIQGe7rgSbwO3b7w==
X-CSE-MsgGUID: KAC6/0D0Rc+ZIl+1Awctfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="143370827"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 23:33:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 15 May 2025 23:33:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 15 May 2025 23:33:10 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 15 May 2025 23:33:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eH1uHiDuMVsY7P+HlfBYTEwDetY6ZLypqhLJkZKoGiJ4dsobam8wZerr6q1CDFMEUJ86gssrWm6kDb5rnBzZpLZydkTNiENMJqXmbucnh+LdQqnqTNoyzfOaRuWifwJ6F3pEUQ/7yAUuyxsYTmm9N7bvqD1PjcF+Df/6eyI1RzSTQtUeY2XyqdsqeB0647jqvVU0jTn98FxG0YhjX+Pxify2bXGcJBeNo2VfZhU764ON8pSbp5gawKDLQ5M8tjxlD1UDs/iyPglFC+6HSMxvVDL4XwUZA1FfGxgIPx9lOK63EF+fPu05qWC4Pt1uw2OAe8zKwVXuYwSWaF7tREsleg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpoTdYmMDHknMaFGbWAAXfRCJ1/OPV6c4ACTF3KSnE0=;
 b=OmHWZTtBC/Dd7mDt3jjoEvOHQ2Ek3PptWAJIE77z5g2Jj8pMy1Rv6sYaOTC2lPOF58ai5jEbfOzXQ9utmpAUo6fj6OmopPZvBfBYo5PAIyIP9ZbmxMr9452MCCVx0n3AyHTB9lqBOQaqo/NXrtwKGEtxtMpKVvzOeIW6eUKiCaPzVhfxgtKIGfdJRi19lnuBJGJEdjmVS/X00nH3yb+KElIUWapueww8nRwRFUg8ZAyekb26gV8WHlgcU8j7YlqC6GSadY1gEBlBuyDrLlNLMX+xeF0lkIxWi/QFS7fX05ATOZg34R3Guk6/vJ1eRreV4yVWAZfjoXxRv8hq95iFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6386.namprd11.prod.outlook.com (2603:10b6:208:3b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 06:32:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 06:32:53 +0000
Date: Fri, 16 May 2025 14:30:40 +0800
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
Subject: Re: [RFC PATCH 12/21] KVM: TDX: Determine max mapping level
 according to vCPU's ACCEPT level
Message-ID: <aCbbkLM/AITIgzXs@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030713.403-1-yan.y.zhao@intel.com>
 <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <7307f6308d6e506bad00749307400fc6e65bc6e4.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6386:EE_
X-MS-Office365-Filtering-Correlation-Id: c1fa386a-145b-40c9-3992-08dd94437c73
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EDv5EVyZROiyWQMVo5Pp2OSzym7TdabDRM6fA3k4dCV0xhF5knL9LHvqy7M+?=
 =?us-ascii?Q?5k2A/Al3HmeC0idyiMMSezG3ht1ZlzqxbuAzyj+4TAR+BGbwfhI7lPBaZOJD?=
 =?us-ascii?Q?S9rtfLvczpdPPOOj3w6IvTaIMJJbi7yHrWu+xn5RrgPcZyzkAEuulWNElcig?=
 =?us-ascii?Q?mcMNZCVL2VVslUl0yI2U+0WKFsrnlO6Bk6SXj3MS8Q/5yaoTGvwJbLE+j+Oz?=
 =?us-ascii?Q?t5TvzEx93AmOslwiIq4T71aOllP6lWoHMT7NFG6NHcd1ityMwTql8V5kwKrw?=
 =?us-ascii?Q?EhNSQHkEPRtkgNSeCtTVSXwIUx9NPytnhTYhHeF38LZPhxTbsOyuMY4CO//9?=
 =?us-ascii?Q?xgrORds4n9A0VGjT9H+Bm9JSUvap/6GNiqW1n3Y4a0McbLaRz5SsBJZiemdE?=
 =?us-ascii?Q?Uun4spL0+3K7Kv6dHO5NXU0RK2vr7RreIIDJH2v0oW+rcSiocVlFYfU6ajnz?=
 =?us-ascii?Q?XdtfQhRqPJ8X5SJPSh/MT8W7z5LFWMBiyxv44oV0jxrRRNfXlKpkcHbmczw6?=
 =?us-ascii?Q?sQgpafEASkGEgN6Ttnsoa/dAmH1aUK5LDO6tLlTBsn6M95c+pPvLoa10IuYb?=
 =?us-ascii?Q?3tcpqZKKYvKbLZ1Vcy2GBj2OLNBkhVaGTMGsz1Tu5YVcYkfOfBccvOj9ZoTt?=
 =?us-ascii?Q?TuI0QOtZPRBP7Y8FfX5eC+ZUccWmvahlV2+F3Z/sfn96IlrviIDQgRIvQ0Fr?=
 =?us-ascii?Q?4C+k5ZjEvVTOW2JQR9W/+DgOuD5YwCy74HGdh7yJlBEbNfgmhJ8c9aErHdGw?=
 =?us-ascii?Q?tbmAxvB+pccpcnDdrbIRYQzG2VkubBoenLyXw/ry8KkOMrKGUxFAqny7TKTS?=
 =?us-ascii?Q?K8wR3TdLlEuLyINxYlr7WOIBPHYw+E1uANaR77hpB91GQqU/Sl9ONbe4D1ek?=
 =?us-ascii?Q?Zgt/URIQ4ui5KuAgXIchtqhRjS8d4DyYEY5CeGV1kZmWS5PoOnytAMFbNar0?=
 =?us-ascii?Q?zdTKEjFR1pf0vbXOlQ3iso0pDae3YgZo+WTl1LJAJ3Ea7FyX1bna7hyq7Lfy?=
 =?us-ascii?Q?UrOn+uL2YnEsiVnjMUO8UsbBYFrY/wNHRPx57NMP4x6/ZHn2Uxrg5dl1EDr6?=
 =?us-ascii?Q?4CxBoBVPaxYs4G6052nL+y9b3Gq1WE8pvgun1YXoyEmxlNodpvyvPlXOgOSk?=
 =?us-ascii?Q?YQBEuyXNr+TDGBhiBmxLb/wTKa/9I01LFm9gU8twVM/ZWMGY9/+ZBKFGL3Kl?=
 =?us-ascii?Q?OspDOsL3qzLOtptUE1X2Icu2CJ2Q9AqBecIgMJxMwY3+Rr7EjnbCeXUsduz5?=
 =?us-ascii?Q?Fo9KH6VIkYKHrNZxYW7qMJWToIXGx/SXXJW8l0CyvAcw2lNrUuXPZ2seUbrU?=
 =?us-ascii?Q?PDII5Cnl7na6zcDeND0uFYBYompF4jmRQMxSf2Ryad3ojsRoVbThT2JWsR9+?=
 =?us-ascii?Q?v5YZPVx8ZLET3HFAsI3IrbCK2UbI0oPmG0LVikk8Tdzu1czkuHnWg8Zc499S?=
 =?us-ascii?Q?EQG86PN32Ws=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VEf5ZP54Us0bN3O7BzFwnMyjYwke9fRhXRmTlxmVZAYvWRdF8OezbXdWxWFo?=
 =?us-ascii?Q?I/TKVHe9E47HNkkXhTyymFXAR8Rx63XyYz2ihVNZQbz1QkvED9sqIg2Cc/ph?=
 =?us-ascii?Q?ASyi2xOGk3Y1WtzvsnqUilvJKV1NJiLsfQ7i8gs7wr2C4V+yICdzQu2Iq5Bk?=
 =?us-ascii?Q?4r4G+Y/OzP7cCzk7WUa02GtISETk6KEn6oksJgW0agqI/EqxCLstH5blfDJ8?=
 =?us-ascii?Q?gUGbo7r3AsF7VFj+H82SJ3lzYSCGiZE4C0a4x2g1G68w73JRv3GJVsX3CwXF?=
 =?us-ascii?Q?C6ogrNp4be2hch7sH0deQ/9wG4cf7qs8LDO9QBCLEXBnaEJCnG6/Cyah/lxd?=
 =?us-ascii?Q?D9DXrdKNM39613MeeJqfZWNEfRlaExqDR+f7DhKvldtnKR4Dkc3xJ7NgH+NK?=
 =?us-ascii?Q?+4DjnDrqnOUaN4LI6e7cIU5bsFzzim8tLepOSR7DbIIx+s2yQOgPMgImA7/u?=
 =?us-ascii?Q?gacX1GigOTf4nw0QloryAKSG8PcGXX1ZsviC85ZGe7cEPfz9+zjTOxcneBi7?=
 =?us-ascii?Q?F0IKujHW0kXQidVJo3lgj1TKb5IYwIJx7w7VLOBGC/o20TqxkmyIFlh75ZpN?=
 =?us-ascii?Q?JKtR4D1cd45khA60Pqsgd0JJkE0jGYHemsHhMheNKkw3Ic815vGBRiVbh7cQ?=
 =?us-ascii?Q?HQKM2k6qnoKUx06ZSicre+zqorqYsjrXYJCiZDg0v0NUrF2M5PayaBIj8mUi?=
 =?us-ascii?Q?iSBhvpmyut8FzBNRPGR/6Vw35AGBfksFD7ano6ialRAfWffm7hPm4LAptZk7?=
 =?us-ascii?Q?tz8t4wL2gNE9NvHDPa87tbM3xaldYxZL+zn9RAZilzZDqevZdURuDdX4Q4Gs?=
 =?us-ascii?Q?sIr/WELcjZWmyRdS3oSzuLb04+RvDRUaS3AmNz6Xt/gjlDBRd62Chbp/aW54?=
 =?us-ascii?Q?RodwbzEFpxhwitdRxSRTB0xxFo2MkrsWx+t+lhVMjvecZUKcYnHBAksfkTpT?=
 =?us-ascii?Q?2EuOKlE9h8I7F6l1HWa0HKPfcP8GXSPeMU9FnKesXqpHujddf6xGgQYR9U2q?=
 =?us-ascii?Q?DiFX40R4zZ71xbynbVBM2kyqFOPgX1klIe0G0l1pLghA0p4mdppcxxYDBub1?=
 =?us-ascii?Q?Dx71jbhEUU9ZCbn3MV56d+zqEMT5mowwZFZJygeFYwunDMudYvPXSYPTWyfT?=
 =?us-ascii?Q?Y8sEQOTklBf+WBfOA/0Zekx3x7ELaNAG1J2Prl70QwpxRaU25rU6B0cUdyNA?=
 =?us-ascii?Q?+YBRWgWspPKPrg04u3I+GIxeV0rotPsM185YXEiRu1cN8nXaTw5EHRicc9Yb?=
 =?us-ascii?Q?/wb7yK3TK3EC3XEKKwPQhMFSEQu8HOzHlezMWb4wx/wMCSarjPdp3HbtIEny?=
 =?us-ascii?Q?9UAOV0RdSbI3S+nYM5cf1lvbGAHDkKdrgv6pmI5cfoUHb7Qfxpd5tEjqEqDk?=
 =?us-ascii?Q?EiokgntGFBBT6mjSU5GjVw4UnZNWr5vGj/jAHJMKYQyofeaCs7dv3+3g7Vjv?=
 =?us-ascii?Q?rC82KIJHmDQbzQm2dopxO5Jl1FTQTZQC/uWHAGv8Uk3RKUR53eM0Lo0YjVT8?=
 =?us-ascii?Q?ATx3n371oitgwaWIie/CrUAsCEIGxnysWQgUzbJXqqS6uLkc5ApAAfGnfEn3?=
 =?us-ascii?Q?gBR8RQPT5gCujfOmvprWLAqQ4wZRY3kgc9/TpYEn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c1fa386a-145b-40c9-3992-08dd94437c73
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 06:32:52.9524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2RaG4bgtSBLu2v6iqDxChqrS0ZHL8M5iNvBaVBLv/yELm9n26GkwlSw65SAIst/xduez+XWjFZbj5KHf23kaIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6386
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 05:20:01AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:07 +0800, Yan Zhao wrote:
> > Determine the max mapping level of a private GFN according to the vCPU's
> > ACCEPT level specified in the TDCALL TDG.MEM.PAGE.ACCEPT.
> > 
> > When an EPT violation occurs due to a vCPU invoking TDG.MEM.PAGE.ACCEPT
> > before any actual memory access, the vCPU's ACCEPT level is available in
> > the extended exit qualification. Set the vCPU's ACCEPT level as the max
> > mapping level for the faulting GFN. This is necessary because if KVM
> > specifies a mapping level greater than the vCPU's ACCEPT level, and no
> > other vCPUs are accepting at KVM's mapping level, TDG.MEM.PAGE.ACCEPT will
> > produce another EPT violation on the vCPU after re-entering the TD, with
> > the vCPU's ACCEPT level indicated in the extended exit qualification.
> 
> Maybe a little more info would help. It's because the TDX module wants to
> "accept" the smaller size in the real S-EPT, but KVM created a huge page. It
> can't demote to do this without help from KVM.
Ok. Right, the TDX module cannot set the entire 2MB mapping to the accepted
state because the guest only specifies 4KB acceptance. The TDX module cannot
perform demotion without a request from KVM. Therefore, the requested level must
be passed to KVM to ensure the mirror page table faults at the expected level.

> > Introduce "violation_gfn_start", "violation_gfn_end", and
> > "violation_request_level" in "struct vcpu_tdx" to pass the vCPU's ACCEPT
> > level to TDX's private_max_mapping_level hook for determining the max
> > mapping level.
> > 
> > Instead of taking some bits of the error_code passed to
> > kvm_mmu_page_fault() and requiring KVM MMU core to check the error_code for
> > a fault's max_level, having TDX's private_max_mapping_level hook check for
> > request level avoids changes to the KVM MMU core. This approach also
> > accommodates future scenarios where the requested mapping level is unknown
> > at the start of tdx_handle_ept_violation() (i.e., before invoking
> > kvm_mmu_page_fault()).
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c      | 36 +++++++++++++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/tdx.h      |  4 ++++
> >  arch/x86/kvm/vmx/tdx_arch.h |  3 +++
> >  3 files changed, 42 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 86775af85cd8..dd63a634e633 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1859,10 +1859,34 @@ static inline bool tdx_is_sept_violation_unexpected_pending(struct kvm_vcpu *vcp
> >  	return !(eq & EPT_VIOLATION_PROT_MASK) && !(eq & EPT_VIOLATION_EXEC_FOR_RING3_LIN);
> >  }
> >  
> > +static inline void tdx_get_accept_level(struct kvm_vcpu *vcpu, gpa_t gpa)
> > +{
> > +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> > +	int level = -1;
> > +
> > +	u64 eeq_type = tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_TYPE_MASK;
> > +
> > +	u32 eeq_info = (tdx->ext_exit_qualification & TDX_EXT_EXIT_QUAL_INFO_MASK) >>
> > +			TDX_EXT_EXIT_QUAL_INFO_SHIFT;
> > +
> > +	if (eeq_type == TDX_EXT_EXIT_QUAL_TYPE_ACCEPT) {
> > +		level = (eeq_info & GENMASK(2, 0)) + 1;
> > +
> > +		tdx->violation_gfn_start = gfn_round_for_level(gpa_to_gfn(gpa), level);
> > +		tdx->violation_gfn_end = tdx->violation_gfn_start + KVM_PAGES_PER_HPAGE(level);
> > +		tdx->violation_request_level = level;
> > +	} else {
> > +		tdx->violation_gfn_start = -1;
> > +		tdx->violation_gfn_end = -1;
> > +		tdx->violation_request_level = -1;
> 
> We had some internal conversations on how KVM used to stuff a bunch of fault
> stuff in the vcpu so it didn't have to pass it around, but now uses the fault
> struct for this. The point was (IIRC) to prevent stale data from getting
> confused on future faults, and it being hard to track what came from where.
> 
> In the TDX case, I think the potential for confusion is still there. The MMU
> code could use stale data if an accept EPT violation happens and control returns
> to userspace, at which point userspace does a KVM_PRE_FAULT_MEMORY. Then it will
> see the stale  tdx->violation_*. Not exactly a common case, but better to not
> have loose ends if we can avoid it.
> 
> Looking more closely, I don't see why it's too hard to pass in a max_fault_level
> into the fault struct. Totally untested rough idea, what do you think?
Thanks for bringing this up and providing the idea below. In the previous TDX
huge page v8, there's a similar implementation [1] [2].

This series did not adopt that approach because that approach requires
tdx_handle_ept_violation() to pass in max_fault_level, which is not always
available at that stage. e.g.

In patch 19, when vCPU 1 faults on a GFN at 2MB level and then vCPU 2 faults on
the same GFN at 4KB level, TDX wants to ignore the demotion request caused by
vCPU 2's 4KB level fault. So, patch 19 sets tdx->violation_request_level to 2MB
in vCPU 2's split callback and fails the split. vCPU 2's
__vmx_handle_ept_violation() will see RET_PF_RETRY and either do local retry (or
return to the guest).

If it retries locally, tdx_gmem_private_max_mapping_level() will return
tdx->violation_request_level, causing KVM to fault at 2MB level for vCPU 2,
resulting in a spurious fault, eventually returning to the guest.

As tdx->violation_request_level is per-vCPU and it resets in
tdx_get_accept_level() in tdx_handle_ept_violation() (meaning it resets after
each invocation of tdx_handle_ept_violation() and only affects the TDX local
retry loop), it should not hold any stale value.

Alternatively, instead of having tdx_gmem_private_max_mapping_level() to return
tdx->violation_request_level, tdx_handle_ept_violation() could grab
tdx->violation_request_level as the max_fault_level to pass to
__vmx_handle_ept_violation().

This series chose to use tdx_gmem_private_max_mapping_level() to avoid
modification to the KVM MMU core.

[1] https://lore.kernel.org/all/4d61104bff388a081ff8f6ae4ac71e05a13e53c3.1708933624.git.isaku.yamahata@intel.com/
[2 ]https://lore.kernel.org/all/3d2a6bfb033ee1b51f7b875360bd295376c32b54.1708933624.git.isaku.yamahata@intel.com/

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index faae82eefd99..3dc476da6391 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -282,7 +282,11 @@ enum x86_intercept_stage;
>   * when the guest was accessing private memory.
>   */
>  #define PFERR_PRIVATE_ACCESS   BIT_ULL(49)
> -#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
> +
> +#define PFERR_FAULT_LEVEL_MASK (BIT_ULL(50) | BIT_ULL(51) | BIT_ULL(52))
> +#define PFERR_FAULT_LEVEL_SHIFT 50
> +
> +#define PFERR_SYNTHETIC_MASK   (PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS |
> PFERR_FAULT_LEVEL_MASK)
>  
>  /* apic attention bits */
>  #define KVM_APIC_CHECK_VAPIC   0
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index 1c1764f46e66..bdb1b0eabd67 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -361,7 +361,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu
> *vcpu, gpa_t cr2_or_gpa,
>                 .nx_huge_page_workaround_enabled =
>                         is_nx_huge_page_enabled(vcpu->kvm),
>  
> -               .max_level = KVM_MAX_HUGEPAGE_LEVEL,
> +               .max_level = (err & PFERR_FAULT_LEVEL_MASK) >>
> PFERR_FAULT_LEVEL_SHIFT,
>                 .req_level = PG_LEVEL_4K,
>                 .goal_level = PG_LEVEL_4K,
>                 .is_private = err & PFERR_PRIVATE_ACCESS,
> diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
> index 8f46a06e2c44..2f22b294ef8b 100644
> --- a/arch/x86/kvm/vmx/common.h
> +++ b/arch/x86/kvm/vmx/common.h
> @@ -83,7 +83,8 @@ static inline bool vt_is_tdx_private_gpa(struct kvm *kvm,
> gpa_t gpa)
>  }
>  
>  static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
> -                                            unsigned long exit_qualification)
> +                                            unsigned long exit_qualification,
> +                                            u8 max_fault_level)
>  {
>         u64 error_code;
>  
> @@ -107,6 +108,10 @@ static inline int __vmx_handle_ept_violation(struct
> kvm_vcpu *vcpu, gpa_t gpa,
>         if (vt_is_tdx_private_gpa(vcpu->kvm, gpa))
>                 error_code |= PFERR_PRIVATE_ACCESS;
>  
> +       BUILD_BUG_ON(KVM_MAX_HUGEPAGE_LEVEL >= (1 <<
> hweight64(PFERR_FAULT_LEVEL_MASK)));
> +
> +       error_code |= (u64)max_fault_level << PFERR_FAULT_LEVEL_SHIFT;
> +
>         return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>  }
>  
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index e994a6c08a75..19047de4d98d 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2027,7 +2027,7 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>          * handle retries locally in their EPT violation handlers.
>          */
>         while (1) {
> -               ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
> +               ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual,
> KVM_MAX_HUGEPAGE_LEVEL);
>  
>                 if (ret != RET_PF_RETRY || !local_retry)
>                         break;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ef2d7208dd20..b70a2ff35884 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5782,7 +5782,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>         if (unlikely(allow_smaller_maxphyaddr && !kvm_vcpu_is_legal_gpa(vcpu,
> gpa)))
>                 return kvm_emulate_instruction(vcpu, 0);
>  
> -       return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);
> +       return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification,
> KVM_MAX_HUGEPAGE_LEVEL);
>  }
>  
>  static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
> 
> 

