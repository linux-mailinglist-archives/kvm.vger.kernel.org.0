Return-Path: <kvm+bounces-25931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 789D196D3D1
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 11:46:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2DECD289E44
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:46:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B10A199240;
	Thu,  5 Sep 2024 09:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MnDOTH1i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DC819882F;
	Thu,  5 Sep 2024 09:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529518; cv=fail; b=X+/TT5EelxApaSjs42vskRPVYS1qDJEwEcqv9KokbP/ssjrUln4WkyMoDDVeFhCWN9awBDrEqpBmg0q6zWR0FbaPxRvCOM+a4lQa8mrWFLGcn3A8ndTZXUDRap4QiOeCMv8BKAtxKMpyVKvVGiCkdvr5CpEwzr65fId0SDboCFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529518; c=relaxed/simple;
	bh=P6igkgQA/4w082YVOjDb6AkfzCuyoOfgAu8M65nMf5E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uY8BYijQx6VuDnbqx8d22Z/Af4IB+YavSQ7IXr1WDPskBMjCK0NNL5up2AUa4Zrsd6x/7lTz4MGCIMl/Td+aNhSTzDqQjZ1s/O6N/vUKqRbMTlYi1AKUXVsUNwsAvKWfT4bf4v3phD/gwU5OEdC6WD1AXM5NdHlx5B6rYq2E6zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MnDOTH1i; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725529517; x=1757065517;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=P6igkgQA/4w082YVOjDb6AkfzCuyoOfgAu8M65nMf5E=;
  b=MnDOTH1i7za4W0ed+SiuVmXQTghNfTe06rivn7WyKhlLMmqApd5LJZPr
   MACgmjL2IsBT0jDhdd7xHtSgrQUWc1QfuZ1Kw9zw/FolJJ+lhLKbjA6Gz
   4HUDA6pYrb3xO62vgWDpLZYM9AiRzZtSrR/mG33fYT8y2wuGDgcU/PwRE
   2NTChYb6yh8BN7D/IBgHVKBPEnIyMIHrSBi01CuGoFc/tGGn1rYBB9LaX
   74nq3drHxQCMNXYSyFuO2nJ3cJ+bKYtq2YR01P4U0/7le+RbmPfQZBy+v
   fU905gUjN0IdXto/WvhgCS3acFvzvhwHFLRHDK5Lo3HU1EqoKyE6N1WPp
   Q==;
X-CSE-ConnectionGUID: nBFCgqgVSrODBQ4H996rqg==
X-CSE-MsgGUID: tE9uvGz/R6GWLIebjFCEFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24037476"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24037476"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 02:45:16 -0700
X-CSE-ConnectionGUID: 9QUjZHIpRbmF25qfMFZFHw==
X-CSE-MsgGUID: jCkAmLnrS/6vVc4g1MV7Tg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65615856"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 02:45:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 02:45:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 02:45:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 02:45:14 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 02:45:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pqg2RVJbR920tjov217ZwU9fYZAR7aTr1V12evaY4341KWdGvwIC33dCl78G9UdLdDrlHUN9JNdnYsPZhKnj4TG1Qwk11ypDKj1HY3JKKmEwHyLhQIdfTr2+RaorZ/vuL6YDYsfKZPqy10LtCusrvIFIL47MTyotyZ01cg+HyCICVS1oSkbpeFesRcZrapoxxF2swZbOXlHrSNkmg1Nh8TOEjP/E8FJYiqAPWoIDYIR2kNxBXfm3KNdyJ9Tfd9zIcyFUTzw2H6ebeseLcrwFUIvox5nW+4xNS6y6VsBFBERNpQfpN0rSnqWZ2psdQOhFUWa3xF95zxsFAiWTe0wFpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gdRsIibCh5LWwIJ9DFVavvOdhw4qD7bvVZx4uH8i2UY=;
 b=rFDFhpdxQWjZOBcJpomLYupgvXnT4A9dPfX/zyQ9DqFB/0udNw8t4QwavgOLFMggMvGRiIfEGl6RUnHT8nI2sA9JExx6aQIo5Tr6RAOIpjJcKmolXVhNr8t37XtdGvYKyiUOf8F8k03u4/upsEzRvF6qMzydlCN7AZvYWPma8nIBfdN4SG5Fs3fKSRmo5ye14K0BF4HqF4mNExnL66USouZLAMnSEYINoZ5dDlxqIhgB3gIBODAjEMwZBPEbdt0qeHMRRiyMSWGv0RqseUpjqcDUcoXyrrPJ91HCuRBUvVRB0guUtQce8A48tgLjTucmHErw4Rdf2LwbYEcEjC6ZSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB4996.namprd11.prod.outlook.com (2603:10b6:303:90::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.27; Thu, 5 Sep 2024 09:45:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 09:45:12 +0000
Date: Thu, 5 Sep 2024 17:43:17 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<rcu@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kevin Tian
	<kevin.tian@intel.com>, Yiwei Zhang <zzyiwei@google.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <877cbyuzdn.fsf@redhat.com>
 <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
 <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com>
 <Ztcrs2U8RrI3PCzM@google.com>
 <87frqgu2t0.fsf@redhat.com>
 <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
 <ZthPzFnEsjvwDcH+@yzhao56-desk.sh.intel.com>
 <Ztj-IiEwL3hlRug2@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Ztj-IiEwL3hlRug2@google.com>
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB4996:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e90538-412b-4ae3-f6b7-08dccd8f7007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vk9Rqzczh/m7ydV5jG+eKysedQMTYvP3I1v7s6Au/YnFmQ0xn9rLLm+lGLFm?=
 =?us-ascii?Q?8J0MFNW4xs7031PxDLnaNxJhKxur2SVIicQhr3Ecp+N7AoArpWhxMLYKpNRi?=
 =?us-ascii?Q?d1nGsSmWoggFFLzkLBFB/gT2EqJ/5JmNjGQxyeVaMeiA1E4i1B+Ho6yHTrc6?=
 =?us-ascii?Q?cDif9t03cGjBe4xXcDExnA8jt+hoAI1tkxLyECuORslSp35guu0WU5WqEYWn?=
 =?us-ascii?Q?NJhKiERlw9QyfFeMUSvEv0ncNavDT6ZHguwrTmodtWYxakroeTiGDAVTDywk?=
 =?us-ascii?Q?Ab/W5XNF8fQTbIdAiLnfUHoeO2Am5gDfx0vS8WiM9IApfboS0cJOju1vD0Lk?=
 =?us-ascii?Q?uWlRww8sel9SvZ/21b8d4d8bwRAB5QALNQcKGUxmmSeAUWUKWWKUMukDqpyL?=
 =?us-ascii?Q?qAAjZ83HHkOPQRlv03ukKwDIesw2oVi0UOdHCGSXB3tH1okdHmGYi+DAibxZ?=
 =?us-ascii?Q?IFZwDsYdFi/gTKBffGcno2BHyT8TiM5zM3/Y6Z3y1DZw1XL1UfMxRrwhlwl/?=
 =?us-ascii?Q?YrMnHlxffKf63j6/gU5CL4ExkXjzKA8GDmqW9g2JikCJeXwe1i3FZq02s/vT?=
 =?us-ascii?Q?qa1frYO1TYCmbamHWxIESvNLlGCI21WD0bXGC3BC3UNkHXO0MIm/DQW3+7st?=
 =?us-ascii?Q?3G2PjIZ+rTqhZoTinggtrkvhLatcYxgmKcJWoXTmXW78pWlibqHUVQX+fWpr?=
 =?us-ascii?Q?xhQyYkLX3TM7dyQfVl/pNv8uJMAaOlpJR0Cj/NMHd9ofFc+gbplqEv0LQg2G?=
 =?us-ascii?Q?ATNvJBeUIpqTMMPEtrSoblC4JHMh1Qr0kC/wOeq0GdPgvpBRNLP58jJJ7pgz?=
 =?us-ascii?Q?YhhuUid4VSuvC+35IDdLHhGlHhMykeVWKv5wqPhmVAWDtCevXkkiFQjN2Q01?=
 =?us-ascii?Q?RMEKjbUTlRl0DC1JopGFWu8LTagdMB7tpm+zEXLNmFLCLdHlcZyvI2S7FQgq?=
 =?us-ascii?Q?4ZeNHpLvAjRs2EdIjo1bES+oxeuqmnbn0CmDQWDq00EFMZZIHtbxqTxQN1Mn?=
 =?us-ascii?Q?DLrCNZkqbHW+UsnzKxaY4TT2UDPZbF0cXBWP0ecGE50y4gOM7LRZPeS9FOgK?=
 =?us-ascii?Q?zuhZ4dFPCILNRfhtEnnhaTghyOOH7xbu8Hk/pLHam9mOnaPfuiA0jb4IjJ49?=
 =?us-ascii?Q?l/mZFu9NwH/KWHP0Z8Pn8RfgbCW5+Td5UHokab/jn6CL4U8feKMR1EcpYwWz?=
 =?us-ascii?Q?dVqxXA4OEKDgW9lWoXU0LkwHaoYrVFDOXMQ5ehpE2eU+LnoxK1d+JmJ7jTnO?=
 =?us-ascii?Q?d0WB0HSUDHmEJb8Rqj85qcwnOppKEKTLedqTrRhoCURqVYZZfkQoQp70lceo?=
 =?us-ascii?Q?58/dnI19hfC2O5lBjks6Zn6kwsUH1VRWOUNMbO4acpgAnw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IqL1SprAXp4XqJ2CkrNrYnmiVHS7lmWpS6SDbnkWlRqQKtw9QLPh0XY+MTue?=
 =?us-ascii?Q?72wvhyPmKQUJ1hgFk1sNBRt7unndv72hsauacCL1qGMquWnI1FkEhs046i3C?=
 =?us-ascii?Q?lE+7/vvueH7tIqm7EsktICO3x6we8yBNv8BGCteJuJDfaq2rtsHZhzaF3Bev?=
 =?us-ascii?Q?muugquW/KC2WdEWddRnFIwLw2bJ0OTHIpHWF4JG+o9OtKpsCYJEYtlhaXcRS?=
 =?us-ascii?Q?VXkO+oW/Kl+MavXmcn3QdGZusbXuh6OqgTJidJu83k8tmnHGR4WMUiDelVON?=
 =?us-ascii?Q?GmH1VFByh3SfidxdZA1kjxM4j1gbz0SOyErS3DvzCaCZ4G6De0t3oGdKIE5u?=
 =?us-ascii?Q?KiP/9z8LbBVpWYhXWDxMQilx4GAO0rXiGbrV6GCy6RZmX0AqfA7a0OKJaRT7?=
 =?us-ascii?Q?/7Dtd7FROHEshwpmtcHUQLpj8eSc5famrLesIX0/kJFfb9GQbXrH3nds6Uo8?=
 =?us-ascii?Q?smcluHTOm+aZirivKLBzNKIY1uAoRD+78WQQAP8IwQByeq0JxcZdCvw6VdXc?=
 =?us-ascii?Q?UOZMV5v4+LoH+vISYV9CN4J2p7347+RnqwQiPpEj7GW0vjgfP23LWVC07gwn?=
 =?us-ascii?Q?U4TikMVDErC5aMj4ErHtIQav7TkSD5rQiVE+JXIYMYRvLEr4HKiDA8touuof?=
 =?us-ascii?Q?uuT+ur1ijBP9sWZQoNhOv1e+kJ2N95uHkLjY561ObCQuU9RyKELBZQPokxZm?=
 =?us-ascii?Q?lYvEK9UoENJkX0LjvGuPKXDKQw6HoT8Bzg3IZgzGVw/8pekCZazUwb/QtT8B?=
 =?us-ascii?Q?nN/CtpU+wvj26zOiwljf/t1o7rW8FhcnonGf6pI0p7aWekc17/AZsBMIv37Q?=
 =?us-ascii?Q?nEZF5s4cYiO+jajGzJo9XlEycJqE4AAeXcBlxv6pO4itF+Orm2TKs7GI5OUK?=
 =?us-ascii?Q?EmJgYegw+uxfjM/DB5PacnTjkfwWkpIFwEGTxNIZuHwXPtsc3w37l5wUG2Wm?=
 =?us-ascii?Q?H6Qp7zDBGydQZ5nEyyHi6WKsMpJ9TFojZ2KJJ7K3R2l3lvuopqhVBNCh9kO1?=
 =?us-ascii?Q?6RqyaPpONVytAab/eam/9hGCiTcwcfmRYzGegET3hO1C+0fvBum+six1clI5?=
 =?us-ascii?Q?Yy2oANq8eQBloVpkh1zq9a0gEz9p3qD8KaKfIzTgjYWibbuEJBCCG9sMIdXx?=
 =?us-ascii?Q?PXZ2V0WwkS91CVOHWTmTTQ1a868QuIelyZDS/gnUcgBODVv8zGO2KT5+y42s?=
 =?us-ascii?Q?Y1ALPeLMSxdjOEyNGkqVVbVRavVADWLMjvjCQcj+bih7ISs80Xsa0afauQ68?=
 =?us-ascii?Q?JUPwWlH7vjYz3OFugPfkDqtvOw2wCqbLAPqRnfTkttuBsVARJ3OpqUQq3Uov?=
 =?us-ascii?Q?HFVDZubpflh/3cvFWbK0yBNjvG1hm4reWPD9KoYhBdKaxWlW5TgljzJffCBi?=
 =?us-ascii?Q?iVD9P3OHzhOE9jzQz0HEb0q08eJHCYlh8e7pGfDpgzXjDrYgqwj4FrLRqiQP?=
 =?us-ascii?Q?1FwJINJ3d0CAJgLzb8eTCks1ssHMeR8cM3sF1rp1k7mvOL/+wzLa2Pi1sU/X?=
 =?us-ascii?Q?BN79NP8vARwgVVCpKmV+GG+sNihM/1H2WUNUQW4YntkBpqbxPXV+77TNNYXK?=
 =?us-ascii?Q?2OOUdSWf5AM97qQt/g+IupJtFe95nyulr63xtpUF?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e90538-412b-4ae3-f6b7-08dccd8f7007
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 09:45:12.4784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KmrBF+AUvaEN1eNEiC3e2CA0SQRTUWiwuAnNasuzMzmBheZnBLJKSIb2EemqW8xDvlJuSyZq+IU/PcSTvp+/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4996
X-OriginatorOrg: intel.com

On Wed, Sep 04, 2024 at 05:41:06PM -0700, Sean Christopherson wrote:
> On Wed, Sep 04, 2024, Yan Zhao wrote:
> > On Wed, Sep 04, 2024 at 10:28:02AM +0800, Yan Zhao wrote:
> > > On Tue, Sep 03, 2024 at 06:20:27PM +0200, Vitaly Kuznetsov wrote:
> > > > Sean Christopherson <seanjc@google.com> writes:
> > > > 
> > > > > On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
> > > > >> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
> > > > >> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
> > > > >> Silver 4410Y".
> > > > >
> > > > > Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
> > > > > on another hardware issue?
> > > > 
> > > > Very possible, as according to Yan Zhao this doesn't reproduce on at
> > > > least "Coffee Lake-S". Let me try to grab some random hardware around
> > > > and I'll be back with my observations.
> > > 
> > > Update some new findings from my side:
> > > 
> > > BAR 0 of bochs VGA (fb_map) is used for frame buffer, covering phys range
> > > from 0xfd000000 to 0xfe000000.
> > > 
> > > On "Sapphire Rapids XCC":
> > > 
> > > 1. If KVM forces this fb_map range to be WC+IPAT, installer/gdm can launch
> > >    correctly. 
> > >    i.e.
> > >    if (gfn >= 0xfd000 && gfn < 0xfe000) {
> > >    	return (MTRR_TYPE_WRCOMB << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> > >    }
> > >    return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> > > 
> > > 2. If KVM forces this fb_map range to be UC+IPAT, installer failes to show / gdm
> > >    restarts endlessly. (though on Coffee Lake-S, installer/gdm can launch
> > >    correctly in this case).
> > > 
> > > 3. On starting GDM, ttm_kmap_iter_linear_io_init() in guest is called to set
> > >    this fb_map range as WC, with
> > >    iosys_map_set_vaddr_iomem(&iter_io->dmap, ioremap_wc(mem->bus.offset, mem->size));
> > > 
> > >    However, during bochs_pci_probe()-->bochs_load()-->bochs_hw_init(), pfns for
> > >    this fb_map has been reserved as uc- by ioremap().
> > >    Then, the ioremap_wc() during starting GDM will only map guest PAT with UC-.
> > > 
> > >    So, with KVM setting WB (no IPAT) to this fb_map range, the effective
> > >    memory type is UC- and installer/gdm restarts endlessly.
> > > 
> > > 4. If KVM sets WB (no IPAT) to this fb_map range, and changes guest bochs driver
> > >    to call ioremap_wc() instead in bochs_hw_init(), gdm can launch correctly.
> > >    (didn't verify the installer's case as I can't update the driver in that case).
> > > 
> > >    The reason is that the ioremap_wc() called during starting GDM will no longer
> > >    meet conflict and can map guest PAT as WC.
> 
> Huh.  The upside of this is that it sounds like there's nothing broken with WC
> or self-snoop.
Considering a different perspective, the fb_map range is used as frame buffer
(vram), with the guest writing to this range and the host reading from it.
If the issue were related to self-snooping, we would expect the VNC window to
display distorted data. However, the observed behavior is that the GDM window
shows up correctly for a sec and restarts over and over.

So, do you think we can simply fix this issue by calling ioremap_wc() for the
frame buffer/vram range in bochs driver, as is commonly done in other gpu
drivers?

--- a/drivers/gpu/drm/tiny/bochs.c
+++ b/drivers/gpu/drm/tiny/bochs.c
@@ -261,7 +261,9 @@ static int bochs_hw_init(struct drm_device *dev)
        if (pci_request_region(pdev, 0, "bochs-drm") != 0)
                DRM_WARN("Cannot request framebuffer, boot fb still active?\n");

-       bochs->fb_map = ioremap(addr, size);
+       bochs->fb_map = ioremap_wc(addr, size);
        if (bochs->fb_map == NULL) {
                DRM_ERROR("Cannot map framebuffer\n");
                return -ENOMEM;


> 
> > > WIP to find out why effective UC in fb_map range will make gdm to restart
> > > endlessly.
> > Not sure whether it's simply because UC is too slow.
> > 
> > T=Test execution time of a selftest in which guest writes to a GPA for
> >   0x1000000UL times
> > 
> >               | Sapphire Rapids XCC  | Coffee Lake-S
> > --------------|----------------------|-----------------
> > KVM UC+IPAT   |    T=0m4.530s        |  T=0m0.622s
> 
> Woah.  Have you tried testing MOVDIR64 and/or WT?  E.g. to see if the problem is
> with UC specifically, or if it occurs with any accesses that immediately write
> through to main memory.
> 
> > --------------|----------------------|-----------------
> > KVM WC+IPAT   |    T=0m0.149s        |  T=0m0.176s
> > --------------|----------------------|-----------------
> > KVM WB+IPAT   |    T=0m0.148s        |  T=0m0.148s
> > ------------------------------------------------------

I re-run all the tests and collected an averaged data (10 times each) as
below (previous data was just a single-run score):


T=Test execution time of a selftest in which guest writes to a GPA for
  0x1000000UL times with WRITE_ONCE

KVM memtype  | Sapphire Rapids XCC | Coffee Lake-S
-------------|---------------------|----------------
 WB+IPAT     |     T=0.1511s       |    T=0.1661s
-------------|---------------------|----------------
 WC+IPAT     |     T=0.1411s       |    T=0.1656s
-------------|---------------------|----------------
 WT+IPAT     |     T=3.7527s       |    T=0.6156s
-------------|---------------------|----------------
 WP+IPAT     |     T=4.4663s       |    T=0.6203s
-------------|---------------------|----------------
 UC+IPAT     |     T=3.4632s       |    T=0.5868s


T=Test execution time of a selftest in which guest writes to a GPA for
  0x1000000UL times with movdir64b.

(Coffee Lake-S has no feature movdir64).

KVM memtype  | Sapphire Rapids XCC | Coffee Lake-S
-------------|---------------------|----------------
 WB+IPAT     |     T=2.6142s       |       /     
-------------|---------------------|----------------
 WC+IPAT     |     T=2.8919s       |       /     
-------------|---------------------|----------------
 WT+IPAT     |     T=3.0966s       |       /      
-------------|---------------------|----------------
 WP+IPAT     |     T=2.4933s       |       /     
-------------|---------------------|----------------
 UC+IPAT     |     T=3.4606s       |       /     




