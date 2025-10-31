Return-Path: <kvm+bounces-61655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3707FC23C57
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 09:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC34B1896F0F
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 08:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7752EF65B;
	Fri, 31 Oct 2025 08:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CfMhcH3X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74B2DF710;
	Fri, 31 Oct 2025 08:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761899101; cv=fail; b=PTfdDv4Yk/AjY3XsqrO2Qg9KhT3/l3bBReNQaYGlf6+FwkeZqQt/Mgpwlnl3MyWL5ugKWALP0ebbqoEEODMZxxjr1V0BbqOWkAyC4IhuVNKVPo+wlkhDf94NE+VKDKiu5aDcWZIWx5ia4wA8pOZ+yX3Dp+xD20DWQ2qNkLz/K4Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761899101; c=relaxed/simple;
	bh=jhVoyx5hpbLpdyiXisEXDVUYNHPJEsfLNdX4ghxf9ig=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZAAqSpE6HvdvKwWZy9ymeL8JeSY7l9dsfGJV5AjtJCDjEvGL/v8+5NsX/9iRfFy/2UjlhnbCYyR3FzXJDlVRIuL2KI9tB4sMEIO4DDha70QeJjdkKH3PDwkdHmC/tmbsP7Z8Wp2q1lQk/5dRANgzP3LNNSObg06BITArBlW3iU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CfMhcH3X; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761899100; x=1793435100;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jhVoyx5hpbLpdyiXisEXDVUYNHPJEsfLNdX4ghxf9ig=;
  b=CfMhcH3XhWEc4OfSYTsYBwlCIw+ml4L0b5rOsO7KGo2EI8WxPaN4lGcW
   okJSY82zJhsnxKTTU9NN+Ie51qCigsxD3CDFjhSEmOd8C5ovfIqPuWSyZ
   V2H0Glz4b1GWTGI2cgTnGo5h8SM06Twjp0tSjnt+clCe7ctrX+hgvwmnc
   oCtmJxzBojrblmHATMNCClIOkpkLBHEuCXRq8/ilf9DeGKvtq27UwYut8
   ZLkLlIN94KLosl2DTOWYRJcLZYEBXEZ4cmgymokkJUtdVntum3Lw+b9hK
   pfDU3hvz9p9zlrd61Kob87CbHzt9pyRHFHf0WBewmHclRxqTLCwUe5RU4
   w==;
X-CSE-ConnectionGUID: tmMw3RyJQfKtraujrrB0pw==
X-CSE-MsgGUID: qs7lW7jDRZCZaUEe8dIWAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="74731019"
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="74731019"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:24:59 -0700
X-CSE-ConnectionGUID: fLWJYXoOR0mQcvlXcmo6Bw==
X-CSE-MsgGUID: mDJJe/rITAO4ixmg6lBuYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,268,1754982000"; 
   d="scan'208";a="217014059"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 01:24:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 01:24:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 01:24:58 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.19)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 01:24:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WMbFw5jRXrdSpA2GpRriVFCQT0Q3YpEgEaMap0HPBMBSKEiYrpPi5kVK8aZKYIFvxoFvNmQtQlhUDb+hGp9ixDXspuTMkpmfK4JaPeHXbjPX5Z0JAjyuHtT85O4OeF7zqLQVeEk15FqdPmelfXhbJSMUKjpVN33lSEm6C/6L9nArd9TOLLbqlpXhEV0CDqGuH2R32iPQaA4J7ff0s/jhk5bNToy5JwxClFQn7CVz1SO/N7BdnmeWVUEb8nSFUGzYBK2IUC72ubY9q1TdhUatigh6gci43/qYeNsRT2mOm++RMHB6yW0SbQdr/oSJBeJPkfkbd7ocMcCzrglYuJXyuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dULCWM9yVulwgW4e+uInXhNLEifNoGIYoC2osjhDyWw=;
 b=JIm/clRu7L/dAbGGHAEOJOVm0Os3h3M7b8olB8w94lhKeNzxa92NjpHWBtBNPH+H49CcvmgzN4E5hivj21IgU/kcNiaaJNUgAjktBQd65/f0JtDiRq6EVE7MDFCBrrv16ddTsKaD1ppqglcgpAe63zsyII4TA+FaB/9Oc9E+VlLH5mKTCLOXcphq4x2eTmw7WMxVdZG6bcqthZLa3TNesMBCI84xBzMuEOMMfVJaXechNvOZmGCGR8sJcGu4FqMCYfExCR7zqBAIRFDfWYbDH6gDH+oefc9Cxf0GiSCVVU7s1tmu4ibHAxn4tdChZwM3pgnZe8PgrTfjE9yDBJP86A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS0PR11MB7766.namprd11.prod.outlook.com (2603:10b6:8:138::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9253.18; Fri, 31 Oct 2025 08:24:54 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 08:24:54 +0000
Date: Fri, 31 Oct 2025 16:23:22 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan
	<maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>, Paul Walmsley
	<pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou
	<aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda
	<imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Kirill A.
 Shutemov" <kas@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<x86@kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>, Kai Huang
	<kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Michael Roth
	<michael.roth@amd.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, Ackerley Tng
	<ackerleytng@google.com>
Subject: Re: [PATCH v4 10/28] KVM: TDX: Fold tdx_sept_drop_private_spte()
 into tdx_sept_remove_private_spte()
Message-ID: <aQRx+lssVZxYLbFt@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251030200951.3402865-1-seanjc@google.com>
 <20251030200951.3402865-11-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251030200951.3402865-11-seanjc@google.com>
X-ClientProxiedBy: SG2PR02CA0003.apcprd02.prod.outlook.com
 (2603:1096:3:17::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS0PR11MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: 0955e144-f205-404e-30c8-08de1856f810
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?pt90xpTyjZBQ3fupttSpySF5LYVA/nTjhTCXI142iSBlYabU/pMl7sKeoU7a?=
 =?us-ascii?Q?zoBF/QNJKzDxaTgtugP9MKOVG9GtEXyJFQF+mYRYS7glhbIQRNnRV+j2ZJ3X?=
 =?us-ascii?Q?T8MzqSyHvMhh87a6wDXycVs0dudL6YY9wo3k94UsTHsdFnWgaveu1GmNQh8z?=
 =?us-ascii?Q?at/40NVu7q5u0Tqmep5t89y/xL+Ps3Snw2lV+qAUmTaFLeuO9+OMhSke2QYI?=
 =?us-ascii?Q?1OAPRa+XLQm9h8XRd1Hxup0NCWCNpYXZ8Edwuf+d5HapueluGNAGXbIBp4Fj?=
 =?us-ascii?Q?ZDG9iRRfdsK86J4IWCSTJMUqHIDdnYFwY9RE3ceNJLOPBwt4JAKpoQASmApY?=
 =?us-ascii?Q?Um3x9mY2PinHlYGOwfvfH8MY0B3EEYUS5s5c5jkOfo0aFm6SgAs3ROOEBR8s?=
 =?us-ascii?Q?twQvRTZ5pOSZG/Qj2qJrJSdz6kv8JYXBrZ6yba4st1WcJIIHXLajdMZjt/g0?=
 =?us-ascii?Q?2QuYsg/hvHQLxqs8mhtwAqA1tqAVOSIkmsIYMjPDdyDUuDEtEfz+HJ56/WlW?=
 =?us-ascii?Q?ypp45Om+nIyajNr9VSfnJlEqn0YQFCIr48I+XjsoEi20A0O+2ouH3rx/xLoP?=
 =?us-ascii?Q?i5suKkGmJUaNIAKjUzfD03bFWOVpSCSL6DFnG8zYGAoGbJ4hjcG0n1RHLu/t?=
 =?us-ascii?Q?UN8mVd0x8crpAA84VD6xw8CQbuT2H3cGKao2v8Df9LLtk+cdNcfmpbvgrCfw?=
 =?us-ascii?Q?mDD0cGhd8RiTU8ZyxrT3sNyexo9qgwmjnoSMeY913xAQ/ysWYje2VQ6PYo49?=
 =?us-ascii?Q?Kog51GLhpOXlcz4P4Iu4SOW06kV682tKUl87VPQ6EABWgYwp3BX0rKI5e7lW?=
 =?us-ascii?Q?AbwUEWFomptaoCThbTpw0L0Rqgc6BpPNwjKFmC+BP01bp48xLY4uB2XAF0Cq?=
 =?us-ascii?Q?u5nGsKQKo0y/ZlSgiotNGzos8f6a+yltAs54ByD+IWpmT8rwCGYT05AKjKfp?=
 =?us-ascii?Q?S1uqNIoE+I41NpradjbsxFgjmgjGWk3l3gdafEEVxStBqg18q+AuavL/nxON?=
 =?us-ascii?Q?7JO7lNBdpCuxFL9sscFe5VDufCHVEL2RFLdFjUPhxf9sskky4ZsvIBPsLspz?=
 =?us-ascii?Q?nD5ggteq0CZ5eCpPZf4bz8D9CBvY09gR78RKnewEEtG2XmijKIvHZ1iW0u+H?=
 =?us-ascii?Q?TX7jY1kIPp1E4k+uegtrm3mHU+GhhCzngJT9Q+zM2yHVMRgDkbD3WcVrYVNY?=
 =?us-ascii?Q?zo55cDRUL/Y6aL3Kz1qMPx9IILvrq7xmx19LY34bmABiZRjf9dRm7Khahzez?=
 =?us-ascii?Q?WvfS+8/nTyHqHgPuQ+4nO3/qYbVEGqllcd/6Hw0M+FIL314GrJfsmwVxmpCC?=
 =?us-ascii?Q?UnxYKOjbqB6gxas6XRubKjNLZ2byW5snMiCis+HUn/ze9vCGWhd7EYkS7007?=
 =?us-ascii?Q?uHc631WLyGvGlFdcBEDtnjNaupkx2YOt6wL3N+2+w+YbZxXHaWyfDWAvx5YA?=
 =?us-ascii?Q?4VDxafru/yaJITy9F671EADe/h/TKRb9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TjhP2nkPv6OutqSnrNmxzGqOSOJVAfGaOVCcbguYiGpQ0bfbq6roOtPXbZxh?=
 =?us-ascii?Q?kXfsqA+G+bpedH860HfQv0jPx5WbFLil6+qvdhs7bAq4yueDogx86/WOe2QV?=
 =?us-ascii?Q?V9/MCGGNBXiqJWB8FSG62kkwxtAAJe1tL98SKibHsFshUbcZcPlgyQuRO/21?=
 =?us-ascii?Q?47hQqSi2DhHnYoGWUbM9WNhH35yf+5+QmrCg0puppjVlSjJzlT5EdsQSsuwp?=
 =?us-ascii?Q?yhsdPg9mixoZqR7uzgW3HTZISGtwM0mPKROgsWPs1oQZ4NuVoE1u6RwmgPp3?=
 =?us-ascii?Q?V/tVHna2ZCGZyecTOyGn0n5w40uQAJ5ZTo3PHvHqaDCGUNgP17SKZ9AeWz7O?=
 =?us-ascii?Q?+eUhveB2I3suz5uawJGJevR2//taHbMHyygtohNm8YLNcc5r7W18s/mEbqx/?=
 =?us-ascii?Q?3h1EnZkyKn1tHb4k0TiutQvOI4a2CQGKBbzgnfCny+nUv/k497opVZ8ONXo5?=
 =?us-ascii?Q?NQYy62VqHS6j+HQEBJTa+ZFy5GFQxdsBqdO7Sf0O6WGbJ2PtLEXy7hDjIDmE?=
 =?us-ascii?Q?v9ywCWhs3aLs3YfD4lpbVR0RoYW+q7aU9lc1V/BLtfVpfouVZ5ikhtU0AG/R?=
 =?us-ascii?Q?U2VEtJN+LY9kt52mBKnLQVoYKivM3Kqf+SBcvCsDTgFr7zdoO5MMcJjtDNjV?=
 =?us-ascii?Q?zYLuWtQCGAPcFlKaZr3BEQ/HdUi6pTph9Xba/iZfR+9Ck0VlbW3RPXNJE+GJ?=
 =?us-ascii?Q?cDQNMp5eTRQ+nkEGC5uG0r4ghAjhTsDpmKPPPw7QpqvGA/TOm4GPmnkvHVA+?=
 =?us-ascii?Q?F1d016+7AzqLMnebnF9WnMSJMInu3qf6iGuq1niqt7lfYx1zBHDJCLIv4+7V?=
 =?us-ascii?Q?ei+0fgCGrogMK4vp9YLwDuXDlEMnT1hSfTe/rG0mjadT6p+B99Dgf4a11zqU?=
 =?us-ascii?Q?oIc9iNOB9UoHIkeHHXOqHC+37LvdP3PmLCeX+BDcqNkCP2ImvTQ+lyXXCiI7?=
 =?us-ascii?Q?mXpRfrgj1INY1siGrbR8BBTIRWepzHhFOG9YkACxro3yaZ9vOEEkjQZ7Yss0?=
 =?us-ascii?Q?POrSIlkctH9PZQqlfNaiL8rg13k2npCYZoTw/BqgOOKZ1LPJ+0BM75YC7Ghf?=
 =?us-ascii?Q?5MsX/+87fJV0x21Im+j6zEFIlGm5NXYNL+llIvT0gryvt9XSyKIODONFb+0T?=
 =?us-ascii?Q?6Ay3kQq48N6bYMePHkPorxPLB0K9xUYlvT1SqnipuT+8YlREkc3HQ6eKr/7e?=
 =?us-ascii?Q?DKHFFBwgJC5s1W34rqtD7HgN4hgBCnHxvK7/Ut/C5lxbSqTV5KoxKzYNsECB?=
 =?us-ascii?Q?Vd6sgclhkitVsTxLuoDUvp7bwY5FM3YrHYmieRpi70OfEGBmf7iUZX9FPUqQ?=
 =?us-ascii?Q?xXt9dLfgYDnSUEroQM5jUgzQtBOZc3gXNQFtu7FYl2CpXvZcWQCDvZnhaZGP?=
 =?us-ascii?Q?0RoWgIyBaQjoqBfDvjXrk1YLx3wUrfySyFsvakf8a1mQfb62sYIO48V4fmfK?=
 =?us-ascii?Q?74u/bsCai27PIX8QapIAZp44Oq+yLD4kdmJ6fIP9ZFgNFGt3wMIcq2VuXChy?=
 =?us-ascii?Q?/wtSx3gzUa7QU77n0/VpZidZ7Ad55QEW3u/tbQDFMli3dtsrEJTNy6jlFnpJ?=
 =?us-ascii?Q?aQeIhFdOefPTZJE7kur1NSln+utiQ+glup0k/wY7?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0955e144-f205-404e-30c8-08de1856f810
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2025 08:24:54.3201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9J9VJDd3eyrYR2o9cyj11ZlQ/sP79esP4krMRl9v8P+TywJVinHgLjsDa7tPnk3HO3F7ZFuwxceWgiF4HEV7lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7766
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 01:09:33PM -0700, Sean Christopherson wrote:
> Fold tdx_sept_drop_private_spte() into tdx_sept_remove_private_spte() as a
> step towards having "remove" be the only and only function that deals with
only and only?

> removing/zapping/dropping a SPTE, e.g. to avoid having to differentiate
> between "zap", "drop", and "remove".  Eliminating the "drop" helper also
> gets rid of what is effectively dead code due to redundant checks, e.g. on
> an HKID being assigned.

