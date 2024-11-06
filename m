Return-Path: <kvm+bounces-30916-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EA5E9BE4F2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:56:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41E341C23723
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:56:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B841DE4E4;
	Wed,  6 Nov 2024 10:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gwn70f8z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79931DE3D8;
	Wed,  6 Nov 2024 10:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730890571; cv=fail; b=cjaGiT8MfiQMfjtAD3rCBncL7zm02SW4miZHiRydS/2mIpbt3Cx81kGbb3qi2CoN6rz9xOJs154q/21d1V2kL2pcfpaUH8sGC/N+jdlk+q5KKTcEHZTajjhVPanhZXXrHgt1ZsnXZcYDN1f/i4hVf4YZXqh7/t23C/9gPqukA3Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730890571; c=relaxed/simple;
	bh=7WfAcPtAbGTsnNxIwWJkBXCnR6A+xdJ8/21KQqQSXvw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EWag229uemynn59hxiwkNcjaiiyhNilMuW0iCNhWnR94nqAexrwcM7VMpb+muxjrezqxfJpYjSYyeNwnpx+7h3hDmHeYZIhrn2DRoQP93IEqU09SJDb3/yaE8IDTXNSUXXDIMMaaAO+y84NngMfqUYh2XyKBDZ5pM/5OYKGv2h4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gwn70f8z; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730890569; x=1762426569;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7WfAcPtAbGTsnNxIwWJkBXCnR6A+xdJ8/21KQqQSXvw=;
  b=gwn70f8z0/Ak+ccE6STqyHZ3zMJ2wGRoHyHozOt8kvzVoHtNOtQZR/mS
   MIEFFIvEtOm7sgYAn0Es2vUPNHF9jyEy671211m+5JzqDHR2EarfDcaNJ
   gkawmmK+p+gh620UwIV7rMZ5MQPXRFM0mOEyQWrOFk/gob5MphDp5jYfd
   xkSlwYJaaPthL2TubFFbBMDN5duUfcCdO3WTA7oKHlxuoe3lhCs0RKVxM
   Rka/gWXvi0z1DoDjXFk5ZOjU8KXBIIp6S3nkDEeK/UO9kV2zkfykb3QDV
   G2dqvhaEkh5qeM7fdVmCMFUdJEw4nXU5d8o87ii0R8O/1jE5prNzem/B+
   w==;
X-CSE-ConnectionGUID: PmPyjg8qRYiIxVboKeB2Jg==
X-CSE-MsgGUID: 6LRGqkTyQyOf9Q8apnqKaQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30110087"
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="30110087"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2024 02:56:08 -0800
X-CSE-ConnectionGUID: 6Kj1vX48SNak2/T7v6TvtA==
X-CSE-MsgGUID: d2xMt8RpT4mxrRg7ABUVbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,262,1725346800"; 
   d="scan'208";a="84828415"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Nov 2024 02:55:50 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 6 Nov 2024 02:55:50 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 6 Nov 2024 02:55:50 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 02:55:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c9gEIkaUMRAPOkkMI8fFSGIS4jrWbYjTZu0ftGlRfOYjmDVPzy0EZ9nOS0PsgM9RLIQsUZ0wCVMns3xYVV5/Jz3Y8gSHl4/ME2Xkc1rbQZ3bM9IWBydspxsR+ice+g7RwzTSOTSA5W/iD8N2ug0+2G+l4PblqmpG0w0IUx6r/VoHJ0rf8IdufRM4kR1pbtxcWthe86MQUrZlB/72cffh/VvMfBpKjKjbTVBUYGDLTPhmUEKQiBe8vlNbz+NSDWD/C1Xp6wyL74FXHgOZXUAtLFnsYsNCrJsDcx83+MzpqC441+WxxxbbI2NmkkPZxJlJI+rcN12M772S0EyKZ5tQlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GH4FWD+9H6YuXy4KXPhhgNMQZWkhIAK0uC1xrc6C8+8=;
 b=FB77Y+UUIkKdmzmJT8T0zstIHFqEReGQQhDU0pS66WJ9+Xu31Fc8EsmlO5c1dEykAqU4aQ3lE6dVujzenhxW9jyuENrw34WTkAXgiqGbJuoLcTcvfYfTDe9nSvVbXvLDz6oxpgn2PTGHcEWUB3mJBLGDGrSEG8w8nnNx4+cZnGayP7D5lLZD7mSS3GBu8xSd6IVmVWgjFo4hR4qI2Junj2Dt+ehPffaFHMEZTBpqtcCLwjGULFcPcad/zmTrbMB7dh7oftu14lmw2Q7oZmOvQwT0YtWnBbM9ru8fwkC0OAc6iaeAGnmaEsbtlyJRX2r5NNHkRW+8nH7KCmoF1yVUhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8186.namprd11.prod.outlook.com (2603:10b6:610:15a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 10:55:48 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 10:55:48 +0000
Date: Wed, 6 Nov 2024 18:55:40 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yong He <zhuangel570@gmail.com>, "Maxim
 Levitsky" <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: x86: Update irr_pending when setting APIC state
 with APICv disabled
Message-ID: <ZytLLD6wbQgNIHuL@intel.com>
References: <20241101193532.1817004-1-seanjc@google.com>
 <Zymk_EaHkk7FPqru@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zymk_EaHkk7FPqru@google.com>
X-ClientProxiedBy: SI1PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d5db43-6b76-4039-34ae-08dcfe519280
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?IA8HC/s9/42rnGufuQ6JvwSA2zyP1Hoj7upomxSTY6qfiFEeG7iXXVOPOTrZ?=
 =?us-ascii?Q?Y8YbKC07L7p/6k9nOoiKmfDgQ4/qazhNwhUiTs9LgJ/vulrU3Jg+Kz3vbtg6?=
 =?us-ascii?Q?6x1QLH7kZUQGnYMod/bcI3fzkJqY0gOucRSwmvLFDrGjhkVBxCES1iUv2nsA?=
 =?us-ascii?Q?T7nGDMnQrCWRjVx8NZ5JDnTj6OSGd5wXT0ZOHnQ9gwOMzvf3ZyECVmN6Ge5k?=
 =?us-ascii?Q?Rx2p2uoFmZc2TMejWPBF8kHMu+3MwkEPPsc88lXTNyxG8UUzC4u09W2zL3Gl?=
 =?us-ascii?Q?pOF12nFIlNLenUttNszpEpHMR72YxsI3cromEed0969UWKKjLT5DtnpriMxX?=
 =?us-ascii?Q?PdXoFPhl0ntwV9hv269XtJk3piw4smM61wIS1I1kTKcz47JxK5UB6cAY8LLa?=
 =?us-ascii?Q?Mus+YeyJgaFyUKoWa8O9u9QhaH23MOAVgxIfg4mY+01OA1sjlFdb/KBtweop?=
 =?us-ascii?Q?mBiNkRZm7aZ6B2b2EYEFaY6qIkLQ1iqgvAOfW4DFxDUKadwPxwUA/NEjZN0y?=
 =?us-ascii?Q?EZPKbMA2sUdW/Xhm21dMzROlBjXOBwsKXElUQ//J4JNyn/xBhhOP12tw+LWA?=
 =?us-ascii?Q?HOAm0PkJLW4fac9qhEUlN5oxBmlIKNQveALWQL4fEcv+mCmCA7MVddaJxLhp?=
 =?us-ascii?Q?gidvRMyURgO/iiHGFEO/rjEXpNHyJ09Ipnw/q/KnCBalgRRMKSEHMy5X57qX?=
 =?us-ascii?Q?i6M2XXjEdbKqMljFQ9jRqt1UF7nKwPxPvPAdj/pq/JukgIlPenQ+m1RiHuAx?=
 =?us-ascii?Q?1R1OrwsqGTuFSEkORq9n6J0Cq1blQcMjPP/oPRJzSiLW3co2YdDqVlSZAoG0?=
 =?us-ascii?Q?VnLarNihw/ZJomeIxmpliXwy1xMLBYPM8MzlIDXYCbRWBcePg6o9jDp5czDJ?=
 =?us-ascii?Q?ooY8KGVIu/9hF8gw+8FvGxxyfhXSsA2uKGjhb4tot0UrDYFJIB5ixz682WPa?=
 =?us-ascii?Q?w+caSdwKmu8/zPPTJGRIKW07DnYdCIjs5S1FZDmaYf1NKioey3MR2s5o1nhN?=
 =?us-ascii?Q?dkoJoqoWUX3HeacTaQqZ7oHNzarFMnBwl6j2okjY8bffFqZ73paENUnZRG1c?=
 =?us-ascii?Q?GDxjXbH0HlucpYUXKzKVnWxbBS0vlZPhn6FbayN7ihevRitgRCVejw2biH6m?=
 =?us-ascii?Q?9Hz1hk+B6hcLVi8YhCAT/KZjFkMewnDfI5Q22hcfcg5Kh99icAo3c3a/BMxc?=
 =?us-ascii?Q?sBv++h8RsO086v99RWMs+jCoEYcj3sF6No71TCefluU8Bkp2V7a5qOXAKuai?=
 =?us-ascii?Q?9DvGFU25BDfkPOaExIbhU4Gs10lURvGLDwxoLSqB9XyBeEjmdifZDxYslJu7?=
 =?us-ascii?Q?LonNDnsd4xmVKir51dfutpZP?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G59t46545TfijTv3/BMxaNUd2ZarU3eggX393/Gu0EQdPLJjg5+1sGO3RF6O?=
 =?us-ascii?Q?+P8bp9w7vUxtsFMI+M34QdVUHDEiOA/YI6rR//PWl97H/1s37NAnZ+sh4wyA?=
 =?us-ascii?Q?k4Wamzdi84bp057zlzjnannE+IRdD6R3vZfTr1XiNrSEx1FBhwSJqBRk3AV9?=
 =?us-ascii?Q?daNIVq52f2s9WxogSmjXlS5VLYRjNQDnC5I2v5BuvF+936hCJTAXKYdFeS65?=
 =?us-ascii?Q?toKv5l0L6zt9q58kR8v2+zZ342kJNcb4jAtdzFe5pp58jLVRNJ30yNgVH2/g?=
 =?us-ascii?Q?4qkOL7kmZjdJvZm1QHIJsR/nRwzTrLF1AlKBAhBGyDS+t0nBws9hz/Fc5/Ca?=
 =?us-ascii?Q?8ZvwOwYhRiH0qgiYtcWcXLokfLTl9uj5ygxR83KLWS0a4FnwO0TCXNtLXO+B?=
 =?us-ascii?Q?V3IBgFH9/UTiNDmC6Ni79Q/47F+UhyuP2mycQdbkTDOvho+kA9PrV3REEIt3?=
 =?us-ascii?Q?cr/kqI1xIL04+U/w8QCyMRYFelXVwHX8O1Cx4EZa+oNpTnngT7vmPWFbQsvS?=
 =?us-ascii?Q?6Z9RSXcnYGKEkkMx3TSx59PRuOc8+CKzC1KvTXOQJ5/BpynbDqMaOf8AOXLA?=
 =?us-ascii?Q?KcsdTlhHVn9DlWkPODNrNGmUHVnUlzvziThoPbCWf66rHIJND4rlhymGqkH2?=
 =?us-ascii?Q?uQWmSvShZMAs4B8+OVMhmCnUXcn+L3ohWYAvVFEeHM6WIZ0ixI15aW2oLBEU?=
 =?us-ascii?Q?YA+OOwImG4NKwCDJoBJM4zUZU2ggtmTzX3HkCN97MqnfHzO8Y0i1W6SPTYbX?=
 =?us-ascii?Q?US8BvwBpolu+ZXYCGsCUopLAR0CMELI+7thCGHrg1z1I59OSf45xu/xyQ6G2?=
 =?us-ascii?Q?ZGO2E9dHoBYwH3k5rJtoeHoJ3Z8cbgDOAxvKzXE+gHrFy7T9VFfqbYy5OIFG?=
 =?us-ascii?Q?sGCf/ov+sUmB306O67XQwBSQACwYsFB/xBgr+NoghiGP3HToBT2zalVsqxaE?=
 =?us-ascii?Q?G8Ns1PrpZpGrYeK97AQn0LXEMEm7GsBncHqfMGi2ThOkMhAhrq8B5InsBTAf?=
 =?us-ascii?Q?H6EIvicZUi37+3tNBEwMW2xAWAMNrS8+a5bH5vLD8qK76vDIbRRjoIm60xxi?=
 =?us-ascii?Q?7f0iJO2vzx2AwiBv20QxeTpP32X2Et4/qCYX45p/r6d4AmZ4HQ8zUfmKVZuy?=
 =?us-ascii?Q?ZRdohOl6IPyp65U5J2hWWBgeclwdNTJpDPb8LuXFPlmigKyeGV2tan16WFF2?=
 =?us-ascii?Q?KcideEIDZv5KslDEdmGu4M/bsJel5+5LzvQqImGXrSSzZLgB04i8uIw0uE+y?=
 =?us-ascii?Q?H+qkkcELUb6lsE6DLWgd41K0N7Vy/3t/QrO8TWx0VKwIMutk3/kxmYGyTkki?=
 =?us-ascii?Q?mGkDrvxJtl70o9TlSflrCaJ/CKbhJyuLw/tWOh4f3WOza3HfJZw/XFdkH0Nc?=
 =?us-ascii?Q?ir6S3UnHlqPkS3Ub4ycvMgkOxWHcYGupOU6S64c2Q5EGimXw//p1tfPHT4sO?=
 =?us-ascii?Q?HbXoTQ5WhyawhImADK6UGSpnV+mDVoTp10zRAxDO1kDaJkIKMM1zaPl4mVbV?=
 =?us-ascii?Q?rZ/xdFLSdTZJYSl92L86jHKMeXp9Dp8BiOQHYLll/eu8mWbNVp35YtDj3spG?=
 =?us-ascii?Q?8BjTznJ2jGG8OTXTFiTKBE6IErsiCPRZMElrCLxP?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d5db43-6b76-4039-34ae-08dcfe519280
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 10:55:48.4716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcTGE4KgXMjB6AzIoFJJuFyqMLr5cV28usJUTfk8Ab+qRxBqq2uar/fJXDrjSjAnDw3iZqlOeDdCZ29JexHj5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8186
X-OriginatorOrg: intel.com

>Furthermore, in addition to introducing this issue, commit 755c2bf87860 also
>papered over the underlying bug: KVM doesn't ensure CPUs and devices see APICv
>as disabled prior to searching the IRR.  Waiting until KVM emulates EOI to update
>irr_pending works because KVM won't emulate EOI until after refresh_apicv_exec_ctrl(),
>and because there are plenty of memory barries in between, but leaving irr_pending
>set is basically hacking around bad ordering, which I _think_ can be fixed by:
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 83fe0a78146f..85d330b56c7e 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -10548,8 +10548,8 @@ void __kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
>                goto out;
> 
>        apic->apicv_active = activate;
>-       kvm_apic_update_apicv(vcpu);
>        kvm_x86_call(refresh_apicv_exec_ctrl)(vcpu);
>+       kvm_apic_update_apicv(vcpu);

I may miss something important. how does this change ensure CPUs and devices see
APICv as disabled (thus won't manipulate the vCPU's IRR)? Other CPUs when
performing IPI virtualization just looks up the PID_table while IOMMU looks up
the IRTE table. ->refresh_apicv_exec_ctrl() doesn't change any of them.

