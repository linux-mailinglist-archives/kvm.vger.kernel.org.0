Return-Path: <kvm+bounces-17161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 32AE08C2227
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 12:32:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46CBD1C20EEB
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 10:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634B214F9E6;
	Fri, 10 May 2024 10:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RdsK5uTq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2928F45018;
	Fri, 10 May 2024 10:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715337128; cv=fail; b=KJe9fWfJ8sHxfuk7D1f3SFZgDELyalKTUDAYdH4F6AePmOMnHXaW1Viq1R07tID60i9Fl6S90Fv+mslxuLgV0Nho4UDRRhMzxFodLgqQuYSrDkAouLTsYsxlTUYp/2pu8qCP5iEM+lbZSZ7YMdT+oioJG5j2MVF0eKVG1y3C3pA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715337128; c=relaxed/simple;
	bh=KftEhOmMZr5yaWArLweLuKqtfFzWyJHWwh5sFjWNNAE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VwIAtsoqFzcrnt9RhIDzAKUOTHTioET+51RXv0ov31IbmrxQVPWq3/enM6p3k/kEf3EF1jj3pYfwX5Z9LOiNEW2N8uFf9IYwV55SJuRew5uzcU8KgLTEdxqATNMzxPGohKEXRwtiwOUKi+vS0k59h2YyuqlDS9TdXUltfioBCek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RdsK5uTq; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715337126; x=1746873126;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=KftEhOmMZr5yaWArLweLuKqtfFzWyJHWwh5sFjWNNAE=;
  b=RdsK5uTq+RsnaK8Co+zrHZxH3NTSLAV33qtnm8egYGZqtLHYNe5V6kVI
   Ztd/Ss0KzarLYOjvS2nMVgtIpp6KLHco5L8+5W+BUHuVCYR+whdzovLO9
   MeVSsKjg9dWEtnv8e3sSRpELoYuF3S45HFLI4s15s98wsfhBOF2DACOH9
   JNfln9xTxFCq1i99kpLatQjvDIsQLekZvrZafaeAHixSpnGhQ86x4KsVf
   uPa1GHCD/BarXmn8MDAbB+dQlCVSdViEGv2xFWf7CvkqisreBnlEn1cY2
   7YtFqtOnnIvnXObvuBAIHHKtdooET2v+3FE2zKVkthdpZtwKTlSOFNlWr
   g==;
X-CSE-ConnectionGUID: YOXGYmNKSQKdR+/stewWLg==
X-CSE-MsgGUID: GsYFRai/R0Cq8YJVsZJY9A==
X-IronPort-AV: E=McAfee;i="6600,9927,11068"; a="11474900"
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="11474900"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 03:32:05 -0700
X-CSE-ConnectionGUID: TcbsnkmOT0Ggm+AB91HhcQ==
X-CSE-MsgGUID: PATIvaONTdKj55EgD1gR8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,150,1712646000"; 
   d="scan'208";a="29430242"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 May 2024 03:32:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 03:32:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 03:32:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 10 May 2024 03:32:04 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 03:32:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4RrqK2ZnMJ7Jj7BNJ/Usav1hZQLKM/Leie2AZUbDqlMZaQ4C7mlquMaqMSUffsM0r6J+bZZYkXEX2uJwYfl3ZshVXQxLsZNv6OtL1XeFOjRr042ZibSsEl5Dmdzld/2X2OXUAGj2i5IqTVgyumypB2Xzq5rD7tSE8KcIrJm1NGYVx4ld5XOzWLFL0LwWw0JJeYPNaXw9qBG1BFkI+JLrbWrDYVoh+m0BnLhMIzGXV8iELc4m/4XNWs9OcPegIN/tpmcjcDMR3ZXfvEIIEFzp/4A+sy3Ee63/Khw/10FqfwXspZ2KZV4d9fmDEwpRU6T1wRNEpXzWzW3UsLIKG/qkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1q+tX3uGdMjPlxabZyW4i06EUFfv90+l8sz1DDUNx0=;
 b=T3tDvzJgvLiUpeaLRjfwlXvIFqurmCdq+gubyyr74isMUuT7DmzlA/dCa21QPcCaYCA0Zi22olDuxHc9Z6JTkQvwpQSxbDXFm4cAWPryJ6zYBfEsB3Iza52AF0Y9JfnXfUjx7z61pmScPDn+lSayyBJWuManKQA6hZnfy7ZZu9qmIAqiRwBbp1+U0XcBa5UgQQJu2HuGtcE4dJGF+w7V9LMvOPCmKDOGgX3y5I1uRRYs+G3TO7hxCDlDcZ3S0lne9vkTRyACBwv66IQ7i3uTTwqF7Z3A2odjpKA01IiAoNNsStH5ajXieAVdFqOccV8jsjS6GB27KcdyPoCZv7BH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.46; Fri, 10 May 2024 10:32:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.047; Fri, 10 May 2024
 10:32:01 +0000
Date: Fri, 10 May 2024 18:31:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<jgg@nvidia.com>, <kevin.tian@intel.com>, <iommu@lists.linux.dev>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <dave.hansen@linux.intel.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>, <corbet@lwn.net>,
	<joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>,
	<baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <Zj33cUe7HYOIfj5N@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062138.20465-1-yan.y.zhao@intel.com>
 <20240509121049.58238a6f.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240509121049.58238a6f.alex.williamson@redhat.com>
X-ClientProxiedBy: KL1PR01CA0113.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::29) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB6504:EE_
X-MS-Office365-Filtering-Correlation-Id: bc42468b-1802-4ade-e6b5-08dc70dc6d9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cIVsB3tD1MYYjlUDsHgXB9eNLpJa4P20owD7+TzDlyYvAk7EdlD1wlkpo1C0?=
 =?us-ascii?Q?pvoZqsaluxPO6x9n5SjTeU2yBt7UZV1o37k6n6W64XaXmOOLRWOAnM0EV0LT?=
 =?us-ascii?Q?Y50iMa1qG1PSzGhZK6lyHJtfpQbTRCcsBrcAr+PvyunUo3SIKCuFrZGQ9yDq?=
 =?us-ascii?Q?Z9DbHOfgtrw5+tGc1WRG3pDAVXGmvkHOzSUTQtkYdJS4z2xGks/+7PgEwxXC?=
 =?us-ascii?Q?jJzk4GiJCOCGmqNxg/aGMa3/Ed5TV0C+saiqjwsa7bh/9UsmHal79/zqspOF?=
 =?us-ascii?Q?3HrwgSyBiQxB422mdiTFYYConYgs4/s/JF6mbQZgqUwckBii8D3SQMRAEyID?=
 =?us-ascii?Q?YGUT2DwwufM6H22DZ1Yl6Gi1fSkuBUZwW4YXsOo9+j7iIi1LRJAEPQDQz7jp?=
 =?us-ascii?Q?Cpw/CRoXg+Jga2r5mKms3uEweHLHdihRzPr7SvOPKl1NoHOTmdCMrBHpdfw7?=
 =?us-ascii?Q?anolOIGu2eNzcFw+bygG+L+1tZgjcTvTOIFvtwmE3CDN864dsPiwmXQZ4DTC?=
 =?us-ascii?Q?qV8kfR7u6wtf1/lI1merzpEBUrID83qGn5nLMwWiSd1Rmyz6GjASUSuzz9tw?=
 =?us-ascii?Q?aoFRa69yR1chxXbMZMyHpaxD8eXV6x5LhcAxdmn9iaW/DRXo34JDPBf8fRfs?=
 =?us-ascii?Q?TVKMuCh9NU9oAWg6+cXUKnFwLEaqerUklrY8IBGcDdt9jIAfBgs5giBNDw3p?=
 =?us-ascii?Q?QrFuiFb8rjSKYYcZTg47eHHPa0TqyAb6MwLqjipSwT2AHToHCgVHszab01aK?=
 =?us-ascii?Q?1xkxbikrpinqf+Tg9fqnBeC9uaK58gVFA+YWmVQC5knYAf7DcAUNvGF21AoT?=
 =?us-ascii?Q?sL09FJ8RjmkjajBc2miwN50Bqd1e3WkK1JHDm8+fiIrPftor8DwP337lmfKk?=
 =?us-ascii?Q?Axl7+vnRryV3Tdu8ddQssn1xXfuxFRi+/7cxGavScoYEZCUOlmp1CoXACT/v?=
 =?us-ascii?Q?m1h8hTVa4YR3Q7Xex4z1ldlyCRJnKXDx3S7AS6qEy/dNHt8FTHeg6pebL/fE?=
 =?us-ascii?Q?76LcwbIjumtlzsyvWJGJ0oNp1LleQAin2QNYRErB+LWzhRKsPwoqBBK5Zjyf?=
 =?us-ascii?Q?htvC5QcyT+cG5Dq1CZjoth83XiufUYWd38dXny3a87S1mCflHE2QaAx16zra?=
 =?us-ascii?Q?A0pYy6yWAebtG6KluLUK2pLv40BfzsawYdKstanoYxdNONFQwcU+bmMa5veE?=
 =?us-ascii?Q?1q6raDi/Qmvm1QfvaBFKuB9zXonjjcDqLxCsJ0B0FtRAuh/0KSGXSQYQLQI2?=
 =?us-ascii?Q?ZyyMzT2IMpVxkJfX6KJhZ9Bem8ISIXFa0BY8V5poDA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zZQaq5EzJY7MPkcte/zXTbFBRBCdtL+b6mIcwlW7+mwdbzt/nHeIfbrjohHo?=
 =?us-ascii?Q?B1GlMI1HBAezVvLyp8BxJJgtauEJEUtGwwcsQuMtPo6XT5UOzCIwGKW2xkAw?=
 =?us-ascii?Q?O1+VH8ODu7okxGqF4wC2DiHQJ/r6+vs4wQoLEfDUqtZpwSDrtYwY86Y0XJ69?=
 =?us-ascii?Q?NWhcC+9TKk3IYfQ7NSHZ8b5rdhiCNG8tJHh54DfMsgRb45mGYADRDhPK2lN3?=
 =?us-ascii?Q?luSeHm6mjU37FSMHDpx21R7fbub9TDvRQaXy4HPCWUNNx5CfkmBoBUYZ1Z28?=
 =?us-ascii?Q?7x9QpldOdD/6DI6Nopqmcv3OffzB7mjVtiCxgs2lBhCCGlfJHD53AWVw0kBY?=
 =?us-ascii?Q?j1C3pK8PlaDTK3qr/Wf9b/1pj4qpRYBE1NMh3oBcJYowKVzbOZgnob+drkS2?=
 =?us-ascii?Q?wLCR7iUMKUMvutuwGn0vsJEjeqsOkjpBO7d//ZbIuq/MuJmvj4qwUZ8VUG+u?=
 =?us-ascii?Q?MgGdaxRzo3sq/BqcbChoDT4DxCqwpIy/Y2HJBiGjo+bUKkPW6IBVC1SwDx/Z?=
 =?us-ascii?Q?LJJxg3TMJLNqhJB1yDRu2pUSVxT8xPdd8cYUDI1llKyh784P7vroZsngMFWN?=
 =?us-ascii?Q?gtVmi8G604qNKlgF7izUhj6kZMBkU3Dd0Ja6jGHtiJCWdWeDHLHjrGXAFrnu?=
 =?us-ascii?Q?F2dWUNkxC4MJ9Dn1STGhxydmcT60B7tWQl2sz18Stcs8O3f+jozyj/qtnJN0?=
 =?us-ascii?Q?xOtoWAaJKbiSV9MsVkzOHNH7U0KIsobJCE9h2pezWuRrM1sakup5YwtKuHPy?=
 =?us-ascii?Q?+IN3nyfATCxltrGwpAP7+7/UQp6VPxCL5Nelb87lfAj9/l7SYjggZf4LOA74?=
 =?us-ascii?Q?mBbtrlWMntY7WlznrokfcH/9AmSQA8jYZtd8ChbWJdBZrhYmkGWZCYj/PSbL?=
 =?us-ascii?Q?1MLVvSw/wjX/CKTf2S1KR8ud0Cw9SONjarChdxbgfr/W1bJzrwUDqXiEGeOW?=
 =?us-ascii?Q?Yhhnpvwp6WpJ8Y7Fty081cjU/GHHm0X3SLh+LuWPWu+OVB7OvdEh6wGWAGSH?=
 =?us-ascii?Q?snSO9wB7cnTQGMrAdQxQgVK4HcaEylqg15O+AG1ajEVeJ85Ysk5P0aE2xG6q?=
 =?us-ascii?Q?bto8s/vuQRBMToY9KdC6S7yMjOJ3CLx462I7sTep+A7YBzG542mZZLk79EzP?=
 =?us-ascii?Q?E1FYlSHOrl29TPsqoOm7iLwVuY/cZU/kGL9ygOOABU+VhSL7mcYzgyoKwpN4?=
 =?us-ascii?Q?4vNvAPTh547RlWHB7diEOCSfyLFnI5cVnjHs2YTaDzkmaxw1tBZUgj/dBHYV?=
 =?us-ascii?Q?oz/gjufTKTgIgjopKZ1YZSDHZ612/U7wbHRC6t+F3vQvX1xSYhSXExkwRISM?=
 =?us-ascii?Q?lwDvH9yuJvlrn6VE7LzUJlERHR2BJmVAjK+xpCnt098utk/yCNDoibk25vMM?=
 =?us-ascii?Q?vGtsI/Ous/lbB4W1pOYNhvCJVN5647m+bdfa2KvzXunWWsJC6ZAQEfPDTEE9?=
 =?us-ascii?Q?SjHynWON0Ko3fjIJEFt/aS8DUt67VJznKVcelIeLol+ALlATkOfyqCTvhzBk?=
 =?us-ascii?Q?Qfcmnr0rJvIIKZlAl1/RruVMiQ0YQCRpDG4tcea/dJ1Fk7PmUggJgGUp9izE?=
 =?us-ascii?Q?Or2voFYFtYdZMH3XpnJlOtRT/qNY5uKVOCSGyPbO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc42468b-1802-4ade-e6b5-08dc70dc6d9d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 10:32:01.5480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3Dd5aLHqPgvm87GxC+TuW8h3sONMuP7O4c7FYHR6CXziEg0ON6hHBQDadklYBbGu54hzBlOe2vtwJUSwP+qHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
X-OriginatorOrg: intel.com

On Thu, May 09, 2024 at 12:10:49PM -0600, Alex Williamson wrote:
> On Tue,  7 May 2024 14:21:38 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
... 
> >  drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++++++
> >  1 file changed, 51 insertions(+)
> > 
> > diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> > index b5c15fe8f9fc..ce873f4220bf 100644
> > --- a/drivers/vfio/vfio_iommu_type1.c
> > +++ b/drivers/vfio/vfio_iommu_type1.c
> > @@ -74,6 +74,7 @@ struct vfio_iommu {
> >  	bool			v2;
> >  	bool			nesting;
> >  	bool			dirty_page_tracking;
> > +	bool			has_noncoherent_domain;
> >  	struct list_head	emulated_iommu_groups;
> >  };
> >  
> > @@ -99,6 +100,7 @@ struct vfio_dma {
> >  	unsigned long		*bitmap;
> >  	struct mm_struct	*mm;
> >  	size_t			locked_vm;
> > +	bool			cache_flush_required; /* For noncoherent domain */
> 
> Poor packing, minimally this should be grouped with the other bools in
> the structure, longer term they should likely all be converted to
> bit fields.
Yes. Will do!

> 
> >  };
> >  
> >  struct vfio_batch {
> > @@ -716,6 +718,9 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
> >  	long unlocked = 0, locked = 0;
> >  	long i;
> >  
> > +	if (dma->cache_flush_required)
> > +		arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT, npage << PAGE_SHIFT);
> > +
> >  	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
> >  		if (put_pfn(pfn++, dma->prot)) {
> >  			unlocked++;
> > @@ -1099,6 +1104,8 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  					    &iotlb_gather);
> >  	}
> >  
> > +	dma->cache_flush_required = false;
> > +
> >  	if (do_accounting) {
> >  		vfio_lock_acct(dma, -unlocked, true);
> >  		return 0;
> > @@ -1120,6 +1127,21 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
> >  	iommu->dma_avail++;
> >  }
> >  
> > +static void vfio_update_noncoherent_domain_state(struct vfio_iommu *iommu)
> > +{
> > +	struct vfio_domain *domain;
> > +	bool has_noncoherent = false;
> > +
> > +	list_for_each_entry(domain, &iommu->domain_list, next) {
> > +		if (domain->enforce_cache_coherency)
> > +			continue;
> > +
> > +		has_noncoherent = true;
> > +		break;
> > +	}
> > +	iommu->has_noncoherent_domain = has_noncoherent;
> > +}
> 
> This should be merged with vfio_domains_have_enforce_cache_coherency()
> and the VFIO_DMA_CC_IOMMU extension (if we keep it, see below).
Will convert it to a counter and do the merge.
Thanks for pointing it out!

> 
> > +
> >  static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
> >  {
> >  	struct vfio_domain *domain;
> > @@ -1455,6 +1477,12 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  
> >  	vfio_batch_init(&batch);
> >  
> > +	/*
> > +	 * Record necessity to flush CPU cache to make sure CPU cache is flushed
> > +	 * for both pin & map and unmap & unpin (for unwind) paths.
> > +	 */
> > +	dma->cache_flush_required = iommu->has_noncoherent_domain;
> > +
> >  	while (size) {
> >  		/* Pin a contiguous chunk of memory */
> >  		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
> > @@ -1466,6 +1494,10 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
> >  			break;
> >  		}
> >  
> > +		if (dma->cache_flush_required)
> > +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> > +						npage << PAGE_SHIFT);
> > +
> >  		/* Map it! */
> >  		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
> >  				     dma->prot);
> > @@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> >  	for (; n; n = rb_next(n)) {
> >  		struct vfio_dma *dma;
> >  		dma_addr_t iova;
> > +		bool cache_flush_required;
> >  
> >  		dma = rb_entry(n, struct vfio_dma, node);
> >  		iova = dma->iova;
> > +		cache_flush_required = !domain->enforce_cache_coherency &&
> > +				       !dma->cache_flush_required;
> > +		if (cache_flush_required)
> > +			dma->cache_flush_required = true;
> 
> The variable name here isn't accurate and the logic is confusing.  If
> the domain does not enforce coherency and the mapping is not tagged as
> requiring a cache flush, then we need to mark the mapping as requiring
> a cache flush.  So the variable state is something more akin to
> set_cache_flush_required.  But all we're saving with this is a
> redundant set if the mapping is already tagged as requiring a cache
> flush, so it could really be simplified to:
> 
> 		dma->cache_flush_required = !domain->enforce_cache_coherency;
Sorry about the confusion.

If dma->cache_flush_required is set to true by a domain not enforcing cache
coherency, we hope it will not be reset to false by a later attaching to domain 
enforcing cache coherency due to the lazily flushing design.

> It might add more clarity to just name the mapping flag
> dma->mapped_noncoherent.

The dma->cache_flush_required is to mark whether pages in a vfio_dma requires
cache flush in the subsequence mapping into the first non-coherent domain
and page unpinning.
So, mapped_noncoherent may not be accurate.
Do you think it's better to put a comment for explanation? 

struct vfio_dma {
        ...    
        bool                    iommu_mapped;
        bool                    lock_cap;       /* capable(CAP_IPC_LOCK) */
        bool                    vaddr_invalid;
        /*
         *  Mark whether it is required to flush CPU caches when mapping pages
         *  of the vfio_dma to the first non-coherent domain and when unpinning
         *  pages of the vfio_dma
         */
        bool                    cache_flush_required;
        ...    
};
> 
> >  
> >  		while (iova < dma->iova + dma->size) {
> >  			phys_addr_t phys;
> > @@ -1737,6 +1774,9 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> >  				size = npage << PAGE_SHIFT;
> >  			}
> >  
> > +			if (cache_flush_required)
> > +				arch_clean_nonsnoop_dma(phys, size);
> > +
> 
> I agree with others as well that this arch callback should be named
> something relative to the cache-flush/write-back operation that it
> actually performs instead of the overall reason for us requiring it.
>
Ok. If there are no objections, I'll rename it to arch_flush_cache_phys() as
suggested by Kevin.

> >  			ret = iommu_map(domain->domain, iova, phys, size,
> >  					dma->prot | IOMMU_CACHE,
> >  					GFP_KERNEL_ACCOUNT);
> > @@ -1801,6 +1841,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
> >  			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
> >  						size >> PAGE_SHIFT, true);
> >  		}
> > +		dma->cache_flush_required = false;
> >  	}
> >  
> >  	vfio_batch_fini(&batch);
> > @@ -1828,6 +1869,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
> >  	if (!pages)
> >  		return;
> >  
> > +	if (!domain->enforce_cache_coherency)
> > +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> > +
> >  	list_for_each_entry(region, regions, list) {
> >  		start = ALIGN(region->start, PAGE_SIZE * 2);
> >  		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
> > @@ -1847,6 +1891,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
> >  		break;
> >  	}
> >  
> > +	if (!domain->enforce_cache_coherency)
> > +		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
> > +
> 
> Seems like this use case isn't subject to the unmap aspect since these
> are kernel allocated and freed pages rather than userspace pages.
> There's not an "ongoing use of the page" concern.
> 
> The window of opportunity for a device to discover and exploit the
> mapping side issue appears almost impossibly small.
>
The concern is for a malicious device attempting DMAs automatically.
Do you think this concern is valid?
As there're only extra flushes for 4 pages, what about keeping it for safety?

> >  	__free_pages(pages, order);
> >  }
> >  
> > @@ -2308,6 +2355,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
> >  
> >  	list_add(&domain->next, &iommu->domain_list);
> >  	vfio_update_pgsize_bitmap(iommu);
> > +	if (!domain->enforce_cache_coherency)
> > +		vfio_update_noncoherent_domain_state(iommu);
> 
> Why isn't this simply:
> 
> 	if (!domain->enforce_cache_coherency)
> 		iommu->has_noncoherent_domain = true;
Yes, it's simpler during attach.

> Or maybe:
> 
> 	if (!domain->enforce_cache_coherency)
> 		iommu->noncoherent_domains++;
Yes, this counter is better.
I previously thought a bool can save some space.

> >  done:
> >  	/* Delete the old one and insert new iova list */
> >  	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
> > @@ -2508,6 +2557,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
> >  			}
> >  			iommu_domain_free(domain->domain);
> >  			list_del(&domain->next);
> > +			if (!domain->enforce_cache_coherency)
> > +				vfio_update_noncoherent_domain_state(iommu);
> 
> If we were to just track the number of noncoherent domains, this could
> simply be iommu->noncoherent_domains-- and VFIO_DMA_CC_DMA could be:
> 
> 	return iommu->noncoherent_domains ? 1 : 0;
> 
> Maybe there should be wrappers for list_add() and list_del() relative
> to the iommu domain list to make it just be a counter.  Thanks,

Do you think we can skip the "iommu->noncoherent_domains--" in
vfio_iommu_type1_release() when iommu is about to be freed.

Asking that is also because it's hard for me to find a good name for the wrapper
around list_del().  :)

It follows vfio_release_domain() in vfio_iommu_type1_release(), but not in
vfio_iommu_type1_detach_group().

> 
> 
> >  			kfree(domain);
> >  			vfio_iommu_aper_expand(iommu, &iova_copy);
> >  			vfio_update_pgsize_bitmap(iommu);
> 

