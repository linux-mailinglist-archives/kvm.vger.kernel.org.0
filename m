Return-Path: <kvm+bounces-29323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B1A9A9573
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 03:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 70FAD1F247F0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 01:28:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE9512C7FB;
	Tue, 22 Oct 2024 01:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nwViScVF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B859136E30;
	Tue, 22 Oct 2024 01:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729560475; cv=fail; b=omyuVYz4LBCUPJnPVPFy4H1MXX9DTwYW65NkWnMbFeLSQ3nPwItI/pkPGIAF+aXEA7UICP+cS57zokr9JoQ3Rl+XCcxMnU725UuySDbYOmRT8jO4oLNWxGW7mtx23rh2gHOccRaj2vtHBQ+iuZpqHrKm8f6jm9EyWHjf2S3VdIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729560475; c=relaxed/simple;
	bh=QLRjpoZt0MMyFlYOMTDMme+R5s8kDMEjjf3thWdcMsM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jj40YRXLf/+sQ4mkKG24mfiJ/MU4dIap6Vmj1xZIi+Z/j9FjaBhdHX7yraTCnaBcaVJjsiBslKC6Hq9LYoDSFX3S2zLzX5g5jiLcPosOQmVFhepXQNdVffa4JtLrDHpOAL6UMNUrIfbykM6EB4Ud0hXX65LQmGO0+2qdPUak/ho=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nwViScVF; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729560473; x=1761096473;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=QLRjpoZt0MMyFlYOMTDMme+R5s8kDMEjjf3thWdcMsM=;
  b=nwViScVFixiDDvQmhBg+8K9zrCexBU6kWQjBNqibg7Lw4BtKpzjcreBD
   qdLXqsIDNCin4rR4SwOjNlmnEDPo6NWfus1frJOPcCmDebGIJMMnV5UPq
   uespM1a5gvqw/gujj8vUSebdOliaPglhm6eyBnFDOpNGtgkKHXaMP+BIb
   Xn4EYdVCfuDCjxX1c8DnLYvbTImO7y3R1vOszdMlRzrrJuDLLe2hM5Cu/
   yiNW8+QOfO/avVMftL+LinvePCqHWwx1IvtqoZHb9fMuPyLyFAb06rCqE
   PHvNCGi6yZQnggXPM9/UIJQQJpiBAeywqzASmXhFEI4RFLl/TFCZDwOsw
   A==;
X-CSE-ConnectionGUID: 2iNopp+hSEm+jViIjjd/AA==
X-CSE-MsgGUID: f3C8v/quThusEPU4U9MhJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="46539342"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="46539342"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 18:27:52 -0700
X-CSE-ConnectionGUID: x1LBae+KSSulWMb1mld9gQ==
X-CSE-MsgGUID: 3OdbdqeqRzK976lVhgejAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,221,1725346800"; 
   d="scan'208";a="79634105"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Oct 2024 18:27:51 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 21 Oct 2024 18:27:50 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 21 Oct 2024 18:27:50 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 21 Oct 2024 18:27:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bCLSIufmLY0Ln7ZLh3/10KD9RPyr0Ht26uy+0xHKZO1Z8di8tkaZkdYiGZKtKkWHQ9Gky3WPS9O51OcssVVkbZLVc+WhCbJcyHLhMItXB6cXw78ZfWGlrnaTsYZJY7kHN72B8IDdZTjp/B1f+MZTPFT9QO7DYPHPFYl8hz+BEANf3o04RWlNjHr3gU4oZmrCg7P6JpqmL/UUVOGS05KU4s3Q/wtWRjhxL0Q15V+Y5jo1pBqIvotqztrve9BVqyBObKvU5NOV/SYlmV3TVjmuAOnbZN3Jq0I580PzYWRGszX4JBQkW3ZLjFM3/JWKAhY27907veI79bP5sKOMeYodVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8wiZMJMqOHn5d7VwEfIIQSOtpMAYOkJZve6CdQ5hjd4=;
 b=KHSTm1YMpLkJemP8innwUGlHM2H+ojIECP5hcxhWcbs6I3QVybeW8VgRNfVJuRNZMakYmAjH2tv1CNAzjUmeVdO0esemqIkQ80p97mmhwZDTLbU+zeJ2fw2kEI1/boWg17rKyHqL4eYn3JJFn03c7m/JSNm2T37hx7RTx/24Z4CHk/r/ye9EzWNHO3R+Q3uX8JTbbYRKzh2kkYmO8m7hRn4gH0YSIAslXtnzDUENxNBxj2hVxZ0CeHNtBBqSbPwyux71TWWj9+sWHFIPkQqzjOot9VMnTH1sanjpKrHtlOuVv/b+uNjA196WrI2ib7v7Zd7V2hTIxvbo3jqUzMm/5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ2PR11MB7647.namprd11.prod.outlook.com (2603:10b6:a03:4c3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8069.17; Tue, 22 Oct 2024 01:27:47 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 01:27:47 +0000
Date: Tue, 22 Oct 2024 09:25:21 +0800
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
Subject: Re: [PATCH v13 19/85] KVM: Introduce kvm_follow_pfn() to eventually
 replace "gfn_to_pfn" APIs
Message-ID: <Zxb/AZVD6wvk28OY@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241010182427.1434605-1-seanjc@google.com>
 <20241010182427.1434605-20-seanjc@google.com>
 <ZxYVnsW9WF1Wp8mx@yzhao56-desk.sh.intel.com>
 <ZxaYsfc0m6UHmi10@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZxaYsfc0m6UHmi10@google.com>
X-ClientProxiedBy: SG2PR06CA0210.apcprd06.prod.outlook.com
 (2603:1096:4:68::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ2PR11MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b29d12-d235-4d1e-b758-08dcf238bc21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?EZf0lpQLySVQiGoyrRjvxWJkC5IVMq8mYWCsCIaZiNJ5rAyUYLfIrSF/HcHp?=
 =?us-ascii?Q?fvEIQD2OKUhETd6XGYuaLcV8+7sksuqn886Oxn6UeT27yA3hrs3TKH1xBXXE?=
 =?us-ascii?Q?OEOmRYBO5ruxrnnTZqz/MR2LGfOAltCzfo28gfAtofI9VK6grhukmTNfyhYB?=
 =?us-ascii?Q?74iqLC/54LN0MYJMyGmrmdNYcJSbgw79WZu0leWb3ydX0CCB/peiFUepL+qn?=
 =?us-ascii?Q?4UGUPzQj6RcuLt5ByIy0lwhLEStc3euoPmjIpeHsDM6WvIL4xryNMmnqc0QG?=
 =?us-ascii?Q?Mze/gWmmqClDqckQ+Fh9bF2VTenhwauQi7+7ulRgEhIMaDWd97AUgSMH9I24?=
 =?us-ascii?Q?ui1gjxeCxnLI/u1JzspEhaVM7AdsDyIE/gMp4x6kB6rz4nENAo/I3jUSqs0T?=
 =?us-ascii?Q?94C8mzzDlg/qjrNrgY9nhkz/wGCTa8prEqjbSJ+R7iWToVyIZjk22L1UEKQS?=
 =?us-ascii?Q?/i0EHbiCUFSjEKSG8Zr46e9IQBWKBmLn7YSPSXwYk2+VHO7Rgk35SiXQL3Ry?=
 =?us-ascii?Q?Wz+m2a2IKFyQWqwHyZGiSlXi32tKcFJYuyk7LjvnI9KjSVaFBnK0yqVppbNh?=
 =?us-ascii?Q?juK3RQ2gtgAk3FcovdRzjc51fsPz5fqrrIgcUY8YZCiULGBAiT+/DSYQmNCX?=
 =?us-ascii?Q?DnVC1hxwMNRtYp+JtzEDynpbZJftmpVAAJIaXsfaOMTzM7Il/rsyxDxUmSP/?=
 =?us-ascii?Q?hJ8iCWJCfpnkDJCtQglwelCIjeZxq26dA6qzV7FKE+IXFfxcNk4dBO2w8AS9?=
 =?us-ascii?Q?YachnGzP5bGdMQ+Xz0b4WHF7wwXZZzrucyd35zGdKS3FFc+fKLzj8munbQOF?=
 =?us-ascii?Q?g+I/zgEarCTZyvVFQIVLTBnqVGn/Snx5AVvvQuyQyaTkggUCzg39rE7gtSBS?=
 =?us-ascii?Q?hL+adCbEgJrfjc94yS0F+SArASQYjC0yazDUXjduEBwf1nKQIWeb/JXd333E?=
 =?us-ascii?Q?9hCfma6PSuvwj+KsMsqAYWz3sjHKioZf6gaskj+tsosdarFkfPpd9kI8Ss5j?=
 =?us-ascii?Q?M2yTI1qPrJHwSiMLl1TFHZJT0COjOMbmRXdPDP1cO604/xc9H/xgSgdV/68o?=
 =?us-ascii?Q?ZsjecjFY05Lz2CPEyibncC/xmAmPNzh0Koq3Kz+0P6DYPDFBair86BzlwdPZ?=
 =?us-ascii?Q?Vh7CUVQG8arKZrJT/aVuYux6fLBvZUlRVrVyausYNDfNuMj6CBlu6/L+vQWw?=
 =?us-ascii?Q?NiRAXgzw4cDxWgXv2WtWLYxC8aj4u6BTg1J9aZj9HaZAsuMoJf1T62G8NUqN?=
 =?us-ascii?Q?c9kDiuiY1q8BgjeKDUiVFOmCdBPQcJMPrbkcCCAizsY77ZQLLgXSz0632Xuh?=
 =?us-ascii?Q?91XFFiMxtWt8h6OrGRwZZ4wY?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dLTNuZgnb+xfQcm1PSYaib6X1ryu93LLLO/vaXe1Zkf37/l9gSGU2hwI7NyQ?=
 =?us-ascii?Q?ZX+e7bR09rO2fbKYJe/LTq+17QHfwdroUu9iyxxeXF01/UbcmLBAP1BElJff?=
 =?us-ascii?Q?etXWZWKV31RhDW5ZvabtLb+XhUja4S60oI4bwcPmUi4BaGxcq8u1srSRmIor?=
 =?us-ascii?Q?WPCuHvU7x4D+jUkOxoASCSYg9fVlkJJaC+uuEVTpCHYWPpckcvVhjY//lfF1?=
 =?us-ascii?Q?mfUJYMft0kzJIuwdgsCjd1ekBeR+7r+qxh5h9IkwNU8Yy7VZnXj8dFGG6vNP?=
 =?us-ascii?Q?QxFKoIgBk7QIAj6ihhYhRmvMQjjgAX4ZM0AYq6xVquKgFFLSbMzn9a1H5ddx?=
 =?us-ascii?Q?C1HmBSiGcewD+k/tjuLNMPGAEaV4FGz35BulOigGImRR0zQRtoN3mzhyfqsZ?=
 =?us-ascii?Q?qUf8i2qr5vKaQMttNqLWKnWM/4dROz6bBbhlHgy9ED16X4A3GlVGDYAZdnjj?=
 =?us-ascii?Q?+eB41Pqfg3kTdr80qaYNjvazWyRQNo8p73pHMG7TWFllSOX97YcGZZ/zsKCO?=
 =?us-ascii?Q?HYbiyoab7OEGL8dJi8S6l3tuTjzZlKlQu3eqHS+OOCmsX0yOnoD+Crb6Agkm?=
 =?us-ascii?Q?buF4L7tq6jBDGg2qTTaeT6aaC7TYPFzFgLK6wMSFYQATWseprX00PSCqyR+s?=
 =?us-ascii?Q?07iPTRbo1NyqKZSbdGzXpwiyf772dgVwC/REtTZuUM0lr9mrMTak20TNhSWQ?=
 =?us-ascii?Q?VFHozfchWAuDYBtbfAlr7EUM+TZ3CN3DH5LFGU7FyCke0CdplWiGVHV5ok4A?=
 =?us-ascii?Q?B/jDnD6egEmq5p88Ezk9uvrD32MMoGWad5sJ9BIoR2N41RrhW1rmruK6k86x?=
 =?us-ascii?Q?T1h5Wnp+GDO674pZnzArU/5QyujI8dGrmFLXhqnITEn0RlOa0OxVc3V8AjCN?=
 =?us-ascii?Q?9Wvse2vqIhyKHpMx25dhPh4pi81P+kpBoIwVDsj/q0gwIc4tuImL38kNRMpP?=
 =?us-ascii?Q?9xadnk7axIKZqgPen8tKVitjtFMDuu2qrAcLUcXlIIZ5wnQILX7SgzXKi8D0?=
 =?us-ascii?Q?uL0jlUj9z4X1J0liwQrp9nnh1ciPntnS11s65DTwxTR2KgnDmMbnNJkWPeP7?=
 =?us-ascii?Q?FRe+ZdVzD2P7glKdnjJMOJzQbnLl0w/qxo+R0s/lNIiIlRdaNYJ5GZiuDHdA?=
 =?us-ascii?Q?AjP6ZBHixSq0HYaw6B5kqakUrCXhnqBftCffhF182158slGx0EPw19RT9XkF?=
 =?us-ascii?Q?BCohql+NXyXKIYyFr8ZiLj7ttDU2umI//Nh208yZMzb7c6UQCTX/aoEaw9YD?=
 =?us-ascii?Q?i7XfvM+Mi35ipJSwM8I++BRctIKXgtogbYP3LrghjwTegg/6rkSIANDkpGfr?=
 =?us-ascii?Q?RQo5cXSZ2gMioGHEYshfA7vJEky1HeP96Q0UEZv+bu/GKB0ZvXqYnZknfxyp?=
 =?us-ascii?Q?+MwRAjO+/go334tsnkbTgLvUNAO/Zeb3Y39ZkO+i4fYOd1uqj1/PA3/KyLOf?=
 =?us-ascii?Q?C+sNMq9wgLLg+qQTiRshsXAaEpfngSHpfntaJJ/QX2aSY1ucRf2MXjZmCkyJ?=
 =?us-ascii?Q?B8X2bWNZX6Whhf3lWSxqgRAbQmCM5qr+MjVnssmB+y/c16mLhF0DaY/LN76D?=
 =?us-ascii?Q?TRNVMnVIDp+D0Ck61hpEge7sxlUPWvHs6HnF+hZr?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b29d12-d235-4d1e-b758-08dcf238bc21
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 01:27:46.9728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4aq+Plh0qZNyyvHtrprHC62R11Ejd7B8pOzkWLXAkpkbsBEommWXMdTk9q46AgLU8Bg/HalfuxrS8JOSLwRW2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7647
X-OriginatorOrg: intel.com

On Mon, Oct 21, 2024 at 11:08:49AM -0700, Sean Christopherson wrote:
> On Mon, Oct 21, 2024, Yan Zhao wrote:
> > On Thu, Oct 10, 2024 at 11:23:21AM -0700, Sean Christopherson wrote:
> > > --- a/virt/kvm/pfncache.c
> > > +++ b/virt/kvm/pfncache.c
> > > @@ -159,6 +159,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
> > >  	kvm_pfn_t new_pfn = KVM_PFN_ERR_FAULT;
> > >  	void *new_khva = NULL;
> > >  	unsigned long mmu_seq;
> > > +	struct kvm_follow_pfn kfp = {
> > > +		.slot = gpc->memslot,
> > > +		.gfn = gpa_to_gfn(gpc->gpa),
> > > +		.flags = FOLL_WRITE,
> > > +		.hva = gpc->uhva,
> > > +	};
> > Is .map_writable uninitialized?
> 
> Nope, per C99, "subobjects without explicit initializers are initialized to zero",
> i.e. map_writable is initialized to "false".
Ah, thanks, good to know that!

