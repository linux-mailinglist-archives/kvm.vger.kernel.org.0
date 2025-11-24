Return-Path: <kvm+bounces-64408-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DE4C819F3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:41:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F24004E2631
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:41:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA7729E10B;
	Mon, 24 Nov 2025 16:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="hK9o6dwO"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013007.outbound.protection.outlook.com [40.93.201.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95FAA29B766;
	Mon, 24 Nov 2025 16:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764002459; cv=fail; b=Kdm7JXN7SFgsUr/uIB2W6pBxkkwSVgxS6Tr74kaKum+60L8vqhMwJ7zC7dnkSybYCnzSvtaugXRx92ZkBkk8UNFYB+pl9PV6DV+Ik8Wc770qF1EpzRUSc39cPaWANFboOpa/ji5rpwdTzuKcQkf4zgEdQaQ1ohA/NxftJkRgQv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764002459; c=relaxed/simple;
	bh=EKrs54fi59zD3hm36OKEOiHq0DTh5182Lqa83+Qmz8o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HlY6/tcDJcsQOfwA9pb7DzpaIBfzhhd5/7I3oHQp91eBlmG6B/XAUlkNs3q9YIssdMDQn5Ipf+0czGjTQWzw4w2Yx4TarEDfNSOCE5KkdxxISbAfSWO7jIu29ahLi8tkD4r3zigDZss4OEmkQZwi157E4a1ivAZYA2CNtV4oLVs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=citrix.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=hK9o6dwO; arc=fail smtp.client-ip=40.93.201.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=citrix.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pgwNE1YZDaDq9XcoaJLofKf0ODRUe86Dhh7deGtcnT7yu9qW7u+NjwsXFLuvg6xlhZk7VNzBck/NKYrBFfqtBLWhONSA2aUMqipz8mRx4i/SQ7DVSe86sPdao2d8WEC2Lg1w1EnuZ1H8aPRouk3nNw02BfnkHZq6b0ygp+DPs9aygEbscFZj92PAccNjM3VpcLqihPLeK1dqy7qRRaXnhBzXJ6lO9LtRRCSCih4M39OXvslBAHaQ/BsXIlj5vTkWsp3887q9JMDWxIe/NkJlX5LUpzyVP6njpzTMnKdafw4ZGENIy2FYuk8D9GPWnVZMM++1gS94q2vSKwF8ptB7uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xQBxBRDYz/do2M0rAuaUQNoF4vvVKUd0l3vRRfGZY3o=;
 b=bJswOFyms23Wp+ihOXp8qxm0Pfu+LvM0BEDkPU/AQpOe7KOqg/R5nKZ/N5pA27+ZgZS+366PD1h8+BetuZUW8glpe8lt19r8e3i+8pf2TfSYC7aEJOtzC0lljcZO67DJa5r1NQc+Tt66dDjlxRQIVvA8YBduCJrzLQFno3+XlW2sO1tgwioUFEehKb1qZllSMSvUtGuCfHqRkd2GPSlmzG+TgMgsJg/9uV0IrhXsPPoWnALvYUrfW7kWRS2FSnfbqP+5XNMEv90sCoex7HRvbSheg0vDakwipKm0Oo7RnT/n+0fBm2h+ZOfSkOYtwVpS9sSbc/e+AOlrdAxMQAuO9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=citrix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xQBxBRDYz/do2M0rAuaUQNoF4vvVKUd0l3vRRfGZY3o=;
 b=hK9o6dwOnjeL0HALpyc+TSZNoYMo5Mlsd84JASBSqJUW+IQXXP7t9V3rYXr/hpOak63JcmkcvEuNKUrS30ivTdYCBqYCBd8YJzQXW96HmP++kb8iQeKyNchk8napvWVTnkU9tObf1DSXzWkNkprzDDHRKp82fxR3axTQP3Vy0DA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from CH8PR03MB8275.namprd03.prod.outlook.com (2603:10b6:610:2b9::7)
 by LV3PR03MB7429.namprd03.prod.outlook.com (2603:10b6:408:1a0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 16:40:54 +0000
Received: from CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8]) by CH8PR03MB8275.namprd03.prod.outlook.com
 ([fe80::b334:94c2:4965:89b8%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 16:40:54 +0000
Message-ID: <4102ede9-4bf7-4c0a-a303-5ed4d9cca762@citrix.com>
Date: Mon, 24 Nov 2025 16:40:48 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/1] x86: kvm: svm: set up ERAPS support for guests
To: "Shah, Amit" <Amit.Shah@amd.com>, "seanjc@google.com" <seanjc@google.com>
Cc: "corbet@lwn.net" <corbet@lwn.net>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "kai.huang@intel.com" <kai.huang@intel.com>,
 "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
 <dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "Moger, Babu"
 <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
 <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
 "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
 "Kaplan, David" <David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
References: <20251107093239.67012-1-amit@kernel.org>
 <20251107093239.67012-2-amit@kernel.org> <aR913X8EqO6meCqa@google.com>
 <db6a57eb67620d1b41d702baf16142669cc26e5c.camel@amd.com>
Content-Language: en-GB
From: Andrew Cooper <andrew.cooper3@citrix.com>
In-Reply-To: <db6a57eb67620d1b41d702baf16142669cc26e5c.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0079.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::19) To CH8PR03MB8275.namprd03.prod.outlook.com
 (2603:10b6:610:2b9::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH8PR03MB8275:EE_|LV3PR03MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: e7dd82b2-9854-4e3d-e347-08de2b783c49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzdHMGI5dWszUmpkR1greEVRb1F2WmJYdnI0NVljZWIvUnpqeDRzcXhGMXo1?=
 =?utf-8?B?WDg3angwaEtlMjkxSlpJaDZlZDhBU1ZsYk1jaDgyWTZHRUhLSnNTS04wSW8v?=
 =?utf-8?B?eW5pWGFIU1NodGJNYndQSm1JNjZHOHplbWRSaVdBWkFQZUgxN1VnL1ZGeCsr?=
 =?utf-8?B?Qmpma0RGQm9SaUNJM0tNN21CN0owWlR4OUEzNit5bjJ6NlB4MWE5aC9LL29I?=
 =?utf-8?B?Y0hFcGNEbjV3aHgzSGs0UThvRU00MTgrT0RtblNEKzcvZkwxYXNDWXFyQjNQ?=
 =?utf-8?B?WFF4aHN0QlJvQm1tbDB6Znk1RlRwcG5PVkhZK1RKM2Mya05qUkhVb0RGa3Vj?=
 =?utf-8?B?TUtaL2N0bjFaOVpWVXE2aGRYMlVWa2d5cHhpc1k1c0ptTGpnL0x3NEZvKzc2?=
 =?utf-8?B?bGFCdzh4a1pHRnFkTWJ2bG5qTTYvZFlna2ZGcC9KU2lBTEhvaTJDMGpST2ww?=
 =?utf-8?B?SzhXWkVieHp4L2pUN3I3bjFvbFdHVFA0ZXZMSmFqZU5VbHhrV2NML0dMVnNZ?=
 =?utf-8?B?d09mUXM5aTlZRzI0VTlrTERqSzU1RGlwcEU1cUlOMFhSVi94MDBtR05RTmUw?=
 =?utf-8?B?aG4yaEt0ZGF6UjVRUlZuMFlPWGNEMWVoVUFYbllsT3lpZ0pobmxjakM1RDJs?=
 =?utf-8?B?VnVVaFZEVmJWNjZoTmxkVGRNa2tpVHF5NlE4YnBicHpMZDc3K3N1OUxtK0tu?=
 =?utf-8?B?NGZyWEkwK2o2aUwxTXBPa2g4Ym11UDRlODBTQnZtZEJ5Z2tkMERQUVVxRWp1?=
 =?utf-8?B?NUVXOWZUUWY2RTYxWFBlU0FNYW01RkR4cVRVZ0pONUxZbGRZQm5ZblpEdnJh?=
 =?utf-8?B?eDB6a3F3REJJOTFzQ21DeENDdG9uMUlVVW1BbW50YUEvYzFQQnpXSHVLZEp0?=
 =?utf-8?B?THh6OS9Ga1MybmRwcHJYZ28xa1FnNmhtbzVuZzlLbllxNTQwYUVHd0Q3NitY?=
 =?utf-8?B?M3RFcXF2QTU5NkhtVWltVFdsMnVLbm9MTUVlMXM3WHh3UUdMQ2x6Z1d5cU9D?=
 =?utf-8?B?ZU5Eemt3UGcxNjlsNWh5dVpJUVJBRE5kcVJ4dkRkQjVUSE9YdWowelJPNlN1?=
 =?utf-8?B?eFcrV25VcUhrYUpOSHJYdTNPQVErYzdab2FpSm9tZTBzTDRvbERDUFlsbUcw?=
 =?utf-8?B?UnFxa3RrbGZvRGFRNU9haUVvZXRuam5NZ29tS0FRZXZ4VlE4U09FQXJ4RWtH?=
 =?utf-8?B?NjFldEZXejFzUzFiTDNGazE5MFo5MHprSlV3dUE2bWtXUVQ0dks0bzZGMXND?=
 =?utf-8?B?bHBrZDFsdjhFaFZuQjZuTFhaK0g5Q1FhbHZKOXlFUEhDNWYrOGROYnJnMDJ5?=
 =?utf-8?B?cGN2U0FZT3ZRNUFQMkdKNGpWTDNkaDN6UldMU0lrSXc1dU90VnozbDBGVGVi?=
 =?utf-8?B?Mlh4QmdoMHFLeXN0NTdmY1NWTkhwYUJxUC95VlpXa1RLTWk3Y3dyUzUvT083?=
 =?utf-8?B?VmxFYTBnWW1DUmRJM0k5V2Q4NW0yenBHVTJSZWhWSGoyVmJKRFRiU0RYSnJ2?=
 =?utf-8?B?bHIrTGdhMjNZOUh5STRqamxRU3RNRXpiQnZVR2lxMVN0ZmQzRERvY3FVeHVq?=
 =?utf-8?B?UnpsNDBIMjB1ZURhdW5Mbms5YURQSGhHQmxGdURpeG4vSyttTzlUdHVTSjFI?=
 =?utf-8?B?SEg3Ykl2SU96ZDh3SHp3TkxnY0NoYlhHaXFxWDZwL2NDUzJ2NFBKTUk2YlQx?=
 =?utf-8?B?MjZEcnRrWFc0MjhaVGtMaExoM1MvYVl3b2x3WmVvOXl3R1RuZjVXUXJkZUN1?=
 =?utf-8?B?TVpWSEUwMmthYVRSaGxrL3kycnNjeCtnbytWcTJoWGJ0UTVmT3dFdGFrcUt1?=
 =?utf-8?B?Sml2QU81ZUxmYktydkM5OThVQUd6Yy9uN1paQmpHSXU4aFhMQXpzV1BoaUxv?=
 =?utf-8?B?WUFpUjA0L3IyamdTNXlnRFpNUjVqVlB4ejdHNWxNS0FoczJBMWs4ZGRZcmhG?=
 =?utf-8?Q?frmxmkApgIe6nS8+LxxSbefiFqLd67o/?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR03MB8275.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NEFOSVpqRjhxc2dTSHRKZ2JaRkN4cW5idDBYa3Bkcnp4YnY4YUdVNVNpNVQy?=
 =?utf-8?B?dzlZWDBmZDN6RlRxSjdnNkVLNTJxaUlzZ3dvYllMZUQ1d3BVVC9oYnN5THB2?=
 =?utf-8?B?TnZlYzQ0WmhjR2c0NGUwM3l2SHFKMkEwY3lKRTlnOWw5U1NFUlAxNDBVeGw4?=
 =?utf-8?B?WnF6dW1SbjJoeUY4MDZDWDVXbHhlWUlYRU1hVFdrZ2ZhUW9MYndXczNONVJ2?=
 =?utf-8?B?MncyVDNpSlo4S0NuTXJZYTFzemNCeGRuSno5QXRQdnFDVFN1RUlmbzhsT1c4?=
 =?utf-8?B?TFZNMEpvby9FcENaNnlCTk1ZZk5TZkRjL1Y3d25oMXBiTjNQUldqTXVuVEdC?=
 =?utf-8?B?L2V2aFdSV01SdjFTT3J2WTNQVi9PbEFDdk1QUFBjSmVGQzdQN2ZlRm5GRUtm?=
 =?utf-8?B?akxyS2g5ZVkySFo2VS9ZaE1VODFEbi9EOG56ckZ3QlpvMWhZTjlyV2M5cUxL?=
 =?utf-8?B?VXlpNWlnTGYwQnBLSzZaTzYreHJScnBPY0I2QzFvYUVDbEI0RUFMQkJsZEZn?=
 =?utf-8?B?NkFhdTVPckoxVnV4QjZZbzJXWGRYK2lxaGRzVXM0clFxT2JNUmZPVXgvNHR6?=
 =?utf-8?B?ZC9XYTkwajFEc3FzL1NrbGIyQ0hvbmMwWXdwUUhONlk0NTRzS3hoK0JnQkFt?=
 =?utf-8?B?TDRwT21wR1Q1b1o3N29QS1UreC9PeTJ2WjBHWWtyanFRTDUrT2F3RUtUS2tZ?=
 =?utf-8?B?VnFBYnEvdkJJMFNCSGoxMFMrWTlJZk1maHhHbUtMeGFjM2E1UkQxMnlzZHFS?=
 =?utf-8?B?QU00STdEK3RYQ21yMFgxNEtTOXo3b0xSRjNqWTRWaHIvN3RUekhUTHZYcGNv?=
 =?utf-8?B?UXVFR3V6K0JXYXFmTW9nQ0xWeW45UDFuNlJqZ2JYZlhCb2R6aEZqOERoZFhS?=
 =?utf-8?B?QUlTR0pQZDhtaUJDTGl2MXJrY0phdk00RmEyZStXR2ZkZGE5R2FQQWxWR2Y3?=
 =?utf-8?B?a0haYnZDS2ptY1ZxVGJ3a3E3TFVONGtyQW0xc1hUS05UVTVFcWE2bU4rZEt1?=
 =?utf-8?B?TGhORlBCa2pqQ3BVaUNmSm9SNHE1SE9EV3c3eXp6N0pXRXF4VG9jbk9xNDUv?=
 =?utf-8?B?MEp3M2N6T1gxNlNML0hmbTg0aGxXNHhaVmxjakprTS9GbGdRalU5cjlheW5m?=
 =?utf-8?B?TFR2SElIZEJjS0c1ZW5mVWd5ejY1LzdqT1ZGSzhjQTlaTFYwaXZNN1VkL0dv?=
 =?utf-8?B?VllwcGlrVXZhTmtDZTVTeGdaMHEwUytrVWNCeG1icktNaURhSWJGaDdLcU43?=
 =?utf-8?B?YWFPZ2tLdDdxb1FnTm02cmU3V3dySHNVcmVienFmZ2d5TnpkelNPdk9oVytW?=
 =?utf-8?B?VDVIVVdqZHo2Tm4zMkJVMCtzbkl2emFPa0hSNG91UXlxQTUzcFlwc0p0UmtU?=
 =?utf-8?B?K1crdWhFeXV4dUd0M2VHaEhjekFWYkRrWUVDUmJlSXFSOVczcnNTbEtOdjJB?=
 =?utf-8?B?OFpJMTE1WmFONnpkZXBPRklFWFY0LzN0YzI4T084d2xET1AzUGU4ZXRqTHhQ?=
 =?utf-8?B?Q1NLV040aU9TRzFOcVNIR2QzZnZSUUtTYitKWVRrUTRoMG5KYS85ZkVjdU5B?=
 =?utf-8?B?TGorU3daS0c1Um90TXl6cDVhczRTK1liTXZCS2o2RjY3YURSU2ZyRlBFVmdl?=
 =?utf-8?B?RXJ1d1VFdkl5bmZOZ2kyeXBuS2lmcitNRDFHRzZSeS9nVzFZVHRsYVBtaUVS?=
 =?utf-8?B?N21vRkpXdHB1ZGh2RkxHK0MxRXNqTDdGL1MrTGs4S3R5UW90ekhrRkRDblcr?=
 =?utf-8?B?aEE2a0VHOFJ1TkROTnB4SnIvbGNHSzA3VnRzdEhyU3NSQkd0WVNKUUtST2ov?=
 =?utf-8?B?TmJ6ZlFjUWN3UmFWeE9IV1YwWTJyZEVuckJydjVydXJOR0tETmJldWxKaTJx?=
 =?utf-8?B?d1dXekVSNEI0YWQvdkJqOVF4NEQwc1VaV01sbU43NjVhZ2lpaVhKRi9Oazlo?=
 =?utf-8?B?WXZVcU1QenE5RjQ4cVRJbk5KUkdvMkpLdEw0MFVtcUhWc0o4RlJrZ1ZmYU1n?=
 =?utf-8?B?T3RrdFlIZ3dlRXVyekpid3hVeTZwWFQ0TDZadkk0RFh4RGZMOVFzZmVyRjlZ?=
 =?utf-8?B?cTR6bzJNQzR2RkRFa1Q5VFlONWg5K21adXFrTXJCbEVZR01PSjF3UlRTTndX?=
 =?utf-8?B?YjIrMytiS2tlTlV3Q3lwVjQvU0xZZUd0M2U1TkdiSzdYWGwvOFNkWlNuVjc2?=
 =?utf-8?B?SlE9PQ==?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7dd82b2-9854-4e3d-e347-08de2b783c49
X-MS-Exchange-CrossTenant-AuthSource: CH8PR03MB8275.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 16:40:54.2353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xty/61bpKJsvJn+uylnnG5WZXEQcgKtNqoMNcDxu7Z3zXUc5797qcJImuHJakp7ku/5Ch0qMf3YAjm6hWYmGYR8uSgx1/PKNSJSWxwVkvq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR03MB7429

On 24/11/2025 4:15 pm, Shah, Amit wrote:
> On Thu, 2025-11-20 at 12:11 -0800, Sean Christopherson wrote:
>>> 2. Hosts that disable NPT: the ERAPS feature flushes the RSB
>>> entries on
>>>    several conditions, including CR3 updates.  Emulating hardware
>>>    behaviour on RSB flushes is not worth the effort for NPT=off
>>> case,
>>>    nor is it worthwhile to enumerate and emulate every trigger the
>>>    hardware uses to flush RSB entries.  Instead of identifying and
>>>    replicating RSB flushes that hardware would have performed had
>>> NPT
>>>    been ON, do not let NPT=off VMs use the ERAPS features.
>> The emulation requirements are not limited to shadow paging.  From
>> the APM:
>>
>>   The ERAPS feature eliminates the need to execute CALL instructions
>> to clear
>>   the return address predictor in most cases. On processors that
>> support ERAPS,
>>   return addresses from CALL instructions executed in host mode are
>> not used in
>>   guest mode, and vice versa. Additionally, the return address
>> predictor is
>>   cleared in all cases when the TLB is implicitly invalidated (see
>> Section 5.5.3 “TLB
>>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>   Management,” on page 159) and in the following cases:
>>
>>   • MOV CR3 instruction
>>   • INVPCID other than single address invalidation (operation type 0)
>>
>> Yes, KVM only intercepts MOV CR3 and INVPCID when NPT is disabled (or
>> INVPCID is
>> unsupported per guest CPUID), but that is an implementation detail,
>> the instructions
>> are still reachable via emulator, and KVM needs to emulate implicit
>> TLB flush
>> behavior.
>>
>> So punting on emulating RAP clearing because it's too hard is not an
>> option.  And
>> AFAICT, it's not even that hard.
> I didn't mean on punting it in the "it's too hard" sense, but in the
> sense that we don't know all the details of when hardware decides to do
> a flush; and even if triggers are mentioned in this APM today, future
> changes to microcode or APM docs might reveal more triggers that we
> need to emulate and account for.  There's no way to track such changes,
> so my thinking is that we should be conservative and not assume
> anything.

But this *is* the problem.  The APM says that OSes can depend on this
property for safety, and does not provide enough information for
Hypervisors to make it safe.

ERAPS is a bad spec.  It should not have gotten out of the door.

A better spec would say "clears the RAP on any MOV to CR3" and nothing else.

The fact that it might happen microarchitecturally in other cases
doesn't matter; what matters is what OSes can architecturally depend on,
and right now that that explicitly includes "unspecified cases in NDA
documents".

~Andrew

