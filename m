Return-Path: <kvm+bounces-56628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4728EB40D69
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 20:56:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A966F1894560
	for <lists+kvm@lfdr.de>; Tue,  2 Sep 2025 18:56:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C90C342CA5;
	Tue,  2 Sep 2025 18:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ITCI/szw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995E2DF15E;
	Tue,  2 Sep 2025 18:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756839356; cv=fail; b=g6FNfFpajp8P2OG+7C7kSiTFgEPgG68MDbydOoKFf7ijWLz7kid13sq+jWEez9oQS3mEA0vxah4nWCzTznLXRf2Wx/Ckz2SMQ4h3xRqYxlQRB6ekjyXQ1N44I/AeqPeGnoqY7iVpBP1IbrfvX1m05/aoM7G6JRhh+geBNBPpfcM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756839356; c=relaxed/simple;
	bh=elzNCytfXfO5wx4Hrjv5/bKwV1hG3dx9Mlq3PUZapmE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pAF5Q1q93ru90PYz/uzKx7mMW0mW6zqFi/gj40oSVPDFLkBkMMDyJFuLZ4iG3msRA5PAUrs5VwXll2RHR90kZ5Xx2TojJ6+J4EhVHqAR8vlJyLKq6WJOlvChnq3TOSxQcA8wv6zG4h/WyfJvru4yo70UDVuHHMdlKeR2BxkGghc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ITCI/szw; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756839355; x=1788375355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=elzNCytfXfO5wx4Hrjv5/bKwV1hG3dx9Mlq3PUZapmE=;
  b=ITCI/szwfpGPfgPaeQ5WRkLj04IrWwiKhYuYrpF+GZ4aPdi1nyr3+ljC
   yXzyKWI6zokzUXphtfILGmS/hsEa/Gvhx0pc3WKXX1bsp3hrg8CB1W5Nu
   //VuD1YNxZFmmnz64ni4Q+s3JrIWJsgThKJA/DHclMaR4Jr0sxXMNHhjF
   TBL1MMEIqJ98n4TqB5esF3Jt5WlMdO77ucW272/gPj6++yGr/zKM/D+BZ
   J4JWVgQZIzXvVl54g34QRzL3oVg0dZZvvj0F63MPfaLlrVN2UUZXWEXow
   ztdqXKBBB3izxIFUKpIYVNm/MRZUnXDKvqOpcv49izG43SjKS+Lwgu6Pr
   w==;
X-CSE-ConnectionGUID: k74KBqNHSl+8qMQdti7y/g==
X-CSE-MsgGUID: 6qSt7lB0Rf6vwoIIby2fDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58987233"
X-IronPort-AV: E=Sophos;i="6.18,233,1751266800"; 
   d="scan'208";a="58987233"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 11:55:54 -0700
X-CSE-ConnectionGUID: 8vgfWD70ScSTPw5c1nQfog==
X-CSE-MsgGUID: QEUsowWUSh6jV03jKFME8g==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 11:55:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 11:55:53 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 2 Sep 2025 11:55:53 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.51) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 2 Sep 2025 11:55:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lhM2vKE9s6kPMYCoebEH1SarXWGv9pFv7lFGf/4AYu616hrnrtNLnYgJiC2dEOrgX8giy6v23RlbnH+4KM/hQnVXaVcm2J4iTO350BlqKghaj97NXSLoiLYyI+7PNecjG6aCRn5tp8KkndSmvhFgJU4x0qbXF0x4qUD/u3FORGiuBKtQHnEWQe/sQiGmaHVVce48eECNk36GCmeuzXWhgrICk32tO64JM8L4ktDR43DA/e9Sc/FCi1BcX/edraG4XsknMO57RFrbpmVlxng+i0XFt9Nt1cxX3opd0/NtZ7cEOexY+LkFTvatT/7BiPDYZbirLOgSSU6iwqQPlM3Hxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=elzNCytfXfO5wx4Hrjv5/bKwV1hG3dx9Mlq3PUZapmE=;
 b=Ibe6QKMRs1m8WiBlyFaXMGhBvaO7YYrh/r6QMF7+5hLS62j/bWvKqjGYAckjWwePb+z1B7TQF0qpqVeFbMyXcOpQ8FJP1Uk07oYzYIffWhYroeuGhXH9VFjkZHew1buU/ZhqsqTHwy7SEVG1rpI2dyZ0r+QGoaCH48APCBvW+eD9fXHhNYKkQIqlf3Z94LyyxdH+WrVYByretBG7ioanmNRz2fTMui21Hn+2FvejSwrCxiAuN9HtEOlWxSMhwR04wLh9Hp08gyHyZ96HUmgd0K+9BJcf8XQMqMuOnO8dWOzQja71mKT99JRDQlrLgQzXf2kBXg1mzDs9O6JCArR4WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SN7PR11MB7116.namprd11.prod.outlook.com (2603:10b6:806:29b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Tue, 2 Sep
 2025 18:55:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9094.015; Tue, 2 Sep 2025
 18:55:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcGHjL8dqNtw+1DUm4eDEQMXeVS7R6DDCAgAOBiYCAAqCiAIAAFxOA
Date: Tue, 2 Sep 2025 18:55:46 +0000
Message-ID: <97a422c0ba7a5d68b35b5327d3bf0cd11429c300.camel@intel.com>
References: <20250829000618.351013-1-seanjc@google.com>
	 <20250829000618.351013-6-seanjc@google.com>
	 <49c337d247940e8bd3920e5723c2fa710cd0dd83.camel@intel.com>
	 <aLT2FwlMySKVYP1i@yzhao56-desk.sh.intel.com> <aLcqVtqxrKtzziK-@google.com>
In-Reply-To: <aLcqVtqxrKtzziK-@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SN7PR11MB7116:EE_
x-ms-office365-filtering-correlation-id: c52d2786-ff91-4547-6c76-08ddea5253ad
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dVZMWFYwUWlIbkZwSFVUL0ZRcFdjY0FxR2lmNnNtU3ZZWXRGUHFaaTVMOGp1?=
 =?utf-8?B?Ym5mQk9yQURhRjZxa09BUE1jckpiT1Z6dzZWT3I4RWhUZEZteXBDaUk3QVJN?=
 =?utf-8?B?VFA4M2gyK0x2VVNQTm1ESFQ0Ti90VDFlMWVVQUllbHo1ZXd3dU42WXhtZENM?=
 =?utf-8?B?NFhVMGZUcFR5WFRBNXBpQTkxOWNuOHErbGl1RXVmZ1VYeTRLU0tsTVRwVlVX?=
 =?utf-8?B?YkR6dHRYcEVlYjBINzduSGYvMXJtWDE5L05vSzVXZzJhZEZ5OGNSTFlEMGtw?=
 =?utf-8?B?OFlYemtMUTJ3c0xMZFZUbXhwL0hMYWVTdWlwSEw1Z0Z4dVVscENBUlhyUy9G?=
 =?utf-8?B?Sk1hY0N3OGV5VTE1SlVzWjJLVG05MUQwbDk3OGZENnFVSFozQmRHaE1GSXZh?=
 =?utf-8?B?Q2NlR3BYZVRaNHQvOXlxMEVZMjJmcmkrejlxSE81c09uNTJUbWNrTzZjbk8x?=
 =?utf-8?B?bCt6Szc4RWxEZkFmSXRHZWpkVkNUdzY5ODNUVW9aVkFxV2NDdkdqMmpCM2I5?=
 =?utf-8?B?MTFKM0NydEczYlRGRnAvdDI1MzF2Z3JOSCtpOHBqL3hQZnhmbDEvS3NqVXU3?=
 =?utf-8?B?NDVnWTdPUUNwN1ZKVzY1eDhmZmVDNE5NTDUvaDdGcEYwRjk1Q2E0b2g4VVBH?=
 =?utf-8?B?K05oYm1RNjh5VUE0VUNMZnU5dmVkWGlkbmpxcFdJSGQzVDJTZndoRGlBYWpW?=
 =?utf-8?B?TDNVOGNIbnpTdCtJUDNWakdFRHRSeHdwYkF3VTVCSU5TQk5NOFZuVXNrdExX?=
 =?utf-8?B?S3R0OC8wSVZUQTROdmNIclR6MFNNWHZHRkVDd0tGcFJaWWVIRU1aZ2wyVmJs?=
 =?utf-8?B?MjJ0bFRJdnVIQUJMaUR0eFZlaHpzc2NmQ0JOdTdsb1JFTDFUWGorZ0x5eUhn?=
 =?utf-8?B?YzBjcWNJdnBTV3VlYmxKOFlqMnMvVXVaUGllckpqREUyd1hxT0huMTBWdFNR?=
 =?utf-8?B?V2I5c2l5bWdoZHZSR0hTQ2RxUmZMZEpQcGUydUF6dE1HV1ZuRVJseFl5Vm5W?=
 =?utf-8?B?UHFOdVpDS3ZNeEcxejhPRWVMRDdnWXdyaHUyL0hIcDQ5Qm1YQXQ4YnA3R09V?=
 =?utf-8?B?NnV3dmVjMlF0RTBqQVNESEdMa1RmQzBGT3pRL2lIcThuV0NNQTdLNmxSZlBz?=
 =?utf-8?B?NThHMWJkcnBSY3I0TFQ4NVJJRFl2UWdTZGdVRjYwWDhSNGFCSFpZNUF6S21o?=
 =?utf-8?B?T1hoYWk4dDZ0V2tzUEdBalJhWUJ0eGowR0dOY20zRFVxU284NHo4Y0JEVG9X?=
 =?utf-8?B?QkVidHhFd21ETFVpcmVOVG83K3B4djU5czRsaE9qL1NVU3pRZzgybUlIdlc2?=
 =?utf-8?B?RjN5aE9DMU1pK1NwUis3U2lJMy9Ma3FUSDFwakFwOFcrMkp4cTA3TXBGam80?=
 =?utf-8?B?RHc0Y2kxMU1FZE1mZHVNaXp2NHIybG1SZW9TZTJ2dk9RRmRMVUxjLy9memNi?=
 =?utf-8?B?bE1VK2srUWM0UXpRTndLVHBtU1hhaWIrenJFOHFYNlhwVWZSczVOSS9HTVFC?=
 =?utf-8?B?V0dBUVJXQWhnWCtpRXBFbXlYT1JJdEszZkVXSURqL3NGR2JLMXVybGo1cnE5?=
 =?utf-8?B?VXNqSzNmRmhHWU1mRllBMXNHNmkvMElYR1RwQUkvZ1FaOGc1R0ZqcW1oZjdE?=
 =?utf-8?B?R01KNExrczd5cVlJNzlkWWFEaFdjVlI4ZjJCMjB5RTRhNEYwaUwyQUw0L0k4?=
 =?utf-8?B?dmM4bVRTQXZRMDh1elExWmNhVG5aZ2Z6TzdXdXI3TGdxZFRUbHFZbDNPbFR1?=
 =?utf-8?B?NCtEaDlBYVhkRHNSY2tvV3RERnEwaWdmdHZiR0lhcVUyMXRtNkRSaFJscTIw?=
 =?utf-8?B?L1JMN0cvZnRlc2pPOVFGdFVFZDljWFVKQXZ0UXprbjlpcEFHdmtkNTRHQmIv?=
 =?utf-8?B?N0hDWTV4c3ZQZTVBN3FkRWc2b2Nwb1VvSit6VWNMRUpIdVQvdm1mVy8rNlJl?=
 =?utf-8?Q?Ll8RjSoyaUI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTFWcVkrQUpibGJ5MUxTR0xFc3NJTDZuSVJPK2lFcVlCMEFpS3JPSndVNGRV?=
 =?utf-8?B?SkVWSmhkbjJVb1M5VXEwbUU0RlFnSlhSUkxjYWdKbXBMcDlVWmpOaVRSMmg3?=
 =?utf-8?B?ZzNxb2x4TGZNeEg3K05hVDJScW50QTJMYUJnaXJFMTlKLytsVmtpczN5elJX?=
 =?utf-8?B?RzdUYVM0N0pFa2FaWkRNZWg0endjNThNWU1xZWYzazg5M2pTbEVkNFR0NGZn?=
 =?utf-8?B?NFIzVk9WbkljUW8rYzlwOU1vTmVHalNQMEVVV1BUQjkzZU5LZlkvNW9wdU83?=
 =?utf-8?B?TGlBblpZY3AzYkorRVEvVXk5WEdRek9aVlRXQnU1Q0dnQU1XaGEreXF4RHNh?=
 =?utf-8?B?VFNvN1JudVZZQml2cC9Uc0RtNDlnN3BjdDRNY0c5ckxBOXRPRkd2cVlzN24z?=
 =?utf-8?B?WjFSWnFyRXBqN1paeUpXcmIxY0J1dE1zajg1OWV4N1lZMHBwM284SGVwN1Av?=
 =?utf-8?B?Q0dHUW42S0g0aHdGbm1wZ0pzL3VBU3lRVkxnVmtWMnpBWmhlOS85aThNaC80?=
 =?utf-8?B?SzcrL1JXK3p3NHR0WGpiam16VEFiaVZGOEpjRFdocjdrV0tNYUg5TEk5OFdV?=
 =?utf-8?B?YXd3VlQ3dDNvV2U5S2l0ZGNhbmVya3ZuWXAxQkZuZzkrdUhCZHlCa0VLb0N4?=
 =?utf-8?B?NmQzeGkrSXgxOGw0ekF1SkJGeXJndVRMdkJhclBPQ3NBNHl0VUM0K0R1amth?=
 =?utf-8?B?OVJ3OEpSOHYyMFdIU1VFOW4zVWczSXlXMGdHZE9iWXgxZG9TRWNGR1NBZmtk?=
 =?utf-8?B?U09wbGRiczdGcEMwTTl5VFFLN0M3cmVDOWo3dmhZeE9nQ0lIVy8zYW0vR0Zk?=
 =?utf-8?B?ZDJabit5V0MwSXBxMnp5NFpTa1JyOHlEVEswbTgvMmE2QmovVk4wRldwRTNP?=
 =?utf-8?B?dTJkQ0pwRnJIR3B0UnRQeXlqaFI3ZExhalFXVHhTUlNxMm5SejNwUGVRblp4?=
 =?utf-8?B?ZXpSZlluNjFtdWdyb041SGlGcXZuQkJ1a1IvVmJNTmEwRk5CNUlPdjJuUUg4?=
 =?utf-8?B?RFhJbS9DcU8xNWZXOVRPamJnUUhPRWJPSG9vUU5hQTJHWTE0ZWNmZXI1eVBk?=
 =?utf-8?B?bGdXVUJ2MkVkaWRiMlFYa292a283NFJ5Vjh6ayt2LzdEamVrS09hUlowNXZk?=
 =?utf-8?B?YjVSK2JGTkVuMFUyUk53aktJV0JvSmtYTVdUT1Q0cFFxWVNkK1JWRE8vcTJP?=
 =?utf-8?B?SkFNbGtEUWdaanZheGNna01SelpPSHl4ZitVa2Z1eHdtcHNsRUJ6NlY2SUhP?=
 =?utf-8?B?aXhteisvYm5HSjJlRkMrRm96TC92bno5ak9ucDFUY0txb0lzSkRJdU96NnM4?=
 =?utf-8?B?N0ZpKzQyNmU1bG8ydmFBeC9TZ3J1amViOUV0SzJTL2ptQ1Q2OUdnMEV1WTcv?=
 =?utf-8?B?QUxRZStFbmhNWDI0WHFjWm1GUnNaSzdwc0FQenFlbm02bDV1UU5pdnBMVlZa?=
 =?utf-8?B?SFF3SUxOOCt1S3lwOGtVYysyQktNUm81U25YNUtWcWZweG0wUnVGNnQ5K1ZX?=
 =?utf-8?B?cHVZTWQxcDRBcm4wWS9tWlh3bHp2SUx2OUtlOWQ3L1l1NDUzbzlxSCs0cUk1?=
 =?utf-8?B?Zlc5aDJnK0NYMVR1dnFpRTZzZURwYkFoQzVkQ2ZJMnowZ0hiM0xuMlJ4cFds?=
 =?utf-8?B?Z3BjRVJaeGltc2pQOGM5OWRZdXp4RUd1MFIzL2VzaC9ndmxoTngxeXBCK2k3?=
 =?utf-8?B?YVpONXU4RHB3NllKZkhRS0lFVFkyS0RGby93N1ZsZUd1NFhUcTdaSnVZN0tx?=
 =?utf-8?B?RmFSVyt5TXM2aE9YZGNOQ1I4QjJLMkJTMDFiK2Z0c1dOZ0pWWWcvMVpBWnJP?=
 =?utf-8?B?WE5XakRsSjVtaXd1RzJHNHhYQlAxeDJVeERTR1JEYzZjemZ2TmNPdUZzSlRX?=
 =?utf-8?B?bnJ5Ymw2ZGVGRHI5eVFBQmNzT2tEamd5ZUxKU2x5bngrUDlNSW56VkNSZWRt?=
 =?utf-8?B?U1pKZm1XQ3RBUjY2dTNlSWlCd25LYlBVWHZpQUQ3QmgwWmhUc2xNOU9FTnoz?=
 =?utf-8?B?dFA4OEFib3EwTzVBandwYW51M0pSTEc0cnRpZGN4L3Q5ZnJQSzZBeTJwbzFL?=
 =?utf-8?B?K2dBYTcrZm1ZT2Z3cDEyUkxHck9CTFZFZkI2V2dOdlk2SGl1SHl6N29ZVllV?=
 =?utf-8?B?WUpGdHloYk44bDArUHBaRW5oM0tROGd2OEY1U0U5KzQ1cUczcFZkMERVV2tW?=
 =?utf-8?B?d3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E6DC35856327D488E97E394393DF377@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c52d2786-ff91-4547-6c76-08ddea5253ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2025 18:55:46.8095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SyYSSNkgixIJZa6vyiqqEt2Ekri5XwXp9WMOkrba1EtUEcZJYX+6SeJx3nn4QhUvEUGQNv+E1JvGMyopshOlCcaAx58BiM1AMiytTQqRO8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7116
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTAyIGF0IDEwOjMzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEJlc2lkZXMsIGEgY2FjaGUgZmx1c2ggYWZ0ZXIgMiBjYW4gZXNzZW50aWFsbHkg
Y2F1c2UgYSBtZW1vcnkgd3JpdGUgdG8gdGhlDQo+ID4gcGFnZS4NCj4gPiBUaG91Z2ggd2UgY291
bGQgaW52b2tlIHRkaF9waHltZW1fcGFnZV93YmludmRfaGtpZCgpIGFmdGVyIHRoZSBLVk1fQlVH
X09OKCksDQo+ID4gdGhlIFNFQU1DQUxMIGl0c2VsZiBjYW4gZmFpbC4NCj4gDQo+IEkgdGhpbmsg
dGhpcyBmYWxscyBpbnRvIHRoZSBjYXRlZ29yeSBvZiAiZG9uJ3Qgc2NyZXcgdXAiIGZsb3dzLsKg
IEZhaWx1cmUgdG8NCj4gcmVtb3ZlIGEgcHJpdmF0ZSBTUFRFIGlzIGEgbmVhci1jYXRhc3Ryb3Bo
aWMgZXJyb3IuwqAgR29pbmcgb3V0IG9mIG91ciB3YXkgdG8NCj4gcmVkdWNlIHRoZSBpbXBhY3Qg
b2Ygc3VjaCBlcnJvcnMgaW5jcmVhc2VzIGNvbXBsZXhpdHkgd2l0aG91dCBwcm92aWRpbmcgbXVj
aA0KPiBpbiB0aGUgd2F5IG9mIHZhbHVlLg0KPiANCj4gRS5nLiBpZiBWTUNMRUFSIGZhaWxzLCBL
Vk0gV0FSTnMgYnV0IGNvbnRpbnVlcyBvbiBhbmQgaG9wZXMgZm9yIHRoZSBiZXN0LCBldmVuDQo+
IHRob3VnaCB0aGVyZSdzIGEgZGVjZW50IGNoYW5jZSBmYWlsdXJlIHRvIHB1cmdlIHRoZSBWTUNT
IGNhY2hlIGVudHJ5IGNvdWxkIGJlDQo+IGxlYWQgdG8gVUFGLWxpa2UgcHJvYmxlbXMuwqAgVG8g
bWUsIHRoaXMgaXMgbGFyZ2VseSB0aGUgc2FtZS4NCj4gDQo+IElmIGFueXRoaW5nLCB3ZSBzaG91
bGQgdHJ5IHRvIHByZXZlbnQgIzIsIGUuZy4gYnkgbWFya2luZyB0aGUgZW50aXJlDQo+IGd1ZXN0
X21lbWZkIGFzIGJyb2tlbiBvciBzb21ldGhpbmcsIGFuZCB0aGVuIGRlbGliZXJhdGVseSBsZWFr
aW5nIF9hbGxfIHBhZ2VzLg0KDQpUaGVyZSB3YXMgYSBtYXJhdGhvbiB0aHJlYWQgb24gdGhpcyBz
dWJqZWN0LiBXZSBkaWQgZGlzY3VzcyB0aGlzIG9wdGlvbiAobGluayB0bw0KbW9zdCByZWxldmFu
dCBwYXJ0IEkgY291bGQgZmluZCk6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9rdm0vYTlhZmZh
MDNjN2NkYzgxMDlkMGVkNmI1Y2EzMGVjNjkyNjllMmYzNC5jYW1lbEBpbnRlbC5jb20vDQoNClRo
ZSBoaWdoIGxldmVsIHN1bW1hcnkgaXMgdGhhdCBwaW5uaW5nIHRoZSBwYWdlcyB3cmlua2xlcyBn
dWVzdG1lbWZkJ3MgcGxhbnMgdG8NCnVzZSByZWZjb3VudCBmb3Igb3RoZXIgdHJhY2tpbmcgcHVy
cG9zZXMuIERyb3BwaW5nIHJlZmNvdW50cyBpbnRlcmZlcmVzIHdpdGggdGhlDQplcnJvciBoYW5k
bGluZyBzYWZldHkuDQoNCkkgc3Ryb25nbHkgYWdyZWUgdGhhdCB3ZSBzaG91bGQgbm90IG9wdGlt
aXplIGZvciB0aGUgZXJyb3IgcGF0aCBhdCBhbGwuIElmIHdlDQpjb3VsZCBidWcgdGhlIGd1ZXN0
bWVtZmQgKGtpbmQgb2Ygd2hhdCB3ZSB3ZXJlIGRpc2N1c3NpbmcgaW4gdGhhdCBsaW5rKSBJIHRo
aW5rDQppdCB3b3VsZCBiZSBhcHByb3ByaWF0ZSB0byB1c2UgaW4gdGhlc2UgY2FzZXMuIEkgZ3Vl
c3MgdGhlIHF1ZXN0aW9uIGlzIGFyZSB3ZSBvaw0KZHJvcHBpbmcgdGhlIHNhZmV0eSBiZWZvcmUg
d2UgaGF2ZSBhIHNvbHV0aW9uIGxpa2UgdGhhdC4gSW4gdGhhdCB0aHJlYWQgSSB3YXMNCmFkdm9j
YXRpbmcgZm9yIHllcywgcGFydGx5IHRvIGNsb3NlIGl0IGJlY2F1c2UgdGhlIGNvbnZlcnNhdGlv
biB3YXMgZ2V0dGluZw0Kc3R1Y2suIEJ1dCB0aGVyZSBpcyBwcm9iYWJseSBhIGxvbmcgdGFpbCBv
ZiBwb3RlbnRpYWwgaXNzdWVzIG9yIHdheXMgb2YgbG9va2luZw0KYXQgaXQgdGhhdCBjb3VsZCBw
dXQgaXQgaW4gdGhlIGdyZXkgYXJlYS4NCg==

