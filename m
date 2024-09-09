Return-Path: <kvm+bounces-26112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8EB397194C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 14:28:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0213B1C22C08
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:28:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD8A21B7904;
	Mon,  9 Sep 2024 12:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gni2pDsr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688531B78E4;
	Mon,  9 Sep 2024 12:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725884904; cv=fail; b=tT7aCVx4HIPnermyF4nWKWkgiavMoZdwE9O4Mc8oQ/vQmR/9qjxHi6Ai4oEnwWOn2b28R2at1y4dYP11liDk2thN3jryNiaI6bmLwVkz9OR2vVM8+4FYHqFRD6naxEXSV5bZF4YW4mvbaoIBmfH2q8/afscnfaczFvO5aKSt+R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725884904; c=relaxed/simple;
	bh=i60gVIRtxnXTSCKCHro8pQ6nAa8NsYcXdRIBELCzrWg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=iPZTpv/i2ZGOLQjg90+RoLPuua8CipYDS4PzKB+VpdZO7ad3ovlLh7GEckXsZHv0WszZehQoyFdsOgivPxBVTQ8pq5ygLkAs70JX874L4JQJPa8T10/LcvfgDmhoRCIOEbLX5i9J0bQDPYgeYi8wbUpGSMsje8pEoPhEOej397M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gni2pDsr; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725884902; x=1757420902;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=i60gVIRtxnXTSCKCHro8pQ6nAa8NsYcXdRIBELCzrWg=;
  b=gni2pDsrvraezDQ5LrZhZ4Et2V4Q5nHv5FedmTl703bQO8j0SZyDngOP
   jkTnR43Pec2iKu6OyjCWMqlPm6qQ6Iv9lLS0eLoq2nPh/qXG/gorgEhHG
   15pNFxC+8yJZhhd3Y3EbC/kWZKAvd+VMSHyua09jzySCvVJ5uQ/cTfjCf
   +TRxdUm9Fgde1XcYl8vz/AIxIQIurBsN5GfPnnbpXWZUID0lUYJgTaqBu
   46p4PoyEzFbgSLjt/wlR+JhK8SvfSdcIc4f2aW7Y0J6lgNH49OozN1o+B
   6lEztjjvBozx39MBB9jutRcFPsh1wDGr35e/Al1DjPo3UC4FeEXqmjzQM
   Q==;
X-CSE-ConnectionGUID: q7iphWdDSm6cKcjRx7JmwQ==
X-CSE-MsgGUID: Y9Oan2fESmm7TfUY3bFulA==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="24076390"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="24076390"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 05:28:21 -0700
X-CSE-ConnectionGUID: q3vsyb1bRgWYcutC3gWThg==
X-CSE-MsgGUID: pOSnoOiNTEuwOrb5iw1tzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="97364045"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 05:28:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 05:28:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 05:28:20 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 05:28:20 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 05:28:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JeOeeONrZ91shCVMZwPs1T3oEYUCjfbAGoIg7lwtv2eBog6m6DaMhS6SWrz2s2kqv/89VSMVzEcZ5YPB0zw8s4+drsUd86veA/YktE2SRa7eHYNTM6Cn6r6j1lML8bsU9WxxXl4MIllke8dRVOnOXOG4VcifcIMWJ8Mm7ckFTPOyvD4T2wxcUP35bzzBmYw58HFYJvPOjfATAwuzesgI1fwLg58B59eLLDqCVM5IZsb6BLrGqAhG8V5RcB65gd9//yE6hqsou5qBtNBidvzUXU9QJMcX7qeG1LdgCTNBRZ/ulJ+7UTjdc2JgalwKqXhTPHoz6+hcQ5z5k73Ln5TgQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i60gVIRtxnXTSCKCHro8pQ6nAa8NsYcXdRIBELCzrWg=;
 b=JEyKt32tSDu4Yb9ZP+c6B5vl2n6x8aRmh3Ajg23pR0AO1mwr3W3KqozomHzZv73AlIZiSL+OFTMauz/wgFC5gVJEcyxnV6HU0s9B5cNWk5J+qkki9/vadkvtp6efMNm3KnchvMazieB/yuKWXbRI4baSIh3JsxQ8RwyxrDfIP5G9N5e5HhgFakXwidf7ENQQwdAFtVIqxUJf472t5DNu3UxKcJqCCsA4BvXyQXZduZddd3yxERnVKRrlqYmnmX7+0bxpba2Iu7m5XN6nWHaDZAsDtlQ5Ts2PCAMb20caSCj+27tWIm918PXXUOPI16jL3tA2s/6TVgIupcgkUnpI5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN2PR11MB4661.namprd11.prod.outlook.com (2603:10b6:208:26b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.23; Mon, 9 Sep
 2024 12:28:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 12:28:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Topic: [PATCH v3 3/8] x86/virt/tdx: Prepare to support reading other
 global metadata fields
Thread-Index: AQHa+E/xnJeJIU2HBUe1bw/wL2vrsbJLWFqAgAQegoA=
Date: Mon, 9 Sep 2024 12:28:17 +0000
Message-ID: <4d4f98882265c6a114f198a3f0d54455a611596c.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <0403cdb142b40b9838feeb222eb75a4831f6b46d.1724741926.git.kai.huang@intel.com>
	 <66db75497a213_22a2294b@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66db75497a213_22a2294b@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN2PR11MB4661:EE_
x-ms-office365-filtering-correlation-id: 8b0161d9-9e88-4557-758c-08dcd0cae23b
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?c3ZhUnkwWVRlTFYvdEE0eWhzdU43eUVVclIwWVVMYnBObzNwMWlFQ0JMN3M0?=
 =?utf-8?B?NGtmY2Rzd3BURGlVMEZtZFI0MFJ3T05DUXp5ZG5jWWNZSHlwNEVvV011WStL?=
 =?utf-8?B?MHVjTnludTFzWXY0dTB3WHRHdEhnS3psaHF2dEhoOGRSOWRSNkpPdWZtMGVE?=
 =?utf-8?B?UUp6SkJVYWdPdXYzM3IrTFI5eUlXczgrbk1EWmdMRlNYdWFZNWlyQys0VHBT?=
 =?utf-8?B?ZGRIZlBkek9xcEMrOFh6R1c0K2J6aFNKOCtpbDZZZlppbndiajE1aGorOGd6?=
 =?utf-8?B?VDJDYUZ0RmpTR25mODE4TFhDUnA4bzl6djIzTW56VCtEOWtZMG12WGVCUE9R?=
 =?utf-8?B?ZDFLc3FSNEFmZGV1ZG5qQjBmcGlTdVI1Vy8vK3M0NzlEZGNpeUlvWFgyMkVD?=
 =?utf-8?B?akRveWJoMGxtZnVzQVZQalJsSUtld1FSZHdEQVNlK09HNjlhZnpETGlFa2Rj?=
 =?utf-8?B?OHJaKzgrVWl2bm1yb0JnRjdpdTRkUTBwSE91TmdnYUJkR2FUUEpETnRkN0pU?=
 =?utf-8?B?NWx4cERwdVdIY1JKQjlqOFJnaDRqaWU1TXZjblQrUkJham9iOWd6MlFXbmk0?=
 =?utf-8?B?VlZyZHV0YW5RL0RyWWlUbjRmWlFZWDNzanFZd3pLcjRNNGFWM2IyUTZrVTJF?=
 =?utf-8?B?eS9TaHh1cXVad0c5MzROSlExMFVsSnhtUFppWTZiV09nbmwyMkpPYVA4WHBj?=
 =?utf-8?B?c3d4K3UrUC92WFVKc09OS3FQL1ViL2R0NXVTcEo3WDE1ZDNUQ252QmhMRkFO?=
 =?utf-8?B?M2hMQnUzTzRXZWx0eXliSWhyeDJ6bEsrZjVoMk1IU0dMenV2ZkJCMExKTitO?=
 =?utf-8?B?aHhwRFVHTkxJMXpXWWZ4bVAvc0JvY0lEZ0tXc2tZWVF1ZHpGM1E0azU5Mlli?=
 =?utf-8?B?UmU0R1htc3YveVFLa2hZNkUxWTQwT29qcEVXVGFXTWRSR3VFRXRlZTBHRUZm?=
 =?utf-8?B?eFdHK1ozTTNhVlNWMEVHdUtQZTRuVmNyWlNGS0hlaXozWGt4dTAzYkRXeHlp?=
 =?utf-8?B?c0kxU0xUTENkdDZ4QW5lRmdNQnlET2tWUzFpWFF0aUdqMGxjUlNrU3krMlcy?=
 =?utf-8?B?RFRjSXJQNDVSMHVtQXFWdWxUTkl3Y2FQaVJvVnhtaVZkYStuRm4zSzc1cEg5?=
 =?utf-8?B?R1lhVWpaemovbXNoaGI3aFEreDRRQ3hhTjdmQ250ak5VQURabGZnWUdicFpa?=
 =?utf-8?B?bWhQcWViZUxxamVSUGlsTFJyVVZLK1N6cG5WeFBjRWxDVFFsY3lnOE9MSURH?=
 =?utf-8?B?aUJKak9PVmlUa2wreEdWYmUyejVveC9UYTVNNE5aSUtIZ3pROFhFaFBEdCtE?=
 =?utf-8?B?aGpIZUVTaGZyTFVST1l4R2ZaS1RvemZOaXZxYm51OG8raG5aenNGWER6OWU3?=
 =?utf-8?B?VE4rQUJvR3VYT2pWcm5uRTN3NTFPRkd6TzZoZXBVV3c2M01Pb012NVRlUVhR?=
 =?utf-8?B?YndEb0RWd1pVQld5OWlIWE1TQkI2Z2FUY2RDNHB5QXh1S1pKU3ZueVZ1QmZY?=
 =?utf-8?B?ZW90RHVsQnNIM0xoZXhTRDk4U0k1Y2dJUGJ4NW1WY2RHMTBHT1NLc1orcEpE?=
 =?utf-8?B?RWdQU3QwR3FXNm40L2hGNW0rcVFlbE1zOGFEaFl4VFVXNmdOaXN1VGdrRGFO?=
 =?utf-8?B?dFFjVHViZ2s1bmVkRXI5ZjAvTGR3d2praVhKWjhZcURQbkdaWmt0YTBlQ0Fs?=
 =?utf-8?B?WHdJbTZHRklPN2ZOdklFMU4xMllyZXQ0aGRSeUdzMUJsUzVYbWNlNUpJYUpE?=
 =?utf-8?B?ZGozNzFqSjVSVXRBN2lBMU44RUVQdlhTYzE5UGZMTWZtekYvVlFHNUNkV0hR?=
 =?utf-8?B?TVRtNWF0dG9lMERSU05sM3RmWHMyc0NXQ3RnVDloaStqQXdGTDUvRTRxMkhv?=
 =?utf-8?B?bTFQbzlpOHZaNGRSZTYzNmdTcDhkN2taR0hmMXBxSkpBNTVDYWZ4RWRjN1hn?=
 =?utf-8?Q?h0fH/FRwngE=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nlh3RlNXL01hYlBnMVh1S2RxOUtSU0wwaHV4WVFxaXlCRC81RW5vU3o0L0tT?=
 =?utf-8?B?UzMrYzNqa28wQjlXQzR5MGFMRk1pcGJIV0ZBNUxmMEg5VWgxRHFTUzlVMUJR?=
 =?utf-8?B?UVYxeGxJMkg2Q25sYmh4Zk9nY0NDZkFxbUx6WlJTd01MV2tYZyt4UjNiQTRo?=
 =?utf-8?B?SzRXZG9JaVNZMFdjYmhyMjBuVndGMWlveDE0NHJZWXdjRGdVWHVnSmdjY2Z1?=
 =?utf-8?B?dDZFSHNlS3Rmb2M4dDRFdVJId1dQbENiamRqaEJzc0tHdDAxcHdNWWdkcHZV?=
 =?utf-8?B?ZmpNU1ZzbXhVRGFXRUFaY1FDVjJtbGNMZnhXZlpIQmMrclJIeTZDclJvUUYr?=
 =?utf-8?B?RU41dzRMV2grR09MS21KdTZudGxvbEUvYUs1V0tnRjBuR1JYNzJMTUZ2Yklq?=
 =?utf-8?B?RG1YVVBRNjJjK2FRNDZRVU5mcXd1Qm5FaExlL0hrcndhN280cFhMbzludWtv?=
 =?utf-8?B?VThxZkhUVXpYMm5lMTVFV2EyV0tPWTgzRjVRL3NzVUs0c2FKVTRkOEMydEhq?=
 =?utf-8?B?WUtLQnBTWitkT0ZkMnhZK1J1Sk1SSlJmYUV5SWpSdjFDMHRWamxXcHFyMUlQ?=
 =?utf-8?B?WE9nb3l5Yks0Rlh0NjFiVU1TN0U2Z2UrMERvUU1NMjFwV2Q0V281R2dpTnJM?=
 =?utf-8?B?WWlCNEtheVNyU2lLcU9xd1k3Z0pEM3dUalVnL3Ria3BjZmVMS0N2UHBFa3Zl?=
 =?utf-8?B?emw5M2J5T1ZWLzFETWk0ck1IK0duNklicmZBUzZRMFZDQ2kxc2dGeGMxR2tE?=
 =?utf-8?B?Z21zL0NhRktPT2pWQnhyTDNkM3NJcUFVS3Q0ZXJmQTE3elZKNWV5MzhWaktK?=
 =?utf-8?B?cEJuSjB3SzkrQllmNFJPeng4NnNWajgycUNUbjZuN0YxUlBQajFSeHB6TG5Z?=
 =?utf-8?B?SjMzYnovVXlqN3dtMHNzbGJXMVhSNVRXWHYyU2RTU2t1QUk3cXA3R1ZGWFB5?=
 =?utf-8?B?MUpPWFZsWkN4aXl3OFZwdGZmbjd1dzdlbVRZZjN3YjN2TVMwaDdoblpZNXFv?=
 =?utf-8?B?NzNseHFTeG55ZjVRZHYvMHk2L2JCRDYrWkp1SndXNUg0QlY2U0ZDcStjWU5P?=
 =?utf-8?B?YjhGb3EwVjJWbHpRejhlYUtqN2o0S0gxc0ZCUm5ZbXNEdThwL1pPWk5OWVph?=
 =?utf-8?B?VFBjNDRhS0dEcSs2MTc5N0VXaTJsQ1BwRC9mYUdQN3k4WlQ2cTY3K0RveHoy?=
 =?utf-8?B?akt0V1lGYUJvSklHZSsxdU40SjQ1TU1YWk84SmN6ZU00U3prdXYrVkt2ajFw?=
 =?utf-8?B?RnpSLy92bXJvTmtHUkFyWUErTHJYQ0Evc29VK1cybmNLcnpqazBqYmEzbjZX?=
 =?utf-8?B?cFdaQ3kyMEFBQzhxeVZ2SkxjdkdtemVVbUhzSzVwTVJka0ZYbHlzYXhzd0hU?=
 =?utf-8?B?L01kQTByNTlpR3lGcTRielJzNWtiaUUxR1lpdE5sclRQWXYwaGtoQ0hpMk5U?=
 =?utf-8?B?azNOVUgrY0VxbHBPYjl1LzEwdzVBdVpJWlBlNHp5R3RNaEpXZWxaUitzTCs3?=
 =?utf-8?B?NXJWWUVkc3pwVkpReVFReG5UOTVHbXlnZzB5eGdPc3dMbXBLZ1lMcDFnUGdU?=
 =?utf-8?B?NWpGK2lJSzlmc29mS3N2RUY3bFBTNEZQc096U2lPYUJiSTgvUldHZCtBMjI3?=
 =?utf-8?B?SjNYSTNkSGFKbWp3akZ3TmFOL2FaRCtUTkdGaHA0b1dZRjNVZGVQRE5iUnpr?=
 =?utf-8?B?ejVxbkthZzhjZXhPdW1GRGhraytHSnBzcFhrRWMyZTdIZk9VaXRQdWdKUmZO?=
 =?utf-8?B?TGNKSUsxbmhUMVZabVlvTzI0b0k2eGdjamV1a3NuSFN0bld2L3h2dEZIMTJN?=
 =?utf-8?B?TVA4a1JFWGVDRFpvN0pkUk5JMk5mQm5ucVhFdkU5ekc1THFLWWl4VXJ2QnIy?=
 =?utf-8?B?cFBkdnFKbHBnNlhGSXpHZEVmcVkrQlV3WWxTTEdQWFNRbEIwUlM5M2xlbzBp?=
 =?utf-8?B?d2JkVWJUeXk4M1lsbm5DNkcybkRBT0hXOEw0RWxyM3k5bGJtZUtzbHVSdGRx?=
 =?utf-8?B?Yng0TVVQUXV3SXM1cDFrOEIzMFJSWWJMK05aK3UxM2QwUEhWYTllK011UWdi?=
 =?utf-8?B?RFRiL3grQ0dlSGE4U29LYzdrdEJhcVhrZkZNWmN5TjZLZURwY0c0YXlNclZH?=
 =?utf-8?Q?VTY4UxsVWfrBD/8UeibhAob9P?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <075CF62F1B971A439349D36FD724EAEC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b0161d9-9e88-4557-758c-08dcd0cae23b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 12:28:17.7038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aRjg4sev2YEeT2jzLPB1Eb3Z47snA7wyQviYcfRdZzcRrM30KUndXada1+rz0pQA2nj5m0af/w9S5cvX0b6GIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4661
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDE0OjM0IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEthaSBIdWFuZyB3cm90ZToNCj4gPiBGdXR1cmUgY2hhbmdlcyB3aWxsIG5lZWQgdG8gcmVhZCBt
b3JlIG1ldGFkYXRhIGZpZWxkcyB3aXRoIGRpZmZlcmVudA0KPiA+IGVsZW1lbnQgc2l6ZXMuICBU
byBtYWtlIHRoZSBjb2RlIHNob3J0LCBleHRlbmQgdGhlIGhlbHBlciB0byB0YWtlIGENCj4gPiAn
dm9pZCAqJyBidWZmZXIgYW5kIHRoZSBidWZmZXIgc2l6ZSBzbyBpdCBjYW4gd29yayB3aXRoIGFs
bCBlbGVtZW50DQo+ID4gc2l6ZXMuDQo+IA0KPiBUaGUgd2hvbGUgcG9pbnQgd2FzIHRvIGhhdmUg
Y29tcGlsZSB0aW1lIHR5cGUgc2FmZXR5IGZvciBnbG9iYWwgc3RydWN0DQo+IG1lbWJlciBhbmQg
dGhlIHJlYWQgcm91dGluZS4gU28sIG5vLCB1c2luZyAndm9pZCAqJyBpcyBhIHN0ZXAgYmFja3dh
cmRzLg0KPiANCj4gVGFrZSBzb21lIGluc3BpcmF0aW9uIGZyb20gYnVpbGRfbW1pb19yZWFkKCkg
YW5kIGp1c3QgaGF2ZSBhIG1hY3JvIHRoYXQNCj4gdGFrZXMgdGhlIHNpemUgYXMgYW4gYXJndW1l
bnQgdG8gdGhlIG1hY3JvLCBub3QgdGhlIHJ1bnRpbWUgcm91dGluZS7CoA0KPiANCg0KQUZBSUNU
IGJ1aWxkX21taW9fcmVhZCgpIG1hY3JvIGRlZmluZXMgdGhlIGJvZHkgb2YgdGhlIGFzc2VtYmx5
IHRvIHJlYWQNCnJlcXVlc3RlZCBzaXplIGZyb20gYSBwb3J0LiAgQnV0IGluc3RlYWQgb2YgYSBz
aW5nbGUgbWFjcm8gd2hpY2ggY2FuIGJlIHVzZWQNCnVuaXZlcnNhbGx5IGZvciBhbGwgcG9ydCBy
ZWFkaW5nLCB0aGUga2VybmVsIHVzZXMgYnVpbGRfbW1pb19yZWFkKCkgdG8gZGVmaW5lDQptdWx0
aXBsZSByZWFkIGZ1bmN0aW9uczoNCg0KYnVpbGRfbW1pb19yZWFkKHJlYWRiLCAiYiIsIHVuc2ln
bmVkIGNoYXIsICI9cSIsIDoibWVtb3J5IikNCmJ1aWxkX21taW9fcmVhZChyZWFkdywgInciLCB1
bnNpZ25lZCBzaG9ydCwgIj1yIiwgOiJtZW1vcnkiKQ0KYnVpbGRfbW1pb19yZWFkKHJlYWRsLCAi
bCIsIHVuc2lnbmVkIGludCwgIj1yIiwgOiJtZW1vcnkiKQ0KLi4uDQoNClNvIGp1c3QgdG8gdW5k
ZXJzdGFuZCBjb3JyZWN0bHksIGRvIHlvdSBtZWFuIHNvbWV0aGluZyBsaWtlIGJlbG93Pw0KDQoj
ZGVmaW5lIGJ1aWxkX3N5c21kX3JlYWQoX2JpdHMpIFwNCnN0YXRpYyBfX21heWJlX3VudXNlZCBp
bnQgICAgICAgXA0KX19yZWFkX3N5c19tZXRhZGF0YV9maWVsZCMjX2JpdHModTY0IGZpZWxkX2lk
LCB1IyNfYml0cyAqdmFsKSAgIFwNCnsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgIHU2NCB0bXA7ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICBpbnQgcmV0
OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBcDQogICAgICAgIHJldCA9IHRkaF9zeXNfcmQoZmllbGRfaWQsICZ0bXApOyAgICAgICAgICAg
ICAgICAgICAgICAgXA0KICAgICAgICBpZiAocmV0KSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIFwNCiAgICAgICAgICAgICAgICByZXR1cm4gcmV0OyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBcDQogICAgICAgICp2YWwgPSB0bXA7ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KICAgICAgICByZXR1
cm4gcmV0OyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCn0N
Cg0KYnVpbGRfc3lzbWRfcmVhZCg4KQ0KYnVpbGRfc3lzbWRfcmVhZCgxNikNCmJ1aWxkX3N5c21k
X3JlYWQoMzIpDQpidWlsZF9zeXNtZF9yZWFkKDY0KQ0KDQo+IFRoZQ0KPiBtYWNybyBzdGF0aWNh
bGx5IHNlbGVjdHMgdGhlIHJpZ2h0IHJvdXRpbmUgdG8gY2FsbCBhbmQgZG9lcyBub3QgbmVlZCB0
bw0KPiBncm93IGEgc2l6ZSBwYXJhbWV0ZXIgaXRzZWxmLg0KDQpTb3JyeSBmb3IgbXkgaWdub3Jh
bmNlLiAgRG8geW91IG1lYW4gdXNpbmcgc3dpdGNoLWNhc2Ugc3RhdGVtZW50IHRvIHNlbGVjdCBy
aWdodA0Kcm91dGluZT8NCg==

