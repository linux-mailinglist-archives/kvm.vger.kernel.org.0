Return-Path: <kvm+bounces-49941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C952DADFF03
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 09:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1FC387A74A8
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 07:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3A8E25D536;
	Thu, 19 Jun 2025 07:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BGk2KW3x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1819D25C6F1;
	Thu, 19 Jun 2025 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750319048; cv=fail; b=jB6FH3nBhcFBem2Xeoj+EakTUq9qYVzcmfy7Q0suFKbPRAOw9VJaC0PzoyJi2XWFCfh1sQ9kx+XNOJV3T2BInG5d+erUCqRDrCME82GfXGNL14jlJndMoAo5ezTXPEjaeFKs0Hl9bhl2c2RbOTftmslaHj2VkJw8pu671Dnd1mU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750319048; c=relaxed/simple;
	bh=UkVb+XTrAa4nTZo0SNCl3HnGv8YZHgdwnOVGlLtSrfk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TAZIk/YXWgu0MM5Iw3A4EX3Sxu+fDQvGjoNluOBWKpwMxudehFJC2yK/uxfZBXiRU4sVHN5+pm08tWpK/nssoNT5gsSjWgSmAWXByWTecF6+XDyV9S4oK+Nh8YOk/TUDq8jE59WbdD1pk3rHxFS2zlbZMahOmUij7/aI7JPvDFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BGk2KW3x; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750319047; x=1781855047;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UkVb+XTrAa4nTZo0SNCl3HnGv8YZHgdwnOVGlLtSrfk=;
  b=BGk2KW3xVEXIY5Xlo1TUWyPDcD2sQwKnPFpxcEEsycco+fsKfo7kBwFR
   hemsL700lAfx9vHoD9rqEE5MVZXYxruD2QXZfnK65FEbbe0XrP8K7NCIS
   cNIUNYD5oy08WQxc9hw2p4XAd3ZmF2/Th0fk2fQtw0lpRzr99tiDQID4w
   gnEpDoLLtG0YHqCvQN0HfLVhtE88bAs8GkXeC82KEkN6QBhpw7K7oRKfe
   R6lRUL6KugHGigqP9R/UIU48x6CjfCvHiAwBJbxBEoGtUVchEIem42G7c
   sVWu0JHKZVDCWznBtW4Huvy+fOiI5jayt5ngBGQp2O+fzuW4/EKMr7yH7
   Q==;
X-CSE-ConnectionGUID: cGbM90KRRAOMFT1+OJacjw==
X-CSE-MsgGUID: sj5zfk2KRImolJ4JdkKt6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="56362386"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="56362386"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 00:44:05 -0700
X-CSE-ConnectionGUID: 7mg7EFMKSXGEyqt7h9ZHUQ==
X-CSE-MsgGUID: za4XDxHdRxSfUIpxYEqp1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="150757537"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 00:44:05 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 00:44:04 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 19 Jun 2025 00:44:04 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.46)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 19 Jun 2025 00:44:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WpBUMYBFY/XzmlCq+bW/y5ap4oxdyyA2892gRs4g6I5H0hYr2L3GvkD28yiwtk8Sod8SuDLRQ5MWkrPUHb0ZLYNh8FU9OnrbNYUXEmTKtN2ssEHLcbWiXa9Px4OpGjOv/0zPzWAcHNJPCnIA+l9T0UDEWtjluNztxxcIxOUwxZQNet2MmF0WlCMlHCK8FPXRb0m5Ic27Uzgfs1TRXb9tch+ve5xNoHsxNCG2LAOelFDCwwwJDmfM6FpoI3+gKZ2g8oXHFk2lDafc03eQQUJXktu1PQPvkc+AMgz6epdC5cHiDKIHnih8xyj8wdeF3+xe70Qk+p8AtMvLVAGegUOByg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMs4IA4QT5wYgiIPOTu5oA729TRLkpnWsPZulUrMgRE=;
 b=lMV9lCygvXc4Ek4I5uxIslJFHyTr0WU2tbcLbgqE491PnYLHEsFZGBdFSmM4owNNznZU/NmI+SoZQuGgIZZAFLtGobGxypxzNv3u+W7lWLAtuEBPTUUUD2oNIYF6UkvU8uwrmOXAuq5lSLnroH17i5pI/crkEVnu6YuSqLkLJJ5vpptH6L6rYSGvphcO/FlcF54gkqME49mota+BHAT5cFwDGYMibdXTvGLYJeAT0EPU45CfHBd4SXbQIAQKADCETlBmnWvsopswfGTfn0bgUKWpUeAKNKUK6SiZuRASBrwpy2lM9WUPMwrVbZTnZ++1Kh5IZ+oN7r5RVDMbypsKiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS0PR11MB8685.namprd11.prod.outlook.com (2603:10b6:8:193::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Thu, 19 Jun
 2025 07:44:01 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Thu, 19 Jun 2025
 07:43:55 +0000
Date: Thu, 19 Jun 2025 15:43:39 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sohil Mehta <sohil.mehta@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, Xin Li <xin@zytor.com>,
	"H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "Peter
 Zijlstra" <peterz@infradead.org>, Sean Christopherson <seanjc@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>, Kan Liang
	<kan.liang@linux.intel.com>, Tony Luck <tony.luck@intel.com>, Zhang Rui
	<rui.zhang@intel.com>, Steven Rostedt <rostedt@goodmis.org>, Andrew Cooper
	<andrew.cooper3@citrix.com>, "Kirill A . Shutemov"
	<kirill.shutemov@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>,
	Andi Kleen <ak@linux.intel.com>, Kai Huang <kai.huang@intel.com>, "Sandipan
 Das" <sandipan.das@amd.com>, <linux-perf-users@vger.kernel.org>,
	<linux-edac@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-pm@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 07/10] x86/nmi: Prepare for the new NMI-source vector
 encoding
Message-ID: <aFO/q52D4XkzmO4i@intel.com>
References: <20250612214849.3950094-1-sohil.mehta@intel.com>
 <20250612214849.3950094-8-sohil.mehta@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250612214849.3950094-8-sohil.mehta@intel.com>
X-ClientProxiedBy: SI2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::9)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS0PR11MB8685:EE_
X-MS-Office365-Filtering-Correlation-Id: 68a8320e-470a-48df-e3c7-08ddaf050ae9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?dtEj6ssne3ig5OxT7yF3poEXi59Y0UJIGyq5mRlRJpdpGY6HVlQiCwClwndl?=
 =?us-ascii?Q?bCfVheVcB83vn1ygSQ+ulS67Ai3bctjBGfDjXOobsWXsqnGNPjuwc+p1gvm+?=
 =?us-ascii?Q?LYytNXIVkRaUssr8AdclQ8VrMyAmmOEbsuZt0qWqNmwmLu1d0LEeX8EArB0H?=
 =?us-ascii?Q?qop/qE3r3lOfwRzN8k5OAlh1APyCem/P/Vod1g1StRsNX8dn4yv3/uujZXi1?=
 =?us-ascii?Q?68lzbvPY71ilcpGzCwOUou6rPivrmiOICuHop+5RkMtNslhiFH6OoXunwort?=
 =?us-ascii?Q?HP6BGdeKK8c6K3QW0tIMu9AuGKT0GcTpND6Z2I6TFEbLykZYlrAmHXkR/RMv?=
 =?us-ascii?Q?/wHCC2QWPod38KjjqPcsgfvl5kcmIx5zYSNws4HPhGOJpSW05U38ADU4qii2?=
 =?us-ascii?Q?TzeThywpGH7AMyLp3ClE97wwjBQkaeg95GGEEE4e1TXRc04Tp5hLu09kxBns?=
 =?us-ascii?Q?VnH2dnvqwXMS+nA8ltGdsFkaLDKupWhDon1oZSYRBKi4ilCgs76CrHko5Mlu?=
 =?us-ascii?Q?XqFtVZW4fBUgHoDpbcMA+gN/lBuRcSEYslBsmdufMOUQXf/VuHvH73wS3a0t?=
 =?us-ascii?Q?BAI7v+vQaiZZWJhmPPZmloXj1AjNR+XsbsS9wtcJoImQ9HV3vl/2/mYo+K5Q?=
 =?us-ascii?Q?sOA0rwgc33d0DO8cIzLItaM0Zqvk0l9iTOzu5cobD5FV1qwM9N7fpOIv0mll?=
 =?us-ascii?Q?4vBZ4h3aLqvdkFhFdDefE0HwmKRSldXQKQn4RRqS6nljGQ/nK5SfAT3aXv5A?=
 =?us-ascii?Q?SdmJ1vSN28K5HuyzdzRNUKLQSkbzbmWgwe9ESOUAYaGIgIwcsXiJhagUAJb7?=
 =?us-ascii?Q?IUAPMFwX06e8a64R+YozUwjeBS5eRv49zUjsRA+9vKEFb0Wer+oY4i3ixRtG?=
 =?us-ascii?Q?CwuBxUDpgaqIS3vh2u0dlsII76RGCVdJp2Qg2pYIOksK0rDed5mRtrcfyjfW?=
 =?us-ascii?Q?T21n5J58FvtM59uvery3GsM5LOtlGhs9aZ9VEnBztp7aelEPErWRxp+nT54t?=
 =?us-ascii?Q?8/LrhnelFpVWi06H8NP5MINRZtR4/nk/gYcwD+maW1wajFAVUsDlQZKuCbEY?=
 =?us-ascii?Q?dWhr8a1uW57b93BX75OOLw1FP0O9AyRqeiuVLsxgjucZ3GgfMJbJfIScJBwi?=
 =?us-ascii?Q?orDy5zdOJRNHAWXIHIPjA43W5zmGxComaVnZw4OnP96ZGBKgDzTD5ymz+yJQ?=
 =?us-ascii?Q?mdb1h68NAGAc3ysJMvWPMKtgvuSPPL7xklEj1fugX937hmmmRxA7pOm0c4XO?=
 =?us-ascii?Q?JQzjoGrVedzzqWs+F4v1xXCnah3ZQyW3Rh6eKIlJfUA08jtq5OALzbVEe3ke?=
 =?us-ascii?Q?imxc6u6SlJRb6m5QuF2msTtq7SsozOEkSAx/DnPwHx0hVjbS933ZbdlDm11J?=
 =?us-ascii?Q?swrMgoFC+2iDFunpnVu3ZmQsukjGSqtNrBcblzPL1KeG2zP6kYNRAxcPXqEm?=
 =?us-ascii?Q?3v8D80E1jKA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cllBrbdLvAzm88v4WWxhCC2N+IC7xbGb3FMxIkfPcaoCElXKj5C6ZTGweF0E?=
 =?us-ascii?Q?8slY/3kfCbLeM5reOdR28ENH9AoLAhBRTvj+IMvnK6s2MHeNmcdbXuHzXgvu?=
 =?us-ascii?Q?YcdJ2YNswhcD0QIxFg+kemmxFaKXEue+KQPsx05LnweVhVnHpJg55aJYszmz?=
 =?us-ascii?Q?2D7sp/t5PYcwI6ryWH5oijUMz8NBcP14mwcDLe1Jq0CLjrfDnTpZ99fuAgoj?=
 =?us-ascii?Q?HNT59Kmhw1xlca8Q2/zfusol/u1K7doy7ZibJF0ZnZNNnrdf9I7Q8c3xipd1?=
 =?us-ascii?Q?xQNKFaF66K4U58ho86ZYICFeaYuxrPW3fCn7LFlX8P7Xmn/e6HSTmyN50+Mo?=
 =?us-ascii?Q?P1kjgh0Tck8LnX12E1rHmNFFSWHH4sxZg6625aKhqhVSI+YVb2+tscWWG2GT?=
 =?us-ascii?Q?Dd4iLSlmk/ckFwsmM9fXP7l4lqaC3yIbIV41M6yE3ITvtpXM+rNqtgxszXZn?=
 =?us-ascii?Q?QtEDCxlh5UKuMHEI7NIsjduJEIBTe8AgFNNZvUscUI3NhuEHw5Aarf8ZuAr7?=
 =?us-ascii?Q?X613ZJoFRZF/CA9dAplGCPzq8PpEYiuV8PzgPeNldlUzj1oI+24ilz2zZ/bx?=
 =?us-ascii?Q?ujRQDbj9JwRVGRHnirpKJd87ChzNkyF/XXI+BLsy0de/+0i8nuwZqb9JQT4c?=
 =?us-ascii?Q?eu5aXv6/+Nwfv9xSNVU/px5I1gScLoZ3/Ky+4KPTsaDy+mkzXqjAx0Boqxgl?=
 =?us-ascii?Q?3u72TCiGpc8vBjRnRUe8VbX1t4mPHysTJ29o7l+gBKSp895eKU/aZxH4R57f?=
 =?us-ascii?Q?TTtu51uZ4ZaBk6cd0ECds3qiqBaZKdO7Po5mznfzRU49KePCnsS//5U7ltEF?=
 =?us-ascii?Q?5kbr8rSpKfHSwPMgnOyT2lkKxZ2bOAM0O5vhFqI+LeQ0QBj3VgEnMXcpvajc?=
 =?us-ascii?Q?h3N4MQY6gE298t6SZnIkK/gN0B9u4ybgw6gmMtY5xAyqIU4QzIWQDutmOx/F?=
 =?us-ascii?Q?5JBAQWXv97JiqOYvb6QR5pFMu/Iy+28x2iJghq2738X4ZgKURchVwXExuZ3I?=
 =?us-ascii?Q?d7aT9ErQaIcQC+im0JHLqDK1NZyrrdkXcNPJID69oNw5B6rTyLv8EO/zNmTW?=
 =?us-ascii?Q?n+xFzOF00gdWUzHtsfO0wreanjjQc5ntNLQL2Y7n4iuCzlD/O0oUyOrsX40+?=
 =?us-ascii?Q?6K964a9E5ef+uYj9XmRlW9UEzpNysMT6PQbZkeWAQNaGWV7FORkWWHi4OkMT?=
 =?us-ascii?Q?MW4bW/5IhjLZjXAbTL63KVlf7jjHszI2k3LEXUst5gDm2G4E+8dLBqNbHELG?=
 =?us-ascii?Q?4T9VqTeq0xR2AzoiA2+4Hx99cSnOWBOjqJ3Jz59gK0Vub0cghpKfzJDqPmHQ?=
 =?us-ascii?Q?T9a/QNZ76oyWwHTLwZxuay5ccOhvWD1TpdWa41lT6mN69oRhjP7Ao02lf68R?=
 =?us-ascii?Q?u034stKeuuX7mrrS/ci32wIz4n9kpICoebm+YxKHJKXJI3ZagFte6PkEqU6k?=
 =?us-ascii?Q?Hb4A8d3/Qagf1HGuVOAc2YSYKFEe/tL32n9Xk1uxZILNFTDna8wfpAH9lgPc?=
 =?us-ascii?Q?vv2UZgEl0bNAHGmqQPBj9hOutDQ1ArtFmsbMNlfJLWqy9JO05xt+UNWX71DO?=
 =?us-ascii?Q?4OGWYt6VXH1FcTCnkAHSBp9Y4NIxOVu1VeY+WUi/?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a8320e-470a-48df-e3c7-08ddaf050ae9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 07:43:55.2468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LnpIKvXkJdTkVszFIR6PurvXxW1CmUkATf9qBHH2cieMdTjgVDBlb2hhwzBWZuJqXqvDh7EEK6pcIJ3PQOk0gQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8685
X-OriginatorOrg: intel.com

On Thu, Jun 12, 2025 at 02:48:46PM -0700, Sohil Mehta wrote:
>When using the send_IPI_* APIC calls, callers typically use NMI vector
>0x2 to trigger NMIs. The APIC APIs convert the NMI vector to the NMI
>delivery mode, which is eventually used to program the APIC.
>
>Before FRED, the hardware would ignore the vector used with NMI delivery
>mode. However, with NMI-source reporting, the vector information is
>relayed to the destination CPU, which sets the corresponding bit in the
>NMI-source bitmap. Unfortunately, the kernel now needs to maintain a new
>set of NMI vectors and differentiate them from the IDT vectors.
>
>Instead of creating a parallel set of send_NMI_* APIs to handle
>NMI-source vectors, enhance the existing send_IPI_* APIs with a new
>encoding scheme to handle the NMI delivery mode along with the
>NMI-source vector.
>
>NMI-source vectors would be encoded as:
>    APIC_DM_NMI (0x400) | NMI_SOURCE_VECTOR (0x1-0xF)
>
>Also, introduce a helper to prepare the ICR value with the encoded
>delivery mode and vector. Update the guest paravirtual APIC code to use
>the new helper as well.
>
>While at it, rename APIC_DM_FIXED_MASK to the more appropriate
>APIC_DM_MASK.
>
>Suggested-by: Sean Christopherson <seanjc@google.com>
>Co-developed-by: Xin Li (Intel) <xin@zytor.com>
>Signed-off-by: Xin Li (Intel) <xin@zytor.com>
>Signed-off-by: Sohil Mehta <sohil.mehta@intel.com>

Reviewed-by: Chao Gao <chao.gao@intel.com>

One nit below,

>--- a/arch/x86/kernel/apic/local.h
>+++ b/arch/x86/kernel/apic/local.h
>@@ -24,22 +24,24 @@ extern u32 x2apic_max_apicid;
> 
> /* IPI */
> 
>+u16 __prepare_ICR_DM_vector(u16 vector);
>+

This seems unnecessary. local.h already includes asm/apic.h, where the function
is defined.

