Return-Path: <kvm+bounces-57121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B1F34B50482
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:34:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AB11B1B21ABE
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 17:34:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45063568F0;
	Tue,  9 Sep 2025 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H/m/Rk+R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550BB272807;
	Tue,  9 Sep 2025 17:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757439250; cv=fail; b=OmXCHGADEvULsr5pSIF59oaiuW961dcY1INB9160xPLSuDcrfDe3vbVymgCknQ+JjfPCzO42EBWZBB+qYv4w5VPxePtu8IKJDJLf9a+FOUskDp5ZAQ1dVIVtO/0kgAicK1szWwrwyiiB7O3MqWnyDHE8mOvlUirLJ63eoIvh2dM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757439250; c=relaxed/simple;
	bh=EB9tt2MivA6ARygoIDxEvBiDY2U0xj2wC2ZbAAJRvIM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lZT1XE+UDRYJPEFB5hDFVKg1LwCNxXQlEX+HPZq2jhjUfTa57XRcqbokOzsLvMZ1EtO5Wc9sUfrVjwLjj4DHsXYcN/ZTfR5V0mbhk8K7JJPTZ7+qXO6qC0/Jygb6ouVwMtZuKwZcCawV5WbHf6rU22NAq2oUn0m01yshol0H/Lw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H/m/Rk+R; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757439249; x=1788975249;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=EB9tt2MivA6ARygoIDxEvBiDY2U0xj2wC2ZbAAJRvIM=;
  b=H/m/Rk+R4QZ9x0xqS61P6cahNTH9G6XewWrtTnRZ4Fv4jmHfBQVwBber
   aX5pEy9S54g/7B7SHWxFxwX9dAjftYdmTfVC1YvDB5QuJ9yBf+TP/DcMN
   teFzAGxpO75HIACS8/uMmEprO/azIxjxLf19WZ8Kxf5DGQbfvOHNWkpHb
   V6mlUR67XpPYpgR/cvhwVpMy6q8d4nSlSenQxdm5ndHjKC5OTk9pYTcO2
   gq87OmliyY4d8NIPGS8UbGTueq/eJ4BwQQ5Z2cMX9dSvueZhBCCQa5Lg0
   sATob4Y6dCmqcVSQsPRvDjNBzWyFkFujmSQQqerGb7i4In9ad7EB0EIwp
   w==;
X-CSE-ConnectionGUID: NGW3uMQCQHWmc7/FU+He7Q==
X-CSE-MsgGUID: cvagY0VQTGi49GWQXYOwyw==
X-IronPort-AV: E=McAfee;i="6800,10657,11548"; a="58774368"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="58774368"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 10:34:05 -0700
X-CSE-ConnectionGUID: Q7O1oDVmQjCS0eJniWNLMA==
X-CSE-MsgGUID: GsLMO5fWTo+LOWJYPhpEdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="196828360"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 10:34:02 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 10:34:00 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 10:34:00 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 10:34:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NiNr0FtmY7UnVKV42kITrTvnVuQXVie7PhLGHa+3RRMyd41zLIG0+GL/ur77ED7GhQDb0qDOI2FoW35gwaUX8OuK3Px3I+PPUmWO1WiY+3xBOU/kzQAxxXMNLkwlU0uPKAKnZMFSq/q5ivWvbC6ILzfCy8mxUIdp+G9h6ri5We1KBf0ooFp1kL6JzphcWjHvJtxIvMnlf6HZNZ36otTpZSgw4kS6wiZ/A//uujkV7KrY88cz82TYFqEQKZMGQv0QioyD/PLgwUEwxg1Iql8vf2JjneE4JWyiUdfMWoAlhc5wF6iMZll3sD/fT3oJJ3w14a453AWcxmZ2h/O1NKLdZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyEPoGIpHHr8/EAE58JIz8LcfL+XY8JVocVvnBDE5aQ=;
 b=RQfsG2aXza8SW8LLKPV8vu8JdPe6lRfC9hoB7H2aBuuINIfC4u4gp2DoFHHqQ230aAS3uHQ48SyNbw+vi+H9le4jwpMUrg8yYF5ofIW/foDlFYmc0MX4brBeu1YmwTEYPXATpe5j1sBZ7nVAvKX9mEsVyrWm90550QV3obnihsHQAeAF7DaBj6uVks9bEnBLHFi9B08zOhjtyAUbxLN4QGTWCIeXLpfrlZ+TeGEzBx34drG3Fs0xWs/vgWflr5MZGxjLwIHMBWP5Ymz4umpQw8oYS0f8D5+lVB4BFziybP8r8p1hJUTX4qvqPoFmCp8RZSjgmzyAgQJSVmMuChZSCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW4PR11MB6811.namprd11.prod.outlook.com (2603:10b6:303:208::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 17:33:55 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 17:33:55 +0000
Date: Tue, 9 Sep 2025 10:33:52 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, Babu Moger <babu.moger@amd.com>,
	<corbet@lwn.net>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
Subject: Re: [PATCH v18 00/33] x86,fs/resctrl: Support AMD Assignable
 Bandwidth Monitoring Counters (ABMC)
Message-ID: <aMBlAG1Pmtr2hHWN@agluck-desk3>
References: <cover.1757108044.git.babu.moger@amd.com>
 <107058d3-9c2d-4cd4-beba-d65b7c6bd9a0@intel.com>
 <20250909161930.GBaMBTku_VgKUpTs2V@fat_crate.local>
 <0227e8ec-aa65-43e6-af07-e71f7a1edca2@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0227e8ec-aa65-43e6-af07-e71f7a1edca2@intel.com>
X-ClientProxiedBy: SJ0PR05CA0070.namprd05.prod.outlook.com
 (2603:10b6:a03:332::15) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW4PR11MB6811:EE_
X-MS-Office365-Filtering-Correlation-Id: 17ac41a3-b2b5-48fd-08d9-08ddefc70cc7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7rLcQHe+jpt8TZnphvkdnZJoAuo5nFMjS8SO42wyr17GhN3G4DQajAU62qpb?=
 =?us-ascii?Q?P5yISrVzUKa4GvuVWd0NJkCxZoCu4qN69cxBnCjYciIhjpMXHd7eME1+Tjuz?=
 =?us-ascii?Q?bve4k04h1y2DIiCl29O86A/GriNEnMSNdbOIk27LAQ5p5dFoUrFttZqmlUKX?=
 =?us-ascii?Q?bLXnxBS9VxMIe2f5W8c+VCEYE7k9hMh++oL9hODgkCxQX5xs/kkKy3y31JVA?=
 =?us-ascii?Q?Cp6yQr5nW4/A1sobdblb59sWim/Sbs8FGWYCdoudMwAt82k2Q91NgDcz+nCs?=
 =?us-ascii?Q?/jM+P7x7HlyRGDvjLY9N1Lqi0X8Niy2ZcILqIp81mUdvTFF4cKY1zgCaJn0+?=
 =?us-ascii?Q?DCLeszwu/P2n0WKs8+3kfNup0vqvZziCte7mAiZsOPFSAwM+JWPKWmhgjSQn?=
 =?us-ascii?Q?7mhu+tCGJjAhG4bK57QwHcZBSmFuB4G8cra7rUWIMPC5TzngTZXVnd9ksk+m?=
 =?us-ascii?Q?1Bgt/VnSrXAfnGdITDDUo0N40FZZXsrIIe2sWhpSCCFEFUODJ/JB9M8McKi7?=
 =?us-ascii?Q?wukZUT/WTAOoHub6F3qzm1W71s1SpfQC8tOf8+wIUZJICphY0/qRo7pPy22K?=
 =?us-ascii?Q?F7klEKPt3D9UtT81qFfACQsIDSGV1Xzcij7SdcIvvEcPu3r0lDiNA6I5Ud9/?=
 =?us-ascii?Q?VRtQDfqgfoW53Q6eJt8x1QMGu9nIDxvV+uuwM5VBpQHAfNy2+HZHl1D/691J?=
 =?us-ascii?Q?opiJ715fNwMMjkbYmJ5N0KaFeeQ629zqyUlyucvovEMvSdgtLDta3fORUJ59?=
 =?us-ascii?Q?5IEc0ov/bpOnYz31exPKEdc2vFDBjB8Y/8ka1KIpiijp7zjWj/kHGSr4Z9Ye?=
 =?us-ascii?Q?G0lbkeccoZBpv8MRlsq89S58akbWc99WZQkoH3PqUnHAYphtEysfhqKvt8bG?=
 =?us-ascii?Q?xm+mFKKzDdBn1z9r1MT6PQcn6XIeOoTpFJb7YDJfPkXg/0zAuvdYIy3mi9Wr?=
 =?us-ascii?Q?e5MzdR+x8XYSD5qh6ujK3bdj1jgGL5Vlzh9N4BcWt0dpBK+vo3x7Q1AjC8GZ?=
 =?us-ascii?Q?IMWkU4usv2n4UyqN2DBWV4g78X8BHG5/m7hMpqMfE4jKwKDokeGtf+dIxRmD?=
 =?us-ascii?Q?8632AeOmgy3SFttLL568WEyN5nqHRI4KRDnexvjOVQNAsUjJPmzzRxTy/NrV?=
 =?us-ascii?Q?LKXfgCs76AIGLz61wX6V8CXGuYL1gnTxh1Pfplg0TvuJIn8mRYkbe65lqhFZ?=
 =?us-ascii?Q?LgbwK93uWLTtVL+w/XkHAhsrEAiMxUIRQVrBIi+OPsIXbSOW4mMXpQl+6o75?=
 =?us-ascii?Q?qvHQWrSWvNq4VyJF2dH/hPVI3ugkTAlF5ixnJa771PSTYIOMsVVzvQDqBWMN?=
 =?us-ascii?Q?+6NqxCBSVU4KhoG7KtY2hlYh6LCcwq84cjKBqEBIBdzpMVQ4/CxMIWVPWUvj?=
 =?us-ascii?Q?cjBUb97K+fLJDocs4RdII749q+125EoX02VVeu3t5wmLl4ExE4e4e+5oP82U?=
 =?us-ascii?Q?HOa5oJXnQKw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9TKv+g69TWCjiC/5WuER2Im2YXdD/W+r646oxGllUn1MdEPLYAZW+i4cFm7d?=
 =?us-ascii?Q?tLdgh+yZWYF+ipqvG6F08hOk4i9EUYwUNC55lYeSY8XLYXZ7saXTOjE1zlCG?=
 =?us-ascii?Q?oFS8kkPu+GPhnuUafoxvba4JXTyYlScJO5duoNcEfcl/QUaOF+8cLOQDBnMZ?=
 =?us-ascii?Q?H46A256t+5Lr3Tg1YLxQzeyhSmW7wdM/yfz+ShaU3MuYrjiiprJm+zSJpe9m?=
 =?us-ascii?Q?7xNsWdvRjyuGmGGgyK/4eFoURfNJI3cbR/TFmkOyLtMdmseo+hBFLwbU1qlM?=
 =?us-ascii?Q?LeDJzwt8HmJ4ou2Dsf/Uh2TFFv6KEz+C9W6PqvkD4U1+NYNXBViAMsjr5obA?=
 =?us-ascii?Q?+E99hKy/x+VYlO9ECBsBxkFgjcZsGvSRBTLm6bw7K5tJZUtiiOo0D7KKo/24?=
 =?us-ascii?Q?zar5Qtb2QyAvwZ6CYLPdoBPPqaWRiDpwCWYKB4jDf/3H7yF3m0zrKbjpiRyH?=
 =?us-ascii?Q?HlRcZfHl4CZH5aGi3MuSdQstjtFeKwE3clqkle68xqUcBcnK7c9gTW4qUd1m?=
 =?us-ascii?Q?71QwDorclwmXmUmV3r6KtqHabw3HHxJJDXI+/uuWo7kTurqmBWiRvrwGL9hE?=
 =?us-ascii?Q?JHxyWUZQ4LhnBdIFHulTvVhH9idIQkK85WNFCI4+03aZTWxGXGl+GwBSLORc?=
 =?us-ascii?Q?V+LPu0F3h1SbScXqglWvDYvF6Je2WER3uqV1WDxdcaLKnTl9LSufHkNT6vLq?=
 =?us-ascii?Q?yN4doy4BK2gBBuX4l06z2ZKnOpqugWXL+WJBEoE8H46lUfbo35ZPUL+d8XT+?=
 =?us-ascii?Q?Ggb/lE3tEQGEjYZiLysAKEuHXequ+kzc1IcyWDxtb0+ObUsZOPrBSs1rNhjD?=
 =?us-ascii?Q?ujuSxFnNfeBONrqZ+xK0oFUWDx7KP3EVmm/nX6Wnv6JVbkBZSuBFXIcx4MdT?=
 =?us-ascii?Q?2Z0PdUU1HmQJ4fw0AR9V27nA9MsWiZJj86qsGcAjC6D+ci1rGFMjVjsbqq+5?=
 =?us-ascii?Q?hRo1B2tCy8RnITW0ZBtxiSJxiHGohvWuh/WOTeYz6jCgZjvmS/HnsWEuntvk?=
 =?us-ascii?Q?aGuW/kc0kpoBCwCcBXmTH3kkoT2knr9yefT7Wu9MnQSSQkiSNglStYSbcKn6?=
 =?us-ascii?Q?nevFFfNqWsA7FtlCIuu40gh/Aa5S8nCN0phiD0btzWJdBPlFHso/dj7JaEh7?=
 =?us-ascii?Q?rAzNDzvDVrPfBD56y5/fbyZLFFoARgIeWZQaScbm1rJLfOQngedh9bsG0c7u?=
 =?us-ascii?Q?O4/EfUz2hAoHX1OsOD0uD5AHzqGXtKG4JjTQZD5zet/lap/+OgcLbRgbKT8P?=
 =?us-ascii?Q?UTF0gh3J+Lns4cT2JaKW9IoDzWWEaFKGU65QhMSR1VfIVVJygUaShecM/up9?=
 =?us-ascii?Q?IPAEqXHOVNUIcmQ1bezTTF/6Py3oiX9zGXbFbhoYyDlTV+0qcAvPa0nbEGEq?=
 =?us-ascii?Q?11LQclqvNhMdW70zDtsc0biARQ6LoihQuP+OzD3MzBZ2Kr2gjZw2WFalkg79?=
 =?us-ascii?Q?m6bSwbOMlFZX1eBCAEHjaMSrG8JwCInlHNGl2e+wGFa8Wlx4lLoaAKPIoUrs?=
 =?us-ascii?Q?gE9v4cfjI75CmfK2JGjonpmB/jZ9bKrkwRxDTfmy+FTiB3lV/WF210qkWX57?=
 =?us-ascii?Q?RjplNHJ1Zhnumw6HEVj2QGXDGMYKpTYP5pa3jnWs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 17ac41a3-b2b5-48fd-08d9-08ddefc70cc7
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 17:33:55.0970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jquex2sF/fjr4kYF8lHiExgOPPrAWsbEC3q1OmNT5phT2EdMAMBXKnqlcMvP9LgpHZrP9KzLt2Gl4lGVEs7zTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6811
X-OriginatorOrg: intel.com

On Tue, Sep 09, 2025 at 09:24:39AM -0700, Reinette Chatre wrote:
> 
> 
> On 9/9/25 9:19 AM, Borislav Petkov wrote:
> > On Tue, Sep 09, 2025 at 09:03:13AM -0700, Reinette Chatre wrote:
> >> When I checked tip/master did not include x86/urgent yet but when it does (and
> >> tip/master thus includes x86/cache and x86/urgent), could you please
> >> merge your series on top of tip/master to ensure all conflicts can be resolved
> >> cleanly and ready to provide conflict resolutions to Boris if needed?
> > 
> > Thanks, just give it a test but no rebasing anymore - I'm going through the
> > set. If there are conflicts, we do enough patch tetris in tip to catch them
> > and handle them upfront - you guys don't have to worry about it.
> 
> Thank you very much Boris.

Conflicts in Babu's series were trivial. Fractionally more complex in
my AET series (because some of the code touched by Reinette's patch
moved to a whole new function. But still not hard.

Whole set (upstream + Reinette + Babu + Me) pushed here:

git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git reinette-abmc-aet-wip

-Tony

