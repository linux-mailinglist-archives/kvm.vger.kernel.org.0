Return-Path: <kvm+bounces-50828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D99B0AE9C77
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 13:22:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57CBC1C2359C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 11:22:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10EA3275841;
	Thu, 26 Jun 2025 11:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I/7EqL6p"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6383238C25;
	Thu, 26 Jun 2025 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750936944; cv=fail; b=KxthnZCPZpjztjmZD45XJ5OT0h80wxWHoBJ8Fm5VF5LBEW1pGs5Rxbs5ipBzzlHVceYmAw+6Xjj23MCjvM+iU99HDl3TZt+FqO5KTgLLf/RH++McqPG0Fo24CBAWL4MrqvhCBHRpQJv1lMmihhHwcqQb+dFGr64azYahLAkLTjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750936944; c=relaxed/simple;
	bh=B4zdrUsYHfhpnef2NNG13lbJ1g3TpmmuzHR2crAwVTU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OcdcLD4zlMn//C0jmSNjruxMnOJpO4F7CUH+oCcKhJOCjtvJPaJSO8ZQ3icPZyabNG2plImvpMefTFhZGHO8ksupGtoPyv561PavVqNuDbkFmbU+h19GdifPp7Kf7yAaegL2li+rIJWwfKFGXb0PMHfMYqAn1QrtovC6g1wTF6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I/7EqL6p; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750936943; x=1782472943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=B4zdrUsYHfhpnef2NNG13lbJ1g3TpmmuzHR2crAwVTU=;
  b=I/7EqL6pZ39/EXp+MEwU4yRUzLho106m91pwRpyYz80IG+TaGHYJNcSX
   7ANL43kg42Op+uB5K5oFiTn13rsCiQH7djVd7QtcYBCJwIWEXPptwIXgB
   d1nNYkSCLy9ptJ3PxhVh/EJq2vAx6E2Pyc0KW4/OPuIWDMKH6UetThb0F
   0m1VHn+bmEpXSzfkRdH3HSVxoUXiAH36q9YUMzit+E1LOto16t/0BmwHz
   OIzdb8YFiavJ8bT4+zn2hhtfrToO/rWt7eLoqF7itvUPVeLZ43XLx0Wz5
   K0pBnI01AwavU/+N/kfaAwjyIKif9iFp+5FW1c9SEWuNsGo3Csqp+rPN4
   A==;
X-CSE-ConnectionGUID: A1fqAjjwT3iDqvwRGaYEjQ==
X-CSE-MsgGUID: J2/3YyQ+TvC/t0o4bAbrqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="53324253"
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="53324253"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 04:22:23 -0700
X-CSE-ConnectionGUID: a83/IO7ESti0VRikOnUEWA==
X-CSE-MsgGUID: mLI76nHoT7yc2bBX88zjqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,267,1744095600"; 
   d="scan'208";a="158250969"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 04:22:22 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 04:22:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 04:22:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 04:22:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j2ysE8gNa3qEBA4y/zIg1ubzaWDgR0dEvghJX0oM/l4czZvCIWHyibbwyQGwrWQTI0r8wFm7aUp/ECh4Mnd7JDGGLI/BlWc7zjFI/PI9av5EtPMWeHCN7xf8STvOpOF/fXLxayNeNVYZkj1BG8nj/Gd0VR1Ih0Q6cuWfDdE0bRjGVHRxai2BsO0kIpYefoU9TOAdnGwDTA3JF0qwzYMWbSeUdiNhUn+yzLxrSwqYv0jaIes4x8T/B2cqY0xthLKPy2aTrH5M19fg8vAjJmpXSoKEVdN3tuPQeA2Ml8o5U+dpAWX28AW+riGegv18cmuwXWTUE+Bu3+EUjsjozzzl+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B4zdrUsYHfhpnef2NNG13lbJ1g3TpmmuzHR2crAwVTU=;
 b=q7WmtPPKmQ3jhPJ6qQOaQfimAdxl5nEY74xzOM6p4ylXi3zuhSeVbyKPptSqa4omQQpotY3nkUrXoQ/eF3o4JyGn2bKdriq0oQmugmvWrGm+HTdIECdfRSW5e5Jd8R0va0/F5oDm3KGwt5PCQ6+TBPgZX1xeOSKQwkp7nRwxRDiB4t62/DX9C/LJ/Xn6A33KXSxoONSa9NYPC8gSwf5Zbdwrh1ZbEIZdv5M6M/JIpXo4G9f7fNir1mO3RUPKhykPNj8rebe0sVFAoCd/ANkjtY3heq0a/H8smRc+rPC4+fMOH9AQztWJAdZRWj7AXe+0kXNEQd/vMVgJz5WkI+FRpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ5PPF5CBB3CBCE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.16; Thu, 26 Jun
 2025 11:21:52 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Thu, 26 Jun 2025
 11:21:52 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 07/12] KVM: TDX: Preallocate PAMT pages to be used in
 page fault path
Thread-Topic: [PATCHv2 07/12] KVM: TDX: Preallocate PAMT pages to be used in
 page fault path
Thread-Index: AQHb2XK412UJAkXsMUuwkzL/hTypxbQVZh6A
Date: Thu, 26 Jun 2025 11:21:52 +0000
Message-ID: <a23aea4cc9b64f16bca1a70f299e766936db589d.camel@intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
	 <20250609191340.2051741-8-kirill.shutemov@linux.intel.com>
In-Reply-To: <20250609191340.2051741-8-kirill.shutemov@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ5PPF5CBB3CBCE:EE_
x-ms-office365-filtering-correlation-id: 3ee8399f-bfc5-4bd4-289b-08ddb4a3a674
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RlA5TS9iZTcwUk9mVUdqQyt0OFBMV21YQWV4TjgxaFQvZVF6dEZtb1JJdlIz?=
 =?utf-8?B?NnBXZ0FzL2F3bTlLV1ZSUnlvaTIyR1JQbG5JYkFOZjNJbUU2Ty84ci9NaVdX?=
 =?utf-8?B?blA2WDlsQlZzbEloRC8wSTRNY3BnOHlxcEJqaTF4bzc4RkEvN1Vhd3E1Sy9U?=
 =?utf-8?B?dk5YZFRiTmhmamlLc1RJWGMwVEtMMk90SE5IRlhVcWR1NVJjYmR2S2U4MkFV?=
 =?utf-8?B?emVnam50eWJoSzlWNzljVDhBR1BFSkRjS1lDWVBzVSs1L2MyTDUvczFrZUZB?=
 =?utf-8?B?MlJldU9KUlU5U0xUeTNyblJ6cm55czJZaTl4QytDVVF2V1U1QW9oZ0EzMTFP?=
 =?utf-8?B?OW1GNjFIRlpYTmFzMFV4OXpvci9zcFl0SzJsMHJoNUlPQ1M3S1ZITHNxSWtw?=
 =?utf-8?B?aXFpN0t1MTY1cG41dDFDS2VkQ1piYThPNFpOVzBXVWdYZ1lTc3h5bmZUZXdD?=
 =?utf-8?B?K09lVWVKVnJUSkdwQ21PUEFVanB0MEhHS015VG1kVkJlRVJuaWJNQVl3VDN6?=
 =?utf-8?B?VkNCQWVIdU1KaVNya1lsZjdwU0xGMHZhS2g1WHhJMUZMTWpNMTdWbTZMUEcr?=
 =?utf-8?B?blBLYmszS1BTQ1BCYis5eVpSNVU0THV4T2kxMGRFbnlMaWpuT2lKQktwSnRJ?=
 =?utf-8?B?bHlCWk93cU53cTNoY2szZ1JTWTFvSEtNdUhIOU95OGNTcTAyOTcyVjZKdklL?=
 =?utf-8?B?a3JlVzlDSHd1cDBOTDZSUUd3RGdxU2ZmeVp5S0dFcm9nNHBZZzlXK2RpQU9u?=
 =?utf-8?B?d1lhOTlQRUxPeDh0K28zVmRRa1h3cXJjT0loMnNyZnVSbkZlNUtRYVppYTlx?=
 =?utf-8?B?bXBaZWVhZWkrQ283ZGw3bkRtNzk3T1ZzNnZZWitOMVJKaVcvR1RBOUFTcytx?=
 =?utf-8?B?K2NMbG1Dckl0ME12UkpVc2p2eFUxcUt4WnV1bjBKd2tvQktvL3hJZGVtYzNX?=
 =?utf-8?B?SEg0WCtmSWoxbXBZZnVTNHNWcitlRHFqMWY3bGliMWdkdDVpeFlleXZYMlFJ?=
 =?utf-8?B?MVFUR1hIMDhmM0Q4QlI1anlCM0Y2TWtDVmMzbVVDQ29taytSY2xMTmhCVzNY?=
 =?utf-8?B?cTZ0Y1Q0VWU4dCtxMEpYbkpsVnp6V2Q1MHRhc01xVXlMWVJQVGtuOWlscDVV?=
 =?utf-8?B?MUNxNThmRmhnQjdtMzdjNTg4YmpBUUhJbitQZXFMaUxRbmtqOWt0ajI3VmJn?=
 =?utf-8?B?RTJpektoS0JRSERjK1dvdlh0N0pMQ202VDRmVWk3QTd6K3ZvWEU3R0tIejBv?=
 =?utf-8?B?Wk5ZN2JzdEFERzdHSlVLWVJlM0ltVHNMa3ZKSnNFVExJa1BQQjMxVm9ISkpn?=
 =?utf-8?B?VnRZdkJaT21WNlBTZGpDcHlyOXVFUURJOWpKQ2duZXRVRlVhbXhYYVpyTDNG?=
 =?utf-8?B?VWhQVjhEenBHVGQwS0l6akRSN1NVN2RvUEVVUHcyM0xPbmhZdXkzME1DUUdP?=
 =?utf-8?B?aHFiQWRuR28yaVpieFpuS3V2dGE4Qm5YTzdYMU1XbVdEM1RzTU9kUDloUHNL?=
 =?utf-8?B?Y1BoRWJnWUEzVlRUUE12b0o5NU9aM3JzTjYxaVlON0wwTHh3bkN5eUJjbGha?=
 =?utf-8?B?YkM3b3drWWJVWXR1YlltRFdQZ2JRKzVuWmNtOWp4RlFseVYzYXFQZW9HY3FU?=
 =?utf-8?B?YTEwMVNOR24rNUVMbmpyWjdDb1BaYWdSZ2QvQnA4a1I0SkcrZG9XbmhFSmhG?=
 =?utf-8?B?NGVXWTkwSFhhNlNBVlN0TkloeTB2L2QyQithM0I5cVhLU1o3MURXaWdTMmFJ?=
 =?utf-8?B?OG0yUmxyTHJqSjhqb1IwbEVWYk5JQXl0ejZLSG1uTk9PMG5SWkNpcVk2WWRa?=
 =?utf-8?B?MDJBbGEyZTBmWnN6cThQWXZBTWo2WWtNUS9FeWtJMEF2eDVaOVFrQUhnZm9l?=
 =?utf-8?B?RVBwejdGQ3NhczZ1d1BmaVBNRzdzZVdmTTc5eFVBYjVxRW9GaWIzbitGcit1?=
 =?utf-8?B?OUlwMnh4ekJLK3FudURCUUtmdmFZajF4NExXQXYyM3F6NFRLWGh0eHg3bHUr?=
 =?utf-8?B?T0lrVVYxSU5RPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Wkl2akNnWnNRVlVtY2ZXSGtQME5XK3hHYjVncWFKZGFKYndGZEx1L2MrcUNR?=
 =?utf-8?B?T1FlbEdZMjI5MWFyZXBLMWoyTkVXdmtRMHhtbEErMEp0bDhNYmJTaGRDdXNr?=
 =?utf-8?B?NnpvMjNaRm8ycWNCQ0xycWRvdVlTRjM1T3k2SDd3SWt4cDNsVnc1WU5CT2Er?=
 =?utf-8?B?OTgyUldpTnEyM2piUWs5bkY1cFJYRFVwaHJzQnJOaDJKbGNvNmpOUHRveGpT?=
 =?utf-8?B?V2lGcDRpUGE5YWxVdUNpSUl0LzNGdWdIVjlEU096SkdaR0pBVDM2R1R4WEg5?=
 =?utf-8?B?MGYyU3RTcWZJN0JwMFBuVUdVbjM2anlmMUNBbmh0dU4ycFAvMVFjVjl1M3lJ?=
 =?utf-8?B?OFNnUjdNMW9tM3dhTWZiakJJL3RQYzNqaUhJSXpRZVFCSU9oSXBnaVJGQys4?=
 =?utf-8?B?ekpoaUpPVjVXSStkUFdjdHQ0aDNiQjI2ZnFSS093ZmtXWVpRVHNtZy9ZVkZi?=
 =?utf-8?B?bDVZc1ovUFBLa2lDRld1TkM5ZlNuZk5sRk5DdGhSczNCSFlENzBOUmdsMGor?=
 =?utf-8?B?UDVtL2FIWnRNY2JaMERhckk2aVM3STJZcUdjaGJ5SXVSdndvWENHeFp3cFFD?=
 =?utf-8?B?ZVcrVmxRUU5WaFFRMjUrODYrM1FqVTZrTVNWSUM4dGhxeC90S0dodWptUzRh?=
 =?utf-8?B?Q0J4Nyt6V3NKcW5RZ1ptZzNrODF5bDQxYXhvdWMvVWNYZnpIdkovQ3ZYMCs3?=
 =?utf-8?B?L1QzMGd2QmFiNTJxN3F3cHk1Vm9HTlU0T3daWFJMblV3ZjNMRTE1dlVSczBt?=
 =?utf-8?B?MXBvbWx5TXQ3c09iSTJSL0JUT0hEU1BwRXVvbG16U2JuMTF1eTlDRy9FZDFZ?=
 =?utf-8?B?QTdzSEo5TmQzZTJxOGVLbDV4c1ltbFlOM2ZLOVNCdElaOEtXc08wTjVvd1RQ?=
 =?utf-8?B?K2ZUZnMydWM1TFNsYWZMRDBkdjFycHozejh5NDdTaGpQNUJZRmJSL2tkRzBO?=
 =?utf-8?B?aG4yQXJoTTNsc0Y4NjZ1QnNvRWtyN1pWN2ZCV0tOd2crWWtvaXROdVJWeGcv?=
 =?utf-8?B?bWF6OFlHR3oyVXBYQksxd0tDdDA3UkJjcGpWUlAxY0s0YUFhZVFnTFhic0FJ?=
 =?utf-8?B?eHM1SFA0L2g0NXZUWXRLNWNmTFppLzVxU0kyeUl5NktvMFdINWR1d3FQSnRz?=
 =?utf-8?B?b1hITFVJMmVWaEVnc2gxVmZEZE95UWZmRmRxT0JZMkQvcmNuakcrNDNaZThT?=
 =?utf-8?B?TWJ6bW1VTWtmOW5QTk1XS2Z4b2V4QWllLzFHak13Y1NHemRLa3c4NzlsNFV4?=
 =?utf-8?B?Y1M4ZEtkZk9YTXNlYzBaSHRaSVR3VGxQZVZwM215d0Z3NE15eFpDVmtGc0Uz?=
 =?utf-8?B?K3hVQy9XTXR0eUYrQmMyUGllbTdsTFVCOHdHY3M1VTdyYXpkeGFTNXlVa0hG?=
 =?utf-8?B?YzBMQ2lHWGI3dlhySjRFV0duQmJSV20rejlMbk03TkZXdnZGN1VJVmNiV2c2?=
 =?utf-8?B?bHBrMGZZanU5YkR1TTVlblRwZHFvVUsvdGJHbWFKWk9FY2d3bGNRSVFFMzhV?=
 =?utf-8?B?VGpDNWErbzNIOWliOW5xdGVTUDZQZ0JsbC9ZbnJLc25FQU5qSFdnem1TZG45?=
 =?utf-8?B?ME1zQTk5MUFnUURZT2svRlYvS1Q5NjhoRWZzUmVZeFRGNVl5RTd4YkFQYXZU?=
 =?utf-8?B?bWNlS2ZGQUR4MnlGWVB5TEw2cUwrTXZlVjdXK0FaaDlVL09iU0R3dFZkeDd0?=
 =?utf-8?B?aVBmZDhsUUNEWVRNNDdoQTNJYWpnTDFncjlNWjNtSWhYM2FVZmt6NkhoOFRy?=
 =?utf-8?B?SmhIMkVoRFV3Z3BXZjJkR0hVQXc0aUw4Ym9VQnF5WXZYNmViVXE2SkU0aldm?=
 =?utf-8?B?OHAxQUpCMW04Nmx1QTNJSTRrc0hzaHRwY1dadzl4YnQ4VlptZXlhUVdFOFRt?=
 =?utf-8?B?SnQyMkRXTEYrZEFsQVE5TWxTclpqbmVnU1BZMDh6NkhwQVgvTkp0MXA3SGV6?=
 =?utf-8?B?ZTR0Sm9qaGdNNHdrUnlDQnlZcG81LzZJb3JjNm56bUZYRkJyYmNPQUNqeEpW?=
 =?utf-8?B?cVRCWFZBRnVNdzA1RXNxNjdBYS9ERkZGRklmRlBCYWE5Tmt6akhwc0FuTnNY?=
 =?utf-8?B?WjlndXRTVXVFZ1FLcFJIOWNpeVRxNWthSEtlNS9QSENYc3FWdllNcHV0a0Z6?=
 =?utf-8?B?YTNSNHgvVkxrQ1ZvMmZVWlkreTRLMHEvWnBwMUJZZ1hXZkJ5cUM5NFh6SmdF?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <28C1AC6398B81C4B8C8BD312F84A137A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee8399f-bfc5-4bd4-289b-08ddb4a3a674
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 11:21:52.1343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hu4lgqSEz2D5zcPfanybD6gN/YQMskHkP6W+w6kH0o0hBpcHlE/t9G2XV+qYjgPQnBn8fkI3G9lMqWqesG6fwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5CBB3CBCE
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA2LTA5IGF0IDIyOjEzICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IFByZWFsbG9jYXRlIGEgcGFnZSB0byBiZSB1c2VkIGluIHRoZSBsaW5rX2V4dGVybmFs
X3NwdCgpIGFuZA0KPiBzZXRfZXh0ZXJuYWxfc3B0ZSgpIHBhdGhzLg0KDQoiYSBwYWdlIiAtPiAi
cmVxdWlyZWQgUEFNVCBwYWdlcyI/DQoNCj4gDQo+IEluIHRoZSB3b3JzdC1jYXNlIHNjZW5hcmlv
LCBoYW5kbGluZyBhIHBhZ2UgZmF1bHQgbWlnaHQgcmVxdWlyZSBhDQo+IHRkeF9ucl9wYW10X3Bh
Z2VzKCkgcGFnZXMgZm9yIGVhY2ggcGFnZSB0YWJsZSBsZXZlbC4NCg0KImEgdGR4X25yX3BhbXRf
cGFnZXMoKSBwYWdlcyIgLT4gInRkeF9ucl9wYW10X3BhZ2VzKCkgcGFnZXMiLg0KDQo=

