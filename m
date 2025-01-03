Return-Path: <kvm+bounces-34523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F2EA0076D
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 11:10:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E034A163E83
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 10:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B22071F8F11;
	Fri,  3 Jan 2025 10:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Sl0PvRYU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2074.outbound.protection.outlook.com [40.107.223.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417521B3929;
	Fri,  3 Jan 2025 10:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735899017; cv=fail; b=fPiXUiU5LBLo9hgE8xQD0FvvMXPr5ePorWTL2v+lTmjqrurYf4VoT5SNPjEudJd2bw+1BrMnHsz6hjzc71IeX4wt6mIA7Ox/VbHxh6UsHdFdfRZF3px8IAn7wMhdwtF5wB5iL0dy0su8EakCPlGfevmwp2s/c+BI2YOrR2gTj6c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735899017; c=relaxed/simple;
	bh=ivS6xwJZgxR1ducWTP7dFmRUjujKk6c6HP/c+rW3Sh8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Qibw6vJMys4imVUpajGTLYXHSHTMR1Js7slgfIIVEd0aWy5eOk6WbMECKjCQC2oNdRpdRkoqlVJ3LmbzfWMpRd6p68lnNb9hrRFCS4oIWsgeawD5kKJTJEDewrnTK0j7YoiQlpF3bPVEc3H0SAZJ4yPU6pfgbrWgv2tWMk2yNmQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Sl0PvRYU; arc=fail smtp.client-ip=40.107.223.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYVhqvXe8WBCLJiASKglN3Jw5vumtNHuyEXMRuRAOLSCv6hWf1E7qxRWSMqCXH4XpYg6bDUZvwEHGL3KwETXohZKod+6SQFvMPuuaNKCx0MypWNLH8iZeLluTa+eFq8YrXE4xi2Y1h5XibXXV6i4eld/BRxksjO3tLj8SX3tTfhEHic3NXpVfuIDxfjSjOmbHLgu5YrUQBhGXqde3nqwLUg4gmoyyJj2fNxejFSknIsU2Gmm6sHgunLL/al8R4w3P1EludfqBbrovk5yoNq2w+VzfUJlLjNkoKUUC9gmAtRbt+jWItMgnDp47ozFguEp+H9CU9st3YZX4vhjrGkbrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QXUcsz4ZDTv5RhaDH8fZkcqiINR/akbrTIC3DC7xUyw=;
 b=C+HwBuW2YInr1xBNTR8HU/rM92fsMw66s3RGW9bLv6Anx1F8vDolPvmRRatkusbQ31IS53o6vL3tkI4aXrZgkE/dPFOE+wsDlZ15BHb1NfcKXeTP+uIW4OXbgQSu+sBucxzMe6/LpaywUJI1dTxr34BrBEU3Lgd/lxYJecinKB7bympimPpjW1a/aZRtdKBV5nNyun3CU5ASxwmF3Ldi4ycA3VZNKnW1ZwuEUdcQtNV3PmB6Rh2Wr2su6k1uVlQy9IvwMMacM0xme2Vr4LhMk031zZgWr4jkxEbnJMGqcN0EIEW4ylv3p5MDQd80afL7uXkworrhOu9Rs4dBtSJC1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QXUcsz4ZDTv5RhaDH8fZkcqiINR/akbrTIC3DC7xUyw=;
 b=Sl0PvRYUjkcBVGhXaD9N6DXnQbUwcYmX1qYnB0AN7JgsiLnktCeBPcB3ojJCZj/xZFDsh64bsQOsqGKMXLCKTQOTRblNsd0N/NWoevWdqbg6x3yK+cZBobg8Ix9TQGAZJVAouh+dQFfEgnSiyUuxcL+GV82xvfKAi6T4v0PvZtA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 SA1PR12MB8644.namprd12.prod.outlook.com (2603:10b6:806:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.12; Fri, 3 Jan
 2025 10:10:07 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%6]) with mapi id 15.20.8314.012; Fri, 3 Jan 2025
 10:10:06 +0000
Message-ID: <2139da61-d03e-49b3-9c7c-08c137bcf22c@amd.com>
Date: Fri, 3 Jan 2025 15:39:56 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 10/13] tsc: Upgrade TSC clocksource rating
To: Borislav Petkov <bp@alien8.de>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
 thomas.lendacky@amd.com, x86@kernel.org, kvm@vger.kernel.org,
 mingo@redhat.com, dave.hansen@linux.intel.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com,
 Alexey Makhalov <alexey.makhalov@broadcom.com>,
 Juergen Gross <jgross@suse.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
References: <20241203090045.942078-1-nikunj@amd.com>
 <20241203090045.942078-11-nikunj@amd.com>
 <20241230113611.GKZ3KFq-Xm_5W40P2M@fat_crate.local>
 <984b7761-acf8-4275-9dcc-ca0539c2d922@amd.com>
 <20250102093237.GEZ3ZdNa-zuiyC9LUQ@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20250102093237.GEZ3ZdNa-zuiyC9LUQ@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0219.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::13) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|SA1PR12MB8644:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d846533-4dc6-48fb-900b-08dd2bdecc09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OUdYZTJublRwbVMybm1YT1NCQ2xyRVFlUi9pOU00NHhDYWlxZ1pUcERqbENO?=
 =?utf-8?B?VE8zWE90OGZJbW8vTXFpOE9pR2lFendydU1TZnRxSnZySnFldkxBQ3dnNDB0?=
 =?utf-8?B?ZlVzTEJXNjZCNmRpTGV5bzRTUXlCTHJRUXpEZ24wMzBrT1N6MnBZRXNNU2Vw?=
 =?utf-8?B?ekVseDJqMk1JZ09Wc1dVSHNLdUpDS05ObFZrWG8rc3oya0d5N3BkTVdROUxW?=
 =?utf-8?B?TWhpRVpuZy9OcVd6WEJVZi83Q25iR2V2QlJKRkl6WmpjK1NxU1Rvd3lxK2pS?=
 =?utf-8?B?VUxuNkxsd1pObjBQYk41RGg4Y0tOOWNJdmQ1UU54WU51eE9iT1hkUnFTZEx3?=
 =?utf-8?B?USsyVVp5dHhlUGdITisrd0NGK0lyVkxPVDBzTkhVbHQ3Q3NJMjVkTG9xZllZ?=
 =?utf-8?B?b0U1U1NFRFhPY2xMK09DeXpBNnBvK00vcFRLUExqb3NYTFVWVGRSRVVBOHZo?=
 =?utf-8?B?NE9mL3FST2ROTVUrVmFua1g3WnByNXAvOEdjbUJTbnNzZkVpSGh2elg0TXZO?=
 =?utf-8?B?MGpyNmtZWGEvdEVyUlFHYVdwT3BObVNWVXpVWmQ2M3VWZkpIczVrbEZSQWhp?=
 =?utf-8?B?MGZ2MG1SZEFuYzFDTmxwSEFIK2x4RW9zazk2SmxFeHZPZkNPYWZ3L0RLOFo2?=
 =?utf-8?B?TTFFcEw3S1JHa1NDMmpSOTdJMkhuY1JiTVdSd2hvZm42c3RpR3JvM2dGMFFk?=
 =?utf-8?B?Ujg2Tm14anpmbEFCNE01NW9Pczh5NHhpMTU1T05KcEJBV0ZZYnloRlpVYWpH?=
 =?utf-8?B?ZGhmTFZmdXU5MG1GcnFob0tIWVF5RjZWbEg3KzJTVHhhcG4vdGpqNjhJd1lt?=
 =?utf-8?B?NzZwdW8xU1hESXdSaTlmMXhIdDV3eFdJQUduU1ZlVDZXYVNESmkxMTMvdmxL?=
 =?utf-8?B?Ym5NbWJzQ28rNGFaTnpPK2wrTFZPUThHQWJWbHQ5UGk5ZVBhd0Q4YzdjREJ3?=
 =?utf-8?B?Zm5TZ1NOZFZ0TXZHT012YXkydWVCYnhBaVNTUmE0MjVwMVdoWUZWSU9ZbnZX?=
 =?utf-8?B?Y2FlS3Q3SjhDWnkyU2tRWTQwU25wL1lZL1R5d0RRcE85ZmpTajQ1RVU4MjFu?=
 =?utf-8?B?aWRRMjBLVjlzMzh2blVLQ3NlWEZ2RUF1S1R6dFB3TFRUaDlRM1Zxb04xdVhz?=
 =?utf-8?B?cFFBeWN2Szczb292K1pwaU4vcUZiUFVDRzVwVWpTZXdud01lZDZKbm81OEdH?=
 =?utf-8?B?R1V5aXpGbkxvMVhzNWoxUDdtQ3FhZ0R5YUZYTXk3eERmNU1WdkpOZ2hsVGhH?=
 =?utf-8?B?Q0h0MkxPaFFTUFNYU0tiVm5EbkI5MHVaMnZNUEpQaWZIZGpHd3RWcDJlZ1h5?=
 =?utf-8?B?Ty9HZFVlUjVKcHM4NFJwc1BkVGppVi9DaTAzb2ZWMWRERUpIWGVPUld5L1lM?=
 =?utf-8?B?cnprQzd6bVJ4ajJrVGZER1JBbEVaL0NYT0NvalR0SC96SUxtLzZIbHlFK3Bp?=
 =?utf-8?B?NnJEZk1ONFpzTlllM1JUTGJYclRLeUJPcGMyTWtqOTd6d1dISDVoSnVpVWl6?=
 =?utf-8?B?OHdoSjlqS2QvbENtQkRkVWYzcGs4c1FJVkFhUGlLZ3cwUlpFcENyTFUxbEFv?=
 =?utf-8?B?T2haT2NXaFhJd2F5THlLVW1idEhSL3ZIdTY0azNERUxQNzI4OFUxd215SVJO?=
 =?utf-8?B?cUxKYnF5NHF3WFpSQ2k1RGpJMVMxS0VCdVphY3BIc2pxeURIa2puejVuQ3R0?=
 =?utf-8?B?UEJTMHpkTkdFUEZJcThScFVwL3BxTE5hU3l1enhBZFV6QXRaNFRXU0l2UmFl?=
 =?utf-8?B?Q3J1TUxEeml1VUVXRERzZUVjenVJMzlkWENTUjBKMDZpSVFxRnQzSmZyQkV2?=
 =?utf-8?B?bEdNZllFL0t2OElDemRveE83eU4yZ3dxSVpOMHp6ZTlibUhQeVZWL2xnN2Vi?=
 =?utf-8?Q?mht/tbmwIKEYc?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OG43SjBYdFBzWjN1TVdLSDh3dU1WdEdsUWlNMVFObmg1VU9vb1J5UWZWcmhC?=
 =?utf-8?B?OVdBcFdrbTdaVGgzakkzdGlsYmxyWmNGdFo1WHp5NTZmZC9QR1M5UWkrYjJJ?=
 =?utf-8?B?Z2h6QWJvNyt2ZkdlQjFmT1kzQmRzWFpOaERORUwrWGl2a3oyWTMyUGp1QlZW?=
 =?utf-8?B?N3RiWXlJamNyeGI1WEpoQTZUbURNWWdSM2dhazIzVm5kSjRLZDVqTFV2N2U1?=
 =?utf-8?B?cWZtUEJ5d2h0UXM4OWFOdlhKTVRUTzVWVWRYbFZUWUp0enc0Nk9aZFhaTFJi?=
 =?utf-8?B?dzRBS055RTNuaDM5RTlaVmtPVHRLTDZ2N1Y0bFpwTkdJcDgwekhIcGltZnFF?=
 =?utf-8?B?aFZJVXVMQ3VaY29ZUlZ5Z3Z2dDRGbVNjM2VkRkFoZEN1TE5aYXJsT1lhVkhF?=
 =?utf-8?B?dVlSWUx4TmZObFBsRVd3bGhsNU12Tnl6NkRBaEJRWGNoYjdKMkRESjgzR2Rt?=
 =?utf-8?B?dkhPT3loSDJQR1dUYjdJSlBRdmhiN1FWakJoM0dJK0grNDNIdEE2cW51T3Fv?=
 =?utf-8?B?eFk5ZDZLWHZTVXJISkhYcWE5N2xtTTlkOTE5SWZhYjZPa1NLK01WTWQrNmxM?=
 =?utf-8?B?d1NhaUtCVXRNZWhFUGxKOGpLdk9ZNUFMZXdhTzJMS0VENHN2bmZySVQ3elFW?=
 =?utf-8?B?bUpKTldJNHpBY2hhODRTVm54bkE0UkFpSWY1WStadFNPY2Z6RHo3Q041Tm92?=
 =?utf-8?B?T1B6VmpXa1l6MzdWSHdhb3NRNERSL0pzU1ZKYlRKaWxhcDhDTndJVUIyUytI?=
 =?utf-8?B?R29xajNJNUYxeDRGdkZqZWFJU09xb0N6UmZVYnJ3eTlteXdUM0s1eVZ6OUpn?=
 =?utf-8?B?MXBwSm1za1BsWjBua3pVUDdWeTVpL3Q0cFpjcmFtU05CTHBRZVNBcWJxQnY0?=
 =?utf-8?B?d1NiRWdGbGtvQkN1amNKdGprWUFjU2c4R2huUUNuWDdBbnNkbTVOUzMwc3lW?=
 =?utf-8?B?WFN1WnVXMi9sOXBLT0tOOFJYcjZpdVFPMC80RzFlc1NLdW0vbHdpZExCRUlE?=
 =?utf-8?B?ZHphZk1VS3VEcHNNSGZYUXh1WTByQ0p3SnlyTVhScW5UYjdOdFJ3TlNaNVZ0?=
 =?utf-8?B?MElTL2pqMUZnMzgwWGhUMVd4WnNpZk5BL0t6Q01OMm5MSU8vcWI3c0lFMSsr?=
 =?utf-8?B?VXZSZW5YTWo5TXBxTXQxWlMvYUtYcnpIdnJrQW55Z2ZxSXZ5TmVVUWtuNzFy?=
 =?utf-8?B?RkY1TGJNNjFaUzUxa0hHT0xzM3E3SWFoRElnblZlWFlRUmtOSHVCSlQ2dGtD?=
 =?utf-8?B?SlY2RURqb0pMNk5hT3hPRWt5L3JvYWpzeE1LTzhtWDN6VSs3bk9iQjhGdDd0?=
 =?utf-8?B?WWdtVDNkN2ExQlhpdHlJeFlSYkFIZm1YM2kvVUtSY044VTZ3QzNmNUdIUDlw?=
 =?utf-8?B?Y1pRdmJzU2ZWcDVPcW1hNFZKVVJUamNpYUx1TFo3UUZKTmYrU0t5cmxIWDVJ?=
 =?utf-8?B?ZktxMEVYOCtWVlkyajFRNUdxV2t4NjlSUWFlbFFHSWp4U1ZsUU1vczdpNFFI?=
 =?utf-8?B?aFRmYkZSNFJYTy9wMFordDJrZ1g1QnA4TEc0eUJtZGdyS2xqR3VnNHBPY1VT?=
 =?utf-8?B?aGIyMTIxVG9idVg3OC90dVgvV3NSdGQyZHFQUGlGbEgxTk9aMTJ4a0xJRmlO?=
 =?utf-8?B?QlFVNXppaTF1TjNWK0p0cjdBdEVHdnNoT2wvLzREUTdmbXJoMHJjUkhlZXZK?=
 =?utf-8?B?WlR1dXQ2YWhZTjVKUkxiM2xTVlhiK0Fzb1ppQ09iOE5tNXBCb3RSdVNTQkZM?=
 =?utf-8?B?VGxEVnhGVXdOc2Z1MG9FVE82Ry81YUNnVkdORkg5MGhDMWliRXdzbE1MMStJ?=
 =?utf-8?B?OHRjVU96YUdveHZZMythYnIraWNuWDYyVFRFWjNHVEMwY1FzbjdvZ0lSbTFo?=
 =?utf-8?B?YWcwT0R1ZGNzOW9tZHpRckFkbTNXL2x4bWQ4MnVXckE3M1hXZGJOQmFtT2sv?=
 =?utf-8?B?bkR6aTVRS3M5UHhnMTFaenFtUnNObjFSUzc1M0t4cGhSckFhR0pSdW9OVkty?=
 =?utf-8?B?ZzNLU1VLUmxyY1piN2ZRcndmdHV0R1IvR25Ma0JoU004VjJnWjJvZXQ0VzNM?=
 =?utf-8?B?QVNEQ0pnVVVSQ0pMZ2xuNjlWWFpFY0wvb1FUWTlnQ2hXYTNKaWJnN3FwNTN2?=
 =?utf-8?Q?IAgeKLLiI/hyTeCXyisBivKPa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d846533-4dc6-48fb-900b-08dd2bdecc09
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 10:10:06.6090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NO4b/zrTZttTqNpwk84hqE9d8yzzluKL4q6lsJZflHZIEPRk0z5diPDM2K8IoSWKLXlVEfZtD6XJ6NDlR0Z/Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8644



On 1/2/2025 3:02 PM, Borislav Petkov wrote:
> On Thu, Jan 02, 2025 at 10:50:53AM +0530, Nikunj A. Dadhania wrote:
>> This is what was suggested by tglx: 
>>
>> "So if you know you want TSC to be selected, then upgrade the rating of
>>  both the early and the regular TSC clocksource and be done with it."
> 
> I highly doubt that he saw what you have now:
> 
> Your commit message is talking about virtualized environments but your diff is
> doing a global, unconditional change which affects *everything*.

Right, let me limit this only to virtualized environments as part of 
CONFIG_PARAVIRT.

Subject: [PATCH] x86/tsc: Upgrade TSC clocksource rating for guests

Hypervisor platform setup (x86_hyper_init::init_platform) routines register 
their own PV clock sources (KVM, HyperV, and Xen) at different clock ratings
resulting in selection of PV clock source even though a stable TSC clock
source is available. Upgrade the clock rating of the TSC early and
regular clock source to prefer TSC over PV clock sources when TSC is
invariant, non-stop and stable

Cc: Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 34dec0b72ea8..5c6831a42889 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -274,10 +274,31 @@ bool using_native_sched_clock(void)
 {
 	return static_call_query(pv_sched_clock) == native_sched_clock;
 }
+
+/*
+ * Upgrade the clock rating for TSC early and regular clocksource when the
+ * underlying platform provides non-stop, invariant, and stable TSC. TSC
+ * early/regular clocksource will be preferred over other para-virtualized clock
+ * sources.
+ */
+static void __init upgrade_clock_rating(struct clocksource *tsc_early,
+					struct clocksource *tsc)
+{
+	if (cpu_feature_enabled(X86_FEATURE_HYPERVISOR) &&
+	    cpu_feature_enabled(X86_FEATURE_CONSTANT_TSC) &&
+	    cpu_feature_enabled(X86_FEATURE_NONSTOP_TSC) &&
+	    !tsc_unstable) {
+		tsc_early->rating = 449;
+		tsc->rating = 450;
+	}
+}
 #else
 u64 sched_clock_noinstr(void) __attribute__((alias("native_sched_clock")));
 
 bool using_native_sched_clock(void) { return true; }
+
+static void __init upgrade_clock_rating(struct clocksource *tsc_early,
+					struct clocksource *tsc) { }
 #endif
 
 notrace u64 sched_clock(void)
@@ -1564,6 +1585,8 @@ void __init tsc_init(void)
 	if (tsc_clocksource_reliable || no_tsc_watchdog)
 		tsc_disable_clocksource_watchdog();
 
+	upgrade_clock_rating(&clocksource_tsc_early, &clocksource_tsc);
+
 	clocksource_register_khz(&clocksource_tsc_early, tsc_khz);
 	detect_art();
 }
-- 
2.34.1


