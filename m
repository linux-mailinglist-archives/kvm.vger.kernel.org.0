Return-Path: <kvm+bounces-47734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF902AC4576
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 01:11:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 61A13179F57
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 23:11:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC5424291C;
	Mon, 26 May 2025 23:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDFVMVFg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5102417FB;
	Mon, 26 May 2025 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748301086; cv=fail; b=h8nR6/WKlZ8rrfMOC3itpqJvB/sEnMPsjRd8yynKAMaTER11Tryka3GQvt+F+HTykDB3h5qTJ4RVs6B7FAFFxrF/RwagOmuhBfzNdfnxiwaVT/Aaa7Kpbyggn0Tewhv+Pz1BSVTklJ/XYZn0dP48BrVYjUhhOfYF4p/AhLaICwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748301086; c=relaxed/simple;
	bh=WYG4OY+ZDdmeO3/N/A7u9k+vXRhNYgDJ5tWNUd8QfEo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VfP1Azhyp9wKz4eEvqTbll160c3D8L8LAUBz1I/IsWQUInN8mqKG2vKnIpcLhy3TVXNr9xq+CFD6QBL0hjiObufhLurc3GMfD6+WBUQ3rldcIekAfSeStJU9Au4zJyRY9u/I0nZLkCK4w51m13faGgIZcKtR3sjIiqqDKemW48U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDFVMVFg; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748301084; x=1779837084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=WYG4OY+ZDdmeO3/N/A7u9k+vXRhNYgDJ5tWNUd8QfEo=;
  b=YDFVMVFgIOPdv/80DpRsaBSDShffrjwcvGVD6mDNxc+PADAHUjlcU43c
   UCuGre41SmPyS1L45OJo3aFAloA+8Yvvizmytu1KnkU5jfdJDpiHjRV2Z
   /lYIMuw6BgGR5XRSb8qQmk4k2nDOY86hzOgj4OmrWfiHU8V96R8ILBHxm
   xokx3u94buNdsIlgf6TMoaha4VvtRQ2tnpB6BzKSnrHi6erv/92sQMYlf
   5MiIq4xZQiUanddl5JDXAR3arKcyKeYjU8FO/NqJhuxg89k/1k7mWM1+C
   XY22VTb48enTN4zkgTraAggyg2gLAAbMXZ9ed0Pdbt0pQKHQYfXN/O3kt
   Q==;
X-CSE-ConnectionGUID: q3q7gsrRS5GX6iaidK2QlA==
X-CSE-MsgGUID: Njnrf93JTl+vpDc6VaEm8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="67820922"
X-IronPort-AV: E=Sophos;i="6.15,316,1739865600"; 
   d="scan'208";a="67820922"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 16:11:24 -0700
X-CSE-ConnectionGUID: pWEso53kTU21pzM4lzNZtw==
X-CSE-MsgGUID: 9yhEsme0SSynnmOTUd1iog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,316,1739865600"; 
   d="scan'208";a="142905213"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 16:10:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 16:10:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 16:10:55 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.40)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 16:10:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rKMqoWGIeCXvRL3rzYOnDYyj+c68QRcqNtgE41tJx98NVFCdRFvbGDIhOeX5EImAwaXwJEp4n9bImpsVxnkUo5LltllckgmM40sc0c7gDloxVvbd+2n8U3ZWpanKY5ce1BUtT0LItvOa69bTfiwN55YhWD6/qlaKUAqpvvKsEmlzvrIwR+llnD3XOJM6VjU36jXqMwAN6zeYBVDYerDHsjkiuwRIulncR8NJ2qYo2luTpvgeyBijy0NkzO6ZFyI7C22kGkurGAszP2FmlO9itNiDmKBH6Jivns8nEtl/+Qe0ulDlzM6qjP07ijXvHlh0il7KJbgEXJGS8WhSuQRt4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WYG4OY+ZDdmeO3/N/A7u9k+vXRhNYgDJ5tWNUd8QfEo=;
 b=w4mfx1M0YtwzxrJddP7ylNvssmXnZhJOym7pMSl+whE8x2JOq7lEE64vz/oH4L1MyeO8ob/bN5MmL4TJtnTQ8TdBk536Pz+mIlsppszpaZ2xrBxo2aeYOF5bXOZSrNui3SJ8swV3wWLB792htwT+oozZFAkwJ+IY0XU7/SQzZxTmE2PwxJE3vpgognOWGozKqK0IktMOH2acfy4E4twf60IbSd5k/MugrysoapAEdo8CmmIjKlgxTcK9p1q8RH/fft6uWTCsP16W9ncTG7LCIRGeN5ufYeHo6DYKKqj30OeZwqdBz6uez238CG7S4r1AxZHj3X52oXXuF0U8a/h6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY8PR11MB7948.namprd11.prod.outlook.com (2603:10b6:930:7f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Mon, 26 May
 2025 23:10:39 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.025; Mon, 26 May 2025
 23:10:39 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, lkp <lkp@intel.com>
Subject: Re: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Thread-Topic: [PATCH] x86/tdx: mark tdh_vp_enter() as __flatten
Thread-Index: AQHbzn8stz8coGrQ8EK4yIl/ulnPQrPlicSA
Date: Mon, 26 May 2025 23:10:37 +0000
Message-ID: <dba9b129a3d6407948f165b885f9c72975e3231b.camel@intel.com>
References: <20250526204523.562665-1-pbonzini@redhat.com>
In-Reply-To: <20250526204523.562665-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY8PR11MB7948:EE_
x-ms-office365-filtering-correlation-id: ad9cd464-01d5-46b5-e886-08dd9caa878d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dEpBK1lSTDByWjdwWUtqd0NVT0FJWURCRGl5MkxxaGl5R0h1VnhaVG9kdEt4?=
 =?utf-8?B?VHZpOUZPR29JdkRiUGpFLzZrc2hITkJJQlRLRVRaKzUxWnFvTnpoUENZc2ov?=
 =?utf-8?B?aVVkV0VwWjRQckdMRitseVl4WllsM1hSMWt2V0d4QWFRV3Q2aTFkZVdJU0pz?=
 =?utf-8?B?Y0ExdklzQ1RxeVB6QmExWWtxM2pWZ0liSkpWRDNhdE55ZldKUkREMDFzVlJ5?=
 =?utf-8?B?Sm54UWZ1Zm1GbVc0bGZrK1QxS2xTMFNIczc1bU9PNUxveFplaDVucVlURUQz?=
 =?utf-8?B?dTI3MHVuL05IREFOZ3ViQ29lZFZTdlZvRjJGQVNiWHZlQ1JrRW00ZnAwcDZZ?=
 =?utf-8?B?MFovVTJrYWoyeWNBME16K0xBRUxlbkY3R2ZWSDZTc0lLRUJLRkJyWlg0eVJX?=
 =?utf-8?B?ZlU3Tk1KVGdtZzVuZDhwTUVEeGpjTVVET0tzZ0F4bFZoNHRXWWRUL3I1Q01h?=
 =?utf-8?B?UDRZR2VkdUN3MG04eGh3SzFSYThIK1l3L1dFcW5kcTh6elExKzhGd1hOWmVk?=
 =?utf-8?B?RjI1ZE00bHAvYk1SUE5UWkJ6blFWdFRyUWNjV3BERVgzRWJZcitZUCtBdEIw?=
 =?utf-8?B?UEpWTzBhNGhiUUVrWkx3WW0wZTBPWEZsZzJwT2wzYzZYVis0QnI5RFFSbmNk?=
 =?utf-8?B?ZStVcm9NOHRRbFNpMDdjOThYRnB5OTA1L3gwOHNRakt2c3p6bkY2aEsyOWlB?=
 =?utf-8?B?bUFsQ2p5dzRVcjlhdDFGNFpsaHVJM3F4SXhMc0s2VnE5VTd4Y0lSQjhLSklT?=
 =?utf-8?B?VVlyZGZ0d2lRRkZFNm0yWDBDSmRDblc2NDlXakFQZTVKeUk4ZVQ5M0JCZG0z?=
 =?utf-8?B?ck9xTnJyekZBWjdORENlVFpVdXdBK3YycE43MmNsc2NPbEVFVkdxYTZKRjl0?=
 =?utf-8?B?WTAyVktHRnM5TWlkS2NmNHZTMHVSbXZ1ZU00bjVWVHBtVWxsbE9zVHcrSzM3?=
 =?utf-8?B?UUV1bVkxd3NTNGxmUFRhMjdQb0NSMnZrYStFU2hsdGVFWUQ0VjJNSEp0a0FT?=
 =?utf-8?B?b05LZjkrVnNSdnBLSjFReVN2WkQ0WkhGRk9lTXlNczFNWFpJWW5ma2h6N0lL?=
 =?utf-8?B?a1pPMWxPRnYzeUdUaWE0N0VWc0V5ZXppSFFKSXlLbW1jWStkbGt4TjlueStx?=
 =?utf-8?B?VGtDSkRhbEMzaTkzQkhkQWZUTkZnOW8wMHJBWWl0a0xuWHFjY1VOeXo2N1RC?=
 =?utf-8?B?aStQcm5aOHZlTDRlV3V2VXkrZmUrZ1BMMFBKZkV2THdaT3c4YUk4VWM5WG40?=
 =?utf-8?B?QzZZT2l4cG1pZkFZTEU1RGpTRW9jWkxBbXkyTi9kNThWaTFwaDh4ZjEwVUJm?=
 =?utf-8?B?Z3VXS0ZTTkRBWXZEYWxjclpmaWlLYW53UDdheTdsWFBweFl5QzljZVVDSFRE?=
 =?utf-8?B?U2FDT1FiYk4rOTVZSy9yK2lwZDhWc0l0VEl4eE1HZEQrcHhoMVJkbk1MNDRo?=
 =?utf-8?B?aGN5QlpnSytGU1lXUzNNMTlaQmlHU01kSUk1L2VPVVArODRSNVVvelFqSHk0?=
 =?utf-8?B?L0psWGVTcXN0aFU1eml0QzNoeGg1M244cm9xOEJ6NXVVbnl1S21uWVRyK0pr?=
 =?utf-8?B?U3V2UmRmbzlGQkFRT0ZpV1hoSGFhL1MzVjZXODhGWkU0RkhzcWRsbFBBWDF5?=
 =?utf-8?B?Vk5hUXFsMmxHZ0JrQUNSMjIwN2FZZm54Uk1xd0pPTUEveDVRdUVaWE5PRjhV?=
 =?utf-8?B?bmdBL1g4YStVZURibzJGeGUzbkxyWVNaUDk1WWlLMDA4ZnZJdS9UZEIzUUFi?=
 =?utf-8?B?YnE2aXpweFRLbzFrTDFBVVBsWTE0bVFlOVVBRHI2TDRjOG5ZdHVLSzVCakgw?=
 =?utf-8?B?RFBVQXlTZ0hlV2dxV1dsRzBuV0hkUnVEYjlHeFBiaCtuQzJXMFREZUFzcTFJ?=
 =?utf-8?B?Zk1rRjZZSHFUSGF3QUZlc3hJYTI0TllMU3VxdlVFYUNKZVJWdnVUc2F4YzVF?=
 =?utf-8?Q?kRwjBmEM8AbEgAlhOIiUhHMUbjfzVZi+?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YVgzMHNQWVpFV1l2eDhHUUtZMVhTTXNhS0xpNm85WFRLY2JoMUxWS3AxVzVm?=
 =?utf-8?B?VDVPZmJ2emtSTkxpY3lubndHdmptY0JlSkR3N01QVmNXUnhleWFqUnVhYUVr?=
 =?utf-8?B?a1NFMjZ0MTlOSi9KVzNYclNJWGxIYzh4S3dUNVl3VG85OWUzaDEwRWlEci85?=
 =?utf-8?B?WCt3cXNjVjZEOEU4UjJZdit0U0hsbDV1UHMwNUVYVWZ4cVBNWHFpUlRwSGxO?=
 =?utf-8?B?ek9jajAzR3VjNlhWR2VEd0VIaExlMnlkQ3lVK2srTFM1UlhsNmlKUGV6L2xK?=
 =?utf-8?B?NGVQMFozcWIyeHF1NDV5TEMzYW5kUGNjdFFsM3g0cWhOSlh3alQzWE1LUU1I?=
 =?utf-8?B?MDVuZnhkUnFiZ0NCVlduczY3VkVwZ3lNME5PVFVqVzlCMXkyRW5sNUNidWpI?=
 =?utf-8?B?MUxZZmJIZzArcHViSVpKSVlxVkt4SmtJdHlKdVh4bFdBaUs5OVRlYzFBbSt6?=
 =?utf-8?B?MmcxZ1FlMFAyYzZDKzQxWThzRGtWR0dVbTJLN2syaWIxWFprVExnSkFnTjZG?=
 =?utf-8?B?bjJFTU1ZNkRGOWNLQ1gwMHZvVGNRRlVWMUxydGRJNXlIOUpNbVR2d1JMdVJh?=
 =?utf-8?B?SzdHck95ckIvUm85N2pHM2xZdTZSYUVYdVU5OGZLZHZpdlhEcXBScEw3bXBB?=
 =?utf-8?B?amRJV1JrWHBBRnI2TG0vWnBEM0N1cU1mVVlwZnhtaEZ0MTB6b1pNaUgvRTlj?=
 =?utf-8?B?NFVnZWdtMVJRSE9MVGd2TjZxNmo1djVxYzN1TUJlRWV4ZXRIZWdObDlJYWdy?=
 =?utf-8?B?UE8vLzJTRk9wdS85MHdTdGd3Wm9ETWsrY2Y4Q1hNVG0yVndvMWt6WmNhclhu?=
 =?utf-8?B?ZUJ5cDVacmlKSDgrWWFQNTBWdzdqbm9FNkt0WmpqTVdScVhSdzNkTGpDaTFy?=
 =?utf-8?B?S1ZVcmQ1S3Bna0N2Qm5Xb1p5enp6WkhCRzk5ZVJRSEpkWHQ4cUovdTZPYWVU?=
 =?utf-8?B?dmZkZ3BMQk1jd1hJQXVFbUdMRlFLenY0amNXdzRia0l4QTNGQkdVUjNySWpN?=
 =?utf-8?B?SEFGOXBsd0luWWdhdWVzeExYSjcwdHh2U3FZaGRCMEl5UkhvWGg1NmQrRkF6?=
 =?utf-8?B?UGg2STMwbnZZWFdOeWxjZHc0bzhNWE44VGszRmZXV2cwSG5tVlRqclpkR0Yv?=
 =?utf-8?B?MktNNUZTVVhnTDc4TWhHTXI5L1gvZldZSHNEZE02SDJFbm8zTUUvN1Vaa2Vw?=
 =?utf-8?B?STF5WjlwZWtqV1NaMSt0dTFMWG8vNjBYVVVwb1JiMXJPajhFYzBUV3haNHJr?=
 =?utf-8?B?RHdNVmxhcEpTcGN1WWpGMklmRDViWHdSUm0yakExZFRiZDVWby9CaVZHdXNV?=
 =?utf-8?B?aWZZTlVUTitvQTd2M2hZei9zZU5SYzZsNHVjcDNlZFRGWFFiV3BSQ1UxcjdR?=
 =?utf-8?B?TjRDOUhrTllSbnVmVnNESUlTNDFEQ3M2RjR3L0hJcUY1KzdxNlczT0FMY3R0?=
 =?utf-8?B?TWRlQWFvaXVXS3VOejBON1BVdzlyV3V1TXB5U3pxVXB2U0xKUEZxTXZvTlhk?=
 =?utf-8?B?LzZhR3JwaGlaUnhJOWx0TGtrR2w3eXRjZmJGbEM3R0dYMWM0czk4SjEvSUhY?=
 =?utf-8?B?ditpUElYNmVRRzNYZThvd1E1RWp5UFptQmt3MmxsazdXSXkydWphTFJjdXZI?=
 =?utf-8?B?aDh2V3dFS3ljd1pNeXUzZytTTTA5QWZ5WmJURFZhYXQyOE95dU0rSkhGdzJr?=
 =?utf-8?B?ZGhHdzBnZ0JqQXFMWEVKVmREMFhXMDYxYSszOXZMLzdUQUl0eURlQmozK3hZ?=
 =?utf-8?B?alJIUU1oVnh5bWRzUDIxY3AwSmhFaFY1Z0dlelFsMmY2WjBqQmVyZCtuaWMw?=
 =?utf-8?B?MFBlekRmNVZTNVVVMTJVSWxoeXc5V3hhcm8rTEhHNHEyUUp6aFdyMmpNYlFC?=
 =?utf-8?B?VlNoMnpWNEZ3bUdvVWtWTzY2MG82bGF1a3RIMmUycVVaakZrdTNsK2pSdXZi?=
 =?utf-8?B?NkNMZ3hBQ0VPczZVUm4yTE8rV21veWxQc1dCWHFERW93K2NWYUJjNkNMVjhL?=
 =?utf-8?B?cmFaRSt3RE83d3Zwa0lQNUlUaEl5Q2dFRFVrRzJsV3VIZEVTMTBWMGRnVnFD?=
 =?utf-8?B?VGFUY2pFeWdpa2NsWElmQmExQ3BhTlNHTTV6YUFDMEQ1aEpzcWJlV1BNRW92?=
 =?utf-8?Q?gqOy/EI/iP2KZIBPA3ZX13jGe?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3B6C1748FC290547A01166E012FA2C91@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9cd464-01d5-46b5-e886-08dd9caa878d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2025 23:10:38.8452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bBkP5vGPOCRW6e3pVm/n/heFGNsQyt02xIXuDBHCo6e0Rkf+Xig/R6e4XiH1vQJ9m4oYq3rqufCf3uPuzxi6XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7948
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTI2IGF0IDE2OjQ1IC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBJbiBzb21lIGNhc2VzIHRkeF90ZHZwcl9wYSgpIGlzIG5vdCBmdWxseSBpbmxpbmVkIGludG8g
dGRoX3ZwX2VudGVyKCksIHdoaWNoDQo+IGNhdXNlcyB0aGUgZm9sbG93aW5nIHdhcm5pbmc6DQo+
IA0KPiAgIHZtbGludXgubzogd2FybmluZzogb2JqdG9vbDogdGRoX3ZwX2VudGVyKzB4ODogY2Fs
bCB0byB0ZHhfdGR2cHJfcGEoKSBsZWF2ZXMgLm5vaW5zdHIudGV4dCBzZWN0aW9uDQo+IA0KPiBU
aGlzIGhhcHBlbnMgaWYgdGhlIGNvbXBpbGVyIGNvbnNpZGVycyB0ZHhfdGR2cHJfcGEoKSB0byBi
ZSAibGFyZ2UiLCBmb3IgZXhhbXBsZQ0KPiBiZWNhdXNlIENPTkZJR19TUEFSU0VNRU0gYWRkcyB0
d28gZnVuY3Rpb24gY2FsbHMgdG8gcGFnZV90b19zZWN0aW9uKCkgYW5kDQo+IF9fc2VjdGlvbl9t
ZW1fbWFwX2FkZHIoKToNCj4gDQo+ICh7ICAgICAgY29uc3Qgc3RydWN0IHBhZ2UgKl9fcGcgPSAo
cGcpOyAgICAgICAgICAgICAgICAgICAgICAgICBcDQo+ICAgICAgICAgaW50IF9fc2VjID0gcGFn
ZV90b19zZWN0aW9uKF9fcGcpOyAgICAgICAgICAgICAgICAgICAgICBcDQo+ICAgICAgICAgKHVu
c2lnbmVkIGxvbmcpKF9fcGcgLSBfX3NlY3Rpb25fbWVtX21hcF9hZGRyKF9fbnJfdG9fc2VjdGlv
bihfX3NlYykpKTsNCj4gXA0KPiB9KQ0KDQpKdXN0IEZZSSB0aGUgYWJvdmUgd2FybmluZyBjYW4g
YWxzbyBiZSB0cmlnZ2VyZWQgd2hlbiBDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVA9eQ0KKGFuZCBD
T05GSUdfU1BBUlNFTUVNPXkgYXMgd2VsbCksIGluIHdoaWNoIGNhc2UgdGhlIF9fcGFnZV90b19w
Zm4oKSBpcyBzaW1wbHk6DQoNCiAgI2RlZmluZSBfX3BhZ2VfdG9fcGZuKHBhZ2UpICAgICAodW5z
aWduZWQgbG9uZykoKHBhZ2UpIC0gdm1lbW1hcCkNCg0KVGhlIGZ1bmN0aW9uIGNhbGwgdG8gcGFn
ZV90b19zZWN0aW9uKCkgYW5kIF9fc2VjdGlvbl9tZW1fbWFwX2FkZHIoKSBvbmx5IGhhcHBlbnMN
CndoZW4gQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQPW4gd2hpbGUgQ09ORklHX1NQQVJTRU1FTT15
Lg0KDQo+IA0KPiBCZWNhdXNlIGV4aXRpbmcgdGhlIG5vaW5zdHIgc2VjdGlvbiBpcyBhIG5vLW5v
LCBqdXN0IG1hcmsgdGRoX3ZwX2VudGVyKCkgZm9yDQo+IGZ1bGwgaW5saW5pbmcuDQo+IA0KPiBS
ZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+IEFuYWx5emVk
LWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gQ2xvc2VzOiBodHRwczov
L2xvcmUua2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjUwNTI0MDUzMC41S2t0UTVtWC1sa3BA
aW50ZWwuY29tLw0KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBCb256aW5pIDxwYm9uemluaUByZWRo
YXQuY29tPg0KPiAtLS0NCj4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14
L3RkeC90ZHguYw0KPiBpbmRleCBmNWUyYTkzN2MxZTcuLjI0NTdkMTNjM2Y5ZSAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYw0KPiBAQCAtMTUxNyw3ICsxNTE3LDcgQEAgc3RhdGljIHZvaWQgdGR4X2Ns
Zmx1c2hfcGFnZShzdHJ1Y3QgcGFnZSAqcGFnZSkNCj4gIAljbGZsdXNoX2NhY2hlX3JhbmdlKHBh
Z2VfdG9fdmlydChwYWdlKSwgUEFHRV9TSVpFKTsNCj4gIH0NCj4gIA0KPiAtbm9pbnN0ciB1NjQg
dGRoX3ZwX2VudGVyKHN0cnVjdCB0ZHhfdnAgKnRkLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICph
cmdzKQ0KPiArbm9pbnN0ciBfX2ZsYXR0ZW4gdTY0IHRkaF92cF9lbnRlcihzdHJ1Y3QgdGR4X3Zw
ICp0ZCwgc3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXJncykNCj4gIHsNCj4gIAlhcmdzLT5yY3gg
PSB0ZHhfdGR2cHJfcGEodGQpOw0KPiAgDQoNCkkgZGlkbid0IGtub3cgdGhpcyBfX2ZsYXR0ZW4g
YXR0cmlidXRlLiAgVGhhbmtzLg0KDQpJIGRpZCBzb21lIHRlc3QgYW5kIGNhbiBjb25maXJtIHRo
aXMgcGF0Y2ggY2FuIHNpbGVuY2UgdGhlIHdhcm5pbmcgbWVudGlvbmVkIGluDQp0aGUgY2hhbmdl
bG9nLg0KDQpIb3dldmVyLCB3aXRoIHRoaXMgcGF0Y2ggYXBwbGllZCwgSSBhbHNvIHRlc3RlZCB0
aGUgY2FzZSB0aGF0DQpDT05GSUdfU1BBUlNFTUVNX1ZNRU1NQVA9biBhbmQgQ09ORklHX1NQQVJT
RU1FTT15IFsxXSwgYnV0IEkgc3RpbGwgZ290Og0KDQp2bWxpbnV4Lm86IHdhcm5pbmc6IG9ianRv
b2w6IHRkaF92cF9lbnRlcisweDEwOiBjYWxsIHRvIHBhZ2VfdG9fc2VjdGlvbigpIGxlYXZlcw0K
Lm5vaW5zdHIudGV4dCBzZWN0aW9uDQoNCk5vdCBzdXJlIHdoeSwgYnV0IGl0IHNlZW1zIF9fZmxh
dHRlbiBmYWlsZWQgdG8gd29yayBhcyBleHBlY3RlZCwgYXMgbGVhc3QNCnJlY3Vyc2l2ZWx5Lg0K
DQpUaGVuIEkgZGlkIHNvbWUgZGlnLiAgVGhlIGdjYyBkb2MgWzJdIGV4cGxpY2l0bHkgc2F5cyBp
dCB3aWxsIGRvIGl0IHJlY3Vyc2l2ZWx5Og0KDQogIGZsYXR0ZW4NCiDCoA0KICBHZW5lcmFsbHks
IGlubGluaW5nIGludG8gYSBmdW5jdGlvbiBpcyBsaW1pdGVkLiBGb3IgYSBmdW5jdGlvbiBtYXJr
ZWQgd2l0aMKgDQogIHRoaXMgYXR0cmlidXRlLCBldmVyeSBjYWxsIGluc2lkZSB0aGlzIGZ1bmN0
aW9uIGlzIGlubGluZWQgaW5jbHVkaW5nIHRoZSBjYWxscw0KICBzdWNoIGlubGluaW5nIGludHJv
ZHVjZXMgdG8gdGhlIGZ1bmN0aW9uIChidXQgbm90IHJlY3Vyc2l2ZSBjYWxscyB0byB0aGXCoA0K
ICBmdW5jdGlvbiBpdHNlbGYpLCBpZiBwb3NzaWJsZS4gDQoNCkJ1dCB0aGUgY2xhbmcgZG9jIFsz
XSBkb2Vzbid0IGV4cGxpY2l0bHkgc2F5IGl0Og0KDQogIGZsYXR0ZW4NCg0KICBUaGUgZmxhdHRl
biBhdHRyaWJ1dGUgY2F1c2VzIGNhbGxzIHdpdGhpbiB0aGUgYXR0cmlidXRlZCBmdW5jdGlvbiB0
byBiZcKgDQogIGlubGluZWQgdW5sZXNzIGl0IGlzIGltcG9zc2libGUgdG8gZG8gc28sIGZvciBl
eGFtcGxlIGlmIHRoZSBib2R5IG9mIHRoZcKgDQogIGNhbGxlZSBpcyB1bmF2YWlsYWJsZSBvciBp
ZiB0aGUgY2FsbGVlIGhhcyB0aGUgbm9pbmxpbmUgYXR0cmlidXRlLg0KDQpPbmUgIkFJIE92ZXJ2
aWV3IiBwcm92aWRlZCBieSBnb29nbGUgYWxzbyBzYXlzIGJlbG93Og0KDQogIENvbXBpbGVyIEJl
aGF2aW9yOg0KICBXaGlsZSBHQ0Mgc3VwcG9ydHMgcmVjdXJzaXZlIGlubGluaW5nIHdpdGggZmxh
dHRlbiwgb3RoZXIgY29tcGlsZXJzIGxpa2XCoMKgDQogIENsYW5nwqBtaWdodCBvbmx5IHBlcmZv
cm0gYSBzaW5nbGUgbGV2ZWwgb2YgaW5saW5pbmcuDQoNClNvIGl0IHNlZW1zIF9fZmxhdHRlbiBt
YXkgbm90IHdvcmsgYXMgZXhwZWN0ZWQgaW4gY2xhbmcuICBCdXQgSSBndWVzcyB3ZSBjYW4NCmJs
YW1lIGNsYW5nIG9uIHRoaXMsIHNvIG5vdCBzdXJlIHdoZXRoZXIgaXQgbWF0dGVycy4NCg0KWzFd
OiBhZnRlciBmaXhpbmcgdGhlIGJ1aWxkIGVycm9yIEkgbWVudGlvbmVkIHRvIHlvdSBpbiB0aGUg
bGFzdCByZXBseS4NClsyXTogaHR0cHM6Ly9nY2MuZ251Lm9yZy9vbmxpbmVkb2NzL2djYy9Db21t
b24tRnVuY3Rpb24tQXR0cmlidXRlcy5odG1sDQpbM106IGh0dHBzOi8vY2xhbmcubGx2bS5vcmcv
ZG9jcy9BdHRyaWJ1dGVSZWZlcmVuY2UuaHRtbA0KDQoNCg==

