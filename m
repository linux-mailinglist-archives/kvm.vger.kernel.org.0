Return-Path: <kvm+bounces-60104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0882EBE08EE
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 21:56:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CCD94859D9
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 19:56:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B1E3064BF;
	Wed, 15 Oct 2025 19:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cviSfWnK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74D430103F;
	Wed, 15 Oct 2025 19:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760558188; cv=fail; b=I1AlL/lJm6H1S+1QylwuxU+I65BX3cYrW2d5hBeS/ijGdxugxjRPBikI8FBPMJgKjUU16qsxm7ALiE6AeqRpigu4t5ho++zy/6tgyy6k9CgtfSf15s4LA299UlyhAVqvMgUG9d3j5Fdehp831froOwbm6EXqJbIczAljNe6a08w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760558188; c=relaxed/simple;
	bh=q482SSOiJ/zOnqKGC3FlGY07uvhbQsm8dkiAe4+TWVs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tcxp7zBiRiQIJdnWU3Li4t4LsRhaus16vVpPhKgwfmK7ngi1aR7608yvsLPDfbIArsJhIzwfK6tk6VLSVYDvz6SlcBmB6BCC5FEDg/VADL8leySXzvGoDjTA6GHjAiaZydZ6+PWiQh8hsKhBzoVujAl0appnA87EfmOFDD64RX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cviSfWnK; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760558187; x=1792094187;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q482SSOiJ/zOnqKGC3FlGY07uvhbQsm8dkiAe4+TWVs=;
  b=cviSfWnKOgGFJBNrnFVpYUUcNSTMUBX3vGu+W9PDKlYCKftP3VUnA7HF
   ElXR3Hh+wbcSPauZO7frdNkO4ujiP25L8W78b91Jfoo64s412LEu8cga+
   +wS5P3ddOyq/UydEd8FU77aicrjXkPajXhqFG1+c3gFzDbwhHDbjdO+6p
   K/HNS4gYq2KKlSPWmRM8GCe/UALsvQyMSoHM8OOSO5mW7+/1OhPF+ZVas
   llgZ67Hvf99YRSo+eRhFfoEKPEwzERib1ykE+f/csvixPUokUSXm2zVvL
   6lcjEC8/UytXRcGWBX7OMgqLMBcbcmLoYtUJZR3jTHYFc50NdtsGm0ZVF
   w==;
X-CSE-ConnectionGUID: 7bhU8bLXQ3SnOKrXFkmFIg==
X-CSE-MsgGUID: L5gvWfdhS6Go89iBy10Cpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="74191710"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="74191710"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 12:56:26 -0700
X-CSE-ConnectionGUID: nbUIqwVZT3adhJqeOnm6CA==
X-CSE-MsgGUID: MeM9iqhkToK8Uy5R+VD7wA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="186276534"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 12:56:26 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 12:56:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 12:56:25 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.44)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 12:56:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EvUd2ulxpQy7VYBTaosGE0wyBx0LRVBgjUPIW5S0G/hPE0oClDU+00/MGP8UfwXaM6JjD6aJieBvD4ZTPuvsy/KoW7MoMhIEmQRr+LfNjNl8Hgu/BA9WGXsxUU+ZMf+DUPQ2tprFEube2ChCTFwI3X1ydpDtnhYbp+hD2Ttg1/kQK/TLdDgr14GMV/6pn4HLPz5gjuUdHX99lKt+B0zwfdIEVdGJ0jYxtbFk4VfF1ASDiifbHf+8O9KaRm92kVQFGYegRBoGRDIBrydCwTuY4eLXMlEcK7MQ39QvXAlaL/esei85QuY2VmbaDR6M8m3f52rLQCVOHu8k4uwu/zwldg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HzAWNL/P0iA0siJPeO5/D7ViMq4SLwMJ0C/4T0UcseY=;
 b=CkezWzFJ6DSwet+e1/u5RxIdDaVyJ+QU9IT00BY67RQZcFaCNkPrRiTfhp29mchxOuUl0fobMwwxIZtMixKcZYYYkRGmbJoPzV9St3YmFvIoBdTa/DPjcF+fZR8G62yQIaa1NMJKpQREm6b+Gdu1x1/Zn8yBoLF+digNuzd1SJ+TKoID1KBGz4eG1UdT5ZY0LvV7RM+vNRW02sloB0ffkZz6EULZ+45Mi6dUo+WRAL3ZswwaUWuJ6mf7ZZQcAkoLE7uuvM69DLj3spZFkVgWgwvS750Q0oHNHcuD/qHTYtHONZ4Mh5lKScX6TDTJ4/gicpdxDgry3Iw34gFvF7Vbdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4629.namprd11.prod.outlook.com (2603:10b6:208:264::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Wed, 15 Oct
 2025 19:56:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.009; Wed, 15 Oct 2025
 19:56:17 +0000
Message-ID: <5645dec8-e344-44d3-82f7-327259a53906@intel.com>
Date: Wed, 15 Oct 2025 12:56:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix MBM events being unconditionally enabled
 in mbm_event mode
To: "Moger, Babu" <bmoger@amd.com>, <babu.moger@amd.com>,
	<tony.luck@intel.com>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<dave.hansen@linux.intel.com>, <bp@alien8.de>
CC: <kas@kernel.org>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <6082147693739c4514e4a650a62f805956331d51.1759263540.git.babu.moger@amd.com>
 <a8f30dba-8319-4ce4-918c-288934be456e@intel.com>
 <b86dca12-bccc-46b1-8466-998357deae69@amd.com>
 <2cdc5b52-a00c-4772-8221-8d98b787722a@intel.com>
 <0cd2c8ac-8dee-4280-b726-af0119baa4a1@amd.com>
 <1315076d-24f9-4e27-b945-51564cadfaed@intel.com>
 <3f3b4ca6-e11e-4258-b60c-48b823b7db4f@intel.com>
 <0e52d4fe-0ff7-415a-babd-acf3c39f9d30@amd.com>
 <7292333a-a4f1-4217-8c72-436812f29be8@amd.com>
 <a9472e2f-d4a2-484a-b9a9-63c317a2de82@intel.com>
 <a75b2fa6-409c-4b33-9142-7be02bf6d217@amd.com>
 <5163ce35-f843-41a3-abfc-5af91b7c68bc@intel.com>
 <a2961f11-705a-4d75-85ee-bf96c8091647@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <a2961f11-705a-4d75-85ee-bf96c8091647@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::28) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4629:EE_
X-MS-Office365-Filtering-Correlation-Id: cc46c5de-ee91-4823-1fed-08de0c24e780
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Vkp6U2hMVW91UlB1a1VJU096RWJZVkhtUGxjV3VuM0FLUEJQSy9sRjl2SUxB?=
 =?utf-8?B?WFVUS0JvZFpNQXdYSzB0VFdIL0h5MXlabS9VeE83L3V4ZjlDOWR2Q1Y5dTRJ?=
 =?utf-8?B?MzMyMUhORWkyMUh6YlhuYlJnTE83eTBNMHEwejBHZFQ5R1k0aVRhLzB5bTRH?=
 =?utf-8?B?M1JaalowTDlNamtsVFRXSnl0ZHJqSDNOUHhjME0vcGQvK2xJRmRFNCtNei90?=
 =?utf-8?B?SDUxRkErd1BlazU3QzlKdmhiNHJEa21TSkMzR3E5SjJFSlpzajRxL3VYdWlx?=
 =?utf-8?B?MGNpeHdGbGRKTlYweEFpNVdpQnNzUXZaTitpZElNM0IwU2d3VFZkcXRxeUcw?=
 =?utf-8?B?R2pkQzd1NHdPc21WRVVBQjFkMlhRMXhyZGJtZFZwSHE5TUV3aFFXYWtsRzlq?=
 =?utf-8?B?d0dZM3ZNOEUyVmN6T3FpV3VTdmNRcS9jSUxxS1YxS3ZsaXd3dXdESWJtSDY4?=
 =?utf-8?B?dXFpWTJwMGNCUTAveEE0SFoxVXgvK21DcnNrQUYyYXpYc2ZBTXRVRjAzT3ZL?=
 =?utf-8?B?NnRkZVVkMlMzYkZ5ck5qTDRHRTJVUk8zK1BYQVo5VFNnN2g3cG9lY2lJRi8y?=
 =?utf-8?B?a09VNzhyZERyYkpzRWxRUTVsbzFUemZDMjNLMjNXUFBURzFWK3ZvUFFpbHNX?=
 =?utf-8?B?cW9uOXBzMS9TdnA1dFRVekR6VWcrTjcyT09VU1VOdS9uUEJmK2lGVi83M21G?=
 =?utf-8?B?ZWh3aE1kQnFpRnVib1pFUE50VjJyZ3VUZ3pEYU0vWjJxcDkxZGhMNU1iNDVO?=
 =?utf-8?B?elFZMS9Od3dlemh1Rm5PSzZXTVlEU1o1MGcvd3J2UCtORGdyZXp1WHdlaVVx?=
 =?utf-8?B?TEs2bldWcnFMR3V4LzAvdmY0MUFtK1VWS0s4M1FFcnQrY2xMSFNwQWh5QUhH?=
 =?utf-8?B?ZjBRbHV2V1RTVTV4Y0wydEVXQmVJUllBNkJtSU82RkV0WUoyL0V1SXdmOVNY?=
 =?utf-8?B?K0plYVNUQkczS0F1cDIxSlJ3aHp1ZkpBUDVMMVJCalpMNXcycEMxbkxyU0Z5?=
 =?utf-8?B?K3NSZTcybXRaa0hHWjhtRzNlMHNLNGNMS3B2VTh3a3hXNWViSkg5NWZ3dmxI?=
 =?utf-8?B?WXk2L2NkTGd3cTBicWk3UkRYK3ZuclpZSmhTcGx5T0RycjZoNG5nSXlEcDNJ?=
 =?utf-8?B?cGZVeXZnbXBKa3cxTTJFTEN5dXM0Mm14cDlUSXdDVGYzSG9aWUpzWjROS1Zs?=
 =?utf-8?B?M0FrdmhVV2lVbWw2RWYvMEpLcVlMSXVEUjRlZDJjMTFpSkVpS2ZjcUFZcE00?=
 =?utf-8?B?OXYvcVQ5cGdzWmhVOUZJeG9TVS9BdUJQeDdCbkdLbkgzVWIvU2FrVE5xNmpX?=
 =?utf-8?B?ellWL3ljY1ZDRUFFTWx0YVB5Q1lPSHVVdk8wZno0WFlXU0JYOHgzOVo4WTFp?=
 =?utf-8?B?N2ZWaExFTWRGRXBuVU5NOUgrOWErNnhWWGoxcGJYbjFzTVRMZGdpL2J1Qlcy?=
 =?utf-8?B?Z3NFWXhwVjdXYjNtOHFVZThSdXEvY0I0Q2twR21Jb0gvbjBVdTViNHJPN2Jp?=
 =?utf-8?B?ZU5YeEF0U2lKb3kyNzkralJkK09Vd2FUMmxjSk5ML05WeWZibU41SjNjbVZ4?=
 =?utf-8?B?YytrNkhCc2tIRkFIcVFzalpxUkZtbTJ6RkdiVmJvWTJXT1JFNkJMMFJsR2dv?=
 =?utf-8?B?d0xsTVo5cStSalQ3clhYZEtuektGMXUyOHc1NjVZbEZ3ZW1zRlRTUDhxN0l1?=
 =?utf-8?B?RFA2bmZDUEZGazN1U2I0OG5VT3lDbktQSGNzaDdxVk0ycVNOOUUrNGdFcndj?=
 =?utf-8?B?NVgybEJLMGxNZisvMHlKNFpKMklYUXR4cnFhcXh5VDBTTkVpanpDbGkrUDFi?=
 =?utf-8?B?eDRkU3pYZTRmekhKdDZRUUg0ajhsYUFuK2Z3MXFRU2NQM1pMNmpvNHJna3Iy?=
 =?utf-8?B?dHBhYVBZaDdPaEJBWjZ4dFNaSE1zd0ZEZTN1WTBhRFZoYU5yM0tNeHcrUjJx?=
 =?utf-8?Q?UndHcuM8Iz/fUdia4TabvXKQVoGcrFLq?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0FJa2dJMWxHL1NvcGd1WXlpRnEycmpPMmFvU1FsUHlaQUgwVmpFRXc0RjNt?=
 =?utf-8?B?blBXWFdMa1dWNFp6MkJ0clZPZ3lybUxSMzJFNk13SWlQMUFFNFkyTjdHMzJr?=
 =?utf-8?B?bFdzRjRpak84VUlVcXJJWTJoQlZvSC95Nml1TXJyN1hzYUI2YUxZTHY3Y0p4?=
 =?utf-8?B?WkxpRVkxcDgvSFVzSlhHRzJEOG9vOGhvSHF4a2FNVjFlY3VQVTNNRUgxc3Nz?=
 =?utf-8?B?YjhoQlU1Ni9qVkhDeURiK2xEdzRKM0wrM3hOLzVTZUdoSkV5a08xbTNHTC8r?=
 =?utf-8?B?RDJBZ0FDN0EvZVE5UzZlTURvaTNqZndjbjlIc01BMzhrUld1YVprU0pMTHpk?=
 =?utf-8?B?TnljNm9uZ0gyTnI1U3gzeEdSakRvazFuSHBlWHU1Q0UyMW0vRkRjeFV5cmxi?=
 =?utf-8?B?NWJWUGZrREIxZEc5S3FnT1dBSitCQWFFMnlFTmNYV3NWQ0tWUkRabEpYTHpM?=
 =?utf-8?B?d3hZUm1vTCtsUGR2a3dWWG80OEFrckRLK1ZLdHl4UkpnbkdES0FNTXdxNnpR?=
 =?utf-8?B?THNweFFBMGdYN1FFMWUxZ2ZrZ2JUZEpqUzEwcWJ4VzhrcXJLNzV2eWgrakJn?=
 =?utf-8?B?ZjcyZThSb3VhQXA1bWhGNGdjb2pFajEwNE1ONzlFWkZ2Tjg0eFprZ0JvTk1J?=
 =?utf-8?B?RE12R3pwTUViNEVDbU9DbnNPbzVoejdKZ2ZxNm02K0JmcVQrMzh5eVNBVlM1?=
 =?utf-8?B?QktTazZnRTVjNWk1N3pMRVRsZFlqZ1RlcWp3ODdzUEladSttY0tpeUtnQmFw?=
 =?utf-8?B?MDgxdmp0L205WmFxMjdLUnJLZitKaTBta1p1U1pDcWJLS0I1cGkxUmJ5Yyt0?=
 =?utf-8?B?Z0tUREJCL1ZLTlp6bHlMUFRsMXpaeFhMd2duWXNFcFVFVGtGQkwxV08xT0w5?=
 =?utf-8?B?N0dGcnJtRE1aeWhqM29tWDhFOVVPaXc4WmlpVXdhRCt5OW5Gc1R4NktDVTQ1?=
 =?utf-8?B?bzQxMUFzS3hRazhQTndBODhESVBPSTNDMGtweGRReFVDbnhQUTV3VHJmV2o1?=
 =?utf-8?B?TVFUVm55aXRyRm5WZHAxRTRjdnU4U2VJeHdEdFZqN2dHakRjVkJQTHBneHpp?=
 =?utf-8?B?MVlUVzd1WTJWRE81MnNYUEhnZWtkMTFNQzBUeVNmU2VUU3NXYjZrYmZLdVA1?=
 =?utf-8?B?M0ZXSmZLQWxrNk0xSHl3MVJVNWhhbzFuZm91RURuOHh6emMrUjNBLy9kODJR?=
 =?utf-8?B?ZFdyYmZpV0tMWVdESEt0dGJzK3g4TjNWZEtzMXM2UnRMaS95STQwck5xK3B1?=
 =?utf-8?B?T2ZZN0J6VnF4djd5RFZqMU9pcm9yQUxQUFhBbmJqZWRyMXB2RXNVWUFrRlh3?=
 =?utf-8?B?emVGL0NHZ2VhcUp0aWJBMkt6YjRCTWl1ZlVWMmZoMncxZHVJdnJaZ3lpcDNU?=
 =?utf-8?B?U05qUzZueGZUdWkwNTJ1a1RmSVpheG9UeVJhdjBsTkpBcHdpYUJmY1VlSlB0?=
 =?utf-8?B?SWNDRlNSRldUSzlRT0NsU2lndXZVKzRObjBad2w5ZjJQbXB6Q2M5dzhjTU9r?=
 =?utf-8?B?NVZOSGNRbWJVaVYxdFcwM1creWRFUm9CYTExSHY2a2ZvbjZkWkQxY3gxMVlE?=
 =?utf-8?B?a2VKZUM3QTR3QXVvZDExVzRtbVoxSVJOL3dGZ2tlY291UlV5QmVmbFZjakR1?=
 =?utf-8?B?V0FPYzAzNXpUMU1iVXBnVlVRUDZUTGNqaEJEUW9RYzk1K3Q1b290UllwVjBS?=
 =?utf-8?B?ejlWZnRnc0NUUnR0c1UrejBwRkpITUJEdGlWaks3YnNSVEgrM2RKV1ZSb2Rw?=
 =?utf-8?B?emh1U3dCUFFtR3hkdHdJNVpBRS94b3p6YzUvMU1GSnhKTldCUzVHS2NJejNF?=
 =?utf-8?B?ajZSajVjRE5ZMXZPd0R3NTlabytZbXRVV0ozSy8rZEJXWmM4bW0xVGxNUGRk?=
 =?utf-8?B?enNTdzg5ZWNuNDBpUjJrVGJUTXN4ZUhKM0RJeW03ZUV1aUNSUk8vSDFNMGxX?=
 =?utf-8?B?dUF3UWZIZ2licEFXbUJnM3VSQkFlMXQvZHpkV2NVWnhBMnZOUUMzR01UWEND?=
 =?utf-8?B?a2ozK1EyYTJOdjQxZUhSaG54czNwUi9qck80dUwyR2tUTWxWUlZsdWp3TFdp?=
 =?utf-8?B?dUN4N2w2amJLTjgrZGQvVVFteFRpd1ZhbnpwRko4VE5xS2QremFlZnhha20v?=
 =?utf-8?B?Y1RDeWNpMXdIb0duaVBLMDBab2VQYTlTbWtjcGlIT3FkWGwxcXVTeUdMS01G?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc46c5de-ee91-4823-1fed-08de0c24e780
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 19:56:17.6698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0vEvGJnLvdy1gN2rl9WrRNx/6e5xDvz7S7Mkw/u8jY0+43zDG7OWyJu+K9uixvvANprfHIJ1t5w2TsvMGKeHY9aHj7dnBQ4BGWHscC6EXWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4629
X-OriginatorOrg: intel.com

Hi Babu,

On 10/15/25 7:55 AM, Moger, Babu wrote:
> Hi Reinette,
> 
> On 10/14/2025 6:09 PM, Reinette Chatre wrote:
>> Hi Babu,
>>
>> On 10/14/25 3:45 PM, Moger, Babu wrote:
>>> On 10/14/2025 3:57 PM, Reinette Chatre wrote:
>>>> On 10/14/25 10:43 AM, Babu Moger wrote:
>>
>>
>>>>>> Yes. I saw the issues. It fails to mount in my case with panic trace.
>>>>
>>>> (Just to ensure that there is not anything else going on) Could you please confirm if the panic is from
>>>> mon_add_all_files()->mon_event_read()->mon_event_count()->__mon_event_count()->resctrl_arch_reset_rmid()
>>>> that creates the MBM event files during mount and then does the initial read of RMID to determine the
>>>> starting count?
>>>
>>> It happens just before that (at mbm_cntr_get). We have not allocated d->cntr_cfg for the counters.
>>> ===================Panic trace =================================
>>>
>>> 349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
>>> [  349.338187] #PF: supervisor read access in kernel mode
>>> [  349.343914] #PF: error_code(0x0000) - not-present page
>>> [  349.349644] PGD 10419f067 P4D 0
>>> [  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
>>> [  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted 6.18.0-rc1+ #120 PREEMPT(voluntary)
>>> [  349.367803] Hardware name: AMD Corporation PURICO/PURICO, BIOS RPUT1003E 12/11/2024
>>> [  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
>>> [  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
>>> [  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
>>> [  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 0000000000000002
>>> [  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 0000000000000020
>>> [  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 0000000000000001
>>> [  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: ff1f5d52517c1800
>>> [  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: ffffffff9525b968
>>> [  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000) knlGS:0000000000000000
>>> [  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 0000000000771ef0
>>> [  349.471022] PKRU: 55555554
>>> [  349.474033] Call Trace:
>>> [  349.476755]  <TASK>
>>> [  349.479091]  ? kernfs_add_one+0x114/0x170
>>> [  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
>>> [  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
>>> [  349.493553]  rdt_get_tree+0x4be/0x770
>>> [  349.497623]  vfs_get_tree+0x2e/0xf0
>>> [  349.501508]  fc_mount+0x18/0x90
>>> [  349.505007]  path_mount+0x360/0xc50
>>> [  349.508884]  ? putname+0x68/0x80
>>> [  349.512479]  __x64_sys_mount+0x124/0x150
>>> [  349.516848]  x64_sys_call+0x2133/0x2190
>>> [  349.521123]  do_syscall_64+0x74/0x970
>>>
>>> ==================================================================
>>
>> Thank you for capturing this. This is a different trace but it confirms that it is the
>> same root cause. Specifically, event is enabled after the state it depends on is (not) allocated
>> during domain online.
>>
> 
> Yes. Thanks
> 
> Here is the changelog.
> 
> x86,fs/resctrl: Fix BUG with mbm_event mode when MBM events are disabled
> 
> The following BUG is encountered when mounting the resctrl filesystem after booting a system with X86_FEATURE_ABMC support and the kernel parameter 'rdt=!mbmtotal,!mbmlocal'.

"booting a system with X86_FEATURE_ABMC" sounds like this is a feature enabled
during boot?

>  
> ===========================================================================
> [  349.330416] BUG: kernel NULL pointer dereference, address: 0000000000000008
> [  349.338187] #PF: supervisor read access in kernel mode
> [  349.343914] #PF: error_code(0x0000) - not-present page
> [  349.349644] PGD 10419f067 P4D 0
> [  349.353241] Oops: Oops: 0000 [#1] SMP NOPTI
> [  349.357905] CPU: 45 UID: 0 PID: 3449 Comm: mount Not tainted
>                    6.18.0-rc1+ #120 PREEMPT(voluntary)
> [  349.367803] Hardware name: AMD Corporation

This backtrace needs to be trimmed. See "Backtraces in commit messages" in
Documentation/process/submitting-patches.rst

> [  349.376334] RIP: 0010:mbm_cntr_get+0x56/0x90
> [  349.381096] Code: 45 8d 41 fe 83 f8 01 77 3d 8b 7b 50 85 ff 7e 36 49 8b 84 24 f0 04 00 00 45 31 c0 eb 0d 41 83 c0 01 48 83 c0 10 44 39 c7 74 1c <48> 3b 50 08 75 ed 3b 08 75 e9 48 83 c4 10 44 89 c0 5b 41 5c 41 5d
> [  349.402037] RSP: 0018:ff56bba58655f958 EFLAGS: 00010246
> [  349.407861] RAX: 0000000000000000 RBX: ffffffff9525b900 RCX: 0000000000000002
> [  349.415818] RDX: ffffffff95d526a0 RSI: ff1f5d52517c1800 RDI: 0000000000000020
> [  349.423774] RBP: ff56bba58655f980 R08: 0000000000000000 R09: 0000000000000001
> [  349.431730] R10: ff1f5d52c616a6f0 R11: fffc6a2f046c3980 R12: ff1f5d52517c1800
> [  349.439687] R13: 0000000000000001 R14: ffffffff95d526a0 R15: ffffffff9525b968
> [  349.447635] FS:  00007f17926b7800(0000) GS:ff1f5d59d45ff000(0000)
>                     knlGS:0000000000000000
> [  349.456659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  349.463064] CR2: 0000000000000008 CR3: 0000000147afe002 CR4: 0000000000771ef0
> [  349.471022] PKRU: 55555554
> [  349.474033] Call Trace:
> [  349.476755]  <TASK>
> [  349.479091]  ? kernfs_add_one+0x114/0x170
> [  349.483560]  rdtgroup_assign_cntr_event+0x9b/0xd0
> [  349.488795]  rdtgroup_assign_cntrs+0xab/0xb0
> [  349.493553]  rdt_get_tree+0x4be/0x770
> [  349.497623]  vfs_get_tree+0x2e/0xf0
> [  349.501508]  fc_mount+0x18/0x90
> [  349.505007]  path_mount+0x360/0xc50
> [  349.508884]  ? putname+0x68/0x80
> [  349.512479]  __x64_sys_mount+0x124/0x150
> 
> When mbm_event mode is enabled, it implicitly enables both MBM total and
> local events. However, specifying the kernel parameter
> "rdt=!mbmtotal,!mbmlocal" disables these events during resctrl initialization. As a result, related data structures, such as rdt_mon_domain::mbm_states, cntr_cfg, and rdt_hw_mon_domain::arch_mbm_states are not allocated. This

This may be a bit confusing with the jumps from "enabled" to "disabled" without noting the
contexts (arch vs fs, early init vs late init).

> leads to a BUG when the user attempts to mount the resctrl filesystem,
> which tries to access these un-allocated structures.
> 
> 
> Fix the issue by adding a dependency on X86_FEATURE_CQM_MBM_TOTAL and
> X86_FEATURE_CQM_MBM_LOCAL for X86_FEATURE_ABMC to be enabled. This is
> acceptable for now, as X86_FEATURE_ABMC currently implies support for MBM total and local events. However, this dependency should be revisited and removed in the future to decouple feature handling more cleanly.

If I understand correctly the fix for the NULL pointer access is to remove
the late event enabling from resctrl fs. The new dependency fixes a related but different
issue that limits the scenarios in which mbm_event mode is enabled and when it may be possible
to switch between modes.

I think the changelog can be made more specific with some adjustments. Here is an attempt
at doing so but I think it can still be improved for flow.

	x86,fs/resctrl: Fix NULL pointer dereference when events force disabled while in mbm_event mode

	The following NULL pointer dereference is encountered on mount of resctrl fs after booting
	a system that support assignable counters with the "rdt=!mbmtotal,!mbmlocal" kernel parameters:

	BUG: kernel NULL pointer dereference, address: 0000000000000008
	#PF: supervisor read access in kernel mode
	#PF: error_code(0x0000) - not-present page
	RIP: 0010:mbm_cntr_get
	Call Trace:
	rdtgroup_assign_cntr_event
	rdtgroup_assign_cntrs
	rdt_get_tree

	Specifying the kernel parameter "rdt=!mbmtotal,!mbmlocal" effectively disables the legacy
	X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL features and thus the MBM events
	they represent. This results in the per-domain MBM event related data structures to not
	be allocated during resctrl early initialization.

	resctrl fs initialization follows by implicitly enabling both MBM total and local
	events on a system that	supports assignable counters (mbm_event mode), but this enabling
	occurs after the per-domain data structures have been created.

	During runtime resctrl fs assumes that an enabled event can access all its state.
	This results in NULL pointer dereference when resctrl attempts to access the
	un-allocated structures of an enabled event.

	Remove the late MBM event enabling from resctrl fs.

	This leaves a problem where the X86_FEATURE_CQM_MBM_TOTAL and X86_FEATURE_CQM_MBM_LOCAL
	features may be	disabled while assignable counter (mbm_event) mode is enabled without
	any events to support. Switching between the "default" and "mbm_event" mode without
	any events is not practical.

	Create a dependency between the X86_FEATURE_CQM_MBM_TOTAL/X86_FEATURE_CQM_MBM_LOCAL
	and X86_FEATURE_ABMC (assignable counter) hardware features. An x86 system that supports
	assignable counters now requires support of X86_FEATURE_CQM_MBM_TOTAL or X86_FEATURE_CQM_MBM_LOCAL.
	This ensures all needed MBM related data structures are created before use and that it is
	only possible to switch	between "default" and "mbm_event" mode when the same events are
	available in both modes. This dependency does not exist in the hardware but this usage of
	these feature settings work for known systems.
	

> 
> Fixes: 13390861b426e ("x86,fs/resctrl: Detect Assignable Bandwidth Monitoring feature details")
> Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Babu Moger <babu.moger@amd.com>
> 
Reinette


