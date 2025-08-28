Return-Path: <kvm+bounces-56016-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3E5CB391A4
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:20:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 55823189AD01
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF2D2512F1;
	Thu, 28 Aug 2025 02:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOaG8tMi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C3C78F36;
	Thu, 28 Aug 2025 02:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756347587; cv=fail; b=FQ0L6EhdCM+RDipxl/trfLv/SgphbFFJCUKu5P6XGTRnNH5MnRMJjiANb5ignKPyl96aUQRSrI2cznA0DPeL7EdaUbC2fK17VYD7sv1eqHEFLwxmRGeH9TBoZtD+Ejh0Rf+E80KTRef8bKhwvAq0BrxXcvbsQ/I4Sm/2/pFcKTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756347587; c=relaxed/simple;
	bh=BDF06HocZ0rvPwbIbCc7VXso5CSZ6LhxOD7MgLKIeUM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NVal88wn6jWOxULvdwHuWuH7gM7EzCTxF/OWqTlDjIHwKxiGKiSj/oKb3Hz9ZWcerCtM0M/cp3U2294/cbPwFtXtpF0nCHqX/uD8xJDwrZhcbpNZNZctGl50uPi7jcCfu0dBNFgpYjnQuaaxS7rSZ+aeAT+Jj978c5EuNLAAjsM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOaG8tMi; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756347586; x=1787883586;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BDF06HocZ0rvPwbIbCc7VXso5CSZ6LhxOD7MgLKIeUM=;
  b=gOaG8tMifZUkPZXkbknRqG4tHr8436iGLgPeIlvPJOcibuYBXG6sOcvF
   QURi5P5Prwgf1PN4UHZ7Z6ysUf3jEQ80Fm0+cvZ6ln/TrowPb+3IcyfSg
   HS4cQaJ9dAvKlFQ7exKzHa31M7dscARMpr9xX/JBpkl0255sada0+U3jr
   1QbCBy/SqKV9v3jrd1STuAFmvmvD67ULcVyKGOzwxgSdC0tvEjJ1d/XgX
   YM4aMG7XovEcCMiEOmo4larhM8BelTUZLHReZnaGmQ7xxJVTcTeuuh+KX
   RXzYinCpa7We6lrN3Lc2Hsfr+FzRNlBm6wzQESSbZBdd7Cfb0Qu8keWm6
   A==;
X-CSE-ConnectionGUID: eq5waOu4QFKI+tqZMoMJ5w==
X-CSE-MsgGUID: Yj0Fb5OLTeqJyb/oAiIEaQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="84012628"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="84012628"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:19:45 -0700
X-CSE-ConnectionGUID: oUX59qB9QQeIHYqTcZ7Big==
X-CSE-MsgGUID: fdlERASnTQaJupSvj+WLjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="174328121"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:19:45 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:19:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:19:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.68)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:19:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzTqz66jH5QSz2kVI9Z8acgUgIy5YjlSEtJfH1+jyFQR8+F9iEbYd2wH17X5CtA9uVUSG8gdX+QbUpALXNDgzH/bzumFEXEBdJQAQUAnydsgZ9+YPtOUNDMuYVTuuOFkVawPA+vL8j6gUI0NEgzMbD7kbexyA7fMHMJO1b6iOi7e9FRl/fQiK2/jemPbuZ7epixZIzxM4uX/EOWbm317jrxN/xb0MfhOpQnyn7IsQfbtVQDHOEN828D3KeEkg3nsdQxDdyiF6z1zW4xhkOCYf5AOJG05z/SowPMbTGiw8EgWFesDVSPJGR/Ie6ku8vnaDW5hebf0ahPN6Nf/e1i0Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BDF06HocZ0rvPwbIbCc7VXso5CSZ6LhxOD7MgLKIeUM=;
 b=mA63cmlsXToyGWp5otWKzQyUzlAnJQfzrUyfAuql/bMsl0mjrCcDqCakqgb2ntia3U/8CbvNOlNMjdBu+2/TSVSUvQCrRlckYVbCtPuKPc0aptz4J1wukUEIlVmxiKinZg3OP8gjA9KvRSvOpCgANO3P0TXLYfcjlwlaDlGhu6Lps8iQUbNkHrTbJmoi5BS0dLz2tr6h2O2o6eO+Tg6IZNYjA0z0rO3pzPeAFhlE54wNuR6BcmhDOTA37OGivZmERzMSwcJ3wVXIo3vC+iU3IGiG9iiEm517RU1HaKIqpO/qsLh5lJYwPt/Z5IuNHdEYCCSRjOjpYydZ2FGYSqTgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8571.namprd11.prod.outlook.com (2603:10b6:510:2fd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 02:19:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 02:19:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>
Subject: Re: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
Thread-Topic: [RFC PATCH 07/12] KVM: TDX: Avoid a double-KVM_BUG_ON() in
 tdx_sept_zap_private_spte()
Thread-Index: AQHcFuZauISCgf+9Q06NADP+L9uuhbR3Vp+A
Date: Thu, 28 Aug 2025 02:19:42 +0000
Message-ID: <f0ab4769b3c7b660b7326fa7cb95c59ebe8a4b48.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-8-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8571:EE_
x-ms-office365-filtering-correlation-id: 742d5297-243e-4f04-c355-08dde5d9592d
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RGdlQnpQaTNkZjFkays4ZmR5VG4wYW5iNUxuZmcyRlZYZUNFV0NESElWZkF3?=
 =?utf-8?B?eDVYRHJBUDUwUUFKcGxTU1d1N2NaMURocHBGbmV3K01YbHBqU2RETkFQczRU?=
 =?utf-8?B?WnVWb2NyeXBJNFJYTEtncWo1Ym9HNG9uMTRCWFkvK2ZQRldjZzNIeUdDVjJ1?=
 =?utf-8?B?T25JVzhBbW4xZUhYMFV0eGY5aVNlc256MzNPSjBpa010dzZvajE2U3NoT1RO?=
 =?utf-8?B?cVdMNm5tV2RXazRUVFBUV3pSMXRLcTRWVEJHNDVSWHVXR0lvY202UmxhUWs4?=
 =?utf-8?B?VTk2NFJBU0Z6Nnk2Ty9aaHdMemZORGNINW5GZDVzOGd1TnpXYS9wdTRIWVBL?=
 =?utf-8?B?ZlN6bEx4RStJWW1EemVYNW1OS3dmT0QyQThRYjBUUU5aaFh2QjN5bllkZFhl?=
 =?utf-8?B?VlVDS1MvN0w3OEl3Ym54ZlBOT2tIZkNURzVQQmUvaHZoaGFNd0FXelk2R3l4?=
 =?utf-8?B?ajdvVUFmZGJ3UjBObitwT1oySGhGd1VUTG5OZUJpUUJDSnpibE5ZZURzbzNt?=
 =?utf-8?B?ZDRhR1NvemFmZGsxVWZqR0FROHVnbFBmOGVXbmJNSmc0KzFzSDlRZGZzZ1R1?=
 =?utf-8?B?ektzQ0dDMFQ1dUh6YmJjUTRhUXp1enpUL1VoTWg1N3E2MmJsc3ZZLzRuUFd3?=
 =?utf-8?B?Q1Awck9DL1lPZjZFcGU5dWZaL0pIOW1QMEt2cHliazNHd254U0NTU0k2VThn?=
 =?utf-8?B?MWo3aWdBbXVWV3pIT2V6QWdmUENoZWVlTEI5ZitTQnUrU1c0Z3d3YndXa2VE?=
 =?utf-8?B?ZVdtUmVSbG5BTDRhSHk1ckdmOFhScDdhS01nalA1TXpHT3k1dExWdnZvSWxL?=
 =?utf-8?B?WWI5cDd5NXBxQStDeGo0eHdxVzFCQ2xudzVOSXlROTBIVVBvcXJ5VkgzdnV4?=
 =?utf-8?B?YUlaTHhlRm4vcFN5TGpzL2dOYXBUYkRVTXhtZXllUmpvc1U1R1F3QWpDdHlK?=
 =?utf-8?B?Y0ZiU0UxR2RmVTR5bGQrTEwrOWVlR25hVE9VRFNRSDRpMGZkK3VSMy95dDNx?=
 =?utf-8?B?aytjeVh4MHZjVnc1RjY5ZkVGRysvVzdQOGkwdlNhelM4YUxYV2xTeWMyR1ds?=
 =?utf-8?B?TXQ0ZkZ3Q1IwMTY2S2JQcUx6NDVWYTl4Ris2T1RVNEFib2VSQjFnclBoWUpq?=
 =?utf-8?B?cGI5bVF1VmplWTY4TVlTdFRxd3BlcjJYenFPNFVpMHE1a3FxYk5tSG5Wem00?=
 =?utf-8?B?ZzFmQnM1dXFydTlFcHNlSXlmZndENlFHN29Oa3hSNS9Ua3JPVHV6cjZEa1Ur?=
 =?utf-8?B?S1kzTXhTWTZVTzRmdVNRWWJMNGs2S3JhRVQrbXdaaTJNRWo4Tm4rWXRnNGl5?=
 =?utf-8?B?YnNHSktsMVNTMGFBQ3ZibFd4QjRvSFp1ckV0RkQ2Ky8yVnRaeXluSm9OaUZ1?=
 =?utf-8?B?aXZhSzJaTjlpWENvY0FiZUY4dkxpaEs3cmthT25SbU5EdlFzeTlsRWU0aGVK?=
 =?utf-8?B?N1UwZEJ3blQwTlozcVFmRC9RMG9mSTZxVTRyWE9Kd2RsRUhoK3YxcFlld1ox?=
 =?utf-8?B?ZHN0YmFvWStsSFZoL1BpbC9vT1B4NjhxSk13Y29jbmxpMW5PM1N3ajNqZTlX?=
 =?utf-8?B?VnFhNlZVUWkxVGlYQ01mVTdKL1ZYalpWOTZ5Mmh5S2FGZGhnVERkRVdIbXVX?=
 =?utf-8?B?WHZVRnZ4ZjZWZzlIb21VUDMxemVNaVFLTHNmbjRCSVZIOHJwTUw5bWVFeWhK?=
 =?utf-8?B?MUZBOElZeXpwck05a05RNTBpU0pmM2dVeUhpMmlJWkNnamVJN20reDh2djZ5?=
 =?utf-8?B?aXE3QnJaakUveDd2ajcxZlA5WExBR0lETml2VXREdG1tVXVRNU9GS1dmVmoy?=
 =?utf-8?B?WDYwMXdVTVBicmppbnpydkhyWW5KWjNqMmF3MlF4aTgvY2g3cHhDcDlnTFNt?=
 =?utf-8?B?cjdFcW5OTS9YTWx3R2d1dCtzWG81UExEQmQ0VU9RLzF1NFZKWG1MVGg1akVu?=
 =?utf-8?B?ek42Ymt1aXd5QS9JYU03cDN3b1RqVm40Ky9sVC9XSzcxNGd3MEdmcE51bVBN?=
 =?utf-8?Q?a/pe9TPut/J77jaCarQnsXr7x7p/Vw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFo2T0xmVkkzM0V2SG9oQk1PSFd5eXdGUzFYa3VhbXBXMzVERzE1UUM2Y0N0?=
 =?utf-8?B?M0p5ZzBRWUF6UzVqVzF3Vlp6Vzk5RnM1V2hJTjB3ODlvd3E5MklmYmRFbEc1?=
 =?utf-8?B?YkU5d3p1ODFLSXJIRzk4Vm9zQ1pLdzdVZ0JMQUxMTWttNjd1ZlYvU1p2Z0pG?=
 =?utf-8?B?b3IxbGtYSmdYMVRQNUhrRWtybW5maTU4UUc3UDViQlFHQ0IvRlRQakhCMHcz?=
 =?utf-8?B?anNrUzJuOGNoWmVCT25lSVlWeTBtaW5zNUpMSkVGaWs5dnZZcit5MVVVY1Fq?=
 =?utf-8?B?M0lJNTlqNE5xc1pzeWtWUVM3bnNsTjdjZm1ZNmhVUTkydHZFcEJLMTkxd0p6?=
 =?utf-8?B?YzRWQTU0Z0dsb0FzcFJjZ0VkK0kwU0g0NEVsbGM4V0Z5dDhURWhMbThNSnM4?=
 =?utf-8?B?Z01pSndhcDlTc0dUalh4WkxVQTloeVhPakxMYVA5SzZ3OE1SeHBKMS9Fa0Qz?=
 =?utf-8?B?ZlFXY3B1TXpBNWRMa1MrSTIrbzMzcUJXSFpqQU94NitqYkZYQ1BRTFhNMVoz?=
 =?utf-8?B?aTNJTHZST3JwNWFIWVJWY3FHU0Zqb3gyYVJyaDZ4YnZabm9hMGhOTGFYeVo4?=
 =?utf-8?B?ay9BWE40SURGdS9ldENzeGg3UmlqanlYdG9TUkxhbWQ0ZHhBalVLUldvSVFj?=
 =?utf-8?B?RC9NWHdCR3hucDQyejYvanhjZTduQmUxNXdXZXFqZXFzakl6SWxpMVd3L0wy?=
 =?utf-8?B?THBDbUc5bThQcTBjQVI0Q2JmeEdBK0g2Y0toN2VUdEsyL1NWR2Jqd2FSTFN1?=
 =?utf-8?B?THZNL2lCSURuTHpjQ1VRdDBDcVo2VzBLTXJXdWZXdERacDlZdXZoVlBVak1q?=
 =?utf-8?B?YnhVelpNeDV1Z2tqV1JMNE5oOUNIeEdYSnZ0NjZpWGJ0QVFwdUhyZnJNcDRK?=
 =?utf-8?B?TmxQMU4xZmZNbkRQK2kxbGpNSVJvVk1BbURQd2RYTkxwSWVHSlVBRkJ3UnBs?=
 =?utf-8?B?cmxBQ2xPYWgvdnRsYnV2SU81RjBkQ0VCMDFaZTdwdzRvbjJGbmozN01tY2l1?=
 =?utf-8?B?eWdiSU9mOEhNdUhMNmZ0TlV3Yi95VDlmZ1hoS2RnWUNBeWxSZ05NclY0VExo?=
 =?utf-8?B?b1BzSWxleW1VSmtBV0VtaDZZM2w4VE9VQUFOVEJWWVZ6Z1ozVGlIc0orYVhq?=
 =?utf-8?B?VW1Xd0lHQlJCUEFEMS95ZWFtSkNzZ0REZUxSam5MVW9MbXAzcGF2V0hiZSth?=
 =?utf-8?B?MEtlQnI0WVd4VzNBRGJscU03d3RpT2wva0VnSXB0RC9LU0NCSHhITHBkL29B?=
 =?utf-8?B?UGl3QmZ5TzRoNUZuS2ZzYUFna1VRMzAyN1FLSTlNZmtLd2NiR2p0SGQzRGdh?=
 =?utf-8?B?OWRWTHl4V1BhVUdRL0FNS3N2ai9iK3RkOG9KazRxL0xkdUt5RzJvd29mbHR0?=
 =?utf-8?B?OHRMbHJ1TFdnVVJJb083Smw3VUEwU1lBU2IzL04zYjlzblFmZDl1VGZ3TXdH?=
 =?utf-8?B?RXdySTYvY0VuSkN2T0d1NFdlNzRuem9UWDl4NktVMTNTNDR6WmVQOUVqNU4w?=
 =?utf-8?B?bWx6OHBiai9SU0I1Z1FFbWNPaVlKeVNFeWNyWU10eHNkaTdLTTE4VkFPQVVD?=
 =?utf-8?B?Mlc2SlFJVzVHZlpXUUpyQ1ZwODVZVUR5eFhiRmVOVjMwaWc4NzdEQU5MbkYw?=
 =?utf-8?B?SjFDSm41bVpTVXhUaUdsU0QrSC9CVVIzT3lEejh4MTN2MjQ4Qk1UM20wUkts?=
 =?utf-8?B?OWhqSnBiMlROOVFDK25GQmF1T2FNdTVEbjVvTEtZMlZUR25DM0ZiN0NZM2tk?=
 =?utf-8?B?VmZpQW5wRWFYZ0MzN1h6SGcyT3FiYVZlUFNSL3NOZHRrb3RUS3BwYjUveC8r?=
 =?utf-8?B?N3ljQUVCV29rSGM5QkFQNERTVXMyKzNobnZVQlNzb1BqVWQwK1h4RDFPN1dH?=
 =?utf-8?B?eWRRUkxGTFZrL3hhN0swcnFseVplWDdMQmtncitXUElxRVFUdHRWTm1qektq?=
 =?utf-8?B?clNkYy8xOVRoaFBmNU1sTnNzR1pJaDBlSVZwNHRmQSt5YzVGNjZvdWRqaEpW?=
 =?utf-8?B?cWlHNTJlOHEzclpGeHdvVG9ad0FEdVNyLys3MDZsdmttVzlNU3BSUlVoSkVo?=
 =?utf-8?B?djZTNjVRa1RBZ013bC94a1FXNjF2c0drMUJFNzZtZUEwZlNkU0F2YS9oN2VP?=
 =?utf-8?B?aVpwQWpLR1hXMEVUaG9JQTg5Q0VOTWVrQWFicTFla1JvVVBCSDd1OG5lcVpm?=
 =?utf-8?Q?7N+mVL1WgmMRfcTg+qcIIXU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99B98C4FEA6623498DE168059A9839C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 742d5297-243e-4f04-c355-08dde5d9592d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:19:42.2744
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hgSsdAkvan0lteVvRaFAGoicbRlB8JlbYo9Jt1IyzYleP9iO7xE0bkw6liNfGG5VeAojV9imiLI4qMOGMRhFy1SPXcN8h9sl8ZHWK3DBZmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8571
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXR1cm4gLUVJTyBpbW1lZGlhdGVseSBmcm9tIHRkeF9zZXB0X3phcF9wcml2YXRl
X3NwdGUoKSBpZiB0aGUgbnVtYmVyIG9mDQo+IHRvLWJlLWFkZGVkIHBhZ2VzIHVuZGVyZmxvd3Ms
IHNvIHRoYXQgdGhlIGZvbGxvd2luZyAiS1ZNX0JVR19PTihlcnIsIGt2bSkiDQo+IGlzbid0IGFs
c28gdHJpZ2dlcmVkLsKgIElzb2xhdGluZyB0aGUgY2hlY2sgZnJvbSB0aGUgImlzIHByZW1hcCBl
cnJvciINCj4gaWYtc3RhdGVtZW50IHdpbGwgYWxzbyBhbGxvdyBhZGRpbmcgYSBsb2NrZGVwIGFz
c2VydGlvbiB0aGF0IHByZW1hcCBlcnJvcnMNCj4gYXJlIGVuY291bnRlcmVkIGlmIGFuZCBvbmx5
IGlmIHNsb3RzX2xvY2sgaXMgaGVsZC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFJpY2sg
RWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==

