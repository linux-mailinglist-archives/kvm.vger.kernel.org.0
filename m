Return-Path: <kvm+bounces-63661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4402C6C7E3
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 04:01:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 7C1C02C8B9
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 03:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C4C2D8781;
	Wed, 19 Nov 2025 03:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K9G0ElZZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D9925B663;
	Wed, 19 Nov 2025 03:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763521256; cv=fail; b=neX7xhMrWY2b9CvVjuaKmAY7ILupVw3WoaBfds0cVDl1EJyqAfvzqjtsCh8ZTATTeO+Bi2a+/eM9s8eeYW1PI9RDNcmu8PFmvseJepI2dAe+4+2JjY3hTcQ+bTCHzCah38/6W/CcZkS39g1UGr/11LZOypvgAZ0hy6448GlGW7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763521256; c=relaxed/simple;
	bh=2cENgedjXTjjxN9tTrMYm6ac+cib19CcERVc/cNJUZM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Fkgsue20yAZJErbMNez2FhiJ9fMRI9ZuyPDdn4eR6wg48JpVZovHUblV6u0IYilr55VSRNxLTRYliJ2UUnqrWvW0M/2BBoIJ5lOIFYUvZRpkCbvck28sduXSj0NrgwyIufz1JRbDpwMRv1oROwK7KtFdBJOIv9+eT4lGDacFreI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K9G0ElZZ; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763521254; x=1795057254;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=2cENgedjXTjjxN9tTrMYm6ac+cib19CcERVc/cNJUZM=;
  b=K9G0ElZZ1hfGW9/cEeylockhHI6OqZuX7hk1zqzidgvjCHrNjWdJtuG6
   66z45sCBcfkzIKNlV+dGAELig4ZR74JSFkrxA1jbqgWSNzhciVAFCR608
   mRoCY/REu9ybwP9J32VSFPjp5i9THnN/H3IRjm9DWIF/l+qniJiz7P3TE
   6Fb8ts7sgyiSo6QnIhWwA2ZWwT/HY+QQ8b9ZFw+NRgneftBjDPFLiuppw
   CygYJ2pxLuJJEujmd4cjm9kBtMM4h3H+2ch449h+H8lMnb1lB6bz7dWvr
   fSQgPlSxzncQszByTlpMYnD4P75hEvX/J3uFyucvPJXeCkf9zPb8bfGRu
   A==;
X-CSE-ConnectionGUID: kbgtK0wcQw6uQYJMtSV+Yg==
X-CSE-MsgGUID: /HXeZrPpR1aQo7lJIZwRGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="65496423"
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="65496423"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:00:53 -0800
X-CSE-ConnectionGUID: z00owAvXTTCLTb1dOHE+8Q==
X-CSE-MsgGUID: +pfgsMgjREGbJv+oDEf9Kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,315,1754982000"; 
   d="scan'208";a="190957264"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 19:00:53 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:00:52 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 19:00:52 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.60) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 19:00:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k5BFiYNuEGcbbVqKQVNArRyUGS3VI50M9X1v7QOs3L1XATp/Xb24he54B7Gmq9nciGqn7nQqhZ9gS67nFyF3ZUlx665oTQfTUhBPn78JYTZIBValwhr7aHj/AZNZz1RklkdoY9B1VRzZtXMnHhLwTQITNv4dP5Ya3ZLjM3zKZ4yPSKdRcSu91Nc8qM8TWghc1K8P1GgHaRYadubXzvq6Nqt/4MVR5P1wjvF9JtQMdqFouRCwa/vxO1F9gEgjGWUB6kIa6KQuxQwcW5E6RhkeKjLZUDJUtMZuX+R/yXD7x2WNllKo/X9+VO7r+nHjM3ll7J4Rq4AxP7q6/6N+Domkpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kYepnZ+nYK+01R4/9usjfiaeJKteJpFsy9ALtStrviI=;
 b=CPCVSlO506cKx8tDHpKK+cylyEseITsaFvakLAMQBvoV9rybDmR7RObvPco3mrkQn3+7lQb8tzjZOCajAjC3ckkQVQIcU4apknrNbocvCHcCmOrjieEJ6CHki7bDIaZnIFUrBzZITPqdUAEh9GYGNdTNlUVyc0CQNYXvJIOyDLulVGBf9or9QkDr4trRdVtRONow/PEP8d80cOsXjMmB/bqFT7VhpIuHkjWu4m55IpNOV/NIHC3zRIm3t5fukyAW/MfILRByIqqttt969UPtOudC4HB2ZU2p4OFSom/CpRXw953cPneLDPJwB820Xcv9CZ/g8Jzv8FKCcVgYLh4Iiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB9462.namprd11.prod.outlook.com (2603:10b6:806:47f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Wed, 19 Nov
 2025 03:00:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Wed, 19 Nov 2025
 03:00:49 +0000
Date: Wed, 19 Nov 2025 10:58:38 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aR0yXoXbqr39bnv7@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <5e1461b8e2ece1647b0d26f0c3b89e98d232bfd0.camel@intel.com>
 <aRbYxOIWosU7RF1K@yzhao56-desk.sh.intel.com>
 <6635e53388c7d2f1bde4da7648a9cffa2bda8caf.camel@intel.com>
 <aRvX9846Acx8NSZ8@yzhao56-desk.sh.intel.com>
 <3866c2e32d51f87ac80cb46489f99ee09e3e3864.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3866c2e32d51f87ac80cb46489f99ee09e3e3864.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB9462:EE_
X-MS-Office365-Filtering-Correlation-Id: 37a568a6-9fbf-469e-cd25-08de2717d7f6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?qqc6NSgvM0q5r02le+ruYol63VQTbT4KGwEp2yQsRdcb9lGdNIVqWo9+1a?=
 =?iso-8859-1?Q?TkxRrLy0Jsgsc+oXCWXD9dRNGg9yAfSU01x9iix9sl6WnQceokGjPNp07I?=
 =?iso-8859-1?Q?5IMdqimKj6Ab+q89CWeT0m7APqdvJ5uItpddKpMryOEyE7icfM94NQ8NLO?=
 =?iso-8859-1?Q?bsVzGF3qaMe2EJNXxJkU3Viq/0uZYlg9XzcdGIL29wodbUuscATfiLfSZh?=
 =?iso-8859-1?Q?8aTnNxNZiPp24zuJ6tRSS/I8qVhzrSOGQHfe+/wfuleVcSIaZ5we0UaVlD?=
 =?iso-8859-1?Q?m41IQxHb31HALjaJtn3YbrP2bh5prtQyVM74VMR5EqEVAaAACks8byvRJb?=
 =?iso-8859-1?Q?/pxet3RbQUZb7coV5ah8a1FYwm+wJwDiqddxrADNHbUJTIJl3rN4/UJC/G?=
 =?iso-8859-1?Q?nEEROlLez0fX3arRUYxLO+XsNQpvVvwiRlM7965bCLgsf6SG9eYTfOogo1?=
 =?iso-8859-1?Q?ldsgR3TQYgyXx1JqFyDXd2qDwgE7LmT2BLV5pWrzr5wOfs+JOYJ0GeEkd2?=
 =?iso-8859-1?Q?VWzoVM5z7n/wbJ5f7LhgNVh0oLKrp0XOChEBnUKduHOvuQnrVApO9hu0Jp?=
 =?iso-8859-1?Q?mcgLqvQv0zuobnFxyZbFkp02xNuh9ho0OcANLo0flVCrogMIzMVtH8JHAs?=
 =?iso-8859-1?Q?rceopa6b/HrqNt3z8ZVfPlUW1G9kFRA+q8d1DIrOYvtRflE/Im80KfAw9q?=
 =?iso-8859-1?Q?lts7XeNMGfC5VdZKV11Bqd9DkUddENtpHUNN+ItG+wzLeGO5TmleD9BOuR?=
 =?iso-8859-1?Q?9iuWEnrIseVOc9VnyG9wLlcZ59XaO+6OzMVJgHBVD1PSOBTq1XfT8A/8pc?=
 =?iso-8859-1?Q?1JiqUJ7EMHVU8wES1dGoHBIgrtT6aluBdJVSX4xm9d4c0XBHLDXBUqpEQ1?=
 =?iso-8859-1?Q?dStfa14IHYbXVimarhBNW6RVpCMpc55Lqkbif0uRNvs6mmBgLvelY/NOa3?=
 =?iso-8859-1?Q?0QNrlTw5ovaxJI4PhWiuigiRrK2SxB2vJaJlYmKYvZrwI6XejYOPgI2c2E?=
 =?iso-8859-1?Q?RyZ/6Fs0EWacyStzMcIp1zxYBB1IPGykHo+Kn1UHY2sTwJtGP0Z9e812Nx?=
 =?iso-8859-1?Q?3jZvlz2n1l404/DoMUQpSW3aI2nXcgOnUjTuAIMc9OU0OWJE2Uae07qOal?=
 =?iso-8859-1?Q?krxn7Vi09qf5XI7Vw/4DUqAiZKReVX/iczbCNoT34yJ/g7jZlNR0lsqzGL?=
 =?iso-8859-1?Q?rvoV72tfpJ08PrO7sOTJYSvd1zbBw3BVEkMbBDi/UYezizzGkqthwp8Lx5?=
 =?iso-8859-1?Q?iBEpBrbFgG6KKDeL1CC1wIvQ2Tovu83b1ykr+M1qqF/ZKzjbJ3zu4LyfmW?=
 =?iso-8859-1?Q?MDjonIrOHlLCWpPF9GjjFnPpeFGeGKq/uJNE0yKbxMDIl/v/aEiXFTqhqg?=
 =?iso-8859-1?Q?7ab+OOVEGxoIMKRCfX9i0tOd50Xy7AVsPmIXuoD8RI9/wN5xVZ+GyKFllj?=
 =?iso-8859-1?Q?GqdwnFBtlRmuratsNVTBDtdjZvahmvdlIQdVdaacYM0AQh55nkL8zJmvAy?=
 =?iso-8859-1?Q?H1cd3twhlgh7+XqqE9YqKz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?rci+vw5LPe12q6XlS5TCL1oiMUTtqi2UfsQmfLM9UZCm2FytqHhQv938yB?=
 =?iso-8859-1?Q?A1ZVMjDtAOQ8pgl+oaeZw3meVvetcxZ+QS53X/KVubUHI5W9GmarIcLM8U?=
 =?iso-8859-1?Q?LIoJr6ZIa/vLXw2JtjiCA1vOrfVUvBl2pKNqJv8eTauJPndRAN9Q7dHC+D?=
 =?iso-8859-1?Q?40e3zolQ6TPoxBagyWhyyThYeGZEbOqkudYid3J4FLhwSMJ92w27dwug90?=
 =?iso-8859-1?Q?jpmaEsLgvJSLrAH9w8q6yDR0oJD8SN7Xs2P0GCRtg8Hz0wEL03W2X7z+7I?=
 =?iso-8859-1?Q?1MMdfMpqbMk2xlsQyqvEEDa5VMADVDgbbifSg4iiNEHEivj16ggVvIhPU1?=
 =?iso-8859-1?Q?r6K+P2nNHcndG8s8OPiSDRJBtU3DzPJXkICc6nzJw5URn7ycSNLQGjxBQ5?=
 =?iso-8859-1?Q?D/aYe34t5rMYuU1mFVH2C+0pOuxREfg/dX//QApnMG0Libl5ytI0QM+4Fe?=
 =?iso-8859-1?Q?N5LHcdwW9uYsisJMf+G4nQG2I2F1/lndk44WKszZ03Y8QuM1FD0z01Ad8k?=
 =?iso-8859-1?Q?9K55CwsC/Re17sMuvrU3Lt8TCAGJvk+t7QFLrST2S/pIQ94YNLXi0WRSwT?=
 =?iso-8859-1?Q?FRiogBYw0BMlfrrDSwMzaEqaFr7FuofaC4d/L9sgQCf2nqxBrVu/oB7KVk?=
 =?iso-8859-1?Q?EGWiPxmJBbse0GZ2/5MJcGqlnygizbgdY6SGlC+7oG5R4RbKi8tWp1dQkW?=
 =?iso-8859-1?Q?a1DSL1C/tAEUBtKFL+pYeq2Kp9C6OMkwIt3KLFWxJahC8SylYFnGkzI+SE?=
 =?iso-8859-1?Q?Z0tYzk1ylI1dLafJdCLhU3AYElUULWiuQXqWkRTkKWyEMvkIcL2YBHUjrQ?=
 =?iso-8859-1?Q?zMk3THCZUpfAMohaCTvJZuMN1EMzREhpFZGLY3VuUxM39AjRfoMrshuSdv?=
 =?iso-8859-1?Q?EHguRN18jfOtAQrJxUc3j8Y9dmvd0QxQYKaQ84u6O9vVIQtjxohkSbBEOL?=
 =?iso-8859-1?Q?k8J18zN2rnZG5cyzuKs2xSD0xhy8n7Y+8UhJZeIXmqcTzlZXxgOstKbdxp?=
 =?iso-8859-1?Q?p4k6XAcHZZe8w7XlKt6xVgj3Nru8puyBIgUPoUcqy+knYOG+QGp2AtablJ?=
 =?iso-8859-1?Q?oMVm6YcZllLXlnPLc1zqCMBbWEl2gZcRe2DO5kSRexBgN8WFW/OYYm5W3L?=
 =?iso-8859-1?Q?96kZpcxCgbnUy8cvnHx5L/twIdSO/5iGUnyKhcVyrAmNq7jvCL3kOsY1Yr?=
 =?iso-8859-1?Q?CwzOH7f0ZOvkFZW0WY7pg9SiMlJEP+P0WExSlIk9PLMHnC/w8k/oZ7Avuj?=
 =?iso-8859-1?Q?dBVD7X9/LqGLtVCEeTtykvohI1fBRIX3Gt5Sq8kcKBWviCzuSudswNFf3R?=
 =?iso-8859-1?Q?PbdSIupsra0mDuqRAgtVjd8IbsMr2qcsfKO3kmBhH8F9VoKzIyIE3tKfgX?=
 =?iso-8859-1?Q?DP0qjgbX3ewCKH+lRncVwa/o/CSNjTS5BgUdpMaeUKm/M3568/mRNZvyMp?=
 =?iso-8859-1?Q?TjlpaALdriI+vsR99xH/HWTIktuAJOpdrkkxhmZaoRao1zjpix4C1I5cSJ?=
 =?iso-8859-1?Q?mxcg+8ZwkwZnUgHNalTkyH4C0lYFdMZCzXhw2Xo9Ip8cNVb5Q0Ay0W7wzw?=
 =?iso-8859-1?Q?R7KjIvQZG5PrSj9bbFrFvDkzM1UebQbtK9A+zIhGUGW77iG/CTjEjhn74V?=
 =?iso-8859-1?Q?IclboFmEXk78HmyywHDa7KkMJfptsGO5US?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 37a568a6-9fbf-469e-cd25-08de2717d7f6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 03:00:49.6437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /i55pQEhw9U/tNfHp0mr6m8GVT0xbmszhb0eYGZ0WngargtbBr4UwrhPbUrs+1o34mvJp9tXWJTW+SFx3zdX/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9462
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 05:44:25PM +0800, Huang, Kai wrote:
> On Tue, 2025-11-18 at 10:20 +0800, Yan Zhao wrote:
> > On Tue, Nov 18, 2025 at 09:04:20AM +0800, Huang, Kai wrote:
> > > On Fri, 2025-11-14 at 15:22 +0800, Yan Zhao wrote:
> > > > > Will 'level == PG_LEVEL_4K' in this case?  Or will this function return
> > > > > early right after check the eeq_type?
> > > > The function will return early right after check the eeq_type.
> > > 
> > > But for such case the fault handler will still return 2M and KVM will AUG 2M
> > > page?  Then if guest accepts 4K page, a new exit to KVM would happen?
> > > 
> > > But this time KVM is able to find the info that guest is accepting 4K and KVM
> > > will split the 2M to 4K pages so we are good to go?
> > 
> > If guest accesses a private memory without first accepting it (like non-Linux
> > guests), the sequence is:
> > 1. Guest accesses a private memory.
> > 2. KVM finds it can map the GFN at 2MB. So, AUG 2MB pages.
> > 3. Guest accepts the GFN at 4KB.
> > 4. KVM receives a EPT violation with eeq_type of ACCEPT and level 4KB
> > 5. KVM splits the 2MB mapping.
> > 6. Guest accepts successfully and accesses the page.
> 
> Yeah looks good.
> 
> Btw, the change to make KVM AUG 2M when no accept level is specified is done in
> patch 23.  I think you can add some text to explain in that patch?
> 
> E.g., something like:
> 
>   Always try to AUG 2M hugepage, even there's no accept level from the guest.
>   If the guest later accepts at 4K page, the TDX module will exit to KVM with 
>   the actual accept level info and KVM will split to 4K pages.  The guest then
>   will be able to accept the 4K pages successfully.
It's a good idea.
I think it's also better to mention in patch 23 that returning 2M in
tdx_gmem_private_max_mapping_level() doesn't mean TDX will AUG 2M.

So, maybe
  Always try to let KVM map at 2MB level, though KVM may still map the page at
  4KB (i.e., passing in PG_LEVEL_4K to AUG) due to
  - the backend folio is 4KB,
  - disallow_lpage restrictions:
    a) mixed private/shared pages in the 2MB range
    b) level alignment due to slot base_gfn, slot size, and ugfn
    c) guest_inhibit bit set due to guest accept level

  When there's accept level of 4KB from the guest, KVM will AUG the page at 4KB
  directly due to the guest_inhibit bit set. So guest is able to accept at 4KB
  successfully.

  When there's no accept level from the guest, and there're no other
  restrictions on the GFN range of a huge folio, KVM will AUG the page at 2MB
  first.

  If the guest later accepts at 4K page, the TDX module will exit to KVM with 
  the actual accept level info and KVM will split to 4K pages and set the
  guest_inhibit bit. The guest then will be able to accept the 4K pages
  successfully.

