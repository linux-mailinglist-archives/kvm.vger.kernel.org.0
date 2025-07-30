Return-Path: <kvm+bounces-53734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F24BB160F3
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 15:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBBD3188F18A
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 13:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EBE3298261;
	Wed, 30 Jul 2025 13:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lsCaqYG9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E03D515;
	Wed, 30 Jul 2025 13:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880655; cv=fail; b=qzOAaYIVz3LpCZmKIaxjn5i0WQu5RInRQ9IGaLBZDSJGKKJMOjfHz27c7QEDp4t6xRyFHEf8xpnfxWFlcD7hAQgdp4TpJM6NX5f/v4Ocnynj6slSEyHxMC476sn/w0nns7m7MVzyyODDrUcT83n9bhCpTZz0zxodgJT3iy+Wj08=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880655; c=relaxed/simple;
	bh=dFaWz02o3sM2ajiuTR8tffBTHXVFLETnxpLQXbUMQuQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=u2WyX91ZT0AWUmUfN9nDQuwXnk61Bs3NNu+LaCeF7dB/RRiG4YgiQnUCsoYXRrX1LS7JTeAh7zimw2ZE01GwO22kk5KVgm7qkXjMzc8G5LSaHzijX69YG74zHy/K/kHtvGsrcAl9f0LufNUwylmsk1ZiA3jAZFOVi2MdZgwagUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lsCaqYG9; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753880654; x=1785416654;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dFaWz02o3sM2ajiuTR8tffBTHXVFLETnxpLQXbUMQuQ=;
  b=lsCaqYG9Y1Qak4Jh8WKMjaTkuZv6mKKCKIzoTo6C8TphwjYIGhyAwyek
   vsL3b6DKs+w5xMdoC6IP/2G7KlwfpIS6Q0Z93UHaaJgkqgA6LKzUZ2ml6
   3spD/TIuzVU1un4EymcvUnPwqkLJGziKAhfVVPBlinrx5B4NyhTaAdoC0
   7S52utJJomU+vRn9sllgMFmj/1mIVEDrEu9Y78/gk0K0rsmRH5b/o0jEu
   BBQip0qGWBMl9rgaWU5LQ2PytWy6hym3LxxAQIJqgUOJwrEuFolAvi2lE
   bmDuGKQfP+ntnu7GlXj84xtTC2kiz98rbjuCXHh9tyhMp9wo0Bk6MMHXM
   A==;
X-CSE-ConnectionGUID: 7pyq1LCjT82CfkEeHnfJeg==
X-CSE-MsgGUID: jPh2+rl0RzSBcAAfJmQ3Pg==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="56046321"
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="56046321"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 06:00:29 -0700
X-CSE-ConnectionGUID: KlROA92fQb2mDvH3Kv+8+A==
X-CSE-MsgGUID: DzjNDNLjQqS4grPrN+/A5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,350,1744095600"; 
   d="scan'208";a="162570091"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 06:00:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 06:00:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 30 Jul 2025 06:00:28 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 30 Jul 2025 06:00:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYSqXKfSYZ/qvB9jDLHCcmR6ipdlnnsHvw0lHHm3mg287gCtfsuX3LCIEhOTNnmUeKqzNIjFAZQFHNVxTW0SHyQl0xJQL2z5n5d+pB0YpRJEVTbydzX9L4vV+Fgb7g7XCEz9M49zGo7qTtm6kTc8sj4j7hkbDJXl7dWSG3hn6OhC58nJ9cqqvUktJKp5Xy32QZPtQOkNA4z6EHHJojV1NfHJDckSAmcscp9Z2/Mkv9ZYz4+xAdcbbaUcfB6HPTeLPunw7yUAVhcKY7dnj4GEE9vwkJkyj+uSF8DYMtvReEMSZwGOE7ox2O2bK/Yy5e0roCUsSGeg4SdzVPcFMVodhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFaWz02o3sM2ajiuTR8tffBTHXVFLETnxpLQXbUMQuQ=;
 b=zTSBsSgqF70MIu0UG3bxXYF9Q0vwMAbQ6ww6NnM2b9phnRueGkBbWXNOZs7Zt32j7lOUgQqLWXg1gc95tuN/hipD5ltshu3y74bmbOY5XSENHWlh5BAalFphsq+shHl1vJH+N+IwpCeZYE7sJEZO/25uPHBrqu3jvbojSjWLy4kpw9ITIQw+rzV9Dn82bMhRqZsIN8cPJZisHaKzxqrlhsXMlE9eWJ9TB2WWkqiZ07+knev5cP3n+CRZ44rFge64C8wkDWmAa/uWutyAaQUma9nbG7fAczpuEfMvttv1kFjl/ZRHk1eQMG6d3JDxuJCj2Abf5XiVhMs1Uew+jcuGxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BY1PR11MB8127.namprd11.prod.outlook.com (2603:10b6:a03:531::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.26; Wed, 30 Jul
 2025 12:59:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8964.025; Wed, 30 Jul 2025
 12:59:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "Annapurve, Vishal" <vannapurve@google.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"maz@kernel.org" <maz@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Topic: [PATCH 2/5] KVM: TDX: Exit with MEMORY_FAULT on unexpected
 pending S-EPT Violation
Thread-Index: AQHcAL+7V9fiN+6xT0aRmIRaSyEMmrRJrnYAgAB9EwCAAHaCgA==
Date: Wed, 30 Jul 2025 12:59:24 +0000
Message-ID: <3ee65cf000465d46d0f682946c238b9310246816.camel@intel.com>
References: <20250729193341.621487-1-seanjc@google.com>
	 <20250729193341.621487-3-seanjc@google.com>
	 <1d9d6e35ebf4658bbe48e6273eefff3267759519.camel@intel.com>
	 <aImzwgbuZniu31/V@yzhao56-desk.sh.intel.com>
In-Reply-To: <aImzwgbuZniu31/V@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BY1PR11MB8127:EE_
x-ms-office365-filtering-correlation-id: 13d594e7-0a5a-440c-79b3-08ddcf68e8e5
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UHpVMUJnanByWDFEU2JESWV0UGpqelh3a2JqSS9vVG1KVU5wKzRCSzRWdkh6?=
 =?utf-8?B?Zk51TEIxMG9nSDZjQ1AzcWxuSGZ2SVFhY0FlS2t5Q2NRU3hHM0tyOUh5YlZl?=
 =?utf-8?B?SmxGNmtZMm90TjFGM01td3ZpZ2dRaHlQU2p5MW94U2YzZWpTL3JRdzkxbkV2?=
 =?utf-8?B?N2Z6M3JZNFNISHo2NDVjMElSWFJxdnV3Q1FpanErMWF0cGhKalV3QUx0NEJk?=
 =?utf-8?B?Z3NFUXY1djVRdTM3ZG9lQVIrR2hNdnhvS0dETkxxZWYwN1JBOUpSYk4yazF1?=
 =?utf-8?B?UkFsY2VqbUNDM2VHbjRoRkpKaUxZalJmdm9JYUZTc3lyK2RieFo0RWlaa2pj?=
 =?utf-8?B?UWhqbTU3WkE3WlJ1U1RpR3JkMGkyZFZTdTNXUE1VU2k5R3NYaEcwWFAyQTRI?=
 =?utf-8?B?a0l2RDVsZ3krWlE2VHZSL2hMamxZS2VHdzRvVXFRREpzN1M4NzI3S0Q4MFBY?=
 =?utf-8?B?MGpZQjVxby9DVG9kSlIzUjlhYjltcTlPdkE5ZmVzSjFPOHBVTE5sWS9IRHZz?=
 =?utf-8?B?TGtqSmh6V2NTSUN2bk9pMTZnMGt2d1krczJrV0RLQThIRUgxM09oWEwwbERH?=
 =?utf-8?B?aW5VWDV5Rm9XZStkQlg5RjVxSXlvWWNNcDh0YVhpVWVkbS9PZHMyMHJwemR6?=
 =?utf-8?B?dWF5eEZwL3Z0ZWQyUmxWTnBvZ0NsQ200RkVMbUZJOTJRRWNES2dlSkJWMW1Y?=
 =?utf-8?B?YzFLNzhDY3k5eGNybDcwMWdFb3BnanlDbXBHWmdWdGR3NjFRemZuSm5McC9E?=
 =?utf-8?B?N3I0dkZGckk0cVpEN3hqb3k1ckRORTJ4VW9mSFB5VUhnZytFSlVBeEdnNDkw?=
 =?utf-8?B?c1Q2TE5sMEU4RFFISlUzb20zaDFLTGl0VzZTV2pjREdMY3hvZzZSb1R5eFJo?=
 =?utf-8?B?c0M0NzUybHg0clU2bWlEMlJEWmQwWGl1YXQ2UjRxSHoxYTJmV0dnZ0ZscHRU?=
 =?utf-8?B?K3c2NHNxZFpKTFM3U3dmODVpZzlkbTZlc0xoblJaZlJ0eEc4TWZjUE40ZDBH?=
 =?utf-8?B?cFNiZ25HVkFMd1dEZUdGZkpyaVVmZTRlQzNyVGJjUTZhNk96SnRTV2EzZ3py?=
 =?utf-8?B?clFnaCtZY1RyaTl6ZU9wL1IybmVkK09LQ3VpMWxycy9HS1YwbnJ5enovQjd2?=
 =?utf-8?B?N2JDU0VGV081cWd3NDBFYlZwY0RLUDlMWCs3bUQwWnZLZ0txeFhJOExlK1BD?=
 =?utf-8?B?Wk1GeVFlTFBKYUVuOGYwQUhjd2FrbUtINlhnREFRMlJEQVk0ZHlqRE5CTkRj?=
 =?utf-8?B?d0ZIZnpUR1o3WXo4ZHdmZnVkb0gxZ2Nmck5sNEc0NTYvVCtrMnpaRmdnMnVX?=
 =?utf-8?B?YjVaVUVIa1pEb1B1R050STd1Q29HeHhBdHpCaHh5T1pDZXVXdUViWE5ZZzZ1?=
 =?utf-8?B?WVBDb0VtVFNZUTFBNnhJaGVaUjNEczJOYVdwMVNhaThMLzJTWUIzYTd4Q2I5?=
 =?utf-8?B?T1QyZlRsYk1hYmZIV0pJVlgyVm1URUlsdXk3WFpOd2NRR0YyaGx3Q2E1STg0?=
 =?utf-8?B?QmlBbkJ1ZTJDK3U5bmlkSVdaQlljU0c4RFc5M0RoUlExb0piNEhhcmtPTGpL?=
 =?utf-8?B?VGpuN3RXLzZZZDBpbmNyV1NFY1d1RXNsc3lLakhPMGVDQWpNVXJVclF0dmhh?=
 =?utf-8?B?YmN6bW0xQWg5bDBmWTBTcE16THc0VmUxRS9ZWXVQMWQrOXk0RFB1K1NaTm1z?=
 =?utf-8?B?bDRRTlptRkhwMmZhUzRWVS9UQTdPd1FaWGhIeG5QM2UvRkVmWXBVSWNnaUd3?=
 =?utf-8?B?UHBNMEZYQTZOU1FGdG1JRGN1N09MSmphNjIyazVBUDVkZWdDN0JXaEhyYmN2?=
 =?utf-8?B?em9tU2VjTEFGMkpaVmR5azFDVzFQUVNsRUNQMnROZTJYYzlwN2JHZlZseDB5?=
 =?utf-8?B?aFBDWGd4Zk95SFVidlhHdWpYajhzZFA3ZitrY0tTZHZORVZkcmVhdThscUw0?=
 =?utf-8?B?Z29STk5HY29DTlh5OHhnRXBQMG1ML1UvcEFwLzZ3SjVicmN1dHpNYWlUdmd0?=
 =?utf-8?Q?y2dSqIy2VLaWvK7aSsnGYfCqB9XzeA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VnZML1VJMzlOdHNsUjRrQmRWNS9JbXZKVVhGeGlBYk40Q1p3WndZckhnZlVY?=
 =?utf-8?B?QVlFMmlFZldoYnlKMTlCbFRtZUZjazdUUzJuQmNCbHBUcjlGZGFtckRDaXdL?=
 =?utf-8?B?WE82eDhCbnBDemkvVnZoZUJWUU5uUmhYbjVpVG1zMlJsMmpIMk9EYjU1d2R2?=
 =?utf-8?B?YlFnTTduMFphclJIa2VseS9sbWdILzlvUzhwMTU0NzFIOWNMaWdHQ3JMbWRj?=
 =?utf-8?B?TWhaTEJCa3NOTWN3TmtGQ2dOWGgxR01rSDVFNFpObzExK2F3RFRJZmJwMWdX?=
 =?utf-8?B?UXk0Y1ViMVgvSGdsdU0vQUxIbEZKVmVjdGlDQWZQcmhFTGpyR1o0UnVvYW54?=
 =?utf-8?B?U0M3OTZ3VHZMVVdnZEhyd01GK0dHZEJacmRLVHFZQlVXaUJRajhjVERLOVpx?=
 =?utf-8?B?azJ0aGRYL2VkVjgwQ2ZVZFhjQ3MxUTh5cld0ZVlPaFdEQ05sb1FTV2xBbFNr?=
 =?utf-8?B?MFBLQkwzdEp0QVpVQ0VIeWUxTGY2bDVUUlN4QkNDdzRsQXFsOVlpeG82TGp0?=
 =?utf-8?B?ekVMZ0FUblRnTm5ZRTZzRlA0VFNHd3VDVlQ4Z0NjM2NVcUtadXlmdENjNEx2?=
 =?utf-8?B?cEpsT3lCTEhWWERKNTZCQ2FxZnNYUUQwK1c2WHUrR1lyWnZYU0lFdlA4bnVH?=
 =?utf-8?B?QkZtWmhKZFRGY1hjc0xIT0dQeTRkVDlPbUkrOVBVNzIwc1VnL3M2WktTWmJC?=
 =?utf-8?B?Y3RCYWh5S0g0MzJWVk84NXNmQ1BoeFIwSU1lejM1dHRnSUpjcWI4ZVdFWUd6?=
 =?utf-8?B?TndmdTdia0lOZy9sREp2QVBmdXlBZE9SOGZhb3FHQ1FKaGdXK0pkWXhrenNa?=
 =?utf-8?B?dDZTZjZRaTduWHd5SmJrcGd5dWZtYUFzZ1J6TW9YTkJSNWw3NXB1eXEwTm5T?=
 =?utf-8?B?TjNoZnVlOXZYdzNiOHl5UDBRMUNnRGdoNHp5d3FnWEoySkNpQXY1aU5pbEVP?=
 =?utf-8?B?SjAzWGJ6QVlrai9PMzRScnNDODV0RzRBeDdHV1YzVElpQXRoTWdQRHkyRUln?=
 =?utf-8?B?MkltenhuUlAvV3dxTXBnTDZaZlY4clkzUjd6OG9sTnkzdjNaQk1GemJrOEl6?=
 =?utf-8?B?Ny81Zi9MSlFVTEE5cExwRXdGU2RRZ1ExbncxY3hDdU91cVBxNGNLMEJkRFJ6?=
 =?utf-8?B?OTJ5WWpuN3lJeFpIdVJyMFZQRWI3Y3BtNnB6dDE5b1hGRmtjQ0xxc0Z1R09r?=
 =?utf-8?B?YjlmemRLK2YwQzczZ1hRUXpnM01TdERjOC9jUXN2TjJ0U1VZbENWdTR1aFB1?=
 =?utf-8?B?MW5qRXpibytUa0UvQVYwNkI0RUFYbVd4YS9vcXd1Z2srVHN2NnNpQUFYeU43?=
 =?utf-8?B?NXFKWEx3amdSazlxTjBpR3pIaWlxUnRDcWJsWVhYWjNNaGsrOGZXc1Biclg3?=
 =?utf-8?B?NEZ0VTVpZXlzMm1sNDRTc29kcS9LcWZjVzB3cUxaR0FMeGlMc2dZK2duMUE2?=
 =?utf-8?B?U3hPZkdycHorRFpxcEpVTEhJdHB2eU1lMjZ0WXJ5cVNERU9tclFJbCsvdUFJ?=
 =?utf-8?B?YkJ2aWdxZVl2a1B4RDVPbk1CaUYzbjM3dUo5cnZvTEoxVWI2M1RBY0h5eFVM?=
 =?utf-8?B?Z1dlZEc2MWVoMXp1azNvcVIrei9IdDlLeTcxUUp3QXlGT3YyLzZHLzVvcEZQ?=
 =?utf-8?B?ZkxiZTRQRXNwLzRpWmM5ZUdEbzhZdDgveXBjTGdsRUszdi9sZ1dQc0UwRjJD?=
 =?utf-8?B?dnE0SllnYmdZZEpHVUFCb1VPSGRDR0E0NzROSTNrdk96M0ErdmFUSTR6UURT?=
 =?utf-8?B?eFBnYTc2WkJKY3ZCdTBRL0psVitxcFFiaWllK3VVK1dmSVBYU0dWTXFMTW5O?=
 =?utf-8?B?MlFGREFFZjhFOVdJTis0OUxHeXdFMlVGZWV2UjA2UkV5RkxSWXZ1VEpVSDEw?=
 =?utf-8?B?VUh4U0xYY0JvS0JQQ0EraUJxYWtYY1lrN1FTS2kxbDl4ZDZKcVFaeVdDSk53?=
 =?utf-8?B?OGxIUjZqZXFkYzh5ZUFmRmJuOTVQM1BORCthdG1PdUFMMG1tOEYxbDQ3cjRx?=
 =?utf-8?B?VVlvWWF3dWlGdWErV0ljOEIwb240MkVValVpN0hJMFlSMlhFN0J6dEhmdzU4?=
 =?utf-8?B?R1RIQk5TVkJFYVhXcFdEcEJ2U0xhUlpTck9nMmE5VTVvcTYwR2RYbFE2bHhp?=
 =?utf-8?B?STEzVkJxdE1lRk9ZZ0FMcjNuaVRXOTdMbDJXQzhpWG5wL1lVTElQOStOLzU5?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55A81DF3D5EEB449A53E54516C21A3AC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d594e7-0a5a-440c-79b3-08ddcf68e8e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2025 12:59:24.6944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 042S7a9J+w0mW8BMDn0E2abSlBxlSihCJnwZIS/GokFxtpVWtWDOK94vQXsLF+wQ8qw7eHCftYo503X+douVwO45lLq0zLYEcUv4nIRamho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8127
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTMwIGF0IDEzOjU1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBC
dXQgaG1tLCB0YW5nZW50aWFsbHkgcmVsYXRlZCwgYnV0IFlhbiBkbyB3ZSBoYXZlIGEgc2ltaWxh
ciBwcm9ibGVtIHdpdGgNCj4gPiBLVk1fUFJFX0ZBVUxUX01FTU9SWSBhZnRlciB3ZSBzdGFydGVk
IHNldHRpbmcgcHJlX2ZhdWx0X2FsbG93ZWQgZHVyaW5nIFREDQo+ID4gZmluYWxpemF0aW9uPw0K
PiBTZWFuJ3MgY29tbWl0IDYzODVkMDFlZWMxNiAoIktWTTogeDg2L21tdTogRG9uJ3Qgb3Zlcndy
aXRlIHNoYWRvdy1wcmVzZW50IE1NVQ0KPiBTUFRFcyB3aGVuIHByZWZhdWx0aW5nIikgc2hvdWxk
IGhhdmUgcHJldmVudGVkIHJlcGVhdGVkIGludm9jYXRpb24gb2YNCj4gc2V0X2V4dGVybmFsX3Nw
dGVfcHJlc2VudCgpIHdpdGggcHJlZmF1bHRlZCBlbnRyaWVzLg0KDQpPaywgZ3JlYXQuDQo=

