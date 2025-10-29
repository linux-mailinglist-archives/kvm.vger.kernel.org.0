Return-Path: <kvm+bounces-61379-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17AD2C18664
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 07:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 60D8B1A65843
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 06:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A71B32FE06B;
	Wed, 29 Oct 2025 06:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QKNwfAfv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355551F4606
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 06:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761718430; cv=fail; b=JeMMZXhbuH78IniLeocW1fd9itk0CGEPYOkzDU4gixYs4q6bCnx14VaT9mIzszRGLLb6JxOvRaa75AyL9gY9YovnxMe5yyWuVvazWHdaSzGN+CWRlMpmKQwsePeY5kx1g6LB9jZUIg/0E13w8YDTJr6Si0/63CQx4W9xJqARL9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761718430; c=relaxed/simple;
	bh=mSM4Y5Fq0jHGySuo/YaSn4uTdFLQIfHl5lMA96v2WuM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=giYEgzpOQwHbp1gv+GrncsbEnYhP1buH16lPqsA+WMmDOuTlo+3iyQufgGpUHgLnfPsbzHUKDcY2O0Hg8EKQ1nu+sVh7tKGYsIa4baqhcsgi63MfUeKDYq8VM3339/tLfykAYIWYUqtJnPq0dXjWYIPmIdowvKE4UKM8l4JfiMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QKNwfAfv; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761718429; x=1793254429;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=mSM4Y5Fq0jHGySuo/YaSn4uTdFLQIfHl5lMA96v2WuM=;
  b=QKNwfAfvo44fDG6O3X40mgXDFSkIl50BFl+P8L0p0/EgVDjRUtupqdWb
   9p8tjionuSViKN8fArQ+JZRcA0x/2PWFLGvHvVnc7o0fVfyFMqCchkAzG
   uBFU+ZuPUeqHN2y6pQjTLYqkp2y/Uqsn4coIBX/GDP2nVAJJ4kTBsJkGL
   tgCPOqtfiFdfxUAQlNpOWSHCp2ywpKO53Vy5KMNx6NusCGsn0OIWa2QXt
   nNNIko/Ju60asSrmDU5lrBmr1sJMWXEzxlXneMXGiiOKMwRYH/zVAS81u
   F1PyJ7L1626TFL1X5IYyauk8/uKvNi7VTpx0ERZnNM5h3jbfLf1moKS+l
   w==;
X-CSE-ConnectionGUID: vo/roYvMQ/Wo7ZfV/F4PTg==
X-CSE-MsgGUID: lKgj65/LTW6CbMv5Yhfupw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67694310"
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="67694310"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 23:13:47 -0700
X-CSE-ConnectionGUID: ko0QEj7DRaebd1/eCntZmQ==
X-CSE-MsgGUID: eXRxQrsMSIaiefbb1qqHNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,263,1754982000"; 
   d="scan'208";a="185481011"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 23:13:48 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 23:13:47 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 23:13:47 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 23:13:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eKJC0g/f9m0lFAdCgrzI1nlm+rAu6C/iadOETvAHa7vGef9SAMBwS6zTfN5nEr3/JEfJ5rBCI/+KJH5pGhwqbqNbRSQCngxrHHEpUxMt8z2x830Aqq/N7DCyiMXMpj2qARZou1ZxxMECXP23DGIzCmT7/WmKbXt6ceI5GWMuC5NPmqrfH+4hkVKVHDtg2QUlGL49Rl9rlbzBri0IR1kRXyBeY0aMlA069iuUtWIBQunWG/8SnPsa8s2fhTwU3kNwLNLghvhR8QF8UuSzAyalKVVBWUwx3wFFzUu6IkWQj72w5ilUhWNHIxYgmvIgCcarGMDFWYcxla1ZTbLVEZqtrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnUxBWWIWL5G+IzQ4rBtMu9HumzoePAFM1bxhwQGUCY=;
 b=zQc2e/kr2zAPFhpIM0l7L9i33Lei+H0KAHwzxejSoUvifaPPSIJi804Vz9K/IrEGj7saFf1fCY3AIS4Uiy3XtMgLJP+b6oip9yGduIc7nqu9ajRN3AM9D2LxXChm27QRkfzHRL94efNdMOuK+OPYuqzXA/zpMQCnX6L5L+/UHJLAl9wTns1hdG39s2xbJv2y5LuRcKSaZN8y393nGPuFk9mgGFwmwbPiQABOIIzNsMSQItdOrnJbKPgSBhXC8lLfo/ZEIFJOXqvrmtcGt/A2ps8pPWgw6V62ta3HkOD1TcgLVk11OFbWehRlPsjYVWSUYlh1dbZqdos6XmbcEZBb1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:91::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.17; Wed, 29 Oct
 2025 06:13:43 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9275.011; Wed, 29 Oct 2025
 06:13:37 +0000
Date: Wed, 29 Oct 2025 14:13:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: Zhao Liu <zhao1.liu@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti
	<mtosatti@redhat.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, "John
 Allen" <john.allen@amd.com>, Babu Moger <babu.moger@amd.com>, Mathias Krause
	<minipli@grsecurity.net>, Dapeng Mi <dapeng1.mi@intel.com>, Zide Chen
	<zide.chen@intel.com>, Chenyi Qiang <chenyi.qiang@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Farrah Chen <farrah.chen@intel.com>
Subject: Re: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as
 migratable
Message-ID: <aQGwhpZmA3kp/a3q@intel.com>
References: <20251024065632.1448606-1-zhao1.liu@intel.com>
 <20251024065632.1448606-17-zhao1.liu@intel.com>
 <aP9Y4B1J1W+3Gv/2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aP9Y4B1J1W+3Gv/2@intel.com>
X-ClientProxiedBy: SG2PR06CA0193.apcprd06.prod.outlook.com (2603:1096:4:1::25)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CO1PR11MB5170:EE_
X-MS-Office365-Filtering-Correlation-Id: dc00578f-b06e-461a-f053-08de16b24bfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ryFMldFzHWywgJWntJ3toeaj3nnYHM+2UVdJgu5VxP3GwwFfQx1g1vXeg6pe?=
 =?us-ascii?Q?iE1kyHpbDVdMM/5LJ/xAkWSjVjcGZcuqu9i0LxnmGAGJLARN6eb3gvFwFlp9?=
 =?us-ascii?Q?DC1Efh7icRymfXpj47XcC+kzvrbA6TaI5IGXHDrIM8xf9JqbI+gDm2lYfJgO?=
 =?us-ascii?Q?7A+rrH8rdg9g9UluZqSgdc7QHhNZYs8PW0yLs4SdvKB4OA8DOeJ0O4Oua3jd?=
 =?us-ascii?Q?1h5olCA4BseXo2y8Kr3UgFjXU50coXXmlUjAX0q3nd7CkswWUn2vXSYIEeG3?=
 =?us-ascii?Q?QR/lFuJeLWrCG7Xfx6S6OtH4quIkeUAq5QPU/ByBflm7AbNuOBH8JKz7ORz3?=
 =?us-ascii?Q?nrIScZdZAoifI0ldIO+SZGIFiTrtjkDGmMWURDV/r4dyBpnJWmvbEzWbT2P3?=
 =?us-ascii?Q?gqQ31dWguNZMMX1O0kBkEZ7DNbAOacWb8SC+g9ZTkanbT3s5c7mBuQItntVu?=
 =?us-ascii?Q?bImltwSlq05XQIS5IVLIbLBE75D3XAXiPx2O9v0zbxbui8epQsahleMQyQNP?=
 =?us-ascii?Q?9BLqVKccJIVnno06sSZeQZ7Z4I1SQLiJhT44YVza+qQ6Nx2+0qxrv2FqXAhz?=
 =?us-ascii?Q?MfjWDo1C6QT+vO8fAbHT2DQW9m73YoqIolIXCY50hcc0IbHu4Z+HyQKq0NGk?=
 =?us-ascii?Q?s8q9Y/i66wCPzFgsLK+GBtEqmjQCN7JK3vjijDtRykShN5OssfkHQfRkFrAd?=
 =?us-ascii?Q?b50Fw9QeAF/0q6nOR2kxKIlI8RG3W8KZn1s395CTJiE5pKDj86Xnh5YxnEA4?=
 =?us-ascii?Q?fu9fVXS9WJZWize8M800KQ1kNrQFbdgN5APg1iQlAuPA93Lfapxm216qZ3f4?=
 =?us-ascii?Q?6sZdaS31Dd1NFPyLqm9F7VTmDif7pLBGpFw/8rE5nXWhUpPW4pj+LnuJfPoJ?=
 =?us-ascii?Q?dwpmKNFQ8bKjwUnzD7a72qFNzDDpbELSqbvJEj6nv86jWCahVOMVMc36XJ05?=
 =?us-ascii?Q?XGduCDw1S9dTE5Ak1drmXqMGWrWjd9GJPl8AwtN2Z/wSN3tPhOfkIJll6IG/?=
 =?us-ascii?Q?bc4rQpi79YW0GOVHaQUo0Az9anEtFRI+sv6lc7CCLTyMSaUDqwfhcCFGtiBt?=
 =?us-ascii?Q?K7IPrXC80ypU4XPX1xGzHjwIPxqBWByxdx8pkxwAqM475UdG+y/wFTDn0Slh?=
 =?us-ascii?Q?GR3k426E1m9QX37B7I8rD24ArEN99JQce1OM/tvUXqTxyEZegyxHXpmga+TY?=
 =?us-ascii?Q?0I0Cmg37wDvVJqi2My4gomSdfbxUrpsgHpTRp9JXB45qpueCFcYxSg10SLay?=
 =?us-ascii?Q?ufUSdj+gHPYts/9z8Vu8/vDL7Ksz9ZP1ZNfQTcfrk2U9VztyvIoPqgF/yTPo?=
 =?us-ascii?Q?b/BIjKNm6QyZvqJOmvWoGJxwAAwFIV+Q7tELN9dVefF0RxISsKtJlM5arkpR?=
 =?us-ascii?Q?XBXSd1IkPmr9dN89pXNYgPY85ycje8gphsqR5SwnoSGq4ruuA95SoGELeWmy?=
 =?us-ascii?Q?EhcdU2pFW5CesM3sqkUa1CWgFf0TkoFe?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gV8O5WUuhzDKGo+Szwm2uZt/cbxjBBYvOGUiKHMl7iAfjT84qWWfvIUb0Wyk?=
 =?us-ascii?Q?EiTKUMTWzoeyHcNOQt/PBsy7/5zdy9N3VLeYC8e9vY4dZhv1XAgKOa/YtCxG?=
 =?us-ascii?Q?4I199bthDuzbMuqiNgj3hipiyKVDng7qUXs177DFUyrxR12m+tcaUvJpy/wU?=
 =?us-ascii?Q?3JTRKmgmnJqYuiaHhFkVeAGNVsculIr+lVYjCRLeHQHQlW5u+g/I4X8mMu0H?=
 =?us-ascii?Q?au/LYIRD/kC+G/LS/x3064+0P9nN/TpvubAkWM8PRcX/zPopK6dscBnXdldC?=
 =?us-ascii?Q?1XToNYTIzNcjas0SaDUUVYy8Is9JL9Wq0BN+nPeZqjdUWTS4RvVC4kXHOB8N?=
 =?us-ascii?Q?rCp0GHzdgpM88/h/xsD7ua32irRDySdzZ9h9/jeOEEU6YNgNEd9VprKXeSfI?=
 =?us-ascii?Q?XVdg6BG730lSVI2TqHQI3HjKwWG0RPK4v4+E+zXLB6e0xuUdEQBvd6pmr7Sl?=
 =?us-ascii?Q?vS5je8TAdSOuO2vkjzt/H+CatlMTCX27US+/lH3a7TIMDe3Hcg6ItY+bEr60?=
 =?us-ascii?Q?5nP04tbNnnA86z9SABbw9lolfhKpVax8qO5mdT/YfrU2hhXYSF8zBxh/iaAn?=
 =?us-ascii?Q?CH6HYIl7xCwYuDEEGZx6Nu4OFqIpJkgueSr6/HmpkIYMon+qwkQ6TBvTPqXP?=
 =?us-ascii?Q?3Nm0Pt+DKVDQAH+U4FdpgDSSnGHVvFK7zcsjYGmOn7v8gKwaCnXLqQHBaumZ?=
 =?us-ascii?Q?CfJ5BSKfkoPRmR4gK/0ZQYvYaYAIBwjsPclQvujfKz6jrH+h7caRDHk4ik/z?=
 =?us-ascii?Q?024rB1t9QirwohNBv73rdGnvcaUS4Gh1eMRYPurilbeukIX6yLxgSIQdey6C?=
 =?us-ascii?Q?CHmxkh/Iwsp3gLJAN6b7Aj7G+prWqMO8RekWBO4llcb/DMBRAbRSXfPrm0hS?=
 =?us-ascii?Q?5KPvkQ8w0xow8mOwQU1Xwv0aq3laYZAkwVcjkhEwkZqvkbkjFm51ujcg00Ak?=
 =?us-ascii?Q?LOwSbhRmwFwh6uopW6EFYPO081F0LBN3qvtccWpp+q1Egc/mYYjmN7E/rL4o?=
 =?us-ascii?Q?+VWFEbThvOOiQccHrL+c+oAPA1VJ825WvT7Uj2IpkdIDH3Bqmtk8ZSYaM4vx?=
 =?us-ascii?Q?iP4XxJYf5nN+05lDEy/21mfD56ffVxXOo7dn5cBOO6QVSNGBl5z0qAM/hRhu?=
 =?us-ascii?Q?XNNCJN04hxaKRym7v5pih9COLyEe1dPBa9fF3WhIlh8h9XpYpmdSJ8QSlnym?=
 =?us-ascii?Q?xT+BzVD5rJ55S4o25cAgjj0s8BCL93xfp+EokiozHIJWcK9uFEMAInSNNhu9?=
 =?us-ascii?Q?U8iXwFWg9PfFaVSQAVPLCd0CuITw0Ho50+fp42O78n3mwvNbCQwr5CMF0V3z?=
 =?us-ascii?Q?+lcBy5Wuw+4RjN9mnXXrKFlfqJa6H+MBHjIc/t8mMZC/+DpNgMKN0FVJJd1p?=
 =?us-ascii?Q?cFUcB4a2roSodZ9q0v/E/xOZPzIPJsnPSHi3v0O5edMeWLhm05Or8vfA/J+g?=
 =?us-ascii?Q?Fnsp8Z/nETeGhai+eGjgL5hNuwNkI2eZqQUaF0f41nuMoSXqvChixXq+2Pch?=
 =?us-ascii?Q?psciriTgC6FoX37xNTS0hvFo/3r65SFUeaiEVAxH40x9nnhKWVQcN/bkZ7e/?=
 =?us-ascii?Q?Dg3V6HggmOSVK6rceU1dVHSORoLqDfnuOcz9bsjY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc00578f-b06e-461a-f053-08de16b24bfb
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 06:13:37.1141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3t4XJXK3ppHI8+85TSXZFyuE5ru+UzUjqTSL2EUakOiBgo40p2UBfA6MNOdXt1ZTtdghUaTn0ZJEzDyjs6GBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5170
X-OriginatorOrg: intel.com

On Mon, Oct 27, 2025 at 07:34:56PM +0800, Zhao Liu wrote:
>On Fri, Oct 24, 2025 at 02:56:28PM +0800, Zhao Liu wrote:
>> Date: Fri, 24 Oct 2025 14:56:28 +0800
>> From: Zhao Liu <zhao1.liu@intel.com>
>> Subject: [PATCH v3 16/20] i386/cpu: Mark cet-u & cet-s xstates as migratable
>> X-Mailer: git-send-email 2.34.1
>> 
>> Cet-u and cet-s are supervisor xstates. Their states are saved/loaded by
>> saving/loading related CET MSRs. And there's a vmsd "vmstate_cet" to
>> migrate these MSRs.
>> 
>> Thus, it's safe to mark them as migratable.
>> 
>> Tested-by: Farrah Chen <farrah.chen@intel.com>
>> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
>> ---
>>  target/i386/cpu.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 0bb65e8c5321..c08066a338a3 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1522,7 +1522,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>>          .migratable_flags = XSTATE_FP_MASK | XSTATE_SSE_MASK |
>>              XSTATE_YMM_MASK | XSTATE_BNDREGS_MASK | XSTATE_BNDCSR_MASK |
>>              XSTATE_OPMASK_MASK | XSTATE_ZMM_Hi256_MASK | XSTATE_Hi16_ZMM_MASK |
>> -            XSTATE_PKRU_MASK | XSTATE_ARCH_LBR_MASK | XSTATE_XTILE_CFG_MASK |
>> +            XSTATE_PKRU_MASK | XSTATE_CET_U_MASK | XSTATE_CET_S_MASK |
>
>CET-U & CET-S should be added to FEAT_XSAVE_XSS_LO.

Yes. XSTATE_ARCH_LBR_MASK as well.

