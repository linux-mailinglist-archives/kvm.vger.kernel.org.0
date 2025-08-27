Return-Path: <kvm+bounces-55858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 479DCB37DF9
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 10:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E81D77C11F1
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 08:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCBA33EAFE;
	Wed, 27 Aug 2025 08:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hEPKy8X5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820C6304BAE;
	Wed, 27 Aug 2025 08:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756284024; cv=fail; b=pUTya/oUOp2JvAp6pbbUIncVXcj1DXxpCLAXN2FxufrJYDYi3berH3gS8jlO+Uk60MyxAv8szfxO+zCa35d6snkHAYcDOdPwAAqqfjizQTY8iDMSYTHb1xgnk12OSpoC+nL1+vHJU/HslUOytshAK7OiULQRbgQzR7wXQLQDt68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756284024; c=relaxed/simple;
	bh=c9J54g01rWv0ao43E7jcXHZuGfLE+maRLt1+BhDsNJ4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=iYebt6QvczW24MNdpNho1t6gX+pmlc0O0XQVan5LesLSaM2VM1b/4SqMQmunVLZWoo1tJ0518yXARwzahBOlUJRmSSKYO2wAlMWxqUEOkpxTFLP6li0YDC8pshMZH4ODGK0dVCGGtfDBdvlPWVD6cz2JltUGh4Szg3FjetJk5lg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hEPKy8X5; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756284022; x=1787820022;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=c9J54g01rWv0ao43E7jcXHZuGfLE+maRLt1+BhDsNJ4=;
  b=hEPKy8X5FuFQklwtdI7KXYibIU5I6Q01vsL+ydMkBNl70oG/xZwxA835
   Wr/JmcQElVFL4fdejDZW0Ccy3J88Q464tYs5diaSlaBNT80nzGpveiGX/
   c0fG70w4v78tiSKd6jC1uscxjEBVL1grNsZ+KfLVzDNGnOW6OnySwWt1A
   RkC1I74H+jFLWg9/nRZNtCIyi28fIhv6lpC2gRXOUpAyhGUxvEbZ5LxsX
   yO/LjFhTEHYWNNMk5nOdJVjR0YAEoorm8g/UJ1XAm0oqchBoqgnlErYDl
   woA8OZ1U6VFrgAab3FN7RducMHwjaNzmWMSCRgjVjZeKWk5gE5lRmNEs6
   g==;
X-CSE-ConnectionGUID: nN44d4FARFmfCiDbwRuUMg==
X-CSE-MsgGUID: Rd1CETQGTCivxm666vb46A==
X-IronPort-AV: E=McAfee;i="6800,10657,11534"; a="69246887"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="69246887"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:40:22 -0700
X-CSE-ConnectionGUID: KHPqKBjMQb6F0CySbddh2w==
X-CSE-MsgGUID: ppJWBk0wRiuyXuXl7SK4gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="173956869"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 01:40:22 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:40:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 01:40:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.74)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 01:40:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4NO+2+GvnZRDHjpwoyH5qoVKZ3cNpmkyjew3dpd9rG+9j17EYAlzPZwjh4aExcwJ3PFN8tHiTAgJKe4YT0bQjr1Flh9vET+dx8ufiY2QM78jREP72KLnCSM1AFLFkMbjoWLW+cJ+UG7KaZNUeGx9ps92k7fvJmfESomCbyqS+IClAvSDJ/TfBkBeNhDCxT/gWNnZXmYsmJaFOCiXYl+WtpVQ/IzA81GQDI3Z41Sx7nWsQbPDoRpnC/zddWTzujClUqQZU/T9YxQifNeppjMqOqbmweXNtH6ba9pSL3i0fHSPHZePyGet6fHYCCT7K6XJoe4WCUDQjYv0Gv4XeUs3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZFkR8VQps0AIBIy5oas4gVHL6Fc0SiJFaEUJPfcfZvc=;
 b=GtutbgJaHiWlNisimgg6v2Fp1MvYd83dEVsAPz4sbZbTRatqI4f8r4QLnLFuEoNOO1NAAvJglKtBY1vfVGiY+eyZb/Cz3Rsg6ug9AskH9EiJvr1OxNxIQFQwGi4epvCIYCLb3U3kYTLNUQGT50Mb80nInydI7gOo0/PT56s1XJV2rmtlxmjStlu+Uc31oiXuB9GSC7qgDEt3l8Cu8QPl4Mzjm7t1meYYKHjo/Z7xN8iYF0NBW3Z5hg62q4r1OJNxTvaWjS/UzxVDl97U+nQLdAbj0JbUu5u4TAA4347q5IhAfgFLoqVk+Qh5YricyQF4YpBI23YHkPUMGExhK+vPIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB6649.namprd11.prod.outlook.com (2603:10b6:510:1a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Wed, 27 Aug
 2025 08:40:17 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.9052.013; Wed, 27 Aug 2025
 08:40:17 +0000
Date: Wed, 27 Aug 2025 16:39:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Michael Roth <michael.roth@amd.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 06/12] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
Message-ID: <aK7EQH44UOr46Hdx@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-7-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-7-seanjc@google.com>
X-ClientProxiedBy: SI2PR02CA0025.apcprd02.prod.outlook.com
 (2603:1096:4:195::21) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 2adaac63-b706-411f-bade-08dde5455940
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TYl++Q5OKPD1RzG2JO19kgSzSHcDB9D9eWUI5y0O8A+NCdAoWk1pMYaaUiCW?=
 =?us-ascii?Q?/ta49JNJeauwvGrn0Ek4vaDqT2fyvdShM7Xj3X+ZoyJQ6GDN/bH7LYz45IbK?=
 =?us-ascii?Q?SVW2uGt+4IO7D1e2guc8qUjCRCKV3bFbwiOusuFXHaDV5qKdmgUKozR83QsU?=
 =?us-ascii?Q?y1gpbGftKV6mSsfOtMCtRpiz3tAXahwjNd2aqMK2jkblIvzTDFLtaNYHThQo?=
 =?us-ascii?Q?3K4vGnhj6ylsd0fVmC2edSuIoZ19vcfxOqbw8Fg+AdLmPzSfR9umBVA0BPd7?=
 =?us-ascii?Q?l0UdgNlt9BnSaUtSz7wD13LSlUHI5W1231fO3C5wv2vmU+IM5ttGb1Fj6FVw?=
 =?us-ascii?Q?8J0hyxZm4TXlcWuF178eCNT6oYTX2/K+q0JzFgDZVbvpiRctd8g6yd2ggK8+?=
 =?us-ascii?Q?5wki3IXAsqizFsiP2o85EpUYcRA37DIYnwVwxiu9XXkQt4v6ZlFY7Mfuwuhl?=
 =?us-ascii?Q?htEE3Sb7AiZjeA0EzIyYEP6G9ah1vVlUaEgF7lVvTXG6xXYinL6he2nFW94c?=
 =?us-ascii?Q?QJZEtQaGOlWztnWfxMovAjJjWBKLxDjteHvLkGUpxg5knn96MXOVJbx0F2fS?=
 =?us-ascii?Q?S4TwIBjoL7rkK0WEtWrid91CpF2gwMtTjY/1F4Rk8uC0gsjZ6go7NfHiHdig?=
 =?us-ascii?Q?YV07TcbDw7BZXFQNJsepEn/Gp8hl47RXMD2rQz1VebJmIYZujMAdOPzEsqc4?=
 =?us-ascii?Q?3JKQvZjxhxQlw6MReTBD2ejJ5tEifxpYtb1OWRUIvfP4uXthuJ6CC9T4TO0d?=
 =?us-ascii?Q?h2BP6zekJ1uJiPoV/jQeREA36CNTBweTabXe+QGRHWUaf9YBUszG9N8VzoRg?=
 =?us-ascii?Q?XVM8lh3jVuMXWbEdosTXolZOQvCsN0+OnM6PQRSs2ICG0vWOdCiHQ4clgGS0?=
 =?us-ascii?Q?bfJkegQ2oi9swg0ZY71Fqp/1VNJp65PdQ/JQFl//V3t1iZQCAEtfSH9r53FX?=
 =?us-ascii?Q?19G980VqXFglv9V2rawYOYCmbV3fs+pQ2BPVwc+LwlDfaxf5HlBNMU4IdUP6?=
 =?us-ascii?Q?8R87lWaCz0GdMViToOMXa+V58DbOoVKEHiIpPCrKhGw86ePWg3JjPY+ycQBd?=
 =?us-ascii?Q?Vd9eouOIp/koTG9apmlxF+OD8ueioG9q0PLyshR96bET4udTh19P91zH/U+Z?=
 =?us-ascii?Q?L21V1fcSvosoP0m+xd2upBXOl6uhcd1GZTNDEOvUXJVF20g+qkrJh8sj+Nal?=
 =?us-ascii?Q?RYWRAPXzj+rOB6HNODJr6t4RLRC6zDySoyN8YkMZduMDZIF5C01awZ/J+3HB?=
 =?us-ascii?Q?WgzcW4D6nHWCXvNaGUjbc5ev6wdJFu3dLdXEIssYlIdDc7HlLAIYC9OBJ08b?=
 =?us-ascii?Q?HnPelggDD4/psm+Utm3syjBzE0h+PMU5SUVgOTVRJlERTdvz6FcbHroMjFT9?=
 =?us-ascii?Q?wPu3tvjn00gmgta6pXAe4XdxWwDcfsGGPWGrD8cjckG8jw+DST+gyGIf22VL?=
 =?us-ascii?Q?3cbVXt9grqQ=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xD9DsIBko/H+aCTFUy/dl3+K5kH3CVsAGcmjUQvcaxnqufeCwPAKRSU4Tyul?=
 =?us-ascii?Q?oan5Nop3XBdQXl9tWSJfQeMpW7bmlXD70wKD9W3Eqme5kg58fuxLdS2S5549?=
 =?us-ascii?Q?66n0s1lW3AUyRIB0TXDyVcb0mu5SrDKOOSX6FzhwEn4eLUJmBtMNhVGrOWIS?=
 =?us-ascii?Q?yY0W2wUgoGkJIBrBj0FDWix2uF2ACRmMQu9Sc50z1iRRIF6gaoA/abvd46m+?=
 =?us-ascii?Q?tRiilQolRuRQjaMacM10JqWjgPVDYsiylwD8dcmWQdckDS98nnYxkVQ/qBDk?=
 =?us-ascii?Q?2fT/y6hd8ZVrrJchJ/RKE308E30n7P/YJooLexphA/0exgJrPOgID/8EVLb9?=
 =?us-ascii?Q?i28kXMeQQs+oIb/AWL3qoHbRIi8feyngA2uLOlCY/5mxzP3VOhHWHo/L1u3R?=
 =?us-ascii?Q?Ba+F3dJ1YTZg3S/VqP1kI0B3BDtEpST6SDgnKn0DJnFxS2mXfA8izZS/k+G4?=
 =?us-ascii?Q?5+g/TmIRhLE2+VoXLpCRL4YAvtx3oR/eTpdgI3AzJCAQFda/NZOQQRfZN6VI?=
 =?us-ascii?Q?kST7rfEcSAeljDQBIrmVsv0E6inIBDxlrbCzXgm/JZPGbLO4iu4z96enNXWb?=
 =?us-ascii?Q?0w2vvkqGrAkVNvpcy1A5fDXHC6kWW0gIexen8SAmkPniLNB9wLWi5B8lPQ4v?=
 =?us-ascii?Q?jZIonufzXPZhve7TqnuHhcPaCEzNXgpAm/Bv6pHa4wDhLsTHtw2t5S4Mpkmt?=
 =?us-ascii?Q?Mx1GyxhipQcftHfNYRoKIxG5aU79jRJSW8Nw1mzirqUZvNH8uwZKeEezsLKd?=
 =?us-ascii?Q?fofMIBLGgf14ibSvB8m5DWdvP4yvfKfqJOWckjGKRLn46G1f3BR2hkw3Jt1A?=
 =?us-ascii?Q?8nYAYWHkjAi6xf6yZlRyMY411wx/vbFPIppLGKCwyUnNGzgdXpnENPLYLmqX?=
 =?us-ascii?Q?ctjgBZc5IZFIph54smcvkSzbkEtCTIv9cN0+WbQIPUTy6oz7g1Qo/e3KFsG2?=
 =?us-ascii?Q?Qrpd/yNSKAQhk+zWqMfbpM3dxxdjnVowBx4tCk0c1ZgHoefrY3WtsWnCVMvi?=
 =?us-ascii?Q?6Y3lGPWv/A6iglDpXiJfHGCLq7lO5cdjT/SKs0JKQPi9wVI9LHYhT2x6b62c?=
 =?us-ascii?Q?1Xefhx9b83pNuHe31hVe/iDwJaNfHQStjNERYfhwucDPTyOpDmQ0ND2QwnnZ?=
 =?us-ascii?Q?Wx6I4ybjmWrD0yXjFn+uJSDxKQ+HVcBMf2jniYVYB6K2eXrgS8Lic0cGzNnZ?=
 =?us-ascii?Q?52Cxc4iwJJEaSJXmXinDgPKMNFzFVd4s511vLx+HgDrj4RfZl0eZEjhgxAdb?=
 =?us-ascii?Q?RrS5lmXGGNuKPtdDyNR0ATHXldCcIr0R3q5ots+f3VcO7Cj4uNtSRf7nNkaH?=
 =?us-ascii?Q?If2695G8jYe1BRoc92gfTzH31KLSDcMDpTpXRBmZMQCxLPN6S9ecVcaBkutp?=
 =?us-ascii?Q?Hl8Jzqp25cO6b5zXGm4wnqX90QAagvShaJFqzgjzHnjqxtii3P9c4zcxmYPB?=
 =?us-ascii?Q?Jy/8BD8MW669H5gqUgT6/SCpoM18EjxyBzuUI5Me3j0QZ1FF46DE6XIsmBsr?=
 =?us-ascii?Q?Sa0CsQxp+XZ8jiS4gXT/v4fLkMN04z/pk41Isgqgrgsfbc9RVbFK5hu9of37?=
 =?us-ascii?Q?v0Ng9hU2itI26cbYZ94N3MEshWeCGABqUbHLffpn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2adaac63-b706-411f-bade-08dde5455940
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2025 08:40:17.0672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/jUb8EGusSumwxNh/Euaai1hKAc2YC2K6sQ/ylRSvsZLkhHEJo0Wgy2FFJ9O600Ns5dKm66tUDbNEPY+M6cuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6649
X-OriginatorOrg: intel.com

On Tue, Aug 26, 2025 at 05:05:16PM -0700, Sean Christopherson wrote:
> Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
> when a VM has been killed due to a KVM bug, not -EINVAL.
Looks good to me, though currently the "-EIO" will not be returned to userspace
either. In the fault path, RET_PF_RETRY is returned instead, while in the zap
paths, void is returned.

> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/tdx.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 9fb6e5f02cc9..ef4ffcad131f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1624,7 +1624,7 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  
>  	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> -		return -EINVAL;
> +		return -EIO;
>  
>  	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
>  	atomic64_inc(&kvm_tdx->nr_premapped);
> @@ -1638,7 +1638,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  
>  	/* TODO: handle large pages. */
>  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> -		return -EINVAL;
> +		return -EIO;
>  
>  	/*
>  	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> @@ -1849,7 +1849,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>  	 * and slot move/deletion.
>  	 */
>  	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
> -		return -EINVAL;
> +		return -EIO;
>  
>  	/*
>  	 * The HKID assigned to this TD was already freed and cache was
> @@ -1870,7 +1870,7 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>  	 * there can't be anything populated in the private EPT.
>  	 */
>  	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> -		return -EINVAL;
> +		return -EIO;
>  
>  	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>  	if (ret <= 0)
> -- 
> 2.51.0.268.g9569e192d0-goog
> 

