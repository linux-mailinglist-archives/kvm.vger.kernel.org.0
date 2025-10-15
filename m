Return-Path: <kvm+bounces-60050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE3EBDBF7D
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 03:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 766A04F1CF4
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:14:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20E0F2F7478;
	Wed, 15 Oct 2025 01:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Yq4RO98l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7132EFD95;
	Wed, 15 Oct 2025 01:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760490854; cv=fail; b=hx7IYNS/SuXy2WYYwspDxmE/rxRqiPvAT4+ieA6g/s3dFu5wmVKGo8Mab+jGiZ+wSFKFDIY+VtbI+mW1TXwEpF2On2HsEhO5AQaNVLCC/YVyWmIOU1GEwDhL8r+KFHtZmfXV4Mv6qr9lpK80QZEh8/fakDTgB9nrU/i2hVsAnv4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760490854; c=relaxed/simple;
	bh=vPNJlBatgsyUDEUzB47OI4bhZ0sL7AE1+6IZTecChKs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WMLZIQRi3XsFMJKVfmzhgCN5/Yy78Jl6tbd9gtzGkcuhHb4nUpO52jqDm13Z82myoTfo1Al/kHtzlaHIZYhCUaCycFe5z0UmC1MrODVDYnmNCHEVddDonxk1R5wWtztbDRiVoOy/Qvw5LohgXtWpAItV9IIkrA398J7ucN32nPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Yq4RO98l; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760490852; x=1792026852;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=vPNJlBatgsyUDEUzB47OI4bhZ0sL7AE1+6IZTecChKs=;
  b=Yq4RO98lHsXrxn7sOJWNvOA0kag9jXR8bDVFjcU2sVQwPvxZbjig2Riy
   O+RNe8T2RpVBd3gHg48G1vcNAasawOK1rBRj6+bkpQy/wUVmQj6pMuXBF
   rmro/tsTxIxAbVOrjA7sy5+il3sOiorZ9xvrawq3ribg1lGRPVV8gXbTt
   CxWTZdj3z6SQN9pDEsPrqWVWPLu9+OphktYnywFanN9ux800QS75rdWTb
   W42/xaIgZgT5WmRkcSUjf2TjB+cXx4MQrr08oDeIE0ainF/pgqhAvQGkz
   PFl4pPx+DmlwIGRxdm8iXdj71c8/jY8zWIV0irPm5A9wGz03yBo3Wd6ap
   g==;
X-CSE-ConnectionGUID: ZlA/ja4zQJiAtb5hQVjKjw==
X-CSE-MsgGUID: MNnlGbnqTVii/CFwNakdeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="74001261"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="74001261"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:14:02 -0700
X-CSE-ConnectionGUID: pFCYNawQSqalUHgHlKRtnQ==
X-CSE-MsgGUID: h8raRZwzQRiu0p0Dtk9ANw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="182812003"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 18:14:02 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:14:01 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 18:14:01 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.69) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 18:14:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ENAfgPDKdKI+zSwPz0tUmZRokIz3QgwdpWApC49eLsTYcNAQCk/oyLQQzrD7Qn5wVho+1zdXK84kPknm4ae9mGgbp/k4FgT3AJ0D+bNEV8PaDCvjtIaR95A0va0TQwaYr0gtSKXJl1bwZ1C0HjeAM3JGtSp5HmJ3wx50qEfC+Ne9ANQtivPIYV5BgAHjPMYQArfFTA+VSQvS8MM0mZELaVDJu3Hq6sC367RaVBonFOLwNJC1RiOE2ujXZe1g1SAS944+9+R7yaCuRTJtsMJTBUo/bAnIILecYUKldznGPTzYtx5KcRY7iUokm5v+BKHwKiVpor1IT4n+eXzYgbHW4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bvWuirNvGk1nIXogHZ6opKOXClFsLIcSF9aoOM7IE7A=;
 b=B+10aPsrvYeJU3Z+XI4c0Fk/+2iRIxi3/M5Fx0EJ0VvYZx6pSGsw/kQYsPiBF4htL2F5tJKJAQX2+soUmPIEMerWqMGEB9wSTd5YQPE9/hql2153qLXJU0rtBVPQ1U5MaGSw+aQen3GrclWVdnSjyBDOdxCQhVwZH9kcctV/92MEZCbG1I1IQVaIpq+owkYXoNkgnkxkT9uxoWVMRMLhhLr0P2QiY/ux+0potST5RYNLxwmchyoHu8VW//8oFWS6rqnfuwYJDh51cVTaYpQjdoaTzlcpiDUauhoWrTTu0yHm5fMqGBTWM/Ha309kSKuCvhzaRohMsPzciUzga2EgGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB6925.namprd11.prod.outlook.com (2603:10b6:510:227::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.11; Wed, 15 Oct
 2025 01:13:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%7]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 01:13:59 +0000
Date: Wed, 15 Oct 2025 09:13:49 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kai Huang <kai.huang@intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL
 or TDCALL
Message-ID: <aO71TX//mL3QOV3T@intel.com>
References: <20251014231042.1399849-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251014231042.1399849-1-seanjc@google.com>
X-ClientProxiedBy: KU2P306CA0079.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3a::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB6925:EE_
X-MS-Office365-Filtering-Correlation-Id: 1206408c-6c0e-40de-d72b-08de0b881e87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eZc5e8oEQzd++kj/AFIUbHmseFDbPlXkGQtR9oZFE244eH+ErUQmo38U9fgA?=
 =?us-ascii?Q?zuUrGeztSuREjxLo9hm3Qx1ST8rdsZmNWflo1vm6zOKyJMb9/V+Nt5wIEsua?=
 =?us-ascii?Q?1D0w5HzrQxg+RK8TSzzuAx//r84JKzEK/H+OsQI2OqXdRv4XPav8hp3/2WuE?=
 =?us-ascii?Q?yXBl4K3ywa1zi5sm5VzgZSOO2lKcc9ixL8RlVPF8EgW5NikImEnfqz1EvJff?=
 =?us-ascii?Q?XXP3xQ4Kouoaih605H+uHHkOtpvvOloPZ6xkqy4Kdi9R7YdXWeYEDOv9UZ6m?=
 =?us-ascii?Q?th6FD/nSbKHpXQdn4brCZtdaFgOBEHbNRjNT6qkTVYBnR8USFPfQlZr4SPiA?=
 =?us-ascii?Q?O900yhMrAsBsFGoXPEtLHSEdryouSZYHwQvCu+0rWRHyYU0w5D4k5muUy5pw?=
 =?us-ascii?Q?cbYhn86gIMW02e+fdI6c+9/xWWK09ppNwALluDy1rMFoG5GUHFCjVv/QWb4b?=
 =?us-ascii?Q?XWbpPKHAk++p1Uq2iQayXwbCdd+8KD2wEfiuB1AaF+exp31w0eWdNvk3bwQA?=
 =?us-ascii?Q?i4hmJh0Owd5qtXjr9fKTS9zVvcz0eabx4ZCLx9AMKGJ0bxKuKGvJhNHbNb6+?=
 =?us-ascii?Q?ZT/Rhi6GSubaDxJsM5DQKfFnfP41i0l1TuCnBw/lIODTiKvwJdrparmVobpO?=
 =?us-ascii?Q?NuVPcpQEsw/zA3bXFAk6epEi3EVoRq0dvk4Qkqgwc7qj4+7dT7C9wv14H3VU?=
 =?us-ascii?Q?qObI5HlJKXPGjAf5mnfjf3eXgv+FLNeqv+9rKo34d+geAIapProvquFZQkBH?=
 =?us-ascii?Q?LNJnEaXxpdeNmI+9eM2WA1L8ZOZ8ZgYhlAeb5lzfTkv4ty51IKaJQsOfDfM3?=
 =?us-ascii?Q?A/+9YoXZkKk5nz6CoJWIj/tOFCvdypRfS2v/JVKAbRfEnSlleB/T61AxDb6b?=
 =?us-ascii?Q?UNsZF7ytw46nArWS7uDHLMOlxhqPTssf0XJ3jx2IadWxzJN7ObvA0g4YaqC7?=
 =?us-ascii?Q?0l4Fyba1obaQKDtcbj43VyHzWetrfE4trdMtT1I9JlEKnUAjKk7trB2Z1U0w?=
 =?us-ascii?Q?m3aXNb0GKLslYaFoBov/WmuqtDn4tfUo0T4b8IPpLa0DLQPCPwSOELEmaxIe?=
 =?us-ascii?Q?Q2/ltSkkawLG7I+naqLrTC7vb1/qTXh6yygelzuZ8L2my4SyYXMo8Y5ZHMBz?=
 =?us-ascii?Q?zKSaD11N7JVC8SZI1lpUdCWrq6cP3D5vL2ofy8F+R374JNWTfX04IWQMt6ug?=
 =?us-ascii?Q?46RG0ROs0OWhlK9RukKbrCdRQu3hgGcolf8uhTpmKYCeODKJvZbL9OejVgsf?=
 =?us-ascii?Q?jOam2D1mlB2g90B84ElNBr+DCSHNVoWZmDWznJCP/g6kHaO/fXG5Dfd5Jdeb?=
 =?us-ascii?Q?EEKu1+ZXMQFAvLhjCiMV8KxRjl6RWWwWbKZXjtVYaIlBaDtCKCN4vJ6xtc1l?=
 =?us-ascii?Q?0/EdHN/0rD25mtohUiNU32tsZjq2i8yzUhPBCXG1mP1r3qB0EBgJgWrUERRW?=
 =?us-ascii?Q?UEus94iW7jyHjYL2lhFIGuHIjhO+MOkF?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?++7JFVccias61Z1xuCenTbpwKv3eN9AFGFYIaTBG+k1PIU/BfIxVQTeMJImq?=
 =?us-ascii?Q?rBzZqaueoLTDSCACz/tzNKh9aF/G6K0FQeWFEw6bIEOGBrEMZOSA8kGIwuSE?=
 =?us-ascii?Q?YuDmXeDl5pT719lJ8Qhk3u2fyXNjN1UOJ/0HpkY8deqhYFA4m+0+otwayY1C?=
 =?us-ascii?Q?VPFQKl5i67kcfW98blsJAJ01plEV7kJvKL+7sMnqJcOGbfELm5lx44SAFzVe?=
 =?us-ascii?Q?YITTCb64I8cRlvG81HfY4GjeKOGCZARhA3DOXdYNKGdG5Iwdp+kS+YjwdMgk?=
 =?us-ascii?Q?F8/xvCbn6Wtxl5NfuyQkYJ1EeTKzjkMTYMmhJOi0nXv/lALDFzlTIJwvmuy4?=
 =?us-ascii?Q?FOOdMj7ajJbzRN6Xa1opqGGol/lknJN1X2E19dSv3D3Lh+3g/GxMpzVQar88?=
 =?us-ascii?Q?3POocIXrGnQ4+xYGi14YlWqmU+iCuNAtYxQS5ZJKL1bmL8JgTwry3EYhQWWC?=
 =?us-ascii?Q?vVzFd/Bjf27tB/rVprNAoXa7ybHztO8ZVy81GFLmbnXR/MtkXmTfI0qYXZJU?=
 =?us-ascii?Q?fG7NJj42zouaJZLEmQVbtGJF+In67bjb1sa+5eFxh4PbVa+FfNgUDpJGafQV?=
 =?us-ascii?Q?IY0nKIQ+IN5SCWTMDsZ5dVFI+5zgAtzp4AhJv+pln8seS/gmi0gS312R4msZ?=
 =?us-ascii?Q?6kbuxE9jS6RlzmMDlmF9X3/qx9TwxsI7KywHygvLonasM2EL+lCLKiSJR3TA?=
 =?us-ascii?Q?QH2Jegx5YTw8GT3D7OpLSqnU9mfEKe6MWW8dYVYiyLA27gIgQqQdZ6Thau3Q?=
 =?us-ascii?Q?shXRTyMwshLzSvEt5f+tFQb7TW05gJ+h9CksLIRYLVwAk1jvDDBvLG2CW9zN?=
 =?us-ascii?Q?X8O9GI2g4QGjbJdhCmpChi02mrIroFMoNLibYTuM8IWBdp60yXkWSS7Y1duR?=
 =?us-ascii?Q?jkoGgVMDnsOnH7Lv3cwxE5kvNO6f0eMeqxfdhZQthb76oUzLQkIj8vXp0XI5?=
 =?us-ascii?Q?Wgb5qt03sI5JXxOZ2rCkScbCwYVYjruOgEvGx8NkdXPJh1J0kSXRXeukd47u?=
 =?us-ascii?Q?iMkefL6XFwIvUEmD4vv3T1UcfVpo9RienTH8D13dKg1Uh1S3aEqEqLcOMYpd?=
 =?us-ascii?Q?LY5JYwQbRUvGUgJLTj7tiIOx35vrjZW0Hpy3uP660sjy+ZxRLXov6rEqd2qC?=
 =?us-ascii?Q?Fujnb9rd5IryeYEXXVKzFvLPI5NxG2Y+ZTAAVTfgujwCf701j4m0cEDd/2Wi?=
 =?us-ascii?Q?0YO/5U+xu+0PezeN93/TDaemTLky531JtB/vxgm2DGNChqmrL78aobsUcSOU?=
 =?us-ascii?Q?fb9SRHxjxErNXsYP13BOgZx5l4NRobd4gbZvhDWhTgpGUVhL9p0JMEnAKdBz?=
 =?us-ascii?Q?juMmVqmuJzSmTh+43RejE8Bc7kIvXI3Ntdxg110a3eOPNlerN/S9Y+26HP1l?=
 =?us-ascii?Q?9EBzQf9OUygR2+mS5WIr/JSlySnebazh1edUcYsr5WVCrefrxrqgMPj+i2p4?=
 =?us-ascii?Q?jsc6BhIB+q6fOjHgUDVMVNLbu0/D7f4WyOAIP2VekbYAl/8IPki7BdFKoBr2?=
 =?us-ascii?Q?Dqn/O0dVtUkI6CUXAZLRK2qw8J2MKT50ZGc++ufQKx6OHgnGCFVDU5A1fpwo?=
 =?us-ascii?Q?0h1IrtQk8n5d4jlOF6lN4tgrJ736c9mZtZ4i3R50?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1206408c-6c0e-40de-d72b-08de0b881e87
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 01:13:59.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AjBKxbtyfnzCn58ISENk/zYJBj8iq+gRXITOUjUIjYDaziRBYymHINGCGT5JDy/5Kq5id5WeWClzv+NWdKpz6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6925
X-OriginatorOrg: intel.com

>--- a/arch/x86/kvm/vmx/nested.c
>+++ b/arch/x86/kvm/vmx/nested.c
>@@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu *vcpu,
> 	case EXIT_REASON_NOTIFY:
> 		/* Notify VM exit is not exposed to L1 */
> 		return false;
>+	case EXIT_REASON_SEAMCALL:
>+	case EXIT_REASON_TDCALL:
>+		/*
>+		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
>+		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
>+		 * never want or expect such an exit.
>+		 */
>+		return true;
> 	default:
> 		return true;
> 	}
>diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>index 097304bf1e1d..7326c68f9909 100644
>--- a/arch/x86/kvm/vmx/tdx.c
>+++ b/arch/x86/kvm/vmx/tdx.c
>@@ -2127,6 +2127,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> 		return tdx_emulate_mmio(vcpu);
> 	case EXIT_REASON_EPT_VIOLATION:
> 		return tdx_handle_ept_violation(vcpu);
>+	case EXIT_REASON_SEAMCALL:
>+		kvm_queue_exception(vcpu, UD_VECTOR);

Emm, the host cannot inject exceptions to TDX guests. Right?

