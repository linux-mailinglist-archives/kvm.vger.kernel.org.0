Return-Path: <kvm+bounces-10293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB42A86B6F9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 19:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0ABE41C21D07
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 18:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E44914085C;
	Wed, 28 Feb 2024 18:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z/DPKn2L"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD8E4084E;
	Wed, 28 Feb 2024 18:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709144183; cv=fail; b=gE8Hi2TkDSz1jCD0/hSIaqIESefU+WopgY1G5MbGeLhCFLAG15pi7Pj2j5/VjNV1Hkr/BntvueRB6COrmdzt8qhfEckj3KOulwiMeLJtKkCn70lNU8dNb91iDq9z0INddg13j57MbLCknGgM1UK+f0upjp9pez4ts3OauCJuJeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709144183; c=relaxed/simple;
	bh=MGsKJX4mcVdYAK5FC9t4V0bW6GfmwqrPhV1K6cc+91o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mC5tKxOQeFPG0Qw7KF8Wuaqfsf5TwPYCUybuz4tmF74SpoA2mk/Ui/jb+Vgn1+anOIzQjSvPsKfZ5lxyGj5yZsvGNB926HA6q3sw6SNRWfYH8U76LzH9tYs5HjQfnrhZryXXF+/HxjdQeWg+1HtEV1Z7W9ZwwPy4pdO59WBvarw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z/DPKn2L; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOoqYdbZVz3CjAMcsVU7AL+sFPIsm4B76nRsqtQMwFIyKEFfU7YjZ1gZ5MOSlzkhD2COGAhUVmVWPbH/f9T9acHI094dZGV9L+FEOb04i9rBvxpj6okW6SO20xrztYXX3U3LmI8h8ureZdx0BNZ47PLFHjxUHCQL31n8vt99h1XFO5mrV8D1fwL9geNrLwbq63wQafIqJwC1kwtF4wUWzWIPtSnBBNDUA1UsglyCa/6wHu3HYu+WeRzpPvijz2Bzxf6Nvlffk1Gs9uMye0caDNaoyDqBgy0ZwNzg9yx5LsNOhKVW1EgCsql6vdUjUCmuKaSpj+3q08UaR38E6FdX4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8QQBAXpKIWMbZdvM5VJTKu7bNGlQoyBPXepVedtWuE=;
 b=c1VFmlx8Qi6F+fIb/J8bsYrRBdLyjbTRlz+WdZmkfQz6nLVWnt5J4167v3LaaPGJcSDa9/kw5ezNd6rVyhqg7uHjNcDTWaTnvf4+TsJiT8aHP3fB5ndslD/wrwpPKtiM3cFiwRxhYMASFaYlA+dT5FYTO3s8Sn1893HqLaCb5sWhH8Q6jDsbbNwviJ4nBiiNYJ8M+U1S+eUV6FkIZLqNqp/kq+sqcf/try3jKwDT7/z1HQ/fYVBbVsvp3mVeX49v9+9oLh1SZTJ9H6NrfcWytqjOWxCqsxqWGzhceTgEezN8PCGVhzqOexOybi1Cx/6O0v1ha/ikAz9pJwP/A5jD4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8QQBAXpKIWMbZdvM5VJTKu7bNGlQoyBPXepVedtWuE=;
 b=Z/DPKn2LiUChVya5JAf9GC5EaJXl8WGA13ZVgjIalTL92Mm0/sX4W8ojlZC2syJI97n5sPU0aGkYTqTwbx7av4C/zJW4kpVXCAaiywHIgZj9l/noUca7V0bSvC9HWvDw0nM77WRAVYE3JgWORjvsXU+CO7Ik3k4appain6/oJsc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Wed, 28 Feb
 2024 18:16:18 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::dc92:cf24:9d0c:53ea]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::dc92:cf24:9d0c:53ea%7]) with mapi id 15.20.7316.035; Wed, 28 Feb 2024
 18:16:18 +0000
Message-ID: <d2e16738-377f-44dd-ae00-5c0c2c2da35a@amd.com>
Date: Wed, 28 Feb 2024 10:16:16 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
 Brett Creeley <brett.creeley@amd.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "yishaih@nvidia.com" <yishaih@nvidia.com>,
 "kevin.tian@intel.com" <kevin.tian@intel.com>,
 "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "shannon.nelson@amd.com" <shannon.nelson@amd.com>
References: <20240228003205.47311-1-brett.creeley@amd.com>
 <ead300c6e249429f92a4ce124fc0fd56@huawei.com>
Content-Language: en-US
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <ead300c6e249429f92a4ce124fc0fd56@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH0PR07CA0075.namprd07.prod.outlook.com
 (2603:10b6:510:f::20) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: c86a5b1b-8f52-4d4e-467e-08dc38895c10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QBtgLBj8DptxEDEQJ2Li6wzYGIPr3YtXHK1iXMrYgXGnuv7EAr+KJy0SzqtK03Xmyi5ZLUJoVu9omu67KBoZmA0hJaCbxk6uZ73bvxSrAWptuyJ9oJ9MrqN5PnTzbnQgqoiAj1wdQYxAfuSqPbK3+vFKtJV/3iarMx48BOkVxeC1C6WgV+iDUu7lNF+hgZNfPDf+iy20AeSOWnkwzLwXnkynQt316B1JgxmK4JkURPVXURZTsXvn00tT9FdasXTbRJhdhr/qdUb3hMiW/D+iTVikSotAIjVP6RxvcWbGxWk9J+3LGCvc73BPaY1weq903FTCbRf7jCBgjdwQtLAG1pDENDZvtKJTlbOplZGwEhujMYgOAPYWhb8W5m/EOJ28DVwo3XSsS+ZPntRsthBtg2U0fl2z1ReNc7pN05UBHK8rY2amTIFL+vXsN/2HdqKUDiwrIVBTS37enQUrc0DC4hXrvYE6sQaIaQJ1GdREY9BIppr1DdIOD4bcfbFM4IYKbgnZct1q/eUZT5h5rVLfAvAzis4EN4VPJNl/npWyw40HX3Ve37hY9QMsvK5DK+YvFTuZdXYuhy1l10mOttc3JLX0/W6LhKTS5WNVnhqJ3acP4OGMP+94BtKZzChU8xYNRoOQ0IYB5V78T5m7PZcsQA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(230273577357003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MDAxR1VMYUZza094Q3hyRFR2cWI3TEp5cmpXbzJicVN4MmtLUWMwZ0JYREpP?=
 =?utf-8?B?Y2duSFNjdTEzbnoxdWZnWVllcUt3OFdpTWY4K1hIK0FVWlRkeGNEZ2R4RlZP?=
 =?utf-8?B?VTlsTTJiN0o5czNoMGpVYU9OcnVibHNPdzVyaGFYNWEyeHorbXJUdmtmRlhN?=
 =?utf-8?B?NFp3T0NTa24wUVpqQmNUcDk5N1hrSTJ5YnpUMGo4SWdTRERuWFNkK29VU0F0?=
 =?utf-8?B?akRyYVFxVllOOTY0V2pwdTZJOHBpRDFvU01OaS9mMEpSZy81VFFDVXpRMndW?=
 =?utf-8?B?YUtuUmhJMTErUm5WcDR0bmxUVXVOZWMyMXRvNHVuZlEwTEtVSEJNTmJUa3BR?=
 =?utf-8?B?VmM5QkluTU1CVmtkR2VOOVUrWmdDVC93UzZtMmRPS0Ezai9VS3FjdURIK1Vw?=
 =?utf-8?B?OVloTFBoT0RJQkhjcFZXNk5GSVgwUlM4VlluZUVHaG05bGFlQjVMUHBkV3Zu?=
 =?utf-8?B?dnNsbWE0SklxMWswQ0I3dmhhV0F4UlRLZWlYWFdWN1YweHpCTys4ME1OTjcv?=
 =?utf-8?B?OWthYm40VXZHQ2VPS2l3b1N6Q2Q2NXVEQlhzc0FqZEhoajBIdUkrT3AzK0RO?=
 =?utf-8?B?T2VsKzB6VjI4cFZ4TEl6Z0dZeGpxSUdsbWJrK2RhMGdUQnlHSEprK2tZMWl4?=
 =?utf-8?B?a2ZnSTBDVkFiMGJ1Q3Bkc0tyY3NXWi81UzFNOWtKNUsyZlZBbldlaXdLTXVP?=
 =?utf-8?B?NXhoOGFKTW9lbjBESDB3eWNnNzBYaUJKbktoQ1d5OW9tZGhXSkRmV0QxYnBn?=
 =?utf-8?B?a3dRTURzcDdoeHEwMjE4ZjVUMTRUNi9NMjRLQ1hibVd6eHFSNUxvdGJJQ0I1?=
 =?utf-8?B?emRJckRQMEQ0YUh4R1NjdTBFcTRBMUJmQUtJU2dteEc5dmJXSmtuQnlIcGk4?=
 =?utf-8?B?UzV4ZXNiRUNtT2R5VllVYi9RaGZITmg2aUh0K082QTFRaWNQOTlkV0NNL09W?=
 =?utf-8?B?cW9jNnU4WU9iSGttS2ZLRFlwaEg2OFZySFArbkxrenVpNUg1OHQ5Mld1TjdQ?=
 =?utf-8?B?Wms4TmlQNThZdXFjZEdLNG1kMk1ldHBrSHNtMXM4RlhQeVJDZktpYklHMGJs?=
 =?utf-8?B?Y3lVSjlucnZZRFA5M01Kdjk3Z0dORVJjYXNPeHR3TGlsenY1Q0hWYnNmczhX?=
 =?utf-8?B?RzVCck9PS2dhbjVOR2svQ1VmK1FPb3VOREc5UW5KaUtPaTk3WFpjbmJOQ0tk?=
 =?utf-8?B?emltU0MzQXhGMGRUSlhSUmxNTjV1SEY4dTU0Z25XNHp0aWkrU0ZTUm1mYkhT?=
 =?utf-8?B?TlNFbC8valc2ZlRtMGRuVmJUNGc4bXM5b2NEc01EaTlQQWkxdGtUaUZBQ1hh?=
 =?utf-8?B?QnV4NFl1WUM3b2tXS2xMa2ZSU1dEY2hHbTAzQ0E5YTFrNmVrSVZINHdKQ2Ez?=
 =?utf-8?B?cHFXYmZSNS96MlVqcHdDMmxpelBoYlNLcm9pNFE3TGIrZzNDSkQ4Nk1PblVZ?=
 =?utf-8?B?K0VYNFRNUHkzdlJJbHNaaWJ6WXJlL3dpOWdUUEF6MFkwOXdPY1dNa3BLTkNG?=
 =?utf-8?B?WEpRdHYyRTFvcFpkR0QrZUo5WFl6bWRwUjRQaVg3OHFwYjgvbWlxNmpraHF1?=
 =?utf-8?B?amw2Wk5hSTMvdmJLdjY3aEppdW9XdDI3Q2NKTVdTQkdOb2hSKy9MWTkxalc3?=
 =?utf-8?B?cHZONzl0SjhOOEtqTVFhbis3S0RlcFRTZXplK20xMTlRVjhtZkRDSDUyZlcr?=
 =?utf-8?B?bjIzQy9pQnVHc0VFOXFhRFNSdmxSd3ZDMTA0RnJCY2ZLaXpKSHVhcDlkVGVS?=
 =?utf-8?B?Sk5SYlhwZ1ZzNm5HRGFXQzRWV1k3VWJCeGxhWFcvYWQ2ZVpWdUJkZ0dNNjA3?=
 =?utf-8?B?c3FPc3RpcnUxaFFvdjFGTWdBTzVQMVRqTlJpa240OE9BSnMxeUM5WVRZRWFL?=
 =?utf-8?B?eHZrRHBDaElla0s2Qmo0YzZJK003cWN3cTNpM1Izenl1OEVLSzJ5YVdpTS9x?=
 =?utf-8?B?d3kzQ0FETXZqdjQ1Y1Q1QmpoUUN3dGlOdGZVdUlEK3doVXdWelNkTHdUUnQ4?=
 =?utf-8?B?UTJJZW1SY2FLYmFrTUVPQWRXckJSNWJFOE5kemNJRVNxNW1ZQkVieWRwR2hE?=
 =?utf-8?B?MzR6UWMyWDF6b3V4Wm8wZU9QVUFwSU1SOWR2dVArV2FyS21Ma3hkWHdqcndN?=
 =?utf-8?Q?xzksgNez9dhRP2FCdsCHEBSCe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c86a5b1b-8f52-4d4e-467e-08dc38895c10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 18:16:18.7365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3cf1pSHWnEu/RZeWVi3tn5mmhKfdOAe6Xpo7Q1F82Lk0idTWU6OvyI/5OjRfuHMIj8eTr+ZulMBHX/Zj0OkG7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622

On 2/28/2024 1:05 AM, Shameerali Kolothum Thodi wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
>> -----Original Message-----
>> From: Brett Creeley <brett.creeley@amd.com>
>> Sent: Wednesday, February 28, 2024 12:32 AM
>> To: jgg@ziepe.ca; yishaih@nvidia.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; kevin.tian@intel.com;
>> alex.williamson@redhat.com; kvm@vger.kernel.org; linux-
>> kernel@vger.kernel.org
>> Cc: shannon.nelson@amd.com; brett.creeley@amd.com
>> Subject: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
>>
>> This small series contains a fix and readability improvements for
>> resets.
>>
>> v2:
>> - Split single patch into 2 patches
>> - Improve commit messages
> 
> Just a query on the reset_done handler and the deferred_reset()
> logic in this driver. From a quick look, it doesn't look like you have
> a condition where a copy_to/from_user() is under state_mutex. So
> do you think we can get rid of the deferred_reset logic from this
> driver? Please see the discussion here,
> https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
> 
> For HiSilicon, we do have the lock taken for PRE_COPY, but that needs fixing
> and then can get rid of the deferred_reset. I will sent out a patch for
> that soon.
> 
> Thanks,
> Shameer

Hi Shameer,

You are probably right that we can get rid of this logic, but the 
current 2 patch series is very simple and I would prefer to keep it that 
way. If you plan to make changes to the HiSilicon driver in the near 
future, then I can use that as a reference in enhancing the pds-vfio-pci 
driver.

Thanks,

Brett
> 
>>
>> v1:
>> https://lore.kernel.org/kvm/20240126183225.19193-1-
>> brett.creeley@amd.com/
>>
>> Brett Creeley (2):
>>    vfio/pds: Always clear the save/restore FDs on reset
>>    vfio/pds: Refactor/simplify reset logic
>>
>>   drivers/vfio/pci/pds/pci_drv.c  |  2 +-
>>   drivers/vfio/pci/pds/vfio_dev.c | 14 +++++++-------
>>   drivers/vfio/pci/pds/vfio_dev.h |  7 ++++++-
>>   3 files changed, 14 insertions(+), 9 deletions(-)
>>
>> --
>> 2.17.1
> 

