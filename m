Return-Path: <kvm+bounces-18018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A1AC78CCBEE
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 08:00:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E50C1F21F62
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 06:00:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD93D13B2B1;
	Thu, 23 May 2024 06:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ijN1htxF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB86BB39;
	Thu, 23 May 2024 06:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716444003; cv=fail; b=YXEHMPTIwjNzeJ/YGq3AK5gk0P2HEyJK66lOcX1+F7qY/5PdY1Ayuy+rgpMy9UEmMQ2wERWaTiYXy7/a+xRR8qPYWQ8FerFJKgp9IsEiGJ8HQusUpQyKhCOl7NCSn3unzShKZ/prnxDdyWJeLYF/C6ZpdnuZHb8VjlkeF/SiHPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716444003; c=relaxed/simple;
	bh=0JZj/j7elz4dcKz/5uFsbF5+2g7GV7hb8Aeg8n759b8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bouBbso4TcOZg0mz8piNaE5oelnxcfX8KtBt3jrJ37blXcS7+BevKYZDfU6QfSiNrQxmUoq8sPEpvXeIM7WZzOBzROsfeaCmBpbKS65A75efdGc+ubEowWJGZrXZflED0eDLFu79ahd4JIRFbMPKUqUIzSIAKACrUXEtBiIJM5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ijN1htxF; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716444002; x=1747980002;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0JZj/j7elz4dcKz/5uFsbF5+2g7GV7hb8Aeg8n759b8=;
  b=ijN1htxFrbnSJ3oL9yODRM6i2+I6EubdVQwBrPh/zN7a6P615CxPDBAS
   8cu1lqjkYQo0eqzmWIuYVdNYVGdgl35TzRU+f3FlqfYkUQKKrcMQ2LCtb
   IINTtEGHEaJrtG5cnTAvFt08ZrbvP39kwBKM1VCRuoLUuNjdmLhrQUoNb
   PztlOAGtJ5p1XZ/Mo/oG97TPQqJpA5j/0TAayojVVWTjk/t7FMrLe8rGa
   tA6PgZJuC2Tqi12Hoa2pAzWwut65jfwgSmovJng3EZvXT/p1uq6eE7fnt
   Kcg1serFvA36d+rwbgbeY0oMQyoT0lAKV8Eu6SIQrtt/z3APZH05A1aKC
   Q==;
X-CSE-ConnectionGUID: 3i+8oBmJRxy9R2Xeu3f/Dw==
X-CSE-MsgGUID: miZBK82nQz+PgsxfrocpOQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11080"; a="12672171"
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="12672171"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2024 23:00:01 -0700
X-CSE-ConnectionGUID: /szJqDvgRPuKHHYD60dK8w==
X-CSE-MsgGUID: mTlTrl4fS6eVgyJkYpZWqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,181,1712646000"; 
   d="scan'208";a="56791120"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 May 2024 23:00:01 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 23:00:00 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 22 May 2024 23:00:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 22 May 2024 23:00:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 22 May 2024 22:59:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=atp51adWeJGzHGWCP2ETD7OJwxtcNaN/Fqyynl2KjB6D8NMr9AWpmQa19tk2KBwB3VVauYBaZZFDZzLvpmPBYvUIaUCbHreFLqC1y5wCVE3SrTO6jSMbgprrD1NI8C0gUjlnCna2vI6NdUMtYglVakgZ3bLum7U1VqedyG8ib2D/chhrRTmc/Efgvy5l7t4Uh06uANj9UhklHkksmrh35g/jc6XXA9ujv1RQxFUgYDCtKxZkrmlhxgiZjw1Bqq6Mmbm2kinNKNwR2mVwksKQQxGD63zFMhEG5EyX0jRIbSPZrNJwpu8SzCKnbuC1492I8eV8BSRD4W6y1aza8Tz4Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXtF4H8qyFKjkbwVmykNHNFJ9io6BAqS+6zvVUPXAt4=;
 b=RbNojtoWnhAyI5xyJS2I1QqGphw3H4wCMSTjIyuleBfAl5FQWYmQkG0YFFaDDkJRr9yoOpA9jUpFT7sIZOMJzMxPJOlQ5Hr4abhubnbPUsRAQwgksTSfOnRjnEBWoR++QpJnIC2kqJVUagG+NQQBe13CNWITaewLd/RR2ShWN4k1tlLzW5Jg0lKLj8MBME4S/MUW0qD4j6IBK0eJMc5oSNOWPwHIVVPAyvxZ78jJDHqRLkdS5G7NbW9LmKHUutlHv/8Qjfa0Mt6CrR4xXCIQeQocH2CUSpGZR/tWBerHSUOT1qjp/MDgPqhBD/0dCGrfuUyEUt75rFh1OPC3Lhl44w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB7342.namprd11.prod.outlook.com (2603:10b6:208:425::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.20; Thu, 23 May
 2024 05:59:57 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 05:59:57 +0000
Date: Thu, 23 May 2024 13:59:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2 6/6] KVM: x86: Register "emergency disable" callbacks
 when virt is enabled
Message-ID: <Zk7bVYh0iJkX/GYs@chao-email>
References: <20240522022827.1690416-1-seanjc@google.com>
 <20240522022827.1690416-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522022827.1690416-7-seanjc@google.com>
X-ClientProxiedBy: SI2P153CA0033.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB7342:EE_
X-MS-Office365-Filtering-Correlation-Id: f4eec9ee-56cc-4d92-4620-08dc7aed9311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zKCcc3/9f6Dcv3Oiy/mUlW7sQcQJwbtebhL7kEO+ovBWAvvmNMAC1DmdNGjH?=
 =?us-ascii?Q?TBi5sc3FBTrJk6TNP9HE/w6rcZ07Vts852RNcqNxGzfN7MJe6Rp6k2QtjBRt?=
 =?us-ascii?Q?GkBiWTpXmLFAEgl4lLHAcGZPr753J0kzcjcNgHMS+JmxDqtZ4SUZRPSxiJVC?=
 =?us-ascii?Q?h8wWhPl7IQgKyWwvi4n/3EHOeNZScV+I0e8mnhnNZ3jVzZfAwTOSDJQ1wLK5?=
 =?us-ascii?Q?73Iq0PdIlYJ+tWaUuhX1nvuTFXAzt22F/t8Rj7n2OwSB4VbhEUZ4wyKsPFXh?=
 =?us-ascii?Q?AFUWmDPaaS5hPvnm3Lku/zKBDkog6PQaJ64Qkn0ZKK32zL6kGs0lTCyK3FkU?=
 =?us-ascii?Q?GvNztxbxZrWkzDuy9Lu3zLt0bToxm2PbdSHVGYjvk4/TULsVQm4LBcn45yxD?=
 =?us-ascii?Q?tOUnQ78IzrlaOwBBm6nFHaH/vhK72nVNxjKUAHtGQbh5nC34YdfiwC++xeIa?=
 =?us-ascii?Q?9FM0iiR99TVuJgkxEZj+TPlZat6yU3vEOppjO9rhrIIOLVxroSLyjRz9Jb4e?=
 =?us-ascii?Q?FcjU4mNyFAgPcBXt4YWaHh1NxybkXmuj94dwCRtvUKk+R0n9/mTVpIVlQM+B?=
 =?us-ascii?Q?txJ3W986F7CIBEUjn3KhTXH5h4NLAtG5kviJvxEGIRp7H+xOx0epTer+C4RN?=
 =?us-ascii?Q?ZH2nwG2133QxvM+vMN51shD8rPA5Mgw1fyc9pIIB6c8xqKoJaA+yj2EP3cYy?=
 =?us-ascii?Q?GmfpGvmvYjnnABKv0HW8ETjDJfNXPDu3zC2ymLKyDwQinWrZRJ0FfqN7Xscn?=
 =?us-ascii?Q?GzuxwzCtbYiLBeriAG5goU2QpycfC63Z4Zi7YC9IS4mDF6hkemdxTfULeeRq?=
 =?us-ascii?Q?kqDe5E2TCNwpe6dA19iu5dERQ11HcNm3e2iOKo9Ts/F4lo1OrvPUfTCFtEzY?=
 =?us-ascii?Q?Ix4Gg3HprGOrTJV3xA2oHkj1Xvq/pK5ETWA1Lw2ZF+h+71lRNciKInbZNrL3?=
 =?us-ascii?Q?uc7jwfLraiDOpX4eBHNTT1u0zc+pSx3KdBCLOxhG2dT74qpLHxHXx8i5ZqcC?=
 =?us-ascii?Q?+GsSV8Id6m+aVatTFVwTlyAXKhs2sUoazcPe/Xo6ua4i90MNEaJpxMyiEcAg?=
 =?us-ascii?Q?9uQxYr0EpzdClzmPrdRfwt5Pze2Ck6zsGdjKAqfB3NSTY52rsqrFPfVxbzRl?=
 =?us-ascii?Q?0pHNQK/zcpEbKCYYt83wveglAQ1rN9VcjshPvnl0i9tTzDtL+qqWlSanVfBi?=
 =?us-ascii?Q?HmxPL2B7V8h/lp+Bd1XpUqkIrmpxQl6cKXexwjSUTNm5CAswIpPOHg+K9U6G?=
 =?us-ascii?Q?NQX2fDljnbotWhNi1Ftpo4MTwOOm8qd367JPIlGRRQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rpYfzyI7Z6b8ziRxFUkBgDV4jCl5Fio0PE9hvImlsowFRMcN/qCFwyrLHVmD?=
 =?us-ascii?Q?1Sr0AjgkMuXWTWINjk5kluyFqglhjC1saSJbBmS90ZsmWmCFVUTkz3/yc+Z4?=
 =?us-ascii?Q?1ZP7ertDP4uuXKA6ZJ6Ev1LnR76n7NLD7EQMO4r3Pmz0qvLW54ZyfbZeFiku?=
 =?us-ascii?Q?sGaFIEN7bU9xUfuuD/3wgzYpcVG+Dw+L46Xk/7wD/Q5jvnIuHiRlaH5nA61i?=
 =?us-ascii?Q?ip/1Zj/nu8Pa4InP7SYETFMg1iTc/ZHlEsYuLWDNUO4R0KBf0LwTlqHmKU/6?=
 =?us-ascii?Q?+KDOlCfNTBw/pIB+7F4UgC7uK34EYQt0pL5qxhtZmD7gNEwycL4j3K8fHDb4?=
 =?us-ascii?Q?/CMM1rZ4Go3QZqo4646r8CfSUceg+mk/Trcr0a0sORW5XV+EQnl2TxDwCeUA?=
 =?us-ascii?Q?X/zIObwj9iA6HMNNDlbTUwnIH8W4wU8LsMwTC5ZRRkhvYrLhGeS25kYTCu93?=
 =?us-ascii?Q?yEIgvnEWyTgNyFabttGOPUvlSh2jGIl3o49O81q/AXd6KQK/eKoNyio9mNBr?=
 =?us-ascii?Q?wcitYySdBaB+/A068FgGEB67CA/mx4Ec77UdikjkNcuaORSe3wplc51LqJgW?=
 =?us-ascii?Q?yyZhZAe722gT0xZ/duRbD03RT6xGVJf+8DIhYrqGwUJtfjQnPwvKjGkEpcB0?=
 =?us-ascii?Q?BNEEXOr2Q9BuWJ5NgW6UCPy+yHFSwuvVzr/x+HhSza8y3p42nvRJ59+kFdE3?=
 =?us-ascii?Q?97rX2rBImP+sTc8iF+LKxts8m4DIQ/DvMUdwy9ggPiXCywyAZPHQFfOSL6lk?=
 =?us-ascii?Q?YafY4Ofpi55Kn0KaBTHSKRimUYT5GITVlweLU+TAzaKeOojxSuRQMP/FIsaq?=
 =?us-ascii?Q?3+QpfZ/r/0j1Hs2YBW5bmhW+Pem+51DuyrVAgWywqYvfGQ5DAvkVIVZJBn9+?=
 =?us-ascii?Q?b7Wu05Nk+FQGmp1oHYqkKGwiE5GtyN1jMZ9nHmiMDw2YuIklzTce46U5IWr6?=
 =?us-ascii?Q?gTopW1KN5efiRPwvkCfZ4nJ7+B0mLD4s4RDNhka6c42cDZ3SndjfwDwJfga7?=
 =?us-ascii?Q?A8QRiilymggKeTRVF7WD8O9LObTbdIdvWhBgoFwsEjLgLOAbktwZKMnQXK8/?=
 =?us-ascii?Q?SbAh2OIG3mY+VERNxG+jdmT6bfYVFHMduO6oMslo8/L/wIegNct3ES3PHBHk?=
 =?us-ascii?Q?mEEpTa3G+3KfhElsyG7GejdzlWn/iqFK/N/liMM8C1rXuWBIlU8QWHja2fAI?=
 =?us-ascii?Q?YES5CEnMG25JZv4oQBM5nolmJtYysg4DtAXNh2ncZ+A0vWJe6hiM+pbFUNRL?=
 =?us-ascii?Q?iAsFuDDSvGywAmbCaKjebq/4GM2HFVJhSlQJE0UyIvr4wq+JPr/YrXoMsKfg?=
 =?us-ascii?Q?oe81X9yr8oQ3rAR/DU9gN1M/UUauAUfeZ5Zn+m64vbACsLycopmJW0gvURCM?=
 =?us-ascii?Q?FU3IhLK5f6dTFMFNNqWPmYra58QnaU4ARPCo8usvva4AVb8GFtLe+9+uYhuQ?=
 =?us-ascii?Q?+kwTyLrVXLwHNW3rHn1xW1dhB3NsxKl+FXD27oOzx/3n3Tm2Sr5YEnEsUBsB?=
 =?us-ascii?Q?j2sNVXkPOAaK6z+JAYKO+Ih/oCXZxRn99hnDbfQ2IpI1J1ZOEr3TXCpz4e3x?=
 =?us-ascii?Q?0zYkb6Zc+wHQ6tyQMvD0dVXAuJ5iraoDgfaPRA9J?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f4eec9ee-56cc-4d92-4620-08dc7aed9311
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 05:59:57.3934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Da6r5BHH8sWMzs4rWYQ2vwB1xDH8XjxwlBNIZLol1OzNq7R9wLFkx0ZlDMLneRJLAY8A9Uos62VyEkExgGIDfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7342
X-OriginatorOrg: intel.com

On Tue, May 21, 2024 at 07:28:27PM -0700, Sean Christopherson wrote:
>Register the "disable virtualization in an emergency" callback just
>before KVM enables virtualization in hardware, as there is no functional
>need to keep the callbacks registered while KVM happens to be loaded, but
>is inactive, i.e. if KVM hasn't enabled virtualization.
>
>Note, unregistering the callback every time the last VM is destroyed could
>have measurable latency due to the synchronize_rcu() needed to ensure all
>references to the callback are dropped before KVM is unloaded.  But the
>latency should be a small fraction of the total latency of disabling
>virtualization across all CPUs, and userspace can set enable_virt_at_load
>to completely eliminate the runtime overhead.
>
>Add a pointer in kvm_x86_ops to allow vendor code to provide its callback.
>There is no reason to force vendor code to do the registration, and either
>way KVM would need a new kvm_x86_ops hook.
>
>Suggested-by: Kai Huang <kai.huang@intel.com>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

...

>--- a/arch/x86/kvm/vmx/vmx.c
>+++ b/arch/x86/kvm/vmx/vmx.c
>@@ -753,7 +753,7 @@ static int kvm_cpu_vmxoff(void)
> 	return -EIO;
> }
> 
>-static void vmx_emergency_disable(void)
>+void vmx_emergency_disable(void)
> {
> 	int cpu = raw_smp_processor_id();
> 	struct loaded_vmcs *v;
>@@ -8613,8 +8613,6 @@ static void __vmx_exit(void)
> {
> 	allow_smaller_maxphyaddr = false;
> 
>-	cpu_emergency_unregister_virt_callback(vmx_emergency_disable);
>-
> 	vmx_cleanup_l1d_flush();
> }
> 
>@@ -8661,8 +8659,6 @@ static int __init vmx_init(void)
> 		pi_init_cpu(cpu);
> 	}
> 
>-	cpu_emergency_register_virt_callback(vmx_emergency_disable);
>-

Nit: with the removal of calls to cpu_emergency_(un)register_virt_callback,
there is no need to include asm/reboot.h in vmx.c any more. right?

