Return-Path: <kvm+bounces-5193-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EA2A81D3BD
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 12:17:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 42C1C1F229C2
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 11:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4093BD264;
	Sat, 23 Dec 2023 11:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RGyRgiRw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8895DD262;
	Sat, 23 Dec 2023 11:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703330220; x=1734866220;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=uwrxtNtuFvRSXtc0Qoo+jiRibQmllzPnkah8RRjDmG0=;
  b=RGyRgiRweOdx2fcvRwT5vODBhQsXCvGJD+nWy0UAcz1nNrqyJyeWvU0b
   imYWU4SqYsFOrpHeqTuzDF8nW7MzDqXOaHkIFscs1RVLH7HjQUNS/vKzs
   l4WYe+pkdYdCSmiYhxsobQlFY6saeFUF7aRl6MyHN0dhig2BkWEbNPZ+4
   yUoQ6ZPW8orAAO61nHeJ8YMBLfa6Yez2DGr8gWJXYPhL1haJS8SuuZ3c0
   bQccvjn8GnED7L5caHKNZ9UFhA5KDt/v0g7un/HAElyXgGQNyzuRnNdik
   7ZLxUgNJI6+BSa3ZyY4/UDUnnAh+X+zua/xnD505Nb3SRF7bPuDMhQ/1V
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10932"; a="9684898"
X-IronPort-AV: E=Sophos;i="6.04,299,1695711600"; 
   d="scan'208";a="9684898"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2023 03:16:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,299,1695711600"; 
   d="scan'208";a="25608859"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Dec 2023 03:16:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 23 Dec 2023 03:16:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 23 Dec 2023 03:16:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Sat, 23 Dec 2023 03:16:57 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 23 Dec 2023 03:16:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY507QYBNEPe7/kVDwAL8TN/XakifHwfacvcjaWZ1qFJ1maAMDWsCKD9Juq1NHaL8eYSR9ZwQ6ZO8Z7zb26ovNavAjQn7TXSxIwIwD+PFZ+ycc3R3XvIHQs5Jez0RSdRGr1jIPt/XhXiYzHG5NaTfxoybBtPSmUkjQrMZnTvn/b3PY3ve7H4+qyFeayotGCJsydHgEeHQ4XA5CVsi8BGll/9z4rJwNEahrDzS3K3qHypCQ3USxv60lBwlmfdywDyI9XfC1Kht3jUSEDhBj2jxnN6dP1xSR4wl6kZEaX7cZPtsvdT7jg9gU4EZ3EYg+m1wD8MbGo1fOKFt0yxlK1lcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfXkyZSoRJSFIYelhVhSiJJ3XqlTe8uunABla4nyBCU=;
 b=eKPpLLSOz0WbN8HFA+qzZcvSjdpm84LMVW9k5b65iijk4vn2kvMez2Pz5NJlfrnU7Smf9M6GVbfB4E9QFh8g/tRhV0I82qki6PpuHNSJUIq4erjNLb1Jo5s/0RCqsH+jo0N1plG7qzLwprLyykGXA+xhaAtw+lzj/TLeqNDARNS4Qp8tpmuBiIUbh7r7qvuJ8WueKGP8/sl+z4+LSQ3iK4GK4ydI8B5PIXZWpeEEv1dU/LXcTkkV2hbSCUj3VWcm6DON6ltPMmXCtQ1/lW/1DVqW21XpWWe/Okhn5/q9RmA9LfpVkG+FHgHVCeAtMIRa5arcw3DdoJnfmqxt+LxAGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
 by IA1PR11MB7943.namprd11.prod.outlook.com (2603:10b6:208:3fc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.21; Sat, 23 Dec
 2023 11:16:18 +0000
Received: from BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::2f1a:e62e:9fff:ae67]) by BL0PR11MB2995.namprd11.prod.outlook.com
 ([fe80::2f1a:e62e:9fff:ae67%5]) with mapi id 15.20.7113.022; Sat, 23 Dec 2023
 11:16:18 +0000
Date: Sat, 23 Dec 2023 19:16:03 +0800
From: kernel test robot <lkp@intel.com>
To: Mina Almasry <almasrymina@google.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux.dev>
CC: <oe-kbuild-all@lists.linux.dev>, Mina Almasry <almasrymina@google.com>,
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, "Stefano
 Garzarella" <sgarzare@redhat.com>, David Howells <dhowells@redhat.com>, Jason
 Gunthorpe <jgg@nvidia.com>, Christian =?iso-8859-1?Q?K=F6nig?=
	<christian.koenig@amd.com>, Shakeel Butt <shakeelb@google.com>, Yunsheng Lin
	<linyunsheng@huawei.com>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: [PATCH net-next v3 3/3] net: add netmem_ref to skb_frag_t
Message-ID: <ZYbBc7NLzkZTEYRt@rli9-mobl>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231220214505.2303297-4-almasrymina@google.com>
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30)
 To BL0PR11MB2995.namprd11.prod.outlook.com (2603:10b6:208:7a::28)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB2995:EE_|IA1PR11MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b5b8570-07a4-4b9a-1c39-08dc03a893f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1DW39/2jkzdyUgttT5nZDuX/RJYFHfT/AlmE16EI4cdmpy8LIBdjh8j8aqPsPJtBh6gIx+TVth2YD4wtfHFOLMj5K48nVW5mFC0EgleVt/6yvBJ4AA7C6mskj0Nvk5XOt4IB8SZwHpf0usC1dyYFsHv+JZL5vFpV/kR63UJSjGkr13DaHbd3Go6E7Lo2XGFkxWNpHK3BMANaRAYuit6ZIszqsyx7o+XvGXvw1SZ8kNru4p5G4QNBD5fMjvvNH2m6XUJPYNaU6F7MuknMY1e54Wm+se2c/NobB3JrBfJLMTFfhMqPg9nTRvHhwlnElIQ/kY6mqipIUfqSWlH6nEu5mRupjCC/aqhOXmR8Wk/xOz2Y+pOiheMowR+3tw9L0RD5l1Ylh6PV46H+X1lDgHfI1TEBYm6il1NzpH/OcebqwaD1r7mX8s5Zsfh8Cy6J5thlAtbaY39AgYB3LbHRsf6R8hfSoMF6DZk29STdTAzQTi/nGHiZnF1LQ4SSRyJ5KUApSC9hw8TFYnuz/AtycWDh1wbxS4X+28E2uMCZF/H8X9QEGh5C4CoQY6ZPNJb0t6uXtpcDErvssjcediOKlssDaEhXdLNS1HzOOIYwJOx7KZdMdf2vBjB6QAOejAJp+d8baCGGmWJdn2zv79G9rIDFQkItZm/x9Eh5qiUh/eaGl34=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB2995.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(366004)(346002)(136003)(396003)(376002)(39860400002)(230173577357003)(230273577357003)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(83380400001)(38100700002)(26005)(66946007)(66556008)(316002)(8676002)(8936002)(66476007)(6506007)(54906003)(478600001)(966005)(6666004)(4001150100001)(6486002)(2906002)(7416002)(30864003)(5660300002)(4326008)(6512007)(9686003)(33716001)(82960400001)(86362001)(41300700001)(579004)(559001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x4hU7WaH5cLQ6Yk4qjRRwvekcLw5mPRvbsCdHfqBZeaVdn7M52eK2xjzK2cP?=
 =?us-ascii?Q?hYXOg2HBfhJa6+gt7hmtqi4oLnQq9g+xc6aO/5NQl98BdXHCb0TTGvLqitQZ?=
 =?us-ascii?Q?AZOzj7k083l+5xx6VfSwgrZlsRdufNrkXWO68LthYCp+0S2Tw+SsCvqTu8sG?=
 =?us-ascii?Q?NspYVVPHARQSygu7p9TicPdLlMyCxtzq1auM3a+abfE5FoyqQTl/FVNymUkS?=
 =?us-ascii?Q?RjAT51gGwATvCh/t0M60Dvj20oevU2hDmVtq0QJlnt9L9ChY/7bzB4ZJzpXE?=
 =?us-ascii?Q?92WxdOo0qxV1+sq8rb0LqGfHbtTY2O4BPngArYHcBDMQJwDUz5FWahhhTqtX?=
 =?us-ascii?Q?/pFyLiAnYWYPyQ73l9JC1itFC+iPVAxjMl5DmfzKfcpJM35Bk+yaGqX5GBhd?=
 =?us-ascii?Q?u2JDhpTXNxRBBKXI/RxN+ODr71KYXFLF0mhLDiJVyTvLbkeL5W175a+5Emcq?=
 =?us-ascii?Q?RozCct3jPTiAbXa4vcRQunnfx3LUVkTo0GIVxO/YQ2fkgVt3N0ZVkd3MMOnz?=
 =?us-ascii?Q?0NGvoyM0wGXM0Noc4P7+YPWSrFJfqXijOCNXuLLK4F3MJK+853BInP++nQCF?=
 =?us-ascii?Q?TfBr/YgjKxrpQqZQ36EEEp+BRyJ80bxbEeifQsanZE0kJtamfgAFMJJf+axe?=
 =?us-ascii?Q?CsUzcTTsYpvAgrCAUYbfJpwBjs/9FhmjiAurQ7bGbG7v9vRa0RHq3wRFebP5?=
 =?us-ascii?Q?5YF7hNOXeObXeCLeZiVHcX2m/71opE5Ohpqw0XgX7Oai9yyoS4xW1q2/hx2I?=
 =?us-ascii?Q?yFTOHwNIxXMlG/yYk82YEbv+l0MiCycq+Eg32lL+TeCW/7xV/4rhWWRXFQje?=
 =?us-ascii?Q?FKJHGUEuRG+8FHqLnkYtSt3XhuNU7WLV/ENY/WSPZ9mizt43sPOEQm5DAj00?=
 =?us-ascii?Q?oM9wi7NZ/K3SpGgDoIg2fxNWXYmR3QO3m5fXMzvo3K/7Z9NyeC9s03nyCoQE?=
 =?us-ascii?Q?YxQRZp9D9IuT3PpY+v3VOjCOo26jMcptVNlhHzY/CczxYNabrauJ3f8MNM8E?=
 =?us-ascii?Q?AbMRydEj6r4FJlQwd2N2bUHsZmZF9FTBF2kPiqamzKBv7EtqzS7aGUcdCyQ0?=
 =?us-ascii?Q?bUBAf9bpfja2y6QLcbZ53EHVmsB+8WEdDnUJ5AFf3fm5Lj6iNNt7lIxvpY/k?=
 =?us-ascii?Q?Bv0kd6Oii2FES4we/4F0EQPlwPcuwKlebEeWTQqtVEqZ04ymT98Hi16UX+Vy?=
 =?us-ascii?Q?qd0yioKlXrI9ZJVPkI9WK1ttCx/DNTuXWDu0Bg9WO8g/M2/WG3ktL32s1/S4?=
 =?us-ascii?Q?+Yg9apMzGizBW65N6Nl2NUOcPqTG6Gx/W8ZXJ98sLngerD9SC0VLsBVefcCg?=
 =?us-ascii?Q?MLnLR5VWN0r3JWj/ERRE3amDJmiup70/In5NFYqHtPmenCaO/OmdPAk3Zp9c?=
 =?us-ascii?Q?WZ95ggC68gmQ2TUsW5ycZdSf5QLlIN85b8DQqsDV9ZspWNZrANagd4w0If2H?=
 =?us-ascii?Q?0bVrLnBJS88FJWKVdhJE8LFzCbKVRR8kJPVKIWvkJDVP06IcUI/tzdLaWw+1?=
 =?us-ascii?Q?UtWf8U1XAzQt/2JmZnHNZWHgDrSw6yyxKoY6LJFvtEWTrH7SswtllYrHUC0H?=
 =?us-ascii?Q?pFDL57s7Eq/whCVz0mtTOYIm7Ec8AXaudwJ7UCEs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5b8570-07a4-4b9a-1c39-08dc03a893f6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB2995.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2023 11:16:16.2267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TDuLWab/TKnHE3rfXyj8yzLAdDSywBOF+smWqRMuutgana/yuunkk43HUjPGmVrrlmkbfNgB29ve4ftm6wLBxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7943
X-OriginatorOrg: intel.com

Hi Mina,

kernel test robot noticed the following build warnings:

[auto build test WARNING on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Mina-Almasry/vsock-virtio-use-skb_frag_-helpers/20231222-164637
base:   net-next/main
patch link:    https://lore.kernel.org/r/20231220214505.2303297-4-almasrymina%40google.com
patch subject: [PATCH net-next v3 3/3] net: add netmem_ref to skb_frag_t
:::::: branch date: 15 hours ago
:::::: commit date: 15 hours ago
config: x86_64-randconfig-121-20231223 (https://download.01.org/0day-ci/archive/20231223/202312230726.4XaPn84E-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-12) 11.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231223/202312230726.4XaPn84E-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/r/202312230726.4XaPn84E-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   net/core/netevent.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/netevent.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/linux/rtnetlink.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/request_sock.c: note: in included file (through include/linux/skbuff.h, include/linux/tcp.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/request_sock.c: note: in included file (through include/linux/tcp.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/utils.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/inet.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/utils.c: note: in included file (through include/net/net_namespace.h, include/linux/inet.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/secure_seq.c: note: in included file (through include/linux/skbuff.h, include/linux/tcp.h, include/net/tcp.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/secure_seq.c: note: in included file (through include/linux/tcp.h, include/net/tcp.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/net_namespace.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/net_namespace.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/linux/rtnetlink.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/stream.c: note: in included file (through include/linux/skbuff.h, include/linux/tcp.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/stream.c: note: in included file (through include/linux/tcp.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/dst.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/dst.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/gen_stats.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/gen_stats.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/linux/rtnetlink.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/gen_estimator.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/gen_estimator.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/scm.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/scm.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/datagram.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/inet.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/datagram.c: note: in included file (through include/net/net_namespace.h, include/linux/inet.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/sysctl_net_core.c: note: in included file (through include/linux/skbuff.h, include/linux/filter.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/sysctl_net_core.c: note: in included file (through include/linux/filter.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/dev_addr_lists.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/dev_addr_lists.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
   net/core/dev_addr_lists.c: note: in included file (through include/linux/hrtimer.h, include/linux/sched.h, include/linux/delay.h, ...):
   include/linux/rbtree.h:74:9: sparse: sparse: incompatible types in comparison expression (different address spaces):
   include/linux/rbtree.h:74:9: sparse:    struct rb_node [noderef] __rcu *
   include/linux/rbtree.h:74:9: sparse:    struct rb_node *
--
   net/core/flow_dissector.c: note: in included file (through include/linux/skbuff.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/flow_dissector.c: note: in included file:
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/link_watch.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/link_watch.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/tso.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/tso.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/linux/if_vlan.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/sock_diag.c: note: in included file (through include/linux/skbuff.h, include/linux/filter.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/sock_diag.c: note: in included file (through include/linux/filter.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/fib_notifier.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/fib_notifier.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/linux/rtnetlink.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/netdev-genl-gen.c: note: in included file (through include/linux/skbuff.h, include/linux/netlink.h, include/net/netlink.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/netdev-genl-gen.c: note: in included file (through include/linux/netlink.h, include/net/netlink.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/dev_ioctl.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/dev_ioctl.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/sock_reuseport.c: note: in included file (through include/linux/skbuff.h, include/linux/ip.h, include/net/ip.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/sock_reuseport.c: note: in included file (through include/linux/ip.h, include/net/ip.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/gso.c: note: in included file (through include/linux/skbuff.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/gso.c: note: in included file:
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/flow_offload.c: note: in included file (through include/linux/skbuff.h, include/linux/netlink.h, include/net/flow_offload.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/flow_offload.c: note: in included file (through include/linux/netlink.h, include/net/flow_offload.h, include/net/act_api.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/netdev-genl.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/netdev-genl.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/net-procfs.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/net-procfs.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/xdp.c: note: in included file (through include/linux/skbuff.h, include/linux/filter.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/xdp.c: note: in included file (through include/linux/filter.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/neighbour.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/neighbour.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/gro.c: note: in included file (through include/linux/skbuff.h, include/linux/ip.h, include/net/gro.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/gro.c: note: in included file (through include/linux/ip.h, include/net/gro.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/sock.c: note: in included file (through include/linux/skbuff.h, include/linux/ip.h, include/net/ip.h, include/linux/errqueue.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/sock.c: note: in included file (through include/linux/ip.h, include/net/ip.h, include/linux/errqueue.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/net-sysfs.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/net-sysfs.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/gro_cells.c: note: in included file (through include/linux/skbuff.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/gro_cells.c: note: in included file:
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/ptp_classifier.c: note: in included file (through include/linux/skbuff.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/ptp_classifier.c: note: in included file:
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/of_net.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/etherdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/of_net.c: note: in included file (through include/linux/if_ether.h, include/linux/etherdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/failover.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/etherdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/failover.c: note: in included file (through include/linux/if_ether.h, include/linux/etherdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/dst_cache.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/dst_cache.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/net/dst.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/rtnetlink.c: note: in included file (through include/linux/skbuff.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/rtnetlink.c: note: in included file:
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/skbuff.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/inet.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/skbuff.c: note: in included file (through include/net/net_namespace.h, include/linux/inet.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
>> net/core/skbuff.c:848:68: sparse: sparse: invalid modifier
--
   net/core/dev.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/dev.c: note: in included file (through include/linux/if_ether.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/net-traces.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/net-traces.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/core/filter.c: note: in included file (through include/linux/skbuff.h, include/linux/filter.h, include/linux/bpf_verifier.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/core/filter.c: note: in included file (through include/linux/filter.h, include/linux/bpf_verifier.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/common.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/common.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/strset.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/strset.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/wol.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/wol.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/privflags.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/privflags.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/linkstate.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/linkstate.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/rss.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/rss.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/debug.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/debug.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/linkinfo.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/linkinfo.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/bitset.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/bitset.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/linkmodes.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/linkmodes.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/features.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/features.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/netlink.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/netlink.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/net/sock.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/rings.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/rings.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/channels.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/channels.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, include/net/sock.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/pause.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/pause.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/eee.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/eee.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/ioctl.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/etherdevice.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/ioctl.c: note: in included file (through include/linux/if_ether.h, include/linux/etherdevice.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/coalesce.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/coalesce.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/tsinfo.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/tsinfo.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/cabletest.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/cabletest.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/linux/phy.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/fec.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/fec.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/tunnels.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/tunnels.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/eeprom.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/eeprom.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/module.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/module.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/plca.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/plca.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/linux/phy.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/phc_vclocks.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/phc_vclocks.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/pse-pd.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/pse-pd.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, net/ethtool/common.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/stats.c: note: in included file (through include/linux/skbuff.h, include/linux/if_ether.h, include/linux/ethtool.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/stats.c: note: in included file (through include/linux/if_ether.h, include/linux/ethtool.h, include/uapi/linux/ethtool_netlink.h, ...):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier
--
   net/ethtool/mm.c: note: in included file (through include/linux/skbuff.h, include/net/net_namespace.h, include/linux/netdevice.h, ...):
>> include/net/netmem.h:28:54: sparse: sparse: invalid modifier
   include/net/netmem.h:36:26: sparse: sparse: invalid modifier
   include/net/netmem.h:38:27: sparse: sparse: invalid modifier
   net/ethtool/mm.c: note: in included file (through include/net/net_namespace.h, include/linux/netdevice.h, net/ethtool/common.h):
>> include/linux/skbuff.h:364:20: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2440:57: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2456:67: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2498:54: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2521:52: sparse: sparse: invalid modifier
   include/linux/skbuff.h:2571:68: sparse: sparse: invalid modifier

vim +364 include/linux/skbuff.h

3953c46c3ac7ee Marcelo Ricardo Leitner 2016-06-02  362  
b2e5852793b6eb Mina Almasry            2023-12-20  363  typedef struct skb_frag {
b2e5852793b6eb Mina Almasry            2023-12-20 @364  	netmem_ref netmem;
b2e5852793b6eb Mina Almasry            2023-12-20  365  	unsigned int len;
b2e5852793b6eb Mina Almasry            2023-12-20  366  	unsigned int offset;
b2e5852793b6eb Mina Almasry            2023-12-20  367  } skb_frag_t;
^1da177e4c3f41 Linus Torvalds          2005-04-16  368  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


