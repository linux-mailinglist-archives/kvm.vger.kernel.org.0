Return-Path: <kvm+bounces-69338-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2HdeLkf1eWnT1AEAu9opvQ
	(envelope-from <kvm+bounces-69338-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:38:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 28177A09BC
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 12:38:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 40E65310B0F2
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 11:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A8D34DB57;
	Wed, 28 Jan 2026 11:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KLLW71Cr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 387B834D4D8;
	Wed, 28 Jan 2026 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769599758; cv=fail; b=BTZ3L2Cngq4tTH4sQwg6dDE2F5tKKJMlV/A/HgfkMq0FpAOMTg85Nj83nCfEQEp3MYLcRqjtqWoVgPsr/rDwf/mS5o05OlGKIObXVk/pxMvYFcdoeqLtv9KLU5wzaqb712DEOm1zm3qT8rjp5uS6LGRis8ZjLqnD34Z0X8V9y4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769599758; c=relaxed/simple;
	bh=rLm2uMeUNwEGLfOppXUYaoxm36jLrsF7jk7JC/549DA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l0VeCf/yQHI7PJcwFk+RYwEDbImurKtxLlQdevK8j4P3BfQdseRTinMOuVh2UmNGlPpg83B/FE+JI1kW04PDAUMAWf2H6Tn4il+Pz4LuVnOKrB/+ygR4JedRj8nzhSW/RtLEaQaenOocWnyKUFh9n0YH1f5qwNzu66NPe9iegkY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KLLW71Cr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769599757; x=1801135757;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rLm2uMeUNwEGLfOppXUYaoxm36jLrsF7jk7JC/549DA=;
  b=KLLW71Crad+iuJaaoM3b4KdnP0SEBYJ3vaB8BqRs2JvnknS0G6H0ybsb
   +Ck4H85DnWUj5gzkLwyKu3jtqnyoFAcwZptbly9Ny5og1WQejC73+CLbI
   7iJCrjQOi5lsMXGpRLroj6wqDgk4NDUz+MfFcScvrBUQ9dNusDHPuCxJC
   0P27ocjMO1hHbVNlJoZ03Lcez52JSTykosqp4G+a/bYGbs0530KUDiv/J
   825sdeEzUy/36S+rOiZwAUT5EMTYnoLSV0NwednyuvA1KQQLhm77/hn9N
   flGbRD2Z58oC0ZiNkLrb29SrbA9RqxYFeVTtoMfSoP3cHBtWQ0vz91+Fc
   g==;
X-CSE-ConnectionGUID: knVYWBXaRVe/8IkveJ0mPQ==
X-CSE-MsgGUID: CMAZ4WOdQhuLAA3JlEgA+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="70782245"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="70782245"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 03:29:16 -0800
X-CSE-ConnectionGUID: mbrCxI+uQE2yeimPn+pDUw==
X-CSE-MsgGUID: 3hwRzE0WR9adyvrgEikmDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="212797573"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 03:29:15 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 03:29:14 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 03:29:14 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.66)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 03:29:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vh2ps9hXwD4+v1g5B0XPp+GNR8tY0hrba8SWdQF+zf5f2MK4y6gPIGMSu8pXh9t2PrJc3ZdbQKWIgSFVgwrZENFln6/f5j5SolZ8p7BviUX41bsXejN8nPPvH0FoTlFpzdX5yND5r/l/asUvUbxFYKsuWbMOsnknUTqznv9f8xYUhbF9WD4vS683rCiKaHfr4nb+IYvgbsEJcAHx9H9ElmTOvK/lKFE4yfLX8LTlw8+/bHOtrkCJzVnzWn6aeUfXPQl9t3vQQhw4O3qaT0Px4eBDEYUl9tn64F01/tXNql/tRino/U1iMTg1tTlkV2yow3AcmqVYOYTIRiARudzbPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29lMt27SRRJMbYH/PH/kDgvme151sXQU+nPFT8y6GBU=;
 b=s9MnRKqI/srMkIS1XuIzQUp3oAEOqHRnld1xDpkuRvuu/CGmV6M1goDCrloCZC1U07SP1TgxbiYC9CkFmy0tmK0uTjJbZTVu+SQkCO9HVhut92m3GlwswEtEh7d3c8pCu1ChQMMAOgq7kvEymHdDiWVGJbP2A3HNAWrGOXt4iFSMdz9Cr2mGW+/+YzOfFToVrNroGJASyUY4xpxtuOIPo+/vhUFThZUz59aP9FdeXnWsTQpXW+rb8PLvWqMgX4aXj8cIdeBnu3IvwHP8xqBjKi0QbHJYq6yl7h2lGI0t4OJcYfLw5ZwvfC+puTCLGijrmFrs9XK5OR0VGMLJw/zG6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB7651.namprd11.prod.outlook.com (2603:10b6:8:149::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 11:29:10 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 11:29:10 +0000
Date: Wed, 28 Jan 2026 19:28:57 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Verma, Vishal L"
	<vishal.l.verma@intel.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "paulmck@kernel.org"
	<paulmck@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Message-ID: <aXny+UkkEzU425k6@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
 <20260123145645.90444-14-chao.gao@intel.com>
 <fc3e72ec4443afd79ccade31e9e0036e645e567b.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fc3e72ec4443afd79ccade31e9e0036e645e567b.camel@intel.com>
X-ClientProxiedBy: TP0P295CA0032.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB7651:EE_
X-MS-Office365-Filtering-Correlation-Id: 72386c2a-9f6c-4c86-750b-08de5e6074d9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?cyIRUEkutuPxgnvOcJ5+Oo9iA94NIONGUMtElycowI0MOoqOAr/rhZIryBq7?=
 =?us-ascii?Q?wxvlZc8oB7bJvzuaC0j1Jk9W5MvBDbXDyMkWFyeYe4xmK3wy4KAQA012UoQ8?=
 =?us-ascii?Q?FFkFUZ3mFWFwmxqjtZr06d2/D+rafpyQAdSeqMnwr0MQSMZ+iFP+Di+sGXkh?=
 =?us-ascii?Q?DBE9CmpIal6vqvg1/zzsWyC6zDRp4ddouzqSX2hcRA3zvrsWDjXUcqiIeytZ?=
 =?us-ascii?Q?5PhI8xF5hBiKR3KBZzK2vi10CmfB7VtJEAhUjhm+iSIMYwmOyRppKn6x6sQl?=
 =?us-ascii?Q?UKu5aMIMJJUYZ0WJSChDMskfVh/tXJC6LBiiyqcq+ZuDR/2WMhHy62ytRj9m?=
 =?us-ascii?Q?7czq4Rj7+p6lb5TMSLC0mKq7DQjDWiS9vJIj8m3Tzg2efElLIAjoUMY5LOiw?=
 =?us-ascii?Q?QgRW32L5NP+f7ZzvtFY4hRbCaB9+HfBGYY6Rqtls5eT4+1BXLiiXAKopSf1d?=
 =?us-ascii?Q?W6b2G7/6howjCzDbLKMTXMiOcm4m9blBfdgrJ1/GEW19dO2rl9XpMKA5uUuq?=
 =?us-ascii?Q?+h4UJHa45bdh0IZFLj4HGENo/VAZcxxIJxy56s+ILu1UBBF7SM0/od6l4De4?=
 =?us-ascii?Q?o0762QrmTRmLDFd/4zHRsHbUYNOh7RlkK5yr1oB5OqC3d5/1eVsVeYwgrXaA?=
 =?us-ascii?Q?Zpk6tlIB5ZgUrn6deuntH0nJuhw0IDU5TjQ7wAsHpJPJGeizjjKG6BWEG4Ud?=
 =?us-ascii?Q?/yFgjXPfGhwLCfrtOB45i/8jbtBBYQ1oofUDeAdoQf/Ca57q3CHsmvIsYgzg?=
 =?us-ascii?Q?FOVVQZlZ3Q7m4rgPw0zw4Xn5l3fE8mbskE89UJRv4Om4YFjfIWklTGCItXZd?=
 =?us-ascii?Q?pJk2kAtPGXwo9aDW7enqQM7Ws7MslmqEGZQz7DWYCsmc7Dok9HfS/fI1j37Y?=
 =?us-ascii?Q?ldHoAiehJ5B7WfpDvKg+173DkilADzVdjZ/syjMyjEiybS/u/6/mdA5jtMvF?=
 =?us-ascii?Q?anO+AOmR8LXvoxeRXE4p6cHd7ITIMFFdZBXCrotn3HV8xWHxV186D7IZy52x?=
 =?us-ascii?Q?VBMqNbVK8edwI0jactlWxDjGbsTEi8gs5SJplCLO18h/WwOC9TpkApayn0G5?=
 =?us-ascii?Q?KuI3z/xkaU4lPtpx5gxkw6zNuJv2DtTcVteSDRu9L5NdH5lzz6nc8z8QvzvN?=
 =?us-ascii?Q?bFcsalLmMTb4SPycnRN7CKMCdaH1txV6h2+idgd0rPqfkMWCROI86e7Xv64M?=
 =?us-ascii?Q?EWmEHEeUBpbcUudmG7DoDxvDDYW5mmGblq0Yo418leElrfAMF/RPjsB5Qmzw?=
 =?us-ascii?Q?qhVXCQmwRuC85GmMf3kB1GcpecOFMRO9M8lXOms3RoLAxbahdhe7Cw8oRqM0?=
 =?us-ascii?Q?ZgQhv4Mov1uCZUia5dzMOL4LMatOVXBp99JXgjU4UnO0DUhWiKsZ8In8Rs+P?=
 =?us-ascii?Q?EAHZr2DN3lQNvAVkx7jBk8MGgSaIA1Op/LL5VjnKIxdEENPjfl3i3aUtCONu?=
 =?us-ascii?Q?N1hRwBOi8v4zkw54XNa0UleANHETJrx9sIoFlJ/y6S85nOSTrD7HxDdnLpiV?=
 =?us-ascii?Q?2V83yFRSevmnxqRjngzvyPyMQkuiacG5To7QtnkR+EF7yKmGsAWgx+Mqo6/U?=
 =?us-ascii?Q?9ADrPCxMMHv8Nu4UhGfzogkvwPnW1PC/qW3tNe/F?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xKwclKp0CMPKZhOXz/HRWeA3+DFo6yZaPH35KIBjjOTFu+mmGEwBBj6MulJL?=
 =?us-ascii?Q?P0vhz7xDdxjU3/9TfJVMM/MpHdj6hDRAJXiG4UiqNIUGqAQkV2eJeV4/XTQR?=
 =?us-ascii?Q?crb8cfTceWK7bs7rgbX5BySYzVyw+zSrEL6MeuTY5ppIkK4OpSPz6pBO6fYn?=
 =?us-ascii?Q?9noRDlMSWjc7YAZO3oJ1YWOQC4w1qN+Zqtf1r3/vF/10Nt6u/US6GPz1nvw2?=
 =?us-ascii?Q?xW+kwO3OLIoscEyypASaEWd7qqB9Fw6pKXXdrFM0yGBSsNYrwLxQwVN1q+MD?=
 =?us-ascii?Q?6jiKiH49/TuQr6aPfuRX/HYB7bdSRjm+2GfsRnY6gKwyO6e+z90d5uCy/THC?=
 =?us-ascii?Q?zvRNNur/I/k/v6PNnf46imWBB4elNNyzFJ8OC6AoKFvwwCq6KBFl+omD5CBt?=
 =?us-ascii?Q?rNurBfjvGaCYvm5gafUACrBOLvpMeGnNhbx23WEzDkpbeTBlsUgfZ44l1rgq?=
 =?us-ascii?Q?NacK9Zmkz1nPKXYs0Q922a2OS1dvpvv33UczpHRz2H02KE8vVUX+9w5Ct23S?=
 =?us-ascii?Q?Qm55zjtd8/mmgVqo1OpCj8o4yuEMG0jF0+p7NkDPnG8FJiZQDo1+qbpNSZfd?=
 =?us-ascii?Q?rraFBJNiN+va63opQ399GAjRS6OPiEbINoCjgMj0X4v6qa6vB2rgGJtU11xW?=
 =?us-ascii?Q?A6cMuMUhG7YOIdoGX9NCGVd4B8pcZJSDjY81ND/QEmIXDLjg0bdCyJ420oPi?=
 =?us-ascii?Q?vlvWEuv2TDPGIz0BIy10831+ftvmWZf7XsyMYoi03FixNCvAMdwne7Y/+0oo?=
 =?us-ascii?Q?AGFnHnY8TJkD8Tplh5b4gmJoECF6uD4wdIV8eVAdzHQGpUxhI4lVwUyw6Wyy?=
 =?us-ascii?Q?6vapoXrDP+ONHUXe6wN52YdC1WZq9AgEax3r0lGxQbPYcWhNKrebhsyBu5/r?=
 =?us-ascii?Q?7cFXlwW4pLqffi714jRZXtDi30VF6M7RJSrtfoAl0QXAjVsinhZXbGpx5lMG?=
 =?us-ascii?Q?/wgDPXCXfqet/pA84U3YznVeE78fFnM+kOUz9mJcXBaSINd72y4hS4Pu3diN?=
 =?us-ascii?Q?BFCwevWID/AqWUQIwuq2LXgNj26S6uAVrG6tYikE/h9cTdKE7oiAN3kvYpMF?=
 =?us-ascii?Q?rOIc3trG0KtWKaCcUu5LZHmsgeykQgsfZe1QA6hp/ADja6qjRjHlPO52H5gn?=
 =?us-ascii?Q?CBrwLL/kAt5bmEjyExDwfYLGFPthZuM6mswGGHIYppBX996Ko+hGaz8jH0an?=
 =?us-ascii?Q?ZytEOYhz6G7zBRiEO+vXBdYxIzIwPW+QCcflM55ZzbWqr3pNwQTUflkcbrFh?=
 =?us-ascii?Q?lPnCvvKOdH0/DqbhdxiU+NemDKkVf/zMoy7Vydl7MhDLhHCSlFXy2B9MRNG9?=
 =?us-ascii?Q?Hh1yIMj6XdTAaU/ZQMyArz+Xxzszi+AIZI/u9QwRxbYFLwlyoLUceEANEB3u?=
 =?us-ascii?Q?4rohzai5aWAedESAZbr3ZYWnuX8gaQaibZw5W6dLIPh1nNo/7T11Z17LPFB5?=
 =?us-ascii?Q?KF1BxDhaV0F87pFwO2I34OoAZs5Li5uzjvasGlFpy/52vz4c79hl8uQN07Bw?=
 =?us-ascii?Q?iwocfw1pRuHAIr9rtuQMATZFqr62yXVIexAH08n/6os+iYSRGmg+/3LfeV0f?=
 =?us-ascii?Q?IoS0kXjW+TXuZwgDDXtxh3Mc0Pradnxr6scUUu47G1MNShXwILqFRdHFzAJq?=
 =?us-ascii?Q?xNl5rgv4LAduGhVnSdnq502N88SWyVLV8f4iVM8wUFcT4Ck+Tu4I5ZX3RTgV?=
 =?us-ascii?Q?t35BxVptye/Ywu8OjHm3aH49a4Qlh21DIglwwj7eh6ZXf7GcRUwUYX+gWzDi?=
 =?us-ascii?Q?ljLq8TRI0w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 72386c2a-9f6c-4c86-750b-08de5e6074d9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 11:29:10.5812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x656ax2VER45fupsPzqKpyTLKGOACtQ8ybSm6Tc7ydgwGpLBa/R5EtYue21kRqHNeIR/3Demnlc9JIlLk+F4dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7651
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69338-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 28177A09BC
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 11:21:06AM +0800, Huang, Kai wrote:
>
>> +/*
>> + * Allocate and populate a seamldr_params.
>> + * Note that both @module and @sig should be vmalloc'd memory.
>> + */
>> +static struct seamldr_params *alloc_seamldr_params(const void *module, unsigned int module_size,
>> +						   const void *sig, unsigned int sig_size)
>> +{
>> +	struct seamldr_params *params;
>> +	const u8 *ptr;
>> +	int i;
>> +
>> +	BUILD_BUG_ON(sizeof(struct seamldr_params) != SZ_4K);
>> +	if (module_size > SEAMLDR_MAX_NR_MODULE_4KB_PAGES * SZ_4K)
>> +		return ERR_PTR(-EINVAL);
>> +
>> +	if (!IS_ALIGNED(module_size, SZ_4K) || sig_size != SZ_4K ||
>> +	    !IS_ALIGNED((unsigned long)module, SZ_4K) ||
>> +	    !IS_ALIGNED((unsigned long)sig, SZ_4K))
>> +		return ERR_PTR(-EINVAL);
>> +
>
>Based on the the blob format link below, we have 
>
>struct tdx_blob
>{
>	...
>	_u64 sigstruct[256]; // 2KB sigstruct,intel_tdx_module.so.sigstruct
>	_u64 reserved2[256]; // Reserved space
>	...
>}
>
>So it's clear SIGSTRUCT is just 2KB and the second half 2KB is "reserved
>space".
>
>Why is the "reserved space" treated as part of SIGSTRUCT here? 

Good question. Because the space is reserved for sigstruct expansion.

The __current__ SEAMLDR ABI accepts one 4KB page, but all __existing__
sigstructs are only 2KB. so, tdx_blob currently defines a 2KB sigstruct field
followed by 2KB of reserved space. We anticipate that sigstructs will
eventually exceed 4KB, so we added reserved3[N*512] to accommodate future
growth.

You're right. The current tdx_blob definition doesn't clearly indicate that
reserved2/3 are actually part of the sigstruct.

Does this revised tdx_blob definition make that clearer and better align with
this patch? The idea is to make tdx_blob generic enough to clearly represent:
a 4KB header, followed by 4KB-aligned sigstruct, followed by the TDX Module
binary. Current SEAMLDR ABI details or current sigstruct sizes are irrelevant.

struct tdx_blob
{
        _u16 version;              // Version number
        _u16 checksum;             // Checksum of the entire blob should be zero
        _u32 offset_of_module;     // Offset of the module binary intel_tdx_module.bin in bytes
        _u8  signature[8];         // Must be "TDX-BLOB"
        _u32 length;               // The length in bytes of the entire blob
        _u32 reserved0;            // Reserved space
        _u64 reserved1[509];       // Reserved space
        _u64 sigstruct[512 + N*512]; // sigstruct, 4KB aligned

	^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        _u8  module[];             // intel_tdx_module.bin, 4KB aligned, to the end of the file
}


>
>> +
>> +/*
>> + * Intel TDX Module blob. Its format is defined at:
>> + * https://github.com/intel/tdx-module-binaries/blob/main/blob_structure.txt
>> + */
>> +struct tdx_blob {
>> +	u16	version;
>> +	u16	checksum;
>> +	u32	offset_of_module;
>> +	u8	signature[8];
>> +	u32	len;
>> +	u32	resv1;
>> +	u64	resv2[509];
>
>Nit:  Perhaps s/resv/rsvd ?
>

Sure. Will do.

>"#grep rsvd arch/x86 -Rn" gave me a bunch of results but "#grep resv" gave
>me much less (and part of the results were 'resvd' and 'resv_xx' instead of
>plain 'resv').
>  
>> +	u8	data[];
>> +} __packed;
>
>For this structure, I need to click the link and open it in a browser to
>understand where is the sigstruct and module, and ...
>
>> +static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
>> +{
>> +	const struct tdx_blob *blob = (const void *)data;
>> +	int module_size, sig_size;
>> +	const void *sig, *module;
>> +
>> +	if (blob->version != 0x100) {
>> +		pr_err("unsupported blob version: %x\n", blob->version);
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	if (blob->resv1 || memchr_inv(blob->resv2, 0, sizeof(blob->resv2))) {
>> +		pr_err("non-zero reserved fields\n");
>> +		return ERR_PTR(-EINVAL);
>> +	}
>> +
>> +	/* Split the given blob into a sigstruct and a module */
>> +	sig		= blob->data;
>> +	sig_size	= blob->offset_of_module - sizeof(struct tdx_blob);
>> +	module		= data + blob->offset_of_module;
>> +	module_size	= size - blob->offset_of_module;
>> +
>
>... to see whether this code makes sense.
>
>I understand the
>
>	...
>	u64	rsvd[N*512];
>	u8	module[];
>
>is painful to be declared explicitly in 'struct tdx_blob' because IIUC we
>cannot put two flexible array members at the end of the structure.

Yes.

>
>But I think if we add 'sigstruct' to the 'struct tdx_blob', e.g.,
>
>struct tdx_blob {
>	u16	version;
>	...
>	u64	rsvd2[509];
>	u64	sigstruct[256];
>	u64	rsvd3[256];
>	u64	data;
>} __packed;
>
>.. we can just use
>
>	sig		= blob->sigstruct;
>	sig_size	= 2K (or 4K I don't quite follow);
>
>which is clearer to read IMHO?

The problem is hard-coding the sigstruct size to 2KB/4KB. This will soon no
longer hold.

But
	sig		= blob->data;
	sig_size	= blob->offset_of_module - sizeof(struct tdx_blob);

doesn't make that assumption, making it more future-proof.

>
>> +	return alloc_seamldr_params(module, module_size, sig, sig_size);
>> +}
>> +
>
>
>

