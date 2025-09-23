Return-Path: <kvm+bounces-58567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A860B96C7A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 18:16:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8D6919C643A
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:16:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0143C270541;
	Tue, 23 Sep 2025 16:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bZZi/kpn"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012040.outbound.protection.outlook.com [40.93.195.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4982A26CE0C;
	Tue, 23 Sep 2025 16:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758644160; cv=fail; b=LZ6bkR6E4iiNIC24e5en/co/RHoGyNzXkSxdW65LqYABttm9fAd9ei7yCV7n740WNJlzgiHxj0uhe3anXsyyxWm1XH52Zx0vyaEoRH02NueFYFLwl595Q+OqtjCVFCmlGV6LfeMtOP7KoDr60bIJmb1YWXR9p/LsmbRFfOL4QZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758644160; c=relaxed/simple;
	bh=x5GsV58mQyXg+A3iZdru84NUv/LvaMprf4mfqt9konE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ivxP/PclB8RafhFN+X1xGD54F/Cb1IoJj/nfq4t65zZ6VqDuxbby1FoHnpEkjEEGx8KrcjxVzSWmRqqIws1DS953Qu4NJnjEJbZ/EPN+n02Ma1R5ZdonL4zKaIklFTS76AzJSjitk4LSykcCrg5sKjH795XZefGG0IDvdJyD9sw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bZZi/kpn; arc=fail smtp.client-ip=40.93.195.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fg4SzSdgDHcP6ATEav1P88DVNCjg6lVu+uxXwQn3cut8hL/wFxXRpRQnPeb1EgonGKOf1OxClilfuvu2rRratnyRsK//avSIa3p4UIZsXpxsEBlxyRW9WtiRdTXt6CvR7O5HFFuJHsTrLWWIOyceBDVMU5JY7+efpUlJOqqJ66xj2DNPWiJ2onA5Y+Jhj3ToibG0fu18EkXbljxNhAhKVRZym0epHxUQStNl7qaum39ZqQFRq3unPx2a0vL+ZYhd2hdB5wyBQHShUhgYPjRSl0lTXHg+zavclzvj3VDp4icjqoN1FF8qtfIkwjA+EXuciBAWaFU+xwgpG3xmeUUlPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o0tqN2nc+xww4t1NRUlFCPJ7jNAeOY70DNUPoen83S8=;
 b=dKMZD5G8QqeNpTiLvM0klFkr/Y7QLj2eYDvOoGil0Cio0Es8gtTaNlK9IR9zF6CJ1OT9tYy1vuEW2Qv0E086IfEbvMnx9Dgrha9WW8DXgGR+epOMygvCBqqUt10qAVQigG/+DQyeWJmUjqYckY+dkFQczeHTKy9pUsgXqb3tRCkvMDTwUfjUNw8DygFTUrGPx0Xkk0ZFNHaEN+TVHqOgSEaFUkcAIN3gtINa54Xt2jneEL56vD693u+frGgtRSZMxTYvfR8trErH8fM/km+1YtjCvbyGE4uQGwc/R1yet5oYnWP+V4yRUbrmiuqIF3UukrhmFiaPInY7IqU/uPzSvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o0tqN2nc+xww4t1NRUlFCPJ7jNAeOY70DNUPoen83S8=;
 b=bZZi/kpnhp1RBhNYPGlrKlt1tixgY3htV4E3nz5My6x6AWh98NKx41u7VX63pQn7UNcZDLCVI4kK/BSv0tsmEVmcTYIhvFW8qTHzY7rb0hTo1uJJ4bRhpQRfngrHgKmRUDYA3r3ZOo+TueudpGcqK3eGCz21uW7gC2IuszakyX0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB5880.namprd12.prod.outlook.com (2603:10b6:510:1d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Tue, 23 Sep
 2025 16:15:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%4]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 16:15:54 +0000
Message-ID: <5305bd63-a393-ad9a-56a9-8eeb167e1b66@amd.com>
Date: Tue, 23 Sep 2025 11:15:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC PATCH v2 13/17] KVM: SVM: Add IOAPIC EOI support for Secure
 AVIC guests
Content-Language: en-US
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, kvm@vger.kernel.org,
 seanjc@google.com, pbonzini@redhat.com
Cc: linux-kernel@vger.kernel.org, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, bp@alien8.de,
 David.Kaplan@amd.com, huibo.wang@amd.com, naveen.rao@amd.com,
 tiala@microsoft.com
References: <20250923050317.205482-1-Neeraj.Upadhyay@amd.com>
 <20250923050317.205482-14-Neeraj.Upadhyay@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250923050317.205482-14-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR11CA0025.namprd11.prod.outlook.com
 (2603:10b6:806:6e::30) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB5880:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a805d52-6b38-4460-1b79-08ddfabc787b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YmIvYXlibVh2OXA5UW1HeG9WQ1A0dnQ4SDV5dkloRzJZSmRJVVkzRjJEWEN4?=
 =?utf-8?B?WUMvc0ZXQWt3YzUrYnNld3NadEJwT0o1dlQ2U3hFM01QbVo0YUdrdEVzMUpR?=
 =?utf-8?B?b3lOUzV4YXE1RnZFSVVkM2dabmJMMVBlbTVPYWtLTlVGZjNYNzFFYlFXaXE2?=
 =?utf-8?B?a1Q1R09idHErcG5ERW5uZzM5YzZsL21ad0FLb2E4V0hQMnI2T3hybkZ3UkVQ?=
 =?utf-8?B?OW1mZ1R5RzBYSmM5THBPWmRoaXVrNzFONVJHRE5CRWU1eStkM3RnTSt1STJi?=
 =?utf-8?B?d3V6MnZTNTBCbXYrVlFIV3Q2VndBSElWMjZrVFR5dVU3WisxZTYySzZNTGZY?=
 =?utf-8?B?dDlZQldDc0FKR2k5dXZzeFd4ZE80NlA4R1AvT3NwNTY5M2k1ZEJoWnUyVkJ0?=
 =?utf-8?B?ZmZFVW9CbkhSWnpWL21uZDlJMDNGa2Y2NEluNkI1NW5jT3UrdlRQRUpvdXo0?=
 =?utf-8?B?VWJtQW12WDczMk9hWlFjSTBGME92U0RlVzB5OGxXZmxaUXBHWVhRN2t5bTJs?=
 =?utf-8?B?UmZVZUQ0TnN5OUNTVnVvbUpKMzY3WkdDSmhMMjB0U2RicExoUVQ4UmdUZDFK?=
 =?utf-8?B?RXVvRENtd2p2RlUyaTdiMERNRUZabWpaLzZLS2FSQ25mb0tEU3QrTlQ3ajho?=
 =?utf-8?B?WHpCQWJnMHp2NU93OWcyeWJ5aE85bi9oUGRZSDZSYjQxMmRYZVRhMGFHU0Vi?=
 =?utf-8?B?aWFWOG94YjQwZXhVNlRCRTRydWhmSWNTVThKcUlxYWZyQTFhNURFamRNQU5h?=
 =?utf-8?B?ZEtMc0JzSGdEZU1VOWwxcVRNU2FyRE9UbENwKzBXckxZK3BpSTdEL0RzNVl5?=
 =?utf-8?B?UG1TckR3SzU0VFhhWjNEZ1hJbUZ6QUR5ZmRmcWdGV0tpQzMzRVc3VHUyK0tr?=
 =?utf-8?B?M1l1QjhJbVpRaTEra1pJSTdPK1lLSStiRDByVzk5Tml5b2dNUW80UUVlVGNw?=
 =?utf-8?B?R0NZbE1mRHdMN3k0N051UjhrVW9aNFhkSWI3dURXK2pHYjVFVE90YldtdUV5?=
 =?utf-8?B?ejM0VHhURER6cStNNDZLQzQwa3NiQktWWjNaaWZGeUcrQ2NmeTJqdU43MU9P?=
 =?utf-8?B?d1dBeFRseityRTZDc01QendEc2xDem1OQVJzUkpqQnE5U2Naaks0ZllzTUoz?=
 =?utf-8?B?N09QMld5QXVWc2FMdHduOHZnb3RLMTM2VjgwVUNiUC9nU3NDM21Wb0tibk84?=
 =?utf-8?B?eDVQL1NGWmpUNjFxREtHVFZQU2tabnpsaVNYb2JMWWF4bnhaQUY2TGQ3NXRH?=
 =?utf-8?B?TFJnRWR2UlFWNWoyaXl1cGNKK0pPN0RvcEJsN2xpU1NHU2RXQUdRNGU2ZlZL?=
 =?utf-8?B?K25Dc1IrRjVTWEQwa0ZERC85d2pYQ0J4YVlQdytrSEdJWWY5QmVHSGp2enFi?=
 =?utf-8?B?V2owdnlkSmF4OStzSWxaNkloUVB3T1loLy9NbUI5eEd2aHBPTWhianFYRE82?=
 =?utf-8?B?aDZVc00yK05IaWdDZmg5Q1NiV3hGS09zNWN0UUZXR3RlUS9JZVlxYVlFUyty?=
 =?utf-8?B?SmhjVHZUWUYzRmp0cEFQVmdPQzlVbWo2M2dwaEVScHZCeUZ5Zm0xN3MxWDVQ?=
 =?utf-8?B?RTAya1hBNy80VXlpeGFGVkdiWmFUTlpnMGlrcnpDOTVMUGtYd0oyZVd1RTRn?=
 =?utf-8?B?K0lIV3Fib0Jpd29PMzlFQkhYUkVxTzQ0ZGNKTUorVk12MEswTXQrQ1pnekRl?=
 =?utf-8?B?aVZ0RUhvZTVDNzVpM1pPVXZxUSt3SzRmam1YSDc4M0NVSkJHSXBKTDA5Kzkz?=
 =?utf-8?B?U1kxS3EzQkxMVTJOa2lqc1FxWGtVV3ZvSlF1VlpGd2ZXZ200dm9KVStqWXh0?=
 =?utf-8?B?R0UwOGp5OHV4bVExelNSdG03UVFKUFd0SWVkaG5pSzlwc0cwRVN3QUtpbmsy?=
 =?utf-8?B?Y3JURWpjZEJlYkQzdm92TnpzT2NBOTVIOUZGQjI3Y3cwVS84dzlHVUVIOUZR?=
 =?utf-8?Q?xyND8nm4ni8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZVRsczZIRTBLaE82bmViendyY0h6SGVlYTNhWjcvT2JrYUFocjJLKy9oV215?=
 =?utf-8?B?WDRwNGN3dVJVR2tBcms5VE1yZ3hjbmZtV25hSlMwM0lFZi9wdERXSGZDM1lw?=
 =?utf-8?B?T1hkekhJSXNsckJpeUVqbkE0OGRwTUxuN0VORThrZDZIdXpJVmQyd1pPci9C?=
 =?utf-8?B?VFBLUHJwVGZZQjViNWVocC9UeGRPUXM1d3NnYWxUVmNHU0NiVmQyZmNKMjls?=
 =?utf-8?B?dFM2QkJwNlRYcFJ1ZnZEQy90NHMyYnJ0WWV6VXhtYTRxTU9XRkJQRnF2dVYx?=
 =?utf-8?B?b3p4clhUdEU5QlhMQlIyK2RjampORVFKdzFSVUJ5SXl0c24xeTRPU3o2Tno4?=
 =?utf-8?B?MHZaM3Q0N3RNVC90ZmtBbDBMTm9tN1l0eWdHL2FkMDVBa2t2d01tdHV3WDVs?=
 =?utf-8?B?YVk4UU5VTGFOM3hkZUhBRUttVHFMUlArdE5MQkg1SjB5K1BvMEx4Sm5qZVhB?=
 =?utf-8?B?M0hZVG9FV0VMMlVrVWxwVTJvSzJRMWk3WXNjQmJsS3RIS1hydjFvNVFCRWdT?=
 =?utf-8?B?ZGk0V25UbTBTY3JRY0lQMEdweVZLOVprdXBRaFg5NTZpaTdpdWpBRnNPcmtW?=
 =?utf-8?B?U1N2c1g2WmZ6QlRtcUFCUmVxMjJxUUJVUmpHdDZ3K3lGWFFzalNTa0QvQ25P?=
 =?utf-8?B?VGtQSEdKUkhjQlM5NFhUUWhaTm5tU2plWVB2RzlyWlJYWUt3VSs3UnEwL2JB?=
 =?utf-8?B?bk9DTUE4NnpTWG5pYllOQWVvZDU3R05TSVRIK25KbWk4VWxhY3U4WFIyRGFM?=
 =?utf-8?B?SFZnK3lSUHlZU2lRMkNhS3R1RWlZQXVqN2IzdjRST01hR25uL3pOd04wcHo4?=
 =?utf-8?B?eTJlVWErOGV6U2ZnZHpkWFE3Y0VINE0vcWgxeW8zN1YwMUJmVnlZZitmZGlo?=
 =?utf-8?B?Yzk0NjJZR0lWMjF2dTc2WmtlNXpmc1krQnIzWTQwbnBUUFVWYUtGNmZLOVFl?=
 =?utf-8?B?dFdYUjZVdkJwQnRKMG50NzM0cXo0UXB6U2NUNXVLVkMxY3A4UUJuMmFXNkIx?=
 =?utf-8?B?OVdFQlRJVkE0NzBJaE05dXk0NmNQWk02UzhlZ3VMQ0hnVCtJeFlQbUh6ZVRj?=
 =?utf-8?B?T2JnS1JEclFxdVViZVF4OGQvR041TWtTSWVYeGRUWVAwYTlndDFqUnk0eVVB?=
 =?utf-8?B?VkVPd3I1Vks4UlljVk4vdm1kbnJDQlJ4ckVrMGFpVHJGdjlVcWNpQ0gwaDQ2?=
 =?utf-8?B?eXQ2RWFnQU5xd0lQcHlCUkVSdW1vUUY5VkQwZHFLUlhma0VXSjlkY2hNNzY0?=
 =?utf-8?B?Vzd0RWFCcW9oYWluSUtYVHpkblZEdWE3bkc5bzVCYTA5bjIvOFNJSUFlazhO?=
 =?utf-8?B?ODVxUmR4aEpHaUJpUTBjZ0RJTXFEb05wWjBWOWVUZEl0STNkRXBabUtoWHda?=
 =?utf-8?B?THZKTC81dE5uYVh0aC9SUmpDWEIyOFY5ZUh6OUZKRzZwWWxaa1RzcERKZE4y?=
 =?utf-8?B?Ym9hNGc3d24rcGxLc1RQL3FqOFI4cFFaSDRyNWNZeGRIQm9rSUpwZUYzYlV2?=
 =?utf-8?B?d2RnOTFxcXJEcWN4NUp3ekxwWGZhS2hVWmpsZUFtWmtDdHU5WUcrTVVNZkxW?=
 =?utf-8?B?dURtaUtDdzZpQndmamZKY0xQQ3ZmSUF2bFNneVEycmlQaExNVEpUNFZhNnhK?=
 =?utf-8?B?L1JKSS9XZGQrelJUVkZzbjlFK1NhUU50NW84bGtyd0VLSVNPWmxUNFpzNlh1?=
 =?utf-8?B?TVluZjFWbmFEVDF6SDUweWJ4UFY4dzBSaHloSGgvS1hiKzltS1dFYlVYWGJj?=
 =?utf-8?B?L3RVZEZWZGhJTXdDYXUxdkRwNXUyVHJmV0phOVQwWTFPU1pnaEd6MDJtL2RF?=
 =?utf-8?B?a1lpK2l1cnVMc1F3L21OTmdOUnNUOHE3U0tHS3NYMVVQM21XQlMvM3VjNTli?=
 =?utf-8?B?TktjRWZReXpST1lJb0xXQitGNldadFp2Vk84ZXdERkVDMy9kQWJLOS96NEpL?=
 =?utf-8?B?aUtuYXQrNzNucW1qZW1NQktwRjFyVFN2dzBEOFlOTXl4TlRMRmVIajJUclQ1?=
 =?utf-8?B?ZzA5bEJjWU5LcmpQd1VJakJZRU10TXpiR3NCeUxMRE5CYytMZjE4M3QrTGVB?=
 =?utf-8?B?d0hmNGQ0cExDVlF5R1hWUDQrQkNiTXZTTHpxMXVZRG9hbk9WU1VwVG1Qald2?=
 =?utf-8?Q?cCs3rgZDUPoTVWKSUisWeV8V5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a805d52-6b38-4460-1b79-08ddfabc787b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 16:15:54.0310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0bSDk2nJJZ9uWEdq85UQSGmEYcViv+q7BkjH3CU1wsy2u8uEkVi/66wxzP6YBvJWEOTevvwGASi/j3nMfJSulA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5880

On 9/23/25 00:03, Neeraj Upadhyay wrote:
> While Secure AVIC hardware accelerates End-of-Interrupt (EOI) processing
> for edge-triggered interrupts, it requires hypervisor assistance for
> level-triggered interrupts originating from the IOAPIC. For these
> interrupts, a guest write to the EOI MSR triggers a VM-Exit.
> 
> The primary challenge in handling this exit is that the guest's real
> In-Service Register (ISR) is not visible to KVM. When KVM receives an EOI,
> it has no direct way of knowing which interrupt vector is being
> acknowledged.
> 
> To solve this, use KVM's software vAPIC state as a shadow tracking
> mechanism for active, level-triggered interrupts.
> 
> The implementation follows this flow:
> 
> 1.  On interrupt injection (sev_savic_set_requested_irr), check KVM's
>     software vAPIC Trigger Mode Register (TMR) to identify if the
>     interrupt is level-triggered.
> 
> 2.  If it is, set the corresponding vector in KVM's software shadow ISR.
>     This marks the interrupt as "in-service" from KVM's perspective.
> 
> 3.  When the guest later issues an EOI, the APIC_EOI MSR write exit
>     handler finds the highest vector set in this shadow ISR.
> 
> 4.  The handler then clears the vector from the shadow ISR and calls
>     kvm_apic_set_eoi_accelerated() to propagate the EOI to the virtual
>     IOAPIC, allowing it to de-assert the interrupt line.
> 
> This enables correct EOI handling for level-triggered interrupts in
> Secure AVIC guests, despite the hardware-enforced opacity of the guest's
> APIC state.
> 
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
>  arch/x86/kvm/svm/sev.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 3e9cc50f2705..5be2956fb812 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -4474,7 +4474,9 @@ static void savic_handle_icr_write(struct kvm_vcpu *kvm_vcpu, u64 icr)
>  
>  static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_lapic *apic;
>  	u32 msr, reg;
> +	int vec;
>  
>  	msr = kvm_rcx_read(vcpu);
>  	reg = (msr - APIC_BASE_MSR) << 4;
> @@ -4492,6 +4494,12 @@ static bool savic_handle_msr_exit(struct kvm_vcpu *vcpu)
>  			return true;
>  		}
>  		break;
> +	case APIC_EOI:
> +		apic = vcpu->arch.apic;
> +		vec = apic_find_highest_vector(apic->regs + APIC_ISR);
> +		apic_clear_vector(vec, apic->regs + APIC_ISR);
> +		kvm_apic_set_eoi_accelerated(vcpu, vec);
> +		return true;

Do you need to ensure that this is truly a WRMSR being done vs a RDMSR?
Or are you guaranteed that it is a WRMSR at this point?

Thanks,
Tom

>  	default:
>  		break;
>  	}
> @@ -5379,6 +5387,8 @@ void sev_savic_set_requested_irr(struct vcpu_svm *svm, bool reinjected)
>  			vec = vec_start + vec_pos;
>  			apic_clear_vector(vec, apic->regs + APIC_IRR);
>  			val = val & ~BIT(vec_pos);
> +			if (apic_test_vector(vec, apic->regs + APIC_TMR))
> +				apic_set_vector(vec, apic->regs + APIC_ISR);
>  		} while (val);
>  	}
>  

