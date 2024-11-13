Return-Path: <kvm+bounces-31724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D83F9C6DE5
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:31:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C4D401F2355B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12AF1FF7D9;
	Wed, 13 Nov 2024 11:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNKPUhKO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039201FF5E5;
	Wed, 13 Nov 2024 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731497481; cv=fail; b=cH8KB5n9/+gZt/ONjwq/kynzG1pS7zeKuoVwYyuN8jb9GItjo/gIZbJiLp8eAz4K0vilMCqoah/hrbYYXWz6gd9ikL7zRnj4XLbdZDhSAkvKGGa1F3r/BYcnEOE5oqni6XH+KUhYo1u1TRGnm7LdJMl/VsoX+vsGnOZh5QXqWHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731497481; c=relaxed/simple;
	bh=5SOBVHVsrJVEBIa4fmUk7Yv2e4fRtthQuRl8M6ABQgc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EtHfKXo5/nqBdle5tFJPK52saaPCDxayhGsSQXn5/+pEqGomBii1r3FfZmK5PWcXmJKlls71khyOzNiO3AaA/pYcXlp6nyQ5s6c6XzWWg7PbeVkxpO3dSl4w3KScttKRctvozVHwv8TSYXCrtFoQN/Kr0PgiIxYkbGT8KH6sO0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SNKPUhKO; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731497479; x=1763033479;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5SOBVHVsrJVEBIa4fmUk7Yv2e4fRtthQuRl8M6ABQgc=;
  b=SNKPUhKOz2gXJWTAwwyqtNVGQ7A/k5bP4cPKAKpQbQ+atK3cHXP70SI9
   boisi4kE6thEPWlpl+UUy80bKwkBvMisZa7lgOSnqY2Fa4+nXfU9Tcs4E
   IRXXvzTEHl0CH2N2kG7aaTRlVQfm6iwHGzvmhJJ5kl2CgRnFMDG66TqlG
   jqn39cqcn729dflPKGzfObE+YSQiMx7d7Jew/pN1xxnvWPnVLjGAE8Y5G
   kyTZkYGGHgCrCTiiaJ8EQ0p3aGWrd4K8MxZRYMJyWKG50sL4jvO16BjRl
   8ctjY0YB3PuU/bxhEMoM9KTsBW6tVvd6nr5ebKFUUkZwVCFQ/HAgbl2f/
   g==;
X-CSE-ConnectionGUID: AtjbUcbBQKCJEEsCmgNQzQ==
X-CSE-MsgGUID: fD3mBJfhTumulJcWLorIsg==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="42000647"
X-IronPort-AV: E=Sophos;i="6.12,150,1728975600"; 
   d="scan'208";a="42000647"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 03:31:18 -0800
X-CSE-ConnectionGUID: 9/GV9bqtRLCzsoKa20+wDg==
X-CSE-MsgGUID: JnsStBflS0aRXG0vkNxX/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="92780183"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 03:31:17 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 03:31:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 03:31:17 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 03:31:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=grNvc8YGZ6PvXHAi6rZx7MrOCvYwFgtJ+kuLhPWBoA15FAAIvW1/BOM4TabStDnMWLzT5U9iGFFkrf/nsqsFaAkx16FTg3HUXQ513eAeKwYczyc15qFRBDWPxOAmpeIOuLPQwXjT6A1WXpfGvQz/fYhgKLa5i10HjK5SWw/eRMNlUpGQZUcDHmEtyrsHYATR2SoaONMriMChRUX8Ln/SwoVlJT87BLq7Iq/MAknwSQi/pXCpdEpO24WfLUJd61OzwKtPuX4mE3BOchSxbRU/glGaNRU/caY5US4M8yd+L9HGirc9DcZpLv0c9GxHwUv7eG3OlS3xeq48aYDS7Mtfww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teA6/cT37zKzvqA8GhQnzDmWLZyaF7c7R23EYoDt9dI=;
 b=U3vbUhvJwP8msMDAfUUyN0KMX75119v94fFVWe4SVF9CSy5uXeZgVKwWzGcoYzwPjqKDacbVhTFCdUDGwLVgaE0k+Hq9uaADsQeMMdc7ZREIZF4vAHKQEiq/vBU5QWrxDh1k20QqgZ6v42m0YEjHblS5reGF1/bfdHFi85u7kGmwJlbeqT/iUra00ePrRMbKWBJORXebz5SwzIZPSvA0ZfIbsZJxqPTWKDEN3aPg+ZX41FdhiejCWz593jhD6C0Ecu3sMVtkwoYQpCXbf+zOMsMVGdp5GX7ZMZTneKKIH6hMm5sC76GnVlejWX4eqm+UiiSs5y3gUS2WDf6hnP6JfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CYXPR11MB8709.namprd11.prod.outlook.com (2603:10b6:930:dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 11:31:15 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.013; Wed, 13 Nov 2024
 11:31:15 +0000
Date: Wed, 13 Nov 2024 19:31:03 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Xin Li (Intel)" <xin@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<corbet@lwn.net>, <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<luto@kernel.org>, <peterz@infradead.org>, <andrew.cooper3@citrix.com>
Subject: Re: [PATCH v3 10/27] KVM: VMX: Set FRED MSR interception
Message-ID: <ZzSN90cBy2eIlu2u@intel.com>
References: <20241001050110.3643764-1-xin@zytor.com>
 <20241001050110.3643764-11-xin@zytor.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241001050110.3643764-11-xin@zytor.com>
X-ClientProxiedBy: SGBP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::35)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CYXPR11MB8709:EE_
X-MS-Office365-Filtering-Correlation-Id: aeecbb4e-707a-4878-4237-08dd03d6aed0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MkuEFR6dMkYzA8UbCuEgXcvgsPr8FmpgbZYvv67VIoM91yS0LK5j//JB2jP9?=
 =?us-ascii?Q?y6hnUKjZwSYKYaeOmicvNV8GuUPLGUHHnc00hQLbsnsG6I33k1yYs6HZ5a4q?=
 =?us-ascii?Q?TM6OSSnacroXKBNjiQB7z1MqpFuoEMfC6mZwknYfAsqO0Qdgup1nbxxOtbMU?=
 =?us-ascii?Q?OXvzSj2XMPpRndeICUJ2V7y7XX++aPvt1vUPV/E6rTzbgwGQF6Wo/VBWKkC+?=
 =?us-ascii?Q?pmaQn2RfaaEEsuG9Kqzx2bJrJ2vN2iWIG+Se1CQlsoCEhJZ7fwk+AAY5fdc7?=
 =?us-ascii?Q?538y3lERdvFqo9RV2CVLUafPl1H6bXBUQFaSczTvYvFkvtBRrn/get5pDAVS?=
 =?us-ascii?Q?+rfCAPAlKG1jKA3YvKBGlPZuTsO8t+tVxPTqjPLICZs2XnHckvn5CFMFrlud?=
 =?us-ascii?Q?S/TQjnTgTstE9DDxFF5wF4E3cnLnXYLYZ/csalnZJVj6vAjTj3GysUYWbNMU?=
 =?us-ascii?Q?cV+ctSWj5cOLRMuBAImjVfgbMKoYPl7ZfnLj5Qj3ssls9pcf2LjyOEnaoGAP?=
 =?us-ascii?Q?kV5r5ukDpT+wESr0JDJLTzyYJSjw9hjVj2kRtVz2WEoGmpCQvTxkD8XJHLW3?=
 =?us-ascii?Q?XTWQh5cV6k1tx7PS225iXaZu+Yujn+AeEpvnSb9W9WBV2QiOOsA0Gvvcvays?=
 =?us-ascii?Q?ltF8TRrUB0MjTHBPKuE3KqsbDkyeDYLbXYp2A6tYqBHHhqCTDgTrJuj0VUkf?=
 =?us-ascii?Q?m5eNV3W/ipguiK8HcxI9/l5vKTnk9M/8qOHp5iuUl+QExARtqmDbnzfEA86/?=
 =?us-ascii?Q?4J7Ks82AAUE8EN2aabSoGScyGQJ7wE5HlhgWnJsWErZCUKDhq/aSOkZeK+TW?=
 =?us-ascii?Q?h5fYfhsADsM5uc83yvH7sbZpE1E3dIloXL+JzByycad2SO44oSu4mybV0L4j?=
 =?us-ascii?Q?RK7L5b8GiG84LDRd9xGg/5s/tfuWzmn0ubygITDJz2OMqEIDKKuketZz1Uhl?=
 =?us-ascii?Q?wX6EYAJcG3sEOhLFaJDJBLkU23HJJPSM2yneLMD3v4JfMuvm40hqokHP0rJa?=
 =?us-ascii?Q?9pW4L7t3n8oe8l8XljSnOSkthFtXtea95V9OreE676uA04e9y5Dn/gqBlI8+?=
 =?us-ascii?Q?HEeXPN6/E2T2GzWYknunZIVU556wKabiVaniJSmZhifxkjSTYp703+oIjwW7?=
 =?us-ascii?Q?GzNQyhjKFMPS2/hnMHOVSWYrzmCoFRSymMYVBNUWRl02lqhDSFDP74TmYbRx?=
 =?us-ascii?Q?57Dovy/wUIw7giQnm5oJH+nSo8gyIsv4/KGPRMgNRiH/8xvLUlrPAk80ygTX?=
 =?us-ascii?Q?yn3aANdhCgH0hg8IMumZ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?p6OOfJVPTl+EZE2u9AyIvB+3q7k3e2ZCvHk0PWWxj0j4SOhEvXFY6D4ILMdT?=
 =?us-ascii?Q?RgrOYFl3rkHhHmF9iQHFztumD/gppJcd+3aVe1/wPm2TL7Gr5gB5gmpMz5jK?=
 =?us-ascii?Q?RULmZWY3Iy3SfgaiKkrWFO9+zoIQiyFjcBwvXCMSPp3g1y1UvSlbPq9de0VI?=
 =?us-ascii?Q?142/UNCcHCVjEA4dT0yxMEBX4gJiGZKe4zIT7AQfj21PGacGa1apW3W1v7U1?=
 =?us-ascii?Q?GIci3ZgkCECQ+zfTEHbV+hnXCGdG5dfP3Mh0rDmDDocJkGxiXpiZi1iH/f38?=
 =?us-ascii?Q?07ZoTJd/zVmJJFCS3Nq9LgcE8ee3SMG04VWVgWGNgTyh73qQ7ccFHZgjM8Sm?=
 =?us-ascii?Q?Jj93AB/vM3r+Qpt0MOSGPbLBUb6JOjXd2unmq1ADbrz/n2Z25AL+LC7tcuk8?=
 =?us-ascii?Q?aA0jU7Zg64039Ix/dS93Hf/1ZDduuIjXgaYowswNbr/ZItyZHcb6eQ7FG4sD?=
 =?us-ascii?Q?DTY9u1OdD7glYqsY52xfgMNkLFg7Xom8q7x5KkykiLzLBLQPvLiEqN+SSGLW?=
 =?us-ascii?Q?zE8GmJomJ0Huv1WKMs6eJaZwQA8z2haRDogkvfyBZpnc3cksuFHioM1/wwSS?=
 =?us-ascii?Q?zLVYgeMu+Wv19J4tl/wVChVb92MoAmNxeV5PDF036ab9QCelEEu8Lnl8bLGQ?=
 =?us-ascii?Q?oZsefN6uBMzfJsFHmr0GuQTgkpa+3JUZc1m8SW0RuokNCvontOiQwDQ32Wc2?=
 =?us-ascii?Q?1rsIrSCEQwTkFkc0WiLjh+gK5Tp868pVUVH4a+3xP+2qQtifQN/62JoZywGX?=
 =?us-ascii?Q?mrZc1rngYGaJt18jl6aDk5nj727zcIhMfKcRgMtCBWnBMZAeLHSAv3OUeMzr?=
 =?us-ascii?Q?1KHagp8Xn+aLI03x6XzZQ8OeNFGmBkXQCzWayd4sUeMw0pg/4zZG/qitslTp?=
 =?us-ascii?Q?YvTKQwNC/kVxNDye+Y7fx6BjdsfKnJ4arE+1HMYAqIFXPsH16d7UIox67m9K?=
 =?us-ascii?Q?b7HCjipWpulkaF8gHL6BQk7e2UE9Y0pTJvZgceZfNxWTEUWyVEoEUsYLc28K?=
 =?us-ascii?Q?YZsYg0LgWGPoQwcT8EAe1tJj7dqxnuaI1ij9q7C+L6UoLVw1huSSn6Ce/VJQ?=
 =?us-ascii?Q?/eRfvzw2/j1gYWIgcBeke0hBCAwfYeaKEPQjtq58O+xUlpq1CklwQeGrD+TL?=
 =?us-ascii?Q?6ksxlxSwGPl26gBJbChyAG2/5JfKc6XZjjp9kttUvI1YOa+TwLjqn876kZmQ?=
 =?us-ascii?Q?TXELMMEgylbm1O77Lx5G5fWFnzEgKM2NsWgbojRFInzT2U01hpf9DVcXh/Tn?=
 =?us-ascii?Q?uEYVnvUDp6nMFAFTu4aT/DZMLiHojLDicQgP2PdrSJEHEl4ppyztTi55O2W9?=
 =?us-ascii?Q?nMWyuKBwTaU4TyDVwVaThDaZBF5graqW69owxwY2m2Nt8+uCkCoFV8iu/XeL?=
 =?us-ascii?Q?MF5AaGCV5czC/f/F5tWajRn9B5DRCTKvsInBMfthNAbnIm8QbB0XufLrrCwP?=
 =?us-ascii?Q?F/QANhG+Shfg8A5PX+rTEpGPOnhp64wBbAp3yijFrrDK+rvyrUkq9Fagaj8q?=
 =?us-ascii?Q?D3x9WanOBd6sp0OdlsakIUm1ubZ1ck6MIOJ8Md+qvF5k/CMUMZUVt7ajPgHW?=
 =?us-ascii?Q?cRHQdaIQ6hoyDhTiEgmpFnTw//Y8EImWt37/3uDm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aeecbb4e-707a-4878-4237-08dd03d6aed0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:31:15.1116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PvI+UFvLoEaGwyrXfmJJK2Qd82FGAQuwRBDPWJ9fWyYpJQ0hraeqbIukySUbpuX/Lu0bzYZT/8R9lhgVhEd8/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8709
X-OriginatorOrg: intel.com

On Mon, Sep 30, 2024 at 10:00:53PM -0700, Xin Li (Intel) wrote:
>From: Xin Li <xin3.li@intel.com>
>
>Add FRED MSRs to the VMX passthrough MSR list and set FRED MSRs
>interception.
>
>8 FRED MSRs, i.e., MSR_IA32_FRED_RSP[123], MSR_IA32_FRED_STKLVLS,
>MSR_IA32_FRED_SSP[123] and MSR_IA32_FRED_CONFIG, are all safe to be
>passthrough, because they all have a pair of corresponding host and
>guest VMCS fields.
>
>Both MSR_IA32_FRED_RSP0 and MSR_IA32_FRED_SSP0 are dedicated for user
>level event delivery only, IOW they are NOT used in any kernel event
>delivery and the execution of ERETS.  Thus KVM can run safely with
>guest values in the 2 MSRs.  As a result, save and restore of their
>guest values are postponed until vCPU context switching and their host
>values are restored on returning to userspace.
>
>Save/restore of MSR_IA32_FRED_RSP0 is done in the next patch.
>
>Note, as MSR_IA32_FRED_SSP0 is an alias of MSR_IA32_PL0_SSP, its save
>and restore is done through the CET supervisor context management.

But CET may be not supported by either the host or the guest. How will
MSR_IA32_FRED_SSP0 be switched in this case? I think that's part of the reason
why Sean suggested [*] intercepting the MSR when CET isn't exposed to the
guest.

[*]: https://lore.kernel.org/kvm/ZvQaNRhrsSJTYji3@google.com/#t

>
>Signed-off-by: Xin Li <xin3.li@intel.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Tested-by: Shan Kang <shan.kang@intel.com>
>---
> arch/x86/kvm/vmx/vmx.c | 34 ++++++++++++++++++++++++++++++++++
> 1 file changed, 34 insertions(+)
>
>diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>index 28cf89c97bda..c10c955722a3 100644
>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -176,6 +176,16 @@ static u32 vmx_possible_passthrough_msrs[] = {
> 	MSR_FS_BASE,
> 	MSR_GS_BASE,
> 	MSR_KERNEL_GS_BASE,
>+	MSR_IA32_FRED_RSP0,
>+	MSR_IA32_FRED_RSP1,
>+	MSR_IA32_FRED_RSP2,
>+	MSR_IA32_FRED_RSP3,
>+	MSR_IA32_FRED_STKLVLS,
>+	MSR_IA32_FRED_SSP1,
>+	MSR_IA32_FRED_SSP2,
>+	MSR_IA32_FRED_SSP3,
>+	MSR_IA32_FRED_CONFIG,
>+	MSR_IA32_FRED_SSP0,		/* Should be added through CET */
> 	MSR_IA32_XFD,
> 	MSR_IA32_XFD_ERR,
> #endif
>@@ -7880,6 +7890,28 @@ static void update_intel_pt_cfg(struct kvm_vcpu *vcpu)
> 		vmx->pt_desc.ctl_bitmask &= ~(0xfULL << (32 + i * 4));
> }
> 
>+static void vmx_set_intercept_for_fred_msr(struct kvm_vcpu *vcpu)
>+{
>+	bool flag = !guest_can_use(vcpu, X86_FEATURE_FRED);
>+
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP0, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP1, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP2, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_RSP3, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_STKLVLS, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP1, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP2, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP3, MSR_TYPE_RW, flag);
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_CONFIG, MSR_TYPE_RW, flag);
>+
>+	/*
>+	 * flag = !(CET.SUPERVISOR_SHADOW_STACK || FRED)
>+	 *
>+	 * A possible optimization is to intercept SSPs when FRED && !CET.SUPERVISOR_SHADOW_STACK.
>+	 */
>+	vmx_set_intercept_for_msr(vcpu, MSR_IA32_FRED_SSP0, MSR_TYPE_RW, flag);

To implement the "optimization", you can simply remove this line. Then the CET
series will take care of the interception of this MSR. And please leave a
comment here to explain why this MSR is treated differently from other FRED
MSRs.

