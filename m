Return-Path: <kvm+bounces-71526-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id APsTI5W+nGlSKAQAu9opvQ
	(envelope-from <kvm+bounces-71526-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:54:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB6D17D41A
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 21:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 647A530371A2
	for <lists+kvm@lfdr.de>; Mon, 23 Feb 2026 20:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2523793A3;
	Mon, 23 Feb 2026 20:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l1NCWgd+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E30377566;
	Mon, 23 Feb 2026 20:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771879716; cv=fail; b=mSPlz1kKgvjYjr3ITMGZMfN83rqbOy8gI2lMRehhUp5XyBRWxlz3RXGbyVWldNYK3mtesnxLX9sXfXL5Nk7NW9lwhGm6I7NdMlc52hMvpECic1rF8/zfCHdTyg+pTbuNNAUIuOxSmmOf0aQQKpUjzTJmZKSXUQkcKtTm5O1crFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771879716; c=relaxed/simple;
	bh=NrJK7iPdpjwpVqSfGq29UtQfA4em5BZfa0go7birIWU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a7nZHOyHa/j0HvM+pGNJkHznvQ1Xv5bpQuDTPQPHgPYz035rkZA0rJuuYo6YuFFpnZZbm6VOyznAiLRdeezu4rfSNd98xOSP+TLioMI0i08suECvjujPYS+emPc7kYjYjnO8mTrOvKXRYDkOQOCQ3mMESE6ADvzlf/yeeT9rcXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l1NCWgd+; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771879714; x=1803415714;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NrJK7iPdpjwpVqSfGq29UtQfA4em5BZfa0go7birIWU=;
  b=l1NCWgd+ouzv8u/V6Yibyq6kkNaP+1p8a49IHUqTW4e1lITNvHnKQaJ8
   mQb1i59RxujmWxZQAteSeT1lmuw9VJseLWE5tRdbtCs9v/u7mltccCLEY
   tml3+YFdTRfPig6udcRefhAb13XHt0DHsLQlef7qioW7Cvg60P/GZkPEP
   6pr1+XkyRoRSM1TPmGyJX6PMbmAoj1YdGgrl3pZHx0aghl2bfCJkPLNOU
   ymlEMf1ChlKk7rOn1Th8oVvDS5kzjopeSX7wHksft3bgCkEBgO07kXn0v
   q++Z146UVRKcmI7YIJFhtMWtnuC7it+hJCk9rRH1EiSXJYNJGuNf6MDBU
   A==;
X-CSE-ConnectionGUID: xOm611ngT1ub5p+0oYcbWA==
X-CSE-MsgGUID: 3PkAYGcZTtGB1iDzigEq8w==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="84249368"
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="84249368"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 12:48:34 -0800
X-CSE-ConnectionGUID: rrmImRwYSA+JG4N53j/uRw==
X-CSE-MsgGUID: 6mR0Y8nCSLilis0N3PZWxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,307,1763452800"; 
   d="scan'208";a="213572322"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2026 12:48:34 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 12:48:33 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 23 Feb 2026 12:48:33 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.41) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 23 Feb 2026 12:48:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sj/XVjZQq4o2ngbbsiIRJlaEzo4pNvqeem7fpT3BBGVye3FqiNMRaT+Agfg13zooq1GhH8ajFyctVA3qjCtq3Xj8ZjwtcXy2tlicQMnv6M21pExpAJb8osg2vhzGNLh2NE/RNQgP1gzt9sYI+IIyYge1xBQL08JeImTpZ3VRitqIsKUBnoksb2+EX0xCRi+ECmitatwM/G3rxRbVXuGocxYte7BrpbQHh7PqJk2L63ohVdfpPZKKt6wnZ48OGKKZ+ovQdcwe5GpH4xHvv+kW5GSBgnmaUjERy3kYyiWG0+jb45QpQUpT2begfAS+Qf0uL3dhKhIRGFMrq+nqQOM2rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrJK7iPdpjwpVqSfGq29UtQfA4em5BZfa0go7birIWU=;
 b=bpJ6KOWPPaeLx/+1VE/PqNmGG2KqNuRAq/iKOZFsa1zyQUJIh6ESlRyTsBDEhf4PnX6Zf3BCDLsI5bDr2Qtt4Gi+TIHH+9uyBxna1slsMzWk+VYdIfeaCEcp8+wbXlk82QFFOqZIUCJEFA+7gkkoqQtIMtaaySmV1CK039vSak+b4aJITZZulTeTN2HhUkSXVQ+gGPSnlrW84XpJyxsUGkRo0qbqFjUOhBihmOYSeoaVrfDFIFR7s+hpy492AUqnA2RE7Van/lWEPJMH6Iw8iTTik8HqqFf4kol+tQifUPO/6WPZzX1ovv1/4kcXkpkoXOZMi9byZIezh2dNFZIGCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 CYYPR11MB8359.namprd11.prod.outlook.com (2603:10b6:930:ca::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 20:48:31 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 20:48:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "yosry.ahmed@linux.dev"
	<yosry.ahmed@linux.dev>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Index: AQHcoTXmp0GPnRCoRk2Vv+i+XQkxSrWQKC+AgABfr4CAAEE8AA==
Date: Mon, 23 Feb 2026 20:48:30 +0000
Message-ID: <9e899034687731c7ee6d431ae49dbe3f5ca13a6c.camel@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
	 <5a826ae2c3549303c205817520623fe3fc4699ec.camel@intel.com>
	 <aZyGY41LybO8mVBT@google.com>
In-Reply-To: <aZyGY41LybO8mVBT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|CYYPR11MB8359:EE_
x-ms-office365-filtering-correlation-id: 92e3d377-6f25-4f5d-f18a-08de731ce732
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cDlUQ2lOM2xVZTkwd2pBeW90RHNsV0IwbnZpY2NMZmxyMGpXNWNjUmNucmt6?=
 =?utf-8?B?U2RrUUNkR1ZUZGV6MEV2SWM0Z3N3a0ZRZ0lPRDRXRS9ITmw3WnJ4SDl4RUpu?=
 =?utf-8?B?TzkwaS9yL2NPMmt3N0ZHNWVScGx5UXgzV2E4R1FQa2ZRbk4zNGF6MEpTVUg4?=
 =?utf-8?B?WlBweGNPVFJWR2ZrZ3lMc0dvb3RmOHN4WlpXeG9sRzBiekludWtVN2VSUEhN?=
 =?utf-8?B?NXh2d3VuMzdNUElSWlZORFlBeXVCZi9XUThxQmxBSG9ZVWdrbGtucVBWWDR4?=
 =?utf-8?B?aDlDWmlSZmNuQytPczhsUkNHTkkzOUppNzVmelB3MGxtUDFIQ0MrR0VDL3hU?=
 =?utf-8?B?T2NBdE0zcXBtS3VmY3ZjYnVOMWJ6Q0hGbTc0QTRGZ0Nzd09DMmdwMlE3eVZ2?=
 =?utf-8?B?alJ3UUl6b0t5L29Bb2l5dVprZFVQYXV1L091N3NNYXRDS0VFQ0JMSnFHTFlM?=
 =?utf-8?B?UDZZd0d6RmQzWkpVK2RWV2c2YVh6UHM1ZFN0R0JnblpsZDNmTVZJTGNSREg5?=
 =?utf-8?B?Qm4raWl6aUY0aG0rQ295dndkM3BVRTRPNmdoM28xYWVyRk1nVnl1YjBqVzVD?=
 =?utf-8?B?TWJSdUpaNkszeENxV09IV00zK0w4TGFMT1FDNk5ZcTRRWUVuK1h6bjNrZmJl?=
 =?utf-8?B?cVVUWW5UV2lFS05sU04raE5OSlpRRk5xUmZBekVKOGxTQXJzQTBFMTFLSHcw?=
 =?utf-8?B?VWJYaFZISDlTSStNazcrUTNQVGRtNDNLd2tNMlZLZDZPcGNLYlp6YlRybUpa?=
 =?utf-8?B?ZzkyUXFOcGJKeUNnVDZVRE5UOTFiVjlTSC9OeCsxKytVMTZneGo4enY5VE9l?=
 =?utf-8?B?NnQrNEQ4SzZka1hmYmVuNzJjcFplVXRsSFN3RUhqVW1jZTBVRHZpZndMTFB3?=
 =?utf-8?B?Q3B5UldHbFgvNkowSHFqMzNQNHBTaXd5bjY4dHFCUFhaZ2hTcGdrVUtXeUtX?=
 =?utf-8?B?aUxlSVVWd0RjcWNKdUZRaHp4cUM3cnNjczBOeTJHM3MzTU4yQ3pqNWdrOURs?=
 =?utf-8?B?OWwrMXdWRWlYVENmVFducjcwdXlSN1Y2YzN6RU5ieDBKYkVFbVh2N29tV1o2?=
 =?utf-8?B?TTl4MVloWlBuR09pUExBY0J4Nm90ZmhrczExRTVjcnkrTkRWS3pFZ3NSUTlC?=
 =?utf-8?B?L0crbEhQVU1RSE85aXhYc3QwVWkycktFZjZHa2V5a2ViVXcvRU5JNmtBTU11?=
 =?utf-8?B?YWYzQXdtYzlRVUZ1NWVxcUlGMXVvM1diR3hZZUZWVmJWYkEralV4am5ZRHM4?=
 =?utf-8?B?anZ5MVZ4WmhLSEsxN2lUQktWdnpneDREeDVjTFNNbUNPMjNFQlY2RHVUZGxi?=
 =?utf-8?B?YUNOK2xNU0diT0hNbzB6Z0UvS2pZYm9tcUVUZHAxN1BMVjAraTJ6Zk4rQnpZ?=
 =?utf-8?B?UDFQcU05N1RNYTUzakwyN2dhZGRkazRtSThEVzJtWUtydG9FUGR1ZmtSQlox?=
 =?utf-8?B?c3JaZHNyQldLZVd2dWpXaTBMcGFseWVCQklWY2orT1M1S3RBZTZqY3VBNjZi?=
 =?utf-8?B?WDdqejVLZnlhMG9peTEyTFBFV1FlZkh2OTllMDhIODZhdktheXJTSk92TnZO?=
 =?utf-8?B?Z2duVnRuVFl2cGJWRnU0ektUbi9VVXBiajM4QzBTeXdJWGo5alZ2RUR2K1Fx?=
 =?utf-8?B?UXVSeWd1YkNGRmJTSTF4TXV6SDlxSENoM1lYMml3T1I2bXloL3IwcUI5RmlJ?=
 =?utf-8?B?WTNzOFRzVG1vcUFCVlFZZ1N4bzNMRmY2a2kyU0RrZ2c3anFtMXFBK0tLUWNv?=
 =?utf-8?B?a0dlMmx4cEFxUzJKYVpjWGV3M1dQRTJBakRJL2dHQXFVcDh2eC9rNmMvQzcr?=
 =?utf-8?B?bGdHdE1GdFVzUExSZ1RMOUYzbEpVNzN5UDFkYTdDWm1YSjRSblVUSFRYVEpn?=
 =?utf-8?B?ZkxsYTM2SWJFSVpqZldaTUZtenA1M3NKak13YVdFRW44QmtZbWt1TDBCbCsv?=
 =?utf-8?B?c1FVamFFUXV5NGxHODlHZzBaTEh1blQ3SmNDeXgybE00ajNQUmxkdzVIYmY1?=
 =?utf-8?B?Uk9SV3lNQnR6Z2x5SHB4bHVNWnBMWHptdXBpV1dxYXFGNjFwajZpZmVkcGY4?=
 =?utf-8?B?NHQzUWZEb0o4T2hZQzFmdkltbHo0ckNmSFlhYlBCdW5tSTlIMitRUzRQVGdm?=
 =?utf-8?B?RnBQb01DVExocGM1dm9nRVBXMzF4OXBsWU1CMWlzMFAxbGcrclFkRDV6SzlW?=
 =?utf-8?Q?iPkQTQ+K91MccXQfwW4Ank4=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QnQ2T0Y0U3RvV01CQjV6QXdlTVJhdmNETFlTRVVldGNiZGNjei9VKzVoclp5?=
 =?utf-8?B?aEM0UFNlN0R2VHl4L0xxVGk1T0p1am92MVZBMnpiV1Jnek52VEtBbXQrd0tC?=
 =?utf-8?B?YldaYWQwTXNHM1k5SkFYWjFuZHM2MGZPb3g0QzVGNmZyZFpVNFRZUWk5OEZ1?=
 =?utf-8?B?QWJvNDFwSTY2SXo5Vk1jS2RQY2JtbjhobEhVM0haY3J4bnl4ZC9LVjlrMU5x?=
 =?utf-8?B?c1l1SGRXcDEybDMvVVl3ZDBxc0NCUzJIY05CT2JtRy9DZXdWdm5XV3VVK3Yr?=
 =?utf-8?B?aTZkZzJmNDRhWkxaMk9QWWxIZXgvcmFNU0l0MGtiNE9qRWRiVUJ5Z1pmMW43?=
 =?utf-8?B?QVZINnV0Q0h4S2pkS0dJQ3dvWG5OalZSemtZWXFocXNSc0pJNFNFRmxUSU0z?=
 =?utf-8?B?WUkrMXBMWEFORExkaDVzT3R0c3RUWll2ZmdZUmhvcDljNzIyOHdFWGgzelAv?=
 =?utf-8?B?aUdPem96M1NkeDN2K2JLaUQrb1ZWZzJzOHZvVDVleUczR2JMdm9qVWptQ0Fj?=
 =?utf-8?B?RCtMUnIvVW1oZEYxUkRheW9pdWFXdjhWRjZCYlFId0QwN3d5cEs1S2JXQUp1?=
 =?utf-8?B?Zmk5a2NxYXJFZ0Z3STIybGxqMGRtb1Q5TWtOOHZHN0FPbVY0a0tycEtKZENY?=
 =?utf-8?B?Vmswd0Izbnovcm03Vk56d2JSWHFpSXladnR0UjIwVFJIbmhMaUQ2VmFTQnFm?=
 =?utf-8?B?Q1haajJkOS9KNTNlcjZNMVFTOHU4UDQ3bjI2VmtHRUlYVDlKZ0xDZTRKV3JH?=
 =?utf-8?B?azVPNEI4SFVXOVB4aDlCSlRGZXhwMXR1WkE1bmlzZ0Z4Nmh2c05CT3R3Zlg5?=
 =?utf-8?B?UnBXVFRSWENKSEE2QmFXYTlpY1pQSk8wQndOaS9sQ0xBY1JPRTArUGladGRQ?=
 =?utf-8?B?N1ByS1p0YUNzbHFCUE9kNEZ1eUV5Tk5Ya2pKSDN0bnZpUi9mV1pxRkd4aVFZ?=
 =?utf-8?B?Nmd5ZmdVTHZ1c3BKdmhxbVFKYlBEQjZ0QVZlRmE0bno2bDJ4TzJaNU83SWp2?=
 =?utf-8?B?WDBBbzhKTWhWSHpNRkVxSkk4ckIrUTVScmtEZ1podVdlNk1FL0U1RUsxNThY?=
 =?utf-8?B?RzlFK0tMZDlIdGRGUUNwMHB4QlFESGpJeUNiaXlFczVuRGhuTTFJcWZONElz?=
 =?utf-8?B?T0RZdEVqUkZTQjBvbHBzeWZ1MktDQ0RYeHk5OFVUT01nZmlldFJYeGlPN2E0?=
 =?utf-8?B?anVOcWNScHFoQ2thenY2Rmo4NHhQZzdkdmZYcll4ZGk4M21kYWRQSkcycWxa?=
 =?utf-8?B?TUtQeWttWE9CTFJFOERPV2xubFNBNFMyZWl3b0RCbDlXcllSN2t2LzljZzYy?=
 =?utf-8?B?VHMxQXFXb3dwdENmNHhBUXFVa1hNTC9BaW43bG9kQjNRNStZd0VIR2NPLzhP?=
 =?utf-8?B?SElqVU1KWmlra29mbVRMbGZYTlgxNmVlQTh2WUFDaTV6Z01GYnk3SFRZUDNa?=
 =?utf-8?B?MXlFV1V2dVl3ZGUvNjVrYUdKbWM4RXVCZ1dwRkw4ZUxtRnJLVDBrdVpaOHZ0?=
 =?utf-8?B?M1pYNnN6R0RidkNQeC9qRkkvelpPT0ZLcEdLMFc5b3RDMVJSVnBlelJQaW95?=
 =?utf-8?B?Vm9hWUhveEhSaXJpSVF4RVJLRFBUTWZyUzU0RE9CMTRtQWg1Z3NWT0ZNbHpl?=
 =?utf-8?B?VWxCREEydmZvOVllMmhMbHZUdDVDdG9qWmpLc2FRMEhzRCs0QUlRblhBSE0x?=
 =?utf-8?B?MFhKMHZTamhJUjU3ckZqM0YvMGwxZ1RSZUM0ZHd2eUxRMWpWZnp6dzF3bFFD?=
 =?utf-8?B?OGV5eWxTT1NQenlhQmRndzZTekFVTTgvVklyb2tBelNldzlyT3FneFNza2pE?=
 =?utf-8?B?M2hlY2ZXUHFuN3llZmswNzJNU0JEY2lPZTIzMFQrRDFxNXNEa0JDTkM4Ujlt?=
 =?utf-8?B?RXRmZitIcVh1NHQrRFRUT2N4ZFhKOGM4WjFNbUI2bjZpbEt0dFUxVlJSSDN2?=
 =?utf-8?B?TnFtT1ZWdE9XbHFCbGU3T3NyenY4bjhieTRxa2RqOTM4bFZsVE9IeXBPU0d4?=
 =?utf-8?B?cmwySjJMNkdFV0FtRXpvTEdDcVFzZWp6b0hUbWJ2aUp6eUNxeko1Znp3TGRw?=
 =?utf-8?B?L3hLc1E0SFl1ejBoM1FoRWF6MEQrWXBacDhVOTJub3U4YXZ2ZkNvMFl2SkdT?=
 =?utf-8?B?bXJ3ZDVWL3JaQ3U3YnhIbHJBRGl1T2d6L3VDeFlrb3lyekVKZDdYWnA5dXZl?=
 =?utf-8?B?TVpFWXJCQlRXZTNhOXBod1B6ekJIbk5PZmp4aFIvaW5GVGJkdDhoc0JvbkZX?=
 =?utf-8?B?NVZhbWl0cjlseE54eFZKWHl3aWJkdjkwQnRCUVVienl0a2M0SEJsSzlldTli?=
 =?utf-8?B?SEpOc05YbWpMcnNubHd2WW9kbEcvbHI1cXpxVU9aOFA0MGJtMGdYUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF7E7D25688D774CBFE32F77CA64C424@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e3d377-6f25-4f5d-f18a-08de731ce732
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2026 20:48:30.7788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vvRVYRjiVC1+XXaVNePgzuUyICyHeg2ggMUkjFGOeXsFTsKJ15a8IKNS4ajgE8B6mXw2HAy4YZ44qR5JqkHKQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8359
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71526-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 5DB6D17D41A
X-Rspamd-Action: no action

T24gTW9uLCAyMDI2LTAyLTIzIGF0IDA4OjU0IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBNb24sIEZlYiAyMywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IA0KPiA+
ID4gQEAgLTM1NDAsNiArMzU0MCwxNCBAQCBzdGF0aWMgaW50IGt2bV9oYW5kbGVfbm9zbG90X2Zh
dWx0KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiA+ICAJaWYgKHVubGlrZWx5KGZhdWx0LT5n
Zm4gPiBrdm1fbW11X21heF9nZm4oKSkpDQo+ID4gPiAgCQlyZXR1cm4gUkVUX1BGX0VNVUxBVEU7
DQo+ID4gPiAgDQo+ID4gPiArCS8qDQo+ID4gPiArCSAqIFNpbWlsYXJseSwgaWYgS1ZNIGNhbid0
IG1hcCB0aGUgZmF1bHRpbmcgYWRkcmVzcywgZG9uJ3QgYXR0ZW1wdCB0bw0KPiA+ID4gKwkgKiBp
bnN0YWxsIGEgU1BURSBiZWNhdXNlIEtWTSB3aWxsIGVmZmVjdGl2ZWx5IHRydW5jYXRlIHRoZSBh
ZGRyZXNzDQo+ID4gPiArCSAqIHdoZW4gd2Fsa2luZyBLVk0ncyBwYWdlIHRhYmxlcy4NCj4gPiA+
ICsJICovDQo+ID4gPiArCWlmICh1bmxpa2VseShmYXVsdC0+YWRkciAmIHZjcHUtPmFyY2gubW11
LT51bm1hcHBhYmxlX21hc2spKQ0KPiA+ID4gKwkJcmV0dXJuIFJFVF9QRl9FTVVMQVRFOw0KPiA+
ID4gKw0KPiA+ID4gIAlyZXR1cm4gUkVUX1BGX0NPTlRJTlVFOw0KPiA+ID4gIH0NCj4gPiA+ICAN
Cj4gPiA+IEBAIC00NjgxLDYgKzQ2ODksMTEgQEAgc3RhdGljIGludCBrdm1fbW11X2ZhdWx0aW5f
cGZuKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwNCj4gPiA+ICAJCXJldHVybiBSRVRfUEZfUkVUUlk7
DQo+ID4gPiAgCX0NCj4gPiA+ICANCj4gPiA+ICsJaWYgKGZhdWx0LT5hZGRyICYgdmNwdS0+YXJj
aC5tbXUtPnVubWFwcGFibGVfbWFzaykgew0KPiA+ID4gKwkJa3ZtX21tdV9wcmVwYXJlX21lbW9y
eV9mYXVsdF9leGl0KHZjcHUsIGZhdWx0KTsNCj4gPiA+ICsJCXJldHVybiAtRUZBVUxUOw0KPiA+
ID4gKwl9DQo+ID4gPiArDQo+ID4gDQo+ID4gSWYgd2UgZm9yZ2V0IHRoZSBjYXNlIG9mIHNoYWRv
dyBwYWdpbmcsIGRvIHlvdSB0aGluayB3ZSBzaG91bGQgZXhwbGljaXRseQ0KPiA+IHN0cmlwIHRo
ZSBzaGFyZWQgYml0Pw0KPiA+IA0KPiA+IEkgdGhpbmsgdGhlIE1NVSBjb2RlIGN1cnJlbnRseSBh
bHdheXMgdHJlYXRzIHRoZSBzaGFyZWQgYml0IGFzICJtYXBwYWJsZSINCj4gPiAoYXMgbG9uZyBh
cyB0aGUgcmVhbCBHUEEgaXMgbWFwcGFibGUpLCBzbyBsb2dpY2FsbHkgaXQncyBiZXR0ZXIgdG8g
c3RyaXAgdGhlDQo+ID4gc2hhcmVkIGJpdCBmaXJzdCBiZWZvcmUgY2hlY2tpbmcgdGhlIEdQQS4g
IEJ1dCBpbiBwcmFjdGljZSB0aGVyZSdzIG5vDQo+ID4gcHJvYmxlbSBiZWNhdXNlIG9ubHkgVERY
IHVzZXMgc2hhcmVkIGJpdCBhbmQgaXQgaXMgd2l0aGluIHRoZSAnbWFwcGFibGUnDQo+ID4gYml0
cy4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgc28/ICBCZWNhdXNlIGV2ZW4gdGhvdWdoIHRoZSBTSEFS
RUQgYml0IGhhcyBzcGVjaWFsIHNlbWFudGljcywgaXQncw0KPiBzdGlsbCB2ZXJ5IG11Y2ggYW4g
YWRkcmVzcyBiaXQgaW4gdGhlIGN1cnJlbnQgYXJjaGl0ZWN0dXJlLg0KDQpJIGd1ZXNzIHdlIGNh
biBzYWZlbHkgYXNzdW1lIHRoaXMgaXMgdHJ1ZSBmb3IgSW50ZWwuICBOb3Qgc3VyZSBmb3IgQU1E
LA0KdGhvdWdoLCBidXQgQU1EIGRvZXNuJ3QgdXNlIHNoYXJlZCBiaXQgaW4gS1ZNLiAgQW55d2F5
IGl0J3Mgc2FmZSBpbg0KcHJhY3RpY2UuDQoNCj4gDQo+ID4gQnV0IHRoZSBvZGQgaXMgaWYgdGhl
IGZhdWx0LT5hZGRyIGlzIEwyIEdQQSBvciBMMiBHVkEsIHRoZW4gdGhlIHNoYXJlZCBiaXQNCj4g
PiAod2hpY2ggaXMgY29uY2VwdCBvZiBMMSBndWVzdCkgZG9lc24ndCBhcHBseSB0byBpdC4NCj4g
PiANCj4gPiBCdHcsIGZyb20gaGFyZHdhcmUncyBwb2ludCBvZiB2aWV3LCBkb2VzIEVQVC9OUFQg
c2lsZW50bHkgZHJvcHMgaGlnaA0KPiA+IHVubWFwcGFibGUgYml0cyBvZiBHUEEgb3IgaXQgZ2Vu
ZXJhdGVzIHNvbWUga2luZGEgRVBUIHZpb2xhdGlvbi9taXNjb25maWc/DQo+IA0KPiBFUFQgdmlv
bGF0aW9uLiAgVGhlIFNETSBzYXlzOg0KPiANCj4gICBXaXRoIDQtbGV2ZWwgRVBULCBiaXRzIDUx
OjQ4IG9mIHRoZSBndWVzdC1waHlzaWNhbCBhZGRyZXNzIG11c3QgYWxsIGJlIHplcm87DQo+ICAg
b3RoZXJ3aXNlLCBhbiBFUFQgdmlvbGF0aW9uIG9jY3VycyAoc2VlIFNlY3Rpb24gMzAuMy4zKS4N
Cj4gDQo+IEkgY2FuJ3QgZmluZCBhbnl0aGluZyBpbiB0aGUgQVBNIChzaG9ja2VyLCAvcykgdGhh
dCBjbGFyaWZpZXMgdGhlIGV4YWN0IE5QVA0KPiBiZWhhdmlvci4gIEl0IGJhcmVseSBldmVuIGFs
bHVkZXMgdG8gdGhlIHVzZSBvZiBoQ1I0LkxBNTcgZm9yIGNvbnRyb2xsaW5nIHRoZQ0KPiBkZXB0
aCBvZiB0aGUgd2Fsay4gIEJ1dCBJJ20gZmFpcmx5IGNlcnRhaW4gTlBUIGJlaGF2ZXMgaWRlbnRp
Y2FsbHkuDQoNClRoZW4gaW4gY2FzZSBvZiBuZXN0ZWQgRVBUIChkaXR0byBmb3IgTlBUKSwgc2hv
dWxkbid0IEwwIGVtdWxhdGUgYW4gVk1FWElUDQp0byBMMSBpZiBmYXVsdC0+YWRkciBleGNlZWRz
IG1hcHBhYmxlIGJpdHM/DQo=

