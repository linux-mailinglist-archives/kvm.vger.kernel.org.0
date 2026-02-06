Return-Path: <kvm+bounces-70430-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FOKFey9hWmpFwQAu9opvQ
	(envelope-from <kvm+bounces-70430-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:09:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E81B2FC848
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:09:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ED145300C0C0
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 10:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CB5B3644BA;
	Fri,  6 Feb 2026 10:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYQ7ES6t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3B535DCFA;
	Fri,  6 Feb 2026 10:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770372581; cv=fail; b=av+m4ZpccuT8Ed13Jx/AUCspBqN8LDnPl3D6kTcfyYCRIK0H+iX9ixw/mh1LpMUNGjJ+PB7b0nsEUl25EPVi7pGnyOr507oUoUO4UFybFrvWw8saHQUicJu0wZ8MDxJH7hLsIJ3TaB9WLMNP8HHq9CGQmakh/6G6dWO5aCFvf9A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770372581; c=relaxed/simple;
	bh=Iu+WDqdRkSoTw7L/gr2jk2c9IeOX7qKWPTR/FxQgZt4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=meOBQqXkSdnSTyDbAfMt31UGoWh+GxrGyZN9e1KZQdCxG4HQ9bOtwhBWCv11812Dg8JDXL+SJhcXDkfgQAU2QDiUYfnPM5eBhe4/cePZHPjDsxXf4Lr/yz7d+ZjmTrwzMwhBdvhQLUi4crWcghzRrcBm/vCRZIuZT7MuBbWPBUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYQ7ES6t; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770372582; x=1801908582;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=Iu+WDqdRkSoTw7L/gr2jk2c9IeOX7qKWPTR/FxQgZt4=;
  b=CYQ7ES6tflrj8G8gdYxc7FX6p6SbGTXQzJaCAVoSQ6uV+ztwcQ5k9Jnd
   rx2YD1mqpEGlE2/qJ+kJPYObeYxWFQEYbWa1mJr2KJ+6VocqBjUaBD07K
   ZA2J8YSMyDtEthFgf1pkCSnN32aj4RsjY9/f+60HW4JaM6NBBT/LmfMFq
   1FLV3Su/96b6g9VlTfMpSAEgotV1eA83vJ8FF2xS9HhnIqXv4MiUSC4Am
   88XNyt2ROqyEn47iMHIugDN70WZcGwDdcuQXQJuuc0pKDlPIj9q1bpzBE
   b9U4fjhheUzaqbwaGI389HGc1nZQ3TCikod5Vp7YfB9ZGZ4RRuQnlpcDe
   A==;
X-CSE-ConnectionGUID: MPNeGgNAQuuHWQLyz7DQ+A==
X-CSE-MsgGUID: 4wgXUjrfT76xoT9U25mjGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="83019886"
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="83019886"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:09:41 -0800
X-CSE-ConnectionGUID: qZpK4meTSLCNpicAiEaOCA==
X-CSE-MsgGUID: rRBBtIp7Qm+JIisujT4OJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,276,1763452800"; 
   d="scan'208";a="233773614"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2026 02:09:40 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:09:39 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 6 Feb 2026 02:09:39 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.53) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 6 Feb 2026 02:09:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qAPhgIlIwkWoHQzVRUQr6s8MtC8pF5Xzmg3jq4JIiyp7Jdhere1+6evi6/x1igfc+ketRkOkVI3Nsseb20qyTOD1DKbFs4H+WDCQQZufiOyoo5H7LmC4mR0j+lvi8/nf5pERMfPfGjjxH+wNxiuK1dQw2T3hZ8AfmlNQf7+LjNgVtJfLhlnXkX0epjkv4STudSHa0vZhFJipAmNBBEcbDRwBFjL53kKfLFTBEcG3UsF31RgUCAASnh/OW7Lgue3WqkWMzh+xAK452Ru5BGI7kXqJxfD2ekK7bOqLYL+a2M3jq/wUjix9P37vbeKb255QD/aGksBvq5vacdkgBwG4Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xWJJYx3IYtyciaZBzcMiNfQt3FtN80+5elmSLmn0SM=;
 b=kQLukfl6uZhXTYtOWHAtF0fxyOtI9tQXrgejX+NgdT/aaMJkrLv5xQ06DJTqoFfel6P2c5vFH0Ydyz+m/Esvgf157p1LG4u7ClgHQkeAismaIGVp4c2AjI92V8mBuPXtENdSA5L88DIF3+mVkzHOIuCGsNtxuLuQS2pS/BYgdLhX5hN29vL7Dk5T0EDjWtA3tnq6KyewS7c3GJYHneKwzSy7Sy5+xSnPDDSyCkqZY9RB7QxXsJDpZOV4c6p198e0HK6MOKPPgywQnO5sbsuq5G0HQgOJmhTclrlO6lGkBj0p4qeKMazr5CHEispC4dNCerbqRXmybmv3mKMYzOQeTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6893.namprd11.prod.outlook.com (2603:10b6:806:2b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Fri, 6 Feb
 2026 10:09:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 10:09:36 +0000
Date: Fri, 6 Feb 2026 18:07:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 37/45] KVM: x86/tdp_mmu: Alloc external_spt page
 for mirror page table splitting
Message-ID: <aYW9UaK7tePxDuyh@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-38-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-38-seanjc@google.com>
X-ClientProxiedBy: TP0P295CA0022.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6893:EE_
X-MS-Office365-Filtering-Correlation-Id: 07fb5e08-0bb7-4a7f-db8b-08de6567d51a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fZ2Vm3KTDNoLh96YCrHw0CmbAaz+CLLJlj/zEf7mhNUPVAIt50L5o6hS6zde?=
 =?us-ascii?Q?rgcMhyE7veDQ14nBAWx3MqDqicSPQx2HAKnV32qBooAHPivpW31utFPouamg?=
 =?us-ascii?Q?UPRB5qKkyeCmMFT2dRvwL+tBUG3LqkU7vUceQqO8WCcuiPaM37jOiKOmmt4m?=
 =?us-ascii?Q?2Hv9hIIzwB+BARZyF0FI12JQqDM8vKgU5Y1AnQ1SUIK6+USZHGbE7yf+CdGY?=
 =?us-ascii?Q?lx60euHhECK4tZBYAg3yXgu6FLOB2cm/PJ/xEeXmjgDBnImOm3lDWb8BIYXE?=
 =?us-ascii?Q?XqcZYxJFoPU2aQwPfZQCK07VzTtzqM2AKZ/EnQpLIDh07An4aU6zF2TCdkQd?=
 =?us-ascii?Q?wfwVwnMD3PY5JyZs22REWy3+FYjORBY9cRkBSGrcqCCCIBKAA5OsspCXeBP+?=
 =?us-ascii?Q?KUyJKOskJhfBNSy5PWCAFmjOydLEga41bx90pQRcO7T0b8yZKHVAs/trIyUs?=
 =?us-ascii?Q?B5aQcS+eDSo4DuynV9+DFRgI6OO4mnPBiCbyWrEfBGAfuo9lE8cROARQA8g5?=
 =?us-ascii?Q?f6FKrvqtn9DL2xgCV2NJhJjnFmCiT5ELnVGejsoDf2p2N2BUVqvwbrRYBsmP?=
 =?us-ascii?Q?1QW3xgijUa0JgoLoUYw8sFMNLJFyljJ4DC+2UnDL2E1LEZWeR9N0aLz1Mt8H?=
 =?us-ascii?Q?0FYfrs1ohRHYLxFAGgsVQ0xgfuWRoC0FCI30GooGkZozZKHYIh1Q68dt4/Ll?=
 =?us-ascii?Q?KZSsVzKgpqJtNegLn2PdvWGYGus0ji8h0ejAHBmKiG5b+DGcZQjYJGv5c/cz?=
 =?us-ascii?Q?mhMRvMFv0XKFVXCxmmW8RWKW/5z0iJ9QExunXwy3BwTPNIiYQEsUsRw9sMm1?=
 =?us-ascii?Q?JkAykvD/5FbcslkSNLMSuaBLOo+Y+bPmErX/vjqO//CHCaLD5pFRsRaUPQ/+?=
 =?us-ascii?Q?33sz3Y/p+XzDk56SI3QhNn4QOUE2kxi1lLW7/pO6anAZ4mbWFt8HLGmsJafw?=
 =?us-ascii?Q?YKto1eRp/vBLPUhmeInxgUz3kiejiBW1nO8vGXytF9V8+ylLA708d6xoqtfA?=
 =?us-ascii?Q?sYxcimD0n9VzZJ38Wk1AI463ZrA3C6BdQJYtGtcqiUKL5+MzuHQNwRRIKo1U?=
 =?us-ascii?Q?wW2HbwR/CeR8pLcTn/rC9mI3vQ39wWcDhqDil5Up58lPDxAMr+veXg1eNRHW?=
 =?us-ascii?Q?cbvVbEXXa7JUn5FmR7WgE/cpbXjviXzE0hRq+iOVwpxhDVvb2VUxpepp8tI2?=
 =?us-ascii?Q?fXCSGgaxGwtVPqjvCFLJl0Dz88b2uI6QZIjy/xTnRcg74fZUj20B22Xq0Z28?=
 =?us-ascii?Q?RzZs4k29M98qYoIcC6qP9Yqpi+VigLVSVPPVAhNET2+F/6E4Cpr31PpU3rXm?=
 =?us-ascii?Q?QF6ZUY3NTchOqzuz/bOmNEwWby5DnLc+wgiCT6IJVB6Pf4dJ3OQkmYQxmmFT?=
 =?us-ascii?Q?GjyAnvULkjE4h0kmzNCiW9oUwFOxPVoJ65nenzDDQOUIUL7SondSXlGurW3I?=
 =?us-ascii?Q?QZJTt7s6K3BNhS/8vQjJq/a/F0KxBHigqj1RRYw4tjuUufiCB7s7kC8upV+H?=
 =?us-ascii?Q?k74UXSzLHYCFw8wgZ2w3cyTeeO5fgfxDMq03M22x4WO+C6c0DNKUiR9F/tB6?=
 =?us-ascii?Q?gegIX40MDqmY/bqcByg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jpA2Hqo0LgemAtPiP2ejNKrIIAKLffH2AZHWBvm7NTBWoIuFP4TrxJ30CQgb?=
 =?us-ascii?Q?tb0T/DjPq5UKLAkLmTgJ2eJt7zUXMmHm4EbQa7LLnyDci1OAA0atNsDTka6Q?=
 =?us-ascii?Q?PAqjgnMdddKlD9QC1asP7WNCywitROlkMj4djcK7urbeLB/c1x8t4Y/A9zEv?=
 =?us-ascii?Q?C3ZNLGScX0k4+Y3CRc1qCrj+iX6hSRCt77M5qdBAIJ29eaXemhPjnp7CiT9e?=
 =?us-ascii?Q?BV2uiAmxd7Lf5wgtl3/a6z4mn4iWyccAup0a+YHVRuooV0cE/40OKs40pcSs?=
 =?us-ascii?Q?HKSOzJfmxW0M8di7T6GPoHBy1rmT0snh1nwWhZf5832wdZ2ZLXGV5IeX9Vbx?=
 =?us-ascii?Q?UKfM/tyc8p9vzEyqvggkK6SWAV81HYhvvuClIMGYTxUNjqufMbiHnZlsIKbI?=
 =?us-ascii?Q?+hOzYCNNNhndLWYVdiY56R8taBdRXQT36EY/jBjzQmtBg0viBEYjuNGUiXKG?=
 =?us-ascii?Q?ytYCj5OIKmEyBmo1yaz3vEOzWm1n+8tfXEkzwWssCNx3hIbXTfxEjFvXVi6D?=
 =?us-ascii?Q?MlDyP6jen6dgUFNKf3CQYtRJP2T+a9A4KCMOEu0zAZMDa6OfXi+Z/MyYdXTU?=
 =?us-ascii?Q?j1w6BOGNh2IZc68+GhgGk5WE+iR6AZI91w2vIaadCAAh3yE4ZfqZcCeLI6MG?=
 =?us-ascii?Q?vopNy50Waad0PVL/d3u378qOGDT51gxWzXV84h41uasCZuTm0HuanNZI5u2t?=
 =?us-ascii?Q?Hj1tpM74jLfuD8NeB/hgDMgD2vnSI5Qinw2w1SlvIfMrJ8ucLKrCtT6rBBZ0?=
 =?us-ascii?Q?Cabmq+RobygxRvFxdOtUi74duFdjwM+G4hV7Jsn8n5dvl7TIBD2nK7qw5QQN?=
 =?us-ascii?Q?iJe06gpe+kVoG+Plhv66cILacGRwyyCK/LEuXy1WH0fVVuHDDwg1+b9IuVFa?=
 =?us-ascii?Q?GY4+s2307tZQBqriCOsm63ee84ZgydX934KsMlg58z+VW1Zq2nb7Wakch0L0?=
 =?us-ascii?Q?0yuTfva6FMjkL9taw0HFQqmK+6/ZxigLKPe2doP2jWdzcYORjMwzJ2y8eO/e?=
 =?us-ascii?Q?M2nXSOOCdyCgJpQcIZ9OA/+w2TjQes/HwVSdx3Czrmt53lrth88X279a3UG9?=
 =?us-ascii?Q?tFkN73+K9xMoPvT5Qw4B++fPebBjk8Ekdrx73SXxPao+Ydm1Q/lNzHtwHaS3?=
 =?us-ascii?Q?Ay0d8x05ekX5CVDbPPaeN/p7sWf+Up/XsoC8GkQdhe7IEOLJk2CQ4in5Yxrf?=
 =?us-ascii?Q?OUu8Jm9IBzIrL63yLSgvCAzFjJXNHCsaJu8rtZDGPqPKYuQZZeQZFSukm0er?=
 =?us-ascii?Q?kHGpm/70SZpybNL+LQ53A4lAJFl8JtzEso5ES0t9WNFGpjvH87Ka8tjurql/?=
 =?us-ascii?Q?l/jK3IfkKts8I6db2upuqMX3TiswCqBLh5bKfvFkqUIOTlMvp2l/97lmZDNM?=
 =?us-ascii?Q?GgYVeTqdIWhV4dPUcVGjME99Hnq7/QqGbv6TF+W421wBsBYBlr/Z3GhITNJa?=
 =?us-ascii?Q?HegWX/VYXctzlrAOY3JGAcxJ9kV3amDWcfOCl76eZlReAdiG3D8PXofqn2yq?=
 =?us-ascii?Q?IC+MV9jykClZytRZ4CeNUblba2ybqHSlzRBopvXUWQO+36puYfr3tNMszd4j?=
 =?us-ascii?Q?blGHSLvscgNZNztP7ndpfCdU2j46RzYSdJwTrMMlGE39XZh6+Qu602k0lDrD?=
 =?us-ascii?Q?NIKPbyW4RuoiHM/vZBoYRulCPa6DdlDFXaRGfS98Ucq31VvVeWBUS6upk4R8?=
 =?us-ascii?Q?OpJNwcJjLCsfwhOb+KF9x4f1xe6tVcgkECAfUTCe26+ZrlbekjOjv4ryoK/x?=
 =?us-ascii?Q?cEt+SeKskg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fb5e08-0bb7-4a7f-db8b-08de6567d51a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 10:09:36.6280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JtjLR9oL7xGi687+0CZ7EiQYbUaeYVEBhMJHsO61IweYv8BlqgBsGZhxvCW/ky1fi1MER91RdrdBHJidSLXng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6893
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70430-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[yzhao56-desk.sh.intel.com:mid,intel.com:email,intel.com:replyto,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: E81B2FC848
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:15:09PM -0800, Sean Christopherson wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Enhance tdp_mmu_alloc_sp_for_split() to allocate a page table page for the
> external page table for splitting the mirror page table.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> [sean: use kvm_x86_ops.alloc_external_sp()]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3b0da898824a..4f5b80f0ca03 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1447,7 +1447,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
>  	return spte_set;
>  }
>  
> -static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
> +static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct tdp_iter *iter)
>  {
>  	struct kvm_mmu_page *sp;
>  
> @@ -1461,6 +1461,15 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(void)
>  		return NULL;
>  	}
>  
> +	if (is_mirror_sptep(iter->sptep)) {
tdp_mmu_alloc_sp_for_split() is invoked in tdp_mmu_split_huge_pages_root() after
rcu_read_unlock() is called.

So, it's incorrect to invoke is_mirror_sptep() which internally contains
rcu_dereference(), resulting in "WARNING: suspicious RCU usage".

> +		sp->external_spt = (void *)kvm_x86_call(alloc_external_sp)(GFP_KERNEL_ACCOUNT);
> +		if (!sp->external_spt) {
> +			free_page((unsigned long)sp->spt);
> +			kmem_cache_free(mmu_page_header_cache, sp);
> +			return NULL;
> +		}
> +	}
> +
>  	return sp;
>  }
>  
> @@ -1540,7 +1549,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
>  			else
>  				write_unlock(&kvm->mmu_lock);
>  
> -			sp = tdp_mmu_alloc_sp_for_split();
> +			sp = tdp_mmu_alloc_sp_for_split(&iter);
>  
>  			if (shared)
>  				read_lock(&kvm->mmu_lock);
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 

