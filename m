Return-Path: <kvm+bounces-70089-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wGgLK0NmgmlOTgMAu9opvQ
	(envelope-from <kvm+bounces-70089-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:18:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 51732DEC80
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 22:18:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B3A933031C8B
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 21:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A01BE352C34;
	Tue,  3 Feb 2026 21:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GT2YYiNc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C4D2DF6F6;
	Tue,  3 Feb 2026 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770153536; cv=fail; b=d6tCsAi+RxrtWMxFFzO3b+OIo7QsnbSvGTBocZ6h0FMxmSdL8FZrltxXItGq5AkrVVq9U09ZyIGuTQJv1GlU6qwnTv5I0HfmecfC4lUzq2CpudBrNgUhqnypgjOhksVDO1B2y9K13LuEeYrGYYbdCUaYLiE9dgJgB1TQFxLnyzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770153536; c=relaxed/simple;
	bh=1ftYlqs42PLP4d2s0yESXZBqQkASXAnDU5TccnGhZ6c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RvpLexQ0/kzuf2L55I1ULFWNAJD4MwadKda2TRci7e9rnm0c6ghy1ZpibXlKw9FWRnwg22Z488Ses/gfH7mgepHUOvAmH7C9OWKwz1lHvFqi0IDYI+3nLMa7PyMGGAhGz4Bm2j1RX0rVn43JaYuTSiJMYKBHxEa6fTU7OheTCW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GT2YYiNc; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770153535; x=1801689535;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1ftYlqs42PLP4d2s0yESXZBqQkASXAnDU5TccnGhZ6c=;
  b=GT2YYiNcHyYlnd24JJ3xEY4jpRFpyGaUdH+LdKRBqBTJDwRA3Paj3Z5L
   MyqIJN01Dj8fHFW+zY213TTeKvbErSxxmuYBn82WP1clF4B2EYUvLCOKy
   i6MD7U4uQcPnrJChZd93EbHKibM9P1v+mltX5edJL3F7APk6oSPErK8Mi
   WEibNmvHXfJ189mfXCjCgBKb+RrUgpuFzjz1I0g/zRNdPVMXHy8MKFKSR
   b3yNaixmO6vXqVCnkudkevSaKicAbfRoGrlXV2y6/F8/I5WqF/uSqqqgh
   /wsquTZ49At3+j5b3PYhbQMIZ7WcYacDYjYcePAG4dvltwXFyAGvF2zrv
   w==;
X-CSE-ConnectionGUID: ZK6P8DoLRZWHtoT5kx/H9w==
X-CSE-MsgGUID: Cph/R8ohSlKA1+ayqONBkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="71495785"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="71495785"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:18:55 -0800
X-CSE-ConnectionGUID: 6FGf1z74T7Gbwo3veqbFbg==
X-CSE-MsgGUID: gsuK13yzR96jfd1KnYEHDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="214934059"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 13:18:53 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 13:18:52 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 13:18:52 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.30) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 13:18:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VMNol3Jo4Cn1WrAfie2Nbbw73j+VHc/1QUgGJyAJSVuLSUlIoxBjyVvgryvDyDrutsYEzBtB9zANdUA+TxrJTyqzD1DbIV/0sV/+QJfnXEI7bgbvkNReAeec5tOYtACvVoltkYpGd004W4yIloyV9igWV6ovahu62djSu3soE5zvH5q9Qv8vVyLXcQWqt0EJvgneB0k6jPivlIBpu6Z+Bqvftlrj+9b3NOlseXT17esorclimplBlyCklJmyPM8Tuerx4TNlaQ9fT2DM/YEfZP7g6h2j2yhHnFPvDSyVs5Z0iJH1WbV0zKQ6ZdlvKqS0nvBXboOqsLsOlrxr2FjvYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ftYlqs42PLP4d2s0yESXZBqQkASXAnDU5TccnGhZ6c=;
 b=dOJl/I4lIwA+K+qq5i4rGY3rYX4JJMzDQnUVtDWLGs6jICVdzclQOv+qHYUxHkAuD6huBvR9ReR8WlmjUuHPJNveBnMnRwS3A9BqVl4MXaVWaqWb4mM9DtIRb0leqz5RCMq16DjjqqmFsp154HdOEo6PY/Clkh6v3D+PQi1vIRHqXW+063zsQI2JzVn7sRKLXuoVEUTWyc+n/fj+C5Z8ZZ/JIjFnWHJJLkim0zbdR9JqBAkiwpoUgomPVgTGfl4KHE3mZsongxlPgJ92hkPQzZlrDBa+FjSGRg/EY6BD9Dz/xbeXSEU2oP4qpm5Ft+R6uV7kmuU9PsUgnVqDH9O8/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN7PR11MB2673.namprd11.prod.outlook.com (2603:10b6:406:b7::13)
 by PH0PR11MB9521.namprd11.prod.outlook.com (2603:10b6:510:3b1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Tue, 3 Feb
 2026 21:18:50 +0000
Received: from BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7]) by BN7PR11MB2673.namprd11.prod.outlook.com
 ([fe80::9543:510b:f117:24d7%4]) with mapi id 15.20.9587.010; Tue, 3 Feb 2026
 21:18:50 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Annapurve,
 Vishal" <vannapurve@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Topic: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages
 using tdx_{alloc,free}_control_page()
Thread-Index: AQHckLzhSspC1sJAD0G07NT4Ge5PXLVw23cAgACXUgCAABEbgA==
Date: Tue, 3 Feb 2026 21:18:50 +0000
Message-ID: <9f2c5b3a3b72436c0b3c44fadaa2c9a8548de191.camel@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
	 <20260129011517.3545883-21-seanjc@google.com>
	 <4fae16cdcc368d33f128c3a79c788b905b83ffe7.camel@intel.com>
	 <aYJX3usu7FzPrFWa@google.com>
In-Reply-To: <aYJX3usu7FzPrFWa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR11MB2673:EE_|PH0PR11MB9521:EE_
x-ms-office365-filtering-correlation-id: 2658ee58-a6ae-4795-b3c5-08de6369d358
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?ZVZyM2hKWVd1ZmdYb3djU0Z2KzlVMFFackYzUkZueXVmQlJVclI4Y2xZUXZS?=
 =?utf-8?B?Q0JYTlVwWmVLTytjNTU1UWlIZUxQdW9tS0x5R0Y0a2dCa3lRWXhyMGJidW9j?=
 =?utf-8?B?dmJpWk0xZ2FLYUI3SXNTWXhncGVlemhBS2VxT0h4bU00LzFYaDFocHQzbCtM?=
 =?utf-8?B?WldMUU0vek43cE5KcnVhYi93S3RpblBVelhiSEViUGxQalFPcTFrU2RUZ3E5?=
 =?utf-8?B?Zk9UU0RSN1BYS25vYVR4TXVzaXpmb0laMkNOcUYwRTBRUFNKQThGZEFQTjlz?=
 =?utf-8?B?cUgwY2ZzdzR5K2lOSTBjc0N3K3pwdmlNN1dyL0RrVmphbHd1QTZSdVU2R0x1?=
 =?utf-8?B?OVNQM1lLQUU1c1kxZklhcmtYRzdXeUdobFVwWUcxdmRTQWpMZEQ1WmFUUlAz?=
 =?utf-8?B?K1BUVldsZWo3bWx6QlFGbHkzSUZUNWVRc0lIWnJFelRkcGxXNW5QcER3Vmsz?=
 =?utf-8?B?cGFlMUhieW1mRmFQNFF3NlpraE4yd2J5NGFBMEwzYnJNakNNYnRoLzdjei90?=
 =?utf-8?B?RmVZVFJ5K3JvNmk2NUZRVzgzRVlXRTdSWDJGMTA1bFVaMjNrdEZqM2hGTzkw?=
 =?utf-8?B?azVYbFJOWjhPLzBLMUxrSGgxVU52MkZpVTNjbUI3WEsxTGJ0QzY3Mi9Dc25z?=
 =?utf-8?B?MFVsekR5S3RISGpWeFNkRUNzZFF4TFdQQzRwSnE2eHZKNUtnWTJCeEsxdEtp?=
 =?utf-8?B?cDl1Y0JvNU9KNHBUY0YzeU1JUmdEVGI5bzg2RXBSbUNyb2d2ZHZudGdlMjk1?=
 =?utf-8?B?d1lyTVRFbkZMa2RCU1hmTklzakxibHZSM2I1OUowTE8wek9ZKytNQ0JYQkhK?=
 =?utf-8?B?bDRjZUlMakFzYjA2RzRsb1NxYWM0UkR1T1NSZ2dUMzZvWFY2bUtxSS9pcHQy?=
 =?utf-8?B?L0pKdUhYVHpSbUhaUVIyTVd3NU1ZdHRZRzZ6WnNtajlOQk9TeVorakJwQ3lm?=
 =?utf-8?B?S0paUzBrNldyUWxpdmJla1U3U1UySkNZMjdRckdNSHVoQSthU0V3RkZMVGxE?=
 =?utf-8?B?TnJjdWpwTi9JdjF2WXZ4ZVd4QUhwcHM2bTUzMm5jK0NVN1BqRTE2RTJsYnRo?=
 =?utf-8?B?QWpLcXErS2kzQ3I3SFlRN3RRTEpDaWxBWlFzdnpzdlQ0bjg0emF1VnRIcHNW?=
 =?utf-8?B?eitJTWE4NGlGQ1RrOXpLU2JJUk9wUCtOaUYxZ1FYR1FPaDFxeC9PMlBYWnlu?=
 =?utf-8?B?c0NwZmZzaVV5Q292cWJpd0V2OFNhSlZLT0crY0N4cnJkd3hxaW9GdXVpa1JZ?=
 =?utf-8?B?WmpsdjR4OUhDM3BncHJGeFovT1dDOXcwLzg0aTFvYW1SWkY2U3ZiajYxVHBh?=
 =?utf-8?B?ZkRPNDBBOHBEdVBtRXNFYnBSRi83ZFpmTkRGMnhlSVhQV29XdXVHMk5HUjlK?=
 =?utf-8?B?RGlWVm1ZSFlxN2J3dGFIKzNiNkZWZlo1K1ZLR1o5dFNZQTVUMlN5em00ME9u?=
 =?utf-8?B?SWZJTmxrcVRXdEZTUzdqNlRGMlRhYjNLSHZiMnNvSFArYjl1VjZCdDJCV2pS?=
 =?utf-8?B?aFY1V3BiaXFiaTRqbFYrN2RqOVhIazYvc09ZVjVvS1RqQ1lJbTFnR1RVQmQ3?=
 =?utf-8?B?Z3JsTm5wVXM1OVF6M2wxdGVqRnNodFlWOWVEWENUVjlPL1pJWU15VGpvZk5l?=
 =?utf-8?B?VGo5ZDBuc0RQMmNPVE9KVFp5YXBDeUEvNzlaNlJ0WCtCQk9ZSWFZdHpuQTlj?=
 =?utf-8?B?SVJQQUZuTGNaT2JOTHpucUdhZHpIT2gyRW1pV0xkcnJvekZ0SDNuVVVXUEJm?=
 =?utf-8?B?YTZUa0JWYWhyNWN6MlRGYmJPcUc5cGJjcjVpdnI4U0J6MzIzMk55c3NRNU1w?=
 =?utf-8?B?eW1TNmVoRStzQjY2WUx3Yk5ZaVFEWThoWUx5a04yb0dYazZSUjV6aDdvQTR4?=
 =?utf-8?B?b09COWJMMnhlUWdqRnMyaUV5aDk0cHZIZ0w1cnlUbkk1NGN6R1JTelVjMTU5?=
 =?utf-8?B?aldlWUFWSU9pMno2bTFnTFFta2xuWUZ2SnJNem5LU1FuRG4wc2diR1lPM3Fk?=
 =?utf-8?B?TjA3NC9IZElaekZjUkJFTjZDM1FJWVpXUUlYVkxVQTVJRk45M25kSStobXY0?=
 =?utf-8?B?MllnZ0JETXp2YW84QzV0TVJXa3NtbnVpcDI0aURnZ2pmSjAwcWFEeEM1SWNQ?=
 =?utf-8?B?dER3THRscXlQdWpxRGRqQWZjVGZuOFBPZGxuZlhvR2p4czUzOUZZR3crdUlj?=
 =?utf-8?Q?niKO4YA5LykNzpfxcp8VIwc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2673.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dkpLaXVwelM3Nkl1cUZCMllGYm41dStZQjNEbWdNOEoycUZ0Vkg4QWZRU0lE?=
 =?utf-8?B?NEdsbFR0NTRHY1RHV1YxanhHVjdkbW1GRExZS0hXMnpkOWJ2Z1RjM2RpaUdm?=
 =?utf-8?B?VXp0Sy9Bb2tnYXcyM1BYVkUydTBrM1doOTVMUmN0RDRQOVNYSk9VOHVsQzlz?=
 =?utf-8?B?TTV2SUQva1c5WmkyRXJvdHZHeDJ0SlRqUFVLMUNEVkZNdW5WR1cxUFZQN1VH?=
 =?utf-8?B?d1R0Yi9yQjUrNnM5VUw4cWREa2MvRE9RUDVoaFpwUENqTGtTN0xjTzFJK3Vt?=
 =?utf-8?B?dFN5T3JDMmp3TEUrOVc3OG04L09HQXRrVmhiNWFQL25uK2ZtY2J3RHJscGVK?=
 =?utf-8?B?TXdXQU5TR01Tbkp4SWl3cFBQV3gydDBoMkhORWJyVFB1WmVmZ2hYMUlTZ3hJ?=
 =?utf-8?B?eGpab2FhVHRBbFdhdkd2c3NzNUhHQURaeWpXRnNIQ00wRXJkeVdOdWU3Ti94?=
 =?utf-8?B?dzBKeGFJN0lpMWJXTDlpcTE2QzN1RXBUa3ZYZXIzVWM4QjBlRmplbzNsQmFx?=
 =?utf-8?B?V2M4U1U0TmdpRExJWDgrWE4vaUZkcGdoZXhTSkN1cmx4aWFPZzFEQXRuT2dU?=
 =?utf-8?B?bVdlSGVNa3hqNlN1NG8vdHBPK000cUxQY3lWS3RyNEtNc0s3REgxYUJrdXhT?=
 =?utf-8?B?WEV4alNrNVlqYVI0akw4YnNEZzRnMXpYN21uUzdOUUJIMUduN1Y1eEh2dlhZ?=
 =?utf-8?B?c01HWjZtR3JEbG9sVm16M0lCSnBFdHJqTEtQRDVic1VxTGlNbU1ReHZ3VFo2?=
 =?utf-8?B?UWU5aHNhSjRYdnZLaWQwNVd4bVA1Y084WjhMd1RxbjZuTEZhenZDazVya3RH?=
 =?utf-8?B?WUdycVM3K2lYcWV6bWtORXN4N0hWSGFnNjd1eFY5aFNzNSsybEVOQWdHWlh2?=
 =?utf-8?B?YjVjMlJjaUNGbXJpYzU2dCtRUWsxUzM0bitZZmlIWGtRbnpZQUhWKzFaK2l4?=
 =?utf-8?B?cUtSZ1J2SWhtQjNDazVqQ2gzSHM5U0VGWEJzZGFaaFQwYUxVQ2ZBVE85aEt2?=
 =?utf-8?B?MnMvTzBaRkNEZGFQb3R0VUYwbjczSFpFOHFpMEdXa1EySjh4MnVFMDd1Wkxp?=
 =?utf-8?B?TWJoeExEY1RFTWk2aGw3VE1jcWhTbGU0WjU2Qm01eHVqbmc5QzlWWjJtMWIy?=
 =?utf-8?B?R2NjR1Mwamt4cDdTTEdGb0pyWVJVbS9CelIybDk1N2UrT2VXTFgzeHhsR3Fz?=
 =?utf-8?B?SzlUb213K0J1NG43c2U2Tml0S2hjalFLcURoMkUwQWtmam9SdmRCQWZtK0NY?=
 =?utf-8?B?ZzVBWFJRZmdZV3VBMWFaZXVqRk1aWVl3T00rODdsb3FhY2JoMldiV3ZVVmd2?=
 =?utf-8?B?UkxSb3lSSUVCZ0ZaS0hqeUNnd1FRT2c3ckh2dlI4MVRIVmt1djFhY1Q5ckVj?=
 =?utf-8?B?WjZwSWNPc0ducGRXa1JyNFhUNm03WDIvTnBQcTlaUVBMemxnbU9PMGJ4TGdv?=
 =?utf-8?B?M0t1OWtBNXYxbXBEd3pqVnoxRzJYM21hVTVOeFRnQlkxWkRBbzhrZnFKdTVU?=
 =?utf-8?B?SEdHOHhweEhwUmpGZG8zZWUwUnpBTW1LeE9uamxqOVkwcEZ6UlVFYlBFZ2JS?=
 =?utf-8?B?VnVBaTZQVU01Z3hNYlJMWllFL0pPdHdPUTdHMExVa1N1ZURhL1VITXVpNy9h?=
 =?utf-8?B?a0I2SGYyQmJodGtvRUtuQWJabkRWYWsrSG94ZXd5MytJQ1p5NVdSZmhDMUlL?=
 =?utf-8?B?Sm5MYXlhaHFtRlNYck1ZNXBXOFd4SzROZC9KOVFiRmgxQXp5MytoU2dkT21Y?=
 =?utf-8?B?dDE3TzlYNUZkMUhDVnBJTVA0dzMyV0ZlLzBRNm9XQjIvam1VaHpLTW9lb3dJ?=
 =?utf-8?B?R0w5eGJGVUZSQ2Z5QUo4Z3krK0pVVlVrREpXZ2hscmRCV1pMelpTUTR4VlBo?=
 =?utf-8?B?YkI4RVh6OE5jK2R2ZFlxbTNLSmZLSW5tdXZyeXZTT0FETzYrK0hPWXVaSEZP?=
 =?utf-8?B?M3FTVThYclViZWNadExFc09sOERSLzFKbUpzYW1ZR2FtQkV5dncyWmNFKzYx?=
 =?utf-8?B?dlMxV0ZWc1VmUjNBVGt1US9oS1cvTkZQL3k0QXYxRTVZa1dTSFFwSVYvR2lF?=
 =?utf-8?B?c0F2TzBRU21QMlNpMG5xTk5sVW9ibjJZQTNIR0VhdVNOcDdwTVEvU2R5WlJX?=
 =?utf-8?B?TDdQZ0ZYaXZaMU1TQUlrVHlwRUtnU3FRSU4wRlQzYmtJY3VPekJIbHNpZFlH?=
 =?utf-8?B?VkpaNnkveFlEWTIrdVN4aDlBV0V4VkduY1BHNGd3M1lYdURadys0eVZTY3dU?=
 =?utf-8?B?aCtYSWpxdlowOTZndjZVV3d0ZHFrU3ZocTlmcHVtUEVlWjYwWjNYUnRzR1Mz?=
 =?utf-8?B?WXE5VC9aUGpTWTFNV3V4Nm5qWm9Qajh4VFV5c3dQUzVHajZ5QlQ2Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D7FF5834D97224CBB2F263FB872C027@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2673.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2658ee58-a6ae-4795-b3c5-08de6369d358
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2026 21:18:50.0763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wGwCYqC39/0pEt5CBRa/9mnBCQDijW2H06lgbsgXxf7BUf/pRejXMeT14DuSpLJLLPhu7V2/ttVfcUuITJZHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB9521
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70089-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 51732DEC80
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTAzIGF0IDEyOjE3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIEZlYiAwMywgMjAyNiwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNi0wMS0yOCBhdCAxNzoxNCAtMDgwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IMKgwqAJaW50ICgqc2V0X2V4dGVybmFsX3NwdGUpKHN0cnVjdCBrdm0gKmt2bSwgZ2Zu
X3QgZ2ZuLCBlbnVtIHBnX2xldmVsIGxldmVsLA0KPiA+ID4gwqDCoAkJCQkgdTY0IG1pcnJvcl9z
cHRlKTsNCj4gPiA+IC0NCj4gPiA+IC0JLyogVXBkYXRlIGV4dGVybmFsIHBhZ2UgdGFibGVzIGZv
ciBwYWdlIHRhYmxlIGFib3V0IHRvIGJlIGZyZWVkLiAqLw0KPiA+ID4gwqDCoAl2b2lkICgqcmVj
bGFpbV9leHRlcm5hbF9zcCkoc3RydWN0IGt2bSAqa3ZtLCBnZm5fdCBnZm4sDQo+ID4gPiDCoMKg
CQkJCcKgwqDCoCBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCk7DQo+ID4gPiAtDQo+ID4gPiAtCS8q
IFVwZGF0ZSBleHRlcm5hbCBwYWdlIHRhYmxlIGZyb20gc3B0ZSBnZXR0aW5nIHJlbW92ZWQsIGFu
ZCBmbHVzaCBUTEIuICovDQo+ID4gDQo+ID4gVGhlIGFib3ZlIHR3byBjb21tZW50cyBhcmUgc3Rp
bGwgdXNlZnVsIHRvIG1lLg0KPiA+IA0KPiA+IE5vdCBzdXJlIHdoeSBkbyB5b3Ugd2FudCB0byBy
ZW1vdmUgdGhlbSwgZXNwZWNpYWxseSBpbiBfdGhpc18gcGF0Y2g/DQo+IA0KPiBNeSBpbnRlbnQg
d2FzIHRvIHJlcGxhY2UgdGhlIGluZGl2aWR1YWwgY29tbWVudHMgd2l0aCBhIG1vcmUgZ2VuZXJp
YyBjb21tZW50IGZvcg0KPiBhbGwgb2YgdGhlICJleHRlcm5hbCIgaG9va3MuwqAgRm9yIHRoaW5n
cyBsaWtlICJhbmQgZmx1c2ggVExCIiwgSU1PIHRob3NlIGNvbW1lbnRzDQo+IGJlbG9uZyBhdCB0
aGUgY2FsbCBzaXRlcywgbm90IGF0IHRoaXMgcG9pbnQuwqAgRS5nLiBfS1ZNXyBkb2Vzbid0IHJl
cXVpcmUgYSBUTEINCj4gZmx1c2ggaW4gYWxsIGNhc2VzLsKgIEFuZCBzbyBmb3IgdGhlIGRlZmlu
aXRpb24gb2YgdGhlIGhvb2tzLCBJIHdvdWxkIHByZWZlciBhIG1vcmUNCj4gZ2VuZXJpYyBjb21t
ZW50LCBzbyB0aGF0IGlmIHRoZXJlIGFyZSBkZXRhaWxzIHRoYXQgbWF0dGVyIHRvIHRoZSB1c2Fn
ZSwgdGhleSBhcmUNCj4gZG9jdW1lbnRlZCB0aGVyZS4NCg0KSSBzZWUuICBZb3UgYWN0dWFsbHkg
bWVudGlvbmVkICJwcm9wYWdhdGUgY2hhbmdlcyBpbiBtaXJyb3IgcGFnZSB0YWJsZXMgdG8NCnRo
ZSBleHRlcm5hbCBwYWdlcyIgaW4gdGhlIG5ldyBjb21tZW50LCBzbyBhbGwgbWFrZSBzZW5zZSB0
byBtZSBub3cuDQo=

