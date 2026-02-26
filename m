Return-Path: <kvm+bounces-72092-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EHhSOebDoGnImQQAu9opvQ
	(envelope-from <kvm+bounces-72092-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:06:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F09E1B02EF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 23:06:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7055D30162AF
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 22:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CD546AF25;
	Thu, 26 Feb 2026 22:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J0LLDLGX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8A53019C5;
	Thu, 26 Feb 2026 22:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772143583; cv=fail; b=AsTlyAElQRt/s3fBFRMb54a2kYhpNZZ7BbHgJXHIpTlUTDy83XgJETWOsUzbKmXQBmcfiN7hz34UxAFtzWU3Lwx6/uj8+N68zDt/I9wyVD+GNXHO5yLCxDA1dINbuC/Q9f37yN+5ON/ww1fe+RkERpNL/X1jF0jPVA5dwxF4Bl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772143583; c=relaxed/simple;
	bh=gMXWJUaw4VjQCCVVx2PIKmaSuGrzVjGe1owS/SVcfNQ=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=QAmC+0X3Tkz8H77bG0Zied/QkGcjNczPQoKJanSEyLSaokl3BM0sm2cIv3gUCKQwp55do1oImfk+pqAO44zVqXKJgb/ljTdBhO06XHFuMPwervQu1PmwtkK4ZP1HPWC40WZ4MUdcSKvpUQ7QYRis2TR76X3hjKJA41JcsnGWKu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J0LLDLGX; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772143583; x=1803679583;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=gMXWJUaw4VjQCCVVx2PIKmaSuGrzVjGe1owS/SVcfNQ=;
  b=J0LLDLGXkzaLh5fZkst+30C712ufDTH0DPQskTlt7fuEnUQQUK9hw8MR
   x+uNssW5qqhXUTpBK1Toj5uMMWW7CRAwPviRIxEstLFcHqLXFYEj6YSLv
   hXnwdstUfu4slWOgSOW79mzF2LB5pcxklw7uCFTnE5J0Vr33utbBA0lzW
   ejj4ypR86cGZ2ayqar0Xk761aqA4fIp05guppfD6kGye9OOIdbmDKDzXY
   q5WwLR104Y19ly4exHitfESUhnh4OhBz/PnkLYRTB0p9vdWPPL/9PQygk
   gMFN/LY3IODaX2o13lsPQHgPZbDRehoeyCEyd+6Y5/3o8FFvj4PnHadmE
   w==;
X-CSE-ConnectionGUID: 8XocFpiASM6QOtjBw4t71g==
X-CSE-MsgGUID: jwyEVpCLTOOr0QxbbhIyJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73130071"
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="73130071"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 14:06:16 -0800
X-CSE-ConnectionGUID: 2v6L+cz8R9+H6hS9OgBeyA==
X-CSE-MsgGUID: ZF6OkZioTEKxyYcXIDTkgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,312,1763452800"; 
   d="scan'208";a="216611205"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 14:06:15 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 14:06:14 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 26 Feb 2026 14:06:14 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.19) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 26 Feb 2026 14:06:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pBouHDopX5zoFNx+JN9v/h1licmMDukluCAM8+Z1gnmc2VH5NUL/v3BAGYsQpgKk69O+yYodoDXHnJ2ZK9rF6ozX2jSVY6+XC7hE1uZHPwbZwB+LLAXoAAduDooJF7MFOd4tg/5HaRqvARWXt2yXUayQq1qp8ooI3f3a2QZoj7g9Z5Hc4773PXRozIsjWpZcs33UYNTR56TSPF5914ff41Xokq0GriSfXHqef2YKLcP2QLwrtrkI2WEf6VUK5nzIXmzDAJhjEAMHywggz3XITL/x4ECT8qcu95Egljw2f2cEpeUBviOOrlVjrOHGqYctKJAobZ9tik4YwKijW9PZew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FhZ0XYtPJWxdDLcdrX/PonlcZkOz9pK5XQ1KxL1nrQI=;
 b=kydBdeLFWtt59GVoPqY2ZVB8yeCFMmLXT35xYXoAWYf0PTHXo+dB45y20cOOcEZqRxmG+O/Gy3OlYUWYLYQXUiSyu8bs0N0Ap6YwXSHnQGpEcMPG9J9CZr0uq37D7jAk4rEfmVs4pAvNKfvgWU54xv7xbBL9Uj57TCQK0XgZmWFq3oWTDXvPs8UjoKA93jCIPrUK7mYwZ28Dbx8j4k7JvqBobag60UYSPXzV7AID6yEz1065gU2uGySZTEnAZmih17gqSSH18yCtOEs/BRu5+8Z25kfObdBJHxXP3YCjgczUn08NCoX7NUh9pfUeKtDPEDy/7ppfUktvFXFxC+orTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by SJ5PPFC35D45AFD.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::853) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Thu, 26 Feb
 2026 22:06:11 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%5]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 22:06:11 +0000
From: <dan.j.williams@intel.com>
Date: Thu, 26 Feb 2026 14:06:10 -0800
To: Chao Gao <chao.gao@intel.com>, <dan.j.williams@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "sagis@google.com" <sagis@google.com>, "Duan,
 Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>
Message-ID: <69a0c3d24310_1cc5100d1@dwillia2-mobl4.notmuch>
In-Reply-To: <aaBndinjh51R2wQU@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
 <20260212143606.534586-22-chao.gao@intel.com>
 <a0a5301140be5a3d944b1c91914b93017af026fb.camel@intel.com>
 <aZ+31DJr0cI7v8C9@intel.com>
 <699fe97dc212f_2f4a100b@dwillia2-mobl4.notmuch>
 <aaBndinjh51R2wQU@intel.com>
Subject: Re: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during
 update-sensitive operations
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY1P220CA0022.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::14) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|SJ5PPFC35D45AFD:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e33f7c0-1e93-44d1-a25a-08de75834028
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: Iw3TwMBXiWCsuWyZjVqpiGdx52NVk4UGzFV2Cd9cTxLPDtOk5viJcreRbSqt/PeE08SXSZW/UU1Zpw4tlRQbkrWnVXERvBNii9mAvxXbqoc8ybqr2DR1eQxlc29Z+SfqEfpccdehe7Gpc8Xe2Hg4uK6ezpghYXlguEWiiUsGoUarLrcD6JyL+uZpz3FjDjlSCrCjyNusIMfYXEz8N3wTuLx9NrNvPGJpuhFxAL+Q2tNbr7KEJba+Z1KXh97XTxYj0r28BGXg0ivpvRluSuFD2xqwOn9qRhw43owC/YCq5XbLD/ruDZW1W/v0BPxOq5/ITLwgIprC3bSDE5CzaIs5ajJNVNW+8egGcHeSBF9xeva7vCyEoS4RJ7CFvpFbSu19xrRyMaCQz3z03ilgvIVXopIiBaG53vWOGuV1JFs3qU1UO7B03J9LSmJSeqcElIM9tY7FtlUQrBvrJzeF/QuSWvt/DLqxhjJhyoWzBHFoSxmjlvyVVDMc/Kg9P3zJ+kv23HGpLOBjFm0aokyDmMtX/yGBNzwdFsdKYw9b4v1L0vhla6Fo5K4ro5Unhnbm40FcZfyh4n/jUKaUfkYBXSNbTGut/fhYMyjFKzZKHrkwmcZx/IyndX9t+crrfEeyS77E8w6SG6KB7LD1VABta9nWF2zPmnlfFLD8lJgISzC5tgdtTEdH5CMJa2C3g+Y7DPgTLkR7VQnFp9+oFXMgC21PTabVlJ+VP94NjJdLvf2sulw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2lRVGdKVGUxelowK3M1TmZOOHBvVU8zam9SMmhYRDErVUU5RHFzcFF2RzhX?=
 =?utf-8?B?MDhvZTFzNHAzNEVsNjBZYVRIYzg1b1NMQ0REenJTZmN5Wk5ZcmFRSVREQ1Zm?=
 =?utf-8?B?TUkrSEo5MG4wT0NGK2k2RnFqRGlqS3ZFMlNCbG9pZ0xtU0kxYS84aVpTdE1k?=
 =?utf-8?B?Ylo2VmllSUw0enBNbmNFbjRjQ1ZubmNOaHYwa0hDMjhMa1FuMkVGT3V4YThI?=
 =?utf-8?B?dEJvQVlKaG1UTjhXa2MvS3RqSXY1ZzVSaDdVWTRpc0RtR3cxdnJEU1pabXNn?=
 =?utf-8?B?VWZyUCtGNEZJakROQXgxN0VOODc1TVZSczhzWVRqK1JuVjhQU2JMUmsyaTNj?=
 =?utf-8?B?T0lheXIzZG44aHcwQ0E0V0djcFM5dk01VnB3OHAzdm50NkE5WGx4UUx5blRl?=
 =?utf-8?B?czcwOWc1Sm1KY0dZUE42Vlk3cXlJVitmdGFlaUpKc1VUUzNWZGRjUkoyWGtP?=
 =?utf-8?B?bnk3VVUrMndsUzBaNkhFTUYyeUtJeFhtU09DVy96QnFLZlhBbk52UHc5MU8y?=
 =?utf-8?B?SzNWNVhjaklXUnc2TkZ4dkJGMWZnSEVVSlJ1aEd1R2JYRVJFSzJVRXF1emdU?=
 =?utf-8?B?TGxtaTBkaC9hTGF3eTd5YkZKNmpNMGkzTVkxYmRwUGc5V3FjVHBydTMwbUxh?=
 =?utf-8?B?aEdYd0VNeDVROGdoNVZzZFpOd0tnM3RhZFJPanNjTzhDZ3ROdUdNT2dnRllx?=
 =?utf-8?B?cS9XMjZpNXNRdEtKbnNydlExQkRIMVcvWHFlSUJJNlRTU2I4UHc4Vi9DcVRH?=
 =?utf-8?B?Sm5MT2dLenY5ZlhYei8yUERRdVRwTmN6NlpQSXdIWG53am44eDlqUllrTkFQ?=
 =?utf-8?B?UlV6QURMT0FVZjBTVHk1VUVObTJaNlc3ajRKSVY0bWlLQlR1VDQwcURFMlU1?=
 =?utf-8?B?NmU0V3p4dXVkb0J2Vk4xa0d5U045ekc2elNMZUxZV3FDQVhUYi9TNjRRUnpr?=
 =?utf-8?B?WVAwNXpZMU9XdEVqZk4wTjVZZXA3SURqZjBFMzRuOTJOT01MeFc3RkozZU1O?=
 =?utf-8?B?UkJWdkpSL2dOOFQ4YnpVeWpxd2xXQjFWbmtqcTZYZzY2VkVzZUZ2SHhUU2VF?=
 =?utf-8?B?ZVlUQ2ZjV2dNVUgyZmdiek1PL2x1eTlUK0RLOXQ0YjRFWnNPaEowdFByT0pI?=
 =?utf-8?B?YjNWbTZGN0hzR1BsRUs2N2dOY1FHRU9tZGpVMFJSeHBSM095NVVKc2l3V01R?=
 =?utf-8?B?UDhWemk4Z2pySE9SaHo5M25WaUNFekR2SU11dGtzUnpwbXA4TnJoS296bmpm?=
 =?utf-8?B?TFNKelpkeGhhRW02UjFUKzJsakFHa2ZzTEp4elhzNzM0YjJJRFZOL0VoZGxO?=
 =?utf-8?B?TlI0V1ROVytXZkFRSU1SeEFNWFBrRlpjRXhscWlGNlkzS0lhOG9kZUlnWlI0?=
 =?utf-8?B?bmpMRDIrdTJpcVAraFpkVzFMazRaOVNTN3YrOUoyY1Vpc1Vib0JsQWl6SnlP?=
 =?utf-8?B?YlIwd1d1eXZBeUFYckN3MHZHWk4wcS83dVUwMmFWMk82RjdqMTJ2STFGNFF6?=
 =?utf-8?B?djVLdmF2SGpZWkRPNjhKUUlDZ1N0WFJuY1VGbjl0SWhFNVJDbkNlQXVxalVj?=
 =?utf-8?B?MndtQ0tVem1NbFFMMVMyWkFhN3VYbGsxN3UvNEFNWk84QmZXWG5hTW15NnRL?=
 =?utf-8?B?Z2J1WXA0N2k2S1hXWGxrK2E5M1Yra291UmZTb2lKRkFXeTBzakVnRWxXZUty?=
 =?utf-8?B?UjkwN1lraHBybVpQMms0Q2plelpWbEFHaGdyMVZiSXBuYkt3Kzg2NTV1M2tl?=
 =?utf-8?B?cTFQMURXbGY1c0crNmZsUENycmxSMXJsdGZRc0xVM2hTdzNuRUlsdUd3WU45?=
 =?utf-8?B?UFB5SWJHcHBuMVNJcE43M2RYalhIZ2h1bzhrU2RmcVFPMmlGT3o0clR2SE4x?=
 =?utf-8?B?cktnQURYemRlRUI5S2tuRm1uZHQveTRvQmtocnRHSjRyeExadTdrUGgwK3Rv?=
 =?utf-8?B?amhxV3dkUm1VNmRjRDlUd0FRampQVG41Zm5aMnlyb2FxeFc1elpuNFhVZXpi?=
 =?utf-8?B?ODBudWNGU1RPWkptMUU1YnRRU01OODlmVm5uN1RVVXhwRFgySXhvTjQ0cktW?=
 =?utf-8?B?WUNTK0hYUkhSbTlxaGsxd0Iyb3JuNDRIZTZMVExpclJKZndoWDNGbHZLUUND?=
 =?utf-8?B?TGk3NE5EbXJtWFd3R29ZdkxBQnkxT1hKZCtJZ1JpRHhGUzlsZjhYZjlpWldS?=
 =?utf-8?B?Y1hyS2VQck9tYjZwNzBNek01UEdjQzdWNi9TaWhENDBQVEszZm54VThxMkhk?=
 =?utf-8?B?a1RROWZjNkVOUTNtRVh2WGhJV1A2K1B1Qy9TVng2NS9CL0xsL1RXQlhEdGRS?=
 =?utf-8?B?c29JM2RZbFJCNEF0ZE9STUx2eDJxdzBPVkFoc3dvVnorL2g4YVJPUU1jVlRF?=
 =?utf-8?Q?JqJhRUxwDYKeNnwE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e33f7c0-1e93-44d1-a25a-08de75834028
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 22:06:11.2574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p+IXidtWr0oHYlj48ZiwPclIOfy/gVNv8gbXLNvuysw1SPcOWjetKBsrieXn0S9z3mklhr4THnUjymW/33hhXWJ7FgoUxBAKGZ4oZqLP0q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC35D45AFD
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72092-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:dkim,dwillia2-mobl4.notmuch:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dan.j.williams@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 8F09E1B02EF
X-Rspamd-Action: no action

Chao Gao wrote:
[..]
> >Do not make Linux carry short lived one-off complexity. Make userspace
> >do a "if $module_version < $min_module_version_for_compat_detect" and
> >tell the user to update at their own risk if that minimum version is not
> >met. Linux should be encouraging the module to be better, not
> >accommodate every early generation miss like this with permanent hacks.
> 
> I realize there's a potential issue with this update sequence:
> 
> old module (no compat detection) -> newer module (has compat detection) -> latest module
> 
> The problem arises during the second update. Userspace checks the currently
> loaded module version and sees it supports compatibility detection, so it
> expects the kernel to perform these checks. However, the kernel still thinks
> the module lacks this capability because it never refreshes the module's
> features after the first update.
> 
> Regarding disabling updates, I was thinking of an approach like the one below.
> Do you think this is a workaround/hack?

Do not include logic to disable updates, document the expectation in the
tool. The general Linux expectation is administrator does not need to be
protected from themselves. The tool documentation can communicate best
practices that "time begins with module version X, only loading a
version X+ module from boot enables the safety protocol, runtime update
to X is insufficient". Administrator always has the option to proceed
and does not need the kernel to do extra hand holding.

Presumably this gap in the ecosystem is short lived and the deployment
of module versions < X drops precipitously and kernel does not need to
carry "disable updates" logic in perpetuity.

