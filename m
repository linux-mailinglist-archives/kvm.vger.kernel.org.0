Return-Path: <kvm+bounces-33092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DDF9E466B
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 22:16:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D381284272
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 21:16:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9262B190696;
	Wed,  4 Dec 2024 21:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ACMvqfmZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9A618B460;
	Wed,  4 Dec 2024 21:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733346980; cv=fail; b=s00o+Pr3R70O58orRYmOvhyEM6jvqLmH5lNFZjJRyfIAvZErGpH1mC+cYPl3qaMOscDI9a6+eo9Q2nE/rEeQ8XQ8tGARlbiRDwZxTNC954fhHlJBls4Et5tSIqvoGvqgFQy402gww+PfDU00ahSZxO1mTo4xzFdYpcuMEs8+SKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733346980; c=relaxed/simple;
	bh=hWTq9LZowM9xPDqa/9OEECNlY+Qc08ep8ev3eMvcDho=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UOTQBMZvKP+mj2R0bBnHS/7Nxe6Szaugu4eilPnqmpyQz3pVcssvdNlGogMuUPjwL3Eep/MdsQCwwOdqahMl5O0FZFMWMa37QzSj3pz4/jAF+KbTNh0wocixNwUMrMY7k+moxlLNeAWI15SrP9w0Q2Ze9ijRLWXHyhGWVXeTB4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ACMvqfmZ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733346978; x=1764882978;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=hWTq9LZowM9xPDqa/9OEECNlY+Qc08ep8ev3eMvcDho=;
  b=ACMvqfmZ1vzWZ0gEym+j+rVTeaccyN0qURAJsWbKlZXoUpJwsudgSQW8
   JdzZXj6Na9wFeJHQE4NYD7ChOETGQmonVoSrz964jbj1IpK6D7eYevGMq
   XFNUxr3l+3u4Q+QA0lYBqxRAMKg+Gh6ZpK+JcdB7h3mZYr+0VLMEhqml9
   LXoofF0shgd4N0lgkj+xfblnnIKgf05DLegvvuMte6H/sI7jMlIHFpX23
   +Bgx+h/y+vy5Ai39jTFfk/IJWu0+EkDkUbkEv46A1510eNYTFndu3xkLZ
   Pu0ZhwwEvKx3mwlRYedc9iwzKuhVKh4iR3RA/TU75KVceB9vBU1Clu0mT
   w==;
X-CSE-ConnectionGUID: USKeB4E6RzWA9RR6j8+Daw==
X-CSE-MsgGUID: Rr7iuKpwQZWACs8uq5mbvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="33552064"
X-IronPort-AV: E=Sophos;i="6.12,208,1728975600"; 
   d="scan'208";a="33552064"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2024 13:16:13 -0800
X-CSE-ConnectionGUID: UBTsWwKhSPWHZObkMyw/kg==
X-CSE-MsgGUID: jBslxR4mSQWMFMcxvRxWGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="98916573"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Dec 2024 13:16:14 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 4 Dec 2024 13:16:12 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 4 Dec 2024 13:16:12 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 4 Dec 2024 13:16:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnqer9t3VNaCKbdEWDfEEJHQ6DXhrheJ3AysPowgsXc8Yu+1vOh43Ey84qTOtmV5n89vfPhLrs1NTWudvGqU5UDT5HNYQKrmDWNPehAa56C3r8oW0FdD4fQF1l0i8FrGeWXtfdny/TxSPeyowWxoW+dQfjKHy/795uCfkAnCtFj/6AERb3J91jOr+Nqt9i4x7ljPGaEK2xpt/ps2SoJ1G8WvGy5vr3AY52PNqc/UKgBbjO3GrsHS/7XD/SZOuNCcR7jRwvh6eiJ3eTaVxaYNl0Q9Hyl7E57LshG0ZDBE6PhTA2g4BLSCUsBkaB7DtJbBwMR6OgRQ3nm8/cPNph8sMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f3Of9tQMy3fJu1opUlfRC7vLIJRoubcl2p/S/KXZKno=;
 b=C1Fmo7AiY6ByijmLZKmgDEBehXtYPOK5TvXoIPlvpO9aitQCS8BcziX1+KNxZPyE3kE5BgHjwbYSGtaTtMguvmEBnEmbHZAj7AWvmLQWC1UHJPI1M1sn9P0RHkDG+O2RvAx3H1F31tv7Y6lkMWbrxFbMRfIZARdHIYfOsff4yN24NnK3GG2vAUuLznmTkYAk4g3jy5gdHYsGdp1V1tYMtTHg0BuZCPiBSQzpwJVekKFJqPOhSv838sdHMMw4qZpjNiObjbB1Wug+4aLyhMCQTYUGxxkBqfoS8Y5mn6NYL57AxvcMb1PShRN11NJiyfRxcETHrvU0V7soL2xI4w63tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by PH7PR11MB6473.namprd11.prod.outlook.com (2603:10b6:510:1f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Wed, 4 Dec
 2024 21:16:08 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%5]) with mapi id 15.20.8230.010; Wed, 4 Dec 2024
 21:16:08 +0000
Date: Wed, 4 Dec 2024 13:16:05 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Steven Price <steven.price@arm.com>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
CC: Sami Mujawar <sami.mujawar@arm.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon
	<will@kernel.org>, James Morse <james.morse@arm.com>, Oliver Upton
	<oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Zenghui
 Yu" <yuzenghui@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Joey Gouly <joey.gouly@arm.com>, "Alexandru
 Elisei" <alexandru.elisei@arm.com>, Christoffer Dall
	<christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
	<linux-coco@lists.linux.dev>, Ganapatrao Kulkarni
	<gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, "Shanker
 Donthineni" <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, "Dan
 Williams" <dan.j.williams@intel.com>, "Aneesh Kumar K . V"
	<aneesh.kumar@kernel.org>, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v7 10/11] virt: arm-cca-guest: TSM_REPORT support for
 realms
Message-ID: <6750c695194cd_2508129427@dwillia2-xfh.jf.intel.com.notmuch>
References: <20241017131434.40935-1-steven.price@arm.com>
 <20241017131434.40935-11-steven.price@arm.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241017131434.40935-11-steven.price@arm.com>
X-ClientProxiedBy: MW4PR04CA0244.namprd04.prod.outlook.com
 (2603:10b6:303:88::9) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|PH7PR11MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: 771f9046-fea4-4d42-2969-08dd14a8dec6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?A07JeXDUlxX90iu/WUK0asy4RoTKrc1yPifkCnHO7ENxpP2xwck4bXG3dlW9?=
 =?us-ascii?Q?7bQPkT5pASIlBdx4vyz0V1Zon7c+0zgt5Kgt6ZWZyQ5e2pFjb5tDvy2m3DtP?=
 =?us-ascii?Q?vmvhh6j4gNF/0NmMxetKyVPaGOQNAswbnAsiMVxPdgPiQn45nHlbrBgI9WJu?=
 =?us-ascii?Q?cjAfr0T949cPUbzFSo5vV3/71q3Z2/gx/GsvRSwiQsqbsh2nSxRfhSAqtbuN?=
 =?us-ascii?Q?ah6fQKQganprn2L3hteXwB2rYqeUBSM6lBQrznGQfon/OAUvs0BTkA972p48?=
 =?us-ascii?Q?67ATJT4X805IUwdNIYxc+G7hvF/9H2kgykmSh2APs6Q7+x6mDUWN9dJrLLGw?=
 =?us-ascii?Q?Ss5r0Yztptt1xBcOMp0ADfHKuSocUYlUYG5vkxMMrzBzAwrVK5qjjggRFAwL?=
 =?us-ascii?Q?2yuviv8JEHX83R36OEAWicvytpc76WECtSPqgs3rNQJ4W2ZEP9S52oxYBd8t?=
 =?us-ascii?Q?UvVIoGZUwMSdr2Ph5XScskbiL5lDQi4XSa8ZdO4qY1XLJEhUDS+6/bDveuWG?=
 =?us-ascii?Q?4VgZsG04j3vYgprTW9XNKyQtLKGR0KJG6L1Kyf1LXVvj5a2H4P2UF1ze3usW?=
 =?us-ascii?Q?fuYhkkVDUNeJ1wVlZ/XF1NdK0Tmym+QTlOPXpz6CirNYqEz4ZhMUFvs0Iriu?=
 =?us-ascii?Q?7iti67tFDQk1P7sXjzeKvupM49GMaDuPC2CEvu2CvewotBS5/eZJ70MGyGKd?=
 =?us-ascii?Q?ZxZhNzm+sI0cGyhc9Up3T9VGXGomRZqT5Y9BIjUQuGBkuGbRyAXJiyyNa+yK?=
 =?us-ascii?Q?Zlj0Bt3DkAlg/80OXDPZkYaSxrLgBRd+r+OGxGss0bUDwY1p9heAwlsc3ttn?=
 =?us-ascii?Q?UK8RHNJcKJMz8CHwMeRD3CrvXUfolG3ZtaGRfFTkSfusTFv+m5QxciNkhoo5?=
 =?us-ascii?Q?x8l7XjvNofg0VawXe4FYVQ+uUtsh9o0R1kgGwAoJkjF0Aq8dwtZTz0W5KvM5?=
 =?us-ascii?Q?Z3NmftWSqOFTO5AAWVyOwZy6bXYKWf/GcAR6IEy40gRaAMJji6AihgIqJly3?=
 =?us-ascii?Q?9Anx+Bmaxo1VdePJtOliYm9ebdOwF7Q0GAyfOSnBJ3WajafDCXguE2OZnBsi?=
 =?us-ascii?Q?gdpuStBp/6YEHovS82hh+Wrv+jvKt72pfIzajxZyJFGamH8vpVl+icIja9Qr?=
 =?us-ascii?Q?ccnh7MK/g2yxV5jT7pIO0ymUVDq/4QxYyFcjIZrAI1JC+nzl8aHaB+dPPLHN?=
 =?us-ascii?Q?n1+y93mwoGeiOiVr7X3cp/jnGfAJ88b/iRXGzZJwAzw92w+PdQfXU3QlpAnD?=
 =?us-ascii?Q?/bmyeF+FPKBkSFL/gdfK7L4Jx1+5uPcQaVcbEfLIsSmBRU9ERGf9yVrJ6q1Y?=
 =?us-ascii?Q?bYU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?al3rIA/m/cPLbMi5+ba5z8jEXyiCw9KPpwhphmJorqaeOxxAOrhOkP4f11ZQ?=
 =?us-ascii?Q?3bt5yXMCFYoMFkLBgaVRFWcVA9TIwmmpZpFYEFHX/uxkteoDnA1UrEUPLvzV?=
 =?us-ascii?Q?R+0FSi8rSr2rwCiThIfOHfx5zCurWMJqyxsT5yKtY4A6sdTmTaKU2pQ/pS6m?=
 =?us-ascii?Q?qeFzBdUc/DPcizgjsx/v9b5GPfFzOfFlYGoacgHk74Eq1OlHQ2PeT69EQShn?=
 =?us-ascii?Q?dMtYIr8RZ5UkWJyGG79F6wdmTnMn3iYn2jcLcnqcPjj/YLs4tlSV4+RFgjEH?=
 =?us-ascii?Q?uyvgQkru2Cfwtnbfs8NsYeU//+6/dU6lgqs7i8r55B0U0N69OxqzfEOcb/vp?=
 =?us-ascii?Q?GnJVMBDxxSFMqNMUu9rUf9GJMxIEt0tm0xcWTyMOE8sDiXxGSKjD4zZmxNz8?=
 =?us-ascii?Q?Q5E/YNjE+6C+q7yWCkp2yVPbbxDlegZ878ZChSZ3bwulbJWcFiCklSwLRCHq?=
 =?us-ascii?Q?9hGlI1XriaxBdRUCmyryr3ldMLSMmoUOrtxBAfmE5NpeY4GR0vfQy/hC0J7Q?=
 =?us-ascii?Q?0OFLjEbRfwsfb4FNt4PCW4HBBnpQwS2sQbaZ/5O8wZBWDXD9fTfKg54ncGPV?=
 =?us-ascii?Q?094dRIlyY8gWNE49O5ngoGkyTNYBg6MXfD2su3bD7rR5ShmamHGQXThGK6Ui?=
 =?us-ascii?Q?glmQEclvI10CmbBpPuwsLDXs8PWXOGXmH3YqhraNsnuYYSRprVZ54g2wfJxQ?=
 =?us-ascii?Q?SIO6YqdygRwcHVSEGPuLFoha+z0zT4I3zAM73SedUPVN2z/yIyyrT4EKuRkw?=
 =?us-ascii?Q?ITMNnFswSbLlAYKBKUyG8aG66a2M2ttaIuPQE29iJI6SSPNTUYPEGCukVwmF?=
 =?us-ascii?Q?EnjPg38zllSFKYuSwZ1NJvFl8fGZarIhAfjswvOS+Vzn6yzYoJkXx1xU9h/d?=
 =?us-ascii?Q?kHDHHhcZGE9EvBQ/Mnj4nwwAsG2+LhR0Wnv5BT5Gkh8sPnrvxto8ySXxuenY?=
 =?us-ascii?Q?BKuDbN4TVzCtzto8NVdNDxgYiqhapJPf6lBJxdWAa3GPf279znkX6zT60rzM?=
 =?us-ascii?Q?QYqm30CElN3jES/67pjVNKpRKGOY+vNW55cx9WTaWQpIqeH0TZhtDMD/ormF?=
 =?us-ascii?Q?DKplOshkLYcMBleooLjHcEYhCjYrtNwtBgErLg6l7oRegASw1WpVXPp68nRc?=
 =?us-ascii?Q?SboARFseUVDB19N+NbmpNRgXHg6ad9jFOLbnshQlgY9i0N8UlYARf+15vJI3?=
 =?us-ascii?Q?xA2JEmPYI8pXw4QZ2N1NqyFsntwE+JbKPT1SlgdPjJYhm4ot2p73rF+WDatV?=
 =?us-ascii?Q?sL2T8rRj6tlTE8SOKS0G1N3xjzSV6RXXR34XDzUZE0W/aKl86uEuAr5AgvR2?=
 =?us-ascii?Q?lsUrGsVl1gH34/X8yvhuqkwRjmLffJVbNqhxMVgQF58ViJQ5G+L0XrWi7Csa?=
 =?us-ascii?Q?ulyF/yuM6cuMACNj2h2HMpj052YKSGPSzRa9614tyWREN6fPUEoFfWPRPKIr?=
 =?us-ascii?Q?fLILjuCxsDVaDqmOJ5s2GWCfsVho9EQ7/3lJ9eU47SwaFWkEPBR0mD2Z5ItU?=
 =?us-ascii?Q?a2B0GdsbE+tU75XkYXuVSGPNTdLXQt+E9xvaMimSZZdMZJrPF4pDH/j7iZzV?=
 =?us-ascii?Q?hw8O82wqTxpXeFKftCIoJsAqqyKDvkOHKmco6P88U1ddYpBPnb7dnCuEeHIs?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 771f9046-fea4-4d42-2969-08dd14a8dec6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2024 21:16:08.2847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y8yxSx/K6oGisPGcUnHptwOFJzzbEZy4al3blbXCD9Youlop2mCn7/jJ32+0TmEHqTqIbgZdhh9o7exFFJ/ifBDye5+6Fi/nbhW+GOmcaac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6473
X-OriginatorOrg: intel.com

Steven Price wrote:
> From: Sami Mujawar <sami.mujawar@arm.com>
> 
> Introduce an arm-cca-guest driver that registers with
> the configfs-tsm module to provide user interfaces for
> retrieving an attestation token.
> 
> When a new report is requested the arm-cca-guest driver
> invokes the appropriate RSI interfaces to query an
> attestation token.
> 
> The steps to retrieve an attestation token are as follows:
>   1. Mount the configfs filesystem if not already mounted
>      mount -t configfs none /sys/kernel/config
>   2. Generate an attestation token
>      report=/sys/kernel/config/tsm/report/report0
>      mkdir $report
>      dd if=/dev/urandom bs=64 count=1 > $report/inblob
>      hexdump -C $report/outblob
>      rmdir $report
> 
> Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>  * Avoid get_cpu() and instead make the init attestation call using
>    smp_call_function_single(). Improve comments to explain the logic.
>  * Minor code reorgnisation and comment cleanup following Gavin's review
>    (thanks!)
> ---
>  drivers/virt/coco/Kconfig                     |   2 +
>  drivers/virt/coco/Makefile                    |   1 +
>  drivers/virt/coco/arm-cca-guest/Kconfig       |  11 +
>  drivers/virt/coco/arm-cca-guest/Makefile      |   2 +
>  .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 224 ++++++++++++++++++
>  5 files changed, 240 insertions(+)
>  create mode 100644 drivers/virt/coco/arm-cca-guest/Kconfig
>  create mode 100644 drivers/virt/coco/arm-cca-guest/Makefile
>  create mode 100644 drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
[..]
> diff --git a/drivers/virt/coco/arm-cca-guest/Kconfig b/drivers/virt/coco/arm-cca-guest/Kconfig
> new file mode 100644
> index 000000000000..9dd27c3ee215
> --- /dev/null
> +++ b/drivers/virt/coco/arm-cca-guest/Kconfig
> @@ -0,0 +1,11 @@
> +config ARM_CCA_GUEST
> +	tristate "Arm CCA Guest driver"
> +	depends on ARM64
> +	default m

I am working on some updates to the TSM_REPORTS interface, rebased them
to test the changes with this driver, and discovered that this driver is
enabled by default.

Just a reminder to please do not mark new drivers as "default m" [1]. In
this case it is difficult to imagine that every arm64 kernel on the
planet needs this functionality enabled by default. In general, someone
should be able to run olddefconfig with a new kernel and not be exposed
to brand new drivers that they have not considered previously.

[1]: http://lore.kernel.org/CA+55aFzxL6-Xp=-mnBwMisZsuKhRZ6zRDJoAmH8W5LDHU2oJuw@mail.gmail.com/

