Return-Path: <kvm+bounces-50268-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A6DAE3463
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 06:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2373F3AFBCA
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 04:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94621C3C14;
	Mon, 23 Jun 2025 04:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IhqePGrP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 888F82581
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 04:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750654267; cv=fail; b=GdfuLsvKMe3BKJkfRs4dSFYB0OYCMlKRMK0bhs5wwrSkwdwtq93uzzMtBiTAw5u+Imz7dAI7erWOWtNFbGnnD1H0whwbvv1U710fASdLh/T/GP7UnAvRid2l9H6DPJWdJvhyPaEm0l7rZhxsqWUkyn8qFU90P9nxii005JiUfmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750654267; c=relaxed/simple;
	bh=rGkbNMb2L6301BShfYyevS8EcqeW8oMYJNEpVsjyyWo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QRCcvLNPj5QPsjOkITOzW/MQEQbhtPVnJOKMf/IjL5n9RvZUIbSG2LOMknJbZZiluaP4OG52ep2rpD/iycIJS2FTxRm7BdCHVHIpQCibj4ubqXkcAgkDY085G+cvSrWE/E1+GZoJgAUiMccKc+MMgQldrgiB3qpQ24Q12QPMt/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IhqePGrP; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750654264; x=1782190264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=rGkbNMb2L6301BShfYyevS8EcqeW8oMYJNEpVsjyyWo=;
  b=IhqePGrPKVMw5VaI2Di/5kvzr2QfLnrChmGiEVCZ/4myvcwEgL983/N0
   GZeBf/ujRMSzTSzPN0Ne+L6ntYkLXqewWJQlLVoWXEKqVCWeICrwxF1M3
   cEcshipvN+Lrn/WAh5MNMUYxqxoKhOFOIl5tp+bba2t/FKKIvlqsaXEc/
   nfIUozxnx+AqpVcNdRZd9Cg2N7yPp3y6Ahzlnzo6SYvASLr0We5oWtKwn
   DyJiVLBs/MksxpvKF+lUO6onjK6Iw2N6oouD1yN7o8zYPxK1irUP+RYQD
   NxN7w47DXILn1iv2w58l55ujMbpyVLOZw0tyeOQUiUNffvtKGNfhZl5QP
   A==;
X-CSE-ConnectionGUID: NLYN1zfKRHyPcsRXji5/ig==
X-CSE-MsgGUID: sP6+dcIJTAaFRq8ogzo4IQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="52565351"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="52565351"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 21:51:03 -0700
X-CSE-ConnectionGUID: Xu8hS4hASEqkN4GxCD/eKg==
X-CSE-MsgGUID: 57h1xkmOSVmiZPdcX4bNrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="182360410"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 21:51:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 21:51:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 22 Jun 2025 21:51:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.48)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 21:51:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BVRnNvNYQZuoLn8iVjZ+qtug6I6TwlFaPrtb3RSxNanrDsM46vqtDJGdi+rFMPC52xwjT3APrs1kfJiCvtw7iF8LVeoBh8pK3WLAKPCx7SFNhWdYXhf2jsPym4wuqKzSN5wyXlcP8frrIu6JluSqITXPkVa/E7IpAVA0apBpQxeFfHt8I1DKBrbSU8Y+tyN2NfGMBJijDUtIVh4v+uGkgFDtJgEqvd2YckzBjN/73yYt3ioo1I32Ej4+EseTkPQVzu/95gagnG1ZjP+Rxe+7ERJfqm1giolYxaBWVoJyrX1m5YTQHHMEh3Gmn4WJ3fUGkrZXNHdTVmVYNiGt4J3T6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rGkbNMb2L6301BShfYyevS8EcqeW8oMYJNEpVsjyyWo=;
 b=UuzoAX5TyVdvYG/QnebUf5oCSRoADG9KWprGcsz8uZi65t5P5b0yd6csa7wRkQ28Wy6O2vSoKksy8qlyqhu2Pju9zmQt8tecg9QRrXu2uqizvrxfx4JMlfrlrUr05Vfi0iMtJYVolnV8G7mICgDxxP/JOQDMWFnpNHRL8mCNtsdfI74kZJ/LInw11o6T+Umsa9iK2Jy4O59oz19RdUmClFIuIl+Tmg16+jFCY51nwfV+/7+Vb3K/Jh2P7wucw6FvdW1s2aMA3/Wu+zTX8SslGKQO134dy+GgGQko4xOFUavBC5aA9Bwewf8g3roSWyYy0IKmcauAgWGG5dI1JIyyKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB8263.namprd11.prod.outlook.com (2603:10b6:806:26d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.27; Mon, 23 Jun
 2025 04:50:46 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 23 Jun 2025
 04:50:46 +0000
Date: Mon, 23 Jun 2025 12:50:36 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 1/8] x86: Avoid top-most page for vmalloc
 on x86-64
Message-ID: <aFjdHImRR1zEjpdf@intel.com>
References: <20250620153912.214600-1-minipli@grsecurity.net>
 <20250620153912.214600-2-minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620153912.214600-2-minipli@grsecurity.net>
X-ClientProxiedBy: MEVP282CA0040.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:206::15) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB8263:EE_
X-MS-Office365-Filtering-Correlation-Id: d7dab876-f4c4-4526-b2cf-08ddb211841d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Pc3l3JD9sukgCzF+ei5cYNAr8DrHjSqbs8WCGjStgPOu7dxKPjLmb7ELaBD5?=
 =?us-ascii?Q?lPjKPIfwrcjVK8iYMDiLLfXAdOETfD7IF/cpQssznqb/dsmir0cAVBznBpYZ?=
 =?us-ascii?Q?uxc1OJvi+iKC7XYMggOf7Im3ZjKCpGFtxF2hOugCmjxkmVEhhGvtFoi2JVL9?=
 =?us-ascii?Q?EzBhartYrAa0S1M88o9Unp+WU+Jm9R/YKV5LOMYO6xS81002SkREyslQOnq0?=
 =?us-ascii?Q?1kL5ur2mPtXqAgocX+91m9Y6dNRMmlmU/C7YdBDU8ntkKEojlqv0dGGKd97A?=
 =?us-ascii?Q?y2s7nn0utZcxzgT+RUniN5KapPo6kvr8+zDyjbodlTkkzGBKFKgEj/7i1iM/?=
 =?us-ascii?Q?5ovVdBxra6oraJgPEavg+aPuzDc0I8VWVc34KaTi3IpQsasdS7/BbpMS08a2?=
 =?us-ascii?Q?xc25uJWq43MZ7eje2xhLBAqicpweRrjooQ91QddPtdN6AF2lWeXtkvXrXwwr?=
 =?us-ascii?Q?QNMomIOtIMIjSsaorVTx18IoSvTrYpRYSjB7834hYlEZ2jYch0j8FEf1AQjZ?=
 =?us-ascii?Q?MQCt5xm3XAR1hNxo/WtE2JHEAjmBL+uGrh0pmlM1HTKYwrm5LP+cHR4GvMil?=
 =?us-ascii?Q?v2NAB38AxgBT7s5H45gjVL2AByhPNfmHC3YBNgiYPKH9k/oSW/DYcwxx7iYw?=
 =?us-ascii?Q?7o0JGSSQxyfyiLc+17rAZMzfjtoY2VsMrJa2mqfahpKiHvUqY9pzS72QFfzj?=
 =?us-ascii?Q?kttmPl/2Wjlfk66dp6ZYRFddkpghCRp9sOhXsai3WAi/YXGiyekdCvyeEceq?=
 =?us-ascii?Q?9BdKRrJuY9yDSCrtRxoLtmZSiGC4uQpuV1gdFFMznzkn0mXZzeiWPREwlndm?=
 =?us-ascii?Q?Nhs9ut9DdpXtvF98bImxQ522JGQi2BguP83obupLKD9dLfMOAFOK3ejecDvp?=
 =?us-ascii?Q?OStMIi9gDesYKjUUfeWCEhrwZxNpCVIRNfjOPzTOC2tXO71BaVnbIyqSUY5Z?=
 =?us-ascii?Q?3ywAYZnZN/gw8ABzhfxdBsKdkAGenauchXgtUa/13JC3+tizSWRh/2n2Bse5?=
 =?us-ascii?Q?H1aCbVHfSY/3WVIhfBTlr1v2e13ZGtyddkK11xg7ywmv5+XpP0BNmEc3yJHI?=
 =?us-ascii?Q?Q3QCS82JnP3ZzpKcHOY+7xQHscbLPx+q/5CzezhSi0a1U18Jx1oGg6enwu/c?=
 =?us-ascii?Q?E0iAAZRoAhy9n9M56cWfTnGyX6eF6YxukKjnb8hmP2cZiZHiJdixI7PVcb6W?=
 =?us-ascii?Q?vledqtt5tZqXH059fe0iv4nnvA1bEtG0wMhcO+jl537M/2Kc60dMsi0Tt5kX?=
 =?us-ascii?Q?enviSTyrhds8/g53esDq99l1aQcFollRoaBcfW6y16SOVpwfQ1fdeu9mAIMe?=
 =?us-ascii?Q?2Y2LfPZ2OMFXxCiyq+MvoehVtdaP9PKcBaEAKl7TmS1/WZI9po388RguPus2?=
 =?us-ascii?Q?aPoNPZZi4ENwdqiJmRSUbpQC5IF9L5HlhFBkvzi7AlLgIulXjB2uRPEmO1RB?=
 =?us-ascii?Q?QkEsoJKVzo0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CfuriiekXlvrWVG9bjGc3kO/GWItPm59tjivSmdDVsNq/AqxC6mwbBksPiNB?=
 =?us-ascii?Q?dM+oZ2Srn0rG7s5T6/EuID8rjoSt4k6wDAG7zK81HcN+LQYB7CqA7TbGIA9t?=
 =?us-ascii?Q?/tNLczQgJhEd+sMWMDMRFDA51xPSvxGb1zauA6LoxK7/FkAyadQ9bKxBDQTb?=
 =?us-ascii?Q?o+XFeKpbHJK/3lqr6/nssZszo+ZYBY+MTokH85Vz1mNwXgEG0RjrOgySjXmK?=
 =?us-ascii?Q?mom8GtDtk9rtohULDp2z/wveumg0zVAXX9ETzfEKsSl4ZAMUVsn77U25nD7R?=
 =?us-ascii?Q?RNBwIpP8nsOvI5CGjI0D9G3+STvf2ZH7wY/7MlP1CFyCVjxFaIa+/3qJs0Yv?=
 =?us-ascii?Q?DRzZd7+O/72Uhdp8/gfKImA1KOz5xmqVbL+GJ6zGkffd7pJ1q7Vx+NC97ha8?=
 =?us-ascii?Q?cAftZAehzhS1XpZ/ZR3t3j8MAph/nzmDqfjtlLzODpl7M8LXEwPXE+49zEXJ?=
 =?us-ascii?Q?Crcp7aq8De2SmlvTVkKGSYSHVfAjl/0x5+N4hRUJhpfGon3Gql7AcZV/goiN?=
 =?us-ascii?Q?45Bqxhx5KuscP6ERLmFhS6ivBfr9sItbo/RJg+VgJUnsHEvXacGe5vewtrpl?=
 =?us-ascii?Q?zIpzVBv7PbgauliP6m6u0LzdTJmhJ1E/Sk68GsXugQeJJ9SLUykybMynEgv+?=
 =?us-ascii?Q?fhepdJyH5sxv7ytoPZLhp8j4/umRgTeBv+EdIcdGeHjHqGEXGnHCAOREjROI?=
 =?us-ascii?Q?VwohWnGOlEvHgg9OOF5lonlLWd93lSlaJ0sOO8yo305t4bsnVXMzVvvAktP2?=
 =?us-ascii?Q?AyHR4+1kYlJTiyQEHF511YcyUIJb71fVJ5aXpyVcYkbQdEln6WEehG9D5YaP?=
 =?us-ascii?Q?WwkUaB7lySEbY1zljQBIUG3BrX24OTLaZ+SsGBhSAQBi+aMHHDVP8r6HHRmR?=
 =?us-ascii?Q?1bUd1zKAvxo+xvd8CTHkCY8LJc8uVBKUYHe87F1UIaF32GhJkEdsfGTXFze6?=
 =?us-ascii?Q?0lXfeDDb//oHIbJhmIWPrpE2yD+EiY2azeh01i/g2Qn03T5XYCVU1102T/jn?=
 =?us-ascii?Q?+UQNb/Z0ym7Y3IAR0QlcHHvD6U/hOnDSPDlusfd3mcyQObpL6nKkpzCf7/dS?=
 =?us-ascii?Q?+hOZ/aGOnvMwDSosAXPztpybytrYB7LwRfwuJE9cpsncfEjMt9/160SOTIfF?=
 =?us-ascii?Q?7bhfZWGJ4kzWeXGpbn6+Q1pZRAo2Dc+UZIQuQYWufWmo9QVlmukF4FtXLXN5?=
 =?us-ascii?Q?M0T5ochyWjcBSM2pXhTyk3GbU+xfrM9YJf3cZPjT7+8Xkv1F3uPJTYZDozFu?=
 =?us-ascii?Q?Zft3Z9EY46wG+hUT/whGZ3JYlA+oAryqRiigZhyz/9iQVteKTgT4NfMKLqIw?=
 =?us-ascii?Q?Nzws6vdhkRf4L0zuHl7JQkr81bn5gN0vajHZ+ihWlmNcuz7r57ImRToA8VLy?=
 =?us-ascii?Q?gxDJR7aFAMMie+y4kvE8ftH0R2BcsNcT6KttEt2xgNVA7RNQEz9xHacz+pyE?=
 =?us-ascii?Q?wr76L28Nn1FGwT3oHxFcudDwlROjy9W00ODvLbHfvkO1A8K02LXfWVJpk7ES?=
 =?us-ascii?Q?9Hjo/je2jDnK0HAM3BJw3eMaD0Sw8nAJ6TU1EQyc1tkMbBwdGfD4iIARoMeP?=
 =?us-ascii?Q?+VPCHnJ8AWpalDY3d8AgDL+P3glXzSj8vOZwOgq/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7dab876-f4c4-4526-b2cf-08ddb211841d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 04:50:45.9591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ti7QJlVYicUfjEt6CYKQ2ac2aBiqOxfLD0Na3z12Qeo75HNv6DNGzcPVYdAiV8lCrRAeGLOS94J/Dtx5J4fH8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8263
X-OriginatorOrg: intel.com

On Fri, Jun 20, 2025 at 05:39:05PM +0200, Mathias Krause wrote:
>The x86-64 implementation of setup_mmu() doesn't initialize 'vfree_top'
>and leaves it at its zero-value. This isn't wrong per se, however, it
>leads to odd configurations when the first vmalloc/vmap page gets
>allocated. It'll be the very last page in the virtual address space --
>which is an interesting corner case -- but its boundary will probably
>wrap. It does so for CET's shadow stack, at least, which loads the
>shadow stack pointer with the base address of the mapped page plus its
>size, i.e. 0xffffffff_fffff000 + 4096, which wraps to 0x0.
>
>The CPU seems to handle such configurations just fine. However, it feels
>odd to set the shadow stack pointer to "NULL".

Not sure if adjusting this is necessary. As a unit test, exercising this corner
case might be beneficial. But I don't have a strong opinion. So,

Reviewed-by: Chao Gao <chao.gao@intel.com>

>
>To avoid the wrapping, ignore the top most page by initializing
>'vfree_top' to just one page below.

Nit: this makes the comment in test_lam_sup() stale, specifically "KUT
initializes vfree_top to 0 for X86_64". So, that comment needs an update.

