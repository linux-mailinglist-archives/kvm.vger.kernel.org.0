Return-Path: <kvm+bounces-18244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CA128D288C
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 01:06:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D31E828767D
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 23:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4007B13E8BF;
	Tue, 28 May 2024 23:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F9uHmrSX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D467017C6A;
	Tue, 28 May 2024 23:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716937610; cv=fail; b=nJoNyhapb7R1JXuViD1iyBZWVuzwj9vuBjRRTbodEQ6BavIbgXIImIm5Bs37xr8nszkeS8wo6VIWq1IPt8RHhtXQZZ2+bCQZ+BBAqrHFTEpBgpsZeTudqVZZOEmvBrU26cXAgCDwMricGCXBZ5VvvJed7KsT/9z9ZY720CViPD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716937610; c=relaxed/simple;
	bh=fqGyTUswELHlCt54pF69oxefE8rsIj+OGJTCy3rXTpU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TNYIK4P5oTTC6uP9gl7GrDPrCmpXHr/hvrxEp+k0K8rpPMcT356v9p62rGZPXR9cdO3xGPTLOsVrd2QF5iIVdUgZj/roZHO0LFtyK1HZTJKc8pBxxKz+Jbxy74B2+D+Qv4yLWWkyLneyZ3lYmJwYHTdlXlncAGuWRo7SZe92OmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F9uHmrSX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716937609; x=1748473609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fqGyTUswELHlCt54pF69oxefE8rsIj+OGJTCy3rXTpU=;
  b=F9uHmrSXEylK9Bc0ijpN1KQ/nSPgt6KfO7EcxguWfa1rG7hK0TsWEEue
   Qe4Zfcwsbqdr1vmI/B/hj8GHnnToLVFRxtQRTLasZzgvMz+Razx8dJWfh
   rxZesH5km/Cm8ysxnnzCfr2C9wFD3Jjq2jt0Ld4SvlxO5XkP1lLXYz4jJ
   Pf2leN/Isp3OC/0iz6hmU7dX9RfPxRsDrzlDJ0Lg0KiSs1ryKhOuvfvFm
   58DdD4xO/FsjJol4r5moyAsYjDnFfPdCNvc0BaOnuUt9TEltJzO7furJk
   p2Wl7yyNqnQ6UBlRtXNmOsAsjiS2jVxsVzMekJSw2l9/R6j5aH748O8Wf
   A==;
X-CSE-ConnectionGUID: +6c+1NwrSce3VWDdfFGXqg==
X-CSE-MsgGUID: MTQZvP9TTLq17nab6odvGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13162728"
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="13162728"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 16:06:49 -0700
X-CSE-ConnectionGUID: iZrl1AltTN+7/SJfe5KDNw==
X-CSE-MsgGUID: /h+YiZtOQ8GGCsWrKA+k8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,196,1712646000"; 
   d="scan'208";a="40102384"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 16:06:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 16:06:47 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 16:06:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 16:06:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MqFFvVaQ42vQHCcWZNnqDd9BS1wmzjD0rNI3fDL/I+FVg3NUvYWfiJbJWOLjGHp9zfvbfUjMf+XEkM6NdFFhPrJuzrVfW2ifPCKBcBhEgmZmcqcxRs1U8DphZBmqet90IZR/B+IhKlyqyo7Uezxv7um0goYeOqXkCuqrFAcuX3g3m+GKqz96q8SjR5rc8sv20KSMoX4qZ7SyR5ocGxQR0KVA1dhGgUFb2yfUcvxlwvqWTSo0SxABsMT2KQtE/h5uzV0YGiZuyV80Tc9n9plOs71LGt6UaqZqhl2FATEyFFWJdOLSQ8vAf5MH9m+XenqZyaTZDhD/JsF2J5IgG86NSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fqGyTUswELHlCt54pF69oxefE8rsIj+OGJTCy3rXTpU=;
 b=kz9t9DDbTXNvoHWjAEAH6z6Jbe+QbRNAHEGll5Lli6/09uavHRsLJlYYb+Zdx6VTQmtsUoZVFiMLpY9BpLFgfv0aCOf7p9J2luQ2eFWNw7CbAcDdCgR9gev/T4olcqrM7/PhzBpdavsLomK8/qGsfFzO9cLhwuXcBRspSiUoCqvxnCU/IgkV5La2FmVocAjqMA88ox68PlepbEA+Rq2JnaXAAHn5uFn6q8GE65Ip9wUPgqhKIVjYKbdFA7ZrrpYbB0J3mpm9p8eQY42fk4k3L+B3SXNYV6ngiVWVsZq378QFDiBpWCC0I7PAseDmvEFUDsMz4hiAUTXVBuXoOiOm6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6504.namprd11.prod.outlook.com (2603:10b6:8:8d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7611.29; Tue, 28 May 2024 23:06:45 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 23:06:45 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Topic: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Thread-Index: AQHapmNTP3XGfqhyyEaM/KHu10XBU7GtWqMA
Date: Tue, 28 May 2024 23:06:45 +0000
Message-ID: <a5ad658b1eec38f621315431a24e028187b5ca2d.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
In-Reply-To: <20240515005952.3410568-11-rick.p.edgecombe@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6504:EE_
x-ms-office365-filtering-correlation-id: 4c90040a-6517-4287-c1e7-08dc7f6ad874
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?dWF6V01xcTlmVXZMRng2aXVPK0hXOHRjM2x6bzlEUllJN2hNVDdxSSt3b2I4?=
 =?utf-8?B?WFFzaURkZW1kZVd1SjVyZE9DSkFmVFRXa0ZwRGxNcDZuNkxRNW45TVlUQStZ?=
 =?utf-8?B?Si9IZ3pEYmpOWllwekdVdGpNTjVmNFBvamVhWEVWNUF3R0ptZ3NpekFLRlho?=
 =?utf-8?B?YXZaNE45aU5OQWlDRU0renNFYWFXbUJuMThwQ0g3Z3hWMmVkdjJ4VWR6WjFP?=
 =?utf-8?B?aGpJdjUrZ1NaaktCd2F5V2FZN1hBeWFDS1hrd2RIbUxWcVJZbUEvbVEyUHZu?=
 =?utf-8?B?Mjd4NFUwUDk2TDFKOFcrSHpUeDZhWWl6UGpMVGUrZHoyL3VmU0czRjVNYmUr?=
 =?utf-8?B?YmFtZHRscEhXK0R4Q1U5RHRMdDdCUEpnUHJpM2V2V3VPQ2l5L001c0hCZXp0?=
 =?utf-8?B?Wm84MGRGanZRcmhmeUxrRWJZTkx5RHZzS3pkT0gzV2xtK3UyR21DKzBpcjUy?=
 =?utf-8?B?NE85TjUxbFhoZEVhM3Jya2U0bXpOQzdmZDFUZFg5MExaZlY4VjhxaGRHZDNO?=
 =?utf-8?B?eThTVVkzOTdHUXkrWE1aUHZBT0UxNW5MWjNaZGFGUm5kYmxHY09DTFlnWG45?=
 =?utf-8?B?T1Fkc21zZ1NtbERVVzdQSEI0Q2xFZkMyU2hqWHRUcktlZ2lBbWY1S0lGZ0VF?=
 =?utf-8?B?MEhsTnJUM2EvTEgvM1lHR05vNGpETVBHMlIvU0JCNlFxcTNQZVlJcTBjaGQz?=
 =?utf-8?B?RXdKbDN1VFNhWHdGNWNXMDQ1YzdDZzNua09MZHJDOWRCdTFDek9RS2FWYjVn?=
 =?utf-8?B?YjRlTTFDcm1sRWx1aE10eWxldTBWeDVhbm5xVkZxanBmR3ErUUNxcStkMWJD?=
 =?utf-8?B?WENaTFFZL3lxNVcrem9Db1hzK2tsTCsxSjg4dEZmWmtSSk04blY5TWJQU2dN?=
 =?utf-8?B?TDVBQjl5dHhBQUJmSXBKS1dtSjdUUG5IRHRNclZqR0g5WHJUWFp2aXllSVlp?=
 =?utf-8?B?RDJkRnBiVTluRmcwVkl2TGFYQTFlQXlkT1cwb3pwTmVUeFZBVnJlOGNRRjFk?=
 =?utf-8?B?WFFIN21wQkNmUnRKeENFVC9ablhKZStoZE9RaVQ2cTZsZW8xK21PQzg3cmlh?=
 =?utf-8?B?L2s3REJ3K0tFU211eWtLeHZrcE5VVFVRMFFTNjdsTm1uRGR1QUJtVHdYWXRW?=
 =?utf-8?B?QlZCS0RuTnBSVGMwMXc2cWNSNEhwYjlXSXJIeTh4VDFMb014MGpPRzZYWkVp?=
 =?utf-8?B?N0NFTHNQWXgyWHNxWnUzV3AzSDdnaHRIeUxCOWE3amdhTE1iVU1nWjFqYWJt?=
 =?utf-8?B?Ujh4SnRYbjFlSURESWdNNkd1RExkcmFFV2xvYlBMZXJTOTZYMWY5N1hJbWVL?=
 =?utf-8?B?TC9KZUlYcDBVa1NDRktiUlMrL042QVJ6M1VmeGwyOVNKMkhuY0c0OGgvVGdo?=
 =?utf-8?B?UklJak84c2VhUWhHbFdpMDZYSzBKMCtoRExXLzRra09xVXN2UnhGNVVxR1FZ?=
 =?utf-8?B?dlhlTmZCaDN5dlhWL2xscGcwS1pUeFZ1Zkl1c2xkQU1nY0dMR3BwVytvMnpw?=
 =?utf-8?B?K1VNejlBUjdmT3Q2a3g3d3Rrc0FKMldONCszNzFzaCs4dmlZT29GbHB0Z2s3?=
 =?utf-8?B?TWlVT3lCV0o5U1JEOTRtNkFKeVlHZm9HU3JkUWJZTFRZcHFyYWw1c1dYeWVp?=
 =?utf-8?B?SGdwSzUrOGtHMzhpTDZZQXhzRGFRNkR3M3BnTmNYSlIrSFA2UUQ0WUxiaGxj?=
 =?utf-8?B?SmtYWDlJNHNnMTZNeXhiL2I1ZTlyL1ZBY0FmQ2VURGoxRlpxMkluaHRJUzdu?=
 =?utf-8?B?RStkVU1kSGVCUkVRQVZubGl0ODVlYnVrcTlvL2doVHdUQTV2NUFYMGpBRi8x?=
 =?utf-8?B?M1BESitOR2RVRzhUSnYyQT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1VJekVRRVVQWW1wRVhocnVubFFpSTg0eFVPMWdGODgzK1pOZUFzcFpEb3FM?=
 =?utf-8?B?alNteC91VHp4cU5zbjhJaE14RkNWOTdTaml2NEtVSWZua1lzUW44TXUvZEx2?=
 =?utf-8?B?bGhZU0dPc3I2MmF2TUxkRkU0dXdnTC9oOWd2ekFpOS9FYktuZzdXY3Q2UmJU?=
 =?utf-8?B?aU1mV21Cb3hvdVVQc0p0ck9tblo1eXFYcmprNGxPRHNQRUZDenFrZ0RSclRk?=
 =?utf-8?B?YWI2a0hFTnBzZi96dy9uM3pMVlNhZmxiaXlxaHhKZ1FWUFNmWk03Z3dPRlVD?=
 =?utf-8?B?UTV3OGRrQ2NacnIxejJIMWhObUYxVEFwLzVKSXFQbVVwanNUd1UxSlU2SkN1?=
 =?utf-8?B?Zm9oQ05JdytNeDdqVWZodExoOGJZYVJ5QmJtQkp3bzhvODRSc0xneXgxQVYy?=
 =?utf-8?B?THQ2dUovVlF5U0JsNWVxak1NUytxakdrUUl5SWhob1kxYkFVK2loQ2FLc1dS?=
 =?utf-8?B?akRsRlc1Nks2SGhXMjAwNkswU3p3ZDBDNHV6QTZlZmxKZkVaWm5sMWZUMFFS?=
 =?utf-8?B?bldZdDhLUHBKczExcVFxVHhxZXZCOFQ3LzZGSmpkMERyZjQ3MWcvckVtaXRB?=
 =?utf-8?B?Smt6Z2xvd29PRHF1dkR2OFp2dE55UTFLZDJyUEtCTk9PbHJlMmRKL05qTEFq?=
 =?utf-8?B?STFKTm85NDVOV1VkQ3FCZWF1eW55STRtVzFGYW9xNHZyaVMwT2l5MTFUd3U0?=
 =?utf-8?B?Q1BCMEplbXRUZlArZ0gyWm5HdmI2NjMwOTdUcUcwQ1FiUVIyQnZndnFmb2Uv?=
 =?utf-8?B?dUZLTTNmTm9qYmpwVzBSZW5DcjY2SnM0YjhDT1lDSWJwRWo2M3lKYUVZRTZx?=
 =?utf-8?B?dU4zenQwVCtDSXRFaUQ1TFhET0hqV2dIUzN6QW8vdWtOM25GMk02eERuN090?=
 =?utf-8?B?R0NwWFlvYnM2V0JHYUZsVGRSRnFnS1g4TGlvUGVpMlR4UzdqN2psTWhxSUFk?=
 =?utf-8?B?UDRFbFo1VzBneVJ1WldkT0JGK3NCdnExS2Y2K296NkxNNm1mbmZJNEhENTI0?=
 =?utf-8?B?Y2JHVTVNQU91VmZnTnI2QnN6YUZESTlEZmpBNy8zRzJjaXNkUlhPYWpPOCtL?=
 =?utf-8?B?TS9jL280UXhPTnNIcmV2dFdUdDlzM2lxcTZsRE9Cc2MzZ0xWKzlSdFljYWxC?=
 =?utf-8?B?WWxEbktRZi9pUis5bHF3WG1SYUh1eWFsdXBnYlRRenFGc3VkY3REOEYxekh6?=
 =?utf-8?B?aElZQXd6NlluZDY1ajlCUlZSZjFObU4vUTV3YlFyUzVJUkxUN2JTT3BPL0ls?=
 =?utf-8?B?Mko4b1lWMHZ6NUdtWlY4SVJBSkcvZGRFWkNMd242L1NNMVROcGhUbG9MNGM3?=
 =?utf-8?B?ZWU0K1AwNnpNbU9LRE1PZDhlbUFMdDdhQm9sSWhpdXZkNG1EWjQ3RmlrNXBS?=
 =?utf-8?B?TTRjQkJ3aXZHS2Z3czVVc0ZBWVcxSHJNRFRKN1ZwRDYrMGdEZFptbENkaXY0?=
 =?utf-8?B?bjZQU3ZMelZVaU1uRmdJMWI3UWZlWmhXbnZHY3hVWkRhTjcySzFRNnQ5Vjg3?=
 =?utf-8?B?YUV1OFBrelkxeFg4S01KeFo1eGxjbzMrVUplNmFoN2xWVS9ETlptMDNsMFhZ?=
 =?utf-8?B?Sk5jayt6Q053ODA3V0VkbTlYVG5kQTVMYnZUTFdHaUxZTzRJTDVFSzBmaGti?=
 =?utf-8?B?cmZUbXBhYmJjRmFPa3dTUkZROGw1dnA4OVdOUll3WExFZ0ZpREIraUpzVUJi?=
 =?utf-8?B?a1laQ3QxQlJ5bU4xZ1pvNDBBZjJReHJ1VnZaT2JsY0VvRzZsZ3NxNnlaV25L?=
 =?utf-8?B?WlJiUTdMODFGNUFPTzZWSTlQL2ZqRlZEYmNFTHZ2NGN4a0Fvanp0QVJETjZ5?=
 =?utf-8?B?S1ZTNTBuMXdFNlJjVnJhUXJsOGM5UHpUTG5yZHA0Qk1DOEYzelo4MnJ3L09B?=
 =?utf-8?B?bVdLZ0NmOFZ1OTIyN1BFL0NJWFpkTE9wN3VmUDFKVmIvb1BCUzZhUFZTL3FW?=
 =?utf-8?B?YnFvNTRVbkRzdEtVS09SNFE1Zmh1bXdPckpkT1IrRVQ4K0dvYlI3QWh0ck83?=
 =?utf-8?B?eXFOS1hWakdkV3d5bi90Mng5L0FCNzJEQXdhSU5Dbk4zdHdKRTh1RG9qZ3hZ?=
 =?utf-8?B?eWYyWldEaVpTenhNQ0lBa2QwZ1hzckx3ZHZ3amdIMXBRcG9SYXpnTUZEeUxD?=
 =?utf-8?B?dGR0N0VWazMzZWZPeS90ZTdtM2NNQ0s2VlFBM3orUE1pYTVQYnZpQ1FkK0py?=
 =?utf-8?B?Tmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4925BB089E66C64ABA12B4B9FC9A5CA6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c90040a-6517-4287-c1e7-08dc7f6ad874
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2024 23:06:45.4028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O7r81uQi7aCfXMlR2N0tnkWDRrpAovbUB7T3AbE7V2JQKQgL3CyS8jFJNNlfjxn70QZyB0ruAHU1bUIj4hsiIQHxUTCwCjBOpwb5I8F4nXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6504
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA1LTE0IGF0IDE3OjU5IC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToK
PiDCoHN0YXRpYyB2b2lkIGhhbmRsZV9jaGFuZ2VkX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQg
YXNfaWQsIGdmbl90IGdmbiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1NjQgb2xkX3NwdGUsIHU2NCBuZXdfc3B0ZSwgaW50
IGxldmVsLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoGJvb2wgc2hhcmVkKQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU2NCBvbGRfc3B0ZSwgdTY0IG5l
d19zcHRlLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHVuaW9uIGt2bV9tbXVfcGFnZV9yb2xlIHJvbGUsIGJvb2wgc2hhcmVk
KQo+IMKgewo+ICvCoMKgwqDCoMKgwqDCoGJvb2wgaXNfcHJpdmF0ZSA9IGt2bV9tbXVfcGFnZV9y
b2xlX2lzX3ByaXZhdGUocm9sZSk7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IGxldmVsID0gcm9sZS5s
ZXZlbDsKPiDCoMKgwqDCoMKgwqDCoMKgYm9vbCB3YXNfcHJlc2VudCA9IGlzX3NoYWRvd19wcmVz
ZW50X3B0ZShvbGRfc3B0ZSk7Cj4gwqDCoMKgwqDCoMKgwqDCoGJvb2wgaXNfcHJlc2VudCA9IGlz
X3NoYWRvd19wcmVzZW50X3B0ZShuZXdfc3B0ZSk7Cj4gwqDCoMKgwqDCoMKgwqDCoGJvb2wgd2Fz
X2xlYWYgPSB3YXNfcHJlc2VudCAmJiBpc19sYXN0X3NwdGUob2xkX3NwdGUsIGxldmVsKTsKPiDC
oMKgwqDCoMKgwqDCoMKgYm9vbCBpc19sZWFmID0gaXNfcHJlc2VudCAmJiBpc19sYXN0X3NwdGUo
bmV3X3NwdGUsIGxldmVsKTsKPiAtwqDCoMKgwqDCoMKgwqBib29sIHBmbl9jaGFuZ2VkID0gc3B0
ZV90b19wZm4ob2xkX3NwdGUpICE9IHNwdGVfdG9fcGZuKG5ld19zcHRlKTsKPiArwqDCoMKgwqDC
oMKgwqBrdm1fcGZuX3Qgb2xkX3BmbiA9IHNwdGVfdG9fcGZuKG9sZF9zcHRlKTsKPiArwqDCoMKg
wqDCoMKgwqBrdm1fcGZuX3QgbmV3X3BmbiA9IHNwdGVfdG9fcGZuKG5ld19zcHRlKTsKPiArwqDC
oMKgwqDCoMKgwqBib29sIHBmbl9jaGFuZ2VkID0gb2xkX3BmbiAhPSBuZXdfcGZuOwo+IMKgCj4g
wqDCoMKgwqDCoMKgwqDCoFdBUk5fT05fT05DRShsZXZlbCA+IFBUNjRfUk9PVF9NQVhfTEVWRUwp
Owo+IMKgwqDCoMKgwqDCoMKgwqBXQVJOX09OX09OQ0UobGV2ZWwgPCBQR19MRVZFTF80Syk7Cj4g
QEAgLTUxMyw3ICs2MzYsNyBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfY2hhbmdlZF9zcHRlKHN0cnVj
dCBrdm0gKmt2bSwgaW50Cj4gYXNfaWQsIGdmbl90IGdmbiwKPiDCoAo+IMKgwqDCoMKgwqDCoMKg
wqBpZiAod2FzX2xlYWYgJiYgaXNfZGlydHlfc3B0ZShvbGRfc3B0ZSkgJiYKPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgICghaXNfcHJlc2VudCB8fCAhaXNfZGlydHlfc3B0ZShuZXdfc3B0ZSkgfHwg
cGZuX2NoYW5nZWQpKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrdm1fc2V0X3Bm
bl9kaXJ0eShzcHRlX3RvX3BmbihvbGRfc3B0ZSkpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBrdm1fc2V0X3Bmbl9kaXJ0eShvbGRfcGZuKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKg
wqAvKgo+IMKgwqDCoMKgwqDCoMKgwqAgKiBSZWN1cnNpdmVseSBoYW5kbGUgY2hpbGQgUFRzIGlm
IHRoZSBjaGFuZ2UgcmVtb3ZlZCBhIHN1YnRyZWUgZnJvbQo+IEBAIC01MjIsMTUgKzY0NSwyMSBA
QCBzdGF0aWMgdm9pZCBoYW5kbGVfY2hhbmdlZF9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgaW50Cj4g
YXNfaWQsIGdmbl90IGdmbiwKPiDCoMKgwqDCoMKgwqDCoMKgICogcGFnZXMgYXJlIGtlcm5lbCBh
bGxvY2F0aW9ucyBhbmQgc2hvdWxkIG5ldmVyIGJlIG1pZ3JhdGVkLgo+IMKgwqDCoMKgwqDCoMKg
wqAgKi8KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHdhc19wcmVzZW50ICYmICF3YXNfbGVhZiAmJgo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoCAoaXNfbGVhZiB8fCAhaXNfcHJlc2VudCB8fCBXQVJOX09O
X09OQ0UocGZuX2NoYW5nZWQpKSkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgKGlzX2xlYWYgfHwg
IWlzX3ByZXNlbnQgfHwgV0FSTl9PTl9PTkNFKHBmbl9jaGFuZ2VkKSkpIHsKPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgS1ZNX0JVR19PTihpc19wcml2YXRlICE9Cj4gaXNfcHJpdmF0
ZV9zcHRlcChzcHRlX3RvX2NoaWxkX3B0KG9sZF9zcHRlLCBsZXZlbCkpLAo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm0pOwo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaGFuZGxlX3JlbW92ZWRfcHQoa3ZtLCBzcHRlX3RvX2No
aWxkX3B0KG9sZF9zcHRlLCBsZXZlbCksCj4gc2hhcmVkKTsKPiArwqDCoMKgwqDCoMKgwqB9Cj4g
Kwo+ICvCoMKgwqDCoMKgwqDCoGlmIChpc19wcml2YXRlICYmICFpc19wcmVzZW50KQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBoYW5kbGVfcmVtb3ZlZF9wcml2YXRlX3NwdGUoa3Zt
LCBnZm4sIG9sZF9zcHRlLCBuZXdfc3B0ZSwKPiByb2xlLmxldmVsKTsKCkknbSBhIGxpdHRsZSBi
b3RoZXJlZCBieSB0aGUgYXN5bW1ldHJ5IG9mIHdoZXJlIHRoZSBtaXJyb3JlZCBob29rcyBnZXQg
Y2FsbGVkCmJldHdlZW4gc2V0dGluZyBhbmQgemFwcGluZyBQVEVzLiBUcmFjaW5nIHRocm91Z2gg
dGhlIGNvZGUsIHRoZSByZWxldmVudApvcGVyYXRpb25zIHRoYXQgYXJlIG5lZWRlZCBmb3IgVERY
IGFyZToKMS4gdGRwX21tdV9pdGVyX3NldF9zcHRlKCkgZnJvbSB0ZHBfbW11X3phcF9sZWFmcygp
IGFuZCBfX3RkcF9tbXVfemFwX3Jvb3QoKQoyLiB0ZHBfbW11X3NldF9zcHRlX2F0b21pYygpIGlz
IHVzZWQgZm9yIG1hcHBpbmcsIGxpbmtpbmcKCigxKSBpcyBhIHNpbXBsZSBjYXNlIGJlY2F1c2Ug
dGhlIG1tdV9sb2NrIGlzIGhlbGQgZm9yIHdyaXRlcy4gSXQgdXBkYXRlcyB0aGUKbWlycm9yIHJv
b3QgbGlrZSBub3JtYWwsIHRoZW4gaGFzIGV4dHJhIGxvZ2ljIHRvIGNhbGwgb3V0IHRvIHVwZGF0
ZSB0aGUgUy1FUFQuCgooMikgb24gdGhlIG90aGVyIGhhbmQganVzdCBoYXMgdGhlIHJlYWQgbG9j
aywgc28gaXQgaGFzIHRvIGRvIHRoZSB3aG9sZQpvcGVyYXRpb24gaW4gYSBzcGVjaWFsIHdheS4g
Rmlyc3Qgc2V0IFJFTU9WRURfU1BURSwgdGhlbiB1cGRhdGUgdGhlIHByaXZhdGUKY29weSwgdGhl
biB3cml0ZSB0byB0aGUgbWlycm9yIHBhZ2UgdGFibGVzLiBJdCBjYW4ndCBnZXQgc3R1ZmZlZCBp
bnRvCmhhbmRsZV9jaGFuZ2VkX3NwdGUoKSBiZWNhdXNlIGl0IGhhcyB0byB3cml0ZSBSRU1PVkVE
X1NQVEUgZmlyc3QuCgpJbiBzb21lIHdheXMgaXQgbWFrZXMgc2Vuc2UgdG8gdXBkYXRlIHRoZSBT
LUVQVC4gRGVzcGl0ZSBjbGFpbWluZwoiaGFuZGxlX2NoYW5nZWRfc3B0ZSgpIG9ubHkgdXBkYXRl
cyBzdGF0cy4iLCBpdCBkb2VzIHNvbWUgdXBkYXRpbmcgb2Ygb3RoZXIgUFRFcwpiYXNlZCBvbiB0
aGUgY3VycmVudCBQVEUgY2hhbmdlLiBXaGljaCBpcyBwcmV0dHkgc2ltaWxhciB0byB3aGF0IHRo
ZSBtaXJyb3JlZApQVEVzIGFyZSBkb2luZy4gQnV0IHdlIGNhbid0IHJlYWxseSBkbyB0aGUgc2V0
dGluZyBvZiBwcmVzZW50IFBURXMgYmVjYXVzZSBvZgp0aGUgUkVNT1ZFRF9TUFRFIHN0dWZmLgoK
U28gd2UgY291bGQgb25seSBtYWtlIGl0IG1vcmUgc3ltbWV0cmljYWwgYnkgbW92aW5nIHRoZSBT
LUVQVCBvcHMgb3V0IG9mCmhhbmRsZV9jaGFuZ2VkX3NwdGUoKSBhbmQgbWFudWFsbHkgY2FsbCBp
dCBpbiB0aGUgdHdvIHBsYWNlcyByZWxldmFudCBmb3IgVERYLApsaWtlIHRoZSBiZWxvdy4KCmRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyBiL2FyY2gveDg2L2t2bS9tbXUv
dGRwX21tdS5jCmluZGV4IGU5NjY5ODZiYjlmMi4uYzlkZGIxYzJhNTUwIDEwMDY0NAotLS0gYS9h
cmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYworKysgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUu
YwpAQCAtNDM4LDYgKzQzOCw5IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9yZW1vdmVkX3B0KHN0cnVj
dCBrdm0gKmt2bSwgdGRwX3B0ZXBfdApwdCwgYm9vbCBzaGFyZWQpCiAgICAgICAgICAgICAgICAg
ICAgICAgICAqLwogICAgICAgICAgICAgICAgICAgICAgICBvbGRfc3B0ZSA9IGt2bV90ZHBfbW11
X3dyaXRlX3NwdGUoc3B0ZXAsIG9sZF9zcHRlLAogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgUkVNT1ZFRF9TUFRFLCBsZXZlbCk7CisKKyAg
ICAgICAgICAgICAgICAgICAgICAgaWYgKGlzX21pcnJvcl9zcChzcCkpCisgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgcmVmbGVjdF9yZW1vdmVkX3NwdGUoa3ZtLCBnZm4sIG9sZF9zcHRl
LApSRU1PVkVEX1NQVEUsIGxldmVsKTsKICAgICAgICAgICAgICAgIH0KICAgICAgICAgICAgICAg
IGhhbmRsZV9jaGFuZ2VkX3NwdGUoa3ZtLCBrdm1fbW11X3BhZ2VfYXNfaWQoc3ApLCBnZm4sCiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG9sZF9zcHRlLCBSRU1PVkVEX1NQVEUs
IHNwLT5yb2xlLCBzaGFyZWQpOwpAQCAtNjY3LDkgKzY3MCw2IEBAIHN0YXRpYyB2b2lkIGhhbmRs
ZV9jaGFuZ2VkX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQgYXNfaWQsCmdmbl90IGdmbiwKICAg
ICAgICAgICAgICAgIGhhbmRsZV9yZW1vdmVkX3B0KGt2bSwgc3B0ZV90b19jaGlsZF9wdChvbGRf
c3B0ZSwgbGV2ZWwpLApzaGFyZWQpOwogICAgICAgIH0KIAotICAgICAgIGlmIChpc19taXJyb3Ig
JiYgIWlzX3ByZXNlbnQpCi0gICAgICAgICAgICAgICByZWZsZWN0X3JlbW92ZWRfc3B0ZShrdm0s
IGdmbiwgb2xkX3NwdGUsIG5ld19zcHRlLCByb2xlLmxldmVsKTsKLQogICAgICAgIGlmICh3YXNf
bGVhZiAmJiBpc19hY2Nlc3NlZF9zcHRlKG9sZF9zcHRlKSAmJgogICAgICAgICAgICAoIWlzX3By
ZXNlbnQgfHwgIWlzX2FjY2Vzc2VkX3NwdGUobmV3X3NwdGUpIHx8IHBmbl9jaGFuZ2VkKSkKICAg
ICAgICAgICAgICAgIGt2bV9zZXRfcGZuX2FjY2Vzc2VkKHNwdGVfdG9fcGZuKG9sZF9zcHRlKSk7
CkBAIC04MzksNiArODM5LDkgQEAgc3RhdGljIHU2NCB0ZHBfbW11X3NldF9zcHRlKHN0cnVjdCBr
dm0gKmt2bSwgaW50IGFzX2lkLAp0ZHBfcHRlcF90IHNwdGVwLAogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBuZXdfc3B0ZSwgbGV2ZWwpLCBrdm0p
OwogICAgICAgIH0KIAorICAgICAgIGlmIChpc19taXJyb3Jfc3B0ZXAoc3B0ZXApKQorICAgICAg
ICAgICAgICAgcmVmbGVjdF9yZW1vdmVkX3NwdGUoa3ZtLCBnZm4sIG9sZF9zcHRlLCBSRU1PVkVE
X1NQVEUsIGxldmVsKTsKKwogICAgICAgIHJvbGUgPSBzcHRlcF90b19zcChzcHRlcCktPnJvbGU7
CiAgICAgICAgcm9sZS5sZXZlbCA9IGxldmVsOwogICAgICAgIGhhbmRsZV9jaGFuZ2VkX3NwdGUo
a3ZtLCBhc19pZCwgZ2ZuLCBvbGRfc3B0ZSwgbmV3X3NwdGUsIHJvbGUsIGZhbHNlKTsKCgpPdGhl
cndpc2UsIHdlIGNvdWxkIG1vdmUgdGhlICJzZXQgcHJlc2VudCIgbWlycm9yaW5nIG9wZXJhdGlv
bnMgaW50bwpoYW5kbGVfY2hhbmdlZF9zcHRlKCksIGFuZCBoYXZlIHNvbWUgZWFybGllciBjb25k
aXRpb25hbCBsb2dpYyBkbyB0aGUKUkVNT1ZFRF9TUFRFIHBhcnRzLiBJdCBzdGFydHMgdG8gYmVj
b21lIG1vcmUgc2NhdHRlcmVkLgoKQW55d2F5LCBpdCdzIGp1c3QgYSBjb2RlIGNsYXJpdHkgdGhp
bmcgYXJpc2luZyBmcm9tIGhhdmluZyBoYXJkIHRpbWUgZXhwbGFpbmluZwp0aGUgZGVzaWduIGlu
IHRoZSBsb2cuIEFueSBvcGluaW9ucz8KCkEgc2VwYXJhdGUgYnV0IHJlbGF0ZWQgY29tbWVudCBp
cyBiZWxvdy4KCj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHdhc19sZWFmICYmIGlzX2FjY2Vz
c2VkX3NwdGUob2xkX3NwdGUpICYmCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAoIWlzX3ByZXNl
bnQgfHwgIWlzX2FjY2Vzc2VkX3NwdGUobmV3X3NwdGUpIHx8IHBmbl9jaGFuZ2VkKSkKPiDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGt2bV9zZXRfcGZuX2FjY2Vzc2VkKHNwdGVfdG9f
cGZuKG9sZF9zcHRlKSk7Cj4gwqB9Cj4gwqAKPiBAQCAtNjQ4LDYgKzgwNyw4IEBAIHN0YXRpYyBp
bmxpbmUgaW50IHRkcF9tbXVfemFwX3NwdGVfYXRvbWljKHN0cnVjdCBrdm0gKmt2bSwKPiDCoHN0
YXRpYyB1NjQgdGRwX21tdV9zZXRfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGludCBhc19pZCwgdGRw
X3B0ZXBfdCBzcHRlcCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgdTY0IG9sZF9zcHRlLCB1NjQgbmV3X3NwdGUsIGdmbl90IGdmbiwgaW50
IGxldmVsKQo+IMKgewo+ICvCoMKgwqDCoMKgwqDCoHVuaW9uIGt2bV9tbXVfcGFnZV9yb2xlIHJv
bGU7Cj4gKwo+IMKgwqDCoMKgwqDCoMKgwqBsb2NrZGVwX2Fzc2VydF9oZWxkX3dyaXRlKCZrdm0t
Pm1tdV9sb2NrKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqAvKgo+IEBAIC02NjAsOCArODIxLDE2
IEBAIHN0YXRpYyB1NjQgdGRwX21tdV9zZXRfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGludCBhc19p
ZCwKPiB0ZHBfcHRlcF90IHNwdGVwLAo+IMKgwqDCoMKgwqDCoMKgwqBXQVJOX09OX09OQ0UoaXNf
cmVtb3ZlZF9zcHRlKG9sZF9zcHRlKSB8fCBpc19yZW1vdmVkX3NwdGUobmV3X3NwdGUpKTsKPiDC
oAo+IMKgwqDCoMKgwqDCoMKgwqBvbGRfc3B0ZSA9IGt2bV90ZHBfbW11X3dyaXRlX3NwdGUoc3B0
ZXAsIG9sZF9zcHRlLCBuZXdfc3B0ZSwgbGV2ZWwpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChpc19w
cml2YXRlX3NwdGVwKHNwdGVwKSAmJiAhaXNfcmVtb3ZlZF9zcHRlKG5ld19zcHRlKSAmJgo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoCBpc19zaGFkb3dfcHJlc2VudF9wdGUobmV3X3NwdGUpKSB7Cj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIEJlY2F1c2Ugd3JpdGUgc3BpbiBsb2Nr
IGlzIGhlbGQsIG5vIHJhY2UuwqAgSXQgc2hvdWxkCj4gc3VjY2Vzcy4gKi8KPiArwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgS1ZNX0JVR19PTihfX3NldF9wcml2YXRlX3NwdGVfcHJlc2Vu
dChrdm0sIHNwdGVwLCBnZm4sCj4gb2xkX3NwdGUsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5ld19zcHRlLCBsZXZlbCksIGt2bSk7Cj4gK8KgwqDC
oMKgwqDCoMKgfQoKQmFzZWQgb24gdGhlIGFib3ZlIGVudW1lcmF0aW9uLCBJIGRvbid0IHNlZSBo
b3cgdGhpcyBodW5rIGdldHMgdXNlZC4KCj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBoYW5kbGVfY2hh
bmdlZF9zcHRlKGt2bSwgYXNfaWQsIGdmbiwgb2xkX3NwdGUsIG5ld19zcHRlLCBsZXZlbCwKPiBm
YWxzZSk7Cj4gK8KgwqDCoMKgwqDCoMKgcm9sZSA9IHNwdGVwX3RvX3NwKHNwdGVwKS0+cm9sZTsK
PiArwqDCoMKgwqDCoMKgwqByb2xlLmxldmVsID0gbGV2ZWw7Cj4gK8KgwqDCoMKgwqDCoMKgaGFu
ZGxlX2NoYW5nZWRfc3B0ZShrdm0sIGFzX2lkLCBnZm4sIG9sZF9zcHRlLCBuZXdfc3B0ZSwgcm9s
ZSwgZmFsc2UpOwo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gb2xkX3NwdGU7Cj4gwqB9Cj4gwqAK

