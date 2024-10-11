Return-Path: <kvm+bounces-28576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD7B999A01
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 04:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9567F283718
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 02:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9502B28684;
	Fri, 11 Oct 2024 02:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G48Zyt3b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC8A17BCA;
	Fri, 11 Oct 2024 02:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728612503; cv=fail; b=MrR8mCC5xuj3SJdUlNQIabwBR20l31lcwIRj6DuWGtIG7qifAZ77SstrPEpy1LD1FDC9ZFphN/1gIytOzBufpD3U/OZ4mUgxQZJzUoml9n51ldkhMnpOk9viCgwjxRhAWRHH6imFjtotHlKrVCRLAcQFu9p18fNIFPusDDx1wec=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728612503; c=relaxed/simple;
	bh=9Bjks4IWfredM21JERn4H4yILSQ5fsuAG/AS5OVylVE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JWWgCRedJU/9AKO7EGG9Stg9ZKE4QWFffrNXxiM26hQ54RZdywI3o9uR6szjoUf23Ho+j1tnZ2M4IThhPq/MbpF2Mo/xUGfTcoqKA2vbKl73VwgQWwbgrJ/gPzqbWA9D34Z9kHjW2OqYFsjNL6Xab0VBgyJEyVYDoSnijnN7LOo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G48Zyt3b; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728612502; x=1760148502;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9Bjks4IWfredM21JERn4H4yILSQ5fsuAG/AS5OVylVE=;
  b=G48Zyt3bf7FbHiiikjvnapHACPkIfNwy2C04ZwElynkHyRI16KWEnPFD
   JT8kbHCekaUV3C+NqBoMeJSgiVpDISDc7ozqlIMizKG0bwK0nstfD/aE1
   27tcI3711QOJuV+vp3om15h2q49GE7pM18Cjw+V97QBgwtmk59phZewus
   GVEFO3Hl/dSURVeF5IXJDkKH+CxKY8x+6ZhkXum0Eegpx47yeJPibzM2e
   Y1F5st7IZ1V1f4vUiucLOffRPeBFxYovypRtin/w5c0r0m5sl+NaQyDLC
   IjipWaKkYEbdUufPvNb4qmZMkJ+NOAhk/8SvLLZZHMli1Tn+ulcXhNAYI
   g==;
X-CSE-ConnectionGUID: Ci360QnhSNqUy2R5nSDGag==
X-CSE-MsgGUID: wHgli9tYS/unlh7OvN7Bpg==
X-IronPort-AV: E=McAfee;i="6700,10204,11221"; a="28132871"
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="28132871"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 19:08:22 -0700
X-CSE-ConnectionGUID: 1Reqh/gpQAWEUWESX5Wf5A==
X-CSE-MsgGUID: D0MU1FrOTn+gboasdFeYgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,194,1725346800"; 
   d="scan'208";a="76774251"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Oct 2024 19:08:20 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 19:08:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 10 Oct 2024 19:08:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 10 Oct 2024 19:08:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 10 Oct 2024 19:08:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CP+P4XNg/6JuZampfYyg/qOK1lsxNeutJFNGykQaW7Np3fWAYP+gLtLnmfOj99ouMfSYVsSgTCgAeOnquL0kZZljzI6P2hx67tLmGoPAnHqbmRohU6mb2zJon22WRZKtBoQ6CKXOR+nwpb9mRNS2YtK08Kt1LImwxnjWl4WdC++WY/89BY0AEtlucTmUEgIfdXQj25kypnTwB7ioSqt4vuo0GHer24mZ1dPT83MSv6cP7uIcxPIcY2rOXRG7ciffnPtSUFIIt/Xbr3NwVhdQ0a5rhXxr9k+nAThHDTAt45OaQPH0UXAqrKrRsfJo6iaiurNvFrdCFg8vM4QMqVp8hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJCJKaM5IsWhlha2qmE08WJKHrOVlNnwvfKJW3FvvT4=;
 b=BDQA8TPny5B3rfoKXJSsFaKCXB2UMg8ar2dmdgVuZBSgpnFsYq4B/zptQnbpuPZe3UtJvNsv/jPEKPV512hMSgHc3fn4nyzTfVl5Y2iCZfw/KkT8bps2e8L99sn2SrJIrKx0fpQqVM8/W/BukICQ/ujGmH1lmKGxMOyfOtmO3coboRTZXCccV6qlaWTX3faVpMwOYj6TD6RmV9fhy6J7xGc+Kg+X2X7F9LVrx6uK5vlCg1HG2i4yWcYbK47r1DQOyKGwR7eg8lCu4fucpwxL9YKej8qS7MDjLvsS3APthZenwuROrFrvtH7ESPVEKPS1FMObHhLW3MTbQWgW9V0aBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7595.namprd11.prod.outlook.com (2603:10b6:510:27a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.18; Fri, 11 Oct 2024 02:08:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.017; Fri, 11 Oct 2024
 02:08:17 +0000
Date: Fri, 11 Oct 2024 10:06:00 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Yuan Yao <yuan.yao@intel.com>, Kai Huang
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dmatlack@google.com"
	<dmatlack@google.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Message-ID: <ZwiICKN8trllBbZW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZuBsTlbrlD6NHyv1@google.com>
 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
 <ZuCE_KtmXNi0qePb@google.com>
 <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
 <ZuR09EqzU1WbQYGd@google.com>
 <ZuVXBDCWS615bsVa@yzhao56-desk.sh.intel.com>
 <ZvPrqMj1BWrkkwqN@yzhao56-desk.sh.intel.com>
 <ZwVG4bQ4g5Tm2jrt@google.com>
 <ZwdkxaqFRByTtDpw@yzhao56-desk.sh.intel.com>
 <ZwgP6nJ-MdDjKEiZ@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZwgP6nJ-MdDjKEiZ@google.com>
X-ClientProxiedBy: SI2PR01CA0019.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::12) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7595:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e0ff1de-dc59-41b2-a4a9-08dce9999130
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fIdMI6fvHKGwbkgb5NcepbYnqrL/+G5e2u+7heKNxuvpXXPclD6GvqrFJ/VW?=
 =?us-ascii?Q?3w8dbDN3+K+Ilki8m7Vj6Y7sgPuh6tprEuJex3LSnepkPZdOCjIPAsmIo2zm?=
 =?us-ascii?Q?QWZHDF/b7s1v7CLrUwZanCW3zdGVdIkmEMqh75WssU6Qx0phE7Rvbg0GhsUw?=
 =?us-ascii?Q?xyizJroiy1xMbp6chXcVQFSQZq50MNL3B0Z8SkgW+gCb+/eXvZtTxvJyQYiL?=
 =?us-ascii?Q?sv5EJxXITCqeCnoBhALv0j13I2sE+eS/cb0i59Zi9iJrDbKscmlID2trA32n?=
 =?us-ascii?Q?jS7S5UahorVIX2pDzPJfxXP0NaZhltbSLOjnFaES+yuYJ8jZP70HSsWGgEKO?=
 =?us-ascii?Q?yIw9xJO0CU2Y6Fcp5YnvO+Zg8olrEPJnJC1Gz/B69ebztEE0DxvTQLAlMiiq?=
 =?us-ascii?Q?PZ1wApRj86bhY2LHk6Re/CAMUuiukXlVHscwAWOFFVDYg7ba5kmlgS/PkeiE?=
 =?us-ascii?Q?ATujiH5sLU7P2svOGJx/Y0wBWTh8mhz613dCwWqWDKQRfXH3bm34ua9OyYcC?=
 =?us-ascii?Q?8XiAEb0DnNuajLPKhm9huzNse8nO3yuZz9m6rBGua7J6KIa4G50ZKDcnaKnT?=
 =?us-ascii?Q?I7h+ZlnuFpBATrpA0pz+S7zs3Vnd8ViYxluqEFmiALfeoY938q3VabYlZfeV?=
 =?us-ascii?Q?c4FkjouWMyJHyo0AOADpN0Fz2qyDpcq9kAhif+hPuag52sN7fpWtVNoHtRmk?=
 =?us-ascii?Q?87pZiqNImfmlfA/gTdPrHcHY6oyzBqhf8mcz4yyjYw+vqOtfXzWGa1/50rFM?=
 =?us-ascii?Q?0W1IRzjQwFUF+Hrymku54IYvvWZmzM/aUPH8KoC6ppz2heeVwizHDwmHv5S/?=
 =?us-ascii?Q?oAR6YFUtJLQuy+QHsJN3+ymHgIeEW3Wtp29VAYyoHhV01XYkjk4zUFGMVZ0Q?=
 =?us-ascii?Q?85+JBY+rEp57ubmEbvUIw4stQWSV+8OciFjfhKH2dg89B/NaRxTqzsx08lIS?=
 =?us-ascii?Q?5ELwtfOufezaW8iJcEQA1tDA1Z3qR4hvGN1SxYVHVsQ/3gp2lmmxtP+3BRG3?=
 =?us-ascii?Q?oC7pOXxMeItnZAuV2MZNNXOLsWjG7AXQ0dMpb/nnCLmjsi/vDe4ep3DZozoX?=
 =?us-ascii?Q?CIaOZ37qITdShyaGzsc9J3Hb/FX8ASXX8DcTPoYdZWouf2eygYhp7mXvDkMK?=
 =?us-ascii?Q?eGXNjCMn+bFPmtfmoFcAWXU+V1eij6KNmsY4f7FzWtUghsPAjEiwqyyjWGju?=
 =?us-ascii?Q?MAb+GfRyKPNbQZcYbyHGBpoAOXjmwlUA07F5aZZsDnJ0JFKX3r4peEEHiJuc?=
 =?us-ascii?Q?mRVZbUFw1VZfRlzoOnfh7QYpisBHfW2AH7K/efbUxw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CjK2AV+mMEuOwUQrK+7+4SlB7mjmwRLZ/eE5LZRetJOvV40rUHM90FSNlgIl?=
 =?us-ascii?Q?64EUqYFQS9wfRfsdaoy+ZruvnluJS9TKT7uHzOVvXTaE01ECxvGEpjzjsg29?=
 =?us-ascii?Q?56bfpe/yW0IjUVKko3HFcXogCRR74Hl7RKS3QPyRTubVd1uRdRFRjeMZtkOo?=
 =?us-ascii?Q?+KdwmH6Gnx73+xwjqxVWJRnFLj+XoJFBr/NRBN/sWsQq2TrpthUIgjmuw9gu?=
 =?us-ascii?Q?zKHN2k9zoFKv3GdBbiHgTQF7aIfAh7+KvLRYEz0J1hI1+F8YgYk2i1JSRLcU?=
 =?us-ascii?Q?9vKvjKont6kS7BIb98Q8F4FaWk+iuW9XAi/qsyzrcFiC4nFhaNZnWlMadlmT?=
 =?us-ascii?Q?pMffAW+7dqkqkCuEj83nh5C1Rgn3iUbUQxRFhZ6sR7O7IbL/21N7MQaL02Lc?=
 =?us-ascii?Q?z6+42bzupPjOFKLETIo+9j8v4z7yfgPz17ZR8irajW37lkWU2JCzdBU9me7Z?=
 =?us-ascii?Q?6kKUR63Ekn1LRFeYhjxiYFl6w6f8qkG31g4/B13A5qBBdKsjWGRpYzDw+n6i?=
 =?us-ascii?Q?09hiVu3m4alpNlevQOhUCyjbAd4r9qfTA8fGtNGhmhoaznGOMXf9k0I+9M5d?=
 =?us-ascii?Q?ZZ9fiTPm3dpV/bTXkeUxPF4r6uqCiEpS8dPdhMfO/hKADmabgE0De8wiBByR?=
 =?us-ascii?Q?5Y+o3XBtRlu/W1cKSJRAp/ybUqZbYd6+iGGbRCm/ZDFstby3PIGjHo+c+jgH?=
 =?us-ascii?Q?/FmaNwL0azgPu8Rk6ZVmsqPjEVBTKHmyqOBFehMwR1oy6IJMxOhkEIZqtZX0?=
 =?us-ascii?Q?O0WaI1vAH29eSOdU42UWZ5Gmdjbyq2x6AsRSa/YPTpCPtU/FYOX3m6pV3sTx?=
 =?us-ascii?Q?8T2kEhFlZneD/VqrXvDo+dEvNQt5JARe8izecoltAOxLzap/P3CatDMOUs1+?=
 =?us-ascii?Q?2Ytz7PvxfHpMzGx7bQeRiO1vW6wc+lPq2w8VTCEJJgavRxI/5l/ZbOlz+JO7?=
 =?us-ascii?Q?LuyKQBF8vlkTkUj/IwjGHFpF1TCRz9ElzBXK5lsciNKQn0qJWHDPVBTTeD7n?=
 =?us-ascii?Q?XvFrHO5bU0NwxdcZfBJW4CR4NieFzmVpg+3XGiGJ2QuV750QihxFAbpEP+mN?=
 =?us-ascii?Q?Eed6BaMdjtTd71qUuFuS0Hd8qEFtVJ3s9+EYD4C7DOsQ1WkDBpSnbg+F1LCX?=
 =?us-ascii?Q?GEOnyB2jDrNKRD6/IYInOJj7w4Tv3OUROLL+H3DOqExlkQ6x2gu7X2fYhVmD?=
 =?us-ascii?Q?Ufj/shzfnikOobRKilCmgnzVoFtXDr4rX9DCuwyZlLLtlNDVz0vIBL7eFYGD?=
 =?us-ascii?Q?2pbu3g9wU/ZAUvKIriOg7vOw7GhI+pTSkvHo+DRL3MuR9iWxGHepD56/IYEY?=
 =?us-ascii?Q?WrW47ffqxH1ZUFi45TqYGsN7pJ6Ftm+j1t6IN7B1fYqYNTKpimleqNRwwTE6?=
 =?us-ascii?Q?Nn3w78/+yZ5GFGFBnLwTbYilVgeeQYW48tcPmo0iOJ3+lVhjK3aDvKtkOXxX?=
 =?us-ascii?Q?j/5/ZzfVnAdEbUVf1KRuNjquDmDFsc/F7imCN3x8VB28mB5bcWYrs+Osu4y0?=
 =?us-ascii?Q?YP2SqoTH3Q0B1rsLRNzqs5+gjSV0tmHLEX7+pBAAEbW0X4GA/T40okQOXkye?=
 =?us-ascii?Q?HFR2zFi9IruUMA2ryjJiJbdCgcfxfsOPJf0YkkDN?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0ff1de-dc59-41b2-a4a9-08dce9999130
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2024 02:08:16.9768
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBS8DdiaL0zzp8xFYmvhJOC2zXMR2YeMq0DNWKL0hf7FTCZB/FcYjTGKhZoenZ6WuRMPL6OWpRIGh+OtpkyylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7595
X-OriginatorOrg: intel.com

On Thu, Oct 10, 2024 at 10:33:30AM -0700, Sean Christopherson wrote:
> On Thu, Oct 10, 2024, Yan Zhao wrote:
> > On Tue, Oct 08, 2024 at 07:51:13AM -0700, Sean Christopherson wrote:
> > > On Wed, Sep 25, 2024, Yan Zhao wrote:
> > > > On Sat, Sep 14, 2024 at 05:27:32PM +0800, Yan Zhao wrote:
> > > > > On Fri, Sep 13, 2024 at 10:23:00AM -0700, Sean Christopherson wrote:
> > > > > > On Fri, Sep 13, 2024, Yan Zhao wrote:
> > > > > > > This is a lock status report of TDX module for current SEAMCALL retry issue
> > > > > > > based on code in TDX module public repo https://github.com/intel/tdx-module.git
> > > > > > > branch TDX_1.5.05.
> > > > > > > 
> > > > > > > TL;DR:
> > > > > > > - tdh_mem_track() can contend with tdh_vp_enter().
> > > > > > > - tdh_vp_enter() contends with tdh_mem*() when 0-stepping is suspected.
> > > > > > 
> > > > > > The zero-step logic seems to be the most problematic.  E.g. if KVM is trying to
> > > > > > install a page on behalf of two vCPUs, and KVM resumes the guest if it encounters
> > > > > > a FROZEN_SPTE when building the non-leaf SPTEs, then one of the vCPUs could
> > > > > > trigger the zero-step mitigation if the vCPU that "wins" and gets delayed for
> > > > > > whatever reason.
> > > > > > 
> > > > > > Since FROZEN_SPTE is essentially bit-spinlock with a reaaaaaly slow slow-path,
> > > > > > what if instead of resuming the guest if a page fault hits FROZEN_SPTE, KVM retries
> > > > > > the fault "locally", i.e. _without_ redoing tdh_vp_enter() to see if the vCPU still
> > > > > > hits the fault?
> > > > > > 
> > > > > > For non-TDX, resuming the guest and letting the vCPU retry the instruction is
> > > > > > desirable because in many cases, the winning task will install a valid mapping
> > > > > > before KVM can re-run the vCPU, i.e. the fault will be fixed before the
> > > > > > instruction is re-executed.  In the happy case, that provides optimal performance
> > > > > > as KVM doesn't introduce any extra delay/latency.
> > > > > > 
> > > > > > But for TDX, the math is different as the cost of a re-hitting a fault is much,
> > > > > > much higher, especially in light of the zero-step issues.
> > > > > > 
> > > > > > E.g. if the TDP MMU returns a unique error code for the frozen case, and
> > > > > > kvm_mmu_page_fault() is modified to return the raw return code instead of '1',
> > > > > > then the TDX EPT violation path can safely retry locally, similar to the do-while
> > > > > > loop in kvm_tdp_map_page().
> > > > > > 
> > > > > > The only part I don't like about this idea is having two "retry" return values,
> > > > > > which creates the potential for bugs due to checking one but not the other.
> > > > > > 
> > > > > > Hmm, that could be avoided by passing a bool pointer as an out-param to communicate
> > > > > > to the TDX S-EPT fault handler that the SPTE is frozen.  I think I like that
> > > > > > option better even though the out-param is a bit gross, because it makes it more
> > > > > > obvious that the "frozen_spte" is a special case that doesn't need attention for
> > > > > > most paths.
> > > > > Good idea.
> > > > > But could we extend it a bit more to allow TDX's EPT violation handler to also
> > > > > retry directly when tdh_mem_sept_add()/tdh_mem_page_aug() returns BUSY?
> > > > I'm asking this because merely avoiding invoking tdh_vp_enter() in vCPUs seeing
> > > > FROZEN_SPTE might not be enough to prevent zero step mitigation.
> > > 
> > > The goal isn't to make it completely impossible for zero-step to fire, it's to
> > > make it so that _if_ zero-step fires, KVM can report the error to userspace without
> > > having to retry, because KVM _knows_ that advancing past the zero-step isn't
> > > something KVM can solve.
> > > 
> > >  : I'm not worried about any performance hit with zero-step, I'm worried about KVM
> > >  : not being able to differentiate between a KVM bug and guest interference.  The
> > >  : goal with a local retry is to make it so that KVM _never_ triggers zero-step,
> > >  : unless there is a bug somewhere.  At that point, if zero-step fires, KVM can
> > >    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >  : report the error to userspace instead of trying to suppress guest activity, and
> > >  : potentially from other KVM tasks too.
> > > 
> > > In other words, for the selftest you crafted, KVM reporting an error to userspace
> > > due to zero-step would be working as intended.  
> > Hmm, but the selftest is an example to show that 6 continuous EPT violations on
> > the same GPA could trigger zero-step.
> > 
> > For an extremely unlucky vCPU, is it still possible to fire zero step when
> > nothing is wrong both in KVM and QEMU?
> > e.g.
> > 
> > 1st: "fault->is_private != kvm_mem_is_private(kvm, fault->gfn)" is found.
> > 2nd-6th: try_cmpxchg64() fails on each level SPTEs (5 levels in total)
> 
> Very technically, this shouldn't be possible.  The only way for there to be
> contention on the leaf SPTE is if some other KVM task installed a SPTE, i.e. the
> 6th attempt should succeed, even if the faulting vCPU wasn't the one to create
> the SPTE.
Hmm, the 7th EPT violation could still occur if the vCPU that sees failure of
"try_cmpxchg64()" returns to guest faster than the one that successfully
installs the SPTE.

> 
> That said, a few thoughts:
> 
> 1. Where did we end up on the idea of requiring userspace to pre-fault memory?
I didn't follow this question.
Do you want to disallow userspace to pre-fault memory after TD finalization
or do you want to suggest userspace to do it?

> 
> 2. The zero-step logic really should have a slightly more conservative threshold.
>    I have a hard time believing that e.g. 10 attempts would create a side channel,
>    but 6 attempts is "fine".
Don't know where the value 6 comes. :)
We may need to ask. 

> 3. This would be a good reason to implement a local retry in kvm_tdp_mmu_map().
>    Yes, I'm being somewhat hypocritical since I'm so against retrying for the
>    S-EPT case, but my objection to retrying for S-EPT is that it _should_ be easy
>    for KVM to guarantee success.
It's reasonable.

But TDX code still needs to retry for the RET_PF_RETRY_FROZEN without
re-entering guest.

Would it be good for TDX code to retry whenever it sees RET_PF_RETRY or
RET_PF_RETRY_FOZEN?
We can have tdx_sept_link_private_spt()/tdx_sept_set_private_spte() to return
-EBUSY on contention.


> 
> E.g. for #3, the below (compile tested only) patch should make it impossible for
> the S-EPT case to fail, as dirty logging isn't (yet) supported and mirror SPTEs
> should never trigger A/D assists, i.e. retry should always succeed.
> 
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 47 ++++++++++++++++++++++++++++++++------
>  1 file changed, 40 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3b996c1fdaab..e47573a652a9 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1097,6 +1097,18 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
>  static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  				   struct kvm_mmu_page *sp, bool shared);
>  
> +static struct kvm_mmu_page *tdp_mmu_realloc_sp(struct kvm_vcpu *vcpu,
> +					       struct kvm_mmu_page *sp)
> +{
> +	if (!sp)
> +		return tdp_mmu_alloc_sp(vcpu);
> +
> +	memset(sp, 0, sizeof(*sp));
> +	memset64(sp->spt, vcpu->arch.mmu_shadow_page_cache.init_value,
> +		 PAGE_SIZE / sizeof(u64));
> +	return sp;
> +}
> +
>  /*
>   * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
>   * page tables and SPTEs to translate the faulting guest physical address.
> @@ -1104,9 +1116,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
>  int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  {
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
> +	struct kvm_mmu_page *sp = NULL;
>  	struct kvm *kvm = vcpu->kvm;
>  	struct tdp_iter iter;
> -	struct kvm_mmu_page *sp;
>  	int ret = RET_PF_RETRY;
>  
>  	kvm_mmu_hugepage_adjust(vcpu, fault);
> @@ -1116,8 +1128,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  	rcu_read_lock();
>  
>  	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> -		int r;
> -
> +		/*
> +		 * Somewhat arbitrarily allow two local retries, e.g. to play
> +		 * nice with the extremely unlikely case that KVM encounters a
> +		 * huge SPTE an Access-assist _and_ a subsequent Dirty-assist.
> +		 * Retrying is inexpensive, but if KVM fails to install a SPTE
> +		 * three times, then a fourth attempt is likely futile and it's
> +		 * time to back off.
> +		 */
> +		int r, retry_locally = 2;
> +again:
>  		if (fault->nx_huge_page_workaround_enabled)
>  			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
>  
> @@ -1140,7 +1160,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  		 * The SPTE is either non-present or points to a huge page that
>  		 * needs to be split.
>  		 */
> -		sp = tdp_mmu_alloc_sp(vcpu);
> +		sp = tdp_mmu_realloc_sp(vcpu, sp);
>  		tdp_mmu_init_child_sp(sp, &iter);
>  
>  		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
> @@ -1151,11 +1171,16 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
>  
>  		/*
> -		 * Force the guest to retry if installing an upper level SPTE
> -		 * failed, e.g. because a different task modified the SPTE.
> +		 * If installing an upper level SPTE failed, retry the walk
> +		 * locally before forcing the guest to retry.  If the SPTE was
> +		 * modified by a different task, odds are very good the new
> +		 * SPTE is usable as-is.  And if the SPTE was modified by the
> +		 * CPU, e.g. to set A/D bits, then unless KVM gets *extremely*
> +		 * unlucky, the CMPXCHG should succeed the second time around.
>  		 */
>  		if (r) {
> -			tdp_mmu_free_sp(sp);
> +			if (retry_locally--)
> +				goto again;
>  			goto retry;
>  		}
>  
> @@ -1166,6 +1191,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  				track_possible_nx_huge_page(kvm, sp);
>  			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>  		}
> +		sp = NULL;
>  	}
>  
>  	/*
> @@ -1180,6 +1206,13 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>  
>  retry:
>  	rcu_read_unlock();
> +
> +	/*
> +	 * Free the previously allocated MMU page if KVM retried locally and
> +	 * ended up not using said page.
> +	 */
> +	if (sp)
> +		tdp_mmu_free_sp(sp);
>  	return ret;
>  }
>  
> 
> base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
> -- 
> 

