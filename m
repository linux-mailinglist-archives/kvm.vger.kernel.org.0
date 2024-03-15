Return-Path: <kvm+bounces-11928-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28B3087D319
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 18:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 960441F21886
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 17:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71A104CB4E;
	Fri, 15 Mar 2024 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T0F6oLh6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D92226AF2
	for <kvm@vger.kernel.org>; Fri, 15 Mar 2024 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710525163; cv=fail; b=ew54a5iAwNJ0NdBoIm4mjffuEGfqHearNYxldQVNs+fBlCuNXA0MGTSeMOmvpf7MQknQLWzwFUxk3Y79MCX+d5sVNcbD0TGJXbo8qGt3aldVXZc8XKbloCvYHsNJhqPsivOyLtWq7OWJ12eGYMLHe5VWDV7CxB3FC/AdVK330FA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710525163; c=relaxed/simple;
	bh=ZR6wQDvaLX9CO0CRHZau3D2A4oPyTpFwg31Xuq6A0XY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jyiytf7PInYmhox807crnpuF0JvFGLy+rsMcFUH0A07+Qez9/YAOkf7utZI4HziknZR9YPl7ZEEHAGkosjL+w32JrW9tKE0fO9r8AEWjnPlm0YssfdLYsiVd9TFbm32wimrclPO7X5r1pOXmBwgq9odVQ8EHyaPXRQ3f8Sx9skg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T0F6oLh6; arc=fail smtp.client-ip=40.107.236.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ3RgGfHFJX6Hw13jVbrR79gbN9tCUvLYDJFYBXUrCpdZftCunqzpw8bk1yZOcszfXrhe/sq+Mqg6KrMBoc94xealSxgZaMNvuvyZFyi1BSX1anPLjpMRx2pbDthiOXZq1dLuaR7L3XAGyawA7PrJW3cj50XbTr24EWCHPZu824kPn/dAC0Led4ov5oVPbnvZmIa/3FqRyfLt5dCSR2n0Wg232sLK+655UX/HtYX2vnlN2QtXKQiUMm06N7qdmR+1TummWMnpPgOcRSd/iSpORkmd8Cyz6aGG1MbwAEbxq75N+B2w7ObzeJ2+X49Ul0sICLpwhGxIPpwk+kEH6z9HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaZ67a015jUkn8J/3WKaRuvSaecRY0Sf77BP5enCL+o=;
 b=EQxXUjOUe2RMLottsHdV69swlS6ul4oZf8ApxsNGaY6N5qYsECjAO1xUXclxc/zNgQgxruDzQjZdf0Jj9fHfReauCgF1t+npiAlbHgJFZ53WVdF4vht69jh8fcKeeQEwV+e/L1BJIGWh1qrRFOyNFM7/yftnidrH1zAvcHA5hheKU3k+RfI63Odx4+VGKPVB2DLzwTjIvHVwgpHLyhk4eK8E0mHPxXAElE3H9lKffxGSEmFow7ajNXWIJza3vN6sEQQ4IgfEIctV0JxIfLnOj8VgCSgpkX63EVR9mIA+Oo43c/5HDRC/V1v9yT1JzrGlLEr6PsBV+vzj7Knvy0C6RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaZ67a015jUkn8J/3WKaRuvSaecRY0Sf77BP5enCL+o=;
 b=T0F6oLh6Sai8h6VOB/4eNtwPwbW3MYsU3HP0iN4QpSzAJCssrcL3h39/TVdsQ9OqYa8GfsF1/g0IsNGn+N9EJZfdPzx3D5eiVUQrlKZuYAhRcI70OnwGlmkVNqxM8zmki+jxPG6XctV0WokgGJxJtIrRZctlYPTmOtvuwGB8MSrsXxh90fMTnK/2WVbTQIfZqzhDJV61YsQ5wJZyLAornaTKYQJ253hJCrcJFJFbvxKQBomKmh3t0/LBYSb6VcxX8F9qChOljjr0mBvpCQ7eE0gniHEF/2G9myWkgRISMaCKFUKawZ0/PU60iof/OvRURepHN9OmIWVZ0k0Kik0UpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SA3PR12MB8810.namprd12.prod.outlook.com (2603:10b6:806:31f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.21; Fri, 15 Mar
 2024 17:52:36 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::74b2:8571:4594:c34a]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::74b2:8571:4594:c34a%5]) with mapi id 15.20.7386.021; Fri, 15 Mar 2024
 17:52:35 +0000
Message-ID: <7cab7d27-0ad2-4cb5-9757-a837a6fd13a9@nvidia.com>
Date: Fri, 15 Mar 2024 23:22:22 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/pci: migration: Skip config space check for
 vendor specific capability during restore/load
To: Alex Williamson <alex.williamson@redhat.com>
Cc: qemu-devel@nongnu.org, mst@redhat.com, marcel.apfelbaum@gmail.com,
 avihaih@nvidia.com, acurrid@nvidia.com, cjia@nvidia.com, zhiw@nvidia.com,
 targupta@nvidia.com, kvm@vger.kernel.org
References: <20240311121519.1481732-1-vkale@nvidia.com>
 <20240311090242.229b80ec.alex.williamson@redhat.com>
Content-Language: en-US
X-Nvconfidentiality: public
From: Vinayak Kale <vkale@nvidia.com>
In-Reply-To: <20240311090242.229b80ec.alex.williamson@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BMXP287CA0017.INDP287.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SA3PR12MB8810:EE_
X-MS-Office365-Filtering-Correlation-Id: 23216dc1-26f3-4c9a-d230-08dc4518b244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cXWdzwl52hXee4twQaRhDLDeYT68ALt692q6Lb+ID2gWZ+n8bt4lChtAPAOXZ41dYQ8Tv2FPgciFUq9EveZW+Hhbkvtw8m33YaTqqNJQ790DYj0FdTwoj4nDh6uG8OgCI0yF4cXgG96r9ZLLB8OT3Tv46/JGc09x7MaI5Wde/aBWjlscV3IqJgcvklSSMw0VDKELn7h3a6PZINWL2uQ16xUSe6wHU/aU28a1Qj58t3pZ0fOb7vV5LEl3KgIy/TC3/5FSR6sCVwSTF5AkvahF//LO4kU5/AvfV5oEl5u6Il42waqp6UI3NjZjvbwB7rqrajof608sUc7rJ8UtnjGWyTIzShp0VSgLC5ZsREiqRAcsZs/6e2t2vNS2/tFhV6LmiPoSSirFaVBw1oU1bCIBHNiW2CB8qOdacJeqBkhXdw2rx0T0ULxK2twXH5g+WtEn47WwN+Cy62gFhXjon0w5IIbaIRaKBavNwckCmQwiuPUbj7e9zZS6P/4rg03rf7JbMEaNHpJpDtO2ixS5bR5CRB5URNFFi8S+YB/7pEeLNjV3VZzgcVbEQu3UbFYEohBzDr4j2ntamFBO/44NMepd+YmiIVxkHjZ+a5m9HT2TMTIWeph4l3YCPEnhmkPqLJL6XwK/UuRDCnaqwy3bmqMlcZa3lKqtyxNIHj4gwkWAfI8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUNnckJVKzFReHNZMk9Wa0F1aGN5bWFhOGFwYVhtZUttMXUzT00veWlLUkw5?=
 =?utf-8?B?T1F1dmNvTmJrejJpWGRlTFV0cXdRRXI1UTZzR0Z4NzFZMWl6ZmVVOXJENXhB?=
 =?utf-8?B?MU5pNDFnSHZpMDdUb29lcnQzbFBIV3pFQlU0M0dtUldBK0E3MDlDNCtmMGYz?=
 =?utf-8?B?bU1rUDRROW80cWZsV3BTbGhSb3RTcUpxT2lyT2FSaEJaNlUvL3didjNscXhS?=
 =?utf-8?B?THJsamRSOEpXMXVSM0JSUjFhSEZYNTRYYVhNeUdUdEFoLzFFVW00Vm1LQ2kv?=
 =?utf-8?B?KzRTbDJ5SHlBVDdSaDJRYllDa2RtQStWOHZDYmVRWnhiWjBqTVNoank3bUNM?=
 =?utf-8?B?M0lZY2J5b3FYSFFpWW1KWkpWV0pwdDRGcGRBZVRVZVpQQTZhL2ViK1RXb0cx?=
 =?utf-8?B?NGNVT1dPbkM2K3hXVTZDOXU1endHaFFxam94VFdiSjVscHAvcjdZbGpQZkF4?=
 =?utf-8?B?WVVXb2hVWWZuR1d1RldVZm91UjkyK2FDQThQRk9VZDhlYURFYmdzZGJNdm5h?=
 =?utf-8?B?aFpFZmp6S1BkZU53ZEhpVnorb292T0hxazlPcUI0TWk5UkczSHFvZXpqbFIz?=
 =?utf-8?B?RjdtSkIyWFJoanIySmJsYXNSSno0M2VFZjJWS2tMcW9VSmoxRm9BTXI1TGpz?=
 =?utf-8?B?UzkzWmw3VlE0Yjd4eVdXeklJTHpGcjNuYWU1eVJ0NUN4K2xibnpZT2FaVmlG?=
 =?utf-8?B?b3NLTU1vRTluVGwzOVpwR3FQTHpaNCs3Y0U1R2xXY2UzdmJnSDR2dVZpdzNs?=
 =?utf-8?B?KzRtMkhFUmxQTVVnTC96N043SW1aR2xURDE4OFJNeGlCV2JWTjF1ZnBHS1dU?=
 =?utf-8?B?Q1lqWnFNa3pOQnN5clBKbXlSMzlsWGVDbDA5VFhXbVlYQ05zT3ozSTlCSzJE?=
 =?utf-8?B?cXJXVVhzZWRlajViaTlldWhyenJaYTlhWmd2SlpoL0tXVFoyYk5yU1RBVW90?=
 =?utf-8?B?WkJoVXZzZFd3OU5XNjVxUVhRMC9EMnJ1L1ZjVi9Od21mdVVyS1NNU1orcXov?=
 =?utf-8?B?eWlienpwNTVOdFF5b2JzcHBvL2t4UEtLeTE1OWNQTmdtTUhrVENaZDJONG5F?=
 =?utf-8?B?Um9aM2ovVHNHU0VGMWx3NEJFT0V1TExlMzd5R3lEMXFFZG9pZnRDNGtuRUVp?=
 =?utf-8?B?dUhvc3Y2c1daZkw1Tmdxb0Viemx4WW4vMXd4NS9mNmZ4aGpvWmxoOHdIaG5r?=
 =?utf-8?B?SGRjVWFFSDl2WjdRSFdSYS9GN1dZbFhqWURFRnhqRld1eTRESVFpU1lBZ2dF?=
 =?utf-8?B?ZlNiNExFd1JoYmJjZ3BrNE9KS2IwOHVVZjJ4QW9HUFYyQTBKV3BGSGI3aS9I?=
 =?utf-8?B?Rnh3VWF2akpyZUp4L0VWUnl6WGswSnhoeEwzOWJtYXJzUmlHQXg5VTJBMk5i?=
 =?utf-8?B?OGlrS29yaXFvUWVmV0FyMGM5VkZvcHJXdkFUVHkyM3E3NGZGNFF3WUFaUVFy?=
 =?utf-8?B?UjNVbGtPVDhpVTNEUnZVT1g0YzBnbkc1UWQ5MDV6TFBUcWl1blUrRzNnVzBD?=
 =?utf-8?B?TFhJcnBkMXJrei83T20waDZYRUZ1RDBqdnk0VkRodTdsQVRkYW02NldGQ2Nx?=
 =?utf-8?B?eVU1TGpMcHh5ZXB4V2ZxcjBRMmlYdTVUYytDVS9nS3k0L2tJRW9lMUl2MmNR?=
 =?utf-8?B?dTJVQ2hBSjVKZVVJaW01WHRNcUU3enlWcXZNVUxNdFh3VE5jSE4xRFJwUXdY?=
 =?utf-8?B?L3VsckdPWFRUWHNjbU5jQ09jQVBlL1lITVBXRWpuaUJwSjliRlJJQmtDTXhW?=
 =?utf-8?B?QkFnQU42WTJ5amtPZnowVDRieGhjbXR3OHdxcTE5b29hODdyeXVKUnR6V2NN?=
 =?utf-8?B?YWMwWjAyQTJnV2UvYkpkTWhVRHZGTVBOTWNMZG8rdmtnaG55akpZUTZxcnJi?=
 =?utf-8?B?THoydjhhWW5vWVBYSlFvbHJ5NXlOa2E5QlZUbFNZUVlkSWJuREhBbUZNSUpw?=
 =?utf-8?B?M2M3YlM3OWNaenlFTWdXSGNTQ3VKbjlwQmMyUXkvMlF1R255Zk1NeEJFbVR6?=
 =?utf-8?B?T1Vib3dYdUJsNXZwTFV0czVtMFQwdVNiNnRVSGZSdUhkbFhGdXl3VjVleUkv?=
 =?utf-8?B?Yk9WSFJPRVR5ODZJbGRKTC9MVDV6WFQrWE9SOTFINDVlS3U0NVd3cUREUXFR?=
 =?utf-8?Q?180MkUuSfRUwiDI59XChQbYyM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23216dc1-26f3-4c9a-d230-08dc4518b244
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2024 17:52:35.5918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9dpNNakZvYiaDHPmHl0QEQ+umbtLsijNnRUnrvf6iZX0RUctEkOJ0n2UpXd0tZmWodQIVlPrhVZxk3p7FPHe5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8810



On 11/03/24 8:32 pm, Alex Williamson wrote:
> External email: Use caution opening links or attachments
> 
> 
> On Mon, 11 Mar 2024 17:45:19 +0530
> Vinayak Kale <vkale@nvidia.com> wrote:
> 
>> In case of migration, during restore operation, qemu checks config space of the
>> pci device with the config space in the migration stream captured during save
>> operation. In case of config space data mismatch, restore operation is failed.
>>
>> config space check is done in function get_pci_config_device(). By default VSC
>> (vendor-specific-capability) in config space is checked.
>>
>> Ideally qemu should not check VSC for VFIO-PCI device during restore/load as
>> qemu is not aware of VSC ABI.
> 
> It's disappointing that we can't seem to have a discussion about why
> it's not the responsibility of the underlying migration support in the
> vfio-pci variant driver to make the vendor specific capability
> consistent across migration.

I think it is device vendor driver's responsibility to ensure that VSC 
is consistent across migration. Here consistency could mean that VSC 
format should be same on source and destination, however actual VSC 
contents may not be byte-to-byte identical.

If a vfio-pci device is migration capable and if vfio-pci vendor driver 
is OK with volatile VSC contents as long as consistency is maintained 
for VSC format then QEMU should exempt config space check for VSC contents.

> 
> Also, for future maintenance, specifically what device is currently
> broken by this and under what conditions?

Under certain conditions VSC contents vary for NVIDIA vGPU devices in 
case of live migration. Due to QEMU's current config space check for 
VSC, live migration is broken across NVIDIA vGPU devices.

> 
>>
>> This patch skips the check for VFIO-PCI device by clearing pdev->cmask[] for VSC
>> offsets. If cmask[] is not set for an offset, then qemu skips config space check
>> for that offset.
>>
>> Signed-off-by: Vinayak Kale <vkale@nvidia.com>
>> ---
>> Version History
>> v1->v2:
>>      - Limited scope of change to vfio-pci devices instead of all pci devices.
>>
>>   hw/vfio/pci.c | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
>> index d7fe06715c..9edaff4b37 100644
>> --- a/hw/vfio/pci.c
>> +++ b/hw/vfio/pci.c
>> @@ -2132,6 +2132,22 @@ static void vfio_check_af_flr(VFIOPCIDevice *vdev, uint8_t pos)
>>       }
>>   }
>>
>> +static int vfio_add_vendor_specific_cap(VFIOPCIDevice *vdev, int pos,
>> +                                        uint8_t size, Error **errp)
>> +{
>> +    PCIDevice *pdev = &vdev->pdev;
>> +
>> +    pos = pci_add_capability(pdev, PCI_CAP_ID_VNDR, pos, size, errp);
>> +    if (pos < 0) {
>> +        return pos;
>> +    }
>> +
>> +    /* Exempt config space check for VSC during restore/load  */
>> +    memset(pdev->cmask + pos, 0, size);
> 
> This excludes the entire capability from comparison, including the
> capability ID, next pointer, and capability length.  Even if the
> contents of the capability are considered volatile vendor information,
> the header is spec defined ABI which must be consistent.  Thanks,

This makes sense, I'll address this in V3. Thanks.

> 
> Alex
> 
>> +
>> +    return pos;
>> +}
>> +
>>   static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>>   {
>>       PCIDevice *pdev = &vdev->pdev;
>> @@ -2199,6 +2215,9 @@ static int vfio_add_std_cap(VFIOPCIDevice *vdev, uint8_t pos, Error **errp)
>>           vfio_check_af_flr(vdev, pos);
>>           ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>>           break;
>> +    case PCI_CAP_ID_VNDR:
>> +        ret = vfio_add_vendor_specific_cap(vdev, pos, size, errp);
>> +        break;
>>       default:
>>           ret = pci_add_capability(pdev, cap_id, pos, size, errp);
>>           break;
> 

