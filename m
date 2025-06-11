Return-Path: <kvm+bounces-49043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09729AD5604
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2B2F1BC2C6E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC95283C8C;
	Wed, 11 Jun 2025 12:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EBHCDC8h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74938269CE8;
	Wed, 11 Jun 2025 12:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749646403; cv=fail; b=HZTWOKltTefByMEYx2GPs7sYfvtj7N99xkCEH4N6fsCPlVzID5KTJzB3mbP7Ae9lpaFAzu5uhQpXcP/F+5+c67F7DeYhyKEB6xfjiqtnuXXg9XK7n5dyZw8dAUQKntcqBOx6wd7we3P163sE9YFhts/cj0qUB3oWHugiOHswMwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749646403; c=relaxed/simple;
	bh=KZ535954n1OrdFSwDykxBKngj0ZPSTuWJtsLBkZcpzA=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pp80QiIn6NGOM9+XIXOO2LhbJ9Hv3LmDm2nCnJwVu+Ny0C1HcQKXN0YVLjo42n3FzKzqkj4GIBR7R5VghEJMtLv6ixz1rKZRpidMo/U3Tblpw9/QzrS/CQm2DkS00onBQPZR0qabkTA05iQFU76cX8dhyUvta+osld41VAk79jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EBHCDC8h; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749646401; x=1781182401;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=KZ535954n1OrdFSwDykxBKngj0ZPSTuWJtsLBkZcpzA=;
  b=EBHCDC8hpKCemOvWXaegOkbnZAX9UFHI0QgkBDdGPlElf8zqQrdE4b1n
   aSh6uLmDPmmEi6jY2bNxhM5SGUKUoccsjOEYKWVgEivFCdvxlq5mfdaKU
   AdEFkz+CDwylrvDLKuCuvKkEViTxEuXNFM/aIL+z/nBQXxgQHepCJOjG3
   779E8td/Mjo8M/9He9xEIVasxTfoyZjqzlyq7pkdMJMbDbZQNbF+6S5nK
   A3u4fbH3DpKleL+nc+N3x+jNI0JJYWq34yNhuGvDBb7yXBog2v9ISt8VV
   kZdckAzfJ3LO4wnF7JBLqVbb2xzoRC74p5u3tNTYHx536ezbxnSFsoHYw
   A==;
X-CSE-ConnectionGUID: +5pNb3D2QcK0BPMaXqNQyQ==
X-CSE-MsgGUID: 3Ix/4KRpSpyIJ2cw0GDslQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51500242"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="51500242"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 05:53:19 -0700
X-CSE-ConnectionGUID: /jCaDI7lRk24CXmNy8X1LQ==
X-CSE-MsgGUID: 1CDeGw3gQPS/A0/sAerUGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="152468965"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 05:53:20 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 05:53:19 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 11 Jun 2025 05:53:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.73)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 11 Jun 2025 05:53:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D//a+ywew8mpF6S4ODP/7y6jqUsOqXDWbp/F0ab9WD15Tg7MSUmMf8EB2Ed1Jkj1VNU/oLN3o4pJtfRPy0RuiDzFCOFbruiBF8dms063bCgER3Or/Mw+LO+ZaIZ9jrfbYn5/82LiVoq/suMkGKbuy7gX616WNOk2mbc0xoMbZaSfBcHQgMiiAFm6vKjcheeUA2ztUjzFB7Mxs08wNH9aXwy2OA8wVfwBPiagzjiGiC5S0/Jej+vxtmVrFt0GI3LxclZn1002obouFBtJgAY5CezUQ4o46Kfcd5eSc4benhvTZKTHCdoALkwZG64bt6cOJzhe79pC2owMaR4L8D8v6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+XjASrKPExHJAk8pho0wTlaBU89BUjYAvkraHd/JCPo=;
 b=o/4A8xwd+Fril8d3kDS1yz5U0PNR45P26z2FIuOJq/XXfW0feYxSomQlQ40qg0ZNmss8/Gh/U9Vf/oxqWu0iaRABcYgiJBcsedIHcXnmI3z92pvhV9IXQviQPBWo1zdh6bDuBjn4HJLB2SivDAcgFi0Ab51ZlTrDrMHurkA9WujPjNEmKrhgWXFh3vJhPmUM6vtl5APe8W72GgNalUNyuw1EJ7ZUb6phDEMNMtf0CAeXvTaeyE/HAL7Gsvf+kNczyvLrmzrMX/RBhQtjHWMKEeOpq5kuHAS7SfSeuwAUr9MCv+nw1LBKr5xV9bLAclUGD/sSiNJx+CtuE6Ow7CnWJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by SJ5PPF8F93806F5.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::845) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Wed, 11 Jun
 2025 12:53:04 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::6826:6928:9e6:d778%3]) with mapi id 15.20.8835.018; Wed, 11 Jun 2025
 12:53:03 +0000
Date: Wed, 11 Jun 2025 13:52:55 +0100
From: "Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>
To: Mario Limonciello <superm1@kernel.org>, <bhelgaas@google.com>,
	<alex.williamson@redhat.com>
CC: <mario.limonciello@amd.com>, <rafael.j.wysocki@intel.com>,
	<huang.ying.caritas@gmail.com>, <stern@rowland.harvard.edu>,
	<linux-pci@vger.kernel.org>, <mike.ximing.chen@intel.com>,
	<ahsan.atta@intel.com>, <suman.kumar.chakraborty@intel.com>,
	<kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] PCI: Explicitly put devices into D0 when initializing
 - Bug report
Message-ID: <aEl8J3kv6HAcAkUp@gcabiddu-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250424043232.1848107-1-superm1@kernel.org>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: DU7P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::12) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|SJ5PPF8F93806F5:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a1132c0-4c7c-4ab3-d6b7-08dda8e6e77a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BPD4yfXnFxHPUleVMuC4ihXj1WLWv9ywPVK1Zw/2pottFk4GOZ8XkO1TI71B?=
 =?us-ascii?Q?z8ruH155k2aZCibpUpXJ6brL0j51eHz5nAadUaH8hP0xy+/Li7bF++7PKwDp?=
 =?us-ascii?Q?Qs7SBgWMsr9MwyL5LuGHwQfozLQ3gqSV34QAZy5oqfXpPxfD/HZIXMKwtAju?=
 =?us-ascii?Q?o0RMraTe8RoL/p9cCcj2BPfDEU9fEP2HZetTeZNGaomLMubgdIBVj4xAvuzS?=
 =?us-ascii?Q?ek7UHVMet2IHEMqC4NLh6L88JZy89cEfOxzN5JiIb7qAAI+OF9e7xlO5IdHk?=
 =?us-ascii?Q?ZAVHyNiCrQS7pfzI4gmnGu+7x13IyJ7f5ef8UQK6cl8RYn8rC9wtsZM+F1oc?=
 =?us-ascii?Q?J7ui5Y5Cur8/CT49kutg4SnxtMnIrB6VOcmj+RBo9lJx7zHgnizEQnf1Tppr?=
 =?us-ascii?Q?3f1qKRJuEWV2cshiYYRYuQ4MkS7TMbIZevJZlcwwvxXiyicneU2798yfNIWd?=
 =?us-ascii?Q?mylve4Lb9GkDp2JrHM/IDFzkDJ+6IoebOkizDrsdtTCPUAncAuPeV9Hwg8r1?=
 =?us-ascii?Q?50l7JURP6111b0He7rgFwZ0qN26FK0AqrJnoZf8dGKwKdt6F4q/vNiMAn2OT?=
 =?us-ascii?Q?1QvnrjEYzbzLHIqyRYyjoCLOswrlFKzfRTVrwFgf2SB4AYfwlyDqmHXN7ONM?=
 =?us-ascii?Q?d1oxzW1FyHH/sDFIWV3enYmBUsTqrfa0O/eP7PgnxlKodH5DRbQGlLbykZ1e?=
 =?us-ascii?Q?2rJu1ULFJWdKjPCD1DjsRDsYnZJRuM2A8DIbjJ2tWVIbi17IJrL2sOSvfSXS?=
 =?us-ascii?Q?51ou6FB+uLYWJvoh0ZSCnqXzLdpFmy88tNTt5PPbqzL2T0gtLAzpf0GIfVYf?=
 =?us-ascii?Q?VtzYTD8nsbFa6nWvi2M7ztbsXS9FdNGyELu8ZQUThYYfQWoB3ps1SZ11DNJF?=
 =?us-ascii?Q?2i3wSfJOPBtAy9Fwl7i6p75S6l2klr/OlOCobD+14ENuL+vUzwfwSZfFLpxk?=
 =?us-ascii?Q?/DuK2SD588MqLtaIGNQb3I7gqnCCsAIBam2n4ofRNhqeZH+pDSSXm99rqTt7?=
 =?us-ascii?Q?t1KfH6T1/msHCpClJKBlcS13fRBGwcUvSu/EXYQF2ZC7XYgm4SXmzZOGnuFb?=
 =?us-ascii?Q?KnW3km/tnd7+klfIBPUJ9J78gFSPzrwZ3eb820nC6AFxqS6yHzwuG6lpeLme?=
 =?us-ascii?Q?WluKvyxdBuDI566gUVEt0psFh1t46t3AHZr7aOFuq5U6UZA3eBoUZFJp6+1O?=
 =?us-ascii?Q?QdTmSwzoeirmgMLLyH/qYn26zY1/YndPloW0wvWY3wzW+N5C1NYGqRq70gem?=
 =?us-ascii?Q?KzCt6uaDco07cbJmBGTM0X8ZN5D9RqGdIfvZUkKtF6iavQNcMiy8hkMPgKzz?=
 =?us-ascii?Q?HHPDBzkbg1Oo8WVvJBS5IWmvY43p8n33couE8J4RefVe9mNLay36JHkFBNS9?=
 =?us-ascii?Q?v9McIYi/lkb2g3E0JXYjnd9Fh5ZTYdVCm3jBnIcAEXY92R/HfqnjX6jUBpEh?=
 =?us-ascii?Q?UwRW7i5yLVE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9wnGjvSiCkY2b+gmCyiaZ3r8xssC7akCGgO8yFHhOBnvOykrFM8RVm+5YnMn?=
 =?us-ascii?Q?3Q5TXDP5jiicueU4ALK6sm/oBNyiQDxOXRVMmvYZ6s6KIPF3YVNcUgcKNQ/r?=
 =?us-ascii?Q?udfx5VkUXl2KeG0gb4Y+XuUbTrqXYeIyzJFa1v6OTo1R+hu9kDLD+tZ9HK1Y?=
 =?us-ascii?Q?pu4ttTzT4unmgvMMcys0iwWhIEkUMkLzQrMOzRmO+d+s6iqBYUSWqhCJIiw0?=
 =?us-ascii?Q?n3mPEuGlwCMxgLGB3edDb9m614HZh7tn7pwaNWt4Yk25xPap9KFCZ9f7Hxjd?=
 =?us-ascii?Q?F+3HyDYO09iOQdlndy/7K2HAc1pfBKPSK0YsJ7TTKL4EwTx1fcN/Z4Tej4BP?=
 =?us-ascii?Q?4lgoyLiIZnON9nwHO1ddZf190moc/CA+clT8jGF7f+8GYd1M0YNfnfjOHaML?=
 =?us-ascii?Q?Mgy+e6lmRCdUZounGuaXJabLkDrAXhboLtBMEOVGFyiC3RVNpF4NbHySbKTD?=
 =?us-ascii?Q?zYvSBlkvqVlwt3ckz5FO7VEzPvpGDd8GHFv/MBLcrPwq8zDDagJxLnVtl7wW?=
 =?us-ascii?Q?EpZNsgt0nMxVbgTXehB/Ijtg5hxhF6Q1B46jizMeJaB0qR1AUhxuSnLBo7ks?=
 =?us-ascii?Q?iMbiEZjr7ROg1y9+kKE3UiuERKniM5SAas3v9yYZD/1UdPU7nYT73N8fiCAq?=
 =?us-ascii?Q?7D+ggNDtVCL/qDX3JaPF5j5RDLi62apPzTQvYEWsLxNrdjMuMjpjxuvxHE7U?=
 =?us-ascii?Q?e3+dVsznVT062qWpGgTn28PbwmQ9FrpnWVkhiq0hfZle7LAeJPCRJIF+xiJy?=
 =?us-ascii?Q?nb8/yGU0s9tLVxP0d4MD3aSeUYOtJN3hhcUlLl6oFwuZkiHMtJ6mAOSiy+oU?=
 =?us-ascii?Q?1AVZiHHeOPK4mJKKHhBsKK6NccsdzqzUyzWBpD6O1jFi+o1KLPLw4I/p3IVz?=
 =?us-ascii?Q?qmcqvcoZ7KMMomv2sFOopasxgtsDvGqXedGAAmcJ4fXlQRErn7JUENdLpxgE?=
 =?us-ascii?Q?MAdF6PoRxd5DgN/7Vw9D6jEyAeH4ZjPO43mAosxAn2UXwNXQELvujdmZMrQP?=
 =?us-ascii?Q?z+CwO7c8cKBOvzPyIYL7ecK52L8yNRsEqAlRiTcn4ocWNdrdBSlvGc4e7vGn?=
 =?us-ascii?Q?s3Zj9kvz4yAxjQa7qFMgh5HH1NsQNTApAO7tv3Z3nUdRBGllL937n8qsGZ26?=
 =?us-ascii?Q?zre7G6Djh1gqgdGVByZJWvQ0oC50FjJJnlCqF5SR0NeBopymwAlCnO0nKSaS?=
 =?us-ascii?Q?vQLt28LXTGqLT4W7VrO5WAPvZpYtipdr7vUqJPgDywHo+7Taoeauj4fJ7R+N?=
 =?us-ascii?Q?Kppdv+SvAF369Uokt0T/wicoTkhtWfkS0NHyVBXbepFTy634+nH5tOVAlK/C?=
 =?us-ascii?Q?ItoDfaoS6U/Z7lWYKDVsddlJkh4dbgp3mkSYg2EccsWl+DhT5vvQiCh0PwuC?=
 =?us-ascii?Q?7pFtjekoN8E4WUVH2HDNX2Jb16pAG+oEJZg2F6zLRJS58NBkar5+6lIj6ARa?=
 =?us-ascii?Q?trroWpGJBzF3hgsIcDbYbg3Sws5/4fChMm0OipU8R32syYaDyixG2rSo2+C+?=
 =?us-ascii?Q?R1ZH/qdetAGKIz+kL1areFhjeLz7FZLvN3GIVjwmbxvnnBuQ/ke9tZzwKT1p?=
 =?us-ascii?Q?+FwDhNWeE4V4BzgaBw46ZEA8acBEoskXa8okETneG/hqKwP3PLBydioA8m4n?=
 =?us-ascii?Q?lg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a1132c0-4c7c-4ab3-d6b7-08dda8e6e77a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 12:53:03.7837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bQP0KQ4/2hRtegwt4P1P5XPK49xPL0WseIHkTQTYMtDuuAq7ZTfO18XN6G8iLIWSenGMT58X+VH6JdHWpuLMyCcityE9zt3Dr4db79b03ng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8F93806F5
X-OriginatorOrg: intel.com

Hi Mario, Bjorn and Alex,

On Wed, Apr 23, 2025 at 11:31:32PM -0500, Mario Limonciello wrote:
> From: Mario Limonciello <mario.limonciello@amd.com>
> 
> AMD BIOS team has root caused an issue that NVME storage failed to come
> back from suspend to a lack of a call to _REG when NVME device was probed.
> 
> commit 112a7f9c8edbf ("PCI/ACPI: Call _REG when transitioning D-states")
> added support for calling _REG when transitioning D-states, but this only
> works if the device actually "transitions" D-states.
> 
> commit 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI
> devices") added support for runtime PM on PCI devices, but never actually
> 'explicitly' sets the device to D0.
> 
> To make sure that devices are in D0 and that platform methods such as
> _REG are called, explicitly set all devices into D0 during initialization.
> 
> Fixes: 967577b062417 ("PCI/PM: Keep runtime PM enabled for unbound PCI devices")
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
Through a bisect, we identified that this patch, in v6.16-rc1,
introduces a regression on vfio-pci across all Intel QuickAssist (QAT)
devices. Specifically, the ioctl VFIO_GROUP_GET_DEVICE_FD call fails
with -EACCES.

Upon further investigation, the -EACCES appears to originate from the
rpm_resume() function, which is called by pm_runtime_resume_and_get()
within vfio_pci_core_enable(). Here is the exact call trace:

    drivers/base/power/runtime.c: rpm_resume()
    drivers/base/power/runtime.c: __pm_runtime_resume()
    include/linux/pm_runtime.h: pm_runtime_resume_and_get()
    drivers/vfio/pci/vfio_pci_core.c: vfio_pci_core_enable()
    drivers/vfio/pci/vfio_pci.c: vfio_pci_open_device()
    drivers/vfio/vfio_main.c: device->ops->open_device()
    drivers/vfio/vfio_main.c: vfio_df_device_first_open()
    drivers/vfio/vfio_main.c: vfio_df_open()
    drivers/vfio/group.c: vfio_df_group_open()
    drivers/vfio/group.c: vfio_device_open_file()
    drivers/vfio/group.c: vfio_group_ioctl_get_device_fd()
    drivers/vfio/group.c: vfio_group_fops_unl_ioctl(..., VFIO_GROUP_GET_DEVICE_FD, ...)

Is this a known issue that affects other devices? Is there any ongoing
discussion or fix in progress?

Thanks,

-- 
Giovanni

