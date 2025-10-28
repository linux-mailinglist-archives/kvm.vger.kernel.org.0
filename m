Return-Path: <kvm+bounces-61312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41930C160F6
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 18:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9B4B3B0ABC
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 17:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75F66346E69;
	Tue, 28 Oct 2025 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mUzHSRpn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4EF13D51E;
	Tue, 28 Oct 2025 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761671040; cv=fail; b=ju9EljrDFsiMteLvil431XiNQfDPSgixPahprIbx7JR8waR1xpy56FhEm5J9K3Xdoyn9viZaOJDpYFL3Z1le5wxu3lzJpFb9PlxT30OJfdBM5B9YiZGZKgXzAQNwRmTjvorzwIiWcj7C6TAFF63yd0fOFxglbDOPxCZuHGa3Z2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761671040; c=relaxed/simple;
	bh=RJJT2Fl+RWBY+6I6t8da+enwV9NjNLsnZ8x6nac84Ho=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ihRPONs1nZml17dbY1aZCKKxgiBiheK4cR3gbXpBgdXlb9tKHMl53oEQhMRlsSEn+9hpxKjT7d0yVA5m//M72FRyi4NG9l5DJGhOzgeKZ0xlWpVR9267/w2ehkdvSoQziTn3Ltu99OfFIpyi42aiLA1ie+soMpyrjZxMGJa6wyI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mUzHSRpn; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761671038; x=1793207038;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=RJJT2Fl+RWBY+6I6t8da+enwV9NjNLsnZ8x6nac84Ho=;
  b=mUzHSRpnHSjsILWYpkl0nal0qQcz7mEgLuk7/xJodzj/rAut0WuPBCtN
   iRHy3fRpCwa0NoURJW9X0qUXUO2MBwL06K0LchOyauJCsXaBlJd1tUWKK
   QqqKb6NM5ths1JIcW3YnDb0KgfQRH8ny+vGLselFT+s0T0yykXm9QZLA7
   rMI+1m8lr9e8lfD5WYOFoETC1CVizhbiMT+E6g5en4jhBXtrVQCqVoIPv
   HzJ2hI1oDLT31J2JXVER+OECO5QfSbRU8UXZljkJ7RCIQRXagZ/XejS7V
   kSm5fCRmnUyN+NsOfKRkkd67NdoC57qWVCzocEhMDOXIPJPKPLeHGoxIr
   Q==;
X-CSE-ConnectionGUID: 3F81SPfsS8KFofvZ37PR8w==
X-CSE-MsgGUID: fxvrCmKySEafRzDVNFWJzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63928865"
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="63928865"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 10:03:58 -0700
X-CSE-ConnectionGUID: 1slJf5NOQASDYvHcT++n4w==
X-CSE-MsgGUID: RcaJEW7YRI6NxpUIsatKYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,261,1754982000"; 
   d="scan'208";a="185041334"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2025 10:03:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 10:03:52 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 28 Oct 2025 10:03:52 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.27) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 28 Oct 2025 10:03:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N127v/XcRQwTEJBIajFuhJ0uALrdMs731VJKp+Rr8G0HU+XjsEvQnKKIxS+tzb+wrew2OUHhdC/dHzQpgYXXsz96K43cC5y0rnNX918IQFTYvPx0hmDgXQJMHswGu8r21T84IrQsLkIarPHVRzNo2v/cm2Dd0DGe55JoVXyME7yX94M31b1jU32d1O+TgqtncDxhZ/IZMlsaiYcGQQa5K+kw0WkL5tjS6APsf9MAemkZMGB4uepIfoWHfaif1lS/c31wY211MNZmEn9lHMQhsrwo21maRrFTWH5NCLHLOajr6GY5Fn/0WonQUjjat/kzd2JC4TAg9zU5du4o6RkDCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67hGUHkX1HovuWgp4MOQlitPLap2NsHKR4ZGIVw7LjU=;
 b=cXktKHmlVJvC7UWN2FEgTO1IhCJOlkrRA8a552gwh0YCkNUPT17XBmqiZzFO2JcKMCAVIuTUR24Mt0FgbWqaJl+peL+vftPFWluA3+SRd9KFeR3PAXsWypS3rO9WCzF2S5isftc5o1azysuLmJWCUVOmzd0DD6GNgyGLPRi9fQ4r5htRy1jjU/BC+a5DGdwZ8//fG7mlXaptRndqYielC3kg3ilIHthKYyvwELFM7qiXVMEEXakzhfZRWrDQ4gWFlD2wxmdIlmB3dGcUlOHpRBEki2T2n+QkWBOT19aYIkertTYtmtepIk6GL42dKY4Mb76K9hGkFwPbanj1VwBcHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Tue, 28 Oct
 2025 17:03:47 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9275.011; Tue, 28 Oct 2025
 17:03:47 +0000
Date: Tue, 28 Oct 2025 18:03:44 +0100
From: =?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>
To: Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
	<matthew.brost@intel.com>, <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>
Subject: Re: [PATCH v2 16/26] drm/xe/pf: Add helpers for VF GGTT migration
 data handling
Message-ID: <yuus76pxd2kcgkr2neoruxa3l24qudl6sezuq3tt5ctc5skter@67vmtfsgvolk>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-17-michal.winiarski@intel.com>
 <92122385-b328-4e96-8f2f-525dff69e3f2@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <92122385-b328-4e96-8f2f-525dff69e3f2@intel.com>
X-ClientProxiedBy: BE1P281CA0286.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:8a::13) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH0PR11MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e92bc77-afc2-4ce2-36a1-08de1643f5b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZlNNZ3diVllaeDVPUHVCTW84Q29keU8rWjljcjJTYS9BbG1Wclhkc0Q4Z2JH?=
 =?utf-8?B?OXN2T1Z6aEc2Q2hiNFhVbkdsUUlUQmZLSCtXL3krcCtiOHdWUnJoa0RSTGxH?=
 =?utf-8?B?QUZ6eWhSRzR3U3MyOXZTUE02WU1kTHlocDl2V0orS0R2K2FiOXZhQnNhUkw4?=
 =?utf-8?B?S05EN0E5bTZjaTgwNUxtbEtUeVRXQ2xVOGp4SXAvVWNrVHh4OThsOEpoMFNH?=
 =?utf-8?B?Um5DcmV6U2JId2o2am55UHJkTE5pWWZWWGxwSHZBKy9vQUppajl0b1VvNHUr?=
 =?utf-8?B?VmdFYWQyQi9iQmVaRUNzZXVxUWxSU1dTWFhQR08wd1FGTm8xZjFTZEdTVDVZ?=
 =?utf-8?B?ZUdqWWhaTGkrb203bXpYNUlTS0R5QkFKM2E4U1hQMC93enJuR1hmZG9ZWlg4?=
 =?utf-8?B?aEkrb3NpS0dLRm5sdGF4QjVGNS9HTlQ2aWtPcW5sZ0JNOGQ2b0hkbXNGUm5J?=
 =?utf-8?B?WFBZa1YrYXBLOVdpM25vZVdjS05lcVJzTGtsVEZWbWcwMnR3S2VNQWpMNFBH?=
 =?utf-8?B?bmJrOTdqVXEzNmhPem44ejlMSU9oSW4xcjFCdzJvTlV5R2pRUWhuWUEzVnls?=
 =?utf-8?B?MUpJK245THBmektjWXdFWmRzR2FoRzlFR3pCNUdjSEVNTklERTRpUklmaVpo?=
 =?utf-8?B?cXdUYUErb3Z2TVlEVlJ6eWZHWEkvRmROaGNnY0NsYjNULy9CcEV2dmtRYmJ4?=
 =?utf-8?B?ZHZmaithdm9FRUZWN21TMmtCWHA4ai9xeWFQNFZ6K2NLSjRpU0JIRzVSNytu?=
 =?utf-8?B?Mm16Qi8zNWtYMklFU0o5c3JFck95MnluS0FGNGU0Q2ZyNUl4elhCVXhFSldT?=
 =?utf-8?B?TUFOdnhGYTlRR3BtY1pCNVRQVjNaeUdRU01xK1hKWEhxNGYza1E1WXl3dTF1?=
 =?utf-8?B?MmRqNmRHWHdRSWowMHZ3ZlpTRkROUXdhZlVXUHkydkx6dVpBRUpibnVXQ0hv?=
 =?utf-8?B?KzduVkcxakJEekhTTjYvUEJ5Szlzd0hTMWp2SkJVYUlKV0tIZWhoM3VxQXc1?=
 =?utf-8?B?SURibFpiWXR2TEtkMmlkd3ZxamhjcUF5MTkveFdMUlRId3JvWXRGcWpWZmtQ?=
 =?utf-8?B?MkgyeDZlWE9lN2wzc3YwanpHVExlejBDbStIdGczK1l0dGxLVTloTmZ2SWV4?=
 =?utf-8?B?eEJDM05pOFBDYWMrRGhadVRhdVhRbitVRmozelhRcDRrTzRUZXppMEZZZGt3?=
 =?utf-8?B?b0xtQTFwc1pQRldDN1hZdmRTd1ZaYXdCV3FodWVDaVRrdUV3VmhtdzFoOE01?=
 =?utf-8?B?Uys4ejVsSGtwR0YrdUFNRmNYYm43cDhpSG9JNFN6R2QzNmxEU3FmVU83cWNz?=
 =?utf-8?B?N0FFbitFc25NSWswL1F2UTVkUzZMQnpOd1BZd1UxSDBJbG0vMitaMUFjYWhQ?=
 =?utf-8?B?VGNsbTB4Y29EVWJZazB5OW1aUHdmcHJRckJrTU5uNUZsL1ZjZE9mQVpDMUM5?=
 =?utf-8?B?aUVoVXNha28yZ2dLM2REZTVMQkFIVnprTzFHRkp3bDdtSHJ4UVNlRHJ2SUlT?=
 =?utf-8?B?Y1U2Yks5U0ZEMXpUNmx4N3dNWmFEUERGWHUxc09TSm1SVXhTb0RjTVlEajlU?=
 =?utf-8?B?QmdCbDBFR1dHQWZYc3oxTGdJR2ZDQW5rMEN5U2tZRXJpSFBFelRGOWh4V2hm?=
 =?utf-8?B?dXFoUXNpTzFNQ2RoTnFoYzBieHdvNnMwWmorT3RzUkFjcU95RDJsdGhuKzVJ?=
 =?utf-8?B?Z1podVlRaW1kSzd4OWhZUnZCRTZsbGFtRUNIVTFoaHhDSXhIT2oxTHJzajBS?=
 =?utf-8?B?aDhQNVE1MEdEQ0tzRjJHeW1xNEhWV2ovUUxXUlNxNXZBK2lUWlRXQmJuR0dt?=
 =?utf-8?B?dmZBcUdFYUZsMk9WN0x6dHozS2pCOWx1VENLY1pYVGpTdzNnU2REYXNsbDFR?=
 =?utf-8?B?VHJtTldPZmVQblJwdXFQTWZmTzR0MkFGaU5lMjYzcXhBeDdvQXpTQWdvS2dk?=
 =?utf-8?Q?MPJo5HD4+r1GqsMo8cSExevNUVVpg1GC?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkIyUEFrN1grR1BpTE82RmVOMTQ2YzJkVURWTmhtTG5pN1pYYytyRU8rR29o?=
 =?utf-8?B?VmNiWktXK1RER25OWE4wZUYxQlYyRmRhQW03WVRwMm9ZK2dPVStDZmdjdVNJ?=
 =?utf-8?B?SWFuRnNGOEZjMEtTSjBDeERHT3ZEeDlVVEdPaVRES3dzSml4eEkwTThPV1VI?=
 =?utf-8?B?cklESVlpSUV3a0pJbnQ4dUZWRS9QNHpJWGwvUUxIb2Ewem13MDRwZGNzNlhH?=
 =?utf-8?B?L1FuS3pna1BWTUFFNXg3VWtjbnhncDlEdytJUDVTZFdOMExqV251bnJoTjRk?=
 =?utf-8?B?MkNHK2taZDViT2EvVk5yYTNpMEFsMEcwdXBsM2xtaUxPS3FodHBPbnRJWGlS?=
 =?utf-8?B?SkpPenBrYkM2RmZLQVRaSVNuK29neE1xN3I1MEtJalVVeWhreDc3UlZyeDFp?=
 =?utf-8?B?WEFybHdsdDRiUjRnNXVJeENXVjA4KzZjdUdnS0ZtbFgrc2NLc3dxdU5ZVzFU?=
 =?utf-8?B?blMrQzU4THVqNTk1UHlyYkZaU01ZcnJMOVdOaXFPa21DRCtmRGZSdzZ4WlZm?=
 =?utf-8?B?dUVjT29hd1pDcnZYQTFjS3dObEQxcnNnT2MyTnY0VWFhVDdoWUtWVjNMQWVv?=
 =?utf-8?B?Rm8vNVpvM2d6NlFLbU92akk1cWFyQXl4aWdMSjNzeUQ1L2ZwMWFod255S1pU?=
 =?utf-8?B?ak5idGVITVI4QzhQa2tML2Mwc3l5dEFyWHZIUk9YZklXNysyY2I5ZmwwTVN4?=
 =?utf-8?B?NkxYR01uYjkzbVhQcGd4YlNYV0lOL0Q0Ti91ODdLeEdTSU9EVzZFenU4ZkFQ?=
 =?utf-8?B?MDdWOEZaTGZyNlVFeGxZV1NtOG90eUFpSUh6TDN0ZW1tUng1bWJyem9oSG0x?=
 =?utf-8?B?UUJSbGlrNmEyUjZrVTdDc0JRWDF4VlcxWFZhTTNYek9jTTJDU0dXbzJzNVVX?=
 =?utf-8?B?WTVSdHFKeFNpOXdiS081Z2dYS085cjNWWm1yVVRZbUFxeG80R05YYlRkR3Zt?=
 =?utf-8?B?TEh2Tk1LU0JISTJtVHg5R1FiL3BTNWU0Z0tkenNDNEVWdnc1andnUERCZmhY?=
 =?utf-8?B?eC8xODRHSzJYRUdYbU45UDNzUGtQU1RwMFVjcUoxNXM0ZVRqQ1dFcDVxNnA0?=
 =?utf-8?B?czBKZFFRUmUzTnhrZXdsRElsbTh6MlliRWQ0bnVjSGZySHhtUTBHZzRjeWlo?=
 =?utf-8?B?MS9pQmY0dVJRZi8vRCtlSFBlUTlWVERrMjMvVE5RMWNLNE1aTXhYaXFNUjRU?=
 =?utf-8?B?MDV4TldnUS9Pemc5ZjMwcnVDV3U1b2ljdVFnQXZUUVRqb1dWeFVCSmdybXBI?=
 =?utf-8?B?RjIyYzErTk5jVmJNL29oWDErSDFQTEwrZmRhUzZDaW52K1QweEFvYmJqMlpN?=
 =?utf-8?B?cnBEQnhNV2JRcDExbW9JM1hMaHBWamEzVkZXMlkxYVhVWnVMZFRTdUJFMnlU?=
 =?utf-8?B?dDZVRG54NWE2S0lqYVNSS05Md0hZSkhQWEJvVkRMZ1M4MFA2VFIyNElHR0Rs?=
 =?utf-8?B?U01HcnJGVXl5aWR2bHk2VlQrc05ENnc2M3B1a1dpZFZlNy9wWVdFQ0hCdzNI?=
 =?utf-8?B?K21EK2Q0aUYzRmg1eFhCMVplSkNnMTdxWnd2V2hIWnYwZ0NIVFlwTEhpbWI2?=
 =?utf-8?B?eGI0TktvcWQwRitJblpULzUrUDlzT3VuS1RxZEpCVXZDcHZGTUlaNzZNaEJR?=
 =?utf-8?B?TUh2VDNoeElTRzNYYi9ycnVJWjFwVldYd2p2RFVUQWdWdE5xdlBwemhLYnRE?=
 =?utf-8?B?dFN3eVZ6bjNkQUV5ZzhVNnZjektyRVJCUXdMVnhZWjZVTTRtYnVIZ2dPQzJU?=
 =?utf-8?B?Mm0vTjc5bmprQXY2Z2JJdXJpdmlFYUxaczB2bG1vS2toQzRqZUgvMVZkT3E4?=
 =?utf-8?B?T1RCVVRmQ01TRzlKSlNXaTcrUU0wckZOS2pVQzJUSUNpS0xzdnR2WlgrL0JD?=
 =?utf-8?B?Uk03TCswemtYT0tMVTVjM1hmU0FTWFcwMm8vMURsMzROOTRRVTlXbEcwOENa?=
 =?utf-8?B?cHozTG1tb3c5UjRpWnhKN2wybXlHNVUzdjJBdURMMDRmWUR1b05ucWxOV1NY?=
 =?utf-8?B?b0RzZmQ3czB1QzQ0UFpDc0FMbkZGUURISTFCVyt0RHNRNklZRlU3ZnpzT1pu?=
 =?utf-8?B?dktxZlZSNXZVNUJtOHJjWTlPYlZvYWRKMFV3YlpsaXgzaFBmOHBhaTZ1ektU?=
 =?utf-8?B?QW5nR0ZIbC9yZFcvREZMNFJ1OEkzb2tYVTBtaHlXa3FxektycjkzaEwvZGl2?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e92bc77-afc2-4ce2-36a1-08de1643f5b5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2025 17:03:47.8219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ObM8uwTGb8n8Qcj9c/hpxyKMgvDrHW0CJUJ5zjt7USBR67ekpjEnekvU4C/J8RCKAwC9FhtsvZGmlRIZ+ywVlvRAMlHu6MTPAJTamIDV3t4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com

On Thu, Oct 23, 2025 at 11:50:28PM +0200, Michal Wajdeczko wrote:
> 
> 
> On 10/22/2025 12:41 AM, Michał Winiarski wrote:
> > In an upcoming change, the VF GGTT migration data will be handled as
> > part of VF control state machine. Add the necessary helpers to allow the
> > migration data transfer to/from the HW GGTT resource.
> > 
> > Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> > ---
> >  drivers/gpu/drm/xe/xe_ggtt.c               | 100 +++++++++++++++++++++
> >  drivers/gpu/drm/xe/xe_ggtt.h               |   3 +
> >  drivers/gpu/drm/xe/xe_ggtt_types.h         |   2 +
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c |  44 +++++++++
> >  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h |   5 ++
> >  5 files changed, 154 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
> > index 40680f0c49a17..99fe891c7939e 100644
> > --- a/drivers/gpu/drm/xe/xe_ggtt.c
> > +++ b/drivers/gpu/drm/xe/xe_ggtt.c
> > @@ -151,6 +151,14 @@ static void xe_ggtt_set_pte_and_flush(struct xe_ggtt *ggtt, u64 addr, u64 pte)
> >  	ggtt_update_access_counter(ggtt);
> >  }
> >  
> > +static u64 xe_ggtt_get_pte(struct xe_ggtt *ggtt, u64 addr)
> > +{
> > +	xe_tile_assert(ggtt->tile, !(addr & XE_PTE_MASK));
> > +	xe_tile_assert(ggtt->tile, addr < ggtt->size);
> > +
> > +	return readq(&ggtt->gsm[addr >> XE_PTE_SHIFT]);
> > +}
> > +
> >  static void xe_ggtt_clear(struct xe_ggtt *ggtt, u64 start, u64 size)
> >  {
> >  	u16 pat_index = tile_to_xe(ggtt->tile)->pat.idx[XE_CACHE_WB];
> > @@ -233,16 +241,19 @@ void xe_ggtt_might_lock(struct xe_ggtt *ggtt)
> >  static const struct xe_ggtt_pt_ops xelp_pt_ops = {
> >  	.pte_encode_flags = xelp_ggtt_pte_flags,
> >  	.ggtt_set_pte = xe_ggtt_set_pte,
> > +	.ggtt_get_pte = xe_ggtt_get_pte,
> >  };
> >  
> >  static const struct xe_ggtt_pt_ops xelpg_pt_ops = {
> >  	.pte_encode_flags = xelpg_ggtt_pte_flags,
> >  	.ggtt_set_pte = xe_ggtt_set_pte,
> > +	.ggtt_get_pte = xe_ggtt_get_pte,
> >  };
> >  
> >  static const struct xe_ggtt_pt_ops xelpg_pt_wa_ops = {
> >  	.pte_encode_flags = xelpg_ggtt_pte_flags,
> >  	.ggtt_set_pte = xe_ggtt_set_pte_and_flush,
> > +	.ggtt_get_pte = xe_ggtt_get_pte,
> >  };
> >  
> >  static void __xe_ggtt_init_early(struct xe_ggtt *ggtt, u32 reserved)
> > @@ -912,6 +923,22 @@ static void xe_ggtt_assign_locked(struct xe_ggtt *ggtt, const struct drm_mm_node
> >  	xe_ggtt_invalidate(ggtt);
> >  }
> >  
> > +/**
> > + * xe_ggtt_pte_size() - Convert GGTT VMA size to page table entries size.
> > + * @ggtt: the &xe_ggtt
> > + * @size: GGTT VMA size in bytes
> > + *
> > + * Return: GGTT page table entries size in bytes.
> > + */
> > +size_t xe_ggtt_pte_size(struct xe_ggtt *ggtt, size_t size)
> 
> passing ggtt just for assert seems overkill
> 
> > +{
> > +	struct xe_device __maybe_unused *xe = tile_to_xe(ggtt->tile);
> 
> we try to avoid __maybe_unused 
> 
> if you need xe/tile/gt just in the assert, then put to_xe/tile/gt inside it

It will go away after restructuring it to pass the node instead.

> 
> > +
> > +	xe_assert(xe, size % XE_PAGE_SIZE == 0);
> > +
> > +	return size / XE_PAGE_SIZE * sizeof(u64);
> > +}
> > +
> >  /**
> >   * xe_ggtt_assign - assign a GGTT region to the VF
> >   * @node: the &xe_ggtt_node to update
> > @@ -927,6 +954,79 @@ void xe_ggtt_assign(const struct xe_ggtt_node *node, u16 vfid)
> >  	xe_ggtt_assign_locked(node->ggtt, &node->base, vfid);
> >  	mutex_unlock(&node->ggtt->lock);
> >  }
> > +
> > +/**
> > + * xe_ggtt_node_save() - Save a &xe_ggtt_node to a buffer.
> > + * @node: the &xe_ggtt_node to be saved
> > + * @dst: destination buffer
> > + * @size: destination buffer size in bytes
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_ggtt_node_save(struct xe_ggtt_node *node, void *dst, size_t size)
> > +{
> > +	struct xe_ggtt *ggtt;
> > +	u64 start, end;
> > +	u64 *buf = dst;
> > +
> > +	if (!node)
> > +		return -ENOENT;
> > +
> > +	guard(mutex)(&node->ggtt->lock);
> > +
> > +	ggtt = node->ggtt;
> > +	start = node->base.start;
> > +	end = start + node->base.size - 1;
> > +
> > +	if (xe_ggtt_pte_size(ggtt, node->base.size) > size)
> > +		return -EINVAL;
> > +
> > +	while (start < end) {
> > +		*buf++ = ggtt->pt_ops->ggtt_get_pte(ggtt, start) & ~GGTT_PTE_VFID;
> 
> up to this point function is generic, non-IOV, so maybe leave PTEs as-is and do not sanitize VFID ?
> 
> or, similar to node_load(), also pass vfid to enforce additional checks ?
> 
> 	pte = ggtt->pt_ops->ggtt_get_pte(ggtt, start);
> 	if (vfid != u64_get_bits(pte, GGTT_PTE_VFID))
> 		return -EPERM;
> 
> then optionally sanitize using:
> 
> 	*buf++ = u64_replace_bits(pte, 0, GGTT_PTE_VFID);
> 

I'll go with check & sanitize.

> 
> 
> > +		start += XE_PAGE_SIZE;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * xe_ggtt_node_load() - Load a &xe_ggtt_node from a buffer.
> > + * @node: the &xe_ggtt_node to be loaded
> > + * @src: source buffer
> > + * @size: source buffer size in bytes
> > + * @vfid: VF identifier
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_ggtt_node_load(struct xe_ggtt_node *node, const void *src, size_t size, u16 vfid)
> > +{
> > +	u64 vfid_pte = xe_encode_vfid_pte(vfid);
> > +	const u64 *buf = src;
> > +	struct xe_ggtt *ggtt;
> > +	u64 start, end;
> > +
> > +	if (!node)
> > +		return -ENOENT;
> > +
> > +	guard(mutex)(&node->ggtt->lock);
> > +
> > +	ggtt = node->ggtt;
> > +	start = node->base.start;
> > +	end = start + size - 1;
> > +
> > +	if (xe_ggtt_pte_size(ggtt, node->base.size) != size)
> > +		return -EINVAL;
> > +
> > +	while (start < end) {
> > +		ggtt->pt_ops->ggtt_set_pte(ggtt, start, (*buf & ~GGTT_PTE_VFID) | vfid_pte);
> 
> 		pte = u64_replace_bits(*buf++, vfid, GGTT_PTE_VFID));
> 		ggtt_set_pte(ggtt, start, pte);
> 

Ok.

> > +		start += XE_PAGE_SIZE;
> > +		buf++;
> > +	}
> > +	xe_ggtt_invalidate(ggtt);
> > +
> > +	return 0;
> > +}
> > +
> >  #endif
> >  
> >  /**
> > diff --git a/drivers/gpu/drm/xe/xe_ggtt.h b/drivers/gpu/drm/xe/xe_ggtt.h
> > index 75fc7a1efea76..5f55f80fe3adc 100644
> > --- a/drivers/gpu/drm/xe/xe_ggtt.h
> > +++ b/drivers/gpu/drm/xe/xe_ggtt.h
> > @@ -42,7 +42,10 @@ int xe_ggtt_dump(struct xe_ggtt *ggtt, struct drm_printer *p);
> >  u64 xe_ggtt_print_holes(struct xe_ggtt *ggtt, u64 alignment, struct drm_printer *p);
> >  
> >  #ifdef CONFIG_PCI_IOV
> > +size_t xe_ggtt_pte_size(struct xe_ggtt *ggtt, size_t size);
> 
> this could be generic (non PCI-IOV only) inline helper or macro here or in .c
> 
> 	size_t to_xe_ggtt_pt_size(size_t size);
> 
> and then more elegant solution would be to expose
> 
> 	size_t xe_ggtt_node_pt_size(const struct xe_ggtt_node *node);
> 
> and yes, that would require to additionally expose something from gt_sriov_pf_config
> as migration code doesn't have access to this node,
> 
> but maybe xe_gt_sriov_pf_config_ggtt_save() can be updated to also support 'query' mode?
> 
> 	size_t xe_gt_sriov_pf_config_ggtt_save(gt, vfid, buf, size) -> bytes saved
> 	size_t xe_gt_sriov_pf_config_ggtt_save(gt, vfid, NULL, 0) -> size to be saved

Ok.
I'll go with passing NULL and 0 to query.

Thanks,
-Michał

> 
> 
> >  void xe_ggtt_assign(const struct xe_ggtt_node *node, u16 vfid);
> > +int xe_ggtt_node_save(struct xe_ggtt_node *node, void *dst, size_t size);
> > +int xe_ggtt_node_load(struct xe_ggtt_node *node, const void *src, size_t size, u16 vfid);
> >  #endif
> >  
> >  #ifndef CONFIG_LOCKDEP
> > diff --git a/drivers/gpu/drm/xe/xe_ggtt_types.h b/drivers/gpu/drm/xe/xe_ggtt_types.h
> > index c5e999d58ff2a..dacd796f81844 100644
> > --- a/drivers/gpu/drm/xe/xe_ggtt_types.h
> > +++ b/drivers/gpu/drm/xe/xe_ggtt_types.h
> > @@ -78,6 +78,8 @@ struct xe_ggtt_pt_ops {
> >  	u64 (*pte_encode_flags)(struct xe_bo *bo, u16 pat_index);
> >  	/** @ggtt_set_pte: Directly write into GGTT's PTE */
> >  	void (*ggtt_set_pte)(struct xe_ggtt *ggtt, u64 addr, u64 pte);
> > +	/** @ggtt_get_pte: Directly read from GGTT's PTE */
> > +	u64 (*ggtt_get_pte)(struct xe_ggtt *ggtt, u64 addr);
> >  };
> >  
> >  #endif
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> > index c0c0215c07036..c857879e28fe5 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> > @@ -726,6 +726,50 @@ int xe_gt_sriov_pf_config_set_fair_ggtt(struct xe_gt *gt, unsigned int vfid,
> >  	return xe_gt_sriov_pf_config_bulk_set_ggtt(gt, vfid, num_vfs, fair);
> >  }
> >  
> > +/**
> > + * xe_gt_sriov_pf_config_ggtt_save() - Save a VF provisioned GGTT data into a buffer.
> > + * @gt: the &xe_gt
> > + * @vfid: VF identifier (can't be 0)
> > + * @buf: the GGTT data destination buffer
> > + * @size: the size of the buffer
> > + *
> > + * This function can only be called on PF.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_gt_sriov_pf_config_ggtt_save(struct xe_gt *gt, unsigned int vfid,
> > +				    void *buf, size_t size)
> > +{
> > +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> > +	xe_gt_assert(gt, vfid);
> > +
> > +	guard(mutex)(xe_gt_sriov_pf_master_mutex(gt));
> > +
> > +	return xe_ggtt_node_save(pf_pick_vf_config(gt, vfid)->ggtt_region, buf, size);
> > +}
> > +
> > +/**
> > + * xe_gt_sriov_pf_config_ggtt_restore() - Restore a VF provisioned GGTT data from a buffer.
> > + * @gt: the &xe_gt
> > + * @vfid: VF identifier (can't be 0)
> > + * @buf: the GGTT data source buffer
> > + * @size: the size of the buffer
> > + *
> > + * This function can only be called on PF.
> > + *
> > + * Return: 0 on success or a negative error code on failure.
> > + */
> > +int xe_gt_sriov_pf_config_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> > +				       const void *buf, size_t size)
> > +{
> > +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> > +	xe_gt_assert(gt, vfid);
> > +
> > +	guard(mutex)(xe_gt_sriov_pf_master_mutex(gt));
> > +
> > +	return xe_ggtt_node_load(pf_pick_vf_config(gt, vfid)->ggtt_region, buf, size, vfid);
> > +}
> > +
> >  static u32 pf_get_min_spare_ctxs(struct xe_gt *gt)
> >  {
> >  	/* XXX: preliminary */
> > diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> > index 513e6512a575b..6916b8f58ebf2 100644
> > --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> > +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> > @@ -61,6 +61,11 @@ ssize_t xe_gt_sriov_pf_config_save(struct xe_gt *gt, unsigned int vfid, void *bu
> >  int xe_gt_sriov_pf_config_restore(struct xe_gt *gt, unsigned int vfid,
> >  				  const void *buf, size_t size);
> >  
> > +int xe_gt_sriov_pf_config_ggtt_save(struct xe_gt *gt, unsigned int vfid,
> > +				    void *buf, size_t size);
> > +int xe_gt_sriov_pf_config_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> > +				       const void *buf, size_t size);
> > +
> >  bool xe_gt_sriov_pf_config_is_empty(struct xe_gt *gt, unsigned int vfid);
> >  
> >  int xe_gt_sriov_pf_config_init(struct xe_gt *gt);
> 

