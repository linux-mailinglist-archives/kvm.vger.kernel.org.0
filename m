Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252432B6A6A
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 17:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbgKQQhY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 11:37:24 -0500
Received: from mail-bn8nam11on2058.outbound.protection.outlook.com ([40.107.236.58]:7168
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbgKQQhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 11:37:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocPmGTIiWOWwoIcaS2TfPux8p36xFA3KZCReeBwm/8mu4/Xz7b8Vk8WmzRFd0JRvGtRL2cFL4ri0I2CEmR5HArTcGlW3xDN59YHwWZB1OfZ29BLeVlVgJUrWVVXgQ1T/tHctzv5GfaPotWzbII8IEmUzmTO3XlHdgHCYuALnfQKuv7FFtvbFa1ODIBtlXtqQABwKdFvwR5XITRr9SoChAgQagi3hs15aAbJ4BIloP7yX9P5tDSmcIzBAqH3semaMcKBCv79gJaXW1JzwjyV0+kmjqoEXRJA3cKhZO0ntbopvOqqc5m5cNqrEn6joik5NT4vUck7G4Ru4uErAILJXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRbSEwsQZIPK90Y7fFfJcwXCS4V1pXJCA3XcVKP1isY=;
 b=I0etXUS4TxVN7aMIz8fHQdQme90/1Yz1gS1t3PIlZb5AkFiK22DpnHUpvck0SEieHPVr0EwYfwS4hEfBknf+tk78KGCxHTYblK46zzrZHMUEx8M8JsJ3/ch50/UoiBhTakwvF3fJFiTkdo4s62XBKZwrX0ryiPfvRYWF5tMJn8gFuTTg/izX5dy4NUP2THVs8t/0c0Ho5mHDCH3SfTCpATBv1Rn9fL/SpyH6Hxyqq2oxkoswmskAA5ICbC/FNg/ireyH25P/y/TmEuxXcJdMzQm5UQnhFUWNe7LneUpPnsmy8Rx+HVa3Z57nY4vPfLiAvi7w9agfQR4r7eoQDErEgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRbSEwsQZIPK90Y7fFfJcwXCS4V1pXJCA3XcVKP1isY=;
 b=tjaxkrpNSZBh+CSW9S9VGNcaOI7YsC78SMeuHmWX6+0Zbl4fqfyV8MujpcoetiXD7R6jOHl+BWu+G/pZC5gUw0GAzyZVtJtkrjyWPwHJY+LdxRF6ZgUHpGUyf4No+rr/zA2oIkk/jZf0K//m8vBUU+lLhooJHnt/U3jnOP4AdC0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4484.namprd12.prod.outlook.com (2603:10b6:5:28f::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.28; Tue, 17 Nov 2020 16:37:20 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 16:37:20 +0000
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Peter Xu <peterx@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
 <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
 <20201117085443.2c183078@w520.home>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b6bd90c5-69e0-4e73-4f1a-8bc000aab941@amd.com>
Date:   Tue, 17 Nov 2020 10:37:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201117085443.2c183078@w520.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0013.namprd05.prod.outlook.com
 (2603:10b6:803:40::26) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0501CA0013.namprd05.prod.outlook.com (2603:10b6:803:40::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 16:37:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f17b2853-b393-4ad3-0bd8-08d88b170d65
X-MS-TrafficTypeDiagnostic: DM6PR12MB4484:
X-Microsoft-Antispam-PRVS: <DM6PR12MB4484CBE62B9011C8730A2BF3ECE20@DM6PR12MB4484.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cdCGDJOFB/O6nvnhqZ1fHU4Jb3BTh7jijTx5n2Hud9PDBcTDFaje06jLrqwOw7vmXYDNOVipj6TGyHwF3ngjHZu3zgnzY+TsNH3iKSwaqSIdUcqs5SmO/AVdGLBpTTA36VVokomsRa2fMnhVo5yfFvDGrJbg2inSCm9l9gNqwkeQyWw11Oz/T7ndWu8DpBMlUM4o7TxlHJFQTMzVrtVatYfL0Uz4LmPynlDSgWr4u88/fBllakwClDVandfb1ALfHydySAxIvILkJ7HdUBPseFogNIU2LukpTgm8tVcD5sz/H7+tSG1qY+JLwF2yXBDVgGRWLX3I8TzHH6OjLMJKpLkkt91DYgdhj4ssCFoWm15XRN6kleE5np/LtyW9RiSr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(376002)(39860400002)(136003)(83380400001)(6916009)(36756003)(52116002)(54906003)(2616005)(316002)(16576012)(53546011)(6486002)(31686004)(5660300002)(31696002)(66946007)(186003)(16526019)(8936002)(478600001)(66556008)(86362001)(8676002)(2906002)(4326008)(956004)(26005)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HNCBofeniNu03y/6Rtt6nA/aB7jJ8cofqLINBBlzpFSrSf7tjpEyBnZkf8hYB94IIQdHjuWAKAtYjQJoEt7xI9LA2M5gcZg3BYxBL5Wz//50vmnB8xziJBJU0lqQK7EwmK9u/sWj72008/MILV8Bgn7oyM/kH2EQ7hMuZmx1ElE6eRAja26x7k7XmazgVyazs291tO046inw0VbINOdz1+8ObFF5GpPfnA19MkUxu2pMNomQ1s0iMESDSnOyvRkk/4kbcXvTyoxz+HqPDC+lO4u8ExEB4Vk622e929mWdqbfyHd+mYUIIY12cjKoCmfbtDdhezEwCncwGBzDB7Szc6E00UPbffZ9IEhMabWsTxMTd2aLSPvp3tueUaHudDUf3PWbtIEZ9qvr1enXRqxzYxUnuLIL/6jPFiRXP+ktWy1GUW8Qys8KX4AIG3e93Sx6ciHnu5X6cApHz8ABiVm48M9FAO6TmOY3BiTUywuM3YqlgED6bUCxSDgi2I2M5+TxrFdSfxHPm3LX1q97LEsHI/EfhnNwbG5vRCScG83/mcUmJgoibdypbgDW1iRq6OJs3YND27SFKPiBBAKI9PMU30EXCaWjQpPIztREkV8CE9CrKgTuBZyWNENV9trIodsZyd9XhlTdMaLHrcEFeLOnXA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f17b2853-b393-4ad3-0bd8-08d88b170d65
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 16:37:20.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V3w502OpURusDDxFt8p/ZWzZFBa8NVm9OCajUYeS4TlHrLJuQE9v2StJt5ruYNoF/NAeXpHkfzzFYS4GGKtPFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4484
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/17/20 9:54 AM, Alex Williamson wrote:
> On Tue, 17 Nov 2020 09:33:17 -0600
> Tom Lendacky <thomas.lendacky@amd.com> wrote:
> 
>> On 11/16/20 5:20 PM, Jason Gunthorpe wrote:
>>> On Mon, Nov 16, 2020 at 03:43:53PM -0600, Tom Lendacky wrote:  
>>>> On 11/16/20 9:53 AM, Jason Gunthorpe wrote:  
>>>>> On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:  
>>>>>> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:  
>>>>>>> Tom says VFIO device assignment works OK with KVM, so I expect only things
>>>>>>> like DPDK to be broken.  
>>>>>>
>>>>>> Is there more information on why the difference?  Thanks,  
>>>>>
>>>>> I have nothing, maybe Tom can explain how it works?  
>>>>
>>>> IIUC, the main differences would be along the lines of what is performing
>>>> the mappings or who is performing the MMIO.
>>>>
>>>> For device passthrough using VFIO, the guest kernel is the one that ends
>>>> up performing the MMIO in kernel space with the proper encryption mask
>>>> (unencrypted).  
>>>
>>> The question here is why does VF assignment work if the MMIO mapping
>>> in the hypervisor is being marked encrypted.
>>>
>>> It sounds like this means the page table in the hypervisor is ignored,
>>> and it works because the VM's kernel marks the guest's page table as
>>> non-encrypted?  
>>
>> If I understand the VFIO code correctly, the MMIO area gets registered as
>> a RAM memory region and added to the guest. This MMIO region is accessed
>> in the guest through ioremap(), which creates an un-encrypted mapping,
>> allowing the guest to read it properly. So I believe the mmap() call only
>> provides the information used to register the memory region for guest
>> access and is not directly accessed by Qemu (I don't believe the guest
>> VMEXITs for the MMIO access, but I could be wrong).
> 
> Ideally it won't, but trapping through QEMU is a common debugging
> technique and required if we implement virtualization quirks for a
> device in QEMU.  So I believe what you're saying is that device
> assignment on SEV probably works only when we're using direct mapping
> of the mmap into the VM and tracing or quirks would currently see
> encrypted data.  Has anyone had the opportunity to check that we don't
> break device assignment to VMs with this patch?  Thanks,

I have not been able to test device assignment with this patch, yet. Jason?

Thanks,
Tom

> 
> Alex
> 
