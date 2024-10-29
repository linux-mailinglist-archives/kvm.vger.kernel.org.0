Return-Path: <kvm+bounces-29958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7E619B4DF6
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 16:29:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 784F3281B79
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2024 15:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCAF01946C3;
	Tue, 29 Oct 2024 15:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cwVir0g+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2080.outbound.protection.outlook.com [40.107.244.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B45E192B90;
	Tue, 29 Oct 2024 15:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215753; cv=fail; b=Fnbq2zoMR7OZpBpsRg+mq9JcTRBT4P3Ht/93DBhygJv00bnlgLtEsr7E7RhHj+/QBU5P4rwfXKKLUj2a2zBDwm+ASHtqZWv0hH2xGLRzqIkHrBJ8HhPwggOdSxSpoD6zl31wqgN50XQ+nqT0WfbdX1wN5psGiJn0FXABWFYZP9E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215753; c=relaxed/simple;
	bh=+gbAiwfk5Nmf3A58TzPoRnLCfoDcPgivnjxDSicpw74=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M+VnY+UMufreMm+Yxpey/Ngcox7OYWO3sUfrIVbVhPrRLqB8FzxrsC6oBRFhGfqlyd6rP+lO8yfIaeDcdivoyiG2gSB4KhGSYElelLNzZq4dd6cfGM28Vy6MqZQVFB+uDhpptjYuaUh+vlinrBTZTvP7E9UOkUURwIG+JokwH2E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cwVir0g+; arc=fail smtp.client-ip=40.107.244.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wf3N6YS+5AsCFoXEg0d08NjAu72Ag/nopmw1lIcZT6zZ0RUXZIFJKMJUzeWyyrvv7hXWjS60oySkKiYW8wntnDdv3kJoSrv3QELkOGcL+iSWUrBJx4ezi54oMmENKd7F3tZ4Gcm+StEcdjYFATfOPxOxMBlYJ986IvF9Wl38kNhlCj4yOxSAm5NHDUEKtrHo/3oVnJ7GpopdyN55ZIPMDh38AwBnh/Ui4y7NQYwszldL3iKlgYVCA93Yfux/vBOjilCdon760AhHyrh2f0WbvosXJ0pU50C0fjdfevtP3/0GkZ4En6bDc0n2TeeM6FR5Q7N9E7Cs2bca4mjRCGhVKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eq2NRg8wOxzpgwKoG8pptZKbuoKlqV56/9PtgOjLIvA=;
 b=UxD2jiioDl0wGwNgrEu7oy6VBbEIFBcFDBR/gGTQqxAoYfRw4RLgCcQeWEXMwEt/2ejuGlp290dHDpMbV77i4f1xpjbFFmhZjPtPkKwz9ivTsZhmkXo4p3vg4oVuWMqiLalQKGNgsEySZCJnw2zU9D3KqE6f9lHn08ZvkGaalgC6Tn6tKkrmTaASWw96gPFbUDkEa2+Iz4MouEh/VDrEw+9FvlQcPlLbY9jovc/XR77IYX9DUIJOGtFfhYGr8NeRNYZuXrPMRaNT3d22/FrrVaYXxbLr1gAFaIMRdyRFGl+jD+Z9LXcL2XluQimxrHOixA7PuH/sB8AEXQneDj+MLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Eq2NRg8wOxzpgwKoG8pptZKbuoKlqV56/9PtgOjLIvA=;
 b=cwVir0g+I5RxgdDI9yZu1WE/z97B6vehFFPEoKGWZr2RNrkoTQwnbRvE7tNylYZYb33M91bIsq1KxCM5zmxHLux7Ri22tqWBpA+cD6Jl86n38c55gt4M8rK9X/iozhZ7ZC3sllWCHwXELm8IENAqoimsoL1NXXWhwDvRW+qOC+A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6599.namprd12.prod.outlook.com (2603:10b6:930:41::11)
 by CY8PR12MB7706.namprd12.prod.outlook.com (2603:10b6:930:85::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 15:29:08 +0000
Received: from CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0]) by CY5PR12MB6599.namprd12.prod.outlook.com
 ([fe80::e369:4d69:ab4:1ba0%5]) with mapi id 15.20.8093.023; Tue, 29 Oct 2024
 15:29:08 +0000
Message-ID: <fd5ea224-5c69-4e51-81d7-5a259bfec668@amd.com>
Date: Tue, 29 Oct 2024 20:58:55 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 00/14] AMD: Add Secure AVIC Guest Support
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <vo2oavwp2p4gbenistkq2demqtorisv24zjq2jgotuw6i5i7oy@uq5k2wcg3j5z>
 <378fb9dd-dfb9-48aa-9304-18367a60af58@amd.com>
 <ramttkbttoyswpl7fkz25jwsxs4iuoqdogfllp57ltigmgb3vd@txz4azom56ej>
 <20241029094711.GAZyCvH-ZMHskXAwuv@fat_crate.local>
 <708594f6-78d3-4877-9a1e-b37c55ad0d39@amd.com>
 <submtt3ajyq54jyyywf3pb36nto27ojtuchjvhzycrplvfzrke@sieiu6mqa6xi>
 <8015deec-08e7-4908-85e1-d42f55f4bb6b@amd.com>
 <mzrkt3qm35tluz3sh3weg7g2xf6xozgmiimenyidubcyofyrng@a63x6gie4vqy>
Content-Language: en-US
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
In-Reply-To: <mzrkt3qm35tluz3sh3weg7g2xf6xozgmiimenyidubcyofyrng@a63x6gie4vqy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN0PR01CA0017.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4f::22) To CY5PR12MB6599.namprd12.prod.outlook.com
 (2603:10b6:930:41::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6599:EE_|CY8PR12MB7706:EE_
X-MS-Office365-Filtering-Correlation-Id: f189016b-2d71-40a8-a8b9-08dcf82e6e01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aTQ4NU9IODNXL2VPVWFyOTk2N2hjSWZwL0JGMHc2dzc3c3BrUjh2MVZTSGF0?=
 =?utf-8?B?VWc2VWdYT0xVcDI4bkNSTHhCMmZ0L0toTXFzcENkS3JqL0xGTGtZZnRTKyt3?=
 =?utf-8?B?dHNQb2paSWN4VGhzOFZDMDI4ZUNIdUJXdncvQ080b0V3WnVSQUp5ZDd6K1Ft?=
 =?utf-8?B?VEdFdGx0Ym9xeGVtSmY4VkpwYTVFMzFFRWVrNk5nUzgrK2JPTkZhNnpOVG1N?=
 =?utf-8?B?R3FseHd5U0ZmdC9WZTFlaTFTMjBxTERxaC9qWXpFYzA5cVRVRStFWTJlOHBX?=
 =?utf-8?B?NStaSURXN2srdWxGRlZJMVl4MmlvblNzK0R6MXRwcmM2WWR3VUhBcFlITzJ1?=
 =?utf-8?B?RFQxN0RCOGdBSHBWVkdoakhGV3lsclZnZXdZaGlxbEd5dkZkU0NpOVlQbHhD?=
 =?utf-8?B?dHI2MHMyaWZFZVZ5Q2pDTVBwWTVkbE1yS2wxeU9OTk9wYldaZThkZ2F3cmFI?=
 =?utf-8?B?V3BuMmtoby9yT09pSmNmdlJaUE1qQ1BUWk9ZWlgxZmpUZU9reVQvdFJWMnhC?=
 =?utf-8?B?Rmx4bFpOdmxYNENqYzBkOFczTVJSem9lY3MzZ0VxVCtoa2VvVkZYdzNWOUtq?=
 =?utf-8?B?eVF4S1lLdGdsUStIZGpyNStFYTNUbnZHYTZhd2FXRGpIRDRJanljTHZNYlM4?=
 =?utf-8?B?Tm1QcHc1czRGREJ3QmVzdHJNVkt4dWNUT25TOHdYUUo3Y2NaSzFrcnBWa1Zn?=
 =?utf-8?B?TjNUUzFwWHB6c0JHdXB0MGtNdUpxVHBkU01waHVEa1c0bEhNa0YyQXdrOXQ0?=
 =?utf-8?B?Ymo4ZHdkSXRzTWVxYXlIZ0Z3QjFWNVQ1RUk1cjJWZjdsenBablhIV0Q1THlT?=
 =?utf-8?B?aHBBbUpTK3NQekNMN1pOVnFZMXA4T250RG1zNDliQlNrdWFXMXdqVTRCZk1m?=
 =?utf-8?B?aVJmOHIza0NRWXFVS0U2QTY0U2lqb1lDWmdZT25tZkdldWhobXl0VUhLVW9O?=
 =?utf-8?B?bkZ6MGI5bnlZUlRUTWxGN2dOOHJweXMyeEdlb2hYTHRBVk9tMVMvekdvbjh0?=
 =?utf-8?B?UnpxZWFxU2lOaWNsY1FZOHVXcEFweXhjelRmTFo5OCtRbXVFT3dYRWVoUEk4?=
 =?utf-8?B?WXNLanZLeUwxbVU1N0hlNEo2YmdrUVdVMFpMZC9xc3pjV01mWENXek8zdlRu?=
 =?utf-8?B?ZmlDeTEwQWlnZGZVYjJRdjJ4LzFRYm1OY2FTRy9kTUNrRi9mQkxwODJhTFNC?=
 =?utf-8?B?K3RMSDNLYlR5cmZVcmFLdjhKeVlMMXBQYUx6YWs4VkZvY1ZWR2Q0SlBBZU85?=
 =?utf-8?B?VGxmNEFDZW5aSHE0VHVPKzF4aW1DejQvVDdWczM4aWNtRjBsa0l1aVJFQ0lo?=
 =?utf-8?B?cjJMVkN1eWZkV0hIdHpMYTlCRlM0bnhDeUkzUS80UmxmR3g2ck50NTF4MmQ4?=
 =?utf-8?B?ZHpNL3hIdmJMZVNVaDYyQmtCak9qOHkzTXJxcUJkRHVpb2ZjbERpWjQvL200?=
 =?utf-8?B?SnRpUFhQYXVRZDlOaHFybEVhbU12UjhRdUU5T0JiOFRRY1Z2dXhSUURWYmFm?=
 =?utf-8?B?ZlNXVmNyS2luNTRxT254bUVsWStHQkhnY1p3VHpha1pvNHZwZWl4NHVjeE9Y?=
 =?utf-8?B?YzhWUkwxUkdTb1lDd2h4K2tFUzJEajhJTkQyd0tCaVZUWmt1VzlaTzRldnJp?=
 =?utf-8?B?QTdRbVp4aXltcTdWeXdOVkI1Y3YwNXZJU1pKRTgrQW5idGFLS3ppeFpQYm5w?=
 =?utf-8?B?WFZQNTBZZi92aGVNR0hDNFFvU0lzTWM4bzhjcnhXclZEN0FTWkxjR09JdnJq?=
 =?utf-8?Q?GF58Kzja+rusamwk9iwPX7kzS9ZQriHnsxtkqYa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6599.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1AzSmRsbE0vZ0ZxdHlrNnBhc1Q5MXZvd3FJQWZKeTRUV1AzTFFmWUt4cWNP?=
 =?utf-8?B?Tk1qVXh1RmVNb2ZkeGplWTdjeGt0SklUREhld1FXMFcrTmpWN0ZMc3d5QXpL?=
 =?utf-8?B?ajNuZlRGVjVkSnp0dldkS3duZFpmdEcvSmhvLzZJZlJLRDQ0RURjR0lNWU14?=
 =?utf-8?B?TjAraVZ0c0k1RXFqemlsUkRMaHNjNVpNZFBxUVZ2VkV4djVJL2doOStoMXlR?=
 =?utf-8?B?ZWN4d3VXSzA2Qm9ZMHdJaTUvejBjZ1BWYUhEU0hPNUxWU0o5R1g4Y09GMEFR?=
 =?utf-8?B?VlBsN05ESG5TMjhaR0dRaXNEeWZXY2hrK3ZXdWx3TnYyd29CZW1EdklPbEtp?=
 =?utf-8?B?NDJUR3hldG9vczEvZEl5a1FYTnU3TDlaWnV0US9QMzZITWUrUGx4b0sva0Vw?=
 =?utf-8?B?V3p0dHo2VHBnUlRwTC9Vb00rRXQ2a2pKUW9sSFB0SE8yVWVFSDJieHlKaVZP?=
 =?utf-8?B?aWxVd3lnYzlHUXJZVk9SNjErcE5jNjNHbWhKV1pCT3lMVHJHbUNhWFBKQXY4?=
 =?utf-8?B?aWhYSDRnbEFnR2lQSlZJQnJrTktBcXIyZ2xnQVcyMnhQY2xEM2MrTE0wZUJX?=
 =?utf-8?B?dSthTDUvUVZiaW16QTNwRno3blZXOUcyRDZPdVdHb1g1R1VPY1VSaWhvb05k?=
 =?utf-8?B?MHR5Q0xXSXYyWk50TjVvK0FXTjVUQ09PYTFzZk53OGxQd0hLbm96dkhONURn?=
 =?utf-8?B?ZVFCMmhmblhTQTNXNXZhMHZDbHIybG5nY3p1UDdEdU1OMVJvaVIxaWdNSlNs?=
 =?utf-8?B?K2Z4MERpNFRTMEUxZEtnY1dhN0F4dFQwYmVFcEtNdG5XcWQwL3BhWjAvVEUv?=
 =?utf-8?B?S2t4MEpwMWNEYTc5a290ODBzVEVGUnhSVFNQdURRTkp1c2tmZkJyRjNlaUxn?=
 =?utf-8?B?YStCc3NQZzZtUnlIZitzako1dnBIdGFpeVpRd1JKS284aE83ZzNqaFA0NzRj?=
 =?utf-8?B?YVZneVJ1YUxNYVJkeHpLbE4yb0RsZ2Z4Mk1OZXZkKzQrWkJ0MjUwUkE3SE5y?=
 =?utf-8?B?SGxoeldUWE1yL0RvUndmN3doejhMV0gvSFRRRzZUelhEMEFvRFhnMFFSRkdW?=
 =?utf-8?B?MHQwYis4RkU2ODFvdkNrN3l1VUwrWU5DQTBLUXhTQVk5YXVITEY3cDRkdlVx?=
 =?utf-8?B?NXVSL1ZHQUNOTnJNL09pVVdkQ2RUOUFMVjNIcHRQQ3JGdlhCQ3ZsWlBGVFVK?=
 =?utf-8?B?RFE1VEpJTDh5NEdYS0NBMkhyYjlTcGhoNlN4cS9wVVF4UE1uVCtvanV2U20r?=
 =?utf-8?B?dndmMU9XUkZmUjZ4UHcrd0U3OUFacXIwS1lPb2MzYnU5enlCaExpcWpyNDdK?=
 =?utf-8?B?TjMwSitqelNSVFNSMkN0Q3BJbFd2V2R0REx2TTNSZHJ6N1VURWEydHdzbHFU?=
 =?utf-8?B?Sk1JRkJpb2U3SmduSVdmUnhtcE11RThJUWtSYlh1aDNISFRqL0ZtUXVTUGkr?=
 =?utf-8?B?dFpNdGIzZHAwSVE5RjlIZ1JBampkQm5pdDdZNk5SSDlaellVN1gvUFR2aVRU?=
 =?utf-8?B?YUM5cEFnSThySTBEMGd0UVpORTBVZzNaSTZCUUFhZlRVbXYrbUt0ZDBQcU9J?=
 =?utf-8?B?MTJhYU9rWVlhRkhiRkZCMDBSM0NSMk1XSys4dkxrUGo0R3VnazV2S1NGK09E?=
 =?utf-8?B?RHhnekpxQW1LS0NCQ1g2SHNPV3o3a25pVmF5dnVYZDBMc25nbDU0M1pDeVpu?=
 =?utf-8?B?QjNRUCtkdHNTZmUyS1ZvK0UzeVhEZWdBVk0rYXNiUGNqNDAyUW8zWVJabUxG?=
 =?utf-8?B?ektoOHpwbVdGeXoyR1JIZUpzNmIxc0pEZ2syWUh0Nm4zcHFYSVhIc3B0bTRn?=
 =?utf-8?B?R29pZmtkMTNPaEJ3TnZmOXdzakJ3aGNxdDZZSG8yMzFpcHdNT2FUT0crd2Uz?=
 =?utf-8?B?dlUvcDVkTE8vUFFrTzljZEN4dnFycnYySHJJeU1QVWg0VzJ5c0xNRE55bDA0?=
 =?utf-8?B?R2l4RU9pcnVBOENRcnc4K3B6N3hoS1ZLSzZPUDN3dVJBcjhrRWN2YjVlLytk?=
 =?utf-8?B?bnNwODRkZkxIaWUzdDV4MFJtSlhZcDg3aHVDbnQ1NTg4NW53K29EQjBQMUtH?=
 =?utf-8?B?KzJvMzdKWVUxU0NkSmJLSnNQSjFnY2hkSWo0L3pOU2JuZEQ2VTFWbnRMT00z?=
 =?utf-8?Q?U5cHR0hH6RHjbFWzxXbRD5FKS?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f189016b-2d71-40a8-a8b9-08dcf82e6e01
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6599.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 15:29:08.2219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PeG9gzuaE1sITUpw93zLaxZUUqNDCo5Hds92fuDJ+1yPscuaP6IIPk7RgzAA9pErclnZ43wNH+4aeyhyFCXgBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7706


>>> Have you tested the case when the target kernel doesn't support SAVIC and
>>> tries to use a new interrupt vector on the boot CPU? I think it will
>>> break.
>>>
>>
>> For a VM launched with VMSA feature containing Secure AVIC, the target
>> kernel also is required to support Secure AVIC. Otherwise, guest bootup
>> would fail. I will capture this information in the documentation.
>> So, as far as I understand, SAVIC kernel kexecing into a non-SAVIC kernel
>> is not a valid use case.
> 
> Hm. I thought if SAVIC is not enabled by the guest the guest would boot
> without the secure feature, no?
> 

Actually no. The guest VM which is launched by VMM with Secure AVIC enabled
would have SecureAVIC reported in sev_status MSR. Secure AVIC is part of
SNP_FEATURES_IMPL_REQ  and guest boot would terminate due to snp_get_unsupported_features()
check in arch/x86/boot/compressed/sev.c if secure avic is not enabled (having said that,
I need to update config rules to select CONFIG_AMD_SECURE_AVIC if CONFIG_AMD_MEM_ENCRYPT
is enabled).

- Neeraj

