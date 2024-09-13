Return-Path: <kvm+bounces-26861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F4A09788C7
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 21:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C27BF281252
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 19:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8317514659D;
	Fri, 13 Sep 2024 19:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="niVi3oMU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B86F146580;
	Fri, 13 Sep 2024 19:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726255153; cv=fail; b=InfJ/2HbkvUOjLlPxtgMptq/cnZO7xHlSbwf06sYRwCXdxqY0K0tD+6tStIhZAluRr9JOWZbzn5CldTMvVpYuI1a/vQ8SN9P7ffug0X68Xvsa58rTuqiszUgR4fWe2FxgZx89wgrA5BzhOmcnZpVx65WMYYrdMaZXwHPMxhfiZk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726255153; c=relaxed/simple;
	bh=TsHa4Av4HEtfrvcspkbWub0k79swcqo6gMGtWiDRYMA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CmEUTENT4XGvlx1mLVfCOKm3UkuhVTuiRPCZbBG/s7IneSWTBSWxM8/gkwS952vWikdVP3sJBTZzuHETv5vBHck8x5U8V9/De/yZiQivANBiBjAPi2oU7vZ+rJUp2gMnFyWym2AplnACWg2Tq467BRCutUsdZLTgq1g2lbFf1Mk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=niVi3oMU; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726255151; x=1757791151;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TsHa4Av4HEtfrvcspkbWub0k79swcqo6gMGtWiDRYMA=;
  b=niVi3oMUdHOVchd497QA6Lk8og+aMvhgwS0aos0E34/Wqxj7yI0V/0Vc
   F76N0mrxTj2abDMYXOZwjb7m+tfe92bcgnVeg6mFr5QGT4LJr/nBlngpy
   xWjf52lugha4ZYGjM4Kx4Dn23aG3e2hp4KT+DgkGDVUK5cYQ4O+qldfC8
   FfsliF4E7jSs+V4WBCgb5gKOxJI4yO5Uu0Jvd/fEcoh6ybJMguzls4ciS
   rc78iKtQnT4PN2OMpcUOxW3VsVQwmrEgdyJs7fYl/7UPi5u4ZHfu3AUb9
   Tk00jap7I60jgzCw+a9gFrevSnNi+9TA8RtZ416+KC0Qfd8P41Ox77dii
   A==;
X-CSE-ConnectionGUID: oFKIUY8FRUuZDHAmrTkPAw==
X-CSE-MsgGUID: pbF6LHtkSB+B3KVetYENdw==
X-IronPort-AV: E=McAfee;i="6700,10204,11194"; a="50584105"
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="50584105"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2024 12:19:11 -0700
X-CSE-ConnectionGUID: h7sP6ZV8RwGsbGKIxjFXZQ==
X-CSE-MsgGUID: QBhgsXdARnyLAHLEzu4NHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,226,1719903600"; 
   d="scan'208";a="68672014"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Sep 2024 12:19:10 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 12:19:10 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 13 Sep 2024 12:19:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 13 Sep 2024 12:19:09 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.48) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 13 Sep 2024 12:19:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u7+9Xde2Eh6vE3c6rrc9wutZ4raRgJswNkVRBO3f66XzqxgIcxcUJHm08QvrtEJh//mTEQU/dbEgt+RfNnx3pIC/dr6VMwvsAaovkexniIlIhdxzqyJufqRlJ2k0CX2MRHxp08moF3isH47ROJ8keJPw48z+2fGnfnuyKYWDARxdC03en0lvMOFZOa8Dmk4NeEgZ9LDTCd6iKN93A/MOWFEV113hK50FjlxVMP47GvSQcySa/S0cZOjFDWLnI2uc+T1TKlgLUu6yAVy7I3LBAs9YwZ+EBwGtN2uZqWIanleBhkXPEAaCd317Uj+rRECgJhVpKXwY7qpEY2PHl5Fdpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TsHa4Av4HEtfrvcspkbWub0k79swcqo6gMGtWiDRYMA=;
 b=lSsmXKe+ds1a4dyNM/UYSnFSBTCk4t9DmqSyySGG8G6Q9DLG+aXMQNMhJaLAcJ/AjCt117GuL3MIFiFBLVa2oubOkiRrqzF7oVuIyBINOzrqbw2PGvVW5UoSuz9UmCOTnIFluuB+hd6ZMr8ZYr5h6bImf7qyTTGLA5XvuGEVxGXIc2ezmaxCKGX07j+fpDcK+N18UXX1OHZ5IGpLJwFx+4w26317R4rrO2LbvEL1VZX5FMZUoh2czSuDhhfehX9FovGw9dYGd03qUO7xTpXnNLk1Z3qBSVCgRe7l6ljaFGzOYjVRhZ3z6pwjRKztkw5liXFspMl5YCfDQRLL0YmGtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5805.namprd11.prod.outlook.com (2603:10b6:510:14a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.20; Fri, 13 Sep
 2024 19:19:06 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Fri, 13 Sep 2024
 19:19:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIABDTgAgAAL3ACAABXhgIAAC2gAgAAItQCAABS2AIAEHmMAgACTNQCAACBvgA==
Date: Fri, 13 Sep 2024 19:19:05 +0000
Message-ID: <4bed8c0579298fbb0767c04b75cc9c3be0e925ad.camel@intel.com>
References: <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
	 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
	 <Zt9kmVe1nkjVjoEg@google.com>
	 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
	 <ZuBQYvY6Ib4ZYBgx@google.com>
	 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
	 <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
	 <ZuCE_KtmXNi0qePb@google.com> <ZuP5eNXFCljzRgWo@yzhao56-desk.sh.intel.com>
	 <ZuR09EqzU1WbQYGd@google.com>
In-Reply-To: <ZuR09EqzU1WbQYGd@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5805:EE_
x-ms-office365-filtering-correlation-id: e4d2f883-5cbe-4770-3fad-08dcd428ef5c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VmxZcnAzellJclJLS212WmJUTnBKK3lqeWRwbG85MjV1ZlBDQUVwQkRhMWZX?=
 =?utf-8?B?ZzMxOTREOE5UdGJPR1ZnbVpjVzArQSt2VW5rNElsSHAwc3ZmWnpjbWJMZFox?=
 =?utf-8?B?MHRqK3pxVjU2L2drWnZ2MFZ3R2ZCMjdraHB3bTRPTEplN2ZVbGd6MmJNS2Z1?=
 =?utf-8?B?d2FpaU5KVzdHVWJVRG5lbEUwWktnMjBVcGxoWTB5cDhvTUlFcGpBUXBHRkpB?=
 =?utf-8?B?bjVGUldRSXRFd0wvMFZKYS83bi9hbmR1alZFYysrSFUwT0U1NDVaeVhMWmk5?=
 =?utf-8?B?OHUyNDNDUnJnQW0weGwycUFocDlOeEJHYlg0eFZSVkxkYkpWQjJoNXJJU0U4?=
 =?utf-8?B?UzZJMEVLVkdiSEYrS1RUVmxOYUVpRnJ5Mk1JdzlPalhyem96Vzd4azlaSXhM?=
 =?utf-8?B?Y0hZcXduS3JhZ2RrZ3NldkxVVzVtWmI0V2JSWUljVzc4OWxES3FUS3BYem1Q?=
 =?utf-8?B?R1JxYUorbXEwZm9DQi9sVllmeG50Zk8xYUNsZVdxMTNGbnN6UGFBeGNaSFQz?=
 =?utf-8?B?Y0tERExmeVlhOUFrdG9EQ1JoVWNGbWN6VkZ5VE1TM1VyMGd0WTgxbXJuTXBC?=
 =?utf-8?B?QzhmdmZ2b2J5NGRVaCtrYy9RS0ZNQVc2SXVEb0hYRU5TVG01YUhUdHNzT2E2?=
 =?utf-8?B?d0pTQ0lkTDFPaDlTdkdaR0x6Tk9NcEtNVndURmd3cktDRnpvT1QyNmRHSStn?=
 =?utf-8?B?UTRPTXliVXBjaGZlcS9RenhkVEZxckNueEE5eXhBaVRtWk5VbHI5YjhkT3Er?=
 =?utf-8?B?Q2ZhN3puaGpEK3pVd1FnVDZUYml0OW16K1VScytzN2dwTW1TRG5EWjRqYzFF?=
 =?utf-8?B?em9rRDBVTU5wM1ZpMDRHaFhrQzdDM3RyeHpSTllDY2M5ck9nVWdoSXRpRWlN?=
 =?utf-8?B?aytxaTg2ZXJERXhPNlRIckhNUktWYmZQdkZYTlRKdUdXMmM2WVIrSGhmK2Ix?=
 =?utf-8?B?NU9tOEU3K0lsdGwyT2kyNG83dy9UaWJTOG56VHBqbkkzT1BlWkxCU2o5dlJ0?=
 =?utf-8?B?T3gwNmhKSDVCWjdpRHRnRFVqamZJL0JKNTdlWjlEYXhTWExYNnZlNGhOTnRz?=
 =?utf-8?B?ZFQzQ1l4VElLcFFqM2I3QVJTL1E3a01qdy8zOFBKcnlsemxJQithTFhZcTBn?=
 =?utf-8?B?bkJCaXFwRW1GOEtzU0VUYUZ1bUUvdXNKVGhyYlJIMXBOSVB6T0hJbnMxWnJM?=
 =?utf-8?B?Q0FTL1dXRVBHQzNoSjU2OHNvZnZyelo0MXIxT2NxT3FIdG5GVUg0U3JBZFQ3?=
 =?utf-8?B?TVVIdGplR3c4eWQ3UEpJWlJINGpzemhmcUtmay81blBjTmRNeW15UXhRblJ4?=
 =?utf-8?B?RkIwTXYvQUsxRWEvcWszOHF0eXRQa1Q0Ym1FekRmZXdQOUJJN2l1UndsTHkv?=
 =?utf-8?B?QXp1UUlsaktHNUZ6VE1VemhHSE5HZFhZUzZHYlIrbXArMFBLazBxVWpCdU9n?=
 =?utf-8?B?bzlrSitDcDFCT1ErSDRGNGtTNGt4a0FMSDlBbU9OWElKQzByeitreU1BMzlL?=
 =?utf-8?B?THNFV21ERGdMbktpQ2U5blpJb2tObCtuZmpZVGVxdTdSMWZkRkFQcVVabDZ0?=
 =?utf-8?B?WDExU2huSGVPVXN5ZGs3WUxQTFlOODlzWGliZVpOelNGSGw5NnBOM1dDMzc3?=
 =?utf-8?B?OEEwSzhmcmJKSnUwUTB2U1FxSXNNSENHcHpxNzdIZGpzbWEra3RHNERNbHFE?=
 =?utf-8?B?VDNHdkxJS09UWDFpQzl4Y0RqUGFqY1o5RHhjajFyam9MS0t4UnBXVVVMSll6?=
 =?utf-8?B?K1c3ek1sMjBwQjNlM1UzUGFCT0xHcUdRVVRzU1MwWFZqSlVMNDBTdmw0eGhu?=
 =?utf-8?B?bFJJQnRwbFB6cHRUYjIyaTg3dkVmRWU1WDJ2RTREdDh3Q0pqSkZGSEk0ZGM0?=
 =?utf-8?B?UzhoUVNhUXZ4Z2t1QzZPT09UeW5IQmx4c0wxWmxBOWxDZnc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWdnc1JuR0wwSEpPNjJHbEVvWjZiYzJqaGRaQ3liMU80bmd6bUx6VXN0c3NI?=
 =?utf-8?B?TlUvNW1US1RWaGhjWjR4ZS9yelFBbGc1WUR5RFI2eGQvVUxsRkhjTFVBZjdZ?=
 =?utf-8?B?VlFsZkRNbGlicEkwTkhKRWRpbGhsNUp6bkNpbnA1RFpOV1BJZ0ZoSE1xUGZJ?=
 =?utf-8?B?YkJ3emplSjhGZ0cxVE9NWDNjSUY2c0tqY0t1dmtZZ0Z0VjhMOUdCUG43cXdC?=
 =?utf-8?B?bGwvWGZXMUpnbGNRM0M1SDBqanluZzNHKzZtVXdRZTUwcU5MYXNuOXYwL0Rt?=
 =?utf-8?B?TjNzWFFpeXZ4dUQxYXU3Z1NvLytIb2g1YXl0N3V0UlJ2U2JKaWNlYUJCYk9X?=
 =?utf-8?B?QzV5YW14UGd2OVBSU0FXKzE1VGFIMVRPWjJPY3puSGxwMWEvcDJoa0FQZ3Fa?=
 =?utf-8?B?OXpoZHlkVVNGVFBJTWJ2c3htUkZSQXhrVXVEb210Kzc4UXhBbkdoMm51dDVI?=
 =?utf-8?B?QSs5aVlqNEE1S2M0OHdqV2FYRnYzdHBrTkxQRDNXakUrUVdBbVZ4MG1HSU9j?=
 =?utf-8?B?VWNpVjdpWlNwVGZmSDNQazFXTmtwck9Lb21ybWhUQnRqOWZsallqcGFQcUFL?=
 =?utf-8?B?c0RjQzd2ZEZ2MkZtMEhSekJuV0V1USs0U25BTUthdi8wOExiTUNXNnlvV01l?=
 =?utf-8?B?SGl6UjBUNDJZQ1A4TXYwMzhsVzF5SFdWdEJlMk8yR0kzQUoxMWpGRExnVVJP?=
 =?utf-8?B?TzVBWDlKNC80QmRDS2dqYWRJcW9SdlcvejFuaEsxNE9MdHR5bmZBcEFVS2Fi?=
 =?utf-8?B?OHVoMGIvVEZnbHhiQWxTOTU5cis1YUFxYXE2MTBMKytHWHV2M3orUHJ6TVZ2?=
 =?utf-8?B?TnJjRUtFY2NzdHdCTU1pZkhiZ3RJQ3owN01LRWx6Ynh3eElJcmRIVHZiMlFy?=
 =?utf-8?B?N3g3ZDF4RUpVVWJNMjc4OUp4N3U4ZWk5RnlnMkdxT0RCYkNQQW12ZU85NzhI?=
 =?utf-8?B?M29LWCtZb0hjNHVFVFQ1am1GRjZMOGkwdUFTTVdsVVVvcFg5eDZ4dm9yMHZE?=
 =?utf-8?B?ME9jT3ZoOWQ3cVBOa0Q1RmhNVVVjdDB0YWlGNVV3eHhBWGVCNWhDenpHZ2ho?=
 =?utf-8?B?VzVsWkFWV2RCdVdEajc3akl6S05nSEloRm8xb2Z3LzdmRWVtd09hQjVnT0JR?=
 =?utf-8?B?YXowM0xNNHRNcS9iTXFIVkNlZWZWTEg3UHprK0dzS1h2RzljZmhhMnEzclRI?=
 =?utf-8?B?eWp6TzFyYzJDTzJGbVNWMm5FVGxndHYrQm1ZL3htSkVEbTg0NDliNTlYdjBS?=
 =?utf-8?B?bFZmby9qaVp1ZEgydTR4ZVB2WEUzb0VsS2hXcXhrbFU1ZUk0RWhLcmtPYWVS?=
 =?utf-8?B?ZURmT1hPcisyb081ZjNVTlFsTE5zeUJ4UWhhdk1iYVdwSURLYmlqZFNudzRX?=
 =?utf-8?B?NWsvQ1dFUXRORnNYVnlYT1piQ2p6bHdQczlQeGZWR0dUTE5XZzZaSm5MNkRF?=
 =?utf-8?B?UmtnZVpibUtrSktDc25LR1RCbzlsRmpXRllFNE15akVCSUZseWpzZWdjQXc3?=
 =?utf-8?B?aWFEUCsrQUl1REJiYkdMc3JYWkRzU01RZWZsakV3dU5xL01lQ0pmS2tKZzQ2?=
 =?utf-8?B?Q3kycjM0Nm5FUDNxUHFZWUNlb2Z2QjZyTmlQTS81SDVZcy9HT1VmUzRPMkVp?=
 =?utf-8?B?a0pDclhZSWtUTVdaRmx0ZUVvUUl4MStoem5zWjJWOFZ1cVcyVXFRKzFyOEFl?=
 =?utf-8?B?REFxSDVlQ0ovbkNhVXJRb2RqVHM5L2RPQ3RhbDMzRElMcEllTGhVMHVLTHZS?=
 =?utf-8?B?MTNsT1JNQ3NoQ1lUa0VTYkcxUmFmVGN6WmZ4VlFxNk5PTitXZFk5R1R3VXFl?=
 =?utf-8?B?NWdZRkNsYjgreXBUNk1QR245WWNyOEZlWlVMcitKbW11MTF2eGMzRFVXRmV4?=
 =?utf-8?B?VDJXcUVvcGYvcHNpSEVLL3VLTXYvM1R1ZThzRU43RklNZWpFcVgwTG02dDR1?=
 =?utf-8?B?cjJoV0NGRU8yME9aazByK2JEVjJkdXNTZDkvMVVNT1hONjc2L0diYy9Sbk15?=
 =?utf-8?B?VkozUHYzYmVjVklDUEFTM0pBeEM3K2Nla0tpRkhOQzAvTklFWlVkL0VyQlZq?=
 =?utf-8?B?Q04zZlQvellMNzh4L09yOWVRYzNyQjR4VUdja2ZYRE5UVmNUN01KRThrQ0xX?=
 =?utf-8?B?Wk9HT1ZtYk9JSEVGZDc2eDN5dGJFRHNpb0Fwc05QbURaQzhTWnIwOWFIa01s?=
 =?utf-8?B?UWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F2AFCDAA407CF4A949B8C514B0DFE6A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d2f883-5cbe-4770-3fad-08dcd428ef5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 19:19:05.8862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XlZiBDjiuMd34ZGU8W3vAi41ijNG7WI8KzGl9fRUGlDUl5ZA3b4VctRHHvVoVVl0f+jmzWpdvw/UIqWmuEs8Bpm4TE66CIc+K9rp0HwkzxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5805
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTEzIGF0IDEwOjIzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFRMO0RSOg0KPiA+IC0gdGRoX21lbV90cmFjaygpIGNhbiBjb250ZW5kIHdpdGgg
dGRoX3ZwX2VudGVyKCkuDQo+ID4gLSB0ZGhfdnBfZW50ZXIoKSBjb250ZW5kcyB3aXRoIHRkaF9t
ZW0qKCkgd2hlbiAwLXN0ZXBwaW5nIGlzIHN1c3BlY3RlZC4NCj4gDQo+IFRoZSB6ZXJvLXN0ZXAg
bG9naWMgc2VlbXMgdG8gYmUgdGhlIG1vc3QgcHJvYmxlbWF0aWMuwqAgRS5nLiBpZiBLVk0gaXMg
dHJ5aW5nDQo+IHRvDQo+IGluc3RhbGwgYSBwYWdlIG9uIGJlaGFsZiBvZiB0d28gdkNQVXMsIGFu
ZCBLVk0gcmVzdW1lcyB0aGUgZ3Vlc3QgaWYgaXQNCj4gZW5jb3VudGVycw0KPiBhIEZST1pFTl9T
UFRFIHdoZW4gYnVpbGRpbmcgdGhlIG5vbi1sZWFmIFNQVEVzLCB0aGVuIG9uZSBvZiB0aGUgdkNQ
VXMgY291bGQNCj4gdHJpZ2dlciB0aGUgemVyby1zdGVwIG1pdGlnYXRpb24gaWYgdGhlIHZDUFUg
dGhhdCAid2lucyIgYW5kIGdldHMgZGVsYXllZCBmb3INCj4gd2hhdGV2ZXIgcmVhc29uLg0KDQpD
YW4geW91IGV4cGxhaW4gbW9yZSBhYm91dCB3aGF0IHRoZSBjb25jZXJuIGlzIGhlcmU/IFRoYXQg
dGhlIHplcm8tc3RlcA0KbWl0aWdhdGlvbiBhY3RpdmF0aW9uIHdpbGwgYmUgYSBkcmFnIG9uIHRo
ZSBURCBiZWNhdXNlIG9mIGV4dHJhIGNvbnRlbnRpb24gd2l0aA0KdGhlIFRESC5NRU0gY2FsbHM/
DQoNCj4gDQo+IFNpbmNlIEZST1pFTl9TUFRFIGlzIGVzc2VudGlhbGx5IGJpdC1zcGlubG9jayB3
aXRoIGEgcmVhYWFhYWx5IHNsb3cgc2xvdy1wYXRoLA0KPiB3aGF0IGlmIGluc3RlYWQgb2YgcmVz
dW1pbmcgdGhlIGd1ZXN0IGlmIGEgcGFnZSBmYXVsdCBoaXRzIEZST1pFTl9TUFRFLCBLVk0NCj4g
cmV0cmllcw0KPiB0aGUgZmF1bHQgImxvY2FsbHkiLCBpLmUuIF93aXRob3V0XyByZWRvaW5nIHRk
aF92cF9lbnRlcigpIHRvIHNlZSBpZiB0aGUgdkNQVQ0KPiBzdGlsbA0KPiBoaXRzIHRoZSBmYXVs
dD8NCg0KSXQgc2VlbXMgbGlrZSBhbiBvcHRpbWl6YXRpb24uIFRvIG1lLCBJIHdvdWxkIG5vcm1h
bGx5IHdhbnQgdG8ga25vdyBob3cgbXVjaCBpdA0KaGVscGVkIGJlZm9yZSBhZGRpbmcgaXQuIEJ1
dCBpZiB5b3UgdGhpbmsgaXQncyBhbiBvYnZpb3VzIHdpbiBJJ2xsIGRlZmVyLg0KDQo+IA0KPiBG
b3Igbm9uLVREWCwgcmVzdW1pbmcgdGhlIGd1ZXN0IGFuZCBsZXR0aW5nIHRoZSB2Q1BVIHJldHJ5
IHRoZSBpbnN0cnVjdGlvbiBpcw0KPiBkZXNpcmFibGUgYmVjYXVzZSBpbiBtYW55IGNhc2VzLCB0
aGUgd2lubmluZyB0YXNrIHdpbGwgaW5zdGFsbCBhIHZhbGlkIG1hcHBpbmcNCj4gYmVmb3JlIEtW
TSBjYW4gcmUtcnVuIHRoZSB2Q1BVLCBpLmUuIHRoZSBmYXVsdCB3aWxsIGJlIGZpeGVkIGJlZm9y
ZSB0aGUNCj4gaW5zdHJ1Y3Rpb24gaXMgcmUtZXhlY3V0ZWQuwqAgSW4gdGhlIGhhcHB5IGNhc2Us
IHRoYXQgcHJvdmlkZXMgb3B0aW1hbA0KPiBwZXJmb3JtYW5jZQ0KPiBhcyBLVk0gZG9lc24ndCBp
bnRyb2R1Y2UgYW55IGV4dHJhIGRlbGF5L2xhdGVuY3kuDQo+IA0KPiBCdXQgZm9yIFREWCwgdGhl
IG1hdGggaXMgZGlmZmVyZW50IGFzIHRoZSBjb3N0IG9mIGEgcmUtaGl0dGluZyBhIGZhdWx0IGlz
DQo+IG11Y2gsDQo+IG11Y2ggaGlnaGVyLCBlc3BlY2lhbGx5IGluIGxpZ2h0IG9mIHRoZSB6ZXJv
LXN0ZXAgaXNzdWVzLg0KPiANCj4gRS5nLiBpZiB0aGUgVERQIE1NVSByZXR1cm5zIGEgdW5pcXVl
IGVycm9yIGNvZGUgZm9yIHRoZSBmcm96ZW4gY2FzZSwgYW5kDQo+IGt2bV9tbXVfcGFnZV9mYXVs
dCgpIGlzIG1vZGlmaWVkIHRvIHJldHVybiB0aGUgcmF3IHJldHVybiBjb2RlIGluc3RlYWQgb2Yg
JzEnLA0KPiB0aGVuIHRoZSBURFggRVBUIHZpb2xhdGlvbiBwYXRoIGNhbiBzYWZlbHkgcmV0cnkg
bG9jYWxseSwgc2ltaWxhciB0byB0aGUgZG8tDQo+IHdoaWxlDQo+IGxvb3AgaW4ga3ZtX3RkcF9t
YXBfcGFnZSgpLg0KPiANCj4gVGhlIG9ubHkgcGFydCBJIGRvbid0IGxpa2UgYWJvdXQgdGhpcyBp
ZGVhIGlzIGhhdmluZyB0d28gInJldHJ5IiByZXR1cm4NCj4gdmFsdWVzLA0KPiB3aGljaCBjcmVh
dGVzIHRoZSBwb3RlbnRpYWwgZm9yIGJ1Z3MgZHVlIHRvIGNoZWNraW5nIG9uZSBidXQgbm90IHRo
ZSBvdGhlci4NCj4gDQo+IEhtbSwgdGhhdCBjb3VsZCBiZSBhdm9pZGVkIGJ5IHBhc3NpbmcgYSBi
b29sIHBvaW50ZXIgYXMgYW4gb3V0LXBhcmFtIHRvDQo+IGNvbW11bmljYXRlDQo+IHRvIHRoZSBU
RFggUy1FUFQgZmF1bHQgaGFuZGxlciB0aGF0IHRoZSBTUFRFIGlzIGZyb3plbi7CoCBJIHRoaW5r
IEkgbGlrZSB0aGF0DQo+IG9wdGlvbiBiZXR0ZXIgZXZlbiB0aG91Z2ggdGhlIG91dC1wYXJhbSBp
cyBhIGJpdCBncm9zcywgYmVjYXVzZSBpdCBtYWtlcyBpdA0KPiBtb3JlDQo+IG9idmlvdXMgdGhh
dCB0aGUgImZyb3plbl9zcHRlIiBpcyBhIHNwZWNpYWwgY2FzZSB0aGF0IGRvZXNuJ3QgbmVlZCBh
dHRlbnRpb24NCj4gZm9yDQo+IG1vc3QgcGF0aHMuDQoNCg==

