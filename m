Return-Path: <kvm+bounces-21606-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 09B10930746
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 22:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA1C51C20DF6
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 20:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9040A144309;
	Sat, 13 Jul 2024 20:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wi+R7xVg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4866A125B9;
	Sat, 13 Jul 2024 20:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720902348; cv=fail; b=VIWZcybgr10fOO2+jZ7YDR75sQ5V1aO8zdCw9ClQGu3jsngezJ3GYp33frrYKsOwJtAQMT3GAxucQb4v6XiR1gZnOsn2+GKlkdz84+8Z20xfJAWAFC1S6IjX5cIN0i+UySScMq3s6zmQXRFmKHSoLg7LsyqAzSrnOWWagieLE/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720902348; c=relaxed/simple;
	bh=Cu0cO6kUrFDxHa1x3V2l4RVmcrBQL94j/Ii8QLtq17c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AVkhoe2kxeazJvv3Db1orQGwn4UbHdWL5/U/1sZaq4zh1WozI7jht3+CruJBWSGIE502NfEzs/br0YiVe2uP2ObxRHwqqm2lUJoMWfu2Qg2Tte0zdv+/9APtNlgikYWqyMfKaDD0bmQqnzc0Wj0eg2sg1Mzncvyg4EuSPf5FyiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wi+R7xVg; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720902347; x=1752438347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Cu0cO6kUrFDxHa1x3V2l4RVmcrBQL94j/Ii8QLtq17c=;
  b=Wi+R7xVgSnfVYtjJ54tJH65TckkoIqFINHBBX7wWdZIiVwvjAYghK8vW
   1zllegCMQ7Bxy3/kLMa8yKbp2IO3t7KF9bHjXDwJpWv/2VE5dbp/aghx3
   mc51cpEzL99IW71g4TMm9s0xdXLIAbXDLIy2YIWQnmmUCkAL3NUdstRnD
   Z3tYnCzXnLXmijPxteiyUOd5es/G4QmV1udb0/kI4YK9zUfY4/G3MIczZ
   5Y0lyeAiFGoMP6dzHVe5xeTbg56RQv9XCwTmR1Dlu0bEKpnFDYfgXSJ5V
   prhntOkzg9niEqCwQZ7BRl+pMIEQXTJ9xhSLR99E56PPtYaH2YCshXsM/
   w==;
X-CSE-ConnectionGUID: pgf1nLm1TXK/C9y5HJW8og==
X-CSE-MsgGUID: RNiZ1OahTimG4GQT71TWMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11132"; a="40855471"
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="40855471"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2024 13:25:46 -0700
X-CSE-ConnectionGUID: uuhkORzbR+STmGVCdLuORA==
X-CSE-MsgGUID: WWstoKOGQOCtKAM3SPHpcw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,206,1716274800"; 
   d="scan'208";a="54169261"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jul 2024 13:25:46 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sat, 13 Jul 2024 13:25:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sat, 13 Jul 2024 13:25:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 13 Jul 2024 13:25:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xzVkxPvqypjzwp0jMbCzVquHEmDfAxtnOSLOk4rgKRR7SN+i40YY0j3Vn8jQusM3z15rxhQgmj8T5u8vJnMtVmSagH1YFSZU1bOc3U8/YlOYqns3Pagco1IPSkpsPgYt6rYalRLA+hMVe7nOnpSQCyvOWFdqYtHg3xgb7StuRJcbFM2RBKfcsgjciuvnP8AJeTiQ7IXIGCU23TcL+2ZpUhW9rrCacgaMmcf1NmrUvR+uc3ydC6L4UTKm1GKwfQTaL0RYxLmQYzC+zHtcC1VqdoOVZI+9a3VRljbDm26k1u+kUPdhl6bVuS8OsoPSdVHr5w+7zxqbCN6LaEUK4LySbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cu0cO6kUrFDxHa1x3V2l4RVmcrBQL94j/Ii8QLtq17c=;
 b=xqUMbiqd/ebpT8UbE6zG8qtRat2ed3XdJ6jxJ40oxGSTI1wAN43iTrkFlCOFiky6x672/jYOEMzcGuZPDUaVbGUlUJYPf8B/KDsEHuGUIbP0KLJi+PdnCdPRz94HivdXJTWBO4ZpmkSSsojWOkJlqU7TA/Cn7YJyU+Vz5+IqXoAu7FYGONl+ATRKNFR6i/OoAqPy1O2EAcfYcr8s6Y6YtXk2fpyGHm6840Z6BhoqZuezZW8+r5bZd8iASmnOf+4jLEYMMPlYDCsJSiz6i1gf7A/z2h4Dlku8p/81ArbU7KfZ/c7uzrQo7H0hEOlQoCahVXWJWYanCasr+L03LwL16Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB8465.namprd11.prod.outlook.com (2603:10b6:610:1bc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.25; Sat, 13 Jul
 2024 20:25:43 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7762.020; Sat, 13 Jul 2024
 20:25:43 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Thread-Topic: [PATCH 09/12] KVM: guest_memfd: move check for already-populated
 page to common code
Thread-Index: AQHa1MP6tknHBB/QAEixGUJsVbkOOLH0cD8AgACr4wA=
Date: Sat, 13 Jul 2024 20:25:42 +0000
Message-ID: <97796c0b86db5d98e03c119032f5b173f0f5de14.camel@intel.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
	 <20240711222755.57476-10-pbonzini@redhat.com>
	 <73c62e76d83fe4e5990b640582da933ff3862cb1.camel@intel.com>
	 <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
In-Reply-To: <CABgObfbhTYDcVWwB5G=aYpFhAW1FZ5i665VFbbGC0UC=4GgEqQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB8465:EE_
x-ms-office365-filtering-correlation-id: 4261f7a0-3f2c-4107-a7ad-08dca379f831
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UndMY3pqZ1lsYnM1d0ttSVdVRUJaWUY1SzlrUEFGQk9XQXN6WVNNdE5QeXlz?=
 =?utf-8?B?U1ZTR1pDSWpWQmxqOWdHRjFtZ3BGSmo4clovbjk4ODQrdnlWd01tRXV5cXRG?=
 =?utf-8?B?dDBTWUxlU3ZUeGtDaFN5K2JLKy9GdEJlQWVRWGJITDBTcGUxTVQ1aHlhZG1o?=
 =?utf-8?B?b2t6aW1VRGtVbDQyeWV3czFlZURQcVhBT3ZYaFZVeEFyME5vbFJtQkhyaUs5?=
 =?utf-8?B?c2ZSeFBkdFk2ZFdlWU4zekZCQXlTNndGQUJUb0VLMFN6ODRWVGJOVzRTaU9z?=
 =?utf-8?B?TTA0NEFleHdwZDRmbVRLY0g4cXM2RHh3bEZoSEVMZStHa1UvQ3hqRXdCaTJs?=
 =?utf-8?B?UDd1dERlUHZRYTFVZ2hFczhzc0Uzbllpbk0raU4xeVJQVVZnaEVMclU1K3ZI?=
 =?utf-8?B?RzdKOEdrallJOVhqZW50enZMUEttTWN2Q2NraXVqdDAycVNjRFIyOERraStm?=
 =?utf-8?B?T2dFZHppdmZzbEdieXVoWitodUd2ZEJCazlhTTRkS00rQVBJcHZBVFBZQkFk?=
 =?utf-8?B?TFdNbWg1YXBMb3p3M3QzdEhuREUxMkF4WHdrcW9iZzczSCtSaWs0cE9RWC9Q?=
 =?utf-8?B?QXowSmp4QlF3YXc1NlhCeEZGbmdwai9UdUxwcGJVa1JwTzgvOXlLU3VMNkxP?=
 =?utf-8?B?SVlMekRYaXBGM3NkNDNaeUY3R0NCcjhlN0lmVjN2QXdORk11MERIdE9sdVRk?=
 =?utf-8?B?RzhrYTdIcEpHSUFReVRkZmd6ZGtVc3pqV2ZCZHZJYlV5UXZwNElaa1lDcDF4?=
 =?utf-8?B?dmFuYWhOemVpbnJpRkNtcmlUS3BqQVMvMkpxeUxtdTIzb2hHQTdqdFp4cEdF?=
 =?utf-8?B?Vmd2S1Y2MlFPTlNldTJOUWg0M0UzRTM1alExbGk0Z2NHelRUaEJaNENvaThV?=
 =?utf-8?B?Uk04aWN6b2pJdkRsbXhFUGNTRlROdUFnTkt2OS9rNjd5RGZndXo3dWIzd3BR?=
 =?utf-8?B?Ym5YRFdNNElHZ3VCSUNSM3FOM1kyL21aMWxzUUZuQStxNEo3U1F1em84bkxu?=
 =?utf-8?B?TnlzMllBcmE0MXdMMVp3WXVGV1FhVnJ0T1RJWFRxUjFOYTNhSUwwQjhJQ2pX?=
 =?utf-8?B?QkNkdysrZWJHZ2VRYkJFeGpwcVo3MHpqeFN6angvc0YxWG5td1B5anVieXBB?=
 =?utf-8?B?YTludnRudnYrS2dmeU9SK2FrbEdySkQyS3d5Q2M5VEt3N0MyV2JTUXNrQnI1?=
 =?utf-8?B?S1BoMEtSVmp4U2hzeDAyMHpVSVFqVU0rWXYyZk1US0V5SXJ5UHhSR1ovVVY5?=
 =?utf-8?B?VmlMbHEvaWhIbm0xRXV4VjNFTTg1K3JwRXlwWldHaE9LaVlNRjU3UnVCRVd2?=
 =?utf-8?B?Um1GTWY3aHFIQWRNUDh6SW5yNHFkZGpJYkY2aVN2VFpEak4ray9JZFNWaklH?=
 =?utf-8?B?d2FBTWZPWDhTdDdjYmxiMEJlM3ZBRXpwU0hMSUwyVGI3OVBnT3dpYUkzaTU3?=
 =?utf-8?B?NmF4czhuMndPS2paVkhtd3FmMWJPZ3ZIdUpIaVFNTU4vWlVJQTNzMGNxQUdL?=
 =?utf-8?B?TmRlQkpZRVBPbVAxb2VNRDcxTS82cGtOYUNtSXRleWxGbkJ4eGtlN0MxZ2g4?=
 =?utf-8?B?bENUTUdabFozRDg3dkJlQlBnWEFtWmRTb3Z4WndxUE55QVBNS1N5QTRxWkNH?=
 =?utf-8?B?OWEyVWZCMGtIWk5BRGRneEQ2TnovbSswcGtSdGF4TitxaTU3ODZzdzRidGhn?=
 =?utf-8?B?OUxYTnF2MHMwYkMydFBKRGx1U25KRUk2Y2lrSzhLRFhYVUtlU0tIclE3ZGVo?=
 =?utf-8?B?TVgxZ2J2WTlKZEpiQjdwd0liNWRJZVVHMXluaDlKUjJCMXhTVnZGL25RZW8x?=
 =?utf-8?Q?MaOiICJgHEWsnKWdE688ef4MCXVGUYqzhvxtc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c0lLN3dZaVo2d2prYnQrMGlmL2NuSjFJYTVWWk1IdG5WOGxnZm9TVjZSbkdu?=
 =?utf-8?B?cFROTk8xRkFUdlFXRHp0d0Z3WnIvSEhTbTVZREVXa1UrYnBKMDF1Y255MVNw?=
 =?utf-8?B?OFpKSDJFSzg2UFk3NTU5SzVaRGd2U2I3Qnh5Sy9ibHFCODJoQVpJeVpzYzRw?=
 =?utf-8?B?VzA3RVA1NTNGSngxb2hUWG5NcHRnSk1MME14WG4rNXlDUzhiZnVNTjJjQlNi?=
 =?utf-8?B?VytaNzNQU3VSdFJnWU85Ny93MGtad0dkRCttMUh5MVpmSTZLOFhQUjJROVZB?=
 =?utf-8?B?bTMrdUpZeFRTcEVrRE9uK2pEaGhlSkt4V2xJSWpWUFkrYWhuWTVxdlAzaURX?=
 =?utf-8?B?TmpvQi90NTNqckhCc21KTjl6SE4wQTMzb1hRbEFiQ2p4VUQxM3JDK3VwNEZr?=
 =?utf-8?B?TytNeHJHclBsTUIzQnBRekxnYUJYSnp4c094dXh4dUhGRjA5cnFGcEJqYnV0?=
 =?utf-8?B?Qk5tOHNHb2ZjYkF5VXo2OG9SZFBWaUxvRFJBN0k2dk01c1grYlU0aFVrOWRS?=
 =?utf-8?B?R0oyMy9xVS9mUDhyNWM5M080OEE0Y3ppYjd2VW84TEZNcHlvSExLS2d4RlNq?=
 =?utf-8?B?ZXhzZmlNTDExUXpGQzl3Q3phSE5xMDVQbGh3YzZraUpJc2NFM0puY1dBbkJS?=
 =?utf-8?B?bTdvWG5lbGtKV1VEdEUzVmdCSDluRnZBbm90ZERGMDFRaVVoWFQ4MDdCNGFq?=
 =?utf-8?B?QWpjWlVKY2F1dkRZUWZHOTRwMjUrdCtpWmFXWWFDT3M3MWlLcTUyOVhLMTJI?=
 =?utf-8?B?NFAzK3NSNU93a3luUndOS2N2anNUNnE3elhwQ1IxbFFLWC9PVC9laXZFcW5p?=
 =?utf-8?B?UVpldy9ydGhSUUUrS21ya1M4cDRHb2UwN21WeFA5NnRoTTNWSG90K2VUNk83?=
 =?utf-8?B?VkdHakI4WVlXUG9uWTUzbmxXUXBFOW12T1AyNEhscWtkVlRxeVN4QXZtYzhM?=
 =?utf-8?B?ang0TDFMSldIYzZGZ2Z3TlRwaFJGdml4bVlVMGlhMklzWTZBSzdsNStSYnlj?=
 =?utf-8?B?V0VYajFqZTEraFZibHlNRy9ZWnl2eUZ5bS9uZFREcmRRTjFYcWs2bDJFdll5?=
 =?utf-8?B?SVNMQ3R2UXhTWHFaTzdDWHJlRkIxK3gyYU1MazhQL3VDZVlDTk9VOUJjZVZ4?=
 =?utf-8?B?RUZkdnp1WitZZjhMaTJpQXBsNUVkTzArclRlaGIySUc0R09QZENOTlczR3Nq?=
 =?utf-8?B?UFlOM1VYUjE3UDB1MmExMDVEQVl0U3A3ZCtnREtQaExuTWFOdk1LL2U2emRS?=
 =?utf-8?B?Z0FoU0R1eVlVMTlSQUlqRUc1a1lUbW5VRTZHMEVMcHFmeFFSOC9ZNmltVXlH?=
 =?utf-8?B?ckVPNzZHQnZTeWo2ZTE1Tmt4cXpXbGxYVkRoNTZCeUg1a3lZSW93MSthK3ZB?=
 =?utf-8?B?WDFqb1dqSFNOMVg1UjNVMXRycjhTOTR5ZDlPUXZZbHJPemFWL1U2WngrZGk3?=
 =?utf-8?B?SFJuTnJpajM4Z2dBWWNnSVFXMGZMYnExekZESkx2ckU4MEpHNzZ0TS8zZlVT?=
 =?utf-8?B?dnl6Qmc3cXJtYzBMZG5WektHYXo2YlFFa1ZQdnp0Vm1CNTk2Y0R0Y0dzeFBX?=
 =?utf-8?B?YWR6bno1ODlkdmthTkVPMXFMTDRSZ2Zjb2FSL0pIVHBWM1pvTE1Ba2NRQ0Jr?=
 =?utf-8?B?VFI0KzdTU0ZRSEFtODBFN0xubDRycUtYNWkzRFRYdW41NVFUQnVwRDF5ajdk?=
 =?utf-8?B?cUMrK0NxYUczdFdXclJkdHdPUVJBSjZvMTlQSER4V1NUaWlwY2FNeHEwUU1q?=
 =?utf-8?B?eWRJSUxwbU1oelh6QmxNYmJXMSt5OG5xaVIwczE2SThEQ2lIZzhEMXZRUGww?=
 =?utf-8?B?N25MbEhOdm8wMy9zNW0yU1VQSStJK3VFWmc0eUVZUnJuNUxuMjNRdUs4enNC?=
 =?utf-8?B?QkNveU45RzhhY0V4Y2hBdUpDbXlDWXhaOVhQbmx6REVDdEw4dkZYZHhxYU4y?=
 =?utf-8?B?c1dpbWM0VE5GYTBqeUhWaGxSMlU4N3hGVnVLVVkrcktlZkhJNzRkVHprZkNl?=
 =?utf-8?B?c3hiZ0N1eDJwMnNSeXp3eVY3aURzMzRzWUNRSUVFakkyMm50Mk0yWlFkM1U5?=
 =?utf-8?B?STBVdmlJc3Fna01rMFN5ZERaMzBORmprenpwbElUZFlZWWRpZnNhWE94eWZi?=
 =?utf-8?B?eE9ZaThKd2F5eUx2S01xb0FJUmJnc0V3M2RZMmltVThKc04ydElZM2h5T0wy?=
 =?utf-8?B?R0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7996F81DB86388408F184E0FC1808918@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4261f7a0-3f2c-4107-a7ad-08dca379f831
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2024 20:25:42.9612
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dL9aQeRSBZ7s/H27zoDf9uFTiXH/UcC5TwiP4uv0L2tbOdXyZDoDS0ONAR8nfAOVc6Guf6zNsFFMt3xcPS13iEXr5C1eANnnhe36d8JRy2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8465
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTA3LTEzIGF0IDEyOjEwICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiA+IA0KPiA+IFRoaXMgcGF0Y2ggYnJlYWtzIG91ciByZWJhc2VkIFREWCBkZXZlbG9wbWVudCB0
cmVlLiBGaXJzdA0KPiA+IGt2bV9nbWVtX3ByZXBhcmVfZm9saW8oKSBpcyBjYWxsZWQgZHVyaW5n
IHRoZSBLVk1fUFJFX0ZBVUxUX01FTU9SWQ0KPiA+IG9wZXJhdGlvbiwNCj4gPiB0aGVuIG5leHQg
a3ZtX2dtZW1fcG9wdWxhdGUoKSBpcyBjYWxsZWQgZHVyaW5nIHRoZSBLVk1fVERYX0lOSVRfTUVN
X1JFR0lPTg0KPiA+IGlvY3RsDQo+ID4gdG8gYWN0dWFsbHkgcG9wdWxhdGUgdGhlIG1lbW9yeSwg
d2hpY2ggaGl0cyB0aGUgbmV3IC1FRVhJU1QgZXJyb3IgcGF0aC4NCj4gDQo+IEl0J3Mgbm90IGEg
cHJvYmxlbSB0byBvbmx5IGtlZXAgcGF0Y2hlcyAxLTggZm9yIDYuMTEsIGFuZCBtb3ZlIHRoZQ0K
PiByZXN0IHRvIDYuMTIgKGV4Y2VwdCBmb3IgdGhlIGJpdCB0aGF0IHJldHVybnMgLUVFWElTVCBp
biBzZXYuYykuDQo+IA0KPiBDb3VsZCB5b3UgcHVzaCBhIGJyYW5jaCBmb3IgbWUgdG8gdGFrZSBh
IGxvb2s/DQoNClN1cmUsIGhlcmUgaXQgaXMuDQoNCktWTToNCmh0dHBzOi8vZ2l0aHViLmNvbS9y
cGVkZ2Vjby9saW51eC90cmVlL3RkeF9rdm1fZGV2LTIwMjQtMDctMTItbWFya191cHRvZGF0ZV9p
c3N1ZQ0KTWF0Y2hpbmcgUUVNVToNCmh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC1zdGFnaW5nL3Fl
bXUtdGR4L3JlbGVhc2VzL3RhZy90ZHgtcWVtdS13aXAtMjAyNC4wNi4xOS12OS4wLjANCg0KSXQg
aXMgbm90IGZ1bGx5IGJhc2VkIG9uIGt2bS1jb2NvLXF1ZXVlIGJlY2F1c2UgaXQgaGFzIHRoZSBs
YXRlc3QgdjIgb2YgdGhlDQp6YXBwaW5nIHF1aXJrIHN3YXBwZWQgaW4uDQoNCj4gIEkndmUgbmV2
ZXIgbGlrZWQgdGhhdA0KPiB5b3UgaGF2ZSB0byBkbyB0aGUgZXhwbGljaXQgcHJlZmF1bHQgYmVm
b3JlIHRoZSBWTSBzZXR1cCBpcyBmaW5pc2hlZDsNCj4gaXQncyBhIFREWC1zcGVjaWZpYyBkZXRh
aWwgdGhhdCBpcyB0cmFuc3BpcmluZyBpbnRvIHRoZSBBUEkuDQoNCldlbGwsIGl0J3Mgbm90IHRv
byBsYXRlIHRvIGNoYW5nZSBkaXJlY3Rpb24gYWdhaW4uIEkgcmVtZW1iZXIgeW91IGFuZCBTZWFu
IHdlcmUNCm5vdCBmdWxseSBvZiBvbmUgbWluZCBvbiB0aGUgdHJhZGVvZmZzLg0KDQpJIGd1ZXNz
IHRoaXMgc2VyaWVzIGlzIHRyeWluZyB0byBoZWxwIHVzZXJzcGFjZSBub3QgbWVzcyB1cCB0aGUg
b3JkZXIgb2YgdGhpbmdzDQpmb3IgU0VWLCB3aGVyZSBhcyBURFgncyBkZXNpZ24gd2FzIHRvIGxl
dCB1c2Vyc3BhY2UgaG9sZCB0aGUgcGllY2VzIGZyb20gdGhlDQpiZWdpbm5pbmcuIEFzIGluLCBu
ZWVkaW5nIHRvIG1hdGNoIHVwIHRoZSBLVk1fUFJFX0ZBVUxUX01FTU9SWSBhbmQNCktWTV9URFhf
SU5JVF9NRU1fUkVHSU9OIGNhbGxzLCBteXN0ZXJpb3VzbHkgcmV0dXJuIGVycm9ycyBpbiBsYXRl
ciBJT0NUTHMgaWYNCnNvbWV0aGluZyB3YXMgbWlzc2VkLCBldGMuDQoNClN0aWxsLCBJIG1pZ2h0
IGxlYW4gdG93YXJkcyBzdGF5aW5nIHRoZSBjb3Vyc2UganVzdCBiZWNhdXNlIHdlIGhhdmUgZ29u
ZSBkb3duDQp0aGlzIHBhdGggZm9yIGEgd2hpbGUgYW5kIHdlIGRvbid0IGN1cnJlbnRseSBoYXZl
IGFueSBmdW5kYW1lbnRhbCBpc3N1ZXMuDQpQcm9iYWJseSB3ZSAqcmVhbGx5KiBuZWVkIHRvIGdl
dCB0aGUgbmV4dCBURFggTU1VIHN0dWZmIHBvc3RlZCBzbyB3ZSBjYW4gc3RhcnQNCnRvIGFkZCBh
IGJpdCBtb3JlIGNlcnRhaW50eSB0byB0aGF0IHN0YXRlbWVudC4NCg0KPiANCj4gPiBHaXZlbiB3
ZSBhcmUgbm90IGFjdHVhbGx5IHBvcHVsYXRpbmcgZHVyaW5nIEtWTV9QUkVfRkFVTFRfTUVNT1JZ
IGFuZCB0cnkgdG8NCj4gPiBhdm9pZCBib290aW5nIGEgVEQgdW50aWwgd2UndmUgZG9uZSBzbywg
bWF5YmUgc2V0dGluZyBmb2xpb19tYXJrX3VwdG9kYXRlKCkNCj4gPiBpbg0KPiA+IGt2bV9nbWVt
X3ByZXBhcmVfZm9saW8oKSBpcyBub3QgYXBwcm9wcmlhdGUgaW4gdGhhdCBjYXNlPyBCdXQgaXQg
bWF5IG5vdCBiZQ0KPiA+IGVhc3kNCj4gPiB0byBzZXBhcmF0ZS4NCj4gDQo+IEl0IHdvdWxkIGJl
IGVhc3kgKGp1c3QgcmV0dXJuIGEgYm9vbGVhbiB2YWx1ZSBmcm9tDQo+IGt2bV9hcmNoX2dtZW1f
cHJlcGFyZSgpIHRvIHNraXAgZm9saW9fbWFya191cHRvZGF0ZSgpIGJlZm9yZSB0aGUgVk0gaXMN
Cj4gcmVhZHksIGFuZCBpbXBsZW1lbnQgaXQgZm9yIFREWCkgYnV0IGl0J3MgdWdseS4gWW91J3Jl
IGFsc28gY2xlYXJpbmcNCj4gdGhlIG1lbW9yeSB1bm5lY2Vzc2FyaWx5IGJlZm9yZSBvdmVyd3Jp
dGluZyBpdC4NCg0KSG1tLCByaWdodC4gU2luY2Uga3ZtX2dtZW1fcG9wdWxhdGUoKSBkb2VzIGZv
bGlvX21hcmtfdXB0b2RhdGUoKSBhZ2FpbiBkZXNwaXRlDQp0ZXN0aW5nIGZvciBpdCBlYXJsaWVy
LCB3ZSBjYW4gc2tpcCBmb2xpb19tYXJrX3VwdG9kYXRlKCkgaW4NCmt2bV9nbWVtX3ByZXBhcmVf
Zm9saW8oKSBmb3IgVERYIGR1cmluZyB0aGUgcHJlLWZpbmFsaXphdGlvbiBzdGFnZSBhbmQgaXQg
d2lsbA0KZ2V0IG1hcmtlZCB0aGVyZS4NCg0KSSBwdXQgYSBsaXR0bGUgUE9DIG9mIHRoaXMgc3Vn
Z2VzdGlvbiBhdCB0aGUgZW5kIG9mIHRoZSBicmFuY2guIEp1c3QgcmV2ZXJ0IGl0DQp0byByZXBy
b2R1Y2UgdGhlIGlzc3VlLg0KDQpJIHRoaW5rIGluIHRoZSBjb250ZXh0IG9mIHRoZSB3b3JrIHRv
IGxhdW5jaCBhIFRELCBleHRyYSBjbGVhcmluZyBvZiBwYWdlcyBpcw0Kbm90IHRvbyBiYWQuIEkn
bSBtb3JlIGJvdGhlcmVkIGJ5IGhvdyBpdCBoaWdobGlnaHRzIHRoZSBnZW5lcmFsIHBpdGZhbGxz
IG9mDQpURFgncyBzcGVjaWFsIGNsZXZlciBiZWhhdmlvciBmb3IgS1ZNX1BSRV9GQVVMVF9NRU1P
UlkgYmVmb3JlIFREIGluaXRpYWxpemF0aW9uLg0KDQpJZi93aGVuIHdlIHdhbnQgdG8gc2tpcCBp
dCwgSSB3b25kZXIgaWYgd2UgY291bGQgbW92ZSB0aGUgY2xlYXJpbmcgaW50byB0aGUNCmdtZW1f
cHJlcGFyZSBjYWxsYmFja3MuDQo=

