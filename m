Return-Path: <kvm+bounces-27650-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0C398948D
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 11:32:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B45011F23EED
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 09:32:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB67144D21;
	Sun, 29 Sep 2024 09:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ceu+U2sX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D36818641;
	Sun, 29 Sep 2024 09:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727602363; cv=fail; b=aMHq4H5xx6XiYZzuFjoeT+fBWNA429Zf15MvFWuK/r2OY1zIfaufo4NQvqq1n0tcmRcnt4xp2EumCEL+w0T/gqGs3Uz7nVqgDjTfpBdSCVwJTqjdcL1ZbcgxCn//JwTfBW+tEhOlz84VGcUVoz+8ppr1Onwa+oxpT/C27kQV8do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727602363; c=relaxed/simple;
	bh=JEirsZtZNyzaeElvOuHFXZyvxSsOGOxF+bz92L7jrpQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NR0oCm4w2bVz0edyjvUMlaQ8BBScgPvwiSpTWVjEg+t2tlJfnCdgEObX20L5TMgNXHM3bJO/Mc4SrB2S08Pb5EmbWJ1l2eqJ0ybP2sHemV8kteYUepexvGx8WwzaJM/kk7PBEtKVxvxShUFwu9wI2Oj2v5zvLE3BI70IK3jMgyw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ceu+U2sX; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727602361; x=1759138361;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=JEirsZtZNyzaeElvOuHFXZyvxSsOGOxF+bz92L7jrpQ=;
  b=ceu+U2sXlixDsjNS/NW6/sWbYOJflXUWgcz1jgiqhnibbGuLDzN0l1Uf
   WeTcLQRW4hqRlroRs0Z1po2PZ46vaTh5zrQYUNNwNo4sV+dQLCH9QrU43
   i35nDUlabYHXlW97Gf4Kc1oDR32IO3KJmKnj5lWMqRL/T7OHtyuYBhwqh
   0nc540/AOOhZssQsseuqyT44siGfIFsKJ6TCbO0YcNANhc1zTlnKyzNIH
   8P4NKMml2JlitUeev/+ZtnVDAjmzI6MgS9+8aXCvY5KL4MwWBR6x7gUlv
   qjdvH1NoOAOpSFYiwUVoK2vsJCPgGqqTOyQqvMpqIkyIxxjq1qMXNlgIK
   Q==;
X-CSE-ConnectionGUID: TDV8CYFlTJ+IxCxd/Pw/Dg==
X-CSE-MsgGUID: TRBVH/hyS9yh4eDENr4lwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11209"; a="37267162"
X-IronPort-AV: E=Sophos;i="6.11,162,1725346800"; 
   d="scan'208";a="37267162"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2024 02:32:39 -0700
X-CSE-ConnectionGUID: wLNZRrANTsCzM/n+EX9HyA==
X-CSE-MsgGUID: 0X2vVkQbR3+m4oZRhEPNsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,162,1725346800"; 
   d="scan'208";a="73051162"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Sep 2024 02:32:05 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 02:32:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 29 Sep 2024 02:32:04 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 29 Sep 2024 02:32:04 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 29 Sep 2024 02:32:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DbaHI0QA1IWpoBNbr54B7zmvHHUXEJfwRTk1QePEuo0mbU0UlpN2ccEwDtb0CoKMTtdH99Os3OFB/74rwH8LxyN1x2ak3+uVfTC+lf+vif56gW6QrcWE3z4iw8rw3oa0XiRRLLdOOPUYd59nY9RKf5QFA3KDVEHERahg51bkluH3LYwY60X5zUDOcndQyGu15oMqlNrk09Fy/l2PEuXm+wg45a/hd8uZp6qFB6/CYBpSBq2V83ysQSBEfjwybJQk3dEXq32pUmokbyBU+F0RiZWL66JnsIQMMKDpEkhb2Jf+KKbH5uHLQQw5scio+OjBab5DTfL3RmlkliSPNdLyTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nTJ6vL14B+fsuf+zU4ugLt8gBDgauM0Pn0HNMIwwcn0=;
 b=tkX7QgoOl81QSTMHQO8nTXB1t61I8y5ZXq72IcyFww+2gaTSwsWEhgVrOuwEYixNQPgBwfH+q92yuBux556JiIDK/9SAzQdxveOIzvVYWWL8DLowT/C9KLFSP2KcJgG9knJsWF0uZPucbzCbEIWWtwpM7JwrWRuiyaLCx7u4TMYjGWHP1rpzN23ivgRh0vavXE3lNUM7am1VSANU5HLLnWVyrInZlJFXGlnYLFe2V9lJ63MGiUbYAQKJiTqHVCCtRaCzqTk6PonYXYM4TRP0yvC/obC9tOpQMHLdWpuwPSDHr1AyE7bTEiCS9P81XjuZRsygcIjdrIXGg2P92nAjIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7578.namprd11.prod.outlook.com (2603:10b6:8:141::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8005.24; Sun, 29 Sep 2024 09:32:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8005.024; Sun, 29 Sep 2024
 09:32:02 +0000
Date: Sun, 29 Sep 2024 17:29:54 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<sagis@google.com>, <chao.gao@intel.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZvkeEtBk8BvR4Hms@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
 <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zva4aORxE9ljlMNe@google.com>
X-ClientProxiedBy: SG2PR02CA0100.apcprd02.prod.outlook.com
 (2603:1096:4:92::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7578:EE_
X-MS-Office365-Filtering-Correlation-Id: f40a90eb-0965-479e-3eca-08dce06992db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?h8XanZc8FnXVFbAtxrsLv4fMSuvHNqrkYb6kXCH6MDhfWc9Sh5MlVkRhWQER?=
 =?us-ascii?Q?JGt8NxT8loREAemqSDMAn93wj5xGZCdaa3R/9DkRxLW33M4eMJPieiGy7Gpu?=
 =?us-ascii?Q?pHuiTpkPj3IMiZlXNyECQjlnixETDtO2pi/XbzUVLaOrWngG7p9Iek/7CjYQ?=
 =?us-ascii?Q?eu7we5OcG4EssWmu14FaeoEbFDnmYK+0SsSjQeaIgnwyyvJejtYItAVwpz4F?=
 =?us-ascii?Q?zC5ZS/ejr7KrEiRjmMP1bL/XCxDsB9HHf9RpKAR4M8RpelaCGc2SNaAIYMtz?=
 =?us-ascii?Q?iO+4Y2G7G2Uha3KQb13Makr2T8dFJI9c5N7c9zNU6dOo+On7U7sr2RAgNncf?=
 =?us-ascii?Q?VuwAM8rqn9f/19mnhEnPAjJfUjwU811sdz6qsxBH7PRNfT7LpOjker7ZwE8B?=
 =?us-ascii?Q?JnGpPp1PirCHJh99eB1mID3YGQ8OvhdagGjBHFtw3wu+HpLDBIJMsAztD7tY?=
 =?us-ascii?Q?g/fene/eVhTrR2stLL+j/89GXNJFfHn59HxwjSJQCo3KSORaLPKPzaDZjvPP?=
 =?us-ascii?Q?CHQS0nQ0kuRr8gxkJkS21blgYLVsVMX4u7KitinU7meUfKrIQOYNho3kwbFq?=
 =?us-ascii?Q?efyaM9XrHoxD0Vr5DkkMRSmYSszSshOVYQHJnCCxne3cpVTWWFi6YqOAQXX1?=
 =?us-ascii?Q?dc6Fe71tJc91udr9H7OB6DvLEG2+iNtHJdlhognVbYSEu2EYf2pKzWxKC19f?=
 =?us-ascii?Q?5krQ5QWq0kBZY3XgjzyL1BHjGmGtnvYzYy9lBNDpd8NK2IGYMvZVaow8D24Y?=
 =?us-ascii?Q?AYg8PUBk4lVXWRvW9pwW+eK6BU7vtXClo5U5OrvxVv5wGJaBu3pidRasRRoB?=
 =?us-ascii?Q?5p79BGMgR799B0/4ICjMIfm5zrk5YOKT6rEOAt3ooHbXic6skTdwgn3vtoLs?=
 =?us-ascii?Q?AhHEVGCDbiUBqv4zfQW3bzWlv7JsfrawTAZNdhbwbMDuUyicWDN8a1EGBShI?=
 =?us-ascii?Q?1Xbzg1nqfTxLV2QZHTIvFyWGehD5KJK4Poz3FVIsQwHZRjmsLGG0lOK+H8i7?=
 =?us-ascii?Q?jvY1emcoEWSZz/emlQnhTMpjE4bkusUqmRckJ4mD1PEQbs3nLmEUcLmewp+z?=
 =?us-ascii?Q?Y1tSgcdXbCZxjjUXzXooC+iMyZsQGX94sOk4QjJpTmLSkLL5ZtU8SvK5f61h?=
 =?us-ascii?Q?U/p9MzQvgta4XSgjH1JwlSdd/C33cPuR4ZZc7495px6HD2VLGP1VTano7c6H?=
 =?us-ascii?Q?m637f3nB0+hbHlcllbT+VJWTTaxtfQpdEGdWwl7PFZ/jU0muNbZ6Ex2zDJRe?=
 =?us-ascii?Q?GYKHJLd4quEr+XS5jL9cCCY/IC24AA8Sir8jJUYHXvGmdjsBg24DwdM1KEm+?=
 =?us-ascii?Q?yzIBWipsQnS6U2EegU1eAgJnyXJ5+lRWrEzzf54iRgYqhw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gHKslOkqDxGl8r5dgdg7f0YQhJOZUCXKHGuR9gV2eawlleQSdvrSuRWugtx0?=
 =?us-ascii?Q?U0DnHVURxJgB27r04B6e2hzYtuRnpwMiLhFVBCkjX4ycouDJi807iY4ySmSW?=
 =?us-ascii?Q?qWgYjkG7ZL7Q5uKFCx5DId868FhGILY6T+xK4Oi4FY8QeSKO5vqT0FsjIozJ?=
 =?us-ascii?Q?81POtJTLZG9w4kE2uewf/ljZQAjdIH3n3IE6on491Xi2P3lsMMmz+ShmNdKB?=
 =?us-ascii?Q?jdDVtWHDZLoF76MrWfYYISyKLk7QTG6sEdJsdyqTWfYIxfHDwkQzYAa6FtS7?=
 =?us-ascii?Q?7WBrReH8eEK7VUV5znufg/LS+pOAuQaEeAR2+oa+O8E6w195uRSRQvRqqrXY?=
 =?us-ascii?Q?kVEwjPEZmB30CHcz3BkaWSt1dVxpbmTTeJMJJsxkbfAggyZMA5kqox0cPbqK?=
 =?us-ascii?Q?/KlLEpnHBT2a6V5BEQ8NQzm4A0n1PCta6RpnDnU5iu2qkN9fNE5SpuM/MdEq?=
 =?us-ascii?Q?O06O0/WoYAYFsloLf4OLQatZv59Df8q1EgdYOeKcCjs+iVZpwf/khGPHghNm?=
 =?us-ascii?Q?T7k0gn6D+pbmbhIp5YQKrGMCAUIQDw0PaRjOordhec8BH2+CNA+9Pg1i/6Ze?=
 =?us-ascii?Q?opmZYW+WiC/T8NSUAF2om3hWePn5qFI/8i5xxAcoHldLD80jClDkVMEwJGzZ?=
 =?us-ascii?Q?9/8Y2KIt/FeVzRaPLtCPit/MGR6HWV/2G3HjEE0Wji+ESsNT+YeFRYrlaX0U?=
 =?us-ascii?Q?SAmqacpheBn4hjkqiyFd1+4beNQY4S7dA+RykUJFbEa3M1ile4pFdGqh8ozY?=
 =?us-ascii?Q?K0hqgzJzrlAgt/juLGpkL3ojqVB37jAx/6CdxkFNqr578xXg3iCt9Rl67cFW?=
 =?us-ascii?Q?K86bqAT1No1TkKq/ANbO5NhfJcQzw00GU8hYOkoiCxolr8timsDAZL3vd3zB?=
 =?us-ascii?Q?2GpAVJMdRsefqFPG8ih1SMzHrLLxZh40ginSx16TpsSrOoxLgKDaeSO/EB9R?=
 =?us-ascii?Q?1aKW1TiLfInINH55ZrE4psyzC25qp+rFSTlM2z1mJWe+sqCPUZ4OcNkJs73a?=
 =?us-ascii?Q?DRmPyqMpFMgR/IAtgP550O3UYgN0e0TRW+Zz9SYyb4DD52IONVUv2hMiJx7s?=
 =?us-ascii?Q?BORcA25taCL+L1fE4wBIbW6WdG5TWzSEW0SpJiNvlkyd0V9eiYTwHLhK8xwX?=
 =?us-ascii?Q?1q5yMyZJ/M326WR8upJ1fgcG98BonJgK2iC4VGQhBXefCcZD3iFGSijWAleG?=
 =?us-ascii?Q?V9UCdVIrabRrl6A9h/TRb2PDkNzxfh/juL+8XflsKC+VnnTBfUD2GvfcSls0?=
 =?us-ascii?Q?g22bgQIx61YF1W/O8ZFFW3ZrZZRzBKbxdwnLugk28MCIWf2kpe0Xo+b33mg0?=
 =?us-ascii?Q?K183hGald94wWAuKCG8kTCBKBC6rGcuP2dF8Dx/+XzDdlcogx9J2lfZPNXXY?=
 =?us-ascii?Q?WEgEGGTUvEE8lFr8dJiYD6y0KmygwsNwTxCADknjhTgPdthlIVfq7G6OPCB+?=
 =?us-ascii?Q?22nCiKwwBJHhIpid6uJ69cqhOKF3cs3kCjwIasTEW/bidxi/hu0EqQrixNZ0?=
 =?us-ascii?Q?cwDGGzjKTCr3oomfHsqtU1q8Yw62ci0gjuUovpnccyErV61rTP+4qm+K7iCs?=
 =?us-ascii?Q?5eT5pMPlQQ4GXCcR+eTB8lmKIfgozyk8nW3qxLob?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f40a90eb-0965-479e-3eca-08dce06992db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2024 09:32:02.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mDtTSzYLJUyVX1rCvfnDj6nl+koVf5jd1iagqCdi7TTsxIAn7p2fe9UpADiUJ2hQaOJQL+teFRfmzi+0/w6RZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7578
X-OriginatorOrg: intel.com

On Fri, Sep 27, 2024 at 06:51:58AM -0700, Sean Christopherson wrote:
> On Thu, Sep 26, 2024, Yan Zhao wrote:
> > On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> > > > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > > > index a72f0e3bde17..1726f8ec5a50 100644
> > > > --- a/arch/x86/kvm/mmu/spte.h
> > > > +++ b/arch/x86/kvm/mmu/spte.h
> > > > @@ -214,6 +214,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> > > >   */
> > > >  #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> > > >  
> > > > +#define EXTERNAL_SPTE_IGNORE_CHANGE_MASK		\
> > > > +	(shadow_acc_track_mask |			\
> > > > +	 (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<		\
> > > > +	  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) |		\
> > > 
> > > Just make TDX require A/D bits, there's no reason to care about access tracking.
> > If KVM_PRE_FAULT_MEMORY is allowed for TDX and if
> > cpu_has_vmx_ept_ad_bits() is false in TDX's hardware (not sure if it's possible),
> 
> Make it a requirement in KVM that TDX hardware supports A/D bits and that KVM's
> module param is enabled.  EPT A/D bits have been supported in all CPUs since
> Haswell, I don't expect them to ever go away.
Got it!

> 
> > access tracking bit is possbile to be changed, as in below scenario:
> > 
> > 1. KVM_PRE_FAULT_MEMORY ioctl calls kvm_arch_vcpu_pre_fault_memory() to map
> >    a GFN, and make_spte() will call mark_spte_for_access_track() to
> >    remove shadow_acc_track_mask (i.e. RWX bits) and move R+X left to
> >    SHADOW_ACC_TRACK_SAVED_BITS_SHIFT.
> > 2. If a concurrent page fault occurs on the same GFN on another vCPU, then
> >    make_spte() in that vCPU will not see prefetch and the new_spte is
> >    with RWX bits and with no bits set in SHADOW_ACC_TRACK_SAVED_MASK.
> 
> This should be fixed by the mega-series.  I'll make sure to Cc you on that series.
Thanks!

> Thanks much for the input and feedback!
:)

