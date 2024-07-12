Return-Path: <kvm+bounces-21468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC72E92F50C
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 07:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D00811C22433
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 05:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACF56381D5;
	Fri, 12 Jul 2024 05:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DkM5qLRR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1F42CCD0;
	Fri, 12 Jul 2024 05:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720761637; cv=fail; b=gJDIdLgeAOeDpSlQl013HctMQC8p/mH4fieDk3N/67fvCZ9nSoem21jXXWygJ6t7sC2aKdGxtupIBejQ9/0FvqyUDkcqufcjb9BVCuvdKd0/zv0bxVov1gLKcP+SR4SbFZDqR5OgCjGrt5QflrTpU60esLWyxZCT0XMYV9Hy9rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720761637; c=relaxed/simple;
	bh=MpyHWwI6KeZTA9ItCAsb8Iny0TpyFoSMDxk7rIhhiN4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S9xANslvXjZ4dBge2a6gLiTg0gJ3QQZeB0HqmiAzs4a3yoUJQDZhNBXj3RvGog8x6yC0qmfU8x8oD9pMMD//G0sFGt+2doJK5xHjKvVepr1nh+hVLVaNDAU8B7fPMyNglcTmCO8sKrNAc1YAiwRWBr/rqvSOgIH/wNQ4gjoCRD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DkM5qLRR; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720761636; x=1752297636;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=MpyHWwI6KeZTA9ItCAsb8Iny0TpyFoSMDxk7rIhhiN4=;
  b=DkM5qLRRr7LTGonayqEz7Eg/zSJk9HnGKRnyDQIGEzawS/D5wnvfROHT
   58x3vyxOkwlZ9zEIzvDh2E39Du3+2P9b7bFOHisIE0vtFycDDkC2Oytcz
   UDxhNxHZ9iO3HUA5M1vnnyzto6139ZMrAjAj1XDVVniaQVcO0ePcJSnsS
   sp2jLwMnZIM6ef6CU9kBMBABO7u9zrHBzRKiRkct2+qJWuR6qZoT1O0oq
   XTClk14DTLkxRx2bgNQMLa8DZ/rtSylCtkehb4SlrafnZ4HkOs+qMDTiu
   mtC05KRsCVDS956sPkBCk5qRHHROkfZjANbPsTet86qhpJZ6wVnRLZLL2
   Q==;
X-CSE-ConnectionGUID: XQjvSyt9TleAuMrt2lkMsw==
X-CSE-MsgGUID: aYBNvmD7RiqmaTYkEIMFyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="28789609"
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="28789609"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 22:20:35 -0700
X-CSE-ConnectionGUID: pDa0J2spTtukc9nlrsjSyA==
X-CSE-MsgGUID: wocbz1V6TqyNtEQ12MOx8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,202,1716274800"; 
   d="scan'208";a="53098421"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 22:20:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 22:20:34 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 22:20:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 22:20:34 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 22:20:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l9v4HeLOuuOCYbeGMPfmfWHySRItxPYo4M69l0OrJ3h9IsgLq1Gj55JQnWy8qcJyBGO/yqZqA/KhH+rk0L/H0rc+TkaIZY3mIenPSS5uEPlRNMAibkr3YhJ6Go9vWij86AkcrRpLnoQ1sGd6uRuUdlBztUqrwrMgscBEjbQJ66Gb49yi6MzSNed0/lpvPjlfTQ10TefuiPPWQc/2IXSWubg6gjhu2YG9RQiqyMpp6bPqEOvEkyvYhvIQzfc51SSCVtoL2ip1DFCYHkTg7Cs3EMxqiEmTYF1y58OkKasLaN+XHMnCS5OQzAVjPcYYv/74lqo6sJNcUXMkMik9F7d9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PTSrdwOiLW9LM0HBupR9ophyG8P84MuZ8rEvI/yL90E=;
 b=UtkipLqWcGi8hBaZcbqk3jVRW4lQoYjIh2hIhsB1IVPbDtNIgXlmbqJnpodzZ2zcoYKiqY+Hi5OfA311JbX1AUMgv2ZuxZKHmm57MAlhyUjPk1R6atRXPqiEyMCK4rNBa6lUt+SV1Lu/vfQ/Ue/lQ0vlsuv+nbRxmOdTfvsglXxERh7GBmirsTSPk38ba5LfNkthg/1liyB1ZEamfeBoY/4lxe+dQk+Aah3pk6W0DmhHXR1aeAg03kvr5tNx1Gpe35Em/9TYyNBvADrHLl+gZOplcySX24G1E3FFRlXAtgZRS6aoIBw21KuCtMpcO0/oo84K5UHhOvuzI2OxPkq2OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.20; Fri, 12 Jul 2024 05:20:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7741.033; Fri, 12 Jul 2024
 05:20:32 +0000
Date: Fri, 12 Jul 2024 13:19:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Yi Liu <yi.l.liu@intel.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"ajones@ventanamicro.com" <ajones@ventanamicro.com>
Subject: Re: [PATCH] vfio: Reuse file f_inode as vfio device inode
Message-ID: <ZpC8zalggIyzdTFQ@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <Zn02BUdJ7kvOg6Vw@yzhao56-desk.sh.intel.com>
 <20240627124209.GK2494510@nvidia.com>
 <Zn5IVqVsM/ehfRbv@yzhao56-desk.sh.intel.com>
 <cba9e18a-3add-4fd1-89ad-bb5d0fc521e4@intel.com>
 <Zn7WofbKsjhlN41U@yzhao56-desk.sh.intel.com>
 <f588f627-2593-4e89-ae13-df9bb64143c4@intel.com>
 <ZoIKwAhOkgkTYtyf@yzhao56-desk.sh.intel.com>
 <e568a45a-4e1d-4477-ac10-103cd605eff3@intel.com>
 <ZoJDFyqzGVuntt94@yzhao56-desk.sh.intel.com>
 <20240710144044.GA1482543@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240710144044.GA1482543@nvidia.com>
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW3PR11MB4538:EE_
X-MS-Office365-Filtering-Correlation-Id: 432f27c8-f184-45d4-8bcd-08dca23259dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?l3jqxTb9wV3o17qrCO6Be0LlgtmE4+eCswd1qO+y/DDazwMswXd644404QNM?=
 =?us-ascii?Q?BiUyi0QIl5dqRb9DemWeRWLglrMjTvPnT1wMutDoPgkn/+tuUOhp7XpP+9bT?=
 =?us-ascii?Q?hmxuUG1b3w/JrfEGbVY3OnIsQYadYbKz1lLH964kemw54TGCB3LqU+KW23Dz?=
 =?us-ascii?Q?p3Y5q0mjAFnJ+JGo+lKtnWOsrpG2u/74D+pbrIQTcioG172AFMb4sWz2P6Xl?=
 =?us-ascii?Q?BFLO/DSbd77W7PLT34oXJnvaidYp1S1P7lInTpJpZV2D5c2qkd668KKmrQOC?=
 =?us-ascii?Q?7t2JnDJLhAOsOsplprxDQx9NMSIqQpMAognq34/E0diYTZVA1WmmXgeL937J?=
 =?us-ascii?Q?yYWAR7AC/PS3z8bsTDOL5k80qZX49Q1fUJlxrZuHS/o+rf9QDzu+jmFoJFHM?=
 =?us-ascii?Q?5UiWu7ou/Ow9vE3boMQ2fwn/3g6cyMu1OamLFsklsfOV3WVyUXd/X+uu5fLk?=
 =?us-ascii?Q?xk3nd4nJ1KfQ3XSE/cmBYK/4ROuj0/LublHSRDjCtblwaPi9DgZ8Tzz5gaWX?=
 =?us-ascii?Q?wfG2RSc5OynMDJVK3vfyWEWm/UCzY71yjBFam4mdHNncKM8WnPA5PRJ76OgT?=
 =?us-ascii?Q?C/osDrCsbomqqaf43SCuYn1geH+y1Ww0vj/5xgBpPNhWkSQBDIophwKBywII?=
 =?us-ascii?Q?bCavRTT+HxjpBulf8DJzXdNDR3HKETf8ERDeHnzlHLhX76NxUHezMg9jC+3b?=
 =?us-ascii?Q?rKEBhg8bQVtHuqBEf3ZjgN1Ad7N32klmWnTINBde4SyJXlHh9f3IvhDLHbVV?=
 =?us-ascii?Q?00bzvhyBRZp9IUA057jqUyT9/ajEvbPYFbz0sR/gVu6wkjuvXKJPZj+BXXr2?=
 =?us-ascii?Q?i7obr5uvsD2rxg4ok90buPViqe2fLPdcQxFqE1rRvSO6Zz/YCuzeQka3Mx3Q?=
 =?us-ascii?Q?AgFu0oX/FqwvTUwXBaW++gyUP/14fGqZD+0PxS1nReEXMB0kfjV+UYvGmlaP?=
 =?us-ascii?Q?IEGIB38WtXGdupWCzBZtDelUqbvHK+VoKXZv+VpNWcQxb1HL31QTZa2tYveX?=
 =?us-ascii?Q?Y5ml0tim9wsp+9DmCz1IVcM6QpSOdxswn8YM/w4wqVRBqMVQ4DWmywTAIm1z?=
 =?us-ascii?Q?XXOshPM+Hg3I9GTdeObPSL6Sl1TbmMnHy1mfDS+5aCT7b2NWZCj9LJKAB+nG?=
 =?us-ascii?Q?8z5AamGMd8pku3p3ZUc005vEGog1q4Y83U3tcBS7PctzjeTbY3Q2fLJnXqEe?=
 =?us-ascii?Q?PHikWbcaNEOGHoHc23FDfuCAyAd91DsdmezDuTnP0kbdJNIHlZfciMsSy5LW?=
 =?us-ascii?Q?aVTUHMzBi6Whl+8OPsbrF76LAznkJnAtarkcA1osIvYbhJBCYzfOf9ddTn1l?=
 =?us-ascii?Q?VGNSxw3QR/0aJQBbdWV4iPSmTNnDfYV0cUd0cQwHWBHrGg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GMvygpzf2Vq8dTYj8bSi/qTm685twXfxDlygMHXrbjlzNd+gj2Xjyw7HXkwW?=
 =?us-ascii?Q?kYNCQuYkY8yLfCYQUqLFzfc1NxsEzXtee6wq+Z/aX8YJZfF4pz3cu+lzRmm+?=
 =?us-ascii?Q?fXiREPeO47sFRBzCRgEOY+/9yP3mRh3nJQuOZ0/V0CB3UQE4peH6z4SKtC84?=
 =?us-ascii?Q?EULqcblZUHbs33ud/8b80TpmglNnA5dYKxqnCHHIZpZ6DKFLTejQGCswB0pt?=
 =?us-ascii?Q?Ko/0tNGD5fqzQ/sp0CbAQn4D+LjjEuA+VF14RDD2kBDFxHcIRjO93C1pxNUQ?=
 =?us-ascii?Q?ON4zCLwK8aN9BKmmeeMKAF4ad0hh58BgbpWH2Dsqen/jDm68tvvEwC4ziL4r?=
 =?us-ascii?Q?LEoR/FQQ9B6Uafb+ViNBaZ3eELAtQY5RfG2SIZRL0EEh8kapqYr8ltPCkzsQ?=
 =?us-ascii?Q?qjcGXeGMDMgd+WCJkjQ0RRlFfHBIEPewaYBZ+SxSkPF+NorXth8IPVvg7zba?=
 =?us-ascii?Q?Zprb5BdcZfJXbFQCqrHDwTmsn5m5kKrGNjzVN+IXicBCltrUyCNhn70Tyjnd?=
 =?us-ascii?Q?xo3bCg90AaWJkoiWwtLa5F9sMFpSB++vnDpAI5z8hoxElahCi2wYBrj3968x?=
 =?us-ascii?Q?s50zBI1brzYaZtCyLxqys6oRNQuWWb2ewEIjQA6+rez5YUlvvJjfCUS+MJZZ?=
 =?us-ascii?Q?fzjo7hwUk6XgIaax4sXOK76ePRHymu+wG+NlGZ/szsNmR7nSypRfNt9qC8cP?=
 =?us-ascii?Q?h5K9Lnz1d6CsocHWh+jFc1XwLSDuGfEyaK9DrzrY4S6n4B7JGB+eWu7d97pv?=
 =?us-ascii?Q?ZMLfTzkY5q+sb+0x6QHa7fA8mTLFAXWQzc8DXbFSJqcckOOObZaSaDPLZ+aL?=
 =?us-ascii?Q?pc3xPSBtwNqIuwnByvdK1nm19kO8NhNE2d5UuthIapLyKzmIZwOiDCzYN9oq?=
 =?us-ascii?Q?cfIUuMimNyumYsWIQSOdd/GXwaZFwAZ5NGHNNnU71x6vebrHUdXVf7xONiL3?=
 =?us-ascii?Q?Jj1pqjn2bfOwiCjzzuyK2wmhfKmVenhxKTSyn3RsqMCDRsh2XdGzzr2zkHCe?=
 =?us-ascii?Q?CFR4aSnNXgdWn3cpCTNuisVFfwoZtK+4Pj0YIABANexehdvJKGnjliMbm9ET?=
 =?us-ascii?Q?tMNLL/0qz9GRE/Oby7NGF7WUque7+/oPnFdNQ0XXRLN1c3Ek50D/NefTuVc3?=
 =?us-ascii?Q?eaZXviEr5+r7XtGDyI3SXg34qu+jWh3n9UGZ59K3ehfzbPAE5R6pZhS+D08N?=
 =?us-ascii?Q?ZU6rIbiDowAV2jArd1bTFHLDpWkxX+LjyYhu+rb6dlloVQB/f3xBqpUAp9gg?=
 =?us-ascii?Q?puQC4cjFDynOf+AcGSKpx4ez2f0myDXFW0hgX4eJhz/W+owvENZ+FnMs99QL?=
 =?us-ascii?Q?IyMjkkhOl6qUKIqRZCczTb0UVUEqkp6pIwcGu8pky8u0mH1fztLDOrvHC2Ed?=
 =?us-ascii?Q?YaYjbEtbC3VPldCfNw23GQFoZSzMJ4fJNoDfwnpgm+yb878rVGKoQcnYiKLE?=
 =?us-ascii?Q?PgTDt5tXZvOCSlVQdQ9DLHqGjz4B8PZGK7AYpFmCpyLLVMc4KHhDZ+KmqzTW?=
 =?us-ascii?Q?l/l3eBkwNFANfHnG0RFrEGYgXvdrxtl53PoBT2BacK5voGf0dm+zERBzsWlS?=
 =?us-ascii?Q?nWn3NGgfZ1mY4IVicp4KHczcX5lDbxCBMktR9XMO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 432f27c8-f184-45d4-8bcd-08dca23259dc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 05:20:32.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Higr0w5StbMGVGVDz9AjYaPQhKKYvHGx3GMDsf7RrASx9u97gW1UFNxdRbvrOzf6nDuexZ429GOtNRlg1aC64A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4538
X-OriginatorOrg: intel.com

On Wed, Jul 10, 2024 at 11:40:44AM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 01, 2024 at 01:48:07PM +0800, Yan Zhao wrote:
> 
> > No, I don't have such a need.
> > I just find it's confusing to say "Only the group path allows the device to be
> > opened multiple times. The device cdev path doesn't have a secure way for it",
> > since it's still doable to achieve the same "secure" level in cdev path and the
> > group path is not that "secure" :)
> 
> It is more that the group path had an API that allowed for multiple
> FDs without an actual need to ever use that. You can always make more
> FDs with dup.
> 
> There is no reason for this functionality, we just have to keep it
> working as a matter of uABI compatability and we are being more strict
> in the new APIs.
Thanks for clarification.
Regarding to uABI compatability, even after being more strict and returning
error when opening the second FD in group path, the uABI compatability is still
maintained? e.g.
QEMU would correctly reports "Verify all devices in group xxx are bound to
vfio-<bus> or pci-stub and not already in use" in that case.
Given there's no actual users, could we also remove the support of multiple FDs
in group path to simplify code?

