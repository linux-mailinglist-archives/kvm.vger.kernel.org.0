Return-Path: <kvm+bounces-25431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0680896555A
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 04:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 029141C22631
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 02:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01FB3132105;
	Fri, 30 Aug 2024 02:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PHu5TSNd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4419130495;
	Fri, 30 Aug 2024 02:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724985688; cv=fail; b=TY3NuYqcFdN+u0KxvsuH4XSVCDUa5LDaNTnHkSp1DEsCIxzaK28vVX2UQeF9GAasaAhcD7w0KoNN+RsnxubUQOA/1+pDWm8ByYYJGGvf3WWB5bB4Bkvcv5JjbF7r1cWIf5lVJcn2tqHdj79c2XpCX3LjYkD805244/up1lBnGJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724985688; c=relaxed/simple;
	bh=MJqud1tDUvW5CjiaC8uDmqmN5jS3MtnJ7avjXsV86h8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z9qUcQEYvBS4Ra+G4kb5w6KSvyfqVbCXbqzBzczlko8HkpZin6aQC4Amz9BfYoV+5kV2ncxCqTG0IfIsdVJUTzSC8a6urpU4UoVBvqoAhIKjO7TQ/FzlOEF/HNWANuIQTcmupXUZOO0kJKzekq45f0+1L4j1GEv15t8nTa6FE7k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PHu5TSNd; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724985686; x=1756521686;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=MJqud1tDUvW5CjiaC8uDmqmN5jS3MtnJ7avjXsV86h8=;
  b=PHu5TSNdG2v3pNDNkWv88eywQtpLV8BPpscZ9N4t7LtQd8e4IIzXFsad
   Gu3+JYjuq+Z4SIMsyl5/zvRa1q/ua9h845uFMtR07EXP9Y7WBfiyIWOfl
   xoHN8RUeAKFzoJQv+Y8YkIPkLDwX8garprJ+qv0F7aUKiVylzWn8551hH
   ChWiU/UKJZzPFlj6HOacrHp31h6BQqJk20x8AamrajMQDqvlZgPziMbsU
   TJ3qOMjLhvfvJo+0AVSSFqxFRX/VPojCzATr7ipJ2aYZ3Nvs49p62jKbh
   doxRyT+c0pwmecm6LZYowKRKF4UXHAUaYaMXwzNzfBBxKhRJmvbotcZVW
   A==;
X-CSE-ConnectionGUID: dGOSOUmkRuW5mgTDjuIa5w==
X-CSE-MsgGUID: /HRzOkVLSsSkT2prMrgkHQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="34775403"
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="34775403"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 19:41:21 -0700
X-CSE-ConnectionGUID: hmJl9On7QMKVIDkHnNy25A==
X-CSE-MsgGUID: ZjKu4V52QLW2kVwvagyJlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,187,1719903600"; 
   d="scan'208";a="63398046"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Aug 2024 19:41:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 29 Aug 2024 19:41:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 29 Aug 2024 19:41:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 29 Aug 2024 19:41:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8Ks11r8APjxNCUhKaDTjzhnxyD7gqjPSBzKBcGTDkP26FzLvJkxoLvUshSA+H2oEmWAQ1nxcDs80ac7sThqF8lDil/iTbIn3FYg4bu/maOkIu1U3voGaAipxgbNRbqnV6StviJyrYtzUIkdItlC58ZJn9emUk24xQGeWo/sgKWnNiLJ1aG22vwa3/B6tF+C1VqJ3+LDlze5Zbo/Pu6WHxHauLROrBYr68kKf79dfrpJuE2wSIK1yf8HykPdtfCkU4SubPDhpxgvTB7fD3mFDhwfdTMOW7kC4GKI0Bb/Xpa7pMdJ5sg95CJas/UMNC6bb2Xu44zWMubc+hHlR/Znig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4v3J25aalJY/hqSd6Btt+t5arSWFEWF7PlSoabs/Zt0=;
 b=s43op2maYbffzWnvJfr/bCAeaalSg0Y2SgAN0vtBqjGa/ZZN6nDYQgNsZdHvOIXZw1pMz5xGZoXpMZt4nbhvbVLWGG/2J/PY5P8q4p3CoGM7J1CCvZzhaI3uLLbQ4mCuwNAiGt8Yd0mYQW96JU/2M2PO4q5BnsxHs77YfVL9LfXvQ4QOuAL5Bxb3nIOUSe8/yJY8+QgMp/WkPPWL1MvCeGM55HHFIkeh6Bl7+hE4qtf/ypUWzNwqTOEcuGmS5G1/l9AjYo1i92gFUXQAWt7xfPnghomgoS5VxzRf+1qwJccIx7w8z8feq+AWumCENbGbh49mGPI5LRLsrTwWqkl7Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB6287.namprd11.prod.outlook.com (2603:10b6:8:a6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 02:41:17 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%7]) with mapi id 15.20.7897.021; Fri, 30 Aug 2024
 02:41:17 +0000
Date: Thu, 29 Aug 2024 19:41:14 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>
CC: <iommu@lists.linux.dev>, <linux-coco@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, Alex Williamson
	<alex.williamson@redhat.com>, Dan Williams <dan.j.williams@intel.com>,
	<pratikrajesh.sampat@amd.com>, <michael.day@amd.com>, <david.kaplan@amd.com>,
	<dhaval.giani@amd.com>, Santosh Shukla <santosh.shukla@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, "Alexander
 Graf" <agraf@suse.de>, Nikunj A Dadhania <nikunj@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, Lukas Wunner <lukas@wunner.de>, Alexey Kardashevskiy
	<aik@amd.com>
Subject: Re: [RFC PATCH 04/21] PCI/IDE: Define Integrity and Data Encryption
 (IDE) extended capability
Message-ID: <66d1314a337f0_31daf294f5@dwillia2-xfh.jf.intel.com.notmuch>
References: <20240823132137.336874-1-aik@amd.com>
 <20240823132137.336874-5-aik@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240823132137.336874-5-aik@amd.com>
X-ClientProxiedBy: MW4P220CA0027.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::32) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: f2999c42-df00-45bd-e12e-08dcc89d3913
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oJx9UdDDHnFnAlRl++046m/3busIkt82brmLobuO0cmqZIQLq063cY4acee4?=
 =?us-ascii?Q?RjLA8xmw7B2Rc0eLZiXlPdKEJFBGzmVyolnjNgDUTa2IMGux+a7NLyeECsDz?=
 =?us-ascii?Q?kzddk85BRhMhKwqghRPjNoidxnQHrbP6fnh8aqsPW3K4DvkV8qLeTmetb5qI?=
 =?us-ascii?Q?QgKBBs1QgKEP6/MIui/92wlpBS53HncXpZtppZCUU6yCNlPbNVyO4wxauq8m?=
 =?us-ascii?Q?T+q+ANxYUrn1KM8khNVuVBU1fGWjAjfDnSdeaTvkpO2yKqC9u4y7EYQ7bYNQ?=
 =?us-ascii?Q?QJZrxXIx5nEOlgctvARh5Xbi5mgvxIVI9hMvlGH0uXmC5fftuVrQCdx4CFti?=
 =?us-ascii?Q?YEyNP2jD+QJNKO85OHQMQlH9Ebt13y36a9e1uWswmAiN+bjQeVjvL/8EGyOT?=
 =?us-ascii?Q?x4lse7MCWEPvOmR3XeQxMBhuPuirD7BOkRN5RDQtSgNUz0HW+koEF1cOo5eT?=
 =?us-ascii?Q?hPlZKELkvbFHWaZnT+BVPeXDZRcgj2ulouO2kJqWdKw+tRqbQnRjWenN9I10?=
 =?us-ascii?Q?wZO9Hxg+SniOrTZRkHl5DyUzJUJeWSRywZfT1+sYaRHJaL8sjqI/IxCCPGOS?=
 =?us-ascii?Q?kR84sRiVNnna266KRxqa38qBtu/RhYF5C0POgyUUTWN3iZ7hYfkgrzyVEFKf?=
 =?us-ascii?Q?2UMHRIoztm2MHvheqv36yjieQtxgH9pjSyJeIcjFKbZSA15tNkTaO9GNk2SC?=
 =?us-ascii?Q?18Fgst6dL/Yw2LF8zb3GfoNOWJLRAxRRJbWWcEUYpzXn8RRlxNsn0DwPOusj?=
 =?us-ascii?Q?5rMwodbMyEXanYOGJW8WegujMhbQ15+D14xIuZtIRo1aab7NLZJDjJKBE2hM?=
 =?us-ascii?Q?r0Mhg37dje+CL6uYN2GiVjCZepdTUjQX0cLZl3C43vj8Y+0saBNelwheNW3V?=
 =?us-ascii?Q?SH3IAURiSCDcFFlDS9Y3ANDkhdcLq55T3g9AAcO6PLOI0Dp8LU/gWAvPY2f/?=
 =?us-ascii?Q?V1gdR/xE9qW3r3L4bQ/buKjSLc4lLAAGLt0tGOoUe2TdUGz1RwWJPWfLFQO6?=
 =?us-ascii?Q?afKHJY3/k50PihAU5L61cNHpg3eGgIsvXeVRv0xfmf9EFlBpuWi24fJ5s7ZG?=
 =?us-ascii?Q?X3Q9teGfpsjDp4ofT/RP2ja18rE7JcGqPWV7JrAvly2VTXf/q9ycN4Xb/pxB?=
 =?us-ascii?Q?SQNE02Wc9fMeuo7PxUkBMLDsdKg/u5H4gO2/GO1E6U98xkAnav8Sz64M8Kf+?=
 =?us-ascii?Q?ZSf7psOvuU1I1g0kRlSISxS8OX5N6t3u+okZZcZuCNKnkt3IdYkOk+xr+Qxq?=
 =?us-ascii?Q?ifB1mJ1sI/mAOGoUjBHONL7F8TTozQULABzprBxakLH5wyi2ivpGcuNXBWfz?=
 =?us-ascii?Q?XrUMXWWdVPPYUAn6jU/Sw+ZlXcaRtqm16UhjjD5qIDIUeg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?shgzoI4kYb/P1mWgXwL02O8egIcjNmIU8KUzbsDZww70sNZnog1nGY90HocN?=
 =?us-ascii?Q?EskgStt0EQLM7yozTPAODNV6t1Z6K+M8iWCsDKYoGMawiqxTgP50jZFClLuo?=
 =?us-ascii?Q?B0Ge2LVKxdwmktVANJicbyXleHvI7E/M0bfQonJDaX2JXkwglT4uSn+z15kC?=
 =?us-ascii?Q?68NH3OT+nDr56fnog6UAhUUY1+gjh6cqgTIALRMPpXv4HTtzRxHryWdqV7xK?=
 =?us-ascii?Q?TjDbaBJHmK7RoT6n86Zt1aOetDvCEXcuQ5HrUXsT4Q9mPzRo6R/D6c8gIoq4?=
 =?us-ascii?Q?wyvkwX16am8rmVMllW8WhwN34rCCg+ljrt5aU07catls7iSpVVeLYct0bib3?=
 =?us-ascii?Q?3PTXS8LSCQwYx5BW824N8Iuf4nPhY5Sw8e9y8SA1rZpAJt3kdyE9LFafM8gQ?=
 =?us-ascii?Q?yCWb/horUH7ot/KzokiSHiDibjVY/WIhCN7wb9hZcfnWUav5TWdEuYyVs//1?=
 =?us-ascii?Q?UOp4+KsdzaDRRzgZVEvGKQXZiRvIyknpQMo8RBfpoQLIf++5Z1tjaOnx7z1M?=
 =?us-ascii?Q?LrDQZNlH9zhXGnaLSmiMMIBhttDl2jBBBa1gcCTMrK/tgoDp3oUROv/Iqjk7?=
 =?us-ascii?Q?kG3IEQncmEEN4Mav3YOw6CwJgiKoxt8Jz1loKfg+i7I4648o155PRFYpfBam?=
 =?us-ascii?Q?J7AUNzjkuT41B0BSo91LE/Yj+6LOa3JiCyk+Hbt0iIDyP5DNi5nzHCYpDI+9?=
 =?us-ascii?Q?kcdsN/9psG/IkCiB6EO/rTjVpgsvjr27+Xy4abQRJu6XdS6YPXkttqEKVLIQ?=
 =?us-ascii?Q?yDd/Ag235i+4ByXLrjKJp1vGziTUuJcRHpuyaXj1BP0Z4mPCixNBfMkdcEth?=
 =?us-ascii?Q?3/NLg1lFIXqNEBDFxITcseeMgX1GrOGMgdnxX9qafUYQoUWiJNyRltjhFn7D?=
 =?us-ascii?Q?kikEZHrZP8exXiMzcL0QPT8IFj0CHVRugkSyN8K0ZhVjKXgykeO6Mg5TgbQA?=
 =?us-ascii?Q?KV3tMKmnk3APo5mEOz+zO8T1Di2nh+hbvo+AiRuJ4y4dKz9Y5Szq5jBDxzGd?=
 =?us-ascii?Q?B3A+1ENRvFjOsjXN+ml4dM7YBJ4qe86gXkBoWJi9FdxWZ4OwzUSwoj08e+le?=
 =?us-ascii?Q?BpXerIiBe+h+gn0WLh7k1WSQnq7mq9jkymgzBEMT27YDba4JZ/DshZMIBWCz?=
 =?us-ascii?Q?m6pq6qLUna9HaSRKyveQvT94S3HarttXbIxLVsjGUFaCbZ5YcZ0dX6hc92r0?=
 =?us-ascii?Q?kafznsgGZHCWPlTAii7K/0nUWSrMEHCvtwbwpTdmhDDgjlWiR4wzSMQdhPdx?=
 =?us-ascii?Q?+EjhKO908MRB5cb/5GOxGrwWvDCsy4L6qq1IwqMXRig1Xt1o4GHQCliy2RH/?=
 =?us-ascii?Q?Ubz4vWgKtESoI7P8d+3NKyMe51BI2pQ98ScVup10Ftn61Mj015B2VJuB69Cz?=
 =?us-ascii?Q?nL7UiXfysEFN/WwC2x//VVNd+5ttKHIvWQ1mv5BouCgKzPDBf7d2hYrUt2+q?=
 =?us-ascii?Q?jbvBaq6HayrPm/rQnSSZ9vhJPngHEShYcI66fbesuKPfIwhV5wGj0x4lSsJX?=
 =?us-ascii?Q?HM6RXl6FLEVtqqoj2rfHvDpl63BBAUtF5OPswO+ZQnYBrFnxAaEYKsSy6G6A?=
 =?us-ascii?Q?+2KMmLT6cZqgQeFzB/R1reVsH9/2augwM361l1Cwd0mNuY3rhePFeP4Uv1Y7?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f2999c42-df00-45bd-e12e-08dcc89d3913
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 02:41:17.3711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p21jbO8Z3w1ypiUG4WJTxrg1BWDQEk50pTRJXQEStcNpeiMriGOhlXeDcEng8Dt8ijfzqWtfVq0UjorBhvV/uxvkJcwCPkcZoxluzayxVNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6287
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
> PCIe 6.0 introduces the "Integrity & Data Encryption (IDE)" feature which
> adds a new capability with id=0x30.
> 
> Add the new id to the list of capabilities. Add new flags from pciutils.
> Add a module with a helper to control selective IDE capability.
> 
> TODO: get rid of lots of magic numbers. It is one annoying flexible
> capability to deal with.

This changelog needs a theory of operation to explain how it is used and
to give some chance of reviewing whether this is implementing more than
is required to get the job done.

> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/pci/Makefile          |   1 +
>  include/linux/pci-ide.h       |  18 ++
>  include/uapi/linux/pci_regs.h |  76 +++++++-
>  drivers/pci/ide.c             | 186 ++++++++++++++++++++
>  drivers/pci/Kconfig           |   4 +
>  5 files changed, 284 insertions(+), 1 deletion(-)
> 
[..]
> diff --git a/include/linux/pci-ide.h b/include/linux/pci-ide.h
> new file mode 100644
> index 000000000000..983a8daf1199
> --- /dev/null
> +++ b/include/linux/pci-ide.h
[..]
> diff --git a/drivers/pci/ide.c b/drivers/pci/ide.c
> new file mode 100644
> index 000000000000..dc0632e836e7
> --- /dev/null
> +++ b/drivers/pci/ide.c
> @@ -0,0 +1,186 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Integrity & Data Encryption (IDE)
> + *	PCIe r6.0, sec 6.33 DOE
> + */
> +
> +#define dev_fmt(fmt) "IDE: " fmt
> +
> +#include <linux/pci.h>
> +#include <linux/pci-ide.h>
> +#include <linux/bitfield.h>
> +#include <linux/module.h>
> +
> +#define DRIVER_VERSION	"0.1"
> +#define DRIVER_AUTHOR	"aik@amd.com"
> +#define DRIVER_DESC	"Integrity and Data Encryption driver"

This is not a driver. It is a helper library for the TSM core and maybe
native PCI IDE establishment in the future.

I am not what purpose AUTHOR, VERSION and DESC, serve as I do not see
how this can get away with being a module when the TSM core is built-in
to be initialized via pci_init_capabilities().

[..]

Difficult to review the implementation without a clear idea of the user,
and the exports are not necessary if the only consumer is the PCI core.

> +
> +static int __init ide_init(void)
> +{
> +	int ret = 0;
> +
> +	pr_info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
> +	return ret;
> +}
> +
> +static void __exit ide_cleanup(void)
> +{
> +}
> +
> +module_init(ide_init);
> +module_exit(ide_cleanup);
> +
> +MODULE_VERSION(DRIVER_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index b0b14468ba5d..8e908d684c77 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -137,6 +137,10 @@ config PCI_CMA
>  config PCI_DOE
>  	bool
>  
> +config PCI_IDE
> +	tristate
> +	default m

Setting aside the tristate, no new kernel code should unconditionally
enable itself by default.

