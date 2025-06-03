Return-Path: <kvm+bounces-48275-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E11CACC190
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 09:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0F983A4667
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 07:57:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE7F727FB3B;
	Tue,  3 Jun 2025 07:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PPi4xbfa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAFE42A96;
	Tue,  3 Jun 2025 07:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748937472; cv=fail; b=FmjPu4QiLgJVKh95joftbOyiX02RreylusIn+gecSvS6iVChvoaJSZpJya+ZS+OV5azfCkC9pdVkL45PVbBt81ZZxd9fHN6o+O0unXid57jvwb8hbisFbHGQT5+V26YpUHNzR3qt3H4HEzBTOI5vDcCGeWJ+S3a6EBVaPF5/RPc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748937472; c=relaxed/simple;
	bh=3jRsGFebLr9aXeJxQ7ukCXC496oEHlsF11vcomqUm3Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C6ZiMLerr5gzhUT06BszkgTRbZNC1CIpGgDNsfbFZo5MO0TOFL6W1j99MKHiRWXnQ8yKPmJs5/iYOgePh42fjBnJ917iNzOsUtpWJvJfvHo7T1pwcN6jqynoJWMeBSJojZdk1xIGLvzJm9LkxN6J6K+52OpxeCoi56vCzfymATo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PPi4xbfa; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748937470; x=1780473470;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3jRsGFebLr9aXeJxQ7ukCXC496oEHlsF11vcomqUm3Y=;
  b=PPi4xbfaAjASkSkaf+niECl+icjDASs07kh0q8LifUhASgA8pcq5EPd1
   1L7DLMPxQHaUORY9y47NIUso+dt9AvB83PUcNqcv7Tvv773tkeQmmW7Gw
   Mio9G7cDJPIDAqcEP9GgOMXbJjTXJiYZVrw24mAD8idjP8o1NGdXxofcf
   tIMNFuLTkRs5oCulkDZ14UOsgRr8SlgFuxdtYXzMbqQaQvMdfCr/4w8YZ
   YmbIuDn+yhLYgkr7RI15llAcZpbnlDt+pVfMoUU+7LOZ8GVnJgBN2tWPV
   9Ia5IAuWlM6wlGMBoRXw4o1Mc/Sny5uphGYXFuyNNWzOj4Zj4kwez3pzK
   A==;
X-CSE-ConnectionGUID: UX8+WtPST/+ByuAZZ1m78g==
X-CSE-MsgGUID: jDs9igv0Q8OUIYNX0h6gJQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11451"; a="76357499"
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="76357499"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:57:49 -0700
X-CSE-ConnectionGUID: P9EDP60eQ5WKVymrkW0PbQ==
X-CSE-MsgGUID: GheCmY8lSge3hy0F5xw4Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,205,1744095600"; 
   d="scan'208";a="144673653"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 00:57:50 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 00:57:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 00:57:48 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.45)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 00:57:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dbXF6mpUfj24PETaRFEY0cGRmqOQ6a/KMmSYezi93P0LcVIRWyRvyTh43SyjWROjc9/1EA3eycogd5pD9OV6dyuLnpeS+fTpnqP6M4swh9YQp1mR01uZJUD8FM8rIgm56EnbEvIFxY06FgQXhuI6aeH1kzXE+ux6ZF4Lv4Yuc+KSxnN7SLKSH59+xvh2zEDJcd2fMblwUmp8oWHNbxvrYRb0IhOcEJlK9SuUQkTU319IjQtnw9JckAirJblp8C1W0lDHj4n/Yz+E1rxp3+EaVWd6DYHq9VGWtW1IfyNgviKGY1uqHO3P5HMtWYJgc7cO4nR2rXGrWZadglPjE8CCFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jRsGFebLr9aXeJxQ7ukCXC496oEHlsF11vcomqUm3Y=;
 b=FctaKoKijWKPX7T4fdjv49IpP+NjFVLysB7zEuXsNVXKqbGzQ5AR5aisGIPckCvPq2inkzQGV+EUCtDq/5CY7LgH9gULWI6x+ggqhvROJlib5dFX8iGrt9nAh33PyZnAPw6ZI3oz/KcuovSzn+nhdeukPDjKA82ravQS1eZdHaWrCTNcNybeR81jzfNT+vhcBmYJEyfLZDPKyN+GHL436Tk/FH//Xm1ZE6Nzr9wQt9ldboacc3XbMlayY4TwteC1j+wraQ1h4P8/2CFbsRHGr2KqPMsGdipcWmkEAJFYnGNTq4uqnm31v2avob+vhqN9cxlfX+VZryQtOvrMov9haA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB7950.namprd11.prod.outlook.com (2603:10b6:8:e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.31; Tue, 3 Jun
 2025 07:57:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Tue, 3 Jun 2025
 07:57:32 +0000
Date: Tue, 3 Jun 2025 15:57:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 03/28] KVM: SVM: Use ARRAY_SIZE() to iterate over
 direct_access_msrs
Message-ID: <aD6q42o/o/fh9SrT@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-4-seanjc@google.com>
X-ClientProxiedBy: SG2P153CA0014.APCP153.PROD.OUTLOOK.COM (2603:1096::24) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB7950:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c5168e9-1e75-4a75-cf85-08dda2744baf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ANS3or14ULYJtvp7wVgkyGrlKmQ/205Inu32iQtgbB3bgTb66jTaUx2WKlt8?=
 =?us-ascii?Q?0boURL3KMBgVk0hjs+6yuokU0ckikS3SXWpGp74xlkd91TbW5B4bgBgmWWAT?=
 =?us-ascii?Q?ZJJ2RzSmd2N2x2/8fY1qS8NlXsOaYwYO+Tc2GAjqtuNPxBesj9Cbie8Y9Izh?=
 =?us-ascii?Q?ICQmtNyOuH7I5anwrE8+U41DsZ2nXnh8a6XT3fkkfgh0sGovvBxgq2lLTF7w?=
 =?us-ascii?Q?dFe6l62fm1iYc551dojUd0Msc2039xDx4SNMTOP/XCRvJ/bIDtMZnykzK9cm?=
 =?us-ascii?Q?+Bq8KgUkRx+vcAqvhubvxjILg2YZSws8rttcFafO7k+/dV3L4F5bwwgiUQdI?=
 =?us-ascii?Q?T3rgRmSbSaTpO3Czpas4vq4Tau3aCSK/xtUS8a18Z/nM1jMiK8W+YCopm2r8?=
 =?us-ascii?Q?fDwfpQYHO0Hnm+cHc+ad/nwKqYW9kVxt9GHafDmaySTos1YpZoB9jMNlcYcn?=
 =?us-ascii?Q?btI2mi3Ps0DNpycfywWYvGdBHG44/zfi9HeLLLh4nfcAVxTNt7SMCUCr+qUo?=
 =?us-ascii?Q?APKM6tTv6Z10zwkky//73iTPEW7EkqilhIHYtKDo1XbU5rsKJTC9QlxZKah/?=
 =?us-ascii?Q?56mlzm89ag67AHyQpOHDgY0c+S8/p8yVhOq9lUvaw8+Pi3wCLv4wmoDTpfwA?=
 =?us-ascii?Q?KFyKsC447GhwwaNx7c5TDL/Ohp9X4dBK3A05fdhcG91T1asW35DBNvEvdy13?=
 =?us-ascii?Q?9nj729JidbWbIkoxRyPf47icwGW8v0BcPuI1OKiFDeyz0HkWxYXLdWaO/PJL?=
 =?us-ascii?Q?hKecOrLlcR7JJypvdTDTCiUTK+bYUR7d39JsFYZVJQOvNLCHQQkJtDJnot1/?=
 =?us-ascii?Q?qexS80xOxX62w/0rImgX6H3gKaCJEr8jMjbsgFeKGB1AVYWxSW4IICExDjf0?=
 =?us-ascii?Q?iXm0LsApVyZZtdIiu8C0uHlGfgBncRwg7RU6muPXduqmr1cXGqWdYV6jrOIr?=
 =?us-ascii?Q?ErOF/f3tn95t5nYDmsUSw0FZoNojCuFln3GcArxq3O9bPAjAjYfKmUys/3fw?=
 =?us-ascii?Q?JKiX9DNyVbspIqpiZByDV/inCd0JW/7OyQqMnwfjOy1z+nWso/t9f+MR/gaE?=
 =?us-ascii?Q?Vw4TjghO3nLK5NKOWUWRLTLhZ77ge4wq4nd/9LIwxYfhwOF36CGvEab9Aqwm?=
 =?us-ascii?Q?qZaf6tsNfJhwWFZ6h//Y5t9LW8pOzDIGV2iaoTh0TgBqtv9X3z3vgLcDjUrM?=
 =?us-ascii?Q?NrKcER37taSas9GNSxMfWAPGc8yAX0msfgeISzxXxl7eDaK63eiosuunkPmk?=
 =?us-ascii?Q?+V70J0O1DSI6FhgdeTiIFUzuHBSVFEcoJuDLhUeDgbM1TE1k6o6+DNfdZJc/?=
 =?us-ascii?Q?yi39cJqEbQVIIrBFK9HhkfLQOlajuGv3CdlFNBSWcoYCVErT9Zp0OkUuGJuG?=
 =?us-ascii?Q?TUw0KyL5baR0hW2WUfGMFVo7TP020eV5DZkFbmNBfpsOR+P9GfWD/XTG63FB?=
 =?us-ascii?Q?xRorJHKsFwo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NS8Rp2A5Y91kwnBxbDz/1Cyu4OatzmqxBy0vBaI2ZxKkZbhhQSPFLM5HbUaD?=
 =?us-ascii?Q?w9sd5MVpxZhkoccf/0V0T8pYqpJCIbGXa8AhTq/uJPNIlqwJ+99Rt5clFECi?=
 =?us-ascii?Q?qJQtjTBVseOskTx3XKeZMK2gx601nL9ksNl+4YDofymvMrS9DQQ+hBd84xYR?=
 =?us-ascii?Q?ohmgTu+TX6zFcfb8peYJQuufuOKmuhhtZ4Ypq55O6HwWHoJVTkY4863eejgI?=
 =?us-ascii?Q?AxWGlJWFJfYPGmmO1zVsjz+erdzh6DjYYJuX4EBPwvK3F2u2BG+QCdlwM1A6?=
 =?us-ascii?Q?5qwNsNJKIuif6aGciWqpeEjbLEC1TP3LEGIBNKeLMp2gPS0q5UBagylzWcu4?=
 =?us-ascii?Q?giHGJnnz/TDFseipFsRvEVtVwBac0H5K61XLgcy+RkU3G3FQiZKp1jiCR7m4?=
 =?us-ascii?Q?chsBT5TZdz7NgJWSvsXK4t3+qIWoSorvKQ7jnoh0pS3l2zF/1hvBWZd8TMQr?=
 =?us-ascii?Q?xbC/yMGySeKrKrE8GeyvMAWiz/DCdEzyY5q0RC+ywf03mwp3vn8gh8ippq01?=
 =?us-ascii?Q?4dVGm3b6idXdFFQ/pLpPNaQn0sifJGsHzduBNlw+SKGnGOcjG+jMiBSlfWml?=
 =?us-ascii?Q?b4zKuDFew5vAK/aJIS6+WdR+eZGMPB1md2giLNHPqwChXExv8gpAZEc0lnUO?=
 =?us-ascii?Q?uJCgEAKonV6hKenw++AyxUec8HbDm/InAfPb9M/aOmdZr4lQYLvEqqQ8ELVy?=
 =?us-ascii?Q?ibQ0Qf9G4fvE13mk7B/faIKaYVNUKZaMISeTGbw7ruCXSTrlaIsnZeKFkSF9?=
 =?us-ascii?Q?vL1MnvFuE/W81aX0zyxbfDh8dZYnJABTGeddXg9HPWCCwiXPVg2XI/8espKQ?=
 =?us-ascii?Q?lVzVlIvw+0MBeLPK5dlJJhvO4GrgtuUK9MFMRKsVSoLCzVi1CK6l+/S8W2j6?=
 =?us-ascii?Q?lo8aM3cwHCwxM5G4VRZcouZspDtBQhwHth+4N4d0xz3LAz21YK4UpPW3hfnx?=
 =?us-ascii?Q?zQZJlI4fsiG5fvsBwMbjJjjtgRBUZDPqWBTEOA5pX9xrO5++XGMRoLtltPwY?=
 =?us-ascii?Q?CxQt0/zYus6/PBbodm+MMbXVObTcI2BY2OeDgLUOdD/Ho0N+RHWxZfRER4hl?=
 =?us-ascii?Q?JAfANU6NZ6CsFhlGZxdffF223/0GHZZ5E+dn1LrNUqb0dlmLmCGNEMDudfLR?=
 =?us-ascii?Q?E7qxKEXywwYMxdJUh9kOuqw1qiFQkxHus/jCHZmMP/sFqjn5zBgCfPD2S92W?=
 =?us-ascii?Q?9Uayim+Nf9+6RTA83C2tfmQJ7TThC3AwPbgm45BmfhYnUynlWnPOSgdh+IXT?=
 =?us-ascii?Q?d6bftCZeE4OvE5mWD5h7JZGW9rHOP9agp8JMfDwDhUBsT27Ye/RTOVnTO/5S?=
 =?us-ascii?Q?AWUa1B6THalzfkrataUx5wXhz/jb80ao+VPBKQdJrHsXtiqaQBZBlOSxNDFJ?=
 =?us-ascii?Q?M/WFQcOwpcFBFzh8YHbyob8z/khfK/c1RmmVzf6YDtvhW0CFd6GW+MqKiDVG?=
 =?us-ascii?Q?pOOTc/ugda/BsRXhNg5UdJsYnGwPLMoCllen4DVFzORp4+s1IQ9yHKNKmhSQ?=
 =?us-ascii?Q?QtQzZDbJ0XfPp0vP8PN9FmZ0eziJSiBkPciwuABkbhjbnGu3pNCC4Gjpu9+b?=
 =?us-ascii?Q?pWov50702jDhE/73UX/nypyBYK2wk9Dhb5Fjjdqe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c5168e9-1e75-4a75-cf85-08dda2744baf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 07:57:32.7768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5d7lBu3/eMimpg+3wLjai2ILdFsmRYxZv/fS3QmbxruvRxPG0xtvrM43DJZwCEyw0vvlNUlXOieqcMjE45VolQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7950
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:39:48PM -0700, Sean Christopherson wrote:
>Drop the unnecessary and dangerous value-terminated behavior of
>direct_access_msrs, and simply iterate over the actual size of the array.
>The use in svm_set_x2apic_msr_interception() is especially sketchy, as it
>relies on unused capacity being zero-initialized, and '0' being outside
>the range of x2APIC MSRs.
>
>To ensure the array and shadow_msr_intercept stay synchronized, simply
>assert that their sizes are identical (note the six 64-bit-only MSRs).
>
>Note, direct_access_msrs will soon be removed entirely; keeping the assert
>synchronized with the array isn't expected to be along-term maintenance
>burden.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

