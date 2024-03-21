Return-Path: <kvm+bounces-12345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1F7881AA4
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 02:30:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40F2D1C20E92
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 01:30:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACB24A2C;
	Thu, 21 Mar 2024 01:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H0bvk76j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE8E10E9;
	Thu, 21 Mar 2024 01:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710984630; cv=fail; b=Xn6Sjj8BpLFlpW3Qtu11nmpGf6p7+A/lABN7JiMS/KgBaUHbzwh0KUSTWo2PZhY4Jkj+6BNcxTW6EPDruXIv+2qkhhmeMSg+or4YpXdzlmwa7BsJD9b+S2WowzaECX81bUSCg645wy2CPS3FA5Dzn+VirtEEDkXrfS1pvHaiBDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710984630; c=relaxed/simple;
	bh=c8P7Ek8DQHElb/4B6GPx+7MyAbWEdRDlOSO6yqWa+hc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LcuRP+oOw/bEdfaxMArHLHe/gGA5G2MNdVdc9kaoy0I4O6W8LFPzrTi03vT53jirzqyriplqhZyTloLV55XjFu26dg4mR3f23S5RJKEEsRDwtNpOGjmaYL6vekitxddvTAZ2E6BrS9g8xA5MzPDLZHmz+eqF64f731XaQlkwNuU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H0bvk76j; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710984629; x=1742520629;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=c8P7Ek8DQHElb/4B6GPx+7MyAbWEdRDlOSO6yqWa+hc=;
  b=H0bvk76j8t9m0ukKlnNiZmLtTk4wafy7I2AxCkXzkibfHfOkqgHEBy1K
   2XyGxH3rVcXGQgd0c8jdBKKVMUECo6mzLY9N2lbUtQYhoZg7mh/SwvedT
   jWP9z+QXv/ARb7ru/h4WynW83lT/+ve8phQZ8w56eHKfzQWWSDTjLNz3O
   iSuALwTXkDmh7HnLn2e00lGsk//yUMm6/s7s46eGxqkqtXHyoCddlMP3V
   d10LHCBkXy7nnP3hTBP/jukuS4NCfNXCInGRjT+DI/bejznAYADAVos0d
   X2agkX0xA6BPUhyQ4Nz2URtE9DEygrCzAKoqx2EOln1/El0bLWLhn/oAF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6065236"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6065236"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 18:30:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="45327867"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 18:30:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 18:30:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 18:30:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 18:30:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPDfwXGuvY0TgDmhLVVJmf9VUe1iBSW6N2q5+fsZp9iTst8bGgMOARzcsxgyhvN7kIXBut1Pcz8z09ntZoIz+K72PRQ93XAugMloUDELXUj10kdr4s/vxDX2YwXgsVKyEpEONIgJ+jXhFhVNADv12cZq3WcCSWfdY80Fw7lvePvQqbiSoSupWctulBw+h+WZAnTs1NAqMCVtqHD6yW4IaJ5aNhnjIkXfRJtlSyDnnfGcGKPFf8JqufvwvAhLNTbGMXinqyFSsMvBdnf5k6AL/VVsey0A7eJOdU+2y87za2b16ArMT/efj9uyromR9s7fe727AHpSqJ8ICjrhQa0zmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jY1tX0p3Td18eRdxE1Up81coT4cYsR8bG4E5dnnujtQ=;
 b=i3K+jsJdlP57991LP+JPgnGwQvFqG9iQaHLQw3A+RV7nVM743wvN8hiy7LYN55jfARiPJ9JO2pWaQKJE2j+ppBYfFYBor0uwAGpfMBH9L6228Q3aMZcIKVOAbTflVSjOH0tc2UHg0XObbQLlMAozb1HexXGnh0TkiV1X9xzlnc8EMyF9GTN4+CTRnLEhyZztJHJJ3yPBCxh//WOm+35aH91UKCdmWziEuXcgyIkc0/UnPVn6kGqjunX+nym4dH8NX4ID+nVWH60BSHQ/MWumeiWE1j9G/fQ96VwXKiibYims0N20HSV/yYVOsXOTl7U2ckCwZHFOR33N9yL7iBKEyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DM6PR11MB4516.namprd11.prod.outlook.com (2603:10b6:5:2a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13; Thu, 21 Mar
 2024 01:30:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 01:30:22 +0000
Date: Thu, 21 Mar 2024 09:30:12 +0800
From: Chao Gao <chao.gao@intel.com>
To: <isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<isaku.yamahata@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<erdemaktas@google.com>, Sean Christopherson <seanjc@google.com>, Sagi Shahar
	<sagis@google.com>, Kai Huang <kai.huang@intel.com>, <chen.bo@intel.com>,
	<hang.yuan@intel.com>, <tina.zhang@intel.com>
Subject: Re: [PATCH v19 043/130] KVM: TDX: create/free TDX vcpu structure
Message-ID: <ZfuNpI1fiUr4h27+@chao-email>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <51c4203e844159451f5a78fb18cc5bebcc38a76e.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51c4203e844159451f5a78fb18cc5bebcc38a76e.1708933498.git.isaku.yamahata@intel.com>
X-ClientProxiedBy: SI2PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:196::12) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DM6PR11MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: 25186bc7-cec1-43be-37c9-08dc49467991
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BPS6luPheb2xwCpZPHFgbz8xVTIyhClWoqFrDhWCb6xLkbBUhX3lvQZFbTSHFDXd5EfjWpuC/vv4xlGqqS9psZkW30AvAe9ZHybeY6ha88fQQ58QAns/olpv3d06xTI85u/FGOxkQp3ECgD9JWI6T9zg2zKGnSCI27EHgDDA9AlaTE+bnT0GIaz40LcPyKXBvSvCP6S/nfv7zgHdujcuMojflvVbqH3jMXLVK2PPH0ZaWPZhJ4Wx2o9baCDOXDDhmB5y7RkIq8jzfjlwCvtx44t6YX/cstZrhvKo4eWLUk1D8c4BWMkQtt8EMRZufGHh2TwBU5sdbXnGJ7cLqUTGsGMUSoJ5VMcY1odU/ogpb7HQpia78APeZInwYpnQXaYwA1UaCJ27WNSViN1kfRXN0VJYlIILTGx+vB5jCFd74tQKOyhM6yDvJYz8gB/06iiRkMHmI/sccjdYJhph3o9YU8dN3znagaOmsqsm2YWn11cHq7EPzmQdmY+SQu98I7516KXJEnK19UmgPLs8WM/J25dxaFq8WKScB981jNJyH3PHleoUy/fPUP5ddrGvN9YWlb2TC7RTZ5rmXiEabbU2quFl4aeKllKb7Nxhd7mcIY9ZfoEl/JMlw3Qg4hxzNgo3EV5bi6GHJ+0yyDcvrPqaZJLwnxtg8WPlsnhVEvIb0is=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KolWOErI0WCDeMfTPNuZcbDVDcHb4eabfTZWg1sYB/DQb+/pEMToGa0/c0Q2?=
 =?us-ascii?Q?xYiOvDsQkjIpJzN0gsRi+QJ+utd6yMYt+yZZxDHpQ29/dR1enybqZjRUrJO/?=
 =?us-ascii?Q?iS1jX0PIp2F9kIUM24gwit7za3qtydgXm0jWA2eUVOmF/7vkcBUKezA20cw1?=
 =?us-ascii?Q?kA3IUwsJ209bgWxb1vT96Ya6Gsv7xvq1cFgzXgaCildfQe4B1fMrCJ0/pAsH?=
 =?us-ascii?Q?PWYHyjh+uiW89bGrzLa+75hW8bAxRj3nG70j06vqwhf1oUyvYgvNs4w4m6Ow?=
 =?us-ascii?Q?s5DftVQekJfMYR3cmMFcxasm13nacCeQhlz6J1yLolUAm0/MfGFnoFUN8DIq?=
 =?us-ascii?Q?Iw5tyqKYM3o2a0I1PnrJonzLK9JQCWPGhbs8NuBOkyuX5oiM14g/4u3utwp9?=
 =?us-ascii?Q?2lVbP+R4Fa8i4owXgANUFmG7H6MQKlnwjJE6mYvvycnrRrLzXq2/lGNzBdAA?=
 =?us-ascii?Q?5Xp1DIZYEkMMtzb7HQ1DbWwa0Q/k/FJd/njfRbqHTb+ylYOCWqy8KfqmOeWO?=
 =?us-ascii?Q?pJF9pf5mQcJBjxpb7VKGctZpE707kX7ofcKF2JGmdY/id0vKq0Q2J8zvY6HH?=
 =?us-ascii?Q?TWGT1wzIdL/xcyLpAwDJxfg3LVLH22IYiGoW+vaYQGW/xTzspKKbEucnXcpR?=
 =?us-ascii?Q?Kx2p7/NYHn4xL0guFtMChvS9BiuxfXvnKkocLkPLLC4EQ8y18TV2q2RTwvfp?=
 =?us-ascii?Q?lVQzfUEOq505hlMK1Pmln+xaO5lMlF0dQGA7YEdVs+aFprTig+YJHKgY9HFF?=
 =?us-ascii?Q?qOtc8VOFKtj6+ebJRt13akZE5J/xSMoMzurpXrxrdg/OTvvXA13x4usImr4+?=
 =?us-ascii?Q?u6qmHISOFBlW4OLr6NsNossPsWD0GOdHzL428HJWEWzGhXfrE1Jy6H5lS5ZK?=
 =?us-ascii?Q?WlJ/e8fkvYEEAb1IjehaQWIv3FmDN2he+o++0v5o57HT5VZ9eivJjvkVU89j?=
 =?us-ascii?Q?WeM2fGEjrsaMT8UVchWJK2u5N4bDEipn8k/h7RI5USm3LLZPyllXb/OamE8d?=
 =?us-ascii?Q?8Wmplt8/v3hxLK+75M2ACAcnhAFL1fdELmxGtxBpUWmxXML4ExKXJkWx9Rbn?=
 =?us-ascii?Q?CEOU4Dfs7krOZYQpTtNqlEM667cddDr3DV1ttWkndU82jqbHKFH6CVCYWxO+?=
 =?us-ascii?Q?UvHI5KsYp+YzbNFeTU9LFMmLJR8fKoRnNWsCGdaFtLcMfNvD6IuOniN5CeeP?=
 =?us-ascii?Q?IChyxXs82sRqnwAS6gch69AwTH6aS4uC0d2nXK07aXF41/3L3TomrzK/5PBi?=
 =?us-ascii?Q?PShlyf+krmGeMW9YJ8lPccQTjWDwxtFtLEy1GAJ2SbDqfWfVOgNwh6ALnZHo?=
 =?us-ascii?Q?bxtJJd2XuXpy6ZhZXMi2N8GY9g/WDBzVjqiAS+Sj9J5sXJNdkkdCmpWIroDC?=
 =?us-ascii?Q?hLpP37gff66uKU0i4SYvFv9lf62XZl6LsEOnnbSZWRPlCtLy18l7H5ayO6qH?=
 =?us-ascii?Q?P9v0Q9DVS+WyHq9+CCby6B46OwD1oetdiJb13JaxJW2H65qNuAGyC5dzIo+p?=
 =?us-ascii?Q?cq7dZPRpJXCQKwgZPWuhonUyJ5MN8xBn8Yc6C0AxIjZTyxN4KMZKoxZOfLpy?=
 =?us-ascii?Q?whq/EA/kkea7Em1Mf7nlX4zvpcGLB9NqapqudaV8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 25186bc7-cec1-43be-37c9-08dc49467991
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 01:30:21.8964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H9ZlUjsSfde7jBgRMqy3qmTMz68ZGzPSwvAewVm+Jp2SOatn/qr4ZxwKtkMiGFzWKQJ8pL13CqjjNzn37h/MBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4516
X-OriginatorOrg: intel.com

>+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>+{
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>+
>+	WARN_ON_ONCE(vcpu->arch.cpuid_entries);
>+	WARN_ON_ONCE(vcpu->arch.cpuid_nent);
>+
>+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */

Cannot QEMU emulate x2APIC? In my understanding, the reason is TDX module always
enables APICv for TDs. So, KVM cannot intercept every access to APIC and forward
them to QEMU for emulation.

>+	if (!vcpu->arch.apic)

will "if (!irqchip_in_kernel(vcpu->kvm))" work? looks this is the custome for such
a check.

>+		return -EINVAL;
>+
>+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>+
>+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
>+
>+	vcpu->arch.cr0_guest_owned_bits = -1ul;
>+	vcpu->arch.cr4_guest_owned_bits = -1ul;
>+
>+	vcpu->arch.tsc_offset = to_kvm_tdx(vcpu->kvm)->tsc_offset;

kvm_tdx->tsc_offset;

>+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
>+	vcpu->arch.guest_state_protected =
>+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTRIBUTE_DEBUG);

!(kvm_tdx->attributes & TDX_TD_ATTRIBUTE_DEBUG);

>+
>+	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
>+		vcpu->arch.xfd_no_write_intercept = true;
>+
>+	return 0;
>+}

