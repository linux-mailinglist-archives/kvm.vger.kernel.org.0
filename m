Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44B7F2B68C6
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 16:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgKQPdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 10:33:23 -0500
Received: from mail-bn8nam11on2040.outbound.protection.outlook.com ([40.107.236.40]:42913
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgKQPdW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Nov 2020 10:33:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9JYfDcpPCOpCVIejRxJcFUZ5G3cLV7gxh3P33V/+MYm3W5+3g2DKmdPfatiXm/DjwL+0YIm1wPxSYa1iy0qB7E/e57R6zBKxfhmF+KP5oFWVc8KxqyElgDOSG1wiCaP5G9udSITsQOHZicIxu7dDt5MWIZ0ctFeUNehZhKtk8IW6XwK0Z01Kz6RW/p2O8MLwE2p/CN7NVwGqSuQ+/+WCAcAXtkBRGnRumOArR2DaT5wqsONSOEsgU8yE9bQBxJ2M9edguIXsSOp8lEWXEoQwmDiIQWnyl1j9ksdr+qvEtY8dZGf4g0fq8mB09uoD8c5+JX4zmteXa7PmMctH4cAkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7nv4UHH2b41m26yRTp9fntoXwAS1Rv3lQ5zIGROPjo=;
 b=MDrXeLoDzAM8X/+Nhl37Lke163tLaIoENVPaCbOSfixFi1oiFri3t6smc67obzunAQa+JS1NRgt3n8juIJp3Mo9GM9rTf9DmFEkpWcoIlmwZwGPBsyS1lKw4OKJM8cwIeq/Uh45Nsd0wU7BwoTmkmUU4w0lUQOSr29tzFi0SVL7wUfqv0JEHBPU3ZroQqL/pdGydcnN6Mpbd1PDJH1DnxYGvqp2jVxxzDNsx5k6oSb7ANtopQDobI67nYo2YfFCGd+7budj0EuUILjUdIE1ymKPG5kA1xftbCTRuRKhHeWnBcdcWc5u3Eh2dw3/HZ8nefXr5ZX4qWlfEDvWVZthPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7nv4UHH2b41m26yRTp9fntoXwAS1Rv3lQ5zIGROPjo=;
 b=dfofux01QkwXVFi6gvQOvYwGiNvKkI2DOZIk3toJNyxjC0Lr2y9GpBxM/oyLFRoXy4U25QBkN9tqtLhPG7ToD0uz6+D8xgpdy6IhSn4L/q3hzql814BZwVOwP6nJ/oKjA+w4OJ0WfAtUIsjgdaEd7EEne4Qll3obaoRlOb2V6PQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB3691.namprd12.prod.outlook.com (2603:10b6:5:1c5::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Tue, 17 Nov 2020 15:33:20 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::dcda:c3e8:2386:e7fe%12]) with mapi id 15.20.3564.028; Tue, 17 Nov
 2020 15:33:19 +0000
Subject: Re: [PATCH] vfio-pci: Use io_remap_pfn_range() for PCI IO memory
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Peter Xu <peterx@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
        kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
References: <0-v1-331b76591255+552-vfio_sme_jgg@nvidia.com>
 <20201105233949.GA138364@xz-x1> <20201116155341.GL917484@nvidia.com>
 <02bd74bb-b672-da91-aae7-6364c4bf555f@amd.com>
 <20201116232033.GR917484@nvidia.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e076f2eb-7c27-5b16-2f45-4c2068c4c264@amd.com>
Date:   Tue, 17 Nov 2020 09:33:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201116232033.GR917484@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN6PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:805:de::36) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN6PR05CA0023.namprd05.prod.outlook.com (2603:10b6:805:de::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.15 via Frontend Transport; Tue, 17 Nov 2020 15:33:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd61cf6a-cf78-4caa-78ee-08d88b0e1c1e
X-MS-TrafficTypeDiagnostic: DM6PR12MB3691:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3691A54E63487EB5AFBCF6A1ECE20@DM6PR12MB3691.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fSqIlLNuRz4uYeyIj6+99eG+XTWlSkLhYinOaysFnPky2U2R1toYpbQVL+1tf5N0hJIZ/tnziP9q7glXvg556AzMmw1c3pKSdz+c20CR7FvnFhdWeI06pUi4uXlx+oIWxYXU88CjSotYh390VOfGeSMRIRTZOQeY7w9pQOHHFiwPEUT8OeAl7UhFdp16f2zKVUigbWnScn4M8WAReo8qzDDtYAfcWt9TgpuoaffGzJToLIuHdGFK5T/4/vZBeU2x3xGkJV2VcgK0iswOvyFPPuSPVFp356YjJ1HShqIGCZ1fUNFB3PYzS1vYvpxd/h5zI6w3Bqi6yiVBABDVo10Z4QuNDpROBERfWnrGue4hT/Addb/PpgLvyEMqJHeBPusK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(6916009)(2906002)(4326008)(478600001)(53546011)(16526019)(2616005)(5660300002)(8676002)(31696002)(8936002)(52116002)(956004)(186003)(26005)(83380400001)(54906003)(86362001)(36756003)(316002)(66946007)(66556008)(66476007)(16576012)(31686004)(6486002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: HXYD/8+ojhCAcU7ruByaGOA+PzvdvE0qHjF/TgbPhhxWtt96YkbbLzUgHddSbRSwwIQpZydeR5pqUdaHxcyDZhZhFMOH0ZCf11w0MNVib/+uDhRRGR481lV8WQSYiy5f9ResKx46dqjv7vsnEnXle4CrPh0HHtSKqPf/K0B3+HZ8CZQ4qK93F591gBst9WLkqfHeO6lS4btbqGApK58Oi2i7ilLgxQHG261tNfIkXG5G+iAZryi0aih75l/HGM+DfqNNAgdNZSW809D9XD5qa/P2NLYEGFU83qdEDLz0YjevgFSzYKi38DTK7E8P8kaHbsG0k0j04aHs8IkCZlQ2itGlMFBFjxgw1oCadD5QV2g0aHKH/CUKsT0r2J+VQJpY7tQA+muw5VvO5yzzRLbmeD4NIDR3VTVe77a6b/8IWNCWygJKyCAXlOUyKfFFKfwM1pwXGDGMG/AChltYK87jjmAF0XNCGSbUVwinGgLNFPSKLC00R02ggeEPI8vZxq3XsoELd/ztZLNKjRy+FEXRgqOhJg9HFdRrlx3XQZn4JgrhZB+aa1fYnmGfQmWXG3qSM7DJvyFOTKTwBT+5nMbvgOnofUricR8XpKVJ01UCuCkdze/5dlHhhRca4XG4xIDVj0QB/hR9MNvMAOsjjn+Xyg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd61cf6a-cf78-4caa-78ee-08d88b0e1c1e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2020 15:33:19.7684
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h4ksv4hdfhjvX0TRPOQLniGFwdW5Gs+bo8y9kvxa4PNgye/XeLi6smqQ5a7tPOMNZY2b6IulPHde9wm3cEyr/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3691
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/16/20 5:20 PM, Jason Gunthorpe wrote:
> On Mon, Nov 16, 2020 at 03:43:53PM -0600, Tom Lendacky wrote:
>> On 11/16/20 9:53 AM, Jason Gunthorpe wrote:
>>> On Thu, Nov 05, 2020 at 06:39:49PM -0500, Peter Xu wrote:
>>>> On Thu, Nov 05, 2020 at 12:34:58PM -0400, Jason Gunthorpe wrote:
>>>>> Tom says VFIO device assignment works OK with KVM, so I expect only things
>>>>> like DPDK to be broken.
>>>>
>>>> Is there more information on why the difference?  Thanks,
>>>
>>> I have nothing, maybe Tom can explain how it works?
>>
>> IIUC, the main differences would be along the lines of what is performing
>> the mappings or who is performing the MMIO.
>>
>> For device passthrough using VFIO, the guest kernel is the one that ends
>> up performing the MMIO in kernel space with the proper encryption mask
>> (unencrypted).
> 
> The question here is why does VF assignment work if the MMIO mapping
> in the hypervisor is being marked encrypted.
> 
> It sounds like this means the page table in the hypervisor is ignored,
> and it works because the VM's kernel marks the guest's page table as
> non-encrypted?

If I understand the VFIO code correctly, the MMIO area gets registered as
a RAM memory region and added to the guest. This MMIO region is accessed
in the guest through ioremap(), which creates an un-encrypted mapping,
allowing the guest to read it properly. So I believe the mmap() call only
provides the information used to register the memory region for guest
access and is not directly accessed by Qemu (I don't believe the guest
VMEXITs for the MMIO access, but I could be wrong).

> 
>> I'm not familiar with how DPDK really works other than it is userspace
>> based and uses polling drivers, etc. So it all depends on how everything
>> gets mapped and by whom. For example, using mmap() to get a mapping to
>> something that should be mapped unencrypted will be an issue since the
>> userspace mappings are created encrypted. 
> 
> It is the same as the rdma stuff, DPDK calls mmap against VFIO which
> calls remap_pfn and creates encrypted mappings
> 
>> Extending mmap() to be able to specify a new flag, maybe
>> MAP_UNENCRYPTED, might be something to consider.
>  
> Not sure how this makes sense here, the kernel knows the should not be
> encrypted..

Yeah, not in this case. Was just a general comment on whether to allow
userspace to do something like that on any mmap().

Thanks,
Tom

> 
> Jason
> 
