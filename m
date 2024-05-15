Return-Path: <kvm+bounces-17465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815158C6D6C
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 22:53:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33E792836AB
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 20:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D51CF15B11F;
	Wed, 15 May 2024 20:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P87C1+pk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4E93BBEA;
	Wed, 15 May 2024 20:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715806425; cv=fail; b=eTM1+gtLFWY5hWxGhu6B4WHjeiTH8bM2vLy82zjB5YPaN8xrZyNLPr+xdgxuYp0VEpIgTA0T5HNS5RJ5YTCZwVGLyaBds1uQnNWasXI3cY4+R04eT4KGke1piQ8ECmFiCwM+XiXBgZgPU7IIU1C6w5JLDc964T+wmVjby0UcEB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715806425; c=relaxed/simple;
	bh=9tWFO05RlUmHC4WBitD8S+7IZeJ2kK7PyWqEZronTok=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oWxilOs3uZ6I2VQFuFGxgn6Ffmo7qbFcV9UTas21u7nxeTA5gkykIsdHnhF1eqGFLYxgD7eu1C7N5sUWnsHmB68JB3UBj57pUaQw8/sfl+Wc0QYHKk2lEtXXFPiiJxWzaMnXQWE9Hj7yEY+3U3HNH38z/c1kCnEOFmGMqsYViNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P87C1+pk; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715806423; x=1747342423;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9tWFO05RlUmHC4WBitD8S+7IZeJ2kK7PyWqEZronTok=;
  b=P87C1+pkoJMHD/mVt68afDXwLGQFH0W6TkBcyDxIGcTvMdje1A7Oytfs
   9BCoc9HVhTv824pXXQ7IaIlY4eY1vXnVAvJ5634IxhAUMjevVHs/pcSRl
   JVh0mVDJuFyf8oaHTkGQV1FWEngNDltd5y0vTRIUnmdCAD7R9f5xLv/Hd
   1Kc4vkHcV/yjIWQCmTPU5pmOD7ZEeKw0WH3nAKGbB1BUewk/y4rdU2yuP
   9vWsROGKgBLkG4TV1cBpMNZeEp/zpgmd2qYCmJ8UNebMedpV9UoEjKfmf
   k02GIBfLVDqNx1uzepY1kPONU1wPO/wLA+hbnAjiKoRBYW0x6u85rA0XI
   Q==;
X-CSE-ConnectionGUID: LQyH5WcKTlmUrz+3h28chg==
X-CSE-MsgGUID: XFrc0siuRU24/U3xuPt+KQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22556428"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="22556428"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 13:53:30 -0700
X-CSE-ConnectionGUID: EvSZkAS3TM6ttZq6NGyfBg==
X-CSE-MsgGUID: 38mIoU8ISh6wDsJI4PaVaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35716365"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 13:53:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 13:53:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 13:53:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 13:53:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 13:53:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZoXmgCIHl3Y5r6hgAJqw6XrulkwBi/kPbC/7YSQOc6cbNOs0VH1462QrF738EOh5o13qC2PvQ82P4q9J3MzqWDQz0f3/OFfNT6EtaNkm1i4RhOECptXeJaGQPAxK5Ll1nnKK+8JUdtRRm6DgVD6iJ2w8xBUcypG71Wuke0V6dzg0eX0cgEi8f2PZIO2Q+FTEIyJeUbNaxMOX/yk3tlZpb+S5byPQ59ecQi2NpJf0iuCliZM1Oy1cgFSU72WsVNMf5WPH7C//YiwoBx4eJ8z3PjnoE6J3HyyyRtcSspuyWZ/cbam8ElEaCqJwLbldLWsI1LhGYlPj/AelK4Bc9ElrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9tWFO05RlUmHC4WBitD8S+7IZeJ2kK7PyWqEZronTok=;
 b=JJI3WKDnK4LhXlaxtfyNAL1CidN2grfCEEMDLul+Pvz0YHwop0zjONFx8MYpzG3I2W0O7xjaTV3u19YtQ9E/Ij5m1NgAff3g5W5TMQkCgeirZJa5/XqXSAYASn6igLK2M/SLakSj63nzU+FgKo6dKq6Ldmd3QzaOsHeCYa1r+gUIXgZrbTs1gd42JARrIuVKWnJn0bYlG0tgnp5CZhpprl85lfVUoHHXcpHTt86ZTk+kz9HgSptJND/DnR5Mz35+l5zlqE+xWmYT5q2ESZx5LEweip5ZJRqoX4VXuiveXhRlQPmocveLJj5U/I4mB+dkqx2P8vypfhCuLdIL4XxiWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB6452.namprd11.prod.outlook.com (2603:10b6:510:1f3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 20:53:26 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 20:53:26 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "dmatlack@google.com" <dmatlack@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Topic: [PATCH 02/16] KVM: x86/mmu: Introduce a slot flag to zap only
 slot leafs on slot deletion
Thread-Index: AQHapmM+V0hpZvOG4Euj+PM9FPWPubGYSbqAgABgPoCAAAP6gIAAC9oAgAANSYA=
Date: Wed, 15 May 2024 20:53:26 +0000
Message-ID: <ac5cab4a25d3a1e022a6a1892e59e670e5fff560.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-3-rick.p.edgecombe@intel.com>
	 <b89385e5c7f4c3e5bc97045ec909455c33652fb1.camel@intel.com>
	 <ZkUIMKxhhYbrvS8I@google.com>
	 <1257b7b43472fad6287b648ec96fc27a89766eb9.camel@intel.com>
	 <ZkUVcjYhgVpVcGAV@google.com>
In-Reply-To: <ZkUVcjYhgVpVcGAV@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB6452:EE_
x-ms-office365-filtering-correlation-id: 86f89242-5f41-4131-074d-08dc7521114b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|376005|1800799015|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?SU5ub0JjaGpVVXRuTUxTaG9LZXg3UHRyWE4yMW5wU1Fob2ZlcjhRSWJsMm5s?=
 =?utf-8?B?VHZ3Vm1LaWd5bklQNnVKV1FETW1ScWtGejNoYjdqa0RPV1p0amdFaEcvTjlk?=
 =?utf-8?B?NXdyODdZcnU2cjhheFFIYzFqL1AxMndlMSsrS1hXYkovdlFoVmlwOVd4Nzl0?=
 =?utf-8?B?N2ptUmx2bzEyVEM2NEQvWHgwVWpGbVB1ZyswaXFnVklubndna1RjOS9RbUV6?=
 =?utf-8?B?R1luZENmMjVvL0hmSG5zWDg5MlpVUDRXTnV2Z2pqaUhabDgyVnVxVy9uNTdn?=
 =?utf-8?B?Wm4rTVZhemV3ZDV5U0ppRjhVYmNhNFpoMzNLdkRDdjRTdVl4Y0IzSEFPNkh1?=
 =?utf-8?B?Z05LTXdUakdzTVdrZTBKNVp4YjhFdHJhZnFVa0tjemcvSmJucWNjQi85WmJI?=
 =?utf-8?B?TC9uQnhlVFFkRTVOUkc1Yi9vZUZRWFdqQnlnbWc4SFVQTU5HRmc1WmZMNlFo?=
 =?utf-8?B?WmxaaUFQbjRoR3lPRFVEdzlCdEFJZVRxV1FvdXRqSWhkTHdhWkFIc1FmUE1V?=
 =?utf-8?B?M2Y4cEtsYklpczA5N2g1eldJZkI5cnNFZ2w4VnVLRTBwSFM0SGpHY1c1QmN2?=
 =?utf-8?B?VkpGd1RRUk5IWDhQZDBkNGRZbkVBeVhnN0E1WHRmL2p4VFhFSGUrTlh6aENM?=
 =?utf-8?B?eXp4Tk5tUjArSEYxVTY1bXJKVlJGeUJBL2tkRnBua0dKSjFMVHRoQ1hDYk5K?=
 =?utf-8?B?RTZYRFQrK1duVzhJTE9IR21ldG5JMklHVzZmQ29wRmpJd2E1UkZBSkxNelFO?=
 =?utf-8?B?cGxZK1ZyUjFaRmZCK0JpMnExeE5hNlUwaHJ6RklHZWVPRnVGcGJyVDl4VDlV?=
 =?utf-8?B?VEx3ZXhOcHRmZC9BcU51YVZsK1c3c2UrdUZZOFp6QnJZdXRxNVlvUFRtQkNa?=
 =?utf-8?B?MXRtVnF6RUpSa3BYYXExWFJlWWhKczNlVGN4YlFaa0hPTjdRbS9JVWhyNzFo?=
 =?utf-8?B?aFU0NE9EdzNsNnVzdlJucU80UnkwY3F4Y1c2VzlUL3N3dWNDWW85UERKTVIv?=
 =?utf-8?B?VmU1UkRFMisyWlBZSi9keW9SSzlnQ0ZXVHdLS213eEM0N1lpSi9PY0M4MVdO?=
 =?utf-8?B?QUFLVk1NcWptZ1FLbmtLWWgxT1dYcWs4cTFLSDlVa2tKdGNhREFPYlpJK1E0?=
 =?utf-8?B?bVVCcDdaT3N6M3BZSWU5R1VpODlBdVRkTkNKRXZGNmRGbEx4bmhIR1dERXVo?=
 =?utf-8?B?U1ByZ1FVYnp2dTFvMVlTSXpvS3dBa0NabnZXaGdGNXlTK1VNYUFUaVNLZWU0?=
 =?utf-8?B?VEhxRnhTdkJnaXMvamIrUlk5RTluM3d4R3ZyT3NySlMxeHhwc0NKOEx3NDlh?=
 =?utf-8?B?NDVuSnF0OHBjTHBoYVUwR2ZrVFVuem1kcGRnWEdVSmFneGRmaHA4SWRlZGVu?=
 =?utf-8?B?MU1QSUthZEFoaFNMMm9Yc1BFTEFTZFpMMDd6ckg1YTlFeWJZMW5VeXMxRzYr?=
 =?utf-8?B?L1ltNGR4UmQ3RVg3S29lWDAzYWsyVHFMSmdZc2gzWVA3dGQvemxValRQM2h5?=
 =?utf-8?B?MjV6dFlNVEFFTlNSeHpXNDIzYUk3cHQxSDJVb0hjUXFWOUhaS0RqWjR4OUxt?=
 =?utf-8?B?OFg0M0hoZkpKYk16L2sxendCYUhQcHE4VHA2Qi9YclpBZFpqV3RGVWpYWmJu?=
 =?utf-8?B?cU5aSlVjOU9xVjFXUlM0dWZQUTgyeWFPOW1lZ0xJV1drSHgxbk93dXZuUGtX?=
 =?utf-8?B?dUEwMjNrY2xucE1OTmdaODN4R0VtU3ZEV2dPQzJJeFhsRWVKenhqdHVUS21j?=
 =?utf-8?B?ay9na1VUem9uUGxZUGxQRUIvYWN4N29WMHZLREJkMndiZ3hXa0VHc0dvQU92?=
 =?utf-8?B?Y0YrYW5ZSHUrM1JiVFVxUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHJ0WHBIc1VkWk9NVTVVRFlxNHRvckRpQ0VOY0Q5OStGby82NjB5UHEzWWUv?=
 =?utf-8?B?T1BFbDcvNm9GNW9mZ1ZHdUYwaXNKWVF6ZFI1TnduNkxNT1hpa21CQVdXU0RN?=
 =?utf-8?B?aWVZaTR3UnFPZHFzWk5UQy8zYkRacEJ1SitxMCsvTjJ5V0NBd3ZkRXFCVDR5?=
 =?utf-8?B?NW1NRUJWYXJOeFZka2o3NVB2ZUtiaHB4dTBzRU1lNnducXl5ak1JWXJEZlNK?=
 =?utf-8?B?RjdGTTRGTFNIYS9XbklxYWl0UFJrTHpMbWdXV1M4QmppalNPS0xXR0E5Mm5D?=
 =?utf-8?B?TW05UXhoQ1F1NnJhUnJ0MVhHcmQwTjlEOEU0Ymg1U0E1dURITVR4WDNGelQ2?=
 =?utf-8?B?TWNvVkJPbHpiaTRVc1NNSUZNUDBoSEVIL3ZXMmNiODIrWUVhSlBQMXN5OFB0?=
 =?utf-8?B?QjJpUytXMjEyOE1CS2xMaFNsSDBxb0tUZUlWVFBKTm9hbVV4ZSszYlA1NTVP?=
 =?utf-8?B?elQrKzR4U0dkd2tNN01DbUdzVWRKdlY3NkFwaTNGbzdHdTVkdU8xRmo0RG16?=
 =?utf-8?B?ZU96UUQwd0JHR3dxWUJvdlhzR0tuL0FuZjJKMlRvUWxveWxDWmhKbWVnRTRQ?=
 =?utf-8?B?aWErWlBLcGdpN3Nkd0xmejgzeXdBb3NwZFYxVHZhc3QzMW9CQWV1cEhEbVpR?=
 =?utf-8?B?Q0RWNU1sMXpiaGNRTWUzRE0yMWxEVmIvNkpUbWdnaEgra3FJUlU1Tk1Wekds?=
 =?utf-8?B?K0VvMlNJUGNYU3NXN3lOalJPcitieDRrd0prYkpiWEQrVnY3aWU2aVB3MnRI?=
 =?utf-8?B?bVNpYk1HZkYzb2JTYVVBdUpYd1EvRXlxc3I3b3g4d1FESnR2N1hleGRDZ24v?=
 =?utf-8?B?Z2FwblVxV2Y1SkQ0anR3ZFZWcEEzVGpwejA5SUFJcVVFb1U5NlpwMFlZWkRO?=
 =?utf-8?B?R2lNdXQ2ZTdlbWN6Q1RHNEdMY0hDdDZ5TFVhRkQ1VGp3Sk0wM2FzS3p0dks2?=
 =?utf-8?B?d0J5eWhoek4wdWgxcitYSEVna1V4OEdYY0F3RXR2MDcyTzM2bWtzWk1zYzl3?=
 =?utf-8?B?Sk9ZSDUxSWptNW9MVHYyeC9zYk9tcmNWYXhzRkQyQmYraHdXYVhySFNJVkUz?=
 =?utf-8?B?NUVreHJoR0pnSHlsNG1iL3pINzRmZzVLS0M2aDVMd2diazZmTzJ5VjVvTCty?=
 =?utf-8?B?UHU0bDVXVER2cEo5Q2pnUFY4T1NaUTkrOGI4ZGt5S2NFQVk1R2doQWVQQnVp?=
 =?utf-8?B?dW42ZDgwWk1aTEdqSGJuZTlqeHF6Qno4OGtFWXEveWg3Z1RuMndLbCs3U0ZX?=
 =?utf-8?B?THRuUWp2a2lQbE1oK3dhQmtId2o4OU42RHpHS01YcW9jb2szd0RiblEzcmhL?=
 =?utf-8?B?VStGUXNvcG4rdDlFOU9RZ0p5dG50dUExMkQyVGd1WnNHUElzMU52c1dMTmll?=
 =?utf-8?B?WkdpbVlYZVlIbDZ3b0ZOaHErV1p4dVlHVC9veW5NMTdMZHBFUm5tdCt3VHZ2?=
 =?utf-8?B?ZzhCM0J0d0lBaVpZcmpmUXlsNWI1UEFsdnFhSEhXb1c2Skg3cTNXOWpLTGN1?=
 =?utf-8?B?QlF0Y0VFK3pxaEZtUUdsQThLMUhBNzM5aThOWWYwb0krbzI1TE1jNEYvSlB0?=
 =?utf-8?B?TmErS0N3ZjJrVDBSeHRNMDl5ZUtTSWN4bEMxdEZNU3Q0eHcrSytuM0hyT2Vn?=
 =?utf-8?B?Y3VtTWVxRWUxU2RaaDFZNGJHcXF4TGZ5TWhrL0h3bHpUbk1mWkdvbkRFdnpS?=
 =?utf-8?B?YjJrN1FBUEtiSTl5YzhpMHJRVWdZVE1ITzBTbDF6aXcyWFJyMFJ3d0pRM1BO?=
 =?utf-8?B?MndrbGJrRmpTam9LQkhQSGk0OEtpMHN1eGJmQzhpa2orVlFkUE1vdmlHSjVQ?=
 =?utf-8?B?Qzk1dXJncUdqZjN4b28ybi9Qa3IrTHlBbTZ1Rk12NkRtQnlKZ3AyTUxOTHVm?=
 =?utf-8?B?QzE1Nmg3dWhtMmdIRFRydm1SVEUxenNTTkRIRktpZkxrb1NTekFNaEFsUlcr?=
 =?utf-8?B?QXRISjBaZUd6a0dqcjhESXN6V3ZieWZSY2lCQVZHVTNnZUxYUVlhRDVaREpX?=
 =?utf-8?B?SVM5aWRZTW1aZDhjWmJNL2dpd1VmUVVxcWJnVEhwWUhTRittNzVtSi8xdXdC?=
 =?utf-8?B?Y1pGS3BVVmM1cDB6dkdpbnBZZEZnOW8wWUNjamlQVENHQzVDN2xSLytPWjha?=
 =?utf-8?B?aVFyU21lWHFqLzd3MEQwamoyNnFFV3RTME1naGt3UEFTUlFEQkwzTHh1OGJF?=
 =?utf-8?Q?vd74WTBgBwQafLnl7yeu/hQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F43EABC9179A8D49B6276C2DBFDB2236@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86f89242-5f41-4131-074d-08dc7521114b
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 20:53:26.3897
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5ZDsv9xIxSXqKM15FEqQyKthvM/yNbTXRbcKaRtDvkDupyr2AKZsDeILl5u0SWCPtdiZ4g0vVGuw3QZOcCVOzNvwzGPkvzeaSvghSaBBUsk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6452
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTE1IGF0IDEzOjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAxNSwgMjAyNCwgUmljayBQIEVkZ2Vjb21iZSB3cm90ZToNCj4g
PiBPbiBXZWQsIDIwMjQtMDUtMTUgYXQgMTI6MDkgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24g
d3JvdGU6DQo+ID4gPiA+IEl0J3Mgd2VpcmQgdGhhdCB1c2Vyc3BhY2UgbmVlZHMgdG8gY29udHJv
bCBob3cgZG9lcyBLVk0gemFwIHBhZ2UgdGFibGUNCj4gPiA+ID4gZm9yDQo+ID4gPiA+IG1lbXNs
b3QgZGVsZXRlL21vdmUuDQo+ID4gPiANCj4gPiA+IFllYWgsIHRoaXMgaXNuJ3QgcXVpdGUgd2hh
dCBJIGhhZCBpbiBtaW5kLsKgIEdyYW50ZWQsIHdoYXQgSSBoYWQgaW4gbWluZA0KPiA+ID4gbWF5
DQo+ID4gPiBub3QgYmUgbXVjaCBhbnkgYmV0dGVyLCBidXQgSSBkZWZpbml0ZWx5IGRvbid0IHdh
bnQgdG8gbGV0IHVzZXJzcGFjZQ0KPiA+ID4gZGljdGF0ZSBleGFjdGx5IGhvdyBLVk0gbWFuYWdl
cyBTUFRFcy4NCj4gPiANCj4gPiBUbyBtZSBpdCBkb2Vzbid0IHNlZW0gY29tcGxldGVseSB1bnBy
ZWNlZGVudGVkIGF0IGxlYXN0LiBMaW51eCBoYXMgYSB0b24gb2YNCj4gPiBtYWR2aXNlKCkgZmxh
Z3MgYW5kIG90aGVyIGtub2JzIHRvIGNvbnRyb2wgdGhpcyBraW5kIG9mIFBURSBtYW5hZ2VtZW50
IGZvcg0KPiA+IHVzZXJzcGFjZSBtZW1vcnkuDQo+IA0KPiBZZXMsIGJ1dCB0aGV5IGFsbCBleHBy
ZXNzIHRoZWlyIHJlcXVlc3RzIGluIHRlcm1zIG9mIHdoYXQgYmVoYXZpb3IgdXNlcnNwYWNlDQo+
IHdhbnRzDQo+IG9yIHRvIGNvbW11bmljYXRlIHVzZXJzcGFjZSdzIGFjY2VzcyBwYXRlcm5zLsKg
IFRoZXkgZG9uJ3QgZGljdGF0ZSBleGFjdCBsb3cNCj4gbGV2ZWwNCj4gYmVoYXZpb3IgdG8gdGhl
IGtlcm5lbC4NCj4gDQoNClRoZXJlIGFyZSBhIGZldyBmb3IgbWFkdmlzZSB0aGF0IGFyZSBsaWtl
ICJkb24ndCBkbyB0aGlzIi4gT2YgY291cnNlIGFsc28sIHNvbWUNCm9mIHRoZSBpbXBsZW1lbnRh
dGlvbnMgdGFrZSBkaXJlY3QgYWN0aW9uIGFueXdheSBhbmQgdGhlbiBiZWNvbWUgQUJJLiBPdGhl
cndpc2UNCnRoZXJlIGlzIG1sb2NrKCkuIFRoZXJlIGFyZSBzbyBtYW55IG1tIGZlYXR1cmVzLiBJ
dCBtaWdodCBhY3R1YWxseSBiZSBtb3JlIG9mIGENCmNhdXRpb25hcnkgdGFsZS4NCg0KW3NuaXBd
DQoNCj4gPiBTbyByYXRoZXIgdGhlbiB0cnkgdG8gb3B0aW1pemUgemFwcGluZyBtb3JlIHNvbWVk
YXkgYW5kIGhpdCBzaW1pbGFyIGlzc3VlcywNCj4gPiBsZXQNCj4gPiB1c2Vyc3BhY2UgZGVjaWRl
IGhvdyBpdCB3YW50cyBpdCB0byBiZSBkb25lLiBJJ20gbm90IHN1cmUgb2YgdGhlIGFjdHVhbA0K
PiA+IHBlcmZvcm1hbmNlIHRyYWRlb2ZmcyBoZXJlLCB0byBiZSBjbGVhci4NCj4gDQo+IC4uLnVu
bGVzcyBzb21lb25lIGlzIGFibGUgdG8gcm9vdCBjYXVzZSB0aGUgVkZJTyByZWdyZXNzaW9uLCB3
ZSBkb24ndCBoYXZlIHRoZQ0KPiBsdXh1cnkgb2YgbGV0dGluZyB1c2Vyc3BhY2UgZ2l2ZSBLVk0g
YSBoaW50IGFzIHRvIHdoZXRoZXIgaXQgbWlnaHQgYmUgYmV0dGVyDQo+IHRvDQo+IGRvIGEgcHJl
Y2lzZSB6YXAgdmVyc3VzIGEgbnVrZS1hbmQtcGF2ZS4NCg0KUGVkYW50cnkuLi4gSSB0aGluayBp
dCdzIG5vdCBhIHJlZ3Jlc3Npb24gaWYgc29tZXRoaW5nIHJlcXVpcmVzIGEgbmV3IGZsYWcuIEl0
DQppcyBzdGlsbCBhIGJ1ZyB0aG91Z2guDQoNClRoZSB0aGluZyBJIHdvcnJ5IGFib3V0IG9uIHRo
ZSBidWcgaXMgd2hldGhlciBpdCBtaWdodCBoYXZlIGJlZW4gZHVlIHRvIGEgZ3Vlc3QNCmhhdmlu
ZyBhY2Nlc3MgdG8gcGFnZSBpdCBzaG91bGRuJ3QgaGF2ZS4gSW4gd2hpY2ggY2FzZSB3ZSBjYW4n
dCBnaXZlIHRoZSB1c2VyDQp0aGUgb3Bwb3J0dW5pdHkgdG8gY3JlYXRlIGl0Lg0KDQpJIGRpZG4n
dCBnYXRoZXIgdGhlcmUgd2FzIGFueSBwcm9vZiBvZiB0aGlzLiBEaWQgeW91IGhhdmUgYW55IGh1
bmNoIGVpdGhlciB3YXk/DQoNCj4gDQo+IEFuZCBtb3JlIGltcG9ydGFudGx5LCBpdCB3b3VsZCBi
ZSBhIF9oaW50Xywgbm90IHRoZSBoYXJkIHJlcXVpcmVtZW50IHRoYXQgVERYDQo+IG5lZWRzLg0K
PiANCj4gPiBUaGF0IHNhaWQsIGEgcGVyLXZtIGtub3cgaXMgZWFzaWVyIGZvciBURFggcHVycG9z
ZXMuDQoNCklmIHdlIGRvbid0IHdhbnQgaXQgdG8gYmUgYSBtYW5kYXRlIGZyb20gdXNlcnNwYWNl
LCB0aGVuIHdlIG5lZWQgdG8gZG8gc29tZSBwZXItDQp2bSBjaGVja2luZyBpbiBURFgncyBjYXNl
IGFueXdheS4gSW4gd2hpY2ggY2FzZSB3ZSBtaWdodCBhcyB3ZWxsIGdvIHdpdGggdGhlDQpwZXIt
dm0gb3B0aW9uIGZvciBURFguDQoNCllvdSBoYWQgc2FpZCB1cCB0aGUgdGhyZWFkLCB3aHkgbm90
IG9wdCBhbGwgbm9uLW5vcm1hbCBWTXMgaW50byB0aGUgbmV3DQpiZWhhdmlvci4gSXQgd2lsbCB3
b3JrIGdyZWF0IGZvciBURFguIEJ1dCB3aHkgZG8gU0VWIGFuZCBvdGhlcnMgd2FudCB0aGlzDQph
dXRvbWF0aWNhbGx5Pw0K

