Return-Path: <kvm+bounces-27714-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E06898B307
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 06:27:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D1CE1C22CEB
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 04:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC1C1B78F1;
	Tue,  1 Oct 2024 04:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="QZkSZ8mY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2069.outbound.protection.outlook.com [40.107.102.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B891B5EA0;
	Tue,  1 Oct 2024 04:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727756776; cv=fail; b=orxGcz9dX2610O9SPxTWeJaTEdwSpiFm20ei4OK1ETCB79LZjth8BzbPwrSZXWB99aM3ALZ3FGLCiaeBiCKyRQXYwZhQ/Gez2WjZ5jsBZkV91giNYla5VDRO5cvDs/DJgATWdKIMoZ6Bz6OzGrRsfxPiSadg3bC8XyK++7xqxk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727756776; c=relaxed/simple;
	bh=78h4+EyaqpALSP9ca8yTcfyYx4zDrh/5P/oZ7Wi8p8Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oKTKltrw7s0ZAZUPkeDu+eqREh+KZU2zIHtgD7BQA7/tAru8ivJMvGTBV/nbmLyGWhploOu+7XsiVscVBSoqbdgTa7YrQCfmDVfsTPYxetHsBHyTM+7a/9870zUr+E2lC6QVM3217/mH+EKrZrRDykYy1CiJ5oHFdsY6bByii3s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=QZkSZ8mY; arc=fail smtp.client-ip=40.107.102.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oz6et8i5vqFXPc7SmWEyJ4jZermaV2R++OESWr/Iao6P3Vg8FbnIFr/cERaNS2n79yd92HshPoABTgRLnHgLhp0+u2YrHHMY8If+IVjwLO/RMz5gH5m/SLncBy/t2QTMLoZp+j9y0gEBGppDgDIZ3TZC/Z3fsvyg+FPz10MtEwoJ0dVRRr6ZE1d2eVKmA/9yTQBLeLaCXfAbKX2nesXDPtKGQrIY1+rsruxdmoaKSF6AX1pgq8f8jShTswHy4QnHszy4aYel2Tic1Fn6+dRS3GSpJDojES8x3568yq0qprK38w2sBzyaUkmLFX+kQseYbhwhPamRKBdP9MUUfdCnng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ucy2OAb+70yd5/aTC1VxeqaYROHq8vk64Wk52DLoyis=;
 b=rSXoeHuP9Nc2OxpeGZKF6cm81N/Oo7cqW6KX9sMaTnwJrfHHxDi+ViV/Q4p9qHepNOyXnbsVhClYYoyLTGZAqQdjQc1Xtjb0CupLl+dDkTskSVZpQ2Jcb8f/J1SQAhUKoQRjqKw3CkczMXsy/6/YVNtS5kQSZhiP5JMzA3dG5CyW7CDsA6LlE1lG+g6pE/k8xl7ilQ5gFqWu05Q33D7QGvmwfz2KFu+txfBpxY3Mp6ER+8wSvQHtNaZDXLi4Yn4hO9O/UBPTSPpT+g95xe+RiZGQmIMn8GceZxN/bum/QujTHig4rmkNUceRnQD9QoSkFQ+m0Eft/1m1BmGj2yVaHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ucy2OAb+70yd5/aTC1VxeqaYROHq8vk64Wk52DLoyis=;
 b=QZkSZ8mYzdzoU1dX5edz7IvlRnzCxfbyuc134cf/87uEsR9hEnXS+nIKxKy3J9vUDRIMY9LYoih86W4i7/Yg1DEnYU3U86HQCPqNaNLW06PfaPYAOSVHSAxzycvg25fuzfle30/JHO4UT4xbeZelxjOb245Uad8ea+FXuR8eiRE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB6738.namprd12.prod.outlook.com (2603:10b6:510:1a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.27; Tue, 1 Oct
 2024 04:26:11 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8005.024; Tue, 1 Oct 2024
 04:26:10 +0000
Message-ID: <156dc1ab-1239-0508-1161-ab0cd13d35b1@amd.com>
Date: Tue, 1 Oct 2024 09:56:00 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v11 19/20] x86/kvmclock: Skip kvmclock when Secure TSC is
 available
To: Thomas Gleixner <tglx@linutronix.de>,
 Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, bp@alien8.de,
 x86@kernel.org, kvm@vger.kernel.org, mingo@redhat.com,
 dave.hansen@linux.intel.com, pgonda@google.com, pbonzini@redhat.com,
 peterz@infradead.org, gautham.shenoy@amd.com
References: <20240731150811.156771-1-nikunj@amd.com>
 <20240731150811.156771-20-nikunj@amd.com> <ZuR2t1QrBpPc1Sz2@google.com>
 <9a218564-b011-4222-187d-cba9e9268e93@amd.com> <ZurCbP7MesWXQbqZ@google.com>
 <2870c470-06c8-aa9c-0257-3f9652a4ccd8@amd.com> <Zu0iiMoLJprb4nUP@google.com>
 <4cc88621-d548-d3a1-d667-13586b7bfea8@amd.com>
 <ef194c25-22d8-204e-ffb6-8f9f0a0621fb@amd.com> <ZvQHpbNauYTBgU6M@google.com>
 <64813123-e1e2-17e2-19e8-bd5c852b6a32@amd.com> <87setgzvn5.ffs@tglx>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <87setgzvn5.ffs@tglx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0111.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:96::10) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB6738:EE_
X-MS-Office365-Filtering-Correlation-Id: 87b9ff28-a494-4037-1f83-08dce1d12d17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NWhwak9IVXRXMWlCTTRYWVdJMEJwbmsrMkFMNGJuZkwya252MVV5aU9mZ2pO?=
 =?utf-8?B?LzlQWXdtemp3anUvTWtOcFU0dm1aZmxXL1FyMWZLN1BoNlhieWx5ZElqVXpu?=
 =?utf-8?B?Yk9mUldqTFJGNkNBYnRJVnNUS0k2Y0ZMUzE3N0V2dXlkR1ZwbW9sMEtIUjBo?=
 =?utf-8?B?dzVBcW9mRXEvS2Z2eFlTa2V1a00xbTR0eFVRZVljSUNIMnBGemh2dXNuakxw?=
 =?utf-8?B?aVhCcnFIbFo4bTNMNGlJUkZTbGJMUXMzTUlsQXFwYVYwcDBKQzhqVmhYQ3RW?=
 =?utf-8?B?V3QxZDRCM2dIZFJmYzkyWFQwcXREWlpVMis3OVYrZjFsOFV5YTJOd1hLZnV6?=
 =?utf-8?B?R2FUWmtVTEF1VTdtbUk5UTZTZlBnTWt1dW5vbzlNd2VKNFdiL0lVK29KS3BX?=
 =?utf-8?B?WG14RlovQnZhKytsYmJJZ1AyOENuZDVYdXptMnRGdW1JSmZRWnRNTW1EczRk?=
 =?utf-8?B?UG1JaVNDUmxnYkxZM2loRDczSC9qek5rbXRjcVlEbFdsOFhPbkQxY2RiNXo2?=
 =?utf-8?B?ODBJRU9BR2lYRzBhVG52cEswTVM0WVdhSHpSZ0tXWElhdENjcGY4dHhuOW5U?=
 =?utf-8?B?WU83T2hnR3JTTmZvZUluSHpjV0ZxNzdGeXFCbHdhb0xHZmxaVENSMGpCL1hC?=
 =?utf-8?B?RHM4RmRYMEdWUXluWTN0SFJOeElWcmRheklTSnBQMHpxUlg3cTlTa1pFdDhl?=
 =?utf-8?B?QUFFWjhwL000b2d5eWNHOUNTRTNTemRxVDUyanJha0hldlFERHlxSmRhdnk3?=
 =?utf-8?B?Z1QyY0QrdWlCTHorZC9rOEZQRUM4TW84blhLR05YNFdNSFNWbGVZTWJ0dHZM?=
 =?utf-8?B?NERrRmhkQzAwdExHaVdycGsvTGVzd3V3QTJKaU5HMnRaT2VBQXYvWmJpVXRx?=
 =?utf-8?B?Q1JWMlMwdUgxS0t2V081dE5oUU13UytWUXVZUDNYOG1pWXFhbTV6ek1MR3pm?=
 =?utf-8?B?QkFpSTJUTzhnYmZjcEZSWTA0VEFJb2FvSWlKVlcrdzByTXM3dlUyMmtCek9E?=
 =?utf-8?B?alZYQ1hRRGtwbjRUQzlEOXJZckhXcTZ5ck1lTnd1d2s4VFR5VGdicFVCNGFq?=
 =?utf-8?B?YWw4bDlsc2E1VnVvMDFRTE5DZHJDL0VYcXZJT0tDVTFtNW0yOXNIbUtVWHBY?=
 =?utf-8?B?RXdaSVpvRFVnUXcyMnc5YlBiSGt6WEJOMW92YjBDZkJhcUZZWXUxUDNWcEIr?=
 =?utf-8?B?UXVNcVY3ZU95L3dwZVRXV0dvSHZDRG9RTHRMbzhRUlVtckltcjFZYXpRYng2?=
 =?utf-8?B?WjZoa3VGWnhDNy8zSjFtYXg3NDI5NmppWml1ZEZSZklhY1d6QzVDSWcxNVdZ?=
 =?utf-8?B?ZGRFTXhKZTY1eGEzTEljWTU2RVh6bVdiRlNsa0N4ME1ZcFhWVnRoSlF5Zktq?=
 =?utf-8?B?R0NpSno5ei9LT0VjeTdaRG9WeTh2bFFwZGRUc0JrQmlFandwekNLT2s1QzBi?=
 =?utf-8?B?eGExZm83dUhmNldsbmEyK0xCYzNKclB4VlBSQjVlNUxJMDloL0NwM3BvOVV1?=
 =?utf-8?B?QmtiSUVRUDNQK2JjVEQrWWQzTFRpaU4rYVJJUGlUNDNvTG9ZZEx5bFpWWkxz?=
 =?utf-8?B?dmF0Mi80THZMNGU2QmozZkxEN3ZZUXptLzRYU2pIQ1kwb1BJOUdFeVdRMG96?=
 =?utf-8?B?ZUdDQlhnbVR2aXhNcEZWb09YTjAxODlFb1RJSnlxQS9uYVIxbE1CTllremxQ?=
 =?utf-8?B?WnFKTm5neWVzL0FsUS9ZQS93VVVOSXZ6MGg5KzNUdjJVMCtSZ2dxT3BLSldH?=
 =?utf-8?B?blBXNHgyN1licVI0aTJyZmMvTi9iK3pkanp3RXljZVZiWkZqMmlkZCtxVEx3?=
 =?utf-8?B?VnJ3RFBGOXo4NTNWTDBOQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L01NSzFaRnpGNW5LWHcycHVXRXdWSHRmTXU1ano5TktwNDB0Y0t0Vk05MDBF?=
 =?utf-8?B?SytFTGlYMGtaVWFLZ0tzZUpUeGRKNVNMdEo4Y2ZQcW5vZEE2MTlydFcwblBi?=
 =?utf-8?B?WU9XU2JtM3RVKzA1Vnppc2dGU2J6QjZ1YWRFbGlseW9ZWkl1UHJteWdORXFW?=
 =?utf-8?B?QWxyQTBoWWcyQXJnbk1KcFk0elAzWTV2ajdzaHRPRTNtNWFPSUJLaGpZakVM?=
 =?utf-8?B?OVBLVWczRHBQOGlOUmxFMCtTc2FMd3hhSHh5YXNocitKaGcvNE01a2pLMU9z?=
 =?utf-8?B?dHlkbUhXQk8wODFreDlKMHlZcWxwK0w0cnpRY29pc2kwYUI5dFpnRVBrN2cy?=
 =?utf-8?B?ejdvOTJXQTJVUWxwdi8zaXQvT1VrVWkvUjk3SGV4TjJBaWliU3ZZcVNhamQw?=
 =?utf-8?B?dmg4WkdSL05jY0lUeUlBcDRFaTYzTjhZcERtUE5FcGJxNVQyTzZRVkk5VlNU?=
 =?utf-8?B?TVhDb1VIZDN1U3Y2aUJ4RVNGSVcwTXJCNHFwc2ZTMWdJYzkzZ09LRWgxdVhJ?=
 =?utf-8?B?ZzcyL2JZcW9nM2NEMFlXZHdrc2g1cElqU1NBczJ6T1YvYnY1MjRFVlNYcmRv?=
 =?utf-8?B?L3RJbWc3bUFHQWFGSnVZWFlYWjgzYmlhb3RKNFkzVzN1bit2em9Sd3ZzU3dN?=
 =?utf-8?B?dVE1VWVrNTMra0hOWmpUUmRUNVU4NzFYY2U1UkJzeWMzVEQ4V29jeEh4Ulkz?=
 =?utf-8?B?cENSYzdBYm05ZUdCenBkcElMVFdNaHlmei9pQ29lWDJsOEN1TUl6Z2VsYkNh?=
 =?utf-8?B?RjgrL05teDlZNHZJdlpiNk9aa3JuZGQrdm5mNTJBbmFUaWlERWNTZk1OVXM2?=
 =?utf-8?B?NmwxQmNuaVd2RFEyMm5VWFh3OU9MN0Z4MVp2M29adjF6U3VNeEx2dG5TMmxt?=
 =?utf-8?B?MnZhdUs2WTdVaWlubjI2OVJ3aVE5N0hnVUtxTHFZKzJJcE9ISnRHYWVhTmJj?=
 =?utf-8?B?SnhGaDByQnI2ekYycC9JN0NQWVh0MEJNMXQ4eXpIdlc0emU5ckw2QzljNUo3?=
 =?utf-8?B?aFRrS1A0Q3NoNUhjWVpaWjZPdEVQeVhFUVQ0VGcrRWhrbXgvZU5pTERpei9E?=
 =?utf-8?B?dzQ4ZDhERmpuM2dXRDlCTlJ3WUExa1ZEcERNbWp1U1grNHozRHg1b0o4akx6?=
 =?utf-8?B?UXZyYmtLMll0RERha2xQK0hBdlRxeWFmMkhJMkkvSVJQS1FGdTZvdWdVYTcy?=
 =?utf-8?B?Q3d5bEprMGhlYzQ0aG5rczlXRHBpNkF3UU5Uc0szRTVVdlhkNnpSQTdTdWdT?=
 =?utf-8?B?UmtMZ2ZWQW8zZHVNU2JrUEJ0ZzZ2eTF1b2ZBdmQyUzNja2xCemR4dFRXdmFx?=
 =?utf-8?B?NTJkMnJ4amVXT3VPKzY3dTJ3WkY4L2l4OFFSTG9DelBYN29HZWZqSlhVeTgw?=
 =?utf-8?B?RXFBYWs0a3JvZ2ZzaDY0dFN5NkZHZkVpNWpoMHBZUHdNZGNWWjk5N0g0SjhO?=
 =?utf-8?B?WXE4cHh0bmd6K3lzU2VlMFEvbW9JaGhROUxiVzZ4dUh3aEdKdTBmaDFVVEVJ?=
 =?utf-8?B?Q1NHZlRYZUpHaVBTS24reXNWTUVObmYwOEVkWDF3Tk51UHhBY1hnY2ZNazNL?=
 =?utf-8?B?SndhSVM1Y3RNUUdGSVFRalMreDdJRDVxamNQQVJrR2JPVXNUeWNwSXY2a05N?=
 =?utf-8?B?Z2FVSldqK2toNCtDQW5PQzNTMFVVTFRGSjdKbHk5TGgzL21mcEVOVkJGWHYv?=
 =?utf-8?B?QytyTjhZZDFtbTluRmY0K3hWY2M3Z3NidkN3R1VIT01FQ1RVL0d5VE9UZWFs?=
 =?utf-8?B?M1RNeE5EdEQ1VlVvVEpmOCtaWnNKWklRZTFPZlcxL3Y3UG8zazhpa0lCQ2Vt?=
 =?utf-8?B?ZGM1Uk0xbWlIa1dWeU9Yck91RkorMDNhalpCaDBoaGk2TUpLLzJqNER6bkhH?=
 =?utf-8?B?Sy95VTRsWkVzVnpvYUZIZ2pVREppdTI0Nm5BeG9sYlJYbFRueHpUTFhkV25B?=
 =?utf-8?B?M1l1TnRaemdXVTZyM0hGWENtT283WVAwTEF3Y0c5OGJ1dzQrV1NVWGJWTlZk?=
 =?utf-8?B?WXlmS3YxY0I3aEd5K3RQeEtCdGN4SG1KekkxaktRQ0VxNlRFd01jbjdlc1pN?=
 =?utf-8?B?YkhiZ2Nwa1NoU2lDeGxmL2VUdWczSlhpQUlFNmh4aTN4MHZHKzF0VDdKMmoy?=
 =?utf-8?Q?JDjjqc15hsd3zvt3UF9eQYKht?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87b9ff28-a494-4037-1f83-08dce1d12d17
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 04:26:10.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B0Zz2MuURw8rWJ/hNAjiAYRIc8Ln3umvD22d2GF4KnogrL2Zt6RPVxMz2ljKzfC4/bMp4lvP++PZdbeDUzQnAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6738



On 10/1/2024 2:50 AM, Thomas Gleixner wrote:
> On Mon, Sep 30 2024 at 11:57, Nikunj A. Dadhania wrote:
>> TSC Clock Rating Adjustment:
>> * During TSC initialization, downgrade the TSC clock rating to 200 if TSC is not
>>   constant/reliable, placing it below HPET.
> 
> Downgrading a constant TSC is a bad idea. Reliable just means that it
> does not need a watchdog clocksource. If it's non-constant it's
> downgraded anyway.
> 
>> * Ensure the kvm-clock rating is set to 299 by default in the 
>>   struct clocksource kvm_clock.
>> * Avoid changing the kvm clock rating based on the availability of reliable
>>   clock sources. Let the TSC clock source determine and downgrade itself.
> 
> Why downgrade? If it's the best one you want to upgrade it so it's
> preferred over the others.

Thanks for confirming that upgrading the TSC rating is fine.

> The above will make sure that the PV clocksource rating remain
>> unaffected.
>>
>> Clock soure selection order when the ratings match:
>> * Currently, clocks are registered and enqueued based on their rating.
>> * When clock ratings are tied, use the advertised clock frequency(freq_khz) as a
>>   secondary key to favor clocks with better frequency.
>>
>> This approach improves the selection process by considering both rating and
>> frequency. Something like below:
> 
> What does the frequency tell us? Not really anything. It's not
> necessarily the better clocksource.
> 
> Higher frequency gives you a slightly better resolution, but as all of
> this is usually sub-nanosecond resolution already that's not making a
> difference in practice.
> 
> So if you know you want TSC to be selected, then upgrade the rating of
> both the early and the regular TSC clocksource and be done with it.

Sure Thomas, I will modify the patch accordingly and send an RFC.

Also I realized that, for the guests, instead of rdtsc(), we should be 
calling rdtsc_ordered() to make sure that time moves forward even when
vCPUs are migrated.

Thanks,
Nikunj



