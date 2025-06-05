Return-Path: <kvm+bounces-48496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33B0FACEBAB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 10:19:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E332217527D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 08:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3643205ABA;
	Thu,  5 Jun 2025 08:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DN8m/cFX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC9C1DF982;
	Thu,  5 Jun 2025 08:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749111584; cv=fail; b=qsO1d8RTa8dJcxMoHf9FzxPIt2Mu2Uou/gdMcnvlqXgBiQ0aG/kDP/RP6iQIk+idv+K2xKQkG0jliQShsMaFiRiHDXWihhvqgeq5DFY5yD44vzG/1aMdIPlm8XERjLTvE4bFmb9HtkbopPVqUcdQ1WqE9oO0SzqErP3IMKgpbaA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749111584; c=relaxed/simple;
	bh=DTKFnlWPoKz55PH1ZcrZBBw6wceOyOf+H6WVDL+aFA0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m96yFiGnQ/SGtG4+LWlgAghv4mQOdEKPt78Vs58UONhPsn1er9Mslqrie1fHXUt+bW9CjA24+VqzC9N9irAYG53ODZKXaNowCjs9ArStYpMcLISlaK9o75JeIBwbNj4ebwp1DTl1U9yvvH5CGPoE9xXD/2x+XQ5FRKomFKZTBN8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DN8m/cFX; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749111584; x=1780647584;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=DTKFnlWPoKz55PH1ZcrZBBw6wceOyOf+H6WVDL+aFA0=;
  b=DN8m/cFXkAuMsf2nYYkY3b0bZ0QlK9b/O3cJMEH574KFjnALihcHivwo
   aofyX92g1N7oK2ohNCEYzXHgz+ErkotiIPvZyMeJ9nEDFKCHtzPHzrwgb
   L94J6jnwDufvQ4hWKJ9G1boMtAr0QNZa0+gECJjJrDfP6VUAvIob1aZHi
   Y8mYwu32Pk9l3s44ERAx77yWoiB42Fetg/sa7mVvyte44t/Gv/puSh3Yt
   /3+X1NZSsfTPXVpRAmiv9FNnaHimgD4HKKWlu2kSboKt7WOo6/2YviGHZ
   q+Otduny8eScLggCuPjJfBHAT4gX1bYW0e1M8gyPrO823g/CcLKp1uR9s
   A==;
X-CSE-ConnectionGUID: KitZklgBQ/K4qtoeFox1NA==
X-CSE-MsgGUID: x56iRBTPR2GDBGqnA5HhmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="51365859"
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="51365859"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:19:43 -0700
X-CSE-ConnectionGUID: DEgnnmZNQcGHXzbKrkkWbA==
X-CSE-MsgGUID: k6ob3kLhR+aXvcq7KCAkHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,211,1744095600"; 
   d="scan'208";a="176390820"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2025 01:19:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Jun 2025 01:19:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 5 Jun 2025 01:19:42 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.58) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 5 Jun 2025 01:19:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IaizIo8BZtVoCW1wIbFL61voybCAZQLoeCXrxHyELX9wOhPEi/vg6bsd3wBJWLltLMdQhqU6JkU+u6t1xcnoyDaP/vvGc1tHAx3htGVtT8xZRpqdloBN5ydLnkHoUpFEM82/hSBRYQrwFntxa7JrOmXDv182X7vrphl4QQmBUUHAuKFckq2Rl9cKh2oz2FBAfI59NyuEkEBXedTo1EAD3Ge1KsK8EvYRA/G+p/QFcvNmh+PeMkcJFn6/zRWd6OAUR1XU6p5yfVPTcyuWGnXospqf32LyBaCJ+smkUQ6XOrD0DGSY6q1m0cTrLGnuV/lfOKghqeiZxQ43FduH2oAPUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g51A+Ch/BTplaj+N/sMprxItWfB5TVqPmXGuIQoS9a4=;
 b=p/3ha5MwKv6tWt2eeatjOnSiezTvXLXw5XhOADnNJDm1kE8vBuXoFAu7C4UNl5PFlYpcbgnNvTSGTM6uOEzlE1G4N0a7K3dzvrR0kg30dIovcBYGJv2heW26NmwmbvGDyRsLj0FdAuGGsFFwpF5GVwMqECSjjuT5EziVUntor3gq5Hdzvom3wzWBB89X/pwFl3tywH/DVFT1EgKPEFNM5Ceu/+4QI4n9cL5sf9oXI0hRLbP6WHnja7USkqOwrPornYusTZexZkmecEWDvrifNJYEfyn0omZJILzpXPt7cUvgpHZz5R+/NynXhmjMfEgdQyNWdW+h5ksPKq/ymLI9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6516.namprd11.prod.outlook.com (2603:10b6:208:3a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Thu, 5 Jun
 2025 08:19:40 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8769.031; Thu, 5 Jun 2025
 08:19:40 +0000
Date: Thu, 5 Jun 2025 16:19:31 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Xin Li
	<xin@zytor.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 12/28] KVM: SVM: Implement and adopt VMX style MSR
 intercepts APIs
Message-ID: <aEFTE1oZ/zvzXiTT@intel.com>
References: <20250529234013.3826933-1-seanjc@google.com>
 <20250529234013.3826933-13-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250529234013.3826933-13-seanjc@google.com>
X-ClientProxiedBy: KL1PR01CA0089.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::29) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6516:EE_
X-MS-Office365-Filtering-Correlation-Id: 08b64598-3503-438f-9313-08dda409b7c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?VPhkZqQDiTAZK3t/W8RwxZyTTu2nt/DD+YR1X4aly7MkKIId3QKIkMts0m6G?=
 =?us-ascii?Q?93eNVwKs0ksrvARpZHeZpBXhDRDrjcONOmehv2Sa+hByfMlGrJ5Kw8tuV3qg?=
 =?us-ascii?Q?gWXa8DVLcJEXnD5oF5X0rQm8WgrY6nqdsEQjAMgElHKyQ/9nfn3/eRJZe1Sr?=
 =?us-ascii?Q?SY7YOANzH0jVxJ0SJGPB7xwxHKrgkOp9k+ncKXRevOYQLztXS0NhXM/nPdnP?=
 =?us-ascii?Q?W0pPGrHyYTPJzRxv0eKw3T7tUeqBBSufbFD/+9HPXI6cKKWHog8onODGNOYs?=
 =?us-ascii?Q?kA4jPEE0GWkN0SX1zAOIqsDQprzWJ6/ShbCAnyP6PvenPGBexyrm/QdCy8M6?=
 =?us-ascii?Q?j3FH6N+HveMAfdpJOoROck2YfCsS1XTt5IKuiWpJylYH/XJzMCZ8FsVXsdkq?=
 =?us-ascii?Q?MdAjOlmr4a+IJeij3h8hjyk3pdpAXydubKJ4CgZXFGW+EeisaEtdZmvGP7sY?=
 =?us-ascii?Q?82rRBjT7wZY6nLThqSra4qYgvIm0d96puJMzlJULWk/3HlnC8VKQRbCuCZy2?=
 =?us-ascii?Q?9iEpQsfi2hlHkaExKaWQyYDRM3+iIvlOWa49XyT3zrcBIUOGvytt4PPdwGdj?=
 =?us-ascii?Q?fNcX6QveHug8s0c1ZF9Unm/qfBd/bOk1adI1xv7ZhsdY159mHzGACC/iC3Fw?=
 =?us-ascii?Q?ZBWuDZ7IiDeTAVOyOYxYJst00GOxSC8utImdZY26ennC2w3mRkUOs8yWr5E9?=
 =?us-ascii?Q?vlLSkscPP3MZSOvZaLw7tB7kTOjRU6xNDVWEfqAfS50Ki+iHX7q6KjIYyzAs?=
 =?us-ascii?Q?kOsHTf/j1er6TFUGevG3O0Yc5OTYzZ4jVxxjOCfxQEkjtA1cPMFjcf+ipxUE?=
 =?us-ascii?Q?2B9n5nYDMz1xXqzII6HAtbEmqGsnEqeOnj0rCz9w7z7mD0vs9vqANtRq/48I?=
 =?us-ascii?Q?lJY1WlyZddRhbQz4tyQdPQ0sjqurLYlV0pu3XaAsjZVzJqeothaHKFrkJX1n?=
 =?us-ascii?Q?bxALmlrpCi/cLsRqARaLM/D78vXcnerWIb/5Bkd5EaGBL7bRxQ9IyGfbfSmf?=
 =?us-ascii?Q?yTvmvAQkmop79RK3uhFaa3CXQxfHP9yInlk3Mn6rgLiTMHjTg+4ro+58XbGS?=
 =?us-ascii?Q?quILpp05jgJ8CEnHL7BMx/naYAnDVHVV65qyeV1GUhD9Wdd9chkGkOmdTOlz?=
 =?us-ascii?Q?od8Wx6NZJ8ybslokMje0+ZMHd8cIJIJm734fR204a0FOhwNJzaJBZCiBnH6q?=
 =?us-ascii?Q?3FFgB0MiVfAZ6T/TQUpBAqzJRRC2bkP9ZyhaUqOyKCFhqY/wzKhpgYgN5u8W?=
 =?us-ascii?Q?eiyyQfQ04hIX7ykPvEtAbakvfE5QRxntVxaORBXIy4ATUFnD0NWuR9phF8At?=
 =?us-ascii?Q?PxGNwcx+4kslgkmSQb/RWtcimWWQ8tXqlAsatvB486Bjk7tGh+vSbkNq6LBG?=
 =?us-ascii?Q?mUSdP47PSKmupn2ZEu6H5cql8NPw42wZqP8pR5IrfogTv1g+jGRNzMGfRyHz?=
 =?us-ascii?Q?i67Ig++nHF0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FHN+ALObR17KkNBqgxfY98dpxlQHAlrI49jqAtpnBHJGeaGBesUfoU0TEAYn?=
 =?us-ascii?Q?spbbEA7kDpMrradg+HYKIltbhs1FxCQ8T/a4z3Q0oq8M6LwhgAZP03Y3yqim?=
 =?us-ascii?Q?DGoyNUVr0SFu3mI1HjLpRw2bEz75cL5j5bkTz3nIzJYewV15T1TMnJNeSaBN?=
 =?us-ascii?Q?41oHsrDpuHcXLirRA45NyGsp9wCgCBwfDwAZiMDTAm4Uk1VhGeOzAuU2XaRN?=
 =?us-ascii?Q?7xSzxRb701DCfHYxOoMK0KLsn8Bv6N4Nk/PlTKSSsewCYix37tVkz7DFTBUS?=
 =?us-ascii?Q?KRUOiHk9052QqVrQA3mSVpaICPQLF2m0dMrE3voU2KGcI+hFz62De6q9fuaY?=
 =?us-ascii?Q?RPaNyQxavAq42KTc/U5zZRvRPXxN7321qfluCtG8n9Zbpni6Ua5OyxaWmoXW?=
 =?us-ascii?Q?XTf7pcdQll78eQRQjBD2xFsn6ZWo3P5JWJwSH/FNdcROn9CiIA8AHNh5DTt1?=
 =?us-ascii?Q?BKZTA2SF2+fiu5a4BIpXXDtX5jHCyvfaWsRazg6WAZCg+rG7HMLCvXs19zD+?=
 =?us-ascii?Q?4aWD7328EFNS1m98pUoCvZQXWxT03ozM08EdvaZJCZw4BF6V/MSiJMNSilZK?=
 =?us-ascii?Q?Qe0ZD+uktsC7EIoJLN1lsfqKePX+QHCallIbdHtxWYOm9lTX60B2xVJ+Cu2h?=
 =?us-ascii?Q?fIlKInSGRByLb7lnQhS/42jGfzIfc/ZWgsrUSptCyGk8UzSkuy49Kmq8Fru6?=
 =?us-ascii?Q?T13fueeB/6hemeCAfXD0ujdzzW6gMi7Um0lLewQa2+VUNW0EGRTvuitPS6ne?=
 =?us-ascii?Q?co6M7sICbsPEUUzPm9xZpLV2VTXpQeZ7dZzq8f/gBKniKSffsLSu4OlXLca2?=
 =?us-ascii?Q?zRUg5KW4EQeVndckyamLS+rGitlwD1BXEBUF0gal62tnfBOkeDTxrmeVkWIi?=
 =?us-ascii?Q?gTPIjcPnxFO3KpQ1z0ZKgzKnrHnhKaWgfaH2d86iLn8KyRERRpE3HTpRp6i5?=
 =?us-ascii?Q?c19S35po1Ukf1a4j+i3AVOVkbTBe8QSuRE5VzyM9Q4LNVKbTQERur9aBpbZe?=
 =?us-ascii?Q?JmRYsqeHtv9FdJN39HaXSmwYTr9QN6x1qTK8E60E3vFKZvHquYkj60q65cJ3?=
 =?us-ascii?Q?5CCH75IWfT2csbhVQOEdxUY9QDQ1bhBF9gNNc7dIZx6nf2Kcu/CgppSmqtaN?=
 =?us-ascii?Q?Ho8LgshP23qUJ/6yA0lXxTzGEJsJTctetCkWeL2IG2NmMWrrk1A4GKnU6tdV?=
 =?us-ascii?Q?VLHR2T5ud2t2IApOS3w13rZchPsgSHTlP1Q+p/wUlUbqgi+LSU624P6bJ1gR?=
 =?us-ascii?Q?wocpUOCTKcS74dmWXiGenq438xHJWlZdODalT4uE7VjmRa6BNhZmN1Dv4jWN?=
 =?us-ascii?Q?GjCPJhth4Ib+2grA/PPCEf/aPK3XGhICC8bx1QQ4eVGhOmpDotX+mlK9AnoG?=
 =?us-ascii?Q?fSRfeLUCeW3LLL6gVQ69PehlbqxgD51O1UXETCev71UVYQ3ka+yjh9++eylN?=
 =?us-ascii?Q?4ny7dESRgO3Rf3LJHsC5eDnUi/MI8NhD+LF0UPxMtKjjGQEEbAnMcwcRAs9v?=
 =?us-ascii?Q?o2x2+muGrQj6vE7C4lsEviOfB6V43ePTI0jmwhNQQtc+98Qpcgo5tqHGugGn?=
 =?us-ascii?Q?CWyAoHTtyedJWa4wMKWL5U/4A9AFDnwRJ29aQWaM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b64598-3503-438f-9313-08dda409b7c9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 08:19:40.4673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 026A23rqmeea0BpYzqoJ+sFpfTs6+bpstRS0lUum4GBj25RVeFPw5iYXrn70KQtzNzgcpt6wToH2oJJoIpjHGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6516
X-OriginatorOrg: intel.com

On Thu, May 29, 2025 at 04:39:57PM -0700, Sean Christopherson wrote:
>Add and use SVM MSR interception APIs (in most paths) to match VMX's
>APIs and nomenclature.  Specifically, add SVM variants of:
>
>        vmx_disable_intercept_for_msr(vcpu, msr, type)
>        vmx_enable_intercept_for_msr(vcpu, msr, type)
>        vmx_set_intercept_for_msr(vcpu, msr, type, intercept)
>
>to eventually replace SVM's single helper:
>
>        set_msr_interception(vcpu, msrpm, msr, allow_read, allow_write)
>
>which is awkward to use (in all cases, KVM either applies the same logic
>for both reads and writes, or intercepts one of read or write), and is
>unintuitive due to using '0' to indicate interception should be *set*.
>
>Keep the guts of the old API for the moment to avoid churning the MSR
>filter code, as that mess will be overhauled in the near future.  Leave
>behind a temporary comment to call out that the shadow bitmaps have
>inverted polarity relative to the bitmaps consumed by hardware.
>
>No functional change intended.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

two nits below:

>+void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
> {
>-	set_shadow_msr_intercept(vcpu, msr, read, write);
>-	set_msr_interception_bitmap(vcpu, msrpm, msr, read, write);
>+	struct vcpu_svm *svm = to_svm(vcpu);
>+	void *msrpm = svm->msrpm;
>+
>+	/* Note, the shadow intercept bitmaps have inverted polarity. */
>+	set_shadow_msr_intercept(vcpu, msr, type & MSR_TYPE_R, type & MSR_TYPE_W);
>+
>+	/*
>+	 * Don't disabled interception for the MSR if userspace wants to

s/disabled/disable

<snip>

>+void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>+{
>+	struct vcpu_svm *svm = to_svm(vcpu);
>+	void *msrpm = svm->msrpm;
>+
>+

Remove one newline here.

