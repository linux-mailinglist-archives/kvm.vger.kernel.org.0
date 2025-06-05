Return-Path: <kvm+bounces-48460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F02DACE7B8
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 03:16:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 194783A80EB
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 01:16:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04E982E40E;
	Thu,  5 Jun 2025 01:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z1TU+JJ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E46D320F
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 01:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749086185; cv=fail; b=thhWAonr2vVmveSWduUQAKguj0j0Yy4iQRRDMMH7GkGtSTZKtTqgd/HEjZMlON+Lmz3awQO5qzFyr+ps5CFE7SAEXyrZwSoh2Nmkn+fL1axQj3gaNMcbcl2LaNqWwhOqsOm2SI1tHp4mcBrsnTrk8YRy1LZLE8O2K0NuI35Fb7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749086185; c=relaxed/simple;
	bh=cpvt6jRLzxlI5MkDmmcKnjcRQBl1/GIvWTwBjQh/bO0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iZXa6j3jNvXqUoM7eMz7b5AjTbqbHaS7eJ25oSWMtbUM/5mSZPUw88PRIhgtMWBZW2kSzN6M4XJB9HIESDmEPqcwyEVzxTtrz4rYRMSiV/3Lx3PnVc65iEpKn1bV2oe7+wAN/Bx7EeWolp0Zv1j6TAB/VbBAV3WlJij5KRw4iT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z1TU+JJ9; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749086183; x=1780622183;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cpvt6jRLzxlI5MkDmmcKnjcRQBl1/GIvWTwBjQh/bO0=;
  b=Z1TU+JJ93KX/WphXgBlPsr+Un75GXmIhG1Tknh4Xaka1060FCOobnBoC
   QxwbIWotoKrY8lpjGxMQmNR6wxhpbafZPJqickhW0b1KYWrmWS5vOjQGC
   tWsQXX/cu8Tg2+exKJrUwm5vYvBwcm34WSRYkKmGKQP2Av7et/xsJCMVZ
   67ubx4DdohDdwQQQzTRwpMgVonol6Vi9FVtVpp0D3/AQjqHAN/O9i1d/F
   BqG7nU+jmwygbyGJaAnfAKCvzpsuP2Va9npzJzAxRUW2uVz3DAj7k0bbo
   HhAYCz0MBHFE+x9rdXXqJL3HeOkHatVAMzKSzPKjladrldUcly6S7gS7r
   w==;
X-CSE-ConnectionGUID: nkJDq6T9QD2exE+oe/Zg0w==
X-CSE-MsgGUID: fWPTp8rBQ1WB9wT6xgcduA==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="50885850"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="50885850"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 18:16:23 -0700
X-CSE-ConnectionGUID: 8pZDeYLPSSC5q7uUh6JeIA==
X-CSE-MsgGUID: AHav9nbOQjWmyXPmOWiaLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="150506946"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 18:16:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 18:16:22 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 18:16:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.62)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 18:16:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eZLHAp0O88a46S6NVuZ2PKX630yCZCdt2/1HLDeyyRadwVU+H7BVlxEOgOvWWUBQDxUd2tEK56hYP0ohwWxYFjkbSYHMqrJq3FmBsRT48msQf+Fx87KG1S2UVNV88yJ/LYc6Q53MjTCsYB53ykNJWvGlRTipgetrGCemFqVBv94+XPGeeXUbxudZkcbZiDyN4+rIRyJE5DhonZcJB7+E45VCEHQshru82RdvfFFqzU9unMAihOzfzgN7yx5SQdiJgza+B8iaw75cKt9ZCdRdqrZw/haEzD1uoCatPu/8RcFkUVxUejVrbYzuFOjx5dpXqXw1tUjrXViyjxOpoaSkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eubjU+vF2kCT/O/DYZm6HADP05SECTa+iIr+zx++jAo=;
 b=IRNedgdC7gnsl/39U3sjNM1WiFvSMwYpJtE8/cwrpy+e+xQCGgbhWug+7uD0QUjUIQb5uqMe+W2RUfA5vmWwQXLfkoOpsmJxuRuQkzLZzCqKeyKl8jPppARnWUtuAmFrYZEcmbG1iUtw6vdeO8eamBvsb2f95/vbTxvdCao1MFYAOIZ3SxH6T3lJImaSnW8L71EOF3tnHEnjy3T4dIv2D1c9h6v7PJaSXxfgaCZQyg9kmD+/jkFGG4K2Hvq7cq2kmoAClNHGJQMSFYGgk7t0BfECbNVGXG3wb/0WhuRpmOmVfneuyHQpHMt6T2WZkfc0NYmDyuD0ZMbRzcyBQz1YKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 MW4PR11MB5822.namprd11.prod.outlook.com (2603:10b6:303:185::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.37; Thu, 5 Jun 2025 01:16:20 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8813.018; Thu, 5 Jun 2025
 01:16:19 +0000
Message-ID: <67695fe5-9deb-4650-a535-92d17c69e2a9@intel.com>
Date: Thu, 5 Jun 2025 09:16:12 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH] nVMX: Fix testing failure for canonical
 checks when forced emulation is not available
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	<kvm@vger.kernel.org>
References: <20250523090848.16133-1-chenyi.qiang@intel.com>
 <aD-DNn6ZnAAK4TmH@google.com>
 <917b478e-14f3-437f-a748-0fdf423e9db7@intel.com>
 <aEChg7jMQKG3Zm6-@google.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <aEChg7jMQKG3Zm6-@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:820:d::19) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|MW4PR11MB5822:EE_
X-MS-Office365-Filtering-Correlation-Id: aec67f27-7b41-403b-40ea-08dda3ce9363
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?b0ZhWXdYVzZrRkcreklXQm9uV1VyaW9yTmNBSW9KVnBRZ3NXdFFRZ2k4RzBI?=
 =?utf-8?B?aEUrU3hnUElXWmY1aVpTUHZCY0Rpa1ZLN3kxR0oxTk5LOEtBQytKQno1SmhB?=
 =?utf-8?B?bDFhNitUQzAyYkxqUXpJU2hObXNnemVvUUtSQmR6aGRnd3dPRmVXKzdmeU50?=
 =?utf-8?B?d1k2RG9WTzBDQVNwK2tWYkdFRm9qWWVTaDdjNlhpMmN4NEhtYXdjdDlHRWpD?=
 =?utf-8?B?a3JoWkZFeXhrVXNTQlg3Mnc1WkNUQjhNM3FmQzh0Y1J4V3JFZEw5OG9oZ1Q0?=
 =?utf-8?B?MkNPS2pZcUZKcVZzeGFzUDZUZ2RjVzRDUTBwSnllRHZ0dDk0YjRyQ1gxSEE4?=
 =?utf-8?B?ekcrVTUzVUo2WHozeEh3UmF6WlVXQlRiUHdMYllObmJLUzRYRzRxK3RRekd0?=
 =?utf-8?B?N2pnSHh3NllibXZYd3owRGdrTjFxNFd4YjhJWDVNL3BiQmUvREJQU2ZyNGps?=
 =?utf-8?B?Vk5NbG1uMmNEeXg0aG9VVm5DV1o2bjB2UHIvVllpVExqYkFETW1UQkVsODc1?=
 =?utf-8?B?YkxZZTJtN1ZSTU84V2RiZnY0QVlHcUYzKzNYaFpUa3JYL3ZSbFI2QWZEbWZQ?=
 =?utf-8?B?cDJNNTl5QVNvdXV5U0diN3RGdldsZHI0QjIzclFhbXk1cjU4SU9wTzFzRlY5?=
 =?utf-8?B?SU5VSTdNYWh2Y2hJV0E3dEpYWWp6UzlGMGIrUUt2VzBsQTNObEVMaW1uNzZk?=
 =?utf-8?B?ZUF2am42Vm90RUxsM0VDWlV4cVU5QkdaSGhRaGlYK1RXck5Qcng5NjdLZ25v?=
 =?utf-8?B?VVM5S0RuZHNKNC9COXRIcXNBcTE1S1dINUwzcGpaQk5qdlhSdWFMWFp3aktY?=
 =?utf-8?B?cUFMQWxPZTNSTGs1UHh5TlVnTEZESmxLc1hDOE10d1l5cys4NW1ZaUMvamJZ?=
 =?utf-8?B?NDJ2R3R2Rlc1Sm0zUTJqVGc3eGx0Ylpmakx5NjN1MG05Vy9wb3dNdm1DWTFa?=
 =?utf-8?B?WUxYdFNRZmdqR2ovNW5ETXBBc3I2TmZHUnNuSk9WcGRvdU5UVytwQ3o4WjJ2?=
 =?utf-8?B?a0pXUnZKV0w1ZVFXbUhOMlkzNkNsYjB0YldLQVFLUDI4OGJMTUdTaWJ4ZG9T?=
 =?utf-8?B?Y2trVzEwei9LdUJVY0p2aTdaUjUxMjFtYk8zTTNaUlo5N3BORlBxUTR3WGg4?=
 =?utf-8?B?WmFhUUF0TytuVkZta3pEY1dvYVRkeTFZWTdQeFJkTFN3UGRKK0RybkJVNURO?=
 =?utf-8?B?dGdhSUVsNlk4K25NcnF2c0ZEcDdoOHlRTjFWSm11alRRV3cyTkp0WkVPd2U1?=
 =?utf-8?B?bjNjSjRNdzFORHhDUWRKTWpSWkxLK2tFL0JmU0NXc0lGSGQ0N3NCOFF1dGV5?=
 =?utf-8?B?RlZEbTZLK0xVNm0wSUtOWnlmeUpyQjNia00xSnBYSDEyckJmdHRGaFhLRVEz?=
 =?utf-8?B?dENRZEUydkQ5Nmhab1VMajF3TmFlaTZjOFNnMWdMdG8zMDYzeVRDMkNOQUxu?=
 =?utf-8?B?ZDJOZER1MEwxQXhlTDFvSjVhSVdZVDhoWXpJU2JDZHNiUlI5V2hwaTFacmN5?=
 =?utf-8?B?Z0xJQXhkVWpZMVJTazFaMnFsMS9FR29jbkF2N2tOVm1FZHgyM0hNVE1qN0Qy?=
 =?utf-8?B?OWhidnRIa01aZzVpTEMzdVJCZGFobm5PTTdOcFVTbks2ZE1GT1A1RDB6dVVt?=
 =?utf-8?B?Z0d1NDZiRlIzRzc1Q1ZtY1lKbEt0RlgzZ2tFcktKMVpDMExDTytKc1ljSzJ3?=
 =?utf-8?B?OXl1UkNGcERXUFF1dWkyOWxLTU5JTmlRZnZlMzNlK2R2d2c4TzlUcFpEek81?=
 =?utf-8?B?LzloeGp6R25FZjJzVHBiVlBGVWtvMVU0b2ZUZjhaQ0Zwaytic2JXdW5RTFMy?=
 =?utf-8?B?dElDTklJQXZHYkF3NnI0RjF6WllPR2lwV2habDZiYVFhVThXbS94OGwvKzVT?=
 =?utf-8?B?OXRYOVpYekdoQmFSRGRsaHV3NkQwczNTeTV3ekRYVGxGLzF1VzYxelJweHFF?=
 =?utf-8?Q?AGWdwZ6a4NM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFBqbHNQSGQydkw0S1plb01TZ0NCMWZvYmVlTmtGcndkeEp6cW9vMTFwaVRl?=
 =?utf-8?B?ZTRuaENqSllubVk5a2YzNElKOGRSOEpOSjA2OFhndVR3VlcvU3pzaXpSZERV?=
 =?utf-8?B?c014eGlMVzI0SXdpYWNZNVFOS1ovdERjYWt1ODNjTHZhS2RIazE1VDh5akRK?=
 =?utf-8?B?bm56TVRuWmxoMjAzWGh1VXpQWlFsdXBYMUhjNlhhaWdOelM0dWcvS2RTWjdU?=
 =?utf-8?B?NWZxbm1OMmw1Um5qbHZmRDY3b29uT0dSNnVManZpSjU4WnIwakFTbzNoTktG?=
 =?utf-8?B?Q0Y3amJmNjRNU0V1bDhrcXcvLy9pVkZUOXpsbDFZYVRYVEJnbDduZ2cwcHFh?=
 =?utf-8?B?aUU1b25LSXBLUm12MUVISGpzdGN0VXVEVERHdWpzdngxRk1JNUg0di9ieElp?=
 =?utf-8?B?UlY2MmpYL2xUQW9HVDdZbXVZMVdHRzNkN2tJdDRrQy8vaGR5bTFhdFU5UFE2?=
 =?utf-8?B?SGh6R0U0aUdDdUZpVlhxZHYxUUhKZmVmR1N6Mi94aFVsZXZXdTNTZm5zK3Vq?=
 =?utf-8?B?ZTkzdXpJcW5EeEVUenFraVRZMkZBUjQwRDB4dDdTcFBnOC9FTnplSkxuUXAr?=
 =?utf-8?B?ZXk0VytBWFBjeXhMaVhPZXZPY3E4OW5hY2ZCMnlXaTVzNlVnZjljUWJ6VnNz?=
 =?utf-8?B?dDg2dlJLc1VIUHZHMXNJSFlaZnpZZzBkY0FWRit1TnExdElxUmtOZWpyWGti?=
 =?utf-8?B?YUdwYTZjRWYyb0tMR1B0enpKMDE5bkFBNFhINGI2QWJsUjA2YVJjZXFGOHJm?=
 =?utf-8?B?ZG91Q0ZhKzJjSTRoUW9scUg2dkRWU1JXclZOVUpZREpCa3hOc251OERhMlMr?=
 =?utf-8?B?NC80Y1M4WmRrZjlQVHNSTStOQzhuakhLTHlLSUQxc0ttNnlvYS9ZeHZjellS?=
 =?utf-8?B?WG10c0wyOXhLamozQy9QaVlOMFlZMHF5b3NHWTRZclhrK3E5QklZalF0Rzlt?=
 =?utf-8?B?bGlUaFhMbG9MbFJrQ2pZbHNKVVBVbFhFNEtvQVlTQUgvaWpxendhWm5OMGZo?=
 =?utf-8?B?VElEazlGd2N1Y3FqL2cwS2ZxZ0RHUFVpYzRGOFE1b2dwUGFyb2dFcUtKWk9U?=
 =?utf-8?B?TlVSUGN2WGlETWVuaVo1T1ZiMTFWMzNxUW5NdW1iUEdPTE15RXNLSENoZ3Zi?=
 =?utf-8?B?SjhKY3BoOXZNUXlCdVp3c2JxenhQUnlUbGhZbmVSSDZFMFZkUVpHT2E3dzd1?=
 =?utf-8?B?clFyQWplL0xxMzlkSllPU0ExR3VENnlTa1QxQ0NhMmNSdUZLZUhmSkZESE5G?=
 =?utf-8?B?VlF3MjNqdTdqRzNIOHdJeWRVYktyMmhPMDJPTEdneEgzeUEvNDR5TlhhOUs3?=
 =?utf-8?B?KzQyTG1JQ0pXdW1kcGlSTmRlT0libGVLS0N5MzVOdzk1K1NJWHpIWnlnMlRV?=
 =?utf-8?B?akc1ZmJkRFJyZkpaa3dnait3MWR0dHZka2ppYWp0M0FxdzBsaFhEQjlMcWNF?=
 =?utf-8?B?Z0FMZWFlU2NqWEpORFhkVGZENTBVVDY2bEJscmRYS0xYbGh1VThzZklXL1U4?=
 =?utf-8?B?VFFCbUpwNXAvZ2wyczhuWW8yNFdhUDN6OXNsV0J5UTU1UzJCbWtXeGhtTWVy?=
 =?utf-8?B?Rm5hTjB3Rkp3eGtzd2h5bDlhVGFQZUQ2cHJxOEhSNHRTU3luQlIvWC93Q2VN?=
 =?utf-8?B?ZlNtRFN2TkFja1F5dlRhS3c5NDFCbTRQWW5nQ2I0WnRKcFhReUpCT2QzWDUw?=
 =?utf-8?B?RkpzTmtPM0hqS3FuNWxsREFhTzRTNkFnSlFPeW1iWjA2cXhxS0xTa0VNaFYv?=
 =?utf-8?B?VDlLM0c3YjgwWmc0RmdrZDZFY3ZRRVNBNGUxaHYrNVgzdExESzYrTXFoNGRa?=
 =?utf-8?B?a2l6Y3oveUNyUTBxbkFaOGlCMUU0TFdMTXlpZFc5OFlQSGhKVHozU2NtV210?=
 =?utf-8?B?WWMvRjBXajFmNm80clMvWldHUkROUXQ5MDR0d0RFSzB0NWJkMjB3NnA1aFFz?=
 =?utf-8?B?bFdvSTNjbXh0RW9uVmJwa3hIM2RsMHcxaFptcjQyZFVwck91MDlHMFN3MUxS?=
 =?utf-8?B?SVZlVmN3NzFmaS9qb2lkOUNmbk9OQmRqTnM2cncrRVNGYlIvRmVqVE5jRE5L?=
 =?utf-8?B?RFVkMTgvbVVJYXpEcjZpd0ZpRlZpdjEvUE1wSGJsRkVET0xqM1VBZE10ejFY?=
 =?utf-8?B?OW52UTIvQkJGN1RLcUc2ejhaWEVHN3NSeC8wRDdMWmw0QzZqR254NzNkSGdJ?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aec67f27-7b41-403b-40ea-08dda3ce9363
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 01:16:19.1639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: twJgvIgRmk/4N5nX20JJPn7KFGE6LKFAMpd+9cFNCF7vHm76JtY8u4sY5Fk2+aq8DANMidDVi8cjcpyr4+b0/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5822
X-OriginatorOrg: intel.com



On 6/5/2025 3:41 AM, Sean Christopherson wrote:
> On Wed, Jun 04, 2025, Chenyi Qiang wrote:
>>
>>
>> On 6/4/2025 7:20 AM, Sean Christopherson wrote:
>>> On Fri, May 23, 2025, Chenyi Qiang wrote:
>>>> Use the _safe() variant instead of _fep_safe() to avoid failure if the
>>>> forced emulated is not available.
>>>>
>>>> Fixes: 05fbb364b5b2 ("nVMX: add a test for canonical checks of various host state vmcs12 fields")
>>>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>>>> ---
>>>>  x86/vmx_tests.c | 5 ++---
>>>>  1 file changed, 2 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>>> index 2f178227..01a15b7c 100644
>>>> --- a/x86/vmx_tests.c
>>>> +++ b/x86/vmx_tests.c
>>>> @@ -10881,12 +10881,11 @@ static int set_host_value(u64 vmcs_field, u64 value)
>>>>  	case HOST_BASE_GDTR:
>>>>  		sgdt(&dt_ptr);
>>>>  		dt_ptr.base = value;
>>>> -		lgdt(&dt_ptr);
>>>> -		return lgdt_fep_safe(&dt_ptr);
>>>> +		return lgdt_safe(&dt_ptr);
>>>>  	case HOST_BASE_IDTR:
>>>>  		sidt(&dt_ptr);
>>>>  		dt_ptr.base = value;
>>>> -		return lidt_fep_safe(&dt_ptr);
>>>> +		return lidt_safe(&dt_ptr);
>>>
>>> Hmm, the main purpose of this particular test is to verify KVM's emulation of the
>>> canonical checks, so it probably makes sense to force emulation when possible.
>>>
>>> It's not the most performant approach, but how about this?
>>>
>>> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
>>> index 2f178227..fe53e989 100644
>>> --- a/x86/vmx_tests.c
>>> +++ b/x86/vmx_tests.c
>>> @@ -10881,12 +10881,13 @@ static int set_host_value(u64 vmcs_field, u64 value)
>>>         case HOST_BASE_GDTR:
>>>                 sgdt(&dt_ptr);
>>>                 dt_ptr.base = value;
>>> -               lgdt(&dt_ptr);
>>> -               return lgdt_fep_safe(&dt_ptr);
>>> +               return is_fep_available() ? lgdt_fep_safe(&dt_ptr) :
>>> +                                           lgdt_safe(&dt_ptr);
>>>         case HOST_BASE_IDTR:
>>>                 sidt(&dt_ptr);
>>>                 dt_ptr.base = value;
>>> -               return lidt_fep_safe(&dt_ptr);
>>> +               return is_fep_available() ? lidt_fep_safe(&dt_ptr) :
>>> +                                           lidt_safe(&dt_ptr);
>>>         case HOST_BASE_TR:
>>>                 /* Set the base and clear the busy bit */
>>>                 set_gdt_entry(FIRST_SPARE_SEL, value, 0x200, 0x89, 0);
>>
>> The call of is_fep_available() itself will trigger the #UD exception:
> 
> Huh.  The #UD is expected, but KUT should handle the #UD
> 
> Gah, I thought it was working on my end, but it's not.  I just got a triple fault
> instead of a nice error report, and didn't notice the return code (was running
> manually).
> 
> Oh, duh.  Invoking is_fep_available() when restoring the original host value for
> the IDT will triple fault due to IDT.base being 0xff55555555000000.
> 
> Hmm, that doesn't explain how you managed to get a stack trace though.  Can you
> test the series I cc'd you on?  If it still fails, then something entirely
> different is going on.

That series works for me. Now the test can pass on my side.

> 
>> Unhandled cpu exception 6 #UD at ip 000000000040efb5
>> error_code=0000      rflags=00010097      cs=00000008
>> rax=0000000000000000 rcx=00000000c0000101 rdx=000000000042d220
>> rbx=0000000000006c0c
>> rbp=000000000073bed0 rsi=ff45454545000000 rdi=0000000000000006
>>  r8=000000000043836e  r9=00000000000003f8 r10=000000000000000d
>> r11=00000000000071ba
>> r12=0000000000436daa r13=0000000000006c0c r14=000000000042d220
>> r15=0000000000420078
>> cr0=0000000080010031 cr2=ffffffffffffb000 cr3=0000000001007000
>> cr4=0000000000042020
>> cr8=0000000000000000
>>         STACK: @40efb5 40f0e9 40ff56 402039 403f11 4001bd
>>
>> Maybe the result of is_fep_available() needs to be passed in from main()
>> function in some way instead of checking it in guest code.
> 
> Ya, it's past time we give KUT the same treatment as KVM selftests and cache the
> information during test setup.  setup_idt() is the obvious choice.  I already
> posted a series (I meant to send this first, but got distracted).
> 
> Nit, this isn't guest code per se, because these writes are all in the "host",
> i.e. in L1 (which is obviously _a_ guest, but not _the_ guest from these test's
> perspective).

Got it! Thanks for the explanation.



