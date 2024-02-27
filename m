Return-Path: <kvm+bounces-10013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51B18868689
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 03:03:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74E691C21D4C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 02:03:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697E5F510;
	Tue, 27 Feb 2024 02:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b01ymH29"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798954689;
	Tue, 27 Feb 2024 02:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999388; cv=fail; b=A0f9t+KacEgSK1g3LCGxul20d1pLTf25mIjBxeOsV/LWxz1Mg7gXulzoK/Q0Uo+e0MQVKoHQReNwBzP9Mgf9dOeTLtalCU6AVq1y0zTXJcrixSY7Ph4Oa4sKY59MPbeZHumQmUpMYblvtcFU/4H/2bfBNcUeyuFgr12BrxkL6a0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999388; c=relaxed/simple;
	bh=kPzYuTy4VW2tXE09yKQjxhJy3orn9lp1OblGjAJlnVc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=psDI/nm1iv7gzQfGpEMxPSDM33NUbHi49lsqvtsoXaK8dHcDAVzhwBnClGYkN/Hao0JniEPi/uusmema396J116PpHs6bSq17gwOq/R5khWHCXPpxJVUQn4EJpeugZbvfhceuG8coxcQBrc/s3/rNV+kAVRi/t0vVMtR3feK+Ag=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b01ymH29; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708999387; x=1740535387;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kPzYuTy4VW2tXE09yKQjxhJy3orn9lp1OblGjAJlnVc=;
  b=b01ymH29qXBzIQNaLl+5PbQBji1kuuuv+3W2dp0Ti6tcgIlZ4DlIoIVV
   eT8oqBDJBtptcK6I+d8PQXE021w6mru2VpvXMX7E1wnirI0A83h1h0RE6
   ErgigLmqP/3YoIdmKo+1r8LIpFkXyrd+whT7Xk03ePbTItud0EgSfevL5
   RAbhtRRBjLG/ZgpVDafN4qBYCEwBB9+yCdwxy+RmlKHmqgOibfKkbTVMm
   ILLxgjg6qvbEasK/ETnMv8d3VtUoAyC0SAw2tumakpPqVaPPRlDgrbUI2
   GCklhqsM0Ho9h3vVSbL2sqKaI5Ess+2tBlEYu2I2Lq/t8RbozO+hW7y5A
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14469559"
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="14469559"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 18:03:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,187,1705392000"; 
   d="scan'208";a="11489525"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Feb 2024 18:03:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 26 Feb 2024 18:03:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 26 Feb 2024 18:03:02 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 26 Feb 2024 18:03:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTk44qBXgzTa5T5H0fsHmDzcgbhmwXHljVLvEWRX2T4vpAFoIu3fuaaakp5X1y0P6jnHVPYfu5Simag/U1pilRsw5i4rJx19zrK6B1HJsPxeoNVS67smKlnw3D4YBK1AjNXO80K7G/AGO1r/icTyqM9xt5eADLBAaHDTTfGQBzdEpg8vWqbmTx+WAsFfsERhrxnQicrYZMFjDHH4C1BT11/8vw1Is+E5ukx8EGeeIGOurvpzxR4VoJ7LfpI87kWIXavPI30SoL7u9u6N3mW/37aQhtt31zJtzdA1ZO9DlG7flDJvFp4ntdGWX0oO5WJVWyI/K73CxChA3zzBeJCRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wuCDSfOh1LDOfPf2z4S3q+ieDZXPWw7tc1Z3yu4STwE=;
 b=E8auvZ29QiHB8a9RTipALPS6a+8JHRkmFwnCo9G84wR8xHt/B8DBDVc4Bd0hmIRzS7RYPKGYJZYsMQTVTZZE6hKrQos+Nb/t0+vFgfw7yISvqE5xOsOZgpygGnVMZQKA28FW4KOxkLb2QGVFoweSix8/meUPpsLOoXui6Ev0BB4nLBmhPLzIBlC6rx2+PNdZC1QCuWlUZkxjV/B206qMo/VmqgUIE24DkWrv7kyMQolWVGHgHK7E5f2IK6QT/F3TiAkAtrXJYPwliBjRzjMSfeE2e9nPB3M4zqb2Alu66L8XsEdgxLYptcHnd8FlohjWUiJvyJ/3CtvdHDFFT/34Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4820.namprd11.prod.outlook.com (2603:10b6:303:6f::8)
 by LV3PR11MB8696.namprd11.prod.outlook.com (2603:10b6:408:216::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.19; Tue, 27 Feb
 2024 02:02:58 +0000
Received: from CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b]) by CO1PR11MB4820.namprd11.prod.outlook.com
 ([fe80::65ce:9835:2c02:b61b%7]) with mapi id 15.20.7339.022; Tue, 27 Feb 2024
 02:02:58 +0000
Message-ID: <ae4c477e-b61f-4816-972a-7e94c9625905@intel.com>
Date: Tue, 27 Feb 2024 10:02:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or
 TME
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Zixi Chen
	<zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, "Kirill A .
 Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li
	<xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, "Ingo
 Molnar" <mingo@kernel.org>, <x86@kernel.org>, <stable@vger.kernel.org>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
 <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
 <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com>
 <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
 <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
 <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
 <7e118d89-3b7a-4e13-b3de-2acfbf712ad5@intel.com>
 <3807c397-2eef-4f1d-ae85-4259f061f08e@intel.com>
From: Yin Fengwei <fengwei.yin@intel.com>
In-Reply-To: <3807c397-2eef-4f1d-ae85-4259f061f08e@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0001.apcprd02.prod.outlook.com
 (2603:1096:4:194::10) To CO1PR11MB4820.namprd11.prod.outlook.com
 (2603:10b6:303:6f::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4820:EE_|LV3PR11MB8696:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f57e31e-f6d9-4c38-df5d-08dc37383883
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Foh7UeQnGerVuIgROfPinXP5plETH2ciNGc0vaPcxpABqNpquF30EHnvi7Xlvtz5xdMcBMeM8ccc7aOOZ3buYE2bkAuGKE3bVS+yI5hDneQahWZozXtzNcflug6BoFXBZ+TxdIO4GAwjmGb5h4gx0kM80Q3vskH9AYa4KKBA4dgNIc4wlrFT+wMHaAR6vpV3cXpMFCO8TkJUxGE3yz/ypEWgZaMumBEpIWORe40Be6v20Hv0BQTPjTytgUni30pj2ocPeB0r+xalw6R1vKIpYyy25koLEl91KupiFKjDGeKeikPxU7hW1U7cmBVNHBk6yVdAJXbDrfRvk0Ve84VP30LslAzTkzTQCa7SMjsg8pOlrQxhbE+C8+gOUuio9GBcTBSiqBIVt8BFtqZWk1XbOs3LLZl43zYIXR7w2DYPFyLYU7Auey7ATKYRQ1jeP+A/BNj/ct118kIZPxHLZRdToJC6ibHayMUpoeQNiCw4DUGBeZtEYZAg2RutlGc6Hel5p+W2bfcYXIG6uGLgoSGrGy1dzdsJT4EIBiV/uUN8pfg78Bl13FggRVbwXX7O861MyIQxLcPZcuj6mt+TPuMQqh7vS4GwIAfrn/XvicVH+fHjHTrWIaH+u88lHsz+7Zw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4820.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkFKRk83UjRDVll4ZnFWSHU0VVdEczhRZXJGRWltVzUwZkEzdlg0M0x5QVFt?=
 =?utf-8?B?R3R3eklRTGRJRTMrQmhvc2dtNzN4ZjB5ZHpBTFg5TitJVGp4WWNUektsRFFj?=
 =?utf-8?B?VVZUQkdkbTc5UjBhOXV4bFcrelVudDBpOTE0S1F6b2VoblNpbVVSU0I5Tis4?=
 =?utf-8?B?VmhWOWtBbm9WQ0gvR1ZhMDdmMEk4MkNFU1FCZXMyQmdiQlJKbEhLb0ZFNlhP?=
 =?utf-8?B?UjJuaEtKSUtwV1FjZjI0YzM4cHpaWWU1SHl6ZkxsS1E3RUtYNFNRMEh0QVNU?=
 =?utf-8?B?QTA5eXV3TVNKcDdDNy9zbzU0emVRcTErd0dHZlhKV203MGV0VHhtN2FWTVRV?=
 =?utf-8?B?YldSSjV3Q3ArQlRzRFVBZUZ3TnBEcmk4YWwzYnh1NnpLZW5sdURRSkRYOGNJ?=
 =?utf-8?B?QjBNOUlwTmgzMGVGVks0VnJ6RHRKb3JvZGZ5bjNqRVJJdENZckhmeDl4a2Rh?=
 =?utf-8?B?d2NuaFQyRDhNUGo5TlRXUmpHZFppR01tZHNNWDJPNFR5VTNHV25LYTNpaFJC?=
 =?utf-8?B?cGgrNGdldExKTkRxeWt4bFo2TnhCVE1lSGFrUjBJL3BxR0wrQmh5cGx3R1BR?=
 =?utf-8?B?YURtdWtmME1sbDlUbS9DbEg2V3BteVphQmtvY1R4MDdzWDJPSnhjSE01SFZ0?=
 =?utf-8?B?VG5ONzdCUStkTkpTSjhNM2xIZ1RLS0Jhd3g3aDVGLzN4TzFPUnZLekxxMEg3?=
 =?utf-8?B?N1Q1WEkrSS91SDJkS0RBMHhFMnlObWhLY0dYV2VjYTE5S3pSc01tTlZSQVoy?=
 =?utf-8?B?ZDF5MXhSbE0vT1cyeHN4RXNaQmlNWXlyeVg1N3BZZzVjVFQ5b2wvSG9TVFFi?=
 =?utf-8?B?aitDYitHOWUxL3F3SmFlcFVybnl6NEhxZmpUUGUyOUZkUjB5Tkx0U05UVWtv?=
 =?utf-8?B?NjJ4T0tkQVBwL1ozWmJLWVQ3bm5JSkJBb3Y5RVhZVzA0YXQ3RHR6b0FHR3VB?=
 =?utf-8?B?TkthczV6b1RKTWhVU0s4Y3gyT3lkbHRqd0hGaUFZUjJaUHplanFISU5BUnpS?=
 =?utf-8?B?aDhqVTI2SUFyeHI1TXVrNSt5OGhHdmt6V1VVY0xEamdUMW1MNUpVVFU1TU5L?=
 =?utf-8?B?MVdyTWZGa1YzNmxvMnk2YmdvR1owZWc5RjFNZU9ZTEFxL3dlT2xpWUVnVkxW?=
 =?utf-8?B?ZjNON3Axa2xpUTdvODNWSDdCeU5BeEIzM05hWDJUbGVZTS85K2ZaK0N6Z3RP?=
 =?utf-8?B?dUd5RmxSRW9NZC8xK0ZNOWo0VXVoUzFSNnhyY3d5eEN2cVk1dklCOHNLVmdn?=
 =?utf-8?B?dWw2MEVMSmwrNFkwTldHV0p3MStIenlCZHBQdGV6ZERrMS9tNTNoTU42VHQy?=
 =?utf-8?B?NFFXTVJ6UE9Ud2VraDdQT1dWT2R2UXcyNk5WN1F3NmpxM0hiOEFsKy92OWhL?=
 =?utf-8?B?c2hWOFZPTlpaTk9vZ0dpTnFxUFFjd25ESCtpQWhzWGNMWGdoZ1hTUEVXVGtl?=
 =?utf-8?B?L21yUjF4NVMwQ0VrWXlvRUVLN2c2STFzdnFpWnZvQkNQOUQ4RHc2NVA2THlC?=
 =?utf-8?B?c3l6UjJ0UGtTMHVTNTM0cW8rdzZ2K3BhNENHOTRiWG1mRytIL3Y0cDFFY2pv?=
 =?utf-8?B?ZmxaUEx1V2V2UkZudHBjOUN0S0I4L2pwcVlNK0dMbjhVdzlQK0JqUEpRV0ha?=
 =?utf-8?B?Q1JTQ2JicVI4N2hJcUk1U3YxWnpPaTI3ZXdaK2ZWNHpEc0pjVXh3WHd3dGll?=
 =?utf-8?B?UllVdDVVbjFLazFaamQxMWdoVUhZb2NyNGh6RDl0ZDkxTGFzYmsxK1Y2Wkl0?=
 =?utf-8?B?azhzWXhTTmozbGpGY1Vpc0dJVStDSHNBVWNtNHRJY2FRcVBTYUtSZEFMdDB3?=
 =?utf-8?B?ZFFLWDZCQ2lHazRjcDhEanNEZVpPMG10S2U0NzNIZEo0Sm5XR0RIcDJRUCtV?=
 =?utf-8?B?YVdXQWp1NWxIMmlkQnhSUjl0MkRuSnljekpsdGMvcGpDWnIvZ05qR0dyOWNB?=
 =?utf-8?B?MDVyMlNoOHlJaytUdFNNTmtpSkorbWVSbVl3NjlFbWxGcEswL0k4c2RVam1E?=
 =?utf-8?B?S1dxb3Q0YXh2MDdHQjMyQTh2U3M1OFBTcTJNUGsrOXJjR3pzVHk2c3BDaDNI?=
 =?utf-8?B?WXQybmh6c0hnK0V6bU9RUGZVQzNrRjZyZXJPaHFnZTBBRW04MFpvMUlabm1H?=
 =?utf-8?B?M2lJYVJHcUhIZkgrYWcwYUExWU5NV05oVzltQmpOdDhmVHRhRENXK1QvbWVQ?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f57e31e-f6d9-4c38-df5d-08dc37383883
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4820.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 02:02:58.6769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QjmL7PID5KXweS7yE1ZodZCgmVNhoy2igkPgS1h1+jfqX9q0hL81OBsINePe3vnfTE6X2rJzpEv44a/LvY8pSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8696
X-OriginatorOrg: intel.com



On 2/27/24 00:21, Dave Hansen wrote:
> On 2/25/24 17:57, Yin Fengwei wrote:
>> On 2/23/24 02:08, Paolo Bonzini wrote:
>>> On Thu, Feb 22, 2024 at 7:07 PM Dave Hansen <dave.hansen@intel.com> wrote:
>>>>> Ping, in the end are we applying these patches for either 6.8 or 6.9?
>>>> Let me poke at them and see if we can stick them in x86/urgent early
>>>> next week.  They do fix an actual bug that's biting people, right?
>>> Yes, I have gotten reports of {Sapphire,Emerald} Rapids machines that
>>> don't boot at all without either these patches or
>>> "disable_mtrr_cleanup".
>> We tried platform other than Sapphire and Emerald. This patchset can fix
>> boot issues on that platform also.
> 
> Fengwei, could you also test this series on the troublesome hardware,
> please?
Sure. I will try it on my env. I just didn't connected your patchset to this
boot issue. :(.


Regards
Yin, Fengwei

> 
>> https://lore.kernel.org/all/20240222183926.517AFCD2@davehans-spike.ostc.intel.com/
> 
> If it _also_ fixes the problem, it'll be a strong indication that it's
> the right long-term approach.
> 

