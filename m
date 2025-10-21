Return-Path: <kvm+bounces-60705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E0B4BF8282
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19B21485A44
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18EC34E751;
	Tue, 21 Oct 2025 18:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iR41987R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D5A34D904;
	Tue, 21 Oct 2025 18:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072885; cv=fail; b=T0n7Wgb/sVAJoTGysLO3GLzlvXvG+N2E1IkFjZ40TnUYJu/P0lW4kbF69KoBayWsM1CUiaHX9D6aIMyQcEXKmTqbu8RhzB9AJCtZGuzae1h3UDme9K/Q3a6lJdpWoJR6bwNRvwTMkLxwMU+YnVSUXBScGFpB4S+tJtT3n9IZOm8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072885; c=relaxed/simple;
	bh=JZsInYJFaBfxr/7ADOS6v3tgzxzQbdupLuwoeCqbU5M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QqwfRXtXvFuKKoGVtp1TmsOuEFU2zskBEvrv56rXd6osVEYrkoj7hIwvWA6CwYrNUwePxj6K8ng8ipuZTQFNz8K8tXl501FcnR2R19Ne4KQvPJqcDfDIakCz68z9M60kjUBvZS9YjwdUiBZ45KAZk8mmQ2I76sxIuIkelA7uQOQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iR41987R; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761072883; x=1792608883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JZsInYJFaBfxr/7ADOS6v3tgzxzQbdupLuwoeCqbU5M=;
  b=iR41987RwQNS7pqJLRfC4cmBf1zc3h2CGjtrtL2K5zy9aWbgtK8sPsG1
   5wn08FYdeTyi3mIEwubtZB6M2Y0Gi60qnpM8NqPiMraQApMLp/Dir0xzh
   IWcFhzshNhYrAbF9yZLXZJ6k+jaR9njq8Q7JjibWUPe056eJnA2pPah3L
   BJY5k7ccOMyMTUurDOfoB9PBTG7vKnbMH9M1iUUl966E2HTual8qietLD
   BiV+vqX3EtlVgDBztUbJtpFzV1qiwyOY9VPd9nxZFmabMhCzAn5OmTJd2
   4NUxrF0CC/CuczvIye77M03OfA0D3tRTYEDKBjcBdIQNckREGK+NaJNNn
   A==;
X-CSE-ConnectionGUID: lHg0RaT2Q5+9iqP6KLZZSw==
X-CSE-MsgGUID: wDo0lo+/Q4eAV3sVnXR+Iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67074951"
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="67074951"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 11:54:43 -0700
X-CSE-ConnectionGUID: Y0j0npXoSfuudbptgrtp5g==
X-CSE-MsgGUID: +gBHMeuTReytEOCL/EEtBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,245,1754982000"; 
   d="scan'208";a="188950817"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 11:54:43 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 11:54:42 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 11:54:42 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 11:54:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hhjFeSU8cvQIELJSBsRrswaDHWwn8WtM4cl0v9GqHbjilBBXsp5CLcTpmLMKSOC7UvSxAECBwyecjU31Kprgd639KiYmJ4CMDcOv4jCy14drT37B4ghncI94tbhY2osYL1NBoPOpBBbTBiHr94ANrnhTLdi3eht45Hm9Mv819j2+6ZPUtt2QukuOvEZhNyntGy0uImGEIRG1SfNUbU2qaUpsNsjxAq8DI7WEQ/9rsIZkAwKNfPr1S+N0gJ7N4xoGaW8z8Pq/Rs+CVTvb5T4KaLqxDI9ZwE9gTW0zuBcEHKCDqCt7IYb6x+0zCvo5OYszLsRXm4eiDwn/jPuo/7TQvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JZsInYJFaBfxr/7ADOS6v3tgzxzQbdupLuwoeCqbU5M=;
 b=VzcOERw5zdnIWFZDMvitLwnhzh63JjYjF2rlCfMbSSL+FSyyi7pj7SDaqVSeCk27JceRN2zlxuV52dNheUwdT66NBnGS14UjIWQd83+CeAyEY1BpYwNuiDPYsiixqPY5PWOGcRLmsx1/LQ9c2IdscVQH9YnWBB1sGeRnh77gJseuwdZMgiMcQi9EygoIgj8EUSuJ6wBpyPFPaf3wxjVS/cYq9fsxuIEBlOh+0KB04SFypbxOhotmwZ7WUkcaP0miotGe0pJL8W9jt9TeYu0QV2vUzojaVRDgOVqzNXJ1ghrg0XRBdKnNSqbcV5aKjGEUlgZbLqlpM6M1odXcJqI8Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7107.namprd11.prod.outlook.com (2603:10b6:930:51::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 18:54:37 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 18:54:37 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hunter, Adrian" <adrian.hunter@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "hou,
 wenlong" <houwenlong.hwl@antgroup.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
Thread-Topic: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs
 immediately after VP.ENTER
Thread-Index: AQHcPuw06cyBS3K2dkWWncH6yXNOTLTLq32AgAD2cQCAABi9AIAAP8cA
Date: Tue, 21 Oct 2025 18:54:37 +0000
Message-ID: <38df6c8bfd384e5fefa8eb6fbc27c35b99c685ed.camel@intel.com>
References: <20251016222816.141523-1-seanjc@google.com>
	 <20251016222816.141523-2-seanjc@google.com>
	 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
	 <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com>
	 <aPehbDzbMHZTEtMa@google.com>
In-Reply-To: <aPehbDzbMHZTEtMa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7107:EE_
x-ms-office365-filtering-correlation-id: e3e1ef86-8f8f-48f7-6649-08de10d348a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?andtNEQwRlpudUNoaS80Sld5SjNBSW5jdFduSzdRdjFqVWpQSndIbUtMcnhI?=
 =?utf-8?B?b085azZiMGI1QnVmK05sUnBIUTZJOC9qWlROOVBtT2Fxcld5dXFNNVJ5cksz?=
 =?utf-8?B?QnlBd2h4UzBwdm4vc2t4M1BuN2dQREJ5YjRHN0xqZVd3NnpYcENyVjdiZVho?=
 =?utf-8?B?cElDMGRjNWhvdTlJWVY0REZrb1plSUl3N3c0dTRrN1MrakhSOTcxQ0wwTnpD?=
 =?utf-8?B?cDQ2N0dFY1hwZ0VQenBqdU1mVktYTzIvZlM3WW8renBBWDhLUFJSTVhtSGhZ?=
 =?utf-8?B?d0o2ZTJFbWROa3Y5MDA0UFdBQ2JMTmUvK3R0dng2bXFZcE4yWWxCa2sxZ0RZ?=
 =?utf-8?B?bkhNU3dzRUh5S2c0eHhUVzJiaHBlYjZlWS9aN3J2WnBoOGhnMkhwaWJFWTlr?=
 =?utf-8?B?VHUvS1JzNnhaWnEzN0s4ZTRjNmZ4OVluekR2cll1Zi9GYVA5T2FGeGdHWko1?=
 =?utf-8?B?TVhGaTZqdU9mTGFqdzlsMWIyT3JzSkZBYXM5THU1R0lQRnNuZmZLWWc4RlFn?=
 =?utf-8?B?RXRiWTlPRmNyQUpOZTd1WU5lc25hMzh3SFNKL3FVenU2QWZoa29VVHB0TmlE?=
 =?utf-8?B?cmVVSlZNVWhOVnR0Zmxld1pXenVzR1pZenV0Mk1jVmNxR1FnTndOckZ4REFI?=
 =?utf-8?B?UTRhaHphd0NlOFVSQlJHWTE2QjR0aGZOV2FZT1dsQzZCRjMyMTV6d01DWmRE?=
 =?utf-8?B?MnNlVWVDcVlrWDJZaFZWQ21SZ0JONWpUVUJkWk1jTkFkZWoyR20xQnZVREFo?=
 =?utf-8?B?N1N2YlZzZDBiSnRyU1BiTzdtZ21qUmI0YW95enhtRmFST3p4aXpGNG83cXEv?=
 =?utf-8?B?TXp5am1weENRVFdtUys5UTBBSkV1SmJIS2dUTWhOQmJiVDBzMHJyYmFIVXNP?=
 =?utf-8?B?TnJHWHp4ak42NFBmRkVCbm5DNnlPRmFCak0xbDFuZkRmZE1ZR2l2Y01tVW1M?=
 =?utf-8?B?YWlZdW1YMXFkZ3pBU0lqMENqUW84NmdLU3N3MWRycGJMTUNBQkZQNkdPV0ZW?=
 =?utf-8?B?R3lIVnM2a1pGSXF1UndjbHZzNEVtRFN6ZW0xbVJkTzBTYTlwcVQvY3BLcGhJ?=
 =?utf-8?B?NTcralpIeWQ0cGI0VkpZNk5JLy9BaTBpR0Vha0RHM0tCUDk1Z3FjK0tSK1NU?=
 =?utf-8?B?R0k0T2xLWXdlRE05alYvTXVkS3duUDVQb1ZFUmo0cFNPTThuaUpVWWFJT3Y0?=
 =?utf-8?B?WnQ5aDc0ejduWFBSbUpIckY5OGg5dnVDdG9MazFkNUdnRTN2Y2U3Mk9uS1Q1?=
 =?utf-8?B?VnJEdUhySCtCRktoMGk4N1ptL09ENzJIOExUUVZkL1ZjL1lxc3pheWg5WGU5?=
 =?utf-8?B?Rkg0WXFxSGR1RW1mejZDMld0Q3ZHQ0JKbU5JbFRoMGl3bkxPSlBiTG9PR2FP?=
 =?utf-8?B?Rm9ncENVc2RVODJ0YUlNSzhHL0MyRm5ETzV6Sno0bVllLzc2ZzhNT3lUMENm?=
 =?utf-8?B?bjlXVWY0Z281TFFKQVhkQlV5QmhhTlFBazYxUmJrY2t5U0RxTGVIUGZtUWYx?=
 =?utf-8?B?dEM2NUJtOG9aVTZIaFBUSlYySzdQTFREM1N1aWg2SGx2YlFJS3JOSzVaakNG?=
 =?utf-8?B?U1AzMlhtbEJRZmk2dDN1OXVuNGhpQ2dUZVhRTGVBUEFZWVI0Nmw1YnhVMjl0?=
 =?utf-8?B?UWtBbk9UOHVyS2h4SzBWUHc5Q1F1dnRvMlpTL2Q3OWpJaVQ2MXZ1RkpRaUNF?=
 =?utf-8?B?bmtHTWF5Qm9QdjBjdXBOWnJJMUdnTFBQWmpTd2xjVmpNa3ZSMzQ2NEJwS2w0?=
 =?utf-8?B?N1RQNmhlRzBiMjIvdmNkNTdVM1hDQXc3aWdtR2s1UmhuT0RRLzFMWkNXc3lQ?=
 =?utf-8?B?alFLc2ZSRzFZUXN3bFhHckRTZnpEQkRVYk5iaHRlejVTbGZUQy91TFNZNkhJ?=
 =?utf-8?B?ZThrTEdMMnpJaWorbXlVZ3Z1SzVqSlhCK2JlZWV2cmVjdFNDdDFHaXl1VFpS?=
 =?utf-8?B?QXhIckJXNTgzbVdRclNGakhPZUhUSVV5Y292aWw5djJzaktQaU9hNERyUFhh?=
 =?utf-8?B?MGlUaUVwZ05HSzh5c0ZNbTBvZzA4MzN1MmE5S0hQSHV4bDg1V3BRbldKWGwr?=
 =?utf-8?Q?ySyZtA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXJmTVExblFJbXhFMzk0QnBGSkNHNlJ4VmZVbCtoYWpyRkMzaG5CTnJsZk1i?=
 =?utf-8?B?amlhdDdPTTAxRDh6WXpEYnJmVWQ3R001YmQ5a3lEaFl0QXVVb25ZTFQ5MGlN?=
 =?utf-8?B?M1JIcERDai9uZjFpVTJWT2QwZThnRDZOblNSVVBRVUVZQk9KMmtaNkNlcU5a?=
 =?utf-8?B?SGRwMXBHckNXc0RwbkN6WjMrUGZabUhYRVozUElIZW9taGxoZ0h6YzNSTkJr?=
 =?utf-8?B?RVV1QXAzLzhxSWg2MnMyeW9DRVpLWktielRnUGVTSUNydG1yRWx1anZDVk56?=
 =?utf-8?B?RnQweks2b1JZenM5RjJTMUIwOFRQMHQxOVY1OUc5SnQyQktkRVg2eVlxeDN1?=
 =?utf-8?B?eWp5TzdwSVdsQVpLaDR4N0pZQlVUTHZaTFRQTG1DQlRSRmhhTm1YY0ZEbmlq?=
 =?utf-8?B?OFd3bk4rVmNDNjFQL1lJRVpmMXRuWXZTRGRiYzNLTDIvVzY0SEJ0QjVjOEh1?=
 =?utf-8?B?L0VnVUN5U29vYlVpb3g2RnhiVDdnVnVUY2ozbXpPaGtZeE1rc1Erbnhtd1pl?=
 =?utf-8?B?ZTNJZkwzSGY3OUJqT2tTTS93RmllU2RldVF0d05GWi9VOUlYYzVyZkIvTVR4?=
 =?utf-8?B?dXpvQndyQWFJVE1PY29EZmx1VWZoTkJ4U0pkL3pEMnpJSFJuZGdmMlkwK3Fn?=
 =?utf-8?B?aG1lak9DSkZQUS84c0g3WTB3c1hrckhWYnBWSXZYWVhlYVpkNU1NdU9TMzFF?=
 =?utf-8?B?ck5yUHdPWTZnTWxQNHpYOHJ5NldyeFIrQXdEU1ZFZjR5YjdWUTBjNVVyMzNF?=
 =?utf-8?B?d3VVY2IxbEJqZzBpUXlaQkxWS3BIRkMvV28yT2xmNHg5YjREck5BaU5uSFFl?=
 =?utf-8?B?SVB5T3VobWswT2FJcVowQVMwa2tBUmgrSlFOZHhBMVdRU0lKZFhNVmRtTFY0?=
 =?utf-8?B?UTIwYnFKRmtXM2NwVHh5MWtUSmpyTnY4RzFYNE9DSGpyRG8zbnZaazhVb2V2?=
 =?utf-8?B?aThnZ05OQ0o4dUtZUytBY2NlNkd3Umo3RCtlWGlzQ3daS3dsOFQvdk5tR0wv?=
 =?utf-8?B?cGdJOWJoTERCWnFiWUNEU3k4RE5IaUJ0ZmEzeWk2cUV1T2FDVTB2RHgwU2o1?=
 =?utf-8?B?bkxFcUtzVzh5UGU3ck9ObFlOYXF1VWR4NjdndTA1c25jY2ZoSWljbEpjMDhW?=
 =?utf-8?B?ZjlpVTBvRU5LR05VWDdhbHpRNWdlVUQ4SVBibkJhT2tYRGNHSXRzZm5vQXRZ?=
 =?utf-8?B?bUpqS2d0ZlllampUQXRJYURDQkZIRDJ0Z1lQS1N1aGhPWFd5Z0RzVnA5TU5C?=
 =?utf-8?B?dEt0TlR4cGV6MTNPQUlvdE1UNVV4NUYxa2paZXM0MjhrWEdrY2FpMHNpSE1U?=
 =?utf-8?B?bDdUOFByUGszbEJFdlczL29pWjFmcFc5SXQySEdkM09oVGtCMGZ3QTNyVDRI?=
 =?utf-8?B?VlFvMXJrTk5Gbm81cnl4c09qdnRjZU54QW5SbEZGZi84NHpnUytQS1RORVB0?=
 =?utf-8?B?VTl3elUyVDA1aVU2L0FpbldhVnRmcUJya0ZBb1V4ejFvd1h0dytRdW1yK3B4?=
 =?utf-8?B?LzI5U2padDZTTFJUZHk5b3BkbEVwWEcrTkhCNGVGVytmcFd0MEY3TEo5VEQz?=
 =?utf-8?B?WDZqK3RCaEdqU1BNTXNQMUdaeEtHanB4UDNjNzZnS2xwNkJhTWJkRUY2UTRE?=
 =?utf-8?B?NDU5SW50M0FuaGo3V2R6b1BEZi9jSXhPS1lyRlp5RXNTK2Q4bkNSdkZUK2Rk?=
 =?utf-8?B?WUdaSjJnOGdrb1Bjczk5UHNrRy81eFk0MC9DSExVUEN4MWhEWEZRMks1SVJj?=
 =?utf-8?B?cmVlZm1ldG5URG5PZGtzQlpsZGRmL1VORThNS0ZLUk5xY2JSRklDaU5sYVNM?=
 =?utf-8?B?ZnQzcXZCbnlUYmtUVnBOMFh4YW14enJ0cmNjbHAzejNHdTAvTWpxU3BZTUxG?=
 =?utf-8?B?TCs0QXZ2aVFWUmh3QW44MVd4OGtOK0VMWjROR1RzdGNieDlMb0srOTVnTE9T?=
 =?utf-8?B?MkhlSnBIRUVZYjMrRUpUWXVaSk9xZEdSZm1MdDZoeFB3SUJjQS96Q1EyNXBh?=
 =?utf-8?B?VTVKREpucE1Cb3g0ZWNyMldlWHVtazgwZFhrUThyVDRWblhRWUR3TWwrd2c1?=
 =?utf-8?B?cDlISERiVWhWam5DZGI0YnpDcyt4VjgwRXB2Sm43N01FZGRpUWdNRC9YanNw?=
 =?utf-8?B?ems4NHk1UFdIc2ZEK0JyUDczRDdMMEtBYVJPMUFud21rdHdpb0dPanZQUDNq?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF65B0DC8591A74F859C831C10CFE180@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3e1ef86-8f8f-48f7-6649-08de10d348a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 18:54:37.6290
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mj7GPdlv8PkWwwHRh/Qd62Upf6sE3OIjKzju6arnLg+s/NWaW9pYskH+Q3vucpIxztvgACIMIqCmDkSWLkg7ch+hSUnLK+njQLtDhdHwNs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7107
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTEwLTIxIGF0IDA4OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiAgSSB0aGluayB3ZSBzaG91bGQgYmUgc3luY2hyb25pemluZyBvbmx5IGFmdGVyIGEg
c3VjY2Vzc2Z1bCBWUC5FTlRFUiB3aXRoIGEgcmVhbA0KPiA+ID4gVEQgZXhpdCwgYnV0IHRvZGF5
IGluc3RlYWQgd2Ugc3luY2hyb25pemUgYWZ0ZXIgYW55IGF0dGVtcHQgdG8gVlAuRU5URVIuDQo+
IA0KPiBXZWxsIHRoaXMgaXMgYWxsIGNvbXBsZXRlbHkgQCMoJCojLsKgIExvb2tpbmcgYXQgdGhl
IFREWC1Nb2R1bGUgc291cmNlLCBpZiB0aGUNCj4gVERYLU1vZHVsZSBzeW50aGVzaXplcyBhbiBl
eGl0LCBlLmcuIGJlY2F1c2UgaXQgc3VzcGVjdHMgYSB6ZXJvLXN0ZXAgYXR0YWNrLCBpdA0KPiB3
aWxsIHNpZ25hbCBhICJub3JtYWwiIGV4aXQgYnV0IG5vdCAicmVzdG9yZSIgVk1NIHN0YXRlLg0K
DQpPaCB5ZWEsIGdvb2QgcG9pbnQuIFNvIHRoZXJlIGlzIG5vIHdheSB0byB0ZWxsIGZyb20gdGhl
IHJldHVybiBjb2RlIGlmIHRoZQ0KY2xvYmJlcmluZyBoYXBwZW5lZC4NCg0KPiANCj4gPiBJZiB0
aGUgTVNSJ3MgZG8gbm90IGdldCBjbG9iYmVyZWQsIGRvZXMgaXQgbWF0dGVyIHdoZXRoZXIgb3Ig
bm90IHRoZXkgZ2V0DQo+ID4gcmVzdG9yZWQuDQo+IA0KPiBJdCBtYXR0ZXJzIGJlY2F1c2UgS1ZN
IG5lZWRzIHRvIGtub3cgdGhlIGFjdHVhbCB2YWx1ZSBpbiBoYXJkd2FyZS7CoCBJZiBLVk0gdGhp
bmtzDQo+IGFuIE1TUiBpcyAnWCcsIGJ1dCBpdCdzIGFjdHVhbGx5ICdZJywgdGhlbiBLVk0gY291
bGQgZmFpbCB0byB3cml0ZSB0aGUgY29ycmVjdA0KPiB2YWx1ZSBpbnRvIGhhcmR3YXJlIHdoZW4g
cmV0dXJuaW5nIHRvIHVzZXJzcGFjZSBhbmQvb3Igd2hlbiBydW5uaW5nIGEgZGlmZmVyZW50DQo+
IHZDUFUuDQo+IA0KPiBUYWtpbmcgYSBzdGVwIGJhY2ssIHRoZSBlbnRpcmUgYXBwcm9hY2ggb2Yg
dXBkYXRpbmcgdGhlICJjYWNoZSIgYWZ0ZXIgdGhlIGZhY3QgaXMNCj4gcmlkaWN1bG91cy7CoCBU
RFggZW50cnkvZXhpdCBpcyBhbnl0aGluZyBidXQgZmFzdDsgYXZvaWRpbmcgX2F0IG1vc3RfIDR4
IFdSTVNScyBhdA0KPiB0aGUgc3RhcnQgb2YgdGhlIHJ1biBsb29wIGlzIGEgdmVyeSwgdmVyeSBw
cmVtYXR1cmUgb3B0aW1pemF0aW9uLsKgIFByZWVtcHRpdmVseQ0KPiBsb2FkIGhhcmR3YXJlIHdp
dGggdGhlIHZhbHVlIHRoYXQgdGhlIFREWC1Nb2R1bGUgX21pZ2h0XyBzZXQgYW5kIGNhbGwgaXQg
Z29vZC4NCj4gDQo+IEknbGwgcmVwbGFjZSBwYXRjaGVzIDEgYW5kIDQgd2l0aCB0aGlzLCB0YWdn
ZWQgZm9yIHN0YWJsZUAuDQoNClNlZW1zIHJlYXNvbmFibGUgdG8gbWUgaW4gY29uY2VwdCwgYnV0
IHRoZXJlIGlzIGEgYnVnLiBJdCBsb29rcyBsaWtlIHNvbWUNCmltcG9ydGFudCBNU1IgaXNuJ3Qg
Z2V0dGluZyByZXN0b3JlZCByaWdodCBhbmQgdGhlIGhvc3QgZ2V0cyBpbnRvIGEgYmFkIHN0YXRl
Lg0KVGhlIGZpcnN0IHNpZ25zIHN0YXJ0IHdpdGggdHJpZ2dlcmluZyB0aGlzOg0KDQphc21saW5r
YWdlIF9fdmlzaWJsZSBub2luc3RyIHN0cnVjdCBwdF9yZWdzICpmaXh1cF9iYWRfaXJldChzdHJ1
Y3QgcHRfcmVncw0KKmJhZF9yZWdzKQ0Kew0KCXN0cnVjdCBwdF9yZWdzIHRtcCwgKm5ld19zdGFj
azsNCg0KCS8qDQoJICogVGhpcyBpcyBjYWxsZWQgZnJvbSBlbnRyeV82NC5TIGVhcmx5IGluIGhh
bmRsaW5nIGEgZmF1bHQNCgkgKiBjYXVzZWQgYnkgYSBiYWQgaXJldCB0byB1c2VyIG1vZGUuICBU
byBoYW5kbGUgdGhlIGZhdWx0DQoJICogY29ycmVjdGx5LCB3ZSB3YW50IHRvIG1vdmUgb3VyIHN0
YWNrIGZyYW1lIHRvIHdoZXJlIGl0IHdvdWxkDQoJICogYmUgaGFkIHdlIGVudGVyZWQgZGlyZWN0
bHkgb24gdGhlIGVudHJ5IHN0YWNrIChyYXRoZXIgdGhhbg0KCSAqIGp1c3QgYmVsb3cgdGhlIElS
RVQgZnJhbWUpIGFuZCB3ZSB3YW50IHRvIHByZXRlbmQgdGhhdCB0aGUNCgkgKiBleGNlcHRpb24g
Y2FtZSBmcm9tIHRoZSBJUkVUIHRhcmdldC4NCgkgKi8NCgluZXdfc3RhY2sgPSAoc3RydWN0IHB0
X3JlZ3MgKilfX3RoaXNfY3B1X3JlYWQoY3B1X3Rzc19ydy54ODZfdHNzLnNwMCkgLQ0KMTsNCg0K
CS8qIENvcHkgdGhlIElSRVQgdGFyZ2V0IHRvIHRoZSB0ZW1wb3Jhcnkgc3RvcmFnZS4gKi8NCglf
X21lbWNweSgmdG1wLmlwLCAodm9pZCAqKWJhZF9yZWdzLT5zcCwgNSo4KTsNCg0KCS8qIENvcHkg
dGhlIHJlbWFpbmRlciBvZiB0aGUgc3RhY2sgZnJvbSB0aGUgY3VycmVudCBzdGFjay4gKi8NCglf
X21lbWNweSgmdG1wLCBiYWRfcmVncywgb2Zmc2V0b2Yoc3RydWN0IHB0X3JlZ3MsIGlwKSk7DQoN
CgkvKiBVcGRhdGUgdGhlIGVudHJ5IHN0YWNrICovDQoJX19tZW1jcHkobmV3X3N0YWNrLCAmdG1w
LCBzaXplb2YodG1wKSk7DQoNCglCVUdfT04oIXVzZXJfbW9kZShuZXdfc3RhY2spKTsgPC0tLS0t
LS0tLS0tLS0tLUhFUkUNCg0KTmVlZCB0byBkZWJ1Zy4NCg0K

