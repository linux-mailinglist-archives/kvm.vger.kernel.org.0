Return-Path: <kvm+bounces-15596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 995698ADC30
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 05:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0C851B23347
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 03:20:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FE41AAD3;
	Tue, 23 Apr 2024 03:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aBJV7vZ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC69017C66;
	Tue, 23 Apr 2024 03:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713842423; cv=fail; b=KJVyQ/wNWFUtbKa5XwFW0PHiyXu2Z1o3Dku/ThyquuptkSKUwGytP/C5mMX8JtJsb/6aZDaWAOjQkfFBjxMkcqNc89MHpASHu5ZjRYQvTXnJvvnF8UpL/RI8r7dYE2Z3OQgA0gOQmVK7qLrQVLsoQ7GEFlcpHBKoD2RRQ2kPBWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713842423; c=relaxed/simple;
	bh=ogLTMv+TWJEc+3B1bLqJQRT1Iiz28IZfNAzliCjViLM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=guETnkDtPICkwSoiyUKRlaC8UUMbBI3esatOkvX4EASE9gi1pLSs195zXcqoXT8gFJIv9sr1v1vwqproRiDDXSHoBzBHaRIWijKrK5PO4i1bQPITk7AwEpe2KSMs0UIC6F3ouKeq5Fn7vvHvVGcjq9Zntnpo702kDLiq8rs4iCg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aBJV7vZ9; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713842421; x=1745378421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ogLTMv+TWJEc+3B1bLqJQRT1Iiz28IZfNAzliCjViLM=;
  b=aBJV7vZ9tY0E6O7PKIugkxinVCc2NARvEkRml3Q+2xz+IXxXXOp+x92l
   NNzpKEzxo0G1eWlF8uUgWIW5Gl6hsbS1/xX5cf4TisM25KpZn/IwIlisD
   qrkIgxr5HHVsA5QWdsJdci9Jj8ZdlHJPThNZAu78v5macKZPeyJ30nwRD
   O2nGH14GASTfkjow6gzH1+1Q7Mse0ri+neUUEOZljiuvcAlU038XOkSfF
   zByHF/EpsI1yMu5FawACjCMwA1/Tez4om3YgyTS9m2Gq7w+jIUwZpEaZ/
   CoB46WYbJ2sUPyDY36H3vAZGrskxSpQiBLxV9RNlg/mUYcvVHPoRCNCv/
   g==;
X-CSE-ConnectionGUID: zHTcuA8bT6WOfEZ7YhgoBg==
X-CSE-MsgGUID: NccQmVwuQLiLUvWQBwKcyw==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="9238684"
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="9238684"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 20:20:21 -0700
X-CSE-ConnectionGUID: o0da9JtJSk6jX+X2CRun7A==
X-CSE-MsgGUID: NuqQ20TFQjG8+siET0rKaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,222,1708416000"; 
   d="scan'208";a="29019812"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 20:20:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 20:20:20 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 20:20:20 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 20:20:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ahe+INK7U/4LpxASsBjNkmOunlskddIP8stqJWlsNClHbt2JYzFTZHDfUoYZ9L61Xr4UCopTT12a/wCDmBLnWF8ouAWXvuSbrGSFWZfjQlXlM+qSLuNeX/ruRPKYh08AlkfTcF1QhDyNhl9xAEdTNVIoznewL6Dqf7xYPQllYHxJIveJi1braeNtcJAMTbd9tzJrEvjG5KRDtdNEh8DI+SCT4e0QxcKtanIkR+uBkCZmKZaA5xQZnM0Wl4lV+zwv8DbefBc+15eCrtXyWGwabRze4rrFfCo+czALIHaXb7u5shXL0Qz8NkougVYJ2KalUXAWXOJ6hvG6nadfL5h5Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=baBCf1W5mXBTES3+srLD5ceSvrspUxJqfFIbDih5viM=;
 b=lftT99NProrcXtPwUhkUYyGnCXakQ0dg9qvyafQf5/oZVp1iRwGziywCbw9H6BHja8pozdsCHcy7CzHAQ8epXXY8BAxuy7yPZvoDCKUo7KF0ULEgkJokdRhjdTyVUutxefvw1xU76uljkdG8Mlayur8XfkKAWMV4sOgoZo5IG48MJnuYpi4iiGmlWd3G0S2Q0OFQj2q7aO3KHsLF6xHboV5HSGDckQMvNG69IT05pes7JJxSIJIYVFc20iEM7x0nBwXr9YrThHFXhK/mqkZcN/E/VzZB5ydUkJv6uyXTNDHVLpzRirnMEdZ0JNxoZW7W4REMSb2RSOlr7TAHeFXHjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 IA1PR11MB6467.namprd11.prod.outlook.com (2603:10b6:208:3a5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Tue, 23 Apr
 2024 03:20:18 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::55de:b95:2c83:7e6c%7]) with mapi id 15.20.7519.020; Tue, 23 Apr 2024
 03:20:18 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1] KVM: x86: Validate values set to guest's
 MSR_IA32_ARCH_CAPABILITIES
Thread-Topic: [PATCH v1] KVM: x86: Validate values set to guest's
 MSR_IA32_ARCH_CAPABILITIES
Thread-Index: AQHalLXdNoJVo5noxUmOBw5weW5kSbF0sUgAgABP5tA=
Date: Tue, 23 Apr 2024 03:20:17 +0000
Message-ID: <DS0PR11MB6373118F72C9013C96718660DC112@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240422130558.86965-1-wei.w.wang@intel.com>
 <Zia94vbLD-DF1GEw@google.com>
In-Reply-To: <Zia94vbLD-DF1GEw@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|IA1PR11MB6467:EE_
x-ms-office365-filtering-correlation-id: cef51de4-18d0-4838-43f6-08dc63444cfa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?pLpAKN+n2hmiUk+ZRTCCJfIjiRJEofUh7nKiTD+ThmMfJPH6S8E64MWcv8NL?=
 =?us-ascii?Q?Ef7C29ibsctGt1wDycvrBcPvS2htvINUPpJXeWENPvXVJK+giUIPW83I9pUy?=
 =?us-ascii?Q?s5XeIZW833rFaGfgPlOvs6HFAcTKXH1Ebe3bKmiQwLGXi5Y21hhlPQcdLGyq?=
 =?us-ascii?Q?oVM8cO/1hjAhTfjnLAfBrlQtBdcaiW/gyMGnC0p9/imEahKetWoD4+d8yxDZ?=
 =?us-ascii?Q?D9gKbvgt6zfFU98vvi+7tzo2UBsfVLm3SnAfGLWCCpOI2Fu66eZP8AMhYR5E?=
 =?us-ascii?Q?BtwvoEuuZZ+Bq0Rg7UXOGnXjvTdtlPum63qy92wj8P1+CMPj5BBWOjH5gz4T?=
 =?us-ascii?Q?B3aIHWKRA+fZI/5dYFEBkMpPa/fRAgKczXIXhAoozVOMoTLntkfKAth4iS4O?=
 =?us-ascii?Q?Zvd4mGNHviBBgDiEhpXUPbSsBUzJFSsLzBEtmeKrUf2/YJGIoJEsFA2X2mlf?=
 =?us-ascii?Q?nFAsBe6BZLjHZFWEFdfDRmOn7P9mpZPlM9htDX4ZQTpNOBDwKMeX6+6+7Qkv?=
 =?us-ascii?Q?+3Xo0BAjIlaRFL4fFIch0/fnUawGGmxJBiCwYN3MBaOwaewAVAPd88rU4l2i?=
 =?us-ascii?Q?9dVqTpVNktm/GhExPlrCXOuyCw6M/PORngCXDjnrD1lmh2s10sIkHSppd59F?=
 =?us-ascii?Q?ZlVPXMzEySwF9JlYk2vaa9Ietr5wRb9RuD1nZLF4wU5kmWYjYY9/h65y+avW?=
 =?us-ascii?Q?yC87NNjb4g0oyyIbq8RbQpDmCwcaUIFOdTp1nYPSIqZ62CVN7eeHkIWk/KJE?=
 =?us-ascii?Q?a88kkDYORn0/tG/KvfMryRE6lzSrAW80JS0PC8gkPHN3CltusIYwVEClGyZW?=
 =?us-ascii?Q?VpSYOKn7nMVnMTwexs3AQtdtoMK5j6QVzGXBT57jos+z2GxJqlrDDue0VRTR?=
 =?us-ascii?Q?jSdyX/WoHKNB6W5tvfh6bOQ8ukEWHAKg2nlc/t6ZlaJKfLchMG1FENkLM540?=
 =?us-ascii?Q?P2fLc6pP+fAjnbPIf7/CfjGp9U3PfZfNxL2S9yR/M6pQh1zpxlWO9AFeo7Kc?=
 =?us-ascii?Q?3TP2B7ObJoRK6MvBCbKoHuz8cY3hdP9LG1LRd9VZ1qWCHzjxKwKYNhbPaN5R?=
 =?us-ascii?Q?zQAGvidYNGXjCiAzcxVlQwNlrA2C9xCjwup3jz0NN7URQQOhQEauFlactBs9?=
 =?us-ascii?Q?tzkeD+XeakbjZwv+z9e2AQQC7ewipL5QtAq4QetdiJBxOEhiEfFo3Mo1q+tH?=
 =?us-ascii?Q?l9jr3JqW0nBdCWPb2twiWxdazkSy2lATS3zRgS+WO6JUVzo3yWAMux3PKPOC?=
 =?us-ascii?Q?qqTJVA6eDaTS3qCfiJeH/9hMi1Hp5IhJP10peSsB8eIjAoOcg8HOzGyFgonR?=
 =?us-ascii?Q?DEn8S5uzEtMNuaJL9AaIkHKg0LMA4XS4cNX0RKim+EeLvw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u6KuUea92JuTpFXY9wVE3/jajFwswRE3/nXAkmOFXm3U+FcfruVYdR4A50x5?=
 =?us-ascii?Q?e1eAmNXmAS5dKo0lw4woKVC6vj8f+VZd5YE1EAprNjmOVONgYHPqcZg7ASHn?=
 =?us-ascii?Q?jdrJ34Y9sIWYCbq+aq+D+x9jPeUATBY3UheP+SBFJMtm7vLmeg1H+JfnJPAC?=
 =?us-ascii?Q?YZsfqJrcH/xA5Oenh/o2FIFiaEa0TRp0bJWnxF1sr7BkQBuppw/Uv63E1oln?=
 =?us-ascii?Q?Ky/WbER/ejz8NGokKXwS2wWmPSafpk9FyO5JYFRb0IJl/960dr0SiOlnjead?=
 =?us-ascii?Q?q6f87DcykKlXuhTgtsFMSFhrc4mO4w0K25B6d4VOwWOiM9tmHTXMiviRbcch?=
 =?us-ascii?Q?BqKWVSgSVxTv1BlQboD1I4LjJF4yfOBXLxfrpyRo/MVmjtkm+ig6axn90EZE?=
 =?us-ascii?Q?AMRCeQpZyMK0giW2NEMGyq4prcTn8ueaeFR/jnOMdD3st8gDKC1yXeZWuQAO?=
 =?us-ascii?Q?dCUc0Y1flwM+YWP/Fwb0VpKMvNBdbZXiXIgOzbGyKXG12qvVctPIW33QOFp5?=
 =?us-ascii?Q?TmGimZtZo2gFCKd2V+RupMpb1otrBaPAfOHZ7DUHdROeaZmbIHMPVXrJjdak?=
 =?us-ascii?Q?Uzbo+UyBATuNo5NnyKFzrtTCyIuakrgJCUUt7BSkz3ca5akKrf+ALKKsV92D?=
 =?us-ascii?Q?3Y7SdFcz+bwiSp0jPhXkuHOkIaaMVoBkwJfR2NDnk/5L3iKBxQhvjuMVLQSr?=
 =?us-ascii?Q?OuXXd5K3yfKXJ2ooIPLi1vqjdTQJllg6+auYMpc5eNDXhw1eAqCwzvyhTfcy?=
 =?us-ascii?Q?BGZzW8/OXFmFk+s+79mdv+nz+QIAe/kHnDFzSrLyyPI6uRWjJPv+Aud3MPmK?=
 =?us-ascii?Q?U/HTQ/b6idm9Qh4yKhKb5iUy6hiCg5AUzdB7mmEZPEwONGCFU/FAcd+RdzuU?=
 =?us-ascii?Q?yBYNor3SQnPekYMnA6Hw6/ppfjN0dyQKSR15uQdsBEM3VX3vg5ttUcEb6CwH?=
 =?us-ascii?Q?8z0USaQ6KrrZbwqpp+ah5uyjhVIgqfNVtudyl8pUcLFzwsoGMv75MiQQ2BWa?=
 =?us-ascii?Q?r5SiJ4BT02dlXd077uRy0nTERYNS6v6eUQC4s+1bmJ/Or/hd4xuwsitZmMxz?=
 =?us-ascii?Q?j/HFODEosQkd+6h00zlvai4cbtIaHWThOfi0dqiyjd1pa7qiVI2TuZApvYtH?=
 =?us-ascii?Q?9qHy8AzkOMmw41gXRiZ8ZQ0+bfBS6moY5n+ZRoVuq/UDigbi4xT+64uRv0s/?=
 =?us-ascii?Q?Jgi6rv6wPayrfDXotWWFLmxWLRgpiU3chS2vYnKJIR7ZrxNuS3Kqv96vjc8D?=
 =?us-ascii?Q?BFjJ8mZTkrwlCqyxzj+y+NyoA4UkWoV7UvboCbyxnHB5E/Yki4+7o1Xj/EwF?=
 =?us-ascii?Q?D5KuegVVxq+kP76xJx1FRukKz/mPCOdQptLGBcvhhD0CzVRPVN+rqd9oT7HV?=
 =?us-ascii?Q?fHCqL0XNhd+aVwktl8NBNaTylNgM9lEiKcQWSY2R/RUXG70zbGVeYlVXAUjS?=
 =?us-ascii?Q?sh8NkYoq+h8Nt2O118aXS7sQBiMwNgPw4bPh2ifLb4lPa/L7WWolmwXtWX/k?=
 =?us-ascii?Q?tQDF/a5fYfjHpKYvHRwOAlc3YlXUknaMCrKxZj3Dv3DZGfYsReV/Of9V+iJ3?=
 =?us-ascii?Q?xPHOcGgf/NrZzCi+52ShSWd82ZSNTvrTWscZrsIl?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef51de4-18d0-4838-43f6-08dc63444cfa
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2024 03:20:17.9641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IPK06lRvsAv5w5GoR7cLB3Finf59zltyiKN7DwbtHlwDaekzyrYPcumDOVPJIcd9385Kji8PsJisz1vHcYzBmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6467
X-OriginatorOrg: intel.com

On Tuesday, April 23, 2024 3:44 AM, Sean Christopherson wrote:
> On Mon, Apr 22, 2024, Wei Wang wrote:
> > If the bits set by userspace to the guest's MSR_IA32_ARCH_CAPABILITIES
> > are not supported by KVM, fails the write. This safeguards against the
> > launch of a guest with a feature set, enumerated via
> > MSR_IA32_ARCH_CAPABILITIES, that surpasses the capabilities supported
> > by KVM.
>=20
> I'm not entirely certain KVM cares.  Similar to guest CPUID, advertising =
features
> to the guest that are unbeknownst may actually make sense in some scenari=
os,
> e.g.
> if userspace learns of yet another "NO" bit that says a CPU isn't vulnera=
ble to
> some flaw.

I think it might be more appropriate for the guest to see the "NO" bit only=
 when
the host, such as the hardware (i.e., host_arch_capabilities), already supp=
orts it.
Otherwise, the guest could be misled by a false "NO" bit. For instance, the=
 guest
might assume it's not vulnerable to a certain flaw as it sees the "NO" bit =
from the
MSR, even though the enhancement feature isn't actually supported by the ho=
st,
and thus bypass a workaround (to the vulnerability) it should have used. Th=
is could
arise with a faulty or compromised userspace.
Another scenario pertains to guest live migration: the source platform phys=
ically
supports the "NO" bit, but the destination platform does not. If KVM fails =
the MSR
write here, it could prevent such a live migration from proceeding.

So I think it might be prudent for KVM to perform this check. This is simil=
ar to the
MSR_IA32_PERF_CAPABILITIES case that we have implemented.

>=20
> ARCH_CAPABILITIES is read-only, i.e. KVM _can't_ shove it into hardware. =
 So
> as long as KVM treats the value as "untrusted", like KVM does for guest C=
PUID,
> I think the current behavior is actually ok.

Yes, the value coming from userspace could be considered "untrusted", but s=
hould
KVM ensure to expose a trusted/reliable value to the guest?


>=20
> > Fixes: 0cf9135b773b ("KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on
> > AMD hosts")
>=20
> This goes all the way back to:
>=20
>   28c1c9fabf48 ("KVM/VMX: Emulate MSR_IA32_ARCH_CAPABILITIES")
>=20
> the above just moved the logic from vmx.c to x86.c.

OK.

