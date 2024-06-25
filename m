Return-Path: <kvm+bounces-20451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7685F915E54
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 07:44:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9B5041C225F2
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 05:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C41145B28;
	Tue, 25 Jun 2024 05:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HKpTx0+O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FF82D600;
	Tue, 25 Jun 2024 05:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719294267; cv=fail; b=FCkYYHumjvMN2EASPhhpx4SCpVCREFX7OBjKqJf8L/8ae8QO9e/N6qyDce66znnKObUiqgGeI+iJZWTB/vdneLXBaIGQ0Gj+F4f4G99oWId64YwUSi5/hKwqRvsbbT/zbiJROUwboMWTsCAPi1taCAFf/ac+RSjlpkOwIj6mV9U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719294267; c=relaxed/simple;
	bh=T7+IVYAwtQv0ZJdOvC3J2xyp46GaxlCA4F/pGlSTPY8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dANk7vyRm3WICqULrDiQ0Xij0bdIIPuKTQUNgyygST5INWOucJfBBH+aic96GwRtZ96w0XhYu/Hq4Tats77PVWx9PlpCc3KTtHlIyqPI9RVdE3nY92+GpdwNY8Mhkj02zqK8JpOZNfk+dnj4R9HOZtK5JLiqTAKz0AYMILi1bSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HKpTx0+O; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719294265; x=1750830265;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=T7+IVYAwtQv0ZJdOvC3J2xyp46GaxlCA4F/pGlSTPY8=;
  b=HKpTx0+OzNT8sm/apnC/vPMWtQK/6z+DCkdJy1don57yTt52t0JySV3D
   jbuI73HGBzZZteADk6xh2vWtMMqN+m9a4pmY5c/lKKkZIs0VFEFXWr/O0
   TvjcG+DZEVHfy49qA3RjWoOywP0WNwlzAZokA9ZDwVv+yCXOTAqM4R+cL
   aRGT/FxyBgOiwIyl1x7QPZ9LIvSKNiBGMP364WlksAhYSOuyWPEsmeiPB
   41fHYMs+8e2BybfS0fITTm1M9wBj90W6dbuNG/oHQFXz+kW0ZLqcJ7eD8
   JcFBizuz27a0M5AmeXotGDLt5Hb4GKLydMQK7VdQqqbBbLR1dvwy3ctX7
   A==;
X-CSE-ConnectionGUID: 2iwxb4AlTdOYctbDrtqqGA==
X-CSE-MsgGUID: 5F5RSkKHRH+kY8iQB4w8Iw==
X-IronPort-AV: E=McAfee;i="6700,10204,11113"; a="27699852"
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="27699852"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2024 22:44:24 -0700
X-CSE-ConnectionGUID: 4ohRsiFiRO6Iiu/2Wms2Vg==
X-CSE-MsgGUID: mJgELwF/S0iuxVdmiQyg2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,263,1712646000"; 
   d="scan'208";a="74290166"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Jun 2024 22:44:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 24 Jun 2024 22:44:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 24 Jun 2024 22:44:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 24 Jun 2024 22:44:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1TujSt3XYWVfLFVsV+UHShKNk9jx4F8NFZ7600UL/hSWg816AT/7DPz5Nm6at9QZh7iiiGpuWPPWVoDzcZvp0JVda9qXsh2CqU5xDNKKpS/aA6XMW3EWvigmu6IcQusCAuVudMdSc2M/dK9/wLxyZ3suTT7I+Ujf07QtajXi6PeIMSRpL/GA0yJpHLLB1UvIF/ik+5x6FqASGQol96VM97xxLavESEcvbjrafAqVByKq0OOOrNLv9tpHfhsqbfOVkds1XR4aQSxc0Z8xpr7nC4vqD0kZfJRNR9PDr5B9jHcKaQd4WL0RlNKC6RTXF+u8FZLFsoX0uUmXk2IxJW8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLryTXUP86e81X8ophXqzoE6J5gfkPFaC5TzR2+Hbo8=;
 b=FMQ50gC8Q2SurKSvzfb5uf21fpUkChVsVzMG4UOXE81XpC4eWy/hICpBbUanib5N6es5MOQmNHlVKTTDZNMmgWzAv5VKZFJ7eGL/a8VclHitBthztmb6mneKFl3jYkkaTWUb9KOhBBZsHZ11qA+Rp50AHlfe3vXiG9etCy8cNBm8ufvCPfzKbaeDqAClFXQrS2A8cvTYk+DpgyyI+OSdyNBLOnCmma5pCqkeidj7wJg2KV6+wAxAgfjevC3Nov5EP4H7FaHr/Lc42NiAXTaV6xu947pJ/VQ0OpY/eAlleratsXL9kIIzZNkAm/SRuG88S/X/slqFmRah9sHbiwMAKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6708.namprd11.prod.outlook.com (2603:10b6:510:1c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.29; Tue, 25 Jun
 2024 05:44:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 05:44:20 +0000
Date: Tue, 25 Jun 2024 13:43:09 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Message-ID: <ZnpY7Va5ZlAwGZSi@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
 <Znkup9TbTIfBNzcv@yzhao56-desk.sh.intel.com>
 <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b295497932e8965a3ea805aa4002caa513e0a6b0.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0004.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6708:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b1e495e-bc9c-4202-29df-08dc94d9dc58
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|366013|1800799021;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?duwlITwoxQrC7Khq6V6a53UOr8HKFQyov1i4YTYo61kyGeV8cwh7C6UBwo?=
 =?iso-8859-1?Q?kk5+YCJCMuIyFNIKknV1c5MGYduRT4i62ppzPNKZIv0uyQ/cCMbjz422wS?=
 =?iso-8859-1?Q?8DfTJt7eEOsZYVurtVBbi5GYXOwzRUkFo5vRQK/HibMbFOERUK3L6a+sMb?=
 =?iso-8859-1?Q?SiNvKCMuRjji/IoEaVotiNorvChJGHV9AmVrUeWb3q/Ecf9fHgpipMSuEv?=
 =?iso-8859-1?Q?4PGIaT9j/UebV7dD+KW+DarL4FDqsw+LB59UI1FGiBJw2bMsZlEZF2zp/x?=
 =?iso-8859-1?Q?Z9j/E3VVaE80X7RuB3F2wnp3hJ4uvsiCtuYF2rzK8Bj7QOe1I+Ar0EG9Hh?=
 =?iso-8859-1?Q?M7FcgZxHdQCLqdMtrLU7YxYiIkqSJISe4QJBUONdu2CYpdcqB/dAj7ZUk5?=
 =?iso-8859-1?Q?RyRhmdSSJ8WsM/z2SJuw+roXO2CbkgHLXkVHwcHUbWaodXb3OrWb+c/zFn?=
 =?iso-8859-1?Q?iEHohec4q+FcSsJapeuP++aviW8DpQIJ4oCzaA+lw6bEvsu6QcGSv+JWDR?=
 =?iso-8859-1?Q?zF+ItXfLuQqyYgnmZLTQOv5gxECa5onmQPTBA5Xf9GjfHx8gFeP+17MTvp?=
 =?iso-8859-1?Q?NIhhvT10DsyxEp1ueIzdF/27Sf1yR44K6PXc9pv6US2Dm//aiV1cS1rVlO?=
 =?iso-8859-1?Q?HHg9oxhCwFBe7CCbl6QagZR6skpKgoAadkAxE4g8+vor2ALjkEJzhs90Ic?=
 =?iso-8859-1?Q?DjpoAlMEO+S0aaqxA2IMs0ZMDt1gxU4kPGBONm5X4uRuLh9+ZQtaKXyB5e?=
 =?iso-8859-1?Q?PDC1RhqbfrZiMq0puh1NyGsT04Cf7KRR6xqeHqmVQjxoFqM7bYqEWYpaLu?=
 =?iso-8859-1?Q?MLQf44TCcvuYtPnlW+APwhm68CUwffijY4CpgnqQAP0ugl//md8FaFmi6V?=
 =?iso-8859-1?Q?ugke+PaI8ZGAHDEd0toG3w1HxDu+iTziL4yhBwHMCkAGoKoBfqU0FtYtCN?=
 =?iso-8859-1?Q?0m05pVTtk/E6x+HTamc0hXskYvZLV8FiAO/8UHG+RP32yA/Y+pvFf6MXX1?=
 =?iso-8859-1?Q?6wVJ4WZKpogV+rDr2OPvtVeD5ZbLX1tQIUlC925yLJO9zzscY6PqRa2dkS?=
 =?iso-8859-1?Q?u1kEin7pZu3wP+RYlMX+LEYq0BUvjpZbOimTREi9Da35WleMQCsdwrQqgV?=
 =?iso-8859-1?Q?AoMYR+YeNlMnAFCabhuoW8wqZl4Ab1i2zdfi6a68ty1jHsCfTHgqxCXiaj?=
 =?iso-8859-1?Q?8tz8DBn1IMteDwfSaY5eFCxNnJZafw+YYaU9Y4wq8JtpmZI9uuWvQa/DAv?=
 =?iso-8859-1?Q?12G9IJiY0MwerGnzXJ52ddA5JIuhK/6UKKVVwrfJRPxbLzkbmVhPqO/5SY?=
 =?iso-8859-1?Q?EskEIoeRRtztIUDrQY+ukV69PGWZcFQCyH+FZzmmeFuws1SsGZkEEdEUHG?=
 =?iso-8859-1?Q?JXdL1FWqY+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(366013)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?akkZi+4FCZQLYWxzv6dHDHNQmUWfoPxpK/SiUsC4la+RA0X/xX2gDauHC2?=
 =?iso-8859-1?Q?brfdHEQEmNGUkMQFegh9gQutJQ3cn+YvAZM/woLPWlNqVoUZEvo+atCL31?=
 =?iso-8859-1?Q?ZmnhSPi+7ACRRyl2W7MqUNu3zJ2F0eviAat9aydgdKapBWsp0IWFTodvdr?=
 =?iso-8859-1?Q?UJoZ8ZiJLfjIJl1PwM7wHjxVhlTe9JN7tWL1/khQ3/xqtJbo70VTpszWiV?=
 =?iso-8859-1?Q?bz5OARBU+fsP9LtQ7tGJ5sGe3l98FUlCNNVGrWFv8dbQOofpocxM3C+Xnl?=
 =?iso-8859-1?Q?YcIC4OC4xk9eUVj9cc4+11cmzlbTGIzUBY2O8TapVOa49hW2V/aauxzv4F?=
 =?iso-8859-1?Q?UujSqxV7nrxZE4a2T5EL96DRSJwZwu9LtHtNl+6qaDsyRYgAv8OqQlaGBK?=
 =?iso-8859-1?Q?ceG1kQxsLiwcaWkLz+mlibhuma4nTrYo7xvkKIVdzR3yX8OdgH5BqMz1lW?=
 =?iso-8859-1?Q?pCWwOUGGLRvPtg6fNz2+Q2v4OvWCHPZ05NmPF4DHi3ysaG12h20f6IKrwm?=
 =?iso-8859-1?Q?A8GQh/UYvRGkUtBKbxt54VgTJsvQBYZ86K8UDSgYBw8vpFB5O1rwdVwwfN?=
 =?iso-8859-1?Q?VT82d54e3D5knf3IpuS0VNtxxU+6TeF8NdKwfS8yjP9m5IHnTv3Ah4vgEm?=
 =?iso-8859-1?Q?uAZadAC9DqRzY2PWR7ciDRrz0+dGBO+HPxqen4THrSsZVqHnFGp2nlYMfD?=
 =?iso-8859-1?Q?NRFjOT9iS6IXlfwE9skbfgJrphm9gXlxeUOBbgMQNX5T0/nndjMQw2yLM5?=
 =?iso-8859-1?Q?ecF8HJNfkmLxiGsBifyFtmN2GSVEDAqSy6ihxU+f5LeGaR23pYgntJQ+mC?=
 =?iso-8859-1?Q?NRlfikN6mdvOvnt1bjslYxJ5+z0XAhI8ojvfOFFMGJpEZeDJ1mkLCZWtkS?=
 =?iso-8859-1?Q?W7KXL4bEHSLxvZWtcPOxuJUIDFs6rLgvGLnXgw+CQOMTNJ40yUeFb6RC9K?=
 =?iso-8859-1?Q?yazaDvcasnseyxFnov+LPrjRWWAsHp+xY3g5vT7MRPFdKXIhDqyAbP6+ZA?=
 =?iso-8859-1?Q?ko/c1tSD1pXmtLS+enMayJCb6y1l1fG+ojHwq5sQt6uyD4yMnkmgiVnuhZ?=
 =?iso-8859-1?Q?qYfOZ1WPkJcIbxr2jWG0uETFcKD+2XuwVSEH2YalZ+UlHIQldqN0Ty6Rh8?=
 =?iso-8859-1?Q?BGOt31UWl5xXB50m82pNu2e7S31Bd/RR1A4wP+4hGjt2BBsFffeVS6MMdw?=
 =?iso-8859-1?Q?yNIH/wKU1L3S6PTN9o99sfdS5qpgEfDMYgY4wlwQwP8D+elOrlBKEkRtv8?=
 =?iso-8859-1?Q?BwN+WfxXIB+0WSEaqv5+xHOv+LwjaAEuJGh3riWRTAA3Wxt5f2ME0naJ/R?=
 =?iso-8859-1?Q?afkqrnPoxMCyxZtLDKHptIpSny3Jde9GLO8ATNnioGn7Al2I7IsIqacJTW?=
 =?iso-8859-1?Q?U7GHJi42dFwQLMMh+gN/oUQDdJ2tMHCt90LpoMUyQOAdRcLcT92kqLXPtN?=
 =?iso-8859-1?Q?dWPvB5Cl3LMKXFS1lLzk024H6PmUz6IzIU4yYn+brAsPR+cmchUdUxlbky?=
 =?iso-8859-1?Q?tyDDh0Lo4ZnG/iBALXkPe95utMQmARYXuQworMeRPaMnLiixFBbRK1KPy6?=
 =?iso-8859-1?Q?IKEu7dGsYYNZIkGcKrDuE2bkMcXBZD1SfjVLL3BwZfhD+YRapklKjmZIaE?=
 =?iso-8859-1?Q?qQiJxDA87GsBkqYraG5V6fTq1wCqI1xi/S?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b1e495e-bc9c-4202-29df-08dc94d9dc58
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 05:44:20.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sjUpCxGW4GBe3yolMkFO4hglqC9NEOPij0jqgDbEzBn9Glye459ViyO20n+JWT8PB23vDoceuyC9zlCM4+S9Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6708
X-OriginatorOrg: intel.com

On Tue, Jun 25, 2024 at 08:51:33AM +0800, Edgecombe, Rick P wrote:
> On Mon, 2024-06-24 at 16:30 +0800, Yan Zhao wrote:
> > On Wed, Jun 19, 2024 at 03:36:10PM -0700, Rick Edgecombe wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index e9c1783a8743..287dcc2685e4 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -3701,7 +3701,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu
> > > *vcpu)
> > >         int r;
> > >   
> > >         if (tdp_mmu_enabled) {
> > > -               kvm_tdp_mmu_alloc_root(vcpu);
> > > +               if (kvm_has_mirrored_tdp(vcpu->kvm))
> > > +                       kvm_tdp_mmu_alloc_root(vcpu, true);
> > > +               kvm_tdp_mmu_alloc_root(vcpu, false);
> > >                 return 0;
> > >         }
> > mmu_alloc_direct_roots() is called when vcpu->arch.mmu->root.hpa is
> > INVALID_PAGE
> > in kvm_mmu_reload(), which could happen after direct root is invalidated.
> > 
> > > -void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> > > +void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
> > >   {
> > >         struct kvm_mmu *mmu = vcpu->arch.mmu;
> > >         union kvm_mmu_page_role role = mmu->root_role;
> > > @@ -241,6 +246,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu)
> > >         struct kvm *kvm = vcpu->kvm;
> > >         struct kvm_mmu_page *root;
> > >   
> > > +       if (mirror)
> > > +               role.is_mirror = 1;
> > > +
> > Could we add a validity check of mirror_root_hpa to prevent an incorrect ref
> > count increment of the mirror root?
> 
> I was originally suspicious of the asymmetry of the tear down of mirror and
> direct roots vs the allocation. Do you see a concrete problem, or just
> advocating for safety?
IMO it's a concrete problem, though rare up to now. e.g.

After repeatedly hot-plugping and hot-unplugping memory, which increases
memslots generation, kvm_mmu_zap_all_fast() will be called to invalidate direct
roots when the memslots generation wraps around.

> 
> > 
> > +       if (mirror) {
> > +               if (mmu->mirror_root_hpa != INVALID_PAGE)
> > +                       return;
> > +
> >                 role.is_mirror = true;
> > +       }
> 

