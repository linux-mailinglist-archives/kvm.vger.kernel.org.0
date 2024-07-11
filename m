Return-Path: <kvm+bounces-21398-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B54D992E2BF
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 10:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D92521C21E5B
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 08:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F5A8154C09;
	Thu, 11 Jul 2024 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zErAJkpP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4728A12BF02;
	Thu, 11 Jul 2024 08:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720687928; cv=fail; b=LBxjs0/OxjGpGPuxJmR78M6SPfMPPMT6vS9IoQUz++uea6cuhfYq05ivW2IrpccBa+hiT1z7LNxZnd1avTWVqbHpe4dzCoTCrZdV8q9gtqN9iMmg3xJAs5U3XQKFwAG8OApAiZ9Se8FhHVgcVLWpbhAqO25Gg64IzM1hpei+ICs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720687928; c=relaxed/simple;
	bh=8yKK/Hgs7BP/J32vmscNxeYlL7JoJPJav21ozi8xEKA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SjUxIslWGrTWq+rO9mQKtzyq1o4RhCW997VEMukFmzvJs+EUTrdtdWBCQmnQUDQQsnb8FYedBdnLNDlnOwYUfUOLnKhMnWaRRweXzXgIpiak/u84BHsDEWW7QXYJXpthM9yXL/+eBu66etuAI3qcEkUAnioF2uWDlMstUBJjGBc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zErAJkpP; arc=fail smtp.client-ip=40.107.243.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BNQIjaJhcb2P2NQdFMM7JpJlIiMFWsGAneqozTkbVrevjDWD0eDyjblpm1vqxLG3rU/AR2DoR9wzeEnTuEVi12Oi1QVeTW6FuGSd40iUJZdR0PMcXSh2xlvFy1ucuUCpjOmcExeq3abwlfIR2XltOaK2qXbpLfJyEqkRZsllqrN7vEAnB4epTQYnhLa3bxxkZ3GEkS3UVMGYoOfgHHcLCeTTNuTHnKnxjBpPsKG3hCS5fh0RCVKjcvuHjlDN5HRlFKmg/bLNPt8/6gmjgTNltdLOE1oD79wxk5b9yxh3yEKwn/niEwf7UnCBp6jq5cIyi+OFlb0RhOBGb+G1gnLumg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vv0RBLPoTTKa2bz+sJmpb3xcz8rg61OMTLHTrOGv41k=;
 b=smLL7/dIZdqdtUIeWB4Ye0xJDQ6qzHkw43INPcZs+EAy04AnZ3ODbTshCpS6tgeF/h2cBnDNUmBadUYY7y1hxHv7p04OHduybfKFEOtUZ24ktf28KnU0O5QsMFX0W/ArF3dDgFrndEmcrbAA63mNgf1i6smYs4k+gCiM7qrJEOa4DNJUSFGPT26kgQyAqKrGzMOz/QORfHMOl+e+mJa1UtxH2KVroiCnxs7ja0FCEFv3BAnxrCTWrPmt8A3A6YRvoQfGNlGWZulGa3hAd4iuZiDiu2Dxal0YNYvYGJWojsHw1cJ7U7QKJKAckrehu7oJ+diZCK1V4nLuU/EdQD+rMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vv0RBLPoTTKa2bz+sJmpb3xcz8rg61OMTLHTrOGv41k=;
 b=zErAJkpPgao0LuDvvFobn4pwYGY92E6DkXUKOE0QWesKG38osxpjNnVHiNyUG6wQPUCZg6DET8GvdxghXvcnxTFmCu9DWYugLuVWBQ4vgdwOOLPC7d9gUUxuD1GNWFlMBATeJzi04/f+qRNZI6JVfcP43QziDw7wOjP9Q6Ic+Jw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by PH7PR12MB7454.namprd12.prod.outlook.com (2603:10b6:510:20d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.34; Thu, 11 Jul
 2024 08:52:03 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%4]) with mapi id 15.20.7741.033; Thu, 11 Jul 2024
 08:52:03 +0000
Message-ID: <735ced48-969e-4a62-8506-667a7491f4c9@amd.com>
Date: Thu, 11 Jul 2024 14:21:41 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>, Jim Mattson <jmattson@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 manali.shukla@amd.com, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-4-ravi.bangoria@amd.com> <Zl5jqwWO4FyawPHG@google.com>
 <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com> <ZmB_hl7coZ_8KA8Q@google.com>
 <59381f4f-94de-4933-9dbd-f0fbdc5d5e4a@amd.com> <Zmj88z40oVlqKh7r@google.com>
 <0b74d069-51ed-4e5e-9d76-6b1a60e689df@amd.com>
 <CALMp9eRet6+v8Y1Q-i6mqPm4hUow_kJNhmVHfOV8tMfuSS=tVg@mail.gmail.com>
 <Zo6RxnGJrxh9mi7g@google.com>
Content-Language: en-US
From: Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <Zo6RxnGJrxh9mi7g@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0133.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::18) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|PH7PR12MB7454:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f8462e0-7521-4a54-091a-08dca186bbee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QXprenp0cUVkWVlKaXVKcW10V3A5OGJaTDFoYnJSQ1MxeVhpNXU1Tkg1Sm8x?=
 =?utf-8?B?cGs2WUpxVnBFUFBnL0hIWGJJcExpdlYyVDdoOHJvRFVVZHBvN0xvNGlPQXk5?=
 =?utf-8?B?ZU8wcytlZDF1VVBSQ2ZIWndkcFNhTXJCUm0rZXI3cWxDQVNWVGYwQU1BUE5E?=
 =?utf-8?B?Qk1FUEJSVmV5WmhPNW9JQ0VDZW5zY3dNZFZ4ZmY3SllRMCtnVU1ZYlRyc0Ro?=
 =?utf-8?B?UHMvelQ2amRLcDFlUlRvVjB6SEp5NnZvK0xxZEpPdm1MNEoxc3JsUTdsbWk5?=
 =?utf-8?B?a2dsQXlzN3h2Rmo3ODdaRnlBM012OGo4NjV2Q0ZSQ0k1ODIyUU5pTzM2U1dh?=
 =?utf-8?B?RWZ0M25xQjVOOExxcS9kOU9XeUIwcENpeGl5bzJqOEgveXpUMHZLL2xoR2Fi?=
 =?utf-8?B?RW5nVU9KUWRlK0tObFpzTVBCeEVDS3Y1TnhrNHBpOXA1UVhxeFo3WVR3SHJ0?=
 =?utf-8?B?d1FHQWlJQTFCMUhNYXgyM21Ja1lYaG9KZDhnYmlyOUE0NW5RYmZnWWM0QTRr?=
 =?utf-8?B?YWtYTTYxb3QxMi8veGNJdk51b3N3d0FEdzloa1JaOFpYWTd0eURQNEFBWm5v?=
 =?utf-8?B?NU44MU4yaE1TUXpnem5pbHhzQ29sWGIwOXhaL1hsOU9UVWoyZmYyUGxxUmt6?=
 =?utf-8?B?MUVhVzRmNGxHblF2MFp6dTBTa3NsNU1HbFhBd1I0V0xjeEtsWXlxZTFsZGNU?=
 =?utf-8?B?SHNnYmZQYXVrelVVdDcxUHBEMUNKUGMvLzhheWpKZUtUMlNGN1dpU0VMWVRB?=
 =?utf-8?B?TGFzMWNteElvQXpMYm50bncySkh1M01ONEpGbGhLVUpRcjJLSXJlNUxzZlJw?=
 =?utf-8?B?UXNsd0ppcWZJYVdNa0tDbEdlN2M0M2ZERjJhZUNoWEYvcnhVZ2w1cmNkbW5K?=
 =?utf-8?B?Y0t5Ukl0bFhKRGVNSzJ1Z3h3dFFDT3lDeTU1cDJuSmdaSFBDYUd1Wk9DNXlu?=
 =?utf-8?B?UTM1dEdITXp6QitEVDkzbmJ1dXo3UjdUSXBNSHhHMVVtOFRieG42WVl3L0pw?=
 =?utf-8?B?TGg4b1Faa2JDb2FueG5ubStkaEs3UzhQRkRRUnBsb0hSU2dnM2hFQ1J0WjRZ?=
 =?utf-8?B?SFhJTUZpUWxIYWQ1SjZheCs4eFZEZjF4c2YxTTZaUmVXQmlkemwzMXplRkZq?=
 =?utf-8?B?RWRKQll3VjQrbFNjOEtRa3ZmUk5QZEhsZmtkZU1hNXpIQmlESmRIZnMra3FJ?=
 =?utf-8?B?eHREYTRIOFZtQm5LVWR3S3ZvZFM5TERhQVdKRHYxZ1dieXZLTTVPZnNVbFVz?=
 =?utf-8?B?bGI1NnVnVlBncDhVU1M4MWhXVHR4Zm50ckt6czZaWkF4TG5McEJibUxEcGY0?=
 =?utf-8?B?TEpEdXJBVzIyMEorMlZaUmdFUVlaa0tQakdNeUFTb1BFOFMzUkVocEdRdWxM?=
 =?utf-8?B?WmVVR0VDckJCbXhxUFFSSDU5TituOE1KbXFVZkRFbnlITUNxMTdQaktFQXdQ?=
 =?utf-8?B?blBvUTJKYmFCNzd5eXNWSzJIeDFtVHFzaTF3eWxCOG4yRmFMeEN3RkJwdlJY?=
 =?utf-8?B?Nm5ZM2N6RDJOdi9qK3ZMYUtNUENaSG9aOWMxcDZyK1dXbzhvanNETGxjV09X?=
 =?utf-8?B?VCtSVm9ZaHF5M2l1Q3Q2bEpnOERJRGFzclVKNi9mTUo5TjB1eWpsbmNubzl1?=
 =?utf-8?B?T3c4Ri9oWTdGRXBDQVFDMHV3TDJqSFRGZ1hRSWt1WVNPekdDQk9tclRpd0M1?=
 =?utf-8?B?bVBOYjhuRktScHVFaDBWak1hQjVsN1crUHhsRmtScklTNnY1ZHJmck9TcXpU?=
 =?utf-8?Q?DBvIG4kijqA040w/Qk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVBiSzRnY2VBRnpudUpZUFlMeC9jVGNMVWRTNHc1bzFuNklrMUgzUFNsNS9P?=
 =?utf-8?B?ekF6YU1Uc200WkFyZHRYNnBKbDdibC9ySHgyVWJHMk5QUFVPYUZvRnU0WjR2?=
 =?utf-8?B?ZTJBQmFpeElqNjBsTHJCVVJSWERBQTlkUm1keFpoaGgybGFTOEh3UjdRRlBj?=
 =?utf-8?B?Y1JPVk1EQ0x6bUxseXhFdk1vOW90SVlSdm04VlBLK2RYcG1kYXBRUlVuME9k?=
 =?utf-8?B?TXJtU0h6a1ZuYWJzWlV3UE13WnlzSk44Y3ZiMEdzZW42VXN2TXpMWThwUGM1?=
 =?utf-8?B?a2JHdkZwT0dGUG10aCtleTVaMll4Qys3Q1I5RTlzQ2ZKSEsxcEsySVFEcGxz?=
 =?utf-8?B?cFdvZkVPaG5mOHFIWDM0cE5wRUFNVmhuaFpWcWVveWNaNnBzeHc0WFJva1Vq?=
 =?utf-8?B?NGRDNEJHZE0xLzhjYWdsMGJyYVpMaFljcnlQMm05ZnBWWlYwRVNjTG05djRw?=
 =?utf-8?B?ejNkVnB5THllNzJ4ZmtrRGtZQ210VjRYcGNqekxCaE1rYmFRZEszSk41MWE4?=
 =?utf-8?B?SkJ3T2NsN3RKT2J0Y3dYd21XSDM4bHd1MGtuUTRINmtYQThrUWt0Um1QaUN1?=
 =?utf-8?B?ZVlkVDJ2bkc3b3NSOXQvanRxZUwvc1NMSDJuOTc1VzZIcnU0R0ZjUU1BZWhJ?=
 =?utf-8?B?QWNtSFYweTEyWGNwemtCaE9zZUp6L05CM2daQmN1NUhkZHBJRXpmU3E4VTIr?=
 =?utf-8?B?aE1nbURPdnhXdXY5UzlDOWNjQmwxK3ZTOC9vVUtBa0Z5bmFJK2x4c3BCcGEr?=
 =?utf-8?B?cmdEL0F5a3pIR2dlVXBKTHFKK01PNzg4anRVTXlQUWpjWTdzMk16WEdDSytx?=
 =?utf-8?B?bGViU3FiSWxnU0VJbkJQbW5JeDN0TWpBTjV0QnVNNXRTRDF5VDJmTUFTRHlq?=
 =?utf-8?B?WDVwQVBvKzJBSXlFK3l1QmRsOEpyOHI4Ulo1bVdhQjUyQm1aZi8xUnk2aVY2?=
 =?utf-8?B?Qmg4V0ZRYTBQL1pnYUF5N2RLOXVDQ2k2cTc5YTZPN2FURmZ1UDNNZXlpOENr?=
 =?utf-8?B?YVpCQkRrTzhDK0VTbVV0Q0FGWm1QU1Vua1k2YzVDd1hHdFY2UTlNNmcwTDM1?=
 =?utf-8?B?TnZOaVNHeUQ1ZE9GR09XeHFpYS8wWXZWTWoramErKzJuQXBLRTJHSlczeDgx?=
 =?utf-8?B?UG80czJQSDVhdjVvMy9rOHozK2txN3dZMlhYRUw5VFZ1Tmx3akl2U1FGSnhH?=
 =?utf-8?B?TlhIYUkzOFFub01VR1dYMUtFSlJjbzBIeEtMVE9OZ25teEo3YTVFM083Zy90?=
 =?utf-8?B?bm1yK3haQ1UwdTFXUFJsWjdYQ0FoKytRcXB0V21Zc25YZm9XTXkwRUkzU0ht?=
 =?utf-8?B?Q29kZGhCVXV0b1F4bk91U3U4MVp2M095U0lpcm5hMlh5emxPMENSVThwLzU0?=
 =?utf-8?B?eFQ0RDRJV2MxTTN1WDZ4dlhkcnowd3Yzd0J6WlpnZHM3aERObG1pOU9jaWdW?=
 =?utf-8?B?cFdnUFJYTTFXM3VZSVlMVk5mM0VXczN3WUxQNjdtRkFNZzJpMzM1eW5FV0dF?=
 =?utf-8?B?K2lKS0tiOVYweCtoQkxBeGY2cHJCUmphOWpjU0p0Ym4rZ0xTcVE2TGhaRnRY?=
 =?utf-8?B?bTltNitnUk92eFd4ZEY4Sko2dHk4dnRwU2J0dUNHYkxXckJxcEk0ZlhWWWht?=
 =?utf-8?B?VHIwZzRyV3R0UCswYTVmaWpFcUllZXBWK1luanZRVHN3bjhVWkpYODYwWVE1?=
 =?utf-8?B?NEd0QkFQaUNXcEpGM1BBL2pFMTZpV2l1YW9rSW11WnFpNTFHZzlCSHArL01Y?=
 =?utf-8?B?MzhrRG0rTVNucTB6WmpDWEFobUR4TDFFZ1A4d2xXZGxZK1paNXdMMjB1REVm?=
 =?utf-8?B?SUc1bmwvMFkxR1M5L0dJOGQ0ZXlOQ3RPNlZidXI1dUE5RHBsaXVpMitzZWJo?=
 =?utf-8?B?ZEhwNnRYRW56cjJKWEUvdGVIRVpSeXEwOEx2bm1INXFhUnJ2TEFQSGFoRCtT?=
 =?utf-8?B?MW9FNGV2Q3BOL29nRGQvS2QwSkIwUWpDbk54cERXNjV4SlUzKzZ4RWVmRytO?=
 =?utf-8?B?eDBMaEJsOGZCOUNtYXZQNUw1T01vY01Vd3pPS3lYcGdJek0yZ0VzZGxEQ1lj?=
 =?utf-8?B?cTJyNmxnZmJ6UytMMWhybkhObWltVkRHVVlhdG53Y2h0WFRDM0Y5QXlMVkgy?=
 =?utf-8?Q?E4ficYA5/l8wos2GolRzQgTyw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8462e0-7521-4a54-091a-08dca186bbee
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2024 08:52:03.4410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fH+Iv+I7RWXLIDoYRzVJ3yEbGiMvKRmnlF8W3m0iYK5zz9URIa49+mVp9VJC18a8vg2Sjum64YrYlT3QLLGToQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7454

On 10-Jul-24 7:22 PM, Sean Christopherson wrote:
> On Tue, Jul 09, 2024, Jim Mattson wrote:
>> On Tue, Jul 9, 2024 at 7:25 PM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>>
>>> Sean,
>>>
>>> Apologies for the delay. I was waiting for Bus Lock Threshold patches to be
>>> posted upstream:
>>>
>>>   https://lore.kernel.org/r/20240709175145.9986-1-manali.shukla@amd.com
>>>
>>> On 12-Jun-24 7:12 AM, Sean Christopherson wrote:
>>>> On Wed, Jun 05, 2024, Ravi Bangoria wrote:
>>>>> On 6/5/2024 8:38 PM, Sean Christopherson wrote:
>>>>>> Some of the problems on Intel were due to the awful FMS-based feature detection,
>>>>>> but those weren't the only hiccups.  E.g. IIRC, we never sorted out what should
>>>>>> happen if both the host and guest want bus-lock #DBs.
>>>>>
>>>>> I've to check about vcpu->guest_debug part, but keeping that aside, host and
>>>>> guest can use Bus Lock Detect in parallel because, DEBUG_CTL MSR and DR6
>>>>> register are save/restored in VMCB, hardware cause a VMEXIT_EXCEPTION_1 for
>>>>> guest #DB(when intercepted) and hardware raises #DB on host when it's for the
>>>>> host.
>>>>
>>>> I'm talking about the case where the host wants to do something in response to
>>>> bus locks that occurred in the guest.  E.g. if the host is taking punitive action,
>>>> say by stalling the vCPU, then the guest kernel could bypass that behavior by
>>>> enabling bus lock detect itself.
>>>>
>>>> Maybe it's moot point in practice, since it sounds like Bus Lock Threshold will
>>>> be available at the same time.
>>>>
>>>> Ugh, and if we wanted to let the host handle guest-induced #DBs, we'd need code
>>>> to keep Bus Lock Detect enabled in the guest since it resides in DEBUG_CTL.  Bah.
>>>>
>>>> So I guess if the vcpu->guest_debug part is fairly straightforward, it probably
>>>> makes to virtualize Bus Lock Detect because the only reason not to virtualize it
>>>> would actually require more work/code in KVM.
>>>
>>> KVM forwards #DB to Qemu when vcpu->guest_debug is set and it's Qemu's
>>> responsibility to re-inject exception when Bus Lock Trap is enabled
>>> inside the guest. I realized that it is broken so I've prepared a
>>> Qemu patch, embedding it at the end.
>>>
>>>> I'd still love to see Bus Lock Threshold support sooner than later though :-)
>>>
>>> With Bus Lock Threshold enabled, I assume the changes introduced by this
>>> patch plus Qemu fix are sufficient to support Bus Lock Trap inside the
>>> guest?
>>
>> In any case, it seems that commit 76ea438b4afc ("KVM: X86: Expose bus
>> lock debug exception to guest") prematurely advertised the presence of
>> X86_FEATURE_BUS_LOCK to userspace on non-Intel platforms. We should
>> probably either accept these changes or fix up that commit. Either
>> way, something should be done for all active branches back to v5.15.
> 
> Drat.  Yeah, we need a patch to clear BUS_LOCK_DETECT in svm_set_cpu_caps(), marked
> for stable@.  Then this series can remove that clearing.
> 
> At least I caught it for CET[*]!  It'd be nice to not have to rely on humans to
> detect potential issues like this, but I can't think of a way to programmatically
> handle this situation without incurring an annoying amount of overhead and/or
> duplicate code between VMX and SVM.
> 
> [*] https://lore.kernel.org/all/ZjLRnisdUgeYgg8i@google.com

Sure, I'll add a patch and respin the series.

Thanks,
Ravi

