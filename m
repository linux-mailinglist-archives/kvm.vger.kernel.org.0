Return-Path: <kvm+bounces-29001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59B109A0C51
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 16:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7414F1C22106
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2024 14:16:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA09D146013;
	Wed, 16 Oct 2024 14:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XMlNTgUX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CC4502BE;
	Wed, 16 Oct 2024 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729088167; cv=fail; b=bYLnpmI0QFCX6k8/H4qBrWm2EOK0tN546zVVOy1W8KMMH1I9UCT8XOGmULHA2olIC3Gr9W2lew0OIqjIeDwZT7aswPhx+30QL0sLtQv7zgDA4az5bDFmToW9UJaCiDrxS+nhLTs2/XKxxNW7CHIN5UnTLf20S2zrHMjA+jnfyf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729088167; c=relaxed/simple;
	bh=/ijA9JT3nqCfPQMcgfBu5PkVUwmWBRnlPRXCoFwlqh4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mcdQJGDAKojDKf0p4KzS9Hhg/gkeFiY8cYv6SjTDKjoJG+XMGO9KrMeeIzrW+ZpgN3pRqE0Ug23BeXood8j5LtZRV0W99+wOLoxXhRo33S4f8veIclt27cfjjeUnbiiFvtU/J7oJe26WTJ0Nq69RSkWsqmvI6EeYqjelhVj+Q58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XMlNTgUX; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729088164; x=1760624164;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=/ijA9JT3nqCfPQMcgfBu5PkVUwmWBRnlPRXCoFwlqh4=;
  b=XMlNTgUXjlBeHB3JHVU4ewx2NtMuiCWp0n22UUPU2Ci8CPaW00wRr3BU
   Y+QMdKLg04h65yqlhvX35MLbrDI1ysMuPeAtA0qKEl3KDYhxiN/YHR8Hv
   QdIfH4E162FXruc8nAq0icd8gBZBVW+6TsXg7fNcBjr6AeQeihDjRz3zw
   wlnRu0WoZyK/OoJHPLYnmJc2MkA7aq7224jEZlzjUJfj247V86B2q9u2n
   FPGCATkmvFZUXoRfXP/ZtV5T9rbcbme/0rDxJOZ4u026fyRFEg5uPheIv
   I6Tu9FZzPBaD45nFLU6XHLAKpLHLLFv4MvJ42J3vuQFPDrbO0wtwkU54Q
   Q==;
X-CSE-ConnectionGUID: p6qCqbhySvWbUm3mkErfKQ==
X-CSE-MsgGUID: xLXTAHYJT4G8/0XvVZk6pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11226"; a="31401545"
X-IronPort-AV: E=Sophos;i="6.11,208,1725346800"; 
   d="scan'208";a="31401545"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2024 07:16:03 -0700
X-CSE-ConnectionGUID: 5cASALFVR2+kBTWUIQlzHQ==
X-CSE-MsgGUID: wNJweS7TRgCZ19gyhoXu2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,208,1725346800"; 
   d="scan'208";a="78191682"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Oct 2024 07:16:02 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 07:16:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 16 Oct 2024 07:16:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 16 Oct 2024 07:16:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 16 Oct 2024 07:16:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EhREBNQ3Itwb4z7DyLfM0tUU6VCB95GAsuM4M5t4YOZRomrgYIVaZM7KUb6+fHNv0kCj3/EDS/wkqXF0cP6ZM2wneJ+oJYR3/5LfbNaiYGtFZiMVdxx8beNC8Isvhrx543KzHT88zCShhQDPIdciwSjeXokBKqO+DCCebVUdXc2/3LRTGOz7iKGZeCCU/OSmRjrrwTkDojGCGPt6j/mQyStX+nXQD52RX+aDY53pECb5WrTyUpgnC1teoZguHsp9/zEOudDT2jphjYtV8fbk+gc1wMbQZLKP6QRE3Yhaki8lSojTtibqDQgA786Gjm2YjGaeo+lzHpfLmxd5ptkqEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xegdd0I+4Ff11jKjSwQWdnwp1Cqb/DJ5PP4DUObE5Hs=;
 b=YpGQtTMRPIisjOxGR8Jqj3aOU8gbS4BBQqKMWSV6VGWwkyGGsotWoTJTMIil/GOe9yK89+0y+iWhQSfFactajJr048oeBkCP1LikTHKaw3XkBrbMjkSJqvbsjNvubNpDJfmHgBKNmxVTmC7NTuUCndqiA/iwcU13pETWFxkHjoHE0v8hFtb8Z1tl+A4SSWtfBtQNP9FL27H2URZIzfMLCB/K+PWCbmJbq3Ii5naS92LCCaMphhQio92acHFTSayHiYZEFR+Bnh9wGaCxbZe824JtImT7R+hcAHH1SYJEO3801242IUgaTS1HQ32k3Qev1pwxF56XQk+3e/bZzfpLVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB5888.namprd11.prod.outlook.com (2603:10b6:510:137::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.27; Wed, 16 Oct
 2024 14:15:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.020; Wed, 16 Oct 2024
 14:15:57 +0000
Date: Wed, 16 Oct 2024 22:13:38 +0800
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
Message-ID: <Zw/KElXSOf1xqLE7@yzhao56-desk.sh.intel.com>
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
X-ClientProxiedBy: SI2PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 660bcb12-9fe2-4ec6-0d17-08dceded0dce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?1ZRzJIOZsMA79rmmr0NFdZWhAQ4kylVQ+ye7KBgOlz4ta4fbVCgADzyX9fQ9?=
 =?us-ascii?Q?O5eEKFCxAsltxERLRAxG0MO+FmZNIwn1uY5OUbwN7A1KJ7JlSWirFZDS9qh2?=
 =?us-ascii?Q?JigjWiHDCnjPSmPQYKXYVMkVHF/baaiJXc3SP+dJzSG5+bAm1zufb+vfJcxU?=
 =?us-ascii?Q?QB87tLvn0DdlFcJDHklTstgZ8BzedOKIDmFYpSiUHl54i+bYNGqlHsk/2l1d?=
 =?us-ascii?Q?1LhStXzSmtvFwiDWkgra2Zj+Rk/iH3A20kaSkKGRuSMHqqhN6qL3kmZkS2py?=
 =?us-ascii?Q?0aCGIXGYo2JQCr4x7BhgDPoFYUdvYXVTGnvmI5uj8WjEDojRUeFLiwVYkl7S?=
 =?us-ascii?Q?1JM/q46PVp+jaNQUbCFcOQxuM2dZejZcAMMUvV3gptdbKABbvsRU7Ge0x707?=
 =?us-ascii?Q?uPbCIboUK7qKfqEqLiu7w+oEQfAqXLJdtEonEMA7dKNh27rIwRPP9RaMSHgr?=
 =?us-ascii?Q?GB3Ki7CFb6oEdGgZJi0hlrPZbLCCeMdxEjxqRt5YPNH0tSOPfdhhpRQlEoZa?=
 =?us-ascii?Q?i0I2sHYw7abCkJKvVs2vYYbYDocrAbAb2jtOoNIuVhqqkoAtcIalh5l/WcER?=
 =?us-ascii?Q?d88PKY877T2vRd7kq/6r+gQbyaPqTOaDrNZlzm6NXbnFcrFmHQUpUneR4omw?=
 =?us-ascii?Q?7pYUIiglkgHYaClh8+NkzFSxR/oGQwGkn5uNAiYKstoRh8NAa8z50pkbL/1y?=
 =?us-ascii?Q?7q4sXIFM27mlRVlAhRsM75Rri1hkOx7DHqfZC3Q8SSQ5l7O3XgCsqwzciUuy?=
 =?us-ascii?Q?XubjL8oT5xvNnRWVNLbQHsENSMJ8ccrf7X7R8jPOaNAW+yAeNopD8dEjs080?=
 =?us-ascii?Q?8orF51Bz9ZJBH787MoTzdExsBjB9YrMc/m4WjYYWUGu5Iu19j+KRtV53LLKd?=
 =?us-ascii?Q?/1zMAfcff4KP/UsymV4vhe5yfxobTavsmqoiKZy2+vzzghbUKG9+XLy8YNz6?=
 =?us-ascii?Q?eAXI41fyZ2Aypzk+5PbwoWTXdhvIh1AEmK79A2aewnqzoJYQG5QLZcMIq7hj?=
 =?us-ascii?Q?CaQCxdpFrp2q35R47wXzKww4CXNZNHSLaI2BCAnnfy2LyXwT0ot89mv7bBwc?=
 =?us-ascii?Q?K8oR8708RlNxAQCOLmKxltCHHbW3b3+boP0BqO7QFxJ5DTI2TQ/20ahcMrT9?=
 =?us-ascii?Q?stRYVroF63yneucj9N9OKIIpoSXm1gjTl3mojJB3HS2c94dLhB6yHMej9cxc?=
 =?us-ascii?Q?J9hQWQkEoT813Wipbf6SIERf6bmVkSaXjqD5VDkgDJQmrpNGlFu/c+f1E/vD?=
 =?us-ascii?Q?/+gzhXkPMUD8t2iVW83yuTaoewv68FH0tjNdJmL48g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V7yZ+1THkJ57jdEpO5063n5XovjmH7rc9LYYC469HE9xQ8+1kzOvFsL/O+tc?=
 =?us-ascii?Q?sn2sOS8cRt37y0zGFcwXteQoi7/EpHjsbvGWAa7wHimByuIyMUXr3e5kVA8W?=
 =?us-ascii?Q?vYcYNYBf7g0EDyZ/cGVsniy4RNnnFnN3reds/wVE7CDDjKJWJeBrMDMoiTO/?=
 =?us-ascii?Q?fUG5c+OSX0hzFH8rV6bnSdko7JLs+GRH2j3YaX5VSYzm0f6bbpJVmIc4n4XU?=
 =?us-ascii?Q?Ij9VtuYNK7DNx4OY+eclIowgwt1H2Ii1dmBXUHLL91UGuk8CLXQPDxdKNKZ5?=
 =?us-ascii?Q?ArzfrC48bZfN+jtPBIkmJBUmv84JhLjQ9B7YaK9gX2yz6wnEV37pVAaFFUus?=
 =?us-ascii?Q?2m5gWa2/n3fQ6ZY/YqjD6IBNl/iWBDvBXIELos3rh68PTsgq+MBnQtrakoah?=
 =?us-ascii?Q?uR/gN3gOxc1wfji//z5k/5Rgc71MoEkaji9VWaHAqwqO3OQkG4Z0YyPjiGGl?=
 =?us-ascii?Q?6e99fmJLsysALGce4BKir+QqJ4PBs6dbj3I62AK7MNBl9Epkx1YPyacLeswr?=
 =?us-ascii?Q?W7q1bhZHMbBAP/AJHJIipBqzK+LIDPTF43utLiraI77vZFmO9eCK31ZZG2vs?=
 =?us-ascii?Q?TUtg6df+SfwIDdQe12q3YUuWBUiwIrmGFC/7lk/V46C/iCMM/MXmGWVBBHvk?=
 =?us-ascii?Q?7gYxhgqsQjaeW91WNzJwkBmlOOOmoxUg1rTT9HIDfiJ41VRhTckD+GQrkOiq?=
 =?us-ascii?Q?npEFtFzgj5vaaOj8mNhsX5oVw36WXqlvIG4qT6WMN6fFjVrGONjrRNDyAitM?=
 =?us-ascii?Q?3K49gbBSsfDkhHhNdBkt1zQcr6yyzn8LgHdFWDCkvkeg3ogd8oJfWzKAIk5m?=
 =?us-ascii?Q?ai1C3ef8+SfgPHJBW82YJ6BWxx244E5qaWP62U/ILzIGkEHQudZ/5bdzaes0?=
 =?us-ascii?Q?p0VbAjeyYtPy/GpgPVpDTlEbdFhS1coHaOq9KIDT2kF8LMUvrv4zHTS1dN7t?=
 =?us-ascii?Q?uAac2r4AoyDNV6DIPzt4bW9L4vSEbFkjtXJtBM0d4KXuic5ArarsDPkv5ukq?=
 =?us-ascii?Q?AwK+lNnLadS1K2FT/O1DctzQGX6lZj0bZTnYq0g8euSkdJ3W8aDogh9ausLw?=
 =?us-ascii?Q?VWwP4JSH3zdnAKInsxaWcl7VEp/8fRzHSi22PyJ/XsMUtctC/LRHQ3GtFzIy?=
 =?us-ascii?Q?xI90PsXtnuNNM68d1H8rPWG3sYZU8045tszbeVczbJrgpcdxkzGQruoZcEdt?=
 =?us-ascii?Q?rj3aC+muTUaxeD8DQNdUltov5QJcfM7OYFxNxanoDapEt4Ccu2g0xWInTP4T?=
 =?us-ascii?Q?qVpypZRJzuIweNqZzw9HcPNuhhLPJ4dffIWwUD1773erXbJpSUb71Geh3uhS?=
 =?us-ascii?Q?/SKbPpzpDQCWMCSLkYby7oDNmDyxUNgogRu4efDs9JI4iFgcRkInHbr5mZTy?=
 =?us-ascii?Q?C1ZY7hzA8eDSoE9qpj6Tp7m9WvtSymzadtnKxzvKHSAVBD1WlVWHW0bczeQq?=
 =?us-ascii?Q?TcCtuvT7/Otbb20QzPi3ZTWXLGK/TBfjIy4ray8rsJ9WdoI55jQv2KF8XHyv?=
 =?us-ascii?Q?fYKep/sJn+w9hkLjI9GeRe0gy3Yn5BkklyHRzRYOZ14qL6WRmpIbx4OL6z0O?=
 =?us-ascii?Q?lX/sWAAYZyYZaVp0Fl/LydRSoyhv/bISrKUawMPk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 660bcb12-9fe2-4ec6-0d17-08dceded0dce
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2024 14:15:57.5864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zr88xKOv1S/9AnvKk11kMJQhkjoqQsWseNMVVwQDkRqTzlVAVa5rVEQhzw8ao1ZVHzu8O71feQrxzfFA5BdN9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5888
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
You are right!
I just realized that if TDX code retries internally for FROZEN_SPTEs, the 6th
attempt should succeed.

But I found below might be another case to return RET_PF_RETRY and trigger
zero-step:

Suppose GFNs are shared from 0x80000 - 0x80200,
with HVA starting from hva1 of size 0x200


     vCPU 0                                    vCPU 1
                                     1. Access GFN 0x80002
	                             2. convert GFN 0x80002 to private

3.munmap hva1 of size 0x200
  kvm_mmu_invalidate_begin
  mmu_invalidate_range_start=0x80000
  mmu_invalidate_range_end=0x80200

                                     4. kvm_faultin_pfn
	                                mmu_invalidate_retry_gfn_unsafe of
				        GFN 0x80002 and return RET_PF_RETRY!

5.kvm_mmu_invalidate_end


Before step 5, step 4 will produce RET_PF_RETRY and re-enter guest.


