Return-Path: <kvm+bounces-10841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FBE871183
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 01:17:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E3A041F21BA7
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 00:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FB21109;
	Tue,  5 Mar 2024 00:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N4z4chbO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2088.outbound.protection.outlook.com [40.107.243.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2E17FE
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 00:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709597855; cv=fail; b=h5V7x4hDhDeR/0iMj9EYBHC2gLIgrWuWvUrLpZ8nmnsVNI63LnlZ+FYPV0htVj3DNNyXRST8JK3p+wqlx2Dbp3FbsmedoDyChpCAx9FQOLmPzIwLtICF6jXzxV4L8Cx7rCZS5lqrd1oPW/x4TAUE6Vk/ElJwE0tic2qlTPM3Hv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709597855; c=relaxed/simple;
	bh=L8ifi3yFd6cGA7xGzmQC5McN064BMzxkf8Aq1mdpku4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aAJKHTGnG0NorXIBl4/Aj3wQI2y4Gz/iMYb4fONhXwifIQ85SuGnlUaLjzCxyq38QTOEt1zD2Zy0BjxAb4LRF2TlSo77OQFwq83rCs8NVhyJdbXF+/3emVNeYa2hR74AfN4L26lAUhzzF+049v9ddFnF5/lhzHRDCsFh/aDVYyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N4z4chbO; arc=fail smtp.client-ip=40.107.243.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KY0D1UeFkIc3lcdWXNUH6IsNtpPSzAJQuXMyaSJRJB3Xs52lFnhYQhBrE0ybI6RPe0E5kyMlnYtP0Ft9c9yRHAhHSvp8YGzQlkiakmflXQEBmXxeKcItCO12366xHwsfRixej7IVh68SjYwxudCiPt51JVQnGHajiq/llVSi0t0Pql2zMqHPwvbBwZj5hkTszsiu1Fs7FBbEM21MAmp2EwinnvuY/cu1wDwYzzzJB2zN3VpWAYSM1t9x3lYwitlgSQzq4sbpG+/V37qIJ1xnACFcf3imf/lpRt/xP1VsWprhu4yTmpGedU1Za4hIf3RgMzEveLGo5sLHekx2LIl76Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFDIYFB1NZHHQPiK/JFrnZGIiFrIt6eEku8ARh55ZQc=;
 b=NukWv2J4yKvD5STz14vaoAxODCCog2J28URX1jhk9o9ad4DAacHHxbDd59p85nYc2iHwadcddX/40RTvTcQqHeZOAcrkt7eCXiFcBUB/M21d+FmJcHIIA/tNb+aE8mZOTX3WHUlr5csDzZYyWD6rnp9/KJzngdixpmNn0Dwg0e8k2oi1/2J/SvlK8FB6qimDPzXTJkVBJQRgrIkausePk5DdbghqzINkdYy2hN8qSXpfjLm2dOlre7KNbqr59WH7vqNWkGDNIDw9dphA3HaB9ybi1+MrajyBEDpc7sghgans6iMEAd31D670130w1ch4m+bHu0CFrJ4M9Bv28IliOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFDIYFB1NZHHQPiK/JFrnZGIiFrIt6eEku8ARh55ZQc=;
 b=N4z4chbOgbd8mmI8rBhDwMr8NpJXvjUCmygjNv7d28vC14A9ZUXK+TzAp+uB2MSjLYM26eQapyuXUV+J04T5++mcCemnlWhrzVL9D7dfO+Dzuo/yRKmt0HyQ3dgzq5XfoGGQcjOo7t2/uKfK0rWC7g3KY+Puk5PRIIuQhtLAykU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA1PR12MB9246.namprd12.prod.outlook.com (2603:10b6:806:3ac::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38; Tue, 5 Mar
 2024 00:17:30 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::c325:df95:6683:b429]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::c325:df95:6683:b429%6]) with mapi id 15.20.7339.035; Tue, 5 Mar 2024
 00:17:30 +0000
Message-ID: <37a234f6-faa7-4733-b958-f239263a583c@amd.com>
Date: Mon, 4 Mar 2024 16:17:28 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvm@vger.kernel.org, jgg@ziepe.ca, yishaih@nvidia.com, kevin.tian@intel.com,
 linuxarm@huawei.com, liulongfang@huawei.com
References: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
 <eed5d95c-f447-4383-8163-1ce419cc0fe6@amd.com>
 <20240304132733.2b7044ad.alex.williamson@redhat.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20240304132733.2b7044ad.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0068.namprd17.prod.outlook.com
 (2603:10b6:a03:167::45) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA1PR12MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: 1adc5bda-1b51-4fb9-9f5a-08dc3ca9a599
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nK1plfeO1PPBdriIeXmFPC854PJiMYT99lmKV7poC/sgcJ2tC1gy3OH9Wt/8J+iNmF5TtaJl7TXPWq9jSON5lJ0BvQsa41Ritknw1+QeSleBHN+/swRfa+SaBUB7XvU8HWSkFkIVDHzIO2JNQbCRRzpPA+LcHYV+rCgl19TWiXRmtTeQetYsGDQwgOXiVIH5z/gsQ5Cj/fTRsMmrg//IIGc0Fph+ZljRfWFUPhetYSL2ezNyGnjPCdu63BKkJkbI7Fbf13M5xOuEyizXtaAUSfUDKLvNKHgVfneKPjnaxmub4gvc5vXTTJTlFYvo2C9wJ/P2LT56ej0KqLJBchZOq1SJF6WRWehV1SJ/Au2yavJehvU+pRv7AC1l8FRlkhKilmHky9Gkof3vKEa5QWOCwNVRe42wTeUTuAG5kInss84lW0Wab7dpNwv33DiJgVonfSg5Zbfxuukdd2maMwyITcd1AGfMpuoobmE8rTKXbkiyd9AjE4aIzj+IlITZ7K9qPYRlZB0L0oLr9qvVvKMXCK1xQT6s1MmeSJItnewTd7ciFr1VZN40N18tOnxjL5maNIaqbnzeDJ+Fzvsv/cwF0DBIH3cfOiMXi9CBe+PHia+P3utANVB7ZjhYLttsjK+p
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bTUweW1wRDRjY2t3czVyVjNUcVFzNDJRanFhK0JxNk1CUmFRbEVBamxnOHdn?=
 =?utf-8?B?M25CZXZ6TWdpQ29uNGFvVEwvLzNOYUxxaDIwWk9JWVVMcGQrbmdFNXpWU2JD?=
 =?utf-8?B?ejBZNEdEdDFKM1Q1S3FEeW9VK244ZkhWRlF0QWowc3FNWWRlcmdSRE92d3lY?=
 =?utf-8?B?cUZ2dUVURUNaZGQ5b25ISW1QeWhEQU96ckhuMFliZU5Bb3JCZlovMjYrQWZK?=
 =?utf-8?B?Nzl2bDBiR3lUYkVmYkJINWtwSHlEVzdyM3paa0FoTnBqQWRXdWZENitMcHFr?=
 =?utf-8?B?aG1iQ1BKbHNsNVhWRDNKQk9aRXRpODhvdnpBNFlUUFpDWTNyWSt5Smp5Qmpi?=
 =?utf-8?B?VE5ZYm1RZkdiVVNMNDhRcjErQnZrVHlpRTlGN0V2WEF5Lyt2elcvZ1Bqck96?=
 =?utf-8?B?OWRVM0syeTZDeFZOeDFiSzZFWkhCRUErRHpNblNJdkdDbitjRy9LRjlzK1N3?=
 =?utf-8?B?d3FLZlhSWGFtUk14L0ZWZGlKR3paMVg1czNreXhiMittemd4bXVMeXNrUTlR?=
 =?utf-8?B?WVFOZmxSUzRUbVFIdjFreWcrUXFMMXdqTXBnWFVRRFc1RUZwMXowQmR3WWRo?=
 =?utf-8?B?bnFSZXMyYU5rWDBxQXgrT3hCQ01aenBNTk5ybUJMajlERld5cVNGZ0E4VXIw?=
 =?utf-8?B?aG10Tk1hUzlCR1dUTWhoSWFvWUdxNnY1ZUtjYkcxNUU0Y0w2YzRRbGRQSlZQ?=
 =?utf-8?B?a0xsTEZZcHQrTmthSWJDMVd3NGtNMHBIZWZCM29OYkRUUjRMZmlLRjNRb0Zi?=
 =?utf-8?B?dFBBMng4NVlxUnlCVStoU200VWtnQTUwYVRBTTlpbmc1RllmdWFGRWFKVFVp?=
 =?utf-8?B?TU9kQWFKeFlsM3lDUFBkMGtEb3ZGUXNIbGZBLzhnTkRDUEt4eEZSMXFpM0Iv?=
 =?utf-8?B?cU5ucVFqUTQ5UlRQRWFrcXpLOGlkdElmZTdIU0xFdS9RWGZIdW9LYW5IUEhn?=
 =?utf-8?B?MUdEbGp1bllNREJpMHRINEhRTkhSSk15Tm9ObFBRNExKVWZwMDBPV0hHWWd2?=
 =?utf-8?B?OXhPQ2JSZFdFamJ4YjBOSHowSVZxREE5Mm83Z0ZCNEhlZXRQUUpaVHdUTk9l?=
 =?utf-8?B?bnlZdXVlZUZSUVE3d2JFK3hiNnFRbHF0U2hQR1VWaVJpOG9rUHQ1alFEREU4?=
 =?utf-8?B?RjVPN3ZDaklrMFhWODdvajF2WC9pbS9ZMXpzQXQwZVRxd0Z2cjZjRVQzMmNH?=
 =?utf-8?B?OGhWVWNGeEM4cFdtT2FHQ0QwVS8zNDJCbXN3QmJCbWpJZ1hVMjd5c05oVlBY?=
 =?utf-8?B?VGhUQ2lySlhpYzRicFNQQlYzRzlPb3lpOVdzNzY1bmVyamEyL0QzTExvUi9E?=
 =?utf-8?B?WENqOGFyejVZU1V2RXNKbUowY2FpU2xtRjFUUDVDSTg2NFljc1l6ZTYwb08w?=
 =?utf-8?B?TTZSUWhlR2F2K29JajkxNS9JZnBYeFFqZEw4QnRYVVVwVjRHdWVyaFRaMzl0?=
 =?utf-8?B?aVpYaXBDRjR2Tit2djZjb0tnbWU5VGxUUmhLVzdkOG96VmRrRVdvRU1NYVY4?=
 =?utf-8?B?ZTVlUnFzWVhBYk5ON0ZmVHZPckNsK1pOWU96M1lCUmJDdDBCQWpiR3RFSk00?=
 =?utf-8?B?bkt6N2ZGMG5ENUd0dXdjSFNoWEh0eFBzR3JTZTYvVE5HLzA0ZjlpRFRIbldO?=
 =?utf-8?B?QUF0NXN0cFBzVmU3OTZVS3ZpbFo2UHN6QVhGQXd0bVVNYnl5a2xwZUFVSVd2?=
 =?utf-8?B?b0dIWUJqSk1nRHp4eEkxVHh6L0IyQmRNb1NRMnRSWWtnMzltcjFieUMvRlow?=
 =?utf-8?B?U2xqWDUyS0haUXRQZGJnMjRwL2x5aXk5VVNraGJ6Y3pmNFh6UUU1VWFlUTgy?=
 =?utf-8?B?dHZsZEFKZ0FReHFZZklRcWNQc3drSk1HcUgvTHBaYTlFYW51ZUl6SGtWNi9O?=
 =?utf-8?B?Z2lPbzk0UXY0ZmpPZG5xUXBwN3NKVk1YczZtVWx4bFZPbzRBQkJqb1Q1Y09r?=
 =?utf-8?B?SGhQVlVtemhyWlBtdVlaZ2ltWFY1a0svbi9UUEg5ckYwRTUrVGU5U1dHQkpr?=
 =?utf-8?B?aU9lMkxTR25wWTdDMTUzaGdNQWhhUWVhSDh1c2dpTzJvdUZtSW43VUs4VDRR?=
 =?utf-8?B?TExiVkllNDd1VEJTbk1EcE5FNWdES2ltOURDcmJBQjdWWGhjVktvUW9DTWpC?=
 =?utf-8?Q?WE5p9JTOVk6gBHimBNMu+SoDM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1adc5bda-1b51-4fb9-9f5a-08dc3ca9a599
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2024 00:17:30.6423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yl+RuRKPEuit9ty9ZCBwKZhejlTc4cuOXbIWT1Z7udHOvKxC7GlAK2KSKXCT8kgVc20nh/PzcizjlYDk0NGBRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9246



On 3/4/2024 12:27 PM, Alex Williamson wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> On Thu, 29 Feb 2024 14:05:58 -0800
> Brett Creeley <bcreeley@amd.com> wrote:
> 
>> On 2/29/2024 1:11 AM, Shameer Kolothum wrote:
>>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>>>
>>>
>>> The deferred_reset logic was added to vfio migration drivers to prevent
>>> a circular locking dependency with respect to mm_lock and state mutex.
>>> This is mainly because of the copy_to/from_user() functions(which takes
>>> mm_lock) invoked under state mutex. But for HiSilicon driver, the only
>>> place where we now hold the state mutex for copy_to_user is during the
>>> PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
>>> updated the data and perform copy_to_user without state mutex. By this,
>>> we can get rid of the deferred_reset logic.
>>>
>>> Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
>>> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
>>
>> Shameer,
>>
>> Thanks for providing this example. After seeing this, it probably
>> doens't make sense to accept my 2/2 patch at
>> https://lore.kernel.org/kvm/20240228003205.47311-3-brett.creeley@amd.com/.
>>
>> I have reworked that patch and am currently doing some testing with it
>> to make sure it's functional. Once I have some results I will send a v3.
> 
> Darn, somehow this thread snuck by me last week.  Currently your series
> is at the top of my next branch, so I'll just rebase it to 8512ed256334
> ("vfio/pds: Always clear the save/restore FDs on reset") to drop your
> 2/2 and wait for something new relative to the reset logic.  Thanks,
> 
> Alex

That works for me.

Thanks,

Brett

> 

