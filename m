Return-Path: <kvm+bounces-10554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD77986D68E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 23:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74804284864
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B44574BE0;
	Thu, 29 Feb 2024 22:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zAEqVb6H"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6DC76D535
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 22:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709244369; cv=fail; b=RV4kUkRxKhE/9yv7Ilbr0TPujq9S8s4YuMnnnJsVmt39FAb+xZY0iA8FzIlLlu8G+oT9CD/TAhWcSlhIzPb8fbm0TkseeARmUVAJsi8vHKWlWzD3JiMzdCopjrZN0oUUHUt2hCunXs3cTRSiL8w7F5AR8C1Qj/KlNC925vVDCzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709244369; c=relaxed/simple;
	bh=9UXICV3rUemDqg71ecnMLk+hDKmpNFr839hTxBaEHow=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M++SHjZRqSfFCdny4b9HkvSdDAgaftdboqHSHeroUctK0l5zwVi3WGaTevSKfweLx4sZS+2MvU2XzKeELTKYUJDvxpldNkF1f0tIIHxcCUB+2WokZV2zDNQ4sLpoS5Sln+1zcRsFqxX7poA90fajISsSifBdATKQ1x17E6X9/So=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zAEqVb6H; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCT4Uk1cl/4Zb9bWeDTEq1Z2alc/U+CMye93pGSqPSrYtrdXjzjieUOEvnRjD7ll/J3va9aDLgfybz2efEi6+bvx5j2cmCog7wadeG3Nh9CI7wZx7ZQR42HUgCnLeE2Ia67TzaQXWUXYGkv6qgTjcUKbQM9+Lj3NkuDZv/6DeaekCWxR5KrspvV0+a805nYtEwIHl8zbTFUw2GNrbCRmjdR18ALhRl43y7dGUIYA1FIpjUxvAatg03hpFXcCcrQDroE4crOsIpn0hrmHPe30Wl9yuAWyIH68/9hTChrnXEry12LWDLerfA16ayemyP3xFoZCHZ0IBqYWOFFaK6GbPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Fhsmdff4KjTeU8PcTYqAc1mjTKDOIcX0RJH1+BOSSQ=;
 b=IlvAKwLuXkFYbrHDvhhMDbWOhgpJyciTimdcsnOXg8i6DIu7bbl2fRjuXW+O+vtYxW511Xl3zb4wVemFQ/vBvdt4xIRRY3iCOsC6Rqd5iGu+muQ5GhM5XuAseEOaBdbe6UMg3K9k7IfcpfwspOnzhbptbY7HdIwihaXQZNLwR1bCtdHR6hOzhA2sPnwJrwC5t0rBaqryiUM2tkDxX/UzgYyPzVcag1mzVVGlaXRh1MTtCCl+pJtgklgnheY9cL6kux4akZhZNZzXs6Jy1/w8Myog1VrxbcHXawznG1vqtWs8qxjwJ55kAcJVeuJUzfRitDNd4e9ZbX9QXRGmmUOumA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Fhsmdff4KjTeU8PcTYqAc1mjTKDOIcX0RJH1+BOSSQ=;
 b=zAEqVb6HrHGsBS8AF+e8VqBbxd7IKuax/1NiZ8xruKI1OYQYl8xjh4rwTe0GLAatiQNSB4we25mqRn0yA/PzNVzgi80lPDlzoQF+naL4nNQIKSKvXD/y+hBA0uzxJnXfetwHHwQCpWvh/l/OUr4w8yMwb5iCRmERum6SER6vTOc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SJ1PR12MB6217.namprd12.prod.outlook.com (2603:10b6:a03:458::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.33; Thu, 29 Feb
 2024 22:06:00 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::c325:df95:6683:b429]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::c325:df95:6683:b429%6]) with mapi id 15.20.7316.039; Thu, 29 Feb 2024
 22:06:00 +0000
Message-ID: <eed5d95c-f447-4383-8163-1ce419cc0fe6@amd.com>
Date: Thu, 29 Feb 2024 14:05:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hisi_acc_vfio_pci: Remove the deferred_reset logic
Content-Language: en-US
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 kvm@vger.kernel.org
Cc: alex.williamson@redhat.com, jgg@ziepe.ca, yishaih@nvidia.com,
 kevin.tian@intel.com, linuxarm@huawei.com, liulongfang@huawei.com
References: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
From: Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20240229091152.56664-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:510:323::19) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SJ1PR12MB6217:EE_
X-MS-Office365-Filtering-Correlation-Id: 2436ad62-4acb-44be-97f6-08dc39729ce8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X6msv5rmfPQSIZyI+8Ri3kYbC1TDkex3lPyeijeMHEB6V69niSIFpMzBUuIFjmXdzSSv7+c6zcoDXPD4Xmhc6kyvKYqmrMul7DoRiyIt8RGjEefY8ZVcx/SagWvM/SJRxgO45RvUcjOAI6W7oJFUmyKRk71wT1SI6qAt+tT8MrcUUaMKrNfdFJTsthYS7bKf1XL7PeT3LInQbBn1EbDU6mXpSk456TSj3AwKUWy9gKgtTZKFjdB7oenzsFs0xDAUTcsPDknADugQqNDVta8QW9Gc/7BtoZ7zrl9eFQ6QEFQMboZWAymOyXFZg3LMPwNiMnR/xV2n58zXmK2IH62MLTAeAev9Yjc2UoojQ/1DeOPj4A+7U5m6ITVwYsiFKixb1vkUjoDvJnOH8YMsYhFyPYJShDzIWGiM2da1I4B4K+c/aLRzURbBdlUJZeNyQ1/88wcIR2uIZf3asycMgaN1xVqE47MBWevO7GZt+iGYfPVZlYy98eYOF4e5uJQGU4xB4dw/zffkTFWmFHIMOW2XiWi9H2UDrEIEIoY7KuPZjlH8VNRZlpgMFONc8au4/gh/CBLiuiB3XMmY3Kdvr9kKzFCuD4t+xdW4nNVO5LzT21Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?N1JXRlRWWmthSU01dlU4emtiamRUR1ZNM0FxN1B6YnJZYkdDYkJEZzNlQUZi?=
 =?utf-8?B?Q21nNk9OOVBOZmsvajEwRDYvTWhnSzdxTTdYNnVJZlNkR2Rpa0tYa1JlL0cz?=
 =?utf-8?B?YjNnOGpFVEh6WWlUWFdVM3k2NkFKQlRKalRrT0hYSWxUUzFqT0RzRGhsWDdJ?=
 =?utf-8?B?aDBuWkJ5MTM1Wk9qd3Q5V1NkeDg3VUQ0S0lNUnl3ZllxY1RuZVJlQzJVMmsz?=
 =?utf-8?B?WkxEWEdzVjBjN3NLSFIzU1h6RlVVRzM4V2gzdFBHYy9xcW9TY3NYZnBDMUF0?=
 =?utf-8?B?bHNYTk5jMmwyY2JYbEJBaWhTcDFzaVVLZkdnWjJLM1ZqbWdKR1VoREo5R1hH?=
 =?utf-8?B?MWdxdVQ4Nm1GOFFsdVl3RWdoK0NpQXhkL3l3TFQ5YlhTd0tQR0hCck43d3dU?=
 =?utf-8?B?dGpjWWdKb1R3QmhrblBZTzRwY2F4dHhVZm9XMUd5aFNKMjZIc0wyNHc1VENO?=
 =?utf-8?B?NDJmdDlhd3phYlgrS2ROYW5HRWIzcG1lUDc5SjJNM0N4bGRVdnF3eVhOTXhC?=
 =?utf-8?B?U3ZieWU0b1JWcm1LUWN6eDFqM3dPMHRVSVpJSWl6WGxqcTlNbmE4SjNZbXZF?=
 =?utf-8?B?dC9Md0xDcm1FbmNtTTN4MW1NVGVoTi9QQnFzdWZTRkFWT0dlRWVCd1lBYSt5?=
 =?utf-8?B?WjgxSjZYaTYvUGpzcGM5YllyQ2ZGa3hHampCcnRhb0ZlaHU1TEtKQzRGNDR0?=
 =?utf-8?B?d0ladUNCWU9ncnJqYk9iWHFjN2JFVnpvNkRxUDM1T0h4eW1RdzErVkhVZklW?=
 =?utf-8?B?MTM1eHlZR1pLRXNHT1VsdnVUTlp5Q0h5RERXWC9xWEtMMXdITlc3dlFZZnVK?=
 =?utf-8?B?ckpDQlRBLzZOZndjbU9jaUdiSEc0Q3JIOFBiNjBFL3dzcUhTRXRKRktZZTJZ?=
 =?utf-8?B?dTdwR3JTVC9wSVFhcFhXU0JKTGhzaUwzejZuSDNkQjZuclg4K3JhRXBKNTJR?=
 =?utf-8?B?bVE1clA2bjNubTdSa20wSFZ6MVFhN080OGhZbXB3blRqRUowZGtwWE5WWXRD?=
 =?utf-8?B?RnFPanNYZEpSVDJJOVVxVVRvWG15UlBPS255S1J2WnRLcHJVallFSENVbHBY?=
 =?utf-8?B?V3ZmWUIvMmVLYnI5Zmo2U3ZXVUxlNTAydXVjZXhHOFhhb3h0cmJjYTNKME1i?=
 =?utf-8?B?VUFZTXJXN2N6N1hoRmJRcUZ2TDRyVnBQeStmY0tWL0FpMko4RGdOTUs5VWtW?=
 =?utf-8?B?cmhTZGNJZmpFRGZkOW5kVENhbGJLcVl1SXZzSmlzTGgwZmpzejBlSlEwV1VL?=
 =?utf-8?B?TzdWZHVjbEpxMjkvY3FQN2xpRjQvbVk1eWptUlYyb1dkNFBDbUU2K1hxOFVi?=
 =?utf-8?B?NzZEYm9EZkMwT0pKbXJ6cHdUN1Q3VGZTR1czSXp3SERpUDN1UVgwQVczV2hq?=
 =?utf-8?B?NVBHd2hNMlJ0VklqOXdsWU43dnd4Mk1rZVZnVnlYNUNjVjJ5VmZPZGk4aTVP?=
 =?utf-8?B?Y1I5UW5QcW8wcXJQMWdxY3d5SGMyNnZlcHRzbFZub0REemlDcVlLL2Rmb0pU?=
 =?utf-8?B?eEJtVVpLaDRaYzJmSmtMOGZUMzhzYTJLYlp3RldTMkttQ0xtbSs3cmozYTNv?=
 =?utf-8?B?UG9VTlBRSFVJcGVNOGJjbTV6VlI0VGpTSEQxRFR5S1RHQVZmRXNFTFVxRGk4?=
 =?utf-8?B?YUJJZGp2eHBlUW03VU5TTnBseGU0MnllQy9aOHNTOHphQlRlYklLYm90UzRR?=
 =?utf-8?B?c1FBYWFGUG1FQmtBN1dobGhTaSsxSjUrWjFoTDZ1UW1YN1ltTVZqM09hUVdR?=
 =?utf-8?B?TC9rUjluOW55NE9ra0VacXc0RzBZbmpzQ2lBQmYzb3NvYWlMczR2OUlaaDZD?=
 =?utf-8?B?bWdKWXhPZ29wNG80cVQwdmM3MlVGMTYxUjZrOHRUMEFqd2FSQVU3bXRvVEtL?=
 =?utf-8?B?Y3A5dDhsTk9ySW1xUTFmUGFxNzlWUXpaVnd6azVGWFJCMFRLSnNoUmJQMDJ4?=
 =?utf-8?B?WDJWQ25YYkFKRW5XczJsNXRzS1owS0lFTGppTyt3ZlRPTUQwdUJoeHByWkFs?=
 =?utf-8?B?VFA5V0tHUFJYMTZzQ0N6NjZkRGU5TkFXcFAyUUpFUGVVUXNMaFhpeElMdk0w?=
 =?utf-8?B?QTQxSVFsV3RWQllpcmhPeHNycFE4d2JXeTBUbVdGaFdYb3pxazNGTUtaWEU1?=
 =?utf-8?Q?Mp2LtTiQ/a/VHb+gslWl7Lz4W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2436ad62-4acb-44be-97f6-08dc39729ce8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 22:06:00.2644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1EieVvu5b1Fz+mPrnw/Xip9MMrDqCddjJLrVZ6m82o0iktvaKhCMEYp926WoFqRYcUQpV53b1rVHUh5Q4rQ/2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6217

On 2/29/2024 1:11 AM, Shameer Kolothum wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> The deferred_reset logic was added to vfio migration drivers to prevent
> a circular locking dependency with respect to mm_lock and state mutex.
> This is mainly because of the copy_to/from_user() functions(which takes
> mm_lock) invoked under state mutex. But for HiSilicon driver, the only
> place where we now hold the state mutex for copy_to_user is during the
> PRE_COPY IOCTL. So for pre_copy, release the lock as soon as we have
> updated the data and perform copy_to_user without state mutex. By this,
> we can get rid of the deferred_reset logic.
> 
> Link: https://lore.kernel.org/kvm/20240220132459.GM13330@nvidia.com/
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Shameer,

Thanks for providing this example. After seeing this, it probably 
doens't make sense to accept my 2/2 patch at 
https://lore.kernel.org/kvm/20240228003205.47311-3-brett.creeley@amd.com/.

I have reworked that patch and am currently doing some testing with it 
to make sure it's functional. Once I have some results I will send a v3.

Thanks,

Brett

> ---
>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 48 +++++--------------
>   .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  6 +--
>   2 files changed, 14 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 4d27465c8f1a..9a3e97108ace 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -630,25 +630,11 @@ static void hisi_acc_vf_disable_fds(struct hisi_acc_vf_core_device *hisi_acc_vde
>          }
>   }
> 
> -/*
> - * This function is called in all state_mutex unlock cases to
> - * handle a 'deferred_reset' if exists.
> - */
> -static void
> -hisi_acc_vf_state_mutex_unlock(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> +static void hisi_acc_vf_reset(struct hisi_acc_vf_core_device *hisi_acc_vdev)
>   {
> -again:
> -       spin_lock(&hisi_acc_vdev->reset_lock);
> -       if (hisi_acc_vdev->deferred_reset) {
> -               hisi_acc_vdev->deferred_reset = false;
> -               spin_unlock(&hisi_acc_vdev->reset_lock);
> -               hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
> -               hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> -               hisi_acc_vf_disable_fds(hisi_acc_vdev);
> -               goto again;
> -       }
> -       mutex_unlock(&hisi_acc_vdev->state_mutex);
> -       spin_unlock(&hisi_acc_vdev->reset_lock);
> +       hisi_acc_vdev->vf_qm_state = QM_NOT_READY;
> +       hisi_acc_vdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
> +       hisi_acc_vf_disable_fds(hisi_acc_vdev);
>   }
> 
>   static void hisi_acc_vf_start_device(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> @@ -804,8 +790,10 @@ static long hisi_acc_vf_precopy_ioctl(struct file *filp,
> 
>          info.dirty_bytes = 0;
>          info.initial_bytes = migf->total_length - *pos;
> +       mutex_unlock(&migf->lock);
> +       mutex_unlock(&hisi_acc_vdev->state_mutex);
> 
> -       ret = copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
> +       return copy_to_user((void __user *)arg, &info, minsz) ? -EFAULT : 0;
>   out:
>          mutex_unlock(&migf->lock);
>          mutex_unlock(&hisi_acc_vdev->state_mutex);
> @@ -1071,7 +1059,7 @@ hisi_acc_vfio_pci_set_device_state(struct vfio_device *vdev,
>                          break;
>                  }
>          }
> -       hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +       mutex_unlock(&hisi_acc_vdev->state_mutex);
>          return res;
>   }
> 
> @@ -1092,7 +1080,7 @@ hisi_acc_vfio_pci_get_device_state(struct vfio_device *vdev,
> 
>          mutex_lock(&hisi_acc_vdev->state_mutex);
>          *curr_state = hisi_acc_vdev->mig_state;
> -       hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +       mutex_unlock(&hisi_acc_vdev->state_mutex);
>          return 0;
>   }
> 
> @@ -1104,21 +1092,9 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
>                                  VFIO_MIGRATION_STOP_COPY)
>                  return;
> 
> -       /*
> -        * As the higher VFIO layers are holding locks across reset and using
> -        * those same locks with the mm_lock we need to prevent ABBA deadlock
> -        * with the state_mutex and mm_lock.
> -        * In case the state_mutex was taken already we defer the cleanup work
> -        * to the unlock flow of the other running context.
> -        */
> -       spin_lock(&hisi_acc_vdev->reset_lock);
> -       hisi_acc_vdev->deferred_reset = true;
> -       if (!mutex_trylock(&hisi_acc_vdev->state_mutex)) {
> -               spin_unlock(&hisi_acc_vdev->reset_lock);
> -               return;
> -       }
> -       spin_unlock(&hisi_acc_vdev->reset_lock);
> -       hisi_acc_vf_state_mutex_unlock(hisi_acc_vdev);
> +       mutex_lock(&hisi_acc_vdev->state_mutex);
> +       hisi_acc_vf_reset(hisi_acc_vdev);
> +       mutex_unlock(&hisi_acc_vdev->state_mutex);
>   }
> 
>   static int hisi_acc_vf_qm_init(struct hisi_acc_vf_core_device *hisi_acc_vdev)
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> index dcabfeec6ca1..5bab46602fad 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.h
> @@ -98,8 +98,8 @@ struct hisi_acc_vf_migration_file {
> 
>   struct hisi_acc_vf_core_device {
>          struct vfio_pci_core_device core_device;
> -       u8 match_done:1;
> -       u8 deferred_reset:1;
> +       u8 match_done;
> +
>          /* For migration state */
>          struct mutex state_mutex;
>          enum vfio_device_mig_state mig_state;
> @@ -109,8 +109,6 @@ struct hisi_acc_vf_core_device {
>          struct hisi_qm vf_qm;
>          u32 vf_qm_state;
>          int vf_id;
> -       /* For reset handler */
> -       spinlock_t reset_lock;
>          struct hisi_acc_vf_migration_file *resuming_migf;
>          struct hisi_acc_vf_migration_file *saving_migf;
>   };
> --
> 2.34.1
> 

