Return-Path: <kvm+bounces-31537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B96499C4824
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 22:35:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6049AB2C8CF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 21:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4296D1BCA05;
	Mon, 11 Nov 2024 21:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iwOyVw8X"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559921BC9F4;
	Mon, 11 Nov 2024 21:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731360503; cv=fail; b=PklywR5FGUhVDl9XzJeKnvJFdcQlYesHYyEbp3O10znU6ykgiSXOaCpAU3wSg7+16BMDfuCWVbv50DpvcZCiEk9KmLcGsDw/BDsNHBzFARe9CVKZSBuoGmJPKJtnYHYRE1ZeHob13aoKYLqO6s7iW9ejZoRYgyczs9LOZnK5bCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731360503; c=relaxed/simple;
	bh=7BvmCUdqo5sB5ZKHQUvLsT+CWADN9/9aJvz1EJEF1sU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mex3DyziO8fKalP3F1VYh7/XfQdoQmg7g+SsfvGIlEJqGKlf5BO+HAAuJr+13SP+qi4xZjHQC3K/ICJJ+3y93d9/Mp9LGvaIVh8U0FYuK1kfCOt86wU8h+YwEdWgTcRirs+nAKPCwvemVizVqBm8UuWx75KDnUqp1nSjEDszOnQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iwOyVw8X; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731360501; x=1762896501;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7BvmCUdqo5sB5ZKHQUvLsT+CWADN9/9aJvz1EJEF1sU=;
  b=iwOyVw8XrI4UEg8DqM3FqLuIgxaoAuuz2OtNqR00KVSADIFacp2yHgKm
   XEK8fJFf5SG67Dkb+mnj0uEpASezPFaCVzm8DAVKxvgdMloOLGCl+iDjr
   8f4OblcOOZNpsfOEs50L9LtJZBVFlsxe8KKVf8uhA9Al/OzCRQo++OeSv
   Bj+6ZD56nYor3gXjtDilVbEWdbaz5x1V9xiyFQs++Of4BuyHojuI2nnZL
   d18zA+zDXlv/BY41phJpd1AO/z8DhfQh89ujsEl8Ayh0eyaGHWS+Rx/Ov
   x2VuufwyAAP23aBa8wQR3afqaaNXFV+Q9GN42sefEyCpeYZfm5Kn8XnD+
   g==;
X-CSE-ConnectionGUID: pYX2kAp6TrGlFHKlbAA23A==
X-CSE-MsgGUID: PbPCoxEaS4OUZ6/RI8GS3A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="53737743"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="53737743"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 13:28:20 -0800
X-CSE-ConnectionGUID: S5mqCidFRbWV9WMlK2oUSw==
X-CSE-MsgGUID: dDxSZ00HSB2AOwe5l4pyqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,146,1728975600"; 
   d="scan'208";a="87059561"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2024 13:28:20 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 11 Nov 2024 13:28:19 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 11 Nov 2024 13:28:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 11 Nov 2024 13:28:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zDaHC+UrUTnNCHW7EZnKpH+nnGvAmS6auLr9I/cNT0IDJc6I8NiDGLoPk4jPTiGJcQTRUlTpRXXtTaMJzPGeKNZkwH5HhqFnSLaW8bsREqH8M95qj05hn6mur6Lc3l+V1nAiRXgSZHMcrGMUg5xQg6bukSFPCcb/iRGEp/GxfoV+6TNSGA25YE6mgimFqOJ+nEAKfOT+dUWfRuddmHBmeBBNjVwXNeu7l667iCAVUrX+nIHA3c4wuz3AuLDM7OjEcujf2y+zRbp3FZ82X5lttAofT0gFqwTm3KSCOrvRa3IL2zP4hRE0+FzGgfOU9quh4zhMnmhK6Hp4wOlMlKWCeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BvmCUdqo5sB5ZKHQUvLsT+CWADN9/9aJvz1EJEF1sU=;
 b=YiwaEX8u+NGoIFp6nGVRzbHv3J++ril658TbSaqy1pJ823y7LtJhjuDWmDCZSvBJvMglZrpHFVlHEJ9KDO27TVzGnkPUHTnomYfkdVRFU55395S29268i2h96f8ya8HSkRycHfLCKDRiNzfXnAfk/D6KBwWAOa2tfZvbNuLyf2ganV/qBqQlBnKYJ5xSOY/xRdK91z/Zdg4aAW3p6c2iFqLpJM7VPCvMRK5VUgppke1hdThSzUhPUgPvcx542EMDj45TL1MK4MWkE4gTcb34wZST/6H+wvsjLyOgIoft6ys//87CHyukXejtxX5UMU4RT5ASWI8hAE8+r6TdWpxnMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13)
 by PH0PR11MB4806.namprd11.prod.outlook.com (2603:10b6:510:31::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Mon, 11 Nov
 2024 21:28:16 +0000
Received: from PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad]) by PH7PR11MB5983.namprd11.prod.outlook.com
 ([fe80::a5b0:59af:6300:72ad%4]) with mapi id 15.20.8137.027; Mon, 11 Nov 2024
 21:28:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "nik.borisov@suse.com" <nik.borisov@suse.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Topic: [PATCH v7 00/10] TDX host: metadata reading tweaks, bug fix and
 info dump
Thread-Index: AQHbNCWIZ2qemHMuw0G7kdYKKGDupbKyiauAgAAEUoCAAAMnAIAAB8qA
Date: Mon, 11 Nov 2024 21:28:16 +0000
Message-ID: <1bd6a48d06e9bbf05ce5d6b138955b4306e2e383.camel@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
	 <0adb0785-286c-4702-8454-372d4bb3b862@intel.com>
	 <f5bc2da140f16da41af948adb50a369840ff890c.camel@intel.com>
	 <c4adf8da-fac0-4a1a-9b83-7a585fc63ca2@intel.com>
In-Reply-To: <c4adf8da-fac0-4a1a-9b83-7a585fc63ca2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB5983:EE_|PH0PR11MB4806:EE_
x-ms-office365-filtering-correlation-id: d025188c-9ec7-4b73-3498-08dd0297c189
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?NVIrMGk4NTVpMjBTb09jbS9XNWJJQ01rOGVZeExidHlpaHpqS0RRZ0ZNWXNl?=
 =?utf-8?B?SGZQRVU5dTVYSlBOaXJqV2FTTTU1T200WllTNW1LOFBGK2xJSkNoakZJVEUr?=
 =?utf-8?B?aVZwWG5UTGMvRVBrZTE5dmVJSE40TFBXaHd0a1h0d2lraVNiUjYveVFsalZK?=
 =?utf-8?B?ZUxmUEVPRVFqTEUwaWQ4TGpLZTBtdUpjMnh6ZmpjNDQwd3M0S0dYbVgzOTh5?=
 =?utf-8?B?V3JkblNCaitLdm1Pckg1NlFPUGVWK3dwNENCdHVPeTQ4QlRyeWFVS1NsZll2?=
 =?utf-8?B?ZnA2eTh5d2xyRkd2Kyt2bnZsV2o1STNtbncvdGNQNWZQVXV4QzRNWDM2Wlcv?=
 =?utf-8?B?cE9IVU9wU0xsQzVRWjlhRWVEdmc1QlZaUW5kUkJuUmFRT1cvQXB4VGVORW1O?=
 =?utf-8?B?eXBYdU9NWWVZU1dyc2EzTUYzN0RsbElRa2lWU2VzR3IxeXdncVhLRGFuVktv?=
 =?utf-8?B?ckpOVHZCVk1ieTE0QUZja0I1alRtNTFEZE9OTktDcmJwSW1jWFNRdjg4clBm?=
 =?utf-8?B?RXdyTFFZSWNBcVFVMmNOaVQ1czhPZXJBamJ2TnAwdmNIV1FJdHQwMXVYNlcw?=
 =?utf-8?B?ZHBFZHNEaUk3eW5CN3c2MTBIcm0xNThQa1dFS2dKUGJuOFdtYXprQnNwTk04?=
 =?utf-8?B?R1lMa04vZElTMXkvczU5a0lFQzhVZkZmZ1NhdktFaGgzSnBIUDZUNEFjSVVs?=
 =?utf-8?B?akF0bk42RlU4VUltTXlHRXhCOGFWVm1qTkdRTDFkSDVzTDhmZmV0MkpZRkdU?=
 =?utf-8?B?UmVEZllYN2dKNWt6SVEwSzBKajNLYTZCWU5WQWxKU09VMTFBclp5VnBsWFR6?=
 =?utf-8?B?MWh6emJpN0pYNnR3UUFsU0tNdlZDNjZxNisydXg3NjJ3djRiM2xXZjJBUTNH?=
 =?utf-8?B?MzdNZmh3R1pLZHdZVEk4eFFTaFF1YUJFZHhwQ1ExR2ZSbTYvbTQreEhhWHNU?=
 =?utf-8?B?ZDJQSmd6WVc2YVBLakFGVjQ0cmFrZFNzbkpGdi9ERHdNbThZcVV6NzJTckJh?=
 =?utf-8?B?aGpZL2NzZlZaYXBNRWw5b0ZJRlJadDRWY01YSTBPZGY2R2NtVzJTQ1dqTmNx?=
 =?utf-8?B?QXVqUUZQUy9rZjkvL1pBckhTMVZlMXhhemhPY0l6bVhybXlydzVyOXZJUHRD?=
 =?utf-8?B?VVp6V0Fhc253ZVpFdlFHUmJ2K2t3K1ArMlJ1dENrZFF4dzdGdkxDM0VxOTMy?=
 =?utf-8?B?L1F0T0xJaXVya2xWaStCcllkUlJoUE50bFA2L1FSMW9IYUluOVJUWDBNZEMz?=
 =?utf-8?B?bDl6L2loRlVFU3dUMVpUTVkyTzB0U3JudlBDaUFJZVVJUFI4cFdabjJWV0xa?=
 =?utf-8?B?cDRZemJ3SEpxMFBlbWhIdzM2bHBFbWh2YkxYOFBsS2F5cVlaOFdBc05nMVlx?=
 =?utf-8?B?b1FvTXIrUy9XUkQ5MHVJamNJOTR6bHQ4UG0zeld1Tm51VnZ3V3U0aDZ5WjBj?=
 =?utf-8?B?cUY5Ym1Ha2tVU0ovLzg4WFpkd3M5c1BXOVU4YzVwK0F5QmdFZC9ZV2poN3ZE?=
 =?utf-8?B?VTFmUDF1eS8waHZpcUxzUjh1OTFHWkh6RUpzRTdlSVRZUUp0WldqOE9kWDJR?=
 =?utf-8?B?TkdpRUFsMHBJcDdQQjJGcVlySHB4NDBpNHZhanRoV3M3UGlCRDBya2dYY3Rl?=
 =?utf-8?B?TzdnTzVWc0FNekNESFBIdnFIYVQzZWNYd2NvL0MxUGRHNC9naGE3bDhMQUNp?=
 =?utf-8?B?Z1VKZmc1MkdrVzlMY2czUTAxb1NwZzZuY1VpNklrN3RnT0FNcTBIaEpJTmNY?=
 =?utf-8?B?ZHFkb216V2hoQWR2dTlvS3VhLzFtQi9td1pidG1uZ0FWRFJ1RWpyTHdWRWxV?=
 =?utf-8?B?UWZ5Y2pjZHU2TE93TmhXVkZRT2tkbkFBUjN4YURCdGpEUU9mZTdsYVpITnI1?=
 =?utf-8?Q?MMz5vpYlaHweX?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB5983.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cUdMS3Q3WVBRZW1qcmhlSWczSHZndCtpOGwzSFh2bWNqUDZZbkhURk5rWEdn?=
 =?utf-8?B?T0UzR0xSeFFWYmlIMDBKTjJEbUNBVWVsSGdmUkFUK3lPV3VBZ2RVWENLemJ1?=
 =?utf-8?B?NWhrNThMdzdRaVJNbFcwZm1IL3MrVnlVS2JIcmliVENkZ3FaRTBaWVNQUlBm?=
 =?utf-8?B?emx5SEp2VCsydHkydE9lMEExNEROSUdLdHFqZEpGMG4vSE40SkZKMzdHUDZV?=
 =?utf-8?B?V2tIbTllblRnNTlsOCtteXFtYW1UajJyY1ZlRXYzbm90dmV5N2ZlcEpNak1T?=
 =?utf-8?B?QmNjZUwxd3VhNmcxdlM0c2czS0xaMmllTCtLelhEZW5ZcnFnTVpUdGxwU25M?=
 =?utf-8?B?blpqR1VjeDk1MU9ORU1JNEsxRmhFRS8wdGl4Ui84dlpHWlh4K0dMNU9IZnVq?=
 =?utf-8?B?VW5wVkU4cDFaUzBRci8xNkI2amF1Yjg3QXl0SndVd3RWNE5aYU8xcmtEcUF5?=
 =?utf-8?B?SlZuK1hJVU5rTk9NOGU0UVp6UXZLSzgvK2tGMGNTcTY3a1hBaGE1elZPMi82?=
 =?utf-8?B?Mm5TU3NPTytLOHhlcUVmRVVLc1lROWhXb2dVMW1DWXZjQm5mRldSZWpQSmlC?=
 =?utf-8?B?SlVYUGZZQlZ4OWovbFlKbCt3NG94d2hGMkM1Y2JpWDlrWWdtd0VjZjdia0kw?=
 =?utf-8?B?K0JBTklvZXRHd0tSYkFDS3pnQllhMlA5ZmFaYkNXUTI2VmFaZWhid0VZU0lP?=
 =?utf-8?B?R1prVEJLWjBSdE5VVytXTWpLbHJqQ1E2M2cvbUNpYkk5Rjg0YnFndEw0ZnRx?=
 =?utf-8?B?V2tCR1lVdXVxMGpvU1JsYytRdXpSbDN0Unpjc25vandtNG5aTkphNWZBZjkr?=
 =?utf-8?B?aStlVFhrN3BpODV2bE9DeVBiRUxmaWJRbVh2dW9nNUg5TXlLdG92TmhrOEZv?=
 =?utf-8?B?S3hubnpUV3lTWXZNaEJEZVNKY1haaFhzOWVmS1ZSUUpISVJTeGl5M2UrdEd6?=
 =?utf-8?B?aFpoOXVndktpdithcjhTc2ozKzBWMExXMG1FR1U1emx6REl1bUNraWhHeFdQ?=
 =?utf-8?B?QjZzSWZ1N2ZCWVNKR0hZeVVQRVc4bHk4ekVKem81M0QxRVFIMk8xaGwwdkV2?=
 =?utf-8?B?OVRGL01IdEd2cUR2aWw3QXRIYlJWYkJaYkwwMFNKMkh5M0I5czBCSFpya1FO?=
 =?utf-8?B?ZHc3Q0JOa0xYZjdYNGsyQnBqdHZUdFhQT3Fvb2VIcWJpL0t3dUZsSCt6TkVR?=
 =?utf-8?B?aDNWbE41YjdoVko4NldpYVBOSFZ0cXdUcng2T0FGT0djRWZJTkF6dlp3MzB2?=
 =?utf-8?B?bmFCeWVTQ2QxUHhuZDkyRTYyMTZSTi9nczVNWTFHTkVjTG9hTFA5QmQ4bzVS?=
 =?utf-8?B?ZTgrdlRCNm5lYnd1MjNqRklETnliZG53MFJDSE54WlRCUCtIeFdseE0yRFcw?=
 =?utf-8?B?OG91MEJHdHhnbEhXREx1bStWTWVWQkR2TlZFOFZmeHkwUUxsSUtNbHE0UkJI?=
 =?utf-8?B?UkViVHNTcnJlVnZZUUo3S1FiWHFmRVpCR2V5eHFlQmg3MDBnSUg2Tzd0bE9Y?=
 =?utf-8?B?ZS82d1k1OGJHanRmQnBnekJUS3k2REFGM1oyeDlCWFl1K1htaWJIQ0RIWThk?=
 =?utf-8?B?TUNxU2wyRUFJeU8xc2hsVEU0bzRseitwNnNwM0dZVU10YUVGU0tpemtoKzhM?=
 =?utf-8?B?WlFOMjkwZEZJTnJXWWlzZStkSlMzclhtekgwbWxjb01TMzlTSFhNWUJvMFJZ?=
 =?utf-8?B?SThNOHBNYStpZmJUZ1YwY3VkWnFuRjZER0NVTGtHQWZDcE13TWQ1bkFCSHMr?=
 =?utf-8?B?ZTFJRFNDWkhEbGVheXBDOFhwQnJYL3FFRnVqMHhaWS80NXZBV245YnZvMnhw?=
 =?utf-8?B?azBwREJFYXZzL3RwVWtiSzYwZTVXY01HK3lIUmVOdEpJU1F2Z0JnUG9tdndH?=
 =?utf-8?B?UHNIek5MQVZyNGpSakRmd0tuZHlZZzRPUEdKdW0rcFlaeDF2eTZCMlcrWUxi?=
 =?utf-8?B?OHJvNUhZdEthYk1vd1JTQ3FVOGp5eFpJbUdCOXoreExHbHdIVDIzMDdxd1lk?=
 =?utf-8?B?d2txQUNJMG94UlVqb2huNjlidHc2dTlFaFNidFc3NjAzeFArbkptSGRxN09k?=
 =?utf-8?B?WGpqeGJOTTluQkh5YzF0L3g5WlRVcXR0dTdpZWUwcENUNXZ1NVdsVXd0dk5D?=
 =?utf-8?Q?duwYCKfw3TIKDY8/56nrEqdMK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <109F27CAD010CC4CA8C10A3AEC120DEC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB5983.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d025188c-9ec7-4b73-3498-08dd0297c189
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2024 21:28:16.6553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QYHLVaz3i0UaJhHlRhheEBXk6VFbwWzr1dPF5f88HFekciodiZoTUEb9PT58oZliZLYyt0DxnP+mQT1YUGAuCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4806
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTExLTExIGF0IDEzOjAwIC0wODAwLCBIYW5zZW4sIERhdmUgd3JvdGU6DQo+
IE9uIDExLzExLzI0IDEyOjQ5LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IEl0IGFsc28gaGFzIGEg
cGF0Y2ggdG8gZmFpbCBtb2R1bGUgaW5pdGlhbGl6YXRpb24gd2hlbiBOT19NT0RfQkJQIGZlYXR1
cmUgaXMgbm90DQo+ID4gc3VwcG9ydC4NCj4gPiANCj4gPiBKdXN0IHdhbnQgdG8gY29uZmlybSwg
ZG8geW91IHdhbnQgdG8gcmVtb3ZlIHRoZSBjb2RlIHRvOg0KPiA+IA0KPiA+ICAtIHByaW50IENN
UnM7DQo+ID4gIC0gcHJpbnQgVERYIG1vZHVsZSB2ZXJzb2luOw0KPiANCj4gV2hhdCBpcyB5b3Vy
IGdvYWw/ICBXaGF0IGlzIHRoZSBiYXJlIG1pbmltdW0gYW1vdW50IG9mIGNvZGUgdG8gZ2V0IHRo
ZXJlPw0KDQpUaGUgZ29hbCBpcyB0byBnZXQgZXZlcnl0aGluZyB0aGF0IEtWTSBURFggbmVlZHMg
bWVyZ2VkLCBwbHVzIHRoZSBidWcgZml4Lg0KDQpLVk0gVERYIG5lZWRzIHRoZSBuZXcgbWV0YWRh
dGEgaW5mcmFzdHJ1Y3R1cmUgYW5kIHRoZSBOT19NT0RfQlJQIHBhdGNoLCBzbyB5ZWFoDQpvbmx5
IHByaW50aW5nIENNUnMgYW5kIFREWCBtb2R1bGUgdmVyc2lvbiBhcmUgbm90IG5lZWRlZC4NCg0K
SSdsbCByZW1vdmUgdGhlbSBpbiB0aGUgbmV4dCB2ZXJzaW9uLg0K

