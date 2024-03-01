Return-Path: <kvm+bounces-10657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F28BA86E70C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 18:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06E2C1C2130D
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 17:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4F7A3FE0;
	Fri,  1 Mar 2024 17:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="cfH4XYsn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2072.outbound.protection.outlook.com [40.107.237.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DA5525B
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 17:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709313719; cv=fail; b=AJmPBhLDK8rUfDWvmkLk6m1l13lw8txrZg8iXlMrErCKmoRq0fQZAH+joTMcTDFXl8+j/rQubPFDtnA/sdCVv5NPYghwas27CsFEh5bkOyfQhHukPjKfc2IN5lF7xjM7KWqmtC6wB6W5ReSBqZQeXzgAe8svKGnpvgO51OSnaGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709313719; c=relaxed/simple;
	bh=2GNVwDfyqFDU4u5ALxACMoOm37/AQuvp0GX1Ue4VDcg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z4EPiDDWEONCIBS+fZLshDix+lWTlRaZ/DZRaZuwQXz1VEIiiC7lM8Pn+sNUQhhGvt4PEALJ72LfoP1vlaw0SisRi+YRIbq8LUMW33g93TTHbXE23469fXcryoHE7KocTNTx4O6Gdr3QB510Buh6WiWm0XCih3L9m2uO/T3oJ8s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=cfH4XYsn; arc=fail smtp.client-ip=40.107.237.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaFflYcP9Rw4H2NWgXd8nADvJ9Q4Nd1B2blwr2+oj5tWS0G2G+1s+6ET1wQ1gskDBYa2nocQG6X44xTpNp1YJ9vI8LpR+J/4Iz32gmwuum8olkFOwMvXe767/BieDqO439VuqgZivc7VqFoMsCLJH0pm6gGWJIntd2rt2nv5Go6fhCVdMCiHnKpBe7FfA8qM/cOyv0Z2JdXGIY/hTRY/dFXedzhr4VsMZwpMAmAfcxGpw7gVa8/w8ETLjmAmiH3j8lNUOpXM7UCNLarcT+kpOdwFG7AUMv/LuX2Gy/qEmmbTlgqwFqdlIBQB4rpxr5Qt3rnOd1DLik+DZ/t0oT/usQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLb16mb4iNYJ/l1XZ4wZzbvtxzfTz5wPi6IWTspSIbc=;
 b=X5KOEEx3KDulL23FrwnxGet9QtRIz+E5PdNo6ib3d56f0ay/2X6rOY4NMH9TwsyHh/hOZRurmMtT4PR7Gs5TdETbTbXHAYda9m29CV5ucYnE3EwsPmeQS4xrmZlCcKk5AATit919af/Ci5aGwxlQjSr4OFatPlDVpQ5vHxGm+OB081VsCh2VOjSxBLtXz9NMS7Vxm3E2l/lwD5/sakFFDvuEpZqPKQA0KBu+r/OuiNOoyA1Mo0R7abl/lGX9BY4a94Oq1xhD/QJwF6AgA3GLBK19mbL/8PqO+5OYRLnXir2bStMCdX2rROtC13+lgic3R/CGSYqBAW9lMleSWaF1eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLb16mb4iNYJ/l1XZ4wZzbvtxzfTz5wPi6IWTspSIbc=;
 b=cfH4XYsnU9fWUYKbu/Brz/RCfeug7ncqYiBpZIF54ohQpHpoK0Rj3OrIcCxfhwZgRIFO3S5ON1QfuwaZ0WVYucHZxS3N0/7HiCOsOX5oLR8ALcCUMf2v4ptr+g6IobBzFm8K8E17nKLTLURlsjicrkp8++yewHnTz+grTSdWIvE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by SA1PR12MB8698.namprd12.prod.outlook.com (2603:10b6:806:38b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Fri, 1 Mar
 2024 17:21:53 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::c325:df95:6683:b429]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::c325:df95:6683:b429%6]) with mapi id 15.20.7316.039; Fri, 1 Mar 2024
 17:21:50 +0000
Message-ID: <5553107e-9ac6-4854-878a-93c9398b409d@amd.com>
Date: Fri, 1 Mar 2024 09:21:48 -0800
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
X-ClientProxiedBy: PH7PR17CA0047.namprd17.prod.outlook.com
 (2603:10b6:510:323::29) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|SA1PR12MB8698:EE_
X-MS-Office365-Filtering-Correlation-Id: f20f2df0-863a-4f2a-e3a3-08dc3a1414ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HSuUWJsR1TrjcvLXawrdbSEIaiQfaCQ4B7eZb8ayEW23lm3Eyuc2acbYAs1SFv7pVug2/UwrsdDzWzS3cAOnyFW2bsJvuwqEkJ7Ig5MEFMGkFpfr4ojEjFqFg9RpWhXQt+pb1SGAOrgohAatxUocz5Jaoq6CT5GGti7piBTKjO/n4kCjecZSC+RFs+r4MFxCp5KzLqyfBOc8u6hTespA8m9eHQwIiQHo0BjoV7c6+3c+gtcaXIllcQSo5r4E9hLy1ajBWao/9+eQ/y0Y9TvSmLhIU+cDv1gv4AvjHZShVYQneV6KMz0yhv8+CTNqlmufXEjPAPWsPLhyiw8JIkz4+1NTB3R1iBE8mjyQJRGCp+/3Q1f/Jh73gRAzrX+wgvr3ZQJJpw8zJRZgu0YDNLjgw4ErPuLd0yyyIuF1D07OljhZUl+1QPOwvfcwPL+Ew4osklmenMdLNaH5gFLzzzOHcq3/s9QJgQKNWRpzWP+Mb1lBYJM7u/i+eEG8U7KhNNH2P/OJX8Ot158XsJHvFRncZ1jBB/5kdud1YAvmHq7O/cyq9SXgBIVpBQto0Nu4siWTj8smrtgYukmRIgVC3AHaEw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWs1aGhnSm42RHFPVjEzcE54ellHelIwQ2dCY1hXSDJmaVl2QXlMZzU0VXhj?=
 =?utf-8?B?Wjk5a01UUWhLWW0zYUZKdTdJOFc4STRmcWQva2RMcHlGdmpnc1I1WTdPR25i?=
 =?utf-8?B?WkU0Q29ReHBjUVNuWGk4eXgzdXNkSmhiVmd0N2RlblFjc2RuZDRtcWpVUVp6?=
 =?utf-8?B?K3JleXBpemVXU2JmOEJ0ZTRoK3BYdnFLUi9QaDRFeVZwQW83M2xtM0Qrc0JO?=
 =?utf-8?B?K1N1a2ZMZ3YzR2dkMUIvT2JqQnRSOFlSd3ExRFdQUjByQmxqc1NLSmh5K0FJ?=
 =?utf-8?B?cU5ORFQ0TmNBWitocjd3alhTcDdsZENvQUErdDZ0bVpXTmNtU2gyQ2NUbEJa?=
 =?utf-8?B?SHRhbFZpMFRXUDhMNnpieGJVYnNVakZRUlM1U29IeEtPUFh0dGVxcStjZmpn?=
 =?utf-8?B?TFljRU4yVzdsQ0lJZG1tUlRXaVdyQlFEREMzdW9uWkJtM1ZYcXFKeWVUM01v?=
 =?utf-8?B?dzZsem1MSnFmQlRWbi9UZm1QUkJML0RVVW9mRDFvUThxNTNycHVMYU1KSzV4?=
 =?utf-8?B?QTZTQXROOXUwYlhXbERSamlHMHB1enRLbkRjMkRHVGc2cW9TWm5vSDRRODZG?=
 =?utf-8?B?YkNDaDhWWnROdGxWeWpPS0RHUlBCZXV1SXZQdWhPNEkyZmkrUVpZUWZETnpJ?=
 =?utf-8?B?bHIvNE12eFp6UzlYOEhEQVhFYWhmK1JQejlpU1kycXUzWE1PV0JJTDRjbDlV?=
 =?utf-8?B?R1FydlJ4ZGVNZXJNdDRYR0tNejBNQWVTOG0rdjFVOTRVQXY0U1hLSGUzZE51?=
 =?utf-8?B?LzFrd2srM0hTZXZMeHRLU2JTYXRIYkc1bHVSeVcrZ1llK3RCT2hueWlMZGZj?=
 =?utf-8?B?d3dOemVmTktoa3FrQWdNbGdnQzZtQUx1QkEySzdPdUdqT1U2ZUdLVk9GenZV?=
 =?utf-8?B?NnBGV1BSTnYrMjJHMmdrbFlFL3FIa3BJdW51Vzd3clRuSzYxNFVkSDRMZ3dY?=
 =?utf-8?B?NmpHWDVjTi92RDN6MzE4OEl6cWdNQVZzS3lKZ05jOXFTQ2Q2TUtFZGJBa1dM?=
 =?utf-8?B?VHppOGlQYWNFVWF2K1RZQThaL2lVZ2JBN3I1MzZoODJMZnY4U1ZqVWpEN24w?=
 =?utf-8?B?MHlHOTVzdkQxbkZKSTVvLzNnNVN1bURSd1NTQ1h2M0lia1NxaUdQQXc1U2sz?=
 =?utf-8?B?cEtQVzRqVElLVHEvRVplM1g2NXU2Z1ZWR2IzK05QNThFNE1OaVdNR052dktE?=
 =?utf-8?B?ZmY3SnVEamlmWFA5c3FaWEt2R2NVbnY0Mkl4eW8yRTV2Z3NmWjNiZmdqRVF1?=
 =?utf-8?B?b1lJS3hnUzB0ZVBraGY0eVpWN1MyaGpTdytRR0NTSnh5WXhlRktadGhqOTh4?=
 =?utf-8?B?Mll5eXEzbUxsZ0NiQTNZVW5ZQjk1R292L0JhQXVVcjQ1LzkzNVFjM1JlSmE0?=
 =?utf-8?B?d1Y0SmM2dnRCZW4xTG9UQWJjK0VxTjU1WnhvM3JWSVVHcENPamducUo0Z3JY?=
 =?utf-8?B?em1KQlFJdC9MRnZSQlNybHA4dG9QWkh0b1VFYk5mTjcxbGpyOGdtVHJOME1E?=
 =?utf-8?B?UTV1SzFKdjZzdGE0cXl4Tkl2VE9kRmVvSGVXL3JBQklzd0RrbDl4aHBHZDZ2?=
 =?utf-8?B?MWlCSFFaRjc3TGVQRXNwdHZwb01IWXRUOTJZOStYZ3h2ZVdmUzkxeDJYZWVw?=
 =?utf-8?B?dGgyYVhUeG5xbmgvSGFFdHJibDJncWVBR2JIb241Y2FPdnNWUVIzeHJGUEU2?=
 =?utf-8?B?MkVMNk5HcmdWV1pRdDYrQndybG8rNFFWbm16UWNOMVR4anZuck9IWkxIK0x6?=
 =?utf-8?B?TCtNd215Mm12Y0dOcXRTY3pTaFBvZVN4UmFDbzFEWHQxc2o0MzFVdGFHTHU5?=
 =?utf-8?B?eW1uWk44eFNGTUVDWXpBdHl5ZnBJZEhvYjJwZkJJNkd3bnZKYkp6eTZvTTgz?=
 =?utf-8?B?a3ByZ2NZR2taeHVRRS9hd0tiQjFLRlplb3dncjlsaVFwRFY2ejd6Y2EyMnd6?=
 =?utf-8?B?d3RQbjYyK0U0cngxUVN2TWFQVTFkYTVpdkhqa2pKVFduSmxRTzhHRHEvUTR5?=
 =?utf-8?B?TEFrUElZdE16WjZGY3diSCtNd3BXQTY1TXRmM1BHQlVpNnFBRFV0RUlHWTdT?=
 =?utf-8?B?bEtkTjhMQ3R3SDFWYytEcTdxWUVUaWh1aDREZ0htMjhCMWozWHI4NUt5T3Uy?=
 =?utf-8?Q?XasL9/zkbnu58KJAuA8Px/sMI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f20f2df0-863a-4f2a-e3a3-08dc3a1414ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2024 17:21:50.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WbjmUVtmeUNwXBknj53yfE/540FAhQuvq0+66aK08F5uO5QvTqTNjUWBxshZlxDmcPn8L+cw0FLQliUGIE47IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8698

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

LGTM. Thanks again for the example.

FWIW: Reviewed-by: Brett Creeley <brett.creeley@amd.com>

