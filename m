Return-Path: <kvm+bounces-59816-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CB77BCFC08
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 21:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9D8A3A23A8
	for <lists+kvm@lfdr.de>; Sat, 11 Oct 2025 19:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F25F12848B1;
	Sat, 11 Oct 2025 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c7RqtMz7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB682285041;
	Sat, 11 Oct 2025 19:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760211656; cv=fail; b=nLF/MkO1KRr0cTMDZw1z60vQMmkblO89NfwmeRwjMJ+wUXMvXdNqqYJaAB+YwInfNgLZc7gka+V0DHYpxFOfmdtF0mbZ5kdUj0vI7qAy37xXteDkcICyY8Y9BFI62Jm3md7cUDUqdsy63aPbvLJ+HfQgpmgjClg8rpzlFZhudtI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760211656; c=relaxed/simple;
	bh=4BnqVkzq0uBUaE2ZFDDrJMshl6GxL83zfN8eXRVo0Mo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U0lg7qSEriLsWHfcjCshaOrTAhjBgcjN9Z8IA5YfdKtzfaIiYSiGiBNJPH1ncpCl9WqEc8NqKN6TnTHLdFxYbJgp4Z9TaDjwFLkTgwfshthDh2bFaUryhYUurSscBUszh2+HUpBjThDpqDSb97GoC8F1rFB0fgTjHFP8BnO65vU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c7RqtMz7; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760211655; x=1791747655;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4BnqVkzq0uBUaE2ZFDDrJMshl6GxL83zfN8eXRVo0Mo=;
  b=c7RqtMz7A0GkDseBnXJdBDscZG1+lLG/Qa8FW5R7872R5OUS8NzLpA3e
   ndTmABrv2CbVGve6UgOQgWpn4iGiGQxaOQS91xtQus3ZjmSNYtK5Hsd/c
   uA+T5s3NQEFlMbJjtjo+6KFx875eUgGpk5/OoQZOOLfWdNRKawChrXUhJ
   ywvvzHkkdDAZ19bjz3s5h54caAuT8d1T1epbDK2JpvwewuLMxbif4sa0n
   m2Ob02YlW3/wSv74STIbPY1TrWc0pbgCkxaDlVKb8c90DoJM2wwBr/Kz4
   Lz+CxVe6n2R8wEYSR7OF0B3wL0ajYPm5tUjViMKKLgjgxx/HekmdP282W
   g==;
X-CSE-ConnectionGUID: xc2siXoIQUa61ib7M52FUw==
X-CSE-MsgGUID: r2R7DVs+R2Obn0I/YiY3dg==
X-IronPort-AV: E=McAfee;i="6800,10657,11579"; a="62294747"
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="62294747"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 12:40:54 -0700
X-CSE-ConnectionGUID: rGLR3XLBRWuu5ucWFCN31Q==
X-CSE-MsgGUID: ieTk7PCNRweYnYzWjOiLnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,221,1754982000"; 
   d="scan'208";a="181252884"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2025 12:40:54 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 11 Oct 2025 12:40:53 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Sat, 11 Oct 2025 12:40:53 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.38) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Sat, 11 Oct 2025 12:40:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ev1iHQMIItTL+QGoDSso45/r8l82wSCWy89kqUONkC50n8ipgPNnuPqa1RCmzcWJcYVz0OVrr0HOfjXvMhyifWugeOOX2OgjZOiV+nbeqNb43B5z7tkJGACQhpGS39TKKRhIXnLDHxss0On2V3v9s67rkR3mUR1KOoixjM5CtEWbtafWXVnsjsbIYAn7NoKs0EBEV7/UqOzQfwUZG8v+XQvxsLRnndaNmqr1CCgAAngFYNkbbxM88bvCuho36uLGKkuQW2zJOvpnuRrlhq6PoRaJViTtgm+IpJZ5fLa9xI1mlJTiuTIhNOBs/+F1C5uLal8SnyOnUpFGlGjNOmMBdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ixx6GHOQqftCFyVuvSjPjy7bIiTfasuSbhtf1GV88jo=;
 b=Hl9oYUHj4tIxKMB2Fva3tDauMPek0nIrVLFiLS9VGjnfzRHdneOE4IdJXxHsv3p5VQRqjmkgGBVIcngAwPXDxqAGyM8oErSTqbfcDoSk8b5Dc+PLY0fG+nMt0EvrAi+Uad7qWw6mUvBLTvRyusQO3eksg2iTpZYFcpmdy+NhN+lQu3UPdGRxmLX1AxDuTFGHwgo+UUXzz1LuHhylQYn0n946Cn0zTAxWO61XIXu1faN3F8QXvBnT8UcGxrwp+HwizE90FKcWyVqkRR/D4HGXiUPZdFCgB+vgLssZ3yfAYTC/arn6w+7A2FDqdeoD6ajKpDmk0InCfXNUOR5YhO4l0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFF2E67D388.namprd11.prod.outlook.com (2603:10b6:f:fc00::f60) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Sat, 11 Oct
 2025 19:40:51 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9203.007; Sat, 11 Oct 2025
 19:40:51 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
CC: <dri-devel@lists.freedesktop.org>, Matthew Brost
	<matthew.brost@intel.com>, Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, =?UTF-8?q?Micha=C5=82=20Winiarski?=
	<michal.winiarski@intel.com>
Subject: [PATCH 08/26] drm/xe/pf: Add minimalistic migration descriptor
Date: Sat, 11 Oct 2025 21:38:29 +0200
Message-ID: <20251011193847.1836454-9-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251011193847.1836454-1-michal.winiarski@intel.com>
References: <20251011193847.1836454-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: WA2P291CA0043.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1f::28) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFF2E67D388:EE_
X-MS-Office365-Filtering-Correlation-Id: cc0751f9-1715-439f-363a-08de08fe15fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VU5Sc2RuMEJkTHZ2enZKTElwa1ZQRzBFcStjSzc1WThMVnM2Zmh5OGF6NUFP?=
 =?utf-8?B?eEhLSG0wZUJrc1doUU0wR0dDdVRMSTdvNUM1NTNNWnhUWGtnSzZzVlFJRE56?=
 =?utf-8?B?Y1ArUWN1Q1pHelU0UFlTS004NkRuaGFaQVBvYjBQcVJ3VmRXb1NtNU1zVEJD?=
 =?utf-8?B?d2dFNVgyTlhKOFlsRG9SaWpFRHl3dGlzZHlXTHUzWS93V3Rob0RNQkYzMUNI?=
 =?utf-8?B?VzQ3Y0xrOGVGS2RPQ3c3bEpzbHpiY2VlSkY3MHFGNHpnSWR1b0xWTTFFZUd5?=
 =?utf-8?B?MnJZVzBlalVMVmsva3d5OEhBQ3N6RHdHNjB1UWlwVmt0bk5xT2lybzlhcjVC?=
 =?utf-8?B?bGhOQzdxaytCMkJXNnphNXNjTFlQMHAzMlBuODdjc1BzcUlSWHFMemluK2sr?=
 =?utf-8?B?Z3Z4YzdOcnN1RnZJVWpUelVyMWdRd1NDTUZqU2UzNGdyc1RBQjdTMS9OdTg4?=
 =?utf-8?B?K3gzRy94SW5aQ0FDMks2dVQ0bUk5NWNZNHdBeFphSUNOdkRxTWRlbit5T1N2?=
 =?utf-8?B?blN2WlBnaXIzZlQrSU5tM2xQT0tlOXdIRWt2ZVJVR1poZXJDVFVjSzNPTTUw?=
 =?utf-8?B?cDVWUlFsRUVqSVpmS242d05ZcmV6amoxVDVWejNURmM1ZWphK2JidzFhSldW?=
 =?utf-8?B?bGQxQnVOTERYS3EvSmFnRGVLOXlYY3UwblhkUlN3WXhpSE9GT00zajdkWmZC?=
 =?utf-8?B?WW83Q2dIbjgyaC94OEhJZEtwWW1icElybmdLcE9CRWcwc2VmVlVtSmQyOFIy?=
 =?utf-8?B?TCtoK1JZdlFjRldTQW44N1pOdkFMME5mTzgxdEJCMC9jcnF5VWl1NnhmYVlk?=
 =?utf-8?B?R2o0bWtqL1BCRVU3M3A4TTVRNm85VU52QTh3cko0bXVFayt3RTVlNTFGdng2?=
 =?utf-8?B?aDlHeDZYNWpLenFhTjFjRW5UZU5QbUR6Sjd3cWFZaHo5WU5yb3pWaUJReW9C?=
 =?utf-8?B?bDJ6QXhRUEJmUGpEYkQzbnd2WmdobHJVWnBpRjUrZ0U5K0xOWjJiSU9EY3d5?=
 =?utf-8?B?by9KM3Y3ZEVmRVRJODJKZnVRWEFDMFhIemJLTWsvUW9vMDlidDZtYjN2OXJi?=
 =?utf-8?B?NnBndFZUN21WYXVGSndrbmZhRFJ5cXFjSGNPZjNvMWNPUzRlKzVyQnVvRmx2?=
 =?utf-8?B?ZHNjVTlYbVJkaVhpazRGVU1rZ1JWTEVDL0F3dlU1N0lSd2h5dzVxY0RIN1FN?=
 =?utf-8?B?N0wzTmU2ZFRNQWdjT1E0S2dsaUxEeFFmQ0syR1EwMG9uNHNYMWJSaHRPNVA4?=
 =?utf-8?B?TTg3WDBPMmsyUlpBUUlPRFBFY2lXVEdzYWp1bkQ4MytQM21DcFB3Z2dwTDUr?=
 =?utf-8?B?VGlPaEJjNXlTSllBcHV6L2VHK1hHUjU1VUUrS0hsaXh5WXNwdHFSYXlMWVBO?=
 =?utf-8?B?NURQcXdJckNWTjNCKzRDTFZ2SDlDNXk1enZwdUVVSkJMR3QzakR4Q1BsSlNX?=
 =?utf-8?B?YTJ0c2V2VjR6ekIvaE1STWR2bStEQkNVZWh5eFIwSnVadjA3MllOR2ZsQjRu?=
 =?utf-8?B?VFhCbWVwR1BDTmxYNUNsMm95NmVNNlk1REZiZHJyWm1TTlc3bWF2c3RIMktp?=
 =?utf-8?B?V1h0d2xQeUZSY0ZGMUk5QmdESU5yVHk4TG1HTzE5T3NKTmVLQ2FuMWxac3ll?=
 =?utf-8?B?bkVyN3VOMkhwU0ZvcWdpWnJNeTB6QjBVK3pYRWRLWVpoN0NNZHB0eG5xNzRD?=
 =?utf-8?B?c3JOV3B3ZTN0SEpQVGFKOHdHOUpsNmd5WnlGNkN0RzhKRnpNT0pDU3k0TXhO?=
 =?utf-8?B?ak9XbWtSK2tkeXdWNERnUWhIZVo2ZzMxNm1xcmIzbnI2clU1Wm5YS2FLMmht?=
 =?utf-8?B?VWFHRVZJN2ZXS2VHcUtJdjk1dDBDUU53NjExUlJtdEQ1MUVCSkYveW45ZEc5?=
 =?utf-8?B?Nm1Uei9ZTHlrQWF0VEhaRE9ScHRZd1loaTBVNGRSNUNROTQ4RFJLb28yaFNN?=
 =?utf-8?B?b2NoVzNiK1FrMDhxWmFsNUozRkhqYzNoWHZTVnlrU0lkUFR2SWN3QmF3aTRH?=
 =?utf-8?Q?WAxOODmc6WtnwG9BuEj4OrzkpLu/Xw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0E0T3h4KzdacFJrOVlaRHhjb0FzLzJrVXlCcXVRZU9hUksxTkRmYVVqQm4w?=
 =?utf-8?B?ZjBVVytXOEhHQlFKTzlDbmdhYjVIZlEzT0c5WlVrMmtscmVaSEdLWTZlS3B0?=
 =?utf-8?B?dTlyVldTU0QvUWl2ZmhPdTN5QzI5YnVka1pPekI4TE5SeTFQdU5qd3JsRlUw?=
 =?utf-8?B?dWdmR0xybngrY2kvdCtqdDN3R2lRSytzV05IT1FFR1ZCVXV4MXROY1dNRWZl?=
 =?utf-8?B?Z3ZENEpNbGNNNEkxb29Wak1WaFlIaHFMaUw1WU9QRHhDSVpmRmZZRFRRYXMz?=
 =?utf-8?B?blQ4SER1ZHRldWFlM3U2Mjl3NjcxWEpiMGpsR1VYYmk2OEtOd01ySGFQNWR2?=
 =?utf-8?B?OEl5VWQ4ckJVY1Joek1zZ2xxT3BNN2ZGT21kd3haRTZiWjNaSTJCdStLK3hX?=
 =?utf-8?B?czFYbkhySnp6UGpWU3JrZ29CZHpLc2J6cFlFaFVIQkJ5K0huTWZWcjVwQmI1?=
 =?utf-8?B?ZVBVaFNzTXVxK1lJRVFReGFWVnM1aG5VMnFPZ2JTRUFYcWV1ckkzZE5rdERa?=
 =?utf-8?B?UzFyMktYYzRkL0xMdWVhQzFUVm5DUUo2MjROeVowVTFlYXRSbnA5cHBLSlJj?=
 =?utf-8?B?ZDdVRG1kblZyYWJ6VUFCZTg0dzhvYmVHeUdPa2RlbXU1MG5wOEdQVGhvemJo?=
 =?utf-8?B?blhzcUI0TkFTTVVPWUZiTUwvK1dNWEtWQTV3LzVaVFh0dGR2dWJMVGJlUkNy?=
 =?utf-8?B?UzRkRk1NZmlLNzlzMStrYVc2M1RYNnBPcXRUYzQ3NU9uQkUvdXk2TXlUc0g5?=
 =?utf-8?B?aHZQdEF2WmpMbWxUZ0Q2ejhZN2dBOTVMb1JCMjRUbGNtQ00yaUVxbFgyZVBv?=
 =?utf-8?B?Sll6ZFBtWVRFMUErblNvZWlTMlAvRlNGQnp5MG90eGx0TURvRkwvb3F5SjZa?=
 =?utf-8?B?K2lrN1VNR2o2U1VCNkxmcTBaTXRPZkFYeEJ0aVU1dktZSHNBSTRDM0FqOWpL?=
 =?utf-8?B?MXB1OVloUm8vQkN5enJmbCt4V0RwczBETlRnM3VSUUhXRklPKzJXakJ6N1ZW?=
 =?utf-8?B?UWNwZGVnY2VCZFhmZk9Dc2ZnSjNiNXQzRjN5RG9ldFZLdGhQQ0FzbVFyaEl6?=
 =?utf-8?B?VUNNU3RUdzZXVGozLzhqS1RMNXlZUDQ1cDhybjg4M3I3MlJWRkZpY1JOa2s0?=
 =?utf-8?B?MER0VzdiNDc5a1IyVm1SQU5HVFZxQU82c1FEV3VsRnk5VUZOSHlFV2dBbFBZ?=
 =?utf-8?B?clRRMUNuTGNSV3hkemtqQjdHWjJLcWdiSWZnT2VKVHozY2FUQ2tzL3N4Smgr?=
 =?utf-8?B?YXN1T2ZoWFo1aUUrRjJQd0N0MkhERFJqVmY4dG5peVN3UkxVempqQUQ0U1R5?=
 =?utf-8?B?QW1hbE1BMHJMdUlDVFBXVUl6V2NkTnZPSFF2NktQYlRVdkZSNXcveXZON2pm?=
 =?utf-8?B?ckFOYjkxR2R0dDFFZE5ocDhrWHVWejkxOGt3NG0yRllUeWdBcXhsUndGNlc2?=
 =?utf-8?B?Sm0zVGN6Y1VJWXdRdGJaV3QyTGNubjRqSDEwUVlwU0ZHMkt5dm1GVHhBTFV2?=
 =?utf-8?B?eVhYVFgvV0RPdll5dEJBSmRacVdqczVzanBpMVVud1FVVVJvMk5BVU5MZTd0?=
 =?utf-8?B?TzBHMWNjZFlPMEl4Z0loL1ZldEZtQXVmNW5ucDNkNks0UFJid2phSnI1cHNa?=
 =?utf-8?B?L0hQZUc2RlhocDFQdVFLb1FRUlB1RnIwVm9tbUt3TXM2R2xRdUNYNmd1cDNG?=
 =?utf-8?B?NWVsZU9PNjRuT1B2c2NLaS84U2RQb0V5MFJqNmF0MUV3K0d0bG5FU2hJKzdn?=
 =?utf-8?B?amVFcnl5Uk9FOWxqSVVzbmt4QWdIZFhQcEI3SldJclUxbUJSM3hiM1pPN21k?=
 =?utf-8?B?N2RqYUhFd3R6bGU2cmh0VDZ6TWFGZTlGVnBQVzhacVFHa05vK2s2bEV6d1NN?=
 =?utf-8?B?a3Z6RGZxcVd1bm4zOVhrd3dJR2I1bkFTSlpjL2FuTkN2bWZCODRRZCtRL3pm?=
 =?utf-8?B?QUQyRCtKNmc5VzNyKzlURDNYQjJDZFRiKzBVYVlTUjdGMmRVR1NJZWg3OFZK?=
 =?utf-8?B?elJERlhVc1JPRVBaVlNBV2tSYURoMHlyeFZLOHp0R09JM0U2UUwveitsV2Zh?=
 =?utf-8?B?MUJIT0NNdDFCc2VpdzZHM2VFSmRFdk92dldhaHpnTFNJNnhkeWxuMS9sZVQ2?=
 =?utf-8?B?eXhhbGhLZHIrVXVlSXZia0RTSG9Qbi83STR1c3dlRmtJVnk0SnJXUlZFTHVQ?=
 =?utf-8?B?eXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0751f9-1715-439f-363a-08de08fe15fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2025 19:40:51.8007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9F/kBdfRhx7JWs0FT/iyz2AZLBhEr/Xq/rOnYCyiVSoiWB5bpdFqZVEhu9Xh6ANobv9f+b+QFJtdKF5zBThNGzNLev7maJJskMxlGeXLp4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF2E67D388
X-OriginatorOrg: intel.com

The descriptor reuses the KLV format used by GuC and contains metadata
that can be used to quickly fail migration when source is incompatible
with destination.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_sriov_pf_migration.c    |  6 +-
 .../gpu/drm/xe/xe_sriov_pf_migration_data.c   | 82 ++++++++++++++++++-
 .../gpu/drm/xe/xe_sriov_pf_migration_data.h   |  2 +
 3 files changed, 87 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
index 9cc178126cbdc..a0cfac456ba0b 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
@@ -186,10 +186,14 @@ xe_sriov_pf_migration_consume(struct xe_device *xe, unsigned int vfid)
 static int pf_handle_descriptor(struct xe_device *xe, unsigned int vfid,
 				struct xe_sriov_pf_migration_data *data)
 {
+	int ret;
+
 	if (data->tile != 0 || data->gt != 0)
 		return -EINVAL;
 
-	xe_sriov_pf_migration_data_free(data);
+	ret = xe_sriov_pf_migration_data_process_desc(xe, vfid, data);
+	if (ret)
+		return ret;
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c b/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c
index 9a2777dcf9a6b..307b16b027a5e 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.c
@@ -5,6 +5,7 @@
 
 #include "xe_bo.h"
 #include "xe_device.h"
+#include "xe_guc_klv_helpers.h"
 #include "xe_sriov_pf_helpers.h"
 #include "xe_sriov_pf_migration.h"
 #include "xe_sriov_pf_migration_data.h"
@@ -404,11 +405,17 @@ ssize_t xe_sriov_pf_migration_data_write(struct xe_device *xe, unsigned int vfid
 	return produced;
 }
 
-#define MIGRATION_DESC_SIZE 4
+#define MIGRATION_KLV_DEVICE_DEVID_KEY	0xf001u
+#define MIGRATION_KLV_DEVICE_DEVID_LEN	1u
+#define MIGRATION_KLV_DEVICE_REVID_KEY	0xf002u
+#define MIGRATION_KLV_DEVICE_REVID_LEN	1u
+
+#define MIGRATION_DESC_DWORDS 4
 static size_t pf_desc_init(struct xe_device *xe, unsigned int vfid)
 {
 	struct xe_sriov_pf_migration_data **desc = pf_pick_descriptor(xe, vfid);
 	struct xe_sriov_pf_migration_data *data;
+	u32 *klvs;
 	int ret;
 
 	data = xe_sriov_pf_migration_data_alloc(xe);
@@ -416,17 +423,88 @@ static size_t pf_desc_init(struct xe_device *xe, unsigned int vfid)
 		return -ENOMEM;
 
 	ret = xe_sriov_pf_migration_data_init(data, 0, 0, XE_SRIOV_MIG_DATA_DESCRIPTOR,
-					      0, MIGRATION_DESC_SIZE);
+					      0, MIGRATION_DESC_DWORDS * sizeof(u32));
 	if (ret) {
 		xe_sriov_pf_migration_data_free(data);
 		return ret;
 	}
 
+	klvs = data->vaddr;
+	*klvs++ = PREP_GUC_KLV_CONST(MIGRATION_KLV_DEVICE_DEVID_KEY,
+				     MIGRATION_KLV_DEVICE_DEVID_LEN);
+	*klvs++ = xe->info.devid;
+	*klvs++ = PREP_GUC_KLV_CONST(MIGRATION_KLV_DEVICE_REVID_KEY,
+				     MIGRATION_KLV_DEVICE_REVID_LEN);
+	*klvs++ = xe->info.revid;
+
 	*desc = data;
 
 	return 0;
 }
 
+/**
+ * xe_sriov_pf_migration_data_process_desc() - Process migration data descriptor.
+ * @gt: the &struct xe_device
+ * @vfid: the VF identifier
+ * @data: the &struct xe_sriov_pf_migration_data containing the descriptor
+ *
+ * The descriptor uses the same KLV format as GuC, and contains metadata used for
+ * checking migration data compatibility.
+ *
+ * Return: 0 on success, -errno on failure
+ */
+int xe_sriov_pf_migration_data_process_desc(struct xe_device *xe, unsigned int vfid,
+					    struct xe_sriov_pf_migration_data *data)
+{
+	u32 num_dwords = data->size / sizeof(u32);
+	u32 *klvs = data->vaddr;
+
+	xe_assert(xe, data->type == XE_SRIOV_MIG_DATA_DESCRIPTOR);
+	if (data->size % sizeof(u32) != 0)
+		return -EINVAL;
+	if (data->size != num_dwords * sizeof(u32))
+		return -EINVAL;
+
+	while (num_dwords >= GUC_KLV_LEN_MIN) {
+		u32 key = FIELD_GET(GUC_KLV_0_KEY, klvs[0]);
+		u32 len = FIELD_GET(GUC_KLV_0_LEN, klvs[0]);
+
+		klvs += GUC_KLV_LEN_MIN;
+		num_dwords -= GUC_KLV_LEN_MIN;
+
+		switch (key) {
+		case MIGRATION_KLV_DEVICE_DEVID_KEY:
+			if (*klvs != xe->info.devid) {
+				xe_sriov_info(xe,
+					      "Aborting migration, devid mismatch %#04x!=%#04x\n",
+					      *klvs, xe->info.devid);
+				return -ENODEV;
+			}
+			break;
+		case MIGRATION_KLV_DEVICE_REVID_KEY:
+			if (*klvs != xe->info.revid) {
+				xe_sriov_info(xe,
+					      "Aborting migration, revid mismatch %#04x!=%#04x\n",
+					      *klvs, xe->info.revid);
+				return -ENODEV;
+			}
+			break;
+		default:
+			xe_sriov_dbg(xe,
+				     "Unknown migration descriptor key %#06x - skipping\n", key);
+			break;
+		}
+
+		if (len > num_dwords)
+			return -EINVAL;
+
+		klvs += len;
+		num_dwords -= len;
+	}
+
+	return 0;
+}
+
 static void pf_pending_init(struct xe_device *xe, unsigned int vfid)
 {
 	struct xe_sriov_pf_migration_data **data = pf_pick_pending(xe, vfid);
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.h b/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.h
index 5b96c7f224002..7cfd61005c00f 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.h
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration_data.h
@@ -32,6 +32,8 @@ ssize_t xe_sriov_pf_migration_data_read(struct xe_device *xe, unsigned int vfid,
 					char __user *buf, size_t len);
 ssize_t xe_sriov_pf_migration_data_write(struct xe_device *xe, unsigned int vfid,
 					 const char __user *buf, size_t len);
+int xe_sriov_pf_migration_data_process_desc(struct xe_device *xe, unsigned int vfid,
+					    struct xe_sriov_pf_migration_data *data);
 int xe_sriov_pf_migration_data_save_init(struct xe_device *xe, unsigned int vfid);
 
 #endif
-- 
2.50.1


