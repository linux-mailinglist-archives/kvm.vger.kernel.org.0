Return-Path: <kvm+bounces-18166-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8084C8CF9D2
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 09:16:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E87A1B20FA7
	for <lists+kvm@lfdr.de>; Mon, 27 May 2024 07:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D91818044;
	Mon, 27 May 2024 07:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YdVURUqa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAACEEAF0;
	Mon, 27 May 2024 07:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716794205; cv=fail; b=ivKoHQFVOoo0MlHODAP0BvvK6mbhn0KfBhhoUVkiz2fq0zwr97MA42b6Qg1GU6+RAYyceBkTamReGU5uwxy0ubaDU7spAiT0F67OaWsHiFD1/0360b7AolBRLrMZtIBd/8BOStzyF2hJnpuWW7ZcyXElIkbuFkQf9Pa9JebUij0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716794205; c=relaxed/simple;
	bh=8rMGUFeUukyUR2u2uTH3l7affptzkpkLYGp6pcBoYRw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=H32gu9ljuGsq2Ep/Dm8uycefRbW4N8gJ3ZE05fL7Mt4+IEUX89oaUGRzv4FmCpTe0oE3TuUaWUeVM5diDYkAizoAvdYcQJ7XII0S4u6qMjca+nZMmBOeCE5Pl0V0sN+o4FAtg7DvqHMWGmDHovGzl9AC/fbfpBhfP/FaMtb0HpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YdVURUqa; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716794204; x=1748330204;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=8rMGUFeUukyUR2u2uTH3l7affptzkpkLYGp6pcBoYRw=;
  b=YdVURUqayOoDUHCzYjeQYIPLLwC2AdV1HXPY5fWS8RUk3XB5oa/vRJXx
   4GOn02NjW2IXWFC9p9BkkA122T6xcfRXEzE48Oc3By4KzNxFQiPQcHgyT
   8RvfFbmSAvZRWtXxbHdUvjvVeCD5f+bprMf7ie/ATKPg3dxTHdxSz/n9Z
   hpYIWMz+0MyJCKE66ISo0aJm1vblnz8/4kA3D2lqZ6Q09o6ZJm3NEmn36
   J4xCyqQvE+ZUV7KUrMhKaXAm7vVCqrGW0S8uMDYTeAxdc0p+KGxq6AIrX
   JwcZKgONQwHXxmvfAY7NZXYsSHwn1l0EXUGAL4s8XSSx43xIUET2wBlxw
   w==;
X-CSE-ConnectionGUID: 8UeXTl/+Sr2JwlE+wOrKkQ==
X-CSE-MsgGUID: /lBI/Ta2R8OXDoXJ68bGzw==
X-IronPort-AV: E=McAfee;i="6600,9927,11084"; a="16929315"
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="16929315"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2024 00:16:39 -0700
X-CSE-ConnectionGUID: 9Nyzc669QpejBfVyLvIEyg==
X-CSE-MsgGUID: GyQAtSeoTrW47L/rTelIWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,192,1712646000"; 
   d="scan'208";a="34752411"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 May 2024 00:16:39 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 00:16:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 27 May 2024 00:16:38 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 27 May 2024 00:16:38 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 27 May 2024 00:16:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/34UMtoG+Zh7L6TBUi/r7iIRpEEJffymqZlEDcFf1lqIBgV1vx+b+Mke3fApNnS877w9E3BgOfOU1mzeEc4bGMw3ZavYRF3M5GILaWMxKdH4obr2WRRFnsPJVkDqQUm2Ym4910GeyBWcnsj0B5lonRPA/P6abfENJlPpTBjYRr1Eqp1ELFqMi4WfSTjJF0wXo7RPqzdHVteMuOElapIlBS36KmgVSIjr7CvOeFMsmBQxU86Y/uufj+eJiRTeQWpCaLX2lZEfpHJ5ahEI1GPafNnYmT4vJ7ZUBNngvfsl4UVNxkDoaz+iA9GfmLV81mQPECW/z1O5tIP08GZgbK4lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0O6DLxDZoxPG/okR3/sQqLSigJmJrtD7ofo3U1GTeWg=;
 b=cjuDg51jnmhkTSvbHKTVMDhC91T8HInu8x5aDNnz2DMb/prl4jxY0WKmgb+2HVWClXo1eHygycj2r6HMvMmcLnUp/6tuduFws/UtDbNyoPR43mJhu1aCFMKfSOdiZvQcojeJq3LyTdlaycxKIbiJP8lm2BRrX5KkG1ijG2oYPpFzrDKF9gZq8s2IMjES6jCnKTBEdlfI3FU5Sd0pfg/YiPjudYlAwNEJ2/S7Y5zq4LuDGU35PUhGd+EF5O2qW6BWNx2LSfCE43TKqomcwSY8gpGVOFoPIRmjUEjuY141xD/M6zZa8M4XML9ChfYp96QMIt1uGffiUapajz7nIAaJvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB7423.namprd11.prod.outlook.com (2603:10b6:510:282::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.29; Mon, 27 May 2024 07:16:35 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7611.025; Mon, 27 May 2024
 07:16:35 +0000
Date: Mon, 27 May 2024 15:15:39 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZlQzGzU1/CLY0eOg@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
 <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
 <20240517170418.GA20229@nvidia.com>
 <Zkq5ZL+saJbEkfBQ@yzhao56-desk.sh.intel.com>
 <20240521160442.GI20229@nvidia.com>
 <Zk1jrI8bOR5vYKlc@yzhao56-desk.sh.intel.com>
 <Zk2Qv4pnSKZBsLYv@yzhao56-desk.sh.intel.com>
 <20240522170150.GE20229@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240522170150.GE20229@nvidia.com>
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: 978b7675-accc-4f9c-14a4-08dc7e1cf156
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EJHOx5qqcrSLV/S163tnmLgFx7PRie77UOv2ApuRMxeNlxvgN23fbqYtcB6o?=
 =?us-ascii?Q?jD5mmFPNCvZNaE4U2isy/ukLh+zbqToLvYovpCHJ7TvagL3Cru5p0h7+hQCF?=
 =?us-ascii?Q?nEHmSVtI65xyvc+Z+cgiQAx12tKLeFrdWy8NmbW34ETiu8huoDDWlS0Iis4e?=
 =?us-ascii?Q?McJufRSejYm9cZXlIpNdBEo5tKA4Q+1DMhJPzLPNl/si3emq0WPBYEN7pBls?=
 =?us-ascii?Q?stH95CGe6CklKPLMV9tqSpqtONkGa/tlBDYAWe4hQzDYubxplz4DryH9/Rfi?=
 =?us-ascii?Q?KoVZsV9feU1+HlhS6fHOKuTV/D9mgPZeVb0kXG2Yo8MyRQdpPxiVb31REitn?=
 =?us-ascii?Q?Fvklitiz+/O8OEunTSTaa7oXCBG5/cY5PD+g7Fhckj6A5mdQ2ZAsu5zVjqUL?=
 =?us-ascii?Q?bKDA6QWC0aXuol8f063yAQQnH7pyInn1SLDnUAk7jYZN74mTSiD2pOkngrWw?=
 =?us-ascii?Q?a3EknghtmtDnFE5sWBdnZGRt3BbryChW/bECc3GRNXEqgbMHJG+OBKeEd1Gi?=
 =?us-ascii?Q?KgIex3cJM4cUMOiMjGwNkrHMwqUMoS0++HpAO4V0DsU2HMVqr1l6hII3MmT0?=
 =?us-ascii?Q?Th5iC50MyW5CHD9ILLSrBuEz+WlICBmYwtA2FU/fsXXBH1vGMY9zfhnIuLoi?=
 =?us-ascii?Q?ZJWmOksW/Nwf1DExEo0Yxqw/VoyJ15OllzgaBTtXxKb0gd179+qP2bN0yDKO?=
 =?us-ascii?Q?xzdsb4UJj6Kn3KpnDEWG82SzVGPvknBA/KXl6wqn9PHhAuPq8niolfKWT9i/?=
 =?us-ascii?Q?THwRFVtZR0CrxBfGYEiAAXovWp3zsdrpPncVaovHBik+IAI5OCmvVUvuTMjt?=
 =?us-ascii?Q?pf6Es5tyeSv5C0Sv4Ms+rGbL6a80TdfBSnFRD9oTtyQprmrPnWEizVf8Gay7?=
 =?us-ascii?Q?/ufR2lxR45dkSoytbrx1DycomRZzymSf4e+hzVYUxaFSb+9mzLY8+U9w0sZZ?=
 =?us-ascii?Q?XQQm5q/eIU+Cd+MU9f/SzIt2QW+wPjWjiuTd7SP780PXij7VOdLAYpJ1RuIL?=
 =?us-ascii?Q?hxBFCb/P9G5BECzKKkKldC5nWi3UNPkXiN2sxVQjnY4qwLfTRxjWkZ62qwG0?=
 =?us-ascii?Q?YtjboiqCdJJ4D5tuv/V8VZ5cBnYzD6cd0HNJJlOUNXcK+L141BcTge7Cp3qY?=
 =?us-ascii?Q?zUhPZnLvE96O0eBXptTOO29bhptwTcu4ytiCw3Z4bdo8EnlFoqwENX8VTtyz?=
 =?us-ascii?Q?AZkNrSeOJl+K4rA/JGEFuZsdwh++OxI3YvDVnXevOn1sgM1A2JAflIGzyHJu?=
 =?us-ascii?Q?Paz7l7YhI7idJ5Ok/O75fap7cWDRV3Nup3YafwIYqQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x8CNmw/KDni0fYkKYrSf92OlSBuUKyhsQHEz5pol7McPCeZKuIyzDK/TISFx?=
 =?us-ascii?Q?F5+bt9AId8c5vzu0sNgtnfODKyAS0Dtvi67vEzgiDqtWGKCaWdYa50mWuXE9?=
 =?us-ascii?Q?Etih4vdp2pFS+pC0vI3ZREbOlM21HQ9zD0kJUoSAwpwPuku3slycxI0Tn/Mp?=
 =?us-ascii?Q?0hTR13T0u20qY6WRQJnxpFcHesTQqHUkgGQ/GvXTUzGM0dIJ2lDo40XMrp7w?=
 =?us-ascii?Q?wJKkIaI8nA6z0hCnjGsbT0wEAHh/55pNW1jRFJyipZC8FptQRgbcTBlG8nQP?=
 =?us-ascii?Q?JPf97iRJbjkTq/03TXcTZTNRZhuqDQ97GYXYfZj/fmfKbpb/Ghshf0d16RI7?=
 =?us-ascii?Q?AGOTHa/GmO0FoPGi5RpPZTxFVNps6VlVInOtyeXPYE68aYuxvrjSmqF8HsXV?=
 =?us-ascii?Q?Qt/LdkiNfnXW1gx+H8zrZs44HwsnJeEG4fBWJdAyo4M6fIxmiQghyoL+nrj9?=
 =?us-ascii?Q?uz6qgqna8eU1AWaJemm0nMW6/9llDWagei/fXKlPoTiyh3YtHTkIAkbwFf2R?=
 =?us-ascii?Q?hBNpyzBbSuWWFK/UKr+Jpin6+qaZxoXBtAk448JBXYzVrVNSDmbAmd2KUcps?=
 =?us-ascii?Q?yuUtel7JJL74LRG90rOG6TzeheMM8WUv4KtEgzNPiSlqWrV0KiqE5gYdSnrS?=
 =?us-ascii?Q?G2wnUUmMGWWa8w01VSZgxUiJVs+vaKucpYO1FyOErTV8ikoKPjt9itxY4m93?=
 =?us-ascii?Q?pDOHDr67UlcZCMbFnFPwGA897gHbmdOnAR41tnbjTnsLH2qltsMNt7st2t3g?=
 =?us-ascii?Q?oYESO2HLyLcS1iVOTkWbPZcZBloMQLF+CvA+uFoGuhMhpxCiqPTolFKM5ziy?=
 =?us-ascii?Q?ACXP4fiwi8uJYdYPiF26vDR5we6CZgJnMcZrT+oybRZYEfhZ3zEcVd3P/q4A?=
 =?us-ascii?Q?1wWW/pyYlE3cAQRVBboLeJM9qDRS9l5eo4PW9vt3Ys7A5jzgxAIEfs8oHIT0?=
 =?us-ascii?Q?4ALb6UyiB66+8+jwa3xdqL4t8ab+T8WlRbmC4gm48KBuHAYC6HJXkl3wbXpw?=
 =?us-ascii?Q?+p04I+mZnDoQsSwQ+o2QFgAkSa59fENefhCH7UODfYWdEk6eAV5+I4HAUM62?=
 =?us-ascii?Q?5VuUjYKMMSH1I0uzqwZgbOiWOz6rjlxYimtsKWxiR1NMvBaPsWi4fcwJ8bdc?=
 =?us-ascii?Q?T55XCtHXSkl8GmPqMqwJ+gvm9JFZ6aCmJDYhmLIT9v7xaPRRmJ7fHJ6BX4Qb?=
 =?us-ascii?Q?yp1fu25Ydo6q8rdKZ/ircB5sbZQElA7iwr0ZMUJAQXl/xNkebv1bj6GO9ro/?=
 =?us-ascii?Q?xUysNbKmRutui8ePIlgCnNNyePN3mwZD2RyK8LTtIY7FwbCBtWXqNP1CWNpH?=
 =?us-ascii?Q?6h52K/bYFO92ZUq/cnycqyyE3zqdsBJiDQpb1G0xqnEo79i6QEemZtdvkw9/?=
 =?us-ascii?Q?zKl6zDevtZlzfHdQeReTKFq0Qp+NiGJfWTRYCOnEqkzDR6zJEGO2P/4bFuAZ?=
 =?us-ascii?Q?BCrQrBdsHpYip+vAp538/iJGGr5Uljkr8ICQvQb0KDUUU1tNSVwPp7+yN663?=
 =?us-ascii?Q?324znsIv4ROyjC8IjvgyRFVJiZqXSDBVlsMQzs2GOpWMrtEDhLK909wRFSx4?=
 =?us-ascii?Q?P2e8W3cqPvVqCK1btMGtJqJeGfS0yaEacP6B2BPy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 978b7675-accc-4f9c-14a4-08dc7e1cf156
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2024 07:16:35.4483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M0UFAqdSA1oEuZ68mrx6brGMAFbvt5vLwlhoNF1TIFmnqwW4tQleNfAL43aPjcoAzXmFZoEqsYi0d1FseixBVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7423
X-OriginatorOrg: intel.com

On Wed, May 22, 2024 at 02:01:50PM -0300, Jason Gunthorpe wrote:
> On Wed, May 22, 2024 at 02:29:19PM +0800, Yan Zhao wrote:
> > > > If you want to minimize flushes then you can't store flush
> > > > minimization information in the pages because it isn't global to the
> > > > pages and will not be accurate enough.
> > > > 
> > > > > > If pfn_reader_fill_span() does batch_from_domain() and
> > > > > > the source domain's storage_domain is non-coherent then you can skip
> > > > > > the flush. This is not pedantically perfect in skipping all flushes, but
> > > > > > in practice it is probably good enough.
> > > > 
> > > > > We don't know whether the source storage_domain is non-coherent since
> > > > > area->storage_domain is of "struct iommu_domain".
> > > >  
> > > > > Do you want to add a flag in "area", e.g. area->storage_domain_is_noncoherent,
> > > > > and set this flag along side setting storage_domain?
> > > > 
> > > > Sure, that could work.
> > > When the storage_domain is set in iopt_area_fill_domains(),
> > >     "area->storage_domain = xa_load(&area->iopt->domains, 0);"
> > > is there a convenient way to know the storage_domain is non-coherent?
> > Also asking for when storage_domain is switching to an arbitrary remaining domain
> > in iopt_unfill_domain().
> > 
> > And in iopt_area_unfill_domains(), after iopt_area_unmap_domain_range()
> > of a non-coherent domain which is not the storage domain, how can we know that
> > the domain is non-coherent?
> 
> Yes, it would have to keep track of hwpts in more case unfortunately
> :(
Current iopt keeps an xarray of domains. Could I modify the xarray to store
hwpt instead? 

