Return-Path: <kvm+bounces-47577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3D13AC21FB
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D51467B1D59
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D53B22DFE8;
	Fri, 23 May 2025 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AQVynea5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727DC262BE;
	Fri, 23 May 2025 11:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747999890; cv=fail; b=ZdnKvCnLgbfKBU876fg3rD6gWtuxw8zoo7rnhba06DEcI/QwogNLVrxGukBRho6RO/qX20x3VwWAZWuLOe0Z6O8wQSyiemmiJQ9N3R/5xiFf8wMtRFfOgsyzOK//6fQTtWLi4Mok8eufkqUe6SZgMXsOrL8RPFVFE2W/dpeyXFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747999890; c=relaxed/simple;
	bh=tgluCeSf9jZ5nocPiD3OBLSWftroB3JLQtR+bkt1seM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=qdcC2qZ81LIiufxuvRRaRsBR9L0MN81Tqbl3FRdg9gKhj527D8N4L5MXt5sV87tWCJpsGxnL+yxN5K7u6fZEONxQWj+aSlkJB/p8Mq9dQpxocq/yyuNHVTrLGfwZzWBSyJBmXTPanGn3PCjrvvsisgvU9WLwamotyQfTE3vzUYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AQVynea5; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747999888; x=1779535888;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=tgluCeSf9jZ5nocPiD3OBLSWftroB3JLQtR+bkt1seM=;
  b=AQVynea56hpLZVQR9/DM2NoG35V0QZ8t8MbTJe0LpY9ZiTsxDBo8aWuA
   14K3OFkIUqqmDHB+GD+5bQd9nEXHMP4XqUjfScb6dgfhRKYmAQuInBIm0
   gIthNj/QW0QHFFZIFuBlGwgugveYHWOgKlkp/zpGMLPwWm6B1jHQNwB30
   5wsPVscX4ogf5hsrtX1nypTDAuVExQxMzIwoQgqB1FpPHtkvGr5XUnlI2
   gvj8Wj0rUXB4/IoFfHH9iTqaHTfmotbsTgYC/0uakQVLUrDv0aVSOzECX
   3gjKdWSURbWff90Mb+Pufe/WnlEEHvaamLn6rkHpKmg43gOUF50iFWNKN
   A==;
X-CSE-ConnectionGUID: op8tdS49S+S9oHOLMTjyXQ==
X-CSE-MsgGUID: FT0TqwOIT1KOlpSsWf/WrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="60690627"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="60690627"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 04:31:27 -0700
X-CSE-ConnectionGUID: fufhf1TyTCqOjym27MMPtw==
X-CSE-MsgGUID: Of5r7sZKS1WbRsvPIWOe3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="140985438"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 04:31:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 23 May 2025 04:31:27 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 23 May 2025 04:31:27 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.41)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 23 May 2025 04:31:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mDUZvrVnm0rk1CR1DRS5pjPWSsgzuyeVcP/X01kJ/BvbN7dooHaQd2uId1f/xxAFmv46/CSP46zH7JQK58TnE41I1UBQ/Ze+wvu0dadwnRsCEJOBqTitI8qIV6wc2MmjSULKznsmB+VaLEh7cuZEjiuRqmPC958D3VhxyGsmyfxWNZhkv9YJYHBNY6qpHJprqJXExDWxLCeU5V/XY6YC9becHqZgeX9V7y/IIFCnQrLqHMniEkPPbyjsufQCY0cx3kvGZOcMx1MUz+rFXjFJWCM9kXghKEe4IUG6kbilNAdrWWpppWr0Rmblt8kG4D1bvarvQf3ahjT+gbNQAFfoXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tgluCeSf9jZ5nocPiD3OBLSWftroB3JLQtR+bkt1seM=;
 b=MnrlYElofz/I4hRi5JZYCjAYMUH2JxinqEjELiuzHVCvEB0gZYLp/YoeudEou20z6JY7I5OU0vOcsoN+NJm3+ymkpRj1/F93aSB2nqaVulQ7Xxf+L7ij4iaSGGjSgGxNk5lnTQ4ct43Sqn+/8taJyve3RAXmw9LRGa8T3P8gamMvX1dKCpeo5UD2y8i1YKLqETd8Mm7Dbw/OBPT8HpzW+zBPYgMQRMwaf7ZnwyM3AjaFKWy751/9bXWQd6WV9k0xfeG2JpZttkN+YDw0r9v0yqhDANQ+xeuARqcTkyzQLMV9zh+E55jXwC88AR3UwsUU20X78GfwgL3eKrg1BpQJ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by BL1PR11MB5255.namprd11.prod.outlook.com (2603:10b6:208:31a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.22; Fri, 23 May
 2025 11:31:10 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8769.021; Fri, 23 May 2025
 11:31:10 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "vipinsh@google.com" <vipinsh@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
Thread-Topic: [PATCH v3 2/3] KVM: x86: Use kvzalloc() to allocate VM struct
Thread-Index: AQHbxq0+OB9mwly9vEqEwiQpLwdhbLPWwyGAgANXzYCAAgqsAIAABhSAgAAM2QCAASEUgIAAXKwAgAD6g4CAAW40gA==
Date: Fri, 23 May 2025 11:31:10 +0000
Message-ID: <572c0f5ce627384b6441b64b9fa036b202d430b7.camel@intel.com>
References: <20250516215422.2550669-1-seanjc@google.com>
	 <20250516215422.2550669-3-seanjc@google.com>
	 <219b6bd5-9afe-4d1c-aaab-03e5c580ce5c@redhat.com>
	 <aCtQlanun-Kaq4NY@google.com>
	 <dca247173aace1269ce8512ae2d3797289bb1718.camel@intel.com>
	 <aC0MIUOTQbb9-a7k@google.com>
	 <5546ad0e36f667a6b426ef47f1f40aee8d83efc9.camel@intel.com>
	 <aC4JZ4ztJiFGVMkB@google.com>
	 <918715044bf0aa6fb51ce511667bf7bb4ccbabea.camel@intel.com>
	 <aC8pSfEBdHZW9Ze7@google.com>
In-Reply-To: <aC8pSfEBdHZW9Ze7@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|BL1PR11MB5255:EE_
x-ms-office365-filtering-correlation-id: 3f72bc3a-751e-4add-f66f-08dd99ed5138
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Z1dVSE03eWYrdkNiY3dvMk13UDJpcWR2NlNVZ3lGTkVqb0lyWHNZWHowb1Ny?=
 =?utf-8?B?SXlBbGhDeUtEMmU1YUxvNDFJaFZvZDdOcEpvUzNMSlBHZEhxR0o3S0U2dmhO?=
 =?utf-8?B?Q25ySkwzR2Z5NWJ1L0puSlVhZGh6NDVtWlJwUjdIMDNPQ0pVVi9BUUZRT1E3?=
 =?utf-8?B?dUVTSkp6MEV2Smd1Mm1OdCtHWEY5UnVNSGkwdTVYbDFLVXBTODZOWC9XVWJa?=
 =?utf-8?B?YnluSWtZaE1BY1BXa1V0dGlYdzBoRG1LVG95MGtpSnVrUVRGYWU1YlcrOUhq?=
 =?utf-8?B?ZFlqSUM3OXRBWnBMRVpLTldHeDV6N0taZmVWZ080anNLUU5uMWpwSjJlUXYv?=
 =?utf-8?B?eUkvSmpSaDN1Y2pKeERuS3o2ZE9HcHA2TklRaHRicjJQeG5IdFd4V2VwcFFp?=
 =?utf-8?B?VHh0RkFhQXJXQThsOG1qSnRyQkRRdFVYZTlnZlBrekZGZ2U5aDAzUFFMUkZP?=
 =?utf-8?B?TUk5VVhjLzdpZUJpRVdLTGliNlZOYjZ6N3FCQWt3RjA4TzhoL29sbC9lbnpr?=
 =?utf-8?B?MWQ4SmcvN0RYTEFDTjQ5eFc0am9oNVZuMlRncmZuOEZVNHN3TGFqV2VpR0xu?=
 =?utf-8?B?eWdCUXh3ZUtraVRaOVpRZUU4U0pmMitETEVvaEh6bDJYL3h0SCtGK0gzcmkx?=
 =?utf-8?B?V3RWSGxmcmRmbTRiRDRSTHQ2Z295ODAveGo4QkFnRFQ0eFpzcXNLZmJncHBE?=
 =?utf-8?B?L2Z4ZUJVZElocHpWSUdMaTZTMWU3RjhFanRJcFJSNFF0NzlxWjVrTjYzTE54?=
 =?utf-8?B?OEhINEZaTXpCa29YUVZwNXFBTU43NERIWEVXNnFDSndvcmZmS0NQRTV1K0FJ?=
 =?utf-8?B?NFRyZUhNcnZCT1dzV2NlUC9NY0dtUUdubHcyTlRaYkYxcThiVE4yZFFZSjRm?=
 =?utf-8?B?TVpna0xaSWhFcTJzOGZuUk1KZHN6OVRqVUN4MFB2TzBLWGVncUk2dnRkT1Zx?=
 =?utf-8?B?N0I3OXg0dFgyak1lK2FjcnZaSVZyTnJXbndyendUWk9wQmROOTlQbE4rVE4x?=
 =?utf-8?B?MVV3RkJIUGFFWTBHby8rKzc4VDhqVTNJTDd6c1JGRGNiMmdWZ1N5ZDByMEU4?=
 =?utf-8?B?dS9NZjlJY1I3Rnp3bGtEcEMvWG5wUWtLTFo0Q1EvUnNHNWVZMk1hUG4zQjdq?=
 =?utf-8?B?eDlXWXBZUjMxWjUybXVVa3A2QW5zZ2p1ckRHYUdPS1Awem44SzEwRDlWbENm?=
 =?utf-8?B?d1EwR1FLT2dsQjh0Rjk1UUtLQWZuTnZvUE5GdUJXTy9zZjZlMlBWdTlVa2li?=
 =?utf-8?B?d3c2ZElMY2d2aVZBU3U5TmtRdjBpaGxLaU9rcUNIaTEzcGlSZk5hbXBUd3pX?=
 =?utf-8?B?OHZmTjdkS3MrVE1mNUdjMy84Mi95aUdCK1hERklqdlJtd21VeWxObnArMmpa?=
 =?utf-8?B?cm9tZDJTM2o2aEJpNzZ3QXJOL3k2eGVuTkdjWm51dmE1a1pjSnF1UmJ6Nmtl?=
 =?utf-8?B?Nk5Nb1A3QnlldWpuVElJdmVCQWU5WlRINmFwVkh1RTgreHdTc0tYNnhXd1JO?=
 =?utf-8?B?em9sWXFPdmxTd3RzNHZGcjMzTm4wRFBZdFM3WE1IQnVzS2xvdVJTKzNpeGRv?=
 =?utf-8?B?RE1rUFJsSEQ3VjgzL0QxSXNJMitpaEdDRDBTaFJZTnZZNS9EcTE1RDMzaVVW?=
 =?utf-8?B?STB5dDNXVlZwd3lsZDY4QWUwZHl5Vld2K010SVYveWVCYkVrSU5wZlE2ZGUz?=
 =?utf-8?B?ZmQycGtnbnNYMURxR2c4ZHJyUFowd3dML0dUeFJoWjZRQ1ZwMnRaVFRPUlRK?=
 =?utf-8?B?SlJ6NmFWSlRTYzN4d2RqcFB6aDZBT2x3TlRiZkdIL0JqT3A1UW9LaU9CRDAr?=
 =?utf-8?B?bEhScytUdytaSlYyeVBSSVMyUDFJY1I5U1AzQTJSL0hQNzVEcEY1d1ZxdzFw?=
 =?utf-8?B?NEMxN2ljS0dLNDkxVnoxNUt6RGl3MGFWVnI0Z2RqRDZyNlJ4TWdxdjNZODVB?=
 =?utf-8?Q?XDcWroUr5yU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmN0SVhERDc3ajhSUkxNY2s2TEVSNGY5TWNoS2NmU1ExOWtobVh2d2l4L0JX?=
 =?utf-8?B?NEQ1cTdmTFFEcDlDRU1LSjJ1aXdXZGxXbHZrN0pJLzB1bEczZXBzanpZQ0pY?=
 =?utf-8?B?TW84OFR0bVQ4UGdJeXNvakdWNXp3QWNLWEtTLzA5SW54TEY4cG02ODdHMUxT?=
 =?utf-8?B?ZlBEaW41WkFodkVNeFl5QWNHU2lQOXVNUGJ1alJoZkJzZEVaV3YrYVVJZjk4?=
 =?utf-8?B?NUlhVFRFR1BRbGlOcUd0bjdkV0Z4Vmc3TFBPV3Rqc0dwUTFOb0NwcDJJY2N5?=
 =?utf-8?B?YjlZTldZOUVIdVBpYUMrTnlqcUhyTkhtZmo3ZnBOVTZURi9YbVZxMXZWUUpk?=
 =?utf-8?B?dDhJWWpYQzVaY0N5bG9PZExFQStBV0E1WFY2RlpkUE9CZ0tFU0h5MGI5eTRK?=
 =?utf-8?B?eE5TaHBrMTgrb0ZtTHZLS0NNVVJVL2R0RnprOUVWMUF0RHN3cU56Z0k5d1Nx?=
 =?utf-8?B?SHFlbEloQUl5Rjg1YUNwTjVXV05UTUoxeUpvbFdLZ3o1S3dJMDMyOHZvcCtR?=
 =?utf-8?B?WWJrSFV5QUhmSW5aNDB0clJEWXBzdnoyTVhaYWE5Mk5nY3lOOGhWRng5WGVx?=
 =?utf-8?B?M1BtTFJzckw0Nk1HaE04NWt2dDl6OFNzQStmRVg2SmFaclNXOTlMTjBSSWNV?=
 =?utf-8?B?cXVRdmMwOGp4RUk0MWU4WVBFY1E2eEZVSlB3VUFkOWVZV0t1OTVubzNWSXcw?=
 =?utf-8?B?Rm1UUE5IdlpkalFYMEZsam5xNytHS0lpWjM0ZFRNbjk3ak5hU3FJRlV1aVpF?=
 =?utf-8?B?enRRbGs1MmtGTGhxVHdLUnBBM1lyanRnS0oraHF2K0c4VW1VdXZpY1B4YjYy?=
 =?utf-8?B?dkxOMEpEMWxzSGJTVXNSbEdscEk0Snp2L3VQNzZ5ZjdnMHhOa3ExbGdyMDd1?=
 =?utf-8?B?YTJzM0RtMXR0aHlFSEdUNkowTUw5Q3pRMi95cTVheUZHWmRGNlNwNXNsQkJZ?=
 =?utf-8?B?TkxjbjYzNXV4dlJscUd0WlpwNjEzNmpra1dIQ1NqeFErNGxDeGVuTmF6U1o0?=
 =?utf-8?B?bkVoVVhtUzBGUTB0ZTA4UWhaZ1ZsWFBCbzl3ZDl1VGRxbkVqRmNLRWcxWXJo?=
 =?utf-8?B?OXQ5RlJ4Qk85Rm9EenNMcWR1Y3Y0L2NJQTJ4ZDNBS0F2NnBWRUI4SnI2V25C?=
 =?utf-8?B?RnJ2UGtQQjJ0dWljM0Rwbm5Rb2VnaWJsbHFuTGJXZklNWFBTcTdhS2xJWFo3?=
 =?utf-8?B?WGpodWthVzYzTUFzQzVQLzBjd05DSGR4QlN5U1dQNjBCaFVPOVdxdlhMYWxP?=
 =?utf-8?B?UG40d2doVlNFTUtOdmxPZURaUCtZSlFtYnBIZVNtd0l1Y21YQUJJZ2ZGTGMv?=
 =?utf-8?B?UjZKc3poY01JN1VHQ0lPTnBOS1VmeURjaWJLOENFK2RUWmgvR2xDYkY4Zi9m?=
 =?utf-8?B?UUV2U0V2VUNLWXQyTzJYQ2pvZGFXWnJnOFVsZURGS2VIalMrYXdFNmFZZElj?=
 =?utf-8?B?NkFGeG5KVW54bVF2MCtYbGM3OXY2VmswSnBJVVdqOGNEOXNWdVlCTUpnUkF3?=
 =?utf-8?B?aXBOL1VLOTZkV2dDUUNJZ080MXFGMldBR1R6TGkxblJQa2tQbGpGQjJ6TGZk?=
 =?utf-8?B?M1JITmZhaWhOdkNtUFZwTVBIdDM0UmpNc3VvdHE5TzJqWWJ2U1BqUnc3ZHdC?=
 =?utf-8?B?bkNPblhFTGlXeHliN0tUOXVLYUdpV3VBa1hXS0xXZmxCQjhlYzBKWkVVWFZU?=
 =?utf-8?B?dW9WSDNKUTh3RGJNRjlVQ3lWOTVQSnhSY1NNUXJDQjBjaGJtRVFtb3NEMFFh?=
 =?utf-8?B?S2Ryc0l6NGdxdE9JejF5VVFHcHA1diswdXJyOXhhTUQvVHNsdVVZOS9jOWhJ?=
 =?utf-8?B?ZlZFR1poUW92N05kOS9vY1F4OU1QMFliSjh5dnM3RlhqMzRtRXRnekhRWEh5?=
 =?utf-8?B?N0VuODhJTFBZK1IwNm9NNXNlVkk4MUo0Z0FQRTZVczdiRU1hT2V5Qi9UU2Va?=
 =?utf-8?B?WDcrajk0QXJCSEI2bVNlRDNmb2VxWVBxT0ZMS0g4aUZWMFd1SVhhd01jbHhQ?=
 =?utf-8?B?VitwQzlaQkYzL1M5NGw0ZURRT3VBUlRzNTlhMzBTWEpjNVdhNDA4NjN2akNt?=
 =?utf-8?B?YkhrZ1k0WUlTbGdiSit1QzZwQTU4d2dqTW1wdzg4YmNBcXF5RFJQTGxUUWhG?=
 =?utf-8?Q?xy+Xl9uNhTwJS4SjInpKGd1YL?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB8C6F85C5E69949A2160FB7BFFD4347@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f72bc3a-751e-4add-f66f-08dd99ed5138
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2025 11:31:10.5036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +shgWcHTwC6onIU+W8//gbt9eqiN/PlaLf3Xfa3AFq/zZvc/OcLY+XrwDaC6iflJBWveH8o0l2qNgmm1vyNQMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5255
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTIyIGF0IDA2OjQwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAyMSwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNS0wNS0yMSBhdCAxMDoxMiAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+ID4gZS5nLiwgaWYgd2UgZXhwb3J0IGt2bV94ODZfb3BzLCB3ZSBjb3VsZCB1bndpbmQg
dGhlbS4NCj4gPiA+IA0KPiA+ID4gTWFhYXliZS4gIEkgbWVhbiwgeWVzLCB3ZSBjb3VsZCBmdWxs
eSB1bndpbmQga3ZtX3g4Nl9vcHMsIGJ1dCBkb2luZyBzbyB3b3VsZCBtYWtlDQo+ID4gPiB0aGUg
b3ZlcmFsbCBjb2RlIGZhciBtb3JlIGJyaXR0bGUuICBFLmcuIHNpbXBseSB1cGRhdGluZyBrdm1f
eDg2X29wcyB3b24ndCBzdWZmaWNlLA0KPiA+ID4gYXMgdGhlIHN0YXRpY19jYWxscyBhbHNvIG5l
ZWQgdG8gYmUgcGF0Y2hlZCwgYW5kIHdlIHdvdWxkIGhhdmUgdG8gYmUgdmVyeSBjYXJlZnVsDQo+
ID4gPiBub3QgdG8gdG91Y2ggYW55dGhpbmcgaW4ga3ZtX3g4Nl9vcHMgdGhhdCBtaWdodCBoYXZl
IGJlZW4gY29uc3VtZWQgYmV0d2VlbiBoZXJlDQo+ID4gPiBhbmQgdGhlIGNhbGwgdG8gdGR4X2Jy
aW5ndXAoKS4NCj4gPiANCj4gPiBSaWdodC4gIE1heWJlIGV4cG9ydGluZyBrdm1fb3BzX3VwZGF0
ZSgpIGlzIGJldHRlci4NCj4gDQo+IEEgYml0LCBidXQgS1ZNIHdvdWxkIHN0aWxsIG5lZWQgdG8g
YmUgY2FyZWZ1bCBub3QgdG8gbW9kaWZ5IHRoZSBwYXJ0cyBvZg0KPiB2dF94ODZfb3BzIHRoYXQg
aGF2ZSBhbHJlYWR5IGJlZW4gY29uc3VtZWQuDQo+IA0KPiBXaGlsZSBJIGFncmVlIHRoYXQgbGVh
dmluZyBURFggYnJlYWRjcnVtYnMgaW4ga3ZtX3g4Nl9vcHMgd2hlbiBURFggaXMgZGlzYWJsZWQg
aXMNCj4gdW5kZXNpcmFibGUsIHRoZSBiZWhhdmlvciBpcyBrbm93biwgaS5lLiB3ZSBrbm93IGV4
YWN0bHkgd2hhdCBURFggc3RhdGUgaXMgYmVpbmcNCj4gbGVmdCBiZWhpbmQuICBBbmQgZmFpbHVy
ZSB0byBsb2FkIHRoZSBURFggTW9kdWxlIHNob3VsZCBiZSB2ZXJ5LCB2ZXJ5IHJhcmUgZm9yDQo+
IGFueSBzZXR1cCB0aGF0IGlzIGFjdHVhbGx5IHRyeWluZyB0byBlbmFibGUgVERYLg0KDQpUaGlz
IGlzIHRydWUuICBBZ3JlZWQuDQoNCj4gDQo+IFdoZXJlYXMgcHJvdmlkaW5nIGEgd2F5IHRvIG1v
ZGlmeSBrdm1feDg2X29wcyBjcmVhdGVzIHRoZSBwb3NzaWJpbGl0eSBmb3IgImJhZCINCj4gdXBk
YXRlcy4gIEtWTSdzIGluaXRpYWxpemF0aW9uIGNvZGUgaXMgYSBsb3QgbGlrZSB0aGUga2VybmVs
J3MgYm9vdCBjb2RlIChhbmQNCj4gcHJvYmFibHkgbW9zdCBib290c3RyYXBwaW5nIGNvZGUpOiBp
dCdzIGluaGVyZW50bHkgZnJhZ2lsZSBiZWNhdXNlIGF2b2lkaW5nDQo+IGRlcGVuZGVuY2llcyBp
cyBwcmFjdGljYWxseSBpbXBvc3NpYmxlLg0KPiANCj4gRS5nLiBJIHJhbiBpbnRvIGEgcmVsZXZh
bnQgb3JkZXJpbmcgcHJvYmxlbVsqXSBqdXN0IGEgZmV3IGRheXMgYWdvLCB3aGVyZSBjaGVja2lu
Zw0KPiBmb3IgVk1YIGNhcGFiaWxpdGllcyBkdXJpbmcgUE1VIGluaXRpYWxpemF0aW9uIGFsd2F5
cyBmYWlsZWQgYmVjYXVzZSB0aGUgVk1DUw0KPiBjb25maWcgaGFkbid0IHlldCBiZWVuIHBhcnNl
ZC4gIFRob3NlIHR5cGVzIG9mIGJ1Z3MgYXJlIGVzcGVjaWFsbHkgZGFuZ2Vyb3VzDQo+IGJlY2F1
c2UgdGhleSdyZSB2ZXJ5IGVhc3kgdG8gb3Zlcmxvb2sgd2hlbiBtb2RpZnlpbmcgZXhpc3Rpbmcg
Y29kZSwgZS5nLiB0aGUNCj4gb25seSBzaWduIHRoYXQgYW55dGhpbmcgaXMgYnJva2VuIGlzIGFu
IG9wdGlvbmFsIGZlYXR1cmUgYmVpbmcgbWlzc2luZy4NCj4gDQo+IFsqXSBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9hbGwvYUNVMllFcFUwZE9rN1JUa0Bnb29nbGUuY29tDQoNClJpZ2h0LiAgTm8g
YXJndW1lbnQgYXJvdW5kIHRoaXMuICBJIGFncmVlIGlmIHRoZXJlIGFyZSBtdWx0aXBsZSBmZWF0
dXJlcyB3YW50aW5nDQp0byB1cGRhdGUgdGhlbiBpdCBjb3VsZCBiZSBkYW5nZXJvdXMuICBUaGFu
a3MgZm9yIHRoZSBpbnNpZ2h0IDotKQ0K

