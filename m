Return-Path: <kvm+bounces-17510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3C98C7054
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 04:33:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6E41F232B5
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 02:33:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1382441D;
	Thu, 16 May 2024 02:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N3U05HRv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665B515A4;
	Thu, 16 May 2024 02:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715826830; cv=fail; b=cOtvjAB/wPlcVLN4QNELdiFPeczFSZPfTQnC6NnmF31bRr2sslLLiK2FK3wAOEUwxsVRRHcEKhZpqHEuxZsVkqrcr9pjH5ZjvllATyf62/lSDBiQBA3e/WbiiP5AGqnlENulWL0KyFgX9IaQzH9WkkeAnXZIPhBMTJzvrNNVqWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715826830; c=relaxed/simple;
	bh=A05INsP5GMAxH3UcI7+wzPZ4BgXF1X3IKUGVBp4FhxM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Cz9vCjkLnAenlQBcRCF8ugRnxAslcChXzkM7HBOR+SJ3jT2dsdO5NIpe2Sy6cWBPzZMSXW/pCZl6+vDntLokoT3Oarqbyx/21LYsOwEcOWPFZA6ONgPF/mgO5CNB9fUEK89lnPZTURMj2dN+PFmbkrM5Uip5P37dXSNzMc6qSMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N3U05HRv; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715826829; x=1747362829;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=A05INsP5GMAxH3UcI7+wzPZ4BgXF1X3IKUGVBp4FhxM=;
  b=N3U05HRva64jOo7YbqMxTdGcQe0pdTArcx4iWb7f+Zp/fRhnQVjteUJV
   lHJa0fxZ68LwhW1T5TtjkPfiscEB+T2cKXecS3eBMiOpWEuGU+J+x8igu
   jzdjjFl72C48ytuRaWW8coHsno3e/P5jVpKsmBG15Sm3c50Xb07+mv9XZ
   qA6euq9thpL3H4CEfIBAZoteIvhylRdz5P4C0G6SJ8Cf0VPH+XvtH25+e
   nvFb9jv0zigi3hQL+CLk/u9WinJIK8O6bwZf6n17wLZdo0yBfVVdtsiRT
   0YwCCHyika3fhNJEKvKNXpxFXwYHwn+kyZENCPBEmKrioM2UovbsuF9Ao
   w==;
X-CSE-ConnectionGUID: rGp+WifsQ2GLj5eYHkhhsw==
X-CSE-MsgGUID: sdF72rdBSHqqwb8t9bz92g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23315355"
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="23315355"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 19:33:41 -0700
X-CSE-ConnectionGUID: 6L5blMg0QlKk4EN0+vjGGw==
X-CSE-MsgGUID: 7T2VyUAkQvOjtukbLQjePQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,163,1712646000"; 
   d="scan'208";a="35792560"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 19:33:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 19:33:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 15 May 2024 19:33:39 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 19:33:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cw68D2OiTPpjrgvUx+15a8rL8LqouGEiOU+AfbSisFikjWu3l1bTsBg2KFCnbonUVSoKUeeQm30tHtDVPY+OS6dK3LoW36LBzwRT8r7SS7zVY489yAlKjRL8f5ySwxeSFAZGfdxSpOj9aeqnQ9vLXoI2SPcBGKtcyaZpa5nSnv5rG1vlReQQ5Zi0Im5oTVaCWjXaUFEFcy4ipyJoMLroRUPX0x6YBE2KInlnwZ7ZQGwJRKsHKq+eE6beXR8lCYTdeYE7nV79Ch1XznYaG8WqFaJWfkRtGrk6MOco6apd0YD8TmaQYXAR+nxrih8gWMDnBj7CN4kWOdiaUdxfWmVHnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkmlR2q0n0wzC0o9XtwA/wQFGOQTy6HjW2J2eY1gvWQ=;
 b=O6c5sBd/TgDLD0B2M6xZrgdPpmv28kSciaFooGW7s/DtfddfRt6//uSurA2OhYiaVtVmFExUZgfynLNVK55vsXzdrqZU3L9opb3iUiGxkbHY1CmUCUpZn5pGa/iS9dYINfr4lFZbTe/AaST4+xb1S1R0tucC5XcQzKIitf0pl53IpE6fBqA+Hpqp2ENf5kJaCYNXXcIN7lVhHiz53zbQ+4sni9usjERTG6QAtm3wJM4nG8Dy8Rdnxr/oTImco+vyZW7pQAIQSy6bQ4habC9X8FB5IjpIHxiUHACJ/IMTcZEK9iYOU+VF2Y6EqKtBnasy4g2Pg+hD/+Zw7gOZ8c90mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB4873.namprd11.prod.outlook.com (2603:10b6:806:113::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.27; Thu, 16 May
 2024 02:33:32 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7587.026; Thu, 16 May 2024
 02:33:32 +0000
Date: Thu, 16 May 2024 10:32:43 +0800
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
Message-ID: <ZkVwS8n7ARzKAbyW@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
 <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
 <ZkN/F3dGKfGSdf/6@nvidia.com>
 <ZkRe/HeAIgscsYZw@yzhao56-desk.sh.intel.com>
 <ZkUeWAjHuvIhLcFH@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkUeWAjHuvIhLcFH@nvidia.com>
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB4873:EE_
X-MS-Office365-Filtering-Correlation-Id: c6eed315-6d63-4da2-2a8b-08dc7550941f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eO+msGD1Od2O0DX8t7jd9CS7aE2eJntxniF1Ev4keQOzZOv4fQdxOCMThnxY?=
 =?us-ascii?Q?h1VPJKIZik1qW9NLEO3fU2ukwPfidQ9QiduwDG3BZYgZWU+crWxOJ+JAIoe6?=
 =?us-ascii?Q?pz3VmEu0Ebcusai4QaZ7ddGxSQUsvxao2c/tgp+HA1EbQNLFw2NoZtfXmuN7?=
 =?us-ascii?Q?QBmLAon1IJ48s2j6tZ3rN6hZFWbmRFVpDqcM8ryEkEVk9mqDSeCc1lDp7gpf?=
 =?us-ascii?Q?xpLZukOTyHWOWeslvc/RLXBxP4K57GRXSbROenigaorim9inyg26quxrf5xz?=
 =?us-ascii?Q?ykT0X0DCHoCSCbGq7WYn/a4g61Jl8unl2gR2JvoE5l59MuE8bJqC3UcH9YEL?=
 =?us-ascii?Q?EkxrQzHQjxIiNQiV0cpp60Yd+5QKy6RECnE38m0WNzxOBq49CdCqV6aq7AwZ?=
 =?us-ascii?Q?cdmXBCBdGl0rbPVbk67Zzz5/w/3K1STaJhetQZ0UhZvdsZUFzXHbuHQot1Pr?=
 =?us-ascii?Q?62zc5mHrnNshUOyXL4wfnPfiS7Pze1XXzL0t+3bR/2b9xE+0pMnERwk/GmHd?=
 =?us-ascii?Q?vVMwufHhjUDrh6Nw+tpW+g83IN0PpJGsMil4Y87KfoLNZXLA+5ZKcApZ80K5?=
 =?us-ascii?Q?LjFXVwN0gkr0iRNiXUYULaOw8/kg/O42lLzVBgyttX/2hcn+G2Rid1ebpsB+?=
 =?us-ascii?Q?EXsgErMw3w8RMpaVg7xHQbaaA5UPO1LoxjMcoaifDtdmQXSpyp8Z3L+D8UM/?=
 =?us-ascii?Q?cOorL1cm/GNBmwzz2d+L2uSEwI1VKLH63SEDgKPAGv2TSTXCNQMf8AeB3DIW?=
 =?us-ascii?Q?VXHNbs6Uy+9qZdRrjmcD3gAezTVDhZyCYBLBBbSRspGwA6tO2x4mj6EtwW9l?=
 =?us-ascii?Q?WMhrMFsmWxZx/vhnhE86yWrWZ9VQg/9FUJFNNG/K8hYrhKxuhh/S46KfWBdv?=
 =?us-ascii?Q?YlriagMyHRw1p21nfv+rvJB7nI5mBoX8kSNFkWNd7hnUbhnICh+Yb7kWsFOf?=
 =?us-ascii?Q?gjP9icRHT/+BZLSS1uM1lAcX2ZUX8mBxKBtIcw19cGo91FmoO3h1+H6hb0jB?=
 =?us-ascii?Q?VRDsjA8e2FRHR1X1x8jICCh/GSuprPN6TtP8io/HhCnHKXGqCMnsOuOKbss0?=
 =?us-ascii?Q?ff+DimfAsZziNZLEd8HqokR20S1CylODT6hKED8OBKYhqaDyil50DCgF823v?=
 =?us-ascii?Q?aw5FBJ7dAXO++yzfNnpJMgIUS4mrTwsQdyR/1G+SH9vURoXMM4Mhk9Afkhlj?=
 =?us-ascii?Q?wjXlIBkjIp68O8oLTaQ4SAAd1BVqWAyHK4QN7/u5l6ZHWAMSxE3OC7h7cKwr?=
 =?us-ascii?Q?9B+lftlZaxYkn9Syqw8b1n0UjESs9tPmCVgMJflaqg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fsa3QRi1risIFIl9XyhC0DUhTy5ZS6beHbXP36J9y6oWv0nEq8CfaVhwEcU5?=
 =?us-ascii?Q?KI/e39NPiOeGGKUQGRXuH2s1Yi8w0UVBZ06Gwn6UF3m79FLx4H93I2AfAFyr?=
 =?us-ascii?Q?YE4IU/CnH6b9RyO8i2cljOiCuPtKxm3wwVtPuzSvdqRTW1cddwh5+pevINPF?=
 =?us-ascii?Q?zkgBWRAcMkEov3VZz7MfkqozJYmpFCgdgg80fHizvp9XucQ4f8WS7hCKzmXT?=
 =?us-ascii?Q?unpealawXfhV5EVJscpyJD8F+mXN03T8VxNNETviOb3WLrChn01laf1eyy2f?=
 =?us-ascii?Q?mt10aseHwLLkEPXMbgkfhhJsy9B4GsL8U0Zo0+Pt1ZwKkMbgWBCGclUnjbfF?=
 =?us-ascii?Q?3fbzB1JyYtzV+NQ5W3tN+l1JJTq7oL/a7EReEopH6x98ID36FpUIAqNgtkw8?=
 =?us-ascii?Q?0RwQWWj/wlUkQGBMpE/CSteFG5ZsiGAoYw6sR2EwU/Z+pg7sW6e6WA4X35bG?=
 =?us-ascii?Q?ler9WOM4SQCJyLt9Iz1Wg2uiVhRK6ElM6BRCiY7vkWIzq9sijVr6btD2mBZd?=
 =?us-ascii?Q?gHPRiJ2nV4vswPSKp/W2ISH6HW9ww9vBkCuf/5cBHI61WJEfw7CQF9sdTP9V?=
 =?us-ascii?Q?QtHVYf9HlrBLrVk/lCfdZ54vinZPibnstYv7z6GrmERvl+W0nkWd5BFgbbXH?=
 =?us-ascii?Q?0o+p6IkX/yGRzINuqgNYGcLjHjmCDg3mygkrA/TJSbjPpvnepFxn7sqTZfNP?=
 =?us-ascii?Q?ZfVnQHQy17+DP7ay7mg7yOHKc5M8sSN2BJi1JQmVeVwXgLMfjMvryZnde/3I?=
 =?us-ascii?Q?OffKozd0Xfb9/tplZLAggOtJK8YK5Zbt4oZrismO61m3nAiBR2OATLFbeg7h?=
 =?us-ascii?Q?cfvJn63B+sifD5SYVXbCamSH7K+XB+QsXVWqvHBjwvfcPee4IY4hwmGeVzev?=
 =?us-ascii?Q?Gg/74+f9T6qD6VfQ1kXnS/mOPpOkQdJRgix5sLZ9hJSxCh94syA3GcePECAP?=
 =?us-ascii?Q?wPT9m+VpGSWYeu7Iz6UHF9suXR7wq7LdmVMTKlxuAn63SCKbtAJG66HnT8A4?=
 =?us-ascii?Q?0YJ4oOvXHtUI08wGq1Tv9rC6GkD37PSFMyDsPMHgKEJ8KcwzPEzj2uIB4UQi?=
 =?us-ascii?Q?K/F2MY+YXq9usYrTL/adf3Jxsu3q54pkakA8IwiJkFp+/zYkANdzbgSxcHo3?=
 =?us-ascii?Q?Xv6QS0nDAVvTQNR96geojjt6Ekw73wyea5BCk6GrsbeUO2Mp+07iwEPCkwAV?=
 =?us-ascii?Q?iaqdaB9NXoUPzF3KmkYVxxCui8QQ4Y9lpoP/GKTGu7PqSaE+8ZnpbwMgJdGz?=
 =?us-ascii?Q?ZIkyfU/E4zjIgo59CD3jxIlwGLNPNvd1SSaFmRPwcPfbjowBPBIzaOEUQ6Xx?=
 =?us-ascii?Q?pu3YYQC6TO8xXU2aZcbzVwb/GlNtSZp/Jtqz2mixA46J7wxIx5yjZpUv48nR?=
 =?us-ascii?Q?4VeSNqdPUkqDepl/lmxrH8EbMh30P3hPaZWaMNpn2pgewGBZDFdUsSHphbFd?=
 =?us-ascii?Q?Jleg4bqWaLvYgeoff4wqBt9JllHQQVvbnNzcz4KnM7NwEc97KcBC1Wj7PefW?=
 =?us-ascii?Q?8+4UkdKfPBlyX117t6bjxLpuWM/gAb9IIFwCaYMTzKMtRMOg8YI5hdczFvZX?=
 =?us-ascii?Q?itn8p65CVBuvexb/AwSXErcy03arOS3oKyqBFTMM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c6eed315-6d63-4da2-2a8b-08dc7550941f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2024 02:33:32.3974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LloidLkxiN700r4xT5LmqLSRWzI/3fpcLtBbXoQ71dGmx6vDDg3AtQnP6RnJCStaN2YJc/mzmxYYTjO53bLR2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4873
X-OriginatorOrg: intel.com

On Wed, May 15, 2024 at 05:43:04PM -0300, Jason Gunthorpe wrote:
> On Wed, May 15, 2024 at 03:06:36PM +0800, Yan Zhao wrote:
> 
> > > So it has to be calculated on closer to a page by page basis (really a
> > > span by span basis) if flushing of that span is needed based on where
> > > the pages came from. Only pages that came from a hwpt that is
> > > non-coherent can skip the flushing.
> > Is area by area basis also good?
> > Isn't an area either not mapped to any domain or mapped into all domains?
> 
> Yes, this is what the span iterator turns into in the background, it
> goes area by area to cover things.
> 
> > But, yes, considering the limited number of non-coherent domains, it appears
> > more robust and clean to always flush for non-coherent domain in
> > iopt_area_fill_domain().
> > It eliminates the need to decide whether to retain the area flag during a split.
> 
> And flush for pin user pages, so you basically always flush because
> you can't tell where the pages came from.
As a summary, do you think it's good to flush in below way?

1. in iopt_area_fill_domains(), flush before mapping a page into domains when
   iopt->noncoherent_domain_cnt > 0, no matter where the page is from.
   Record cache_flush_required in pages for unpin.
2. in iopt_area_fill_domain(), pass in hwpt to check domain non-coherency.
   flush before mapping a page into a non-coherent domain, no matter where the
   page is from.
   Record cache_flush_required in pages for unpin.
3. in batch_unpin(), flush if pages->cache_flush_required before
   unpin_user_pages.

