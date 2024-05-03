Return-Path: <kvm+bounces-16460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 991F28BA44E
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 02:08:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC0751C22151
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 00:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E72642F5B;
	Fri,  3 May 2024 00:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UZdBDPx8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B93F23BE;
	Fri,  3 May 2024 00:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714694880; cv=fail; b=AlBUEmpHKx9dJh09Gf+VYa06fYSd43bI2t+cjT7/A+mBYvLtMBSpkrNaxNT3VyWjZT52g7+m0Ckgkbb7kp6M3TwkV2iKmb4gCKMJAZx9uRgy8FWgDm+fpH5kfrrd1KNHtKX2Ppys/1AB+PUOS0fei9xhcig6LkOTFQMHWtAyUt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714694880; c=relaxed/simple;
	bh=t6K98wk+eov1e9aomOANo/i53x2CIhMuPXsjzC3TNz0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EbE8A6Ul0zQVAioGA7Ltq2zA0LMApae+faPhzoTn1+6YMdayCSIqxWWZvqXOzmywi1ucT5DZIM0ajmEvFMjaa9kimr6BDthXioDQ2M5NGJDX+EX/pO++MMUxTWk+pwv661SMbI7pCEzEYNDaKZQJvv87mOLo3TGlFzUiGBuOvFo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UZdBDPx8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714694878; x=1746230878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=t6K98wk+eov1e9aomOANo/i53x2CIhMuPXsjzC3TNz0=;
  b=UZdBDPx8FseH4ZAvpcUACfhjg17O896+r55Zwv8C/ky0dfS6w/lUiIWO
   F19KMWvXhwsmPhRPmE7Op16ipj8bBJKNTrBEfF8L29FlaE7bsyypmkNYi
   8DaV9G7UdIWPkll/yhognOyaQhvocrPHMutesc0bz11hgPlAbUTYIzx+u
   h7waa76p3OALylHZnKuA5jAIBSDKRkfVCYE3CIKwBkkfMibriM0lNtNYc
   3S1sH8wGWXVxtmtP6v/6ndPsTQ88KLBk6yKa37u1FVDDnCqcM8V6XND83
   kOP3oqAAvoWfqOH0pvJkmudvB0c+DdsM7zhC6iiRews6pFSyJ3fU1F3SN
   g==;
X-CSE-ConnectionGUID: sdZqtR3YSAyW2qTnIPBO5g==
X-CSE-MsgGUID: Gw7NZKmqTJujG3+uh2X/nQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11062"; a="14278320"
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="14278320"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2024 17:07:57 -0700
X-CSE-ConnectionGUID: ROr+F03MRZG+1b4cA+hrHA==
X-CSE-MsgGUID: mSlVeWRmTaW5hhHAP/O73Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,247,1708416000"; 
   d="scan'208";a="27345489"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 May 2024 17:07:58 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:07:57 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 2 May 2024 17:07:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 2 May 2024 17:07:56 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 2 May 2024 17:07:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WOVIWxYaEMM4TOnz+ybaz4KJaU4HX0W1/YB8wyZIXEKK9/tyxO/B0JtwmfRN8sYFrvRhvm1iQOXqgckmck1kRglE1Q4Q5pH+1WlZq0sp7iZTn6kyJLQb5j/GyPHg3q/bimC9mcvy6ccetsnhk2ywWD+d94IsjyTVywFW6ezDf/+cqEM8mOmRUVFQlINwrNCPjL9tHJ3OLaTpXk+yU8THl52jD9m8WA0vYbSHJSZnj7Q8ClMqmgcH+Mvre/HViBpMBeJ9VhthdgTtRrjSXDiAWn5Tl0CZoJH+NdEOpAQ+BKf1egCSt5vd/3G7Xnv1VCTCd5UQziOHPprTcvmUU2XrrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6K98wk+eov1e9aomOANo/i53x2CIhMuPXsjzC3TNz0=;
 b=F5tm4UGAjKzmAYADBjUUjzN7WGmpIuPlluEfpz+0JWTkIxwbMTkN8v5xVwQspF6jnOWnDPU7e1UAKVvfbBGn2/rkJoQce7O2owv1YUb7U/sXEl/Np18/Edq/vuzvvnG+dRNLLu0DeQukXIfBCJ+S4Rskj2p1awZbyXoj1/xOfUcBVTGmCjJ2CQCohmHd/OEgxf5ucnQ8236pFX99Nn2gPf4Td5UO64a0cC3MTqJnDbjYKVUDHKMihCebfTZoXibKxQHPyl1zTWp01KXmzxxBVB1eZaGl3p5oDkdNPuf5cIAm8+HDTJxTVvb5/NB5wtg0qNoR4jYc3+tc4S/Vekyg4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB5983.namprd11.prod.outlook.com (2603:10b6:510:1e2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Fri, 3 May
 2024 00:07:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7519.031; Fri, 3 May 2024
 00:07:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/5] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Thread-Topic: [PATCH 1/5] x86/virt/tdx: Rename _offset to _member for
 TD_SYSINFO_MAP() macro
Thread-Index: AQHanO1KB8Un9Yi3BkqBVsMtYPbJgrGEogCA
Date: Fri, 3 May 2024 00:07:48 +0000
Message-ID: <ba0e8645c0a6878efbb6224bfdd8ab2cdc813542.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <a55e86430c81274af86d2d1c23cdce2f53fef7d6.1709288433.git.kai.huang@intel.com>
In-Reply-To: <a55e86430c81274af86d2d1c23cdce2f53fef7d6.1709288433.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB5983:EE_
x-ms-office365-filtering-correlation-id: a6596205-1851-47d3-b67d-08dc6b0510df
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?ZDd5VUhCb2xFYU1oZUoycmhkWCt6SkxOMU4wZlA2ZjVQZ000eGpkUEs3ZUUx?=
 =?utf-8?B?TTV5WUFvSkNrQnpTMDZZR0pMQmJEbm5pMzNGZ05YUFdKRU5DbHM2cWlydURJ?=
 =?utf-8?B?Q1B6NVhieTRraE1nL3JCMks5NkJna1YyTXI1dHhaUmhGMCtHeVhVcUZydnB2?=
 =?utf-8?B?aHVzZTFldWd5d2hkOFZLQ2pGZW1ORjVPb3d1aTFEL1U4UHR0WGRQUWkvdWpD?=
 =?utf-8?B?eTVHMXZhVVIzd0NBZ3FkdDdJUGNubzBDcWs0VmpEUGp2Tk9YK2pWUDI3b2tL?=
 =?utf-8?B?V0RhQXpzOHZZeHVYMmpET09ySndjWkhnMEw2L1ZuWHdJWWV3Qm94bGhKcXUv?=
 =?utf-8?B?RVZkR1ZSVG1lbVhVaUVmdjlSVHM4RlhDVXU0bm9vdnY1UDAxL1JCTDJscGw3?=
 =?utf-8?B?cVovc1ZtaFhHRjFRcDNHc3F2a3hoczhKWVdldmtodytzbXlZRDlDbXROSm9H?=
 =?utf-8?B?WkxkVGpJeTk4NkFpYVdrY2gvbUNHUC8yUXFoWnNSVEg3UzFmakt4ZnArQWJh?=
 =?utf-8?B?MFA1WkJ5alk0SVRGQUVmMGoxRzZ0cEcyVmdkL2RXMDNiUHFBbzMzWmwwMGJj?=
 =?utf-8?B?bGtIY0h0dDFSZUUzSDVhaStOYW9CWGg1SGlTSGNZamlWVHViZVZrZVkyb1d6?=
 =?utf-8?B?ZzU2VUJBdXpRZkloQVl6bnBGeFVqS1pBMkppdmRsR3pWTW1icm1xVUJILzBq?=
 =?utf-8?B?Z2pmL0w1a3Nxd3preDZBOXRBTTFNWWovNm00ZDhoMWNGRUw4eVVLUFZkV2dj?=
 =?utf-8?B?NTFyenJhRW1DdGFOcVAzbitDUk9qdEJrdTE1K1VWdktxUXJYRE9PUURhZ0ZC?=
 =?utf-8?B?NHBUeXQ2eWJnTm8wM09rSVhqbThGZFBtOFFBU1dYcWhualgyb0QwNFI5Q1Jx?=
 =?utf-8?B?R3R0ckVkQ2g1UU1TQUFaOVAzT29oL0dNTEZtK1pvbi9XZFFYdCtXeHkrUldt?=
 =?utf-8?B?MUozVmVpRkg5bHY4YlN0R3kwMkdZUkNGL1RWQm56WDNuUTg0U0pkR0VaUURR?=
 =?utf-8?B?ankzRWx5K2RnVDBCdGFtQTFRcmtoU0N3cEhpOTZUUTFERGxzMENyV01tQ2VW?=
 =?utf-8?B?cXZaN3hRd1JhRDYzRzdMYnJMQkRMOU04aFZVNVVrWWZnK2NsNnB1eHJFUlgz?=
 =?utf-8?B?SmhzcVlCWVlobW9VM2hsa3p5Z1ZPNmpNdzV0UVlDdlVLcm50UTFZRUpYOUc1?=
 =?utf-8?B?WC9XRjB3L3ZYVVVPRVNWanRkMzZQVDVGZlYreSt0OFBXbW1CSHF1NWJWbkFo?=
 =?utf-8?B?WE1KZkJuSWsvNVpYVzJjQUxZMko2NlN5S0cyWU9zbWo5SnExeEJLKy9VTjYr?=
 =?utf-8?B?c0crZUFxbmVPYi90WFZHMVkyVTdteUJydzFJYUkxT1h2L2RnYnEvTW14L1Fp?=
 =?utf-8?B?UHNyREVJdlh5Wmh5Mmg3a1ZCdW9hclAvVjlUNGxiQnQ4VksraUtiRzVMZmQ3?=
 =?utf-8?B?Qm51NCs0eS9zbXE5M2hFS0ZhQ21TNGVicEZtR0p1VEFOZGt6bU1kbFFjL3k1?=
 =?utf-8?B?eWdzUGFnTlVjWnRGdGIrR0dTK3RpZUU1elVzNHE4dWNJRGU3NGZTYTFlaUtR?=
 =?utf-8?B?c1RYc09IV1Bydm9NTVhXbVcyQkRLUmdLWnY0ZUpVMkRUbUliZE9zL1pmSmhv?=
 =?utf-8?B?ZlI0Z1o1VGdUdFgyUXZ3dkhSeHFJcjR6RTFYeHNmTTZSY2ovNnFsOWFqb3F3?=
 =?utf-8?B?RG5ySlNYZmY0eGw4ckM3c1JXRkZvRW01QzJsdjBwS2MyT21uT0pBTUpISTVu?=
 =?utf-8?B?eGVpcXlaYzJ0MWRoQzQ0R3pVdWhSeWIvb2c1d0R3NnUvMGRFNG8rdS9nUnBZ?=
 =?utf-8?B?anRZVWcvM1lKZFhXaWFWUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXZlYU40OHJZNGxHbitNTWZQZzErdUlFSTJFcUdtZ1JvcFpHd0dzVHlTYnV6?=
 =?utf-8?B?cVdyM1N3V3N5NldoV0F1a1RwUTJRTFlabU9RcTlEMmx1NkliSkY2dmkvdzlZ?=
 =?utf-8?B?VXF5SzdMWVpvQ014ODd2cDMranJ6dHYxNnVXNytDYXN2K1lGUGdVNkNIMUVX?=
 =?utf-8?B?azdtVllhZ0UwT0I5MWIzZjkxMTVDWUpiMjdHaVZwVWw3blk1Rm5WUTk2cENZ?=
 =?utf-8?B?RHMwclRUaXNCa1g0Z3hubWxNd3JJNnJVeTMrek5qc2s3RjNxY0NuTW9yalU1?=
 =?utf-8?B?aXRsZFAzZ2hEV3FBRnJ4eFQyaXRhZEw2bUJFK0RxaEFiQmJ5Z3gyWWJvSFZ6?=
 =?utf-8?B?SjAxOFhGekFlNWhJR1pUdDMyNXpYcXJVWlNPVmR2Q3dDYkZhN0hkdDJ4aHo2?=
 =?utf-8?B?aXRFOERvZ2txUDVrOXA4Z3BYYmRDa0N6aXZSM2M4bHVvQ2RIVDV6MGFTZS9L?=
 =?utf-8?B?WUx1ZnRDdHptOGlzODdPbW1mNDQxa0Q2RDMzZFA0anRheWp4OE5qbGZGRWlx?=
 =?utf-8?B?dG9aSE5xdXM0UHVBWFVUUldzNis2T3E4NGlsL2gra0lzdWpqeUZaQ1JqWHpC?=
 =?utf-8?B?dXRlT3A2ZWxhTUNRbzNMQUNGMFFYYStpUFJaYkdBS2tSbHFobTBqVTlNLzhO?=
 =?utf-8?B?OWxxUmd2V2c3NFI4cElBSkZqL3FjbTkrZDNSWHhIV3l2b2QvUk9vV0IyWENn?=
 =?utf-8?B?NTNVQmN6NGVBb3FHTjhCSDFqS2xNdmEvQVkxRkNGUllNK0pHYlROeEN0VVha?=
 =?utf-8?B?U001WVJOQVkwUnpYOTR5enlsK21oSkpqdEVOeTh0ZnJibjNhOHc3Q2VKeElZ?=
 =?utf-8?B?aXZZSS9vOWMvTnNWYjUwSUVCYUR1YVJyNWVOMDVJL3ZQdktCMlU0NS9yY0dn?=
 =?utf-8?B?Z25JclJ6KzVHOWFJbnVKUWdiSzlqc21lQ0RVbTZYRDR2ZVBtVWJlc2hoSmlw?=
 =?utf-8?B?RmNJSDZGUUZZMW8rUUV4d0dHc1RBMndtN3FLQUM0R3lnNVd3OStvK0d1VzFV?=
 =?utf-8?B?R1RabEJ4NGhnNmxVZzA1ZWY0OU1IcFFHNWx3QVBNemdnTlVWRXdQM3IvOXR0?=
 =?utf-8?B?dHhnYi9XbHVSY0JSbVUvMkN6SER4QTBRV0UxQmVUd09mSjJwNmNvS0Z5aGto?=
 =?utf-8?B?Z2NnSE5zVm5neDlxaXhUbWZXNmc4V2Z1QWFxTmd1MGhmY2VzV3ZyZHhTVFpP?=
 =?utf-8?B?dG1Fa0p0dTI0L1VrY3EvbGdSeWFDSExJcTFPVGJ1R0hjTDA4QWxsUGhGZWda?=
 =?utf-8?B?VWdXM0lNL240VWZIL3BvZzZ1MzdhUzBtT29kanpLS2I0TGxKRnJlK3IyRUVX?=
 =?utf-8?B?T25pZGpjalc1Qmh4dTJKV0E1R2NtNTh2bW9vemZvN2F1bG5kVzBSZmVGT2V5?=
 =?utf-8?B?NFV3TUxWbk4xMzlXWXV6RVhRUFh4WjBGRzFlS3pGMEhYTmtnZHdveGxjNGJJ?=
 =?utf-8?B?ZHcwZmZIT2pEcW5SY29JUTdGb1ZOVlFmSGpyUmxEeXk2S2ZEWnFFZ0JJcjhQ?=
 =?utf-8?B?aGYveUZSSXFvK3Ard2FBeExUTFFkQllZd2Q4c1dpcHRvTXRQMWY0dzdZZVpi?=
 =?utf-8?B?eHY2K09tbS94WFJoUGZ1RFNMV2Z1eFZNeUNsODNsZThEblJsNTBIWE8vSVlE?=
 =?utf-8?B?NmFGaXhwc2UvdkhLMHNCQnA2VC9xNUhneTFLeTdKVXViSmVWVW0wcVJoUUdK?=
 =?utf-8?B?UUtUTUhkQXhBZm9MR0F4di9RUFBtN0ViVCtEMU8vWC8rRVdHVHpodFhLVGNn?=
 =?utf-8?B?WGlVVlBEMGRtZEcyQmhDbnZNWXgvSVZkTjRlRTRDZGE1MnRiZ3c5K1BnNUQ1?=
 =?utf-8?B?bGpJK2FuTDhxWDNrVGZNb1l3R3RoekZGb2NZUlIzc216YUF2bmxRNklrNUlO?=
 =?utf-8?B?TVhkUmhXeWdvb0c0SXNqZmRTenIybkhFcWlJcWpDUUJ3Mzh1MG1wdWZKUnl0?=
 =?utf-8?B?dTR5M3JwSk5FWXpCbE5TQ3l1eGM2T1VlNGN6U0RVdWpqUHh0SjN4L2hDbmVZ?=
 =?utf-8?B?NmpNMzdieHRYODU1OXJUbWhyMXFlekhYMTZmd0RoV1pxQ3hLRDZuQjRqeVo3?=
 =?utf-8?B?N0ZMb1d2aTZnd1VKeEFBbS9QaHpBalcycU1sVUlkVGhrcWFPMGFGUkMyMVM2?=
 =?utf-8?B?UVBQQk9XNElhRXBJWVJIMnNIRUZZWWJmemtUeXEvenppOXYwTSt2dmdFRlVy?=
 =?utf-8?Q?d+YV0vYfyEsIJUnqhDjtKX4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45A97D4ADB86B54287ACA6414B1B594E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6596205-1851-47d3-b67d-08dc6b0510df
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2024 00:07:48.1565
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iQn2SXUrLbM6i/uooVublUrgMFOWwLx8H4haaJeiiGNob/GJSK+5ZD6yE2s93Y/EW89+usGdTZ9zVkL77PevAMj3CxID5vY79luJt+Jcxj8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5983
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTAzLTAyIGF0IDAwOjIwICsxMzAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IFRE
X1NZU0lORk9fTUFQKCkgbWFjcm8gYWN0dWFsbHkgdGFrZXMgdGhlIG1lbWJlciBvZiB0aGUgJ3N0
cnVjdA0KPiB0ZHhfdGRtcl9zeXNpbmZvJyBhcyB0aGUgc2Vjb25kIGFyZ3VtZW50IGFuZCB1c2Vz
IHRoZSBvZmZzZXRvZigpIHRvDQo+IGNhbGN1bGF0ZSB0aGUgb2Zmc2V0IGZvciB0aGF0IG1lbWJl
ci4NCj4gDQo+IFJlbmFtZSB0aGUgbWFjcm8gYXJndW1lbnQgX29mZnNldCB0byBfbWVtYmVyIHRv
IHJlZmxlY3QgdGhpcy4NCg0KVGhlIEtWTSBwYXRjaGVzIHdpbGwgd2FudCB0byB1c2UgdGhpcyBt
YWNyby4gVGhlIGZhY3QgdGhhdCBpdCBpcyBtaXNuYW1lZCB3aWxsDQpwZXJjb2xhdGUgaW50byB0
aGUgS1ZNIGNvZGUgaWYgaXQgaXMgbm90IHVwZGF0ZWQgYmVmb3JlIGl0IGdldHMgd2lkZXIgY2Fs
bGVycy4NCihUaGlzIGlzIGEgcmVhc29uIHdoeSB0aGlzIGlzIGdvb2QgY2hhbmdlIGZyb20gS1ZN
J3MgcGVyc3BlY3RpdmUpLg0KDQpTZWUgdGhlIEtWTSBjb2RlIGJlbG93Og0KDQojZGVmaW5lIFRE
WF9JTkZPX01BUChfZmllbGRfaWQsIF9tZW1iZXIpCQlcDQoJVERfU1lTSU5GT19NQVAoX2ZpZWxk
X2lkLCBzdHJ1Y3Qgc3QsIF9tZW1iZXIpDQoNCglzdHJ1Y3QgdGR4X21ldGFkYXRhX2ZpZWxkX21h
cHBpbmcgc3RfZmllbGRzW10gPSB7DQoJCVREWF9JTkZPX01BUChOVU1fQ1BVSURfQ09ORklHLCBu
dW1fY3B1aWRfY29uZmlnKSwNCgkJVERYX0lORk9fTUFQKFREQ1NfQkFTRV9TSVpFLCB0ZGNzX2Jh
c2Vfc2l6ZSksDQoJCVREWF9JTkZPX01BUChURFZQU19CQVNFX1NJWkUsIHRkdnBzX2Jhc2Vfc2l6
ZSksDQoJfTsNCiN1bmRlZiBURFhfSU5GT19NQVANCg0KI2RlZmluZSBURFhfSU5GT19NQVAoX2Zp
ZWxkX2lkLCBfbWVtYmVyKQkJCVwNCglURF9TWVNJTkZPX01BUChfZmllbGRfaWQsIHN0cnVjdCB0
ZHhfaW5mbywgX21lbWJlcikNCg0KCXN0cnVjdCB0ZHhfbWV0YWRhdGFfZmllbGRfbWFwcGluZyBm
aWVsZHNbXSA9IHsNCgkJVERYX0lORk9fTUFQKEZFQVRVUkVTMCwgZmVhdHVyZXMwKSwNCgkJVERY
X0lORk9fTUFQKEFUVFJTX0ZJWEVEMCwgYXR0cmlidXRlc19maXhlZDApLA0KCQlURFhfSU5GT19N
QVAoQVRUUlNfRklYRUQxLCBhdHRyaWJ1dGVzX2ZpeGVkMSksDQoJCVREWF9JTkZPX01BUChYRkFN
X0ZJWEVEMCwgeGZhbV9maXhlZDApLA0KCQlURFhfSU5GT19NQVAoWEZBTV9GSVhFRDEsIHhmYW1f
Zml4ZWQxKSwNCgl9Ow0KI3VuZGVmIFREWF9JTkZPX01BUA0K

