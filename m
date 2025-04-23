Return-Path: <kvm+bounces-44019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 35275A99AF1
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 23:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24DB61B83110
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 21:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B7A1F7575;
	Wed, 23 Apr 2025 21:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dvn+flL4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685982701D4;
	Wed, 23 Apr 2025 21:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745444801; cv=fail; b=CRH+yMc0Su/5n1bSg74MMPoSP4PrJtrB1y3IbdNaev+ydWPCPQwMaogDVUCRKBFNweHAjvO59E+tpn2yCJoxJZtzfLUvcd1CXtfpmmNIe3TfEGu1+29duOQDJ2Ktfkgx4SPNgirhurX5tVY4lxBcoIlc5Cw3Lqo5VgyLqDsK0+g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745444801; c=relaxed/simple;
	bh=7xsG4XzwSy4jvucL/KAUHfUAWmqGa6wgO1skLsu5HYE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LuT5MJvfOadhAawLRfyDWBHSEcOiGFxFGEMpdEpOxvlqVwPIL+8tmdlcMgwfDjKZteJX47pgUUmgxdv1Q909B9tPXjPkN4Q8F8840GmnAewxiYedOsBN2dFOFj2IffGPeC6dCFXS/sna7t46AukBBkwp5JyOUoMiSb0v9LBbmBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dvn+flL4; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745444799; x=1776980799;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7xsG4XzwSy4jvucL/KAUHfUAWmqGa6wgO1skLsu5HYE=;
  b=Dvn+flL4H2tu7yecWhc25qZ4DS/bS8eqHzDu06Xw0oiEX0vpE5Gtj77A
   WOiDdfRFF9TI0RqbQg8aeg+mvbmJQhFRKuPieMk+nktRQOhKttYHYcvPg
   ZlC/qBXmW1LjQxOt3rg3JXHs2/1QYx5+n2BUliC7OofL8IrTLGoJQPkp8
   AM2VJsc8HZ4uGOUoRtKPE8TxCD/xn55pTyNjEG49EMRzVbTfoB3mouw/H
   8ES4HRWSHl18k5xB7p1sMJQkiQM+kQVnIY74omwC5KRkcu5eghBlPCQRX
   X94GTjz3AddnXuw2EaagUDLhjeOrJOwHxXPhL+K5SKhdvs4hTEogMLhLd
   w==;
X-CSE-ConnectionGUID: rLJuBun2SaaEFNiftXha2w==
X-CSE-MsgGUID: ZEbSa+W4SMumcSuQ+ZdYcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="46177184"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="46177184"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 14:46:32 -0700
X-CSE-ConnectionGUID: x9suKmGuQZS3+p0aq8JXuw==
X-CSE-MsgGUID: gTMS3bGmRlWrO7YEZb37UQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137605645"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 14:46:29 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Apr 2025 14:46:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 23 Apr 2025 14:46:28 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 23 Apr 2025 14:46:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pQ/FvzQ/vD5+IS+1sOmqd9+0Nr1GAN7ag4d5gTcwKA6l/A7SMoB1uHEoJMVVqrl1N9PCXiKetQ3Gl0hyvsPBHjmCOtQbMM6P8+sVepoaOnJZFtwhADgIMissJiIq+tMzwQZgQskWSf6YeL/HIm8ypabiFxxDqXBQT6mDUzvb7KlRPJWJWAbO3pLiQkX50U5VKbarg7Du2mk+bOnZVNzpKtIENyvGPXTKnZMtlDXlA9d843Zp56XdtYkc84jrnWsLiO+BNsOwKL4VK5kSwQgCR43Rek9y3Jwc+b6wyqvqSnHhS3O2n3TLy2EcRztl9Wl2RKBuPc0SW570utjo0XJgIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7xsG4XzwSy4jvucL/KAUHfUAWmqGa6wgO1skLsu5HYE=;
 b=ldb7Y91xIldoYfMjfD8L4A85dr9MRwe7LW/uJ+PkgK4jNv6HCeAg+J3OsbRLoTj3qxJAPg+d9s4xQQlgBmn5rRLxeHI6sAv7Qda1hd/smZRcs+MuMU+ysknvZ/Ec3n82BdaJg2yYuqdlqkWqH/voMOykwUA44puG/KPDQCr990Ngtm7CXSZqrc3Or2W+zbAV+4QStEISE8CeASeTlRm18Th0Oj16APbal8AHg63XHGdsGjqWAYAy1gvxXC1AOMFYrHg3RvfWSjicQr4zxL1/CrwGZ+rNZDYUCoQrFn6oQ3V1e76/olapzGqt2shPfw6OHFfiL2DPdotQyDrTyBkrDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by BY1PR11MB8077.namprd11.prod.outlook.com (2603:10b6:a03:527::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Wed, 23 Apr
 2025 21:46:22 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%5]) with mapi id 15.20.8655.033; Wed, 23 Apr 2025
 21:46:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "vipinsh@google.com" <vipinsh@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
Thread-Topic: [PATCH v2 2/3] KVM: x86: Allocate kvm_vmx/kvm_svm structures
 using kzalloc()
Thread-Index: AQHbox7gNNt5MIEoWkqSWOPujcKUELOms2CAgAALtACAAA40AIAJnzuAgAExvICAAE3OgA==
Date: Wed, 23 Apr 2025 21:46:22 +0000
Message-ID: <8e64fb0f97479ea237d2dba459b095b1c7281006.camel@intel.com>
References: <20250401155714.838398-1-seanjc@google.com>
	 <20250401155714.838398-3-seanjc@google.com>
	 <20250416182437.GA963080.vipinsh@google.com>
	 <20250416190630.GA1037529.vipinsh@google.com> <aAALoMbz0IZcKZk4@google.com>
	 <8a58261a0cc5f7927177178d65b0f0b3fa1f173c.camel@intel.com>
	 <aAkeZ5-TCx8q6T6y@google.com>
In-Reply-To: <aAkeZ5-TCx8q6T6y@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|BY1PR11MB8077:EE_
x-ms-office365-filtering-correlation-id: df84a9b3-5fc5-4fa1-0729-08dd82b04a1c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SkY2MlJUNHV3eGQrTGxQK29MejBwLy9Na1lyV1VJNzZTcjJHQklqdUdReUNh?=
 =?utf-8?B?d2ZmYm5YWUVvQlhmOGRTY285RVdqbE13K1JvRklrMXVHY0NyelFTNlpHMnNk?=
 =?utf-8?B?RUFBaTdOWnFFRjNjWHJtUDdFQSttemt0U2loTzkyTm5sdUpiUWN1TzkvNDc4?=
 =?utf-8?B?aHBpNmZ1UGhvcGNRT1EyQ3BtKzZibnZhaUxPdTFWZFBQcFRySDQ1MEZ1ZHBJ?=
 =?utf-8?B?Y2NBSEI5TG5Rc3FZdlc1SHJ5UnZlWndjaWZSZ2cwLzJmREhEL3JpTXM1dDB2?=
 =?utf-8?B?QWc5VzBjUTcxWjM5ajh2c3ViMk82ektiaTdMZ1U4djdxZEU5RGFCdnlPZDEy?=
 =?utf-8?B?bElCc08ycUhrcDJTUGRmUDJCeEw4Zmx0OUhZRW5rUVNiY1BFQ0hhd05WV254?=
 =?utf-8?B?d3ZHSDBPV1JTcmc5dGlyT25CenZOWjNYcmFSUkFWdUIvTGpqMW04eHRtdHVr?=
 =?utf-8?B?Z3plK0VQSTExK0x4Ly9zcm13a1E0aVg5TW1neEtmcmVKMm03dGdZbXp5VkU0?=
 =?utf-8?B?NU91clhxY3p1TXltbWVlY1FoTmlramk4WFkzSUN4WlVBSW9sOFdCYVNOMGRG?=
 =?utf-8?B?amVianU5eElwMXdsbGlXaUF5TWFEU2lqRzV6VGxpZmhsT2Yrc2t0SlZnRTF0?=
 =?utf-8?B?UlVBNmJBeDJuYXdHTUFtWExGUkxEK1ZRekxrRlBjZVJzMWlqOTl0OWhpK3Zs?=
 =?utf-8?B?WFNKNUZmUVRGZERsMC92Z1ZLUy9TRVNnbXBYVGQ3MFg1c3pDbXFSUFpkdkVH?=
 =?utf-8?B?SW5zSEgzSERTNGZpWlRwdnhJUVBFSGh5Y1BkeWkvSEl1bkVIVlJRNmZIQklD?=
 =?utf-8?B?ZDRlRGszNmJ2MW83c2MrbkRxMDFuaEdFTnRtZ2d3aHNZNWdTTWNPdkFEODBy?=
 =?utf-8?B?NUp4RVpQVmxjTmNUdThaWURHaml4T1hiWDRMcjBZTWttRUVDNlMrNC9uODJR?=
 =?utf-8?B?eVkyYlM2RWRFR21VSTZ2eGtpM0JLclV2dHlhcUZud0xuVDVHYlZYMTFHVDVV?=
 =?utf-8?B?bFYrZFRJOXJIa1lRd2svSzIyMHdvUzdhU2VvTmthRUpPT0xDQXEzejVYV3lx?=
 =?utf-8?B?QTVQc3BYYXN2TWFIL01QOEhMZnlBclRDaUc1b0lqUEtYWHpWaXdMdUV0ZnlV?=
 =?utf-8?B?N0lIUjZ2bERtc1JSRzhwZ0lKOENuaml0d3RLTlUvd3RYbHlaU2tCemYxaHRR?=
 =?utf-8?B?VEpNN3BUWEFnenNKbUVVQ2NsWTZGSUtKOGpxZ3kyQVpzZCt2WVVYem5oZXpM?=
 =?utf-8?B?R2V1czg2Z2ltSGVaaVJrVGh0dUU2VFZTcGdjNzRLTTdQdmhFZ2t3Q20ya1Y2?=
 =?utf-8?B?SzR5SVhHcFJmTmFzY2kvUC9QVmRCd1ZpcXZPSmtEc1dLNVJ5S3JlbjVWUUdB?=
 =?utf-8?B?aXI5SGJjYVBOaUpVZFQyR21sMjJWTlZVVmZDTDhpZFIzSlVLSk5yUlUrNXZy?=
 =?utf-8?B?blROS1FtWkMvYUR1OUYwTmh4SHpKeTJtbG4rZDkwN3pzbGdwN21CNjJpRExj?=
 =?utf-8?B?SDVrdlB0Z0JNZHVOdlZlNWJ1VzhQQjFGd0g4Y1hhdEVHZHZoZXRMZm44N0Qy?=
 =?utf-8?B?b2hOZnpTV2RCUzMyS2IwaWt0UkxjVGh3RkJSKy83czZqMHB5ZmcyalBYdmhL?=
 =?utf-8?B?ZytsWGJpZTQzS09xNFJiWmQ0OTVSMDRlb0x4bysrU3NqZUo1K1dqR3hvU1Fq?=
 =?utf-8?B?UCtySkFsbHBIdjJWUGFTOUZKd05PVEtVVU14b3VOZXJzRHhLZzROR3BWb0FK?=
 =?utf-8?B?OFJxYVlvcFBtb1pqTFNTZWl4U29DUmdEbFh5UWh3RUwyVXFoRkRzQTVuL012?=
 =?utf-8?B?Nnp6Ujk2a1d4Vlh3U1YwclAzbG90eVdWM203TUhTTDZyOGp5YnVCQTA4anRG?=
 =?utf-8?B?RFVCZHJ5cm5MS3c3cXlHbE9mTnoxYTdqR0xpSFZ3djdSOWVzMFBUanZaNVRV?=
 =?utf-8?B?d1F6eUg1ckpBMlhqZ3NCelpoRzRvVUNRQnVXSWFoVk5aWUYrOE5FZlhULzdR?=
 =?utf-8?Q?Ha+RR1bxx8zd1D383Y2mVl4RdHzW/4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NFBhVFhXSTBLdmd1c05iczk5WW50SXpFYWZ5Mml2U1AyNktiYzFoazFsZndh?=
 =?utf-8?B?SWowS0R3RGdIWTkrRG53QUZodDRKS1dRSTlMSHgzeHRhRmY0RDNHZkRYYlB0?=
 =?utf-8?B?OTVYRnkydzBFdy9KeTU1ZmV3OTBlWklMVE5mOHNBQURqQStkL1VlN3N0N3U3?=
 =?utf-8?B?V1Z2OUF4MkdZdndnRW1MSzFXSGRTQitrZ1FsQUlXMVF6a2VnRXg4QndNWm9B?=
 =?utf-8?B?bzlRb2RXZGJIampjYVhReVRwYXdPTXN2eExsU1ZQTjRRVEw4U0lDQjBHcnc4?=
 =?utf-8?B?dHVFeGFEb1NYTVVzaElxQXdnTnlKUm1nQUFUZkpIbHc3Q05qZ2dGL2pLNGxQ?=
 =?utf-8?B?dEV4MytKeU1VSHFaR2FoL0N6QkgyQWxWNmFhcjFlSE5CVC9RY0U0UmpBVFBs?=
 =?utf-8?B?RTI2ODh3STFheXB2a2N1SisxdkNRblVjelU3VkE2MUtsY09zUGJPV1lGcnhT?=
 =?utf-8?B?TVhKWllabzlqZFNhQ0x5SG5GN2ZSblNHVUY5bmpibHhJR2VHbFpZd29IZVVH?=
 =?utf-8?B?cjVYM3pBamxOT3RTcmxySzBWaENNL0RXYUQ4dzZPclpudjJleGkvemZGd1E5?=
 =?utf-8?B?UkdzeFo1UGtRZTQ0Ni80Vy8xZ3haanBwTlB6bElHOTNKYU8xVnpNczhBYTJW?=
 =?utf-8?B?Zi9TaDBGR3BURFB0MGp3SmZyR2xvSUZJS1N0dGxNUnA4TzFZVWVSaDZ4bjcz?=
 =?utf-8?B?RHNuajJNeEtNdmVtWmI5QjhoSkpTRkNCbll6TVpmRGRnemtzK21MdUlsV3py?=
 =?utf-8?B?MWx0aEpsbzRHNlRFM25ub050MW1yTEN6Mm9XeUpVZGFvcndpREdZWXJrV21z?=
 =?utf-8?B?ZGhxK2dWbXRWVENpZHNKWjlnbSsvaHU0azVtL1NuN0Faa09qQ2JYRUtJYW5G?=
 =?utf-8?B?ZGttQlNmMWF3L1JCVDlKcWFzbi9wNkRmaWlsbEdxT3FMZHFBQTBHaHh3d2t1?=
 =?utf-8?B?LzdZRmlXR3NTNzFobkZyemdhMEM1TGtSVktjejNsNU9HTDgxbmpVVTZJUXRp?=
 =?utf-8?B?a09uZktVTUI2N2JCQnZBdzRtOXlwWFd6SmhVdlBvN010bXNyNk1rWGVoYVVa?=
 =?utf-8?B?TkdlbDJ5b0lFbDdPU1VDRE1ZQ2tDOFRFWkdmSThNV2xacmR3WDRwVDZwQTg4?=
 =?utf-8?B?Q3VNUHpPRHBtcm02QWpvYTU3VG1tTVdVTE9ocHMvSmZXeXMwTytRcTNGKzN5?=
 =?utf-8?B?Z3BDcmUvRjFCTktSQUdrZWdUU3lqU0piVkdxcE1iTzNDckJDTmpaaDM2TEo4?=
 =?utf-8?B?Uy9tbkpyU2xIQUloamFVNDc0MnJsQm41WXc4S2orcTB4SUhZa1JuMTFqV2Ur?=
 =?utf-8?B?K1FBekE0YmpvQVhEWmpLVkdvZ3BtZU1PRmxrZHhjVlJDRlRZZExKWnF2enRO?=
 =?utf-8?B?NlA4dDNGRmZMb3NmZzdJNHZNblBZaXRjaTV5WmZyQ3Q3TjJLTVlCaHR3TUx3?=
 =?utf-8?B?L1QvV0J5UWNoK294ZXlyMjFkR1R0THNZN1ZhcjlrWXhaUFNpWXBtV1cwbVlh?=
 =?utf-8?B?dmJyaG9aRGMyRmExY2RDSDNSK2o0RW5BS1pZNnJJRjJ0Z0w4bmRHdUhPMGcr?=
 =?utf-8?B?U0JZamlRajZFd0pnVVBKYzgrU095MFhqSHJaTXZIQ216bG9sNldkM1NVaGtP?=
 =?utf-8?B?SEE3dXV6TGFoaUdnNkQ0M0NtaXZ5elVwSGJBK2xOSFN5K21RT2RnOXU2czRo?=
 =?utf-8?B?VzlyWXNQSW1raWxuQkFwY2tRUDBDZEYvUFR2dHovbXdoVFpTcVo2cGVvWVNu?=
 =?utf-8?B?VXRsdHkwVHdvTlV6a0tLbWJBOVF4NnBHRmlsWXk4SFlNcngydFc1eERZRUEr?=
 =?utf-8?B?c3BCbTQzTzZSRVJRdEJlMGQ4dk5yemIrS3ZYQWUxZXk0VVJjaU16TmtxT09C?=
 =?utf-8?B?YkRERWdRY0EyUFBaWE8xTWtBTmI2VXQzelBCV3c3bXNZbWJvbnJBald1Q1ZL?=
 =?utf-8?B?K28xdXYzamFEQUZnNDd5aCt5WmIrcHVsMzlwc1lRSUdrNlN3dXRwZks2QUVh?=
 =?utf-8?B?cnlDMWhqNTlIQ1NrR01XTFZkdUxGYkpWVW5KUjV3MnZ5L0dwZ3JTNW9NVys4?=
 =?utf-8?B?enI1dUZlelRoWFAyZUVXYkR0c1U2ak1EZDNZcmtIMUMybHpteG4vLzhJdU5D?=
 =?utf-8?Q?hunFw2XJIPXElmQZeOp6kkWxv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6FEBD06E98EE241B54F70173DC03F47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df84a9b3-5fc5-4fa1-0729-08dd82b04a1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2025 21:46:22.5170
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D3lSNtOOelfAYJ9hiB7LucpgEivxDbxwuT7w1e4IrmdbIrenNXI++2iU454iT4Bjl+r7a8XiOg80rESu0YiGTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8077
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTIzIGF0IDEwOjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEFwciAyMiwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNS0wNC0xNiBhdCAxMjo1NyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IE9uIFdlZCwgQXByIDE2LCAyMDI1LCBWaXBpbiBTaGFybWEgd3JvdGU6DQo+ID4gPiA+
IENoZWNrZWQgdmlhIHBhaG9sZSwgc2l6ZXMgb2Ygc3RydWN0IGhhdmUgcmVkdWNlZCBidXQgc3Rp
bGwgbm90IHVuZGVyIDRrLg0KPiA+ID4gPiBBZnRlciBhcHBseWluZyB0aGUgcGF0Y2g6DQo+ID4g
PiA+IA0KPiA+ID4gPiBzdHJ1Y3Qga3Zte30gLSA0MTA0DQo+ID4gPiA+IHN0cnVjdCBrdm1fc3Zt
e30gLSA0MzIwDQo+ID4gPiA+IHN0cnVjdCBrdm1fdm14e30gLSA0MTI4DQo+ID4gPiA+IA0KPiA+
ID4gPiBBbHNvLCB0aGlzIEJVSUxEX0JVR19PTigpIG1pZ2h0IG5vdCBiZSByZWxpYWJsZSB1bmxl
c3MgYWxsIG9mIHRoZSBpZmRlZnMNCj4gPiA+ID4gdW5kZXIga3ZtX1t2bXh8c3ZtXSBhbmQgaXRz
IGNoaWxkcmVuIGFyZSBlbmFibGVkLiBXb24ndCB0aGF0IGJlIGFuDQo+ID4gPiA+IGlzc3VlPw0K
PiA+ID4gDQo+ID4gPiBUaGF0J3Mgd2hhdCBidWlsZCBib3RzIChhbmQgdG8gYSBsZXNzZXIgZXh0
ZW50LCBtYWludGFpbmVycykgYXJlIGZvci4gIEFuIGluZGl2aWR1YWwNCj4gPiA+IGRldmVsb3Bl
ciBtaWdodCBtaXNzIGEgcGFydGljdWxhciBjb25maWcsIGJ1dCB0aGUgYnVpbGQgYm90cyB0aGF0
IHJ1biBhbGx5ZXNjb25maWcNCj4gPiA+IHdpbGwgdmVyeSBxdWlja2x5IGRldGVjdCB0aGUgaXNz
dWUsIGFuZCB0aGVuIHdlIGZpeCBpdC4NCj4gPiA+IA0KPiA+ID4gSSBhbHNvIGJ1aWxkIHdoYXQg
aXMgZWZmZWN0aXZlbHkgYW4gImFsbGt2bWNvbmZpZyIgYmVmb3JlIG9mZmljaWFsbHkgYXBwbHlp
bmcNCj4gPiA+IGFueXRoaW5nLCBzbyBpbiBnZW5lcmFsIHRoaW5ncyBsaWtlIHRoaXMgc2hvdWxk
bid0IGV2ZW4gbWFrZSBpdCB0byB0aGUgYm90cy4NCj4gPiA+IA0KPiA+IA0KPiA+IEp1c3Qgd2Fu
dCB0byB1bmRlcnN0YW5kIHRoZSBpbnRlbnRpb24gaGVyZToNCj4gPiANCj4gPiBXaGF0IGlmIHNv
bWVkYXkgYSBkZXZlbG9wZXIgcmVhbGx5IG5lZWRzIHRvIGFkZCBzb21lIG5ldyBmaWVsZChzKSB0
bywgbGV0cyBzYXkNCj4gPiAnc3RydWN0IGt2bV92bXgnLCBhbmQgdGhhdCBtYWtlcyB0aGUgc2l6
ZSBleGNlZWQgNEs/DQo+IA0KPiBJZiBpdCBoZWxwcywgaGVyZSdzIHRoZSBjaGFuZ2Vsb2cgSSBw
bGFuIG9uIHBvc3RpbmcgZm9yIHYzOg0KPiAgICAgDQo+ICAgICBBbGxvY2F0ZSBWTSBzdHJ1Y3Rz
IHZpYSBrdnphbGxvYygpLCBpLmUuIHRyeSB0byB1c2UgYSBjb250aWd1b3VzIHBoeXNpY2FsDQo+
ICAgICBhbGxvY2F0aW9uIGJlZm9yZSBmYWxsaW5nIGJhY2sgdG8gX192bWFsbG9jKCksIHRvIGF2
b2lkIHRoZSBvdmVyaGVhZCBvZg0KPiAgICAgZXN0YWJsaXNoaW5nIHRoZSB2aXJ0dWFsIG1hcHBp
bmdzLiAgVGhlIFNWTSBhbmQgVk1YIChhbmQgVERYKSBzdHJ1Y3R1cmVzDQo+ICAgICBhcmUgbm93
IGp1c3QgYWJvdmUgNDA5NiBieXRlcywgaS5lLiBhcmUgb3JkZXItMSBhbGxvY2F0aW9ucywgYW5k
IHdpbGwNCj4gICAgIGxpa2VseSByZW1haW4gdGhhdCB3YXkgZm9yIHF1aXRlIHNvbWUgdGltZS4N
Cj4gICAgIA0KPiAgICAgQWRkIGNvbXBpbGUtdGltZSBhc3NlcnRpb25zIGluIHZlbmRvciBjb2Rl
IHRvIGVuc3VyZSB0aGUgc2l6ZSBpcyBhbg0KPiAgICAgb3JkZXItMCBvciBvcmRlci0xIGFsbG9j
YXRpb24sIGkuZS4gdG8gcHJldmVudCB1bmtub3dpbmdseSBsZXR0aW5nIHRoZQ0KPiAgICAgc2l6
ZSBiYWxsb29uIGluIHRoZSBmdXR1cmUuICBUaGVyZSdzIG5vdGhpbmcgZnVuZGFtZW50YWxseSB3
cm9uZyB3aXRoIGENCj4gICAgIGxhcmdlciBrdm1fe3N2bSx2bXgsdGR4fSBzaXplLCBidXQgZ2l2
ZW4gdGhhdCB0aGUgc2l6ZSBpcyBiYXJlbHkgYWJvdmUNCj4gICAgIDQwOTYgYWZ0ZXIgMTgrIHll
YXJzIG9mIGV4aXN0ZW5jZSwgZXhjZWVkaW5nIGV4Y2VlZCA4MTkyIGJ5dGVzIHdvdWxkIGJlDQo+
ICAgICBxdWl0ZSBub3RhYmxlLg0KDQpZZWFoIGxvb2tzIHJlYXNvbmFibGUuDQoNCk5pdDogSSBh
bSBub3QgcXVpdGUgZm9sbG93aW5nICJmYWxsaW5nIGJhY2sgdG8gX192bWFsbG9jKCkiIHBhcnQu
ICBXZSBhcmUNCnJlcGxhY2luZyBfX3ZtYWxsb2MoKSB3aXRoIGt6YWxsb2MoKSBBRkFJQ1QsIHRo
ZXJlZm9yZSB0aGVyZSBzaG91bGQgYmUgbm8NCiJmYWxsaW5nIGJhY2siPw0KDQo+IA0KPiANCj4g
PiBXaGF0IHNob3VsZCB0aGUgZGV2ZWxvcGVyIGRvPyAgSXMgaXQgYSBoYXJkIHJlcXVpcmVtZW50
IHRoYXQgdGhlIHNpemUgc2hvdWxkDQo+ID4gbmV2ZXIgZ28gYmV5b25kIDRLPyAgT3IsIHNob3Vs
ZCB0aGUgYXNzZXJ0IG9mIG9yZGVyIDAgYWxsb2NhdGlvbiBiZSBjaGFuZ2VkIHRvDQo+ID4gdGhl
IGFzc2VydCBvZiBvcmRlciAxIGFsbG9jYXRpb24/DQo+IA0KPiBJdCBkZXBlbmRzLiAgTm93IHRo
YXQgVmlwaW4gaGFzIGNvcnJlY3RlZCBteSBtYXRoLCB0aGUgYXNzZXJ0aW9uIHdpbGwgYmUgdGhh
dCB0aGUNCj4gVk0gc3RydWN0IGlzIG9yZGVyLTEgb3Igc21hbGxlciwgaS5lLiA8PSA4S2lCLiAg
VGhhdCBnaXZlcyB1cyBhIF9sb3RfIG9mIHJvb20gdG8NCj4gZ3Jvdy4gIEUuZy4gS1ZNIGhhcyBl
eGlzdGVkIGZvciB+MTggeWVhcnMgYW5kIGlzIGJhcmVseSBhYm91dCA0S2lCLCBzbyBmb3Igb3Jn
YW5pYw0KPiBncm93dGggKHNtYWxsIGFkZGl0aW9ucyBoZXJlIGFuZCB0aGVyZSksIEkgZG9uJ3Qg
ZXhwZWN0IHRvIGhpdCB0aGUgOEtpQiBsaW1pdCBpbg0KPiB0aGUgbmV4dCBkZWNhZGUgKGZhbW91
cyBsYXN0IHdvcmRzKS4gIEFuZCB0aGUgbWVtb3J5IGxhbmRzY2FwZSB3aWxsIGxpa2VseSBiZQ0K
PiBxdWl0ZSBkaWZmZXJlbnQgMTArIHllYXJzIGZyb20gbm93LCBpLmUuIHRoZSBhc3NlcnRpb24g
bWF5IGJlIGNvbXBsZXRlbHkgdW5uZWNlc3NhcnkNCj4gYnkgdGhlIHRpbWUgaXQgZmlyZXMuDQo+
IA0KPiBXaGF0IEknbSBtb3N0IGludGVyZXN0ZWQgaW4gZGV0ZWN0aW5nIGFuZCBwcmV2ZW50IGlz
IHRoaW5ncyBsaWtlIG1tdV9wYWdlX2hhc2gsDQo+IHdoZXJlIGEgbWFzc2l2ZSBmaWVsZCBpcyBl
bWJlZGRlZCBpbiBzdHJ1Y3Qga3ZtIGZvciBhbiAqb3B0aW9uYWwqIGZlYXR1cmUuICBJLmUuDQo+
IGlmIGEgbmV3IGZlYXR1cmUgYWRkcyBhIG1hc3NpdmUgZmllbGQsIHRoZW4gaXQgc2hvdWxkIHBy
b2JhYmx5IGJlIHBsYWNlZCBpbiBhDQo+IHNlcGFyYXRlLCBkeW5hbWljYWxseSBhbGxvY2F0ZWQg
c3RydWN0dXJlLiAgQW5kIGZvciB0aG9zZSwgaXQgc2hvdWxkIGJlIHF1aXRlDQo+IG9idmlvdXMg
dGhhdCBhIHNlcGFyYXRlIGFsbG9jYXRpb24gaXMgdGhlIHdheSB0byBnby4NCg0KQWdyZWVkLiAg
VGhhbmtzIGZvciBleHBsYWluaW5nLg0KDQo=

