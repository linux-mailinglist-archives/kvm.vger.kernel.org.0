Return-Path: <kvm+bounces-12316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF33188161D
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 18:07:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CF9A1F23334
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD98669E02;
	Wed, 20 Mar 2024 17:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EltbW2/A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C896A035
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710954424; cv=fail; b=FzHbqO03ZAchA3NXqOuPjXsZdHxaZN+BI214UYkpMt/Cu/oVJqJrRP+fFHhRvy8JaZDNZ0JHBEjr9wGJcHYVDzKxNEuifaOghPuTdVaKxYcGEhKNkkKMrrbQ6NZPOd8nYOoUt+/WN7Pr25uhsNypOHt+5z4P1reMfKnTeyCPvNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710954424; c=relaxed/simple;
	bh=fPvy4tncEd1pRbdPsThu+VneBPdgrvaokwQ0aaOk2DA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gtOzZDbTzWpzu8M1REHXGMwEUNkEIwoddiKW4N0e2q+B5s3JDWADhzHkLbqAaH2I7L4H5TWFi3iZvLxuz0fUVRvDEMMn+42PUT8i8YHvFC5c7O57W5HWFgAS2QcRQLokiGsp9D0XDEQVSYnTWJZ5pKOsdngr9GOz4WTS26V9MQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EltbW2/A; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ko0SJmB6ItcwGnIqKtxbzhU9W4rUopqpLiDOlENaEll2xKN6x9rx8NLV83Rgeyzc+VRCH5/dCz5BAgTve39axpKL710sbfqwDXpSbarDvGWoA2BTmjKNU4SB7+ReOCXO1F8gE+Zz6H2txVH/2dTw4RuGP09/HPE1x5vIbZi221yycqBe4A/UUFjffn40H4gzMPkeD/nApJVAlKrMZZtrktnPKyio7yk/Fll4poJWatTXJ51ysjrvdZ8vaJ1o4dsBEndcTa/27+2ngPOHf5+MWj6GL3TzZzJgMWi9BQCzxHkYuieknJmAK3auqqD0cSsEDS236YtEVEuQnuliR5NKpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpGdzk3mqoIKBR888KeSWchB+9HYWMUSHMcnC1ZIBV0=;
 b=H5j+3FHEUpv+r0pVJ8N/aDcZLzh5RVCOCt5xTYOvgpwwqLkxuLnC12o+MYr9clrf0/e5kqOMuhfMCX8JhdL0T19fsW7QdbXcfYLzQ3ACNrKSJdU8hsVnagpjb/mahXyLm3Hwrr+/Bjv3DyExZgGcwwnA+tbyA8q6oj5th3dudcSgLD0184V2zzX4X5rgLwh8m0/oePpSEgxVwM7u85THd7c5zxjOPxweqTuw5hXiU8TWa5M51KT1a/IAGaqdW1cLjcq7Xs6HE2jPLJbH9CceOD5fkJvmhX8jyKHnb4DuyPagrv3BuPHVXUWtuep36kQRsCRwBZRUgPp0U4HQ7dyoiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mpGdzk3mqoIKBR888KeSWchB+9HYWMUSHMcnC1ZIBV0=;
 b=EltbW2/AQfC9/oo72AIU7TNb5KS2a705WMez8x0AtnkFkgJE68Zg7IPdVjS2ADDi3N2pyYZR4t281qLomB5bOA8FhWqdJBV3EuUsA9CQZ0eWLHmrXUpWt0myZ6BgOaSNQfiLF6AjVwW8m+0ioevAHhQdrHJWUtufJLvlzqCgRFN73KswDeaV+HKpJEWxd6Q0tl3sR6HUFNgdeHi/KaGgzXQ6JTmdvwBDAxvJXUhoFtPJ5G9o5BsHk7oCjEo1lkC8lDNCEepoueuVCWqcxptgG7njcjwrQ5EX+9R95u/flGL3GIeJZYk/4RDAgQIyM1PHJGrrX87Y3SrQ95pS+9VgjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CH3PR12MB9315.namprd12.prod.outlook.com (2603:10b6:610:1cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 17:06:57 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::74b2:8571:4594:c34a]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::74b2:8571:4594:c34a%5]) with mapi id 15.20.7386.025; Wed, 20 Mar 2024
 17:06:54 +0000
Message-ID: <a16b2bcd-4ba2-49e9-8fe1-48d8fba07c56@nvidia.com>
Date: Wed, 20 Mar 2024 22:36:44 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: migration: Skip config space check for
 vendor specific capability during restore/load
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, marcel.apfelbaum@gmail.com,
 avihaih@nvidia.com, acurrid@nvidia.com, cjia@nvidia.com, zhiw@nvidia.com,
 targupta@nvidia.com, kvm@vger.kernel.org
References: <20240311121519.1481732-1-vkale@nvidia.com>
 <20240311090242.229b80ec.alex.williamson@redhat.com>
 <7cab7d27-0ad2-4cb5-9757-a837a6fd13a9@nvidia.com>
 <20240318085848.32b34594.alex.williamson@redhat.com>
X-Nvconfidentiality: public
From: Vinayak Kale <vkale@nvidia.com>
In-Reply-To: <20240318085848.32b34594.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0002.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:95::22) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CH3PR12MB9315:EE_
X-MS-Office365-Filtering-Correlation-Id: 2befe2b1-41aa-489f-fffe-08dc49002484
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nDoZUTVTthtVcb4Ia2vkstQ46E3ObMhbNnufs/vRYVEeQ7fokCQA8P7hjbsj7b5OQq/nSkfhv+N1nCPKy2+A954KB1J7TXTGJWFqSxthlWBpL0rk/9iO9cg6R3mda3aVqfep2W1xTotLoWBy6TvQbkemTI7WnOoZAxUgXiVJCCP9lGv+isjaLcAy9CrEk8Slh7UJQc1KNa7uYP0jzMwcTxQH+r4zY2RFL6etw27pZp/Vij6cGVLUv/8+iHIBgwgph1Vbse1TvaWihrSlIk/kRrlhl40sAfR45g53afF1bC0Zp+xTb4fahgGqZvuUCjbUCmRMFsRJrbRTI+0Az3fGrqeZJiXZGlaom64PlKxYhhwdvmdD6L2mCHLlzV/WEKEoa2vuf6VYCDlk7SZ4zH6ukdqWRXLj4aKNT3nZWDcZ7/vkdjQ8vVflRiHlCcPBG9pxqVpHFkF3BeyEJ2q6e53toDoGpp6eSrIybWwCLOOHJ+i+b7HMBt4tvYZbEu3aIPJguJ1dunJSBmwFpIQ2Ed6aAb5DzegCwPUpWfF4At0zgI+sB4yB9aKx7o6kcAkj5tvZh1Z4QJHQeMcd14Iq9UJsIVQDkhrx6oDIIy1+NK5T6vNtnLiCe/bE7K4uJBFMX10N8s+B7vVofwkhDEDN5cHRYYnaGZmGCenpMRm9/3vw0CA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?KzlNcXFsYnMyUm1xc25ZdTdlOEJXM2Z6Ti9tREZpR3ZvUjJTRUNjSGdJMVZh?=
 =?utf-8?B?QWJtRXRIWkI4NG40UXJWaEhLMWFPbXg4ZlBjN3hoREJsaHJkRmdIQmt2b1lv?=
 =?utf-8?B?Mnl4Yk5wYlhIRGM4RW8wOGx3eXJNSFQ2K05nRXJ3NEYwSmdtOExYSkpaWE83?=
 =?utf-8?B?NEJ4SFFxRW05OTVUdkFxaGhlRjdNNm1hbzdUdTBjZnlLY3RQOHdXVDlXc0JN?=
 =?utf-8?B?M3pOeENOVGZxVUVVQ1B0c1hONUI1bjNHcldzalMwcTVkUWxxUEpjU05RZlZt?=
 =?utf-8?B?elkrY0M5OGxaNktiY0FKMm53RWVWTGVNQW00LzdYLzVVQmpwN1ByUnJNbitJ?=
 =?utf-8?B?SStCYUt2Zklpb0FjN2hKTVlGQ21lWHphUHlVYWtUM0VVZUh1dGcyTGVxWG9O?=
 =?utf-8?B?Y3dTNFh2VXI2Z0w4UjZyNEdhZ0wzcENJb0pRaGMzT1dhSjZsUVhxZzdWejN4?=
 =?utf-8?B?bUFFOE1OV3BOcTFWTkU3L0pnY2V4WGdOZkZiZWZOVnFLME51NVB4NURzV1JV?=
 =?utf-8?B?eTh0WnJjeGtTdlZ6cUJyQUg1am5oK0hYV0NSS0FIbVBOMHM5akoyUnhtZGo0?=
 =?utf-8?B?S3lUeW5DdWdyWmY5UWIwWS9KT2xIT0g2ZHNTQ1JNZjZtQmM1R3FQendsQ0ly?=
 =?utf-8?B?VHB5RkJBZXd2c0JEbksrV0dPOTQyVUxzQlFYeDZMaVYraVRVOS8yUWNyR3E3?=
 =?utf-8?B?WUM5bFZHZUVFdEVjVXZmbVlNaVRoQWUyTXdOT1p2NE5maXhhLzh0aTZ0bmlo?=
 =?utf-8?B?RjFTS3RrNW1VN2NGclIrRlR4V1ZibC9sZ2JLOGlNQ0YrV1MyNzY4cUVlZU9o?=
 =?utf-8?B?TlYvMno0S0I2ZEdxSWNwQ0RSbmluSVg0TTRZVzNmdTdGUmtKdE9jcWV2MGpR?=
 =?utf-8?B?aU83clZiOHh6dHZaYS9OVTVTMFBzOE92YVZqUk1sdlFONVJQWjc3b1JJbXJp?=
 =?utf-8?B?VUJwR1JLUGdWTktsRUo3MXdBejE4QW1qVktpaURCUUR2dHo1R2pYWFhvRnpU?=
 =?utf-8?B?Rm5XTTBHU09adkxhWFVtZGhBOS9tdlF0STF3RjNjSTc1SGpQUmZjeEdkUXMx?=
 =?utf-8?B?dXlKZ1h3NFBqRkhWTjgzeFNCNFRqUnpEUVhVd3Exckl1bDdxM0JvMUkwbDZz?=
 =?utf-8?B?VFcyRUZIenFkYVZTRDFWM09NcVFuUEh3NnFoUDI3ZyttemQ1OWhKVTUwbVFF?=
 =?utf-8?B?eDNyVkx2b0NhVExVYUlzWldDS2phTXlYUktqOUV1NVZXR1hLUjNHUklNcTdx?=
 =?utf-8?B?TW1JdG5RQ0tDQlRhZDBOYmloWlpGL0g2Nnl2ZndmMEgxYTlhdjhpeVZPZzlG?=
 =?utf-8?B?KzQzdi9JNm9mZkVCeGJueS9GWVk3dWhuR1NtYUJxQ2FXK2taK3RyTTlRL2xC?=
 =?utf-8?B?VVlhS25odWVTU2Zsc0YreUlQNmNxdnN6cm00STZ6NTkzOEN6L1hmWXdscTNU?=
 =?utf-8?B?N2tEeG9IaUxZQXFVcTMvRUllSWw1UE9wNGVTaVRweFp0alFPditBc3pCZE5R?=
 =?utf-8?B?ZHh5ZDNiM3Z0ZE9DOTgweFh2VXlhZmdSZ0xEc2w3M0plQjJMQW51aUtjQ29q?=
 =?utf-8?B?Q3Jaa1N0SFJwNEV5elRLL3dGc1pDTUZ6RUZtUTc0QnpZVjArVWhzbHkxNGVQ?=
 =?utf-8?B?bTlzV0xKeHpmVS9mYjRYT0h3SFlxa3hzbG0wbkZRQ2N1UUJLSTFHSE14Zm5I?=
 =?utf-8?B?Y2JNVGxpdDRBMDEzMFFFTm5ab2ozb0dyMUhzalNsQjZJSEZQenhpNHdQcnVi?=
 =?utf-8?B?bmpBYXF5TXlxYnFHOEQzd3dwR0V2d0VRdW9xTkcxeUVEcUpFdStEMHo2ZzI0?=
 =?utf-8?B?eHRJMlA5YXZqR2poTXZNZkhiR2ZIZS9sRmlLNERETmI0RG5TZzRYUkxWN01Z?=
 =?utf-8?B?T1hzeUtRSFhidzBvNElWc2gvVjc2UFFJTUdreVg1MkFsU01WakV1cE9lUi9o?=
 =?utf-8?B?NW1VUVU5QVFtZlF5Q1IyTm8zSk1SU1dteUIvWDhYdzB1OWtaQVZ2RzZ0N2R1?=
 =?utf-8?B?cVZlcGlZYVEzd1BPTUt6VFQ3S3diVFBIVFZnZmdUeEQ0OHE1NFZ5cHV3cVM1?=
 =?utf-8?B?a3o4Sy84aktvU2dpUWlZNGNhSWcxNjV3dzU4VWNrRWZIcDEvR0NHUERBREpJ?=
 =?utf-8?B?cEZGNC9pRGZqZXkvTklQWmJGemdCOExmSGpJOGN6N1ZkLzAwb05SdS9WUmVE?=
 =?utf-8?Q?Vk/SqL+ltPn5UoJeNMQIkChl5BSYIDGzltuUl7+A3Rge?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2befe2b1-41aa-489f-fffe-08dc49002484
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 17:06:54.5510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wrQZu1VzgSr/ErCDthULV0I0/GIN2Q076QMxEVcNL/nZ4Xo9dYbL77dmCrliCMJgR6bc/b8oEGuaKHEWL9EezQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9315



On 18/03/24 8:28 pm, Alex Williamson wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Fri, 15 Mar 2024 23:22:22 +0530
> Vinayak Kale <vkale@nvidia.com> wrote:
> 
>> On 11/03/24 8:32 pm, Alex Williamson wrote:
>>> External email: Use caution opening links or attachments
>>>
>>>
>>> On Mon, 11 Mar 2024 17:45:19 +0530
>>> Vinayak Kale <vkale@nvidia.com> wrote:
>>>
>>>> In case of migration, during restore operation, qemu checks config space of the
>>>> pci device with the config space in the migration stream captured during save
>>>> operation. In case of config space data mismatch, restore operation is failed.
>>>>
>>>> config space check is done in function get_pci_config_device(). By default VSC
>>>> (vendor-specific-capability) in config space is checked.
>>>>
>>>> Ideally qemu should not check VSC for VFIO-PCI device during restore/load as
>>>> qemu is not aware of VSC ABI.
>>>
>>> It's disappointing that we can't seem to have a discussion about why
>>> it's not the responsibility of the underlying migration support in the
>>> vfio-pci variant driver to make the vendor specific capability
>>> consistent across migration.
>>
>> I think it is device vendor driver's responsibility to ensure that VSC
>> is consistent across migration. Here consistency could mean that VSC
>> format should be same on source and destination, however actual VSC
>> contents may not be byte-to-byte identical.
>>
>> If a vfio-pci device is migration capable and if vfio-pci vendor driver
>> is OK with volatile VSC contents as long as consistency is maintained
>> for VSC format then QEMU should exempt config space check for VSC contents.
> 
> I tend to agree that ultimately the variant driver is responsible for
> making the device consistent during migration and QEMU's policy that
> even vendor defined ABI needs to be byte for byte identical is somewhat
> arbitrary.
> 
>>> Also, for future maintenance, specifically what device is currently
>>> broken by this and under what conditions?
>>
>> Under certain conditions VSC contents vary for NVIDIA vGPU devices in
>> case of live migration. Due to QEMU's current config space check for
>> VSC, live migration is broken across NVIDIA vGPU devices.
> 
> This is incredibly vague.  We've been testing NVIDIA vGPU migration and
> have not experienced a migration failure due to VSC mismatch.  Does this
> require a specific device?  A specific workload?  What specific
> conditions trigger this problem?

In case of live migration, in a situation where source and destination 
host driver is different, Vendor Specific Information in VSC varies on 
the destination to ensure vGPU feature capabilities exposed to guest 
driver are compatible with destination host. This is applicable to all 
NVIDIA vGPU devices.

> 
> While as above, I agree in theory that the responsibility lies on the
> migration support in the variant driver, there are risks involved,
> particularly if new dependencies on the VSC contents are developed in
> the guest.  For future maintenance and development in this space, the
> commit log should describe exactly the scenario that requires this
> policy change.  Thanks,

I'll add aforementioned scenario (situation when live migration is 
broken for NVIDIA vGPU devices) in the commit description. Thanks.

> 
> Alex
> 
>>>> This patch skips the check for VFIO-PCI device by clearing pdev->cmask[] for VSC
>>>> offsets. If cmask[] is not set for an offset, then qemu skips config space check
>>>> for that offset.
>>>>
>>>> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
>>>> ---
>>>> Version History
>>>> v1->v2:
>>>>       - Limited scope of change to vfio-pci devices instead of all pci devices.
>>>>
>>>>    hw/vfio/pci.c | 19 +++++++++++++++++++
>>>>    1 file changed, 19 insertions(+)
>>>>
>>>> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
>>>> index d7fe06715c..9edaff4b37 100644
>>>> --- a/hw/vfio/pci.c
>>>> +++ b/hw/vfio/pci.c
>>>> @@ -2132,6 +2132,22 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
>>>>        }
>>>>    }
>>>>
>>>> +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
>>>> +                                        uint8_t size, Error **errp)
>>>> +{
>>>> +    PCIDevice *pdev = &vdev->pdev;
>>>> +
>>>> +    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
>>>> +    if (pos < 0) {
>>>> +        return pos;
>>>> +    }
>>>> +
>>>> +    /* Exempt config space check for VSC during restore/load  */
>>>> +    memset(pdev->cmask + pos, 0, size);
>>>
>>> This excludes the entire capability from comparison, including the
>>> capability ID, next pointer, and capability length.  Even if the
>>> contents of the capability are considered volatile vendor information,
>>> the header is spec defined ABI which must be consistent.  Thanks,
>>
>> This makes sense, I'll address this in V3. Thanks.
>>
>>>
>>> Alex
>>>
>>>> +
>>>> +    return pos;
>>>> +}
>>>> +
>>>>    static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>>>>    {
>>>>        PCIDevice *pdev = &vdev->pdev;
>>>> @@ -2199,6 +2215,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>>>>            vfio_check_af_flr(vdev, pos);
>>>>            ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>>>>            break;
>>>> +    case PCI_CAP_ID_VNDR:
>>>> +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
>>>> +        break;
>>>>        default:
>>>>            ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>>>>            break;
>>>
>>
> 

