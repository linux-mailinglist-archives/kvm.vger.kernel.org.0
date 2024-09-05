Return-Path: <kvm+bounces-25967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10C7596E478
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 22:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8263C1F22FAE
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 20:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71941A7256;
	Thu,  5 Sep 2024 20:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WvdJghhR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCFF1A3022;
	Thu,  5 Sep 2024 20:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725569622; cv=fail; b=TGNWoye9Ueb9gqkf/f0db9WE7DRmlRtp+KHCLIGDuSQI427eYoMMb2fWo3Qvl69TTNVbf+a5EL10oKAAeFkuPt3D4OUqPKi2r3245Z/nbIkxqxHfDsch1ts5f+aKPqrINwyJUmAwEPupWNynrYt7i+P1W4HrIo7FTv7hTI+bCso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725569622; c=relaxed/simple;
	bh=IUz2N51Hge7X1KV+3KzbJxAog2fuZVkGOp+yukXh1qw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HlpMpbcNcYBTIJetBtF5xDkqhVBbnRATVBC2FHjrA85fjApy6HupBHAu2XyFNZOhF7trfJ2LzqKAs/xwcX+V6tJ6r8IIFUKvkSfBDI0kebqD1wwkYsFpzTwxbZIgLTtneeHog/0eqUZcBcqUVN5JuYrOOCBV4K4v0+VZ8VCs3xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WvdJghhR; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725569620; x=1757105620;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IUz2N51Hge7X1KV+3KzbJxAog2fuZVkGOp+yukXh1qw=;
  b=WvdJghhRCenLyJv2shaxl2eWqJHYp+Z0tp6nuEr8xcllOWdE3pjK2pH8
   6au4zJeGithtBYE0Q8umngxehVTqRSsWBJRmvWYjnAneiA9OXaLRUaLLS
   CB7eolhE8hkb7qBXuwYyieVE6mn9JF+mC9IzkNmGVQJZPl1kD35+m12kG
   GS2b/YrL3MDkvaFSy7VyHX9kLzB5awczDYpjDa8VNIKVt4+WvWUJAusf3
   gTJVONB3ZZ7ZiJkpGCMQ0MhLBlTZq9ca7khS51w2b2mHW//7qqTHZjzD4
   K5qqgG0rzhdPYDgvAm9gtKWiAqPX3NheoOSgkY9nO4v8WHnEzJTEksKzt
   Q==;
X-CSE-ConnectionGUID: 5RhNIJqLQHCW64FtA5d3ig==
X-CSE-MsgGUID: R9oesYAQQZ2OnTrmZx0u4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11186"; a="23869411"
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="23869411"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 13:53:40 -0700
X-CSE-ConnectionGUID: bXRxeqHETkSW5Ib2GOXcgQ==
X-CSE-MsgGUID: bhd19zHxQFesK58k8NTGOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,205,1719903600"; 
   d="scan'208";a="66288857"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 13:53:40 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 13:53:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 13:53:39 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 13:53:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvLJmuuhIxOVOinxUfnVAJSiJclcL4OPPMFVXTp6xK3CT++NeZcfPqt3fJ3XOhe3nMYCjCdRLEA5Xfj5G330w/egeOqZq97hr6IJdwL5mtmWBFpsiJv9SjThyfF2x7hyfrbCdnlnuIlxynQzs8KMPu2p8R1Dkww0Ho815p/vs8fBa4vhZq+SocBh3rvmWghRNhF9xA1DKKb+WKJ5fdXgSw3rYuV22R1LCZLIskLgoXD9rxAnljJ7bqTJvcTwhMi4fvK+fYEisXfxYqV7xOL6Ut29P6p1ZWIdrGM3tcW4fo9Gox9Z5wQXaKN62xTf7/P/M8A8nRzh+PPAmcYtuRk2IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N9w+M41nCHZ40Ggo/3q+GaZpW0TEE571DKJHuj0UjQg=;
 b=xrn/e1S1JQyXmccDa9PHNXcvaf/h9281c8aligGt+6H+TUcb9A/AxsB+ZKFckpKfirZ/XoByNwqYzTRfU1Vfge2KE3RHkrnzgE98rhT7JQrcxEImcT3K6rFj+QjVZN4uLOvCfimELa33nUxEJB8xFv9Zn5pfq9giJbudr2PP/ootaQ1jjtcgR+Egjs83Sl6st4N4iAytpRfi6A49h6SKfPcehOw5hL/kIcE9oizMFYyfXp4fK1AS4sllU9Xgk8Hc7RqV9HOvYN0HFamtcyZhvQOist5wV2JVeDe90qvNO1S8EBq77oFD0FWV27k3A/brNnTE3ACSgl077JdnIirhDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Thu, 5 Sep
 2024 20:53:31 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 20:53:31 +0000
Date: Thu, 5 Sep 2024 13:53:27 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Tian, Kevin" <kevin.tian@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Mostafa Saleh <smostafa@google.com>, "Alexey
 Kardashevskiy" <aik@amd.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-pci@vger.kernel.org"
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, "pratikrajesh.sampat@amd.com"
	<pratikrajesh.sampat@amd.com>, "michael.day@amd.com" <michael.day@amd.com>,
	"david.kaplan@amd.com" <david.kaplan@amd.com>, "dhaval.giani@amd.com"
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, "david@redhat.com"
	<david@redhat.com>
Subject: Re: [RFC PATCH 12/21] KVM: IOMMUFD: MEMFD: Map private pages
Message-ID: <66da1a47724e8_22a2294ef@dwillia2-xfh.jf.intel.com.notmuch>
References: <ZtBAvKyWWiF5mYqc@yilunxu-OptiPlex-7050>
 <20240829121549.GF3773488@nvidia.com>
 <ZtFWjHPv79u8eQFG@yilunxu-OptiPlex-7050>
 <20240830123658.GO3773488@nvidia.com>
 <66d772d568321_397529458@dwillia2-xfh.jf.intel.com.notmuch>
 <20240904000225.GA3915968@nvidia.com>
 <66d7b0faddfbd_3975294e0@dwillia2-xfh.jf.intel.com.notmuch>
 <20240905120041.GB1358970@nvidia.com>
 <BN9PR11MB527612F4EF22B4B564E1DEDA8C9D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240905122336.GG1358970@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240905122336.GG1358970@nvidia.com>
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SA2PR11MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: 22d18bbb-4d0d-4ed3-4636-08dccdecccc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Kh16CxST4DKh/u9Xg6eqrfSzx47iYKgB+6Bvjr6z3qOiQoBQ0WPmaUfC0+dm?=
 =?us-ascii?Q?4NpJwICmm/aMW8ps6ILDkEibkgFuIuBPD0Wxqjp7y+xoQF0vb5qdXDQbXtH/?=
 =?us-ascii?Q?BU5/X0puR47NgG5RNzwZvHMx8isNykVqtsRxMADfY9AjEqIjWxiYVghmZA2c?=
 =?us-ascii?Q?FAzvqr84WAoCKK/saAMGKEyHFUazeDdICt2k6le0Lwi1ESwP7v6vKiMNku9P?=
 =?us-ascii?Q?X4Inuhu35RTKc/CWZj9p9adTQ5SWRZxO0+QxoHjb2ZYqeupnbM8VRNc8qfPs?=
 =?us-ascii?Q?T8MNbibXGn3PPxVa/7BgXEg6FnQevS6MzO2L9+Tm39BgctnGJ6t2pnpQBrcr?=
 =?us-ascii?Q?ug6GCDvDvR3ywQgBoTnV96u4RXjrbCNg9xa1CGC8VMWthOs+IGBAgY3s3OJu?=
 =?us-ascii?Q?wWpk+TBgez9OLXEUhOxoAKxsVTkBJH0ufVZDOPmr2sUm9RhyG5ZQ9qXYcV/L?=
 =?us-ascii?Q?gtNDd0etBGinRy0YcxbhazZFbbyuo7A2IAGEbD/CRkIMgeBM+D+kIY/UrSJ0?=
 =?us-ascii?Q?ykE7JHOn4eUCMkE6yh8JJORWEY1L9m8gw5Y4OSLIx/CqGhYY6W0/GpRXpnw5?=
 =?us-ascii?Q?UUBebyioAIrvY991OeoJcFoq0kNkKHy874NfTmj6XIWF3Oa9WrXhCYZlYIyw?=
 =?us-ascii?Q?AAY+GRUg8yu73a7nT/ARUIL28Gqs7Cotks6AX6wbdwlM5/l0doPJAmp38wAn?=
 =?us-ascii?Q?9fqZfOLbK5cHYra9WSYD4TgnXtCnuzhI4lCZpdVq5PA8v8KinmgmVQtH1jYo?=
 =?us-ascii?Q?7i5HZnbxaf63p8wwjCIcRBQB4ML8I8BoQhEXwVycKkfXULJgmmr5my4+rOTC?=
 =?us-ascii?Q?JhS0MllbMvewFI4GHwtP62/5XxneV7I9LzKWeQnlnWIL6c02j8obKy3mPSH0?=
 =?us-ascii?Q?pUHFye6+tKfk6hSMNlukjMHI4M0TnyYCh0lZgr2VP4XmWvTOpNY+1a1qfUYz?=
 =?us-ascii?Q?DdBLCEQ3r3fudpbgMzDPVA/EAwZ/QCzXm0wzPHS/g1ZCnfD/8+OiEL41kbGl?=
 =?us-ascii?Q?QtsTzG3yZZkQp3G4Vih08LuPAKdMBTSznlVQ+zd8fw0nz6S6Zf4wV6GyxInx?=
 =?us-ascii?Q?tALddwes5NzHQyE6TncBPr2mnuL1GNqOGkef7XUojFuuzGH0b3aOwZN3Miv7?=
 =?us-ascii?Q?67+thOTDAeHiTstVEl/xrvsvMjPPGXKCMyU+BnSb9YEVtu/qBhLHSMj3skIK?=
 =?us-ascii?Q?QLqx5lXn/HotIJdFuLnodeOkyZuE+/8FF0xT5TsKO/ShuNT6AD94XMoNQtLB?=
 =?us-ascii?Q?wHmsTPkGzW8zvZHZk/GGcm+dgXLZqWx+ObAn3GIoutKDvCY5TCRZoc4oSiIG?=
 =?us-ascii?Q?pMRBDO+Hi3jGLoZWqhiEyZ4BVzAJGnM8YRCoY6cjbexhaA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8T650HM6sy296rfg/80rW0Lx93TR6IwbAJeUmUiEOcih30oe8nmn3RYM+Ss+?=
 =?us-ascii?Q?E1XNBKqYL+5ybINnc4y0mXwY5N1Bd/0buoZgj3L3k8lRT0lrD2sPXKdmFYbF?=
 =?us-ascii?Q?3q+eqgIEDpCvC61rK8fiMYXTFaWByTq3uRc0fPfplh0EOxG9tQCGqyF85YWd?=
 =?us-ascii?Q?RV3RorOp6v3OgHrNmYBKXc0PxWkMQcImnhkElKFcbRQGa/OcjTa1nz9N/zJe?=
 =?us-ascii?Q?JhUfBxj36kqh2oC3eRUkZlqUMfhRr2ABVY1orWrikVKcUShuDBjS9FHj+MYS?=
 =?us-ascii?Q?ax/uKOdw8dDhijv6oPG/XK8V7HeJVoqOxULGjYeeESuRJYwIPGHpHaVc1Jir?=
 =?us-ascii?Q?wpV0DG4Xvkyoi88nnwcasijYbgE8M/e19Ewcr5sU0fQriwLK+J2CgS69H/F1?=
 =?us-ascii?Q?y6BC0uB9QIQMSsMidVbkMaYEgVI4pJdEAeJYwuIHdADuOr6ID0TmF4zX+b+f?=
 =?us-ascii?Q?Er/OnNjPV/o2mjaw4ZeCMJR2AQofWuJCR5z0hxz4wJmE8Me3kYI5oNVHh8hT?=
 =?us-ascii?Q?2zam2CP7xSVzSJnG57Jgk9uGNjGJJq/41WLOmyVSVbroeTuT/7Lj2Uzw3SVW?=
 =?us-ascii?Q?KXsgBIYjXxyGAmrzlk+KXuCpMBpYUZDL7qcXopGJyWsks+PrJJyKruymdkFK?=
 =?us-ascii?Q?FWFpwCkA7gmTsJ1aRc4kxz82lhzQO8vNEGi50zOvG+rg2tDLoT2yWAkbT5sK?=
 =?us-ascii?Q?Jm0y0DL+homQ6zfHyE+AgESt0F5t9Oc9lssluFNoBVgDdaN5kvyrSdmwJ80f?=
 =?us-ascii?Q?p5dotXf5i6Mx5pb+yTxoWiq1dttU+F41EcrNOB+jZ09vI904+2F7y8Mc204w?=
 =?us-ascii?Q?jyp+Y/ANcXGasEEIYZedVn3j28upijq30fn2oyiTVE4rrk8sAh4PvFugD+rD?=
 =?us-ascii?Q?bp0ytIjG6KhSIcs/KDPRRnwfGFdKcbcInTqN8ZCsMb2dj8tTtgKnh9Mz9dPz?=
 =?us-ascii?Q?hdw23eIk6Ydu3/Q3rNSRjrRyNG4RaBOxkZ7GxgUB+T+gyo8AHmeXiCp/EPBt?=
 =?us-ascii?Q?y2/PAr+8Fzf1hXPlqiSJhokMO/lf/z9uDqre6UQKJpr0ADKxUhtCOKmCh8gf?=
 =?us-ascii?Q?gfCYbM1l2/u6Ms/ZtwHOrv+NSvKvhR4n8QwO1k29nFv72sTofTPqbbZeDjwG?=
 =?us-ascii?Q?MesGfRD0268MRFO/aHTcMtU9Q3JxSz2OUAYPJoY+OzBY12ILMomkciRfs389?=
 =?us-ascii?Q?W2/ltIkrm715byu9tTT52rywZDwmcH+E+wXZ6Y+rSTNIFra7UXUpGdEwhGYE?=
 =?us-ascii?Q?vvDNir0vuHqTxQarsES0UEBzd1oM2RmRz4YymNQ6x/vcPB728zm9weE/JfBj?=
 =?us-ascii?Q?yfEp1w33l8t5wr3gG+Fl/+EzABxqKNPD6HPwLn9KvbVK4FKNQ0Gy7peXlqR0?=
 =?us-ascii?Q?q2P1ue1dhCRi0MxpuyVCmFuh4rkRXLWdffxw6zE71+SpwMYGSicDidugMbDr?=
 =?us-ascii?Q?wu6H8pR2Ny1txZeg6BjXw4sao7N2BW7ukhZBTz4tLQXW9MSLAa9+suZQ0+Yq?=
 =?us-ascii?Q?67CwlChczlEVlVXXFTVJ7UsId+PxJmITWj6NhwAie/q2gR+mfd/uLjLYRpqk?=
 =?us-ascii?Q?412SGp2MZLwXFLDffJFzmBqlfm2e+VuCh4ggGJtFLQTe44cxdue7Bzat3Vhk?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22d18bbb-4d0d-4ed3-4636-08dccdecccc5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 20:53:31.2856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k3+f9iXWcHMwysr87dSU1mMAGVg+4iLVkO7Ci5rbRCHYWnIC4ZFCY13OxGme5lmB2CkWk/llhokskQF4d2cU4ZkmTA/VV1GZOJNc9jWIYX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com

Jason Gunthorpe wrote:
> On Thu, Sep 05, 2024 at 12:17:14PM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Thursday, September 5, 2024 8:01 PM
> > > 
> > > On Tue, Sep 03, 2024 at 05:59:38PM -0700, Dan Williams wrote:
> > > > Jason Gunthorpe wrote:
> > > > > It would be a good starting point for other platforms to pick at. Try
> > > > > iommufd first (I'm guessing this is correct) and if it doesn't work
> > > > > explain why.
> > > >
> > > > Yes, makes sense. Will take a look at that also to prevent more
> > > > disconnects on what this PCI device-security community is actually
> > > > building.
> > > 
> > > We are already adding a VIOMMU object and that is going to be the
> > > linkage to the KVM side
> > > 
> > > So we could have new actions:
> > >  - Create a CC VIOMMU with XYZ parameters
> > >  - Create a CC vPCI function on the vIOMMU with XYZ parameters
> > >  - Query stuff?
> > >  - ???
> > >  - Destroy a vPCI function
> > > 
> > 
> > I'll look at the vIOMMU series soon. Just double confirm here.
> > 
> > the so-called vIOMMU object here is the uAPI between iommufd
> > and userspace. Not exactly suggesting a vIOMMU visible to guest.
> > otherwise this solution will be tied to implementations supporting
> > trusted vIOMMU.
> 
> Right, the viommu object today just wraps elements of HW that are
> connected to the VM in some way. It is sort of a security container.
> 
> If the VMM goes on to expose a vIOMMU to the guest or not should be
> orthogonal.
> 
> I expect people will explicitly request a secure vIOMMU if they intend
> to expose the vIOMMU to the CC VM. This can trigger any actions in the
> trusted world that are required to support a secure vIOMMU.
> 
> For instance any secure vIOMMU will require some way for the guest to
> issue secure invalidations, and that will require some level of
> trusted world involvement. At the minimum the trusted world has to
> attest the validity of the vIOMMU to the guest.
> 
> > Then you expect to build CC/vPCI stuff around the vIOMMU
> > object given it already connects to KVM?
> 
> Yes, it is my thought
> 
> We alreay have a binding of devices to the viommu, increasing that to
> also include creating vPCI objects in the trusted world is a small
> step.

Sounds reasonable to me.

To answer Kevin's question about what "bind capable" means I need to
clarify this oversubscribed "bind" term means. "Bind" in the TDISP sense
is transitioning the device to the LOCKED state so that its
configuration is static and ready for the VM to run attestation without
worrying about TOCTOU races.

The VMM is not in a good position to know when the assigned device can
be locked. There are updates, configuration changes, and reset/recovery
scenarios the VM may want to perform before transitioning the device to
the LOCKED state. So, the "bind capable" concept is: pre-condition VFIO
with the context that "this vPCI device is known to VFIO as a device
that can attach to the secure world, all the linkage between VFIO and
the secure world is prepared for a VM to trigger entry into the LOCKED
state, and later the RUN state".

As mentioned in another thread this entry into the LOCKED state is
likely nearly as violent as hotplug event since the DMA layer currently
has no concept of a device having a foot in the secure world and the
shared world at the same time.

