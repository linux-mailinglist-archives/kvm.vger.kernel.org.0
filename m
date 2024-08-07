Return-Path: <kvm+bounces-23578-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF16694B27B
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 23:56:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76F5828412F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 21:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0461155301;
	Wed,  7 Aug 2024 21:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BhwKAK+s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D4C77F1B;
	Wed,  7 Aug 2024 21:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723067790; cv=fail; b=BnRuvd0m/Kk7tZhsfof8H8DLBc986oBlESHv/kRzR/9qKLW/B3y3yo1z4W/kYW9LqymyzzuTtZTgmfjG4SBPAG25MU+yt3W7BAarNTntaOWgPt6de+pspWholaBYfIVPE/iiW+we6O2CvCkBWVCY/7F9Dup4upFIL6ngntwCehU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723067790; c=relaxed/simple;
	bh=y33dTymS0Q5iIQyHvq6x+ytUoKYtLL19ced4MwShHiA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=efWg4hff1qw5G0ViisHJmUovmGGq+1BlSF23NLpmVMnAck8nWXciXP+JYWIerw2vXN8KCVmUUQHijaT48UrBYy/eF70hrSVEmwjOcwRc6i1AQLHhg6d+NqtH2c+zMuiKat527wfimRjepQmOGBuCw91WSRscK6MUjyzBhS7XbtQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BhwKAK+s; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723067787; x=1754603787;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=y33dTymS0Q5iIQyHvq6x+ytUoKYtLL19ced4MwShHiA=;
  b=BhwKAK+sRXXXFAjmPyXRaVa6gP7Y/FBq5Yl5DxMbghtTIaUES1k3yslM
   leUe8DwKQfx3B1jB4d3zxwNAVMyxdw8KQSQksGjOG8HRZRYKytLXHL1Pm
   mTvJPub22a6stv9hjL9BjKqeIsRuTrF+UGDtaw/eKyOrS5LK9xJZxhnPf
   OQ6HmuTM9dxJApb/b7+VbCS7/0OoFZCn07scZ7/EpD9F3PLP8hkYdABaG
   h36ViglErT5N2o9IttNmsxo0IDhioe+nQQBv2hnXWjPvmepBr8CcFrcrk
   voz2JRTtuuJQPgHgv0x45xGDDKaUMrrL9p09hSXIdTolDW2Er7RuTBjSr
   w==;
X-CSE-ConnectionGUID: V1JzGrMdTQursmzIa9Zobg==
X-CSE-MsgGUID: oHwMSY8GRwSlxqLH21phyA==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="38624428"
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="38624428"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 14:56:26 -0700
X-CSE-ConnectionGUID: 1ibcizePSBistViDnYxVcg==
X-CSE-MsgGUID: SGMyFzrzTROrLRvYqcIMjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="56958429"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Aug 2024 14:56:25 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 7 Aug 2024 14:56:25 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 7 Aug 2024 14:56:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 7 Aug 2024 14:56:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cM1nNGL8njtPGClHs/uwxF8Q+G0dXzS/fHzvyBdiUmSSW+HKYHSxikb0Bab5oAECR8ASCJeWtZo2oC0x8XG+4BGwfOBBKsJ26He5edmxRAit8o5z+VyeksxEshSOEnmEtfGAPmi9y75h3eKezZDmHu1EJiN4BKoTmIyJvM86bDu4Wh5XSbrpxONtRxoKe7+hISwhfM0kufGbat2bCiSm63uswCasx24gp7Y4XG+QKCY6w0PNt9zU3dF5LbEHYp/BWNxAjexvuNRNiRGfjvkIvVMDPN/4+yafPDZO38exR2bQg7+sC4xtSr0H9iF7sV06JJ++MSKeo2S+WvZ5JSmYVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLwuqA9BV5bnW6WRO1rKnrnlZVTkeKKZLnDiosEOpSs=;
 b=vp90HIK0NbldYshdT0TkbxJNH6rUennc/UBGDYFL8KO+lfe8mefVGQJA2YNuWrxZAEqdb+R1EXdNfAdt5sJBW+veoLZJX/Q7qLcym1EiFihL5qdNDM3oUUfAB6YgKnLYqYiVPUTuj+1ob3hrN3Ez/DUpi9eFKD7uuXnoaoidPZF4NCBZdyO58tE5BJE6uDLhKY2tqaKVJ7wNEyatCkLw88Y1ZhgaitRlQNM9haRthgOZ+39nNINSVvw30M8b95t2qePoOvvlp7GmCRpk83SRweyyFmoA9VZef7YRxat3viiOiE5ygVw7yjxdH9H/+cqmJeiIlOl+KJu4Hr1LRDxdbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MN6PR11MB8243.namprd11.prod.outlook.com (2603:10b6:208:46e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Wed, 7 Aug
 2024 21:56:21 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Wed, 7 Aug 2024
 21:56:21 +0000
Date: Wed, 7 Aug 2024 14:56:18 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v2 08/10] x86/virt/tdx: Print TDX module basic information
Message-ID: <66b3ed82a47c9_4fc72943f@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <1e71406eec47ae7f6a47f8be3beab18c766ff5a7.1721186590.git.kai.huang@intel.com>
 <66b1a44236bf8_4fc72945a@dwillia2-xfh.jf.intel.com.notmuch>
 <ccf6974cb0c0b30cd019abf195276c2e1dff49a2.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ccf6974cb0c0b30cd019abf195276c2e1dff49a2.camel@intel.com>
X-ClientProxiedBy: MW4PR04CA0266.namprd04.prod.outlook.com
 (2603:10b6:303:88::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MN6PR11MB8243:EE_
X-MS-Office365-Filtering-Correlation-Id: cbecf993-8d23-41a6-026a-08dcb72bc621
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7+KFM/XioO7XeVzYFSKws8kgtcorVHcgYGnagef+68BxUw7rYcabz15c/tgP?=
 =?us-ascii?Q?kEqZyF25YNQFmIgR6z9niSpepB4otgqONcK6BtwoZ5J2Z+Lik3s4ncf61iRl?=
 =?us-ascii?Q?qjH5gi2EgccPicK72yQZZPqBUX5NaLECJTOvJ8x79XxOW7tQjPTFv1k7ScHV?=
 =?us-ascii?Q?EDRzxgAqAdKl91vyxCODNDC7Mk9vDcFH0qCrr7mpTwlJTEbuEVLVdER/1/Fb?=
 =?us-ascii?Q?MflSaPu6bOO9go5eZUdhk1L+L2uBPfrSWXq2ALQ6VJS1xKblv0mL3ipH+JFL?=
 =?us-ascii?Q?R0rC6tX69VzzETeUH5nZC77EMXhC9iqJYMwMXHSB55+eckKxd0DMiCuTAU0f?=
 =?us-ascii?Q?L+Vn00q9fW/czP0080hlSJ0XvNH9LA5FIykYPoMh5kKKmV4+eBmb5mGX+a7H?=
 =?us-ascii?Q?Mldh2cVOAQgA8KeMk2WH3qyABKfHtgyxWnL16tfF8wJEOd0xeyn4zsiT/BqL?=
 =?us-ascii?Q?EgHU77C4t0w30YrEQaFb62xf7sVjYH65LO2OTsuA2oGeFUZSn3lwkQQonDfu?=
 =?us-ascii?Q?33eZMTC8NBaQwX2JlfcuTGg2mlzwzYF66WJcz4JzVqsJSnq634oVrh7Ysx/N?=
 =?us-ascii?Q?+vuIkcWmbMijoeJk1poMrFVbPgVeInIlYfABIfciiPSibbil3ZYazO29fxkM?=
 =?us-ascii?Q?+vlDoAoG1KTs9dzSNp6IBoe66RKbLbg3w44kyMvBLUccJh46wjZGM29VRTm4?=
 =?us-ascii?Q?z3HWs55KSGp1sep5zrJswSuEisrYGuqLhaXtPUoQn4x4t0ApUfXCpORVXHB8?=
 =?us-ascii?Q?Ux+RC2bF6EPm/m8o4WtGOLYx7eI2+C2wQXg0dNseLX99iw+DSO5iG7n9nBJY?=
 =?us-ascii?Q?gTtV+JdSVsoyRCy99BiLK65eIiVvilEgEywK+9dP/vlvtRhC1ZcUCsHorgoo?=
 =?us-ascii?Q?0SLbZ6RsqfhHaBEHfCihzuTKQaay5R49RbxtaWLi4V+kJv5oszgHLZ1jSZYx?=
 =?us-ascii?Q?07W5jaKkyNAhq0e2D0BgmvYY85yhxgJTJ5OwSclqceepwuHK4IXZn+MTEgLN?=
 =?us-ascii?Q?4Yl5ESCYuQdENAgtlyDXffFWLdh/Ra7Pyii/0NciJ7b5xF4toqRqc9IqK3mz?=
 =?us-ascii?Q?pO6jrphmS8A8jkWCBDm8r+2KucDkzEFRqvRtyXYe/atvj+bp/Etp1n/QGvfw?=
 =?us-ascii?Q?iY9GGh2GpIftzCmzeVkUStNSMbC82U7K6VMd7z7lAX8zFaR+GbMWs6y/DwSg?=
 =?us-ascii?Q?YdZYxWKl3M9Qli0LURUZmscumkmHWHK1pUvZQ1C1+nW3rIQ5avBw+U0uL/kK?=
 =?us-ascii?Q?l1clhCww0sJF+/zGe/n9jgRa59PkkCx6/eugUxkFAIpYFNSdFcBuMH03f1J/?=
 =?us-ascii?Q?hZ7iJgudXcq4PwYXeBuYH0IyZpj6+ZVPuufLVwwbu/3oxUQSPHRH7TYGRmid?=
 =?us-ascii?Q?OTrfLxI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r5LIHHSwhbwCK75u3ZMLMh2NCcY4A0BA7v5yDZ18kFykQBhhFP7d2UzJMDRo?=
 =?us-ascii?Q?NJvlvEeQCMo0BW55zzrkTEGaESIMrURa7pCYoqpBH/Z1ga4ZRRMklCRVsEOv?=
 =?us-ascii?Q?JHMXiIjadmt8RSZQFM6xlfoYJY9qSWa+rchtel7Sii2rR1dN1q/M0L9ChyZn?=
 =?us-ascii?Q?RXLW6s2ohq/GQUW3OW2b57NyWfj6ENFDTf3FzkejxnnVwqateIcAfBc5nbKZ?=
 =?us-ascii?Q?PfOvmpmrpwfuwvqsCGjKdtv17XIQ2lp5k/aDWmpLEbEbYjg2A20DLUuD4SrU?=
 =?us-ascii?Q?aMGerjuIbK4/4NVHyxLyE1J50MhI67aEpzjLxekEkebWIChyqOqgODnvy7D7?=
 =?us-ascii?Q?Ctj+x9SKyzp7ll49gMp3OqIeuy97UN85a/ww8FGXJ2WP+B1TfXl9PO+pk9cA?=
 =?us-ascii?Q?kIdjYWby58tdvM8k/oFgDaYtu4BtjygigtFfru00OMRkxmWcpyDakfCTd1oM?=
 =?us-ascii?Q?XElfq3vqDJ45dPXThksyTiKhEN5v5biFlh4XS0nzyR6mYgy9IfoKpQETnNkQ?=
 =?us-ascii?Q?GCpN0vtwpK1/SG+/1b2JqvqPDzAR+MaDDT3vMqHLwKIN03tKmUFdKYG2X1NO?=
 =?us-ascii?Q?ROxN5SxbDjv/rv9G8sujtRb+PcLI1Hp9WXUyERZs6x/iOR2Aze29RSj0RF/8?=
 =?us-ascii?Q?n8f7368TFUMCdm9ieB/I+Z1P4r6Jy8WdpvRpod+uTTYGcrdipSWY8VUf9aIn?=
 =?us-ascii?Q?RG07/JOElDKEt2KNQpj7auBaz06/7+2hAqOHdqSVgIY0Tl77MV9mb2jmoUC0?=
 =?us-ascii?Q?7i0vDU+TBsQ5SfqXPotrKfyPlSwn7uVBaT972FFiZtNQ7AmzG44m2JXFBZyB?=
 =?us-ascii?Q?mKIGeJZQC91a1MiTMkjTh3dUD0Ft2ECR4yHo0o5+ciETvySQqh8ytJf0X8Yb?=
 =?us-ascii?Q?3fzyIUSoVawl4KVKE1weCwaddSfWnbFV00/gcTCyFRRU605aJuXf+gzKrvv9?=
 =?us-ascii?Q?ayzY+9p0loPicR86goDQZyygzZbae6ZNwdsOPH0l4CvNSm9jYzQPrg0PS2i2?=
 =?us-ascii?Q?zIjcOavAL1W6AFJnviLz8mpUdITcGR6dtRqZwVbVFPHUjKS+tbS/P1bkKlSc?=
 =?us-ascii?Q?YTXu2HQoIOmGtoIGLPE1W61CmACN5ToAGB/ANK0ojM1GW+y47sTzANvxfStB?=
 =?us-ascii?Q?ys2dBesMcl31jh6w09/4AeQ6n/5pvO2wIV96/X4dUZ1CtPWqSSIzn9/tDN3P?=
 =?us-ascii?Q?LeIoR5be5CUH/XpW64pxUDL5gZ3+GQtqdL+okOsjOgY8f3pFi1+DsBqwjH2q?=
 =?us-ascii?Q?ycJlYmaJjWb14jzSkvD1FBkVDTkaDVdzRJ33a0TQVYMZgiYuuHvacTZn5fiB?=
 =?us-ascii?Q?D/Fm7iLISBWoUYs+6A8Neyc82vIqMQfJOxudaq5dmw/DQ2YC4vxo2/RxE8LG?=
 =?us-ascii?Q?ifwTVQpYG6wJHfgN9qoogugnFx2NDEvuQuFbCJO2wbgkGtKf9rd9CVqVeIWU?=
 =?us-ascii?Q?eLhorLZOV1DNTbzOs6cGCsCi8+2IWyb43XN9hvSHVGKR/5xqqbiHxoF0h9iY?=
 =?us-ascii?Q?0CNlFkZUOWGdBNJukbivgndGgfBdN4vVdnIZyKGM7TbEoxS498mFsj6eRAxZ?=
 =?us-ascii?Q?knkUkhX9/t3NlSgr9LY6nIBDGEVBIe5lgAjhc2ggQGJa1R8swtz8lmTH8vZh?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbecf993-8d23-41a6-026a-08dcb72bc621
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2024 21:56:21.7073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJ23DgRubrRED32PXhmr1xP6V5A6gL/pFqaj89ihJKjSqGVsaySMLkkstpKMZ7ng3drYyc8kn/++uDjBSfXP+At5SYRA7zPyo28si0g1fl8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8243
X-OriginatorOrg: intel.com

Huang, Kai wrote:
> On Mon, 2024-08-05 at 21:19 -0700, Williams, Dan J wrote:
> > Kai Huang wrote:
> > > Currently the kernel doesn't print any information regarding the TDX
> > > module itself, e.g. module version.  In practice such information is
> > > useful, especially to the developers.
> > > 
> > > For instance, there are a couple of use cases for dumping module basic
> > > information:
> > > 
> > > 1) When something goes wrong around using TDX, the information like TDX
> > >    module version, supported features etc could be helpful [1][2].
> > > 
> > > 2) For Linux, when the user wants to update the TDX module, one needs to
> > >    replace the old module in a specific location in the EFI partition
> > >    with the new one so that after reboot the BIOS can load it.  However,
> > >    after kernel boots, currently the user has no way to verify it is
> > >    indeed the new module that gets loaded and initialized (e.g., error
> > >    could happen when replacing the old module).  With the module version
> > >    dumped the user can verify this easily.
> > > 
> > > So dump the basic TDX module information:
> > > 
> > >  - TDX module version, and the build date.
> > >  - TDX module type: Debug or Production.
> > >  - TDX_FEATURES0: Supported TDX features.
> > > 
> > > And dump the information right after reading global metadata, so that
> > > this information is printed no matter whether module initialization
> > > fails or not.
> > > 
> > > The actual dmesg will look like:
> > > 
> > >   virt/tdx: Initializing TDX module: 1.5.00.00.0481 (build_date 20230323, Production module), TDX_FEATURES0 0xfbf
> > > 
> > > Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m352829aedf6680d4628c7e40dc40b332eda93355 [1]
> > > Link: https://lore.kernel.org/lkml/e2d844ad-182a-4fc0-a06a-d609c9cbef74@suse.com/T/#m351ebcbc006d2e5bc3e7650206a087cb2708d451 [2]
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > > 
> > > v1 -> v2 (Nikolay):
> > >  - Change the format to dump TDX basic info.
> > >  - Slightly improve changelog.
> > > 
> > > ---
> > >  arch/x86/virt/vmx/tdx/tdx.c | 64 +++++++++++++++++++++++++++++++++++++
> > >  arch/x86/virt/vmx/tdx/tdx.h | 33 ++++++++++++++++++-
> > >  2 files changed, 96 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > index 3253cdfa5207..5ac0c411f4f7 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > @@ -319,6 +319,58 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
> > >  	return 0;
> > >  }
> > >  
> > > +#define TD_SYSINFO_MAP_MOD_INFO(_field_id, _member)	\
> > > +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_info, _member)
> > > +
> > > +static int get_tdx_module_info(struct tdx_sysinfo_module_info *modinfo)
> > > +{
> > > +	static const struct field_mapping fields[] = {
> > > +		TD_SYSINFO_MAP_MOD_INFO(SYS_ATTRIBUTES, sys_attributes),
> > > +		TD_SYSINFO_MAP_MOD_INFO(TDX_FEATURES0,  tdx_features0),
> > > +	};
> > > +
> > > +	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modinfo);
> > > +}
> > > +
> > > +#define TD_SYSINFO_MAP_MOD_VERSION(_field_id, _member)	\
> > > +	TD_SYSINFO_MAP(_field_id, struct tdx_sysinfo_module_version, _member)
> > > +
> > > +static int get_tdx_module_version(struct tdx_sysinfo_module_version *modver)
> > > +{
> > > +	static const struct field_mapping fields[] = {
> > > +		TD_SYSINFO_MAP_MOD_VERSION(MAJOR_VERSION,    major),
> > > +		TD_SYSINFO_MAP_MOD_VERSION(MINOR_VERSION,    minor),
> > > +		TD_SYSINFO_MAP_MOD_VERSION(UPDATE_VERSION,   update),
> > > +		TD_SYSINFO_MAP_MOD_VERSION(INTERNAL_VERSION, internal),
> > > +		TD_SYSINFO_MAP_MOD_VERSION(BUILD_NUM,	     build_num),
> > > +		TD_SYSINFO_MAP_MOD_VERSION(BUILD_DATE,	     build_date),
> > > +	};
> > > +
> > > +	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), modver);
> > 
> > Looks good if stbuf_read_sysmd_multi() is replaced with the work being
> > done internal to TD_SYSINFO_MAP_MOD_VERSION().
> > 
> > > +}
> > > +
> > > +static void print_basic_sysinfo(struct tdx_sysinfo *sysinfo)
> > > +{
> > > +	struct tdx_sysinfo_module_version *modver = &sysinfo->module_version;
> > > +	struct tdx_sysinfo_module_info *modinfo = &sysinfo->module_info;
> > > +	bool debug = modinfo->sys_attributes & TDX_SYS_ATTR_DEBUG_MODULE;
> > 
> > Why is this casually checking for debug modules, but doing nothing with
> > that indication? Shouldn't the kernel have policy around whether it
> > wants to interoperate with a debug module? I would expect that kernel
> > operation with a debug module would need explicit opt-in consideration.
> 
> For now the purpose is just to print whether module is debug or
> production in the dmesg to let the user easily see, just like the module
> version info.
> 
> Currently Linux depends on the BIOS to load the TDX module.  For that we
> need to put the module at /boot/efi/EFI/TDX/ and name it TDX-SEAM.so.  So
> given a machine, it's hard for the user to know whether a module is debug
> one (the user may be able to get such info from the BIOS log, but it is
> not always available for the user).
> 
> Yes I agree we should have a policy in the kernel to handle debug module,
> but I don't see urgent need of it.  So I would prefer to leave it as
> future work when needed.

Then lets leave printing it as future work as well. It has no value
outside of folks that can get their hands on a platform and a
module-build that enables debug and to my knowledge that capability is
not openly available.

In the meantime I assume TDs will just need to be careful to check for
this detail in their attestation report. It serves no real purpose to
the VMM kernel.

[..]
> > This name feels too generic, perhaps 'tdx_sys_info_features' makes it
> > clearer?
> 
> I wanted to name the structure following the "Class" name in the JSON
> file.  Both 'sys_attributes' and 'tdx_featueres0' are under class "Module
> Info".

I am not sure how far we need to take fidelity to the naming choices
that the TDX module makes. It would likely be sufficient to
note the class name in a comment for the origin of the fields, i.e. the
script has some mapping like:

{ class name, field name } => { linux struct name, linux attribute name }

...where they are mostly 1:1, but Linux has the option of picking more
relevant names, especially since the class names are not directly
reusable as Linux data type names.

> I guess "attributes" are not necessarily features.

Sure, but given that attributes have no real value to the VMM kernel at
this point and features do, then name the data structure by its primary
use.

> > > +	u32 sys_attributes;
> > > +	u64 tdx_features0;
> > > +};
> > > +
> > > +#define TDX_SYS_ATTR_DEBUG_MODULE	0x1
> > > +
> > > +/* Class "TDX Module Version" */
> > > +struct tdx_sysinfo_module_version {
> > > +	u16 major;
> > > +	u16 minor;
> > > +	u16 update;
> > > +	u16 internal;
> > > +	u16 build_num;
> > > +	u32 build_date;
> > > +};
> > > +
> > >  /* Class "TDMR Info" */
> > >  struct tdx_sysinfo_tdmr_info {
> > >  	u16 max_tdmrs;
> > > @@ -134,7 +163,9 @@ struct tdx_sysinfo_tdmr_info {
> > >  };
> > >  
> > >  struct tdx_sysinfo {
> > > -	struct tdx_sysinfo_tdmr_info tdmr_info;
> > > +	struct tdx_sysinfo_module_info		module_info;
> > > +	struct tdx_sysinfo_module_version	module_version;
> > > +	struct tdx_sysinfo_tdmr_info		tdmr_info;
> > 
> > Compare that to:
> > 
> >         struct tdx_sys_info {
> >                 struct tdx_sys_info_features features;
> >                 struct tdx_sys_info_version version;
> >                 struct tdx_sys_info_tdmr tdmr;
> >         };
> > 
> > ...and tell me which oine is easier to read.
> 
> I agree this is easier to read if we don't look at the JSON file.  On the
> other hand, following JSON file's "Class" names IMHO we can more easily
> find which class to look at for a given member.
> 
> So I think they both have pros/cons, and I have no hard opinion on this.

Yeah, it is arbitrary. All I can offer is this quote from Ingo when I
did the initial ACPI NFIT enabling and spilled all of its awkward
terminology into the Linux implementation [1]:

"So why on earth is this whole concept and the naming itself
('drivers/block/nd/' stands for 'NFIT Defined', apparently) revolving
around a specific 'firmware' mindset and revolving around specific,
weirdly named, overly complicated looking firmware interfaces that come
with their own new weird glossary??"

The TDX "Class" names are not completely unreasonable, but if they only
get replicated as part of kdoc comments on the data structures I think
that's ok. 

[1]: http://lore.kernel.org/20150420070624.GB13876@gmail.com

