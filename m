Return-Path: <kvm+bounces-58931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B495BA65AB
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 03:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 320DD189BFA7
	for <lists+kvm@lfdr.de>; Sun, 28 Sep 2025 01:42:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 191FA245028;
	Sun, 28 Sep 2025 01:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QxcQk9O2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B4D1DE3DC;
	Sun, 28 Sep 2025 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759023730; cv=fail; b=ZJ7F4BwPI1w/IipaC9GLUVynnUUUzy0/CQDKKdQ4M6os8GI8EnWwcF3sH9J0HuE58bFhy5VxoozMJIhSgQOFXzf3zqpJLrRcgiFOh1R/At2gpWWy9zz6Wh8lWjxZcgtdVvtxj6upNTZ+VVtUDv64ZN8QQ6sN6+9cmogSsd/8hL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759023730; c=relaxed/simple;
	bh=4iKCraYmYe79Mpprv+J5xagdN6a1PLF95lXO8CuA7po=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=g1H+MfK2NTdYpOVtUX294KN79XeYHkfnt8T6noaxd0eeiKorFOv9tPtL+HgEf+pTbbK+mgxRAWFCbHpbuuaTGe59rUjCdOQVK9nxCmGWRR7AXDENm5nufioDZH9GAkBsPGBeEc0tzvOtuUtTWIKQ67MxNqVomGlJCKV072O0Do4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QxcQk9O2; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759023729; x=1790559729;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=4iKCraYmYe79Mpprv+J5xagdN6a1PLF95lXO8CuA7po=;
  b=QxcQk9O29fJzjxvwyzuQ63azNHONDKJwC/TD1iQ1fEIDx/N48/VGPGQP
   QkepOyDwSubcxXXbzr6G1yI4wRkAsEDSLKbaNkUHJmN9Nh5Nl3SbzAEH/
   MO/w/bRgONxcLpOtSQKLJqAOMUwRHjuR/hXF7T/wa9pQCdo6sSPu5Ssqv
   fbCFp798vvXwcVPgab67wVc4xk5Hpvm9/kqx64Qf2aypzgvo/lEBXd47n
   rCxGIcey7ukU7JWGKQIMhv9KkeRwnyDbyj4RCJVZhLP+RvruT6igBeq7K
   pFQbKYS/GVvAQex8n4cj6kcsPl1evOCTML23koToZOHqnnxq0zBzZ1RVx
   A==;
X-CSE-ConnectionGUID: Dm+JHFhPRMyMjelD3VPdoQ==
X-CSE-MsgGUID: bqXtaSu1R5+SRketrt7paw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="61357346"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="61357346"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 18:42:08 -0700
X-CSE-ConnectionGUID: Yl3M9/x6R1iis4x0nUiHXw==
X-CSE-MsgGUID: NmoyBm+6RGCWetJ8MkfEcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="183094970"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 18:42:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 27 Sep 2025 18:42:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 27 Sep 2025 18:42:07 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.44) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 27 Sep 2025 18:42:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZvHvrJmvxJ02z5nZcwodnp1UdbK69yfuGj7+ExgmW7yEfgDfWbXttwYQAteGrs6fHkRBUkKjFVgx71LP7VHn5uXnDex64lPonGmR8UqMTSgTX4rn1vLYlQDRrFfjcFnFFp8/1i5yqi0Tmp0w1qxJ+lJsssqGElBHAJ7hVt702Fg+GF8EM51RgEw0paGdVfVfFsYE4ANG0opd8FLDvu10SJ1x8fypzmG4p9sxIjmdGOHvcaSr0UO288Q86oJVr2e4lsgFadWoe3fy/hwHG+gseH26LSYDjaYOQ29oZiOlYW2U77MNoT7z1guR7ChB64aYQSTOLqgn4yzwgEyqcDl73w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6km8tyiUQJtPj43rUN8inp3NuN0dJWrJogV7HJ513dQ=;
 b=HmRcIEq6y+MXlDDESpUyJVrl493lL4QjwDkb7K9iQn9wN8hHOdramIXBvfz9z2dpNzbzvs3khbW1UHTtDs/+UEM/SpihtqxOD31DVYKgFss3SNfGomIezy87qDUc8n9ULdSICWj/4sckM3/0caijCwLT+JQ8glyerHNY8p8O/Paxl/X08Oe5oCh5xSrK+9hsA71TczidUTom7Q31DpzoLlZ4uPjowaL0/HobA0LKwsKv6Vfj6hLZgSMAhlz9xnZz0sKWMEAlFwMGLQ3Dd2GRfv6MN16CjdxufTqRv/OOUxsJ36IDepfZ25gnbKCoQkJOZ6ImbscUjt/qdgXyzIKlRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB7093.namprd11.prod.outlook.com (2603:10b6:510:217::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Sun, 28 Sep
 2025 01:42:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.014; Sun, 28 Sep 2025
 01:42:03 +0000
Date: Sun, 28 Sep 2025 09:40:54 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Message-ID: <aNiSJh/65oUp+4Dr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
 <aNXwEft+ioM9Ut8Q@yzhao56-desk.sh.intel.com>
 <b3b70404aaf634cca9199b917a9987ccdb3a66b0.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b3b70404aaf634cca9199b917a9987ccdb3a66b0.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0105.apcprd01.prod.exchangelabs.com
 (2603:1096:820:3::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB7093:EE_
X-MS-Office365-Filtering-Correlation-Id: 6896c747-bb01-4f8b-30b6-08ddfe3039a3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?1hOo6Mfj/KQbdfOZut9KFw7lPdmZk+rR7T5RB/RWmNN+mEAQEB6Uk4uLfx?=
 =?iso-8859-1?Q?PVD2Jft56fSdfTU7QMemwQOx8npYPqD2sZjOtgEhtpqk9sHEtjwPGUlGCK?=
 =?iso-8859-1?Q?vQtmLYxF/H8qa5WENT3qWFu4xBc5t1oCYdjY4ZZp1lOS86oAZeg6H95pAZ?=
 =?iso-8859-1?Q?cKRR+rxnmCt/uAcp67t3APtHYNijug2dXLWY4A/ahvHZHz2yS6xgMIelOx?=
 =?iso-8859-1?Q?xV4PIFfV7UrLmt89vSdgizuSoWejU26/0P0cZD1734rSjTzJ3vRjw+WNf/?=
 =?iso-8859-1?Q?QjjP20CvyHzwrCyqMTh92zZtULAxFxsn+UBWSFhckRj88sO7WbAeCYK45v?=
 =?iso-8859-1?Q?FtH5AZhDtAiSt85AFT+DsEd1AvrC1j5q6ihtRePcMe/JU3+jmesnaEN1Mm?=
 =?iso-8859-1?Q?7EbWRS2OPGCXekglVlRXnrDUCQi7ZgEDsud5gGo3ciUo/uOydhkVBNQ3zO?=
 =?iso-8859-1?Q?Xsj/0AREumqNruP1QZuRiXoJph+QLuKuXgqzUOgciFd2MuD+ZBMmNj98my?=
 =?iso-8859-1?Q?Qu4xjGe2ZI38OcWV2ZaqX6o0ZPjPdX426IT5md2oAiqPLvpX42LlRqVLi9?=
 =?iso-8859-1?Q?fVLmPGYkG+jRt0UGGrbJNaqeOKZ/U5IRY+8klkp5/6JYG2+Ke01WYRJ5kt?=
 =?iso-8859-1?Q?sFKMRUd2+NQeut/MqIB/O3F5PIJPBJEkJJdcq8/Kh7b1o3FyMQq4etRh6U?=
 =?iso-8859-1?Q?BnadjRLcNjcSCgdlhGXnjMSHFpsVfo0l8INmoSZTPI283g0oO5QZYYp5T6?=
 =?iso-8859-1?Q?SxmXv9hljBTPC7XZFjkPX9V33q7xBmD5Ojr+QPiRZPrF8LHsmU+3x+PECd?=
 =?iso-8859-1?Q?ydsWymKt39pfKxB+CI82I3W06wP26qOVgLRVJoozEI63l15yTeJ/fGNclH?=
 =?iso-8859-1?Q?brjCTv25gkUrrSnbaeCR/d3ieiq+aRl437KCFKiGthAnS4fLb86rd2tMRU?=
 =?iso-8859-1?Q?HkN7xv0WwWzQfDVhk75lQHvElO52AzUd0btPlsMpA6bNqcBWKp/ET2S7aM?=
 =?iso-8859-1?Q?ozJ6u9ryyXBNyv+obxyanwHhYPXnXaeRkxODviVg7jrNdjsXXUkTPVhD9j?=
 =?iso-8859-1?Q?R46UTlhzZxYBP5UdURLaFplkkXHGFSykcNcJTN/fl5VHc6AGEnDvU5Of8A?=
 =?iso-8859-1?Q?ai0zpP/PdnpEtX4ozRmJ1u/qo2buZ9ESZDDluP5KjfaJSr9Y8Rn8M4isIk?=
 =?iso-8859-1?Q?YlTkKmcVdWMlAu2c+cUc4GCUUWxIeEBetexhsyj/9IwziEkkAbc9ZggaUs?=
 =?iso-8859-1?Q?W9fjayXBnfsi37yqT4AIjkvqbfy+EM6KeGbf9RnGI4LtyLz2mzbwyLqzrl?=
 =?iso-8859-1?Q?4fFg4giWHzhw6wx1KZt41LJ1xSPS1DaBSOhm4zaGIZSXxAkucR6af6UdhF?=
 =?iso-8859-1?Q?pw0uHa0sfwPqMyuZqTwAp9MyQXZaDbwP6gJwnRUkNLS8cVrzYk/ChJ7o1E?=
 =?iso-8859-1?Q?EBehRPhxLpAFi4mh5f7p+6wwYGpJQXCAQs0oVKPnqv12BsHrzKCRcNU7xp?=
 =?iso-8859-1?Q?/HjMYNdAvgNFdV7aYZxTZj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?6abvIFN6Kk/7AJUqtkyVwl1uYOjSu6qNylVxkdm27fJuE7so3cbZ5y4cF3?=
 =?iso-8859-1?Q?TBUfowkGtcmb4oHQYXeDzxNGJtP0uHVdX2vX0my7hjTjhlj4JuEclBym5V?=
 =?iso-8859-1?Q?y9G5vpc3GPDqLoqfzRRGf/OphVm6pp8Fz+H+W9aP0mkbuf0aTzjNvnxCFN?=
 =?iso-8859-1?Q?5a5Cz6WkzsoNE0tp/ZrF7it/KxYalw/U2f2cIawUfpPHUOb6P9XoAUFsN5?=
 =?iso-8859-1?Q?/+Uq3T+Bg+PgozRhkutzgSrrgGOwpx2ACkn3Agyd3RuR8cktc09LCJsbhW?=
 =?iso-8859-1?Q?sZ1EtD4V4iCEoSL9QILl1ZW69mJr/QhtPuyngpDkI6kdS2YOkHJ85X1uB3?=
 =?iso-8859-1?Q?EfvdnVKLYrrhjHIDZztg2AOC30eoNmkOcwvL5XOOJKKTWbc5EghNrEaCZy?=
 =?iso-8859-1?Q?ZTcWcu0JkjYeajCo158XI2QzU5ozeCzV6RurCKYmrGDcmzLB3FgVlHpfRo?=
 =?iso-8859-1?Q?HTacNMzruLRouRf5gGS0HC7rf/DXW5BGfoH/o8pZoGCgExFwtoK13l+ynX?=
 =?iso-8859-1?Q?IhFTbT7ogJ1BxnylfePur7IoINBKmNQWfQTA8KzGLXkW7csefATEQS9/i9?=
 =?iso-8859-1?Q?pf6Wb5Shf4uOWPXU/cuCt1mbd0XdktrLp6mSXzxcWmkcGxlY1JiAGuyhla?=
 =?iso-8859-1?Q?cDuRMOCXG2PJzY8HobcObO7kSoqLSksf2PhNFWwS2j2rdqsijwX9OijuIh?=
 =?iso-8859-1?Q?AO9QW7i8XkBepjkSN+Ogx/FsZN4y3dPwKDDfyNttppm6n1JxiGP6w6tHPz?=
 =?iso-8859-1?Q?57670nookKOwcLflMdhMLXgUM3VHENQGyqcZoYP4P0/X/mSrSaJuOvydNn?=
 =?iso-8859-1?Q?DRPyPBqZ1lSDYG/qngmCIsfvSFLQ7aL9AHKqOPOBPfqubddvwih67v+2gw?=
 =?iso-8859-1?Q?ZXFWg9xbkEQxiR8dmhehLFyORRZpq2ogRneG9r/AL8T8dQ5fNc5UWX6URG?=
 =?iso-8859-1?Q?x0DZSqG2YORfZV0k/teG1/pd086CVn4kHJDVke++p+o8Dmqx2BQaCVHgMh?=
 =?iso-8859-1?Q?5IVexcIZ7JM493nTl1+kc4Lz3dUG4qOdrZmnamFSVlO3ur4pudLj9hr3Gl?=
 =?iso-8859-1?Q?P4HzgTOBxoAtOPYq0DvAqTd40GMj3vJHC7ESM5Zz+D5B4usuNVgM/KU1nW?=
 =?iso-8859-1?Q?W3vFQ46/GJ/lIzjTJkhY4fEN7+JkTkkLagT+y/5ZkWB+JQ7NPf4LEkgceI?=
 =?iso-8859-1?Q?s/XZWk+97ptt7fCOZBa8aa77XD+OhChPhmGgMeKu3OK6y8boYZfaZ8z4oC?=
 =?iso-8859-1?Q?OS723ao6b7ML3V71jkXCRXkSWFzJ6iA+JCCn/9QiU8lo9u4dnfkPE+Dx8U?=
 =?iso-8859-1?Q?pveApFHf+tZnSoFB2E+5k8cusa8CJYbiXwdUIKSXeQmz143rGKq0EVHMlc?=
 =?iso-8859-1?Q?s+n3IHZN77V8s9nCY7zr+31DGUgB47JoKR0vgEgPhwCc1O0doHSWHOlnQg?=
 =?iso-8859-1?Q?m9G6Rak+F86Vnwpthr1A2CAPcQv6dpPLK82n62CHTUOdz55wiFDGk7iVxB?=
 =?iso-8859-1?Q?OhPkJWJ7ut2ABsox1U59Dra8VzkDeg1vmQE0PBHsJQge8jTWlQa7CXs3r2?=
 =?iso-8859-1?Q?mhMG2fQSI06BP415L791AnIjyxesPolSzqWIuSj2vry4SloqKAAMLl7JuV?=
 =?iso-8859-1?Q?obC6gFrJaS3i0lRvbxlc7oeT8RhNrk3b7d?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6896c747-bb01-4f8b-30b6-08ddfe3039a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2025 01:42:03.6530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: snDuhjcQNCTiHU2tPpOlWqFF58cb6iAhqzzYdb9OvhvVz6bkL6ro22Ofiovp2DxKYeUvfGIMtD2OMf7O052AMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7093
X-OriginatorOrg: intel.com

On Sat, Sep 27, 2025 at 06:05:12AM +0800, Edgecombe, Rick P wrote:
> On Fri, 2025-09-26 at 09:44 +0800, Yan Zhao wrote:
> > > -	return kvm_mmu_topup_memory_cache(&tdx-
> > > >mmu_external_spt_cache,
> > > -					  PT64_ROOT_MAX_LEVEL);
> > > +	/* External page tables */
> > > +	min_fault_cache_size = PT64_ROOT_MAX_LEVEL;
> > 
> > min_fault_cache_size = PT64_ROOT_MAX_LEVEL - 1?
> > We don't need to allocate page for the root page.
> 
> Why change it in this patch?
The previous size determined by TDP MMU core was just unnecessarily 1 more than
required (I guess it's due to historical reasons).

But since now the size is determined by TDX itself, I think it can be accurate.

> > > +	/* Dynamic PAMT pages (if enabled) */
> > > +	min_fault_cache_size += tdx_dpamt_entry_pages() *
> > > PT64_ROOT_MAX_LEVEL;
> > > +
> > What about commenting that it's
> > tdx_dpamt_entry_pages() * ((PT64_ROOT_MAX_LEVEL - 1) + 1) ?
> > i.e.,
> > (PT64_ROOT_MAX_LEVEL  - 1) for page table pages, and 1 for guest
> > private page.
> 
> Yes the comment could be improved. I'll enhance it. Thanks.

