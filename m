Return-Path: <kvm+bounces-56238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 868FFB3B057
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 03:18:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 712247B1CCC
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 01:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08F41DE2CC;
	Fri, 29 Aug 2025 01:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9z+oKbz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7928B3FE7;
	Fri, 29 Aug 2025 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756430271; cv=fail; b=YinO5e8PsQ9w5UK14MOITG9fu+pdyUuiIuo7PZSNc/NUGD/8gX2ddfsT4hc0fLsgXhFR7/z5+gOX3uew+ZOPUJXK8uaR+R+o9uYdUXg24qv9orM1lEFdhPcE+J5WIZ7GnKulBQCMR8rJpnJxK5mn65dRjhD8GPRAcw/s7v0wrao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756430271; c=relaxed/simple;
	bh=kz5TTRvUc4zVatTmIOGLI7J0ViTMvhZwx43s61F2uCE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FpNb3dq/k9qrWSxTL5FVdH4giCm6Y/Anv6fJ4ZT5kvgeWzcJi3CXTbNRX0IzntuvYPnlTYHEHa8BOLRLOFXy+5EwkKUKjgI0mS2xHB3HoYCrjbyukw59hME0BQWlSYSIdkqdAJ76s6rnIY8Uil2oXPmLSifDHTgL6CKa3A2RU6g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9z+oKbz; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756430270; x=1787966270;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kz5TTRvUc4zVatTmIOGLI7J0ViTMvhZwx43s61F2uCE=;
  b=l9z+oKbzgDrDTTPsy6KEtnDEKlbEEdtK13tHXBrPdnEX5rKVJEfoaeaS
   3/fXH4+/1eK11uNFfXjTPuSG6p4AEiC00EKzsB7cvQ7kapI9m2boHEAPD
   E9NhHX/KXgUcgBXlP1tEZiTYHfEkOhdVcRJ1aYwKlOj8SWyAVgl+f1jtx
   Jg2I/YnCmKK5FLcJ0AXgTD3Opnes1/NqKchRvcKlzV4tI9EuQ1gsjn20W
   N1Olag076OfrMyPX9p1SvSL1ENu3U5yJDg53GOovHcRb09kROVVNyZHcs
   0wcX0iOqXwtp+ps2FUVaNV71jdTJxDdKhxZNl6oqzTfR6m0J0L7+9KxDZ
   g==;
X-CSE-ConnectionGUID: zXWsLI52QMubfzbpvS9o8g==
X-CSE-MsgGUID: Y4h2sSUmS2mYJDXXH9BVgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="62359455"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="62359455"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 18:17:49 -0700
X-CSE-ConnectionGUID: 44t1Qbd3QaWbtGKwm0s5Yw==
X-CSE-MsgGUID: dkJSMP4AR8Kx7dt98GbRIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174630791"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 18:17:49 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 18:17:48 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 18:17:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 18:17:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JUtrPrtXrr6f+pOoM1cD4FpXT5OhMIhFshjk+4FqDwpR41ZlcrepgOa1FLGIaC+e3B6AXw93ybdvgwnjxNE4JNlCXWKkMY6OmelwVyVWqYx01E6Uc7T33nm3N0hdUXvwaNRz+Uvog3JUy05ECbd9Lol1IcUnriDBRPp1NWCMAILPEgoTNcI6QWh3wI/zE+xUyyqKH8kIftQTXQvfNTu+9Wg7UoTGL6FmziNiJcE7xQwH+Cb0wPUcMn/l65LGaSSxttLpEdKuGiwyqymrE3Sf1S3Bdn8tpinIGqnBURcXmfkqVKOpHPHZMUdUfVw4cofYoDm915K8fjjq6rp2oiHewQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0To0jvOoWP4XOjGD/TO5ZA/zGaZt48Zeld70jSaq2wE=;
 b=bqTzfbjIWXO48bbYGasi2EtCbEWOHNaDBdtCSKuHKKGCB+7fVgMnIQtaVGoAa/XP6qszOQHcsYPk2Zndgj/JBh1ieFXxkPI06vkchO/rau3Q+FmynJJ0Ou19y2dkdyVX4CrBJ77SdGimG/gWr4+4WhZlcU6DOthiFXnGUexvEi37R9CXRU+7CvR1GDB71wBsOCJB+dORynt0gTzDWSxWp5dTx/E0AQjH8Avczp2ZpQeeZNDFer9VjAsNfdf+VFzazy621YR+Qs7ug57eTEYc/7GR1rmm8mqDk7untEtIwN+CirZi69CruvcNpbsC1t3kZgb9HoGjdDywy1MCdajt9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS4PPF900531A26.namprd11.prod.outlook.com (2603:10b6:f:fc02::3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Fri, 29 Aug
 2025 01:17:36 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Fri, 29 Aug 2025
 01:17:36 +0000
Date: Fri, 29 Aug 2025 09:16:47 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Vishal
 Annapurve" <vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 02/12] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Message-ID: <aLD/fy8RK3u+z2Lr@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-3-seanjc@google.com>
 <aK7BBen/EGnSY1ub@yzhao56-desk.sh.intel.com>
 <4c292519bf58d503c561063d4c139ab918ed3304.camel@intel.com>
 <6bb76ce318651fcae796be57b77e10857eb73879.camel@intel.com>
 <aK/1+Al99CoTKzKH@yzhao56-desk.sh.intel.com>
 <aLCwpNygeC64Bkra@google.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLCwpNygeC64Bkra@google.com>
X-ClientProxiedBy: SG2PR01CA0136.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS4PPF900531A26:EE_
X-MS-Office365-Filtering-Correlation-Id: 89cd31de-974f-4c7c-008c-08dde699d6a4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?SwtrKCraHbHx/VQGFS3zTG97MVXkpSB2HfWf/lEXywpxnKIotHM7WnuE7j?=
 =?iso-8859-1?Q?ux3r9MIJbm5xT081sribG0EjwhMhQpxwTv3NVqm3RjLpW18tDg5T36w+Qf?=
 =?iso-8859-1?Q?UFOPhyYzW9NIg5TWLpEYP8XBk3BOm9yI8+nK/2cQq7ujnfAj79043hhwwm?=
 =?iso-8859-1?Q?H/g3ZUHG42pNseJn9jGyaqvztXY51j96se+vKOeEoqD3ObTin+QFRYCoUe?=
 =?iso-8859-1?Q?XX2bLBKBum/nvAGE1Kd7NedW+1c1i2VnmYeVARoWCh3o5QLSUz0K0Ia5UJ?=
 =?iso-8859-1?Q?je+8Iw1oQPg4fYBXPLfmgCAbpXiJXQVi5iZskNC7dy1p+MislhkB6olFiS?=
 =?iso-8859-1?Q?SJCBef02PllrR/5RQnoFuanGjnQZkbgW/4R3ubO3q84QfURfkJsTNQvefY?=
 =?iso-8859-1?Q?d33Hq+kiW1LSpmwhSeGSZdTXMUA6VffkL9FmTmZxncLcmMhD9BPaSRV9aO?=
 =?iso-8859-1?Q?XhnTjY3Dn6/8iMe8DyObdB45wH75H2e8xdiU7Xkfl/RnoiWr2H5Fxb1/EF?=
 =?iso-8859-1?Q?JoHEE+m+WHCWTAWrw9v34RjumKZY/2zrM7yk128gLRJMpldSZX067186oU?=
 =?iso-8859-1?Q?6+kiEI3l6RbVeD3QYFlOkWFQc9gviRJXuhFX+QqFQTcCqzRzbT31Tec6Kk?=
 =?iso-8859-1?Q?72/E+cM9W8enluDQ4b/xFIODywppLkL3pmGOpOKOF9cSW9ziWvgg89RhD5?=
 =?iso-8859-1?Q?8thh1qrapJuEuF2l93RBvKtPjzhBkRs0XqnuOV9okpnUOEjwxMDy5eO/Q7?=
 =?iso-8859-1?Q?bmXnXA6TOUBKPhibwNwGuxzjZlw4PjM4MQ+S/yxZpDHecSMAkiYVWlQ+w+?=
 =?iso-8859-1?Q?G5l06kBJCQ1ZqSZhwCOTcZcwzHwTdzjOEonOhhuaRUzX0WTXVIg5HJlAFd?=
 =?iso-8859-1?Q?/wKpbogjOUidmji4RYptjleY1lpJSiNSrFVO/9w8vIC9Qq5ITTfp/M+S61?=
 =?iso-8859-1?Q?pz5qxN9km03WUhS6fvca6m0WXkQtzvMZ5/DeA7dMGjQLZ9yZcO1TtykKGk?=
 =?iso-8859-1?Q?dUtk3QqsEs5mhw7hUHTQ6QBlDMG/yDf4AcHg9S45lUIlQ2XPb9pFAASVoR?=
 =?iso-8859-1?Q?YiIyJ4TD8GyynSPe+UXQ87PB8rbd2Np3Lj3YyXhlND7XVUf6QcAz8ogbTo?=
 =?iso-8859-1?Q?Dw44zb8eQhFtKUjz0S/Wz3mkOmYPqaMjT8n8VpsZKVLb4bXuRMcCTRDaBq?=
 =?iso-8859-1?Q?gnoiLF+CfofUGPYqEzxZa4vsyEzZduuk+NMa9NDXA5ppgjD5D54nzlJibo?=
 =?iso-8859-1?Q?q6G0D0PyWIwwWp/ZAdegdRsGYxrMJTRUp3To45Wvhn5uXwE7CQ7HwT8VCg?=
 =?iso-8859-1?Q?jxfbH5gqvkdcOrU4Yh8m4KT4hyydhPcIFwGmfGpj/hyDTpwLJ7hWEr3ykA?=
 =?iso-8859-1?Q?CKs7EDWE2oLfhSduEIjemHG09N0/4DJS5EMUoKOSCk3EbFpABfX61eM3SU?=
 =?iso-8859-1?Q?maMn+DULPPnRyEMa0JO6la2Xk5Otr6UtaeX/u52KADp2eyHrEocQHLE3XN?=
 =?iso-8859-1?Q?k=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?AAucxkENz8vrwlYXa/W294C4gM0qqi/QDB1sK6gaLponVoj0vyEhHc7X1r?=
 =?iso-8859-1?Q?BVCvXYiBBItCt9Kd8kxxFQhbiqGL+GPWlSEPnaKcuZJHb23yL8fvJjn1T8?=
 =?iso-8859-1?Q?QvN4Vxwv4sS1CsaiNhUXeh+rlHrzrV17EW6EcF4e+BuNj+91JKUajklOH9?=
 =?iso-8859-1?Q?C2BaAw99C3jEwqoQBb09MOpMGhaFyaDzvRFJcazL+rWGGFSh+ORif7lGUZ?=
 =?iso-8859-1?Q?eMzuuWREgI8v1zDNZgLrx2jIkzuxtewQzDMdpNs77gwYvg29PkzG4y5Rdv?=
 =?iso-8859-1?Q?36O9P4EBUG/6TVGB22fsDfsEe1/J5OKmu7GcLn59wjGNOOsFnoKBDe3o/y?=
 =?iso-8859-1?Q?T1moNNBwgVK0gSpqM3ErJPMehX2ebAL+JIk22GQrPTLc6nk3dcpJiDYnYX?=
 =?iso-8859-1?Q?wEa+0JH91dPh8F/SWb7W7ZIUcwNiV+5mllwtXLgrPVryO2gKuCAH2MriWf?=
 =?iso-8859-1?Q?WUtKT+AmbVutuSin02kq2v0c9AYZyyiY4/W9pAUs/23KG2/34W87RDTO0u?=
 =?iso-8859-1?Q?mrHt0MebFmDLUtrToUoe+YbsuLjCM6sgBReNZwpPwDAMqg8d2UNJ3cibbF?=
 =?iso-8859-1?Q?18eQrgqc/HGm7gcI969frWp1Gke/h4FttG+IggjB29XeAd3Lb8IcONK+Eh?=
 =?iso-8859-1?Q?BBqXh/eLidMr4g8yjj0RLzmSrri0LfnrrAefUaq5Wl70GTkA5rYFrBir9H?=
 =?iso-8859-1?Q?zXqim/0XT3MfZzb+8Z7uGR/4fdxMN8Ip6IL+v0uIFoKB+zpYuPQBa3ecBu?=
 =?iso-8859-1?Q?es+TS67nYUZfkl//PkZ7NVeTycRPr8T7skAdNLBaKGWj2LF56z7F7TeeGr?=
 =?iso-8859-1?Q?CQ6qAM5+4x/uxQT9cG7f20+OR/KZ8p6CVFe8xJAM8vhL+j/up+zisMWF1e?=
 =?iso-8859-1?Q?C9+WS2jvVoLg7PNH2C4+IdNOaWhVgJbMsikv48KesgtiXP8HT2S3LsGgm9?=
 =?iso-8859-1?Q?F4fPPTBci8Uu5GEcV+aoXuLyFyVsJefAaPapKq7pGupadW6txjpo2ZmV2+?=
 =?iso-8859-1?Q?y+oRY1ah/IsFLbwk+m/LQv24BByhk4zbp6T4N7eEChPE45gKgFWG2BD7z2?=
 =?iso-8859-1?Q?QAjNjkzkgn6WIKTmA0PLBW7UHwCX8tRTr1V+HcQ5Ydj31nlmC1fa+GcINt?=
 =?iso-8859-1?Q?7va9Tvw9zhCDGaVNEDz0x2zIMibbgTBAMmGNKPH+vdLP66XLlnLqV3ZjBb?=
 =?iso-8859-1?Q?SfilpOq6HokwrapHP+OziGZVcv2nrE+L0tLrWUqLJ2P61VpLdngcERyZRZ?=
 =?iso-8859-1?Q?84rKh4w5f4UdZ42soMI+m7VdHI03MycItVD9chBnRsqsKOE7xnZc2PpKFT?=
 =?iso-8859-1?Q?wWrPBcw0TiiccVn+AVqwTOqIgcR6ct8buMnidpW+R7p/9lyiT6OOBVnr7c?=
 =?iso-8859-1?Q?hCliy0KG9dEayh8HPvOJzPv94DNMTz+6oS/CwxCnBHqMQMPcgBMXs7elAA?=
 =?iso-8859-1?Q?6A9TZFZaDPSlsQSDNh1w56HzcTOqzq69HIBUz53nnAMFeaGnzwcRTnPhOF?=
 =?iso-8859-1?Q?VhWv1MDM45yeMwY+rD41c8KzH4Ypp4TyugEjofcjgQIWka7ndkxxSP6xbm?=
 =?iso-8859-1?Q?HTdltSuXYIWDvGQst5Bqxc6vYHZ/TMFb0JgudJHde9Ol/emq6IqmmmLWZW?=
 =?iso-8859-1?Q?70A6MmJ38CSC2ODC/GRmPkhqFRxgRLBf2W?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89cd31de-974f-4c7c-008c-08dde699d6a4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2025 01:17:36.4251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdblqkWdF5SVeoee15qIPQwJhbnp/Y8/F6RwXwqGobgwy9ILlI5ccXjbN5otRiUtINak4T73aLqDkAtrfU5pdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF900531A26
X-OriginatorOrg: intel.com

On Thu, Aug 28, 2025 at 12:40:20PM -0700, Sean Christopherson wrote:
> On Thu, Aug 28, 2025, Yan Zhao wrote:
> > On Thu, Aug 28, 2025 at 09:26:50AM +0800, Edgecombe, Rick P wrote:
> > > On Wed, 2025-08-27 at 17:54 -0700, Rick Edgecombe wrote:
> > > > > 
> > > > > Then, what about setting
> > > > >                 .max_level = PG_LEVEL_4K,
> > > > > directly?
> > > > > 
> > > > > Otherwise, the "(KVM_BUG_ON(level != PG_LEVEL_4K, kvm)" would be triggered
> > > > > in
> > > > > tdx_sept_set_private_spte().
> > > > 
> > > > Yes this fails to boot a TD. With max_level = PG_LEVEL_4K it passes the full
> > > > tests. I don't think it's ideal to encode PAGE.ADD details here though.
> > > > 
> > > > But I'm not immediately clear what is going wrong. The old struct
> > > > kvm_page_fault
> > > > looks pretty similar. Did you root cause it?
> > >
> > > Oh, duh. Because we are passing in the PFN now so it can't know the size. So
> > > it's not about PAGE.ADD actually.
> > Right, it's because the previous kvm_tdp_map_page() updates fault->max_level in
> > kvm_mmu_faultin_pfn_private() by checking the private_max_mapping_level hook.
> > 
> > However, private_max_mapping_level() skips the faultin step and goes straight
> > to kvm_tdp_mmu_map().
> > 
> > > Sill, how about calling the function kvm_tdp_mmu_map_private_pfn_4k(), or
> > > passing in the level?
> > Looks [1] can also address this issue. Not sure which one Sean prefers.
> > 
> > [1] https://lore.kernel.org/all/20250729225455.670324-15-seanjc@google.com
> 
> That won't fix this issue though, becuase @fault will be valid and so max_level
Ah, right, I missed that you composed a fault...

> will still be KVM_MAX_HUGEPAGE_LEVEL.  Which is by design, the intent in that
> flow is that KVM should have gotten the level when getting the pfn from gmem.
> 
> IIUC, this particular flow _must_ map at 4KiB, so I think forcing PG_LEVEL_4k is
> the right solution.
Forcing PG_LEVEL_4k looks good to me.
I was worried that SEV might want to use higher levels.

