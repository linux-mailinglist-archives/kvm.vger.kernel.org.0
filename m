Return-Path: <kvm+bounces-12703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D0C2388C75B
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 16:40:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3D2D1C641F6
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 15:40:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DE313CC7B;
	Tue, 26 Mar 2024 15:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="3i66Qmeh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2113.outbound.protection.outlook.com [40.107.243.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DA013C8E3
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 15:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.113
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711467341; cv=fail; b=fF3u8Euw3K7g+Kw9dfQt+HDCk1pedItSSFFZlpcvUqaT5O4xUInajzl0oe/y6rVFBmAyl9pQV+n5DYc4WPvwK3J1MwMHUu2zYP5KVt5nx7fYrhPp7EaiBJHEgQV33eOLu69YYwW7SfiBd81KuzKshFyMcFOH6V0JfC1QTscYAkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711467341; c=relaxed/simple;
	bh=TYOr9Hij1pGbFWUo09wYgqLVyUIqp4gnSxyK9Cjfw+w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IbG+9g6uGdPI6FZr1We1pI4xZ4xqzUOts2h1VaHzokZDg1nlx8BlI4aPJJ7LLD1TEJ/aypO6XcSFaEq3jLtbd4dXpAxFiLZLR7LBA/UPTlIXOHFCpFQ9FA8HlD0Gl3yc1Qxmn7fzQumoJAAXLqk2PnwGAIkw7YhBWVI9Meu3gzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=3i66Qmeh; arc=fail smtp.client-ip=40.107.243.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P1WsdxjbKq5/A17+EGWFpyJwQ4drMQdS+4iy4laNAFMzYwa+Jx0pblVOUIH6g1FbeJ6g7FaVkHUgaUR2OxoJ6DtWeQpVE4Qln03MWOefeP6RG13to3b9bTmTO3r7DGhpe9cPhsRhKSyNAu8Er24C/+rhleBZAzbnlP+MQUlvlLqWLI3oe6wSHTt8XEb7MmATSfzcEASGIRp5SXo5dGJYUg8q3jFeSZZi8N+ewntKj8KBFPRPDyAeomU8UpSRsVaXIwLRyV7XLV3wzm8SGiDq7jAYoJc31cQl3pss9plB3eMrBUPQQpasCGGmcJZcHCgMSMWop0N6JD7B09WNvLA+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ywKtuMJALVMiibKfQNjSVarHY2yB0y6hPSw572hXV8=;
 b=L3sZ2WQsos7LjOMS9ic08QrcuI0wihACcU3nMB0/o0PV9u6LbgCdMlIcia2W2TTZtKedTG3VbLlD6vjHuJe0M61+ilco2j1H0EqK9UBXljV3m3e1vRvrNYkNkXUFlhcm1iRRDCZvgbbdY17Grbj4uRKaFIZDNOaNei4mNJnemFnKq3h5JpWPcUfKEPZJc8f5JCUvjxrdobYi+6VAP3Ff3wnqRd/b6xVSM8YnVJyQy+EiSb6B48occmzoCk+ujaZ2xtdeXJmmB88vtL1/Lk6gxDhzUAo3tFPNedcMQXb2zZK1WJbCgnGTF9ZQdxopjIJAy1OLgZOAq0WPypDakkhgHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ywKtuMJALVMiibKfQNjSVarHY2yB0y6hPSw572hXV8=;
 b=3i66QmehgWVq9/AZvsr3jfsXt5UDPM33BHQcydnRI43PFiTaum0LXCuEcZIbXW8QPxa+XmGlAskEUS2/hK1dq6wgg1SFrqfx20DuvOWOWAGIifvjyHKG9Xr00/LFJuxgqgz/a1vYvM4/nlFoKqczLj4Px2Gk9ER+gyY1hJa240c=
Received: from SA0PR12MB4447.namprd12.prod.outlook.com (2603:10b6:806:9b::23)
 by PH8PR12MB7327.namprd12.prod.outlook.com (2603:10b6:510:215::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Tue, 26 Mar
 2024 15:35:37 +0000
Received: from SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9]) by SA0PR12MB4447.namprd12.prod.outlook.com
 ([fe80::b6fb:23e5:a2a5:88c9%3]) with mapi id 15.20.7409.031; Tue, 26 Mar 2024
 15:35:37 +0000
Message-ID: <93664d1d-396a-72ec-dd58-eed78e545788@amd.com>
Date: Tue, 26 Mar 2024 10:35:35 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [kvm-unit-tests RFC PATCH 3/3] x86 AMD SEV-ES: Setup a new page
 table and install level 1 PTEs
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org
Cc: pbonzini@redhat.com, andrew.jones@linux.dev, nikos.nikoleris@arm.com,
 michael.roth@amd.com, amit.shah@amd.com
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-3-papaluri@amd.com>
 <71311318-ca6d-47f8-8fe9-807b308f198d@amd.com>
From: "Paluri, PavanKumar" <papaluri@amd.com>
In-Reply-To: <71311318-ca6d-47f8-8fe9-807b308f198d@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::14) To SA0PR12MB4447.namprd12.prod.outlook.com
 (2603:10b6:806:9b::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR12MB4447:EE_|PH8PR12MB7327:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Vy6kZlDJZL/sf1zghrbZEIiCGCffxpIqp2H/CWCgHHT4aGlWa2HGMnyanvkhTcQGDozLJ99BlYUgJx2wGjNT9Y0BIRdITLIOC8sxR+eFrE7qFkM1btUSYyzsHf3sKzbCyb777aOb1sHHl/xrjtYjM7frYbDr+WKYYGouziVqnMJzxJojHP+OzlL9zGqbMb6zfkR72hzHkuumIKkMG7DMZaD5oz8835sdrhQTZ9WwERx70fTkWL2ETjn8C5gckM4s4MpaGXypJjPM3oQ+y1UAyvyHqKeXnRLm/wle43JqOLgVIWRKniFTsSzmcCfqafjTH64pq986L9LVxqKneS3nH+X6DrmZGlXGhu2eaAMclGfOffFhh7N2uvGCw3DA3OxyrBbYqhVwrLiafLMNH4m9DtFIy45JWx9dXyqmhfMNGvePHSQIhL8M96AJiN8vRNOYRe1PCw6rvpigVvE4jsm2Cnb/xzianHat72vcbSnDhaO0HKzmVbVIYQpc2dEBIWOnxBairdSkT/+zYQT/lWeeeYJRpO+wgFVBFiOzVa/cqbfS6VrBroKWfwcvigkH55ESt34t5qfMBkI5pI92DYRofJerEwSeVmP/2YG1/ZzvxmLwdqSxmOKE2ZiIyZEhRnwwBmpcQtDENt3zNPYGWaYACs5xN9YmY+/RlR9ZCWFejIk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4447.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RjZzbUIwaUZwZ25hbEVjdjd2MVhua2ZpMzdkUlZTU0g0dlQ4NDlRVDdrR0Yv?=
 =?utf-8?B?Z2E2RnRVOWJTeE9WZThVWlE1VitzR2hnRS9DcHJNcWllNW4xbzhlamdSampK?=
 =?utf-8?B?eUVZVjhEL0pHaTBxRDVLSnBVWUpjSGc4WUdadTMxNGZ3cFM4YUhlQkhKWEt3?=
 =?utf-8?B?WW9UQ2RiYklXSzlEVDZOVlV2NTZjREl1K083Y2RhVnFraGI3cXBtZ3RrUjlH?=
 =?utf-8?B?RzVHSlZkR0RrcElQSVdDU3A3RzdmalVpWmxaeVQwbUE4UzMrSkhFeEhMRVNX?=
 =?utf-8?B?c1FuaU91RS9kbjhqazJvSUlWenQvUW9Tck5YYnpOSHB5TEhnQU1ISmdFenpt?=
 =?utf-8?B?emJ0eUN3R002VW9DNE81WHZ1MVlKRkpZT3d4ZUM3MHIyMzRzWWc4RVhUWllP?=
 =?utf-8?B?Y3hQcHVwci80RzN1bkJCTWtUeHg5L0pTUFNPSzJqUXlnZlp2Q2RHODNidU9h?=
 =?utf-8?B?NCtQZ3M0WWNoSW1Mbnhnc3JJWlk2NG96TEdhdkdxTFVLbDlFMzRhekNVRWdk?=
 =?utf-8?B?WkI2a2NGVW9tU2VQK2JCUWhKb2h5ayt2Y1NxQm90ZlFjd2tQMktIMCtlRGE0?=
 =?utf-8?B?cnFNM0lMMXFhMG1UYUZNV3BseU14NUdNc0ZSbWhVbndWVWNmajFMaUdMZXB3?=
 =?utf-8?B?V1lSWFJtUTcveFJldXVBdi8wTnRPaWdGNXpFSFp4TlJZMEJMZVJLRHFsQzdn?=
 =?utf-8?B?SHNTMWEzTGgyUmd2cmNzTnp6NnQxZkxvSFpTOW9EbGs2UkQwOWdsQkUzME5s?=
 =?utf-8?B?a25ONEM5NGNSek1VRjBJdm11N1psSENYZnhjWm5XeVQ4RHRQMXhMU2ZxWEFC?=
 =?utf-8?B?Q3dtZmk2U29ZeEp5Z0NmUGx6VXpTMWE5cThESHBITnF4cVNrcy8vQ1FiVWNi?=
 =?utf-8?B?bjhlckZ6WlZaY1ZXTUxOSlVlWXl4V0ExNkZaNzR5MVluM1dONFFaMHh6Yk9w?=
 =?utf-8?B?eG52WWI0NGY3YnhHOHdsZkVKVk9ERHhjUHdnTEZ0SWl3S1l5M2JlbWJkNzY1?=
 =?utf-8?B?MmcyMXc5b1d6YmpyR1VNb1N3MjJhazFQY2duRXprZWpqTVZEays2Y3Y1UmdN?=
 =?utf-8?B?ZnNEcnZsb3JoTnZ5S3JQNE9Cak9KY1FPd3E2UHRFV21rcldJL3d5Wkx1K3l0?=
 =?utf-8?B?T2t1RG8waHBLaUlJdXFkdjg2S0xld1RZME9JYktKTzFrbGR2RjE4Ykd0bWhN?=
 =?utf-8?B?MmQySTQ2S3orT0VhVHcvbW52Mk00eGFPaHNZY2hsemtjSHpJN0hxajlMZHBh?=
 =?utf-8?B?TnpFUkpqcUJnTTRIdkV5YXQ3ZkVzZ05jQ3ZjZU5BSlFjdUdIUW9FNzAwRmhx?=
 =?utf-8?B?Yi9FOTluYmNSRTNvRGVVOHVObENzU3hmS0l6cW5SaG9NeHo2dzJBNzNnS2J2?=
 =?utf-8?B?QTBiTWRaY21nVjd0NWVFbWU4ak5zVk9CYzFiM2N4UmNUTTFsaDJhK2ZKOStN?=
 =?utf-8?B?blAyUWlKQ2lYbXN5ZENWckxIZnc1RzEzNmpDd1Y5SmltSnpYVndEeGVwbnFa?=
 =?utf-8?B?RWNKWFJKK095ckxYZUpZZnJoSlpYZmhIVnlrbzErRlcyTkpIZCt1VlJtY2tM?=
 =?utf-8?B?b0RYUDgwMS9hRmR3bnRHbEFxY0FXYkt0MTUyQmV4emErT0ZxTUYvSTF5cmti?=
 =?utf-8?B?ZXYyUytuU25TY1pqZXY5cjJWOFNLV2U3RG8vL3F6YnZkUlZkbytrQ2FNYnpj?=
 =?utf-8?B?UWFhMFRDM0RmeWxiWDY0cTltUHlMcGtXK1JTb25RUnVTTkp3cWxGZUFCQ2FE?=
 =?utf-8?B?S3Fwd2tJclJsNDlUTXFycURGblpORUc4WS9pQXdITWRBMkd3dXA2TGtCcXNq?=
 =?utf-8?B?NVBYMjNqalRMWjY4MHd3RnJwTHpqWlF5MHZxa3lGSmRGQk1DTTI5K2EwQ3Bm?=
 =?utf-8?B?QWlPMncrZTZqbXNlMlBYTk5FcGQ2c2dHaVB3dzBzZXl2WjlrK29zeVo2MDRN?=
 =?utf-8?B?Mkk1N25mWGVKVy9CMVEweTVyaEFGV09ZUXo4aUEwNElXTXp4TFhHQTVPNGxk?=
 =?utf-8?B?OU9WK08vQlRmeWJjRml3MGV3K3E3SFVJNnZEaVRPNUsrTlFReGZDUTlPWFBG?=
 =?utf-8?B?S2Q3eDVDa3NCQXJzckFNYytCSHU0Z1JGODZWMi9JWXZwcFQrZ0grbzhjdzBD?=
 =?utf-8?Q?cr8aSd4W8ertXAPWp2OJheAVE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8a88ba3-d43d-4fd5-59f5-08dc4daa62c3
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4447.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 15:35:37.7739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HFHj7CRFRIH0d5rhSfowaTd9cujE3x1twggQyQ8ta4zG8Fub0Ul4v1w6VvZ6XGdyG5N0XReUNbV1F25gsPlrYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7327



On 3/26/2024 9:01 AM, Tom Lendacky wrote:
> On 3/25/24 16:36, Pavan Kumar Paluri wrote:
>> KUT's UEFI tests don't currently have support for page allocation.
>> SEV-ES/SNP tests will need this later, so the support for page
>> allocation is provided via setup_vm().
>>
>> SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
>> page should remain unencrypted (its c-bit should be unset). Therefore,
>> call setup_ghcb_pte() in the path of setup_vm() to make sure c-bit of
>> GHCB's pte is unset.
> 
> This looks like it should be 2 separate patches. One for supporting page
> allocation and one for setting the GHCB page attributes.
> 

Sure, I will separate this into 2 patches, the GHCB page attribute patch
followed by the page allocation support.

Thanks,
Pavan
> Thanks,
> Tom
> 

