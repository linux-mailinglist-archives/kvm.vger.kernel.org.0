Return-Path: <kvm+bounces-44718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 29A34AA055F
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 10:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D64DE7AC8F4
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 08:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78920288C92;
	Tue, 29 Apr 2025 08:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kJo+CKwF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD875223;
	Tue, 29 Apr 2025 08:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745914702; cv=fail; b=lpqIy/SW/Ms0Fpkm69j2uNUjlGhRaMn7NMvFvMCWgDaXd+aYmyx2NlN4d7WSH9yKkdZZgokVwyuIKglXr4CIYfLFYb0mo9RVq2QkEo23weVwIxiuh19JWDpjmNBjSVqCsF66bdSqYXkNQmbE3N9sqMyxxtTug4rcJcKgyzvTRdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745914702; c=relaxed/simple;
	bh=0Zkl2BQm32NEuyqUfwPXBmAbJonB/31gkQLWxE51vsk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JxycBTGTYNseCNjGqdl0rTqtpLGAsTBHenC8QKqBWl1r+BU/arjzEgENeM76XFoMVnk4zWLu54q2R8BimGZEm53e8yPFjKU7/m6hso81CtxTAUg1UdJ+3TsNMNfbUiWY8B2OaB8AXM8EN8G/IMCpjMMLjDTFP5LxdzBhROtFVR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kJo+CKwF; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745914701; x=1777450701;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=0Zkl2BQm32NEuyqUfwPXBmAbJonB/31gkQLWxE51vsk=;
  b=kJo+CKwFLd+WfIT6NprpnrkWZuY4dDh4vGA9x7N1CN11gFv2ltnhb7+6
   uEaZjH+ktyWd0QBSW9Ng3wPw/tXfLHzGFZOkeueCy/C59ly5CuT12mleD
   TMckCQUeRfhrJVk7O+Y+cY10oIIwAfqC+BSrNCG8gXyRBipcPq0NFNWkY
   pZl6htpAn18xxGp96/mz4o/rRlNns7k/dmp57auXaFI4RuGYSVsCl9pH0
   O8y8Nh7wNmx9YAVDUGi9EARIkmYA5YTDzLnsjAqwPEwa9ozJw5OutkSgb
   jznXZ7Ei31MCFrwB9D7f2qr/QJVcNhis32Uug8BKRXCfkyq7/5helUmBW
   w==;
X-CSE-ConnectionGUID: THX/tpsdQ3SxFbcgXGirtA==
X-CSE-MsgGUID: l7T1L7mrREuPejYbtbwDiw==
X-IronPort-AV: E=McAfee;i="6700,10204,11417"; a="64946105"
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="64946105"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 01:18:19 -0700
X-CSE-ConnectionGUID: PrizqI71SCenR9jsF77KHg==
X-CSE-MsgGUID: Lv8Mi+lFRWq0CaaYw6zrqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,248,1739865600"; 
   d="scan'208";a="134072754"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2025 01:18:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 29 Apr 2025 01:18:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 29 Apr 2025 01:18:18 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 29 Apr 2025 01:18:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kxCWrn76nIIv/yOu+XwdrXJuTt01WkgqSwa8KXboVm3jrvJN+ggpFqf8aVf21h2dZEUSqSZ7QvYj+zTvdumFx2/EA5ue2dlq1WHBgp//58tCII1m6qjfM/CT7Dya453TMiHRiMwpGg7jXGVU9DbTUsxcgESF6AHVhJqHuyNVF1RjcYLSoYEg91Oc0bOxzsDIYljnOoJX7Sfl73Y6DoKsdlgGq+y5NikdkgoGRVkHM2GtVhrGPatxzLdh5QCFi6tlL2CuMPvajz1VuBB0VJPElAoWisaV3n8Dq93fVPbu37KkeULRCTX127Jb4UF09gjb4dIgzf7bqkbp+w9cP3sNhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyB40PPj171jp/4rG+DhdE9HDTiW8BzXQTT+iwhTLcg=;
 b=wSmYbPSFTCapHbodKh6yhcCpBRyLoUT2Quaok/KnJFi7JO8r7pVvp4UFSxdOmKlvRe4qe+R9+ETHq0bUw046sbSMDTOdC3kbQV1Nyk8ovSQ07GCSomfA4irKrKGiXolq6OcUcu0xkoLb77vPGXtRSCQyQKdUoEJiekscPOCrcBi40fdv7LHD93/bv6OCGdDmX+oLkZdAUrd/7Q2LRUoPF6440yzrFv84iat2H9ZQ1/efjIDXSJ3JzB6g1DtBj+SnalS86TKRHGFRAX67FJ3/ibNmFFW5wgPRE3DdCJNn3lofKXhkU1WrwhjSSqzzPrxuG5uXNAxQWdiv75GlFtwMfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:432::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.31; Tue, 29 Apr
 2025 08:17:33 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8678.028; Tue, 29 Apr 2025
 08:17:33 +0000
Date: Tue, 29 Apr 2025 16:17:24 +0800
From: Chao Gao <chao.gao@intel.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Binbin Wu <binbin.wu@linxu.intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>
Subject: Re: [PATCH v2 2/4] KVM: VMX: Move apicv_pre_state_restore to
 posted_intr.c
Message-ID: <aBCLFB7BS/vhSAuk@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
 <20250318-vverma7-cleanup_x86_ops-v2-2-701e82d6b779@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-2-701e82d6b779@intel.com>
X-ClientProxiedBy: SI2P153CA0006.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: 0cd78073-25a9-4809-6ac9-08dd86f64ac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?SfTa37IA126of2iiHlHE+ILGM8AtWTzI3KJ4NE0pYkPG/11IzMoMhhmyjhWA?=
 =?us-ascii?Q?iqDO20/h0HQz+7hec5hxTBkwm1Ud/j5KO9eGuLxo1Fd5TieBxloVKtZBynhY?=
 =?us-ascii?Q?X2avK25FWoNTGDArxowKv/uTBg8uhGsWXh50OXOw5K1DSgAIGH9TkE28tw1l?=
 =?us-ascii?Q?1b7sgOMdVUXNi1l4+Od6XvoQC1lw+c4JxrYTAihPILxIVLEf7rlriW22vbZ0?=
 =?us-ascii?Q?gVYKsuYF2m5vxkUtxXu+cjoQezoXeVHtP02BoCV0qrmpJZPw/LFC5PNH74Zp?=
 =?us-ascii?Q?PYCgUZvUpHva3n1EQbCAGaaGGGtSckALjEvtMB/XlouJvKTqwNhpmVvrrdZI?=
 =?us-ascii?Q?BuKRB5hDeBINibpBXRZO0GboDNnv0AHWQomfeA+LnlPq1qp+2JTgFldBsAyC?=
 =?us-ascii?Q?nR/xZ/Z41v3tQZHDd8aWAF51zyMq30f+5WxXZu3tMvdrU+t/+2fni6FnSi7g?=
 =?us-ascii?Q?r054Gx9VXFJpskeJBzrDxW8tKx0KiWDkqLytSrZ4OGOYYy2X1R/0O1lVsmTn?=
 =?us-ascii?Q?WBvJWcnxNoQcBOQWzJa4CzzJI6JNPW3XeUb2eAyDoYikRAsyPeDJKrfkD8Yc?=
 =?us-ascii?Q?P0NjXfuczA7oQTKywAJ2X2WdKuUk6YkmNpGI3b/Wspu+d3PiLMQO9wSHZbzv?=
 =?us-ascii?Q?i+wjKy+yvgwyq/4swWj6LUr+m+Bqe8JDYeXx28z8Y0mTo1LBTJxH1y1CaMXD?=
 =?us-ascii?Q?MB5/kUYxxR5L/hwxsxztiQr/o+SnIcqR0ekhdiCsIbYde1FH0m7Xw/W/l/3a?=
 =?us-ascii?Q?IU5K0w31pmRCSA5fk8wWuIgf7k1nwynf3UMqdwklBWWFpaSyBF6+L0y81ynP?=
 =?us-ascii?Q?cDSad8IohCMY9qksWexVwp2BtbMasmJofScbIIgS2bPI2O4ciKIbIq14t3pB?=
 =?us-ascii?Q?vyS/C91Mso1EVQPymHHqZPJ00fX57Pgi/0mqgLJ7G5JmvUNsazqtjMeAUMoZ?=
 =?us-ascii?Q?kcBMjkmGXdQso5zjO7c9cgEOyFYklvNf6eV4/Mktg4KKQeMpmxxWAfT+29rw?=
 =?us-ascii?Q?+RP8dIdy/qWdPpQc76VFfzKu+nxDLhTNCVXh+4VaqtoeXguPsmbiCXjgRWQe?=
 =?us-ascii?Q?+mdcEFvHJwdQiI2BJTZgJPLzBTQZje5ce5cWuQxzFZ7ZSlIyhyBzogaH+EIW?=
 =?us-ascii?Q?0DcFlzY9tcl/giN77zNWuOimqquI8yOfhH8AvsEC1Xn5oIuOJ+HZK27+bnXn?=
 =?us-ascii?Q?hhuLPkoegJg4HGlc5oFQThBiPILQ+DwRMrzeuMBONnOZHaLar6QqymW19iK4?=
 =?us-ascii?Q?7ZLV3CmU/E4RDBQGqJ5oeP1XhLhStvscyJ1hKBThAKk6Z2lvUXXde9/76jcH?=
 =?us-ascii?Q?407SpYGpOfm+iXttIhjQWLVAnMEyWj/QlBbm5cwx0ygkkMYVZMHQsW8+DWgY?=
 =?us-ascii?Q?kSYyLOkgnoxwErS8Jnssmhpnyof62lzsmBvp0FBgus98IuLC0Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?05sfK4ZHr87mVTfK74v3h3yuvF/jYuvo8S8kDKbJ6hM0GwiGcH8yMBGo4bh2?=
 =?us-ascii?Q?B2Ww2KoB+Meoby1gx4PnVssyyxHy9ADj2dNMqOSssSOWhXe9+PP6dj6SzoKB?=
 =?us-ascii?Q?qMeKpf9TXjD2tGr3rqcOHoSxgj0JitLDSHFgWQtcFsRl0AODz3K7gOg3troa?=
 =?us-ascii?Q?1JkEe4dTpILfnsCVM0OIj2xVeqFuO+qqSjYPC4AOVZlua0il5zF459JQ50dt?=
 =?us-ascii?Q?fKhWzx1aHqmVkbrpkpCkn1kYT+tVLAcbWgOcpKoAW8f18giJsyXCrzDpXrPy?=
 =?us-ascii?Q?aKzKH6Ahbb8f9E685LvVrB1iviogm/x7qigtQM3QZWDzss9JZnMN/Xt96GxR?=
 =?us-ascii?Q?zdj+LBSfn4WeBXtvkfkv9RGADyVeTNGUBhzQD+pFkS+9tBCUwfEd9ZnzzMuk?=
 =?us-ascii?Q?tFoq3eeWfcGAfUGdANp50mf1xU4OCLULkgC4nTfGnpdstqW8sg+vSO77i4z3?=
 =?us-ascii?Q?LKNIj4dE2jXt2ZXV8bpV1pT2gSIimAxiORmzBVu2EsnOeLUm8kyEFZjeuwUV?=
 =?us-ascii?Q?DF2g9EIstqN7wTZ50scwTnAFN28/+4i9TfdtPJ5oUCdAo2a5C91h4NVfLvvi?=
 =?us-ascii?Q?8IIgRCq2jWoh/O6jhlThdVFa7ZZPqJorrHpwWZIuikzeCtrCWDL7Jlmc2K90?=
 =?us-ascii?Q?cW1Hgd0VDGgmxRzfryK7sdETOvNCs+ntweAlukqadU8RIgvrq1rFAJxsJD+i?=
 =?us-ascii?Q?aHZs0dWJPrPyXNulWBrrrXHdfscCJZyrxwnntiij0T68tIvUANuOEMw8Old9?=
 =?us-ascii?Q?cPPlHUIuDRUPbQ0k0Mo47MbEddwOQD+W5KUA+HzF5GAfKaVENw+Wwk22+lYG?=
 =?us-ascii?Q?3Bhf16dmE8ePyZvVrIgdPBymNIwMzVKPNxwGKbOsgB0+IwHIeE9wZdocGnXO?=
 =?us-ascii?Q?TNyDcOtGlxJjJFlOGlVJZKWLnaRkxfe6Q82YLIY4njfh3GvLRPCX6l9f48rB?=
 =?us-ascii?Q?9ZG6DYxBejVIBq+pdjT3WkMNYVNgbVy0+vqejIWB1ra9F4439B8o1TYIWcSs?=
 =?us-ascii?Q?N2jNE76iwVBo27wClWasvwCzq3wnPEhC/ymy8mxSUeHpBA9Y7E+CIS+dnQIf?=
 =?us-ascii?Q?27CSYJYZK1yqQ98ZrPih8fcyfkdBF4WZ3fSF1xldOeT1G1wCb6RlHtoM71jA?=
 =?us-ascii?Q?8RTPFGoYPnVSth6iESNW5zrMpve5X8nQcoSOMEPTyJlQ1fJR4dKXJMrHIeqP?=
 =?us-ascii?Q?3AioQxs3MvkOT205n1qyUJjngichk59Stnyah+EsIMCIRSiZAA9xIjlWkzpa?=
 =?us-ascii?Q?3j0+oEmSOQSs+XtWvOXmsxksZD0jRkipDV/gnIMH5FeDXbhJAarislgu7bHb?=
 =?us-ascii?Q?kH+A2GYvBWubvUb/3A99rSVByu2frMDCPRVKODSBu0aeCdDVUM/pLH5js06t?=
 =?us-ascii?Q?37u7rTflspqXasvRyqBXrzpy5i4mR1sqIF3VeW0Xb8uIIu7RCgWMOzusPgNG?=
 =?us-ascii?Q?MfaOIzV3BOWVFdGB7CSQ8wSSxpD94pioh75slsPFqGUBgmj/JYRE/l+IqvhA?=
 =?us-ascii?Q?LxCXr5A9iolvDQq4tKMDrY1J0plCfXyjM+tyZc06E6mp0T121lzDa6Y9p+Tz?=
 =?us-ascii?Q?vdaN87fhKcdjkj4nULtOmGWMd7NKux/3cuin/Ano?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cd78073-25a9-4809-6ac9-08dd86f64ac0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2025 08:17:33.5113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8LzM4yU3P+idmebK/qogqyxCD11J3GpTidl5+rXCEKNuQHE7nIk69OSqRikX7lPBy8C2RzvH00QZGw3Yc/v+YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7185
X-OriginatorOrg: intel.com

On Tue, Mar 18, 2025 at 12:35:07AM -0600, Vishal Verma wrote:
>In preparation for a cleanup of the x86_ops struct for TDX, which turns
>several of the ops definitions to macros, move the
>vt_apicv_pre_state_restore() helper into posted_intr.c.

This doesn't explain how the movement is related to that cleanup.

how about:

In preparation for a cleanup of the kvm_x86_ops struct for TDX, all vt_*
functions are expected to act as glue functions that route to either tdx_*
or vmx_* based on the VM type. Specifically, the pattern is:

vt_abc:
    if (is_td())
        return tdx_abc();
    return vmx_abc();

But vt_apicv_pre_state_restore() does not follow this pattern. To
facilitate that cleanup, rename and move vt_apicv_pre_state_restore() into
posted_intr.c.

>
>Based on a patch by Sean Christopherson <seanjc@google.com>

You can consider adding his Suggested-by.

>-static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
>-{
>-	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);

With this removal, vcpu_to_pi_desc() is only used within posted_intr.c. no
need to expose it.

