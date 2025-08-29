Return-Path: <kvm+bounces-56360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F51DB3C2C8
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 21:01:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A801A058A7
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 19:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D7EA221558;
	Fri, 29 Aug 2025 19:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GJn1iQN4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B114A23;
	Fri, 29 Aug 2025 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756494068; cv=fail; b=XHFTLC0K0KzJwwzgMzEExRwIuyf2ClKUobFLiSxkYwUZNpsdDKmRIxLIEHat1/v5u1UVRXnCHFk3Pq6uxdGD7vq2evhpwtzLD6BPIDU1JMnl+SS3gh+/wVQ25nrTnhKOW2HjEiISvsBikP/Av7a7+mSm992PE3swPPNzafa+Veo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756494068; c=relaxed/simple;
	bh=J+I+r0iy7xHswu8AUBRLSKt8SClM73ZcPDqZW0rzaTE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HmM3iNAQqOf5drjmlHCuyXBtUmDHbdS5FAnx1qtCLbcTVvksIu6OwFsDQa/3wlQSn/VWv6QRkp9thGZmna2XNTUI/KQIki9a587C2Y2OdBKMmyiUk6MIEHk9uzo4nE4fraPlH3ge9hnPgSx8aNMFx530f8DrWiH7amP83H+63mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GJn1iQN4; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756494064; x=1788030064;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=J+I+r0iy7xHswu8AUBRLSKt8SClM73ZcPDqZW0rzaTE=;
  b=GJn1iQN4mDY8SNOoG4hLmdplnEb8qy5ZM64tmsoZz/d04zB9pgZeP/d+
   XXVoas0GBNIL61SYV3XKFY1jLVrILzc957DnAxGeAPywTiP/aqdLZLw4d
   NOfHfSnwx5ytyqhx9ihdUVYZkO54E2IHqbWaWIyB5lxzWr9yT9vsGiaFM
   GQUnODlEzETWWWl9gLgKXcw+JsDRMreK+pRYhqlcTsH8C/Tl5oyLYR2Te
   bmFbMb2Siw0JdcsS69GNQIoTASypn3IMHZk1LjrKQh2gAPcqQB2VvrczL
   sh2js3WqP5+J9f1DqDXTj6Xf02rBWtrJ8RVtFRJXg34L4nM4v3V+8MhbX
   g==;
X-CSE-ConnectionGUID: IZX0fQ6MQ9OMOv6l+g2mKg==
X-CSE-MsgGUID: GD8kH4W/Q5eJVRdCQMR7NA==
X-IronPort-AV: E=McAfee;i="6800,10657,11537"; a="76240180"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="76240180"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:01:03 -0700
X-CSE-ConnectionGUID: rxcNeEJUQJaywQspw4o9Og==
X-CSE-MsgGUID: 2AsrOAmYRD6hWcBbaFtKCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174808028"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 12:01:02 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:01:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 29 Aug 2025 12:01:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.88)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 29 Aug 2025 12:01:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4Yd+IEpgF73kb3lpLfl2Em61W7bK5IwWLnlO4Osumg5v1/1oNAgeOFx42nMFRw9UQTSVmxaNLt9b08+aHzZfRHyYlVors3tDro9i/HSRqNKrmSaMgmB8MRJPHoTurThbhcLXix7MwxIR9wr5hcvGDYqhhZWhjzZBYvPu0xnLbmaqNldqIKlRV203wEyRgKNf25pz4Hle90x9I8pM7ljCSz5tmH2AgYIYg+odmxclcUu6fTpkXy39x6hqKw+Xw4ZkXuycRjVz0zv6NfJzgyw55rCZSFi0hhiRkS2+xwey5kxPya5hoIfedmJAJQuejImufO3rOipBGhNi/BE1A+mYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J+I+r0iy7xHswu8AUBRLSKt8SClM73ZcPDqZW0rzaTE=;
 b=AkGPEvIpFlqe8R2bQHQpr0pAQCbHaeusBTLKCMkP9sc1G0hjK+DAIPN7bf0W45zvjDSY1A2sIjO51fmqcEM1jHNkUbDpbqImancZcm/rz4+koNYfNNA18+eHfhnd8SEBMI4uA304MdyumZycMAa7MROqeXKRk3hsitD8Z8olHEs6HEvoKRz9zLzsM59ZmPcOlI60+EP99sUe08WlTNSVVC51fCg73vGWhM7IZO8l9ZLVunU8TSEQ628vuZaxipHeAiKN3ouQfQx4XC7fkku70vqEbWJkIkdrfP1uQj5U4g7x1abnpUJpd0wbk13efFmFfGo1QP5YtuSxFv+tXYCHtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7328.namprd11.prod.outlook.com (2603:10b6:8:104::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Fri, 29 Aug
 2025 19:00:53 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Fri, 29 Aug 2025
 19:00:53 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>
Subject: Re: [RFC PATCH v2 03/18] Revert "KVM: x86/tdp_mmu: Add a helper
 function to walk down the TDP MMU"
Thread-Topic: [RFC PATCH v2 03/18] Revert "KVM: x86/tdp_mmu: Add a helper
 function to walk down the TDP MMU"
Thread-Index: AQHcGHjKBLPhpt8zuUCGgPQP9y9KvrR5/YkA
Date: Fri, 29 Aug 2025 19:00:53 +0000
Message-ID: <4a8df01a8dac0d3a880dfbe2439c80fb4138affc.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-4-seanjc@google.com>
In-Reply-To: <20250829000618.351013-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7328:EE_
x-ms-office365-filtering-correlation-id: 4f860ff4-3a5d-479b-efca-08dde72e60c8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VnNZbnZ4RUdzeDlrT1RKbTExZG8vZFBWTTFnaytPYktUUEpSWGl2U1JIdktn?=
 =?utf-8?B?d1BMY2xKaGtHcmNzdlN0NmVmeUhtUWtWTzduTUhLMk9hL05aMU00L1lIbUg2?=
 =?utf-8?B?dWd5TlNlVHdveXlDd2NCemQ1azN0NUFqd3AyVDg0YTkwYXdMSi84V0RzdUNv?=
 =?utf-8?B?djdReVY3WmpoVnkrbjVTdEd2alFrL0Vqamduekp2L1I3by9yN2R5ekQ0MEdF?=
 =?utf-8?B?MnkzQnR5TXU2d0FldXJEdEdHREFuT1NlTkQ1NzdXZEM2VDlCZjlweVhJSkMv?=
 =?utf-8?B?Z2EwWFdxVUlwRFVGaUZtWUFUTmlTSXlBT29ER3dreGtDb3N1VzdHM3NYMzhv?=
 =?utf-8?B?VUdMUmNSelpnY05aUzc5Qk94bEFGcExuM2prV2w1Z0FTalJoVEw0Ky80M3M0?=
 =?utf-8?B?a1luaGZaRmhPbGY1L3pBK045TE5EZ09DRVQycUFyK1dTaW5WS1oxckFiOHE1?=
 =?utf-8?B?Y1dOUHRWcmZZZW9WNjN4MUtyZGt3Tm9Kbld5QkdZSkN5VjQ0bVR5Q2M3enRs?=
 =?utf-8?B?cGYwdjNwSWd2RU5BME1ZZFhhS1hYcWxyOTNhc3gyTlZObFFsWElhTFBUb2JZ?=
 =?utf-8?B?WnUzWGRSWnY1MG42aUFIdXAveEZEVko4Nmg5Mkg2V3FzWkQ4VUhSRjFqbmR0?=
 =?utf-8?B?MC9qeWZLUjRzaTVLbXMxeTl5aGRmMWhBV2ErTUVxcWFibzZMWnRMY1RxV2Ft?=
 =?utf-8?B?R0Vpdzdxb0xpZHllMFJPRWhiTWpjbEd6UnhMcGVZWWhCcFM5Q0NxSnpsSy95?=
 =?utf-8?B?NThYVEVoMHhLL1A4SHZreDZXTUtYTHhUUUJwckdmWTBVZnN1ZCtTcFBvOXJ5?=
 =?utf-8?B?NnZTUklBRy9DM0Y4M1BNRTNLN3pleGpkTTh1ZnhsR1NPL2RONjlzOW00cXlG?=
 =?utf-8?B?aGZEcU5nZkdZT0RBTE9OVFhqTnA4SXdBSTU1Z01BWWlEL3BCS1FrYVJrMzV5?=
 =?utf-8?B?S2pPcHI0ZnFUYTF2cGluVHM0YTdFaHUxTmgxTHQ5MjY0NzhkV0NYYkFzOGJF?=
 =?utf-8?B?Z08rSEdldW5KK0M2VHlKRTVOYUlJcWFNdkNndWZqOHc3UGZDS1IyVy9tbnF5?=
 =?utf-8?B?Q2RwR3VLZ2E1UmQwS25qSEdJSlgxazVjamRzR0F1bExsaHlaYUVvMXE1Qzhi?=
 =?utf-8?B?ZVVCZ1p6cFRoYlAwa2FjZEdXazV6ZU55WndEUWlXNVJmNU5vTFIrb1ZMYy9v?=
 =?utf-8?B?Yk0xZ3hhSFRPcy9pVzNGZTFQZEY3ckxhVUhpU3FUSThOYXNYd0FQekR3c05y?=
 =?utf-8?B?bHd6a3lybklhSTIzazByeWxTR3IzTGxYUzM2TXZZR3liZUVaUlkwZmliaE9v?=
 =?utf-8?B?Sk56cnRBTmFVM001V0h1RGpDT0s5TEIzVmw3K1pxbDNDOVlucHJLYU9sRmhs?=
 =?utf-8?B?R3FJemxwRFpkRm5WNGZzYkw3NGF4d0R5Mm1ZaTFIWHlZMHplRjFibnVRM2do?=
 =?utf-8?B?UWhIWURMYURZY1pTbEZESTFIY0ZWTi9WdG5wdzU0UTJpQkFqRUlFR2ZzV0Jt?=
 =?utf-8?B?ZlpkcTZOUnY5MmpJMWwvNlBFay9ydVhFdjU1ZjV5ZDZNWHhITE53QVZDWmlB?=
 =?utf-8?B?NVJlaUlUV24wMWJiSndFM0JEQnNJWk5Ta3JUc0pmaVdXWUFvcXM1dUpBak5r?=
 =?utf-8?B?QVVLME9aUnVKTG5LcGJDdnppZ3Q0SlBRMk1qRHZnckEvdlh1Mm44TWMrdVl6?=
 =?utf-8?B?dlRKWW5qYXEvNHE2RnJZeU9DV2c5aGZwRkltc09CZU1LS3FYWjJZMUI3MEV0?=
 =?utf-8?B?OXV3VFJReGVhMGx1ZnJ4dTk0eHIxUk5qZS9sZ3ZqN29OWXdZbmlkOEJxcnFM?=
 =?utf-8?B?V1owSVdZcTNGdldIOTVhWHVLMjVNQXhrbVExbHNhcjRZMzBXbFRtWi9EaWJs?=
 =?utf-8?B?OFhucHJ5T05FZ1ZzQm1EQzlLVkI1L1l0eTlpQ3ZxWUVwSEkyVmM4THdMaGp4?=
 =?utf-8?B?NTU3V1R5am50OGVhdEtsTjBEdTYzRUxTeWtBeWgxbjBvQ09aakdkdDB1TTln?=
 =?utf-8?B?SkNqSXZUQnFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b05xQ1czT29IN0lxZUU5WjR3cWRWUEp1UVRHVWEwQ3FSZUhQVURQQ1NjMm0y?=
 =?utf-8?B?Nm9xOWppOU1mRkdrMVNiQXZ5RU9MOTF6dDB1Q2N2SlZnYWVwcFh1YktHQ1hL?=
 =?utf-8?B?V3FGVWlQSElPdVBmZUtXNDdRUGlnTk5zMHdybDlheTM0bWFxdXh6QVRzdXZZ?=
 =?utf-8?B?cDBGSHNGamFwemhmdjZHTDdlMGd2TVBqT2FrbjliNWF0d01BazcyT3lEakhm?=
 =?utf-8?B?UmRvUndoWmdtY2hWS0lVbG5RQVNHTk5LOUxRRElGOGN0QjRxSXZveDN6UFNq?=
 =?utf-8?B?OFBDRjQzSS9sZzk5dVlsZkxDU2hVbm5teWx2a1dFZWxnTUtZd2sxbjNndGZv?=
 =?utf-8?B?Y1FnTmdtUXRCYnhSNldtNjNyWFAxSWk2VDg2RS9mY3M2MmUxczhZK0gxZDdn?=
 =?utf-8?B?d0FNVTNCbFBkUkw2bFlGcWtGNkxpTk42UnNISWIxQS9ST2Z1dXk4QlRqKzJV?=
 =?utf-8?B?T0I0SWhXYWdCQTdxU0lmVlVJQ1hlVHFwYVl1RnNocGcweGlrZTV6aFFzZTlx?=
 =?utf-8?B?UVFZYkJGVU9QVloyZHN3WTJBZnZFL1pXVzhDbkNrS3p3bGFWbEErSThjdExi?=
 =?utf-8?B?ZjVvSHBzUG1VMTZuaEtKZUs0UVd0MldIVDN2UG5UdmZnOTNtbnBxdnFDY0Ur?=
 =?utf-8?B?MzJJNjRoOVFnMUtneEsxRUpPSkNuaVVEUVAybC81ZUsxcXRSVE10SENkK1pa?=
 =?utf-8?B?N1U1cWxCSXhQYVYzaitOb3RHaG4wUWEvZmoydFlaZ1pQWU5WUHNiMUgwcCsx?=
 =?utf-8?B?dk42QzBGYzVVa2FHeVZaMUV3amRnNmdqTzZtSjZrSDlUeWFMSVpFVzlqV0RM?=
 =?utf-8?B?TGFzOURyVU9nTzJXMGtERHZOS2VwVDhLUkV5UGN6cVJudEJBR2xNRUJUd0c0?=
 =?utf-8?B?K1J6cjhmZnVTSy9TMTJCKzBSRXhFV3I3eXBCRVB1MzRiMXhqRGNHVTNmcTdK?=
 =?utf-8?B?R0VRQ3hwa1huN0NwemNlL1FXUmN2VFE4N2ZRa0NqNnFQczA4Q2cvWFJ3Z3FJ?=
 =?utf-8?B?cGk0Q01tUlR0MisrMjVLc1BUYVFmcWQzaER0L0lXdDZZbG9pYjZxV3pPOTlI?=
 =?utf-8?B?UzFSWGNkRzZFcWNEM1l5bnp6WTc2SmhOYm41VXBmaVYrUEg4VG1wVHk4MzNN?=
 =?utf-8?B?Ykw1Y0dLZHJock1RUkowS2R6Q28rbDRGYzRRblFpaTlKdng2NzRQOGdiVmcy?=
 =?utf-8?B?eDBpR0xnMVlCL01BRHBmd2VVNlhIWmJZVnF1UGdpL2pJSW5hOTF5TGthTG04?=
 =?utf-8?B?OGFmbFQ5SUNhMEE5OFBKeG9BZXE3YllLYlJITFZDY29Zb1QxL2FXQTI2eGxn?=
 =?utf-8?B?WjR3QXdVenFHdUNMWENtdjZGOFZTYTg4M0FJVHp0bU1JK0pPekcyTDRpS1Ar?=
 =?utf-8?B?dXovZWhialRhVVRXYU9Lc2N1WHNsRWtJV0Zic1ZRbUlIcW9IR2NwZmsxUzlw?=
 =?utf-8?B?Y2ZYdU4vOStkemkxMWhuZGNTVFJZMDhBMkxXVGN1bWRxTlVydUx0TFROWStN?=
 =?utf-8?B?UkRDNnhKN2JVTk5STUE1WkFsYUhicThvcGlyQWYrcE81d0NNbkNEbzIwQlEv?=
 =?utf-8?B?U2dvTmhlaWR4cklUeVVnOVFOR1Vqa2V2a3dPUzVrT2wwNHpjZXk0eDZwUm4r?=
 =?utf-8?B?dW9lVW96RmduV0Z0TEM4MndEV1lJb05BUmpYS0JCQmxpN2lqQ25PbzN4dVow?=
 =?utf-8?B?NDRUOXYxU01NTGpDbUhESFA2Y1EzN2k2M20zMVhudDc3eDF6KzlwSFdBZWwy?=
 =?utf-8?B?REpUSVZpY2VTMG1ELy8wY2VpajUxYWdxOFYzTHlkVXk3Zzl3NWp3cHViOUpT?=
 =?utf-8?B?L2I1cTYySmc3Ykd0RmdwdExqNE9ESjlPZmhYZlRBUE90dEhiZTBZQnZOelhl?=
 =?utf-8?B?WWlaUWFPOEEzM3p5ZDhaZ1l0alVKTDFGNjRNcmYzVnlFd2RZM0svS3g5Slo0?=
 =?utf-8?B?dkFmanpRNjNHWWVMb0FkbUo1MmRUNkMyZEpmQW1tUjFpclBjKzBHY0hNV01k?=
 =?utf-8?B?SUJtL0M1UHZwRUlBakFZZVNWV1hvRXJSRnZVcDM5MVVoUFIyc2FCVmRMZ3hp?=
 =?utf-8?B?RHNLN1dNRitTK1dRN2ZaV0FmYnVQdDYvUWtrdmVVQ01aUG45amtndE9OVVIx?=
 =?utf-8?B?Um9KUEJwTWdDYUlGcXkvelJ6Z2pQR01YbkFlV2lyRlloOFBlSGtEMnJ5QW9n?=
 =?utf-8?B?TXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E15A63BBF2DF094BAF743653739DC6E6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f860ff4-3a5d-479b-efca-08dde72e60c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 19:00:53.4747
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DkLz3yWSqREpQ8B+ktBSs3TtmCCjeEbqyLoleMqHTeABAFySJ7/KX7v/CwKfG6PbFdVEgVTrLyD7UnFTRe/N+yC3ZdroNWfh4Akoy+TdOzM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7328
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE3OjA2IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW1vdmUgdGhlIGhlbHBlciBhbmQgZXhwb3J0cyB0aGF0IHdlcmUgYWRkZWQgdG8g
YWxsb3cgVERYIGNvZGUgdG8gcmV1c2UNCj4ga3ZtX3RkcF9tYXBfcGFnZSgpIGZvciBpdHMgZ21l
bSBwb3N0LXBvcHVsYXRlIGZsb3cgbm93IHRoYXQgYSBkZWRpY2F0ZWQNCj4gVERQIE1NVSBBUEkg
aXMgcHJvdmlkZWQgdG8gaW5zdGFsbCBhIG1hcHBpbmcgZ2l2ZW4gYSBnZm4rcGZuIHBhaXIuDQo+
IA0KPiBUaGlzIHJldmVydHMgY29tbWl0IDI2MDhmMTA1NzYwMTE1ZTk0YTAzZWZkOWYxMmY4ZmJm
ZDFmOWFmNGIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFu
amNAZ29vZ2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRn
ZWNvbWJlQGludGVsLmNvbT4NCg==

