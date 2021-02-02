Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334AE30CF1C
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 23:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhBBWfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 17:35:25 -0500
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:59297
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235296AbhBBWfG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 17:35:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jR9EsdbF5CHRVoAurA8NqOdGNZJRifElt9GtDe3kIxuZFi4CSnVa9lTUCtxCfIY7gUPn7ENh2sYaO4QkI8AKsmIi93x1ZNgGXB0MVraEbQ326dPQm3gDPIDF5QD9kxBfvlKCeCMYzWFIr54ELD6EgY2E0udUONlktBKcoKYcXs127/Uk+/g62hljDebSqZELMtlkP8iWCxLI5lzrzyZ2jiaM3ennmiImh/Th0Qyl+LeZi5UrvJnI0uI7dxXgG4mYuXVh+MUts5+vIKo8RJVLOxUDbyOtQm9c3b9AQtGag0lhCd7iDS68LgWA4ug0BfRay8+wgWOcOZy5maxVDM2AcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJbpCd7ikuwa7Ken4CiBTXl/Wt9bTmToSDb6XExlpCE=;
 b=n5ShS7+KL99ru031YqCbN2Gx3GSVx7oiPCHBYvtbzFdUXOENuv3tFWJIEI0yBCnnsCyjlkGoQcfQRfdzY4hvqlsqsaX5uEcsdMEPRzfRCrzOsio3bbxx/bqD1rQPnA2SJDRg2ZurPUsIfEapSnw08gzVhyQu85W2H+/2jClH5EJDu5go/JU1om7fFHR7knHJbg3vEj/oLHaLVSalVOnJMMLiAKzZ+8mRuPaWMV786SaFcsOnHto3ISvq3lpisSQl8StHP+ukWX30BrUxqnLc+YLsHw/KKTvUEh7ynycmZCN0OwKg3V0lxc0tZUVLzto9aqItkBxpq6C/EIxihc1ptg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QJbpCd7ikuwa7Ken4CiBTXl/Wt9bTmToSDb6XExlpCE=;
 b=zYBS1A7mYSRocMSx679vIlM/pDKrbde6/0LAe459s3ZO5utWSwW9cJ7ApRtSQOzF/St9sP3GCQuDEx3vpbxUNISfsJziZAvabpsPWI9MMULzlcSkKIDH79F4hWdv5zhTz3JdzLC+fQPCVV4wVKHsQrspc5gl/6L3MVQzXVk+3LQ=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR1201MB0021.namprd12.prod.outlook.com (2603:10b6:910:1a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Tue, 2 Feb
 2021 22:34:13 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::8e8:e699:d479:7e16]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::8e8:e699:d479:7e16%8]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 22:34:12 +0000
Subject: Re: [PATCH] swiotlb: Validate bounce size in the sync/unmap path
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Martin Radev <martin.b.radev@gmail.com>
Cc:     Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Christoph Hellwig <hch@lst.de>, file@sect.tu-berlin.de,
        robert.buhren@sect.tu-berlin.de, kvm@vger.kernel.org,
        mathias.morbitzer@aisec.fraunhofer.de,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        iommu@lists.linux-foundation.org, robin.murphy@arm.com,
        kirill.shutemov@linux.intel.com
References: <X/27MSbfDGCY9WZu@martin> <20210113113017.GA28106@lst.de>
 <YAV0uhfkimXn1izW@martin> <20210118151428.GA72213@fedora>
 <YA8O/2qBBzZo5hi7@martin> <YBl/4c9j+KCTA0iQ@Konrads-MacBook-Pro.local>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <62ac054d-f520-6b8e-2dcc-d1a81bbab4ec@amd.com>
Date:   Tue, 2 Feb 2021 16:34:09 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YBl/4c9j+KCTA0iQ@Konrads-MacBook-Pro.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0171.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::26) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA0PR11CA0171.namprd11.prod.outlook.com (2603:10b6:806:1bb::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.21 via Frontend Transport; Tue, 2 Feb 2021 22:34:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 66108189-beda-4da1-dcf8-08d8c7caa9d8
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0021:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0021A92266D8C916C7EA993EECB59@CY4PR1201MB0021.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBJVNwbgBuzCM8Sw9Sati/25x0Q5UDkQN3vgyzI5TdnaLWLdpXEKXbU08pH5OFflXYr9QzCgEeJvMz8rRt0Mc4L0S2xEhe7hOIyVDAtC17eAGM729ADYvBcfIdvYy5YSfDd02/dfjxFS4ueOyYndGd/R/mY44QXQqPJontDz2BGkAKSFEl+ADgsuL9nPWPjPHhP3yazhhUmPbguZBMFIq5fXJu662pu4TXhI0GUk+hVajMXO8HPxT6D1PJWKkDaulP06xGPNvyqis3IpSjZdX9tgj/uPhN3xo2QFOlR1ZNGS8Lt16QgNwjR6WHxrL1FTMBmUTLuW34jDcuHk1sM4VHQSFNU+iaXBy7IY/uLaezIA8i12FgKkjigBsR6bHOscygOZomZGwT1Vq3zx4BLsP/PYwDs+T/WWF+XfFpebpsluM9v4ksrYoZ2JLIUXsMTUCueKY60F9Jt82P3meESIIJt0XDbKnXlmlCryfn/5b2ER9JNtNV5ydNUUwLrETwpeb3JSeKVZlDO0ICXZ6neJnfTRLmnHVGXlbi3AwKaNuXw1DM2s8hvBPQHs9cgsfTmISOXmtxwjic9yKIicJChU0A4ESD4bXVGtCbNVaRowyIqOa5Mc24q8FNbMq38bKhc24iDkmfyFSxFVmepawJ9Iz+Eh7F5X73z1kMFkcCPWzVxt09KHeGhUWAEiOKz7LCS3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(7416002)(31686004)(45080400002)(4326008)(8676002)(2616005)(966005)(52116002)(478600001)(316002)(16576012)(36756003)(110136005)(6486002)(66476007)(956004)(186003)(66946007)(16526019)(53546011)(26005)(8936002)(54906003)(2906002)(5660300002)(66556008)(83380400001)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YUtVM3BxS3VkWXN5aDVMd1dGUTd4TWxaaFdVUTJOWlAyaFVaYkR4NEIvaUlI?=
 =?utf-8?B?VU5pMVRaNFo1QU9wSTB6bGxlclRiMnQ3czRPUnNHUHg3TUQ4a1YrbDl5N21w?=
 =?utf-8?B?NzBsUHVMSDh1Y2RJbTR3TXVIZGVPVUhHemd1b3FyQUphUWFQQjcxbmxsNlFB?=
 =?utf-8?B?dmw3QS9OUU5HZGR6UzVEeWVSeXJKTlpuMytUdnYzL0R1TmFEZ3I0b3V0cHZx?=
 =?utf-8?B?cC94TlF2KzZaRTdNVis0QzA5WkF1YTNtSDNzMCt1Z1VEWk1wT2xUNlJ2bVlr?=
 =?utf-8?B?NlhDVElMaEx2dmtPVWU0ZDllcEFsVzFCcmJXK242ak9QS2RjNzVLWFBFa1RZ?=
 =?utf-8?B?dFdPY1V6aFUzNmkrMkJ3QlU5NU5iNTUxQkppQytIL25yVFNIeDBqbG0xd1c5?=
 =?utf-8?B?N2JZajZ4cHA3dmZubnBCOWdHSDY5TVg5YWh1Sk9WdXBDSnVRMy9CcFBnM1Qw?=
 =?utf-8?B?RXpQblhXdzZVaTU5Sm5CRlN0VGdJbi9WS1V1RmZiZjJidkJvOFVYN0lYWFZ2?=
 =?utf-8?B?dFBFVWV0bFpraGNGSCtXVzJ6cmdvRlc5azVWVjBDcjJFZG82WnpnL3RadDlG?=
 =?utf-8?B?ekRISFExOC9OTzlwVlhSZk9JY3ZNeDUraFp1cEtiNXNJTmdRclM5RWdBNEVr?=
 =?utf-8?B?cjlEK1h5eldBeVQ5MnNqdUtqS2FNRUZTc28xTWNPS3JRUHJnMTQ0TGtPa0FR?=
 =?utf-8?B?aEVUTE40VXV3eXl5Sis3dVN6VWdvOWRSR20zTnRMRnIzU1RwVzBxR0U3Rys2?=
 =?utf-8?B?Vys3UTJ0Qlo1cTIzdXg5YVMzQUtHaVBFZmhFa2tnWjI2N2pDWk5hbzdEeFBx?=
 =?utf-8?B?K0p4VXJTWDZ6ZXJxcWV0Ni92c2tlNHdkQ3VPL1FZdkNaTklFUFRLcE12QS9P?=
 =?utf-8?B?YTNQYVVYYkVFR216dEQrbzRVTkVzaXFkSnR3TDdrUGd5OElneWQrMkNHdmsv?=
 =?utf-8?B?VFJoZnI4ZjAzQytUODNYaXNDRkJ5Smh5dHAvcC8wdUFndTdEUnNsclYxallN?=
 =?utf-8?B?VFBCeWoyZnE0QXNXbHJNcGtCUm9sYU4zL3BBRDhicHllRWQ2Mk8zT29EbjdE?=
 =?utf-8?B?QXlOWFkwalNiS3JPUk9xaTNjbGR1blQxK09CRXVJaTY1SHlRR29qV1dWZS9h?=
 =?utf-8?B?c3duVDdIeDNSeXhPcC93Uzl5NEd0aVFOLzNDemlnWWhrdWxMZE41NHhESlFC?=
 =?utf-8?B?UWQ4N0J5Q0UyQWdlcUhoMDFTOE93Wm4zOFA4WWZ0MFJoMTBGS1ZwOXdVdVZG?=
 =?utf-8?B?TUgwNWZITmUraWFaNXZsSndpOTJtZElOSGpOWVUyekpWV0M4bVpBWnRMakFS?=
 =?utf-8?B?Rm15K1RYdm5ZUG10eGJUbVJvL0tzeXcxbWpCLzgzN0sydGMvYnd0SVg1dm1B?=
 =?utf-8?B?VHhmVXZzNzcveXVYTWIzWlYvaHByQVFuRjFtbjdXRHM3czlwbXM4bkxIcjVY?=
 =?utf-8?B?TjZaU2R4aVRJWlI3eVRUdjlZRHcraHVzQXlQSzJhUzdtVWhyUkR2TFM4SkpI?=
 =?utf-8?B?Q285THc0NDg1bUkvNFZWM0F5dUFtYTdLVlFEZ3c2Qlh3Y0RIc0p0bk85OUVE?=
 =?utf-8?B?ZlloelZtQXUzQU1oM3NtOXhFbzRBOHExK01hK1crKzAyUDlHTHZRMmZhNit3?=
 =?utf-8?B?OUNITEJSQmNaS0R6d1ZuVEgrRFZCU1FlWjUzZE1iM092UXVUYzdSN0Zzdno1?=
 =?utf-8?B?MjJKSUFpN3N5Tjdna1o2bGlNTk1nMGc5cGxFU2UxQXcvWjZ4YXllOHdMcUtE?=
 =?utf-8?Q?P9uH5jYSGqk64xKFOPMlmWt6ALq3GZE2QfFxhFu?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66108189-beda-4da1-dcf8-08d8c7caa9d8
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 22:34:12.8593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTxIc5imfxCkSpzwW/PJoJYJio3IHsds1f2XHD2e/gAOTCdCDCryl26aYYHEpEkTSoJSUE9DdmpLsLMrW4HzLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0021
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/2/21 10:37 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Jan 25, 2021 at 07:33:35PM +0100, Martin Radev wrote:
>> On Mon, Jan 18, 2021 at 10:14:28AM -0500, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Jan 18, 2021 at 12:44:58PM +0100, Martin Radev wrote:
>>>> On Wed, Jan 13, 2021 at 12:30:17PM +0100, Christoph Hellwig wrote:
>>>>> On Tue, Jan 12, 2021 at 04:07:29PM +0100, Martin Radev wrote:
>>>>>> The size of the buffer being bounced is not checked if it happens
>>>>>> to be larger than the size of the mapped buffer. Because the size
>>>>>> can be controlled by a device, as it's the case with virtio devices,
>>>>>> this can lead to memory corruption.
>>>>>>
>>>>>
>>>>> I'm really worried about all these hodge podge hacks for not trusted
>>>>> hypervisors in the I/O stack.  Instead of trying to harden protocols
>>>>> that are fundamentally not designed for this, how about instead coming
>>>>> up with a new paravirtualized I/O interface that is specifically
>>>>> designed for use with an untrusted hypervisor from the start?
>>>>
>>>> Your comment makes sense but then that would require the cooperation
>>>> of these vendors and the cloud providers to agree on something meaningful.
>>>> I am also not sure whether the end result would be better than hardening
>>>> this interface to catch corruption. There is already some validation in
>>>> unmap path anyway.
>>>>
>>>> Another possibility is to move this hardening to the common virtio code,
>>>> but I think the code may become more complicated there since it would
>>>> require tracking both the dma_addr and length for each descriptor.
>>>
>>> Christoph,
>>>
>>> I've been wrestling with the same thing - this is specific to busted
>>> drivers. And in reality you could do the same thing with a hardware
>>> virtio device (see example in https://nam11.safelinks.protection.outlook.com/?url=http%3A%2F%2Fthunderclap.io%2F&amp;data=04%7C01%7Cthomas.lendacky%40amd.com%7Cfc27af49d9a943699f6c08d8c798eed4%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637478806973542212%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=aUVqobkOSDfDhCAEauABOUvCAaIcw%2FTh07YFxeBjBDU%3D&amp;reserved=0) - where the
>>> mitigation is 'enable the IOMMU to do its job.'.
>>>
>>> AMD SEV documents speak about utilizing IOMMU to do this (AMD SEV-SNP)..
>>> and while that is great in the future, SEV without IOMMU is now here.
>>>
>>> Doing a full circle here, this issue can be exploited with virtio
>>> but you could say do that with real hardware too if you hacked the
>>> firmware, so if you say used Intel SR-IOV NIC that was compromised
>>> on an AMD SEV machine, and plumbed in the guest - the IOMMU inside
>>> of the guest would be SWIOTLB code. Last line of defense against
>>> bad firmware to say.
>>>
>>> As such I am leaning towards taking this code, but I am worried
>>> about the performance hit .. but perhaps I shouldn't as if you
>>> are using SWIOTLB=force already you are kind of taking a
>>> performance hit?
>>>
>>
>> I have not measured the performance degradation. This will hit all AMD SEV,
>> Intel TDX, IBM Protected Virtualization VMs. I don't expect the hit to
>> be large since there are only few added operations per hundreads of copied
>> bytes. I could try to measure the performance hit by running some benchmark
>> with virtio-net/virtio-blk/virtio-rng.
>>
>> Earlier I said:
>>>> Another possibility is to move this hardening to the common virtio code,
>>>> but I think the code may become more complicated there since it would
>>>> require tracking both the dma_addr and length for each descriptor.
>>
>> Unfortunately, this doesn't make sense. Even if there's validation for
>> the size in the common virtio layer, there will be some other device
>> which controls a dma_addr and length passed to dma_unmap* in the
>> corresponding driver. The device can target a specific dma-mapped private
>> buffer by changing the dma_addr and set a good length to overwrite buffers
>> following it.
>>
>> So, instead of doing the check in every driver and hitting a performance
>> cost even when swiotlb is not used, it's probably better to fix it in
>> swiotlb.
>>
>> @Tom Lendacky, do you think that it makes sense to harden swiotlb or
>> some other approach may be better for the SEV features?
> 
> I am not Tom, but this change seems the right way forward regardless if
> is TDX, AMD SEV, or any other architecture that encrypt memory and use
> SWIOTLB.

Sorry, I missed the @Tom before. I'm with Konrad and believe it makes
sense to add these checks.

I'm not sure if there would be a better approach for all confidential
computing technologies. SWIOTLB works nicely, but is limited because of
the 32-bit compatible memory location. Being able to have buffers above
the 32-bit limit would alleviate that, but that is support that would have
to be developed.

Thanks,
Tom

> 
> Let me queue it up in development branch and do some regression testing.
>>
