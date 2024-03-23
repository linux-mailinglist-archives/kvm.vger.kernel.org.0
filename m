Return-Path: <kvm+bounces-12543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5EE4887712
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 05:27:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D17228414B
	for <lists+kvm@lfdr.de>; Sat, 23 Mar 2024 04:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29559523C;
	Sat, 23 Mar 2024 04:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ia0SvQlH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB494683;
	Sat, 23 Mar 2024 04:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711168069; cv=fail; b=VBCriG7A4h/Z+2TUA62g4ncVAPWL6eZsHcUFdX64rF2MlOv/m/JgTqUrp3pDCQxX1lPwKAPtw2zupaWFFu5Ox002mpy+FcH8JD7eNDqdwBCCwwuDSz9KESyy3VidRym55tYptws28c4ypBDRZUkRyGO4WiO/acCvT93XPhMMu7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711168069; c=relaxed/simple;
	bh=TAG0aIGfoFttLrUyg25ef7GbrxVioJ6tK+Paaf3tG0U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MH+KkrudxZIhjdIRjO9nu8wfQmPMnGnsNMkTol9D5iegCa9JvK4dzOX18Q2EP2XeiUfebOKfILfRUOtiNNaeBS5XkdI9NN7USo9d7Z/62zQgv+6vOUywrFFMBYLqaJxEWzXSKJ4w3QXEFOHsAy7DNGKw+umHkYWqshyEggGJ4hw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ia0SvQlH; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711168067; x=1742704067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TAG0aIGfoFttLrUyg25ef7GbrxVioJ6tK+Paaf3tG0U=;
  b=ia0SvQlH1R4W/Cba0TgDPYaHT2zWB8LVzmEyd5fxXn14iIlXm+gYp2cl
   ajzY+o9ZHJMp13Za9XKeuaJ8NXmEPPP6vKt7ELiTgycYVB193qLmD3WIf
   9kdTWVoRzK7E5CZyfDhaAi+Cmnmg3TKx/bxtf6egSh6oe6zd5v/bw2+FL
   k4nH/d93AFNrg4VWqiI5KYYxAIQ2RRZ48km4Foc2XJxUn+lyBnd/xILDD
   2uetMUV2l5cSWEB5KiCJF1rII/fyA9OMmXQR69T4PvKmh9MUy5ZWYn5tt
   ouHKPOhCIyrrx/qWnzFlrEIoOppN+l5ESRJS/ibjSvtMb/jidU0tTCyOY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11021"; a="31666558"
X-IronPort-AV: E=Sophos;i="6.07,148,1708416000"; 
   d="scan'208";a="31666558"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2024 21:27:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,148,1708416000"; 
   d="scan'208";a="15004853"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Mar 2024 21:27:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 22 Mar 2024 21:27:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 22 Mar 2024 21:27:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 22 Mar 2024 21:27:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+R8A0hYIIlw1W9exbJNUMRP+T+9r9MUha7KN2ritWZGzrrw1cDBgm3MHxSrkj0/h/CXPUs8t3+TyQlzkUM+Y6bquye53vNag973Z3q98EGTJvqDQjWejUqBmMN+6tEQq6FP+b5VFEGcE0U9rK+XtHdMH9YXHC+CnnRUi7DVgIAsajTndLgHIBmfREfpn7IFHBFBKQ2wxlzI05AgfYNQsM4qxGQcSQPuqAeXrR+a046Rhvh8S6HUJgPw3xczDrPCXIwHoBUrrU3H73c65cZoo2aMAzUjwxYbnG9uYQawKpvBgA1QSnPMjB8y1nbbtmtWIr8Eb4HcbXwQndVjeV21mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAG0aIGfoFttLrUyg25ef7GbrxVioJ6tK+Paaf3tG0U=;
 b=hTPmsryU2d5v7US6u9Y8nb6SANW5UwVj0G/kiuEflH+g9hVlvqzEvwPNgbEHwqWMghGSZJj92a3h9IjI28SGtDuc8q2LCkc05YlgHXUubiUW7v2YDi14WaX/TkHSkP4lTwT0KlZiUEwAMmfW0aaaUKCctQK4Tcc8p5/rNa8SFmH+aAY1rFzHS4AmoQ13U9Up+WVABnu7SodtxJBFNFNf2MrZ9GBCXSyDS00BLKwhv7EbpE+9hlo3RJChYyAOPa+sRYWjVXXg7CnO+aH9KsdPV0FZWoUde30iIZc/rjkvOe2B63fHcI8YadbbhEEIGy6mx1GiRo4vMQajiIfpxxxapQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN6PR11MB8145.namprd11.prod.outlook.com (2603:10b6:208:474::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Sat, 23 Mar
 2024 04:27:42 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.023; Sat, 23 Mar 2024
 04:27:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Thread-Topic: [PATCH v19 035/130] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Thread-Index: AQHaaI27aksaajNLb0Ce6W5dhBjJe7FC6CUAgAGqaACAAFEzgA==
Date: Sat, 23 Mar 2024 04:27:42 +0000
Message-ID: <a021b0779bd23624bedf7d9b854963fb4edd90ba.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <079540d563ab0f5d8991ad4d3b1546c05dc2fb01.1708933498.git.isaku.yamahata@intel.com>
	 <9c35ecd7-e737-441a-99ff-27bda2a9b25d@intel.com>
	 <20240322233658.GG1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240322233658.GG1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN6PR11MB8145:EE_
x-ms-office365-filtering-correlation-id: 3908fedd-5fd9-42e7-0bae-08dc4af194bf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wcT1OenWer70tp8QgNENRCvqzq5UnD4DjgGZhEHrozCNabNeqv5Ya8Rv8WvCPS275xmlmV2pcago+K9FQmnUAlOXOQTKRiSywAYVh3P689rw9ttN+UaDKKPo0HLaeHQ7TVhs1FRqevq2mVDH8fCN8t8J4cgV9aWJIktwDrfKyt8D6D9B6LAuJClnA46Wi80/Kx7SrG+yOXdRaquZywDTroPC0m2c4tBLH5I9Scqty4TQNH0zfpsPt79V1QalaZQQBHPucmC8MX901uP8ZNKc/Ih31DLF8SMerhwru2RnRtbbt6e3nXyBzJcG0s9IQl49hrrmWJjKkzmv5xyG5iwCP6TW8TkuBe4jeiMYi2OqGQym4lr67v2wcmFNQFVYe6SSe2xS8/OJw/hWBzcpCXcJjxEhWnviMqbiYhLMCrWe7axctSHJTzkx5uGNDalD8d5Jhx+4WGl7/jBa3kbGdNkupklLC54qnyGOSOSEz3LNkd9K/WKcglnuAfPgQVwT2B7iOlzk6FcHtRWyjEBjkN+IvthDxUmImcwdM+yAtBwt2jYZS0HfbVW+hXG1GBKaewRH/aVBgMhTPh3g0v1la7vccYMI4MTV3nTT/QQw3PUFdjM/qn4W/9l6GZOZ2wC8UnCzYD0GMGgAncQzwYZObi/w4cpqnUTez/COq1/yyCvxrTw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1cwU1haRDdPaExQSTFNVXlOOXVSZjZReVVSc0V6WHd1Q3l4UndmMitlOFdj?=
 =?utf-8?B?VXpqekg0YjE0MjJCZUlMR25nM1hvakx0bW5rSzlxWkF2MHB0NzV0S2lBaC9F?=
 =?utf-8?B?ZW82dE9ERkR3V1VBaEhTeW5ZVnpqc1ByUC9ZUFFlNmVOR1pCSUE1TWNSVWV6?=
 =?utf-8?B?aU8yVW4wclZDMFJiM0hqWFZxWGFYRXoyb0JpYjUxUzF6WjBvd1E4YTMwSXlG?=
 =?utf-8?B?TkU5ZHk2TG9WSGxqTzRWUVFlRUJtbHJWVHBKbEIvN0N2cWxrUW8zSzcwTVFr?=
 =?utf-8?B?V1pMeE12QnJZZ25paGpUdWp4SVRkVUlxZ2ZKU1BKT25sVXJVWlM1Um8wWkZ0?=
 =?utf-8?B?QUN2UHBKa0xBVU5jejNQdHpVQmoyeFhnMU43OGcyUllQMk5saVc0YWFhRCsv?=
 =?utf-8?B?cVdFRnNNb3RKL0ZwS0pCZzJxNnJ4QlVML042RmZncHNNdjlOa0hlYTRUQm5u?=
 =?utf-8?B?UGNnYlZDL2hmVytkV2Y3eEZRTDRzc0c1cXN6WWxDVGtOdGpzTTlHOUF1SWtM?=
 =?utf-8?B?WHhzWmZqY202NktDTjE1V3h0OGFVc1o3RlY0TVVHd25CQmtUZWNxa2UwS09E?=
 =?utf-8?B?OVR2SSs1QzAzT0NqYmhobExnU2tuWXV4RHV4d1lzWlFpa29ONjB4T01LbGxG?=
 =?utf-8?B?Ymw2RW4wVmo1MjJ1STNER05XZHRpRHFobGVERzJCUGR5TjZ4YXFmUytRSHFW?=
 =?utf-8?B?VjZOazlBNnludmxZbStxeDhSNVB6emxXUVpiWVZiTThvd3NRY1pvM1hGR2dU?=
 =?utf-8?B?L2FReWtMS0tvaHpYU0JEdTZJOW1KVTI2WjRyUTRKYmhObXN1UnE3RFVwY2o4?=
 =?utf-8?B?cWFyZ1lJK2I4VVpGR3ZIalQ2aStOallqWnJEVmd6WWQrUWlUc0RDWEdGYkxk?=
 =?utf-8?B?YVQrU1VzSXQ0TCt0dE04dFNpck9NUWQ1d0dGZHVrcVYzY2hMWXpxdFB6V1dV?=
 =?utf-8?B?UWZOd21OZVVQSFhzM3ZXYkx5Qm40RjVJK29uQVdYMytTaCtvVnR1U3poYW10?=
 =?utf-8?B?U1F0YWpVZGUvN2RmeG5tL0xrdzlZZ0l1NFRqQko2bkg4QnVSRk9GaW9xNFhx?=
 =?utf-8?B?R0hpU1JCclZUVUF1Ulh1a25tck1zMU5FbHRLcmRYMEtzeSszRVpjeFZIeHd3?=
 =?utf-8?B?Um0zbUpucHYyRk1IVlA4RDM3c0owUC9xNHdONGloMkhuZEdqZEh3d282RFht?=
 =?utf-8?B?bmNRL1JnNlNRS3k2YStlWGN2TTgvVUxWUDE0c242Y2Z0Yi8xRUM2REVPOWZG?=
 =?utf-8?B?RDlhR2hjaWk3QUJlOVp6dy92ZkVTcmZVOGRCMThlN1IyVzg3aWhXeVowdERJ?=
 =?utf-8?B?V0c4NEJyUytkT1BtWFlUVkxLdkFxaTdIOW5XTU10SHBRaWxwbDRXOHd4Rlhq?=
 =?utf-8?B?bk0wS1cvZzBhTGUvYUpYM041MGJ6cElBQkxmZ1dsQjBFN3lRcmtEbU9TY2Vp?=
 =?utf-8?B?S3lpNGVuK25HMFY5dnJ6emxGNDlUdVRDSDNWWHFsMTVIQXBGUys1eVZISE44?=
 =?utf-8?B?TU5XbUg1eGh2TlV2djl5VVQ3S0JBNTQ1MEIrbTZwaVNqZUsvRjVSZzZZYVJX?=
 =?utf-8?B?WXFFUnVtYzk5Zjl2cWNyZklLUGt3dEJTc1QzSXlSRTBPMnFkR0RoNmtXd05u?=
 =?utf-8?B?cGlrQnVYU3F0TVF6a2kxYXpOTUNzbEFVNktZV2pUR0pwcUZDUHhZVGtvK2xH?=
 =?utf-8?B?djlFclFIanl4WjUzcjJESm5HOVJqMFdFMXA0WE9ZelZ0aFBzQy96eTJ0UUtD?=
 =?utf-8?B?WXBOSkdBRkZ0MlU0OE5ieU9aZWlMM0FMaWNMc3VoMzV2NjZ2Q2drTWlLREg2?=
 =?utf-8?B?ckxOWFRRSXlwQkdmcmpkSURkN3BqVFZublFSeE5NYlRTSmNpUnlYRzgrdDY4?=
 =?utf-8?B?QVlmTzdPck14MzVuTEwrakZEb2NzVklmNEVSUFdIcDJ5ZURvd1hoRGhac1c1?=
 =?utf-8?B?LzVlY2dwUVRtVUhHUCt5VHc2VytTOXg1Zk40eXVlczQ4bmFjS3JHeHMyREF4?=
 =?utf-8?B?WjFLekVmWFlFRWgzTTN3eXRqWWVuekUxZlZKejh4VjJuandMckhyQnZVK1FW?=
 =?utf-8?B?UGxqRXFiL2VtaVJXeUtHM2E4bFBnaCtRck0vMzArMWVkbnBOUHZ1QW1YRDMr?=
 =?utf-8?B?a0xWSDB0SDhkelRSOHlITi9lNE9yQ0RBMldjQlR5Rk5NTFJpWjRBdE8vVGxq?=
 =?utf-8?B?VUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <75247BA4A614CA49B17BC940DC96AAB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3908fedd-5fd9-42e7-0bae-08dc4af194bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2024 04:27:42.2810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wz3cC6BIVKHGcL9BTbhaeNWqLKVoOtjqjAa3shnJlwiYyhusBUBpp8qjsVVSDttxs6yaMXwsJj6LpEzoYbG1HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8145
X-OriginatorOrg: intel.com

PiANCj4gPiA+ICsNCj4gPiA+ICsJbXV0ZXhfbG9jaygma3ZtLT5sb2NrKTsNCj4gPiA+ICsNCj4g
PiA+ICsJc3dpdGNoICh0ZHhfY21kLmlkKSB7DQo+ID4gPiArCWRlZmF1bHQ6DQo+ID4gPiArCQly
ID0gLUVJTlZBTDsNCj4gPiANCj4gPiBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgeW91IHNob3VsZCBy
ZXR1cm4gLUVOT1RUWSB0byBiZSBjb25zaXN0ZW50IHdpdGggdGhlDQo+ID4gcHJldmlvdXMgdnRf
bWVtX2VuY19pb2N0bCgpIHdoZXJlIGEgVERYLXNwZWNpZmljIElPQ1RMIGlzIGlzc3VlZCBmb3Ig
bm9uLVREWA0KPiA+IGd1ZXN0Lg0KPiA+IA0KPiA+IEhlcmUgSSB0aGluayB0aGUgaW52YWxpZCBA
aWQgbWVhbnMgdGhlIHN1Yi1jb21tYW5kIGlzbid0IHZhbGlkLg0KPiANCj4gdnRfdmNwdV9tZW1f
ZW5jX2lvY3RsKCkgY2hlY2tzIG5vbi1URFggY2FzZSBhbmQgcmV0dXJucyAtRU5PVFRZLiAgV2Ug
a25vdyB0aGF0DQo+IHRoZSBndWVzdCBpcyBURC4NCg0KQnV0IHRoZSBjb21tYW5kIGlzIG5vdCBz
dXBwb3J0ZWQsIHJpZ2h0Pw0KDQpJIHJvdWdobHkgcmVjYWxsIEkgc2F3IHNvbWV3aGVyZSB0aGF0
IGluIHN1Y2ggY2FzZSB3ZSBzaG91bGQgcmV0dXJuIC1FTk9UVFksIGJ1dA0KSSBjYW5ub3QgZmlu
ZCB0aGUgbGluayBub3cuDQoNCkJ1dCBJIGZvdW5kIHRoaXMgb2xkIGxpbmsgdXNlcyAtRU5PVFRZ
Og0KDQpodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvNTg3MTkvDQoNClNvLCBqdXN0IGZ5aS4NCg==

