Return-Path: <kvm+bounces-28644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A980999AABD
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 19:57:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 157D1B21BA6
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 17:57:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A079A1C244B;
	Fri, 11 Oct 2024 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pjqr5ohd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F51C198857
	for <kvm@vger.kernel.org>; Fri, 11 Oct 2024 17:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728669428; cv=fail; b=u6pVz4O3iME7WOpUksIUq+Eh2xZN82KieFjcjEVE2nhA8zqxrdxeLpxDZsXFDLmRkPgL2AfTCFCVIp97GlP/bzb3PNPVB26DVjz/VOajU2io1Q61psDgf9orC5316eA/3DJHLQDd0SzdWY7rwm3dapfmrBdaZqMKhcxBstAQp/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728669428; c=relaxed/simple;
	bh=B8lfRbRl655srMVFW2ja5oCHrxcKGBK3wubhiR2ZsVA=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=M9c9vkYSUg+aJPjVzv08t5ym+UnHDv0F54JAqb+UVjP86BAB7ZDDlYVBMMoJolmu0hhERk7IiDHSS4f400oN2uhKAT2tpM0nQbCHFeth9dWJIu7Px6tNHUfLzY2v8+RP/l5Ne5ltVruwebYCnr1U1v5rZI30ooYFETLutM4ESy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pjqr5ohd; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728669427; x=1760205427;
  h=date:from:to:subject:message-id:references:in-reply-to:
   mime-version;
  bh=B8lfRbRl655srMVFW2ja5oCHrxcKGBK3wubhiR2ZsVA=;
  b=Pjqr5ohdeY3Zv6DboE034ULm83R/rmM8cfIDKUEsGuaIjF6E0UFemyp3
   oXX6y/IizR/79wvIUXMz4hKSPK6AYO9oZRDP+DEl5/xWLf16VNLBrgmFm
   C1bYF14Y6DW0W7MFwcUbuLLpdGutBTkH0SgkLOy4I7vtytgq3M9e7h29s
   GqHok9xu30HcS72G4yraXE1vA7W99T/vGXdElRn8DqBH9ubNRbdBqb5fG
   eZWG05biqB/o5VIo+JZT95LNn3Sq9gF5Zf43UGKZomg8Esi2T1Iw8IRdd
   41AjRjqEoL0pD4kNpmLwOESdDJwP4fUtP72DzenOZrMoOKw/D7JLXDinb
   Q==;
X-CSE-ConnectionGUID: nyZnQgp5SNOlCWe+y5p4nQ==
X-CSE-MsgGUID: h0QQxQb2Sbyh9WZXjaChMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28030571"
X-IronPort-AV: E=Sophos;i="6.11,196,1725346800"; 
   d="scan'208";a="28030571"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2024 10:57:07 -0700
X-CSE-ConnectionGUID: gtpUBc+sTlmrTIrNFOIarQ==
X-CSE-MsgGUID: 983qP+6mQiKKXbehhNZS1A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,196,1725346800"; 
   d="scan'208";a="81534043"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Oct 2024 10:57:05 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 11 Oct 2024 10:57:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 11 Oct 2024 10:57:04 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 11 Oct 2024 10:57:04 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 11 Oct 2024 10:57:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPKMC9NOrBUD79nQ2TpIT6hXscPUx3rBeKFs3nVJIRRh2AHU0P9pycSkhxRssFRJRC2BYY2kt0/MegwHTun/eE/4rUystpNyIrAyWRUGs3iDOjpppmBtSd6mEzmxxSMhSp5PxxF059uSPvJG/r2Ts5kXyifQ4r69gql8XoWITzCjkj9s2kZCRj9VkWThwvVBzLC2UAhB39DU+1du/RUgocMfwCwr1QY/mKh13nPsW1wxV43N1dg2yPK0ruerPNYHcIIRAWUilrV6LxDrFJKhEBnf7VxZYACOJPd/n60eoY7hhmI46f7nVcXwY8vC4cziS6N88mnirOz5GdjaUH4uAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EZkD3wytp9zLXeBHJNeMRcCYejDdz+YuSEQFm2OyPHk=;
 b=BTNmsMiWNtVKXnltB4+zK6B+pDjFoYADCY7TXGBfhIvD5wmb8f14Zj9ptuCBV8en3pPAKHHcPAkjHU8czrpa1OGzqJgxiV4pfR/EKMH126kycJwB0ZSE+Xyi+qs61rMZblbcypliBjPaqvfTDYGmGsKFQVznC53xGQ+vZhQXpoQ7RKM5J21OZZashvAy7CUlizRSHJg4RVFEBcWGljI/aIUuxXKiGdbCDP5oJMVCnEsdpey5UCTeIO0WbjXQKpfRmaI0OEGMAekRRk3rJJfiBqM+s0uPXLIOsLvLDlH/sCOc2G8zNJ31AZ2f5PEoN/DFZ3igIrActw+rzCujFCfNbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB6446.namprd11.prod.outlook.com (2603:10b6:8:c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Fri, 11 Oct
 2024 17:57:02 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 17:57:02 +0000
Date: Fri, 11 Oct 2024 10:57:00 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: David Hildenbrand <david@redhat.com>, <linux-coco@lists.linux.dev>, KVM
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Proposal: bi-weekly guest_memfd upstream call
Message-ID: <670966ec5db4e_964f2294f2@dwillia2-xfh.jf.intel.com.notmuch>
References: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4b49248b-1cf1-44dc-9b50-ee551e1671ac@redhat.com>
X-ClientProxiedBy: MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::10) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB6446:EE_
X-MS-Office365-Filtering-Correlation-Id: 33bdea9d-6f5c-446a-80c3-08dcea1e1c5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|3613699012;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?UOCX7yRRDTQaxwzCdVn9hQlbbrYgEN0Sbpcmw0UquKgXsa/UIiXLQS7C+rhP?=
 =?us-ascii?Q?A+hBpzYr4Mq0gdl7sj4pOFZzlU/cZmwL30osE6kKzvlbB9jIJNdvVey7vrWu?=
 =?us-ascii?Q?1yZrc5Uk35WgMDu8oytmmksO5FHqKXzx9KMCRYC193mA6ISKwUcKAPRJjUfJ?=
 =?us-ascii?Q?IPSAHoXDKA+CQoeliuVfMkaaEX7TBVeEKOQaJJ3NIS18UztuPSqTk20NWhzM?=
 =?us-ascii?Q?TWbY9lqPOXeSw8RWiMTfMLlxEYLJaPGZ98shbHuqwaudcJk+ZCLBqIcuIczB?=
 =?us-ascii?Q?QhXZuBOtgI+U+Y4LUqiYFe1xJmbMJX4tiJX+81rNTLYsYYqbdroz6ij4PDh3?=
 =?us-ascii?Q?X7xtJzImsafOIKN1F1OJktLBWpyZCwmq2ZksAcgps5snmpO08izMLip5Nxiu?=
 =?us-ascii?Q?6rDOcOMo+cTLIxqzPhRZgjEBmDzat8W2iw38pGOqqhhAjFi8nKAdydZ84v98?=
 =?us-ascii?Q?vdaYNT8Opd6nhak6oSw1uKFxeo1nGUGsQTN9mQc80E9BRcZxhavfFNVhyHu/?=
 =?us-ascii?Q?nkn8cTJK9oaXgri7Z+6pRX3fwha42yBrUGwvR1vEcqw41TenodT0gCDFytiA?=
 =?us-ascii?Q?jWiad8kQazlunfcrqstbSZ541nCO6HDHLZy8I40K87A5pq2lh4+SOiyXBFAU?=
 =?us-ascii?Q?pucBr5XIeIRlk5gcQKDrTomHb9k7MDV/4D7NPHO9lyApjwD68yexkZZsOso2?=
 =?us-ascii?Q?37CJVtjheUFvefPpJFlqecGeWJK5cOlh8S4ktzG1YZqpza+hnV1nt1QuKbET?=
 =?us-ascii?Q?cTPhuWsst16ch8v+HvXEfKksCaBLe1Ee3nxq6OEPi0dpnoeYyYXSVoXovK1A?=
 =?us-ascii?Q?pDlauBmlsiOD9Bzcm0CKi7TQS3XmhVmYtkuZj+5yGQmEjniZf1O6Qto10ri1?=
 =?us-ascii?Q?5D08pz1lRjwdJG/GuOxNIplEKP6g6o91nycXHVk732YZPXPfDBu4ibyfDJKi?=
 =?us-ascii?Q?rjNIYi/1Cne6i1Kc9+gg2Iy0qSYDS2uZb4brdWyji+ymaNkgFcF7xTGVWqlg?=
 =?us-ascii?Q?uFmkTdcgTCRXtD9iE1wFP7Q26tYpnBC+Z7NCQML04xxVOKEtjSr7eyotSiSk?=
 =?us-ascii?Q?zB/ytG1KNFkS4UtPBZoNlwjJLybHmXRA44cBA1nzRG0TQIONcT7bsibpPZ1J?=
 =?us-ascii?Q?cp9RbDDV3aL/PG7cAQHJ2kmS8fjfLTUHmFV6nSZcj8ztHV++3/qosAKWlYtZ?=
 =?us-ascii?Q?PIbzULbz5hgCoihlDTQr6Jooj5M6TFfrGteJNQGdpvlwdfWV9p4J+uNCsfl3?=
 =?us-ascii?Q?wOm0aJKydaj90CowcKihFQtxQIQ6sG3z8GPv4v2X4HvUHtG44VPV6LuktnKE?=
 =?us-ascii?Q?sEAmBxB813Y8OhfBGdKCqcsP/PWaEQ6gcHFExqtEFKxIXw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(3613699012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nWQi6C6yL1IK2E5l90LmTKhC83+t63UVEQYEjfhvTm05/LsAk9W18ZLrYYQY?=
 =?us-ascii?Q?cJMWZQq/cb0x64YHy8rfU2BCw6i/kInf64AcKSzgKNnOaqzJrE+jVZLlLMhl?=
 =?us-ascii?Q?UPM1P2wi/Np6+riEnc+YTnCkkoHqPnl2br5ohxBQ3ijaykRddD1chfLhhW/n?=
 =?us-ascii?Q?8sHQfoSd1AfLTOPsYANnuF4jnYG8IGgGl9zHRVaWJUP7GxudULmNKfzkDuAU?=
 =?us-ascii?Q?AQHEUbrxIqLW/iDbEGIHr0MkFGzO2UG94d1QVj5Q/ZQ2scWSK1cCvS0PxyAC?=
 =?us-ascii?Q?hURKtFz/4B1QdZwUH+ho9B5B8KbeqJxnfajdIvpIQ2VkiHY/JyWM80TrTydh?=
 =?us-ascii?Q?kI1pL7S0NFm7PuaviFjKL7TZ0IMyBHgpfNyc5MDuN+NltW07z2rSFKmG/Ks/?=
 =?us-ascii?Q?K/wJAbyDW7q+wswWjwWSLgES8RwFRVZXdW8EP8IGksuydU7MkfFGtlKVr5Gr?=
 =?us-ascii?Q?2LQ8hcA/y35wWzREE6fJ1z2GiDueSRA2SecalW5U3suXPmHNjvX3eMDoJx47?=
 =?us-ascii?Q?YVT9pshHObtpAnRYlxVWpE05VW3asXqIl7AGW03QgH3ACe4/KqQ1EPWA6NtZ?=
 =?us-ascii?Q?+jRhkDRDYR2rBm7yE9qZ3MupLRtEnlJKRIuMaZon1N9zBCQ2RUYmTUYD7eXj?=
 =?us-ascii?Q?5wCb7jdC6udglH6h9RxbzCLlSpetjMrPCqtxy4oqKjiNYg83etDq6EsR8sFy?=
 =?us-ascii?Q?IiHTaENhUW2f566i6zcABrIxr+1HuMf2TTCnBuh1R8LS352gmhByvJpBH8XP?=
 =?us-ascii?Q?m3LpAdveNLePXODjwDGdrM+gp/3iLFArrThnrp5d2Njlovn1xHFx5+vG7nWk?=
 =?us-ascii?Q?ctl+c/PXeTiDwyvTa9Y7Dj91q8Bim9L6Zk1KeR/AvQnOar256BiA0dZwlNR7?=
 =?us-ascii?Q?U5/NQaekiL+Bm/5DwOnyIu2vlasHCeupw03FGeF3icBo6hJL/sovYqjBM6xT?=
 =?us-ascii?Q?jeRV2wka2Ahb+dqD/4bVlTgSTO60K2emXsnwc1vDYcWOIFNsQMFWSG9pqzDw?=
 =?us-ascii?Q?YzfgMeGlp/QX06dOi+sMrDHttRI+YFy4VEgpQFFi0UO3Nqjo432IV1hpDYLb?=
 =?us-ascii?Q?fJophKbIrc02ky/rWPfsoxRWn2SvvHXPEqE4JGT8hoAYxeiBWJD9A0G1CmbE?=
 =?us-ascii?Q?4eiGSHWIyPPYLQUVaE6V69jpusR0D61yZZMmKSqphzPl99kcggfpBOpOz2lS?=
 =?us-ascii?Q?EUUROtpTD7G76ot/iLlT15ICHlMWoUbcMv0lheWxCfUEhfVPfoLr3BZ48zBT?=
 =?us-ascii?Q?opAp8eVP7vMaLX+NTzP1wlCwmtFK2eOgtblqaUO4efNhuVcMJFnvRjd6D/cn?=
 =?us-ascii?Q?v+JBC9rIwaBq9L6Gw+r3oL8Kp/10B8L9p5vc+mcnkRn9y+NPOwb9sYfEYnPo?=
 =?us-ascii?Q?m2Fyh1339a/YHUEP6ZyaOShrCZN7hHNRebhrMo/Mdp/kpNFdZ0EprexIkOm4?=
 =?us-ascii?Q?5EkOQjQG3ujKx2IjWmk0EGTRlAZrSzylu1OKSza8SNexGUV0RM4UbFF0FjOa?=
 =?us-ascii?Q?JzvXHeetB1qyJmUitrxiPgyogrYc7ubZc+xoBh10Xdo8KQFKIQo5FaXcVwc0?=
 =?us-ascii?Q?HuVS+x0Od4gps5uFUYatwB6uVZCPFrDXMZaxOMb/fnf6j4mIKMKlIVDHhc7C?=
 =?us-ascii?Q?fg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 33bdea9d-6f5c-446a-80c3-08dcea1e1c5a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 17:57:02.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bu4vYjjnVUdeRJF2D8DghkrVw9dfyASiqVUajQzbb7nxUtkHTd/WVx4zgt/6PXH6lrQFadjE+NcpzKy1db3en1r4/BJHRaEkMUa3ZYf1924=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6446
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> Ahoihoi,
> 
> while talking to a bunch of folks at LPC about guest_memfd, it was 
> raised that there isn't really a place for people to discuss the 
> development of guest_memfd on a regular basis.
> 
> There is a KVM upstream call, but guest_memfd is on its way of not being 
> guest_memfd specific ("library") and there is the bi-weekly MM alignment 
> call, but we're not going to hijack that meeting completely + a lot of 
> guest_memfd stuff doesn't need all the MM experts ;)
> 
> So my proposal would be to have a bi-weekly meeting, to discuss ongoing 
> development of guest_memfd, in particular:
> 
> (1) Organize development: (do we need 3 different implementation
>      of mmap() support ? ;) )
> (2) Discuss current progress and challenges
> (3) Cover future ideas and directions
> (4) Whatever else makes sense
> 
> Topic-wise it's relatively clear: guest_memfd extensions were one of the 
> hot topics at LPC ;)
> 
> I would suggest every second Thursdays from 9:00 - 10:00am PDT (GMT-7), 
> starting Thursday next week (2024-10-17).
> 
> We would be using Google Meet.
> 
> 
> Thoughts?

Sounds like a great idea to me, thanks for setting this up!

