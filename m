Return-Path: <kvm+bounces-51264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCABFAF0D44
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8E95A7B220A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 07:54:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E921123184F;
	Wed,  2 Jul 2025 07:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FqGxchHr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99886200BA1;
	Wed,  2 Jul 2025 07:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751442947; cv=fail; b=LOzEIt21o1Y7XCHn4kEXPVqeldnDjad9IO917KdK7niVFi2t73yQw7/2DigAFWT9zvT4eaQ1yKtrPbYQ1bBGPWpcFRtej4OOTgX9pRgxM6AqoNUkc2SwrDD+3s1wodE2+iGwcgQ8frM5qwdEMIJsqZ9zAaqNtK77MGBmn+ePzHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751442947; c=relaxed/simple;
	bh=q7Q7Jq1JIpzy56YmeTUZSKSRLNZDC1sXkYrrc0WoJhw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KQqTSU0WuXoaC5gHFrGJFU0uwfkXnu36eY37KtyYs1CCYDEA5IlaRw4YCks25INLyvlGq805o1w5rtH+f3WAhEBERy3ZjejquMhkpbBgHz90C1CRJyNguSBXRslTOOgoVJ//Zo0XFdSXSQ0OOmqt4Q6p1ixPRNTdGMUytJbx69M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FqGxchHr; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751442946; x=1782978946;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=q7Q7Jq1JIpzy56YmeTUZSKSRLNZDC1sXkYrrc0WoJhw=;
  b=FqGxchHrBb1v/+tfW6Yw3vJh0uuZhmV+Luo2XwKmFejDQ4GNiIsNOHTk
   2QOXrZucJzfBUmU1SDz+Mhpy5hFlkmUBwM2BiOsKYrdR3j0BvCWrOgr2J
   kj92e1IOud9nZe7DqdXqiHZVr+cRQVWjYiW5JWZLVx0+PfrOUfwtHQVJX
   JSp/8Ko40xBVsB/RcGaFgw79McmkpIiJ6iMkGs82mu3dIBw/q6JxvYK5k
   xdt5WTvVbH/gGFN3ZOWGISuQ1b8ad24kZ0Sw1/P++XXTRH5X3jfXEszRy
   Dp5dFGwybQdqaoVIP4+N60Httjrqic+Nt9WnqJsAJ/hUN3xfPk+uBa4GS
   Q==;
X-CSE-ConnectionGUID: 9TEFQPBjScSLVivSHQGzrA==
X-CSE-MsgGUID: CWS+DHlzQ+qv7XbpbLj2tQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64421616"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="64421616"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 00:55:44 -0700
X-CSE-ConnectionGUID: zzTzT3NQR/CMmemX9Im/Kw==
X-CSE-MsgGUID: ol0naELHQCqGmUF6lS5ysw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="154088325"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 00:55:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 00:55:43 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 00:55:43 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 00:55:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yp844wdDgLa/9jzVtTM3rKQGewiqiEJq3D/1wvAoMuBJhDvNBgJvaVzRl/4TxQDKSvWcrsix0z0fUru427eZXiK6BOpzVC8xzYhQOgJgTz5Yy54b066v2fWTAQSOn0tvRnvYJ7Huv4GbSoG6YPT8rGxd7QplIXxnu/6GvShX2CkYOP86QDkNXY4mLcvLAPCeweB9KIWrmr+Ongx6H0mkpfd/xsn23ndYT9KFgI9i+nz4bCA+aLjCQlLv6qu0gu2nbFEmvCm6pXzVzwYBXVcbUV//XszxNG8A/gUWxWvbX1pxQ6Z0t94CgwTvRqcq7h7bauM077EOuwCRgv7OTDsiRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YG3ZoaNkvH0G9xHejdNAfdMNo5K33aNNeu7c0PfIjik=;
 b=xKrmnvq9XoU1g6NpWLWebiobHsiJCrtY82RjQ75jaRQItrSP7a4kD34fz7k9LGaNgPTYl0YJ8CIHlpB6/GxTZhJ1yozMuYhb76we4dNzWOT/bir+U7f7KrLuQLSQtgHkjSbFl2HO7gvtOmJfgmKsVs2ygjPBXZGktzLQfS9favjaaMZv+Gg38X0gZK2wZ5ZRXsKO2Twe5QZiDSVrPLxM5esVA58ophg9g0iSuPVGhn4fwUhBSXvXkRyIE0B1xx6D2gpLXdDsA6SnH0wnPDZPw7w721QumT2ibhJ/ETOFvtDrJr853QBM10kFHeL0Rpn+K2366JLNlzBcZTJpn6i+hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA3PR11MB8047.namprd11.prod.outlook.com (2603:10b6:806:2fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 07:55:13 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Wed, 2 Jul 2025
 07:55:12 +0000
Date: Wed, 2 Jul 2025 15:54:59 +0800
From: Chao Gao <chao.gao@intel.com>
To: Kai Huang <kai.huang@intel.com>
CC: <dave.hansen@intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<thomas.lendacky@amd.com>, <x86@kernel.org>,
	<kirill.shutemov@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<kvm@vger.kernel.org>, <reinette.chatre@intel.com>,
	<isaku.yamahata@intel.com>, <dan.j.williams@intel.com>,
	<ashish.kalra@amd.com>, <nik.borisov@suse.com>, <sagis@google.com>, "Farrah
 Chen" <farrah.chen@intel.com>
Subject: Re: [PATCH v3 6/6] KVM: TDX: Explicitly do WBINVD upon reboot
 notifier
Message-ID: <aGTl09wV1Kt6b0Hz@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
 <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6cc612331718a8bdaae9ee7071b6a360d71f2ab8.1750934177.git.kai.huang@intel.com>
X-ClientProxiedBy: SG2P153CA0043.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::12)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA3PR11MB8047:EE_
X-MS-Office365-Filtering-Correlation-Id: 277bb017-2404-4242-7d82-08ddb93dc5fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tjkSAVn1bH7uYnwJWqVna7j7iNFNvxxtP6iMz/HQtAuEswr7KtnhmW4OYSiP?=
 =?us-ascii?Q?oSMmDldPTbkmZGRp3DeHUwE9L3cNiv6FqxVWwWpXlb1G0LQQqq12xQdTpFKN?=
 =?us-ascii?Q?PNRyCBBMw6xOqz8cG+ujbru6oA8ODsQeInoijHX4a7Psx9ruWiYDjG5Dn+ga?=
 =?us-ascii?Q?97qkLZrswRNybbLJr+3QYzrV/zp7UPHGz3Kp5ux2no7kQip5Q7cm0rq7UMRp?=
 =?us-ascii?Q?bqQ86aGxA/G+j0l/pRuE+gchz5WcoagHAH0r4l/Ecj7NGTUBNFNmXnBE95rt?=
 =?us-ascii?Q?cKMimQkRFtthva1C4JBUgw2BW5BYWWPAJXCyzSQZ7pRNR/ufJQWMgis1QQ5k?=
 =?us-ascii?Q?ZXgGaSryjUivD1JLGsM+JHwIp75Mf6awBfFP4llAtAQe+ertZymatJFSaevg?=
 =?us-ascii?Q?eIH87nlPWVn6th2/qoirtSYw3acBBCOp8nRY9P9H524vH8XnDIX8/8Ox93N2?=
 =?us-ascii?Q?8O2IunhAkfr32vBUbgCtwL5LvnpGnsRJxHVwJ3Q9OmyFx705q68qj8rj+p4x?=
 =?us-ascii?Q?SgtXD8DQXlv3obIf+cO9xOJ5I0g1myVf8+zAz3gwdn8E/YZWntAok15zNWpF?=
 =?us-ascii?Q?1R7y53uU11TmYtetpVvEua4fw5gjs7FDMlkQVwMVF5r3genQIEj0cFRh20nM?=
 =?us-ascii?Q?/ID9dQIxoHnBEGNpQLdMcNH6xjSvq60VNiTQYZny6W+zVIRW4Zmr5muR06k5?=
 =?us-ascii?Q?hQ47vbAvDTr1L13Uq4k4X6lESXoYZ6pWlnVYFBytB1Fbr6+f4taKFmkG0/Ov?=
 =?us-ascii?Q?gApcNDQLZpFbfG2FEOmQjz++ykfDoKln2ZxmBl+D/f83n8zmKbdbZ2qmwCNk?=
 =?us-ascii?Q?UimXGTrFbKWmFwUPOFScNiEDl4X4cNlaQZcMw5+mMmtxuuiXxeeJ+f8dEOgf?=
 =?us-ascii?Q?prnmwJDHJ5QZzles3860mdI+LB2/DVbIz1anwz+FMEOvUMAHjWcKZhY1lKnh?=
 =?us-ascii?Q?wkkOnLuZrwxKju5O5lMR2HrivSnlWMNyoCYfE4ihkxpQsoDU1BiWmvGizBG3?=
 =?us-ascii?Q?RaMTOWtlQTjtIcguMQThU2vXqV+PRltDs4H4RoS6bVrqkKG7SVwuVUYtyGEV?=
 =?us-ascii?Q?GcRhwdMa5qDiAhc1KXzJdBEGVFI05EadyPootyib+6njZQ13kGhMiz24Kevl?=
 =?us-ascii?Q?n0KFNLWiuCdnTwG8+rp1RNFuJVopoUsvBKd6Ru61eAZ+x9Q4sN3X0Jfr6N3C?=
 =?us-ascii?Q?rF48s2OVyCoqVCOfoh8jFHVEQphMT1lJQTrPZ6YpxYPi4rouGMtPJ5AgMBYB?=
 =?us-ascii?Q?n7X0FMC7f2b3VYJ2TBQT8XhsxKArZ3Qc+s1jhsDeElEEOgZXg8RI4eWGQpPd?=
 =?us-ascii?Q?DVTu85pjX+HuIwU6rXIbQkYUFu2Aro5dhpFDYidQsLOO/V2o2aaHLRyktcQY?=
 =?us-ascii?Q?1zD3tv2LAzTKvjZB04f8D4DegzIhAqstgWxQ79HwLUHgl72osKelaOXKjprj?=
 =?us-ascii?Q?ooZy4VTOjtg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5ryE5+GXkQ4647lQ+cHThGXzTvhzlUiG2AdKishNgtw499m9HUHyaaIZapOn?=
 =?us-ascii?Q?pk599ALiG1FTOi4/8I/QqM1W+yV/NoHVOB/fUcRYtNSssXBhuciipW67CkQT?=
 =?us-ascii?Q?r3nttFm1YB8Ohny+rSc/lXwlAz9q2PBgMgcRmPQ2CD8fmTti4OpwOBSojZQp?=
 =?us-ascii?Q?deDGm+1xGxJ5Hj3xR+Rf8aXtSAd4moHloQPTyv8OibV+unX97H3NwNKaKoJy?=
 =?us-ascii?Q?BxVaKHHpbZgeNoiK9+bhIB9llN/T5LU+fcWYFpo0NFh8+K5qyOILMVvOOHT2?=
 =?us-ascii?Q?hIH9NYWFzlMoIDQT85anZFu28XSpEyPYZYqB0ra1jOI29xyzUsMDXdPv877/?=
 =?us-ascii?Q?LBkRHGBbJ9NOj0RRQ0wejdxUx0EZajyNj+WjzkQ1Gf1aave9kk/qfmXXFhOp?=
 =?us-ascii?Q?U/zpvPI5tES26tvm537bjrB48unHyLVG9tPjsQ/h/PSNRJZJEDKNwOemrWKL?=
 =?us-ascii?Q?1LHSkObTXF2y4gq9swu52vGAw7N9HZScpEk2CvRtNNZmPXrWOcOVW9ZizWGs?=
 =?us-ascii?Q?B1PeAWtHm6NU6+Ye+wFdhYT9PMQRNH64grQsK/CBNM62VqBKb8CmCurFm0VX?=
 =?us-ascii?Q?XHVmvzJ5tOtzuwC7V6WMqehYoaENf6iBDZ3UrJ1XxvvjsOs1avRkdY5/Xe1M?=
 =?us-ascii?Q?nYwFiiRpH6uvgdhhNGobQD/dAeCedM7BY5kG5/Xf6WzsMaBxjPighwnCp3CI?=
 =?us-ascii?Q?DwfeCugDJmx0qldWb8D6RJmDj/c+nhOIMycnhipArDVbxcWPykRLK/r17/QM?=
 =?us-ascii?Q?U109pCD83zrE7kYmXhjKIgn94ghfN79slfYL0m9c0f8U8+j02LkPErYmTrly?=
 =?us-ascii?Q?xveZ75590ZG8vw29xigrKrE/6aepplH02LgdYz1aPd/JsSjhw/AwrBD/7V0l?=
 =?us-ascii?Q?OxTx1Ij5feDBBGjuwrHjLx/+piTpUwgMPzXSwGg/E8pf48PZv91uSPN8+7LJ?=
 =?us-ascii?Q?in6MffEVv6AM0LKJK+2SKNA8GPxKD2fWuZYAB4bmarQwcgq48cpW4H5UvXMm?=
 =?us-ascii?Q?oj4wF8kFhVFi4sIUgFwkDLOfRzeQDKJU36Vy5NhBdhZ+ZSO4MP9eVhAnpr4V?=
 =?us-ascii?Q?Ofbp33hNs8Cv6zHJU9lDfJD8ECTkp+8TNjiQ2RCqNqNK1Nq0u3CU6iMvTzqF?=
 =?us-ascii?Q?ZXuQb/KT/bo1LCZtfEUOInAYSP3AZjp4i2d9C7nQo2ChqykKGa+VfX8GtjxX?=
 =?us-ascii?Q?9VXRXzBVPaA7Z7zmzkvEJuZDzl7x00URIqtHEXF3tHUPzUU2MRZQFJm8LXCH?=
 =?us-ascii?Q?iFl94g4CZsKMQJ8MN3lpDlbDZxaL03zqmeyiAsiT5f8ngkGKkKQGmBFXQZUK?=
 =?us-ascii?Q?P4CglB5FkrE6+QzwHaEHG0EQ4ZNfaiqsD0lG/5lywvY9ml5QJXTDYqdNq1Rx?=
 =?us-ascii?Q?rgfqUVj8ZZJFnf3dQaRkwGVrkIWuH2jcom7Scl1MfICzZwIol0OxjmNkpV3q?=
 =?us-ascii?Q?so+Cl9W8F+Oa4hH7Z48g3fX7vnfcEneWWhnZ2ZseAT/01dd5Fh+7haPeUB77?=
 =?us-ascii?Q?dVzdlr/jSmw/neNEHgRVc4FukyiPqjsp96bP5qio2CYEiqek2qM6nEF9X2pK?=
 =?us-ascii?Q?BiDu11GLzgqJ/QfGlzLjfkE5p0HOl3wSoizGYXG8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 277bb017-2404-4242-7d82-08ddb93dc5fc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 07:55:12.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jGnot7xYVND+2WBDHf5CgX+0UZqJvuj/pi+msLw90McB5gSEbCTDJwFakpjMRfSlRei+VCGIab2SgwZTIJC9mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8047
X-OriginatorOrg: intel.com

>--- a/arch/x86/virt/vmx/tdx/tdx.c
>+++ b/arch/x86/virt/vmx/tdx/tdx.c
>@@ -1870,3 +1870,12 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
> 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
> }
> EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
>+
>+void tdx_cpu_flush_cache(void)
>+{
>+	lockdep_assert_preemption_disabled();
>+
>+	wbinvd();

Shouldn't you check the per-CPU variable first? so that WBINVD can be
skipped if there is nothing incoherent.

And reboot notifier looks the wrong place for WBINVD. Because SEAMCALLs
(see below) called after the reboot notifier will set the per-CPU variable
again. So in some cases, this patch will result in an *extra* WBINVD
instead of moving WBINVD to an earlier stage.

kernel_kexec()
  ->kernel_restart_prepare()
    ->blocking_notifier_call_chain() // reboot notifier
  ->syscore_shutdown()
    -> ...
      ->tdx_disable_virtualization_cpu()
        ->tdx_flush_vp()

>+	this_cpu_write(cache_state_incoherent, false);
>+}
>+EXPORT_SYMBOL_GPL(tdx_cpu_flush_cache);

I wonder why we don't simply perform WBINVD in
vt_disable_virtualization_cpu() after VMXOFF, i.e.,

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d1e02e567b57..1ad3c28b8eff 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -19,6 +19,8 @@ static void vt_disable_virtualization_cpu(void)
	if (enable_tdx)
		tdx_disable_virtualization_cpu();
	vmx_disable_virtualization_cpu();
+	/* Explain why WBINVD is needed */
+	if (enable_tdx)
+		wbinvd();
 }
 
 static __init int vt_hardware_setup(void)

It can solve the cache line aliasing problem and is much simpler than
patches 1-2 and 6.

