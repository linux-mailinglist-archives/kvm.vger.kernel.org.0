Return-Path: <kvm+bounces-59158-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C48DBACCE8
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 14:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CEDB1925422
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 12:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833BA2F9DAF;
	Tue, 30 Sep 2025 12:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bXGRUBgE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DA2F362B;
	Tue, 30 Sep 2025 12:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759235035; cv=fail; b=c5/lwJX1eZxSDesuW2XtBhPRNtd4eCWslvM1Y4MMdxcBCbPzz5eGnusp+3zapKRtOPLlwpzRJlp2z/n3fg4P4sjK0H6I3lpLMHiMq5jwSJeSwneR9B+iQQ/9qNEQnTV9fEpRbf3I0JCO73ABbmYcewbbKD9QcvMycjNzWbibdXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759235035; c=relaxed/simple;
	bh=DELjXSj4RePc+Y3YhjBo15FB1/EWDVekL+gElmWR2sI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z8n3e5V5kIIjNcZ2QyBTllRAQqM3kiOHSD9r+nFwA0ap5xWTOjeUu/eOwcmQ2FqXcPww2oDy6vskJu8r00oPHxOfbHgTzk6I6vLvbG7bB0mLQUNodg9TwSu8/3Bp02/T4gA1fTYkH8qgLcuRGxCdktLiW+5dRIWq+3MGxMj8sXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bXGRUBgE; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759235033; x=1790771033;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=DELjXSj4RePc+Y3YhjBo15FB1/EWDVekL+gElmWR2sI=;
  b=bXGRUBgE9Vhtn1wWf4uqv4zU7klg86jDhs98X/4jpv8Hs8/7CuA5NM+Y
   lR/yGyKtVsoy9wKKNMIBNmZlPj90IsmG7r2XURgS3ip4s+S6ChwkzEYtz
   04i79FXbcy0b4BWyQdfZC4RRJmBFDE9ypOxng4/8EZAY+uTFWTT27tR65
   2NLl/sQyeT4EZG2LHCG3JtDMcyZxtT9lhVEnd5Ub6ImDalHaFSzcq78DO
   divZbXOoqdcxpVqAi04OfpzoQ0/XETvR+85T+I+/ulSXthgLJQuqsq0iS
   Ca5UDwNg2/TX/xPawRbhOCP3hF1HgPypaQZNXzAiEuu9cY+NFquigTssC
   g==;
X-CSE-ConnectionGUID: zCABiHZaQGSqG9gFz/XCDQ==
X-CSE-MsgGUID: 4iV8YbhhSOWmGaPcoG6idw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65311197"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65311197"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 05:23:52 -0700
X-CSE-ConnectionGUID: XY1ISvWYSEC0ywRqSSL2zw==
X-CSE-MsgGUID: GqYZaxAVQHSHBCdy5JnKiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,304,1751266800"; 
   d="scan'208";a="178084526"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2025 05:23:52 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 05:23:52 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 30 Sep 2025 05:23:52 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.51) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 30 Sep 2025 05:23:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjXCubljbgmhmhy8FTVU2a/6WWWWaVb9Ptd/cZaTsFmp84BT1Xnf5wcOVPoXBUHzclU8g/dFZJVBM82OiAdP+IOiDS4CZGy2rdTikmrmI+ONvZts6BDZagOFClDD6EhoZ1kOTqqu+N48P4UZmgJxCe/1AZEqJRakThMcHQB0NrrStdno/3f8NXrPldNvb8lPK1X0n6bll9Nc03nZNvDTIbb3io/A0XX6jOEgZQ2QD/ZpRQ4n/P0S+D/5b1jrwS6e1ImNQRE4pK30dPkm7MLDpHXPEMYSv1b0Qup5552lRuqdzVYi9TDCoZR536rY1usIHJx353A+DdwYSja2+gidPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+piCpOD5pnDhlmfixNfc7fo6tF1GxjTtdfnmVb+IvDc=;
 b=AYxVQyptSpf+JdX0QXqeE85Kuc6YNWgE21PGQBTR392w5nAWyk0zEnqtypIjmTs/mu0CRppN5KppIdf0PL2qaXvFK3t+IrjTEj70Zskbu4VikWJPaKbk9g0EgKMWkMmt1OYE6iue2dFLCw41KTfWj/uk42wqzJwX+H0eoqLfQe+cVNeCDIRG6zW1cDTWjgFyAvYmQzhwByWpD3lmWskCLhgXxjUc8Sc60DyBdBsrScNi5UH9XDLIPPVb7gxM2qwr/7VPw7WcdxPprPfzA3+5kpL25ycbxBqql3C/f3LWEL3FsuWNxNcqPRFNWEs0brz9HhLvdKbZBFxN0S02feDfwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB4999.namprd11.prod.outlook.com (2603:10b6:510:37::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Tue, 30 Sep 2025 12:23:49 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 12:23:49 +0000
Date: Tue, 30 Sep 2025 20:22:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: x86: Drop "cache" from user return MSR setter that
 skips WRMSR
Message-ID: <aNvLkRZCZ1ckPhFa@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250919214259.1584273-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250919214259.1584273-1-seanjc@google.com>
X-ClientProxiedBy: KUZPR01CA0024.apcprd01.prod.exchangelabs.com
 (2603:1096:d10:26::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB4999:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f73fe4e-7aa6-4b85-03ee-08de001c356b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?8Qsw4ttOhZyDD/gq7SgyMw8m2UzBHJf6DOFTn4QxmgKpuHl7d+sUJdnQzzkb?=
 =?us-ascii?Q?lw0jn9oSQAlQEevWoghqFJ90ssih6P95+2Q31+IxIMoSoOvAruLHZX9CbBOV?=
 =?us-ascii?Q?jHl7NjobD5+N4/R1TAZhf3u8u7jbTlj6/KiuIxP1XGucsJyXnkVyunINp/VV?=
 =?us-ascii?Q?ItlkzvjJo0tWrda+Vkqmo5V+OrCp+zDp6F5YldGxTkmc2LBcC8mGNLoTJaku?=
 =?us-ascii?Q?xASHM7YgZzxAeST7WQO0iFx6HTuxb50084V1tD1xVo23HO2Svc45+c3jU5CM?=
 =?us-ascii?Q?tyeeYC7aUC2xzEhqitLgcr2L16w1zFAUS1STDZz1PUdQAG5cuLIv0iZdwTdy?=
 =?us-ascii?Q?OlPa4HdmuyBKVp13OzVusgifMhCkztGPBwhXSB67BWf+BMJh+bR+zLEYnuql?=
 =?us-ascii?Q?X25DlAFYT8KgcZ7K4MN3RJiRDla+nUXyyEQVOv+Vr6PwSHkCoVfh2LlpkoC+?=
 =?us-ascii?Q?ayvByfq/lHAwZgs9ZAuHDGAPpr4f0VMh8oOuKx28VokfyZrIagzimptXoxSM?=
 =?us-ascii?Q?UpnWa+4XvRxbCHinIA4PPrOk9P9g07PP4oo0Z/bKhkj7m++2jIg8FqalJZlB?=
 =?us-ascii?Q?EiGrh6rvwDukZTO7S+06PLMCLb5xuzx55/2caOSyvqfScEJiXWS9nGuFaQCF?=
 =?us-ascii?Q?pOhGhm4NQ/+JdKVwN2bYufiD2s/zJ6UEv8MVr1+AkK4WNNhzM+LidASdtmKj?=
 =?us-ascii?Q?jGiV/XBmP5KrsvoN3P1uXlCP6xSdtGLnto53jFG+a5a5+XAWTflQL2Um9RES?=
 =?us-ascii?Q?8NdIFHhuZEf/lCpYkGcjbuRDVXkoDxgzcpITUtPWVPQ0RrXnR39cZFaHvCbc?=
 =?us-ascii?Q?n6O0gQa71f4EkNwB8rxFLiQ5NadUI1ymKRuPP7WgJt7Te+uoXiD5DtqTvzV9?=
 =?us-ascii?Q?GoYUVAd13X3NnZz8E7+Udf6GZHdiYOXqknh3eFp9zG9hLvhiM6HJfBlikooS?=
 =?us-ascii?Q?ru+hjBl3PShuNNaJDCU3sF3besEk2US/sIuJ8ktY6Q0eh5JEaEmUobaBwqYf?=
 =?us-ascii?Q?XTWM285FxSPife1Zmxv6XDa0cqeZusx6xbkk0cb6wMLLF+QdoQZfQ1SDtmt3?=
 =?us-ascii?Q?Hv7K5mLIDNaGA+JvUEP8SGpmGcGeDMXfZ29YxqB0Z8VVVcMVdwaGUEohT8WI?=
 =?us-ascii?Q?Ytwdr9DKGtYm7nyVoVFuG5TlFz5kXLSU7adQIAGzL5o+A+E7VQq1YB8k4O3V?=
 =?us-ascii?Q?MqedSct/E9eJJamD1ljuf5CE+yvNuV/DLoKQ3dy/xlR3Nf+yI4gym2PS/Etr?=
 =?us-ascii?Q?OrBkm3C74clfxx8LBpYk8e5E93ZspqOP5r1RHh3shMNE4ZJH1JfSWqPpicy5?=
 =?us-ascii?Q?wKk1PwWoUH70IP9dP8SJ4Brc5/cPZ3xyVb4WfguodEsX6H90iSMLrISGn6qI?=
 =?us-ascii?Q?OJ9uSOzxeTVmHdZKX0XiJHS1sc0O0/cg4AzUi8SJaPwQbDkaikKoH66QYSin?=
 =?us-ascii?Q?PkqbGlHK6rP1jv5UgIueqHablNltWdHDaYF0/gM0PIZivDgxLW82VA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iMUCqzq0UGZbuYvif1POXy5aAo5XLeyvnD4y6I8GHgElgQ03TIdo/EKbKhXx?=
 =?us-ascii?Q?kEKckz8+ulipn1ppWS2nrff91mfNTwonLE376brm4VCE/KyGD46LmarWqJep?=
 =?us-ascii?Q?uSErhsHaRpz2x0zDPA4te4SXSU9WjrZ57nWBmp4Ava+Mm2GDWDYNIfv6Xoqh?=
 =?us-ascii?Q?YgEMzANBxV4pGO0G6KI8QGHSex9Him+pki4Rs8ReEbe4P8RC+scdT+juCMKX?=
 =?us-ascii?Q?yWQpmLcijxTlHdQPoRqhTQbn8WzPrFOTGO8Dxjl/FDzBM0c5oHJ7XQ8VHP+H?=
 =?us-ascii?Q?18aM+7zD9hTU9nE2VlZ9q6p/JU+CtOmtGsis9EVYk403P5kqWzSH6wzGeaa0?=
 =?us-ascii?Q?NnG78l6yu85b6tgGo27Vu2rHbawtEY3qEakV4JJLgAJdnDI1GFy15EXjvaLE?=
 =?us-ascii?Q?yS4lIEEWfonyT7+4tvoVQRxQBN/2n7xtUqzMh+s9pezOMivxUImQYvre+Ivo?=
 =?us-ascii?Q?6tnkKmGN8PU2y9LUja+FtPJnyUYIYcXbHLl1UFMtKAiVA5Un0EODwsu5DmSq?=
 =?us-ascii?Q?I7geEevVJzi3Gag1/hXvZz/bmWBxy9vjSSyqrKx2WYBImWjmogcib0BMN+Ln?=
 =?us-ascii?Q?ZitJE6oa15pkQHFmsZiS1D2/TQLtXclNTaGddQmyQlKYt7+am6EoIRDyUVLy?=
 =?us-ascii?Q?GVYkqTjZJiIprrTmoNJJQM4BmD3DZnBu5DRBCxb5Wqgh+B3YSc53U6El6zul?=
 =?us-ascii?Q?7A4yuQI+5JFNSY16DuOIaXCgHBXBypOmpDKjz/zXjCU4HE6z8AmkLpLg4ZFn?=
 =?us-ascii?Q?RvAKIIvCQ7cv2eemSrvN3o3dZnCgaUn1nXWyN8aMDab8b+KFdclDyoOvyFEL?=
 =?us-ascii?Q?IpWn7r/S6VFEOsYTiXVitIy8XpNhLByvBM2j36mN3YB9pRsnSNjlSrWKC7RV?=
 =?us-ascii?Q?j+tUJcbDPwOp91IedIPMlDVNGO2EUZ4qZJGO6dkP40GCGvEQraW99pZfRFuo?=
 =?us-ascii?Q?Y7nD0VvPsZnDWelgvmqYTVHLYXxh5pYN3Y3CLzme/6oRgQnsmmOgMal9GFPZ?=
 =?us-ascii?Q?AwWUQ47QYpH8MWbZT0efl+L7SOhyMRu74CmcXnrd3WOG2DFRGocQ24Edta1A?=
 =?us-ascii?Q?Hlzi4yCfr/V5Dg0BI6VQ5ybJkLFt5MBCisGhyciYn4YFECXQaP77tR+ZrYaI?=
 =?us-ascii?Q?FheO78++ynKRoZ9E5j1t0b9rvJocEOUwg6CfloTdhsNIBHqSDKmwydKIPEr4?=
 =?us-ascii?Q?RunSkz/bp19Bkdj0+H4sk/eqLHXXUt05ZCGGi0YY9B9OSEHlZAzGRqLVFIPl?=
 =?us-ascii?Q?9lKtHxbzBwC1WzfIQwqD+C9Fr9aRq8ZVlKxKZumKWF/mGg4lshS957MZQUUA?=
 =?us-ascii?Q?X+mnYYdbiQakCK/BY8pYsciqff1/vcNWoJipo+KyLOR8loQ7quIq4FcceT+3?=
 =?us-ascii?Q?6DxOV9VWdyOfRpEnyBLG5H5cKFkEyGYbqlSwzCAFytpylmo8bhLYnf4ScrjK?=
 =?us-ascii?Q?e8x/G6Ru41ipPecpsF8rPrIgQFt5tT8xz7CJeWpzwaNgWFKj306BdccL6dmw?=
 =?us-ascii?Q?09/uY0GaPGBdWK/X02Wb7dRDaa15ppkyPXSIHbxc5T8uTX7+K8g++GdJdhq5?=
 =?us-ascii?Q?Ef083qEksvCwGi6P9vxhulbSbBCyOwVXnuXg869O?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f73fe4e-7aa6-4b85-03ee-08de001c356b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 12:23:49.1653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nATM60iE/+MkSid+Tvp/DtF77tpr2R6XGZnxWtFVfyKnw5RvEmOU2FrWUsKxkSVlOlmPSD++raxRpVAKINEFNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4999
X-OriginatorOrg: intel.com

On Fri, Sep 19, 2025 at 02:42:59PM -0700, Sean Christopherson wrote:
> Rename kvm_user_return_msr_update_cache() to __kvm_set_user_return_msr()
> and use the helper kvm_set_user_return_msr() to make it obvious that the
> double-underscores version is doing a subset of the work of the "full"
> setter.
> 
> While the function does indeed update a cache, the nomenclature becomes
> slightly misleading when adding a getter[1], as the current value isn't
> _just_ the cached value, it's also the value that's currently loaded in
> hardware.
Nit:

For TDX, "it's also the value that's currently loaded in hardware" is not true.

> Opportunistically rename "index" to "slot" in the prototypes.  The user-
> return APIs deliberately use "slot" to try and make it more obvious that
> they take the slot within the array, not the index of the MSR.
> 
> No functional change intended.

Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

> Cc: Yan Zhao <yan.y.zhao@intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Link: https://lore.kernel.org/all/aM2EvzLLmBi5-iQ5@google.com [1]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

