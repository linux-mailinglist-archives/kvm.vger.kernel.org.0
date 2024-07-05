Return-Path: <kvm+bounces-20985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53BF4927FAE
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 03:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44B3F1C2149B
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 01:19:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497C4132804;
	Fri,  5 Jul 2024 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dRbQegIr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D08A84A3B;
	Fri,  5 Jul 2024 01:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720142290; cv=fail; b=X09j1IriA+gIf2VamWD3oLvqtmQOU+fZ9HT0evw6jan5Osg5Dcb1IdF+MSmJjqGHKz2Xdq3HaoqA1YFGiB9sWqHbMRRo0Z8LrVeq+Dr1VmM5Rkfma7RmlYLTd/gHD+DwxEgIHdxwvfRdaLDjPtAgxtX9l55gkInugJzPLtMS33Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720142290; c=relaxed/simple;
	bh=YRJPJS2TbNysSZdIwZQivIRnuQ7IM339Vv0pmsBOQvA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PJjk+1L9WKegruz6u2Z13tzcNko6xrSoNFbl8r/aoC4IpKjjn8DBsvrU8FA1KxgcqtZ+qEWsHCpm8JSoegXChn3P+1aOD/uCm1rrxNFv1ADQw2RmUfQhDBxff2iUJp8rHggRSpnj8QDMCO3JEV6+XeOr0EEOXdN3l5FGshbKHtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dRbQegIr; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720142288; x=1751678288;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=YRJPJS2TbNysSZdIwZQivIRnuQ7IM339Vv0pmsBOQvA=;
  b=dRbQegIrvegeYKZQhdPY7Zo0xlNuF3TamMP2OejXNwS6PNAruw+Wv1bo
   gusE8CBy9DMjkmM/MUowKsuhte0/dCLz43e7oUc7pGMMrDVX+lkYyGM9+
   ApINs9NoU/VI8/leWDIQjTe7HCJ2JxhgxvX7dGYarltDn/ARG1rVu3Zim
   fRi/Ch3qUddYZ65GYhVHGrV354RxNFK2a8IjKDRAX9r0JG5IlemMq9mOU
   Pik8NveuVAgUbC0/AzYPgoQLl2uW9NvmL9KauLdDGc0PuaN0R8EEK3oOl
   7ikRmZZQWYYLw8/dieGqh6aWULfyoBjgJLWwMwzvdiGJVyZ186qsjvZzD
   A==;
X-CSE-ConnectionGUID: osFz3T7iSEiFDySnnkHXjg==
X-CSE-MsgGUID: 7KSMVPLCS0ey1yjanG7KDg==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="34870481"
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="34870481"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2024 18:18:07 -0700
X-CSE-ConnectionGUID: tX1YlFLhQMyb/29OTBQ1Gw==
X-CSE-MsgGUID: 8zfqNZIjSoO15gUl2+wW1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,183,1716274800"; 
   d="scan'208";a="46693489"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Jul 2024 18:18:08 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 4 Jul 2024 18:18:06 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 4 Jul 2024 18:18:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 4 Jul 2024 18:18:06 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 4 Jul 2024 18:18:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mEDbcCXGXsDWKNYhNExMPWjXGShAJqx8DlaPHZQYnrTeq1RwpAwgpOQzTrWQKqGbyl7gCcTDjiC8ttMkpWe8ocsR8vJ56nOEm4CGkpnl4EBuj1sixbWUjqzE8rPnZshPNov/q+aB3UeTs1P10njNPLK8Vjpev1UjGh9o32WGoIga6RGZxGdSt+lISXiju4k5s9t5DQraqd3nt9AfXNxE1ok7mmF9RL+N8/UEp/GYMmojcnoDC7CokBOlQ7JtFCxWHiJTI3j1VHTJaNcsfrmks0ztzMYB53qdaRQiPKcAX/esr0FnhKjxkE8Hqn1rZc6IQV4VnN0z90BkE2VX+VGmOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=paZ1bcnLopVAA+LcsSDQQfy0RYtAXHiMFaWAO3Ltjm4=;
 b=ZyBA4QR2PKU81tAPfFq2QWSuUij5cIl31KvYn67cezVWTHrYdmDe5YPGytyHCudxy3m5KdOgDzlbmORGfwU+qeD1GMW2/2BSHedkzeqcUb7L4yBAGk/u1ANrKR9BAT94HrYph3L7C0sUSFxhEKi73cmfOcLTfgnXdCodnEj1kts42D+uJv2ZuGDvVR9sVqXHVvCSDRoVvjQCI6kxgyUPuhk7jTB8M7Oou+Agp2+IB5kOmLl3Wh5/NZKKeRe7qNKS1Iz2m8xh6RoL1a/bGcLZJrZ7Ygo5ZpU/OThxWZAstJmPglLY33dH++kqDa2XHArsvY0JoL5qKaCBXfnYrDsN8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL3PR11MB6529.namprd11.prod.outlook.com (2603:10b6:208:38c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.23; Fri, 5 Jul
 2024 01:18:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7741.029; Fri, 5 Jul 2024
 01:18:02 +0000
Date: Fri, 5 Jul 2024 09:16:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 17/17] KVM: x86/tdp_mmu: Take root types for
 kvm_tdp_mmu_invalidate_all_roots()
Message-ID: <ZodJeS3qhO6nJ0di@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-18-rick.p.edgecombe@intel.com>
 <ZnUncmMSJ3Vbn1Fx@yzhao56-desk.sh.intel.com>
 <0e026a5d31e7e3a3f0eb07a2b75cb4f659d014d5.camel@intel.com>
 <Znkuh/+oeDeIY68f@yzhao56-desk.sh.intel.com>
 <d12ce92535710e633ed095286bb8218f624d53bb.camel@intel.com>
 <ZnpgRsyh8wyswbHm@yzhao56-desk.sh.intel.com>
 <2f867acb7972d312c046ae3170670931a57377a8.camel@intel.com>
 <Znt8K7o0gCwjuES+@yzhao56-desk.sh.intel.com>
 <c2380408eff9fb8501f2feee571e96eab5ca882b.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c2380408eff9fb8501f2feee571e96eab5ca882b.camel@intel.com>
X-ClientProxiedBy: SGAP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::31)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL3PR11MB6529:EE_
X-MS-Office365-Filtering-Correlation-Id: 7161e1c6-6dd8-456b-75cb-08dc9c9050c2
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?GwEzdgtpIIIhNtw9PWaIm3+hetblRRwSnQ50Gx4yFoUdgnqNM97IMK3HqnHa?=
 =?us-ascii?Q?8FKNpZocqkLw3IkHrO+xwrqdoBW66Wu7Aw42S188rB3/yxc+xSWbl0EJiFxt?=
 =?us-ascii?Q?/ftoQwQ4Ljqy2roEsYsJ4AQy/ceVGrp8tEs+8JTgV39AI8L8+0XZ2JQ7VCE0?=
 =?us-ascii?Q?GH+l3oZU2mVIqAVPaz0h9KDqACQJguERooOEcE8LNKhyb2u0Qa7rSe1eu/Ck?=
 =?us-ascii?Q?KzjauYklLPO6ZhpEgOzfwp3NVncgVCoJCpmO5tty4MvmQK5dG83Cqo6OMoGk?=
 =?us-ascii?Q?71PvebPsMFyNRzumIDjsqhepPYZCpIOGp9fA9Afqq5v0JF/tfvRMU57eDkuu?=
 =?us-ascii?Q?l6u9ObiY4laz0QzhU8ffybzQtgC1fgQNOJ5Ad8o14RbW9VNPCOOT1b94fuls?=
 =?us-ascii?Q?mT8SmOf/ki1GuURGsQtR9SiSIy45Uzhk2KjtjMI5f5QZnP6ZHsvOzfvUgEMW?=
 =?us-ascii?Q?PNt0ZFszHYsuFG+AAWgwS3vD7Mm+ZIYYCwzBeTrtbz8bv1JWK9jvB1p8sSM7?=
 =?us-ascii?Q?jw7Qm754HNY5XsD2UQ2Lxx9rDkApjxs4qjb8+gYlo+nryf034XfIp8/RJzjZ?=
 =?us-ascii?Q?RMIMPPoybGcrdn5a6JTMHvBKNsJb9hQi2b57dTxCH184ufxFiSc4TDylAzjS?=
 =?us-ascii?Q?SwvkNEUROn+M6IXKZX8yb2rjaUfoiKBw9FHMypkvaH3UXA7OsvhAqRNxn/b5?=
 =?us-ascii?Q?pJ1hkHS81b7A31ZRKWEJQURFkAcB2pKFkuKvX2KXKFtVrOc4VPxX5CQpQxKo?=
 =?us-ascii?Q?2w7jkcmTP0Ac2Ai2XqEErCl7zrOjT2tYzdtXaJY/uwqQx8Up6dtSQrUjW5++?=
 =?us-ascii?Q?oaEFlSUgArHaFje+XWlYDCDmcaAb7OMvScm23tAGTksEXcgNGqKDd2oMBXKf?=
 =?us-ascii?Q?51S93n/R/KBdF134P53WMPZFaGBhd2nyUZEMaRGVQREBl6XCMst/kmVuWinW?=
 =?us-ascii?Q?tujOQxuZ/qPGoy2fkw68tjZYxRmEcojzdWMRjKH6KANZsqXg+xK/pWeOhG5I?=
 =?us-ascii?Q?hVFPA3q/Cpg80xnKMRy5XT9Pt2AbLS9dBSwbnmp7+MSFi1sstcAm0SmkiXWU?=
 =?us-ascii?Q?gDgN3qgYH3XJt1lDTrmhphoTAjXF5EU/Izzz3s3Gj1iZP45I71ZE99yAIKja?=
 =?us-ascii?Q?2ocPR6dYGcT9ddKQqTaXRbDNFgQ/YR9aQBr5B3S/uL5a9ztfjmyjPePyW5DW?=
 =?us-ascii?Q?euSDtHl5II9saZCCPdxV8MGdmxo4VMAnspBS8wbm24cPDQSsXm3UeGHVD2Q5?=
 =?us-ascii?Q?UZVquLGhBL7+g63RAx2bFaO3lNSvH6fe1z85x7B5V8O3AIhC8WohGHj6imw5?=
 =?us-ascii?Q?3aaIdT4+eUBhb1bAW/6Y6JovFrSKXKfLYwxNP8jug/BLuw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xcmxIUvpR1YMlDZc6UxBZ+x26Rn1kmGaHqPTHlulXSdF/UHx6esBhfTQzdZy?=
 =?us-ascii?Q?Eqe9GtK+j6kJcmWmiuJBtApz+Ez49Bx3iqE6dYnhV5vo928nCNys9Lw7kEwm?=
 =?us-ascii?Q?wsxd8hbLfvIXcIfO90VlChKg1/DBgEd0o16sIDz/NKu9S4x2LlZN5YfQnkrk?=
 =?us-ascii?Q?Lg7ecDLZVJJXaCUgJpuHBXzOKFfs1JcmN+WX0bLuJU/t1gSv0l9AnXstlyxP?=
 =?us-ascii?Q?2T2k7t2HQc7f8RTmt6hftv4eU4cKn/LsXMqYyGv8Utw4FMc/dKQGxmZvyjcm?=
 =?us-ascii?Q?BIhQ2q0XSSNW/3zR9R/0RF1QqETQYt2xL+oWor6GSR+00jFFUNcmxHWqUNLK?=
 =?us-ascii?Q?T2ItjQqGstPJGVxQURNuJdhYL7G7sYe+Oypajz+z7DRn0QMnAnXD1UlkYmw3?=
 =?us-ascii?Q?i7QomPmnHBH8qLoujiYxM3ldZfT8IUuzbFA0ql+OojVsmBoMqnSUMN2L7vAC?=
 =?us-ascii?Q?XzU+KHe8+DH+axOdKEiQlvI1Am+8XiInihxalUN+kIYlwZwdvMv2mOVeuuCK?=
 =?us-ascii?Q?YgUf2bpuUqlerbqA3+ATLFMf3WmwwmvslrwogtGSLchi7VKIZ+0JX/wIX7IH?=
 =?us-ascii?Q?PWtjTvz/iR4ztcHkd9MrYVjr0Tbxbt2RzmRcc4MMDJlT940tM50WoRXWwBPP?=
 =?us-ascii?Q?vh3zhDjhTCJjK3585X00+GXUDSsHVuSRSVHXA5aoqlCfvg28v6gJZCWIdRr5?=
 =?us-ascii?Q?Q50uQw1NO2qt316rHf4RchEq6pqlColD0n8NBo5sL1zbMtUAQ0BuDzeOGXTQ?=
 =?us-ascii?Q?/CoTvF1Euo15dZh4gUQ3GtZLezd7yENqns8UjQT+tawv3mkIEco883uMSmtY?=
 =?us-ascii?Q?pstnq6z22sfgBE3Auxz3+gvFHC67ki/E/DkmVE4UzWiwiVunMdQ4TRatDtCq?=
 =?us-ascii?Q?SjEb312ko5OTkhTbIbMU2l+ddP1NW1rKV346KSWNcooLOEau7WnsN+duLEHu?=
 =?us-ascii?Q?LV978T9Snyn2w9s+U3TawyOQePROVA1vswTrm+FJ+UR+3j0/iwxYLnrSPj+k?=
 =?us-ascii?Q?3H2+EZ0H60QSRGTceNba1FhdkbQ0+HlSdSIqAB2ORaBZsbDJtjYsVnFfxLdh?=
 =?us-ascii?Q?exMxO/VIM4FxvoEfcFYpsWG7lwmcdpvMQXxVpHHLtvoao+eh/ETq1VlmzoqN?=
 =?us-ascii?Q?Q8c2ykeMrfRm0/A8CwskSfbnvqreHmm4nZW807Z1xjqOuCAJs//ltW1jaxue?=
 =?us-ascii?Q?6TmUQiJxDNrXZ+i9Do8PqXtpcrCUhHDLsz8rLVk1v4kv6bqWzOcu9GdUzckr?=
 =?us-ascii?Q?b8BOOMvLovmh+s84SujUN1Tg0S1/PhmckRI+MC8HAqOhn2XWVmvmxUcAJpX3?=
 =?us-ascii?Q?PRSUpg74o+QRFbFyWL1S1ezFXnzyymmKrcx4SBP9+MKasq+A0dm2yePs3AzQ?=
 =?us-ascii?Q?t0V3cG4TKWiXBwADcZlRd8wuT+S8+CvlpQbozjLYzUD6b02cQS8Ux70aFYGy?=
 =?us-ascii?Q?nSFef9W/FOcJhFp+oIn/1QoDqv2HrPAeaXfYy5S3+v1ZFMZ0kTC8gv6sZ3u2?=
 =?us-ascii?Q?1xwUOwk33Xp/VKeaXcESeafvKhwuVFAmU5TSrRVZOPX4/m2omDTB92urrlup?=
 =?us-ascii?Q?FkPzC9ufSdOo3z/OCs1ATibD7f4Gyqq3sxWYaW/c?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7161e1c6-6dd8-456b-75cb-08dc9c9050c2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2024 01:18:02.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaqIMMwhj5O/dLA+fBpFOCA50WCOdeO7uqhG9F2ORm/B7Ww/iwyWS60BZuUxhQQoX1bzZZi6pSwR2+3J4tRTGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6529
X-OriginatorOrg: intel.com

On Thu, Jul 04, 2024 at 04:00:18AM +0800, Edgecombe, Rick P wrote:
> On Wed, 2024-06-26 at 10:25 +0800, Yan Zhao wrote:
> > > Maybe better than a comment...? Need to put the whole thing together and
> > > test it
> > > still.
> > Hmm, I think passing KVM_DIRECT_ROOTS only in kvm_tdp_mmu_zap_all() is ok,
> > because kvm_mmu_uninit_tdp_mmu() will zap all invalidated roots eventually,
> > though KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS matches more to the function name
> > zap_all.
> > 
> > I'm not convinced that the change in tdp_mmu_root_match() above is needed.
> > Once a root is marked invalid, it won't be restored later. Distinguishing
> > between invalid direct roots and invalid mirror roots will only result in more
> > unused roots lingering unnecessarily.
> 
> The logic for direct roots is for normal VMs as well. In any case, we should not
> mix generic KVM MMU changes in with mirrored memory additions. So let's keep the
> existing direct root behavior the same.
To keep the existing direct root behavior the same, I think specifying
KVM_DIRECT_ROOTS | KVM_INVALID_ROOTS in kvm_tdp_mmu_zap_all() is enough.

No need to modify tdp_mmu_root_match() do distinguish between invalid direct
roots and invalid mirror roots. As long as a root is invalid, guest is no longer
affected by it and KVM will not use it any more. The last remaining operation
to the invalid root is only zapping.

Distinguishing between invalid direct roots and invalid mirror roots would
make the code to zap invalid roots unnecessarily complex, e.g.

kvm_tdp_mmu_zap_invalidated_roots() is called both in kvm_mmu_uninit_tdp_mmu()
and kvm_mmu_zap_all_fast().

- When called in the former, both invalid direct and invalid mirror roots are
  required to zap;
- when called in the latter, only invalid direct roots are required to zap.





