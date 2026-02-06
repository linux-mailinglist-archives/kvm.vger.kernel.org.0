Return-Path: <kvm+bounces-70403-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IHlZKzNUhWmV/wMAu9opvQ
	(envelope-from <kvm+bounces-70403-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:38:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 35AF5F9626
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 03:38:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15363304A31D
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 02:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACD3F26ED40;
	Fri,  6 Feb 2026 02:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hK3AxOQg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB44E1E991B;
	Fri,  6 Feb 2026 02:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770345294; cv=fail; b=mKumkzdO98TqvbYyINnoogcceUCdw1pXOstRpzWMsgLg0ZcQuXRlpCKzzipAGlSxzEb2ngM6ONlxRoZkmYTtb7CsXY0uKPa9VWHfLvBdVR2kZo7TjHMd1zp1vKiYiY+uzLWJQu8rCOeAVbkCXYogQVmTJurK9T/Zy8iat1cCQys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770345294; c=relaxed/simple;
	bh=dBILUZIa0aw9itwwRUS/eC3uouJrqs9SokR1d4zkRuE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=doYlQsSxum6VCetaqr/W5zIlLROutGKGXqhpkNgLWbffBwtjo+vXgW/THRyB7Fyql09U7M0QY+6ZdWtW1FepehNSv6el40QQ0BklDYurMLHFVKOOjcJSEi9kdQLibVxSF6aMgIIQWfKMS5qEhg8jRneVSUwdg9ZT7Um+hiCfJKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hK3AxOQg; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770345295; x=1801881295;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=dBILUZIa0aw9itwwRUS/eC3uouJrqs9SokR1d4zkRuE=;
  b=hK3AxOQgwo+QJIbwOfWAVI44MxctvXCwTyHrKhdHE5E0CcXrqBa71Mzf
   RfuN2i6Y5ai5TBlPwke8rTfqRWazwFmf87QP6ZFdbIn/EPRPScpHNWXet
   MlKP5wFTtCkr0XG3R/4IPk9hTvsgzEjARa7DIpUP0Z/u4WoWQDulAXiYn
   a96YAOsyQ7pWBbDdAho0SVUYoMf7+lPqDs/mU7ULmIQB2R4UK+VakfhCD
   hX8Q6/OVbeIt/lGIRcD7M4k0aiN7WbKMrqieO/4PGJJcrXuqwXMyotK2d
   UCjIPpiGEIx3ERyXcKGVGblanxNU4e7o/7TkiyU7SXMvw9oNEt5s5lAfV
   g==;
X-CSE-ConnectionGUID: vpEq6dT/SnOfAfB3DWN0zw==
X-CSE-MsgGUID: bQjH3bMDQpOMQl2FjtQRMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="97008963"
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="97008963"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:34:54 -0800
X-CSE-ConnectionGUID: DRuQhJuiTO+XjRro9dIuCQ==
X-CSE-MsgGUID: HSY/Ml4mQpmMrNMr91ajJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,275,1763452800"; 
   d="scan'208";a="215238155"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 18:34:54 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:34:53 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 5 Feb 2026 18:34:53 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.15) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 5 Feb 2026 18:34:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pLr0waMGBkqxVoliV55zMB1inLzVAGAuNgLUUJlT5konZl6F+faHN4QEJH1mhDO8RVpiBqBC2xnTZWGCf8N/89Btxut9ypYrhZoHgnDkPc5fQyDSK8N56cj4nqP9HUcVbU9HW/wpcawcuiXYHrzv5UJvO7oOtIlErqWgIAsLp/Jg1D3jNvY+lN7EmSFurerMaN4qUpkGWJqYsDdJ5Tj9CqcRwcFXcexGdW6RP+arCo5PRy1RfAVKt5am+R3E1Hzr0Otpz04O7S6nvy2nPH20+wno5gSBfsD7MIubfMx6ihI5fgemW6j+zPkoKXSEJqDRS2vOLtWy+YJInepJFYT6sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SyArrsd6NiNqN4eWRr56EHR+rn7J1oQw7qWoKKECzE=;
 b=k2hLNHbDt4f8qEuvq7jnZLJ1KJwLDxDK5oy3HTU4hQC7XnVe6rN3+NPNM8vETM2nyvKpX16x7etalCuzBOKehLX5fD56FUQ9MwAhs5UrS1/OkawyvsNYyEbKmlyL23yeuL3yOJ/83kYVRw+ZbfY5+42qw93Dw9+nwj3NLU6UGQonObBLXXdyZlZkegKWmlHn8Rqu/oEmsUtmFMVPhuH50yHhe8dHco1917MIFVKOxkBMnSIYaGSn6g/Yk6FyxCeKd0rx40qzESHmk7UE7UJ2kihyrZnbhCK9bmOHU13L3artdFnkQhF/H+/ivUegmnInZZ+BLPirK42X5fFCM9fJWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6822.namprd11.prod.outlook.com (2603:10b6:806:29f::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Fri, 6 Feb 2026 02:34:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9587.010; Fri, 6 Feb 2026
 02:34:50 +0000
Date: Fri, 6 Feb 2026 10:32:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 16/45] x86/virt/tdx: Add
 tdx_alloc/free_control_page() helpers
Message-ID: <aYVSu4Yzbqdw/LgE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-17-seanjc@google.com>
 <aYQ0l+C42gssMHHV@yzhao56-desk.sh.intel.com>
 <aYUbLVrxwDDZ2qh-@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aYUbLVrxwDDZ2qh-@google.com>
X-ClientProxiedBy: SI1PR02CA0018.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::7) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6822:EE_
X-MS-Office365-Filtering-Correlation-Id: ed89ccaa-1eff-4f21-b5e1-08de65284ceb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Hs6re5B3mzv8Tr/XtDuizXzKq+VC86hmNOYe/uRfxuRBirb8zEt75Dn25LV3?=
 =?us-ascii?Q?t2nbwnzPG5PvFnStxhTYiaHmEwTK86kEUnqYgnF9hCoWMhhs9Ux76LX28Q/C?=
 =?us-ascii?Q?19CpPqGEbAoRIG+/LGZ2u/YvJNZIjN7XyrEzHLomdziEJHdHbmSj1aOgCXkS?=
 =?us-ascii?Q?LYH0Qf1REfs24VJmrd+p2+dJPVKvi9z2YL0lybyzh7tmUGJQTFe9byD86nyV?=
 =?us-ascii?Q?/7OcjjkhTKKd76oz4SYAsA2rX0uaBEfC3PtOYLiADQ8kEmDLu5KFXq11X+Dv?=
 =?us-ascii?Q?jNdq41QjliNchBq0sBz8SqD8IJzkqQ77YGvVIC2Kz7IIUJ6K+HamimSfW7DB?=
 =?us-ascii?Q?cTtttCt5AZCh6cQU55VgKT3I67gx8KwkzaHjJf60iC/1P5Nl7B683h3DIlQM?=
 =?us-ascii?Q?rFvJmim+2aHCxYnDBknktS6RS4+LRjTjUj/lgmyns1zaYFOLAGmxmRg3TuPC?=
 =?us-ascii?Q?roeRoM/b31oeZfbDoQ44qpl2/N2R3ApK/g1lbktTYVodbKehzXW1dwKIvNee?=
 =?us-ascii?Q?0Ca4wLS0tL7ZR7NKT2UcoXm9ZgsEpnjtn2zmn2Ro9y8N/YiLmn3/pq1u5FzP?=
 =?us-ascii?Q?ChVE7Pao2YJQAh6Bj6BUaw8tKNUGlrV6FIosgcyQ1E54w90cgDLUt/INWTLT?=
 =?us-ascii?Q?h8JZmx9XKaOrTqOdGQj9vzWhhPwnh/Rj04jVN4hDivwLtN10U3dAfowwTU17?=
 =?us-ascii?Q?d+/CpXwkG7ctAYSIERg0FCACL9nt2cLdbeZUypMcIBB1qMAqud8wIareDGv6?=
 =?us-ascii?Q?JRSdoxqyP1In6JIuiRjtEvUPimfZJlXB3Bf3lm2N/xYJk3CcXWhfIAmqQb0s?=
 =?us-ascii?Q?BwVMIn1Ei7/+k7dvS87AWsVBOs3dtfCK428HsFvd/iyshRPnQPPhGKR7L+Wt?=
 =?us-ascii?Q?ukHO/1wxse/y6e3dPQlKbyyckyScQt60kM8TwRL4XxC1nib3hhpiV+aWSz56?=
 =?us-ascii?Q?ZB4i9cmr5aSVIYr0PWLdGchYvH3XsjGjCS0qfVt8D8OxPJNYISlpb2MwwenA?=
 =?us-ascii?Q?Jy9XOs+jXa0x52sgidIACwI/nRO7/LdCHCghYacLQ2Q/AIkP7t6Yjv4/PKYh?=
 =?us-ascii?Q?CCZN05k9da0Po6sEGtc7Xlkeyh2XKbmqnRjwugHSqJg7pVNJiV3S+VuVnp9g?=
 =?us-ascii?Q?U5QoMXp0E4nKHmwS387wCHGD8y7lQgF45kacawS1fmRmuAcp5q6iJEdi3jmS?=
 =?us-ascii?Q?0NniU+Qrfhpt2B0i3UTo+qM00MtZ6Wjuphr+uzV95ZHNDQQh2xAn+i+jhBNq?=
 =?us-ascii?Q?xVStO2YjSg0TdI2v2Pl12wwjtAfO+hVcPhi0X3KDAu0K6zvSCHZoejqmHU4c?=
 =?us-ascii?Q?+IAGjle39UjLN3R55lllRSYf5XyP7wm8WTjZFK+N1fjeIrU3Afryl+NNoNZN?=
 =?us-ascii?Q?0MKdwuAD9RpjM9LwXMOp09OrTENf3ie4OHA2vGiDOrXMt9bEzUa3vejmYW5+?=
 =?us-ascii?Q?yRsUmzH1Y8e5PFe1bpg8zUVQD3duGP9CC1tIlKWysYrgqpiuQbjujIuNKeRM?=
 =?us-ascii?Q?0GzYXScpAzJ8IWjpi+HMpOxldIJdLerDI+YB0XIPfCu2xeDlKk5m3/vXwAaP?=
 =?us-ascii?Q?oilMcpPAPOVQGB2ryd8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IB9EOERJ2XUKWnLPTQ2xYK9nfA2MkrvsGwax9XcUeSY72SBYJK+MSYFOV1Er?=
 =?us-ascii?Q?srqspHfCgIEMSyZtUoukwYiRHw4Zryp/TeODiuQn1MO4RQpSwUk0PNpV8oMi?=
 =?us-ascii?Q?jeNotpu3sV0vE2iMRb2td7RC+jfm9CRI0N0v+AlFMGv/lzXehHxz9nnO8nMZ?=
 =?us-ascii?Q?75WhWQ5SDKEX187rbNMvVk4m+vAMnwN205sfc8BMTrX9c93iKCh6T7V6UzG4?=
 =?us-ascii?Q?muFDLjufNJT7fh+vQfNzFmnf6Iz3WRSLi+iQldi3+rqCQxa/Y0ELuxS5l/qp?=
 =?us-ascii?Q?VFzMX7BkQ2joiN2LRmZBVjPz9VgHKqtBqemOIBN64MPzsSjPNDkt/J5AMjM9?=
 =?us-ascii?Q?iLr9pKMopP5y8caDAD1vDjsK0y3evRooqxrZQBvdfILZRzSvdkwK0/SQDECs?=
 =?us-ascii?Q?YC23LJZ+6kQ0GSl421IadGRs9ABp3KCxQ78Ne14+Pl4Kfhhz2DGnHDjiu6hj?=
 =?us-ascii?Q?dmgNKM4HqfEld8YKDwb8KvClTANDen5gJwx7f18FQqcnjWNLOaqmtPh93AyT?=
 =?us-ascii?Q?uKXS7D9O6GIsLw6Tq6MDS6p+O5/WsdFEf+iR70tLhiQzXPMsVlFdIa4tjfPM?=
 =?us-ascii?Q?TbItmsRMESeQ6CcwenzJ7e9NMATRv5pYinP1Gbu5Uf+fy+3IccUbNCqwb1zq?=
 =?us-ascii?Q?PtTSB8+UCctPMMF6dGwO3lLREOxwL37vlaOoxJW76pcuLbT6YguOOkY1UK+7?=
 =?us-ascii?Q?3AHmMNWJS2TfNtIAqlUq9Lqr0gwZvNgRxm1j3juLaAyKz2A9eQ5Ah4KNjNbi?=
 =?us-ascii?Q?j8OjNM8ujXI8qCWGmMbYVzRWdAmhlNDCLywGyPiYmehgrMseq+mYPXQX4g9v?=
 =?us-ascii?Q?QeOT5TkQ153H0viwv86BXcFIfVx4f2/BYCQRpum7CHDPw85pXrtAM6AEBkyW?=
 =?us-ascii?Q?R0tWfjRb9b7Ju68EQZH5Y7/v2aChW2RPCHiiZLXggu2XTi2h4dFYiiAQpYTr?=
 =?us-ascii?Q?jRieYYkg4sj0uln3wI/0W27oyrLTRFeg0z+8EiuLnJ/MkU6M19TdadNRkE0d?=
 =?us-ascii?Q?AiwaAX5++M5+Mb1Ef0K4Vxi0Fi5VzStH2/HFKkO8TA+B80Qe3h/y2TXdTqdg?=
 =?us-ascii?Q?wZ1aFiNTUKnlrskkzjSuvHOEyWqea36FTnQFeNML7DIB2hPxY4/5HJF9zsRS?=
 =?us-ascii?Q?WD84kfbKnvXob/16jSHuvHua3W2vOl7cTHEet6X2vGcdb096/EXVGRQYFtSe?=
 =?us-ascii?Q?HpfpDF8sioP+7efY4/Z2lJmt50RVEg4zma1Ab3ncOmn6jv/vNpqbzVX/vN6u?=
 =?us-ascii?Q?MYjoV13MVCBPEBA+n7Ot+pApY4kXpSDWjGVBDrr7TUOBqnsmUH+t50ciXIxF?=
 =?us-ascii?Q?P1Kdaa4HOy0ES2Lbn0GwdX9KrX79j8kPPlfXkZvgQKS4/mnlBNKNk9ZWEOKn?=
 =?us-ascii?Q?MqxtfDAF0Plah4MxgbahtkOFkTpGetwN7lT08lRSRVDhTculsH9da3qOIHMm?=
 =?us-ascii?Q?aLk5NscBXA791P9NlN5R+KG4ndWsMF0c7iajc1/NKTi+/MiED2zbZmq9KmQy?=
 =?us-ascii?Q?IWhvmHzvACWsacG8F3Ov8Mw5bGm3Y9Ep5U731QfIzUfY1dt6xey5WZBXV//W?=
 =?us-ascii?Q?i/dUYTwni+ewrtD9nMyzfYpIIpSroG5ofj3eDYF4fGGOrgjN7zPwf8cJ7a6P?=
 =?us-ascii?Q?CNui02rtPrvuTFMqtLS6F2rA2AoPxaPZjxJaIqkghznezPGznuB9I87f+b8I?=
 =?us-ascii?Q?n31BDbA+IXqNGRONDj1F9dnT9GKtoWOPkt0k0m/ZSwcIJpPs57JkBfRU1dHG?=
 =?us-ascii?Q?msaZDQBExw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ed89ccaa-1eff-4f21-b5e1-08de65284ceb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 02:34:49.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBU8eMzx55ymngfZok2h4qYpu0j0feKv09u1tXtTF4kvaPP1BHIT8lDWpl6bgx7VERHIBHYjvtGFE2jVLueqtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6822
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70403-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 35AF5F9626
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 02:35:25PM -0800, Sean Christopherson wrote:
> On Thu, Feb 05, 2026, Yan Zhao wrote:
> > > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > > index f6e80aba5895..682c8a228b53 100644
> > > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > > @@ -1824,6 +1824,50 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
> > >  }
> > >  EXPORT_SYMBOL_FOR_KVM(tdh_mng_rd);
> > >  
> > > +/* Number PAMT pages to be provided to TDX module per 2M region of PA */
> > > +static int tdx_dpamt_entry_pages(void)
> > > +{
> > > +	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
> > > +		return 0;
> > > +
> > This function is not invoked when !tdx_supports_dynamic_pamt().
> > So, probably we can just return the count below?
> 
> Or maybe WARN_ON_ONCE() and return 0?  I have no strong preference.
"WARN_ON_ONCE() and return 0" looks good to me.

> > > +	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
> > > +}
> > > +
> >  

