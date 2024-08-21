Return-Path: <kvm+bounces-24679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4B999591BD
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 02:24:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62C8B1F2302F
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 00:24:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C63AD58;
	Wed, 21 Aug 2024 00:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLDXSkuV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC31139B;
	Wed, 21 Aug 2024 00:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724199846; cv=fail; b=HrgABSlCHeFmTX4gUM1iivI2Abw/ZVLo8PNsTfrn8pBqZSAKwegqcHHZQvEMklr4/E5EPezHGl9S1uxwl/zvu7iCKmbVEBS16b+y5y37E1HyE/PCXg+xvFP4Z8mg8RqB4qMyBUcMOJ+Mn7wYmkLL/JqoxSJRC2hEyZOhDz57Ytg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724199846; c=relaxed/simple;
	bh=5HeapFHauFoTGPP30Yg2OSa4kFMO8ZkUQCbkGiQBiFo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VoWtAQMPxY79YmyuNiRM/DE3aZv+sGveEjlJw3Hg1Wi3cJsSO+H1X5KZ2cJkXY5MutA7HU4odHZRi6ym+l0Fqc4DskX2L+XAhZw3q9iqTRQ/hYgFF47BMIL3EGFR+dfIdCwa5i4mwqjdU3vJKUpsjWDwvSW4h50ENvMQHhHz+Uw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLDXSkuV; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724199845; x=1755735845;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5HeapFHauFoTGPP30Yg2OSa4kFMO8ZkUQCbkGiQBiFo=;
  b=nLDXSkuVElAi/auBXpl3v4vtRqdqOeg9digacn1bvLL7gSrkI55MsVpz
   sG7BnhHbOzmGtIfklRuH2wsisCcd+vdMNRHxEKfhwN7wfRVP5ptofB2hO
   FLgXxZgRneieBwsrolYLF58BJ2rygGv8g/2J/16qRpNsYeZSwbP8OLk7t
   30vfvn+1TQ8Gn2bNO6y1dYXQtajELjRg06WSl2eB4U0DNBZU5ut0qVDf/
   R5d56vq5ykgse8oSCHOJRE4wG1AhoQ/C1Yukvp5K70yS3kda2jdTd6LA0
   cgENzOn3FJgcimH+35ror30/yhdhBbyrGdwhGqbseDvH5EEBeFoDnxxBM
   w==;
X-CSE-ConnectionGUID: CJLjvx6pT6eNs5VlrBmNdw==
X-CSE-MsgGUID: 6T9iY46pRGi9Ps2Zb+C89g==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="39993603"
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="39993603"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2024 17:24:04 -0700
X-CSE-ConnectionGUID: K4xAFkX0TlmEdum27SHPNw==
X-CSE-MsgGUID: +rJPYsLST8SF2Ugn4MdHDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,163,1719903600"; 
   d="scan'208";a="65866455"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Aug 2024 17:24:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:24:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 20 Aug 2024 17:23:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 20 Aug 2024 17:23:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 20 Aug 2024 17:23:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RKN8MwpMl8DyRBtEI8ZXgb+f50OWEfIRHmyjuT5DXS6EQI/X/XYuquVH49TQ8SkvVFQcdOJAT1O7dj6LHFLiRq/WK6IvsOjy3b4sCs8OlJL+DItw33/DIggB/1k1GdHAWwXms6m/oqkanBZC6S2nbM2iZ585KP0eiVVnvhgsaSWOu0pn53qLOwh8AZenhOE0heJJ6jRcjMlXtcgpxvqkB3+rNJmR0NGCR6K6IK29YmSg/izy7Vi2pOMBgKh8Yawav8DD7Ma7uAHWXKNRFcJWbCkesFtWoRdrNU5EP+IGBqOF52PWtZSdFT5talv1hIe71pZaRKTMt67DRRtZfd2Ihw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5HeapFHauFoTGPP30Yg2OSa4kFMO8ZkUQCbkGiQBiFo=;
 b=QRNulKHLv/+G5VEn7xy6R137tHcXqgm7MeKjBl2oE4k4vR+Q2zkFKW/g/QKkfn4Vk+zH4oyD9lo1B8PYQlPWZIfsvAUVwqAZF9FGYmaG5nhvrKYH/Ncw6wDoStExr6GAZdRIsINlwlTMVoO+U5JY4IUdngPGgGusGpmKhFHdN8jIBk8CjxtWGlbbdd0xlrhnHmLWGnQYDpGCMSGg8pNAbfQkxVItJzX/RZJpQ0fAGXeM7yYG+4BmvD/Oie+AOOdIWlktBZla68I1NKkduee3sGlYoQTzr0uBHSjRY3tRZ5UrxaLU018yv7DLySJi9FAGcaXq/TWhedgPyGgstkAGiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6066.namprd11.prod.outlook.com (2603:10b6:8:62::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Wed, 21 Aug
 2024 00:23:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.7897.014; Wed, 21 Aug 2024
 00:23:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Thread-Topic: [PATCH 13/25] KVM: TDX: create/destroy VM structure
Thread-Index: AQHa7QnMPfu1hYwqqUWmu9DbeieC5rIuuWQAgAItR4A=
Date: Wed, 21 Aug 2024 00:23:42 +0000
Message-ID: <850ef710eac95a5c36863c94e1b31a8090eb8a2a.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-14-rick.p.edgecombe@intel.com>
	 <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
In-Reply-To: <e7c16241-100a-4830-9628-65edb44ca78d@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6066:EE_
x-ms-office365-filtering-correlation-id: 9c5771de-5ac0-48b8-1af9-08dcc1778328
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TWdacm1mVEJMcWphT1l3M3dUYjI0Y3VOY29OR2ZxV2sxZTRQeUhYUS9QTlVL?=
 =?utf-8?B?TDdiM3VYUVBTRkVHZWkzNUdtZE9TZ1FWNXhDWTdjMUhWR05zMDZOeVFlVnEy?=
 =?utf-8?B?N2YwUzVSZjRQVzVvemMzWnNIUk9vdXg1eUoyZUxhWWY2NDdqOGRYOWQ5aCtP?=
 =?utf-8?B?S0RNZG8yM3FrNXRhTTRKWGtKMFRrSG03TGNDamx5emhOUUNkdWtxNDltaHMw?=
 =?utf-8?B?NlA0dnZpdFFob1ZiZ2xwTGJTY1p6ekNZZXVYTGk5ZWNOcmxERFhKUDlLLzBh?=
 =?utf-8?B?engrZ3hnd0Q0V1FoeWZNYWJNNlNBSXFnSlRpL0ZhM1RHY0xmMjBhKzFIcGFa?=
 =?utf-8?B?aDU2QmQ2a01mOEc2Nk9mWktjU3V2U3JVMjJDcFY5T1BQYnA4dno1ZDhSTDBw?=
 =?utf-8?B?Rk11bUU3TUFpRzA5K0hGbzc2Nm9PQnBUWHVybGZQd2dRN29BZ1NjK2dRS2JC?=
 =?utf-8?B?R05zQTcwTGhkQ1JEcDBYYlRhaGgvR3BkNkdNUFFFMkFpc1V2eXNwWjNYQllY?=
 =?utf-8?B?UW1ZRU5PK3pFdTdkVW5IZW9oTytBNUFiRzkxbUc1KzMzSlA4VGo2aXlSUUEv?=
 =?utf-8?B?UEI4Yzg5NWNKY2txZ1U1b2xRS1cvT0tDdUhBdEdVUUNLdVNZaHcrZmhLSGVh?=
 =?utf-8?B?cXlHdVBuKzk4aXR0dkdWVHRWMHRueDBhcXE4VWpDTS9ocTVhK2pWM2xpNjRD?=
 =?utf-8?B?UC9wTFpydjljOG9VYW9NQU12TDBSWVRncUEvSkNsQVIxODl0blhQQWxpdTND?=
 =?utf-8?B?MXNnRnA4bHlRRFUrRXFMV01HU051TldBOHRlZ1VzUGRCeml1RlpVengwRjJW?=
 =?utf-8?B?bStueFhMam1kcGhIN1dVYXRTdWdqNFpYVlB4TnVLT3RaQ2Njc1lCQ1FIaHRw?=
 =?utf-8?B?TU53QXlKQmdTMkdzU2NxcmJSaGxLNm5qN25HZzVDMG13R2JGelBxdUcxMkE5?=
 =?utf-8?B?UzN4QWo4ZTVXTE90bVp5c1dSQ2pET0kvQXlDdUNEYy9mMHM2S1QyOTdjcTcy?=
 =?utf-8?B?eUlIMkcwSFZaU2tSY1MreHhTd2VVZTJ6aFBmZThJN2VvV3Z2Q0cxTXZlSEp2?=
 =?utf-8?B?aUJNdm9tQTlaUm94K1EwQTB2RDZ3SU1kcW83T1N3T0xCUmdGclpDalZnUFZK?=
 =?utf-8?B?dmp0aUQwU2thNjd2TDJWWjBPY2QrdHpPM3FYTkQ3OG1YUiswZmVoQWJ3dzFY?=
 =?utf-8?B?MklQcDhFdEdiWm1Xa2VsRU9seDNNUkUxSjRPZXlxTUtOcXN0OE5TYkhxMDZO?=
 =?utf-8?B?OTIzQUhnRDBvNUtyNit3WFBWbFdyODh5dHR6K3VPWitNUnZaNTEzRUJYbUhP?=
 =?utf-8?B?MHgyeTRsV3RYUlo4Z0xaT1hPMnoxVU1mQS82eTlueWlZaW85MmRleFA2bTJa?=
 =?utf-8?B?cWlabHNQbyt3ZjlaVys2eWZzcUJPT1dEaDE1Q25XNmdEVjRGUkZsWklEZ1Iv?=
 =?utf-8?B?ZFFOK24vNUx3cEhaMTAxenFjRFF4d2tLR096aUJTdm84T3Bad1lWckVnRVVE?=
 =?utf-8?B?QzlzSFpUU3BzYlRsa0l3d29ra0RpblNhMU4vcTd6UEY3dlI5S1VQWkRtL0Iy?=
 =?utf-8?B?YUxLWnd2QW1KNGJPeFg4b1IvOFJJbitlSEJLcFpEMzcyTEJDd0dwREc3MHBt?=
 =?utf-8?B?KytXMGZwOTd2OXRNVndaamh6ZkhKR1N6VjNCb0tlczIyMitxZll6cG9Dc0xS?=
 =?utf-8?B?V0FNUS9BOWpYcVpDNWduVkdNMWovVFFIMTBRV1hIQ01obHNEbGFqOU01TVVO?=
 =?utf-8?B?QlltS1kya1R1QWdna3R2c2Y4OGN5eG1lb0U3eElXVFlXT3VhenRZY1d6Ukwv?=
 =?utf-8?B?SzUvb1NxZFRhMWl2SkpJb1R5Rm1DSzQxQUpJZHhObkZsTTV3L2xwL3R1VjBo?=
 =?utf-8?B?Z2JZQVdUaDdick5WemNJeFVob1dOajRYREo2Z1RzdXVjNmc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0Y2ZzBZSE9wVi9EM1prRjIyNjVJbjFMWExxK285SzFyb2V4eVZTMmZ1OFhL?=
 =?utf-8?B?Rnl3VTF4N093TjNCRkNkUGJXSVQ4SWg1SWdxd3p0TWo3QXNQdnFMaHFNSDM1?=
 =?utf-8?B?azlFMVpxb3NIMlJvbW9BMnllbzh1VllWUzBicUxUOVBwRkx3SnJKaCtsSGtR?=
 =?utf-8?B?eU00K3QzWENsaWlGdU5ZTUhPdzc4RERrTXQ0WXB5Q1BvbWltVmdXSlE5TlZZ?=
 =?utf-8?B?UFRxMGQ2Y3kreEJaaVRqOGZTV0tuSVFadGh5eVlJZldkSlBiYUVaVlJLeXdp?=
 =?utf-8?B?dysvVkZ2MS9Ca1FldGVZWjZ0U3Z2RGJIS0kvMVJrVCtOLzJPUDVlMG9OdmlU?=
 =?utf-8?B?VitXQ1N5SlFELys0TDlsS2ViODBMTmhkQXAwZllMRjJjT08yM3BhT2JmZ3Bk?=
 =?utf-8?B?MnFoN2NSaDVWWkExYkYvR1Z4bDdKS2ZqeWxGb3NpNXMydXgwL2E0RHYzYzdF?=
 =?utf-8?B?SUpoT0l1WWVKMGJVNS9wNmdUaC9LNTJXWkRiWXVNRUk1MXJiOTY5L1hkNUNT?=
 =?utf-8?B?VGdLZnZtUHUrNjdmOUNEbDFlV1drT0c0bEw1QnJ3WC9xWUNXOURQRlFiU2pp?=
 =?utf-8?B?TG1Jb0ZqY3lWWlUveE0vcjRhTm9YQld5Q1N2Rk5ES0lTUEkrdWdJbXN5bWlU?=
 =?utf-8?B?SjRQOXp6QXNjbjZUNkYwUWxUeGR1RWFFMHhMNUNZS0pvRW5NQzZFRDI3RHEx?=
 =?utf-8?B?eU9UVjNFSjZCZm11VzJMTy9KMVNRTmpZdHVCWVZmRzhTeHdwbmtMUEtGZDVJ?=
 =?utf-8?B?cnphY20zcWV0QUdzaG90UFFheUZVVmtTblMxUnhVQzhTZkhuMy84VGlJbzJH?=
 =?utf-8?B?S1lmSGVSbm5iYjZ6cWNYOWVCdHhQQmEycU43WHJFSk45R0pSa09GanRseERU?=
 =?utf-8?B?MDNBdFZ6eHpYcFpBK0xlbDVpSXJDeFZZOU9qZ1BBaTRQd3FTS2JaVkM1L25P?=
 =?utf-8?B?OHhFSTc2LzhNTTBHMWUyVEdiL2dpM1BiblFzazJWeHRDcnRjZm9BUTBMUWM5?=
 =?utf-8?B?T3VEbmxmMjFGR2k3VzdGZUNEMXhrTjc3ZnYyVkhCelBCODBsbzl5b2srMVR3?=
 =?utf-8?B?MitLWEdBekVlUEpHcWR2QmpCVEREdm9vU0pjTjJ0MVJoWkhGQ2R0K3BKV2lP?=
 =?utf-8?B?STZqOGp5MlpRVDJTbXRVd1dRem5qOERFWFYzdGd1UGZuL3ZuWjNvSWVQQVAz?=
 =?utf-8?B?ajF0eG9sTjRDNDd4Y2pkWVcyc2VtazNYQXRwS3BSSVZEdEY3VFVaT1Q3RWE1?=
 =?utf-8?B?ZkZJZG1GcTh3VTVGa3laSXVMNTArZ1dsMko3a0tTUTYwNGFwdmFXYnNoeFp1?=
 =?utf-8?B?bDRqSmhNMEtqMFI4RGg0VEFsVGVSY01MRjBoNVlGYUFUVndsemNEN1FUM0lw?=
 =?utf-8?B?eU51YnlzRlRpQUx1ZXZtTndOclFscVdQeERCMk84MElEeUxFOEpTcVE1VnZX?=
 =?utf-8?B?QUZEZEtaSGViZzJwdURadWdaRjRHdEhYQ0FTd3ZONytQWWx2SklubVpTakZq?=
 =?utf-8?B?SzlnUFVvM1BOMFBDUUwrbk9hb3hCZ2tBTHlxUExhMUNkcFBIbThpcm5BVGtj?=
 =?utf-8?B?ZjZtL3Y5Y3pOWkRUbDVCcWdLakxQTlA4Z3J1d0NFenk1bnVGVWZFZDNyWnhD?=
 =?utf-8?B?QTBYZVphVXVJWW4zY2N6MlYybk9uSmNITE84OGxYRm4xaTBSbDdYOXFVZE9v?=
 =?utf-8?B?MjcyUmdzSCtaWFo5bmRwVXJKemxUR0lJOTFtZ0ZUWFhxREpnWE5Zdi9nQ01i?=
 =?utf-8?B?M1ZXNmdHb0taRkVhSEcrNHZLSHZOaWpidXFRR3Q1RnFlNTFRcVBhV1FXSUdp?=
 =?utf-8?B?QnJmZ1BUekZ0WWwxRTNQMGVvS3pwYlJSOE5pWjUxdXJxNWdVWHRaMTAyNmlr?=
 =?utf-8?B?VVMvUGw2L1RGZkVLZDFoYWN0UDBLVmdyS1Y4UEdjbHN4WmRIS1hwUGZxeGVC?=
 =?utf-8?B?c25TQVdneDhUbnh5UGVvOWQzT2ZqZmJRQTNEWGh3RExzZDNaQ2lpSkZ2YTVm?=
 =?utf-8?B?a2JrVVQ4cDZLQlhUVW8raG9yK0MwKzI1bjVOTU9ycGRtNGY1OC9NdjM4Tzc2?=
 =?utf-8?B?ZG1JUkRDRXZNNzlFYWJnOUE4a2YyY2pqYWVGdEZPRWVYazJVdHM1MTI0QjlG?=
 =?utf-8?B?U3ppd1JpSGVlVGI2TStkQVBJc29wbEp0N2gvbDRhSUVwVnlIQ09NN3E0TEVm?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66957F73B8C8F54EADD8D5B38CC07358@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5771de-5ac0-48b8-1af9-08dcc1778328
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2024 00:23:42.4999
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SgsCgKh8Dsyy/ljqi63o7E0zA3+TRggQNXRSd14yZPLGoRsZQSXwCJneyfHVErNAFnyGTZcYBCDA7IIUJgK7d58cjmVAEEttth8DIBkVTPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6066
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA4LTE5IGF0IDE4OjA5ICswMzAwLCBOaWtvbGF5IEJvcmlzb3Ygd3JvdGU6
DQo+ID4gKy8qDQo+ID4gKyAqIFNvbWUgU0VBTUNBTExzIGFjcXVpcmUgdGhlIFREWCBtb2R1bGUg
Z2xvYmFsbHksIGFuZCBjYW4gZmFpbCB3aXRoDQo+ID4gKyAqIFREWF9PUEVSQU5EX0JVU1kuwqAg
VXNlIGEgZ2xvYmFsIG11dGV4IHRvIHNlcmlhbGl6ZSB0aGVzZSBTRUFNQ0FMTHMuDQo+ID4gKyAq
Lw0KPiA+ICtzdGF0aWMgREVGSU5FX01VVEVYKHRkeF9sb2NrKTsNCj4gDQo+IFRoZSB3YXkgdGhp
cyBsb2NrIGlzIHVzZWQgaXMgdmVyeSB1Z2x5LiBTbyBpdCBlc3NlbnRpYWxseSBtaW1pY3MgYSBs
b2NrIA0KPiB3aGljaCBhbHJlYWR5IGxpdmVzIGluIHRoZSB0ZHggbW9kdWxlLiBTbyB3aHkgbm90
IHNpbXBseSBncmFjZWZ1bGx5IA0KPiBoYW5kbGUgdGhlIFREWF9PUEVSQU5EX0JVU1kgcmV0dXJu
IHZhbHVlIG9yIGNoYW5nZSB0aGUgaW50ZXJmYWNlIG9mIHRoZSANCj4gbW9kdWxlICh5ZWFoLCBp
dCdzIHByb2JhYmx5IGxhdGUgZm9yIHRoaXMgbm93KSBzbyBleHBvc2UgdGhlIGxvY2suIFRoaXMg
DQo+IGxvY2sgYnJlYWtzIG9uZSBvZiB0aGUgbWFpbiBydWxlcyBvZiBsb2NraW5nIC0gIkxvY2sg
ZGF0YSBhbmQgbm90IGNvZGUiDQoNCkhtbSzCoHdlIHdvdWxkIGhhdmUgdG/CoG1ha2UgU0VBTUNB
TExzIHRvIHNwaW4gb24gdGhhdCBsb2NrLCB3aGVyZSBhcyBtdXRleGVzIGNhbg0Kc2xlZXAuIEkg
c3VzcGVjdCB0aGF0IGlzIHdoZXJlIGl0IGNhbWUgZnJvbS4gQnV0IHdlIGFyZSB0cnlpbmcgdG8g
bWFrZSB0aGUgY29kZQ0Kc2ltcGxlIGFuZCBvYnZpb3VzbHkgY29ycmVjdCBhbmQgYWRkIG9wdGlt
aXphdGlvbnMgbGF0ZXIuIFRoaXMgbWlnaHQgZml0IHRoYXQNCnBhdHRlcm4sIGVzcGVjaWFsbHkg
c2luY2UgaXQgaXMganVzdCB1c2VkIGR1cmluZyBWTSBjcmVhdGlvbiBhbmQgdGVhcmRvd24uDQo=

