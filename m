Return-Path: <kvm+bounces-18939-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 16F298FD296
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 18:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C90E1F21749
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 16:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88B57188CC2;
	Wed,  5 Jun 2024 16:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fqvNR58o"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F7153561;
	Wed,  5 Jun 2024 16:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604080; cv=fail; b=U/BV2cFJP0Gz62o2HSsMbpj6bnT719OHaIPfmNsq29XVj5RHz7xzngYilCRJdzEZW/eNVN2xlHdAudDrgmpBqQKUyTCIl001/f0grCbg4hn8qLr6aTZKh1Rw/k3shazn26I8IN5Fy0L0GsvAlv5N+DzVBi2J2EZIJAV9/MrQuGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604080; c=relaxed/simple;
	bh=S176runJVOVZEjzpvflSQzPVdgNHaWOKCAwIBpqi1Og=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RgYraBwpzi1kx1cPJbWxvDbr0HSn6Btq6aeW4S/rh+ieIKqoOFSlcblAukiS/HXPE1ZCoUd5GR3zZEjihCHAKUor51JGhZEbXL8KHQgpeuI1txloV3xHKcw6F2zFmZfT91fk+4PDJjhXk3iJR+9rDd4Yq1D4UDCbfcwodZEtsBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fqvNR58o; arc=fail smtp.client-ip=40.107.96.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=emwd6oOKDBbdyJ27B1zLT7EdhiqqXxpmAfsdvl91llXMDblhI1wJRNnKxgmpuJ9PwXCceonFpm6LpOcapvRoiQhm6XdzEpIuQt1vBcKEwNoy6Fs+jgsz3c5ubz110K2xQgtfkvxeUnlENMkYBi4BuPO3yIbaleqIwjMrtjXZgwz/lm2EVn9UPXFAy4m9itEoTg10OpacSrB9YJqWaVDaNEVdN8VxxgOMM0bOLg3HdorIkm8wDO6frpkz9bfKXgImYVqYdkdslA/RjcAOVhGTpLD3B70ka70i4C4iarKHC5nik2ORSc1XfZkkUq9SU6LBa6X3hkMvrOKXt1PrDY9sXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1Rsx5rql6SN7CHcT2zRO/X5Y7deM4sjmFB022/nr88=;
 b=dLdfjWJ1xSBHPXYSVLmomGmIGpsoiQARnxWSFwEXTutE3klvtjIiSGjA6onlbw2JhVOJRMf57LIShs56b0m+Z8k8XZ+IcTkm3fqfIORvjMwtql0nsa/83ZAU5Eikmr1w/JyqXcVYkBYj+vRw5YezSigZh5/goPOWBXTzXS7F79WYuDdgkJSBVN0RIzUSSHTFT+T8l/i50cQRVaCBIlS/6XtlUPojDff5hgoY4iEFwkg+6k0p7UXdvYATYMvX2tq0UgAyrDlEOd9EDazS249xu/scWttCuYqyw5Lk6dqRMqPlzgOW2HUipqus3deon48xGgxXZwE0nsUfKkyImoTrLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1Rsx5rql6SN7CHcT2zRO/X5Y7deM4sjmFB022/nr88=;
 b=fqvNR58oxEE3N7SP/DG30Ycp77pugEGFUkBuuXTa5cbAzJo0G2Oa5/+ol1bAlIdeXhiBZaE12pigjO/t+Mce1ZtJbeW15HaNcz3XS4f3P/iolVidIEKBLH+d8/WMB/0hNGx3zn38etFRgjpkaVeWnnxMNFK8gPYi2vCcXmhbkp8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by SN7PR12MB6768.namprd12.prod.outlook.com (2603:10b6:806:268::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Wed, 5 Jun
 2024 16:14:35 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::5e9c:4117:b5e0:cf39%6]) with mapi id 15.20.7633.018; Wed, 5 Jun 2024
 16:14:35 +0000
Message-ID: <59381f4f-94de-4933-9dbd-f0fbdc5d5e4a@amd.com>
Date: Wed, 5 Jun 2024 21:44:13 +0530
User-Agent: Mozilla Thunderbird
From: Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [PATCH 3/3] KVM SVM: Add Bus Lock Detect support
To: Sean Christopherson <seanjc@google.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
 hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
 james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
 j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
 michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
 x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 santosh.shukla@amd.com, ananth.narayan@amd.com, sandipan.das@amd.com,
 ravi.bangoria@amd.com
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-4-ravi.bangoria@amd.com> <Zl5jqwWO4FyawPHG@google.com>
 <e1c29dd4-2eb9-44fe-abf2-f5ca0e84e2a6@amd.com> <ZmB_hl7coZ_8KA8Q@google.com>
Content-Language: en-US
In-Reply-To: <ZmB_hl7coZ_8KA8Q@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0032.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:b8::19) To DS0PR12MB6584.namprd12.prod.outlook.com
 (2603:10b6:8:d0::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|SN7PR12MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: 20166cc4-f6e9-444c-a402-08dc857a9661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bnk5aDRid3Q5YmIySm9way9YZFROVXIzb3BnLzFWV01sWGtoV2F0T3hmamp3?=
 =?utf-8?B?NG42QlJPK3RZM0F4cE83amNkVzFMZkRVZ1FqT2JNNkp0VThyRnlmKzNwT0FZ?=
 =?utf-8?B?RWNod3RmbkIyTFRCazViZFlKWmM4QzFaMlR0aUxlbEkzL0Z1RTJ6c2RTRGE3?=
 =?utf-8?B?QzJWcFE1S2lIZGpyYk1kT2VVa0ZaOEJXNk9qT3BKcitzUkhFTnZFRUdaemlK?=
 =?utf-8?B?WDlQODJwa2c2eHQrdlljbXl5dEZ3TDV1bnZSeDE2UTVQbnJKMVpmWUtXRXFW?=
 =?utf-8?B?bDVKd2tHK3pJbW9hQlVldTdxUmxGQUduT1B4YktuK0VlbSsrQ1NZUllWZFBC?=
 =?utf-8?B?WnA0VkxRQzNncmgxVTc1aFBLK2hld3Eyd3VSMmxCRHNUa092VFA4ZXJRbEt0?=
 =?utf-8?B?VElqRHZ6NmNKY2VZb0xtRlZ4SFNuRWp0bSt5ajlPSmtQaU1Cc0J3dzcvZVpv?=
 =?utf-8?B?WGxVZjd1VHRTKzVMUFo2KzdiMS95YjJMRURFVkNOWU92ODdxNEJOdEp4ejA0?=
 =?utf-8?B?by9RUlVpcUZ2U2lJS1VESk0vRXd5UTF0Q0tNOU01dnJFWnl4OW9Va1JyUTVR?=
 =?utf-8?B?MWFjYTlCQ3FxaDZ3bmRLL09UMHlxYXhVMldTaTRnSEJoQXJ2K0krK3Z6dUhC?=
 =?utf-8?B?NUdjQXRnb1hrZjMwTzZKWkljeFhwR3c5cXZxaVVjd1FMeU9CSDAzVDRnb2xK?=
 =?utf-8?B?WGI3SHdEYzdoeldzTE5xT0p3dHRtNUF0ZzdXMXhTYTRGb2tWYzJCTjNZRzJ2?=
 =?utf-8?B?SXFPaUUyNzFEL3UyMDJYaXIxK21mTW5wNVdoc253ZFJBMmtlcVdmSFQxbEM4?=
 =?utf-8?B?R2F3WkIrL1ZxdzY2YVlFRWpiUmZNOXRrOFBFT09sSnJBaXQ0SkE0TWFWMjNM?=
 =?utf-8?B?Q0U3UUwxUzJOeDB6V1MxcFhmUkhPSkhYcUJINGdOUzhDZU9qQnNXa0tBd0JE?=
 =?utf-8?B?c3FoQU9ZcjZkdTBiR20xelNVYTVTWlhVaC9hVEdIdFpjS2x3NyttYWo1VTB4?=
 =?utf-8?B?OUxCUVRMeVlmeVcxZEVjTUNZS3pxK1lwMzF0SG1oNi9ib2JndmU4bjl2UG5J?=
 =?utf-8?B?cW96cDJ3YkdoeitRZ2dGcHh5QkJ3S2Q2WXdyZDdBblFqUVpUYmR0aHpJMSth?=
 =?utf-8?B?dlRrK0VxYXZKWmFPSy80TnJoN0NUKzNIOHpudWJZdmZrTjJPOElGNkNSRS8v?=
 =?utf-8?B?Sk1IY1JlaEFMNk84anY1OHBvNUdjbko3SlNZcHFvUzdFVXJkd1ZBeTBxdWhp?=
 =?utf-8?B?Q0NYOHhKb0ZyZnk4Q2x0aUJSSzBHd2FXQStPa1Y1amRxOUhLRzlxMDJ0bWdR?=
 =?utf-8?B?ZEh5TUpSZTd4bFlOU1Exb0RqZ0FLT0dMYStFRUFxZmRDbmFvYVFXTVA5N2hT?=
 =?utf-8?B?dk5YTU1leHZRbmNyZSsweFZEclEveVVoMGRNWnkzcXVqZ0dTM2c0bWhHaVVI?=
 =?utf-8?B?dU83L2NhdVJCU1Y2ZlZLMk5ncDgxSnFCb3lKWlpQc0wvS3Y0TzFva0ZJRmtN?=
 =?utf-8?B?NFM3S21pY3crWXhMVFNMUyt4YlBYRmVKZ2pOYW1NTEZsNTluUWVKc3Q4eUo2?=
 =?utf-8?B?eXBvcHdQRUZMNENaYjZwY0J3bkRNZzYyYTlSZzdDWjl5aXZhNWdkL09zZENR?=
 =?utf-8?B?OXpRZEdZdTNWUm8zVkJ3QUQ3NmNkOG1PSkhxSHF0ekFsZDNoamczd3lvSXI0?=
 =?utf-8?B?T0lOZUlwTHFrbjlRNGdNVW9aQmZIMVlRK0hSUUwvU3doRlUvaHRFcHI2R2N0?=
 =?utf-8?Q?VsOSg33dY70o8MN1uR+g0EyMI/+s7Xdf0vBIjFt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NWltT1dHbkF5REVGSzB5UHhBSzVjYWxEalpmV1pIMG9pckphTGwvQ2hWcXdB?=
 =?utf-8?B?UkgxcG8vYUhua21nc3hDTm5DTlMwN3JDN3JETHF5elFsYVZKUXZnUlJEZ0hi?=
 =?utf-8?B?TmFlajZtdUplK2cxbDIzWGJqSzdQV3NOajgxMkhSRU9LMGZKdFo1SXVHbDhM?=
 =?utf-8?B?Ri9FMzFkNElxWGhERGhpYkVWei83a3BRYkowajl4QnNEVEV6WGl3UW05NjZ6?=
 =?utf-8?B?KzBYSU1MNElPNDVxVWh3aGVqRnNNbFlSOWZuWlFaMkI0UWY1VkthK3FxV3Bm?=
 =?utf-8?B?Q0RVV2J5Vzl1ZzVwaXV1UHVmZEFWSTVlbU1PdklZN3Frbm4rZ2paT1FQYlZX?=
 =?utf-8?B?OTRDRWFHRS9qTVR1MDd0WjFwUmh1Y2NuVEhzRXY5L0VPd1UyUkdDMmxRdHln?=
 =?utf-8?B?dXNkV2g5UWV1cGZyU05WNVVDWlR6aGJoZGZoN0x2cUZ0RVcxNGtKSzQzaUxz?=
 =?utf-8?B?cEZRMjdxdE4zSHVPRzlDc0NMMmZyd29UcDAvWThZVjQzWDFVY3J3NktoTzRF?=
 =?utf-8?B?UjA1bjliT0NMLzNibGc0VHF3dW9kWnpSc2hVV3NjQjNJaTZ4TTZkQmlxMFdV?=
 =?utf-8?B?NzVMdUpjbFV6NFRZQ3NhNzB2clZKOGRTcVhuY0hiUHh3WS9LKzFLOGJlemtE?=
 =?utf-8?B?WVhjTVdkQU5oTXNudWJQV1dZMDlSUVhvK0s2NjFWZkQ0SDBSWjBmMHRnTU5s?=
 =?utf-8?B?RVpITWZZV1MwUzlLTTc4eGRxMjlHUU8wcjBZcGNKTVkwRDgwUEQ4RnpBSlRS?=
 =?utf-8?B?bmliQzhnTERBMlE0ZmY3UVJFTXRhS3dTZFRhazVJc0h2SEdpM1JQUFVGaUZ6?=
 =?utf-8?B?Zk1sbjJ5cTZ6a0phcVdPRldFMS8xL3dRTjhJTGJ4bGM5bWFmQjZXcVludHpK?=
 =?utf-8?B?WnhNVWRZKzhKU3dsU01tVjhGNFVDdHN6S0dmdVJWVWd2QWhjYnBNYm1ET21t?=
 =?utf-8?B?RlRzbjdwMUQzSFlObk1JU0t5RVdLdXdMd1lFWmVsc0dOMWdxWHV2Q2FWaGlS?=
 =?utf-8?B?ZUN4bXZKUHpNTTA5eFpDNHhQcEM2cTZIRDJrQUEwckVGNVdMbFdyUEZhb1k1?=
 =?utf-8?B?MHBFdTBubjRSS1JsWTNMUFJJekxxU2hsdUIzN1N3bldOUTYvR0lwcTNJdWk1?=
 =?utf-8?B?N1h1Y0hmSmFTM01vZjJrRXpTeFIrL3I2ZHFkc0lKNzFSRGlQRm5kMEFGaVBW?=
 =?utf-8?B?a250YVZVTjNTdWRZRHdlQ0dROVpMR0dyV1hYVFZPeWc3L3c5WUplWXhkZE1X?=
 =?utf-8?B?ZHdWd3RGMVpRL2Z2b0FXMlo4NjhLbjBaUWxac0lwbWtHR3dlaUFSQnhhbkxq?=
 =?utf-8?B?WnMxL0xvWGVMUldZakRwcExhUjBOZjRRRWpuUzdLTStyV3lBYXJTTER6MGlL?=
 =?utf-8?B?RldnSVQzUkxHd2JJVjVyMjhOVS96SC9ocFRTcEJHNFFjbUdMaEVreEsrc1l3?=
 =?utf-8?B?aitoS0ZiYzdFOWZyZVA2L0xDWkhIYnRUcjNicGRDU2JvQ1RPWjNUaHdUNzBT?=
 =?utf-8?B?c1RJenpuVkZJUkxLNmliZlpBNGQvVDZxbXU0K2x1VXduQlkwWEhQRnZtaEF3?=
 =?utf-8?B?K2s3RUdNTVkvR0g4dERFQnF1YkhZWUphb25YVEk4K3pEQjliYTdPTmZWV1hO?=
 =?utf-8?B?d3lQUU5CZSs5SkdLOWVWc21vK0Z3eTBQc2FrL2Y1SllFbUFmbUxHTVJ0bjFn?=
 =?utf-8?B?SlhLMzloNDAzb1FabHMxZ014SXZnZkpPa0t6bXMvbXFpR1N0Q2wxbFRIa2NL?=
 =?utf-8?B?bzZiZ2tRQUdCR0hoamhUVXBEQW9xOXQvbG9VYjFBWmI5emxGcURnWWJnZzFT?=
 =?utf-8?B?aE9hV0FoVVF6NEF4Nkh2L3p6Ny95T1U4aHBzMVNOUzBiaFljL2g2Z3BjajNU?=
 =?utf-8?B?YVJ5TytNRGdxb0VYbkNxbTR2OTBhUVR2R3ZhMGxXcTRJdm5Vb2JKY3ZVa3lN?=
 =?utf-8?B?aExXWXNLUnlib21aRkU4d0JjN2tGOUx5SXkvZnVQVzNwYlNEUEx1Z3IzV2ov?=
 =?utf-8?B?em5GbTg2MituVmltdWRXUXRycVNJSFZ2bkl1U3JFbFRIRHVETzZpaU52UFZG?=
 =?utf-8?B?NStXVHJMT3pNR25oeW01ampzOHFxRnZqTEJhZGV2UW5ZNVVYeTJLdlRRbSt2?=
 =?utf-8?Q?xaKTPcFSX3E4KQiNuY8mk62yG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20166cc4-f6e9-444c-a402-08dc857a9661
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6584.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2024 16:14:35.0925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jlR+MxTtiBiBHGPxZBnEDxRhOEiWE2Ik67NDZzs1DN4jCUSWZZKCTRs+KIHh6iItalwe4ZRZ9qb/gpE631Zxhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6768

On 6/5/2024 8:38 PM, Sean Christopherson wrote:
> On Wed, Jun 05, 2024, Ravi Bangoria wrote:
>> Hi Sean,
>>
>> On 6/4/2024 6:15 AM, Sean Christopherson wrote:
>>> On Mon, Apr 29, 2024, Ravi Bangoria wrote:
>>>> Upcoming AMD uarch will support Bus Lock Detect. Add support for it
>>>> in KVM. Bus Lock Detect is enabled through MSR_IA32_DEBUGCTLMSR and
>>>> MSR_IA32_DEBUGCTLMSR is virtualized only if LBR Virtualization is
>>>> enabled. Add this dependency in the KVM.
>>>
>>> This is woefully incomplete, e.g. db_interception() needs to be updated to decipher
>>> whether the #DB is the responsbility of the host or of the guest.
>>
>> Can you please elaborate. Are you referring to vcpu->guest_debug thingy?
> 
> Yes.  More broadly, all of db_interception().
> 
>>> Honestly, I don't see any point in virtualizing this in KVM.  As Jim alluded to,
>>> what's far, far more interesting for KVM is "Bus Lock Threshold".  Virtualizing
>>> this for the guest would have been nice to have during the initial split-lock #AC
>>> support, but now I'm skeptical the complexity is worth the payoff.
>>
>> This has a valid usecase of penalizing offending processes. I'm not sure
>> how much it's really used in the production though.
> 
> Yeah, but split-lock #AC and #DB have existed on Intel for years, and no one has
> put in the effort to land KVM support, despite the series getting as far as v9[*].

Split-Lock Detect through #AC and Bus Lock Detect through #DB are independent
features. AMD supports only Bus Lock Detect with #DB. I'm not sure about Split
Lock Detect but Intel supports Bus Lock Detect in the guest. These are the
relevant commits:

  https://git.kernel.org/torvalds/c/9a3ecd5e2aa10
  https://git.kernel.org/torvalds/c/e8ea85fb280ec
  https://git.kernel.org/torvalds/c/76ea438b4afcd

> Some of the problems on Intel were due to the awful FMS-based feature detection,
> but those weren't the only hiccups.  E.g. IIRC, we never sorted out what should
> happen if both the host and guest want bus-lock #DBs.

I've to check about vcpu->guest_debug part, but keeping that aside, host and
guest can use Bus Lock Detect in parallel because, DEBUG_CTL MSR and DR6
register are save/restored in VMCB, hardware cause a VMEXIT_EXCEPTION_1 for
guest #DB(when intercepted) and hardware raises #DB on host when it's for the
host.

Please correct me if I misunderstood your comment.

> Anyways, my point is that, except for SEV-ES+ where there's no good reason NOT to
> virtualize Bus Lock Detect, I'm not convinced that it's worth virtualizing bus-lock
> #DBs.
> 
> [*] https://lore.kernel.org/all/20200509110542.8159-1-xiaoyao.li@intel.com
> 
>>> I suppose we could allow it if #DB isn't interecepted, at which point the enabling
>>> required is minimal?
>>
>> The feature uses DEBUG_CTL MSR, #DB and DR6 register. Do you mean expose
>> it when all three are accelerated or just #DB?
> 
> I mean that if KVM isn't intercepting #DB, then there's no extra complexity needed
> to sort out whether the #DB "belongs" to the host or the guest.  See commit
> 90cbf6d914ad ("KVM: SEV-ES: Eliminate #DB intercept when DebugSwap enabled").

