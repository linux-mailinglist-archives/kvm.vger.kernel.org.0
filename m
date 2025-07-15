Return-Path: <kvm+bounces-52542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4890B0683F
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 23:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E930C18836B9
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 807ED2857C9;
	Tue, 15 Jul 2025 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b9KdEwFE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD791238C0D;
	Tue, 15 Jul 2025 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752613438; cv=fail; b=RzAa9GknDUOjThG1XuYlSeu4YgVUgx9Dz1up/Rb3LTaFlvzjT6oDBV5bQmja9q4/3bGcLHpJmO7jfRvcOIWh+jqbteKiy9+NPyt+eLzEQp+cBrW/dMef+2JPHQKMbwMeGCWtDiGjRKWe/NyU41SEVOOXmi7bBC03v2/7TN/cdgM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752613438; c=relaxed/simple;
	bh=qsTmuryzzmOPRob9VxQIfynFw0rfZHSB48zO/amJL/U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LXJaJp1XCBSHTuhEuXwI1qyF/tMXUb0oM52Ai69WOsDJKpRWxwfrPKITmTVip1SOG60R3UjS9rZUqAHKUm3FZl9yiCVHOr8v0TfqpA83zLclld3KeCbRbmlGIjEBkmNh0VxyfJCcGdvjGyEJNt0/n7ByFnaYsM3G2sqKk4M4dvk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b9KdEwFE; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752613437; x=1784149437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qsTmuryzzmOPRob9VxQIfynFw0rfZHSB48zO/amJL/U=;
  b=b9KdEwFEoy2ab0l52fqxb42RJrPy3c02vtoaTK5wAfVL0emAks1wl7h/
   JgkTLrBYV8GwXBNcVPwzNajtrAapEHe26S09s9ZH5NmPWoJl+DxQipikd
   UqVTxhVThjUExSICm6KRPCTmppLMjH7ZzvQ8lWZPl7iRAMNO/kSLTQ1vg
   j0nMQgwXyXkGlanrL2ktyU2CqVCOBnFE78HcvdkAk4zSryrpgTzspb56m
   o73Wo1ZkloaJt46i3SlyeQlqBUUp/b4xzDSplHDQYnhOYoDKPIB+igMTh
   0rMtHJ6rP8r9Rp1/Zxn9jXYlPk49jfp3ymfkiJBmAOn8SvbYBiDdHuA+N
   Q==;
X-CSE-ConnectionGUID: Qk4IsS2bSsKKcRJNdMuKgw==
X-CSE-MsgGUID: t6wp8+CzTOWZ1ON0KpzIig==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65544922"
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="65544922"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:03:56 -0700
X-CSE-ConnectionGUID: pAzAW8pjTZGpwo9Zf7TNDg==
X-CSE-MsgGUID: cPkcHk0nThqxB0vfBcrQcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,314,1744095600"; 
   d="scan'208";a="188305277"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 14:03:56 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:03:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 15 Jul 2025 14:03:55 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 15 Jul 2025 14:02:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z2Gfxy4cHh2YGqZA0jIN3NH0LmbZXtp5CxRW638XCwVxDLJFtzKrIBEzjdOe1zdgdvsWrJLC4JEUBeqeaPdzlqbW+5JVv5VHILIfEgXW9PRngjsjcX91XEVu+TZBdkfqeCqFNEAOK+mF8HZ8Bc5US1xR6qDk6oKu0HNFLNTwOjka5gQlX0WhdsRBzySE2n4l/W6sUKARRY3K5N0iGuctKCaKhWRxJZAWsQAa6UkIlKbhaBuQEwxoFUdVItGROv8QKI3FFQXTkv1atBIRi9dPYVEfIS7ndpLEynt2W5bMrikIc8pg5QNmHtzPwrfWI2LnM4+9d3oNXDYCwF+DzLoKuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qsTmuryzzmOPRob9VxQIfynFw0rfZHSB48zO/amJL/U=;
 b=euO+YfJqKaD3ZP6fN28nLzGDmplcq5ZdJP3xoneLUXCnLrk8AHyY4VETUvgWn45X6Fkrrx69R4hKYmX/9S25DwcfwyPeg57J/bmd92OBQ584JjHNiJKGmLOYHEvBwwcHg/HYNDKRQHoNiVpxMnkRct4Gj8imYmK9dlvXmRnKqoaX3I3vLRn40YhQlA4ZR7usVCX2fvJ/EBu7a0vFNIyaREfCY1JTljUOTLvzxJF/r1u5hbLQTb2I15RF3xKqfwuHv4UY0kClHm4lqGRoU2in6iA6blsfMeD0uzsWctUDrG85o1vv4rK+RmcSKyn24fLAapIGd+1djNOfTUVMr9qVyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5281.namprd11.prod.outlook.com (2603:10b6:610:bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Tue, 15 Jul
 2025 21:01:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.033; Tue, 15 Jul 2025
 21:01:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: Ensure unused kvm_tdx_capabilities fields are
 zeroed out
Thread-Topic: [PATCH] KVM: VMX: Ensure unused kvm_tdx_capabilities fields are
 zeroed out
Thread-Index: AQHb9Q1oYnFfXSGt6E+zZPENp1TUOLQzrTcA
Date: Tue, 15 Jul 2025 21:01:42 +0000
Message-ID: <6d4a77196b446e2fe0ee930a45888fae4cb60a5b.camel@intel.com>
References: <20250714221928.1788095-1-seanjc@google.com>
In-Reply-To: <20250714221928.1788095-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5281:EE_
x-ms-office365-filtering-correlation-id: 623afe1e-487f-4c41-a535-08ddc3e2ccca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dWdWOE5jRmFEek84dVY0RzBpdmxRbTQxRzRWQUhsQU9hRVlrUVl5TENIaEg2?=
 =?utf-8?B?dnVpYkVObXZVRmw3b3Z5aWFPMElVS3VVQUhHTE9Jbkl3OXNQK1RYZExZRGlw?=
 =?utf-8?B?cXQ3SExYMityV2cxOXdFcEEvVlJ5LzNVZThZc2gveHpuRU02UkxPN2tpZEY5?=
 =?utf-8?B?SWx3MFlKNzhUS2orSytZZFZIVjkwSEVNa0pQejlrUTFjUVdtZFNuQkdBaUNC?=
 =?utf-8?B?NElpUnNEN1ZsNlg5NmtPb0g2T1h3QWsxMmRxYitQZU9IKzU2R1BXaWl1d0cx?=
 =?utf-8?B?bFNJaE1YTWtzejdJMFVxakFnaG5pa3kzZFhXS2R3cUFOWU9zTkwvT1BaNWVL?=
 =?utf-8?B?QXVSLzlDbnJtN2hXdGltVk4yY2tWalQ3b2xDVEg0blNpT3lGb3lMYnRscVRw?=
 =?utf-8?B?WEd4NHk2VUpBQkNtTW5iVlIwYlpNNGN1NWhTNnR2enFLT0x6RlJXcy9LdXBT?=
 =?utf-8?B?Rlp3eDdwcW1YNy9JZXhJdjdSeWgyR1ZYYVRNWjJYVVJTWHM5ZVlIRG9rR0dD?=
 =?utf-8?B?M21ZNXBtQ1V0VzQyL1FXTnpoRFV3T2N4LzEwMXB6aU9SdlJ5SVRydk5Bejlv?=
 =?utf-8?B?SjNOMTlDMGlZLzI1dkVyYkJjVTNpc3dNQ1R2akgrNytaSGxpRm9PU1U5dTNv?=
 =?utf-8?B?OXFYTFN5aFYxNW01ejA3VmNtSUd5Y3VuOGRTTkZzUDRDN0c5OXlZV2ZFV3Rq?=
 =?utf-8?B?LzBzazVxNUdmL3RaVnJzRW50dllWRFR3SEdybENKa1QzY1pGdlFidVhoSllk?=
 =?utf-8?B?WlMrVnV5bVhHUklwQ21XL2lMUVh0enpFdDRnRnVQcnoyQXIrTFdLTUlhYkdE?=
 =?utf-8?B?REszdHQ1UG42b1YvYy9KbFpDRUc2K0FPY2p0MUlzTTlwZHMyWTE3SWZRZmJU?=
 =?utf-8?B?bW1XUXc4RTBIKzFSS3EvSko2WnJiOFZPalB4TkFoMHRtSUk1TUIzd2lWdVBP?=
 =?utf-8?B?WTZLMlVxY2lWam9GMGpQdlFoMDYwTERkVVdvR3lvRnJKWVFFcnlyVXg0UVh4?=
 =?utf-8?B?Uk13ZmZaVm12VnBzeUN6dkJkOXg1L09mSFRoaFFUUDdqcDlWQVNjSUVUM21R?=
 =?utf-8?B?Q0xhWjhsZmNrVmovKzNiYlNCSjBvdEVaUjNmN0oydWZoQ2pWMnNxamZFQmxz?=
 =?utf-8?B?UTc1bTJSWW9uWkJNRFZkK2tBTnVBODZvYis5dGt3MzJnTkJ1UHAxZGxIamR4?=
 =?utf-8?B?QkEwUU4zVkl5YjNRcGNNcml3eTJzeE9tVXk5anR4UlBsQ0NvZGZiOWhITmZ3?=
 =?utf-8?B?N08xckFBZ28vMkRFQXFvYzZ3ajN0ZVp3NGQ0anEvQlp4V1JvQ0hCR0JCK2d1?=
 =?utf-8?B?MGpCeGUyM2ZQOGJqOVhYY043enpsSUlEdmU4WHdmSVVxdkE3V1B2QW5NOUcv?=
 =?utf-8?B?TDI2cDBtc01RR3d5eDBPOWFQR0dCNmU0V2t4OVZvVkh2emRZU3kzbW9rNW1a?=
 =?utf-8?B?VTFpRFdiVCtab3dRbDk4RnFhdE5lWVpWWVBOSGppU0NwTnI1UHd2elNLZnR4?=
 =?utf-8?B?MUFGUjJVRHZsTURCdGQ4MlEwRWE4Y0htMmkzUWZGd3g3bXRCcCtjNnN0bms0?=
 =?utf-8?B?NThydkNKc01NQ2o4QmJRblFsd2l1cFkyandmVnUrbkNOUHRHTTNVTkZIejY0?=
 =?utf-8?B?cTFjVUFvUFBmNFpSbHc2azRTMU9XOGNIUGxDNjlWeG1xb3RLTGo5SVdOWHVH?=
 =?utf-8?B?QkVBc01xRWlESGcyNXk0QkJGOHV0QU5MNDR3ckVpeUxVU0crQi9YREFIUzdP?=
 =?utf-8?B?MnRDejNsaVU4ejN0TnlDZDBtRTdEK004MVB5anlEQVN4azk1clpHeHBXTEJY?=
 =?utf-8?B?L3duazN6OVFnWHRJVzdUcE5ac0U0eVptUXFzMVhZSjJCYkxsMzl3aEVnOG1L?=
 =?utf-8?B?c0VGbDZmWVg1QUcvTmtITHY4Z3kvT0Z1WFZQMDJwbWVwa1Fsdkx4N2M5SzNn?=
 =?utf-8?B?dEkxQTNVQm9lSHU2QituZlM2Rm1qa2RMd2czaUtmMjJWMTM4TjRCYWNsTHZM?=
 =?utf-8?Q?yAFNSZLwt1Yewb12f3hrtSX0OqA8Hk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UjRHWGxOK1p2TTlORGJrWXRxSEp4eWppRHFYQjYzYVZVeUdpM1E2cEg4M2Zm?=
 =?utf-8?B?QWRxSXlTekUrdWxWYmx6eS9NUFVFaEJKNVBPZ2hFTTNvRDRnWVhTcUl4ZDQr?=
 =?utf-8?B?QWJUZ21EeEhUU0lyZHdITmpLL04rc3RaNkZUNW5PdGcvSHpkcnFlTkgvcVdk?=
 =?utf-8?B?L2FtbVRnZzJNcUNvUzllN1BYM2RYN0E4T3JJK0VrM2grVUw5VGRIVUQ2ZVBr?=
 =?utf-8?B?U0NUc1RSNFFCaVJUdUYyTmFoNnNhakpGRW0wbmdPUldNY29sdEhpZWhubDZ0?=
 =?utf-8?B?VGFPTDBrRThMMDRPTXR5UUt2c1BuNk9IY2IzU3UrR2thWTVFMGdBYXg5ckt6?=
 =?utf-8?B?MEpXSXpPNzd6T0pNK2tjNGpuZHVpeThBa0hDd3hiT1lzSi9sQmZ6SmJYek1v?=
 =?utf-8?B?dUh3aVlvNG5haXN6NERBWmFRVG4vMHhLMXRvejRsYjhXaS9XMXloNHEyeXBW?=
 =?utf-8?B?bW9aQlJsb1FDN2xtZ0tkczRmOXJ6YVdsNTFndnhhbzhCWktZWS8wK2Z1TVFi?=
 =?utf-8?B?Y3RieUhLcUFZdE04cFJ0dzF0OFgzeGd2cmZCMGlMUlN2cHM5SHR2blh1UG1H?=
 =?utf-8?B?aDJPcWJveDFWRWIzb0xlcTdzK2NWOTBVMzVCUFY2WnU3WVhublE0V1l1bFNv?=
 =?utf-8?B?NGxXeHFjN1o0R0FmdTZMa21yMHRrZ0lxN2RSUFpQTUtraU5sOUl2TnpiOWNH?=
 =?utf-8?B?MU5NQ0FoWjBLVmRoUXFWS2VFOHlLS2g2bi8rS1FMeXhUaENFVmVTY1p0N2x3?=
 =?utf-8?B?UUMvZWxENjZDWW9EeThidEtLSHpmN0dVNC9xS0dzK0IzeEE0N1RMNVhDRkZN?=
 =?utf-8?B?d2VycjhaSjVvQTBCRjRyVnZyWEV2MWZOMk13a0Z6Q2p5SkpoNDcyUldhK2JB?=
 =?utf-8?B?THRuemY2Z3VxZDk5NS9SaElUSXhpcXNwTDd0K3BVZnFRU1hzQ3FDVVdCYXBE?=
 =?utf-8?B?d3k1NjJhQmtmNnVmKzBWaHBLWnpjTkNJVHNTK01ISCtIaTR2d1pxOEsyak96?=
 =?utf-8?B?T1g4dHdrV2pFOU0rMy9CRDNOLzFRbHJUSzE4bFMrWWZCbCtQeTVTTDBqdms0?=
 =?utf-8?B?NEdCejNVYWRSN0RGbFprdEswcTIyVWNXWUJVZmhseFN2UWFIRDNBdzFPenhw?=
 =?utf-8?B?TEoxNVB4eVpYRm9vcys2bnlwMEZISHBkVjh6eGEzc0NrSXcvK0xvY21adzIy?=
 =?utf-8?B?bDVzYkwyZW5LMjlhWVJiNHhUbVpIUy9JL3NHZmgrQVl3a2dmcEZReU9Uc0JG?=
 =?utf-8?B?VDEyYmRQNVBTTTJ5dWRmK3QwaWpKY2s4bWZmN0YyeFltTHNmMmNScDhjcFdu?=
 =?utf-8?B?OXdjQUFzc2x5UmhyKzJDZEhzNDljV0xqd1plejFDeE9tZVluZmZBdFlBdUFF?=
 =?utf-8?B?N0dHanovY2w2ckN6cVJVUW53Yy94S0tmUU0wakJ4aUtpR3FLdlNSY1g4bFJK?=
 =?utf-8?B?eS9EdktabG5qUVUrdFRRVE1KSm1rNCtaMGI2VENVNHM2N3F0cTl0cDdyMlp0?=
 =?utf-8?B?Nkp4R3RpUUFRYk8ranpMb0NlNWdEM2ZzZmhxU2IzbFNlc0VoeGtTK2Yra2xi?=
 =?utf-8?B?TVFaM0djWEp0d040NHlYcllqeElwaTdILzUrSkU2alRhUTFJcCthWnk4WUxW?=
 =?utf-8?B?N0pBQ1VNQTYyakk1WVA3OFNZVHVXaDlHbFpoY2tla1V2ZlkxN2t1WStWa3pD?=
 =?utf-8?B?U1pURWFBUXczM2o2ZTJ6MWl5NXZCcWRQZnc2YWtaZ0xwUk1KZ2tLVmNKWVVW?=
 =?utf-8?B?ZGdDMzR3OXZ5QlRmZFcxUldyN2Vqd0wxWFlQejdTcXBXTmtOTFVOYnZkUThX?=
 =?utf-8?B?Nm94b0hsZ1RNdnlIZHRXTzRER3ZyWjhYRnRVYVhtbE5vVzNtNVFhcWQxYjA1?=
 =?utf-8?B?eGZweTNSeXFoMU0zV2E3YmdySXRZUU9rVk9ua1pHdU5lUE9wTzU5WWU3b1J0?=
 =?utf-8?B?RitWRlJaRGtteDhUWDlrMm1LNWFaSlA2d2NlQ0gweXRjK2g5K2pLeW1JdG5k?=
 =?utf-8?B?c1VmeHErOUh6NDJCZE40THpDV0wvMWlpZG5mUXc1eDZxaHVaUnJYQURQNUdC?=
 =?utf-8?B?b0laa0ZpV3RhbCt2RnY4UkVuMUcxRVNiMzRJb0ZuMlB4dVNjeDZpK29KT2Ir?=
 =?utf-8?B?ZUZRYzlaem9zak1QWTBzSzA2MDF1YWJYVW9pYzNpbXdBaGFtTHpoL0kwWWdO?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4757188D73088498BB372B94FBF676E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623afe1e-487f-4c41-a535-08ddc3e2ccca
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2025 21:01:42.2018
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JUoLmwd+xNpaafc1S0zsEHdEohR7ucSA03Md2ouRddQifNtA1hg5tWzXSHXsjVDhVsfF3J0FgfZGZPds7/24fn9YubZ+IZ99E2TUyp/o5rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5281
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTE0IGF0IDE1OjE5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBaZXJvLWFsbG9jYXRlIHRoZSBrZXJuZWwncyBrdm1fdGR4X2NhcGFiaWxpdGllcyBz
dHJ1Y3R1cmUgYW5kIGNvcHkgb25seQ0KPiB0aGUgbnVtYmVyIG9mIENQVUlEIGVudHJpZXMgZnJv
bSB0aGUgdXNlcnNwYWNlIHN0cnVjdHVyZS7CoCBBcyBpcywgS1ZNDQo+IGRvZXNuJ3QgZW5zdXJl
IGtlcm5lbF90ZHZtY2FsbGluZm9fMV97cjExLHIxMn0gYW5kIHVzZXJfdGR2bWNhbGxpbmZvXzFf
cjEyDQo+IGFyZSB6ZXJvZWQsIGkuZS4gS1ZNIHdpbGwgcmVmbGVjdCB3aGF0ZXZlciBoYXBwZW5z
IHRvIGJlIGluIHRoZSB1c2Vyc3BhY2UNCj4gc3RydWN0dXJlIGJhY2sgYXQgdXNlcnNlcGFjZSwg
YW5kIHRodXMgbWF5IHJlcG9ydCBnYXJiYWdlIHRvIHVzZXJzcGFjZS4NCiAgICAgICAgICAgICAg
ICAgICAgICAgICBedHlwbw0KDQo+IA0KPiBaZXJvaW5nIHRoZSBlbnRpcmUga2VybmVsIHN0cnVj
dHVyZSBhbHNvIHByb3ZpZGVzIGJldHRlciBzZW1hbnRpY3MgZm9yIHRoZQ0KPiByZXNlcnZlZCBm
aWVsZC7CoCBFLmcuIGlmIEtWTSBleHRlbmRzIGt2bV90ZHhfY2FwYWJpbGl0aWVzIHRvIGVudW1l
cmF0ZSBuZXcNCj4gaW5mb3JtYXRpb24gYnkgcmVwdXJwb3NpbmcgYnl0ZXMgZnJvbSB0aGUgcmVz
ZXJ2ZWQgZmllbGQsIHVzZXJzcGFjZSB3b3VsZA0KPiBiZSByZXF1aXJlZCB0byB6ZXJvIHRoZSBu
ZXcgZmllbGQgaW4gb3JkZXIgdG8gZ2V0IHVzZWZ1bCBpbmZvcm1hdGlvbiBiYWNrDQo+IChiZWNh
dXNlIG9sZGVyIEtWTXMgd2l0aG91dCBzdXBwb3J0IGZvciB0aGUgcmVwdXJwb3NlZCBmaWVsZCB3
b3VsZCByZXBvcnQNCj4gZ2FyYmFnZSwgYSBsYSB0aGUgYWZvcmVtZW50aW9uZWQgdGR2bWNhbGxp
bmZvIGJ1Z3MpLg0KPiANCj4gRml4ZXM6IDYxYmIyODI3OTYyMyAoIktWTTogVERYOiBHZXQgc3lz
dGVtLXdpZGUgaW5mbyBhYm91dCBURFggbW9kdWxlIG9uIGluaXRpYWxpemF0aW9uIikNCj4gU3Vn
Z2VzdGVkLWJ5OiBSaWNrIEVkZ2Vjb21iZSA8cmljay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+DQo+
IFJlcG9ydGVkLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gQ2xvc2Vz
OiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvM2VmNTgxZjEtMWZmMS00Yjk5LWIyMTYtYjMx
NmY2NDE1MzE4QGludGVsLmNvbQ0KPiBUZXN0ZWQtYnk6IFhpYW95YW8gTGkgPHhpYW95YW8ubGlA
aW50ZWwuY29tPg0KPiBSZXZpZXdlZC1ieTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5j
b20+DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUu
Y29tPg0KDQpUaGFua3MgU2VhbiENCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNr
LnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCg==

