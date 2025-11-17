Return-Path: <kvm+bounces-63327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B73FDC6249E
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 05:07:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 82D4B22961
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 04:07:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8313D30C620;
	Mon, 17 Nov 2025 04:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZIdE5kpC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5521225A5B;
	Mon, 17 Nov 2025 04:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763352430; cv=fail; b=fx/x0x8gAsQiSOjR3JXB3EOj20htm2rrnLhJECAo++E1mW4foWx5RiQc2Of9FEpIOPq9a0AcVBCoJgQ5Pdl2fOxmRNGrKHfAes5Ojla6oxMLF4hvrRO50I2NYTKHAvZ/AuhpX0NNlPOB6lFZ4IK95qqyK4F6910CQMuZkKN5/sQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763352430; c=relaxed/simple;
	bh=DUkYLka3ZSatD7V8IGiVC/MQUPR40aPsSWmTrVXqR08=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QuhCPZHtp5OagO6WyyGEDYfFg5Udn8DeJFIM+Sx691LhiphmCfDiJ+iVHTSLHMYPNFz0etFx1JQYP625JsLu9OgVLDUyksWQK0gP5X4mugbem9yhlQRUA+uTh0YR0cefohGpTWXyNPc7/nnJvuiOBzSSTDd2bovp+8VS2cQAmjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZIdE5kpC; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763352428; x=1794888428;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=DUkYLka3ZSatD7V8IGiVC/MQUPR40aPsSWmTrVXqR08=;
  b=ZIdE5kpC1ZqXFeJ3JkW5mGFBhubTdi+q3BKq1PjJUc5MOPxmpB50QBlb
   H+IYVzM462368pnIn8gQFbLFA3dHlXudUcl1aiXJp9Z9b7eJX0W8fashQ
   2/yYqmFrFN+/V4QwLwP+OxYk/ATSpGDZJBHFmVz7Iu2r8ulvDq+oZSjXP
   7KNFr3lP3epfioGQ+JBByQqP0mdRNp0VftGsAdrPeKg2R9CoEGa2XD5nF
   Nb0/wYgeamFe6GIjpH85n6Nnou5ZYfSxCLPW+dKZaz8YmO8XR+dnd5rBP
   Qccx2Pl6jrwab/79KOfGLz7wIHntp7q5JKvpshE/bUm7X8xBzYGA/21Ho
   g==;
X-CSE-ConnectionGUID: /xGNIgWVSsKu9zRvBASbxA==
X-CSE-MsgGUID: Rq+rRBuCTG6kYHtMeXscIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="65382104"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="65382104"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 20:07:06 -0800
X-CSE-ConnectionGUID: ic4tadwVR+qiQoN9IzINCQ==
X-CSE-MsgGUID: 3DTq58OrQwu86LOeLQmUCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="190130383"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 20:07:06 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 20:07:05 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sun, 16 Nov 2025 20:07:05 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.54) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sun, 16 Nov 2025 20:07:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jp53vUPlZuV6vhftaof82ml39P0ZNxInbX8GIUCJ2Ee4NN0kO/Zc0Dvp4g0+SOlZlAenBwtWnT1OGVmBfY6xj6IZbfld3idj9y+lrc90vqZBTTJ6lwP8w8EoBbM2IOjhFXJj4XMSYVMbIRxnCvohF3mlLudmiWbLXPE7Stz+1ct5MNb21kR2Hzt0ZHr9vkA3dtLTiNff+3mQ61eqoBFhz7uxg33wWhsRouFsJV57u4g5ybUVAo3oT8C2JPbvOQbjls5F8ORnq/Ue1VDfYGfwmm75be/RsnucJNuySbnK+XgPYKejvduzAuzVynjeoZ/5H1UfAhZ85M76Q9/a05SiTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=URClIAgk4sORaLPfVp/Ki5I81lCqc1Q9cZvxUDjGrpA=;
 b=fTY4AlAwRwI4aWZTJDO9RmhFHQuywbe0xXJXnO0ffcGrJSSLk8p+965452dxkFA1jIlrYt15HGldSPs0kBjuOVrfxihvX5JxwVXy0z3GTl2EvvSaCgzXODC0kN+WWv4LCN7/92GxgPbtZ9+aSg5aKMb0pHqJzNfqoDJLsFrubk+6E2U8p+8UFIQHSy/JEOgMizV8yIJDlJx+vnfBvTBeKyTJ4hc/zBUOl/oeq5kRV2541U/bxb4Up2fc6x9zX0WCGu4QsMiCx2aJ7bx2hqv053NR7KZacIAgNBNDypfxXEr3T5rUWBL/qHtSNnxmdU9veDowZN98c/EJi/CzG7GvQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB7089.namprd11.prod.outlook.com (2603:10b6:806:298::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.19; Mon, 17 Nov
 2025 04:07:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Mon, 17 Nov 2025
 04:07:02 +0000
Date: Mon, 17 Nov 2025 12:05:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>, <kas@kernel.org>,
	<tabba@google.com>, <ackerleytng@google.com>, <michael.roth@amd.com>,
	<david@redhat.com>, <vannapurve@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <fan.du@intel.com>,
	<jun.miao@intel.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH v2 05/23] x86/tdx: Enhance tdh_phymem_page_reclaim()
 to support huge pages
Message-ID: <aRqfAlt1sxn7yZJ1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094228.4509-1-yan.y.zhao@intel.com>
 <b4cc4097-67fd-4d31-bf91-ef80e4fc7f61@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b4cc4097-67fd-4d31-bf91-ef80e4fc7f61@linux.intel.com>
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB7089:EE_
X-MS-Office365-Filtering-Correlation-Id: 27d63f0d-83d8-41cd-c281-08de258ec2e7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?fj72wRepGqDGI7O4MIElCDXcjyDCFFOnT9vuhxor2zOU+fD42tHV2YgRmV?=
 =?iso-8859-1?Q?AHgkciSYvLYviTuLew/0Sdd4DqmzTB+rDYnYU07c6bbWtkvaTMe+dDH5/x?=
 =?iso-8859-1?Q?E8ZVGoacZxzgK6u/9p1Ri6vpEwN+q4Os+CgfpDEjUMG03DRJx5Dl+HaQc0?=
 =?iso-8859-1?Q?WopHLAwzr8x23wTyfQrkTOg481S72hPYTj6YxIu0ZZqmzQT1FtJXohowyx?=
 =?iso-8859-1?Q?eZHgGZnpz0JT8T79gOKV5v/gKDotMu9FbY7tiJOcuGODsbEtqeSuFYtPXP?=
 =?iso-8859-1?Q?HgFEXzSomZwEMf7mvgDZwH7HjVo/W2Qm1MPNz5JwZQdS9J+5GrfAJTIiCT?=
 =?iso-8859-1?Q?W7tAxs5acbgYVyPx9F10ww0H9nGVC4oTDrrvM2wFC0Fc4VY9cqpkwXGfwN?=
 =?iso-8859-1?Q?Dsn8fDGdqpfdDSpiuGxP3uVNW2uRm5d5lKWSdMpIWgPoBR5FXJvTqFQZ+J?=
 =?iso-8859-1?Q?xF8Go9yJvB/melsRpqKID0eLcPXtb+yuaToCEylwu6jyQ+mPZo6j0jZERq?=
 =?iso-8859-1?Q?/jrOqu9ETjEL5gbIeD/oUe7hMLzX04SlUkXcfMdnSbx3USBoWSPOilEUbK?=
 =?iso-8859-1?Q?8qUpvWVkFN+xArFNiYsUFAqucMQ4D/pmgDbMkrpeNyh3UBLedmqQbxJSgJ?=
 =?iso-8859-1?Q?Cyfs5X1DGqSTSJdqTMuZvv7gRZ/Ig6hzd71nClgGimjB3UYt8ft9QC5BHJ?=
 =?iso-8859-1?Q?ZNCyftJxTPb1K8vJQtYtbF/LlpfvW5PXmyGhS9L9XTX3r2rRVSOBuH13Nn?=
 =?iso-8859-1?Q?QBnslk/YZT472TvcwcDlijnRAaOCvTRjXi/QKgYbToBatPSSOpxraFenNp?=
 =?iso-8859-1?Q?ZGBGI3sarlskY98+sxVMkxBf4APGjmwOdDYviP5qlpZrptRg/pjwieqsqB?=
 =?iso-8859-1?Q?L8lU5JZDa+OlVZ+Zl3vgaGajwGLWSFC+n8S2WoZ68nzF0kvYr6Mz5JauDW?=
 =?iso-8859-1?Q?Lj4gvEVh5vdoelQvAksJ5xoxBO/lj52tFDEMARKOvWWAoiVQsAPQ9lQX/o?=
 =?iso-8859-1?Q?R3bY4VoN27x+tpjUPdAozkSE1NYIvAaZgK0DXW8sH2lnURuI/Bipvmtowg?=
 =?iso-8859-1?Q?vwS5J1fD5p6PRwAkwTJxqCtSCltvutuTA9ZOH34HafJGRiI1zTaHV0HcCI?=
 =?iso-8859-1?Q?9mLhpkkVY7ry29bfNdCuR3StD3I9w31hKcK290W6NIXVeJv+pAUgiCHNcg?=
 =?iso-8859-1?Q?NPDsFKU9lEnBReQ4DjFZn1rAINfc3HlCDHjmvcjztcb9gFIVkzf0TbgmAz?=
 =?iso-8859-1?Q?f6OIqh6PcYnWoCnuY9mzfBnaFU8GzcRnAIkr0OvmRTcvXROfqDlWA/FzZo?=
 =?iso-8859-1?Q?4XWa5hA7knJUPebOEmAlA8+5cZtnFy6XaLkStw5+0WSVxTWbIkfb4lE0ud?=
 =?iso-8859-1?Q?oid3pZMBMQUR+fI6PH3JRYs3QQ2m0+P3pBuRw65ALp+mCBWI88LNQM2rKF?=
 =?iso-8859-1?Q?55C3CoR4y79LNPBc2wFurte40h0/g76g3td28Zg//W064afIUYuaGTc0Iq?=
 =?iso-8859-1?Q?HAfnvap8e8+sFQv8aOMmcF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?ya+G721Lne+6O0RRntj1+IxYy2Mbf4/Pw3DX2uVJIOhU7j3sABAeBvXTw9?=
 =?iso-8859-1?Q?JqkDE+beWVW5jarf01sRfPJaC+wJmkUUJTG5n4zIWIEAyO4sETeins4r6L?=
 =?iso-8859-1?Q?WnA04O2jZbGDv0+RJjV6nm3KimZEx99BZgr+iJk3jqawA5kH7f79SkJHtx?=
 =?iso-8859-1?Q?qlz/rnxGVgP5T0zSS4pnWpEUIni4YygPY//cMASzhivH5DytMA2nEjmoOV?=
 =?iso-8859-1?Q?iMZYaFrKpqFhKZcANcKeJue1AMBOrh4367QzJyhsbfPWp0SOZm8Dj89048?=
 =?iso-8859-1?Q?ZuBlUp5SzpRR7FThMkQnIui0ChO1SeUSF/L+5ON5pR42sOeZ68aXicfhz2?=
 =?iso-8859-1?Q?KjtNTUSivD0LrYSwQ0qwYVzpcjlOJaNVPiCk4ld/IpWCR9jVlrC4wPpBMp?=
 =?iso-8859-1?Q?Ybxft0s87bQfmJqmGfJlGSi3TgBwyZAkq+rXiauGeN1X/GSW568nVaJKhE?=
 =?iso-8859-1?Q?cYjdKu3R9Q/NQEwq26pz4+XK/a+BG3lhJqEJi6Bw1z2a0VYMK/IBv788em?=
 =?iso-8859-1?Q?UpP/qz5Bar9WIlLCwyF4ee5S5Pg/Nfp6KyWEe/K1MXV0cLf0ZAF+SckQyr?=
 =?iso-8859-1?Q?MfKd9/Hv52byg99R3GhdgypyFwzFnf/2iptbZVehquhOFdck1YFGEBcZXv?=
 =?iso-8859-1?Q?j6vMOXaMf7eE3GqpQR1CJE+E9CnsV19YJwu4W9To9hpqFXiVqJGeUwInNu?=
 =?iso-8859-1?Q?nwi5KvJf9ktCR+Ed54AjxtstKZqepoOEBT9jjZv0xG32fbsreS27b7BI8e?=
 =?iso-8859-1?Q?caQfWZa61nz8uZ/ScXjDOQydMmFx9wJfLfKsU5iikPaz23Db46G8wrQ89l?=
 =?iso-8859-1?Q?keKtr0r1TCGSMnJ3mhZdSsvGLz+f+vw1swkT6YJ0sKrYGmqRHKXwpfTYRl?=
 =?iso-8859-1?Q?hCxnI1IQ3IxZHVYotANlpYVEjbmpwjkLPveHzuBODIhGMdTnanFq4TDAJ1?=
 =?iso-8859-1?Q?x9Oial/xfRKdAKwjxs8Pm2sm6KSVDiQxIAKuy0oEEHRO3SKoWQ8yMuIo61?=
 =?iso-8859-1?Q?cbqIu/0i6cgw7TpRX71c8RHyXPNLRyQAsY+bhIN1Wqa4eJFBKfkm8Tk7pE?=
 =?iso-8859-1?Q?bSO7ybAtqLO2Yyml0BeN4IO8KlrA2WqKX50uCoiKIJC/v5xOxEfMp1CtE+?=
 =?iso-8859-1?Q?QpwUZIUOcKzu8c1JvfKd3Eo2ddtVYn0Ox4EXzxzf6fTnCd/b3kb4KqskN0?=
 =?iso-8859-1?Q?fhrWkT8+w7R6O4rAtRlA0lgiD78eWbz2oirAMj7L3AMYESsaPu/Ydj0DYf?=
 =?iso-8859-1?Q?u6imJBUwHyx3LioAYrCO3SyMaggCquW94fSoLCKCgnzBC/CEQ+lBlxfc7W?=
 =?iso-8859-1?Q?dXg9SR/CHI11erOUqeenV+N7ZBjtvjFGUAa8vKnyPfdmaLwv4axl8Hw9Ke?=
 =?iso-8859-1?Q?7GoR2so6+B9XiKDHGV7BOgZmvEedhJOQWipQ2/Y7fpZQoWX7zf0UiendMw?=
 =?iso-8859-1?Q?njAZ6C4o63vbpFCEWS98oRAC4QLC5RhGOwl2pehhGAjMrGKVSg6ASlABLj?=
 =?iso-8859-1?Q?tD8P8msDCdZEQeXCk2Rij/YRBjYB0t1beU3wsQtFV/jU7o8xQ0J0pI1O/x?=
 =?iso-8859-1?Q?ITWiTCswW5q6SxZANYTJeDbdl3XQPrwFGiuP/JierzyxmPHOqefEL0BtCs?=
 =?iso-8859-1?Q?VjeTx2ejCbRfNx5AIGQVuTsarHEW2VooMM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d63f0d-83d8-41cd-c281-08de258ec2e7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 04:07:02.0540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sqn79uK5icy1MlMu7tz70tThkA/qwLEcfTGplvyDnibxB9t9JSnJ6f6JD0ZXP0I81Pc09WwT9E8sM/yeUMk2RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7089
X-OriginatorOrg: intel.com

On Mon, Nov 17, 2025 at 10:09:42AM +0800, Binbin Wu wrote:
> 
> 
> On 8/7/2025 5:42 PM, Yan Zhao wrote:
> [...]
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index 64219c659844..9ed585bde062 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1966,19 +1966,27 @@ EXPORT_SYMBOL_GPL(tdh_vp_init);
> >    * So despite the names, they must be interpted specially as described by the spec. Return
> >    * them only for error reporting purposes.
> >    */
> > -u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
> > +u64 tdh_phymem_page_reclaim(struct folio *folio, unsigned long start_idx, unsigned long npages,
> > +			    u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
> >   {
> > +	struct page *start = folio_page(folio, start_idx);
> >   	struct tdx_module_args args = {
> > -		.rcx = page_to_phys(page),
> > +		.rcx = page_to_phys(start),
> >   	};
> >   	u64 ret;
> > +	if (start_idx + npages > folio_nr_pages(folio))
> > +		return TDX_OPERAND_INVALID;
> > +
> >   	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
> >   	*tdx_pt = args.rcx;
> >   	*tdx_owner = args.rdx;
> >   	*tdx_size = args.r8;
> > +	if (npages != (1 << (*tdx_size) * PTE_SHIFT))
> > +		return TDX_SW_ERROR;
> 
> Nit:
> 
> The size check here is to  make sure the reclamation on the correct level,
> however, tdx_size may not be updated if some other error occurs first.
> Do you think it's better to check 'ret' first before returning TDX_SW_ERROR?
> Otherwise, the error code provided by the TDX module, which may be helpful for
> debugging,  will be buried under TDX_SW_ERROR.
Makes sense. Thanks!

I'll change it to:

	if (!ret && npages != (1 << (*tdx_size) * PTE_SHIFT))
		return TDX_SW_ERROR;

> >   	return ret;
> >   }
> >   EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
> 

