Return-Path: <kvm+bounces-56172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD43B3AAAF
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 21:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 56DBE4E1877
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 19:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4333375C3;
	Thu, 28 Aug 2025 19:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X5Zr9U6z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23543BA4A;
	Thu, 28 Aug 2025 19:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756408475; cv=fail; b=OF+1wLIVcjNVhLiH76H0jUUGe553FTa/xaqBZP1GLXSq4CxO9HQvpvsakhJmEbiGt4OovLGGDDbGD6SCadhV7/Vwy9c7jg9p9MHNMzqtTS9ryAEkZ6DnDzJp/wSWmYOSuFZJSy9/DU3ZIyHLXaz7oFpCZ/eYLlplExVBBr+vTpM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756408475; c=relaxed/simple;
	bh=lK78PEhDLhkqI8XrqvxbkCb0zErrqMUYFOrHqtuT6dU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g8lO/FzW4lO3Owzy27m7dxat39LW5tRfSJYEBATRbWCHLhPkMokcnmQ8mmJ6rPITFOngUEsf6Qwpp20uPlk9B5AZBOhh5Fs9we6QGj77eOFTib3vB4HI+b6pMmM/em5029PnXPcSedhg/ieoSiniJtQXkDHP13dnygdHTbma4a4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=X5Zr9U6z; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756408474; x=1787944474;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lK78PEhDLhkqI8XrqvxbkCb0zErrqMUYFOrHqtuT6dU=;
  b=X5Zr9U6z26EWshOp6xzoQF7w1dn7gpI+1ZuvYvcaEZspaeKt0EoO+eWy
   x2ElACPnUvOv28S5CQx9NiyGfu821w/ByWGGIDjtwsxqf7Vz69PDZ4PYh
   1I7FCVSxsUTztM7lImw8WH18f+1iU98ipu7jMWEO7GfvcqgW7SolzWu5N
   JPqpQveV3F6ILMH+W0MqbGZL5f9ACUSGwGk2HXKJPE0P1KDdjRzYEpTlp
   2tpi/LF2ryRbR7yqdEYrwck3FVGXEKWPO6zX2v/nuXhz2GBCkNO630T4F
   u8taBTQ8DxCsGA++R52rn94os2NDHeTOipdJu68I+7YBxKH++S6thg0Lr
   w==;
X-CSE-ConnectionGUID: Yjg6u1sCRYyj6U15Ep7kaQ==
X-CSE-MsgGUID: TKEee37xQ/ODCw8uWBPLsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62522871"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62522871"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:14:33 -0700
X-CSE-ConnectionGUID: M3TQKbxhQvm/oLnBEh1ifA==
X-CSE-MsgGUID: AZeVfU1yTySlva46MhZrOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="174572041"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 12:14:32 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:14:31 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 12:14:31 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.67)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 12:14:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmboUIMeSfAGnUXR49tRMC83aHQoI1VnRF8tntxV5i6sWUfT68niPk22Rjc+nPVwVclMuKqfU7QYS3TuqEoV45HNzhx3FaWuYra1kIcRTTAPe/GcRdLsig3Sojl8VONvSsbjr6dSXa2I1jt9KmWqApA0gvrIR4JSmrGZ7Vs9JxJA/uLZdAHcBVMiYhySIgxWLRfXSVAPvFvyZkPThj0A/a/joHM7GzoNVbjyt+30/heC4SWtuuVnylTs70NSrnGZiOpFVLAYcUNiMF2siuOve0r1OExUvBME5goBwilQBw0zFS0oTwekK2V7cZbEQE98ohR1SBAQpKO1ONH6qR8iXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lK78PEhDLhkqI8XrqvxbkCb0zErrqMUYFOrHqtuT6dU=;
 b=fhO9353cBlATLT1bomBCtD9kpC/iSf9pibsx5GQoN14LBMzXJIJ1VSrlLFmOkiQlFCS50wneDjnbUAQG6j4W2f8h/umWPw8ev6uJn9AAhQul6bPHIxNwxcqfh14Qsce7irWxhdeo88e3KRKVy6QNclwUWmFfcKYtNlBpjfDyXHlDQBgwWw+pDPmZvNZf6wIawkOyjNF7OYEJD1Jaecig5rVzoYee9Gt/w2SXyUR7l3f4HoPxm4YjHO40ctKCbrQP9/y5O03M2MH64ctW26xXLKyCbx7Q/KYug4PxhiqftFn8Yu3d/+Avp3Lcxe/ksOifb0js1kQyS1sS9p356zXxfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS4PPF31CEE2CEC.namprd11.prod.outlook.com (2603:10b6:f:fc02::1c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.13; Thu, 28 Aug
 2025 19:14:24 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9052.014; Thu, 28 Aug 2025
 19:14:24 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"seanjc@google.com" <seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Thread-Topic: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Thread-Index: AQHcFuZhH5ivTN1080yMH+cPgFIX9bR3YNiAgABAzwCAANB5gA==
Date: Thu, 28 Aug 2025 19:14:24 +0000
Message-ID: <128a19f38bb532a91cfe23b7a7512bb883b276cd.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-9-seanjc@google.com>
	 <afacb9fb28259d154c0a6a9d30089b7bb057cd61.camel@intel.com>
	 <aK/7rgrUdC2cBiYd@yzhao56-desk.sh.intel.com>
In-Reply-To: <aK/7rgrUdC2cBiYd@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS4PPF31CEE2CEC:EE_
x-ms-office365-filtering-correlation-id: 9ee69093-60a7-49eb-3a88-08dde66719ac
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YXVZTmxNOVJjMXZjaXZaNjFablRDUGxaUUd4UFRNMkFnczkxS0k5VGcxQVRE?=
 =?utf-8?B?WS9YdURFd0pVZ3VwNXpBSnlxMENFdm51RjFPbG9PWU9ReHF1UWpJdHBsaDg3?=
 =?utf-8?B?S1E5M3g5WFZoc3FOYUN0Umx5QWZqWWNsTnJWOW8vS2lUcmdoaGJRQVR0N3pK?=
 =?utf-8?B?VmZNL0MwbGEzUXhoYitPT08yTFNVdEVPTG9LaHR2aDEzZ1ZZNXFJY2xuaDJ3?=
 =?utf-8?B?TWxlRSt2NjduUmZ6eGhwVmJkNm1jWlFmdjh4U1RSS3pHRjV4S21xQTRBY0wy?=
 =?utf-8?B?bEZXNDgrY0RvbE93UGpLZkI4a2Z3b2VzMjZqNW1NdkFMUmJ1NG5kbnVqUHBs?=
 =?utf-8?B?M3RmVW8vTU5iMFFxMHU5RmNtY1ZlRmp0S3VuV01PUkFLMFZiNkhOeVpPRXdi?=
 =?utf-8?B?eHVjdk5RYmtaSFEvY1ZvTFhCcTc0d1dEQTkvTytqVmJlRE9BSkFmMW4zRVd0?=
 =?utf-8?B?MXE2NjdnMmhJNGR1akdMVnVic3pKTk1IREZhQWxGQS9DSHhzdUhsbEUvWm9v?=
 =?utf-8?B?aWFjNGRnWDV4MUNyOHVRSjBaZjR6VlYyb2JqcytBcmxtMGpxTTU2UXhWeDFZ?=
 =?utf-8?B?a3hHOEljaExBRkZiQ0pwSDF4NmNJVThXOGVvNU13KzBUdkMwUXlUZW5oRGpT?=
 =?utf-8?B?dS9qNWdCR2VGL0MxckhuZU51d09DaENzNWVad1hVTXlyeUdGV2t2TjRncFQ3?=
 =?utf-8?B?VGFDaTJQRFBBdXJmVVRUN1VkL0dUY1JkcExJaU9hQkhkZkROQUVGMlJQYStp?=
 =?utf-8?B?QnE5SnhRbGw5RXUzWVNNcVdRaWhSZERCenRLY004M3VRbklpYlJJUy9RREZQ?=
 =?utf-8?B?VEZnNVZWcGd1KzNaZTB4QnAxcmpuMlZ5K1FBeTA2MVBKU2w2MVU5VHBnUncy?=
 =?utf-8?B?RWJTaDBIQUJ4L2ZzY2E4SGllLzV3S3IxQXZCTFArQ0p3ZHRQVkVxRkdhWFVJ?=
 =?utf-8?B?WWJkc1VqTUI3RzVPRENpK1laYUF4aXZCN0xuVEgyRHIvMWtKdlpFNmkrdklC?=
 =?utf-8?B?ZEdjUzFLYis4dk8wbFBEOTFoYjdDcys5YzRjNHh4NGxPQnBwYW9La3ZpSnU5?=
 =?utf-8?B?N21kOW03RjhNSzRBb0hVV05iZkxyZUIrdC9LaXRHVTBlWlUwWFl1V0prT2I1?=
 =?utf-8?B?bk90d3ZYN254TjkvdFRCSE5TbWM3cThTNzlVWDlvRXVpZHBxS0plbEZjdlF6?=
 =?utf-8?B?YkRzcVZZWERYeWlWRTRVdFlBZXY0T1p3akdIVGpTR2piU1Z5VXhYdFhzMXdl?=
 =?utf-8?B?b2NRc3ZoZ2Y0ZzNuK0RwbmVyYmJvS1NodlFpOWNQRXV3cTJjdXBlT2N3ZnBq?=
 =?utf-8?B?bDh2eXBNdWVBZy9Ha1k5cUxDazRlWkhOU1pxSXNXVEhPK1FhWldHcGc1MGQ4?=
 =?utf-8?B?bUcxS1IyNUxjOTR2RHpnVHJSVXdtTlE2NmhyS0g3RHJhUVpHMk4yNXNxRG9s?=
 =?utf-8?B?THZSZzM2NUFqZU1wYmwrbnhHNm43WG9IVU1UM0NSUG9KQjZ2T0FlTUI0emVa?=
 =?utf-8?B?bFUwWHV2amNWTDR4NnBFeW1kb0pQbWY4TXM2YVBCNHJ3OGdKTVNpdlg5OUxv?=
 =?utf-8?B?UUJPU1A5NEJoa0xCR0twRU1CU0pReTlHTEtJRjczeWx2elRsOW9sZzFYaHpa?=
 =?utf-8?B?bWFyK3NITTB1SVlQZ1VGMDBpQktOWlM5OTgzSHlVelVWY3hrbHBDcDZjWE5H?=
 =?utf-8?B?U1BkclFRWjRUdU1NSnBkT1dmMWw0cmJDbEsxdDJaNE5GamdVSERyWTZXV3dl?=
 =?utf-8?B?T3FZNTJycmFIa1B5YmRWcVNmVnd5TFJYYzJ2VDJZV0Z4ZzZqd0c5MjBmejVY?=
 =?utf-8?B?RHFnUkxqb0pGY1VZVmNINW1sYkJLRXlPVlhnMXpFZ2xlYUZqbEhHWEppcitt?=
 =?utf-8?B?L2lxV09Qam8rd2pyL0lsekpvME83SW1VaExoVUFoR0FIbW9BdkpZZlFmd2t4?=
 =?utf-8?B?aDFBdGZQY25wYXhZR2liTzJTVU51L3lEQTJ1aVFTckthN05rWjNMRFdUYXZq?=
 =?utf-8?B?Z2xjbUdZWmFRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0QrWHhtTE9vaUxWeFZXQmpScnR6ZXl1bjEvbCttUGNKeXplUGV4eFJjZDNJ?=
 =?utf-8?B?MnpiUmpHdUcwbXFmL2t2MjVIUVVhZHYrQ2h5STBYeWNaYit6MWl1UjZLVjBj?=
 =?utf-8?B?S2IydXBlVXJUVy9oeTVNMGpNeUJiQjdHQ2RUcWZBd2NHZmF1NUFONnNHN0lh?=
 =?utf-8?B?eEs0cko1Tzd2RmZwejhlcjgyTkhXbXJ3R1RNTFpOV0UvN1dBS2pVazZvc3Iz?=
 =?utf-8?B?MjVva2c1SUF6SVUwQmVRNDBlOVJ5ZlE2ZWplaXI2a0xleFNHUXIwNFlUcFdK?=
 =?utf-8?B?S0tMdU01NXkzTHJ0M2JQYjBNSExVWFhRcWdNTm5OZDhRMTNhZmxPS3BWaGoz?=
 =?utf-8?B?cHJVVlc0UDVKTCtEZlVMa0xKS3N5Q0NyQ0hVaXczc3FmNnNUb2R2VUd5YVZW?=
 =?utf-8?B?NDZ4V2pTK2l2a0NHYVVSQllVZGp3Z2JqZ1c0N2ZsalYwVFBSMEViWXdEMTRP?=
 =?utf-8?B?N2RLRDZYMjY0TUpsUVB2SGlaclRib0RvcDRPQUZUcER1TWhRY1Y5Ti90QjBN?=
 =?utf-8?B?NmZkRHN5UXZnZ0JtdFpKODNLLzBYOFJpNDlYUGRWb0FqYWhYeFBwSHlzK1lT?=
 =?utf-8?B?cVBveVZWVGdKZDZMbG95ZnZ3eWIzTSszUXBiRjJZaHBUUUxtWndObUlWR2xB?=
 =?utf-8?B?dVBkZzZiYjlaTGtOTmJzUzZNZzRQeUFma0FXbHAzRFJHL2NwdCt3ekl3bXZq?=
 =?utf-8?B?YW43VmFWeVA3czdSclJPU3FlTnBqMzJNTHp6YmtlajJJQ3MyUnBTOWZvRElB?=
 =?utf-8?B?anRSalh6VWdLNmdQNVNkeWFlYk5Jak5nYWErWnVTN0swSXVLWFZWYXlYQXlH?=
 =?utf-8?B?MURsT1ZLMUtqSmpHcTdicTdQZENZY1F3NnlQMUhVMmtrV0NDbTlsR1JBN2NJ?=
 =?utf-8?B?Mkp1SzFIMkEvT1poVDVpaTIvYktWWmNBeWJ1cW56ZlBpMGFIK09jVjdZemRZ?=
 =?utf-8?B?QzBjU0JlQVZiV1FWK0FNSVBES21NL2dOZXNiVDk4N2VoN3hhVGlzRnVvWHhv?=
 =?utf-8?B?YVdhaHdqZ3czU3VqOUpPdUtGS3o1cWJRczRxZUdydURoRTZseHRaS3dsNU12?=
 =?utf-8?B?QzRUTUlacVFmdVV6R29LRmRENHdqMlJBeUF1a2pXZkI5TURZdnhReWpiRHFs?=
 =?utf-8?B?VklJTENENnNBWFpCdXRmSkkzdmtDNWhNejJLUXJ0aHZlZEdIRTBxNTg3WDAy?=
 =?utf-8?B?aWNQbFd0T0tNZ25NQkRQeVVPTlVJandiNjhLMHVkZU5XNmxsbmUwVlNtTUZC?=
 =?utf-8?B?L01zMzE2U0tsTzhaM0ZTaFkvQUpJRURsTnU2NWMwbURNQ0wwYW1LbGJEQVZ0?=
 =?utf-8?B?M3NlMDdhWTdPZGdwbXBwbTM4OUZBb0d1TmQrY2Mzc0xqeXUweTU0TmxRa20r?=
 =?utf-8?B?OUUrMThYZlRJNlJvSjNwT1dNWFp1SmJVaDcvWVlydk1aYlNqbnNObzBVbWxy?=
 =?utf-8?B?UnlndHNtY09xeWNlQ0JwR3FLb1crSjF5TVpjSW9GRTJzWG9YNGZvWEZxRllu?=
 =?utf-8?B?NTBSMUVubmxOcTRjS25ueHA3UXRYdm12WTh0REpTMHBUazFzcjhNMm9uOEJq?=
 =?utf-8?B?ZDBhQk80bFlOampCVVZBcDVyUWN3ZitZL1FxMzRZVXZZS1NiU3BPZVBldCtv?=
 =?utf-8?B?ODgxSjgySGV1SmNpTGQra2tta3YrdUdOWXdxd2JZTFVTYmU2bitDQ2J4dElB?=
 =?utf-8?B?cnQ5NmVrTUgzbXRlTFZ4TVZkcE10RlZuWm80Y2JGWkF3K2o1VkVsdlRIMHpL?=
 =?utf-8?B?aU0xMnhyWGJ2OTU5R3pxQVFZcVQ1TlZMVXpsZGtyeWd1SDVQQ01zaGVzS01t?=
 =?utf-8?B?a1BQL2RVY3lJUlZVNkplcERHQnlQSDZ4MG5xUlhzcSswU2dSbXM1cjc4TDYx?=
 =?utf-8?B?b3BMeStSSVpTU0l5Q0VlZXJJbjB4djY4OVFLaUsybkRraGtTZEFZK2NFbzNJ?=
 =?utf-8?B?WkY5WURZeDhUR29oQUZ0cHFNUzZaUG40YStwVGo1TkxOSlNPUEE1b3dLRVRX?=
 =?utf-8?B?U096VCs0Z3NrQ09XMXIxWXI2UXp6UXRuTHNsTWNUcFdUYTFDTnRLUTRIRXhW?=
 =?utf-8?B?N0V5d0JlSzEvTXRWdXpuODV5QzY5Q1lXOE02d0tIdzhXVDlCRHk1ZXYrVzAy?=
 =?utf-8?B?c0p5d3JYTmtQUUpxdkN5YWRiZmVnekd5Nno3QmhPUmNmYThTL2VCVXNmNGI1?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAC5AD3BFAD4394CA25260139DD7FDB7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee69093-60a7-49eb-3a88-08dde66719ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 19:14:24.2973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GAJIRxN9S8bnI2z9suAwVRdqthjRh0mLYPSz3W4PF+D+xk7oMwYalfqc6TnvX/RcgaYgPfZVUnRow9I92k8coId2yIVhJtuVEpsyf8tkGCk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF31CEE2CEC
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA4LTI4IGF0IDE0OjQ4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSG1t
LCBJIHN0aWxsIHRoaW5rIGl0J3Mgc2FmZXIgdG8ga2VlcCB0aGUgbnJfcHJlbWFwcGVkIHRvIGRl
dGVjdCBhbnkgdW5leHBlY3RlZA0KPiBjb2RlIGNoYW5nZS4NCg0KV2hlbiBJIGNoZWNraW5nIHBh
dGNoIDYgSSBzYXcgaG93IG1hbnkgbW9yZSBLVk1fQlVHX09OKClzIHdlIGVuZGVkIHVwIHdpdGgg
aW4NClREWCBjb2RlIGNvbXBhcmVkIHRvIHRoZSByZXN0IG9mIEtWTS4gKGV2ZW4gYWZ0ZXIgd2Ug
ZHJvcHBlZCBhIGJ1bmNoIGR1cmluZw0KZGV2ZWxvcG1lbnQpIFdlIGhhdmUgdG8gZGlmZmVyZW50
aWF0ZSBmcm9tIGdvb2Qgc2FmZXR5LCBhbmQgInNhZmV0eSIgdGhhdCBpcw0KcmVhbGx5IGp1c3Qg
cHJvcHBpbmcgdXAgYnJpdHRsZSBjb2RlLiBFYWNoIEtWTV9CVUdfT04oKSBpcyBhIGhpbnQgdGhh
dCB0aGVyZQ0KbWlnaHQgYmUgZGVzaWduIGlzc3Vlcy4NCg==

