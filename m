Return-Path: <kvm+bounces-69705-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WDnWGkSxfGmbOQIAu9opvQ
	(envelope-from <kvm+bounces-69705-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:25:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E0343BAF86
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12F22304E6FB
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:21:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4392E172D;
	Fri, 30 Jan 2026 13:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eNdQIz98"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9432C0F81;
	Fri, 30 Jan 2026 13:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769779308; cv=fail; b=Uttl+vNpNYjdE0LsrFhw13jOz+MFIPG0KScUdtQbpGk8fCHOc8wj8lPP5Eb1zXbUZU0+TUxQ1sqo/KcRiYDxrfOW+j/+9pVSk92o8LX1wQ1PgkikdIW4T3TNh8OYIjknmjzxuKlaN6/099u+tPtRHcly3hKxdhnv/P/JsA9XWyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769779308; c=relaxed/simple;
	bh=scPdiJ4a6xAixqMbeczoXLtnsXmOX1XczcDC4Kbn02Y=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=eIHZAbaElFd8Pmr4G6J5v9msjlj64e6ULrtxp76k/CBXiEvfJENecYbYhqfNCKglP2eK0sOa97T5HimvWnKbIcaQDenmtyHi71C55v/8vObfi20G6GkwRmp69n74AdnFxiaFWBtWrGZs2YliNwgxq61E3NOtWCwoE+fasTIdLd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eNdQIz98; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769779306; x=1801315306;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=scPdiJ4a6xAixqMbeczoXLtnsXmOX1XczcDC4Kbn02Y=;
  b=eNdQIz98OA3ogJYcDsF2pQWq6RSL/ldceSsHj81k8LfYQYWPkp0WXlmi
   L+olN+W1KyrIY7fsDNUsnrZRnl5IJoEhrKbzidK1M/rOlKlY4lWYQfjBp
   XDn/ttw6W4yGjwcqvYc8mz9DJ+KHwNW4XwwNlxIeSihAKtzy766HQpFZh
   SEv5HpHiKnyqkIlfxmUpe+nbeksZJ9rlECqdMfXVw5D86/QOyvATvfeq4
   9aPbygpzWgYszcXmp1RKzN08mpws5x7OMJHp0owGxZYa50ijHInM5lNw/
   WECPcUHByb1R6au2pWTpa/wQAW7w213oeykjd2ssDfsfDi4DxUAcSHLnG
   g==;
X-CSE-ConnectionGUID: 0+7iWsDDRTqU34QrgBZlNA==
X-CSE-MsgGUID: S2clPMGxR7+TKtJEpG91rQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11686"; a="74653119"
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="74653119"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 05:21:45 -0800
X-CSE-ConnectionGUID: leu2E03KTNeZfeK2VQJTMg==
X-CSE-MsgGUID: 3jSTlE78Rk++4hK6WOqjlQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,263,1763452800"; 
   d="scan'208";a="209209841"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2026 05:21:46 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 05:21:44 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 30 Jan 2026 05:21:44 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.18)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 30 Jan 2026 05:21:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M4a6mr8cWukg2EEH/nfrQ+0/1BdVtMTJQekVlePsw4Xj2FvHXYUSuG9i+WG8SriLfHBloW0sCzWmYWjaDq8pmAMjMJME8o/jV9yhWbGLUnW3s0dJm6yk42Z7ZOYTVgkuHRenJI4A7Oe2IA1mGbVI4JmhjrAkSj78QZw7vk3oQBIUZxlkmOlmdl63QwGnQGGYVGGaqW2o9s+QYXNCFAhNbEe/H09yBvYIqMcGbc6am18+ZFEOxjs1cv9i8tNMX/l3OfDmsATIcWcjBH7B/Pc+eMy/ZzHqYY65HcuCrg01rzhiyMDSypw+CQ85/L3Nz5gFvljrdwyyjFqC58sUrTi4QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=00sk1b5Nl214WBAq5mol46uTKFlgo9NOnw/IMVgfpxQ=;
 b=pfT4AUvNoFRCB/u5Im22U0paA05MJ5vpqID+DVdVhMl4o+3d8n0jez+4uV+K3EXQBa0yYgjLRYRwKq92ZdbAQfvlRPMK3o7TJRDFzcK7VAr3iEqAvez7nkZGecQxDi576Cukrccsjey1vqGxpnkvAi15qrXQgY4QASjVtL5bnNrLOWAVugN5TZhL8PKsOHxMCxm/JhB74Mu+R8Mxytn5nQg1HR+NKNpVuWxOyO7GKU5BETMNtA1dc5E7ciH1gx0T4BYhH9O+s4y6DmrzBv9Iokxbk5dgkBBwZYJ5iXFYBy9c7mlgkKYifM58yHHB1Kvi8uJmgMPcOczFin1M/u4EYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5829.namprd11.prod.outlook.com (2603:10b6:510:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 13:21:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 13:21:40 +0000
Date: Fri, 30 Jan 2026 21:21:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <reinette.chatre@intel.com>,
	<ira.weiny@intel.com>, <kai.huang@intel.com>, <dan.j.williams@intel.com>,
	<yilun.xu@linux.intel.com>, <sagis@google.com>, <vannapurve@google.com>,
	<paulmck@kernel.org>, <nik.borisov@suse.com>, <zhenzhong.duan@intel.com>,
	<seanjc@google.com>, <rick.p.edgecombe@intel.com>, <kas@kernel.org>,
	<dave.hansen@linux.intel.com>, <vishal.l.verma@intel.com>, Farrah Chen
	<farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aXywVcqbXodADg4a@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-8-chao.gao@intel.com>
 <301f8156-bafe-440a-8628-3bf8fae74464@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <301f8156-bafe-440a-8628-3bf8fae74464@intel.com>
X-ClientProxiedBy: TPYP295CA0002.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: 58d6f956-702b-4d62-eaa5-08de60028106
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SEMsPoscuptBkD/sTQOmewMRk8t0+KJAPwKZnwLjBYuK8fsgwQ9yCmP/qm7z?=
 =?us-ascii?Q?LevK1pSpE1lZqnyYWhphV/qa2a9liNDti7ZoBhfFz9ibh8qXu+l1XAd06ySd?=
 =?us-ascii?Q?dKR1GTjzZ+Y/QAzRD3d8gzLI5/yw1DQY5l0de4Y36selD3aYdA2lOacgLxVP?=
 =?us-ascii?Q?OwXmqqO+K6su/FZBoGAWBF0FA/u86nu0vM4wpwGhGB3/nqHUFNpDjJCaleBP?=
 =?us-ascii?Q?C9QpqF9ei8/Aid00h5+dcyIzAw06xy7VkC+ubEKFEmR+2vqGKYHYlKS19uPE?=
 =?us-ascii?Q?2XX0q7BvU9Ew+x4mfXmp0Fx81E/7QANItyQ/ieV/dQO+Oy7ZGiC71Nvl4XQz?=
 =?us-ascii?Q?BMj9QT9x3FHiueqZAtGWMlUZfywNPJQpjgJ3FSJxz7THRaMhEboe9H9ax4fr?=
 =?us-ascii?Q?fJnqTu7nccbQpEGh8KzIcPbif5crL1UMoiSm7lnmT2Fle/13MsnABfS6TKGI?=
 =?us-ascii?Q?Q+tg+D3hJxrVQW9xPuH1rLYgcicjEq+MV/YRlehHEUPKZPeht0SMQ1BaHsoJ?=
 =?us-ascii?Q?u36Twfth//T/fWHUSNv9j/4/QmPFDuHvI1rgNfQMBpLN1lWmazew4vqdLOKI?=
 =?us-ascii?Q?RE3LObdsXmaPgTwUxei7riH/LF/PKQo+9rzRyNsdNY7JT43ByxofpfbcBLwW?=
 =?us-ascii?Q?J5zzHz1l5d9SPPAJsoC0YJKNE/Yjck0hX0LWvoOe+J86MMZDRreFwKBCikHe?=
 =?us-ascii?Q?J3jQz0WfyEKShfx9/AL9zuk8Isa8B0LFQllGONvuyjytEXTiiryuN11EyUXA?=
 =?us-ascii?Q?9jb/PebmbxA0aDRi5+AKobwqn+llCRORXUKGQEfD3ItcqYtVSbd/HN+Yes6I?=
 =?us-ascii?Q?6EC43lB9VNcZYiJ8bHpsGrx8lux8MCt+UD3ikC1eMluIcnvVJiRdMUekS3ut?=
 =?us-ascii?Q?UkQznnj7CNCisbb+CN40FBXObgaq3yFmGIZ/gQ7Ax5TqhyCtj7vHQpg0rKpG?=
 =?us-ascii?Q?LjLBhZ36BCO1dXda9z5GWL5IW3U1SBK1qhkUpheQc8cSsE+xa9QQOXOJOLc3?=
 =?us-ascii?Q?k0dyaK8FsRu2JajjJ93Y/3Te4qFQ+FNTo/nTTb/+Jiy4/Pi1bBI51ptgFa7g?=
 =?us-ascii?Q?wHFnzFRm2l7/2ZA5xmXUk/bfMnj1IOaUvvAVuj/vpZsTa/BA7DNgPq1cfOJM?=
 =?us-ascii?Q?e4ey1SOTg1tdy0cs/vW8P76kG/b1stQRV02A4ZMo7p5EcIrfipOGP2KDk/wO?=
 =?us-ascii?Q?aaC4K4lqoaQg7XY942iV1s33iJsmC9z+OwJu/rMP/vN7s0mOCJv8q9vDIali?=
 =?us-ascii?Q?3GcUP1HZjRDAdcYzMFvju+AYkOqAUvXD0etUQ2ZLpqko4kDDclLlQMnbvXoU?=
 =?us-ascii?Q?orcspkz7b3b++cgEdz5J03ytXNQYqpVdDT+bhm7k6h1B8eLkE2XNvXIBsf7k?=
 =?us-ascii?Q?t+oWx/a1w/aYMtdsBxO92eeJV3Q5PaKMQP9GZOpg2k6yzOpuS5v2gZCXpdeq?=
 =?us-ascii?Q?RFpbHNXRp6cx168Fjhs38H4A0J3gcidoJQhoN97PT4TKbfbvKsYMdhA7uQ4H?=
 =?us-ascii?Q?2dJg9/lqeulgAfekLncsT62rKUD1y6RyoxPkO/V1gaoYY+01FBznwVA/a95Q?=
 =?us-ascii?Q?5m1UtjYsyCOKpwPeyE5O+SfZeOiZmdtfXCCKFvCx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x0BI5FTNS+gUW1iHP3yDhDaL/xzR9IiXb9giaT0OZFGdBVCletlkJK2gWbfE?=
 =?us-ascii?Q?A9+D1iR7PLs8C/VNZUdmX6J048BT8N4/7dppVvnHXwUK51WiCq74fs/XflbU?=
 =?us-ascii?Q?hrt+7yfEVn8welk6cmNUdktJ1Zlu/NUvDdLiUY7Z/aNltQqwlWDDMjKj2zfu?=
 =?us-ascii?Q?Xp22qLrKHjciRH4txu5I7GuEfnjXG0OBeXicSHrXOa6qHFe8LBxPMxII56D4?=
 =?us-ascii?Q?3/RhVNVffL+wiHqgZeMOBAnYf21U0e+8kqYSoepbpnVkWf19itBTqhuYRYMK?=
 =?us-ascii?Q?0mA89rSynG+ckJiVYJQUhLFxiujVAYNVAOTFpqn5YxGzgKXnlzFF/FKV2A4K?=
 =?us-ascii?Q?/6NJH3dZlSRIZbcwQg9OtgAU8f7hGSb33D4JdnB8Fv9NKdvjYUaeXyk5lvnZ?=
 =?us-ascii?Q?0rZMCyvk/JuYVXX0lKyS+KGAhHK+Tle/8n/7iz8gCSR4X6yPb890pU6DBRL/?=
 =?us-ascii?Q?ejzFZWVwJI2ktG2bJqTkIoqQ/2j5EeWZEyyd8LXYqIh+sdh9jRJnB0YTXWo5?=
 =?us-ascii?Q?UKz4n2gniJZkS6CG4Ma1NFuTY6mCDpm6vbUR2zaQeGTBnU7e0A4Qp/PeKJ5L?=
 =?us-ascii?Q?+BwL0bI+ofC777cqy0bnOeoaXFlZnfk5ga/xoO+TDu/rf37iKt072xVHTRkZ?=
 =?us-ascii?Q?29WnqcZZ19tSn2qpGR+zxV2hlDMF9NQDcOOAi+8XrlFrJtvaYc/FQ9Nz0HLg?=
 =?us-ascii?Q?SHFHNIGVhiN1ruc9cJz7bKBP45gdZ8zM9tvT1RUsvF3WqxsQ+2FSFG4EZnGa?=
 =?us-ascii?Q?UTxIo7ac/dxHHd2ZgkPLT7lg3dtZkex4coxCEXR22DJyh7UF47xIcJI7lAo9?=
 =?us-ascii?Q?TIB07EN5DfqVuSojdxQUlRpRmhfvfw924DUJm6+pplM47ENaef/Du56ADobc?=
 =?us-ascii?Q?fdfHYfm3Io/Fr0rH9aP1h1cip7aSoQN7ENLqXZVL8Uf2eQyOu/ZshQHyCCa0?=
 =?us-ascii?Q?s5ngDcuIpaX8nM5wFqc1FAESwcp1uquWuAaTEka6o+ApBf2ZdRKT8a8Fo5v8?=
 =?us-ascii?Q?r5PG9Tu397IVo0Uduvr8bzga5HsHH+QtXTkEfY1r6yMqZ3fB6UiyEr1JQWeH?=
 =?us-ascii?Q?4EESstDPjKo7Uquj8Ciz+YrYJiPdixknb9fCFqIL8WE1y0ek1m1b7jJebXLF?=
 =?us-ascii?Q?m0dNbKXYBiSfXMBqhjYkt+bAEsgAAzP5luPHBoc2R2TJI0ovJ6HcpHwZiCf3?=
 =?us-ascii?Q?b4rFCoHoWqmkwid55N/GLjgXYshSTvu4l0C1CDWFw/m397c54MZ0g37VX4hO?=
 =?us-ascii?Q?HpBJ8Azo00GeQqSI8A3AwP+ZzNTAweKangN7ogPwq7Oc879yxlHXOoyKLqQd?=
 =?us-ascii?Q?yYfOCq1SJEN1dHOaYw7SP8wOCmnTXorYjGd/9km77dDsPD4jqa+se6vFC8cU?=
 =?us-ascii?Q?LUu4++Hs3s3LsKw85PR9wwA6sGxeQjDOHS+6wqHT4t0SYJDvd7LBrZb8Tz3P?=
 =?us-ascii?Q?hZOwjqyIrf3jztLY27w135WCC6ABG2oO8m1YQaeWuuoaqNaavzKxEMHkW5x4?=
 =?us-ascii?Q?CctyWEkbTeOVOrIFXw5c4N7Nd9StQhDgdWITOZsX0iyLcWDmUPicfZDVdwII?=
 =?us-ascii?Q?WWw/hzntUeNVRAaUM6nwQjoa++x+FvXwKjGNXhQaonnRqabMJKGg+VNHfv1R?=
 =?us-ascii?Q?Gmpou3fYI2hMTYtaBxiqbxqMvBZICAl/pxKbp2GdJraO1B3mUJpoiBdk4yKc?=
 =?us-ascii?Q?IP38wQICEcF+X1UtIpYpIrO2F99AsC8dUSrtBKn4Do7IaG+B5AL745aTsJIG?=
 =?us-ascii?Q?7zLSLfW+uw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 58d6f956-702b-4d62-eaa5-08de60028106
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 13:21:40.5822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ypb1BSNaMWpISooDHLMIUloRAxHYm+uQ+VBIze4gi99WzR9llvlWfo37qV1u/1fCYlpGUspNUM+TXItn9akQZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5829
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69705-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: E0343BAF86
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 03:36:49PM -0800, Dave Hansen wrote:
>On 1/23/26 06:55, Chao Gao wrote:
>...
>> +static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
>> +{
>> +	unsigned long flags;
>> +	u64 vmcs;
>> +	int ret;
>> +
>> +	if (!is_seamldr_call(fn))
>> +		return -EINVAL;
>
>Why is this here? We shouldn't be silently papering over kernel bugs.
>This is a WARN_ON() at *best*, but it also begs the question of how a
>non-SEAMLDR call even got here.

Only SEAMLDR calls can get here. I will make it a WARN_ON_ONCE().

>
>> +	/*
>> +	 * SEAMRET from P-SEAMLDR invalidates the current VMCS.  Save/restore
>> +	 * the VMCS across P-SEAMLDR SEAMCALLs to avoid clobbering KVM state.
>> +	 * Disable interrupts as KVM is allowed to do VMREAD/VMWRITE in IRQ
>> +	 * context (but not NMI context).
>> +	 */
>
>I think you mean:
>
>	WARN_ON(in_nmi());

This function only disables interrupts, not NMIs. Kirill questioned whether any
KVM operations might execute from NMI context and do VMREAD/VMWRITE. If such
operations exist and an NMI interrupts seamldr_call(), they could encounter
an invalid current VMCS.

The problematic scenario is:

	seamldr_call()			KVM code in NMI handler

1.	vmptrst // save current-vmcs
2.	seamcall // clobber current-vmcs
3.					// NMI handler start
					call into some KVM code and do vmread/vmwrite
					// consume __invalid__ current-vmcs
					// NMI handler end
4.	vmptrld // restore current-vmcs

The comment clarifies that KVM doesn't do VMREAD/VMWRITE during NMI handling.

>
>> +	local_irq_save(flags);
>> +
>> +	asm goto("1: vmptrst %0\n\t"
>> +		 _ASM_EXTABLE(1b, %l[error])
>> +		 : "=m" (vmcs) : : "cc" : error);
>
>I'd much rather this be wrapped up in a helper function. We shouldn't
>have to look at the horrors of inline assembly like this.
>
>But this *REALLY* wants the KVM folks to look at it. One argument is
>that with the inline assembly this is nice and self-contained. The other
>argument is that this completely ignores all existing KVM infrastructure
>and is parallel VMCS management.

Exactly. Sean suggested this approach [*]. He prefers inline assembly rather than
adding new, inferior wrappers

*: https://lore.kernel.org/linux-coco/aHEYtGgA3aIQ7A3y@google.com/

>
>I'd be shocked if this is the one and only place in the whole kernel
>that can unceremoniously zap VMX state.
>
>I'd *bet* that you don't really need to do the vmptrld and that KVM can
>figure it out because it can vmptrld on demand anyway. Something along
>the lines of:
>
>	local_irq_disable();
>	list_for_each(handwaving...)
>		vmcs_clear();
>	ret = seamldr_prerr(fn, args);
>	local_irq_enable();	
>
>Basically, zap this CPU's vmcs state and then make KVM reload it at some
>later time.

The idea is feasible. But just calling vmcs_clear() won't work. We need to
reset all the tracking state associated with each VMCS. We should call
vmclear_local_loaded_vmcss() instead, similar to what's done before VMXOFF.

>
>I'm sure Sean and Paolo will tell me if I'm crazy.

To me, this approach needs more work since we need to either move 
vmclear_local_loaded_vmcss() to the kernel or allow KVM to register a callback.

I don't think it's as straightforward as just doing the save/restore.

>
>> diff --git a/drivers/virt/coco/tdx-host/Kconfig b/drivers/virt/coco/tdx-host/Kconfig
>> index e58bad148a35..6a9199e6c2c6 100644
>> --- a/drivers/virt/coco/tdx-host/Kconfig
>> +++ b/drivers/virt/coco/tdx-host/Kconfig
>> @@ -8,3 +8,13 @@ config TDX_HOST_SERVICES
>>  
>>  	  Say y or m if enabling support for confidential virtual machine
>>  	  support (CONFIG_INTEL_TDX_HOST). The module is called tdx_host.ko
>> +
>> +config INTEL_TDX_MODULE_UPDATE
>> +	bool "Intel TDX module runtime update"
>> +	depends on TDX_HOST_SERVICES
>> +	help
>> +	  This enables the kernel to support TDX module runtime update. This
>> +	  allows the admin to update the TDX module to another compatible
>> +	  version without the need to terminate running TDX guests.
>
>... as opposed to the method that the kernel has to update the module
>without terminating guests? ;)

I will reduce this to:

	  This enables the kernel to update the TDX Module to another compatible
	  version.


>
>> +	  If unsure, say N.
>
>Let's call this:
>
> config
>INTEL_TDX_ONLY_DISABLE_THIS_IF_YOU_HATE_SECURITY_AND_IF_YOU_DO_WHY_ARE_YOU_RUNNING_TDX?
>
>Can we have question marks in config symbol names? ;)
>
>But, seriously, what the heck? Who would disable security updates for
>their confidential computing infrastructure? Is this some kind of
>intelligence test for our users so that if someone disables it we can
>just laugh at them?

Looks like I failed that test! ;) I'll change it to default to 'y' and
recommend 'Y' if unsure.

