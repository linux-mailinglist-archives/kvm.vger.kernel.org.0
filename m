Return-Path: <kvm+bounces-12351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBDD1881C2C
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 06:43:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 641191F21F24
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 05:43:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 239AB38DE5;
	Thu, 21 Mar 2024 05:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYrcxF/K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8050374D9;
	Thu, 21 Mar 2024 05:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710999812; cv=fail; b=d+VWLPSDMXbY+QTQC8seZZvZfpLS31oL+n5N48vDPswBo6WWdGqi3umvw57g9/CcmUlPuhFi8S9ImScVoKIqkCfftlAapeQoSRZGJ8m9Veg6QmfrivtGbPlD/U4x+CQQRniNMieuW2CAxPiU7MMTw6r9QxDdEy6odC/FcZ2bZRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710999812; c=relaxed/simple;
	bh=X+qjYbBnmv/dTzFpQVC13GwGakPFqZTGowmXm6HhQJk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dMoKqRgXWhIzWTlEmN53n9GMiJZ0zElKAXymwH2WEDqLFxZAsVDmPNNJZrAXNhBDO6hRQbP+URO+hVeZZKLwBFBhOeSAUAuHaaIjeugvqJn2I9SezlQrK1kY+5wF/TZMvhvt7tdXL+RCrifVKIGWmqrl3q46fBbUp7112zfeXQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYrcxF/K; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710999810; x=1742535810;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=X+qjYbBnmv/dTzFpQVC13GwGakPFqZTGowmXm6HhQJk=;
  b=nYrcxF/KQUVsFY0+Xgff3OPh/yS0KEo34CFDIQUKhCHId1luMNFp7DEp
   l7Z99oqO4l2qZOU/2UvZ0X0XxK1qT+sdaD1cqzDvd81b4DCTxt07a5X1G
   QpQExUFnbu7dDh2rlsMXN1XeiadRaPwNrYfSVqzbkitnQpYn2VAgdSLUq
   FeEmU+Ye99aQiriPnUoZx5CusaNVCreSfEfryPVvmqg2UB62EYCOtsS6Q
   omwxPzU+SO8f8/63q8kgw6se1njKtRCO7s/pOS2Uv9VvGtCrlEHMoC8IK
   bgrC3RWTPbUNTgGYJAiC5WsHivIz+/GK7o8Ufgb2UDMbp++10bIhsEUKl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="28439101"
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="28439101"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 22:43:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="14419451"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 22:43:29 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 22:43:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 22:43:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 22:43:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHF0zvs7V+TNAYLlcnCJcoEiM2hGU36YA2UuuwI7dKDHUiIcHOsLoWa0VXvDwm2IcyokU+UMUWHh5+w3ksiaun/ELcdSCNu4nkXKynTYXu6h8PQTQcSFyEsKx2Af6lXYIsi+Q/Er31ZbrCm+SHEgzmfPXjUMLGIKC+HDRkFsh974wGae2NcRM7TY8BJkZdyFLQUtJZ9b2UPNZRijhUbIIhuqKRX/iQQI/qUnnQ01x+jp8lfDgbLV0yfg32T3uqQLlkJB6P2/VU5kK9qXNciynF2pglgEooWu82K3f4PYS/GMWx/Xd0+8SCkyQt9v6xLvmNdBfqusNhO3X2MHcxQzbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zQ4u/2iL9iUoY5htx9QIjFD0pp8Em7P1HWwg/furbjQ=;
 b=Gy0nhlFYKRJwa3FMHvSMpZLDVGyIj8k0XRJJ9FoQB78ltmm3N3sUq+ppT719mv3NQExkIiHSIGTM/LjG0XuvcbRA+0xd57iJdTKDYPia1Qdas6x3Z8r979N0FSNsI/mi6TbkD2vpG2H7HYOVS/9I2qQnkHtZMxllTkGqHeQyPzmLxgxrsLn+END9mPKZv/9VNNNT+nJmbdpa/S0swGpJ+4rT4jVpSGDuhbsBVrMVSAXeGICUoOmk4j61rYTQzLUP4hju9wWNEIyEhLYM5VNqSQU9s1ZD8p0CmN6DJ0pYU6FQpfjC4QUt0MVtkOVEWYqN2B0KjvBaane1EYGa2WFPSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13; Thu, 21 Mar
 2024 05:43:25 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 05:43:25 +0000
Date: Thu, 21 Mar 2024 13:43:14 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 044/130] KVM: TDX: Do TDX specific vcpu initialization
Message-ID: <ZfvI8t7SlfIsxbmT@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <d6a21fe6ea9eb53c24b6527ef8e5a07f0c2e8806.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d6a21fe6ea9eb53c24b6527ef8e5a07f0c2e8806.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: 12ab73c7-3af5-466e-4f64-08dc4969d32c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TEFkYP0eU1K+itGr5py5aAbaxFytTqiYNRVSQ6Mcbl2snnwOFvbUup1WLnVbTKZ/BPSfLsK7FOjJpCF7x2LGGo0PfsfRehM8EeWaoJA4fG5qi3pYIdMcfEq6k35DWy3Iwtm90BOXFOfYG6mwdq8/Yme3BRGSV6JEz4h83vBSWQankAMiUcQP1fdNpuvusqICvEbJED5Mn7iInDaeWeQSDvab2IM84F2yMCXJv06YBOAr3guxmwXh1HO8jGG1hwyQ2dTarO5fBOFvgu6eJZHn+A6m5oBylFazZ0mkyIzEdzw2sBNI95dKlRRuucwew9owYwPeuXJO41BA9FCBFD65y5RtxP7vNKbM5t3aJtbbMKkgiwFUilcJO2MwHiSpfOKsw2qGZ6soeANjMmI7hnNrP0sEhzkvqtaEYhqHHT3isTD+jyd+YIfOtJOT3kLGcogVQrtibfgsHHx6wi6FlGHGxKLWZTXE9Rcbi7BatdkesIGUGqMj+lIyEUpOCqg2G/YjWVjRin48ib3heYQIBxbIxrBMxsK00m0lL/A8MIhZoFScf64VMM1fLdKEToluFzFbh60+wTNnckE1RZpcXPM/1fZIje2oyRMp1Wh9fPGZ5cZ2OQs1SLg9YKv3Me607XT9ZFcIa7wRqALwZLGANeyMO10AO/OTVItAJouB9Ot4PhY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GKi/ecgrIrIm8Uwn16ScZ9tA5RxOGgZXDXqVsKK31DLGLDTg6lgwp5bVJtof?=
 =?us-ascii?Q?nxpfOfZPO7VUlTM42gmy/cEwCqlfkWfLOvuESwEavlvQME/J5chf5bsJ4ets?=
 =?us-ascii?Q?pm0APrECSus3Od6R2mgG5oGJvgFdWyshbZ6FTAGUYWKZHtBBizjNTPBnd45Z?=
 =?us-ascii?Q?e+CVz7vaxJnkfiKoUI9UKJ0/5Ilm7wa7BGFP6/LrJ2qOOJBzLzKii2Hy7XyO?=
 =?us-ascii?Q?PAw+onnJI0N21J7fZXZGcMP5xqNWqKYT4f/5vrqnwdDtL4HB15feEFnPzb0a?=
 =?us-ascii?Q?9E++mY/xM3aBY2gFAnfXLi0GciaqV5K/ZwM6YGoF/hVOEkL0fDYV/wCKZ7J7?=
 =?us-ascii?Q?D3ojfZn0/gnD4jINsLm0OqgCmCE5zreXfFc5Ed74vrXQt6+542VGud3HZJB6?=
 =?us-ascii?Q?sMZFL51Bga1dAA2g6SYu/8TNYu3m7QPMCkqbSHQumTfpnn7Uft4+IC9PM4LD?=
 =?us-ascii?Q?L8ae64ZmexIAF7gFzWQ1pZVdqOp/LRsN/GLrTnZ+qZ+qGYQWSrqc4NtFE6Ge?=
 =?us-ascii?Q?0utD9pK/7MFoglP0Uez0Zx4jzmZJAsYcaDeIYCq0rCjNyPDZBbXF2nRrtJL0?=
 =?us-ascii?Q?qTSnit5vd8vpXB76jK4M+YaaBrqo6NexuKzzZhh0KybEId8uZxc0jTzpW+w+?=
 =?us-ascii?Q?FYuqZEV4QHgPfkZGvk/tg0n+dDECgH3+hIJksaAL+aY328T9Sqi3XPp31tRB?=
 =?us-ascii?Q?XQnzWEsvwJejZwCE99n9feQkFxWDbLLcwOzWsYhedRRa+/JZubplIkpLxAHr?=
 =?us-ascii?Q?TNDbVF4QNqmbL+ESG74HxUhtGArcaA0S8yuR5XxNbcK56a0xqvB96uSz5PqN?=
 =?us-ascii?Q?hMh+uNdz8x26qQJwgsKu0r2yTbnQop0ZS7VZaA1XqIAWjmO4kKL1CXQ3Uma7?=
 =?us-ascii?Q?viYSO/2gJNiPxExCyRDxHEqp9dcCNqTUtEaWwTv7lCH16pjWEVMfpd6SzkBX?=
 =?us-ascii?Q?pi6Lh4WuM3Ryw+ko/4PEfgIcBrlK+PD8AfqzzFafbVEh2YvtW8QbZyHUYqbQ?=
 =?us-ascii?Q?53+L74xtymN5LY5PpAiYhITsLd0Vb1qJjkbHcgbmII0ClmgOdogv9lPoi51k?=
 =?us-ascii?Q?IldGB0Ri+ORk7nKRR0suILx8Gf/k+6BjtFXZ0lPXvHgwPiyr9HtOCoCVjjeU?=
 =?us-ascii?Q?dubnLvU9B5NTCpm2wDSnrMD1bUBHu28x9UphifNVHAXQQEhZ3k2A5KXbQsXc?=
 =?us-ascii?Q?PPFPTuYMF5b+Mf2JjeLQJuLFvJP6Hjieoih+kV0oaLUFwBQsIFbz60KSIeJV?=
 =?us-ascii?Q?cBGqvI45y8IzSOLSFtgnoHG2egy4rzDJ+mRotpmsB5Z2hi9yE+QQ8qq2wQfD?=
 =?us-ascii?Q?SmehHIejU/lBK9qQwofuz5sgZr8Lte+3EcDCLUVOQBMtI91i9/MIQ+MA9Xag?=
 =?us-ascii?Q?XX+3YZ1Rj8xDzh/OIGZk/rl4FN6irPKmbg1kCTGUReJ0m63bNwGDOKHY2ogg?=
 =?us-ascii?Q?RKfdX/ztbS3F7TRuOaCTT6smVeL+Nt0nbyHiqQ8Et7pcUhMYMyAPLv7q439g?=
 =?us-ascii?Q?TAjHqLH0r0mvNbQg09N/VIIZM6196buBtlS5sA6LqGAivIJajPetbjiLpdBd?=
 =?us-ascii?Q?H7LRMVgBo/eoww80fpK5hwmGmT/pmEKkS/8eVAGw?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12ab73c7-3af5-466e-4f64-08dc4969d32c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 05:43:25.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SH4Q77VQLZHYqoNlW+8ZOAJcUdI26apHXSA0W9c7UFlHKXnnnxmKgU9zdeDDCNiCr1J0VoONysSLcKjbhDzbQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8508
X-OriginatorOrg: intel.com

>+/* VMM can pass one 64bit auxiliary data to vcpu via RCX for guest BIOS. */
>+static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>+{
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+	unsigned long *tdvpx_pa = NULL;
>+	unsigned long tdvpr_pa;
>+	unsigned long va;
>+	int ret, i;
>+	u64 err;
>+
>+	if (is_td_vcpu_created(tdx))
>+		return -EINVAL;
>+
>+	/*
>+	 * vcpu_free method frees allocated pages.  Avoid partial setup so
>+	 * that the method can't handle it.
>+	 */
>+	va = __get_free_page(GFP_KERNEL_ACCOUNT);
>+	if (!va)
>+		return -ENOMEM;
>+	tdvpr_pa = __pa(va);
>+
>+	tdvpx_pa = kcalloc(tdx_info->nr_tdvpx_pages, sizeof(*tdx->tdvpx_pa),
>+			   GFP_KERNEL_ACCOUNT);
>+	if (!tdvpx_pa) {
>+		ret = -ENOMEM;
>+		goto free_tdvpr;
>+	}
>+	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
>+		va = __get_free_page(GFP_KERNEL_ACCOUNT);
>+		if (!va) {
>+			ret = -ENOMEM;
>+			goto free_tdvpx;
>+		}
>+		tdvpx_pa[i] = __pa(va);
>+	}
>+
>+	err = tdh_vp_create(kvm_tdx->tdr_pa, tdvpr_pa);
>+	if (KVM_BUG_ON(err, vcpu->kvm)) {
>+		ret = -EIO;
>+		pr_tdx_error(TDH_VP_CREATE, err, NULL);
>+		goto free_tdvpx;
>+	}
>+	tdx->tdvpr_pa = tdvpr_pa;
>+
>+	tdx->tdvpx_pa = tdvpx_pa;
>+	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {

Can you merge the for-loop above into this one? then ...

>+		err = tdh_vp_addcx(tdx->tdvpr_pa, tdvpx_pa[i]);
>+		if (KVM_BUG_ON(err, vcpu->kvm)) {
>+			pr_tdx_error(TDH_VP_ADDCX, err, NULL);

>+			for (; i < tdx_info->nr_tdvpx_pages; i++) {
>+				free_page((unsigned long)__va(tdvpx_pa[i]));
>+				tdvpx_pa[i] = 0;
>+			}

... no need to free remaining pages.

>+			/* vcpu_free method frees TDVPX and TDR donated to TDX */
>+			return -EIO;
>+		}
>+	}
>+
>+	err = tdh_vp_init(tdx->tdvpr_pa, vcpu_rcx);
>+	if (KVM_BUG_ON(err, vcpu->kvm)) {
>+		pr_tdx_error(TDH_VP_INIT, err, NULL);
>+		return -EIO;
>+	}
>+
>+	vcpu->arch.mp_state = KVM_MP_STATE_RUNNABLE;
>+	tdx->td_vcpu_created = true;
>+	return 0;
>+
>+free_tdvpx:
>+	for (i = 0; i < tdx_info->nr_tdvpx_pages; i++) {
>+		if (tdvpx_pa[i])
>+			free_page((unsigned long)__va(tdvpx_pa[i]));
>+		tdvpx_pa[i] = 0;
>+	}
>+	kfree(tdvpx_pa);
>+	tdx->tdvpx_pa = NULL;
>+free_tdvpr:
>+	if (tdvpr_pa)
>+		free_page((unsigned long)__va(tdvpr_pa));
>+	tdx->tdvpr_pa = 0;
>+
>+	return ret;
>+}
>+
>+int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
>+{
>+	struct msr_data apic_base_msr;
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>+	struct vcpu_tdx *tdx = to_tdx(vcpu);
>+	struct kvm_tdx_cmd cmd;
>+	int ret;
>+
>+	if (tdx->initialized)
>+		return -EINVAL;
>+
>+	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))

These checks look random e.g., I am not sure why is_td_created() isn't check here.

A few helper functions and boolean variables are added to track which stage the
TD or TD vCPU is in. e.g.,

is_hkid_assigned()
is_td_finalized()
is_td_created()
tdx->initialized
td_vcpu_created

Insteading of doing this, I am wondering if adding two state machines for
TD and TD vCPU would make the implementation clear and easy to extend.

>+		return -EINVAL;
>+
>+	if (copy_from_user(&cmd, argp, sizeof(cmd)))
>+		return -EFAULT;
>+
>+	if (cmd.error)
>+		return -EINVAL;
>+
>+	/* Currently only KVM_TDX_INTI_VCPU is defined for vcpu operation. */
>+	if (cmd.flags || cmd.id != KVM_TDX_INIT_VCPU)
>+		return -EINVAL;

Even though KVM_TD_INIT_VCPU is the only supported command, it is worthwhile to
use a switch-case statement. New commands can be added easily without the need
to refactor this function first.

>+
>+	/*
>+	 * As TDX requires X2APIC, set local apic mode to X2APIC.  User space
>+	 * VMM, e.g. qemu, is required to set CPUID[0x1].ecx.X2APIC=1 by
>+	 * KVM_SET_CPUID2.  Otherwise kvm_set_apic_base() will fail.
>+	 */
>+	apic_base_msr = (struct msr_data) {
>+		.host_initiated = true,
>+		.data = APIC_DEFAULT_PHYS_BASE | LAPIC_MODE_X2APIC |
>+		(kvm_vcpu_is_reset_bsp(vcpu) ? MSR_IA32_APICBASE_BSP : 0),
>+	};
>+	if (kvm_set_apic_base(vcpu, &apic_base_msr))
>+		return -EINVAL;

Exporting kvm_vcpu_is_reset_bsp() and kvm_set_apic_base() should be done
here (rather than in a previous patch).

>+
>+	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
>+	if (ret)
>+		return ret;
>+
>+	tdx->initialized = true;
>+	return 0;
>+}
>+

>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index c002761bb662..2bd4b7c8fa51 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -6274,6 +6274,12 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> 	case KVM_SET_DEVICE_ATTR:
> 		r = kvm_vcpu_ioctl_device_attr(vcpu, ioctl, argp);
> 		break;
>+	case KVM_MEMORY_ENCRYPT_OP:
>+		r = -ENOTTY;

Maybe -EINVAL is better. Because previously trying to call this on vCPU fd
failed with -EINVAL given ...

>+		if (!kvm_x86_ops.vcpu_mem_enc_ioctl)
>+			goto out;
>+		r = kvm_x86_ops.vcpu_mem_enc_ioctl(vcpu, argp);
>+		break;
> 	default:
> 		r = -EINVAL;

... this.

> 	}
>-- 
>2.25.1
>
>

