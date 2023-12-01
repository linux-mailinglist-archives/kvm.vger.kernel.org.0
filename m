Return-Path: <kvm+bounces-3062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9564480039E
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 07:15:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7C0C1C20C00
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 06:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35957C144;
	Fri,  1 Dec 2023 06:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X4FpZXAl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8271711;
	Thu, 30 Nov 2023 22:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701411330; x=1732947330;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=JYmh6ZLq3tVBVAk7NaC66Eo12aC9Crwd34amlFtXl/w=;
  b=X4FpZXAlYjagXTytg0nh3WJ7g2DJh2Y9w+Eza+o+OxzPL1gpq+8s8QXg
   2BrLl+3/xO27IntgfLA3hdzTal4RttJWZyNAzMiw33oqLt6LRWv/DivWb
   UALElIy2ApwbqZzPFr0rTHQE4iwSiTO2IHg/EPDKbTJ8jefyt5FrWXqdI
   jRZMoHJ0zviM85iDuUOgLmx79AiKnNb8+RMeljEBF0qGvXknBwWAbVHBv
   bwtvG6VWkUO53q1/A1diqs463uvuAxiRDMHw3rtii89a7xnVgVAj4V4pM
   4i8JquIFL9R1biT8Se39zeVsPHbsBHRCjbfRH0nLtShkZKumbVRb+pI1u
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="455230"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="455230"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 22:15:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10910"; a="1016918818"
X-IronPort-AV: E=Sophos;i="6.04,241,1695711600"; 
   d="scan'208";a="1016918818"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Nov 2023 22:15:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 30 Nov 2023 22:15:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 30 Nov 2023 22:15:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 30 Nov 2023 22:15:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGbSUW6Ct7qPscVtmCCqA2I5TjJV5YkLV3IJqsOK4dyA9rqO89lZxfHefu2UmIKzA+1avyP0ZrRvzA2RESClWOTUbEsOrZ+06IcTVbHNiwupvZiRtJfMnmWsHFJ2htSIeXHYp7s2/jxnU4kY7d5bRm4nanSCr7WwT12z57MD2ZFZ1MWoNjGq2QSgyS1aAWSu9PB6bQQnb6nnE4XSKywoTG7aIxJCCdllyQIODoH5QgLVceAKEZ+elShIJglPhjc3CrbFkDPsCTCsO4I42u2N5xqY+Mifv2xUQ3sjbyXxMGlWqIxdvpxS/LccbNUfsQP2Wj0Ctcv3uRTm8C3iC8B/fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eECwkKkiirMhyd9eKUm0yTXcbsl6PpZ7pNh82pbgiyk=;
 b=KTocmkaqXmS5bL3LZbTZbZkJUX087X2A2z+mU9gGjJPzQF8knsDI0yRmBSe3PuUYnVfe0tWBTtETBF8oVG8AM0FbvO4nQvyHmlucrBG2VEsgry3COTPAIDd2JQVLtd1s0OiyK8N0hrMtyhRTHYUXV7uUqlTdIrLHmQUJ/mNIn51KbJPINbwp9Fj/ySwPXTNe4qlMX39cmIx6rk9QpC9PKVCJC9KdrCP21HkWK7uziMLGPqjeB11HsVH1m500JtXDxEwPcD31z37jGB3Nf6zs1cA9Vf2rt6zLrhIsqSIrs/53EGMwJsiNykcg9UG1eoKGYOKf6xUuDpsqD4PymT2MzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6392.namprd11.prod.outlook.com (2603:10b6:930:37::15)
 by IA0PR11MB7789.namprd11.prod.outlook.com (2603:10b6:208:400::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 06:15:26 +0000
Received: from CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86]) by CY5PR11MB6392.namprd11.prod.outlook.com
 ([fe80::15d3:7425:a09e:1c86%4]) with mapi id 15.20.7025.022; Fri, 1 Dec 2023
 06:15:26 +0000
Date: Fri, 1 Dec 2023 14:10:51 +0800
From: Yujie Liu <yujie.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Vitaly Kuznetsov <vkuznets@redhat.com>, kernel test robot <lkp@intel.com>,
	<oe-kbuild-all@lists.linux.dev>, <linux-kernel@vger.kernel.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, <kvm@vger.kernel.org>
Subject: Re: arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates
 bits from constant value (1b009b becomes 9b)
Message-ID: <ZWl466DIxhF7uRnP@yujie-X299>
References: <202311302231.sinLrAig-lkp@intel.com>
 <87v89jmc3q.fsf@redhat.com>
 <ZWjLN3As3vz5lXcK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZWjLN3As3vz5lXcK@google.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To CY5PR11MB6392.namprd11.prod.outlook.com
 (2603:10b6:930:37::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6392:EE_|IA0PR11MB7789:EE_
X-MS-Office365-Filtering-Correlation-Id: cd01aab8-2687-458c-08b3-08dbf234e8cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o3aAp7MrCCN7be+p8UKh6B6EckBLiWJZAUgrlMK1o7GQ9brAc40ZwMk04fXwkPUxuv0XvorlUbkhwcKrirq9LTsjiA5w04RmuW6NRthlzqZy7y0sTOritjGo4MQ/XtzokqtKv5gzSgZ1DrP/pbanMma60yyhGFvcH851oupG/+CWgd8SdgWKOgmZ0fJg64QPmMtDwep4hVpbxgYG4a7BH6QAbuwey/Hl25B6Tf5QDWWF2SfyXm+nyHkbrzWtQsejWdzwAe9bH+uts9aMxTnjXmeiEtY02U7dADP1EToShPGq15rIL2wLIiziaBUbCn8QU/HhsheT8iVujxxuUvsB8xklSPi2Na/pTC6lrPtFeTN7d9z81YxDuUiGkbKenwLq4Dv9E+BUpSdWz5uLiijfU3lj74elf0NYAAqsZ5js1OH6LI+KaKHoM9WR40l4DWBctYPmJh8/Jf5KgtMVdiQ/Db4ZXXaxIUFsnLxf1tTTZ6UxH88gTpWb9x1kGCcvCv05bSSfuDOhn5zPPAjqLmu5QzFNnInUUpe2/n5h+3tKGIp7E+g8UJ8z5b1EpOAGLxA60+5FCdFxLIXn4PrKWv68a7TCZLIWd90ds7x4YZg/PPHHKu4/Vc6Rdlf1YqIv8UaLRNNJiX3hfUPboP9BKgVAQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(396003)(376002)(366004)(39860400002)(136003)(230273577357003)(230922051799003)(230173577357003)(64100799003)(1800799012)(451199024)(186009)(4326008)(44832011)(2906002)(8676002)(8936002)(41300700001)(26005)(316002)(6666004)(66946007)(66556008)(6916009)(54906003)(66476007)(5660300002)(6512007)(9686003)(6506007)(83380400001)(6486002)(86362001)(82960400001)(966005)(38100700002)(33716001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AR2JJ1sgETxR0GPv5qAxxXXug/FmSQHNYCscQtKIJuH0ax1LIRYb1bA5AMFH?=
 =?us-ascii?Q?e9bCCTILfSyvvzVR6g+ev09bxz9y+c5GL+UE4WCZtR10SoL7fdXRPwEKmhH9?=
 =?us-ascii?Q?mlC2GvJn/CN0LksjC9LcwD0Hvsd218E7J0ZOyjdi26ZvX3bG0ede1stsokVN?=
 =?us-ascii?Q?HsHmwFHL0nLVm0vVft86T7MTFNZPggM+w7f0CLW2liSRATAkv1wK0EsLv1v1?=
 =?us-ascii?Q?YHhWayMx/Nqn9vx8rOaa0tIXVCMuRYqx5u6UzspDyyKIv98EksFbqstZ1+YM?=
 =?us-ascii?Q?hxyrWhn/xpZ0PyI2SssBErxjXJixnEalzzzD81p+sCDeaSjYknLDRq5xSzc4?=
 =?us-ascii?Q?pre7wVNKm4ekATggHHsdU5m/DUTYA+o7/njuW/ZMPZa1jRJPV6HcrAekP7Wy?=
 =?us-ascii?Q?qXHSiuFiLfBNz14frim45aR30nCC8Er332NH5CVVe+fF3C3d3YCJiM1L07uS?=
 =?us-ascii?Q?xUNmkYbOjB03p0ZSwzaD5dcUGpy7WUcyLpj5sSC32obepdPLsBodf+2ELzps?=
 =?us-ascii?Q?HWKfnOtmo7B8cyhB0GN9BRN23oxvbLvmAIewivVwsLuNAXLhMY/y2alRLonm?=
 =?us-ascii?Q?kpkXzQ0VkuxP90NcohWfelD9lLgultRYM1CZoIZcNKNnhDkeKXhk14QSGL1c?=
 =?us-ascii?Q?yz3TSU/K5ymS/AQpScoC0PPgIWfaxigHR3XRTr4Krjmpz+/7AA11kCl+HeJh?=
 =?us-ascii?Q?rHBxaiLE2sPP9nSngwNTt2PiCjkllDubh+mxNVASQD5Ox9Lgdcs410M+JMPi?=
 =?us-ascii?Q?VSf/wvovE+nOBvTlF3oWi06g6/329qnUrRb9IRjP+KaEjRzJNzbFN/DGM4cl?=
 =?us-ascii?Q?wasdCxnQZO9hmllJ2PcVA+fcaQfcWRDHGJpWh0Zszv9hZxPV5fkoAV6jVSFS?=
 =?us-ascii?Q?jMr84lMGgShkEnKPso55+gAiANUvY6jQhJOFxXciA55TtqJb3CrIKFttAi3J?=
 =?us-ascii?Q?PyqNHHhRXg7oiTidx+Aqx+1zTL1thk0b3IDQx5q6ojQ1yolB377tMYs+Vw6H?=
 =?us-ascii?Q?ekovrLUZcfj0Fhvm21RePp1EV2VV/ProSjW1+YGd3r+luDL11I+WzYm3+fHX?=
 =?us-ascii?Q?RmiLeahgKWCTlnqkGysvMdde0t6aT3MOFnrCcl3lFBckJrYDSTqIsf4DR9TL?=
 =?us-ascii?Q?IC4plfGD6ss2P/Jc6K+pPgn7bVMq5NahSBReSi5gmrK5zfDjUGWJ+fECheoq?=
 =?us-ascii?Q?B9LW3HpJmX/fziP9FlR2MQNSuFnbzaAO0Kn+U0bt1PXqJcTu4VFQduavj7iY?=
 =?us-ascii?Q?/duEU+v4GmY1D7P8P/zRcK9fhb9vn9indqLKityDzCzu/S6GzopgaUh/rUkX?=
 =?us-ascii?Q?c3EfMrJNYwJc0Sf2NiBDm9zQOM5NyvJu4py8aWn3YUGhQthxKMHlBYNXRElV?=
 =?us-ascii?Q?YawpF37H7qOoRlDk2z+KOWp6S5nF2gcmvpqE0giXqHTXyrvdmaq5XIiY+Uy5?=
 =?us-ascii?Q?p77+MNnJUuDIqtKqYuluWywAaMwnyvCKqFdmcNyTPpfGJjy5o3C7x+eW91x0?=
 =?us-ascii?Q?hj0oW6VLG6ry41SvazRTieOzoB7bj6PpuNV6IX4SKRHacnbW7VtmV9/WFK7M?=
 =?us-ascii?Q?RRuaOcDzmfVxgFu900ncx5TH9DO3yKuxrAsYyJk3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cd01aab8-2687-458c-08b3-08dbf234e8cf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 06:15:26.2350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1JbGH5fIgaVDBw5VSZrYJQC1a3bylSVOr57Lzv7TX/e9nF2O7MFv9bNnACIQw8rKH0qmFdix4dK+mi+MRYetAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7789
X-OriginatorOrg: intel.com

On Thu, Nov 30, 2023 at 09:49:43AM -0800, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Vitaly Kuznetsov wrote:
> > kernel test robot <lkp@intel.com> writes:
> > 
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > > head:   3b47bc037bd44f142ac09848e8d3ecccc726be99
> > > commit: a789aeba419647c44d7e7320de20fea037c211d0 KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
> > > date:   1 year ago
> > > config: x86_64-randconfig-123-20231130 (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/config)
> > > compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
> > > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/reproduce)
> > >
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <lkp@intel.com>
> > > | Closes: https://lore.kernel.org/oe-kbuild-all/202311302231.sinLrAig-lkp@intel.com/
> > >
> > > sparse warnings: (new ones prefixed by >>)
> > >    arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
> > 
> > This is what ROL16() macro does but the thing is: we actually want to
> > truncate bits by doing an explicit (u16) cast. We can probably replace
> > this with '& 0xffff':
> > 
> > #define ROL16(val, n) ((((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))) & 0xffff)
> > 
> > but honestly I don't see much point...
> 
> Yeah, just ignore 'em, we get the exact same sparse complaints in vmcs12.c and
> have had great success ignoring those too :-)

Thanks for the information. We've disabled this warning in the bot to
avoid sending reports against other files with similar code.

Best Regards,
Yujie

