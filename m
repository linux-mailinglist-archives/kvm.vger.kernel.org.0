Return-Path: <kvm+bounces-49811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 12019ADE330
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 07:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A834817B133
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 05:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 377E5207A32;
	Wed, 18 Jun 2025 05:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="csBaApCf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63621EF39F;
	Wed, 18 Jun 2025 05:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225875; cv=fail; b=BFMJ4ygDqRj6Yl+i6OZ65m6QZwnqXNvhCl8iMCDO9Nxinn6ncfYCxzRwkzlU8O5ozv8doDR5ypFiGrfS7xP99BXKYWplrdE/EJ1mkI9TiL1kCb8/IGOZmN8u2S2vaJQMHvQDWe+/2fudclMfMFXt52DWwDpZfL+djE3INHTkL8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225875; c=relaxed/simple;
	bh=SGYQZjG92jQIQrOMhO/LYDyPT55LcjHMYf5FswlAS9c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OC9bk0uiNIaPOGJPypE+/EmULArb5GwcnG63FDOh+JOx1cfzYPC7xoQY7l2SlykmvpHzCa8l/ZtYVbsV95DR80hZltlobwpOQvUYawUK99man/NzMf6t4p2kOxZBYKi/CDpHlxwsdWZXP+6Bzr6BLgXf+gOCF6xnH1qSVHoXuds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=csBaApCf; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750225874; x=1781761874;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SGYQZjG92jQIQrOMhO/LYDyPT55LcjHMYf5FswlAS9c=;
  b=csBaApCfw1s62uhxQ9nHjvfCk7BkzpPZIvGKielCyk8YnmRFmIZ5Dm8v
   JRvMO67bfUUvj2zvz3VJ1uDswuc1y3zyzH56fnvSVIvpqJvFRTAQWD3bl
   L0UIrZuzB+0Spjs1SSvmM9uC9zCGWLuUkXBL++QzxVvrFifHXDEt0AGvK
   NCNdreCIxQwBeurERxh6t1Kjpzol0TdQ6yHpp3/3wwZcQWwHkzoQxCcU3
   /kn7GzDjwW43fQ/TcqnghemqfLKZOsVnEW82kAqdfcAKSZ0JAaacZgMpU
   l+pL6Un0OzVHiosxZ85XefZpqxxJBUD/qtmjBtVaZkejRenqnklyd5Fdb
   Q==;
X-CSE-ConnectionGUID: Uti4LDoSQAeIAD2O6OyeSQ==
X-CSE-MsgGUID: xqMREsVvSCG32eZG3Z0a8A==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="52568779"
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="52568779"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 22:51:12 -0700
X-CSE-ConnectionGUID: /NpxdvoPSlyDVWOnX09Snw==
X-CSE-MsgGUID: q+NuqHNBS2+0UHSwhCVNWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,245,1744095600"; 
   d="scan'208";a="154787039"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 22:51:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 22:51:07 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 22:51:07 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.65)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 22:51:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n4dT30rY/vrNq1QRWPbxCruADR8I2//SaD0MEekGVIgtHk5pxc/FriwPHFlI3GEcTJYL76+JGLfskKx1XG7l66TPPP9MFOPSA+HWSjc/bOhxEpbFVMQbrCBBhpm2MLMjKPbcPyWstHni+8WTvqaunltJqfZsZGIHz5zwrpuVmjxe8QcHWcnvrtk+FGx7FBlBH6PgOvN4GcBQJ190FQ3aw1DYaROjREbqKBVUxMJKmPEutEfhjyRV3ezQNe4jps3jzQyMSIL51ieu/6GlwuZdHJfAJILpoSRQoyrzW3CqZrBzv+Yfd0DBi2Nem2lKnMj+zFO5Rpwgz/FFoywx+v0ACQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/vsSLgZ0x7kvbYu70a8dGQaTj9reeeOkXxAffoKzOM=;
 b=Ixc4sh0a9YtWSyqlN9TRTwzNSSc2YrzSeFb5wiBiLj99KQ8FKqwkpHqdcc++r+/E2+SwI2vp76761lqUz3BO1RFvLx6k5nWvU3fTpHVU6ZfYZ1zZC2O639ypkKW8vMMErGd8dUEWtPaiP6jalM3j+oDT1lG0Ntk2NgjSxEBujpQfwpIeBKtpNas+a78GGbTAwJpyXW1fpHr3fCbn9wWxASRFAinDhsyhFgY7kJxjGwl68zrHwwJiWQ6g6vd4NxZRCbsi/XnBEt4qdIxsCdvGUTJqNJ2onJ68u3S3tAXDN5bhJkb/ykLKV9iWZh6epXqVF55JvpJ5z3wCtv6w43MxSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3206.namprd11.prod.outlook.com (2603:10b6:a03:78::27)
 by DS7PR11MB7739.namprd11.prod.outlook.com (2603:10b6:8:e0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Wed, 18 Jun
 2025 05:50:20 +0000
Received: from BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d]) by BYAPR11MB3206.namprd11.prod.outlook.com
 ([fe80::4001:1e6c:6f8d:469d%4]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 05:50:19 +0000
Message-ID: <e86aa631-bedd-44b4-b95a-9e941d14b059@intel.com>
Date: Wed, 18 Jun 2025 08:50:04 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
To: Vishal Annapurve <vannapurve@google.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kirill.shutemov@linux.intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<isaku.yamahata@intel.com>, <linux-kernel@vger.kernel.org>,
	<yan.y.zhao@intel.com>, <chao.gao@intel.com>
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <20250611095158.19398-2-adrian.hunter@intel.com>
 <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <CAGtprH_cpbPLvW2rSc2o7BsYWYZKNR6QAEsA4X-X77=2A7s=yg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DU2PR04CA0047.eurprd04.prod.outlook.com
 (2603:10a6:10:234::22) To BYAPR11MB3206.namprd11.prod.outlook.com
 (2603:10b6:a03:78::27)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3206:EE_|DS7PR11MB7739:EE_
X-MS-Office365-Filtering-Correlation-Id: 611afcff-8a9a-423c-0bec-08ddae2c0221
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SXZYNlpLYlhkSmVDTFlLWXFnK2hBMUxwTHBoYWFQbEFkVU8vZW42RU5GVWNY?=
 =?utf-8?B?aDI2ajVGNnRwazZwVXZxcmMvT0FHUDFaVFltK3g2ODNuK3BUN0NoTXl2TDkv?=
 =?utf-8?B?bXk1eWhsYms5bEVnbzlrdTkzVHh5TEUvaVR6YXl0VXFIMFQxSld6YnA3YkFR?=
 =?utf-8?B?OGk5OU1pY2hRNmd3YzdrV1lEZHlwSHlBc1pCMXg4ek5PSVZsQ1l1eXQ5amhk?=
 =?utf-8?B?dW9iY0xzRGJ3MVRLcStreXZqR3BvZEpMd1U3TEVqd3RUMUNNR0cwaSs0TW1x?=
 =?utf-8?B?K0swa0lxUzc5UDE1OWRlV3h1K2g0VERIcDJiVnI1OEJOMkIybUd6Wjh4SGpI?=
 =?utf-8?B?SlYvUk41bnRUaDRmZmpaQi84cUYyUTZ5Lys5OWQ5R2RGTmN2dHpYZmJld0o5?=
 =?utf-8?B?dmxXVHNCTERkdmJ1S0JLWTF0VytrTmtLc2c3K1R2ZHI0STFOK3NkbktyWkw5?=
 =?utf-8?B?cm9WTEdmY0k5YlRIUFNPNVdpbFFoYzYzYzZxRyszdnlmeHFTckdKTDRxbmlr?=
 =?utf-8?B?ck9IelRzaEtweU1SdnhLSElZRmYxSEdYTU00Rm5kRXNmNDZtYXAyZVE0ZFo5?=
 =?utf-8?B?d3VnUVZtSmdjc25tK2l4d3kyN2t4TXk3V1BLRHI4SXBzaGxTV1JBb2xVK2da?=
 =?utf-8?B?UUliUm1IY0VScnNUMkY2dWdzRE54dzBMbjVPRnE0TkJEd012VjR4ZWNvb1lt?=
 =?utf-8?B?OTFRd2g5Z09kTEdIUXRYL0F5blQ0emlobVNRVXBLeVhmS0RvTDJZbU9zQkhy?=
 =?utf-8?B?bVFoSG5Sc0s2ZFNsanRoTkY0d0Q5MUlxREpFTTk1WnBqcEdtdFV0WDg3NXZi?=
 =?utf-8?B?ZG5TVXhVeWNLWHR0STdVcDdzZU1NbUY4TjBycVVZeW1uTHh6RDhieWVkRUVu?=
 =?utf-8?B?bDduL25TM2dIVVJaSU5IdFNRSnRzMnVXK3dOdTJ1aVIvOWp1SW9JMDg3c2wx?=
 =?utf-8?B?SnBxSGRxTXFGMDl1cmNMdTJKR3EwQ2JkSHNqMUtSN1gyY3B6dzNXYmVTZWFu?=
 =?utf-8?B?V2RacEVFaXdEVFc1dGNUNzFoUkNWY1A2VERJSExtNUdpV0dxa2hNZytCNEJG?=
 =?utf-8?B?eXFZQk4rQURKcmszUUovcUswSGlZYXR5bndwK1ZGSnF5Q09HcUVQY0VENmIz?=
 =?utf-8?B?M0d0UmhVbHhkNHREaHozZWx3dUZjK1RGUUNUbVpDaXFlZVhOYnp4V3VpUm1B?=
 =?utf-8?B?c0NUbzljQTBmWG5TWS9Kc1M5ejBCN2FNU3ljbDlmNXhCciswMWp0RFRUdVNY?=
 =?utf-8?B?WE1WUm9YazlGRi9qeHIyYUNPaDMwbDVxZGNqR3FCUkk4RXJBMkpZMXFlazVq?=
 =?utf-8?B?MEZPOTlFRXRhNkQrK0VjbXVvMkZUQ2doaWw1S04remxLazNGTmdYc3owQU9P?=
 =?utf-8?B?dXVzd05iUS9pMGV1eVJvZ3BGYmdCSGxsMmRBYTVCZWJMUmZ0MklmTVkyak0v?=
 =?utf-8?B?SisvbjhLOW9jTnY0U3J6ek04bUVFUFIxU3RHdGlEc3RFaGhOWnVnekdmR3hr?=
 =?utf-8?B?UVRqOEtudW1NZm9YUUx1WDlHRkN0bWcwZmIzR3NNY3oxeGtwczh2Ull3NDRT?=
 =?utf-8?B?SmJKV25KT1ZVK0JnTmlYVWI4YldYWUdTVVp3bTBuK21YQXY5d0pkc0VNWHNt?=
 =?utf-8?B?S005VFkvQ29vbU5TQmxuNWs0WU5zVDdNSnlCR3VIaXhSV3ZQazlBUUNNSm1l?=
 =?utf-8?B?Mi9EOFlXNk14NlZZcUdVaXlDQm1BN3dFRTB6Sld6K0N1M3VUYm9rVExZeUlH?=
 =?utf-8?B?aUlHLzg2RnJJVVJYbmxpVkZaS3dqMTE0OURHY0xwbDM1OG1lUGVZZGtyT2pa?=
 =?utf-8?B?MWJ0RU5NTjhTVnlXdG9ZQUJxOGxKa0RkM0hRME1OUUdDanMyV2dNZ1NZZUlx?=
 =?utf-8?Q?HA10FU1mae/o2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3206.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZnZOU0Fub3RhektsMytORWlWM29YR0p5bVlhSXhmSy8vSSt3K3FXVHlqcWRJ?=
 =?utf-8?B?Z3BGYnJIZCtJVVluSG5lL2RhK1c5UWZVa01rbUJhRDRMaFgwOEMxSTd4cFVz?=
 =?utf-8?B?UkE0T0pUaU5TNW41SlhhcE82MFpYckhTNWNvV003NjZ2UXFaNi9GRWZURmVq?=
 =?utf-8?B?VG44M0ZkaHNxYmJSb0JnTGU2UjZOVE8rdVB5cWJ0ZkFhbFNQMzR6dkx4RzN5?=
 =?utf-8?B?a3czcGxuc0VyZGJZeDViYytJWlloM0xZNitWYzJtdldvZ2szcnd4SjdjQUFk?=
 =?utf-8?B?UXBDU29aQXM4S0liMUJpVnZ3T1dPSTdBZmRtWDhxZGxlU0VyTHZaTTFwMUdY?=
 =?utf-8?B?T0tia3czRTA1RWE3d0EyeklnVDZMQmhaWU4xRVUwa3Mxb1gvczJpUE8zbmtE?=
 =?utf-8?B?SEJYcEZjdjU5d1hqc1FEOWt6YXRUcXZyYVRQN1BJMDFBOW9IWVdiejlkcEdt?=
 =?utf-8?B?UUdtMGxkSmZDWndIc0hkRnRGTHNBTDVFR2o0cStzS1g5SkVvcFYxZWlNYjBO?=
 =?utf-8?B?WXdybC95c3ptbVd0MDFpNnZONWJxM2tFVVZ6bHpuUy9SSTlzYnovSlJOTEo3?=
 =?utf-8?B?ZWtOS3JZUFprby92RldNT3NrK3RDWEtGUmlwY005dnEzOFY2RVIzTERFRDlT?=
 =?utf-8?B?Z0g5UEVRenB2NGtueXpuaTdmRDRPTDgwSDBsbG5iVEhsVWxwcWVaUkJQTmNq?=
 =?utf-8?B?K3phUStCb0F3Rk83Yjdlc3ljenhhZUlTb3Rtb0Q2RGtkbkkvc05PZFlCc0FI?=
 =?utf-8?B?QjdIL0lRQlFkR0dPQ2NUVkNEQUs0eEh1eVMvNnVUWnd5ajFMc2pmY0p6SjlC?=
 =?utf-8?B?azlYdHVWeC9yM1FtbEFuUjFrZ2k5T0YwaGpuS2MxUTFiRHlYREtSSEI1bngx?=
 =?utf-8?B?MDFscllqeGRjSUttejd5WlYwbjZ4RUVlUGQ0T3krK2xLemo2V0VQWkIxbW5m?=
 =?utf-8?B?NlRkRHplNVYrak45d0wxL2dzYjN5YUNrNW9SVUFiMDk1dzcyOXpMbW1mZ1FX?=
 =?utf-8?B?QXhJcGIzeVFzVk9uMWVFVjE2SzB5WnY3VjVNMXpUbjJNNFFvMFFXaitGeXcx?=
 =?utf-8?B?K2lUbmxWR1BZdTUxbGwrdGFPUks5Z1RLYU9aRWxiT0UxZ0RPWlp6bDBFeVhm?=
 =?utf-8?B?WFVhckZNekpxOERMSWFNVzZZS3RpZlVmRzhKRFIzUkE3SEd2R2lnazVKRXBV?=
 =?utf-8?B?bHBNU3VWQ2xOYllUV0p4VU9XbWtVeHE5VVh3U3hZWm5kV1BmZmFHeTBWQjhh?=
 =?utf-8?B?UDA3b2lHY3pRZ0FBWUNJNUVLRXpkVWVJUmlLMnFZOHFkcWVvcjRONll6R0lN?=
 =?utf-8?B?RzhISTBDbDFNTlVYT0ZUeDh2Q0p5VHhUbjR3cXRGVkZhM2d2TlNycWdmWDJ5?=
 =?utf-8?B?U3lsR0QwamxmMmFjSEJZcHZ6by8yMC9jRUtpMWtoaG93OFVGbW5IZFlNbEF1?=
 =?utf-8?B?Y0YwcHl1NjdGQ0pMVGoxTzZvRW9QQUZwVnJVaDRndmhzaXJwc2lDa3BqRU9V?=
 =?utf-8?B?cUpXcFliQmJMc3hIQkhjNkNzK1p6M0NEYTZMRXZ6NXhHWGFGVlREQWtkZlly?=
 =?utf-8?B?TzB1emtZRm03dU5ub0MxWHE0d0F0emNzU2dQOU5LeDl0RFJGeDJkbE1qNERG?=
 =?utf-8?B?TEUxd1h4NWc2Y1Y4TTVnRDFEMHp2dHFTWUt3ZzRIcGU2eCtCV2l6NjRJU1J1?=
 =?utf-8?B?akRuSEM2MStmMmtBUzA2cUZnMnpFQ01ldjRTMmpmbkYwdGJIYTlyemZBYVph?=
 =?utf-8?B?N2kyTzkzbHpycHNZc0xtLzdtZC8waEZGREN2Y0JqWkZkY2VLeVplMDdYMENm?=
 =?utf-8?B?U01zNWlnM2hLb0xub1R4aFA5ajUxTnBqdkNoc2lQcUJDUzE0NG5zZTlNazJJ?=
 =?utf-8?B?eERYekZ1emRBbzVrckg1MCtGbGYrbmIxMzBjQWtOaXFZcjNxNER0NC9UWmNr?=
 =?utf-8?B?dlpQU3RSbkVETmhYUFVrbFNhV2NPcWNsRmk4TFNaaXRTWE11d1JvelVyNGFt?=
 =?utf-8?B?TTcvNmJ0eXdUbExvZDd2SmQ0U1BoeUFnTVhEbm9CTFJHKzlIRDh0Vlh4U2xi?=
 =?utf-8?B?WUtEVjVvVzJsL25WU3p6ajFUOTl5Nkt1RW4vK0xNZ0FNdTd1d216c0N6aVB2?=
 =?utf-8?B?U0JZdkhCeVN1ZXpJRFZZZ2h4bHQzeFZMeHMxVHhnRHc4ZTRvSzlUTS96V1c5?=
 =?utf-8?B?dlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 611afcff-8a9a-423c-0bec-08ddae2c0221
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3206.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2025 05:50:19.7396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLbEcTWoL7us0tzfz/S5Afoy5kMDfltEBwSvYIWKduS9SDr3RQOgR7ZyKRFxQesPwb+4CLXKLwVPZLIQ1jmqiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7739
X-OriginatorOrg: intel.com

On 16/06/2025 06:40, Vishal Annapurve wrote:
> On Wed, Jun 11, 2025 at 2:52 AM Adrian Hunter <adrian.hunter@intel.com> wrote:
>>
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Add sub-ioctl KVM_TDX_TERMINATE_VM to release the HKID prior to shutdown,
>> which enables more efficient reclaim of private memory.
>>
>> Private memory is removed from MMU/TDP when guest_memfds are closed. If
>> the HKID has not been released, the TDX VM is still in RUNNABLE state,
>> so pages must be removed using "Dynamic Page Removal" procedure (refer
>> TDX Module Base spec) which involves a number of steps:
>>         Block further address translation
>>         Exit each VCPU
>>         Clear Secure EPT entry
>>         Flush/write-back/invalidate relevant caches
>>
>> However, when the HKID is released, the TDX VM moves to TD_TEARDOWN state
>> where all TDX VM pages are effectively unmapped, so pages can be reclaimed
>> directly.
>>
>> Reclaiming TD Pages in TD_TEARDOWN State was seen to decrease the total
>> reclaim time.  For example:
>>
>>         VCPUs   Size (GB)       Before (secs)   After (secs)
>>          4       18               72             24
>>         32      107              517            134
>>         64      400             5539            467
>>
>> Link: https://lore.kernel.org/r/Z-V0qyTn2bXdrPF7@google.com
>> Link: https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>
>>
>> Changes in V4:
>>
>>         Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>>         Use KVM_BUG_ON() instead of WARN_ON().
>>         Correct kvm_trylock_all_vcpus() return value.
>>
>> Changes in V3:
>>
>>         Remove KVM_BUG_ON() from tdx_mmu_release_hkid() because it would
>>         trigger on the error path from __tdx_td_init()
>>
>>         Put cpus_read_lock() handling back into tdx_mmu_release_hkid()
>>
>>         Handle KVM_TDX_TERMINATE_VM in the switch statement, i.e. let
>>         tdx_vm_ioctl() deal with kvm->lock
>> ....
>>
>> +static int tdx_terminate_vm(struct kvm *kvm)
>> +{
>> +       if (kvm_trylock_all_vcpus(kvm))
>> +               return -EBUSY;
>> +
>> +       kvm_vm_dead(kvm);
> 
> With this no more VM ioctls can be issued on this instance. How would
> userspace VMM clean up the memslots? Is the expectation that
> guest_memfd and VM fds are closed to actually reclaim the memory?

Yes

> 
> Ability to clean up memslots from userspace without closing
> VM/guest_memfd handles is useful to keep reusing the same guest_memfds
> for the next boot iteration of the VM in case of reboot.

TD lifecycle does not include reboot.  In other words, reboot is
done by shutting down the TD and then starting again with a new TD.

AFAIK it is not currently possible to shut down without closing
guest_memfds since the guest_memfd holds a reference (users_count)
to struct kvm, and destruction begins when users_count hits zero.


