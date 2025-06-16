Return-Path: <kvm+bounces-49583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E0555ADAA54
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:10:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A0571886F81
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 08:09:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BB522144A3;
	Mon, 16 Jun 2025 08:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C9vem2vp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C955820E01A;
	Mon, 16 Jun 2025 08:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750061355; cv=fail; b=ck6aK+zZGtmWEUGVeBsMApza5R7FNgWvLXvW2IAFEWTwaKCToaI3WORbj9Y6B7dDmfo5t+BdpCnfhfypht85U80RQ0yk0dkL7YQGb0ESIrfJ1HbYGe25PAEQLV9/hfcMBGtFl4UO269qcZ3kRYzJ6Z+nHE4rc1WmIvP6zJp9DNM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750061355; c=relaxed/simple;
	bh=xNg2BuQpPQm7VDmXuTNp3n44+2dh3ZEaH6fQ1h0AZIw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l1MTgkuskGx5fmiTbhLKeWqazcWHCkPDTEx6LfhK0t1ypY5Z37YOPWPoF3s2AazCWubaVxDJBM+AYFHrlHDvCSnlh1WQIOvlpg8TfRI3SQ/rIE7Dqwex/+9zU9yjrHOCWiWeoeNilADvRYiEu7tqJMciFZ8MLC3Gn6wPyED2IXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C9vem2vp; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750061354; x=1781597354;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xNg2BuQpPQm7VDmXuTNp3n44+2dh3ZEaH6fQ1h0AZIw=;
  b=C9vem2vpDWyVnD8pGDdRCgrLbeFm87FDQd9+H/ChsMeMpB7IJLsz+mO5
   gKHzhslhQpIy4/PeU+OYmmlAY4HD0OJL6JXX2q794KPxMeXU1rvXTQvg5
   RhY7QZispl3dkbrrSXgZKDyWh9evMrsplVE/XtBijDmgILl9hPEz7y4Rt
   6k0oL/1KcKt/hcrzUKk9g6ENMDd8u0x2rEtzDxrNingIyy0+yGkmiPhRz
   q6pDNsCHRHZj2UV4DGQ/k9daNucPKqiOkastnvToNXPMxS+xlT4Twvz+E
   SdKPIYMDL6pGIVNjbMz/RjPnIAx9yvm5FtBtFTUul4RmXsYq94/gzN7zS
   g==;
X-CSE-ConnectionGUID: +Ik3gyCsTcKTs3ONV/kcig==
X-CSE-MsgGUID: 2u9B/i4FRBuFkHPHmLoUJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11465"; a="55996123"
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="55996123"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 01:09:13 -0700
X-CSE-ConnectionGUID: NrUNHEYxRRiS5kt99waOfQ==
X-CSE-MsgGUID: g0DFYoOAR02t3Qw8YrI7uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,240,1744095600"; 
   d="scan'208";a="148302372"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2025 01:09:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 01:09:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 16 Jun 2025 01:09:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.86) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 16 Jun 2025 01:09:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u9XGDiMptPpCGhgrUdXkkVhQO7BrmK99c3zqevbCqM6ky2tpG38ipeSF7OTPUzUg/1rBsBEHCr+MswJSQA6abI1F/s0OqeLgGzYUcCtHV+lL4A1bVuwm/yeAPfRjWOYqV/IpLLkZZCU61j5JJGuzn7933T+ogcf3PasoD7z8HOmuibkbBF8sFFYcA9xszaOhtLJ+lcKL+gJd08wiGKm9awZJT1fmLGhAsYKCqgI1GoOCxZOL0VPLYzDSESgWaGKlJi7e6tOfh2ev5QfAj4TNsdiczEFiWGtjqiNgMyKs/jc+ASHHWXkM3nfWgD6qAyzVxs0ehBiFUceeZoKtsB2ocw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xNg2BuQpPQm7VDmXuTNp3n44+2dh3ZEaH6fQ1h0AZIw=;
 b=I74YNnRWHNr9LX2gpyh/6xfL5HAJ7YxbqrBhG7SBVsJ0ediSZFK2Bg1+PvCKINddbZejWIhkdBXADWH9qvai291mI9KOL6mhRcI3mT6C9m7+73ixie8b0OkueOZJAL2wl5n3sngeq6rClwzEdo9H9SshjZcsjD1IfNsriGJDMUbgODyCT2CS7aGbc5EdxTgRcWhjwOHBvZUojQoWoLjsaUMJzVsIYfp8BKIuT1u2npV7PRofdz4n1oGOSssf2kodEFVCvCIHIkRcylkrnYlczpOJWOh3mFz3dz47mYRBK8qDdF3JYUJ6SKkUtOMxtXumnTTPp2Qn39LLXT3Yb5YdCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB8313.namprd11.prod.outlook.com (2603:10b6:610:17c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Mon, 16 Jun
 2025 08:08:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 16 Jun 2025
 08:08:39 +0000
Date: Mon, 16 Jun 2025 16:08:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<chang.seok.bae@intel.com>, <xin3.li@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Eric Biggers <ebiggers@google.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Kees Cook
	<kees@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Mitchell Levy
	<levymitchell0@gmail.com>, Nikolay Borisov <nik.borisov@suse.com>, "Oleg
 Nesterov" <oleg@redhat.com>, Sohil Mehta <sohil.mehta@intel.com>, "Stanislav
 Spassov" <stanspas@amazon.de>, Vignesh Balasubramanian <vigbalas@amd.com>
Subject: Re: [PATCH v8 0/6] Introduce CET supervisor state support
Message-ID: <aE/Q9+VGv6V/8Bvf@intel.com>
References: <20250522151031.426788-1-chao.gao@intel.com>
 <aD+ZrBoJcrGRzjy0@intel.com>
 <a2639c00-ddbb-4e74-afd4-2ab74f6d3397@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a2639c00-ddbb-4e74-afd4-2ab74f6d3397@intel.com>
X-ClientProxiedBy: SI2PR02CA0022.apcprd02.prod.outlook.com
 (2603:1096:4:195::23) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB8313:EE_
X-MS-Office365-Filtering-Correlation-Id: f5afdc2e-569b-4ba8-54f6-08ddacad000c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NNmZeGVnBFBdr5Q9KyKs8JsCeURUEDWhMjMZe9/CYcogz4V3fPWECqarFSdK?=
 =?us-ascii?Q?5zmCZSqx1jx1PvUxV/FBcZVkxQo60HqMZvKb5NNDTYXS9xRqw1JeO+WIssyJ?=
 =?us-ascii?Q?xFzxNI10nQb6nBVBlv73rHxk5bWKbbAHv1UrX6JQQgSyxz+/EtInSpslMwWz?=
 =?us-ascii?Q?V6Ja4Z5oU9oR7FossFUzZ/wgQjSz8BlnidPyjzxKQAx8RfGGxkFWPXISRRVZ?=
 =?us-ascii?Q?wS6HM45/mMOktcvFVRpYcrbp7trYcvJhgZcmlkt/hPSQ45q2p8gSL75lUWL1?=
 =?us-ascii?Q?D9Ix3p1c33DITsR1FWmGLgx3UXq16bfuc2SEMpsknwrhVbDjFRxJgCI8ePr/?=
 =?us-ascii?Q?BJJF6L0jT+qIF8Tc6Xpl5Z5VrI5/NPSnRSQRU6w1Jiu3l3bb+dStbrGmTcmn?=
 =?us-ascii?Q?eEgP0dXFuwWhTg5BOLru/1WxlgyGKb2p7JHHtg0JY9To2DDollMngIGf3AMn?=
 =?us-ascii?Q?JUB+YeZIYMt54XvrEzmUAA5Ot5RthONfeV4UmZG3QtHDMVaVEXMuy3bPH7uo?=
 =?us-ascii?Q?TxQyWZGZQQr6+MaenrDx3IaGqfHm2yT9LCo86xWBAF1DQMavULnqhoUJQx2t?=
 =?us-ascii?Q?JD02fNXNDwF2vKxnXY2FZisT6b6UIWWpoDCK+ScC8+X/MZw3t/BMhyicPpWP?=
 =?us-ascii?Q?GZ46EJniWMLYE/VdV7GUbM1l/HbijUb8DonyPtTcvlHnvlB6tjXZ2q6YycKT?=
 =?us-ascii?Q?rM26ySWWJVZY3cMSgopxqRYI+qkCe4k9CAC+YVSczae/zyo2gPzwZ11wiuDj?=
 =?us-ascii?Q?qUDhaLLTwv3pRsG+i0bcL3NTBpn5EOuVYghTPvzXYeqlY+FDtiskLR7z6UYZ?=
 =?us-ascii?Q?zENYpxZfdbpS4guMqP4AsT/vWNIuaBIOPZO8Yq9DNs4QaNHynV0OmgLHrTGT?=
 =?us-ascii?Q?/PjaLVuJjZOTvvh1DKBqVATaYxohYPnveRVl1baIQFCJ89CkXT8fp+IUu3wT?=
 =?us-ascii?Q?SHXEvIWpQ3SWIQ8egbYI1thNVD6aggucG0Zxq0T6sb5/m/ja/kWlVG0QAu/d?=
 =?us-ascii?Q?iOivChj1kkFuoHlqo+LbKmfv7NB6XKl4IUSIHPukAoBOU8kJIVMtYipojCK+?=
 =?us-ascii?Q?CCHkGIUmXkKYkb+HhYTRDqZM3w4KDzKOc8LrdHijKGq8bCF/ZYsHDNbjoQCj?=
 =?us-ascii?Q?WAWh/uqCrKOVy8VdQZyXxcqnQTShTQH8EVA9TTtPnDaHRc+pvMMw+GGS10E5?=
 =?us-ascii?Q?OU/rKI/oc3hKoAk8YlTfxE5Q1EPKkFdpavU7QWJyk9F9jpegtBFl7Q5LtX+G?=
 =?us-ascii?Q?V4TM9bOeIogqp16fcM+ChIBnG4CW9sXFpr00oT3GoJVKnS9gUu26X5OPoPgA?=
 =?us-ascii?Q?NK6f2izv86lJKRJw0Q9y4qZH3lvrOPWZbJIbftiKd5z07n/KkA7Aj/XratCM?=
 =?us-ascii?Q?pXulqyzRNMp9OGkucNLqsYkEqrSM8yzWiccePIb37baAweHjTFS485ZKfETs?=
 =?us-ascii?Q?vp5x/YWgJfw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C7sAzAlCMgGOsAfF56b8RdU/we5IwheWizHpKlCobX7GekMvqlRuwNxpr/5U?=
 =?us-ascii?Q?5ehfS68lw8bEUfXqlT//4vmegwxQksLcxYSZ6jIWXjC38rwYz/7qBMRs2pFL?=
 =?us-ascii?Q?9wl+hjbSJ4CQFKzwmmEpHfLOJ9WQQWTKxt1zGt8gSSf5FuiAXLiO7r40Lx4Y?=
 =?us-ascii?Q?l20YxoGwHHi/Z9ZF4Rw4vdURnS9M03pwYAZTUiT8vQXsLYDr4tyu1pPb1L7D?=
 =?us-ascii?Q?SoK3eOx9hFgHNypMp1KKM9m1iWh5RqrNzRYyz+jYWZJPyKshSKVyhCVy8X49?=
 =?us-ascii?Q?/wwqBaPjOjOwo1cROxWtP6/dJA66f+ZJLS6/lABsUFnwahlrp3vJFPDoIk4J?=
 =?us-ascii?Q?7bLYOaUS3+w5VFTDNbA1xtvALKFsFhniCwlfDhk0nf0AC8QZFZSkIC9OZA7i?=
 =?us-ascii?Q?HZ4gGQ5wqefvJp6pUqFL82S9VvgISgOSuXV4b6Pq2gaCsEmHoF2cgkh/2XpI?=
 =?us-ascii?Q?HJOQ/PYbw0MTN9ReExEFxyzeTYsDYD9gxLa4F3pZaK0pY7Vkv22pbHPAq1lG?=
 =?us-ascii?Q?GhLF/t3jEKAWWtAvaLH6dH2EnjwAU18Ma2GM6Y7RrP83zBSrtziwjARpwsaY?=
 =?us-ascii?Q?qzsX3BgXy97Agvdb/7cKmg64zlobt1AR3tPZcZFGaj2LR1W147HxGG3smVeL?=
 =?us-ascii?Q?6Don40U2lAHUs4XJnPc2/kq9weneL9vqQBvqguMHRisWIRGrI7p7BTZ8F58a?=
 =?us-ascii?Q?dmhksnRSPIrx9NJSCFuzMcmJKkVgLuPK2qZeyqdZfhloMuPek/xDBPRi4BpP?=
 =?us-ascii?Q?MyRlSZNRv7OTjtiIIiByYBDfP6OWcSUGGYiYjyLbChIyg7WKYzbo8jspgLSx?=
 =?us-ascii?Q?6se2ZxGAAg8HYNt0xxF2893WPSV/MYv2DMNzNzj0Wvom9bQDzk7es29ppOYW?=
 =?us-ascii?Q?0yhteuxYx+d5PxTeuzddwiualyDy0L3XuBmLFkzELaQnlbxDuCUhjzkRujzM?=
 =?us-ascii?Q?AaBtstWTQEPW6zGiYuCZFj7t305WyZU06toQ7uZUlAmIGQDgguO49nK32MDi?=
 =?us-ascii?Q?mNWtq47u20hSU/bNKSon7lxz4vbgrGLGhGdb7gMNCkRHBvqHakYOIEd0p5fy?=
 =?us-ascii?Q?OCdM8DLNmgkB54wKjNgIplfskIwMBXoeUNncyAwWMIpVLPtxdVUC2bXV/1B7?=
 =?us-ascii?Q?SFeU+xyxYtGG/PdrWrhh7c0tUbBWMpfyyE2aL+yV5ar5Zi+fLwhMyioSzrzk?=
 =?us-ascii?Q?wfhjmJ25oZ0yYMZ/a6fRescrWRfpbJ6Z6jsEabMKBbiUAbW8a+jhbQg2flSD?=
 =?us-ascii?Q?LHRE0rTEAATpJWf1Q+/iL3ASCS3Ww6uC29dppvBg6wGpdHfE6AAU87clCZAA?=
 =?us-ascii?Q?TnzdwW6R+3DGL65MuNSRTb/RV/bYbUrTabcjrtNZD4TXvOMJBjpodMNxejUv?=
 =?us-ascii?Q?PoUON7ldUgMR4En3X1sfYVHoyaTsQAMpF/jUy6RFy58bpyk3lUcCc9Txdxly?=
 =?us-ascii?Q?rgPI0H90WO+JLd4umkh0YYUAMYEXr8qL2UMI6Ze8F4JTMtO2g7PvDGX/OpVz?=
 =?us-ascii?Q?6L0zzHK/ndbPxiPD8iSeWYH5N4bLg+y+fe124PSEGl3A2P61KAI8/b3Dyfjl?=
 =?us-ascii?Q?ywI+Eblptlny6HevG/TDiRpFAzsegFZihGTneMYm?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5afdc2e-569b-4ba8-54f6-08ddacad000c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 08:08:38.9012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WseC6KQ0+wxdNnql7kRbQpcaznfCQ0l6yNB+ChtrUzP2zeea+CwTtWChdnohSkWcpUNKTq73WLHVPSHG7UQxNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8313
X-OriginatorOrg: intel.com

On Wed, Jun 04, 2025 at 11:45:53AM -0700, Dave Hansen wrote:
>My suggestion to you and all other submitters of non-critical fixes is
>to spend the time between now and -rc1 reviewing *others* code and
>making sure yours is 100% ready once -rc1 is released. The week after
>the -rc1 release is a great time to send these emails, not now.

Hi Dave,

Thanks for the suggestion. I just tested this series on the latest tip/master.
It applies cleanly and passes all my tests. Please consider merging it if it
looks good to you.

