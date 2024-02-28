Return-Path: <kvm+bounces-10207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C5F86A7B5
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 05:56:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77AFA1F2335C
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 04:56:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0F620DF4;
	Wed, 28 Feb 2024 04:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E3Y1+11H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6734920B17;
	Wed, 28 Feb 2024 04:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709096159; cv=fail; b=gCuHLfUiLo6LCkVeZHGeLE811IKVCDmViQdI5y+i+MAeTGmP243m/xAbDdMjYTMShUwSf21+4LnkTTFkxcCJs1uGBToEK+i1m4CzcAIcSCqh54ooTAHnbsQow7MGBwWZB5t/aLl+JObfmaDklgsoStVKHwVyNk2MY5zTLrh/oAM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709096159; c=relaxed/simple;
	bh=ALLOrjMYXnXvZaUqYcBBxGGTFpWW0jrV1EYybAasG4w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aqyfucxkab5mILxHOF84iKVUSSm1GiwsnY46gnVyDMBRT4xRAUqWeRbl5t/xU4Qfj5RWFbLqXbY3AToY1W2RJXbkQa0tM2/3tG1svtzFnWwf5vf7xfogPilgZcCemcni9snEPo9wmDa+64UuPVjb4ls+2jApN997m6nSRkcTNDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E3Y1+11H; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709096157; x=1740632157;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ALLOrjMYXnXvZaUqYcBBxGGTFpWW0jrV1EYybAasG4w=;
  b=E3Y1+11HLofKg8gim7s81XEHxlpkmL8tzNiCV51ogxGpr3te2yl1tQGm
   qf/53XcuQH3iBV+hmUySxE16BUX1HDp13CDobL3JvHw9NBFyFc4kije1S
   5tCHWJXnkrR1QhW9n5y//CoF8B5EX3UafeYqe9q6xXpKW69pfYdvpS2UF
   aOqGUd4gchxX/xobCYCpn31u+F6rRzhECZK8Y2ssToYrbkBVNOkwycLZY
   fk31ZeRmVGEMjjSkQUmFPh//7DerCU1QJ+ES2an4w+6j90UZyF2EC5+mu
   FYy9xwMCVTjale7s1hgsrPf4wQgGjk5nXBpQ64oPSPE0ZnNk6x/OoCVe8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="3322664"
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="3322664"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 20:55:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,189,1705392000"; 
   d="scan'208";a="11858403"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Feb 2024 20:55:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 20:55:55 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Feb 2024 20:55:55 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 27 Feb 2024 20:55:55 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 27 Feb 2024 20:55:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OwjsUBqTaOWBHCOBLqqydyNrd7n5R9kPwqzuiIPU+9KzCQu10SD60wp3Hh4lFQyiLGAgjNhmhnDOxBzNckMp7IusS5OL2yLKqF9BVUyRGRupWfE857EJsRLt12XyAyzjLcBJbKs1NQDB1P3gXpTM0fGStmN+6EMm8f9PkCO4UrWu5IJzCQKmd+rfUHt4jFzck86C/r7ydfT/+m3j2sU3jCl+W24ArpquO51UDYddhu4x81NVUyHo6R4SeT8MvG6n44Ty0rB4xvJH/aX3nngz5ZO2cGadLmWfHx5sml/Gfj7Kasl/LsaTUm1Enyy6b5LEMp1/jcSoB7DI95o3wPNsSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ALLOrjMYXnXvZaUqYcBBxGGTFpWW0jrV1EYybAasG4w=;
 b=YC3PmIe+2vf40pZSRHCQS9P6vZC1cCbokYSLlZvX/mcvBzUkmx3YcrQalNbj+23YG+TDClOpHneOPF+4TsLq9HVSzzwj87BGiaSTsE6HCTuHM4NMq8OH0DQOBFfCOweb9191YNYMQOvy9hAST6dB2UqdFZK7iASLd44NZggyusmLELH/6rdbbuSqL1wKt/1P/+o0zUaqGBbidMd36hDQRdQwFtmwNWbXuU/FD1lA8ydXqTDSq3QAiHSLOkBxzroI1bX5h9v1/vWM8ssfxyTDJyhj8M9wUiwZgDoJW3lf1oYjzdExK+NY5bxAmdrfsAEUWd/rNboHCoUGG/Ld5Gf92A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ0PR11MB4781.namprd11.prod.outlook.com (2603:10b6:a03:2d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.25; Wed, 28 Feb
 2024 04:55:52 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b0e3:e5b2:ab34:ff80%7]) with mapi id 15.20.7339.024; Wed, 28 Feb 2024
 04:55:52 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
Subject: RE: [PATCH v2 vfio 2/2] vfio/pds: Refactor/simplify reset logic
Thread-Topic: [PATCH v2 vfio 2/2] vfio/pds: Refactor/simplify reset logic
Thread-Index: AQHaad2mmn7QJGU1A0GQRc8NjAd5FbEfMPnA
Date: Wed, 28 Feb 2024 04:55:52 +0000
Message-ID: <BN9PR11MB5276CD4BF00814779A22CF1F8C582@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
 <20240228003205.47311-3-brett.creeley@amd.com>
In-Reply-To: <20240228003205.47311-3-brett.creeley@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ0PR11MB4781:EE_
x-ms-office365-filtering-correlation-id: c2b2409e-57ca-44c8-b46f-08dc38198a63
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YMJ1ZjpHIoY67Zq2lLinpjBJ6wzU5lTRnYU+zIjO8xpY3WsrWJWBZmiqTESYvMKEGMXUE9/ok2UyqQz1BG7fAKY2Sa2fo1W2qIEa+o+dYQ5F6Cemj1+q4vHis+ccsXwYifWO7wTWV4gHIjm0BtUknzz5audcnDZ+TSKAXoN4/iuymbSj/kS7+74RLC/NXeWx1UvVnbCOI5JM8MQI9V2WZ8o13wrfKtHT/TnGXw/8MEK7LauZClxYEC4uOdYS1dPRRl3tdJkQNMnlFdxmWRMKybKi8YA+4XHRroJBbQD1N5FpHeOdW4XARUqc6e8qXYyQ3TpsxQAIFjd+EnYFDqWATI+IoCDMeK+Oi4kUW2e9BvNQRDLZ7ODOg10DXLiuX8AIGTcRTcAwBOy0ATU0GG8zOmrH+wS7v7jphg3QR/e5eIfBmLpyHaJHKqFFLNprl0XrIWYR9SeKShkrtRozuetgOI4PpvgTgwbAu2xdXjA96+HQe9aHjyOewZqoMRbA1bsblCneipuy4nIFZVoxCxLyauFRa497Y5H5pGxU1um6UuKHCQOVt+MIYV6Hwm03vf4ZThk96ZiPdF/Idwqnx80ls+FMhMrYE4lEIYOM/VrmgJQW62P0Pyv8EJud85tDbRrHAPnm+P1XMSk7X6XNcbqCk5vS6nZxPjG6T41IFkX+26abjovqpVhxRe1IhIczXdFCkvpUyFIa47hH9Vy+I6dVQNt+CPvZmk6q36is69V9ziI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sh9B2D54eZycLT7X8P+d67tkVORBPSxvaE3lDZLqhT/t05zH9XQGAiHSArXP?=
 =?us-ascii?Q?494d3hqr2zvSoKxzBSz5SLs4+NyTAsTnKvE/nKpp8Xdi2d8BmTSFo3DepXBJ?=
 =?us-ascii?Q?xnFXA70OD56yBIRU5iYx59lPcheGjtgccUdd1157wJA7P6vsgadGsABWsz6V?=
 =?us-ascii?Q?WY5kkx9zFV5UGInDY4R+aMSb7aU9o0fgxfsnalNXOuH7ZQbij6UWi/wzx4sE?=
 =?us-ascii?Q?md9SHUvkYZFv4k9TVtvpJQhVAxIpCsUB+hsuzfrhe3qiTLlRv+SaH0owjhdP?=
 =?us-ascii?Q?NEE+Ufvk02Qd/pPuc92ARImiYfAukvWejRoiUGM5euVc9RLHYcD9oIUiaPnJ?=
 =?us-ascii?Q?khkyFExVcId4OXoEcDzx7XVJZuN6hEIuDvDhl6apytZNMo4g7RRODsggBwmt?=
 =?us-ascii?Q?BmHE7ym0uVGXnuHrzrKbYnuog+GZQcgI0CmtvIPmqXp08M2Dwj39OXiyHUtj?=
 =?us-ascii?Q?sGrEZ3OUSf88yyWBWBujDlVASt/7TH33L6fqO2OLsUIhaUMrSeizRgOjkfki?=
 =?us-ascii?Q?dAJydH8FTXMgL6XqEWTbkHRZfHxI70uVskhh9uRjOl+9qaraeKkT5NRB0DzE?=
 =?us-ascii?Q?FhOe7T70evRsDVpUW4ZQNJSJf4T2A3zRWZo98Smwe6iwEI2x8FNHE6Zvj+BV?=
 =?us-ascii?Q?h42EsW0RdpVS0QBBkYlpYBulOJRsyGr80ofIK5sX8oW3P7WwtnCQAAaymyCx?=
 =?us-ascii?Q?uDNNZJTw2vMJvuNpuEVCSN7uHB6IUJULDHEbPsLgCXbhAaWnt2cDyDKa6Rhu?=
 =?us-ascii?Q?7AIY/UvRDDRkyngexuY+DfQpEjZ0wnFnDQgmeJgVUaZpsa0wjGTM0LzQWleS?=
 =?us-ascii?Q?YEnGDKhNlzxRhYDKrGeGtnspJkxv5rVvwpKQ0niudjedKh1THO79qzt+YtTt?=
 =?us-ascii?Q?ZtfaRZaw7MXKG86k8xiqGV8oJnBVhc3iNZgvwjDtJHD9+7AyKYPIGohrZ9QC?=
 =?us-ascii?Q?w8vGKHHVEK4p8Mmm4Eu2+ZAOScwlERL9h+kFNijYKtKUfy2geGvqp5pFxkyS?=
 =?us-ascii?Q?ABiM2OreNpgcUCQBJI5E60QRLRlvrDo9FLoH68s5BDzhqPjyU9UEGXhZuP3Q?=
 =?us-ascii?Q?e1D3b5WBnz1iOaU9vXm6Wrzj0yPGyVzSquK2sUuBKoT4E9DSpMhxS9x5Ek/X?=
 =?us-ascii?Q?VfmJ3XFX/eVXBVr9PAwWlpBI/GFZJ9EaM9zHlw4BoDAK/qY0FSqSEjssL+H9?=
 =?us-ascii?Q?7mTYKc0ZWf9ASOYWO7MKYMHvKxPniyyUL37LiDTEKzL0UBsp2OPZlqvu4M4+?=
 =?us-ascii?Q?eG0n/W6gdQUIA0bmRbD1ZgGMLKyQEVC/WW4pXcQUEVrpnESQWU2OlswPi7D6?=
 =?us-ascii?Q?obkFlW88sW0iUmaNW8yDet6Z7jW+lYqHxAVipAbHxqSD3ymuoapFpvf3nHWn?=
 =?us-ascii?Q?ipmUP3VwanlEMsl3qMRlv/4DKbM1mkMI/nWHdJSTu/zePfV4/RYNMbWaBtJd?=
 =?us-ascii?Q?RoYXJd28/smUz9miETH/b89wFOpl+T/BpY9+WBNcQ9NT7Pv7hnAnlmtlQiYY?=
 =?us-ascii?Q?gsV+qAH6yO+o3UQUMtpD5B/cpi+4Oe5KaSg6jMZsaM+UW2Mr+bLEPKN8Bsv8?=
 =?us-ascii?Q?bpnwcctD3hSIotng5hJcYqmNHFW7DlNnLVJpLCnH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2b2409e-57ca-44c8-b46f-08dc38198a63
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2024 04:55:52.6515
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Et5WquG9Fcqna+C82BLEXxn2QhujAFM3kZtl7Wec4h7FTDlQkFXJRo+AOe6FKvuh0JJu5M3ok+0sCR3R0RgmWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4781
X-OriginatorOrg: intel.com

> From: Brett Creeley <brett.creeley@amd.com>
> Sent: Wednesday, February 28, 2024 8:32 AM
>=20
> The current logic for handling resets is more complicated than it needs
> to be. The deferred_reset flag is used to indicate a reset is needed
> and the deferred_reset_state is the requested, post-reset, state. The
> source of the requested reset isn't immediately obvious. Improve
> readability by replacing deferred_reset_state with deferred_reset_type,
> which can be either PDS_VFIO_DEVICE_RESET (initiated/requested by the
> DSC) or PDS_VFIO_HOST_RESET (initiated/requested by the VMM).
>=20
> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

