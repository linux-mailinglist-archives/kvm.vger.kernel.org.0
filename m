Return-Path: <kvm+bounces-13511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44EE9897D44
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 03:04:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C62C41F2550A
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 01:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7017318AF4;
	Thu,  4 Apr 2024 01:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bNCJZDVY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79661803E;
	Thu,  4 Apr 2024 01:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712192646; cv=fail; b=Ez8hW4t6aR/+Uxu/2tg9MLt78LphKXCFdtJMwoyqU+bIHcGAH5nmLEgjCrzcDON0tusnO40Ln0Jj2h1S6//btc0Ffrutd0okzN2bNAMOFP/isibQn4kqhA3vTUeOXJ6jlXYqZjKcNyBPYEBhOEnNB12xIKtVq+m92ckqJogB3QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712192646; c=relaxed/simple;
	bh=k8fRoj8k12yBq24OVuZ2b9px57mJkl2XHDHYOOIM9Pg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CaZAxi963ot/buhwTb1CrUY+1hhykrUmnAIQYhzfAR5SgofkBgxnfXNpAdPa73ZOctt5nbz1sBeRWoVlDDGl68s/DkygghgQAtezHaxIuyi7g/EiGm4dyPvm5qx1huEP6nKMs/SJH0WEz1hkb8fw2awwfAoFmCuScPYEv8+gNpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bNCJZDVY; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712192644; x=1743728644;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=k8fRoj8k12yBq24OVuZ2b9px57mJkl2XHDHYOOIM9Pg=;
  b=bNCJZDVY/AEEQ7mNb2O14Xxaca/vWioQyJMTxwHzDnN1m4ddnG8zL2qd
   JZmTiXH8SuT4IQ3RS4YwZQKs8rQKj5SJtey00hrw6AmmfCvCVbo4LdRpq
   68Lw4A8F9JkLn8Oi5acrRwFoLTBcVuZIEwmH/+PdOXdy9ulDoNda//Jmq
   eJLWokxwp0fIZ2qz3oxdn3neIanIhrTOMsQskVZQ/B40SZ0ul+VWFsGmn
   ULdLLxLqxqYzf5Kbqq+1fpLwtZFDcUMLXoOU6rgcCFndTVd52ZnzvL/Lc
   UN70cE4iDcgtSfrNaFU9ezjkIvQ9pl1B8UMpapPaoK7VK9Cir02PRqqU5
   w==;
X-CSE-ConnectionGUID: NoR1o/i9QJCnXmJu/7b4rQ==
X-CSE-MsgGUID: uq2e6xxtS1uDnh3YoQQt5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11033"; a="32844815"
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="32844815"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2024 18:04:04 -0700
X-CSE-ConnectionGUID: ayZEGWwwS/+i3vd2QxAkVQ==
X-CSE-MsgGUID: qOSuEBGHTjK2dJ7zSkRKnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,178,1708416000"; 
   d="scan'208";a="41786709"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Apr 2024 18:04:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 3 Apr 2024 18:04:03 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 3 Apr 2024 18:04:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 3 Apr 2024 18:04:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdtHBjjcaAcNNV3Q8lgNLznmKcj146jDULAjbLKD2uH5YMpqmqbhgTstRDoaiPO7AsG5EKrAACIXG12jTl9scY6a1XszDWBdwl7QyVC3OXLc6nzkxdA08DiskrlpEnKCwGcXvDOMFJEKJiaU9d+k/37lKegp++qD6yx5KiyvTW79POuqPTa3KttBbKSHSfE+aDyrPFPvPJ/vrxzaPVgWU0z2AddLmANblXQ/gXqIt/h87T6Ewq6U5JrSRto2db6gjEn+lJjHisLqOibLjIRSuaGVFipsjBSYIDjsZGZ3gr4UPgOOiVlQHClWcUBfkyruSWfUkGQU9xS4nh1kMqhwuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B59+Edf9G0aBkHoTWufCF8kTOcEpJmcMXQ8puD3sKy0=;
 b=Q0ut5Ij4vKzzaQsu9DkgtjhCt5+ZE1hlRqvTQTIbszX48zAKq9noK5YCEtGrWlBc7JXIDl63CyDXJJg6AtbrGEfW4dGeRBB7BT7Vv6y09MmT/hVhOPJMlzaVBNb3aT9byVnA/QNH0Bm9NYhyfrHus/mM5UDA4BPQGtBwyHu/U2UD3UroeqdDmEeZrUz3zYmbBdX695464z4N5VYINwayfZC8okNaVgiWmBVJh4loFjA2kPhWK5Xgdur6ZQw9OozVOzh6hTAhiDW1Yq5ZpJBol0gwVIj8xkI6pMB7t+QKMBj3qq7F9yhCOGJQWR6zgE8fxXL34x5s2HGW57X8+0kQow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by BL3PR11MB6532.namprd11.prod.outlook.com (2603:10b6:208:38f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 4 Apr
 2024 01:04:00 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7452.019; Thu, 4 Apr 2024
 01:04:00 +0000
Date: Thu, 4 Apr 2024 09:03:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>,
	"Sagi Shahar" <sagis@google.com>, "Chen, Bo2" <chen.bo@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "Zhang, Tina" <tina.zhang@intel.com>, "Sean
 Christopherson" <sean.j.christopherson@intel.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 038/130] KVM: TDX: create/destroy VM structure
Message-ID: <Zg38dcrwMg1a7iJT@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7a508f88e8c8b5199da85b7a9959882ddf390796.1708933498.git.isaku.yamahata@intel.com>
 <ZfpwIespKy8qxWWE@chao-email>
 <20240321141709.GK1994522@ls.amr.corp.intel.com>
 <58e0cf59-1397-44a3-a6a0-e26b2e51ba7b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <58e0cf59-1397-44a3-a6a0-e26b2e51ba7b@intel.com>
X-ClientProxiedBy: SG2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:3:18::21) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|BL3PR11MB6532:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: prnDWq7gcBUCD6zgmUgGTvORzn3SuzbrE+8ivOdnApQvksEECJesjn+wRcoVryTfszQIK3yyxGor0UHsIRqlxBa+WGHU2e91Q56gQxxnfXCOvSFuYJ7o3zt9Xq4zOTRfZqymmB5on5pf/rtUkxQcTeh9KqlTotbwMRO3gfii0I/u5ZhBXoCwRtjUyoZSpUbnMs3VQyJCGnjlA3oLmTzaoPSpUn7oXRohgDqgdLjkCsP3BeI04NKCvo1u2NSIqr0kwM4CyrD92/x4JQKiZKc89sYKOVXafdEhoTiBY20+1aPW7jVYUWFqK5spu3jTZdazELrwfDB/HqOLLZBi62VYeakoNRz6b6ZiKbeM/f0zpvYqBenuRWtSJ9dcWi/Kf51nbuexEy7m8PTBhS49Rp3X4nin5IAtazSpQVjD/ICdSvSSQkyvTiUaTp+mzC9beRbZVyNeUoLa1Ooe+bRRgmhUMnTprQDo2MefHw4HwQ7kgjje2VlrqiW+hPwF3oDfQNnrZMlL/BGKfekI8darUEyT/rWAxQnSYxDcFDpnCYz9G8ecFRCGiUSSfG1id+qjH3OHg3pFEtP9skU+h2rPrPgQWZ4pPHkSwv0KSeQ/LDY1Z1r6ZP5nB7H4uIR7YgJkC8iQpl4jnZ5B+KPGbf9Q6BFGZdopY8CPtQZ1n1hupKFjtak=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9XdnOm75BRd4JOphI5Hr2R8kjyRbMU9KWuNhvr3K/LVoRMAcrPNLM26TrGb+?=
 =?us-ascii?Q?FzMNX5l0bRbA+hYR/SkSHjF7JsPNMVuWJsSGSesYI6p6MKMBVf704UDkGG5L?=
 =?us-ascii?Q?UB7iBiu3dkJrzUFMsRargOrWwi2fWqPNy0+S4Sah0BqhVZ7jttQWCGWFRov3?=
 =?us-ascii?Q?Cfvl69EDyVh58p2r2cFcpvhiAmoBXl3LZZHiqJmkHdRSe3dBQE6fG+5+tNnB?=
 =?us-ascii?Q?jLV4E3FdRItZ8GsueAK8dloZiI2vcF0MDRCWrdf1nj2FZWHjiqisflsuEC4G?=
 =?us-ascii?Q?OPB6CBs0ncD9S7hRoxOsDcKN/cWE3kivH+SwLeg8anqt/rkNL97+ObBLg0pF?=
 =?us-ascii?Q?AV/ds6k9FEj0wpTSpk1tQ18zGLMk80+aecH2VjDsFMX3ZCXBj3QXd2QxEJll?=
 =?us-ascii?Q?AGGocFH0wxNW9JQdxR/DBXlbNO9oraTeKk70amOUqpMJI49/Z50kBotx1BNv?=
 =?us-ascii?Q?tYhp5L1BjRBpBzZuCz/jn+x5k31qL0Wm87st2KHINfeLgIkPwim503F0JDHT?=
 =?us-ascii?Q?x98pnHefCSkIq30nLWJNsRKSQEDbBPBLMkF1n6ibNSpptu+PAh09WDWHiPIe?=
 =?us-ascii?Q?XqQBKo5zhLFw099yBfVCAGpxn9R29RvcqVeWzJAAEyp01ByzqTq5NLN6PAEU?=
 =?us-ascii?Q?Pg9ef6xlOiFAB3gPb0aoWkfAN0u0kazCigz4BeJWVLdw4CBHh3ffQIDJLbaD?=
 =?us-ascii?Q?b59EA/Zw8t1j6vzumDF9QMgRxrYslK3oS/oaFXm/uMtP+8ZNnYlzwtZDpIYm?=
 =?us-ascii?Q?aVnHqfo2Nwyyz67Hkqgp9yv2g6w3uOIlXtCKk3WozMIO9lClN6Y5PbIWmlfe?=
 =?us-ascii?Q?ohy9fIBSZp2fu9om6k/e2IRO3z2Xe9fyf3/XXu3YW9Z1i9CD9uj6NAt79zpv?=
 =?us-ascii?Q?6DzV9yALWpE7aB6FXJNx7or1RUnrK2JZdbpv78QC+BXH5CNFFcPiakQ7zBQ+?=
 =?us-ascii?Q?B7Lfvp5VYsEVmKhWk5AoLtNxslYVIyVeIyLpoBfe1AJghhOtoA0OuQqvqefx?=
 =?us-ascii?Q?Si4Vo1VKD6muio8J7AWya3u/tOdgoEa4ud4gdcJH3G1l+Fae/zPEfVxKvf2F?=
 =?us-ascii?Q?qwflvEnjXMzIejxhsBOpxvFKwf4iWLAMaTkouwsFYhlsT8YF3rcxKdFY3Hu9?=
 =?us-ascii?Q?4HQvYs/sCeWhOo7PZJb62qOHxPOOHyZcG7ZbZKBaR6aI6y13YqUryFsnRQcP?=
 =?us-ascii?Q?C+PxRzctJPSNhkX4qs3NXOXu8AXfzKFkvQrDkjFRbOfAdsXeirXd7vvruJ8L?=
 =?us-ascii?Q?aQ7Jy7yI4CEie+03yKbJyuYfxVtynh+BR13xfXbDNuYwgS9J+JzBxK1WLmCz?=
 =?us-ascii?Q?gjAUsrTcAcy3hM5DNrEFzS3CpwrSz8jMjDHsMjpE/4OMI8B4C+a0aj+1F45n?=
 =?us-ascii?Q?p/Gahs9iBQdLj66d+ShoHCGkmTKPSOIbnmczAki/FO5dlHgSHvJbUyO62SRJ?=
 =?us-ascii?Q?y2wAtYBN1ZgVZpixprRgQBhAkj8OS7bXGPKvziRLs0OmwMrhsp8xftR8pm8l?=
 =?us-ascii?Q?gbLff8C/gV5iiGm3TcTO1gfpmIUFONlvIFTgcjaox0SWsiO6taL/a7MXjxE9?=
 =?us-ascii?Q?40X+IvLD2Go8YOC1A0BH/eIhSlhRWMqMXNfvoL92?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf717634-b701-47c6-d42f-08dc54431cb5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2024 01:04:00.4740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bizc3hhPRKIhLpuvj3DVFwUXHNhBbXfA6j6otdO2q9rPHnGAfNwZLa6TSDaYvuw0sUIHycTBWGmRz1M+ZaOW2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6532
X-OriginatorOrg: intel.com

On Thu, Apr 04, 2024 at 11:13:49AM +1300, Huang, Kai wrote:
>
>
>On 22/03/2024 3:17 am, Yamahata, Isaku wrote:
>> > > +
>> > > +	for_each_online_cpu(i) {
>> > > +		int pkg = topology_physical_package_id(i);
>> > > +
>> > > +		if (cpumask_test_and_set_cpu(pkg, packages))
>> > > +			continue;
>> > > +
>> > > +		/*
>> > > +		 * Program the memory controller in the package with an
>> > > +		 * encryption key associated to a TDX private host key id
>> > > +		 * assigned to this TDR.  Concurrent operations on same memory
>> > > +		 * controller results in TDX_OPERAND_BUSY.  Avoid this race by
>> > > +		 * mutex.
>> > > +		 */
>> > > +		mutex_lock(&tdx_mng_key_config_lock[pkg]);
>> > the lock is superfluous to me. with cpu lock held, even if multiple CPUs try to
>> > create TDs, the same set of CPUs (the first online CPU of each package) will be
>> > selected to configure the key because of the cpumask_test_and_set_cpu() above.
>> > it means, we never have two CPUs in the same socket trying to program the key,
>> > i.e., no concurrent calls.
>> Makes sense. Will drop the lock.
>
>Hmm.. Skipping in cpumask_test_and_set_cpu() would result in the second
>TDH.MNG.KEY.CONFIG not being done for the second VM.  No?

No. Because @packages isn't shared between VMs.

