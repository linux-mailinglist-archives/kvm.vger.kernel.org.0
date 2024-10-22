Return-Path: <kvm+bounces-29324-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 824869A95B9
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 03:54:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 153C928398A
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 01:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F7212FF72;
	Tue, 22 Oct 2024 01:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JOCVCA6N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DF8768E7;
	Tue, 22 Oct 2024 01:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729562032; cv=fail; b=HtYEMP6+BZ/sHie856Yha/ySLgO3Uw6PywEjw413zImsfU4G1yx90nf9gXQYoymbghGS9QltWJ+OnYF/68C5Y/bA91cj1U6jFHPwT90gd/6bFfUSk8bjl3Gg/1PISy4ubqYvHStLSWFI5aRLULFTvW2xvBgz0DjyOpvfwB5I9Do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729562032; c=relaxed/simple;
	bh=XjhrJ2fQOxX8pzclig076w+FmnMCFE9SZKR6Xc5K92g=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mxQpM4/QbiDGGwJw04nAmGt//HhbiNkKbEVInD08Yu4zUHexjmBi8y/lMrFHLcNOc900FyE2yYbgDiJgWUuxYukC1EwpbbaJ95tvQdy3NNEDTv8pOstahRsCLG/8dk7y+1WB5M9JEPwURAIkxdq87ists8iHVPxUiVzYHktZW8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JOCVCA6N; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729562030; x=1761098030;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=XjhrJ2fQOxX8pzclig076w+FmnMCFE9SZKR6Xc5K92g=;
  b=JOCVCA6NJJQHUrPG/W45lggSEH1YzD3EUnBF7TynPrsZq2aH/b3c33fp
   LOIPJtbmUIQbJwVQoN6pErXY5EX8sFws+r81VcrL4lo9Lx7+9KJuBZ40k
   970DlMUYDVf9iDwWt/JtS2ql2gaaf4wFORTAHpcIDeKEpcS1pkmCDcSwO
   0LoOwuliVvy0wATmj6Ws9SsHllc79usKIcYCbWq++p5ChSUOMb2r7kkff
   EMdH46UTkhpQhXSoFIYMHCqS3WvhQgWDQe8Twnfu+S5Q/LClIOprCMyve
   62BIPJmT96odEHWPt0rfHVZ+m7Tr/jJbRwWdQz9KseVwox39nsogzJiue
   w==;
X-CSE-ConnectionGUID: SPDcdaCQTaGqLMINL9Rsjg==
X-CSE-MsgGUID: PD58AMdHS5W0XqdH9WW43g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="29016766"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="29016766"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 18:53:48 -0700
X-CSE-ConnectionGUID: p7REMbFwSVSUCDkja+aZWg==
X-CSE-MsgGUID: b6lAnnHaS/mwO+na22EQVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,222,1725346800"; 
   d="scan'208";a="79702689"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 18:53:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 18:53:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 18:53:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 18:53:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uKMu2e3qhVF5HYUfRtoEtFWB+7ItTuHNGbyaVbd4gs6IyhFcEDXqN60hGVS1Fbu55t4NASsaJG2vswCniIWT3codRO/lknE1pgeRQSmEZAkrXFnQBxjZitj3CSnQpbEFMo2o+Ydg7UingNu+7eCtAa1pdsh48BQ1+kgeQNQFGTO4DryPsjYj74sYzcsNovTbSL/R2gsRrePicrW5Hgl6TvWm3KAxnWq0wJ9dE+EOMmKwFvALbsOWz0694Fa7tiMmyQH83sEhjEKvvMmPrQYWcyxsB4Xf4tRYrhtPdx3svKBNjI5EcHxtupdZf4k+hCx2nrV9QOihC3h8NrI5L4X7VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KF/dcXgUkYQbnq50DWqb0NBRMqntWIroKy46rNU5eMQ=;
 b=ds2K5DoTy9oLu5msJzOn3ECszjZQz/LOQaXH7iqfDciei3/IzH12+Jd+SdgFjKz84M8UF70F9Ny8y4bb3t+28GHDNO/uOBb5v/B5Zzq5IvVrMduYE0r15ug7X5WinCDPhZ5tEJ5rMIpZF1CNXCiwniK0kYODu0aKld/uy10PXtt7S7gdh/mtDr3ePuKm0/zomrKlA6ivWLNvBWtkRugqBGxwUreF5eSdrKXsyeyl2BO7WUiD9oFL3y9GS3YywXy/f3+SLF3FuFvHDFSxurwku1q8lWl4K1vgnOuIyaI8FJexINyOgv3Unm6TUePHbIh4GHmfhE42STBr0CJUIXUXQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BL1PR11MB5238.namprd11.prod.outlook.com (2603:10b6:208:313::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.29; Tue, 22 Oct 2024 01:53:39 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 01:53:39 +0000
Date: Tue, 22 Oct 2024 09:51:13 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	"Oliver Upton" <oliver.upton@linux.dev>, Tianrui Zhao
	<zhaotianrui@loongson.cn>, "Bibo Mao" <maobibo@loongson.cn>, Huacai Chen
	<chenhuacai@kernel.org>, "Michael Ellerman" <mpe@ellerman.id.au>, Anup Patel
	<anup@brainfault.org>, "Paul Walmsley" <paul.walmsley@sifive.com>, Palmer
 Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank
	<frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <loongarch@lists.linux.dev>,
	<linux-mips@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, Alex =?iso-8859-1?Q?Benn=E9e?=
	<alex.bennee@linaro.org>, David Matlack <dmatlack@google.com>, David Stevens
	<stevensd@chromium.org>, Andrew Jones <ajones@ventanamicro.com>
Subject: Re: [PATCH v13 34/85] KVM: Get writable mapping for __kvm_vcpu_map()
 only when necessary
Message-ID: <ZxcFEQOk0MFQt0KU@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241010182427.1434605-1-seanjc@google.com>
 <20241010182427.1434605-35-seanjc@google.com>
 <ZxYeFKl2KbZ3Ila1@yzhao56-desk.sh.intel.com>
 <ZxaZtJGfN2_5Db6h@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZxaZtJGfN2_5Db6h@google.com>
X-ClientProxiedBy: SI2PR01CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BL1PR11MB5238:EE_
X-MS-Office365-Filtering-Correlation-Id: ae4234b2-2c35-4949-a44c-08dcf23c598a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?XR5uh6Iay0FxOBK2s0pBDA2OPpNMsxmkHZoWUey97VUYNqciH3YbDwPV3a?=
 =?iso-8859-1?Q?XJWP2gvbfGb5NU9iOLclj+HZ87UPpBibjTXSM56C+P81EIh8tGxLTl79X7?=
 =?iso-8859-1?Q?jdZzB7uTyNl5KaYQn5Ax3BXki80eRLplVsNj/Q8933GS6VS0EmAvCgxJ4p?=
 =?iso-8859-1?Q?ZHrfV/Vg+YrAxZAj0Nb/uq+kOlpJv+zCiAR0+3AoYLzuFea1D1cyZ/a4iN?=
 =?iso-8859-1?Q?t1IJGBU+iFc4aGJl0xH5/jmdhBs4ewDAC0UlHuUP8K7By1IYXQpn/nVc65?=
 =?iso-8859-1?Q?QsLSsqjGdDFFlWLwwYWyr3vg0xa90t07+SRiwR2Tkvnog8+ys7Ib15EoXs?=
 =?iso-8859-1?Q?dJK/9WUZaI09TYzjreBIH3GD+p5T6JUrbZRZG//Gj2SkkF2fUD9Lb38hvR?=
 =?iso-8859-1?Q?xmx32QA5XlOS7kXbjdI9qGPbhVZK57jpXi/KUd7jEOqTUSyVCwHKToKKNO?=
 =?iso-8859-1?Q?8gTR+5nNqf/4f3Lzp0/e4VTYCZf1sEzAAOpE3fM6WCv3p6qN0bfR6hC2aE?=
 =?iso-8859-1?Q?sz6/l9ldqzgP+4ngiZbkFCP+TEW3gxInu7EXc5lSXWYG3aYCWZoU5cYVzh?=
 =?iso-8859-1?Q?urx0KqRB9lzGz0UnwLi3KROy1gbLniiKGbHOxw/HBybiRv10uKXU7pMjwm?=
 =?iso-8859-1?Q?cm4W/Bg9WRnWhYSGw5SRpmej4CiYIHM9qtZ6MUN6TKc5ZONCGwrMhCbt5e?=
 =?iso-8859-1?Q?a2jNHukizwTIQajA7C/cxy26VQzV0R5xHLMN5FSE8asY/ZNk17JJILk4cl?=
 =?iso-8859-1?Q?7t1duBDTxBlamv7a+3W9wwNoawcNdNWMQIcj8BJXvhvDgRxiwE2HWylO6f?=
 =?iso-8859-1?Q?QfPC4etjhl5fdc6VGvVtBhwUtfTlolQ2JJZcCDbo78rL43ud5YVCOI0AJ6?=
 =?iso-8859-1?Q?izIA7jvLgiFVbOEGBsu2MSakr0CFW7h3aNWAH+hEqNiRMOmmG4fuwhtr/K?=
 =?iso-8859-1?Q?9O4+djOcBb5svg5QG/VLz2FtgV3XJW2Ae0W0rU4KfdiXLYMP1Wn6IoGnPn?=
 =?iso-8859-1?Q?Ue2IstwoFRodu16X2+JiZGgLmyVYow+EvqlwkG0rbHLpTQSAKSA1BcYTgi?=
 =?iso-8859-1?Q?BZZPplMCCim2jPV4hp8odg3uHodQF+zFFWuaBbCjsam9qL+j/yUabfTQr1?=
 =?iso-8859-1?Q?gwS7hF8vba5kW4sNO7eMychtC5dOt5VPoUtT29giUx11qKSejlqS1rPg/R?=
 =?iso-8859-1?Q?z2g7xIB/LawDSq7HKbBFT4p8MxCxkCJlKsXwuX78r8gy7Pi1s7IplL5sGv?=
 =?iso-8859-1?Q?DAfg8RPufnjB4/ZlbLyDrLu3PNTO5D/ZsbqKWQbaM4KcHoelNxh1rfE3aU?=
 =?iso-8859-1?Q?Nw8HXag2I5zQCyYvLJ0wp12SEQqueDPSFUshfHFskwn68IQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?hhwEO92IKHH1GRQW3yu8AzzXwNkVxg6RnVONBjkHNWTJkH24c12B+qJcl7?=
 =?iso-8859-1?Q?P+TO9B394pyXEx5ZPGAMq9/5BcrEgN/v7tLZkwdFrUOOcnGB7pQFC3YIp5?=
 =?iso-8859-1?Q?3VwqgP/4na26hAT0x7yKn4w4ya6nmXgyh29bxr7X/sLioMKuWgOf4Vva66?=
 =?iso-8859-1?Q?DRcPUvbSI+fSkUDmn3UCnrVeCmOuz3oEpfx1Oya0nIhmAuRIGf2PJSAz0V?=
 =?iso-8859-1?Q?Ynck8GXj8oT4gsR7OD6QjxGqBZZczdvgpcnjNoAxkcJKdY1kkQ36LW/rKr?=
 =?iso-8859-1?Q?kiKgW/wC7ogZ0Gj8msThnbzG/yD0Y0h+7t3NWn0Kue0Y4FitQ8GkEDY6fV?=
 =?iso-8859-1?Q?kIEudk3s9fn9sJdYrJZRrTHIXPvTbJeOxvI6QfvrXK8sOxUmCPAVQjeCt2?=
 =?iso-8859-1?Q?AY1Z/6rLlDcXgCLX92Au0DT5tF7Ea8/VK/Dvqt5QdXQjmzHWDoBbbw/7aJ?=
 =?iso-8859-1?Q?/ppgiOe0v4o2j2ZXKR7YewYe80fKogK0cCHYpEftU4Sx9c9Nlv9oaWqYsb?=
 =?iso-8859-1?Q?f8l2Lue/imanUp6IT39tI8pNX5ewKOvUTMThzsxBkqD6/axEsteDPTFsRe?=
 =?iso-8859-1?Q?YiNTDpBeSbSEOyZm8mraJTezCUswI2AAO35ISbpXi77lHFlzWumO6CE/1w?=
 =?iso-8859-1?Q?BMQLKBceFIrW2ToxnN7vXHSXPibgRkukImA/hwfdvvnnbEErdoiI1tCMxp?=
 =?iso-8859-1?Q?ywSfekANh7VoXPbeh208y/UM3XqGGvA9s8AWDwQ/7g66pYEemyAgdzQX1V?=
 =?iso-8859-1?Q?axWGdHKWRqYEY2DosGS1Ep+zewHS22OfJu75BfY+2iWewC9lY7CeiRsaTv?=
 =?iso-8859-1?Q?U3a4XNjLbAFPPVO9kYS6PGwQVvbk36EI84WC1E0H/NQem3UpJBdeKlPXqu?=
 =?iso-8859-1?Q?qydVLP5rg4ovu6Zhgeckw9zKa96yxSKqnAw9bOPJDtql6kzLl15zWh5w71?=
 =?iso-8859-1?Q?Z7CN67+zRZPVpwDEE+fs9d53GlKHUSgtmiVv2alFg/Mymb0YbQ8b0foirx?=
 =?iso-8859-1?Q?2pfs9lcV77p7QBeW0MAs8Y7Y+q9OCZWVqhTNm6nUYlzkN7t7Hor0XspaLq?=
 =?iso-8859-1?Q?DwGdzyge8wUKG04eMxvrvlk7p3b3PsmZGbaxxldrPA/khHa0Qr/GTcA310?=
 =?iso-8859-1?Q?Fq416zrpjUabqOBlP7/VSxkGQew4xA9Cciq4ZWqEHoMGw5X9aHdbyREwYv?=
 =?iso-8859-1?Q?pqUPQ9MWz6Msc/b1KSXJsVJNnUA3nJwnBbc7M4HidmsRTio2T6xL50445c?=
 =?iso-8859-1?Q?K8y8OkLypduFsPkFvuGuzMW5L1IxnfcztGGaZy86rSK1mvIGNTiuCAnfUy?=
 =?iso-8859-1?Q?y+rK6oC6ana/ZHNsUti58PrO5tl5TL/23wfUT81rRFUVSmAKE39vrfVx0S?=
 =?iso-8859-1?Q?Cfl8DnnlLQ1qO06Y1OloS9COJgkZlMGDI/bKr25ezURCV1MEWsqAo/WFDp?=
 =?iso-8859-1?Q?ASvSCzHPT8SaVCY9JQZdzCsEBfB7thRzcMpe7jOLPNddgQzg6wRvA3MNbD?=
 =?iso-8859-1?Q?r18LTS0LXSLj6mBKuFEQ1kU+ZQS0IAiY4Y+N3tBmbPBdBCV4ZPlmle2emO?=
 =?iso-8859-1?Q?IzreD8EeB4WiJoh90/KszH7Y6pwEM/ZWuGURNst72DaK/GQTXRuQIyBs+Y?=
 =?iso-8859-1?Q?0ORx5krqbn61RtGKhdg4wcYmywWggvB7FH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4234b2-2c35-4949-a44c-08dcf23c598a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 01:53:39.5332
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D50aO5VOQqfXGIwHC1fbS3wB9fskHfLDU3WTGhUcogM8D/opKwdZhOMgsFS54xGqFnSsfR4ulxUDNXGVweBLsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5238
X-OriginatorOrg: intel.com

On Mon, Oct 21, 2024 at 11:13:08AM -0700, Sean Christopherson wrote:
> On Mon, Oct 21, 2024, Yan Zhao wrote:
> > On Thu, Oct 10, 2024 at 11:23:36AM -0700, Sean Christopherson wrote:
> > > When creating a memory map for read, don't request a writable pfn from the
> > > primary MMU.  While creating read-only mappings can be theoretically slower,
> > > as they don't play nice with fast GUP due to the need to break CoW before
> > > mapping the underlying PFN, practically speaking, creating a mapping isn't
> > > a super hot path, and getting a writable mapping for reading is weird and
> > > confusing.
> > > 
> > > Tested-by: Alex Bennée <alex.bennee@linaro.org>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 080740f65061..b845e9252633 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3122,7 +3122,7 @@ int __kvm_vcpu_map(struct kvm_vcpu *vcpu, gfn_t gfn, struct kvm_host_map *map,
> > >  	struct kvm_follow_pfn kfp = {
> > >  		.slot = gfn_to_memslot(vcpu->kvm, gfn),
> > >  		.gfn = gfn,
> > > -		.flags = FOLL_WRITE,
> > > +		.flags = writable ? FOLL_WRITE : 0,
> > >  		.refcounted_page = &map->pinned_page,
> > >  		.pin = true,
> > >  	};
> > When writable is false, could we set ".pin = false," ?
> 
> Hmm, maybe?  I can't imagine anything would actually break, but unless FOLL_PIN
> implies writing, my preference would still be to pin the page so that KVM always
> pins when accessing the actual data of a page.
Ok. So setting .pin = true here is because of KVM direct access, which does not
check mmu notifier's invalidation callback.

