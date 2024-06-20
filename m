Return-Path: <kvm+bounces-20164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B47F91124C
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 21:38:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F9BA1C22EFC
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 19:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 551121B9AB9;
	Thu, 20 Jun 2024 19:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mnd1jddZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C3A52F71;
	Thu, 20 Jun 2024 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718912293; cv=fail; b=dl9/zQO2diOfxg3eIGNbWaOVxbly732YcDpscqh8fHtvdnw9NHRiXtfE7XGQnUom9b+rpdHi7zyIEHR6rFh2F8AYTCW5TQ+1+HSrA0oDBnH8Q4vrRJoPFKdq1mnpqBAFvB4UcFwdm9jH9jrymK0ucIFxQJ7I0WHpcN3EdOf01cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718912293; c=relaxed/simple;
	bh=QF88P49Okl61XrEtrGc5dlwajST2ymTLRSctvVcBzNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=orlsRYflgC1bhppekh+80G67m7AYiFcXs93dPMf4Z/+eJ51DoU15eSRzVjwZ5Q7tLr36QwSmONVu97zwFeEq9ml/+GoM0TqEhHpFz17VOdQzRjhU6B0w61ZRGAoGWOYy2RppjLVTFJvo6ZiNgAyaOKO24PbBWgCjoNlXdmm0tVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mnd1jddZ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718912292; x=1750448292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QF88P49Okl61XrEtrGc5dlwajST2ymTLRSctvVcBzNQ=;
  b=mnd1jddZAR5j3JHRXnB73HcJryvBtdgW245d3vUle5mz20IhUFEfi703
   kZWhiGLBRs/MnM6WOOaM7tE3F9KuRYPyJZlA/QVyWnWdzzqlDkEoTBFvc
   90cz3lnFq790w6BQFB5VDsoXRXet6hvS6uaHymT+qDraxlYu1Vp/4kj77
   nXvITPyC115N3hcVTjr+6p31qi8fjFSowqYcYos8cQmrhJ1i/UKq+/3Q7
   9gWJFV2x/Ck8rAtt7EHZ9N5tjRPzB2M1QbQfdt+w8XNIAJbj0pxEBCQvQ
   y81t26An4cE819nctDp4ZzXji0iAb+cXUkhhOU8TQ0+kMUn/h1zTNvJw6
   A==;
X-CSE-ConnectionGUID: 9VbMWhWPQbi8j2rJT8C9kg==
X-CSE-MsgGUID: kkbKtB2UTra+XKteeCO2hQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="19699627"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="19699627"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 12:38:11 -0700
X-CSE-ConnectionGUID: F2vy1aLcQHKnt7+Dj+GgzA==
X-CSE-MsgGUID: wv/jLVMHSm66+4aBRuSi/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="43034468"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 12:38:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 12:38:10 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 12:38:10 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 12:38:10 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 12:38:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gN8J9OwvJQ0v92zxMrTEGcrpGuxSyyq9pBKGrwnWowZCD2aCFwNzW6fkP/ZBvD7jkcxdCKlybQ5eDbyn4Hwq8ITTE/khmBGIXUf52vAhReZTLZIob2eQeKP1UtJxw8SWPlr/gs/yIPUXpW0SEZ1j7NdDVhKStqv0YsJ3xaEhwN13jIqT5KjaL0C9RVQ7Q+sXpYcqqAOxKBVL4v6b5ihA4NM1HyQq9mFx6dEZnk+CqltAxSUgGTYOQ/GH7a2UJPY7npO+yoJNP/Rd2tIfF0j/4noVleIn2olk52tEyuFeoHhmtUCuRwFRo0OnS77+WjhJYehHvhBbCglzlZOcmwo56g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QF88P49Okl61XrEtrGc5dlwajST2ymTLRSctvVcBzNQ=;
 b=gPtBmlIohXbXsqlj9Yr4syvgzYZPdUYJp4UF58Qu5LkQm0zwjzqEDCpRr9sPCkY0kMyt5NTECXfZ2wr3Hs9c74kVQI9kjn7WGXzZsa/rI0ejQ1VzKKFJeMkZBYQo1aEYlTXYM9l92+kw5F6jeyD7diYjujnPoaijgsienMpBYI2LeQjWpHiPx9+A9FyR08d+Fn77TKqpmixeLm8SjUipn42OK2lHT5CqlRF/ouurK8xVm1Ew3a7GG7YsK23JZhapZE+JyhRUlinriItNRyLRjBwUbYYo0mPyNmdRYlSVwlioD4916o6puJHpxKrxhYM564TJEsJXNzABQzjIWf8Q0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6335.namprd11.prod.outlook.com (2603:10b6:8:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 19:38:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 19:38:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Thread-Topic: [PATCH 0/5] Introduce a quirk to control memslot zap behavior
Thread-Index: AQHavVgfQPm70dQw5Eee10kcdYgSb7HGHiqAgAWlogCAAdqzgIADeY8A
Date: Thu, 20 Jun 2024 19:38:07 +0000
Message-ID: <21b18171d36a8284987f8cf3f2d02f9d783d1c25.camel@intel.com>
References: <20240613060708.11761-1-yan.y.zhao@intel.com>
	 <aa43556ea7b98000dc7bc4495e6fe2b61cf59c21.camel@intel.com>
	 <ZnAMsuQsR97mMb4a@yzhao56-desk.sh.intel.com> <ZnGa550k46ow2N3L@google.com>
In-Reply-To: <ZnGa550k46ow2N3L@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6335:EE_
x-ms-office365-filtering-correlation-id: 8e07e3cf-f6f1-4a3b-dc34-08dc916082aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|376011|1800799021|38070700015;
x-microsoft-antispam-message-info: =?utf-8?B?RnVCaFJnZkRELzJad2t5UnF0NTNvem10VG95NjJwN3lDUG5yTnNKWWhTQW9J?=
 =?utf-8?B?czYzZHBTZ0ZPNFcyR3ROcy92S3plWnFmL3NqR1NsZHcxeHk4YmZtREhqRzBa?=
 =?utf-8?B?dmhPQ1VWMldBdFduZnlhcDhOaG9LajdVbEd6SG1QNklpVDVTTG5UemlrQmdJ?=
 =?utf-8?B?RFJyMTlGYmh5WkpmNlNlZC93SVVJaDYvVzlOZFFMMmVUSnpBZVdwelRJQ25n?=
 =?utf-8?B?cDZkdGtJWjZMRjM5aVF1Tmp0a3l1MVdBUitjZnE1RnNSYWZlTFI5UkhVcXZk?=
 =?utf-8?B?TXFvMHlIcVpSZjFvMkpnZ1BVem5jcnBrZTNhajVYSVVtTmhVWStBZ21IaDQy?=
 =?utf-8?B?WG9zNjZWTFcvVm50SjFaeHV1Y2d0NFhtS3V0SFJ0UWNjK1NRak00M0s2b2ZZ?=
 =?utf-8?B?Y2tEdzJSUE1JUFJucXQvK2dSRU1HQ2ZsT0I1dXVCeVRNUXV2R2kvWUUxdlRW?=
 =?utf-8?B?dy9uMHEvT2wxWFVaZ1dLZ2sxd09FRFl3L2JJSUoxM1YxRFcvVHVrNExSMEFl?=
 =?utf-8?B?RDQ4ZmV3dHdxSy9scnZ3ZWJHNll6YTAvemttNW8zNEw3Z2lNYmppeTgxS3NS?=
 =?utf-8?B?QWF3R2VzdCsra0ZxOWhFSVMxTkovYmk4L3ViV3FRVEdUSjBYeVAzcW54dWtI?=
 =?utf-8?B?dkdTRHZqdEVRQzczamRrQUJ5RzloakZLMjB5UW5wVXQxSDBXbk9ralAzVDJn?=
 =?utf-8?B?RjlEVGpOR2UwUDFBb2svdC9IczVrRCt5Z1RvbVRUeE9HL1VUc0JpdXh6Qkln?=
 =?utf-8?B?NGt4SjdRUjlIOFp6amkxU3NjWTNGRVovTVhKajE0MjA0Y0RlaXlPZWZQMXJ0?=
 =?utf-8?B?aXhXZExXMloxRWdIZlM5Y2FUWUhoZVA0OGFMdm5USUIwb2VrNHMwTXVGWFdM?=
 =?utf-8?B?VFlrZ3pXVHNCejYrWTlpdHVEbWFsTjlOdjhnS0xBNzUxR1ZkVU1BQjQ1eWo3?=
 =?utf-8?B?TkdHUXVmd0xJZUppUExucE1QYW1kamVyUDBsVXBtaFFDeWQ1YzhGZlRTY2Z0?=
 =?utf-8?B?cW5wZ1Q0L0FNUnFOaWlLM1NTMkNlSndqWmxTYUtvcUliYk0zRTRXVkF4RXJv?=
 =?utf-8?B?ZEJNWkpVeEVqbWFrQnhjc1hqNUozMEpRVEZKVnMrS2VOVVJkYnA5eE5JMkFa?=
 =?utf-8?B?dmRMUjhkR091VmVPSXE1K3B1YjJJRG1lK0o1cVdQUXNsWGswOVprL3dpdTZR?=
 =?utf-8?B?S0VybTlrYXRNQ3Ywa1NUNGRKVUZmZ1c3MUlWclVRTHhZdUtQRkFTR0MxU1li?=
 =?utf-8?B?SlFUeExRN21XcG1KK0ZmT3JQUlRBMzZjcTVsbDJKYlBqZVNrZmgvVmR4VXRn?=
 =?utf-8?B?eXl6VG1Cby9CejN6TmpSSHhIRHUvS3k0OUQzSHZScHJ0eUw5SFFqVXNRRWJu?=
 =?utf-8?B?VzF1OGtXVWVJcWFNTkx1R2ZhelJYdHBNOEVPeHJoajExRmtqbHBNNElyeVBh?=
 =?utf-8?B?UWgvZVcwckJPME1leHV5NXVrOTIweDlBQ2ZDNXhGOWN1YXptWW5vZlhyRFJJ?=
 =?utf-8?B?bmtoejZ6Ty9vUmFwUC84d3hQdHhBMEIyU2dWTzh5Z3NjcDVvWjVNOE1UT0Jh?=
 =?utf-8?B?bGJmNnRmT3BFdGo4WXhya21TUkNUcmp3UlNMbnlJVHkrT3B5bGlQdWFMNGFG?=
 =?utf-8?B?M2tFdWZwUC9PNVRtOGFLRTdMc1ZvRUYyTmdQNjluR0JRVFQwbEVhMnRKcXRL?=
 =?utf-8?B?VEJzQUMrR1pqU2hna0djWWVSdGs4TUFqOGEwRWloZ0RNb1dOUzAxd21sS1Bh?=
 =?utf-8?B?eTVlQmh0ditIVHZROGJTelhuR0RLd1VrejNBM05IZmlwcVFlYitRa3U1WXg3?=
 =?utf-8?Q?EZqq/0ZHpTbjJXr2d8V47Isa2eYoR8S9NIMtc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(1800799021)(38070700015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjZhck96d0pOZlZIcmE2U1pzSmJYTGFtdXRWbm4rWHBDVDZ3a2ZWaDVxVHBS?=
 =?utf-8?B?UzlxMTNXZi9KM3RRdDBZMDNYZEM4V2J6eHpoVlY3MzNJeXFxRnVLNVV2SDlF?=
 =?utf-8?B?SG5iK0xPdmI0aUc4VmxnejR2SHdjOTFXVU9PMWNObVgxWThqQjVWMWxmRnlH?=
 =?utf-8?B?ZEUvMXdaSThQQk9Dc0g3ZGtXcVNpMjhaaVgrUVFCemNQaW4xejZ4b1k5MU1B?=
 =?utf-8?B?WFZ4eVJaQ3pVSzdmMEJJdCtpZW9DbGxWTTZsTU9TdGFzWGM5RWh2ZGZXdnh3?=
 =?utf-8?B?a2RHNGVnaDE5bytHc3VxYWlWMVRDS2I1RmVYRzlxNnRYYWhwSUxmRWJEMUhI?=
 =?utf-8?B?TGlSdHFEVE9XU1hEY3pDajh3dnhQTGowU1cybmlKMXhHK3hNOWlXbEZrUzYr?=
 =?utf-8?B?QUJmYTFNcmlkMFRVaktURytmOWRNNXNkVzVHREt0K3JON09TYTVnR1UzNXZH?=
 =?utf-8?B?Q1A0N1pXL045b3F6QTVhT25rVmxWcVF5NE53MWVGdmIzNEk2MlMvcG1QSmJB?=
 =?utf-8?B?L1A5S1d0SndrZHJWMGMrTWlzUmE3ekE2MDdrMkZuV1ZIRXkwbWhvb0RJdDFl?=
 =?utf-8?B?YmE5VEc1Yjd4b2tKeEVnVHphZXZucS96Ky82RjArVmx6TUdLMmdlajZKcWlY?=
 =?utf-8?B?K2R4aHQrT0pMWUR2VWVnQnBQbFZ3b2hjQ2FjMDR5YjUwRkJPNkM0Z3VUWG9o?=
 =?utf-8?B?ZXZZUGdxTytDNE5jVnlkMGNjMzRMbVloSDRpeDJ1Z0F1OFBob1lja2ZlaGRT?=
 =?utf-8?B?Wko0TmVPRXROemhYUnIvS1ZUWkxaSEdRSXI4S1JIcVpTcFQySnRVNkRoejE3?=
 =?utf-8?B?TlIweis0OVBubWs4Qk1HbnY4ZUhOUDFUMSs0SUdvN3VraTRES3FSeHlBaVBG?=
 =?utf-8?B?S1M2ZGRZSWRiVTZKRzVITyt3aGJSZXk2QTB6UTVZZGhjZVhSVUdaWjV4UzJn?=
 =?utf-8?B?eUk5SEg2QXJmTWFGZlh6a09FbFAzeHlTRVBEOVRZUGRrMFU3NGdYbGJXWURU?=
 =?utf-8?B?djhyTE1pbTBhN1NtZ3MyZHFQK3R3TXpTNUllY0NGYmpoWWRCOHZmd2svNSto?=
 =?utf-8?B?S0J5ampsTmhZeml0ZGtGL1NSSzRhM1Vwc1BNS1VZVHZ5eDNsdXVxazBkS3Jn?=
 =?utf-8?B?bHkrbW95MUtWRUMvOTMwcUFmVHdWZ1BuNThkdUJncXlIbHJuM21lMWc4eWFj?=
 =?utf-8?B?SDI1bk5kaDFQNVBmRDRWTThhTWJUZHFOQU5OTUVKWXY4SEhxWGJFNStjMi9L?=
 =?utf-8?B?WUcrODd3TE84T1hzWmdxdGpsT2drbDNWLzdmZlZYcFZCZmpyTS96b2J2SGJm?=
 =?utf-8?B?d3o3YkQzR09tQk11YUR1bGRwc3ZuRjREODNPc2k5WFIxN1E5UUdjNUNsM1g1?=
 =?utf-8?B?bGRqUXdTOTFwaGlFMmpiejBwSU5DdGxYMHZkVHcxamlLTE54MENkclJvNVJN?=
 =?utf-8?B?aUJIdzFMZys2dDkxQ1JlcGVVTmRuSXNBc0dWZmQxc3diNEpsMjBUY0d2Wkkr?=
 =?utf-8?B?MDRBbUVRbWMyNXFrajJ2M09FdTBqSVJQaXBNTlZaVkRmV2dBcHgzR2pHazNJ?=
 =?utf-8?B?L0VHTFFnR0E3aHBWZHEwYWRCbUhHSFlOclJqblJ2cDBpOFdCQ2FrR1BpM2Vj?=
 =?utf-8?B?dW9wdE1wQTVpVWFoRWEvaDkrNCtuVU91eEx0NnE0NkVMWVhxQ3RNVnhFZVpJ?=
 =?utf-8?B?U3N0ZWt6V0JvUlhQelMrYlZZcUo1cHVyS3VDY080V3BIT2dkZ0dnYUNSU1Fp?=
 =?utf-8?B?dkpMNTYvcVhxOEdSWVJucDErVXlDWWpsQzJzZU9hdDk4NHB0Q0Rnc2hyeUNJ?=
 =?utf-8?B?cGlYREJUazAvMFFVTlNYZGp0VzlETmV3RHM1T3BSaTZmODJOSEEvN3JqclYx?=
 =?utf-8?B?UnFtSEp2eUc0cG0xcDBpUkVUWm12clJhK2k1TzNpbWFWV2FqY2lrWkVwd3dP?=
 =?utf-8?B?R3MyUFkxTUdkQVBFb2NIWEZ1aGJtb3NQci9MTDRUdDBuZkZKMDdtdzZTeTBv?=
 =?utf-8?B?ZnNGRkNwL1puTzVQZzI1MEFYLzlHUU9uQU5OUXdJVXMySk93WVhIK04wTWV1?=
 =?utf-8?B?dEI0c2F1MmcraVd1ZFMzR0U1SFZnKzhJNWdkNFV3TVVuQno2ZzM2NXk3Y3l1?=
 =?utf-8?B?OVQzQ3dxZ3FFcjdTUnJMbzY0NlBsT3lQczFGZnIrdU5tZEE0MGFQRi9QZGZ3?=
 =?utf-8?Q?FHQqkA/Mz8rUxosB7330QQQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3194482570D8A4428A164E9FFAB85A32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e07e3cf-f6f1-4a3b-dc34-08dc916082aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2024 19:38:07.4624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wqpnTGE4he9nbmL9COWSLX8okmgLE3kye2RZdI6Yxk+XzI0qJRGSTV+PYRpui4TH4qtHQSEppZw7pHaZk92uRzNeUDHVwkbHJQxRjdyqzpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6335
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA2LTE4IGF0IDA3OjM0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBUaGVyZSdzIGFsc28gb3B0aW9uOg0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBjKSBJbml0IGRpc2FibGVkX3F1aXJrcyBiYXNlZCBvbiBWTSB0eXBlLg0KPiANCj4gSS5lLiBs
ZXQgdXNlcnNwYWNlIGVuYWJsZSB0aGUgcXVpcmsuwqAgSWYgdGhlIFZNTSB3YW50cyB0byBzaG9v
dCBpdHMgVERYIFZNDQo+IGd1ZXN0cywNCj4gdGhlbiBzbyBiZSBpdC7CoCBUaGF0IHNhaWQsIEkg
ZG9uJ3QgbGlrZSB0aGlzIG9wdGlvbiBiZWNhdXNlIGl0IHdvdWxkIGNyZWF0ZSBhDQo+IHZlcnkN
Cj4gYml6YXJyZSBBQkkuDQoNCkkgdGhpbmsgd2UgYWN0dWFsbHkgbmVlZCB0byBmb3JjZSBpdCBv
biBmb3IgVERYIGJlY2F1c2Uga3ZtX21tdV96YXBfYWxsX2Zhc3QoKQ0Kb25seSB6YXBzIHRoZSBk
aXJlY3QgKHNoYXJlZCkgcm9vdC4gSWYgdXNlcnNwYWNlIGRlY2lkZXMgdG8gbm90IGVuYWJsZSB0
aGUNCnF1aXJrLCBtaXJyb3IvcHJpdmF0ZSBtZW1vcnkgd2lsbCBub3QgYmUgemFwcGVkIG9uIG1l
bXNsb3QgZGVsZXRpb24uIFRoZW4gbGF0ZXINCmlmIHRoZXJlIGlzIGEgaG9sZSBwdW5jaCBpdCB3
aWxsIHNraXAgemFwcGluZyB0aGF0IHJhbmdlIGJlY2F1c2UgdGhlcmUgaXMgbm8NCm1lbXNsb3Qu
IFRoZW4gd29uJ3QgaXQgbGV0IHRoZSBwYWdlcyBnZXQgZnJlZWQgd2hpbGUgdGhleSBhcmUgc3Rp
bGwgbWFwcGVkIGluDQp0aGUgVEQ/DQoNCklmIEkgZ290IHRoYXQgcmlnaHQgKG5vdCAxMDAlIHN1
cmUgb24gdGhlIGdtZW0gaG9sZSBwdW5jaCBwYWdlIGZyZWVpbmcpLCBJIHRoaW5rDQpLVk0gbmVl
ZHMgdG8gZm9yY2UgdGhlIGJlaGF2aW9yIGZvciBURHMuDQoNCj4gDQo+ID4gPiANCj4gPiA+IEkn
ZCBwcmVmZXIgdG8gZ28gd2l0aCBvcHRpb24gKGEpIGhlcmUuIEJlY2F1c2Ugd2UgZG9uJ3QgaGF2
ZSBhbnkgYmVoYXZpb3INCj4gPiA+IGRlZmluZWQgeWV0IGZvciBLVk1fWDg2X1REWF9WTSwgd2Ug
ZG9uJ3QgcmVhbGx5IG5lZWQgdG8gImRpc2FibGUgYSBxdWlyayINCj4gPiA+IG9mIGl0Lg0KPiAN
Cj4gSSB2b3RlIGZvciAoYSkgYXMgd2VsbC4NCj4gDQo+ID4gPiBJbnN0ZWFkIHdlIGNvdWxkIGp1
c3QgZGVmaW5lIEtWTV9YODZfUVVJUktfU0xPVF9aQVBfQUxMIHRvIGJlIGFib3V0IHRoZQ0KPiA+
ID4gYmVoYXZpb3INCj4gPiA+IG9mIHRoZSBleGlzdGluZyB2bV90eXBlcy4gSXQgd291bGQgYmUg
YSBmZXcgbGluZXMgb2YgZG9jdW1lbnRhdGlvbiB0byBzYXZlDQo+ID4gPiBpbXBsZW1lbnRpbmcg
YW5kIG1haW50YWluaW5nIGEgd2hvbGUgaW50ZXJmYWNlIHdpdGggc3BlY2lhbCBsb2dpYyBmb3Ig
VERYLg0KPiA+ID4gU28gdG8NCj4gPiA+IG1lIGl0IGRvZXNuJ3Qgc2VlbSB3b3J0aCBpdCwgdW5s
ZXNzIHRoZXJlIGlzIHNvbWUgb3RoZXIgdXNlciBmb3IgYSBuZXcNCj4gPiA+IG1vcmUNCj4gPiA+
IGNvbXBsZXggcXVpcmsgaW50ZXJmYWNlLg0KPiA+IFdoYXQgYWJvdXQgaW50cm9kdWNpbmcgYSBm
b3JjZWQgZGlzYWJsZWRfcXVpcmsgZmllbGQ/DQo+IA0KPiBOYWgsIGl0J2QgcmVxdWlyZSBtYW51
YWwgb3B0LWluIGZvciBldmVyeSBWTSB0eXBlIGZvciBhbG1vc3Qgbm8gYmVuZWZpdC7CoCBJbg0K
PiBmYWN0LA0KPiBJTU8gdGhlIGNvZGUgaXRzZWxmIHdvdWxkIGJlIGEgbmV0IG5lZ2F0aXZlIHZl
cnN1czoNCj4gDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIGt2bS0+
YXJjaC52bV90eXBlID09IEtWTV9YODZfREVGQVVMVF9WTSAmJg0KPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBrdm1fY2hlY2tfaGFzX3F1aXJrKGt2bSwgS1ZN
X1g4Nl9RVUlSS19TTE9UX1pBUF9BTEwpOw0KPiANCj4gYmVjYXVzZSBleHBsaWNpdGx5IGNoZWNr
aW5nIGZvciBLVk1fWDg2X0RFRkFVTFRfVk0gd291bGQgZGlyZWN0bHkgbWF0Y2ggdGhlDQo+IGRv
Y3VtZW50YXRpb24gKHdoaWNoIHdvdWxkIHN0YXRlIHRoYXQgdGhlIHF1aXJrIG9ubHkgYXBwbGll
cyB0byBERUZBVUxUX1ZNKS4NCg0KT2ssIEkgdXBkYXRlZCAoYW5kIHBvc3RlZCBvbiB0aGlzIHNl
cmllcykgdGhlIFREWCBpbnRlZ3JhdGlvbiBwYXRjaC4NCg==

