Return-Path: <kvm+bounces-9313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1430785E099
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 16:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0263A1C21FE7
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 15:11:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24948003D;
	Wed, 21 Feb 2024 15:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="laRvX2/e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C5D7FBBF;
	Wed, 21 Feb 2024 15:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708528304; cv=fail; b=KsyNI+WRkGX+Pl8cCQrQkZarul+0upUKiuzHqdWmqFo64mLqfsqpa0UWQrMbjinXTPoZyEmBEjlkCcEFx5u4UPcGkWCdKzlx6Tb2GW+zyrJApysAXZuFYmvdOpUMkJhs9zORreTrM/uIcSJJpZysQ6cFCq51lho/Uw41MC94uwc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708528304; c=relaxed/simple;
	bh=ofHgS2vfWQHjLr96ETkVQCJhzbsgpOVkjNP6m4CZ6yU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=H64n0j4JS8u99AZxbuW8enYYnThd7L9NpLcNv02lmaq730TxBCGw58MgGl7BkYzQWweznJD2HjBuXJegT8MTQlPnWslpV63qY20gF+R2cqbHvuGFB7vl79wAXvihawU6GkTmHm1ZPw16XlMk6BsQXaGkdBLxSEFxxfSYsZOMtsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=laRvX2/e; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYZTd5CQ2T5HR2SGUDq4fe3vcpn87dqGWlMSdEBjkcxytCAIorZPd5FxuCAb2/JqNid0YyG9DMpGaxZ1HDWh50FfxicvufHi9k659jpENK6RWA3ydsj8uknJQWeNWP3wiXQ64gaUNX3Wy+/l0MEKBQo8ivLGt1gkovRI4ND9es5J3KWnQUSNw0n0NemLOxssFF9ZNrVmOb3j3l1iCbIS2jeE96cIl+Hhh8ARqEZaJ3EQhZXtLIwkWd+NhMtG4A7O7fetyt0NTqfyshJPKJbGwT8h3thjjrRUuNV7rWqIP5YM6duCo9+sAdl0AGPiaFdjz5GxGIUcmXzdIbDhFa7LIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUs+eMkUb8WwqB4CnrUZhSQkQmu3Pe2NzGB2vovYnA8=;
 b=oH9gWGjfZCEM8oHp5fE7QvHZ7Jl1yR41KgSAt4qEjU/RQ7O34JH1SPcI5tjPZJWeV+Oo2cbcOUKGiidLWewqM4WCNfgKcfSUw9X3wyffBrwly8snbKEXRt7nnbIEhNOd0ayzpDcl8seNia5em9fynSHe+zzzu8oA6idZDebKmymqzrPhSRykeGZvB2O0KCPxda5pp9D5OtImCla76bpHIKziwGeeBLGoEUReBNI6hWKra6IoP6h/7eVg743o/Q9RhNx4/dTlqyTLZaPJjF2fq2garAfE9WOoh+G2KU8gtAzOvTQonWhObuquzt4WnNfHSYZTSZlPPWbbv1mmPYjZGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUs+eMkUb8WwqB4CnrUZhSQkQmu3Pe2NzGB2vovYnA8=;
 b=laRvX2/eXlz+oZCtwsSgQe5jTBN7j5WG1+ZBsykXZ/rHkZwT4QxXJfnpQlvJMACCn8M0Xz+dp54Cvk8CdtrqbdDEtsyEz16f669VPYFaS4e3eA0kl9ul+r0C1aM6Ym73U911mL04RGGThBrzofays6w5QL2XJpnLbqfUHtlE3OAgbnwEi65PbI4HHntQRzTjBoZG5vjGYRGOlXavCxPLLZd47drQX7nwqKms7rYv70KDo77P7UbjG3Ze9kpTdHyeckOdl6pdNEG7pjAOPZwYwP7pkyc8LgDj1FvAGhIqPOxZZPd8rmfKhp6a/W0QiLCR9VW4RTwlLIzBE2JmFQ/IXw==
Received: from SN6PR01CA0012.prod.exchangelabs.com (2603:10b6:805:b6::25) by
 DM6PR12MB4468.namprd12.prod.outlook.com (2603:10b6:5:2ac::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.22; Wed, 21 Feb 2024 15:11:38 +0000
Received: from SN1PEPF0002636D.namprd02.prod.outlook.com
 (2603:10b6:805:b6:cafe::b7) by SN6PR01CA0012.outlook.office365.com
 (2603:10b6:805:b6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.40 via Frontend
 Transport; Wed, 21 Feb 2024 15:11:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF0002636D.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Wed, 21 Feb 2024 15:11:37 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Wed, 21 Feb
 2024 07:11:16 -0800
Received: from [172.27.50.144] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Wed, 21 Feb
 2024 07:11:12 -0800
Message-ID: <461b50e9-c539-46c0-96ad-d379da581d8c@nvidia.com>
Date: Wed, 21 Feb 2024 17:11:10 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, "Zeng, Xin" <xin.zeng@intel.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
References: <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220132459.GM13330@nvidia.com>
 <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220170315.GO13330@nvidia.com>
 <DM4PR11MB550223E2A68FA6A95970873888572@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240221131856.GS13330@nvidia.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20240221131856.GS13330@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636D:EE_|DM6PR12MB4468:EE_
X-MS-Office365-Filtering-Correlation-Id: 50c61f50-41d9-4339-6c99-08dc32ef669b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dnJ+2wwwDyYNEFRia00s5+3D5+wUIxBRPtO47rmHTv9UqVudZd1GFgQ2NNB542a0GgRGpmd9E7Xv2nqU2HDhmv0nhj91XrM34peaNyiDxF8KvAA5jxc3nVCJBXiyatiGMmf7K+SiuIJMElauGDjovz2d9qLnQVH07mWi5mIhVFziCrpt8Q80yxcOt+K3RiyPg9HzXohAiS+KD01OBdOhjnmg+VUCiUVSysoU7pQB6uoEcxW2XiuY9QdIu3PkxrOXhcBPIi8EDLcxeWK6BNs/aGfI8W0LkqGhjGyn/Xm55/9gQa1BWcW3/YXID8A4Zw6e9HkZxr1/1+lI6bMU+0gbkFm8rWCoOHnCWy/5pWBbEEHpR3Xt+rmETZ84pLJC2SDMY/luuJTKUwtIzbEiWmoHajBstWOD2p/e0rc2Js7JmhmKw0aFXrqTH+NBjPSs0CSY9CITI/IiSYjgMPa5x3mHkTw/fSftSqyeo4LfeJyk/mK8WnH8DX5F1K/aqB0mfAi7Bi+0vq5xErXfzlVGSv3DZ07J0zMV09320fBwunlKQNN7DoD1NV0ctw3f0TBI3uIXVM5VacXvXR2Mr28qv9Ydy2heZZFJOmbhG77I2RJ21hN9duz+6NLBDZJGZaxFqLFW0ljf8pQaQBnibUozasptiJ9C0OAM/4v3iwoWpIvhtM9qIRqeO+IDgQ58bBel4sUoDrnSStbxEItuv/DpS29MiQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 15:11:37.7927
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c61f50-41d9-4339-6c99-08dc32ef669b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4468

On 21/02/2024 15:18, Jason Gunthorpe wrote:
> On Wed, Feb 21, 2024 at 08:44:31AM +0000, Zeng, Xin wrote:
>> On Wednesday, February 21, 2024 1:03 AM, Jason Gunthorpe wrote:
>>> On Tue, Feb 20, 2024 at 03:53:08PM +0000, Zeng, Xin wrote:
>>>> On Tuesday, February 20, 2024 9:25 PM, Jason Gunthorpe wrote:
>>>>> To: Zeng, Xin <xin.zeng@intel.com>
>>>>> Cc: Yishai Hadas <yishaih@nvidia.com>; herbert@gondor.apana.org.au;
>>>>> alex.williamson@redhat.com; shameerali.kolothum.thodi@huawei.com;
>>> Tian,
>>>>> Kevin <kevin.tian@intel.com>; linux-crypto@vger.kernel.org;
>>>>> kvm@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cao, Yahui
>>>>> <yahui.cao@intel.com>
>>>>> Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
>>> devices
>>>>>
>>>>> On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:
>>>>>
>>>>>> Thanks for this information, but this flow is not clear to me why it
>>>>>> cause deadlock. From this flow, CPU0 is not waiting for any resource
>>>>>> held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
>>>>>> to run. Am I missing something?
>>>>>
>>>>> At some point it was calling copy_to_user() under the state
>>>>> mutex. These days it doesn't.
>>>>>
>>>>> copy_to_user() would nest the mm_lock under the state mutex which is
>>> a
>>>>> locking inversion.
>>>>>
>>>>> So I wonder if we still have this problem now that the copy_to_user()
>>>>> is not under the mutex?
>>>>
>>>> In protocol v2, we still have the scenario in precopy_ioctl where
>>> copy_to_user is
>>>> called under state_mutex.
>>>
>>> Why? Does mlx5 do that? It looked Ok to me:
>>>
>>>          mlx5vf_state_mutex_unlock(mvdev);
>>>          if (copy_to_user((void __user *)arg, &info, minsz))
>>>                  return -EFAULT;
>>
>> Indeed, thanks, Jason. BTW, is there any reason why was "deferred_reset" mode
>> still implemented in mlx5 driver given this deadlock condition has been avoided
>> with migration protocol v2 implementation.
> 
> I do not remember. Yishai?
> 

Long time passed.., I also don't fully remember whether this was the 
only potential problem here, maybe Yes.

My plan is to prepare a cleanup patch for mlx5 and put it into our 
regression for a while, if all will be good, I may send it for the next 
kernel cycle.

By the way, there are other drivers around (i.e. hisi and mtty) that 
still run copy_to_user() under the state mutex and might hit the problem 
without the 'deferred_rest', see here[1].

If we'll reach to the conclusion that the only reason for that mechanism 
was the copy_to_user() under the state_mutex, those drivers can change 
their code easily and also send a patch to cleanup the 'deferred_reset'.

[1] 
https://elixir.bootlin.com/linux/v6.8-rc5/source/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c#L808
[2] 
https://elixir.bootlin.com/linux/v6.8-rc5/source/samples/vfio-mdev/mtty.c#L878

Yishai





